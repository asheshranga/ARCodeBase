/*********************************************************************************
Name :   CCRSiteAssociationController 
Usage :  Controller on CCRSiteAssociation VF page.
*********************************************************************************/
public with sharing class CCRSiteAssociationController
{
	//--- Collection of sites to display
	private Boolean addToCCRFlag = false;
	public List<siteWrapper> siteSearchResults {
		get{
			if (soql == null) {
				siteSearchResults = new List<siteWrapper>();	
			}
			else if (addToCCRFlag==false) {
				siteSearchResults = new List<siteWrapper>();      
				for(Site__c s : (List<Site__c>) setCon.getRecords()){
					siteSearchResults.add(new siteWrapper(s));
				}
      		}  
			return siteSearchResults;        
		}
		set;
	} 

  //--- Flag to toggle select all sites checkbox
  public Boolean checkFlag {get {return (checkFlag == null) ? false:checkFlag;} set;}
  
  //--- CCR to which the selected sites have to be associated
  public CCR__c ccr {get;set;}  
  
  
  //--- SOQL without the order and limit
  @TestVisible
  private String soql {get;set;}
  
 
  //--- Current sort direction, defaults to asc
  public String sortDir {
    get  { if (sortDir == null) {  sortDir = 'asc'; } return sortDir;  }
    set;
  }
 
  //--- Current field to sort, defaults to name
  public String sortField {
    get  {return (sortField == null) ? 'name ':sortField;}
    set;
  }
 
    public String soqlLimit {
        get  { if (soqlLimit == null) {soqlLimit = 'Limit 1000 '; } return soqlLimit;  }
        set;
    }  
    
  //--- Debug soql for display on the visualforce page
  public String debugSoql {
    get { return soql + ' order by ' + sortField + ' ' + sortDir + ' limit 20'; }
    set;
  }
 
	//--- Init the controller and display data when the page loads
	public CCRSiteAssociationController() 
	{
		//--- Get the CCR reference to which the Sites selected should be added
		PageReference pageRef = ApexPages.currentPage();
    
		String ccrNum = (String)pageRef.getParameters().get('ccr');
		ccr = [Select id, name, subject__c, status__c, severity__c, urgency__c from CCR__c where id = :ccrNum];
/*  
		//--- Set the SQL to display all sites by default
		soql = 'select recordtypeid, id, name, SiteName__c, flag__c, status__c, account__r.id, account__r.name, product__r.id, product__r.name, creationdate__c, deactivationdate__c, activationdate__c, AlternateSiteNames__c, ' +
           '       (select name, tailnumber__c, make__c, model__c, satelliteip__c from site__c.Aviation__r) ' +
           '  from site__c ';  
*/          
	}
 
  
  // toggles the sorting of query from asc<-->desc
  public void toggleSort() {
    // simply toggle the direction
    sortDir = sortDir.equals('asc') ? 'desc' : 'asc';    
  }
 
	// ApexPages.StandardSetController must be instantiated for standard list controllers     
	public ApexPages.StandardSetController setCon {
	get {
		if(setCon == null) {
			if (soql != null)
                setCon = new ApexPages.StandardSetController(Database.getQueryLocator(soql + ' order by ' + sortField + ' ' + sortDir + ' ' + soqlLimit));
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
    
    
  //--- runs the actual query
  public void runQuery() {
    try {    
      siteSearchResults = new List<siteWrapper>();
      checkFlag = false;
      
      system.debug('sortField: '+sortField);
      
      setCon = new ApexPages.StandardSetController(Database.getQueryLocator(soql + ' order by ' + sortField + ' ' + sortDir + ' ' + soqlLimit));      
      for(Site__c s : (List<Site__c>) setCon.getRecords()){
    siteSearchResults.add(new siteWrapper(s));
      }
    } catch (Exception e) {
      ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Ooops! ' + e.getMessage() + ' SQL - ' + soql + ' order by ' + sortField + ' ' + sortDir + ' ' + soqlLimit));
    }
  }
  
  
  public PageReference cancelAction(){
    PageReference pg = new PageReference('/' + ccr.id);
    
    return pg;
  }
  
  
  public PageReference addSiteToCCR(){
    addToCCRFlag = true;
    

    List<CCRSiteAssociation__c> associationsToInsert = new List<CCRSiteAssociation__c>();     
    for(siteWrapper sw: siteSearchResults) {
      if(sw.checked) {  
        Site__c siteObj = sw.site;
        
        CCRSiteAssociation__c junction = new CCRSiteAssociation__c();
        junction.CCR__c     = ccr.id;
        junction.SiteNOC__c = siteObj.id;
    
        //---add the junction to the collection of rows to be inserted;
        associationsToInsert.add(junction);     
      }
    }
    
    addToCCRFlag = false;
    
    //--- Now add the records to the database
    try{
      insert associationsToInsert;      
    } catch (Exception e) {
      //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Ooops! ' + e.getMessage()));      
      ApexPages.addMessages(e);      
      return null;  
    }
    
    if(associationsToInsert.size() == 0) {
      ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Please select at least one Site.'));
      return null;
    } else {    
      return (ApexPages.getMessages().size() > 0) ? null: new PageReference('/' + ccr.id);
    }
  }
  
  
  public PageReference toggleCheckedSites(){    
    checkFlag = (Apexpages.currentPage().getParameters().get('selectAll') == 'true') ? true:false;

    for(siteWrapper s : siteSearchResults){
      s.checked = checkFlag;
    }
    
    return null;
  }
 
 
	//--- runs the search with parameters passed via Javascript
	public PageReference runSearch() 
	{
		String name          = Apexpages.currentPage().getParameters().get('name');
		String sitename      = Apexpages.currentPage().getParameters().get('sitename');
		String product       = Apexpages.currentPage().getParameters().get('product');
		String account       = Apexpages.currentPage().getParameters().get('account');
		String search        = Apexpages.currentPage().getParameters().get('search');
		String alternatename = Apexpages.currentPage().getParameters().get('alertnatename');
 
		soql = 'select recordtypeid, id, name, SiteName__c, flag__c, status__c, account__r.id, account__r.name, product__r.id, product__r.name, creationdate__c, deactivationdate__c, activationdate__c, AlternateSiteNames__c, ' +
           '       (select name, tailnumber__c, make__c, model__c, satelliteip__c from site__c.Aviation__r) ' +
           '  from site__c where name != null ';  
		if (name != null && !name.equals(''))
			soql += ' and name like \'%'+String.escapeSingleQuotes(name.trim())+'%\'';    
		if (product != null && !product.equals(''))
			soql += ' and product__r.name like \'%'+String.escapeSingleQuotes(product.trim())+'%\'';    
		if (account != null && !account.equals(''))
			soql += ' and account__r.name like \'%'+String.escapeSingleQuotes(account.trim())+'%\'';    
		if (sitename != null && !sitename.equals(''))      
			soql += ' and SiteName__c like \'%'+String.escapeSingleQuotes(sitename.trim())+'%\''; 
		if (alternatename != null && !alternatename.equals(''))      
			soql += ' and AlternateSiteNames__c like \'%'+String.escapeSingleQuotes(alternatename.trim())+'%\''; 
		if (search != null && !search.equals('')) {      
			String lssearch  = '\'%'+String.escapeSingleQuotes(search)+'%\'' ;      
			String lssearch1 = '%'+String.escapeSingleQuotes(search)+'%' ;      
			String lssiteids = '';            
			for (Aviation__c a : [select site__c
                              from aviation__c
                             where name like :lssearch1
                                or tailnumber__c like :lssearch1
                                or make__c like :lssearch1
                                or model__c like :lssearch1
                                or satelliteip__c like :lssearch1 ]) {         
				lssiteids += ',\'' + a.site__c + '\'';                                        
			}              
        
			if (!lssiteids.equals(''))        
				lssiteids = ' or id in (' + lssiteids.substring(1) + ')';      
			soql += ' and (AlternateSiteNames__c like ' + lssearch + ' or ' +              
			'(name like ' + lssearch + ' or ' +              
              '      product__r.name like ' + lssearch + ' or ' +              
              '      account__r.name like ' + lssearch + lssiteids + '))';   
		}
    
		// run the query again
		runQuery();
 
		return null;
	}
	
  //--- use apex describe to build the picklist values
  public List<String> types {
    get {
      if (types == null) {
        types = new List<String>();
        Schema.DescribeFieldResult field = site__c.CurrencyIsoCode.getDescribe();
 
        for (Schema.PicklistEntry f : field.getPicklistValues())
          if (f.isActive()) types.add(f.getLabel());
      }
      return types;          
    }
    set;
  }   
  
  //--- Inner Class for maintaining checkboxes
  public class siteWrapper {
    public Boolean checked {get; set;}
    public Site__c site {get; set;}
    
    public siteWrapper(){
      site = new Site__c();
      checked = false;
    }
    
    public siteWrapper(Site__c s) {
      site = s;
      checked = false;
    }   
  }   
}