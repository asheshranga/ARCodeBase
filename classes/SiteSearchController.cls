/*********************************************************************************
Name :   SiteSearchController 
Usage :  Controller on Viasite VF page.
*********************************************************************************/
public with sharing class SiteSearchController
{
	public string profileName{get;set;}
	
	public boolean selectRecordType 
	{
    	get
    	{
        	if (profileName == null)
            	profileName = [Select Id, Name, usertype from Profile where Id=:userinfo.getProfileId()].Name;
        	return (profileName != 'ViaSat NOC Customer Portal');
    	}
	} 

	//fetch the siteId field ID from custom label
	Public String siteId{ 
		get { return System.label.NOC_SiteId;  }
		set; 
	}
	
    private String soql {get;set;}
    
    public String rType {get; set;}
    
    // use apex describe to build the picklist values
    public List<String> types {
        get{
            if (types == null)
            {
                types = new List<String>();
                Schema.DescribeFieldResult field = site__c.CurrencyIsoCode.getDescribe();

                for (Schema.PicklistEntry f : field.getPicklistValues())
                    if (f.isActive())
                        types.add(f.getLabel());
            }
            return types;
        }
        set;
    }
    
    // the collection of contacts to display
    public List<Site__c> sites {get{ return (List<Site__c>) setCon.getRecords();}set;}
    
    // the current sort direction. defaults to asc
    public String sortDir {
        get  { if (sortDir == null) {  sortDir = 'asc'; } return sortDir;  }
        set;
    }
 
    // the current field to sort by. defaults to last name
    public String sortField {
        get  { if (sortField == null) {sortField = 'name '; } return sortField;  }
        set;
    }
    
    public String soqlLimit {
        get  { if (soqlLimit == null) {soqlLimit = 'Limit 1000 '; } return soqlLimit;  }
        set;
    }    
 
    // format the soql for display on the visualforce page
    public String debugSoql {
        get { return soql + ' order by ' + sortField + ' ' + sortDir + ' limit 20'; }
        set;
    }
 
    // init the controller and display some sample data when the page loads
   	// No records shall appear when the user first clicks onto the page/tab
    public SiteSearchController() 
    {
		if(ApexPages.currentPage().getParameters().get('RecordType')!=Null)
			rType = ApexPages.currentPage().getParameters().get('RecordType');    
    }
  
	// ************************************************************************************************************************************
    // ApexPages.StandardSetController must be instantiated for standard list controllers     
    public ApexPages.StandardSetController setCon 
    {
        get 
        {
            if(setCon == null) 
            {
				if (soql != null)
                	setCon = new ApexPages.StandardSetController(Database.getQueryLocator(soql + ' order by ' + sortField + ' ' + sortDir + ' ' + soqlLimit ));
				else
					setCon = new ApexPages.StandardSetController(new list<Site__c>());
            }
            return setCon;
        }
        set;
    }

    // Initialize setCon and return a list of records     
    public List<Site__c> getSites() {
        return (List<Site__c>) setCon.getRecords();
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

    // toggles the sorting of query from asc<-->desc
    public void toggleSort() {
        sortDir = sortDir.equals('asc') ? 'desc' : 'asc';
        runQuery();
    }
      
	// ************************************************************************************************************************************
    // Support the search with parameters passed via Javascript
	// ************************************************************************************************************************************
    // the soql without the order and limit
	public final string SOQLSiteSearchSelect = 'SELECT recordtypeid, id, name, Flag__c, SiteName__c, Status__c, TailNumber__c, make__c, model__c' +
		', account__r.id, account__r.name, product__r.id, product__r.name, creationdate__c, AlternateSiteNames__c' +
        ', SatelliteIP__c, IPAddress__c, TerminalIPAddress__c, FilterIPAddress__c, StaticPublicIP__c, Serial__c '+
        ', CISCOMACAddress__c, PrimaryPhysicalCircuitID__c, PrimaryLogicalCircuitID2__c, PrimaryLogicalCircuitID1__c, DLLPhysicalCircuitID__c, DLLLogicalCircuitID2__c, DLLLogicalCircuitID1__c' +
        ' FROM site__c WHERE name != null '; 

    // runs the actual query
    public void runQuery() 
    {
        try{
            setCon = new ApexPages.StandardSetController(Database.getQueryLocator(soql + ' order by ' + sortField + ' ' + sortDir + ' ' + soqlLimit ));
            system.debug('Listtt////'+setCon);
        } 
        catch (Exception e) {
             ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Ooops! ' + e.getMessage() + ' SQL - ' + soql + ' order by ' + sortField + ' ' + sortDir + ' ' + soqlLimit ));            
        }
    }
  
    public PageReference runSearch()
    {
       	soql = SOQLSiteSearchSelect;  

        String searchKey        = Apexpages.currentPage().getParameters().get('search');
		if (searchKey != null && !searchKey.equals('')) 
        {
            searchKey=searchKey.trim();
            String lssearch  = '\'%'+String.escapeSingleQuotes(searchKey)+'%\'' ;
            String lssearch1 = '%'+String.escapeSingleQuotes(searchKey)+'%' ;
            String lssiteids = '';                                   
         /*   for (site__c a : [select id, name
                                    from site__c
                                    where Serial__c like :lssearch1
                                    or tailnumber__c like :lssearch1
                                    or make__c like :lssearch1
                                    or model__c like :lssearch1                            
                                    or satelliteip__c like :lssearch1 ]) {
                lssiteids += ',\'' + a.name+ '\'';                                  
            }  
          
           if (!lssiteids.equals(''))
                lssiteids = ' or id in (' + lssiteids.substring(1) + ')'; */
                
            Schema.DescribeSObjectResult Record_typeName = Site__c.SObjectType.getDescribe();    
            Map<String,Schema.RecordTypeInfo> rtMapByName = Record_typeName.getRecordTypeInfosByName();
            SET<String> Setof_Rtype = rtMapByName.keyset();        
                

            soql += ' and (AlternateSiteNames__c like ' + lssearch + ' or ' +
                  '      name like ' + lssearch + ' or ' +
                  '      sitename__c like ' + lssearch + ' or ' +
                  '      Serial__c like ' + lssearch + ' or ' +
                  '      tailnumber__c like ' + lssearch + ' or ' +
                  '      make__c like ' + lssearch + ' or ' +
                  '      model__c like ' + lssearch + ' or ' +
                  '      satelliteip__c like ' + lssearch + ' or ' +   
                  '      Recordtype.Name like ' + lssearch + ' or ' +              
                  '      product__r.name like ' + lssearch + ' or ' +
                  '      account__r.name like ' + lssearch + lssiteids + ')';
        }
		else
		{			
        	String name          = Apexpages.currentPage().getParameters().get('name');
        	String product       = Apexpages.currentPage().getParameters().get('product');
        	String account       = Apexpages.currentPage().getParameters().get('account');
        	String alternatename = Apexpages.currentPage().getParameters().get('alertnatename');

			// Ability to search by the following fields in the Site Search (using the ‘Search’ box) and display these columns in the Search Results:
			//Satellite IP, IP Address (SatelliteIP__c, IPAddress__c)
        	String satelliteIP	= Apexpages.currentPage().getParameters().get('satelliteip');
        	String ipAddress	= Apexpages.currentPage().getParameters().get('ipaddress');
        system.debug('*** name, satelliteIP, ipAddress: '+name+satelliteIP+ipAddress);          

        	//CISCO MAC Address (CISCOMACAddress__c)
        	String ciscoMACAddress	= Apexpages.currentPage().getParameters().get('ciscomacaddress');
		
			//Primary Physical Circuit ID, Primary Logical Circuit ID1, Primary Logical Circuit ID2 (PrimaryPhysicalCircuitID__c, PrimaryLogicalCircuitID2__c, PrimaryLogicalCircuitID1__c)
        	String primaryPhysicalCircuitID	= Apexpages.currentPage().getParameters().get('primaryphysicalcircuitid');
        	String primaryLogicalCircuitID2	= Apexpages.currentPage().getParameters().get('primarylogicalcircuitid2');
        	String primaryLogicalCircuitID1	= Apexpages.currentPage().getParameters().get('primarylogicalcircuitid1');

			//DLL Physical Circuit ID (DLLPhysicalCircuitID__c)
			//DLL Logical Circuit ID1, DLL Logical Circuit ID2 (DLLLogicalCircuitID2__c, DLLLogicalCircuitID1__c)
        	String dllPhysicalCircuitID	= Apexpages.currentPage().getParameters().get('dllphysicalcircuitid');
        	String dllLogicalCircuitID2	= Apexpages.currentPage().getParameters().get('dlllogicalcircuitid2');
        	String dllLogicalCircuitID1	= Apexpages.currentPage().getParameters().get('dlllogicalcircuitid1');

        	if (!String.isEmpty(name))
				soql += ' and sitename__c like \'%'+String.escapeSingleQuotes(name.trim())+'%\'';  
        	if (!String.isEmpty(product))
				soql += ' and product__r.name like \'%'+String.escapeSingleQuotes(product.trim())+'%\''; 
        	if (!String.isEmpty(account))  
				soql += ' and account__r.name like \'%'+String.escapeSingleQuotes(account.trim())+'%\''; 
        	if (!String.isEmpty(alternatename))
				soql += ' and AlternateSiteNames__c like \'%'+String.escapeSingleQuotes(alternatename.trim())+'%\'';   			

        	if (!String.isEmpty(satelliteIP))
				soql += ' and satelliteIP__c like \'%'+String.escapeSingleQuotes(satelliteIP.trim())+'%\'';   			
        	if (!String.isEmpty(ipAddress))
				soql += ' and ipAddress__c like \'%'+String.escapeSingleQuotes(ipAddress.trim())+'%\'';   			
        	if (!String.isEmpty(ciscoMACAddress))
				soql += ' and ciscoMACAddress__c like \'%'+String.escapeSingleQuotes(ciscoMACAddress.trim())+'%\'';   			
        	if (!String.isEmpty(primaryPhysicalCircuitID))
				soql += ' and primaryPhysicalCircuitID__c like \'%'+String.escapeSingleQuotes(primaryPhysicalCircuitID.trim())+'%\'';   			
        	if (!String.isEmpty(primaryLogicalCircuitID2))
				soql += ' and primaryLogicalCircuitID2__c like \'%'+String.escapeSingleQuotes(primaryLogicalCircuitID2.trim())+'%\'';   			
        	if (!String.isEmpty(primaryLogicalCircuitID1))
				soql += ' and primaryLogicalCircuitID1__c like \'%'+String.escapeSingleQuotes(primaryLogicalCircuitID1.trim())+'%\'';   			
        	if (!String.isEmpty(dllPhysicalCircuitID))
				soql += ' and dllPhysicalCircuitID__c like \'%'+String.escapeSingleQuotes(dllPhysicalCircuitID.trim())+'%\'';   			
        	if (!String.isEmpty(dllLogicalCircuitID2))
				soql += ' and dllLogicalCircuitID2__c like \'%'+String.escapeSingleQuotes(dllLogicalCircuitID2.trim())+'%\'';   			
        	if (!String.isEmpty(dllLogicalCircuitID1))
				soql += ' and dllLogicalCircuitID1__c like \'%'+String.escapeSingleQuotes(dllLogicalCircuitID1.trim())+'%\'';   			
		}     
        // run the query again
        system.debug('*** soql: '+soql);          
        runQuery();
        return null;
    }
}