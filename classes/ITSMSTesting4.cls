@isTest
private class ITSMSTesting4 {
    // coverage for ITSMSWorkstationCompController 
    static testMethod void testWorkstationSubmit() {          
        ITSMSTestDataSetup.createTestConstants();
        // create test data - requestor, requestedFor, delegates
        ITSMSTestDataSetup.createRequestor();
        User communityUser = [select Id,  Delegate__c from User where FirstName = 'Community'];
        Contact communityContact = [Select Id, FirstName, ContactUser__c from Contact where ContactUser__c =: communityUser.Id Limit 1];
		
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
            ccc.caseRec.ContactId  = communityContact.Id;
            ccc.saveOnly();
            ccc.saveAndSubmit();
            String sysadmProfileId = [Select Id from Profile WHERE Name = 'System Administrator'].Id;
            User sysAdmin = [Select Id from User where ProfileId = :sysadmProfileId and IsActive = true limit 1];
            system.runAs (sysAdmin) 
            {
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
}