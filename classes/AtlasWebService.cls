public with sharing class  AtlasWebService {
    Private String secuirtyHeaderTemplate = '<wsse:Security soapenv:mustUnderstand="1" xmlns:wsse="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd">' + 
                                            ' <wsu:Timestamp wsu:Id="Timestamp-4" xmlns:wsu="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-utility-1.0.xsd">' + 
                                            '    <wsu:Created>{0}</wsu:Created>' + 
                                            '    <wsu:Expires>{1}</wsu:Expires>' + 
                                            ' </wsu:Timestamp>' + 
                                            ' <wsse:UsernameToken wsu:Id="UsernameToken-3" xmlns:wsu="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-utility-1.0.xsd">' + 
                                            '    <wsse:Username>{2}</wsse:Username>' +
                                            '    <wsse:Password Type="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-username-token-profile-1.0#PasswordText">{3}</wsse:Password>' + 
                                            '    <wsse:Nonce EncodingType="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-soap-message-security-1.0#Base64Binary">{4}</wsse:Nonce>' + 
                                            '    <wsu:Created>{5}</wsu:Created>' + 
                                            ' </wsse:UsernameToken>' + 
                                            '</wsse:Security>';

     Private String WBHeaderTemplate = '<pws:wildBlueHeader xmlns:pws="http://www.viasat.com/XMLSchema/PublicWebService/v2/PWSHeader">' +
                                       '  <pws:invokedBy>' +
                                       '    <pws:username>{0}</pws:username>' +
                                       '    <pws:application>{0}</pws:application>' +
                                       '  </pws:invokedBy>' +
                                       '</pws:wildBlueHeader>';

     Private String soapEnvelopTemplate = '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/">' +
                                          '   <soapenv:Header>{0}{1}</soapenv:Header>' +
                                          '   <soapenv:Body>{2}</soapenv:Body>' +
                                          '</soapenv:Envelope>';                                

     Private String searchByNameTemplate = ' <sear:findSubscribersBySearchCriteria xmlns:sear="http://www.viasat.com/XMLSchema/PublicWebService/v1/SearchService">' +
                                           '   <sear:subscriberUsername>{0}</sear:subscriberUsername>' +
                                           ' </sear:findSubscribersBySearchCriteria>';

     Private String searchByAccountNumberTemplate= ' <sear:findSubscribersBySearchCriteria xmlns:sear="http://www.viasat.com/XMLSchema/PublicWebService/v1/SearchService">' +
                                              '   <sear:internalReferenceType>ACCOUNT</sear:internalReferenceType>' +
                                              '   <sear:internalReference>{0}</sear:internalReference>' +
                                              ' </sear:findSubscribersBySearchCriteria>';
     
     Private String searchByAccountTemplate = ' <sear:findSubscribersBySearchCriteria xmlns:sear="http://www.viasat.com/XMLSchema/PublicWebService/v1/SearchService">' +
                                              '   <sear:externalReferenceType>ACCOUNT</sear:externalReferenceType>' +
                                              '   <sear:externalReference>{0}</sear:externalReference>' +
                                              ' </sear:findSubscribersBySearchCriteria>';
    
     Private String searchByinternalServiceAgreementReferenceTemplate = ' <sear:findSubscribersBySearchCriteria xmlns:sear="http://www.viasat.com/XMLSchema/PublicWebService/v1/SearchService">' +
                                              '   <sear:internalReferenceType>SERVICE_AGREEMENT</sear:internalReferenceType>' +
                                              '   <sear:internalReference>{0}</sear:internalReference>' +
                                              ' </sear:findSubscribersBySearchCriteria>';
     
     Private String getLegacyAcctTemplate = '<sear:getLegacyAccount xmlns:sear="http://www.viasat.com/XMLSchema/PublicWebService/v1/SearchService"> ' +
                                            '  <sear:externalSystemName>{0}</sear:externalSystemName> ' +
                                            '  <sear:externalAccountReference>{1}</sear:externalAccountReference> ' +
                                            '  <sear:internalAccountReference>{2}</sear:internalAccountReference> ' +
                                            '</sear:getLegacyAccount>';

     Private String getProvSummaryTemplate = '<acc:getProvisioningSummary  xmlns:acc="http://www.wildblue.viasat.com/XMLSchema/PublicWebService/AccountInfoService"> ' +
                                             '  <acc:account>{0}</acc:account> ' +
                                             '</acc:getProvisioningSummary>';
      
     Private String getBillSummaryTemplate = '<acc:getBillingSummary  xmlns:acc="http://www.wildblue.viasat.com/XMLSchema/PublicWebService/AccountInfoService"> ' +
                                             '  <acc:account>{0}</acc:account> ' +
                                             '</acc:getBillingSummary>';
                                             
     Private String getInvoiceSummaryTemplate = '<fin:getSubscriberInvoiceSummaries xmlns:fin="http://www.viasat.com/XMLSchema/PublicWebService/v3/FinanceService"> ' +
                                                '  <fin:externalSystemName>{0}</fin:externalSystemName> ' +
                                                '  <fin:externalAccountReference>{1}</fin:externalAccountReference> ' +
                                                '</fin:getSubscriberInvoiceSummaries>';                                             

     Private String getInvoiceDetailsTemplate = '<fin:getSubscriberInvoiceDetails xmlns:fin="http://www.viasat.com/XMLSchema/PublicWebService/v3/FinanceService"> ' +
                                                '  <fin:externalSystemName>{0}</fin:externalSystemName> ' +
                                                '  <fin:externalAccountReference>{1}</fin:externalAccountReference> ' +
                                                '   <fin:externalInvoiceReference>{2}</fin:externalInvoiceReference> ' +
                                                '</fin:getSubscriberInvoiceDetails>';                                             

     Private String getCurrentUsageTemplate = '<pub:getCurrentUsageByAccount xmlns:pub="http://www.viasat.com/XMLSchema/v3/webservice/PublicUsageWebService"> ' +
                                                '  <pub:externalSystemName>{0}</pub:externalSystemName> ' +
                                                '  <pub:externalAccountReference>{1}</pub:externalAccountReference> ' +
                                                '</pub:getCurrentUsageByAccount>';  
     
     Private String getCurrentQuotaTemplate = '<pub:getCurrentQuotaByAccount xmlns:pub="http://www.viasat.com/XMLSchema/v3/webservice/PublicUsageWebService"> ' +
                                                '  <pub:externalSystemName>{0}</pub:externalSystemName> ' +
                                                '  <pub:externalAccountReference>{1}</pub:externalAccountReference> ' +
                                                '</pub:getCurrentQuotaByAccount>';  
                                                                                                                                                                                                                                           
     Private String soapEnvelopGetSubscribersTemplate = '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/">' +
                                                        '   <soapenv:Header></soapenv:Header>' +
                                                        '   <soapenv:Body>{0}</soapenv:Body>' +
                                                        '</soapenv:Envelope>';   
                                                                                                                                                      
     Private String searchBygetsubscribersTemplate = '<sso:getSubscribers xmlns:sso="http://api.viasat.com/schema/atlas/sso">' +
                                                     '   <sso:serviceusername>{0}</sso:serviceusername>' +
                                                     '   <sso:serviceuserpassword>{1}</sso:serviceuserpassword>' +
                                                     '   <sso:subscriberid>{2}</sso:subscriberid>' +
                                                     '</sso:getSubscribers>';
                                                                                                                                                                                
     Private String searchBygetsubscriberTemplate = ' <sso:getSubscriber xmlns:sso="http://api.viasat.com/schema/atlas/sso">' +
                                                   '   <sso:serviceusername>{0}</sso:serviceusername>' +
                                                   '   <sso:serviceuserpassword>{1}</sso:serviceuserpassword>' +
                                                   '   <sso:subscriberkey>{2}</sso:subscriberkey>' +                                                  
                                                   ' </sso:getSubscriber>';                                            
    //--- User Inputs
    Public String wsEnv {get {return wsEnv;} set;}
    public List<SelectOption> getEnv() {
        List<SelectOption> options = new List<SelectOption>(); 
        options.add(new SelectOption('TEST','Test')); 
        options.add(new SelectOption('PROD','Production')); 
        
        return options;
    }    
    Public String searchAccount  {get;set;}
    Public String searchUserName {get;set;}
    Public String searchAccountNumber {get;set;} 
    Public String searchInternalServiceAgreementRef{get;set;}   
    Public string subscriberkey {get;set;} 
    Public String serviceTab {get {return (serviceTab == null) ? 'search':serviceTab;} set;}
    Public String invoiceNum {get;set;}
    public String name;
    public String value;
    public String text;   
    
    // Time stamps for performance
    public DateTime timestarted {get; set;}
    public DateTime timestopped {get; set;}
    public Long callDuration {get; set;}
    
    //--- HTTPRequest variables
    Public String wsMethod { get {return (wsMethod == null) ? 'POST':wsMethod;} set;}
    Public String wsEndPoint { get {return wsEndPoint;} set;}
    Public String wsRequestMsg {get {return wsRequestMsg;} set;}
    Public Map<String, String> searchResult {get;set;}
    Public String wsReturn { 
       get { return wsReturn ; }      
       set;    
    }
    
    //--- Service variables
    Private String serviceInternalAccount;    
    Private String serviceExternalAccount;
    Private String serviceExternalSystemName;
    Private String serviceUserName;
    Private String serviceLegacyAccount;
    Private String serviceinternalServiceAgreementRef;
    private string serviceLevelName;
    Public String timenow {get;set;}
    Public String getthetime() {
        return String.valueof(System.now());
    }
       
    // Generate created timestamp in GMT
    public String generatecreatedTimestamp()
    {
       /*Datetime now = Datetime.now();
       String createdDate = ''+now.yearGmt()+'-'+now.monthGmt()+'-'+now.dayGmt()+'T'+now.hourGmt()+':'+now.minuteGmt()+':'+now.secondGmt()+'Z';
       return createdDate;*/
       
       String createdDate = DateTime.now().addminutes(-5).formatgmt('yyyy-MM-dd\'T\'HH:mm:ss\'Z\'');
       System.debug('Security - Created Date: ' + createdDate);
       return createdDate;
    }
    // Generate expires timestamp in GMT
    public String generateexpiredTimestamp()
    {
       /*Datetime now = Datetime.now().addminutes(5);
       String expiresDate = ''+now.yearGmt()+'-'+now.monthGmt()+'-'+now.dayGmt()+'T'+now.hourGmt()+':'+now.minuteGmt()+':'+now.secondGmt()+'Z';
       return expiresDate;*/
       
       String expiresDate = DateTime.now().addMinutes(5).formatgmt('yyyy-MM-dd\'T\'HH:mm:ss\'Z\'');          
       System.debug('Security - Expired Date: ' + expiresDate);           
       return expiresDate;
    }

    // Generate Nounce, random number base64 encoded
    public String generateNounce()
    {
        Long randomLong = Crypto.getRandomLong();
        return EncodingUtil.base64Encode(Blob.valueOf(String.valueOf(randomLong)));
    }

    // Generate timestamp in GMT
    public String generateTimestamp()
    {
       /*Datetime now = Datetime.now();
       String createdDate = ''+now.yearGmt()+'-'+now.monthGmt()+'-'+now.dayGmt()+'T'+now.hourGmt()+':'+now.minuteGmt()+':'+now.secondGmt()+'Z';
       return createdDate;*/
       
       String createdDate = DateTime.now().formatgmt('yyyy-MM-dd\'T\'HH:mm:ss\'Z\'');
       System.debug('User Token - Created: ' + createdDate);           
       return createdDate;
    }      

    private Map<String,String> parseXML(String toParse) {
       Map<String, String> returnObj = new Map<String, String>();
       DOM.Document doc = new DOM.Document();      
       try {
          doc.load(toParse);    
              DOM.XMLNode root = doc.getRootElement();
              walkThrough(root, returnObj);                
       } catch (System.XMLException e) {  // invalid XML
              //return e.getMessage();
       }           
       return returnObj;
    }
        
    private void walkThrough(DOM.XMLNode node, Map<String,String> returnObj) {
       String result = '\n';
         if (node.getNodeType() == DOM.XMLNodeType.COMMENT) {
           //--- 'Comment (' +  node.getText() + ')';
           return;
         }
         if (node.getNodeType() == DOM.XMLNodeType.TEXT) {
           //--- 'Text (' + node.getText() + ')'
           return;
         }
         if (node.getNodeType() == DOM.XMLNodeType.ELEMENT) {
           String lsElement = node.getName();
           if (node.getText().trim() != '') {
             returnObj.put(lsElement, node.getText().trim());
           }
           
           
           if (node.getAttributeCount() > 0) { 
             for (Integer i = 0; i< node.getAttributeCount(); i++ ) {
               //result += ', attribute #' + i + ':' + node.getAttributeKeyAt(i) + '=' + node.getAttributeValue(node.getAttributeKeyAt(i), node.getAttributeKeyNsAt(i));
             }  
           }
           for (Dom.XMLNode child: node.getChildElements()) {
             walkThrough(child, returnObj);
           }
           return;
         }
         return;  //should never reach here 
    }           

    public Map<String,String> parseGetSubscriber(string xml) {   
        Dom.Document doc = new Dom.Document();
        doc.load(xml);
        Map<String, String> returnObj = new Map<String, String>();
        //Retrieve the root element for this document.
        Dom.XMLNode root = doc.getRootElement();
        for(dom.XMLNode bodyNode1 : root.getChildElements()){
            for(dom.XMLNode bodyNode2 : bodyNode1.getChildElements()){
                for(dom.XMLNode bodyNode3 : bodyNode2.getChildElements()){                                            
                    for(dom.XMLNode bodyNode4 : bodyNode3.getChildElements()){
                        if(bodyNode4.getname()=='getsubscriberuri' || bodyNode4.getname()=='subscriberid' || bodyNode4.getname()=='subscriberkey'){
                            text=bodyNode4.getText(); 
                            returnObj.put(bodyNode4.getname(),text);                                   
                        }                           
                        for(dom.XMLNode bodyNode5 : bodyNode4.getChildElements()){
                            if(bodyNode5.getName() == 'sprattribute') {
                                for(dom.XMLNode bodyNode6 : bodyNode5.getChildElements()){
                                    if(bodyNode6.getname()=='name'){
                                        name=bodyNode6.getText();
                                    }
                                    if(bodyNode6.getname()=='value'){
                                        value=bodyNode6.getText();
                                    }
                                    else if(bodyNode6.getname()=='values'){
                                        value='';
                                        for(dom.XMLNode bodyNode7 : bodyNode6.getChildElements()){
                                            value+=bodyNode7.getText()+ ': ';     
                                        }   
                                    }
                                }                          
                                returnObj.put(name,value);
                            }                           
                            if(bodyNode5.getName() == 'username'){                             
                                returnObj.put(bodyNode5.getName(),bodyNode5.getText());
                            }                                                     
                         }                        
                    }                   
                }
            }
        }
        system.debug('******************map*********************'+ returnObj);
        return returnObj;     
    }       
    public List<AtlasPlan__c> atlasPlan{get;set;}
    public  Set<String> planNameSet{get;set;} 
       
    public AtlasWebService () {
        timenow = string.valueof(System.now());
        atlasPlan = new List<AtlasPlan__c>();
        planNameSet = new Set<String>();
        // For new Evolution and Unlimited Plans
        atlasPlan = [select id, Is_Plan_Unlimited__c, PlanAPIName__c,Is_Plan_Opennet__c  from AtlasPlan__c where Is_Plan_Unlimited__c =: true OR Is_Plan_Opennet__c =: true];
        if(atlasPlan != null && atlasPlan.size()>0){
            for(AtlasPlan__c ap : atlasPlan){
                  planNameSet.add(ap.PlanAPIName__c.toLowerCase());
            }
        }
    }
        
    public void invokeAtlasService () {
    
        System.debug('Service to Execute (Passed by user) - ' +  serviceTab);
        
        if (((searchUserName == null) || (searchUserName.trim().equals(''))) &&
            ((searchAccount == null) || (searchAccount.trim().equals(''))) &&         
            ((searchInternalServiceAgreementRef== null) || (searchInternalServiceAgreementRef.trim().equals(''))) &&
            ((searchAccountNumber== null) || (searchAccountNumber.trim().equals('')))) {
           ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Ooops! Please enter Account # (or) External Account Reference # (or) Internal Service Agreement Reference # (or) User Name.'));
           return;
        }
        
        //--- Check if search has to be performed or need to perform search agaun
        if ((!serviceTab.equalsIgnoreCase('search')) &&            
            (((serviceExternalAccount == null) || (serviceExternalAccount.trim().equals(''))) ||
            ((serviceInternalAccount== null) || (serviceInternalAccount.trim().equals(''))) ||
             ((searchUserName != null) && (!searchUserName.trim().equals('')) && (!searchUserName.trim().equals(serviceUserName))) || 
             ((searchAccountNumber!= null) && (!searchAccountNumber.trim().equals('')) && (!searchAccountNumber.trim().equals(serviceInternalAccount))) ||
             ((searchAccount != null) && (!searchAccount.trim().equals('')) && (!searchAccount.trim().equals(serviceExternalAccount))) ||
             ((searchInternalServiceAgreementRef!= null) && (!searchInternalServiceAgreementRef.trim().equals('')) && (!searchInternalServiceAgreementRef.trim().equals(serviceinternalServiceAgreementRef))))) {
           if (invokeAtlasService ('search'))
              return;
        }
        
        //--- for billing summary first get the legacy account
        if ((serviceTab.equalsIgnoreCase('billingsummary')) || (serviceTab.equalsIgnoreCase('provisioningsummary'))) {
           if (invokeAtlasService ('getlegacyacct'))
              return;
        }
        if ((serviceTab.equalsIgnoreCase('currentusage'))) {
           if (invokeAtlasService ('getlegacyacct'))
              return;
           if (invokeAtlasService ('billingsummary'))
              return;
        }
        if ((serviceTab.equalsIgnoreCase('getSubscriber'))) {
           if (invokeAtlasService ('getsubscribers'))
              return;
        }
        //--- Invoke the service requested        
        invokeAtlasService(serviceTab);        
    }
        
    private Boolean invokeAtlasService (String asService) {        
        HttpRequest req = new HttpRequest();
        
        System.debug('Service to Execute (Internal Private Method) - ' +  asService);
        
        wsEndPoint = ((wsEnv == 'PROD') ? 'https://webservices.wildblue.net': 'https://webservices.test.wildblue.net');
        
        if ((asService.equalsIgnoreCase('search')) || (asService.equalsIgnoreCase('getlegacyacct')))
           wsEndPoint += '/PublicSearch/v1/services/PublicSearchService';
        else if ((asService.equalsIgnoreCase('billingsummary')) || (asService.equalsIgnoreCase('provisioningsummary')))    
           wsEndPoint += '/AccountInfoService/services/AccountInfoService';
        else if ((asService.equalsIgnoreCase('invoicesummaries')) || (asService.equalsIgnoreCase('invoicedetails')))            
           wsEndPoint += '/FinanceService/v3/services/FinanceService';
        else if (asService.equalsIgnoreCase('currentusage'))   
           wsEndPoint += '/PublicWebService-Usage/v3/services/Usage';
       else if (asService.equalsIgnoreCase('getsubscribers') && (wsEnv == 'TEST'))
           wsEndPoint = 'https://mysso.test.exede.net/sso/ATLASSSOAPIService/getSubscribers';
       else if (asService.equalsIgnoreCase('getsubscribers') && (wsEnv == 'PROD'))
           wsEndPoint = 'https://mysso.exede.net/sso/ATLASSSOAPIService/getSubscribers';  
       else if (asService.equalsIgnoreCase('getsubscriber') && (wsEnv == 'TEST'))
           wsEndPoint = 'https://mysso.test.exede.net/sso/ATLASSSOAPIService/getSubscriber';  
       else if (asService.equalsIgnoreCase('getsubscriber') && (wsEnv == 'PROD'))
           wsEndPoint = 'https://mysso.exede.net/sso/ATLASSSOAPIService/getSubscriber';         
                     
        req.setMethod(wsMethod);
        req.setEndpoint(wsEndPoint);
        req.setTimeout(80000);
        req.setHeader('Content-Type', 'text/xml; charset=utf-8');
        req.setHeader('SOAPAction', '');
        
        String[] securityHeaderArgs = new String[] {generatecreatedTimestamp(),generateexpiredTimestamp(),AtlasConstants.WEBSERVICE_USERNAME,((wsEnv=='PROD') ? AtlasConstants.WEBSERVICE_PWD_PROD:AtlasConstants.WEBSERVICE_PWD_TEST),generateNounce(),generateTimestamp()};
        String secuirtyHeader = String.format(secuirtyHeaderTemplate, securityHeaderArgs);

        String wbHeader = '';
        if ((!asService.equalsIgnoreCase('search')) && (!asService.equalsIgnoreCase('getlegacyacct'))) {
           String[] wbHeaderArgs = new String[] {'AtlasWebServiceTestUI','AtlasWebServiceTestUI'};
          wbHeader = String.format(wbHeaderTemplate, wbHeaderArgs);          
        }
        
        String soapServiceCall = '';
                
        if (asService.equalsIgnoreCase('search')) {
           if ((searchUserName != null)  && (!searchUserName.trim().equals(''))){
              String[] args = new String[] {searchUserName};
              soapServiceCall = String.format(searchByNameTemplate,args);
           } 
           else if ((searchAccountNumber!= null)  && (!searchAccountNumber.trim().equals(''))) {
              String[] args = new String[] {searchAccountNumber};
              soapServiceCall = String.format(searchByAccountNumberTemplate,args) ;          
           }
           else if ((searchAccount!= null)  && (!searchAccount.trim().equals(''))) {
              String[] args = new String[] {searchAccount};
              soapServiceCall = String.format(searchByAccountTemplate,args) ;          
           }
           else {
               String[] args = new String[] {searchInternalServiceAgreementRef};
               soapServiceCall = String.format(searchByinternalServiceAgreementReferenceTemplate,args) ;
           }
        } else if (asService.equalsIgnoreCase('getlegacyacct')) {
           String[] args = new String[] {serviceExternalSystemName,serviceExternalAccount,serviceInternalAccount};
           soapServiceCall = String.format(getLegacyAcctTemplate,args) ;                     
        } else if (asService.equalsIgnoreCase('provisioningsummary')) {
           String[] args = new String[] {serviceLegacyAccount};
           soapServiceCall = String.format(getProvSummaryTemplate,args) ;                     
        } else if (asService.equalsIgnoreCase('billingsummary')) {
           String[] args = new String[] {serviceLegacyAccount};
           soapServiceCall = String.format(getBillSummaryTemplate,args) ;                     
        } else if (asService.equalsIgnoreCase('invoicesummaries')) {
           String[] args = new String[] {serviceExternalSystemName,serviceExternalAccount};
           soapServiceCall = String.format(getInvoiceSummaryTemplate,args) ;                     
        } else if (asService.equalsIgnoreCase('invoicedetails')) {
           String[] args = new String[] {serviceExternalSystemName,serviceExternalAccount,invoiceNum};
           soapServiceCall = String.format(getInvoiceDetailsTemplate,args) ;                                
        } else if (asService.equalsIgnoreCase('currentusage')) {
           String[] args = new String[] {serviceExternalSystemName,serviceExternalAccount};
           // For new Evolution and Unlimited Plans
           if(!AtlasUtility.isEmpty(serviceLevelName)&& !AtlasUtility.isEmpty(planNameSet)&& planNameSet.contains(serviceLevelName))
                  soapServiceCall = String.format(getCurrentQuotaTemplate,args);
           else
                  soapServiceCall = String.format(getCurrentUsageTemplate,args);                
        } else if (asService.equalsIgnoreCase('getsubscribers')) {
           String[] args = new String[] {AtlasUtility.getMapValue(AtlasConstants.ATLAS_SSO_API_UNAME),((wsEnv=='PROD') ? AtlasUtility.getMapValue(AtlasConstants.ATLAS_SSO_API_PWD_PROD):AtlasUtility.getMapValue(AtlasConstants.ATLAS_SSO_API_PWD_TEST)),serviceinternalServiceAgreementRef};
           soapServiceCall = String.format(searchBygetsubscribersTemplate,args) ;
        }else if (asService.equalsIgnoreCase('getsubscriber')) {
           String[] args = new String[] {AtlasUtility.getMapValue(AtlasConstants.ATLAS_SSO_API_UNAME),((wsEnv=='PROD') ? AtlasUtility.getMapValue(AtlasConstants.ATLAS_SSO_API_PWD_PROD):AtlasUtility.getMapValue(AtlasConstants.ATLAS_SSO_API_PWD_TEST)),subscriberkey};
           soapServiceCall = String.format(searchBygetsubscriberTemplate,args) ;
        }else {
           ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Ooops! Invalid Service Tab...'));
           return true;                          
        }
        
        if (asService.equalsIgnoreCase('getsubscribers')||asService.equalsIgnoreCase('getsubscriber')) {
            String[] args = new String[] {soapServiceCall};
            wsRequestMsg = String.format(soapEnvelopGetSubscribersTemplate,args);
        }
        else{
            String[] args = new String[] {secuirtyHeader,wbHeader,soapServiceCall};
            wsRequestMsg = String.format(soapEnvelopTemplate,args);
        }
        
        req.setBody(wsRequestMsg);
        
        Http http = new Http();
        try {
          //--- Execute web service call here    
          timestarted = System.now();   
          HTTPResponse res = http.send(req);   
          timestopped = System.now();
          callDuration = timestopped.getTime() - timestarted.getTime();
          //--- Get the response
          wsReturn = res.getBody();
          system.debug('---response---:' +wsReturn);
          
          //--- Parse the results...
          if(asService.equalsIgnoreCase('getsubscriber')) {
              searchResult = parseGetSubscriber(wsReturn);
          }
          else
              searchResult = parseXML(wsReturn);
              
          if (asService.equalsIgnoreCase('search')) {
             serviceExternalAccount    = searchResult.get('externalAccountReference');
             serviceInternalAccount    = searchResult.get('internalAccountReference');
             serviceExternalSystemName = searchResult.get('externalSystemName');
             serviceUserName           = searchResult.get('subscriberUsername');
             serviceinternalServiceAgreementRef = searchResult.get('internalServiceAgreementReference');
             
             if ((serviceExternalAccount == null) || (serviceExternalAccount.trim().equals(''))) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING, 'Ooops! Unable to find the subscriber'));
                return true;
             }
                
          } else if (asService.equalsIgnoreCase('getlegacyacct')) {
              serviceLegacyAccount = searchResult.get('account');
          }else if (asService.equalsIgnoreCase('billingsummary')) {
              serviceLevelName= searchResult.get('serviceLevel');
              serviceLevelName=serviceLevelName.toLowercase();
          }else if(asService.equalsIgnoreCase('getSubscribers')){
              subscriberkey = searchResult.get('subscriberkey');
          }
          
          ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'Successfully executed the web service (' + asService + '). Status=' + res.getStatus() + ' Status Code=' + res.getStatusCode()));
          return false;
       } catch(Exception e) {
            System.debug('Error Invoking the service' + e.getMessage());
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Ooops! Unable to invoke the service - ' + e.getMessage()));
            return true;
       }       
    }    
}