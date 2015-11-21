global class  AtlasPurgeUserLockoutScheduler implements Schedulable{
    
    global void execute (SchedulableContext SC) {
        purgeUserLockoutRecords();
    }
    
    public void purgeUserLockoutRecords()
    {
        Datetime d = Datetime.now();
        //default value--1
        integer value=1;
        //to get value from custom setting
        string strValue=AtlasUtility.getMapValue(Atlasconstants.PURGE_USER_LOCK_OUTS);
        //if the value from custom setting is not null
        if(!AtlasUtility.isEmpty(strValue))
            value=integer.valueOf(value);
        //if the value from custom setting is null, assign defalut value(1) 
        d = d.addDays(-value);
        //to run query
            
        Atlas_User_Lock_Out__c [] userLockoutArray =   [select id from Atlas_User_Lock_Out__c where CreatedDate <: d Limit 10000];
        delete userLockoutArray;
        
    }

}