/**
 * This class is used to support the following RESTful API method. It is an entry point into the Apex code.
 * GET /modem/{mac-address}/usage?{parameters}
 */
@RestResource(urlMapping='/modem/*/usage')
global with sharing class SNG_REST_ModemUsageApi {
	
	/**
     * Retrieve modem usage data for a specified Modem MAC address.
     *
     * @return                The SNG_REST_JsonResponse object. Note that the object is converted
     *                        to a JSON string representation of the object,
     *                        since the API is invoked using a RESTful API request.
     */
	@HttpGet
	global static SNG_REST_JsonResponse get() 
	{ 
		return new SNG_REST_ModemUsage(RestContext.request).get();  
	}
}