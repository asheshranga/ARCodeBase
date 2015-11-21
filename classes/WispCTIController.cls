/*********************************************************************************
Name         : WispCTIController
Created By   : Tejesh Kumar
Company Name : CMC Americas    
Project      : ViaSat WISP
Created Date : 28 October, 2014
Usages       : Controller for VisualForce Page: WispCTISearch
*********************************************************************************/
public with sharing class WispCTIController{

    private String soql {get;set;}   
    public string profileId { get; set; }          
    public List<User> users {get{ return (List<User>) setCon.getRecords();}set;}   // the collection of users to display  
    public Map<Id,String> userStatus {get;set;}    // Map to display user status from backoffice
    public Integer resultSetSize {get;set;}
    // Search criteria fields
    public String partnername { get; set;}
    public String username { get; set;}
    public String userEmail { get; set;}
    public String firstName { get; set;}
    public String lastName { get; set;}
    public String externalAccountRef { get; set;}
    public String accountNumber { get; set;}
    public String phoneNumber   { get; set;}
    public String communityProfile { get; set; }   
    public User dummyUser {get; set;}     
    public Boolean existinSFDC {get; set;}
    public String headerName { get; set; } 
    
    public string ctiViasat{get{return AtlasUtility.getMapWispValue(Atlasconstants.Wisp_CTI_Viasat);}set;}
    public string searchAgents{get{return AtlasUtility.getMapWispValue(Atlasconstants.Wisp_SearchAgents);}set;}
    public string Loading{get{return AtlasUtility.getMapWispValue(Atlasconstants.Wisp_CTI_Loading);}set;}
    public string agents{get{return AtlasUtility.getMapWispValue(Atlasconstants.Wisp_Agents);}set;}
    public string loginAs{get{return AtlasUtility.getMapWispValue(Atlasconstants.Wisp_CTI_LoginAs);}set;}
    public string createSFDC{get{return AtlasUtility.getMapWispValue(Atlasconstants.WIsp_CTI_CreateSFDC);}set;}
    public string search{get{return AtlasUtility.getMapWispValue(Atlasconstants.Wisp_Search);}set;}
    public string clear{get{return AtlasUtility.getMapWispValue(Atlasconstants.Wisp_Clear);}set;}
                    
    // the current sort direction. defaults to asc
    public String sortDir {
        get  { if (sortDir == null) {  sortDir = 'asc'; } return sortDir;  }
        set;
    }

    // the current field to sort by. Default by Partner name
    public String sortField {
        get  { if (sortField == null) {sortField = 'Contact.Account.Name'; } return sortField;  }
        set;
    }

    // format the soql for display on the visualforce page
    public String debugSoql {
        get { return soql + ' order by ' + sortField + ' ' + sortDir + ' limit 20'; }
        set;
    }

    // Limit string for @Test case
    public String soqlLimit   { 
        get { if (soqlLimit == null) {soqlLimit = ' limit 1000 '; } return soqlLimit;  } 
        set;
    }      

    // Constructor - init the controller and display some sample data when the page loads
    public WispCTIController() {
        
        existinSFDC=true;
        dummyUser = new User();   
             
        // Load in the custom setting for Admin Profiles
        //WispKeyValueStore__c WispKVS = WispKeyValueStore__c.getValues('Wisp Agent Community Profile');
        communityProfile = AtlasUtility.getMapWispValue(AtlasConstants.WISP_Admin_Community);          
       
        soql = 'SELECT Id, Username, Contact.Account.Parent.Name, Contact.Account.ParentId, Contact.Account.Name, Contact.firstName, Contact.lastName, Contact.email, Contact.phone, Contact.Account_Number__c, ExternalAccountReference__c, FederationIdentifier, Account_Number__c ' +
               'FROM User ' +
               'WHERE ProfileId in (\'' + communityProfile + '\') ' +
               '  and IsActive = true '; 
        
        // set the size to a larger value so that initial page load does not call backoffice API
        resultSetSize = 100;
        
        // Initialize the userStatus Map
        userStatus = new Map<Id,String>();
    }
 
    // toggles the sorting of query from asc<-->desc
    public void toggleSort() {
        // simply toggle the direction
        sortDir = sortDir.equals('asc') ? 'desc' : 'asc';
        // run the query again
        runQuery();
    }
 
 
    // ApexPages.StandardSetController must be instantiated     
    // for standard list controllers     
    public ApexPages.StandardSetController setCon {
        get {
            if(setCon == null) {
                setCon = new ApexPages.StandardSetController(Database.getQueryLocator(soql + ' order by ' + sortField + ' ' + sortDir + ' ' + soqlLimit));
            }
            return setCon;
        }
        set;
    }

    // Initialize setCon and return a list of records 
    public List<User> getUsers() {
        return (List<User>) setCon.getRecords();
    }
    
    public Integer resultSize {
        get {return setCon.getResultSize();}
        set;
    }
    
    public Boolean hasPrev {
        get {return setCon.getHasPrevious();}
        set;
    }

    public Boolean hasNext {
        get {return setCon.getHasNext();}
        set;
    }

    public String recordInfo { 
        get { return (resultSize == 0) ? '':((setCon.getPageNumber() - 1) * setCon.getPageSize() + 1) + ' - ' + 
                    ((setCon.getPageNumber() * setCon.getPageSize()) < setCon.getResultSize() ? (setCon.getPageNumber() * setCon.getPageSize()) : setCon.getResultSize()) + ' of ' +
                    setCon.getResultSize(); } 
        set;
    }    
    
    public String pageInfo { 
        get { return (resultSize == 0) ? '':'Page ' + setCon.getPageNumber() + ' of ' + 
                    (((setCon.getResultSize()/setCon.getPageSize())*setCon.getPageSize() == setCon.getResultSize()) ? (setCon.getResultSize() / setCon.getPageSize()) : (setCon.getResultSize() / setCon.getPageSize()+1));} 
        set;
    }    
    
    public void next() {
        setCon.next();
    }
    
    public void previous() {
        setCon.previous();
    }
    
    public void first() {
        setCon.first();
    }
    
    public void last() {
        setCon.last();
    }
  
    // runs the actual query
    public void runQuery() {
        String soqlWithOrderByAndLimit = soql + ' order by ' + sortField + ' ' + sortDir + ' ' + soqlLimit;
        try {
            setCon = new ApexPages.StandardSetController(Database.getQueryLocator(soqlWithOrderByAndLimit));       
            // Only display backoffice status if result set size is 5 or less
            resultSetSize = setCon.getResultSize();
            if (resultSetSize <= 5) {
                List<User> loUsers =  setCon.getRecords();
           
                AtlasPublicWebServiceSearchServiceStub.findSubscribersBySearchCriteriaResponse loSearchResponse;
                String lsUserStatus;
                for (User loUser : loUsers) {
                    lsUserStatus = '';
                    try {
                        loSearchResponse = AtlasIntegrationUtility.findSubscribersBySearchCriteria(loUser.Account_Number__c);
                        lsUserStatus = loSearchResponse.subscriber[0].serviceAgreement.provisioningStatus;
                    } catch (Exception e) {
                     // Do Nothing
                    }
                    userStatus.put(loUser.Id,lsUserStatus);
                }
            }
               
        } catch (Exception e) {
         String apexMessage = 'Ooops! ' + e.getMessage() + ' SQL - ' + soqlWithOrderByAndLimit;        
         ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, apexMessage));
        }
    }
   
    // runs the search with parameters passed via Javascript
    public PageReference runSearch() {
        // System.debug('In runSearch ...');
        partnername         = Apexpages.currentPage().getParameters().get('partnername');
        username            = Apexpages.currentPage().getParameters().get('username');
        userEmail           = Apexpages.currentPage().getParameters().get('useremail');
        externalAccountRef  = Apexpages.currentPage().getParameters().get('externalaccountref');
        accountNumber       = Apexpages.currentPage().getParameters().get('accountnumber');
        firstName           = Apexpages.currentPage().getParameters().get('firstname');
        lastName            = Apexpages.currentPage().getParameters().get('lastname');
        phoneNumber         = Apexpages.currentPage().getParameters().get('phoneNumber');

        soql = 'SELECT Id, Username, Contact.Account.Parent.Name, Contact.Account.Name, Contact.firstName, Contact.lastName, Contact.email, Contact.phone, Contact.Account_Number__c, ExternalAccountReference__c, FederationIdentifier, Account_Number__c ' +
               'FROM User ' +
               'WHERE ProfileId in (\'' + communityProfile + '\') ' +
               '  and IsActive = true '; 
        
        // System.debug('soql before checking for username: ' + soql);
        if(!partnername.equals(''))
            soql += ' and Contact.Account.Name LIKE \'%'+String.escapeSingleQuotes(partnername)+'%\'';
        if (!username.equals(''))
          soql += ' and FederationIdentifier LIKE \'%'+String.escapeSingleQuotes(username)+'%\'';  
        if (!userEmail.equals(''))
            soql += ' and Contact.email LIKE \'%'+String.escapeSingleQuotes(userEmail)+'%\'';                 
        if (!firstName.equals(''))
          soql += ' and Contact.firstName LIKE \'%'+String.escapeSingleQuotes(firstName)+'%\'';       
        if (!lastName.equals(''))
          soql += ' and Contact.lastName LIKE \'%' +String.escapeSingleQuotes(lastName) + '%\''; 
        if (!phoneNumber.equals(''))
          soql += ' and Contact.phone LIKE \'%' +String.escapeSingleQuotes(phoneNumber) + '%\''; 

        // run the query again
        runQuery();

        return null;
    }
    
    public PageReference logInAs() {
      string url = '/apex/partner_search?Id=' + profileId;
      String siteURl =site.getBaseUrl();
      if(!AtlasUtility.IsEmpty(siteURl)) {              
          PageReference page = new PageReference(siteURl+'/partner_search?Id=' + profileId);
          page.setRedirect(true);
          return page;
      }
      else {
          PageReference page1 = new PageReference(url);
          page1.setRedirect(true);
          return page1;    
      }
    }
 
    public pagereference createInSFDC() {
    return null;
    }
}