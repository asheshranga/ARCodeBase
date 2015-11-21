/**
 * This class works in conjunction with the SNG_UtUsageAgggregate class to update the terminal usage data. The class
 * is responsible for processing the response from Usage Service and populating the corresponding terminal object with
 * the usage information.
 */
public with sharing class SNG_UtUsageAggregateUpdater
{
	/**
     * Processes the usage data received from the Usage Service by updating the associated Terminal object.
     * 
     * @param   macAddressesToTerminal    A collection containing the mac address mapping to the usage data. 
     * @param   response                  The response from the Usage Service when querying for usage data. 
     */
    public static void process(Map<Id, Terminal__c> terminals, Map<String, Id> macAddressToTerminalId, final SNG_UsageService.Response response)
    {
        Map<String, SNG_MacAddressUsageData> maudCollection = populateMacAddressUsageDataCollection(response);
        updateTerminals(terminals, macAddressToTerminalId, maudCollection);        
    }
    
    /**
     * Process an exception case when attempting to retrive usage data from the Usage Service.
     * 
     * @param   macAddressesToTerminal    A collection containing the mac address mapping to the usage data.  
     */
    public static void processException(Terminal__c[] terminals)
    {
    	if (null != terminals) {
    		final String unableToLoad = SNG_TerminalQuery.UNABLE_TO_LOAD;
			
			for (Terminal__c t : terminals) {
	            t.GbUploaded__c = unableToLoad;
	            t.GbDownloaded__c = unableToLoad;
	            t.GbTotal__c = unableToLoad;
	        }
    	}
    	// terminals update trigger is invoked in Terminal Tab after the Performance Latest is calculated.
    }
    
    /**
     * Creates and populates the MAC address and its corresponding usage based on the response received from Usage Service.
     *
     * @param    response                 The object containing the usage data response from Usage Service for a set of MAC addresses.
     * @return                            A collection object, containing the mapping between the MAC address and its corresponding
     *                                    usage.
     */ 
    private static Map<String, SNG_MacAddressUsageData> populateMacAddressUsageDataCollection(final SNG_UsageService.Response response) {
        List<List<SNG_UsageService.UsageAndErrors>> uaesList = (SNG_UsageAggregateUpdateHelper.isDataPresent(response)) ? response.data : 
                                                                                                                          new List<List<SNG_UsageService.UsageAndErrors>>();
        
        Map<String, SNG_MacAddressUsageData> maudCollection = new Map<String, SNG_MacAddressUsageData>(); 
        
        for (List<SNG_UsageService.UsageAndErrors> uaes : uaesList)
        {
            processUsageData(maudCollection, uaes);
        }
        
        return maudCollection;
    }
    
    /**
     * Processes the usage data by translating the data provided by the Usage Service to a list of MacAddressUsageData objects
     * based on the input. The code also keeps track of the aggregate upload, download, and total across the Modem MAC addresses.
     *
     * @param    maudCollection             A collection containing the mac address mapping to the usage data.
     * @param    uaes                       The usage and errors data obtained from the Usage Service.
     */ 
    public static void processUsageData(Map<String, SNG_MacAddressUsageData> maudCollection, 
                                        List<SNG_UsageService.UsageAndErrors> uaes)
    {
        for (SNG_UsageService.UsageAndErrors uae : uaes)
        {
            String macAddress = SNG_REST_Utilities.formatMacAddress(uae.macAddress).toLowerCase();
            SNG_MacAddressUsageData usageData = (maudCollection.containsKey(macAddress)) ? maudCollection.get(macAddress) : 
                                                                                           new SNG_MacAddressUsageData(macAddress, 0, 0);
            
            usageData.downloadUsage += uae.aggregateAcctInputOctets;
            usageData.uploadUsage += uae.aggregateAcctOutputOctets;
            maudCollection.put(macAddress, usageData);
        }
    }
    
    /**
     * Processes the usage data by translating the data provided by the Usage Service to a list of MacAddressUsageData objects
     * based on the input. The code also keeps track of the aggregate upload, download, and total across the Modem MAC addresses.
     *
     * @param    macAddressToTerminal       Contains a mapping between the mac address to the terminal object.
     * @param    maudCollection             A collection containing the mac address mapping to the usage data.
     */ 
    private static void updateTerminals(Map<Id, Terminal__c> terminals, 
                                        Map<String, Id> macAddressToTerminalId, 
                                        Map<String, SNG_MacAddressUsageData> maudCollection)
    {
    	Map<Id, Terminal__c> terminalMap = (null != terminals) ? terminals : new Map<Id, Terminal__c>(); 
    	Map<String, Id> macToTerminalId = (null != macAddressToTerminalId) ? macAddressToTerminalId : new Map<String, Id>();
    	
    	// Initially set all terminals to UNABLE_TO_LOAD (not updating yet)
    	for (Terminal__c terminal : terminalMap.values()) {
    		terminal.GbUploaded__c = SNG_TerminalQuery.UNABLE_TO_LOAD;
            terminal.GbDownloaded__c = SNG_TerminalQuery.UNABLE_TO_LOAD;
            terminal.GbTotal__c = SNG_TerminalQuery.UNABLE_TO_LOAD;
    	}
    	
        for (String macAddress : maudCollection.keySet())
        {
            if (macToTerminalId.containsKey(macAddress))
            {
                SNG_MacAddressUsageData maud = maudCollection.get(macAddress);
                Terminal__c terminalToUpdate = terminalMap.get(macToTerminalId.get(macAddress)); 
                terminalToUpdate.GbUploaded__c = String.valueOf(SNG_UsageAggregateUpdateHelper.convertToGb(maud.uploadUsage));
                terminalToUpdate.GbDownloaded__c = String.valueOf(SNG_UsageAggregateUpdateHelper.convertToGb(maud.downloadUsage));
                terminalToUpdate.GbTotal__c = String.valueOf(SNG_UsageAggregateUpdateHelper.convertToGb(maud.totalUsage));
            }
        }
        
        defaultMissingEntries(terminalMap, macToTerminalId, maudCollection.keySet(), String.valueOf(0));
        // terminals update trigger is invoked in Terminal Tab after the Performance Latest is calculated.
    }
    
    
    /**
     * Defaults usage data to the specified default value for any entries not addressed by Usage Service on a valid response.
     *
     * @param    macAddressToTerminal       Contains a mapping between the mac address to the terminal object.
     * @param    maudCollection             Set of MAC addresses appearing in the UDM response.
     * @param    defaultValue               The default value to set the terminal usage data to.
     */
    private static void defaultMissingEntries(Map<Id, Terminal__c> terminals, 
                                              Map<String, Id> macAddressToTerminalId, 
                                              Set<String> maudCollection,
                                              String defaultValue)
    {	
        for (String macAddress : macAddressToTerminalId.keySet())
        {
        	if (!maudCollection.contains(macAddress))
        	{
                Terminal__c terminalToDefault = terminals.get(macAddressToTerminalId.get(macAddress));
                terminalToDefault.GbUploaded__c = defaultValue;
                terminalToDefault.GbDownloaded__c = defaultValue;
                terminalToDefault.GbTotal__c = defaultValue;
            }
        }
    }
}