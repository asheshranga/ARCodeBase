public with sharing class SNG_REST_TerminalsAdminInfoRequest extends SNG_REST_Collection
{  
    /**
     * This class contains the terminal adminstrative information for a single terminal. This
     * class is wrapped in the TerminalAdminInfoListOutput when responding to a RESTful API request.
     */
    public class TerminalAdminInfo implements SNG_REST_IJsonResponseData
    {
        /**
         * The terminal ID.
         */
        public String terminalId;
        
        /**
         * The nickname of the terminal.
         */
        public String nickname { get; private set; }
        
        /**
         * The serial number of the terminal.
         */
        public String serialNumber { get; private set; }
        
        /**
         * The terminal type.
         */
        public String terminalType { get; private set; }
        
        /**
         * The current software version for the terminal.
         */
        public String softwareVersion { get; private set; }
        
        /**
         * The modem MAC address.
         */
        public String macAddress { get; private set; }
        
        /**
         * Creates an instance of the object.
         *
         * @param    terminal           The terminal object.
         * @param    macAddress         The Modem MAC address.
         * @param    softwareVersion    The Modem software version.
         */
        public TerminalAdminInfo(Terminal__c terminal, String macAddress, String softwareVersion)
        {
            terminalId = terminal.Name;
            nickname = terminal.Nickname__c;
            serialNumber = terminal.SerialNumber__c;
            terminalType = terminal.TerminalType__r.Name;
            this.softwareVersion = softwareVersion;
            this.macAddress = macAddress;
        }
        
        public virtual boolean equals(Object obj) 
        {
            if (this === obj) return true;
            if (obj == null || !(obj instanceof TerminalAdminInfo)) return false;
            TerminalAdminInfo other = (TerminalAdminInfo)obj;
            return (StringUtils.equals(terminalId, other.terminalId) &&
                    StringUtils.equals(macAddress, other.macAddress) &&
                    StringUtils.equals(nickname, other.nickname) &&
                    StringUtils.equals(serialNumber, other.serialNumber) &&
                    StringUtils.equals(terminalType, other.terminalType) &&
                    StringUtils.equals(softwareVersion, other.softwareVersion));
        }
        
        public virtual integer hashCode()
        {
            final integer prime = 31;
            integer result = 1;
            result = prime * result + ((terminalId == null) ? 0 : terminalId.hashCode());
            result = prime * result + ((macAddress == null) ? 0 : macAddress.hashCode());
            result = prime * result + ((nickname == null) ? 0 : nickname.hashCode());
            result = prime * result + ((serialNumber == null) ? 0 : serialNumber.hashCode());
            result = prime * result + ((terminalType == null) ? 0 : terminalType.hashCode());
            result = prime * result + ((softwareVersion == null) ? 0 : softwareVersion.hashCode());
            return result;
        }
    }
 
    /**
     * An error mesage to indicate the software version could not be retrieved for the terminal.
     */
    @TestVisible
    private static final String SOFTWARE_VERSION_ERROR = 'Unable to obtain software version for at least one terminal.';  
    
    /**
     * Constructs a result list based on the data provided. It is assumed the SNG_REST_Collection has validated
     * the necessar data before-hand.
     *
     * @param   ids                       The collection of IDs for the data requested.
     * @param   sObjects                  The corresponding objects to the request.
     * @param   detail                    The status details of the current request.
     * @return                            The response to the specific request.
     */
    public SNG_REST_Response constructResultList(SNG_REST_StatusDetail detail, final List<String> ids, final List<SObject> sObjects)
    {
        SNG_Perf.UtPhyVersion updateSoftwareVersion = null;
        List<Terminal__c> terminals = (null != sObjects) ? sObjects : new List<Terminal__c>();
        List<Modem__c> modems = (!ArrayUtils.isEmpty(ids)) ? getModems(ids) : getModems();
        detail = updateInitialStatus(detail, ids, terminals, modems);
        List<String> macAddresses = createMacAddressList(modems);
        updateSoftwareVersion = updateSoftwareVersion(macAddresses);
        SNGHttpUtilities.Status externalStatus = SNG_REST_Utilities.getStatusFromString(updateSoftwareVersion.status);
        detail = evaluateStatus(detail, externalStatus);
        return buildResponse(detail, modems, terminals, updateSoftwareVersion);     
    }
    
    /**
     * Builds the JSON object response for the RESTful HTTP GET request made by the client.
     * 
     * @param   modems                      The list of modems associated with the request.
     * @param   terminals                   The list of terminals associated with the request.
     * @param   updateSoftwaverVersion      The software version information.
     *
     * @return                              A JSON formatted result string.
     */ 
    private static SNG_REST_Response buildResponse(SNG_REST_StatusDetail detail, 
                                                   List<Modem__c> modems, 
                                                   List<Terminal__c> terminals, 
                                                   SNG_Perf.UtPhyVersion updateSoftwareVersion)
    {
        Map<String, String> macAddressToSwVersion = constructMacAddressToSwMapping(updateSoftwareVersion.result);
        Map<String, String> terminalToMacAddress = constructTerminalToMacAddressMapping(modems);
        
        List<TerminalAdminInfo> terminalAdminInfos = (0 < terminals.size()) ? new List<TerminalAdminInfo>() : null;
        
        for (Terminal__c t : terminals)
        {
            String macAddress = getTerminalMacAddress(terminalToMacAddress, t.Name);
            String softwareVersion = getSoftwareVersion(macAddressToSwVersion, macAddress);
            addEntry(terminalAdminInfos, t, macAddress, softwareVersion);
        }
        
        return new SNG_REST_Response(detail, new SNG_REST_CollectionOutput(terminalAdminInfos));
    }
    
    /**
     * Calculates the status based on the overall status and the web service callout status, combining the results into one.
     *
     * @param   internalStatus   Captures the status of the administrative information retrieval within Salesforce.
     * @param   externalStatus   Captures the Web service callout status, when attempting to retrieve the software version.
     *
     * @return                   The combined status between the internal and the external Web service status.
     */
    private static SNG_REST_StatusDetail evaluateStatus(SNG_REST_StatusDetail internalDetail, SNGHttpUtilities.Status externalStatus)
    {
        SNG_REST_StatusDetail retDetail = internalDetail;
        
        if (SNGHttpUtilities.Status.OK != externalStatus && SNGHttpUtilities.Status.OK == internalDetail.status)
        {
            retDetail.status = SNG_REST_Utilities.getCombinedStatus(internalDetail.status, SNGHttpUtilities.Status.OK_WITH_ERRORS);
            retDetail.code = (null != retDetail.code) ? retDetail.code : SNG_REST_Error.SubCode.WEBSERVICE_GENERATED_ERROR;
            retDetail.message = (null != retDetail.message) ? retDetail.message : SOFTWARE_VERSION_ERROR;
        }
        else
        {
            retDetail.status = SNG_REST_Utilities.getCombinedStatus(internalDetail.status, externalStatus);
        }
        
        return retDetail;     
    }
           
    /**
     * Initializes the status based on the modems obtained from the terminal ID parameters.
     *
     * @param  modems      The list of modems corresponding to the terminal ID.
     * @param  terminals   The list of terminal IDs in the URI of the RESTful API request.
     * @return                 The initial status based on the modems and terminal IDs.
     */
    private SNG_REST_StatusDetail updateInitialStatus(SNG_REST_StatusDetail detail, List<String> terminalIds,  List<Terminal__c> terminals, List<Modem__c> modems)
    {
        // only degrade status furthur if necessary.
        if (!ArrayUtils.isEmpty(terminalIds) && modems.size() != terminalIds.size())
        {
            detail.status = (!modems.isEmpty()) ? SNGHttpUtilities.Status.OK_WITH_ERRORS : SNGHttpUtilities.Status.ZERO_RESULTS;
            detail.code = SNG_REST_Error.SubCode.SALESFORCE_GENERATED_ERROR; 
            detail.message = SNG_REST_Error.TERMINAL_NO_MODEM;
        }
    
        return detail;
    }

    /**
     * Adds each terminal entry for the response.
     *
     * @param tais              The list of the terminal admin infos.
     * @param terminal          The terminal object containing the info.
     * @param macAddress        The MAC address.
     * @param softwareVersion   The software version.
     */
    private static void addEntry(List<TerminalAdminInfo> tais, Terminal__c terminal, String macAddress, String softwareVersion)
    {
        if (!StringUtils.isEmpty(terminal.Id))
        {
             tais.add(new TerminalAdminInfo(terminal, macAddress, softwareVersion));
        }
    }

    /**
     * Retrieves the software version corresponding to the MAC address.
     * 
     * @param    macAddressToSwVersion     Mapping between MAC address to software version.
     * @param    macAddress                The MAC address.
     * @return                             The software version or NULL if not found.     
     */
    private static String getSoftwareVersion(Map<String, String> macAddressToSwVersion, String macAddress)
    {
        return (macAddressToSwVersion.containsKey(macAddress)) ? macAddressToSwVersion.get(macAddress) : null;
    }


    /**
     * Retrieves the MAC address corresponding to the terminal ID.
     * 
     * @param    macAddressToSwVersion     Mapping between terminal ID to the MAC address.
     * @param    terminalName              The terminal ID.
     * @return                             The MAC address or NULL if not found.     
     */
    private static String getTerminalMacAddress(Map<String, String> terminalToMacAddress, String terminalName)
    {
        return (terminalToMacAddress.containsKey(terminalName)) ? terminalToMacAddress.get(terminalName) : null;
    }

    /**
     * Constructs the terminal to MAC address mapping based on the modem objects.
     *
     * @param    modems                    The list of modem objects.
     * @return                             The mapping between terminal IDs to MAC address.
     */
    private static Map<String, String> constructTerminalToMacAddressMapping(List<Modem__c> modems)
    {
        Map<String, String> terminalToMacAddress = new Map<String, String>();
        
        for (Modem__c m : modems)
        {
            terminalToMacAddress.put(m.Terminal__r.Name, m.MacAddress__c.toLowerCase());
        }
        
        return terminalToMacAddress;    
    }

    /**
     * Constucts the MAC address to software version mapping based on the results obtained from PmdrService.
     *
     * @param    macAddressSwVersions      The list of MAC address to software versions.
     * @return                             The mapping between MAC address to software version.
     */
    private static Map<String, String> constructMacAddressToSwMapping(List<SNG_Perf.UtPhyVersionResult> macAddressSwVersions)
    {
        Map<String, String> macAddressToSwVersion = new Map<String, String>();
        for (SNG_Perf.UtPhyVersionResult masv : macAddressSwVersions)
        {
           macAddressToSwVersion.put(SNGHttpUtilities.translateMacAddressFromDbToSfFormat(masv.MACADDR), masv.SOFTWAREVERSION);
        }
        
        return macAddressToSwVersion;
    }

    /**
     * Validates the terminal IDs to ensure they are in the proper format.
     *
     * @param   id                        The id to validate.
     * @return                            Whether the id is in the valid format or not.
     */
    public boolean isValidId(String id)
    {
        return SNG_Terminal.isValidTerminalId(id);
    }

    /**
     * Retrieves a list of modems that are linked to the provided terminal names.
     *
     * @param   terminalNames             The list of terminal names.
     * @return                            A list of modem objects linked to the terminal ID.
     */
    private static List<Modem__c> getModems(String[] terminalNames)
    {
        List<Modem__c> modems = [SELECT Id, Terminal__r.Name, MacAddress__c FROM Modem__c WHERE Terminal__r.Name IN :terminalNames];
        return modems;
    }

    /**
     * Retrieves a list of modems that are under the users account.
     *
     * @return                            A list of modem objects owned by the account.
     */    
    private static List<Modem__c> getModems()
    {
        List<Modem__c> modems = [SELECT Id, Terminal__r.Name, MacAddress__c FROM Modem__c];
        return modems;
    }
    
    /**
     * Retrieves a list of terminal objects that match the provided terminal names.
     *
     * @param   terminalNames             The list of terminal names.
     * @return                            A list of terminal objects that correspond with the terminal name.
     */
    private List<SObject> getSObjects(String[] terminalNames)
    {
        List<Terminal__c> terminals = [SELECT Id, Name, Nickname__c, SerialNumber__c, TerminalType__r.Name FROM Terminal__c WHERE Name IN :terminalNames];
        return terminals;
    }
    
    
    /**
     * Retrieves a list of terminals that are under the users account.
     *
     * @return                            A list of terminals owned by the account.
     */    
    private List<SObject> getSObjects()
    {
        List<Terminal__c> terminals = [SELECT Id, Name, Nickname__c, SerialNumber__c, TerminalType__r.Name FROM Terminal__c];
        return terminals;
    }
      
    /**
     * Creates a list of mac addresses based on the list of Modem objects.
     *
     * @param   modems                    The list of the Modem objects to generate the list of the MAC addresses.
     * @return                            The list of MAC addresses corresponding to the modem.
     */
    private static List<String> createMacAddressList(List<Modem__c> modems)
    {
        List<String> macAddresses = new List<String>();
        for (Modem__c m : modems)
        {
            macAddresses.add(m.MacAddress__c);
        }
        
        return macAddresses;
    }
    
    /**
     * Updates the software version based on the list of MAC addresses
     *
     * @param    macAddresses             The list of Modem MAC addresses.
     * @return                            An object that contains the software version corresponding to the MAC address.
     */
    private static SNG_Perf.UtPhyVersion updateSoftwareVersion(List<String> macAddresses)
    {
        return (!ArrayUtils.isEmpty(macAddresses)) ? SNG_REST_ModemSoftwareVersion.get(macAddresses) :
                                                        new SNG_Perf.UtPhyVersion();
    }
}