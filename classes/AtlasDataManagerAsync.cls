/*********************************************************************************
Name  : AtlasDataManagerAsync 
Usages: Extention to the Controller for dashboardAsync and customerInfoAsync VisualForce Pages
        apex/dashboardAsync?Id=00519000000XH6XAAW
============================================================================
Dashboard Callouts order: Calls must be made in this order to simulate MyExede accurately   
    -   Continuation Group 1: call 1a and 1b sequentially
        1a (findSubscriberBySearchCriteria by AccountNumber) then 1b (getLegacyAccount by AccountNumber)
         
    -   Continuation Group 2: call 1c and 2a in parallel after Group 1 is finished
        1c (getAccountServiceAgreementsAndServices by LegacyAccount returned from getLegacyAccount)  
        2a (getBillingSummary                      by LegacyAccount returned from getLegacyAccount)

    -   Continuation Group 3: call 3a and 3c in parallel after Group 1 is finished
        3a (getSubscriberLedgerSummary  by external system name and external system reference from findSubscriberBySearchCriteria) 
      when 3a completes call 3b (getSubscriberPaymentHistory by external system name and external system reference from findSubscriberBySearchCriteria)
        3c (getCurrentUsageByAccount    by external system name and external system reference from findSubscriberBySearchCriteria)
      When 3c completes call 3d (getCurrentQuotaByAccount    by external system name and external system reference from findSubscriberBySearchCriteria)
============================================================================
*/

