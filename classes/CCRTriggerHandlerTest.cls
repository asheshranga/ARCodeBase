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
private class  CCRTriggerHandlerTest {
    
    static testmethod void  testNotifications()
    {
        //Creating this since this custom setting record is being refernenced in a CCR Trigger 
        CarlsbadNOCKeyValueStore__c noc= new CarlsbadNOCKeyValueStore__c();
        noc.Name = 'CCRClosedTaskStatusList';
        noc.Value__c = 'New,Open';
        insert noc;
        
        //Create the CCR record
        CCR__c ccr = new CCR__c();
        ccr.Status__c = 'New';
        insert ccr;
        
        // Create Account 
        Account acc = new Account();
        acc.Name = 'Google';
        acc.Status__c = 'Prospect';
        acc.CurrencyIsoCode = 'USD';
        acc.Type = 'End-User';
        acc.Industry = 'RAF';
        acc.Country__c = 'Benin';
        insert acc;
        
        //Create Contact
        Contact con = new Contact ( AccountId = acc.id, LastName = 'portalTestUser1' );
        insert con;
        
        //Create customer portal user
        Set<String> customerUserTypes = new Set<String> {'CSPLiteUser', 'PowerPartner', 'PowerCustomerSuccess',   'CustomerSuccess'};
        
        User cpUser;   
        User thisUser = [ select Id, userRoleId, profileId from User where Id = :UserInfo.getUserId() ];
        System.assertEquals(UserInfo.getUserId(),thisUser.id);
        System.runAs ( thisUser ) {
            UserRole ur = [Select PortalType, PortalAccountId From UserRole where PortalType =:'CustomerPortal' limit 1];
            Profile p = [select Id,name from Profile where UserType in :customerUserTypes limit 1];
            cpUser = new User(
                PortalRole = 'Manager',
                profileId = p.id,
                username = 'dummtyTestUser1@visasat.com',
                email = 'dummtyTestUser1@visasat.com',
                emailencodingkey = 'UTF-8',
                localesidkey = 'en_US',
                languagelocalekey = 'en_US',
                timezonesidkey = 'America/Los_Angeles',
                alias='nuser',
                lastname='lastname',
                Account_Number__c = '123456789',
                contactId = con.id
            );
            insert cpUser;  
            System.assertEquals(cpUser.username,'dummtyTestUser1@visasat.com');
        }
        
        PermissionSet p = [select id from PermissionSet where name = :CCRTriggerHandler.CCR_CUSTOMER_PERMISSION_SET limit 1];
        //Assign permission set to the customer portal user
        PermissionSetAssignment assignment = new PermissionSetAssignment();
        assignment.AssigneeId = cpUser.id;
        assignment.PermissionSetId = p.id;
        System.runAs ( thisUser ) {
            insert assignment;}

       
        
        //Create Site        
        site__c s = new site__c();
        s.Account__c = acc.id; 
        s.Program__c = 'AECN';
        s.SiteName__c = 'mySite1';
        insert s;
       
        Test.startTest();
        //Create the ccr-site junction object record
        CCRSiteAssociation__c ccrassoc = new CCRSiteAssociation__c();
        ccrassoc.SiteNOC__c = s.id;
        ccrassoc.CCR__c = ccr.id;
        insert ccrassoc;
        
        
        //Share to the customer by setting the visible flag
        ccr.Visible_to_Customer__c = true;
        update ccr;
        
        //Close the CCR
        ccr.Status__c = 'Closed';
        ccr.Requested_Maintenance_Window_Duration__c = '03:35';
        update ccr;
        Test.stopTest();
    }
    
}