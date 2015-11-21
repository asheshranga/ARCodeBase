/*********************************************************************************
Name         : AtlasUserSearchController
Created By   : Kelly Wortel
Created Date : 4/24/2014
Project      : Atlas Beta-Exit
Usages       : Controller to return User Search details

Change Log:
<Date>      <Modified By>   <Change Description>
4/24/2014   K. Wortel       Controller Created
*********************************************************************************/
public with sharing class AtlasUserSearchController {
 
    // the soql without the order and limit
    private String soql {get;set;}
    
    public string profileId { get; set; }
    
    public string accountId {get; set;}
    
    // the collection of users to display
    public List<User> users {get{ 
    	if(setCon!=null)
    		return (List<User>) setCon.getRecords();
		else 
			return null;    	
    	}   	   	
    	set;}

    // Map to display user status from backoffice
    public Map<Id,String> userStatus {get;set;}
    
    public Integer resultSetSize {get;set;}
    
    // the current sort direction. defaults to asc
    public String sortDir {
        get  { if (sortDir == null) {  sortDir = 'asc'; } return sortDir;  }
        set;
    }

    // the current field to sort by. defaults to status
    public String sortField {
        get  { if (sortField == null) {sortField = 'UserName'; } return sortField;  }
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

    // Search criteria fields
    public String username { get; set;}
    public String userEmail { get; set;}
    public String firstName { get; set;}
    public String lastName { get; set;}
    public String externalAccountRef { get; set;}
    public String accountNumber { get; set;}
    public String phoneNumber   { get; set;}
    //public String federatedId   { get; set;}
    
    public String communityProfile { get; set; }
    
    public User dummyUser {get; set;} 
    
    public Boolean isSysAdmin {get; set;}   

    // init the controller and display some sample data when the page loads
    public AtlasUserSearchController() {
        
        dummyUser = new User();   
        
        // Load in the custom setting for Admin Profiles
        AtlasKeyValueStore__c AtlasKVS = AtlasKeyValueStore__c.getValues('Atlas Community Profile');
        communityProfile = AtlasKVS.Value__c;          
        
        Profile userProfile = [select Id, Name from Profile where Id = :UserInfo.getProfileId()];
        if (userProfile.Name.contains('System Administrator')) {  //('System Administrator'.equals(userProfile.Name)) {
           isSysAdmin = true;
        } else {
           isSysAdmin = false;
        }
       
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
            if(setCon == null && soql!=null) {
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
        get {if(setCon!=null)
        	 	return setCon.getResultSize();
        	else
        		return null; 	
    	 	}
        set;
    }
    
    public Boolean hasPrev {
        get {if(setCon!=null)
        		return setCon.getHasPrevious();
    		else
    			return null;
			}
        set;}

    public Boolean hasNext {
        get {if(setCon!=null)
        		return setCon.getHasNext();
    		 else
    		 return null;
        }
        set;}

    public String recordInfo {      
        get {if(setCon!=null)
        	 	return (resultSize == 0) ? '':((setCon.getPageNumber() - 1) * setCon.getPageSize() + 1) + ' - ' + 
                    ((setCon.getPageNumber() * setCon.getPageSize()) < setCon.getResultSize() ? (setCon.getPageNumber() * setCon.getPageSize()) : setCon.getResultSize()) + ' of ' +
                    setCon.getResultSize();
        	else
        		return null; 	
    	 	}
        set;
    }    
    
    public String pageInfo { 
        get {if(setCon!=null)
        	 	return (resultSize == 0) ? '':'Page ' + setCon.getPageNumber() + ' of ' + 
                    (((setCon.getResultSize()/setCon.getPageSize())*setCon.getPageSize() == setCon.getResultSize()) ? (setCon.getResultSize() / setCon.getPageSize()) : (setCon.getResultSize() / setCon.getPageSize()+1));
        	else
        		return null; 	
    	 	}
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
         //cases = Database.query(soql + ' order by ' + sortField + ' ' + sortDir);
         // System.debug('soqlWithOrderByAndLimit: ' + soqlWithOrderByAndLimit);
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
        username           = Apexpages.currentPage().getParameters().get('username');
        userEmail           = Apexpages.currentPage().getParameters().get('useremail');
        externalAccountRef  = Apexpages.currentPage().getParameters().get('externalaccountref');
        accountNumber       = Apexpages.currentPage().getParameters().get('accountnumber');
        firstName           = Apexpages.currentPage().getParameters().get('firstname');
        lastName            = Apexpages.currentPage().getParameters().get('lastname');
        phoneNumber         = Apexpages.currentPage().getParameters().get('phoneNumber');

        soql = 'SELECT Id, Username, Contact.firstName, Contact.lastName, Contact.email, Contact.phone, Contact.Account_Number__c, ExternalAccountReference__c, FederationIdentifier, Account_Number__c ' +
               'FROM User ' +
               'WHERE ProfileId in (\'' + communityProfile + '\') '; 
        
        if(!AtlasUtility.isEmpty(username)||!AtlasUtility.isEmpty(userEmail)||!AtlasUtility.isEmpty(externalAccountRef)||
        !AtlasUtility.isEmpty(accountNumber)||!AtlasUtility.isEmpty(firstName)||!AtlasUtility.isEmpty(lastName)||
        !AtlasUtility.isEmpty(phoneNumber)) {
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
	      
        }
        else
        	 soql += ' and Username=null';  

        // run the query again
        runQuery();

        return null;
    }
    
    public PageReference logInAs() {
      string url = '/apex/dashboard?Id=' + profileId + '&firstTime=true&isdtp=' ; 
      PageReference page = new PageReference(url);
      page.setRedirect(true);
      return page;
    }
    
    public PageReference passwordReset() {
      string url = '/apex/AtlasUserPasswordReset?Id=' + profileId; 
      PageReference page = new PageReference(url);
      page.setRedirect(true);
      return page;
    } 
    
    public PageReference changeUsername() {
      string url = '/apex/AtlasChangeLoginUserName?Id=' + profileId; 
      PageReference page = new PageReference(url);
      page.setRedirect(true);
      return page;
    } 
    
   /** public PageReference syncUserData() {
      User userObj = [select Id, ExternalAccountReference__c, Account_Number__c from User where Id = :profileId];
      AtlasSyncSFDC syncSFDC = new AtlasSyncSFDC();                
      ApexPages.Message syncStatusMesg;      
      if (syncSFDC.syncUserAndContact(userObj.Account_Number__c)) {
         syncStatusMesg = new ApexPages.Message(ApexPages.Severity.INFO,
                                AtlasUtility.getMapValue(AtlasConstants.SYNC_USER_DATA_WITH_SFDC_SUCCESS_MESG));
      } else {
         syncStatusMesg = new ApexPages.Message(ApexPages.Severity.INFO,
                                AtlasUtility.getMapValue(AtlasConstants.SYNC_USER_DATA_WITH_SFDC_FAIL_MESG));
      }
      ApexPages.addMessage(syncStatusMesg);
      return null;      
    }
    
    public PageReference moveInternalAccountNumber() {
      string url = '/apex/AtlasMoveInternalAccount?Id=' + profileId; 
      PageReference page = new PageReference(url);
      page.setRedirect(true);
      return page;
    }
    **/
    public PageReference checkStatus(){
    	PageReference pr = new PageReference('/apex/AtlasCustomerStatus');
    	pr.getParameters().put('accountId',accountId);
    	pr.setRedirect(true);
    	return pr;	
    } 
}