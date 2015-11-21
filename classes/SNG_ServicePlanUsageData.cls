/**
 * This class holds onto usage data for a particular Service Plan
 */
public with sharing class SNG_ServicePlanUsageData {
	
	/**
     * The Service Plan Id (Name field)
     */
    public String servicePlanId { get; set; }
	
	/**
	 * Mapping from MAC address to SNG_ModemServicePlanUsageData object
	 */
	public Map<String, SNG_ModemServicePlanUsageData> mspUsageData { get; private set; }
	
	/**
     * The upload usage in bytes for the specified Service Plan
     */
    public Long uploadUsage { get; private set; }

    /**
     * The download usage in bytes for the specified Service Plan
     */
    public Long downloadUsage { get; private set; }
    
    /**
     * The total usage in bytes for the specified Service Plan
     */
    public Long totalUsage { get { return uploadUsage + downloadUsage; } }
	
	/**
     * Creates an instance of this object.
     *
     * @param     servicePlanId     Service Plan Id (Name)
     */
	public SNG_ServicePlanUsageData(String servicePlanId) {
		this.servicePlanId = servicePlanId;
		this.mspUsageData = new Map<String, SNG_ModemServicePlanUsageData>();
		this.uploadUsage = 0;
		this.downloadUsage = 0;
	}
	
	/**
	 * Adds the SNG_ModemServicePlanUsageData to the mspUsageData map and updates the
	 * total usage counts for this SNG_ServicePlanUsageData
	 *
	 * @param  mspUsageDataToAdd   SNG_ModemServicePlanUsageData object to add to the mspUsageData map
	 */
	public void addMspUsageData(final SNG_ModemServicePlanUsageData mspUsageDataToAdd) {
		addDownloadUsage(mspUsageDataToAdd.downloadUsage);
		addUploadUsage(mspUsageDataToAdd.uploadUsage);
		mspUsageData.put(mspUsageDataToAdd.macAddress, mspUsageDataToAdd);
	}
    
    /**
     * Adds downloadUsageToAdd to the downloadUsage
     *
     * @param   downloadUsageToAdd  Download usage to add
     */
    private void addDownloadUsage(final Long downloadUsageToAdd) {
        downloadUsage += downloadUsageToAdd;
    }
    
    /**
     * Adds uploadUsageToAdd to the uploadUsage
     *
     * @param   uploadUsageToAdd  Upload usage to add
     */
    private void addUploadUsage(final Long uploadUsageToAdd) {
        uploadUsage += uploadUsageToAdd;
    }
	
}