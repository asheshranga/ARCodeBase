/**
 * This class is used to communicate and retrieve the user terminal physical(PHY) information for
 * a specified user terminal MAC address. The data retrieved consists of user terminal information
 * such as the signal-to-noise ratio for a forward link, return link symbol rate, current status, and
 * online time. Additional granularity may be retrieved for the user terminal state if the user is 
 * an adminstrator to obtain more information granularity.
 */
public with sharing class SNG_UTPerformanceFromPerf 
{
	/**
	 * MAC Address of the modem which has this terminal associated
	 */
	public String macAddress {get; private set;}
	
	
	public String onlineTime {get {return ( null == onlineTime ) ? '' : onlineTime; } private set; }
	
	
	/**
	 * References the specified terminal record to update.
	 */ 
	private Terminal__c terminal;
	
	/**
	 * The HTTP path used to communicate with the PMDR Web service.
	 */
	private static final transient String DB_PERF_HTTP_PATH =  SNGHttpUtilities.TOMCAT_SERVER.Url__c  + '/PmdrService/query/perf/phy/latest/';
    
    /**
     * The timeout used for the HTTP request.
     */
    private static final transient integer PERF_HISTORY_TIMEOUT_IN_MSEC = 5000;
    
    
    /**
     * This constructor is used to create an instance of the object. The constructor is
     * required due to usage by the Visualforce page corresponding to this class.
     *
     * @param  controller       The pre-built Visualforce controller for the terminal object.
     */
	public SNG_UTPerformanceFromPerf(ApexPages.StandardController controller) 
	{
		this((Terminal__c)controller.getRecord());
	}
    
    /**
     * This constructor is used by SNGTerminalTab to create an instance of the object.
     *
     * @param   terminalObj       terminal object to get performance data
     */ 
    public SNG_UTPerformanceFromPerf(Terminal__c terminalObj) 
    { 
    	initialize(terminalObj);
    }
        
    /**
     * Retrieves the user terminal performance for a specified terminal. The call is
     * accessible through a Visualforce page.
     */
    public void getUTPerformance()
    {
        try
        {
           initializePropertiesBeforeQuery();
           SNG_ExceptionUtil.throwIfNullObject(macAddress, 'MAC address to get performance data is NULL.');
    	   updateObject(getUTPerformance(macAddress));
        }
        catch (SNG_Exception e)
        {
        	// NOTE: This is slightly different than how the generic Exception is handled. Here, the e.getMessage() is actually shown to the user.
        	SNGVisualforceErrorReporter.reportError(e, 'Performance data could not be retrieved. ' + e.getMessage());
        }
        catch (Exception e)
        {
            SNGVisualforceErrorReporter.reportError(e, 'Performance data could not be retrieved.');
        }
    }
    
    
    private void initialize(Terminal__c controller)
    {
        terminal = controller;
        macAddress = SNG_Terminal.getModemMacAddressForTerminal(terminal);
    }
    
    private void initializePropertiesBeforeQuery()
    {
        onlineTime = null;
    }
    
    
    /**
     * Retrieves the user terminal performance for a specified modem MAC address. 
     * The method is accessible through a third-party API call.
     * @param 	macAddress   	The MAC address of the user terminal to retrieve
     *        	             	performance data.
     * @return	             	The performance data for the specified modem MAC 
     *        	             	address.
     * @throws	SNG_Exception	If the specified MAC address is null.
     */
    private static SNG_Perf.UtPhyLatest getUTPerformance(String macAddr) 
    {
    	SNG_Perf.UtPhyLatest utPerformance = null;
    	
    	try 
    	{
    		String url = DB_PERF_HTTP_PATH + macAddr;
        	HttpResponse res = SNG_HttpCallout.sendHttpGetRequest(url, PERF_HISTORY_TIMEOUT_IN_MSEC, true);
        	utPerformance = processResponse(res, macAddr);
    	} 
    	catch (Exception e) 
    	{
    		utPerformance = new SNG_Perf.UtPhyLatest(SNGHttpUtilities.Status.SERVER_ERROR, new SNG_Perf.UtPhyLatestResult(null, SNG_TerminalQuery.UNABLE_TO_LOAD, null, null, macAddr));
    	}
    	
    	return utPerformance;
    }
    
    /**
     * Updates the user terminal object with performance data retrieved from
     * the Performance and Monitor Data Retrieval (PMDR) Web service.
     *
     * @param   utPerformance   The UT performance data retrieved from the
     *                          PMDR Web service.
     */
    private void updateObject(SNG_Perf.UtPhyLatest utPerformance) 
    {
    	// update the object with current performance data
    	if (null != utPerformance && SNGHttpUtilities.Status.OK.name() == utPerformance.status)
    	{
	    	terminal.UploadSymbolRateBackEnd__c = (utPerformance.result[0].UTRLSYMBOLRATE != null)  
	    	                                       ? utPerformance.result[0].UTRLSYMBOLRATE : 0;
	    	terminal.DownloadSinrBackEnd__c = (utPerformance.result[0].UTFLSINR != null) 
	    	                                  ? utPerformance.result[0].UTFLSINR : 0;
	    	terminal.StatusBackEnd__c = (utPerformance.result[0].UTSTATE != null) 
	    	                            ? SNG_Perf.getPrettyStateString(SNG_Perf.toUTState(utPerformance.result[0].UTSTATE)) : SNG_TerminalQuery.UNABLE_TO_LOAD;
	    	terminal.OnlineTime__c = (null != utPerformance.result[0].UTONLINETIME && SNG_TerminalQuery.UNABLE_TO_LOAD != utPerformance.result[0].UTONLINETIME) 
	    	                            ? getTimeString(SNG_SnmpDateAndTimeConverter.translateTimeToDurationFromNow(utPerformance.result[0].UTONLINETIME)) : SNG_TerminalQuery.UNABLE_TO_LOAD;
    	}
	    else
	    {
	    	// no results
	    	terminal.UploadSymbolRateBackEnd__c = 0;
	    	terminal.DownloadSinrBackEnd__c = 0;
	    	terminal.StatusBackEnd__c = SNG_TerminalQuery.UNABLE_TO_LOAD;
	    	terminal.OnlineTime__c = SNG_TerminalQuery.UNABLE_TO_LOAD;
	    }
	    
	    onlineTime = terminal.OnlineTime__c;
	    System.Debug('Online time: ' + onlineTime);
    	System.Debug('Terminal StatusBackEnd: ' + terminal.StatusBackEnd__c);
    	System.debug('Terminal ID: ' + terminal.Id);
    	update terminal;
    	
    	updateTrafficLights();	
    }
    
    
    private void updateTrafficLights()
    {            
        Terminal__c updatedTerminal = [SELECT Performance__c, Pointing__c FROM Terminal__c WHERE Id = :terminal.Id];
    }
    
    /**
     * Processes the HTTP response for the user terminal performance data from the PERF data.
     *
     * @param 	httpResponse        	The HTTP response from the PMDR Web service in JSON format.
     * @return	                    	The parsed user terminal performance data.
     * @throws	SNG_CalloutException	If the status of the HTTP response is not OK (200).
     */
    private static SNG_Perf.UtPhyLatest processResponse(HttpResponse httpResponse, String macAddress)
	{
		SNG_Perf.UtPhyLatest utPhyLatest = null;
		if (SNGHttpUtilities.isStatusCodeOK(httpResponse.getStatusCode()))
		{
			utPhyLatest = parseResponseBody(httpResponse.getBody(), macAddress);
		}
		else
		{
			System.Debug(LoggingLevel.ERROR, 'Response: ' + httpResponse.getStatus());
            throw new SNG_CalloutException('HTTP Status Code ' + httpResponse.getStatusCode() + ' returned. ' + httpResponse.getStatus());
		}
		
		return utPhyLatest;
	}
	
	/**
     * Formats the seconds data into a stringified format 
     * (day/hour/minute/second) for display.
     * 
     * @param   second          The seconds data to format.
     * @return                  A stringified time in day/hour/minute/second
     */
    public static String getTimeString(Long seconds) 
    {
    	String timeString = '';
    	
    	if (seconds > 0) {
    		Long days = seconds / (60 * 60 * 24);
	    	if (days > 0) {
	    		seconds -= days * (60 * 60 * 24);
	    		timeString += days + ' days';
	    		if (seconds != 0) {
	    			timeString += ', ';
	    		}
	    	}
	    	
	    	Long hours = seconds / 3600;
	    	if (hours > 0) {
	    		seconds -= hours * 3600;
	    		timeString += hours + ' hours';
	    		if (seconds != 0) {
	    			timeString += ', ';
	    		}
	    	}
			
			Long minutes = seconds / 60;
			if (minutes > 0) {
				seconds -= minutes * 60;
				timeString += minutes + ' minutes';
				if (seconds != 0) {
	    			timeString += ', ';
	    		}
			}
			
			if (seconds > 0) {
				timeString += seconds + ' seconds';
			}
    	} else {
    		timeString = 'Offline';
    	}
		
    	return timeString;
    }

    /**
     * Process the HTTP response body for the user terminal performance query.
     *
     * @param    responseBody   The HTTP response body in JSON format.
     * @return                 The parsed user terminal performance data.
     */
    private static SNG_Perf.UtPhyLatest parseResponseBody(String response, String macAddress) 
    {
        return (SNG_Perf.UtPhyLatest)JSON.deserialize(response, SNG_Perf.UtPhyLatest.class);
    }
}