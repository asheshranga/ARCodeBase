/**
 * This class is responsible for updating usage counts in ModemServicePlan__c and ServicePlan__c records.
 */
public with sharing class SNG_SpUsageAggregateUpdater {
	
	/**
	 * The string to use in the Usage fields for zero (0) usage
	 */
	@TestVisible
	private static final String ZERO_STR = '0';
	
	/**
	 * The entry point to update usage counts for all of the passed in servicePlans and msps,
	 * using values from the SNG_UsageService.Response.
	 *
	 * @param  servicePlans    List of ServicePlan__c records to update usage for
	 * @param  msps            List of ModemServicePlan__c records to update usage for
	 * @param  response        The response from UsageService
	 */
	public static void process(ServicePlan__c[] servicePlans, ModemServicePlan__c[] msps, final SNG_UsageService.Response response) {
		Map<String, SNG_ServicePlanUsageData> spUsageDatas = populateServicePlanUsageDataCollection(response, msps);
		
		// Update MSP and Service Plan usage fields
		updateMspAndSpUsage(servicePlans, msps, spUsageDatas);
	}
	
	/**
     * Processes an exception caught while doing the call to UsageService.
     * The Exception is handled by setting the usage fields of all of the passed in
     * servicePlans and msps to SNG_TerminalQuery.UNABLE_TO_LOAD.
     *
     * @param  servicePlans    List of ServicePlan__c records to update usage for
     * @param  msps            List of ModemServicePlan__c records to update usage for
     */
	public static void processException(ServicePlan__c[] servicePlans, ModemServicePlan__c[] msps) {
		final String unableToLoad = SNG_TerminalQuery.UNABLE_TO_LOAD;
		
		for (ModemServicePlan__c msp : msps) {
            msp.GbUploaded__c = unableToLoad;
            msp.GbDownloaded__c = unableToLoad;
            msp.GbTotal__c = unableToLoad;
        }
        update msps;
        
        for (ServicePlan__c sp : servicePlans) {
        	sp.GbUploaded__c = unableToLoad;
            sp.GbDownloaded__c = unableToLoad;
            sp.GbTotal__c = unableToLoad;
        }
        update servicePlans;
	}
	
	/**
	 * Populates a map from Service Plan Name to SNG_ServicePlanUsageData containing usage counts per Service Plan.
	 * The passed in response is parsed and split up into the appropriate ModemServicePlan__c.
	 *
	 * @param  response    Response from UsageService
	 * @param  msps        List of ModemServicePlan__c records to map each SNG_UsageService.UsageAndErrors in the response to
	 * @return             Map between Service Plan Name and corresponding SNG_ServicePlanUsageData object.
	 */
	private static Map<String, SNG_ServicePlanUsageData> populateServicePlanUsageDataCollection(final SNG_UsageService.Response response, final ModemServicePlan__c[] msps) {
	   List<List<SNG_UsageService.UsageAndErrors>> uaesList = (SNG_UsageAggregateUpdateHelper.isDataPresent(response)) ? response.data : 
                                                                                                                         new List<List<SNG_UsageService.UsageAndErrors>>();
	   
	   Map<String, SNG_ServicePlanUsageData> spUsageDatas = new Map<String, SNG_ServicePlanUsageData>();
	   
	    for (List<SNG_UsageService.UsageAndErrors> uaes : uaesList) {
            SNG_ModemServicePlanUsageMapper.mapToServicePlanUsageDatas(msps, spUsageDatas, uaes);
	    }
	   
	   return spUsageDatas;
	}
	
	/**
	 * Updates the usage values of the passed in servicePlans and msps to the values that are set in spUsageDatas
	 *
	 * @param  servicePlans    List of ServicePlan__c records to update usage for
	 * @param  msps            List of ModemServicePlan__c records to update usage for
	 * @param  spUsageDatas    Map between Service Plan Name and corresponding SNG_ServicePlanData object, containing usage counts.
	 */
	@TestVisible
	private static void updateMspAndSpUsage(ServicePlan__c[] servicePlans, ModemServicePlan__c[] msps, final Map<String, SNG_ServicePlanUsageData> spUsageDatas) {
		for (ModemServicePlan__c msp : msps) {
			SNG_ModemServicePlanUsageData mspUsageData = getUsageDataForMsp(spUsageDatas, msp);
			
			if (null != mspUsageData) {
				msp.GbDownloaded__c = String.valueOf(SNG_UsageAggregateUpdateHelper.convertToGb(mspUsageData.downloadUsage));
	            msp.GbUploaded__c = String.valueOf(SNG_UsageAggregateUpdateHelper.convertToGb(mspUsageData.uploadUsage));
	            msp.GbTotal__c = String.valueOf(SNG_UsageAggregateUpdateHelper.convertToGb(mspUsageData.totalUsage));
			} else {
				setMspUsageDataToZero(msp);
			}
		}
		update msps;
		
		for (ServicePlan__c sp : servicePlans) {
			final SNG_ServicePlanUsageData spUsageData = spUsageDatas.get(sp.Name);
			
			if (null != spUsageData) {
				sp.GbDownloaded__c = String.valueOf(SNG_UsageAggregateUpdateHelper.convertToGb(spUsageData.downloadUsage));
	            sp.GbUploaded__c = String.valueOf(SNG_UsageAggregateUpdateHelper.convertToGb(spUsageData.uploadUsage));
	            sp.GbTotal__c = String.valueOf(SNG_UsageAggregateUpdateHelper.convertToGb(spUsageData.totalUsage));
			} else {
				setServicePlanUsageDataToZero(sp);
			}
			
		}
		update servicePlans;
	}
	
	/**
	 * Looks up the SNG_ModemServicePlanUsageData object in the spUsageDatas map corresponding with the msp record
	 *
	 * @param  spUsageDatas    Map between Service Plan Name and corresponding SNG_ServicePlanData object
	 * @param  msp             ModemServicePlan__c record to get the SNG_ModemServicePlanUsageData object for
	 * @return                 SNG_ModemServicePlanUsageData object corresponding with msp
	 */
	private static SNG_ModemServicePlanUsageData getUsageDataForMsp(final Map<String, SNG_ServicePlanUsageData> spUsageDatas, final ModemServicePlan__c msp) {
		final SNG_ServicePlanUsageData spUsageData = spUsageDatas.get(msp.ServicePlan__r.Name);
		return null != spUsageData ? spUsageData.mspUsageData.get(msp.Modem__r.Name) : null;
	}
	
	/**
	 * Sets the given ModemServicePlan__c record's usage fields to zero
	 *
	 * @param  msp ModemServicePlan__c record to update usage fields for
	 */
	private static void setMspUsageDataToZero(final ModemServicePlan__c msp) {
		msp.GbDownloaded__c = ZERO_STR;
        msp.GbUploaded__c = ZERO_STR;
        msp.GbTotal__c = ZERO_STR;
	}
	
	/**
     * Sets the given ServicePlan__c record's usage fields to zero
     *
     * @param  sp   ServicePlan__c record to update usage fields for
     */
	private static void setServicePlanUsageDataToZero(final ServicePlan__c sp) {
        sp.GbDownloaded__c = ZERO_STR;
        sp.GbUploaded__c = ZERO_STR;
        sp.GbTotal__c = ZERO_STR;
    }
	
}