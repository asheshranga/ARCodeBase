public with sharing class SNG_ModemValidation {

	private static final String VALIDATION_EXCEPTION_MESSAGE_PREFIX = 'Could not validate modems; ';

	@testVisible
	private static final String NULL_EXCEPTION_MESSAGE_PREFIX = VALIDATION_EXCEPTION_MESSAGE_PREFIX + 'null ';

	/**
	 *  Validates modem changes identified in a "before update" trigger. Supports both the
	 *  update case and insert case (i.e. oldModems is an empty map)
	 *
	 *  @param oldModems		old modems from trigger
	 *  @param newModems		new modems from trigger
	 *  @return					map of modems with errors
	 */
    public static Modem__c[] validateBeforeUpdate(final Map<Id, Modem__c> oldModems, final Modem__c[] newModems, final Map<Modem__c, String> modemError) {
    	SNG_ExceptionUtil.throwIfNullObject(oldModems, NULL_EXCEPTION_MESSAGE_PREFIX + 'oldModems');
    	SNG_ExceptionUtil.throwIfNullObject(newModems, NULL_EXCEPTION_MESSAGE_PREFIX + 'newModems');
    	SNG_ExceptionUtil.throwIfNullObject(modemError, NULL_EXCEPTION_MESSAGE_PREFIX + 'modemError');
		return validateModemsForInsertOrUpdate(oldModems, newModems, modemError);
    }

    /**
     * Validates modem changes identified in a "before delete" trigger. Supports only the delete case.
     *
     * @param oldModems		old modems from trigger
     * @return         		list of modems passing validation
     */
    public static Modem__c[] validateBeforeDelete(final Map<Id, Modem__c> oldModems, final Map<Id, String> modemError) {
    	SNG_ExceptionUtil.throwIfNullObject(oldModems, NULL_EXCEPTION_MESSAGE_PREFIX + 'oldModems');
    	SNG_ExceptionUtil.throwIfNullObject(modemError, NULL_EXCEPTION_MESSAGE_PREFIX + 'modemError');
    	return validateModemsNotAssociatedWithActiveMsps(oldModems, modemError);
    }

    /**
	 * Returns a map of invalid modems and corresponding error messages.
	 *
	 * 1) An initial traversal through the set of modems is used to build keysets and gather data
	 * from the modems that will be relevant to the ensuing validation. This step is necessary
	 * for a bulk-safe approach. It is an O(n) operation.
	 *
	 * 2) The modems to be upserted must first undergo validations on some of their individual fields.
	 * Any modems failing validation shall be filtered out before undergoing subsequent validation.
	 * This is an O(n) operation.
 	 *
 	 * 3) Next, the set of remaining modems attempting to be upserted should be checked for "duplicates."
 	 * An iteration through the set of new modems filters out any "duplicates" within the set. Care must
 	 * be taken in this traversal to make sure not to compare a modem to itself as a "duplicate".
 	 * The duplicates are flagged for errors, and thus are not to be upserted into the database.
 	 * This is an O(n^2) operation given that each modem is compared to the others in the set.
 	 *
 	 * 4) The resulting filtered set is then compared against the other modems in the database to check if
 	 * a new modem may be "duplicating" an already existing entry; in that case the new modem
 	 * is flagged with an error indicating the conflict, and is not upserted into the database.
 	 * This is an O(n*m) operation given that each new modem is compared to all others in the database
 	 *
 	 * Note that the term "duplicate" is used loosely here. The validations done within this method
 	 * protect, for example, that a given Terminal is associated with only 1 Modem.
 	 *
 	 * Note that this approach is conservative in its rejection strategy. If two modems were to swap
 	 * values for a field that is checked for uniqueness in the triggers, both could theoretically be admitted
 	 * since there would be no resulting conflict; however, this approach actually rejects them because each
 	 * "new modem" is compared to the relevant set of modems already in the database. As such,
	 * Accuracy has been compromised somewhat for complexity. This was chosen after finding a similar
	 * example on the developer force website:
	 * http://developer.force.com/cookbook/recipe/bulk-processing-records-in-a-trigger
	 *
	 * This method has a constant number of  SOQL calls to support bulksafe triggers. Time-complexity
	 * of the method overall is O(n*m) given the nested loops when validating against other terminals
	 *
	 *  @param oldModems		old modems from trigger
	 *  @param newModems		new modems from trigger
	 */
    private static Modem__c[] validateModemsForInsertOrUpdate(final Map<Id,Modem__c> oldModems,
    		final Modem__c[] newModems, final Map<Modem__c, String> modemError) {
    	/*********************************************************************************************
    	 * 1) Iterate through list of modems to gather data relevant to validations
    	 *********************************************************************************************/

    	//IDs of updated modems (i.e. not inserted; IDs are not yet assigned in 'before insert')
    	Set<Id> mIDs = new Set<Id>();
    	for (Modem__c newModem : newModems) {
    		//may be null in the case of insert, when IDs are not yet assigned
    		if (null != newModem.Id) {
    			mIDs.add(newModem.Id);
    		}
    	}

    	/*********************************************************************************************
    	 * 2) Check modems individually before comparing to others. A subset of modems that
    	 * pass this level of validation will be returned, and this filtered set may be used in the
    	 * subsequent check for uniqueness against other modems.
    	 *********************************************************************************************/
    	Modem__c[] newModemsFilteredSubset =
    			validateModemsIndividually(oldModems, newModems, mIDs, modemError);

    	/***********************************************************************************************
    	 * 3) Check remaining modems for uniqueness against one another. Modems that did not
    	 * pass individual validation should not be included, so they do not give rise to any
    	 * uniqueness conflict that would preclude other modems from being successfully admitted.
    	 ***********************************************************************************************/
    	newModemsFilteredSubset =
    			validateAgainstOtherNewModems(oldModems, newModemsFilteredSubset, modemError);

    	/***********************************************************************************************
    	 * 4) Check remaining modems for uniqueness against one another all other modems
    	 * present in database
    	 ***********************************************************************************************/
    	newModemsFilteredSubset =
    			validateAgainstAllOtherModems(oldModems, newModemsFilteredSubset, modemError);

        return getModemsPassingValidation(newModems, modemError);
    }

    /**
	 * Performs any validation on new modems that doesn't require comparison against other modems
     *
     * @param   oldModems   map of old Modems (before the change)
     * @param   newModems   map of new Modems (after the change)
     * @param   mIds 		IDs of updated modems (may be empty in insert case)
     * @param   modemError	map of "bad modems" to error messages
     * @return	        	Returns subset of new modems that passed validation
     */
    private static Modem__c[] validateModemsIndividually(final Map<Id, Modem__c> oldModems,
    		final Modem__c[] newModems, final Set<Id> mIDs, final Map<Modem__c, String> modemError) {
		/****************************************************
		 * 1. Build Lists and Maps for Bulksafe approach
		 ****************************************************/
		 
		 // Query for all active or Future MSPs associated with modems being updated. This will be empty for an insert trigger.
		 final Map<Id, ModemServicePlan__c> activeOrFutureMsps = new Map<Id, ModemServicePlan__c>([SELECT Id, Name, Modem__c, Modem__r.Name from ModemServicePlan__c 
		 		WHERE Modem__c = :mIDs AND (EndDate__c = null OR EndDate__c >= :DateTime.now().date())]);

		/**************************
		 * 2. Validate
		 **************************/

		 // Using newModemsFilteredSubset for each subsequent validation.
		 // This way, if one validation test fails, we don't bother running the other test for the same modem.
		Modem__c[] newModemsFilteredSubset = newModems;
		newModemsFilteredSubset = validateNoActiveOrFutureMspsIfTerminalNull(newModemsFilteredSubset, activeOrFutureMsps, modemError);
		newModemsFilteredSubset = validateNoAccountChangeWithActiveOrFutureMSP(oldModems, newModemsFilteredSubset, activeOrFutureMsps, modemError);
		return newModemsFilteredSubset;
    }

    /**
	 * Checks the updated/inserted modems for uniqueness against other modems being
	 * inserted/updated in bulk
     *
     * @param   oldModems   old Modems (before the change)
     * @param   newModems   new Modems (after the change) that have passed individual validation
     * @param   modemError	map of "bad modems" to error messages
     * @return	        	Returns subset of new modems that passed validation
     */
    private static Modem__c[] validateAgainstOtherNewModems(final Map<Id, Modem__c> oldModems,
    	                                                    final Modem__c[] newModems, final Map<Modem__c, String> modemError) {
		return validateAgainstOtherModems(oldModems, newModems, null, modemError);
    }

    /**
	 * Checks the updated/inserted modems for uniqueness against other modems in database
     *
     * @param   oldModems   old Terminals (before the change)
     * @param   newModems   new Terminals (after the change) that have passed individual validation
     * @param   modemError	map of "bad modems" to error messages
     * @return	        	Returns subset of new modems that passed validation
     */
    private static Modem__c[] validateAgainstAllOtherModems(final Map<Id, Modem__c> oldModems,
    		                                                final Modem__c[] newModems, final Map<Modem__c, String> modemError) {
    	// Get all modems relevant to uniquness checks to be performed
     	Modem__c[] otherModems = [SELECT Id, Name, Terminal__c FROM Modem__c];

		return validateAgainstOtherModems(oldModems, newModems, otherModems, modemError);
    }

    /**
	 * Checks the updated/inserted modems for uniqueness against another set of modems
	 *
	 * This helper method is used to check a set of modems for uniqueness against
	 * 1) themselves or
	 * 2) all other modems that presently exist in the database.
	 *
     * A resulting list of modems passing validation shall be built while iterating over the set
     * of new modems, and ultimately returned to the caller.
     *
     * In the first case where the new modems are to be compared against themselves, this dynamic
     * resulting list shall be used as the set of modems to be compared against. That is, only
     * once a modem has successfully passed validation will the subsequent iterative modems
     * be compared against it. Thus, the order of the newModems list will have bearing on the
     * results. Note that the first modem in the newModems list will always pass validation
     * (as there are no other modems to compare it against at the time it is processed)
     *
     * @param   oldModems   	old Modems (before the change)
     * @param   newModems   	new Modems (after the change) that have passed individual validation
     * @param   otherModems 	other set of modems to perform uniqueness checks against; should be
     * 							null if objective is to validate newModems against themselves
     * @param   modemError		map of "bad modems" to error messages
     * @return	        		Returns subset of new modems that passed validation
     */
    private static Modem__c[] validateAgainstOtherModems(final Map<Id, Modem__c> oldModems,
    		                                             final List<Modem__c> newModems, final Modem__c[] otherModems,
    		                                             final Map<Modem__c, String> modemError) {
    	Modem__c oldModem;
		Modem__c[] newModemsFilteredSubset = new List<Modem__c>();

		for (Modem__c newModem : newModems)
		{
			if (newModem.Id != null) //may be null in the case of insert, when IDs are not yet assigned
			{
				oldModem = oldModems.get(newModem.id);
			}

			// If validating against the other new modems, only compare for
			if (validateAgainstOtherModems(oldModem, newModem,
					(null == otherModems) ? newModemsFilteredSubset : otherModems,
					modemError))
			{
				newModemsFilteredSubset.add(newModem);
			}
		}
		return newModemsFilteredSubset;
    }

    /**
	 * Checks the updated/inserted modems for uniqueness against other modems in database
     *
     * @param   oldModem    old Modem (before the change)
     * @param   newModem    new Modem (after the change)
     * @param   otherModems	modems that have been queried to be relevant for comparison
     * @param   modemError	map of "bad modems" to error messages
     * @return	        	Returns true if there are no issues with the Modem, otherwise false
     */
    private static boolean validateAgainstOtherModems(final Modem__c oldModem,
    		                                          final Modem__c newModem, final Modem__c[] otherModems,
    		                                          final Map<Modem__c, String> modemError) {
    	if (SNG_Modem.isTerminalChanged(oldModem, newModem)) {
        	//Combine multiple validations into this conditional so as to iterate over otherModems only once
			for (Modem__c otherModem : otherModems) {
				// Make sure not to compare modem to itself.
				// Check for validation failures.
				if ((SNG_TriggerUtils.isInsert(oldModem, newModem) || otherModem.Id != newModem.Id)
						&& !validateTerminalNotAssociatedWithOtherModem(newModem, otherModem, modemError)) {
    				return false;
				}
			}
		}
        return true;
    }

    private static boolean validateTerminalNotAssociatedWithOtherModem(final Modem__c newModem, final Modem__c otherModem, final Map<Modem__c, String> modemError) {
    	boolean result = true;
    	if (!isTerminalNameEmpty(newModem) && isTerminalAssociatedWithModem(newModem, otherModem)) {
            final String errorMsg = 'Cannot associate modem with the specified terminal as it is already associated with another modem.';
            // Adding all errors to the Modem__c object rather than the field, in order to show links properly on custom Visualforce page.
            // This is also because on the custom Visualforce page, apex:pageMessages is used, and shows messages for the field anyways.
            //newModem.Terminal__c.addError(errorMsg);
            newModem.addError(errorMsg);
    		modemError.put(newModem, errorMsg);
    		result = false;
    	}
    	return result;
    }

    private static Modem__c[] validateNoActiveOrFutureMspsIfTerminalNull(final Modem__c[] newModems, 
    	                                                                 final Map<Id, ModemServicePlan__c> activeOrFutureMsps, final Map<Modem__c, String> modemError) {
    	// Filter out the modems which the Terminal is null
		final Modem__c[] modemsWithNullTerminal = getModemsWithNullTerminal(newModems);

		// Create mapping from Modem to MSPs for all modems failing validation
		final Map<Modem__c, ModemServicePlan__c[]> modemToMsps = createMappingFromModemToMsps(modemsWithNullTerminal, activeOrFutureMsps);

		// Add errors
		for (Modem__c modem : modemToMsps.keySet()) {
			final ModemServicePlan__c[] msps = modemToMsps.get(modem);
			final String ERROR_MESSAGE = 'Modems must have Terminals associated with them if they have'
                                       + ' active or future Modem / Service Plans. Please deactivate'
                                       + ' the following Modem / Service Plan(s) and try again: '
                                       + SNG_HtmlUtilities.getHtmlSalesforceRecordLinkListString(msps) + '.';
            // Adding all errors to the Modem__c object rather than the field, in order to show links properly on custom Visualforce page.
            // This is also because on the custom Visualforce page, apex:pageMessages is used, and shows messages for the field anyways.
            //modem.Terminal__c.addError(ERROR_MESSAGE, false);
            modem.addError(ERROR_MESSAGE, false);
            modemError.put(modem, ERROR_MESSAGE);
		}

		return getModemsPassingValidation(newModems, modemError);
    }

    private static Modem__c[] validateNoAccountChangeWithActiveOrFutureMSP(final Map<Id, Modem__c> oldModems, final Modem__c[] newModems, 
    	                                                                   final Map<Id, ModemServicePlan__c> activeOrFutureMsps, final Map<Modem__c, String> modemError) {
    	// Only running this validation for updates (not inserts)
		if (!oldModems.isEmpty()) {
		 	// Filter out the modems which the account is changing
		 	final Modem__c[] modemsWithAccountChanging = getModemsWithAccountChanging(oldModems, newModems);

		 	// Create mapping from Modem to MSPs for all modems failing validation
		 	final Map<Modem__c, ModemServicePlan__c[]> modemToMsps = createMappingFromModemToMsps(modemsWithAccountChanging, activeOrFutureMsps);

		 	// Add errors
		 	for (Modem__c modem : modemToMsps.keySet()) {
		 		final ModemServicePlan__c[] msps = modemToMsps.get(modem);
		 		String errorMsg = 'Cannot modify modem account unless all corresponding Modem / Service Plans end dates are in the past. Violating Modems / Service Plan(s): ' 
                                  + SNG_HtmlUtilities.getHtmlSalesforceRecordLinkListString(msps);
                
                // Adding all errors to the Modem__c object rather than the field, in order to show links properly on custom Visualforce page.
                // This is also because on the custom Visualforce page, apex:pageMessages is used, and shows messages for the field anyways.
                // False 2nd parameter indicates any HTML markup in the custom error message should NOT be escaped.
                //modem.Account__c.addError(errorMsg, false);
                modem.addError(errorMsg, false);
                modemError.put(modem, errorMsg);
		 	}
		 }

		 return getModemsPassingValidation(newModems, modemError);
    }

    private static Modem__c[] getModemsWithAccountChanging(final Map<Id, Modem__c> oldModems, final Modem__c[] newModems) {
    	final Modem__c[] modemsWithAccountChanging = new List<Modem__c>();
    	for (Modem__c newModem : newModems) {
    		if (isAccountChanged(oldModems.get(newModem.Id), newModem)) {
    			modemsWithAccountChanging.add(newModem);
    		}
    	}
    	return modemsWithAccountChanging;
    }

    /**
     * Returns whether the terminal associated with the modem object is an empty name.
     *
     * @param   newModem        The modem object's terminal reference to validate.
     *
     * @return                  Whether the terminal name associated with the modem is empty.
     */
    private static boolean isTerminalNameEmpty(final Modem__c newModem) {
    	return StringUtils.isEmpty(newModem.Terminal__c);
    }

    private static Modem__c[] getModemsWithNullTerminal(final Modem__c[] newModems) {
    	final Modem__c[] modemsWithNullTerminal = new List<Modem__c>();
    	for (Modem__c newModem : newModems) {
    		if (null == newModem.Terminal__c) {
    			modemsWithNullTerminal.add(newModem);
    		}
    	}
    	return modemsWithNullTerminal;
    }

    private static Map<Modem__c, ModemServicePlan__c[]> createMappingFromModemToMsps(final Modem__c[] modems, 
    	                                                                             final Map<Id, ModemServicePlan__c> activeOrFutureMsps) {
    	final Map<Modem__c, ModemServicePlan__c[]> modemToMsps = new Map<Modem__c, ModemServicePlan__c[]>();
    	for (ModemServicePlan__c msp : activeOrFutureMsps.values()) {
    		final Modem__c modem = getModemForMsp(msp, modems);
    		if (null != modem) {
    			final ModemServicePlan__c[] msps = modemToMsps.containsKey(modem) ? modemToMsps.get(modem) : new List<ModemServicePlan__c>();
    			msps.add(msp);
    			modemToMsps.put(modem, msps);
    		}
    	}
    	return modemToMsps;
    }

    private static Modem__c getModemForMsp(final ModemServicePlan__c msp, final Modem__c[] newModems) {
    	// NOTE: This method should never return null.
    	final Modem__c modemForMsp = null;
    	for (Modem__c modem : newModems) {
    		if (modem.Name == msp.Modem__r.Name) {
    			modemForMsp = modem;
    		}
    	}
    	return modemForMsp;
    }

    /**
     * Returns whether the terminal associated with the modem object is already associated
     * with an another modem object or not.
     *
     * @param   newModem        The modem object's terminal reference to validate.
     * @param   otherModem      THe modem object to compare against
     *
     * @return                  Whether the terminal is already associated with otherModem or not
     */ 
    private static boolean isTerminalAssociatedWithModem(final Modem__c newModem, final Modem__c otherModem) {
        return otherModem.Terminal__c == newModem.Terminal__c;
    }

    /**
     * Verifies the account referenced in Modem has been changed in the update.
     *
     * @param   oldModem        The modem object prior to the update.
     * @param   newModem        The modem object after the update.
     *
     * @return                  Whether the account object has been updated or not.
     */
    private static boolean isAccountChanged(final Modem__c oldModem, final Modem__c newModem) {
        return null == oldModem || oldModem.Account__c != newModem.Account__c;
    }

    private static Modem__c[] validateModemsNotAssociatedWithActiveMsps(final Map<Id, Modem__c> oldModems, final Map<Id, String> modemError) {
    	// Query for Active MSPs using any of the modems in oldModems
    	Map<Id, ModemServicePlan__c> activeMsps = new Map<Id, ModemServicePlan__c>([SELECT Id, Name, Modem__c from ModemServicePlan__c WHERE Modem__c = :oldModems.keySet() AND Status__c = :SNG_ModemServicePlan.MSP_STATUS_ACTIVE]);

    	// Get mapping of Modem__c.Id to List<ModemServicePlan__c> for all active MSPs using any of the modems in oldModems
    	Map<Id, List<ModemServicePlan__c>> modemstoActiveMsps = new Map<Id, List<ModemServicePlan__c>>();
    	for (ModemServicePlan__c msp : activeMsps.values()) {
    		List<ModemServicePlan__c> activeMspsForModem = modemsToActiveMsps.containsKey(msp.Modem__c) ? modemsToActiveMsps.get(msp.Modem__c) : new List<ModemServicePlan__c>();
    		activeMspsForModem.add(msp);
    		modemsToActiveMsps.put(msp.Modem__c, activeMspsForModem);
    	}

    	// Add errors to each modem in modemsToActiveMsps
    	for (Id modemId : modemsToActiveMsps.keySet()) {
    		Modem__c modem = oldModems.get(modemId);
    		final String errorMsg = 'Modem: ' + SNG_HtmlUtilities.getHtmlSalesforceRecordLinkString(modem) + 
    								' cannot be deleted as the following active Modem / Service Plan(s) use it: ' +
    								SNG_HtmlUtilities.getHtmlSalesforceRecordLinkListString(modemsToActiveMsps.get(modemId));
    		SNG_TriggerUtils.addError(modemError, modem, SNG_HtmlUtilities.getHtmlMessageBoldRedFontFormat(errorMsg));
    	}

    	return getModemsPassingValidation(oldModems, modemError);
    }

    private static Modem__c[] getModemsPassingValidation(final Map<Id, Modem__c> allModems, final Map<Id, String> modemError) {
    	// Create list of modems passing validation
    	Modem__c[] modemsPassingValidation = new List<Modem__c>();
    	for (Id modemId : allModems.keySet()) {
    		if (!modemError.containsKey(modemId)) {
    			modemsPassingValidation.add(allModems.get(modemId));
    		}
    	}
    	return modemsPassingValidation;
    }

    private static Modem__c[] getModemsPassingValidation(final Modem__c[] allModems, final Map<Modem__c, String> modemError) {
    	// Create list of modems passing validation
    	final Modem__c[] modemsPassingValidation = new List<Modem__c>();
    	for (Modem__c modem : allModems) {
    		if (!modemError.containsKey(modem)) {
    			modemsPassingValidation.add(modem);
    		}
    	}
    	return modemsPassingValidation;
    }

}