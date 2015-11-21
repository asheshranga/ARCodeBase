/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an organization are executed whenever Apex code is deployed
 * to a production organization to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production organization. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the organization size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
@isTest
private class CCRControllersTest 
{
    static private list<CCR__c> createData() 
    { 
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
        return ccrs;
    }
    
    static testmethod void testCCRCreateCaseController() 
    { 
        //Oct 15 commenting out since the controller logic has changed and the test method migrated to a separate class
     /*   CCR__c testCCR = createData()[0];

        Site__c testSite = new Site__c(SiteName__c='SiteNameCCRCaseCreateController');
        insert testSite;

        Case testCase = [SELECT Id FROM Case LIMIT 1];
       
        Test.startTest();

        // CCR missing site
        Apexpages.currentPage().getParameters().put('id',testCCR.id);       
        CCRCreateCaseController controller = new CCRCreateCaseController(new ApexPages.StandardController(testCCR));
        controller.createCase(); 
        
        //insert custom setting
        CarlsbadNOCKeyValueStore__c kvs = new CarlsbadNOCKeyValueStore__c();
        kvs.Name = 'CCRClosedTaskStatusList';
        kvs.Value__c = 'test';
        insert kvs;
        
        CCRSiteAssociation__c testCSA = new CCRSiteAssociation__c(ccr__c = testCCR.id, siteNOC__c = testSite.id);
        insert testCSA;
           
        // Instantiate a new controller with all parameters in the page
        // CCR with all required elements present     
        controller = new CCRCreateCaseController(new ApexPages.StandardController(testCCR));
        controller.createCase();      

        // CCR with Case already created (to test page refresh) 
        Apexpages.currentPage().getParameters().put('CaseId',testCase.id);     
        controller = new CCRCreateCaseController(new ApexPages.StandardController(testCCR));
        controller.createCase();  
       
        // CCR with invalid Case already created (to test page refresh with error)  
        Apexpages.currentPage().getParameters().put('CaseId','abcdefghijklmno');     
        controller = new CCRCreateCaseController(new ApexPages.StandardController(testCCR));
        controller.createCase();
    
        Test.stopTest();  */   
    }   

    
    static testmethod void testCCRSearchController() 
    {   
        CCR__c ccr = createData()[0];
    
        Test.startTest();
    
        // Instantiate a new controller with all parameters in the page
        CCRSearchController controller = new CCRSearchController();
        String lsSQL = controller.debugSoql;
        
        Map<String,Schema.RecordTypeInfo> rtMapByName = Schema.SObjectType.CCR__c.getRecordTypeInfosByName();
		
        CarlsbadNOCKeyValueStore__c cs = new CarlsbadNOCKeyValueStore__c();
        cs.Name = CCRSearchController.CCR_RT_AVL_FOR_SEARCH;
        for(String s: rtMapByName.keySet())
        cs.Value__c = s;
        insert cs;
            
		System.assert(!controller.recordTypes.isEmpty());
        
        MultiselectController compController = new MultiselectController();
        controller.setComponentController(compController);
        compController.leftOptions = new list<SelectOption>();
        compController.rightOptions = new list<SelectOption>();
        SelectOption[] so = compController.selectedOptions;
        compController.leftOptionsHidden = 'New';
        compController.rightOptionsHidden = 'Closed&Canceled';
        compController.pageController = controller;
      
        PageReference pageRef = Page.CCRSearch;
        Test.setCurrentPageReference(pageRef);
        Apexpages.currentPage().getParameters().put('name','success');
        Apexpages.currentPage().getParameters().put('subject','success');
        Apexpages.currentPage().getParameters().put('statussel','open');
        Apexpages.currentPage().getParameters().put('owner','success');
        Apexpages.currentPage().getParameters().put('requestor','success');
        Apexpages.currentPage().getParameters().put('sitenum','3');
        Apexpages.currentPage().getParameters().put('siteAltName','123');    
        Apexpages.currentPage().getParameters().put('casenum','9');
        Apexpages.currentPage().getParameters().put('account','success');
        Apexpages.currentPage().getParameters().put('product','success');
        Apexpages.currentPage().getParameters().put('urgencysel','success');
        Apexpages.currentPage().getParameters().put('severitysel','success');
    
        controller.toggleSort();
        controller.runSearch();
    
        String lsOut=null;
        List<String> loString=null;
    
        controller.runQuery();      
    
        lsOut = controller.soql;
        String lsDir = controller.sortDir;
        String lsField = controller.sortField;        
    
        lsSQL = controller.debugSoql;       

        List<CCR__c> c = controller.getCCRs();
        Integer s = controller.resultSize;
        Boolean p = controller.hasNext;
        Boolean n = controller.hasPrev;
        String r = controller.recordInfo;
        String p1 = controller.pageInfo;
    
        CCR__c cObj = controller.dummyCCR;
        List<CCR__c> ccrList = controller.ccrs;
        List<CCRSiteAssociation__c> siteList = controller.associations;
        Map<Id, Long> siteMap = controller.siteCountMap;
        Map<Id, Long> caseMap = controller.caseCountMap;
        
        controller.next();
        controller.previous();
        controller.last();
        controller.first();

        PageReference pg = controller.clearSearch();
        controller.getPageCont();

        Test.stopTest();
    }
    
