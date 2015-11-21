/**
 * This class is used to communicate and retrieve the user terminal usage history for
 * a specified user terminal MAC address. The data retrieved consists of user terminal usage data
 * such as the byte count for upload and download usage.
 */
public with sharing class SNG_UtUsageHistory 
{
   /**
     * MAC Address of the modem which has this terminal associated. Set by Visualforce page
     */
    public String macAddress { get; private set; }
    
    /**
     * The start date for the request.
     */
    public String startDate { get; set; }
    
    /**
     * The end date for the request.
     */
    public String endDate { get; set; }
    
    /**
     * Data As Of. Timestamp of last update in milliseconds since midnight GMT January 1, 1970.
     */
    public Long dataAsOf { get { return repository.dataAsOf; } }  

    /**
     * String showing the bytes downloaded + units (for use by Visualforce)
     */
    public String bytesDownloadedStr { get { return repository.bytesDownloadedStr; }}
        
    /**
     * String showing the bytes uploaded + units (for use by Visualforce)
     */
    public String bytesUploadedStr { get { return repository.bytesUploadedStr; } }

    /**
     * The byte count units for the data based on how usage data accumulated.
     */
    public String byteCountUnit { get { return repository.byteCountUnit; } }
    
    /**
     * Download count array for use by Visualforce graph
     */
    public List<Decimal[]> downloadByteCountArr { get { return repository.downloadByteCountArr; } }
    
    /**
     * Upload byte count array for use by Visualforce graph
     */
    public List<Decimal[]> uploadByteCountArr { get { return repository.uploadByteCountArr; } }   
    
    /**
     * Flag to indicate whether valid data exists for the request. This flag is set to true upon
     * successly processing the response from Usage Service.
     */
    public boolean validData { get { return repository.validData; } }
    
    /**
     * The terminal object to get usage data for.
     */
    private Terminal__c terminal;
    
    /**
     * The usage history repository, where all the usage data resides.
     */
    private SNG_UtUsageHistoryRepository repository;
    
    /**
     * The data granularity in minutes.
     */
    private integer DATA_GRANULARITY_IN_MINUTES { get { return SNG_UtUsageHistoryRepository.DATA_GRANULARITY_IN_MINUTES; } }
    
    
    /**
     * This constructor is used to create an instance of the object. The constructor is
     * required due to usage by the Visualforce page corresponding to this class.
     *
     * @param  controller       The pre-built Visualforce controller for the terminal object.
     */
    public SNG_UtUsageHistory(ApexPages.StandardController controller)
    {
        this((Terminal__c)controller.getRecord());
    }
    
    
    /**
     * Creates an instance of this object.
     */
    public SNG_UtUsageHistory(Terminal__c terminal) 
    {          
    	this.terminal = terminal; 
        repository = new SNG_UtUsageHistoryRepository();
    }
    
    /**
     * Gets the usage history for the currently selected cycle.
     * This is called from the Visualforce page.
     */
    public void getUsageHistory() 
    {               
        try 
        {   
        	processRequest();
        }
        catch (SNG_Exception e)
        {
            repository.processException();
            // NOTE: This is slightly different than how the generic Exception is handled. Here, the e.getMessage() is actually shown to the user.
            // If an exception is thrown from throwIfNullObject or getHistory, update usage fields
            SNGVisualforceErrorReporter.reportError(e, 'Usage data could not be retrieved. ' + e.getMessage());
        }
        catch (Exception e) 
        {
            repository.processException();
            // If an exception is thrown from throwIfNullObject or getHistory, update usage fields
            SNGVisualforceErrorReporter.reportError(e, 'Usage data could not be retrieved. ');
        }
    }
    
    /**
     * Processes the request to calculate the usage history for a specified terminal and date range.
     *
     * @throws   SNG_Exception       If the mac address field is null or if there are no Modem / Service Plans
     *                               assigned to the terminal.
     */
    private void processRequest()
    {
    	Date startDate = Date.parse(startDate);
        Date endDate = SNG_DateUtils.min(SNG_DateUtils.todayGmt(), Date.parse(endDate));
    	
    	macAddress = SNG_Terminal.getModemMacAddressForTerminal(terminal);
    	SNG_ExceptionUtil.throwIfNullObject(macAddress, 'MAC address to get usage history is NULL.');
    	
	    List<ModemServicePlan__c> msps = SNG_Terminal.getMspForTerminal(terminal, startDate, endDate);
	    SNG_ExceptionUtil.assert(!ArrayUtils.isEmpty(msps), 'No Modem/Service Plan to get usage details for.');

        // need to map for the start date / end date of the msps. MSPS are in order, so this should work
        // as expected.
        Date mspStartDate = SNG_DateUtils.max(startDate, msps.get(0).StartDate__c);
        Date mspEndDate = SNG_DateUtils.min(endDate, msps.get(msps.size() - 1).EndDate__c);
        
        DateTime requestTimestamp = DateTime.Now();
        repository.processResponse(getHistory(msps, startDate, endDate), requestTimestamp, mspStartDate, mspEndDate);
    }
    
    /**
     * Retrieves the usage history for the given MAC address 
     * between the start and end dates provided
     *
     * @param   msps        The list of Modem / Service plans.
     * @param   startDate   First day in the requested range for usage data
     * @param   endDate     Last day in the requested range for usage data
     * @return              Usage history
     * @throws              SNG_CalloutException
     */     
    private SNG_UsageService.Response getHistory(List<ModemServicePlan__c> msps, Date startDate, Date endDate)
    {
        // perform post call
        List<SNG_ModemUsageDate> requestBody = buildRequestBody(msps, startDate, endDate);
        HttpResponse response = SNG_ModemUsageDataHttpCallout.post(requestBody, 
                                                                   SNG_ModemUsageDataHttpCallout.Grain.CUSTOM, 
                                                                   DATA_GRANULARITY_IN_MINUTES, 
                                                                   true,
                                                                   true);
        return processResponse(response);
    }
    
    
    /**
     * Processes the response from the HTTP request to the PmdrService to obtain the user terminal
     * usage history.
     *
     * @param    httpResponse            The HTTP response from the PMDR Web service.
     *                                   usage history.
     * @return                           The user terminal usage history data
     *                                   encapsulated in an object.
     * @throws   SNG_CalloutException    If the status in the HTTP response is not OK (200).
     */    
    private SNG_UsageService.Response processResponse(HttpResponse httpResponse)
    {
        SNG_UsageService.Response usageHistory = null;
        if (SNGHttpUtilities.isStatusCodeOK(httpResponse.getStatusCode()))
        {
            final String responseBody = httpResponse.getBody();
            usageHistory = parseResponseBody(responseBody);
        }
        else
        {
            System.Debug(LoggingLevel.ERROR, 'Response: ' + httpResponse.getStatus());
            throw new SNG_CalloutException('HTTP Status Code ' + httpResponse.getStatusCode() + ' returned. ' + httpResponse.getStatus());
        }
        
        return usageHistory;
    }
    
    /**
     * Builds the request body to be sent as part of the HTTP request to Usage Service Web service to determine the
     * usage data.
     *
     * @param   msps                     The Modem / Service Plans
     * @param   startDate                The start date for the request. This date is bound as the minimum allowed date
     * @param   endDate                  The end date for the request. This date is bound as the maximum allowed date.
     */
    private List<SNG_ModemUsageDate> buildRequestBody(List<ModemServicePlan__c> msps, Date startDate, Date endDate)
    {
    	List<SNG_ModemUsageDate> muds = new List<SNG_ModemUsageDate>();
    	
    	for (ModemServicePlan__c msp : msps)
        {
        	String macAddress = msp.Modem__r.Name;
        	if (null != macAddress)
            {
            	// Note: EndDate has to add a day since Usage Service treats end date as exclusive and not inclusive.
            	// Salesforce uses the end date as inclusive.
        	    muds.add( new SNG_ModemUsageDate(macAddress, 
        	                                     SNG_DateUtils.max(startDate, msp.StartDate__c),
        	                                     SNG_DateUtils.min(endDate, msp.EndDate__c).addDays(1)) );
            }
        }
        
        return muds;
    }
    
    /**
     * Process the HTTP response body for the peer online data.
     *
     * @param    response   The HTTP response body in JSON format.
     */
    private SNG_UsageService.Response parseResponseBody(String responseBody)
    {
        return SNG_UsageService.deserialize(responseBody);
    }
}