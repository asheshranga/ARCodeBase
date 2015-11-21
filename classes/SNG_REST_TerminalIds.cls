public with sharing class SNG_REST_TerminalIds extends SNG_REST_Collection {

    public SNG_REST_TerminalIds(final SNG_IConverter idConverter) {
        super(idConverter);
    }
	/**
     * Validates the MAC addresses to ensure they are in the proper format.
     *
     * @param   id                        The id to validate.
     * @return                            Whether the id is in the valid format or not.
     */
    public boolean isValidId(final String id) {
    	return new SNG_ModemMacAddressChecker().isValidFormat(id);
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
        Modem__c[] modems = (null != sObjects) ? (Modem__c[]) sObjects : new Modem__c[0];
        return buildResponse(detail, modems);
    }

    /**
     * Retrieves a list of Modem objects that match the provided MAC addresses.
     *
     * @param   macAddresses              The list of modem MAC addresses.
     * @return                            A list of Modem objects that correspond with the MAC addresses.
     */
    private SObject[] getSObjects(final String[] macAddresses) {
        return [SELECT Id, Name, Terminal__r.Name FROM Modem__c WHERE Name = :macAddresses];
    }

    /**
     * Retrieves a list of Modems that are under the users account.
     *
     * @return                            A list of Modems owned by the account.
     */    
    private SObject[] getSObjects() {
        return [SELECT Id, Name, Terminal__r.Name FROM Modem__c];
    }

    /**
	 * Build the SNG_REST_Response
	 * 
	 * @param	detail			the status detail of the response
	 * @param	modems		    the modems that the user passed in
	 * @return 					SNG_REST_Response
	 */ 
	private static SNG_REST_Response buildResponse(final SNG_REST_StatusDetail detail, final Modem__c[] modems) { 
		// Build "Data" portion of the reponse
		SNG_REST_TerminalIdMacAddressOutput[] termIdMacAddrData = buildResponseData(modems);
		// Build and return the response
		return new SNG_REST_Response(detail, new SNG_REST_CollectionOutput(termIdMacAddrData));
	}

	/**
	 * Bulids the data of the response
	 * 
	 * @param   modems     List of modems that were passed in which actually correspond to modems under the account
	 * @return             List of SNG_REST_TerminalIdMacAddressOutput containing the response data
	 */
	private static SNG_REST_TerminalIdMacAddressOutput[] buildResponseData(final Modem__c[] modems) {
		SNG_REST_TerminalIdMacAddressOutput[] termIdMacAddrData = new List<SNG_REST_TerminalIdMacAddressOutput>();
		for (Modem__c modem : modems) {
			termIdMacAddrData.add(new SNG_REST_TerminalidMacAddressOutput(null != modem.Terminal__r ? modem.Terminal__r.Name : null, modem.Name));
		}
		return termIdMacAddrData;
	}

}