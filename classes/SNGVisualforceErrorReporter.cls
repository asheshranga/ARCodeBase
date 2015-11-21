global with sharing class SNGVisualforceErrorReporter
{
	/**
     * Reports an error to both the customer and the developer. The customer receives a simplified error
     * message, removing specific details. The developer message is more detailed, providing an additional
     * stack trace if the error is on the server.
     *
     * @param   errorMessage    The error message to be viewed by a customer.
     * @param   internalMessage The error message to be viewed by a developer.
     */
    @RemoteAction
    public static void reportError(String externalMessage, String internalMessage)
    {
    	logInternalMessage(internalMessage);
    	logExternalMessage(externalMessage);
    }

    /**
     * Reports an error to both the customer and the developer. The customer receives a simplified error
     * message, removing specific details. The developer message is more detailed, providing an additional
     * stack trace if the error is on the server. This method is used only in exception
     * cases where the exception is unknown.
     *
     * @param   e               The exception details.
     */
    // Note: This method is used for unknown exceptions. All other exceptions should be caught at a lower level.
    public static void reportError(Exception e)
    {
        logInternalMessage(e);
        logExternalMessage('Unexpected error');
    }

    /**
     * Reports an error to both the customer and the developer. The customer receives a simplified error
     * message, removing specific details. The developer message is more detailed, providing an additional
     * stack trace if the error is on the server. This method is used only in exception
     * cases where the exception is unknown.
     *
     * @param   e               The exception details.
     */
    // Note: This method is used for unknown exceptions. All other exceptions should be caught at a lower level.
    public static void reportError(Exception e, String simpleMessage)
    {
        logInternalMessage(e);
        logExternalMessage(simpleMessage);
    }

    /**
     * Reports an error to both the customer and the developer. The customer receives a simplified error
     * message, removing specific details. The developer message is more detailed, providing an additional
     * stack trace if the error is on the server.
     *
     * @param   errorMessage    The error message to be viewed by a customer.
     * @param   internalMessage The error message to be viewed by a developer.
     * @param   stackTrace      The stack trace of where the error occurred to be viewed by a developer.
     */
    @RemoteAction
    public static void reportError(String errorMessage, String internalMessage, String stackTrace)
    {
        logExternalMessage(errorMessage);
        logInternalMessage(internalMessage, stackTrace);
    }

    /**
     * Verifies if the error message was generated from a Visualforce page.
     *
     * @return                  Whether or not the method was invoked from a Visualforce page.
     */
    private static boolean invokedFromVfPage()
    {
    	// ApexPages.currentPage() returns System.PageReference[null], does not return null, if no page
    	// need to compare url, otherwise will always be true.

    	return (null != ApexPages.currentPage().getUrl());
	    	//return (null != ApexPages.currentPage());
    }

    /**
     * Logs an external message to the user. THe external message is display on any Visualforce
     * page supporting pagemessage tags.
     */
    private static void logExternalMessage(String externalMessage)
    {
    	if (invokedFromVfPage())
        {
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, externalMessage));
        }
        else
        {
            logInternalMessage('ReportError was invoked from a Non-Visualforce page. Message: ' + externalMessage);
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
     * Logs an internal message for a developers from the exception thrown.
     *
     * @param   internalMessage    The error message.
     */
    private static void logInternalMessage(String internalMessage)
    {
        logInternalMessage(internalMessage, null);
    }

    /**
     * Logs an internal message for a developers with an error message and corresponding
     * stack trace into a ViasatLog SObject. 
     *
     * @param   internalMessage    The error message.
     * @param   stackTrace         The stack trace of where the error took place.
     */
    private static void logInternalMessage(String internalMessage, String stackTrace)
    {
        System.debug(LoggingLevel.ERROR, 'Error Message: ' + internalMessage);
        
        // If there is a stackTrace, logging an exception 
        if (null != stackTrace)
        {
            System.debug(LoggingLevel.ERROR, 'Stack Trace: ' + stackTrace);
        }
        
        // Log the error asynchronously in a ViasatLog SObject. SNGVisualforceErrorReporter is only called from Exceptions, log type = Exception
        SNG_ViasatLogHandler.Log(ViasatLogHandler.SeverityTypeEXCEPTION, internalMessage, null, stackTrace);
    }
    
}