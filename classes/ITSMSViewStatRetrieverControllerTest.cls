/*
 
	Created by: Dennis Estioco
	
	Test class for ITSMSViewStatRetrieverController. 
	Currently uses the (seeAllData = true) annotation because there is not a known way to create ITSMS__ViewStat
	records within a test environment.

	Roadblocks: 
	1.) DML operations not allowed on ITSMS__ViewStat object.
	2.) Visiting detail pages of ITSMS__kav records through PageReferences in the test class does not create or update corresponding ITSMS__ViewStat records.

*/

@isTest(seeAllData = true)
public class ITSMSViewStatRetrieverControllerTest {
    static testmethod void ITSMSViewStatRetrieverControllerTest(){
        
        ITSMSTestDataSetup.createTestConstants();      
        ITSMSTestDataSetup.createAdmins();
        
        User admin = [SELECT Id, firstname FROM User WHERE firstname = 'knowledgeAdmin' ]; 
        test.startTest();             
        
        System.runAs(admin){ 
            
            ITSMSTestDataSetup.createPublishedArticleList('LandingPage', 'Featured Links', 22);             
            ITSMSViewStatRetrieverController controller = new ITSMSViewStatRetrieverController();
            LIST<Double> normalizedScore1 = controller.viewNormalizedScore;
			            
            			
            LIST<ITSMS__kav> articles = [SELECT Title, Id, KnowledgeArticleId FROM ITSMS__kav WHERE Language = 'en_US' AND PublishStatus = 'Online'];		
			
            // Attempt to create views for each newly created article by visiting their pages. As of 11/16/2015, attempts to create ITSMS__ViewStat records have failed
            for(ITSMS__kav a : articles){
                
                //PageReference articlePage = new PageReference('/' + a.KnowledgeArticleId);
                PageReference articlePage = new PageReference('https://viasat--devsup2.cs23.my.salesforce.com/' + a.KnowledgeArticleId);                
                articlePage.setRedirect(true);
                Test.setCurrentPage(articlePage);
                System.debug('Current page: ' + ApexPages.currentPage().getURL());

                PageReference articlePage2 = new PageReference('https://viasat--devsup2.cs23.my.salesforce.com/' + a.Id);                
                articlePage2.setRedirect(true);
                Test.setCurrentPage(articlePage2);                
                
                PageReference selfHelpPage = Page.ITSMSupportCenterSelfHelpPOC;
                selfHelpPage.setRedirect(true);
                Test.setCurrentPage(selfHelpPage);                 

            }
            
            PageReference selfHelpPage = Page.ITSMSupportCenterSelfHelpPOC;
            selfHelpPage.setRedirect(true);
            Test.setCurrentPage(selfHelpPage); 
            
            LIST<ITSMS__kav> allArticles = [SELECT Title, Id, KnowledgeArticleId FROM ITSMS__kav WHERE Language = 'en_US' AND PublishStatus = 'Online' UPDATE VIEWSTAT];
            System.debug('(ITSMSViewStatRetrieverControllerTest) allArticles.size(): ' + allArticles.size());          
            System.debug('(ITSMSViewStatRetrieverControllerTest) view stats in test environment: ' + [SELECT Id FROM ITSMS__ViewStat].size());                        

            LIST<ITSMS__kav> testArticle = [SELECT Id, KnowledgeArticleId, Language, PublishStatus FROM ITSMS__kav WHERE Language = 'en_US' AND PublishStatus = 'Online' LIMIT 1 UPDATE VIEWSTAT];
            for(ITSMS__kav a : testArticle){
	            controller.articleID = a.KnowledgeArticleId;
            }
            LIST<Double> normalizedScore2 = controller.viewNormalizedScore;            
        }
    }
}