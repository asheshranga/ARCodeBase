/**
 * This class is used to perform the HTTP callout to the PMDR service to retrieve the user terminal
 * physical (PHY) history for a specified user terminal MAC address. The response from PMDR will be 
 * passed back to a higher level class. 
 */ 
public with sharing class SNG_PerformanceHistoryRetrieval {
	
	/** 
	 * The HTTP path used to communicate with the PDMR Web service.
	 */
	private static final String DB_PERF_HTTP_PATH = SNGHttpUtilities.TOMCAT_SERVER.Url__c + '/PmdrService/query/perf/phy/history/';
	
	/**
	 * The timeout used for the HTTP requests
	 */
	private static final integer PERF_HISTORY_TIMEOUT_IN_MSEC = 30000; 
	
	/** 
	 * Perform HTTP callout to PMDR service for performance history
	 * 
	 * @param		macAddress		MAC address of the modem
	 * @param		startDate		start date of the period to get performance history 
	 * @param		endDate			end date of the period to get performance history
	 * @return						The HTTP response from the PMDR service 
	 */ 
	public static HttpResponse getPerformanceHistory(String macAddress, Date startDate, Date endDate) { 
		
		String url = DB_PERF_HTTP_PATH + macAddress + '/' + SNGHttpUtilities.formatDate(startDate) + '/' + SNGHttpUtilities.formatDate(endDate); 
	
		HttpResponse res = SNG_HttpCallout.sendHttpGetRequest(url, PERF_HISTORY_TIMEOUT_IN_MSEC, true);
		
		return res;  
	}
}