/*
 * Class ITSMSCaseMatrixComponentControllerTest
 * 
 * @version 0.1
 * @author  Dianna Guilinger - Slalom  
 * 
 *  Verifies functionality and code coverage for ITSMSCaseMatrixComponentController 
 */
@isTest 
private class ITSMSCaseMatrixComponentControllerTest {

    static testMethod void myUnitTest() {
       ITSMSTestDataSetup.createTestConstants();
        /*ITSMSTestDataSetup.createPortalUser();

        User portalUser = [select Id from User where FirstName = 'Portal'];
        system.runAs (portalUser)
        {*/

             
            ITSMSCaseMatrixComponentController matrixController = new ITSMSCaseMatrixComponentController();
            Case caseRecord = ITSMSUtilityClass.createCase('Conferencing','Test');
            insert caseRecord;
            
			//*** start test
            Test.startTest(); 
            
            matrixController.key = 'Testing' ;
            matrixController.componentToPage = new ITSMSComponentToController ();
            matrixController.pageController = new ITSMSPageControllerBase();
        	matrixController.caseRec = caseRecord;
            matrixController.componentToPage.caseRec = caseRecord;
        	matrixController.recordTypeName = 'FolderShareNew';
            matrixController.theFieldSetName = 'MatrixNew';
            matrixController.intNumberOfRows = 2;
            
            // validate
            system.assertEquals(matrixController.intNumberOfRows, matrixController.LstPermissions.size(), 'Failed to set the lstPermissions');
          	system.assertEquals(0, matrixController.lstSavedPermissions.size());
          	
          	// set the user field of one of the permission rows and save
          	ITSMSPermission__c permissionRecord =  matrixController.LstPermissions[0];
          	permissionRecord.user__c = UserInfo.getUserId();
        	permissionRecord.ReadOnly__c = true;
          	matrixController.savePermission();
          	// validate the permission saved successfully
          	system.assertEquals(1, matrixController.lstSavedPermissions.size());
          	
            // set the user field as a duplicate
          	ITSMSPermission__c permissionRecord2 =  matrixController.LstPermissions[1];
          	permissionRecord2.user__c = UserInfo.getUserId();
        	permissionRecord2.ReadOnly__c = true;
          	matrixController.savePermission();

          	// set the selected field of one the saved permission rows and delete
          	matrixController.lstSavedPermissions[0].selected = true; 
          	matrixController.DeleteSelectedPermission();
          	// validate the permission deleted successfully
          	//system.assertEquals(0, matrixController.lstSavedPermissions.size());
          	
          	Test.stopTest();
    	//} 
    }
}