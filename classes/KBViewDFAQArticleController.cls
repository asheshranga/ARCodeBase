/*
    Controller for the view article page
    Display an article    
    Created date : Nov 2014  
    Case Number : 145364   
   
*/
public with sharing class KBViewDFAQArticleController {
    
   
    private Denver_FAQ__kav d_article;
    public String artTypeTitle {get; set;}   
    
    public KBViewDFAQArticleController (ApexPages.knowledgeArticleVersionStandardController stdController) {
                           
            
        this.d_article = (Denver_FAQ__kav)stdController.getRecord();
        System.debug('d_article: ' + this.d_article);
                 
                     
        // Article Name combination of Article Type + Article Title
        artTypeTitle = d_article.ArticleType.replace('__kav','')+' : '+d_article.Title;
        
    }
     
    public string currentLink {
        get {
            return EncodingUtil.urlEncode(URL.getCurrentRequestUrl().toExternalForm(), 'UTF-8');
        }
    }
    
    
    public string articleLink {   
      get {   
        return URL.getSalesforceBaseUrl().toExternalForm() + '/' + this.d_article.knowledgeArticleId;      
      }
    }
    
        
    // action for the "Article Request" button
    public PageReference gotoArticleRequest() {
        string reference = '/apex/KBArticleRequest?articleId=' + d_article.id +'&articleNumber='+d_article.articleNumber+'&artName='+d_article.Title+'&articleLink=' + articleLink + '&retURL=' + currentLink ;           
        return new PageReference(reference);
    }
    
    //action for the "Search Articles" button
    public PageReference gotoArticleSearch() {
    	string reference = '/_ui/knowledge/ui/KnowledgeHome?search=';
    	return new PageReference(reference);
    }
   
 }