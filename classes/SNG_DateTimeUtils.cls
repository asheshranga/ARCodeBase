public with sharing class SNG_DateTimeUtils 
{
	
	/**
	 * Gets a DateTime object with the date from a Date object, at 00:00:00 GMT on that date
	 *
	 * @param  d   Date object to get DateTime object for
	 * @return     DateTime object 
	 */
	public static DateTime toDateTimeGmt(Date d)
	{
		return DateTime.newInstanceGmt(d.year(), d.month(), d.day());
	}
	
    /**
     * Returns the maximum Datetime between two DateTime objects.
     *
     * @param   a                   The first DateTime object to compare.
     * @param   b                   The second DateTime object to compare.
     * @return                      The maximum DateTime object.
     */    
    public static DateTime max(final DateTime a, final DateTime b)
    {
        return (a > b) ? a : b;
    }
    
    /**
     * Returns the minimum Datetime between two DateTime objects.
     *
     * @param   a                   The first DateTime object to compare.
     * @param   b                   The second DateTime object to compare.
     * @return                      The minimum DateTime object.
     */
    public static DateTime min(final DateTime a, final DateTime b)
    {
        return (a < b) ? a : b;
    }
    
}