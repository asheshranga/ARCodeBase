/*
Test Class : PassengerCareFAQController_VA_Test
Controller : PassengerCareFAQController_VA
Created By : Rajbabu Boopalan
Created Date : 12th October 2015
Description : Test Class for the class PassengerCareFAQController_VA
Log :        
*/

@isTest(seeAllData=true)
private class PassengerCareFAQController_VA_Test
{
    static testMethod void FAQPageUnitTest() 
    {
        //--- 1. Visaulforce page(s)
        Test.setCurrentPageReference(new PageReference('Page.PassengerCareFAQ_VA')); 
        
        //--- 2. Constants
        PassengerCareConstants constant = new PassengerCareConstants();
        
        //--- 3. Utility Class
        PassengerCareUtility.getQueueIdByName('PassengerCare');
        PassengerCareUtility.getObjectRecordTypeId(CASE.SObjectType,'PassengerCare');
        
        //--- 4. Controller(s)
        PassengerCareFAQController_VA cont = new PassengerCareFAQController_VA();
        
        String test1;
        test1 = cont.FAQHeader;
        test1 = cont.FAQHeaderText;
        test1 = cont.FAQPageTitle;
        test1 = cont.CallUsPhone;
        test1 = cont.LearnMoreViaSatURL;
        test1 = cont.LearnMoreExedeURL;
    }
}