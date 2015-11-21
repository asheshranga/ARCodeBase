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
public with sharing class SNG_MockModemSoftwareVersionHttpCallout implements HttpCalloutMock
{
    public static final transient String MACADDR_OK = '00:a0:bc:11:11:11';
    public static final transient String MACADDR_HTTP_ERROR = '00:a0:bc:22:22:22';
    public static final transient String MACADDR_CMD_ERROR = '00:a0:bc:33:33:33';
    public static final transient String SOFTWARE_VERSION = 'UT_1.3.4';
    public static final transient String MACADDR_ZERO_RESULTS = '00:a0:bc:44:44:44';
    public static final transient String MACADDR_OK_WITH_ERRORS =  MACADDR_ZERO_RESULTS + ',' + MACADDR_OK;
    
    public HTTPResponse respond(HTTPRequest req) {
        HTTPResponse res = new HTTPResponse();
        final String ENDPOINT = req.getEndpoint();
        
        if (ENDPOINT.contains(MACADDR_OK_WITH_ERRORS))
        {  	
            res.setStatusCode(SNGHttpUtilities.STATUS_CODE.OK);
            res.setBody('{"result": [{' +
                        '"MACADDR": "' + SNGHttpUtilities.translateMacAddressFromSfToDbFormat(MACADDR_OK) + '",' +
                        '"SOFTWAREVERSION": "' + SOFTWARE_VERSION + '"' +
                        '},{' +
                        '"MACADDR": "' + SNGHttpUtilities.translateMacAddressFromSfToDbFormat(MACADDR_ZERO_RESULTS) + '",' +
                        '"SOFTWAREVERSION": null' +                       
                        '}],' +
                        '"status": "OK_WITH_ERRORS"}');        	
        	
        }
        else if (ENDPOINT.contains(MACADDR_OK)) {
            res.setStatusCode(SNGHttpUtilities.STATUS_CODE.OK);
            res.setBody('{"result": [{' +
                        '"MACADDR": "' + SNGHttpUtilities.translateMacAddressFromSfToDbFormat(MACADDR_OK) + '",' +
                        '"SOFTWAREVERSION": "' + SOFTWARE_VERSION + '"' +
                        '}],' +
                        '"status": "OK"}');
        } 
        else if (ENDPOINT.contains(MACADDR_ZERO_RESULTS))
        {
            res.setStatusCode(SNGHttpUtilities.STATUS_CODE.OK);
            res.setBody('{"result":[], "status":"ZERO_RESULTS"}');
        } 
        
        else if (ENDPOINT.contains(MACADDR_HTTP_ERROR)) {
            res.setStatusCode(SNGHttpUtilities.STATUS_CODE.NOT_FOUND);
            res.setStatus('Not found');
        } else if (ENDPOINT.contains(MACADDR_CMD_ERROR)) {
            res.setStatusCode(SNGHttpUtilities.STATUS_CODE.OK);
            String resBody = '{"' + SNG_AbstractTomcatCmd.FIELD.ERROR_CODE + '":-1,' 
                           + '"' + SNG_AbstractTomcatCmd.FIELD.ERROR_MESSAGE + '":"Something went wrong!"}';
            res.setBody(resBody);
        } else if (ENDPOINT.startsWith(SNG_MockCustomSettings.MOCK_OPENAM_URL)) {
            System.debug('SNGMockModemSoftwareVersionHttpCallout.respond: OpenAM Authentication');
            System.assertEquals('GET', req.getMethod());
            
            res.setStatusCode(SNGHttpUtilities.STATUS_CODE.OK);
            res.setBody('token.id=' + SNG_MockHttpCallout.TOKEN_ID);
        }
        
        return res;
    }
}