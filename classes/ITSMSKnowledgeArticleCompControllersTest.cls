/*
    Created on: October 30, 2015
    Author: Dennis Estioco
 
    [November 3, 2015] 
    - Renamed to 'public class ITSMSKnowledgeArticleCompControllersTest' and will now contain all the test classes for each knowledge article component

*/

@isTest
//public class ITSMSAlertsAndNotifsCompControllerTest{
public class ITSMSKnowledgeArticleCompControllersTest{       
		
   /*static testMethod void testAlertsAndNotifsController(){     
         
        ITSMSTestDataSetup.createTestConstants();      
        ITSMSTestDataSetup.createAdmins();        
        User admin = [SELECT Id, firstname FROM User WHERE firstname = 'knowledgeAdmin' ]; 
        
        test.startTest();             
        
        System.runAs(admin){
			ITSMSUtilityClass.createPublishedArticle('LandingPage', 'Alerts & Notifications');  
            ITSMSAlertsAndNotifsComponentController alertController = new ITSMSAlertsAndNotifsComponentController();                  
        }                   
        test.stopTest();
    }*/    

    /*static testMethod void testFormsManagementController(){     
        
        ITSMSTestDataSetup.createTestConstants();             
        ITSMSTestDataSetup.createAdmins();
        
        User admin = [SELECT Id, firstname FROM User WHERE firstname = 'knowledgeAdmin' ]; 
        test.startTest();             
        
        System.runAs(admin){
			ITSMSUtilityClass.createPublishedArticle('LandingPage', 'Forms');            
            ITSMSFormsManagementComponentController formController = new ITSMSFormsManagementComponentController();                     
        }
        test.stopTest();
    }*/   

    /*static testMethod void testFeatLinksController(){     
        
        ITSMSTestDataSetup.createTestConstants();      
        ITSMSTestDataSetup.createAdmins();
        
        User admin = [SELECT Id, firstname FROM User WHERE firstname = 'knowledgeAdmin' ]; 
        test.startTest();             
        
        System.runAs(admin){
			ITSMSUtilityClass.createPublishedArticle('LandingPage', 'Featured Links');             
            ITSMSFeatLinksComponentController linksController = new ITSMSFeatLinksComponentController();                     
        }
        test.stopTest();
    }*/        

    /*static testMethod void testFooterController(){     
        
        ITSMSTestDataSetup.createTestConstants();      
        ITSMSTestDataSetup.createAdmins();
        
        User admin = [SELECT Id, firstname FROM User WHERE firstname = 'knowledgeAdmin' ]; 
        
        test.startTest();             
        
        System.runAs(admin){
			ITSMSUtilityClass.createPublishedArticle('LandingPage', 'Footer');                
            ITSMSFooterComponentController footerController = new ITSMSFooterComponentController();                     
        }
        test.stopTest();
    }*/    
    
    /*static testMethod void testMetricsController(){     
        
        ITSMSTestDataSetup.createTestConstants();      
        ITSMSTestDataSetup.createAdmins();
        
        User admin = [SELECT Id, firstname FROM User WHERE firstname = 'knowledgeAdmin' ]; 
        
        test.startTest();             
        
        System.runAs(admin){
                        
			ITSMSUtilityClass.createPublishedArticle('Contact Us', 'IT Metrics');            
            ITSMSMetricsComponentController metricsController = new ITSMSMetricsComponentController();                     
        }
        test.stopTest();
    }*/           
    
    static testMethod void testContactUsInfoController(){

        ITSMSTestDataSetup.createAdmins();
        User admin = [SELECT Id, firstname FROM User WHERE firstname = 'knowledgeAdmin' ];    
        
        test.startTest();
        ITSMSContactUsInfoComponentController contactUsInfoController1 = new ITSMSContactUsInfoComponentController();        
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
            ITSMSContactUsInfoComponentController contactUsInfoController2 = new ITSMSContactUsInfoComponentController();                    
            test.stopTest();
        }
    }

    /*static testMethod void testInformationTextController(){
        ITSMSTestDataSetup.createAdmins();
        User admin = [SELECT Id, firstname FROM User WHERE firstname = 'knowledgeAdmin' ];    
        
        test.startTest(); 
              
        System.runAs(admin){
            LIST<String> sections = new LIST<String> {'Storage','JIRA','VTC'};
            LIST<String> areas = new LIST<String> {'Server','Software','Conferencing'};
            Integer numOfSections = sections.size();
            LIST<ITSMS__kav> infoArticles = new LIST<ITSMS__kav>();
            for(Integer i = 0; i < numOfSections ; i++){            
                ITSMS__kav infoArticle = new ITSMS__kav(Title = 'test article' + i, 
                                                         Summary = 'test summary ' + i, 
                                                         URL__c = 'testURL' + i, 
                                                         UrlName = 'testURLName' + i, 
                                                         Section__c = sections[i], 
                                                         Area__c = areas[i],
                                                         Language = 'en_US',
                                                         IsVisibleInPkb = true,
                                                         IsVisibleInCsp = true                                                     
                                                         );                                                                                                                
                infoArticles.add(infoArticle);
            }                
                                               
            insert infoArticles;  
            
            for(ITSMS__kav i: infoArticles){
                ITSMS__kav a = [SELECT KnowledgeArticleId FROM ITSMS__kav WHERE Id = :i.Id LIMIT 1];
                KbManagement.PublishingService.publishArticle(a.KnowledgeArticleId, true);   
            }
                     
            ITSMSInformationTextComponentController infoTextController = new ITSMSInformationTextComponentController();     
            
            for(Integer j = 0; j < numOfSections ; j++){
                infoTextController.area = areas[j];
                infoTextController.section = sections[j];            
                infoTextController.getInfoArticleList();
            }                         
        }                   
        test.stopTest();             
    }*/
    
    static testMethod void testFailureQuery(){
        
        ITSMSTestDataSetup.createAdmins();
        User admin = [SELECT Id, firstname FROM User WHERE firstname = 'knowledgeAdmin' ];    
        
        test.startTest();           
        System.runAs(admin){
            ITSMSUtilityClass.getITSMSKavs('', '', '');
        }
        test.stopTest();           
    }
        
}