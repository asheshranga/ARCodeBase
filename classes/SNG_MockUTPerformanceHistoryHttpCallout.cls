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
global class SNG_MockUTPerformanceHistoryHttpCallout implements HttpCalloutMock {

    public static final transient string ZERO_RESULTS_MAC_ADDRESS = '00:a0:bc:44:55:11';
    public static final transient string HTTP_ERROR_404_MAC_ADDRESS = '00:a0:bc:44:55:22';
    public static final transient string NOT_FOUND_MAC_ADDRESS = '00:a0:bc:44:55:33';
    public static final transient string HTTP_STATUS_ONE_RESULT_MAC_ADDRESS = '00:a0:bc:44:55:44';
    public static final transient string HTTP_STATUS_TWO_RESULT_MAC_ADDRESS = '00:a0:bc:44:55:55';
    public static final transient string BAD_REQUEST = '00:a0:bc:44:55:66';
    public static final transient string BAD_REQUEST_DIFF_STATUS = '00:a0:bc:44:55:77';
    public static final transient string HTTP_STATUS_DIFF_STATUS = '00:a0:bc:44:55:88';
    public static final transient string OK_NO_DATA_MAC_ADDRESS = '00:a0:bc:44:55:99'; 
    
    public static final transient String UTONLINETIME = '0x07de0510123a34002b0000';

	global HTTPResponse respond(HTTPRequest req)
	{
		String endpoint = req.getEndpoint();
		
		HttpResponse res = new HttpResponse();
				
		if (endpoint.startsWith(SNGHttpUtilities.TOMCAT_SERVER.Url__c  + '/PmdrService/query/perf/phy/history/' + ZERO_RESULTS_MAC_ADDRESS))
		{
			System.debug('SNG_MockUTPerformanceHistoryHttpCallout.respond: ZERO_RESULTS_MAC_ADDRESS');
			System.assertEquals('GET', req.getMethod());
			
			res.setHeader('Content-Type', 'application/json');
        	res.setBody('{"result":[], "status":"ZERO_RESULTS"}');
        	res.setStatusCode(SNGHttpUtilities.STATUS_CODE.OK);
		}
		else if (endpoint.startsWith(SNGHttpUtilities.TOMCAT_SERVER.Url__c  + '/PmdrService/query/perf/phy/history/' + NOT_FOUND_MAC_ADDRESS))
        {
        	System.debug('SNG_MockUTPerformanceHistoryHttpCallout.respond: NOT_FOUND_MAC_ADDRESS');
            System.assertEquals('GET', req.getMethod());
            
            res.setHeader('Content-Type', 'application/json');
            res.setBody('{"result":[], "status":"ZERO_RESULTS"}');
            res.setStatusCode(SNGHttpUtilities.STATUS_CODE.NOT_FOUND);
        }
        else if (endpoint.startsWith(SNGHttpUtilities.TOMCAT_SERVER.Url__c  + '/PmdrService/query/perf/phy/history/' + OK_NO_DATA_MAC_ADDRESS))
        {
            System.debug('SNG_MockUTPerformanceHistoryHttpCallout.respond: NOT_FOUND_MAC_ADDRESS');
            System.assertEquals('GET', req.getMethod());
            
            res.setHeader('Content-Type', 'application/json');
            res.setBody('{"result":[], "status":"OK"}');
            res.setStatusCode(SNGHttpUtilities.STATUS_CODE.NOT_FOUND);
        }
		else if (endpoint.startsWith(SNGHttpUtilities.TOMCAT_SERVER.Url__c  + '/PmdrService/query/perf/phy/history/' + HTTP_ERROR_404_MAC_ADDRESS))
		{
			System.debug('SNG_MockUTPerformanceHistoryHttpCallout.respond: HTTP_ERROR_404_MAC_ADDRESS');
		    System.assertEquals('GET', req.getMethod());            
            throw new SNG_CalloutException('404 Error');
		}
		else if (endpoint.startsWith(SNGHttpUtilities.TOMCAT_SERVER.Url__c  + '/PmdrService/query/perf/phy/history/' + BAD_REQUEST))
		{
			System.debug('SNG_MockUTPerformanceHistoryHttpCallout.respond: HTTP_ERROR_404_MAC_ADDRESS_RESPONSE');
			res.setHeader('Content-Type', 'application/json');
			res.setBody('{"result":[], "status":"INPUT_VALIDATION_EXCEPTION"}');
			res.setStatusCode(400);
		}
		else if (endpoint.startsWith(SNGHttpUtilities.TOMCAT_SERVER.Url__c + '/PmdrService/query/perf/phy/history/' + BAD_REQUEST_DIFF_STATUS))
		{ 
			System.debug('SNG_MockUTPerformanceHistoryHttpCallout.respond: BAD_REQUEST_DIFF_STATUS');
			res.setHeader('Content-Type', 'application/json');
			res.setBody('{"result":[], "status":"DIFFERENT_STATUS"}');
			res.setStatusCode(400);
		}
		else if (endpoint.startsWith(SNGHttpUtilities.TOMCAT_SERVER.Url__c  + '/PmdrService/query/perf/phy/history/' + HTTP_STATUS_ONE_RESULT_MAC_ADDRESS))
		{
			System.debug('SNG_MockUTPerformanceHistoryHttpCallout.respond: HTTP_STATUS_ONE_RESULT_MAC_ADDRESS');
            res.setHeader('Content-Type', 'application/json');		    
            res.setBody('{ "result": [{' +
                        '"UTFLSINR": 20.5,' +
                        '"UTRLSINR": 14.77,' +
                        '"UTRLSYMBOLRATE": 625,' +
                        '"UTSUMMARYMACADDR": "' + HTTP_STATUS_ONE_RESULT_MAC_ADDRESS + '",' +
                        '"UTTIME": 1385971200,' +
                        '"UTONLINETIME": "' + UTONLINETIME + '"' +
                        '}],' +
                        '"status": "OK"}');
		    res.setStatusCode(SNGHttpUtilities.STATUS_CODE.OK);
		}
		else if (endpoint.startsWith(SNGHttpUtilities.TOMCAT_SERVER.Url__c  + '/PmdrService/query/perf/phy/history/' + HTTP_STATUS_TWO_RESULT_MAC_ADDRESS))
		{
			System.debug('SNG_MockUTPerformanceHistoryHttpCallout.respond: HTTP_STATUS_TWO_RESULT_MAC_ADDRESS');
            res.setHeader('Content-Type', 'application/json');          
            res.setBody('{ "result": [{' +
                        '"UTFLSINR": 20.5,' +
                        '"UTRLSINR": 14.77,' +
                        '"UTRLSYMBOLRATE": 625,' +
                        '"UTSUMMARYMACADDR": "' + HTTP_STATUS_TWO_RESULT_MAC_ADDRESS + '",' +
                        '"UTONLINETIME": "' + UTONLINETIME + '",' +
                        '"UTTIME": 1385971200},' +
                        '{' +
                        '"UTFLSINR": 19.0,' +
                        '"UTRLSINR": 10.26,' +
                        '"UTRLSYMBOLRATE": 376,' +
                        '"UTSUMMARYMACADDR": "' + HTTP_STATUS_TWO_RESULT_MAC_ADDRESS + '",' +
                        '"UTONLINETIME": "' + UTONLINETIME + '",' +
                        '"UTTIME": 1385971215' +
                        '}],' +
                        '"status": "OK"}');
            res.setStatusCode(SNGHttpUtilities.STATUS_CODE.OK);
		}
		else if (endpoint.startsWith(SNGHttpUtilities.TOMCAT_SERVER.Url__c + '/PmdrService/query/perf/phy/history/' + HTTP_STATUS_DIFF_STATUS))
		{ 
			System.debug('SNG_MockUTPerformanceHistoryHttpCallout.respond: HTTP_STATUS_DIFF_STATUS'); 
			res.setHeader('Content-Type', 'application/json');
			res.setBody('{ "result":[], "status":"DIFFERENT_STATUS"}');
			res.setStatusCode(SNGHttpUtilities.STATUS_CODE.OK);
		}
		else if (endpoint.startsWith(SNG_MockCustomSettings.MOCK_OPENAM_URL))
        {
        	System.debug('SNG_MockUTPerformanceHistoryHttpCallout.respond: OpenAM Authentication');
            System.assertEquals('GET', req.getMethod());
            
            res.setStatusCode(SNGHttpUtilities.STATUS_CODE.OK);
            res.setBody('token.id=' + SNG_MockHttpCallout.TOKEN_ID);
        }

		return res;
	}
}