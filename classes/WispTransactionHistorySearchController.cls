/*********************************************************************************
Name         : WispTransactionHistorySearchController
Created By   : Tejesh Kumar
Company Name : CMC Americas    
Project      : ViaSat Atlas
Created Date : 24 November, 2014
Usages       : Controller for VisualForce Comp: WispTransactionHistorySearch
*********************************************************************************/
public with sharing class WispTransactionHistorySearchController {
                            
                            
    //--- Dummy Transaction History so that we can get the dropdown values
    public AtlasTransactionHistory__c dummyTransactionHistory {get;set;}
   
    // the soql without the order and limit
    private String soql='';

    //--- the collection of Transactions to display
    public List<AtlasTransactionHistory__c> transactions {
        get {return (List<AtlasTransactionHistory__c>) setCon.getRecords();}
        set;
    }
                        
    public AtlasComponenttoController componentToPage{get; set;}
    
    public string accountNumber {get;set;}
    public string customername {get;set;}
    public string module {get;set;}
    public string type {get;set;}
    public string status {get;set;}
    public string lastmodifieddate {get;set;}
    public string partnerName;
    
    public string headerName { get; set; } 
    public String application{get{return AtlasConstants.Wisp_application;}set;}
    public string loading{get{return AtlasUtility.getMapWispValue(Atlasconstants.Wisp_CTI_Loading);}set;}
    public string backtoSearch{get{return AtlasUtility.getMapWispValue(Atlasconstants.Wisp_BacktoSearch);}set;}
    public string transHistory{get{return AtlasUtility.getMapWispValue(Atlasconstants.Wisp_Transaction_History);}set;}
    public string next{get{return AtlasUtility.getMapWispValue(Atlasconstants.Wisp_Partner_Next);}set;}
    public string previous{get{return AtlasUtility.getMapWispValue(Atlasconstants.Wisp_Partner_Previous);}set;}                                     
    public string profileId{get; set;}
    public boolean runSearch;
    
    //--- Constructor
    public WispTransactionHistorySearchController() {
        dummyTransactionHistory = new AtlasTransactionHistory__c();   
        dummyTransactionHistory.transactionModule__c='';
        dummyTransactionHistory.transactionType__c='';
        runSearch = false;        
        //--- Assign the module and type, lastmodifieddate to the dummy transaction history
        dummyTransactionHistory.transactionModule__c = (module==null) ? '':module.trim();
        dummyTransactionHistory.transactionType__c = (type==null) ? '':type.trim();        
        lastmodifieddate = (lastmodifieddate==null) ? '':lastmodifieddate.trim();        
        try {
           dummyTransactionHistory.lastmodifieddate = Date.parse(lastmodifieddate);  
        } catch (Exception e) {
        }         
    }
    
    public  void loadFirst()
    { 
        // For test class usage
        if(AtlasUtility.isEmpty(profileId)) {
            id id1 = userinfo.getUserId();
            profileId= string.valueOf(id1);
            system.debug('--id1 --'+ id1 );
            system.debug('--profileId--'+ profileId);
        }    
        User userObj= [select Id, Account_Number__c, FederationIdentifier, Contact.Name, Contact.Account.Parent.Name, Contact.Email, Contact.Phone,Contact.ExternalAccountReference__c from User Where Id = :profileId Limit 1];       
        
        string externalaccref= ((userObj.Contact.ExternalAccountReference__c== null) || (userObj.Contact.ExternalAccountReference__c.trim().equals(''))) ? '':userObj.Contact.ExternalAccountReference__c;
        string username= ((userObj.Contact.ExternalAccountReference__c== null) || (userObj.Contact.ExternalAccountReference__c.trim().equals(''))) ? '':userObj.Contact.Name;        
        partnerName= ((userObj.Contact.Account.Parent.Name== null) || (userObj.Contact.Account.Parent.Name.trim().equals(''))) ? '':userObj.Contact.Account.Parent.Name;
     
        soql = 'SELECT Name, lastmodifieddate, LastModifiedById, AccountNumber__c, Application__c, customerName__r.name, LoggedInUser__r.name, transactionDescription__c, externalReferenceNum__c, internalServiceAgreementId__c, LoggedInUser__c, transactionModule__c, transactionStatus__c, transactionType__c' +              
               '  FROM AtlasTransactionHistory__c ' + 
               ' WHERE Application__c = \'' + String.escapeSingleQuotes(application) + '\'';
        if (username != '')
        	soql += ' and customerName__r.name like \''+String.escapeSingleQuotes(username)+'%\'';
        if (!externalaccref.equals(''))        
           soql += ' and externalReferenceNum__c like \''+String.escapeSingleQuotes(externalaccref)+'%\''; 
           
        //runQuery(); 
    }
    
    public String sortDir {
        get  { if (sortDir == null) {  sortDir = 'desc'; } return sortDir;  }
        set;
    }
   
    //--- ApexPages.StandardSetController must be instantiated     
    //--- for standard list controllers     
    public ApexPages.StandardSetController setCon {
        get {               
            if(!runsearch){
                system.debug('---enter runsearch true load first----');
                loadFirst();   
            }
            if(setCon == null) {  
                system.debug('---enter run search false setcon----');            
                setCon = new ApexPages.StandardSetController(Database.getQueryLocator(soql + ' order by ' + sortField + ' ' + sortDir + (Test.isRunningTest() ? ' limit 1 ': '') ));
            }
        return setCon;
        }
        set;
    }
   
    public String sortField {
        get  { if (sortField == null) {sortField = 'name '; } return sortField;  }
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
   
    public void toggleSort() {
        // simply toggle the direction
        sortDir = sortDir.equals('asc') ? 'desc' : 'asc';
      
        // run the query again
        runQuery();
    }
    
    public PageReference runSearch() {        
        runSearch = true;
        // For Test Class
        if(AtlasUtility.IsEmpty(partnerName))
            partnerName= ''; 
                
        soql = 'SELECT Name, lastmodifieddate, LastModifiedById, AccountNumber__c, Application__c, customerName__r.name, LoggedInUser__r.name, PartnerName__c, transactionDescription__c, externalReferenceNum__c, internalServiceAgreementId__c, LoggedInUser__c, transactionModule__c, transactionStatus__c, transactionType__c' +              
               '  FROM AtlasTransactionHistory__c ' + 
               ' WHERE Application__c = \'' + String.escapeSingleQuotes(application) + '\'' +
               ' and PartnerName__c = \'' + String.escapeSingleQuotes(partnerName) + '\'';
  
        string lsAccountNumber = ((accountNumber == null) || (accountNumber.trim().equals(''))) ? 'DUMMY':accountNumber;
        string lsCustomername = ((customername == null) || (customername.trim().equals(''))) ? 'DUMMY':customername;
        string lsModule  = (dummyTransactionHistory.transactionModule__c==null) ? '':dummyTransactionHistory.transactionModule__c;
        string lsType     =(dummyTransactionHistory.transactionType__c==null) ? '':dummyTransactionHistory.transactionType__c;
        string lsStatus = ((status == null) || (status.trim().equals(''))) ? 'DUMMY':status;
              
        if (!lsAccountNumber.equals('DUMMY'))        
            soql += ' and AccountNumber__c like \'%'+String.escapeSingleQuotes(lsAccountNumber)+'%\''; 
        if (!lsCustomername.equals('DUMMY'))        
            soql += ' and customerName__r.name like \'%'+String.escapeSingleQuotes(lsCustomername)+'%\''; 
        if (!lsStatus.equals('DUMMY'))          
            soql += ' and transactionStatus__c like \'%'+String.escapeSingleQuotes(lsStatus)+'%\'';           
        if (!lsModule.equals(''))
            soql += ' and transactionModule__c like \'%'+String.escapeSingleQuotes(lsModule)+'%\'';     
        if (!lsType.equals(''))
            soql += ' and transactionType__c like \'%'+String.escapeSingleQuotes(lsType)+'%\'';     
        // run the query again   
        runQuery();    
        
        return null;
        
    } 
    
    // runs the actual query
    public void runQuery() { 
        try {
            system.debug('runQuery = ' + soql);
            setCon = new ApexPages.StandardSetController(Database.getQueryLocator(soql + ' order by ' + sortField + ' ' + sortDir));
        } catch (Exception e) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Ooops! ' + e.getMessage() + ' SQL - ' + soql + ' order by ' + sortField + ' ' + sortDir));
        }
    } 
    
    public PageReference backToSearch() {
        componentToPage.isComp1=true; 
        componentToPage.isComp2=false;
        componentToPage.isComp3=false; 
        componentToPage.isComp4=false;
        runSearch = false;
        setcon = null;
        return null;
    } 
}