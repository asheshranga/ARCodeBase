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
private class  CCRSiteAssociationTriggerHandlerTest {
    
    static testmethod void testAccountNamePopulation()
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
        Account acc1 = new Account();
        acc1.Name = 'Google';
        acc1.Status__c = 'Prospect';
        acc1.CurrencyIsoCode = 'USD';
        acc1.Type = 'End-User';
        acc1.Industry = 'RAF';
        acc1.Country__c = 'Benin';
        insert acc1;
        
        // Create Account
        Account acc2 = new Account();
        acc2.Name = 'Microsoft';
        acc2.Status__c = 'Prospect';
        acc2.CurrencyIsoCode = 'USD';
        acc2.Type = 'End-User';
        acc2.Industry = 'RAF';
        acc2.Country__c = 'Benin';
        insert acc2;
        
        //Create Site        
        site__c s1 = new site__c();
        s1.Account__c = acc1.id; 
        s1.Program__c = 'AECN';
        s1.SiteName__c = 'mySite1';
        insert s1;
        
        site__c s2 = new site__c();
        s2.Account__c = acc2.id;     
        s2.Program__c = 'AECN';
        s2.SiteName__c = 'mySite10';
        insert s2;
        
        //Create the junction object record
        CCRSiteAssociation__c ccrassoc1 = new CCRSiteAssociation__c();
        ccrassoc1.SiteNOC__c = s1.id;
        ccrassoc1.CCR__c = ccr.id;
        insert ccrassoc1;
        
        String ccrAccName = [select id, AccountNameSharingRule__c from CCR__c where id = :ccr.id limit 1].AccountNameSharingRule__c;
        //Validate the account name field has been updated to contain the account name from the site s1.
        System.assert(ccrAccName.contains('Google'));
        
        
        CCRSiteAssociation__c ccrassoc2 = new CCRSiteAssociation__c();
        ccrassoc2.SiteNOC__c = s2.id;
        ccrassoc2.CCR__c = ccr.id;
        insert ccrassoc2;
        
        ccrAccName = [select id, AccountNameSharingRule__c from CCR__c where id = :ccr.id limit 1].AccountNameSharingRule__c;
        //Validate the account name field has been updated to contain the account name from the site s2.
        System.assert(ccrAccName.contains('Microsoft'));
        
        delete ccrassoc1;
        
        ccrAccName = [select id, AccountNameSharingRule__c from CCR__c where id = :ccr.id limit 1].AccountNameSharingRule__c;
        //Validate the account name field has been updated to remove the account name from the deleted site s1.
        System.assert(!ccrAccName.contains('Google'));   
        
        delete ccrassoc2;
        ccrAccName = [select id, AccountNameSharingRule__c from CCR__c where id = :ccr.id limit 1].AccountNameSharingRule__c;
        //Validate the account name field has been updated to remove the account name from the deleted site s2.
        System.assert(String.isBlank(ccrAccName));  
        
    }
    
    
    
}