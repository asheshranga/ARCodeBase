/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an organization are executed whenever Apex code is deployed
 * to a production organization to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production organization. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the organization size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
public with sharing class IntegerUtil {
    public static String convertToHex(integer dataToConvert, integer numberOfOctets)
    {
    	integer intData = dataToConvert;
    	integer divideFactor = 16;
    	String result= '';
    	String[] hexArray = new String[]{'0', '1', '2', '3', '4', '5', '6', '7', '8', '9', 'a', 'b', 'c', 'd', 'e', 'f'};
    	
    	while (intData != 0)
    	{
    	   	 integer remainder = Math.mod(intData, divideFactor);
    	     result += hexArray[remainder];
    	     intData = intData / divideFactor;
    	}
    	
    	result = padZeroes(result, (2 * numberOfOctets - result.length()));
    	return StringUtils.reverse(result).substring(0, numberOfOctets * 2);
    }
    
    private static String padZeroes(String original, integer padAmount)
    {
    	String result = original;
    	for (integer i = 0; i < padAmount; ++i)
            result += '0';         
        return result;
    }
}