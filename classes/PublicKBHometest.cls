/*********************************************************************************
Name 		: PublicKBHometest Class
Created By  : Hayli Silber 
Created Date: 18-JUl-2013	 
Project  	: ViaSat Support Tooway
Usage 		: PublicKBHometest Class for PublicKBHome, PublicKBHomeTrendingArticles ,PublicKBHomeSearchResults,
              PublicKBViewArticle , PublicKBContactUs , PublicKBErrors ,PublicKBError , PublicKBSearchResultWrapper 
			  PublicKBViewArticleDummy Class
*********************************************************************************/
@IsTest(seealldata=true) 
public class PublicKBHometest
{ 
	
    public static String moreInfo = 'test';
    public static String errorDesc = 'Error Desc';
    
    /**
		* @description - publicKBHometest1() for PublicKBHome Class. 
	*/
    static testMethod void publicKBHometest1() 
    {
        List<KnowledgeArticleVersion> kavList = KBHomeCtrlrTest.insertTestArticles();
        List<sObject> l = new List<sObject>();
        for (KnowledgeArticleVersion k:kavList) {
            string categorizationName = k.ArticleType.replace('__kav', '__DataCategorySelection');
            sObject obj = Schema.getGlobalDescribe().get(categorizationName).newSObject();
            obj.put('parentId', k.Id);
            obj.put('DataCategoryGroupName', 'Customer_Categories');
            obj.put('DataCategoryName', 'Email');
            l.add(obj);
        } 
        System.debug('l::' + l);
        insert l;
        
        PublicKBHome controller = new PublicKBHome();

        controller.categoryLevel1 = 'Customer_Categories';
        controller.categoryLevel2 = 'Customer_Categories_two';
        controller.selectedProduct = 'Testing';
        ApexPages.currentPage().getParameters().put('page', '3');
        controller.dosearch = 'search';

        controller.searchKeyword = 'Testing123';
        controller.selectedCategory = 'test';
        controller.doSearch = 'Title';
        controller.searchDone = true;
        controller.viewAdvanced = true;
        controller.Load();
        controller.doSearch();
        controller.toggleAdvanced();
        controller.getControllerObj();
        controller.getSearchStyleClassName();
        controller.getAdvancedSearchButtonText();
        controller.getCategoriesLevel1();
        controller.getCategoriesLevel2();
        
        ApexPages.currentPage().getParameters().put('searchKeyword','Testing123');
        ApexPages.currentPage().getParameters().put('categoryLevel1','Customer_Categories');
        ApexPages.currentPage().getParameters().put('categoryLevel2','Customer_Categories_two');
        ApexPages.currentPage().getParameters().put('selectedProduct','Testing');
        ApexPages.currentPage().getParameters().put('dosearch','search');
    }
    
   /**
		* @description - publicKBHometest2() for PublicKBHome Class. 
	*/
    static testMethod void publicKBHometest2() 
    {
        List<KnowledgeArticleVersion> kavList = KBHomeCtrlrTest.insertTestArticles();
        List<sObject> l = new List<sObject>();
        for (KnowledgeArticleVersion k:kavList) {
            string categorizationName = k.ArticleType.replace('__kav', '__DataCategorySelection');
            sObject obj = Schema.getGlobalDescribe().get(categorizationName).newSObject();
            obj.put('parentId', k.Id);
            obj.put('DataCategoryGroupName', 'Customer_Categories');
            obj.put('DataCategoryName', 'Email');
            l.add(obj);
        }
        System.debug('l::' + l);
        insert l;
        
        PublicKBHome controller = new PublicKBHome();

        controller.categoryLevel1 = 'Customer_Categories';
        controller.categoryLevel2 = 'Customer_Categories_two';
        controller.selectedProduct = 'Testing';
        ApexPages.currentPage().getParameters().put('page', '3');
        controller.dosearch = 'search';

        controller.searchKeyword = 'Testing123';
        controller.selectedCategory = 'test';
        controller.searchDone = true;
        controller.viewAdvanced = false;
        controller.Load();
        controller.doSearch();
        controller.toggleAdvanced();
        controller.getControllerObj();
        controller.getSearchStyleClassName();
        controller.getAdvancedSearchButtonText();
        controller.getCategoriesLevel1();
        controller.getCategoriesLevel2();
        
        ApexPages.currentPage().getParameters().put('searchKeyword','Testing123');
        ApexPages.currentPage().getParameters().put('categoryLevel1','Customer_Categories');
        ApexPages.currentPage().getParameters().put('categoryLevel2','Customer_Categories_two');
        ApexPages.currentPage().getParameters().put('selectedProduct','Testing');
        ApexPages.currentPage().getParameters().put('dosearch','search');
    }
    
