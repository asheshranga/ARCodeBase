/*********************************************************************************
Name         : CCRTriggerHandler
Created By   : Anand Sanjeev
Company Name : Slalom Consulting
Created Date : 08/24/2015
Modified Date: 
Usages       : Handler class for the trigger CCRTrigger on CCR object
*********************************************************************************/
public class CCRTriggerHandler {
    
    public static String CCR_CUSTOMER_NOTIFICATION_TEMPLATE =  Label.CCRCustomerNotificationTemplate;
    public static String CCR_CLOSED_NOTIFICATION_TEMPLATE =  Label.CCRCustomerClosedNotificationTemplate;
    public static String CCR_CUSTOMER_PERMISSION_SET = Label.CCRCustomerPermissionSet;
    public static String CCR_STATUS_CLOSED = Label.CCRStatusClosed;
    public static String OWE_SUPPORT_SERVICES = Label.CCRCustomerEmailDispName;
    
    //This is to prevent retriggering of the trigger after a field update
    public static boolean isBeforeUpdateFired = FALSE;
    
    /**
	* Method called on after update event on the trigger
	*/
    public static void handleBeforeUpdate(Map<Id, CCR__c> MapOfNewCCR, Map<Id, CCR__c> MapOfOldCCR)
    {
        //Do not run again if already run once in this execution context.
        if(isBeforeUpdateFired)
        return;    
        
        Set<Id> setOfCCRIdsWithVisibilityChange = new Set<Id>();
        Set<Id> setOfCCRIdsClosed = new Set<Id>();
        //Iterate through and collect the CCRs to be processed
        for(Id ccrId : MapOfNewCCR.keySet())
        {
            CCR__c oldCCR =  MapOfOldCCR.get(ccrId);
            CCR__c newCCR =  MapOfNewCCR.get(ccrId);                
            
            //Check if visible to customer
            if(newCCR.Visible_to_Customer__c)
            {
                //Check if visible to customer flag has changed
                if(!oldCCR.Visible_to_Customer__c)
                {
                    //Validate if this is associated to a site with a customer
                    //and that a notification was not sent previously
                    if(!String.isBlank(newCCR.AccountNameSharingRule__c)
                       && newCCR.CCRCustomerNotificationDate__c == null)
                    {
                        setOfCCRIdsWithVisibilityChange.add(newCCR.id);
                    }
                }
                
                //Check if status changed to closed
                if(oldCCR.Status__c != newCCR.Status__c && newCCR.Status__c == CCR_STATUS_CLOSED
                   && oldCCR.Date_Closed__c == NULL)
                {
                     setOfCCRIdsClosed.add(newCCR.id);
                }
            }
            
        }//for ends
        
        //Call appropriate methods to process the CCRs
        
        if(!setOfCCRIdsWithVisibilityChange.isEmpty())
            sendCCRSharedNotificationToCustomer(MapOfNewCCR,setOfCCRIdsWithVisibilityChange);
        
        if(!setOfCCRIdsClosed.isEmpty())
            sendCCRClosedNotificationToCustomer(MapOfNewCCR,setOfCCRIdsClosed);
        
        //Set the boolean to know that this trigger has fired
        isBeforeUpdateFired = true;
    }
    
    //This method will send the notification to customers that a CCR is available in the customer portal
    public static void sendCCRSharedNotificationToCustomer(Map<Id, CCR__c> MapOfNewCCR, Set<Id> setOfCCRIds)
    {
        try{
            
            //Create a relation between the ccr id its related contactIds(with the necessary permission set) in this map
            Map<id, List<Id>> mapOfCCRIdToContactIds = getCCRContacts(setOfCCRIds);
            
            if(!mapOfCCRIdToContactIds.isEmpty())
                sendCCRNotifications(mapOfCCRIdToContactIds,MapOfNewCCR,CCR_CUSTOMER_NOTIFICATION_TEMPLATE);
        }  
        
        catch(exception e)
        {
            ViasatLogHandler.Log(AtlasConstants.SF_ORG_NAME, ViasatLogHandler.SeverityTypeEXCEPTION,'CCRTriggerHandler: sendCCRCustomerNotification',e.getMessage());
        }
        
    }
    
    //This method will send a notification to the customers that a CCR available in the customer portal has been closed 
    public static void sendCCRClosedNotificationToCustomer(Map<Id, CCR__c> MapOfNewCCR, Set<Id> setOfCCRIds)
    {
        try{
            
            //Create a relation between the ccr id its related contactIds(with the necessary permission set) in this map
            System.debug('************* setOfCCRIds: ' + setOfCCRIds);
            Map<id, List<Id>> mapOfCCRIdToContactIds = getCCRContacts(setOfCCRIds);
            
            System.debug('************* mapOfCCRIdToContactIds: ' + mapOfCCRIdToContactIds);
            
            
            if(!mapOfCCRIdToContactIds.isEmpty())
                sendCCRNotifications(mapOfCCRIdToContactIds,MapOfNewCCR,CCR_CLOSED_NOTIFICATION_TEMPLATE);
        }  
        
        catch(exception e)
        {
            ViasatLogHandler.Log(AtlasConstants.SF_ORG_NAME, ViasatLogHandler.SeverityTypeEXCEPTION,'CCRTriggerHandler: sendCCRClosedNotificationToCustomer',e.getMessage());
        }
        
    }
    
