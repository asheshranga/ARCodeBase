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
@isTest
private class SfIdCheckerUnitTest {

    static testMethod void testIsValidFormatNullId() 
    {    
    	String prefix = '[Ss][Pp][-]';
        SfIdChecker idChecker = new SfIdChecker(prefix);
        System.assertEquals(false, idChecker.isValidFormat(null)); 
        
        prefix = '[Tt][-]';
        idChecker = new SfIdChecker(prefix);
        System.assertEquals(false, idChecker.isValidFormat(null));  
    }
    
    
    static testMethod void testIsValidFormatInvalidIntegerAfterPrefix()
    {
    	String prefix = '[Ss][Pp][-]';
        SfIdChecker idChecker = new SfIdChecker(prefix);
        System.assertEquals(false, idChecker.isValidFormat('SP-notAnInteger'));
        
        prefix = '[Tt][-]';
        idChecker = new SfIdChecker(prefix);
        System.assertEquals(false, idChecker.isValidFormat('T-notAnIntegerEither'));        
    }
    
    static testMethod void testIsValidFormatIntegerAfterPrefixSmallerThanFourDigits()
    {
        String prefix = '[Ss][Pp][-]';
        SfIdChecker idChecker = new SfIdChecker(prefix);
        System.assertEquals(false, idChecker.isValidFormat('SP-123'));
        
        prefix = '[Tt][-]';
        idChecker = new SfIdChecker(prefix);
        System.assertEquals(false, idChecker.isValidFormat('T-789'));        
    }
    
    static testMethod void testIsValidFormatIntegerStartsWithZeroYetGreaterThanFourDigits()
    {
        String prefix = '[Ss][Pp][-]';
        SfIdChecker idChecker = new SfIdChecker(prefix);
        System.assertEquals(false, idChecker.isValidFormat('SP-012345'));
        
        prefix = '[Tt][-]';
        idChecker = new SfIdChecker(prefix);
        System.assertEquals(false, idChecker.isValidFormat('T-07892'));        
    }
    
    static testMethod void testIsValidFormatSunnyDay()
    {
        String prefix = '[Ss][Pp][-]';
        SfIdChecker idChecker = new SfIdChecker(prefix);
        System.assertEquals(true, idChecker.isValidFormat('SP-1234'));
        
        prefix = '[Tt][-]';
        idChecker = new SfIdChecker(prefix);
        System.assertEquals(true, idChecker.isValidFormat('T-7892'));   
    }    
}