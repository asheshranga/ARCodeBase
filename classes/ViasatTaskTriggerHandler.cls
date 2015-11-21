/*********************************************************************************
Name        : ViasatTaskTriggerHandler Class
Created By  : Mohantesh Kanike
Created Date: 27-AUG-2014    
Project     : ViaSat Support Tooway
Usage       : Handler Class for ViaSatTask AFTER INSERT/UPDATE TASK Trigger
*********************************************************************************/
// case 85389: allow portal user to update CCR tasks
public without sharing class ViasatTaskTriggerHandler 
{
    
    public static String VIASAT_LOGO = 'ViaSat_Logo';
    public static String CASE_ITSMS_RT = 'ITSMSGeneral';
    public static String TASK_ITSMS_RT = 'ITSMS';
    public static String STATUS_COMPLETED ='Completed';
    public static String TASK_TYPE_EMAIL ='Email';
    /**
        * @description - handlerMethod for ViaSatTask Trigger. 
        * @param object trigNew,oldMap, newMap, isInsert, isUpdate.
    */  
    public void handlerMethod(List<Task> trigNew,map<id,Task> oldMap,map<id,Task> newMap,boolean isInsert, boolean isUpdate)
    {
        // Send task custom email notification to the user
        // if Task has CCR recordtype && status is Not Started or Completed 
        set<Id> CCRIDs = new set<Id>();
        set<Id> ownerIDs = new set<Id>();
        set<Id> createdIDs = new set<Id>();
        String status;
        
        // Send task custom email notification to the user
        // if Task has ITSMS recordtype && status is Completed 
        set<Id> ITSMSIDs = new set<Id>();
        
        //
        set<Id> DenverCaseIds = new set<Id>();
        
        // Retrieve the Status List from Custom Setting
        CarlsbadNOCKeyValueStore__c  c= CarlsbadNOCKeyValueStore__c.getValues('CCRTaskStatusListToSendEmail');
        if (!Test.isRunningTest())
            status= c.Value__c;
        else
            status= 'New';
        
        List<String> statusList= status.Split(',');
        Set<String> statusSet = new Set<String>(statusList);
        
        for(Task t : trigNew)
        {             
            if ( t.WhatId != null && t.WhatId.getSObjectType().getDescribe().getName()== 'CCR__c' &&
                statusSet.contains(t.Status))
            {
                   if (t.WhatId != null)    CCRIDs.add(t.WhatId);
                   ownerIDs.add(t.ownerId);
                   createdIDs.add(t.createdbyId);    
                             
            } else if ( t.WhatId != null && t.WhatId.getSObjectType().getDescribe().getName()== 'Case' &&
                t.Status == STATUS_COMPLETED)
            {
                   if (t.WhatId != null)    ITSMSIDs.add(t.WhatId);
            }
            
            //Update for case # 00400467 by Jaspreet Monga
            
            if(t.WhatId != null && t.WhatId.getSObjectType().getDescribe().getName()== 'Case' 
               && t.Status == STATUS_COMPLETED)
            {
                DenverCaseIds.add(t.WhatId);
            }
         } 
           
        // Map for CCR__c and User object for checking record Id is from CCR__c object
        map<Id,CCR__c> ccrMap = new map<Id,CCR__c>();
        map<Id,User> usrMap = new map<Id,User>();      
        if (CCRIDs.size() > 0 && createdIDs.size() > 0)
        {
            ccrMap = new map<Id,CCR__c>([Select Id,Name,OwnerId, Subject__c From CCR__c Where Id In : CCRIDs]);
            usrMap = new map<Id,User>([Select Id,Name,email From User Where Id In : ownerIDs OR Id In : createdIDs]);  
        }
        
        // Map for Case and User object for checking record Id is from Case object
        map<Id,Case> caseMap = new map<Id,Case>();
        map<Id,User> caseUsrMap = new map<Id,User>();
        
        if (!ITSMSIDs.isEmpty())        
            caseMap = new map<Id,Case>([Select Id,CaseNumber,OwnerId, Subject, recordType.developerName From Case Where Id In : ITSMSIDs]);        
        
        Set<Id> caseOwnerIds = new Set<Id>();
        for(Case cCase : caseMap.values())
        {
            caseOwnerIds.add(cCase.ownerId);
        }
        
        if (!caseOwnerIds.isEmpty())
            caseUsrMap = new map<Id,User>([Select Id,Name,email From User Where Id In : caseOwnerIds]);  

    // PL: JIRA SFP-13       
    if (!ccrMap.isEmpty() && !usrMap.isEmpty())
    {
        //Declaring Task object Record Type for 'CCR' Record Type  
        RecordType rt = [SELECT Id FROM RecordType WHERE SObjectType='Task' AND Name='CCR' LIMIT 1];
        
        List<Messaging.SingleEmailMessage> emailList = new List<Messaging.SingleEmailMessage>();
     
        //Iterating for loop if task record for CCR__c is New
        for(Task t : trigNew)
        {
            if ( t.recordTypeId == rt.Id &&
                (isInsert || (isUpdate && (oldMap.get(t.id).lastmodifiedDate != newMap.get(t.id).lastmodifiedDate))))
            {            
              String[] toAddresse = new String[]{usrMap.get(t.OwnerId).email}; 
              String[] bccAdd = new String[]{usrMap.get(t.createdbyId).Email}; 
              // Concatenating String(CCR Number, CCR Subject and Task Status) at Subject Header for Task.
              CCR__c ccrObj = ccrMap.get(t.WhatId);
              String subject = (ccrObj != null ? (ccrObj.name+':'+ccrObj.Subject__c+'  '+t.Status) : t.Status);
              String body = '<span style="color:#0000FF;font-size: 20px;"><b>Task</b></span>'+'<br/><br/>';
                      body += 'To : '+usrMap.get(t.OwnerId).Name+'<br/><br/>';                      
                      body += usrMap.get(t.createdbyId).Name+' has assigned you the following task:'+'<br/><br/>'; 
                      body += 'Subject : '+ (t.Subject == null ? '' : t.Subject) +'<br/>';   
                      body += 'Priority : '+ (t.Priority == null ? '' : t.Priority)+'<br/>';
                      body += 'Status       : '+t.Status+'<br/><br/>';  
                      body += 'For more details, click the following link:<br/><br/>'; 
                      body += URL.getSalesforceBaseUrl().toExternalForm()+'/'+t.Id; 

                // Calling buildEmail method for fetching a record from Messaging.SingleEmailMessage object and then adding record into email list  
                emailList.add(ViasatUtilityClass.buildEmail(subject,toAddresse,bccAdd,usrMap.get(t.createdbyId).Name,body));      
            } 
        }
        
        if(!emailList.isEmpty())
        {
            try{
                if (!Test.isRunningTest())
                    Messaging.sendEmail(emailList);
            } catch(Exception e){
                 System.debug('The following exception has occurred: ' + e.getMessage());
                 if (ApexPages.currentPage() != null)
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'There was a problem sending the CCR notification email.'));
            }       
        }
    }
    
    // Case 00310146, Modified by Lynnet
    if (!caseMap.isEmpty() && !caseUsrMap.isEmpty())
    {        
        String viasatLogo = '';
        ViaSatTaskKeyValueStore__c logoCS = ViaSatTaskKeyValueStore__c.getInstance(VIASAT_LOGO);
               
        if (logoCS != null) viasatLogo = logoCS.Value__c;
        
        List<Messaging.SingleEmailMessage> emailList = new List<Messaging.SingleEmailMessage>();
        
        RecordType rt = [select id from RecordType where developerName = :TASK_ITSMS_RT AND SObjectType='Task' limit 1];
     
        //Iterating for loop if task record for CCR__c is New
        for(Task t : trigNew)
        {
             if (caseMap.get(t.WhatId) != null // Added by Jaspreet to avoid null pointer exception
                && caseMap.get(t.WhatId).recordType.developerName == CASE_ITSMS_RT &&
                 t.RecordTypeId == rt.id &&
                 t.status == STATUS_COMPLETED && 
                 t.OwnerId != caseMap.get(t.WhatId).ownerId && 
                 t.type != TASK_TYPE_EMAIL &&                
                (isInsert || (isUpdate && (oldMap.get(t.id).lastmodifiedDate != newMap.get(t.id).lastmodifiedDate))))
            { 
              if(!caseUsrMap.containsKey(caseMap.get(t.WhatId).ownerId)) 
                  continue;
                
              String[] toAddresse = new String[]{caseUsrMap.get(caseMap.get(t.WhatId).ownerId).email}; 
                  String[] bccAdd = new String[]{}; 
              // Concatenating String(CCR Number, CCR Subject and Task Status) at Subject Header for Task.
              Case caseObj = caseMap.get(t.WhatId);
              String subject = 'Task ' + (t.Subject == null ? '' : t.Subject) + ' is completed on Case ' + (caseObj == null ? '' : caseObj.CaseNumber);
                
              String body = '<center><table cellpadding="0" width="500" cellspacing="0" id="topTable" height="450"><tbody><tr valign="top"><td style="background-color:#FFFFFF; bEditID:r1st1; bLabel:header; vertical-align:top; height:100; text-align:left;">';
                      body += '<img src="'+viasatLogo+'" alt="Company Logo" />'+'</td></tr>';
                      body += '<tr valign=\"top\"> Task <a href="'+URL.getSalesforceBaseUrl().toExternalForm()+'/'+t.Id+'">'+(t.Subject == null ? '' : t.Subject)+'</a> has been completed on your case  <b>' + (caseObj == null ? '' : caseObj.CaseNumber) + '</b>.'+'<br/><br/>';
                      body += 'Task Details:'+'<br/><br/>';
                      body += 'Subject : '+ (t.Subject == null ? '' : t.Subject) +'<br/>';   
                      body += 'Priority : '+ (t.Priority == null ? '' : t.Priority)+'<br/>';
                      body += 'Status       : '+t.Status+'<br/><br/></td></tr>';
                      body += '</table></center>';

                // Calling buildEmail method for fetching a record from Messaging.SingleEmailMessage object and then adding record into email list  
                // Fix for Case 00589761 
                emailList.add(ViasatUtilityClass.buildEmail(subject,toAddresse,bccAdd,caseUsrMap.get(caseMap.get(t.WhatId).ownerId).Name,body));      
            } 
        }
        
        if(!emailList.isEmpty())
        {
            try{
                if (!Test.isRunningTest())
                    Messaging.sendEmail(emailList);
            } catch(Exception e){
                 System.debug('The following exception has occurred: ' + e.getMessage());
                 if (ApexPages.currentPage() != null)
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'There was a problem sending the Task notification email.'));
            }       
        }
        
    }
  
   // Changes by Jaspreet for Case #00400467 - Start
       
   if(isInsert)
   {
      List<Case> listCase = new List<Case>();
      
      Map<Id,Case> denverCaseMap = new map<Id,Case>([Select Id,CaseNumber,OwnerId, Subject, recordType.developerName From Case Where Id In : DenverCaseIds]);
      
      if(denverCaseMap.size() >0)
      {
        for(Task newTask : trigNew)
        {
            if(denverCaseMap.get(newTask.WhatId) != null)
            {
            	Case caseObj = denverCaseMap.get(newTask.WhatId);
            	caseObj.LastActivityDate__c =  newTask.CreatedDate;
            	listCase.add(caseObj);
            } 	    
        }
      
      try{
          update listCase;    
      }
      
      catch(Exception e){
          System.debug('The following exception has occurred: ' + e.getMessage());
          if (ApexPages.currentPage() != null)
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING, e.getMessage()));
      }
     }        
        
   }
   
  // Changes by Jaspreet for Case #00400467 - Ends  
    
}
}