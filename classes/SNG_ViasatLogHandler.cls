public with sharing class SNG_ViasatLogHandler {

	@testVisible
	private static final String PROJECT_NAME = 'SNG';

	public static void Log(string logType, string message, string details, string stackTrace, string processId, string userId, string httpCode, string status) {
		if (System.isFuture()) {
			ViaSatLogHandler.Log(PROJECT_NAME, logType, message, details, stackTrace, processId, userId, httpCode, status);
		} else {
			ViaSatLogHandler.futureLog(PROJECT_NAME, logType, message, details, stackTrace, processId, userId, httpCode, status);
		}
	}

	public static void Log(string logType, string message, string details, string stackTrace, string processId, string userId, string httpCode){
		Log(logType, message, details, stackTrace, processId, userId, httpCode, null);
	}

	public static void Log(string logType, string message, string details, string stackTrace, string processId){
		Log(logType, message, details, stackTrace, processId, null, null, null);
	}

	public static void Log(string logType, string message, string details, string stackTrace){
		Log(logType, message, details, stackTrace, null, null, null, null);
	}
	
	public static void Log(string logType, string message, string details){
		Log(logType, message, details, null, null, null, null, null);
	}

}