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
private with sharing class TestServices 
{
    // HttpCalloutMock Interface for Multi HttpMock Tests
    public class MockHttpResponseGenerator implements HttpCalloutMock
    {
        public HTTPResponse respond(HTTPRequest req) 
        {   
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'text/xml');
            
            // 1. HTTPRequestCallOut
            if(req.getBody().contains('Call 1'))
                res.setBody('<soapenv:Envelope><soapenv:Body>Response 1</soapenv:Body></soapenv:Envelope>');
            else if(req.getBody().contains('Call 2'))
                res.setBody('<soapenv:Envelope><soapenv:Body>Response 2</soapenv:Body></soapenv:Envelope>');
            else if(req.getBody().contains('Call 3'))
                res.setBody('<soapenv:Envelope><soapenv:Body>Response 3</soapenv:Body></soapenv:Envelope>');            
            res.setStatusCode(200);
            return res;
        }
    }

    //  Methods defined as TestMethod do not support Web service callouts
    public static testMethod void HTTPRequestCallOutTest() 
    {
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());

        String lsToken = '';
        Boolean lbValidToken = false;
        
        // HTTPResponse res = HTTPRequestCallOut.invokeService('%BASEURL%/identity/authenticate?username=%USERNAME%&password=%PASSWORD%','GET',9000,'','');
        lsToken = OpenAMAuthService.getAuthToken('https://sso.test.exede.net/federation','eecp','vg3NecHN3w71');
        system.debug('Token =' + lsToken);

        if (lsToken==null)
            lsToken ='testToken';
        lbValidToken = OpenAMAuthService.validateToken('https://sso.test.exede.net/federation',lsToken.trim());
        
        system.debug('Valid Token? ' + lbValidToken);

        if (lbValidToken!=null && lbValidToken)
        {
            HTTPResponse res = HTTPRequestCallOut.invokeService('https://sngapp.test.exede.net/PmdrService/query/perf/phy/latest/00:a0:bc:26:42:0b','GET',9000,'application/x-www-form-urlencoded','iPlanetDirectoryPro=' + lsToken.trim());
   
            if (res !=null) 
            {
            system.debug('SNG Service - Status = ' + res.getStatusCode());   
            system.debug('SNG Service - Body = ' + res.getBody());
            } 
            else
                system.debug('SNG Service Response is null'); 
        }
    }
}