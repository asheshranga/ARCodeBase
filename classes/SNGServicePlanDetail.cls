global with sharing class SNGServicePlanDetail {
	
	/** 
	 * Service plan record
	 */
	public ServicePlan__c servicePlan { get; set; } 
	
	/** 
	 * List of Active or Partially Active modem service plans associated with the Service Plan
	 */ 
	public List<ModemServicePlan__c> relatedModemServicePlans { get; set; }
	
	/** 
	 * List of aggregate usage data to display as a table in visualforce page
	 */
	public List<Integer> aggregateUsageData {get; set;}
	
	// Start of the current month
	private Date startOfMonth; 
	
	// End of the current month
	private Date endOfMonth; 
	
	/** 
	 * Controller constructor
	 */ 
	public SNGServicePlanDetail(ApexPages.StandardController controller) { 
		
		// get the Service Plan record 
		servicePlan = (ServicePlan__c) controller.getRecord();
		
		servicePlan = [SELECT Name, Id, GbDownloaded__c, GbUploaded__c, GbTotal__c FROM ServicePlan__c WHERE Id = :servicePlan.Id];
		
		// initialize aggregateUsageData list
		aggregateUsageData = new List<Integer>(); 
		// Add one element to aggregateUsageData so we can display one row in the Usage Data table 
		aggregateUsageData.add(1); 
		
		// get Modem Service Plans that use the Service Plan
		relatedModemServicePlans = getRelatedMsps(); 
		
		// get the dates for the start and end of the current month
		startOfMonth = System.today().toStartOfMonth();
		endOfMonth = startOfMonth.addMonths(1).addDays(-1);  
	}
	
	/** 
	 * Updates corresponding Modem/Service Plan's usage data fields
	 * Service plans will get the usage data information from their corresponding terminals
	 * Called from visualforce page SNGServicePlanDetail
	 */ 
	public void updateUsageData() { 
		
		// Create List of service plan with current Service Plan on record for the visualforce page
		List<ServicePlan__c> servicePlans = new List<ServicePlan__c>();
		servicePlans.add(servicePlan);
		
		// Update usage for the Service Plan and its corresponding Modem/Service Plans
		SNG_ServicePlan.updateUsageData(servicePlans, relatedModemServicePlans);  
	}
	
	/**
	 * get a list of Active and Partially Active Modem Service Plans that are associated with the Service Plan 
	 */
	private List<ModemServicePlan__c> getRelatedMsps () 
	{ 	
		List<ModemServicePlan__c> relatedMsp = [SELECT Name, Id, Status__c, StartDate__c, EndDate__c, GbTotal__c, GbDownloaded__c, GbUploaded__c,
												Modem__r.Id, Modem__r.Name, Modem__r.SerialNumber__c, Modem__r.Terminal__c, Modem__r.Terminal__r.Name,
												ServicePlan__r.Name
												FROM ModemServicePlan__c 
												WHERE ServicePlan__c = :servicePlan.Id AND
												 		 (Status__c = 'Active' OR (StartDate__c >= :System.today().toStartOfMonth() AND StartDate__c <= :System.today()) OR
												 		(EndDate__c <= :System.today() AND EndDate__c >= :System.today().toStartOfMonth()))];                
		return relatedMsp; 
	}
		
}