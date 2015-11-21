/**
 * This class is used to support a RESTful response to the client when interfacing through the RESTful interface
 * provided through Salesforce.
 * an entry point into the Apex code.
 */
global with sharing virtual class SNG_REST_JsonResponse
{
	/**
	 * The status of the request made by the client.
	 */
    public String status;

    /**
     * The code describing the type of error that occurred.
     */
    public integer errorCode;

    /**
     * Descriptive message detailing the error.
     */
    public String errorMessage;

    /**
     * The results corresponding to the given request
     */
    public SNG_REST_IJsonResponseData data;

    /**
     * Creates an instance of this object, initializing the various parameters.
     *
     * @param    status        		The status of the request.
     * @param    errorSubCode      	The error subcode describing the source of the error.
     * @param    errorMessage       The detailed message of the error.
     * @param    data               The resulting data relevant to the API call
     */
    public SNG_REST_JsonResponse(SNGHttpUtilities.Status status, SNG_REST_Error.SubCode errorSubCode, String errorMessage,
    		SNG_REST_IJsonResponseData data)
    {
    	this.status = status.name();
    	this.errorCode = SNG_REST_Error.getErrorCode(status, errorSubCode);
    	this.errorMessage = errorMessage;
    	this.data = data;
    }
    
    public SNG_REST_JsonResponse(SNG_REST_StatusDetail detail, SNG_REST_IJsonResponseData data)
    {
    	this(detail.status, detail.code, detail.message, data);
    }
	
	public SNG_REST_JsonResponse(SNG_REST_Response response) {
		this(response.detail, (SNG_REST_Utilities.isStatusOK(response.detail.status)) ? response.data : null);
	}
	
	/**
	 *TESTING PURPOSES
	 */
	@TestVisible
	private SNG_REST_JsonResponse() { 
		
	}
	
    /**
     * The hashcode for this object.
     *
     * @return                   A singular hashcode representing this object.
     */
	public virtual integer hashCode() {
		final integer prime = 31;
		integer result = 1;
		result = prime * result + ((errorCode == null) ? 0 : errorCode);
		result = prime * result
				+ ((errorMessage == null) ? 0 : errorMessage.hashCode());
		result = prime * result + ((status == null) ? 0 : status.hashCode());
		result = prime * result + ((data == null) ? 0 : data.hashCode());
		return result;
	}

	/**
	 * Equality comparison used when the object is used as a key in a map.
	 * Verifies the status and sub-code is equal.
	 *
	 * @param    obj             The object to compare for equality.
	 * @return                   Whether or not the objects are considered equal.
	 */
	public virtual boolean equals(Object obj) {
		// Compare references
		if (this === obj) {
			return true;
		}

		if (obj == null || !(obj instanceof SNG_REST_JsonResponse)) {
			return false;
		}

		SNG_REST_JsonResponse other = (SNG_REST_JsonResponse) obj;
		return (StringUtils.equals(status, other.status) && errorCode == other.errorCode &&
				StringUtils.equals(errorMessage, other.errorMessage) &&
			    equalsData(other.data));
	}

	private boolean equalsData(SNG_REST_IJsonResponseData other)
	{
		return data == null ? other == null : data.equals(other);
	}
}