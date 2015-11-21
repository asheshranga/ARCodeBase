/**
 * This class contains structures for data retrieved from PERF DB via Web Services on the
 * SNG Tomcat server. This includes both structures matching the JSON responses back from
 * the SNG Tomcat server, as well as some structures used in both the Salesforce REST
 * endpoints as well as on pages representing the data.
 */
global with sharing class SNG_Perf {
	
	/**
	 * The state of the user terminal in the SMTS MIB (stored in Perf DB).
	 * NOTE: The order, and name of these values must not be changed,
	 *       since it will break deserializing the JSON response.
	 */
	public enum UTState {
		off_line,                	// 0
		ranging,                	// 1
		authenticating,            	// 2
		registering,               	// 3
		transferring_op_params,    	// 4
		on_line,                	// 5
		handover,                	// 6
		symbol_rate_discovery,     	// 7
		capabilities_negotiation,  	// 8
		network_entry              	// 9
		                         	// NOTE: network_entry is not a state in the SMTS MIB.
		                         	//       It is only for simplifying the state for the customer.
	}
	
	public static final transient Map<integer, UTState> utStateMap = new Map<integer, UTState>();
	
	static {
		for (UTState state : UTState.values()) {
			utStateMap.put(state.ordinal(), state);
		}
	}
	
	public static UTState toUTState(integer stateValue)
	{
		UTState utState = null;
		
		if (utStateMap.containsKey(stateValue))
		{
			utState = utStateMap.get(stateValue);
		}
		else
		{
			throw new SNG_Exception('Cannot convert value: ' + stateValue + ' to UTState');
		}
		
		return utState;
	}
	
	/**
	 * Returns a pretty string to show on pages for the given UTState enum value
	 *
	 * @param 	state	The UTState enum value to return a pretty string for
	 * @return	     	A pretty string string for the given UTState enum value
	 */
	public static String getPrettyStateString(UTState state) {
		if (state == UTState.off_line) {
			return 'Offline';
		} else if (state == UTState.ranging) {
			return 'Ranging';
		} else if (state == UTState.authenticating) {
			return 'Authenticating';
		} else if (state == UTState.registering) {
			return 'Registering';
		} else if (state == UTState.transferring_op_params) {
			return 'Transferring Op Params';
		} else if (state == UTState.on_line) {
			return 'Online';
		} else if (state == UTState.handover) {
			return 'Handover';
		} else if (state == UTState.symbol_rate_discovery) {
			return 'Symbol Rate Discovery';
		} else if (state == UTState.capabilities_negotiation) {
			return 'Capabilities Negotiation';
		} else if (state == UTState.network_entry) {
			return 'Network Entry';
		}
		return 'Unknown';
	}
	
	
	public class PerfLatest {
		// these need to have public mutators.
		public String status { get; set; }
		public PerfLatestResult[] result { get; set; }

		/**
		 * Creates an instance of this class.
		 */
		public PerfLatest()
		{
			this(SNGHttpUtilities.Status.ZERO_RESULTS, new List<PerfLatestResult>());
		}
		
		public PerfLatest(SNGHttpUtilities.Status status, PerfLatestResult[] result) {
            this.status = status.name();
            this.result = result;
        }
	}
	
	public class PerfLatestResult {
		@TestVisible public Long NUM_PEERS_ONLINE { get; private set; }
		@TestVisible public Decimal PEER_AVG_SYMBOL_RATE { get; private set; }
		@TestVisible public String UTSUMMARYMACADDR { get; private set; }
		@TestVisible public Decimal UTFLSINR { get; private set; }
		@TestVisible public Decimal UTRLSYMBOLRATE { get; private set; }
		@TestVisible public String UTONLINETIME { get; private set; }
		@TestVisible public String UTTIME { get; private set; }
		@TestVisible public String id { get; private set; }
	}
	
	global class UtPeerDataLatest 
	{
	    public String status { get; private set; }
	    public List<UtPeerDataLatestResult> result { get; private set; }
	}
	
	public class UtPeerDataLatestResult
	{
		public Long NUM_PEERS_ONLINE { get; set; }
		public Decimal AVG_RL_SYM_RATE { get; set; }
		public String id { get; set; }
	}
	

	/**
	 * This inner-class represents the structure for the JSON response of the phy/hist call
	 * NOTE: This structure must match the structure of the JSON response.
	 */
	global class UtPhyHistoryInternal {
		/**
		 * List of samples for the requested data
		 */
		public List<UtPhyStatusInternal> result { get; private set; }
		
		/**
		 * Status of the JSON response
		 */
		public String status { get; private set; }
		
		/**
		 * This constructor sets the status property and leaves the result null.
		 * It is used for certain statuses which a result is not included (ie. Access Denied).
		 *
		 * @param	status	The status received in the response from the SNG Tomcat Server
		 */
		public UtPhyHistoryInternal(String status)
		{
		   this.status = status;
		}
	}
	
	/**
	 * This inner-class represents the structure for the result
	 * field in the JSON response of the phy/hist call
	 * NOTE: This structure must match the structure of the JSON response.
	 */
	public class UtPhyStatusInternal {
		/**
		 * Time that the sample was taken
		 */
		public String  UTTIME { get; private set; }
		
		/**
		 * UT FL SINR (in dB) from the last received PMM. 0 if UT is offline.
		 */
		public Decimal UTFLSINR  { get; private set; }
		
		/**
		 * UT RL SINR (in dB) from the last received PMM. 0 if UT is offline.
		 */
		public Decimal UTRLSINR  { get; private set; }
		
		/**
		 * UT MAC address
		 */
		public String  UTSUMMARYMACADDR  { get; private set; }
		
		/**
		 * UT RL Symbol Rate in ksps. 0 if UT is offline.
		 */
		public Decimal UTRLSYMBOLRATE  { get; private set; }
		
		/**
		 * UT Online time.
		 */
		public String UTONLINETIME { get; private set; }
	}
	
	/**
	 * This inner-class represents the structure for the JSON response of the phy/latest call
	 * NOTE: This structure must match the structure of the JSON response.
	 */
	global class UtPhyLatest {
		/**
		 * Status of the JSON response
		 */
		public String status { get; private set; }
		
		/**
		 * List containing latest sample for the requested data
		 */
		public List<UtPhyLatestResult> result { get; private set; }
		
		/**
		 * This constructor instantiates a UtPhyLatest object with the provided status and result
		 *
		 * @param	status	Status of the JSON response
		 * @param	result	Structure containing the requested data
		 */
		public UtPhyLatest(SNGHttpUtilities.Status status, UtPhyLatestResult result) {
			this.status = status.name();
			this.result = new UtPhyLatestResult[] { result };
		}
	}
	
	/**
	 * This inner-class represents the structure for the result
	 * field in the JSON response of the phy/latest call
	 * NOTE: This structure must match the structure of the JSON response.
	 */
	public class UtPhyLatestResult {
		
		/**
		 * Number of peers online.
		 */
		public Long NUM_PEERS_ONLINE { get; set; }
		
		/**
		 * Peer average symbol rate.
		 */
		public Decimal PEER_AVG_SYMBOL_RATE { get; private set; }
		
		/**
		 * UT FL SINR (in dB) from the last received PMM. 0 if UT is offline.
		 */
		public Decimal UTFLSINR { get; private set; }
		
		/**
		 * Time when UT successfully completed network entry. All 0's if UT is offline.
		 * This field is representing time in the SNMP DateAndTime data type as defined in SNMPV2-TC.
		 */
		public String UTONLINETIME { get; private set; }
		
		/**
		 * UT RL Symbol Rate in ksps. 0 if UT is offline.
		 */
		public Decimal UTRLSYMBOLRATE { get; private set; }
		
		/**
		 * UT State.
		 * Possible values: <br>
		 * <table border="1">
         * <tr> <th>value</th>           <th>state</th>                                   </tr>
		 * <tr> <td align="right">0</td> <td align="right">off-line</td>                  </tr>
		 * <tr> <td align="right">1</td> <td align="right">ranging</td>                   </tr>
		 * <tr> <td align="right">2</td> <td align="right">authenticating</td>            </tr>
		 * <tr> <td align="right">3</td> <td align="right">registering</td>               </tr>
		 * <tr> <td align="right">4</td> <td align="right">transferring-op-params</td>    </tr>
		 * <tr> <td align="right">5</td> <td align="right">on-line</td>                   </tr>
		 * <tr> <td align="right">6</td> <td align="right">handover</td>                  </tr>
		 * <tr> <td align="right">7</td> <td align="right">symbol-rate-discovery</td>     </tr>
		 * <tr> <td align="right">8</td> <td align="right">capabilities-negotiation</td>  </tr>
		 * </table>
		 */
		public Integer UTSTATE { get; private set; }
		
		/**
		 * UT MAC address
		 */
		public String UTSUMMARYMACADDR { get; private set; }
		
		/**
		 * This constructor instantiates a UtPhyLatestResult object with all required data
		 *
		 * @param	macAddress	UT MAC address
		 * @param	rlSymRate 	UT RL Symbol Rate in ksps. 0 if UT is offline.
		 * @param	flSinr    	UT FL SINR (in dB) from the last received PMM. 0 if UT is offline.
		 * @param	swVersion 	UT Software Version
		 * @param	state     	UT State
		 * @param	ipAddress 	Terminal IP Address
		 * @param	onlineTime	Seconds the terminal has been online
		 */
        public UtPhyLatestResult(Decimal utFlSinr, String utOnlineTime, 
                                 Decimal utRlSymbolRate, UTState utState, 
                                 String utMacAddr) {
        	this.UTFLSINR = utFlSinr;
        	this.UTONLINETIME = utOnlineTime;
        	this.UTRLSYMBOLRATE = utRlSymbolRate;
        	this.UTSTATE = utState.ordinal();
			this.UTSUMMARYMACADDR = utMacAddr;
		}
	}
	
	/**
	 * This inner-class represents the structure used for representing the data 
	 * retrieved from the phy/hist call. It is used in both the Salesforce page,
	 * as well as the Salesforce REST endpoint.
	 * NOTE: The Salesforce REST endpoint serializes this structure, so it must match
	 *       what our API should send back as the response.
	 */
	global class UtPhyHistory
	{
		/**
		 * List of samples for the requested data
		 */
		public UtPhyHistoryResult result  { get; private set; }
		
		/**
		 * Status of the JSON response
		 */
		public String status  { get; private set; }
		
		/**
		 * This constructor initializes the object with a provided status,
		 * and empty result.
		 *
		 * @param	status	The status to set
		 */
		public UtPhyHistory(SNGHttpUtilities.Status status)
		{
			result = new UtPhyHistoryResult();
			this.status = status.name();
		}
		
		/**
		 * This constructor initializes the object using the internal 
		 * structure received in the response from the SNG Tomcat Server.
		 *
		 * @param	utPhyHistory	Deserialized response from the SNG Tomcat server
		 */
		public UtPhyHistory(UtPhyHistoryInternal utPhyHistory)
		{
			status = utPhyHistory.status;
			result = new UtPhyHistoryResult(utPhyHistory.result);
		}
	}
	
	/**
	 * This inner-class represents the structure for the result field in the JSON
	 * response of the phy/hist call. It is used in both the Salesforce page,
	 * as well as the Salesforce REST endpoint. It contains the UT MAC Address
	 * and a list containing the requested data samples.
	 * NOTE: The Salesforce REST endpoint serializes this structure, so it must match
	 *       what our API should send back as the response.
	 */
	public class UtPhyHistoryResult
	{
		/**
		 * UT MAC Address
		 */
		public String MAC_ADDRESS  { get; set; }
		
		/**
		 * List of samples for the requested data
		 */
		public List<UtPhyStatus> history  { get; private set; }
		
		/**
		 * This default constructor initializes the history property as an empty list.
		 */
		public UtPhyHistoryResult()
		{
			this.history = new List<UtPhyStatus>();
		}
		
		/**
		 * This constructor translates from the List<UtPhyStatusInternal> containing
		 * data received from the SNG Tomcat Server to the UtPhyHistoryResult structure.
		 */
		public UtPhyHistoryResult(List<UtPhyStatusInternal> utPhyStatus)
		{
			history = new List<UtPhyStatus>();
			if (utPhyStatus.size() > 0)
			{
				MAC_ADDRESS = utPhyStatus[0].UTSUMMARYMACADDR;	
				
				for (UtPhyStatusInternal u: utPhyStatus)
				{
					System.assert (u.UTSUMMARYMACADDR == MAC_ADDRESS, 'Query was not correctly setup. Check Salesforce or Web Service.');
					history.add( new UtPhyStatus(Long.valueof(u.UTTIME), u.UTFLSINR, u.UTRLSYMBOLRATE) );
				}
			}
		}
	}
	
	/**
	 * This inner-class represents the structure for the result.history field in the JSON
	 * response of the phy/hist call. It is used in both the Salesforce page,
	 * as well as the Salesforce REST endpoint. It represents a single sample of data.
	 * NOTE: The Salesforce REST endpoint serializes this structure, so it must match
	 *       what our API should send back as the response.
	 */
	public class UtPhyStatus
	{
		/**
		 * Time that the sample was taken
		 */
		public Long TIMESTAMP  { get; private set; }
		
		/**
		 * UT Forward Link SINR (in dB) from the last received PMM. 0 if UT is offline.
		 */
		public Decimal FORWARD_LINK_SINR  { get; private set; }
		
		/**
		 * UT Return Link Symbol Rate in ksps. 0 if UT is offline.
		 */
		public Decimal RETURN_LINK_SYMBOL_RATE  { get; private set; }
		
		/**
		 * This constructor creates an object initialized with the values passed in.
		 *
		 * @param	utTimeInSec 	Time that the sample was taken
		 * @param	flSinr      	UT Forward Link SINR (in dB) from the last received PMM.
		 *       	            	0 if UT is offline.
		 * @param	rlSymbolRate	UT Return Link Symbol Rate in ksps. 0 if UT is offline.
		 */
		public UtPhyStatus(Long utTimeInSec, Decimal flSinr, Decimal rlSymbolRate)
		{
			TIMESTAMP = utTimeInSec;
			FORWARD_LINK_SINR = flSinr;
			RETURN_LINK_SYMBOL_RATE = rlSymbolRate;
		}
	}
	
	/**
	 * This inner-class represents the structure for the JSON response of the /query/perf/status/list call
	 * NOTE: This structure must match the structure of the JSON response.
	 */
	global class UtPhyStatusList {
		/**
		 * List containing objects which contain status
		 * for the requested terminals
		 */
		public List<UtPhyStatusResult> result { get; private set; }
		
		/**
		 * Status of the JSON response
		 */
		public String status { get; private set; }
	}
	
	/**
	 * This inner-class represents the structure for a single item in the
	 * result field in the JSON response of the /query/perf/status/list call.
	 */
	global class UtPhyStatusResult {
		/**
		 * Time that the sample was taken
		 */
		public String UTTIME { get; private set; }
		
		/**
		 * UT MAC address
		 */
		public String UTSUMMARYMACADDR { get; private set; }
		
		/**
		 * UT State.
		 * Possible values: <br>
		 * <table border="1">
         * <tr> <th>value</th>           <th>state</th>                                   </tr>
		 * <tr> <td align="right">0</td> <td align="right">off-line</td>                  </tr>
		 * <tr> <td align="right">1</td> <td align="right">ranging</td>                   </tr>
		 * <tr> <td align="right">2</td> <td align="right">authenticating</td>            </tr>
		 * <tr> <td align="right">3</td> <td align="right">registering</td>               </tr>
		 * <tr> <td align="right">4</td> <td align="right">transferring-op-params</td>    </tr>
		 * <tr> <td align="right">5</td> <td align="right">on-line</td>                   </tr>
		 * <tr> <td align="right">6</td> <td align="right">handover</td>                  </tr>
		 * <tr> <td align="right">7</td> <td align="right">symbol-rate-discovery</td>     </tr>
		 * <tr> <td align="right">8</td> <td align="right">capabilities-negotiation</td>  </tr>
		 * </table>
		 */
		public Integer UTSTATE { get; private set; }
	}
	
	/**
	 * This inner-class represents the structure for the JSON response of the phy/usage call
	 * NOTE: This structure must match the structure of the JSON response.
	 */
	global class UtPhyUsageHistory {
		/**
		 * List containing objects which contain usage data with the
		 * associated time that the sample was taken
		 */
		public List<UtPhyUsageResult> result { get; private set; }
		
		/**
		 * Status of the JSON response
		 */
		public String status { get; private set; }
	}
	
	/**
	 * This inner-class represents the structure for the result field in the JSON
	 * response of the 
	 * /query/perf/phy/usage/history/FL_OR_RL/MACADDRESS_WITH_COLONS/START_DATE (YYYY-MM-DD)/END_DATE (YYYY-MM-DD)
	 * call.
	 */
	global class UtPhyUsageResult {
		/**
		 * Time that the sample was taken
		 */
		@TestVisible 
		public Long UTTIME { get; private set; }
		
		/**
		 * Time when UT successfully completed network entry. All 0's if UT is offline.
		 * This field is representing time in the SNMP DateAndTime data type as defined in SNMPV2-TC.
		 */
		@TestVisible 
		public String UTONLINETIME { get; private set; }
		
		/**
         * The usage data. This is the Forward-Link Byte count.
         */
        @TestVisible 
        public Long UTFLBYTECOUNT { get; private set; }
		
		/**
		 * The usage data. This is the Return-Link Byte count.
		 */
		@TestVisible 
		public Long UTRLBYTECOUNT { get; private set; }
		
		/**
		 * The state of the UT at the specified point in time.
		 */
		@TestVisible 
		public Integer UTSTATE { get; private set; }
	}
	
	/**
	 * This inner-class represents the structure for the JSON response of the /query/perf/phy/version/MACADDR call
	 * NOTE: This structure must match the structure of the JSON response.
	 */
	global class UtPhyVersion {
		/**
		 * List containing a single object containing version data for
		 * the requested modem
		 */
		public List<UtPhyVersionResult> result { get; private set; }
		
		/**
		 * Status of the JSON response
		 */
		public String status { get; private set; }
		
		/**
		 * Creates an instance of this class.
		 */
		public UtPhyVersion()
		{
			result = new List<UtPhyVersionResult>();
			status = SNGHttpUtilities.Status.ZERO_RESULTS.name();
		}
		
		public UtPhyVersion(SNGHttpUtilities.Status statusValue)
		{
            result = new List<UtPhyVersionResult>();
            status = statusValue.name();			
		}

	}
	
	/**
	 * This inner-class represents the structure for the result field in the JSON
	 * response of the /query/perf/phy/version/MACADDR call.
	 */
	global class UtPhyVersionResult {
		/**
		 * UT MAC address
		 */
		public String MACADDR { get; private set; }
		
		/**
		 * UT System Software Version
		 */
		public String SOFTWAREVERSION { get; private set; }
	}
	
	/**
	 * Generate a UtPhyStatusList to be used in parsing when the HTTP
	 * callout fails. This is used for handling errors.
	 *
	 * @param 	macAddrs	The list of MAC addresses which status was requested for
	 * @return	        	The UtPhyStatusList object
	 */
	public static UtPhyStatusList generateFailedUtPhyStatusList(String[] macAddrs) {
		UtPhyStatusList statusList = new UtPhyStatusList();
    	
    	statusList.status = SNGHttpUtilities.Status.OK.name();
    	statusList.result = new List<UtPhyStatusResult>();
    	
    	for (String macAddr : macAddrs) {
    		statusList.result.add(generateFailedUtPhyStatusResult(macAddr));
    	}
    	
    	return statusList;
	}
	
	/**
	 * Generate a UtPhyStatusResult to be used in parsing when the HTTP
	 * callout fails. This is used for handling errors.
	 *
	 * @param 	macAddr	A MAC address which status was requested for
	 * @return	        The UtPhyStatusResult object
	 */
	public static UtPhyStatusResult generateFailedUtPhyStatusResult(String macAddr) {
		UtPhyStatusResult utStatus = new UtPhyStatusResult();
		
		if (null != macAddr) {
			utStatus.UTSUMMARYMACADDR = SNGHttpUtilities.translateMacAddressFromSfToDbFormat(macAddr);
		}
		
		utStatus.UTSTATE = UTState.off_line.ordinal();
		utStatus.UTTIME = '0';
		return utStatus;
	}
}