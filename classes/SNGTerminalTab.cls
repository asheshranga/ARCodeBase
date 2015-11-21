/**
 * This is a custom list controller for the Terminal__c tab.
 */
global with sharing class SNGTerminalTab 
{
    /**
     * The set of terminals
     */
    public List<Terminal__c> terminals { get; set; }
        
    public String terminalId { get; set; }
    
    // True if user is admin
    public boolean userAdmin { get { return SNGVisualforceRender.userAdmin; } }
   
    public String sortExpression { get { return sorting.sortExpression; } set { sorting.sortExpression = value; } }

    public List<Terminal__c> displayTerminals { get { return paging.displaySObjects; } }
    // The current page of Terminals that is being displayed to the user
    public String pageNumberStr { get { return paging.pageNumberStr;}  set { paging.pageNumberStr = value; } }   
    
    // The total amount of pages 
    public integer totalPages { get { return paging.totalPages; } }
    
    public integer noop { get; set; }
    
    public String recordInfo { get { return paging.recordInfo; } }
    
    
    // boolean to determine if next command link in service plan table should be displayed 
    public boolean isNextValid { get { return paging.isNextValid; } } 
    // boolean to determine if prev command link in service plan table should be displayed
    public boolean isPrevValid { get { return paging.isPrevValid; } } 
    // the amount of service plans to display to user at one time
    private integer amountToDisplay = 10;  
    
    private SNGTabPaging paging;
    private SNGTabColumnSort sorting;
    
    private static final transient String BASIC_QUERY = 'SELECT Id, Name, Nickname__c, MacAddress__c, Status__c, TerminalType__c, TerminalType__r.Name, SerialNumber__c, GbUploaded__c, GbDownloaded__c, GbTotal__c, UploadSymbolRateBackEnd__c, DownloadSinrBackEnd__c, StatusBackEnd__c, OnlineTime__c FROM Terminal__c';
    
    @TestVisible 
    private static final transient String OFFLINE = 'Offline';
    
    /**
     * Default constructor. 
     * Initializes the list of terminals, and the ApexPages.StandardSetController.
     * This constructor is called from the Visualforce page upon page load.
     */
    public SNGTerminalTab() 
    {
        terminals = Database.query(BASIC_QUERY);
        paging = new SNGTabPaging(terminals);
        sorting = new SNGTabColumnSort(BASIC_QUERY);
    }

    @TestVisible 
    private void updateUsageData(boolean allowCookieCaching)
    {
        try
        {
            SNG_ExceptionUtil.throwIfNullObject(terminals, 'No terminals to obtain status for.');
            processUsageDataRequest(terminals, allowCookieCaching);
        }
        catch (Exception e)
        {
            // The downstream call handles Exceptions already. No need to seperate SNG_Exception from Exception.
            SNGVisualforceErrorReporter.reportError(e, 'Usage data could not be retrieved. ' + e.getMessage());
        }
    }
    
	/**
	 * Updates latest performance data for terminals
	 */
	@TestVisible 
	private void updatePerformanceData(boolean allowCookieCaching)
	{
		try 
		{
			SNG_ExceptionUtil.throwIfNullObject(terminals, 'No terminals to obtain status for.');
			
			List<String> macAddresses = getMacAddressesFromTerminals(terminals);
			
			// Update all the terminals in one bulk call using the MAC addresses of the terminals
			processPerformanceLatestRequest(macAddresses, terminals, allowCookieCaching); 
		}
		catch (Exception e) 
		{ 
			// The downstream call handles Exceptions already. No need to seperate SNG_Exception from Exception.
    		SNGVisualforceErrorReporter.reportError(e, 'Performance data could not be retrieved. ' + e.getMessage());
		}
	}
	
	/**
	 * Updates terminals to the Salesforce database
	 */
	public void updateTerminals() 
	{
		updateUsageData(false);
		updatePerformanceData(true);
		update terminals; 
	}
	
	
    /**
     * Updates paging object with updated List<Terminal__c> terminals
     */ 
    public void updateTable() 
    { 
        terminals = Database.query(BASIC_QUERY);
    	paging.updateDisplay(terminals); 
    }

    public void gotoPage()
    {
    	paging.gotoPage();
    }
    
    public void getPrevPage()
    {
    	paging.getPrevPage();
    }
    
    public void getNextPage()
    {
    	paging.getNextPage();
    }
    
    public void getFirstPage()
    {
    	paging.getFirstPage();
    }
    
    public void getLastPage()
    {
        paging.getLastPage();    	
    }
    
    public String getSortDirection()
    {
       return sorting.getSortDirection();
    }

    public void setSortDirection(String value)
    {  
       sorting.setSortDirection(value);
    }
       
    public PageReference ViewData() 
    {
       terminals = sorting.ViewData();
       paging.updateDisplay(terminals);
       return null;
    }
    
    @RemoteAction
    global static String getStatusTrafficLight(Id terminalId)
    {
    	return SNG_TerminalQuery.getStatusTrafficLight(terminalId);
    }
    
    private void processUsageDataRequest(List<Terminal__c> terms, boolean allowCookieCaching)
    {
        SNG_UtUsageAggregate utUsageAggregate = createUsageAggregateObject(terms, allowCookieCaching);
        utUsageAggregate.process();
    }

	/**
	 * Retrieve performance data and update the terminals
	 */
	private void processPerformanceLatestRequest(List<String> macAddresses, List<Terminal__c> termList, boolean allowCookieCaching)
	{
		// Perform callout to PMDR Service to retrieve performance latest statistics
		SNG_Perf.PerfLatest perfLatest = SNG_PerformanceLatest.getPerformance(macAddresses, allowCookieCaching);
		
		// Create a mapping of mac addresses to their corresponding retrieved performance data
		Map<String,SNG_Perf.PerfLatestResult> macAddrToPerfData =  generateMacAddressToPerfLatestResult(perfLatest);
		
		// update the terminals with the new performance latest data
		updateTerminalsPerfData(macAddrToPerfData, termList);
	}    

    private SNG_UtUsageAggregate createUsageAggregateObject(List<Terminal__c> terms, boolean allowCookieCaching)
    {   
    	Date beginningOfCurrentMonth = SNG_DateUtils.todayGmt().toStartOfMonth();
        SNG_UtUsageAggregate usageAggregate = new SNG_UtUsageAggregate(terms, 
                                                                       beginningOfCurrentMonth, 
                                                                       beginningOfCurrentMonth.addMonths(1),
                                                                       allowCookieCaching);
        return usageAggregate;
    }
    
    /**
	 * Creates a list of MAC addresses from a list of Terminals
	 */
	private List<String> getMacAddressesFromTerminals(List<Terminal__c> terminalsToUpdate) 
	{
		List<String> termMacAddresses = new List<String>();
		
		// Iterate through the terminals, if they have a modem (MAC address), add it to the list
		for (Terminal__c term : terminalsToUpdate) 
		{
			if (term.MacAddress__c != null) 
			{
				termMacAddresses.add(term.MacAddress__c);
			}
		}
		
		return termMacAddresses;
	}

	/**
	 * Creates a map of MAC addresses to their corresponding PerfLatestResult data
	 */
	private Map<String,SNG_Perf.PerfLatestResult> generateMacAddressToPerfLatestResult(SNG_Perf.PerfLatest perfLatest)
	{
		Map<String,SNG_Perf.PerfLatestResult> macAddrToPerfLatestResult = new Map<String,SNG_Perf.PerfLatestResult>();
		
		if (perfLatest.result != null)
		{
			for (SNG_Perf.PerfLatestResult perfLatestResult : perfLatest.result)
			{
				macAddrToPerfLatestResult.put(perfLatestResult.UTSUMMARYMACADDR, perfLatestResult);
			}
		}
		
		return macAddrToPerfLatestResult;
	}

	/**
	 * Update the terminals with retrieved performance data.
	 */
	private void updateTerminalsPerfData(Map<String,SNG_Perf.PerfLatestResult> macAddrToPerfData, List<Terminal__c> termList)
	{ 	
		// Update each terminal with its corresponding performance data, if it has none, default values
		for (Terminal__c terminal : termList) 
		{
			// Flag: false - use default data, true - do not use default data
			boolean validData = false;
			
			// Check terminal for an associated MAC address
			if (terminal.MacAddress__c != null)
			{
				SNG_Perf.PerfLatestResult perfDataForTerminal = macAddrToPerfData.get(SNGHttpUtilities.translateMacAddressFromSfToDbFormat(terminal.MacAddress__c).toLowerCase());
				
				// Terminal has corresponding performance data
				if (perfDataForTerminal != null)
				{
					// Terminal has associated performance data, don't use default data
					validData = true;
					terminal.UploadSymbolRateBackEnd__c = (perfDataForTerminal.UTRLSYMBOLRATE != null) ? perfDataForTerminal.UTRLSYMBOLRATE : 0;
					terminal.DownloadSinrBackEnd__c = (perfDataForTerminal.UTFLSINR != null) ? perfDataForTerminal.UTFLSINR : 0;
					terminal.OnlineTime__c = (perfDataForTerminal.UTONLINETIME != null) ? SNGTimeUtil.getTimeString(SNGTimeUtil.translateOnlineTime(perfDataForTerminal.UTONLINETIME)) : OFFLINE;
                    terminal.PeersOnlineBackEnd__c = perfDataForTerminal.NUM_PEERS_ONLINE;
                    Decimal averageSymbolRate = perfDataForTerminal.PEER_AVG_SYMBOL_RATE;
                    terminal.PeersAvgUploadSymbolRateBackEnd__c = (null != averageSymbolRate) ? averageSymbolRate.setScale(3) : 0;
				}
			}
			
			// Terminal has no associated MAC address and/or corresponding performance data 
			if (!validData)
			{
				terminal.UploadSymbolRateBackEnd__c = 0;
				terminal.DownloadSinrBackEnd__c = 0;
				terminal.StatusBackEnd__c = SNG_TerminalQuery.UNABLE_TO_LOAD;
				terminal.OnlineTime__c = OFFLINE;				
			}
		}	
	}		
    
}