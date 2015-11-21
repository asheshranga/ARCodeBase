/**
 * This class contains helper functions to determine whether a Terminal can be successfully added or
 * updated in the database. All public methods should only be called within context of triggers for
 * terminal inserts and updates. The implementation supports bulk-safe triggers.
 */
public with sharing class SNG_TerminalValidation
{
	/**
	 * The Product Record Type for Terminal Type to validate against
	 */
	public static final transient String TERMINAL_TYPE_RECORD_TYPE_NAME = 'Terminal Types';

	/**
	 *  Validates terminal changes identified in a "before insert" trigger.
	 *  A list of terminals is passed in (i.e. Trigger.new) rather than a map simply
	 *  because the trigger does not support maps (i.e. Trigger.newMap) in insertion
	 *  case (since IDs have not yet been assigned)
	 *
	 *  @param newTerminals		new terminals from trigger
	 *  @return					map of terminals with errors
	 */
    public static Map<Terminal__c, String> validateBeforeInsert( List<Terminal__c> newTerminals)
    {
    	Map<Id, Terminal__c> oldTerminals = new Map<Id, Terminal__c>();
    	return validateBeforeUpdate(oldTerminals, newTerminals);
    }

	/**
	 *  Validates terminal changes identified in a "before update" trigger. Supports both the
	 *  update case and insert case (i.e. oldTerminals is an empty map)
	 *
	 *  @param oldTerminals		old terminals from trigger
	 *  @param newTerminals		new terminals from trigger
	 *  @return					map of terminals with errors
	 */
    public static Map<Terminal__c, String> validateBeforeUpdate(Map<Id, Terminal__c> oldTerminals, List<Terminal__c> newTerminals)
    {
    	SNG_ExceptionUtil.throwIfNullObject(oldTerminals, 'Could not validate terminals; null oldTerminals');
    	SNG_ExceptionUtil.throwIfNullObject(newTerminals, 'Could not validate terminals; null newTerminals');
		return validateTerminals(oldTerminals, newTerminals);
    }

	/**
	 * Returns a map of invalid terminals and corresponding error messages.
	 *
	 * 1) An initial traversal through the set of terminals is used to build keysets and gather data
	 * from the terminals that will be relevant to the ensuing validation. This step is necessary
	 * for a bulk-safe approach. It is an O(n) operation.
	 *
	 * 2) The terminals to be upserted must first undergo validations on some of their individual fields.
	 * Any terminals failing validation shall be filtered out before undergoing subsequent validation.
	 * This is an O(n) operation
 	 *
 	 * 3) Next, the set of remaining terminals attempting to be upserted should be checked for "duplicates."
 	 * An iteration through the set of new terminals filters out any "duplicates" within the set. Care must
 	 * be taken in this traversal to make sure not to compare a terminal to itself as a "duplicate".
 	 * The duplicates are flagged for errors, and thus are not to be upserted into the database.
 	 * This is an O(n^2) operation given that each terminal is compared to the others in the set.
 	 *
 	 * 4) The resulting filtered set is then compared against the other terminals in the database to check if
 	 * a new terminal may be "duplicating" an already existing entry; in that case the new terminal
 	 * is flagged with an error indicating the conflict, and is not upserted into the database.
 	 * This is an O(n*m) operation given that each new terminal is compared to all others in the database
 	 *
 	 * Note that the term "duplicate" is used loosely here. The validations done within this method
 	 * protect, for example, sales order and tracking number "duplicates" across accounts. That is,
 	 * it is okay for sales order and tracking number to be the same on multiple terminals sharing the
 	 * same account.
 	 *
 	 * Note that this approach is conservative in its rejection strategy. If two terminals were to swap
 	 * values for a field that is checked for uniqueness in the triggers, both could theoretically be admitted
 	 * since there would be no resulting conflict; however, this approach actually rejects them because each
 	 * "new terminal" is compared to the relevant set of terminals already in the database. As such,
	 * Accuracy has been compromised somewhat for complexity. This was chosen after finding a similar
	 * example on the developer force website:
	 * http://developer.force.com/cookbook/recipe/bulk-processing-records-in-a-trigger
	 *
	 * An example with three terminals attempting to be INSERTED follows to help illustrate the algorithm
	 * more clearly :
	 * Terminal		Account 	SalesOrder	TrackingNumber
	 * T0001 		ACCT1		SO1    		TN1
	 * T0002		ACCT2		SO2			TN1
	 * T0003		ACCT2		SO2			TN2
	 *
	 * For simplicity, assume no other terminals exist in the database. T0001 is the first processed
	 * and passes validation by default (as there are no other validated terminals to compare against).
	 * T0002 is processed next, and compared to T0001; a conflict exists because T0002 shares the same
	 * tracking number as T0001 despite being on a separate account. Therefore, T0002 is filtered out.
	 * T0003 is processed next, and compared to T0001; T0003 has no conflicts with T0001, and therefore
	 * passes validation. The resulting list of successfully validated terminals is {T0001, T0003}
	 *
	 * To illustrate how the order changes the results, now consider the same terminals were submitted
	 * in a list in reverse order:
	 * Terminal		Account 	SalesOrder	TrackingNumber
	 * T0003		ACCT2		SO2			TN2
	 * T0002		ACCT2		SO2			TN1
	 * T0001 		ACCT1		SO1    		TN1
	 *
	 * In this scenario, T0003 passes validation by default. T0002 is processed next and compared to
	 * T0003; T0002 has no conflicts with T0003, and therefore passes validation. T0001 is processed
	 * last and compared to both T0002 and T0003; a conflict exists because T0001 has the same
	 * tracking number as T0002 despite being on a separate account. Therefore T0001 is filtered out.
	 * The resulting list of successfully validated terminals is {T0002, T0003}
	 *
	 *
	 * This method has a constant number of  SOQL calls to support bulksafe triggers. Time-complexity
	 * of the method overall is O(n*m) given the nested loops when validating against other terminals
	 *
	 *  @param oldTerminals		old terminals from trigger
	 *  @param newTerminals		new terminals from trigger
	 */
    private static Map<Terminal__c, String> validateTerminals(Map<Id,Terminal__c> oldTerminals,
    		List<Terminal__c> newTerminals)
    {
    	Map<Terminal__c, String> terminalError = new Map<Terminal__c, String>();

    	/*********************************************************************************************
    	 * 1) Iterate through list of terminals to gather data relevant to validations
    	 *********************************************************************************************/
    	//IDs of terminal types corresponding to new terminals
    	Set<Id> pIDs = new Set<Id>();

    	//IDs of updated terminals (i.e. not inserted; IDs are not yet assigned in 'before insert')
    	Set<Id> tIDs = new Set<Id>();
        Set<String> trackingNumbers = new Set<String>();
        Set<String> salesOrders = new Set<String>();

    	for (Terminal__c newTerm : newTerminals)
    	{
    		pIDs.add(newTerm.TerminalType__c);
    		if (null != newTerm.Id) //may be null in the case of insert, when IDs are not yet assigned
    		{
    			tIDs.add(newTerm.Id);
    		}

    		if (null != newTerm.TrackingNumber__c)
    		{
    			// Tracking number is optional field. Only add if non-null
    			trackingNumbers.add(newTerm.TrackingNumber__c);
    		}

    		if (null != newTerm.SalesOrder__c)
    		{
    			// Sales order is optional field. Only add if non-null
    			salesOrders.add(newTerm.SalesOrder__c);
    		}
    	}

    	/*********************************************************************************************
    	 * 2) Check terminals individually before comparing to others. A subset of terminals that
    	 * pass this level of validation will be returned, and this filtered set may be used in the
    	 * subsequent check for uniqueness against other terminals.
    	 *********************************************************************************************/
    	List<Terminal__c> newTerminalsFilteredSubset =
    			validateTerminalsIndividually(oldTerminals, newTerminals, tIDs, pIDs, terminalError);

    	/***********************************************************************************************
    	 * 3) Check remaining terminals for uniqueness against one another. Terminals that did not
    	 * pass individual validation should not be included, so they do not give rise to any
    	 * uniqueness conflict that would preclude other terminals from being successfully admitted.
    	 ***********************************************************************************************/
//    	newTerminalsFilteredSubset =
//    			validateAgainstOtherNewTerminals(oldTerminals, newTerminalsFilteredSubset, terminalError);

    	/***********************************************************************************************
    	 * 4) Check remaining terminals for uniqueness against one another all other terminals
    	 * present in database
    	 ***********************************************************************************************/
/*     	newTerminalsFilteredSubset =
    			validateAgainstAllOtherTerminals(oldTerminals, newTerminalsFilteredSubset,
    					trackingNumbers, salesOrders, terminalError);
*/
        return terminalError;
    }

	/**
	 *  Validates terminal type. Makes sure that it is correct Record Type, and that it
	 *  is an active terminal type in the event that a terminal is inserted (note that
	 *  it may be possible for terminals to be updated with an invalid terminal type)
	 *
     *  @param   oldTerm        old Terminal (before the change)
     *  @param   newTerm        new Terminal (after the change)
     *  @param   terminalType	terminal type of the new terminal
     *  @param   terminalError	map of "bad terminals" to error messages
	 */
    private static boolean validateTerminalType(Terminal__c oldTerm, Terminal__c newTerm,
    		Product2 terminalType, Map<Terminal__c, String> terminalError)
    {
		if (null == terminalType)
		{
			addError(terminalError, newTerm, buildNullTerminalTypeErrorMsg(newTerm));
			return false;
		}

		return validateTerminalTypeRecordType(newTerm, terminalType, terminalError) 
				&& validateTerminalTypeProductType(newTerm, terminalType, terminalError); 
    }

    /**
     * Validates that the Terminal contains a valid Terminal Type: active, valid product family, valid business area.  
     * 
     * @param	terminal		The Terminal object to be validated
     * @param 	terminalType	The product that has been selected as the Terminal Type for the Terminal
     * @param	terminalError	Map of "bad terminals" to error messages
     * @return					True if Terminal Type is valid, false if not
     */
    private static boolean validateTerminalTypeProductType(Terminal__c terminal, Product2 terminalType, Map<Terminal__c, String> terminalError)
    {
    	if(!SNG_Product2.validateActiveProductType(terminalType)) 
    	{
    		addError(terminalError, terminal, buildInactiveTerminalTypeErrorMsg(terminal, terminalType));
    		return false;
    	}

    	return true;
    }

    /**
     *	Validates that the Terminal Type selected for the given Terminal is the valid Record Type
     * 
     * @param 	terminal		The Terminal object to be evaluated
     * @param	terminalType	The product that has been selected as the Terminal Type for the Terminal
     * @param	terminalError	Map of "bad terminals" to error messages
     * @return					True if Record Type is valid, false if not
     */
    private static boolean validateTerminalTypeRecordType(Terminal__c terminal, Product2 terminalType, Map<Terminal__c, String> terminalError)
    {
    	if (terminalType.RecordType.Name != TERMINAL_TYPE_RECORD_TYPE_NAME)
    	{
    		addError(terminalError, terminal, buildInvalidRecordTypeErrorMsg(terminal));
    		return false;
    	}

    	return true;
    }

    /**
	 * If an update to terminal's account is attempted, validate that the Terminal
	 * is not associated with a modem; otherwise the terminal would end up with a
	 * different account than its associated modem.
     *
     * @param   oldTerm        old Terminal (before the change)
     * @param   newTerm        new Terminal (after the change)
     * @param   terminalModemMap	   map of terminals to modems
     * @param   terminalError		   map of "bad terminals" to error messages
     * @return	        	Returns true if there are no issues with the Account, otherwise false
     */
    private static boolean validateTerminalAccount(Terminal__c oldTerm, Terminal__c newTerm,
    		Map<Id, Modem__c> terminalModemMap, Map<Terminal__c, String> terminalError) {
    	boolean retVal = true;

    	/*
    	 * This needs to be done only in the update trigger, and not the insert trigger,
    	 * because there is no way to associate a modem with a terminal at the moment of
    	 * terminal creation / insertion; i.e., the terminal must be created first and the
    	 * association is subsequently made through the lookup field on the modem object
    	 */
    	if (isUpdate(oldTerm, newTerm) && hasTerminalAccountChanged(oldTerm, newTerm))
    	{
    		retVal = validateTerminalIsNotAssociatedWithModem(newTerm,
    				terminalModemMap, terminalError);
    	}

    	return retVal;
    }

    /**
     * Validates that the Terminal Account is not associated with a modem.
     *
     * @param 	terminal	The terminal to check modem association on
     * @param   terminalModemMap	   map of terminals to modems
     * @param   terminalError		   map of "bad terminals" to error messages
     * @return	        	Returns true if modem is not associated with a modem; false otherwise
     */
    private static boolean validateTerminalIsNotAssociatedWithModem(Terminal__c terminal,
    		Map<Id, Modem__c> terminalModemMap, Map<Terminal__c, String> terminalError) {
    	boolean retVal = true;

		Modem__c modemAssociatedWithTerminal = terminalModemMap.get(terminal.Id);
		if (modemAssociatedWithTerminal != null )
    	{
    		retVal = false;
			addError(terminalError, terminal,
					buildModemAssociatedOnAccountChangeErrorMsg(terminal, modemAssociatedWithTerminal));
    	}

    	return retVal;
    }

	/**
	 * Builds a map of Terminal__c ID to Modem__c object: <Terminal__c.Id, Modem__c>
	 *
	 * @param modems 	list of modems to build map of associated terminals with
	 */
    private static Map<Id, Modem__c> buildTerminalModemMap(List<Modem__c> modems)
    {
    	Map<Id, Modem__c> terminalModemMap = new Map<Id,Modem__c>();

		for (Modem__c m : modems)
		{
			terminalModemMap.put(m.Terminal__c, m);
		}

		return terminalModemMap;
    }

    /**
	 * Performs any validation on new terminals that doesn't require comparison against other terminals
     *
     * @param   oldTerminals    map of old Terminals (before the change)
     * @param   newTerminals    map of new Terminals (after the change)
     * @param   tIds 			IDs of updated terminals (may be empty in insert case)
     * @param   pIds 			IDs of terminal types corresponding to new terminals
     * @param   terminalError	map of "bad terminals" to error messages
     * @return	        	Returns subset of new terminals that passed validation
     */
    private static List<Terminal__c> validateTerminalsIndividually(Map<Id, Terminal__c> oldTerminals,
    		List<Terminal__c> newTerminals, Set<Id> tIDs, Set<Id> pIDs,
    		Map<Terminal__c, String> terminalError)
    {
		/****************************************************
		 * 1. Build Lists and Maps for Bulksafe approach
		 ****************************************************/
		// Build MAP OF <Product2.ID, Product2> for validateTerminalType
	 	Map<Id,Product2> terminalTypes = new Map<Id,Product2>(
	 		[SELECT Id, Name, RecordType.Name, IsActive, Family, Business_Area__c
	 		 FROM Product2 WHERE Id IN :pIDs]);

		//Get all modems associated with new terminals. Only used in update case, not insert
	 	List<Modem__c> modems;
	 	if (tIDs.isEmpty())
	 	{
	 		// Create empty list to pass into buildTerminalModemMap()
	 		modems = new List<Modem__c>();
	 	}
	 	else
	 	{
	 		modems = [SELECT Id, Name, Terminal__c, SerialNumber__c, PartNumber__c, Account__c
		     		 FROM Modem__c WHERE Terminal__c IN :tIDs];
	 	}

	 	//Build MAP OF <Terminal__c.Id, List<Modem__c>> for validateTerminalAccount
		Map<Id, Modem__c> terminalModemMap = buildTerminalModemMap(modems);

		/**************************
		 * 2. Validate
		 **************************/
		List<Terminal__c> newTerminalsFilteredSubset = new List<Terminal__c>();
		for (Terminal__c newTerm : newTerminals)
		{
			Terminal__c oldTerm = null;

			if (newTerm.Id != null) //may be null in the case of insert, when IDs are not yet assigned
			{
				oldTerm = oldTerminals.get(newTerm.id);
			}

			if (validateTerminalType(oldTerm, newTerm, terminalTypes.get(newTerm.TerminalType__c), terminalError) &&
					validateTerminalAccount(oldTerm, newTerm, terminalModemMap, terminalError) )
			{
				newTerminalsFilteredSubset.add(newTerm);
			}
		}

		return newTerminalsFilteredSubset;
    }

    /**
	 * Checks the updated/inserted terminals for uniqueness against another set of terminals
	 *
	 * This helper method is used to check a set of terminals for uniqueness against
	 * 1) themselves or
	 * 2) all other terminals that presently exist in the database.
	 *
     * A resulting list of terminals passing validation shall be built while iterating over the set
     * of new terminals, and ultimately returned to the caller.
     *
     * In the first case where the new terminals are to be compared against themselves, this dynamic
     * resulting list shall be used as the set of terminals to be compared against. That is, only
     * once a terminal has successfully passed validation will the subsequent iterative terminals
     * be compared against it. Thus, the order of the newTerminals list will have bearing on the
     * results. Note that the first terminal in the newTerminals list will always pass validation
     * (as there are no other terminals to compare it against at the time it is processed)
     *
     * @param   oldTerminals    old Terminals (before the change)
     * @param   newTerminals    new Terminals (after the change) that have passed individual validation
     * @param   otherTerminals  other set of terminals to perform uniqueness checks against; should be
     * 							null if objective is to validate newTerminals against themselves
     * @param   terminalError	map of "bad terminals" to error messages
     * @return	        	Returns subset of new terminals that passed validation
     */
/*
    private static List<Terminal__c> validateAgainstOtherTerminals(Map<Id, Terminal__c> oldTerminals,
    		List<Terminal__c> newTerminals, List<Terminal__c> otherTerminals,
    		Map<Terminal__c, String> terminalError)
    {
    	Terminal__c oldTerm;
		List<Terminal__c> newTerminalsFilteredSubset = new List<Terminal__c>();

		for (Terminal__c newTerm : newTerminals)
		{
			if (newTerm.Id != null) //may be null in the case of insert, when IDs are not yet assigned
			{
				oldTerm = oldTerminals.get(newTerm.id);
			}

			// If validating against the other new terminals, only compare for
			if (validateAgainstOtherTerminals(oldTerm, newTerm,
					(null == otherTerminals) ? newTerminalsFilteredSubset : otherTerminals,
					terminalError))
			{
				newTerminalsFilteredSubset.add(newTerm);
			}
		}
		return newTerminalsFilteredSubset;
    }
*/

    /**
	 * Checks the updated/inserted terminals for uniqueness against other terminals being
	 * inserted/updated in bulk
     *
     * @param   oldTerminals    old Terminals (before the change)
     * @param   newTerminals    new Terminals (after the change) that have passed individual validation
     * @param   terminalError	map of "bad terminals" to error messages
     * @return	        	Returns subset of new terminals that passed validation
     */
/*
    private static List<Terminal__c> validateAgainstOtherNewTerminals(Map<Id, Terminal__c> oldTerminals,
    		List<Terminal__c> newTerminals, Map<Terminal__c, String> terminalError)
    {
		return validateAgainstOtherTerminals(oldTerminals, newTerminals, null, terminalError);
    }
*/

    /**
	 * Checks the updated/inserted terminals for uniqueness against other terminals in database
     *
     * @param   oldTerminals    old Terminals (before the change)
     * @param   newTerminals    new Terminals (after the change) that have passed individual validation
     * @param   trackingNumbers	tracking numbers of new terminals
     * @param   salesOrders 	sales orders of new terminals
     * @param   terminalError	map of "bad terminals" to error messages
     * @return	        	Returns subset of new terminals that passed validation
     */
/*
    private static List<Terminal__c> validateAgainstAllOtherTerminals(Map<Id, Terminal__c> oldTerminals,
    		List<Terminal__c> newTerminals, Set<String> trackingNumbers, Set<String> salesOrders,
    		Map<Terminal__c, String> terminalError)
	{
    	// Get all terminals relevant to uniquness checks to be performed
     	List<Terminal__c> otherTerminals =
     		[SELECT Id, Name, TrackingNumber__c, SalesOrder__c, Account__c
     		 FROM Terminal__c
     		 WHERE TrackingNumber__c IN :trackingNumbers OR SalesOrder__c IN :salesOrders];

		return validateAgainstOtherTerminals(oldTerminals, newTerminals, otherTerminals, terminalError);
    }
*/
    /**
	 * Checks the updated/inserted terminals for uniqueness against other terminals in database
     *
     * @param   oldTerm        old Terminal (before the change)
     * @param   newTerm        new Terminal (after the change)
     * @param   otherTerminals	terminals that have been queried to be relevant for comparison
     * @param   terminalError		   map of "bad terminals" to error messages
     * @return	        	Returns true if there are no issues with the Account, otherwise false
     */

/*
    private static boolean validateAgainstOtherTerminals(final Terminal__c oldTerm,
    		final Terminal__c newTerm, final List<Terminal__c> otherTerminals,
    		final Map<Terminal__c, String> terminalError)
    {
        if (hasTerminalAccountChanged(oldTerm, newTerm) || hasTerminalSalesOrderChanged(oldTerm, newTerm))
		{
        	//Combine multiple validations into this conditional so as to iterate over otherTerminals only once
			for (Terminal__c term : otherTerminals)
			{
				// Tracking number and sales order may be the same among otherTerminals under same account, but
				// cannot be the same among terminals on different accounts. Thus, make sure account is
				// distinct before attempting these validations.
				//
				// Also make sure not to compare terminal to itself.
				if (term.Account__c != newTerm.Account__c &&
						(isInsert(oldTerm, newTerm) || term.Id != newTerm.Id))
				{
                    // only need to check if one of them is not-empty. Tracking numbers can only be considered a duplicate
                    // if they contain a value.
    				if (!StringUtils.isEmpty(term.TrackingNumber__c) && term.TrackingNumber__c == newTerm.TrackingNumber__c)
    				{
    					addError(terminalError, newTerm, buildTrackingNumberNotUniqueErrorMsg(newTerm, term));
    					return false;
    				}

                    // only need to check if one of them is not-empty. SalesOrder can be considered a duplicate 
                    // across accounts if they contain a value.
    				if (!StringUtils.isEmpty(term.SalesOrder__c) && term.SalesOrder__c == newTerm.SalesOrder__c)
    				{
    					addError(terminalError, newTerm, buildSalesOrderNotUniqueErrorMsg(newTerm, term));
    					return false;
    				}
				}
			}
		}
        return true;
    }
*/


    /**
     * Checks whether the terminal type has changed. The insert case is considered a change
     * since previous value was null
   	 *
     * @param   oldTerm        old Terminal (before the change)
     * @param   newTerm        new Terminal (after the change)
     */
    private static boolean hasTerminalTypeChanged(Terminal__c oldTerm, Terminal__c newTerm)
    {
    	return (isInsert(oldTerm, newTerm) || oldTerm.TerminalType__c != newTerm.TerminalType__c);
    }

    /**
     * Checks whether the terminal tracking number has changed. The insert case is considered
     * a change since previous value was null
   	 *
     * @param   oldTerm        old Terminal (before the change)
     * @param   newTerm        new Terminal (after the change)
     */
    private static boolean hasTerminalTrackingNumberChanged(Terminal__c oldTerm, Terminal__c newTerm)
    {
    	return (isInsert(oldTerm, newTerm) || oldTerm.TrackingNumber__c != newTerm.TrackingNumber__c);
    }

    /**
     * Checks whether the sales order number has changed. The insert case is considered
     * a change since previous value was null
   	 *
     * @param   oldTerm        old Terminal (before the change)
     * @param   newTerm        new Terminal (after the change)
     */
    private static boolean hasTerminalSalesOrderChanged(Terminal__c oldTerm, Terminal__c newTerm)
    {
    	return (isInsert(oldTerm, newTerm) || oldTerm.SalesOrder__c != newTerm.SalesOrder__c);
    }

    /**
     * Checks whether the terminal account has changed. The insert case is considered
     * a change since previous value was null
   	 *
     * @param   oldTerm        old Terminal (before the change)
     * @param   newTerm        new Terminal (after the change)
     */
    private static boolean  hasTerminalAccountChanged(Terminal__c oldTerm, Terminal__c newTerm)
    {
    	return (isInsert(oldTerm, newTerm) || oldTerm.Account__c != newTerm.Account__c);
    }

    /**
     * Checks whether the processing is being done within insert trigger
     *
     * System.trigger.isInsert was considered as opposed to creating this method,
     * but unfortunately it cannot be called from Apex classes (System.trigger.isInsert
     * results in attempt to de-reference null object). Nevertheless, this
     * method as implemented allows for checking whether an individual terminal
     * is being inserted; this may be beneficial in bulk inserts, and when comparing to
     * terminals previously in the database
   	 *
     * @param   oldTerm        old Terminal (before the change)
     * @param   newTerm        new Terminal (after the change)
     */
    private static boolean isInsert(Terminal__c oldTerm, Terminal__c newTerm)
    {
    	return (null == oldTerm && null != newTerm);
    }

    /**
     * Checks whether the processing is being done within update trigger
     *
     * System.trigger.isUpdate was considered as opposed to creating this method,
     * but unfortunately it cannot be called from Apex classes (System.trigger.isUpdate
     * results in attempt to de-reference null object). Nevertheless, this
     * method as implemented allows for checking whether an individual terminal
     * is being updated; this may be beneficial in bulk updates, and when comparing to
     * terminals previously in the database
     *
     * @param   oldTerm        old Terminal (before the change)
     * @param   newTerm        new Terminal (after the change)
     */
    private static boolean isUpdate(Terminal__c oldTerm, Terminal__c newTerm)
    {
    	return (null != oldTerm && null != newTerm);
    }


	/**
     * Adds an error to both the errors Map<Terminal__c, errorString> as well as to the record itself
     *
     * @param     errors  Map<Terminal__c, errorString> to add the error to
     * @param     record record to add the error on
     * @param     error   The error message to add
     * @return            Map<Terminal__c, errorString> with the error added
     */
    private static Map<Terminal__c, String> addError(final Map<Terminal__c, String> errors,
    		final Terminal__c record, final String error) {
       // add to map
       errors.put(record, error);

       // add to record
       record.addError(error, false);

       return errors;
    }

    /**
     * Build error message for case where terminal type is null
     *
     * @param term 		terminal in error
     * @return error message
     */
	private static String buildNullTerminalTypeErrorMsg(Terminal__c term)
	{
		final String NULL_TERMINAL_TYPE = 'Terminal {0} cannot have missing terminal type';
		return String.format(NULL_TERMINAL_TYPE, new String[]{getTerminalIdentifier(term)});
	}

    /**
     * Build error message for case where terminal type is inactive
     *
     * @param term 			terminal in error
     * @param terminalType 	the inactive terminal type
     * @return error message
     */
	private static String buildInactiveTerminalTypeErrorMsg(Terminal__c term, Product2 terminalType)
	{
		// Retrieve allowable business areas from custom label
		String businessAreasStr = Label.SNGBusinessArea;

		// Set businessAreaStr to format: label1/label2/label3, remove white spaces and commas
		businessAreasStr = businessAreasStr.replace(' ', '').replace(',', '/');

        final String INVALID_TERMINAL_TYPE = 'Terminal Type ' + terminalType.Name + ' must be equal to Business Area(' + businessAreasStr + '), Family(Exede), and active.';

        return INVALID_TERMINAL_TYPE;
	}

    /**
     * Build error message for case where tracking number is not unique among terminals on different
     * accounts
     *
     * @param term 			terminal in error
     * @param offendingTerm terminal on different account with same tracking number
     * @return error message
     */
/*
	private static String buildTrackingNumberNotUniqueErrorMsg(Terminal__c term, Terminal__c offendingTerm)
	{
		final String TRACKING_NUMBER_NOT_UNIQUE =
				'Tracking numbers must be unique across different accounts.' +
				'Terminal {0} uses the same tracking number as Terminal {1}';
		return String.format(TRACKING_NUMBER_NOT_UNIQUE,
				new String[]{getTerminalIdentifier(term), getTerminalIdentifier(offendingTerm)});
	}
*/

    /**
     * Build error message for case where sales order number is not unique among terminals on different
     * accounts
     *
     * @param term 			terminal in error
     * @param offendingTerm terminal on different account with same sales order number
     * @return error message
     */
/*
	private static String buildSalesOrderNotUniqueErrorMsg(Terminal__c term, Terminal__c offendingTerm)
	{
		final String SALES_ORDER_NOT_UNIQUE =
				'Sales order numbers must be unique across different accounts.' +
				'Terminal {0} uses the same sales order number as Terminal {1}';
		return String.format(SALES_ORDER_NOT_UNIQUE,
				new String[]{getTerminalIdentifier(term), getTerminalIdentifier(offendingTerm)});
	}
*/

    /**
     * Build error message for case where record type of a terminal type is invalid
     *
     * @param term 			terminal in error
     * @return error message
     */
	private static String buildInvalidRecordTypeErrorMsg(Terminal__c term)
	{
		final String INVALID_RECORD_TYPE =
				'Terminal {0} cannot have a terminal type with record type other than ' +
				TERMINAL_TYPE_RECORD_TYPE_NAME;
		return String.format(INVALID_RECORD_TYPE, new String[]{getTerminalIdentifier(term)});
	}

    /**
     * Build error message for case where account is attempting to be changed while modem
     * is associated to terminal
     *
     * @param term 							terminal in error
     * @param modemAssociatedWithTerminal 	modem linked to terminal
     * @return error message
     */
	private static String buildModemAssociatedOnAccountChangeErrorMsg(Terminal__c term,
			Modem__c modemAssociatedWithTerminal)
	{
		final String MODEM_ASSOCIATED_ON_ACCOUNT_CHANGE =
				'The account for Terminal {0} can only be changed if there are no modems '
	            + 'linked to it. Please remove the link with modem {1} and try again.';
		return String.format(MODEM_ASSOCIATED_ON_ACCOUNT_CHANGE, new String[]{getTerminalIdentifier(term),
				SNG_HtmlUtilities.getHtmlSalesforceRecordLinkString(modemAssociatedWithTerminal)});

	}

	/**
	 * Gets hyperlink to terminal if it already exists in database. If it does not
	 * (i.e. terminal has yet to be inserted) then the serial number is returned
	 * instead (neither ID nor name exist for a terminal until inserted)
	 *
	 * @param term 	terminal for which identifier is to be retrieved
	 * @return hyperlink to terminal if it exists; serial number otherwise
	 */
	private static String getTerminalIdentifier(Terminal__c term)
	{
		String termId;

		if (null == term.Id)
		{
			termId = 'Serial Number ' + term.SerialNumber__c;
		}
		else
		{
			termId = SNG_HtmlUtilities.getHtmlSalesforceRecordLinkString(term);
		}

		return termId;
	}
}