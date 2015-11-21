global class  AtlasPurgeViewStateScheduler implements Schedulable{
    
    global void execute (SchedulableContext SC) {
        purgeViewStates();
    }
    
    public void purgeViewStates()
    {
        Datetime dt =(System.now() - (1/24.0));
            AtlasViewState__c [] viewStateArray =   [select id from AtlasViewState__c where lastModifiedDate <:dt limit 10000 ];
            delete viewStateArray;
        
    }

}