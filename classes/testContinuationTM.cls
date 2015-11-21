public with sharing class testContinuationTM {
    
   String query = 'select id from account  limit 1';   
   
   public String requestLabel {get; set;}
   public String gsMsg;
   public String gsServiceName;
   public String gsRequest; 
   
   private String returnedContinuationId;
    
   List<Atlas_Webservice_Log__c> loLogEntries;
   
    public Object invokeMethods() {
       boolean gbFoundErrors = false;      
       loLogEntries = new List<Atlas_Webservice_Log__c>();          
       //invokeServiceStandardFramework('Test');     //--- Call Test Services 
       //invokeServiceStandardFramework('Prod');      //--- Call Prod Services
       //invokeServiceContinuationFramework('Test');  //--- Call Continuation Test Services
       //--- Call Continuation Prod Services
       //invokeServiceContinuationFramework('Prod');
       
       //--- commit the log entries
       try {
          insert loLogEntries;
       } catch (Exception e){
          system.debug('Unable to insert records - ' + e.getMessage());
       } 
       return null;       
    }
  
  
    //--- Call Service using Continucation Framework
    public Object invokeServiceContinuationFramework() {   
        system.debug('---enter continuation---');       
        String lsMethod = 'GET';

        gsMsg = 'Call Continuation API - Test ' + ' - ';
        gsServiceName = 'Continuation API - Test ';        
        gsRequest = 'https://webservices.test.wildblue.net/PublicSearch/v2/services/PublicSearchService?wsdl';
        
       

        //--- Create HTTP Request that should be added to continuation     
        HttpRequest req = new HttpRequest();               
        req.setMethod('GET');        
        req.setEndpoint(gsRequest);
        
      //--- Create continuation with a timeout
        Continuation con = new Continuation(60);
        returnedContinuationId  = con.addHttpRequest(req);
        //--- Set callback method
        con.continuationMethod='processContinuationResponse';
      
        //addLogEntry(gsServiceName,gsRequest,gsMsg);
        //--- Return the continuation              
        return con;  
    }
    
    
    //--- Callback method by continutation
    public Object processContinuationResponse() {  
        system.debug('---enter continuation callback method---');    
        String lsReturn;
        Integer liStatusCode;
        try {                    
            lsReturn = 'Error getting the response';
            
            //--- Get the response by using the unique label
            HttpResponse res = Continuation.getResponse(returnedContinuationId);
            system.debug('---res---' + res);   
            system.debug('---res.getStatusCode()---' + res.getStatusCode());    
            liStatusCode = res.getStatusCode();           
            if (liStatusCode >= 2000) {  
                gsMsg = gsMsg + 'Continuation error: '+ liStatusCode;               
            }  else {           
                lsReturn = res.getBody();   
                system.debug('---lsReturn ---'+ lsReturn);        
                if ((lsReturn == null) || (lsReturn.equals(''))) {
                    system.debug('Continuous API Response is null'); 
                    gsMsg = gsMsg + 'Successful - response is null' ;                                    
                } else {
                    system.debug('Continuous API - Status = ' + liStatusCode);   
                    system.debug('Continuous API - Body = ' + lsReturn);
                    gsMsg = gsMsg + 'Successful - status = ' + liStatusCode;
                }                             
            }
            
            addLogEntry(gsServiceName,gsRequest,gsMsg,true);
            return null;
        } catch(Exception e) {
            System.debug('Error - ' + e.getMessage());
            gsMsg = gsMsg + 'Error - ' + e.getMessage();
            
            addLogEntry(gsServiceName,gsRequest,gsMsg,true);
            insert loLogEntries;
            return null;
        }       
    }  

    private void addLogEntry(String asServiceName, String asRequest, String asMsg) {
        addLogEntry(asServiceName, asRequest, asMsg,false);
    }
    
    private void addLogEntry(String asServiceName, String asRequest, String asMsg, boolean insertData) {
       try {
           Atlas_Webservice_Log__c loServiceLog = new Atlas_Webservice_Log__c();
       
           loServiceLog.Webservice_Name__c = asServiceName;
           loServiceLog.Request__c = asRequest;
           loServiceLog.Error_Message__c = asMsg;
           
           if (insertData)
               insert loServiceLog;           
           else
               loLogEntries.add(loServiceLog);           
           //insert loServiceLog;           
       } catch (Exception e) {
          //--- Nothing
       }
    }

}