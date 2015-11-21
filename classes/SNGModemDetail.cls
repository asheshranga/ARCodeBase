public with sharing class SNGModemDetail 
{
    public List<ModemServicePlan__c> relatedModemServicePlans { get; set; }
    
    public String softwareVersion { get { return (null == softwareVersion) ? '' : softwareVersion; } private set; }
    
    /**
     * References the specified modem record to update.
     */     
    private Modem__c modem;
    
    
     /**
     * This constructor is used to create an instance of the object. The constructor is
     * required due to usage by the Visualforce page corresponding to this class.
     *
     * @param  controller       The pre-built Visualforce controller for the modem object.
     */
    public SNGModemDetail(ApexPages.StandardController controller)
    {
        initialize((Modem__c)controller.getRecord());
    }
    
    
    private void initialize(Modem__c m)
    {
    	modem = m;
    	relatedModemServicePlans = [ SELECT Id, Name, Account__c, StartDate__c, EndDate__c, Modem__c, 
    	                                    Status__c, ServicePlanStartDate__c, ServicePlanEndDate__c, ServicePlanStatus__c 
    	                                    FROM ModemServicePlan__c 
    	                                    WHERE Modem__c = :modem.id ];
    }
    
    
    /**
     * Calls static void updateVersion(Modem__c) on the current Modem.
     * This is called from a Visualforce action.
     */
    public void updateVersion() 
    {
    	initializePropertiesBeforeQuery();
        softwareVersion = SNGModemSoftwareVersion.get(modem.MacAddress__c);
        updateObject(modem);
    }
    
    
    private void initializePropertiesBeforeQuery()
    {
        softwareVersion = null;
    }
    
    /**
     * Performs a HTTP callout to retrieve the version information for the given modem from the PmdrService.
     * If a valid version is returned, it is set in the Modem object. Otherwise, it is set to VERSION_UNKNOWN.
     *
     * @param   modem   The modem to update the version for
     */
    private void updateObject(Modem__c modem) 
    {    
        modem.SoftwareVersion__c = softwareVersion;
        update modem;
    }
}