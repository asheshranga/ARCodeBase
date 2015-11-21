@RestResource(urlMapping='/modems/ids')
global with sharing class SNG_REST_QueryAllModemMacAddresses {
	
	private static final String MODEM_NAME = 'Modem__c'; 
	
	@HttpGet
	global static SNG_REST_JsonResponse getModemMacAddresses() { 
	
		// create a validator to check for modem mac address format
		SNG_ModemMacAddressChecker validator = new SNG_ModemMacAddressChecker();
		
		SNG_REST_NameCollection modemMacAddresses = new SNG_REST_NameCollection(MODEM_NAME, validator);
		
		SNG_REST_Response response = modemMacAddresses.handleRequest(RestContext.request); 
		
		return new SNG_REST_JsonResponse(response); 
	}
	
}