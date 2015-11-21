/**
 * This class holds onto usage data for a particular Modem / Service Plan
 */
public with sharing class SNG_ModemServicePlanUsageData extends SNG_MacAddressUsageData {
	
	/**
	 * The Service Plan Id (Name field) corresponding with this ModemServicePlan__c
	 */
	public String servicePlanId { get; set; }
	
	/**
	 * The Modem / Service Plan Id (Name field) corresponding with this ModemServicePlan__c
	 */
	public String mspId { get; set; }
	
	/**
     * Creates an instance of this object.
     *
     * @param     mspId               The Modem / Service Plan Id (Name)
     * @param     macAddress          The Modem MAC address
     * @param     servicePlanId       The Service Plan Id (Name)
     * @param     uploadUsage         The upload data usage in bytes.
     * @param     downloadUsage       The download data usage in bytes
     * @throws    SNG_Exception       Thrown if the MAC address from the Usage Data Mart is not expected.
     */
    public SNG_ModemServicePlanUsageData(String mspId, String macAddress, String servicePlanId, Long uploadUsage, Long downloadUsage) {
    	super(macAddress, uploadUsage, downloadUsage);
    	this.mspId = mspId;
    	this.servicePlanId = servicePlanId;
    }
    
    /**
     * Indicates whether some other object is "equal to" this one.
     * 
     * @param   obj             The reference object with which to compare.
     * @return                  True if this object is the same as the obj argument; false otherwise.
     */ 
    public override virtual boolean equals(final Object obj) {
    	if (this === obj) return true;
        if (obj == null || !(obj instanceof SNG_ModemServicePlanUsageData)) return false;
        
        SNG_ModemServicePlanUsageData other = (SNG_ModemServicePlanUsageData) obj;
    	return super.equals(obj) && this.mspId == other.mspId && this.servicePlanId == other.servicePlanId;
    }
    
    /**
     * The hashcode for this object.
     *
     * @return                   A singular hashcode representing this object.
     */
    public override virtual integer hashCode() {
        final integer prime = 31;
        Integer result = prime * super.hashCode() + ((mspId == null) ? 0 : mspId.hashCode());
        result = prime * result + ((servicePlanId == null) ? 0 : servicePlanId.hashCode());
        return result;
    }
	
}