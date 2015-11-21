/*
    Controller for the announcements component.
    Extracts and displays the announcement articles
        
    **********************************************************
    Audit History
    **********************************************************
    4/13/2013    Lucian Ciobanu      Created
    **********************************************************  
*/
public with sharing class KBHomeAnnouncements {

   /* public boolean inConsole { get; set; }

    // Announcements (last 10) 
    public List<Date> announcementDates { get; set; }
    public Map<Date, List<ArticleLine>> announcementsMap { get; set; }

    public KBHomeAnnouncements() {
        
        inConsole = false;
        if (!String.isEmpty(ApexPages.currentPage().getParameters().get('isdtp')))
            inConsole = true;
            
        // Extract the limit from custom setting
        integer settingsLimit = KeyValueStoreHelper.getIntegerValue('NewsAndUpdatesLimit');

        // Builds the announcements map        
        announcementDates = new List<Date>();
        announcementsMap = new Map<Date, List<ArticleLine>>();
        List<KnowledgeArticleVersion> announcements = [SELECT Id, Title, Summary, LastPublishedDate FROM KnowledgeArticleVersion WHERE PublishStatus = 'Online' AND Language = 'en_US' WITH DATA CATEGORY Care_Categories__c AT Announcements__c ORDER BY LastPublishedDate DESC LIMIT :settingsLimit];
        for (KnowledgeArticleVersion announcement : announcements) { 
            if (!announcementsMap.containsKey(announcement.LastPublishedDate.date())) {
                // Keep a separate dates list to ensure order, sets and maps do not guarantee order
                announcementDates.add(announcement.LastPublishedDate.date());
                announcementsMap.put(announcement.LastPublishedDate.date(), new List<ArticleLine>());
            }
            announcementsMap.get(announcement.LastPublishedDate.date()).add(new ArticleLine(announcement));
        }
        
    }
    
    // Wrapper around the article, used for the Summary handling
    public class ArticleLine {
        
        public KnowledgeArticleVersion article { get; set; }
        
        public String summary {
            get {
                if (article.Summary == null || article.Summary.length() <= 100)
                    return article.Summary;
                else
                    return article.Summary.left(100) + '...';
            }
        }
        
        public ArticleLine(KnowledgeArticleVersion art) {
            article = art;
        }
    }
    
   
    public static testmethod void test1() {
        KeyValueStore__c settingsLimit = new KeyValueStore__c(Name = 'NewsAndUpdatesLimit', Application__c = 'KBInternal', IntegerValue__c = 2, Description__c = 'desc');
        insert settingsLimit;
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
        System.debug('l::' + l);
        insert l;
        
        KBHomeAnnouncements controller = new KBHomeAnnouncements();

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
        System.debug(objList);
        insert objList;
        System.debug(objList);
        List<KnowledgeArticleVersion> kavList = [SELECT knowledgeArticleId, ArticleType from KnowledgeArticleVersion where id in :objList];
        for (KnowledgeArticleVersion s:kavList) {
            KbManagement.PublishingService.publishArticle(s.knowledgeArticleId, true);
        }
        System.debug('kavList:::' + kavList);
        return kavList;
    }*/
    
}