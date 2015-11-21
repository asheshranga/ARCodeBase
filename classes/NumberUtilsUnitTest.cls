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
private class NumberUtilsUnitTest {

    private static testmethod void testMaxIntegerValue(){
        System.assert(NumberUtils.MAX_INTEGER == 2147483647);
    }
    private static testmethod void testlgerValue(){
        System.assert(NumberUtils.MIN_INTEGER == -2147483647);
    }
    
    private static testmethod void testParseIntBadRadix(){
        //test: global static Integer parseInt(String str, Integer radix){
        Boolean exceptionCaught = false;
        try{
            NumberUtils.parseInt('01',1);    
        }catch(IllegalArgumentException e){
            exceptionCaught = true;
        }
        System.assert(exceptionCaught,'NumberUtils.parseInt(\'01\',1) did not throw IllegalArgumentException'); 
        exceptionCaught = false;
        try{
            NumberUtils.parseInt('01',37);    
        }catch(IllegalArgumentException e){
            exceptionCaught = true;
        }
        System.assert(exceptionCaught,'NumberUtils.parseInt(\'01\',37) did not throw IllegalArgumentException'); 
    }
    
    private static testmethod void testParseIntEmptyNumber(){
        //test: global static Integer parseInt(String str, Integer radix){
        Boolean exceptionCaught = false;
        try{
            NumberUtils.parseInt(null,2);    
        }catch(NumberFormatException e){
            exceptionCaught = true;
        }
        System.assert(exceptionCaught,'NumberUtils.parseInt(null,2) did not throw NumberFormatException'); 
        exceptionCaught = false;
        try{
            NumberUtils.parseInt('  ',2);    
        }catch(NumberFormatException e){
            exceptionCaught = true;
        }
        System.assert(exceptionCaught,'NumberUtils.parseInt(\'  \',2) did not throw NumberFormatException'); 
    }
    
    private static testmethod void testParseIntInvalidNumber(){
        //test: global static Integer parseInt(String str, Integer radix){
        for(Integer i = 2; i < 37; i++){
            assertParseIntNumberFormatException(
                '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ$'.substring(0,i+1)
                ,i);
        }        
    }

    private static void assertParseIntNumberFormatException(String str, Integer radix){
        Boolean exceptionCaught = false;
        try{
            NumberUtils.parseInt(str,radix);    
        }catch(NumberFormatException e){
            exceptionCaught = true;
        }
        System.assert(exceptionCaught,'NumberUtils.parseInt(\'' + str + '\',' + radix + ') did not throw NumberFormatException'); 
    }
    
    private static testmethod void testParseIntBase2(){
        //test: global static Integer parseInt(String str, Integer radix){
        assertParseInt('0',2,0);
        assertParseInt('00',2,0);
        assertParseInt('1',2,1);
        assertParseInt('10',2,2);
        assertParseInt('11',2,3);
        assertParseInt('100',2,4);
    }
    
    private static testmethod void testParseIntBase10(){
        //test: global static Integer parseInt(String str, Integer radix){
        assertParseInt('0',10,0);
        assertParseInt('-0',10,0);
        assertParseInt('473',10,473);
    }
    
    private static testmethod void testParseIntOtherBases(){
        //test: global static Integer parseInt(String str, Integer radix){
        assertParseInt('1100110',2,102);
        assertParseInt('-FF',16,-255);
        assertParseInt('12',8,10);
        assertParseInt('az',36,395);
     }
    
    private static void assertParseInt(String str, Integer radix, Integer expected){
        Integer actual = NumberUtils.parseInt(str,radix);
        System.assert(actual==expected, 'NumberUtils.parseInt(\'' + str + '\',' + radix + ') returned ' 
            + actual + '; expected ' + expected + '');
    }
    
    private static testmethod void testIntegerToHex(){
        //test: global static String toHexString(Integer i){
        assertIntegerToHex(-2147483647,'-7FFFFFFF');
        assertIntegerToHex(-2147483646,'-7FFFFFFE');
        assertIntegerToHex(-19,'-13');
        assertIntegerToHex(-18,'-12');
        assertIntegerToHex(-17,'-11');
        assertIntegerToHex(-16,'-10');
        assertIntegerToHex(-15,'-F');
        assertIntegerToHex(-14,'-E');
        assertIntegerToHex(-13,'-D');
        assertIntegerToHex(-12,'-C');
        assertIntegerToHex(-11,'-B');
        assertIntegerToHex(-10,'-A');
        assertIntegerToHex(-9,'-9');
        assertIntegerToHex(-8,'-8');
        assertIntegerToHex(-7,'-7');
        assertIntegerToHex(-6,'-6');
        assertIntegerToHex(-5,'-5');
        assertIntegerToHex(-4,'-4');
        assertIntegerToHex(-3,'-3');
        assertIntegerToHex(-2,'-2');
        assertIntegerToHex(-1,'-1');
        assertIntegerToHex(0,'0');
        assertIntegerToHex(1,'1');
        assertIntegerToHex(2,'2');
        assertIntegerToHex(3,'3');
        assertIntegerToHex(4,'4');
        assertIntegerToHex(5,'5');
        assertIntegerToHex(6,'6');
        assertIntegerToHex(7,'7');
        assertIntegerToHex(8,'8');
        assertIntegerToHex(9,'9');
        assertIntegerToHex(10,'A');
        assertIntegerToHex(11,'B');
        assertIntegerToHex(12,'C');
        assertIntegerToHex(13,'D');
        assertIntegerToHex(14,'E');
        assertIntegerToHex(15,'F');
        assertIntegerToHex(16,'10');
        assertIntegerToHex(17,'11');
        assertIntegerToHex(2147483646,'7FFFFFFE');
        assertIntegerToHex(2147483647,'7FFFFFFF');
         
    }
    
