/**
 * This class is contains the format to be used as the JSON output for a Service Plan Usage
 * API call.
 */
public with sharing class SNG_REST_ServicePlanUsageOutput extends SNG_REST_CollectionOutput
{
	/**
     * The prefix for a valid ServicePlan id. All ServicePlan IDs are of the format: SP-xxxx. 
     */
    private static final String SERVICE_PLAN_PREFIX_REGEX = '[Ss][Pp][-]';
	
    /**
     * The Service Plan ID. Format: SP-XXXX
     * The property will throw if the value being set to is not the expectant format.
     */
    public String servicePlanId 
    { 
      get; 
      set
      {
      	assertTrue(new SfIdChecker(SERVICE_PLAN_PREFIX_REGEX).isValidFormat(value), 
      	           'Invalid servicePlanId: ' + value);
      	servicePlanId = value;
      }
    }
    
    /**
     * The aggregate upload usage in bytes.
     */
    public Long uploadUsage { get; set; }
    
    /**
     * The aggregate download usage in bytes.
     */
    public Long downloadUsage { get;set; }
    
    /**
     * The aggregate total usage in bytes.
     */
    public Long totalUsage { get { return uploadUsage + downloadUsage; } } 
    
    /**
     * Creates an instance of this object.
     *
     * @param  servicePlanId          The service plan ID.
     * @param  items                  A list of usage information separated by mac address.
     */
    public SNG_REST_ServicePlanUsageOutput( final String servicePlanId,
                                            final List<MacAddressUsageData> items)
    {
        super(items);
        this.servicePlanId = servicePlanId;
        initializeUsage(items);
    }
    
    /**
     * Initializes the usage data. The method aggregates the upload, download, and total usage
     * data to calculate overall data usage.
     *
     * @param  items                  The Modem MAC address and usage information to aggregate.
     */
    private void initializeUsage(final List<MacAddressUsageData> items)
    {
    	defaultUsage();
    	
    	if (null != items)
    	    updateUsage(items);
    }
    
    /**
     * Defaults the upload and download total to a default value.
     */
    private void defaultUsage()
    {
    	uploadUsage = 0;
    	downloadUsage = 0;
    }
    
    /**
     * Calculates the aggregate upload and download usage based on the service plan usage
     * data.
     *
     * @param      items             The data usage based on the service plan.
     */
    private void updateUsage(final List<MacAddressUsageData> items)
    {
    	assertTrue(null != items, 'Items list is expected to be a non-null value.');
        for (MacAddressUsageData maud : items)
        {
            uploadUsage += maud.uploadUsage;
            downloadUsage += maud.downloadUsage;
        }   	
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
    
    /**
	 * Indicates whether some other object is "equal to" this one.
	 * 
	 * @param 	obj 			The reference object with which to compare.
	 * @return 					True if this object is the same as the obj argument; false otherwise.
	 */ 
	public virtual override boolean equals(final Object obj) { 
		
		if (this === obj) return true;
        if (obj == null || !(obj instanceof SNG_REST_ServicePlanUsageOutput)) return false;
        if (!super.equals(obj)) return false;

		SNG_REST_ServicePlanUsageOutput other = (SNG_REST_ServicePlanUsageOutput) obj; 
        return ( (this.servicePlanId == other.servicePlanId) && 
        		 (this.uploadUsage == other.uploadUsage) &&
        		 (this.downloadUsage == other.downloadUsage) &&
        		 (this.totalUsage == other.totalUsage));
	}
	
	/**
     * The hashcode for this object.
     *
     * @return                   A singular hashcode representing this object.
     */
	public virtual override integer hashCode()
    {	
        final integer prime = 31;
        integer result = 1;
        result = prime * result + super.hashCode();
        result = prime * result + ((servicePlanId == null) ? 0 : servicePlanId.hashCode());
        result = prime * result + (integer)(uploadUsage ^ (uploadUsage >>> 32));
        result = prime * result + (integer)(downloadUsage ^ (downloadUsage >>> 32));
        result = prime * result + (integer)(totalUsage ^ (totalUsage >>> 32));
        return result;
    }
  
    
    /**
     * Inner class, capturing the list of items in the JSON response. The list of
     * items is the breakdown of usage data for a specified mac address within the
     * date ranges the service plan is valid.
     */    
    public class MacAddressUsageData
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
        public MacAddressUsageData( String macAddress, 
                                    Long uploadUsage,
                                    Long downloadUsage)
        {
        	this.macAddress = macAddress;
        	this.uploadUsage = uploadUsage;
        	this.downloadUsage = downloadUsage;
        }      
        
        
        /**
	 	 * Indicates whether some other object is "equal to" this one.
	 	 * 
	 	 * @param 	obj 			The reference object with which to compare.
	 	 * @return 					True if this object is the same as the obj argument; false otherwise.
	 	 */ 
		public virtual boolean equals(final Object obj) { 
		
			if (this === obj) return true;
        	if (obj == null || !(obj instanceof MacAddressUsageData)) return false;
        	
			MacAddressUsageData other = (MacAddressUsageData) obj; 
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
    }
}