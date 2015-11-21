/**
 * This class creates a mapping between Modem / Service Plans and SNG_ServicePlanUsageData 
 * (each containing SNG_ModemServicePlanUsageData objects).
 */
public with sharing class SNG_ModemServicePlanUsageMapper {
	
	/**
	 * Maps usage from the UsageService response in uaes to a mapping from Service Plan Name to SNG_ServicePlanUsageData objects.
	 * The passed in list of ModemServicePlan__c records (msps) is used for mapping each uae to a particular ModemServicePlan__c,
	 * each of which has a corresponding SNG_ModemServicePlanUsageData object within spUsageDatas.
	 *
	 * @param  msps            List of Modem / Service Plans to use for the mapping
	 * @param  spUsageDatas    Mapping between Service Plan Name and SNG_ServicePlanUsageData to be filled in and returned
	 * @param  uaes            List of SNG_UsageService.UsageAndErrors objects (response from UsageService) to map to spUsageDatas
	 * @throws SNG_Exception   If spUsageDatas is null
	 */
	public static void mapToServicePlanUsageDatas(final ModemServicePlan__c[] msps, 
	                                              final Map<String, SNG_ServicePlanUsageData> spUsageDatas, 
	                                              final SNG_UsageService.UsageAndErrors[] uaes) {
	    if (null == spUsageDatas) {
	    	throw new SNG_Exception('SNG_ModemServicePlanUsageMapper.mapToServicePlanUsageDatas called with null spUsageDatas');
	    }
	    
	    // If this method is called with no msps or no uaes, no mapping needs to be done.
	    if (null != uaes && null != msps) {
	    	for (SNG_UsageService.UsageAndErrors uae : uaes) {
	            final SNG_ModemServicePlanUsageData mspUsageData = mapToMspUsageData(msps, uae);
	            	            
	            if (null != mspUsageData) {
	                final String servicePlanName = mspUsageData.servicePlanId;
	                final SNG_ServicePlanUsageData spUsageData = spUsageDatas.containsKey(servicePlanName) ? spUsageDatas.get(servicePlanName) 
	                                                                                                       : new SNG_ServicePlanUsageData(servicePlanName);
	                spUsageData.addMspUsageData(mspUsageData);
	                spUsageDatas.put(servicePlanName, spUsageData);
	            }
	        }
	    }

	}
	
	/**
	 * Maps a single SNG_UsageService.UsageAndErrors object (uae) to a new SNG_ModemServicePlanUsageData object by going through
	 * the list of ModemServicePlan__c records (msps) to find the proper MSP for the uae object.
	 *
	 * @param  msps    List of ModemServicePlan__c records
	 * @param  uae     SNG_UsageService.UsageAndErrors to map to a new SNG_ModemServicePlanUsageData object
	 * @return         SNG_ModemServicePlanUsageData object corresponding with the passed in SNG_UsageService.UsageAndErrors object
	 */
	private static SNG_ModemServicePlanUsageData mapToMspUsageData(final ModemServicePlan__c[] msps, SNG_UsageService.UsageAndErrors uae) {
	   final String uaeMacAddress = SNG_REST_Utilities.formatMacAddress(uae.macAddress);
	   SNG_ModemServicePlanUsageData result = null;		
		
		for (ModemServicePlan__c msp : msps) {
			final String mspName = msp.Name;
			final String mspMacAddress = msp.Modem__r.Name;

			// Make sure the MAC address (modem) matches
			if (uaeMacAddress.toLowerCase() == mspMacAddress.toLowerCase()) {
				
				final DateTime uaeFirstProcessedEventTimestamp = uae.firstProcessedEventTimestamp;
				
				// If uaeFirstProcessedEventTimestamp is null, the usage is 0, so we can just skip it.
				if (null != uaeFirstProcessedEventTimestamp) {
					// Check if the first processed event timestamp from the UsageService response correlates with the current msp.
					// If it does, then the MSP matches and we can stop searching through the loop.
					
					if (SNG_ModemServicePlan.isMspActiveOnDate(msp, uaeFirstProcessedEventTimestamp.dateGMT())) {					
						
	                    final String servicePlanName = msp.ServicePlan__r.Name;
	                    final Long uploadUsage = uae.aggregateAcctOutputOctets;
	                    final Long downloadUsage = uae.aggregateAcctInputOctets;
	                    result = new SNG_ModemServicePlanUsageData(mspName, mspMacAddress, servicePlanName, uploadUsage, downloadUsage);
	                    break;
	                }
				}
			}
		}
		
		return result;
	}
	
}