public with sharing class SNG_CustomTerminalLookupController { 
    
    public final String searchString {get; set;}  				// search string will change based on visualforce page component
    public final Account modemAccount {get; private set;} 		// modem's account
	public List<Terminal__c> results {get; private set;}		// results of Terminal's that have the same account that is listed in the modem edit page
	public final String formId {get; private set;}				// id of form from ModemEdit.page 
	public final String inputField{get; private set;}			// id of terminal input field from ModemEdit.page
	
	private final String SOQL_WILDCARD = '%';					// SOQL wildcard character
	private final String USER_WILDCARD = '*';  					// wildcard character user enters into search box
	
    public SNG_CustomTerminalLookupController()
    {
        // extract the search string (the value that was in Terminal input field)
        searchString = ApexPages.currentPage().getParameters().get('lksrch'); 
        // extract the id of the form that launched the lookup
        formId = ApexPages.currentPage().getParameters().get('frm'); 
        // extract the id of the text box to send result back to
        inputField = ApexPages.currentPage().getParameters().get('txt'); 
		// Extract Account search parameter that is associated with Modem
        modemAccount = [SELECT Name, Id FROM Account WHERE Name = :ApexPages.currentPage().getParameters().get('mAcct') LIMIT 1]; 
    }
	
	public void search() { 
		
		// String that will be used in SOQL query
		String queryString;
		
		// Check searchString for '*' character that user may enter as wildcard character, replace '*' with '%' character
		if (searchString.contains(USER_WILDCARD)) { 
			queryString = searchString.replace(USER_WILDCARD, SOQL_WILDCARD); 	
			
			// if the queryString does not have a wildcard character at the end, add it 
			if (!queryString.endsWith(SOQL_WILDCARD)) { 
				queryString = queryString + SOQL_WILDCARD; 	
			}
			if (!queryString.startsWith(SOQL_WILDCARD)) { 
				queryString = SOQL_WILDCARD + queryString; 
			}	
		}
		// searchString does not contain '*' character, add '%', SOQL wildcard character at the start and end
		else { 
			queryString = SOQL_WILDCARD + searchString + SOQL_WILDCARD; 		// if searchString doesn't contain wildcard character, add one at the end
		}
		
		results = [SELECT Name, Id, Nickname__c, Account__c, Account__r.Name, TerminalType__r.Name FROM Terminal__c WHERE Account__c = :modemAccount.Id AND Name LIKE :queryString];   
	}
	 
}