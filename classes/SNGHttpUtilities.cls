/**
 * This class contains static methods which can be used to perform
 * common functions involving HTTP requests/results.
 */
public with sharing class SNGHttpUtilities {

    /**
     * This inner-class contains integer constants for HTTP status codes
     */
    public class StatusCode {
        /**
         * HTTP Status 200 - OK
         */
        public final Integer OK         = 200;
        
        /**
         * HTTP Status 302 - FOUND (Redirect)
         */
        public final Integer FOUND      = 302;
        
        /**
         * HTTP Status 404 - NOT FOUND
         */
        public final Integer NOT_FOUND  = 404;
    }

    /**
     * Accessor for fields inside the inner-class StatusCode
     */
    public static final transient SNGHttpUtilities.StatusCode STATUS_CODE = new SNGHttpUtilities.StatusCode();
    
    /**
     * Contains an enumeration of the various status values that may be
     * returned to the client when performing RESTful API calls in the "status" JSON field.
     * <br/>
     * The possible enumeration values are as follows:
     * <br /><br />
     * OK: The call was successful and contains results
     * <br />
     * ZERO_RESULTS: The call was successful, but there are no results.
     * <br />
     * ACCESS_DENIED: The client is not authorized to make this call.
     * <br />
     * SERVER_ERROR: An error occurred preventing the server from getting
     *               the result. The call may be successful if tried again
     *               at a later time.
     */
    public enum Status
    {
        OK,
        ZERO_RESULTS,
        ACCESS_DENIED,
        SERVER_ERROR,
        INPUT_VALIDATION_ERROR,
        OK_WITH_ERRORS
    }

    /**
     * The Custom Setting storing the SNG Tomcat Server details.
     */
    public static final transient SNGWebService__c TOMCAT_SERVER = SNGWebService__c.getValues(Label.SNGTomcatServer);
    
    /**
	 * The Custom Setting storing the login details for the OpenAM instance
	 */
	public static final transient SNGWebService__c OPENAM_LOGIN = SNGWebService__c.getValues(Label.SNGOpenAMLogin);
	
	/**
	 * Converts a Date String in the user's locale format to a String in 
	 * the format used in HTTP requests/responses.
	 *
	 * @param   dateStr                 The Date String to be formatted.
	 * @return                          The date String in YYYY-MM-DD format
	 * @throws  SNG_Exception           If the provided String is not a valid date object
	 */
	public static String formatDate(String dateStr)
	{
		try {
			return formatDate(Date.parse(dateStr));
		} catch (TypeException e) {
			throw new SNG_Exception(e);
		}
	}
	
	/**
	 * Converts a Date object to a String in the format used in HTTP requests/responses.
	 *
	 * @param   dateObj       The Date object to be formatted.
	 * @return                The date string in YYYY-MM-DD format
	 */
	public static String formatDate(Date dateObj)
	{
		return dateObj.year() + '-' + dateObj.month() + '-' + dateObj.day();
	}
	
	/**
     * Validates whether the status code from the HTTP request is set to HTTP
     * status value of 200 (OK).
     *
     * @param   statusCode  The HTTP status obtained from the HTTP request
     * @return              Whether the HTTP status indicates 200 (OK) or not.
     */
    public static boolean isStatusCodeOK(integer statusCode)
    {
        return (SNGHttpUtilities.STATUS_CODE.OK == statusCode);
    }

    /**
     * Translates the max address from a 0x000000000000 to a 00:00:00:00:00:00 format in lowercase.
     *
     * @param   macAddressHexNum       The MAC address in a hexadecimal format.
     * @return                         The modem MAC address in a 00:00:00:00:00:00 format in lowercase.
     */
    public static String translateMacAddressFromDbToSfFormat(String macAddressHexNum) {
    	// cut out the 0x at the beginning
    	macAddressHexNum = macAddressHexNum.substring(macAddressHexNum.indexOf('x')+1);
    	
    	String convertedMacAddress;
    	final integer MAC_ADDRESS_LENGTH = 12;
    	
    	if (MAC_ADDRESS_LENGTH == macAddressHexNum.length())
    	{
    		// construct the mac address in 11:22:33:44:55:66 format
    		convertedMacAddress = macAddressHexNum.substring(0, 2) + ':'
                                + macAddressHexNum.substring(2, 4) + ':'
                                + macAddressHexNum.substring(4, 6) + ':'
                                + macAddressHexNum.substring(6, 8) + ':'
                                + macAddressHexNum.substring(8, 10) + ':'
                                + macAddressHexNum.substring(10, 12);
    	}
    	else
    	{
    		throw new SNG_Exception ('Not a proper MAC Address in hex: ' + macAddressHexNum);
    	}
    	
    	return convertedMacAddress.toLowerCase();
    }
    
    /**
     * Translates the max address from a 00:00:00:00:00:00 to a 0x000000000000 format.
     *
     * @param   macAddress             The modem MAC address in a 00:00:00:00:00:00 format.
     * @return                         The MAC address in a hexadecimal format.
     */
    public static String translateMacAddressFromSfToDbFormat(String macAddress) {
    	return '0x' + macAddress.replaceAll(':', '');
    }
}