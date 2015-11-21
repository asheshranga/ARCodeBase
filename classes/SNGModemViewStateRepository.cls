/**
 * This class is used to cache usage and performance data that is mapped to a modem MAC address.
 */
public with sharing class SNGModemViewStateRepository 
{
    /**
     * This enum contains the possible RecordTypes for the ModemViewState__c object.
     * <br/>
     * NOTE: These must match the exact Strings in the RecordType names.
     */
    public enum EntryRecordTypeLabel { Performance, Usage }
    
    /**
     * Maps EntryRecordTypeLabel to the corresponding RecordTypeId
     */
    private static final transient Map<EntryRecordTypeLabel, Id> entryRecordTypeMap = new Map<EntryRecordTypeLabel, Id>(); 
    
    /**
     * Initializes entryRecordTypeMap
     */
    static 
    {
        for (EntryRecordTypeLabel label : EntryRecordTypeLabel.values()) 
        {
            RecordType recType = [SELECT Id FROM RecordType WHERE Name = :label.name()];
            entryRecordTypeMap.put(label, recType.Id);
        }
    }

    /**
     * Validates if cached usage data exists for the specified billing cycle
     *
     * @param   modemd      The modem ID.
     * @param   startDate   Billing cycle start date
     * @param   endDate     Billing cycle end date
     * @return              Whether or not a valid cached usage data exists.
     */
    public static boolean doesValidUsageCacheExist(Id modemId, 
                                                   Date startDate, 
                                                   Date endDate,
                                                   boolean currentBillingCycle,
                                                   boolean refresh)
    {
    	return doesValidCacheDataExist(modemId, 
    	                               EntryRecordTypeLabel.Usage, 
                                       startDate, 
                                       endDate,
                                       currentBillingCycle,
                                       refresh);
    }


    /**
     * Caches the specified terminal's usage for the specified billing cycle. The data
     * captured is mapped to a unique modem MAC address for a terminal.
     *
     * @param   modemId     The Id of the modem to cache data for
     * @param   timestamp   The timestamp of the data capture.
     * @param   usage       The JSON string containing usage to be cached
     * @param   startDate   The billing cycle start date
     * @param   endDate     The billing cycle end date
     */
    public static void cacheUsage(Id modemId, DateTime timestamp, String usage, Date startDate, Date endDate) 
    {
        cacheData(modemId, timestamp, getRecordTypeId(EntryRecordTypeLabel.Usage), usage, startDate, endDate);
    }
    
    /**
     * Caches the specified terminal's performance for the specified billing cycle. The data
     * captured is mapped to a unique modem MAC address for a terminal.
     *
     * @param   modemId     The Id of the modem to cache data for
     * @param   timestamp   The timestamp of the data capture.
     * @param   usage       The JSON string containing usage to be cached
     * @param   startDate   The billing cycle start date
     * @param   endDate     The billing cycle end date
     */
    public static void cachePerformance(Id modemId, DateTime timestamp, String performance, Date startDate, Date endDate) 
    {
        cacheData(modemId, timestamp, getRecordTypeId(EntryRecordTypeLabel.Performance), performance, startDate, endDate);
    }
    
    /**
     * Retrieves the cached usage data for the specified billing cycle
     *
     * @param   modemd      The modem ID.
     * @param   startDate   Billing cycle start date
     * @param   endDate     Billing cycle end date
     * @return              The cached usage data deserialized into a SNG_Perf.UtPhyUsageHistory object.
     *                      If no cached usage data for the specified cycle, returns null.
     */
    public static SNG_Perf.UtPhyUsageHistory getCachedUsage(Id modemId, 
                                                            Date startDate, 
                                                            Date endDate,
                                                            boolean currentBillingCycle,
                                                            boolean refresh) 
    {   
        String cachedUsage = getCachedData(modemId, 
                                           EntryRecordTypeLabel.Usage, 
                                           startDate, 
                                           endDate,
                                           currentBillingCycle,
                                           refresh);
                                           
        return (null != cachedUsage) ? (SNG_Perf.UtPhyUsageHistory)JSON.deserialize(cachedUsage, SNG_Perf.UtPhyUsageHistory.class) :
                                                null ;
    }
    
    /**
     * Retrieves the cached performance data for the specified billing cycle
     *
     * @param   modemId     The modem ID.
     * @param   startDate   Billing cycle start date
     * @param   endDate     Billing cycle end date
     * @return              The cached performance data deserialized into a SNG_Perf.UtPhyHistoryInternal object.
     *                      If no cached performance data for the specified cycle, returns null.
     */
    public static SNG_Perf.UtPhyHistoryInternal getCachedPerformance(Id modemId, 
                                                                     Date startDate, 
                                                                     Date endDate,
                                                                     boolean currentBillingCycle,
                                                                     boolean refresh) 
    {
        String cachedPerformance = getCachedData(modemId, 
                                                 EntryRecordTypeLabel.Performance, 
                                                 startDate, 
                                                 endDate,
                                                 currentBillingCycle,
                                                 refresh);
                                                 
        return (null != cachedPerformance) ? (SNG_Perf.UtPhyHistoryInternal)JSON.deserialize(cachedPerformance, SNG_Perf.UtPhyHistoryInternal.class) :
                                             null ;
    }
    
    /**
     * Compresses and caches data for the current RecordTypeId (Usage / Performance) and billing cycle
     *
     * @param   modemId        The modem ID.
     * @param   timestamp      The timestamp of the data capture. 
     * @param   recordTypeId   The RecordTypeId to use when caching data (Usage / Performance)
     * @param   dataStr        The data to cache before compression
     * @param   startDate      Billing cycle start date
     * @param   endDate        Billing cycle end date
     */    
    private static void cacheData(Id modemId, DateTime timestamp, Id recordTypeId, String dataStr, Date startDate, Date endDate)
    {            
        insertModemViewState(modemId, timestamp, recordTypeId, dataStr, startDate, endDate);
    }
    
    /**
     * Retrieves the ID associated to the enumeration in the database.
     *
     * @param  enumValue    The enumeration record type value to query
     * @return              The corresponding ID value to the enumeration.
     */
    public static Id getRecordTypeId(EntryRecordTypeLabel enumValue)
    {
        return entryRecordTypeMap.get(enumValue);
    }
    
    
    /**
     * Validates whether valid cache data exists for the specified by the 
     *   RecordTypeId (Usage / Performance) and billing cycle 
     *
     * @param   modemId         The modem ID.
     * @param   recordTypeId    The RecordType (Usage / Performance)
     * @param   startDate       Billing cycle start date
     * @param   endDate         Billing cycle end date
     * @return                  Whether or not a valid cache data exists.
     * @throws  SNG_Exception   If any exception other than QueryException is caught
     */
    private static boolean doesValidCacheDataExist(Id modemId, EntryRecordTypeLabel recordType, Date startDate, Date endDate, boolean currentBillingCycle, boolean refresh) 
    {
        boolean validCacheData = false;
        Id recordTypeId = getRecordTypeId(recordType);
        
        if (doesViewStateExist(modemId, recordTypeId, startDate, endDate))
        {
            ModemViewState__c viewState = getViewState(modemId, recordTypeId, startDate, endDate);
            validCacheData = !SNGModemViewStateExpiration.isCacheDataExpired(viewState.TimeStamp__c, 
                                                                            currentBillingCycle, 
                                                                            refresh,
                                                                            EntryRecordTypeLabel.Performance == recordType);
        }
        // no else needed.
        
        return validCacheData;
    }
        
    
    /**
     * Decompresses and returns the cached data specified by the RecordTypeId (Usage / Performance) and billing cycle
     *
     * @param   modemId         The modem ID.
     * @param   recordType      The RecordType (Usage / Performance)
     * @param   startDate       Billing cycle start date
     * @param   endDate         Billing cycle end date
     * @return                  The decompressed cached data.
     *                          If there was no corresponding data in the cache, this method returns null.
     * @throws  SNG_Exception   If any exception other than QueryException is caught
     */    
    private static String getCachedData(Id modemId, 
                                        EntryRecordTypeLabel recordType, 
                                        Date startDate, 
                                        Date endDate, 
                                        boolean currentBillingCycle, 
                                        boolean refresh) 
    {
        String cachedData = null;      
        /*  
        Id recordTypeId = getRecordTypeId(recordType);
                 
        if (doesViewStateExist(modemId, recordTypeId, startDate, endDate))
        {
            try
            {
                ModemViewState__c viewState = getViewState(modemId, recordTypeId, startDate, endDate);
                cachedData = SNGModemViewStateExpiration.isCacheDataExpired(viewState.TimeStamp__c, 
                                                                            currentBillingCycle, 
                                                                            refresh,
                                                                            EntryRecordTypeLabel.Performance == recordType
                                                                            ) ? null : LZW.decompress(viewState.Data__c);            
            }
            catch (Exception e)
            {
                // TODO change to use SNGSObjectErrorReporter
                //throw new SNG_Exception(e);
                System.debug(LoggingLevel.ERROR, 'Caught Exception in SNGModemViewStateRepository.getCachedData: ' + e.getMessage() 
                                                 + '\nStack Trace: ' + e.getStackTraceString() + '\n Returning null.');
                return null;
            }
        }
        else
        {
            System.debug(LoggingLevel.ERROR, 'No matching usage data cached for terminal with Id [' + modemId
                                             + '] and cycle dates [' + startDate + ' - ' + endDate + '].');             
        }
        */
        return cachedData;
    }
    
    /**
     * Verifies a table entry exists that matches the criteria specified in the parameters.
     *
     * @param   modemId                The modem ID.
     * @param   recordIdType           The RecordTypeId (Usage / Performance)
     * @param   startDate              Billing cycle start date
     * @param   endDate                Billing cycle end date
     * @return                         Whether not an entry exists.
     */    
    public static boolean doesViewStateExist(Id modemId, Id recordIdType, Date startDate, Date endDate)
    {
        return 0 < [SELECT COUNT() FROM ModemViewState__c
                                   WHERE Modem__c = :modemId 
                                   AND RecordTypeId = :recordIdType AND StartDate__c = :startDate AND EndDate__c = :endDate];
    }    

    /**
     * Retrieves a ModemViewState__c that matches the criteria specified in the parameters. 
     *
     * @param   modemId                The modem ID.
     * @param   recordIdType           The RecordTypeId (Usage / Performance)
     * @param   startDate              Billing cycle start date
     * @param   endDate                Billing cycle end date
     * @return                         Whether not an entry exists.
     */  
    public static ModemViewState__c getViewState(Id modemId, Id recordTypeId, Date startDate, Date endDate)
    {
    	ModemViewState__c[] queryResult = [SELECT Id, TimeStamp__c, Data__c FROM ModemViewState__c WHERE Modem__c = :modemId 
                                           AND RecordTypeId = :recordTypeId AND StartDate__c = :startDate AND EndDate__c = :endDate];
                                           
        ModemViewState__c result;
        
        if (!queryResult.isEmpty()) {
        	if (queryResult.size() == 1) {
	        	result = queryResult[0];
	        } else {
	        	// If there are duplicates, just use the latest one.
	        	DateTime latestTimeStamp = DateTime.newInstance(0);
	        	for (ModemViewState__c modemViewState : queryResult) {
	        		if (latestTimeStamp < modemViewState.TimeStamp__c) {
	        			latestTimeStamp = modemViewState.TimeStamp__c;
	        			result = modemViewState;
	        		}
	        	}
	        }
        }
        
        return result;
    }

    /**
     * Creates or updates the mkodem view state with new data, depending on if the
     * modem MAC address time period already exists in the table.
     *
     * @param   modemId                 The modem ID.
     * @param   timestamp               The timestamp of the data capture.     
     * @param   recordIdType            The RecordTypeId (Usage / Performance)
     * @param   dataStr                 The data to compress and store.
     * @param   startDate               Billing cycle start date
     * @param   endDate                 Billing cycle end date
     * @return                          Whether not an entry exists.
     */    
    private static void insertModemViewState(Id modemId, DateTime timestamp, Id recordTypeId, String dataStr, Date startDate, Date endDate)
    {   
        ModemViewState__c viewState = null;
        if (doesViewStateExist(modemId, recordTypeId, startDate, endDate))
        {
            viewState = getViewState(modemId, recordTypeId, startDate, endDate);   
            //viewState.Data__c = LZW.compress(dataStr);
            viewState.Data__c = null;
            viewState.Timestamp__c = timestamp;
        }
        else
        {
             viewState = new ModemViewState__c (Modem__c = modemId, 
                                                TimeStamp__c = timestamp,
                                                RecordTypeId = recordTypeId, 
                                                StartDate__c = startDate, 
                                                EndDate__c = endDate,
                                                //Data__c = LZW.compress(dataStr));  
                                                Data__c = null);
        }
        
        upsert viewState;     
    }
}