    /**
		* @description - publicKBHometest3() for PublicKBHome Class. 
	*/
    static testMethod void publicKBHometest3() 
    {
        List<KnowledgeArticleVersion> kavList = KBHomeCtrlrTest.insertTestArticles();
        List<sObject> l = new List<sObject>();
        for (KnowledgeArticleVersion k:kavList) {
            string categorizationName = k.ArticleType.replace('__kav', '__DataCategorySelection');
            sObject obj = Schema.getGlobalDescribe().get(categorizationName).newSObject();
            obj.put('parentId', k.Id);
            obj.put('DataCategoryGroupName', 'Customer_Categories');
            obj.put('DataCategoryName', 'Email');
            l.add(obj);
        }
        System.debug('l::' + l);
        insert l;
        
        PublicKBHome controller = new PublicKBHome();

        controller.categoryLevel1 = 'Email';
	    controller.selectedProduct = 'Testing';
        ApexPages.currentPage().getParameters().put('page', '3');
        controller.dosearch = 'search';

        controller.searchKeyword = 'Testing123';
        controller.selectedCategory = 'test';
        controller.doSearch = 'Title';
        controller.searchDone = true;
        controller.viewAdvanced = true;
        controller.Load();
        controller.doSearch();
        controller.toggleAdvanced();
        controller.getControllerObj();
        controller.getSearchStyleClassName();
        controller.getAdvancedSearchButtonText();
        controller.getCategoriesLevel1();
        controller.getCategoriesLevel2();
        
        ApexPages.currentPage().getParameters().put('searchKeyword','Testing123');
        ApexPages.currentPage().getParameters().put('categoryLevel1','Email');
        ApexPages.currentPage().getParameters().put('selectedProduct','Testing');
        ApexPages.currentPage().getParameters().put('dosearch','search');
    }
    
     /**
		* @description - publicKBHometest4() for PublicKBHome Class. 
	 */
    static testMethod void publicKBHometest4() 
    {
        List<KnowledgeArticleVersion> kavList = KBHomeCtrlrTest.insertTestArticles();
        List<sObject> l = new List<sObject>();
        for (KnowledgeArticleVersion k:kavList) {
            string categorizationName = k.ArticleType.replace('__kav', '__DataCategorySelection');
            sObject obj = Schema.getGlobalDescribe().get(categorizationName).newSObject();
            obj.put('parentId', k.Id);
            obj.put('DataCategoryGroupName', 'Customer_Categories');
            obj.put('DataCategoryName', 'Email');
            l.add(obj);
        }
        System.debug('l::' + l);
        insert l;
        
        PublicKBHome controller = new PublicKBHome();
	    controller.selectedProduct = 'Testing';
        ApexPages.currentPage().getParameters().put('page', '3');
        controller.dosearch = 'search';

        controller.searchKeyword = 'Testing123';
        controller.selectedCategory = 'test';
        controller.doSearch = 'Title';
        controller.searchDone = true;
        controller.viewAdvanced = true;
        controller.Load();
        controller.doSearch();
        controller.toggleAdvanced();
        controller.getControllerObj();
        controller.getSearchStyleClassName();
        controller.getAdvancedSearchButtonText();
        controller.getCategoriesLevel1();
        controller.getCategoriesLevel2();
        
        ApexPages.currentPage().getParameters().put('searchKeyword','Testing123');
        ApexPages.currentPage().getParameters().put('selectedProduct','Testing');
        ApexPages.currentPage().getParameters().put('dosearch','search');
    }
     /**
		* @description - publicKBHomeTrendingArticlesTest1() for PublicKBHomeTrendingArticles Class. 
	 */
    
