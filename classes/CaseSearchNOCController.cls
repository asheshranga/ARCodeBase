/***********************************************************************************************************
Name          : CaseSearchNOCController 
Modified By	  : Marina Basovich
Company Name  : ViaSat
Modified Date : Jan, 2015
Description   : Extention to CaseSearchController Controller for CaseSearchNOC.page
************************************************************************************************************/
public with sharing class CaseSearchNOCController 
{
	public Case dummyStartDates {get; set;}  
	public Case dummyEndDates {get;set;}

	// the collection of cases to display in export  
	public List<Case> allcases {get{ return database.query(soql + userTypeSQL + ' order by ' + sortField + ' ' + sortDir);}set;}

	// the collection of custom setting
	//public static Map<String,CarlsbadNOCKeyValueStore__c> MapKeyValue= CarlsbadNOCKeyValueStore__c.getAll(); 

  // the soql without the order and limit
  private String soql {get;set;}
  private String userTypeSQL;
  
  // the collection of cases to display
  public List<Case> cases {get{ return (List<Case>) setCon.getRecords();}set;}
  
  // format the soql for display on the visualforce page
  public String debugSoql {
    get { return soql + ' order by ' + sortField + ' ' + sortDir + ' limit 20'; }
    set;
  }
  
  // Search criteria fields
  public String accountName { get; set;}
  public String contactName { get; set;}
  public String productName { get; set;}
  public String ownerName   { get; set;}
  public String caseNumber  { get; set;} 
  
	// the soql without the order and limit
	public final string SOQLCaseSearchSelect = 'SELECT type, id, accountid, casenumber, subject, createddate, closeddate, status, statusdetails__c, severity__c, priority, network__c, ' +
           'ownerid, owner.name, contactid, contact.name, casecontact__c, casecontact__r.name, account.name, site__c, site__r.name, productid, product.name, product_family__c ' +
           'FROM Case WHERE casenumber != null and recordtype.name in (\'Carlsbad NOC\',\'Carlsbad NOC Customer Portal\') ';
  
  // init the controller and display some sample data when the page loads
  public CaseSearchNOCController() {
    dummyStartDates = new Case();
    dummyEndDates   = new Case();
    dummyStartDates.status = '';    
    
    userTypeSQL = '';
    if (UserInfo.getUserType() != 'Standard') {
       userTypeSQL = ' and VisibleToCustomer__c=\'Yes\' ';   
    }
  }
  
    // ApexPages.StandardSetController must be instantiated     
    // for standard list controllers     
	public ApexPages.StandardSetController setCon 
	{
		get {
			if(setCon == null) {
				if (soql != null)
					setCon = new ApexPages.StandardSetController(Database.getQueryLocator(soql + userTypeSQL + ' order by ' + sortField + ' ' + sortDir +' limit 1000'));
				else
					setCon = new ApexPages.StandardSetController(new list<Case>());
			}
			return setCon;
		}
		set;
	}

    // Initialize setCon and return a list of records 
    
    public List<Case> getCases() {
         return (List<Case>) setCon.getRecords();
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
	}
    
	public Boolean hasPrev{
		get {return setCon.getHasPrevious();}
	}

	public Boolean hasNext{
		get {return setCon.getHasNext();}
	}

    public void next() { setCon.next(); }    
    public void previous() { setCon.previous(); }    
	public void first() { setCon.first(); }    
	public void last() { setCon.last(); }
    
	public void toggleSort(){
		sortDir = sortDir.equals('asc') ? 'desc' : 'asc';
		runQuery();
	}

	// the current sort direction. defaults to asc
	public String sortDir {
    	get  { if (sortDir == null) {  sortDir = 'asc'; } return sortDir;  }
    	set;
	}
   
	// the current field to sort by. defaults to status
	public String sortField {
    	get  { if (sortField == null) {sortField = 'SortStatus__c'; } return sortField;  }
    	set;
	} 
    
	public String dateToString(Datetime aoDate) 
	{
		String lsReturn = aoDate + 'Z';
		return lsReturn.replace(' ','T'); 
	}
  
	// runs the actual query
	public void runQuery() 
	{
		try 
		{    
			string userTypeSQL = '';
			if (UserInfo.getUserType() != 'Standard')
				userTypeSQL = ' and VisibleToCustomer__c=\'Yes\' ';   

			setCon = new ApexPages.StandardSetController(Database.getQueryLocator(soql + userTypeSQL + ' order by ' + sortField + ' ' + sortDir + ' limit 10000'));
			setCon.first();      
		} catch (Exception e) {
			ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Ooops! ' + e.getMessage() + ' SQL - ' + soql + ' order by ' + sortField + ' ' + sortDir));
		}
	}
   
	// Runs the search with parameters passed via Javascript
	public PageReference runSearch() 
	{
		String type   = dummyStartDates.type;
		String status = dummyStartDates.status;
    
		accountName   = Apexpages.currentPage().getParameters().get('accountname');
		contactName   = Apexpages.currentPage().getParameters().get('contactname');
		productName   = Apexpages.currentPage().getParameters().get('productname');
		ownerName     = Apexpages.currentPage().getParameters().get('ownername');
		caseNumber    = Apexpages.currentPage().getParameters().get('casenumber');
     
		// Set soql to the basic Case Search SOQL
		soql = SOQLCaseSearchSelect;
     
     	// Modify soql based on the search criteria
		soql += (String.isEmpty(type)  ? '' : ' and type in (\''+String.escapeSingleQuotes(type)+'\')');    
		if (String.isEmpty(status) == false)
		{
			soql += ( status.equals('Open') ? ' and isclosed = false' : '');  
			soql += (!status.equals('Open') ? ' and status in (\''+String.escapeSingleQuotes(status)+'\')' : '');
		}
		   
		soql += (!accountName.equals('') ? ' and account.name LIKE \'%'+String.escapeSingleQuotes(accountName)+'%\'' : '');  
		soql += (!contactName.equals('') ? ' and casecontact__r.name LIKE \'%'+String.escapeSingleQuotes(contactName)+'%\'' : '');        
		soql += (!productName.equals('') ? ' and product.name LIKE \'%'+String.escapeSingleQuotes(productName)+'%\'' : '');       
		soql += (!ownerName.equals('') ? ' and owner.name LIKE \'%'+String.escapeSingleQuotes(ownerName)+'%\'' : '');       
		soql += (!caseNumber.equals('') ? ' and casenumber LIKE \'%' +String.escapeSingleQuotes(caseNumber) + '%\'' : '');  
      
		soql += (dummyStartDates.dummystartdate__c != null ? ' and createddate >= ' + dateToString(dummyStartDates.dummystartdate__c) : ''); 
		soql += (dummyEndDates.dummystartdate__c != null ? ' and createddate <= ' + dateToString(dummyEndDates.dummystartdate__c).replace('00:00:00','23:59:59') : ''); 
		soql += (dummyStartDates.dummyenddate__c != null ? ' and closeddate >= ' + dateToString(dummyStartDates.dummyenddate__c) : ''); 
		soql += (dummyEndDates.dummyenddate__c != null ? ' and closeddate <= ' + dateToString(dummyEndDates.dummyenddate__c).replace('00:00:00','23:59:59') : '');  
            
		// run the query again
		runQuery();
 
		return null;
	}
 
	public PageReference exportResults() 
	{
		PageReference exportPage = Page.CaseSearchNOCExport;
		return exportPage.setRedirect(false);
	}
}