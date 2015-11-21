/*****************************************************************
Name          : ServiceRequestHelper
Created By    : P. Labaye
Company Name  : ViaSat
Project       : ATRF Project
Created Date  : January 2015
Modified Date : Nov 2015, Anand Sanjeev, Jaspreet Singh modified for case 582979
******************************************************************/
public class ServiceRequestHelper 
{    
    //Nov 2015, Changes for CASE# 582979 
    
    //Get custom setting values for Type field of cases to be updated 
    private static final String ATRF_CONFIG_CASETYPE = CarlsbadNOCKeyValueStore__c.getInstance('ATRF_CONFIGCASE_TYPE_FIELD_VAL') != null ? CarlsbadNOCKeyValueStore__c.getInstance('ATRF_CONFIGCASE_TYPE_FIELD_VAL').value__c : ' '; 
    private static final String ATRF_COMMISION_CASETYPE = CarlsbadNOCKeyValueStore__c.getInstance('ATRF_COMMSNCASE_TYPE_FIELD_VAL') != null ?  CarlsbadNOCKeyValueStore__c.getInstance('ATRF_COMMSNCASE_TYPE_FIELD_VAL').value__c : ' ';   
    private static final String ATRF_DECOMMISION_CASETYPE = CarlsbadNOCKeyValueStore__c.getInstance('ATRF_DECOMMCASE_TYPE_FIELD_VAL') != null ? CarlsbadNOCKeyValueStore__c.getInstance('ATRF_DECOMMCASE_TYPE_FIELD_VAL').value__c : ' ';   
    
    //Get custom setting values for Category field of Cases (Config, Commission & Decommission)    
    private static final String ATRF_CONFIG_CASECATEGORY = CarlsbadNOCKeyValueStore__c.getInstance('ATRF_CONFIGCASE_CATEGORY_FIELD_VAL') != null ? CarlsbadNOCKeyValueStore__c.getInstance('ATRF_CONFIGCASE_CATEGORY_FIELD_VAL').value__c : ' ';    
    private static final String ATRF_COMMISION_CASECATEGORY = CarlsbadNOCKeyValueStore__c.getInstance('ATRF_COMMSNCASE_CATEGORY_FIELD_VAL') != null ? CarlsbadNOCKeyValueStore__c.getInstance('ATRF_COMMSNCASE_CATEGORY_FIELD_VAL').value__c : ' ';    
    private static final String ATRF_DECOMMISION_CASECATEGORY = CarlsbadNOCKeyValueStore__c.getInstance('ATRF_DECOMMCASE_CATEGORY_FIELD_VAL') != null ? CarlsbadNOCKeyValueStore__c.getInstance('ATRF_DECOMMCASE_CATEGORY_FIELD_VAL').value__c : ' ';
    
    // Get custom setting values for Subject field of Cases (Config, Commission & Decommission)    
    private static final String ATRF_CONFIG_CASESUBJECT = CarlsbadNOCKeyValueStore__c.getInstance('ATRF_CONFIGCASE_SUBJ_FIELD_VAL_PREF') != null ? CarlsbadNOCKeyValueStore__c.getInstance('ATRF_CONFIGCASE_SUBJ_FIELD_VAL_PREF').value__c : ' ';    
    private static final String ATRF_COMMISION_CASESUBJECT = CarlsbadNOCKeyValueStore__c.getInstance('ATRF_COMMSNCASE_SUBJ_FIELD_VAL_PREF') != null ? CarlsbadNOCKeyValueStore__c.getInstance('ATRF_COMMSNCASE_SUBJ_FIELD_VAL_PREF').value__c : ' ';    
    private static final String ATRF_DECOMMISION_CASESUBJECT = CarlsbadNOCKeyValueStore__c.getInstance('ATRF_DECOMMCASE_SUBJ_FIELD_VAL_PREF') != null ? CarlsbadNOCKeyValueStore__c.getInstance('ATRF_DECOMMCASE_SUBJ_FIELD_VAL_PREF').value__c : ' ';
    
    public Static String SITE_STATUS_TO_AVOID = 'SITE_STATUS_TO_AVOID';
    //*************************************************
    // Methods related to ATRF Update Validation
    //*************************************************
    public static Boolean ATRFUpdateIsValid(Service_Request__c sr, Service_Request__c srOld)
    {
        Boolean updateValid=true; // default to ok        
        // JIRA SFP-21
        // Check for revision validation
        // outside the creation stage
        if (sr.ATRF_Revision_Number__c != null &&  srOld.ATRF_Revision_Number__c != null)
        {
            if (sr.ATRFReasonforNewRevision__c == null)
            {
                sr.ATRFReasonforNewRevision__c.adderror('Please update reason for revision.');  
                return false;
            }
        }
        
        if (sr.Status__c != srOld.Status__c)
        {   
            // if going to an auto status - always ok
            // New is currently the only status available to the user directly 
            if (sr.Status__c != 'New')         
                return true;
            
            // Do not allow going to "New' from Approved, Archived, Active, Deactivated or Expired
            if ((srOld.Status__c == 'Approved' || srOld.Status__c == 'Archived' || srOld.Status__c == 'Active' || srOld.Status__c == 'Deactivated' || srOld.Status__c == 'Expired'))
            {
                sr.Status__c.adderror('Unable to update ATRF already in this status: '+ srOld.Status__c);   
                return false;
            }   
        }           
        
        Boolean ownerChanged=(sr.ownerId != srOld.ownerId)? true:false;
        // If already in Approved, Deactivation Approved, Active, Deactivated or Expired - only owner switch is tolerated
        if ((sr.Status__c == 'Approved' && !ownerChanged) ||    
            (sr.Status__c == 'Deactivation Approved' && !ownerChanged) ||
            (sr.Status__c == 'Active' && !ownerChanged) ||
            (sr.Status__c == 'Deactivated' && !ownerChanged) ||
            (sr.Status__c == 'Expired' && !ownerChanged) || 
            (sr.Status__c == 'Archived'))
        {            
            updateValid = false;
            sr.Status__c.adderror('Unable to update ATRF in this status: '+ sr.Status__c);              
        }
        return updateValid;
    }
    
