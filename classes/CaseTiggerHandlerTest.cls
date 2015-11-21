//to be deleted
@isTest
private class CaseTiggerHandlerTest {

   /* static testmethod void testCaseTriggerHandler()
    {
        ViasatTestUtility.setNBNCoKeyvalueStore();
		ViasatTestUtility.setGlobals();
		ViasatTestUtility.setCaseKeyValueStore();
        
        list<Account> accounts = ViasatTestUtility.createAccounts(1, 'Test Acc');
		insert accounts; 
		list<Contact> contacts = ViasatTestUtility.createContacts(accounts, 2); // two contacts for account
		insert contacts; 
		
		// Create two 'Carlsbad NOC' Cases 
		list<Case> lstcase = ViasatTestUtility.createCases(accounts, contacts, 'Carlsbad NOC');
		insert lstcase;
        
        System.assertEquals(lstcase.size(),2);

		Test.startTest();  
        
        Set<Id> setOfCaseIds = new Set<Id>();
        
        User u = [select id from User where profileId =: UserInfo.getProfileId() and id != :UserInfo.getUserId() limit 1];
        
        for(Case c: lstcase)
        {
            c.status = 'On Hold';            
            setOfCaseIds.add(c.id);
        }
        update lstcase;
        
        for(Case c: lstcase)
        {
            c.status = 'Working';
        }
        update lstcase;
        
        for(Case c: lstcase)
        {
            c.ownerId = u.id;            
        }
        update lstcase;
        
        List<StatusDetail__c> statDetList = [Select id,TotalTimeInHrs__c,LastModifiedDate,Case__c,ObjectType__c,Status__c,EntryTime__c,ExitTime__c
                                      from StatusDetail__c
                                      where Case__c IN :setOfCaseIds];
        
        List<Case_Owner_History__c> ownerHistList = new List<Case_Owner_History__c>();
        ownerHistList = [select id, Exittime__c from Case_Owner_History__c where case__c IN: setOfCaseIds];
        
                                          
        System.assert(!statDetList.isEmpty());
        System.assert(!ownerHistList.isEmpty());
        
        Test.stopTest();
    }*/
}