/**
 * This class is used to support a RESTful API methods that take as input multiple objects
 * This class can only be created and invoked from within Apex REST methods
 */
public abstract with sharing class SNG_REST_Collection implements SNG_REST_ICollection {
	
    /**
     * The key identifier for parameters when performing a request for a list of items.
     */
    public static final String IDS_PARAM = 'ids';

    /**
     * The ID converter.
     */
    protected final SNG_IConverter idConverter;

    /**
     * Creates an instance of this object. The constructor is invoked if an ID converter
     * is not required.
     * 
     * @param    idConverter       The converter for the ID once validated.
     */
    public SNG_REST_Collection()
    {
        this(null);
    }

    /**
     * Creates an instance of this object.
     * 
     * @param    idConverter       The converter for the ID once validated.
     */
    public SNG_REST_Collection(SNG_IConverter idConverter)
    {
        // null is allowed.
        this.idConverter = idConverter; 
    }


	/**
	 * handles the API request for a collection of objects.
	 * @param  restReq					REST request
	 * @return                       	response capturing the data and the status of the request.
	 */
	public SNG_REST_Response handleRequest(RestRequest restReq)
    {
    	return handleRequest(extractIds(restReq));
    }

	/**
	 * helper method to handle the API request for a collection of objects. May also be leveraged
	 * by corresponding instance API method
	 * @param  ids 						ID names of objects for which information is requested
	 * @return                   	    response
	 */
	public SNG_REST_Response handleRequest(String[] ids)
    {
        SNG_REST_Response response = null;

        try
        {
            response = process(ids);
        }
        catch (SNG_REST_Exception e)
        {
            SNG_REST_ErrorReporter.logError(e);
            response = new SNG_REST_Response(e.statusDetail, null);
        }
        catch (Exception e)
        {
            // these are unexpected errors. Using a generic response
            SNG_REST_StatusDetail detail = new SNG_REST_StatusDetail( SNGHttpUtilities.Status.SERVER_ERROR,
                                                                      SNG_REST_Error.SubCode.SALESFORCE_GENERATED_ERROR,
                                                                      SNG_REST_ERROR.INTERNAL_SERVER_ERROR );

            SNG_REST_ErrorReporter.logError(detail, e);
            response = new SNG_REST_Response(detail, null);
        }

        return response;
    }
    
    private SNG_REST_Response process(String[] ids)
    {
        List<String> uniqueIds = removeDuplicateIds(ids);
        SNG_REST_Response response =  ArrayUtils.isEmpty(ids) ?  processNoIdInstance() : processIdCollection(uniqueIds);
        response = updateDataIfStatusNotOK(response);
        return response;
    }

    /**
     * Removes duplicate IDs within the request. This ensures that minimal processing is performed
     * for a RESTful API request.
     *
     * @param  ids                       The list of IDs to process.
     * @return                           The list of unique IDs.
     */
    private List<String> removeDuplicateIds(String[] ids)
    {
        Set<String> keys = new Set<String>(); 
        if(!ArrayUtils.isEmpty(ids))
        {
            for(String id : ids)
            {
                String upperCaseId = id.toUpperCase();
                keys.add(upperCaseId);
            }
        }
        return new List<String>(keys);
    }
    
    
    /**
     * Process the API request for all objects. In this instance, the client does not provide
     * a specific filter.
     *
     * @return                          response capturing the data and the status of the request.
     */
    private SNG_REST_Response processNoIdInstance()
    {
    	SObject[] objs = getSObjects();
    	return constructResultList(evaluateStatus(null, objs), new List<String>(), objs);
    }
    
    /**
     * Process the API request for a specified collection of objects.
     *
     * @param     ids                   The IDs to process.
     * @return                          response capturing the data and the status of the request.
     */
    private SNG_REST_Response processIdCollection(String[] ids)
    {
    	SNG_REST_Response response;    	
    	
    	if (validateIds(ids))
    	{
            // Use this.ids field, since validateIds modified the values of the ids field
            String[] convertedIds = (null != idConverter) ? idConverter.convert(ids) : ids;
    		SObject[] objs = getSObjects(convertedIds);
    		response = constructResultList(evaluateStatus(convertedIds, objs), convertedIds, objs);
    	}
    	else
    	{
    		response = new SNG_REST_Response(SNGHttpUtilities.Status.INPUT_VALIDATION_ERROR,
    		                                 SNG_REST_Error.SubCode.SALESFORCE_GENERATED_ERROR,
    		                                 SNG_REST_Error.INPUT_INVALID_FORMAT,
    		                                 null);
    	}
    	
    	return response;
    }
    
    /**
     * Evaluates the initial request status by comparing the requested IDs and the corresponding
     * objects retrieved based on the IDs.
     *
     * @param     ids                   The IDs specified in the RESTful API request
     * @param     objs                  The corresponding objects of the IDs.
     * @return                          The status details based on comparing the IDs and objects.
     */
    private SNG_REST_StatusDetail evaluateStatus(String[] ids, SObject[] objs)
    {
    	SNG_REST_StatusDetail detail = new SNG_REST_StatusDetail(SNGHttpUtilities.Status.OK, null);
    
        if (!ArrayUtils.isEmpty(ids) && ids.size() != objs.size() )
        {
            detail.status = (objs.isEmpty()) ? SNGHttpUtilities.Status.ZERO_RESULTS : SNGHttpUtilities.Status.OK_WITH_ERRORS;
            detail.code = SNG_REST_Error.SubCode.SALESFORCE_GENERATED_ERROR;
            detail.message = SNG_REST_Error.IDS_INVALID;
        }
        // do not have ids = get all and the result is empty
        else if (ArrayUtils.isEmpty(ids) && objs.isEmpty())
        {
        	detail.status = SNGHttpUtilities.Status.ZERO_RESULTS; 
        }
       
        return detail;
    }
    
    /**
     * Updates the response data if the status is not OK for the REST request.
     * 
     * @param      response              The REST response
     * @return                           The updated REST response.
     */
    private SNG_REST_Response updateDataIfStatusNotOk(SNG_REST_Response response)
    {
    	response.data = (SNG_REST_Utilities.isStatusOK(response.detail.status)) ? response.data : null;
    	return response;
    }
    
    /**
     * Extracts the IDs from the REST request.
     *
     * @param     req                   Represents an object used to pass data from an HTTP request to an 
     *                                  Apex RESTful Web service method.
     * @return                          An array of extracted IDs.
     */
	private static String[] extractIds(final RestRequest req)
	{
        String objs = (null != req) ? req.params.get(IDS_PARAM) : null;
        return (null != objs) ? objs.split(',') : null;
	}

    /**
     * Validates the array of IDs through the abstract method, which is defined in the subclass.
     *
     * @param     ids                   The list of IDs to verify.
     * @return                          True if IDs are valid; false otherwise.
     */
    private boolean validateIds(String[] ids) {
        boolean success = true;
        
        for (String id : ids)
        {
            if (!isValidId(id))
            {
                success = false;
                break;
            }
        }                 

        return success;
    }

	/**
     * Checks if the ID name is of valid format
     *
     * @param ids	ID name of salesforce custom object to check
     * @return		true if ID is valid; false otherwise
     */
	abstract boolean isValidId(String id);

	/**
     * Retrieves salesforce custom objects relevant to the calling API method based on the list
     * 	of ID names that are input
     *
     * @param ids	ID names of the custom objects to be retrieved
     * @return		custom objects corresponding to the list of ID names
     */
    abstract sobject[] getSObjects(String[] ids);

    /**
     * Retrieves ALL salesforce custom objects associated with account relevant to the
     * 	calling API method
     *
     * @return		all custom objects associated with account relevant to the calling API method
     */
    abstract sobject[] getSObjects();

    /**
     * Constructs the resulting list of JSON objects with the data corresponding to the collected objects
     *
     * @param   detail    The current detail. this can be overridden as necessary.
     * @param   ids       The collection of IDs for the data requested.
     * @param   objs      The objects corresponding to the ids.
     * @return		      resulting list of JSON objects. Return type is polymorphic depending on the
     * 					  particular API. Primitive types may be valid return types which precludes
     * 					  the use of a marker interface as the return type in this signature
     */
    abstract SNG_REST_Response constructResultList(SNG_REST_StatusDetail detail, string[] ids, sobject[] objs);
}