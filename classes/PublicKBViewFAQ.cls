public with sharing class PublicKBViewFAQ extends PublicKBViewArticle {
	public String relatedArticles {get; set;}
	public Boolean showTOC {get; set;}

	private Denver_FAQ__kav article;
	 
	public PublicKBViewFAQ(ApexPages.StandardController stdController) {
		System.debug('PublicKBViewFAQ constructor');

		this.article = (Denver_FAQ__kav)stdController.getRecord();
		System.debug('incoming article: ' + article);
		this.article = [Select Id, Summary, Content__c, DynamicTOC__c 
						from Denver_FAQ__kav where Id=:article.Id];
		this.showTOC = article.DynamicTOC__c == 'Yes' ? true : false;
		
		loadKnowledgeArticle(article.Id);		
	}
	
	public override String fetchArticleSummary() {
		return article.Summary;
	}
	
	public override String fetchTOCSourceData() {
		return article.Content__c;
	}
	
	private void loadKnowledgeArticle(Id articleId) {
		String knowledgeArticleId = [Select KnowledgeArticleId from Denver_FAQ__kav where Id=:articleId].KnowledgeArticleId;
		System.debug('knowledgeArticleId: ' + knowledgeArticleId);
		
		loadKnowledgeArticleVersion(knowledgeArticleId);
	}
}