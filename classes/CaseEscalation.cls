/*  ******************************************************************************************************
Change Log:
<Date>      <Modified By>       <Change Description>
07/28/2015   Tejesh Kumar      Case 00482105: Case Escalation Details Updates - Added a new soql to query
                                              mobile phones of user and builded a Wrapper Class to pass 
                                              the Wrapper list to Page Block Table 
11/17/2015  Jaspreet Monga    Case 00554001: Case Escalation On-Call function not updating correct On-Call individual
********************************************************************************************************* */

public class CaseEscalation
{
    ApexPages.StandardController controller;
    Public final Case c;
    Public Case dummyCase {get;set;} 
    Public EscalationCheckList__c ec {
        get {return ec;}
        set;
    }
    
    Public String escalateTo {
        get { return escalateTo; }
        set;
    }
    
    Public String escalationStep {
        get { return escalationStep; }
        set;
    }
    
    Public List<String> escalationTiers {get {return escalationTiers;} set;}
    Public List<List<String>> escalationPath {get {return escalationPath;} set;}
    
    Public Boolean renderStatus {
        get { return (renderStatus ==null) ? false:renderStatus; }
        set;
    }    
         
    //--- Support User Information
    
    Private String selectedUserId;
    Public String getselectedUserId() {return this.selectedUserId;}
    Public void setselectedUserId(String u) {this.selectedUserId = u; }
    
    Private String selectedUserName;
    Public String getselectedUserName() {return this.selectedUserName;}
    Public void setselectedUserName(String n) {this.selectedUserName = n; }
    
    Map<Id,String> mobileMap= new Map<Id,String>();
    Set<Id> setIds = new Set<Id>();
    Public List<combinedList> combinedListUsers{get;set;}  
        
    Public List<OnCallSchedule__c> supportUsers {
        get {return supportUsers;}
        set;
    }    
    //---Result and Error Details
    
    public String result {
        get { return result;}
        set;
    }
    
    public Integer errorCode { 
        get {return (errorCode == null) ? 0:errorCode;} 
        set;
    }    

    Public String escalationCheckListId;        
    public String getescalationCheckListId() {return escalationCheckListId;}       
    public void setescalationCheckListId(String e) {this.escalationCheckListId= e;}
    
    public List<SelectOption> escalationCheckLists {
        get {
           if (escalationCheckLists == null)
                {
                     escalationCheckLists = new List<SelectOption>();
                     escalationCheckLists.add(new SelectOption('NA', '--Not Required--'));
         
                for(RecordType rt: [select id,name from recordtype where sobjecttype='EscalationCheckList__c' and isactive=true]) 
                     escalationCheckLists.add(new SelectOption(rt.id, rt.name));
                }
       
                    return escalationCheckLists; 
            }
                    set;
    }
     
    //---Initialize the controller    
    public CaseEscalation(ApexPages.StandardController stdController) 
    {
        controller = stdController;
        c = (Case) controller.getRecord();
        dummyCase = new Case();
        //dummyCase.ownerid = null;
    }
    //--- wrapper class to pass for the page block table : supportusers+mobilephone
    public class combinedList {          
        Public OnCallSchedule__c onCallObj{get;set;}
        public string ownerMobile{get; set;}
        
        Public combinedList(OnCallSchedule__c onCallRec, string ownerMobileNo){
            onCallObj = onCallRec;
            ownerMobile= ownerMobileNo;
        } 
    }
    
    public PageReference userSelected() {
        return null;
    }
    
    public PageReference userSelectedManually() {
        return null;
    }
        
    public PageReference save(){ 
        controller.save();
        PageReference caseURL = new PageReference('/' + this.c.id);
        return caseURL;
    }
    
    String selectedTier = '';
    public List<SelectOption> getTiers() {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('','--None--'));
        for (integer i=2; i<=6; i++)
           options.add(new SelectOption('Tier ' + i,'Tier ' + i));