public virtual with sharing class AtlasDataManagerAsync extends AtlasDataManager
{
    // Project field for the ViasatLog
    private final String appName = 'Atlas';
    
    // Time vars to show the TOTAL performance
    public DateTime timestarted {get; set;}
    public Long callDuration {get; set;}
    
    // Continuation HTTP Request settings vars
    public static String wsEndPointDenver;  
    public static String wsEndPointDenverFin; 
    public static String wsEndPointDenverPub;  
    
    public static Map<String,AtlasWebserviceSetting__c> wsSettings=AtlasWebserviceSetting__c.getall();
    // Class to keep Continuation info:
    // Unique label corresponding to the continuation request, callBack, Time stamp for performance  
    public class continuationClass
    {
        String requestLabel{get;set;}
        String action{get;set;}
        String callBackMethod{get;set;}
        String wsEndPoint{get;set;}
        
        DateTime timeStarted{get;set;}
        Long duration{get{ return System.now().getTime() - this.timeStarted.getTime();}}
        public continuationClass(String sAction, String sMethod, String endPoint)
        {
            this.action=sAction;
            this.callBackMethod=sMethod;
            this.wsEndPoint = endPoint;
            this.timeStarted = System.now();
        }
    }     

    private Object setContinuation(continuationClass c, string wsRequestMsg) 
    {
        //--- Create continuation with a timeout & Set callback method
        Continuation con = new Continuation(AtlasIntegrationUtility.TIMEOUT_INT_SECS);
        con.continuationMethod=c.callBackMethod;

        //--- Create HTTP Request AND add it to continuation     
        HttpRequest req = new HttpRequest();                
        req.setMethod('POST');        
        req.setEndpoint(c.wsEndPoint);
        req.setHeader('Content-Type', 'text/xml; charset=utf-8');//req.setHeader('Content-Type', 'text/xml');   
        req.setHeader('SOAPAction', '');
        req.setBody(wsRequestMsg);      //req.setBodyDocument(doc);
        system.debug('@@@ Request --->'+wsRequestMsg);
        c.requestLabel = con.addHttpRequest(req);              

        system.debug('*** Continuation ' + c.action + ': ' + con);  
        return con; 
    }
    
    //============================================================================
    // Continuation Group 1: 
    // Call sequentially 1a(findSubscriberBySearchCriteria by AccountNumber) then 1b(getLegacyAccount by AccountNumber) 
    // Note: You cannot use more than 3 sequential continuation in a single request handling.
    //============================================================================

    // Action Method
    public continuationClass cont1a; 
    public Object invokeGetCustomerDetails() 
    {
        string wsRequestMsg;
        if (timestarted == null) timestarted = System.now();
        
        if(!Test.isRunningTest()) 
            wsEndPointDenver = AtlasUtility.getWebServiceHost(string.valueOF(AtlasUtility.randomNumberGenerator()))+AtlasIntegrationUtility.wsSettings.get(AtlasConstants.FIND_SUBSCRIBERV2).End_Point__c;
        else
            wsEndPointDenver='https://webservices.test.wildblue.net/PublicSearch/v2/services/PublicSearchService';
            
        cont1a = new continuationClass('findSubscribersBySearchCriteria', 'processFindSubscribersBySearchCriteriaResponse', wsEndPointDenver);

        // Populate mainDTOObj: Get data from AtlasViewState__c by UserInfo.getSessionID() OR by quering User record
        mainDTOObj = AtlasDatabaseManager.populateViewState(mainDTOObj);

        //--- Set Request message
        if(!Test.isRunningTest()) 
            wsRequestMsg = AtlasIntegrationServiceManager.findSubscribersBySearchCriteriaRequest(mainDTOObj);
        else
            wsRequestMsg = 'test';
                
        if (String.isEmpty(wsRequestMsg))
            return invokeGetLegacyAccount();

        return setContinuation(cont1a, wsRequestMsg);
    }
    
    // Callback method for invokeGetCustomerDetails
    public Object processFindSubscribersBySearchCriteriaResponse() 
    {   
        //--- Set durations
        callDuration = System.now().getTime() - timestarted.getTime();
        continuationClass c = cont1a;
        string wsReturn = c.action;//action1a;         
          
        try 
        {          
            //--- Get the response by using the unique label
            HttpResponse res = Continuation.getResponse(c.requestLabel);//requestLabel1a);          
            Integer statusCode = res.getStatusCode();     
            string body = res.getBody();       

            wsReturn += (' StatusCode:' + string.valueOf(statusCode) + ' Duration:' + c.duration + ' Total Run:' + string.valueOf(callDuration));
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, wsReturn));
            wsReturn += (body!=null && body!='' ? ' BODY: ' + body : ' NO BODY');   
system.debug('*** ' + wsReturn);
            if (statusCode > 200)
                throw new AtlasException.CalloutException(String.valueOf(statusCode),'Failed: '+ (res.getStatus() == null ? String.valueOf(statusCode):res.getStatus()));
            
            //--- Process Response
            mainDTOObj = AtlasIntegrationServiceManager.processSubscribersBySearchCriteriaResponseAsync(body, mainDTOObj);
        
            //--- If Request was successfully processed, then do 1b(getLegacyAccount by AccountNumber)
            return invokeGetLegacyAccount();
        } 
        catch(Exception e) 
        {
            ViasatLogHandler.Log(appName, ViasatLogHandler.SeverityTypeEXCEPTION, c.action, e.getMessage(), wsReturn);
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, c.action + ': ' + e.getMessage()));

            AtlasUtility.populateExceptionString(c.action, mainDTOObj
            , (e instanceOf AtlasException ? e : new AtlasException.CalloutException(AtlasUtility.getMapCode(AtlasConstants.SC_Callout_Exp), AtlasUtility.getMapValue(AtlasConstants.SC_Callout_Exp))));
            
            // END OF STEP 1 ACTION  - persist DTO objects if has changed
            persistViewState();
            return null;
        }              
    }  


    // Action method
    public continuationClass cont1b; 
    public Object invokeGetLegacyAccount() 
    {            
        string wsRequestMsg;
        if (timestarted == null) timestarted = System.now();
        
        if(!Test.isRunningTest()) 
            wsEndPointDenver = AtlasUtility.getWebServiceHost(string.valueOF(AtlasUtility.randomNumberGenerator()))+AtlasIntegrationUtility.wsSettings.get(AtlasConstants.FIND_SUBSCRIBERV2).End_Point__c;
        else
            wsEndPointDenver='https://webservices.test.wildblue.net/PublicSearch/v2/services/PublicSearchService';

        cont1b = new continuationClass('getLegacyAccount', 'processContinuationGetLegacyAccountResponse', wsEndPointDenver);
        
        //--- Set Request message
        if(!Test.isRunningTest()) 
            wsRequestMsg = AtlasIntegrationServiceManager.getLegacyAccountRequest(mainDTOObj);
        else
            wsRequestMsg ='test';
            
        if (String.isEmpty(wsRequestMsg))
            return null;

        return setContinuation(cont1b, wsRequestMsg);
    }

    // Callback method for invokeGetLegacyAccount
    public Object processContinuationGetLegacyAccountResponse() 
    {               
        //--- Set durations
        callDuration = System.now().getTime() - timestarted.getTime();
        continuationClass c = cont1b;
        string wsReturn = c.action;         
          
        try 
        {          
            //--- Get the response by using the unique label
            HttpResponse res = Continuation.getResponse(c.requestLabel);//1b);          
            Integer statusCode = res.getStatusCode();     
            string body = res.getBody();       

            wsReturn += (' StatusCode:' + string.valueOf(statusCode) + ' Duration:' + c.duration + ' Total Run:' + string.valueOf(callDuration));
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, wsReturn));
            wsReturn += (body!=null && body!='' ? ' BODY: ' + body : ' NO BODY');   
            if (statusCode > 200)
                throw new AtlasException.CalloutException(String.valueOf(statusCode),'Failed: '+ (res.getStatus() == null ? String.valueOf(statusCode):res.getStatus()));
            
            mainDTOObj = AtlasIntegrationServiceManager.processGetLegacyAccountResponseAsync(body, mainDTOObj);
            // To determine VOIP Accounts
            AtlasIntegrationServiceManager.getAccountServicesAtlas(mainDTOObj);
        } 
        catch(Exception e) 
        {
            ViasatLogHandler.Log(appName, ViasatLogHandler.SeverityTypeEXCEPTION, c.action, e.getMessage(), wsReturn);
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, c.action + ': ' + e.getMessage()));

            AtlasUtility.populateExceptionString(c.action, mainDTOObj
            , (e instanceOf AtlasException ? e : new AtlasException.CalloutException(AtlasUtility.getMapCode(AtlasConstants.SC_Callout_Exp), AtlasUtility.getMapValue(AtlasConstants.SC_Callout_Exp))));               
        }
        system.debug('*** ' + wsReturn);
        
        // END OF STEP 1 ACTION  - persist DTO objects if has changed
        persistViewState();
        return null;
    }  


    //============================================================================
    // Continuation Group 2: call 1c and 2a in parallel after Group 1 is finished
    //      1c (getAccountServiceAgreementsAndServices by LegacyAccount returned from getLegacyAccount)  
    //      2a (getBillingSummary                      by LegacyAccount returned from getLegacyAccount)
    //============================================================================

    // Action Method
    public continuationClass cont1c; 
    public AtlasAccInfoXmlschemaPublic.getAccountServiceAgreementsAndServicesResponseFuture accountServiceAgreementsAndServicesResponseFuture;  
    public Object invokeGetAccountServiceAgreementsAndServices() 
    {            
        cont1c = new continuationClass('getAccountServiceAgreementsAndServices', 'processGetAccountServiceAgreementsAndServicesResponse', null);//wsEndPointDenverAccount);
        continuationClass c = cont1c;
        if (timestarted == null) timestarted = System.now();

        mainDTOObj = AtlasDatabaseManager.getViewState(false, mainDTOObj);
        system.debug('*** ' + c.action + ' ' + mainDTOObj);
            
        // Check if got mainDTOObj.accountKey populated
        if(!Test.isRunningTest()) {
            if (AtlasUtility.isEmpty(mainDTOObj.accountKey))
                return null;         
        }
        
        //--- Create continuation with a timeout & Set callback method
        Continuation con = new Continuation(AtlasIntegrationUtility.TIMEOUT_INT_SECS);
        con.continuationMethod = c.callBackMethod;
        
        //--- Async SOAP Web service call using class created from wsdl:
        // Set continuation callback method, then invoke the begin* method by passing it the Continuation instance as first param     
        AtlasAccInfoWsdlPublicwebse.AccountInfoEndpoint asyncServiceSoap=new AtlasAccInfoWsdlPublicwebse.AccountInfoEndpoint();
        //Added endpoint and timeout
        asyncServiceSoap.endpoint_x=AtlasUtility.getWebServiceHost(string.valueOF(AtlasUtility.randomNumberGenerator()))+wsSettings.get(AtlasConstants.ACCOUNT_INFO).End_Point__c;
        asyncServiceSoap.timeout_x=AtlasConstants.TIMEOUT;
        accountServiceAgreementsAndServicesResponseFuture = asyncServiceSoap.beginGetAccountServiceAgreementsAndServices(con,mainDTOObj.accountKey);

        system.debug('*** Continuation ' + c.action + ': ' + con);  
        return con;  
        //throw new AtlasException.CalloutException(getExCode(AtlasConstants.SA_Callout_Exp),getExValue(AtlasConstants.SA_Callout_Exp));
    }

    // Callback method for invokeGetAccountServiceAgreementsAndServices
    public Object processGetAccountServiceAgreementsAndServicesResponse() 
    {               
        //--- Set this request & total durations
        continuationClass c = cont1c;
        callDuration = System.now().getTime() - timestarted.getTime();          
        string wsReturn = c.action;         

        mainDTOObj = AtlasDatabaseManager.getViewState(false, mainDTOObj);      
        try 
        {          
            Object body = accountServiceAgreementsAndServicesResponseFuture.getValue();         

            wsReturn += (' Duration:' + c.duration + ' Total Run:' + string.valueOf(callDuration));
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, wsReturn));
            wsReturn += (body!=null && body!='' ? ' BODY: ' + body : ' NO BODY');   
            
            mainDTOObj = AtlasIntegrationServiceManager.processGetAccountServiceAgreementsAndServicesResponseAsync(body, mainDTOObj);           
        } 
        catch(Exception e) 
        {
            ViasatLogHandler.Log(appName, ViasatLogHandler.SeverityTypeEXCEPTION, c.action, e.getMessage(), wsReturn);
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, c.action + ': ' + e.getMessage()));

            AtlasUtility.populateExceptionString(c.action, mainDTOObj
            , (e instanceOf AtlasException ? e : new AtlasException.CalloutException(AtlasUtility.getMapCode(AtlasConstants.SC_Callout_Exp), AtlasUtility.getMapValue(AtlasConstants.SC_Callout_Exp))));
        }                     
