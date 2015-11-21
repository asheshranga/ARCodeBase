/*
    Created on: October 30, 2015
    Author: Dennis Estioco

    Test class for ITSMSAlertsAndNotifsComponentController.cls. Will be clean once I build out a solution that gives 100% test coverage 

*/

@isTest
public class ITSMSAlertsAndNotifsCompControllerTest{
    
    static testMethod void testAlertsAndNotifsController(){     
        
        ITSMSTestDataSetup.createTestConstants();      
        Profile testProfile = [SELECT Id, Name FROM Profile WHERE Name = 'Denver: Knowledgebase User' LIMIT 1];            
        User knowledgeUser = new User(  firstname = 'Delegate2', lastName = 'ForRequestor',
                              email = 'delegate2' + '@test.org',
                              Username = 'delegate2' + '@test.org',
                              EmailEncodingKey = 'ISO-8859-1',
                              Alias = 'dele2',
							  UserPermissionsKnowledgeUser = true,                        
                              TimeZoneSidKey = 'America/Los_Angeles',
                              LocaleSidKey = 'en_US',
                              LanguageLocaleKey = 'en_US',  
                              ProfileId = testProfile.Id
                              );
        insert knowledgeUser;    
        
        System.debug('New KB user: ' + [SELECT Name, UserPermissionsKnowledgeUser FROM User WHERE UserPermissionsKnowledgeUser = true AND firstname = 'Delegate2' LIMIT 1]);
        System.debug('Other KB users: ' + [SELECT Name, UserPermissionsKnowledgeUser FROM User WHERE UserPermissionsKnowledgeUser = true AND firstname != 'Delegate2']);
        
        test.startTest();             
        
        System.runAs(knowledgeUser){
            ITSMS__kav alertArticle = new ITSMS__kav(Title = 'test article', 
                                                     Summary = 'test summary', 
                                                     URL__c = 'testURL', 
                                                     UrlName = 'testURLName', 
                                                     Section__c = 'Alerts & Notifications', 
                                                     Area__c ='LandingPage',
                                                     Language= 'en_US'
                                                     );         
            insert alertArticle;  
            //ITSMS__kav a = [SELECT KnowledgeArticleId FROM ITSMS__kav WHERE Id = :alertArticle.Id LIMIT 1];
            KbManagement.PublishingService.publishArticle(alertArticle.KnowledgeArticleId, false);           
            System.debug('(ITSMSAlertsAndNotifsCompControllerTest) Online alert articles in test environment: ' + 
                         [SELECT Title, Area__c, Section__c 
                          FROM ITSMS__kav 
                          WHERE Section__c = :'Alerts & Notifications' AND Area__c = :'LandingPage' AND PublishStatus = 'Online' AND Language = :'en_US']);   
            System.debug('(ITSMSAlertsAndNotifsCompControllerTest) Archived alert articles in test environment: ' + 
                         [SELECT Title, Area__c, Section__c 
                          FROM ITSMS__kav 
                          WHERE Section__c = :'Alerts & Notifications' AND Area__c = :'LandingPage' AND PublishStatus = 'Archived' AND Language = :'en_US']);         
            ITSMSAlertsAndNotifsComponentController alertController = new ITSMSAlertsAndNotifsComponentController();                     
        }
        test.stopTest();
    }    
    
}