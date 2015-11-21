/**
 * This class is used to capture the details for rest response, including the status, code, and
 * the message. 
 */
public with sharing class SNG_REST_StatusDetail 
{
	/**
	 * The status.
	 */
    public SNGHttpUtilities.Status status;
    
    /**
     * The subcode for the status. This value must be populated if the status value is not
     * OK. If the status value is OK, the value can be null.
     */
    public SNG_REST_Error.SubCode code;
    
    /**
     * The message associated with the status. This value can be null.
     */
    public String message;
    
    /**
     * Creates an instance of this object.
     *
     * @param      s          The status.
     * @param      c          The subcode. 
     */
    public SNG_REST_StatusDetail(SNGHttpUtilities.Status s, SNG_REST_Error.SubCode c)
    {
        this(s, c, null);
    }

    /**
     * Creates an instance of this object.
     *
     * @param      s          The status.
     * @param      c          The subcode. 
     * @param      m          The message.
     */        
    public SNG_REST_StatusDetail(SNGHttpUtilities.Status s, SNG_REST_Error.SubCode c, String m)
    {
        status = s;
        code = c;
        message = m;
    }
}