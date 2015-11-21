/**
 * This class is used to support a RESTful API for the user terminal performance history method. It is
 * an entry point into the Apex code.
 */
@RestResource(urlMapping='/terminal/*/performance/history')
global with sharing class SNG_REST_PerfHistory {

	/**
	 * An error message to indicate that terminal ID is not in valid format
	 */
	@TestVisible
	private static final String TERMINAL_INVALID_FORMAT = 'Terminal input is not in the valid format';

	/**
	 * An error message to indicate that the ID does not have a corresponding Terminal object.
	 */
	@TestVisible
	private static final String NO_TERMINAL = 'Terminal ID does not correspond with any Terminal objects in your account';

	/**
	 * An error message to indicate that the terminal does not have a modem
	 */
	@TestVisible
	private static final String TERMINAL_NO_MODEM = 'Terminal does not have a modem associated.';

	/**
	 * An error message to indicate that the PMDR does not have performance history for the terminal's modem
	 */
	@TestVisible
	private static final String NO_PERFORMANCE_HISTORY = 'Terminal does not contain performance history.';

	/**
	 * PMDR only accepts years 1970 - 2037
	 */
	@TestVisible
	private static final String DATE_YEAR_LIMITS = 'Year for dates must be between 1970 - 2037';

	/**
	 * An error message to indicate that the start date cannot be more than 60 days old. Performance history is stored only for 60 days.
	 */
	@TestVisible
	private static final String START_DATE_MORE_THAN_60_DAYS = 'Start date cannot be more than 60 days ago from today\'s date';
	
	
	@HttpGet
	global static SNG_REST_JsonResponse getPerformanceHistory() {

		RestRequest req = RestContext.request;

		// Status of the response, default status = OK, default errorSubCode = null, default errorMessage = null
		SNG_REST_StatusDetail details = new SNG_REST_StatusDetail(SNGHttpUtilities.Status.OK, null);		
		
		// retrieve start and end dates and verify format
		String startDate = req.params.get('start-date');
		String endDate = req.params.get('end-date');
		details = verifyDates(startDate, endDate, details); 
		
		// retrieve terminal ID from the URI path and verify format
		String terminalId = SNG_REST_Utilities.getPathVariableFromUri(RestContext.request.requestURI, '/terminal/', '/performance');
		details = verifyTerminalId(terminalId, details); 
		
		// Dates and terminal ID are valid, verify if terminal object exists
		if (details.status == SNGHttpUtilities.Status.OK)
		{  
			details = verifyTerminalObjectExists(terminalId, details);
		}
			
		// Inputs are valid, terminal object exists	
		if (details.status == SNGHttpUtilities.Status.OK)
		{
			// check if terminal has a modem
			List<Modem__c> modem = [SELECT Id, Name FROM Modem__c WHERE Terminal__r.Name = :terminalId];
			details = verifyModemExists(modem, details); 
			
			// Inputs are valid, terminal Object exists, modem exists, make http callout for performance history
			if (details.status == SNGHttpUtilities.Status.OK) 
			{ 
				return sendHttpCalloutPerfHistory(modem.get(0).Name, terminalId, startDate, endDate, details); 
			}
		}
		
		// return error response
		return new SNG_REST_JsonResponse(details, null);
	}


	/**
	 * Send HTTP callout to retrieve performance history data
	 * 
	 * @param	modemMacAddr		Modem Mac Address corresponding to terminal
	 * @param 	terminalId			Terminal ID
	 * @param	startDate			Starting date for performance history data
	 * @param	endDate				End date for performance history data
	 * @param	details				Response status details 
	 * @return  					object that represents the structure fot the JSON response of the API call
	 */
	private static SNG_REST_JsonResponse sendHttpCalloutPerfHistory(String modemMacAddr, String terminalId, 
																	String startDate, String endDate, 
																	SNG_REST_StatusDetail details) 
	{ 
		
		try {
			// send http request  
			HttpResponse res = SNG_PerformanceHistoryRetrieval.getPerformanceHistory(modemMacAddr, Date.valueOf(startDate), Date.valueOf(endDate));
			
			// Http Request is OK 
			if (SNGHttpUtilities.isStatusCodeOK(res.getStatusCode()))
			{ 
				return processOkResponse(res, terminalId, startDate, endDate, details); 
			}
			// Http Request is not OK
			else 
			{ 
				return processBadResponse(res, terminalId, startDate, endDate, details); 
			} 
		}
		// Exception occurred during HTTP Callout
		catch (Exception e) { 
			details.status = SNGHttpUtilities.Status.SERVER_ERROR;
			details.code = SNG_REST_Error.SubCode.WEBSERVICE_GENERATED_ERROR;
			details.message = SNG_REST_Error.GENERIC_WEBSERVICE_ERROR; 
			
			return new SNG_REST_JsonResponse(details, null); 	
		}
	}
	
	
	/**
	 * Process OK/200 Response from PMDR callout 
	 *  
	 * @param	res				HTTP response from PMDR
	 * @param	terminalId		Terminal ID
	 * @param	startDate		Starting date for performance history data
	 * @param	endDate			End date for performance history data
	 * @param	details			Response status details 
	 * @return 					object that represents the structure fot the JSON response of the API call
	 */ 
	private static SNG_REST_JsonResponse processOkResponse (HttpResponse res, String terminalId, String startDate, String endDate,
																 SNG_REST_StatusDetail details) 
	{ 
		
		// Object containing the raw performance data
		SNG_Perf.UtPhyHistoryInternal perfHistory = null;
		
		// Get PMDR response in the HTTP Response body
		String pmdrStatus = getResponseBodyStatus(res.getBody());
		
		details.status = SNG_REST_Utilities.getStatusFromString(pmdrStatus);		
	
		// PMDR Status = OK, process the response
		if (details.status == SNGHttpUtilities.Status.OK)
		{
			perfHistory = deserializePerfHistoryData(res);
		}
		// PMDR Status = ZERO_RESULTS
		else if (details.status == SNGHttpUtilities.Status.ZERO_RESULTS)
		{
			details.code = SNG_REST_Error.SubCode.WEBSERVICE_GENERATED_ERROR;
			details.message = NO_PERFORMANCE_HISTORY;
		}
		// default status, could not find matching status in SNG_REST_Utilities.getStatusFromString()
		else if (details.status == null)
		{
			details.status = SNGHttpUtilities.Status.SERVER_ERROR;
			details.code = SNG_REST_Error.SubCode.WEBSERVICE_GENERATED_ERROR;
			details.message = SNG_REST_Error.GENERIC_WEBSERVICE_ERROR;
		}
		
		return responseBuilder(details,terminalId, startDate, endDate, perfHistory);	
	} 
	
	
	/**
	 * Process HTTP Response that does not have OK/200 status
	 * 
	 * @param	res				HTTP response from PMDR
	 * @param	terminalId		Terminal ID
	 * @param	startDate		Starting date for performance history data
	 * @param	endDate			End date for performance history data
	 * @param	details			Response status details 
	 * @return 					object that represents the structure fot the JSON response of the API call
	 */ 
	private static SNG_REST_JsonResponse processBadResponse(HttpResponse res, String terminalId, String startDate, String endDate, 
															SNG_REST_StatusDetail details)
	{
		details.code = SNG_REST_Error.SubCode.WEBSERVICE_GENERATED_ERROR;
		String pmdrStatus = getResponseBodyStatus(res.getBody());
		
		// if dates are before 1970, HTTP response will have 400 response code, PMDR Status = INPUT_VALIDATION_EXCEPTION
		if (pmdrStatus == 'INPUT_VALIDATION_EXCEPTION')
		{ 
			details.status = SNGHttpUtilities.Status.INPUT_VALIDATION_ERROR; 
			details.message = DATE_YEAR_LIMITS;
		}
		// Unknown error from PMDR service
		else 
		{ 
			details.status = SNGHttpUtilities.Status.SERVER_ERROR; 
			details.message = SNG_REST_Error.GENERIC_WEBSERVICE_ERROR;
		}
		
		return responseBuilder(details, terminalId, startDate, endDate, null);
	}


	/**
	 * Extracts the PMDR's response status
	 *
	 * @param 	responseBody 	The response body from HTTP callout to PMDR service
	 * @return					The PMDR Service response status
	 */
	private static String getResponseBodyStatus(String responseBody) {

		JSONParser parser = JSON.createParser(responseBody);
		String status;

		while(parser.nextToken() != null)
		{
			if (parser.getCurrentName() == 'status')
			{
				parser.nextToken();
				status = parser.getText();
			}

		}
		return status;
	}
	
	
	/**
     * Deserialize performance history data from HTTP response body
     *
     * @param	httpResponse		The HTTP response from the PerfMonDataRetrieval Web service.
     * @return						The user terminal physical history data encapsulated in an object.
	 */
	private static SNG_Perf.UtPhyHistoryInternal deserializePerfHistoryData (HttpResponse httpResponse) {

		SNG_Perf.UtPhyHistoryInternal utPhyHistory = null;

		utPhyHistory = (SNG_Perf.UtPhyHistoryInternal) JSON.deserialize(httpResponse.getBody(), SNG_Perf.UtPhyHistoryInternal.class);

		return utPhyHistory;
	}
	

	/**
	 * Build the structure that represents the JSON response of the API call 
	 *
	 * @param	details			Response status details
	 * @param	terminalId		Terminal ID
	 * @param	startDate		Starting date for performance history data
	 * @param	endDate			End date for performance history data
	 * @param	perfHistory		object that represents the structure for the JSON response of the performance history call
	 * @return  				object that represents the structure fot the JSON response of the API call
	 */
	private static SNG_REST_JsonResponse responseBuilder(SNG_REST_StatusDetail details, final String terminalId,
											final String startDate, final String endDate, final SNG_Perf.UtPhyHistoryInternal perfHistory)
	{
		SNG_REST_JsonResponse response;
		
		// Status is OK, return response with data
		if (details.status == SNGHttpUtilities.Status.OK) 
		{ 
			List<TerminalRawPerformanceData> performanceData = new List<TerminalRawPerformanceData>();

			// retrieve performance history data from perfHistory; result[] in perfHistory will either be empty or a filled List
			performanceData = extractPerformanceData(perfHistory);
			
			return new SNG_REST_JsonResponse(details, new TerminalPerformanceHistoryOutput(terminalId, startDate, endDate, performanceData)); 
		}  
		
		// Status not OK, return response with data null
		return  new SNG_REST_JsonResponse(details, null); 	
	}
	
			
	/**
	 * Extract relevant performance data from SNG_Perf.UtPhyHistoryInternal object to a List
	 * 
	 * @param		phyHistory		Object that PMDR response is deserialized to.
	 * @return 						List that represents the performance data
	 */ 
    @TestVisible
	private static List<TerminalRawPerformanceData> extractPerformanceData(SNG_Perf.UtPhyHistoryInternal phyHistory) { 
		
		List<TerminalRawPerformanceData> performanceData = new List<TerminalRawPerformanceData>(); 
		
		if (phyHistory != null) 
		{ 
			for (SNG_Perf.UtPhyStatusInternal phyStatusElement : phyHistory.result)
			{ 
				 performanceData.add(new TerminalRawPerformanceData(phyStatusElement));
			} 
		}

        return  (!performanceData.isEmpty()) ? performanceData : null;
	} 
	

	/**
	 * Check that there are values for start date and end date. The Dates can either have some value, be an empty string, or null
	 *
	 * @param		startDate		Start Date of the period to get performance history, format YYYY-MM-DD
	 * @param		endDate			End Date of the period to get performance history, format YYYY-MM-DD
	 * @return 						true if dates are valid and formatted correctly
	 * 								false if dates are not entered or not formatted
	 */
	private static SNG_REST_StatusDetail verifyDates(String startDate, String endDate, SNG_REST_StatusDetail details) {
		
		// set the message to null
		details.message = null; 
		
		SNG_DateChecker dateValidator = new SNG_DateChecker(); 
		
		// start/end dates are null
		if (startDate == null) {
			details.message = SNG_REST_Error.MISSING_START_DATE;
		}
		else if (endDate == null) {
			details.message = SNG_REST_Error.MISSING_END_DATE;
		}
		else
		{
			if (dateValidator.isValidFormat(startDate) && dateValidator.isValidFormat(endDate)) 
			{ 
				// CHECK Start Date cannot be in the future
				if (dateValidator.isDateInTheFuture(startDate)) {
					details.message = SNG_REST_Error.START_DATE_IN_FUTURE;
				}
				// CHECK end date cannot be before start date
				else if (dateValidator.isEndDateBeforeStartDate(startDate, endDate)) {
					details.message = SNG_REST_Error.END_DATE_BEFORE_START_DATE;
				}
				// CHECK PMDR only stores data for up to 60 days, start date has to be less than 60 days ago
				else if (dateValidator.isDateOlderThan60Days(startDate)) {
					details.message = START_DATE_MORE_THAN_60_DAYS;
				}				
			}
			else 
			{ 
				details.message = SNG_REST_Error.INVALID_DATE +  ' Dates must be in YYYY-MM-DD format.';
			}
		}
		
		// If an error message was set, an error occurred, set the status and error code
		if (details.message != null) 
		{ 
			details.status = SNGHttpUtilities.Status.INPUT_VALIDATION_ERROR;
			details.code = SNG_REST_Error.SubCode.SALESFORCE_GENERATED_ERROR;			
		}
		
		return details;
	}
	

	/**
	 * Verify terminal object has a modem
	 *
	 * @param	modem		List that contains the modem corresponding to the terminal
	 * @param 	details		Response status details
	 */ 
	private static SNG_REST_StatusDetail verifyModemExists(List<Modem__c> modem, SNG_REST_StatusDetail details) { 
		if (ArrayUtils.isEmpty(modem))
		{
			details.status = SNGHttpUtilities.Status.ZERO_RESULTS;
			details.code = SNG_REST_Error.SubCode.SALESFORCE_GENERATED_ERROR;
			details.message = TERMINAL_NO_MODEM;
		}
		
		return details; 		
	}
	
		
	/**
	 * Verify terminal ID is in correct format
	 *
	 * @param	terminalId		The terminal ID
	 * @param	details			Response status details
	 */ 
	private static SNG_REST_StatusDetail verifyTerminalId(String terminalId, SNG_REST_StatusDetail details) { 
		
		// create validator object for terminal ID
		SfIdChecker termIdChecker = new SfIdChecker('[Tt]');
		
		// Check if terminal ID is valid
		if ( !termIdChecker.isValidFormat(terminalId) )
		{
			details.status = SNGHttpUtilities.Status.INPUT_VALIDATION_ERROR;
			details.code = SNG_REST_Error.SubCode.SALESFORCE_GENERATED_ERROR;
			details.message = TERMINAL_INVALID_FORMAT;
		}
		
		return details; 		
	}
	 
	
	/**
	 * Verify terminal Object exists
	 *
	 * @param	terminalId		The terminal ID
	 * @param  	details			Response status details
	 */
	private static SNG_REST_StatusDetail verifyTerminalObjectExists(String terminalId, SNG_REST_StatusDetail details) { 
		
		// Retrieve terminal object from terminal ID
		List<Terminal__c> terminal = [SELECT Id, Name FROM Terminal__c WHERE Name = :terminalId];

		// no terminal found, ZERO RESULTS
		if (ArrayUtils.isEmpty(terminal))
		{
			details.status = SNGHttpUtilities.Status.ZERO_RESULTS;
			details.code = SNG_REST_Error.SubCode.SALESFORCE_GENERATED_ERROR;
			details.Message = NO_TERMINAL;
		}
		
		return details; 
	}
	
	
    /**
     * This class represents the structure for the JSON response to the API request.
     */
    public class TerminalPerformanceHistoryOutput extends SNG_REST_CollectionOutput
    {
        /**
         * The terminal ID
         */ 
        public String terminalId;

		/**
         * The date to start getting performance data.
         */ 
        public String startDate;

        /**
         * The date to stop getting performance data.
         */
        public String endDate;
		
		// List<TerminalRawOutput> items
		
        /**
         * Creates an instance of this object
         */
        public TerminalPerformanceHistoryOutput(String inputTerminalId, String inputStartDate, String inputEndDate, 
        										List<TerminalRawPerformanceData> perfHistory)
        {
        	super(perfHistory);
            terminalId = inputTerminalId;
            startDate = inputStartDate;
            endDate = inputEndDate;
        }
        
        /**
         * Overriding equals for comparison 
         */
        public override Boolean equals(final Object obj) { 
        	
        	boolean isEquals; 
        	if (this === obj) { 
        		return true; 
        	}
        	if ( obj == null || !(obj instanceof TerminalPerformanceHistoryOutput) ) { 
        		return false; 
        	}
        	// Check for null 
        	TerminalPerformanceHistoryOutput other = (TerminalPerformanceHistoryOutput) obj; 
        	
        	isEquals = StringUtils.equals(terminalId, other.terminalId) && StringUtils.equals(startDate, other.startDate) && 
        									StringUtils.equals(endDate, other.endDate); 
        	
        	if (items == null && other.items == null) { 
        		isEquals = isEquals && true; 
        	}
        	else { 
        		isEquals = (items.equals(other.items) && isEquals); 
        	}
        	return isEquals; 
        }
        
        /**
         * Overriding hashCode()
         */
        public override integer hashCode() { 
        	
        	final integer prime = 31; 
        	integer result = 1; 
        	result = prime * result + ((terminalId == null) ? 0 : terminalId.hashCode()); 
        	result = prime * result + ((startDate == null) ? 0 : startDate.hashCode()); 
        	result = prime * result + ((endDate == null) ? 0 : endDate.hashCode());
        	result = prime * result + ((items == null) ? 0 : items.hashCode());
        	return result; 
        	  
        }  
    }

    /**
     * This class is used in TerminalsPerformanceHistoryOutput
     */
    public class TerminalRawPerformanceData
    {
        public Integer timestamp;
        public Decimal uploadSymbolRate;
        public Decimal downloadSinr;
		
		public TerminalRawPerformanceData(integer timestamp, Decimal uploadSymbolRate, Decimal downloadSinr) { 
			this.timestamp = timestamp; 
			this.uploadSymbolRate = uploadSymbolRate; 
			this.downloadSinr = downloadSinr; 
		}
		
        public TerminalRawPerformanceData(SNG_Perf.UtPhyStatusInternal phyStatus)
        {
            timestamp = Integer.valueOf(phyStatus.UTTIME);
            uploadSymbolRate = phyStatus.UTRLSYMBOLRATE;
            downloadSinr = phyStatus.UTFLSINR;
        }
        
        public boolean equals(final Object obj) { 
        	 
        	 if(this === obj) { 
        	 	return true; 
        	 }
        	 if (obj == null || !(obj instanceof TerminalRawPerformanceData)) { 
        	 	return false; 
        	 }
        	 TerminalRawPerformanceData other = (TerminalRawPerformanceData) obj; 
 
        	 return( (timestamp == other.timestamp) && (uploadSymbolRate == other.uploadSymbolRate) &&
        	 		(downloadSinr == other.downloadSinr) ); 
        }
        
        /**
         * Overriding hashCode()
         */
        public override integer hashCode() { 
            final integer prime = 31; 
            integer result = 1; 
            result = prime * result + ((timestamp == null) ? 0 : timestamp ^ (timestamp >>> 32)); 
            result = prime * result + ((uploadSymbolRate == null) ? 0 : uploadSymbolRate.format().hashCode()); 
            result = prime * result + ((downloadSinr == null) ? 0 : downloadSinr.format().hashCode());
            return result;
        }
    }

}