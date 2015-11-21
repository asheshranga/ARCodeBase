/*
 * Class ITSMSMultiAttachmentComponentTest
 * 
 * @version 1.0
 * @author  Dianna Guilinger - Slalom  
 *
 *  Usage: tests code coverage for ITSMSMultiAttachment
 */
@IsTest
public class ITSMSMultiAttachmentComponentTest {
	private static testMethod void testMultiAttachController()
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
    		ITSMSMultiAttachmentComponentController controller=new ITSMSMultiAttachmentComponentController();
	    	controller.sobjId=c.id;
	    	system.assertEquals(0, controller.getAttachments().size());
    		system.assertEquals(3,controller.newAttachments.size());
    
    		controller.addMore();
    		system.assertEquals(6, controller.newAttachments.size());
    
    		// populate the first and third new attachments
    		List<Attachment> newAtts=controller.newAttachments;
    		newAtts[0].Name='Unit Test 1';
    		newAtts[0].Description='Unit Test 1';
    		newAtts[0].Body=Blob.valueOf('Unit Test 1');

    		newAtts[2].Name='Unit Test 2';
    		newAtts[2].Description='Unit Test 2';
    		newAtts[2].Body=Blob.valueOf('Unit Test 2');
    
   	 		controller.save();
    
    		system.assertEquals(2, controller.getAttachments().size());
  		}
    }
}