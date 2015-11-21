public with sharing class SNG_TerminalTypes {
	
	/**
	 * Runs validation checks to check if Terminal Type Products can be updated
	 *
	 * @param  oldProducts All products before update
	 * @param  newProducts All products after update
	 * @return             <Id productId, String errorMessage> mapping containing the error messages for each Terminal Type Product which cannot be updated
	 */
	public static Map<Id, String> validateUpdate(final Map<Id, Product2> oldProducts, final Map<Id, Product2> newProducts) {

		// For both Maps (oldProducts and newProducts), extract the Terminal Types out so we're only running validation on those Products
        final Map<Id, Product2> oldTerminalTypes = extractTerminalTypes(oldProducts);
        final Map<Id, Product2> newTerminalTypes = extractTerminalTypes(newProducts);
        
        System.assertEquals(newTerminalTypes.size(), oldTerminalTypes.size());
        
        // Create an empty errors map. This map should be passed into each validation method, and updated accordingly.
        Map<Id, String> errors = new Map<Id, String>();
        
        if (!newTerminalTypes.isEmpty()) {
        	errors = validateDeactivation(oldTerminalTypes, newTerminalTypes, errors);
        }
        
        return errors;
    }
    
    /**
     * Validates that Terminal Type Products can be deactivated.
     * In order to be deactivated, Terminal Type Products cannot be associated with any ModemServicePlan's which are either Active, or will become Active in the future.
     * 
     * @param   oldTerminalTypes    Terminal Type Products before update
     * @param   newTerminalTypes    Terminal Type Products after update
     * @param   errors              <Id productId, String errorMessage> mapping containing the error messages for each Terminal Type Product which cannot be updated
     * @return                      Updated <Id productId, String errorMessage> mapping containing the error messages for each Terminal Type Product which cannot be updated
     */
    private static Map<Id, String> validateDeactivation(final Map<Id, Product2> oldTerminalTypes, final Map<Id, Product2> newTerminalTypes, Map<Id, String> errors) {
        final String errorMessagePrefix = 'Terminal Type cannot be deactivated because it is used by: ';
        
        // Filter out the Terminal Types that are becoming inactive (deactivated)
        final Map<Id, Product2> terminalTypesBecomingInactive = SNG_Product2.extractProductsBecomingInactive(oldTerminalTypes, newTerminalTypes);
        
        if (!terminalTypesBecomingInactive.isEmpty()) {
        	// Get all Modems associated with Terminals with a Terminal Type that is being deactivated
	        final Map<Id, Modem__c> modems = new Map<Id, Modem__c>([SELECT Id, Name, Terminal__c, Terminal__r.TerminalType__c FROM Modem__c WHERE Terminal__r.TerminalType__c = :terminalTypesBecomingInactive.keySet()]);
	        
	        if (!modems.isEmpty()) {
	        	// Get all ModemServicePlans that are either Active or will become Active in the future, and that are associated with the Modems in the modems map
	            final Map<Id, ModemServicePlan__c> msps = new Map<Id, ModemServicePlan__c>([SELECT Id, Name, Modem__c FROM ModemServicePlan__c 
	                                WHERE Modem__c = :modems.keySet() AND 
	                                ( (StartDate__c <= :SNG_DateUtils.todayGmt() AND (EndDate__c >= :SNG_DateUtils.todayGmt() OR EndDate__c = NULL))
	                                OR StartDate__c > :SNG_DateUtils.todayGmt())]);
	            
	            if (!msps.isEmpty()) {
	            	// Map each Terminal Type to a list of conflicting ModemServicePlans. This will be used for the error messages.
	                final Map<Id, List<ModemServicePlan__c>> terminalTypeToMsps = new Map<Id, List<ModemServicePlan__c>>();
	                
	                // For each ModemServicePlan...
	                for (ModemServicePlan__c msp : msps.values()) {
	                    // get the Modem
	                    final Modem__c modem = modems.get(msp.Modem__c);
	                    
	                    // get the Id of the Terminal Type used by the Terminal associated with that modem
	                    final Id terminalTypeId = modem.Terminal__r.TerminalType__c;
	                    
	                    // lookup the list of ModemServicePlans in the map associated with the terminalTypeId for this msp.
	                    List<ModemServicePlan__c> mspListForTerminalType = terminalTypeToMsps.get(terminalTypeId);
	                    
	                    // If this is the first ModemServicePlan for the terminalTypeId, the list will be null and will need to be initialized.
	                    if (null == mspListForTerminalType) {
	                        mspListForTerminalType = new List<ModemServicePlan__c>();
	                    }
	                    
	                    // Add msp to the list of ModemServicePlans for the terminalTypeId
	                    mspListForTerminalType.add(msp);
	                    terminalTypeToMsps.put(terminalTypeId, mspListForTerminalType);
	                }
	                
	                // Use the mapping from above to create the error map
	                for (Id terminalTypeId : terminalTypeToMsps.keySet()) {
	                    final String errorMessage = errorMessagePrefix + SNG_HtmlUtilities.getHtmlSalesforceRecordLinkListString(terminalTypeToMsps.get(terminalTypeId));
	                    errors = SNG_Product2.addError(errors, terminalTypesBecomingInactive.get(terminalTypeId), errorMessage);
	                }
	            }
	        }
        }
        
        return errors;
    }
    
    /**
     * Returns a new map containing only the Terminal Type Products from the given products map
     * 
     * @param   products        Map of products
     * @return                  Map of Terminal Type Products
     */
    private static Map<Id, Product2> extractTerminalTypes(final Map<Id, Product2> products) {
        return SNG_Product2.extractProductsWithMatchingRecordType(products, SNG_Terminal.TERMINAL_TYPE_RECORD_TYPE_NAME);
    }
	 	 
}