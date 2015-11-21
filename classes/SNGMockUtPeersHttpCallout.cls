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
global class SNGMockUtPeersHttpCallout implements HttpCalloutMock {
	
	public static final transient String MACADDR_OK = '00:a0:bc:11:11:11';
    public static final transient String MACADDR_HTTP_ERROR = '00:a0:bc:22:22:22';
    public static final transient String MACADDR_CMD_ERROR = '00:a0:bc:33:33:33';
    public static final transient String SOFTWARE_VERSION = 'UT_1.3.4';
    public static final transient String MACADDR_ZERO_RESULTS = '00:a0:bc:44:44:44';
    
    public static final transient Decimal AVG_RL_SYM_RATE = 4583.333333333333333333333333333333333333;

    global HTTPResponse respond(HTTPRequest req) {
        // TO DO: implement unit test
       HTTPResponse res = new HTTPResponse();
        final String ENDPOINT = req.getEndpoint();
        final String BODY = req.getBody();
        
        // OpenAM Login
        if (ENDPOINT.startsWith(SNG_MockCustomSettings.MOCK_OPENAM_URL)) {
            System.debug('SNGMockModemSoftwareVersionHttpCallout.respond: OpenAM Authentication');
            System.assertEquals('GET', req.getMethod());
            
            res.setStatusCode(SNGHttpUtilities.STATUS_CODE.OK);
            res.setBody('token.id=' + SNG_MockHttpCallout.TOKEN_ID);
        }
        
        else if (BODY.contains(MACADDR_OK)) {
            res.setStatusCode(SNGHttpUtilities.STATUS_CODE.OK);
            res.setBody('{"result": [{' +
                        '"AVG_RL_SYM_RATE": ' + 
                        AVG_RL_SYM_RATE + ',' +
                        '"NUM_PEERS_ONLINE": 6,' +
                        '"id": "' + SNGHttpUtilities.translateMacAddressFromSfToDbFormat(MACADDR_OK) + '"' +
                        '}],' +
                        '"status": "OK"}');
        } 
        else if (BODY.contains(MACADDR_ZERO_RESULTS))
        {
            res.setStatusCode(SNGHttpUtilities.STATUS_CODE.OK);
            res.setBody('{"result":[], "status":"ZERO_RESULTS"}');
        } 
        
        else if (BODY.contains(MACADDR_HTTP_ERROR)) {
            res.setStatusCode(SNGHttpUtilities.STATUS_CODE.NOT_FOUND);
            res.setStatus('Not found');
        } else if (BODY.contains(MACADDR_CMD_ERROR)) {
            res.setStatusCode(SNGHttpUtilities.STATUS_CODE.OK);
            String resBody = '{"' + SNG_AbstractTomcatCmd.FIELD.ERROR_CODE + '":-1,' 
                           + '"' + SNG_AbstractTomcatCmd.FIELD.ERROR_MESSAGE + '":"Something went wrong!"}';
            res.setBody(resBody);
        }
        
        return res;        
        /* { "result": [{ "AVG_RL_SYM_RATE": 4583.333333333333333333333333333333333333, "NUM_PEERS_ONLINE": 6 }], "status": "OK" }*/
    }
}