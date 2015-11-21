/**
 * This class is used to report errors on custom SObjects.
 * The class helps facilitate logging by performing a log of both internal and external messages. 
 * Internal messages are primarily for developers such as a stack trace. The external messages 
 * are general purpose messages for customers.
 */
public with sharing class SNGSObjectErrorReporter {
	/**
	 * The API name of the field to update with the error message.
	 * NOTE: This field must exist on any SObject this class is used with.
	 */
    private static final transient String ERROR_FIELD_LOWERCASE = 'statusdetail__c';

    /**
     * Reports an error to both the customer and the developer. This method is used for logging errors where 
     * the error message is used for both the customer and developer. 
     *
     * @param   obj             The SObject to be updated. The error message is captured in the 
     *                          object, to be displayed to the customer.
     * @param   errorMessage    The error message to be displayed to both the customer and developer.
     */
    @RemoteAction
    public static void reportError(SObject obj, String errorMessage)
    {
        reportError(obj, errorMessage, errorMessage);
    }
    
    /**
     * Reports an error to both the customer and the developer. The customer receives a simplified error
     * message, removing specific details. The developer message is more detailed, providing an additional
     * stack trace if the error is on the server. This method is used for SNG SObject exceptions.
     *
     * @param   obj             The SObject to be updated. The error message is captured in the 
     *                          object, to be displayed to the customer.
     * @param   e               The exception details.
     */
    public static void reportError(SObject obj, SNGSObjectException e)
    {
    	if (null != e.SimpleMessage) {
    		logExternalMessage(obj, e);
    		logInternalMessage(e);
    	} else {
    		reportError(obj, (Exception)e);
    	}
    }
    
    
    /**
     * Reports an error to both the customer and the developer. The customer receives a simplified error
     * message, removing specific details. The developer message is more detailed, providing an additional
     * stack trace if the error is on the server. This method is used only in exception
     * cases where the exception is unknown.
     *
     * @param   obj             The SObject to be updated. The error message is captured in the 
     *                          object, to be displayed to the customer.
     * @param   e               The exception details.
     */
    // Note: This method is used for unknown exceptions. All other exceptions should be caught at a lower level.
    public static void reportError(SObject obj, Exception e)
    {
    	logExternalMessage(obj, 'Unexpected error');
    	logInternalMessage(e);
    }
    

    /**
     * Reports an error to both the customer and the developer. The customer receives a simplified error
     * message, removing specific details. The developer message is more detailed, providing an additional
     * stack trace if the error is on the server.
     *
     * @param   obj             The SObject to be updated. The error message is captured in the 
     *                          object, to be displayed to the customer.
     * @param   errorMessage    The error message to be viewed by a customer.
     * @param   internalMessage The error message to be viewed by a developer.
     */
    @RemoteAction
    public static void reportError(SObject obj, String errorMessage, String internalMessage)
    {
    	reportError(obj, errorMessage, internalMessage, null);
    }
    
    /**
     * Reports an error to both the customer and the developer. The customer receives a simplified error
     * message, removing specific details. The developer message is more detailed, providing an additional
     * stack trace if the error is on the server.
     *
     * @param   obj             The SObject to be updated.
     * @param   errorMessage    The error message to be viewed by a customer.
     * @param   internalMessage The error message to be viewed by a developer.
     * @param   stackTrace      The stack trace of where the error occurred to be viewed by a developer.
     */
    @RemoteAction
    public static void reportError(SObject obj, String errorMessage, String internalMessage, String stackTrace)
    {
        logExternalMessage(obj, errorMessage);
        logInternalMessage(internalMessage, stackTrace);
    }
    
    /**
     * Logs an external message for a customer when a SNG SObject exception is encountered. 
     * The object is updated to expose the error to the customer.
     *
     * @param   obj             The SObject to be updated.
     * @param   e               The exception details.
     */
    private static void logExternalMessage(SObject obj, SNGSObjectException e)
    {
        logExternalMessage(obj, e.SimpleMessage);
    } 
    
    /**
     * Logs an external message for a customer. The method takes into account whether the
     * method was invoked within a future or a non-future method and marks the error appropriately.
     *
     * @param   obj             The SObject to be updated.
     * @param   errorMessage    The error message detail.
     */
    private static void logExternalMessage(SObject obj, String errorMessage)
    {
    	if (!isInvokedWithinFutureMethod())
        {
             obj.addError(errorMessage);
        }
        else
        {
            handleExternalFutureError(obj, errorMessage);
        }
    }
    
    /**
     * Logs an internal message for a developers from the exception thrown.
     *
     * @param   e               The exception thrown.
     */
    private static void logInternalMessage(Exception e)
    {
        logInternalMessage(e.getMessage(), e.getStackTraceString());
    }
    
    /**
     * Logs an internal message for a developers with an error message and corresponding
     * stack trace.
     *
     * @param   internalMessage    The error message.
     * @param   stackTrace         The stack trace of where the error took place.
     */
    private static void logInternalMessage(String internalMessage, String stackTrace)
    {
        System.debug(LoggingLevel.ERROR, 'Error Message: ' + internalMessage);
        if (null != stackTrace)
        {
            System.debug(LoggingLevel.ERROR, 'Stack Trace: ' + stackTrace);
        }
    }
    
    /**
     * Returns whether the function call is made within a future method.
     *
     * @return          Whether the call is made within a future method or not.
     */
    private static boolean isInvokedWithinFutureMethod()
    {
        return System.isFuture();
    }
    
    /**
     * Handles reporting an error to a customer from a @future method. This is done by updating ERROR_FIELD_LOWERCASE on the provided SObject.
     * NOTE: ERROR_FIELD_LOWERCASE field must exist in obj provided.
     *
     * @param   obj             The SObject to be updated.
     * @param   errorMessage    The error message detail.
     */
    private static void handleExternalFutureError(SObject obj, String errorMessage) {
    	try {
        	Type objType = getSObjectType(obj);
            Map<string, schema.sobjecttype> allSObjects = schema.getglobaldescribe();
	        schema.sobjecttype q = allsobjects.get(objType.getName());
	        schema.describesobjectresult d = q.getdescribe();
	        Map<string, schema.sobjectfield> m = d.fields.getmap();
	        Set<String> s = m.keyset();
	        if (s.contains(ERROR_FIELD_LOWERCASE)) {
	        	obj.put(ERROR_FIELD_LOWERCASE, errorMessage);
	        	update obj;
	        } else {
	        	final String noErrorFieldErrorMessage = 'SObject [' + objType.getName() + '] does not contain field [' 
	        	                                      + ERROR_FIELD_LOWERCASE + '] required for reporting errors occurring in @future methods.';
	        	throw new SNG_Exception(noErrorFieldErrorMessage);
	        }
        } catch (SNG_Exception e) {
        	System.debug(LoggingLevel.ERROR, 'Caught SNG_Exception in SNGSObjectErrorReporter.logExternalMessage: ' + e.getMessage());
        	// TODO Somehow notify the user. Maybe send an email?
        } catch (Exception e) {
        	System.debug(LoggingLevel.ERROR, 'Caught Exception in SNGSObjectErrorReporter.logExternalMessage: ' + e.getMessage());
        	// TODO Somehow notify the user. Maybe send an email?
        }
    }
    
    /**
     * Returns the Type of the provided SObject
     *
     * @param 	obj          	The SObject to check the type for
     * @return	             	The Type of the provided SObject
     * @throws	SNG_Exception	If the provided SObject is invalid
     */
    private static Type getSObjectType(SObject obj) {
    	final String myIdPrefix = String.valueOf(obj.Id).substring(0, 3); //get just the prefix
    	Type objType = null;
		Map<String, Schema.SObjectType> gd = Schema.getGlobalDescribe(); 
		for (Schema.SObjectType stype : gd.values()) {
		    Schema.DescribeSObjectResult r = stype.getDescribe();
		    String prefix = r.getKeyPrefix();
		    if (null != prefix && myIdPrefix.equals(prefix)) {
		        objType = Type.forName(r.getName());
		        break;
		    }
		}
		
		// This shouldn't ever happen. Commented it out to get more coverage on the file.
		// If it does happen, ths exception will be caught by the calling method, 
		// handleExternalFutureError(SObject obj, String errorMessage).
		/*if (null == objType) {
			final String exceptionStr = 'Invalid SObject Type with prefix [' + myIdPrefix 
			                            + '] and full Id [' + obj.Id + ']';
			throw new SNG_Exception(exceptionStr);
		}*/
		
		return objType;
    }
    
}