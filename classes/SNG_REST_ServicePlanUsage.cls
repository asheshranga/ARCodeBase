/**
 * This class is the main handler for Service Plan Usage API. This class performs the main handling of the client request
 * and packages the necessary response back to the client.
 */
public with sharing class SNG_REST_ServicePlanUsage extends SNG_REST_IdWithDateRange
{
	/**
     * The prefix for a valid ServicePlan id. All ServicePlan IDs are of the format: SP-xxx. 
     */
    private static final String SERVICE_PLAN_PREFIX_REGEX = '[Ss][Pp][-]';  
    
    /**
     * Error message used when the usage data cannot be obtained for the requested service plan. This error message
     * is concatenated with the service plan ID.
     */
    @TestVisible
    private static final String USAGE_SERVICE_ERROR = 'Unable to obtain usage data for the requested service plan: ';
    
    /**
     * Error message used when there is an issue with obtaining usage data for at least one MAC address under the requested
     * service plan. Multiple MAC addresses can be assigned to a service plan.
     */
    @TestVisible
    private static final String USAGE_PARTIAL_ERROR = 'Unable to obtain usage data for at least on mac address under the service plan.';
	
	/**
	 * Detailed message informing the client that there are no active modems during the time period requested
	 * to retrieve the service plan. This indicates the service plan is valid, just no associated active Modem / Service Plans.
	 */
	@TestVisible
	private static final String NO_ACTIVE_MODEMS = 'No active modems on the service plan during this period.';
	
	/**
	 * Creates an instance of this object.
	 * 
	 * @param    restReq           The REST request information. This information is created through the client RESTful API request.
     * @throws   SNG_Exception     If expected parameters are not found or too many wildcards are encountered.
	 */
	public SNG_REST_ServicePlanUsage(final RestRequest restReq)
	{
		super(restReq, null);
	}

    /**
     * Creates an instance of this object. This constructor can be used if the information is not wrapped within a RestRequest
     * object and the user explicitly requests to pass the information in.
     *
     * @param    servicePlanId     The service plan ID. 
     * @param    startDate         The start date for the usage period requested.
     * @param    endDate           The end date for the usage data period requested.
     */
	public SNG_REST_ServicePlanUsage(final String servicePlanId, final String startDate, final String endDate)
	{
		super(servicePlanId, startDate, endDate, null);
	}
	
    /**
     * Process the request from the client. This is a method that overrides the abstract method defined
     * in the SNG_REST_IdWithDateRange. This method is responsible for taking the extracted data 
     * (which is stored as a field in the parent class) and obtaining the usage for the data.
     *
     * The member variables are as follows:
     * id : the mac address
     * startDate : the start date for the usage data request
     * endDate : the end date for the usage request.
     *
     * @param   detail   The current status to be relayed to the client.
     * @return           The JSON Response usage data for the Modem 
     */ 
	private SNG_REST_IJsonResponseData processRequest(SNG_REST_StatusDetail detail)
    {
         List<ModemServicePlan__c> msps = getModemServicePlans(startDate, endDate);
         SNG_UsageService.Response response = sendRequest(detail, msps);     
         return (doesResponseRequireData(detail)) ? SNG_REST_ServicePlanUsageOutputBuilder.build(id, response, msps) : null;
    }
     
    /**
     * Determines whether the response to client requires the data field to be populated. The data
     * field should be populated if the status is OK or OK_WITH_ERRORS.
     *
     * @param     detail             The current status to be relayed to the client.
     * @return                       Whether the data portion should be populated or not.
     */
    public boolean doesResponseRequireData(final SNG_REST_StatusDetail detail)
    {
    	return SNGHttpUtilities.Status.OK == detail.status || 
    	       SNGHttpUtilities.Status.OK_WITH_ERRORS == detail.status;
    }
   
    
    /**
     * Checks if the ID name is of valid format. This is a method that overrides the abstract method defined
     * in the SNG_REST_IdWithDateRange. The date ranges are checked for proper format. Since the ID can
     * vary based on the request the class is supporting (i.e. mac address, service plan ID), the ID verification
     * is left to the child class to verify.
     *
     * In this case, the ID is a Service Plan. The check validates the Service Plan is in the correct
     * format: SP-XXXX and the service plan exists in the database.
     *
     * @param     detail             The current status to be relayed to the client.
     * @param     id                 The Modem MAC address.
     * @return                       true if ID is valid; false otherwise
     */
    private boolean isIdValid(SNG_REST_StatusDetail detail, String id)
    {
        return isIdFormatValid(detail, id) && isValidServicePlan(detail, id);
    }
    
    /**
     * Validates if the service plan ID format is valid. The expected format is SP-XXXX.
     *
     *
     * @param    detail            The detail object to modify if any error is encountered. This object
     *                             is used to fill in the JSON response to the client.
     * @param    id                The service plan ID to validate.
     * @return                     True if the id provided is valid, false otherwise. The detail object is
     *                             modified based on the error encountered.
     */
    private boolean isIdFormatValid(SNG_REST_StatusDetail detail, final String id)
    {
    	if (! new SfIdChecker(SERVICE_PLAN_PREFIX_REGEX).isValidFormat(id) )
    	{
    		detail.status = SNGHttpUtilities.Status.INPUT_VALIDATION_ERROR;
    		detail.code = SNG_REST_Error.SubCode.SALESFORCE_GENERATED_ERROR;
    		detail.message = SNG_REST_Error.INPUT_INVALID_FORMAT;
    	}
    	
    	return (SNGHttpUtilities.Status.OK == detail.status);
    }
    
    /**
     * Validates if the service plan ID exists within the database.
     *
     *
     * @param    detail            The detail object to modify if any error is encountered. This object
     *                             is used to fill in the JSON response to the client.
     * @param    name              The name to check to see if it exists in the database.
     * @return                     True if the name provided exists in the database, false otherwise. 
     *                             The detail object is modified based on the error encountered.
     */
    private boolean isValidServicePlan(SNG_REST_StatusDetail detail, final String name)
    {
    	boolean exists = (0 < [SELECT COUNT() FROM ServicePlan__c WHERE name = :Name]);
    	
    	if (!exists)
    	{
            detail.status = SNGHttpUtilities.Status.INPUT_VALIDATION_ERROR;
            detail.code = SNG_REST_Error.SubCode.SALESFORCE_GENERATED_ERROR;
            detail.message = SNG_REST_Error.IDS_INVALID;
    	}
    	
        return exists;
    }
    
    /**
     * Retrieves all modem service plan objects that overlap the specified range.
     *
     * @param    startDateStr       The start date. Format: YYYY-MM-dd.
     * @param    endDateStr         The end date. Format: YYYY-MM-dd.
     * @return                      All Modem / Service Plan objects that have dates that overlap the 
     *                              date range specified.
     */
    @TestVisible
    private List<ModemServicePlan__c> getModemServicePlans(final String startDateStr, final String endDateStr)
    {
    	Date startDate = Date.valueOf(startDateStr);
    	Date endDate = Date.valueOf(endDateStr);
    	
    	List<ModemServicePlan__c> msps = [SELECT Modem__r.Name, StartDate__c, EndDate__c FROM ModemServicePlan__c 
    	                                  WHERE ServicePlan__r.Name = :id AND
    	                                        StartDate__c <= :endDate AND EndDate__c >= :startDate];
    	
    	return msps;
    }    
    
    /**
     * Sends the specified request to Usage Service and returns the response. The method builds the appropriate
     * HTTPS POST request.
     *
     * @param    detail            The detail object to modify if any error is encountered. This object
     *                             is used to fill in the JSON response to the client.
     * @param    msps              The Modem / Service Plans to query the Usage Service to obtain usage data for.
     *                             The information is presented in the request Body in the HTTPS POST. 
     * @return                     The response from the Usage Service, null if msps collection is empty.
     *                             The detail object may be modified based on the error encountered.
     */
    private SNG_UsageService.Response sendRequest(SNG_REST_StatusDetail detail, final List<ModemServicePlan__c> msps)
    {
    	SNG_UsageService.Response response = null;
    	
    	if (!msps.isEmpty())
    	{
    	    response = sendPost(detail, buildRequestBody(msps));
    	    evaluateResponseStatus(detail, response);
    	}
    	else
        {
        	detail.status = SNGHttpUtilities.Status.ZERO_RESULTS;
        	detail.code = SNG_REST_Error.SubCode.SALESFORCE_GENERATED_ERROR;
        	detail.message = NO_ACTIVE_MODEMS;
        }
        
        return response;
    }
   
    /**
     * Evaluates the response from Usage Service, updating the detail object as required.
     * 
     * @param    detail            The detail object to modify if any error is encountered. This object
     *                             is used to fill in the JSON response to the client.
     * @param    response          The response from UsageService to be evaluated. 
     */
    private void evaluateResponseStatus(SNG_REST_StatusDetail detail, final SNG_UsageService.Response response)
    {
    	if (null == response) return;
    	
    	if (response.status.equalsIgnoreCase('success'))
        {
            detail.status = (!ArrayUtils.isEmpty(response.data)) ? detail.status : SNGHttpUtilities.Status.ZERO_RESULTS;
        }
        else
        {       	
            if (!ArrayUtils.isEmpty(response.data))
            {
            	// even though UsageService returned an error, some data was filled in. So it is considered OK with errors.
                detail.status = SNG_REST_Utilities.getCombinedStatus(detail.status, SNGHttpUtilities.Status.OK_WITH_ERRORS);
                detail.code = (null != detail.code) ? detail.code : SNG_REST_Error.SubCode.WEBSERVICE_GENERATED_ERROR;
                detail.message = (null != detail.message) ? detail.message : USAGE_PARTIAL_ERROR;
            }
            else
            {
                detail.status = SNG_REST_Utilities.getCombinedStatus(detail.status, SNGHttpUtilities.Status.SERVER_ERROR);
                detail.code = (null != detail.code) ? detail.code : SNG_REST_Error.SubCode.WEBSERVICE_GENERATED_ERROR;
                detail.message = (null != detail.message) ? detail.message : USAGE_SERVICE_ERROR + id;
            } 
        }
    }
    
    /**
     * Builds the request body to be placed in the HTTPS POST request to UsageService
     *
     * @param     msps              A collection of Modem/Service Plan objects to populate for the request body. 
     * @return                      A POJO representing the request body for the HTTPS POST request.  
     */
    private List<SNG_ModemUsageDate> buildRequestBody(final List<ModemServicePlan__c> msps)
    {
    	List<SNG_ModemUsageDate> modemUsagesDates = (!msps.isEmpty()) ? new List<SNG_ModemUsageDate>() : null;
        
        for (ModemServicePlan__c msp: msps)
        {
            SNG_ModemUsageDate mspData = new SNG_ModemUsageDate(msp.Modem__r.Name,
                                                                SNG_DateTimeUtils.max(msp.StartDate__c, Date.valueof(startDate)),
                                                                SNG_DateTimeUtils.min(msp.EndDate__c, Date.valueof(endDate)));
            modemUsagesDates.add(mspData); 
        }
        
        return modemUsagesDates;
    }
    
    /**
     * Sends a post request to Usage Services.
     *
     * @param    detail            The detail object to modify if any error is encountered. This object
     *                             is used to fill in the JSON response to the client.
     * @param    requestBody       The collection of Modem MAC addresses and date ranges to be used in the 
     *                             request body of the HTTPS POST request.
     * @return                     The response from Usage Services.
     */
    private static SNG_UsageService.Response sendPost(SNG_REST_StatusDetail detail, final List<SNG_ModemUsageDate> requestBody)
    {
    	HttpResponse response = SNG_ModemUsageDataHttpCallout.post(requestBody, SNG_ModemUsageDataHttpCallout.Grain.DAY, 0, false, true);
    	return processResponse(detail, response);
    }
    
    /**
     * Processes the response from Usage Services by evaluating the HTTP status code and the JSON response.
     *
     * @param    detail            The detail object to modify if any error is encountered. This object
     *                             is used to fill in the JSON response to the client.
     * @param    httpResponse      The HTTPS response to evaluate.
     * @return                     The Usage Service Response encapsulated in a POJO object.
     */
    private static SNG_UsageService.Response processResponse(SNG_REST_StatusDetail detail, final HttpResponse httpResponse)
    {	
    	SNG_UsageService.Response response = null;
    	
    	if (SNGHttpUtilities.isStatusCodeOK(httpResponse.getStatusCode()))
    	{
    		response = parseResponseBody(httpResponse.getBody());
    	}
    	else
        {
            System.Debug(LoggingLevel.ERROR, 'HTTP Status Code ' + httpResponse.getStatusCode() + ' returned. ' + httpResponse.getStatus());
            detail.status = SNGHttpUtilities.Status.SERVER_ERROR;
            detail.code = SNG_REST_Error.SubCode.WEBSERVICE_GENERATED_ERROR;
            detail.message = SNG_REST_Error.GENERIC_WEBSERVICE_ERROR;
        }
        
    	return response;
    }
    
    
    /**
     * Parses the response body response from Usage Service by converting into a POJO object
     * representing the JSON response. The POJO object allows easier readability and usage of the data.
     *
     * @param    response          The JSON response from Usage Services.
     * @return                     The POJO object representation of the JSON response.
     * @throws                     An exception if deserialization fails.
     */
    private static SNG_UsageService.Response parseResponseBody(final String response)
    {
    	return SNG_UsageService.deserialize(response);
    }
}