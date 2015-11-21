/*********************************************************************************
Name 		: KBHomeCtrlrTest Class
Created By  : Mohantesh Kanike
Created Date: 11-SEP-2014	 
Project  	: ViaSat Support Tooway
Usage 		: KBHomeCtrlrTest Class for KBHome,KBHomeCtrlr , KBHomeSearchResults ,KBCategoryGroupDetails 
			  KBCategoryDetails KBArtilceWrapper, KBEscalateToCorporateCare and KBDAPRemoval Class
*********************************************************************************/
@isTest(SeeAllData = true)
public with sharing class KBHomeCtrlrTest 
{
	/**
		* @description - testMethod for KBHome Class. 
	*/  
    public static testMethod void testKBHome() 
    {
        ApexPages.currentPage().getParameters().put('groupName','Care_Categories');
        KBHome controller = new KBHome();
        controller.doSearch();
        controller.gotoArticleRequest(); 
        
        System.assertEquals(controller.searchDone, true);
        
        ApexPages.currentPage().getParameters().put('groupName','Customer_Categories');
        controller = new KBHome();
        controller.doSearch();
        controller.gotoArticleRequest();
        
        ApexPages.currentPage().getParameters().put('groupName','Denver_Product');
        controller = new KBHome();
        controller.doSearch();
        controller.gotoArticleRequest();
    }
    
    /**
		* @description - kbHomeCtrlrTest1 for KBHomeCtrlr Class. 
	*/
    static testmethod void kbHomeCtrlrTest1()
	{
        KBHomeCtrlr kbhomeCtrlr = new KBHomeCtrlr();
        ApexPages.currentPage().getParameters().put('isdtp', 'isdtp');
        KeyValueStore__c settings = new KeyValueStore__c();
        settings.Name = 'ViaSatToolsLimit';
		settings.Application__c = 'KBInternal';
		settings.IntegerValue__c = 2;
		settings.Description__c = 'desc';
        
        
        String publishStatus = 'Online';
        String language = 'en_US';
        KnowledgeArticleVersion artVersion = KBSOQLHelper.knwldgeArtPubOnline(publishStatus, language); 
        KBHomeCtrlr.ArticleLine artLine = new KBHomeCtrlr.ArticleLine(artVersion);
        ApexPages.currentPage().getParameters().put('isdtp', 'isdtp');
          
        List<KnowledgeArticleVersion> kavList = insertTestArticles();
        List<sObject> l = new List<sObject>();
                
        for (KnowledgeArticleVersion k:kavList) {
            string categorizationName = k.ArticleType.replace('__kav', '__DataCategorySelection');
            sObject obj = Schema.getGlobalDescribe().get(categorizationName).newSObject();
            obj.put('parentId', k.Id);
            obj.put('DataCategoryGroupName', 'Care_Categories');
            obj.put('DataCategoryName', 'Announcements');
            l.add(obj);
        }
               
        Test.startTest();
        insert settings;
        System.assertEquals(settings.Name,'ViaSatToolsLimit'); 
		insert l;
		Test.stopTest();
    }

    // static method used by tests to insert published articles of all categories
    public static List<KnowledgeArticleVersion> insertTestArticles() {
        Map<String, Schema.SObjectType> gd = Schema.getGlobalDescribe();
        List<sObject> objList = new List<sObject>();
        integer i = 1;
        for (String s:gd.keyset()) {
            if (s.endsWithIgnoreCase('__kav')) {
                sObject obj = Schema.getGlobalDescribe().get(s).newSObject();
                obj.put('Title', 'Title');
                obj.put('UrlName', 'Test' + i);
                obj.put('Language', 'en_US');
                i++;
                objList.add(obj);
            }
        }
        
        insert objList;
        
        List<KnowledgeArticleVersion> kavList = KBSOQLHelper.knowArtQueryList(objList);  
        for (KnowledgeArticleVersion s:kavList) {
            KbManagement.PublishingService.publishArticle(s.knowledgeArticleId, true);
        }
        
        return kavList;
    }
    
    /**
		* @description - kbHomeSearchResultTest1 for KBHomeSearchResults Class. 
	*/
    static testmethod void kbHomeSearchResultTest1()
	{
         KeyValueStore__c settings = new KeyValueStore__c();
        settings.Name = 'ViaSatToolsLimit';
        settings.Application__c = 'KBInternal';
        settings.IntegerValue__c =2;
        settings.Description__c = 'desc';
                    
        List<KnowledgeArticleVersion> kavList = KBHomeCtrlrTest.insertTestArticles();
        List<sObject> l = new List<sObject>();
        for (KnowledgeArticleVersion k:kavList) {
            string categorizationName = k.ArticleType.replace('__kav', '__DataCategorySelection');
            sObject obj = Schema.getGlobalDescribe().get(categorizationName).newSObject();
            obj.put('parentId', k.Id);
            obj.put('DataCategoryGroupName', 'Care_Categories');
            obj.put('DataCategoryName', 'Announcements');
            l.add(obj);
        }
             
        
        KBHomeSearchResults kbHomeSrhRslts = new KBHomeSearchResults();
        List<KnowledgeArticleVersion> foundArticles = [SELECT Id, Title, Summary,ArticleType, LastPublishedDate FROM KnowledgeArticleVersion 
                                                       WHERE PublishStatus = 'Online' AND Language = 'en_US' AND
                                                       ArticleType IN('General__kav', 'Announcement__kav','Denver_FAQ__kav') Limit 3];
        
        kbHomeSrhRslts.searchCriteria = '';
        kbHomeSrhRslts.internalCareCategory = 'Announcements__c';
        kbHomeSrhRslts.customerCategory = 'Policies__c';
        kbHomeSrhRslts.product = 'Exede__c';
        kbHomeSrhRslts.loadSearchResults();
        String srchCriteria = kbHomeSrhRslts.searchCriteria;
        if(String.isEmpty(srchCriteria))
        {
            String query = 'SELECT Id, Title,  LastPublishedDate FROM KnowledgeArticleVersion  WHERE    Language=\'en_US\' limit 1';
        }
		
        General__kav  gkav = [Select Id,SpotlightTerms__c from General__kav where PublishStatus = 'Online' AND Language = 'en_US' 
                              		 limit 1];
        gkav.SpotlightTerms__c = 'test';
        String spotTerms = gkav.SpotlightTerms__c;
        String spotLightTerms;
        if(spotTerms != null)
        spotLightTerms = 'Testing';
        
        Map<Id,String> spotMap = new Map<Id,String>();
        spotMap.put(gkav.Id,spotLightTerms);
        
        
        String inString = '#,';
        List<integer> pages = kbHomeSrhRslts.previousPages;
        pages = kbHomeSrhRslts.nextPages;
        ApexPages.currentPage().getParameters().put('page', '0');
        ApexPages.currentPage().getParameters().put('currentpage', '0');
        ApexPages.currentPage().getParameters().put('isdtp', '');
        kbHomeSrhRslts.gotoPage();
        kbHomeSrhRslts.addHashTag(inString);
        kbHomeSrhRslts.BuildSOQLQuery();
        kbHomeSrhRslts.loadSearchResults();
                        
        List<KnowledgeArticleVersion> orderedArticleIds = kbHomeSrhRslts.getSpotLight(foundArticles);
        KnowledgeArticleVersion art = new KnowledgeArticleVersion();
        KBHomeSearchResults.ArticleLine artLine = new KBHomeSearchResults.ArticleLine(art);
        
        System.assertEquals(settings.Name,'ViaSatToolsLimit'); 
        
        Test.startTest();
        insert settings;
        insert l;
        Test.stopTest();        
    }
    
    /**
		* @description - kbHomeSearchResultTest2 for KBHomeSearchResults Class. 
	*/
     static testmethod void kbHomeSearchResultTest2()
	{
         KeyValueStore__c settings = new KeyValueStore__c();
        settings.Name = 'ViaSatToolsLimit';
        settings.Application__c = 'KBInternal';
        settings.IntegerValue__c =2;
        settings.Description__c = 'desc';
                    
        List<KnowledgeArticleVersion> kavList = KBHomeCtrlrTest.insertTestArticles();
        List<sObject> l = new List<sObject>();
        for (KnowledgeArticleVersion k:kavList) {
            string categorizationName = k.ArticleType.replace('__kav', '__DataCategorySelection');
            sObject obj = Schema.getGlobalDescribe().get(categorizationName).newSObject();
            obj.put('parentId', k.Id);
            obj.put('DataCategoryGroupName', 'Care_Categories');
            obj.put('DataCategoryName', 'Announcements');
            l.add(obj);
        }
             
        
        KBHomeSearchResults kbHomeSrhRslts = new KBHomeSearchResults();
        List<KnowledgeArticleVersion> foundArticles = [SELECT Id, Title, Summary,ArticleType, LastPublishedDate FROM KnowledgeArticleVersion 
                                                       WHERE PublishStatus = 'Online' AND Language = 'en_US' AND
                                                       ArticleType IN('General__kav', 'Announcement__kav','Denver_FAQ__kav') Limit 3];
        
        kbHomeSrhRslts.searchCriteria = 'Test';
        kbHomeSrhRslts.internalCareCategory = 'Announcements__c';
        kbHomeSrhRslts.customerCategory = 'Policies__c';
        kbHomeSrhRslts.product = 'Exede__c';
        kbHomeSrhRslts.loadSearchResults();
        String srchCriteria = kbHomeSrhRslts.searchCriteria;
        if(String.isEmpty(srchCriteria))
        {
            String query = 'SELECT Id, Title,  LastPublishedDate FROM KnowledgeArticleVersion  WHERE    Language=\'en_US\' limit 1';
        }
        
        Announcement__kav  akav = [Select Id,SpotlightTerms__c from Announcement__kav where PublishStatus = 'Online' AND Language = 'en_US' 
                              		 limit 1];
        akav.SpotlightTerms__c = 'test';
        String spotTerms = akav.SpotlightTerms__c;
        if(spotTerms != null)
        {
            String spotLightTerms = 'Testing';
        }
        String inString = '#,';
        List<integer> pages = kbHomeSrhRslts.previousPages;
        pages = kbHomeSrhRslts.nextPages;
        ApexPages.currentPage().getParameters().put('page', '0');
        ApexPages.currentPage().getParameters().put('currentpage', '0');
        ApexPages.currentPage().getParameters().put('isdtp', '');
        kbHomeSrhRslts.gotoPage();
        kbHomeSrhRslts.addHashTag(inString);
        kbHomeSrhRslts.BuildSOQLQuery();
        kbHomeSrhRslts.loadSearchResults();
                        
        List<KnowledgeArticleVersion> orderedArticleIds = kbHomeSrhRslts.getSpotLight(foundArticles);
        KnowledgeArticleVersion art = new KnowledgeArticleVersion();
        KBHomeSearchResults.ArticleLine artLine = new KBHomeSearchResults.ArticleLine(art);
        
        System.assertEquals(settings.Name,'ViaSatToolsLimit'); 
        
        Test.startTest();
        insert settings;
        insert l;
        Test.stopTest();        
    }
    
    
    
    /**
		* @description - kbCategoryGroupDetailsTest for KBCategoryGroupDetails Class. 
	*/
    static testmethod void kbCategoryGroupDetailsTest()
	{
        String name = 'work';
        String label = 'hello';
        KBCategoryGroupDetails kbCatDet = new KBCategoryGroupDetails(name,label);
        List<KBCategoryDetails> categList = new List<KBCategoryDetails>(); 
        
    }	
    /**
		* @description - kbCategoryDetailsTest for KBCategoryDetails Class. 
	*/
    static testmethod void kbCategoryDetailsTest()
	{
        String name = 'work';
        String label = 'hello';
        KBCategoryDetails kbCatDet = new KBCategoryDetails(name,label);
               
    }	
    
    /**
		* @description - kbArtilceWrapperTest1 for KBArtilceWrapper Class. 
	*/
    static testmethod void kbArtilceWrapperTest1() 
	{
        KnowledgeArticleVersion knowArt = new KnowledgeArticleVersion();
        List<Case> categs = [Select Id from Case limit 2];
        Map<Id, AggregateResult> staring = new Map<Id, AggregateResult>();
        KBArticleWrapper kbartWrap = new KBArticleWrapper(knowArt,categs,staring);
        KBArticleWrapper kbart = new KBArticleWrapper(knowArt,categs);
        
        String sum =  kbartWrap.Summary;
        Boolean sumFull = kbartWrap.SummaryFull; 
        Boolean IsWB = kbartWrap.IsWildBlue;
        Boolean IsEx = kbartWrap.IsExede;
    }
     /**
		* @description - kbArtilceWrapperTest2 for KBArtilceWrapper Class. 
	*/
    static testmethod void kbArtilceWrapperTest2() 
	{
        KnowledgeArticleVersion knowArt = new KnowledgeArticleVersion();
        List<Case> categs = new List<Case>();
        Map<Id, AggregateResult> staring = new Map<Id, AggregateResult>();
        KBArticleWrapper kbartWrap = new KBArticleWrapper(knowArt,categs,staring);
        KBArticleWrapper kbart = new KBArticleWrapper(knowArt,categs);
        
        String sum =  kbartWrap.Summary;
        Boolean sumFull = kbartWrap.SummaryFull; 
        Boolean IsWB = kbartWrap.IsWildBlue;
        Boolean IsEx = kbartWrap.IsExede;
    }
    /**
		* @description - kbEscalateToCorporateCareTest for KBEscalateToCorporateCare Class. 
	*/
    static testmethod void kbEscalateToCorporateCareTest() 
	{
        KBEscalateToCorporateCare ecc = new KBEscalateToCorporateCare();
        String initial = 'MKanike';
        ecc.accountName = 'a';
        ecc.name = 'n';
        ecc.description = 'd';
        ecc.ticketNumber = 's';
        
        String accClean = ecc.accountNameClean; 
        String nameClean = ecc.nameClean;
        String ticketClean = ecc.ticketNumberClean;
        String descClean = ecc.descriptionClean;
        String liveAgentDomain = ecc.liveAgentDomain;
        
        ecc.goBack();
        ecc.actionContinue();
        ecc.chatNow();
        ecc.CleanForJavascript(initial);
    }
    
    /**
		* @description - kbDAPRemovaltest for KBDAPRemoval Class. 
	*/
    static testmethod void kbDAPRemovalTest() 
	{
        KBDAPRemoval controller = new KBDAPRemoval();    
        controller.accountName = 'a';
        controller.details = 'd';
        String inital = 'MKanike';
        String accNameClean = controller.accountNameClean;
        String detClean = controller.detailsClean;
		String liveAgentDomain = controller.liveAgentDomain;
        
        controller.actionContinue();
        controller.goBack();
        controller.chatNow();
        controller.CleanForJavascript(inital);
    }
}