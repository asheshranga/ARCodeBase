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
@IsTest
public with sharing class  SiteControllersTest 
{
    static private void createData() 
    {
		CCR__c testCCR = new CCR__c(subject__c='test', status__c='new',urgency__c='Immediate', severity__c='Medium', estimatedoutage__c='00:30');
		insert testCCR;

		Site__c testSite = new Site__c();
		testSite.SiteName__c='TestSITE';
		insert testSite;

		//Apexpages.currentPage().getParameters().put('id',testCCR.id);       
		//CCRCreateCaseController ccrcontroller = new CCRCreateCaseController(new ApexPages.StandardController(testCCR));
		//ccrcontroller.createCase(); 

        //insert custom setting
        CarlsbadNOCKeyValueStore__c kvs = new CarlsbadNOCKeyValueStore__c();
        kvs.Name = 'CCRClosedTaskStatusList';
        kvs.Value__c = 'test';
        insert kvs;
        
		CCRSiteAssociation__c testCSA = new CCRSiteAssociation__c(ccr__c = testCCR.id, siteNOC__c = testSite.id);
		insert testCSA;
           
		// Instantiate a new controller with all parameters in the page
		// CCR with all required elements present     
		//ccrcontroller = new CCRCreateCaseController(new ApexPages.StandardController(testCCR));
		//ccrcontroller.createCase();      
		//ITSMSKeyValueStore__c k = new ITSMSKeyValueStore__c();
        //k.name = 'CaseRecordType';
        //k.Value1__c = 'ITSMS - General';   
        //insert k;
		Case testCase = new Case();
		insert testCase;
    }

//SELECT recordtypeid, id, name, flag__c, SiteName__c, status__c, account__r.id, account__r.name, product__r.id, product__r.name, creationdate__c, AlternateSiteNames__c,'+
//tailnumber__c, make__c, model__c, satelliteip__c,Serial__c FROM site__c 
    static testMethod void SiteRegisterControllerTest() 
    {
    	createData();
    	
        SiteRegisterController controller = new SiteRegisterController();
        controller.username = 'test@force.com';
        controller.email = 'test@force.com';
        controller.communityNickname = 'test';
        // registerUser will always return null when the page isn't accessed as a guest user
        System.assert(controller.registerUser() == null);    
        
        controller.password = 'abcd1234';
        controller.confirmPassword = 'abcd123';
        System.assert(controller.registerUser() == null);  
    }
    
    static testMethod void SiteLoginControllerTest () 
    {
    	createData();

		RecordType agSiteRecordType=[SELECT Id,Name FROM RecordType WHERE SObjectType = 'Site__c' AND recordType.name='Aviation-General'];
		Site__c aviationGeneralSite = new Site__c();
		aviationGeneralSite.SiteName__c='aviationGeneralSite';
		aviationGeneralSite.RecordTypeId = agSiteRecordType.id;
		insert aviationGeneralSite;
    	
		Test.startTest();

        // Instantiate a new controller with all parameters in the page
        SiteLoginController controller = new SiteLoginController ();
        controller.username = 'test@salesforce.com';
        controller.password = '123456'; 

		// Test trigger after
		list<Site__c> sites = [select id,VisibleToManufacturer__c from Site__c where id =: aviationGeneralSite.id];
		sites[0].VisibleToManufacturer__c = !sites[0].VisibleToManufacturer__c;
		update sites;
                
        System.assertEquals(controller.login(),null);
        Test.stopTest();                           
    }    

    static testMethod void testSiteSearchController1() 
    {
		createData();
		       
		Test.startTest();

        PageReference pageRef = Page.ViaSite;
        Test.setCurrentPageReference(pageRef);
        Apexpages.currentPage().getParameters().put('name','TestSITE');
        Apexpages.currentPage().getParameters().put('product','success');
        Apexpages.currentPage().getParameters().put('account','open');
        Apexpages.currentPage().getParameters().put('search','128');
        Apexpages.currentPage().getParameters().put('alertnatename','success');

        // Instantiate a new controller with all parameters in the page
        SiteSearchController controller = new SiteSearchController();
        controller.runSearch();

        String lsSQL = controller.debugSoql;
        List<String> loString = controller.types;
        controller.toggleSort();
    
		List<site__c> c = controller.getSites();
        Integer s = controller.resultSize;
        Boolean p = controller.hasNext;
        Boolean n = controller.hasPrev;
        String r = controller.recordInfo;
        String p1 = controller.pageInfo;

        controller.next();
        controller.previous();
        controller.last();
        controller.first();
        
        Test.stopTest();
    }    

    static testMethod void testSiteSearchController() 
    {
		createData();

		Test.startTest();

        PageReference pageRef = Page.ViaSite;
        Test.setCurrentPageReference(pageRef);
        Apexpages.currentPage().getParameters().put('RecordType','Aviation-General');
        Apexpages.currentPage().getParameters().put('name','test');
        Apexpages.currentPage().getParameters().put('product','test');
        Apexpages.currentPage().getParameters().put('account','test');
        Apexpages.currentPage().getParameters().put('ipAddress','test');
        SiteSearchController controller = new SiteSearchController();
        controller.runSearch();

        String lsOut=null;
        List<String> loString=null;

        controller.runQuery();      
        String lsDir = controller.sortDir;
        String lsField = controller.sortField;
        String lsLimit = controller.soqlLimit;        
        String lsSQL = controller.debugSoql;  
        boolean b = controller.selectRecordType;
        string s = controller.siteId;  
        s = controller.rType;   
        List<Site__c> st = controller.sites;
        
        Test.stopTest();
    }     
}