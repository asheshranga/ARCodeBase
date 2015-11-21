/**************************************************************************************************************
Name         : ITSMSLandingPageController 
Created By   : Dianna Guilinger - Slalom 
Description  : 
***************************************************************************************************************/

@isTest
private class ITSMSLandingPageControllerTest {
    
    static testMethod void testLandingPage() {
        ITSMSTestDataSetup.createTestConstants();
	        Test.startTest();
            PageReference pageRef= Page.ITSMSSupportCenterLandingPage;
            Test.setCurrentPage(pageRef);
            ApexPages.currentPage().getParameters().put('tab', 'Request_Help');
        	ITSMSLandingPageController lpc1 = new ITSMSLandingPageController();
	      	lpc1.requestHelp();
        	system.assertEquals(lpc1.RequestHelpCSS,'active');

            ApexPages.currentPage().getParameters().put('tab', 'My_Cases');
        	ITSMSLandingPageController lpc2 = new ITSMSLandingPageController();
            lpc2.MyCases();
        	system.debug('@@ lpc2:'+lpc2.MyCasesCSS);
        	system.assertEquals(lpc2.MyCasesCSS,'active');

            ApexPages.currentPage().getParameters().put('tab', 'My_New_Hires');
             ITSMSLandingPageController lpc3 = new ITSMSLandingPageController();
        	lpc3.MyNewHires();
        	system.assertEquals(lpc3.MyNewHiresCSS,'active');

            ApexPages.currentPage().getParameters().put('tab', ' ');
        	ITSMSLandingPageController lpc4 = new ITSMSLandingPageController();
        	system.assertEquals(lpc4.RequestHelpCSS,'active');
        }
}