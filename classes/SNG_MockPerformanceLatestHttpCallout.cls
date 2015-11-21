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
public class SNG_MockPerformanceLatestHttpCallout implements HttpCalloutMock {
	
	public static final String[] SUCCESS_MACADDRS = new String[] { '00:a0:bc:00:00:00', '00:a0:bc:00:00:01' };
	public static final String[] SERVER_ERROR_MACADDRS = new String[] { '00:a0:bc:00:00:02', '00:a0:bc:00:00:03' };
	public static final String[] SERVER_BUG_MACADDRS = new String[] { '00:a0:bc:00:00:04', '00:a0:bc:00:00:05' };
	public static final String[] ZERO_RESULTS_MACADDRS = new String[] {'00:a0:bc:00:00:06', '00:a0:bc:00:00:07' };
	
	public static final String SUCCESS_RESPONSE_STRING = 
		'{' +
		'    "result": [' +
		'        {' +
		'            "UTFLSINR": 25.70000,' +
		'            "UTONLINETIME": "0x07dd0b0c131714002b0000",' + // 1384284200000 milliseconds Unix time
		'            "UTRLSYMBOLRATE": 10000,' +
		'            "NUM_PEERS_ONLINE": 5,' +
		'            "PEER_AVG_SYMBOL_RATE": 10000,' +
		'            "UTSUMMARYMACADDR": "' + convertMacAddressToHex(SUCCESS_MACADDRS[0]) + '"' +
		'        },' +
		'        {' +
		'            "UTFLSINR": 25.80000,' +
		'            "UTONLINETIME": "0x07dd0b0c131714003b0000",' +
		'            "UTRLSYMBOLRATE": 8000,' +
		'            "NUM_PEERS_ONLINE": 3,' +
		'            "PEER_AVG_SYMBOL_RATE": 8000,' +
		'            "UTSUMMARYMACADDR": "' + convertMacAddressToHex(SUCCESS_MACADDRS[1]) + '"' +
		'        }' +
		'    ],' +
		'    "status": "OK"' +
		'}';
	
	public static final String SUCCESS_RESPONSE_0_STRING = 
		'{' +
		'    "result": [' +
		'        {' +
		'            "UTFLSINR": 25.70000,' +
		'            "UTONLINETIME": "0x07dd0b0c131714002b0000",' + // 1384284200000 milliseconds Unix time
		'            "UTRLSYMBOLRATE": 10000,' +
		'            "NUM_PEERS_ONLINE": 5,' +
		'            "PEER_AVG_SYMBOL_RATE": 10000,' +
		'            "UTSUMMARYMACADDR": "' + convertMacAddressToHex(SUCCESS_MACADDRS[0]) + '"' +
		'        }' +
		'    ],' +
		'    "status": "OK"' +
		'}';
	
	public static final String SUCCESS_RESPONSE_1_STRING = 
		'{' +
		'    "result": [' +
		'        {' +
		'            "UTFLSINR": 25.80000,' +
		'            "UTONLINETIME": "0x07dd0b0c131714003b0000",' +
		'            "UTRLSYMBOLRATE": 8000,' +
		'            "NUM_PEERS_ONLINE": 3,' +
		'            "PEER_AVG_SYMBOL_RATE": 8000,' +
		'            "UTSUMMARYMACADDR": "' + convertMacAddressToHex(SUCCESS_MACADDRS[1]) + '"' +
		'        }' +
		'    ],' +
		'    "status": "OK"' +
		'}';
	
	public static final String SERVER_ERROR_RESPONSE_STRING = 
		'{' +
		'    "result": null,' +
		'    "status": "SERVER_ERROR"' +
		'}';
	
	public static final String SERVER_BUG_RESPONSE_STRING = 
		'{' +
		'    "result": null,' +
		'    "status": "OK"' +
		'}';

	public static final String ZERO_RESULTS_RESPONSE_STRING =
		'{' +
		'    "result": [],' +
		'    "status": "ZERO_RESULTS"' +
		'}';
	
/*
	private static final String SUCCESS_REQUEST_URL = SNG_PerformanceLatest.constructUrl(SUCCESS_MACADDRS);
	private static final String SUCCESS_REQUEST_0_URL = SNG_PerformanceLatest.constructUrl(new String[] { SUCCESS_MACADDRS[0] });
	private static final String SUCCESS_REQUEST_1_URL = SNG_PerformanceLatest.constructUrl(new String[] { SUCCESS_MACADDRS[1] });
	
	private static final String SERVER_ERROR_REQUEST_URL = SNG_PerformanceLatest.constructUrl(SERVER_ERROR_MACADDRS);
	private static final String SERVER_ERROR_REQUEST_0_URL = SNG_PerformanceLatest.constructUrl(new String[] { SERVER_ERROR_MACADDRS[0] });
	private static final String SERVER_ERROR_REQUEST_1_URL = SNG_PerformanceLatest.constructUrl(new String[] { SERVER_ERROR_MACADDRS[1] });
	
	private static final String SERVER_BUG_REQUEST_URL = SNG_PerformanceLatest.constructUrl(SERVER_BUG_MACADDRS);
	private static final String SERVER_BUG_REQUEST_0_URL = SNG_PerformanceLatest.constructUrl(new String[] { SERVER_BUG_MACADDRS[0] });
	private static final String SERVER_BUG_REQUEST_1_URL = SNG_PerformanceLatest.constructUrl(new String[] { SERVER_BUG_MACADDRS[1] });
*/
	
