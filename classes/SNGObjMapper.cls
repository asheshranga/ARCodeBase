/*
 * This class is used to construct and access maps between various SNG objects
 */
public with sharing class SNGObjMapper {

	/**
	 * Create a map of Service Plan Ids to their corresponding list of Modem/Service Plans (MSPs)
	 *
     * @param    msps			          Modem/Service Plans associated with service plan
     * @return                            map of Service Plan Ids to MSPs
	 */
	public static Map<Id, List<ModemServicePlan__c>> buildServicePlanToMspsMap(final List<ModemServicePlan__c> msps) {

		Map<Id, List<ModemServicePlan__c>> servicePlanToMsps = new Map<Id, List<ModemServicePlan__c>>();

		// Go through list of MSPs to create a map between a Service Plan and its partially and fully active MSPs
		for (ModemServicePlan__c msp : msps) {

			// get the value based on the Service Plan Id from the map
			List<ModemServicePlan__c> mspList = servicePlanToMsps.get(msp.ServicePlan__c);

			// if no key-value pair exists for Service Plan Id, create one
			if (mspList == null) {
				// create the list to be stored for this Service Plan's Id
				mspList = new List<ModemServicePlan__c>();
				mspList.add(msp);
				servicePlanToMsps.put(msp.ServicePlan__c, mspList);
			}
			// a key-value pair exists for the msp's service plan Id, add the msp to the service plan Id's mspList
			else {
				mspList.add(msp);
				servicePlanToMsps.put(msp.ServicePlan__c, mspList);
			}
		}

		return servicePlanToMsps;
	}

    /**
     * Retrieves the list of MSPs corresponding to service plan
     *
     * @param    servicePlanId            ID of service plan
     * @param    servicePlanToMspsMap     Mapping between service plan and MSPs
     * @return                            list of MSPs
     */
    public static List<ModemServicePlan__c> getMsps(final Id servicePlanId,
    		final Map<Id, List<ModemServicePlan__c>> servicePlanToMspsMap)
    {
    	return servicePlanToMspsMap.get(servicePlanId);
    }
}