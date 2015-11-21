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
private class  ServiceReqTerminalSelectControllerTest {
    
     static testmethod void testSearch() 
    {
        ServReqRTToSiteRTMap__c cs= new ServReqRTToSiteRTMap__c();
        cs.Name = 'Terminal';
        cs.FieldSetToDisplay__c = 'Terminals';
        cs.Site_Record_Types_Avl__c = 'Aviation_GOV;Aviation_GOV_BAN'; 
        cs.AllowedStatus__c = 'Commissioned';
        insert cs;
        
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
        
        Id rtId = [select id from RecordType where developerName = 'Aviation_GOV'].id;
        
        //Create Site        
        site__c s1 = new site__c();
        s1.Account__c = acc1.id; 
        s1.Program__c = 'AECN';
        s1.SiteName__c = 'mySite1';
        s1.SatelliteIP__c = '255.249.245.249';
        s1.RecordTypeId = rtId;
        insert s1;
        
        site__c s2 = new site__c();
        s2.Account__c = acc2.id;     
        s2.Program__c = 'AECN';
        s2.SiteName__c = 'mySite10';
        s2.SatelliteIP__c = '255.249.245.249';
        s1.RecordTypeId = rtId;
        insert s2;
        
        Id srRtId = [select id from RecordType where developerName = 'ATRF_Gov'].id;
        
        Service_Request__c sr = new Service_Request__c(Status__c = 'Archived',                                                    
                                                    ATRF_Date_to_Activate__c = System.today(),
                                                    ATRF_Date_to_Terminate__c = System.today().addMonths(1),
                                                    ATRF_Tiered_Service_Plan__c = 'GenAv - Yonder VIP 4M x 512k',
                                                    ATRF_Map_Bundle__c = '200.X',
                                                    ATRF_APR_Blanking__c = 'Yes',
                                                    ATRF_Sat_Search__c = 'On',
                                                    recordTypeId = srRtId);
        insert sr;
        
        Test.startTest();
        PageReference pageRef = Page.ServiceReqTerminalSelect;

        Test.setCurrentPage(pageRef);

        ApexPages.currentPage().getParameters().put('type', 'terminal');
        ApexPages.StandardController sc = new ApexPages.StandardController(sr);
        ServiceReqTerminalSelectController s = new ServiceReqTerminalSelectController(sc);
        ServiceReqTerminalSelectController.InitList();
        
        List<Map<String,String>> results = new List<Map<String,String>> ();
        
        results = ServiceReqTerminalSelectController.searchForTerminals(
            s.listOfFieldsToDisplay,
            sr.id, 
            rtId,
            s.avlStatus,
            'mySite',
            '',
            '255',
            'AECN');
        
        //Should not be empty - it should return the sites inserted above.
        System.assert(!results.isEmpty());
        
        List<Id> siteIds = new List<Id>();
        for(Map<String,String> mapOfFields : results)
        {
            siteIds.add(mapOfFields.get('Id'));
        }
        ServiceReqTerminalSelectController.addSitesToSR(sr.id, 'Terminal' , siteIds);
        
        List<ServiceRequestSite__c> sitesAdded = [select id, ServiceSite__c from ServiceRequestSite__c where ServiceRequest__c =: sr.id];
    
        System.assert(!sitesAdded.isEmpty());
        results = ServiceReqTerminalSelectController.searchForTerminals(
            s.listOfFieldsToDisplay,
            sr.id, 
            rtId,
            s.avlStatus,
            'mySite',
            '',
            '255',
            'AECN');
        
        //Should be empty now since the sites have already been added to the ATRF
        System.assert(results.isEmpty());
        Test.stopTest();
    }

}