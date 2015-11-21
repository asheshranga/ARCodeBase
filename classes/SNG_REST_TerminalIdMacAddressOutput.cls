public with sharing class SNG_REST_TerminalIdMacAddressOutput implements SNG_REST_IJsonResponseData {
	
	/**
	 * The terminal ID
	 */ 
	public String terminalId;
	
	/**
	 * The mac address 
	 */  
	public String macAddress; 
	
	/**
	 * Constructor 
	 */ 
	public SNG_REST_TerminalIdMacAddressOutput(String terminalId, String macAddress) { 
		this.terminalId = terminalId; 
		this.macAddress = macAddress; 
	}
	
	/**
	 * Comparison of SNG_REST_TerminalIdMacAddressOutput
	 * 
	 * @param 	obj 			An object that is being compared to SNG_REST_TerminalIdMacAddressOutput
	 * @return 					true if object is equal to this instance of SNG_REST_TerminalIdMacAddressOutput
	 * 							false otherwise
	 */ 
	public boolean equals(final Object obj) { 
		
		if (this === obj) return true;
		// obj not an instance of SNG_REST_TerminalIdMacAddressOutput
        if (obj == null || !(obj instanceof SNG_REST_TerminalIdMacAddressOutput)) return false;
		
		// obj is instance of SNG_REST_TerminalIdMacAddressOutput
		SNG_REST_TerminalIdMacAddressOutput other = (SNG_REST_TerminalIdMacAddressOutput) obj; 
        return ((this.terminalId == other.terminalId) && (this.macAddress == other.macAddress));
	}
	
	/** 
	 * Returns hash code of the object 
	 * 
	 * @return 			Hash code of the object 
	 */ 
	public Integer hashCode() { 
		return ((31*terminalId.hashCode())^macAddress.hashCode()); 
	}
}