    //*************************************************
    // Methods related to ATRF Approvers
    //*************************************************
    private static final Integer ATRF_MAX_APPROVERS = 50; // the code works for any number of fields - increase this value if more than 50 fields of one type are needed.
    private static final String ATRF_APPROVER_FLD = 'ATRF_Approver';
    private static final String ATRF_COUNT_FLD = 'Count'; // convention for the count field: same as approver field name with Count at the end.
    
    // for individual category counters
    private static final String ATRF_FINANCE_APPROVER_FLD = 'ATRF_FinanceApprover';
    private static final String ATRF_BUSINESS_APPROVER_FLD = 'ATRF_BusinessApprover';
    private static final String ATRF_CAPACITY_APPROVER_FLD = 'ATRF_CapacityPlanningApprover';  
    
    
    // Clear all ATRF approvers
    public static void clearATRFApprovers(Service_Request__c sr)
    {   
        clearApproverCounter(sr, ATRF_FINANCE_APPROVER_FLD);    
        clearApproverCounter(sr, ATRF_BUSINESS_APPROVER_FLD);
        clearApproverCounter(sr, ATRF_CAPACITY_APPROVER_FLD);
        clearApprovers(sr, ATRF_APPROVER_FLD);
    }
    
    // Add all ATRF approvers
    // convention : Finance approvers first, then business, then capacity
    public static void addATRFApprovers(Service_Request__c sr, list<ServiceRequestSite__c> srsList)
    {
        //9/2/15: Clear the approver collection fields too
        sr.BusinessApprovers__c = null;
        sr.FinanceApprovers__c = null;
        sr.CapacityPlanningApprovers__c = null;
        
        for (ServiceRequestSite__c srs : srsList)
        {
            if (srs.ServiceSite__r.ATRF_Finance_Approver__c != null)
            {
                System.debug('approver:' + srs.ServiceSite__r.ATRF_Finance_Approver__c);
                
                // this hub needs finance approval              
                addApprover(sr, srs.ServiceSite__r.ATRF_Finance_Approver__c, ATRF_APPROVER_FLD, ATRF_FINANCE_APPROVER_FLD);  
                
                
                //9/2/15: Collect the finance approver names
                if(sr.FinanceApprovers__c == null)
                    sr.FinanceApprovers__c = srs.ServiceSite__r.ATRF_Finance_Approver__r.Name;
                else
                    if(!sr.FinanceApprovers__c.contains(srs.ServiceSite__r.ATRF_Finance_Approver__r.Name))   
                    sr.FinanceApprovers__c = sr.FinanceApprovers__c + ';' + srs.ServiceSite__r.ATRF_Finance_Approver__r.Name;    
            }
        }   
        
        for (ServiceRequestSite__c srs : srsList)
        {   
            if (srs.ServiceSite__r.ATRF_Business_Approver__c != null)
            {
                System.debug('approver:' + srs.ServiceSite__r.ATRF_Business_Approver__c);
                
                // this hub needs business approval             
                addApprover(sr, srs.ServiceSite__r.ATRF_Business_Approver__c, ATRF_APPROVER_FLD, ATRF_BUSINESS_APPROVER_FLD );  
                
                //9/2/15: Collect the Business approver names
                if(sr.BusinessApprovers__c == null)
                    sr.BusinessApprovers__c = srs.ServiceSite__r.ATRF_Business_Approver__r.Name;
                else
                    if(!sr.BusinessApprovers__c.contains(srs.ServiceSite__r.ATRF_Business_Approver__r.Name))  
                    sr.BusinessApprovers__c = sr.BusinessApprovers__c + ';' + srs.ServiceSite__r.ATRF_Business_Approver__r.Name;  
            }
        }   
        
        for (ServiceRequestSite__c srs : srsList)
        {   
            if (srs.ServiceSite__r.ATRF_Capacity_Planning_Approver__c != null)
            {
                System.debug('approver:' + srs.ServiceSite__r.ATRF_Capacity_Planning_Approver__c);
                
                // this hub needs capacity approval             
                addApprover(sr, srs.ServiceSite__r.ATRF_Capacity_Planning_Approver__c, ATRF_APPROVER_FLD, ATRF_CAPACITY_APPROVER_FLD );    
                
                
                //9/2/15: Collect the Capacity planning approver names
                if(sr.CapacityPlanningApprovers__c == null)
                    sr.CapacityPlanningApprovers__c = srs.ServiceSite__r.ATRF_Capacity_Planning_Approver__r.Name;
                else
                    if(!sr.CapacityPlanningApprovers__c.contains(srs.ServiceSite__r.ATRF_Capacity_Planning_Approver__r.Name))  
                    sr.CapacityPlanningApprovers__c = sr.CapacityPlanningApprovers__c + ';' + srs.ServiceSite__r.ATRF_Capacity_Planning_Approver__r.Name; 
            }
        }
    }
    
    
    //common methods for all types of approvers
    private static void clearApprovers(Service_Request__c sr, string baseName)
    {
        try             
        { 
            for (integer index=1; index <= ATRF_MAX_APPROVERS; index++)
            {
                String approverFldName = baseName + index + '__c';
                sr.put(approverFldName, null);  
                System.debug('approverFldName:' + approverFldName + ' set to null');        
            }
            
            //9/2/15: Clear the approver collection fields too
            sr.BusinessApprovers__c = null;
            sr.FinanceApprovers__c = null;
            sr.CapacityPlanningApprovers__c = null;
        }
        catch (Exception e)
        {
            // expected exception (stop when out of fields)
            System.debug('exception:' + e);     
        }
        finally
        {
            // clear count
            clearApproverCounter(sr, baseName);                         
        }
    }
    
