global class scheduledSNGAPICall implements Schedulable {
    global void execute(SchedulableContext SC) {
        try {
            BatchSNGAPI sngapi = new BatchSNGAPI ();
            ID batchprocessid = Database.executeBatch(sngapi);
            addLogEntry('Batch SNG API','Schedule','Success - ID = ' + batchprocessid);          
       } catch (Exception e) {
            addLogEntry('Batch SNG API','Schedule','Error - ' + e.getMessage());          
       }
    }
    
    private void addLogEntry(String asServiceName, String asRequest, String asMsg) {
       try {
           Atlas_Webservice_Log__c loServiceLog = new Atlas_Webservice_Log__c();
       
           loServiceLog.Webservice_Name__c = asServiceName;
           loServiceLog.Request__c = asRequest;
           loServiceLog.Error_Message__c = asMsg;
           
           insert loServiceLog;
       } catch (Exception e) {
          //--- Nothing
       }
    }    
}