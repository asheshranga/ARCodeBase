/*
 * Class ITSMSSupportRequestControllerTest
 * 
 * @version 1.0
 * @author  Dianna Guilinger - Slalom  
 * 
 *  Verifies functionality and code coverage for ITSMSSupportRequest 
 *   will use category of General for this test 
 */

@isTest
private class ITSMSSupportRequestControllerTest {
    
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
            // create a child to parent  
            ITSMSTestDataSetup.createTestCase();
            Case testChild = [Select Id, Subject from Case where Subject != 'ParentCase' limit 1];
            testChild.Subject = 'ChildCase';
            testChild.ParentId = testParent.Id;
            update testChild;
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
          	//  e4.editCase();
			// test 5.  Delete case that is child
            ApexPages.currentPage().getParameters().put('DeleteCaseId',testChild.Id);
        	ITSMSSupportRequestController e5= new ITSMSSupportRequestController();
            e5.deleteCase();
            
        }
    }
        static testMethod void testSupportRequestSubmitAll() {
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
            //*** start test
        	Test.startTest();
        	PageReference pageRef= Page.ITSMSSupportRequest;
        	Test.setCurrentPage(pageRef);
	        ApexPages.currentPage().getParameters().put('Category', 'General');
			// test  Existing case that is child
	        ApexPages.currentPage().getParameters().put('Id', testChild1.Id);
        	ITSMSSupportRequestController e1= new ITSMSSupportRequestController();
            e1.submitAll();
            List<Case> testSubmit = [Select Id, Status, ParentId from Case where ParentId =: testChild1.ParentId];
            system.debug('@@ found children'+testSubmit);
            system.assertEquals(testSubmit.size(),2);
            system.assertEquals(testSubmit[0].Status,'New');
            system.assertEquals(testSubmit[1].Status,'New');

                
        }
    }

}