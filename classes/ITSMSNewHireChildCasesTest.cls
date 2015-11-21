/*
 * Class ITSMSNewHireChildCasesTest
 * 
 * @version 1.0
 * @author  Dianna Guilinger - Slalom  
 * 
 *  Verifies class ITSMSNewHireChildCases.  
 */
@isTest
private class ITSMSNewHireChildCasesTest {
    static testMethod void testNewHireChildCasesAll() {          
        ITSMSTestDataSetup.createTestConstants();
        // create test data - requestor, requestedFor, delegate
        ITSMSTestDataSetup.createRequestor();
        User requestor = [select Id, ManagerId from User where FirstName = 'Requestor'];
        ITSMSTestDataSetup.createAdmins();
        User admin = [select Id from User where FirstName = 'Admin'];
        system.runAs (requestor)
        {
            // create test where all child cases will be created
            ITSMSTestDataSetup.createNewHireSubmitted();
            Case ce = [Select Id, CreatedById from Case where FirstName__c = 'Submitted' and LastName__c = 'Employee' limit 1];
            ce.FirstName__c = 'TestA';
            ce.MiddleNameInitial__c = 'A';
            // set requestor
            ce.Requestor__c = requestor.Id;
            // desktop
            ce.DeskPhone__c = 'Yes';
            ce.WirelessHeadset__c = 'Yes';
            // access admin
            ce.IsRemoteAccessRequired__c = 'Yes';
            ce.WIKIRequired__c = 'Yes';
            ce.JustificationWIKIURLs__c = 'testing WIKI access';
            ce.SecurityGroups__c ='Testing';
            // Perforce
            ce.IsPerforceAccessRequired__c = 'Yes';
            ce.PerforceServerFolders__c = 'freeform text'; 
            // agile
            ce.AgileAccessRequired__c = 'Yes';
            ce.AgileAccessLevel__c= 'Access Level 1';
            ce.AgileModelUser__c= requestor.ManagerId;
            ce.OracleASCPResponsibilities__c= 'Testing';
            ce.OracleEBSResponsibilities__c= 'Testing';
            ce.OracleOBIEEResponsibilities__c= 'Testing';
            // subscriber/backoffice
            ce.BackofficeSystemDetails__c = 'Exede/Denver';
            ce.BackofficeSystemsAccess__c = 'freeform text';
            ce.ExedeBackOfficeJumpBox__c = 'freeform text'; 
            // telecom
            ce.NOCAgents__c= True;
            ce.AgentToMirror__c = requestor.ManagerId;
            ce.AdditionalSoftware1__c = 'testing';
            update ce;
            // create case with form where only wireless option is selected 
            ITSMSTestDataSetup.createNewHireSubmitted();
            Case ce2 = [Select Id, CreatedById from Case where FirstName__c = 'Submitted' and LastName__c = 'Employee' limit 1];
            ce2.FirstName__c = 'TestB';
            //    --desktop
            ce2.DeskPhone__c = 'No';
            ce2.WirelessHeadset__c = 'Yes';
            ce2.PCModelType__c = 'No PC Required';
            ce2.IsRemoteAccessRequired__c = 'No';
            ce2.WIKIRequired__c = 'No';
            ce2.IsPerforceAccessRequired__c = 'No';
            ce2.AgileAccessRequired__c = 'No';
            ce2.BackofficeSystemDetails__c = 'Exede/Denver';
            update ce2;

            // create form where only PC Model Laptop option is selected 
            ITSMSTestDataSetup.createNewHireSubmitted();
            Case ce3 = [Select Id, CreatedById from Case where FirstName__c = 'Submitted' and LastName__c = 'Employee' limit 1];
            ce3.FirstName__c = 'TestC';
            ce3.DeskPhone__c = 'No';
            ce3.WirelessHeadset__c = 'No';
            ce3.PCModelType__c = 'Laptop';
            ce3.PCModel__c = 'HP 820';
            ce3.IsRemoteAccessRequired__c = 'No';
            ce3.WIKIRequired__c = 'No';
            ce3.IsPerforceAccessRequired__c = 'No';
            ce3.AgileAccessRequired__c = 'No';
            ce3.BackofficeSystemDetails__c = 'Exede/Denver';
            update ce3;

            // get all test cases, build set of Ids 
            list<Case> testCases = new list<Case> ([Select Id from Case]);
            set<Id> testCaseIds = new set<Id>();
            for (Case c:testCases)
            {
                testCaseIds.add(c.Id);
            }
            //*** start test
            Test.startTest();
            system.debug('@@ start test:'+testCaseIds);
            ITSMSNewHireChildCases.createCases(testCaseIds);
     		list<Case> allCases = [Select Id, Status, ParentId from Case];
            system.debug('@@ test cases:'+allCases);
            system.debug('@@ test case ce:'+ce.Id);
            list<Case> childCasesTest1 = new list<Case> ([Select Id, ParentId from Case where ParentId = :ce.Id]);
            system.assert(childCasesTest1.size() >1 ); 

            list<Case> childCasesTest2 = new list<Case> ([Select Id, ParentId from Case where ParentId = :ce2.Id]);
            system.assert(childCasesTest2.size() >1 ); 
            list<Case> childCasesTest3 = new list<Case> ([Select Id, ParentId from Case where ParentId = :ce3.Id]);
            system.assert(childCasesTest3.size() > 1); 
        }
    }
}