    private static void clearApproverCounter(Service_Request__c sr, string baseName)
    {
        // clear count
        sr.put(basename+ATRF_COUNT_FLD+'__c', 0);    
    }
    
    
    
    
    private static void addApprover(Service_Request__c sr, ID userId, string baseName, string subCountBaseName )
    {
        Decimal cnt = (Decimal) sr.get(basename+ATRF_COUNT_FLD+'__c');
        if (cnt==null)
            cnt=0;
        
        Decimal subCnt = (Decimal) sr.get(subCountBaseName+ATRF_COUNT_FLD+'__c');
        if (subCnt==null)
            subCnt=0;
        
        try             
        { 
            for (integer index=1; index <= ATRF_MAX_APPROVERS; index++)
            {
                String approverFldName = baseName + index + '__c';
                ID currentApproverId = (ID)sr.get(approverFldName);
                if (currentApproverId == null)
                {                   
                    sr.put(approverFldName, userId);
                    cnt += 1;
                    subCnt += 1;
                    System.debug('approverFldName:' + approverFldName + ' set to: ' + userId);
                    // done
                    break;          
                }           
                else if (currentApproverId == userId)
                {
                    // user already in the list of approvers
                    break;
                }
            }
        }
        catch (Exception e)
        {
            sr.adderror('Unable to add approver('+ userId + ') on ' + baseName + (cnt+1) + '__c');
        }   
        finally
        {
            // set the count
            sr.put(basename+ATRF_COUNT_FLD+'__c', cnt); 
            // and sub count
            sr.put(subCountBaseName+ATRF_COUNT_FLD+'__c', subCnt);  
        }
    }
    
    
    //*************************************************
    // Methods related to Approval Email Reminders
    //*************************************************
    @InvocableMethod
    public static void sendATRFApprovalEmailReminders(List<Service_Request__c> srList)
    {
        
        final RecordType ATRFrecordtype=[SELECT Id FROM RecordType WHERE SObjectType = 'Service_Request__c' AND recordType.DeveloperName='ATRF_Gov'];   
        final EmailTemplate emailTemplate = [select id, name from EmailTemplate where developername = 'ATRF_ReminderVF'];
        final Group CarlsbadNOCATRFNetworkingApprovalQueue = [Select Type, Name, id, DeveloperName From Group where DeveloperName = 'Carlsbad_NOC_ATRF_Networking_Approval_Qu'];        
        
        if (emailTemplate == null)
            return; // dont go further if email template is not there
        
        
        // Select only the ATRFs in submitted status
        Map <Id, Service_Request__c> srMap = new Map <Id, Service_Request__c>();
        for (Service_Request__c sr : srList)
        {
            if ((sr.recordtypeId == ATRFrecordtype.Id) && (sr.Status__c == 'Submitted'))
                srMap.put(sr.id, sr);
        }       
        
        if (srMap.size() > 0)
        {
            
            //list the current approval processes pending
            list <ProcessInstance> processList = [select Id, Status, targetObjectID, (Select Id, ProcessInstanceId, OriginalActorId, ActorId, ElapsedTimeInDays, ElapsedTimeInHours, ElapsedTimeInMinutes From Workitems) from ProcessInstance where Status='Pending' and targetObjectID in :srMap.KeySet()]; 
            
            if (processList != null && processList.size()>0)
            {
                List<Messaging.SingleEmailMessage> emailList = new List<Messaging.SingleEmailMessage>();
                List <Id> networkReminderSrList = new List<Id>();
                
                for (ProcessInstance pr :  processList)
                {
                    if (pr.Workitems == null ||  pr.Workitems.size() == 0 )
                        continue;
                    
                    for (ProcessInstanceWorkitem pwi : pr.Workitems )
                    {
                        if (pwi.ActorId.getSObjectType() == User.SObjectType || pwi.ActorId.getSObjectType() == Contact.SObjectType)
                        {
                            // Sending to a user
                            // build email reminder for this service request 
                            Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
                            email.setTemplateId(emailTemplate.Id); 
                            email.setTargetObjectId(pwi.ActorId); // user or contact ids only
                            email.setWhatId(pr.targetObjectID); // the service request  
                            email.setSaveAsActivity(false); // set as activity is not allowed in this case
                            emailList.add(email);
                        }
                        else if (CarlsbadNOCATRFNetworkingApprovalQueue != null && pwi.ActorId == CarlsbadNOCATRFNetworkingApprovalQueue.Id)
                        {
                            // queue case 
                            // add the sr to the list of sr whose networking queue needs a reminder
                            Service_Request__c sr = srMap.get(pr.targetObjectID);
                            if (sr != null)
                                networkReminderSrList.add(sr.Id);                               
                            
                        }
                        
                    }
                    
                }
                
                // send emails
                if (emailList.size() > 0)
                {
                    List<Messaging.SendEmailResult> results = Messaging.sendEmail(emailList);
                }
                
                // Trigger network queue reminder 
                if (networkReminderSrList.size() > 0)
                {
                    // Call to update sr
                    if (Test.isRunningTest())
                        triggerATRFNetworkingApprovalReminder(networkReminderSrList);
                    else        
                        triggerATRFNetworkingApprovalReminderAsync(networkReminderSrList);
                }               
            }
        }
    }   
    
    // set the ATRF_SendNetworkApprovalReminder__c in sr to indicate that an approval reminder is needed 
    @future
    public static void triggerATRFNetworkingApprovalReminderAsync(list<Id> srIds)
    {
        triggerATRFNetworkingApprovalReminder(srIds);
    }
    
    private static void triggerATRFNetworkingApprovalReminder(list<Id> srIds)
    {
        list <Service_Request__c> srList = [select Id, Status__c from Service_Request__c where Status__c = 'Submitted' and Id in :srIds]; // only in Submitted status
        
        if (srList != null && srList.size() > 0)
        {
            for (Service_Request__c myRequest : srList) 
            {
                myRequest.ATRF_SendNetworkApprovalReminder__c = true;
            }
            
            update srList;
        }
    }
    
