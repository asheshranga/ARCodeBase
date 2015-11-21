public with sharing class PublicKBViewArticleDummy extends PublicKBViewArticle {
    public String relatedArticles {get; set;}
    public Boolean showTOC {get; set;}
    private string sessionId;
    private General__kav article;
     
    public PublicKBViewArticleDummy(ApexPages.StandardController stdController) {
        this.article = (General__kav)stdController.getRecord();
        this.article = [Select Id, Related_Articles__c, Content__c, Summary__c, DynamicTOC__c from General__kav where Id=:article.Id];
        this.showTOC = article.DynamicTOC__c == 'Yes' ? true : false;         
        List<AggregateResult> ags = [SELECT AVG(Rating__c) avgRating FROM PublicArticleRating__c WHERE KnowledgeArticelId__c = :article.Id];     
       
        loadKnowledgeArticle(article.Id);   
        load(article.Id);   
        PublicArticleRating__c selected=new PublicArticleRating__c();  
        VoteStars(); 
        getSearchController();      
        massageRelatedArticlesField();                
    }
    
    public override String fetchArticleSummary() {
        return article.Summary__c;
    }
    
    public override String fetchTOCSourceData() {
           return article.Content__c;
    }
    
    @TestVisible
    private  void loadKnowledgeArticle(Id articleId) {
        String knowledgeArticleId = [Select KnowledgeArticleId from General__kav where Id=:articleId].KnowledgeArticleId;
        loadKnowledgeArticleVersion(KnowledgeArticleId );
        List<AggregateResult> ags = [SELECT AVG(Rating__c) avgRating FROM PublicArticleRating__c WHERE KnowledgeArticelId__c = :knowledgeArticleId]; 
        load(article.Id);         
        this.summary = fetchArticleSummary();
        this.tocSourceData = fetchTOCSourceData();        
      }
        
     @TestVisible   
     private void massageRelatedArticlesField() {
        
        this.relatedArticles = article.Related_Articles__c;
        if (relatedArticles == null) 
            return;
        Integer i = relatedArticles.indexOf('<ul');
        System.debug('!!!! Int I: ' + i);
        if (i == -1) 
            return;
        Integer j = relatedArticles.indexOf('>', i);
        if (j == -1) 
            return;
        String ulTag = relatedArticles.substring(i, j+1);
        System.debug('!!!! ulTag: ' + ulTag);
        if (ulTag.contains('class=') == false) {
            this.relatedArticles = this.relatedArticles.replace(ulTag, KeyValueStoreHelper.getTextValue('RelatedArticlesULStyle'));
        } 
    }
}