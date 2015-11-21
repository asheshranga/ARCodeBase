@isTest
private class CaseOwnerHistoryUtilityTest {

     static testmethod void testCaseOwnerHistory()
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
        
        User u = [select id from User where Tier__c != null limit 1];
        
        QueueSobject qso = [select id, Queue.DeveloperName, QueueId from QueueSobject where SobjectType = 'Case' limit 1];
        
        //Group grp = [select id, Name, developerName from Group limit 1];
        
        CaseQueueTierMap__c cs = new CaseQueueTierMap__c();
        cs.name = qso.Queue.DeveloperName;
        cs.Tier__c = 'Tier 1';
        insert cs;
        
        for(Case c: lstcase)
        {
            c.ownerId = u.id;  
            setOfCaseIds.add(c.id);
        }
        update lstcase;
        
        for(Case c: lstcase)
        {
            c.ownerId = qso.QueueId;            
        }
        update lstcase;
        
        
        List<Case_Owner_History__c> ownerHistList = new List<Case_Owner_History__c>();
        ownerHistList = [select id, Exittime__c from Case_Owner_History__c where case__c IN: setOfCaseIds];
        
                                          
        System.assert(!ownerHistList.isEmpty());
        
        Test.stopTest();
    }
}