/**
 * This exception class is used to capture exceptions based on a terminal.
 */
public virtual with sharing class SNGTerminalException extends SNGSObjectException {

    /**
     * The constructor used to create an instance of the object. This constructor assumes
     * the terminal status is updated to an error state.
     *
     * @param   detailedMessage    The detailed message to be logged for developers to
     *                             track the error.
     * @param   simpleMessage      The simplified message to be displayed to the customer
     *                             without exposing the inner workings of the error.
     */
    public SNGTerminalException(String detailedMessage, String simpleMessage)
    {
    	super(detailedMessage, simpleMessage);
    }

}