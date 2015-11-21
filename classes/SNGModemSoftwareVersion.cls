public with sharing class SNGModemSoftwareVersion 
{
	/**
     * The HTTP path used to communicate with the PMDR Web service.
     */
    private static final transient String DB_PERF_HTTP_PATH =  SNGHttpUtilities.TOMCAT_SERVER.Url__c  + '/PmdrService/query/perf/phy/version/';
    
    /**
     * The timeout used for the HTTP request.
     */
    private static final transient integer PERF_VERSION_TIMEOUT_IN_MSEC = 5000;
    
    public static final transient String UNKNOWN_VERSION = 'Unknown Version';
    
	
	/**
     * Performs a HTTP callout to retrieve the version information for the given MAC address from the PmdrService.
     *
     * @param   macAddr The MAC address to lookup the version information for
     * @return          The version information for the given MAC address
     */
    public static String get(String macAddress) 
    {  
    	String softwareVersion = '';
    	
        try 
        {
            SNG_ExceptionUtil.throwIfNullObject(macAddress, 'MAC address to get usage history is NULL.');
            HttpResponse res = SNG_ModemSoftwareVersionHttpCallout.get(new String[]{ macAddress } );
            softwareVersion = processResponse(res, macAddress);
        }
        catch (SNG_Exception e)
        {
        	// If an exception is thrown from either throwIfNullObject, update usage fields for the Terminal
        	// NOTE: This is slightly different than how the generic Exception is handled. Here, the e.getMessage() is actually shown to the user.
            softwareVersion = SNG_TerminalQuery.UNABLE_TO_LOAD;
            SNGVisualforceErrorReporter.reportError(e, 'Software version could not be retrieved. ' + e.getMessage());
        }
        catch (Exception e) 
        {
            // If an exception is thrown from either throwIfNullObject, update usage fields for the Terminal
            softwareVersion = SNG_TerminalQuery.UNABLE_TO_LOAD;
            SNGVisualforceErrorReporter.reportError(e, 'Software version could not be retrieved.');
        }
        
        return softwareVersion;
    }
    
    /**
     * Processes the HTTP response for the user terminal version data from the PERF data.
     *
     * @param   httpResponse            The HTTP response from the PMDR Web service in JSON format.
     * @return                          The parsed user terminal version data, or UNKNOWN_VERSION if
     *                                  the status code returned was not OK (200).
     */
    private static String processResponse(HttpResponse httpResponse, String macAddress)
    {
    	String softwareVersion = '';
    	
        if (SNGHttpUtilities.isStatusCodeOK(httpResponse.getStatusCode()))
        {
            SNG_Perf.UtPhyVersion utPhyVersion = parseResponseBody(httpResponse.getBody(), macAddress);
            softwareVersion = utPhyVersion.result.get(0).SOFTWAREVERSION;
        }
        else
        {
            softwareVersion = UNKNOWN_VERSION;
        }
        
        return softwareVersion;
    }
    
    /**
     * Process the HTTP response body for the user terminal version query.
     *
     * @param    responseBody   The HTTP response body in JSON format.
     * @return                  The parsed user terminal version data.
     */
    private static SNG_Perf.UtPhyVersion parseResponseBody(String response, String macAddress) 
    {
        return (SNG_Perf.UtPhyVersion)JSON.deserialize(response, SNG_Perf.UtPhyVersion.class);
    }

}