/**
 * This class is used to support the following RESTful API method. It is an entry point into the Apex code.
 * GET /terminals/status?{parameters}
 */
@RestResource(urlMapping='/terminals/status')
global with sharing class SNG_REST_TerminalsStatus {

	/**
     * Used to retrieve the latest Performance data for a list of Terminals through a RESTful API interface using
     * HTTP get.
     *
     * @return		The JSON response containing performance data for the list of terminals
     */   
    @HttpGet
    global static SNG_REST_JsonResponse get() {
        SNG_ExceptionUtil.throwIfNullObject(RestContext.request, 'This method invocation must be made from a RESTful API request.');
        SNG_REST_Response output = new SNG_REST_TerminalStatusHandler().handleRequest(RestContext.request);
        return new SNG_REST_JsonResponse(output);
    }
}