        return options;
    }
    
    public String getselectedTier() {
        return selectedTier;
    }
 
    public void setselectedTier(String tier) {
        this.selectedTier = tier;
    }
    
    public PageReference checkListSelection() {
       if (escalationCheckListId == 'NA') {
          ApexPages.currentPage().getParameters().put('escalationstep','2'); 
          ApexPages.currentPage().getParameters().put('selectedtier',selectedTier); 
          escalationStep = '2';  
          escalateCase();
          return null;
       } else {
       
        List<EscalationCheckList__c> e = [select Id, RecordTypeId  
                                            from EscalationCheckList__c 
                                           where case__c = :c.id 
                                             and RecordTypeId = :escalationCheckListId];
                                                                                   
        PageReference checkListURL;
        if (e.size() >=1) {
            //---Edit existing check list
            checkListURL = new PageReference('/' + e[0].Id + '/e');
            checkListURL.getParameters().put('saveURL','/apex/CaseEscalation?escalationstep=2&id=' + c.id + '&selectedtier=' + selectedTier);
            checkListURL.getParameters().put('retURL','/apex/CaseEscalation?id=' + c.id);             
        } else {
            //---Select check list doesn't exists on the case, create new
                 string lspreFix    = EscalationCheckList__c.sObjectType.getDescribe().getKeyPrefix();
                 string lsID        = System.Label.EscalationCheckListObjectID;
                 string lsCaseField = System.Label.CaseFieldID;
                 checkListURL = new PageReference('/' + lspreFix + '/e');
                 checkListURL.getParameters().put('ent',lsID);
                 checkListURL.getParameters().put('CF' + lsCaseField,c.casenumber);
                 checkListURL.getParameters().put('CF'+ lsCaseField +'_lkid',c.id);
                 checkListURL.getParameters().put('RecordType',escalationCheckListId);
                 checkListURL.getParameters().put('saveURL','/apex/CaseEscalation?escalationstep=2&id=' + c.id + '&selectedtier=' + selectedTier);
                 checkListURL.getParameters().put('retURL','/apex/CaseEscalation?id=' + c.id);                          
                }
                
                return checkListURL.setRedirect(true);   
                 
                }
    }
 
    //---Escalation Process used by escalation page    
    public void escalateCase() { 
        Map<String,String> req = ApexPages.currentPage().getParameters();
            errorCode = 0;
           
            //--- Check the escalation step
            //--- base on the step of escalation process take approriate action
                escalationStep = req.get('escalationstep');
                escalationStep = ((escalationStep == null) || (escalationStep == '')) ? '1':escalationStep;
           
           if ((selectedTier == null) || (selectedTier == '')) {
                selectedTier = req.get('selectedtier');
                selectedTier = ((selectedTier == null) || (selectedTier == '')) ? '':selectedTier;           
           }
  
           String checkListId = req.get('newid');
           ec = ((checkListId==null) || (checkListId == '')) ? null:[select id,name,recordtype.name from EscalationCheckList__c where id=:checkListId];
            
           //--- Get escalation tier path information
            
           List<escalation__c> ep;          
           
           if (c.site__c == null) {
              ep = [select id, name, tiers__c 
                   from escalation__c 
                   where product__c = :c.productid]; 
                                           
           } else {
              //--- First check the escalation path if the program identified by the site
              ep = [select id, name, tiers__c 
                      from escalation__c 
                     where product__c = :c.productid 
                    and program__c != 'All' and program__c = :c.site__r.program__c];  
              
            //--- If no escalation path is found for the site program, check to see if path is defined for all programs
            if (ep.size() <= 0) {
               ep = [select id, name, tiers__c 
                       from escalation__c 
                     where product__c = :c.productid 
                      and (program__c = 'All' or program__c = '' or program__c = null)]; 
                                                                                  
                }
           }           
                String currentTier        = 'Tier 1';
                String escalationLastTier = 'Tier 6';
            if (ep.size() > 0) {
                escalationTiers = ep[0].tiers__c.split(';');
            if (escalationTiers.size() > 0) {
                 CurrentTier = escalationTiers[0];
                 escalationLastTier = escalationTiers[escalationTiers.size() - 1];
              }
           } else {
                escalationTiers = new List<String>();
           }
           
           escalateTo = selectedTier;
           for (CaseHistory h: [select id, caseid, newvalue, oldvalue 
                                  from casehistory 
                                 where field = 'StatusDetails__c' 
                                  and caseid = :c.id 
                                  order by createddate desc]) {                                                                                                                    
                String lsNewValue;
                lsNewValue = (h.newvalue == null) ? '':(String)h.newvalue;                                                     
                if (lsNewValue.indexOf('Tier')>=0) {
                   currentTier = (String) h.newvalue;                                 
                   break;
                }   
                }  
           
           boolean lbFound = false;
           escalationPath = new List<List<String>>();
           for (integer i=0; i<escalationTiers.size();i++) {
              String t = escalationTiers[i];
              List<String> tierInfo = new List<String>();

              Integer liT   = (t == '') ? 0: Integer.valueof(t.replace('Tier ',''));
              Integer liCurrentTier = (currentTier == '') ? 0: Integer.valueof(currentTier.replace('Tier ',''));
              
                  
              tierInfo.add(t);             
              
              if ((escalateTo == '') && (liT > liCurrentTier)) {
                 escalateTo = t;
              }
              
              if (t == currentTier) {
                 tierInfo.add('Current');
                 lbFound = true;
                 if (i+1 < escalationTiers.size())
                    escalateTo = escalationTiers[i+1];
                } else if ((t != currentTier) && (lbFound == false) && (liT < liCurrentTier)) {
                 tierInfo.add('Complete');
                } else {
                 tierInfo.add('Future');
                }
              
                 escalationPath.add(tierInfo);
                }
           
                Integer liescalateToTier = 0;
                Integer liescalateLastTier = 0;
                      
                liescalateToTier   = (escalateTo == '') ? 0: Integer.valueof(escalateTo.replace('Tier ',''));
                liescalateLastTier = (escalationLastTier == '') ? 0: Integer.valueof(escalationLastTier.replace('Tier ',''));
               
            if (c.ClosedDate != null) {
                errorCode      = 3;
                escalationStep = '2';
                renderStatus   = false;

                result = 'Can\'t escalate the case. The case has been closed on ' + c.ClosedDate;
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Ooops! Can\'t escalate the case. The case has been closed on ' + c.ClosedDate));              
           
                } 
            else if (((1==2) && (escalateTo == '')) || (liescalateToTier > liescalateLastTier) || (currentTier==escalationLastTier)) 
                {
                errorCode      = 3;
                escalationStep = '2';
                renderStatus   = false;

                result = 'Can\'t escalate the case beyond Tier ' + liescalateLastTier;
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Ooops! Can\'t escalate the case beyond Tier ' + liescalateLastTier));                         
                }               
            else if ((escalationStep == '1') && (selectedUserId == null) && (dummyCase.ownerid == null))  
                {
               //--- Present the user with option to select the check list type
               //--- No action
               renderStatus   = false;
                } 
            else{
                //--- Now get the support information and escalate the case          
                renderStatus   = true;             
                result         = '';          
                   
                date loToday = date.today();
                DateTime loCurrentTime = datetime.now();
                String lsToday       = loCurrentTime .format('MM/dd/yyyy HH:mm:ss');
                String lsCurrentTime = loCurrentTime .format('HH:mm');
                List<OnCallSchedule__c> supportUsersCache = new List<OnCallSchedule__c>();

              if (!(selectedUserId==null))
                {
                 //--- Get selected user information for assignment
                 //--- For displaying back to the use with info on which user was the case escalated to
                 supportUsersCache = [select Id, ownerid, owner.name, owner.firstname, owner.email, owner.phone,
                                        StartDate__c, EndDate__c, StartTime__c, EndTime__c,CallSequence__c, casetype__c, program__c
                                   from OnCallSchedule__c 
                                  where recordtype.name =:escalateTo
                                    and StartDate__c <= :loToday
                                    and EndDate__c >= :loToday
                                    and (product__c = :c.ProductId or product__c = null or product__c = '')
                                    and (casetype__c includes (:c.type) or casetype__c = null or casetype__c = '')
                                    and (program__c includes (:c.site__r.program__c) or program__c = null or program__c = '' or program__c = 'All')
                                    and ownerid    = :selectedUserId
                                  order by StartDate__c, CallSequence__c];
                                   
              
              } else {
                 //--- Now check the on call schedule person, based on case product and type
                 supportUsersCache = [select Id, ownerid, owner.name, owner.firstname, owner.email, owner.phone,
                                        StartDate__c, EndDate__c, StartTime__c, EndTime__c,CallSequence__c, casetype__c, program__c 
                                   from OnCallSchedule__c 
                                   where recordtype.name =:escalateTo
                                    and StartDate__c <= :loToday
                                    and EndDate__c >= :loToday  
                                    and (product__c = :c.ProductId or product__c = null or product__c = '')
                                    and (casetype__c includes (:c.type) or casetype__c = null or casetype__c = '')
                                    and (program__c includes (:c.site__r.program__c) or program__c = null or program__c = '' or program__c = 'All')
                                  order by StartDate__c, CallSequence__c];
                                  
              }
             
             // Added by Jaspreet for Case # 00554001
             supportUsers = new List<OnCallSchedule__c >();
             for(OnCallSchedule__c sUsers: supportUsersCache){
                   
                 Time startTime; 
                 Time endTime;
                
                 if(sUsers.StartTime__c != '')
	       		    startTime = Time.newInstance(integer.valueof(sUsers.StartTime__c.split(':')[0]), integer.valueof(sUsers.StartTime__c.split(':')[1]), 0, 0);

				 if(sUsers.EndTime__c != '')
	       		   endTime = Time.newInstance(integer.valueof(sUsers.EndTime__c.split(':')[0]), integer.valueof(sUsers.EndTime__c.split(':')[1]), 0, 0);

				 DateTime startDateTime = DateTime.newInstance(sUsers.StartDate__c, startTime);
                 DateTime endDateTime = DateTime.newInstance(sUsers.EndDate__c, endTime);
                                    
                 Datetime currentimeGMT = System.now();
                
                if((startDateTime < currentimeGMT) && (endDateTime > currentimeGMT))
                   {
                      supportUsers.add(sUsers);
                   } 
                
                 }
             // changes for case # 00554001 ends
                
             // To query mobile phone of the owner
             for(OnCallSchedule__c sUsers: supportusers) {
            	  system.debug(lsCurrentTime + ' ---- ' + sUsers.StartTime__c + ' ----- '+ sUsers.EndTime__c);
                  setIds.add(sUsers.ownerid);                 
              }
                
              for(List<User> ownerDetails : [SELECT Id, MobilePhone from User WHERE Id=: setIds]) {
                  for(User owner: ownerDetails) {
                      mobileMap.put(owner.Id,owner.MobilePhone);
                  }             
              }
              
              // Adding all supportusers along with mobile phone to wrapper class
              combinedListUsers = New List<combinedList>();
              for(OnCallSchedule__c sUsers: supportusers) {
                  combinedListUsers.add(new combinedList(sUsers,mobileMap.get(sUsers.ownerid)));
              }
              
             // Verify if the account tied to the case requires labor hours
             Case laborRequired = [select id, Labor_Hours_Required__c from case where id = :c.id];
             system.debug('laborRequired = ' + laborRequired.labor_hours_required__c);
             
             if (laborRequired.labor_hours_required__c == 'Yes') {
                 //Find the last escalatedDate for the case.  Set it equal to the case creation date to start with.
                 system.debug('Find the last escalatedDate for the case');
                 
                 Case caseCreated = [select createdDate from case where id = :c.id limit 1];
                 DateTime TotalLaborUpdate = caseCreated.createdDate;
                 //DateTime TotalLaborUpdate = c.createdDate;
                 DateTime lastEscalated;
                 
                 //Check if this is the second+ escalation
                 for (CaseHistory h: [select NewValue, createddate 
                                     from casehistory 
                                     where field = 'StatusDetails__c' 
                                     and caseid = :c.id 
                                     order by createddate desc limit 1]) {
                   String sdNewValue;
                   sdNewValue = (h.newvalue == null) ? '':(String)h.newvalue;                                                     
                   if (sdNewValue.contains('Tier')) {
                      lastEscalated = (Datetime) h.createdDate;                                 
                      break;
                   }                
                 }                    
             
                 //if still null, check if first escalation exists
                 if (lastEscalated==null) {
                     for (CaseHistory h: [select NewValue, createddate  
                                           from casehistory 
                                          where field = 'Status__c'
                                            and caseid = :c.id
                                          order by createddate desc]) {
                       String lsNewValue;
                       lsNewValue = (h.newvalue == null) ? '':(String)h.newvalue;                                                     
                       if (lsNewValue.indexOf('Escalated')>=0) {
                          lastEscalated = (Datetime) h.createdDate;                                 
                          break;
                       }                
                     }
                 }
             
                 //if no escalation found then set it equal to TotalLaborUpdate so nothing happens.
                 if (lastEscalated==null) lastEscalated = TotalLaborUpdate;
                 system.debug('lastEscalated: ' + lastEscalated);  
             
             
                 //if this case has been escalated previously, check the last update made on TotalLaborHours field
                 system.debug('Check the last update made on TotalLaborHours');
                 if (!(lastEscalated == null)) {
                     for (CaseHistory h: [select NewValue, createddate  
                                           from casehistory 
                                          where field = 'TotalLaborHours__c'
                                            and caseid = :c.id
                                          order by createddate desc
                                          limit 1]) {
                       Decimal leNewValue;
                       leNewValue = (h.newvalue == null) ? 0 : (Decimal)h.newvalue;                                                     
                       if (leNewValue > 0) {
                          TotalLaborUpdate = (Datetime) h.createdDate;                                 
                          break;
                       }   
                     }   
                     system.debug('TotalLaborUpdate: ' + TotalLaborUpdate);              
                 }

                 //If the lastEscalated date > TotalLaborUpdate date then throw error
                 System.debug('Compare lastEscalated to TotalLaborUpdate:' + (lastEscalated > TotalLaborUpdate));
                 if (lastEscalated > TotalLaborUpdate) {
                     //errorCode = 4;                
                     result    = 'Labor hours must be updated before this case can be escalated.';
                     ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING, 'Labor hours must be updated before this case can be escalated.'));           
                 }
             }
             
             
                                           
              if (((supportusers.size() == 1) && (selectedUserId == null)) ||
                  ((supportusers.size() >= 1) && (selectedUserId != null)) ||
                  (dummyCase.ownerid != null)) {                                      
                 List<Case> casesToUpdate = new List<Case>();     
           
                 c.status           = 'Escalated';
                 c.statusdetails__c = escalateTo;                         
                 
                 if (dummyCase.ownerid != null)
                    c.ownerid = dummyCase.ownerid;
                 else   
                    c.ownerid = supportusers[0].ownerid;
                 
                //--- Upadte the case with the above values
                 casesToUpdate.add(c);  
                 
                 try{                  
                     update casesToUpdate;  
                       } catch (DMLException e) {
                          ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Unable to escalate the case - Error: ' + e.getDMLMessage(0)));
                          return;
                       } catch (exception e1) {
                          ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Unable to escalate the case - Error: ' + e1.getMessage()));
                          return;
                       } 
                                         
                     ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'Successfully escalated the case.'));
                     errorCode = 0;                  
                     result = 'Successfully escalated the case to the following support person.';
                } 
                else if (supportusers.size() <= 0) 
                {
                   // caseboolean=true;
                     errorCode = 4;                
                     result    = 'Please select a user or queue to manually escalate the case.';
                     ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING, 'Ooops! No Support Schedule found for today. Please select a user or queue to manually escalate the case.'));
                     // caseboolean=true;
                } 
                else if (supportusers.size() < 0) 
                {
                    errorCode = 1;
                 
                    result = 'None Selected';
                if ((c.site__c != null) && (c.site__r.program__c != null)) 
                    result = c.site__r.program__c; 
                 
                    result = 'Ooops! No Support Schedule found for today (' + lsToday + '). ' +
                          'Please make sure you have schedule defined for ' +
                          '[Tier: ' + escalateTo + ',' +
                          ' Type: ' + c.type + ',' +                       
                          ' Product: ' + c.product.name + ', and' +
                          ' Program: ' + result + ']';                 
                          ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, result));
                } 
                else 
                {
                     errorCode = 2;
                     result    = 'More than one support person was found for today. Please select the approriate person to escalate the case.';
                     ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING, 'Ooops! Multiple Support persons found for the Product.'));
                }   
               }
    }
    
  }