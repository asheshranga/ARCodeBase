@isTest
private class ITSMSTestTemp {
    // coverage for ITSMSContactUsInfoComponentController
    static testMethod void testContactUsInfoController(){
 	   ITSMSTestDataSetup.createTestConstants();
       ITSMSTestDataSetup.createAdmins();
        User admin = [SELECT Id, firstname FROM User WHERE firstname = 'knowledgeAdmin' ];    
        
        test.startTest();
        System.runAs(admin){
            LIST<String> sections = new LIST<String> {'Hours','Phone Number','Email','IT Support Personnel'};
            LIST<String> summaries = new LIST<String> {'5 a.m. to 12 a.m.', '1234567890','testEmail@test.com','test'};
            LIST<String> urls = new LIST<String>{'testURL1@test.com','testURL2@test.com','testUR3L@test.com','testURL4@test.com'};
            Integer numOfSections = sections.size();
            LIST<ITSMS__kav> contactArticles = new LIST<ITSMS__kav>();
            for(Integer i = 0; i < numOfSections ; i++){            
                ITSMS__kav contactArticle = new ITSMS__kav(Title = 'test article' + i, 
                                                         Summary = 'test summary ' + i, 
                                                         URL__c = 'testURL' + i, 
                                                         UrlName = 'testURLName' + i, 
                                                         Section__c = sections[i], 
                                                         Area__c = 'Contact Us',
                                                         Language = 'en_US',
                                                         IsVisibleInPkb = true,
                                                         IsVisibleInCsp = true                                                     
                                                         );                                                                                                                
                contactArticles.add(contactArticle);
            }                
                                               
            insert contactArticles;  
            
            for(ITSMS__kav i: contactArticles){
                ITSMS__kav a = [SELECT KnowledgeArticleId FROM ITSMS__kav WHERE Id = :i.Id LIMIT 1];
                KbManagement.PublishingService.publishArticle(a.KnowledgeArticleId, true);   
            }          
        	ITSMSContactUsInfoComponentController cuc = new ITSMSContactUsInfoComponentController();        
			system.debug('@@ contact us email:'+ cuc.contactUsEmail);            
			system.debug('@@ contact us hours:'+ cuc.contactUsHours);          
			system.debug('@@ contact us phone:'+ cuc.contactUsPhone); 
			system.debug('@@ contact us support:'+ cuc.contactUsSupport);           
            test.stopTest();
        }
    }
}