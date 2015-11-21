/**
 * This class is used to update the terminal objects with the peer online data, performing any conversation
 * or translation from the received web service data.
 */
public with sharing class SNG_UtPeersUpdater 
{
    /**
     * The main entry point to update peer onine data.
     *
     * @param   macAddressToTerminal      Contains a mapping between the mac address to its terminal object.
     * @param   peerData                  The response object obtained from the web service.
     */
    public static void process(Map<String, Terminal__c> macAddressToTerminal, final SNG_Perf.UtPeerDataLatest peerData)
    {
        if (isDataPresent(peerData)) 
        {  
        	updateTerminals(macAddressToTerminal, peerData.result); 
        }
        else
        {
        	// error case. Default all entries to zero since no data can be obtained.
        	defaultMissingEntries(macAddressToTerminal, new Set<String>());
        }
        
        // update the values.
        update macAddressToTerminal.values();   
    }
    
    /**
     * Validates if the response object contains any data that can be used to update the terminal object.
     *
     * @param   response                   The response object obtained from the web service.
     */
    private static boolean isDataPresent(final SNG_Perf.UtPeerDataLatest response)
    {
        return (null != response && null != response.result);
    }

    /**
     * Updates the corresponding terminal object based on the response data. Since the MAC address is associated with
     * the terminal, the mapping between the response data to the object is done using the MAC address as the key.
     *
     * @param   macAddressToTerminal      Contains a mapping between the mac address to its terminal object.
     * @param   peerResults               The response object obtained from the web service.
     */
    private static void updateTerminals(Map<String, Terminal__c> macAddressToTerminal, final List<SNG_Perf.UtPeerDataLatestResult> peerResults)
    {
    	
    	for (SNG_Perf.UtPeerDataLatestResult peer : peerResults)
    	{
    		String macAddress = SNGHttpUtilities.translateMacAddressFromDbToSfFormat(peer.id).toLowerCase();
    		
    		if (macAddressToTerminal.containsKey(macAddress))
    		{
    			Terminal__c terminal = macAddressToTerminal.get(macAddress);             
    			terminal.PeersOnlineBackEnd__c = peer.NUM_PEERS_ONLINE;
                Decimal averageSymbolRate = peer.AVG_RL_SYM_RATE;
                terminal.PeersAvgUploadSymbolRateBackEnd__c = (null != averageSymbolRate) ? averageSymbolRate.setScale(3) : 0;
                //macAddressToTerminal.put(macAddress, terminal);
    		}
    	}

    	Set<String> peerSet = createResultSet(peerResults);
    	defaultMissingEntries(macAddressToTerminal, peerSet);
    }
    
    /**
     * Creates a result set from the web service response object. The returned collection contains a set
     * of MAC addresses found in the response object. The collection returned provides an easy lookup
     * method.
     *
     * @param   peerResults                The response object obtained from the web service.
     * @return                             The collection set of MAC addresses in the response.
     */
    private static Set<String> createResultSet(final List<SNG_Perf.UtPeerDataLatestResult> peerResults)
    {
        Set<String> result = new Set<String>();
        
        for (SNG_Perf.UtPeerDataLatestResult peer : peerResults)
        {
            result.add(SNGHttpUtilities.translateMacAddressFromDbToSfFormat(peer.id).toLowerCase());
        }
        
        return result;
    }
    
    /**
     * This method defaults the missing entries from the response.
     *
     * @param   macAddressToTerminal      Contains a mapping between the mac address to its terminal object.
     * @param   peerCollection             The collection of MAC addresses found in the response 
     *                                     from the web service.
     */
    private static void defaultMissingEntries(Map<String, Terminal__c> macAddressToTerminal, 
                                              final Set<String> peerCollection)
    {
        for (String macAddress : macAddressToTerminal.keySet())
        {
            if (!peerCollection.contains(macAddress))
            {
                Terminal__c terminalToDefault = macAddressToTerminal.get(macAddress);
                terminalToDefault.PeersOnlineBackEnd__c = 0;
                terminalToDefault.PeersAvgUploadSymbolRateBackEnd__c = 0;
                //macAddressToTerminal.put(macAddress, terminalToDefault);
            }
        }
    }
}