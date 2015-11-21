@isTest
private class SalesforceRequestFormControllerTest {

    
    static testmethod void testSalesforceRequestFormController()
    {
     CaseKeyValueStore__c cs1 = new CaseKeyValueStore__c();   
	 cs1.name = 'SALESFORCE_SUPPORT_RT_NAME';
     cs1.value__c = 'Salesforce Support';
     insert cs1; 
        
      CaseKeyValueStore__c cs2 = new CaseKeyValueStore__c();   
	 cs2.name = 'SF_REQ_FORM_BUS_JUST_NEEDED_ERROR';
     cs2.value__c = 'Business Justification is required for the selected Category.';
     insert cs2;  
        
       CaseKeyValueStore__c cs3 = new CaseKeyValueStore__c();   
	 cs3.name = 'SF_REQ_FORM_CONFIRM_MESSAGE';
     cs3.value__c = 'Your case has been created. You could add attachments to it. Please contact salesforce.support@viasat.com if you have any questions.';
     insert cs3;  
        
         CaseKeyValueStore__c cs4 = new CaseKeyValueStore__c();   
	 cs4.name = 'SF_REQ_FORM_DATA_MANAGEMENT';
     cs4.value__c = 'Data Management';
     insert cs4;  
        
         CaseKeyValueStore__c cs5 = new CaseKeyValueStore__c();   
	 cs5.name = 'SF_REQ_FORM_DEF_ORIGIN';
     cs5.value__c = 'Web';
     insert cs5;  
        
         CaseKeyValueStore__c cs6 = new CaseKeyValueStore__c();   
	 cs6.name = 'SF_REQ_FORM_ENHANCEMENT';
     cs6.value__c = 'Enhancement';
     insert cs6;  
        
         CaseKeyValueStore__c cs7 = new CaseKeyValueStore__c();   
	 cs7.name = 'SF_REQ_FORM_GENERIC_ERROR';
     cs7.value__c = 'Your case could not be created. Please contact salesforce.support@viasat.com.';
     insert cs7;  
      
      Test.startTest();  
      Case c = new Case();
      ApexPages.StandardController sc= new ApexPages.StandardController(c);
      SalesforceRequestFormController sCont = new SalesforceRequestFormController(sc);
      sCont.cCase.suppliedName = 'Test';
      sCont.cCase.suppliedEmail = 'test@example.com';
      sCont.cCase.Type = 'BPEL';
      sCont.cCase.Category__c = 'Enhancement (BPEL)';
      sCont.cCase.Date_Needed_By__c = System.today() +7;
      sCont.cCase.Priority = 'Medium';
      sCont.cCase.subject = 'Test';
      sCont.cCase.description = 'Test';
      sCont.cCase.Business_Justification__c = 'Test'; 
        
      sCont.handleCategoryChange();
      System.assert(sCont.isBusJustRequired  );
        
      sCont.createCase();
      System.assert(sCont.cCase.id != null);
        
      System.assert(sCont.getStepTwoMessage() != null);
      
      PageReference pg = sCont.redirectHome();
      System.assert(pg != null);  
        
      sCont.attachmentToInsert.Name = 'Unit Test Attachment';
      sCont.attachmentToInsert.Body = Blob.valueOf('Unit Test Attachment Body');  
        
      sCont.addAttachment(); 
      List<attachment> attList = sCont.getListOfAttachments();
      System.assert(!attList.isEmpty());  
      Test.stopTest();  
    }
}