    //*************************************************
    // Methods related to ATRF Case Creation
    //*************************************************     
    // It is used in ServiceRequestBefore.trigger
    // - Create ATRF Case
    // - Create Networking Task
    // - Support Activation
    // - Support Revisions
    //
    // When a new revision of an ATRF is created, the system automatically creates cases for each terminal upon final approval 
    // - IF any fields in the ‘Service Requirements’ or ‘Configuration Information’ sections have changed; 
    //   These field values (old value and new value) are also listed in the Case DescriptionCreate ATRF Cases;
    
    static private final RecordType caseRecordType = [Select Id From RecordType where SObjectType = 'Case' and DeveloperName='Carlsbad_NOC'];
    
    // Auto create case for 'approved' or 'deactivation approved' ATRF.
    // ATRF II: When Hubs ADDED/REMOVED to/from a new version of an ATRF (based on previous revision), a Case shall be created against each Terminal in the ATRF:
    //          Case Type shall be set to ‘Administrative’; The Case Category shall be set to ‘Commission/Activate’ / ‘Decommission/Deactivate’
    //          Case shall list each Hub that has been added/removed to/from ATRF in the Case Description (Site ID and the Site Name for each Hub)
    // ATRF II: Update ATRFChangeDetails__c field with:
    //  - updates on ATRF_ServiceRequirementsAndConfig FieldSet between versions of SR  
    //  - any Terminals & Hubs that were added or removed between versions of SR   
    public static void createATRFCases(list<Service_Request__c> srList)
    {
        final Group caseQueue= [Select Name, id From Group where type = 'Queue' and Name = 'NOC - Tier 1'];
        
        //-----------------------------------------------------------------------------------       
        // Get the CURRENT list of terminals and hubs for the Service Requests that we creating Cases for
        //Nov 2015 Change for case 00602189 - adding service site status to the list of fields being queried
        
        map <id, Service_Request__c> srMap = new map <Id,Service_Request__c>(
            [SELECT Id, (SELECT Id, SiteName__c, ServiceSite__c, ServiceSite__r.Name, ServiceSite__r.Status__c, SatelliteIP__c, ServiceSite__r.product__c, ServiceSite__r.Account__c, recordTypeId, recordType.DeveloperName 
                         FROM Service_Request_Sites__r) 
             FROM Service_Request__c WHERE id in :srList]);             
        
        // Get the contacts (for the cases) from the ownerId of the sr      
        // collect user ids
        // collect previous revisions if activation case (approval)
        // map  new terminals
        set <Id> ownerIds = new set<Id>();
        map <Id, Id> previousRevMap = new map<Id,Id>();
        map <id, map<Id, Service_Request__c>> srTerminals = new map<id, map<Id, Service_Request__c>>(); 
        map <id, map<Id, Service_Request__c>> srHubs = new map<id, map<Id, Service_Request__c>>(); 
        for (Service_Request__c sr : srList)
        {
            if (!ownerIds.contains(sr.OwnerId)) ownerIds.add(sr.OwnerId);
            
            if (sr.ATRF_PreviousRevision__c != null && sr.Status__c != 'Deactivation Approved')
                previousRevMap.put(sr.id, sr.ATRF_PreviousRevision__c);
            
            map<Id, Service_Request__c> terminalMap = new map<Id, Service_Request__c>();
            map<Id, Service_Request__c> hubMap = new map<Id, Service_Request__c>();
            srTerminals.put (sr.Id, terminalMap);
            srHubs.put (sr.Id, hubMap);
            // loop thru ServiceRequest Sites
            for (ServiceRequestSite__c srs : srMap.get(sr.Id).Service_Request_Sites__r)
            {
                if (srs.recordType.DeveloperName == 'Terminal')
                    terminalMap.put(srs.ServiceSite__c, sr); // terminals should not be duplicated in srs   
                if (srs.recordType.DeveloperName == 'Hub')
                    hubMap.put(srs.ServiceSite__c, sr); // hubs should not be duplicated in srs 
            }           
        }   
        // user id -> user
        map <Id, User> userMap = new map<Id, User>([select id, Name from user where Id in :ownerIds]); 
        
        // collect user names
        list <String> userNames = new list<String>();
        for (User usr : userMap.values())
        {
            userNames.add(usr.Name);            
        }
        
        // get contact from user name matching in corporate account only
        Globals__c gs = Globals__c.getInstance();
        list <contact> contactList = [select Id, Name from Contact where AccountId=:gs.ViaSatAccount__c and Name in:userNames];
        
        // name -> contact
        map <String, contact> contactNameMap = new map<String, contact>();
        for (Contact c : contactList)
        {
            // we pickup the first found contact (in case of duplicate)
            if (!contactNameMap.containsKey(c.Name))
                contactNameMap.put(c.Name, c);              
        }
        
        //-----------------------------------------------------------------------------------       
        // Do we have revisions? If YES, gather PREV data
        map <id, Service_Request__c> previousSRs; 
        map <id, Service_Request__c> srPreviousConfigMap;
        map <id, map<Id, Service_Request__c>> previousSRTerminals = new map<id, map<Id, Service_Request__c>>(); 
        map <id, map<Id, Service_Request__c>> previousSRHubs = new map<id, map<Id, Service_Request__c>>(); 
        
        if (previousRevMap.size() > 0)
        {
            // Get the previous revisions: will be used to build the correct cases for the revisions
            // build map of SR to Terminals and Hubs
            list <Id> previousSrList = previousRevMap.Values(); 
            //Nov 2015 Change for case 00602189 - adding service site status to the list of fields being queried
            previousSRs = new map<Id, Service_Request__c>([SELECT Id, (SELECT Id, SiteName__c, ServiceSite__c, ServiceSite__r.Name, ServiceSite__r.Status__c, SatelliteIP__c, ServiceSite__r.product__c, ServiceSite__r.Account__c, recordType.DeveloperName 
                                                                       FROM Service_Request_Sites__r) 
                                                           FROM Service_Request__c WHERE id in :previousSrList]);
            if (previousSRs != null)
            {
                for (Service_request__c sr : previousSRs.Values())
                {
                    map<Id, Service_Request__c> terminalMap = new map<Id, Service_Request__c>();
                    previousSRTerminals.put (sr.Id, terminalMap);
                    map<Id, Service_Request__c> hubMap = new map<Id, Service_Request__c>();
                    previousSRHubs.put (sr.Id, hubMap);
                    
                    // loop thru previous terminals and hubs
                    for (ServiceRequestSite__c srs : sr.Service_Request_Sites__r)
                    {
                        if (srs.recordType.DeveloperName == 'Terminal')
                            terminalMap.put(srs.ServiceSite__c, sr); // terminals should not be duplicated in srs   
                        if (srs.recordType.DeveloperName == 'Hub')
                            hubMap.put(srs.ServiceSite__c, sr); // hubs should not be duplicated in srs 
                    }
                }               
            }           
            
            // get configs for all previous srs 
            string SOQLString  = 'SELECT ';
            SOQLString += getATRFListOfRequirementsAndConfigFields();
            SOQLString += 'Id,Name FROM Service_Request__c WHERE id in :previousSrList';  
            System.debug('*** SOQLString: '+ SOQLString);           
            srPreviousConfigMap = new map<id,Service_Request__c>((List<Service_Request__c>)Database.query(SOQLString));     
        }
        
        //-----------------------------------------------------------------------------------   
        // Build a list of Cases & Tasks to create
        list <Case> caseList = new list<case>();
        list <Case> taskCaseList = new list<case>();
        
        map <Id, Case> srCaseMap = new map <Id, Case>(); 
        
        for (Service_Request__c sr : srList)
        {
            // determine contactid
            User myUser = userMap.get(sr.ownerId);
            Contact myContact = contactNameMap.get(myUser.Name);
            
            // new ATRF or deactivation
            if (sr.Status__c != 'Submitted' && (sr.ATRF_PreviousRevision__c == null || sr.Status__c == 'Deactivation Approved'))
            {           
                // Create one commission/decommission case per terminal
                for (ServiceRequestSite__c srs : srMap.get(sr.Id).Service_Request_Sites__r)
                {
                    if (srs.recordType.DeveloperName == 'Terminal')
                    {
                        if (sr.Status__c == 'Deactivation Approved')
                        {
                            // create a decommission case
                            Case myCase=CreateATRFDecommissionCase(sr, srs, (myContact!=null)?myContact.Id:null, caseQueue.Id);
                            if (mycase != null)
                                caseList.add(myCase);                       
                        }
                        else 
                        {                           
                            // create a commission case
                            Case myCase=CreateATRFCommissionCase(sr, srs, (myContact!=null)?myContact.Id:null, caseQueue.Id);
                            if (mycase != null)
                            {
                                caseList.add(myCase);
                                
                                // special routing task
                                if (sr.ATRF_Networking_Approval_Needed__c)
                                    taskCaseList.add(myCase);
                            }
                        }
                    }
                }
            }
            // Previous revision exists   
            else if (sr.ATRF_PreviousRevision__c != null)                         
            {
                // get current terminals & hubs
                map<Id, Service_Request__c> currentTerminals = srTerminals.get(sr.Id);
                map<Id, Service_Request__c> currentHubs = srHubs.get(sr.Id);
                
                // get previous rev and its terminals & hubs
                Service_Request__c previousSR = previousSRs.get(sr.ATRF_PreviousRevision__c);
                map<Id, Service_Request__c> previousRevTerminals = previousSRTerminals.get(sr.ATRF_PreviousRevision__c);
                map<Id, Service_Request__c> previousRevHubs = previousSRHubs.get(sr.ATRF_PreviousRevision__c);
                
                // Check if any field from ATRF config FieldSet was changed: compare new and previous rev
                Boolean configSame = CompareATRFRevisions(sr, srPreviousConfigMap.get(previousSR.Id)); 
                String sATRFRequirementsAndConfigChanges = OutputATRFRequirementsAndConfigFields(sr, srPreviousConfigMap.get(previousSR.Id));
                sr.ATRFChangeDetails__c = sATRFRequirementsAndConfigChanges;
                
                // Check if any Hub or terminal was added on the new revision
                String sHubsAdded = '';
                String sTerminalsAdded = '';
                for (ServiceRequestSite__c srs : srMap.get(sr.Id).Service_Request_Sites__r)
                {
                    // since SiteName__c is <a href="/a0F180000000PlL" target="_top">Test Hub B</a>
                    string[] s = srs.SiteName__c.split('>',2);
                    string sSiteName = (s.size() > 1 ? s[1].replace('</a>','') : srs.SiteName__c);
                    if (srs.recordType.DeveloperName == 'Hub' && !previousRevHubs.containsKey(srs.ServiceSite__c))
                        sHubsAdded += ((sHubsAdded == '' ?'Hubs added: ':', ') + string.valueOf(srs.ServiceSite__r.Name) + ' - ' + sSiteName);
                    if (srs.recordType.DeveloperName == 'Terminal' && !previousRevTerminals.containsKey(srs.ServiceSite__c))
                        sTerminalsAdded += ((sTerminalsAdded == '' ?'Terminals added: ':', ') + string.valueOf(srs.ServiceSite__r.Name) + ' - ' + sSiteName); 
                }
                //Adding space before the newline to fix an issue where email is not rendered properly in outlook.
                //Refer this for the issue https://support.microsoft.com/en-us/kb/287816
                if (sHubsAdded != '')       sr.ATRFChangeDetails__c += ('   \n' + sHubsAdded);
                if (sTerminalsAdded != '')  sr.ATRFChangeDetails__c += ('   \n' + sTerminalsAdded);
                
                // Check if any Hub or terminal was deleted on the new revision
                String sHubsDeleted = '';
                String sTerminalsDeleted = '';
                
                //Nov 2015 Change for case 00602189 - collect hubs and terminals which were actually deleted and not removed because they were archived.
                List<ServiceRequestSite__c> listOfHubsDeleted = new List<ServiceRequestSite__c>();
                List<ServiceRequestSite__c> listOfTerminalsDeleted = new List<ServiceRequestSite__c>();
                Set<String> setOfStatusToAvoid = ServiceRequestHelper.getSiteStatusesToAvoid();
                
                for (ServiceRequestSite__c srs : previousSR.Service_Request_Sites__r)
                {
                    string[] s = srs.SiteName__c.split('>',2);
                    string sSiteName = (s.size() > 1 ? s[1].replace('</a>','') : srs.SiteName__c);
                    if (srs.recordType.DeveloperName == 'Hub' && !currentHubs.containsKey(srs.ServiceSite__c))
                    {    
                        sHubsDeleted += ((sHubsDeleted == '' ?'Hubs deleted: ':'') + string.valueOf(srs.ServiceSite__r.Name) + ' - ' + sSiteName);
                        //Nov 2015 Change for case 00602189 - collect hubs which were actually deleted and not removed because they were archived.
                        if(!setOfStatusToAvoid.contains(srs.ServiceSite__r.Status__c))
                            listOfHubsDeleted.add(srs);
                    }
                    if (srs.recordType.DeveloperName == 'Terminal' && !currentTerminals.containsKey(srs.ServiceSite__c))
                    {   
                        sTerminalsDeleted += ((sTerminalsDeleted == '' ?'Terminals deleted: ':', ') + string.valueOf(srs.ServiceSite__r.Name) + ' - ' + sSiteName);
                        //Nov 2015 Change for case 00602189 - collect hubs which were actually deleted and not removed because they were archived.
                        if(!setOfStatusToAvoid.contains(srs.ServiceSite__r.Status__c))
                            listOfTerminalsDeleted.add(srs);
                    }
                }
                //Adding space before the newline to fix an issue where email is not rendered properly in outlook.
                //Refer this for the issue https://support.microsoft.com/en-us/kb/287816
                if (sHubsDeleted != '')         sr.ATRFChangeDetails__c += ('   \n' + sHubsDeleted);               
                if (sTerminalsDeleted != '')    sr.ATRFChangeDetails__c += ('   \n' + sTerminalsDeleted);
                
                // To not create case if the status is 'submitted'
                if (sr.Status__c != 'Submitted') 
                {
                    // For each SR loop thru terminals of the new revision and Create CASE if:
                    // - 
                    for (ServiceRequestSite__c srs : srMap.get(sr.Id).Service_Request_Sites__r)
                    {
                        Case myCase=null;
                        if (srs.recordType.DeveloperName == 'Terminal')
                        {                   
                            // Is it a new terminal for revision? YES-> create a commission case
                            if (!previousRevTerminals.containsKey(srs.ServiceSite__c))
                                myCase = CreateATRFCommissionCase(sr, srs, (myContact!=null)?myContact.Id:null, caseQueue.Id);
                            else 
                                if (!configSame) 
                                // NO (existing terminal) but config changed -> create a config case
                                myCase = CreateATRFConfigCase(sr, sATRFRequirementsAndConfigChanges, srs, (myContact!=null)?myContact.Id:null, caseQueue.Id);                       
                            
                            if (sHubsAdded != '')
                            {
                                Case myCaseForAddedHubs = CreateATRFCommissionCase(sr, srs, (myContact!=null)?myContact.Id:null, caseQueue.Id);
                                myCaseForAddedHubs.Description += ('\n' + sHubsAdded);
                                caseList.add(myCaseForAddedHubs);
                                // special routing task
                                if (sr.ATRF_Networking_Approval_Needed__c)
                                    taskCaseList.add(myCaseForAddedHubs);
                            } 
                            
                            //Nov 2015 Change for case 00602189 - Cases should not be created if the hub was removed because it was archived.     
                            if (sHubsDeleted != '' && listOfHubsDeleted.size() > 0)
                            {
                                Case myCaseForDeletedHubs = CreateATRFDecommissionCase(sr, srs, (myContact!=null)?myContact.Id:null, caseQueue.Id);
                                myCaseForDeletedHubs.Description += ('\n' + sHubsDeleted);
                                caseList.add(myCaseForDeletedHubs);
                                // special routing task
                                if (sr.ATRF_Networking_Approval_Needed__c)
                                    taskCaseList.add(myCaseForDeletedHubs);
                            }                   
                        }           
                        
                        if (mycase != null)
                        {
                            caseList.add(myCase);
                            // special routing task
                            if (sr.ATRF_Networking_Approval_Needed__c)
                                taskCaseList.add(myCase);
                        }   
                    }
                    
                    // loop thru terminals part of previous revision
                    //Nov 2015 Change for case 00602189 - Cases should not be created if the terminal was removed because it was archived.
                    for (ServiceRequestSite__c srs : previousSR.Service_Request_Sites__r)
                    {
                        Case myCase=null;
                        // Was the terminal removed?
                        if (srs.recordType.DeveloperName == 'Terminal'
                            && !currentTerminals.containsKey(srs.ServiceSite__c)
                            && !setOfStatusToAvoid.contains(srs.ServiceSite__r.Status__c))
                        {
                            // terminal removed, create a decommission case
                            myCase=CreateATRFDecommissionCase(sr, srs, (myContact!=null)?myContact.Id:null, caseQueue.Id);
                            caseList.add(myCase);
                            
                            // special routing task
                            if (sr.ATRF_Networking_Approval_Needed__c)
                                taskCaseList.add(myCase);
                        }                       
                    }               
                }
            }
        }
        
        //-----------------------------------------------------------------------------------       
        // insert case + case task in DB
        try
        {
            if (caseList.size() > 0)
                insert caseList;
            
            if (taskCaseList.size() > 0)
            {
                list <task> taskList = new list <task>();
                RecordType rt = [SELECT Id FROM RecordType WHERE SObjectType='Task' AND DeveloperName='CarlsbadNOC'];  
                ID taskOwnerId=(Test.isRunningTest())?UserInfo.getUserId():(ID)KeyValueStoreHelper.getTextValue('SpecialRoutingCaseTaskAssignmentId');
                // JIRA SFP-18 
                set<Id> caseServiceRequestIds = new set<Id>();
                for (case c: taskCaseList)
                    caseServiceRequestIds.add(c.ServiceRequest__c);                         
                
                map<id, Service_Request__c> serviceRequestMap = new map<id, Service_Request__c >([select Id, Name from Service_Request__c where Id in :caseServiceRequestIds]);
                
                for (case c: taskCaseList)
                {
                    // create the case task
                    Task myTask = new Task();
                    myTask.Status='Not Started';
                    myTask.Priority='Normal';
                    myTask.OwnerId=taskOwnerId;
                    myTask.RecordTypeId = rt.id;
                    myTask.Type = 'Action Required';                    
                    myTask.whatid=c.Id;        
                    myTask.Subject = 'Special Routing Required for a Terminal';
                    myTask.Description = 'Networking Group assistance is required for this terminal.  Please review ATR (' +serviceRequestMap.get(c.ServiceRequest__c).Name +').  If you have any questions contact the PM.';
                    
                    taskList.add(myTask);               
                }               
                insert taskList;                
            }
        }
        catch (Exception e)
        {
            for (Service_Request__c sr : srList)
            {
                sr.adderror('Unable to create case(s): '+ e.getMessage()); 
            }
        }
    }
    
    
    
