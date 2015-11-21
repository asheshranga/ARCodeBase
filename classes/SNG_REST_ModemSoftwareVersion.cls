public with sharing class SNG_REST_ModemSoftwareVersion 
{
     /**
     * Performs a HTTP callout to retrieve the version information for the given MAC address from the PmdrService.
     *
     * @param   macAddress     The list MAC addresses to lookup the version information for
     * @return                 The version information for the given MAC addresses.
     */    
    public static SNG_Perf.UtPhyVersion get(List<String> macAddresses)
    {
    	SNG_Perf.UtPhyVersion utPhyVersion = null;
    	
    	try
    	{
    	   HTTPResponse res = SNG_ModemSoftwareVersionHttpCallout.get(macAddresses);
    	   utPhyVersion = parseResponseBody(res.getBody());
    	}
    	catch (Exception e)
    	{
    	   System.debug(LoggingLevel.ERROR, 'Software version could not be retrieved.');
    	   utPhyVersion = new SNG_Perf.UtPhyVersion(SNGHttpUtilities.Status.SERVER_ERROR);
    	}
    	
    	return utPhyVersion;
    }

    /**
     * Process the HTTP response body for the user terminal version query.
     *
     * @param    responseBody   The HTTP response body in JSON format.
     * @return                  The parsed user terminal version data.
     */
    private static SNG_Perf.UtPhyVersion parseResponseBody(String response) 
    {
    	System.debug(LoggingLevel.ERROR, 'Body: ' + response);
        return (SNG_Perf.UtPhyVersion)JSON.deserialize(response, SNG_Perf.UtPhyVersion.class);
    }

}