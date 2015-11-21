/**
 * This class is used to generate the subscriber availability array. The class
 * is used in conjunction with the SNGUtUsageHistory class, which supplies each
 * usage data point to construct the graph.
 */
public with sharing class SNGSubscriberAvailability {

    /**
     * The polling interval rate for the database.
     */
    private static final transient long DB_POLLING_INTERVAL = 900; //15 minutes * 60 seconds
    
    /**
     * The data point specified to indicate no data. The Visualforce graph minimum
     * value is set to 0 (puts the data out of range to be tracked for data points)
     */
    private static final transient Decimal NO_DATA = -1;

    /**
     * Flag to indicate whether it is the first iteration of the availability calculation
     * or not.
     */
    private transient boolean firstTime;
    
    /**
     * The expected time stamp of the data. The timestamps for the data usage are at exactly
     * 0, 15, 45 minutes past the hour.
     */
    private transient long expectedTimeStamp;
    
    
    /**
     * The last usage data sample.
     */
    private transient decimal lastUsageDataSampleValue;

    /**
     * This constructor is used to create an instance of the object. The constructor initializes
     * the necessary data prior to invoking methods.
     */
    public SNGSubscriberAvailability()
    {
    	utOnlineArr = new List<Decimal[]>();
    	utNoDataArr = new List<Decimal[]>();
    	utRebootArr = new List<Decimal[]>();
    	firstTime = true;
    	expectedTimeStamp = null;
    }
    
    /**
     * The first day of the selected billing cycle
     */
    public transient Date billingCycleStartDate { get; set; }
    
    /**
     * UT Online array for use by Visualforce graph
     */
    public transient List<Decimal[]> utOnlineArr { get; private set; }
    
    /**
     * UT Online array for use by Visualforce graph
     */
    public transient List<Decimal[]> utNoDataArr { get; private set; }    
    
    /**
     * UT reboot array for use by Visualforce graph
     */
    public transient List<Decimal[]> utRebootArr { get; private set; }
    
    /**
     * The primary function to update availability data. Each data sample point is passed
     * to this method, which updates the appropriate array with the data, based on whether
     * the data point is available at the appropriate intervals and whether the state of the UT
     * is online or rebooting.
     *
     * @param    dataSample     The usage data sample at a specific timestamp. The data passed
     *                          in should have the timestamps in ascending order.
     * @param    divideFactor   The number to normalize the data for the graph.
     * @throws   SNG_Exception  Thrown if the expectedTimeStamp has not been set.
     */
    public void updateAvailability(SNG_Perf.UtPhyUsageResult dataSample, decimal divideFactor)
    {	
    	SNG_ExceptionUtil.throwIfNullObject(expectedTimeStamp, 'The start date has not been seeded prior to updating availability');
    	
    	if (!firstTime)
    	{
    		expectedTimeStamp += (DB_POLLING_INTERVAL * 1000);
    		setAvailability(dataSample, divideFactor);	
    	}
    	else
    	{
    		setInitialAvailability(dataSample, divideFactor);
    		firstTime = false;
    	}
    }
    
    /**
     * This method is used to seed the start date. If the start data is not seeded prior to calling
     * updateAvailability, the updateAvailability function throws.
     *
     * @param    startDate      The start date for the usage data.
     */
    public void seedStartDate(Date startDate)
    {
        Time startOfDay = Time.newInstance(0, 15, 0, 0);
        DateTime expectedDateTime = DateTime.newInstance(startDate, startOfDay);
        expectedTimeStamp = expectedDateTime.getTime();
        firstTime = true;
    }

    /**
     * This method is used to set the availability after the initial availability value
     * has been set.The data sample state is considered when setting the data.
     *
     * @param    dataSample     The usage data sample at a specific timestamp. The data passed
     *                          in should have the timestamps in ascending order.
     * @param    divideFactor   The number to normalize the data for the graph. 
     */
    private void setAvailability(SNG_Perf.UtPhyUsageResult dataSample, decimal factor)
    {
        decimal maxValue = Math.max(dataSample.UTFLBYTECOUNT, dataSample.UTRLBYTECOUNT) / factor;

        System.debug('Sample time: ' + dataSample.UTTIME + ' ExpectedTimeStamp: ' + expectedTimeStamp);

        addNoDataEntriesIfMissing(dataSample.UTTIME, maxValue);
        
        long timeInMSec = dataSample.UTTIME * 1000;
          
        if (dataSample.UTTIME == expectedTimeStamp)
        {
            if (SNG_Perf.UTState.on_line == SNG_Perf.toUTState(dataSample.UTSTATE))
            {
                addEntry(utOnlineArr, timeInMSec, maxValue);
                addEntry(utRebootArr, timeInMSec, NO_DATA);
                addEntry(utNoDataArr, timeInMSec, NO_DATA);
                lastUsageDataSampleValue = maxValue;
            }
            else
            {
                addEntry(utRebootArr, timeInMSec, maxValue);
                addEntry(utOnlineArr, timeInMSec, NO_DATA);
                addEntry(utNoDataArr, timeInMSec, NO_DATA);
                lastUsageDataSampleValue = maxValue;
            }
        }
        else
        {
            //something darn goofed up here.
        }
    }

    /**
     * This method is used to set the initial availability. The data is dependent on the
     * expected time stamp matching the actual time stamp.
     *
     * @param    dataSample     The usage data sample at a specific timestamp. The data passed
     *                          in should have the timestamps in ascending order.
     * @param    divideFactor   The number to normalize the data for the graph. 
     */  
    private void setInitialAvailability(SNG_Perf.UtPhyUsageResult dataSample, decimal factor)
    {
    	clearArrays();
    	
        long timeInMSec = dataSample.UTTIME * 1000;
        
        decimal currentValue = Math.max(dataSample.UTFLBYTECOUNT, dataSample.UTRLBYTECOUNT) / factor;
        
        if (dataSample.UTTIME == expectedTimeStamp)
        {
            addEntry(utOnlineArr, timeInMSec, currentValue);
            addEntry(utNoDataArr, timeInMSec, NO_DATA);
            addEntry(utRebootArr, timeInMSec, NO_DATA);
            lastUsageDataSampleValue = currentValue;
        }
        else
        {
            addEntry(utRebootArr, timeInMSec, currentValue);
            addEntry(utOnlineArr, timeInMSec, NO_DATA);
            addEntry(utNoDataArr, timeInMSec, NO_DATA);
            lastUsageDataSampleValue = currentValue;
        }
    }
    
    /**
     * This function add an entry to the array list. The data point added is dependent on
     * the previous data point and the data point being added. Extra data points are added
     * to ensure the data points get properly filled in when plotted.
     *
     * @param   arrayList      The array list to add the data point to
     * @param   timeInMsec     The timestamp to add
     * @param   value          The value to add that is associated with the timestamp.
     */
    private void addEntry(List<Decimal[]> arrayList, long timeInMsec, decimal value)
    {
        if (!arrayList.isEmpty())
        {
            Decimal[] lastUsageData = arrayList.get(arrayList.size() - 1);
            
            if (NO_DATA != value)
            {
                if (NO_DATA == lastUsageData[1])
                {
                	// since transitioning from no data to valid data. Need
                	// to add an extra data point to show a straight vertical transition
                	// to the value (added 1 to ensure the graph is drawn correctly).
                    arrayList.add(new Decimal[] { timeInMsec, NO_DATA });
                    arrayList.add(new Decimal[] { timeInMsec + 1, value });
                }
                else
                {
                    arrayList.add(new Decimal[] { timeInMSec, value });
                }
            }
            else
            {
                if (NO_DATA != lastUsageData[1])
                {
                	// since transitioning from data to no data. Need
                    // to add an extra data point to show a straight vertical transition
                    // to the value (added 1 to ensure the graph is drawn correctly).
                    arrayList.add(new Decimal[] { timeInMsec, lastUsageData[1]});
                    arrayList.add(new Decimal[] { timeInMsec + 1, value });
                }
            }   
        }
        else
        {
            arrayList.add(new Decimal[] {timeInMsec, value});
        }
    }
    
    /**
     * This method is used to add data entries if data points are missing where expected.
     * This can happen if the poller misses and does not update the database at the expected
     * interval.
     *
     * @param   actualTime     The actual time for the usage data
     */
    private void addNoDataEntriesIfMissing(long actualTime, decimal actualValue)
    {
        long timeInMsec = 0;
        boolean firstTime = true;
        
        while (expectedTimeStamp < actualTime)
        {

            timeInMSec = expectedTimeStamp * 1000;
            addEntry(utNoDataArr, timeInMSec, lastUsageDataSampleValue);
            addEntry(utOnlineArr, timeInMSec, NO_DATA);
            addEntry(utRebootArr, timeInMsec, NO_DATA);
            expectedTimeStamp += DB_POLLING_INTERVAL * 1000; //convert to milliseconds
        }
        
        expectedTimeStamp = actualTime;
    }
    
    /**
     * This method clears out the 3 list properties in the class. It is to be called each time
     * availability is set, to prevent the view state from growing too large.
     */
    private void clearArrays() {
    	utOnlineArr.clear();
        utNoDataArr.clear();
        utRebootArr.clear();
    }

}