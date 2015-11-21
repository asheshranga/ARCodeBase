/*********************************************************************************
Name         : AtlasCurrentDataUsageDTO 
Created By   : Raghuprasad Halkere
Modified BY  : Gaurav Gathania
Company Name : NTT Data
Project      : ViaSat Atlas, Bangalore
Created Date : 28 October 2013
Modified Date : 13 November 2013
Usages       : DTO object for CurrentDataUsage Information
*********************************************************************************/
global with sharing class AtlasCurrentDataUsageDTO extends AtlasParentDTO{
    
    global boolean refreshNow{get;set;}
     
    /**
    * Holds value in bytes (convert to GB) to display for Plan details
    */
    global Long planThreshold{get;set;}
    
     /**
    * Holds value in bytes (convert to GB) to display for text below Total on the graph .
    */
    global String planThresholdConvertedText{get{
        if (threshold!=null){
          Decimal toround =double.valueOf(planThreshold)/1024/1024/1024;
          return  toround.setScale(1)+AtlasConstants.AMOUNT_USED_UNIT;            
        }  
        else
            return null;      
        }set;}
    
    /**
    * Holds value in bytes (convert to GB) to display for Total on the graph and text below it.
    */
    global Long threshold{get;set;}
    /**
    * Holds value in bytes (convert to GB) to display for Total on the graph .
    */
    global Double thresholdConvertedValue{get{
         if(threshold!=null)
            return (double.valueOf(threshold)/1024/1024/1024);             
         else
            return null;       
        }set;}
    /**
    * Holds value in bytes (convert to GB) to display for text below Total on the graph .
    */
    global String thresholdConvertedText{get{
        if (threshold!=null){
          Decimal toround =double.valueOf(threshold)/1024/1024/1024;
          
          //--- 07/01/2014 - Hanu
          //--- Don't display #.0, if the threshold is whole number
          //--- Examples:
          //---     10 GB and not 10.0 GB
          //---     10.3 GB
          return  (toround.setScale(0) <> toround.setScale(1)) ? toround.setScale(1)+AtlasConstants.AMOUNT_USED_UNIT:toround.setScale(0)+AtlasConstants.AMOUNT_USED_UNIT;            
        }  
        else
            return null;      
        }set;}
    
    /**
    * Holds value  in bytes (to be convert to GB) to display for GREEN dial on the graph and text below it (displayed as %).
    */
    global Long amountUsed{get;set;}
    
    
    /**
    * Holds value  in bytes (to be convert to GB) to display for GREEN dial on the graph (displayed as %).
    */
    global Double amountUsedValue{get{
            if(amountUsed != null)
            return (double.valueOf(amountUsed)/1024/1024/1024); 
            else
            return 0;       
        }set;}
    
    /**
    * Holds value in bytes (to be convert to GB) to display for text below GREEN dial on the graph .
    */
    global String amountUsedConvertedText{get{
            if(amountUsed!=null)
            { Decimal tempAmountUsed = amountUsedValue; return tempAmountUsed.setScale(1)+AtlasConstants.AMOUNT_USED_UNIT; }     
            else 
            return null;    
        }set;}
    
    
    /**
    * Holds the  The date the usage was last reset.
    */
    global DateTime usageCycleStartDate{get;set;}
    
    /**
    * Holds the  The date the usage was last reset.
    */
    global DateTime usageResetDate{get;set;}
    
    /**
    * Holds value  value in hours .
    */
    global Integer timePeriod{get;set;}
    
    /**
    * Holds value  value in hours .
    */
    global double timePeriodVal{get;set;}
    
    /**
    * Holds the  value in hours (convert to days) and substract from billing cycle (usageResetDate - usageCycleStartDate) to be displayed under Usage Graph
    Need to be converted as follows
            Example:
                266 = 266/24 = 11 days
                (11/01/2013 - 10/01/2013) - 11 = 20 days
                
                if(usageCycleStartDate!=null&&usageResetDate!=null&&timePeriodVal!=null)
            return String.valueOf(((usageCycleStartDate.date().daysBetween(usageResetDate.date()))-math.round(timePeriodVal/24)));
        
    */
    /*As Comment by David Rollingson [ 17/Jan/14 ] 
        This is what the business would like the meter to display:
        Is the expectation to see just the remaining days in the current billing cycle – which in that case will be:
        Days Remaining = usageResetDate – todays date
        For the above example, it will be:
        Days Remaining = 02/08/2014 – 01/15/2014 = 24 days
    */
     global String timePeriodDays{get{
             if(usageResetDate!=null){
                return String.valueOf(date.today().daysBetween(usageResetDate.date()));
             }  
            else 
            return null;    
        }set;}
    
    
    global integer dbPercentUsed{get{
            if(amountUsedValue!=null && thresholdConvertedValue!=null && thresholdConvertedValue!=0)
            {
                
                return integer.valueof((amountUsedValue/thresholdConvertedValue)*100);
                
            }
            else return 0;}set;}
            
    // Boolean variable to identify the unlimited plan
	global boolean isUnlimited{get;set;}   
   
    
}