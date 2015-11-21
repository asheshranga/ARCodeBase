/**
 * This class is used to support a RESTful API to retrieve terminal administrative information. It is 
 * an entry point into the Apex code.
 */
@RestResource(urlMapping='/terminal/*/info')
global with sharing class SNG_REST_TerminalAdminInfo 
{	
    /**
     * Used to retrieve the latest administrative information for a list of Terminals through a RESTful API interface using
     * HTTP get. 
     *
     * @return                  The JSON response containing administrative information for the list of terminals
     */
    @HttpGet
    global static SNG_REST_JsonResponse get()
    {
    	return new SNG_REST_Instance().handleRequest(RestContext.request, new SNG_REST_TerminalsAdminInfoRequest());
    }
}