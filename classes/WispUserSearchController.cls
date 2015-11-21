/*********************************************************************************
Name         : WispUserSearchController
Created By   : Tejesh Kumar
Company Name : CMC Americas    
Project      : ViaSat WISP
Created Date : 17 October, 2014
Usages       : Controller for VisualForce Page: partner_search
*********************************************************************************/
public class WispUserSearchController{

    private String soql {get;set;}  
    public string profileId { get; set; }        
    public List<User> users {get{ return (List<User>) setCon.getRecords();}set;}    // the collection of users to display    
    public Map<Id,String> userStatus {get;set;}    // Map to display user status from backoffice   
    public Integer resultSetSize {get;set;}   
    // Search criteria fields
    public String username { get; set;}
    public String userEmail { get; set;}
    public String firstName { get; set;}
    public String lastName { get; set;}
    public String externalAccountRef { get; set;}
    public String accountNumber { get; set;}
    public String phoneNumber   { get; set;}  
    public User dummyUser {get; set;}    
    public Boolean isSysAdmin {get; set;} 
    public string UserId {get; set;}
    public string urlId {get; set;}
    public String ParentId { get; set; }
    public AtlasMainDTO mainDTOObj{get; set;}
    public String headerName { get; set; }
    public String UrlName { get; set; } 
    public String communityProfile { get; set; }
    
    public string search{get{return AtlasUtility.getMapWispValue(Atlasconstants.Wisp_Search);}set;}
    public string clear{get{return AtlasUtility.getMapWispValue(Atlasconstants.Wisp_Clear);}set;}
    public string userAdmin{get{return AtlasUtility.getMapWispValue(Atlasconstants.Wisp_UserAdmin);}set;}
    public string subscribers{get{return AtlasUtility.getMapWispValue(Atlasconstants.WIsp_Subscribers);}set;}
    public string searchSubscribers{get{return AtlasUtility.getMapWispValue(Atlasconstants.Wisp_SearchSubscribers);}set;}
    public string wisploginAs{get{return AtlasUtility.getMapWispValue(Atlasconstants.Wisp_Partner_Loginas);}set;}
    public string resetPswd{get{return AtlasUtility.getMapWispValue(Atlasconstants.Wisp_Password);}set;}
    public string changeUname{get{return AtlasUtility.getMapWispValue(Atlasconstants.Wisp_ChangeUname);}set;}
    public string loading{get{return AtlasUtility.getMapWispValue(Atlasconstants.Wisp_CTI_Loading);}set;}
    public string next{get{return AtlasUtility.getMapWispValue(Atlasconstants.Wisp_Partner_Next);}set;}
    public string previous{get{return AtlasUtility.getMapWispValue(Atlasconstants.Wisp_Partner_Previous);}set;}
    
    public AtlasComponenttoController componentToPage {get; private set;}
    
    // the current sort direction. defaults to asc
    public String sortDir {
        get  { if (sortDir == null) {  sortDir = 'asc'; } return sortDir;  }
        set;
    }

