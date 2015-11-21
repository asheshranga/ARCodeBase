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
private class SNG_TerminalQueryUnitTest {

    //----------------------------------------------------------------------------------------------
    // Exception scenarios
    //----------------------------------------------------------------------------------------------
    private static Integer s_num = 1;

    static testMethod void testGetStatusTrafficLightInvalidId() {
    	try
    	{
    	    Id fakeTerminalId = getFakeId(Terminal__c.sObjectType);
            SNG_TerminalQuery.getStatusTrafficLight(fakeTerminalId);
            System.assert(false);
    	}
    	catch (SNG_Exception e)
    	{
    	    System.assert(true);
    	}
    	catch (Exception e)
    	{
    	    System.assert(false);
    	}
    }
    
    static testMethod void testGetPerformanceTrafficLightInvalidId() {
        try
        {
            Id fakeTerminalId = getFakeId(Terminal__c.sObjectType);
            SNG_TerminalQuery.getPerformanceTrafficLight(fakeTerminalId);
            System.assert(false);
        }
        catch (SNG_Exception e)
        {
            System.assert(true);
        }
        catch (Exception e)
        {
            System.assert(false);
        }
    }
    
    static testMethod void testGetPointingTrafficLightInvalidId() {
        try
        {
            Id fakeTerminalId = getFakeId(Terminal__c.sObjectType);
            SNG_TerminalQuery.getPointingTrafficLight(fakeTerminalId);
            System.assert(false);
        }
        catch (SNG_Exception e)
        {
            System.assert(true);
        }
        catch (Exception e)
        {
            System.assert(false);
        }
    }
    
    static testMethod void testGetNetworkTrafficLightInvalidId() {
        try
        {
            Id fakeTerminalId = getFakeId(Terminal__c.sObjectType);
            SNG_TerminalQuery.getNetworkTrafficLight(fakeTerminalId);
            System.assert(false);
        }
        catch (SNG_Exception e)
        {
            System.assert(true);
        }
        catch (Exception e)
        {
            System.assert(false);
        }
    }
    
    static testMethod void testGetWeatherTrafficLightInvalidId() {
        try
        {
            Id fakeTerminalId = getFakeId(Terminal__c.sObjectType);
            SNG_TerminalQuery.getWeatherTrafficLight(fakeTerminalId);
            System.assert(false);
        }
        catch (SNG_Exception e)
        {
            System.assert(true);
        }
        catch (Exception e)
        {
            System.assert(false);
        }
    }
    
    static testMethod void testGetOnlineTimeTrafficLightInvalidId() {
        try
        {
            Id fakeTerminalId = getFakeId(Terminal__c.sObjectType);
            SNG_TerminalQuery.getOnlineTimeTrafficLight(fakeTerminalId);
            System.assert(false);
        }
        catch (SNG_Exception e)
        {
            System.assert(true);
        }
        catch (Exception e)
        {
            System.assert(false);
        }
    }
    
    static testMethod void  testSetStatusTrafficLightInTerminalNullTerminal()
    {
    	try
    	{
    		SNG_TerminalQuery.setStatusTrafficLightInTerminal(null);
    		System.assert(false);
    	}
    	catch (SNG_Exception e)
        {
            System.assert(true);
        }
        catch (Exception e)
        {
            System.assert(false);
        }
    }
    
    static testMethod void  testSetStatusTrafficLightInTerminalNonExistentTerminal()
    {
        try
        {
            // Add modem to Salesforce 
            Account account = SNG_TestUtilities.insertAccount('testAccount');
            Terminal__c terminal = SNG_TestUtilities.insertTerminal(account, '11111');
        	
        	Terminal__c queriedTerminal = [SELECT Id FROM Terminal__c WHERE SerialNumber__c = '11111'];
        	
            SNG_TerminalQuery.setStatusTrafficLightInTerminal(queriedTerminal);
            System.assert(false);
        }
        catch (SNG_Exception e)
        {
            System.assert(true);
        }
        catch (Exception e)
        {
            System.assert(false);
        }
    }
    
    //----------------------------------------------------------------------------------------------
    // Sunny-Day scenarios
    //----------------------------------------------------------------------------------------------

