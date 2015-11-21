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
private class ISODateAndTimeConverterUnitTest {

    static testMethod void testFormatDate() {  
        System.assertEquals('2014-02-01', ISODateAndTimeConverter.formatDate(Date.newInstance(2014, 2, 1)));
        System.assertEquals('2015-12-23', ISODateAndTimeConverter.formatDate(Date.newInstance(2015, 12, 23)));
        System.assertEquals('1987-05-17', ISODateAndTimeConverter.formatDate(Date.newInstance(1987, 5, 17)));   
    }
    
    static testMethod void testFormatDateTime() 
    {
    	   /* Year-Month-Day ISO Date format */
        String ISO_DATE_FORMAT = 'yyyy-MM-dd';
        String ISO_DATE_TIME_FORMAT = ISO_DATE_FORMAT + '\'T\'HH:mm:ssXXX';
   
        DateTime dt1 = DateTime.newInstance(2014, 2, 1, 0, 0, 0);
        System.assertEquals(dt1.format(ISO_DATE_TIME_FORMAT), ISODateAndTimeConverter.formatDateTime(dt1));
        System.assertNotEquals(dt1.formatGmt(ISO_DATE_TIME_FORMAT), ISODateAndTimeConverter.formatDateTime(dt1));
        
        DateTime dt2 = DateTime.newInstance(2015, 12, 23, 23, 14, 6);
        System.assertEquals(dt2.format(ISO_DATE_TIME_FORMAT), ISODateAndTimeConverter.formatDateTime(dt2));        
        System.assertNotEquals(dt2.formatGmt(ISO_DATE_TIME_FORMAT), ISODateAndTimeConverter.formatDateTime(dt2));
        
        DateTime dt3 = DateTime.newInstance(2015, 5, 17, 8, 19, 27);
        System.assertEquals(dt3.format(ISO_DATE_TIME_FORMAT), ISODateAndTimeConverter.formatDateTime(dt3));     
        System.assertNotEquals(dt3.formatGmt(ISO_DATE_TIME_FORMAT), ISODateAndTimeConverter.formatDateTime(dt3));
    }
    
        
    static testMethod void testFormatDateTimeGmt() 
    {
           /* Year-Month-Day ISO Date format */
        String ISO_DATE_FORMAT = 'yyyy-MM-dd';
        String ISO_DATE_TIME_FORMAT = ISO_DATE_FORMAT + '\'T\'HH:mm:ssXXX';
   
        DateTime dt1 = DateTime.newInstance(2014, 2, 1, 0, 0, 0);
        System.assertEquals(dt1.formatGmt(ISO_DATE_TIME_FORMAT), ISODateAndTimeConverter.formatDateTimeGmt(dt1));
        System.assertNotEquals(dt1.format(ISO_DATE_TIME_FORMAT), ISODateAndTimeConverter.formatDateTimeGmt(dt1));
        
        DateTime dt2 = DateTime.newInstance(2015, 12, 23, 23, 14, 6);
        System.assertEquals(dt2.formatGmt(ISO_DATE_TIME_FORMAT), ISODateAndTimeConverter.formatDateTimeGmt(dt2));        
        System.assertNotEquals(dt2.format(ISO_DATE_TIME_FORMAT), ISODateAndTimeConverter.formatDateTimeGmt(dt2));
        
        DateTime dt3 = DateTime.newInstance(2015, 5, 17, 8, 19, 27);
        System.assertEquals(dt3.formatGmt(ISO_DATE_TIME_FORMAT), ISODateAndTimeConverter.formatDateTimeGmt(dt3));   
        System.assertNotEquals(dt3.format(ISO_DATE_TIME_FORMAT), ISODateAndTimeConverter.formatDateTimeGmt(dt3));  
    }
    
    static testMethod void testFormatDurationExceptionCases()
    {
    	try
    	{
    		ISODateAndTimeConverter.formatDuration(null);
    	}
    	catch (ISODateAndTimeConverter.ISODateAndTimeException e)
    	{
    		System.assert(true);
    	}
    	catch (Exception e)
    	{
    		System.assert(false);
    	}
    	
    	try
        {
            ISODateAndTimeConverter.formatDuration(-1);
        }
        catch (ISODateAndTimeConverter.ISODateAndTimeException e)
        {
            System.assert(true);
        }
        catch (Exception e)
        {
            System.assert(false);
        }
    }
    
    static testMethod void testFormatDuration()
    {
    	// use this webpage: http://www.ostyn.com/standards/scorm/samples/ISOTimeForSCORM.htm for conversions
    	// uses ISO-precise 	
    	System.assertEquals('PT0H0M0S', ISODateAndTimeConverter.formatDuration(0));
    	System.assertEquals('P1428DT21H33M9S', ISODateAndTimeConverter.formatDuration(123456789));
    	System.assertEquals('P18DT1H40M38S', ISODateAndTimeConverter.formatDuration(1561238));
    }
}