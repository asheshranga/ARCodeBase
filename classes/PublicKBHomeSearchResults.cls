/*
    Controller for the public search results component
    Display search results based on user input
        
    **********************************************************
    Audit History
    **********************************************************
    4/22/2013    Lucian Ciobanu      Created
    1/9/2014    Kelly Wortel        Case 39449 - Fix to allow for exact search enclosed in double quotes
    1/9/2014    Kelly Wortel        Case 89135 - Fix to allow for spotlight search term capability
    **********************************************************  
*/
public with sharing class PublicKBHomeSearchResults {
    // the list of search results
    public List<KBArticleWrapper> searchResults { get; set; }
    
    // ids of found articles
    public List<KnowledgeArticleVersion> foundArticleIds { get; set; }
    
    // number of found articles
    public integer numberOfArticles {
        get {
            if (foundArticleIds == null)
                return 0;
            return foundArticleIds.size();
        }
    }

    // current page number
    public integer currentPage { get; set; }
    
    // input parameters
    // Serach criteria. Set as a parameter
    private boolean productInitiallySet = false;
    public string selectedProductPrivate;
    public string selectedProduct { 
        get {
            return selectedProductPrivate; 
        }
        set {
            if (value != selectedProductPrivate) {
                selectedProductPrivate = value;
                loadSearchResults();
            }
        }
    }
    public string initiallySelectedProduct { 
        get {
            return selectedProductPrivate;
        }
        set {
            if (!productInitiallySet) {
                selectedProductPrivate = value;
                productInitiallySet = true;
                loadSearchResults();
            }
        }
    }
    
    private string searchCriteriaPrivate;
    public string searchCriteria { 
        get {
            return searchCriteriaPrivate;
        }
        set {
            if (value != searchCriteriaPrivate) {
                searchCriteriaPrivate = value;
                loadSearchResults();
            }
        }
    }
    private string categoryLevel1Private;
    public string categoryLevel1 { 
        get {
            return categoryLevel1Private;
        }
        set {
            if (value != categoryLevel1Private) {
                categoryLevel1Private = value;
                loadSearchResults();
            }
        }
    }
    private string categoryLevel2Private;
    public string categoryLevel2 { 
        get {
            return categoryLevel2Private;
        }
        set {
            if (value != categoryLevel2Private) {
                categoryLevel2Private = value;
                loadSearchResults();
            }
        }
    }
    //1 means, the control is coming from basic or advanced search. 2 means, coming from footer data category list or from article view page
    //data category component
    private string doSearchPrivate;
    public string doSearch { 
        get {
            return doSearchPrivate;
        }
        set {
            if (value != doSearchPrivate) {
                doSearchPrivate = value;
                loadSearchResults();
            }
        }
    }
    
    public PublicKBSearchResultWrapper searchResultWrapper {
        get {
            return new PublicKBSearchResultWrapper(searchResults);
        }
    }

    // page size;
    private integer pageSize;
    
    public PublicKBHomeSearchResults() {
        System.debug('PublicKBHomeSearchResults constructor is called');
        searchResults = new List<KBArticleWrapper>();
    }
    
    // sets the number of search results
   
   
    public void loadSearchResults() {
        System.debug('loadSearchResults. doSearch: ' + doSearch + ', searchCriteria: ' + searchCriteria + ', categoryLevel1: ' + categoryLevel1 + ', categoryLevel2: ' + categoryLevel2);

        //if (doSearch == '1' && String.isEmpty(searchCriteria)) {
            //return;
        //}
        
        try {            
            // page size is set from the custom settings
            pageSize = KeyValueStoreHelper.getIntegerValue('ExtArticleSearchResultPageSize');
            System.debug('pageSize: ' + pageSize);
            
            // Extract the number of articles found
            foundArticleIds = new List<KnowledgeArticleVersion>();
            if (String.isEmpty(searchCriteria) || searchCriteria.length() < 2 || doSearch == '2') {
                // Request is coming from page footer or from the data category component on the article view page
                String soql = BuildSOQLQuery();
                for (KnowledgeArticleVersion kav : Database.query(soql)) {
                    foundArticleIds.add(kav);
                }
            }
            else {                
                String sosl = BuildSOSLQuery();          
                for (List<sObject> searchResult : search.query(sosl))
                    for (sObject result : searchResult)
                        foundArticleIds.add((KnowledgeArticleVersion)result);                                              
            }
            
            System.debug('total articles found using SOSL: ' + foundArticleIds.size());
            currentPage = 1;
            loadArticlesSOQL();
            
        } catch (Exception ex) {
            PublicKBErrors.AddError(ex);
        }
    }
    
    // loads a batch of articles, based on current page
   
     public void loadArticlesSOQL() {
        System.debug('loadArticles starts');
        integer offset = (currentPage - 1) * pageSize;
        
        // Find any spotlight articles and reorder the list
        List<KnowledgeArticleVersion> orderedArticleIds = getSpotLight(foundArticleIds);       
        
        // get the ids of the current page
        List<Id> pageArticleIds = new List<Id>();
        for (integer i = offset; i < offset + pageSize && i < orderedArticleIds.size(); i++) {
            try {
                pageArticleIds.add(orderedArticleIds.get(i).Id);
            } catch (Exception ex) {}
        }
        
        string query = KBSOQLHelper.strArtQuery(pageArticleIds);
        List<KnowledgeArticleVersion> foundArticles = database.query(query); 
        system.debug('found article size:::'+foundArticles.size());   
             
        // re-sort foundArticles.  since it is a map, must use for loops
        List<KnowledgeArticleVersion> orderedArticles = new List<KnowledgeArticleVersion>();
        if (!orderedArticleIds.isEmpty()){  // Only process if there are results
            for (integer i = 0; i < orderedArticleIds.size(); i++){
                for (integer j = 0; j < foundArticles.size(); j++){
                    //if foundArticle.id = orderArticleId then add to orderedArticles
                    system.debug('foundArticles.get(j).id: ' + foundArticles.get(j).id);                    
                    if (orderedArticleIds.get(i).id == foundArticles.get(j).id)
                        orderedArticles.add(foundArticles.get(j));  // update new list based on the order from getSpotlight method
                }
            }        
            foundArticles = orderedArticles;
        }
                
        List<sObject> categories = getCategories(foundArticles);
        System.debug('categories: ' + categories);
        
        Map<Id, AggregateResult> ags = new Map<Id, AggregateResult>([SELECT KnowledgeArticelId__c Id, AVG(Rating__c) avgRating FROM PublicArticleRating__c WHERE KnowledgeArticelId__c IN :pageArticleIds GROUP BY KnowledgeArticelId__c]);
        
        searchResults = new List<KBArticleWrapper>();
        for (KnowledgeArticleVersion foundArticle : foundArticles) {
            searchResults.add(new KBArticleWrapper(foundArticle, categories, ags));
        }
        System.debug('searchResults: ' + searchResults);
    }
    
    // action called when the user clicks on a page number
    public void gotoPage() {
        currentPage = integer.valueof(ApexPages.currentPage().getParameters().get('page'));
        System.debug('gotoPage invoked with page number ' + currentPage + ', numberOfPages: ' + numberOfPages);
        if (currentPage == null || currentPage < 1)
            currentPage = 1;
        if (currentPage > numberOfPages)
            currentPage = numberOfPages;
        loadArticlesSOQL();
    }

    // method used to remove spaces and add hash tags to strings
    public String addHashTag(String inString){
        // Remove spaces and replace comma's with pound
        String tempString = inString;
        tempString = tempString.replace(' ','');
        tempString = tempString.replace(',','#');
        tempString = '#' + tempString + '#';
        
        return tempString;   
    }

    // method called to find any articles that need to be spotlighted
    public List<KnowledgeArticleVersion> getSpotLight(List<KnowledgeArticleVersion> foundArticles) {
        String                             searchCriteriaPrivate2 = searchCriteria;
        Set<String>                        articleTypes = new Set<String>();
        Set<Id>                            articleIds = new Set<Id>();
        Map<Id, KnowledgeArticleVersion>   articleList = new Map<Id, KnowledgeArticleVersion>();
        List<String>                       tempSpotlightArticles = new List<String>();
        Map<Id, String>                    spotlightArticles = new Map<Id, String>{};
        List<KnowledgeArticleVersion>      orderedArticleList = new List<KnowledgeArticleVersion>();
        
        for (KnowledgeArticleVersion foundArticle : foundArticles) {
            articleTypes.add(foundArticle.ArticleType);      // unique Set of ArticleTypes
            articleIds.add(foundArticle.Id);                 // unique Set of Article Ids  
            articleList.put(foundArticle.Id, foundArticle);  // Map of article Id's to List of article's found
        }

        // check if the searchstring is empty or less than 2 characters, if so create a generic search
        // clean up any special characters and add it to a list
        if (String.isEmpty(searchCriteriaPrivate2) || searchCriteriaPrivate2.length() < 2)
            searchCriteriaPrivate2 = 'aa';
        // Clean up the searchstring to allow for whole word matches
        String specialChars = '&|^|@|!|\'|"|%|$|#|*';   // special chars to remove, pipe separated
        for(integer i=0; i<specialChars.split('|').size(); i++)
            searchCriteriaPrivate2 = searchCriteriaPrivate2.replace(specialChars.split('|')[i], '');               
        List<String> searchTerms = searchCriteriaPrivate2.split(' ');

        Map<Id, String> articleSpotlightTerms = new Map<Id, String>{}; 
        for (String articleType : articleTypes) {

            /*  Future to-do.  Determine how to dyanamically set the object type in the for loop so you don't have to specifically check for each article type
            String query = 'SELECT Id, SpotlightTerms__c FROM ' + articleType + ' WHERE Id IN :articleIds Group by Id, SpotlightTerms__c';
            System.debug('getSpotLight query: ' + query);
            
            articleType tempArticleType; 

            for(tempArticleType objCS : database.query(query)){
                    // Only add the Spot Light Term if it is not null
                    if (!String.isEmpty((String)objCS.get('SpotlightTerms__c')) || ((String)objCS.get('SpotlightTerms__c')!=null)) {
                        // Add it to our List of Spotlight Terms
                        articleSpotlightTerms.put((Id)objCS.get('Id'), addHashtag((String)objCS.get('SpotlightTerms__c')));      
                    }
            }*/
            
           
            String query = 'SELECT Id, SpotlightTerms__c FROM ' + articleType + ' WHERE Id IN :articleIds';
            
            // run the query for each of the article types
            if (articleType == 'General__kav') {
                for(General__kav objCS : database.query(query)){
                    // Only add the Spot Light Term if it is not null
                    if (!String.isEmpty((String)objCS.get('SpotlightTerms__c')) || ((String)objCS.get('SpotlightTerms__c')!=null)) {
                        // Add it to our List of Spotlight Terms
                        articleSpotlightTerms.put((Id)objCS.get('Id'), addHashtag((String)objCS.get('SpotlightTerms__c')));      
                    }
                } 
            } else if (articleType == 'Announcement__kav') {   
                for(Announcement__kav objCS : database.query(query)){
                    // Only add the Spot Light Term if it is not null
                    if (!String.isEmpty((String)objCS.get('SpotlightTerms__c')) || ((String)objCS.get('SpotlightTerms__c')!=null)) {
                        // Add it to our List of Spotlight Terms
                        articleSpotlightTerms.put((Id)objCS.get('Id'), addHashtag((String)objCS.get('SpotlightTerms__c')));      
                    }
                } 
            } else if (articleType == 'Denver_FAQ__kav') {   
                for(Denver_FAQ__kav objCS : database.query(query)){
                    // Only add the Spot Light Term if it is not null
                    if (!String.isEmpty((String)objCS.get('SpotlightTerms__c')) || ((String)objCS.get('SpotlightTerms__c')!=null)) {
                        // Add it to our List of Spotlight Terms
                        articleSpotlightTerms.put((Id)objCS.get('Id'), addHashtag((String)objCS.get('SpotlightTerms__c')));      
                    }
                } 
            } /*else if (articleType == 'FAQ__kav') {   
                for(FAQ__kav objCS : database.query(query)){
                    // Only add the Spot Light Term if it is not null
                    if (!String.isEmpty((String)objCS.get('SpotlightTerms__c')) || ((String)objCS.get('SpotlightTerms__c')!=null)) {
                        // Add it to our List of Spotlight Terms
                        articleSpotlightTerms.put((Id)objCS.get('Id'), addHashtag((String)objCS.get('SpotlightTerms__c')));      
                    }
                } 
            } */                                    
        }
        
        system.debug('searchCriteria: ' + searchCriteria);
        
        // if searchCriteria exists, then loop through all the articles and see if any of the spotlight terms exist for each article
        if (!String.isEmpty(searchCriteria) || (searchCriteria!=null)) {   
            for (Id id : articleSpotlightTerms.keySet()) {            
                for (String searchTerm: searchTerms){
                    searchTerm = '#' + searchTerm.toUpperCase() + '#';  // enclose the searchTerm in # to match the searchCriteria formatting
                    //system.debug('searchTerm.toUpperCase(): ' + searchTerm);
                    //system.debug('articleSpotlightTerms.get(id).toUpperCase(): ' + articleSpotlightTerms.get(id).toUpperCase());
                    //system.debug('articleSpotlightTerms.get(id).contains(searchTerm): ' + articleSpotlightTerms.get(id).toUpperCase().contains(searchTerm));
                                        
                    // Loop through all the articles and check if the spotlight term contains the searchTerm
                    if (articleSpotlightTerms.get(id)!=null && articleSpotlightTerms.get(id).toUpperCase().contains(searchTerm)){                              
                        integer startIndex = articleSpotlightTerms.get(id).toUpperCase().indexOf(searchTerm)+ searchTerm.length();
                        integer endIndex;
                        if (startIndex < articleSpotlightTerms.get(id).length()) // make sure the last term has a number after it
                            endIndex = articleSpotlightTerms.get(id).toUpperCase().indexOf('#',startIndex);
                        else  // if not, set the indexes to be the same
                            endIndex = startIndex;
                        
                        //system.debug('startIndex: ' + startIndex);
                        //system.debug('articleSpotlightTerms.get(id).indexOf(#,startIndex): ' + articleSpotlightTerms.get(id).indexOf('#',startIndex));
                        //system.debug('endIndex: ' + endIndex);
                                                
                        String spotlightRank = articleSpotlightTerms.get(id).substring(startIndex, endIndex); 
                        //system.debug('spotlightRank: ' + spotlightRank);  
                        if (spotlightRank.isNumeric()) // check the case where no rank is entered, if the value following the spotlight term is a number, use it.
                            tempSpotlightArticles.add(spotlightRank.leftPad(4).replace(' ','0') + '#' + id);
                        else // no match or null - set rank to 99
                            tempSpotlightArticles.add('0099' + '#' + id);
                        
                        break;  // found a match for this Id, move on.
                    }
                }
            }
            
            //sort the spotlight results
            tempSpotlightArticles.sort();

            // loop through the tempSpotlightArticles List and add the Id's to the orderedArticleList
            for (integer i = 0; i < tempSpotlightArticles.size(); i++) {
                String tempId = tempSpotlightArticles.get(i).substring(tempSpotlightArticles.get(i).indexOf('#')+1);
                orderedArticleList.add(articleList.get(tempId));
                articleList.remove(tempId);  // remove this Id since a match was found
            }            
            
            // add the remainder of the returned results to the orderedArticleList
            for (Id id : articleList.keySet()) 
                orderedArticleList.add(articleList.get(id));                
        }
        
        System.debug('articleSpotlightTerms: ' + orderedArticleList);
        return orderedArticleList; 
    }
        
    private List<sObject> getCategories(List<KnowledgeArticleVersion> foundArticles) {
        Set<String> articleTypes = new Set<String>();
        Set<Id> articleIds = new Set<Id>();
        for (KnowledgeArticleVersion foundArticle : foundArticles) {
            articleTypes.add(foundArticle.ArticleType);
            articleIds.add(foundArticle.Id);
        }
        List<sObject> toReturn = new List<sObject>(); 
        for (String articleType : articleTypes) {
            string categorizationName = articleType.replace('__kav', '__DataCategorySelection');
            String query = 'SELECT ParentId, DataCategoryGroupName, DataCategoryName FROM ' + categorizationName + ' WHERE ParentId IN :articleIds';
            System.debug('getCategories query: ' + query);
            toReturn.addAll(database.query(query));
        }
        System.debug('toReturn: ' + toReturn);
        return toReturn;
    }
    
    // private method that builds the SOSL query based on search criteria
    
    public string BuildSOSLQuery() {
        String SearchTerm = ''; 
        String searchCriteriaPrivate2 = searchCriteria; 
        searchCriteriaPrivate2 = searchCriteriaPrivate2.unescapeEcmaScript();    
        System.debug('searchCriteria: ' + searchCriteriaPrivate2);  
        
        searchCriteriaPrivate2 = searchCriteriaPrivate2.replace('\'','\\\'');   // Escape Single Quotes         
              
        if (searchCriteriaPrivate2.left(1)=='"' && searchCriteriaPrivate2.right(1)=='"' && searchCriteriaPrivate2.length()>2) {
            // Search string surrounded by double quotes.  Assume exact match required.
            SearchTerm = searchCriteriaPrivate2;
            System.debug('Quoted: ' + SearchTerm );
        } 
        else {
            // remove any quotes to allow for quoted text in search string - Case 39449
            //searchCriteriaPrivate2 = searchCriteriaPrivate2.replace('"','');        // Remove Double Quotes          
            searchCriteriaPrivate2 = searchCriteriaPrivate2.replace('"','\"');        // Escape Double Quotes
            
            if (String.isEmpty(searchCriteriaPrivate2) || searchCriteriaPrivate2.length() < 2)
                searchCriteriaPrivate2 = 'aa';
                    
/*          // split the criteria to search for all the words
            List<String> splits = searchCriteriaPrivate2.split(' ');
            for (string split : splits) { 
                if (split != null && split != '') {
                    if (SearchTerm != '')
                        SearchTerm += ' OR';
                    SearchTerm += ' ' + split + '*';
                }
            }           
*/            
            SearchTerm = searchCriteriaPrivate2;  //+ '*'
        } 
      
        System.debug('SearchTerm: ' + SearchTerm);
        
        // first part of the query
        string query = 'FIND \'' + SearchTerm + '\' IN ALL FIELDS RETURNING KnowledgeArticleVersion (Id, ArticleType WHERE PublishStatus=\'Online\' and Language=\'en_US\') ';
        
        // add categories if needed
        boolean categoryAdded = false;
        if (!String.isEmpty(categoryLevel2)) {
            if (!categoryAdded) {
                query += ' WITH DATA CATEGORY ';
                categoryAdded = true;
            } else {
                query += ' AND ';
            }
            query += 'Customer_Categories__c BELOW ' + categoryLevel2 + '__c';
        } else if (!String.isEmpty(categoryLevel1)) {
            if (!categoryAdded) {
                query += ' WITH DATA CATEGORY ';
                categoryAdded = true;
            } else {
                query += ' AND ';
            }
            query += 'Customer_Categories__c BELOW ' + categoryLevel1 + '__c';
        }

        if (!String.isEmpty(selectedProduct)) {
            if (!categoryAdded) {
                query += ' WITH DATA CATEGORY ';
                categoryAdded = true;
            } else {
                query += ' AND ';
            }
            query += 'Denver_Product__c BELOW ' + selectedProduct + '__c';
        }
        
        // add limit
        integer limitSearch = KeyValueStoreHelper.getIntegerValue('ExternalSearchLimit');
        query += ' LIMIT ' + limitSearch;
        query += ' UPDATE TRACKING ';
        System.debug('BuildSOSLQuery sosl query: ' + query);
        
        return query;
    }
    
    // private method that builds the search query based on search criteria
    
    public string BuildSOQLQuery() { 
        string query = 'SELECT ID, ArticleType FROM KnowledgeArticleVersion WHERE PublishStatus = \'Online\' AND Language = \'en_US\' ';
                
        boolean categoryAdded = false;
        if (!String.isEmpty(categoryLevel2)) {
            if (!categoryAdded) {
                query += ' WITH DATA CATEGORY ';
                categoryAdded = true;
            } else {
                query += ' AND ';
            }
            query += 'Customer_Categories__c BELOW ' + categoryLevel2 + '__c';
        } else if (!String.isEmpty(categoryLevel1)) {
            if (!categoryAdded) {
                query += ' WITH DATA CATEGORY ';
                categoryAdded = true;
            } else {
                query += ' AND ';
            }
            query += 'Customer_Categories__c BELOW ' + categoryLevel1 + '__c';
        }

        if (!String.isEmpty(selectedProduct)) {
            if (!categoryAdded) {
                query += ' WITH DATA CATEGORY ';
                categoryAdded = true;
            } else {
                query += ' AND ';
            }
            query += 'Denver_Product__c BELOW ' + selectedProduct + '__c';
        } 
        
        // add limit
        integer limitSearch = KeyValueStoreHelper.getIntegerValue('ExternalSearchLimit');
        query += ' LIMIT ' + limitSearch;

        System.debug('BuildSOQLQuery soql: ' + query);
        return query;
    }
    
    // number of pages calculated based on number of articles and page size
    public integer numberOfPages {
        get {
            if (numberOfArticles == 0 || numberOfArticles == NULL)
                return 1;
            else return (numberOfArticles - 1) / pageSize + 1;
        }
    }
    
    // extracts a list of available previous pages
    public List<integer> previousPages {
        get {
            List<integer> toReturn = new List<integer>();
            if (currentPage == null)
                return toReturn;
            integer pageIndex = currentPage - 1; 
            while (pageIndex > 0 && toReturn.size() < 5) {
                toReturn.add(pageIndex);
                pageIndex --;
            }
            toReturn.sort();
            return toReturn;
        }
    }
    
    // extracts a list of available next pages
    public List<integer> nextPages {
        get {
            List<integer> toReturn = new List<integer>();
            if (currentPage == null)
                return toReturn;
            integer pageIndex = currentPage + 1; 
            while (pageIndex <= numberOfPages && toReturn.size() < 5) {
                toReturn.add(pageIndex);
                pageIndex ++;
            }
            toReturn.sort();
            return toReturn;
        }
    }
    
    // Returns a list of all topics
    public List<SelectOption> getProducts() {
        List<SelectOption> topics = new List<SelectOption>();
        try {
            topics.add(new SelectOption('', '-- No filter --'));
            
            DataCategoryGroupSobjectTypePair pair = new DataCategoryGroupSobjectTypePair();
            pair.setSobject('KnowledgeArticleVersion');
            pair.setDataCategoryGroupName('Denver_Product');
            for (DataCategory categ : Schema.describeDataCategoryGroupStructures(new Datacategorygroupsobjecttypepair[] { pair }, false)[0].getTopCategories()[0].getChildCategories())
                topics.add(new SelectOption(categ.getName(), categ.getLabel()));
        } catch (Exception ex) {
            PublicKBErrors.AddError(ex);
        }
        
        return topics;
    }

  }