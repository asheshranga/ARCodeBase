/*
    Controller for the public Contact Us page
        
    **********************************************************
    Audit History
    **********************************************************
    4/26/2013    Lucian Ciobanu      Created
    **********************************************************  
*/

public with sharing class PublicKBContactUs {
    public string nameValue {get; set;}
    public string firstnameValue { get; set; }   
    public string lastnameValue { get; set; }    
    public string phoneValue { get; set; }   
    public string emailValue { get; set; }    
    public string productValue { get; set; }
    public string validationValue { get; set; }
    public string helpValue { get;  set; }
    
    public Boolean missingData {get; set;}
    public Boolean incorrectPhone{get; set;}
    public Boolean incorrectEmail {get; set;}
    public Boolean missingHelp {get; set;}
    public string exedePhone { get; set; }
    public string wildbluePhone { get; set; }
    public string viasatAddress { get; set; }
    public List<KBArticleWrapper> searchResults { get; set; }
    public string chatDeploymentId { get; set; }
    public string chatButtonId { get; set; }
    public Boolean searchDone {get; set;}
    public Boolean emailSent {get; set;}
    public String liveAgentDomain {get {return KeyValueStoreHelper.getTextValue('LiveAgentDomain'); } set;}
    public String validationHelpText {get {return Schema.sObjectType.Case.fields.WebContactValidation__c.getInlineHelpText();} set;}
    
    public Boolean messageEntered {get; set;}
    public Boolean productEntered {get {return (productValue != null && productValue != 'All'); }}
    
    
    //validationHelpText = Schema.sObjectType.Case.fields.WebContactValidation__c.getInlineHelpText();
    
    @testVisible private string emailAddress;
    @testVisible private string emailSubject;
    @testVisible private integer pageSize;
    
        
    public PublicKBContactUs() {
        missingData = false;
        incorrectPhone = false;
        incorrectEmail = false;
        // searchDone = false;
        emailSent = false;
        ChatReady = false;
        messageEntered = false;
        missingHelp = false;
        fetchInputParams();
        clearInputParams(); 
        
        // init settings
        loadSettings();
    }
    
    // Returns a list of all topics
    public List<SelectOption> getProducts() {
        List<SelectOption> topics = new List<SelectOption>();
        try {
            
            DataCategoryGroupSobjectTypePair pair = new DataCategoryGroupSobjectTypePair();
            pair.setSobject('KnowledgeArticleVersion');
            pair.setDataCategoryGroupName('Denver_Product');
            for (DataCategory categ : Schema.describeDataCategoryGroupStructures(new Datacategorygroupsobjecttypepair[] { pair }, false)[0].getTopCategories()[0].getChildCategories())
                topics.add(new SelectOption(categ.getName(), categ.getLabel()));
            topics.add(new SelectOption('All', 'All'));    
            
        } catch (Exception ex) {
            PublicKBErrors.AddError(ex);
        }

        return topics;
    }
    
     
    
    
    public void searchNow()
    {
         messageEntered = true;                                     
         loadPossibleArticles();        
    }
    
/*    
    public PageReference continueToSearchResults() {
        emailSent = false;
        fetchInputParams();
        try {
            if (String.isEmpty(firstnameValue) || String.isEmpty(lastnameValue) || String.isEmpty(emailValue) || String.isEmpty(productValue) || String.isEmpty(helpValue) || String.isEmpty(phoneValue)) {
                missingData = true;
                if(!test.isRunningTest()) return null;
            }
            if (!validEmail) {
                incorrectEmail = true;
                return null;
            }
            missingData = false;
            incorrectEmail = false;
            searchDone = true;
            loadPossibleArticles();
            return null;
            
        } catch (Exception ex) {
            string trackingNumber = PublicKBErrors.AddError(ex);
            PageReference pr = Page.PublicKBError;
            pr.getParameters().put('trackingNumber', trackingNumber);
            pr.setRedirect(true);
            return pr;
        }
        
    }
*/ 
    
    @testVisible private boolean validEmail {
        get {
            String emailRegex = '^[a-zA-Z0-9._|\\\\%#~`=?&/$^*!}{+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,4}$';
            Pattern MyPattern = Pattern.compile(emailRegex);
            Matcher MyMatcher = MyPattern.matcher(emailValue);

            return MyMatcher.matches();
        }
    }
    
     @testVisible private boolean validPhone {
        get {
            String phoneRegex = '\\D*?(\\d\\D*?){10}';
            Pattern MyPattern = Pattern.compile(phoneRegex);
            Matcher MyMatcher = MyPattern.matcher(phoneValue);

            return MyMatcher.matches();
        }
    }
    
    public PageReference chatNow() 
    {    
        // init flags
        emailSent = false;
        missingData = false;
        ChatReady = false;
        missingHelp = false;
        incorrectEmail = false;
        incorrectPhone =false;
            
        if (String.isEmpty(firstnameValue) || String.isEmpty(lastnameValue) || String.isEmpty(emailValue) || String.isEmpty(phoneValue)) 
        {
            missingData = true;
        }
        if (!validEmail && !String.isEmpty(emailValue)) 
            incorrectEmail = true;
        if(!validPhone && !String.isEmpty(phoneValue))
            incorrectPhone =true;
        if(missingData || incorrectEmail || incorrectPhone)
            return null;           
        // create case
        try 
        {                       
            CreateCase();           
            ChatReady = true;
            return null;
                  
        } catch (Exception ex) {
            string trackingNumber = PublicKBErrors.AddError(ex);
            PageReference pr = Page.PublicKBError;
            pr.getParameters().put('trackingNumber', trackingNumber);
            pr.setRedirect(true);
            return pr;
        }           
        
    }
    
    // values from the custom settings
   @testVisible private void loadSettings() {
        pageSize = KeyValueStoreHelper.getIntegerValue('ExtArticleSearchResultPageSize');
        exedePhone = KeyValueStoreHelper.getTextValue('ContactUsExedePhone');
        wildbluePhone = KeyValueStoreHelper.getTextValue('ContactUsWildBluePhone');
        viasatAddress = KeyValueStoreHelper.getTextValue('ContactUsViasatAddress');
        chatDeploymentId = KeyValueStoreHelper.getTextValue('ExtLiveAgentDeploymentId');
        chatButtonId = KeyValueStoreHelper.getTextValue('ExtLiveChatButtonId');
        emailAddress = KeyValueStoreHelper.getTextValue('ContactUsEmailAddress');
        emailSubject = KeyValueStoreHelper.getTextValue('ContactUsEmailSubject');
    }
    
/*    
    
   @testVisible
   */
    private void fetchInputParams() {
        this.firstnameValue = ApexPages.currentPage().getParameters().get('contact-first-name');
        this.lastnameValue = ApexPages.currentPage().getParameters().get('contact-last-name');
        this.emailValue = ApexPages.currentPage().getParameters().get('contact-email');
        this.phoneValue = ApexPages.currentPage().getParameters().get('contact-phone');
        this.helpValue = ApexPages.currentPage().getParameters().get('contact-message');
        this.validationValue = ApexPages.currentPage().getParameters().get('contact-validation');
        
         System.debug('firstnameValue: ' + this.firstnameValue);
        System.debug('lastnameValue: ' + this.lastnameValue);
        System.debug('emailValue: ' + this.emailValue);
        System.debug('phoneValue: ' + this.phoneValue);
        System.debug('productValue: ' + this.productValue);
        System.debug('validationValue: ' + this.validationValue);
        System.debug('helpValue: ' + this.helpValue);
    }
    
 
    
   @testVisible private void loadPossibleArticles() {
        
        // loadSettings();
        
        // load articles
        List<KnowledgeArticleVersion> foundArticles;
        if (String.isEmpty(helpValue) || helpValue.length() < 2) {
            string baseQuery = 'SELECT Id, Title, Summary, IsVisibleInPkb, ArticleType, UrlName FROM KnowledgeArticleVersion ';
            baseQuery += 'WHERE PublishStatus=\'Online\' AND Language=\'en_US\' AND IsVisibleInPkb = true ';
            
            string query = baseQuery;
            if (productEntered)
                query += 'WITH DATA CATEGORY Denver_Product__c AT ' + productValue + '__c '; 
            query += 'LIMIT ' + pageSize;
            
            foundArticles = database.query(query);
            
            if (productEntered && foundArticles.size() < pageSize)
            {
                // Get the Articles that have the Denver_Product__c  -> we will exclude them from our query 
                query = baseQuery;
                query += 'WITH DATA CATEGORY Denver_Product__c BELOW All__c'; 
 
                List<KnowledgeArticleVersion> belowAllArticles = database.query(query); // should include all articles with a product category
                                                
                // add all the articles with no product tag
                integer noCatSize = pageSize-foundArticles.size();
                
                query = baseQuery;
                query += 'AND Id not in :belowAllArticles limit ' + noCatSize;
                
                system.debug('query: ' + query);
                
                List<KnowledgeArticleVersion> noCatfoundArticles = database.query(query);
                
                system.debug('noCatfoundArticles: ' + noCatfoundArticles);
                
                if (noCatfoundArticles != null && noCatfoundArticles.size() > 0)
                    foundArticles.addall(noCatfoundArticles);   
                
            }
            
            
            
            
        } else {
            // split the criteria to search for all the words
            List<String> splits = helpValue.replace('\'', '').split(' ');
            string SearchTerm = '';
            for (string split : splits) { 
                if (split != null && split != '') {
                    if (SearchTerm != '')
                        SearchTerm += ' OR';
                    SearchTerm += ' ' + split + '*';
                }
            }

            string baseQuery = 'FIND \'' + SearchTerm + '\' IN ALL FIELDS RETURNING KnowledgeArticleVersion ';
            baseQuery += '(Id, Title, Summary, IsVisibleInPkb, ArticleType, UrlName WHERE PublishStatus=\'Online\' AND Language=\'en_US\' AND IsVisibleInPkb = true ';            
            
            string query = baseQuery;
            if (productEntered)
                query += ') WITH DATA CATEGORY Denver_Product__c AT ' + productValue + '__c ';
            else
                query += ') ';
                     
            query += 'LIMIT ' + pageSize;
            
            foundArticles = search.query(query).get(0);
            
            if (productEntered && foundArticles.size() < pageSize)
            {
                // Get the Articles that have the Denver_Product__c  -> we will exclude them from our query 
                query = baseQuery;
                query += ') WITH DATA CATEGORY Denver_Product__c BELOW All__c'; 
 
                List<KnowledgeArticleVersion> belowAllArticles = search.query(query).get(0); // should include all articles with a product category
                                                
                // add all the articles with no product tag
                integer noCatSize = pageSize-foundArticles.size();
                
                query = baseQuery;
                query += 'AND Id not in :belowAllArticles) LIMIT ' + noCatSize;
                
                system.debug('query: ' + query);
                
                List<KnowledgeArticleVersion> noCatfoundArticles = search.query(query).get(0);
                
                system.debug('noCatfoundArticles: ' + noCatfoundArticles);
                
                if (noCatfoundArticles != null && noCatfoundArticles.size() > 0)
                    foundArticles.addall(noCatfoundArticles);   
                
            }
            
              
            
        }
        
        List<sObject> categories = getCategories(foundArticles);
        
        searchResults = new List<KBArticleWrapper>();
        for (KnowledgeArticleVersion foundArticle : foundArticles)
            searchResults.add(new KBArticleWrapper(foundArticle, categories));
    }
    
   @testVisible private List<sObject> getCategories(List<KnowledgeArticleVersion> foundArticles) {
        Set<String> articleTypes = new Set<String>();
        Set<Id> articleIds = new Set<Id>();
        for (KnowledgeArticleVersion foundArticle : foundArticles) {
            articleTypes.add(foundArticle.ArticleType);
            articleIds.add(foundArticle.Id);
        }
        List<sObject> toReturn = new List<sObject>(); 
        for (String articleType : articleTypes) {
            string categorizationName = articleType.replace('__kav', '__DataCategorySelection');
            toReturn.addAll(database.query('SELECT ParentId, DataCategoryGroupName, DataCategoryName FROM ' + 
                        categorizationName + ' WHERE ParentId IN :articleIds'));
        }
        return toReturn;
    }
    public PublicKBSearchResultWrapper searchResultWrapper {
        get {
            return new PublicKBSearchResultWrapper(searchResults);
        }
    }
    
    public PageReference sendEmail() 
    {
        // init flags
        emailSent = false;
        incorrectEmail = false;
        missingData = false;
        ChatReady = false;
        incorrectPhone = false;
        missingHelp = false;
        
        if (String.isEmpty(firstnameValue) || String.isEmpty(lastnameValue) || String.isEmpty(emailValue) || String.isEmpty(phoneValue)) 
            missingData = true;
        if (!validEmail && !String.isEmpty(emailValue)) 
            incorrectEmail = true;
        if(!validPhone && !String.isEmpty(phoneValue))
            incorrectPhone =true;
        if (string.isEmpty(helpValue))
            missingHelp = true;
        if(missingData || incorrectEmail || incorrectPhone || missingHelp){
            return null;
        }
        else
        {
            try 
            {
            string caseRecordTypeName = KeyValueStoreHelper.getTextValue('ContactUsEmailRecordTypeName');
            system.debug('!!!! caseRecordTypeName '+ caseRecordTypeName);
            RecordType rt = [SELECT Id FROM RecordType WHERE DeveloperName = :caseRecordTypeName AND sObjectType = 'Case'];
            
            Case newCase = new Case();
            newCase.SuppliedName = firstnameValue + ' ' + lastnameValue;
            newCase.SuppliedEmail = emailValue;
            newCase.SuppliedPhone = phoneValue;
            newCase.Product_Family__c = productValue;
            newCase.Description = helpValue;//.replace('\n', '<br />');
            newCase.RecordTypeId = rt.Id;
            newCase.Origin = KeyValueStoreHelper.getTextValue('ContactUsEmailCaseOrigin');
            newCase.Priority = 'Medium';
            newCase.WebContactValidation__c = validationValue;
            
            // issue 294648 - PL - 12-03-2014
            newCase.Subject = 'Public Send Email / ' + productValue+ ' ('+ System.now() + ')';
            
            
            Database.DMLOptions dmo = new Database.DMLOptions();
            dmo.assignmentRuleHeader.useDefaultRule  = true;
            dmo.EmailHeader.triggerAutoResponseEmail = true;
            newCase.setOptions(dmo);
            
            insert newCase;
            
            emailSent = true;           
//          searchDone = false;
            messageEntered=false;
            clearInputParams();
            if (searchResults != null)
                searchResults.clear();            
            } 
            catch (Exception ex) 
            {
            string trackingNumber = PublicKBErrors.AddError(ex);
            PageReference pr = Page.PublicKBError;
            pr.getParameters().put('trackingNumber', trackingNumber);
            pr.setRedirect(true);
            return pr;
            }
        }
        return null;     
    }
    
    public string gotoHelpLibraryURL{
    get{
        if (helpValue != null && helpValue.length() > 0) 
            return ('/apex/publickbhome?dosearch=1&searchKeyword='+helpValue);
        else
            return ('/apex/publickbhome?dosearch=1'); // go to search with no keyword 
    }}   
    
    public pageReference gotoHelpLibrary() 
    {
        pageReference pageRedirect = new pageReference(gotoHelpLibraryURL); 
        pageRedirect.setRedirect(true);
        return pageRedirect;
    }       
    
   @testVisible private void clearInputParams() {
        firstnameValue = null;
        lastnameValue = null;
        emailValue = null;
        phoneValue = null;
        productValue = 'All'; // for all
        validationValue = null;
        helpValue = null;
        
        messageEntered=false;
    }
    
    public boolean ChatReady { get; set; }
    
    public Case newCase { get; set; }
    public String newCaseId { get; set; }
    
    public void CreateCase() {      
        
        newCase = new Case();
        RecordType rt = [SELECT Id FROM RecordType WHERE Name = 'Denver Care' AND sObjectType = 'Case'];
        newCase.RecordTypeId = rt.Id;
        newCase.Origin = 'Care - Chat';
        newCase.SuppliedName = firstnameValue + ' ' + lastnameValue;
        newCase.SuppliedEmail = emailValue;
        newCase.SuppliedPhone = phoneValue;
        newCase.Subject = 'Public Chat / ' + productValue;
        newCase.WebContactValidation__c = validationValue;
        newCase.Description = helpValue;
        newCase.Status = 'New';
        newCase.Product_Family__c = productValue;    
        insert newCase;        
        newCaseId = newCase.Id;                
        
        System.debug('New Case:' + newCase);
    }
    
    public String getPopupMsg(){
        return KeyValueStore__c.getInstance('ChatPopupNote').Description__c;
    }
}