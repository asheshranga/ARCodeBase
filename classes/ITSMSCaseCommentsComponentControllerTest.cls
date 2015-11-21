/*
 * Class ITSMSCaseCommentsComponentControllerTest
 * 
 * @version 1.0
 * @author  Dianna Guilinger - Slalom  
 *
 *  Usage: tests code coverage for ITSMSCaseComments
 */
@IsTest
public class ITSMSCaseCommentsComponentControllerTest {
	private static testMethod void testController()
  	{
        ITSMSTestDataSetup.createTestConstants();
    	// create test data - requestor, requestedFor, delegate
        ITSMSTestDataSetup.createRequestor();
        User requestor = [select Id, ManagerId from User where FirstName = 'Requestor'];
		// create basic Case 
		string inputCategory = ITSMSConstants.GENERAL_CATEGORY;
        string srvreqType = ITSMSConstants.SUPPORT_SRVREQTYPE_GENERAL;
        system.runAs (requestor)
        {
	        Case c = ITSMSUtilityClass.createCase(inputCategory, srvreqType);
            boolean isUpserted = ITSMSUtilityClass.upsertCase(c);
            Globals__c tempSkipValidation = new Globals__c (CaseMilestoneValidationIgnore__c=true);
            insert tempSkipValidation;
            
            list<CaseComment> comments = new list<CaseComment> {
                new CaseComment(CommentBody='TestComment1',IsPublished=True,ParentId = c.Id),
                new CaseComment(CommentBody='TestComment2',IsPublished=False,ParentId = c.Id)};
            insert comments;
            
    		ITSMSCaseCommentsComponentController controller=new ITSMSCaseCommentsComponentController();
	    	controller.caseId=c.id;
            //controller.comments= new list<ITSMSCaseCommentsComponentController.cComments>();
            system.assertEquals(2,controller.comments.size());
            system.assertEquals(false,controller.newCommentNeeded);
            controller.newComment();
            controller.saveComment();
            controller.cancelComment();
            
   		}
    }
}