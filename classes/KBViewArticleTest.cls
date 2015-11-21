/*********************************************************************************
Name        : KBViewArticleTest Class
Created By  : Mohantesh Kanike
Created Date: 11-SEP-2014    
Project     : ViaSat Support Tooway
Usage       : KBViewArticleTest Class for KBViewArticle, KBArticleRequest Class 
********************************************************************************/

@isTest(SeeAllData = true)
public class KBViewArticleTest {
    /**
        * @description - Test Method for KBViewArticle Class. 
    */ 
    static testmethod void KBViewArticleTest1()
    {
        List<KnowledgeArticleVersion> kavList = KBHomeCtrlrTest.insertTestArticles();
        List<sObject> l = new List<sObject>();
        for (KnowledgeArticleVersion k:kavList) 
        {
            string categorizationName = k.ArticleType.replace('__kav', '__DataCategorySelection');
            sObject obj = Schema.getGlobalDescribe().get(categorizationName).newSObject();
            obj.put('parentId', k.Id);
            obj.put('DataCategoryGroupName', 'Care_Categories');
            obj.put('DataCategoryName', 'Announcements');
            l.add(obj);
        }
        insert l;
        
        
        Apexpages.currentPage().getParameters().put('id', kavList[0].id);
        
        KBViewArticle controller = new KBViewArticle();
        controller.gotoArticleRequest();
       
    }
     /**
        * @description - kbArticleRequestTest1() for KBArticleRequest Class. 
    */ 
    static testmethod void kbArticleRequestTest1()
    {
              
        String publishStatus = 'Online';
        String language = 'en_US';
       
        KBArticleRequest artRequest = new KBArticleRequest();   
        KnowledgeArticleVersion artic = KBSOQLHelper.knwldgeArtPubOnline(publishStatus,language);
        String categorizationName = artic.ArticleType.replace('Announcement__kav', 'Announcement'); 
                
        PageReference pageRef = Page.KBArticleRequest;
        Test.setCurrentPage(pageRef);        
        
        ApexPages.currentPage().getParameters().put('articleNumber',artic.ArticleNumber);
        ApexPages.currentPage().getParameters().put('artName',artic.ArticleType+''+artic.Title);
        ApexPages.currentPage().getParameters().put('ArticleLink__c',artic.UrlName);
        
		//FIELD_CUSTOM_VALIDATION_EXCEPTION, Please select the Account for this contact.: [AccountId]
		List<Account> accounts = ViasatTestUtility.createAccounts(1, 'testAccount');
		insert accounts;
		List<Contact> contacts = ViasatTestUtility.createContacts(accounts,1);
		insert contacts;
		Contact contactObj = contacts[0];
            
        artRequest.newCase = new Case();
        artRequest.newCase.Type='Update Article';
        artRequest.newCase.Article__c =artic.ArticleNumber;
        artRequest.newCase.ArticleName__c = categorizationName+':'+artic.Title;
        if (artRequest.newCase.ArticleName__c.length() > 70)
            artRequest.newCase.ArticleName__c = artRequest.newCase.ArticleName__c.substring(0,50);        
        artRequest.newCase.ArticleLink__c = artic.UrlName;
        artRequest.newCase.Description ='working';
        artRequest.newCase.Product_Family__c ='WildBlue';
        artRequest.newCase.Category__c ='Account Administration';
        artRequest.newCase.CategoryDetails__c ='Move';
        artRequest.newCase.Priority = 'Priority';   
                
        insert artRequest.newCase;
       
        //Validating the value after inserting the case record
        System.assertEquals(artRequest.newCase.Type,'Update Article'); 
                
        Test.startTest();   
        
        ApexPages.Standardcontroller sc = new ApexPages.Standardcontroller(artic); 
        ApexPages.currentPage().getParameters().put('Id',artRequest.newCase.Id);
        artRequest.saveCase();
        artRequest.CheckCaseLoaded();
        artRequest.findLoginUserContactRecord();
        artRequest.goBack();  
        artRequest.setCategories(artic.id);
        Test.stopTest();
       
    }
    /**
        * @description - Test Method for KBViewDFAQArticleController Class. 
        // Created date -11/21/2014 - Case Number : 145364
    */ 
    static testmethod void KBViewDFAQArticleTest()
    {      
        Denver_FAQ__kav dkav = new Denver_FAQ__kav();
        dkav.Related_Articles__c = 'Test\'<ul\'';
        dkav.Title = 'Test';
        dkav.UrlName = 'Test0123';                  
        insert dkav;        
        Denver_FAQ__kav dkavlst=[select title,Articletype,UrlName,ArticleNumber,KnowledgeArticleId from Denver_FAQ__kav where Id=:dkav.id];
             
        PageReference KBViewDFAQArticleVfPage = Page.KBViewDFAQArticle;
        Test.setCurrentPage(KBViewDFAQArticleVfPage);     
        //Validating the value after inserting  article type Denver_FAQ__kav for the new article.
        System.assertEquals(dkav.Id,dkavlst.Id);      
        KBViewDFAQArticleController  controller=new KBViewDFAQArticleController(new ApexPages.KnowledgeArticleVersionStandardController(dkavlst));           
        controller.gotoArticleRequest();       
    }
  
  /**
        * @description - Test Method for KBViewGeneralArticleController Class. 
        // Created date -11/21/2014 - Case Number : 145364
    */ 
    static testmethod void KBViewGeneralArticleTest()
    {      
        General__kav gkav = new General__kav();
        gkav.Related_Articles__c = 'Test\'<ul\'';
        gkav.Title = 'Test';
        gkav.UrlName = 'Test0123';                  
        insert gkav;        
        General__kav gkavlst=[select title,Articletype,UrlName,ArticleNumber,KnowledgeArticleId from General__kav where Id=:gkav.id];
             
        PageReference KBViewGeneralArticleVfPage = Page.KBViewGeneralArticle;
        Test.setCurrentPage(KBViewGeneralArticleVfPage);     
        //Validating the value after inserting  article type General__kav for the new article.
        System.assertEquals(gkav.Id,gkavlst.Id);      
        KBViewGeneralArticleController controller=new KBViewGeneralArticleController(new ApexPages.KnowledgeArticleVersionStandardController(gkavlst));           
        controller.gotoArticleRequest();       
    }
    
}