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
global class SNG_MockUtPeersHttpCallout implements HttpCalloutMock {
	
	public static final String SUNNY_DAY_SINGLE_VALID_MAC_ADDRESS = '00:a0:bc:44:55:11';
    public static final String HTTP_STATUS_FAILURE_MAC_ADDRESS = '00:a0:bc:44:55:22';
    public static final String INVALID_RESPONSE_FORMAT_MAC_ADDRESS = '00:a0:bc:44:55:33';
    public static final String SUNNY_DAY_DOUBLE_VALID_MAC_ADDRESS_1 = '00:a0:bc:44:55:44';
    public static final String SUNNY_DAY_DOUBLE_VALID_MAC_ADDRESS_2 = '00:a0:bc:44:55:55';
    
    
    public static final Integer SUNNY_DAY_SINGLE_NUM_PEERS_ONLINE = 4;
    public static final Decimal SUNNY_DAY_SINGLE_AVG_RL_SYM_RATE = 3.867;
    
    public static final Integer SUNNY_DAY_DOUBLE_NUM_PEERS_ONLINE_1 = 5;
    public static final Decimal SUNNY_DAY_DOUBLE_AVG_RL_SYM_RATE_1 = 6.997;

    public static final Integer SUNNY_DAY_DOUBLE_NUM_PEERS_ONLINE_2 = 18;
    public static final Decimal SUNNY_DAY_DOUBLE_AVG_RL_SYM_RATE_2 = 5.12;
		
	/**
	 * Returns an HTTP response for a given request. This method is called by Apex
	 * runtime to send fake response when an HTTP callout is made after Test.setMock has been called. 
	 */ 
	global HTTPResponse respond(HTTPRequest req) {
		 
		String endpoint = req.getEndpoint();
        
        HttpResponse res = new HttpResponse();
        
        if (endpoint.contains('/PmdrService/query/perf/peer/latest/avg'))
        {
	         res = generatePmdrResponse(req);
        }
        else if (ENDPOINT.startsWith(SNG_MockCustomSettings.MOCK_OPENAM_URL)) {
            System.debug('SNG_MockUsageServiceHttpCallout.respond: OpenAM Authentication');
            System.assertEquals('GET', req.getMethod());
            
            res.setStatusCode(SNGHttpUtilities.STATUS_CODE.OK);
            res.setBody('token.id=' + SNG_MockHttpCallout.TOKEN_ID);
        }
        else 
        {
             res = generateResponseMimicRequest(req);
        }
		 
		return res; 
	}
	
	private HTTPResponse generatePmdrResponse(HTTPRequest req)
	{
		 HttpResponse res = new HttpResponse();
		 String jsonRequestBody = req.getBody();
		
		 if (jsonRequestBody.contains(SUNNY_DAY_SINGLE_VALID_MAC_ADDRESS))
         {
             String macAddressFormatted = formatMacAddress(SUNNY_DAY_SINGLE_VALID_MAC_ADDRESS);
             res.setHeader('Content-Type', 'application/json');
             res.setBody('{' +
                              '"status" : "success"' + ',' +
                              '"result": [' + 
                               '{' +
                                   '"NUM_PEERS_ONLINE" : ' + SUNNY_DAY_SINGLE_NUM_PEERS_ONLINE + ',' +
                                   '"AVG_RL_SYM_RATE" : ' + SUNNY_DAY_SINGLE_AVG_RL_SYM_RATE + ','  +
                                   '"id" : "' +  macAddressFormatted + '"' +
                               '}]' + 
                          '}'
                       );
             res.setStatusCode(SNGHttpUtilities.STATUS_CODE.OK);
         }
         else if (jsonRequestBody.contains(HTTP_STATUS_FAILURE_MAC_ADDRESS))
         {
         	  res.setStatusCode(SNGHttpUtilities.STATUS_CODE.NOT_FOUND);
         }
         else if (jsonRequestBody.contains(INVALID_RESPONSE_FORMAT_MAC_ADDRESS))
         {
         	 res.setHeader('Content-Type', 'application/json');
         	 res.setBody('invalidFormatBody');
         	 res.setStatusCode(SNGHttpUtilities.STATUS_CODE.OK);
         }
         else if (jsonRequestBody.contains(SUNNY_DAY_DOUBLE_VALID_MAC_ADDRESS_1) &&
                  jsonRequestBody.contains(SUNNY_DAY_DOUBLE_VALID_MAC_ADDRESS_2))
         {
             String macAddressFormatted1 = formatMacAddress(SUNNY_DAY_DOUBLE_VALID_MAC_ADDRESS_1);
             String macAddressFormatted2 = formatMacAddress(SUNNY_DAY_DOUBLE_VALID_MAC_ADDRESS_2);
             res.setHeader('Content-Type', 'application/json');
             res.setBody('{' +
                              '"status" : "success"' + ',' +
                              '"result": [' + 
                               '{' +
                                   '"NUM_PEERS_ONLINE" : ' + SUNNY_DAY_DOUBLE_NUM_PEERS_ONLINE_1 + ',' +
                                   '"AVG_RL_SYM_RATE" : ' + SUNNY_DAY_DOUBLE_AVG_RL_SYM_RATE_1 + ','  +
                                   '"id" : "' +  macAddressFormatted1 + '"' +
                               '},' +
                               '{' +
                                   '"NUM_PEERS_ONLINE" : ' + SUNNY_DAY_DOUBLE_NUM_PEERS_ONLINE_2 + ',' +
                                   '"AVG_RL_SYM_RATE" : ' + SUNNY_DAY_DOUBLE_AVG_RL_SYM_RATE_2 + ','  +
                                   '"id" : "' +  macAddressFormatted2 + '"' +
                               '}]' + 
                          '}'
                       );
             res.setStatusCode(SNGHttpUtilities.STATUS_CODE.OK);         	
         }
         
         return res;
	}
	
	
	private HTTPResponse generateResponseMimicRequest(HTTPRequest req)
	{
		 HTTPResponse res = new HTTPResponse();
		
		 SNG_UtPeersHttpCallout.SNG_UtPeersRequestBody utPeersRequest = 
                                        (SNG_UtPeersHttpCallout.SNG_UtPeersRequestBody) JSON.deserialize(req.getBody(), SNG_UtPeersHttpCallout.SNG_UtPeersRequestBody.class);
             
         String resBody = 
            '{' + 
            '   "minutesFromNow": ' + utPeersRequest.minutesFromNow + ',' +  
            '   "macAddresses":[ ';
         
         for (integer i = 0; i < utPeersRequest.macAddresses.size(); i++)
         {
             resBody = resBody + '"' + utPeersRequest.macAddresses.get(i) + '"';
             
             if (i < utPeersRequest.macAddresses.size() -1)
             {  
                resBody = resBody + ',';
             }
         }
         
         resBody = resBody + ']}'; 
         
         res.setHeader('Content-Type', 'application/json');
         res.setBody(resBody);
         res.setStatusCode(SNGHttpUtilities.STATUS_CODE.OK);
         
         return res;
	}
	
	private String formatMacAddress(String macAddress)
	{
		return '0x' + macAddress.replaceAll(':', '').toLowerCase();
	}
}