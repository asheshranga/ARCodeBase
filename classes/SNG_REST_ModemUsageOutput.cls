/**
 * Represents the "data" portion of the JSON response structure
 */ 
public with sharing class SNG_REST_ModemUsageOutput  extends SNG_REST_CollectionOutput 
{
    /**
     * The Modem MAC address.
     */
    public String macAddress;
    
    /**
     * The download usage in bytes.
     */
    public long downloadUsage; 
    
    /**
     * The upload usage in bytes.
     */
    public long uploadUsage;
    
    /**
     * The total usage in bytes.
     */
    public long totalUsage { get { return downloadUsage + uploadUsage; } } 
    
    /**
     * Creates an instance of this object.
     *
     * @param     modemUsage        The list of modems and its corresponding usage information. This object
     *                              contains the service plan ID and usage under the service plan.
     * @param     macAddress        The modem mac address.
     */
    public SNG_REST_ModemUsageOutput(final List<ServicePlanUsageData> spudUsage, final String macAddr)
    { 
        super(spudUsage);
        macAddress = macAddr;
        initialize(spudUsage);
    }
    
    /**
     * Initializes usage data values based on the parameters provided.
     *
     * @param     spud              The data usage based on the service plan.
     */
    private void initialize(final List<ServicePlanUsageData> spudUsage)
    {
    	defaultUsage();
    	
    	if (null != spudUsage)
    	   updateUsage(spudUsage);
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
    private void updateUsage(final List<ServicePlanUsageData> items)
    {
        SNG_REST_Utilities.assertTrue(null != items, 'Items list is expected to be a non-null value.');
        for (ServicePlanUsageData spud : items)
        {
            downloadUsage += spud.downloadUsage;
            uploadUsage += spud.uploadUsage;
        }       
    }
    
    
    /**
     * Equality comparison used when the object is used as a key in a map.
     * Verifies the status and sub-code is equal.
     *
     * @param    obj             The object to compare for equality.
     * @return                   Whether or not the objects are considered equal.
     */
    public override boolean equals(Object obj) { 
        // Compare references
        if (this === obj) return true; 
        if (obj == null || !(obj instanceof SNG_REST_ModemUsageOutput)) return false;
        if (!super.equals(obj)) return false;
        
        SNG_REST_ModemUsageOutput other = (SNG_REST_ModemUsageOutput) obj;
        
        boolean isEquals = (StringUtils.equals(macAddress, other.macAddress) &&
                            downloadUsage == other.downloadUsage &&
                            uploadUsage == other.uploadUsage &&
                            totalUsage == other.totalUsage); 
        return isEquals;
    }
    
    /**
     * The hashcode for this object.
     *
     * @return                   A singular hashcode representing this object.
     */
    public override Integer hashCode() { 
        final integer prime = 31;
        integer result = 1;
        result = prime * result + ((macAddress == null) ? 0 : macAddress.hashCode());
        result = prime * result + (integer)(downloadUsage ^ (downloadUsage >>>32));
        result = prime * result + (integer)(uploadUsage ^ (uploadUsage >>>32));
        result = prime * result + (integer)(totalUsage ^ (totalUsage >>>32));
        result = prime * result + ((items == null) ? 0 : items.hashCode());
        return result;
    }
    
    
    /**
     * This inner class is used to capture the usage data information and its corresponding
     * service plan.
     */
    public class ServicePlanUsageData
    {
       /**
         * The service plan ID.
         */
        public String servicePlanId
        {
            get;
            set 
            {
            	System.debug('servicePlanId value output: ' + value);
            	
                String SERVICE_PLAN_PREFIX_REGEX = '[Ss][Pp][-]';
                SNG_REST_Utilities.assertTrue(new SfIdChecker(SERVICE_PLAN_PREFIX_REGEX).isValidFormat(value), 
                                              'Invalid Service Plan ID format. Expected: SP-XXXX');
                servicePlanId = value;
            }
        }
        
        /**
         * The download usage under the service plan.
         */
        public long downloadUsage;
        
        /**
         * The upload usage under the service plan.
         */
        public long uploadUsage;
        
        /**
         * The total usage under the service plan.
         */
        public long totalUsage { get { return downloadUsage + uploadUsage; } }
        
        /**
         * Creates an instance of the object.
         *
         * @param   servicePlanId    The service plan ID.
         * @param   dlUsage          The download usage for the service plan.
         * @param   ulUsage          The upload usage for the service plan.
         */
        public ServicePlanUsageData(final String servicePlanId, final long dlUsage, final long ulUsage)
        { 
            this.servicePlanId = servicePlanId;
            downloadUsage = dlUsage;
            uploadUsage = ulUsage;
        }
        
        /**
         * Equality comparison used when the object is used as a key in a map.
         * Verifies the status and sub-code is equal.
         *
         * @param    obj             The object to compare for equality.
         * @return                   Whether or not the objects are considered equal.
         */
        public boolean equals(Object obj) {
            // Compare references
            if (this === obj)  return true; 
            if (obj == null || !(obj instanceof ServicePlanUsageData)) return false;
            
            ServicePlanUsageData other = (ServicePlanUsageData) obj;
            return (StringUtils.equals(servicePlanId, other.servicePlanId) &&
                    downloadUsage == other.downloadUsage && 
                    uploadUsage == other.uploadUsage &&
                    totalUsage == other.totalUsage);
        }
        
        /**
         * The hashcode for this object.
         *
         * @return                   A singular hashcode representing this object.
         */
        public integer hashCode() { 
            final integer prime = 31;
            integer result = 1;
            result = prime * result + ((servicePlanId == null) ? 0 : servicePlanId.hashCode());
            result = prime * result + (integer)(downloadUsage ^ (downloadUsage >>>32));
            result = prime * result + (integer)(uploadUsage ^ (uploadUsage >>>32));
            result = prime * result + (integer)(totalUsage ^ (totalUsage >>>32));
            return result;
        } 
    }    
}