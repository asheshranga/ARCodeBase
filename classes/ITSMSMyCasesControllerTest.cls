/*
 * Class ITSMSMyCasesControllerTest
 * 
 * @version 1.0
 * @author  Dianna Guilinger - Slalom  
 *
 *  tests code coverage for ITSMSMyCases
 * 
 */
@isTest (SeeAllData=true)
private class ITSMSMyCasesControllerTest {
    static testMethod void testMyCases1 () {        
        ITSMSTestDataSetup.createTestConstants();
    	// create test data - requestor, requestedFor, delegate
        ITSMSTestDataSetup.createRequestor();
        User requestor = [select Id, ManagerId from User where FirstName = 'Requestor'];
        system.runAs (requestor)
        {

			// create submitted Case 
	        ITSMSTestDataSetup.createNewHireSubmitted();
	        ITSMSTestDataSetup.createNewHireSubmitted();
            Test.startTest();
            PageReference pageRef= Page.ITSMSMyCases;
            Test.setCurrentPage(pageRef);
            list<Case> c = [Select Id, Subject from Case];
            ApexPages.StandardSetController ssc = new ApexPages.Standardsetcontroller(c);
            ITSMSMyCasesController mcc = new ITSMSMyCasesController();
        
			//-- verify controller 
            system.assert(mcc != null); 
			system.assert(ssc != null);
            system.debug('@@ ready to test '+ssc);
            mcc.getCases();
            mcc.getStatuses();
            mcc.getYears();
            mcc.next();
            mcc.previous();
            mcc.first();
            mcc.last();
            mcc.filterYear = '2015';
            mcc.filterStatus = 'Submitted';
            mcc.checkQueryFilters();
            system.debug('@@ filter:'+mcc.foundCaseIds);
            mcc.refresh();
            mcc.searchText = null;
            system.debug('@@ search:'+mcc.foundCaseIds);
			mcc.toggleSort();
            system.assertEquals(false,mcc.hasNext);
            system.assertEquals(false,mcc.hasPrevious);
            system.assertEquals(1,mcc.pageNumber);
            mcc.caseDetail();
        }
    }
}