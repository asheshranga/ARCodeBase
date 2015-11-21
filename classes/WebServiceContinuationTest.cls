public with sharing class  WebServiceContinuationTest {

    //--- Unique label corresponding to the continuation request and request status    
    public String requestLabel {get; set;}
    public Integer statusCode {get; set;}
                                                                                                                                    
    // Time stamps for performance
    public DateTime timestarted {get; set;}
    public DateTime timestopped {get; set;}
    public Long callDuration {get; set;}
    Public String timenow {get;set;}
    Public String getthetime() {
        return String.valueof(System.now());
    }
    
    //--- HTTPRequest variables and User Inputs
    Public String wsMethod { get {return (wsMethod == null) ? 'GET':wsMethod;} set;}
    Public String wsEndPoint { get; set;}
    Public String wsRequestMsg {get;set;}
    Public String wsReturn {get;set;}
           
    public WebServiceContinuationTest () {
        timenow = string.valueof(System.now());
    }
        
    
    //--- Call Service using Continucation Framework
    public Object invokeContinuationService () {            
    
        timestarted = System.now();          
        timestopped = null;
        callDuration = 0;
        
        //--- Create continuation with a timeout
        Continuation con = new Continuation(40);
    
        //--- Set callback method
        con.continuationMethod='processContinuationResponse';

        //--- Create HTTP Request that should be added to continuation     
        HttpRequest req = new HttpRequest();
                
        req.setMethod(wsMethod);        
        req.setEndpoint(wsEndPoint);
        
        if ((wsRequestMsg != null) && (!wsRequestMsg.trim().equals('')))
           req.setBody(wsRequestMsg);
        
        //--- Add callout request to continuation  
        requestLabel = con.addHttpRequest(req);
      
        //--- Return the continuation              
        return con;  
    }
    
    
    //--- Callback method by continutation
    public Object processContinuationResponse() {   
      try {
          
          timestopped = System.now();          
          callDuration = timestopped.getTime() - timestarted.getTime();
          
          wsReturn = 'Error getting the response';
          
          //--- Get the response by using the unique label
          HttpResponse res = Continuation.getResponse(requestLabel);
          
          statusCode = res.getStatusCode();           
          if (statusCode >= 2000) {  
              wsReturn = 'Continuation error: '+ statusCode; 
              return null;
          }  

          
          //--- Set the result variable that is displayed on the Visualforce page      
          wsReturn = res.getBody();
          
          if ((wsReturn == null) || (wsReturn.equals('')))
             wsReturn = 'Response is null or empty';
                              
          ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'Successfully executed the web service (' + wsEndPoint + '). Status=' + res.getStatus() + ' Status Code=' + res.getStatusCode()));
          return null;
       } catch(Exception e) {
            System.debug('Error Invoking the service' + e.getMessage());
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Ooops! Unable to invoke the service - ' + e.getMessage()));
            return null;
       }       
    }  
    
    //--- Call Service using Standard Framework
    public PageReference invokeService () {  
        
        timestarted = System.now();   
                
        HttpRequest req = new HttpRequest();
        
        req.setMethod(wsMethod);
        req.setEndpoint(wsEndPoint);
        req.setTimeout(40000);
                
        if ((wsRequestMsg != null) && (!wsRequestMsg.trim().equals('')))
           req.setBody(wsRequestMsg);
        
        Http http = new Http();
        try {
          //--- Execute web service call here    
          HTTPResponse res = http.send(req);   
          
          timestopped = System.now();
          callDuration = timestopped.getTime() - timestarted.getTime();
          
          //--- Get the response
          wsReturn = res.getBody();
          
          statusCode = res.getStatusCode();                    
          
          ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'Successfully executed the web service (' + wsEndPoint + '). Status=' + res.getStatus() + ' Status Code=' + res.getStatusCode()));
          
          return null;
       } catch(Exception e) {
            System.debug('Error Invoking the service' + e.getMessage());
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Ooops! Unable to invoke the service - ' + e.getMessage()));
            return null;
       }       
    }    
}