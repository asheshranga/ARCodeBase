/*
 * Class ITSMSWorkstationCompControllerTest
 * 
 * @version 1.0
 * @author  Dianna Guilinger - Slalom  
 * 
 *  Verifies functionality and code coverage for ITSMSWorkstationCompController 
 */
@isTest
private class ITSMSWorkstationCompControllerTest {
    static testMethod void testWorkstationSave() {          
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
        	ITSMSWorkstationCompController ccc = new ITSMSWorkstationCompController();
        	//-- verify controller
			ccc.caseRec = ITSMSUtilityClass.createCase('Workstation','Workstation/Laptop');
        	ccc.pageController = new ITSMSPageControllerBase ();
        	ccc.key = 'testing';
        	ccc.componentToPage = new ITSMSComponentToController ();
			ccc.caseRec.IssueOrRequest__c = 'Request';
            ccc.caseRec.Date_Needed_By__c = system.today();
            ccc.caseRec.EquipmentLocation__c = 'testing';
            ccc.caseRec.CostCenterNumber__c = 'testing';
            ccc.caseRec.BriefDescription__c = 'testing';
            ccc.caseRec.JustificationRequest__c = 'testing';
            ccc.caseRec.WorkstationType__c = 'testing';
            ccc.caseRec.PCModelType__c = 'testing';
            ccc.caseRec.ComputerType__c = 'testing';
            ccc.caseRec.OperatingSystem__c = 'testing';
            ccc.caseRec.AssetTag__c  = 'testing';
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
            ccc.caseRec.WorkstationType__c = 'testing';
            ccc.caseRec.PCModelType__c = 'Laptop';
            ccc.caseRec.ComputerType__c = 'testing';
            ccc.caseRec.OperatingSystem__c = 'testing';
            ccc.caseRec.AssetTag__c  = 'testing';
        	ccc.saveAndNew();
        	ccc.cancelCase();
            testCases = [Select Id, Subject, Status, ParentId from Case];
        	system.debug('@@ after cancel:'+testCases);
        }			
     }
    static testMethod void testWorkstationSubmit() {          
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
        	ITSMSWorkstationCompController ccc = new ITSMSWorkstationCompController();
        	//-- verify controller
			ccc.caseRec = ITSMSUtilityClass.createCase('Workstation','Workstation/Laptop');
        	ccc.pageController = new ITSMSPageControllerBase ();
        	ccc.key = 'testing';
        	ccc.componentToPage = new ITSMSComponentToController ();
			ccc.caseRec.IssueOrRequest__c = 'Request';
            ccc.caseRec.Date_Needed_By__c = system.today();
            ccc.caseRec.EquipmentLocation__c = 'testing';
            ccc.caseRec.CostCenterNumber__c = 'testing';
            ccc.caseRec.BriefDescription__c = 'testing';
            ccc.caseRec.JustificationRequest__c = 'testing';
            ccc.caseRec.WorkstationType__c = 'testing';
            ccc.caseRec.PCModelType__c = 'Desktop';
            ccc.caseRec.ComputerType__c = 'testing';
            ccc.caseRec.OperatingSystem__c = 'testing';
            ccc.caseRec.AssetTag__c  = 'testing';
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