/*
    Controller for the public view article page
    Displays an article
        
    **********************************************************
    Audit History
    **********************************************************
    4/26/2013    Lucian Ciobanu      Created
    3/29/2014    Kelly Wortel        Updated to fix ArticleRating data
    **********************************************************  
*/
public abstract with sharing class PublicKBViewArticle {

    // article id
    public Id articleId { get; set; }
    public List<AggregateResult> ags{get;set;}
    
    // article record, extracted from the database
    public KnowledgeArticleVersion article { get; set; }  
    
    // a list of all categories linked to this article
    public Map<String, KBCategoryGroupDetails> categories { get; set; }
    public KBCategoryListWrapper dataCategoryListWrapper {get; set;}
    public integer numberOfCategoryLinks { get; set; }
    
    private string sessionId;
    public String tocSourceData {get; set;}  //which field should be analyzed for preparing the TOC
    public String summary {get; set;} //custom summary field
    public PublicArticleRating__c selectedRating { get; set; }
    public PublicArticleRatingSummary__c newRatingSummary { get; set; }
    public boolean thankYouVisible { get; set; }
    public boolean ratingDescriptionIn { get; set; } // Case 240793
    public boolean sorryToHearVisible { get; set; }
    public string tempDescription { get; set; }
    public static boolean afterRating{get;set;}
    public PublicKBViewArticle() {
        thankYouVisible = false;
        sorryToHearVisible = false;
        
        Apexpages.currentPage().getHeaders().put('X-UA-Compatible', 'IE=8'); 
        
    }
    public PublicKBViewArticle currentInstance {
        get {
            return this;
        }
    }
    
    protected void loadKnowledgeArticleVersion(Id knowledgeArticleId) {
        this.article = [Select Id, ArticleNumber, Title, Summary, UrlName, ArticleType, KnowledgeArticleId, VersionNumber 
                    from KnowledgeArticleVersion where 
                    KnowledgeArticleId=:knowledgeArticleId and 
                    Language='en_US' and PublishStatus='Online' limit 1 UPDATE VIEWSTAT];
              
        this.articleId = article.Id;

        fetchSessionId();
        loadCategories();
        loadRating();
        
        this.summary = fetchArticleSummary();
        this.tocSourceData = fetchTOCSourceData();
        prepareTOC();
    }
    public abstract String fetchArticleSummary();    
    public abstract String fetchTOCSourceData();
    
    
    public void load(String articleId) {
        fetchSessionId();
                
        this.articleId = articleId;
        article = KBSOQLHelper.knowledgeArticleQuery(articleId);
        
        loadCategories();
        
        // Load Ratings
        List<AggregateResult> ags = [SELECT AVG(Rating__c) avgRating FROM PublicArticleRating__c WHERE KnowledgeArticelId__c = :articleId]; 
        numberOfStars = 0;
       
        if (ags.size() > 0 && ags.get(0).get('avgRating') != null)
            numberOfStars = Math.round((decimal)ags.get(0).get('avgRating'));
        List<PublicArticleRating__c> ratings = [SELECT Rating__c FROM PublicArticleRating__c WHERE KnowledgeArticelId__c = :articleId AND SessionId__c = :sessionId];
        if (ratings.size() > 0) {
            selectedRating = ratings.get(0);
        }
        else {
            thankYouVisible = false; 
            ratingDescriptionIn = false;      
        }
    }
    
    public void articleViewed() {
        try {       
            datetime currDateTime = datetime.now();        
            upsert newRatingSummary;
            
            selectedRating.DateViewed__c = currDateTime;
            selectedRating.PublicArticleRatingSummary__c = newRatingSummary.Id;
            upsert selectedRating;
            
        } catch (Exception ex) {
            system.debug('articleViewed Error: ' + ex);
        }
    }
  

    private void loadRating() {
        // Load Ratings
        List<AggregateResult> ags = [SELECT AVG(Rating__c) avgRating FROM PublicArticleRating__c WHERE KnowledgeArticelId__c = :articleId]; 
        numberOfStars = 0;
        if (ags.size() > 0 && ags.get(0).get('avgRating') != null) {
            numberOfStars = (integer)((decimal)ags.get(0).get('avgRating')).round(RoundingMode.HALF_UP);
        }
        List<PublicArticleRating__c> ratings = [SELECT Rating__c FROM PublicArticleRating__c WHERE KnowledgeArticelId__c = :articleId AND SessionId__c = :sessionId];
        if (ratings.size() > 0) {
            integer tempRating = (integer)((decimal)ratings.get(0).get('Rating__c')).round(RoundingMode.HALF_UP);
            selectedRating = ratings.get(0);
            
            if ( tempRating == 5 || tempRating == 4 || tempRating == 3 || tempRating == 2 || tempRating == 1 ) {
                 thankYouVisible = true;
                 afterRating = false;
                 if( thankYouVisible == true ) {
                 	afterRating = true;                   
                 }
                   
            }
            
        } else {
            // verify that a summary record exists for the Article.  If not, create one.
            thankYouVisible = false;
            ratingDescriptionIn = false;  
          
            
            List<PublicArticleRatingSummary__c> ratingSum = [SELECT Id, KnowledgeArticleId__c FROM PublicArticleRatingSummary__c WHERE KnowledgeArticleId__c = :articleId];
            if (ratingSum.size() > 0) {
                newRatingSummary = ratingSum.get(0);
            } else {
                // PublicArticleRatingSummary record doesn't exist for this session.  Create one.
                createPublicArticleRatingSummary();
            }
                         
            // Create a new detail record
            // PublicArticleRatingDetail record doesn't exist for this session.  Create one.
            createPublicArticleRatingDetail();
        }
       
        
    }    
    
    private void fetchSessionId() {
        Cookie sessionCookie = ApexPages.currentPage().getCookies().get('PKB2SessionId');
              
        if (sessionCookie == null) {
            this.sessionId = randomUUID();
            sessionCookie = new Cookie('PKB2SessionId', sessionId, '/', -1, false);
            ApexPages.currentPage().setCookies(new Cookie[]{sessionCookie});
        } else {
            this.sessionId = sessionCookie.getValue();
        }
        
    }
    
    private String randomUUID(){
        String kHexChars = '0123456789abcdefABCDEF';
        String returnValue = '';
        Integer nextByte = 0;
        for(Integer i = 0; i < 16; i++){
            if(i==4 || i==6 || i==8 || i==10){
                returnValue += '-';
            }
            //generate a "byte"; i.e., number in range [-2^7,2^7-1]
            nextByte = (Math.round(Math.random() * 255)-128) & 255;

            if(i==6){
                nextByte = nextByte & 15;
                nextByte = nextByte | (4 << 4);
            }
            if(i==8){
                nextByte = nextByte & 63;
                nextByte = nextByte | 128;
            }
            
            returnValue += charAt(kHexChars,nextByte >> 4);
            returnValue += charAt(kHexChars,nextByte & 15);
        }
        return returnValue;
    }
    
    @TestVisible
    private String charAt(String str, Integer index) {
        if(str == null){
            return null;
        }
        if(str.length() <= 0){
            return str;    
        }
        if(index < 0 || index >= str.length()){
            return null;    
        }
        return str.substring(index, index+1);
    }
    
    // builds a map with all the categories linked to the article
    private void loadCategories() {
        
        string categorizationName = article.ArticleType.replace('__kav', '__DataCategorySelection');
        
        List<sObject> categoriesWithNames = database.query('SELECT Id, DataCategoryGroupName, DataCategoryName FROM ' + categorizationName + ' WHERE ParentId = \'' + article.Id + '\'');
        Map<Id, sObject> categoriesWithLabels = new Map<Id, sObject>(database.query('SELECT Id, toLabel(DataCategoryGroupName), toLabel(DataCategoryName) FROM ' + categorizationName + ' WHERE ParentId = \'' + article.Id + '\''));
        
        numberOfCategoryLinks = 0;
        
        categories = new Map<String, KBCategoryGroupDetails>();
        for (sObject categoryWithName : categoriesWithNames) {
            sObject categoryWithLabel = categoriesWithLabels.get(categoryWithName.Id);
            String gpName = (string)categoryWithName.get('DataCategoryGroupName');
            String catName = (string)categoryWithName.get('DataCategoryName');
                        
            if (!gpName.startsWith('Customer_Categories') && !gpName.startsWith('Denver_Product'))
                continue;
            
            if (!categories.containsKey(gpName)) {
                categories.put(gpName, 
                        new KBCategoryGroupDetails(gpName, (string)categoryWithLabel.get('DataCategoryGroupName')));
            }
            if (catName.startsWith('Trending_Articles') == false) {
                categories.get(gpName).Categories.add(new KBCategoryDetails(catName, (string)categoryWithLabel.get('DataCategoryName')));
            }
            numberOfCategoryLinks ++;
        }
        this.dataCategoryListWrapper = new KBCategoryListWrapper(categories);
    }

    public integer numberOfStars { get; set; }
    public string star1Class { get { return numberOfStars >= 1 ? 'icon-star' : 'icon-star-empty'; } }
    public string star2Class { get { return numberOfStars >= 2 ? 'icon-star' : 'icon-star-empty'; } }
    public string star3Class { get { return numberOfStars >= 3 ? 'icon-star' : 'icon-star-empty'; } }
    public string star4Class { get { return numberOfStars >= 4 ? 'icon-star' : 'icon-star-empty'; } }
    public string star5Class { get { return numberOfStars >= 5 ? 'icon-star' : 'icon-star-empty'; } }
    
   public PageReference VoteStars() {
         
        try {
            Integer tempRating = Integer.valueOf(Apexpages.currentPage().getParameters().get('paramStars'));
                       
            /* Added tempRating Integer number from 1 to 5 for rating 'Stars' with thankYouVisible message and  commented 
            else part (before there was - 'Yes' and 'NO' button,  which displays proper mesage based on user clicks on it. )*/ 
             
            if (tempRating == 1 || tempRating == 2 ||tempRating == 3 ||
                 tempRating == 4 || tempRating == 5) 
            {
                  thankYouVisible = true; 
            }
            
            datetime currDateTime = datetime.now();
            newRatingSummary.LastVoteDate__c = currDateTime;  
                      
            upsert newRatingSummary;

            selectedRating.Rating__c = tempRating;
            selectedRating.KnowledgeArticelId__c = articleId;
                       
            if (selectedRating.PublicArticleRatingSummary__c == null) 
                selectedRating.PublicArticleRatingSummary__c = newRatingSummary.Id;
                
            upsert selectedRating;
            
           
            ags = [SELECT AVG(Rating__c) avgRating FROM PublicArticleRating__c WHERE KnowledgeArticelId__c = :articleId];
                            
            if (ags.size() > 0 && ags.get(0).get('avgRating') != null){
                numberOfStars = Math.round((decimal)ags.get(0).get('avgRating'));
            }
         
            return null;
        } catch (Exception ex) {
            string trackingNumber = PublicKBErrors.AddError(ex);
            PageReference pr = Page.PublicKBError;
            pr.getParameters().put('trackingNumber', trackingNumber);
            pr.setRedirect(true);
            return pr;
        }
    }
    
    public PageReference updateRatingDescription() { 
        try {
            //tempDescription = Apexpages.currentPage().getParameters().get('rateDescription');
            
            selectedRating.RatingDescription__c = tempDescription;
            update selectedRating;
            
            thankYouVisible = true; 
            
            ratingDescriptionIn = true;
                     
            return null;            
            
        } catch (Exception ex) {
            string trackingNumber = PublicKBErrors.AddError(ex);
            PageReference pr = Page.PublicKBError;
            pr.getParameters().put('trackingNumber', trackingNumber);
            pr.setRedirect(true);
            return pr;        
        }
    
    }
    
    public PublicKBHome getSearchController() {
        PublicKBHome obj = new PublicKBHome();
        obj.searchDone = true;
        return obj;
    }
    
    public List<TOCLine> tocList {get; set;}
    public Boolean hasTOC {get {return tocList != null && tocList.size()>0;} set;}
    
    //Using custom summary field, it prepares table of contents for display
    private void prepareTOC() {
        System.debug('prepareTOC start');
        if (tocSourceData == null) return;
        this.tocList = new List<TOCLine>();
        
        Integer i=0,j=0,m=0,n=0;
        String h3Line, startTag, endTag, h3Data, h3DataTrimmed, anchorTag;
        startTag = KeyValueStoreHelper.getTextValue('TOCIdentifierStartTag');
        endTag = KeyValueStoreHelper.getTextValue('TOCIdentifierEndTag');
       
        
        while (true) {
            i = tocSourceData.indexOf(startTag, i);
            if (i == -1) break;
            j = tocSourceData.indexOf(endTag, i);
            if (j == -1) break;
            h3Line = tocSourceData.substring(i, j+endTag.length());
            
            h3Data = h3Line.replace(startTag, '');
            h3Data = h3Data.replace(endTag, '').trim();
                        
            if (h3Data.startsWith('<')) {
                m = h3Data.indexOf('</');
                if (m == -1) break;
                h3Data = h3Data.substring(0, m).trim();
                n = h3Data.lastIndexOf('>');
                if (n == -1) break;
                h3Data = h3Data.substring(n+1).trim();
            }
            else {
                m = h3Data.indexOf('<');
                if (m != -1) {
                    h3Data = h3Data.substring(0, m).trim();
                }
            }
                       
            h3DataTrimmed = h3Data.remove(' ');
            h3DataTrimmed = h3DataTrimmed.remove('#');
            h3DataTrimmed = h3DataTrimmed.remove('?');
            h3DataTrimmed = h3DataTrimmed.remove('.');
            h3DataTrimmed = h3DataTrimmed.remove('-');
            
            anchorTag = '<a name="' + h3DataTrimmed + '"></a>';
            tocSourceData = tocSourceData.substring(0, i) + anchorTag +
                        tocSourceData.substring(i);
                        
            this.tocList.add(new TOCLine(h3Data, h3DataTrimmed));
            i=j+anchorTag.length();
        }
        
    }
  
    public class TOCLine {
        public String title {get; set;}
        public String anchorHref {get; set;}
        
        public TOCLine(String title, String anchorHref) {
            this.title = title;
            this.anchorHref = anchorHref;
        }
    }
    
	@TestVisible
    private void createPublicArticleRatingSummary() {
        // Create new summary record if one doesn't exist for this article
        newRatingSummary = new PublicArticleRatingSummary__c();
        newRatingSummary.KnowledgeArticleId__c = articleId;
        newRatingSummary.ArticleTitle__c = article.Title;
        newRatingSummary.ArticleNumber__c = article.ArticleNumber;
        newRatingSummary.ArticleType__c = article.ArticleType;
        newRatingSummary.ArticleURLName__c = article.UrlName;
        
    }
    
    @TestVisible
    private void createPublicArticleRatingDetail() {
        // Create a detail record for this article/session
        selectedRating = new PublicArticleRating__c();
        selectedRating.SessionId__c = sessionId;
        selectedRating.KnowledgeArticelId__c = article.KnowledgeArticleId;
        selectedRating.KnowledgeArticleVersionId__c = articleId;
        selectedRating.ArticleTitle__c = article.Title;
        selectedRating.ArticleNumber__c = article.ArticleNumber;
        selectedRating.ArticleType__c = article.ArticleType;
        selectedRating.ArticleURLName__c = article.UrlName;
        String tempVersion = String.valueOf(article.VersionNumber);
        selectedRating.ArticleVersion__c = tempVersion;
        //selectedRating.browser__c = ApexPages.currentPage().getHeaders().get('USER-AGENT');
        
    }
    
   
    
}