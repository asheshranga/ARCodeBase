/**
 * This class captures the JSON request body for a Usage Service request. The data
 * is a list of objects, which contain the modem MAC address and a corresponding date
 * range to get usage data for.
 */
global with sharing class SNG_ModemUsageDate 
{
	/**
	 * The Modem MAC address.
	 */
    public String macAddress;
    
    /** 
     * The start date for the usage data period.
     */
    public DateTime startTime;
    
    /** 
     * The end date for the usage data period.
     */
    public DateTime endTime;
    
    /**
     * Creates an instance of this object
     *
     * @param    macAddress     The Modem MAC address
     * @param    startTime      The start date/time.
     * @param    endTime        The end date/time.
     */
    public SNG_ModemUsageDate(String macAddress, DateTime startTime, DateTime endTime)
    {
        this.macAddress = macAddress;
        this.startTime = startTime;
        this.endTime = endTime;
    }
    
    /**
     * Method to deserialize the JSON response. This is required due to the quirky oddness of DateTime. Regardless
     * of ISO-8601 GMT time, the date is converted to local time, without accounting for difference in hours
     * from actual GMT. This fixes the problem to retain the proper time for GMT.
     *
     * @param    jsonResponse          The JSON response to parse.
     * @return                         The deserialized object as SNG_ModemUsageDate.
     * @throw    SNG_Exception         Thrown if the response to deserialize is null. 
     * @throw    System.JSONException  Thrown if the JSON cannot be properly deserialized.
     */
    public static SNG_ModemUsageDate deserialize(String jsonResponse)
    {
    	SNG_ExceptionUtil.throwIfNullObject(jsonResponse, 'The JSON response to deserialize is null.');
    	SNG_ModemUsageDate mud = (SNG_ModemUsageDate)JSON.deserialize(jsonResponse, SNG_ModemUsageDate.class);
    	mud.startTime = DateTime.newInstance(mud.startTime.getTime());
    	mud.endTime = DateTime.newInstance(mud.endTime.getTime());
    	return mud;
    }
    
    
    /**
	 * Indicates whether some other object is "equal to" this one.
	 * 
	 * @param 	obj 			The reference object with which to compare.
	 * @return 					True if this object is the same as the obj argument; false otherwise.
	 */ 
    public Boolean equals(Object obj) { 
    	
    	// objects are the same objects
    	if (this === obj)
    	{ 
    		return true;
    	}
    	// obj is null or not instance of this class
    	if (obj == null || !(obj instanceof SNG_ModemUsageDate))
    	{
    		return false;
    	}
    	
    	SNG_ModemUsageDate other = (SNG_ModemUsageDate) obj;
    	
    	return StringUtils.equals(macAddress, other.macAddress) && (startTime == other.startTime) 
    			&& (endTime == other.endTime);
    }
    
	/**
     * The hashcode for this object.
     *
     * @return                   A singular hashcode representing this object.
     */
    public integer hashCode() { 
    	
    	final Integer prime = 31;
    	Integer result = 1;
    	result = prime * result + ((macAddress == null) ? 0 : macAddress.hashCode());
    	result = prime * result + ((startTime == null) ? 0 : startTime.format().hashCode());
    	result = prime * result + ((endTime == null) ? 0 : endTime.format().hashCode()); 
    	return result;  
    }
}