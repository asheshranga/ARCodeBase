/**
 * This class is used to support a RESTful API for the Service Plan administrative info method
 * that takes as input a single id in the Resource Path. It is an entry point into the Apex code.
 */
@RestResource(urlMapping='/service-plan/*/info')
global with sharing class SNG_REST_ServicePlanInfoApi {

    /**
     * Retrieve service plan admin info per service plan ID
     */
    @HttpGet
    global static SNG_REST_JsonResponse getServicePlanInfo()
    {
        SNG_REST_Instance servicePlanInfoHandler = new SNG_REST_Instance();
        return servicePlanInfoHandler.handleRequest(RestContext.request, new SNG_REST_ServicePlansInfo());
    }
}