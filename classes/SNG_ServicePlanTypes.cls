public with sharing class SNG_ServicePlanTypes {
	
	/**
     * Runs validation checks to check if Service Plan Type Products can be updated
     *
     * @param  oldProducts All products before update
     * @param  newProducts All products after update
     * @return             <Id productId, String errorMessage> mapping containing the error messages for each Service Plan Type Product which cannot be updated
     */
	public static Map<Id, String> validateUpdate(final Map<Id, Product2> oldProducts, final Map<Id, Product2> newProducts) {
		// For both Maps (oldProducts and newProducts), extract the Service Plan Types out so we're only running validation on those Products
		final Map<Id, Product2> oldServicePlanTypes = extractServicePlanTypes(oldProducts);
		final Map<Id, Product2> newServicePlanTypes = extractServicePlanTypes(newProducts);
		
		System.assertEquals(newServicePlanTypes.size(), oldServicePlanTypes.size());
		
		// Create an empty errors map. This map should be passed into each validation method, and updated accordingly.
		Map<Id, String> errors = new Map<Id, String>();
		
		if (!newServicePlanTypes.isEmpty()) {
			errors = validateDeactivation(oldServicePlanTypes, newServicePlanTypes, errors);
		}
		
		return errors;
	}
	
	/**
     * Validates that Service Plan Type Products can be deactivated.
     * In order to be deactivated, Service Plan Type Products cannot be associated with any ModemServicePlan's which are either Active, or will become Active in the future.
     * 
     * @param   oldServicePlanTypes    Service Plan Type Products before update
     * @param   newServicePlanTypes    Service Plan Type Products after update
     * @param   errors                 <Id productId, String errorMessage> mapping containing the error messages for each Service Plan Type Product which cannot be updated
     * @return                         Updated <Id productId, String errorMessage> mapping containing the error messages for each Service Plan Type Product which cannot be updated
     */
	private static Map<Id, String> validateDeactivation(final Map<Id, Product2> oldServicePlanTypes, final Map<Id, Product2> newServicePlanTypes, Map<Id, String> errors) {
        final String errorMessagePrefix = 'Service Plan Type cannot be deactivated because it is used by: ';
        
        // Filter out the Service Plan Types that are becoming inactive (deactivated)
        final Map<Id, Product2> servicePlanTypesBecomingInactive = SNG_Product2.extractProductsBecomingInactive(oldServicePlanTypes, newServicePlanTypes);
        
        if (!servicePlanTypesBecomingInactive.isEmpty()) {
        	// Get all Service Plans associated with a Service Plan Type that is being deactivated
	        final Map<Id, ServicePlan__c> servicePlans = new Map<Id, ServicePlan__c>([SELECT Id, Name, ServicePlanType__c FROM ServicePlan__c WHERE ServicePlanType__c = :servicePlanTypesBecomingInactive.keySet()]);
	        
	        if (!servicePlans.isEmpty()) {
	        	// Get all ModemServicePlans that are either Active or will become Active in the future, and that are associated with the Service Plans in the servicePlans map
	            final Map<Id, ModemServicePlan__c> msps = new Map<Id, ModemServicePlan__c>([SELECT Id, Name, ServicePlan__c FROM ModemServicePlan__c 
	                                WHERE ServicePlan__c = :servicePlans.keySet() AND 
	                                ( (StartDate__c <= :SNG_DateUtils.todayGmt() AND (EndDate__c >= :SNG_DateUtils.todayGmt() OR EndDate__c = NULL))
	                                OR StartDate__c > :SNG_DateUtils.todayGmt())]);
	            
	            if (!msps.isEmpty()) {
	            	// Map each Service Plan Type to a list of conflicting ModemServicePlans. This will be used for the error messages.
	                final Map<Id, List<ModemServicePlan__c>> servicePlanTypeToMsps = new Map<Id, List<ModemServicePlan__c>>();
	                
	                // For each ModemServicePlan...
	                for (ModemServicePlan__c msp : msps.values()) {
	                    // get the Service Plan
	                    final ServicePlan__c servicePlan = servicePlans.get(msp.ServicePlan__c);
	                    
	                    // get the Id of the Service Plan Type used by the Service Plan
	                    final Id servicePlanTypeId = servicePlan.ServicePlanType__c;
	                    
	                    // lookup the list of ModemServicePlans in the map associated with the servicePlanTypeId for this msp.
	                    List<ModemServicePlan__c> mspListForServicePlanType = servicePlanTypeToMsps.get(servicePlanTypeId);
	                    
	                    // If this is the first ModemServicePlan for the servicePlanTypeId, the list will be null and will need to be initialized.
	                    if (null == mspListForServicePlanType) {
	                        mspListForServicePlanType = new List<ModemServicePlan__c>();
	                    }
	                    
	                    // Add msp to the list of ModemServicePlans for the servicePlanTypeId
	                    mspListForServicePlanType.add(msp);
	                    servicePlanTypeToMsps.put(servicePlanTypeId, mspListForServicePlanType);
	                }
	                
	                // Use the mapping from above to create the error map
	                for (Id servicePlanTypeId : servicePlanTypeToMsps.keySet()) {
	                    final String errorMessage = errorMessagePrefix + SNG_HtmlUtilities.getHtmlSalesforceRecordLinkListString(servicePlanTypeToMsps.get(servicePlanTypeId));
	                    errors = SNG_Product2.addError(errors, servicePlanTypesBecomingInactive.get(servicePlanTypeId), errorMessage);
	                }
	            }
	        }
	        
        }
        
        return errors;
    }
	
	/**
     * Returns a new map containing only the Service Plan Type Products from the given products map
     * 
     * @param   products        Map of products
     * @return                  Map of Service Plan Type Products
     */
	private static Map<Id, Product2> extractServicePlanTypes(final Map<Id, Product2> products) {
        return SNG_Product2.extractProductsWithMatchingRecordType(products, SNG_ServicePlan.SERVICE_PLAN_TYPE_RECORD_TYPE_NAME);
    }
	
}