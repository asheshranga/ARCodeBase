/**
 * This class is used to support a buildout of the JSON response for the Service Plan Usage API request.
 * The class requires the service plan ID and the response from the Usage Service. 
 */
public with sharing class SNG_REST_ServicePlanUsageOutputBuilder 
{   
    /**
     * Builds the SNG_REST_ServicePlanUsageOutput based on the service plan ID and the Usage Service response
     * provided. The resulting output format provides the "items" field in the JSON response for a Service Plan
     * Usage API call (Section 2.1.15 in the SNG Customer Portal 3rd Party API document).
     *
     * @param    servicePlanId          The service plan ID for which the response corresponds to.
     * @param    response               The Usage Service Web service response.
     * @param    msps                   The requested Modem / Service Plans.
     * @return                          The Service Plan Usage Output data or null if data is not found.
     * @throws   SNG_Exception          Thrown if the MAC address from the Usage Data Mart is not expected.
     */   
    public static SNG_REST_ServicePlanUsageOutput build(final String servicePlanId, 
                                                        final SNG_UsageService.Response response, 
                                                        final List<ModemServicePlan__c> msps)
    {   
        List<List<SNG_UsageService.UsageAndErrors>> uaesList = (isDataPresent(response)) ? response.data : 
                                                                                           new List<List<SNG_UsageService.UsageAndErrors>>();
        
        Map<String, SNG_REST_ServicePlanUsageOutput.MacAddressUsageData> maudCollection = 
                        new Map<String, SNG_REST_ServicePlanUsageOutput.MacAddressUsageData>(); 
        
        
        for (List<SNG_UsageService.UsageAndErrors> uaes : uaesList)
        {
            processUsageData(maudCollection, uaes);
        }
     
        addMissingEntries(maudCollection, msps); //adds in any missing entries   
        return (!maudCollection.isEmpty()) ? new SNG_REST_ServicePlanUsageOutput(servicePlanId, maudCollection.values()) : null;
    }
    
    /**
     * Validates the data is present to populate the response with.
     *
     * @param     response              The Usage Service Web service response.
     * @return                          True if data exists; false otherwise.
     */
    private static boolean isDataPresent(final SNG_UsageService.response response)
    {
        return (null != response && null != response.data);
    }
    
    /**
     * Adds missing entries from the UsageService. UsageService will return an empty data set if there
     * are no entries residing in UDM for usage data. This will autofill in the response to the client
     * with the MAC address and 0 for the input and output data.
     *
     * @param    mauds                 The current output response.
     * @param    msps                  The requested Modem / Service Plans.
     */
    private static void addMissingEntries(Map<String, SNG_REST_ServicePlanUsageOutput.MacAddressUsageData> maudCollection, 
                                          final List<ModemServicePlan__c> msps)
    {
    	Set<String> macAddressSet = new Set<String>(maudCollection.keySet());
    	for (ModemServicePlan__c msp : msps)
    	{
    		String macAddress = msp.Modem__r.Name;
    		if (!macAddressSet.contains(macAddress))
    		{
    			maudCollection.put(macAddress, createDefaultMacAddressUsageData(macAddress));
    			macAddressSet.add(macAddress);
    		}
    	}
    }
    
    /**
     * Creates a default Modem MAC address usage data object, which contains the mac address and 0 for download and
     * upload usage. This method is used when the UsageService does not provide any usage data for the specified
     * MAC address and time period. 
     *
     * @param    macAddress             The MAC address to create a default Modem MAC address usage/data for.
     * @return                          The default Modem Usage data using the specified MAC address.
     */
    private static SNG_REST_ServicePlanUsageOutput.MacAddressUsageData createDefaultMacAddressUsageData(final String macAddress)
    {
    	return new SNG_REST_ServicePlanUsageOutput.MacAddressUsageData(macAddress, 0, 0);
    }
    
    /**
     * Processes the usage data by translating the data provided by the Usage Service to a list of MacAddressUsageData objects
     * based on the input. The code also keeps track of the aggregate upload, download, and total across the Modem MAC addresses.
     *
     * @param    uae                    The list of usage and error data extracted from the Usage Service Web service response.
     * @return                          A list of the usage data information or an empty list if none is found.
     * @throws   SNG_Exception         Thrown if the MAC address from the Usage Data Mart is not expected.
     */ 
    private static void processUsageData(Map<String, SNG_REST_ServicePlanUsageOutput.MacAddressUsageData> maudCollection, 
                                         List<SNG_UsageService.UsageAndErrors> uaes)
    {
        String macAddress = null;
        SNG_REST_ServicePlanUsageOutput.MacAddressUsageData usageData;
        
        for (SNG_UsageService.UsageAndErrors uae : uaes)
        {
        	macAddress = SNG_REST_Utilities.formatMacAddress(uae.macAddress);
        	usageData = (maudCollection.containsKey(macAddress)) ? maudCollection.get(macAddress) : 
        	                                                       new SNG_REST_ServicePlanUsageOutput.MacAddressUsageData(macAddress, 0, 0);
        	
        	usageData.downloadUsage += uae.aggregateAcctInputOctets;
        	usageData.uploadUsage += uae.aggregateAcctOutputOctets;
        	maudCollection.put(macAddress, usageData);
        }
    }
}