    //This method will return a map with CCR id as the key and the list of related contact ids (who have access to see the CCR) as the value
    //We figure out the users who should get the CCR Notification by using these conditions:
    //Should have the CCR Customer Portal permission assigned to them
    //They should be a related contact to one of the accounts related to the CCR via sites.
    
    public static Map<id, List<Id>> getCCRContacts(Set<Id> setOfCCRIds)
    {
       
        //Final map to be returned
        Map<id, List<Id>> mapOfCCRIdToContactIds = new Map<id, List<Id>>();
            
        
        //Do a query on the CCRSiteAssocation itself to get the Site Accounts
        List<CCRSiteAssociation__c> ccrAssnList = [select id, CCR__c, SiteNOC__c, SiteNOC__r.Account__c
                                                   from CCRSiteAssociation__c
                                                   where CCR__c IN: setOfCCRIds
                                                  ];
        
        
        //Create a relation between the CCR id its related AccountIds in this map
        Map<Id, List<Id>> mapOfCCRIdToAccIds = new Map<Id, List<Id>>();
        List<Id> listOfAccountIds = new List<Id>();
        for(CCRSiteAssociation__c ccrsiteassn : ccrAssnList)
        {
            if(mapOfCCRIdToAccIds.containsKey(ccrsiteassn.CCR__c))
            {
                mapOfCCRIdToAccIds.get(ccrsiteassn.CCR__c).add(ccrsiteassn.SiteNOC__r.Account__c);                    
            }
            else
            {
                List<Id> tempIdList = new List<Id>();
                tempIdList.add(ccrsiteassn.SiteNOC__r.Account__c);
                mapOfCCRIdToAccIds.put(ccrsiteassn.CCR__c, tempIdList);                    
            }
            listOfAccountIds.add(ccrsiteassn.SiteNOC__r.Account__c);
        }
        
        Map<id, List<Id>> mapOfAccIdtoListOfConIds = new Map<id, List<Id>>();
        
        //Query the permission set which gives CCR access to customer portal users
        PermissionSet p = [select id from PermissionSet where name = :CCR_CUSTOMER_PERMISSION_SET limit 1];
        
        Set<Id> userIds = new Set<Id>();
        
        //Get the list of portal user who belongs to accounts associated with the CCR
        Map<Id,User> mapOfUsers = new Map<Id,User>([select id, contactId, accountId from User where AccountId IN:listOfAccountIds]);
        
        List<Id> contactIds = new List<Id>();
        //Query for the permission set assignments to get the users who belongs to the accounts and has the permission set assigned to them
        for(PermissionSetAssignment permassign : [select AssigneeId, Assignee.Name, PermissionSet.Name from PermissionSetAssignment where PermissionSetid =: p.id and AssigneeId IN: mapOfUsers.keySet()])
        {
            contactIds.add(mapOfUsers.get(permassign.AssigneeId).contactId);
            
            Id accId = mapOfUsers.get(permassign.AssigneeId).accountId;
            Id conId = mapOfUsers.get(permassign.AssigneeId).contactId;
            
            if(mapOfAccIdtoListOfConIds.containsKey(accId))
            {
                mapOfAccIdtoListOfConIds.get(accId).add(conId);
            }
            else
            {
                List<Id> tempIdList = new List<Id>();
                tempIdList.add(conId);
                mapOfAccIdtoListOfConIds.put(accId, tempIdList);
            }            
        }
        
        if(!mapOfAccIdtoListOfConIds.isEmpty())
        {
            for(Id ccrId : setOfCCRIds)
            {
                List<Id> listOfContactIds = new List<Id>();
                
                for(Id accId : mapOfCCRIdToAccIds.get(ccrId))
                {
                    if(mapOfAccIdtoListOfConIds.containsKey(accId))
                    {
                        listOfContactIds.addAll(mapOfAccIdtoListOfConIds.get(accId));
                    }
                }
                
                mapOfCCRIdToContactIds.put(ccrId, listOfContactIds);
            }               
        }
        return mapOfCCRIdToContactIds;
        
    }
    
    //This method is used to send the notifications
    public static void sendCCRNotifications(Map<id, List<Id>> mapOfCCRIdToContactIds, Map<Id, CCR__c> MapOfNewCCR, String templateName)
    {
        List<Messaging.SingleEmailMessage> allMails = new List<Messaging.SingleEmailMessage>();
        EmailTemplate template =  [SELECT Id, Name FROM EmailTemplate WHERE DeveloperName = :templateName LIMIT 1];
        //OrgWideEmailAddress  owe = [select id from OrgWideEmailAddress  where DisplayName = :OWE_SUPPORT_SERVICES limit 1];            
            for(Id ccrId:  mapOfCCRIdToContactIds.keySet())
            {
                for(Id conId: mapOfCCRIdToContactIds.get(ccrId))
                {
                    Messaging.SingleEmailMessage email=new Messaging.SingleEmailMessage(); 
                    email.setTargetObjectId(conId);
                    email.setTemplateId(template.Id);
                    email.setSaveAsActivity(true);                
                    email.setWhatId(ccrId);
                    //email.setOrgWideEmailAddressId(owe.id);
                    email.setSenderDisplayName(OWE_SUPPORT_SERVICES);
                    allMails.add(email);
                }
                System.debug('************** ccrId : '  + ccrId);
                
                if(templateName == CCR_CUSTOMER_NOTIFICATION_TEMPLATE)
                MapOfNewCCR.get(ccrId).CCRCustomerNotificationDate__c = System.Now(); 
                
            }
            Messaging.SendEmail(allMails); 
    }
    
    
}