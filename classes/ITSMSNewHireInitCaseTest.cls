/*
 * Class ITSMSNewHireInitCaseTest
 * 
 * @version 1.0
 * @author  Dianna Guilinger - Slalom  
 * 
 *  Verifies functionality and code coverage for New Hire Init Case 
 */
@isTest
private class ITSMSNewHireInitCaseTest {
    static testMethod void testNewHireInitEmployee() {          
        ITSMSTestDataSetup.createTestConstants();
		// create test data - requestor, requestedFor, delegate
        ITSMSTestDataSetup.createRequestor();
        User requestor = [select Id, ManagerId from User where FirstName = 'Community' and LastName = 'User'];
        system.runAs (requestor)
        {
            // create - Case as Submitted
            ITSMSTestDataSetup.createNewHireSubmitted();
            Case ce = [Select Id, CreatedById from Case where FirstName__c = 'Submitted' and LastName__c = 'Employee'];
            // set requestor
            ce.Requestor__c = requestor.Id;
            update ce;       
			ce = ITSMSUtilityClass.getExistingCase(ITSMSConstants.NEWHIRE_QUERY +' from Case where Id = :inputCaseId', ce.Id);
			system.debug('@@ test parent:'+ce);

			//*** start test
        	Test.startTest();
  	        Case childCase = ITSMSNewHireInitCase.createInitialNewHireCase(ce);
            system.debug('@@ emp:'+childCase);
        	system.assert(childCase.ParentId == ce.Id); 
        }
    }
    static testMethod void testNewHireInitContractor() {          
        ITSMSTestDataSetup.createTestConstants();
		// create test data - requestor, requestedFor, delegate
        ITSMSTestDataSetup.createRequestor();
        User requestor = [select Id, ManagerId from User where FirstName = 'Requestor'];
        system.runAs (requestor)
        {
            // create - Case as Submitted
            ITSMSTestDataSetup.createNewHireSubmitted();
            Case cc = [Select Id from Case where FirstName__c = 'Submitted' and LastName__c = 'Employee'];
            // change case to be for contractor
            cc.Requestor__c = requestor.Id;
            cc.CompanyName__c = 'ConsultantCompany';
            cc.CompanyEmail__c = 'consult@testing.com';
            cc.WorkEndDate__c = date.newInstance(2016,08,20);
            update cc;       
			cc = ITSMSUtilityClass.getExistingCase(ITSMSConstants.NEWHIRE_QUERY +' from Case where Id = :inputCaseId', cc.Id);
			system.debug('@@ test parent:'+cc);
            //*** start test
        	Test.startTest();
  	        Case childCase = ITSMSNewHireInitCase.createInitialNewHireCase(cc);
            system.debug('@@ emp:'+childCase);
        	system.assert(childCase.ParentId == cc.Id); 
        }
    }
}