    static testMethod void statusTrafficLightOfflineTest() {
    	ApexPages.StandardController controller = initController();
    	SNG_TerminalQuery terminalQuery = new SNG_TerminalQuery(controller);
    	Terminal__c terminal = (Terminal__c)controller.getRecord();
    	terminal = SNGTerminalStatusLightUnitTestHelper.setTerminalOffline(terminal);
    	System.assertEquals(SNGTerminalStatusLight.getPathToStatusImage(SNGTerminalStatusLight.DotColor.GRAY), terminalQuery.statusTrafficLight);
    }
    
    static testMethod void statusTrafficLightGreenTest() {
    	ApexPages.StandardController controller = initController();
    	SNG_TerminalQuery terminalQuery = new SNG_TerminalQuery(controller);
    	Terminal__c terminal = (Terminal__c)controller.getRecord();
    	terminal = SNGTerminalStatusLightUnitTestHelper.setPerformanceGreen(terminal);
    	terminal = SNGTerminalStatusLightUnitTestHelper.setPointingGreen(terminal);
    	System.assertEquals(SNGTerminalStatusLight.getPathToStatusImage(SNGTerminalStatusLight.DotColor.GREEN), terminalQuery.statusTrafficLight);
    }
    
    static testMethod void statusTrafficLightYellowPerformanceTest() {
    	ApexPages.StandardController controller = initController();
    	SNG_TerminalQuery terminalQuery = new SNG_TerminalQuery(controller);
    	Terminal__c terminal = (Terminal__c)controller.getRecord();
    	terminal = SNGTerminalStatusLightUnitTestHelper.setPerformanceYellow(terminal);
    	terminal = SNGTerminalStatusLightUnitTestHelper.setPointingGreen(terminal);
    	System.assertEquals(SNGTerminalStatusLight.getPathToStatusImage(SNGTerminalStatusLight.DotColor.YELLOW), terminalQuery.statusTrafficLight);
    }
    
    static testMethod void statusTrafficLightYellowPointingTest() {
    	ApexPages.StandardController controller = initController();
    	SNG_TerminalQuery terminalQuery = new SNG_TerminalQuery(controller);
    	Terminal__c terminal = (Terminal__c)controller.getRecord();
    	terminal = SNGTerminalStatusLightUnitTestHelper.setPerformanceGreen(terminal);
    	terminal = SNGTerminalStatusLightUnitTestHelper.setPointingYellow(terminal);
    	System.assertEquals(SNGTerminalStatusLight.getPathToStatusImage(SNGTerminalStatusLight.DotColor.YELLOW), terminalQuery.statusTrafficLight);
    }
    
    static testMethod void statusTrafficLightRedPerformanceTest() {
    	ApexPages.StandardController controller = initController();
    	SNG_TerminalQuery terminalQuery = new SNG_TerminalQuery(controller);
    	Terminal__c terminal = (Terminal__c)controller.getRecord();
    	terminal = SNGTerminalStatusLightUnitTestHelper.setPerformanceRed(terminal);
    	terminal = SNGTerminalStatusLightUnitTestHelper.setPointingYellow(terminal);
    	System.assertEquals(SNGTerminalStatusLight.getPathToStatusImage(SNGTerminalStatusLight.DotColor.RED), terminalQuery.statusTrafficLight);
    }
    
    static testMethod void statusTrafficLightRedPointingTest() {
    	ApexPages.StandardController controller = initController();
    	SNG_TerminalQuery terminalQuery = new SNG_TerminalQuery(controller);
    	Terminal__c terminal = (Terminal__c)controller.getRecord();
    	terminal = SNGTerminalStatusLightUnitTestHelper.setPerformanceYellow(terminal);
    	terminal = SNGTerminalStatusLightUnitTestHelper.setPointingRed(terminal);
    	System.assertEquals(SNGTerminalStatusLight.getPathToStatusImage(SNGTerminalStatusLight.DotColor.RED), terminalQuery.statusTrafficLight);
    }
    
