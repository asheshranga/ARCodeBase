/*****************************************************************
Name          : ServiceRequestController
Created By    : M.Basovich
Company Name  : ViaSat
Project       : ATRF Project
Created Date  : January 2015
Modified Date : https://viasat--devsup.cs12.my.salesforce.com/a1eV0000000I7iz 
******************************************************************/
public with sharing class ServiceRequestController 
{
	//*************************************************
	// Record Types of Service Request:
	//*************************************************
	public static final string SERVICEREQUEST_TERMINAL_RecType = 'Terminal';
	public static final string SERVICEREQUEST_HUB_RecType = 'Hub';
    public static final string SERVICEREQUEST_MPLS_RecType = 'MPLS';
	
	//*************************************************
	// Private Settings for the Service Request Site assignments:
	//*************************************************
	private final string[] siteTypeofServiceForHub = new string[]{'VGN','MPS','VIPSAM'}; 
	Set<String> siteTypeofServiceForHubSET = new Set<String>((list<String>)siteTypeofServiceForHub);

	private final string[] serviceRequestChangableStatuses = new string[]{'New', 'Rejected', 'Change Requested'}; 
	Set<String> serviceRequestChangableStatusesSET = new Set<String>((list<String>)serviceRequestChangableStatuses);

	// Current Service_Request__c
	private Service_Request__c obj; 
	
	// MAP of All ServiceRequestSites for the Current Service_Request__c by RecordType
	private static map<string, List<ServiceRequestSite__c>> sitesRelatedListMap;
	
	// All Site__c objects of specific RecordType in the system 
	private static list<Site__c> sitesOfProvisionRecordType; // Hubs
	
	// All servicerequest__c record types: <name,id>
	public static map<string, Id> serviceReqRecTypes{
		get{
			if (serviceReqRecTypes == null)	
				serviceReqRecTypes = ViasatUtilityClass.getAvailableRecordTypes(ServiceRequestSite__c.SObjectType);
			return serviceReqRecTypes;
		}
		set;}
    public boolean allowUpdate {get{return serviceRequestChangableStatusesSET.contains(this.obj.Status__c);}}	
    public static string errorMessage {get;set;}	
	public Boolean editMode {get;set;}
		
	//*************************************************
	// Lists to be used on the embedded VF page used for the Service Request Site assignments:
	//*************************************************
	public map<string, List<ServiceRequestSite__c>> sitesCustomRelatedListMap {get; set;} 	
	public map<string, List<ServiceRequestSite__c>> sitesToProvisionListMap {get; set;} 
	
	public List<ServiceRequestSite__c> customRelatedList3 {get{return sitesToProvisionListMap.get(customRelatedListDesc3);} set{List<ServiceRequestSite__c> lst = sitesToProvisionListMap.get(customRelatedListDesc3); lst = customRelatedList3;}} 
	public string customRelatedListDesc3 {get{return siteTypeofServiceForHub[0];} set;} 
	public List<ServiceRequestSite__c> customRelatedList4 {get{return sitesToProvisionListMap.get(customRelatedListDesc4);} set{List<ServiceRequestSite__c> lst = sitesToProvisionListMap.get(customRelatedListDesc4); lst = customRelatedList4;}} 
	public string customRelatedListDesc4 {get{return siteTypeofServiceForHub[1];} set;} 
	public List<ServiceRequestSite__c> customRelatedList5 {get{return sitesToProvisionListMap.get(customRelatedListDesc5);} set{List<ServiceRequestSite__c> lst = sitesToProvisionListMap.get(customRelatedListDesc5); lst = customRelatedList5;}} 
	public string customRelatedListDesc5 {get{return siteTypeofServiceForHub[2];} set;} 
	
	public ServiceRequestController(ApexPages.StandardController controller) 
	{
		// FOR SOME REASON controller.getRecord() does not get Name field - will need it for Creating a new Terminal
		//this.obj = (Service_Request__c)controller.getRecord();
		//this.obj = [SELECT Id, name, UserRecordAccess.HasEditAccess FROM Service_Request__c WHERE Id = :controller.getId()];
		this.obj = [SELECT Id, name, Status__c FROM Service_Request__c WHERE Id = :controller.getId()];
		init();
	}
	
	private void init()
	{
		errorMessage = null;		
		editMode = false;
				
		// Create sitesRelatedListMap MAP of all sites linked to the current Service_Request__c object by RecordTypeName 
		setSitesRelatedListMap();
		system.debug('***sitesRelatedListMap: ' + sitesRelatedListMap);

		// Create sitesCustomRelatedListMap MAP of sites of specified RecordTypeName linked to the current Service_Request__c object
		// to DISPLAY in the Custom Related List - for now it is only TERMINALs
		setSitesCustomRelatedListMap(new string[]{SERVICEREQUEST_TERMINAL_RecType});
		system.debug('***sitesCustomRelatedListMap: ' + sitesCustomRelatedListMap);
		
		// Build sitesToProvisionListMap: ServiceRequestSite__c List to PROVISION - HUB record type
		buildServiceRequestsitesToProvisionListMap(SERVICEREQUEST_HUB_RecType);
	}
    
    public List<ServiceRequestSite__c> getMPLSSites()
    {
        List<ServiceRequestSite__c> mplsSites = new List<ServiceRequestSite__c>();
        
        if(sitesRelatedListMap != null)
        if(sitesRelatedListMap.containsKey(SERVICEREQUEST_MPLS_RecType))
        mplsSites = sitesRelatedListMap.get(SERVICEREQUEST_MPLS_RecType);
        
        return mplsSites;
    }

	//*************************************************
	// ACTION Methods Used in ServiceRequestSites.page
	//*************************************************
	public PageReference createNew() 
	{		
		PageReference newPage = Page.ServiceReqTerminalSelect;		
		newPage.getParameters().put('id',obj.Id);  
		return newPage; 
	}

	public PageReference updateServiceRequestSite()
	{
		errorMessage = null;		
        Schema.DescribeSObjectResult dsr = ServiceRequestSite__c.getSObjectType().getDescribe();
        String keyPrefix = dsr.getKeyPrefix();
		
		String srSiteId= ApexPages.currentPage().getParameters().get('srSiteId'); 
		
		PageReference newPage =  new PageReference('/' + keyPrefix + '/e?id=' + srSiteId + '&retURL=/' + obj.Id);

		init();		
        System.debug('************** newPage : ' + newPage);
        return null;
		//return newPage.setRedirect(true); // preserves the view state
	}
	
	public PageReference deleteServiceRequestSite()
	{
		String srSiteId= ApexPages.currentPage().getParameters().get('srSiteId'); 
		ServiceRequestSite__c srSite = [Select id from ServiceRequestSite__c where id =:srSiteId limit 1];
		if (srSite != null)
			delete srSite;
		
		init();		
		return null;
	}	
	
	//*************************************************
	// ACTION Methods Used in ServiceRequestProvision.page
	//*************************************************
	public PageReference saveProvisioning()
	{
		if (editMode)
		{
		List<ServiceRequestSite__c> associationsToUpsert = new List<ServiceRequestSite__c>();  
		List<ServiceRequestSite__c> associationsToDelete = new List<ServiceRequestSite__c>();  
		for (List<ServiceRequestSite__c> lst : sitesToProvisionListMap.values()) 
		{
			for (ServiceRequestSite__c srs : lst)
			{
				if (srs.ServiceSite__r.isProvisioned__c)
				{
					if (srs.ServiceRequest__c == null)
						srs.ServiceRequest__c = obj.Id;
					associationsToUpsert.add(srs);
				}
				else if (srs.ServiceRequest__c != null)
					associationsToDelete.add(srs);					
			}
		}
		try
		{
			if(associationsToDelete.size() > 0)	delete associationsToDelete;
			if(associationsToUpsert.size() > 0)	upsert associationsToUpsert;

			init();
		} 
		catch (Exception e) 
		{
			editMode = true;
			//errorMessage = e.getMessage();		
			//ViasatLogHandler.LogAsync('GENERAL', ViasatLogHandler.SeverityTypeEXCEPTION, 'saveProvisioning', e.getMessage(), e.getStackTraceString());//, UserInfo.getSessionId(), UserInfo.getUserId(), responseObj.status.httpcode);
		}
		}
		return null;
	}	

	public PageReference cancelProvisioning()
	{
		if (editMode)
			init();
		return null; 
	}

    public PageReference editProvisioning()
    {
		errorMessage = null;		
    	editMode = true;
    	return null;
    }

	//*************************************************
	// Private Methods used in ServiceRequestController.....
	//*************************************************		
	
	// Create a MAP of all sites linked to the current Service_Request__c object by RecordTypeName
	private void setSitesRelatedListMap()
	{
		sitesRelatedListMap = new map<string, List<ServiceRequestSite__c>>();
		list<ServiceRequestSite__c> srlst = getServiceRequestSites(obj.Id);
		if (srlst != null)
		{
			for (ServiceRequestSite__c srs : srlst)				                                         
			{			
				List<ServiceRequestSite__c> lst = sitesRelatedListMap.get(srs.RecordType.Name);
				if (lst != null)
					lst.add(srs);
				else
					sitesRelatedListMap.put(srs.RecordType.Name, new List<ServiceRequestSite__c>{srs});
			}
		}
	}

	// Create a MAP (sitesCustomRelatedListMap) of sites of specified rec types that are linked to the current Service_Request__c object
	// to DISPLAY in the Custom Related List - for now it is only TERMINALs
	private void setSitesCustomRelatedListMap(string[] siteRecTypes)
	{
		sitesCustomRelatedListMap = new map<string, List<ServiceRequestSite__c>>();
		for (string recType : siteRecTypes)
		{
			List<ServiceRequestSite__c> lst = sitesRelatedListMap.get(recType);
			if (lst == null)
				lst = new List<ServiceRequestSite__c>();
			sitesCustomRelatedListMap.put(recType, lst);
		}
	}
			
	// Create a MAP of all Hubs (linked & not linked to the current Service_Request__c)
	private void buildServiceRequestsitesToProvisionListMap(string provisionRecordType) 
	{
		// Initialize a map of HUB sites
		sitesToProvisionListMap = new map<string, List<ServiceRequestSite__c>>();
		if (siteTypeofServiceForHubSET.size() > 0)
		for (string s : siteTypeofServiceForHubSET)
		{
			sitesToProvisionListMap.put(s, new List<ServiceRequestSite__c>());
		}
		system.debug('***sitesToProvisionListMap: ' + sitesToProvisionListMap);

		// Get a list of all sites Of Provision RecordTypes (all HUBs).
		if (sitesOfProvisionRecordType == null)
			sitesOfProvisionRecordType = getSitesByRecordType(provisionRecordType); //and TypeofService__c in :siteTypeofServiceForHub];
		system.debug('***sitesOfProvisionRecordType: ' + sitesOfProvisionRecordType);

		// Create a MAP of Site__c.Id & ServiceRequestSite__c that are on the current Service_Request__c
		map<id,ServiceRequestSite__c> siteIds = new map<id,ServiceRequestSite__c>();
		List<ServiceRequestSite__c> srlst = sitesRelatedListMap.get(provisionRecordType);
		if (srlst != null && srlst.size() > 0)
		{
			for (ServiceRequestSite__c srs : srlst)				                                         
			{			
				srs.ServiceSite__r.isProvisioned__c = true;
				siteIds.put(srs.ServiceSite__c, srs);
			}
		}
		
		// Create a list of ServiceRequestSite__c for Add sites Of Provision RecordType (all HUBs).
		// Site__c.isProvisioned__c is a temp field used only here that indicates whether Site is linked/selected to/for the currect Service_request__c
		if (sitesOfProvisionRecordType != null)
		{		
			for (Site__c s : sitesOfProvisionRecordType)
			{
			  if (siteTypeofServiceForHubSET.contains(s.TypeofService__c))
			  {
			  	ServiceRequestSite__c srs = siteIds.get(s.id);
			  	if (srs == null)
				{	
					s.isProvisioned__c = false;
					srs = new ServiceRequestSite__c();
					srs.ServiceSite__c = s.Id;
					srs.ServiceSite__r = s;						
					srs.PriorityAccess__c = false;
					srs.ServiceRequest__c = null;
				}
				
				
				List<ServiceRequestSite__c> lst = sitesToProvisionListMap.get(srs.ServiceSite__r.TypeofService__c);
				if (lst != null)
					lst.add(srs);
			  }
			}
		}
	}
	
	// Get all sites (Terminals & Hubs) that are already linked to the specified Service_Request__c	
	private static list<ServiceRequestSite__c> getServiceRequestSites(Id serviceRequestObjId) 
	{
		try{
        //9/1/15: Modified the query to add Antenna Type
        //9/16/15: Modified the query to add Arclight 1 CRL field
		return [SELECT Id, ServiceRequest__c, SiteName__c, SatelliteIP__c, Program__c, Product__c, Name, Account__c, RecordType.Name, PriorityAccess__c, Satellite__c
		             , ServiceSite__c, ServiceSite__r.Id, ServiceSite__r.ArcLight_1_CRL__c, ServiceSite__r.AntennaType__c, ServiceSite__r.AlternateSiteNames__c, ServiceSite__r.TypeofService__c, ServiceSite__r.SiteName__c, ServiceSite__r.Name, ServiceSite__r.Satellite__c 
				FROM ServiceRequestSite__c WHERE ServiceRequest__c = :serviceRequestObjId ORDER BY RecordTypeId, ServiceSite__r.TypeofService__c, ServiceSite__r.SiteName__c];
		}
		catch(Exception e){
			return new list<ServiceRequestSite__c>();
		}
	}

	// Get all sites of the specific Record Type		
	private static list<Site__c> getSitesByRecordType(string siteRecordTypeName) 
	{
		return [SELECT id, TypeofService__c, AlternateSiteNames__c, AntennaType__c, ArcLight_1_CRL__c, SiteName__c, Name, RecordType.Name, isProvisioned__c, Satellite__c 
				FROM Site__c WHERE RecordType.Name = :siteRecordTypeName ORDER BY TypeofService__c, SiteName__c];
	}
}