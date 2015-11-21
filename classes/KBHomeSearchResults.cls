/*
    Controller for the search results component.
    Extracts and displays the article search results based on user criteria
        
    **********************************************************
    Audit History
    **********************************************************
    4/6/2013    Lucian Ciobanu      Created
    1/9/2014    Kelly Wortel        Case 39449 - Fix to allow for exact search enclosed in double quotes
    4/9/2014    Kelly Wortel        Case  - Fix for spotlight search term capability on internal search
    **********************************************************  
*/
public with sharing class KBHomeSearchResults {

    public boolean inConsole { get; set; }
    
    public KBHomeSearchResults() {

        inConsole = false;
        if (!String.isEmpty(ApexPages.currentPage().getParameters().get('isdtp')))
            inConsole = true;
                    
    }

    // Serach criteria. Set as a parameter
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
    
    // Internal care category. Set as a parameter
    private string internalCareCategoryPrivate;
    public string internalCareCategory { 
        get {
            return internalCareCategoryPrivate;
        }
        set {
            if (value != internalCareCategoryPrivate) {
                internalCareCategoryPrivate = value;
                loadSearchResults();
            }
        }
    }
    
    // Customer Category. Set as a parameter
    private string customerCategoryPrivate;
    public string customerCategory { 
        get {
            return customerCategoryPrivate;
        }
        set {
            if (value != customerCategoryPrivate) {
                customerCategoryPrivate = value;
                loadSearchResults();
            }
        }
    }
    
    // product category. Set as a parameter
    private string productPrivate;
    public string product { 
        get {
            return productPrivate;
        }
        set {
            if (value != productPrivate) {
                productPrivate = value;
                loadSearchResults();
            }
        }
    }
    
    // page size;
    private integer pageSize;
    
    // sets the number of search results
    public void loadSearchResults() {
        
        // page size is set from the custom settings
        pageSize = KeyValueStoreHelper.getIntegerValue('IntArticleSearchResultPageSize');
        
        foundArticleIds = new List<KnowledgeArticleVersion>();
        // Extract the number of articles found
        if (String.isEmpty(searchCriteria) || searchCriteria.length() < 2) { 
            string query = BuildSOQLQuery();
            List<KnowledgeArticleVersion> searchResults = database.query(query);
            for (KnowledgeArticleVersion result : searchResults)
                foundArticleIds.add(result);
        } else {
            string query = BuildSOSLQuery();
            List<List<sObject>> searchResults = search.query(query);
            for (List<sObject> searchResult : searchResults)
                for (sObject result : searchResult)
                    foundArticleIds.add((KnowledgeArticleVersion)result);
        }
        
        currentPage = 1;
        loadArticles();
    }
    
    // loads a batch of articles, based on current page
    @TestVisible
    private void loadArticles() {
        integer offset = (currentPage - 1) * pageSize;

        // Find any spotlight articles and reorder the list
        List<KnowledgeArticleVersion> orderedArticleIds = getSpotLight(foundArticleIds);  
        system.debug('orderedArticleIds+++'+orderedArticleIds);   
         
        List<Id> pageArticleIds = new List<Id>();
        for (integer i = offset; i < offset + pageSize && i < foundArticleIds.size(); i++) {
            try {
                pageArticleIds.add(orderedArticleIds.get(i).Id);
            } catch (Exception ex) {}
        }
        string query = KBSOQLHelper.strArtQuery(pageArticleIds); 
          
        List<KnowledgeArticleVersion> foundArticles = database.query(query);

        // re-sort foundArticles.  
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
            foundArticles = orderedArticles;  // update foundArticles with the reordered list
        }

        searchResults = new List<ArticleLine>();
        for (KnowledgeArticleVersion foundArticle : foundArticles)
            searchResults.add(new ArticleLine(foundArticle));
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
            }                                    
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

    // method used to remove spaces and add hash tags to strings
    public String addHashTag(String inString){
        // Remove spaces and replace comma's with pound
        String tempString = inString;
        tempString = tempString.replace(' ','');
        tempString = tempString.replace(',','#');
        tempString = '#' + tempString + '#';
        
        return tempString;   
    }

    // private method that builds the SOSL query based on search criteria
    @TestVisible
    private string BuildSOSLQuery() {
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
            searchCriteriaPrivate2 = searchCriteriaPrivate2.replace('"','\"');        // Escape Double Quotes
            
            if (String.isEmpty(searchCriteriaPrivate2) || searchCriteriaPrivate2.length() < 2)
                searchCriteriaPrivate2 = 'aa';
                    
            SearchTerm = searchCriteriaPrivate2; //+ '*';            
            System.debug('Split: ' + SearchTerm );
        }
        
        System.debug('SearchTerm: ' + SearchTerm);        
        
        // first part of the query
        List<String> articleTypes = new List<String>();
  
        for (Knowledge_Article_Type__c iso : Knowledge_Article_Type__c.getAll().values())
            articleTypes.add(iso.Article_Type__c); 
        string query = 'FIND \'' + SearchTerm + '\' IN ALL FIELDS RETURNING KnowledgeArticleVersion (Id, Title, articletype WHERE PublishStatus=\'Online\' and Language=\'en_US\' and articletype in '+articleTypes+')';
        
        System.debug('SOSL query: ' + query);
        
        // add categories if needed
        boolean categoryAdded = false;
        if (internalCareCategory != NULL && internalCareCategory != '') {
        	
            if (!categoryAdded) {
                query += ' WITH DATA CATEGORY';
                categoryAdded = true;
            } else {
                query += ' AND';
            }
            query += ' Care_Categories__c BELOW ' + internalCareCategory;
        }
        if (customerCategory != NULL && customerCategory != '') {
            if (!categoryAdded) {
                query += ' WITH DATA CATEGORY';
                categoryAdded = true;
            } else {
                query += ' AND';
            }
            query += ' Customer_Categories__c BELOW ' + customerCategory;
        }
        if (product != NULL && product != '') {
            if (!categoryAdded) {
                query += ' WITH DATA CATEGORY';
                categoryAdded = true;
            } else {
                query += ' AND';
            }
            query += ' Denver_Product__c BELOW ' + product;
        }
        
        // add limit
        integer limitSearch = KeyValueStoreHelper.getIntegerValue('InternalSearchLimit');
        query += ' LIMIT ' + limitSearch;
        query += ' UPDATE TRACKING ';
        
        return query;
    }
    
    // public method that builds the SOQL query based on search criteria 
    
    @TestVisible private string BuildSOQLQuery() {
        // first part of the query
        List<String> articleTypes = new List<String>();
  
        for (Knowledge_Article_Type__c iso : Knowledge_Article_Type__c.getAll().values())
            articleTypes.add(iso.Article_Type__c);
        string query = 'SELECT ArticleType, Id, Title FROM KnowledgeArticleVersion WHERE PublishStatus=\'Online\' and Language=\'en_US\' AND ArticleType IN '+articleTypes+' ';
        
        // add categories if needed
        boolean categoryAdded = false;
        if (internalCareCategory != NULL && internalCareCategory != '') {
            if (!categoryAdded) {
                query += ' WITH DATA CATEGORY';
                categoryAdded = true;
            } else {
                query += ' AND';
            }
            query += ' Care_Categories__c BELOW ' + internalCareCategory;
        }
        if (customerCategory != NULL && customerCategory != '') {
            if (!categoryAdded) {
                query += ' WITH DATA CATEGORY';
                categoryAdded = true;
            } else {
                query += ' AND';
            }
            query += ' Customer_Categories__c BELOW ' + customerCategory;
        }
        if (product != NULL && product != '') { 
            if (!categoryAdded) {
                query += ' WITH DATA CATEGORY';
                categoryAdded = true;
            } else {
                query += ' AND';
            }
            query += ' Denver_Product__c BELOW ' + product;
        }
        
        // add limit
        integer limitSearch = KeyValueStoreHelper.getIntegerValue('InternalSearchLimit');
        query += ' LIMIT ' + limitSearch;
        
        return query;
    }
    
    // the list of search results
    public List<ArticleLine> searchResults { get; set; }
    
    public boolean emptyResults {
        get {
            return searchResults == null || searchResults.size() == 0;
        }
    }
    
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
    
    // number of pages calculated based on number of articles and page size
    public integer numberOfPages {
        get {
            if (numberOfArticles == 0 || numberOfArticles == NULL)
                return 1;
            else return (numberOfArticles - 1) / pageSize + 1;
        }
    }
    
    // current page number
    public integer currentPage { get; set; }
    
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
    
    // action called when the user clicks on a page number
    public void gotoPage() {
        try {
            currentPage = integer.valueof(ApexPages.currentPage().getParameters().get('page'));
            if (currentPage == null || currentPage < 1)
                currentPage = 1;
            if (currentPage > numberOfPages)
                currentPage = numberOfPages;
        } catch (Exception ex) {}
        loadArticles();
    }

    // Wrapper for an article result. Used for Summary manipulation
    public class ArticleLine {
        
        public KnowledgeArticleVersion article { get; set; }
        
        public String Summary {
            get {
                if (article.Summary == null || article.Summary.length() <= 100)
                    return article.Summary;
                else
                    return article.Summary.left(100) + '...';
            }
        }
        
        public ArticleLine(KnowledgeArticleVersion art) {
            article = art;
        }
    }

}