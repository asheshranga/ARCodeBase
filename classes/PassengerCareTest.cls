/*
TestClass    : PassengerCareTest
Controller   : PassengerCareHomeController_VA, PassengerCareFAQController_VA
Created By   : Rajbabu Boopalan
Created Date : 14th October 2015
Description  : Master Test Class for all the Passenger Care Classes
Log :        
*/

@isTest(seeAllData=true)
private class PassengerCareTest
{
    //--- Test Method for PassengerCareHome Page and controller
    //--- Class : PassengerCareHomeController_VA
    //--- Page  : PassengerCareHome_VA
    private static testMethod void PassengerCareHomeUnitTest() 
    {
        //--- 1. Visaulforce page(s)
        Test.setCurrentPageReference(new PageReference('Page.PassengerCareHome_VA')); 
        
        //--- 2. Constants
        PassengerCareConstants constant = new PassengerCareConstants();
        
        //--- 3. Utility Class
        PassengerCareUtility.getQueueIdByName('PassengerCare');
        PassengerCareUtility.getObjectRecordTypeId(CASE.SObjectType,'PassengerCare');
        
        // create an account that is used by controller
        try {
            //upsert new Passenger_Care__c(Name='VA_Account',value__c = 'PassengerCare Test Count');
        } catch (Exception e) {
            // do nothing
        }    
        
        // create an account
        insert new account(Name=PassengerCareConstants.ACCOUNT_NAME);
        
        //--- 4. Controller(s)
        PassengerCareHomeController_VA cont = new PassengerCareHomeController_VA();
        
        String test1;
        test1 = cont.LiveChatDeploymentURL;
        test1 = cont.LiveChatInitURL;
        test1 = cont.LiveChatCompanyInfoID;
        test1 = cont.LiveChatDeploymentID;
        test1 = cont.LiveChatButtonID;
        test1 = cont.EmailToUsInfo;
        test1 = cont.EmailAdditionalInfo;
        test1 = cont.ChatWithUsInfo;
        test1 = cont.ChatAdditionalInfo;
        test1 = cont.CallUsPhone;
        test1 = cont.LearnMoreViaSatURL;
        test1 = cont.LearnMoreExedeURL;
        test1 = cont.HelpPageTitle;
        test1 = cont.PassengerCareFAQURL;
        test1 = cont.ChatSubject;
        test1 = cont.ChatStatus ;
        test1 = cont.ChatOrigin ;
        test1 = cont.ChatType ;
        test1 = cont.ChatProductFamily ;
        
        Id Testid;
        Testid = cont.CaseRecordTypeId ;
        Testid = cont.PassengerCareAccountId;
        Testid = cont.ChatSite;
        
        Map<string,string> TestMap;
        TestMap = cont.PCSubject.clone();        
        
        Boolean bTest;
        btest = cont.displaySubmitButton;

        //--- Create Case for contact doesn't exists scenario
        Case objEmailCase = new case(Subject='Test Subject',suppliedEmail='Test10291025@viasattest.com',SuppliedName='Test1027 lastname',description='test description',origin='phone');        
        cont.EmailCase = objEmailCase;
        cont.submit();
        
        //--- Method calls
        //cont.getLiveAgentCaseMapping();
        
        //--- Create Contact for contact exists scenario        
        Contact testContact = PassengerCareTestFactory.buildTestContact('TestFirstName','TestLastName','contactexist@viasattest.com');
        insert testContact;
        
        //--- Create Case for contact exists scenario
        cont = new PassengerCareHomeController_VA();        
        cont.EmailCase = new case(Subject='Contact Exist Subject',suppliedEmail='contactexist@viasattest.com',SuppliedName='TestLastName',description='test description',origin='phone');                
        cont.submit();
        
        //--- Testing the Catch block of Submit method
        cont = new PassengerCareHomeController_VA();        
        cont.EmailCase = new case();
        cont.submit();        
    }
    
    //--- Test Method for PassengerCareFAQ Page and controller
    //--- Class : PassengerCareFAQController_VA
    //--- Page  : PassengerCareFAQ_VA
    private static testMethod void FAQPageUnitTest() 
    {
        //--- 1. Visaulforce page(s)
        Test.setCurrentPageReference(new PageReference('Page.PassengerCareFAQ_VA')); 
        
        //--- 2. Constants
        PassengerCareConstants FAQconstant = new PassengerCareConstants();
        
        //--- 3. Utility Class
        PassengerCareUtility.getQueueIdByName('PassengerCare');
        PassengerCareUtility.getObjectRecordTypeId(CASE.SObjectType,'PassengerCare');
        PassengerCareUtility.getObjectIdByName('contact','PassengerCare');
        
        //--- 4. Controller(s)
        PassengerCareFAQController_VA contFAQ = new PassengerCareFAQController_VA();
        
        String test1;
        test1 = contFAQ.FAQHeader;
        test1 = contFAQ.FAQHeaderText;
        test1 = contFAQ.FAQPageTitle;
        test1 = contFAQ.CallUsPhone;
        test1 = contFAQ.LearnMoreViaSatURL;
        test1 = contFAQ.LearnMoreExedeURL;
    }
}