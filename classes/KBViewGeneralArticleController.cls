/*
    Controller for the view article page
    Display an article    
    Created date: Nov 2014 
    Case Number : 145364    
   
*/
public with sharing class KBViewGeneralArticleController {

   
    // article record, extracted from the database
    private General__kav g_article;           
    public String artTypeTitle {get; set;}   
    
    public KBViewGeneralArticleController(ApexPages.knowledgeArticleVersionStandardController stdController) {
                          
            
        this.g_article = (General__kav)stdController.getRecord();               
        System.debug('g_article: ' + this.g_article);
                 
                     
        // Article Name combination of Article Type + Article Title
        artTypeTitle = g_article.ArticleType.replace('__kav','')+' : '+g_article.Title;
        
    }
     
    public string currentLink {
        get {
            return EncodingUtil.urlEncode(URL.getCurrentRequestUrl().toExternalForm(), 'UTF-8');
        }
    }
    
    
    public string articleLink {   
      get {   
        return URL.getSalesforceBaseUrl().toExternalForm() + '/' + this.g_article.knowledgeArticleId;      
      }
    }
    
    
    
    // action for the "Article Request" button
    public PageReference gotoArticleRequest() {
        string reference = '/apex/KBArticleRequest?articleId=' + g_article.id +'&articleNumber='+g_article.articleNumber+'&artName='+g_article.Title+'&articleLink=' + articleLink + '&retURL=' + currentLink ;              
        return new PageReference(reference);
    }
    
    //action for the "Search Articles" button
    public PageReference gotoArticleSearch() {
    	string reference = '/_ui/knowledge/ui/KnowledgeHome?search=';
    	return new PageReference(reference);
    }
    
  

}