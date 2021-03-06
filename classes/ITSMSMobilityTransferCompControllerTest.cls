/*
 * Class ITSMSMobilityTransferCompControllerTest
 * 
 * @version 1.0
 * @author  Dianna Guilinger - Slalom  
 * 
 *  Verifies functionality and code coverage for ITSMSMobilityTransferCompController 
 */
@isTest
private class ITSMSMobilityTransferCompControllerTest {
    static testMethod void testMobilityTransferSave() {          
        ITSMSTestDataSetup.createTestConstants();
        // create test data - requestor, requestedFor, delegates
        ITSMSTestDataSetup.createRequestor();
        User communityUser = [select Id,  Delegate__c from User where FirstName = 'Community'];
        system.runAs (communityUser)
        {
            //*** start test
            Test.startTest();
            PageReference pageRef= Page.ITSMSSupportRequest;
            Test.setCurrentPage(pageRef);
            ITSMSMobilityTransferCompController ccc = new ITSMSMobilityTransferCompController();
            //-- verify controller
            ccc.caseRec = ITSMSUtilityClass.createCase('Mobility','Transfer Service from Personal account');
            ccc.pageController = new ITSMSPageControllerBase ();
            ccc.key = 'testing';
            ccc.componentToPage = new ITSMSComponentToController ();
            ccc.caseRec.IssueOrRequest__c = 'Request';
          //  ccc.caseRec.ManagerUser__c = communityUser.Delegate__c;
            ccc.caseRec.Date_Needed_By__c = system.today();
            ccc.caseRec.DeptVP__c = communityUser.Delegate__c;
            ccc.caseRec.CostCenterNumber__c = '11111';
            ccc.caseRec.JustificationRequest__c = 'Testing';
            ccc.caseRec.ExistingMobilePhoneNumber__c = 'Testing';
            ccc.caseRec.CurrentCarrier__c = 'Testing'; 
            ccc.caseRec.CurrentPhoneModel__c = 'Testing';
            ccc.caseRec.ContractEndDate__c = system.today();
            ccc.caseRec.NewCarrierPhoneModel__c = 'Testing';
            ccc.caseRec.Color__c = 'Testing';
            ccc.caseRec.Accessories__c = 'Testing';
            ccc.saveOnly();
            list<Case> testCases = [Select Id, Subject, Status, ParentId from Case];
            system.debug('@@ after save:'+testCases);
            // verify 2 cases created and status is 'Pending Submission'
            system.assertEquals(testCases.size(),2);
            system.assertEquals(testCases[0].Status,'Pending Submission');
            system.assertEquals(testCases[1].Status,'Pending Submission');
            ccc.caseRec.IssueOrRequest__c = 'Request';
          //  ccc.caseRec.ManagerUser__c = communityUser.Delegate__c;
            ccc.caseRec.Date_Needed_By__c = system.today();
            ccc.caseRec.CostCenterNumber__c = '11111';
            ccc.caseRec.JustificationRequest__c = 'Testing';
            ccc.caseRec.ExistingMobilePhoneNumber__c = 'Testing';
            ccc.caseRec.CurrentCarrier__c = 'Testing'; 
            ccc.caseRec.CurrentPhoneModel__c = 'Testing';
            ccc.caseRec.ContractEndDate__c = system.today();
            ccc.caseRec.NewCarrierPhoneModel__c = 'Testing';
            ccc.caseRec.Color__c = 'Testing';
            ccc.caseRec.Accessories__c = 'Testing';
            ccc.saveAndNew();
            ccc.cancelCase();
            testCases = [Select Id, Subject, Status, ParentId from Case];
            system.debug('@@ after cancel:'+testCases);
        }           
     }
    static testMethod void testMobilityTransferSubmit() {          
        ITSMSTestDataSetup.createTestConstants();
        // create test data - requestor, requestedFor, delegates
        ITSMSTestDataSetup.createRequestor();
        User communityUser = [select Id,  Delegate__c from User where FirstName = 'Community'];
        system.runAs (communityUser)
        {
            //*** start test
            Test.startTest();
            PageReference pageRef= Page.ITSMSSupportRequest;
            Test.setCurrentPage(pageRef);
            ITSMSMobilityTransferCompController ccc = new ITSMSMobilityTransferCompController();
            //-- verify controller
            ccc.caseRec = ITSMSUtilityClass.createCase('Mobility','Transfer Service from Personal account');
            ccc.pageController = new ITSMSPageControllerBase ();
            ccc.key = 'testing';
            ccc.componentToPage = new ITSMSComponentToController ();
            ccc.caseRec.IssueOrRequest__c = 'Request';
            ccc.caseRec.Date_Needed_By__c = system.today();
            ccc.caseRec.DeptVP__c = communityUser.Delegate__c;
            ccc.caseRec.CostCenterNumber__c = '11111';
            ccc.caseRec.JustificationRequest__c = 'Testing';
            ccc.caseRec.ExistingMobilePhoneNumber__c = 'Testing';
            ccc.caseRec.CurrentCarrier__c = 'Testing'; 
            ccc.caseRec.CurrentPhoneModel__c = 'Testing';
            ccc.caseRec.ContractEndDate__c = system.today();
            ccc.caseRec.NewCarrierPhoneModel__c = 'Testing';
            ccc.caseRec.Color__c = 'Testing';
            ccc.caseRec.Accessories__c = 'Testing';
            ccc.saveOnly();
            ccc.saveAndSubmit();
            list<Case> testCases = [Select Id, Subject, Status, ParentId from Case];
            system.debug('@@ after submit:'+testCases);
            // verify 2 cases created, parent is closed, child is new
            system.assertEquals(testCases.size(),2);
            for (Case c:testCases)
            {
                if (c.Subject == 'Support Parent')
                    system.assertEquals(c.Status,'Closed');
                if (c.Subject != 'Support Parent')
                    system.assertEquals(c.Status,'New');
            }

        }           
     }
}