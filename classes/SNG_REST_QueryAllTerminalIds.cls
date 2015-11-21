/**
 * This class is used to support a RESTful API to retrieve the terminal names under the user's account. It is 
 * an entry point into the Apex code.
 */
@RestResource(urlMapping='/terminals/ids')
global with sharing class SNG_REST_QueryAllTerminalIds 
{
	/**
	 * The SObject type for terminals.
	 */
	private static final String TERMINAL_OBJ = 'Terminal__c'; 
	
	/**
	 * The regular expression prefix for a terminal object.
	 */
	private static final String TERMINAL_PREFIX_REGEX = '[Tt]';
	
	/**
	 * Retrieves a list of terminal ids that are under the user's account.
	 *
	 * @return                   The JSON response that contains the terminal names visible under the user's account.
	 */
    @HttpGet
    global static SNG_REST_JsonResponse get()
    {
    	SNG_REST_Response response = new SNG_REST_NameCollection(TERMINAL_OBJ, new SfIdChecker(TERMINAL_PREFIX_REGEX)).handleRequest(RestContext.Request);
    	return new SNG_REST_JsonResponse(response);
    }
}