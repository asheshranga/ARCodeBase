/*********************************************************************************
Name         : CCRSiteAssociationTriggerHandler
Created By   : Anand Sanjeev
Company Name : Slalom Consulting
Created Date : 08/21/2015
Modified Date: 
Usages       : Handle class for the trigger CCRSiteAssociationTrigger on CCRSiteAssociation objec
*********************************************************************************/
public class CCRSiteAssociationTriggerHandler {
    
    /**
	* Method called on after insert events on the trigger
	*/
    public static void handleAfterInsert(Map<Id,CCRSiteAssociation__c> MapOfCCRSites)
    {
       updateCCRAccountNames(MapOfCCRSites.values());  
    }
    
    /**
	* Method called on after delete events on the trigger
	*/
    public static void handleAfterDelete(Map<Id,CCRSiteAssociation__c> MapOfCCRSites)
    {
       updateCCRAccountNames(MapOfCCRSites.values()); 
    }
    
    /**
	* Method called to update the account name field on CCR
	* Iterate through the CCRSiteAssociation records and get all the accounts names and
	* use that to update the account name field on CCR.
	*/
    public static void updateCCRAccountNames(List<CCRSiteAssociation__c> listOfCCRSites)
    {
        try{
        List<Id> listOfCCRIds = new List<Id>();
        
        //Collect ids of the related CCRs
        for(CCRSiteAssociation__c c : listOfCCRSites)
        {
            listOfCCRIds.add(c.CCR__c);
        }
        
        //Query related CCRs
        Map<Id, CCR__c> ccrMap =  new Map<Id, CCR__c>([Select id, AccountNameSharingRule__c
                                                       from CCR__c
                                                       where Id IN: listOfCCRIds]);
        
        //Do another query on the CCRSiteAssocation itself to get the Site Account Names
        List<CCRSiteAssociation__c> ccrAssnList = [select id, CCR__c, SiteNOC__c, SiteNOC__r.Account__c, SiteNOC__r.Account__r.Name
                                                   from CCRSiteAssociation__c
                                                   where CCR__c IN: listOfCCRIds and IsDeleted = false
                                                   order by SiteNOC__r.Account__r.Name asc];
        
        Map<Id, CCR__c> mapOfCCRsToUpdate = new Map<Id, CCR__c>();
        
        //Iterate throught the CCRSiteAssocation records and update the account name field
        for(CCRSiteAssociation__c ccrSite: ccrAssnList)
        {     
            //9/18/15: Do not process if site not tied to an account
            if(ccrSite.SiteNOC__r.Account__c == null)
                continue;
            
            if(mapOfCCRsToUpdate.containsKey(ccrSite.CCR__c))
            {
                Set<String> namesAlreadyAdded = new Set<String>();
                
                namesAlreadyAdded.addAll(mapOfCCRsToUpdate.get(ccrSite.CCR__c).AccountNameSharingRule__c.split(';'));
                
                //Add the account name only if not already present.
                if(!namesAlreadyAdded.contains(ccrSite.SiteNOC__r.Account__r.Name))
                mapOfCCRsToUpdate.get(ccrSite.CCR__c).AccountNameSharingRule__c = mapOfCCRsToUpdate.get(ccrSite.CCR__c).AccountNameSharingRule__c + ';' + ccrSite.SiteNOC__r.Account__r.Name;
            }
            else
            {
                CCR__c c = ccrMap.get(ccrSite.CCR__c);
                c.AccountNameSharingRule__c = ccrSite.SiteNOC__r.Account__r.Name;
                //This is not needed anymore - this will be set manually
                //c.Visible_to_Customer__c = true;
                mapOfCCRsToUpdate.put(ccrSite.CCR__c, c);
            }
        }
            
        for(Id ccrId : listOfCCRIds)
        {
            if(!mapOfCCRsToUpdate.containsKey(ccrId))
            {
                CCR__c c =  new CCR__c();
                c.id = ccrId;
                c.AccountNameSharingRule__c = null;
                c.Visible_to_Customer__c = false;
                c.CCRCustomerNotificationDate__c = null;
                mapOfCCRsToUpdate.put(ccrId, c);
            }
        }
        
        //Update all CCR records
        update mapOfCCRsToUpdate.values();
        }
        
        Catch(Exception e){
            ViasatLogHandler.Log(AtlasConstants.SF_ORG_NAME, ViasatLogHandler.SeverityTypeEXCEPTION,'CCRSiteAssociationTriggerHandler: updateCCRAccountNames - updating account name field in CCR',e.getMessage());
        }           

    }
    
}