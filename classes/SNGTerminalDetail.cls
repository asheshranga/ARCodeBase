public with sharing class SNGTerminalDetail 
{
    /**
     * Currently selected billing cycle to be shown on the Visualforce page
     */
    public String billingCycleSelection { get; set; }

    /**
     * List of possible billing cycles to be shown on the Visualforce page
     */
    public List<SelectOption> billingCycles { get; private set; }
     
    /**
     * A stringified form of the billing cycle start date for use by Visualforce
     */
    public String billingCycleStartDateStr { get { return (null == billingCycleStartDate) ? UNKNOWN_STRING : billingCycleStartDate.format(); } }

    /**
     * A stringified form of the billing cycle end date for use by Visualforce
     */
    public String billingCycleEndDateStr { get { return (null == billingCycleEndDate) ? UNKNOWN_STRING : billingCycleEndDate.format(); } }

    /**
     * Flag to indicate whether it is the current billing cycle or previous billing cycle.
     */
    public boolean currentBillingCycle { get { return (CURRENT_BILLING_CYCLE == billingCycleSelection); } }

    /**
     * A collection of modems related to the terminal.
     */
    public List<Modem__c> relatedModems { get; set; }
    
    /**
     * The first day of the selected billing cycle
     */
    private Date billingCycleStartDate { get; private set; }
    
    /**
     * The last day of the selected billing cycle
     */
    private Date billingCycleEndDate { get; private set; }
    
    /**
     * The modem MAC address.
     */
    private transient String macAddress;
    
    /**
     * The terminal object.
     */
    private Terminal__c terminal;
        
    /**
     * Current Billing Cycle
     */
    private static final transient String CURRENT_BILLING_CYCLE = 'Current Billing Cycle';
    
    /**
     * Previous Billing Cycle
     */
    private static final transient String PREVIOUS_BILLING_CYCLE = 'Previous Billing Cycle';
    
    /**
     * Default string if data is unknown.
     */
    private static final transient String UNKNOWN_STRING = 'Unknown';
    
    /**
     * Reference to the billing cycle util.
     */
    private SNGBillingCycleUtil bcUtil;
        
    /**
     * This constructor is used to create an instance of the object. The constructor is
     * required due to usage by the Visualforce page corresponding to this class.
     *
     * @param  controller       The pre-built Visualforce controller for the terminal object.
     */
    public SNGTerminalDetail(ApexPages.StandardController controller)
    {
        initialize((Terminal__c)controller.getRecord());
    }
    
    public void updateBillingCycleDates() 
    {
        if (billingCycleSelection == CURRENT_BILLING_CYCLE) 
        {
            billingCycleStartDate = bcUtil.currentBillingCycleStartDate;
            billingCycleEndDate = bcUtil.currentBillingCycleEndDate;
        } 
        else if (billingCycleSelection == PREVIOUS_BILLING_CYCLE) 
        {
            billingCycleStartDate = bcUtil.previousBillingCycleStartDate;
            billingCycleEndDate = bcUtil.previousBillingCycleEndDate;
        } 
        else 
        {
            throw new SNG_Exception('Invalid billing cycle selected');
        }
    }
    
    
    public void getSoftwareVersions()
    {
        for (Modem__c modem : relatedModems)
        {
            modem.SoftwareVersion__c = SNGModemSoftwareVersion.get(modem.MacAddress__c);
        }
    }
        
    private void initialize (Terminal__c t)
    {
        terminal = t;
        billingCycleSelection = CURRENT_BILLING_CYCLE;
        bcUtil = new SNGBillingCycleUtil(terminal);
        initBillingCycleSelectList(terminal);
        macAddress = SNG_Terminal.getModemMacAddressForTerminal(terminal);
        relatedModems = [SELECT Name, SerialNumber__c, MacAddress__c, PartNumber__c, SoftwareVersion__c FROM Modem__c WHERE MacAddress__c = :macAddress];
        updateBillingCycleDates();
    }

    private void initBillingCycleSelectList(Terminal__c terminal)
    {
        billingCycles = new List<SelectOption>();
        billingCycles.add(new SelectOption(CURRENT_BILLING_CYCLE, CURRENT_BILLING_CYCLE + ' (' + bcUtil.currentBillingCycleStartDate.format() + ' - ' + bcUtil.currentBillingCycleEndDate.format() + ')'));
               
        if (bcUtil.previousBillingCycleValid)
        {
        	billingCycles.add(new SelectOption(PREVIOUS_BILLING_CYCLE, PREVIOUS_BILLING_CYCLE + ' (' + bcUtil.previousBillingCycleStartDate.format() + ' - ' + bcUtil.previousBillingCycleEndDate.format() + ')'));
        }
    }       
}