/*
 * Class ITSMSIssueComponentControllerTest
 * 
 * @version 1.0
 * @author  Dianna Guilinger - Slalom  
 * 
 *  Verifies functionality and code coverage for ITSMSIssueComponentController 
 */
@isTest
private class ITSMSIssueComponentControllerTest {
    static testMethod void testFormsComp() {          
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
        	ITSMSIssueComponentController ccc = new ITSMSIssueComponentController();
        	//-- verify controller
        	ccc.pageController = new ITSMSPageControllerBase ();
        	ccc.key = 'testing';
        	ccc.componentToPage = new ITSMSComponentToController ();
   			ccc.caseRec = ITSMSUtilityClass.createCase('Access','Issue');
			ccc.caseRec.IssueOrRequest__c = 'Issue';
            ccc.caseRec.Description = 'Testing';
            ccc.caseRec.ScreenshotsAttached__c = 'Yes';
            ccc.addingAttachment();
            Case testCase = [Select Id, Status, Type, ServiceRequestType__c from Case limit 1];
            system.debug('@@ case will exist:'+ccc.caseRec);
            system.assertEquals(testCase.Status, 'Pending Submission');
            PageReference pageRef2 = ccc.submitAndNew();
            testCase = [Select Id, Status, Type, ServiceRequestType__c from Case limit 1];
            system.debug('@@ after submit and new:'+testCase);
            system.assertEquals(testCase.Status, 'New');
			ccc.caseRec.IssueOrRequest__c = 'Issue';
            ccc.caseRec.Description = 'Testing';
            ccc.caseRec.ScreenshotsAttached__c = 'Yes';
            PageReference pageRef3 = ccc.submitOnly();
            List<Case> testCases = [Select Id, Status, Type, ServiceRequestType__c from Case];
            system.debug('@@ after submit only:'+testCases);
            system.assertEquals(testCases.size(),1);
            PageReference pageRef4 = ccc.cancelCase();
            system.debug('@@ after cancel:'+pageRef4);
            system.assert(pageRef4.getUrl().contains('Home'));
        }			
     }
}