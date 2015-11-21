/*
 * Class ITSMSNewHireRequestControllerTest
 * 
 * @version 1.0
 * @author  Dianna Guilinger - Slalom  
 * 
 *  Verifies functionality and code coverage for New Hire Request controller 
 */

@isTest
private class ITSMSNewHireRequestControllerTest {
    
    static testMethod void testNewHireRequest() {
        ITSMSTestDataSetup.createTestConstants();
        // create test data - requestor, requestedFor, delegate
        ITSMSTestDataSetup.createRequestor();
        User requestor = [select Id, ManagerId from User where FirstName = 'Requestor'];

        system.runAs (requestor)
        {
            // create - Case in Pending Submission Status
            ITSMSTestDataSetup.createNewHirePending();
            Case peC = [Select Id from Case where FirstName__c = 'Pending' and LastName__c = 'Employee'];
            // set requestor
            peC.Requestor__c = requestor.Id;
            update peC;       
            //*** start test
            Test.startTest();
            PageReference pageRef= Page.ITSMSNewHireRequest;
            Test.setCurrentPage(pageRef);
            // test 1.  No existing case 
            ITSMSNewHireRequestController e = new ITSMSNewHireRequestController();
            // set variables, save form
            e.caseRec.AdditionalComments__c ='testing';
            e.caseRec.DeskPhone__c = 'Yes';
            e.caseRec.EmployeeType__c='Regular';
            e.caseRec.NewHireType__c = 'Employee';
            e.caseRec.StartDate__c = date.newInstance(2015,08,20);
            e.saveRequest();
            // verify case submitted in 'Pending Submission' status on save
            system.assert(e.caseRec.Status == 'Pending Submission');

            // update fields required on submit
            e.caseRec.AgileAccessRequired__c = 'No';
            e.caseRec.DoYouApproveThisForm__c  = 'Yes';
            e.caseRec.DeskPhone__c = 'Yes';
            e.caseRec.WirelessHeadset__c = 'No';
            e.caseRec.PCModelType__c = 'No PC Required';
            e.caseRec.IsRemoteAccessRequired__c = 'Yes';
            e.caseRec.WIKIRequired__c = 'No';
            e.caseRec.IsPerforceAccessRequired__c = 'No';
            e.caseRec.AgileAccessRequired__c = 'No';
            e.caseRec.BackofficeSystemDetails__c = 'Exede/Denver';
            e.caseRec.BackofficeSystemsAccess__c = 'freeform text';
            e.caseRec.ExedeBackOfficeJumpBox__c = 'freeform text';
            e.caseRec.NOCAgents__c= True;
            e.caseRec.AgentToMirror__c = requestor.ManagerId;
            e.SubmitAndNew();
            // verify case submitted 
            system.assert(e.caseRec.Status == 'Submitted');
            // test with existing case
            PageReference pageRef2= Page.ITSMSNewHireRequest;
            Test.setCurrentPage(pageRef2);
            ApexPages.currentPage().getParameters().put('caseId', pec.Id);
            ITSMSNewHireRequestController e1 = new ITSMSNewHireRequestController();
            // set variables, submit form
            e1.caseRec.AdditionalComments__c ='testing';
            e1.caseRec.NewHireType__c = 'Contractor';
            e1.caseRec.EmployeeType__c='Consultant';
            e1.caseRec.StartDate__c = date.newInstance(2015,08,20);
            e1.caseRec.WorkEndDate__c = date.newInstance(2016,01,10);
            e1.caseRec.AgileAccessRequired__c = 'No';
            e1.caseRec.DoYouApproveThisForm__c  = 'Yes';
            e1.caseRec.PhysicalLocation__c = 'Testing';
            e1.caseRec.OfficeCubeNumber__c = 'Some cube';
            e1.caseRec.DepartmentName__c = 'test';
            e1.caseRec.Citizenship__c = 'test';
            e1.caseRec.DeskPhone__c = 'Yes';
            e1.caseRec.WirelessHeadset__c = 'No';
            e1.caseRec.PCModelType__c = 'No PC Required';
            e1.caseRec.OtherPCModelOS__c = 'freeform text';
            e1.caseRec.PCModel__c = 'freeform text';
            e1.caseRec.OtherHardware__c = 'freeform text';
            e1.caseRec.OracleEBSResponsibilities__c= 'read update delete';
            e1.caseRec.OracleOBIEEResponsibilities__c= 'read update delete';
            e1.caseRec.OracleASCPResponsibilities__c= 'read update delete';
            e1.caseRec.SecurityGroups__c = 'freeform text';
            e1.caseRec.DistributionGroup__c = 'freeform text';
            e1.caseRec.SharedMailboxes__c = 'freeform text';
            e1.caseRec.NetworkDirectoryAccessLevel__c = 'freeform text';
            e1.caseRec.IsRemoteAccessRequired__c = 'Yes';
            e1.caseRec.WIKIRequired__c = 'Yes';
            e1.caseRec.JustificationWIKIURLs__c = 'testing WIKI access';                                                      
            e1.caseRec.IsPerforceAccessRequired__c = 'Yes';
            e1.caseRec.PerforceServerFolders__c = 'freeform text';
            e1.caseRec.AgileAccessRequired__c = 'Yes';
            e1.caseRec.AgileAccessLevel__c= 'Access Level 1';
            e1.caseRec.AdditionalAgileRolesRequired__c = 'some roles here';
            e1.caseRec.AgileModelUser__c= requestor.ManagerId;
            e1.caseRec.BackofficeSystemDetails__c = 'Exede/Denver';
            e1.caseRec.BackofficeSystemsAccess__c = 'freeform text';
            e1.caseRec.ExedeBackOfficeJumpBox__c = 'freeform text';
            e1.caseRec.NOCAgents__c= True;
            e1.caseRec.AgentToMirror__c = requestor.ManagerId;
            e1.submitRequest();
            ApexPages.getMessages();
            system.debug('@@ error:'+pec.Id+' '+pec);
            list<Case> secondCase = [Select Id, Status, CreatedById, Requestor__c from Case];
            // verify case now in 'Submitted' status 
            //system.assert(secondCase.Status == 'Submitted');
        
            // test 3. Existing submitted case 
            PageReference pageRef3= Page.ITSMSNewHireRequest;
            Test.setCurrentPage(pageRef3);
            ApexPages.currentPage().getParameters().put('caseId', e.caseRec.Id);
            ITSMSNewHireRequestController e2 = new ITSMSNewHireRequestController();
            // test cancel 
            e2.cancelRequest();
        }
    }
}