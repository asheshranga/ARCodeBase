/**************************************************************************************************************
Name         : ITSMSComponentControllerBaseTest 
Created By   : Dianna Guilinger - Slalom 
Description  : 
***************************************************************************************************************/

@isTest
private class ITSMSComponentControllerBaseTest {
    
    static testMethod void testComponentControllerBase() {
        ITSMSTestDataSetup.createTestConstants();
	        Test.startTest();
            PageReference pageRef= Page.ITSMSSupportRequest;
            Test.setCurrentPage(pageRef);
            ITSMSComponentControllerBase base = new ITSMSComponentControllerBase();
			//-- verify controller
			base.key = 'Testing' ;
        	base.pageController = new ITSMSPageControllerBase();
			base.key = 'Testing2' ;
        }
}