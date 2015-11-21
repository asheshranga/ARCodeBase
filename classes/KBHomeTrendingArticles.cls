/*
    Controller for the trending articles component.
    Extracts and displays the trending articles
        
    **********************************************************
    Audit History
    **********************************************************
    4/13/2013    Lucian Ciobanu      Created
    **********************************************************  
*/
public with sharing class KBHomeTrendingArticles {

    
   /* public boolean inConsole { get; set; }

    // Trending Articles
    public List<KnowledgeArticleVersion> trendingArticles { get; set; }
    
    public KBHomeTrendingArticles() {
        
        inConsole = false;
        if (!String.isEmpty(ApexPages.currentPage().getParameters().get('isdtp')))
            inConsole = true;
            
        // Extract the limit from custom setting
        integer settingsLimit = KeyValueStoreHelper.getIntegerValue('TrendingArticlesLimit');
        
        // Extract the articles
        trendingArticles = [SELECT Id, Title FROM KnowledgeArticleVersion WHERE PublishStatus = 'Online' AND Language = 'en_US' WITH DATA CATEGORY Care_Categories__c AT Trending_Articles__c LIMIT :settingsLimit];

    }
    
    public static testmethod void test1() {
        KeyValueStore__c settings = new KeyValueStore__c(Name = 'TrendingArticlesLimit', Application__c = 'KBInternal', IntegerValue__c = 2, Description__c = 'desc');
        insert settings;
        KBHomeTrendingArticles controller = new KBHomeTrendingArticles();
    }*/
}