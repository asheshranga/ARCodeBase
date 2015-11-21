/**
 * This class is used to support a RESTful API for the user to retrieve a terminal Id for a given MAC address. It is 
 * an entry point into the Apex code.
 */
@RestResource(urlMapping='/modem/*/terminal-id')
global with sharing class SNG_REST_TerminalIdApi {
	
    /**
     * Used to retrieve the terminal ID through a RESTful API interface using
     * HTTP get. 
     *
     * @return                  The terminal ID based on the mac address in the URI.
     */
    @HttpGet
    global static SNG_REST_JsonResponse getTerminalId() {
        SNG_ExceptionUtil.throwIfNullObject(RestContext.request, 'This method invocation must be made from a RESTful API request.');
        return new SNG_REST_Instance().handleRequest(RestContext.request, new SNG_REST_TerminalIds(new SNG_ModemMacAddressConverter()));
    }
    
}