/*
 * Class ITSMSFormsCompControllerTest
 * 
 * @version 1.0
 * @author  Dianna Guilinger - Slalom  
 * 
 *  Verifies functionality and code coverage for ITSMSFormsComponentController 
 */
@isTest
private class ITSMSFormsCompControllerTest {
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
        	ITSMSFormsComponentController ccc = new ITSMSFormsComponentController();
        	//-- verify controller
        	ccc.pageController = new ITSMSPageControllerBase ();
        	ccc.key = 'testing';
        	ccc.componentToPage = new ITSMSComponentToController ();
   			ccc.caseRec = ITSMSUtilityClass.createCase('Access','Folder/Share');
        }			
     }
}