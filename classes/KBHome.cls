/*
    Controller for the knowledge base home page.
        
    **********************************************************
    Audit History
    **********************************************************
    31/3/2013    Lucian Ciobanu      Created
    **********************************************************  
*/
public with sharing class KBHome {

	public boolean inConsole { get; set; }

    // search keywork
    public String searchKeyword { get; set; }
    
    // selected categories
    public String internalCareCategory { get; set; }
    public String customerCategory { get; set; }
    public String productCategory { get; set; }
    
    // true after the user clicks on "Search"
    public boolean searchDone { get; set; }
    
    public KBHome() {
    	inConsole = false;
    	if (!String.isEmpty(ApexPages.currentPage().getParameters().get('isdtp')))
    		inConsole = true;
    		
        // initialization
        searchKeyword = ApexPages.currentPage().getParameters().get('searchKeyword');
        internalCareCategory = ApexPages.currentPage().getParameters().get('internalCareCategory');
        customerCategory = ApexPages.currentPage().getParameters().get('customerCategory');
        productCategory = ApexPages.currentPage().getParameters().get('productCategory');
        searchDone = ApexPages.currentPage().getParameters().get('searchDone') == 'true';
        collectDataFromViewArticlePage();        
    }
    
    // Search
    public PageReference doSearch() {
        searchDone = true;
        PageReference p = Page.KBHome;
        p.getParameters().put('searchKeyword', searchKeyword);
        p.getParameters().put('internalCareCategory', internalCareCategory);
        p.getParameters().put('customerCategory', customerCategory);
        p.getParameters().put('productCategory', productCategory);
        p.getParameters().put('searchDone', 'true');
        p.setRedirect(true);
        return p;
    }
    
    // gets a list of internal care categories
    public List<SelectOption> internalCareCategories {
        get {
            return getCategories('Care_Categories');
        }
    }
    
    // gets a list of customer categories
    public List<SelectOption> customerCategories {
        get {
            return getCategories('Customer_Categories');
        }
    }
    
    // gets a list of product categories
    public List<SelectOption> productCategories {
        get {
            return getCategories('Denver_Product');
        }
    }
    
    // private method that returns a tree list for a selected category
    private List<SelectOption> getCategories(string categAPIName) {
        List<SelectOption> toReturn = new List<SelectOption>();
        toReturn.add(new SelectOption('', '-- No filter --'));
        DataCategoryGroupSobjectTypePair pair = new DataCategoryGroupSobjectTypePair();
        pair.setSobject('KnowledgeArticleVersion');
        pair.setDataCategoryGroupName(categAPIName);
        for (DataCategory categ : Schema.describeDataCategoryGroupStructures(new Datacategorygroupsobjecttypepair[] { pair }, false)[0].getTopCategories()) {
            toReturn.add(new SelectOption(categ.getName() + '__c', categ.getLabel()));
            addSubcategories(toReturn, categ, '&nbsp;&nbsp;');
        }
        return toReturn;
    }
    
    // recursive method that build the category tree
    private void addSubcategories(List<SelectOption> toReturn, DataCategory categ, String level) {
        for (DataCategory subcateg : categ.getChildCategories()) {
            SelectOption so = new SelectOption(subcateg.getName() + '__c', level + subcateg.getLabel());
            so.setEscapeItem(false);
            toReturn.add(so);
            addSubcategories(toReturn, subcateg, level + '&nbsp;&nbsp;');
        }
    }
    
    // if we come back from View Article with a search by category
    private void collectDataFromViewArticlePage() {
        string groupName = ApexPages.currentPage().getParameters().get('groupName');
        if (groupName == 'Care_Categories') {
            internalCareCategory = ApexPages.currentPage().getParameters().get('categoryName');
            if (String.isEmpty(internalCareCategory))
                internalCareCategory = internalCareCategories[1].getValue();
            else
                internalCareCategory += '__c';
            searchDone = true;
        }
        if (groupName == 'Customer_Categories') {
            customerCategory = ApexPages.currentPage().getParameters().get('categoryName');
            if (String.isEmpty(customerCategory))
                customerCategory = customerCategories[1].getValue();
            else
                customerCategory += '__c';
            searchDone = true;
        }
        if (groupName == 'Denver_Product') {
            productCategory = ApexPages.currentPage().getParameters().get('categoryName');
            if (String.isEmpty(productCategory))
                productCategory = productCategories[1].getValue();
            else
                productCategory += '__c';
            searchDone = true;
        }
    }
    
    // action for the "Article Request" button
    public PageReference gotoArticleRequest() {
    	string reference = '/apex/KBArticleRequest?retURL=%2Fapex%2FKBHome';
    	string isdtp = ApexPages.currentPage().getParameters().get('isdtp');
    	if (isdtp == 'nv')
    		reference += '&isdtp=nv';
        PageReference pr = new PageReference(reference);
        pr.setRedirect(true);
        return pr;
    }

    public static testMethod void test1() {
        ApexPages.currentPage().getParameters().put('groupName','Care_Categories');
        KBHome controller = new KBHome();
        controller.doSearch();
        controller.gotoArticleRequest();
        
        System.assertEquals(controller.searchDone, true);
        
        ApexPages.currentPage().getParameters().put('groupName','Customer_Categories');
        controller = new KBHome();
        controller.doSearch();
        controller.gotoArticleRequest();
        
        ApexPages.currentPage().getParameters().put('groupName','Denver_Product');
        controller = new KBHome();
        controller.doSearch();
        controller.gotoArticleRequest();

    }
}