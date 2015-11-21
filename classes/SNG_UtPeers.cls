public with sharing class SNG_UtPeers 
{
	
	/**
     * The HTTP path used to communicate with the Usage service.
     * An optional granularity filter can be passed in if desired. If the filter is not specified, 
     * a day granularity will be used by UsageService. 
     */
    public static final String PMDR_HTTP_PATH =  SNGHttpUtilities.TOMCAT_SERVER.Url__c  + '/PmdrService/query/perf/peer/latest/avg/'; 
	
	/**
	 * The list of terminal objects to obtain the peer online data for.
	 */
	private List<Terminal__c> terminalList;

    /**
     * Conversion of one second into milliseconds.
     */
    private static final Integer ONE_SEC_IN_MSEC = 1000;
	
	/**
	 * The timeout for the bulk HTTP request.
	 */
	private static integer PMDR_BULK_PEER_TIMEOUT_IN_MSEC = 
        Integer.valueOf(SNGKeyValueStore__c.getValues(Label.SNGPmdrHttpCalloutTimeoutSec).Value__c) * ONE_SEC_IN_MSEC;
	
	/**
	 * Default OpenAM Login cookie to be cached.
	 */
	private static final boolean CACHE_COOKIE = true;
	
	
	/**
     * This constructor is used to create an instance of the object. The constructor is
     * required due to usage by the Visualforce page corresponding to this class.
     *
     * @param  controller       The pre-built Visualforce controller for the terminal object.
     */
    public SNG_UtPeers(ApexPages.StandardController controller)
    {
         Terminal__c terminal = ((Terminal__c)controller.getRecord());
         terminal.MacAddress__c = SNG_Terminal.getModemMacAddressForTerminal(terminal);
         terminalList = new List<Terminal__c>{ terminal };
    }
    
	
    /**
     * This constructor is used to create an instance of the object. The constructor is
     * required due to usage by the Visualforce page corresponding to this class.
     *
     * @param  controller       The pre-built Visualforce controller for the terminal object.
     */
    public SNG_UtPeers(List<Terminal__c> terminals)
    {
        terminalList = terminals;
    }
    
    public void getPeersOnlineData() 
    {
        process();	
    }
    
    /**
     * The main entry point of the request. This method processes the request to obtain the peer online data.
     */
    public void process()
    {
        Map<String, Terminal__c> macAddressToTerminal = createMacAddressToTerminalMap(terminalList);
        getPeersOnlineData(macAddressToTerminal);
    }
    
    
    /**
     * This method is used to obtain and update the peer online data results.
     *
     * @param   macAddressToTerminal      Contains a mapping between the mac address to its terminal object. 
     */
    private void getPeersOnlineData(Map<String, Terminal__c> macAddressToTerminal) 
    {            
        try 
        {
            SNG_Perf.UtPeerDataLatest peerData = getPeerData(macAddressToTerminal.keySet());
            SNG_UtPeersUpdater.process(macAddressToTerminal, peerData);
        }
        catch (SNG_Exception e)
        {

            SNG_UtPeersUpdater.process(macAddressToTerminal, null);
            // NOTE: This is slightly different than how the generic Exception is handled. Here, the e.getMessage() is actually shown to the user.
            SNGVisualforceErrorReporter.reportError(e, 'Peer online data could not be retrieved. ' + e.getMessage());
        }
        catch (Exception e) 
        {
            SNG_UtPeersUpdater.process(macAddressToTerminal, null);
            SNGVisualforceErrorReporter.reportError(e, 'Peer online data could not be retrieved.');
        }
    }
    
    /**
     * Performs the HTTP callout to obtain the peer online data.
     *
     * @param   macAddresses              The list of MAC addresses to query for.
     * @return                            The response data from the web service. The response body returned
     *                                    from the web service is mapped to the UtPeerDataLatest object.
     */
    private SNG_Perf.UtPeerDataLatest getPeerData(Set<String> macAddresses)
    {
        SNGKeyValueStore__c keyValueStore = SNGKeyValueStore__c.getValues(Label.SNGPmdrValidThresholdMinutes);
        HttpResponse res = SNG_UtPeersHttpCallout.post(PMDR_HTTP_PATH,
                                                       new List<String>(macAddresses), 
                                                       Integer.valueOf(keyValueStore.Value__c), 
                                                       PMDR_BULK_PEER_TIMEOUT_IN_MSEC,
                                                       CACHE_COOKIE);
        return processResponse(res);
    }
    
        
   /**
    * Processes the response from the HTTP request to the PmdrService to obtain the peer online
    * data.
    *
    * @param    httpResponse            The HTTP response from the PMDR Web service.
    *                                   usage history.
    * @return                           The user terminal usage history data
    *                                   encapsulated in an object.
    * @throws   SNG_CalloutException    If the status in the HTTP response is not OK (200).
    */    
    private SNG_Perf.UtPeerDataLatest processResponse(HttpResponse httpResponse)
    {
        SNG_Perf.UtPeerDataLatest peerOnlineData = null;
        if (SNGHttpUtilities.isStatusCodeOK(httpResponse.getStatusCode()))
        {
            final String responseBody = httpResponse.getBody();
            peerOnlineData = parseResponseBody(responseBody);
        }
        else
        {
            System.Debug(LoggingLevel.ERROR, 'Response: ' + httpResponse.getStatus());
            throw new SNG_CalloutException('HTTP Status Code ' + httpResponse.getStatusCode() + ' returned. ' + httpResponse.getStatus());
        }
        
        return peerOnlineData;
    }
    
    /**
     * Creates a mapping between the MAC address and it's corresponding terminal object. Any MAC address
     * without a terminal object is ignored.
     *
     * @param    terminals              The collection of terminals to map to a MAC address.
     * @return                          A mapping from the MAC address to its terminal object.
     */
    private Map<String, Terminal__c> createMacAddressToTerminalMap(List<Terminal__c> terminals)
    {
    	Map<String, Terminal__c> macAddressToTerminal = new Map<String, Terminal__c>();
    	for (Terminal__c terminal : terminals)
    	{
    	    if (null != terminal.MacAddress__c)
    	        macAddressToTerminal.put(terminal.MacAddress__c.toLowerCase(), terminal);
    	}
    	
    	return macAddressToTerminal;
    }
    
    /**
     * Process the HTTP response body for the peer online data.
     *
     * @param    response   The HTTP response body in JSON format.
     */
    private SNG_Perf.UtPeerDataLatest parseResponseBody(String responseBody)
    {
    	return (SNG_Perf.UtPeerDataLatest)JSON.deserialize(responseBody, SNG_Perf.UtPeerDataLatest.class);
    }
}