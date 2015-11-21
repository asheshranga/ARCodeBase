public with sharing class SNG_ModemServicePlanValidation {
    
	/**
	 * Validates the deletion of Modem / Service Plans 
	 *
	 * @param 	oldMsps		List of Modem/Service Plan records for deletion
	 * @return				Map of Modem/Service Plans objects and their corresponding error(s) if validation error occurs 
	 */
	public static Map<ModemServicePlan__c, String> validateBeforeDelete(List<ModemServicePlan__c> oldMsps)
	{ 
		Map<ModemServicePlan__c, String> errors = new Map<ModemServicePlan__c, String>();
		
		// Modem/Service Plans must be inactive before can be deleted
		return validateModemServicePlansInactive(oldMsps, errors);
	}
	
	
	/**
	 * Validates the insertion of Modem / Service Plans
	 *
	 * @param 	newMsps		List of Modem/Service Plan records for insertion
	 * @param	oldMsps		List of old
	 * @return 				Map of Modem/Service Plans objects and their corresponding error(s) if validation error occurs
	 */
	public static Map<ModemServicePlan__c, String> validateBeforeInsert(List<ModemServicePlan__c> newMsps)
	{
		return modemServicePlanValidation(new Map<Id, ModemServicePlan__c>(), newMsps);
	}
	
	
	/**
	 * Validates the update of Modem/Service Plans
	 *
	 * @param	oldMsps		The Modem / Service Plan objects prior to update			
	 * @param	newMsps		The Modem / Service Plan objects after the update
	 * @return				Whether the Modem / Service Plan object is valid or not.
	 */
	public static Map<ModemServicePlan__c, String> validateBeforeUpdate(Map<Id, ModemServicePlan__c> oldMsps, Map<Id, ModemServicePlan__c> newMsps)
	{
		Map<ModemServicePlan__c, String> errors = new Map<ModemServicePlan__c, String>();
		
		List<ModemServicePlan__c> mspsToValidate = new List<ModemServicePlan__c>();
		
		// Only validate MSP if the date fields (StartDate__c and EndDate__c) have changed. 
		// Salesforce validation rules prohibit Modem__c and ServicePlan__c fields from being modified. 
		for (Id newMspId : newMsps.keySet())
		{ 
			ModemServicePlan__c oldModemServicePlan = oldMsps.get(newMspId);
			ModemServicePlan__c newModemServicePlan = newMsps.get(newMspId);
			
			// If either the StartDate__c or EndDate__c has changed perform same validation 
			// on newMsps as in insertion
			if(isStartDateChanged(oldModemServicePlan, newModemServicePlan) || isEndDateChanged(oldModemServicePlan, newModemServicePlan))
			{
				mspsToValidate.add(newModemServicePlan);
			}
		}
		
		return modemServicePlanValidation(oldMsps, mspsToValidate);
	}
	
	
	/**
	 * Validates the insertion or update of a group of Modem/Service Plans, returning a map of invalid Modem/Service Plans
	 * and their corresponding error messages. 
	 * 
	 * 1) The MSPs are traversed to query for a map of service plans and a map  of modems that are associated with all the 
	 * Modem/Service Plans being processed. Afterwards, the map of service plans and the map of modems are used to query for 
	 * their associated Service Plan Types and Terminal Types. 
	 *   
	 * 2) For any Modem/Service Plans that do not have an end-date, auto complete an end-date for the Modem/Service Plan.
	 * 
	 * 3) Validate each Modem/Service Plan individually. Each MSP will have each of their fields validated. Any 
	 * Modem/Service Plan that fails will be filtered out before the next validation. 
	 *
	 * 4) The remaining Modem/Service Plans are compared against other Modem/Service Plans in the Salesforce database to
	 * check if a new Modem/Service Plan "duplicates" or "overlaps" with any existing Modem/Service Plans. "Duplicate" or
	 * "Overlaps" means any Modem/Service Plans that are associated with the same Modem may not have overlapping
	 * start-date/end-dates.  Any Modem/Service Plan that fails will be filtered out before the next validation. 
	 * 
	 * 5) The remaining Modem/Service Plans are verified against other remaining new Modem/Service Plans. This set is verified
	 * against itself to make sure there are no conflicts. Modem/Service Plans that reference the same modem, may not have
	 * overlapping start-date/end-dates. Should there be a conflict, the first Modem/Service Plan that is to be inserted or
	 * updated will be allowed to pass, while the Modem/Service Plan that is being inserted or updated later will be flagged
	 * with an error. 
	 * 
	 * @param	oldMsps		Map of Modem/Service Plans prior to the update. Will be an empty map if operation is an insertion
	 * @param	newMsps 	Map of Modem/Service Plans to be verified for insertion or Map of MSPs after the update
	 * @return				Map of "bad Modem/Service Plans" to error messages 
	 */
	private static Map<ModemServicePlan__c, String> modemServicePlanValidation(Map<Id, ModemServicePlan__c> oldMsps, List<ModemServicePlan__c> newMsps)
	{
    	// Create list of Modem IDs referenced by newMsps, use to build map of modems and terminals
    	List<Id> modemIdsToQuery = buildModemIdList(newMsps);
		Map<Id, Modem__c> modemMap = SNG_Modem.buildMapOfModems(modemIdsToQuery);
		Map<Id, Terminal__c> terminalMap = buildTerminalMap(modemMap.values());

    	// List of all MSPs in SF database with same modems as MSPs to be processed sorted by start date 
		List<ModemServicePlan__c> modemServicePlansSortedStartDate = SNG_ModemServicePlan.retrieveMspsOrderedByStartDate(modemIdsToQuery);

    	// Create a map of Modem ID to a corresponding list of MSPs that are associated to the Modem. This will represent the state of 
    	// the Salesforce Modem/Service Plan database
    	Map<Id, List<ModemServicePlan__c>> sfMspDatabaseSub = SNG_ModemServicePlan.buildMapOfMspsWithSameModems(modemServicePlansSortedStartDate);

		// Create list of Service Plan IDs referenced by newMsps and MSPs in database, use to build map of Service Plans
		List<Id> servicePlanIdsToQuery = new List<Id>();
    	buildServicePlanIdList(newMsps, modemServicePlansSortedStartDate, servicePlanIdsToQuery);
    	Map<Id, ServicePlan__c> servicePlanMap = SNG_ServicePlan.buildMapOfServicePlans(servicePlanIdsToQuery);
    	
		// Build list of Terminal Type IDs, and Service Plan Type IDs from the service plans
		List<Id> servicePlanTypeIdsToQuery = new List<Id>();
		List<Id> terminalTypeIdsToQuery = new List<Id>();
		buildServicePlanTypeIdsList(servicePlanMap.values(), servicePlanTypeIdsToQuery);
		buildTerminalTypeIdsList(modemMap.values(), terminalTypeIdsToQuery);
		
		// Query for Service Plan Types referenced by the Service Plans
		Map<Id, Product2> servicePlanTypeMap = new Map<Id, Product2>([SELECT Id, Name, IsActive FROM Product2 WHERE Id IN :servicePlanTypeIdsToQuery]);
				
		// Query for Terminal Types that are referenced by the Modems
		Map<Id, Product2> terminalTypeMap = new Map<Id, Product2>([SELECT Id, Name, IsActive FROM Product2 WHERE Id IN :terminalTypeIdsToQuery]);
	
    	// List of the new MSPs (to-be-inserted/updated) whose dates do not conflict with one another 
    	List<ModemServicePlan__c> newMspsNoConflictWithEachOther = new List<ModemServicePlan__c>(); 

		// List of Modems to update at the end of the trigger
		List<Modem__c> modemsToUpdate = new List<Modem__c>();

		// List of Terminals to update at the end of the trigger
		List<Terminal__c> terminalsToUpdate = new List<Terminal__c>();

		List<ModemServicePlan__c> mspsToUpdate = new List<ModemServicePlan__c>();

		List<ModemServicePlan__c> mspsToDelete = new List<ModemServicePlan__c>();

		Map<ModemServicePlan__c, String> errors = new Map<ModemServicePlan__c, String>();

		// Iterate through each Modem/Service Plan, validate them individually and against the database
		// If it is valid, enter it into the running Map of Modem/Service Plans
		for (ModemServicePlan__c msp : newMsps)
		{	
			// If a Moved MSP (moves can only happen on insert operation)
			if (oldMsps.isEmpty() && SNG_ModemServicePlanMove.isMovedMsp(msp, sfMspDatabaseSub, servicePlanMap))
			{
				// Validate Moved MSPs 
				if (SNG_ModemServicePlanMove.validateMovedMsp(msp, sfMspDatabaseSub, modemMap, servicePlanMap, errors)) 
				{
					// Validate Modem/Service Plan's input is valid and it does not conflict with other new Msps for bulk insert/updates 
					if (validateModemServicePlansIndividually(msp, modemMap, servicePlanMap, servicePlanTypeMap, terminalTypeMap, true, errors)
						&& validateAgainstOtherNewModemServicePlans(msp, newMspsNoConflictWithEachOther, errors))
					{
						// Perform account change on Modem if necessary
						SNG_ModemServicePlanMove.processAccountChange(msp, modemMap, servicePlanMap, 
																		terminalMap, modemsToUpdate, terminalsToUpdate);

						// At this point, Moved MSP is valid and should be added to the database - perform shifts and deletes
						// Shift overlapping MSP
						try {
							SNG_ModemServicePlanMove.shiftOverlappingMsp(msp, sfMspDatabaseSub, mspsToUpdate);
						}
						catch (SNG_Exception e) {
							SNG_ViasatLogHandler.Log(ViasatLogHandler.SeverityTypeEXCEPTION, e.getMessage(), e.getStackTraceString());
							final String ERROR_MESSAGE = 'Unexpected error processing Modem/Service Plan';
							addError(errors, msp, ERROR_MESSAGE);
						}

						// delete future MSPs that do not have the same account
						SNG_ModemServicePlanMove.deleteFutureMspsWithDiffAccount(msp, sfMspDatabaseSub,
																				 modemMap, servicePlanMap, mspsToDelete, errors);

						// Add the Moved MSP to the running list
						List<ModemServicePlan__c> mspsWithSameModem = sfMspDatabaseSub.get(msp.Modem__c);

						if (mspsWithSameModem == null) {
							mspsWithSameModem = new List<ModemServicePlan__c>();
						}
						
						mspsWithSameModem.add(msp);
						
						sfMspDataBaseSub.put(msp.Modem__c, mspsWithSameModem);
					}
				}
			}
			// Regular insert/update
			else 
			{
				// Assign end-date to MSP if it does not have specified end-date
				SNG_ModemServicePlan.autoCompleteEndDateIfEmpty(msp, servicePlanMap, modemServicePlansSortedStartDate);

				// if MSP is valid individually and does not conflict with any MSPs in database, add in
				// running database, so that next iteration will compare against the valid new insert
				if (validateModemServicePlansIndividually(msp, modemMap, servicePlanMap, servicePlanTypeMap, terminalTypeMap, false, errors)
					&& validateAgainstDatabase(oldMsps, sfMspDatabaseSub, msp, errors)) 
				{
					List<ModemServicePlan__c> mspsWithSameModem = sfMspDatabaseSub.get(msp.Modem__c);
					
					// There are no MSPs associated with the modem of current MSP
					if (mspsWithSameModem == null) {
						mspsWithSameModem = new List<ModemServicePlan__c>();
						mspsWithSameModem.add(msp);
					}
					else {
						mspsWithSameModem.add(msp);
					}
					
					sfMspDataBaseSub.put(msp.Modem__c, mspsWithSameModem);
				}
			}
		}

		// Update MSPs 
		update mspsToUpdate;

		// Delete MSPs
		delete mspsToDelete;

		// Update Modems and Terminals that have accounts changed
		SNG_Modem.reassociateModemWithTerminal(modemsToUpdate, terminalsToUpdate);

		return errors;
	}


	/**
	 * Performs validation on new Modem/Service Plans that doesn't require comparison against other Modem/Service Plans. 
	 *  
	 * @param	msp					The Modem/Service Plan to validate
	 * @param	modems				The modems referenced by the Modem/Service Plans in the newMsps parameter
	 * @param	servicePlans		The service plans referenced by the Modem/Service Plans in the newMsps parameter
	 * @param	servicePlanTypes	The service plan types of the servicePlans parameter
	 * @param	terminalTypes		The terminal types of the terminals that are associated with the modems parameter
	 * @param	errors				Map of "bad Modem/Service Plans" to error messages
	 * @return 						Returns subset of new modem/service plans that passed validation
	 */
	private static boolean validateModemServicePlansIndividually(ModemServicePlan__c msp,
																	Map<Id, Modem__c> modems, 
																	Map<Id, ServicePlan__c> servicePlans,
																	Map<Id, Product2> servicePlanTypes,
																	Map<Id, Product2> terminalTypes,
																	Boolean isMovedMsp,
																	Map<ModemServicePlan__c, String> errors)
	{
		Modem__c modem = modems.get(msp.Modem__c);
		ServicePlan__c servicePlan = servicePlans.get(msp.ServicePlan__c);
		Product2 servicePlanType = servicePlanTypes.get(servicePlan.ServicePlanType__c);
		Product2 terminalType = terminalTypes.get(modem.Terminal__r.TerminalType__c);

		// If MSP being validated is a moved MSP
		if (isMovedMsp)
		{
			return validateModemServicePlanDateWithinServicePlanDate(msp, servicePlan, errors) 
					&& validateModemHasTerminalIfMspActiveOrFuture(msp, modem, errors);
		}
		// MSP being validated is regular MSP 
		else 
		{
			// If an MSP passes individual validation criteria, add it to the new subset
			return validateModemAndServicePlanAccountMatch(msp, modem, servicePlan, errors) 
					&& validateModemServicePlanDateWithinServicePlanDate(msp, servicePlan, errors) 
					&& validateModemHasTerminalIfMspActiveOrFuture(msp, modem, errors);
				// 	&& validateActiveServicePlanType(msp, servicePlanType, errors) 
				//	&& validateActiveTerminalType(msp, terminalType, errors))		
		}
	}

	
	/**
	 * Validate new Modem/Service Plans against Modem/Service Plan entries in the Salesforce database. 
	 *
	 * @param	oldMsps		Will be an empty Map if trigger is insertion. If trigger is update, will be a map of the MSPs prior to the update
	 * @param	newMsps		The Modem/Service Plans requiring validation for insertion, if update, the MSPs after the update
	 * @param	errors		Map of "bad Modem/Service Plans" to error messages
	 * @return				Subset of new Modem/Service Plans that passed validation
	 */
	private static boolean validateAgainstDatabase(Map<Id, ModemServicePlan__c> oldMsps,
													Map<Id, List<ModemServicePlan__c>> sfMspDatabaseSub, 
													ModemServicePlan__c msp, 
													Map<ModemServicePlan__c, String> errors)
	{ 	
		List<ModemServicePlan__c> mspsWithSameModem = sfMspDatabaseSub.get(msp.Modem__c);

		if (mspsWithSameModem == null)
		{
			mspsWithSameModem = new List<ModemServicePlan__c>();
		}

		// If operation is insert, there will be an empty oldMsps map, get will return null, if update return list of Msps
		return validateMspDateDoesNotConflictAgainstDatabase(msp, oldMsps.get(msp.Id), mspsWithSameModem, errors);
	}
	
	/**
	 * Checks to-be-inserted/updated Modem/Service Plan for uniqueness against other to-be-inserted/updated 
	 * Modem/Service Plans. Modem/Service Plans with the same modem will be checked for overlapping date period. 
	 *
	 * @param	mspToEval			The Modem/Service Plan requiring validation
	 * @param	noConflictMsps		To-be-inserted/updated MSPs that do not conflict with other to-be-inserted/updated MSPs
	 * @param	errors				Map of "bad Modem/Service Plans" to error messages
	 * @return						True if msp does not conflict with other to-be-inserted/updated MSPs. False otherwise. 	
	 */
	private static boolean validateAgainstOtherNewModemServicePlans(ModemServicePlan__c mspToEval, 
																	List<ModemServicePlan__c> noConflictMsps,
																	Map<ModemServicePlan__c, String> errors)
	{
		// Compare msp to other to-be-inserted MSPs that do not have existing conflicts
		if (noConflictMsps.isEmpty()) {
			noConflictMsps.add(mspToEval);
		}
		else 
		{ 
			for (ModemServicePlan__c validMsp : noConflictMsps)
			{
				// Only compare MSPs that have the same Modem
				if (mspToEval.Modem__c == validMsp.Modem__c)
				{
					// If mspToEval overlaps with an MSP of same modem, error
					if (!( (mspToEval.EndDate__c <= validMsp.StartDate__c) || (mspToEval.StartDate__c >= validMsp.EndDate__c) ))
					{
						final String ERROR_MESSAGE = 'Modem/Service Plan\'s dates overlap with another Modem/Service Plan with the same modem. '; 
						addError(errors, mspToEval, ERROR_MESSAGE);
						return false;	
					}
				}
			}

			// mspToEval does not conflict with other to-be-inserted/updated MSPs, add to noConflictMsps list
			noConflictMsps.add(mspToEval);
		}

		return true;
	}

	/**
	 * Validate that the MSP active date does not conflict/overlap with any other MSPs (from Salesforce database) 
	 * that have the same modem. 
	 *
	 * The list of database MSPs to compare the to-be-evaluated MSP against is sorted by the 
	 * EndDate__c in descending order; making the assumption that there will be less MSPs that are active or will be 
	 * future active versus MSPs that have already expired for a modem.
	 * 
	 * If the operation is an update, the MSP under evaluation should not be compared against its database version.  
	 *
	 * @param	mspToEval				The Modem/Service Plan to evaluate
	 * @param	existingMsp				The database version of the Modem/Service plan if it exists. Null for insertion operations
	 * @param	mspsSortedByEndDate		All MSPs in the database sorted by end-date in descending order. i.e. 1-21-2015, 1-19-2015
	 * @param	errors					Map of "bad Modem/Service Plans" to error messages
	 * @return 							Whether or not the Modem/Service Plan conflicts with any existing MSP in the database
	 */
	private static boolean validateMspDateDoesNotConflictAgainstDatabase(ModemServicePlan__c mspToEval, ModemServicePlan__c existingMsp,  
																		List<ModemServicePlan__c> mspsWithSameModem, 
																		Map<ModemServicePlan__c, String> errors) 
	{
		boolean result = true;
		boolean operationIsUpdate = true;
		boolean notComparingAgainstSelf = true;
		
		List<ModemServicePlan__c> databaseMspsThatOverlap = new List<ModemServicePlan__c>();
				
		for (ModemServicePlan__c msp : mspsWithSameModem)
		{	
			// Check MSPs only if they have the same modem
			if (mspToEval.Modem__c == msp.Modem__c) 
			{
				// Check that mspToEval is not being compared to its database self if mspToEval already exists in the database
				// If operation is insertion, existingMsp == null, otherwise it is an update operation
				if (existingMsp != null)
				{
					notComparingAgainstSelf = (existingMsp.Id != msp.Id);
				}
				// For update operations, make sure mspToEval is not comparing against itself
				// For insert operations, comparingAgainstSelf will always be true
				if (notComparingAgainstSelf)
				{
					// If there is an overlap, mark the mspToEval as an error and return false
					if (!( (mspToEval.EndDate__c < msp.StartDate__c) || (mspToEval.StartDate__c > msp.EndDate__c) ))
					{ 
						// Add the database MSP that mspToEval overlaps with to the list
						databaseMspsThatOverlap.add(msp);
						result = false;
					}						
				}
			}
		}
		
		// If mspToEval overlaps with any MSPs w/ same Modem from the database, add error to object
		if (!result)
		{ 
			final String ERROR_MESSAGE = 'The following Modem/Service plan(s): ' +  SNG_HtmlUtilities.getHtmlSalesforceRecordLinkListString(databaseMspsThatOverlap) + 
                                         ' overlap the current start and end dates selected (' + mspToEval.StartDate__c.format() + ' - ' + mspToEval.EndDate__c.format() + ').' +
                                         ' Please ensure no service dates overlap.';
			addError(errors, mspToEval, ERROR_MESSAGE);
		}
		
		return result;
	}

	
	
	/**
	 * Checks that an MSP's dates does not conflict/overlap with the dates of a list of valid MSPs, that have the same 
	 * Modem as the MSP being evaluated. 
	 * 
	 * @param	mspToEvaluate	The MSP to validate
	 * @param	validMsps		List of valid MSPs to compare the MSP against
	 * @param	errors			Map of "bad Modem/Service Plans" to their corresponding error messages
	 * @return					Whether or not the Modem/Service Plan's dates conflict with any valid MSP's dates. 
	 */
	private static boolean mspDateDoesNotConflictWithValidMsp(ModemServicePlan__c mspToEvaluate, List<ModemServicePlan__c> validMsps, 
																Map<ModemServicePlan__c, String> errors)
	{	
		// Compare the mspToEvaluate to each valid MSP
		for (ModemServicePlan__c msp : validMsps)
		{
			// If the to-be-evaluated MSP's dates overlap with any of the valid MSPs' dates, mark it as an error
			if (!( (mspToEvaluate.EndDate__c <= msp.StartDate__c) || (mspToEvaluate.StartDate__c >= msp.EndDate__c) ))
			{
				final String ERROR_MESSAGE = 'Modem/Service Plan\'s dates overlap with another Modem/Service Plan with the same modem. '; 
				addError(errors, mspToEvaluate, ERROR_MESSAGE);
				return false;		
			}
		}
		
		return true;
	}
	
	
    /**
     * Validates that the Service Plan associated with the MSP has an active Service Plan Type
     *
     * @param	msp				The Modem / Service Plan object to validate
     * @return					Whether Modem / Service Plan has a Service Plan with an active Service Plan Type	 
     */ 
/*    private static boolean validateActiveServicePlanType(ModemServicePlan__c msp, Product2 servicePlanType, Map<ModemServicePlan__c, String> errors) 
    {
	   boolean result = true; 
			 
	   // If the MSP is being set to active or to become active on a future date, make sure service plan type is active
	   if (msp.EndDate__c >= Datetime.now().dateGMT()) 
	   { 	
	    	if (servicePlanType.IsActive == false) 
	    	{
	    		final String ERROR_MESSAGE = 'The Service Plan has an inactive service plan type: '  
	    									+ SNG_HtmlUtilities.getHtmlSalesforceRecordLinkString(servicePlanType) 
	    									+ ' Modem / Service Plan cannot be activated.';
	    		addError(errors, msp, ERROR_MESSAGE);
	    		result = false;   
	    	}
	   }
       return result;
	}
*/

    /**
     * Validates that the Modem associated with the MSP has an active Terminal Type
     *  
     * If the MSP is inactive, it does not matter if the modem has a Terminal or not, and the status of the TerminalType does not matter
     * 
     * If the MSP is active or will be active in the future, the MSP MUST have a Terminal, this check should have already been
     * performed by validateModemHasTerminalIfMspActiveOrFuture() method. 
     * 
     * Hence, MSPs that reach this method will either be inactive (with or without a Terminal) or active/future active (with a Terminal).
     * There can be no MSPs that are being evaluated in this method that are active/future active with no Terminals. 
     * Additionally, Terminals are required to have a TerminalType, so if an MSP is active/future active, it has a TerminalType.
     * 
     * @param	msp				The Modem / Service Plan object to validate
     * @param	terminalType	The Terminal Type of the Terminal referenced by the Modem of the Modem/Service Plan
     * @param	errors			Map of "bad Modem/Service Plans" to error messages
     * @return 					Whether the Modem/Service Plan has an active Terminal Type
     */ 
/*
    private static boolean validateActiveTerminalType(ModemServicePlan__c msp, Product2 terminalType, Map<ModemServicePlan__c, String> errors) 
    { 
		boolean result = true; 
		
		// If the MSP is active or to become active on a future date, terminal type must be active
		if (msp.EndDate__c >= DateTime.now().dateGMT())
		{
			if (terminalType.isActive == false)
			{
				final String ERROR_MESSAGE = 'The Modem has an inactive terminal type: ' 
											+ SNG_HtmlUtilities.getHtmlSalesforceRecordLinkString(terminalType) 
											+ ' Modem / Service Plan cannot be activated.';
				addError(errors, msp, ERROR_MESSAGE);
				result = false; 
			}
		}
		
		return result;  
    }
*/    
    
    /**
     * Validates the Modem and Service Plan accounts match.
     *
     * @param   msp		    The Modem / Service Plan objects to update if there is a mismatch.
     * @param   modem       The modem object to validate.
     * @param   sp          The Service Plan object to validate.
     * @param	errors		Map of "bad" Modem/Service Plans to their corresponding error messages.					
     * @return              Whether or not the Modem/Service Plan's modem and service plan have matching accounts.
     */ 
	private static boolean validateModemAndServicePlanAccountMatch(ModemServicePlan__c msp, Modem__c modem, ServicePlan__c servicePlan, 
																Map<ModemServicePlan__c, String> errors) 
	{
		boolean retVal = (modem.Account__c == servicePlan.Account__c); 
		
		// If the MSP's modem and service plan accounts are different, issue error
		if (!retVal)
		{
			final String ERROR_MESSAGE = 'Modem account (' + modem.Account__r.Name + ') and Service Plan account (' + servicePlan.Account__r.Name + ') must match.';
			addError(errors, msp, ERROR_MESSAGE);
		}
		
		return retVal;
	}


    /**
     * Validates that if the Modem / Service Plan is Active or starts in the future, 
     * its Modem has a Terminal associated
     *
     * @param 	msp		The Modem / Service Plan to validate
     * @param	modem	The modem object to validate.
     * @param	errors	Map of "bad" Modem/Service Plans to their corresponding error messages
     * @return	   		True if validation passes, otherwise false
     */
    private static boolean validateModemHasTerminalIfMspActiveOrFuture(ModemServicePlan__c msp, Modem__c modem, Map<ModemServicePlan__c, String> errors) 
    {
    	boolean result = true;
		
		// Check if MSP is currently active or will be active
		if (msp.EndDate__c >= Datetime.now().dateGMT()) 
		{
			// If the MSP's modem does not have a terminal when it is active or will be active, set error
			if (modem.Terminal__c == null) 
			{
				result = false;
				final String ERROR_MESSAGE = 'Modems must have Terminals associated with them in order'
				                           + ' to link them to an active or future Modem / Service Plan.'
				                           + ' Please associate a Terminal with the following Modem and try again: '
				                           + SNG_HtmlUtilities.getHtmlSalesforceRecordLinkString(modem) + '.';
            	msp.Modem__c.addError(ERROR_MESSAGE, false);
            	errors.put(msp, ERROR_MESSAGE);
			}
		}
		
		return result;
    }
    

	/**
	 * Validates that the Modem/Service Plan start and end dates are within its Service Plan's start and end dates
	 *
	 * @param	msp 	The Modem/Service Plan to validate
	 * @param	sp		The Modem/Service Plan's Service Plan
	 * @param	errors	Map of "bad" Modem/Service Plans to their corresponding error messages 
	 * @return			Whether the Modem/Service Plan's dates are within its Service Plan's dates 
	 */
	private static boolean validateModemServicePlanDateWithinServicePlanDate(ModemServicePlan__c msp, ServicePlan__c sp, 
																			Map<ModemServicePlan__c, String> errors)
	{
    	boolean retValue = true;
    	    	
        if(msp.StartDate__c < sp.StartDate__c || msp.StartDate__c > sp.EndDate__c) 
        { 
            final String ERROR_MESSAGE = 'Modems/Service Plan\'s start date (' + msp.StartDate__c.format() + ') must be within range of the Service Plan\'s dates (' 
                                        + sp.StartDate__c.format() + ' - ' + sp.EndDate__c.format() + '):' + SNG_HtmlUtilities.getHtmlSalesforceRecordLinkString(sp);
        
            msp.StartDate__c.addError(ERROR_MESSAGE, false);
            errors.put(msp, ERROR_MESSAGE);
            retValue = false;
        }  
        else if (msp.EndDate__c > sp.EndDate__c)
        {
            final String ERROR_MESSAGE = 'Modems/Service Plan\'s end date (' + msp.EndDate__c.format() + ') must be within range of the Service Plan\'s dates (' 
                                        + sp.StartDate__c.format() + ' - ' + sp.EndDate__c.format() + '):' + SNG_HtmlUtilities.getHtmlSalesforceRecordLinkString(sp);
        
            msp.EndDate__c.addError(ERROR_MESSAGE, false);
            errors.put(msp, ERROR_MESSAGE);
            retValue = false;
        }
        
        return retValue;
	}

	
    /**
     * Validates that Modem/Service Plans are inactive 
     *
     * @param   msps	The Modem/Service Plans to check whether active or inactive
     * @param	errors	Map of "bad" Modem/Service Plans to their corresponding error messages
     * @return      	Map of "active" Modem/Service Plans and their error messages
     */
	private static Map<ModemServicePlan__c, String> validateModemServicePlansInactive(List<ModemServicePlan__c> msps, Map<ModemServicePlan__c, String> errors)
	{
		for (ModemServicePlan__c msp : msps) 
		{
			boolean mspInactive = (msp.Status__c != SNG_ModemServicePlan.MSP_STATUS_ACTIVE);
			
			if (!mspInactive)
			{
				final String ERROR_MESSAGE = 'Modem/Service Plan: ' + SNG_HtmlUtilities.getHtmlSalesforceRecordLinkString(msp)
												+ ' cannot be deleted as it is currently \'Active\'';
				
				addError(errors, msp, SNG_HtmlUtilities.getHtmlMessageBoldRedFontFormat(ERROR_MESSAGE));
			}
		}
		
		return errors; 	
	}
	
	

	
	
	/**
	 * Build a list of modem IDs and service plan IDs from the list of MSPs
	 * 
	 * @param	msps				List of Modem/Service Plans to evaluate
	 */
	private static List<Id> buildModemIdList(List<ModemServicePlan__c> msps)
	{
		Set<Id> modemIds = new Set<Id>();
		
		for (ModemServicePlan__c msp : msps)
		{
			modemIds.add(msp.Modem__c);
		}

		return new List<Id>(modemIds);
	}

	private static void buildServicePlanIdList(List<ModemServicePlan__c> mspsToEval, 
												List<ModemServicePlan__c> mspsFromDb,
												List<Id> servicePlanIds)
	{
		for (ModemServicePlan__c msp : mspsToEval)
    	{
    		servicePlanIds.add(msp.ServicePlan__c);
    	}

    	for (ModemServicePlan__c msp : mspsFromDb)
    	{
    		servicePlanIds.add(msp.ServicePlan__c);
    	}
	}


	/**
	 * Build lists of Service Plan Type IDs from a list of Service Plan Objects
	 * 
	 * @param	servicePlans		List of Service Plan Objects to evaluate
	 * @param	servicePlanTypeIds	List of IDs of the Service Plan Types
	 */	
	private static void buildServicePlanTypeIdsList(List<ServicePlan__c> servicePlans, List<Id> servicePlanTypeIds)
	{
		for (ServicePlan__c sp : servicePlans)
		{
			servicePlanTypeIds.add(sp.ServicePlanType__c);
		}
	}
	
	/**
	 * Build a list of Terminal Type IDs from a list of modems
	 * 
	 * @param	modems				List of modem objects
	 * @param	terminalTypeIds		List of TerminalType IDs that are referenced by the modems
	 */
	private static void buildTerminalTypeIdsList(List<Modem__c> modems, List<Id> terminalTypeIds)
	{
		for (Modem__c modem : modems)
		{
			// If the modem has a Terminal, add the Terminal's TerminalType__c to terminalTypes list
			if (modem.Terminal__c != null) {
				terminalTypeIds.add(modem.Terminal__r.TerminalType__c);
			}
		}
	}
	
	/**
	 * Create a map of Terminal IDs to Terminal objects given a list of modem objects
	 *
	 * @param	modems		List of modem objects
	 * @return				Map of Terminal IDs to their respective Terminal objects	 
	 */ 
	public static Map<Id, Terminal__c> buildTerminalMap(List<Modem__c> modems) {

		// Create list of Terminal IDs from the modems
		List<Id> terminalIds = new List<Id>();

		for (Modem__c modem : modems) 
		{
			if (modem.Terminal__c != null) 
			{
				 terminalIds.add(modem.Terminal__c);
			}
		}

		// Using Terminal IDs, query and build Map of Terminal IDs to Terminal objects
		return SNG_Terminal.buildMapOfTerminals(terminalIds);
	}
	
	/**
	 * Adds an error messsage to the SObject record and adds it into the error map passed in. 
	 *
	 * @param	errors		Map of Modem/Service Plan objects to their corresponding error message
	 * @param	record		The Modem/Service Plan record
	 * @param 	error		The error message corresponding to the Modem/Service Plan
	 * @return 				Updated map of Modem/Service plan objects to their corresponding error message
	 */
	public static Map<ModemServicePlan__c, String> addError (Map<ModemServicePlan__c, String> errors, ModemServicePlan__c record, String error)
	{
		// add error to the error map
		errors.put(record, error);
		
		// add error to the record
		record.addError(error, false);
		
		return errors;
	}
	
	
	/**
     * Verifies the start date referenced in msp has been changed in the update.
     *
     * @param   oldMsp        The msp object prior to the update.
     * @param   newM          The msp object after the update.
     * @return                Whether the start date has been updated or not.
     */	
    private static boolean isStartDateChanged(ModemServicePlan__c oldMsp, ModemServicePlan__c newMsp)
    {
    	return oldMsp.startDate__c != newMsp.startDate__c;
    }    
    
	
    /**
     * Verifies the end date referenced in msp has been changed in the update.
     *
     * @param   oldMsp        The msp object prior to the update.
     * @param   msp           The msp object after the update.
     *
     * @return                  Whether the end date has been updated or not.
     */	    
    private static boolean isEndDateChanged(ModemServicePlan__c oldMsp, ModemServicePlan__c newMsp)
    { 
    	return oldMsp.endDate__c != newMsp.endDate__c;
    } 
}