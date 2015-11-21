/*
Test Class : PassengerCareHomeControllerVATest
Controller : PassengerCareHomeControllerVA
Created By : Rakesh
Created Date : 25th August 15
Description : 
Log :        
*/

@isTest(seeAllData=true)
private class PassengerCareHomeController_VA_Test
{
    static testMethod void PassengerCareHomeUnitTest() 
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
        
        //--- Create Case for contact doesn't exists scenario
        Case EmailCase = new case(Subject='Test Subject',suppliedEmail='Test@viasattest.com',SuppliedName='Test last name',description='test description',origin='phone');        
        cont.EmailCase = EmailCase;
        
        //--- Method calls
        cont.getLiveAgentCaseMapping();
        cont.submit();          
        
        //--- Create Case for contact exists scenario        
        Contact testContact = PassengerCare_TestFactory.buildTestContact('TestFirstName','TestLastName','abc@viasattest.com');
        insert testContact;
        
        cont = new PassengerCareHomeController_VA();
        
        EmailCase = new case(Subject='Test Subject',suppliedEmail='abc@viasattest.com',SuppliedName='TestLastName',description='test description',origin='phone');        
        cont.EmailCase = EmailCase;        
        cont.submit();        
    }
    
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