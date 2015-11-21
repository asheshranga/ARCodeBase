global class invokeApiTestController{

   String query = 'select id from account  limit 1';   
   
   public String requestLabel {get; set;}
   public String gsMsg;
   public String gsServiceName;
   public String gsRequest; 
   public boolean allServicesSuccess{get; set;}
   public boolean standardServicesSuccess;
   public boolean continServicesSuccess;
       
   List<Atlas_Webservice_Log__c> loLogEntries;
   
   public invokeApiTestController() {
       allServicesSuccess = false;  
       continServicesSuccess = false;
       standardServicesSuccess= false; 
   }
   
   public void invokeMethods() {
       boolean gbFoundErrors = false;      
       loLogEntries = new List<Atlas_Webservice_Log__c>();          
       invokeServiceStandardFramework('Test');     //--- Call Test Services 
       invokeServiceStandardFramework('Prod');      //--- Call Prod Services
       
       try {
          insert loLogEntries;
          standardServicesSuccess = true; 
          if(standardServicesSuccess && continServicesSuccess) 
              allServicesSuccess = true;    
              
       } catch (Exception e){
          system.debug('Unable to insert records - ' + e.getMessage());
       }        
   }
       
    
    private void invokeServiceStandardFramework(String asInstance) {
        String lsMsg = '';
        String lsServiceName;
        String lsRequest;
        
        lsRequest = ((asInstance != null) && asInstance.equalsIgnoreCase('PROD')) ? 'https://webservices.wildblue.net/PublicSearch/v2/services/PublicSearchService?wsdl' : 'https://webservices.test.wildblue.net/PublicSearch/v2/services/PublicSearchService?wsdl';
        try {
           lsMsg = 'Call API - ' + asInstance + ' - ';
           lsServiceName = 'Standard API - ' + asInstance;

           HTTPResponse res = HTTPRequestCallOut.invokeService(lsRequest,'GET',15000,null,null);               
           if (res !=null) {
              system.debug('Standard API - Status = ' + res.getStatusCode());   
              system.debug('Standard API - Body = ' + res.getBody());
              lsMsg = lsMsg + 'Successful - status = ' + res.getStatusCode();
           } else {
              system.debug('Standard API Response is null'); 
              lsMsg = lsMsg + 'Successful - response is null' ;                  
           }
               
           addLogEntry(lsServiceName,lsRequest,lsMsg);
           continServicesSuccess = true;
       } catch (Exception e) {
            lsMsg = lsMsg + 'Error - ' + e.getMessage();            
            addLogEntry(lsServiceName,lsRequest,lsMsg);
            continServicesSuccess = false;
       }
    }

    
    //--- Call Service using Continucation Framework Test
    public Object invokeServiceContinuationFrameworkTest () {   
        system.debug('---enter continuation---');         
        String lsMethod = 'GET';
        String asInstance = 'Test';
        gsMsg = 'Call Continuation API - ' + 'Test' + ' - ';
        gsServiceName = 'Continuation API - ' + 'Test' ;        
        gsRequest = 'https://webservices.test.wildblue.net/PublicSearch/v2/services/PublicSearchService?wsdl';
        
        //--- Create continuation with a timeout
        Continuation con = new Continuation(40);
    
        //--- Set callback method
        con.continuationMethod='processContinuationResponse';

        //--- Create HTTP Request that should be added to continuation     
        HttpRequest req = new HttpRequest();
                
        req.setMethod(lsMethod);        
        req.setEndpoint(gsRequest);
        
        //--- Add callout request to continuation  
        requestLabel = con.addHttpRequest(req);

        //--- Return the continuation              
        return con;  
    }
            
    //--- Callback method by continutation
    public Object processContinuationResponse() {  
        system.debug('---enter continuation callback method---');  
        loLogEntries = new List<Atlas_Webservice_Log__c>();    
        String lsReturn;
        Integer liStatusCode;
        try {                    
            lsReturn = 'Error getting the response';
            
            //--- Get the response by using the unique label
            HttpResponse res = Continuation.getResponse(requestLabel);
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
            //insert loLogEntries;
        } catch(Exception e) {
            System.debug('Error - ' + e.getMessage());
            gsMsg = gsMsg + 'Error - ' + e.getMessage();
            
            addLogEntry(gsServiceName,gsRequest,gsMsg,true);
            //insert loLogEntries;            
        } 
         insert loLogEntries;
        return null;     
    }  
    
    //--- Call Service using Continucation Framework Prod
    public Object invokeServiceContinuationFrameworkProd () {   
        system.debug('---enter continuation---');         
        String lsMethod = 'GET';
        String asInstance = 'Prod';
        gsMsg = 'Call Continuation API - ' + 'Prod' + ' - ';
        gsServiceName = 'Continuation API - ' + 'Prod' ;        
        gsRequest = 'https://webservices.wildblue.net/PublicSearch/v2/services/PublicSearchService?wsdl';
        
        //--- Create continuation with a timeout
        Continuation con = new Continuation(40);
    
        //--- Set callback method
        con.continuationMethod='processContinuationResponse';

        //--- Create HTTP Request that should be added to continuation     
        HttpRequest req = new HttpRequest();
                
        req.setMethod(lsMethod);        
        req.setEndpoint(gsRequest);
        
        //--- Add callout request to continuation  
        requestLabel = con.addHttpRequest(req);

        //--- Return the continuation              
        return con;  
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