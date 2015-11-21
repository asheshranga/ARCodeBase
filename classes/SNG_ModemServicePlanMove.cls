/**
 * This class contains methods to identify, validate, and process moved Modem/Service Plans. 
 * A moved Modem/Service Plan is a Modem/Service Plan that is being inserted that fulfills the 
 * following conditions: 
 * 
 * 1) The to-be-inserted MSP will be an active MSP; start date <= Today and end date >= Today
 * 2) To-be-inserted MSP's start date must occur within another MSP's date period (The MSP must have
 * 		the same modem as the to-be-inserted MSP)
 * 3) To-be-inserted MSP must have a different Service Plan than the MSP that it overlaps with
 * 		(condition 2)
 */
public with sharing class SNG_ModemServicePlanMove {
	
	/**
	 * Determine if an MSP is a moved MSP
	 *
	 * @param	mspToEval	The MSP to evaluate
	 * @param	mspsToEval	List of Modem/Service Plans to be evaluated	 
	 * @param	allMsps		Map of all MSPs associated to its Modem's ID
	 * @return				True if MSP is a moved MSP, false if not
	 */ 
	public static boolean isMovedMsp(ModemServicePlan__c mspToEval, Map<Id, List<ModemServicePlan__c>> allMsps, 
										Map<Id, ServicePlan__c> servicePlanMap) 
	{
		boolean isAutoCompleted = false;
		boolean isMoved = false; 

		// Verify that mspToEval's start date is on or before today and it overlaps with an existing MSP that was/is active
		if ((mspToEval.StartDate__c <= SNG_DateUtils.todayGmt()) && isOverlappingMspWithDiffServicePlan(mspToEval, allMsps))
		{
			// Auto-complete MSP end-date if not filled in 
			if (mspToEval.EndDate__c == null) {
				autoCompleteMovedMspEndDate(mspToEval, servicePlanMap);
				isAutoCompleted = true;
			}	

			// End-date does not occur on today or after today = not Moved MSP
			if (mspToEval.EndDate__c < SNG_DateUtils.todayGmt()) 
			{
				// If end-date was auto-completed, reset it back to null
				if(isAutoCompleted) {
					mspToEval.EndDate__c = null;
				}
			}
			// End Date fulfills condition
			else 
			{
				isMoved = true;
			}
		}

		return isMoved;
	}


	/**
	 * Validates Moved MSPs fulfill the following conditions: 
	 * 1) There are no MSPs whose start date is between the Moved MSPs start date and today
	 * 2) Moved MSP does not overlap with any future MSPs that have the same accounts
	 *
	 * @param	mspToEval			MSP to validate
	 * @param	allMsps				Map of all MSPs in Salesforce database
	 * @param	modemMap			Map of all modems from Salesforce database
	 * @param	servicePlanMap		Map of all service plans from Salesforce database
	 * @param	errors				Map of "bad Modem/Service Plans" to error messages
	 * @return						True if MSP is valid, false otherwise
	 */
	public static boolean validateMovedMsp(ModemServicePlan__c mspToEval, Map<Id, List<ModemServicePlan__c>> allMsps,
											Map<Id, Modem__c> modemMap, Map<Id, ServicePlan__c> servicePlanMap,
											Map<ModemServicePlan__c, String> errors)
	{
		return doesNotContainPastOrActiveMsp(mspToEval, allMsps, errors) 
				&& doesNotOverlapFutureMspsWithSameAccount(mspToEval, allMsps, modemMap, servicePlanMap, errors);
	}


	/**
	 * Shifts the past or active MSP that overlaps with a Moved MSP's start-date to Moved MSP.StartDate - 1
	 *
	 * Precondition: An overlapping MSP has been found that conflicts with the to-be-inserted moved Modem/Service Plan 
	 * @param	movedMsp		The moved MSP
	 * @param 	allMsps			Map of all MSPs in Salesforce database
	 * @param	mspsToUpdate	List of Modem/Service Plans that will need to be updated
	 */
	public static void shiftOverlappingMsp(ModemServicePlan__c movedMsp, Map<Id, List<ModemServicePlan__c>> allMsps,
											List<ModemServicePlan__c> mspsToUpdate) 
	{	
		// Retrieve the overlapping MSP that was found earlier
		ModemServicePlan__c overlappingMsp = findMspOverlappingWithMovedStartDate(movedMsp, allMsps);
		
		// Overlapping MSP is null, an unknown error occurred, should not have reached this part of the code
		// if overlappingMsp is null
		final String ERROR_MESSAGE = 'Cannot find overlapping MSP, there should be an overlapping MSP; unexpected error.';
		SNG_ExceptionUtil.throwIfNullObject(overlappingMsp, ERROR_MESSAGE);

		// shift the overlapping MSP so that its end-date is (movedMsp.StartDate__c - 1)
		overlappingMsp.EndDate__c = movedMsp.StartDate__c.addDays(-1);

		// Determine if overlappingMsp is already existing MSP, or an MSP to-be-inserted (nothing needs to be done to it, fall through)
		// MSP is existing, needs to be updated
		if (overlappingMsp.Id != null) {
			
			// Add overlappingMsp to MSP update list
			mspsToUpdate.add(overlappingMsp);
		}
	}

	/**
	 * Deletes all future active Modem/Service Plans that have the same modem as the moved MSP
	 * 
	 * @param 	movedMsp			The moved MSP
	 * @param 	allMsps				Map of all MSPs in Salesforce database
	 * @param	modemMap			Map of all modems from Salesforce database
	 * @param	servicePlanMap		Map of all service plans from Salesforce database
	 * @param	mspsToDelete		List of MSPs that need to be deleted
	 * @param	errors				Map of "bad Modem/Service Plans" to error messages
	 */
	public static void deleteFutureMspsWithDiffAccount(ModemServicePlan__c movedMsp, Map<Id, List<ModemServicePlan__c>> allMsps,
														Map<Id, Modem__c> modemMap, Map<Id, ServicePlan__c> servicePlanMap, 
														List<ModemServicePlan__c> mspsToDelete, Map<ModemServicePlan__c, String> errors)
	{
		// The Modem object of movedMsp
		Modem__c movedMspModem = modemMap.get(movedMsp.Modem__c);

		// Retrieve all MSPs that have the same modem
		List<ModemServicePlan__c> mspsWithSameModem = allMsps.get(movedMsp.Modem__c);
		
		if (mspsWithSameModem == null) {
			mspsWithSameModem = new List<ModemServicePlan__c>();
		}

		// Updated list of Modem/Service Plans of the same modem
		List<ModemServicePlan__c> newMspsWithSameModem = new List<ModemServicePlan__c>();

		for (ModemServicePlan__c msp : mspsWithSameModem)
		{
			// Retrieve service plan of the future msp
			ServicePlan__c futureMspServicePlan = servicePlanMap.get(msp.ServicePlan__c);

			// if msp is future msp and its account is different than movedMsp
			if (msp.StartDate__c > SNG_DateUtils.todayGmt() && (futureMspServicePlan.Account__c != movedMspModem.Account__c)) 
			{
				// If the future MSP is a to-be-inserted MSP, do not let it be inserted, error it out
				if (msp.Id == null)
				{
					final String ERROR_MESSAGE = 'The Modem/Service Plan with Modem: ' + msp.Modem__r.Name +
					 								' cannot be inserted, as the modem is being moved to a ' +
					 								'different account.';
					SNG_ModemServicePlanValidation.addError(errors, msp, ERROR_MESSAGE);
				}
				// Future MSP is an existing MSP, mark it for delete
				else {
					mspsToDelete.add(msp);
				}
			}
			else {
				newMspsWithSameModem.add(msp);
			}
		}
		
		// Add updated list of MSPs with same modem to running list
		allMsps.put(movedMsp.Modem__c, newMspsWithSameModem);
	}

	/**
	 * If the MSP's Modem and Terminal accounts differ from the MSP's Service Plan account, change the modem's and terminal's account 
	 * to the Service Plan's account. 
	 *
	 * @param	msp					The MSP to be processed
	 * @param	modemMap			Map of all modems from Salesforce database
	 * @param	servicePlanMap		Map of all service plans from Salesforce database
	 * @param 	terminalMap			Map of all terminals from Salesforce database
	 * @param	modemsToUpdate		List containing modems that need to be updated
	 * @param	terminalsToUpdate	List containing terminals that need to be updated
	 */
	public static void processAccountChange(ModemServicePlan__c msp, Map<Id, Modem__c> modemMap, Map<Id, ServicePlan__c> servicePlanMap,
											Map<Id, Terminal__c> terminalMap, List<Modem__c> modemsToUpdate, List<Terminal__c> terminalsToUpdate) 
	{
		Modem__c modem = modemMap.get(msp.Modem__c); 
		ServicePlan__c servicePlan = servicePlanMap.get(msp.ServicePlan__c); 

		// Accounts between Modem and Service Plan do not match, modify Modem's and Terminal's account and add to respective update lists
		if (modem.Account__c != servicePlan.Account__c)
		{
			modem.Account__c = servicePlan.Account__c; 

			// Add modified modem back into the modemMap and to List of Modems to update
			modemMap.put(msp.Modem__c, modem);
			modemsToUpdate.add(modem);

			// If modem has an associated Terminal, modify its account and add to update list
			if(modem.Terminal__c != null)
			{
				Terminal__c terminal = terminalMap.get(modem.Terminal__c); 
				terminal.Account__c = servicePlan.Account__c;

				// Add modified Terminal back into terminalMap and to List of Terminals to update
				terminalMap.put(modem.Terminal__c, terminal);
				terminalsToUpdate.add(terminal);
			}
		}
	}

	/**
	 * Set Moved MSP's end-date to its service plan's end-date
	 * 
	 * @param	msp 			The MSP to set the end-date for
	 * @param	servicePlans	List of Service Plan Objects mapped by Service Plan ID	
	 */
	private static void autoCompleteMovedMspEndDate(ModemServicePlan__c msp, Map<Id, ServicePlan__c> servicePlans)
	{
		// Auto-complete moved MSP's end-date if no end-date has been set
		if (msp.EndDate__c == null)
		{
			ServicePlan__c servicePlan = servicePlans.get(msp.ServicePlan__c); 
			msp.EndDate__c = servicePlan.EndDate__c;
		}
		
	}

	/**
	 * Determine if MSP's start date falls within the active period of an existing MSP of the same modem 
	 * but different servcie plan. 
	 *
	 * @param	mspToEval	The MSP to evaluate
	 * @param	allMsps		Map of all MSPs associated to its Modem's ID
	 * @return				True if mspToEval's start-date occurs during an existing MSP's active period
	 */
	private static boolean isOverlappingMspWithDiffServicePlan(ModemServicePlan__c mspToEval, Map<Id, List<ModemServicePlan__c>> allMsps) { 

		ModemServicePlan__c overlapMsp = findMspOverlappingWithMovedStartDate(mspToEval, allMsps); 

		// There exists an overlapping MSP
		if (overlapMsp != null)
		{
			// overlapping MSP must be under different service plan
			if (mspToEval.ServicePlan__c != overlapMsp.ServicePlan__c) { 
				return true;
			}
		}

		return false;
	}

	/**
	 * Finds a corresponding Modem / Service Plan with a matching Modem that overlaps, 
	 * but does not encompass the start date of the moved Modem / Service Plan.
	 * 
	 * @param	mspToEval	Moved Modem/Service Plan to evaluate
	 * @param	allMsps		Map of all MSPs associated to its Modem's ID
	 * @return				The Modem/Service Plan that mspToEval overlaps with. 
	 */
	private static ModemServicePlan__c findMspOverlappingWithMovedStartDate(ModemServicePlan__c mspToEval, 
																			Map<Id,	List<ModemServicePlan__c>> allMsps) 
	{
		// Retrieve list of existing MSPs that have same modem as mspToEval
		List<ModemServicePlan__c> existingMspsWithSameModem = allMsps.get(mspToEval.Modem__c);

		// If mspToEval's modem does not have any existing MSPs (i.e. first time modem associated to MSP), return null
		if (existingMspsWithSameModem != null) {
			for (ModemServicePlan__c msp : existingMspsWithSameModem) 
			{	
				// MSP is not considered overlapping if its start date is the same as the moved MSP. If this
				// occurs, the moved MSP contains the MSP, and violates what a moved MSP is. 
				// MSP can be considered overlapping if its end date is on the same day as the moved MSP's
				// start date, since the moved MSP will overlap with part of the MSP active period. 
				if (mspToEval.StartDate__c > msp.StartDate__c && mspToEval.StartDate__c <= msp.EndDate__c)
				{
					return msp;
				}
			}
		}

		return null;
	}

	/**
	 * Verify that a Moved MSP's will not overlap with any future MSPs that will have the same account. A situation like this
	 * will occur if the Modem for the Moved MSP will NOT be undergoing an account change (i.e. the Modem and the Service Plan have 
	 * different accounts, then the Modem/Terminal will change its account to match the Service Plan's). 
	 * 
	 * If an MSP's modem is going through an account change, all future MSPs will be removed, so there will be no overlap of the Moved MSP 
	 * with any future MSP. 
	 *
	 * @param 	mspToEval		Moved Modem/Service Plan to evaluate
	 * @param	allMsps			Map of all MSPs associated to its Modem's ID
	 * @param	modemMap		Map of all modems from Salesforce database
	 * @param 	servicePlanMap	Map of all service plans from Salesforce database
	 * @param	errors			Map of "bad Modem/Service Plans" to error messages
	 * @return					True if mspToEval does not overlap, false otherwise
	 */
	private static boolean doesNotOverlapFutureMspsWithSameAccount(ModemServicePlan__c mspToEval, Map<Id, List<ModemServicePlan__c>> allMsps,
																	Map<Id, Modem__c> modemMap, Map<Id, ServicePlan__c> servicePlanMap,
																	Map<ModemServicePlan__c, String> errors)
	{
		// Retrieve Modem and Service Plan Object associated to the MSP
		Modem__c modem = modemMap.get(mspToEval.Modem__c); 
		ServicePlan__c servicePlan = servicePlanMap.get(mspToEval.ServicePlan__c); 

		// Retrieve list of existing MSPs that have the same modem as mspToEval
		List<ModemServicePlan__c> existingMspsWithSameModem = allMsps.get(mspToEval.Modem__c); 

		if (existingMspsWithSameModem == null)
		{
			existingMspsWithSameModem = new List<ModemServicePlan__c>();
		}

		// If the accounts are the same, verify that the Moved MSP will not overlap with any future MSPs
		if (modem.Account__c == servicePlan.Account__c)
		{
			for (ModemServicePlan__c msp : existingMspsWithSameModem)
			{
				// Future MSP 
				if (msp.StartDate__c > SNG_DateUtils.todayGmt())
				{
					// mspToEval overlaps with a future MSP, Invalidate mspToEval
					if (!(mspToEval.EndDate__c < msp.StartDate__c)) 
					{
						final String ERROR_MESSAGE = 'Modem/Service Plan cannot be created because it conflicts with ' 
														+ SNG_HtmlUtilities.getHtmlSalesforceRecordLinkString(msp);
						SNG_ModemServicePlanValidation.addError(errors, mspToEval, ERROR_MESSAGE);
						return false;
					}
				}
			}
		}

		return true;
	}

	/**
	 * Verifies that a Moved MSP does not contain a past MSP or a currently active MSP. If it does, invalidate the "Moved" MSP
	 * The Moved MSP cannot overlap with any MSP's whose start date occurs on or after the Moved MSP's start date and 
	 * occurs on or before today. 
	 *
	 * @param 	mspToEval	The moved Modem/Service Plan to evaluate
	 * @param	allMsps		Map of all MSPs associated to its Modem's ID
	 * @param	errors		Map of "bad Modem/Service Plans" to error messages
	 * @return				True if mspToEval does not contain past/current active MSP, false otherwise
	 */
	private static boolean doesNotContainPastOrActiveMsp(ModemServicePlan__c mspToEval, Map<Id, List<ModemServicePlan__c>> allMsps,
															Map<ModemServicePlan__c, String> errors) 
	{
		// retrieve list of existing MSPs that have the same modem as mspToEval
		List<ModemServicePlan__c> existingMspsWithSameModem = allMsps.get(mspToEval.Modem__c);

		// If mspToEval's modem does not have any existing MSPs (i.e. first time modem associated to MSP), return true
		if (existingMspsWithSameModem == null) {
			return true;
		}

		for (ModemServicePlan__c msp : existingMspsWithSameModem)
		{
			// If an MSP's start date occurs in between the mspToEval's start-date and today, mspToEval contains an
			// existing past or active MSP, invalidate the MSP, add error and return false.
			if (msp.StartDate__c >= mspToEval.StartDate__c && msp.StartDate__c <= SNG_DateUtils.todayGmt())
			{

				final String ERROR_MESSAGE = (msp.Id != null) ? 'Modem/Service Plan cannot be created because it conflicts with '
																	+ SNG_HtmlUtilities.getHtmlSalesforceRecordLinkString(msp)
																: 'Modem/Service Plan cannot be created because it conflicts with '
																	+ 'another MSP being inserted.'; 

				SNG_ModemServicePlanValidation.addError(errors, mspToEval, ERROR_MESSAGE);
				return false; 
			}
		}

		return true;
	}
}