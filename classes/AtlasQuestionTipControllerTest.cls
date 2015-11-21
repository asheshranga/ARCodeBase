@isTest
    public class AtlasQuestionTipControllerTest {
        public static testMethod void testMethod1() {  
        	Test.startTest(); 
            User userObj;
	    	 System.runAs(TestDataManager.adminTestUser1) {
	    	    userObj = TestDataManager.createPortalUser('Test Account 1', 'John', 'Smith', 'john@viasat.com', 
		                                                   'JohnP', 'SmithP', '11111111', '11111111',
		                                                   '8003334444', 'myfed@devatlas.exede.net');
	    	 }
	    	 string userIdtest=string.valueOf(userObj.Id);
	    	 string userIdtest1=userIdtest.substring(0,15);
	    	 NPSContent__c content1= new NPSContent__c(QuestionId__c='Test',Type__c='Question',Text__c='TestQuestion'); 
             NPSContent__c content2= new NPSContent__c(Type__c='Tip',Text__c='Test',Link__c='Test',LinkText__c='Test');
             insert content1;
             insert content2; 
             NPSResponse__c response1= new NPSResponse__c(QuestionId__c='Test',ResponseType__c='Answer',ResponseValue__c='5',userId__c=userIdtest1);
             
             insert response1;
             
             
             AtlasQuestionTipController c = new AtlasQuestionTipController();
             AtlasMainDTO mainDTO= new AtlasMainDTO();
             c.mainDTOObj=mainDTO;
             mainDTO.contactId=userObj.ContactId;
             c.checkExistingAnswers=true;
             c.selectedValue='5';
             c.userId=userObj.id;
             c.loadQuestionorTip();
             c.modFunction();
             c.skipNPS(); 
             c.submitNPS(); 
             Test.stopTest();            
         }
         public static testMethod void testMethod2() {  
         	Test.startTest();
         	User userObj2;     	
         	System.runAs(TestDataManager.adminTestUser2) { 
         		userObj2 = TestDataManager.createPortalUser('Test Account 2', 'John1', 'Smith1', 'john@viasat.com', 
		                                                   'JohnP', 'SmithP', '111111115', '111111115',
		                                                   '8003334444', 'myfed@devatlas.exede.net'); 
         	}  
         	string userId2=string.valueOf(userObj2.Id);
	    	string userId22=userId2.substring(0,15);
         	NPSResponse__c response2= new NPSResponse__c(ResponseType__c='Skip',userId__c=userId22); 
         	insert response2;   		       	
     		AtlasQuestionTipController q = new AtlasQuestionTipController();
     		AtlasMainDTO mainDTO= new AtlasMainDTO();
         	q.mainDTOObj=mainDTO;
         	mainDTO.contactId=userObj2.ContactId; 
     		q.loadQuestionorTip(); 
     		Test.stopTest();
         } 
        
    }