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
private class SNGRESTTerminalTest 
{
    // *****************************************************
    // SNG_REST_TerminalsAdminInfoUnitTest
    // *****************************************************
    private static testMethod void noMacAddressZeroResults() 
    {
        // PROCESS REQUEST #1
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse(); 
        req.requestURI = '/terminals/info';
        req.resourcePath ='/terminals/info/*';
        req.addParameter('ids', 'T0000');
        req.httpMethod = 'GET'; 
        
        // RestContext contains the RestRequest and RestResponse objects in REST methods
        RestContext.request = req; 
        RestContext.response = res; 
        
        SNG_REST_JsonResponse response = SNG_REST_TerminalsAdminInfo.get(); 
        
        SNG_REST_JsonResponse expectedOutput = new SNG_REST_JsonResponse(SNGHttpUtilities.Status.ZERO_RESULTS,
                                                                         SNG_REST_Error.SubCode.SALESFORCE_GENERATED_ERROR,
                                                                         SNG_REST_Error.TERMINAL_NO_MODEM, 
                                                                         null);
        System.assertEquals(expectedOutput, response);

        // PROCESS REQUEST #2
        req = new RestRequest(); 
        res = new RestResponse(); 
        String terminalId = 'T0000';
        req.requestURI = '/terminal/' + terminalId + '/info';
        req.resourcePath ='/terminal/*/info';
        req.httpMethod = 'GET'; 
        
        // RestContext contains the RestRequest and RestResponse objects in REST methods
        RestContext.request = req; 
        RestContext.response = res; 
        
        response = SNG_REST_TerminalAdminInfo.get(); 
        
        expectedOutput = new SNG_REST_JsonResponse(SNGHttpUtilities.Status.ZERO_RESULTS,
                                                                         SNG_REST_Error.SubCode.SALESFORCE_GENERATED_ERROR,
                                                                         SNG_REST_Error.TERMINAL_NO_MODEM, 
                                                                         null);
        System.debug('Response: ' + response.toString());
        System.debug('Expected: ' + expectedOutput.toString());        
        System.assertEquals(expectedOutput, response);
    }
    
    private static testMethod void methodCallNotFromRestfulUriRequest2() 
    {
        try
        {
            SNG_REST_TerminalsAdminInfo.get();
            System.assert(false);
        }
        catch (Exception e)
        {
            System.assert(true);
        }
    }

    // this should be similar to sunny day.
    private static testMethod void noParametersButOneTerminalIsOwnedByAccount() 
    {
        
        SNG_MockCustomSettings.initialize();
        
        String terminalNickname = 'Terminal1';
        String macAddress = SNG_MockModemSoftwareVersionHttpCallout.MACADDR_OK;
        SNG_TestUtilities.insertEquipment(terminalNickname, macAddress, 'Red Cross', true);

        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new SNG_MockModemSoftwareVersionHttpCallout());
        
        Terminal__c terminal = [SELECT Name, Nickname__c, SerialNumber__c, TerminalType__r.Name, IpAddress__c FROM Terminal__c WHERE Nickname__c = :terminalNickname];
        
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse(); 
        
        // set the request URL 
        req.requestURI = '/terminals/info';
        req.resourcePath ='/terminals/info/*';
        
        // set the request method
        req.httpMethod = 'GET'; 
        
        // RestContext contains the RestRequest and RestResponse objects in REST methods
        RestContext.request = req; 
        RestContext.response = res; 
        
        SNG_REST_JsonResponse response = SNG_REST_TerminalsAdminInfo.get(); 
        
       SNG_REST_TerminalsAdminInfoRequest.TerminalAdminInfo expectedInfo = new SNG_REST_TerminalsAdminInfoRequest.TerminalAdminInfo(terminal, macAddress, SNG_MockModemSoftwareVersionHttpCallout.SOFTWARE_VERSION);
        
        List<SNG_REST_TerminalsAdminInfoRequest.TerminalAdminInfo> expectedList = new List<SNG_REST_TerminalsAdminInfoRequest.TerminalAdminInfo>();
        expectedList.add(expectedInfo);
        
        SNG_REST_JsonResponse expectedOutput = new SNG_REST_JsonResponse(SNGHttpUtilities.Status.OK, null, null, new SNG_REST_CollectionOutput(expectedList));
        
       System.assertEquals(expectedOutput, response);
    }   
    
    private static testMethod void testHashCode()
    {
        SNG_MockCustomSettings.initialize();
        
        String terminalNickname = 'Terminal1';
        String macAddress = SNG_MockModemSoftwareVersionHttpCallout.MACADDR_ZERO_RESULTS;
        SNG_TestUtilities.insertEquipment(terminalNickname, macAddress, 'Red Cross', true);

        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new SNG_MockModemSoftwareVersionHttpCallout());
        
        Terminal__c terminal = [SELECT Name, Nickname__c, SerialNumber__c, TerminalType__r.Name, IpAddress__c FROM Terminal__c WHERE Nickname__c = :terminalNickname];
                
        SNG_REST_TerminalsAdminInfoRequest.TerminalAdminInfo infoA = new SNG_REST_TerminalsAdminInfoRequest.TerminalAdminInfo(terminal, macAddress, '1.2.3.4');
        SNG_REST_TerminalsAdminInfoRequest.TerminalAdminInfo infoB = new SNG_REST_TerminalsAdminInfoRequest.TerminalAdminInfo(terminal, macAddress, '1.2.3.4');

        System.assert(infoA == infoB);
        System.assertEquals(infoA.hashCode(), infoB.hashCode());
    }
    
    private static testMethod void validTerminalMacAddressOKWithErrors() 
    {
        SNG_MockCustomSettings.initialize();
        
        String terminalNickname = 'Terminal1';
        String macAddress = SNG_MockModemSoftwareVersionHttpCallout.MACADDR_OK;

        Account acc = SNG_TestUtilities.insertAccount('Red Cross');
        Modem__c m = SNG_TestUtilities.insertEquipment(terminalNickname, macAddress, acc, 'ser1', true, '1234567');
system.debug('*** Modem__c m: ' + m);

        String terminalNickname2 = 'Terminal2';
        String macAddress2 = SNG_MockModemSoftwareVersionHttpCallout.MACADDR_ZERO_RESULTS;
system.assert(macAddress!=macAddress2);
system.debug('*** ' + macAddress +';  ' + macAddress2);
        SNG_TestUtilities.insertEquipment(terminalNickname2, macAddress2, acc, 'ser2', true, '7654321');

        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new SNG_MockModemSoftwareVersionHttpCallout());
        
        Terminal__c terminal = [SELECT Name, Nickname__c, SerialNumber__c, TerminalType__r.Name, IpAddress__c FROM Terminal__c WHERE Nickname__c = :terminalNickname];
        Terminal__c terminal2 = [SELECT Name, Nickname__c, SerialNumber__c, TerminalType__r.Name, IpAddress__c FROM Terminal__c WHERE Nickname__c = :terminalNickname2];
        
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse(); 
        
        System.debug('Terminal.Name: ' + terminal.Name);
        
        // set the request URL 
        req.requestURI = '/terminals/info';
        req.resourcePath ='/terminals/info/*';
        req.addParameter('ids', terminal.Name + ',' + terminal2.Name);
        
        // set the request method
        req.httpMethod = 'GET'; 
        
        // RestContext contains the RestRequest and RestResponse objects in REST methods
        RestContext.request = req; 
        RestContext.response = res; 
        
        SNG_REST_JsonResponse response = SNG_REST_TerminalsAdminInfo.get(); 

        SNG_REST_TerminalsAdminInfoRequest.TerminalAdminInfo expectedInfo = new SNG_REST_TerminalsAdminInfoRequest.TerminalAdminInfo(terminal, macAddress, SNG_MockModemSoftwareVersionHttpCallout.SOFTWARE_VERSION);
        SNG_REST_TerminalsAdminInfoRequest.TerminalAdminInfo expectedInfo2 = new SNG_REST_TerminalsAdminInfoRequest.TerminalAdminInfo(terminal2, macAddress2, null);
        
            
        List<SNG_REST_TerminalsAdminInfoRequest.TerminalAdminInfo> expectedList = new List<SNG_REST_TerminalsAdminInfoRequest.TerminalAdminInfo>();
        expectedList.add(expectedInfo);
        expectedList.add(expectedInfo2);
        
        SNG_REST_JsonResponse expectedOutput = new SNG_REST_JsonResponse(SNGHttpUtilities.Status.OK_WITH_ERRORS, 
                                                                         SNG_REST_Error.SubCode.WEBSERVICE_GENERATED_ERROR, 
                                                                         SNG_REST_TerminalsAdminInfoRequest.SOFTWARE_VERSION_ERROR, 
                                                                         new SNG_REST_CollectionOutput(expectedList));
        
//System.assertEquals(expectedOutput, response);
        Test.stopTest();
    }
    
    private static testMethod void validTerminalMacAddressForOneTerminalOKWithErrors() 
    {
        SNG_MockCustomSettings.initialize();
        
        String terminalNickname = 'Terminal1';
        String macAddress = SNG_MockModemSoftwareVersionHttpCallout.MACADDR_OK;
        
        String accountName = 'Red Cross';
        Account account = SNG_TestUtilities.insertAccount(accountName);
        SNG_TestUtilities.insertEquipment(terminalNickname, macAddress, account, true);
        
        String serialNumber = '1234';
        SNG_TestUtilities.insertTerminal(account, serialNumber, '1234567');
        

        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new SNG_MockModemSoftwareVersionHttpCallout());
        
        Terminal__c terminal = [SELECT Name, Nickname__c, SerialNumber__c, TerminalType__r.Name, IpAddress__c FROM Terminal__c WHERE Nickname__c = :terminalNickname];
        Terminal__c terminal2 = [SELECT Name, Nickname__c, SerialNumber__c, TerminalType__r.Name, IpAddress__c FROM Terminal__c WHERE SerialNumber__c = :serialNumber];
        
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse(); 
        req.requestURI = '/terminals/info';
        req.resourcePath ='/terminals/info/*';
        req.addParameter('ids', terminal.Name + ',' + terminal2.Name);
        req.httpMethod = 'GET'; 
        
        // RestContext contains the RestRequest and RestResponse objects in REST methods
        RestContext.request = req; 
        RestContext.response = res; 
        
        SNG_REST_JsonResponse response = SNG_REST_TerminalsAdminInfo.get(); 

        SNG_REST_TerminalsAdminInfoRequest.TerminalAdminInfo expectedInfo = new SNG_REST_TerminalsAdminInfoRequest.TerminalAdminInfo(terminal, macAddress, SNG_MockModemSoftwareVersionHttpCallout.SOFTWARE_VERSION);
        SNG_REST_TerminalsAdminInfoRequest.TerminalAdminInfo expectedInfo2 = new SNG_REST_TerminalsAdminInfoRequest.TerminalAdminInfo(terminal2, null, null);
        
        List<SNG_REST_TerminalsAdminInfoRequest.TerminalAdminInfo> expectedList = new List<SNG_REST_TerminalsAdminInfoRequest.TerminalAdminInfo>();
        expectedList.add(expectedInfo);
        expectedList.add(expectedInfo2);
        
        SNG_REST_JsonResponse expectedOutput = new SNG_REST_JsonResponse(SNGHttpUtilities.Status.OK_WITH_ERRORS, 
                                                                         SNG_REST_Error.SubCode.SALESFORCE_GENERATED_ERROR, 
                                                                         SNG_REST_Error.TERMINAL_NO_MODEM, 
                                                                         new SNG_REST_CollectionOutput(expectedList));
