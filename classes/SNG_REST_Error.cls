/**
 * This class is used to determine the subcodes that reside within the standard header of the RESTful
 * JSON response message when third-party API's perform a query.
 */
public with sharing class SNG_REST_Error 
{
	/**
	 * An error message to indicate that the ID(s) do not have corresponding objects, yet they are in the correct format. 
	 */ 
	public static final String IDS_INVALID = 'One or more of the specified ids do not correspond with any objects on your account.';	
	/**
	 * An error message to indicate the input in the URI is of an invalid format.
	 */
	public static final String INPUT_INVALID_FORMAT = 'One or more inputs is not in the valid format';
	
	/**
	 * An error message to indicate the Terminal does not have a modem associated with it.
	 */
	public static final String TERMINAL_NO_MODEM = 'One or more terminals do not have a modem associated.';
	
	/**
	 * An error message to indicate the Start/End date parameters are of an invalid format. 
	 */ 
	public static final String DATE_INVALID_FORMAT = 'Start and/or End date(s) not in the valid format YYYY-MM-DD';	
	
	/**
	 * An error message to indicate that no Start Date was entered as a parameter. 
	 */
	public static final String MISSING_START_DATE = 'Missing start date input';
		
	/**
	 * An error message to indicate that no End Date was entered as a parameter. 
	 */ 
	public static final String MISSING_END_DATE = 'Missing end date input';
	
	/**
	 * An error message to indicate the Start Date parameter is set to a future date. 
	 */ 
	public static final String START_DATE_IN_FUTURE = 'Start date cannot be a future date'; 

	/**
	 * An error message to indicate the End Date parameter is before the Start Date parameter. 
	 */ 
	public static final String END_DATE_BEFORE_START_DATE = 'End date cannot occur before start date'; 

	/**
	 * An error message to indicate the Date is not a reasonable date, yet still in correct format. 
	 */ 
	public static final String INVALID_DATE = 'Invalid Start and/or End dates';
	
	/**
	 * An error message to indicate there was an error retrieving data from a web service
	 */
	public static final String GENERIC_WEBSERVICE_ERROR = 'Error retrieving data from server';

    /**
     * An internal server error default message to use when returning a rest response to the client.
     */
    public static final String INTERNAL_SERVER_ERROR = 'Internal Server Error. Please see log for details';
		
	/**
	 * The enumeration of possible sub-codes. These are used in conjunction with the status to 
	 * generate an error code.
	 */
    public enum SubCode
    {
        SALESFORCE_GENERATED_ERROR,
        WEBSERVICE_GENERATED_ERROR
    }

    /**
     * Provides a tuple of data matching status, sub-code, and error together.
     */
    private class SubCodeMapping
    {
    	/**
    	 * The status of the request.
    	 */
    	public SNGHttpUtilities.Status status;
    	
    	/**
    	 * The sub-code corresponding to the status. The data is null if the status is OK.
    	 */
    	public SubCode subCode;
    	
    	/**
    	 * The appropriate error code for the status and sub-code pair.
    	 */
    	public integer errorCode;
    	
    	/**
    	 * Creates an instance of this object.
    	 *
    	 * @param    status          The status of the request.
    	 * @param    subcode         The subcode of the status providing more detail.
    	 * @param    errorCode       The error code corresponding to the status and sub-code.
    	 */
    	public SubCodeMapping(SNGHttpUtilities.Status status, SubCode subcode, integer errorCode)
    	{
    		this.status = status;
    		this.subCode = subCode;
    		this.errorCode = errorCode;
    	}
    }

    /**
     * Provides a pair between the status and sub-code. The status a more generic response,
     * while the sub-code provides more granularity on the error. The sub-code can provide which
     * component provided the fault (Salesforce or Web-service).
     */
    @TestVisible
    private class StatusAndSubCode
    {
    	/**
    	 * The status of the request.
    	 */
    	public SNGHttpUtilities.Status status;
    	
    	/**
    	 * The corresponding sub-code for the status.
    	 */
    	public SubCode subCode;
    	
    	/**
    	 * Creates an instance of the object.
    	 *
         * @param    status          The status of the request.
         * @param    subcode         The subcode of the status providing more detail.
    	 */
    	public StatusAndSubCode(SNGHttpUtilities.Status status, SubCode subCode)
    	{
    		this.status = status;
    		this.subCode = subCode;
    	}
    	
    	/**
    	 * Equality comparison used when the object is used as a key in a map.
    	 * Verifies the status and sub-code is equal.
    	 *
    	 * @param    obj             The object to compare for equality.
    	 * @return                   Whether or not the objects are considered equal.
    	 */
    	public Boolean equals(Object obj) 
    	{
            if (this === obj)
            {
                return true;
            }
            else if (obj == null || !(obj instanceof StatusAndSubCode))
            {
                return false;
            }
            else if (obj instanceof StatusAndSubCode) 
	        {
	            StatusAndSubCode sc = (StatusAndSubCode)obj;
	            return ((status == sc.status) && (subcode == sc.subcode));
	        }
            return false;
        }
        
        /**
         * The hashcode for this object.
         *
         * @return                   A singular hashcode representing this object.
         */
        public override Integer hashCode() 
        {
        	final integer primeNumber = 31;
        	integer result = primeNumber * ((null != status) ? status.hashCode() : 0); 
        	result ^= ((null != subCode) ? subCode.hashCode() : 0);
            return result;
        }
    }
    
    /**
     * A static map containing a mapping between status and sub-code to the error code.
     */
    private static Map<StatusAndSubCode, integer> errorCodeMap = new Map<StatusAndSubCode, integer>();
    
    
    /**
     * A static table provides the tuple for the status, sub-code, and error code.
     */
    public static final SubCodeMapping[] errorCodeTbl = new SubCodeMapping[]
    {
    	//------------------------------------------------------------------------------------------------------------------------------------------
    	//                      status                                                        subCode                                      errorCode
    	//------------------------------------------------------------------------------------------------------------------------------------------
            new SubCodeMapping( SNGHttpUtilities.Status.ZERO_RESULTS,                       SubCode.SALESFORCE_GENERATED_ERROR,          1001 ),
            new SubCodeMapping( SNGHttpUtilities.Status.ZERO_RESULTS,                       SubCode.WEBSERVICE_GENERATED_ERROR,          1002 ),
            
            new SubCodeMapping( SNGHttpUtilities.Status.ACCESS_DENIED,                      SubCode.SALESFORCE_GENERATED_ERROR,          2001 ),
            new SubCodeMapping( SNGHttpUtilities.Status.ACCESS_DENIED,                      SubCode.WEBSERVICE_GENERATED_ERROR,          2002 ),
            
            new SubCodeMapping( SNGHttpUtilities.Status.SERVER_ERROR,                       SubCode.SALESFORCE_GENERATED_ERROR,          3001 ),
            new SubCodeMapping( SNGHttpUtilities.Status.SERVER_ERROR,                       SubCode.WEBSERVICE_GENERATED_ERROR,          3002 ),
            
            new SubCodeMapping( SNGHttpUtilities.Status.INPUT_VALIDATION_ERROR,             SubCode.SALESFORCE_GENERATED_ERROR,          4001 ),
            new SubCodeMapping( SNGHttpUtilities.Status.INPUT_VALIDATION_ERROR,             SubCode.WEBSERVICE_GENERATED_ERROR,          4002 ),
            
            new SubCodeMapping( SNGHttpUtilities.Status.OK_WITH_ERRORS,                     SubCode.SALESFORCE_GENERATED_ERROR,          5001 ),
            new SubCodeMapping( SNGHttpUtilities.Status.OK_WITH_ERRORS,                     SubCode.WEBSERVICE_GENERATED_ERROR,          5002 ) 
    };
    
    /**
     * Static initialization for the error code map.
     */
    static
    {
        for (SubCodeMapping et : errorCodeTbl)
        {
        	errorCodeMap.put(new StatusAndSubCode(et.status, et.subCode), et.errorCode);
        }
    }
    
    /**
     * Retrieves the corresponding error code that maps the status and subcode provided.
     * 
     * @param     status              The status of the request.
     * @param     subCode             The code corresponding to the status providing better detail.
     *
     * @return                        Returns the appropriate error code. A zero is returned
     *                                if the status is OK.
     */
    public static integer getErrorCode(SNGHttpUtilities.Status status, SubCode subCode)
    {
    	return (SNGHttpUtilities.Status.OK != status) ? process(status, subCode) : 0;
    }
    
    /**
     * Processes the status and sub-code, returning the appropriate error. The function assumes
     * the status is not set to the OK. The method can throw an exception if either param is
     * not valid.
     *
     * @param     status               The status of the request. The value must not be set to OK.
     * @param     subCode              The code corresponding to the status providing better detail.
     *
     * @return                         Returns the appropriate error code. Otherwise returns 0.
     */
    private static integer process(SNGHttpUtilities.Status status, SubCode subCode)
    {
        StatusAndSubCode sc = new StatusAndSubCode(status, subcode);
        return (errorCodeMap.containsKey(sc)) ? errorCodeMap.get(sc) : 0;
    }
}