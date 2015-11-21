/**
 * Custom controlller for custom Visualforce page SNGServicePlanTab.page
 */
global with sharing class SNGServicePlanTab {

	// List of Service Plans
	public List<ServicePlan__c> servicePlans { get; set; }

	// List of Service Plans that will displayed in visualforce table - 10 at a time
	public List<ServicePlan__c> displayServicePlans { get { return paging.displaySObjects; } set; }

	// True if user is admin
    public boolean userAdmin { get { return SNGVisualforceRender.userAdmin; } }

	// boolean to determine if next command link in service plan table should be displayed
	public boolean isNextValid { get { return paging.isNextValid; } }
    // boolean to determine if prev command link in service plan table should be displayed
    public boolean isPrevValid { get { return paging.isPrevValid; } }
    // information regarding the record
    public String recordInfo { get { return paging.recordInfo; } }

	// The page of Service Plans that is being displayed to the user
	public integer pageNumber { get; set; }
	// The current page that is displayed to user string format
	public String pageNumberStr { get { return paging.pageNumberStr; } set { paging.pageNumberStr = value; } }
	// The total amount of pages
	public integer totalPages { get { return paging.totalPages; } }

	public integer noop { get; set; }

	// For sorting
	public String sortExpression { get { return sorting.sortExpression; } set { sorting.sortExpression = value; } }

	// List of partially active and fully active Modem Service Plans
	public List<ModemServicePlan__c> msps { get; set; }

	@TestVisible
	private SNGTabPaging paging;
	private SNGTabColumnSort sorting;

	private static final transient String BASIC_QUERY = 'SELECT Id, Name, Account__r.Name, Status__c, StartDate__c, ServicePlanType__c, ServicePlanType__r.Id, ServicePlanType__r.Name, EndDate__c, SalesOrder__c, Industry__c, GbDownloaded__c, GbTotal__c, GbUploaded__c FROM ServicePlan__c';

	/**
	 * Controller constructor
	 */
	public SNGServicePlanTab() {
		
		displayServicePlans = new List<ServicePlan__c>();
        servicePlans =  Database.query(BASIC_QUERY);
		
		// get partially active or fully active MSPs
		msps = getRelatedMsps();
        msps = (null != msps) ? msps : new List<ModemServicePlan__c>();

		// initialize paging in Service Plan Tab
		paging = new SNGTabPaging(servicePlans);

		// initialize sorting in Service Plan Tab
		sorting = new SNGTabColumnSort(BASIC_QUERY);
	}

	/**
	 * Calls updateDisplay on the paging object.
	 * Called from visualforce page when updateUsageData() is complete
	 */
	public void updateDisplay() {
		// Update paging object with List of updated service plans
		paging.updateDisplay(servicePlans);
	}

	/**
	 * Updates the Modem/Service Plan's usage fields
	 * Called from visualforce page SNGServicePlanTab
	 */
	public void updateUsageData() {
		SNG_ServicePlan.updateUsageData(servicePlans, msps);
	}

    public void goToPage() {
    	paging.goToPage();
    }

    public void getPrevPage() {
    	paging.getPrevPage();
    }

    public void getNextPage() {
    	paging.getNextPage();
    }

    public void getFirstPage() {
        paging.getFirstPage();
    }

    public void getLastPage() {
        paging.getLastPage();
    }

    public String getSortDirection() {
    	return sorting.getSortDirection();
    }

    public void setSortDirection(String value) {
    	sorting.setSortDirection(value);
    }

    public PageReference ViewData() {
    	servicePlans = sorting.ViewData();
    	paging.updateDisplay(servicePlans);
    	return null;
    }

	/**
	 * Retrieves a list of Modem Service Plans from a list of Service Plans
	 *
	 * @param		servicePlans	List of Service Plans
	 * @return						List of active Modem Service Plans
	 */
	private List<ModemServicePlan__c> getRelatedMsps () {

		// List of all (active and partially active) Modem Service Plans
		List<ModemServicePlan__c> relatedMsps;
		
		relatedMsps = [SELECT Name, Id, Status__c, ServicePlan__c, StartDate__c, EndDate__c, GbTotal__c, GbDownloaded__c, GbUploaded__c,
						Modem__r.Id, Modem__r.Name, Modem__r.SerialNumber__c, Modem__r.Terminal__c, Modem__r.Terminal__r.Name,
						Modem__r.Terminal__r.GbDownloaded__c, Modem__r.Terminal__r.GbUploaded__c, Modem__r.Terminal__r.GbTotal__c,
						ServicePlan__r.Name, ServicePlan__r.GbDownloaded__c, ServicePlan__r.GbUploaded__c, ServicePlan__r.GbTotal__c
						FROM ModemServicePlan__c
						WHERE
							(Status__c = 'Active' OR (StartDate__c >= :System.today().toStartOfMonth() AND StartDate__c <= :System.today()) OR
							(EndDate__c <= :System.today() AND EndDate__c >= :System.today().toStartOfMonth()))];
		
		return relatedMsps;
	}

}