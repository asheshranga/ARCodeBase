/*
 * Class ITSMSCaseDetailControllerTest
 * 
 * @version 1.0
 * @author  Dianna Guilinger - Slalom  
 *  tests code coverage for ITSMSCaseDetail
 */
@isTest
private class ITSMSCaseDetailControllerTest {
    static testMethod void testCasePendingNewHire() {          
        ITSMSTestDataSetup.createTestConstants();
    	// create test data - requestor, requestedFor, delegate
        ITSMSTestDataSetup.createRequestor();
        User requestor = [select Id, ManagerId from User where FirstName = 'Requestor'];
        system.runAs (requestor)
        {

            // create pending Case for New Hire
			ITSMSTestDataSetup.createTestCase();
            Case pendingCase = [Select Id, Subject from Case limit 1];
			pendingCase.Subject = 'CaseDetailNewHire';
            pendingCase.Status = 'Pending Submission';
            pendingCase.ServiceRequestType__c = ITSMSConstants.NEWHIRE_SRVREQTYPE_PARENT;
            boolean isUpserted = ITSMSUtilityClass.upsertCase(pendingCase);

            Test.startTest();
            PageReference pageRef= Page.ITSMSCaseDetail;
            Test.setCurrentPage(pageRef);
            ApexPages.StandardController sc = new ApexPages.StandardController(pendingCase);
			ITSMSCaseDetailController cdc = new ITSMSCaseDetailController(sc);
            ApexPages.currentPage().getParameters().put('caseId', pendingCase.Id);
        
			//-- verify controller
			cdc.thisCase = [Select Id, Status, ServiceRequestType__c from Case where Id = :pendingCase.Id limit 1];
			cdc.checkCase();
        }
    }
    static testMethod void testCasePendingSupport() {          
        ITSMSTestDataSetup.createTestConstants();
    	// create test data - requestor, requestedFor, delegate
        ITSMSTestDataSetup.createRequestor();
        User requestor = [select Id, ManagerId from User where FirstName = 'Requestor'];
        system.runAs (requestor)
        {

            // create pending Case for Support
			ITSMSTestDataSetup.createTestCase();
            Case pendingCase = [Select Id, Subject from Case limit 1];
			pendingCase.Subject = 'CaseDetailSupport';
            pendingCase.Status = 'Pending Submission';
            pendingCase.ServiceRequestType__c = 'Access';
            boolean isUpserted = ITSMSUtilityClass.upsertCase(pendingCase);

            Test.startTest();
            PageReference pageRef= Page.ITSMSCaseDetail;
            Test.setCurrentPage(pageRef);
            ApexPages.StandardController sc = new ApexPages.StandardController(pendingCase);
			ITSMSCaseDetailController cdc = new ITSMSCaseDetailController(sc);
            ApexPages.currentPage().getParameters().put('caseId', pendingCase.Id);
        
			//-- verify controller
			cdc.thisCase = [Select Id, Status, ServiceRequestType__c from Case where Id = :pendingCase.Id limit 1];
			cdc.checkCase();
        }
    }
    static testMethod void testCaseSubmittedSupport() {          
        ITSMSTestDataSetup.createTestConstants();
    	// create test data - requestor, requestedFor, delegate
        ITSMSTestDataSetup.createRequestor();
        User requestor = [select Id, ManagerId from User where FirstName = 'Requestor'];
        system.runAs (requestor)
        {

            // create submitted Case for Support 
			ITSMSTestDataSetup.createTestCase();
            Case submitCase = [Select Id, Subject from Case limit 1 ];
			submitCase.Subject = 'CaseDetailSupport';
            submitCase.Status = 'New';
            submitCase.ServiceRequestType__c = 'Access';
            boolean isUpserted = ITSMSUtilityClass.upsertCase(submitCase);

            Test.startTest();
            PageReference pageRef= Page.ITSMSCaseDetail;
            Test.setCurrentPage(pageRef);
            ApexPages.StandardController sc = new ApexPages.StandardController(submitCase);
			ITSMSCaseDetailController cdc = new ITSMSCaseDetailController(sc);
            ApexPages.currentPage().getParameters().put('caseId', submitCase.Id);
        
			//-- verify controller
			cdc.thisCase = [Select Id, Status, ServiceRequestType__c from Case where Id = :submitCase.Id limit 1];
			//cdc.checkCase();
        }
    }
    static testMethod void testCaseSubmittedNewHire() {          
        ITSMSTestDataSetup.createTestConstants();
    	// create test data - requestor, requestedFor, delegate
        ITSMSTestDataSetup.createRequestor();
        User requestor = [select Id, ManagerId from User where FirstName = 'Requestor'];
        system.runAs (requestor)
        {

            // create submitted Case for Support 
			ITSMSTestDataSetup.createTestCase();
            Case submitCase = [Select Id, Subject from Case limit 1 ];
			submitCase.Subject = 'CaseDetailNewHire';
            submitCase.Status = 'Submitted';
            submitCase.ServiceRequestType__c = ITSMSConstants.NEWHIRE_SRVREQTYPE_PARENT;
            boolean isUpserted = ITSMSUtilityClass.upsertCase(submitCase);

            Test.startTest();
            PageReference pageRef= Page.ITSMSCaseDetail;
            Test.setCurrentPage(pageRef);
            ApexPages.StandardController sc = new ApexPages.StandardController(submitCase);
			ITSMSCaseDetailController cdc = new ITSMSCaseDetailController(sc);
            ApexPages.currentPage().getParameters().put('caseId', submitCase.Id);
        
			//-- verify controller
			cdc.thisCase = [Select Id, Status, ServiceRequestType__c from Case where Id = :submitCase.Id limit 1];
			cdc.checkCase();
        }
    }
}