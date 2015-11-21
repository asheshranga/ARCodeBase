/**
 * This class is used to perform the HTTP callout to the PMDR service to obtain peer data.
 */
public with sharing class SNG_UtPeersHttpCallout {

    /**
     * This method is used to perform the HTTP POST call to the PMDR service.
     *
     * @param   url                 The URL path to send the HTTP callout to.
     * @param   macAddress          The MAC address to obtain data for. This data will be added to the
     *                              response body.
     * @param   minutesFromNow      The minutes from current time. This value is used to determine 
     *                              if the data point is still considered valid. Any value outside this range
     *                              will not be considered as a data point.
     * @param   timeout             The HTTP callout timeout in waiting for a response.
     */
    public static HTTPResponse post(String url, String macAddress, integer minutesFromNow, integer timeout, boolean allowCookieCaching)
    {
    	SNG_ExceptionUtil.throwIfNullObject(macAddress, 'MAC address is NULL.');
        return post(url, new String[]{ macAddress }, minutesFromNow, timeout, allowCookieCaching);
    }

    /**
     * This method is used to perform the HTTP POST call to the PMDR service.
     *
     * @param   url                 The URL path to send the HTTP callout to.
     * @param   macAddress          The lists of MAC addresses to obtain data for. This data will be added to the
     *                              response body.
     * @param   minutesFromNow      The minutes from current time. This value is used to determine 
     *                              if the data point is still considered valid. Any value outside this range
     *                              will not be considered as a data point.
     * @param   timeout             The HTTP callout timeout in waiting for a response.
     */
    public static HTTPResponse post(String url, List<String> macAddresses, integer minutesFromNow, integer timeout, boolean allowCookieCaching)
    {
    	SNG_ExceptionUtil.throwIfNullObject(url, 'url is NULL.');
    	SNG_ExceptionUtil.throwIfNullObject(macAddresses, 'MAC addresses are NULL.');
    	SNG_ExceptionUtil.throwIfNullObject(minutesFromNow, 'minutes from now is NULL.');
    	SNG_ExceptionUtil.throwIfNullObject(timeout, 'timeout is NULL.');
    	
        String jsonRequestBody = JSON.serialize(new SNG_UtPeersRequestBody(macAddresses, minutesFromNow));
        
        return SNG_HttpCallout.sendHttpPostRequest(url, timeout, jsonRequestBody, SNG_HttpCallout.CONTENT_TYPE_JSON, allowCookieCaching);   
    }
 
    /**
     * The class represents the response body format to be used in the HTTP request body. This object can be serialized
     * into the JSON request body for this particular HTTP request.
     */
    public class SNG_UtPeersRequestBody 
    {
    	/**
    	 * The list of mac addresses to the obtain data for.
    	 */
        public List<String> macAddresses;
        
        /**
         * The minutes from current time for which the data is still valid for.
         */
        public integer minutesFromNow;
    
        /**
         * Creates an instance of this object.
         *
         * @param   macAddress          The lists of MAC addresses to obtain data for. This data will be added to the
         *                              response body.
         * @param   minutesFromNow      The minutes from current time. This value is used to determine 
         *                              if the data point is still considered valid. Any value outside this range
         *                              will not be considered as a data point.
         */
        public SNG_UtPeersRequestBody(List<String> macAddresses, integer minutesFromNow)
        {
            this.macAddresses = macAddresses;
            this.minutesFromNow = minutesFromNow;
        }
    }
    
}