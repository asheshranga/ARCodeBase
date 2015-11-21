/**
 * This class is used to support a RESTful API methods that take as input an id and a specified
 * date range.
 */
public abstract with sharing class SNG_REST_IdWithDateRange 
{
	/**
	 * The ID provided by the client used to query for data. The ID is expected to be part of the wildcard
	 * in the URL.
	 */
    protected String id;
    
    /**
     * The start date provided by the client used to query for data. The start date is expected to be part
     * the parameters in the URL request.
     */
    protected String startDate;

    /**
     * The end date provided by the client used to query for data. The end date is expected to be part
     * the parameters in the URL request.
     */    
    protected String endDate;
    
    /**
     * The expected number of IDs to be found from the wildcard path from which the API is invoked from.
     */
    private static final integer NUM_EXPECTED_IDS = 1;
    
    /**
     * The start date parameter id that is used as part of the filter in the URL request.
     */
    private static final String START_DATE_PARAM = 'start-date';
    
    /**
     * The end date parameter id that is used as part of the filter in the URL request.
     */
    private static final String END_DATE_PARAM = 'end-date';

    /**
     * The ID converter.
     */
    protected final SNG_IConverter idConverter;
    
    /**
     * Creates an instance of this object.
     * 
     * @param    restReq           The REST request information. This information is created through the client RESTful API request.
     * @param    idConverter       The converter for the ID once validated.
     * @throws   SNG_Exception     If expected parameters are not found or too many wildcards are encountered.
     */
    public SNG_REST_IdWithDateRange(final RestRequest restReq, final SNG_IConverter idConverter)
    {
    	SNG_ExceptionUtil.throwIfNullObject(restReq, 'SNG_REST_IdWithDateRange invoked with null RestRequest');        
        id = extractFromUri(restReq);
        this.idConverter = idConverter;
        startDate = extractFromParams(restReq, START_DATE_PARAM);
        endDate = extractFromParams(restReq, END_DATE_PARAM);
    }
    
    /**
     * Creates an instance of this object. This constructor can be used if the information is not wrapped within a RestRequest
     * object and the user explicitly requests to pass the information in.
     *
     * @param    id                The id for which the date applies to.
     * @param    startDate         The start date for the usage period requested.
     * @param    endDate           The end date for the usage data period requested.
     * @param    idConverter       The converter for the ID once validated.
     */
    public SNG_REST_IdWithDateRange(final String id, final String startDate, final String endDate, final SNG_IConverter idConverter)
    {
        this.id = id;
        this.idConverter = idConverter;
        this.startDate = startDate;
        this.endDate = endDate;
    }

    /**
     * The main entry point of the class. This method is invoked to obtain the data for the ID and the specified
     * start ranges that were provided in the constructor.
     *
     * @return                The SNG_REST_JsonResponse object. Note that the object is converted
     *                        to a JSON string representation of the object,
     *                        since the API is invoked using a RESTful API request.
     */
    public SNG_REST_JsonResponse get()
    {
        SNG_REST_JsonResponse response = null;
        
        try
        {
            response = process();
        }
        catch (Exception e)
        {
            // the only expected exception are improper formatting of data from Web Service
            SNG_REST_StatusDetail details = new SNG_REST_StatusDetail(SNGHttpUtilities.Status.SERVER_ERROR,
                                                                      SNG_REST_Error.SubCode.WEBSERVICE_GENERATED_ERROR,
                                                                      SNG_REST_Error.GENERIC_WEBSERVICE_ERROR); 
            response = new SNG_REST_JsonResponse(details, null);        
        }
        
        return response;
    }
    
    /**
     * This method is invoked to process the request.
     *
     * @return                The SNG_REST_JsonResponse object. Note that the object is converted
     *                        to a JSON string representation of the object,
     *                        since the API is invoked using a RESTful API request.
     */    
    private SNG_REST_JsonResponse process()
    {
        SNG_REST_StatusDetail detail = new SNG_REST_StatusDetail(SNGHttpUtilities.Status.OK, null);
        SNG_REST_IJsonResponseData data = null;
        
        if (validateInput(detail))
        {
            id = (null != idConverter) ? idConverter.convert(id) : id; //convert id only if idconverter exists. Otherwise, leave ID as is.
            data = processRequest(detail);
        }

        return new SNG_REST_JsonResponse(detail, data);
    }
    
    /**
     * Validates the data provided. The function is expected to modify the detail if there
     * are validation issues.
     *
     * @param      detail       The status detail to be modified.
     * @return                  True if validation passes; false otherwise.
     */
    @TestVisible
    private boolean validateInput(SNG_REST_StatusDetail detail)
    {
        return areDatesValid(detail, startDate, endDate) && isIdValid(detail, id);
    }
    
    /**
     * Validates if the dates are valid. The parameters are validated on the following criteria:
     * 1) Proper format: YYYY-MM-DD
     * 2) Start date is not in the future
     * 3) Start date is before the end date
     *
     * @param    detail            The detail object to modify if any error is encountered. This object
     *                             is used to fill in the JSON response to the client.
     * @param    startDate         The start date to validate.
     * @param    endDate           The end date to validate.
     * @return                     True if the dates provided are valid, false otherwise. The detail object is
     *                             modified based on the error encountered.
     */
    private boolean areDatesValid(SNG_REST_StatusDetail detail, final String startDate, final String endDate)
    {
        return new SNG_DateChecker().validate(detail, startDate, endDate);
    }
    
    /**
     * Checks if the ID name is of valid format
     * 
     * @param   detail             The detail object to modify if any error is encountered. This object
     *                             is used to fill in the JSON response to the client.
     * @param   ids                ID name of salesforce custom object to check
     * @return                     True if ID is valid; false otherwise
     */
    abstract boolean isIdValid(SNG_REST_StatusDetail detail, String id);
    
    /**
     * Process the request. This is overridden by classes inheriting to provide class
     * specific behavior in generating a response back to the click.
     *
     * @param   detail             The status detail, which is in the header of the JSON response.
     * @return                     The data portion of the JSON response.
     */
    abstract SNG_REST_IJsonResponseData processRequest(SNG_REST_StatusDetail detail);
    
    /**
     * Extracts a requested parameter from the RestRequest object.
     *
     * @param    restReq            The RESTful API request. Contains the URL of which API was invoked.
     * @param    key                The parameter to extract.
     * @return                      The value associated with the parameter, null otherwise.
     */
    private String extractFromParams(final RestRequest restReq, final String key)
    {
        return restReq.params.get(key);
    }
    
    /**
     * Extracts the ID from the RESTful API request.
     *
     * @param     restReq           The RESTful API request. Contains the URL of which API was invoked.
     * @return                      The singular ID found within the URL path.
     * @throws    SNG_Exception     If no IDs are found or if the URL does not contain the expected number of IDs.                  
     */
    private String extractFromUri(final RestRequest restReq)
    {
        String path = SNG_REST_Utilities.getWildcardPath(restReq);
        List<String> pathVariables = SNG_REST_Utilities.getPathVariablesFromUri(restReq);

        SNG_ExceptionUtil.assert(pathVariables.size() == NUM_EXPECTED_IDS,
                                 NUM_EXPECTED_IDs + ' path variable(s) expected for URI path ' + path + '. Found ' + pathVariables.size());

        return pathVariables[0];
    }
}