    private static void assertIntegerToHex(Integer i, String expected){
        String actual = NumberUtils.toHexString(i);
        System.assert(actual==expected, 'NumberUtils.toHex(' + i + ') returned \'' 
            + actual + '\'; expected \'' + expected + '\'');
    }
    
    private static testmethod void testIntegerToStringNullInput(){
        //test: global static String toString(Integer i, Integer radix){
        Integer i = null;
        System.assertEquals(null,NumberUtils.toString(i,2));
    }
    
    private static testmethod void testIntegerToStringBadRadix(){
        //test: global static String toString(Integer i, Integer radix){
        Boolean exceptionCaught = false;
        try{
            NumberUtils.toString(0,1);    
        }catch(IllegalArgumentException e){
            exceptionCaught = true;
        }
        System.assert(exceptionCaught,'NumberUtils.toString(null,1) did not throw IllegalArgumentException'); 
        exceptionCaught = false;
        try{
            NumberUtils.toString(0,37);    
        }catch(IllegalArgumentException e){
            exceptionCaught = true;
        }
        System.assert(exceptionCaught,'NumberUtils.toString(null,1) did not throw IllegalArgumentException'); 
    }
    
    private static testmethod void testLongToHex(){
        //test: global static String toHexString(Long l){
        assertLongToHex(-9223372036854775807L,'-7FFFFFFFFFFFFFFF');
        assertLongToHex(-9223372036854775806L,'-7FFFFFFFFFFFFFFE');
        assertLongToHex(-19L,'-13');
        assertLongToHex(-18L,'-12');
        assertLongToHex(-17L,'-11');
        assertLongToHex(-16L,'-10');
        assertLongToHex(-15L,'-F');
        assertLongToHex(-14L,'-E');
        assertLongToHex(-13L,'-D');
        assertLongToHex(-12L,'-C');
        assertLongToHex(-11L,'-B');
        assertLongToHex(-10L,'-A');
        assertLongToHex(-9L,'-9');
        assertLongToHex(-8L,'-8');
        assertLongToHex(-7L,'-7');
        assertLongToHex(-6L,'-6');
        assertLongToHex(-5L,'-5');
        assertLongToHex(-4L,'-4');
        assertLongToHex(-3L,'-3');
        assertLongToHex(-2L,'-2');
        assertLongToHex(-1L,'-1');
        assertLongToHex(0L,'0');
        assertLongToHex(1L,'1');
        assertLongToHex(2L,'2');
        assertLongToHex(3L,'3');
        assertLongToHex(4L,'4');
        assertLongToHex(5L,'5');
        assertLongToHex(6L,'6');
        assertLongToHex(7L,'7');
        assertLongToHex(8L,'8');
        assertLongToHex(9L,'9');
        assertLongToHex(10L,'A');
        assertLongToHex(11L,'B');
        assertLongToHex(12L,'C');
        assertLongToHex(13L,'D');
        assertLongToHex(14L,'E');
        assertLongToHex(15L,'F');
        assertLongToHex(16L,'10');
        assertLongToHex(17L,'11');
        assertLongToHex(9223372036854775806L,'7FFFFFFFFFFFFFFE');
        assertLongToHex(9223372036854775807L,'7FFFFFFFFFFFFFFF');
         
    }
    
    private static void assertLongToHex(Long l, String expected){
        String actual = NumberUtils.toHexString(l);
        System.assert(actual==expected, 'NumberUtils.toHex(' + l + ') returned \'' 
            + actual + '\'; expected \'' + expected + '\'');
    }
      
    private static testmethod void testLongToStringNullInput(){
        //test: global static String toString(Long l, Long radix){
        Long l = null;
        System.assertEquals(null,NumberUtils.toString(l,2));
    }
    
    private static testmethod void testLongToStringBadRadix(){
        //test: global static String toString(Long l, Integer radix){
        Boolean exceptionCaught = false;
        try{
            NumberUtils.toString(0L,1);    
        }catch(IllegalArgumentException e){
            exceptionCaught = true;
        }
        System.assert(exceptionCaught,'NumberUtils.toString(null,1) did not throw IllegalArgumentException'); 
        exceptionCaught = false;
        try{
            NumberUtils.toString(0L,37);    
        }catch(IllegalArgumentException e){
            exceptionCaught = true;
        }
        System.assert(exceptionCaught,'NumberUtils.toString(null,1) did not throw IllegalArgumentException'); 
    }
}