    private static Case createATRFCommissionCase(Service_Request__c sr, ServiceRequestSite__c srs, Id contactId, Id ownerId)
    {       
        Case myCase = new Case(); 
        myCase.recordTypeId = caseRecordType.Id;
        myCase.Type = ATRF_COMMISION_CASETYPE; // 'Administrative';
        myCase.Category__c = ATRF_COMMISION_CASECATEGORY; // 'Commission/Activate'; 
        myCase.Subject = ATRF_COMMISION_CASESUBJECT +' '+ (srs.SatelliteIP__c != null ? srs.SatelliteIP__c : ' '); //'Fulfill ATRF - ' + srs.SatelliteIP__c; 
        myCase.Description = 'Please review ATRF # ' + sr.Name + ', and perform necessary steps to provision air time as described. ';
        myCase.OwnerId = ownerId;
        myCase.ServiceRequest__c = sr.id;
        myCase.Site__c = srs.ServiceSite__c;
        //ATRF Phase 2.2  9/21/15 - do not populate the contact fields on the case getting created
        //myCase.ContactId = contactId;
        //myCase.CaseContact__c = mycase.ContactId;   //Removed 9/3/2015 - ATRF 2.0
        myCase.ProductId = srs.ServiceSite__r.product__c;
        myCase.AccountId = srs.ServiceSite__r.account__c;       
        myCase.Origin = 'Internal';
        myCase.VisibleToCustomer__c = 'Yes';        
        myCase.Terminal_Qty__c = 1;
        
        //Added 9/3/2015 - ATRF 2.0
        myCase.SendClosureEmail__c = false;
        
        return myCase;
    }
    
    
    private static Case createATRFDecommissionCase(Service_Request__c sr, ServiceRequestSite__c srs, Id contactId, Id ownerId)
    {
        Case myCase = new Case(); 
        myCase.recordTypeId = caseRecordType.Id;
        myCase.Type = ATRF_DECOMMISION_CASETYPE; //'Administrative';
        myCase.Category__c = ATRF_DECOMMISION_CASECATEGORY; //'Decommission/Deactivate'; 
        myCase.Subject = ATRF_DECOMMISION_CASESUBJECT +' '+ (srs.SatelliteIP__c != null ? srs.SatelliteIP__c : ' '); //'Decommission ATRF - ' + srs.SatelliteIP__c; 
        myCase.Description = 'Please review ATRF # ' + sr.Name + ', and perform necessary steps to de-provision air time as described';
        myCase.OwnerId = ownerId;
        myCase.ServiceRequest__c = sr.id;
        myCase.Site__c = srs.ServiceSite__c;
        //ATRF Phase 2.2  9/21/15 - do not populate the contact fields on the case getting created
        //myCase.ContactId = contactId;
        //myCase.CaseContact__c = mycase.ContactId;   //Removed 9/3/2015 - ATRF 2.0
        myCase.ProductId = srs.ServiceSite__r.product__c;
        myCase.AccountId = srs.ServiceSite__r.account__c;   
        myCase.Origin = 'Internal';
        myCase.VisibleToCustomer__c = 'Yes';    
        myCase.Terminal_Qty__c = 1;
        
        //Added 9/3/2015 - ATRF 2.0
        myCase.SendClosureEmail__c = false;
        
        return myCase;
    }
    
    
    private static Case createATRFConfigCase(Service_Request__c sr, String sATRFRequirementsAndConfigChanges, ServiceRequestSite__c srs, Id contactId, Id OwnerId)
    {
        Case myCase = new Case(); 
        myCase.recordTypeId = caseRecordType.Id;
        myCase.Type = ATRF_CONFIG_CASETYPE; //'Administrative';
        myCase.Category__c =  ATRF_CONFIG_CASECATEGORY; //'Plan/Config Change/Provision'; 
        myCase.Subject = ATRF_CONFIG_CASESUBJECT +' '+ (srs.SatelliteIP__c != null ? srs.SatelliteIP__c : ' '); //'Update ATRF - ' + srs.SatelliteIP__c; 
        myCase.Description = 'Please review ATRF # ' + sr.Name + ', and perform necessary steps to provision air time as described.';
        myCase.Description += sATRFRequirementsAndConfigChanges; //OutputATRFRequirementsAndConfigFields(sr, previousSR);
        myCase.OwnerId = OwnerId;
        myCase.ServiceRequest__c = sr.id;
        myCase.Site__c = srs.ServiceSite__c;
        //ATRF Phase 2.2  9/21/15 - do not populate the contact fields on the case getting created
        //myCase.ContactId = contactId;
        //myCase.CaseContact__c = mycase.ContactId;   //Removed 9/3/2015 - ATRF 2.0
        myCase.ProductId = srs.ServiceSite__r.product__c;
        myCase.AccountId = srs.ServiceSite__r.account__c;
        myCase.Origin = 'Internal';
        myCase.VisibleToCustomer__c = 'Yes';
        myCase.Terminal_Qty__c = 1;       
        
        //Added 9/3/2015 - ATRF 2.0
        myCase.SendClosureEmail__c = false;
        
        return myCase;
    }
    
