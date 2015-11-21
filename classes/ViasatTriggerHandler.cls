/******************************************************************************
Name          : ViasatTriggerHandler
Created By    : Marina Basovich
Company Name  : ViaSat
Project       : IT Service Management System project
Purpose       : All viasat methods that called from Triggers should go here
Created Date  : October, 2014
Modified Date : Oct 2015, moving the handler methods here from CaseTiggerHandler as per review comments
                10/12/2015 Added ITSMS logic cases to Before Update
                10/23/2015 Added ITSMS logic cases After Insert, After Update
                10/29/2015 Added logic to handle milestone auto closure for Service desk and Initial response milestone
********************************************************************************
*/
public without sharing class ViasatTriggerHandler 
{
    public static String MS_INITIAL_RESPONSE = 'MS_INITIAL_RESPONSE';
    public static String MS_SD_RESPONSE = 'MS_SD_RESPONSE';
    Public static String ITSMS_RT_NAME = 'ITSMS_RT_NAME';
    Public static String ORIGIN_PHONE = 'ORIGIN_PHONE';
    Public static String SERVICE_DESK_QUEUE = 'SERVICE_DESK_QUEUE';
    Public static String SERVICE_DESK_ROLE = 'SERVICE_DESK_ROLE';
    public static String EMPTY_STRING = '';
    
    //Handle before insert for case    
    public static void handleCaseBeforeInsert(List<Case> caseList)
    {
       	CaseStatusTrackingUtility.handleCaseStatusChange(caseList, null);
		
		ITSMSCaseUpdate.beforeInsert(caseList);         

    }
    
    //Handle before update for case
    public static void handleCaseBeforeUpdate(Map<Id, Case> newMap, Map<Id, Case> oldMap)
    {
        CaseStatusTrackingUtility.handleCaseStatusChange(newMap.values(), oldMap);        
		ITSMSCaseUpdate.beforeUpdate(newMap.values(), oldMap);         
    }
    
    //Handle after insert for case
    public static void handleCaseAfterInsert(Map<Id, Case> newMap)
    {
       	CaseOwnerHistoryUtility.handleCaseOwnerChange(newMap, null);
       	createCCRCaseAssociation(newMap);
       	//Added for Case 00310159
       	sdMilestoneAutoClose(newMap, null); 

		// checks for ITSMS cases		
		ITSMSCaseUpdate.afterUpdate(newMap.values(), null);         
        
    }
    
    //Handle after update for case
    public static void handleCaseAfterUpdate(Map<Id, Case> newMap, Map<Id, Case> oldMap)
    {
        system.debug('@@ in viasat trigger handler u:'+newMap);
        CaseOwnerHistoryUtility.handleCaseOwnerChange(newMap, oldMap);
       //Added for Case 00310159
       sdMilestoneAutoClose(newMap, oldMap);
        
 		// checks for ITSMS cases		
		ITSMSCaseUpdate.afterUpdate(newMap.values(), oldMap);         
    }
    
    //Added for Case 00310159 - When origin changed to Phone the Service Desk Milestone should be closed.
    // or when case transferred to tier2 auto close the milestone.
    public static void sdMilestoneAutoClose(Map<id, Case> newCases, Map<id, Case> oldCases)
    {
         Set<Id> setOfCaseIdsToCompleteMilestone = new  Set<Id>();
        
        //Get the name for ITSMS record type stored in a custom setting
        String RT = CaseKeyValueStore__c.getInstance(ITSMS_RT_NAME) != null ? CaseKeyValueStore__c.getInstance(ITSMS_RT_NAME).value__c :  EMPTY_STRING;
        String PHONE = CaseKeyValueStore__c.getInstance(ORIGIN_PHONE) != null ? CaseKeyValueStore__c.getInstance(ORIGIN_PHONE).value__c :  EMPTY_STRING;
        String SVC_DESK_QUEUE = CaseKeyValueStore__c.getInstance(SERVICE_DESK_QUEUE) != null ? CaseKeyValueStore__c.getInstance(SERVICE_DESK_QUEUE).value__c :  EMPTY_STRING;
        String SVC_DESK_ROLE = CaseKeyValueStore__c.getInstance(SERVICE_DESK_ROLE) != null ? CaseKeyValueStore__c.getInstance(SERVICE_DESK_ROLE).value__c :  EMPTY_STRING;
        String ITSMSRTId = Schema.SObjectType.Case.RecordTypeInfosByName.containsKey(RT) ? (String)Schema.SObjectType.Case.RecordTypeInfosByName.get(RT).RecordTypeId : EMPTY_STRING;
       
        for(Case cCase : newCases.values())
        {
          if(!String.isBlank(ITSMSRTId)
             && cCase.recordTypeId == ITSMSRTId
             && cCase.EntitlementId != null
             && cCase.SlaStartDate != null             
             && cCase.SlaExitDate == null)  
          {
            //Check if origin has changed            
            if( Trigger.isInsert || cCase.Origin != oldCases.get(cCase.id).Origin)
            {
                if(cCase.Origin == PHONE )
                {
                    setOfCaseIdsToCompleteMilestone.add(cCase.id);
                } 
            }
            //Check if owner has changed            
            if( !Trigger.isInsert && cCase.OwnerId != oldCases.get(cCase.id).OwnerId 
               && cCase.recordTypeId == ITSMSRTId
               && ((cCase.OwnerRole__c != null && !cCase.OwnerRole__c.contains(SVC_DESK_ROLE))
                  || (cCase.CurrentQueueOwner__c !=null && !cCase.CurrentQueueOwner__c.contains(SVC_DESK_QUEUE)))
              )
            {
                setOfCaseIdsToCompleteMilestone.add(cCase.id);
            }
          }
        }
      
        if(!setOfCaseIdsToCompleteMilestone.isEmpty())
        {
            Globals__c skipVal = Globals__c.getOrgDefaults();
 			if(skipVal!=null)
            {
            	skipVal.CaseMilestoneValidationIgnore__c = true;
            	update skipVal;     
            }
            String sdMilestone = CaseKeyValueStore__c.getInstance(MS_SD_RESPONSE) != null ? CaseKeyValueStore__c.getInstance(MS_SD_RESPONSE).value__c :  EMPTY_STRING;
            completeMilestone(setOfCaseIdsToCompleteMilestone, sdMilestone, System.now());
           
            if(skipVal!=null)
            {
            	skipVal.CaseMilestoneValidationIgnore__c = false;    
            	update skipVal;
            }
        }
    }
 
    //Takes in a map of cases, checks if the case has a ccr associated and creates an association record
    public static void createCCRCaseAssociation(Map<Id, Case> newMap)
    {
        List<CCRCaseAssociation__c> listOfAssnRecsToInsert = new List<CCRCaseAssociation__c> ();
        for(Case c: newMap.values())
        {
            if(c.CCR__c != null)
            {
                CCRCaseAssociation__c ca = new CCRCaseAssociation__c(ccr__c = c.CCR__c, Case__c = c.id);
                listOfAssnRecsToInsert.add(ca);
            }
        }
        try{
            insert listOfAssnRecsToInsert;
        }
        catch(exception e)
        {
            
        }
    }
    
    //---------------------------------------------------------------------------
    // For Cases associated to Entitlement records: 
    // Complete Case Initial Response milestone (if not yet completed) for the OWNER of the Case. 
    // Called from the following triggers: EmailMessage, CaseComment, CaseAfter, ViasatTask.
    //---------------------------------------------------------------------------
    public static void completeMilestone(Set<Id> caseIds)
    {
        DateTime completionDate = System.now();
        
        String sdMilestone = CaseKeyValueStore__c.getInstance(MS_SD_RESPONSE) != null ? CaseKeyValueStore__c.getInstance(MS_SD_RESPONSE).value__c :  EMPTY_STRING;
        String initMilestone = CaseKeyValueStore__c.getInstance(MS_INITIAL_RESPONSE) != null ? CaseKeyValueStore__c.getInstance(MS_INITIAL_RESPONSE).value__c :  EMPTY_STRING;

        Id uId = UserInfo.getUserId();
        List<Case> caseList = [SELECT Id, recordType.Name, ContactId, Contact.Email, OwnerId, Status, EntitlementId, SlaStartDate, SlaExitDate
                               FROM Case WHERE EntitlementId != null and Id IN :caseIds];
        if (caseList != null && !caseList.isEmpty())
        {
            System.Debug('*** completeMilestone caseList: ' + caseList);
            Set<Id> updateCasesInitialResponse = new Set<Id>();
            for (Case obj : caseList) 
            {
                if (obj.SlaStartDate != null && obj.SlaStartDate <= completionDate && obj.SlaExitDate == null && obj.OwnerId == uId)
                    updateCasesInitialResponse.add(obj.Id);
            }
            if(updateCasesInitialResponse.isEmpty() == false)
            { 
                completeMilestone(updateCasesInitialResponse, sdMilestone, completionDate);
                completeMilestone(updateCasesInitialResponse, initMilestone, completionDate);      
            }    
        }
    }
   
      
    // Comple Not Completed & not Expired milestone
    public static Set<Id> completeMilestone(Set<Id> caseIds, String milestoneName, DateTime completionDate) 
    {
        List<CaseMilestone> cmsToUpdate = [SELECT Id, completionDate, caseId, TargetDate, IsCompleted
                                           FROM CaseMilestone cm WHERE caseId in :caseIds and cm.MilestoneType.Name=:milestoneName and completionDate = null limit 1];
        System.debug('*** cmsToUpdate: ' + cmsToUpdate);
        Set<Id> setCaseIds = new Set<Id>();
        if (cmsToUpdate != null && !cmsToUpdate.isEmpty())
        {
            for (CaseMilestone cm : cmsToUpdate){
                //if (TargetDate <= completionDate)
                {
                cm.completionDate = completionDate;
                setCaseIds.add(cm.caseId);
                }
            }
            update cmsToUpdate;
        }
        return setCaseIds;
    }
    
    //---------------------------------------------------------------------------
    // For Cases associated to Entitlement records: 
    // Update Milestone Business Hours when the Case Owner is changed to the user with different TimeZone unless milestone is already closed.
    // Called from the following triggers: CaseAfter.
    //---------------------------------------------------------------------------
    public static void updateMilestoneBusinessHours_Async(Set<Id> caseIds) 
    {
        try
        {
            futureUpdateMilestoneBusinessHours(caseIds);
        }
        catch(AsyncException ax)    
        {   
            updateMilestoneBusinessHours(caseIds);
        }
    }   

    @future
    public static void futureUpdateMilestoneBusinessHours(Set<Id> caseIds)
    {
        updateMilestoneBusinessHours(caseIds);  
    } 
    public static void updateMilestoneBusinessHours(Set<Id> caseIds) 
    {       
        if (!caseIds.isEmpty())
        {
            List<Case> caseToUpdate = [SELECT Id, ownerId FROM Case WHERE Id in :caseIds];
            if (caseToUpdate.size() > 0)    update caseToUpdate;
        }
    }
    
    //---------------------------------------------------------------------------
    // For Cases associated to Entitlement records: 
    // Set Case Next Milestone Target Date with the Target Date of the case milestone that’s closest to today
    // Called from the following triggers: CaseAfter.
    //---------------------------------------------------------------------------
    public static void updateNextMilestoneTargetDate_Async(Set<Id> caseIds) 
    {
        try
        {
            futureUpdateNextMilestoneTargetDate(caseIds);
        }
        catch(AsyncException ax)    
        {   
            updateNextMilestoneTargetDate(caseIds);
        }
    }   
    
    @future
    public static void futureUpdateNextMilestoneTargetDate(Set<Id> caseIds) 
    {       
        updateNextMilestoneTargetDate(caseIds);
    }   
    
    public static void updateNextMilestoneTargetDate(Set<Id> caseIds) 
    {
        if (!caseIds.isEmpty())
        {
            Map<Id,Case> cases = new Map<Id,Case>([SELECT Id, NextMilestoneTargetDate__c FROM Case WHERE Id in :caseIds]);      
            List<Case> updatedCases = updateNextMilestoneTargetDate(cases); 
            if (updatedCases.size() > 0)
                update updatedCases;
        }
    }   
    public static List<Case> updateNextMilestoneTargetDate(Map<Id,Case> cases) 
    {       
        Map<Id,Case> updatedCases = new Map<Id,Case>();

        List<CaseMilestone> cms = [SELECT Id, caseId, MilestoneType.name, TargetDate FROM CaseMilestone WHERE caseId in :cases.keySet() ORDER BY caseId, TargetDate desc];
        System.debug('*** cms: ' + cms);

        if (cms != null && !cms.isEmpty())
        {
            decimal dtNow = system.now().getTime();
            for (CaseMilestone cm : cms)
            {
                Case c = cases.get(cm.caseId);
                if (c.NextMilestoneTargetDate__c == null || cm.MilestoneType.name == 'Initial Response')
                {
                    c.NextMilestoneTargetDate__c = cm.TargetDate;
                  
//                decimal dt = null;
//                if (caseToUpdateIds.containsKey(cm.caseId))
//                    dt = caseToUpdateIds.get(cm.caseId).getTime();
//                    
//                if (dt == null || ( math.mod((decimal)cm.TargetDate.getTime() - dtNow) <  math.mod(dt - dtNow)) )
//                    caseToUpdateIds.put(cm.caseId, cm.TargetDate);
  
                    updatedCases.put(c.Id, c);
                }               
            }
        }
        return updatedCases.values();
    }
    

    // Called from CaseAfter trigger: Resolution Case Count Update ------------------        
    public static void SiteCaseCountUpdate(set<Id> siteIds)
    {
        //---Map will contain one Site Id to one count value  
        map<Id,Double> siteMap = new map <Id,Double>();  
        
        list<Case> cases = [select site__c, id from Case where site__c in :siteIds and createddate >= LAST_N_DAYS:60];
        if (cases != null && !cases.isEmpty())
        {
            for (Case c : cases)
            {
                if (siteMap.containsKey(c.site__c) == false)
                    siteMap.put(c.site__c,1.0);
                else
                    siteMap.put(c.site__c,siteMap.get(c.site__c) + 1.0);
            }

//        //---Get number of cases for a given site
//        for(AggregateResult q : [select site__c,count(id) from Case 
//                                 where site__c IN :siteIds and createddate >= LAST_N_DAYS:60 
//                                 group by site__c])
//        {  
//            siteMap.put((Id)q.get('site__c'),(Double)q.get('expr0'));  
//        }  
        
            List<site__c> sitesToUpdate = new List<site__c>();  

            //---Now Update the sites with the number of cases  
            for(site__c s : [Select Id, recentcases__c from site__c where Id IN :siteIds])
            {  
                Double caseCount = siteMap.get(s.Id);  
                s.recentcases__c = caseCount;  
                sitesToUpdate.add(s);  
            }  
            update sitesToUpdate;   
        }  
    }
    
    // Called from CaseAfter trigger: Resolution Case Count Update ------------------        
    public static void ResolutionCaseCountUpdate(set<Id> resolutionIds)
    {
        //---Map will contain one Resolution Id to one count value 
        map<Id,Double> resolutionMap = new map <Id,Double>();

        //---Get number of cases for a given resolution code (level 1)
        for(AggregateResult q : [select resolutioncodelevel1__c,count(id) from Case 
                             where resolutioncodelevel1__c IN :resolutionIds
                               and createddate >= LAST_N_DAYS:30 group by resolutioncodelevel1__c])
        {  
            resolutionMap.put((Id)q.get('resolutioncodelevel1__c'),(Double)q.get('expr0'));  
        }  

        //---Get number of cases for a given resolution code (level 2)
        for(AggregateResult q : [select resolutioncodelevel2__c,count(id) from Case 
                             where resolutioncodelevel2__c IN :resolutionIds
                               and createddate >= LAST_N_DAYS:30 group by resolutioncodelevel2__c])
        {  
            resolutionMap.put((Id)q.get('resolutioncodelevel2__c'),(Double)q.get('expr0'));  
        }  

        //---Get number of cases for a given resolution code (level 3)
        for(AggregateResult q : [select resolutioncodelevel3__c,count(id) from Case 
                                 where resolutioncodelevel3__c IN :resolutionIds
                                 and createddate >= LAST_N_DAYS:30 group by resolutioncodelevel3__c])
        {  
            resolutionMap.put((Id)q.get('resolutioncodelevel3__c'),(Double)q.get('expr0'));  
        }  

        //---Now Update the resolutions with the number of cases  
        List<resolution__c> resolutionsToUpdate = new List<resolution__c>();  
        for(resolution__c r : [Select Id, recentcases__c from resolution__c where Id IN :resolutionIds])
        {  
            Double caseCount = resolutionMap.get(r.Id);  
            r.recentcases__c = caseCount;  
            resolutionsToUpdate.add(r);
        }  
        if (resolutionsToUpdate.size() > 0) update resolutionsToUpdate;  
    }
    //Handle after insert for user    
    public static void handleUserAfterInsert(Map<Id, User> newMap)
    {
        string triggerType = 'Insert';
        ITSMSCaseDelegateUpdate.checkCaseDelegateChange(newMap.values(), null, triggerType);
    }
    //Handle after update for user    
    public static void handleUserAfterUpdate(Map<Id, User> newMap, Map<Id, User> oldMap)
    {
        string triggerType = 'Update';
        ITSMSCaseDelegateUpdate.checkCaseDelegateChange(newMap.values(), oldMap, triggerType);
    }

}