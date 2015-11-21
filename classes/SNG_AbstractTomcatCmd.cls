/**
 * This class defines common constants used in HttpCallout commands to the SNG Tomcat Server.
 * It is the parent class of classes containing those commands.
 */
public with sharing abstract class SNG_AbstractTomcatCmd /*implements SNG_ResAsyncCmdInterface*/ {
    /**
     * This inner-class contains names of common fields used in SNG_AbstractTomcatCmds
     */
    public class Field {
        public final transient String ERROR_CODE          = 'errorCode';
        public final transient String ERROR_MESSAGE       = 'errorMessage';
    }
    
    /**
     * Public accessor for the fields inside the inner Field class
     */
    public static final transient Field FIELD = new Field();
    
    /**
     * This inner-class contains possible error code values that can be retrieved from the SNG Tomcat Server.
     */
    public class ErrorCode {
        public final transient Integer NO_ERROR           = 0;
    }
    
    /**
     * Public accessor for the fields inside the inner ErrorCode class
     */
    public static final transient ErrorCode ERROR_CODE = new ErrorCode();
}