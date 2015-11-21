/*********************************************************************************
Name         : ATRFServiceRequestListControllerTest
Created By   : Lynnet Ambrocio
Company Name : Slalom Consulting
Project      : ATRF 2.0
Created Date : 9/3/2015
Usages       : Test Class for Apex Class: ATRFServiceRequestListController
*********************************************************************************/
@isTest
public class ATRFServiceRequestListControllerTest {
    
    static private Site__c createData() {
        Site__c site = new Site__c();
        insert site;
        
        ServiceRequestSite__c srSite = new ServiceRequestSite__c(ServiceSite__c = site.Id);
        
        Service_Request__c sr = new Service_Request__c(Status__c = 'Archived',                                                    
                                                    ATRF_Date_to_Activate__c = System.today(),
                                                    ATRF_Date_to_Terminate__c = System.today().addMonths(1),
                                                    ATRF_Tiered_Service_Plan__c = 'GenAv - Yonder VIP 4M x 512k',
                                                    ATRF_Map_Bundle__c = '200.X',
                                                    ATRF_APR_Blanking__c = 'Yes',
                                                    ATRF_Sat_Search__c = 'On');
        insert sr;
        
        srSite.ServiceRequest__c = sr.Id;
        insert srSite;
        
        return site;
    } 
    
    static testMethod void testSearch() {
        Site__c site = createData();
        
        ApexPages.StandardController controller = new ApexPages.StandardController(site);
        
        Test.startTest();
        ApexPages.currentPage().getParameters().put('showPage', 'true');
        ATRFServiceRequestListController ctrlr1 = new ATRFServiceRequestListController(controller);
        ApexPages.currentPage().getParameters().put('showPage', 'false');
        ATRFServiceRequestListController ctrlr2 = new ATRFServiceRequestListController(controller);
        System.assertNotEquals(null, ctrlr1.searchResults);
        System.assertNotEquals(null, ctrlr2.searchResults);
        Test.stopTest();
        
        
    }

}