/**
 * This class contains helper functions to determine whether a Terminal can be successfully added or
 * updated in the database.
 */
public with sharing class SNG_Terminal
{
	/**
	 * List containing all fields in the Terminal__c object which the data is modem dependent and
     * should be reset upon any modem/terminal association/dissociation.
	 */
	private static final transient List<Schema.sObjectField> MODEM_DEPENDENT_FIELDS = new List<Schema.sObjectField>();

	/**
	 * Initialize MODEM_DEPENDENT_FIELDS
	 */
	static {
		MODEM_DEPENDENT_FIELDS.add(Terminal__c.DownloadSinrBackEnd__c);
		MODEM_DEPENDENT_FIELDS.add(Terminal__c.GbDownloaded__c);
		MODEM_DEPENDENT_FIELDS.add(Terminal__c.GbTotal__c);
		MODEM_DEPENDENT_FIELDS.add(Terminal__c.GbUploaded__c);
		MODEM_DEPENDENT_FIELDS.add(Terminal__c.IpAddress__c);
        MODEM_DEPENDENT_FIELDS.add(Terminal__c.MacAddress__c);
		MODEM_DEPENDENT_FIELDS.add(Terminal__c.OnlineTime__c);
		MODEM_DEPENDENT_FIELDS.add(Terminal__c.PeersAvgUploadSymbolRateBackEnd__c);
		MODEM_DEPENDENT_FIELDS.add(Terminal__c.PeersOnlineBackEnd__c);
		MODEM_DEPENDENT_FIELDS.add(Terminal__c.StatusBackEnd__c);
		MODEM_DEPENDENT_FIELDS.add(Terminal__c.UploadSymbolRateBackEnd__c);
	}

	/**
	 * The Product Record Type for Terminal Type to validate against
	 */
	//TODO: Doesn't it make more sense to move all record types to another class ?
	public static final transient String TERMINAL_TYPE_RECORD_TYPE_NAME = 'Terminal Types';

    /**
     * Looks up the modem with the given terminal associated and returns its MAC address
     *
     * @param 	terminal	The terminal to return the MAC address for
     * @return	        	The MAC address for the modem which has the given terminal
     *        	        	associated. If no modem associated, null.
     */
    public static String getModemMacAddressForTerminal(Terminal__c terminal) {
    	String macAddress = null;

    	SNG_ExceptionUtil.throwIfNullObject(terminal, 'Cannot get Modem MAC address for an invalid terminal');
        if (doesModemExistForTerminal(terminal))
        {
            macAddress = [SELECT Name FROM Modem__c WHERE Terminal__c = :terminal.Id].Name;
        }
        else
        {
            System.debug(LoggingLevel.ERROR, 'No modem found for terminal ' + terminal.Name);
        }

        return macAddress;
    }


    /**
     * Looks up the modem with the given terminal associated and returns its MAC address
     *
     * @param   terminal    The terminal to return the MAC address for
     * @return              The MAC address for the modem which has the given terminal
     *                      associated. If no modem associated, null.
     */
    public static String getModemIdForTerminal(Terminal__c terminal) {
        String modemId = null;

        SNG_ExceptionUtil.throwIfNullObject(terminal, 'Cannot get modem ID for a null terminal.');
        if (doesModemExistForTerminal(terminal))
        {
            modemId = [SELECT Id FROM Modem__c WHERE Terminal__c = :terminal.Id].Id;
        }
        else
        {
            String errorMsg = 'No modem found for terminal ' + terminal.Name;
            System.debug(LoggingLevel.ERROR, errorMsg);
            //throw new SNG_Exception(errorMsg); -- TODO: Discuss appropriate detail for this case.
        }

        return modemId;
    }

    /** get
     * Looks up the modems for the given terminals associated and returns a map from the Terminal Id to Modem Object
     *
     * @param	terminals	The terminals to return modems for
     * @return				The map from the Terminal Id to Modems.
     *						If any Terminal has no modem associated, the value is null.
     */
    public static Map<Id, Modem__c> getModemsForTerminals(List<Terminal__c> terminals)
    {
    	Map<Id, Modem__c> terminalsIdToModems = new Map<Id, Modem__c>();

    	// initialize map with all terminals having null value
    	for(Terminal__c terminal : terminals) {
            SNG_ExceptionUtil.throwIfNullObject(terminal, 'Terminal in the list to get modem IDs is null');
    		terminalsIdToModems.put(terminal.Id, null);
    	}

        String query = 'SELECT Terminal__c, Name, Id FROM Modem__c WHERE ';
        for (integer i = 0; i < terminals.size(); i++) {
            query += 'Terminal__c = \'' + terminals.get(i).Id + '\'';

            //If not the last element
            if (i < terminals.size() -1) {
                query += 'OR ';
            }
        }

        // update the map with the Modems for each Terminal
        List<Modem__c> modems = Database.query(query);
        for (Modem__c modem : modems) {
            terminalsIdToModems.put(modem.Terminal__c, modem);
        }

    	return terminalsIdToModems;
    }


    /**
     * Looks up the modems for the given terminals associated and returns a map from the Terminal Id to MAC Address
     *
     * @param 	terminals	The terminals to return the MAC addresses for
     * @return	        	The map from the Terminal Id to MAC Address for the modem which has that terminal associated.
     *        	        	If any Terminal has no modem associated, the value is null.
     */
    public static Map<Id, String> getModemMacAddressForTerminals(List<Terminal__c> terminals) {
    	// init map with all terminals having null mac addresses
    	// NOTE: Is that really needed? Commented out insertion of null data for now...
    	Map<Id, String> macAddresses = new Map<Id, String>();
    	for (Terminal__c terminal : terminals) {
            SNG_ExceptionUtil.throwIfNullObject(terminal, 'Terminal in the list to get modem MAC Address is null');
    		//macAddresses.put(terminal.Id, null);
    	}

    	Id[] terminalIds = new Id[terminals.size()];
    	for (Integer i = 0; i < terminals.size(); ++i) {
    		terminalIds[i] = terminals[i].Id;
    	}

   		Modem__c[] modems = [SELECT Terminal__c, Name FROM Modem__c WHERE Terminal__c IN :terminalIds];

   		// update the map with the MAC addresses for each Terminal
        for (Modem__c modem : modems) {
            macAddresses.put(modem.Terminal__c, modem.Name);
        }

    	return macAddresses;
    }
 
    /**
     * Looks up the Modem / Service Plan(s) for the given terminals associated and returns a map from the Terminal Id to 
     * Modem / Service Plan(s).
     *
     * @param   terminals   The terminals to return the MAC addresses for
     * @return              The map from the Terminal Id to Modem / Service Plan(s).
     *                      If a Terminal has no Modem / Service Plan associated, it is not added to the list.
     *                      Returns an empty list if there are no valid mappings.
     */
    public static Map<Id, List<ModemServicePlan__c>> getMspsForTerminals(List<Terminal__c> terminals, Date startDate, Date endDate) {
        
        List<ModemServicePlan__c> msps = [SELECT Terminal__c, Modem__r.Name, StartDate__c, EndDate__c FROM ModemServicePlan__c];
        
        // init map with all terminals having null mac addresses
        // NOTE: Is that really needed? Commented out insertion of null data for now...
        Map<Id, List<ModemServicePlan__c>> modemServicePlans = new Map<Id, List<ModemServicePlan__c>>();
        for (Terminal__c terminal : terminals) {
            SNG_ExceptionUtil.throwIfNullObject(terminal, 'Terminal in the list to get modem MAC Address is null');
        }

        Map<String, Id> terminalNameToId = new Map<String, Id>();
        String[] terminalNames = new String[terminals.size()];
        for (Integer i = 0; i < terminals.size(); ++i) {
            terminalNames[i] = terminals[i].Name;
            terminalNameToId.put(terminals[i].Name, terminals[i].Id);
        }

        ModemServicePlan__c[] mspsResults = [SELECT Terminal__c, Modem__r.Name, StartDate__c, EndDate__c FROM ModemServicePlan__c 
                                             WHERE Terminal__c IN :terminalNames 
                                             AND StartDate__c <= :endDate 
                                             AND EndDate__c >= :startDate];

        // update the map with the MAC addresses for each Terminal
        for (ModemServicePlan__c msp : mspsResults) 
        {
        	if (terminalNameToId.containsKey(msp.Terminal__c))
        	{
        		Id terminalId = terminalNameToId.get(msp.Terminal__c);
        		
        		if (modemServicePlans.containsKey(terminalId))
        		{
        			modemServicePlans.get(terminalId).add(msp);
        		}
        		else
        		{
        			modemServicePlans.put(terminalId, new List<ModemServicePlan__c>{ msp });
        		}
        	}
        }

        return modemServicePlans;
    }

    /**
     * Looks up the active MSP with the given terminal associated
     *
     * @param 	terminal	The terminal to return the active MSP for
     * @return	        	The active MSP for the modem which has the given terminal
     *        	        	associated. If either no modem associated or no
     *                      active MSP for the associated modem, null is returned.
     */
    public static ModemServicePlan__c getActiveMspForTerminal(Terminal__c terminal) {
    	ModemServicePlan__c msp = null;

        SNG_ExceptionUtil.throwIfNullObject(terminal, 'Cannot retrieve active MSP for a null terminal.');
        if (doesModemExistForTerminal(terminal))
        {
 			Modem__c modem = [SELECT Id, Name FROM Modem__c WHERE Terminal__c = :terminal.Id];
    		msp = SNG_Modem.getActiveMspForModem(modem);
        }
        else
        {
            System.debug('No modem found for terminal ' + terminal.Name);
        }

        return msp;
    }
    
    /**
     * Looks up the active MSP with the given terminal associated within the specified date range
     *
     * @param   terminal    The terminal to return the active MSP for
     * @return              The active MSP for the modem which has the given terminal
     *                      associated. If either no modem associated or no
     *                      active MSP for the associated modem, null is returned.
     */
    public static List<ModemServicePlan__c> getMspForTerminal(Terminal__c terminal, Date startDate, Date endDate) {
        List<ModemServicePlan__c> msps = null;

        SNG_ExceptionUtil.throwIfNullObject(terminal, 'Cannot retrieve active MSP for a null terminal.');
        if (doesModemExistForTerminal(terminal))
        {
            Modem__c modem = [SELECT Id, Name FROM Modem__c WHERE Terminal__c = :terminal.Id];
            msps = SNG_Modem.getMspsForModem(modem, startDate, endDate);
        }
        else
        {
            System.debug('No modem found for terminal ' + terminal.Name);
        }

        return msps;
    }

    public static void resetModemDependentDataWithoutUpdate(final Terminal__c[] terminals) {
        for (Terminal__c terminal : terminals) {
            // set all modem dependent fields to their default values
            for (Schema.sObjectField field : MODEM_DEPENDENT_FIELDS) {
                terminal.put(field, field.getDescribe().getDefaultValue());
            }
        }
    }


    /**
     * Given a list of terminal Ids, create a Map of ID to terminal objects
     *
     * @param   modemIds    List of terminal IDs
     * @return              Map of terminal IDs to their respective terminal records
     */
    public static Map<Id, Terminal__c> buildMapOfTerminals(List<Id> terminalIds) { 

        Map<Id, Terminal__c> terminalMap = new Map<Id, Terminal__c>([SELECT Id, Name, Account__c, Account__r.Name
                                                                FROM Terminal__c 
                                                                WHERE Id IN :terminalIds]);

        return terminalMap;
    }

    /**
	 * Validates if Terminal Id input is correct form
	 *
	 * @param	terminalId		the terminalId input
	 * @return 					true if terminalId is valid, false if not
	 */
	public static boolean isValidTerminalId(String terminalId) {
        String TERMINAL_PREFIX_REGEX = '[Tt]';
        return new SfIdChecker(TERMINAL_PREFIX_REGEX).isValidFormat(terminalId);
	}

    private static boolean doesModemExistForTerminal(Terminal__c terminal)
    {
        return 0 < [SELECT COUNT() FROM Modem__c WHERE Terminal__c = :terminal.Id];
    }

    /**
     * Queries to find the Modem with the given Terminal linked to it
     *
     * @param 	terminal	The Terminal record to find the Modem record for
     * @return	        	The Modem record associated with the given Terminal
     */
     @TestVisible 
     private static Modem__c getModemWithTerminal(Terminal__c terminal) {
     	return getModemWithTerminal(terminal.Id);
     }

     /**
     * Queries to find the Modem with the Terminal for the given Terminal ID linked to it
     *
     * @param 	terminalId	The Terminal ID to search for in the Modem query
     * @return	          	The Modem record associated with the Terminal with the given Terminal ID
     */
     private static Modem__c getModemWithTerminal(Id terminalId) {
     	Modem__c modem = null;

     	try
     	{
     		SNG_SObjectQueryBuilder queryBuilder = new SNG_SObjectQueryBuilder(SNG_SObjectQueryBuilder.MODEM_OBJ_NAME);
     		queryBuilder.addAllFields();

     		final String queryString = queryBuilder.constructQuery() + ' WHERE Terminal__c = \'' + terminalId + '\'';
     		modem = Database.query(queryString);
     	}
     	catch(QueryException e) {
     		System.debug('No modem found for terminal ' + terminalId);
     	}

     	return modem;
     }

}