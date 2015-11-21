public with sharing class SNG_REST_MacAddresses extends SNG_REST_Collection {

	/**
     * Validates the terminal IDs to ensure they are in the proper format.
     *
     * @param   id                        The id to validate.
     * @return                            Whether the id is in the valid format or not.
     */
    public boolean isValidId(final String id) {
        return SNG_Terminal.isValidTerminalId(id);
    }

    /**
     * Constructs a result list based on the data provided. It is assumed the SNG_REST_Collection has validated
     * the necessary data before-hand.
     *
     * @param   detail                    The status details of the current request.
     * @param   ids                       The collection of IDs for the data requested.
     * @param   sObjects                  The corresponding objects to the request.
     * @return                            The response to the specific request.
     */
    public SNG_REST_Response constructResultList(final SNG_REST_StatusDetail detail, final String[] ids, final SObject[] sObjects) {
        Map<Id, Terminal__c> terminals = (null != sObjects) ? new Map<Id, Terminal__c>((Terminal__c[])sObjects) : new Map<Id, Terminal__c>();
        Modem__c[] modems = getModems(terminals);
        return buildResponse(detail, terminals, modems);
    }

    /**
     * Retrieves a list of Terminal objects that match the provided terminal names.
     *
     * @param   terminalNames             The list of terminal names.
     * @return                            A list of Terminal objects that correspond with the terminal names.
     */
    private SObject[] getSObjects(final String[] terminalNames) {
        return [SELECT Id, Name FROM Terminal__c WHERE Name = :terminalNames];
    }
    
    
    /**
     * Retrieves a list of Terminals that are under the users account.
     *
     * @return                            A list of terminals owned by the account.
     */    
    private SObject[] getSObjects() {
        return [SELECT Id, Name FROM Terminal__c];
    }

    /**
     * Retrieves a list of modems corresponding with the map of Terminals
     * 
     * @param   terminals  Map of Terminals
     * @return             List of modems
     */
    private static Modem__c[] getModems(final Map<Id, Terminal__c> terminals) {
    	return [SELECT Id, Name, Terminal__c, Terminal__r.Name FROM Modem__c WHERE Terminal__c = :terminals.keySet()];
    }

    /**
	 * Build the SNG_REST_Response
	 * 
	 * @param	detail			the status detail of the response
	 * @param	terminals		the terminals that the user passed in
	 * @param	macAddress		the mac addresses of the associated modems
	 * @return 					SNG_REST_Response
	 */ 
	private static SNG_REST_Response buildResponse(final SNG_REST_StatusDetail detail, final Map<Id, Terminal__c> terminals, final Modem__c[] modems) { 
		// Build "Data" portion of the reponse
		SNG_REST_TerminalIdMacAddressOutput[] termIdMacAddrData = buildResponseData(terminals, modems);
		// Build and return the response
		return new SNG_REST_Response(detail, new SNG_REST_CollectionOutput(termIdMacAddrData));
	}

	/**
	 * Bulids the data of the response
	 * 
	 * @param   terminals  Map of terminals that were passed in which actually correspond to Terminals under the account
	 * @param   modems     List of modems mapping to the terminals
	 * @return             List of SNG_REST_TerminalIdMacAddressOutput containing the response data
	 */
	private static SNG_REST_TerminalIdMacAddressOutput[] buildResponseData(final Map<Id, Terminal__c> terminals, final Modem__c[] modems) {
		// Map<Terminal Id, SNG_REST_TerminalIdMacAddressOutput>
		Map<Id, SNG_REST_TerminalIdMacAddressOutput> termIdMacAddrData = new Map<Id, SNG_REST_TerminalIdMacAddressOutput>();

		// Fill the map with nulls first so we include terminals without mac addresses
		for (Id terminalId : terminals.keySet()) {
			termIdMacAddrData.put(terminalId, new SNG_REST_TerminalidMacAddressOutput(terminals.get(terminalId).Name, null));
		}

		// Go through the list of modems and update the map
		for (Modem__c modem : modems) {
			termIdMacAddrData.put(modem.Terminal__c, new SNG_REST_TerminalidMacAddressOutput(modem.Terminal__r.Name, modem.Name));
		}

		return termIdMacAddrData.values();
	}

}