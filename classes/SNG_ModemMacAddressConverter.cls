/**
 * Converts MAC addresses of different formats: 
 * 1) 00%3Aa0%3Abc%3A26%3A42%3A7a (with colons that are URL encoded)
 * 2) 00a0bcXXXXXX (no colons)
 *
 * to Salesforce format: 00:a0:bc:XX:XX:XX (with colons, not URL-encoded). 
 *
 * Note: The case (upper/lower) is not converted from the original input. This is
 * because Salesforce is case-insensitive. 
 */
public with sharing class SNG_ModemMacAddressConverter implements SNG_IConverter {

    /**
     * The length of a MAC address without colons.
     */
	private static final integer MAC_ADDRESS_LENGTH_WITHOUT_COLONS = 12;

   /**
    * The expected UTF format when decoding the URL.
    */
	private static final String UTF_8_FORMAT = 'UTF-8';

	public SNG_ModemMacAddressConverter() {
	
	}

	/**
	 * Convert a MAC address to 00:a0:bc:XX:XX:XX format
	 * 
	 * @param 	parameter 	The MAC address to convert
	 * @return				The MAC address in 00:a0:bc:XX:XX:XX format
	 */
	public String convert(String parameter)
	{
		// Verify MAC address is valid format 
		SNG_ExceptionUtil.assert(new SNG_ModemMacAddressChecker().isValidFormat(parameter), 'Invalid MAC address format.');
		
		// Decode URL encoded characters
		String urlDecoded = EncodingUtil.urlDecode(parameter, UTF_8_FORMAT);

		// If decoded MAC address does not have colons, add colons
		return (MAC_ADDRESS_LENGTH_WITHOUT_COLONS == urlDecoded.length()) ? urlDecoded.replaceAll('..(?!$)', '$0:') : 
																			 urlDecoded;
	}

	/**
	 * Convert a list of MAC address to 00:a0:bc:XX:XX:XX format
	 * 
	 * @param 	parameters	List of MAC addresses to convert
	 * @return				List of MAC addresses in 00:a0:bc:XX:XX:XX format
	 */
	public List<String> convert(List<String> parameters)
	{
		List<String> results = new List<String>();

		for (String parameter: parameters)
		{
			results.add(convert(parameter));
		}	

		return results;
	}
}