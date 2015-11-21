public with sharing class PublicKBViewGeneral extends PublicKBViewArticle {
	public String relatedArticles {get; set;}
	public Boolean showTOC {get; set;}

	private General__kav article;
	 
	public PublicKBViewGeneral(ApexPages.StandardController stdController) {
		System.debug('PublicKBViewGeneral constructor');

		this.article = (General__kav)stdController.getRecord();
		System.debug('incoming article: ' + article);
		this.article = [Select Id, Related_Articles__c, Content__c, Summary__c, DynamicTOC__c from General__kav where Id=:article.Id];
		this.showTOC = article.DynamicTOC__c == 'Yes' ? true : false;
		
		loadKnowledgeArticle(article.Id);		
		massageRelatedArticlesField();		
	}
	
	public override String fetchArticleSummary() {
		return article.Summary__c;
	}
	
	public override String fetchTOCSourceData() {
		return article.Content__c;
	}
	
	private void loadKnowledgeArticle(Id articleId) {
		String knowledgeArticleId = [Select KnowledgeArticleId from General__kav where Id=:articleId].KnowledgeArticleId;
		System.debug('knowledgeArticleId: ' + knowledgeArticleId);
		
		loadKnowledgeArticleVersion(knowledgeArticleId);
	}
	
	private void massageRelatedArticlesField() {
		System.debug('massageRelatedArticlesField starts');
		this.relatedArticles = article.Related_Articles__c;
		System.debug('relatedArticles: ' + relatedArticles);
		if (relatedArticles == null) return;
		Integer i = relatedArticles.indexOf('<ul');
		if (i == -1) return;
		Integer j = relatedArticles.indexOf('>', i);
		if (j == -1) return;
		String ulTag = relatedArticles.substring(i, j+1);
		System.debug('ulTag: ' + ulTag);
		if (ulTag.contains('class=') == false) {
			this.relatedArticles = this.relatedArticles.replace(ulTag, KeyValueStoreHelper.getTextValue('RelatedArticlesULStyle'));
		} 
	}
}