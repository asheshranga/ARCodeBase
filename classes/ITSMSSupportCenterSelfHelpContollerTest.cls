@isTest
public class ITSMSSupportCenterSelfHelpContollerTest {
    static testMethod void testSelfHelpController(){     
        
        ITSMSTestDataSetup.createTestConstants();      
        ITSMSTestDataSetup.createAdmins();
        
        User admin = [SELECT Id, firstname FROM User WHERE firstname = 'knowledgeAdmin' ]; 
        test.startTest();             
        
        System.runAs(admin){ 
            
			ITSMSTestDataSetup.createPublishedArticleList('LandingPage', 'Featured Links', 22);        
			PageReference pageRef = Page.ITSMSupportCenterSelfHelpPOC;        
            Test.setCurrentPage(pageRef);         
            ITSMSSupportCenterSelfHelpContoller selfHelpController = new ITSMSSupportCenterSelfHelpContoller();       

            selfHelpController.refreshSearchResult();
             
            System.debug(selfHelpController.maxSize);
            System.assertEquals(22, selfHelpController.maxSize);            
            
            System.assertEquals(false, selfHelpController.getPrevRequired());
                
            System.assertEquals(true, selfHelpController.getNextRequired());
            
            System.assertEquals(1, selfHelpController.getCurrentPageNumber());            
			selfHelpController.next();
            System.assertEquals(2, selfHelpController.getCurrentPageNumber());            
			selfHelpController.next();
            System.assertEquals(3, selfHelpController.getCurrentPageNumber());            
			selfHelpController.next();
            System.assertEquals(3, selfHelpController.getCurrentPageNumber());  
            
            selfHelpController.previous();		
            System.assertEquals(2, selfHelpController.getCurrentPageNumber());              
            selfHelpController.previous();		
            System.assertEquals(1, selfHelpController.getCurrentPageNumber());              
            selfHelpController.previous();	
            System.assertEquals(1, selfHelpController.getCurrentPageNumber());  
            
            selfHelpController.clickedPage = 3;
            selfHelpController.jumpPage();       
            System.assertEquals(3, selfHelpController.getCurrentPageNumber());  
            
            selfHelpController.clickedPage = 1;
            selfHelpController.jumpPage();             
            System.assertEquals(1, selfHelpController.getCurrentPageNumber());  
            
            selfHelpController.searchString = 'test';
            selfHelpController.getRatings();
            selfHelpController.refreshSearchResult();             
            selfHelpController.checkRatingFilter(); 
            selfHelpController.filterRating = 'Most Viewed';
            selfHelpController.checkRatingFilter();            
            selfHelpController.filterRating = 'Last Updated';
            selfHelpController.checkRatingFilter();            
            selfHelpController.filterRating = 'Title';
            selfHelpController.checkRatingFilter();
            Integer a = selfHelpController.articlesPerPage;
            
			            
        }             
        test.stopTest();
    }        
    static testMethod void testEdgeCase1(){  // Case where there are no articles   
        
        ITSMSTestDataSetup.createTestConstants();      
        ITSMSTestDataSetup.createAdmins();
        
        User admin = [SELECT Id, firstname FROM User WHERE firstname = 'knowledgeAdmin' ]; 
        test.startTest();             
        
        System.runAs(admin){ 
			PageReference pageRef = Page.ITSMSupportCenterSelfHelpPOC;        
            Test.setCurrentPage(pageRef);	                                  
            ITSMSSupportCenterSelfHelpContoller selfHelpController = new ITSMSSupportCenterSelfHelpContoller();       
            System.assertEquals(selfHelpController.maxSize, 0);
        }             
        test.stopTest();
    }    
    
    static testMethod void testEdgeCase2(){ // Case where # of articles is divisible 10 
        
        ITSMSTestDataSetup.createTestConstants();      
        ITSMSTestDataSetup.createAdmins();
        
        
        
        User admin = [SELECT Id, firstname FROM User WHERE firstname = 'knowledgeAdmin' ]; 
        test.startTest();             
         
        System.runAs(admin){  
            
			ITSMSTestDataSetup.createPublishedArticleList('LandingPage', 'Featured Links', 40);           
			PageReference pageRef = Page.ITSMSupportCenterSelfHelpPOC;        
            Test.setCurrentPage(pageRef);
			ApexPages.currentPage().getParameters().put('j_id0:j_id1:j_id102:j_id103:j_id104:j_id105:theSearchstring','Test Search String');                
            ITSMSSupportCenterSelfHelpContoller selfHelpController = new ITSMSSupportCenterSelfHelpContoller();       
			selfHelpController.next();                            
            selfHelpController.previous();                   
        }             
        test.stopTest();
    }   

}