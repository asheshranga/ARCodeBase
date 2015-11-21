/*********************************************************************************
Name        : KBHomeCtrlr Class
Created By  : Mohantesh Kanike
Created Date: 11-SEP-2014    
Project     : ViaSat Support Tooway
Usage       : KBHomeCtrlr Class for KBHome Page
Modified Date : 11/19/2014
*********************************************************************************/
public with sharing class KBHomeCtrlr 
{
    public boolean inConsole { get; set; }
    
    // Declaring KnowledgeArticleVersion article list 
    public List<Date> announcementDates { get; set; }
    public Map<Date, List<ArticleLine>> announcementsMap { get; set; }
    
    public List<KnowledgeArticleVersion> viasatONEArticle { get; set; }
    public List<UsefulLinks__c> usefulLinks { get; set; }
    public List<KnowledgeArticleVersion> recAnnouncements {get;set;}
    public List<KnowledgeArticleVersion> lastModifiedArticles { get; set; }
    public List<KnowledgeArticleVersion> everyDayArticles { get; set; }
    
    
     /**
        * @description - KBHomeCtrlr constructor for KBHomeCtrlr Clas
        * @param object null
        
    */   
    public KBHomeCtrlr()
    {
        // From KBHomeAnnouncements
        inConsole = false;
        if (!String.isEmpty(ApexPages.currentPage().getParameters().get('isdtp')))
            inConsole = true;
            
        // Extract the limit from custom setting
        integer settingsLimit = KeyValueStoreHelper.getIntegerValue('NewsAndUpdatesLimit'); 

        // Builds the announcements map        
        announcementDates = new List<Date>();
        announcementsMap = new Map<Date, List<ArticleLine>>();
        //case - 145364 - Added KnowledgeArticleId  **** Created date 11/19/2014
        List<KnowledgeArticleVersion> announcements = [SELECT Id, Title, Summary,LastPublishedDate,KnowledgeArticleId   FROM KnowledgeArticleVersion 
             WHERE PublishStatus = 'Online' AND Language = 'en_US' WITH DATA CATEGORY Care_Categories__c AT Announcements__c ORDER BY LastPublishedDate DESC LIMIT :settingsLimit];
             
        for (KnowledgeArticleVersion announcement : announcements) { 
            if (!announcementsMap.containsKey(announcement.LastPublishedDate.date())) {
                // Keep a separate dates list to ensure order, sets and maps do not guarantee order
                announcementDates.add(announcement.LastPublishedDate.date());
                announcementsMap.put(announcement.LastPublishedDate.date(), new List<ArticleLine>());
            }
            announcementsMap.get(announcement.LastPublishedDate.date()).add(new ArticleLine(announcement));
        }
        
        // Extract the articles for ViaSatONE Tools
        //case - 145364 - Added KnowledgeArticleId  **** Created date 11/19/2014        
        viasatONEArticle = [SELECT Id,Title,KnowledgeArticleId  FROM KnowledgeArticleVersion WHERE PublishStatus = 'Online'
         AND Language = 'en_US' WITH DATA CATEGORY Care_Categories__c AT ViaSat_ONE__c LIMIT :settingsLimit];   
        
        // Extract the articles for UsefulLinks
        // Case 407045: added the sorting 
        usefulLinks = [SELECT Id, URL__c, URLTitle__c FROM UsefulLinks__c order by sortorder__c];
                
        
        // First extract the announcements, so they are excluded from the search
        recAnnouncements = [SELECT Id FROM KnowledgeArticleVersion WHERE PublishStatus = 'Online' AND Language = 'en_US'
                            AND ArticleType = 'Announcement__c' ORDER BY LastPublishedDate DESC LIMIT 10000];
        
        // Extract the articles for Recently Modified
        if(recAnnouncements != null) {
        // PL - Test - Added KnowledgeArticleId - Nov 2014  
        lastModifiedArticles = [SELECT Id, Title, KnowledgeArticleId FROM KnowledgeArticleVersion WHERE PublishStatus = 'Online' AND Language = 'en_US' AND 
                                Id NOT IN :recAnnouncements ORDER BY LastPublishedDate DESC LIMIT :settingsLimit];
        }
        
       // Extract the articles for Everyday Tools
       //case - 145364 - Added KnowledgeArticleId  **** Created date 11/19/2014
        everyDayArticles = [SELECT Id, Title,KnowledgeArticleId  FROM KnowledgeArticleVersion WHERE PublishStatus = 'Online' AND Language = 'en_US' WITH DATA CATEGORY Care_Categories__c AT 
                            Everyday_Tools__c LIMIT :settingsLimit];
                   
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
    
    
}