    static testMethod void publicKBHomeTrendingArticlesTest1() {
        List<PublicKBHomeTrendingArticles.ArticleWrapper> articleList = new List<PublicKBHomeTrendingArticles.ArticleWrapper>();
        Map<String, Schema.SObjectType> gd = Schema.getGlobalDescribe();
        List<sObject> objList = new List<sObject>();
        integer i = 1;
        for (String s:gd.keyset()) {
            if (s.endsWithIgnoreCase('__kav')) {
                sObject obj = Schema.getGlobalDescribe().get(s).newSObject();
                obj.put('Title', 'Title');
                obj.put('UrlName', 'titleFAQ' + i);
                obj.put('Language', 'en_US');
                i++;
                objList.add(obj);
            }
        }
        System.debug(objList);
        insert objList;
        System.debug(objList);
        List<KnowledgeArticleVersion> kavList = KBSOQLHelper.knowArtQueryList(objList); 
        for (KnowledgeArticleVersion s:kavList) {
            KbManagement.PublishingService.publishArticle(s.knowledgeArticleId, true);
        }
        List<sObject> l = new List<sObject>();
        for (KnowledgeArticleVersion k:kavList) {
            string categorizationName = k.ArticleType.replace('__kav', '__DataCategorySelection');
            sObject obj = Schema.getGlobalDescribe().get(categorizationName).newSObject();
            obj.put('parentId', k.Id);
            obj.put('DataCategoryGroupName', 'Customer_Categories');
            obj.put('DataCategoryName', 'Trending_Articles');
            l.add(obj);

        }
        System.debug('l::' + l);
        insert l;        
        KnowledgeArticleVersion artVer = new KnowledgeArticleVersion();
        Map<Id,AggregateResult> staring = new   Map<Id,AggregateResult>();
        list<sObject> sobj = new list<sObject>();
        PublicKBHomeTrendingArticles controller = new PublicKBHomeTrendingArticles();
        List<PublicKBHomeTrendingArticles.ArticleWrapper> arts = controller.trendingArticles;
        PublicKBHomeTrendingArticles.ArticleWrapper pkbhtaw = new PublicKBHomeTrendingArticles.ArticleWrapper(artVer,staring,sobj);
        Boolean iwb = pkbhtaw.IsWildBlue;
        Boolean sf = pkbhtaw.SummaryFull;
        Boolean ie = pkbhtaw.IsExede;
        
       
    }
    
    /**
		* @description - publicKBHomeTrendingArticlesTest2() for PublicKBHomeTrendingArticles Class. 
	 */
	 
     static testMethod void publicKBHomeTrendingArticlesTest2() {
        PublicKBHomeTrendingArticles controller = new PublicKBHomeTrendingArticles();
        KnowledgeArticleVersion article = new KnowledgeArticleVersion();
        PublicKBHomeTrendingArticles.ArticleWrapper artWrap = new PublicKBHomeTrendingArticles.ArticleWrapper(article,null,null); 
        try{  
           Boolean isWild = artWrap.IsWildBlue;
           Boolean isExe = artWrap.IsExede;    
           String artURL = artWrap.articleURL;
           
        }catch(Exception ex){}
         
     }
     
