/**
 * This class is used to verify the exception dates of a ModemViewState record. 
 * The records expire daily, with the exception of the refresh button, which
 * allows an existing record to be updated every 15 minutes (for current billing cycle only).
 */
public with sharing class SNGModemViewStateExpiration 
{
	/**
	 * Validates whether the cache data is valid or not.
	 *
	 * @param  currentBillingCycle        Flag to indicate whether the current billing cycle is selected.
	 * @param  isRefresh                  Flag to indicate whether the call is from a refresh button.
	 */
	public static boolean isCacheDataExpired(DateTime timestamp, 
	                                         boolean currentBillingCycle, 
	                                         boolean isRefresh, 
	                                         boolean isPerformanceData)
	{
		return (DateTime.now() >= calculate(currentBillingCycle, timestamp, isRefresh, isPerformanceData));
	}
	
	
	/**
	 * This method is used to calculate an expiration date of a ModemViewState
	 *
	 * @param   currentBillingCycle        Flag to indicate whether the current billing cycle is selected.
	 * @return                             The expiration datetime value.
	 */
    private static DateTime calculate(boolean currentBillingCycle, 
                                      DateTime timestamp, 
                                      boolean isRefresh, 
                                      boolean isPerformanceData)
    {   
        DateTime expirationTime = null;
        
        
        if (currentBillingCycle && (isRefresh || isPerformanceData))
        {
            expirationTime = calculateNextQuarterHour(timestamp);
        }
        else
        { 
            expirationTime = calculateNextDay(timeStamp);
        }

        return expirationTime;
    }
    
    /**
     * Calculates the datetime for the next quarter hour based on current time.
     *
     * @return               The expected datetime for the next quarter hour.
     */
    private static DateTime calculateNextQuarterHour(DateTime timestamp)
    {
        DateTime currentTime = timestamp.addSeconds(-timestamp.second());
        integer newMinute = 15 - Math.mod(currentTime.minute(), 15);
        currentTime = currentTime.addMinutes(newMinute);
        return currentTime;
    }
  
  
    /**
     * Calculates the datetime for the next day based on current time.
     *
     * @return               The expected datetime for the next quarter hour.
     */    
    private static DateTime calculateNextDay(DateTime timestamp)
    {
        DateTime currentTime = timestamp;
        DateTime nextDay = currentTime.addDays(1);
        return nextDay.addHours(-nextDay.hourGmt()).addMinutes(-nextDay.minute()).addSeconds(-nextDay.second());
    }
}