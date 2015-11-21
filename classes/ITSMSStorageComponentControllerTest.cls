/*
 * Class ITSMSStorageComponentControllerTest
 * 
 * @version 1.0
 * @author  Dianna Guilinger - Slalom  
 * 
 *  Verifies functionality and code coverage for ITSMSStorageComponentController 
 */
@isTest
private class ITSMSStorageComponentControllerTest {
    static testMethod void testStorageSave() {          
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
        	ITSMSStorageComponentController ccc = new ITSMSStorageComponentController();
        	//-- verify controller
			ccc.caseRec = ITSMSUtilityClass.createCase('Server','Storage');
        	ccc.pageController = new ITSMSPageControllerBase ();
        	ccc.key = 'testing';
        	ccc.componentToPage = new ITSMSComponentToController ();
			ccc.caseRec.IssueOrRequest__c = 'Request';
            ccc.caseRec.Date_Needed_By__c = system.today();
            ccc.caseRec.EquipmentLocation__c = 'testing';
            ccc.caseRec.CostCenterNumber__c = 'testing';
            ccc.caseRec.BriefDescription__c = 'testing';
            ccc.caseRec.JustificationRequest__c = 'testing';
            ccc.caseRec.StorageRequestType__c = 'testing';
            ccc.caseRec.StorageLocation__c = 'testing';
            ccc.caseRec.NewHost__c = 'testing';
            ccc.caseRec.ServerHostName__c = 'testing';
            ccc.caseRec.Clustered__c  = 'testing';
            ccc.caseRec.Database__c = 'testing';
            ccc.caseRec.DiskName__c = 'testing';
            ccc.caseRec.StorageSize__c  = 5;
            ccc.caseRec.StorageSizeType__c = 'testing';
            ccc.caseRec.StorageSnapshotClone__c = 'testing';
            ccc.caseRec.SourceHostname__c = 'testing';
            ccc.caseRec.TargetHostname__c = 'testing';
            ccc.caseRec.StorageEnvironment__c = 'testing';
            ccc.caseRec.StorageFrequency__c = 'testing';
            ccc.caseRec.StartDateTime__c = system.now();
            ccc.caseRec.EndDateTime__c = system.now();
        	ccc.saveOnly();
            list<Case> testCases = [Select Id, Subject, Status, ParentId from Case];
        	system.debug('@@ after save:'+testCases);
			// verify 2 cases created and status is 'Pending Submission'
            system.assertEquals(testCases.size(),2);
            system.assertEquals(testCases[0].Status,'Pending Submission');
            system.assertEquals(testCases[1].Status,'Pending Submission');
			ccc.caseRec.IssueOrRequest__c = 'Request';
            ccc.caseRec.Date_Needed_By__c = system.today();
            ccc.caseRec.EquipmentLocation__c = 'testing';
            ccc.caseRec.CostCenterNumber__c = 'testing';
            ccc.caseRec.BriefDescription__c = 'testing';
            ccc.caseRec.JustificationRequest__c = 'testing';
            ccc.caseRec.StorageRequestType__c = 'testing';
            ccc.caseRec.StorageLocation__c = 'testing';
            ccc.caseRec.NewHost__c = 'testing';
            ccc.caseRec.ServerHostName__c = 'testing';
            ccc.caseRec.Clustered__c  = 'testing';
            ccc.caseRec.Database__c = 'testing';
            ccc.caseRec.DiskName__c = 'testing';
            ccc.caseRec.StorageSize__c  = 3;
            ccc.caseRec.StorageSizeType__c = 'testing';
            ccc.caseRec.StorageSnapshotClone__c = 'testing';
            ccc.caseRec.SourceHostname__c = 'testing';
            ccc.caseRec.TargetHostname__c = 'testing';
            ccc.caseRec.StorageEnvironment__c = 'testing';
            ccc.caseRec.StorageFrequency__c = 'testing';
            ccc.caseRec.StartDateTime__c = system.now();
            ccc.caseRec.EndDateTime__c = system.now();
        	ccc.saveAndNew();
        	ccc.cancelCase();
            testCases = [Select Id, Subject, Status, ParentId from Case];
        	system.debug('@@ after cancel:'+testCases);
        }			
     }
    static testMethod void testStorageSubmit() {          
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
        	ITSMSStorageComponentController ccc = new ITSMSStorageComponentController();
        	//-- verify controller
			ccc.caseRec = ITSMSUtilityClass.createCase('Server','Storage');
        	ccc.pageController = new ITSMSPageControllerBase ();
        	ccc.key = 'testing';
        	ccc.componentToPage = new ITSMSComponentToController ();
			ccc.caseRec.IssueOrRequest__c = 'Request';
            ccc.caseRec.Date_Needed_By__c = system.today();
            ccc.caseRec.EquipmentLocation__c = 'testing';
            ccc.caseRec.CostCenterNumber__c = 'testing';
            ccc.caseRec.BriefDescription__c = 'testing';
            ccc.caseRec.JustificationRequest__c = 'testing';
            ccc.caseRec.StorageRequestType__c = 'testing';
            ccc.caseRec.StorageLocation__c = 'testing';
            ccc.caseRec.NewHost__c = 'testing';
            ccc.caseRec.ServerHostName__c = 'testing';
            ccc.caseRec.Clustered__c  = 'testing';
            ccc.caseRec.Database__c = 'testing';
            ccc.caseRec.DiskName__c = 'testing';
            ccc.caseRec.StorageSize__c  = 2;
            ccc.caseRec.StorageSizeType__c = 'testing';
            ccc.caseRec.StorageSnapshotClone__c = 'testing';
            ccc.caseRec.SourceHostname__c = 'testing';
            ccc.caseRec.TargetHostname__c = 'testing';
            ccc.caseRec.StorageEnvironment__c = 'testing';
            ccc.caseRec.StorageFrequency__c = 'testing';
            ccc.caseRec.StartDateTime__c = system.now();
            ccc.caseRec.EndDateTime__c = system.now();
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