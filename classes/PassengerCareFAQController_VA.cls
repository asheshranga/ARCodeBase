public class PassengerCareFAQController_VA {    
    //--Text constants
    public String FAQHeader {get {return PassengerCareConstants.FAQ_HEADER;}}
    public String FAQHeaderText {get {return PassengerCareConstants.FAQ_HEADER_TEXT;}}
    public String FAQPageTitle {get {return PassengerCareConstants.FAQ_PAGE_TITLE;}}
    public String CallUsPhone {get {return PassengerCareConstants.CALL_US_PHONE;}}
    
    //--Help Links
    public String LearnMoreViaSatURL {get {return PassengerCareConstants.LEARN_MORE_VIASAT_URL;}}
    public String LearnMoreExedeURL {get {return PassengerCareConstants.LEARN_MORE_EXEDE_URL;}}
    
    //Lists to store FAQ Articles
    public List<FAQwrapper> lstPassengerCareFAQ{get;set;}
    public List<FAQArticlewrapper> lstFAQArticle{get;set;}
    
    //---Begin Constructor
    public PassengerCareFAQController_VA (){          
        String lstrQuery    = '';
        lstPassengerCareFAQ = new List<FAQwrapper>();
        
        //---Get Categories and its related Articles
        DataCategoryGroupSobjectTypePair pair = new DataCategoryGroupSobjectTypePair();
        pair.setSobject('KnowledgeArticleVersion');
        pair.setDataCategoryGroupName('PassengerCareFAQCategories');        
        
        //--Loop through each category
        for (DataCategory categ : Schema.describeDataCategoryGroupStructures(new Datacategorygroupsobjecttypepair[] { pair }, false)[0].getTopCategories()[0].getChildCategories()){
            try{
                //--For every category get the list of related Articles
                lstFAQArticle = new List<FAQArticlewrapper>();
                lstrQuery = '';
                lstrQuery = 'select Id,Question__c,Answer__c,PassengerCareArticleID__c from PassengerCareFAQ_VA__kav where ID in (SELECT ID FROM KnowledgeArticleVersion WHERE PublishStatus = \'Online\' AND Language = \'en_US\' WITH DATA CATEGORY PassengerCareFAQCategories__c BELOW ';
                lstrQuery = lstrQuery + categ.getName() + '__c) ORDER BY PassengerCareArticleID__c ASC';
                
                //--Loop to retrieve Articles of one Category
                for(PassengerCareFAQ_VA__kav faq: Database.query(lstrQuery)){
                    lstFAQArticle.add(new FAQArticlewrapper(faq.Question__c,faq.Answer__c,faq.ID));
                }                
                
                //--Add Category and its Article List to the FAQWrapper list
                lstPassengerCareFAQ.add(new FAQwrapper(categ.getName(),categ.getLabel(),lstFAQArticle)); 
            }
            catch(Exception e){
                System.debug('Error '+e);
            }            
        }                
    }//---End Constructor
    
    
    //---Wrapper Class to hold FAQ Articles
    public class FAQArticleWrapper{        
        public Id faqID {get;set;}        
        public String Question{get;set;}
        public String Answer{get;set;}                
        
        public FAQArticleWrapper(String Question, String Answer, Id faqID){
            this.Question = Question;
            this.Answer = Answer;
            this.faqID = faqID;       
        }
        
    }//--End Wrapper FAQArticleWrapper
    
    
    //---Wrapper Class to hold FAQ Categories with its Articles
    public class FAQWrapper{        
        public String CategoryName {get;set;}        
        public String Category{get;set;}
        public List<FAQArticleWrapper> lstFAQ{get;set;}                
        
        public FAQWrapper(String CategoryName, String Category, List<FAQArticlewrapper> lstFAQ){
            this.CategoryName = CategoryName;
            this.Category = Category;
            this.lstFAQ = lstFAQ;       
        }        
    }//--End Wrapper FAQWrapper
}