@isTest
private class  ITSMSTesting1 {
    // coverage for ITSMSRequestHeaderComponentController 
    static testMethod void testRequestHeaderComp() {          
        ITSMSTestDataSetup.createTestConstants();
        // create test data - requestor, requestedFor, delegates
        ITSMSTestDataSetup.createRequestor();
        User communityUser = [select Id,  Delegate__c from User where FirstName = 'Community'];
		ITSMSTestDataSetup.createAdmins();
        User admin = [Select Id from User where FirstName = 'Admin' limit 1];
        system.runAs (admin) {
            ITSMSTestDataSetup.createTestContact();
            Contact userContact = [Select Id, ContactUser__c, FirstName, LastName from Contact limit 1];
            userContact.ContactUser__c = communityUser.Id;
            userContact.FirstName = 'Community';
            userContact.LastName = 'User';
            update userContact;
        }
        system.runAs (communityUser)
        {
            // create a test case ma
            ITSMSTestDataSetup.createTestCase();
            Case testCase = [Select Id, Subject, Requestor__c from Case limit 1];
           	system.assertEquals(testCase.Requestor__c,communityUser.Id);
            testCase.Subject = 'HeaderTest';
            update testCase;
            //*** start test
            Test.startTest();
            PageReference pageRef= Page.ITSMSSupportRequest;
            Test.setCurrentPage(pageRef);
            ITSMSRequestHeaderComponentController rhc = new ITSMSRequestHeaderComponentController();
            //-- verify controller
            rhc.pageController = new ITSMSPageControllerBase ();
            rhc.key = 'testing';
            rhc.componentToPage = new ITSMSComponentToController ();
            rhc.caseRec = ITSMSUtilityClass.getExistingCase(ITSMSConstants.SUPPORT_QUERY +' from Case where Id = :inputCaseId Limit 1', testCase.Id);
            rhc.formatHeader();
            rhc.checkCase();
            system.assertNotEquals(rhc.requestorLocation,null);
        }           
     }


}