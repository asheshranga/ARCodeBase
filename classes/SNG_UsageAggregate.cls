/**
 * This abstract class is used to help calculate the usage data for either the Service Plan tab or
 * Terminal tab
 */
public abstract with sharing class SNG_UsageAggregate {
	
	/**
	 * The start date for the usage data requested.
	 */
	protected DateTime startDate;
	
	/**
	 * The end date for the usage data requested.
	 */
    protected DateTime endDate;
	
	/**
	 * Creates an instance of this object.
	 *
	 * @param    startDate           The start date for the usage data requested.
	 * @param    endDate             The end date for the usage data requested.
	 */
	protected SNG_UsageAggregate(Date startDate, Date endDate) {
        this.startDate = SNG_DateTimeUtils.toDateTimeGmt(startDate);
        this.endDate = SNG_DateTimeUtils.toDateTimeGmt(endDate);
    }
	
	/**
	 * An abstract method to process the request. This method is to be overriden
	 * by implementors of this class.
	 */
	public abstract void process();
	
	/**
	 * Gets the latest usage data based on the modem service plans.
	 * 
	 * @param   msps          The set of Modem Service Plan(s) to obtain usage data.
	 * @return                The response from Usage Service containing the MAC address and its usage.
	 */
	protected SNG_UsageService.Response getUsageLatest(ModemServicePlan__c[] msps, boolean allowCookieCaching) {
        SNG_ModemUsageDate[] muds = createRequestBody(msps);
        return getUsageResponse(muds, allowCookieCaching);
    }
	
	/**
	 * Creates the request body to sent as part of the HTTP request to Usage Service.
	 *
	 * @param   msps          The set of Modem Service Plan(s) to obtain usage data.
	 * @return                An array of modem MAC addresses and their corresponding usage dates. 
	 */
	private SNG_ModemUsageDate[] createRequestBody(ModemServicePlan__c[] msps) {
		SNG_ModemUsageDate[] muds = (!ArrayUtils.isEmpty(msps)) ? new SNG_ModemUsageDate[msps.size()] :
		                                                          new SNG_ModemUsageDate[]{};
        
        for (Integer i = 0; i < msps.size(); ++i) {
            ModemServicePlan__c msp = msps[i];
            muds[i] = new SNG_ModemUsageDate(msp.Modem__r.Name, getMspStartForRequest(msp),  getMspEndForRequest(msp));
        }
        
        return muds;
	}
	
	/**
	 * Performs the HTTP callout to obtain the response from the Usage Service.
	 *
	 * @param    muds          An array of Modem MAC addresses and their usage dates to query for usage data.
	 * @return                 The response from Usage Service regarding teh usage data.
	 */
	private SNG_UsageService.Response getUsageResponse(SNG_ModemUsageDate[] muds, boolean allowCookieCaching) {
		HttpResponse response = SNG_ModemUsageDataHttpCallout.post(muds, SNG_ModemUsageDataHttpCallout.Grain.MONTH, null, null, 30000, allowCookieCaching);
		return processResponse(response);
	}
	
	/**
     * Processes the response from UsageService
     * 
     * @param   detail        Response status details
     * @param   response      The response from UsageService
     * @return                The response to be sent back to the client
     */
    @TestVisible 
    private SNG_UsageService.Response processResponse(final HttpResponse httpResponse) { 
    	SNG_ExceptionUtil.assert(SNGHttpUtilities.isStatusCodeOK(httpResponse.getStatusCode()), 
    	                         'HTTP Status Code ' + httpResponse.getStatusCode() + ' returned. ' + httpResponse.getStatus());
        return parseResponseBody(httpResponse.getBody());
    }
    
    /**
     * Parses the response body response from Usage Service by converting into a POJO object
     * representing the JSON response. The POJO object allows easier readability and usage of the data.
     *
     * @param    response          The JSON response from Usage Services.
     * @return                     The POJO object representation of the JSON response.
     * @throws                     An exception if deserialization fails.
     */
    private SNG_UsageService.Response parseResponseBody(final String response) {
        return SNG_UsageService.deserialize(response);
                //(SNG_UsageService.Response)JSON.deserialize(response, SNG_UsageService.Response.class);
    }
    
    /**
     * Retrieves the msp start date for the request for a particular Modem/Service Plan.
     *
     * @param    msp               The Modem/Service Plan object.
     */
    private DateTime getMspStartForRequest(final ModemServicePlan__c msp) {
    	return SNG_DateTimeUtils.max(startDate, SNG_DateTimeUtils.toDateTimeGmt(msp.StartDate__c));
    }
    
    /**
     * Retrieves the msp end date for the request for a particular Modem/Service Plan.
     *
     * @param    msp               The Modem/Service Plan object.
     */
    private DateTime getMspEndForRequest(final ModemServicePlan__c msp) {
    	return SNG_DateTimeUtils.min(endDate, SNG_DateTimeUtils.toDateTimeGmt(msp.EndDate__c).addDays(1));
    }
	
}