     /**
		* @description - publicKBHomeSearchResultsTest1() for PublicKBHomeSearchResults Class. 
	 */
     public static testMethod void publicKBHomeSearchResultsTest1() {
        
        List<KnowledgeArticleVersion> kavList = KBHomeCtrlrTest.insertTestArticles();
        List<sObject> l = new List<sObject>();
        for (KnowledgeArticleVersion k:kavList) {
            string categorizationName = k.ArticleType.replace('__kav', '__DataCategorySelection');
            sObject obj = Schema.getGlobalDescribe().get(categorizationName).newSObject();
            obj.put('parentId', k.Id);
            obj.put('DataCategoryGroupName', 'Customer_Categories');
            obj.put('DataCategoryName', 'Email');
            l.add(obj);
        }
        System.debug('l::' + l);
        insert l;
       
        PublicKBHomeSearchResults controller = new PublicKBHomeSearchResults();
        controller.searchCriteria = 'Test';
        controller.dosearch = 'search';
        controller.loadSearchResults();
        controller.BuildSOQLQuery(); 
        List<integer> pages = controller.previousPages;
        pages = controller.nextPages;
        ApexPages.currentPage().getParameters().put('page', '3');
        controller.gotoPage();
        controller.getProducts();
        controller.loadArticlesSOQL();
    }
    /**
		* @description - publicKBHomeSearchResultsTest2() for PublicKBHomeSearchResults Class. 
	 */
      static testMethod void publicKBHomeSearchResultsTest2() {
    
        profile profileid = [ Select id from Profile where name = 'Denver: Knowledge Only User'];
        
        Account A1 = new Account(Name = 'Test Account');
        insert A1;
        
        Contact C1 = new Contact( AccountID = A1.id, FirstName = 'Test', LastName = 'User', 
        email = 'test-user@fakeemail.com');
        insert C1;

        User u1 = new User( email='test-user@fakeemail.com', profileid = profileid.id, 
        UserName='TestNTTDATAIndia@nttdata.com', alias='tuser1', CommunityNickName='tuser1', 
        TimeZoneSidKey='America/New_York', LocaleSidKey='en_US', EmailEncodingKey='ISO-8859-1', 
        LanguageLocaleKey='en_US', FirstName = 'Test', LastName = 'User' );
        insert u1;
            
        List<KnowledgeArticleVersion> kavList = KBHomeCtrlrTest.insertTestArticles();
        List<sObject> l = new List<sObject>();
        for (KnowledgeArticleVersion k:kavList) {
            string categorizationName = k.ArticleType.replace('__kav', '__DataCategorySelection');
            sObject obj = Schema.getGlobalDescribe().get(categorizationName).newSObject();
            obj.put('parentId', k.Id);
            obj.put('DataCategoryGroupName', 'Customer_Categories');
            obj.put('DataCategoryName', 'Email');
            l.add(obj);
        }
        System.debug('l::' + l);
        insert l;
        
        PublicKBHomeSearchResults controller = new PublicKBHomeSearchResults();
        controller.searchCriteria = 'T';
        controller.categoryLevel1 = 'Customer_Categories';
        controller.categoryLevel2 = 'Customer_Categories_two';
        controller.selectedproduct = 'Testing';
        controller.initiallyselectedproduct = 'Testing123';
        controller.selectedproductprivate = 'test';
        controller.dosearch = 'se';
        controller.loadSearchResults();
        controller.BuildSOQLQuery();
        List<integer> pages = controller.previousPages;
        pages = controller.nextPages;
        ApexPages.currentPage().getParameters().put('page', '0');
        controller.gotoPage();
        controller.getProducts();
        controller.LoadArticlesSOQL();
    }
    
    /**
		* @description - publicKBHomeSearchResultsTest3() for PublicKBHomeSearchResults Class. 
	 */
     static testMethod void publicKBHomeSearchResultsTest3() {
            
        List<KnowledgeArticleVersion> kavList = KBHomeCtrlrTest.insertTestArticles();
        List<sObject> l = new List<sObject>();
        for (KnowledgeArticleVersion k:kavList) {
            string categorizationName = k.ArticleType.replace('__kav', '__DataCategorySelection');
            sObject obj = Schema.getGlobalDescribe().get(categorizationName).newSObject();
            obj.put('parentId', k.Id);
            obj.put('DataCategoryGroupName', 'Customer_Categories'); 
            obj.put('DataCategoryName', 'Trending_Articles');
            
            l.add(obj);
        }
        System.debug('l::' + l);
        insert l;
        
        PublicKBHomeSearchResults controller = new PublicKBHomeSearchResults();
        controller.searchCriteria = '"Test"';
        controller.dosearch = 'search';
        controller.BuildSOQLQuery();
        List<integer> pages = controller.previousPages;
        pages = controller.nextPages;
        ApexPages.currentPage().getParameters().put('page', '1');
        controller.gotoPage();
        controller.getProducts();
        controller.LoadArticlesSOQL();
    }

