/*
 * Class ITSMSUtilityClassTest
 * 
 * @version 1.0
 * @author  Dianna Guilinger - Slalom  
 * 
 *  Verifies functionality and code coverage for Utility Class 
 */
@isTest
private class ITSMSUtilityClassTest {
    static testMethod void testUpsertCase() {          
        ITSMSTestDataSetup.createTestConstants();
		// create test data - requestor, requestedFor, delegate
        ITSMSTestDataSetup.createRequestor();
        User requestor = [select Id, ManagerId from User where FirstName = 'Requestor'];
        system.runAs (requestor)
        {
            // create - Case as Submitted
            ITSMSTestDataSetup.createNewHireSubmitted();
            Case ce = [Select Id, CreatedById from Case where FirstName__c = 'Submitted' and LastName__c = 'Employee'];
            system.assertNotEquals(ce,null);
        }
    }
}