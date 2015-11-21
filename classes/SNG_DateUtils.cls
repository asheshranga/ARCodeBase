public with sharing class SNG_DateUtils {

    /**
     * Returns the current date in GMT
     *
     * @return                      Current Date in GMT
     */
     public static Date todayGmt()
     {
        return System.now().dateGMT();
     }

    /**
     * Returns the maximum Datetime between two DateTime objects.
     *
     * @param   a                   The first DateTime object to compare.
     * @param   b                   The second DateTime object to compare.
     * @return                      The maximum DateTime object.
     */    
    public static Date max(final Date a, final Date b)
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
    public static Date min(final Date a, final Date b)
    {
        return (a < b) ? a : b;
    }

}