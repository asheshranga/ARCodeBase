/*********************************************************************************
Name         : WAAYSArticlesController
Created By   : Raghuprasad Halkere
Modified BY  : Raghuprasad Halkere
Company Name : NTT Data
Project      : ViaSat Atlas, Bangalore
Created Date : 22 October 2013
Modified Date: 13 November 2013
Usages       : Controller for VisualForce Page: AtlasPopularArticles.Component
*********************************************************************************/

global with sharing class WAAYSArticlesController{
//global String URLCheck=AtlasUtility.getURL('KnowledgeBaseSearch'); 

    public String keywords {get;set;}
    
    // List to hold all the trending articles
    public String idd{get;set;}  
    global List<ArticleWrapper> trendingArticles{
        get {
            try {
                // Extract the limit from custom setting
                Integer articlesLimit=KeyValueStoreHelper.getIntegerValue(AtlasConstants.ARTICLE_LIMIT);
                summaryCharsLimit=KeyValueStoreHelper.getIntegerValue(AtlasConstants.CHARACTER_LIMIT); 
                
                // Extract the articles
                List<ArticleWrapper> articleList=new List<ArticleWrapper>();
                
                List<KnowledgeArticleVersion> articles;
                
                if ((keywords==null) || (keywords.trim().equals(''))) {
                   articles =[SELECT Id, Title, Summary, ArticleType,ArticleNumber, UrlName 
                                FROM KnowledgeArticleVersion 
                       WHERE PublishStatus ='Online' 
                         AND Language      = 'en_US' 
                       LIMIT :articlesLimit];                
                } else {
                   String searchquery = 'FIND \'' + keywords.replaceALL(',',' ') + '\'' +
                                        '  IN ALL FIELDS RETURNING' +
                                        '  KnowledgeArticleVersion(Id, Title, Summary, ArticleType,ArticleNumber, UrlName' +
                                '                    WHERE PublishStatus =\'Online\'' + 
                                '                      AND Language      = \'en_US\')';
                   List<List<SObject>>searchList = search.query(searchquery);
                   articles = (List<KnowledgeArticleVersion>)searchList[0];                   
                }
                
                /*
                String lsKeywordsWhere = '';
                
                lsKeywordsWhere = ((keywords==null) || (keywords.trim().equals(''))) ? '': '%' + keywords + '%';
                
                
                List<KnowledgeArticleVersion> articles =[SELECT Id, Title, Summary, ArticleType,ArticleNumber, UrlName FROM KnowledgeArticleVersion 
                                                          WHERE PublishStatus ='Online' AND Language = 'en_US' AND Title like :lsKeywordsWhere LIMIT :articlesLimit];
                
                */
                
                Set<Id> articleIds = new Set<Id>();
                for (KnowledgeArticleVersion article : articles) {
                    articleIds.add(article.Id);
                }
                
                Map<Id, AggregateResult> ags=new Map<Id, AggregateResult>([SELECT KnowledgeArticelId__c Id, AVG(Rating__c) avgRating FROM PublicArticleRating__c WHERE KnowledgeArticelId__c IN :articleIds GROUP BY KnowledgeArticelId__c]);
                
                List<sObject> categories = getCategories(articles);              
                
                for (KnowledgeArticleVersion article : articles) {
                    articleList.add(new ArticleWrapper(article, ags, categories));  
                   
                    
                }
            
                return articleList;
            } catch (Exception ex) {
                //PublicKBErrors.AddError(ex);
                return new List<ArticleWrapper>();
            }
        }
    }/*This method will be used for read on.. link*/
        
    private static Integer summaryCharsLimit;

    /**
    * @author Rahul Kumar Sharma
    * @description - getCategories of Articles for AtlasPopularArticlesController
    * @input param  - List of KnowledgeArticleVersion Articles
    * @return - List of categorized KnowledgeArticleVersion Articles
    */          
    private List<sObject> getCategories(List<KnowledgeArticleVersion> foundArticles) {
        Set<String> articleTypes = new Set<String>();
        
        Set<Id> articleIds = new Set<Id>();
        for (KnowledgeArticleVersion foundArticle : foundArticles) {
            articleTypes.add(foundArticle.ArticleType);
            articleIds.add(foundArticle.Id);
            // articleIds.add('ka6n0000000000pAAA');
        }
        List<sObject> toReturn = new List<sObject>(); 
        set<string> categorizationNameSet = new set<string>();
        for (String articleType : articleTypes) {
              categorizationNameSet.add(articleType.replace('__kav', '__DataCategorySelection'));
              
              
            string categorizationName = articleType.replace('__kav', '__DataCategorySelection');
            
            String query = 'SELECT ParentId, DataCategoryGroupName, DataCategoryName FROM ' + categorizationName + ' WHERE ParentId IN :articleIds';
            
            toReturn.addAll(database.query(query));
        }                
        return toReturn;
    }
    
    /* INNER CLASSES */
    
    global class ArticleWrapper{
        public KnowledgeArticleVersion article{get;set;}
        public String summaryAbbr{get;set;}
        
        public integer numberOfStars{get;set;}
        public string star1Class{get{return numberOfStars>=1?AtlasConstants.ICON_STAR:AtlasConstants.ICON_STAR_EMPTY;}}
        public string star2Class{get{return numberOfStars>=2?AtlasConstants.ICON_STAR:AtlasConstants.ICON_STAR_EMPTY;}}
        public string star3Class{get{return numberOfStars>=3?AtlasConstants.ICON_STAR:AtlasConstants.ICON_STAR_EMPTY;}}
        public string star4Class{get{return numberOfStars>=4?AtlasConstants.ICON_STAR:AtlasConstants.ICON_STAR_EMPTY;}}
        public string star5Class{get{return numberOfStars>=5?AtlasConstants.ICON_STAR:AtlasConstants.ICON_STAR_EMPTY;}}
        
        global Boolean SummaryFull{
            get {
                try{
                return summaryAbbr==article.Summary.substring(0,50);
                }
                catch(Exception ex){
                    return false; 
                }
            }
        }
        
        //Variable to hold IsWildblue
        global Boolean IsWildBlue {
            get {
                try {
                    if (categories==null)
                    return false;
                    for(sObject connection : categories)
                    if (connection.get(AtlasConstants.PARENT_ID)==(string)article.Id && connection.get(AtlasConstants.DATA_CTG_GRP_NAME)==AtlasConstants.DENVER_PROD &&connection.get(AtlasConstants.DATA_CTG_NAME)==AtlasConstants.STR_WILDBLUE)
                    return true;
                    return false;
                } catch (Exception ex) {
                    PublicKBErrors.AddError(ex);
                    return false;
                }
            }
        }
        
        // Variable to hold isExede 
        global Boolean IsExede {
            get {
                try { 
                    if (categories==null)
                    return false;
                    for(sObject connection : categories)
                    if (connection.get(AtlasConstants.PARENT_ID)==(string)article.Id && connection.get(AtlasConstants.DATA_CTG_GRP_NAME)==AtlasConstants.DENVER_PROD &&connection.get(AtlasConstants.DATA_CTG_NAME)==AtlasConstants.STR_EXEDE)
                    return true;
                    return false;
                } catch (Exception ex){
                    PublicKBErrors.AddError(ex);
                    return false;
                }
            }
        }
        
        private List<sObject> categories;
        
        // Method to map all the KnowledgeArticleVersion articles, rating and categories
    /**
    * @author Rahul Kumar Sharma
    * @description - getCategories of Articles for AtlasPopularArticlesController
    * @input param  - KnowledgeArticleVersion article,Map of Ids , List of categories.
    * @return - null
    */         
        global ArticleWrapper(KnowledgeArticleVersion article,Map<Id, AggregateResult> staring,List<sObject> categs) {
            categories=categs;
            this.article=article;
            if (article.Summary!=null)
            this.summaryAbbr=article.Summary.abbreviate(summaryCharsLimit);
            numberOfStars=0;
            if (staring!=null&&staring.containsKey(article.Id))
            numberOfStars=(integer)((decimal)staring.get(article.Id).get(AtlasConstants.AVG_RATING)).round(RoundingMode.HALF_UP);
        }
        
        // Variable holds the article URL to be used in the iframe
        global String articleURL{
            get{             
                //return 'articles/' + article.ArticleType.replace('__kav', '') + '/' + article.UrlName;  
                
                //return AtlasConstants.DEV_URL+article.UrlName;   
                return AtlasConstants.KB_URL+'/articles/' + article.ArticleType.replace('__kav', '') + '/' + article.UrlName;
                   
            }
        }
    }
      

}