system.debug('*** ' + wsReturn);
        
        // Persist DTO objects if has changed
        persistViewState(); 
        return null;
    }  

    
    // Action method
    public continuationClass cont2a; 
    public AtlasAccInfoXmlschemaPublic.getBillingSummaryResponseFuture billingSummaryResponseFuture;  
    public Object invokeGetBillingSummary() 
    {            
        cont2a = new continuationClass('getBillingSummary', 'processContinuationGetBillingSummaryResponse', null);//wsEndPointDenverAccount);
        continuationClass c = cont2a;
        if (timestarted == null) timestarted = System.now();
        mainDTOObj = AtlasDatabaseManager.getViewState(false, mainDTOObj);
        system.debug('*** ' + c.action + ' ' + mainDTOObj);

        // Check if got mainDTOObj.accountKey populated
        if(!Test.isRunningTest()) {
            if (AtlasUtility.isEmpty(mainDTOObj.accountKey))
                return null;         
        }
        
        //--- Set endPoint & Request message, Create continuation with a timeout, set callback method
        Continuation con = new Continuation(AtlasIntegrationUtility.TIMEOUT_INT_SECS);
        con.continuationMethod = c.callBackMethod;
 
        //--- Async SOAP Web service call using class created from wsdl:
        // Set continuation callback method, then invoke the begin* method by passing it the Continuation instance as first param     
        AtlasAccInfoWsdlPublicwebse.AccountInfoEndpoint asyncServiceSoap=new AtlasAccInfoWsdlPublicwebse.AccountInfoEndpoint();
        asyncServiceSoap.endpoint_x=AtlasUtility.getWebServiceHost(string.valueOF(AtlasUtility.randomNumberGenerator()))+wsSettings.get(AtlasConstants.ACCOUNT_INFO).End_Point__c; 
        asyncServiceSoap.timeout_x=AtlasConstants.TIMEOUT;
        billingSummaryResponseFuture = asyncServiceSoap.beginGetBillingSummary(con,mainDTOObj.accountKey);

        system.debug('*** Continuation ' + c.action + ': ' + con);  
        return con;  
    }
    
    // Callback method for invokeGetBillingSummary
    public Object processContinuationGetBillingSummaryResponse()
    {   
        //--- Set durations
        continuationClass c = cont2a;
        callDuration = System.now().getTime() - timestarted.getTime();
        string wsReturn = c.action;         

        mainDTOObj = AtlasDatabaseManager.getViewState(false, mainDTOObj);
        try 
        {
            Object body = billingSummaryResponseFuture.getValue();          

            wsReturn += (' Duration:' + c.duration + ' Total Run:' + string.valueOf(callDuration));
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, wsReturn));
            wsReturn += (body!=null && body!='' ? ' BODY: ' + body : ' NO BODY');   
            
            mainDTOObj = AtlasIntegrationServiceManager.processGetBillingSummaryResponseAsync(body, mainDTOObj);            
        } 
        catch(Exception e) 
        {
            ViasatLogHandler.Log(appName, ViasatLogHandler.SeverityTypeEXCEPTION, c.action, e.getMessage(), wsReturn);
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, c.action + ': ' + e.getMessage()));

            if (AtlasUtility.isEmpty(mainDTOObj.accountDTOObj))
                mainDTOObj.accountDTOObj=new AtlasAccountDTO();      
            AtlasUtility.populateExceptionString(c.action, mainDTOObj.accountDTOObj
            , (e instanceOf AtlasException ? e : new AtlasException.CalloutException(AtlasUtility.getMapCode(AtlasConstants.SC_Callout_Exp), AtlasUtility.getMapValue(AtlasConstants.SC_Callout_Exp))));
        }               
        system.debug('*** ' + wsReturn);
        
        // Persist DTO objects if has changed
        persistViewState(); 
        return null;
    }


    //============================================================================
    // Continuation Group 3: call 3a and 3c in parallel after Group 1 is finished
    //      3a (getSubscriberLedgerSummary  by external system name and external system reference from findSubscriberBySearchCriteria) 
    //      when 3a completes call 3b (getSubscriberPaymentHistory by external system name and external system reference from findSubscriberBySearchCriteria)
    //      3c (getCurrentUsageByAccount    by external system name and external system reference from findSubscriberBySearchCriteria)
    //      When 3c completes call 3d (getCurrentQuotaByAccount    by external system name and external system reference from findSubscriberBySearchCriteria)
    //============================================================================
   
    // Action method
    public continuationClass cont3a; 
    public AtlasFinServiceXmlschemaFinanceService.getSubscriberLedgerSummaryResponse_elementFuture subscriberLedgerSummaryResponseFuture;  
    public Object invokeGetSubscriberLedgerSummary() 
    {            
        cont3a = new continuationClass('getSubscriberLedgerSummary', 'processContinuationGetSubscriberLedgerSummaryResponse', null); //wsEndPointDenverFin);
        continuationClass c = cont3a;
        if (timestarted == null) timestarted = System.now();
               
        mainDTOObj = AtlasDatabaseManager.getViewState(false, mainDTOObj);
        system.debug('*** ' + c.action + ' ' + mainDTOObj);
        if(!Test.isRunningTest()) {
            if (String.isEmpty(mainDTOObj.externalSystemName) || String.isEmpty(mainDTOObj.externalAccountReference))
                return null;
        }
        //--- Create continuation with a timeout, set callback method
        Continuation con = new Continuation(AtlasIntegrationUtility.TIMEOUT_INT_SECS);
        con.continuationMethod = c.callBackMethod;

        //--- Async SOAP Web service call using class created from wsdl:
        // Set continuation callback method, then invoke the begin* method by passing it the Continuation instance as first param     
        AtlasFinServiceWsdlV3FinanceService.FinanceServiceEndpoint asyncServiceSoap=new AtlasFinServiceWsdlV3FinanceService.FinanceServiceEndpoint();
        asyncServiceSoap.endpoint_x=AtlasUtility.getWebServiceHost(string.valueOF(AtlasUtility.randomNumberGenerator()))+wsSettings.get(AtlasConstants.FINANCE_SERVICE).End_Point__c; 
        asyncServiceSoap.timeout_x=AtlasConstants.TIMEOUT;
        subscriberLedgerSummaryResponseFuture = asyncServiceSoap.beginGetSubscriberLedgerSummary(con,mainDTOObj.externalSystemName,mainDTOObj.externalAccountReference);

        system.debug('*** Continuation ' + c.action + ': ' + con);  
        return con;  
//throw new AtlasException.CalloutException(getExCode(AtlasConstants.LS_Callout_Exp),getExValue(AtlasConstants.LS_Callout_Exp));
    }

    // Callback method for invokeGetSubscriberLedgerSummary
    public Object processContinuationGetSubscriberLedgerSummaryResponse() 
    {               
        continuationClass c = cont3a;

        //--- Set durations
        callDuration = System.now().getTime() - timestarted.getTime();
        string wsReturn = c.action;         

        mainDTOObj = AtlasDatabaseManager.getViewState(false, mainDTOObj);
        try 
        {          
            Object body = subscriberLedgerSummaryResponseFuture.getValue();         

            wsReturn += ('Duration:' + c.duration + ' Total Run:' + string.valueOf(callDuration));
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, wsReturn));
            wsReturn += (body!=null && body!='' ? ' BODY: ' + body : ' NO BODY');   
            
            mainDTOObj = AtlasIntegrationServiceManager.processGetSubscriberLedgerSummaryResponseAsync(body, mainDTOObj);           
        } 
        catch(Exception e) 
        {
            ViasatLogHandler.Log(appName, ViasatLogHandler.SeverityTypeEXCEPTION, c.action, e.getMessage(), wsReturn);
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, c.action + ': ' + e.getMessage()));

            AtlasUtility.populateExceptionString(c.action, mainDTOObj.billSnapShotDTOObj
            , (e instanceOf AtlasException ? e : new AtlasException.CalloutException(AtlasUtility.getMapCode(AtlasConstants.LS_Callout_Exp), AtlasUtility.getMapValue(AtlasConstants.LS_Callout_Exp))));
        }
