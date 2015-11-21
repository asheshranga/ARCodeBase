/**
 * This class is used to support a RESTful API to retrieve terminal administrative information. It is 
 * an entry point into the Apex code.
 */ 
@RestResource(urlMapping='/terminals/info/*')
global with sharing class SNG_REST_TerminalsAdminInfo 
{
    /**
     * Used to retrieve the latest administrative information for a list of Terminals through a RESTful API interface using
     * HTTP get. 
     *
     * @return                  The JSON response containing administrative information for the list of terminals
     */
    @HttpGet
    global static SNG_REST_JSONResponse get()
    {    	
        SNG_ExceptionUtil.throwIfNullObject(RestContext.request, 'This method invocation must be made from a RESTful API request.');
    	SNG_REST_Response output = new SNG_REST_TerminalsAdminInfoRequest().handleRequest(parseTerminals(RestContext.request));
    	return new SNG_REST_JsonResponse(output);
    }
     
    /**
     * Parses the request URI for the terminal IDs that are part of the request.
     *
     * @param   req                       The REST request information.
     * @return                            The list of terminals in the URI.   
     */
    private static List<String> parseTerminals(RestRequest req) 
    {
    	final String IDS_PARAM = 'ids';
        String objs = (null != req) ? req.params.get(IDS_PARAM) : null;
        return (null != objs) ? objs.split(',') : null;
    }
    
}