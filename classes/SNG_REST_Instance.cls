/**
 * This class is used to support RESTful API methods that take a single ID of object in question.
 * This class can only be created and invoked from within Apex REST methods.
 * 
 * To use this class, there would be a call like this for example, from an API entry-point:
 *     return new SNG_REST_Instance().handleRequest(RestContext.request, new <COLLECTION_HANDLER_CLASS>());
 * 
 * The <COLLECTION_HANDLER> would be a class implementing SNG_REST_ICollection. The idea behind this design is
 * that this same class would be used in the collection version of the same API method. For example,
 * the entry-point for the collection version would do something like this:
 *     return new SNG_REST_JsonResponse(new <COLLECTION_HANDLER_CLASS>().handleRequest(RestContext.Request));
 */
public virtual with sharing class SNG_REST_Instance {

    /**
     * Constant regarding the number of IDs expected when the RESTful API request is made and
     * within the response. The IDs are expected with the URL path for the request.
     */
	private static final integer NUM_EXPECTED_IDS = 1;

    /**
     * Handles the request from the client.
     *
     * @param  restReq                The RESTful API request.
     * @param  collectionHandler      The handler to process the request.
     * @return                        The JSON response to the request.
     */
	public SNG_REST_JsonResponse handleRequest(RestRequest restReq, SNG_REST_ICollection collectionHandler)
    {
        SNG_REST_JsonResponse response = null;

        try
        {
            SNG_ExceptionUtil.throwIfNullObject(restReq, 'Method was invoked without a restReq.');
            SNG_ExceptionUtil.throwIfNullObject(collectionHandler, 'No handler available to support API request.');
            List<String> ids = new List<String>();
            ids.add(extractId(restReq));
            response = convertResponseToInstance(collectionHandler.handleRequest(ids));
        }
        catch (SNG_REST_Exception e)
        {
            SNG_REST_ErrorReporter.logError(e);
            response = new SNG_REST_JsonResponse(e.statusDetail, null);
        }
        catch (Exception e)
        {
            // these are unexpected errors. Using a generic response
            SNG_REST_StatusDetail detail = new SNG_REST_StatusDetail( SNGHttpUtilities.Status.SERVER_ERROR,
                                                                      SNG_REST_Error.SubCode.SALESFORCE_GENERATED_ERROR,
                                                                      SNG_REST_ERROR.INTERNAL_SERVER_ERROR );

            SNG_REST_ErrorReporter.logError(detail, e);
            response = new SNG_REST_JsonResponse(detail, null);
        }

        return response;
    }

	/**
	 * Converts the response to a single instance response.
	 * Assumption: instance version of API request yields response with single JSON object while
	 * 		collection version of API request yields list of JSON objects
	 *
	 * @param   resp                   Response to the request.
	 * @param                          The JSON response with single instance data.
	 */
	private SNG_REST_JsonResponse convertResponseToInstance(SNG_REST_Response resp) {
    	resp.data = convertCollectionResponseDataToInstance(resp);
    	return new SNG_REST_JsonResponse(resp);
	}

    /**
     * Converts the provided collection response data into instance response data
     *
     * @param 	resp                    Response data to convert.
     * @return	                  	    The instance response data, or null if status indicates error.
     */
    private static SNG_REST_IJsonResponseData convertCollectionResponseDataToInstance(final SNG_REST_Response resp) 
    {
    	
    	SNG_REST_IJsonResponseData outputData = null;
    	SNG_REST_CollectionOutput output = (null != resp) ? (SNG_REST_CollectionOutput)resp.data : null;

        if (null != output && SNG_REST_Utilities.isStatusOK(resp.detail.status))
        {
        	integer itemSize = (!ArrayUtils.isEmpty(output.items)) ? output.items.size() : 0;
            SNG_ExceptionUtil.assert(NUM_EXPECTED_IDS == itemSize, 'Expected single data item. Found ' +  itemSize);
            outputData = (!ArrayUtils.isEmpty(output.items)) ? (SNG_REST_IJsonResponseData)output.items[0] : null;
        }
        
        return outputData;
    }

    /**
     * Extracts the ID from the RESTful API request.
     *
     * @param   restReq                  The RESTful API request. Contains the URL of which API was invoked.
     * @return                           The singular ID found within the URL path.
     * @throws  SNG_Exception            If no IDs are found or if the URL does not contain the expected number of IDs.                  
     */
	private String extractId(final RestRequest restReq)
	{
		String id;
		String reqPath = restReq.requestUri;
		String path = SNG_REST_Utilities.getWildcardPath(restReq);
		List<String> pathVariables = SNG_REST_Utilities.getPathVariablesFromUri(restReq);

		if (pathVariables.isEmpty())
		{
			throw new SNG_Exception('No ID found in ' + reqPath);
		}
		else if (pathVariables.size() > NUM_EXPECTED_IDS)
		{
			throw new SNG_Exception('Expected ' + NUM_EXPECTED_IDs + ' ID(s) for URI path ' + path + '. Found ' + pathVariables.size()
					+ ' in ' + reqPath);
		}
		else
		{
			id = pathVariables[0];
		}
		return id;
	}
}