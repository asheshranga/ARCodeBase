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
public class SNG_MockHttpCallout implements HttpCalloutMock {
	
	public static final String URL_GET_NO_LOGIN = 'https://URL_GET_NO_LOGIN';
	public static final String URL_POST_NO_LOGIN = 'https://URL_POST_NO_LOGIN';
	public static final String URL_TOMCAT_NEED_AUTH = '/needAuth';
	
	@TestVisible
	private static final String TOKEN_ID = 'AQIC5wM2LY4Sfcz-IEhznLoNnJRvY-_ifTCEoEXPw6jdSrM.*AAJTSQACMDIAAlMxAAIwMQ..*';
	
	private static Integer needAuthCallCount = 0;
	
	/**
	 * The header for where the cookie is stored in the response from OpenAM
	 */
	private static final transient String SET_COOKIE_HEADER_KEY = 'SET-COOKIE';

    public HTTPResponse respond(HTTPRequest req) {
    	final String COOKIES_TO_SET = SNG_HttpCallout.OPENAM_COOKIE_NAME + SNG_HttpCallout.COOKIE_NAME_VALUE_DELIM + TOKEN_ID;
    	
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
    	} else if (endpoint.startsWith(URL_GET_NO_LOGIN) || endpoint.startsWith(SNGHttpUtilities.TOMCAT_SERVER.Url__c) 
    	 || endpoint.startsWith(URL_POST_NO_LOGIN)) {
    		res.setStatusCode(SNGHttpUtilities.STATUS_CODE.OK);
    		res.setHeader(SET_COOKIE_HEADER_KEY, COOKIES_TO_SET);
    		res.setBody(endpoint);
    	} else if (endpoint.startsWith(SNGHttpUtilities.OPENAM_LOGIN.Url__c)) {
    		res.setStatusCode(SNGHttpUtilities.STATUS_CODE.OK);
    		res.setBody('token.id=' + TOKEN_ID);
    	}
    	
    	System.debug('Response: ' + res);
    	
    	return res;
    }
}