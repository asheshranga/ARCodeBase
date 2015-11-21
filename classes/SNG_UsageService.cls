/**
 * This class is used to capture the response from SNG_UsageService (JSON response) by mapping the response
 * into the corresponding POJO object described here.
 */
global with sharing class SNG_UsageService 
{
	/**
	 * The response header provided by Usage Service when performing a RESTful API request to get Modem MAC
	 * address usage data.
	 */
    global virtual class ResponseHeader
    {
    	/**
    	 * The status of the request. There are three possible values: 
    	 * 1) success  -  HTTP status response (1XX, 2XX, 3XX)
    	 * 2) failure  -  HTTP status response (500-599)
    	 * 3) error    -  HTTP status (4XX)
    	 */
    	public String status;
    	
    	/**
    	 * An error code describing the error encountered during the processing of the requeest.
    	 * 0 represents no error.
    	 */
    	public integer error;
    	
    	/**
    	 * Represents the array of detailed errors that occurred in the API method. The primary
    	 * purpose is to relay any errors found during the processing of the raw accoungint records
    	 * in the UDM private API.
    	 */
    	public List<String> errorDetail;
    }
    
    /**
     * This class extends the Response Header by providing the usage data information for a Modem with
     * a specified date range.
     */
    global class Response extends ResponseHeader
    {
    	/**
    	 * A list of usage data information.
    	 */
    	public List<List<UsageAndErrors>> data;
    }
    
    
    /**
     * This class captures the usage data information and any errors encountered during the processing
     * of the specific request.
     */
    public class UsageAndErrors
    {
    	/**
    	 * The start time of the grain interval (inclusive).
    	 */
    	public DateTime startTime;
    	
    	/**
		 * The end time of the grain interval (exclusive).
    	 */
    	public DateTime endTime;
    	
    	/**
    	 * The timestamp of the first raw record processed within the grain interval.
    	 */
    	public DateTime firstProcessedEventTimestamp;
    	
    	/**
    	 * The timestamp of the last raw record processed within the grain interval.
    	 */
    	public DateTime lastProcessedEventTimestamp;
    	
    	/**
    	 * The number of bytes downloaded during the period.
    	 */
    	public Long aggregateAcctInputOctets;
    	
    	/**
    	 * The number of bytes uploaded during the period.
    	 */
    	public Long aggregateAcctOutputOctets;
    	
    	/**
    	 * array containing a set of tuples, providing usage according to base-station (bsid) 
    	 * serving the modem at the time the usage occurred.
    	 */
    	public List<UsagePerBaseStationId> usage;
    	
    	/**
    	 * MAC address of the modem for which usage was requested.
    	 */
    	public String macAddress;
    }
    
    /**
     * This class captures the usage data based on the base station ID used during the specified time period.
     * This class is intended to be used within the UsageAndErrors class, which covers the time period.
     */
    public class UsagePerBaseStationId
    {
    	/**
    	 * Base station ID serving the modem when the usage was generated.
    	 */
    	public String bsid;
    	
    	/**
    	 * The number of bytes downloaded during the period on this basestation.
    	 */
    	public Long acctInputOctets;
    	
    	/**
    	 * The number of bytes downloaded during the period on this basestation.
    	 */
    	public Long acctOutputOctets;
    }
    
    
    public static SNG_UsageService.Response deserialize(String jsonResponse)
    {
        SNG_UsageService.Response response = (SNG_UsageService.Response)JSON.deserialize(jsonResponse, SNG_UsageService.Response.class);
        if (!ArrayUtils.isEmpty(response.data))
        {
        	for (integer i = 0; i < response.data.size(); ++i)
        	{
        		if (!ArrayUtils.isEmpty(response.data.get(i)))
        		{
        			integer uaeCollectionSize = response.data.get(i).size();
        		    for (integer j = 0; j < uaeCollectionSize; ++j)
        		    {
        		    	UsageAndErrors uaes = response.data.get(i).get(j);    		    	
        			    response.data.get(i).get(j).startTime = DateTime.newInstance(uaes.startTime.getTime());
        			    response.data.get(i).get(j).endTime = DateTime.newInstance(uaes.endTime.getTime());
        			    response.data.get(i).get(j).firstProcessedEventTimestamp = (null != uaes.firstProcessedEventTimestamp) ?
        			                      DateTime.newInstance(uaes.firstProcessedEventTimestamp.getTime()) : null;
        			    response.data.get(i).get(j).lastProcessedEventTimestamp = (null != uaes.lastProcessedEventTimestamp) ?
        			                      DateTime.newInstance(uaes.lastProcessedEventTimestamp.getTime()) : null;
        		    }
        		}
        	}
        }
        
        return response;
    } 
    
}