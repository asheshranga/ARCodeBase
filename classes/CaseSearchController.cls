/***********************************************************************************************************
Name          : CaseSearchController 
Created By    : Marina Basovich
Company Name  : ViaSat
Project       : This is the base for any CASE SEARCH CONTROLLER
Modified Date : Jan, 2015
Description   : Custom Controller that is used by CaseSearchNOC.page, ViaCase.page, CaseSearch.page(just like CaseSearchNOC + itars)
				It has the basic methods & properties for the Case Search
************************************************************************************************************/
public with sharing class CaseSearchController 
{
	// Dummy Case so we can get the dropdown values
	public Case dummyCase {get;set;}   
      	
	public String soql {get;set;}  
 
	// the collection of custom setting
	private static Map<String, CaseKeyValueStore__c> MapKeyValue = CaseKeyValueStore__c.getAll(); 

	// Search criteria fields
	public String accountName { get; set;}
	public String contactName { get; set;}
	public String productName { get; set;}
	public String ownerName   { get; set;}
	public String caseNumber  { get; set;} 

	// init the controller and display some sample data when the page loads
	public CaseSearchController() 
	{    
		dummyCase = new Case(); 
		dummyCase.status = '';    
		dummyCase.priority = '';
	}

	public List<Case> cases 
	{
		get{ return (List<Case>) setCon.getRecords();}
		set;
	}

	// the collection of cases to display in export  
	public List<Case> allRecords 
	{
		get
		{
	        if (allRecords == null)
	        {
	        	allRecords = new List<Case>();
	        	setCon.first();
	        	allRecords.addAll((List<Case>)setCon.getRecords());
	        	while(setCon.getHasNext())
        		{
        			setCon.next();
					allRecords.addAll((List<Case>)setCon.getRecords());
            	}
	        }
        	return allRecords;
    	}
		set;
	}
 
	// the current sort direction. defaults to asc
	public String sortDir {
    	get  { if (sortDir == null) {  sortDir = 'asc'; } return sortDir;  }
    	set;
	}
   
	// the current field to sort by. defaults to status
	public String sortField {
    	get  { if (sortField == null) {sortField = 'SortStatus__c'; } return sortField;  }
    	//get  { if (sortField == null) {sortField = 'SortPriority__c desc, SortStatus__c'; } return sortField;  }
    	set;
	} 

	public Boolean itarsAllowed{ 
		get	{ return false; }//ItarHelper.viewAllowed(ProfileName.Name);  
	}	

	// ApexPages.StandardSetController must be instantiated for standard list controllers     
    // Initialize setCon and return a list of records 
	public ApexPages.StandardSetController setCon 
	{
		get {
			if(setCon == null) {
				if (soql != null)
					setCon = new ApexPages.StandardSetController(Database.getQueryLocator(soql + ' order by ' + sortField + ' ' + sortDir +' limit 1000'));
				else
					setCon = new ApexPages.StandardSetController(new list<Case>());
			}
			return setCon;
		}
		set;
	}

	public String recordInfo{ 
		get { return (resultSize == 0) ? '':((setCon.getPageNumber() - 1) * setCon.getPageSize() + 1) + ' - ' + 
                    ((setCon.getPageNumber() * setCon.getPageSize()) < setCon.getResultSize() ? (setCon.getPageNumber() * setCon.getPageSize()) : setCon.getResultSize()) + ' of ' +
                    setCon.getResultSize(); } 
    }    
      
	public String pageInfo{ 
		get { return (resultSize == 0) ? '':'Page ' + setCon.getPageNumber() + ' of ' + 
                    (((setCon.getResultSize()/setCon.getPageSize())*setCon.getPageSize() == setCon.getResultSize()) ? (setCon.getResultSize() / setCon.getPageSize()) : (setCon.getResultSize() / setCon.getPageSize()+1));} 
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
  
	public PageReference exportResults() 
	{
		PageReference exportPage = Page.CaseSearchNOCExport;
		return exportPage.setRedirect(false);
	} 
    
	public String dateToString(Datetime aoDate) 
	{
		String lsReturn = aoDate + 'Z';
		return lsReturn.replace(' ','T'); 
	}

	// use apex describe to build the picklist values
	public List<String> statuses 
	{
		get{
			if (statuses == null) { 
        	statuses = new List<String>();
        	statuses.add('--None--');
        	statuses.add('New');
        	statuses.add('Open');
        	statuses.add('Analyzing');
        	statuses.add('Working');
        	statuses.add('Verifying');
        	statuses.add('Monitoring');
        	statuses.add('Cancelled');
        	statuses.add('On Hold');
        	statuses.add('Closed');        
        //--- Since we have issue with status.getDescribe getting specific record type values,
        //--- hardcoded the values above, instead of using the below approach.
        //Schema.DescribeFieldResult field = case.status.getDescribe();
        //for (Schema.PicklistEntry f : field.getPicklistValues())
        //  statuses.add(f.getLabel()); 
			}
			return statuses;          
		}
		set;
	}
  
	// use apex describe to build the picklist values
	public List<String> networks
	{
    	get {
			if (networks == null) { 
				networks = new List<String>();
				networks.add('--None--');        
				for (Network__c objnetworks : [SELECT Name FROM network__c]) 
					networks.add(objnetworks.Name);          
			}
			return networks;          
		}
		set;
	}
	
	// ************************************************************************************
	// Support the search with parameters passed via Javascript
	// ************************************************************************************
	// the soql without the order and limit
	public final string SOQLCaseSearchSelect = 'SELECT type, id, accountid, casenumber, subject, createddate, closeddate, status, statusdetails__c, severity__c, priority, network__c, ' +
           'ownerid, owner.name, contactid, contact.name, casecontact__c, casecontact__r.name, account.name, site__c, site__r.name, productid, product.name, product_family__c ' +
           'FROM Case WHERE casenumber != null '; 

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
			allRecords = null;
		} catch (Exception e) {
			ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Ooops! ' + e.getMessage() + ' SQL - ' + soql + ' order by ' + sortField + ' ' + sortDir));
		}
	}
   
	public PageReference runSearch() 
	{
		String type          = dummyCase.type;
		String status        = Apexpages.currentPage().getParameters().get('status');

		String severity      = dummyCase.severity__c;
		String priority      = dummyCase.priority;
		String network       = Apexpages.currentPage().getParameters().get('network');
		String productfamily = dummyCase.product_family__c;
    
		accountName   = Apexpages.currentPage().getParameters().get('accountname');
		contactName   = Apexpages.currentPage().getParameters().get('contactname');
		productName   = Apexpages.currentPage().getParameters().get('productname');
		ownerName     = Apexpages.currentPage().getParameters().get('ownername');
		caseNumber    = Apexpages.currentPage().getParameters().get('casenumber');
     
		// Set soql to the basic Case Search SOQL
		soql = SOQLCaseSearchSelect;
     
     	// Modify soql based on the search criteria
		soql += (String.isEmpty(type) || type =='--None--' ? '' : ' and type in (\''+String.escapeSingleQuotes(type)+'\')');    

		if (!String.isEmpty(status) && status != '--None--')
		{
			if (status.equals('Open'))
				soql += ' and isclosed = false';  
			else
				soql += ' and status in (\''+String.escapeSingleQuotes(status)+'\')';
		}
		soql += (String.isEmpty(severity) || severity=='--None--' ? '' : ' and severity__c in (\''+String.escapeSingleQuotes(severity)+'\')');
		soql += (String.isEmpty(priority) || priority=='--None--' ? '' : ' and priority in (\''+String.escapeSingleQuotes(priority)+'\')');
		soql += (String.isEmpty(network) || network=='--None--' ? '' : ' and network__r.name in (\''+String.escapeSingleQuotes(network)+'\')');
		soql += (String.isEmpty(productfamily) || productfamily=='--None--' ? '' : ' and product_family__c in (\''+String.escapeSingleQuotes(productfamily)+'\')');
		   
		soql += (accountName != null && !accountName.equals('') ? ' and account.name LIKE \'%'+String.escapeSingleQuotes(accountName)+'%\'' : '');  
		soql += (contactName != null && !contactName.equals('') ? ' and casecontact__r.name LIKE \'%'+String.escapeSingleQuotes(contactName)+'%\'' : '');        
		soql += (productName != null && !productName.equals('') ? ' and product.name LIKE \'%'+String.escapeSingleQuotes(productName)+'%\'' : '');       
		soql += (ownerName != null && !ownerName.equals('') ? ' and owner.name LIKE \'%'+String.escapeSingleQuotes(ownerName)+'%\'' : '');       
		soql += (caseNumber != null && !caseNumber.equals('') ? ' and casenumber LIKE \'%' +String.escapeSingleQuotes(caseNumber) + '%\'' : '');  
            
		// run the query again
		runQuery();
 
		return null;
	}
}