system.debug('*** ' + wsReturn);
                      
        // Persist DTO objects if has changed
        persistViewState();
        return null;
    }  

    
    // Action method
    public continuationClass cont3b; 
    public AtlasFinServiceXmlschemaFinanceService.getSubscriberPaymentHistoryResponse_elementFuture subscriberPaymentHistoryResponseFuture;  
    public Object invokeGetSubscriberPaymentHistory() 
    {            
        cont3b = new continuationClass('getSubscriberPaymentHistory', 'processContinuationGetSubscriberPaymentHistoryResponse', null);//wsEndPointDenverFin);
        continuationClass c = cont3b;
        if (timestarted == null) timestarted = System.now();

        mainDTOObj = AtlasDatabaseManager.getViewState(false, mainDTOObj);
        system.debug('*** ' + c.action + ' ' + mainDTOObj);
        if(!Test.isRunningTest()) {
            if (String.isEmpty(mainDTOObj.externalSystemName) || String.isEmpty(mainDTOObj.externalAccountReference))
                return null;
        }
        //--- Create continuation with a timeout, set callback method
        Continuation con = new Continuation(AtlasIntegrationUtility.TIMEOUT_INT_SECS);
        con.continuationMethod = c.callBackMethod;
 
        //--- Async SOAP Web service call using class created from wsdl:
        // Set continuation callback method, then invoke the begin* method by passing it the Continuation instance as first param           
        AtlasFinServiceWsdlV3FinanceService.FinanceServiceEndpoint asyncServiceSoap=new AtlasFinServiceWsdlV3FinanceService.FinanceServiceEndpoint();
        asyncServiceSoap.endpoint_x=AtlasUtility.getWebServiceHost(string.valueOF(AtlasUtility.randomNumberGenerator()))+wsSettings.get(AtlasConstants.FINANCE_SERVICE).End_Point__c; 
        asyncServiceSoap.timeout_x=AtlasConstants.TIMEOUT;
        Integer maxRows = 1;
        subscriberPaymentHistoryResponseFuture = asyncServiceSoap.beginGetSubscriberPaymentHistory(con,mainDTOObj.externalSystemName,mainDTOObj.externalAccountReference,maxRows);

        system.debug('*** Continuation ' + c.action + ': ' + con);  
        return con;  
        //throw new AtlasException.CalloutException(getExCode(AtlasConstants.PH_Callout_Exp),getExValue(AtlasConstants.PH_Callout_Exp));
    }

    // Callback method for invokeGetSubscriberPaymentHistory
    public Object processContinuationGetSubscriberPaymentHistoryResponse() 
    {               
        continuationClass c = cont3b;

        //--- Set durations
        callDuration = System.now().getTime() - timestarted.getTime();
        string wsReturn = c.action;         

        mainDTOObj = AtlasDatabaseManager.getViewState(false, mainDTOObj);
        try 
        {          
            Object body = subscriberPaymentHistoryResponseFuture.getValue();            

            wsReturn += (' Duration:' + c.duration + ' Total Run:' + string.valueOf(callDuration));
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, wsReturn));
            wsReturn += (body!=null && body!='' ? ' BODY: ' + body : ' NO BODY');   
            
            mainDTOObj = AtlasIntegrationServiceManager.processGetSubscriberPaymentHistoryResponseAsync(body, mainDTOObj);          
        } 
        catch(Exception e) 
        {
            ViasatLogHandler.Log(appName, ViasatLogHandler.SeverityTypeEXCEPTION, c.action, e.getMessage(), wsReturn);
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, c.action + ': ' + e.getMessage()));

            if (!mainDTOObj.billSnapShotDTOObj.isPopulated)
                AtlasUtility.populateExceptionString(c.action, mainDTOObj.billSnapShotDTOObj
               , (e instanceOf AtlasException ? e : new AtlasException.CalloutException(AtlasUtility.getMapCode(AtlasConstants.PH_Callout_Exp), e.getMessage())));
            mainDTOObj.billSnapShotDTOObj.isPymentPopulated=false;
        }             
        system.debug('*** ' + wsReturn);
        
        // Persist DTO objects if has changed
        persistViewState();
        return null;
    }  

    
    // Action method
    public continuationClass cont3c; 
    public Object invokeGetCurrentUsageByAccount() 
    {            
        string wsRequestMsg;
        if (timestarted == null) timestarted = System.now();
        
        if(!Test.isRunningTest())     
            wsEndPointDenverPub = AtlasUtility.getWebServiceHost(string.valueOF(AtlasUtility.randomNumberGenerator()))+AtlasIntegrationUtility.wsSettings.get(AtlasConstants.CURRENT_USAGE_V3).End_Point__c;
        else
            wsEndPointDenverPub = 'https://webservices.test.wildblue.net/PublicWebService-Usage/v3/services/Usage';
        
        cont3c = new continuationClass('getCurrentUsageByAccount', 'processContinuationGetCurrentUsageByAccountResponse', wsEndPointDenverPub);                

        //--- Set Request message        
        mainDTOObj = AtlasDatabaseManager.getViewState(false, mainDTOObj);
        system.debug('*** ' + cont3c.action + ' ' + mainDTOObj);
        
        if(!Test.isRunningTest())
            wsRequestMsg = AtlasIntegrationServiceManager.getCurrentUsageByAccountRequest(mainDTOObj); 
        else
            wsRequestMsg = 'test';
                          
        if (String.isEmpty(wsRequestMsg))
            return invokeGetCurrentQuotaByAccount(); // INVOKE 3d HERE: 
        
        return setContinuation(cont3c, wsRequestMsg);
    }

    // Callback method for invokeGeCurrentUsageByAccount
    public Object processContinuationGetCurrentUsageByAccountResponse() 
    {               
        continuationClass c = cont3c;

        //--- Set durations
        callDuration = System.now().getTime() - timestarted.getTime();
        string wsReturn = c.action;         
          
        mainDTOObj = AtlasDatabaseManager.getViewState(false, mainDTOObj);
        try 
        {          
            //--- Get the response by using the unique label
            HttpResponse res = Continuation.getResponse(c.requestLabel);          
            Integer statusCode = res.getStatusCode();     
            string body = res.getBody();       

            wsReturn += (' StatusCode:' + string.valueOf(statusCode) + ' Duration:' + c.duration + ' Total Run:' + string.valueOf(callDuration));
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, wsReturn));
            wsReturn += (body!=null && body!='' ? ' BODY: ' + body : ' NO BODY');   
