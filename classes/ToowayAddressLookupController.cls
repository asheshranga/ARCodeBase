/********************************************************************************************************************************************************
Created By    : Nazeer Ahamed
Use of Class  : 
Company Name  : NTT DATA,Inc. 
Modified By   : Nazeer Ahamed
********************************************************************************************************************************************************/

public with sharing class ToowayAddressLookupController 
{
    public Address__c address {get;set;}       // new contact to create
    public List<Address__c> results{get;set;}  // search results
    public string searchString{get;set;}       // search keyword
    public string accountID{get;set;}
    public string accountName{get;set;}
    public string addressCity {get;set;}
    public string addressState {get;set;}
    public string addressCountry {get;set;}
    public string addressPostalcode {get;set;}
    public string addressVAT{get;set;}
    public string lookupFieldType {get;set;} 
    public string addressType {get;set;}
    public string addressEndDate {get;set;}
    public date today = system.today();
  
    //Constructor for class
      
    public ToowayAddressLookupController() 
    {
        address = new Address__c();
        results = new List<Address__c>();
        
    // get the current search string
        String lookupFieldType = '';
        searchString = System.currentPageReference().getParameters().get('lksrch');
    
    //Setting Search String to empty
        searchString = '';
        lookupFieldType = System.currentPageReference().getParameters().get('txt');
        accountID = System.currentPageReference().getParameters().get('accountid');
        accountName  = System.currentPageReference().getParameters().get('accountname');
    
    //If accountID is null, the search should not show all the availalable addresses    
            if ((accountID!='') && (accountID!=null) && (accountID!='000000000000000'))
                {
                    address.account__c=accountID;
       
            if (lookupFieldType.contains('Ship')) 
                {   
                    address.Type__c = 'Ship To';
                    addressType = 'Ship To'; 
                } 
            else 
                {
                    address.Type__c = 'Bill To';
                    addressType = 'Bill To';
                }
    
                    runSearch();
   
                } 
            else
                {
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'Please select an account using the lookup functionality on Return Request form.'));
                } 
    }
 
    //performs the keyword search
    
    public PageReference search() 
    {
        runSearch();
        return null;
    }
 
    //prepare the query and issue the search command
    
    public void runSearch() 
    {
    //TODO prepare query string for complex serarches & prevent injections
        results = performSearch(searchString);               
    } 
 
    //run the search and return the records found.
     
    private List<Address__c> performSearch(string searchString)
    {  
        String soql = 'select id, name, city__c, state__c, country__c, type__c, Full_Address__c, PostalCode__c, Default__c, End_Date__c, VAT__c ' + '  from Address__c ' +
                  'where  Type__c LIKE \'%' + addressType+ '%\'';
                  
            if (searchString != '' && searchString != null)
                  soql = soql +  ' and (name LIKE \'%' + searchString + '%\')';
            if (accountID != null && accountID != '')
                  soql = soql +  ' and account__r.Id =\'' + accountID +'\'';
            if (addressCity != null && addressCity != '')
                  soql = soql +  ' and city__c LIKE \'%' + addressCity +'%\'';
            if (addressState != null && addressState != '')
                  soql = soql +  ' and state__c LIKE \'%' + addressState +'%\'';
            if (addressCountry != null && addressCountry != '')
                  soql = soql +  ' and Country__c LIKE \'%' + addressCountry +'%\'';
            if (addressPostalcode != null && addressPostalcode != '')
                  soql = soql +  ' and postalcode__c LIKE \'%' + addressPostalcode +'%\'';
            if (addressVAT != null && addressVAT != '')
                  soql = soql +  ' and VAT__c LIKE \'%' + addressVAT +'%\'';      
            if (addressEndDate != null && addressEndDate != '')
                soql = soql +  ' and End_Date__c LIKE \'%' + addressEndDate +'%\'';
            else if (addressEndDate == null || addressEndDate == '')
                soql = soql +  ' and (End_Date__c >= today or End_Date__c = null) ';
                
            soql = soql + ' order by name limit 25';
          
                  ApexPages.getMessages().clear();
        
        List<Address__c> addresses = database.query(soql);    
            if (addresses.size() >= 25)    
                  ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'Search results have been restricted to first 25 rows. Found more than 25+ rows, please refine the search.'));
       
                  return addresses;  
    }
 
    //used by the visualforce page to send the link to the right dom element
    
    public string getFormTag() 
    {
        return System.currentPageReference().getParameters().get('frm');
    }
 
    //used by the visualforce page to send the link to the right dom element for the text box
    
    public string getTextBox() 
    {
        return System.currentPageReference().getParameters().get('txt');
    }
 }