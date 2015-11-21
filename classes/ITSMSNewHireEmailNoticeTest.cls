/* @version 1.0
 * @author  Dianna Guilinger - Slalom  
 * 
 *  Verifies code coverage for class ITSMSNewHireEmailNotice.  
 */
@isTest
private class ITSMSNewHireEmailNoticeTest {
    static testMethod void testNewHireEmailNotice() {          
        ITSMSTestDataSetup.createTestConstants();
		// create test users as Requestor, Requested For 
    	ITSMSTestDataSetup.createRequestor();
		User requestor = [Select Id from User where firstname = 'Requestor' and lastName = 'Creator' Limit 1];
    	system.runAs (requestor) 
    	{
			// create test parent case
        	ITSMSTestDataSetup.createNewHirePending();
			// create test new hire contact
            ITSMSTestDataSetup.createTestContact();
			Contact newHireContact = [Select Id from Contact where LastName = 'NewHire' Limit 1];
			Case parentCase = [Select Id from Case Limit 1];
        	set<Id> parentCaseIds = new set<Id>();
        	parentCaseIds.add(parentCase.Id);
			// set requestor and new hire contact on parent case 
			parentCase.NewHireContact__c = newHireContact.Id;
            parentCase.Requestor__c = requestor.Id;
            update parentCase;
			// create child case
			ITSMSTestDataSetup.createNewHirePending();  
        	Case childCase = [Select Id, ParentId from Case where Id != :parentCase.Id limit 1];
			childCase.ParentId = parentCase.Id;
        	update childCase;
			//*** start test
        	Test.startTest();
        	system.debug(' **** start of Email test ***');
        	ITSMSNewHireEmailNotice.sendNewHireNotice(parentCaseIds);
        }
    }
}