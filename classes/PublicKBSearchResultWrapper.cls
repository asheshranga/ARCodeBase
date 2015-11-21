/*
    Data holder object that carries result for article search
        
    **********************************************************
    Audit History
    **********************************************************
    5/17/2013    Shah Kadirmohideen			Created
    **********************************************************  
*/
public with sharing class PublicKBSearchResultWrapper {
	
	public List<KBArticleWrapper> searchResults { get; set; }
	public Integer searchResultSize {
		get {
			return searchResults != null ? searchResults.size() : 0; 
		}
	}

	public PublicKBSearchResultWrapper(List<KBArticleWrapper> searchResults) {
		this.searchResults = searchResults;
	}

}