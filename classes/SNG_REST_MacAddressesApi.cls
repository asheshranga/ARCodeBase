/**
 * This class is used to support a RESTful API to retrieve the associated Modem MAC Addresses given a list of terminal IDs. It is 
 * an entry point into the Apex code.
 */
@RestResource(urlMapping='/terminals/mac-address') 
global with sharing class SNG_REST_MacAddressesApi {
	
	/**
	 * Retrieve Terminal's MAC addresses from terminal IDs
	 */
	@HttpGet
	global static SNG_REST_JsonResponse getMacAddresses() {
		SNG_ExceptionUtil.throwIfNullObject(RestContext.request, 'This method invocation must be made from a RESTful API request.');
		return new SNG_REST_JsonResponse(new SNG_REST_MacAddresses().handleRequest(RestContext.Request));
	}
	
}