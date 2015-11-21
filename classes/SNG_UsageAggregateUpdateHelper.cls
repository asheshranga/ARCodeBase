/**
 * Utility class to help in update the usage data information.
 */
public with sharing class SNG_UsageAggregateUpdateHelper {
    
    /**
     * One gigabyte in bytes.
     */
    private static final long ONE_GIGABYTE_IN_BYTES = 1073741824;
    
    /**
     * Min GB allowed.
     */
    private static final Decimal MIN_GB_THRESHOLD = 0.01;
    
    /**
     * Validates the data is present to populate the response with.
     *
     * @param     response              The Usage Service Web service response.
     * @return                          True if data exists; false otherwise.
     */
    public static boolean isDataPresent(final SNG_UsageService.response response)
    {
        return (null != response && null != response.data);
    }
    
    /**
     * Converts the byte count value to two decimal places. If the value is less than the
     * required threshold, the value gets set to 0.
     *
     * @byteCount           The byte count to convert into GB.
     * @return              The byte count in GB format.
     */
    public static decimal convertToGb(long byteCount)
    {
        decimal byteCountDecimal = Decimal.valueOf(byteCount);
        decimal retValue = (byteCountDecimal/ONE_GIGABYTE_IN_BYTES).setScale(2);
        return (retValue >= MIN_GB_THRESHOLD) ? retValue : 0;
    }
    
}