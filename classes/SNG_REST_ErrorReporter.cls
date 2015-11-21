public with sharing class SNG_REST_ErrorReporter {
	
	public static void logError(final SNG_REST_Exception e) {
		SNG_ViasatLogHandler.Log(ViasatLogHandler.SeverityTypeEXCEPTION, e.statusDetail.message, e.getMessage(), e.innerStackTrace);
	}

	public static void logError(final SNG_REST_StatusDetail statusDetail, final Exception e) {
		logError(new SNG_REST_Exception(statusDetail, e));
	}

}