system.debug('*** ' + wsReturn);
            if (statusCode > 200)
                throw new AtlasException.CalloutException(String.valueOf(statusCode),'Failed: '+ (res.getStatus() == null ? String.valueOf(statusCode):res.getStatus()));
                
            mainDTOObj = AtlasIntegrationServiceManager.processGetCurrentUsageByAccountResponseAsync(body, mainDTOObj);
        } 
        catch(Exception e) 
        {
            ViasatLogHandler.Log(appName, ViasatLogHandler.SeverityTypeEXCEPTION, c.action, e.getMessage(), wsReturn);
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, c.action + ': ' + e.getMessage()));

            AtlasUtility.populateExceptionString(c.action, mainDTOObj.cduDTOObj
            , (e instanceOf AtlasException ? e : new AtlasException.CalloutException(AtlasUtility.getMapCode(AtlasConstants.SC_Callout_Exp), AtlasUtility.getMapValue(AtlasConstants.SC_Callout_Exp))));
            mainDTOObj.cduDTOObj.refreshNow =false;
        }             
        
        // Persist DTO objects if has changed
        persistViewState();
        return null;
    }  


    // Action method
    public continuationClass cont3d; 
    public Object invokeGetCurrentQuotaByAccount() 
    {            
        string wsRequestMsg;
        if (timestarted == null) timestarted = System.now();
        
        if(!Test.isRunningTest())     
            wsEndPointDenverPub = AtlasUtility.getWebServiceHost(string.valueOF(AtlasUtility.randomNumberGenerator()))+AtlasIntegrationUtility.wsSettings.get(AtlasConstants.CURRENT_USAGE_V3).End_Point__c;
        else
            wsEndPointDenverPub = 'https://webservices.test.wildblue.net/PublicWebService-Usage/v3/services/Usage';

        cont3d = new continuationClass('getCurrentQuotaByAccount', 'processContinuationGetCurrentQuotaByAccountResponse', wsEndPointDenverPub);
        system.debug('*** ' + cont3d.action + ' ' + mainDTOObj);
        
        //--- Set Request message        
        // Do not bother to refresh mainDTOObj - Invoked from invokeGetCurrentUsageByAccount
        //mainDTOObj = AtlasDatabaseManager.getViewState(false, mainDTOObj); 
        
        if(!Test.isRunningTest())      
            wsRequestMsg = AtlasIntegrationServiceManager.getCurrentQuotaByAccountRequest(mainDTOObj); 
        else
            wsRequestMsg = 'test';  
                    
        if (String.isEmpty(wsRequestMsg))
            return null;

        return setContinuation(cont3d, wsRequestMsg);
    }

    // Callback method for invokeGetCurrentQuotaByAccount
    public Object processContinuationGetCurrentQuotaByAccountResponse() 
    {               
        continuationClass c = cont3d;

        //--- Set durations
        callDuration = System.now().getTime() - timestarted.getTime();
        string wsReturn = c.action;         
          
        mainDTOObj = AtlasDatabaseManager.getViewState(false, mainDTOObj);
        try 
        {          
            //--- Get the response by using the unique label
            HttpResponse res = Continuation.getResponse(c.requestLabel);          
            Integer statusCode = res.getStatusCode();     
            string body = res.getBody();       

            wsReturn += (' StatusCode:' + string.valueOf(statusCode) + ' Duration:' + c.duration + ' Total Run:' + string.valueOf(callDuration));
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, wsReturn));
            wsReturn += (body!=null && body!='' ? ' BODY: ' + body : ' NO BODY');
            if (statusCode > 200)
                throw new AtlasException.CalloutException(String.valueOf(statusCode),'Failed: '+ (res.getStatus() == null ? String.valueOf(statusCode):res.getStatus()));
                            
            mainDTOObj = AtlasIntegrationServiceManager.processGetCurrentQuotaByAccountResponseAsync(body, mainDTOObj);
        } 
        catch(Exception e) 
        {
            ViasatLogHandler.Log(appName, ViasatLogHandler.SeverityTypeEXCEPTION, c.action, e.getMessage(), wsReturn);
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, c.action + ': ' + e.getMessage()));

            AtlasUtility.populateExceptionString(c.action, mainDTOObj.cduDTOObj
                      , (e instanceOf AtlasException ? e : new AtlasException.CalloutException(AtlasUtility.getMapCode(AtlasConstants.SC_Callout_Exp), AtlasUtility.getMapValue(AtlasConstants.SC_Callout_Exp))));
            mainDTOObj.cduDTOObj.refreshNow =false;
        }             