    static testMethod void statusTrafficLightGrayPerformanceTest() {
    	ApexPages.StandardController controller = initController();
    	SNG_TerminalQuery terminalQuery = new SNG_TerminalQuery(controller);
    	Terminal__c terminal = (Terminal__c)controller.getRecord();
    	terminal = SNGTerminalStatusLightUnitTestHelper.setPointingRed(terminal);
    	terminal = SNGTerminalStatusLightUnitTestHelper.setPerformanceGray(terminal);
    	System.assertEquals(SNGTerminalStatusLight.getPathToStatusImage(SNGTerminalStatusLight.DotColor.GRAY), terminalQuery.statusTrafficLight);
    }
    
    static testMethod void statusTrafficLightGrayPointingTest() {
    	ApexPages.StandardController controller = initController();
    	SNG_TerminalQuery terminalQuery = new SNG_TerminalQuery(controller);
    	Terminal__c terminal = (Terminal__c)controller.getRecord();
    	terminal = SNGTerminalStatusLightUnitTestHelper.setPerformanceRed(terminal);
    	terminal = SNGTerminalStatusLightUnitTestHelper.setPointingGray(terminal);
    	System.assertEquals(SNGTerminalStatusLight.getPathToStatusImage(SNGTerminalStatusLight.DotColor.GRAY), terminalQuery.statusTrafficLight);
    }
    
    static testMethod void performanceTrafficLightOfflineTest() {
    	ApexPages.StandardController controller = initController();
    	SNG_TerminalQuery terminalQuery = new SNG_TerminalQuery(controller);
    	Terminal__c terminal = (Terminal__c)controller.getRecord();
    	terminal = SNGTerminalStatusLightUnitTestHelper.setTerminalOffline(terminal);
    	System.assertEquals(SNGTerminalStatusLight.getPathToStatusImage(SNGTerminalStatusLight.DotColor.GRAY), terminalQuery.performanceTrafficLight);
    }
    
    static testMethod void performanceTrafficLightGreenTest() {
    	ApexPages.StandardController controller = initController();
    	SNG_TerminalQuery terminalQuery = new SNG_TerminalQuery(controller);
    	Terminal__c terminal = (Terminal__c)controller.getRecord();
    	terminal = SNGTerminalStatusLightUnitTestHelper.setPerformanceGreen(terminal);
    	System.assertEquals(SNGTerminalStatusLight.getPathToStatusImage(SNGTerminalStatusLight.DotColor.GREEN), terminalQuery.performanceTrafficLight);
    }
    
    static testMethod void performanceTrafficLightYellowTest() {
    	ApexPages.StandardController controller = initController();
    	SNG_TerminalQuery terminalQuery = new SNG_TerminalQuery(controller);
    	Terminal__c terminal = (Terminal__c)controller.getRecord();
    	terminal = SNGTerminalStatusLightUnitTestHelper.setPerformanceYellow(terminal);
    	System.assertEquals(SNGTerminalStatusLight.getPathToStatusImage(SNGTerminalStatusLight.DotColor.YELLOW), terminalQuery.performanceTrafficLight);
    }
    
    static testMethod void performanceTrafficLightRedTest() {
    	ApexPages.StandardController controller = initController();
    	SNG_TerminalQuery terminalQuery = new SNG_TerminalQuery(controller);
    	Terminal__c terminal = (Terminal__c)controller.getRecord();
    	terminal = SNGTerminalStatusLightUnitTestHelper.setPerformanceRed(terminal);
    	System.assertEquals(SNGTerminalStatusLight.getPathToStatusImage(SNGTerminalStatusLight.DotColor.RED), terminalQuery.performanceTrafficLight);
    }
    
    static testMethod void performanceTrafficLightGrayTest() {
    	ApexPages.StandardController controller = initController();
    	SNG_TerminalQuery terminalQuery = new SNG_TerminalQuery(controller);
    	Terminal__c terminal = (Terminal__c)controller.getRecord();
    	terminal = SNGTerminalStatusLightUnitTestHelper.setPerformanceGray(terminal);
    	System.assertEquals(SNGTerminalStatusLight.getPathToStatusImage(SNGTerminalStatusLight.DotColor.GRAY), terminalQuery.performanceTrafficLight);
    }
    
