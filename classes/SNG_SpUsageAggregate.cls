/**
 * This class is responsible for doing the call to UsageService for a list of ModemServicePlan__c records
 */
public with sharing class SNG_SpUsageAggregate extends SNG_UsageAggregate {
	
	/**
	 * The Service Plans to update usage for
	 */
	private ServicePlan__c[] servicePlans;
	
	/**
	 * The Modem / Service Plans to update usage for
	 */
	private ModemServicePlan__c[] msps;
	
	/**
	 * Flag to indicate whether caching the cookie is allowed for the HTTP request.
	 */
	private boolean allowCookieCaching;
	
	/**
     * This constructor is used to create an instance of the object.
     *
     * @param   servicePlans    List of Service Plans to update usage for
     * @param   msps            List of Modem / Service Plans to update usage for
     * @param   startDate       The start date to use in the request to UsageService
     * @param   endDate         The end date to use in the request to UsageService
     */
	public SNG_SpUsageAggregate(ServicePlan__c[] servicePlans, ModemServicePlan__c[] msps, Date startDate, Date endDate, boolean allowCookieCaching) {
		super(startDate, endDate);
		this.servicePlans = servicePlans;
		this.msps = msps;
		this.allowCookieCaching = allowCookieCaching;
	}
	
	/**
	 * Requests usage from UsageService between startDate and endDate for the msps list
	 *
	 * @throws SNG_Exception   If any error occurs in getting usage or updating totals
	 */
	public override void process() {
		try {
			SNG_UsageService.Response usageResponse = getUsageLatest(msps, allowCookieCaching);
			SNG_SpUsageAggregateUpdater.process(servicePlans, msps, usageResponse);
		} catch (Exception e) {
			System.debug(LoggingLevel.ERROR, 'Caught Exception ' + e.getMessage() + ' thrown at ' + e.getStackTraceString());
			SNG_SpUsageAggregateUpdater.processException(servicePlans, msps);
			throw new SNG_Exception(SNG_HtmlUtilities.getHtmlMessageCenteredBoldRedFontFormat(e.getMessage()));
		}
	}
	
}