	public HTTPResponse respond(HTTPRequest req) {
		final String endpoint = req.getEndpoint();
		
		HttpResponse res = new HttpResponse();
		
		if (endpoint.startsWith(SNG_PerformanceLatest.DB_PERF_HTTP_PATH))
        {
        	String jsonRequestBody = req.getBody();
        	
        	if (jsonRequestBody.contains(SUCCESS_MACADDRS[0]) && jsonRequestBody.contains(SUCCESS_MACADDRS[1]))
        	{
                System.debug(LoggingLevel.ERROR, 'SNG_MockPerformanceLatestHttpCallout.respond: SUCCESS_REQUEST_STRING');
                System.assertEquals('POST', req.getMethod());
                res.setHeader('Content-Type', 'application/json');
                res.setBody(SUCCESS_RESPONSE_STRING);
                res.setStatusCode(SNGHttpUtilities.STATUS_CODE.OK);       	       	
        	}
        	else if (jsonRequestBody.contains(SUCCESS_MACADDRS[0]))
        	{
        		System.debug(LoggingLevel.ERROR, 'SNG_MockPerformanceLatestHttpCallout.respond: SUCCESS_REQUEST_0_URL');
                System.assertEquals('POST', req.getMethod());
                res.setHeader('Content-Type', 'application/json');
                res.setBody(SUCCESS_RESPONSE_0_STRING);
                res.setStatusCode(SNGHttpUtilities.STATUS_CODE.OK);
        	}
            else if (jsonRequestBody.contains(SUCCESS_MACADDRS[1]))
            {
                System.debug(LoggingLevel.ERROR, 'SNG_MockPerformanceLatestHttpCallout.respond: SUCCESS_REQUEST_1_URL');
                System.assertEquals('POST', req.getMethod());
                res.setHeader('Content-Type', 'application/json');
                res.setBody(SUCCESS_RESPONSE_1_STRING);
                res.setStatusCode(SNGHttpUtilities.STATUS_CODE.OK);
            }
        	else if (jsonRequestBody.contains(SERVER_ERROR_MACADDRS[0]) || 
        	         jsonRequestBody.contains(SERVER_ERROR_MACADDRS[1]))
        	{
        		System.debug(LoggingLevel.ERROR, 'SNG_MockPerformanceLatestHttpCallout.respond: SERVER_ERROR_REQUEST_URL');
                System.assertEquals('POST', req.getMethod());
                res.setHeader('Content-Type', 'application/json');
                res.setBody(SERVER_ERROR_RESPONSE_STRING);
                res.setStatusCode(SNGHttpUtilities.STATUS_CODE.NOT_FOUND);
        	}
        	else if (jsonRequestBody.contains(SERVER_BUG_MACADDRS[0]) ||
        	         jsonRequestBody.contains(SERVER_BUG_MACADDRS[1]))
        	{
                System.debug(LoggingLevel.ERROR, 'SNG_MockPerformanceLatestHttpCallout.respond: SERVER_BUG_REQUEST_URL');
                System.assertEquals('POST', req.getMethod());
                res.setHeader('Content-Type', 'application/json');
                res.setBody(SERVER_BUG_RESPONSE_STRING);
                res.setStatusCode(SNGHttpUtilities.STATUS_CODE.OK);
			}
			else if (jsonRequestBody.contains(ZERO_RESULTS_MACADDRS[0]) ||
				     jsonRequestBody.contains(ZERO_RESULTS_MACADDRS[1]))
        	{
        		System.assertEquals('POST', req.getMethod());
        		res.setHeader('Content-Type', 'application/json');
            	res.setStatusCode(SNGHttpUtilities.STATUS_CODE.OK);
            	res.setBody('{"result":[], "status":"ZERO_RESULTS"}');
        	} 
        }
        else if (endpoint.startsWith(SNG_MockCustomSettings.MOCK_OPENAM_URL)) 
        {
        	System.debug('SNG_MockPerformanceLatestHttpCallout.respond: OpenAM Authentication');
            System.assertEquals('GET', req.getMethod());
            
            res.setStatusCode(SNGHttpUtilities.STATUS_CODE.OK);
            res.setBody('token.id=' + SNG_MockHttpCallout.TOKEN_ID);
        } 
        else 
        {
			System.debug(LoggingLevel.ERROR, 'SNG_MockPerformanceLatestHttpCallout.respond: EMPTY CASE.\nEndpoint was: ' + endpoint);
			System.assert(false);
		}
		
		return res;
	}
	
	public static String convertMacAddressToHex(String macAddress) {
    	String macAddressToUpdate = macAddress;
    	return '0x' + macAddressToUpdate.replaceAll(':', '');
    }
	
}