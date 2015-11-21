/**
 * This class contains helper functions to determine whether a Service Plan can be successfully added or
 * updated in the database.
 */
public with sharing class SNG_ServicePlan {
	
    /**
     * The name of the RecordType for Service Plan Types
     */
    public static final transient String SERVICE_PLAN_TYPE_RECORD_TYPE_NAME = 'Service Plan Types';
	
	/**
	 * Updates the usage data fields for the list of Service Plans and ModemServicePlans
	 *
	 * @param  servicePlans    Service Plans to update usage data fields for
	 * @param  msps            ModemServicePlans to update usage data fields for
	 */
	public static void updateUsageData(ServicePlan__c[] servicePlans, ModemServicePlan__c[] msps) {
		try {
			SNG_ModemServicePlan.updateUsageData(servicePlans, msps);
		} catch (Exception e) {
			final String internalMessage = e.getMessage();
			final String externalMessage = 'Error encountered while computing usage for Service Plans. Some reported values may not be correct.';
			final String stackTrace = e.getStackTraceString();
			SNGVisualforceErrorReporter.reportError(externalMessage, internalMessage, stackTrace);
		}
	}

	/**
     * Given a list of service plan IDs, create a Map of ID to service plan objects
     *
     * @param   servicePlanIds  	List of service plan IDs
     * @return              		Map of service plan IDs to their respective service plan objects
     */
    public static Map<Id, ServicePlan__c> buildMapOfServicePlans(List<Id> servicePlanIds) { 

    	Map<Id, ServicePlan__c> servicePlanMap = new Map<Id, ServicePlan__c>([SELECT Id, Name, Account__c, Account__r.Name, Status__c, StartDate__c, 
    																				EndDate__c, ServicePlanType__c FROM ServicePlan__c 
    																				WHERE Id IN :servicePlanIds]);
    	return servicePlanMap; 
    }
}