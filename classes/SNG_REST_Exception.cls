public class SNG_REST_Exception extends SNG_Exception {

	public SNG_REST_StatusDetail statusDetail { private set; public get; }
	public String innerStackTrace { private set; public get; }

	public SNG_REST_Exception(final SNG_REST_StatusDetail statusDetail, final String exceptionMsg, final String innerStackTrace) {
		super(exceptionMsg);
		this.statusDetail = statusDetail;
		this.innerStackTrace = innerStackTrace;
	}

	public SNG_REST_Exception(final SNG_REST_StatusDetail statusDetail, final String exceptionMsg) {
		this(statusDetail, exceptionMsg, null);
	}

	public SNG_REST_Exception(final SNG_REST_StatusDetail statusDetail, final Exception innerException) {
		this(statusDetail, innerException.getMessage(), innerException.getStackTraceString());
	}

}