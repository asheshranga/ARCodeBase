/*
 * Class ITSMSConferencingComponentControllerTest
 * 
 * @version 1.0
 * @author  Dianna Guilinger - Slalom  
 * 
 *  Verifies functionality and code coverage for ITSMSConferencingComponentController 
 */
@isTest
private class ITSMSConferencingComponentControllerTest {
    static testMethod void testConferencingComponentSave() {          
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
            ITSMSConferencingComponentController ccc = new ITSMSConferencingComponentController();
            //-- verify controller
            ccc.caseRec = ITSMSUtilityClass.createCase('Conferencing','Test');
            ccc.pageController = new ITSMSPageControllerBase ();
            ccc.key = 'testing';
            ccc.componentToPage = new ITSMSComponentToController ();
            ccc.caseRec.IssueOrRequest__c = 'Request';
            ccc.caseRec.ManagerUser__c = communityUser.Delegate__c;
            ccc.caseRec.EventTitle__c = 'Testing';
            ccc.caseRec.Description = 'Testing';
            ccc.caseRec.ConferenceRoomSetupTime__c = system.Now();
            ccc.caseRec.StartDateTime__c = system.Now();
            ccc.caseRec.EndDateTime__c = system.Now();
            ccc.caseRec.Attendees__c = 3;
            ccc.caseRec.VTCRoom__c = 'Testing';
            ccc.caseRec.WebExRequired__c = 'Yes';
            ccc.caseRec.WebExMeetingNumber__c = 'Testing';
            ccc.caseRec.HostPasscode__c = 'Testing';
            ccc.caseRec.WebexInformation__c = 'Testing';
            ccc.saveOnly();
            list<Case> testCases = [Select Id, Subject, Status, ParentId from Case];
            system.debug('@@ after save:'+testCases);
            // verify 2 cases created and status is 'Pending Submission'
            system.assertEquals(testCases.size(),2);
            system.assertEquals(testCases[0].Status,'Pending Submission');
            system.assertEquals(testCases[1].Status,'Pending Submission');
            ccc.saveAndNew();
            testCases = [Select Id, Subject, Status, ParentId from Case];
            ccc.caseRec.EventTitle__c = 'Testing';
            ccc.caseRec.Description = 'Testing';
            ccc.caseRec.ConferenceRoomSetupTime__c = system.Now();
            ccc.caseRec.StartDateTime__c = system.Now();
            ccc.caseRec.EndDateTime__c = system.Now();
            ccc.caseRec.Attendees__c = 3;
            ccc.caseRec.VTCRoom__c = 'Testing';
            ccc.caseRec.WebExRequired__c = 'Yes';
            ccc.caseRec.WebExMeetingNumber__c = 'Testing';
            ccc.caseRec.HostPasscode__c = 'Testing';
            ccc.caseRec.WebexInformation__c = 'Testing';
            ccc.componentToPage.childCases = [Select Id, Status, ParentId from Case];
            ccc.componentToPage.parentId = null;
            ccc.cancelCase();
            testCases = [Select Id, Subject, Status, ParentId from Case];
            system.debug('@@ after cancel:'+testCases);
            // verify 2 cases created and status is 'Pending Submission'
        }           
     }
    static testMethod void testConferencingComponentSubmit() {          
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
            ITSMSConferencingComponentController ccc = new ITSMSConferencingComponentController();
            //-- verify controller
            ccc.caseRec = ITSMSUtilityClass.createCase('Conferencing','Test');
            ccc.pageController = new ITSMSPageControllerBase ();
            ccc.key = 'testing';
            ccc.componentToPage = new ITSMSComponentToController ();
            ccc.caseRec.IssueOrRequest__c = 'Request';
            ccc.caseRec.EventTitle__c = 'Testing';
            ccc.caseRec.Description = 'Testing';
            ccc.caseRec.ConferenceRoomSetupTime__c = system.Now();
            ccc.caseRec.StartDateTime__c = system.Now();
            ccc.caseRec.EndDateTime__c = system.Now();
            ccc.caseRec.Attendees__c = 3;
            ccc.caseRec.VTCRoom__c = 'Testing';
            ccc.caseRec.WebExRequired__c = 'Yes';
            ccc.caseRec.WebExMeetingNumber__c = 'Testing';
            ccc.caseRec.HostPasscode__c = 'Testing';
            ccc.caseRec.WebexInformation__c = 'Testing';
            ccc.saveAndSubmit();
            list<Case> testCases = [Select Id, Subject, Status, ParentId from Case];
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