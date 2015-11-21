@isTest
private class CCRCreateCaseControllerTest {
    
    static void createTestData()
    {
        List<CarlsbadNOCKeyValueStore__c> listOfFields = new List<CarlsbadNOCKeyValueStore__c>();
        CarlsbadNOCKeyValueStore__c cs1 = new CarlsbadNOCKeyValueStore__c();
        cs1.name = 'CASE_ACCT_FIELD_ID';
        cs1.Value__c = 'xxx';
        listOfFields.add(cs1);
        
        CarlsbadNOCKeyValueStore__c cs2 = new CarlsbadNOCKeyValueStore__c();
        cs2.name = 'CASE_SITE_FIELD_ID';
        cs2.Value__c = 'xxx';
        listOfFields.add(cs2);
        
        CarlsbadNOCKeyValueStore__c cs3 = new CarlsbadNOCKeyValueStore__c();
        cs3.name = 'CASE_CCR_FIELD_ID';
        cs3.Value__c = 'xxx';
        listOfFields.add(cs3);
        
        CarlsbadNOCKeyValueStore__c cs4 = new CarlsbadNOCKeyValueStore__c();
        cs4.name = 'CASE_PRODUCT_FIELD_ID';
        cs4.Value__c = 'xxx';
        listOfFields.add(cs4);
        
        CarlsbadNOCKeyValueStore__c cs5 = new CarlsbadNOCKeyValueStore__c();
        cs5.name = 'CASE_VIS_TO_CUST_FIELD_ID';
        cs5.Value__c = 'xxx';
        listOfFields.add(cs5);
        
        CarlsbadNOCKeyValueStore__c cs6 = new CarlsbadNOCKeyValueStore__c();
        cs6.name = 'CASE_ORIGIN_FIELD_ID';
        cs6.Value__c = 'xxx';
        listOfFields.add(cs6);
        
        CarlsbadNOCKeyValueStore__c cs7 = new CarlsbadNOCKeyValueStore__c();
        cs7.name = 'CASE_SUB_FIELD_ID';
        cs7.Value__c = 'xxx';
        listOfFields.add(cs7);
        
        CarlsbadNOCKeyValueStore__c cs8 = new CarlsbadNOCKeyValueStore__c();
        cs8.name = 'CASE_DESC_FIELD_ID';
        cs8.Value__c = 'xxx';
        listOfFields.add(cs8);
        
        CarlsbadNOCKeyValueStore__c cs9 = new CarlsbadNOCKeyValueStore__c();
        cs9.name = 'CASE_VIS_TO_CUST_FIELD_DEF_VAL';
        cs9.Value__c = 'No';
        listOfFields.add(cs9);
        
        CarlsbadNOCKeyValueStore__c cs10 = new CarlsbadNOCKeyValueStore__c();
        cs10.name = 'CASE_ORIGIN_FIELD_DEF_VAL';
        cs10.Value__c = 'Origin';
        listOfFields.add(cs10);
        
        insert listOfFields;
        
        CarlsbadNOCKeyValueStore__c kvs = new CarlsbadNOCKeyValueStore__c();
        kvs.Name = 'CCRClosedTaskStatusList';
        kvs.Value__c = 'test';
        insert kvs;
        
        ViasatTestUtility.setCaseKeyValueStore(); 
             
        List<Account> accounts = ViasatTestUtility.createAccounts(1, 'testAcc');
        insert accounts;

        List<Contact> contacts = ViasatTestUtility.createContacts(accounts, 1);
        insert contacts; 

        List<Case> cases = ViasatTestUtility.createCases(accounts, contacts, null);                       
        insert cases;                     

        CCR__c[] ccrs = new CCR__c[]{
            new CCR__c(subject__c='test', status__c='New',urgency__c='Immediate', severity__c='Medium', estimatedoutage__c='00:30'),
            new CCR__c(subject__c='Test', status__c='New',urgency__c='Immediate', Severity__c ='Low',
                       Description__c ='Test',SuccessCriteria__c ='Test',RollbackCriteria__c ='Test',RiskLevel__c = 'High',RiskDescription__c = 'Test',RiskMitigation__c='Test',
                       Pre_Checks__c= 'Test',Pre_Backup__c = 'Test',Main_Work__c = 'Test',Backout__c = 'Test',Post_Checks__c = 'Test',Post_Backup__c = 'Test',     
                       EstimatedVisibilityOutage__c = '0:35',OutageDescription__c ='Test',Customer_Maintenance_Notice_Required__c = 'Yes',Smart_Hands_Required__c = 'Yes',CustomerPOCInfo__c = 'Test',
                       estimatedoutage__c='00:20')          
            };
        insert ccrs;
       
    }
    
    static testmethod void testWithoutSiteAssociation()
    {
        createTestData();
        Test.startTest();
        CCR__c testCCR = [select id from CCR__c limit 1];        
        Apexpages.currentPage().getParameters().put('id',testCCR.id);       
        CCRCreateCaseController controller = new CCRCreateCaseController(new ApexPages.StandardController(testCCR));
        PageReference pg = controller.redirect();
        //Since no site added
        System.assert(pg == null);
        Test.stopTest();
   
    }
    static testmethod void testWithSiteAssociation()
    {
        createTestData();
        CCR__c testCCR = [select id from CCR__c limit 1];       
        
        Site__c testSite = new Site__c();
		testSite.SiteName__c='TestSITE';
		insert testSite;
        
        CCRSiteAssociation__c cass = new CCRSiteAssociation__c();
        cass.CCR__c = testCCR.id;
        cass.SiteNOC__c  = testSite.id;
        insert cass;
        Test.startTest();
        Apexpages.currentPage().getParameters().put('id',testCCR.id);       
        CCRCreateCaseController controller = new CCRCreateCaseController(new ApexPages.StandardController(testCCR));
        PageReference pg = controller.redirect();
        //Since no site added
        System.assert(pg != null);
        Test.stopTest();
    }

}