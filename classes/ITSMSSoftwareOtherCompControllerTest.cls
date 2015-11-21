/*
 * Class ITSMSSoftwareOtherCompControllerTest
 * 
 * @version 1.0
 * @author  Dianna Guilinger - Slalom  
 * 
 *  Verifies functionality and code coverage for ITSMSSoftwareOtherCompController 
 */
@isTest
private class ITSMSSoftwareOtherCompControllerTest {
    static testMethod void testSoftwareOtherSave() {          
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
        	ITSMSSoftwareOtherCompController ccc = new ITSMSSoftwareOtherCompController();
        	//-- verify controller
			ccc.caseRec = ITSMSUtilityClass.createCase('Software','All Other Products/Changes/Issues');
        	ccc.pageController = new ITSMSPageControllerBase ();
        	ccc.key = 'testing';
        	ccc.componentToPage = new ITSMSComponentToController ();
			ccc.caseRec.IssueOrRequest__c = 'Request';
            ccc.caseRec.OtherSoftwareProduct__c = 'bamboo';
            ccc.caseRec.Description  = 'bamboo';
        	ccc.saveOnly();
            list<Case> testCases = [Select Id, Subject, Status, ParentId from Case];
        	system.debug('@@ after save:'+testCases);
			// verify 2 cases created and status is 'Pending Submission'
            system.assertEquals(testCases.size(),2);
            system.assertEquals(testCases[0].Status,'Pending Submission');
            system.assertEquals(testCases[1].Status,'Pending Submission');
			ccc.caseRec.IssueOrRequest__c = 'Request';
            ccc.caseRec.OtherSoftwareProduct__c = 'Fisheye';
            ccc.caseRec.Description  = 'Fisheye';
        	ccc.saveAndNew();
			ccc.caseRec.IssueOrRequest__c = 'Request';
            ccc.caseRec.OtherSoftwareProduct__c = 'HipChat';
            ccc.caseRec.Description  = 'HipChat';
        	ccc.saveAndNew();
			ccc.caseRec.IssueOrRequest__c = 'Request';
            ccc.caseRec.OtherSoftwareProduct__c = 'JIRA';
            ccc.caseRec.Description  = 'JIRA';
        	ccc.saveAndNew();
			ccc.caseRec.IssueOrRequest__c = 'Request';
            ccc.caseRec.OtherSoftwareProduct__c = 'confluence';
            ccc.caseRec.Description  = 'confluence';
        	ccc.saveAndNew();
        	ccc.cancelCase();
            testCases = [Select Id, Subject, Status, ParentId from Case];
        	system.debug('@@ after cancel:'+testCases);
        }			
     }
    static testMethod void testSoftwareOtherSubmit() {          
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
        	ITSMSSoftwareOtherCompController ccc = new ITSMSSoftwareOtherCompController();
        	//-- verify controller
			ccc.caseRec = ITSMSUtilityClass.createCase('Software','All Other Products/Changes/Issues');
        	ccc.pageController = new ITSMSPageControllerBase ();
        	ccc.key = 'testing';
        	ccc.componentToPage = new ITSMSComponentToController ();
			ccc.caseRec.IssueOrRequest__c = 'Request';
            ccc.caseRec.OtherSoftwareProduct__c = 'Testing';
            ccc.caseRec.Description  = 'Testing';
        	ccc.saveOnly();
        	ccc.saveAndSubmit();
            list<Case> testCases = [Select Id, Subject, Status, ParentId, ownerId from Case];
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