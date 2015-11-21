/*********************************************************************************
Name         : AtlasPlanDetailsDTO 
Created By   : RahulKumar Sharma
Modified BY  : RahulKumar Sharma
Company Name : NTT Data
Project      : ViaSat Atlas, Bangalore
Created Date : 29 October 2013
Modified Date: 13 November 2013
Usages       : used in the AtlasUsagePlanDetails Component
*********************************************************************************/

global with sharing class AtlasPlanDetailsDTO extends AtlasParentDTO{
    
    
     /**
    * Holds the Limit Information. 
    */
      global string exedeLimit{get;set;}
    /**
     * Holds the Time From Information. 
     */
    global string timeFrom{get;set;}
    /**
     * Holds the total Data Information. 
     */   
    global string planDescription{get;set;}    
    /**
     * Holds 'true' value for unlimited plans. 
     */
    public boolean isUnlimitedPlan{get;set;}
    /**
     * Holds the total Data Information. 
     */
    global string totalData{get;set;}
    /**
     * Holds the time to Information. 
     */
    global string timeTo{get;set;}
    
    /**
     * Holds the time to Information. 
     */
    global string timeToTimeFromStr { 
        get {
            String notNullTimeFrom = timeFrom == null ? '' : timefrom;
            String notNullTimeTo = timeTo == null ? '' : timeTo;
            if(!AtlasUtility.isEmpty(timefrom) && !AtlasUtility.isEmpty(timeTo))
                return 'Unmetered usage: ' + notNullTimeFrom + ' - ' + notNullTimeTo;
            else
                return null;
        }
        set; 
    } 

}