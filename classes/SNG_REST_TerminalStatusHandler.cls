/**
 * This class handles the RESTful API request GET /terminals/status?{parameters}
 * and the API request GET /terminal/{parameter}/status
 */
public with sharing class SNG_REST_TerminalStatusHandler extends SNG_REST_Collection 
{
    /**
     * This error message is used in cases where an error occurs within the code that is unexpected. The error
     * is logged for developers to look if a response is received by the client with the specific message.
     */
    private static final String INTERNAL_SERVER_ERROR_MESSSAGE = 'Internal Server Error. See log for details.';

    /**
     * This class is used in the response to the terminals/performance/latest RESTful API request.
     */
    public class TerminalPerformanceLatestOutput implements Comparable, SNG_REST_IJsonResponseData 
    {
        /**
         * The terminal ID.
         */
        public String terminalId {
            get;
            private set {
                if (SNG_Terminal.isValidTerminalId(value)) {
                    terminalId = value;
                } else {
                    throw new SNG_REST_JsonResponseOutput.ValidationException('Invalid Terminal ID: ' + value);
                }
            }
        }

        /** Current status of the terminal. This indicator is the worst value between performance and pointing.
         *
         * Format:
         * 0 - Terminal is experiencing severe issues
         * 1 - Terminal is functioning as expected
         * 2 - Terminal is experiencing minor issues
         * 3 - Terminal is offline
         */
        public Integer status {
            get;
            private set {
                if (-1 < value && 4 > value) {
                    status = value;
                } else {
                    throw new SNG_REST_JsonResponseOutput.ValidationException('Invalid STATUS value: ' + value);
                }
            }
        }

        /**
         * Current status of the network.
         *
         * Format:
         * 0 - Network Outage
         * 1 - Network Functional
         */
        public Integer network {
            get;
            private set {
                if (-1 < value && 2 > value) {
                    network = value;
                } else {
                    throw new SNG_REST_JsonResponseOutput.ValidationException('Invalid NETWORK value: ' + value);
                }
            }
        }

        /**
         * Current weather for the network.
         *
         * Format:
         * 0 - Severe weather performance degradation.
         * 1 - No weather performance degradation.
         * 2 - Minor weather performance degradation.
         */
        public Integer weather {
            get;
            private set {
                if (-1 < value && 3 > value) {
                    weather = value;
                } else {
                    throw new SNG_REST_JsonResponseOutput.ValidationException('Invalid WEATHER value: ' + value);
                }
            }
        }

        /**
         * The performance of the terminal.
         *
         * Format:
         * 0 - Terminal is experiencing degraded performance.
         * 1 - Terminal performing as expected.
         * 2 - Terminal is experience minor degraded performance.
         * 3 - Terminal is offline.
         */
        public Integer performance {
            get;
            private set {
                if (-1 < value && 4 > value) {
                    performance = value;
                } else {
                    throw new SNG_REST_JsonResponseOutput.ValidationException('Invalid PERFORMANCE value: ' + value);
                }
            }
        }

        /**
         * The pointing efficiency of the terminal
         *
         * Format:
         * 0 - Terminal may be mispointed.
         * 1 - Terminal pointed correctly.
         * 2 - Terminal may be slightly mispointed.
         * 3 - Terminal is offline.
         */
        public Integer pointing {
            get;
            private set {
                if (-1 < value && 4 > value) {
                    pointing = value;
                } else {
                    throw new SNG_REST_JsonResponseOutput.ValidationException('Invalid POINTING value: ' + value);
                }
            }
        }

        /**
         * The amount of time the terminal has been online.
         *
         * Format:
         * ISO-1861 Duration
         */
        public String onlineTime { get; private set; }

        /**
         * Constructs a TerminalPerformanceLatestOutput object
         *
         * @param   terminalId  The Terminal ID (Name) for the Terminal
         * @param   status      The status light value for the Terminal's overall Status
         * @param   network     The status light value for the Terminal's network status
         * @param   weather     The status light value for the Terminal's weather status
         * @param   performance The status light value for the Terminal's performance status
         * @param   pointing    The status light value for the Terminal's pointing status
         * @param   onlineTime  The amount of time the terminal has been online in seconds
         */
        public TerminalPerformanceLatestOutput(String terminalId, SNG_REST_StatusLight.Status status,
                                               SNG_REST_StatusLight.Status network, SNG_REST_StatusLight.Status weather,
                                               SNG_REST_StatusLight.Status performance, SNG_REST_StatusLight.Status pointing,
                                               Long onlineTime) {
            this.terminalId = terminalId;
            this.status = getStatusInteger(status);
            this.network = getStatusInteger(network);
            this.weather = getStatusInteger(weather);
            this.performance = getStatusInteger(performance);
            this.pointing = getStatusInteger(pointing);
            this.onlineTime = stringifyOnlineTime(onlineTime);
        }

        /**
         * Compares this TerminalPerformanceLatestOutput object to another TerminalPerformanceLatestOutput object
         *
         * Note: This method is required by the Comparable interface which this class implements. It is used for sorting
         *       collections of TerminalPerformanceLatestOutput objects.
         *
         * @param   objectToCompareTo      TerminalPerformanceLatestOutput object to compare this object to
         * @return                         The result of the serialized objects compared with each other
         * @throws  SNG_Exception          If the passed in objectToCompareTo is not of type TerminalPerformanceLatestOutput
         * @throws  NullPointerException   If objectToCompareTo is null 
         */
        public Integer compareTo(Object objectToCompareTo) {
            if (!(objectToCompareTo instanceof TerminalPerformanceLatestOutput)) {
                throw new SNG_Exception('Cannot compare a TerminalPerformanceLatestOutput object with an object of another type');
            }

            TerminalPerformanceLatestOutput other = (TerminalPerformanceLatestOutput)objectToCompareTo; 
            return terminalId.compareTo(other.terminalId); // terminalId is sufficient since they are unique.
        }

        /**
         * Stringifies online time in the proper format for the JSON response
         *
         * @param   seconds             The number of seconds the terminal has been online in seconds
         * @return                      The stringified online time
         * @throws  ValidationException If the given duration in seconds is invalid
         */
        private String stringifyOnlineTime(Long seconds) {
            try {
                return ISODateAndTimeConverter.formatDuration(seconds);
            } catch (ISODateAndTimeConverter.ISODateAndTimeException e) {
                throw new SNG_REST_JsonResponseOutput.ValidationException('Invalid Online Time: ' + (null == seconds ? 'null' : String.valueOf(seconds)));
            }
        }

        /**
         * Gets the Integer representation for the given status value
         *
         * @param   status              The status value
         * @return                      The Integer representation for the given status value
         * @throws  ValidationException If the given status was null
         */
        private Integer getStatusInteger(SNG_REST_StatusLight.Status status) {
            if (null != status) {
                return status.ordinal();
            } else {
                throw new SNG_REST_JsonResponseOutput.ValidationException('Null status value');
            }
        }

       /**
        * Indicates whether some other object is "equal to" this one.
        * 
        * @param   obj             The reference object with which to compare.
        * @return                  True if this object is the same as the obj argument; false otherwise.
        */
        public boolean equals(Object obj)
        {
            if (this === obj) return true;
            if (obj == null || !(obj instanceof TerminalPerformanceLatestOutput)) return false;

            TerminalPerformanceLatestOutput other = (TerminalPerformanceLatestOutput) obj; 
            return ( (this.terminalId == other.terminalId) &&
                     (this.status == other.status) &&
                     (this.network == other.network) &&
                     (this.weather == other.weather) &&
                     (this.performance == other.performance) &&
                     (this.pointing == other.pointing) &&
                     (this.onlineTime == other.onlineTime) );
        }

       /**
        * The hashcode for this object.
        *
        * @return                   A singular hashcode representing this object.
        */
        public Integer hashCode()
        {
            final Integer prime = 31;
            Integer result = 1;
            result = prime * result
                    + ((network == null) ? 0 : network);
            result = prime * result
                    + ((onlineTime == null) ? 0 : onlineTime.hashCode());
            result = prime * result
                    + ((performance == null) ? 0 : performance);
            result = prime * result
                    + ((pointing == null) ? 0 : pointing);
            result = prime * result
                    + ((status == null) ? 0 : status);
            result = prime * result
                    + ((terminalId == null) ? 0 : terminalId.hashCode());
            result = prime * result
                    + ((weather == null) ? 0 : weather);
            return result;
        }
    }

    /**
     * Checks if the ID name is of valid format
     *
     * @param  terminalName    Terminal name to validate.
     * @return                 true if terminal name is valid; false otherwise
     */
    public boolean isValidId(String terminalName)
    {
        return SNG_Terminal.isValidTerminalId(terminalName);
    }

    /**
     * Retrieves salesforce custom objects relevant to the calling API method based on the list
     *  of ID names that are input
     *
     * @param ids   ID names of the custom objects to be retrieved
     * @return      custom objects corresponding to the list of ID names
     */
    public List<SObject> getSObjects(String[] terminalNames)
    {
        List<Terminal__c> terminals = [SELECT Id, Name, PeersOnlineBackEnd__c, PeersAvgUploadSymbolRateBackEnd__c, DownloadSinrBackEnd__c,
                                       UploadSymbolRateBackEnd__c, Status__c, StatusBackEnd__c, Network__c, WeatherBackEnd__c, Performance__c,
                                       Pointing__c, OnlineTime__c FROM Terminal__c WHERE Name IN :terminalNames];
        return terminals;
    }

    /**
     * Retrieves ALL salesforce custom objects associated with account relevant to the
     *  calling API method
     * @return      all custom objects associated with account relevant to the calling API method
     */
    public sobject[] getSObjects()
    {
        List<Terminal__c> terminals = [SELECT Id, Name, Nickname__c, SerialNumber__c, TerminalType__r.Name FROM Terminal__c];
        return terminals;
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
    public SNG_REST_Response constructResultList(SNG_REST_StatusDetail detail, final List<String> ids, final List<SObject> sObjects)
    {   
        
        List<Terminal__c> terminals = (null != sObjects) ? sObjects : new List<Terminal__c>();
        Map<Id, String> terminalIdToMacAddr = SNG_Terminal.getModemMacAddressForTerminals(terminals);
        detail = updateInitialStatus(detail, ids, terminals, terminalIdToMacAddr);
        
        SNG_REST_Response response = null;
        SNG_Perf.PerfLatest perfLatest = null;
        if (SNGHttpUtilities.Status.ZERO_RESULTS != detail.status)
        {
            // Call PmdrService and construct the result
            perfLatest = getLatestPerformance(terminalIdToMacAddr.values(), true);
            perfLatest = evaluateResponse(detail, perfLatest);
        }

        return (null != perfLatest && null != perfLatest.result) ? processResponse(detail, perfLatest, ids, terminalIdToMacAddr, terminals) :
                                                                   new SNG_REST_Response(detail, null);
    }

    /**
     * Initializes the status based on the modems obtained from the terminal ID parameters.
     *
     * @param  detail                  The status detail of the current request.
     * @param  terminalIds             The terminal IDs for the status requested
     * @param  terminalObjs            The corresponding terminal objects for the Terminal IDs. 
     *                                 Any IDs that do not correspond with the objects are not included.
     * @param  terminalIdsToMacAddr    A collection of terminal IDs with their corresponding MAC address.
     * @return                         The updated status detail for the current request.
     */
    private SNG_REST_StatusDetail updateInitialStatus(SNG_REST_StatusDetail detail, 
                                                      final List<String> terminalIds, 
                                                      final List<Terminal__c> terminalObjs, 
                                                      final Map<Id, String> terminalIdToMacAddr)
    {

        // only degrade status furthur if necessary.
        if (!ArrayUtils.isEmpty(terminalIds) && terminalIdToMacAddr.size() != terminalIds.size())
        {
            detail.status = (terminalIdToMacAddr.isEmpty() || terminalObjs.isEmpty()) ?  SNGHttpUtilities.Status.ZERO_RESULTS : SNGHttpUtilities.Status.OK_WITH_ERRORS;
            detail.code = SNG_REST_Error.SubCode.SALESFORCE_GENERATED_ERROR; 
            detail.message = (terminalObjs.size() != terminalIds.size()) ? SNG_REST_Error.IDS_INVALID : SNG_REST_Error.TERMINAL_NO_MODEM;
        }

        return detail;
    }

    /**
     * Evaluates the response from the web service queried to obtain the performance information of the modem.
     *
     * @param  detail                  The status detail of the current request.
     * @param  perfLatest              The response from the web service.
     * @return                         The response from the web service. 
     */
    private SNG_Perf.PerfLatest evaluateResponse(SNG_REST_StatusDetail detail, SNG_Perf.PerfLatest perfLatest)
    {

        if (SNGHttpUtilities.Status.ZERO_RESULTS.name() == perfLatest.status)
        {
            perfLatest.result = (null != perfLatest.result) ? perfLatest.result : new List<SNG_Perf.PerfLatestResult>();
            // use current default status.
        }
        else if (SNGHttpUtilities.Status.OK.name() != perfLatest.status) 
        {
            detail.status = SNG_REST_Utilities.getStatusFromString(perfLatest.status);
            detail.code = SNG_REST_Error.SubCode.WEBSERVICE_GENERATED_ERROR;
            detail.message = SNG_REST_Error.GENERIC_WEBSERVICE_ERROR;
        }
        else if (null == perfLatest.result) {
            // NOTE: This should not actually happen if PmdrService behaves as it should.
            //       If this does happen, there is a problem with PmdrService.
            //       If Status is OK, result should not be null.
            detail.status = SNGHttpUtilities.Status.SERVER_ERROR;
            detail.code = SNG_REST_Error.SubCode.SALESFORCE_GENERATED_ERROR;
            detail.message = SNG_REST_Error.GENERIC_WEBSERVICE_ERROR;
        } 

        return perfLatest;
    }

    /**
     * Processes the response from the web service, updating the corresponding terminal object and generating
     * a response to return the client.
     *
     * @param  detail                  The status detail of the current request.
     * @param  perfLatest              The response from the web service.
     * @param  ids                     The collection of IDs for the data requested.
     * @param  terminalIdToMacAddr     A collection of terminal IDs with their corresponding MAC address. 
     * @param  terminals               A collection of terminal objects.
     * @return                         The response capturing the web service response to return to the client.   
     */
    private SNG_REST_Response processResponse(SNG_REST_StatusDetail detail, 
                                              final SNG_Perf.PerfLatest perfLatest,
                                              final List<String> ids, 
                                              final Map<Id, String> terminalIdToMacAddr,
                                              final List<Terminal__c> terminals )
    {
        Map<String, Terminal__c> macAddrToTerminals = updateTerminals(perfLatest, terminalIdToMacAddr, terminals, ids);
        return buildResponse(detail, perfLatest, macAddrToTerminals); 
    }

    /**
     * Updates the values in the Terminal object which need to change based on the response from the
     * PerformanceLatest call to PmdrService
     *
     * @param   perfLatest          The deserialized response from PmdrService
     * @param   terminalIdToMacAddr Mapping from Terminal ID (Terminal__c.Id) to Modem MAC Address
     * @param   terminals           List of Terminal's with all necessary fields present
     * @param   terminalIdNames     List of Terminal ID names (Terminal__c.Name) to use when needing
     *                              to requery the terminal after updating fields which change
     *                              formula field values
     * @return                      Mapping from Modem MAC Address to Terminal containing the updated
     *                              field values
     */
    private Map<String, Terminal__c> updateTerminals(SNG_Perf.PerfLatest perfLatest, 
                                                     Map<Id, String> terminalIdToMacAddr,
                                                     Terminal__c[] terminals,
                                                     final String[] terminalIdNames) {
        
        Map<String, Terminal__c> macAddrToTerminal = getMacAddrToTerminalMap(terminalIdToMacAddr, terminals);

        for (SNG_Perf.PerfLatestResult result : perfLatest.result) {
            final String macAddr = SNGHttpUtilities.translateMacAddressFromDbToSfFormat(result.UTSUMMARYMACADDR);
            Terminal__c terminal = macAddrToTerminal.get(macAddr);
            if (null != terminal) {
                terminal.PeersOnlineBackEnd__c = result.NUM_PEERS_ONLINE;
                terminal.PeersAvgUploadSymbolRateBackEnd__c = result.PEER_AVG_SYMBOL_RATE;
                terminal.DownloadSinrBackEnd__c = result.UTFLSINR;
                terminal.UploadSymbolRateBackEnd__c = result.UTRLSYMBOLRATE;
                terminal.OnlineTime__c = SNG_UTPerformanceFromPerf.getTimeString(SNG_SnmpDateAndTimeConverter.translateTimeToDurationFromNow(result.UTONLINETIME));

                macAddrToTerminal.put(macAddr, terminal);
            }
        }

        update macAddrToTerminal.values();

        // NOTE: This intermediate update is needed before calling SNG_TerminalQuery.setStatusTrafficLightInTerminal(terminal),
        //       in order to ensure that the correct values are being used in determining the Status.
        terminals = getSObjects(terminalIdNames);
        macAddrToTerminal = getMacAddrToTerminalMap(terminalIdToMacAddr, terminals);

        // Set the status traffic lights
        for (SNG_Perf.PerfLatestResult result : perfLatest.result) {
            final String macAddr = SNGHttpUtilities.translateMacAddressFromDbToSfFormat(result.UTSUMMARYMACADDR);
            Terminal__c terminal = macAddrToTerminal.get(macAddr);
            if (null != terminal) {
                terminal = SNG_TerminalQuery.setStatusTrafficLightInTerminal(terminal);
                macAddrToTerminal.put(macAddr, terminal);
            }
        }

        update macAddrToTerminal.values();

        terminals = getSObjects(terminalIdNames);
        macAddrToTerminal = getMacAddrToTerminalMap(terminalIdToMacAddr, terminals);

        return macAddrToTerminal;
    }


    /**
     * Builds the object response for the RESTful HTTP GET request made by the client.
     * 
     * @param   detail                      The status detail of the current request.
     * @param   response                    The response from the web service queried.
     * @param   terminalIdToMacAddr         A collection of terminal IDs with their corresponding MAC address. 
     *
     * @return                              The object response to the client request.
     */ 
    private SNG_REST_Response buildResponse(SNG_REST_StatusDetail detail, 
                                            final SNG_Perf.PerfLatest response, 
                                            final Map<String, Terminal__c> macAddrToTerminal)
    {
        List<TerminalPerformanceLatestOutput> result = new List<TerminalPerformanceLatestOutput>();

        for (SNG_Perf.PerfLatestResult perfLatestResult : response.result) 
        {
            final String macAddr = SNGHttpUtilities.translateMacAddressFromDbToSfFormat(perfLatestResult.UTSUMMARYMACADDR);
            Terminal__c terminal = macAddrToTerminal.get(macAddr);
            if (null != terminal) {

                TerminalPerformanceLatestOutput iResult = 
                    new TerminalPerformanceLatestOutput(terminal.name, 
                                                        SNG_REST_StatusLight.getStatus(terminal.Status__c),         // status
                                                        SNG_REST_StatusLight.getStatus(terminal.Network__c),   // network - no offline option 
                                                        SNG_REST_StatusLight.getStatus(terminal.WeatherBackEnd__c),   // weather - no offline option
                                                        SNG_REST_StatusLight.getStatus(terminal.Performance__c),         // performance
                                                        SNG_REST_StatusLight.getStatus(terminal.Pointing__c),         // pointing
                                                        SNG_SnmpDateAndTimeConverter.translateTimeToDurationFromNow(perfLatestResult.UTONLINETIME)); 
                result.add(iResult);
            } else {
                final String internalErrorMsg = 'SNG_REST_TerminalStatusHandler.constructResultList: Could not find terminal for mac address [' 
                                                + (null != macAddr ? macAddr : 'null') + '] in macAddrToTerminal';
                throw new SNG_REST_Exception(new SNG_REST_StatusDetail(SNGHttpUtilities.Status.SERVER_ERROR, 
                                             SNG_REST_Error.SubCode.SALESFORCE_GENERATED_ERROR, 
                                             INTERNAL_SERVER_ERROR_MESSSAGE), internalErrorMsg);
            }
        }

        Set<String> macAddresses = createResultSet(response.result);
        defaultMissingEntries(result, macAddrToTerminal, macAddresses);

        return new SNG_REST_Response(detail, new SNG_REST_CollectionOutput(result));
    }

    /**
     * Creates a result set from the web service response object. The returned collection contains a set
     * of MAC addresses found in the response object. The collection returned provides an easy lookup
     * method.
     *
     * @param   performanceResult          The response object obtained from the web service.
     * @return                             The collection set of MAC addresses in the response.
     */
    private static Set<String> createResultSet(final List<SNG_Perf.PerfLatestResult> performanceResult)
    {
        Set<String> result = new Set<String>();
        
        for (SNG_Perf.PerfLatestResult perf : performanceResult)
        {
            result.add(SNGHttpUtilities.translateMacAddressFromDbToSfFormat(perf.UTSUMMARYMACADDR).toLowerCase());
        }
        
        return result;
    }

    /**
     * This method defaults the missing entries from the response.
     *
     * @param   result                     The current result collection to be updated with default entries.
     * @param   macAddrToTerminal          Contains a mapping between the mac address to its terminal object.
     * @param   macAddresses               The collection of MAC addresses found in the response 
     *                                     from the web service.
     */
    private void defaultMissingEntries(List<TerminalPerformanceLatestOutput> result,
                                       final Map<String, Terminal__c> macAddrToTerminal,
                                       final Set<String> macAddresses)
    {
        for (String macAddress : macAddrToTerminal.keySet())
        {
            if (!macAddresses.contains(macAddress))
            {
                TerminalPerformanceLatestOutput iResult = 
                    new TerminalPerformanceLatestOutput(macAddrToTerminal.get(macAddress).name, 
                                                        SNG_REST_StatusLight.Status.OFFLINE,         // status
                                                        SNG_REST_StatusLight.Status.SEVERE_ISSUES,   // network - no offline option 
                                                        SNG_REST_StatusLight.Status.SEVERE_ISSUES,   // weather - no offline option
                                                        SNG_REST_StatusLight.Status.OFFLINE,         // performance
                                                        SNG_REST_StatusLight.Status.OFFLINE,         // pointing
                                                        0);                                          // online time.
                result.add(iResult);
            }
        }
    }


    /**
     * Creates a mapping from Modem MAC Address to Terminal object
     *
     * @param   terminalIdToMacAddr Mapping from Terminal ID (Terminal__c.Id) to Modem MAC Address
     * @param   terminals           The list of terminals to be included in the new mapping
     * @return                      Map<String, Terminal__c> from Modem MAC Address to Terminal object
     */
    private static Map<String, Terminal__c> getMacAddrToTerminalMap(Map<Id, String> terminalIdToMacAddr, Terminal__c[] terminals) {
        SNG_ExceptionUtil.throwIfNullObject(terminalIdToMacAddr,
                'SNG_REST_TerminalStatusHandler.getMacAddrToTerminalMap called with null terminalIdToMacAddr');
        SNG_ExceptionUtil.throwIfNullObject(terminals,
                'SNG_REST_TerminalStatusHandler.getMacAddrToTerminalMap called with null terminals');

        Map<String, Terminal__c> macAddrToTerminal = new Map<String, Terminal__c>();

        for (Terminal__c terminal : terminals) {
            String macAddr = terminalIdToMacAddr.get(terminal.Id);
            if (null != macAddr) {
                macAddrToTerminal.put(macAddr.toLowerCase(), terminal);
            }
        }

        return macAddrToTerminal;
    }


    private  SNG_Perf.PerfLatest getLatestPerformance(List<String> macAddresses, boolean allowCookieCaching)
    {
        return (!ArrayUtils.isEmpty(macAddresses)) ? SNG_PerformanceLatest.getPerformance(macAddresses, true) :
                                                     new SNG_Perf.PerfLatest();
    }
}