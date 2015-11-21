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
public class SNG_REST_TerminalStatusUnitTestHelper {
    
    /**
     * Resource path for the singular API call
     * NOTE: This must match what's specified in the @RestResource annotation
     * cannot be static since this class is copied as an inner class for SNGRestTest.cls
     */
    private final String SINGULAR_TERMINAL_STATUS_RESOURCE_PATH = '/terminal/*/status';
    
    /**
     * Resource path for the plural API call
     * NOTE: This must match what's specified in the @RestResource annotation
     * cannot be static since this class is copied as an inner class for SNGRestTest.cls
     */
    private final String PLURAL_TERMINAL_STATUS_RESOURCE_PATH = '/terminals/status';
    
    public void initTest() {
        // initialize custom settings
        SNG_MockCustomSettings.initialize();
    }
    
    public void startTestAndSetMock() {
        // start the test and set the mock for the http callout
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new SNG_MockPerformanceLatestHttpCallout());
    }
    
    public RestRequest getSingularRequest(Terminal__c terminal) {
        return (null == terminal ? null : getSingularRequest(terminal.Name));
    }
    
    public RestRequest getSingularRequest(String terminalIdName) {
        RestRequest req = new RestRequest();
        
        req.requestURI = '/terminal/' + terminalIdName + '/status';
        req.resourcePath = SINGULAR_TERMINAL_STATUS_RESOURCE_PATH;
        
        // set the request method
        req.httpMethod = 'GET';
        
        // Print out the request URI for debug
        System.debug('Singular Request URI for terminalIdName [' + terminalIdName + ']: ' + req.requestUri);
        
        return req;
    }
    
    public RestRequest getPluralRequest(Terminal__c[] terminals) {
        String[] terminalIdNames = getTerminalIdNames(terminals);
        return getPluralRequest(terminalIdNames);
    }
    
    public RestRequest getPluralRequest(String[] terminalIdNames) {
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
    
    public void verifyExceptionForRequestNullRequestTest(SNG_Exception e) {
        System.assert(null != e);
    }
    
    
    
    // START Plural Request Tests
    
    
    public Terminal__c[] getTerminalsForPluralRequestSuccessTest() {
        Modem__c[] modems = insertModems(SNG_MockPerformanceLatestHttpCallout.SUCCESS_MACADDRS);
        return getTerminalsForModems(modems);
    }

    public Terminal__c[] getTerminalsForPluralRequestPmdrServiceZeroResults() {
        Modem__c[] modems = insertModems(SNG_MockPerformanceLatestHttpCallout.ZERO_RESULTS_MACADDRS);
        return getTerminalsForModems(modems);
    }
    
    public void verifyResponseForPluralRequestSuccessTest(Terminal__c[] terminals, SNG_REST_JsonResponse responseBody) {
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
    
    public void verifyResponseForPluralRequestPmdrZeroResultsTest(Terminal__c[] terminals, SNG_REST_JsonResponse responseBody)
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

    
    public String[] getTerminalNamesForPluralRequestInvalidIdTest() {
        Modem__c[] modems = insertModems(SNG_MockPerformanceLatestHttpCallout.SUCCESS_MACADDRS);
        Terminal__c[] terminals = getTerminalsForModems(modems);
        List<String> terminalIdNames = getTerminalIdNames(terminals);
        terminalIdNames.add('INVALID_TERMINAL_ID');
        return terminalIdNames;
    }
    
    public void verifyResponseForPluralRequestInvalidIdTest(String[] terminalIdNames, SNG_REST_JsonResponse responseBody) {
        verifyPluralResponse(responseBody, SNGHttpUtilities.Status.INPUT_VALIDATION_ERROR, 
                       SNG_REST_Error.INPUT_INVALID_FORMAT, 
                       SNG_REST_Error.SubCode.SALESFORCE_GENERATED_ERROR, null);
    }
    
    
    public Terminal__c[] getTerminalsForPluralRequestTerminalNotOnAccountTest() {
        Modem__c[] modems = insertModems(SNG_MockPerformanceLatestHttpCallout.SUCCESS_MACADDRS);
        Terminal__c[] terminals = getTerminalsForModems(modems);
        
        // delete so it's not available on the account
        delete modems[0];
        delete terminals[0];
        
        return terminals;
    }
    
    public void verifyResponseForPluralRequestTerminalNotOnAccountTest(Terminal__c[] terminals, SNG_REST_JsonResponse responseBody) {
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
    
    
    public Terminal__c[] getTerminalsForPluralRequestNoTerminalsOnAccountTest() {
        String[] macAddrs = new String[] { '00:a0:bc:99:99:99' };
        Modem__c[] modems = insertModems(macAddrs);
        Terminal__c[] terminals = getTerminalsForModems(modems);
        
        // delete so it's not available on the account
        delete modems[0];
        delete terminals[0];
        
        return terminals;
    }
    
    public void verifyResponseForPluralRequestNoTerminalsOnAccountTest(SNG_REST_JsonResponse responseBody) {
        verifyPluralResponse(responseBody, SNGHttpUtilities.Status.ZERO_RESULTS, 
                       SNG_REST_Error.IDS_INVALID, 
                       SNG_REST_Error.SubCode.SALESFORCE_GENERATED_ERROR, null);
    }
    
    
    public Terminal__c[] getTerminalsForPluralRequestTerminalModemNotAssociatedTest() {
        Modem__c[] modems = insertModems(SNG_MockPerformanceLatestHttpCallout.SUCCESS_MACADDRS);
        Terminal__c[] terminals = getTerminalsForModems(modems);
        
        // delete a modem so it's not associated with the corresponding terminal
        delete modems[0];
        
        return terminals;
    }
    
    public void verifyResponseForPluralRequestTerminalModemNotAssociatedTest(Terminal__c[] terminals, SNG_REST_JsonResponse responseBody) {
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
    
    
    public Terminal__c[] getTerminalsForPluralRequestPmdrServiceErrorTest() {
        Modem__c[] modems = insertModems(SNG_MockPerformanceLatestHttpCallout.SERVER_ERROR_MACADDRS);
        return getTerminalsForModems(modems);
    }
    
    public void verifyResponseForPluralRequestPmdrServiceErrorTest(SNG_REST_JsonResponse responseBody) {
        verifyPluralResponse(responseBody, SNGHttpUtilities.Status.SERVER_ERROR, 
                       SNG_REST_Error.GENERIC_WEBSERVICE_ERROR, 
                       SNG_REST_Error.SubCode.WEBSERVICE_GENERATED_ERROR, null);
    }
    
    
    public Terminal__c[] getTerminalsForPluralRequestPmdrServiceBugTest() {
        Modem__c[] modems = insertModems(SNG_MockPerformanceLatestHttpCallout.SERVER_BUG_MACADDRS);
        return getTerminalsForModems(modems);
    }
    
    public void verifyResponseForPluralRequestPmdrServiceBugTest(SNG_REST_JsonResponse responseBody) {
        verifyPluralResponse(responseBody, SNGHttpUtilities.Status.SERVER_ERROR, 
                       SNG_REST_Error.GENERIC_WEBSERVICE_ERROR, 
                       SNG_REST_Error.SubCode.SALESFORCE_GENERATED_ERROR, null);
    }
    
    
    // END Handle Plural Request Tests
    
    
    
    // START Handle Singular Request Tests
    
    public Terminal__c getTerminalForSingularRequestSuccessTest() {
        Modem__c modem = insertModem(SNG_MockPerformanceLatestHttpCallout.SUCCESS_MACADDRS[0]);
        return requeryTerminal(modem.Terminal__r);
    }
    
    public Terminal__c getTerminalsForSingularRequestPmdrServiceZeroResults() {
        Modem__c modem = insertModem(SNG_MockPerformanceLatestHttpCallout.ZERO_RESULTS_MACADDRS[0]);
        return requeryTerminal(modem.Terminal__r);
    }

    public void verifyResponseForSingularRequestSuccessTest(Terminal__c terminal, SNG_REST_JsonResponse responseBody) {
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

    public void verifyResponseForSingularRequestPmdrZeroResultsTest(Terminal__c terminal, SNG_REST_JsonResponse responseBody)
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

    
    
    public String getTerminalNameForSingularRequestInvalidIdTest() {
        return 'INVALID_TERMINAL_ID';
    }
    
    public void verifyResponseForSingularRequestInvalidIdTest(SNG_REST_JsonResponse responseBody) {
        verifySingularResponse(responseBody, SNGHttpUtilities.Status.INPUT_VALIDATION_ERROR, 
                               SNG_REST_Error.INPUT_INVALID_FORMAT, 
                               SNG_REST_Error.SubCode.SALESFORCE_GENERATED_ERROR, null);
    }
    
    
    public Terminal__c getTerminalForSingularRequestNoTerminalsOnAccountTest() {
        String macAddr = '00:a0:bc:99:99:99';
        Modem__c modem = insertModem(macAddr);
        Terminal__c terminal = requeryTerminal(modem.Terminal__r);
        
        // delete so it's not available on the account
        delete modem;
        delete terminal;
        
        return terminal;
    }
    
    public void verifyResponseForSingularRequestNoTerminalsOnAccountTest(SNG_REST_JsonResponse responseBody) {
        verifySingularResponse(responseBody, SNGHttpUtilities.Status.ZERO_RESULTS, 
                               SNG_REST_Error.IDS_INVALID, 
                               SNG_REST_Error.SubCode.SALESFORCE_GENERATED_ERROR, null);
    }
    
    
    public Terminal__c getTerminalForSingularRequestTerminalModemNotAssociatedTest() {
        String macAddr = SNG_MockPerformanceLatestHttpCallout.SUCCESS_MACADDRS[0];
        Modem__c modem = insertModem(macAddr);
        Terminal__c terminal = requeryTerminal(modem.Terminal__r);
        
        // Disassociate terminal from modem
        modem.Terminal__c = null;
        modem.Terminal__r = null;
        update modem;
        
        return terminal;
    }
    
    public void verifyResponseForSingularRequestTerminalModemNotAssociatedTest(SNG_REST_JsonResponse responseBody) {
        verifySingularResponse(responseBody, SNGHttpUtilities.Status.ZERO_RESULTS, 
                               SNG_REST_Error.TERMINAL_NO_MODEM, 
                               SNG_REST_Error.SubCode.SALESFORCE_GENERATED_ERROR, null);
    }
    
    
    public Terminal__c getTerminalForSingularRequestPmdrServiceErrorTest() {
        Modem__c modem = insertModem(SNG_MockPerformanceLatestHttpCallout.SERVER_ERROR_MACADDRS[0]);
        return requeryTerminal(modem.Terminal__r);
    }
    
    public void verifyResponseForSingularRequestPmdrServiceErrorTest(SNG_REST_JsonResponse responseBody) {
        verifySingularResponse(responseBody, SNGHttpUtilities.Status.SERVER_ERROR, 
                               SNG_REST_Error.GENERIC_WEBSERVICE_ERROR, 
                               SNG_REST_Error.SubCode.WEBSERVICE_GENERATED_ERROR, null);
    }

    public void verifyResponseForSingularRequestNullRestRequestTest(SNG_REST_JsonResponse responseBody) {
        verifySingularResponse(responseBody, SNGHttpUtilities.Status.SERVER_ERROR, 
                               SNG_REST_ERROR.INTERNAL_SERVER_ERROR, 
                               SNG_REST_Error.SubCode.SALESFORCE_GENERATED_ERROR, null);
    }
    
    
    public Terminal__c getTerminalForSingularRequestPmdrServiceBugTest() {
        Modem__c modem = insertModem(SNG_MockPerformanceLatestHttpCallout.SERVER_BUG_MACADDRS[0]);
        return requeryTerminal(modem.Terminal__r);
    }
    
    public void verifyResponseForSingularRequestPmdrServiceBugTest(SNG_REST_JsonResponse responseBody) {
        verifySingularResponse(responseBody, SNGHttpUtilities.Status.SERVER_ERROR, 
                               SNG_REST_Error.GENERIC_WEBSERVICE_ERROR, 
                               SNG_REST_Error.SubCode.SALESFORCE_GENERATED_ERROR, null);
    }
    
    
    // END Handle Singular Request Tests
    
    
    
    
    // START Private Helper Methods
    
    private Terminal__c requeryTerminal(Terminal__c terminal) {
        final SNG_SObjectQueryBuilder queryBuilder = new SNG_SObjectQueryBuilder(SNG_SObjectQueryBuilder.TERMINAL_OBJ_NAME);
        queryBuilder.addAllFields();
        String queryStr = queryBuilder.constructQuery() + ' WHERE Id=\'' + terminal.Id + '\'';
        return Database.query(queryStr);
    }
    
    private Modem__c[] insertModems(String[] macAddrs) {
        Account acct = SNG_TestUtilities.insertAccount('testAccount');
        
        Modem__c[] modems = new Modem__c[macAddrs.size()];
        
        for (Integer i = 0; i < macAddrs.size(); ++i) {
            modems[i] = insertModem(macAddrs[i], acct, i);
        }
        
        return modems;
    }
    
    private Modem__c insertModem(String macAddr) {
        return insertModem(macAddr, SNG_TestUtilities.insertAccount('testAccount'), 0);
    }
    
    private Modem__c insertModem(String macAddr, Account acct, Integer index) {
        return SNG_TestUtilities.insertEquipment('Terminal_' + index, macAddr, acct, String.valueOf(index), true);
    }
    
    private Id[] getTerminalIdsForModems(Modem__c[] modems) {
        List<Id> terminalIds = new List<Id>();
        
        for (Modem__c modem : modems) {
            terminalIds.add(modem.Terminal__c);
        }
        
        return terminalIds;
    }
    
    private Terminal__c[] getTerminalsForModems(Modem__c[] modems) {
        Id[] terminalIds = getTerminalIdsForModems(modems);
        
        Terminal__c[] terminals = [SELECT Id, Name, PeersOnlineBackEnd__c, PeersAvgUploadSymbolRateBackEnd__c, DownloadSinrBackEnd__c, 
                                   UploadSymbolRateBackEnd__c, Status__c, Network__c, WeatherBackEnd__c, Performance__c, Pointing__c, 
                                   OnlineTime__c FROM Terminal__c WHERE Id IN :terminalIds];
        
        return terminals;
    }
    
    private String[] getTerminalIdNames(Terminal__c[] terminals) {
        List<String> terminalIdNames = new List<String>();
        
        for (Terminal__c terminal : terminals) {
            terminalIdNames.add(terminal.Name);
        }
        
        return terminalIdNames;
    }
    
    private void verifyPluralResponse(final SNG_REST_JsonResponse responseBody, final SNGHttpUtilities.Status status, 
                                       final String errorMessage, final SNG_REST_Error.SubCode errorSubCode, final SNG_REST_CollectionOutput termPerf) {
        System.assertEquals(status.name(), responseBody.status);
        System.assertEquals(errorMessage, responseBody.errorMessage);
        System.assertEquals(SNG_REST_Error.getErrorCode(status, errorSubCode), responseBody.errorCode);
        
        SNG_REST_CollectionOutput responseBodyData = (SNG_REST_CollectionOutput) responseBody.data;
        verifyResponseData(termPerf, responseBodyData);
    }
    
    private void verifySingularResponse(final SNG_REST_JsonResponse responseBody, final SNGHttpUtilities.Status status, 
                                               final String errorMessage, final SNG_REST_Error.SubCode errorSubCode, final SNG_REST_TerminalStatusHandler.TerminalPerformanceLatestOutput termPerf) {
        System.assertEquals(status.name(), responseBody.status);
        System.assertEquals(errorMessage, responseBody.errorMessage);
        System.assertEquals(SNG_REST_Error.getErrorCode(status, errorSubCode), responseBody.errorCode);
        
        SNG_REST_TerminalStatusHandler.TerminalPerformanceLatestOutput responseBodyData 
            = (SNG_REST_TerminalStatusHandler.TerminalPerformanceLatestOutput) responseBody.data;
        verifyResponseResult(termPerf, responseBodyData);
    }
    
    private void verifyResponseData(SNG_REST_CollectionOutput expected, SNG_REST_CollectionOutput actual) {
        if (null != expected) {
            SNG_REST_TerminalStatusHandler.TerminalPerformanceLatestOutput[] expectedItems = (SNG_REST_TerminalStatusHandler.TerminalPerformanceLatestOutput[]) expected.items;
            SNG_REST_TerminalStatusHandler.TerminalPerformanceLatestOutput[] actualItems = (SNG_REST_TerminalStatusHandler.TerminalPerformanceLatestOutput[]) actual.items;
            verifyResponseItems(expectedItems, actualItems);
        } else {
            System.assertEquals(null, actual);
        }
    }
    
    private void verifyResponseItems(final SNG_REST_TerminalStatusHandler.TerminalPerformanceLatestOutput[] expected, 
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
    
    private void verifyResponseResult(final SNG_REST_TerminalStatusHandler.TerminalPerformanceLatestOutput expected, 
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
    
    private void verifyOnlineTime(String expectedOnlineTimeStr, String actualOnlineTimeStr) {
        Long expectedOnlineTime = parseOnlineTime(expectedOnlineTimeStr);
        Long actualOnlineTime = parseOnlineTime(actualOnlineTimeStr);
        
        // 5 second tolerance
        System.assert(Math.abs(expectedOnlineTime - actualOnlineTime) < 5);
    }
    
    private Long parseOnlineTime(String onlineTimeStr) 
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