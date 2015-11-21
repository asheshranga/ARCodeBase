public with sharing class SNG_ModemUsageDataHttpCallout 
{
   /**
     * The HTTP path used to communicate with the Usage service.
     * An optional granularity filter can be passed in if desired. If the filter is not specified, 
     * a day granularity will be used by UsageService. 
     */
    public static final transient String UDM_HTTP_PATH =  SNGHttpUtilities.TOMCAT_SERVER.Url__c  + '/UsageService/v1/modems/usage/base-station/historical?';
    
    /**
     * The timeout used for the HTTP request.
     */
    private static final transient integer UDM_VERSION_TIMEOUT_IN_MSEC = 30000;
    
    /**
     * The enumeration of possible grain values that can be specified for the request.
     */
    public enum Grain
    {
    	DAY,
    	MONTH,
    	CUSTOM
    }
    
    /**
     * Performs a HTTP callout to retrieve the usage data information based on the 
     * modem and date range provided.
     *
     * @param   modemUsageDate  The list MAC addresses and date ranges to obtain usage data for.
     * @param  grain             The requested grain: DAY, MONTH, CUSTOM
     * @param  granularity       The requested granularity. If this value is null, the default value UsageService uses is 0.
     * @param  aggregate         Whether to aggregate values across intervals or not. If null, UsageService uses false
     * @return                  The usage data for the modem MAC address within the date range.
     */    
    public static HTTPResponse post(SNG_ModemUsageDate modemUsageDate, Grain grain, Integer granularity, Boolean aggregate, boolean cacheCookie)
    {
        return post(new SNG_ModemUsageDate[] { modemUsageDate }, grain, granularity, aggregate, cacheCookie);
    }
    
   /**
     * Performs a HTTP callout to retrieve a list of usage data information based on the 
     * list of modems and date ranges provided.
     *
     * @param   modemsUsageDates The list MAC addresses and date ranges to obtain usage data for.
     * @param  url               The URL of the request
     * @param  grain             The requested grain: DAY, MONTH, CUSTOM
     * @param  granularity       The requested granularity. If this value is null, the default value UsageService uses is 0.
     * @param  aggregate         Whether to aggregate values across intervals or not. If null, UsageService uses false
     * @return                   A list of usage data corresponding to the requested data.
     */    
    public static HTTPResponse post(List<SNG_ModemUsageDate> modemsUsageDates, Grain grain, Integer granularity, Boolean aggregate, boolean cacheCookie)
    {
    	return post(modemsUsageDates, grain, granularity, aggregate, UDM_VERSION_TIMEOUT_IN_MSEC, cacheCookie);
    }
    
    /**
     * Performs a HTTP callout to retrieve a list of usage data information based on the 
     * list of modems and date ranges provided.
     *
     * @param   modemsUsageDates The list MAC addresses and date ranges to obtain usage data for.
     * @param  url               The URL of the request
     * @param  grain             The requested grain: DAY, MONTH, CUSTOM
     * @param  granularity       The requested granularity. If this value is null, the default value UsageService uses is 0.
     * @param  aggregate         Whether to aggregate values across intervals or not. If null, UsageService uses false
     * @param  timeout           The timeout value requested for the service to respond.
     * @return                   A list of usage data corresponding to the requested data.
     */    
    public static HTTPResponse post(List<SNG_ModemUsageDate> modemsUsageDates,  Grain grain, Integer granularity, Boolean aggregate, integer timeout,  boolean cacheCookie)
    {
    	SNG_ExceptionUtil.throwIfNullObject(modemsUsageDates, 'modems to get usage data is NULL.');
        String jsonRequestBody = JSON.serialize(modemsUsageDates);
        String url = buildUrl(UDM_HTTP_PATH, grain, granularity, aggregate);
        
        //System.debug('Modem Usage Request Body: ' + jsonRequestBody);
        HttpResponse response = SNG_HttpCallout.sendHttpPostRequest(url, timeout, jsonRequestBody, SNG_HttpCallout.CONTENT_TYPE_JSON, cacheCookie);
        //System.debug('Modem Usage Response Body: ' + response.getBody());
        return response;
    }
    
    /**
     * Builds up the URL based on the parameters provided. If the request parameter value is set to null, the data is not added
     * to the URL.
     *
     * @param  url               The URL of the request
     * @param  grain             The requested grain: DAY, MONTH, CUSTOM
     * @param  granularity       The requested granularity. If this value is null, the default value UsageService uses is 0.
     * @param  aggregate         Whether to aggregate values across intervals or not. If null, UsageService uses false.
     */
    private static String buildUrl(String url, Grain grain, Integer granularity, Boolean aggregate)
    {
    	return url + 'grain=' + grain.name() + 
    	       ((null != granularity) ? '&granularity=' + granularity : '') + 
    	       ((null != aggregate) ? '&aggregate=' + aggregate : '');
    }
    
    
}