    private static Boolean compareATRFRevisions(Service_Request__c sr, Service_Request__c previousSR) 
    {
        for(Schema.FieldSetMember f : getATRFListOfRequirementsAndConfigFieldMembers()) 
        {
            if (sr.get(f.getFieldPath()) != previousSR.get(f.getFieldPath()))
                return false;
        }
        return true;
    }
    
    private static string outputATRFRequirementsAndConfigFields(Service_Request__c sr, Service_Request__c previousSR) 
    {
        string outputString = '';       
        for(Schema.FieldSetMember f : getATRFListOfRequirementsAndConfigFieldMembers()) 
        {
            //Adding space before the newline to fix an issue where email is not rendered properly in outlook.
            //Refer this for the issue https://support.microsoft.com/en-us/kb/287816
            
            //Nov 15, Change for case 582979 - Add to the field only of the field value changed.
            if(previousSR.get(f.getFieldPath()) != sr.get(f.getFieldPath()))
            {
                string myString = '   \n' + f.getLabel() + ':' + previousSR.get(f.getFieldPath()) + '->' +  sr.get(f.getFieldPath());  
                outputString += myString;   
            }
        }
        return outputString;
    }
    
    // return , separated string (used in SOQL)
    private static string getATRFListOfRequirementsAndConfigFields()
    {
        string outputString=''; 
        for(Schema.FieldSetMember f : getATRFListOfRequirementsAndConfigFieldMembers()) 
        {
            outputString += f.getFieldPath() + ', ';
        }
        return outputString;
    }
    
