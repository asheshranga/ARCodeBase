/**
 * This class is used to calculate the usage data for a list of terminal objects based on a 
 * specified date range.
 */
public with sharing class SNG_UtUsageAggregate extends SNG_UsageAggregate
{
	/**
	 * The list of terminals to update usage data for.
	 */
    private List<Terminal__c> terminalList;
    
    /**
     * Boolean whether to allow cookie caching for HTTP request
     */
    private boolean allowCookieCaching; 

    /**
     * This constructor is used to create an instance of the object. The constructor is
     * required due to usage by the Visualforce page corresponding to this class.
     *
     * @param  controller       The pre-built Visualforce controller for the terminal object.
     */
    public SNG_UtUsageAggregate(List<Terminal__c> terminals, Date startDate, Date endDate, boolean allowCookieCaching)
    {
    	super(startDate, endDate);
    	terminalList = terminals;
    	this.allowCookieCaching = allowCookieCaching;
    }
    
    /**
     * Processes the usage aggregate calculation for a list of terminals. This method is overriden
     * from the SNG_UsageAggregate.
     *
     * @throw   SNG_Exception       If any exceptions are encountered during the request process.
     */
    public override void process()
    {
    	Map<String, Id> macAddressToTerminalId = null;
    	
    	try 
        {
        	Map<Id, Terminal__c> terminals = createTerminalMap(terminalList);
            macAddressToTerminalId = createMacAddressToTerminalIdMap(terminals);
            Map<Id, List<ModemServicePlan__c>> msps = SNG_Terminal.getMspsForTerminals(terminalList, startDate.dateGmt(), endDate.dateGmt());
            
            List<ModemServicePlan__c> mspList = constructSingularList(msps.values());
            SNG_UsageService.Response usageResponse = getUsageLatest(mspList, allowCookieCaching);
            SNG_UtUsageAggregateUpdater.process(terminals, macAddressToTerminalId, usageResponse);
        } 
        catch (Exception e) 
        {
        	SNG_UtUsageAggregateUpdater.processException(terminalList);
            throw new SNG_Exception(SNG_HtmlUtilities.getHtmlMessageCenteredBoldRedFontFormat(e.getMessage()));
        }
    }
    
    private List<ModemServicePlan__c> constructSingularList(List<List<ModemServicePlan__c>> msps)
    {
    	List<ModemServicePlan__c> singularList = new List<ModemServicePlan__c>();
    	
    	for (List<ModemServicePlan__c> mspsList : msps)
    	{
    		for (ModemServicePlan__c msp : mspsList)
    		{
    			msp.EndDate__c = msp.EndDate__c; 
    		    singularList.add(msp);
    		}
    	}
    	
    	return singularList;
    }
    
    
    /**
     * Creates a mapping between the terminal ID and the corresponding terminal object.
     *
     * @param   terminals             The list of terminals to be updated.
     */
    private Map<Id, Terminal__c> createTerminalMap(List<Terminal__c> terminals)
    {
        Map<Id, Terminal__c> terminalMap = new Map<Id, Terminal__c>();
        for (Terminal__c t : terminals)
        {
            terminalMap.put(t.Id, t);
        }
        return terminalMap;
    }
    
    /**
     * Creates a mapping between the MAC address and it's corresponding terminal object. Any MAC address
     * without a terminal object is ignored.
     *
     * @param    terminals              The collection of terminals to map to a MAC address.
     * @return                          A mapping from the MAC address to its terminal object.
     */
    private Map<String, Id> createMacAddressToTerminalIdMap(Map<Id, Terminal__c> terminals)
    {
        Map<String, Id> macAddressToTerminalId = new Map<String, Id>();
        List<Modem__c> modems = [SELECT MacAddress__c, Terminal__r.Name FROM Modem__c WHERE Terminal__c IN :terminals.keySet()];
        
        for (Modem__c modem : modems)
        {
            if (terminals.containsKey(modem.Terminal__c))
            {
                macAddressToTerminalId.put(modem.MacAddress__c.toLowerCase(), modem.Terminal__c);
            }
        }
        
        return macAddressToTerminalId;
    }
}