    static testMethod void networkTrafficLightGreenTest() {
    	ApexPages.StandardController controller = initController();
    	SNG_TerminalQuery terminalQuery = new SNG_TerminalQuery(controller);
    	Terminal__c terminal = (Terminal__c)controller.getRecord();
    	terminal = SNGTerminalStatusLightUnitTestHelper.setNetworkGreen(terminal);
    	System.assert(terminalQuery.networkTrafficLight.contains(SNGTerminalStatusLight.getPathToStatusImage(SNGTerminalStatusLight.DotColor.GREEN)));
    }
    
    static testMethod void networkTrafficLightRedTest() {
    	ApexPages.StandardController controller = initController();
    	SNG_TerminalQuery terminalQuery = new SNG_TerminalQuery(controller);
    	Terminal__c terminal = (Terminal__c)controller.getRecord();
    	terminal = SNGTerminalStatusLightUnitTestHelper.setNetworkRed(terminal);
    	System.assert(terminalQuery.networkTrafficLight.contains(SNGTerminalStatusLight.getPathToStatusImage(SNGTerminalStatusLight.DotColor.RED)));
    }
    
    static testMethod void weatherTrafficLightGreenTest() {
    	ApexPages.StandardController controller = initController();
    	SNG_TerminalQuery terminalQuery = new SNG_TerminalQuery(controller);
    	Terminal__c terminal = (Terminal__c)controller.getRecord();
    	terminal = SNGTerminalStatusLightUnitTestHelper.setWeatherGreen(terminal);
    	System.assert(terminalQuery.weatherTrafficLight.contains(SNGTerminalStatusLight.getPathToStatusImage(SNGTerminalStatusLight.DotColor.GREEN)));
    }
    
    static testMethod void weatherTrafficLightYellowTest() {
    	ApexPages.StandardController controller = initController();
    	SNG_TerminalQuery terminalQuery = new SNG_TerminalQuery(controller);
    	Terminal__c terminal = (Terminal__c)controller.getRecord();
    	terminal = SNGTerminalStatusLightUnitTestHelper.setWeatherYellow(terminal);
    	System.assert(terminalQuery.weatherTrafficLight.contains(SNGTerminalStatusLight.getPathToStatusImage(SNGTerminalStatusLight.DotColor.YELLOW)));
    }
    
    static testMethod void weatherTrafficLightRedTest() {
    	ApexPages.StandardController controller = initController();
    	SNG_TerminalQuery terminalQuery = new SNG_TerminalQuery(controller);
    	Terminal__c terminal = (Terminal__c)controller.getRecord();
    	terminal = SNGTerminalStatusLightUnitTestHelper.setWeatherRed(terminal);
    	System.assert(terminalQuery.weatherTrafficLight.contains(SNGTerminalStatusLight.getPathToStatusImage(SNGTerminalStatusLight.DotColor.RED)));
    }
    
    static testMethod void onlineTimeTrafficLightOfflineTest() {
    	ApexPages.StandardController controller = initController();
    	SNG_TerminalQuery terminalQuery = new SNG_TerminalQuery(controller);
    	Terminal__c terminal = (Terminal__c)controller.getRecord();
    	terminal = SNGTerminalStatusLightUnitTestHelper.setTerminalOnlineTime(terminal, 0);
    	System.assertEquals('Offline', terminalQuery.onlineTimeTrafficLight);
    }
    