    private static list<Schema.FieldSetMember> getATRFListOfRequirementsAndConfigFieldMembers()
    {
        return SObjectType.Service_Request__c.FieldSets.ATRF_ServiceRequirementsAndConfig.getFields();  
    }
    
    //******************************************************
    // Methods related to setting ATRF as Active/Deactivated
    //******************************************************
    
    // If all cases linked to ATRF are closed or no cases
    // set the ATRF as Active from Status Approved
    // or as Deactivated from Status Deactivation Approved
    public static void setATRFActive(list<Service_Request__c> srListInput) 
    {
        // create a map with input list
        map <Id,Service_Request__c> srMap = new map <Id,Service_Request__c> (srListInput);
        
        // get srList: srs with their cases
        list <Service_Request__c> srList=[Select Id, (Select Id, Status From Cases__r where IsClosed <> true) From Service_Request__c where id in :srListInput];
        
        for (Service_Request__c sr : srList)
        {
            Service_Request__c srInput = srMap.get(sr.id);
            
            if (sr.Cases__r.size() == 0)
            {
                if (srInput.status__c == 'Approved' )
                    // set to active 
                    srInput.status__c = 'Active';
                else if (srInput.status__c == 'Deactivation Approved')  
                    srInput.status__c = 'Deactivated';                              
            }
        }
    }
    
