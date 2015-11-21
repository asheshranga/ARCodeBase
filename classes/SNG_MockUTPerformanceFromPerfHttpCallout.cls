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
global class SNG_MockUTPerformanceFromPerfHttpCallout implements HttpCalloutMock {
	
	public static final transient string VALID_MAC_ADDRESS = '00:a0:bc:44:55:11';
	public static final transient string ACCESS_DENIED_MAC_ADDRESS = '00:a0:bc:44:55:22';
	public static final transient string ZERO_RESULTS_MAC_ADDRESS = '00:a0:bc:44:55:33';
	public static final transient string NOT_FOUND_MAC_ADDRESS = '00:a0:bc:44:55:44';
	
	private static final transient string VALID_RESPONSE = 
		'{' +
		'    "result": [{' +
		'        "UTFLSINR": 25.70000,' +
		'        "UTONLINETIME": "0x07dd0b0c131714002b0000",' + // 1384284200000 milliseconds Unix time
		'        "UTRLSYMBOLRATE": 10000,' +
		'        "UTSTATE": 5,' +
		'        "UTSUMMARYMACADDR": "' + convertMacAddressToHex(VALID_MAC_ADDRESS) + '"' +
		'    }],' +
		'    "status": "OK"' +
		'}';
		
		
    global static String convertMacAddressToHex(String macAddress)
    {
    	String macAddressToUpdate = macAddress;
    	return '0x' + macAddressToUpdate.replaceAll(':', '');
    }		

    global HTTPResponse respond(HTTPRequest req)
	{
		String endpoint = req.getEndpoint();
		
		HttpResponse res = new HttpResponse();

		if (endpoint.startsWith(SNGHttpUtilities.TOMCAT_SERVER.Url__c  + '/PmdrService/query/perf/phy/latest/' + VALID_MAC_ADDRESS))
		{
			System.debug('SNG_MockUTPerformanceFromPerfHttpCallout.respond: VALID_MAC_ADDRESS');
			System.assertEquals('GET', req.getMethod());
			
			res.setHeader('Content-Type', 'application/json');
        	res.setBody(VALID_RESPONSE);
        	res.setStatusCode(SNGHttpUtilities.STATUS_CODE.OK);
		}
		else if (endpoint.startsWith(SNGHttpUtilities.TOMCAT_SERVER.Url__c  + '/PmdrService/query/perf/phy/latest/' + ACCESS_DENIED_MAC_ADDRESS))
        {
        	System.debug('SNG_MockUTPerformanceFromPerfHttpCallout.respond: ACCESS_DENIED_MAC_ADDRESS');
            System.assertEquals('GET', req.getMethod());
            
            res.setHeader('Content-Type', 'application/json');
            res.setBody('{"result":[], "status":"ACCESS_DENIED"}');
            res.setStatusCode(SNGHttpUtilities.STATUS_CODE.OK);
        }
        else if (endpoint.startsWith(SNGHttpUtilities.TOMCAT_SERVER.Url__c  + '/PmdrService/query/perf/phy/latest/' + ZERO_RESULTS_MAC_ADDRESS))
        {
            System.assertEquals('GET', req.getMethod());
            
            res.setHeader('Content-Type', 'application/json');
            res.setBody('{"result":[], "status":"ZERO_RESULTS"}');
            res.setStatusCode(SNGHttpUtilities.STATUS_CODE.OK);
        }
        else if (endpoint.startsWith(SNGHttpUtilities.TOMCAT_SERVER.Url__c  + '/PmdrService/query/perf/phy/latest/' + NOT_FOUND_MAC_ADDRESS))
        {
            System.assertEquals('GET', req.getMethod());
            
            res.setHeader('Content-Type', 'application/json');
            res.setBody('{"result":[], "status":"ZERO_RESULTS"}');
            res.setStatusCode(SNGHttpUtilities.STATUS_CODE.NOT_FOUND);
        }
        else if (endpoint.startsWith(SNG_MockCustomSettings.MOCK_OPENAM_URL))
        {
        	System.debug('SNG_MockUTPerformanceFromPerfHttpCallout.respond: OpenAM Authentication');
            System.assertEquals('GET', req.getMethod());
            
            res.setStatusCode(SNGHttpUtilities.STATUS_CODE.OK);
            res.setBody('token.id=' + SNG_MockHttpCallout.TOKEN_ID);
        }
        else
        {
        	System.debug(LoggingLevel.ERROR, 'SNG_MockUTPerformanceFromPerfHttpCallout.respond: EMPTY CASE');
        }

		return res;
	}
}