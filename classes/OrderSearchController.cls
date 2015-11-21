public with sharing class OrderSearchController {
	
	public Order__c o {get; set;} //Object for drop down
  	// the soql without the order and limit
  	private String soql {get;set;}  	
	// the collection of CCRs to display
	public List<Order__c> orders
	{
	 	get { 
	        		return (List<Order__c>) setCon.getRecords();
	    }
	    set;
	}
	
	// init the controller and display some sample data when the page loads
	public OrderSearchController() {
		o = new Order__c();
	     
	    o.status__c = '';
	  
		//This is done to make sure that the results are empty on first load.	  
	    soql = 'select name, Account__r.Name, Requestor_Name__c, OracleOrder__c, OrderDate__c, status__c, BillToAddress__r.Name, ShipToAddress__r.Name,TotalLines__c' +
	           '  from Order__c where recordtype.name=\''+System.Label.RMARecordType+'\' and name = null';
	          
	        
	    runQuery();
	     

	  }
	
	@IsTest(SeeAllData=true) public static void testOrderSearchController() { 
		OrderSearchController orderSearchController = new OrderSearchController();
		List<Order__c> otest = orderSearchController.orders;
		orderSearchController.toggleSort();
		Integer rsize = orderSearchController.resultSize;
		Boolean hprev = orderSearchController.hasPrev;
		Boolean hnext = orderSearchController.hasNext;
		String rInfo  = orderSearchController.recordInfo;
		String pInfo  = orderSearchController.pageInfo; 
		orderSearchController.next();
		orderSearchController.previous();
		orderSearchController.first();
		orderSearchController.last();
		String sDir   	= orderSearchController.sortDir;
		String sField 	= orderSearchController.sortField;
		String dsoql 	= orderSearchController.debugSoql;
	}
	  
	@IsTest(SeeAllData=true) public static void testOrderSearchController2() { 
		OrderSearchController orderSearchController = new OrderSearchController();
		orderSearchController.setCon = null;
		List<Order__c> otest = orderSearchController.orders;
	}  
	  
	
	@IsTest(SeeAllData=true) public static void testRunSearch() { 
	    OrderSearchController controller = new OrderSearchController();
	      
	    PageReference pageRef = Page.OrderSearch;
	    Test.setCurrentPageReference(pageRef);
	    Apexpages.currentPage().getParameters().put('name','1234');
	    Apexpages.currentPage().getParameters().put('order','1234');
	    Apexpages.currentPage().getParameters().put('status','Submitted');
	    Apexpages.currentPage().getParameters().put('sn','1234');
	    
	    controller.runSearch();
		
	}
	  
	@IsTest(SeeAllData=true) public static void testRunQueryError() { 
	    OrderSearchController controller = new OrderSearchController();
	    controller.soql = ''; 
	    
	    controller.runQuery();
		
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
	    	setCon = new ApexPages.StandardSetController(Database.getQueryLocator(soql + ' order by ' + sortField + ' ' + sortDir));
	       }
	       return setCon;
	    }
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
	    try {
	      setCon = new ApexPages.StandardSetController(Database.getQueryLocator(soql + ' order by ' + sortField + ' ' + sortDir));
	    } catch (Exception e) {
	      ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Ooops! ' + e.getMessage() + ' SQL - ' + soql + ' order by ' + sortField + ' ' + sortDir));
	    }
	 
	  }
	  
	  // the current sort direction. defaults to asc
	  public String sortDir {
	    get  { if (sortDir == null) {  sortDir = 'desc'; } return sortDir;  }
	    set;
	  }
	 
	  // the current field to sort by. defaults to last name
	  public String sortField {
	    get  { if (sortField == null) {sortField = 'name '; } return sortField;  }
	    set;
	  }
	
	  // format the soql for display on the visualforce page
	  public String debugSoql {
	    get { return soql + ' order by ' + sortField + ' ' + sortDir + ' limit 20'; }
	    set;
	  }
	  
  public PageReference runSearch() {
 
    String name     = Apexpages.currentPage().getParameters().get('name');
    String oracleOrder    = Apexpages.currentPage().getParameters().get('order');
    String status	= Apexpages.currentPage().getParameters().get('status');
    String sn	    = Apexpages.currentPage().getParameters().get('sn');
    
    soql = 'select name, Account__r.Name, Requestor_Name__c, OracleOrder__c, OrderDate__c, status__c, BillToAddress__r.Name, ShipToAddress__r.Name,TotalLines__c' +
	           '  from Order__c where recordtype.name=\''+System.Label.RMARecordType+'\'';
    
    if (!name.equals(''))
      soql += ' and name like \'%'+String.escapeSingleQuotes(name)+'%\'';
    if (!oracleOrder.equals(''))
      soql += ' and OracleOrder__c like \'%'+String.escapeSingleQuotes(oracleOrder)+'%\'';
    if (!status.equals(''))
      soql += ' and status__c like \'%'+String.escapeSingleQuotes(status)+'%\'';
    
    
    //--- Do the Site and CCR assosication SOQL to get the CCR IDs
    if (!sn.equals('')) {
       String snsearch	    = '%'+String.escapeSingleQuotes(sn)+'%';
    
       String lsorderids = '';
          
       for (AggregateResult q : [select  Order__c, count(id)
                                         from OrderLine__c
                                         where SerialNo__c like :snsearch
                                           		group by Order__c]) {
          lsorderids += ',\'' + q.get('Order__c') + '\'';
       }  
      
     
       if (!lsorderids.equals(''))
           soql += ' and id in (' + lsorderids.substring(1) + ')';
    } 
    

    // run the query again    
    runQuery();
    
    return null;
  }
  
  
	 

}