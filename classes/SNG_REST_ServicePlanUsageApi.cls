/**
 * This class is used to support a RESTful API for the Service Plan usage data info method
 * that takes as input a single id in the Resource Path. It is an entry point into the Apex code.
 */
@RestResource(urlMapping='/service-plan/*/usage')
global with sharing class SNG_REST_ServicePlanUsageApi 
{
    /**
     * Retrieve service plan usage data for a service plan.
     *
     * @return                The SNG_REST_JsonResponse object. Note that the object is converted
     *                        to a JSON string representation of the object,
     *                        since the API is invoked using a RESTful API request.
     */
    @HttpGet
    global static SNG_REST_JsonResponse get()
    {
        return new SNG_REST_ServicePlanUsage(RestContext.request).get();
    }
}