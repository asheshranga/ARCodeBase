public with sharing class AddressLookupController {
 
  public Address__c address {get;set;}       // new contact to create
  public List<Address__c> results{get;set;}  //  results
  public string searchString{get;set;}    // search keyword
  public string accountID{get;set;}
  public string accountName{get;set;}
  public string addressCity {get;set;}
  public string addressState {get;set;}
  public string addressCompany {get;set;}
  public string addressCountry {get;set;}
  public string addressPostalcode {get;set;}
  public string addressEBSID {get;set;}
  public string addressType {get;set;}
  
  
  public AddressLookupController () {
    address = new Address__c();
    results = new List<Address__c>();
    // get the current search string
    String lookupFieldType = '';
    searchString = System.currentPageReference().getParameters().get('lksrch');
    
    //Setting Search String to empty
    searchString = '';
    lookupFieldType = System.currentPageReference().getParameters().get('txt');

    accountID    = System.currentPageReference().getParameters().get('accountid');
    accountName  = System.currentPageReference().getParameters().get('accountname');
    
    //If accountID is null, the search should not show all the availalable addresses    
    if ((accountID!='') && (accountID!=null) && (accountID!='000000000000000'))
    {
       address.account__c=accountID;
       
    if(lookupFieldType.contains('ship')) {   
       address.Type__c = 'Ship To';
       addressType = 'Ship To'; 
    }
     else if(lookupFieldType.contains('bill'))
      { address.Type__c = 'Bill To';
       addressType = 'Bill To';
    }
    else
      { address.Type__c = 'Drop Ship';
       addressType = 'Drop Ship';}
    
    
      runSearch();
   
    } else{
        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'Please select an account using the lookup functionality on Return Request form.'));
    } 
    
  }
 
  // performs the keyword search
  public PageReference search() {
    runSearch();
    return null;
  }
 
  // prepare the query and issue the search command
  public void runSearch() {
    // TODO prepare query string for complex serarches & prevent injections
    results = performSearch(searchString);               
  } 
 
  // run the search and return the records found. 
  public List<Address__c> performSearch(string searchString){  
    String soql = 'select id, name, city__c, state__c, country__c,Company__c,EBSAddressID__c, type__c, Full_Address__c, PostalCode__c, Default__c ' +
                  '  from Address__c ' +
                  ' where (End_Date__c = null OR End_Date__c >= TODAY) and Type__c LIKE \'%' + addressType+ '%\'';
                  
    if (searchString != '' && searchString != null)
      soql = soql +  ' and (name LIKE \'%' + searchString + '%\')';
    if (accountName != null && accountName != '')
      soql = soql +  ' and (account__r.name like \'%' + accountName + '%\')';
    if (addressCity != null && addressCity != '')
      soql = soql +  ' and city__c LIKE \'%' + addressCity +'%\'';
    if (addressState != null && addressState != '')
      soql = soql +  ' and state__c LIKE \'%' + addressState +'%\'';
    if (addressCompany != null && addressCompany != '')
      soql = soql +  ' and Company__c LIKE \'%' + addressCompany +'%\'';
    if (addressEBSID != null && addressEBSID != '')
      soql = soql +  ' and  EBSAddressID__c LIKE \'%' + addressEBSID +'%\'';
    if (addressCountry != null && addressCountry != '')
      soql = soql +  ' and Country__c LIKE \'%' + addressCountry +'%\'';
    if (addressPostalcode != null && addressPostalcode != '')
      soql = soql +  ' and postalcode__c LIKE \'%' + addressPostalcode +'%\'';
          
    soql = soql + 'order by name limit 25';
    
    ApexPages.getMessages().clear();

    List<Address__c> addresses = database.query(soql);    
    if (addresses.size() >= 25)    
       ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'Search results have been restricted to first 25 rows. Found more than 25+ rows, please refine the search.'));
       
    return addresses;  
  }
 
  // save the new contact record
  public PageReference saveAddress() {
    try {
       //Setting the default EBS id. 
       address.EBSAddressID__c = '0';   
       insert address;
       
       searchString = '';
       runSearch();
    }
    catch (exception e) {
       ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Ooops! Unable to save the address - Error: ' + address.account__c + e.getMessage()));
       return null; //If not returned then both error and save messages show up.
    }   
    
    // reset the adddress
    address = new Address__c();    
    address.account__c=accountID;
    
    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'Address has been created successfully. Please use the search tab to select the newly created address.'));
    return null;
  }

 
  // used by the visualforce page to send the link to the right dom element
  public string getFormTag() {
    return System.currentPageReference().getParameters().get('frm');
  }
 
  // used by the visualforce page to send the link to the right dom element for the text box
  public string getTextBox() {
    return System.currentPageReference().getParameters().get('txt');
  }
}