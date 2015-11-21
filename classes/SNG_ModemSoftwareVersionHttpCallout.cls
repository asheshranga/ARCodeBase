public with sharing class SNG_ModemSoftwareVersionHttpCallout 
{

    /**
     * The HTTP path used to communicate with the PMDR Web service.
     */
    private static final transient String DB_PERF_HTTP_PATH =  SNGHttpUtilities.TOMCAT_SERVER.Url__c  + '/PmdrService/query/perf/phy/version/list/';
    
    /**
     * Indicates the version is unknown if status is not OK.
     */
    public static final transient String UNKNOWN_VERSION = 'Unknown Version';

    /**
     * The timeout used for the HTTP request.
     */
    private static final transient integer PERF_VERSION_TIMEOUT_IN_MSEC = 5000;
    
   /**
     * Performs a HTTP callout to retrieve the version information for the given MAC address from the PmdrService.
     *
     * @param   macAddress     The list MAC addresses to lookup the version information for
     * @return                 The version information for the given MAC addresses.
     */    
    public static HTTPResponse get(List<String> macAddresses)
    {
        SNG_ExceptionUtil.throwIfNullObject(macAddresses, 'MAC addresses to get usage history is NULL.');
        String url = DB_PERF_HTTP_PATH + StringUtils.joinStrings(macAddresses, ',');	
        return SNG_HttpCallout.sendHttpGetRequest(url, PERF_VERSION_TIMEOUT_IN_MSEC, true);   
    }

}