@isTest
private class  ITSMSTesting2 {
    // coverage for ITSMSSupportRequestController 
    static testMethod void testSupportRequestBasic() {
        ITSMSTestDataSetup.createTestConstants();
        // create test data - requestor, requestedFor, delegate
        ITSMSTestDataSetup.createRequestor();
        User requestor = [select Id, ManagerId from User where FirstName = 'Requestor'];

        system.runAs (requestor)
        {
            // create a parent case
            ITSMSTestDataSetup.createTestCase();
            Case testParent = [Select Id, Subject from Case limit 1];
            testParent.Subject = 'ParentCase';
            update testParent;
            // create children to parent  
            ITSMSTestDataSetup.createTestCase();
            Case testChild = [Select Id, Subject from Case where Subject != 'ParentCase' limit 1];
            testChild.Subject = 'ChildCase1';
            testChild.ParentId = testParent.Id;
            update testChild;
            ITSMSTestDataSetup.createTestCase();
            Case testChild2 = [Select Id, Subject from Case where Subject != 'ParentCase' AND Subject != 'ChildCase1' limit 1];
            testChild2.Subject = 'ChildCase2';
            testChild2.ParentId = testParent.Id;
            update testChild2;
            //*** start test
            Test.startTest();
            PageReference pageRef= Page.ITSMSSupportRequest;
            Test.setCurrentPage(pageRef);
            ApexPages.currentPage().getParameters().put('Category', 'General');
            // test 1.  No existing case 
            ITSMSSupportRequestController e = new ITSMSSupportRequestController();
            // test 2.  Existing case that is parent
            ApexPages.currentPage().getParameters().put('Id', testParent.Id);
            ITSMSSupportRequestController e2 = new ITSMSSupportRequestController();
            // test 3.  Existing case that is not parent
            ApexPages.currentPage().getParameters().put('Id', testChild.Id);
            ITSMSSupportRequestController e3= new ITSMSSupportRequestController();
            
            // test 4.  Edit case that is child
            ApexPages.currentPage().getParameters().put('EditCaseId',testChild.Id);
            ITSMSSupportRequestController e4= new ITSMSSupportRequestController();
            e4.componentToPage.caseRec = ITSMSUtilityClass.getExistingCase(ITSMSConstants.SUPPORT_QUERY +' from Case where Id = :inputCaseId Limit 1', testChild.Id);
            set<Id> parentIds = new set <Id> ();
            parentIds.add(testParent.Id);
            e4.componentToPage.childCases = ITSMSUtilityClass.getCases(ITSMSConstants.SUPPORT_QUERY +' from Case where ParentId = :caseIds', parentIds);
            e4.editCase();
            // test 5.  Delete case that is not last child
            ApexPages.currentPage().getParameters().put('DeleteCaseId',testChild.Id);
            ITSMSSupportRequestController e5= new ITSMSSupportRequestController();
            e5.componentToPage.caseRec = ITSMSUtilityClass.getExistingCase(ITSMSConstants.SUPPORT_QUERY +' from Case where Id = :inputCaseId Limit 1', testChild.Id);
            parentIds = new set <Id> ();
            parentIds.add(testParent.Id);
            e5.componentToPage.childCases = ITSMSUtilityClass.getCases(ITSMSConstants.SUPPORT_QUERY +' from Case where ParentId = :caseIds', parentIds);
            e5.editCase();
            e5.deleteCase();
            // test 5.  Delete case that is last child
            ApexPages.currentPage().getParameters().put('DeleteCaseId',testChild2.Id);
            ITSMSSupportRequestController e6= new ITSMSSupportRequestController();
            e6.componentToPage.caseRec = ITSMSUtilityClass.getExistingCase(ITSMSConstants.SUPPORT_QUERY +' from Case where Id = :inputCaseId Limit 1', testChild.Id);
            parentIds = new set <Id> ();
            parentIds.add(testParent.Id);
            e6.componentToPage.childCases = ITSMSUtilityClass.getCases(ITSMSConstants.SUPPORT_QUERY +' from Case where ParentId = :caseIds', parentIds);
            e6.editCase();
            e6.deleteCase();
            list<Case> deletedCases = [Select Id, Subject from Case];
            system.assertEquals(deletedCases.size(),0);
        }
    }

    // coverage for ITSMSSupportRequestController 
    static testMethod void testSupportRequestSubmitAll() {
        ITSMSTestDataSetup.createTestConstants();
        // create test data - requestor, requestedFor, delegate
        ITSMSTestDataSetup.createRequestor();
        User requestor = [select Id, ManagerId from User where FirstName = 'Requestor'];

        system.runAs (requestor)
        {
            Test.startTest();
            // create a parent case
            ITSMSTestDataSetup.createTestCase();
            String sysadmProfileId = [Select Id from Profile WHERE Name = 'System Administrator'].Id;
            User sysAdmin = [Select Id from User where ProfileId = :sysadmProfileId and IsActive = true limit 1];
            system.runAs (sysAdmin) 
            {
                Case testParent = [Select Id, Subject from Case limit 1];
                testParent.Subject = 'ParentCase';
                update testParent;
            
                // create 2 children to parent  
                ITSMSTestDataSetup.createTestCase();
                Case testChild1 = [Select Id, Subject from Case where Subject != 'ParentCase' limit 1];
                testChild1.Subject = 'ChildCase1';
                testChild1.ParentId = testParent.Id;
                update testChild1;
                // create 2 children to parent  
                ITSMSTestDataSetup.createTestCase();
                Case testChild2 = [Select Id, Subject from Case where Subject != 'ParentCase' and Subject != 'ChildCase1' limit 1];
                testChild2.Subject = 'ChildCase2';
                testChild2.ParentId = testParent.Id;
                update testChild2;
            
            	PageReference pageRef= Page.ITSMSSupportRequest;
            	Test.setCurrentPage(pageRef);
            	ApexPages.currentPage().getParameters().put('Category', 'General');
            	// test  Existing case that is child
                ApexPages.currentPage().getParameters().put('Id', testChild1.Id);
            	ITSMSSupportRequestController e1= new ITSMSSupportRequestController();
                e1.componentToPage.caseRec = ITSMSUtilityClass.getExistingCase(ITSMSConstants.SUPPORT_QUERY +' from Case where Id = :inputCaseId Limit 1', testChild1.Id);
                set<Id> parentIds = new set <Id> ();
                parentIds.add(testParent.Id);
                e1.componentToPage.childCases = ITSMSUtilityClass.getCases(ITSMSConstants.SUPPORT_QUERY +' from Case where ParentId = :caseIds', parentIds);
            	e1.submitAll();
                List<Case> testSubmit = [Select Id, Status, ParentId from Case where ParentId =: testChild1.ParentId];
                system.debug('@@ found children'+testSubmit);
                system.assertEquals(testSubmit.size(),2);
                system.assertEquals(testSubmit[0].Status,'New');
                system.assertEquals(testSubmit[1].Status,'New');
				e1.setIssueType();
            }
        }    
    }

}