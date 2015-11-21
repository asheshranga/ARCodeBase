/*
    Data holder object that carries various data elements for an article.
        
    **********************************************************
    Audit History
    **********************************************************
    5/17/2013    Shah Kadirmohideen			Created
    **********************************************************  
*/
public with sharing class KBArticleWrapper {

        public KBArticleWrapper(KnowledgeArticleVersion art, List<sObject> categs) {
            article = art;
            categories = categs;
            numberOfStars = 0;
        }
        
        public KBArticleWrapper(KnowledgeArticleVersion art, List<sObject> categs, Map<Id, AggregateResult> staring) {
            article = art;
            categories = categs;
            numberOfStars = 0;
    		if (staring != null && staring.containsKey(article.Id))
    			numberOfStars = (integer)((decimal)staring.get(article.Id).get('avgRating')).round(RoundingMode.HALF_UP);
        }
        
        public KnowledgeArticleVersion article { get; set; }
        
        public integer numberOfStars { get; set; }
	    public string star1Class { get { return numberOfStars >= 1 ? 'icon-star' : 'icon-star-empty'; } }
	    public string star2Class { get { return numberOfStars >= 2 ? 'icon-star' : 'icon-star-empty'; } }
	    public string star3Class { get { return numberOfStars >= 3 ? 'icon-star' : 'icon-star-empty'; } }
	    public string star4Class { get { return numberOfStars >= 4 ? 'icon-star' : 'icon-star-empty'; } }
	    public string star5Class { get { return numberOfStars >= 5 ? 'icon-star' : 'icon-star-empty'; } }
         
        public String Summary {
            get {
                if (article.Summary == null || article.Summary.length() <= summaryCharsLimit)
                    return article.Summary;
                else
                    return article.Summary.left(summaryCharsLimit) + '...';
            }
        }
        
        public Boolean SummaryFull {
        	get {
        		return Summary == article.Summary;
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
        
	    // builds the article URL to be used in the iframe
	    public String articleURL {
	        get {
	            return 'articles/' + article.ArticleType.replace('__kav', '') + '/' + article.UrlName;
	        }
	    }
	    
	    public static Integer summaryCharsLimit = KeyValueStoreHelper.getIntegerValue('SearchResutlsSummaryCharsLimit');
	    
}