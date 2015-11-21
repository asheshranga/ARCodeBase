/**
 * This class handles the RESTful API request GET /modem/{mac-address}/usage?{parameters}
 */ 
global with sharing class SNG_REST_ModemUsage extends SNG_REST_IdWithDateRange
{
	
	/**
     * Error message indicating a modem cannot be found that is associated with the supplied MAC address.
     */
	public static final String MISSING_MODEM = 'There is no Modem associated with the MAC address';
	
	/**
	 * Detailed message indicating the modem was not active during the requested time period.
	 */
	public static final String MODEM_NOT_ACTIVE = 'The modem was not active during this period';

    /**
     * Creates an instance of this object.
     * 
     * @param    restReq           The REST request information. This information is created through the client RESTful API request.
     * @throws   SNG_Exception     If expected parameters are not found or too many wildcards are encountered.
     */
	public SNG_REST_ModemUsage(final RestRequest restReq)
	{
		super(restReq, new SNG_ModemMacAddressConverter());
		SNG_REST_Utilities.assertTrue(null != idConverter, 'Converter should never be null');
	}
	
	/**
     * Creates an instance of this object. This constructor can be used if the information is not wrapped within a RestRequest
     * object and the user explicitly requests to pass the information in.
     *
     * @param    macAddress        The MAC address (also considered the id). 
     * @param    startDate         The start date for the usage period requested.
     * @param    endDate           The end date for the usage data period requested.
     */
	public SNG_REST_ModemUsage(final String macAddress, final String startDate, final String endDate)
    {
        super(macAddress, startDate, endDate, new SNG_ModemMacAddressConverter());
        SNG_REST_Utilities.assertTrue(null != idConverter, 'Converter should never be null');
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
	 * @param	detail	 The current status to be relayed to the client.
	 * @return 			 The JSON Response usage data for the Modem 
	 */ 
	private SNG_REST_IJsonResponseData processRequest(SNG_REST_StatusDetail detail) 
	{ 
		List<ModemServicePlan__c> activeMsps = getModemServicePlans(id, startDate, endDate);
		List<ServicePlanInfo> servicePlans = new List<ServicePlanInfo>();
		SNG_UsageService.Response response = sendRequest(detail, activeMsps, servicePlans);
		return (doesResponseRequireData(detail)) ? SNG_REST_ModemUsageOutputBuilder.build(id, response, servicePlans) : null; 
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
     * Prepares and sends the post request to the Usage Service. The preparation includes
     * building a request body with the requested mac address and it's corresponding date range.
     *
     * @param    detail            The detail object to modify if any error is encountered. This object
     *                             is used to fill in the JSON response to the client.
     * @param    msps              The list of of Modem / Service Plan corresponding to the Modem MAC
     *                             address and active date ranges.
     * @param    servicePlans      An empty collection to be populated with the service plan ID and its
     *                             usages dates.
     * @return                     The response from Usage Services.
     */	
	private SNG_UsageService.Response sendRequest(SNG_REST_StatusDetail detail, 
	                                              final List<ModemServicePlan__c> msps,
	                                              List<ServicePlanInfo> servicePlans)
	{
		SNG_UsageService.Response response = null;

        if (!ArrayUtils.isEmpty(msps))
        {
            response = sendPost(detail, buildRequestBody(servicePlans, msps, id, startDate, endDate));
        }
        else
        {
            detail.status = SNGHttpUtilities.Status.ZERO_RESULTS;
            detail.code = SNG_REST_Error.SubCode.SALESFORCE_GENERATED_ERROR;
            detail.message = MODEM_NOT_ACTIVE;
        }
        
        return response;
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
    private SNG_UsageService.Response sendPost(SNG_REST_StatusDetail detail, 
                                               final List<SNG_ModemUsageDate> requestBody)
    {
        HttpResponse response = SNG_ModemUsageDataHttpCallout.post(requestBody, SNG_ModemUsageDataHttpCallout.Grain.DAY, 0, false, true);
        return processResponse(detail, response);
    }
	
	/**
     * Checks if the ID name is of valid format. This is a method that overrides the abstract method defined
     * in the SNG_REST_IdWithDateRange. The date ranges are checked for proper format. Since the ID can
     * vary based on the request the class is supporting (i.e. mac address, service plan ID), the ID verification
     * is left to the child class to verify.
     *
     * In this case, the ID is a Modem MAC address. The check validates the Modem MAC address is in the correct
     * format: XX:XX:XX:XX:XX:XX and the MAC address exists in the database.
     *
     * @param     detail             The current status to be relayed to the client.
     * @param     id                 The Modem MAC address.
     * @return                       true if ID is valid; false otherwise
     */
    private boolean isIdValid(SNG_REST_StatusDetail detail, String id)
    {
        return isIdFormatValid(detail, id) &&  doesModemExistForMacAddress(detail, idConverter.convert(id));
    }
	
	
	/**
     * Validates if the service MAC address format is valid. The expected format is XX:XX:XX:XX:XX:XX.
     *
     *
     * @param    detail            The detail object to modify if any error is encountered. This object
     *                             is used to fill in the JSON response to the client.
     * @param    id                The MAC address to validate.
     * @return                     True if the id provided is valid, false otherwise. The detail object is
     *                             modified based on the error encountered.
     */
    private boolean isIdFormatValid(SNG_REST_StatusDetail detail, final String id)
    {
        return new SNG_ModemMacAddressChecker().validate(detail, id);
    }
	
	/**
	 * Checks if MAC address corresponds to an existing terminal
	 *
	 * @param detail		Response status details
	 * @param macAddress 	The MAC address to check
	 * @return				True if modem exist, false if modem does not
	 */
	private static boolean doesModemExistForMacAddress(SNG_REST_StatusDetail detail, final String macAddress) { 
		
		if(getModem(macAddress) == null) 
		{ 
			detail.status = SNGHttpUtilities.Status.ZERO_RESULTS;
			detail.code = SNG_REST_Error.SubCode.SALESFORCE_GENERATED_ERROR;
			detail.message = MISSING_MODEM; 
			return false;
		}
		
		return true;
	}
	
	/**
	 * Retrieve Modem__c object
	 * 
	 * @param macAddress 	The MAC address used to retrieve modem objecct
	 * @return				The Modem__c object, or null if MAC address does not correspond to a Modem__c 
	 */
	private static Modem__c getModem(final String macAddress) {
		 
		 List<Modem__c> modem = [SELECT Id, Name FROM Modem__c WHERE Modem__c.Name = :macAddress];
		 return (0 < modem.size()) ? modem.get(0) : null; 
	}
	
	/**
	 * Returns list of ModemServicePlan__c active during the specified time period.
	 * 
	 * @param macAddress	The MAC address of the Modem
	 * @param startDate		The start date
	 * @param endDate		The end date
	 * @return				List of ModemServicePlan_c active during time period; null if no active
	 *                      Modem / Service Plans can be found.
	 */
	@TestVisible  
	private static List<ModemServicePlan__c> getModemServicePlans(final String macAddress, final String startDate, final String endDate) 
	{ 	
		// Retrieve Modem__c object
		Modem__c modem = getModem(macAddress);
		
		List<ModemServicePlan__c> msps = null;
		
		if (modem != null) 
		{ 
			// Retrieve MSPs active for the given MAC address during the given period
			msps = [SELECT Name, ServicePlan__c, ServicePlan__r.Name, Modem__c, Modem__r.Name, StartDate__c, EndDate__c 
										FROM ModemServicePlan__c 
										WHERE Modem__c = :modem.Id 
										AND StartDate__c <= :Date.valueOf(endDate) 
        								AND EndDate__c >= :Date.valueOf(startDate)];
		}	
							
		return msps;
	}
	
	
	/**
	 * Builds objects for the request body. This method extracts out the service plans and their active start/end
	 * dates for usage.
	 * 
	 * @param servicePlans	List of service plans and their active usage dates. The object is populated
	 *                      in this method.
	 * @param msps			List of Modem Service Plans active during the query period
	 * @param macAddress	The MAC address to retrieve usage 
	 * @param startDate		The start date
	 * @param endDate		The end date
	 * @return 				List of SNG_ModemUsageDate objects that will be written in the request body
	 */
	@TestVisible  
	private static List<SNG_ModemUsageDate> buildRequestBody(List<ServicePlanInfo> servicePlans,
															 final List<ModemServicePlan__c> msps, 
															 final String macAddress, 
															 final String startDate, 
															 final String endDate) 
	{ 
		List<SNG_ModemUsageDate> requestBodyParameters = new List<SNG_ModemUsageDate>();
		
	 	// Iterate through MSPs, create SNG_ModemUsageDate objects for each MSPs
	 	for (ModemServicePlan__c msp : msps)
	 	{ 
	 		// Set the proper query dates
	 		DateTime queryStartDate = SNG_DateTimeUtils.max(Date.valueOf(startDate), msp.StartDate__c);
	 		DateTime queryEndDate = SNG_DateTimeUtils.min(Date.valueOf(endDate), msp.EndDate__c);
	 		
	 		SNG_ModemUsageDate modemUsageDate = new SNG_ModemUsageDate(macAddress, queryStartDate, queryEndDate);
	 		requestBodyParameters.add(modemUsageDate);	 
	 		servicePlans.add(new ServicePlanInfo(msp.ServicePlan__r.Name, modemUsageDate));
	 	}
	 	
	 	return requestBodyParameters;
	}
	
	/**
	 * Processes the response from UsageService
	 * 
	 * @param	detail		  Response status details
	 * @param	response	  The response from UsageService
	 * @return 				  The response to be sent back to the client
	 */
	@TestVisible 
	private static SNG_UsageService.Response processResponse(SNG_REST_StatusDetail detail, 
	                                                          final HttpResponse httpResponse) 
    { 
		return SNGHttpUtilities.isStatusCodeOK(httpResponse.getStatusCode()) ? processOkResponse(detail, httpResponse) : 
		                                                                       processBadResponse(detail);  
	}
	
	/**
	 * Process HTTP status 200/OK response. This method processes the response and formats the messages into
	 * a SNG_REST_JsonResponse. It is possible that the UsageService returns a non-success flag even with the HTTP
	 * status of 200 OK. In this case, the detail is set to ERROR since the response cannot be interpretted any
	 * furthur. 
	 *
     * @param   detail        Response status details
     * @param   response      The response from UsageService
     * @param   servicePlans  The service plans and their corresponding active dates.
     * @param   macAddress    The mac address of the usage data requested.
     * @return                The response in an SNG_REST_JsonResponse format, which is sent back to the client.
	 */
	@TestVisible  
	private static SNG_UsageService.Response processOkResponse(SNG_REST_StatusDetail detail, 
	                                                       final HttpResponse httpResponse) 
	{ 
		// Deserialize and parse the HTTP response body
		SNG_UsageService.Response response = parseResponseBody(httpResponse); 
		
		return (response.status.equals('success')) ? response : processBadResponse(detail);
	}
	
	/**
	 * Process non 200/OK response and build response back to 3rd party.
	 *
	 * @param   detail        Response status details.
	 * @param   httpResponse  The response from the UsageService.
	 */
	@TestVisible 
	private static SNG_UsageService.Response processBadResponse(SNG_REST_StatusDetail detail) 
	{ 	
		detail.status = SNGHttpUtilities.Status.SERVER_ERROR;
		detail.code = SNG_REST_Error.SubCode.WEBSERVICE_GENERATED_ERROR;
		detail.message = SNG_REST_Error.GENERIC_WEBSERVICE_ERROR;
		return null;
	}
	
	/**
	 * Retrieves the service plan which coincides with the start date selected.
	 *
	 * @param     servicePlans          The list of service plans and their active dates for the requested mac addressed and date range.
	 * @param     startDate             The startDate to verify which service plan the date falls under
	 * @return                          The service plan corresponding to the start date.
	 * @throws    SNG_Exception         Thrown if the date provided is not within the range of service plans.
	 */
	@TestVisible
	private static String getServicePlanId(final List<ServicePlanInfo> servicePlans, final DateTime startDate)
	{
		for (ServicePlanInfo servicePlan : servicePlans)
		{
			if (servicePlan.inRange(startDate))
				return servicePlan.id;
		}
		
		throw new SNG_Exception('Service Plan not in range.');
	}
	
    /**
     * Parses the response body response from Usage Service by converting into a POJO object
     * representing the JSON response. The POJO object allows easier readability and usage of the data.
     *
     * @param    response          The JSON response from Usage Services.
     * @return                     The POJO object representation of the JSON response.
     */
	@TestVisible 
	private static SNG_UsageService.Response parseResponseBody(final HttpResponse httpResponse) 
	{ 
		return SNG_UsageService.deserialize(httpResponse.getBody());
	}
	
	/**
	 * This inner class captures a grouping of the service plan id and their active usage dates. This is used
	 * to remap the Usage Data Mart (UDM) usage data 
	 */
	public class ServicePlanInfo
	{
		/**
		 * The service plan ID. Expected format: SP-XXXX
		 */
		public String id 
		{ 
			get;
			set 
			{
				String SERVICE_PLAN_PREFIX_REGEX = '[Ss][Pp][-]';
				SNG_REST_Utilities.assertTrue(new SfIdChecker(SERVICE_PLAN_PREFIX_REGEX).isValidFormat(value), 
				                              'Invalid Service Plan ID format. Expected: SP-XXXX');
				id = value;
			}
		}
		
		/**
		 * Contains the Modem MAC address and it's corresponding active start and end dates.
		 */
		public SNG_ModemUsageDate modemUsageDate;
		
		/**
		 * Creates an instance of this object.
		 *
		 * @param    id              The service plan ID. Expected format: SP-XXXX
		 * @param    modemUsageDate  The Modem MAC address and its corresponding start and end date.
		 */
		public ServicePlanInfo(final String id, final SNG_ModemUsageDate modemUsageDate)
		{
			this.id = id;
			this.modemUsageDate = modemUsageDate;
		}
		
		/**
		 * Validates whether the date specified falls within the specified active dates for the service plan.
		 *
		 * @param    startTime       The start time for the usage data to validate.
		 * @return                   True if the date falls within the service plan active dates; false otherwise.
		 */
		public boolean inRange(final DateTime startTime)
		{
			return (modemUsageDate.startTime <= startTime && modemUsageDate.endTime >= startTime);
		}
	}
}