    // the current field to sort by. defaults to FederationIdentifier
    public String sortField {
        get  { if (sortField == null) {sortField = 'FederationIdentifier'; } return sortField;  }
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

    // init the controller and display some sample data when the page loads
    public WispUserSearchController() {        
        ProfileId = UserInfo.getProfileId();
        componentToPage = new AtlasComponenttoController();
        componentToPage.isComp1=true; 
        componentToPage.isComp2=false;
        componentToPage.isComp3=false; 
        componentToPage.isComp4=false; 
        
        dummyUser = new User(); 
        //WispKeyValueStore__c WispKVS = WispKeyValueStore__c.getValues('Wisp Subscriber Community');
        communityProfile = AtlasUtility.getMapWispValue(AtlasConstants.WISP_Subscriber_Community);     
                          
        Profile userProfile = [select Id, Name from Profile where Id = :UserInfo.getProfileId()];
        loadUserObj();  
        system.debug('---ParentId before soql---> '+ ParentId);
                                                             
        soql = 'SELECT Id, Username, Contact.Account.ParentId, Contact.Account.Parent.Name, Contact.firstName, Contact.lastName, Contact.email, Contact.phone, Contact.Account_Number__c, ExternalAccountReference__c, FederationIdentifier, Account_Number__c ' +
               'FROM User '+
               'WHERE ProfileId in (\'' + communityProfile + '\')' +
               'and Contact.Account.ParentId = \'' + String.escapeSingleQuotes(ParentId) + '\'';
               
        // set the size to a larger value so that initial page load does not call backoffice API
        resultSetSize = 100;
        
        // Initialize the userStatus Map
        userStatus = new Map<Id,String>();
    }
    
    public void loadUserObj() {        
        urlId =  Apexpages.currentPage().getParameters().get('id');
        string siteurl =site.getBaseUrl();
        if(!AtlasUtility.IsEmpty(urlId) && AtlasUtility.IsEmpty(siteurl))
            UserId = urlId; 
        else
            UserId = UserInfo.getUserID();
                
        system.debug('---UserId---> '+ UserId);  
           
        if(!AtlasUtility.IsEmpty(UserId)) {
            User usr = [SELECT Id, Name, Contact.AccountId , Contact.Account.Name FROM User WHERE Id =: UserId LIMIT 1];
            headerName = usr.Name; 
            if(!AtlasUtility.IsEmpty(usr.Contact.AccountId))
            	ParentId = usr.Contact.AccountId;
        	else
        		ParentId = ''; 	 
        }
        else {
            headerName = ''; 
            ParentId = '';    
        } 
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
            system.debug('------setCon-----> '+setCon.getRecords());
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
        // System.debug('In runQuery method ...');
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
        username           = Apexpages.currentPage().getParameters().get('username');
        userEmail           = Apexpages.currentPage().getParameters().get('useremail');
        externalAccountRef  = Apexpages.currentPage().getParameters().get('externalaccountref');
        accountNumber       = Apexpages.currentPage().getParameters().get('accountnumber');
        firstName           = Apexpages.currentPage().getParameters().get('firstname');
        lastName            = Apexpages.currentPage().getParameters().get('lastname');
        phoneNumber         = Apexpages.currentPage().getParameters().get('phoneNumber');       

        system.debug('---ParentId in runsearch---> '+ ParentId);
        soql = 'SELECT Id, Username, Contact.Account.ParentId,  Contact.Account.Parent.Name, Contact.firstName, Contact.lastName, Contact.email, Contact.phone, Contact.Account_Number__c, ExternalAccountReference__c, FederationIdentifier, Account_Number__c ' +
               'FROM User ' +
               'WHERE ProfileId in (\'' + communityProfile + '\') ' + 
               'and Contact.Account.ParentId = \'' + String.escapeSingleQuotes(ParentId) + '\'';
        
        // System.debug('soql before checking for username: ' + soql);
        if (!username.equals(''))
          soql += ' and FederationIdentifier LIKE \'%'+String.escapeSingleQuotes(username)+'%\'';  
        if (!userEmail.equals(''))
          soql += ' and Contact.email LIKE \'%'+String.escapeSingleQuotes(userEmail)+'%\'';       
        if (!externalAccountRef.equals(''))
          soql += ' and ExternalAccountReference__c LIKE \'%'+String.escapeSingleQuotes(externalAccountRef)+'%\'';    
        if (!accountNumber.equals(''))
          soql += ' and Contact.Account_Number__c LIKE \'%'+String.escapeSingleQuotes(accountNumber)+'%\'';
        if (!firstName.equals(''))
          soql += ' and Contact.firstName LIKE \'%'+String.escapeSingleQuotes(firstName)+'%\'';       
        if (!lastName.equals(''))
          soql += ' and Contact.lastName LIKE \'%' +String.escapeSingleQuotes(lastName) + '%\''; 
        if (!phoneNumber.equals(''))
          soql += ' and Contact.phone LIKE \'%' +String.escapeSingleQuotes(phoneNumber) + '%\'';                    
          
        // System.debug('soql before calling runQuery: ' + soql);
        // run the query again
        runQuery();

        return null;
    }
    
    public PageReference logInAs() {
        string url = '/apex/subscriber_dashboard?firstTime=true&Id=' + profileId; 
        string siteURl =site.getBaseUrl();
        if(!AtlasUtility.IsEmpty(siteURl)) {              
            PageReference page = new PageReference(siteURl+'/subscriber_dashboard?firstTime=true&Id=' + profileId);
            page.setRedirect(true);
            return page;
        }
        else {
            PageReference page1 = new PageReference(url);
            page1.setRedirect(true);
            return page1;    
        }
    }
    
    public PageReference passwordReset() {
        componentToPage.isComp1=false; 
        componentToPage.isComp2=true;
        componentToPage.isComp3=false; 
        componentToPage.isComp4=false;
        return null;
    } 
    
    public PageReference changeUsername() {
        componentToPage.isComp1=false; 
        componentToPage.isComp2=false;
        componentToPage.isComp3=true; 
        componentToPage.isComp4=false;
        return null;
    } 
    
    public PageReference transactionhistory() {
        componentToPage.isComp1=false; 
        componentToPage.isComp2=false;
        componentToPage.isComp3=false; 
        componentToPage.isComp4=true;
        return null;
    } 

}