    static testmethod void testCCRSiteAssociationController() 
    {    
        CCR__c tstCCR = createData()[0];
    
        Test.startTest();
        
        PageReference pageRef = Page.CCRSiteAssociation;
        Test.setCurrentPageReference(pageRef);
        Apexpages.currentPage().getParameters().put('ccr',tstCCR.Id);
    
        Apexpages.currentPage().getParameters().put('name','10');
        Apexpages.currentPage().getParameters().put('product','7');
        Apexpages.currentPage().getParameters().put('account','7');
        Apexpages.currentPage().getParameters().put('search','10');
        Apexpages.currentPage().getParameters().put('alertnatename','1');

        // Instantiate a new controller with all parameters in the page
        CCRSiteAssociationController controller = new CCRSiteAssociationController();

        String lsSQL = controller.debugSoql;
    
        List<String> loString = controller.types;
        controller.toggleSort();

        controller.runSearch();

        controller.cancelAction();
    
        delete tstCCR;
    
        Test.stopTest();    
    }

    static testmethod void testCCRSiteAssociationController2() 
    {
        CCR__c tstCCR = createData()[0];
    
        Test.startTest();

        PageReference pageRef = Page.CCRSiteAssociation;
        Test.setCurrentPageReference(pageRef);
        Apexpages.currentPage().getParameters().put('ccr',tstCCR.Id);
    
        // Instantiate a new controller with all parameters in the page
        CCRSiteAssociationController controller = new CCRSiteAssociationController();
    
        String lsOut=null;
        List<String> loString=null;
    
        //controller.soql = 'select recordtypeid, id, name, flag__c, status__c, account__r.id, account__r.name, product__r.id, product__r.name, creationdate__c, deactivationdate__c, activationdate__c, AlternateSiteNames__c, ' +
        //       '       (select name, tailnumber__c, make__c, model__c, satelliteip__c from site__c.Aviation__r) ' +
        //       '  from site_c ';
    
        controller.runQuery();      
    
        lsOut = controller.soql;
        String lsDir = controller.sortDir;
        String lsField = controller.sortField;  
        String lsLimit = controller.soqlLimit;      
        String lsSQL = controller.debugSoql;
    
        controller.setCon = null;
        ApexPages.StandardSetController pg = controller.setCon;
   
        Integer s = controller.resultSize;
        Boolean p = controller.hasNext;
        Boolean n = controller.hasPrev;
        String r = controller.recordInfo;
        String p1 = controller.pageInfo;
   
        controller.next();
        controller.previous();
        controller.last();
        controller.first();
     
        delete tstCCR;    
        Test.stopTest();    
    } 
  