    static testMethod void onlineTimeTrafficLightOnlineTest() {
    	ApexPages.StandardController controller = initController();
    	SNG_TerminalQuery terminalQuery = new SNG_TerminalQuery(controller);
    	Terminal__c terminal = (Terminal__c)controller.getRecord();
    	Long secondsJustUnder2Days = 60 * 60 * 24 * 2 - 1;  // 1 day, 23 hours, 59 minutes, 59 seconds
    	terminal = SNGTerminalStatusLightUnitTestHelper.setTerminalOnlineTime(terminal, secondsJustUnder2Days);
    	String onlineTimeTrafficLight = terminalQuery.onlineTimeTrafficLight;
    	String[] onlineTimeParts = onlineTimeTrafficLight.split(',');
    	System.assertEquals(4, onlineTimeParts.size());
    	
    	System.assert(onlineTimeParts[0].contains('day'));
    	String[] dayParts = onlineTimeParts[0].split(' ');
    	System.assertEquals(2, dayParts.size());
    	System.assertEquals(1, Integer.valueOf(dayParts[0]));
    	System.assert(dayParts[1].contains('day'));
    	
    	System.assert(onlineTimeParts[1].contains('hours'));
    	String[] hourParts = onlineTimeParts[1].trim().split(' ');
    	System.assertEquals(2, hourParts.size());
    	System.assertEquals(23, Integer.valueOf(hourParts[0]));
    	System.assertEquals('hours', hourParts[1]);
    	
    	System.assert(onlineTimeParts[2].contains('minutes'));
    	String[] minParts = onlineTimeParts[2].trim().split(' ');
    	System.assertEquals(2, minParts.size());
    	System.assertEquals(59, Integer.valueOf(minParts[0]));
    	System.assertEquals('minutes', minParts[1]);
    	
    	System.assert(onlineTimeParts[3].contains('seconds'));
    	String[] secParts = onlineTimeParts[3].trim().split(' ');
    	System.assertEquals(2, secParts.size());
    	System.assertEquals(59, Integer.valueOf(secParts[0]));
    	System.assertEquals('seconds', secParts[1]);
    }
    
    static testMethod void pointingTrafficLightGreenTest() {
    	ApexPages.StandardController controller = initController();
    	SNG_TerminalQuery terminalQuery = new SNG_TerminalQuery(controller);
    	Terminal__c terminal = (Terminal__c)controller.getRecord();
    	terminal = SNGTerminalStatusLightUnitTestHelper.setPointingGreen(terminal);
    	System.assertEquals(SNGTerminalStatusLight.getPathToStatusImage(SNGTerminalStatusLight.DotColor.GREEN), terminalQuery.pointingTrafficLight);
    }
    
    static testMethod void pointingTrafficLightYellowTest() {
    	ApexPages.StandardController controller = initController();
    	SNG_TerminalQuery terminalQuery = new SNG_TerminalQuery(controller);
    	Terminal__c terminal = (Terminal__c)controller.getRecord();
    	terminal = SNGTerminalStatusLightUnitTestHelper.setPointingYellow(terminal);
    	System.assertEquals(SNGTerminalStatusLight.getPathToStatusImage(SNGTerminalStatusLight.DotColor.YELLOW), terminalQuery.pointingTrafficLight);
    }
    
    static testMethod void pointingTrafficLightRedTest() {
    	ApexPages.StandardController controller = initController();
    	SNG_TerminalQuery terminalQuery = new SNG_TerminalQuery(controller);
    	Terminal__c terminal = (Terminal__c)controller.getRecord();
    	terminal = SNGTerminalStatusLightUnitTestHelper.setPointingRed(terminal);
    	System.assertEquals(SNGTerminalStatusLight.getPathToStatusImage(SNGTerminalStatusLight.DotColor.RED), terminalQuery.pointingTrafficLight);
    }
    
    static testMethod void pointingTrafficLightGrayTest() {
    	ApexPages.StandardController controller = initController();
    	SNG_TerminalQuery terminalQuery = new SNG_TerminalQuery(controller);
    	Terminal__c terminal = (Terminal__c)controller.getRecord();
    	terminal = SNGTerminalStatusLightUnitTestHelper.setPointingGray(terminal);
    	System.assertEquals(SNGTerminalStatusLight.getPathToStatusImage(SNGTerminalStatusLight.DotColor.GRAY), terminalQuery.pointingTrafficLight);
    }
    
    private static ApexPages.StandardController initController() {
    	Terminal__c terminal = SNG_TestUtilities.insertTerminal(SNG_TestUtilities.insertAccount('accountName'), 'serialNum');
    	return new ApexPages.StandardController(terminal);
    }
    
    private static String getFakeId(Schema.SObjectType sot)
    {
         String result = String.valueOf(s_num++);
         return sot.getDescribe().getKeyPrefix() + 
         '0'.repeat(12-result.length()) + result;
    }
}