    //**************************************************************
    // Methods related to setting ATRF previous revision as Archived - used in ServiceRequestAfter.trigger
    //**************************************************************
    public static void archivePreviousATRFRevision(list<Service_Request__c> srListInput) 
    {
        list <id> idList = new list<id>();
        
        for (Service_Request__c sr : srListInput)
        {
            if (sr.ATRF_PreviousRevision__c != null)        
                idList.add (sr.ATRF_PreviousRevision__c);
        }
        
        // Archive request not already archived
        list<Service_Request__c> toArchiveList = [select Id, Status__c from Service_Request__c where Id in :idList and Status__c <> 'Archived']; 
        
        if (toArchiveList != null && toArchiveList.size() > 0 )
        {
            try
            {
                for (Service_Request__c sr : toArchiveList)
                    sr.Status__c = 'Archived';
                
                update toArchiveList; 
                
            }
            catch (Exception e)
            {
                for (Service_Request__c sr : srListInput)
                {
                    sr.adderror('Unable to archive ATRF previous revision: '+ e.getMessage()); 
                }
            }           
        }
    }
    
    //Nov 2015 Change for case 00602189 - get list of site statuses which needs to be ignored when 
    //1) Creating a new revision
    //2) Creating new cases based on terminals or hubs added or deleted.
    public static Set<String> getSiteStatusesToAvoid()
    {
        String statusesToAvoid = CarlsbadNOCKeyValueStore__c.getValues(SITE_STATUS_TO_AVOID) != null ? CarlsbadNOCKeyValueStore__c.getValues(SITE_STATUS_TO_AVOID).value__c : ' ';         
        Set<String> setOfStatusToAvoid = new Set<String>();
        setOfStatusToAvoid.addAll(statusesToAvoid.split(';'));
        return setOfStatusToAvoid;
    }
}