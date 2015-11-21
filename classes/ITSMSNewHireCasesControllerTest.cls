/*
 * Class ITSMSNewHireCasesControllerTest
 * 
 * @version 1.0
 * @author  Dianna Guilinger - Slalom  
 *
 *  tests code coverage for ITSMSNewHireCases
 * 
 */
@isTest (SeeAllData=true)
private class ITSMSNewHireCasesControllerTest {
    static testMethod void testNewHireCases() {          
        ITSMSTestDataSetup.createTestConstants();
    	// create test data - requestor, requestedFor, delegate
        ITSMSTestDataSetup.createRequestor();
        User requestor = [select Id, ManagerId from User where FirstName = 'Requestor'];
        system.runAs (requestor)
        {

			// create submitted Case 
	        ITSMSTestDataSetup.createNewHireSubmitted();
            Test.startTest();
            PageReference pageRef= Page.ITSMSNewHireCases;
            Test.setCurrentPage(pageRef);
            ITSMSNewHireCasesController mcc = new ITSMSNewHireCasesController();
        
			//-- verify controller 
            system.assert(mcc != null); 
            mcc.totalPages = 1;
            mcc.refresh();
            mcc.next();
            mcc.previous();
            mcc.first();
            mcc.last();
            mcc.getStatuses();
            mcc.getYears();
            mcc.toggleSort();
            mcc.checkQueryFilters();
            mcc.filterYear = '2015';
            mcc.checkQueryFilters();
            mcc.filterStatus = 'New';
            mcc.checkQueryFilters();
            mcc.searchText='Test';
            //mcc.runSearch();
            mcc.caseDetail();
            boolean chk = mcc.hasNext;
            boolean chk2 = mcc.hasPrevious;
            integer pn = mcc.pageNumber;
        }
    }
}