    static testmethod void testToggleCheckedSites() 
    {    
        CCR__c tstCCR = createData()[0];
    
        Test.startTest();
    
        PageReference pageRef = Page.CCRSiteAssociation;
        Test.setCurrentPageReference(pageRef);
        Apexpages.currentPage().getParameters().put('ccr',tstCCR.Id);   
        Apexpages.currentPage().getParameters().put('selectAll','true');
    
        CCRSiteAssociationController controller = new CCRSiteAssociationController();
        controller.toggleCheckedSites();
    
        Apexpages.currentPage().getParameters().put('selectAll','false');
        controller.toggleCheckedSites();
    
        List<CCRSiteAssociationController.siteWrapper> lsList = controller.siteSearchResults;
    
        //If nothing is checked
        controller.addSiteToCCR();
    
        if(lsList.size() > 0) {
        CCRSiteAssociationController.siteWrapper sw = controller.siteSearchResults.get(0);
        sw.checked = true;
        controller.siteSearchResults.set(0,sw);
        }
    
        delete tstCCR; 
    
        //Testing if else case
        //If Messages are empty
        controller.addSiteToCCR();
    
        //delete tstCCR; 
        //If messages are not empty
        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'Test! '));
        controller.addSiteToCCR();
  
        //  testsiteWrapper
        // Instantiate a new controller with all parameters in the page
        CCRSiteAssociationController.siteWrapper controller1 = new CCRSiteAssociationController.siteWrapper();
        Boolean checkedTest1 = controller1.checked;
        Site__c siteTest1 = controller1.site;

        Test.stopTest();    
    }   

    static testmethod void testCCRFindDetailsforMailController() 
    {
        CCR__c ccr = createData()[0];
    
        // Instantiate a new controller with all parameters in the page
        CCRFindDetailsforMailController c = new CCRFindDetailsforMailController();
        c.CCR = ccr.Id; //'a0M70000005zVB4EAM';
        String caseList = c.cases;
        String siteList = c.sites;
    } 

    static testMethod void testCCRUpdateTaskController1() 
    {
        // create user
        User user1 = ViasatTestUtility.createInsertUser(null, 'Carlsbad NOC Manager');
        
        //insert custom setting
        CarlsbadNOCKeyValueStore__c kvs = new CarlsbadNOCKeyValueStore__c();
        kvs.Name = 'CCRClosedTaskStatusList';
        kvs.Value__c = 'test';
        insert kvs;
        CarlsbadNOCKeyValueStore__c kvs1 = new CarlsbadNOCKeyValueStore__c();
        kvs1.Name = 'CCRTaskStatusListToSendEmail';
        kvs1.Value__c = 'New';
        insert kvs1;
        
        // create CCR
        CCR__c c1 = createData()[0];
        c1.RequestedBy__c = user1.id;
        update c1;      
        
        // create CCR Task
        RecordType rt = [SELECT Id FROM RecordType WHERE SObjectType='Task' AND Name='CCR' LIMIT 1];                   
        Task t1 = new Task(OwnerId= user1.Id, whatid=c1.Id, Status = 'Not Started', Priority = 'Normal',
                           Subject = 'Subject', RecordTypeId=rt.id, ActivityDate=System.Today(), Area_s_To_Be_Reviewed__c='Business;Implementation');
        insert t1;        
            
        Test.startTest();
                     
        ApexPages.Standardcontroller controller = new ApexPages.Standardcontroller(t1);
        CCRUpdateTaskController ccruC = new  CCRUpdateTaskController(controller); // error user not matching.
       
        System.runAs(user1)
        {
            ccruC = new  CCRUpdateTaskController(controller);   
            
            List<SelectOption> types = ccruC.getTypes();
            ccruC.selectedType= 'Information Required'; 
            
            List<SelectOption> statuses = ccruC.getStatus();
            ccruC.selectedStatus = 'In Progress';
            
            List<SelectOption> priorities = ccruC.getPriorities();
            ccruC.selectedPriority = 'Low';
            
            List<SelectOption> subjects = ccruC.getSubject();
            ccruC.selectedSubject = 'Send Letter';
                
            ccruC.UpdateTask();
            
            Task updatedT1 = [select type, status, priority, subject from Task where id = :t1.id];
            
            System.AssertEquals('Information Required', updatedT1.type);
            System.AssertEquals('In Progress', updatedT1.status);
            System.AssertEquals('Low', updatedT1.priority);
            System.AssertEquals('Send Letter', updatedT1.subject);
            
            ccruC.Cancel();
        }   
        
        // Multi Select Controller
        MultiselectController msC = new  MultiselectController(); 
        
        msC.leftOptions = new list<SelectOption>();
        msC.rightOptions = new list<SelectOption>();
            
        msC.leftOptionsHidden = 'option1&option2&option3';
        msc.rightOptionsHidden = 'option4';
        
        Test.stopTest();           
    }
}