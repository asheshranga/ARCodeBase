/**
 * This class is used to create the necessary mappings utilized by the SNG_ServicePlanValidation bulk
 * validation operations. This class helps limit the amount of SOQL queries performed by grouping the
 * necessary mappings through a bulk SOQL query instead of querying for each mapping per SObject. 
 */
public with sharing class SNG_ServicePlanValidationUtil {

    /**
     * The status value for an Active Service Plan.
     */
    public static final transient String STATUS_ACTIVE = 'Active';
    
    /**
     * The name of the RecordType for Service Plan Types
     */
    public static final transient String SERVICE_PLAN_TYPE_RECORD_TYPE_NAME = SNG_ServicePlan.SERVICE_PLAN_TYPE_RECORD_TYPE_NAME;


    /**
     * Creates a mapping between the service plan ID to the corresponding Modem Service Plan(s). Any service plan
     * that is not used by any Modem / Service Plan(s) will not appear in the mapping.
     *
     * @param     servicePlans              The service plans to map to the corresponding Modem / Service Plan(s).
     * @return                              A mapping between the service plan ID to the related Modem / Service Plan(s).
     * @throws    SNG_Exception             Thrown if the provided parameter input is null.
     */
    public static Map<Id, List<ModemServicePlan__c>> createServicePlanIdToModemServiceplan(List<ServicePlan__c> servicePlans)
    {
    	SNG_ExceptionUtil.throwIfNullObject(servicePlans, 'servicePlans is set to NULL.');
    	Set<Id> servicePlanIds = new Map<Id, SObject>(servicePlans).keySet();
    	List<ModemServicePlan__c> modemServicePlans = 
    	   [SELECT Id, Name, ServicePlan__c, StartDate__c, EndDate__c FROM ModemServicePlan__c WHERE ServicePlan__c IN :servicePlanIds];
        
        return createServicePlanIdToModemServicePlansCollection(modemServicePlans);
    }
    
    /**
     * Creates a mapping between the service plan ID to the corresponding Modem Service Plan(s). Any service plan
     * that is not used by any Modem / Service Plan(s) will not appear in the mapping.
     *
     * @param     modemServicePlans         The Modem / Service Plan(s) to map to the corresponding Service Plan.
     * @return                              A mapping between the service plan ID to the related Modem / Service Plan(s).
     * @throws    SNG_Exception             Thrown if the provided parameter input is null.
     */
    public static Map<Id, List<ModemServicePlan__c>> createServicePlanIdToModemServicePlansCollection(List<ModemServicePlan__c> modemServicePlans)
    {
    	SNG_ExceptionUtil.throwIfNullObject(modemServicePlans, 'modemServicePlans is set to NULL.');
    	Map<Id, List<ModemServicePlan__c>> servicePlanIdToModemServicePlans = new Map<Id, List<ModemServicePlan__c>>();
    	
    	for (ModemServicePlan__c modemServicePlan : modemServicePlans)
    	{
    		addEntry(servicePlanIdToModemServicePlans, modemServicePlan);
    	}
    	
    	return servicePlanIdToModemServicePlans;
    }

    /**
     * Creates a listing of Service Plans based on the salesOrder provided. This performs a query on the Salesforce database to
     * obtain ServicePlans that utilize the same sales orders number provided in the collection parameter.
     *
     * @param     salesOrder                The collection of sales order to query in Salesforce.
     * @return                              A listing of service plans that contain the sales order parameter.
     * @throws    SNG_Exception             Thrown if the provided parameter input is null.
     */
    public static List<ServicePlan__c> createServicePlanListingBasedOnSalesOrders(Set<String> salesOrders)
    {
     	SNG_ExceptionUtil.throwIfNullObject(salesOrders, 'salesOrders is set to NULL.');
    	return [SELECT Account__c, SalesOrder__c FROM ServicePlan__c WHERE SalesOrder__c IN :salesOrders];
    }
    
    /**
     * Creates a mapping between the service plan type to the Product object.
     *
     * @param     servicePlan               The service plan objects to obtain the product object matching the service plan type.
     * @return                              A mapping between hte service plan type to the Product.
     * @throws    SNG_Exception             Thrown if the provided parameter input is null.
     */
    public static Map<Id, Product2> createServicePlanTypesToProductCollection(List<ServicePlan__c> servicePlans)
    {
    	SNG_ExceptionUtil.throwIfNullObject(servicePlans, 'servicePlans is set to NULL.');
    	Set<Id> servicePlanTypeIds = createServicePlanTypeCollection(servicePlans);
    	return new Map<Id, Product2>([SELECT Id, Name, RecordType.Name, IsActive, Family, Business_Area__c FROM Product2 WHERE Id IN :servicePlanTypeIds]);
    }

    /**
     * Creates a collection of service plan types.
     *
     * @param     servicePlan               The service plan objects to obtain the product object matching the service plan type.
     * @return                              A mapping between hte service plan type to the Product.
     * @throws    SNG_Exception             Thrown if the provided parameter input is null.
     */
    public static Set<Id> createServicePlanTypeCollection(List<ServicePlan__c> servicePlans)
    {
    	SNG_ExceptionUtil.throwIfNullObject(servicePlans, 'servicePlans is set to NULL.');
        Set<Id> servicePlanTypes = new Set<Id>();
        for (ServicePlan__c servicePlan : servicePlans)
        {
            servicePlanTypes.add(servicePlan.ServicePlanType__c);
        }  
        return servicePlanTypes; 	
    }
    
    /**
     * Creates a collection of sales order values that exist in the service plan collection.
     * 
     * @param     servicePlan               The service plans to obtain the sales order for.
     * @return                              A collection of sales orders that are used by the service plan collection.
     * @throws    SNG_Exception             Thrown if the provided parameter input is null.
     */
    public static Set<String> createSalesOrdersCollection(List<ServicePlan__c> servicePlans)
    {
    	SNG_ExceptionUtil.throwIfNullObject(servicePlans, 'servicePlans is set to NULL.');
    	Set<String> salesOrders = new Set<String>();
        for (ServicePlan__c servicePlan : servicePlans)
        {
        	if (null != servicePlan.SalesOrder__c)
               salesOrders.add(servicePlan.SalesOrder__c);
        }  
        return salesOrders;    	
    }

    /**
     * Creates a mapping of sales orders to service plan(s) that utilitize the sales order.
     * 
     * @param     servicePlan               The service plans to obtain the sales order for.
     * @return                              A mapping of sales order to service plans that utilize the sales order.
     * @throws    SNG_Exception             Thrown if the provided parameter input is null.
     */    
    public static Map<String, List<ServicePlan__c>> createSalesOrderToServicePlanCollection(List<ServicePlan__c> servicePlans)
    {
    	SNG_ExceptionUtil.throwIfNullObject(servicePlans, 'servicePlans is set to NULL.');
    	Map<String, List<ServicePlan__c>> salesOrderToServicePlan = new Map<String, List<ServicePlan__c>>();
    	
    	for (ServicePlan__c servicePlan: servicePlans)
    	{
    		if (null != servicePlan.SalesOrder__c)
    		{
    			addEntry(salesOrderToServicePlan, servicePlan);
    		}
    	}
    	
    	return salesOrderToServicePlan;
    }
    
    /**
     * Creates a mapping of service plan IDs to a list of active Modem / Service Plan(s).
     * 
     * @param     servicePlan               The service plans to obtain the active Modem / Service Plan(s) for.
     * @return                              A mapping of service plan id to active Modem / Service Plan(s).
     * @throws    SNG_Exception             Thrown if the provided parameter input is null.
     */     
    public static Map<Id, List<ModemServicePlan__c>> createServicePlanToActiveModemServicePlans(Set<Id> servicePlanIds)
    {
    	SNG_ExceptionUtil.throwIfNullObject(servicePlanIds, 'servicePlanIds is set to NULL.');
        List<ModemServicePlan__c> msps = [SELECT Id, Name, ServicePlan__c FROM ModemServicePlan__c 
                                                                          WHERE ServicePlan__c IN :servicePlanIds AND Status__c = :STATUS_ACTIVE];
        
        Map<Id, List<ModemServicePlan__c>> spActiveMsps =  new Map<Id, List<ModemServicePlan__c>>();
        
        for (ModemServicePlan__c msp : msps)
        {
        	addEntry(spActiveMsps, msp);
        }
        
        return spActiveMsps;        
    }

    /**
     * Adds an entry to the provided collection. 
     *
     * @param     salesOrderToServicePlan   A mapping between the sales order to the service plan object.
     * @param     SNG_Exception             Thrown if either parameter is set to null.   
     */
    public static void addEntry(Map<String, List<ServicePlan__c>> salesOrderToServicePlan, ServicePlan__c servicePlan)
    {
        SNG_ExceptionUtil.throwIfNullObject(salesOrderToServicePlan, 'salesOrderToServicePlan is set to NULL.');
        SNG_ExceptionUtil.throwIfNullObject(servicePlan, 'servicePlan is set to NULL.');

        if (salesOrderToServicePlan.containsKey(servicePlan.SalesOrder__c))
        {
            salesOrderToServicePlan.get(servicePlan.SalesOrder__c).add(servicePlan);
        }
        else
        {
            salesOrderToServicePlan.put(servicePlan.SalesOrder__c, new List<ServicePlan__c>{servicePlan});
        }
    } 

    /**
     * Adds an entry to the provided collection. 
     *
     * @param     spActiveMsps              A mapping between the service plan ID to Modem / Service Plan(s) that
     *                                      use the service plan.
     * @param     SNG_Exception             Thrown if either parameter is set to null.   
     */    
    private static void addEntry(Map<Id, List<ModemServicePlan__c>> spActiveMsps, ModemServicePlan__c msp)
    {
        SNG_ExceptionUtil.throwIfNullObject(spActiveMsps, 'spActiveMsps is set to NULL.');
        SNG_ExceptionUtil.throwIfNullObject(msp, 'msp is set to NULL.');

	    if (spActiveMsps.containsKey(msp.ServicePlan__c))
        {
            spActiveMsps.get(msp.ServicePlan__c).add(msp);
        }
        else
        {
            List<ModemServicePlan__c> activeMsps = new List<ModemServicePlan__c>();
            activeMsps.add(msp);
            spActiveMsps.put(msp.ServicePlan__c, activeMsps);
        }
    }
}