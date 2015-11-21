/*********************************************************************************
Name :   CCRSearchController 
Usage :  Controller on CCRSearch VF page.
*********************************************************************************/
public with sharing class CCRSearchController extends PageControllerBase
{
	// Build a local cache so that we don't request this multiple times
	private static Map<string, Id> rtypesCache;
    public static String CCR_RT_AVL_FOR_SEARCH = 'CCR_RT_AVL_FOR_SEARCH';
	static {rtypesCache = new Map<string, Id>();}

	// Returns a map of active, user-available RecordType IDs for CCR__r SObject 
	public static map<string, Id> ccrRecordTypes
	{
		get{
			if (rtypesCache == null || rtypesCache.size() == 0)	
				rtypesCache = ViasatUtilityClass.getAvailableRecordTypes(CCR__c.SObjectType);           
           
			return rtypesCache;
		}
		set;
	}

	// Build Record Type select options 
    public List<selectOption> recordTypes
    {
        get {
            List<selectOption> options = new List<selectOption>();
            options.add(new SelectOption('', '--None--'));
            /*map<string, Id> recTypes = ccrRecordTypes;
            for(string stype : recTypes.keySet())
                options.add(new SelectOption(ccrRecordTypes.get(stype),stype));*/
            
            CarlsbadNOCKeyValueStore__c avlRecTypes = CarlsbadNOCKeyValueStore__c.getInstance(CCR_RT_AVL_FOR_SEARCH);
            List<String> listOfRTs = new List<String>();
            
            if(avlRecTypes != null && avlRecTypes.Value__c != null)
            listOfRTs = avlRecTypes.Value__c.split(';');
            
            for(String rtName : listOfRTs)
            {
             String rtId =  Schema.SObjectType.CCR__c.getRecordTypeInfosByName().get(rtName).getRecordTypeId();
             options.add(new SelectOption(rtId, rtName));   
            }
                         
            return options;
        }
        set;
    }
    	
	public CCR__c dummyCCR {get; set;} //CCR Object for Status drop down
 
	// the soql without the order and limit
	@TestVisible
	private String soql {get;set;}
	private set<id> lsccrids; 
/*
	public MultiselectController msComponentController { get; set; }
	public override void setComponentController(MultiselectController compController) {
    	msComponentController = (MultiselectController)compController;
  	}
  	public override MultiselectController getComponentController() {
    	return msComponentController;
	}
*/	
	public SelectOption[] allStatuses 
	{
	 get
	 { 
		if(allStatuses == null)
		{
			allStatuses = new list<SelectOption>();
            Schema.DescribeFieldResult field = CCR__c.Status__c.getDescribe();            
			for (Schema.PicklistEntry f : field.getPicklistValues())
			{
				if (f.isActive())// && f.getLabel() != 'New')
					allStatuses.add(new SelectOption(f.getLabel(), f.getLabel()));
			}
			//selectedOptions = new list<SelectOption>();
			//selectedOptions.add(new SelectOption('New', 'New'));			
		}
		return allStatuses;
	 }
	 set;
	}
 
	// the collection of CCRs to display
	public List<CCR__c> ccrs
	{
		get { return (List<CCR__c>) setCon.getRecords(); }
		set;
	}
  
	public List<CCRSiteAssociation__c> associations {get;set;}
  
	public map<Id,Long> siteCountMap {get;set;}
	public map<Id,Long> caseCountMap {get;set;}   
 
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
  
	// init the controller and display some sample data when the page loads
	public CCRSearchController() 
	{
		dummyCCR = new CCR__c();   
        selectedOptions = new List<SelectOption>();
	}
  
	//Populates siteCountMap and caseCountMap
	private void populateAssociationMap()
	{
		siteCountMap = new map<Id, Long>();
		caseCountMap = new map<Id, Long>();

		List<AggregateResult> siteCountList = [select CCR__c, count(id) from CCRSiteAssociation__c where CCR__c IN : setCon.getRecords() group by CCR__c];
		List<AggregateResult> caseCountList = [select CCR__c, count(id) from CCRCaseAssociation__c where CCR__c IN : setCon.getRecords() group by CCR__c];
        for(CCR__c ccr: (List<CCR__c>) setCon.getRecords())
        {
			siteCountMap.put((id)ccr.id, 0);
            caseCountMap.put((Id)ccr.id, 0);
        }

		for (AggregateResult sitecount : siteCountList)
		{
			siteCountMap.put((Id)sitecount.get('CCR__c'),(Long)sitecount.get('expr0'));
		}
		for (AggregateResult casecount : caseCountList)
		{
			caseCountMap.put((Id)casecount.get('CCR__c'),(Long)casecount.get('expr0'));
		} 
	}
  
	// toggles the sorting of query from asc<-->desc
	public void toggleSort() {
		// simply toggle the direction
		sortDir = sortDir.equals('asc') ? 'desc' : 'asc';
		
		// run the query again
		runQuery();
	}
	    
	// ApexPages.StandardSetController must be instantiated for standard list controllers     
	public ApexPages.StandardSetController setCon 
	{
		get 
		{
			if(setCon == null) 
			{
				if (soql != null)
					setCon = new ApexPages.StandardSetController(Database.getQueryLocator(soql + ' order by ' + sortField + ' ' + sortDir));
				else
					setCon = new ApexPages.StandardSetController(new list<CCR__c>());
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
    populateAssociationMap();
	}
    
	public void previous() {
    setCon.previous();
    populateAssociationMap();
	}
    
	public void first() {
    setCon.first();
    populateAssociationMap();
	}
    
	public void last() {
    setCon.last();
    populateAssociationMap();
	}
  
	// runs the actual query
	public void runQuery() 
	{ 
		try 
		{
			system.debug('runQuery = ' + soql + ' order by ' + sortField + ' ' + sortDir);
			setCon = new ApexPages.StandardSetController(Database.getQueryLocator(soql + ' order by ' + sortField + ' ' + sortDir));
    
			populateAssociationMap();
		} 
		catch (Exception e) {
			ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Ooops! ' + e.getMessage() + ' SQL - ' + soql + ' order by ' + sortField + ' ' + sortDir));
		}
	}
	
public String selectedItms{ get; set; }

public string status{get;set;}
public string urgency{get;set;}
public String selectedRecType{get;set;}
public String name{get;set;}
public String subject{get;set;}
public String owner{get;set;}
public String requestor{get;set;}
public String sitenum{get;set;}
public String siteAltName{get;set;}
//public String casenum{get;set;}
public String account{get;set;}
public String product{get;set;}

	// runs the search with parameters passed via Javascript
	public PageReference clearSearch() 
	{
		//MultiselectController msc = getComponentController();
		//msc.selectedOptions = new List<SelectOption>();
		//msc.rightOptionsHidden = '';
		//msc.rightOptions= new List<SelectOption>();
		
		selectedOptions = new List<SelectOption>();
		allStatuses = null;
		
		setCon = new ApexPages.StandardSetController(new list<CCR__c>());
    	return null;
	}
	 
	// runs the search with parameters passed via Javascript
	public PageReference runSearch() 
	{
		name     = Apexpages.currentPage().getParameters().get('name');
		subject  = Apexpages.currentPage().getParameters().get('subject');
		owner    = Apexpages.currentPage().getParameters().get('owner');
		requestor= Apexpages.currentPage().getParameters().get('requestor');

    	selectedItms = '';
    	if (selectedOptions != null)
    	for (SelectOption so : selectedOptions) 
    	{
    		selectedItms += ((selectedItms == '' ? '\'' : ',\'') + so.getValue() +'\'');
    	}
		status  = Apexpages.currentPage().getParameters().get('statussel');
		if (!String.isEmpty(status))
    		selectedItms = '\'' + status +'\'';
		
		urgency  = Apexpages.currentPage().getParameters().get('urgencysel');
		//recType = Apexpages.currentPage().getParameters().get('recType');
        
		sitenum  = Apexpages.currentPage().getParameters().get('sitenum');
		siteAltName  = Apexpages.currentPage().getParameters().get('siteAltName');
		//casenum  = Apexpages.currentPage().getParameters().get('casenum');
		account  = Apexpages.currentPage().getParameters().get('account');
		product  = Apexpages.currentPage().getParameters().get('product');

		soql = 'SELECT name, subject__c,CreatedDate, status__c,urgency__c, severity__c,RecordType.Id,RecordType.Name, owner.name, estimatedoutage__c, schedulestarttime__c, scheduleendtime__c,requestedby__r.name' +
               '  FROM CCR__c where name != null ';

		if (!String.isEmpty(name))
			soql += 'and name like \'%'+String.escapeSingleQuotes(name)+'%\'';
		if (!String.isEmpty(subject))
			soql += 'and subject__c like \'%'+String.escapeSingleQuotes(subject)+'%\'';
		if (!String.isEmpty(owner))
			soql += 'and owner.name like \'%'+String.escapeSingleQuotes(owner)+'%\'';
		if (!String.isEmpty(requestor))
			soql += 'and requestedby__r.name like \'%'+String.escapeSingleQuotes(requestor)+'%\'';   

		if (selectedItms != '')
			soql += ' and status__c in ('+ selectedItms +')';

		if (!String.isEmpty(urgency))
			soql += ' and urgency__c in (\''+String.escapeSingleQuotes(urgency)+'\')';

		if (!String.isEmpty(selectedRecType))
			soql += ' and recordTypeId = \''+ selectedRecType +'\'';    
		
		//--- Do the Site and CCR assosication SOQL to get the CCR IDs
		if (!String.isEmpty(sitenum) || !String.isEmpty(siteAltName) || !String.isEmpty(account) || !String.isEmpty(product))// || !String.isEmpty(casenum)) 
		{
			lsccrids = new set<id>();
 		      
//			if (!casenum.equals(''))
//			{
//				String casesearch = '%'+String.escapeSingleQuotes(casenum)+'%';
//
//				for (AggregateResult a : [select CCR__c from CCRCaseAssociation__c
//			                          where case__r.casenumber like :casesearch group by CCR__c]) {
//					lsccrids.add((id)a.get('CCR__c')); 
//				}
//			}

			if (!account.equals(''))
			{
				String accountsearch       = '%'+String.escapeSingleQuotes(account)+'%';
				for (AggregateResult q : [select CCR__c from CCRSiteAssociation__c
                              where sitenoc__r.account__r.name like :accountsearch group by CCR__c]) {
					lsccrids.add((id)q.get('CCR__c'));
				}
			}

			if (!sitenum.equals('') || !siteAltName.equals('') || !product.equals('')) 
			{
				//--- If no value was passed, set to dummy value so the Site and CCR assosiation SOQL returns no data        
				sitenum = (sitenum.equals('')) ? '###NULL###':sitenum;
				siteAltName = (siteAltName.equals('')) ? '###NULL###':siteAltName;    
				String sitesearch          = '%'+String.escapeSingleQuotes(sitenum)+'%';
				String siteAltNamesearch   = '%'+String.escapeSingleQuotes(siteAltName)+'%';
             
				if (product.equals(''))
				{
					if (sitenum.equals(''))
					{
						if (!siteAltName.equals(''))
						{
							for (AggregateResult q : [select CCR__c from CCRSiteAssociation__c
                                 where sitenoc__r.AlternateSiteNames__c like :siteAltNamesearch group by CCR__c]) {
								lsccrids.add((id)q.get('CCR__c'));
							}						
						}
					}
					else
					{
						if (siteAltName.equals(''))
						{
							for (AggregateResult q : [select CCR__c from CCRSiteAssociation__c
                                 where sitenoc__r.name like :sitesearch group by CCR__c]) {
								lsccrids.add((id)q.get('CCR__c'));
							}
						}
						else
						{
							for (AggregateResult q : [select CCR__c, count(id) from CCRSiteAssociation__c
                                 where sitenoc__r.name like :sitesearch
                                    or sitenoc__r.AlternateSiteNames__c like :siteAltNamesearch group by CCR__c]) {
								lsccrids.add((id)q.get('CCR__c'));
							}						
						}
					}
				}
				else
				{
					String productsearch       = '%'+String.escapeSingleQuotes(product)+'%';
					if (sitenum.equals(''))
					{
						if (siteAltName.equals(''))
						{
							for (AggregateResult q : [select CCR__c, count(id) from CCRSiteAssociation__c
                                 where sitenoc__r.product__r.name like :productsearch group by CCR__c]) {
								lsccrids.add((id)q.get('CCR__c'));
							}
						}
						else
						{
							for (AggregateResult q : [select CCR__c, count(id) from CCRSiteAssociation__c
                                 where sitenoc__r.product__r.name like :productsearch
                                    or sitenoc__r.AlternateSiteNames__c like :siteAltNamesearch
                                 group by CCR__c]) {
								lsccrids.add((id)q.get('CCR__c'));
							}
						}
					}
					else
					{
						if (siteAltName.equals(''))
						{
							for (AggregateResult q : [select CCR__c, count(id) from CCRSiteAssociation__c
                                 where sitenoc__r.product__r.name like :productsearch
                                    or sitenoc__r.name like :sitesearch
                                 group by CCR__c]) {
								lsccrids.add((id)q.get('CCR__c'));
							}
						}
						else
						{
							for (AggregateResult q : [select CCR__c, count(id) from CCRSiteAssociation__c
                                 where sitenoc__r.product__r.name like :productsearch
                                    or sitenoc__r.name like :sitesearch
                                    or sitenoc__r.AlternateSiteNames__c like :siteAltNamesearch
                                 group by CCR__c]) {
								lsccrids.add((id)q.get('CCR__c'));
							}
						}
					}
				} 
			}
		
			if (!lsccrids.equals(''))
				soql += ' and id in :lsccrids ';
			else
				// Find nothing
				soql += ' and id = \'111111111111111\' ';
    	} 
    
    	// run the query again    
system.debug('*** soql: ' + soql);
    	runQuery();
       
    	return null;
	}
  
	public List<CCR__c> getCCRs() {
         return (List<CCR__c>) setCon.getRecords();
	}
}