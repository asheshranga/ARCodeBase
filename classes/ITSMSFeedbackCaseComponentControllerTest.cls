/*
    Created on: October 27, 2015
    Author: Dennis Estioco

    Test class for ITSMSFeedbackCaseComponentController.cls. The testFeedbackCasePage method runs the submitFeedbackCase method in the ITSMSFeedbackCaseController class as a newly
    created portal user and submits a feedback case successfully. The second call to the submitFeedbackCase method hits the catch blocks in the ITSMSFeedbackCaseController class.

*/

@isTest
public class ITSMSFeedbackCaseComponentControllerTest{
 
    static testMethod void testFeedbackCasePage(){     
        
        ITSMSTestDataSetup.createTestConstants();
        ITSMSTestDataSetup.createPortalUser();        
        User portalUser = [SELECT Id, AccountId, ContactId FROM User WHERE FirstName = 'Portal'];
        ITSMSFeedbackCaseComponentController feedbackCaseController = new ITSMSFeedbackCaseComponentController();            
        test.startTest();
        system.runAs (portalUser){ 
                       
            PageReference pageRef= Page.ITSMSFeedbackCase; 
            Test.setCurrentPage(pageRef);                    
            feedbackCaseController.submitFeedbackCase();            
        }    
        feedbackCaseController.submitFeedbackCase();
        test.stopTest();
    }
    
}