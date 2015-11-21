/**
 * This class is used to support a RESTful API for the Service Plan administrative info method. It is
 * an entry point into the Apex code.
 */
@RestResource(urlMapping='/service-plans/info') // URI_PATH constant must be edited below if this changes
global with sharing class SNG_REST_ServicePlansInfoApi {

	global static final String URI_PATH = '/service-plans/info';

	/**
	 * Retrieve list of service plan admin info per service plan IDs
	 */
	@HttpGet
	global static SNG_REST_JsonResponse getServicePlanInfo()
    {
		SNG_REST_ServicePlansInfo ServicePlansInfoApiHandler = new SNG_REST_ServicePlansInfo();
		return new SNG_REST_JsonResponse(ServicePlansInfoApiHandler.handleRequest(RestContext.Request));
    }
}