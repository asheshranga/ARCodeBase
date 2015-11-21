/*
 * Class ITSMSComponentToControllerTest
 * 
 * @version 1.0
 * @author  Dianna Guilinger - Slalom  
 * 
 *  Verifies functionality and code coverage for ITSMSComponentToController 
 */
@isTest
private class ITSMSComponentToControllerTest {
    static testMethod void testComponentToController() {          
        ITSMSTestDataSetup.createTestConstants();
		//*** start test
       	Test.startTest();
        ITSMSComponentToController c = new ITSMSComponentToController();
		c.notSubmitted = true;
        c.isNewRequest = true;
    	c.isNewCaseForRequest = true;
    	c.showSubmitAll = true;
    	c.isGeneralCase = true;
    	c.childCasesExist = false;
    	c.inputCaseId = null;
    	c.parentId = null;
    	c.inputSupportCategory = 'test';
    	c.caseToEdit = 'test';
    	c.caseToDelete= 'test';
		c.childCases = new list <Case> ();
    	c.errorRows = new map <Integer, String>();
		Case testCase = c.setCaseRec('test',null);
        c.initRequestChildCases();
        c.saveCase();
        //PageReference pageRef = c.submitCases();
        Case thisCase = c.getCaseRec();
    }
}