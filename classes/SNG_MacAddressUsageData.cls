public virtual with sharing class SNG_MacAddressUsageData 
{
    /**
     * The Modem MAC address for the usage data. Format: XX:XX:XX:XX:XX:XX
     * The property will throw if the value being set to is not the expectant format.
     */
    public String macAddress 
    { 
        get; 
        set
        {
            assertTrue(new SNG_ModemMacAddressChecker().isValidFormat(value), 'Invalid mac address format: ' + value);
            macAddress = value;
        }
    }
    
    /**
     * The upload usage in bytes for the specified Modem MAC address.
     */
    public Long uploadUsage { get; set; }

    /**
     * The download usage in bytes for the specified Modem MAC address.
     */
    public Long downloadUsage { get; set; }

    /**
     * The total usage in bytes for the specified Modem MAC address.
     */
    public Long totalUsage { get { return uploadUsage + downloadUsage; }  private set; }  
    
    /**
     * Creates an instance of this object.
     *
     * @param     macAddress          The Modem MAC address
     * @param     uploadUsage         The upload data usage in bytes.
     * @param     downloadUsage       The download data usage in bytes
     * @throws    SNG_Exception       Thrown if the MAC address from the Usage Data Mart is not expected.
     */
    public SNG_MacAddressUsageData( String macAddress, Long uploadUsage, Long downloadUsage)
    {
        this.macAddress = macAddress;
        this.uploadUsage = uploadUsage;
        this.downloadUsage = downloadUsage;
    }      
    
    
    /**
     * Indicates whether some other object is "equal to" this one.
     * 
     * @param   obj             The reference object with which to compare.
     * @return                  True if this object is the same as the obj argument; false otherwise.
     */ 
    public virtual boolean equals(final Object obj) { 
    
        if (this === obj) return true;
        if (obj == null || !(obj instanceof SNG_MacAddressUsageData)) return false;
        
        SNG_MacAddressUsageData other = (SNG_MacAddressUsageData) obj; 
        return ( (this.macAddress == other.macAddress) && 
                 (this.uploadUsage == other.uploadUsage) &&
                 (this.downloadUsage == other.downloadUsage) &&
                 (this.totalUsage == other.totalUsage));
    }

    /**
     * The hashcode for this object.
     *
     * @return                   A singular hashcode representing this object.
     */
    public virtual integer hashCode()
    {   
        final integer prime = 31;
        integer result = 1;
        result = prime * result + ((macAddress == null) ? 0 : macAddress.hashCode());
        result = prime * result + (integer)(uploadUsage ^ (uploadUsage >>> 32));
        result = prime * result + (integer)(downloadUsage ^ (downloadUsage >>> 32));
        result = prime * result + (integer)(totalUsage ^ (totalUsage >>> 32));
        return result;
    }
    
    /**
     * Assertion check function, which will throw a ValidationException on error.
     *
     * @param   expression            The expression to validate.
     * @param   message               The message to add to the exception.
     * @throws  ValidationException   Thrown if the expression is false; returns otherwise.
     */
    private static void assertTrue(boolean expression, String message)
    {
        if (!expression)
           throw new  SNG_REST_JsonResponseOutput.ValidationException(message);
    }
}