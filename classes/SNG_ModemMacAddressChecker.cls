public with sharing class SNG_ModemMacAddressChecker implements SNG_IValidator {

	public static final String INVALID_MAC_ADDRESS = 'Invalid MAC address format.';

	private static final String MAC_ADDR_REGEX = '^(([0-9A-Fa-f]{2}:){5}([0-9A-Fa-f]{2})|([0-9A-Fa-f]{2}%3A){5}([0-9A-Fa-f]{2})|([0-9A-Fa-f]{12}))$';

	public boolean validate(SNG_REST_StatusDetail details, String macAddress) { 
		
		if (!isValidFormat(macAddress))
		{	
			// MAC address has invalid format, set status details 
			details.message = INVALID_MAC_ADDRESS;
			details.status = SNGHttpUtilities.Status.INPUT_VALIDATION_ERROR;
			details.code = SNG_REST_Error.SubCode.SALESFORCE_GENERATED_ERROR;
			return false; 
		}
		
		// MAC address has valid format
		return true;
	}


	public boolean isValidFormat(String macAddress) { 
    	
    	boolean result = (null != macAddress);
    	
    	if (result)
    	{
    	   Pattern macAddressPattern = Pattern.compile(MAC_ADDR_REGEX);
    	   Matcher macAddressMatcher = macAddressPattern.matcher(macAddress);
    	   result = macAddressMatcher.matches();
    	}
    	
        return result;
	}
}