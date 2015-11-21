/**************************************************************************************************************
Name         : ITSMSPageControllerBaseTest 
Created By   : Dianna Guilinger - Slalom 
Description  : 
***************************************************************************************************************/

@isTest
private class ITSMSPageControllerBaseTest {
    
    static testMethod void testPageControllerBase() {
        ITSMSTestDataSetup.createTestConstants();
	    Test.startTest();
        PageReference pageRef= Page.ITSMSSupportRequest;
        Test.setCurrentPage(pageRef);
        ITSMSPageControllerBase base = new ITSMSPageControllerBase();
		//-- verify controller
		base.getComponentControllerMap();
        base.getMyComponentController();
        base.getThis();
        ITSMSComponentControllerBase cm = new ITSMSComponentControllerBase();
        base.setComponentController(cm);
        base.setComponentControllerMap('test',cm);
        
			
    }
}