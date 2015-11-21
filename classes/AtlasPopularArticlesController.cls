/*********************************************************************************
Name         : AtlasPopularArticlesController
Created By   : Raghuprasad Halkere
Modified BY  : Raghuprasad Halkere
Company Name : NTT Data
Project      : ViaSat Atlas, Bangalore
Created Date : 22 October 2013
Modified Date: 13 November 2013
Usages       : Controller for VisualForce Page: AtlasPopularArticles.Component
*********************************************************************************/

global with sharing class AtlasPopularArticlesController{
//global String URLCheck=AtlasUtility.getURL('KnowledgeBaseSearch'); 
    // List to hold all the trending articles
    public String idd{get;set;} 
    public Id trendingArticleId{get;set;}
    global static Id customerUserId;
    public string KnowledgeBaseLabel{get{return AtlasUtility.getMapValue(AtlasConstants.STRHEADER3_AtlasKnowledgeBase);}set;} 
    global List<ArticleWrapper> trendingArticles{
        get {
            try {
                // Extract the limit from custom setting
                Integer articlesLimit=KeyValueStoreHelper.getIntegerValue(AtlasConstants.ARTICLE_LIMIT);
                summaryCharsLimit=KeyValueStoreHelper.getIntegerValue(AtlasConstants.CHARACTER_LIMIT); 
                
                // Extract the articles
                List<ArticleWrapper> articleList=new List<ArticleWrapper>();
                
                List<KnowledgeArticleVersion> articles =[SELECT Id, Title, Summary, ArticleType,ArticleNumber, UrlName FROM KnowledgeArticleVersion 
                                WHERE PublishStatus ='Online'  AND Language = 'en_US' WITH DATA CATEGORY Customer_Categories__c 
                                AT Trending_Articles__c LIMIT :articlesLimit];
                /*List<KnowledgeArticleVersion> articles = [SELECT Id, Title, Summary, ArticleType, UrlName FROM KnowledgeArticleVersion 
                WHERE PublishStatus = 'Online' AND Language = 'en_US'];*/
                
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
    
    global AtlasPopularArticlesController(){
        customerUserId = ApexPages.currentPage().getParameters().get('Id'); 
    }

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
                //commmented by Sarath
                //return AtlasConstants.KB_URL+'/articles/' + article.ArticleType.replace('__kav', '') + '/' + article.UrlName;
                if(customerUserId !=null){
                return AtlasConstants.AtlasKnowledgeLinkPageURL+'?aticleId='+article.Id+'&articleType='+article.ArticleType.replace('__kav', '')+'&articleUrlName=' + article.UrlName+'&customerId='+customerUserId;
                }
                else{
                return AtlasConstants.AtlasKnowledgeLinkPageURL+'?aticleId='+article.Id+'&articleType='+article.ArticleType.replace('__kav', '')+'&articleUrlName=' + article.UrlName;   
                }
            }
        }
    }
      
    /** public PageReference AddAtlasTransactionHsitory(){
        AtlasTransactionHistory__c artTransc;
        String articleRedirectUrl = '';
        String PageUrl= ApexPages.currentPage().getUrl(); 
        Integer PageUrlpart1= PageUrl.indexOf('apex/');
        Integer PageUrlpart2= pageUrl.indexOf('?');
        String ref= PageUrl.substring(PageUrlpart1,PageUrlpart2);
        //String ref = PageUrl.substring(0, 30);
        String userid = Userinfo.getUserId();
        system.debug('@@@@@@@@@@' +userid);
        for(ArticleWrapper aw: trendingArticles){
            if(aw.article.Id == trendingArticleId){
                artTransc = new AtlasTransactionHistory__c();
                artTransc.transactionDescription__c = 'Kb article';
                artTransc.KBArticleUrl__c = aw.articleURL;
               artTransc.SessionID__c = userinfo.getSessionId();
                artTransc.transactionStatus__c = 'Success';
                artTransc.transactionType__c = 'Kb article';
                artTransc.transactionModule__c ='Knowledge';
                artTransc.KBArticleReferer__c=ref;
                artTransc.KBArticleId__c=aw.article.Id;
                articleRedirectUrl = aw.articleURL;
                Integer articleUrlLength=articleRedirectUrl .length();
                String articleType1= articleRedirectUrl.substring(49,articleUrlLength);
                Integer endIndex = articleType1.indexOf('/');
                String articleType= articleType1.substring(0,endIndex);
                artTransc.KBArticleType__c= articleType;
                arttransc.customerName__c=userid;
                break;
            }
        }
        
        if(artTransc != null){
       
        
            AtlasDatabaseManager.insertTransaction(artTransc);
           // system.debug('@@@@@@@@@@ artTransc '+artTransc);
          
            }
       
        
        if(articleRedirectUrl != ''){
            pagereference page=new pagereference(articleRedirectUrl);
            page.setRedirect(true);
            return page;
        }
        
        return null;
     } 
     */

}