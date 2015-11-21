/**
 * This exception class is used to capture exceptions based on a SObject.
 */
public virtual with sharing class SNGSObjectException extends SNG_Exception {

    /**
     * A simplified message to be displayed to the customer if an exception occurs.
     */
    public String SimpleMessage { get; private set; }

    /**
     * The constructor used to create an instance of the object.
     *
     * @param   detailedMessage    The detailed message to be logged for developers to
     *                             track the error.
     * @param   simpleMessage      The simplified message to be displayed to the customer
     *                             without exposing the inner workings of the error.
     */
    public SNGSObjectException(String detailedMessage, String simple_Message)
    {
    	super(detailedMessage);
    	SimpleMessage = simple_Message;
    }
}