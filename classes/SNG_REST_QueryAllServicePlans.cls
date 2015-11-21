/**
 * This class is used to support a RESTful API to retrieve the service plans under the user's account. It is 
 * an entry point into the Apex code.
 */
@RestResource(urlMapping='/service-plans/ids')
global with sharing class SNG_REST_QueryAllServicePlans 
{
	/**
     * The SObject type for service plans.
     */
    private static final String SERVICEPLAN_OBJ = 'ServicePlan__c';
    
    /**
     * The regular expression prefix for a service plan ID.
     */
    private static final String SERVICEPLAN_REGEX_PREFIX = '[Ss][Pp][-]';
	
    /**
     * Retrieves a list of service plan names that are under the user's account.
     *
     * @return                   The JSON response that contains the service plans visible under the user's account.
     */
    @HttpGet
    global static SNG_REST_JsonResponse get()
    {
    	SfIdChecker spIdValidator = new SfIdChecker(SERVICEPLAN_REGEX_PREFIX);
    	SNG_REST_NameCollection terminalNames = new SNG_REST_NameCollection(SERVICEPLAN_OBJ, spIdValidator);         
        return new SNG_REST_JsonResponse(terminalNames.handleRequest(RestContext.request));
    }
}