	/**
		* @description - publicKBHomeSearchResultsTest4() for PublicKBHomeSearchResults Class. 
	 */
     static testMethod void publicKBHomeSearchResultsTest4() {
        
        List<KnowledgeArticleVersion> kavList = KBHomeCtrlrTest.insertTestArticles();
        List<sObject> l = new List<sObject>();
        for (KnowledgeArticleVersion k:kavList) {
            string categorizationName = k.ArticleType.replace('__kav', '__DataCategorySelection');
            sObject obj = Schema.getGlobalDescribe().get(categorizationName).newSObject();
            obj.put('parentId', k.Id);
            obj.put('DataCategoryGroupName', 'Customer_Categories');
            obj.put('DataCategoryName', 'Trending_Articles');
            l.add(obj);
        }
        System.debug('l::' + l);
        insert l;
        
        PublicKBHomeSearchResults controller = new PublicKBHomeSearchResults();
        controller.searchCriteria = '""';
        controller.dosearch = 'search';
        controller.BuildSOQLQuery();
        List<integer> pages = controller.previousPages;
        Pages = controller.nextPages;
        ApexPages.currentPage().getParameters().put('page', '1');
        controller.getProducts();

    }
    /**
		* @description - publicKBHomeSearchResultsTest5() for PublicKBHomeSearchResults Class. 
	 */
     static testMethod void publicKBHomeSearchResultsTest5() {
        
        List<KnowledgeArticleVersion> kavList = KBHomeCtrlrTest.insertTestArticles();
        List<sObject> l = new List<sObject>();
        for (KnowledgeArticleVersion k:kavList) {
            string categorizationName = k.ArticleType.replace('__kav', '__DataCategorySelection');
            sObject obj = Schema.getGlobalDescribe().get(categorizationName).newSObject();
            obj.put('parentId', k.Id);
            obj.put('DataCategoryGroupName', 'Customer_Categories');
            obj.put('DataCategoryName', 'Trending_Articles');
            l.add(obj);
            
            
        }
        System.debug('l::' + l);
        insert l;
        
        PublicKBHomeSearchResults controller = new PublicKBHomeSearchResults();
        controller.searchCriteria = '';
        controller.dosearch = 'search';
        controller.loadSearchResults();
        controller.foundArticleIds = kavList;
        controller.addHashTag('test');
        controller.BuildSOQLQuery();
        controller.BuildSOSLQuery();
        List<integer> pages = controller.previousPages;
        pages = controller.nextPages;
        ApexPages.currentPage().getParameters().put('page', '10');
        controller.gotoPage();
        controller.getProducts();
        controller.LoadArticlesSOQL();
    }
    /**
		* @description - publicKBViewArticletest1() for PublicKBViewArticle Class. 
	*/
    
