global class  AtlasPurgeNewUserRegistrationHistories implements Schedulable{
    
    global void execute (SchedulableContext SC) {
        purgeNewUserRegistrationHistories();
    }
    
    public void purgeNewUserRegistrationHistories()
    {
        Datetime d = Datetime.now();
        //default value--14
        integer value=14;
        //to get value from custom setting
        string strValue=AtlasUtility.getMapValue(Atlasconstants.PURGE_USER_REGISTRATION_HISTORY);
        //if the value from custom setting is not null
        if(!AtlasUtility.isEmpty(strValue))
            value=integer.valueOf(value);
        //if the value from custom setting is null, assign defalut value(1) 
        d = d.addDays(-value);
        //to run query
        
        New_User_Registration_History__c [] newUserRegHstoryArray =   [select id from New_User_Registration_History__c where CreatedDate <: d Limit 10000];
        delete newUserRegHstoryArray;
        
    }

}