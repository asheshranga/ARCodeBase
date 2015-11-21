@isTest
global class SNGMockModemSoftwareVersionHttpCallout implements HttpCalloutMock
{
    public static final transient String MACADDR_OK = '00:a0:bc:11:11:11';
    public static final transient String MACADDR_HTTP_ERROR = '00:a0:bc:22:22:22';
    public static final transient String MACADDR_CMD_ERROR = '00:a0:bc:33:33:33';
    public static final transient String SOFTWARE_VERSION = 'UT_1.3.4';
    public static final transient String MACADDR_ZERO_RESULTS = '00:a0:bc:44:44:44';
    
    global HTTPResponse respond(HTTPRequest req) {
        HTTPResponse res = new HTTPResponse();
        final String ENDPOINT = req.getEndpoint();
        
        if (ENDPOINT.contains(MACADDR_OK)) {
            res.setStatusCode(SNGHttpUtilities.STATUS_CODE.OK);
            res.setBody('{"result": [{' +
                        '"MACADDR": "00:a0:bc:11:11:11",' +
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