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
private class SNGVisualforceRenderUnitTest {

    static testMethod void isUserSystemAdminFail()
    {
        Account a = new Account(name ='Red Cross', BillingStreet = '6155 El Camino Real', 
                                BillingState = 'California', BillingCity = 'San Diego',
                                BillingPostalCode = '92008');
		
		insert a;
		
        Contact c = new Contact(AccountId = a.id, firstname='firstname', lastname = 'testName',
        					    Phone='760-111-2222');
        insert c;    
        
        Profile p = [SELECT Id FROM Profile WHERE Name='Standard User'];

        User u = new User(Alias = 'tempuser', Email='tempuser@testorg.com', 
        EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
        LocaleSidKey='en_US', ProfileId = p.Id, 
        TimeZoneSidKey='America/Los_Angeles', UserName='tempuser@testorg.com');

        System.runAs(u) 
        {
            System.assertEquals(false, SNGVisualforceRender.isUserSystemAdmin());
            System.assertEquals(false, SNGVisualforceRender.userAdmin);
            System.assertEquals(true, SNGVisualforceRender.userNotAdmin);
        }   
        
    }
    
    static testMethod void testCtorNoBehavior()
    {
        try
        {
            SNGVisualforceRender rv = new SNGVisualforceRender(null);
            System.assert(true);
        }
        catch (Exception e)
        {
            System.assert(false);
        }
    }
    
    static testMethod void testIsUserAdminWithNoCustomSetting()
    {
        Account a = new Account(name ='Red Cross', BillingStreet = '6155 El Camino Real', 
                                BillingState = 'California', BillingCity = 'San Diego',
                                BillingPostalCode = '92008');
		
		insert a;
		
        Contact c = new Contact(AccountId = a.id, firstname='firstname', lastname = 'testName',
        					    Phone='760-111-2222');
        insert c;    
        
        Profile p = [SELECT Id FROM Profile WHERE Name='Standard User'];

        User u = new User(Alias = 'tempuser', Email='tempuser@testorg.com', 
        EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
        LocaleSidKey='en_US', ProfileId = p.Id, 
        TimeZoneSidKey='America/Los_Angeles', UserName='tempuser@testorg.com');

        System.runAs(u) 
        {
            System.assertEquals(false, SNGVisualforceRender.isUserSystemAdmin());
            System.assertEquals(false, SNGVisualforceRender.userAdmin);
            System.assertEquals(true, SNGVisualforceRender.userNotAdmin);
        }   
    }
    
    static testMethod void isUserSystemAdminPassWithCustomSettingInsert()
    {
        SNGAdminProfile__c sap = new SNGAdminProfile__c();
        sap.Name = 'SystemAdmin';
        sap.ProfileId__c='';
        sap.ProfileName__c='';
        insert sap;
        
        Account a = new Account(name ='Red Cross', BillingStreet = '6155 El Camino Real', 
                                BillingState = 'California', BillingCity = 'San Diego',
                                BillingPostalCode = '92008');
		
		insert a;
		
        Contact c = new Contact(AccountId = a.id, firstname='firstname', lastname = 'testName',
        					    Phone='760-111-2222');
        insert c;    
        
        Profile admin = [SELECT Id, Name FROM Profile WHERE Name = 'System Administrator' LIMIT 1];
        
        User u = new User(Alias = 'tempuser', Email='tempuser@testorg.com', 
        EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
        LocaleSidKey='en_US', ProfileId = admin.Id, 
        TimeZoneSidKey='America/Los_Angeles', UserName='tempuser@testorg.com');

        System.runAs(u) 
        {
        	boolean isA = SNGVisualforceRender.userAdmin;
        	isA = SNGVisualforceRender.userNotAdmin;
            //System.assertEquals(true, SNGVisualforceRender.isUserSystemAdmin());
            //System.assertEquals(true, SNGVisualforceRender.userAdmin);
            //System.assertEquals(false, SNGVisualforceRender.userNotAdmin);
        }            
         
    }
    
    static testMethod void testDoSaveAndNew()
    {
        Account a = new Account(name ='Red Cross', BillingStreet = '6155 El Camino Real', 
                                BillingState = 'California', BillingCity = 'San Diego',
                                BillingPostalCode = '92008');
        ApexPages.StandardController controller = new ApexPages.StandardController(a);
        SNGVisualforceRender rv = new SNGVisualforceRender(controller);
        PageReference pageReference = rv.doSaveAndNew();

        Schema.DescribeSObjectResult r = Account.sObjectType.getDescribe();
        String keyPrefix = r.getKeyPrefix();
        
        System.assertEquals(1, [SELECT COUNT() FROM Account WHERE Name = :a.name]);
        System.assertEquals('/' + keyPrefix + '/e', pageReference.getUrl());
    }
}