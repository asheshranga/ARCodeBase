/* @version 1.0
 * @author  Dianna Guilinger - Slalom  
 * 
 *  Verifies code coverage for class ITSMSNewHireCaseComplete. Performs the following 
 *  tests:
 *  1. Child Case for New Hire AD Account where entry of Email results in search for Contact 
 *      that is found. This case is closed, additional child cases are created, contact is updated.
 *  2. Child Case for New Hire AD Account where entry of Email does not find a corresponding Contact.
 *      No change to case occurs. No additional child cases are created.
 *  3. Child Case for New Hire AD Account is modified and Email is not entered.  No change to cases occurs.
 *      No additional child cases are created.
 *  4. Case not 'AD Account' with New Hire parent is modified.  No change to case. No additional child cases are created.
 *  5. Case not 'AD Account' without parent is modified.  No change to case. 
 */
@isTest
private class ITSMSNewHireCaseCompleteTest {
    
    static testMethod void testNewHireComplete() {          
        ITSMSTestDataSetup.createTestConstants();
        // create test contact        
            ITSMSTestDataSetup.createTestContact();
            // create test parent case, set Requestor with manager/delegate 
            ITSMSTestDataSetup.createNewHireSubmitted();
            Case pc1 = [Select Id, Subject, Type, Origin, RecordTypeId, Requestor__c, 
                            RequestingForUser__c, ManagerUser__c, Category__c, CategoryDetails__c  
                       from Case where FirstName__c = 'Submitted' and LastName__c = 'Employee'];
            update pc1;
        
                 // create child case for 'AD Account'
                Case cc1 = new Case (Subject='Test 1 Child Case',ParentId=pc1.Id, RecordTypeId=pc1.RecordTypeId,  Status='New', 
                                        ServiceRequestType__c='AD Account');
                insert cc1;
                Test.startTest();
                // populate new hire email on AD case
                cc1.NewHireEmail__c='testContact@testing.com';
                cc1.OwnerId = UserInfo.getUserId();
                update cc1;
                Case cc1a = [Select Id, ParentId, Subject, Status, ServiceRequestType__c 
                           from Case where Id = :cc1.Id limit 1];
                system.assertEquals(cc1a.Status,'Closed');
                Case pc1a = [Select Id, Subject, Status, NewHireContact__c  
                               from Case where Id = :cc1.ParentId];
                system.assert(pc1a.NewHireContact__c != null);
    }
}