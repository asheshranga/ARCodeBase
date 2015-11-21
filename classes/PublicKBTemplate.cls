/*
    Controller for the public knowledgebase footer section
        
    **********************************************************
    Audit History
    **********************************************************
    5/1/2013    Shah Kadirmohideen      Created
    1/14/2013    Kelly Wortel            Added isProd variable to support secure contact us page
    **********************************************************  
*/
public class PublicKBTemplate {
    
    public List<FooterRow> footerRows {get; set;}
    private static final Integer TOTAL_FOOTER_COLUMNS = 4;
    public boolean isProd {get; set;} 
 
    public PageReference Load() {
        // check if this is PROD
        isProd = ( UserInfo.getOrganizationId() == '00D70000000K0RwEAK' );  
        system.debug('isProd: ' + isProd);          
                  
        try {
            //Load the primary and sub categories for 'Customer Categories' data category
            DataCategoryGroupSobjectTypePair pair = new DataCategoryGroupSobjectTypePair();
            pair.setSobject('KnowledgeArticleVersion');
            pair.setDataCategoryGroupName('Customer_Categories');
            
            this.footerRows = new List<FooterRow>();
            List<CategoryWrapper> categories = new List<CategoryWrapper>();
    
            for (DataCategory categ : Schema.describeDataCategoryGroupStructures(
                    new Datacategorygroupsobjecttypepair[] { pair }, false)[0].getTopCategories()[0].
                    getChildCategories()) {
                if (categ.getName().toLowerCase() == 'home_page_components')
                    continue;
                List<CategoryWrapper> subCategories = new List<CategoryWrapper>();      
                for (DataCategory categ2 : categ.getChildCategories()) {
                    subCategories.add(new CategoryWrapper(categ2.getName(), categ2.getLabel()));
                }
                CategoryWrapper primaryCategory = new CategoryWrapper(categ.getName(), categ.getLabel(), subCategories);
                categories.add(primaryCategory);
                
                if (categories.size() == TOTAL_FOOTER_COLUMNS) {
                    footerRows.add(new FooterRow(categories));
                    categories = new List<CategoryWrapper>();
                }
            }
            if (categories.size() > 0) {
                footerRows.add(new FooterRow(categories));
            }
            
            System.debug('total footerRows loaded: ' + footerRows.size());
            return null;
        } catch (Exception ex) {
            string trackingNumber = PublicKBErrors.AddError(ex);
            PageReference pr = Page.PublicKBError;
            pr.getParameters().put('trackingNumber', trackingNumber);
            pr.setRedirect(true);
            return pr;
        }
    }
    
    /* INNER CLASSES */
    
    //Represents a primary data category and its sub categories
    public class CategoryWrapper {
        public String categoryName {get; set;}
        public String categoryAPIName {get; set;}
        public List<CategoryWrapper> subCategories {get; set;}
        
        public CategoryWrapper(String categoryAPIName, String categoryName, List<CategoryWrapper> subCategories) {
            this.categoryName = categoryName;
            this.categoryAPIName = categoryAPIName;
            this.subCategories = subCategories;
        }
        public CategoryWrapper(String categoryAPIName, String categoryName) {
            this.categoryName = categoryName;
            this.categoryAPIName = categoryAPIName;
        }
    }
    
    //Represents a single row in the footer
    public class FooterRow {
        public List<CategoryWrapper> categories {get; set;}
        
        public FooterRow(List<CategoryWrapper> categories) {
            this.categories = categories;
        }
    }
}