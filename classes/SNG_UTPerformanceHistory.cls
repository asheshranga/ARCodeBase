/**
 * This class is used to communicate and retrieve the user terminal physical(PHY) history for
 * a specified user terminal MAC address. The history is retrievable up to maximum of 60 days
 * for a specified MAC address. The data retrieved consists of user terminal information
 * such as the signal-to-noise ratio for a forward link and return link symbol rate. Additional
 * fields may be retrieved if the user is an adminstrator to obtain more information granularity.
 */
global with sharing class SNG_UTPerformanceHistory
{
    /**
     * MAC Address of the modem which has this terminal associated
     */
    public String perfMacAddress {get; private set;}
        
    //TODO: Update startDate and endDate with validators to validate the date.
    public String performanceStartDate { get; set; }
        
    public String performanceEndDate { get; set; }
        
    public Date startDate { get { return Date.parse(performanceStartDate); } }
        
    public Date endDate { get { return Date.parse(performanceEndDate); } }
        
    public transient SNG_Perf.UtPhyHistoryInternal internalPhyHistory { get; private set; }
        
    public transient boolean performanceCurrentBillingCycle { get; set; }
        
    public transient boolean performanceRefresh { get; set; }
        
    /**
     * ID for the Modem
     */
    private Id modemId;
        
    /**
     * FL byte count array for use by Visualforce graph
     */
    public transient List<Decimal[]> uploadSymRateArr {get; private set;}
    
    /**
     * RL byte count array for use by Visualforce graph
     */
    public transient List<Decimal[]> downloadSinrArr {get; private set;}
        
    /**
     * References the specified terminal record to update.
     */ 
    private Terminal__c terminal;
        
    /**
     * The HTTP path used to communicate with the PMDR Web service.
     */
    private static final transient String DB_PERF_HTTP_PATH = SNGHttpUtilities.TOMCAT_SERVER.Url__c + '/PmdrService/query/perf/phy/history/';
   
    /**
     * The timeout used for the HTTP request.
     */
    private static final transient integer PERF_HISTORY_TIMEOUT_IN_MSEC = 
        Integer.valueOf(SNGKeyValueStore__c.getValues(Label.SNGPmdrHttpCalloutTimeoutSec).Value__c);
    
    
    private static final transient integer ONE_SEC_IN_MSEC = 1000;
    
    private static final transient integer ONE_MIN_IN_SEC = 60;
    
    private static final transient String OFFLINE = 'Offline';
    
    /**
     * This constructor is used to create an instance of the object. The constructor is
     * required due to usage by the Visualforce page corresponding to this class.
     *
     * @param  controller       The pre-built Visualforce controller for the terminal object.
     */
    public SNG_UTPerformanceHistory(ApexPages.StandardController controller)
    {
        initialize((Terminal__c)controller.getRecord());
    }
    
    
    /**
     * This constructor is used by SNGTerminalTab to create an instance of SNGUtUsageHistory
     *
     * @param   terminal        terminal object to get usage history
     */ 
    public SNG_UTPerformanceHistory(Terminal__c terminal) 
    { 
        initialize(terminal);
    }
    
    
    private void initialize(Terminal__c assignTerminal)
    {
        try 
        {
            terminal = assignTerminal;
            uploadSymRateArr = new List<Decimal[]>();
            downloadSinrArr = new List<Decimal[]>();
            perfMacAddress = SNG_Terminal.getModemMacAddressForTerminal(terminal);
            modemId = SNG_Terminal.getModemIdForTerminal(terminal);
        } 
        catch (Exception e) 
        {
            defaultTerminalNoData(terminal);
            throw new SNG_Exception(SNG_HtmlUtilities.getHtmlMessageCenteredBoldRedFontFormat(e.getMessage()));
        }
    }
    
    /**
     * Obtains the performance history of the user terminal MAC address specified in the constructor, capturing
     * the performance data up to the specified number of days.
     * This is called from the Visualforce page.
     */
    public void getPerformanceHistory()
    {
        try 
        {   
        	SNG_ExceptionUtil.throwIfNullObject(perfMacAddress, 'MAC address to get performance history is NULL.');
            SNG_ExceptionUtil.throwIfNullObject(performanceStartDate, 'Start Date for performance history is not set.');
            SNG_ExceptionUtil.throwIfNullObject(performanceEndDate, 'End date for performance history is not set.');
        	
        	List<ModemServicePlan__c> msps = SNG_Terminal.getMspForTerminal(terminal, startDate, endDate);
            SNG_ExceptionUtil.assert(!ArrayUtils.isEmpty(msps), 'No Modem/Service Plan to get performance history.'); 
           
            Date startDate = calculateMaxStartDate(msps, Date.parse(performanceStartDate));
            Date endDate = calculateMinEndDate(msps, Date.parse(performanceEndDate));

            internalPhyHistory = getHistoryInternal(perfMacAddress, startDate, endDate);
            //SNG_Perf.UtPhyHistoryInternal internalPhyHistory = getHistoryInternal(macAddress, msp.StartDate__c, today);
            parseInternalDataForVf(internalPhyHistory.result);
                
        }
        catch (SNG_Exception e)
        {
            defaultTerminalNoData(terminal);
        	// NOTE: This is slightly different than how the generic Exception is handled. Here, the e.getMessage() is actually shown to the user.
        	SNGVisualforceErrorReporter.reportError(e, 'Performance data could not be retrieved. ' + e.getMessage());
        }
        catch (Exception e) 
        {
            defaultTerminalNoData(terminal);
        	SNGVisualforceErrorReporter.reportError(e, 'Performance data could not be retrieved.');
        }
    }
    
    /**
     * Calculates the maximum date between the Modem / Service and the date range. This is required since the Modem / Service Plan
     * Start date can be out of range or start after the specified performance start date requested. The list of MSPs are modem / service
     * plans for the modem that fall within the date ranges specified (performance start date - performance end date). 
     * The performance start date is the requested UT Performance History start date.
     *
     * @param    msps                   The Modem / Service Plans.
     * @param    performanceStartDate   The requested performance start date.
     * @return                          The maximum start date between the MSP and the performance start date.
     */    
    private Date calculateMaxStartDate(List<ModemServicePlan__c> msps, Date performanceStartDate)
    {
        SNG_ExceptionUtil.assert(!ArrayUtils.isEmpty(msps), 'Improper method usage. ModemServicePlan list must not be empty.');
        SNG_ExceptionUtil.throwIfNullObject(performanceStartDate, 'Performance start date cannot be NULL');
        Date minDate = msps.get(0).StartDate__c;
        
        // find the minimum date to find the minimum start date that falls within the requested date range 
        // (performance start date - performance end date)
        for (ModemServicePlan__c msp : msps)
        {
            minDate = SNG_DateUtils.min(msp.StartDate__c, minDate);
        }
        
        return SNG_DateUtils.max(minDate, performanceStartDate);
    }
    
    /**
     * Calculates the maximum date between the Modem / Service and the Date Range. This is required since the Modem / Service Plan
     * end date can be out of range or end after the specified performance end date requested. The performance end date is the
     * requested UT Performance History start date.
     *
     * @param    msps                   The Modem / Service Plans.
     * @param    performanceStartDate   The requested performance end date.
     * @return                          The maximum start date between the MSP and the performance start date.
     */
    private Date calculateMinEndDate(List<ModemServicePlan__c> msps, Date performanceEndDate)
    {
        SNG_ExceptionUtil.assert(!ArrayUtils.isEmpty(msps), 'ModemServicePlan list must not be empty.');
        SNG_ExceptionUtil.throwIfNullObject(performanceEndDate, 'Performance start date cannot be NULL');
        Date maxDate = msps.get(0).EndDate__c;
        
                
        // find the maximum date to find the maximum end date that falls within the requested date range 
        // (performance start date - performance end date)
        for (ModemServicePlan__c msp : msps)
        {
            maxDate = SNG_DateUtils.max(msp.EndDate__c, maxDate);
        }
        
        return SNG_DateUtils.min(maxDate, performanceEndDate);
    }
    
    
    /**
     * Parses the data for use by Visualforce
     * @param   performanceData   The deserialized JSON response for the performance data request
     */
    private void parseInternalDataForVf(List<SNG_Perf.UtPhyStatusInternal> performanceData) {
        uploadSymRateArr = new List<Decimal[]>();
        downloadSinrArr = new List<Decimal[]>();        
        
        for (SNG_Perf.UtPhyStatusInternal dataSample : performanceData) {
            Long timeInMSec = Long.valueOf(dataSample.UTTIME) * 1000;
            Decimal uploadSymRate = (Decimal) (dataSample.UTRLSYMBOLRATE)/1000;
            Decimal downloadSinr = (Decimal)(dataSample.UTFLSINR);
            uploadSymRateArr.add(new Decimal[] {timeInMSec, uploadSymRate});
            downloadSinrArr.add(new Decimal[] {timeInMSec, downloadSinr});
        }
        
        updatePerformanceLatestData(performanceData);
    }
    
    private void updatePerformanceLatestData(List<SNG_Perf.UtPhyStatusInternal> performanceData)
    {
        // OnlineTime__c is only set if the current billing cycle is selected. If not current billing cycle, do not change. 
        if (performanceCurrentBillingCycle)
        {
            if (!performanceData.isEmpty())
            {
                SNG_Perf.UtPhyStatusInternal lastData = performanceData[performanceData.size() - 1];
                terminal.UploadSymbolRateBackEnd__c = (lastData.UTRLSYMBOLRATE != null)  ? lastData.UTRLSYMBOLRATE : 0;
                terminal.DownloadSinrBackEnd__c = (lastData.UTFLSINR != null) ? lastData.UTFLSINR : 0;
                terminal.OnlineTime__c = isTerminalOffline(lastData) ? OFFLINE : SNGTimeUtil.getTimeString(SNGTimeUtil.translateOnlineTime(lastData.UTONLINETIME));             
                update terminal; 
            }
            else
            {
                // note: method invokes update of terminal object.
                defaultTerminalNoData(terminal);	                 
            }           
         }         
    }

    /**
     * This method is used to default the terminal to no data. This method can be used when an exception occurs or
     * there is no data from the PMDR service.
     */
    private void defaultTerminalNoData(Terminal__c terminal)
    {
        if (null != terminal)
        {
            // no results
            terminal.UploadSymbolRateBackEnd__c = 0;
            terminal.DownloadSinrBackEnd__c = 0;
            terminal.StatusBackEnd__c = SNG_TerminalQuery.UNABLE_TO_LOAD;                 
            terminal.OnlineTime__c = OFFLINE;
            update terminal;    
        }  
    }
    
    
    private boolean isTerminalOffline(SNG_Perf.UtPhyStatusInternal dataSample)
    {           
        boolean isOffline = (null == dataSample.UTONLINETIME);

        if (!isOffline)
        {   SNGKeyValueStore__c keyValueStore = SNGKeyValueStore__c.getValues(Label.SNGPmdrValidThresholdMinutes);
            long onlineThresholdInSec = Long.valueOf(keyValueStore.Value__c) * ONE_MIN_IN_SEC;      
            long differenceInSec = DateTime.now().getTime() / ONE_SEC_IN_MSEC - Long.valueOf(dataSample.UTTIME);
            isOffline = (onlineThresholdInSec < differenceInSec);
        }
        
        return isOffline;
    }
    
    
    /**
     * Obtains the internal performance history structure of the user terminal MAC address, capturing
     * the performance data up to the specified number of days.
     *
     * @param   macAddr         The MAC address of the user terminal to retrieve
     *                          performance history.
     * @param   days            The specified number of days to retrieve performance data.
     *                          The maximum number of days is capped at 60 days.
     * @return                  The internal performance history structure of the MAC address up to the
     *                          specified number of days.
     */
    private SNG_Perf.UtPhyHistoryInternal getHistoryInternal(String macAddress, Date startDate, Date endDate)
    {
        SNG_ExceptionUtil.throwIfNullObject(macAddress, 'MAC address to get usage history is NULL.');
        
        SNG_Perf.UtPhyHistoryInternal performanceHistory = null;
        // Caching disabled
           //SNGModemViewStateRepository.getCachedPerformance(modemId, startDate, endDate, performanceCurrentBillingCycle, performanceRefresh);

  		HttpResponse res = SNG_PerformanceHistoryRetrieval.getPerformanceHistory(macAddress, startDate, endDate); 
  		performanceHistory = processResponse(res, macAddress);              
        
        return performanceHistory;
    }
    
    
 
   /**
    * Processes the response from the HTTP request to the PmdrService to obtain the user terminal
    * physical history.
    *
    * @param    httpResponse            The HTTP response from the PerfMonDataRetrieval Web service.
    *                                   performance history.
    * @param    macAddress              The MAC address of the user terminal queried.
    * @return                           The user terminal physical history data
    *                                   encapsulate in an object.
    * @throws   SNG_CalloutException    If the status in the HTTP response is not OK (200).
    */    
    private SNG_Perf.UtPhyHistoryInternal processResponse(HttpResponse httpResponse, String macAddress)
    {
        SNG_Perf.UtPhyHistoryInternal utPhyHistory = null;
        if (SNGHttpUtilities.isStatusCodeOK(httpResponse.getStatusCode()))
        {
            final String responseBody = httpResponse.getBody();
            //cachePerformance(modemId, DateTime.now(), responseBody, startDate, endDate);
            utPhyHistory = parseResponseBody(responseBody);
        }
        else
        {
            System.Debug(LoggingLevel.ERROR, 'Response: ' + httpResponse.getStatus());
            System.Debug(LoggingLevel.ERROR, 'Response Body: ' + httpResponse.getBody());
            throw new SNG_CalloutException('HTTP Status Code ' + httpResponse.getStatusCode() + ' returned. ' + httpResponse.getStatus());
        }
        
        return utPhyHistory;
    }
    
    /**
     * Process the HTTP response body for the user terminal physical history.
     *
     * @param    response   The HTTP response body in JSON format.
     * @return              The JSON response body deserialized into a SNG_Perf.UtPhyHistoryInternal object
     */
    private static SNG_Perf.UtPhyHistoryInternal parseResponseBody(String response) 
    {
        return (SNG_Perf.UtPhyHistoryInternal)JSON.deserialize(response, SNG_Perf.UtPhyHistoryInternal.class);
    }
}