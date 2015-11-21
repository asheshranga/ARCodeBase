/**
 * Contains utility methods related to Exceptions for the SNG project
 */
public with sharing class SNG_ExceptionUtil {
	
	/**
	 * Default Exception type to be used
	 */
	private static final Type DEFAULT_EXCEPTION_TYPE = SNG_Exception.class;
	
	/**
     * Throws DEFAULT_EXCEPTION_TYPE if the object is null.
     *
     * @param   objToCheck               The object to check.
     * @param   errorMessage             The error message to use if the object is null.
     * @throws  DEFAULT_EXCEPTION_TYPE   If the provided object is null.
     */
    public static void throwIfNullObject(final object objToCheck, final String errorMessage) {
        throwIfNullObject(objToCheck, errorMessage, DEFAULT_EXCEPTION_TYPE);
    }
    
    public static void assert(final boolean assertionCheck, final String message)
    {
        assert(assertionCheck, new SNG_Exception(message));
    }

    public static void assert(final boolean assertionCheck, final Exception exceptionToThrow) {
        if (!assertionCheck) {
            throw exceptionToThrow;
        }
    }
	
	/**
     * Throws the provided Exception type if the object is null.
     *
     * @param   objToCheck                   The object to check.
     * @param   errorMessage                 The error message to use if the object is null.
     * @param   exceptionType                The Exception type to throw. If invalid Exception type, DEFAULT_EXCEPTION_TYPE is used.
     * @throws  DEFAULT_EXCEPTION_TYPE       If the provided object is null.
     */
	public static void throwIfNullObject(final object objToCheck, final String errorMessage, final Type exceptionType) {
    	if (null == objToCheck) {
    		String modifiedMessage = errorMessage;
    		Exception e = (Exception) DEFAULT_EXCEPTION_TYPE.newInstance();
    		
    		if (Exception.class != exceptionType) {
            	object o = exceptionType.newInstance();
	        	
	        	if (o instanceof Exception) {
                	e = (Exception) o;
	        	} else {
	        		modifiedMessage = 'Attempting to throw invalid Exception type: ' + exceptionType.getName() 
	        		                + '. Defaulting to ' + DEFAULT_EXCEPTION_TYPE.getName() + '. Message: ' + errorMessage;
	        	}
    		} else {
    			// Handling the scenario that Exception.class is passed in for the type. 
    			// This is because Exception.class.newInstance(); results in a System.UnexpectedException.
    			modifiedMessage = 'Attempting to throw System Exception type: ' + exceptionType.getName() 
	        		            + '. Defaulting to ' + DEFAULT_EXCEPTION_TYPE.getName() + '. Message: ' + errorMessage;
    		}
        	
        	e.setMessage(modifiedMessage);
        	throw e;
        }
    }
    
}