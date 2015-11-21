/**
 * This utility class is used to support the RESTful interface APIs used by
 * third-party developers to retrieve information for their user terminals.
 */
public with sharing class SNG_REST_Utilities {

	public static final string URI_DELIM = '/';
	public static final string URI_WILDCARD = '*';
	public static final String BASE_URI_EXTENSION = '/services/apexrest';

	private static final Map<String, SNGHttpUtilities.Status> STRING_TO_STATUS = new Map<String, SNGHttpUtilities.Status>();
	static {
		for (SNGHttpUtilities.Status s : SNGHttpUtilities.Status.values()) {
			STRING_TO_STATUS.put(s.name(), s);
		}
	}

    public static String formatMacAddress(String macAddress)
    {
    	Pattern p = Pattern.compile('^[0-9a-fA-F]{12}$');
        Matcher pm = p.matcher(macAddress);
        final SNG_REST_Exception invalidFormatException = new SNG_REST_Exception(
            new SNG_REST_StatusDetail(SNGHttpUtilities.Status.SERVER_ERROR, SNG_REST_Error.SubCode.SALESFORCE_GENERATED_ERROR, SNG_REST_Error.INTERNAL_SERVER_ERROR), 
            'MAC address must be of format: XXXXXXXXXXXX');
    	SNG_ExceptionUtil.assert(pm.matches(), invalidFormatException);
        return macAddress.replaceAll('..(?!$)', '$0:').toLowerCase();
    }

    public static boolean isStatusOK(SNGHttpUtilities.Status status)
    {
    	return (SNGHttpUtilities.Status.OK == status || SNGHttpUtilities.Status.OK_WITH_ERRORS == status);
    }


    public static SNGHttpUtilities.Status getStatusFromString(String statusString) {
    	return STRING_TO_STATUS.get(statusString);
    }

    public static SNGHttpUtilities.Status getCombinedStatus(SNGHttpUtilities.Status a, SNGHttpUtilities.Status b)
    {
        SNGHttpUtilities.Status retStatus;

        if (SNGHttpUtilities.Status.ACCESS_DENIED == a || SNGHttpUtilities.Status.ACCESS_DENIED == b)
            retStatus = SNGHttpUtilities.Status.ACCESS_DENIED;
        else if (SNGHttpUtilities.Status.INPUT_VALIDATION_ERROR == a || SNGHttpUtilities.Status.INPUT_VALIDATION_ERROR == b)
        {
            retStatus = SNGHttpUtilities.Status.INPUT_VALIDATION_ERROR;
        }
        else if (SNGHttpUtilities.Status.SERVER_ERROR == a || SNGHttpUtilities.Status.SERVER_ERROR == b)
        {
            retStatus = SNGHttpUtilities.Status.SERVER_ERROR;
        }
        else if (SNGHttpUtilities.Status.ZERO_RESULTS == a || SNGHttpUtilities.Status.ZERO_RESULTS == b)
        {
            retStatus = SNGHttpUtilities.Status.ZERO_RESULTS;
        }
        else if (SNGHttpUtilities.Status.OK_WITH_ERRORS == a || SNGHttpUtilities.Status.OK_WITH_ERRORS == b)
        {
            retStatus = SNGHttpUtilities.Status.OK_WITH_ERRORS;
        }
        else
        {
            retStatus = SNGHttpUtilities.Status.OK;
        }

        return retStatus;
    }


    /**
     * Determines whether the user is authorized to perform the RESTful API
     * call. The user is considered authorized if the user is a Salesforce User
     * or if the user owns the specific MAC address.
     *
     * @param  macAddress    The MAC address of the user terminal the user is
     *                       querying for.
     *
     * @return               Whether the user is authorized or not.
     */
    public static boolean isUserAuthorized(String macAddress)
    {
        // user must be admin or own the modem.
        return (isSalesforceUser() || doesUserOwnMacAddress(macAddress));
    }

    /**
     * Determines if the user is a Salesforce User.
     *
     * @return               Whether the user is a Salesforce user or not.
     */
    public static boolean isSalesforceUser()
    {
        final String profileId = UserInfo.getProfileId();
        Profile p = [SELECT UserLicenseId FROM Profile WHERE Id = :profileId];
        return (System.Label.SNG_SalesforceUserLicenseId == p.UserLicenseId);
    }

    /**
	 * Retrieve the path variable from the request URI
	 *
	 * @param	reqUri       	The REST Request URI
	 * @param 	pathVarStart 	The String to look for before the path variable starts
	 * @param 	pathVarEnd   	The String to look for after the path variable ends
	 * @return	             	The path variable. Returns null if either pathVarStart or pathVarEnd cannot be found in reqUri.
	 * @throws	SNG_Exception	If any of the arguments are null
	 */
	public static String getPathVariableFromUri(final String reqUri, final String pathVarStart, final String pathVarEnd) {
		SNG_ExceptionUtil.throwIfNullObject(reqUri, 'SNG_REST_Utilities.getPathVariableFromUri called with null reqUri');
		SNG_ExceptionUtil.throwIfNullObject(pathVarStart, 'SNG_REST_Utilities.getPathVariableFromUri called with null pathVarStart');
		SNG_ExceptionUtil.throwIfNullObject(pathVarEnd, 'SNG_REST_Utilities.getPathVariableFromUri called with null pathVarEnd');
		return reqUri.substring(reqUri.lastIndexOf(pathVarStart) + pathVarStart.length(), reqUri.lastIndexOf(pathVarEnd));
	}
	
	public static String getPathVariableFromUri(final RestRequest restReq)
    {
    	List<String> pathVariables = getPathVariablesFromUri(restReq);
    	return (0 < pathVariables.size()) ? pathVariables[0] : null;
    }
	

    /**
	 * Retrieve the path variables in the URI of the given REST request
	 *
	 * @param	restReq			REST request with non-null requestURI and resourcePath members
	 *
	 * @return	             	The path variables in a list in order as they appear in the URI
	 * @throws	SNG_Exception	If the REST request is null, or either of its requestURI and
	 * 								resourcePath members
	 */
	public static List<String> getPathVariablesFromUri(final RestRequest restReq) {
		
		SNG_ExceptionUtil.throwIfNullObject(restReq, 'Null REST request');
		SNG_ExceptionUtil.throwIfNullObject(restReq.requestUri, 'Null requestURI in REST request');
		
		String uri = restReq.requestUri; //Stop doing the Uri.getPath()! It is not correct!!!!
		String wildcardUri = getWildcardPath(restReq);

		String[] uriPaths = uri.split(URI_DELIM);
		String[] wildcardUriPaths = wildcardUri.split(URI_DELIM);
		List<String> result = new List<String>();

        integer minPathSize = Math.min(uriPaths.size(), wildcardUriPaths.size());
		for (integer i = 0; i < minPathSize; i++)
		{
			if (wildcardUriPaths[i].equals(URI_WILDCARD))
			{
				result.add(uriPaths[i]);
			}
		}

		return result;
	}


	/**
	 * Returns the resource path corresponding to the given REST request
	 * not including the /apexrest/services/ prefix
	 *
	 * @param restReq			the REST request
	 *
	 * @return 					the resource path corresponding to the given REST request
	 * @throws	SNG_Exception	If the REST request or its requestURI member is null
	 */
	public static String getPath(final RestRequest restReq)
	{
		SNG_ExceptionUtil.throwIfNullObject(restReq, 'Null REST request');
		SNG_ExceptionUtil.throwIfNullObject(restReq.requestUri, 'Null requestURI in REST request');
		URL uri = new URL(restReq.requestUri);
		String path = uri.getPath();
		path = path.replaceFirst(URL.getSalesforceBaseUrl().toExternalForm(), '');
		path = path.replaceFirst(BASE_URI_EXTENSION, '');
		return path;
	}

    /**
	 * Retrieve the resource path in the REST request including the wildcard parameters
	 * but not including the /apexrest/services/ prefix
	 *
	 * @param	restReq     	REST request
	 *
	 * @return	             	the resource path in the REST request including the wildcard parameters
	 * @throws	SNG_Exception	If the REST request or its resourcePath member is null
	 */
	public static String getWildcardPath(RestRequest restReq)
	{
		SNG_ExceptionUtil.throwIfNullObject(restReq, 'Null REST request');
		SNG_ExceptionUtil.throwIfNullObject(restReq.resourcePath, 'Null resource path in REST request');
		String resourcePath = restReq.resourcePath;
		resourcePath = resourcePath.replaceFirst(URL.getSalesforceBaseUrl().toExternalForm(), '');
		resourcePath = resourcePath.replaceFirst(BASE_URI_EXTENSION, '');
		return resourcePath;
	}

    /**
     * Determines if the user owns the specified MAC address or not.
     *
     * @param  macAddress    The MAC address to check the ownership of.
     * @return               Whether or not the user owns the specified MAC address.
     */
    private static boolean doesUserOwnMacAddress(String macAddress)
    {
       Id accountId = getAccountId(UserInfo.getUserId());
       return doesAccountOwnMacAddress(accountId, macAddress);
    }

    /**
     * Determines if the MAC address is under the user's account.
     *
     * @param  macAddress    The MAC address to check the ownership of.
     * @param  accoundId     The ID of the account to check if macAddress is owned
     *                       by the account.
     * @return               Whether or not the account owns the MAC address.
     */
    private static boolean doesAccountOwnMacAddress(Id accountId, String macAddress)
    {
       integer sqlCount = null;

       sqlCount = [SELECT COUNT() FROM Modem__c WHERE Account__r.Id = :accountId AND
                   MacAddress__c = :macAddress];

       return (0 < sqlCount);
    }

    /**
     * Retrieves the account ID based on the user ID of the client.
     *
     * @param 	userId       	The ID of the user.
     * @return	Id           	The ID of the account the user is associated with.
     * @throws	SNG_Exception	If an error occurred in getting the account ID for a user
     *        	             	with the specified user ID.
     */
    private static Id getAccountId(Id userId)
    {
        Id accountId = null;

        try
        {
            User user = [SELECT ContactId FROM User WHERE Id = :userId];
            Contact contact = [SELECT AccountId FROM Contact WHERE Id = :user.ContactId];
            accountId = contact.AccountId;
        }
        catch (QueryException qe)
        {
            final SNG_REST_StatusDetail statusDetail = new SNG_REST_StatusDetail(
                SNGHttpUtilities.Status.SERVER_ERROR, SNG_REST_Error.SubCode.SALESFORCE_GENERATED_ERROR, 'Query is empty: ' + userId);
        	throw new SNG_REST_Exception(statusDetail, qe);
        }

        return accountId;
    }
    
    /**
     * Assertion check function, which will throw a SNG_REST_Exception on error.
     *
     * @param   expression            The expression to validate
     * @param   message               The message to add to the exception.
     * @throws  SNG_REST_Exception    Thrown if the expression is false; returns otherwise.
     */
    public static void assertTrue(boolean expression, String message)
    {
        if (!expression) {
            final SNG_REST_StatusDetail statusDetail = new SNG_REST_StatusDetail(
                SNGHttpUtilities.Status.SERVER_ERROR, SNG_REST_Error.SubCode.SALESFORCE_GENERATED_ERROR);
            throw new SNG_REST_Exception(statusDetail, message);
        }
    }
}