/**
 * This class is used to support a RESTful API for the user to retrieve a list of terminal Ids for a list of given MAC addresses. It is 
 * an entry point into the Apex code.
 */
@RestResource(urlMapping='/modems/terminal-id')
global with sharing class SNG_REST_TerminalIdsApi {
	
    /**
     * Used to retrieve terminal IDs through a RESTful API interface using
     * HTTP get. 
     *
     * @return                  The terminal IDs based on the mac addresses in the URI.
     */
    @HttpGet
    global static SNG_REST_JsonResponse getTerminalIds() {
        SNG_ExceptionUtil.throwIfNullObject(RestContext.request, 'This method invocation must be made from a RESTful API request.');
        return new SNG_REST_JsonResponse(new SNG_REST_TerminalIds(new SNG_ModemMacAddressConverter()).handleRequest(RestContext.Request));
    }
    
}