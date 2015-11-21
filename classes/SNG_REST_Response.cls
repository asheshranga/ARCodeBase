public with sharing class SNG_REST_Response 
{
    public SNG_REST_StatusDetail detail;
    public SNG_REST_IJsonResponseData data;
    
    public SNG_REST_Response(SNG_REST_StatusDetail detail,  SNG_REST_IJsonResponseData data)
    {
    	this.detail = detail;
    	this.data = data;
    }
    
    /**
     * Creates an instance of this object, initializing the various parameters.
     *
     * @param    status             The status of the request.
     * @param    errorSubCode       The error subcode describing the source of the error.
     * @param    errorMessage       The detailed message of the error.
     * @param    data               The resulting data relevant to the API call
     */
    public SNG_REST_Response(SNGHttpUtilities.Status status, SNG_REST_Error.SubCode errorSubCode, String errorMessage,
                             SNG_REST_IJsonResponseData data)
    {
    	this(new SNG_REST_StatusDetail(status, errorSubCode, errorMessage), data);
    }
}