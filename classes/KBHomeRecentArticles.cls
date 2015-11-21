/*
    Controller for the recent articles component.
    Extracts and displays the last modified articles
        
    **********************************************************
    Audit History
    **********************************************************
    4/13/2013    Lucian Ciobanu      Created
    **********************************************************  
*/
public with sharing class KBHomeRecentArticles {

    /*public boolean inConsole { get; set; }

    // Top 10 last modified articles 
    public List<KnowledgeArticleVersion> lastModifiedArticles { get; set; }
    
    public KBHomeRecentArticles() {
        
        inConsole = false;
        if (!String.isEmpty(ApexPages.currentPage().getParameters().get('isdtp')))
            inConsole = true;
            
        // Extract the limit from custom setting
        integer settingsLimit = KeyValueStoreHelper.getIntegerValue('RecentlyPublishedArticlesLimit');
        
        // First extract the announcements, so they are excluded from the search
        List<KnowledgeArticleVersion> announcements = [SELECT Id FROM KnowledgeArticleVersion WHERE PublishStatus = 'Online' AND Language = 'en_US' AND ArticleType = 'Announcement__c' ORDER BY LastPublishedDate DESC LIMIT 10000];
        
        // Extract the articles
        lastModifiedArticles = [SELECT Id, Title FROM KnowledgeArticleVersion WHERE PublishStatus = 'Online' AND Language = 'en_US' AND Id NOT IN :announcements ORDER BY LastPublishedDate DESC LIMIT :settingsLimit];
        
    }

    @IsTest public static void test1() {
        KeyValueStore__c settings = new KeyValueStore__c(Name = 'RecentlyPublishedArticlesLimit', Application__c = 'KBInternal', IntegerValue__c = 2, Description__c = 'desc');
        insert settings;
        KBHomeRecentArticles controller = new KBHomeRecentArticles();
    }*/
}