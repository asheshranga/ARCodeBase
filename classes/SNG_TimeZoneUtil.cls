/**
 * This utility class is used to handle conversions between the standard
 * world timezone and salesforce timezones, which add additional granularity.
 */
public with sharing class SNG_TimeZoneUtil
{
	/**
	 * This inner-class keeps the mapping between the standard timezone and
	 * salesforce timezone in an object. 
	 */
	public class TimeZoneToSalesforceTimeZone
	{
		/**
		 * The standard timezone string (Pacific/Mountain/Central/Eastern).
		 */
		public String timeZone;
		
		/**
		 * The Salesforce timezone string.
		 */
		public String salesforceTimeZone;
		
		/**
		 * The constructor to create an instance of the object that
		 * keeps the mapping between the standard timezone and the Salesforce
		 * timezone.
		 */
		public TimeZoneToSalesforceTimeZone(String tz, String sfTz)
		{
			timezone = tz;
			salesforceTimeZone = sfTz;
		}
	}
	
	/**
	 * This table captures the string mapping between a standard timezone and
	 * the Salesforce timezone.
	 */
	public static final transient TimeZoneToSalesforceTimeZone[] timeZoneTable = new TimeZoneToSalesforceTimeZone[]
	{
		new TimeZoneToSalesforceTimeZone( 'Pacific',   'America/Los_Angeles' ),
		new TimeZoneToSalesforceTimeZone( 'Mountain',  'America/Denver'      ),
		new TimeZoneToSalesforceTimeZone( 'Central',   'America/Chicago'     ),
		new TimeZoneToSalesforceTimeZone( 'Eastern',   'America/New_York'    ),
		new TimeZoneToSalesforceTimeZone( 'Arizona',   'America/Phoenix'     )
	};
	
	/**
	 * Unsupported Timezone Exception Message Prefix
	 */
	private static final String UNSUPPORTED_TIMEZONE_EXCEPTION_PREFIX = 'Unsupported timezone: ';
	
	/**
	 * Captures the mapping between the standard timezone and Salesforce timezone in 
	 * collection map.
	 */
	private Map<String, String> timeZoneToSalesforceTimeZoneMap = new Map<String, String>();
	
	/**
     * Captures the mapping between the Salesforce timezone and standard timezone in 
     * collection map.
     */
	private Map<String, String> salesforceTimeZoneToTimeZoneMap = new Map<String, String>();
	
	/**
	 * The default constructor used to create an instance of the object.
	 */
	public SNG_TimeZoneUtil()
	{
		for (integer i = 0; i < timezoneTable.size(); ++i)
		{
			timeZoneToSalesforceTimeZoneMap.put(timezoneTable[i].timeZone, timezoneTable[i].salesforceTimeZone);
			salesforceTimeZoneToTimeZoneMap.put(timezoneTable[i].salesforceTimeZone, timezoneTable[i].timeZone);
		}
	}
	
	/**
	 * Retrieves the standard timezone name that corresponds to the Salesforce timezone
	 * name.
	 *
	 * @param   salesforceTimeZoneStr   The Salesforce timezone string name.
	 * @return                          The standard timezone name that maps to the
	 *                                  equivalent Salesforce timezone name.
	 */
	public String getTimeZoneName(String salesforceTimeZoneStr)
	{
		String timeZoneStr = salesforceTimeZoneToTimeZoneMap.get(salesforceTimezoneStr); 
		throwIfValueIsNull(timeZoneStr, salesforceTimeZoneStr);		
		return timeZoneStr;
	}

    /**
     * Retrieves the Salesforce timezone name that corresponds to the standard timezone
     * name.
     *
     * @param   timeZoneStr             The standard timezone string name.
     * @return                          The Salesforce timezone name that maps to the
     *                                  equivalent standard timezone name.
     */		
	public String getSalesforceTimeZoneName(String timeZoneStr)
	{
		String salesforceTimeZoneStr = timeZoneToSalesforceTimeZoneMap.get(timeZoneStr);
		throwIfValueIsNull(salesforceTimeZoneStr, timeZoneStr);
		return salesforceTimeZoneStr;
	}
	
    /**
     * Retrieves a TimeZone object that corresponds to the standard timezone
     * name.
     *
     * @param   timeZoneStr             The standard timezone string name.
     * @return                          A TimeZone object that corresponds
     *                                  with the specified timezone.
     */ 
	public TimeZone getSalesforceTimeZone(String timeZoneStr)
	{
		String salesforceTimeZoneStr = timeZoneToSalesforceTimeZoneMap.get(timeZoneStr);
		throwIfValueIsNull(salesforceTimeZoneStr, timeZoneStr);
		return TimeZone.getTimezone(salesforceTimeZoneStr);
	}

    /**
     * Retrieves the timezone offset difference between the desired timezone/start time
     * and the current user's timezone/start time.
     *
     * @param   desiredTimeZoneStr      The desired timezone.
     * @param   desiredStartTime        The desired start time.
     * @return                          The timezone offset difference in the desired
     *                                  timezone/start time and the user's local
     *                                  timezone/start time.
     */	
	public integer getSalesforceTimeZoneOffset(String desiredTimeZoneStr, DateTime desiredStartTime)
	{
		String salesforceTimeZoneStr = timeZoneToSalesforceTimeZoneMap.get(desiredTimeZoneStr);
		throwIfValueIsNull(salesforceTimeZoneStr, desiredTimeZoneStr);
	    TimeZone desiredTimeZone = TimeZone.getTimeZone(salesforceTimeZoneStr);
	    TimeZone localTimeZone = UserInfo.getTimeZone();
	    return desiredTimeZone.getOffset(desiredStartTime) - localTimeZone.getOffset(desiredStartTime);
	}
	
	/**
	 * Throws an exception if the value specified is null.
	 *
	 * @param   valueToCheck            The value to check.
	 * @param   inputValue              The variable name holding the value to check.
	 * @throws  SNG_Exception           If the value to check is null.
	 */
	private void throwIfValueIsNull(String valueToCheck, String inputValue)
	{
		SNG_ExceptionUtil.throwIfNullObject(valueToCheck, UNSUPPORTED_TIMEZONE_EXCEPTION_PREFIX + inputValue);
	}

}