//System.assertEquals(expectedOutput, response);
        
        Test.stopTest();
    }
    
    // ******************************************************
    // SNG_REST_TerminalIdUnitTest 
    // ******************************************************
    private static testMethod void validMacAddressNoResults() 
    {
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse(); 
        
        // set the request URL 
        String macAddress = '00:a0:bc:11:22:33';
        req.requestURI = '/modem/' + macAddress + '/terminal-id';
        req.resourcePath = '/modem/*/terminal-id';

        // set the request method
        req.httpMethod = 'GET'; 
        
        // RestContext contains the RestRequest and RestResponse objects in REST methods
        RestContext.request = req; 
        RestContext.response = res; 
        
        SNG_REST_JsonResponse response = SNG_REST_TerminalIdApi.getTerminalId(); 

        SNG_REST_JsonResponse expectedOutput = new SNG_REST_JsonResponse(SNGHttpUtilities.Status.ZERO_RESULTS,
                                                                         SNG_REST_Error.SubCode.SALESFORCE_GENERATED_ERROR,
                                                                         SNG_REST_ERROR.IDS_INVALID,
                                                                         null);
        System.assertEquals(expectedOutput, response);
    }
    
    private static testMethod void methodCallNotFromRestfulUriRequest() 
    {
        try
        {
            SNG_REST_TerminalIdApi.getTerminalId();
            System.assert(false);
        }
        catch (Exception e)
        {
            System.assert(true);
        }
    }
    
    private static testMethod void invalidMacAddress() 
    {
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse(); 
        
        // set the request URL 
        String macAddress = '00:f0:ad:11:22:';
        req.requestURI = '/modem/' + macAddress + '/terminal-id';
        req.resourcePath = '/modem/*/terminal-id';

        // set the request method
        req.httpMethod = 'GET'; 
        
        // RestContext contains the RestRequest and RestResponse objects in REST methods
        RestContext.request = req; 
        RestContext.response = res; 
        
        SNG_REST_JsonResponse response = SNG_REST_TerminalIdApi.getTerminalId(); 

        SNG_REST_JsonResponse expectedOutput = new SNG_REST_JsonResponse(SNGHttpUtilities.Status.INPUT_VALIDATION_ERROR,
                                                                         SNG_REST_Error.SubCode.SALESFORCE_GENERATED_ERROR,
                                                                         SNG_REST_ERROR.INPUT_INVALID_FORMAT,
                                                                         null);
        System.assertEquals(expectedOutput, response);
    }
    
    private static testMethod void validMacAddressToTerminalSunnyDay() 
    {
        String macAddressSalesforceFormat = '00:a0:bc:11:22:33';
        String macAddressUrlEncoded = '00%3Aa0%3Abc%3A11%3A22%3A33';
        String macAddressNoColons = '00a0bc112233';

        String equipmentName = 'T1234';
        SNG_TestUtilities.insertEquipment(equipmentName, macAddressSalesforceFormat, SNG_TestUtilities.insertAccount('Red Cross'), true);
      
        Terminal__c terminal = [SELECT Name FROM Terminal__c WHERE NickName__c = :equipmentName];
      
      
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse(); 
        
        // set the request method
        req.httpMethod = 'GET'; 

        // Set the resource path
        req.resourcePath = '/modem/*/terminal-id';

        // RestContext contains the RestRequest and RestResponse objects in REST methods
        RestContext.request = req; 
        RestContext.response = res; 

        // Create expected response
        SNG_REST_JsonResponse expectedOutput = new SNG_REST_JsonResponse(SNGHttpUtilities.Status.OK,
                                                                         null,
                                                                         null,
                                                                         new SNG_REST_TerminalIdMacAddressOutput(terminal.Name, macAddressSalesforceFormat));

        // TerminalId API call for MAC address in Salesforce format
        req.requestURI = '/modem/' + macAddressSalesforceFormat + '/terminal-id';
        SNG_REST_JsonResponse response = SNG_REST_TerminalIdApi.getTerminalId();
        System.assertEquals(expectedOutput, response);

        // TerminalId API call for MAC address in URL encoded format
        req.requestURI = '/modem/' + macAddressUrlEncoded + '/terminal-id';
        response = SNG_REST_TerminalIdApi.getTerminalId();
        System.assertEquals(expectedOutput, response);

        // TerminalId API call for MAC address with no colons format
        req.requestURI = '/modem/' + macAddressNoColons + '/terminal-id';
        response = SNG_REST_TerminalIdApi.getTerminalId();
        System.assertEquals(expectedOutput, response);
    }

    private static testMethod void validModemNoTerminal() 
    {
        String macAddress = '00:a0:bc:11:22:33';
        String equipmentName = 'T1234';
        Modem__c modem = SNG_TestUtilities.insertEquipment(equipmentName, macAddress, SNG_TestUtilities.insertAccount('Red Cross'), true);
        modem.Terminal__c = null;
        modem.Terminal__r = null;
        update modem;
      
        Terminal__c terminal = [SELECT Name FROM Terminal__c WHERE NickName__c = :equipmentName];
        delete terminal;
      
      
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse(); 
        
        // set the request URL 
        req.requestURI = '/modem/' + macAddress + '/terminal-id';
        req.resourcePath = '/modem/*/terminal-id';
        
        
        // set the request method
        req.httpMethod = 'GET'; 
        
        // RestContext contains the RestRequest and RestResponse objects in REST methods
        RestContext.request = req; 
        RestContext.response = res; 
        
        SNG_REST_JsonResponse response = SNG_REST_TerminalIdApi.getTerminalId(); 

        SNG_REST_JsonResponse expectedOutput = new SNG_REST_JsonResponse(SNGHttpUtilities.Status.OK,
                                                                         null,
                                                                         null,
                                                                         new SNG_REST_TerminalIdMacAddressOutput(null, macAddress));
        System.assertEquals(expectedOutput, response);
        
    }

    // ******************************************************
    // SNG_REST_TerminalAdminInfo
    // ******************************************************
    private static testMethod void noMacAddressZeroResults3() 
    {
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse(); 
        
        // set the request URL 
        String terminalId = 'T0000';
        req.requestURI = '/terminal/' + terminalId + '/info';
        req.resourcePath ='/terminal/*/info';
        
        // set the request method
        req.httpMethod = 'GET'; 
        
        // RestContext contains the RestRequest and RestResponse objects in REST methods
        RestContext.request = req; 
        RestContext.response = res; 
        
        SNG_REST_JSONResponse response = SNG_REST_TerminalAdminInfo.get(); 
        
        SNG_REST_JsonResponse expectedOutput = new SNG_REST_JsonResponse(SNGHttpUtilities.Status.ZERO_RESULTS,
                                                                         SNG_REST_Error.SubCode.SALESFORCE_GENERATED_ERROR,
                                                                         SNG_REST_Error.TERMINAL_NO_MODEM, 
                                                                         null);
        System.debug('Response: ' + response.toString());
        System.debug('Expected: ' + expectedOutput.toString());        
        System.assertEquals(expectedOutput, response);
    }
    
    private static testMethod void nullMacAddressZeroResults() 
    {
        // PROCESS REQUEST #1
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse(); 
        String terminalId;
        req.requestURI = '/terminal/' + terminalId + '/info';
        req.resourcePath ='/terminal/*/info';
        req.httpMethod = 'GET'; 
        
        // RestContext contains the RestRequest and RestResponse objects in REST methods
        RestContext.request = req; 
        RestContext.response = res; 
        
        SNG_REST_JSONResponse response = SNG_REST_TerminalAdminInfo.get(); 

        SNG_REST_JsonResponse expectedOutput = new SNG_REST_JsonResponse(SNGHttpUtilities.Status.INPUT_VALIDATION_ERROR,
                                                                         SNG_REST_Error.SubCode.SALESFORCE_GENERATED_ERROR,
                                                                         SNG_REST_Error.INPUT_INVALID_FORMAT, 
                                                                         null);
        System.assertEquals(expectedOutput, response);
    
        // PROCESS REQUEST #2
        req = new RestRequest(); 
        res = new RestResponse(); 
        req.requestURI = '/terminals/info';
        req.resourcePath ='/terminals/info/*';
        req.httpMethod = 'GET'; 
        
        // RestContext contains the RestRequest and RestResponse objects in REST methods
        RestContext.request = req; 
        RestContext.response = res; 
        
        response = SNG_REST_TerminalsAdminInfo.get(); 
        
        expectedOutput = new SNG_REST_JsonResponse(SNGHttpUtilities.Status.ZERO_RESULTS,null, null, null);
        System.assertEquals(expectedOutput, response);
    }
    
    private static testMethod void invalidTerminalIdZeroResults() 
    {
        // PROCESS REQUEST #1
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse(); 
        
        // set the request URL 
        String terminalId = 'invalidTerminalId';
        req.requestURI = '/terminal/' + terminalId + '/info';
        req.resourcePath ='/terminal/*/info';
        req.httpMethod = 'GET'; 
        
        // RestContext contains the RestRequest and RestResponse objects in REST methods
        RestContext.request = req; 
        RestContext.response = res; 
        
        SNG_REST_JSONResponse response = SNG_REST_TerminalAdminInfo.get(); 

        SNG_REST_JsonResponse expectedOutput = new SNG_REST_JsonResponse(SNGHttpUtilities.Status.INPUT_VALIDATION_ERROR,
                                                                         SNG_REST_Error.SubCode.SALESFORCE_GENERATED_ERROR,
                                                                         SNG_REST_Error.INPUT_INVALID_FORMAT, 
                                                                         null);
        System.assertEquals(expectedOutput, response);

        // PROCESS REQUEST #2
        req = new RestRequest(); 
        res = new RestResponse(); 
        req.requestURI = '/terminals/info';
        req.resourcePath ='/terminals/info/*';
        req.addParameter('ids', 'invalidTerminalId');
        req.httpMethod = 'GET'; 
        
        // RestContext contains the RestRequest and RestResponse objects in REST methods
        RestContext.request = req; 
        RestContext.response = res; 
        
        response = SNG_REST_TerminalsAdminInfo.get(); 
        
        expectedOutput = new SNG_REST_JsonResponse(SNGHttpUtilities.Status.INPUT_VALIDATION_ERROR,
                                                                         SNG_REST_Error.SubCode.SALESFORCE_GENERATED_ERROR,
                                                                         SNG_REST_Error.INPUT_INVALID_FORMAT, 
                                                                         null);
        System.assertEquals(expectedOutput, response);
    }
    
    private static testMethod void validTerminalMacAddressNoSoftwareVersion() 
    {
        SNG_MockCustomSettings.initialize();
        
        String terminalNickname = 'Terminal1';
        String macAddress = SNG_MockModemSoftwareVersionHttpCallout.MACADDR_ZERO_RESULTS;
        SNG_TestUtilities.insertEquipment(terminalNickname, macAddress, 'Red Cross', true);

        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new SNG_MockModemSoftwareVersionHttpCallout());
        
        Terminal__c terminal = [SELECT Name, Nickname__c, SerialNumber__c, TerminalType__r.Name, IpAddress__c FROM Terminal__c WHERE Nickname__c = :terminalNickname];
        System.debug('Terminal.Name: ' + terminal.Name);
                
        // PROCESS REQUEST #1
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse(); 
        
        // set the request URL 
        String terminalId = terminal.Name;
        req.requestURI = '/terminal/' + terminalId + '/info';
        req.resourcePath ='/terminal/*/info';
        
        // set the request method
        req.httpMethod = 'GET'; 
        
        // RestContext contains the RestRequest and RestResponse objects in REST methods
        RestContext.request = req; 
        RestContext.response = res; 
        
        SNG_REST_JSONResponse response = SNG_REST_TerminalAdminInfo.get(); 

        SNG_REST_TerminalsAdminInfoRequest.TerminalAdminInfo expectedInfo = new SNG_REST_TerminalsAdminInfoRequest.TerminalAdminInfo(terminal, macAddress, null);
        
        SNG_REST_JsonResponse expectedOutput = new SNG_REST_JsonResponse(SNGHttpUtilities.Status.OK_WITH_ERRORS,
                                                                         SNG_REST_Error.SubCode.WEBSERVICE_GENERATED_ERROR,
                                                                         SNG_REST_TerminalsAdminInfoRequest.SOFTWARE_VERSION_ERROR, 
                                                                         expectedInfo);
        System.assertEquals(expectedOutput, response);

        // PROCESS REQUEST #2
        req = new RestRequest(); 
        res = new RestResponse(); 
        req.requestURI = '/terminals/info';
        req.resourcePath ='/terminals/info/*';
        req.addParameter('ids', terminal.Name);
        req.httpMethod = 'GET'; 
        
        // RestContext contains the RestRequest and RestResponse objects in REST methods
        RestContext.request = req; 
        RestContext.response = res; 
        
        response = SNG_REST_TerminalsAdminInfo.get(); 
        
        List<SNG_REST_TerminalsAdminInfoRequest.TerminalAdminInfo> expectedList = new List<SNG_REST_TerminalsAdminInfoRequest.TerminalAdminInfo>();
        expectedInfo = new SNG_REST_TerminalsAdminInfoRequest.TerminalAdminInfo(terminal, macAddress, null);
        expectedList.add(expectedInfo);
        
        expectedOutput = new SNG_REST_JsonResponse(SNGHttpUtilities.Status.OK_WITH_ERRORS,
                                                                         SNG_REST_Error.SubCode.WEBSERVICE_GENERATED_ERROR,
                                                                         SNG_REST_TerminalsAdminInfoRequest.SOFTWARE_VERSION_ERROR, 
                                                                         new SNG_REST_CollectionOutput(expectedList));
        System.assertEquals(expectedOutput, response);
      
        Test.stopTest();
    }

    private static testMethod void validTerminalMacAddressSunnyDay() 
    {
        SNG_MockCustomSettings.initialize();
        
        String terminalNickname = 'Terminal1';
        String macAddress = SNG_MockModemSoftwareVersionHttpCallout.MACADDR_OK;
        SNG_TestUtilities.insertEquipment(terminalNickname, macAddress, 'Red Cross', true);

        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new SNG_MockModemSoftwareVersionHttpCallout());
        
        Terminal__c terminal = [SELECT Name, Nickname__c, SerialNumber__c, TerminalType__r.Name, IpAddress__c FROM Terminal__c WHERE Nickname__c = :terminalNickname];
        System.debug('Terminal.Name: ' + terminal.Name);
        
        // PROCESS REQUEST #1
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse(); 
        req.requestURI = '/terminal/' + terminal.Name + '/info';
        req.resourcePath ='/terminal/*/info';
        req.httpMethod = 'GET'; 
        
        // RestContext contains the RestRequest and RestResponse objects in REST methods
        RestContext.request = req; 
        RestContext.response = res; 
        
        SNG_REST_JSONResponse response = SNG_REST_TerminalAdminInfo.get();         
        SNG_REST_TerminalsAdminInfoRequest.TerminalAdminInfo expectedInfo = new SNG_REST_TerminalsAdminInfoRequest.TerminalAdminInfo(terminal, macAddress, SNG_MockModemSoftwareVersionHttpCallout.SOFTWARE_VERSION);       
        SNG_REST_JsonResponse expectedOutput = new SNG_REST_JsonResponse(SNGHttpUtilities.Status.OK,
                                                                         null,null,expectedInfo);        
        System.assertEquals(expectedOutput, response);
        
        // PROCESS REQUEST #2
        req = new RestRequest(); 
        res = new RestResponse();  
        req.requestURI = '/terminals/info';
        req.resourcePath ='/terminals/info/*';
        req.addParameter('ids', terminal.Name);       
        req.httpMethod = 'GET'; 
        
        // RestContext contains the RestRequest and RestResponse objects in REST methods
        RestContext.request = req; 
        RestContext.response = res; 
        
        response = SNG_REST_TerminalsAdminInfo.get(); 
        expectedInfo = new SNG_REST_TerminalsAdminInfoRequest.TerminalAdminInfo(terminal, macAddress, SNG_MockModemSoftwareVersionHttpCallout.SOFTWARE_VERSION);        
        List<SNG_REST_TerminalsAdminInfoRequest.TerminalAdminInfo> expectedList = new List<SNG_REST_TerminalsAdminInfoRequest.TerminalAdminInfo>();
        expectedList.add(expectedInfo);
        
        expectedOutput = new SNG_REST_JsonResponse(SNGHttpUtilities.Status.OK, null, null, new SNG_REST_CollectionOutput(expectedList));
        
        System.assertEquals(expectedOutput, response);

        Test.stopTest();
    }
    
    // ******************************************************
    // SNG_REST_TerminalsStatusUnitTest     
    // ******************************************************
    static testMethod void pluralRequestSuccessTest() {
        // init
        SNG_MockCustomSettings.initialize();
        Terminal__c[] terminals = getTerminalsForPluralRequestSuccessTest();
        RestContext.request = getPluralRequest(terminals);

        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new SNG_MockPerformanceLatestHttpCallout());
        
        // do the callout
        SNG_REST_JsonResponse responseBody = SNG_REST_TerminalsStatus.get();
        
        // verify the response
        verifyResponseForPluralRequestSuccessTest(terminals, responseBody);
        Test.stopTest();
    }
    
    static testMethod void pluralRequestInvalidIdTest() {
        // init
        SNG_MockCustomSettings.initialize();
        String[] terminalIdNames = getTerminalNamesForPluralRequestInvalidIdTest();
        RestContext.request = getPluralRequest(terminalIdNames);

        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new SNG_MockPerformanceLatestHttpCallout());
        
        // do the callout
        SNG_REST_JsonResponse responseBody = SNG_REST_TerminalsStatus.get();
        
        // verify the response
        verifyResponseForPluralRequestInvalidIdTest(terminalIdNames, responseBody);
        Test.stopTest();
    }
    
    static testMethod void pluralRequestTerminalNotOnAccountTest() {
        // init
        SNG_MockCustomSettings.initialize();
        Terminal__c[] terminals = getTerminalsForPluralRequestTerminalNotOnAccountTest();
        RestContext.request = getPluralRequest(terminals);
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new SNG_MockPerformanceLatestHttpCallout());
        
        // do the callout
        SNG_REST_JsonResponse responseBody = SNG_REST_TerminalsStatus.get();
        
        // verify the response
        verifyResponseForPluralRequestTerminalNotOnAccountTest(terminals, responseBody);
        Test.stopTest();
    }
    
    static testMethod void pluralRequestNoTerminalsOnAccountTest() {
        // init
        SNG_MockCustomSettings.initialize();
        Terminal__c[] terminals = getTerminalsForPluralRequestNoTerminalsOnAccountTest();
        RestContext.request = getPluralRequest(terminals);

        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new SNG_MockPerformanceLatestHttpCallout());
        
        // do the callout
        SNG_REST_JsonResponse responseBody = SNG_REST_TerminalsStatus.get();
        
        // verify the response
        verifyResponseForPluralRequestNoTerminalsOnAccountTest(responseBody);
        Test.stopTest();
    }

    static testMethod void pluralRequestTerminalModemNotAssociatedTest() {
        // init
        SNG_MockCustomSettings.initialize();
        Terminal__c[] terminals = getTerminalsForPluralRequestTerminalModemNotAssociatedTest();
        RestContext.request = getPluralRequest(terminals);

        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new SNG_MockPerformanceLatestHttpCallout());
        
        // do the callout
        SNG_REST_JsonResponse responseBody = SNG_REST_TerminalsStatus.get();
        
        // verify the response
        verifyResponseForPluralRequestTerminalModemNotAssociatedTest(terminals, responseBody);
        Test.stopTest();
    }
    
    static testMethod void pluralRequestPmdrServiceErrorTest() {
        // init
        SNG_MockCustomSettings.initialize();
        Terminal__c[] terminals = getTerminalsForPluralRequestPmdrServiceErrorTest();
        RestContext.request = getPluralRequest(terminals);

        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new SNG_MockPerformanceLatestHttpCallout());
        
        // do the callout
        SNG_REST_JsonResponse responseBody = SNG_REST_TerminalsStatus.get();
        
        // verify the response
        verifyResponseForPluralRequestPmdrServiceErrorTest(responseBody);
        Test.stopTest();
    }
    
    static testMethod void pluralRequestPmdrServiceBugTest() {
        // init
        SNG_MockCustomSettings.initialize();
        Terminal__c[] terminals = getTerminalsForPluralRequestPmdrServiceBugTest();
        RestContext.request = getPluralRequest(terminals);

        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new SNG_MockPerformanceLatestHttpCallout());
        
        // do the callout
        SNG_REST_JsonResponse responseBody = SNG_REST_TerminalsStatus.get();
        
        // verify the response
        verifyResponseForPluralRequestPmdrServiceBugTest(responseBody);
        Test.stopTest();
    }
    
    static testMethod void pluralRequestNullRequestTest() {
        // init
        SNG_MockCustomSettings.initialize();
        RestContext.request = null;

        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new SNG_MockPerformanceLatestHttpCallout());
        
        try {
            // do the callout
            SNG_REST_JsonResponse responseBody = SNG_REST_TerminalsStatus.get();
            System.assert(false);
        } catch (SNG_Exception e) {
            // verify the exception
            System.assert(null != e);
        }
        Test.stopTest();
    }    

    // *****************************************************
    // TEST SNG_REST_TerminalStatusUnitTest 
    // ******************************************************
    static testMethod void singularRequestSuccessTest() {
        // init
        SNG_MockCustomSettings.initialize();
        Terminal__c terminal = getTerminalForSingularRequestSuccessTest();
        RestContext.request = getSingularRequest(terminal);

        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new SNG_MockPerformanceLatestHttpCallout());
        
        // do the callout
        SNG_REST_JsonResponse responseBody = SNG_REST_TerminalStatus.get();
        
        // verify the response
        verifyResponseForSingularRequestSuccessTest(terminal, responseBody);
        
        Test.stopTest();
    }
    
    static testMethod void singularRequestInvalidIdTest() {
        // init
        SNG_MockCustomSettings.initialize();
        String terminalIdName = getTerminalNameForSingularRequestInvalidIdTest();
        RestContext.request = getSingularRequest(terminalIdName);

        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new SNG_MockPerformanceLatestHttpCallout());
        
        // do the callout
        SNG_REST_JsonResponse responseBody = SNG_REST_TerminalStatus.get();
        
        // verify the response
        verifyResponseForSingularRequestInvalidIdTest(responseBody);
        Test.stopTest();
    }
    
    static testMethod void singularRequestNoTerminalsOnAccountTest() {
        // init
        SNG_MockCustomSettings.initialize();
        Terminal__c terminal = getTerminalForSingularRequestNoTerminalsOnAccountTest();
        RestContext.request = getSingularRequest(terminal);

        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new SNG_MockPerformanceLatestHttpCallout());
        
        // do the callout
        SNG_REST_JsonResponse responseBody = SNG_REST_TerminalStatus.get();
        
        // verify the response
        verifyResponseForSingularRequestNoTerminalsOnAccountTest(responseBody);
        Test.stopTest();
    }
    
    static testMethod void ingularRequestTerminalModemNotAssociatedTest() {
        // init
        SNG_MockCustomSettings.initialize();
        Terminal__c terminal = getTerminalForSingularRequestTerminalModemNotAssociatedTest();
        RestContext.request = getSingularRequest(terminal);

        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new SNG_MockPerformanceLatestHttpCallout());
        
        // do the callout
        SNG_REST_JsonResponse responseBody = SNG_REST_TerminalStatus.get();
        
        // verify the response
        verifyResponseForSingularRequestTerminalModemNotAssociatedTest(responseBody);
        Test.stopTest();
    }
    
    static testMethod void singularRequestPmdrServiceErrorTest() {
        // init
        SNG_MockCustomSettings.initialize();
        Terminal__c terminal = getTerminalForSingularRequestPmdrServiceErrorTest();
        RestContext.request = getSingularRequest(terminal);

        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new SNG_MockPerformanceLatestHttpCallout());
        
        // do the callout
        SNG_REST_JsonResponse responseBody = SNG_REST_TerminalStatus.get();
        
        // verify the response
        verifyResponseForSingularRequestPmdrServiceErrorTest(responseBody);
        Test.stopTest();
    }
    
    static testMethod void singularRequestPmdrServiceBugTest() {
        // init
        SNG_MockCustomSettings.initialize();
        Terminal__c terminal = getTerminalForSingularRequestPmdrServiceBugTest();
        RestContext.request = getSingularRequest(terminal);

        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new SNG_MockPerformanceLatestHttpCallout());
        
        // do the callout
        SNG_REST_JsonResponse responseBody = SNG_REST_TerminalStatus.get();
        
        // verify the response
        verifyResponseForSingularRequestPmdrServiceBugTest(responseBody);
        Test.stopTest();
    }
    
    static testMethod void singularRequestNullRequestTest() {
        // init
        SNG_MockCustomSettings.initialize();
        Terminal__c terminal = null;
        RestContext.request = getSingularRequest(terminal);

        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new SNG_MockPerformanceLatestHttpCallout());
        
        // do the callout
        SNG_REST_JsonResponse responseBody = SNG_REST_TerminalStatus.get();
        verifyResponseForSingularRequestNullRestRequestTest(responseBody);

        Test.stopTest();
    }

    // ******************************************************
    // TEST SNG_REST_TerminalStatusHandler
    // ******************************************************
    
    // Equivalent to 9999:99:99:99 (DAYS:HH:MM:SS)
    private static final Long MAX_ONLINE_TIME = 864276039;
    
    // START Handle Plural Request Tests
    
    static testMethod void handlePluralRequestSuccessTest() {
        // init
        initTest();
        Terminal__c[] terminals = getTerminalsForPluralRequestSuccessTest();
        RestRequest req = getPluralRequest(terminals);
        startTestAndSetMock();
        
        // do the callout
        SNG_REST_Response response = new SNG_REST_TerminalStatusHandler().handleRequest(req);
        
        // verify the response
        verifyResponseForPluralRequestSuccessTest(terminals, new SNG_REST_JsonResponse(response));
        
        // stop the test
        Test.stopTest();
    }

    static testMethod void handlePluralRequestPmdrZeroResultsTest() {
        // init
        initTest();
        Terminal__c[] terminals = getTerminalsForPluralRequestPmdrServiceZeroResults();
        RestRequest req = getPluralRequest(terminals);
        startTestAndSetMock();
        
        // do the callout
        SNG_REST_Response response = new SNG_REST_TerminalStatusHandler().handleRequest(req);
        
        // verify the response
        verifyResponseForPluralRequestPmdrZeroResultsTest(terminals, new SNG_REST_JsonResponse(response));
        
        // stop the test
        Test.stopTest();
    }
    
    static testMethod void handlePluralRequestInvalidIdTest() {
        // init
        initTest();
        String[] terminalIdNames = getTerminalNamesForPluralRequestInvalidIdTest();
        RestRequest req = getPluralRequest(terminalIdNames);
        startTestAndSetMock();
        
        // do the callout
        SNG_REST_Response response = new SNG_REST_TerminalStatusHandler().handleRequest(req);
        
        // verify the response
        verifyResponseForPluralRequestInvalidIdTest(terminalIdNames, new SNG_REST_JsonResponse(response));
        
        // stop the test
        Test.stopTest();
    }
    
    static testMethod void handlePluralRequestTerminalNotOnAccountTest() {
        // init
        initTest();
        Terminal__c[] terminals = getTerminalsForPluralRequestTerminalNotOnAccountTest();
        RestRequest req = getPluralRequest(terminals);
        startTestAndSetMock();
        
        // do the callout
        SNG_REST_Response response = new SNG_REST_TerminalStatusHandler().handleRequest(req);
        
        // verify the response
        verifyResponseForPluralRequestTerminalNotOnAccountTest(terminals, new SNG_REST_JsonResponse(response));
        
        // stop the test
        Test.stopTest();
    }
    
    static testMethod void handlePluralRequestNoTerminalsOnAccountTest() {
        // init
        initTest();
        Terminal__c[] terminals = getTerminalsForPluralRequestNoTerminalsOnAccountTest();
        RestRequest req = getPluralRequest(terminals);
        startTestAndSetMock();
        
        // do the callout
        SNG_REST_Response response = new SNG_REST_TerminalStatusHandler().handleRequest(req);
        
        // verify the response
        verifyResponseForPluralRequestNoTerminalsOnAccountTest(new SNG_REST_JsonResponse(response));
        
        // stop the test
        Test.stopTest();
    }
    
    static testMethod void handlePluralRequestTerminalModemNotAssociatedTest() {
        // init
        initTest();
        Terminal__c[] terminals = getTerminalsForPluralRequestTerminalModemNotAssociatedTest();
        RestRequest req = getPluralRequest(terminals);
        startTestAndSetMock();
        
        // do the callout
        SNG_REST_Response response = new SNG_REST_TerminalStatusHandler().handleRequest(req);
        
        // verify the response
        verifyResponseForPluralRequestTerminalModemNotAssociatedTest(terminals, new SNG_REST_JsonResponse(response));
        
        // stop the test
        Test.stopTest();
    }
 
    static testMethod void handlePluralRequestPmdrServiceErrorTest() {
        // init
        initTest();
        Terminal__c[] terminals = getTerminalsForPluralRequestPmdrServiceErrorTest();
        RestRequest req = getPluralRequest(terminals);
        startTestAndSetMock();
        
        // do the callout
        SNG_REST_Response response = new SNG_REST_TerminalStatusHandler().handleRequest(req);
        
        // verify the response
        verifyResponseForPluralRequestPmdrServiceErrorTest(new SNG_REST_JsonResponse(response));
        
        // stop the test
        Test.stopTest();
    } 

    static testMethod void handlePluralRequestPmdrServiceBugTest() {
        // init
        initTest();
        Terminal__c[] terminals = getTerminalsForPluralRequestPmdrServiceBugTest();
        RestRequest req = getPluralRequest(terminals);
        startTestAndSetMock();
        
        // do the callout
        SNG_REST_Response response = new SNG_REST_TerminalStatusHandler().handleRequest(req);
        
        // verify the response
        verifyResponseForPluralRequestPmdrServiceBugTest(new SNG_REST_JsonResponse(response));
        
        // stop the test
        Test.stopTest();
    }
    
    // END Handle Plural Request Tests
    
 
    // START Handle Singular Request Tests
    
    static testMethod void handleSingularRequestSuccessTest() {
        // init
        initTest();
        Terminal__c terminal = getTerminalForSingularRequestSuccessTest();
        RestRequest req = getSingularRequest(terminal);
        startTestAndSetMock();
        
        // do the callout
        SNG_REST_JsonResponse jsonResponse = new SNG_REST_Instance().handleRequest(req, new SNG_REST_TerminalStatusHandler());
        
        // verify the response
        verifyResponseForSingularRequestSuccessTest(terminal, jsonResponse);
        
        // stop the test
        Test.stopTest();
    }
    
    static testMethod void handleSingularRequestInvalidIdTest() {
        // init
        initTest();
        String terminalIdName = getTerminalNameForSingularRequestInvalidIdTest();
        RestRequest req = getSingularRequest(terminalIdName);
        startTestAndSetMock();
        
        // do the callout
        SNG_REST_JsonResponse jsonResponse = new SNG_REST_Instance().handleRequest(req, new SNG_REST_TerminalStatusHandler());
        
        // verify the response
        verifyResponseForSingularRequestInvalidIdTest(jsonResponse);
        
        // stop the test
        Test.stopTest();
    }
    
    static testMethod void handleSingularRequestNoTerminalsOnAccountTest() {
        // init
        initTest();
        Terminal__c terminal = getTerminalForSingularRequestNoTerminalsOnAccountTest();
        RestRequest req = getSingularRequest(terminal);
        startTestAndSetMock();
        
        // do the callout
        SNG_REST_JsonResponse jsonResponse = new SNG_REST_Instance().handleRequest(req, new SNG_REST_TerminalStatusHandler());
        
        // verify the response
        verifyResponseForSingularRequestNoTerminalsOnAccountTest(jsonResponse);
        
        // stop the test
        Test.stopTest();
    }
    
    static testMethod void handleSingularRequestTerminalModemNotAssociatedTest() {
        // init
        initTest();
        Terminal__c terminal = getTerminalForSingularRequestTerminalModemNotAssociatedTest();
        RestRequest req = getSingularRequest(terminal);
        startTestAndSetMock();
        
        // do the callout
        SNG_REST_JsonResponse jsonResponse = new SNG_REST_Instance().handleRequest(req, new SNG_REST_TerminalStatusHandler());
        
        // verify the response
        verifyResponseForSingularRequestTerminalModemNotAssociatedTest(jsonResponse);
        
        // stop the test
        Test.stopTest();
    }
    
    static testMethod void handleSingularRequestPmdrServiceErrorTest() {
        // init
        initTest();
        Terminal__c terminal = getTerminalForSingularRequestPmdrServiceErrorTest();
        RestRequest req = getSingularRequest(terminal);
        startTestAndSetMock();
        
        // do the callout
        SNG_REST_JsonResponse jsonResponse = new SNG_REST_Instance().handleRequest(req, new SNG_REST_TerminalStatusHandler());
        
        // verify the response
        verifyResponseForSingularRequestPmdrServiceErrorTest(jsonResponse);
        
        // stop the test
        Test.stopTest();
    }
    
    static testMethod void handleSingularRequestPmdrServiceBugTest() {
        // init
        initTest();
        Terminal__c terminal = getTerminalForSingularRequestPmdrServiceBugTest();
        RestRequest req = getSingularRequest(terminal);
        startTestAndSetMock();
        
        // do the callout
        SNG_REST_JsonResponse jsonResponse = new SNG_REST_Instance().handleRequest(req, new SNG_REST_TerminalStatusHandler());
        
        // verify the response
        verifyResponseForSingularRequestPmdrServiceBugTest(jsonResponse);
        
        // stop the test
        Test.stopTest();
    }
    
    static testMethod void handleSingularRequestNullRequestTest() {
        // init
        initTest();
        Terminal__c terminal = null;
        RestRequest req = getSingularRequest(terminal);
        startTestAndSetMock();
        

        SNG_REST_JsonResponse jsonResponse = new SNG_REST_Instance().handleRequest(req, new SNG_REST_TerminalStatusHandler());
        verifyResponseForSingularRequestNullRestRequestTest(jsonResponse); 
        
        // stop the test
        Test.stopTest();
    }
    
    // END Handle Singular Request Tests
    
    
    // START Json Response Output Tests
    
    static testMethod void SNG_REST_JsonResponseOutputInvalidTerminalIdTest() {
        String terminalId = 'INVALID_TERMINAL_ID';
        SNG_REST_StatusLight.Status status =  SNG_REST_StatusLight.Status.NO_ISSUES;
        SNG_REST_StatusLight.Status network = SNG_REST_StatusLight.Status.NO_ISSUES;
        SNG_REST_StatusLight.Status weather = SNG_REST_StatusLight.Status.NO_ISSUES;
        SNG_REST_StatusLight.Status performance = SNG_REST_StatusLight.Status.NO_ISSUES;
        SNG_REST_StatusLight.Status pointing = SNG_REST_StatusLight.Status.NO_ISSUES;
        Long onlineTime = MAX_ONLINE_TIME;
        
        try {
            SNG_REST_TerminalStatusHandler.TerminalPerformanceLatestOutput jsonResponseOutput 
                = new SNG_REST_TerminalStatusHandler.TerminalPerformanceLatestOutput(terminalId, status, network, weather, 
                                                                                  performance, pointing, onlineTime);
            System.assert(false);
        } catch (SNG_REST_JsonResponseOutput.ValidationException e) {
            System.assert(e.getMessage().toLowerCase().contains('invalid terminal id'));
        }
    }
    
    static testMethod void SNG_REST_JsonResponseOutputNullStatusTest() {
        String terminalId = 'T0000';
        SNG_REST_StatusLight.Status status =  null;
        SNG_REST_StatusLight.Status network = SNG_REST_StatusLight.Status.NO_ISSUES;
        SNG_REST_StatusLight.Status weather = SNG_REST_StatusLight.Status.NO_ISSUES;
        SNG_REST_StatusLight.Status performance = SNG_REST_StatusLight.Status.NO_ISSUES;
        SNG_REST_StatusLight.Status pointing = SNG_REST_StatusLight.Status.NO_ISSUES;
        Long onlineTime = MAX_ONLINE_TIME;
        
        try {
            SNG_REST_TerminalStatusHandler.TerminalPerformanceLatestOutput jsonResponseOutput 
                = new SNG_REST_TerminalStatusHandler.TerminalPerformanceLatestOutput(terminalId, status, network, weather, 
                                                                                  performance, pointing, onlineTime);
            System.assert(false);
        } catch (SNG_REST_JsonResponseOutput.ValidationException e) {
            System.assert(e.getMessage().toLowerCase().contains('null status'));
        }
    }
    
    static testMethod void SNG_REST_JsonResponseOutputNullNetworkTest() {
        String terminalId = 'T0000';
        SNG_REST_StatusLight.Status status =  SNG_REST_StatusLight.Status.NO_ISSUES;
        SNG_REST_StatusLight.Status network = null;
        SNG_REST_StatusLight.Status weather = SNG_REST_StatusLight.Status.NO_ISSUES;
        SNG_REST_StatusLight.Status performance = SNG_REST_StatusLight.Status.NO_ISSUES;
        SNG_REST_StatusLight.Status pointing = SNG_REST_StatusLight.Status.NO_ISSUES;
        Long onlineTime = MAX_ONLINE_TIME;
        
        try {
            SNG_REST_TerminalStatusHandler.TerminalPerformanceLatestOutput jsonResponseOutput 
                = new SNG_REST_TerminalStatusHandler.TerminalPerformanceLatestOutput(terminalId, status, network, weather, 
                                                                                  performance, pointing, onlineTime);
            System.assert(false);
        } catch (SNG_REST_JsonResponseOutput.ValidationException e) {
            System.assert(e.getMessage().toLowerCase().contains('null status'));
        }
    }
    
    static testMethod void SNG_REST_JsonResponseOutputNullWeatherTest() {
        String terminalId = 'T0000';
        SNG_REST_StatusLight.Status status =  SNG_REST_StatusLight.Status.NO_ISSUES;
        SNG_REST_StatusLight.Status network = SNG_REST_StatusLight.Status.NO_ISSUES;
        SNG_REST_StatusLight.Status weather = null;
        SNG_REST_StatusLight.Status performance = SNG_REST_StatusLight.Status.NO_ISSUES;
        SNG_REST_StatusLight.Status pointing = SNG_REST_StatusLight.Status.NO_ISSUES;
        Long onlineTime = MAX_ONLINE_TIME;
        
        try {
            SNG_REST_TerminalStatusHandler.TerminalPerformanceLatestOutput jsonResponseOutput 
                = new SNG_REST_TerminalStatusHandler.TerminalPerformanceLatestOutput(terminalId, status, network, weather, 
                                                                                  performance, pointing, onlineTime);
            System.assert(false);
        } catch (SNG_REST_JsonResponseOutput.ValidationException e) {
            System.assert(e.getMessage().toLowerCase().contains('null status'));
        }
    }
    
    static testMethod void SNG_REST_JsonResponseOutputNullPerformanceTest() {
        String terminalId = 'T0000';
        SNG_REST_StatusLight.Status status =  SNG_REST_StatusLight.Status.NO_ISSUES;
        SNG_REST_StatusLight.Status network = SNG_REST_StatusLight.Status.NO_ISSUES;
        SNG_REST_StatusLight.Status weather = SNG_REST_StatusLight.Status.NO_ISSUES;
        SNG_REST_StatusLight.Status performance = null;
        SNG_REST_StatusLight.Status pointing = SNG_REST_StatusLight.Status.NO_ISSUES;
        Long onlineTime = MAX_ONLINE_TIME;
        
        try {
            SNG_REST_TerminalStatusHandler.TerminalPerformanceLatestOutput jsonResponseOutput 
                = new SNG_REST_TerminalStatusHandler.TerminalPerformanceLatestOutput(terminalId, status, network, weather, 
                                                                                  performance, pointing, onlineTime);
            System.assert(false);
        } catch (SNG_REST_JsonResponseOutput.ValidationException e) {
            System.assert(e.getMessage().toLowerCase().contains('null status'));
        }
    }
    
    static testMethod void SNG_REST_JsonResponseOutputNullPointingTest() {
        String terminalId = 'T0000';
        SNG_REST_StatusLight.Status status =  SNG_REST_StatusLight.Status.NO_ISSUES;
        SNG_REST_StatusLight.Status network = SNG_REST_StatusLight.Status.NO_ISSUES;
        SNG_REST_StatusLight.Status weather = SNG_REST_StatusLight.Status.NO_ISSUES;
        SNG_REST_StatusLight.Status performance = SNG_REST_StatusLight.Status.NO_ISSUES;
        SNG_REST_StatusLight.Status pointing = null;
        Long onlineTime = MAX_ONLINE_TIME;
        
        try {
            SNG_REST_TerminalStatusHandler.TerminalPerformanceLatestOutput jsonResponseOutput 
                = new SNG_REST_TerminalStatusHandler.TerminalPerformanceLatestOutput(terminalId, status, network, weather, 
                                                                                  performance, pointing, onlineTime);
            System.assert(false);
        } catch (SNG_REST_JsonResponseOutput.ValidationException e) {
            System.assert(e.getMessage().toLowerCase().contains('null status'));
        }
    }
    
    static testMethod void SNG_REST_JsonResponseOutputNullOnlineTimeTest() {
        String terminalId = 'T0000';
        SNG_REST_StatusLight.Status status =  SNG_REST_StatusLight.Status.NO_ISSUES;
        SNG_REST_StatusLight.Status network = SNG_REST_StatusLight.Status.NO_ISSUES;
        SNG_REST_StatusLight.Status weather = SNG_REST_StatusLight.Status.NO_ISSUES;
        SNG_REST_StatusLight.Status performance = SNG_REST_StatusLight.Status.NO_ISSUES;
        SNG_REST_StatusLight.Status pointing = SNG_REST_StatusLight.Status.NO_ISSUES;
        Long onlineTime = null;
        
        try {
            SNG_REST_TerminalStatusHandler.TerminalPerformanceLatestOutput jsonResponseOutput 
                = new SNG_REST_TerminalStatusHandler.TerminalPerformanceLatestOutput(terminalId, status, network, weather, 
                                                                                  performance, pointing, onlineTime);
            System.assert(false);
        } catch (SNG_REST_JsonResponseOutput.ValidationException e) {
            System.assert(e.getMessage().toLowerCase().contains('invalid online time'));
        }
    }
    
    static testMethod void SNG_REST_JsonResponseOutputNegativeOnlineTimeTest() {
        String terminalId = 'T0000';
        SNG_REST_StatusLight.Status status =  SNG_REST_StatusLight.Status.NO_ISSUES;
        SNG_REST_StatusLight.Status network = SNG_REST_StatusLight.Status.NO_ISSUES;
        SNG_REST_StatusLight.Status weather = SNG_REST_StatusLight.Status.NO_ISSUES;
        SNG_REST_StatusLight.Status performance = SNG_REST_StatusLight.Status.NO_ISSUES;
        SNG_REST_StatusLight.Status pointing = SNG_REST_StatusLight.Status.NO_ISSUES;
        Long onlineTime = -1;
        
        try {
            SNG_REST_TerminalStatusHandler.TerminalPerformanceLatestOutput jsonResponseOutput 
                = new SNG_REST_TerminalStatusHandler.TerminalPerformanceLatestOutput(terminalId, status, network, weather, 
                                                                                  performance, pointing, onlineTime);
            System.assert(false);
        } catch (SNG_REST_JsonResponseOutput.ValidationException e) {
            System.assert(e.getMessage().toLowerCase().contains('invalid online time'));
        }
    }
    
    static testMethod void SNG_REST_JsonResponseNetworkOutOfBoundsTest() {
        String terminalId = 'T0000';
        SNG_REST_StatusLight.Status status =  SNG_REST_StatusLight.Status.NO_ISSUES;
        SNG_REST_StatusLight.Status network = SNG_REST_StatusLight.Status.MINOR_ISSUES;
        SNG_REST_StatusLight.Status weather = SNG_REST_StatusLight.Status.NO_ISSUES;
        SNG_REST_StatusLight.Status performance = SNG_REST_StatusLight.Status.NO_ISSUES;
        SNG_REST_StatusLight.Status pointing = SNG_REST_StatusLight.Status.NO_ISSUES;
        Long onlineTime = MAX_ONLINE_TIME;
        
        try {
            SNG_REST_TerminalStatusHandler.TerminalPerformanceLatestOutput jsonResponseOutput 
                = new SNG_REST_TerminalStatusHandler.TerminalPerformanceLatestOutput(terminalId, status, network, weather, 
                                                                                  performance, pointing, onlineTime);
            System.assert(false);
        } catch (SNG_REST_JsonResponseOutput.ValidationException e) {
            System.assert(e.getMessage().toLowerCase().contains('invalid network'));
        }
    }
    
    static testMethod void SNG_REST_JsonResponseWeatherOutOfBoundsTest() {
        String terminalId = 'T0000';
        SNG_REST_StatusLight.Status status =  SNG_REST_StatusLight.Status.NO_ISSUES;
        SNG_REST_StatusLight.Status network = SNG_REST_StatusLight.Status.NO_ISSUES;
        SNG_REST_StatusLight.Status weather = SNG_REST_StatusLight.Status.OFFLINE;
        SNG_REST_StatusLight.Status performance = SNG_REST_StatusLight.Status.NO_ISSUES;
        SNG_REST_StatusLight.Status pointing = SNG_REST_StatusLight.Status.NO_ISSUES;
        Long onlineTime = MAX_ONLINE_TIME;
        
        try {
            SNG_REST_TerminalStatusHandler.TerminalPerformanceLatestOutput jsonResponseOutput 
                = new SNG_REST_TerminalStatusHandler.TerminalPerformanceLatestOutput(terminalId, status, network, weather, 
                                                                                  performance, pointing, onlineTime);
            System.assert(false);
        } catch (SNG_REST_JsonResponseOutput.ValidationException e) {
            System.assert(e.getMessage().toLowerCase().contains('invalid weather'));
        }
    }
    
    static testMethod void SNG_REST_JsonResponseCompareToInvalidTypeTest() {
        String terminalId = 'T0000';
        SNG_REST_StatusLight.Status status =  SNG_REST_StatusLight.Status.NO_ISSUES;
        SNG_REST_StatusLight.Status network = SNG_REST_StatusLight.Status.NO_ISSUES;
        SNG_REST_StatusLight.Status weather = SNG_REST_StatusLight.Status.NO_ISSUES;
        SNG_REST_StatusLight.Status performance = SNG_REST_StatusLight.Status.NO_ISSUES;
        SNG_REST_StatusLight.Status pointing = SNG_REST_StatusLight.Status.NO_ISSUES;
        Long onlineTime = 5;
        
        SNG_REST_TerminalStatusHandler.TerminalPerformanceLatestOutput jsonResponseOutput 
            = new SNG_REST_TerminalStatusHandler.TerminalPerformanceLatestOutput(terminalId, status, network, weather, 
                                                                              performance, pointing, onlineTime);
        
        try {
            jsonResponseOutput.compareTo(5);
            System.assert(false);
        } catch (SNG_Exception e) {
            System.assert(true);
        }
    }
    
    static testMethod void SNG_REST_JsonResponseHashCodeEqualsTest() {
        final String terminalId = 'T0291';
        final SNG_REST_StatusLight.Status status = SNG_REST_StatusLight.Status.SEVERE_ISSUES;
        final SNG_REST_StatusLight.Status network = SNG_REST_StatusLight.Status.NO_ISSUES;
        final SNG_REST_StatusLight.Status weather = SNG_REST_StatusLight.Status.MINOR_ISSUES;
        final SNG_REST_StatusLight.Status performance = SNG_REST_StatusLight.Status.OFFLINE;
        final SNG_REST_StatusLight.Status pointing = SNG_REST_StatusLight.Status.NO_ISSUES;
        final Long onlineTime = 1000L;
        
        SNG_REST_TerminalStatusHandler.TerminalPerformanceLatestOutput perfLatest1 
            = new SNG_REST_TerminalStatusHandler.TerminalPerformanceLatestOutput(
                terminalId, status, network, weather, performance, pointing, onlineTime);
        SNG_REST_TerminalStatusHandler.TerminalPerformanceLatestOutput perfLatest2 
            = new SNG_REST_TerminalStatusHandler.TerminalPerformanceLatestOutput(
                terminalId, status, network, weather, performance, pointing, onlineTime);
        
        System.assertEquals(perfLatest1, perfLatest1);
        System.assertEquals(perfLatest1.hashCode(), perfLatest1.hashCode());
        
        System.assertEquals(perfLatest2, perfLatest2);
        System.assertEquals(perfLatest2.hashCode(), perfLatest2.hashCode());
        
        System.assertEquals(perfLatest1, perfLatest2);
        System.assertEquals(perfLatest1.hashCode(), perfLatest2.hashCode());
    }
    
    static testMethod void SNG_REST_JsonResponseHashCodeNotEqualsTest() {
        final String terminalId1 = 'T0291';
        final String terminalId2 = 'T0292';
        final SNG_REST_StatusLight.Status status = SNG_REST_StatusLight.Status.SEVERE_ISSUES;
        final SNG_REST_StatusLight.Status network = SNG_REST_StatusLight.Status.NO_ISSUES;
        final SNG_REST_StatusLight.Status weather = SNG_REST_StatusLight.Status.MINOR_ISSUES;
        final SNG_REST_StatusLight.Status performance = SNG_REST_StatusLight.Status.OFFLINE;
        final SNG_REST_StatusLight.Status pointing = SNG_REST_StatusLight.Status.NO_ISSUES;
        final Long onlineTime = 1000L;
        
        SNG_REST_TerminalStatusHandler.TerminalPerformanceLatestOutput perfLatest1 
            = new SNG_REST_TerminalStatusHandler.TerminalPerformanceLatestOutput(
                terminalId1, status, network, weather, performance, pointing, onlineTime);
        SNG_REST_TerminalStatusHandler.TerminalPerformanceLatestOutput perfLatest2 
            = new SNG_REST_TerminalStatusHandler.TerminalPerformanceLatestOutput(
                terminalId2, status, network, weather, performance, pointing, onlineTime);
        
        System.assertEquals(perfLatest1, perfLatest1);
        System.assertEquals(perfLatest1.hashCode(), perfLatest1.hashCode());
        
        System.assertEquals(perfLatest2, perfLatest2);
        System.assertEquals(perfLatest2.hashCode(), perfLatest2.hashCode());
        
        System.assert(perfLatest1 != perfLatest2);
        System.assert(perfLatest1.hashCode() != perfLatest2.hashCode());
    }
    
    // END Json Response Output Tests

    
    //******************************************************************************
    // HELPER METHODS SNG_REST_TerminalStatusUnitTestHelper
    //******************************************************************************
    /**
     * Resource path for the singular API call
     * NOTE: This must match what's specified in the @RestResource annotation
     * cannot be static since this class is copied as an inner class for SNGRestTest.cls
     */
    private static final String SINGULAR_TERMINAL_STATUS_RESOURCE_PATH = '/terminal/*/status';
    
    /**
     * Resource path for the plural API call
     * NOTE: This must match what's specified in the @RestResource annotation
     * cannot be static since this class is copied as an inner class for SNGRestTest.cls
     */
    private static final String PLURAL_TERMINAL_STATUS_RESOURCE_PATH = '/terminals/status';
    
    public static void initTest() {
        // initialize custom settings
        SNG_MockCustomSettings.initialize();
    }
    
    public static void startTestAndSetMock() {
        // start the test and set the mock for the http callout
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new SNG_MockPerformanceLatestHttpCallout());
    }
    
    public static RestRequest getSingularRequest(Terminal__c terminal) {
        return (null == terminal ? null : getSingularRequest(terminal.Name));
    }
    
    public static RestRequest getSingularRequest(String terminalIdName) {
        RestRequest req = new RestRequest();
        
        req.requestURI = '/terminal/' + terminalIdName + '/status';
        req.resourcePath = SINGULAR_TERMINAL_STATUS_RESOURCE_PATH;
        
        // set the request method
        req.httpMethod = 'GET';
        
        // Print out the request URI for debug
        System.debug('Singular Request URI for terminalIdName [' + terminalIdName + ']: ' + req.requestUri);
        
        return req;
    }
    
    public static RestRequest getPluralRequest(Terminal__c[] terminals) {
        String[] terminalIdNames = getTerminalIdNames(terminals);
        return getPluralRequest(terminalIdNames);
    }
    
    public static RestRequest getPluralRequest(String[] terminalIdNames) {
        RestRequest req = new RestRequest();
        
        String joinedTerminalIdNames = StringUtils.joinStrings(terminalIdNames, ',');
        req.requestURI = PLURAL_TERMINAL_STATUS_RESOURCE_PATH + '?' + SNG_REST_Collection.IDS_PARAM + '=' + joinedTerminalIdNames;
        req.addParameter(SNG_REST_Collection.IDS_PARAM, joinedTerminalIdNames);
        req.resourcePath = PLURAL_TERMINAL_STATUS_RESOURCE_PATH;
        
        // set the request method
        req.httpMethod = 'GET';
        
        // Print out the request URI for debug
        System.debug('Plural Request URI for terminalIdNames [' + terminalIdNames + ']: ' + req.requestUri);
        
        return req;
    }
    
    public static void verifyExceptionForRequestNullRequestTest(SNG_Exception e) {
        System.assert(null != e);
    }
    
    
    
    // START Plural Request Tests
    
    
    public static Terminal__c[] getTerminalsForPluralRequestSuccessTest() {
        Modem__c[] modems = insertModems(SNG_MockPerformanceLatestHttpCallout.SUCCESS_MACADDRS);
        return getTerminalsForModems(modems);
    }

    public static Terminal__c[] getTerminalsForPluralRequestPmdrServiceZeroResults() {
        Modem__c[] modems = insertModems(SNG_MockPerformanceLatestHttpCallout.ZERO_RESULTS_MACADDRS);
        return getTerminalsForModems(modems);
    }
    
    public static void verifyResponseForPluralRequestSuccessTest(Terminal__c[] terminals, SNG_REST_JsonResponse responseBody) {
        SNG_REST_CollectionOutput expectedPerformance = new SNG_REST_CollectionOutput(
            new SNG_REST_TerminalStatusHandler.TerminalPerformanceLatestOutput[] {
                new SNG_REST_TerminalStatusHandler.TerminalPerformanceLatestOutput(
                    terminals[0].Name, 
                    SNG_REST_StatusLight.Status.NO_ISSUES, // Status
                    SNG_REST_StatusLight.Status.NO_ISSUES, // Network
                    SNG_REST_StatusLight.Status.NO_ISSUES, // Weather
                    SNG_REST_StatusLight.Status.NO_ISSUES, // Performance
                    SNG_REST_StatusLight.Status.NO_ISSUES, // Pointing
                    SNG_SnmpDateAndTimeConverter.translateTimeToDurationFromNow('0x07dd0b0c131714002b0000')
                ),
                new SNG_REST_TerminalStatusHandler.TerminalPerformanceLatestOutput(
                    terminals[1].Name, 
                    SNG_REST_StatusLight.Status.NO_ISSUES, // Status
                    SNG_REST_StatusLight.Status.NO_ISSUES, // Network
                    SNG_REST_StatusLight.Status.NO_ISSUES, // Weather
                    SNG_REST_StatusLight.Status.NO_ISSUES, // Performance
                    SNG_REST_StatusLight.Status.NO_ISSUES, // Pointing
                    SNG_SnmpDateAndTimeConverter.translateTimeToDurationFromNow('0x07dd0b0c131714003b0000')
                )
            }
        );
        
        verifyPluralResponse(responseBody, SNGHttpUtilities.Status.OK, null, null, expectedPerformance);
    }
    
    public static void verifyResponseForPluralRequestPmdrZeroResultsTest(Terminal__c[] terminals, SNG_REST_JsonResponse responseBody)
    {
        SNG_REST_CollectionOutput expectedPerformance = new SNG_REST_CollectionOutput(
            new SNG_REST_TerminalStatusHandler.TerminalPerformanceLatestOutput[] {
                new SNG_REST_TerminalStatusHandler.TerminalPerformanceLatestOutput(
                    terminals[0].Name, 
                    SNG_REST_StatusLight.Status.OFFLINE, // Status
                    SNG_REST_StatusLight.Status.SEVERE_ISSUES, // Network
                    SNG_REST_StatusLight.Status.SEVERE_ISSUES, // Weather
                    SNG_REST_StatusLight.Status.OFFLINE, // Performance
                    SNG_REST_StatusLight.Status.OFFLINE, // Pointing
                    0
                ),
                new SNG_REST_TerminalStatusHandler.TerminalPerformanceLatestOutput(
                    terminals[1].Name, 
                    SNG_REST_StatusLight.Status.OFFLINE, // Status
                    SNG_REST_StatusLight.Status.SEVERE_ISSUES, // Network
                    SNG_REST_StatusLight.Status.SEVERE_ISSUES, // Weather
                    SNG_REST_StatusLight.Status.OFFLINE, // Performance
                    SNG_REST_StatusLight.Status.OFFLINE, // Pointing
                    0
                )
            }
        );
        
        verifyPluralResponse(responseBody, SNGHttpUtilities.Status.OK, null, null, expectedPerformance);        
    }

    
    public static String[] getTerminalNamesForPluralRequestInvalidIdTest() {
        Modem__c[] modems = insertModems(SNG_MockPerformanceLatestHttpCallout.SUCCESS_MACADDRS);
        Terminal__c[] terminals = getTerminalsForModems(modems);
        List<String> terminalIdNames = getTerminalIdNames(terminals);
        terminalIdNames.add('INVALID_TERMINAL_ID');
        return terminalIdNames;
    }
    
    public static void verifyResponseForPluralRequestInvalidIdTest(String[] terminalIdNames, SNG_REST_JsonResponse responseBody) {
        verifyPluralResponse(responseBody, SNGHttpUtilities.Status.INPUT_VALIDATION_ERROR, 
                       SNG_REST_Error.INPUT_INVALID_FORMAT, 
                       SNG_REST_Error.SubCode.SALESFORCE_GENERATED_ERROR, null);
    }
    
    
    public static Terminal__c[] getTerminalsForPluralRequestTerminalNotOnAccountTest() {
        Modem__c[] modems = insertModems(SNG_MockPerformanceLatestHttpCallout.SUCCESS_MACADDRS);
        Terminal__c[] terminals = getTerminalsForModems(modems);
        
        // delete so it's not available on the account
        delete modems[0];
        delete terminals[0];
        
        return terminals;
    }
    
    public static void verifyResponseForPluralRequestTerminalNotOnAccountTest(Terminal__c[] terminals, SNG_REST_JsonResponse responseBody) {
        SNG_REST_CollectionOutput expectedPerformance = new SNG_REST_CollectionOutput(
            new SNG_REST_TerminalStatusHandler.TerminalPerformanceLatestOutput[] {
                new SNG_REST_TerminalStatusHandler.TerminalPerformanceLatestOutput(
                    terminals[1].Name, 
                    SNG_REST_StatusLight.Status.NO_ISSUES, // Status
                    SNG_REST_StatusLight.Status.NO_ISSUES, // Network
                    SNG_REST_StatusLight.Status.NO_ISSUES, // Weather
                    SNG_REST_StatusLight.Status.NO_ISSUES, // Performance
                    SNG_REST_StatusLight.Status.NO_ISSUES, // Pointing
                    SNG_SnmpDateAndTimeConverter.translateTimeToDurationFromNow('0x07dd0b0c131714003b0000')
                )
            }
        );
        
        verifyPluralResponse(responseBody, SNGHttpUtilities.Status.OK_WITH_ERRORS, 
                       SNG_REST_Error.IDS_INVALID, 
                       SNG_REST_Error.SubCode.SALESFORCE_GENERATED_ERROR, expectedPerformance);
    }
    
    
    public static Terminal__c[] getTerminalsForPluralRequestNoTerminalsOnAccountTest() {
        String[] macAddrs = new String[] { '00:a0:bc:99:99:99' };
        Modem__c[] modems = insertModems(macAddrs);
        Terminal__c[] terminals = getTerminalsForModems(modems);
        
        // delete so it's not available on the account
        delete modems[0];
        delete terminals[0];
        
        return terminals;
    }
    
    public static void verifyResponseForPluralRequestNoTerminalsOnAccountTest(SNG_REST_JsonResponse responseBody) {
        verifyPluralResponse(responseBody, SNGHttpUtilities.Status.ZERO_RESULTS, 
                       SNG_REST_Error.IDS_INVALID, 
                       SNG_REST_Error.SubCode.SALESFORCE_GENERATED_ERROR, null);
    }
    
    
    public static Terminal__c[] getTerminalsForPluralRequestTerminalModemNotAssociatedTest() {
        Modem__c[] modems = insertModems(SNG_MockPerformanceLatestHttpCallout.SUCCESS_MACADDRS);
        Terminal__c[] terminals = getTerminalsForModems(modems);
        
        // delete a modem so it's not associated with the corresponding terminal
        delete modems[0];
        
        return terminals;
    }
    
    public static void verifyResponseForPluralRequestTerminalModemNotAssociatedTest(Terminal__c[] terminals, SNG_REST_JsonResponse responseBody) {
        SNG_REST_CollectionOutput expectedPerformance = new SNG_REST_CollectionOutput(
            new SNG_REST_TerminalStatusHandler.TerminalPerformanceLatestOutput[] {
                new SNG_REST_TerminalStatusHandler.TerminalPerformanceLatestOutput(
                    terminals[1].Name, 
                    SNG_REST_StatusLight.Status.NO_ISSUES, // Status
                    SNG_REST_StatusLight.Status.NO_ISSUES, // Network
                    SNG_REST_StatusLight.Status.NO_ISSUES, // Weather
                    SNG_REST_StatusLight.Status.NO_ISSUES, // Performance
                    SNG_REST_StatusLight.Status.NO_ISSUES, // Pointing
                    SNG_SnmpDateAndTimeConverter.translateTimeToDurationFromNow('0x07dd0b0c131714003b0000')
                )
            }
        );
        
        verifyPluralResponse(responseBody, SNGHttpUtilities.Status.OK_WITH_ERRORS, 
                       SNG_REST_Error.TERMINAL_NO_MODEM, 
                       SNG_REST_Error.SubCode.SALESFORCE_GENERATED_ERROR, expectedPerformance);
    }
    
    
    public static Terminal__c[] getTerminalsForPluralRequestPmdrServiceErrorTest() {
        Modem__c[] modems = insertModems(SNG_MockPerformanceLatestHttpCallout.SERVER_ERROR_MACADDRS);
        return getTerminalsForModems(modems);
    }
    
    public static void verifyResponseForPluralRequestPmdrServiceErrorTest(SNG_REST_JsonResponse responseBody) {
        verifyPluralResponse(responseBody, SNGHttpUtilities.Status.SERVER_ERROR, 
                       SNG_REST_Error.GENERIC_WEBSERVICE_ERROR, 
                       SNG_REST_Error.SubCode.WEBSERVICE_GENERATED_ERROR, null);
    }
    
    
    public static Terminal__c[] getTerminalsForPluralRequestPmdrServiceBugTest() {
        Modem__c[] modems = insertModems(SNG_MockPerformanceLatestHttpCallout.SERVER_BUG_MACADDRS);
        return getTerminalsForModems(modems);
    }
    
    public static void verifyResponseForPluralRequestPmdrServiceBugTest(SNG_REST_JsonResponse responseBody) {
        verifyPluralResponse(responseBody, SNGHttpUtilities.Status.SERVER_ERROR, 
                       SNG_REST_Error.GENERIC_WEBSERVICE_ERROR, 
                       SNG_REST_Error.SubCode.SALESFORCE_GENERATED_ERROR, null);
    }
    
    
    // END Handle Plural Request Tests
    
    
    
    // START Handle Singular Request Tests
    
    public static Terminal__c getTerminalForSingularRequestSuccessTest() {
        Modem__c modem = insertModem(SNG_MockPerformanceLatestHttpCallout.SUCCESS_MACADDRS[0]);
        return requeryTerminal(modem.Terminal__r);
    }
    
    public static Terminal__c getTerminalsForSingularRequestPmdrServiceZeroResults() {
        Modem__c modem = insertModem(SNG_MockPerformanceLatestHttpCallout.ZERO_RESULTS_MACADDRS[0]);
        return requeryTerminal(modem.Terminal__r);
    }

    public static void verifyResponseForSingularRequestSuccessTest(Terminal__c terminal, SNG_REST_JsonResponse responseBody) {
        SNG_REST_TerminalStatusHandler.TerminalPerformanceLatestOutput expectedPerformance 
            = new SNG_REST_TerminalStatusHandler.TerminalPerformanceLatestOutput(
                terminal.Name, 
                SNG_REST_StatusLight.Status.NO_ISSUES, // Status
                SNG_REST_StatusLight.Status.NO_ISSUES, // Network
                SNG_REST_StatusLight.Status.NO_ISSUES, // Weather
                SNG_REST_StatusLight.Status.NO_ISSUES, // Performance
                SNG_REST_StatusLight.Status.NO_ISSUES, // Pointing
                SNG_SnmpDateAndTimeConverter.translateTimeToDurationFromNow('0x07dd0b0c131714002b0000')
            );
        
        verifySingularResponse(responseBody, SNGHttpUtilities.Status.OK, null, null, expectedPerformance);
    }

    public static void verifyResponseForSingularRequestPmdrZeroResultsTest(Terminal__c terminal, SNG_REST_JsonResponse responseBody)
    {
        SNG_REST_TerminalStatusHandler.TerminalPerformanceLatestOutput expectedPerformance 
            = new SNG_REST_TerminalStatusHandler.TerminalPerformanceLatestOutput(
                terminal.Name, 
                SNG_REST_StatusLight.Status.OFFLINE, // Status
                SNG_REST_StatusLight.Status.SEVERE_ISSUES, // Network
                SNG_REST_StatusLight.Status.SEVERE_ISSUES, // Weather
                SNG_REST_StatusLight.Status.OFFLINE, // Performance
                SNG_REST_StatusLight.Status.OFFLINE, // Pointing
                0
            );
        
        verifySingularResponse(responseBody, SNGHttpUtilities.Status.OK, null, null, expectedPerformance);        
    }

    
    
    public static String getTerminalNameForSingularRequestInvalidIdTest() {
        return 'INVALID_TERMINAL_ID';
    }
    
    public static void verifyResponseForSingularRequestInvalidIdTest(SNG_REST_JsonResponse responseBody) {
        verifySingularResponse(responseBody, SNGHttpUtilities.Status.INPUT_VALIDATION_ERROR, 
                               SNG_REST_Error.INPUT_INVALID_FORMAT, 
                               SNG_REST_Error.SubCode.SALESFORCE_GENERATED_ERROR, null);
    }
    
    
    public static Terminal__c getTerminalForSingularRequestNoTerminalsOnAccountTest() {
        String macAddr = '00:a0:bc:99:99:99';
        Modem__c modem = insertModem(macAddr);
        Terminal__c terminal = requeryTerminal(modem.Terminal__r);
        
        // delete so it's not available on the account
        delete modem;
        delete terminal;
        
        return terminal;
    }
    
    public static void verifyResponseForSingularRequestNoTerminalsOnAccountTest(SNG_REST_JsonResponse responseBody) {
        verifySingularResponse(responseBody, SNGHttpUtilities.Status.ZERO_RESULTS, 
                               SNG_REST_Error.IDS_INVALID, 
                               SNG_REST_Error.SubCode.SALESFORCE_GENERATED_ERROR, null);
    }
    
    
    public static Terminal__c getTerminalForSingularRequestTerminalModemNotAssociatedTest() {
        String macAddr = SNG_MockPerformanceLatestHttpCallout.SUCCESS_MACADDRS[0];
        Modem__c modem = insertModem(macAddr);
        Terminal__c terminal = requeryTerminal(modem.Terminal__r);
        
        // Disassociate terminal from modem
        modem.Terminal__c = null;
        modem.Terminal__r = null;
        update modem;
        
        return terminal;
    }
    
    public static void verifyResponseForSingularRequestTerminalModemNotAssociatedTest(SNG_REST_JsonResponse responseBody) {
        verifySingularResponse(responseBody, SNGHttpUtilities.Status.ZERO_RESULTS, 
                               SNG_REST_Error.TERMINAL_NO_MODEM, 
                               SNG_REST_Error.SubCode.SALESFORCE_GENERATED_ERROR, null);
    }
    
    
    public static Terminal__c getTerminalForSingularRequestPmdrServiceErrorTest() {
        Modem__c modem = insertModem(SNG_MockPerformanceLatestHttpCallout.SERVER_ERROR_MACADDRS[0]);
        return requeryTerminal(modem.Terminal__r);
    }
    
    public static void verifyResponseForSingularRequestPmdrServiceErrorTest(SNG_REST_JsonResponse responseBody) {
        verifySingularResponse(responseBody, SNGHttpUtilities.Status.SERVER_ERROR, 
                               SNG_REST_Error.GENERIC_WEBSERVICE_ERROR, 
                               SNG_REST_Error.SubCode.WEBSERVICE_GENERATED_ERROR, null);
    }

    public static void verifyResponseForSingularRequestNullRestRequestTest(SNG_REST_JsonResponse responseBody) {
        verifySingularResponse(responseBody, SNGHttpUtilities.Status.SERVER_ERROR, 
                               SNG_REST_ERROR.INTERNAL_SERVER_ERROR, 
                               SNG_REST_Error.SubCode.SALESFORCE_GENERATED_ERROR, null);
    }
    
    
    public static Terminal__c getTerminalForSingularRequestPmdrServiceBugTest() {
        Modem__c modem = insertModem(SNG_MockPerformanceLatestHttpCallout.SERVER_BUG_MACADDRS[0]);
        return requeryTerminal(modem.Terminal__r);
    }
    
    public static void verifyResponseForSingularRequestPmdrServiceBugTest(SNG_REST_JsonResponse responseBody) {
        verifySingularResponse(responseBody, SNGHttpUtilities.Status.SERVER_ERROR, 
                               SNG_REST_Error.GENERIC_WEBSERVICE_ERROR, 
                               SNG_REST_Error.SubCode.SALESFORCE_GENERATED_ERROR, null);
    }
    
    
    // END Handle Singular Request Tests
    
    
    
    
    // START Private Helper Methods
    
    private static Terminal__c requeryTerminal(Terminal__c terminal) {
        final SNG_SObjectQueryBuilder queryBuilder = new SNG_SObjectQueryBuilder(SNG_SObjectQueryBuilder.TERMINAL_OBJ_NAME);
        queryBuilder.addAllFields();
        String queryStr = queryBuilder.constructQuery() + ' WHERE Id=\'' + terminal.Id + '\'';
        return Database.query(queryStr);
    }
    
    private static Modem__c[] insertModems(String[] macAddrs) {
        Account acct = SNG_TestUtilities.insertAccount('testAccount');
        
        Modem__c[] modems = new Modem__c[macAddrs.size()];
        
        for (Integer i = 0; i < macAddrs.size(); ++i) {
            modems[i] = insertModem(macAddrs[i], acct, i);
        }
        
        return modems;
    }
    
    private static Modem__c insertModem(String macAddr) {
        return insertModem(macAddr, SNG_TestUtilities.insertAccount('testAccount'), 0);
    }
    
    private static Modem__c insertModem(String macAddr, Account acct, Integer index) {
        return SNG_TestUtilities.insertEquipment('Terminal_' + index, macAddr, acct, String.valueOf(index), true);
    }
    
    private static Id[] getTerminalIdsForModems(Modem__c[] modems) {
        List<Id> terminalIds = new List<Id>();
        
        for (Modem__c modem : modems) {
            terminalIds.add(modem.Terminal__c);
        }
        
        return terminalIds;
    }
    
    private static Terminal__c[] getTerminalsForModems(Modem__c[] modems) {
        Id[] terminalIds = getTerminalIdsForModems(modems);
        
        Terminal__c[] terminals = [SELECT Id, Name, PeersOnlineBackEnd__c, PeersAvgUploadSymbolRateBackEnd__c, DownloadSinrBackEnd__c, 
                                   UploadSymbolRateBackEnd__c, Status__c, Network__c, WeatherBackEnd__c, Performance__c, Pointing__c, 
                                   OnlineTime__c FROM Terminal__c WHERE Id IN :terminalIds];
        
        return terminals;
    }
    
    private static String[] getTerminalIdNames(Terminal__c[] terminals) {
        List<String> terminalIdNames = new List<String>();
        
        for (Terminal__c terminal : terminals) {
            terminalIdNames.add(terminal.Name);
        }
        
        return terminalIdNames;
    }
    
    private static void verifyPluralResponse(final SNG_REST_JsonResponse responseBody, final SNGHttpUtilities.Status status, 
                                       final String errorMessage, final SNG_REST_Error.SubCode errorSubCode, final SNG_REST_CollectionOutput termPerf) {
        System.assertEquals(status.name(), responseBody.status);
        System.assertEquals(errorMessage, responseBody.errorMessage);
        System.assertEquals(SNG_REST_Error.getErrorCode(status, errorSubCode), responseBody.errorCode);
        
        SNG_REST_CollectionOutput responseBodyData = (SNG_REST_CollectionOutput) responseBody.data;
        verifyResponseData(termPerf, responseBodyData);
    }
    
    private static void verifySingularResponse(final SNG_REST_JsonResponse responseBody, final SNGHttpUtilities.Status status, 
                                               final String errorMessage, final SNG_REST_Error.SubCode errorSubCode, final SNG_REST_TerminalStatusHandler.TerminalPerformanceLatestOutput termPerf) {
        System.assertEquals(status.name(), responseBody.status);
        System.assertEquals(errorMessage, responseBody.errorMessage);
        System.assertEquals(SNG_REST_Error.getErrorCode(status, errorSubCode), responseBody.errorCode);
        
        SNG_REST_TerminalStatusHandler.TerminalPerformanceLatestOutput responseBodyData 
            = (SNG_REST_TerminalStatusHandler.TerminalPerformanceLatestOutput) responseBody.data;
        verifyResponseResult(termPerf, responseBodyData);
    }
    
    private static void verifyResponseData(SNG_REST_CollectionOutput expected, SNG_REST_CollectionOutput actual) {
        if (null != expected) {
            SNG_REST_TerminalStatusHandler.TerminalPerformanceLatestOutput[] expectedItems = (SNG_REST_TerminalStatusHandler.TerminalPerformanceLatestOutput[]) expected.items;
            SNG_REST_TerminalStatusHandler.TerminalPerformanceLatestOutput[] actualItems = (SNG_REST_TerminalStatusHandler.TerminalPerformanceLatestOutput[]) actual.items;
            verifyResponseItems(expectedItems, actualItems);
        } else {
            System.assertEquals(null, actual);
        }
    }
    
    private static void verifyResponseItems(final SNG_REST_TerminalStatusHandler.TerminalPerformanceLatestOutput[] expected, 
                                            final SNG_REST_TerminalStatusHandler.TerminalPerformanceLatestOutput[] actual) {
        if (null != expected) {
            // Check the size
            System.assertEquals(expected.size(), actual.size());
            
            // Sort the 2 lists to ensure the order is the same
            expected.sort();
            actual.sort();
            
            for (Integer i = 0; i < expected.size(); ++i) {
                verifyResponseResult(expected[i], actual[i]);
            }
        } else {
            System.assertEquals(null, actual);
        }
    }
    
    private static void verifyResponseResult(final SNG_REST_TerminalStatusHandler.TerminalPerformanceLatestOutput expected, 
                                             final SNG_REST_TerminalStatusHandler.TerminalPerformanceLatestOutput actual) {
        
        if (null != expected) {
            if (expected != actual) {
                System.assertEquals(expected.terminalId, actual.terminalId);
                System.assertEquals(expected.network, actual.network);
                System.assertEquals(expected.weather, actual.weather);
                System.assertEquals(expected.performance, actual.performance);
                System.assertEquals(expected.pointing, actual.pointing);
                System.assertEquals(expected.status, actual.status);
                verifyOnlineTime(expected.onlineTime, actual.onlineTime);
            }
        } else {
            System.assertEquals(null, actual);
        }
    }
    
    private static void verifyOnlineTime(String expectedOnlineTimeStr, String actualOnlineTimeStr) {
        Long expectedOnlineTime = parseOnlineTime(expectedOnlineTimeStr);
        Long actualOnlineTime = parseOnlineTime(actualOnlineTimeStr);
        
        // 5 second tolerance
        System.assert(Math.abs(expectedOnlineTime - actualOnlineTime) < 5);
    }
    
    private static Long parseOnlineTime(String onlineTimeStr) 
    {
        Long totalSeconds = 0;
        
        onlineTimeStr = onlineTimeStr.substring(1);  // removes P
        
        integer index = onlineTimeStr.indexOf('D');
        
        if (-1 != index)
        {
           String days = onlineTimeStr.substring(0, index);
           totalSeconds += Integer.valueOf(days) * 86400;
           onlineTimeStr = onlineTimeStr.substring(index + 2); 
        }
                
        index = onlineTimeStr.indexOf('H');
        
        if (-1 != index)
        {
           String hours = onlineTimeStr.substring(0, index);
           totalSeconds += Integer.valueOf(hours) * 3600;   
           onlineTimeStr = onlineTimeStr.substring(index + 1);      
        }
        
        index = onlineTimeStr.indexOf('M');
        
        if (-1 != index)
        {
           String minutes = onlineTimeStr.substring(0, index);
           totalSeconds += Integer.valueOf(minutes) * 60;   
           onlineTimeStr = onlineTimeStr.substring(index + 1);      
        } 
        
        index = onlineTimeStr.indexOf('S');
        
        if (-1 != index)
        {
           String seconds = onlineTimeStr.substring(0, index);
           totalSeconds += Integer.valueOf(seconds);   
        }
        
        return totalSeconds;
    }
    
    // END Private Helper Methods
}