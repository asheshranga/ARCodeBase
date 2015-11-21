public with sharing class ContactLookupController {
 
  public Contact contact {get;set;}       // new contact to create
  public List<Contact> results{get;set;}  // search results
  public string searchString{get;set;}    // search keyword
  public string accountID{get;set;}
  public string accountName{get;set;}
  public string contactCity {get;set;}
  public string contactState {get;set;}
 
  public ContactLookupController () {
    contact = new Contact();
    // get the current search string
    searchString = System.currentPageReference().getParameters().get('lksrch');
    accountID    = System.currentPageReference().getParameters().get('accountid');
    accountName  = System.currentPageReference().getParameters().get('accountname');
        
    if ((accountID!='') && (accountID!=null) && (accountID!='000000000000000'))
       contact.accountid=accountID;
    runSearch();  
  }
 
  // performs the keyword search
  public PageReference search() {
    runSearch();
    return null;
  }
 
  // prepare the query and issue the search command
  private void runSearch() {
    // TODO prepare query string for complex serarches & prevent injections
    results = performSearch(searchString);               
  } 
 
  // run the search and return the records found. 
  private List<Contact> performSearch(string searchString) {
 
    String soql = 'select id, firstname, lastname, name, account.name, company__c, phone, email, mailingcity, mailingstate ' +
                  '  from contact ' +
                  ' where name != null ';
    if(searchString != '' && searchString != null)
      soql = soql +  ' and name LIKE \'%' + searchString +'%\'';
    if(accountName != null && accountName != '')
      soql = soql +  ' and (account.name LIKE \'%' + accountName + '%\' or ' + 
                     '      company__c LIKE \'%' + accountName + '%\')';
    if(contactCity != null && contactCity != '')
      soql = soql +  ' and mailingcity LIKE \'%' + contactCity +'%\'';
    if(contactState != null && contactState != '')
      soql = soql +  ' and mailingstate LIKE \'%' + contactState +'%\'';
          
    soql = soql + 'order by name limit 25';
    System.debug(soql);
    
    ApexPages.getMessages().clear();

    List<Contact> contacts = database.query(soql);    
    if (contacts.size() >= 25)    
       ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'Search results have been restricted to first 25 rows. Found more than 25+ rows, please refine the search.'));
       
    return contacts;  
  }
 
  // save the new contact record
  public PageReference saveContact() {
    try {
       insert contact;
       runSearch();
    }
    catch (exception e) {
       ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Ooops! Unable to save the contact - Error: ' + e.getMessage()));
    }   
    
    // reset the contact
    contact = new Contact();
    contact.accountid=accountID;
    
    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'Contact has been created successfully. Please use the search tab to select the newly created contact.'));
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