     static testMethod void publicKBViewArticletest1() {
        Denver_FAQ__kav dkav = new Denver_FAQ__kav();
        dkav.Related_Articles__c = 'Test\'<ul\'';
        dkav.Title = 'Denver work';
        dkav.UrlName = 'Denver-work';           
        insert dkav;
        
                
        Id generalArticleId;
        List<sObject> l = new List<sObject>();        
        List<KnowledgeArticleVersion> kavList = [SELECT knowledgeArticleId,title,urlname, ArticleType from KnowledgeArticleVersion 
        							where id =: dkav.id];
        for (KnowledgeArticleVersion k:kavList) {
            
            System.debug('l:: k.ArticleType ' + k.ArticleType);
            string categorizationName = k.ArticleType;
            sObject obj = Schema.getGlobalDescribe().get(categorizationName).newSObject();
            obj.put('Title', 'NTT data');
            obj.put('UrlName', 'NTT-data');
            l.add(obj);

            if (k.ArticleType == 'Denver_FAQ__kav')
                generalArticleId = k.Id;
                KbManagement.PublishingService.publishArticle(k.knowledgeArticleId, true);  
         }
        insert l;
        
        Apexpages.currentPage().getParameters().put('id', generalArticleId);       
        PublicKBViewFAQ controller = new PublicKBViewFAQ(new ApexPages.StandardController([SELECT Id FROM Denver_FAQ__kav WHERE Id = :generalArticleId]));
       
        PageReference pageRef=Page.PublicKBHome;             
        Test.setCurrentPage(pageRef);        
       
        PublicKBHome obj = new PublicKBHome();         
        obj.doSearch();        
        obj.Load();        
        obj.toggleAdvanced();
        obj.getCategoriesLevel1();
        obj.getCategoriesLevel2();
        obj.getControllerObj();
        obj.getSearchStyleClassName();
        obj.getAdvancedSearchButtonText(); 
              
        PublicKBTemplate  temp =new  PublicKBTemplate();
        temp.Load();         
    }
    
      
    /**
		* @description - publicKBViewArticletest2() for PublicKBViewArticle Class. 
	*/
    static testMethod void publicKBViewArticletest2() {
        
        List<KnowledgeArticleVersion> kavList = KBHomeCtrlrTest.insertTestArticles();
        Id generalArticleId;
        List<sObject> l = new List<sObject>();
        for (KnowledgeArticleVersion k:kavList) {
            string categorizationName = k.ArticleType.replace('__kav', '__DataCategorySelection');
            sObject obj = Schema.getGlobalDescribe().get(categorizationName).newSObject();
            obj.put('parentId', k.Id);
            obj.put('DataCategoryGroupName', 'Care_Categories');
            obj.put('DataCategoryName', 'Trending_Articles');
            l.add(obj);
            if (k.ArticleType == 'General__kav')
                generalArticleId = k.Id;
        }
        
        insert l;
        
        Apexpages.currentPage().getParameters().put('id', kavList[0].id);
        
        PublicKBViewGeneral controller = new PublicKBViewGeneral(new ApexPages.StandardController([SELECT Id,Related_Articles__c FROM General__kav WHERE Id = :generalArticleId]));
        String title  = 'Test';
        String anchorHref = 'anchor';
        PublicKBViewArticle.TOCLine tocLine = new PublicKBViewArticle.TOCLine(title,anchorHref);
		controller.load(string.valueOf(generalArticleId));        
        
        // create temporary article rating objects records
        controller.createPublicArticleRatingSummary();
        controller.createPublicArticleRatingDetail(); 
        
        //PageReference pageRef = Page.PublicKBViewGeneral;
        // Vote with no param values set so the error condition is validated
        controller.VoteStars();
        controller.updateRatingDescription();
        controller.articleViewed();
        
        
        // Vote with rating passed in to test the valid condition
        Apexpages.currentPage().getParameters().put('paramStars', '5');
        controller.VoteStars();
        
        // check getSearchController
        controller.getSearchController();
        
        // Test the three charAt scenarios
        String testStr = controller.charAt(null,1); 
        String testStr1 = controller.charAt('',1);
        String testStr2 = controller.charAt(' ',0);
        
    }
    /**
		* @description - publicKBViewArticletest3() for PublicKBViewArticle Class. 
	*/
    static testMethod void publicKBViewArticletest3()
    {
        General__kav gkav = [SELECT Id,Related_Articles__c FROM General__kav WHERE PublishStatus = 'Online' 
                             AND Language = 'en_US' limit 1]; 
		ApexPages.StandardController sc = new ApexPages.StandardController(gkav);
        PublicKBViewGeneral controller = new PublicKBViewGeneral(sc);
        PublicKBViewArticle currInst = controller.currentInstance;
        /*KnowledgeArticleVersion article = [Select Id,Title from KnowledgeArticleVersion WHERE PublishStatus = 'Online' AND Language = 'en_US' limit 1];
        currInst.load(article.Id);
         
		List<AggregateResult> ags = [SELECT AVG(Rating__c) avgRating FROM PublicArticleRating__c  WHERE KnowledgeArticelId__c =: article.Id];
        List<PublicArticleRating__c> ratings = [SELECT Rating__c FROM PublicArticleRating__c  Limit 1];
        */
         
    }
        /**
		* @description - publicKBContactUstest1() for PublicKBContactUstest Class. 
		*/
    static testmethod void publicKBContactUstest1() 
    {  
  	   

        test.starttest();
 
                           
            PageReference pageRef=Page.PublicKBContactUs;             
            Test.setCurrentPage(pageRef);             
            PublicKBContactUs PKBCU = new PublicKBContactUs();           
            PKBCU.nameValue = 'a';
            PKBCU.firstnameValue = 'firstnameValue';
            PKBCU.lastnameValue = 'lastnameValue';
            PKBCU.phoneValue = '1234567879';
            PKBCU.emailValue = 'EmalValue@email.com';
            PKBCU.productValue = 'All';
            PKBCU.validationValue = '1';
            PKBCU.helpValue = 'w';
            PKBCU.missingData = true;
            PKBCU.incorrectEmail = true;
            PKBCU.exedePhone = 'v';
            PKBCU.wildbluePhone = 'u';
            PKBCU.viasatAddress = 't';
            PKBCU.chatDeploymentId = 's';
            PKBCU.chatButtonId = 'r';
            PKBCU.searchDone = true;
            PKBCU.emailSent = true;
            PKBCU.emailAddress = 'q';
            PKBCU.emailSubject = 'p';
            PKBCU.pageSize = 5;
            PKBCU.ChatReady = true; 
            PKBCU.validEmail = true;
            PKBCU.emailSent = true;
            PKBCU.searchDone = false; 
            
            String liveAgentDomain = PKBCU.liveAgentDomain;
    		String validationHelpText = PKBCU.validationHelpText;            
                      
            
            String firstNmVlCln = PKBCU.firstnameValue;
            String lastNmVlCln = PKBCU.lastnameValue;
            String phoneVlCln = PKBCU.phoneValue;
            String emailVlCln = PKBCU.emailValue;
            String helpVlCln = PKBCU.helpValue;
            String productVlCln = PKBCU.productValue;
            
            // normal paths
            PKBCU.searchNow();
            PKBCU.chatNow();
            PKBCU.sendEmail();
            
                        
			// error-alternate paths, misc methods            
            try
            { 
            	PKBCU.productValue = 'Exede'; // product selected
            	PKBCU.helpValue = 'Exe';      // more than 2 chars
            	PKBCU.searchNow();
            	            	
            	PKBCU.helpValue = 'Exe Wil'; // multiple words
            	PKBCU.searchNow();
            	            	
            	PKBCU.helpValue = ''; // product - but no help
            	PKBCU.searchNow();
            	            	
           		PKBCU.chatNow();  // missing data
           		PKBCU.sendEmail();           		
           		
           		PKBCU.firstnameValue = 'firstnameValue';
                PKBCU.lastnameValue = 'lastnameValue';
                PKBCU.phoneValue = '1234567879';              	
             	PKBCU.helpValue = 'Exe';
             	PKBCU.emailValue = 'EmailValue'; // invalid email
             	PKBCU.sendEmail();  
             	
             	
             	PKBCU.firstnameValue = 'firstnameValue';
                PKBCU.lastnameValue = 'lastnameValue';
                PKBCU.phoneValue = '1234567879';
             	PKBCU.helpValue = ''; // empty help
             	PKBCU.emailValue = 'EmailValue@email.com'; 
             	PKBCU.chatNow();
             	PKBCU.sendEmail(); 
          		PKBCU.gotoHelpLibrary();
          		
            	PKBCU.helpValue = 'Exede';
            	PKBCU.gotoHelpLibrary();
            	
            	PKBCU.getProducts();
            	PublicKBSearchResultWrapper srw=PKBCU.searchResultWrapper;
            }catch(Exception e){} 
           
     
         
      	test.stoptest();  
    }
       
