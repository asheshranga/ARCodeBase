public with sharing class SNGBillingCycleUtil 
{
    public Date currentBillingCycleStartDate { get; private set; }
    
    public Date currentBillingCycleEndDate { get; private set; }
    
    public boolean previousBillingCycleValid { get; private set; }
    
    public Date previousBillingCycleStartDate { get; private set; }
    
    public Date previousBillingCycleEndDate { get; private set; }
    

    private Date currentDate;
    
    private Date previousDate;
    
    
    public SNGBillingCycleUtil(Terminal__c terminal)
    {
    	currentDate = SNG_DateUtils.todayGmt();
    	previousDate = currentDate.addMonths(-1);
    	calculateBillingCycle(terminal);
    }
    
     
    public SNGBillingCycleUtil(Date currentStartDate, Date currentEndDate) 
    { 
    	currentDate = SNG_DateUtils.todayGmt(); 
    	previousDate = currentDate.addMonths(-1); 
    	
    	currentBillingCycleStartDate = currentDate.toStartOfMonth(); 
    	currentBillingCycleEndDate = currentBillingCycleStartDate.addMonths(1).addDays(-1);
    	previousBillingCycleValid = false;
    }
    
    private void calculateBillingCycle(Terminal__c terminal)
    {
    	Date startOfCurrentMonth = currentDate.toStartOfMonth();
    	Date endOfCurrentMonth = startOfCurrentMonth.addMonths(1).addDays(-1);

        currentBillingCycleStartDate = startOfCurrentMonth;
        currentBillingCycleEndDate = endOfCurrentMonth;
        
        Date startOfPreviousMonth = startOfCurrentMonth.addMonths(-1);
        Date endOfPreviousMonth = startOfPreviousMonth.addMonths(1).addDays(-1);
        
        List<ModemServicePlan__c> msp = SNG_Terminal.getMspForTerminal(terminal, startOfPreviousMonth, endOfPreviousMonth);
                                                                 
        if (!ArrayUtils.isEmpty(msp))
        {
            previousBillingCycleStartDate = startOfPreviousMonth;
            previousBillingCycleEndDate = endOfPreviousMonth; 
            previousBillingCycleValid = true;       	
        }     
        else
        {
     	    previousBillingCycleValid = false;
        }                                                 
    }
      
    public boolean isCurrentMonth(DateTime startDate)
    {
    	return (currentDate.month() == startDate.monthGmt());
    }
    
    public boolean isCurrentYear(DateTime startDate) 
    { 
    	return (currentDate.year() == startDate.yearGmt()); 
    }
}