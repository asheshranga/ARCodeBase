@isTest
private class CaseStatusTrackingUtilityTest {
    
   static testmethod void testCaseStatusTrackingUtility()
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
           
        CaseKeyValueStore__c ccs = new CaseKeyValueStore__c();
        ccs.name = CaseStatusTrackingUtility.ITSMS_RT_NAME;
        ccs.value__c = 'Not Started';
        insert ccs;

		Test.startTest();  
        
        Set<Id> setOfCaseIds = new Set<Id>();
        
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
            c.status = 'Closed';
            c.ResolutionDescription__c = 'tes';
        }
        update lstcase;
        
        
        
        List<StatusDetail__c> statDetList = [Select id,TotalTimeInHrs__c,LastModifiedDate,Case__c,ObjectType__c,Status__c,EntryTime__c,ExitTime__c
                                      from StatusDetail__c
                                      where Case__c IN :setOfCaseIds];
                                         
        System.assert(!statDetList.isEmpty());
        
        Test.stopTest();
    }
    
    static testmethod void testStatusSpecificTrackingFields()
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
        for(Case c: lstcase)
        {
            c.status = 'On Hold';            
            setOfCaseIds.add(c.id);
        }
        update lstcase;
        
        List<LaborHour__c> laborList = new List<LaborHour__c>();
        
        for(Case c: lstcase)
        {
            LaborHour__c l = new LaborHour__c();
            l.Case__c = c.id;
            l.StartTime__c = System.now()-1;
            l.StopTime__c = System.now();
            l.User__c = UserInfo.getUserId();
            laborList.add(l);
        }
        insert laborList;
        
        
        for(Case c: lstcase)
        {
            c.status = CaseStatusTrackingUtility.RESOLVED; 
            c.ResolutionDescription__c = 'Test Resolution';
            setOfCaseIds.add(c.id);
        }
        update lstcase;
        
        for(Case c: lstcase)
        {
            c.status = 'Closed';            
            
        }
        update lstcase;
        
        for(Case c: lstcase)
        {
            c.status = CaseStatusTrackingUtility.CANCELLED;            
            
        }
        update lstcase;
        
        List<Case> caseList = new List<Case>();
        
        caseList = [select id, FirstResolution__c, FirstResolutionSetBy__c, LastResolution__c, LastResolutionSetBy__c, FirstClosure__c, FirstClosureSetBy__c,
                   LastClosure__c, LastClosureSetBy__c, FirstCancelled__c, FirstCancelledSetBy__c from case where id IN :setOfCaseIds ];
        
        for(Case c: caseList)
        {
            System.assertNotEquals(c.FirstResolution__c, null);
            System.assertNotEquals(c.FirstResolutionSetBy__c, null);
            System.assertNotEquals(c.LastResolution__c, null);
            System.assertNotEquals(c.LastResolutionSetBy__c, null);
            System.assertNotEquals(c.FirstClosure__c, null);
            System.assertNotEquals(c.FirstClosureSetBy__c, null);
            System.assertNotEquals(c.LastClosure__c, null);
            System.assertNotEquals(c.LastClosureSetBy__c, null);
            System.assertNotEquals(c.FirstCancelled__c, null);
            System.assertNotEquals(c.FirstCancelledSetBy__c, null);
        }
        
        Test.stopTest();
        
    }    
}