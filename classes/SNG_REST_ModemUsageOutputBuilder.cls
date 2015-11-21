/**
 * This class is used to support a buildout of the JSON response for the Modem Plan Usage API request.
 * The class requires the modem MAC address, service plan active dates, and the response from the Usage Service. 
 */
public with sharing class SNG_REST_ModemUsageOutputBuilder 
{
    /**
     * Builds the SNG_REST_ModemUsageOutput based on the modem MAC address, service plan active dates,
     * and the Usage Service response provided. The resulting output format provides the "items" field in the 
     * JSON response for a Modem Usage API call (Section 2.1.14 in the SNG Customer Portal 3rd Party API document).
     *
     * @param    servicePlanId          The service plan ID for which the response corresponds to.
     * @param    response               The Usage Service Web service response.
     * @param    msps                   The requested Modem / Service Plans.
     * @return                          The Service Plan Usage Output data or null if data is not found.
     * @throws   SNG_Exception          Thrown if the MAC address from the Usage Data Mart is not expected.
     */ 
    public static SNG_REST_ModemUsageOutput build(final String macAddress, 
                                                  final SNG_UsageService.Response response, 
                                                  final List<SNG_REST_ModemUsage.ServicePlanInfo> servicePlans)
    {   
    	List<List<SNG_UsageService.UsageAndErrors>> uaesList = (isDataPresent(response)) ? response.data : 
                                                                                           new List<List<SNG_UsageService.UsageAndErrors>>();  
    	
        Map<String, SNG_REST_ModemUsageOutput.ServicePlanUsageData> spudCollection = 
            new Map<String, SNG_REST_ModemUsageOutput.ServicePlanUsageData>();
        
        // parse through response's data
        for (List<SNG_UsageService.UsageAndErrors> uaes : uaesList)
        {
        	processUsageData(servicePlans, spudCollection, uaes);
        }
        
        List<SNG_REST_ModemUsageOutput.ServicePlanUsageData> spud = new List<SNG_REST_ModemUsageOutput.ServicePlanUsageData>(spudCollection.values());
        addMissingEntries(servicePlans, spud);

        // Build the data portion of the JSON response                                       
        return new SNG_REST_ModemUsageOutput(spud, macAddress);
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
     * Retrieves the service plan which coincides with the start date selected.
     *
     * @param     servicePlans          The list of service plans and their active dates for the requested mac addressed and date range.
     * @param     startDate             The startDate to verify which service plan the date falls under
     * @return                          The service plan corresponding to the start date.
     * @throws    SNG_Exception         Thrown if the date provided is not within the range of service plans.
     */
    @TestVisible
    private static String getServicePlanId(final List<SNG_REST_ModemUsage.ServicePlanInfo> servicePlans, final DateTime startDate)
    {
        for (SNG_REST_ModemUsage.ServicePlanInfo servicePlan : servicePlans)
        {
            if (servicePlan.inRange(startDate))
                return servicePlan.id;
        }
        
        throw new SNG_Exception('Service Plan not in range.');
    }
    
    /**
     * Adds missing entries from the UsageService. UsageService will return an empty data set if there
     * are no entries residing in UDM for usage data. This will autofill in the response to the client
     * with the MAC address and 0 for the input and output data.
     *
     * @param    servicePlans          The list of service plans and their active dates.
     * @param    items                 The list of output response items.
     */
    private static void addMissingEntries(final List<SNG_REST_ModemUsage.ServicePlanInfo> servicePlans, 
                                                List<SNG_REST_ModemUsageOutput.ServicePlanUsageData> items)
    {
        for (SNG_REST_ModemUsage.ServicePlanInfo servicePlan : servicePlans)
        {
            boolean found = false;
            
            for (SNG_REST_ModemUsageOutput.ServicePlanUsageData item : items)
            {
                if (item.servicePlanId == servicePlan.id)
                {
                    found = true;
                    break;
                }
            }
            
            if (!found)
            {
                items.add(new SNG_REST_ModemUsageOutput.ServicePlanUsageData(servicePlan.id, 0, 0));
            }           
        }
    }
    
     /**
     * Processes the usage data by translating the data provided by the Usage Service to a list of MacAddressUsageData objects
     * based on the input. The code also keeps track of the aggregate upload, download, and total across service plans.
     *
     * @param    servicePlans          A collection of the service plan IDs and their active dates for a specific modem 
     *                                 MAC address
     * @param    spudCollection        A collection of the service plan IDs and it's currently accumulated usage data stats.
     * @param    uaes                  The list of usage and error data extracted from the Usage Service Web service response.
     */ 
    private static void processUsageData(final List<SNG_REST_ModemUsage.ServicePlanInfo> servicePlans,
                                         Map<String, SNG_REST_ModemUsageOutput.ServicePlanUsageData> spudCollection, 
                                         final List<SNG_UsageService.UsageAndErrors> uaes)
    {
        long aggregateInput = 0;
        long aggregateOutput = 0;
        //String macAddress = null;
        SNG_REST_ModemUsageOutput.ServicePlanUsageData usageData;
        
        for (SNG_UsageService.UsageAndErrors uae : uaes)
        {
        	// Convert UsageAndErrors' DateTimes to have default time 00:00:00
            DateTime startTime = uae.startTime;
            DateTime endTime = uae.endTime;
            startTime.addHours(-startTime.hour()).addMinutes(-startTime.minute()).addSeconds(-startTime.second());
            endTime.addHours(-endTime.hour()).addMinutes(-endTime.minute()).addSeconds(-endTime.second()); 
            
            // Build key to to locate the Service Plan name that corresponds to the data
            String servicePlanId = getServicePlanId(servicePlans, startTime);

            //macAddress = SNG_REST_Utilities.formatMacAddress(uae.macAddress);
            usageData = (spudCollection.containsKey(servicePlanId)) ? spudCollection.get(servicePlanId) : 
                                                                   new SNG_REST_ModemUsageOutput.ServicePlanUsageData(servicePlanId, 0, 0);
            
            usageData.downloadUsage += uae.aggregateAcctInputOctets;
            usageData.uploadUsage += uae.aggregateAcctOutputOctets;
            spudCollection.put(servicePlanId, usageData);
        }        
    }
}