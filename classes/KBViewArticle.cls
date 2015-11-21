/*
    Controller for the view article page
    Display an article
        
    **********************************************************
    Audit History
    **********************************************************
    4/10/2013    Lucian Ciobanu      Created
    **********************************************************  
*/
public with sharing class KBViewArticle  {

    public boolean inConsole { get; set; }
    

    // article id,number,title
    public Id articleId { get; set; }
    public String artNum{get;set;}
    public String artName {get;set;}
    public String artTypeTitle{get;set;}
    public String articleLink{get;set;}
    
    // article record, extracted from the database
    public KnowledgeArticleVersion article { get; set; }
    
    // a list of all categories linked to this article
    public Map<String, CategoryGroupDetails> categories { get; set; }
    
    public KBViewArticle() {
        
        inConsole = false;
        if (!String.isEmpty(ApexPages.currentPage().getParameters().get('isdtp')))
            inConsole = true;
                  
        // extract the article id and article
        articleId = ApexPages.currentPage().getParameters().get('id');
        
        article = KBSOQLHelper.knowledgeArticleQuery(articleId) ;
        artNum=article.ArticleNumber;
        artName = article.Title;
        // Article Name combination of Article Type + Article Title
        artTypeTitle = article.ArticleType.replace('__kav','')+' : '+article.Title;
        loadCategories();
    }
     
    public string currentLink {
        get {
            return EncodingUtil.urlEncode(URL.getCurrentRequestUrl().toExternalForm(), 'UTF-8');
        }
    }
    
    // action for the "Article Request" button
    public PageReference gotoArticleRequest() {
        string reference = '/apex/KBArticleRequest?articleId=' + articleId +'&articleNumber='+artNum+'&artName='+artTypeTitle+'&articleLink=' + currentLink + '&retURL=' + currentLink ;
        string isdtp = ApexPages.currentPage().getParameters().get('isdtp');
        if (isdtp == 'nv')
            reference += '&isdtp=nv';
        return new PageReference(reference);
    }
    
    // builds the article URL to be used in the iframe
    public String articleURL {
        get {
            return article.ArticleType.replace('__kav', '') + '/' + article.UrlName;
        }
    }
    
    // builds a map with all the categories linked to the article
    private void loadCategories() {
        string categorizationName = article.ArticleType.replace('__kav', '__DataCategorySelection');
        
        List<sObject> categoriesWithNames = database.query('SELECT Id, DataCategoryGroupName, DataCategoryName FROM ' + categorizationName + ' WHERE ParentId = \'' + article.Id + '\'');
        Map<Id, sObject> categoriesWithLabels = new Map<Id, sObject>(database.query('SELECT Id, toLabel(DataCategoryGroupName), toLabel(DataCategoryName) FROM ' + categorizationName + ' WHERE ParentId = \'' + article.Id + '\''));
        
        categories = new Map<String, CategoryGroupDetails>();
        for (sObject categoryWithName : categoriesWithNames) {
            sObject categoryWithLabel = categoriesWithLabels.get(categoryWithName.Id);
            if (!categories.containsKey((string)categoryWithName.get('DataCategoryGroupName')))
                categories.put((string)categoryWithName.get('DataCategoryGroupName'), new CategoryGroupDetails((string)categoryWithName.get('DataCategoryGroupName'), (string)categoryWithLabel.get('DataCategoryGroupName')));
            categories.get((string)categoryWithName.get('DataCategoryGroupName')).Categories.add(new CategoryDetails((string)categoryWithName.get('DataCategoryName'), (string)categoryWithLabel.get('DataCategoryName')));
        }
    }

    // wrapper class for the article category group
    public class CategoryGroupDetails {
        
        public List<CategoryDetails> Categories { get; set; }
        
        public string Name { get; set; }
        public string Label { get; set; }
        
        public integer CategoriesCount {
            get {
                return Categories.size();
            }
        }
        
        public CategoryGroupDetails(string nm, string lb) {
            Name = nm;
            Label = lb;
            Categories = new List<CategoryDetails>();
        }
    } 

    // wrapper class for the article category
    public class CategoryDetails {
        
        public string Name { get; set; }
        public string Label { get; set; }
        
        public CategoryDetails(string nm, string lb) {
            Name = nm; 
            Label = lb;
        }
    }
    
    

}