/*
    Controller for the public trending articles component.
    Extracts and displays the trending articles
        
    **********************************************************
    Audit History
    **********************************************************
    4/22/2013    Lucian Ciobanu      Created
    **********************************************************  
*/
public with sharing class PublicKBHomeTrendingArticles {

    // Trending Articles
    public List<ArticleWrapper> trendingArticles {
        get {
            try {
                // Extract the limit from custom setting
                Integer articlesLimit = KeyValueStoreHelper.getIntegerValue('ExtTrendingArticlesLimit');
                summaryCharsLimit = KeyValueStoreHelper.getIntegerValue('TrendingArticleSummaryCharsLimit');
                
                // Extract the articles
                List<ArticleWrapper> articleList = new List<ArticleWrapper>();
                
                List<KnowledgeArticleVersion> articles = [SELECT Id, Title, Summary, ArticleType, UrlName FROM KnowledgeArticleVersion 
                                WHERE PublishStatus = 'Online' AND Language = 'en_US' WITH DATA CATEGORY Customer_Categories__c 
                                AT Trending_Articles__c LIMIT :articlesLimit];
                                
                Set<Id> articleIds = new Set<Id>();
                for (KnowledgeArticleVersion article : articles) {
                    articleIds.add(article.Id);
                }
                                
                Map<Id, AggregateResult> ags = new Map<Id, AggregateResult>([SELECT KnowledgeArticelId__c Id, AVG(Rating__c) avgRating FROM PublicArticleRating__c WHERE KnowledgeArticelId__c IN :articleIds GROUP BY KnowledgeArticelId__c]);
                
                List<sObject> categories = getCategories(articles);
                
                for (KnowledgeArticleVersion article : articles) {
                    articleList.add(new ArticleWrapper(article, ags, categories));                                  
                }
                return articleList;
            } catch (Exception ex) {
                PublicKBErrors.AddError(ex);
                return new List<ArticleWrapper>();
            }
        }
    }
    private static Integer summaryCharsLimit;
    
    private List<sObject> getCategories(List<KnowledgeArticleVersion> foundArticles) {
        Set<String> articleTypes = new Set<String>();
        Set<Id> articleIds = new Set<Id>();
        for (KnowledgeArticleVersion foundArticle : foundArticles) {
            articleTypes.add(foundArticle.ArticleType);
            articleIds.add(foundArticle.Id);
        }
        List<sObject> toReturn = new List<sObject>(); 
        for (String articleType : articleTypes) {
            string categorizationName = articleType.replace('__kav', '__DataCategorySelection');
            String query = 'SELECT ParentId, DataCategoryGroupName, DataCategoryName FROM ' + categorizationName + ' WHERE ParentId IN :articleIds';
            System.debug('getCategories query: ' + query);
            toReturn.addAll(database.query(query));
        }
        System.debug('toReturn: ' + toReturn);
        return toReturn;
    }
    
    /* INNER CLASSES */
    
    public class ArticleWrapper {
        public KnowledgeArticleVersion article {get; set;}
        public String summaryAbbr {get; set;}
        
        public integer numberOfStars { get; set; }
        public string star1Class { get { return numberOfStars >= 1 ? 'icon-star' : 'icon-star-empty'; } }
        public string star2Class { get { return numberOfStars >= 2 ? 'icon-star' : 'icon-star-empty'; } }
        public string star3Class { get { return numberOfStars >= 3 ? 'icon-star' : 'icon-star-empty'; } }
        public string star4Class { get { return numberOfStars >= 4 ? 'icon-star' : 'icon-star-empty'; } }
        public string star5Class { get { return numberOfStars >= 5 ? 'icon-star' : 'icon-star-empty'; } }
        
        public Boolean SummaryFull {
            get {
                return summaryAbbr == article.Summary;
            }
        }
        
        public Boolean IsWildBlue {
            get {
              try {
                  if (categories == null)
                      return false;
                  for(sObject connection : categories)
                      if (connection.get('ParentId') == (string)article.Id && connection.get('DataCategoryGroupName') == 'Denver_Product' && connection.get('DataCategoryName') == 'WildBlue')
                          return true;
                  return false;
              } catch (Exception ex) {
                PublicKBErrors.AddError(ex);
                return false;
              }
            }
        }
        
        public Boolean IsExede {
            get {
              try {
                  if (categories == null)
                      return false;
                  for(sObject connection : categories)
                      if (connection.get('ParentId') == (string)article.Id && connection.get('DataCategoryGroupName') == 'Denver_Product' && connection.get('DataCategoryName') == 'Exede')
                          return true;
                  return false;
              } catch (Exception ex) {
                PublicKBErrors.AddError(ex);
                return false;
              }
            }
        }
        
        private List<sObject> categories;
        
        public ArticleWrapper(KnowledgeArticleVersion article, Map<Id, AggregateResult> staring, List<sObject> categs) {
            categories = categs;
            this.article = article;
            if (article.Summary != null)
                this.summaryAbbr = article.Summary.abbreviate(summaryCharsLimit);
            numberOfStars = 0;
            if (staring != null && staring.containsKey(article.Id))
                numberOfStars = (integer)((decimal)staring.get(article.Id).get('avgRating')).round(RoundingMode.HALF_UP);
            //  system.debug('ArticleURl >>>'+articleURL);
            //  system.debug('numberOfStars >>>'+numberOfStars);
        }
        
        // builds the article URL to be used in the iframe
        public String articleURL {
            get {
                return 'articles/' + article.ArticleType.replace('__kav', '') + '/' + article.UrlName;
            }
        }
    }

}