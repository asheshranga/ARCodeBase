@isTest
public class ITSMSTestingA {
    // Coverage for ITSMSCaseMatrix Controller 
    static testMethod void testCaseMatrixController() {
       ITSMSTestDataSetup.createTestConstants();
        // create test data - requestor, requestedFor, delegate
        ITSMSTestDataSetup.createRequestor();
        User requestor = [select Id, ManagerId from User where FirstName = 'Requestor'];
        system.runAs (requestor)
        {
            // create submitted Case 
            ITSMSTestDataSetup.createTestCase();
            Case submitCase = [Select Id, Subject, SupportCategory__c, ServiceRequestType__c  from Case limit 1 ];
            submitCase.SupportRequestType__c = 'Folder/Share';
            submitCase.ServiceRequestType__c = ITSMSConstants.FOLDERSHARE_SRVREQTYPE;
            submitCase.SupportCategory__c = 'Access';
            boolean isUpserted = ITSMSUtilityClass.upsertCase(submitCase);
            ITSMSCaseMatrixComponentController matrixController = new ITSMSCaseMatrixComponentController();
           
            //*** start test
            Test.startTest(); 
            matrixController.key = 'Testing' ;
            matrixController.componentToPage = new ITSMSComponentToController ();
            matrixController.pageController = new ITSMSPageControllerBase();
            matrixController.caseRec = submitCase;
            matrixController.componentToPage.caseRec = submitCase;
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
            system.debug('@@@ lstSavedPermissions.size(): ' + matrixController.lstSavedPermissions.size());            
            matrixController.lstSavedPermissions[0].selected = true;            
			matrixController.savePermission();                 
            system.debug('@@@ lstSavedPermissions[0].selected: ' + matrixController.lstSavedPermissions[0].selected);                  
            matrixController.DeleteSelectedPermission();
            // validate the permission deleted successfully
            //system.assertEquals(0, matrixController.lstSavedPermissions.size());
            
            Test.stopTest();
        } 
    }
}