system.debug('*** ' + wsReturn);
        
        // Persist DTO objects if has changed
        persistViewState();
        return null;
    } 


    // Action method
    public continuationClass cont3e; 
    public AtlasFinServiceXmlschemaFinanceService.getSubscriberCurrentPaymentMethodResponse_elementFuture subscriberCurrentPaymentMethodResponseFuture;
    public Object invokeGetCurrentPaymentMethod() 
    {            
        if(!Test.isRunningTest()) 
            wsEndPointDenverFin= AtlasUtility.getWebServiceHost(string.valueOF(AtlasUtility.randomNumberGenerator()))+AtlasIntegrationUtility.wsSettings.get(AtlasConstants.FINANCE_SERVICE).End_Point__c;
        else
            wsEndPointDenverFin='https://webservices.test.wildblue.net/FinanceService/v3/services/FinanceService';
        
        cont3e = new continuationClass('getSubscriberCurrentPaymentMethod', 'processContinuationGetSubscriberCurrentPaymentMethodResponse', wsEndPointDenverFin);
        continuationClass c = cont3e;
        if (timestarted == null) timestarted = System.now();

        mainDTOObj = AtlasDatabaseManager.getViewState(false, mainDTOObj);
        system.debug('*** ' + c.action + ' ' + mainDTOObj);
        if(!Test.isRunningTest()) {
            if (String.isEmpty(mainDTOObj.externalSystemName) || String.isEmpty(mainDTOObj.externalAccountReference))
                return null;      
        }
        if (mainDTOObj.currentPaymentMethodDTOObj != null)
            return null;
        
        //--- Async SOAP Web service call using class created from wsdl:
        //--- Create continuation with a timeout, set callback method, then invoke the begin* method by passing it the Continuation instance as first param
        Continuation con = new Continuation(AtlasIntegrationUtility.TIMEOUT_INT_SECS);
        con.continuationMethod = c.callBackMethod;
 
        AtlasFinServiceWsdlV3FinanceService.FinanceServiceEndpoint asyncServiceSoap=new AtlasFinServiceWsdlV3FinanceService.FinanceServiceEndpoint();
        asyncServiceSoap.endpoint_x=AtlasUtility.getWebServiceHost(string.valueOF(AtlasUtility.randomNumberGenerator()))+wsSettings.get(AtlasConstants.FINANCE_SERVICE).End_Point__c; 
        asyncServiceSoap.timeout_x=AtlasConstants.TIMEOUT;
        subscriberCurrentPaymentMethodResponseFuture = asyncServiceSoap.beginGetSubscriberCurrentPaymentMethod(con,mainDTOObj.externalSystemName,mainDTOObj.externalAccountReference);

        system.debug('*** Continuation ' + c.action + ': ' + con);  
        return con;  
//throw new AtlasException.CalloutException(getExCode(AtlasConstants.PH_Callout_Exp),getExValue(AtlasConstants.PH_Callout_Exp));
    }

    // Callback method for invokeGetCurrentPaymentMethod
    public Object processContinuationGetSubscriberCurrentPaymentMethodResponse() 
    {               
        continuationClass c = cont3e;

        //--- Set durations
        callDuration = System.now().getTime() - timestarted.getTime();
        string wsReturn = c.action;         

        mainDTOObj = AtlasDatabaseManager.getViewState(false, mainDTOObj);
        try 
        {          
            Object body = subscriberCurrentPaymentMethodResponseFuture.getValue();          

            wsReturn += (' Duration:' + c.duration + ' Total Run:' + string.valueOf(callDuration));
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, wsReturn));
            wsReturn += (body!=null && body!='' ? ' BODY: ' + body : ' NO BODY');   
            
            mainDTOObj = AtlasIntegrationServiceManager.processGetSubscriberCurrentPaymentMethodResponseAsync(body, mainDTOObj);            
        } 
        catch(Exception e) 
        {
            ViasatLogHandler.Log(appName, ViasatLogHandler.SeverityTypeEXCEPTION, c.action, e.getMessage(), wsReturn);
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, c.action + ': ' + e.getMessage()));

            if (!mainDTOObj.billSnapShotDTOObj.isPopulated)
                AtlasUtility.populateExceptionString(c.action, mainDTOObj.billSnapShotDTOObj
               , (e instanceOf AtlasException ? e : new AtlasException.CalloutException(AtlasUtility.getMapCode(AtlasConstants.PH_Callout_Exp), e.getMessage())));
            mainDTOObj.billSnapShotDTOObj.isPymentPopulated=false;
        }             
system.debug('*** ' + wsReturn);
        
        // Persist DTO objects if has changed
        persistViewState();
        return null;
    }  
}