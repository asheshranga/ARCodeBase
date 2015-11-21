/**
 * This class is used to support the following RESTful API method. It is an entry point into the Apex code.
 * GET /terminal/{id}/status
 */
@RestResource(urlMapping='/terminal/*/status')
global with sharing class SNG_REST_TerminalStatus {

	/**
     * Used to retrieve the latest Performance data for a single Terminal through a RESTful API interface using
     * HTTP get.
     *
     * @return		The JSON response containing performance data for the terminal
     */
    @HttpGet
    global static SNG_REST_JsonResponse get() {
		return new SNG_REST_Instance().handleRequest(RestContext.request, new SNG_REST_TerminalStatusHandler());
    }
}