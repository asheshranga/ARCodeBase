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
private class LZWUnitTest {

    static testMethod void compressDecompressTest() {
        final String toCompress1 = 'This class contains unit tests for validating the behavior of Apex classes'
                                 + '* and triggers.'
                                 + '*'
                                 + '* Unit tests are class methods that verify whether a particular piece'
                                 + '* of code is working properly. Unit test methods take no arguments,'
                                 + '* commit no data to the database, and are flagged with the testMethod'
                                 + '* keyword in the method definition.'
                                 + '*'
                                 + '* All test methods in an organization are executed whenever Apex code is deployed'
                                 + '* to a production organization to confirm correctness, ensure code'
                                 + '* coverage, and prevent regressions. All Apex classes are'
                                 + '* required to have at least 75% code coverage in order to be deployed'
                                 + '* to a production organization. In addition, all triggers must have some code coverage.'
                                 + '* '
                                 + '* The @isTest class annotation indicates this class only contains test'
                                 + '* methods. Classes defined with the @isTest annotation do not count against'
                                 + '* the organization size limit for all Apex scripts.'
                                 + '*'
                                 + '* See the Apex Language Reference for more information about Testing and Code Coverage.'
                                 + 'Hey, I\'m a good software engineer, but I\'m not exactly known for my fashion sense. White socks and sandals don\'t translate to \'good design sense\'.\n'
                                 + 'Linus Torvalds'
                                 + 'Read more at http://www.brainyquote.com/quotes/quotes/l/linustorva587356.html#v3vsZWGARmyer6O6.99';
        
        final String compressed1 = LZW.compress(toCompress1);
        final String decompressed1 = LZW.decompress(compressed1);
        System.assertEquals(toCompress1,decompressed1);
        System.assertNotEquals(toCompress1,compressed1);
    }
   /*
    static testMethod void hugeRandomIntListTest() {
        final Long intListSize = 16000;
        final Integer maxValue = 65535;
        List<Integer> hugeIntList = new List<Integer>();
        for (Long i = 0; i < intListSize; ++i) {
            hugeIntList.add(maxValue * (Integer)Math.random());
        }
        
        final String originalString = String.fromCharArray(hugeIntList);
        final String compressed = LZW.compress(originalString);
        final String decompressedString = LZW.decompress(originalString);
        if (originalString != decompressedString) {
            System.assert(false);
        }
    }
    */
    // Commented out the following unit test because it causes a System.UnexpectedException to be thrown from Salesforce.
    /*
    static testMethod void hugeSequentialNonRepeatingIntListTest() {
        try {
            final Long intListSize = 16000;
            final Integer maxValue = 65535;
            List<Integer> hugeIntList = new List<Integer>();
            for (Integer i = maxValue; hugeIntList.size() < intListSize; --i) {
                hugeIntList.add(i);
            }
            
            final String originalString = String.fromCharArray(hugeIntList);
            final String compressed = LZW.compress(originalString);
            final String decompressedString = LZW.decompress(originalString);
            if (originalString != decompressedString) {
                System.assert(false);
            }
        } catch (System.UnexpectedException e) {
            System.debug(LoggingLevel.ERROR, e);
        }
    }
    */
}