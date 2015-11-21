/*
    Controller for the public knowledgebase page
        
    **********************************************************
    Audit History
    **********************************************************
    3/27/2013    Lucian Ciobanu      Created
    **********************************************************  
*/
public with sharing class PublicKBHome {
    
    // search keywork
    public String searchKeyword { get; set; }
    
    // selected categories
    public String categoryLevel1 { get; set; }
    public String categoryLevel2 { get; set; }
    public String selectedProduct { get; set; }
    
    // category used for the search
    public String selectedCategory { get; set; }

    // true after the user clicks on "Search"
    public String doSearch {get; set;}
    public boolean searchDone { get; set; }
    
    // result of article search
    public List<KBArticleWrapper> articleSearchResult {get; set;}

    // View advanced items
    public boolean viewAdvanced { get; set; }
    
    private boolean searchAction;
    
    public PublicKBHome() {
        System.debug('public kb home constructor');
        // initialization
        searchDone = false;
        viewAdvanced = false;
        selectedCategory = null;
        articleSearchResult = new List<KBArticleWrapper>();
        searchKeyword = ApexPages.currentPage().getParameters().get('searchKeyword');
        categoryLevel1 = ApexPages.currentPage().getParameters().get('categoryLevel1');
        categoryLevel2 = ApexPages.currentPage().getParameters().get('categoryLevel2');
        selectedProduct = ApexPages.currentPage().getParameters().get('selectedProduct');
        doSearch = ApexPages.currentPage().getParameters().get('dosearch');
        searchAction = !String.isEmpty(doSearch);
        System.debug('searchkeyword: ' + searchKeyword + ', categoryLevel1: ' + categoryLevel1 + 
                    ', categoryLevel2: ' + categoryLevel2 + ', searchAction: ' + searchAction);
        viewAdvanced = !String.isEmpty(categoryLevel1) || !String.isEmpty(categoryLevel2);
    }
    public PageReference Load() {
        try {
            if (searchAction) {
                doSearch();
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
    
    // Search
    public PageReference doSearch() {
        try {
            System.debug('doSearch start');
            if (!viewAdvanced)
                selectedCategory = null;
            else {
                if (categoryLevel2 != null && categoryLevel2 != '' && !categoryLevel2.endsWith('__c'))
                    selectedCategory = categoryLevel2 + '__c';
                else {
                    if (categoryLevel1 != null && categoryLevel1 != '' && !categoryLevel1.endsWith('__c'))
                        selectedCategory = categoryLevel1 + '__c';
                    else
                        selectedCategory = null;
                }
            }
            System.debug('selectedCategory: ' + selectedCategory);
            searchDone = true;
            
            if (String.isEmpty(doSearch)) doSearch = '1';
            PageReference p = Page.PublicKBHome;
            p.getParameters().put('searchKeyword', searchKeyword);
            p.getParameters().put('categoryLevel1', categoryLevel1);
            p.getParameters().put('categoryLevel2', categoryLevel2);
            p.getParameters().put('dosearch', doSearch);
            p.setRedirect(true);
            return p;
        } catch (Exception ex) {
            string trackingNumber = PublicKBErrors.AddError(ex);
            PageReference pr = Page.PublicKBError;
            pr.getParameters().put('trackingNumber', trackingNumber);
            pr.setRedirect(true);
            return pr;
        }
    }
    
    // Toggle view advanced items
    public void toggleAdvanced() {
        viewAdvanced = !viewAdvanced;
    }
    
    // Returns a list of all topics
    public List<SelectOption> getCategoriesLevel1() {
        List<SelectOption> topics = new List<SelectOption>();
        try {
            topics.add(new SelectOption('', '-- No filter --'));
            
            DataCategoryGroupSobjectTypePair pair = new DataCategoryGroupSobjectTypePair();
            pair.setSobject('KnowledgeArticleVersion');
            pair.setDataCategoryGroupName('Customer_Categories');
            for (DataCategory categ : Schema.describeDataCategoryGroupStructures(new Datacategorygroupsobjecttypepair[] { pair }, false)[0].getTopCategories()[0].getChildCategories())
                if (categ.getName().toLowerCase() != 'home_page_components')
                    topics.add(new SelectOption(categ.getName(), categ.getLabel()));
        } catch (Exception ex) {
            PublicKBErrors.AddError(ex);
        }
        
        return topics;
    }
    
    // Returns a list of all subtopics in a topic
    public List<SelectOption> getCategoriesLevel2() {
        List<SelectOption> subtopics = new List<SelectOption>();
        try {
            subtopics.add(new SelectOption('', '-- No filter --'));
            
            DataCategoryGroupSobjectTypePair pair = new DataCategoryGroupSobjectTypePair();
            pair.setSobject('KnowledgeArticleVersion');
            pair.setDataCategoryGroupName('Customer_Categories');
            for (DataCategory categ : Schema.describeDataCategoryGroupStructures(new Datacategorygroupsobjecttypepair[] { pair }, false)[0].getTopCategories()[0].getChildCategories())
                if (categ.getName() == categoryLevel1)
                    for (DataCategory categ2 : categ.getChildCategories())
                        subtopics.add(new SelectOption(categ2.getName(), categ2.getLabel()));
        } catch (Exception ex) {
            PublicKBErrors.AddError(ex);
        }
        
        return subtopics;
    }
    
    // Returns the current object
    public PublicKBHome getControllerObj() {
        return this;
    }
    
    // Returns the search class tag name
    public String getSearchStyleClassName() {
        return searchDone ? '' : 'collapse';
    }
    
    // Returns the advanced search button text
    public String getAdvancedSearchButtonText() {
        return searchDone ? '' : 'Advanced Search';
    }
    
}