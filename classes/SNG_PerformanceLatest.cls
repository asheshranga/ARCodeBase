/**
 * This class is used to communicate and retrieve the user terminal physical(PHY) information for
 * a list of user terminal MAC addresses. The data retrieved consists of user terminal information
 * such as the signal-to-noise ratio for a forward link, return link symbol rate, current status, and
 * online time.
 */
public with sharing class SNG_PerformanceLatest {
	
	/**
	 * The HTTP path used to communicate with the PMDR Web service.
	 */
	@TestVisible
	private static final transient String DB_PERF_HTTP_PATH =  SNGHttpUtilities.TOMCAT_SERVER.Url__c  + '/PmdrService/query/perf/peer/phy/latest/list/';
	
    /**
     * Conversion of one second into milliseconds.
     */
    private static final Integer ONE_SEC_IN_MSEC = 1000;

	/**
     * The timeout used for the HTTP request.
     */
    private static final transient Integer TIMEOUT_IN_MSEC = 
    	Integer.valueOf(SNGKeyValueStore__c.getValues(Label.SNGPmdrHttpCalloutTimeoutSec).Value__c) * ONE_SEC_IN_MSEC;
	
	public static SNG_Perf.PerfLatest getPerformance(String[] macAddresses, boolean allowCookieCaching) {
		SNG_Perf.PerfLatest perfLatest = null;
		
		try {
			HttpResponse res = SNG_UtPeersHttpCallout.post(DB_PERF_HTTP_PATH, 
			                                               macAddresses, 
			                                               Integer.valueOf(SNGKeyValueStore__c.getValues(Label.SNGPmdrValidThresholdMinutes).Value__c),
														   TIMEOUT_IN_MSEC,
														   allowCookieCaching);
			perfLatest = processResponse(res);
		} catch (Exception e) {
			System.debug(LoggingLevel.ERROR, 'Caught Exception in SNG_PerformanceLatest.getPerformance. ' 
			                                 + e.getMessage() + '\n' + e.getStackTraceString());
			perfLatest = generateFailedResponse();
		}
		
		return perfLatest;
	}

	/**
     * Processes the HTTP response for the user terminal performance data from the PERF data.
     *
     * @param 	httpResponse        	The HTTP response from the PMDR Web service in JSON format.
     * @return	                    	The parsed user terminal performance data.
     * @throws	SNG_CalloutException	If the status of the HTTP response is not OK (200).
     */
    private static SNG_Perf.PerfLatest processResponse(HttpResponse httpResponse)
	{
		SNG_Perf.PerfLatest perfLatest = null;
		if (SNGHttpUtilities.isStatusCodeOK(httpResponse.getStatusCode()))
		{
			perfLatest = parseResponseBody(httpResponse.getBody());
		}
		else
		{
			System.Debug(LoggingLevel.ERROR, 'Response: ' + httpResponse.getStatus());
            throw new SNG_CalloutException('HTTP Status Code ' + httpResponse.getStatusCode() + ' returned. ' + httpResponse.getStatus());
		}
		
		return perfLatest;
	}
	
	/**
     * Process the HTTP response body for the user terminal performance query.
     *
     * @param    responseBody   The HTTP response body in JSON format.
     * @return                  The parsed user terminal performance data.
     */
    private static SNG_Perf.PerfLatest parseResponseBody(String response) 
    {
        return (SNG_Perf.PerfLatest)JSON.deserialize(response, SNG_Perf.PerfLatest.class);
    }
    
    private static SNG_Perf.PerfLatest generateFailedResponse() {
    	 return new SNG_Perf.PerfLatest(SNGHttpUtilities.Status.SERVER_ERROR, null);
    }
    
}