    /**
		* @description - publicKBErrorsTest1() for PublicKBErrors  Class. 
	*/
     static testmethod void publicKBErrorsTest1() 
     {
        PublicKBErrors.AddError(moreInfo, errorDesc); 
     }
    
    /**
		* @description - publicKBErrorTest1() for PublicKBError   Class. 
	*/ 
     static testmethod void publicKBErrorTest1() 
     {
      	 PublicKBError kbError = new PublicKBError();
         String trackNumber = kbError.trackingNumber;
      	       
     }	

    /**
		* @description - PublicKBSearchResultWrapperTest() for PublicKBSearchResultWrapper   Class. 
	*/ 
     static testmethod void publicKBSearchResultWrapperTest() 
     {
       List<KBArticleWrapper> searchResults = new List<KBArticleWrapper>();  
       PublicKBSearchResultWrapper publicSrRsltWrap = new PublicKBSearchResultWrapper(searchResults);
       Integer srchRslts =  publicSrRsltWrap.searchResultSize;
     }
     
     /**
		* @description - publicKBViewArticleDummyTest() for PublicKBViewArticleDummy   Class. 
	*/
     static testmethod void publicKBViewArticleDummyTest() 
     {
         General__kav article = [Select Id, Related_Articles__c,Content__c, Summary__c, DynamicTOC__c from General__kav WHERE 
             					PublishStatus = 'Online' AND Language = 'en_US'limit 1];
         ApexPages.StandardController sc = new ApexPages.standardController(article);
         PublicKBViewArticleDummy viewArt = new PublicKBViewArticleDummy(sc);
                 
         viewArt.fetchArticleSummary();
         viewArt.fetchTOCSourceData();
         viewArt.massageRelatedArticlesField();
         
     }
   }