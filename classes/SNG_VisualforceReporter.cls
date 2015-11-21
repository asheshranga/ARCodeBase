public with sharing class SNG_VisualforceReporter {
		
	public static void report(ApexPages.Severity severity, String message)
	{
    	logExternalMessage(severity, message);
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
	private static void logExternalMessage(ApexPages.severity severity, String externalMessage)
	{
		if (invokedFromVfPage())
    	{
        	ApexPages.addMessage(new ApexPages.message(severity, externalMessage));
    	}
    	else
    	{
        	logInternalMessage('ReportError was invoked from a Non-Visualforce page. Message: ' + externalMessage);
    	}
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