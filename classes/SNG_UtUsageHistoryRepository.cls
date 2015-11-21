/**
 * This class calculates and stores the data, acting as a repository fo the usage history information.
 */
public with sharing class SNG_UtUsageHistoryRepository 
{
    /**
     * FL byte count array for use by Visualforce graph
     */
    public List<Decimal[]> downloadByteCountArr { get; private set;}
    
    /**
     * RL byte count array for use by Visualforce graph
     */
    public List<Decimal[]> uploadByteCountArr { get; private set;}   
    
    /**
     * Latest sample of download byte count (unit is specified through byte count unit)
     */
    public Decimal latestDownloadByteCount { get; private set; }              
    
    /**
     * Latest sample of RL byte count in MB
     */
    public Decimal latestUploadByteCount  { get; private set; }
    
    /**
     * String showing the bytes downloaded + units (for use by Visualforce)
     */
    public String bytesDownloadedStr { get { return getBytesString(latestDownloadByteCount); } }
        
    /**
     * String showing the bytes uploaded + units (for use by Visualforce)
     */
    public String bytesUploadedStr { get { return getBytesString(latestUploadByteCount); } }
        
    /**
     * Flag to keep track of data being valid or invalid. This flag is updated to true once
     * the process is completed and valid. The flag is reset per invocation to false initially.
     */
    public boolean validData { get; set; }
    
    /**
     * The byte count units for the data based on how usage data accumulated.
     */
    public String byteCountUnit { get { return (null == byteCountUnit) ? 'GB' : byteCountUnit; } private set; }
    
    /**
     * Data As Of. Timestamp of last update in milliseconds since midnight GMT January 1, 1970.
     */
    public Long dataAsOf { get; private set; }    

    /**
     * One gigabyte in bytes.
     */
    private static final long ONE_GIGABYTE_IN_BYTES = 1073741824;
    
    /**
     * One megabyte in bytes.
     */
    private static final long ONE_MEGABYTE_IN_BYTES = 1048576;
    
    /**
     * The granularity of data required for the usage history. Currently set at 30 minutes.
     */
    public static final Integer DATA_GRANULARITY_IN_MINUTES = 30;
    
    /**
     * Creates an instance of this object.
     */
    public SNG_UtUsageHistoryRepository()
    {
        downloadByteCountArr = new List<Decimal[]>();
        uploadByteCountArr = new List<Decimal[]>();     
        latestDownloadByteCount = null;
        latestUploadByteCount = null;
    }
    
    /**
     * Processes the response from usage service by storing the response data in the repository. The data is split into
     * multiple fields, allowing the Visualforce page to pick and choose the data to be displayed.
     *
     * @param   response                        The response from the Usage Service.
     * @param   requestTimestamp                The timestamp of the request.
     * @param   mspStartDate                    The Modem/Service Plan start date. Since multiple MSPS can be attached to the modem,
     *                                          this date should reflect the minimum date that was provided to the Usage Service when
     *                                          calculating usage data.
     * @param   mspEndDate                      The Modem/Service Plan start date. Since multiple MSPS can be attached to the modem,
     *                                          this date should reflect the maximum date that was provided to the Usage Service when
     *                                          calculating usage data.
     */ 
    public void processResponse(SNG_UsageService.Response response, DateTime requestTimestamp, Date mspStartDate, Date mspEndDate)
    {
        resetData();
   
        if ('success' == response.status) 
        {  
        	if (isDataPresent(response))
        	    updateData(response, requestTimestamp, mspStartDate, mspEndDate);	
        }
        else 
        {
            System.debug(LoggingLevel.ERROR, 'Received "status": "' + response.status + '" from web service.');
        }
    }

    public void processException()
    {
        downloadByteCountArr.clear();
        uploadByteCountArr.clear();   
        dataAsOf = null;
        validData = false;
        latestDownloadByteCount = 0;
        latestUploadByteCount = 0;
    }

    
    /**
     * Validates the data is present to populate the response with.
     *
     * @param     response              The Usage Service Web service response.
     * @return                          True if data exists; false otherwise.
     */
    private boolean isDataPresent(SNG_UsageService.Response response)
    {
    	return (!ArrayUtils.isEmpty(response.data));
    }
    
    /**
     * Updates the repository fields with data from the Usage Service Web service response. This function assumes that
     * data is valid (i.e. not null). The caller is responsible for checking data validity prior to invoking this function.
     *
     * @param   response                        The response from the Usage Service.
     * @param   requestTimestamp                The timestamp of the request.
     * @param   mspStartDate                    The Modem/Service Plan start date. Since multiple MSPS can be attached to the modem,
     *                                          this date should reflect the minimum date that was provided to the Usage Service when
     *                                          calculating usage data.
     * @param   mspEndDate                      The Modem/Service Plan start date. Since multiple MSPS can be attached to the modem,
     *                                          this date should reflect the maximum date that was provided to the Usage Service when
     *                                          calculating usage data.  
     */
    private void updateData(SNG_UsageService.Response response, DateTime requestTimestamp, Date mspStartDate, Date mspEndDate)
    {
	    boolean processDataSample = true;

        long lastDownload = 0, downloadFactor = 0;
        long lastUpload = 0, uploadFactor = 0;

        DateTime expectedTime = DateTime.newInstanceGmt(mspStartDate.year(), mspStartDate.month(), mspStartDate.day());
        DateTime expectedEndTime = calculateExpectedEndTime(mspEndDate); 

        decimal divideFactor = setUsageDataUnits(response);
        List<List<SNG_UsageService.UsageAndErrors>> uaesSorted = sortUsageAndErrors(response.data);
        
        for (List<SNG_UsageService.UsageAndErrors> uaes : uaesSorted)
        {
	        for (SNG_UsageService.UsageAndErrors dataSample : uaes) 
	        {
	        	fillInMissingEntries(expectedTime, dataSample.endTime, lastDownload/divideFactor, lastUpload/divideFactor);	        	
	            Long timeInMSec = dataSample.endTime.getTime();	            
	            downloadByteCountArr.add(new Decimal[] { timeInMSec,  (downloadFactor + dataSample.aggregateAcctInputOctets)/divideFactor });
	            uploadByteCountArr.add(new Decimal[] { timeInMSec, (uploadFactor + dataSample.aggregateAcctOutputOctets)/divideFactor });
	            lastDownload = downloadFactor + dataSample.aggregateAcctInputOctets;
	            lastUpload = uploadFactor + dataSample.aggregateAcctOutputOctets;
	            expectedTime = dataSample.endTime.addMinutes(DATA_GRANULARITY_IN_MINUTES);
	        }

	        downloadFactor = lastDownload;
	        uploadFactor = lastUpload;
        }

        updateFinalByteCounts(lastDownload/divideFactor, lastUpload/divideFactor);
        fillInMissingEntries(expectedTime, expectedEndTime, lastDownload/divideFactor, lastUpload/divideFactor);
        dataAsOf = requestTimestamp.getTime();
        validData = true;
    }
 
    /**
     * Sorts the usage and errors order to match the MSP order. This is done through using the start date as the ordering key.
     * Since no MSPs can overlap on dates, using the start order guarantees the ordering of the data.
     *
     * @param   uaes                            The response data from the Usage Service to sort.
     * @return                                  A list containing the usage and errors in sorted order.
     */
    private List<List<SNG_UsageService.UsageAndErrors>> sortUsageAndErrors(List<List<SNG_UsageService.UsageAndErrors>> uaes)
    {
    	Map<DateTime, List<SNG_UsageService.UsageAndErrors>> uaeCollection = 
    	                                               new Map<DateTime, List<SNG_UsageService.UsageAndErrors>>();
    	
    	for (List<SNG_UsageService.UsageAndErrors> uae  : uaes)
    	{
    		if (!ArrayUtils.isEmpty(uae))
    		{
    			uaeCollection.put(uae.get(0).startTime, uae);
    		}
    	}
    	
    	return convertMapToListInSortedOrder(uaeCollection);
    }
 
    /**
     * Converts the map into a list, preserving the order from the map.
     *
     * @param    uaeCollection                   The collection mapping between DateTime to the usage and errors bucket.
     * @return                                  A list containing the usage and errors in sorted order.
     */
    private List<List<SNG_UsageService.UsageAndErrors>> convertMaptoListInSortedOrder(Map<DateTime, List<SNG_UsageService.UsageAndErrors>> uaeCollection)
    {
        List<List<SNG_UsageService.UsageAndErrors>> retCollection = new List<List<SNG_UsageService.UsageAndErrors>>();
       
        // Note: according to Salesforce API, uaeCollection.values API returns a list in arbitrary order. Need to
        // retain the actual order here.
        for (DateTime key : uaeCollection.keySet())
        {
           retCollection.add(uaeCollection.get(key));  
        }
        
        return retCollection;
    }
 
    /**
     * Calculates the expected end time for the usage history. The expected end time for Usage Service needs to
     * be recalculated since UDM treats the endpoint as exclusive, while Salesforce treats as inclusive.
     *
     * @param   msps              The end date for the Modem/Service Plan.
     */
    private DateTime calculateExpectedEndTime(Date mspEndDate)
    {
    	DateTime retValue = DateTime.now();
       
    	if ( mspEndDate < SNG_DateUtils.todayGmt() )
    	{  
    		retValue = DateTime.newInstanceGmt(mspEndDate.year(), mspEndDate.month(), mspEndDate.day())
                               .addDays(1)
                               .addMinutes(DATA_GRANULARITY_IN_MINUTES);
    	}
    	
    	return retValue;
    }
 
    
    /**
     * Updates the final tally byte counts to individual fields which are
     * displayed to the user. The caller is expected to pass in the appropriate
     * value with the proper unit taken into account.
     *
     * @param     lastDownload      The last download count (no unit specified)
     * @param     lastUpload        The last upload count (no unit specified)
     */
    private void updateFinalByteCounts(decimal lastDownload, decimal lastUpload)
    {
        latestDownloadByteCount = lastDownload;
        latestUploadByteCount = lastUpload;
    }
    
    /**
     * Sets the usage data units based on the response. The granularity is dependent
     * on whether the usage data exceeds 1GB or not. If 1 GB is exceeded, the units
     * are expressed in terms of gigabytes, otherwise megabites.
     *
     * @param     response          The response from Usage Service to evaluate.
     * @return                      The divide factor required on the byte count to
     *                              convert to the appropriate units required.
     */
    private decimal setUsageDataUnits(SNG_UsageService.Response response)
    {
    	long maxValue = calculateMaxExpectedSize(response);
           
        // switch to GB units if exceeds 1 GB.
        byteCountUnit = (maxValue >= ONE_GIGABYTE_IN_BYTES) ? 'GB' : 'MB';       
        return calculateDivideFactorForGb(byteCountUnit);
    }
    
    /**
     * Calculates the maximum expected data size for the usage data. This determines
     * byte count unit that would be used when providing the historical data to the 
     * Visualforce page.
     *
     * @param    response               The response to evaluate.
     * @return                          The maximum usage data byte count.
     */
    private long calculateMaxExpectedSize(SNG_UsageService.Response response)
    {
        long downloadByteCount = 0;
        long uploadByteCount = 0;
    	
    	for (List<SNG_UsageService.UsageAndErrors> uaes : response.data)
    	{
    		if (!ArrayUtils.isEmpty(uaes))
    		{
    			SNG_UsageService.UsageAndErrors lastDataSample = uaes.get(uaes.size() - 1);
    			downloadByteCount += lastDataSample.aggregateAcctInputOctets;
    			uploadByteCount += lastDataSample.aggregateAcctOutputOctets;
    		}
    	}
    	
    	return Math.max(downloadByteCount, uploadByteCount);
    }
    
    /**
     * Calculates the divide factor required. The divide factor is dependent on the byte count
     * unit provided. 
     *
     * @param   byteCountUnitStr         The byte count unit string.
     * @return                           The divide factor. If the byte count unit string is not
     *                                   set to GB (case-sensitive), the code assumes megabite units.
     */
    private decimal calculateDivideFactorForGb(String byteCountUnitStr)
    {
        return ('GB' == byteCountUnitStr) ? ONE_GIGABYTE_IN_BYTES : ONE_MEGABYTE_IN_BYTES;
    }
    
     /**
     * This method is used to add data entries if data points are missing where expected.
     * This can happen if the poller misses and does not update the database at the expected
     * interval.
     *
     * @param   actualTime     The actual time for the usage data
     */
    private void fillInMissingEntries(DateTime expectedTime, 
                                      DateTime actualTime, 
                                      decimal downloadValue, 
                                      decimal uploadValue)
    {
        while (expectedTime < actualTime)
        {
        	 Long timeInMSec = expectedTime.getTime();               
             downloadByteCountArr.add(new Decimal[] { timeInMSec, downloadValue });
             uploadByteCountArr.add(new Decimal[] { timeInMSec, uploadValue });
             expectedTime = expectedTime.addMinutes(DATA_GRANULARITY_IN_MINUTES);
        }
    }
    
    /**
     * Resets the data fields in the repository as needed.
     */
    private void resetData()
    {
        downloadByteCountArr.clear();
        uploadByteCountArr.clear();   
        dataAsOf = null;
        validData = false;
        latestDownloadByteCount = 0;
        latestUploadByteCount = 0;
    }
    
    /**
     * Gets the bytes String for a given amount of bytes 
     * which can be in either MB or GB, depending on byteCountUnit.
     *
     * @param   bytes          Amount of bytes
     * @return                 String for given amount of bytes
     */
    private String getBytesString(Decimal bytes) 
    {   
        return (null != bytes) ? String.valueOf(bytes.setScale(2)) + ' ' + byteCountUnit : '';
    }   
}