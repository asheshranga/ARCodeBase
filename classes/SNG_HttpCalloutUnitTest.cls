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
global class SNG_HttpCalloutUnitTest {

    static testMethod void sendHttpGetRequestUnitTest() {
    	init();
        SNG_HttpCallout.sendHttpGetRequest(SNG_MockHttpCallout.URL_GET_NO_LOGIN);
        Test.stopTest();
    }
    
    static testMethod void sendHttpGetRequestWithLoginUnitTest() {
        init();
        // NOTE: 2 consecutive calls here to cover more of the code
        SNG_HttpCallout.sendHttpGetRequest(SNGHttpUtilities.TOMCAT_SERVER.Url__c);
        SNG_HttpCallout.sendHttpGetRequest(SNGHttpUtilities.TOMCAT_SERVER.Url__c);
        Test.stopTest();
    }
    
    static testMethod void sendHttpPostRequestUnitTest() {
    	init();
        SNG_HttpCallout.sendHttpPostRequest(SNG_MockHttpCallout.URL_POST_NO_LOGIN);
        Test.stopTest();
    }
    
    static testMethod void sendHttpPostRequestWithLoginUnitTest() {
    	init();
        SNG_HttpCallout.sendHttpPostRequest(SNGHttpUtilities.TOMCAT_SERVER.Url__c);
        Test.stopTest();
    }
    
    static testMethod void urlNullTest() {
    	init();
    	try {
    		SNG_HttpCallout.sendHttpPostRequest(null);
    		System.assert(false);
    	} catch (SNG_CalloutException e) {
    		System.assert(true);
    	}
        Test.stopTest();
    }
    
    static testMethod void sendHttpPostRequestWithBodyUnitTest() {
    	init();
    	SNG_HttpCallout.sendHttpPostRequest(SNGHttpUtilities.TOMCAT_SERVER.Url__c, 'POST_BODY', SNG_HttpCallout.CONTENT_TYPE_URL_ENCODED);
    	Test.stopTest();
    }
    
    static testMethod void sendHttpGetRequestNeedAuthUnitTest() {
    	init();
    	SNG_HttpCallout.sendHttpGetRequest(SNGHttpUtilities.TOMCAT_SERVER.Url__c + SNG_MockHttpCallout.URL_TOMCAT_NEED_AUTH);
    	Test.stopTest();
    }
    
    static testMethod void sendHttpPostRequestNeedAuthUnitTest() {
    	init();
    	SNG_HttpCallout.sendHttpPostRequest(SNGHttpUtilities.TOMCAT_SERVER.Url__c + SNG_MockHttpCallout.URL_TOMCAT_NEED_AUTH);
    	Test.stopTest();
    }
    
    static testMethod void testHandleLoginExceptionCase()
    {
    	init();
    	Test.setMock(HttpCalloutMock.class, new SNG_MockHttpCalloutError());
    	
    	try
    	{
    	   SNG_HttpCallout.sendHttpGetRequest(SNGHttpUtilities.TOMCAT_SERVER.Url__c + SNG_MockHttpCallout.URL_TOMCAT_NEED_AUTH);
    	   System.assert(false);
    	}
    	catch (SNG_CalloutException e)
    	{
    	   System.assertEquals(true, e.getMessage().contains('Authentication Error'));
    	   System.assert(true);
    	}
    	Test.stopTest();
    }
    
    static testMethod void testHandleLoginNullAuthToken()
    {
        init();
        Test.setMock(HttpCalloutMock.class, new SNG_MockHttpCalloutNoAuthToken());
        
        try
        {
           SNG_HttpCallout.sendHttpGetRequest(SNGHttpUtilities.TOMCAT_SERVER.Url__c + SNG_MockHttpCallout.URL_TOMCAT_NEED_AUTH);
           System.assert(false);
        }
        catch (SNG_CalloutException e)
        {
           System.assertEquals(true, e.getMessage().contains('Null Auth Token'));
           System.assert(true);
        }
        Test.stopTest();
    }
  
    static testMethod void testHandleLoginMultipleCookies()
    {
        SNG_MockCustomSettings.initializeMultipleCookies();
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new SNG_MockHttpCalloutMultipleTokenIds());
        
        try
        {
           SNG_HttpCallout.sendHttpGetRequest(SNGHttpUtilities.TOMCAT_SERVER.Url__c + SNG_MockHttpCallout.URL_TOMCAT_NEED_AUTH);
           System.assert(true);
        }
        catch (SNG_CalloutException e)
        {
           System.assertEquals(true, e.getMessage().contains('Null Auth Token'));
           System.assert(false);
        }
        Test.stopTest();
        
        //verify cookie is stored.
    }
    
    private static void init() {
    	Test.setMock(HttpCalloutMock.class, new SNG_MockHttpCallout());
    	SNG_MockCustomSettings.initialize();
    	Test.startTest();
    }
    
    global class SNG_MockHttpCalloutError implements HttpCalloutMock {
   
        global HTTPResponse respond(HTTPRequest req)
        {
            throw new SNG_Exception('Expected error thrown.');
        }
    }
    
    global class SNG_MockHttpCalloutNoAuthToken implements HttpCalloutMock {

        private Integer needAuthCallCount = 0;

		public HTTPResponse respond(HTTPRequest req) {
		    final String COOKIES_TO_SET =   SNG_HttpCallout.OPENAM_COOKIE_NAME + SNG_HttpCallout.COOKIE_NAME_VALUE_DELIM 
		                                  + SNG_MockHttpCallout.TOKEN_ID;
		    
		    HTTPResponse res = new HTTPResponse();
		    final String endpoint = req.getEndpoint();
		    
		    if (SNGHttpUtilities.TOMCAT_SERVER.Url__c + SNG_MockHttpCallout.URL_TOMCAT_NEED_AUTH == endpoint) {
		        if (++needAuthCallCount > 1) {
		            // the response the second time, after logging in
		            System.assertEquals(COOKIES_TO_SET, req.getHeader(SNG_HttpCallout.COOKIE_HEADER_KEY));
		            res.setStatusCode(SNGHttpUtilities.STATUS_CODE.OK);
		            res.setBody(endpoint);
		        } else {
		            // the response the first time
		            res.setStatusCode(SNGHttpUtilities.STATUS_CODE.FOUND);
		            res.setHeader(SNG_HttpCallout.LOCATION_HEADER_KEY, SNGHttpUtilities.OPENAM_LOGIN.Url__c);
		        }
		    }
		    
		    return res;
		} 
    }
   
    global class SNG_MockHttpCalloutMultipleTokenIds implements HttpCalloutMock {
	    
	    public final String URL_GET_NO_LOGIN = 'https://URL_GET_NO_LOGIN';
	    public final String URL_POST_NO_LOGIN = 'https://URL_POST_NO_LOGIN';
	    public final String URL_TOMCAT_NEED_AUTH = '/needAuth';
    
        @TestVisible
        private final String TOKEN_ID_1 = 'AQIC5wM2LY4Sfcz-IEhznLoNnJRvY-_ifTCEoEXPw6jdSrM.*AAJTSQACMDIAAlMxAAIwMQ..*';
    
        @TestVisible
        private final String TOKEN_ID_2 = 'BQIC5wM2LY4Sfcz-IEhznLoNnJRvY-_ifTCEoEXPw6jdSrM.*AAJTSQACMDIAAlMxAAIwMQ..*';
    
        private Integer needAuthCallCount = 0;
    
        // The header for where the cookie is stored in the response from OpenAM
        private final transient String SET_COOKIE_HEADER_KEY = 'SET-COOKIE';

	    public HTTPResponse respond(HTTPRequest req) {
	        final String COOKIES_TO_SET = SNG_HttpCallout.OPENAM_COOKIE_NAME + SNG_HttpCallout.COOKIE_NAME_VALUE_DELIM + TOKEN_ID_1 +
	                                      SNG_HttpCallout.COOKIE_DELIM + //SNG_HttpCallout.COOKIE_EMPTY_STRING + 
	                                      SNG_HttpCallout.LB_COOKIE_NAME + SNG_HttpCallout.COOKIE_NAME_VALUE_DELIM + TOKEN_ID_2;
	        
	        HTTPResponse res = new HTTPResponse();
	        final String endpoint = req.getEndpoint();
	        
	        if (SNGHttpUtilities.TOMCAT_SERVER.Url__c + URL_TOMCAT_NEED_AUTH == endpoint) {
	            if (++needAuthCallCount > 1) {
	                // the response the second time, after logging in
	                System.assertEquals(COOKIES_TO_SET, req.getHeader(SNG_HttpCallout.COOKIE_HEADER_KEY));
	                res.setStatusCode(SNGHttpUtilities.STATUS_CODE.OK);
	                res.setHeader(SET_COOKIE_HEADER_KEY, COOKIES_TO_SET);
	                res.setBody(endpoint);
	            } else {
	                // the response the first time
	                res.setStatusCode(SNGHttpUtilities.STATUS_CODE.FOUND);
	                res.setHeader(SNG_HttpCallout.LOCATION_HEADER_KEY, SNGHttpUtilities.OPENAM_LOGIN.Url__c);
	            }
	        }else if (endpoint.startsWith(URL_GET_NO_LOGIN) || endpoint.startsWith(SNGHttpUtilities.TOMCAT_SERVER.Url__c) 
                   || endpoint.startsWith(URL_POST_NO_LOGIN)) {
		            res.setStatusCode(SNGHttpUtilities.STATUS_CODE.OK);
		            res.setHeader(SET_COOKIE_HEADER_KEY, COOKIES_TO_SET);
		            res.setBody(endpoint);
		    } else if (endpoint.startsWith(SNGHttpUtilities.OPENAM_LOGIN.Url__c)) {
		        res.setStatusCode(SNGHttpUtilities.STATUS_CODE.OK);
		        res.setBody('token.id=' + TOKEN_ID_1 + ';' + SNG_HttpCallout.LB_COOKIE_NAME + + SNG_HttpCallout.COOKIE_NAME_VALUE_DELIM + TOKEN_ID_2);
		    }
        
	        
	        System.debug('Response: ' + res);
	        
	        return res;
	    }
    }
}