/**
 * This class contains helper functions to determine whether a modem has an active service plan.
 */
public with sharing class SNG_ModemServicePlan {
    
    /**
     * The Modem Service Plan Active status.
     */
    public static final transient String MSP_STATUS_ACTIVE = 'Active';  
    
    /**
     * Verifies if the modem has an active service plan. Modems can be associated with multiple service plans with
     * only one service plan active at one time. 
     *
     * @param   modem          The modem object to be validated.
     * @return                 Whether the modem is associated with an active service plan or not.
     */
    public static boolean doesModemHaveActiveServicePlan(Modem__c modem) 
    {
        return [SELECT Count() FROM ModemServicePlan__c WHERE Modem__c = :modem.Id AND Status__c = :MSP_STATUS_ACTIVE] > 0;
    }

   	
   	/**
     * Update the usage data fields of the Service Plans and msps
     *
     * @param   servicePlans    Service Plan objects to update
     * @param   msps            Modem/Service Plan objects to update
     *  
     */
   	public static void updateUsageData(ServicePlan__c[] servicePlans, ModemServicePlan__c[] msps) {
        final SNG_SpUsageAggregate spUsageAggregate = createUsageAggregateObject(servicePlans, msps);
        spUsageAggregate.process();
   	}
   	
   	/**
   	 * Checks if the provided ModemServicePlan is/was active on the provided date
   	 *
   	 * @param   msp         ModemServicePlan to check status on date for
   	 * @param   dateToCheck Date to check for status of the ModemServicePlan on
   	 * @return              True if ModemServicePlan was active on the given date, else false
   	 */
   	public static boolean isMspActiveOnDate(final ModemServicePlan__c msp, final Date dateToCheck) {
   	    return (msp.StartDate__c <= dateToCheck && msp.EndDate__c >= dateToCheck);
   	}
   	
    /**
     * Retrieves all MSPs that are associated with the Modem IDs
     * 
     * @param modemIdsToQuery   List of modem IDs
     * @return                  The Modem/Service Plans that are associated with the Modem IDs
     */
    public static List<ModemServicePlan__c> retrieveMspsAssocicatedWithModems(List<Id> modemIdsToQuery) 
    {
      // Query for MSPs that have the same modems as the to-be-inserted MSPs
      List<ModemServicePlan__c> msps = [SELECT Id, Name, Modem__c, EndDate__c, StartDate__c, ServicePlan__c FROM ModemServicePlan__c 
                              WHERE Modem__c IN :modemIdsToQuery];  

      return msps;
    }

    /**
     * Retrieves all MSPs that are associated with the Modem IDs and sort the results by start date
     *
     * @param modemIdsToQuery   List of modem IDs
     * @return                  The Modem/Service Plans that are associated with the Modem IDs sorted by start date
     */
    public static List<ModemServicePlan__c> retrieveMspsOrderedByStartDate(List<Id> modemIdsToQuery)
    {
      // Query for MSPs that have the same modems as the to-be-inserted MSPs, sort the results by StartDate__c
      List<ModemServicePlan__c> msps = [SELECT Id, Name, Modem__c, EndDate__c, StartDate__c, ServicePlan__c,
                                        Modem__r.Name, ServicePlan__r.Name FROM ModemServicePlan__c 
                                        WHERE Modem__c IN :modemIdsToQuery ORDER BY StartDate__c ASC];  

      return msps;
    }


    /**
     * Creates a Map of Modem IDs to a list of Modem/Service Plans that are associated with the Modem ID.
     *
     * @param msps  List of Modem/Service Plans
     * @return      Map of Modem IDs to list of Modem/Service Plans
     */
    public static Map<Id, List<ModemServicePlan__c>> buildMapOfMspsWithSameModems(List<ModemServicePlan__c> msps)
    {
      Map<Id, List<ModemServicePlan__c>> mspsWithSameModemMap = new Map<Id, List<ModemServicePlan__c>>();
      
      for (ModemServicePlan__c msp : msps)
      {
        // If there is no entry for the Modem, create a new one
        List<ModemServicePlan__c> sameModemList = (mspsWithSameModemMap.containsKey(msp.Modem__c)) 
                                                  ? mspsWithSameModemMap.get(msp.Modem__c) : new List<ModemServicePlan__c>();
        
        sameModemList.add(msp);
        mspsWithSameModemMap.put(msp.Modem__c, sameModemList);
      }
      
      return mspsWithSameModemMap;
    }


    /**
     * Auto-completes the end date for the Modem / Service Plan if the end date is not filled in by the user.
     * The date used is either the end-date of the MSP's Service Plan or the start-date of the next 
     * closest Modem/Service Plan that occurs after the MSP's start-date, whichever occurs first. 
     *
     * @param   msps                  The list of Modem/Service Plan objects to be stored in database.
     * @param   idToServicePlanMap    Map of service plan ids to corresponding service plans
     * @param   mspsSortedStartDate   List of Modem/Service Plans with same modem as msp, sorted by start date. 
     */
    public static void autoCompleteEndDateIfEmpty(ModemServicePlan__c msp, 
                                                  Map<Id,SObject> idToServicePlanMap, 
                                                  List<ModemServicePlan__c> mspsSortedStartDate)
    {
        if (msp.EndDate__c == null)
        { 
          ModemServicePlan__c nextMsp = getClosestMsp(msp, mspsSortedStartDate);
          ServicePlan__c servicePlan = (ServicePlan__c) idToServicePlanMap.get(msp.ServicePlan__c); 
          
          msp.EndDate__c = (nextMsp != null && servicePlan.EndDate__c >= nextMsp.StartDate__c) 
                          ? nextMsp.StartDate__c.addDays(-1) : servicePlan.EndDate__c;
        }
    }

	/**
	 * Finds the MSP with the same modem and the closest start date after the to-be-evaluated MSP's start date 
	 * 
	 * @param	msp 		The Modem/Service Plan that is to be evaluated 
	 * @param	mspList		Sorted list of Modem/Service Plans that contains MSPs with modems matching all to-be-inserted MSPs sorted by StartDate__c.
	 * @return				Returns the next MSP, if no next MSP found, returns null
	 */
	private static ModemServicePlan__c getClosestMsp(ModemServicePlan__c modemServicePlan, List<ModemServicePlan__c> mspList)
	{
		for (ModemServicePlan__c msp : mspList)
		{ 
			if (msp.Modem__c == modemServicePlan.Modem__c && msp.StartDate__c > modemServicePlan.StartDate__c)
			{
				return msp;
			}
		}
		
		return null;
	}
	
   	/**
   	 * Creates the SNG_SpUsageAggregate object to use for querying usage for the current month
   	 *
   	 * @param   servicePlans    List of Service Plans to get usage for
   	 * @param   msps            List of Modem Service Plans to get usage for
   	 * @return                  Constructed SNG_SpUsageAggregate object
   	 */
   	private static SNG_SpUsageAggregate createUsageAggregateObject(ServicePlan__c[] servicePlans, ModemServicePlan__c[] msps) {
        final Date beginningOfCurrentMonth = SNG_DateUtils.todayGmt().toStartOfMonth();
        SNG_SpUsageAggregate usageAggregate = new SNG_SpUsageAggregate(servicePlans, 
                                                                       msps, 
                                                                       beginningOfCurrentMonth, 
                                                                       beginningOfCurrentMonth.addMonths(1),
                                                                       true);

        return usageAggregate;
    } 
}