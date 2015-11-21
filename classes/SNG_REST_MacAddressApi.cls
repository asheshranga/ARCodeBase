/**
 * This class is used to support a RESTful API to retrieve the associated Modem MAC Address given the terminal ID. It is 
 * an entry point into the Apex code.
 */
@RestResource(urlMapping='/terminal/*/mac-address') 
global with sharing class SNG_REST_MacAddressApi {
	
	/**
	 * Retrieve Terminal's MAC address from terminal ID
	 */
	@HttpGet
	global static SNG_REST_JsonResponse getMacAddress() {
		SNG_ExceptionUtil.throwIfNullObject(RestContext.request, 'This method invocation must be made from a RESTful API request.');
		return new SNG_REST_Instance().handleRequest(RestContext.request, new SNG_REST_MacAddresses());
	}
	
}