/*********************************************************************************
Name        : AtlasIntegrationUtility
Created By  : Gaurav Gathania
Created Date: 29 October 2013
Project     : Atlas Beta
Usages      : Integration Untility to call required webservice endpoints
              This utility shall not contain any business logic and will only have statements
              pertaining to configuration of webservice callouts.
        
Change Log:
<Date>      <Modified By>       <Change Description>
4/24/2014   K. Wortel           Added call to AtlasUtility.insertTransaction method to support transaction audit capability
*********************************************************************************/
global with sharing class AtlasIntegrationUtility{

    public static Map<String,AtlasWebserviceSetting__c> wsSettings=AtlasWebserviceSetting__c.getall();
    public static Map<String,AtlasSSOWebserviceSetting__c> wsSSOSettings=AtlasSSOWebserviceSetting__c.getall(); 
    
    /* Adding these in AtlasDataManagerAsync class
        //Continuation HTTP Request settings vars
        public static String wsEndPointDenver = AtlasUtility.getWebServiceHost(string.valueOF(AtlasUtility.randomNumberGenerator()))+AtlasIntegrationUtility.wsSettings.get(AtlasConstants.FIND_SUBSCRIBERV2).End_Point__c;                                         
        public static String wsEndPointDenverAccount = AtlasUtility.getWebServiceHost(string.valueOF(AtlasUtility.randomNumberGenerator())) + AtlasIntegrationUtility.wsSettings.get(AtlasConstants.ACCOUNT_INFO).End_Point__c;
        public static String wsEndPointDenverFin = AtlasUtility.getWebServiceHost(string.valueOF(AtlasUtility.randomNumberGenerator()))+AtlasIntegrationUtility.wsSettings.get(AtlasConstants.FINANCE_SERVICE).End_Point__c; 
        public static String wsEndPointDenverPub = AtlasUtility.getWebServiceHost(string.valueOF(AtlasUtility.randomNumberGenerator()))+AtlasIntegrationUtility.wsSettings.get(AtlasConstants.CURRENT_USAGE_V3).End_Point__c;
    */
    public static Integer TIMEOUT_INT_SECS = 40;
    
    final static String soapNS = 'http://schemas.xmlsoap.org/soap/envelope/';
    final static String serviceNSSearch = 'http://www.viasat.com/XMLSchema/PublicWebService/v2/SearchService';
    final static String serviceNSAccount = 'http://www.wildblue.viasat.com/XMLSchema/PublicWebService/AccountInfoService';
    final static String serviceNSFin = 'http://www.viasat.com/XMLSchema/PublicWebService/v3/FinanceService';
    final static String serviceNSPub = 'http://www.viasat.com/XMLSchema/v3/webservice/PublicUsageWebService';
    final static String serviceNSServiceAvailability = 'http://www.wildblue.viasat.com/XMLSchema/v2/webservice/PublicServiceAvailabilityWebService';

    /* Start - Initialization for findSubscriberBySearchCriteriaV2 webservice */
    public static String secuirtyHeaderTemplate   = '<wsse:Security soapenv:mustUnderstand="1" xmlns:wsse="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd">' + 
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
    public static String WBHeaderTemplate         = '<pws:wildBlueHeader xmlns:pws="http://www.viasat.com/XMLSchema/PublicWebService/v2/PWSHeader">' +
                                              '  <pws:invokedBy>' +
                                              '    <pws:username>{0}</pws:username>' +
                                              '    <pws:application>{0}</pws:application>' +
                                              '  </pws:invokedBy>' +
                                              '</pws:wildBlueHeader>'; 
    public static String soapEnvelopTemplate      = '<soapenv:Envelope xmlns:soapenv="' + soapNS + '">' + //'<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/">' +
                                              '   <soapenv:Header>{0}{1}</soapenv:Header>' +
                                              '   <soapenv:Body>{2}</soapenv:Body>' +
                                              '</soapenv:Envelope>';                                                
//  public static String searchByAccountNumberTemplate= ' <sear:findSubscribersBySearchCriteria xmlns:sear="http://www.viasat.com/XMLSchema/PublicWebService/v2/SearchService">' +
    public static String searchByAccountNumberTemplate= ' <sear:findSubscribersBySearchCriteria xmlns:sear="' + serviceNSSearch + '">' +
                                                  '   <sear:internalReferenceType>ACCOUNT</sear:internalReferenceType>' +
                                                  '   <sear:internalReference>{0}</sear:internalReference>' +
                                                  ' </sear:findSubscribersBySearchCriteria>';
//  public static String searchByMacTemplate= ' <sear:findSubscribersBySearchCriteria xmlns:sear="http://www.viasat.com/XMLSchema/PublicWebService/v2/SearchService">' + 
    public static String searchByMacTemplate= ' <sear:findSubscribersBySearchCriteria xmlns:sear="' + serviceNSSearch + '">' +                                         
                                                  ' <sear:macAddress>{0}</sear:macAddress>' +
                                                  ' </sear:findSubscribersBySearchCriteria>';    
    public static String updatePaymentTemplate= ' <fin:updatePaymentMethod xmlns:fin="http://www.viasat.com/XMLSchema/PublicWebService/v4/FinanceService">' +
                                                ' <fin:externalSystemName>{0}</fin:externalSystemName>' +
                                                ' <fin:externalAccountReference>{1}</fin:externalAccountReference>' +
                                                ' <fin:paymentMethod>' +
                                                ' <fin:eft>' +
                                                ' <fin:accountHolder>{2}</fin:accountHolder>' +
                                                ' <fin:bankAccountNumber>{3}</fin:bankAccountNumber>' +
                                                ' <fin:bankCode>{4}</fin:bankCode>' +
                                                ' <fin:paymentType>{5}</fin:paymentType>' +
                                                ' </fin:eft>' +
                                                ' </fin:paymentMethod>' +
                                                ' </fin:updatePaymentMethod>';  
    public static String updatePaymentTemplateCard= ' <fin:updatePaymentMethod xmlns:fin="http://www.viasat.com/XMLSchema/PublicWebService/v4/FinanceService">' +
                                                ' <fin:externalSystemName>{0}</fin:externalSystemName>' +
                                                ' <fin:externalAccountReference>{1}</fin:externalAccountReference>' +
                                                ' <fin:externalTransactionReference>{2}</fin:externalTransactionReference>' +
                                                ' <fin:paymentMethod>' +
                                                ' <fin:creditCard>' +
                                                ' <fin:accountHolder>{3}</fin:accountHolder>' +
                                                ' <fin:cardNumber>{4}</fin:cardNumber>' +
                                                ' <fin:expirationDate>{5}</fin:expirationDate>' +
                                                ' <fin:methodOfPayment>{6}</fin:methodOfPayment>' +
                                                ' <fin:zipCode>{7}</fin:zipCode>' +
                                                ' <fin:CVV>{8}</fin:CVV>' +
                                                ' </fin:creditCard>' +
                                                ' </fin:paymentMethod>' +
                                                ' </fin:updatePaymentMethod>';                                                                                                                                                         
    public static String oneTimePaymentTemplateCheck= ' <fin:submitOneTimePayment xmlns:fin="http://www.viasat.com/XMLSchema/PublicWebService/v4/FinanceService">' +
                                                ' <fin:externalSystemName>{0}</fin:externalSystemName>' +
                                                ' <fin:externalAccountReference>{1}</fin:externalAccountReference>' +
                                                ' <fin:paymentMethodActionType>{2}</fin:paymentMethodActionType>' +
                                                ' <fin:amount>{3}</fin:amount>' +
                                                ' <fin:paymentMethod>' +
                                                ' <fin:eft>' +
                                                ' <fin:accountHolder>{4}</fin:accountHolder>' +
                                                ' <fin:bankAccountNumber>{5}</fin:bankAccountNumber>' +
                                                ' <fin:bankCode>{6}</fin:bankCode>' +
                                                ' <fin:paymentType>{7}</fin:paymentType>' +
                                                ' </fin:eft>' +
                                                ' </fin:paymentMethod>' +
                                                ' </fin:submitOneTimePayment>';  
    public static String oneTimePaymentTemplateCard= ' <fin:submitOneTimePayment xmlns:fin="http://www.viasat.com/XMLSchema/PublicWebService/v4/FinanceService">' +
                                                ' <fin:externalSystemName>{0}</fin:externalSystemName>' +
                                                ' <fin:externalAccountReference>{1}</fin:externalAccountReference>' +
                                                ' <fin:paymentMethodActionType>{2}</fin:paymentMethodActionType>' +
                                                ' <fin:amount>{3}</fin:amount>' +
                                                ' <fin:paymentMethod>' +
                                                ' <fin:creditCard>' +
                                                ' <fin:accountHolder>{4}</fin:accountHolder>' +
                                                ' <fin:cardNumber>{5}</fin:cardNumber>' +
                                                ' <fin:expirationDate>{6}</fin:expirationDate>' +
                                                ' <fin:methodOfPayment>{7}</fin:methodOfPayment>' +
                                                ' <fin:zipCode>{8}</fin:zipCode>' +
                                                ' <fin:CVV>{9}</fin:CVV>' +
                                                ' </fin:creditCard>' +
                                                ' </fin:paymentMethod>' +
                                                ' </fin:submitOneTimePayment>'; 
    public static String oneTimePaymentRecurring= ' <fin:submitOneTimePayment xmlns:fin="http://www.viasat.com/XMLSchema/PublicWebService/v4/FinanceService">' +
                                                ' <fin:externalSystemName>{0}</fin:externalSystemName>' +
                                                ' <fin:externalAccountReference>{1}</fin:externalAccountReference>' +
                                                ' <fin:paymentMethodActionType>{2}</fin:paymentMethodActionType>' +
                                                ' <fin:amount>{3}</fin:amount>' +                                                
                                                ' </fin:submitOneTimePayment>';                                            
    public static String oneTimeAutoResumeTemplateCheck= ' <fin:submitOneTimePaymentAutoResume xmlns:fin="http://www.viasat.com/XMLSchema/PublicWebService/v4/FinanceService">' +
                                                ' <fin:externalSystemName>{0}</fin:externalSystemName>' +
                                                ' <fin:externalAccountReference>{1}</fin:externalAccountReference>' +
                                                ' <fin:paymentMethodActionType>{2}</fin:paymentMethodActionType>' +
                                                ' <fin:amount>{3}</fin:amount>' +
                                                ' <fin:paymentMethod>' +
                                                ' <fin:eft>' +
                                                ' <fin:accountHolder>{4}</fin:accountHolder>' +
                                                ' <fin:bankAccountNumber>{5}</fin:bankAccountNumber>' +
                                                ' <fin:bankCode>{6}</fin:bankCode>' +
                                                ' <fin:paymentType>{7}</fin:paymentType>' +
                                                ' </fin:eft>' +
                                                ' </fin:paymentMethod>' +
                                                ' </fin:submitOneTimePaymentAutoResume>';  
    public static String oneTimeAutoResumeTemplateCard= ' <fin:submitOneTimePaymentAutoResume xmlns:fin="http://www.viasat.com/XMLSchema/PublicWebService/v4/FinanceService">' +
                                                ' <fin:externalSystemName>{0}</fin:externalSystemName>' +
                                                ' <fin:externalAccountReference>{1}</fin:externalAccountReference>' +
                                                ' <fin:paymentMethodActionType>{2}</fin:paymentMethodActionType>' +
                                                ' <fin:amount>{3}</fin:amount>' +
                                                ' <fin:paymentMethod>' +
                                                ' <fin:creditCard>' +
                                                ' <fin:accountHolder>{4}</fin:accountHolder>' +
                                                ' <fin:cardNumber>{5}</fin:cardNumber>' +
                                                ' <fin:expirationDate>{6}</fin:expirationDate>' +
                                                ' <fin:methodOfPayment>{7}</fin:methodOfPayment>' +
                                                ' <fin:zipCode>{8}</fin:zipCode>' +
                                                ' <fin:CVV>{9}</fin:CVV>' +
                                                ' </fin:creditCard>' +
                                                ' </fin:paymentMethod>' +
                                                ' </fin:submitOneTimePaymentAutoResume>';   
    public static String oneTimePaymentAutoResRecurring= ' <fin:submitOneTimePaymentAutoResume xmlns:fin="http://www.viasat.com/XMLSchema/PublicWebService/v4/FinanceService">' +
                                                ' <fin:externalSystemName>{0}</fin:externalSystemName>' +
                                                ' <fin:externalAccountReference>{1}</fin:externalAccountReference>' +
                                                ' <fin:paymentMethodActionType>{2}</fin:paymentMethodActionType>' +
                                                ' <fin:amount>{3}</fin:amount>' +                                                
                                                ' </fin:submitOneTimePaymentAutoResume>';
     public static String searchByFiltersTemplate= ' <sear:findSubscribersBySearchCriteria xmlns:sear="' + serviceNSSearch + '">' +                                         
                                                  ' <sear:externalReferenceType>{0}</sear:externalReferenceType>' +
												  ' <sear:externalReference>{1}</sear:externalReference>' +
												  ' <sear:internalReferenceType>{2}</sear:internalReferenceType>' +
												  ' <sear:internalReference>{3}</sear:internalReference>' +
												  ' <sear:contactType>{4}</sear:contactType>' +
												  ' <sear:emailAddress>{5}</sear:emailAddress>' +
												  ' <sear:phoneNumber>{6}</sear:phoneNumber>' +
												  ' <sear:firstName>{7}</sear:firstName>' +
												  ' <sear:lastName>{8}</sear:lastName>' +
												  ' <sear:subscriberUsername>{9}</sear:subscriberUsername>' +
												  ' <sear:businessName>{10}</sear:businessName>' +
												  ' <sear:address>' +
												  '	<countryCode>{11}</countryCode>' +
												  '	<postalCode>{12}</postalCode>' +
												  '	<region>{13}</region>' +
												  '	<municipality>{14}</municipality>' +
												  '	<addressLine>{15}</addressLine>' +
												  ' </sear:address>' +
												  ' <sear:ticketNumber>{16}</sear:ticketNumber>' +
												  ' <sear:macAddress>{17}</sear:macAddress>' +
												  ' <sear:serialNumber>{18}</sear:serialNumber>' +
												  ' </sear:findSubscribersBySearchCriteria>';
	public static String searchByFiltersTemplate1= ' <sear:findSubscribersBySearchCriteria xmlns:sear="' + serviceNSSearch + '">' +                                         
												  ' <sear:internalReferenceType>{0}</sear:internalReferenceType>' +
												  ' <sear:internalReference>{1}</sear:internalReference>' +
												  ' <sear:emailAddress>{2}</sear:emailAddress>' +
												  ' <sear:phoneNumber>{3}</sear:phoneNumber>' +
												  ' <sear:firstName>{4}</sear:firstName>' +
												  ' <sear:lastName>{5}</sear:lastName>' +
												  '<sear:maxResults>{6}</sear:maxResults>'+
												  ' </sear:findSubscribersBySearchCriteria>';                                             	  
    
    Public static String wsReturn {get {return wsReturn ;} set;}
    Public static Map<String, String> searchResult {get;set;} 
    // Generate Nounce, random number base64 encoded
    public static String generateNounce()
    {
        Long randomLong = Crypto.getRandomLong();
        return EncodingUtil.base64Encode(Blob.valueOf(String.valueOf(randomLong)));
    }   
    /* End - Initialization for findSubscriberBySearchCriteriaV2 webservice*/
    
    /**
    * @author Gaurav Gathania
    * @description - searchCustomer, taking an input parameter of type String accountNo
    * @input param  - String accountNo
    * @return param AtlasCustomerSearchWS.customerInfoBean
    */   
    public static AtlasCustomerSearchWS.customerInfoBean searchCustomer(String accountNo)
    { 
        AtlasTestConstants.WEBSERVICE_NAME=AtlasConstants.CUSTOMER_SEARCH;  
        AtlasCustomerSearchWS.CustomerSearchImplV2Port accStub=new AtlasCustomerSearchWS.CustomerSearchImplV2Port();
        accStub.endpoint_x=AtlasUtility.getWebServiceHost(string.valueOF(AtlasUtility.randomNumberGenerator()))+wsSettings.get(AtlasConstants.CUSTOMER_SEARCH).End_Point__c;
        accStub.timeout_x=AtlasConstants.TIMEOUT;
        AtlasCustomerSearchWS.customerInfoBean[] customerArray=null;
        try{ 
            customerArray=accStub.findCustomers(accountNo,null,null,null,null,null,null,null,null,null,null,null);
            if(AtlasUtility.isEmpty(customerArray))
            throw new AtlasException.InvalidDataException(getExCode(AtlasConstants.SC_No_Data_Exp),getExValue(AtlasConstants.SC_No_Data_Exp));
        }catch(CalloutException e)
        {
            throw new AtlasException.CalloutException(getExCode(AtlasConstants.SC_Callout_Exp),getExValue(AtlasConstants.SC_Callout_Exp));
        }
        if(!AtlasUtility.isEmpty(customerArray)&&customerArray.size()==1)
        return customerArray[0];
        return null; 
    }
    
    /**
    * @author Gaurav Gathania
    * @description - getAccountServiceAgreementsAndServices,
    * @input param  - String accountNoEncrypted
    * @return param AtlasAccInfoXmlschemaPublic.accountServiceAgreementsBean
    */   
    public static AtlasAccInfoXmlschemaPublic.accountServiceAgreementsBean getAccountServiceAgreementsAndServices(String accountNoEncrypted)
    { 
        AtlasTestConstants.WEBSERVICE_NAME=AtlasConstants.GET_SERVICEAGREEMENTS;    
        AtlasAccInfoWsdlPublicwebse.AccountInfoEndpoint accStub=new AtlasAccInfoWsdlPublicwebse.AccountInfoEndpoint();
        accStub.endpoint_x=AtlasUtility.getWebServiceHost(string.valueOF(AtlasUtility.randomNumberGenerator()))+wsSettings.get(AtlasConstants.ACCOUNT_INFO).End_Point__c;
        accStub.timeout_x=AtlasConstants.TIMEOUT;
        AtlasAccInfoXmlschemaPublic.accountServiceAgreementsBean[] accServAgmntArray=null;
        try{
            accServAgmntArray=accStub.getAccountServiceAgreementsAndServices(accountNoEncrypted);
            if(AtlasUtility.isEmpty(accServAgmntArray))
            throw new AtlasException.InvalidDataException(getExCode(AtlasConstants.SA_No_Data_Exp),getExValue(AtlasConstants.SA_No_Data_Exp));
        }catch(CalloutException e)
        {
            throw new AtlasException.CalloutException(getExCode(AtlasConstants.SA_Callout_Exp),getExValue(AtlasConstants.SA_Callout_Exp));
        }
        if(!AtlasUtility.isEmpty(accServAgmntArray)&&accServAgmntArray.size()==1)
        return accServAgmntArray[0];
        return null; 
    }
    /**
    * @author Gaurav Gathania
    * @description - findSubscribersBySearchCriteria,
    * @input param  - String externalAccountNo
    * @return param AtlasPublicWebServiceSearchServiceStub.findSubscribersBySearchCriteriaResponse
    */
    public static AtlasPublicWebServiceSearchServiceStub.findSubscribersBySearchCriteriaResponse findSubscribersBySearchCriteria(String internalAccountNo)
    {   /*AtlasTestConstants.WEBSERVICE_NAME=AtlasConstants.FIND_SUBSCRIBER;    
        AtlasPublicWebServiceSearchService.SearchImplPort accStub=new AtlasPublicWebServiceSearchService.SearchImplPort();
        accStub.endpoint_x=AtlasUtility.getWebServiceHost(string.valueOF(AtlasUtility.randomNumberGenerator()))+wsSettings.get(AtlasConstants.FIND_SUBSCRIBER).End_Point__c;
        //accStub.endpoint_x='http://requestb.in/13qhmyt1';
        accStub.timeout_x=AtlasConstants.TIMEOUT;
        AtlasPublicWebServiceSearchServiceStub.findSubscribersBySearchCriteriaResponse accResponse=null;
        try{
            accResponse=accStub.findSubscribersBySearchCriteria(AtlasConstants.EX_REF_FOR_SEARCH, externalAccountNo, null, null, null, null, null, null, null, null, null, null, null, null, 1);
            if(AtlasUtility.isEmpty(accResponse))
                throw new AtlasException.InvalidDataException(getExCode(AtlasConstants.SC_No_Data_Exp),getExValue(AtlasConstants.SC_No_Data_Exp));
        }catch(CalloutException e)
        {
            throw new AtlasException.CalloutException(getExCode(AtlasConstants.SC_Callout_Exp),getExValue(AtlasConstants.SC_Callout_Exp));
        }
        return accResponse; */
        
        // Use the Generic call.  Converting this method so we don't break any historical references.
        return findSubscribersBySearchCriteriaGeneric(null, null, AtlasConstants.EX_REF_FOR_SEARCH, internalAccountNo, null, null, null, null, null, null, null, null, null, null);
    }

    /**
    * @author Kelly Wortel
    * @description - findSubscribersBySearchCriteria,
    * @input param  - String internalAccountNo
    * @return param AtlasPublicWebServiceSearchServiceStub.findSubscribersBySearchCriteriaResponse
    */
    public static AtlasPublicWebServiceSearchServiceStub.findSubscribersBySearchCriteriaResponse findSubscribersBySearchCriteriaGeneric(String externalRefType, String externalAccountNo, String internalRefType, String internalAccountNo, String contactType, String email, String phoneNum, String firstName, String lastName, String userName, AtlasPublicWebServicePWSCommonData.Address address, String ticketNum, String MAC, String serialNum)
    {   
        AtlasTestConstants.WEBSERVICE_NAME=AtlasConstants.FIND_SUBSCRIBER;    
        AtlasPublicWebServiceSearchService.SearchImplPort accStub=new AtlasPublicWebServiceSearchService.SearchImplPort();
        accStub.endpoint_x=AtlasUtility.getWebServiceHost(string.valueOF(AtlasUtility.randomNumberGenerator()))+wsSettings.get(AtlasConstants.FIND_SUBSCRIBER).End_Point__c;
        //accStub.endpoint_x='http://requestb.in/1bcavlo1';
        accStub.timeout_x=AtlasConstants.TIMEOUT;
        AtlasPublicWebServiceSearchServiceStub.findSubscribersBySearchCriteriaResponse accResponse=null;
        try{ 
            accResponse=accStub.findSubscribersBySearchCriteria(externalRefType, externalAccountNo, internalRefType, internalAccountNo, contactType, email, phoneNum, firstName, lastName, userName, Address, ticketNum, MAC, serialNum, null);
            if(AtlasUtility.isEmpty(accResponse))
                throw new AtlasException.InvalidDataException(getExCode(AtlasConstants.SC_No_Data_Exp),getExValue(AtlasConstants.SC_No_Data_Exp));
                    
            // If the response includes multiple subscriber elements, then see if one if "ACTIVE" otherwise we will use the 0th.  
            if(!AtlasUtility.isEmpty(accResponse)&& !AtlasUtility.isEmpty(accResponse.subscriber)){  
                if(accResponse.subscriber.size()>1) {
                    AtlasPublicWebServiceSearchServiceStub.Subscriber[] subscriberNew = new AtlasPublicWebServiceSearchServiceStub.Subscriber[1];
                    
                    // Loop through the subscriber list.  If one is "Active" then use it.
                    for(AtlasPublicWebServiceSearchServiceStub.Subscriber subscriberElement : accResponse.subscriber) {
                        if(subscriberElement.serviceAgreement.provisioningStatus.equalsIgnoreCase('ACTIVE')) {
                            subscriberNew[0] = subscriberElement; 
                            accResponse.subscriber = subscriberNew;
                            break;
                        }
                    }
                }   
            }
        }catch(CalloutException e)
        {   
            throw new AtlasException.CalloutException(getExCode(AtlasConstants.SC_Callout_Exp),getExValue(AtlasConstants.SC_Callout_Exp));
        }
        return accResponse; 
    }
        
    /**
    * @author Gaurav Gathania
    * @description - getLegacyAccount,
    * @input param  - String externalAccountNo
    * @return param AtlasPublicWebServiceSearchServiceStub.findSubscribersBySearchCriteriaResponse
    */ 
    public static String getLegacyAccount(String externalSystemName,String externalAccountReference,String internalAccountReference) {
        AtlasTestConstants.WEBSERVICE_NAME=AtlasConstants.GET_LEGACYACCOUNT; 
        AtlasPublicWebServiceSearchService.SearchImplPort accStub=new AtlasPublicWebServiceSearchService.SearchImplPort();
        accStub.endpoint_x=AtlasUtility.getWebServiceHost(string.valueOF(AtlasUtility.randomNumberGenerator()))+wsSettings.get(AtlasConstants.FIND_SUBSCRIBER).End_Point__c;
        accStub.timeout_x=AtlasConstants.TIMEOUT;
        String str =accStub.getLegacyAccount(externalSystemName, externalAccountReference, internalAccountReference);    
        return  str;
    }
    
    /**
    * @author Gaurav Gathania
    * @description - getBillingSummary,
    * @input param  - String accountNo
    * @return param AtlasAccInfoXmlschemaPublic.billingSummary
    */  
    public static AtlasAccInfoXmlschemaPublic.billingSummary getBillingSummary(String accountNo, String internalAccountReference)
    {   
        AtlasTestConstants.WEBSERVICE_NAME=AtlasConstants.GET_BILLING;   
        AtlasAccInfoWsdlPublicwebse.AccountInfoEndpoint accStub=new AtlasAccInfoWsdlPublicwebse.AccountInfoEndpoint();
        accStub.endpoint_x=AtlasUtility.getWebServiceHost(string.valueOF(AtlasUtility.randomNumberGenerator()))+wsSettings.get(AtlasConstants.ACCOUNT_INFO).End_Point__c; 
        accStub.timeout_x=AtlasConstants.TIMEOUT;
        AtlasAccInfoXmlschemaPublic.billingSummary accBillingSummary=null;
       
        try{
            accBillingSummary=accStub.getBillingSummary(accountNo);
            if(AtlasUtility.isEmpty(accBillingSummary))
            throw new AtlasException.InvalidDataException(getExCode(AtlasConstants.BS_No_Data_Exp),getExValue(AtlasConstants.BS_No_Data_Exp)); 
        }catch(CalloutException e)
        {   
            throw new AtlasException.CalloutException(getExCode(AtlasConstants.BS_Callout_Exp),getExValue(AtlasConstants.BS_Callout_Exp));
        }
        return accBillingSummary;
    }


    /**
    * @author Gaurav Gathania
    * @description - getCurrentUsageByAccount,
    * @input param  - String externalSystemName,String accountNo
    * @return param AtlasPubUsageServiceXmlschemaV1Web.serviceAgreementUsage_element
    */  
    public static AtlasPubUsageServiceXmlschemaV1Web.serviceAgreementUsage_element getCurrentUsageByAccount(String externalSystemName,String accountNo)
    { 
        AtlasTestConstants.WEBSERVICE_NAME=AtlasConstants.CURRENT_DATA_USAGE;    
        AtlasPubUsageServiceWsdlV1.UsageServiceEndpoint accStub=new AtlasPubUsageServiceWsdlV1.UsageServiceEndpoint();
        AtlasPubUsageServiceXmlschemaPWSHeader.wildBlueHeader wbHeaderObj=new AtlasPubUsageServiceXmlschemaPWSHeader.wildBlueHeader();
        AtlasPubUsageServiceXmlschemaPWSHeader.invokedBy invokedByObj=new AtlasPubUsageServiceXmlschemaPWSHeader.invokedBy();
        invokedByObj.application=AtlasConstants.INVOKED_BY_APP;
        invokedByObj.username=AtlasConstants.INVOKED_BY_USERNAME;
        wbHeaderObj.invokedBy=invokedByObj;
        accStub.wildBlueHeader=wbHeaderObj;
        accStub.endpoint_x=AtlasUtility.getWebServiceHost(string.valueOF(AtlasUtility.randomNumberGenerator()))+wsSettings.get(AtlasConstants.CURRENT_USAGE).End_Point__c;        
        accStub.timeout_x=AtlasConstants.TIMEOUT;
        AtlasPubUsageServiceXmlschemaV1Web.serviceAgreementUsage_element[] accCDUObj=null;
        try{ 
            accCDUObj=accStub.getCurrentUsageByAccount(externalSystemName,accountNo);
            if(AtlasUtility.isEmpty(accCDUObj))
            throw new AtlasException.InvalidDataException(getExCode(AtlasConstants.CU_No_Data_Exp),getExValue(AtlasConstants.CU_No_Data_Exp));
        }catch(CalloutException e)
        {
            throw new AtlasException.CalloutException(getExCode(AtlasConstants.CU_Callout_Exp),getExValue(AtlasConstants.CU_Callout_Exp));
        }
        system.debug('---accCDUObj--->'+accCDUObj);
        if(!AtlasUtility.isEmpty(accCDUObj)&&accCDUObj.size()==1)
        return accCDUObj[0];
        return null; 
    }
    /**
    * @author Gaurav Gathania
    * @description - getCurrentUsageByAccount,
    * @input param  - String externalSystemName,String accountNo
    * @return param AtlasPubUsageServiceXmlschemaV1Web.serviceAgreementUsage_element
    **/
    public static HttpResponse getCurrentUsageByAccountV3(String externalSystemName,String accountNo)
    { 
        AtlasTestConstants.WEBSERVICE_NAME=AtlasConstants.CURRENT_DATA_USAGE;    
        OasisOpenOrgWssSecuritySecext.SecurityHeaderType Security = new OasisOpenOrgWssSecuritySecext.SecurityHeaderType(AtlasConstants.WEBSERVICE_USERNAME, AtlasConstants.WEBSERVICE_PWD);
        String requestXML='<?xml version="1.0" encoding="UTF-8"?>';
//      requestXML+='<env:Envelope xmlns:env="http://schemas.xmlsoap.org/soap/envelope/" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">';
        requestXML+='<env:Envelope xmlns:env="' + soapNS + '" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">';
        requestXML+='<env:Header>';
        requestXML+='<Security xmlns="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd" xmlns:wsu="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-utility-1.0.xsd">';
        requestXML+='<wsu:Timestamp>';
        requestXML+='<wsu:Created>'+Security.Timestamp.Created+'</wsu:Created>';
        requestXML+=' <wsu:Expires>'+Security.Timestamp.Expires+'</wsu:Expires>';
        requestXML+='</wsu:Timestamp>';
        requestXML+='<UsernameToken>';
        requestXML+=' <Username>'+AtlasConstants.WEBSERVICE_USERNAME+'</Username>';
        requestXML+=' <Password Type="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-username-token-profile-1.0#PasswordText">'+AtlasConstants.WEBSERVICE_PWD+'</Password>';
        requestXML+='<Nonce>'+Security.UsernameToken.Nonce+'</Nonce>';
        requestXML+='<wsu:Created>'+Security.UsernameToken.Created+'</wsu:Created>';
        requestXML+=' </UsernameToken>';
        requestXML+='</Security>';
        requestXML+='</env:Header>';
        requestXML+='<env:Body>';
//      requestXML+='<getCurrentUsageByAccount xmlns="http://www.viasat.com/XMLSchema/v3/webservice/PublicUsageWebService">';
        requestXML+='<getCurrentUsageByAccount xmlns="' + serviceNSPub + '">';
        requestXML+=' <externalSystemName>'+externalSystemName+'</externalSystemName>';
        requestXML+='<externalAccountReference>'+accountNo+'</externalAccountReference>';
        requestXML+='</getCurrentUsageByAccount>';
        requestXML+='</env:Body>';
        requestXML+='</env:Envelope>'; 
        HttpResponse res=executeHTTPCallout(AtlasUtility.getWebServiceHost(string.valueOF(AtlasUtility.randomNumberGenerator()))+wsSettings.get(AtlasConstants.CURRENT_USAGE_V3).End_Point__c,requestXML);
        return res; 
    }
    
    /**
    * @author Srikanth Kudumula
    * @description - getCurrentUsageByAccount for unlimited plan accounts,
    * @input param  - String externalSystemName,String accountNo, String internalAccountReference //added by AR:11/12/2015
    * @return param AtlasPubUsageServiceXmlschemaV1Web.serviceAgreementUsage_element
    **/
    public static HttpResponse getCurrentQuotaByAccount(String externalSystemName, String accountNo, String internalAccountReference)
    { 
        AtlasTestConstants.WEBSERVICE_NAME=AtlasConstants.CURRENT_DATA_USAGE;    
        OasisOpenOrgWssSecuritySecext.SecurityHeaderType Security = new OasisOpenOrgWssSecuritySecext.SecurityHeaderType(AtlasConstants.WEBSERVICE_USERNAME, AtlasConstants.WEBSERVICE_PWD);
        String requestXML='<?xml version="1.0" encoding="UTF-8"?>';
//      requestXML+='<env:Envelope xmlns:env="http://schemas.xmlsoap.org/soap/envelope/" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">';
        requestXML+='<env:Envelope xmlns:env="' + soapNS + '" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">';
        requestXML+='<env:Header>';
        requestXML+='<Security xmlns="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd" xmlns:wsu="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-utility-1.0.xsd">';
        requestXML+='<wsu:Timestamp>';
        requestXML+='<wsu:Created>'+Security.Timestamp.Created+'</wsu:Created>';
        requestXML+=' <wsu:Expires>'+Security.Timestamp.Expires+'</wsu:Expires>';
        requestXML+='</wsu:Timestamp>';
        requestXML+='<UsernameToken>';
        requestXML+=' <Username>'+AtlasConstants.WEBSERVICE_USERNAME+'</Username>';
        requestXML+=' <Password Type="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-username-token-profile-1.0#PasswordText">'+AtlasConstants.WEBSERVICE_PWD+'</Password>';
        requestXML+='<Nonce>'+Security.UsernameToken.Nonce+'</Nonce>';
        requestXML+='<wsu:Created>'+Security.UsernameToken.Created+'</wsu:Created>';
        requestXML+=' </UsernameToken>';
        requestXML+='</Security>';
        requestXML+='</env:Header>';
        requestXML+='<env:Body>';
//      requestXML+='<getCurrentQuotaByAccount xmlns="http://www.viasat.com/XMLSchema/v3/webservice/PublicUsageWebService">';
        requestXML+='<getCurrentQuotaByAccount xmlns="' + serviceNSPub + '">';
        requestXML+=' <externalSystemName>'+externalSystemName+'</externalSystemName>';
        requestXML+='<externalAccountReference>'+accountNo+'</externalAccountReference>';
        requestXML+='</getCurrentQuotaByAccount>';
        requestXML+='</env:Body>';
        requestXML+='</env:Envelope>'; 

        HttpResponse res=executeHTTPCallout(AtlasUtility.getWebServiceHost(string.valueOF(AtlasUtility.randomNumberGenerator()))+wsSettings.get(AtlasConstants.CURRENT_USAGE_V3).End_Point__c,requestXML);
        return res; 
    }
    
    /**
    * @author Gaurav Gathania
    * @description - getSubscriberCurrentPaymentMethod,
    * @input param  - String externalSystemName,String externalAccountReference
    * @return param AtlasFinServiceXmlschemaFinanceService.PaymentMethodHistoryItem
    */  
    public static AtlasFinServiceXmlschemaFinanceService.PaymentMethodHistoryItem getSubscriberCurrentPaymentMethod(String externalSystemName,String externalAccountReference)
    { AtlasTestConstants.WEBSERVICE_NAME=AtlasConstants.GET_SUBSCRIBER_PaymentMethod;   
        AtlasFinServiceWsdlV3FinanceService.FinanceServiceEndpoint paymentMethodStub=new AtlasFinServiceWsdlV3FinanceService.FinanceServiceEndpoint();
        paymentMethodStub.endpoint_x=AtlasUtility.getWebServiceHost(string.valueOF(AtlasUtility.randomNumberGenerator()))+wsSettings.get(AtlasConstants.FINANCE_SERVICE).End_Point__c; 
        paymentMethodStub.timeout_x=AtlasConstants.TIMEOUT;
        AtlasFinServiceXmlschemaFinanceService.PaymentMethodHistoryItem accPaymentMethod=null;
        try{
            accPaymentMethod=paymentMethodStub.getSubscriberCurrentPaymentMethod(externalSystemName,externalAccountReference);
            if(AtlasUtility.isEmpty(accPaymentMethod))
            throw new AtlasException.InvalidDataException(getExCode(AtlasConstants.PM_No_Data_Exp),getExValue(AtlasConstants.PM_No_Data_Exp));
        }catch(CalloutException e)
        {
            throw new AtlasException.CalloutException(getExCode(AtlasConstants.PM_Callout_Exp),getExValue(AtlasConstants.PM_Callout_Exp));
        }
        return accPaymentMethod;
    }

    /**
    * @author Gaurav Gathania
    * @description - getBillingHistory,
    * @input param  - String externalSystemName,String externalAccountReference
    * @return param AtlasFinServiceXmlschemaFinanceService.SubscriberInvoiceSummaries 
    */  
    public static AtlasFinServiceXmlschemaFinanceService.SubscriberInvoiceSummaries getBillingHistory(String externalSystemName,String externalAccountReference)
    { AtlasTestConstants.WEBSERVICE_NAME=AtlasConstants.BILLING_HISTORY;    
        AtlasFinServiceWsdlV3FinanceService.FinanceServiceEndpoint billStub=new AtlasFinServiceWsdlV3FinanceService.FinanceServiceEndpoint();
        billStub.endpoint_x=AtlasUtility.getWebServiceHost(string.valueOF(AtlasUtility.randomNumberGenerator()))+wsSettings.get(AtlasConstants.FINANCE_SERVICE).End_Point__c; 
        billStub.timeout_x=AtlasConstants.TIMEOUT;
        AtlasFinServiceXmlschemaFinanceService.SubscriberInvoiceSummaries accBillingHistory=null;
        try{
            accBillingHistory=billStub.getSubscriberInvoiceSummaries(externalSystemName,externalAccountReference,null,null,null);
            if(AtlasUtility.isEmpty(accBillingHistory))
            throw new AtlasException.InvalidDataException(getExCode(AtlasConstants.BH_No_Data_Exp),getExValue(AtlasConstants.BH_No_Data_Exp));
        }catch(CalloutException e)
        {   
            throw new AtlasException.CalloutException(getExCode(AtlasConstants.BH_Callout_Exp),getExValue(AtlasConstants.BH_Callout_Exp));
        }
        return accBillingHistory;
    }
    /**
    * @author Gaurav Gathania
    * @description - getBillingsnapShot,
    * @input param  - String externalSystemName,String externalAccountReference
    * @return param AtlasFinServiceXmlschemaFinanceService.SubscriberLedgerSummary
    */  
    public static AtlasFinServiceXmlschemaFinanceService.SubscriberLedgerSummary getBillingsnapShot(String externalSystemName,String externalAccountReference, String internalAccountReference)
    { 
        AtlasTestConstants.WEBSERVICE_NAME=AtlasConstants.BILLING_SNAPSHOT;  
        AtlasFinServiceWsdlV3FinanceService.FinanceServiceEndpoint ledgerStub=new AtlasFinServiceWsdlV3FinanceService.FinanceServiceEndpoint();
        ledgerStub.endpoint_x=AtlasUtility.getWebServiceHost(string.valueOF(AtlasUtility.randomNumberGenerator()))+wsSettings.get(AtlasConstants.FINANCE_SERVICE).End_Point__c; 
        ledgerStub.timeout_x=AtlasConstants.TIMEOUT;
        AtlasFinServiceXmlschemaFinanceService.SubscriberLedgerSummary LedgerSummary=null;
        try
        {   
            LedgerSummary=ledgerStub.getSubscriberLedgerSummary(externalSystemName,externalAccountReference);
            if(AtlasUtility.isEmpty(LedgerSummary))
            throw new AtlasException.InvalidDataException(getExCode(AtlasConstants.LS_No_Data_Exp),getExValue(AtlasConstants.LS_No_Data_Exp));
        }catch(CalloutException e)
        {
            throw new AtlasException.CalloutException(getExCode(AtlasConstants.LS_Callout_Exp),getExValue(AtlasConstants.LS_Callout_Exp));
        }
        return LedgerSummary;
    }
    /**
    * @author Gaurav Gathania
    * @description - getSubscriberInvoiceDetails,
    * @input param  - String externalSystemName,String externalAccountReference
    * @return param AtlasFinServiceXmlschemaFinanceService.SubscriberInvoiceDetails
    */  
    public static AtlasFinServiceXmlschemaFinanceService.SubscriberInvoiceDetails getSubscriberInvoiceDetails(String externalSystemName,String externalAccountReference,String externalInvoiceReference)
    {    
        AtlasTestConstants.WEBSERVICE_NAME=AtlasConstants.GET_SUBSCRIBER_INVOICE;  
        AtlasFinServiceWsdlV3FinanceService.FinanceServiceEndpoint subInvoiceStub=new AtlasFinServiceWsdlV3FinanceService.FinanceServiceEndpoint();
        subInvoiceStub.endpoint_x=AtlasUtility.getWebServiceHost(string.valueOF(AtlasUtility.randomNumberGenerator()))+wsSettings.get(AtlasConstants.FINANCE_SERVICE).End_Point__c; 
        subInvoiceStub.timeout_x=AtlasConstants.TIMEOUT;
        AtlasFinServiceXmlschemaFinanceService.SubscriberInvoiceDetails subInvoiceObj=null;
        try
        {   
            subInvoiceObj=subInvoiceStub.getSubscriberInvoiceDetails(externalSystemName,externalAccountReference,externalInvoiceReference);
            if(AtlasUtility.isEmpty(subInvoiceObj))
            throw new AtlasException.InvalidDataException(getExCode(AtlasConstants.ID_No_Data_Exp),getExValue(AtlasConstants.ID_No_Data_Exp));
            
        }catch(CalloutException e)
        {
            throw new AtlasException.CalloutException(getExCode(AtlasConstants.LS_Callout_Exp),getExValue(AtlasConstants.LS_Callout_Exp));
        }
        return subInvoiceObj;
    }
    /** -- Commenting out this method & reframing using HTTP Callout below - to fix the problem with new ACH requirement. 
            WSDL Callout doesnt catch the entire response when the callout is failed ---- 
            
    * @author Edwin Raymond
    * @description - updateCurrentPaymentSettings,
    * @input param  - AtlasTransactionDTO.updatedPaymentMethodDTO
    * @return param string
     
    public static String updateCurrentPaymentSettings(AtlasTransactionDTO.updatedPaymentMethodDTO newPaymentMethod)
    {   
        
        AtlasFinServiceWsdlV4FinanceService.FinanceServiceEndpoint updatePaymentSettingsStub=new AtlasFinServiceWsdlV4FinanceService.FinanceServiceEndpoint();
        updatePaymentSettingsStub.endpoint_x=AtlasUtility.getWebServiceHost(string.valueOF(AtlasUtility.randomNumberGenerator()))+wsSettings.get(AtlasConstants.FINANCE_SERVICEV4).End_Point__c;
        //updatePaymentSettingsStub.endpoint_x='http://requestb.in/yzfq0tyz';
        updatePaymentSettingsStub.timeout_x=AtlasConstants.TIMEOUT;
        updatePaymentSettingsStub.outputHttpHeaders_x=new Map<String,String>();
        String updatePaymentSettingsStubResponse=null;
        
        
        // For 'invoked by' xml element
        AtlasFinServiceXmlschemaV2PWSHeader.wildBlueHeader wbHeaderObj=new AtlasFinServiceXmlschemaV2PWSHeader.wildBlueHeader();
        AtlasFinServiceXmlschemaV2PWSHeader.invokedBy invokedByObj=new AtlasFinServiceXmlschemaV2PWSHeader.invokedBy();
        invokedByObj.application=AtlasConstants.INVOKED_BY_APP;
        invokedByObj.username=AtlasConstants.INVOKED_BY_USERNAME;
        wbHeaderObj.invokedBy=invokedByObj;
        updatePaymentSettingsStub.wildBlueHeader=wbHeaderObj;
        
        try
        {           
            updatePaymentSettingsStubResponse=updatePaymentSettingsStub.updatePaymentMethod(newPaymentMethod.externalSystemName,newPaymentMethod.externalAccountReference,newPaymentMethod.externalTransactionReference,newPaymentMethod.paymentMethod);            
            if(AtlasUtility.isEmpty(updatePaymentSettingsStubResponse)){
                AtlasDatabaseManager.insertTransaction('Billing','Update Payment Method','Update Customer Payment Settings','Failure',getExCode(AtlasConstants.UP_Input_Data_Exp) + ': ' + getExValue(AtlasConstants.UP_Input_Data_Exp),newPaymentMethod.externalAccountReference);
                throw new AtlasException.InputDataException(getExCode(AtlasConstants.UP_Input_Data_Exp),getExValue(AtlasConstants.UP_Input_Data_Exp));
            }
            system.debug('updatePaymentSettings');
            system.debug('---updatePaymentSettingsStubResponse--->'+ updatePaymentSettingsStubResponse);
            AtlasDatabaseManager.insertTransaction('Billing','Update Payment Method','Update Customer Payment Settings','Success','',newPaymentMethod.externalAccountReference);
        }catch(Exception e)
        {
            system.debug('---exception e ---> '+e);
             
            if(e.getMessage().contains('')){
                //AtlasDatabaseManager.insertTransaction('Billing','Update Payment Method','Update Customer Payment Settings','Failure',getExCode(AtlasConstants.UP_Input_Data_Exp) + ': ' + getExValue(AtlasConstants.UP_Input_Data_Exp),newPaymentMethod.externalAccountReference);
                throw new AtlasException.InputDataException(getExCode(AtlasConstants.UP_Input_Data_Exp),getExValue(AtlasConstants.UP_Input_Data_Exp));
            } else {
                //AtlasDatabaseManager.insertTransaction('Billing','Update Payment Method','Update Customer Payment Settings','Failure',getExCode(AtlasConstants.UP_Callout_Exp) + ': ' + getExValue(AtlasConstants.UP_Callout_Exp),newPaymentMethod.externalAccountReference);
                throw new AtlasException.CalloutException(getExCode(AtlasConstants.UP_Callout_Exp),getExValue(AtlasConstants.UP_Callout_Exp));
            } 
        }
        return updatePaymentSettingsStubResponse;
                         
    }
     */
    
    /**
    * @author Tejesh Kumar
    * @description - updateCurrentPaymentSettings,
    * @input param  - AtlasTransactionDTO.updatedPaymentMethodDTO
    * @return param string
    */ 
    public static String updateCurrentPaymentSettings(AtlasTransactionDTO.updatedPaymentMethodDTO newPaymentMethod)
    {           
        String extSysName= newPaymentMethod.externalSystemName;
        String extAccRef = newPaymentMethod.externalAccountReference;
        String externalTransactionReference = newPaymentMethod.externalTransactionReference;
        AtlasFinServiceXmlschemaV4FinanceService.PaymentMethodDetails paymentMethodDetails = newPaymentMethod.paymentMethod;
        AtlasFinServiceXmlschemaV4FinanceService.EFTDetails eftDetails = paymentMethodDetails.eft;
        AtlasFinServiceXmlschemaV4FinanceService.CreditCardDetails creditCardDetails = paymentMethodDetails.creditCard;
        String accHolder;
        String bankAccNo;
        String bankCode;
        String paymentType;
        String cardNo;
        String expDate;
        String methodOfPayment;
        String zipCode;
        String cvv;      
        if(!AtlasUtility.isEmpty(eftDetails)) {           
            accHolder = eftDetails.accountHolder; 
            bankAccNo = eftDetails.bankAccountNumber;
            bankCode  = eftDetails.bankCode;
            paymentType= eftDetails.paymentType;  
        }
        else {
            accHolder = creditCardDetails.accountHolder; 
            cardNo= creditCardDetails.cardNumber;           
            DateTime exDt = creditCardDetails.expirationDate;
            expDate = exDt.format('yyyy', 'GMT' );
            methodOfPayment= creditCardDetails.methodOfPayment;  
            zipCode= creditCardDetails.zipCode; 
            cvv= creditCardDetails.CVV; 
        }
        string result;
        OasisOpenOrgWssSecuritySecext.SecurityHeaderType Security = new OasisOpenOrgWssSecuritySecext.SecurityHeaderType(AtlasConstants.WEBSERVICE_USERNAME, AtlasConstants.WEBSERVICE_PWD);
        HttpRequest req = new HttpRequest(); 
        String wsEndPoint;
        if(!Test.isRunningTest())           
            wsEndPoint  = AtlasUtility.getWebServiceHost(string.valueOF(AtlasUtility.randomNumberGenerator()))+wsSettings.get(AtlasConstants.FINANCE_SERVICEV4).End_Point__c; 
            //wsEndPoint ='http://requestb.in/r246dor2';                                      
        else
            wsEndPoint='test';
            
        req.setMethod('POST');
        req.setEndpoint(wsEndPoint);
        req.setTimeout(80000);
        req.setHeader('Content-Type', 'text/xml; charset=utf-8');
        req.setHeader('SOAPAction', '');
        
        String[] securityHeaderArgs;
        if(!Test.isRunningTest()) 
            securityHeaderArgs = new String[] {Security.Timestamp.Created,Security.Timestamp.Expires,AtlasConstants.WEBSERVICE_USERNAME,AtlasConstants.WEBSERVICE_PWD,generateNounce(),Security.UsernameToken.Created};
        else
            securityHeaderArgs =new String[] {Security.Timestamp.Created,Security.Timestamp.Expires,'test','test',generateNounce(),Security.UsernameToken.Created};
            
        String secuirtyHeader = String.format(secuirtyHeaderTemplate, securityHeaderArgs);

        String wbHeader = '';
        String[] wbHeaderArgs = new String[] {'myexede','test'};
        wbHeader = String.format(wbHeaderTemplate, wbHeaderArgs);          
     
        String soapServiceCall = '';
        if(!AtlasUtility.isEmpty(eftDetails)) {
            String[] args1 = new String[] {extSysName,extAccRef,accHolder,bankAccNo,bankCode,paymentType};
            soapServiceCall = String.format(updatePaymentTemplate,args1); 
        }
        else {
            String[] args11 = new String[] {extSysName,extAccRef,externalTransactionReference,accHolder,cardNo,expDate,methodOfPayment,zipCode,cvv};
            soapServiceCall = String.format(updatePaymentTemplateCard ,args11) ; 
        }
        String[] args2 = new String[] {secuirtyHeader,wbHeader,soapServiceCall};
        String wsRequestMsg = String.format(soapEnvelopTemplate,args2);   
        req.setBody(wsRequestMsg);
        
        Http http = new Http();
        HTTPResponse res ;
        try {   
          system.debug('---req-- '+ req);  
          res = http.send(req);
          system.debug('---res.getBody()-- '+ res.getBody()); 
          wsReturn = res.getBody();
          searchResult = parseXML(wsReturn);   
          system.debug('---searchResult-- '+ searchResult);
          if(searchResult!= null && searchResult.get('result')!=null) 
              result = searchResult.get('result'); 
          else if(searchResult!= null && searchResult.get('code')!=null) {
              if(searchResult.get('detail')=='VALIDATION_ERROR') 
                  result = AtlasKeyValueStore__c.getInstance(AtlasConstants.PMU_UpdateBankAcc_FailureMessageCode).Value__c; 
              else
                  result = searchResult.get('code');                      
          }                             
       } 
       catch(Exception e) {
            System.debug('Error Invoking the service' + e.getMessage());
            if(e.getMessage().contains(''))
                throw new AtlasException.InputDataException(getExCode(AtlasConstants.UP_Input_Data_Exp),getExValue(AtlasConstants.UP_Input_Data_Exp));
            else 
                throw new AtlasException.CalloutException(getExCode(AtlasConstants.UP_Callout_Exp),getExValue(AtlasConstants.UP_Callout_Exp));
       }
       return result;                        
    }
    
    /**
    * @author Gaurav Gathania
    * @description - getSubscriberPaymentHistory,
    * @input param  - String externalSystemName,String externalAccountReference,Integer maxRows
    * @return param AtlasFinServiceXmlschemaFinanceService.PaymentHistoryItem
    */  
    public static AtlasFinServiceXmlschemaFinanceService.PaymentHistoryItem getSubscriberPaymentHistory(String externalSystemName,String externalAccountReference,Integer maxRows, String internalAccountReference)
    { 
        AtlasTestConstants.WEBSERVICE_NAME=AtlasConstants.GET_SUBSCRIBER_PAYMENTS;  
        AtlasFinServiceWsdlV3FinanceService.FinanceServiceEndpoint subpaymentStub=new AtlasFinServiceWsdlV3FinanceService.FinanceServiceEndpoint();
        subpaymentStub.endpoint_x=AtlasUtility.getWebServiceHost(string.valueOF(AtlasUtility.randomNumberGenerator()))+wsSettings.get(AtlasConstants.FINANCE_SERVICE).End_Point__c; 
        subpaymentStub.timeout_x=AtlasConstants.TIMEOUT;
        AtlasFinServiceXmlschemaFinanceService.PaymentHistoryItem [] subInvoiceObj=null;

        try
        {   
            subInvoiceObj=subpaymentStub.getSubscriberPaymentHistory(externalSystemName,externalAccountReference,maxRows);
            if(AtlasUtility.isEmpty(subInvoiceObj))
            throw new AtlasException.InputDataException(getExCode(AtlasConstants.PH_No_Data_Exp),getExValue(AtlasConstants.PH_No_Data_Exp));
        }catch(CalloutException e)
        {
            throw new AtlasException.CalloutException(getExCode(AtlasConstants.PH_Callout_Exp),getExValue(AtlasConstants.PH_Callout_Exp));
        }
        if(!AtlasUtility.isEmpty(subInvoiceObj)&&subInvoiceObj.size()>=1)
	        return subInvoiceObj[0];
        return null; 
    }

    /**
    * @author Gaurav Gathania
    * @description - updateCustomerInfo,
    * @input param  - AtlasTransactionDTO.UpdateCustomerInfoTxDTO custInfoObj
    * @return param String
    */  
    public static String updateCustomerInfo(AtlasTransactionDTO.UpdateCustomerInfoTxDTO custInfoObj)
    { 
        AtlasTestConstants.WEBSERVICE_NAME=AtlasConstants.UPDATE_CONTACT_INFO;  
        AtlasPubContactServWsdlV1.PublicContactServiceEndpoint contactStub=new AtlasPubContactServWsdlV1.PublicContactServiceEndpoint();
        contactStub.endpoint_x=AtlasUtility.getWebServiceHost(string.valueOF(AtlasUtility.randomNumberGenerator()))+wsSettings.get(AtlasConstants.UPDATE_CONTACT_SERVICE).End_Point__c;  
        //contactStub.endpoint_x='http://requestb.in/vm58d4vm'; 
        contactStub.timeout_x=AtlasConstants.TIMEOUT; 
        AtlasPubContactServXmlschema.CorrectedContact correctedContact=new AtlasPubContactServXmlschema.CorrectedContact();
        if(!AtlasUtility.isEmpty(custInfoObj.phone))
            correctedContact.primaryPhone=custInfoObj.phone;
        if(!AtlasUtility.isEmpty(custInfoObj.email))
            correctedContact.emailAddress=custInfoObj.email;
        if(!AtlasUtility.isEmpty(custInfoObj.secondaryPhone))
            correctedContact.secondaryPhone = custInfoObj.secondaryPhone;     
        correctedContact.billingAddress=null;
        if(!AtlasUtility.isEmpty(custInfoObj.billingAddress1)) {    
            correctedContact.billingAddress=new AtlasPubContactServXmlschema.CorrectedAddress();
            AtlasPubContactServXmlschemaCommonData.Address addObj=new AtlasPubContactServXmlschemaCommonData.Address();
            addObj.postalCode=custInfoObj.zipCode;
            addObj.region=custInfoObj.state;
            addObj.municipality=custInfoObj.city;
            addObj.countryCode=custInfoObj.countryCode;
            addObj.addressLine=new String[]{custInfoObj.billingAddress1};
            if(!AtlasUtility.isEmpty(custInfoObj.billingAddress2))
            addObj.addressLine.add(custInfoObj.billingAddress2);
            correctedContact.billingAddress.address=addObj;
            correctedContact.billingAddress.taxJurisdictionCode=custInfoObj.taxJurisdictionCode;
        }
         
        system.debug('UserName: ' + custInfoObj); 
        boolean emailChange = false;
        String previousEmailAddress = null;
        if(custInfoObj.oldStrUsername != null)
        {
            User userObj = [SELECT Id, Username, Contact.email from User where FederationIdentifier = :custInfoObj.oldStrUsername limit 1];
            if (userObj != null && userObj.contact != null && userObj.contact.email != null) {
                if (!userObj.contact.email.equalsIgnoreCase(correctedContact.emailAddress)) {
                    emailChange=true;
                    previousEmailAddress=userObj.contact.email;
                }
            }
        }
         
        String responseStr='';
		DateTime startTime;
        DateTime endTime;		
        String SessionID = UserInfo.getSessionId();

        try
        {   
            system.debug('Corrected Contact--->'+correctedContact);
			startTime = System.now();
            responseStr=contactStub.updateContacts(custInfoObj.externalAccountReference,custInfoObj.externalSystemName,AtlasConstants.SF_ORG_NAME+System.now(),correctedContact) ;
            endTime = System.now();
            System.debug('Update Customer Information - ' + responseStr);
            
            if(AtlasUtility.isEmpty(responseStr)|| responseStr.toUpperCase()!=AtlasConstants.UPDATE_CONTACT){
                AtlasDatabaseManager.insertTransaction('Customer Information','Account Information Change','Update Customer Information','Failure',getExCode(AtlasUtility.isEmpty(responseStr)+responseStr.toUpperCase()+':'+AtlasConstants.UC_Input_Data_Exp)+ ' - ' + responseStr.toUpperCase()+':'+getExValue(AtlasConstants.UC_Input_Data_Exp),custInfoObj.internalAccountReference);
                throw new AtlasException.InputDataException(getExCode(AtlasUtility.isEmpty(responseStr)+responseStr.toUpperCase()+':'+AtlasConstants.UC_Input_Data_Exp),responseStr.toUpperCase()+':'+getExValue(AtlasConstants.UC_Input_Data_Exp));
            }
               
            system.debug('Response Before SYNC--->'+responseStr);
            /* Calling method to sync updatedCustomerinfo to salesforce */
            AtlasSyncSFDC sync = new AtlasSyncSFDC();
            sync.syncContacts(custInfoObj); 
            system.debug('Response After SYNC--->'+responseStr); 
        }
        catch(CalloutException e)
        {
            System.debug('Error - Update Customer Information - ' + e.getMessage());
            
            if(e.getMessage().contains(AtlasConstants.BUY_MORE_REJECTED)){
                AtlasDatabaseManager.insertTransaction('Customer Information','Account Information Change','Update Customer Information','Failure',getExCode(AtlasConstants.UC_Input_Data_Exp) + ': ' + getExValue(AtlasConstants.UC_Input_Data_Exp),custInfoObj.internalAccountReference);
                throw new AtlasException.InputDataException(getExCode(AtlasConstants.UC_Input_Data_Exp),getExValue(AtlasConstants.UC_Input_Data_Exp));
            } else {
                AtlasDatabaseManager.insertTransaction('Customer Information','Account Information Change','Update Customer Information','Failure',AtlasUtility.isEmpty(responseStr)+responseStr.toUpperCase()+':'+getExCode(AtlasConstants.UC_Callout_Exp) + ' - ' + responseStr.toUpperCase()+':'+getExValue(AtlasConstants.UC_Callout_Exp),custInfoObj.internalAccountReference);
                throw new AtlasException.CalloutException(AtlasUtility.isEmpty(responseStr)+responseStr.toUpperCase()+':'+getExCode(AtlasConstants.UC_Callout_Exp),responseStr.toUpperCase()+':'+getExValue(AtlasConstants.UC_Callout_Exp));
            }            
        }
        system.debug('updateCustomerInfo');

        if (responseStr == 'SUCCESS')
            if (emailChange)
                AtlasDatabaseManager.insertTransaction('Customer Information',getExValue('CPNI_CONTACT_EMAIL'),'Contact Email Changed','Success','',custInfoObj.internalAccountReference,previousEmailAddress, sessionID, null, startTime, endTime);    
            else
                AtlasDatabaseManager.insertTransaction('Customer Information','Account Information Change','Update Customer Information','Success','',custInfoObj.internalAccountReference, null, sessionID, null, startTime, endTime);                   
        return responseStr; 
    }
    
    /**  -- Commenting out this method & reframing using HTTP Callout below - to fix the problem with new ACH requirement. 
            WSDL Callout doesnt catch the entire response when the callout is failed 
            Leaving the old methods commented so that we can revert anytime if we need the 
            old functionality(comment the HTTP methods and we can directly use WSDL methods, no return type is changed)---- 
            
      @author Edwin Raymond
    * @description - submitOneTimePaymentTransaction,
    * @input param  - AtlasTransactionDTO.oneTimePaymentDTO
    * @return param String 
    
    Public static string submitOneTimePaymentTransaction(AtlasTransactionDTO.oneTimePaymentDTO oneTimePayment)
    {   
        system.debug('---oneTimePayment---'+ oneTimePayment); 
        AtlasTestConstants.WEBSERVICE_NAME=AtlasConstants.MAKE_ONE_TIME_PAY;
        AtlasFinServiceWsdlV4FinanceService.FinanceServiceEndpoint submitOneTimePaymentStub=new AtlasFinServiceWsdlV4FinanceService.FinanceServiceEndpoint();
        submitOneTimePaymentStub.endpoint_x=AtlasUtility.getWebServiceHost(string.valueOF(AtlasUtility.randomNumberGenerator()))+wsSettings.get(AtlasConstants.FINANCE_SERVICEV4).End_Point__c;
        submitOneTimePaymentStub.timeout_x=AtlasConstants.TIMEOUT;
        String submitOneTimePaymentStubResponse=null;
        
        // For 'invoked by' xml element
        AtlasFinServiceXmlschemaV2PWSHeader.wildBlueHeader wbHeaderObj=new AtlasFinServiceXmlschemaV2PWSHeader.wildBlueHeader();
        AtlasFinServiceXmlschemaV2PWSHeader.invokedBy invokedByObj=new AtlasFinServiceXmlschemaV2PWSHeader.invokedBy();
        invokedByObj.application=AtlasConstants.INVOKED_BY_APP;
        invokedByObj.username=AtlasConstants.INVOKED_BY_USERNAME;
        wbHeaderObj.invokedBy=invokedByObj;
        submitOneTimePaymentStub.wildBlueHeader=wbHeaderObj;

        try
        {            
            submitOneTimePaymentStubResponse=submitOneTimePaymentStub.submitOneTimePayment(oneTimePayment.externalSystemName,oneTimePayment.externalAccountReference,oneTimePayment.externalTransactionReference,oneTimePayment.paymentMethodActionType,oneTimePayment.amount,oneTimePayment.paymentMethod);                     
            if(AtlasUtility.isEmpty(submitOneTimePaymentStubResponse) ){   
                //AtlasDatabaseManager.insertTransaction('Billing','Payment','Submit One-Time Payment','Failure',getExCode(AtlasConstants.OTP_Input_Data_Exp) + ': ' + getExValue(AtlasConstants.OTP_Input_Data_Exp),oneTimePayment.externalAccountReference);      
                throw new AtlasException.InputDataException(getExCode(AtlasConstants.OTP_Input_Data_Exp),getExValue(AtlasConstants.OTP_Input_Data_Exp));
            }
            AtlasDatabaseManager.insertTransaction('Billing','Payment','Submit One-Time Payment','Success','',oneTimePayment.externalAccountReference);
        }
        catch(Exception e)
        {   
            //AtlasDatabaseManager.insertTransaction('Billing','Payment','Submit One-Time Payment','Failure',getExCode(AtlasConstants.OTP_Callout_Exp) + ': ' + getExValue(AtlasConstants.OTP_Callout_Exp),oneTimePayment.externalAccountReference);
            System.debug('--- onetime payment Catch block - ' + e.getMessage());
            throw new AtlasException.CalloutException(getExCode(AtlasConstants.OTP_Callout_Exp),getExValue(AtlasConstants.OTP_Callout_Exp));
        }
        if(submitOneTimePaymentStubResponse !=null) {
            system.debug('---submitOneTimePaymentStubResponse---> '+submitOneTimePaymentStubResponse);
            return submitOneTimePaymentStubResponse;
        }
        return null; 
    }
    */
    
    /**
    * @author Tejesh Kumar
    * @description - submitOneTimePaymentTransaction,
    * @input param  - AtlasTransactionDTO.oneTimePaymentDTO
    * @return param String
    */ 
    Public static string submitOneTimePaymentTransaction(AtlasTransactionDTO.oneTimePaymentDTO oneTimePayment)
    {   
        String extSysName= oneTimePayment.externalSystemName;
        String extAccRef = oneTimePayment.externalAccountReference;
        String externalTransactionReference = oneTimePayment.externalTransactionReference;
        String paymentActionType = oneTimePayment.paymentMethodActionType;
        Double amountDouble = oneTimePayment.amount;
        String amount = String.valueOf(amountDouble);
        String accHolder;
        String bankAccNo;
        String bankCode;
        String paymentType;
        String cardNo;
        String expDate;
        String methodOfPayment;
        String zipCode;
        String cvv;
        AtlasFinServiceXmlschemaV4FinanceService.PaymentMethodDetails paymentMethodDetails = new AtlasFinServiceXmlschemaV4FinanceService.PaymentMethodDetails();
        AtlasFinServiceXmlschemaV4FinanceService.EFTDetails eftDetails = new AtlasFinServiceXmlschemaV4FinanceService.EFTDetails();  
        AtlasFinServiceXmlschemaV4FinanceService.CreditCardDetails creditCardDetails = new AtlasFinServiceXmlschemaV4FinanceService.CreditCardDetails(); 
        system.debug('---oneTimePayment---'+ oneTimePayment); 
        
        if(!AtlasUtility.isEmpty(oneTimePayment.paymentMethod)) {
            paymentMethodDetails = oneTimePayment.paymentMethod;
            eftDetails = paymentMethodDetails.eft;
            creditCardDetails = paymentMethodDetails.creditCard;      
            if(!AtlasUtility.isEmpty(eftDetails)) {           
                accHolder = eftDetails.accountHolder; 
                bankAccNo = eftDetails.bankAccountNumber;
                bankCode  = eftDetails.bankCode;
                paymentType= eftDetails.paymentType;  
            }
            else {
                accHolder = creditCardDetails.accountHolder; 
                cardNo= creditCardDetails.cardNumber;           
                DateTime exDt = creditCardDetails.expirationDate;
                expDate = exDt.format('yyyy', 'GMT' );
                methodOfPayment= creditCardDetails.methodOfPayment;  
                zipCode= creditCardDetails.zipCode; 
                cvv= creditCardDetails.CVV; 
            }
        }
        String submitOneTimePaymentStubResponse=null;
        
        OasisOpenOrgWssSecuritySecext.SecurityHeaderType Security = new OasisOpenOrgWssSecuritySecext.SecurityHeaderType(AtlasConstants.WEBSERVICE_USERNAME, AtlasConstants.WEBSERVICE_PWD);
        HttpRequest req = new HttpRequest(); 
        String wsEndPoint;
        if(!Test.isRunningTest())           
            wsEndPoint  = AtlasUtility.getWebServiceHost(string.valueOF(AtlasUtility.randomNumberGenerator()))+wsSettings.get(AtlasConstants.FINANCE_SERVICEV4).End_Point__c;
            //wsEndPoint ='http://requestb.in/1ip85lh1';                                      
        else
            wsEndPoint='test';
            
        req.setMethod('POST');
        req.setEndpoint(wsEndPoint);
        req.setTimeout(80000);
        req.setHeader('Content-Type', 'text/xml; charset=utf-8');
        req.setHeader('SOAPAction', '');
        
        String[] securityHeaderArgs;
        if(!Test.isRunningTest()) 
            securityHeaderArgs = new String[] {Security.Timestamp.Created,Security.Timestamp.Expires,AtlasConstants.WEBSERVICE_USERNAME,AtlasConstants.WEBSERVICE_PWD,generateNounce(),Security.UsernameToken.Created};
        else
            securityHeaderArgs =new String[] {Security.Timestamp.Created,Security.Timestamp.Expires,'test','test',generateNounce(),Security.UsernameToken.Created};
            
        String secuirtyHeader = String.format(secuirtyHeaderTemplate, securityHeaderArgs);

        String wbHeader = '';
        String[] wbHeaderArgs = new String[] {'myexede','test'};
        wbHeader = String.format(wbHeaderTemplate, wbHeaderArgs);  
        
        String soapServiceCall = '';
        
        if(!AtlasUtility.isEmpty(oneTimePayment.paymentMethod)) {
            if(!AtlasUtility.isEmpty(eftDetails)) {
                String[] args1 = new String[] {extSysName,extAccRef,paymentActionType,amount,accHolder,bankAccNo,bankCode,paymentType};
                soapServiceCall = String.format(oneTimePaymentTemplateCheck,args1); 
            }
            else {
                String[] args11 = new String[] {extSysName,extAccRef,paymentActionType,amount,accHolder,cardNo,expDate,methodOfPayment,zipCode,cvv};
                soapServiceCall = String.format(oneTimePaymentTemplateCard ,args11) ; 
            }
        }
        else {
            String[] args12 = new String[] {extSysName,extAccRef,paymentActionType,amount};
            soapServiceCall = String.format(oneTimePaymentRecurring,args12); 
        }

        String[] args2 = new String[] {secuirtyHeader,wbHeader,soapServiceCall};
        String wsRequestMsg = String.format(soapEnvelopTemplate,args2);   
        req.setBody(wsRequestMsg);

        Http http = new Http();
        HTTPResponse res ;
        try {   
          system.debug('---req-- '+ req);  
          res = http.send(req);
          system.debug('---res.getBody()-- '+ res.getBody()); 
          wsReturn = res.getBody();
          searchResult = parseXML(wsReturn);   
          system.debug('---searchResult-- '+ searchResult);
          if(searchResult!= null && searchResult.get('result')!=null) {
              submitOneTimePaymentStubResponse = searchResult.get('result');
              AtlasDatabaseManager.insertTransaction('Billing','Payment','Submit One-Time Payment','Success','',oneTimePayment.externalAccountReference);
          }              
          else if(searchResult!= null && searchResult.get('code')!=null) {
              if(searchResult.get('detail')=='VALIDATION_ERROR') 
                  submitOneTimePaymentStubResponse = AtlasKeyValueStore__c.getInstance(AtlasConstants.PMU_UpdateBankAcc_FailureMessageCode).Value__c; 
              else {
                  submitOneTimePaymentStubResponse = searchResult.get('code');
                  AtlasDatabaseManager.insertTransaction('Billing','Payment','Submit One-Time Payment','Success','',oneTimePayment.externalAccountReference);
              }                      
          }                               
        } 
        catch(Exception e) {
            System.debug('--- onetime payment Catch block - ' + e.getMessage());
            throw new AtlasException.CalloutException(getExCode(AtlasConstants.OTP_Callout_Exp),getExValue(AtlasConstants.OTP_Callout_Exp));
       }  
       return submitOneTimePaymentStubResponse;
    }
   
    /** -- Commenting out this method & reframing using HTTP Callout below - to fix the problem with new ACH requirement. 
            WSDL Callout doesnt catch the entire response when the callout is failed 
            Leaving the old methods commented so that we can revert anytime if we need the 
            old functionality(comment the HTTP methods and we can directly use WSDL methods, no return type is changed)----
            
    * @author Tejesh Kumar
    * @description - submitOneTimePaymentTransactionAutoResume,
    * @input param  - AtlasTransactionDTO.oneTimePaymentDTOForAutoResume
    * @return param String
    
    public static AtlasFinServiceXmlschemaV4FinanceService.OneTimePaymentAutoResumeResults submitOneTimePaymentAutoResume(AtlasTransactionDTO.oneTimePaymentDTOForAutoResume oneTimePayment)
    {   
        AtlasTestConstants.WEBSERVICE_NAME=AtlasConstants.MAKE_ONE_TIME_PAY;
        AtlasFinServiceWsdlV4FinanceService.FinanceServiceEndpoint submitOneTimePaymentStub=new AtlasFinServiceWsdlV4FinanceService.FinanceServiceEndpoint();
        submitOneTimePaymentStub.endpoint_x=AtlasUtility.getWebServiceHost(string.valueOF(AtlasUtility.randomNumberGenerator()))+wsSettings.get(AtlasConstants.FINANCE_SERVICEV4).End_Point__c;
        submitOneTimePaymentStub.timeout_x=AtlasConstants.TIMEOUT;
        // For 'invoked by' xml element
        AtlasFinServiceXmlschemaV2PWSHeader.wildBlueHeader wbHeaderObj=new AtlasFinServiceXmlschemaV2PWSHeader.wildBlueHeader();
        AtlasFinServiceXmlschemaV2PWSHeader.invokedBy invokedByObj=new AtlasFinServiceXmlschemaV2PWSHeader.invokedBy();
        invokedByObj.application=AtlasConstants.INVOKED_BY_APP;
        invokedByObj.username=AtlasConstants.INVOKED_BY_USERNAME;
        wbHeaderObj.invokedBy=invokedByObj;
        submitOneTimePaymentStub.wildBlueHeader=wbHeaderObj;
                
        AtlasFinServiceXmlschemaV4FinanceService.OneTimePaymentAutoResumeResults response= null;
        try
        {            
            response=submitOneTimePaymentStub.submitOneTimePaymentAutoResume(oneTimePayment.externalSystemName,oneTimePayment.externalAccountReference,oneTimePayment.externalTransactionReference,oneTimePayment.paymentMethodActionType,oneTimePayment.amount,oneTimePayment.paymentMethod);                     
            if(AtlasUtility.isEmpty(response) ){   
                //AtlasDatabaseManager.insertTransaction('Billing','Payment','Submit One-Time Payment','Failure',getExCode(AtlasConstants.OTP_Input_Data_Exp) + ': ' + getExValue(AtlasConstants.OTP_Input_Data_Exp),oneTimePayment.externalAccountReference);      
                throw new AtlasException.InputDataException(getExCode(AtlasConstants.OTP_Input_Data_Exp),getExValue(AtlasConstants.OTP_Input_Data_Exp));
            }
            AtlasDatabaseManager.insertTransaction('Billing','Payment','Submit One-Time Payment','Success','',oneTimePayment.externalAccountReference);
        }
        catch(Exception e)
        {   
            //AtlasDatabaseManager.insertTransaction('Billing','Payment','Submit One-Time Payment','Failure',getExCode(AtlasConstants.OTP_Callout_Exp) + ': ' + getExValue(AtlasConstants.OTP_Callout_Exp),oneTimePayment.externalAccountReference);
            System.debug('--- onetime payment auto resume Catch block - ' + e.getMessage());
            throw new AtlasException.CalloutException(getExCode(AtlasConstants.OTP_Callout_Exp),getExValue(AtlasConstants.OTP_Callout_Exp));
        }
        if(response!=null) {
            system.debug('---submit onetime auto resume response---> '+response); 
            return response;              
        }
        return null;
    }
    */
    /**
    * @author Tejesh Kumar
    * @description - submitOneTimePaymentTransactionAutoResume,
    * @input param  - AtlasTransactionDTO.oneTimePaymentDTOForAutoResume
    * @return param String
    */
    public static AtlasFinServiceXmlschemaV4FinanceService.OneTimePaymentAutoResumeResults submitOneTimePaymentAutoResume(AtlasTransactionDTO.oneTimePaymentDTOForAutoResume oneTimePayment)
    {           
        String extSysName= oneTimePayment.externalSystemName;
        String extAccRef = oneTimePayment.externalAccountReference;
        String externalTransactionReference = oneTimePayment.externalTransactionReference;
        String paymentActionType = oneTimePayment.paymentMethodActionType;
        Double amountDouble = oneTimePayment.amount;
        String amount = String.valueOf(amountDouble);
        AtlasFinServiceXmlschemaV4FinanceService.PaymentMethodDetails paymentMethodDetails = new AtlasFinServiceXmlschemaV4FinanceService.PaymentMethodDetails();
        AtlasFinServiceXmlschemaV4FinanceService.EFTDetails eftDetails = new AtlasFinServiceXmlschemaV4FinanceService.EFTDetails();
        AtlasFinServiceXmlschemaV4FinanceService.CreditCardDetails creditCardDetails = new AtlasFinServiceXmlschemaV4FinanceService.CreditCardDetails();
        String accHolder;
        String bankAccNo;
        String bankCode;
        String paymentType;
        String cardNo;
        String expDate;
        String methodOfPayment;
        String zipCode;
        String cvv;      
        system.debug('---oneTimePayment---'+ oneTimePayment);        
        if(!AtlasUtility.isEmpty(oneTimePayment.paymentMethod)) {
            paymentMethodDetails = oneTimePayment.paymentMethod;
            eftDetails = paymentMethodDetails.eft;
            creditCardDetails = paymentMethodDetails.creditCard;
            if(!AtlasUtility.isEmpty(eftDetails)) {           
                accHolder = eftDetails.accountHolder; 
                bankAccNo = eftDetails.bankAccountNumber;
                bankCode  = eftDetails.bankCode;
                paymentType= eftDetails.paymentType;  
            }
            else {
                accHolder = creditCardDetails.accountHolder; 
                cardNo= creditCardDetails.cardNumber;           
                DateTime exDt = creditCardDetails.expirationDate;
                expDate = exDt.format('yyyy', 'GMT' );
                methodOfPayment= creditCardDetails.methodOfPayment;  
                zipCode= creditCardDetails.zipCode; 
                cvv= creditCardDetails.CVV; 
            }
        }
        AtlasFinServiceXmlschemaV4FinanceService.OneTimePaymentAutoResumeResults response= new AtlasFinServiceXmlschemaV4FinanceService.OneTimePaymentAutoResumeResults();
        OasisOpenOrgWssSecuritySecext.SecurityHeaderType Security = new OasisOpenOrgWssSecuritySecext.SecurityHeaderType(AtlasConstants.WEBSERVICE_USERNAME, AtlasConstants.WEBSERVICE_PWD);
        HttpRequest req = new HttpRequest(); 
        String wsEndPoint;
        if(!Test.isRunningTest())           
            wsEndPoint  = AtlasUtility.getWebServiceHost(string.valueOF(AtlasUtility.randomNumberGenerator()))+wsSettings.get(AtlasConstants.FINANCE_SERVICEV4).End_Point__c;
            //wsEndPoint ='http://requestb.in/12a0eae1';                                      
        else
            wsEndPoint='test';
        
        req.setMethod('POST');
        req.setEndpoint(wsEndPoint);
        req.setTimeout(80000);
        req.setHeader('Content-Type', 'text/xml; charset=utf-8');
        req.setHeader('SOAPAction', '');
        
        String[] securityHeaderArgs;
        if(!Test.isRunningTest()) 
            securityHeaderArgs = new String[] {Security.Timestamp.Created,Security.Timestamp.Expires,AtlasConstants.WEBSERVICE_USERNAME,AtlasConstants.WEBSERVICE_PWD,generateNounce(),Security.UsernameToken.Created};
        else
            securityHeaderArgs =new String[] {Security.Timestamp.Created,Security.Timestamp.Expires,'test','test',generateNounce(),Security.UsernameToken.Created};
            
        String secuirtyHeader = String.format(secuirtyHeaderTemplate, securityHeaderArgs);

        String wbHeader = '';
        String[] wbHeaderArgs = new String[] {'myexede','test'};
        wbHeader = String.format(wbHeaderTemplate, wbHeaderArgs);  
        
        String soapServiceCall = '';
        if(!AtlasUtility.isEmpty(oneTimePayment.paymentMethod)) {
            if(!AtlasUtility.isEmpty(eftDetails)) {
                String[] args1 = new String[] {extSysName,extAccRef,paymentActionType,amount,accHolder,bankAccNo,bankCode,paymentType};
                soapServiceCall = String.format(oneTimeAutoResumeTemplateCheck,args1); 
            }
            else {
                String[] args11 = new String[] {extSysName,extAccRef,paymentActionType,amount,accHolder,cardNo,expDate,methodOfPayment,zipCode,cvv};
                soapServiceCall = String.format(oneTimeAutoResumeTemplateCard,args11) ; 
            }
        }
        else {
            String[] args12 = new String[] {extSysName,extAccRef,paymentActionType,amount};
            soapServiceCall = String.format(oneTimePaymentAutoResRecurring,args12) ; 
        }
            
        String[] args2 = new String[] {secuirtyHeader,wbHeader,soapServiceCall};
        String wsRequestMsg = String.format(soapEnvelopTemplate,args2);   
        req.setBody(wsRequestMsg);

        Http http = new Http();
        HTTPResponse res ;
        try {   
          system.debug('---req-- '+ req);  
          res = http.send(req);
          system.debug('---res.getBody()-- '+ res.getBody()); 
          wsReturn = res.getBody();
          searchResult = parseXML(wsReturn);   
          system.debug('---searchResult-- '+ searchResult);
          if(searchResult!= null && searchResult.get('paymentResult')!=null && searchResult.get('autoResumeResult')!=null) {
              response.paymentResult = searchResult.get('paymentResult'); 
              response.autoResumeResult= searchResult.get('autoResumeResult');
              AtlasDatabaseManager.insertTransaction('Billing','Payment','Submit One-Time Payment','Success','',oneTimePayment.externalAccountReference);   
          }
          else if(searchResult!= null && searchResult.get('code')!=null) {
              if(searchResult.get('detail')=='VALIDATION_ERROR') 
                  response.paymentResult= AtlasKeyValueStore__c.getInstance(AtlasConstants.PMU_UpdateBankAcc_FailureMessageCode).Value__c; 
              else {
                  response.paymentResult= searchResult.get('code');
                  AtlasDatabaseManager.insertTransaction('Billing','Payment','Submit One-Time Payment','Success','',oneTimePayment.externalAccountReference);
              }                           
          }                                  
        } 
        catch(Exception e) {
            System.debug('--- onetime payment auto resume Catch block - ' + e.getMessage());
            throw new AtlasException.CalloutException(getExCode(AtlasConstants.OTP_Callout_Exp),getExValue(AtlasConstants.OTP_Callout_Exp));
       }        
       return response;
    }
    
    /**
    * @author Gaurav Gathania
    * @description - retieveInvoiceOneTimeCharges,
    * @input param  - String externalSystemName,String externalAccountReference
    * @return param AtlasFinServiceXmlschemaFinanceService.OneTimeChargeHistoryItem
    */ 
    Public static AtlasFinServiceXmlschemaFinanceService.OneTimeChargeHistoryItem retieveInvoiceOneTimeCharges(String externalSystemName,String externalAccountReference)
    {          
        AtlasFinServiceWsdlV3FinanceService.FinanceServiceEndpoint retieveInvoiceOneTimeChargesStub=new AtlasFinServiceWsdlV3FinanceService.FinanceServiceEndpoint();
        retieveInvoiceOneTimeChargesStub.endpoint_x=AtlasUtility.getWebServiceHost(string.valueOF(AtlasUtility.randomNumberGenerator()))+wsSettings.get(AtlasConstants.FINANCE_SERVICE).End_Point__c;
        retieveInvoiceOneTimeChargesStub.timeout_x=AtlasConstants.TIMEOUT;
        AtlasFinServiceXmlschemaFinanceService.OneTimeChargeHistoryItem retieveInvoiceOneTimeChargesStubResponse=null;
        try
        {
            retieveInvoiceOneTimeChargesStubResponse=retieveInvoiceOneTimeChargesStub.getSubscriberOneTimeChargeHistory(externalSystemName,externalAccountReference,null);
            if(AtlasUtility.isEmpty(retieveInvoiceOneTimeChargesStubResponse))
            throw new AtlasException.InputDataException(getExCode(AtlasConstants.OTC_No_Data_Exp),getExValue(AtlasConstants.OTC_No_Data_Exp));
        }catch(CalloutException e)
        {
            throw new AtlasException.CalloutException(getExCode(AtlasConstants.OTC_Callout_Exp),getExValue(AtlasConstants.OTC_Callout_Exp));
        }
        return retieveInvoiceOneTimeChargesStubResponse;
    }
    /**
    * @author Gaurav Gathania
    * @description - getALaCartePackages,
    * @input param  - String externalSystemName,String externalAccountReference,String transactionType
    * @return param AtlasPubCatlogServiceXmlschemaV2.Package_Test[]
    */
    Public static AtlasPubCatlogServiceXmlschemaV2.Package_Test[] getALaCartePackages(String externalSystemName,String externalAccountReference,String transactionType)
    {
        AtlasPubCatlogServiceWsdlV2.PublicCatalogServiceEndpoint catlogStub=new AtlasPubCatlogServiceWsdlV2.PublicCatalogServiceEndpoint ();
        catlogStub.endpoint_x=AtlasUtility.getWebServiceHost(string.valueOF(AtlasUtility.randomNumberGenerator()))+wsSettings.get(AtlasConstants.PUBLIC_CATALOG_SERVICE).End_Point__c;
        catlogStub.timeout_x=AtlasConstants.TIMEOUT;
        AtlasPubCatlogServiceXmlschemaPWSHeader.wildBlueHeader wbHeaderObj=new AtlasPubCatlogServiceXmlschemaPWSHeader.wildBlueHeader();
        AtlasPubCatlogServiceXmlschemaPWSHeader.invokedBy invokedByObj=new AtlasPubCatlogServiceXmlschemaPWSHeader.invokedBy();
        invokedByObj.application=AtlasConstants.INVOKED_BY_APP;
        invokedByObj.username=AtlasConstants.INVOKED_BY_USERNAME;
        wbHeaderObj.invokedBy=invokedByObj;
        catlogStub.wildBlueHeader=wbHeaderObj;
        AtlasPubCatlogServiceXmlschemaV2.Package_Test[] catResponse;
        try{
            catResponse=catlogStub.getALaCartePackages(externalSystemName,externalAccountReference,transactionType);
            if(AtlasUtility.isEmpty(catResponse))
            throw new AtlasException.InputDataException(getExCode(AtlasConstants.PKG_No_Data_Exp),getExValue(AtlasConstants.PKG_No_Data_Exp));
        }catch(CalloutException e)
        {
            throw new AtlasException.CalloutException(getExCode(AtlasConstants.PKG_Callout_Exp),getExValue(AtlasConstants.PKG_Callout_Exp));
        }
        return catResponse;
    }
    /**
    * @author Edwin Raymond
    * @description - getInvoiceCDRDetails,
    * @input param  - String externalSystemName,String externalAccountReference,String[] externalInvoiceReferences,Integer maxRows
    * @return param AtlasFinServiceXmlschemaFinanceService.EventHistoryItem[]
    */
    Public static AtlasFinServiceXmlschemaFinanceService.EventHistoryItem[] getInvoiceCDRDetails(String externalSystemName,String externalAccountReference,String[] externalInvoiceReferences,Integer maxRows)
    {  
        AtlasFinServiceWsdlV3FinanceService.FinanceServiceEndpoint retieveInvoiceCDRDetailsStub = new AtlasFinServiceWsdlV3FinanceService.FinanceServiceEndpoint();
        retieveInvoiceCDRDetailsStub.endpoint_x=AtlasUtility.getWebServiceHost(string.valueOF(AtlasUtility.randomNumberGenerator()))+wsSettings.get(AtlasConstants.FINANCE_SERVICE).End_Point__c;
        retieveInvoiceCDRDetailsStub.timeout_x=AtlasConstants.TIMEOUT;                
        AtlasFinServiceXmlschemaFinanceService.EventHistoryItem[] retieveInvoiceCDRDetailsResponse;
        try{
            retieveInvoiceCDRDetailsResponse=retieveInvoiceCDRDetailsStub.getSubscriberEventHistory(externalSystemName,externalAccountReference,externalInvoiceReferences,maxRows);
            if(AtlasUtility.isEmpty(retieveInvoiceCDRDetailsResponse))
            throw new AtlasException.InputDataException(getExCode(AtlasConstants.CDR_No_Data_Exp),getExValue(AtlasConstants.CDR_No_Data_Exp));
        }catch(CalloutException e)
        {   
            throw new AtlasException.CalloutException(getExCode(AtlasConstants.CDR_Callout_Exp),getExValue(AtlasConstants.CDR_Callout_Exp));
        }
        return retieveInvoiceCDRDetailsResponse;
    }
    /**
    * @author Gaurav Gathania
    * @description - getALaCartePackages,addUsageQuota
    * @input param
    *       @ String externalSystemName
    *       @ String externalTransactionReference
    *       @ String externalServiceAgreementReference
    *       @ String responseURL
    *       @ String salesChannel
    *       @ String enteredBy
    *       @ String soldBy
    *       @ String marketingSourceCode
    *       @ String referralSourceCode
    *       @ String note
    @   @return param AtlasTransServiceXmlschemav2.UsageQuotaItem[] addUsageQuotaItem
    */    
    Public static String addUsageQuota(AtlasTransactionDTO.AddUsageQuotaDTO addQuotaObj) 
    {   
    	AtlasTestConstants.WEBSERVICE_NAME=AtlasConstants.BUY_MORE;
        AtlasTransServiceWsdlTransService.TransactionServiceEndpoint addUsageQuotaStub=new AtlasTransServiceWsdlTransService.TransactionServiceEndpoint();
        addUsageQuotaStub.endpoint_x=AtlasUtility.getWebServiceHost(string.valueOF(AtlasUtility.randomNumberGenerator()))+wsSettings.get(AtlasConstants.TX_SERVICE).End_Point__c;
        //addUsageQuotaStub.endpoint_x='http://requestb.in/14ujwkh1';
        addUsageQuotaStub.timeout_x=AtlasConstants.TIMEOUT;
        String addUsageQuotaResponse=null;
        AtlasTransServiceXmlschemav2.UsageQuotaItem[] addUsageQuotaItemList;
        integer count=0;
        if(!AtlasUtility.isEmpty(addQuotaObj)&&!AtlasUtility.isEmpty(addQuotaObj.usageItems))
        {
            addUsageQuotaItemList=new AtlasTransServiceXmlschemav2.UsageQuotaItem[]{};
            AtlasTransServiceXmlschemav2.UsageQuotaItem uTemp;
            for(AtlasTransactionDTO.UsageItems u :addQuotaObj.usageItems)
            { 
                uTemp=new AtlasTransServiceXmlschemav2.UsageQuotaItem();
                uTemp.externalOneTimeChargeReference=u.externalOneTimeChargeReference;
                uTemp.masterCatalogNumber=u.masterCatalogNumber;
                addUsageQuotaItemList.add(uTemp);
                count = count + 1;
            }
        }
        try
        {              
            addUsageQuotaResponse=addUsageQuotaStub.addUsageQuota(addQuotaObj.externalSystemName,addQuotaObj.externalTransactionReference,addQuotaObj.externalServiceAgreementReference,addQuotaObj.responseURL,addQuotaObj.salesChannel,addQuotaObj.enteredBy,addQuotaObj.soldBy,addQuotaObj.marketingSourceCode,addQuotaObj.referralSourceCode,addQuotaObj.note,addUsageQuotaItemList);                        
            if(AtlasUtility.isEmpty(addUsageQuotaResponse)){
                AtlasDatabaseManager.insertTransaction('Buy More','Buy More Data','Buy More Data - ' + count + 'GB','Failure',getExCode(AtlasConstants.AUQ_Input_Data_Exp) + ': ' + getExValue(AtlasConstants.AUQ_Input_Data_Exp),'');
                throw new AtlasException.InputDataException(getExCode(AtlasConstants.AUQ_Input_Data_Exp),getExValue(AtlasConstants.AUQ_Input_Data_Exp));
            }
            AtlasDatabaseManager.insertTransaction('Buy More','Buy More Data','Buy More Data - ' + count + 'GB','Success','',addQuotaObj.externalServiceAgreementReference);
        }
        catch(CalloutException e)
        {   
        	System.debug(e.getMessage());
            //AR 11/18/2015: uncommented insertTransaction to capture the failures for Instrumentation project 
            AtlasDatabaseManager.insertTransaction('Buy More','Buy More Data','Callout Failure - Buy More Data - ' + count + 'GB','Failure',getExCode(AtlasConstants.AUQ_Callout_Exp) + ': ' + getExValue(AtlasConstants.AUQ_Callout_Exp),addQuotaObj.externalServiceAgreementReference);
            throw new AtlasException.CalloutException(getExCode(AtlasConstants.AUQ_Callout_Exp),getExValue(AtlasConstants.AUQ_Callout_Exp));
        }
        system.debug('---addUsageQuotaResponse--> '+addUsageQuotaResponse);
        return addUsageQuotaResponse;
    }
    /**
    * @author Gaurav Gathania
    * @description - getExCode - Reduction of characters to call the utility
    * @input param String name
    * @return param String
    */    
    public static String getExCode(String name)
    {
        return AtlasUtility.getMapCode(name);
    }
    /**
    * @author Gaurav Gathania
    * @description - getExValue - Reduction of characters to call the utility
    * @input param String name
    * @return param String
    */  
    public static String getExValue(String name)
    {
        return AtlasUtility.getMapValue(name);
    }
    /**
    * @author Gaurav Gathania
    * @description - executeHTTPCallout - Simple method to Fallback incase of SOAP Errors
    * @input param String wsEndPoint ,String reqSOAPXML
    * @return param HttpResponse
    */  
    public static HttpResponse executeHTTPCallout(String wsEndPoint ,String reqSOAPXML)
    {
        HttpRequest req=new HttpRequest();
        req.setMethod('POST');
        req.setEndpoint(wsEndPoint);
        req.setTimeout(AtlasConstants.TIMEOUT);
        req.setHeader('Content-Type', 'text/xml; charset=utf-8');
        req.setHeader('SOAPAction', '');
        req.setBody(reqSOAPXML);
        Http http=new Http();
        HTTPResponse res ;
        try{
            res=http.send(req);  
        }catch(Exception e)
        {
            
        }
        return res ;
    }
    /**
    * @author Shiva shankar
    * @description - searchCustomer, taking an input parameter of type String MacAddress
    * @input param  - String accountNo
    * @return param AtlasCustomerSearchWS.customerInfoBean
    */   
    public static AtlasCustomerSearchWS.customerInfoBean searchCustomerByMacAddress(String MacAddress)
    { 
        //AtlasTestConstants.WEBSERVICE_NAME=AtlasConstants.CUSTOMER_SEARCH;  
        AtlasCustomerSearchWS.CustomerSearchImplV2Port accStub=new AtlasCustomerSearchWS.CustomerSearchImplV2Port();
        accStub.endpoint_x=AtlasUtility.getWebServiceHost(string.valueOF(AtlasUtility.randomNumberGenerator()))+wsSettings.get(AtlasConstants.CUSTOMER_SEARCH).End_Point__c;
        accStub.timeout_x=AtlasConstants.TIMEOUT;
        AtlasCustomerSearchWS.customerInfoBean[] customerArray=null;
        try{ 
            customerArray=accStub.findCustomersByMacAddress(MacAddress);
            if(AtlasUtility.isEmpty(customerArray))
            throw new AtlasException.InvalidDataException(getExCode(AtlasConstants.SC_No_Data_Exp),getExValue(AtlasConstants.SC_No_Data_Exp));
        }catch(CalloutException e)
        {
            throw new AtlasException.CalloutException(getExCode(AtlasConstants.SC_Callout_Exp),getExValue(AtlasConstants.SC_Callout_Exp));
        }
        if(!AtlasUtility.isEmpty(customerArray)&&customerArray.size()==1)
        return customerArray[0];
        return null; 
    }
    
    /**
    * @author Shiva Shankar
    * @description - validate username
    * @input param  - String username or mac # or account #
    * @return param AtlasSSOWS.getSubscribersResponse_element
    */   
    public static AtlasSSOWS.getSubscribersResponse_element getSSOSubscribers(string accountNumber, String MAC, String subscriberAttribute, String subscriberattributevalue)
    { 
        AtlasSSOWS.ATLASSSOAPIPort accStub=new AtlasSSOWS.ATLASSSOAPIPort();
        accStub.endpoint_x=AtlasUtility.getSSOWebServiceEndPoint(string.valueOF(AtlasUtility.randomNumberGenerator()))+wsSSOSettings.get(AtlasConstants.GET_SUBSCRIBER).EndPoint__c;
        //accStub.endpoint_x='http://requestb.in/tuolpetu';
        accStub.timeout_x=AtlasConstants.TIMEOUT;
        AtlasSSOWS.getSubscribersResponse_element getsubscriberResponse=null;
        try{ 
            getsubscriberResponse=accStub.getSubscribers(AtlasUtility.getMapValue(AtlasConstants.ATLAS_SSO_API_UNAME),AtlasUtility.getMapValue(AtlasConstants.ATLAS_SSO_API_PWD),accountNumber,MAC,subscriberAttribute,subscriberattributevalue,'',5,0);
            if(AtlasUtility.isEmpty(getsubscriberResponse))
            throw new AtlasException.InvalidDataException(getExCode(AtlasConstants.SC_No_Data_Exp),getExValue(AtlasConstants.SC_No_Data_Exp));
        }catch(CalloutException e)
        {
            throw new AtlasException.CalloutException(getExCode(AtlasConstants.SC_Callout_Exp),getExValue(AtlasConstants.SC_Callout_Exp));
        }
        if(!AtlasUtility.isEmpty(getsubscriberResponse))
        return getsubscriberResponse;
        return null;
    }
    
    /**
    * @author Shiva Shankar
    * @description - validate username
    * @input param  - String username or mac # or account #
    * @return param AtlasSSOWS.getSubscribersResponse_element
    */   
    public static AtlasSSOWS.getSubscriberResponse_element getSSOSubscriber(long ld)
    { 
        AtlasSSOWS.ATLASSSOAPIPort accStub=new AtlasSSOWS.ATLASSSOAPIPort();
        accStub.endpoint_x=AtlasUtility.getSSOWebServiceEndPoint(string.valueOF(AtlasUtility.randomNumberGenerator()))+wsSSOSettings.get(AtlasConstants.GET_SUBSCRIBER).EndPoint__c;
        accStub.timeout_x=AtlasConstants.TIMEOUT;
        AtlasSSOWS.getSubscriberResponse_element getsubscriberResponse=null;
        try{ 
            getsubscriberResponse=accStub.getSubscriber(AtlasUtility.getMapValue(AtlasConstants.ATLAS_SSO_API_UNAME),AtlasUtility.getMapValue(AtlasConstants.ATLAS_SSO_API_PWD),ld,'');
            if(AtlasUtility.isEmpty(getsubscriberResponse))
            throw new AtlasException.InvalidDataException(getExCode(AtlasConstants.SC_No_Data_Exp),getExValue(AtlasConstants.SC_No_Data_Exp));
        }catch(CalloutException e)
        {
            throw new AtlasException.CalloutException(getExCode(AtlasConstants.SC_Callout_Exp),getExValue(AtlasConstants.SC_Callout_Exp));
        }
        if(!AtlasUtility.isEmpty(getsubscriberResponse))
        return getsubscriberResponse;
        return null;
    }
    
    /**
    * @author Shiva Shankar
    * @description - to login
    * @input param  - String userName, string pasword
    * @return param AtlasSSOWS.changePasswordResponse_element
    */   
    public static AtlasSSOWS.loginResponse_element login(string userName,string newpassword)
    { 
        AtlasSSOWS.ATLASSSOAPIPort accStub=new AtlasSSOWS.ATLASSSOAPIPort();
        accStub.endpoint_x=AtlasUtility.getSSOWebServiceEndPoint(string.valueOF(AtlasUtility.randomNumberGenerator()))+wsSSOSettings.get(AtlasConstants.GET_SUBSCRIBER).EndPoint__c;
        accStub.timeout_x=AtlasConstants.TIMEOUT;
        AtlasSSOWS.loginResponse_element response=null;
        try{ 
            response=accStub.login(userName, newpassword);
            //if(AtlasUtility.isEmpty(response))
            //throw new AtlasException.InvalidDataException(getExCode(AtlasConstants.SC_No_Data_Exp),getExValue(AtlasConstants.SC_No_Data_Exp));
        }catch(CalloutException e)
        {
            //throw new AtlasException.CalloutException(getExCode(AtlasConstants.SC_Callout_Exp),getExValue(AtlasConstants.SC_Callout_Exp));
        }
        if(!AtlasUtility.isEmpty(response))
        return response;
        return null;
    }
    
    /**
    * @author Kelly Wortel
    * @description - change password
    * @input param  - String username
    * @input param  - String oldpassword
    * @input param  - String newpassword
    * @return param - String loginUserName
    */  
    public static AtlasSSOWS.changePasswordResponse_element changePassword(string userName,string oldpassword,string newpassword)
    { 
        AtlasSSOWS.ATLASSSOAPIPort accStub=new AtlasSSOWS.ATLASSSOAPIPort();
        accStub.endpoint_x=AtlasUtility.getSSOWebServiceEndPoint(string.valueOF(AtlasUtility.randomNumberGenerator()))+wsSSOSettings.get(AtlasConstants.GET_SUBSCRIBER).EndPoint__c;
        accStub.timeout_x=AtlasConstants.TIMEOUT;
        AtlasSSOWS.changePasswordResponse_element response=null;
        try{ 
            response=accStub.changePassword(userName,oldpassword,newpassword);
            //if(AtlasUtility.isEmpty(response))
                //throw new AtlasException.InvalidDataException(getExCode(AtlasConstants.ChangePassword_No_Data_Exp),getExValue(AtlasConstants.ChangePassword_No_Data_Exp)); 
            
            // Update the Atlas Transaction History
            If(response.Status=='Success') {
            	//AR 11/18/2015: added Account_Number__c in below query to pass it to AtlasDatabaseManager.insertTransaction instead of externalAccountReference
                User userObj = [SELECT Id, ExternalAccountReference__c,Account_Number__c from User where FederationIdentifier = :userName limit 1];
                AtlasDatabaseManager.insertTransaction(getExValue('TRANSACTION_HISTORY_CUSTOMERINFO'),getExValue('CPNI_PASSWORD'),'Password Changed','Success','',userObj.Account_Number__c);
            }            
        }catch(CalloutException e)
        {
            throw new AtlasException.CalloutException(getExCode(AtlasConstants.ChangePassword_Callout_Exp),getExValue(AtlasConstants.ChangePassword_Callout_Exp));
        }
        if(!AtlasUtility.isEmpty(response))
            return response;
        return null;
    }    

    /**
    * @author Kelly Wortel
    * @description - change security questions
    * @input param  - String username
    * @input param  - AtlasSSOWS.securityQuestionsType securityQuestions
    * @return param - String loginUserName
    */     
    public static AtlasSSOWS.saveSecurityQuestionsResponse_element saveSecurityQuestions(String userName, AtlasSSOWS.securityQuestionsType securityQuestions)
    { 
        AtlasSSOWS.ATLASSSOAPIPort accStub=new AtlasSSOWS.ATLASSSOAPIPort();
        accStub.endpoint_x=AtlasUtility.getSSOWebServiceEndPoint(string.valueOF(AtlasUtility.randomNumberGenerator()))+wsSSOSettings.get(AtlasConstants.GET_SUBSCRIBER).EndPoint__c;
        accStub.timeout_x=AtlasConstants.TIMEOUT;
        AtlasSSOWS.saveSecurityQuestionsResponse_element response=null;
        
        try{ 
               System.debug('making web service call to saveSecurityQuestions');
            response=accStub.saveSecurityQuestions(AtlasUtility.getMapValue(AtlasConstants.ATLAS_SSO_API_UNAME),AtlasUtility.getMapValue(AtlasConstants.ATLAS_SSO_API_PWD),userName,securityQuestions);
            if(AtlasUtility.isEmpty(response))
                throw new AtlasException.InvalidDataException(getExCode(AtlasConstants.ChangeSecurity_No_Data_Exp),getExValue(AtlasConstants.ChangeSecurity_No_Data_Exp)); 
            
            System.debug('about to insert into ATH');
            // Update the Atlas Transaction History
            User userObj=null;
            try{
                userObj = [SELECT Id, ExternalAccountReference__c, Account_Number__c from User where FederationIdentifier = :userName limit 1];
            }
            catch (exception e){
                  System.debug('did not find user object for fedid: ' + userName);
                  AtlasDatabaseManager.insertTransaction(getExValue('TRANSACTION_HISTORY_CUSTOMERINFO'),getExValue('CPNI_SECURITY'),'Security Questions Changed','Success','',null);            
            }
            
            if (userObj != null) {
                System.debug('ext ref num: ' + userObj.ExternalAccountReference__c + 'Account Number' + userObj.Account_Number__c);
                AtlasDatabaseManager.insertTransaction(getExValue('TRANSACTION_HISTORY_CUSTOMERINFO'),getExValue('CPNI_SECURITY'),'Security Questions Changed','Success','',userObj.Account_Number__c);
            } 
            
            System.debug('finished inserting into ATH');
            
            /*if (AtlasUtility.getMapValue('AtlasGuestProfile') != userinfo.getprofileId()){
                User userObj = [SELECT Id, ExternalAccountReference__c from User where FederationIdentifier = :userName limit 1];
                if (userObj != null) {
                    System.debug('ext ref num: ' + userObj.ExternalAccountReference__c);
                  AtlasDatabaseManager.insertTransaction(getExValue('TRANSACTION_HISTORY_CUSTOMERINFO'),getExValue('CPNI_SECURITY'),'Security Questions Changed','Success','',userObj.ExternalAccountReference__c);
                } else {
                    System.debug('did not find user object for fedid: ' + userName);
                  AtlasDatabaseManager.insertTransaction(getExValue('TRANSACTION_HISTORY_CUSTOMERINFO'),getExValue('CPNI_SECURITY'),'Security Questions Changed','Success','',null);                
                }
                System.debug('finished inserting into ATH');
            }*/
            
            return response;
            
        }catch(CalloutException e)
        {
            throw new AtlasException.CalloutException(getExCode(AtlasConstants.ChangeSecurity_Callout_Exp),getExValue(AtlasConstants.ChangeSecurity_Callout_Exp));
        }
    }    


    /**
    * @author Shiva Shankar
    * @description - create new password
    * @input param  - String newpassword
    * @return param AtlasSSOWS.resetPasswordResponse_element
    */   
    public static AtlasSSOWS.resetPasswordResponse_element resetPassword(String userName, String newpassword, Boolean temporarypasswordflag)
    { 
        AtlasSSOWS.ATLASSSOAPIPort accStub=new AtlasSSOWS.ATLASSSOAPIPort();
        accStub.endpoint_x=AtlasUtility.getSSOWebServiceEndPoint(string.valueOF(AtlasUtility.randomNumberGenerator()))+wsSSOSettings.get(AtlasConstants.GET_SUBSCRIBER).EndPoint__c;
        accStub.timeout_x=AtlasConstants.TIMEOUT;
        AtlasSSOWS.resetPasswordResponse_element response=null;
        try{ 
            response=accStub.resetPassword(AtlasUtility.getMapValue(AtlasConstants.ATLAS_SSO_API_UNAME),AtlasUtility.getMapValue(AtlasConstants.ATLAS_SSO_API_PWD),userName,newpassword,temporarypasswordflag);
            if(AtlasUtility.isEmpty(response)) {
               throw new AtlasException.InvalidDataException(getExCode(AtlasConstants.ResetPassword_No_Data_Exp),getExValue(AtlasConstants.ResetPassword_No_Data_Exp));             
            }
            
            if(!AtlasUtility.isEmpty(response) && (!response.status.equalsIgnoreCase(getExValue(AtlasConstants.ATLAS_SSO_API_SUCCESS_STATUS)))) { 
               throw new AtlasException.InvalidDataException(response.errorcode.format(),response.error);
            }

            // Update the Atlas Transaction History
            List<User> userObj = [SELECT Id, ExternalAccountReference__c, Account_Number__c from User where FederationIdentifier = :userName limit 1];
            if(!AtlasUtility.isEmpty(userObj))
            AtlasDatabaseManager.insertTransaction(getExValue('TRANSACTION_HISTORY_CUSTOMERINFO'),getExValue('CPNI_PASSWORD'),'Password Reset','Success','',userObj[0].Account_Number__c); 
            return response;
        }
        catch(CalloutException e)
        {
            throw new AtlasException.CalloutException(getExCode(AtlasConstants.ResetPassword_Callout_Exp),getExValue(AtlasConstants.ResetPassword_Callout_Exp));
        }
        // TODO: Discuss with Kelly and Hanu, the response error will be lost if we uncomment the catch block below
       /*
        catch(Exception ex)
        {
            throw new AtlasException.GeneralException(getExCode(AtlasConstants.ResetPassword_General_Exp),getExValue(AtlasConstants.ResetPassword_General_Exp));
        }*/
    }
     
    /**
    * @author Kelly Wortel
    * @description - change loginUserName
    * @input param  - String username
    * @input param  - String newusername
    * @return param - String loginUserName or error message
    */   
    public static AtlasSSOWS.changeLoginUserNameResponse_element changeLoginUserName(string userName,string newUserName)
    { 
        AtlasSSOWS.ATLASSSOAPIPort accStub=new AtlasSSOWS.ATLASSSOAPIPort();
        accStub.endpoint_x=AtlasUtility.getSSOWebServiceEndPoint(string.valueOF(AtlasUtility.randomNumberGenerator()))+wsSSOSettings.get(AtlasConstants.GET_SUBSCRIBER).EndPoint__c;
        accStub.timeout_x=AtlasConstants.TIMEOUT;
        AtlasSSOWS.changeLoginUserNameResponse_element response;
        try{ 
            response=accStub.changeLoginUserName(AtlasUtility.getMapValue(AtlasConstants.ATLAS_SSO_API_UNAME),AtlasUtility.getMapValue(AtlasConstants.ATLAS_SSO_API_PWD),userName,newUserName);
            if(AtlasUtility.isEmpty(response))
                throw new AtlasException.InvalidDataException(getExCode(AtlasConstants.ChangeUserName_No_Data_Exp),getExValue(AtlasConstants.ChangeUserName_No_Data_Exp)); 
        
            if(!AtlasUtility.isEmpty(response) && (!response.status.equalsIgnoreCase(getExValue(AtlasConstants.ATLAS_SSO_API_SUCCESS_STATUS)))) 
                throw new AtlasException.InvalidDataException(response.errorcode.format(),response.error);
                
            /* Calling method to sync updated username to salesforce */
            AtlasSyncSFDC sync = new AtlasSyncSFDC();
            sync.syncUsername(userName,newUserName);  
            
            // Update the Atlas Transaction History
            User userObj = [SELECT Id, ExternalAccountReference__c, Account_Number__c from User where FederationIdentifier = :newUserName limit 1];
            AtlasDatabaseManager.insertTransaction(getExValue('TRANSACTION_HISTORY_CUSTOMERINFO'),getExValue('CPNI_USERNAME'),'Username change','Success','',userObj.Account_Number__c);
            
            return response;
        }
        catch(CalloutException e)
        {
            throw new AtlasException.CalloutException(getExCode(AtlasConstants.ChangeUserName_Callout_Exp),getExValue(AtlasConstants.ChangeUserName_Callout_Exp));
        }
        // TODO: Discuss with Kelly and Hanu, the response error will be lost if we uncomment the catch block below
        /*
        catch(Exception ex)
        {
            throw new AtlasException.GeneralException(getExCode(AtlasConstants.ChangeUserName_General_Exp),getExValue(AtlasConstants.ChangeUserName_General_Exp));
        }
        */
    } 
    
    /**
    * @author Sujit Kumar
    * @description - upload file given the file name & the file content
    * @input param  - String fileName
    * @input param  - String fileContent
    * @return param - String fileName that was uploaded, same as input argument
    */   
    public static AtlasSSOWS.uploadFileResponse_element uploadFile(String fileName, String fileContent)
    { 
        AtlasSSOWS.ATLASSSOAPIPort accStub=new AtlasSSOWS.ATLASSSOAPIPort();
        accStub.endpoint_x=AtlasUtility.getSSOWebServiceEndPoint(string.valueOF(AtlasUtility.randomNumberGenerator()))+wsSSOSettings.get(AtlasConstants.GET_SUBSCRIBER).EndPoint__c;
        accStub.timeout_x=AtlasConstants.TIMEOUT;
        
        // Create a blob from the file contents
        Blob fileContentBlob = Blob.valueOf(fileContent);
    
        // base64 encode the blob that contains the file content
        String fileContentAsBase64EncodedBlob = EncodingUtil.base64Encode(fileContentBlob);
        
        AtlasSSOWS.uploadFileResponse_element response;
        try { 
            response=accStub.uploadFile(AtlasUtility.getMapValue(AtlasConstants.ATLAS_SSO_API_UNAME),
                                        AtlasUtility.getMapValue(AtlasConstants.ATLAS_SSO_API_PWD),
                                        fileName,
                                        fileContentAsBase64EncodedBlob);
                                        
            if(AtlasUtility.isEmpty(response))
                throw new AtlasException.InvalidDataException(getExCode(AtlasConstants.UploadFile_No_Data_Exp),getExValue(AtlasConstants.UploadFile_No_Data_Exp)); 
        
            if(!AtlasUtility.isEmpty(response) && (!response.status.equalsIgnoreCase(getExValue(AtlasConstants.ATLAS_SSO_API_SUCCESS_STATUS)))) 
                throw new AtlasException.InvalidDataException(response.errorcode.format(),response.error);
            
            return response;
        }
        catch(CalloutException e)
        {
            throw new AtlasException.CalloutException(getExCode(AtlasConstants.UploadFile_Callout_Exp),getExValue(AtlasConstants.UploadFile_Callout_Exp));
        }
    }
         
    /**
    * @author Srikanth Kudumula
    * @description - update Subscriber
    * @input param - String UserName
    * @input param - String Password
    * @return param - updateSubscriberResponse_element
    */   
    public static AtlasSSOWS.updateSubscriberResponse_element updateSubscriber(Long subscriberkey,String loginusername,String loginuserpassword,AtlasSSOWS.securityQuestionsType securityQuestions)
    { 
        AtlasSSOWS.ATLASSSOAPIPort accStub=new AtlasSSOWS.ATLASSSOAPIPort();
        accStub.endpoint_x=AtlasUtility.getSSOWebServiceEndPoint(string.valueOF(AtlasUtility.randomNumberGenerator()))+wsSSOSettings.get(AtlasConstants.GET_SUBSCRIBER).EndPoint__c;
        accStub.timeout_x=AtlasConstants.TIMEOUT;
        AtlasSSOWS.updateSubscriberResponse_element response;
        try{ 
            response=accStub.updateSubscriber(AtlasUtility.getMapValue(AtlasConstants.ATLAS_SSO_API_UNAME),AtlasUtility.getMapValue(AtlasConstants.ATLAS_SSO_API_PWD),subscriberkey,loginusername,loginuserpassword,securityQuestions);
            if(AtlasUtility.isEmpty(response))
                throw new AtlasException.InvalidDataException(getExCode(AtlasConstants.UpdateSubscriber_No_Data_Exp),getExValue(AtlasConstants.UpdateSubscriber_No_Data_Exp)); 
            if(!AtlasUtility.isEmpty(response) && (!response.status.equalsIgnoreCase(getExValue(AtlasConstants.ATLAS_SSO_API_SUCCESS_STATUS)))) 
                throw new AtlasException.InvalidDataException(response.errorcode.format(),response.error);
            
            return response;
        }
        catch(CalloutException e)
        {
            throw new AtlasException.CalloutException(getExCode(AtlasConstants.UpdateSubscriber_Callout_Exp),getExValue(AtlasConstants.UpdateSubscriber_Callout_Exp));
        }
        catch(Exception ex)
        {
            throw new AtlasException.GeneralException(getExCode(AtlasConstants.UpdateSubscriber_General_Exp),getExValue(AtlasConstants.UpdateSubscriber_General_Exp));
        }
    }
    
    /**
    * @author Tejesh Kumar
    * @description - getTaxJudistricationCode
    * @input param  - AtlasTransactionDTO.UpdateCustomerInfoTxDTO custInfoObj
    * @return param String
    */  
    public static List<AtlasPubContactServXmlschema.AddressAndTaxJurisdictions> findAddressAndTaxJurisdictions(AtlasTransactionDTO.UpdateCustomerInfoTxDTO custInfoObj)
    { 
        AtlasTestConstants.WEBSERVICE_NAME=AtlasConstants.UPDATE_CONTACT_INFO;  
        AtlasPubContactServWsdlV1.PublicContactServiceEndpoint contactStub=new AtlasPubContactServWsdlV1.PublicContactServiceEndpoint();
        contactStub.endpoint_x=AtlasUtility.getWebServiceHost(string.valueOF(AtlasUtility.randomNumberGenerator()))+wsSettings.get(AtlasConstants.UPDATE_CONTACT_SERVICE).End_Point__c;  
        //contactStub.endpoint_x='http://requestb.in/vm58d4vm'; 
        contactStub.timeout_x=AtlasConstants.TIMEOUT; 
        AtlasPubContactServXmlschemaCommonData.Address addObj=new AtlasPubContactServXmlschemaCommonData.Address();
        if(!AtlasUtility.isEmpty(custInfoObj.billingAddress1)) {    
            addObj.postalCode=custInfoObj.zipCode;
            addObj.region=custInfoObj.state;
            addObj.municipality=custInfoObj.city;
            addObj.countryCode=custInfoObj.countryCode;
            addObj.addressLine=new String[]{custInfoObj.billingAddress1};
            if(!AtlasUtility.isEmpty(custInfoObj.billingAddress2))
            addObj.addressLine.add(custInfoObj.billingAddress2);
        }
        AtlasPubContactServXmlschema.AddressAndTaxJurisdictions[] response=null;
        try
        {   
            response=contactStub.findAddressAndTaxJurisdictions(addObj) ;
            
            System.debug('findAddressAndTaxJurisdictions--->' + response);
        }
        catch(CalloutException e)
        {
            System.debug('Error - findAddressAndTaxJurisdictions - ' + e.getMessage());
        }   
        return response; 
    }
    
    /**
    * @author Srikanth Kudumula
    * @description - getAccountProvisioningInfo,
    * @input param  - String Provisioning status
    * @return param Long accountNo
    */  
    /*public static AtlasAccInfoXmlschemaPublic.provisioningInfoBean[] getAccountProvisioningInfo(String accountNo)
    {   
        AtlasAccInfoWsdlPublicwebse.AccountInfoEndpoint accStub=new AtlasAccInfoWsdlPublicwebse.AccountInfoEndpoint();
        accStub.endpoint_x=AtlasUtility.getWebServiceHost(string.valueOF(AtlasUtility.randomNumberGenerator()))+wsSettings.get(AtlasConstants.ACCOUNT_INFO).End_Point__c; 
        accStub.timeout_x=AtlasConstants.TIMEOUT;
        AtlasAccInfoXmlschemaPublic.provisioningInfoBean[] provisioningStatus = null;
        try{
            provisioningStatus=accStub.getAccountProvisioningInfo(accountNo);
            if(AtlasUtility.isEmpty(provisioningStatus))
            throw new AtlasException.InvalidDataException(getExCode(AtlasConstants.BS_No_Data_Exp),getExValue(AtlasConstants.BS_No_Data_Exp)); 
        }catch(CalloutException e)
        {   
            throw new AtlasException.CalloutException(getExCode(AtlasConstants.BS_Callout_Exp),getExValue(AtlasConstants.BS_Callout_Exp));
        }
        
        return provisioningStatus;
    }*/
    
    /**
    * @author Srikanth Kudumula
    * @description - getAccountServices,
    * @input param  - String Account Key
    * @return param accountServiceBean element
    */
    public static AtlasAccInfoXmlschemaPublic.accountServiceBean getAccountServices(String accountNum, String internalAccountReference)
    {
        AtlasAccInfoWsdlPublicwebse.AccountInfoEndpoint accStub=new AtlasAccInfoWsdlPublicwebse.AccountInfoEndpoint();
        accStub.endpoint_x=AtlasUtility.getWebServiceHost(string.valueOF(AtlasUtility.randomNumberGenerator()))+wsSettings.get(AtlasConstants.ACCOUNT_INFO).End_Point__c; 
        accStub.timeout_x=AtlasConstants.TIMEOUT;
        AtlasAccInfoXmlschemaPublic.accountServiceBean[] response = null;
        system.debug('@@@---accountNum--->'+accountNum);
        
        try{
            response = accStub.getAccountServices(accountNum);
            if(AtlasUtility.isEmpty(response))
            throw new AtlasException.InvalidDataException(getExCode(AtlasConstants.AS_No_Data_Exp),getExValue(AtlasConstants.AS_No_Data_Exp));
        }
        catch(exception ex){
            system.debug('@@@---Stack Trace--->'+ex.getStackTraceString());
            System.debug('@@@---get Message--->'+ex.getMessage());
            throw new AtlasException.CalloutException(getExCode(AtlasConstants.AS_Callout_Exp),getExValue(AtlasConstants.AS_Callout_Exp));
        }

        if(!AtlasUtility.isEmpty(response))
            return response[0];
        return null;
    }
    
    /**
    * @author Tejesh Kumar
    * @description - getAccountServices for Atlas,
    * @input param  - String Account Key
    * @return param accountServiceBean element
    */
    public static AtlasAccInfoXmlschemaPublic.accountServiceBean[] getAccountServicesAtlas(String accountNum)
    {
        AtlasAccInfoWsdlPublicwebse.AccountInfoEndpoint accStub=new AtlasAccInfoWsdlPublicwebse.AccountInfoEndpoint();
        accStub.endpoint_x=AtlasUtility.getWebServiceHost(string.valueOF(AtlasUtility.randomNumberGenerator()))+wsSettings.get(AtlasConstants.ACCOUNT_INFO).End_Point__c; 
        accStub.timeout_x=AtlasConstants.TIMEOUT;
        AtlasAccInfoXmlschemaPublic.accountServiceBean[] response = null;
        system.debug('@@@---accountNum--->'+accountNum);
        try{
            response = accStub.getAccountServices(accountNum);
            if(AtlasUtility.isEmpty(response))
            throw new AtlasException.InvalidDataException(getExCode(AtlasConstants.AS_No_Data_Exp),getExValue(AtlasConstants.AS_No_Data_Exp));
        }
        catch(exception ex){
            system.debug('@@@---Stack Trace--->'+ex.getStackTraceString());
            System.debug('@@@---get Message--->'+ex.getMessage());
            throw new AtlasException.CalloutException(getExCode(AtlasConstants.AS_Callout_Exp),getExValue(AtlasConstants.AS_Callout_Exp));
        }
        if(!AtlasUtility.isEmpty(response))
            return response;
        return null;
    }
    
    /**
    * @author Tejesh Kumar
    * @description - findSubscriberBySearchCriteria V2,
    * @input param  - String Account Number
    * @return param - HttpResponse
    */
    public static Map<String,String> findSubscriberBySearchCriteriaV2(AtlasMainDTO mainDTO) 
    {   
        String AccountNumber = mainDTO.internalAccountReference;     
        OasisOpenOrgWssSecuritySecext.SecurityHeaderType Security = new OasisOpenOrgWssSecuritySecext.SecurityHeaderType(AtlasConstants.WEBSERVICE_USERNAME, AtlasConstants.WEBSERVICE_PWD);
        HttpRequest req = new HttpRequest(); 
        String wsEndPoint;
        if(!Test.isRunningTest())          
            wsEndPoint  = AtlasUtility.getWebServiceHost(string.valueOF(AtlasUtility.randomNumberGenerator()))+wsSettings.get(AtlasConstants.FIND_SUBSCRIBERV2).End_Point__c;                                         
        else
            wsEndPoint  = 'test'; 
        req.setMethod('POST');
        req.setEndpoint(wsEndPoint);
        req.setTimeout(80000);
        req.setHeader('Content-Type', 'text/xml; charset=utf-8');
        req.setHeader('SOAPAction', '');
        
        String[] securityHeaderArgs = new String[] {Security.Timestamp.Created,Security.Timestamp.Expires,AtlasConstants.WEBSERVICE_USERNAME,AtlasConstants.WEBSERVICE_PWD,generateNounce(),Security.UsernameToken.Created};
        String secuirtyHeader = String.format(secuirtyHeaderTemplate, securityHeaderArgs);

        String wbHeader = '';
        String[] wbHeaderArgs = new String[] {'AtlasWebServiceTestUI','AtlasWebServiceTestUI'};
        wbHeader = String.format(wbHeaderTemplate, wbHeaderArgs);          
     
        String soapServiceCall = '';
        String[] args1 = new String[] {AccountNumber};
        soapServiceCall = String.format(searchByAccountNumberTemplate,args1) ; 
            
        String[] args2 = new String[] {secuirtyHeader,wbHeader,soapServiceCall};
        String wsRequestMsg = String.format(soapEnvelopTemplate,args2);   
        req.setBody(wsRequestMsg);
        
        Http http = new Http();
        HTTPResponse res ;
        try {   
          system.debug('--req-- '+ req);  
          res = http.send(req);
          wsReturn = res.getBody();
          searchResult = parseXML(wsReturn);                                                              
       } 
       catch(Exception e) {
            System.debug('Error Invoking the service' + e.getMessage());
       }
       return searchResult;       
    }
    
    /**
    * @author Tejesh Kumar
    * @description - findSubscriberBySearchCriteria V2 with Mac,
    * @input param  - String Mac Address
    * @return param - HttpResponse
    */
    public static Map<String,String> findSubscriberBySearchCriteriaV2Mac(String MacAddress) 
    {   
        //String MacAddress = mainDTO.internalAccountReference;     
        OasisOpenOrgWssSecuritySecext.SecurityHeaderType Security = new OasisOpenOrgWssSecuritySecext.SecurityHeaderType(AtlasConstants.WEBSERVICE_USERNAME, AtlasConstants.WEBSERVICE_PWD);
        HttpRequest req = new HttpRequest(); 
        String wsEndPoint;
        if(!Test.isRunningTest())           
            wsEndPoint  = AtlasUtility.getWebServiceHost(string.valueOF(AtlasUtility.randomNumberGenerator()))+wsSettings.get(AtlasConstants.FIND_SUBSCRIBERV2).End_Point__c;                                         
        else
            wsEndPoint='test';
            
        req.setMethod('POST');
        req.setEndpoint(wsEndPoint);
        req.setTimeout(80000);
        req.setHeader('Content-Type', 'text/xml; charset=utf-8');
        req.setHeader('SOAPAction', '');
        
        String[] securityHeaderArgs;
        if(!Test.isRunningTest()) 
            securityHeaderArgs = new String[] {Security.Timestamp.Created,Security.Timestamp.Expires,AtlasConstants.WEBSERVICE_USERNAME,AtlasConstants.WEBSERVICE_PWD,generateNounce(),Security.UsernameToken.Created};
        else
            securityHeaderArgs =new String[] {Security.Timestamp.Created,Security.Timestamp.Expires,'test','test',generateNounce(),Security.UsernameToken.Created};
            
        String secuirtyHeader = String.format(secuirtyHeaderTemplate, securityHeaderArgs);

        String wbHeader = '';
        String[] wbHeaderArgs = new String[] {'AtlasWebServiceTestUI','AtlasWebServiceTestUI'};
        wbHeader = String.format(wbHeaderTemplate, wbHeaderArgs);          
     
        String soapServiceCall = '';
        String[] args1 = new String[] {MacAddress};
        soapServiceCall = String.format(searchByMacTemplate,args1) ; 
            
        String[] args2 = new String[] {secuirtyHeader,wbHeader,soapServiceCall};
        String wsRequestMsg = String.format(soapEnvelopTemplate,args2);   
        req.setBody(wsRequestMsg);
        
        Http http = new Http();
        HTTPResponse res ;
        try {   
          system.debug('--req-- '+ req);  
          res = http.send(req);
          wsReturn = res.getBody();
          searchResult = parseXML(wsReturn);                                                              
       } 
       catch(Exception e) {
            System.debug('Error Invoking the service' + e.getMessage());
       }
       return searchResult;       
    }
    
    // Method for Parsing response XML in findSubscriberBySearchCriteriaV2
    public static Map<String,String> parseXML(String toParse) {
       Map<String, String> returnObj = new Map<String, String>();
       DOM.Document doc = new DOM.Document();      
       try {
          doc.load(toParse);    
              DOM.XMLNode root = doc.getRootElement();
              walkThrough(root, returnObj);                
       } catch (System.XMLException e) {  
            // invalid XML
       }          
       return returnObj;
    }        
    public static void walkThrough(DOM.XMLNode node, Map<String,String> returnObj) {
        String result = '\n';
       if (node.getNodeType() == DOM.XMLNodeType.COMMENT) {
          return;
       }
       if (node.getNodeType() == DOM.XMLNodeType.TEXT) {
          return;
       }
       if (node.getNodeType() == DOM.XMLNodeType.ELEMENT) {
          String lsElement = node.getName();
          if (node.getText().trim() != '') {
             returnObj.put(lsElement, node.getText().trim());
          }          
          if (node.getAttributeCount() > 0) { 
             for (Integer i = 0; i< node.getAttributeCount(); i++ ) {
             }  
          }
          for (Dom.XMLNode child: node.getChildElements()) {
             walkThrough(child, returnObj);
          }
          return;
       }
       return;  //should never reach here          
    }            
    
    /**
    * @author Srikanth Kudumula
    * @description - getTransitionPackages,
    * @input param  - String externalSystemName,String externalAccountReference
    * @return param AtlasPubCatlogServiceXmlschemaV2.Package_x[]
    */
    Public static AtlasPubCatlogServiceXmlschemaV2.Package_TPTest[] getTransitionPackages(String externalSystemName,String externalAccountReference)
    {
        system.debug('**------FROM AtlasIntUtility--------@@@@----------------------------> mainDTO.externalSystemName= '+externalSystemName);
        AtlasPubCatlogServiceWsdlV2.PublicCatalogServiceEndpoint catlogStub=new AtlasPubCatlogServiceWsdlV2.PublicCatalogServiceEndpoint ();
        catlogStub.endpoint_x=AtlasUtility.getWebServiceHost(string.valueOF(AtlasUtility.randomNumberGenerator()))+wsSettings.get(AtlasConstants.PUBLIC_CATALOG_SERVICE).End_Point__c;
        catlogStub.timeout_x=AtlasConstants.TIMEOUT;
        AtlasPubCatlogServiceXmlschemaPWSHeader.wildBlueHeader wbHeaderObj=new AtlasPubCatlogServiceXmlschemaPWSHeader.wildBlueHeader();
        AtlasPubCatlogServiceXmlschemaPWSHeader.invokedBy invokedByObj=new AtlasPubCatlogServiceXmlschemaPWSHeader.invokedBy();
        invokedByObj.application=AtlasConstants.INVOKED_BY_APP;
        invokedByObj.username=AtlasConstants.INVOKED_BY_USERNAME;
        wbHeaderObj.invokedBy=invokedByObj;
        catlogStub.wildBlueHeader=wbHeaderObj;
        AtlasPubCatlogServiceXmlschemaV2.Package_TPTest[] catResponse;
        try{
            catResponse=catlogStub.getTransitionPackages(externalSystemName,externalAccountReference);
            if(AtlasUtility.isEmpty(catResponse))
            throw new AtlasException.InputDataException(getExCode(AtlasConstants.PKG_No_Data_Exp),getExValue(AtlasConstants.PKG_No_Data_Exp));
        }catch(CalloutException e)
        {
            system.debug(LoggingLevel.Error, '@@@---> getTransitionPackages Rsponse'+catResponse);
            system.debug(LoggingLevel.Error, '@@@---> getTransitionPackages Exception'+e);
            system.debug(LoggingLevel.Error, '@@@---> getTransitionPackages Exception MSG'+e.getMessage());
            throw new AtlasException.CalloutException(getExCode(AtlasConstants.PKG_Callout_Exp),getExValue(AtlasConstants.PKG_Callout_Exp));
        }
        system.debug('@@@---> getTransitionPackages Rsponse'+catResponse);
        //system.assert(false, 'assert failure');
        return catResponse;
    }

    /**
    * @author Hanu Cholleti
    * @description - Get packages based on beam, satellite for a sales channel, customer type, and transaction type
    * @input param - String salesChannel,String customerType, String transactionType, Integer beam, String satelliteName
    * @return param AtlasPubCatlogServiceXmlschemaV2.Package_x[]
    */
    Public static AtlasPubCatlogServiceXmlschemaV2.Package_x[] getPackages(String salesChannel,String customerType, String transactionType, Integer beam, String satelliteName)
    {
        AtlasPubCatlogServiceWsdlV2.PublicCatalogServiceEndpoint catlogStub=new AtlasPubCatlogServiceWsdlV2.PublicCatalogServiceEndpoint ();
        catlogStub.endpoint_x=AtlasUtility.getWebServiceHost(string.valueOF(AtlasUtility.randomNumberGenerator()))+wsSettings.get(AtlasConstants.PUBLIC_CATALOG_SERVICE).End_Point__c;
        catlogStub.timeout_x=AtlasConstants.TIMEOUT;
        
        AtlasPubCatlogServiceXmlschemaPWSHeader.wildBlueHeader wbHeaderObj=new AtlasPubCatlogServiceXmlschemaPWSHeader.wildBlueHeader();
        AtlasPubCatlogServiceXmlschemaPWSHeader.invokedBy invokedByObj=new AtlasPubCatlogServiceXmlschemaPWSHeader.invokedBy();
        invokedByObj.application=AtlasConstants.INVOKED_BY_APP;
        invokedByObj.username=AtlasConstants.INVOKED_BY_USERNAME;
        wbHeaderObj.invokedBy=invokedByObj;
        catlogStub.wildBlueHeader=wbHeaderObj;
        
        AtlasPubCatlogServiceXmlschemaV2.Package_x[] catResponse;
        try{
            AtlasPubCatlogServiceXmlschemaV2.Qualifier qualifier = new AtlasPubCatlogServiceXmlschemaV2.Qualifier();
            qualifier.salesChannel = salesChannel;
            qualifier.customerType = customerType;
            qualifier.transactionType = transactionType;
            qualifier.beamNumber = beam;
            qualifier.satelliteName = satelliteName;
                
            catResponse=catlogStub.getPackages(qualifier);
            if(AtlasUtility.isEmpty(catResponse))
                throw new AtlasException.InputDataException(getExCode(AtlasConstants.PKG_No_Data_Exp),getExValue(AtlasConstants.PKG_No_Data_Exp));
        } catch(CalloutException e) {
            system.debug('@@@---> Rsponse'+catResponse);
            system.debug('@@@---> Exception'+e);
            system.debug('@@@---> Exception MSG'+e.getMessage());
            throw new AtlasException.CalloutException(getExCode(AtlasConstants.PKG_Callout_Exp),getExValue(AtlasConstants.PKG_Callout_Exp));
        }
        return catResponse;
    }

    
    /**
    * @author Srikanth Kudumula
    * @description - getTransitionBase,
    * @input param  - String externalSystemName,String externalAccountReference,Target Service, Plan Name, Catalog Number
    * @return param AtlasPubCatlogServiceXmlschemaV2.Package_x[]
    */
    public static HttpResponse getTransistionBaseService(String externalSystemName,String externalReference,String toPlanName,String toCatalogNumber,String targetService)
    {
        //, String currentDateFormatted, String currentDateTimeUnFormatted
        
        Datetime dt =(System.now());
        string strYear = String.valueOf(dt.year());
        string strMonth = String.valueOf(dt.month());
        string strDay = String.valueOf(dt.day());
        string strHour = String.valueOf(dt.hour());
        string strMinute = String.valueOf(dt.minute());
        string strSecond = String.valueOf(dt.second());
        
        if (strMonth.length()==1) strMonth = '0' + strMonth;
        if (strDay.length()==1) strDay = '0' + strDay;
        if (strHour.length()==1) strHour = '0' + strHour;
        if (strMinute.length()==1) strMinute = '0' + strMinute;
        if (strSecond.length()==1) strSecond = '0' + strSecond;
        
        string currentDateFormatted = strYear + '-' + strMonth + '-' + strDay;
        string currentDateTimeUnFormatted = strYear+strMonth+strDay+strHour+strMinute+strSecond;
                
        //system.debug('Current Date:' + currentDateFormatted);
        //system.debug('Current Date:' + currentDateTimeUnFormatted);
        
        string buildRequest = '<Request xsi:schemaLocation="http://www.wildblue.com/XMLSchema/v2.1/OrderEntry http://dvwbapp1:7771/XMLSchema/v2.1/OrderEntry.xsd" xsi:noNamespaceSchemaLocation="'
            +'http://dvwbapp1:7771/XMLSchema/v2.1/WildBlue.xsd" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:oe="http://www.wildblue.com/XMLSchema/v2.1/OrderEntry">'
            +' <SchemaVersion>2.1</SchemaVersion>'
            +'<TransactionID>MyExede' + externalReference + currentDateTimeUnFormatted + '</TransactionID>'
            +'   <TransactionMode>sync</TransactionMode>'
            +'  <Requestor>MyExede</Requestor>'
            +' <ResponseURL>http://www.wildblue.com</ResponseURL>'
            +' <Transaction TransactionType="Update" xsi:type="oe:TransactionRequest">'
            +'    <SystemID>' + externalSystemName + '</SystemID>'
            +'    <UpdateService>'
            +'       <OrderCommon>'
            +'          <OrderReference>MyExede' + externalReference + currentDateTimeUnFormatted + '</OrderReference>'
            +'           <SellerInfo>'
            +'              <OrderSoldBy>MyExede</OrderSoldBy>'
            +'             <FulfillmentVendor xsi:nil="true"/>'
            +'          </SellerInfo>'
            +'         <StartDate>' + currentDateFormatted + '</StartDate>'
            +'    </OrderCommon>'
            +'  <TargetAccount>' + externalReference + '</TargetAccount>'
            +'<TransitionBaseService>'
            +' <From>'
            +'      <TargetService>' + targetService + '</TargetService>'
            +' </From>'
            +'  <To>'
            +' <ServiceReference>MyExede' + externalReference + currentDateTimeUnFormatted + '</ServiceReference>'
            +'   <Name>' + toPlanName + '</Name>'
            +'               <Type>BASE_SERVICE</Type>'
            +'             <CatalogNumber>' + toCatalogNumber + '</CatalogNumber>'
            +'        </To>'
            +'   </TransitionBaseService>'
            +' <RemoveService xsi:nil="true"/>'
            +'<AddService xsi:nil="true"/>'
            +'</UpdateService>'
            +'</Transaction>'
            +'</Request>';
            HttpRequest req = new HttpRequest();                        
            //String wsEndPoint  = 'https://webservices.test.wildblue/XMLAgent/request';
            String wsEndPoint;
            if(!Test.isRunningTest()) 
                wsEndPoint = AtlasUtility.getWebServiceHost(string.valueOF(AtlasUtility.randomNumberGenerator()))+wsSettings.get(AtlasConstants.GET_TRANSITION_BASE).End_Point__c;
            else
                wsEndPoint ='test';
            //String wsEndPoint = 'http://requestb.in/1ek2nac1';                   
            req.setMethod('POST');
            req.setEndpoint(wsEndPoint);
            req.setTimeout(80000);
            req.setHeader('Content-Type', 'application/xml');
            req.setBody(buildRequest);
            
            Http http = new Http();
            HTTPResponse res ;
            try {   
              system.debug('--req-- '+ req);  
              res = http.send(req);
              system.debug('@@@Responseeeeeeeeeee--->'+res.getBody());                                                              
           } 
           catch(Exception e) {
                System.debug('Error Invoking the service' + e.getMessage());
           }
           return res;
    }
    
    /**
    * @author Kelly Wortel
    * @description - getTransactionsByAccountAndType,
    * @input param  - String externalSystemName,String externalAccountReference
    * @return param AtlasTransServiceXmlschemav2.Transaction_x[]
    */
    Public static AtlasTransServiceXmlschemav2.Transaction_x[] getTransactionsByAccountAndType(String externalSystemName,String externalAccountReference,String transactionType) 
    {   
        AtlasTransServiceWsdlTransService.TransactionServiceEndpoint getTransactionsByAccountAndTypeStub=new AtlasTransServiceWsdlTransService.TransactionServiceEndpoint();
        getTransactionsByAccountAndTypeStub.endpoint_x=AtlasUtility.getWebServiceHost(string.valueOF(AtlasUtility.randomNumberGenerator()))+wsSettings.get(AtlasConstants.TX_SERVICE).End_Point__c;
        //getTransactionsByAccountStub.endpoint_x = 'http://requestb.in/1bh4oas1'; 
        getTransactionsByAccountAndTypeStub.timeout_x=AtlasConstants.TIMEOUT;
        AtlasTransServiceXmlschemaPWSHeader.wildBlueHeader wbHeaderObj=new AtlasTransServiceXmlschemaPWSHeader.wildBlueHeader();
        AtlasTransServiceXmlschemaPWSHeader.invokedBy invokedByObj=new AtlasTransServiceXmlschemaPWSHeader.invokedBy();
        invokedByObj.application=AtlasConstants.INVOKED_BY_APP;
        invokedByObj.username=AtlasConstants.INVOKED_BY_USERNAME;
        wbHeaderObj.invokedBy=invokedByObj;
        getTransactionsByAccountAndTypeStub.wildBlueHeader=wbHeaderObj;        
        AtlasTransServiceXmlschemav2.Transaction_x[] getTransactionsByAccountAndTypeResponse=null;

        try
        {              
            getTransactionsByAccountAndTypeResponse = getTransactionsByAccountAndTypeStub.getTransactionsByAccountAndType(externalSystemName,externalAccountReference,transactionType,null,null); 
            
            //if(AtlasUtility.isEmpty(getTransactionsByAccountResponse))
            //throw new AtlasException.InputDataException(getExCode(AtlasConstants.PKG_No_Data_Exp),getExValue(AtlasConstants.PKG_No_Data_Exp));
        }
        catch(CalloutException e)
        {   
            system.debug('@@@---> Rsponse'+getTransactionsByAccountAndTypeResponse);
            system.debug('@@@---> Exception'+e);
            system.debug('@@@---> Exception MSG'+e.getMessage());
            //throw new AtlasException.CalloutException(getExCode(AtlasConstants.PKG_Callout_Exp),getExValue(AtlasConstants.PKG_Callout_Exp));
        }
        return getTransactionsByAccountAndTypeResponse;
    }    
    
    /**
    * @author Kelly Wortel
    * @description - getTransactionsByAccount,
    * @input param  - String externalSystemName,String externalAccountReference
    * @return param AtlasTransServiceXmlschemav2.Transaction_x[]
    */
    Public static AtlasTransServiceXmlschemav2.Transaction_x[] getTransactionsByAccount(String externalSystemName,String externalAccountReference) 
    {   
        AtlasTransServiceWsdlTransService.TransactionServiceEndpoint getTransactionsByAccountStub=new AtlasTransServiceWsdlTransService.TransactionServiceEndpoint();
        getTransactionsByAccountStub.endpoint_x=AtlasUtility.getWebServiceHost(string.valueOF(AtlasUtility.randomNumberGenerator()))+wsSettings.get(AtlasConstants.TX_SERVICE).End_Point__c;
        //getTransactionsByAccountStub.endpoint_x = 'http://requestb.in/1bh4oas1'; 
        getTransactionsByAccountStub.timeout_x=AtlasConstants.TIMEOUT;
        AtlasTransServiceXmlschemaPWSHeader.wildBlueHeader wbHeaderObj=new AtlasTransServiceXmlschemaPWSHeader.wildBlueHeader();
        AtlasTransServiceXmlschemaPWSHeader.invokedBy invokedByObj=new AtlasTransServiceXmlschemaPWSHeader.invokedBy();
        invokedByObj.application=AtlasConstants.INVOKED_BY_APP;
        invokedByObj.username=AtlasConstants.INVOKED_BY_USERNAME;
        wbHeaderObj.invokedBy=invokedByObj;
        getTransactionsByAccountStub.wildBlueHeader=wbHeaderObj;        
        AtlasTransServiceXmlschemav2.Transaction_x[] getTransactionsByAccountResponse=null;

        try
        {              
            getTransactionsByAccountResponse = getTransactionsByAccountStub.getTransactionsByAccount(externalSystemName,externalAccountReference,null,null); 

        }
        catch(CalloutException e)
        {   
            system.debug('@@@---> Rsponse'+getTransactionsByAccountResponse);
            system.debug('@@@---> Exception'+e);
            system.debug('@@@---> Exception MSG'+e.getMessage());
        }
        return getTransactionsByAccountResponse;
    }       

    
    /**
    * @author Hanu Cholleti
    * @description - Get Service Availability based on postal code
    * @input param - postalCode
    * @input param - salesChannel 
    * @return param - Map<string,string>
    */
    public static Map<String,String> getServiceAvailability(String postalCode, String salesChannel) 
    {   
        HttpRequest req = new HttpRequest(); 
        String wsEndPoint;
        if(!Test.isRunningTest())           
            wsEndPoint  = AtlasUtility.getWebServiceHost(string.valueOF(AtlasUtility.randomNumberGenerator()))+wsSettings.get(AtlasConstants.GET_SERVICE_AVAILABILITY).End_Point__c;                                         
        else
            wsEndPoint='test';
            
        req.setMethod('POST');
        req.setEndpoint(wsEndPoint);
        req.setTimeout(80000);
        req.setHeader('Content-Type', 'text/xml; charset=utf-8');
        req.setHeader('SOAPAction', '');
        
        req.setBody(getServiceAvailabilityEnvelope(postalCode,salesChannel));
        
        Http http = new Http();
        HTTPResponse res ;
        try {   
          system.debug('--req-- '+ req);  
          res = http.send(req);
          wsReturn = res.getBody();
          searchResult = parseXML(wsReturn);                                                              
       } 
       catch(Exception e) {
            System.debug('Error Invoking the service' + e.getMessage());
       }
       return searchResult;       
    }
    
     /**
    * @author Tejesh Kumar
    * @description - getAvailableInstallDates to get the installation schedule dates available between the date range
    * @input param - dateTime fromDate,dateTime toDate,DealerGetAvailInstallDatesService.addressBean serviceAddress, String salesChannel
    * @return param - List<DealerGetAvailInstallDatesService.scheduleDate>
    */
    Public List<DealerGetAvailInstallDatesService.scheduleDate> getAvailableInstallDates(DateTime fromDate,DateTime toDate,DealerGetAvailInstallDatesService.addressBean serviceAddress,String salesChannel)
    {
        DealerGetAvailInstallDatesService.DirectFulfillmentImplPort catlogStub=new DealerGetAvailInstallDatesService.DirectFulfillmentImplPort();
        //catlogStub.endpoint_x=AtlasUtility.getWebServiceHost(string.valueOF(AtlasUtility.randomNumberGenerator()))+wsSettings.get(AtlasConstants.PUBLIC_CATALOG_SERVICE).End_Point__c;
        catlogStub.endpoint_x='https://webservices.test.wildblue.net/PublicWebServices/services/DirectFulfillment';
        catlogStub.timeout_x=AtlasConstants.TIMEOUT;
        
        List<DealerGetAvailInstallDatesService.scheduleDate> catResponse;
        
        try{
            DealerGetAvailInstallDatesService.getAvailableInstallDates request = new DealerGetAvailInstallDatesService.getAvailableInstallDates();
            request.fromDate = fromDate ;
            request.toDate = toDate;
            request.serviceAddress = serviceAddress;
            request.salesChannel = salesChannel;
                
            catResponse=catlogStub.getAvailableInstallDates(fromDate,toDate,serviceAddress,salesChannel);
            if(AtlasUtility.isEmpty(catResponse))
              throw new AtlasException.InputDataException(getExCode(AtlasConstants.PKG_No_Data_Exp),getExValue(AtlasConstants.PKG_No_Data_Exp));
        } catch(CalloutException e) {
            system.debug('@@@---> Rsponse'+catResponse);
            system.debug('@@@---> Exception'+e);
            system.debug('@@@---> Exception MSG'+e.getMessage());
            throw new AtlasException.CalloutException(getExCode(AtlasConstants.PKG_Callout_Exp),getExValue(AtlasConstants.PKG_Callout_Exp));
        }
        return catResponse;
    }
                 
    /**
    * @author Tejesh Kumar
    * @description - getUniqueExternalReferenceValues,
    * @input param - Integer quantity,String prefix
    * @return param - String[]
    */
    Public static String[] getUniqueExternalReferenceValues(Integer quantity,String prefix) 
    {   
        AtlasTransServiceWsdlTransService.TransactionServiceEndpoint getTransactionsByAccountStub=new AtlasTransServiceWsdlTransService.TransactionServiceEndpoint();
        getTransactionsByAccountStub.endpoint_x=AtlasUtility.getWebServiceHost(string.valueOF(AtlasUtility.randomNumberGenerator()))+wsSettings.get(AtlasConstants.TX_SERVICE).End_Point__c;
        //getTransactionsByAccountStub.endpoint_x = 'http://requestb.in/1bh4oas1'; 
        getTransactionsByAccountStub.timeout_x=AtlasConstants.TIMEOUT;
        AtlasTransServiceXmlschemaPWSHeader.wildBlueHeader wbHeaderObj=new AtlasTransServiceXmlschemaPWSHeader.wildBlueHeader();
        AtlasTransServiceXmlschemaPWSHeader.invokedBy invokedByObj=new AtlasTransServiceXmlschemaPWSHeader.invokedBy();
        invokedByObj.application=AtlasConstants.INVOKED_BY_APP;
        invokedByObj.username=AtlasConstants.INVOKED_BY_USERNAME;
        wbHeaderObj.invokedBy=invokedByObj;
        getTransactionsByAccountStub.wildBlueHeader=wbHeaderObj;
        
        String[] response=null;

        try
        {              
            response = getTransactionsByAccountStub.getUniqueExternalReferenceValues(quantity,prefix); 

        }
        catch(CalloutException e)
        {   
            system.debug('@@@---> Rsponse'+response);
            system.debug('@@@---> Exception'+e);
            system.debug('@@@---> Exception MSG'+e.getMessage());
        }
        return response;
    }
	
	 /**
    * @author Tejesh Kumar
    * @description - getModemDeatils 
    * @input param - String externalSystemName,String externalAccountReference,String phoneNumber,String macAddress
    * @return param - DealerPubModemQueryV2XMLSchema.ModemSummary
    */
    Public DealerPubModemQueryV2XMLSchema.ModemSummary getModemDeatils(String externalSystemName,String externalAccountReference,String phoneNumber,String macAddress)
    {
        DealerPubModemQueryV2Wsdl.PublicModemQueryServiceEndpoint catlogStub=new DealerPubModemQueryV2Wsdl.PublicModemQueryServiceEndpoint();
        //catlogStub.endpoint_x=AtlasUtility.getWebServiceHost(string.valueOF(AtlasUtility.randomNumberGenerator()))+wsSettings.get(AtlasConstants.PUBLIC_CATALOG_SERVICE).End_Point__c;
        catlogStub.endpoint_x='https://webservices.test.wildblue.net/PublicModemQueryService/v2/services/ModemQueryService';
        catlogStub.timeout_x=AtlasConstants.TIMEOUT;
        
        DealerPubModemQueryV2XMLSchema.ModemSummary catResponse;
        
        try{
            catResponse=catlogStub.getModemSummary(externalSystemName,externalAccountReference,phoneNumber,macAddress);
            if(AtlasUtility.isEmpty(catResponse))
              throw new AtlasException.InputDataException(getExCode(AtlasConstants.PKG_No_Data_Exp),getExValue(AtlasConstants.PKG_No_Data_Exp));
        } catch(CalloutException e) {
            system.debug('@@@---> Rsponse'+catResponse);
            system.debug('@@@---> Exception'+e);
            system.debug('@@@---> Exception MSG'+e.getMessage());
            throw new AtlasException.CalloutException(getExCode(AtlasConstants.PKG_Callout_Exp),getExValue(AtlasConstants.PKG_Callout_Exp));
        }
        return catResponse;
    }
    
    /**
    * @author Tejesh Kumar
    * @description - getInstallDeatils 
    * @input param - String externalSystemName,String externalAccountReference,String phoneNumber,String macAddress
    * @return param - DealerPubModemQueryV2XMLSchema.InstallDetails
    */
    Public DealerPubModemQueryV2XMLSchema.InstallDetails getInstallDeatils(String externalSystemName,String externalAccountReference,String phoneNumber,String macAddress)
    {
        DealerPubModemQueryV2Wsdl.PublicModemQueryServiceEndpoint catlogStub=new DealerPubModemQueryV2Wsdl.PublicModemQueryServiceEndpoint();
        //catlogStub.endpoint_x=AtlasUtility.getWebServiceHost(string.valueOF(AtlasUtility.randomNumberGenerator()))+wsSettings.get(AtlasConstants.PUBLIC_CATALOG_SERVICE).End_Point__c;
        catlogStub.endpoint_x='https://webservices.test.wildblue.net/PublicModemQueryService/v2/services/ModemQueryService';
        catlogStub.timeout_x=AtlasConstants.TIMEOUT;
        
        DealerPubModemQueryV2XMLSchema.InstallDetails catResponse;
        
        try{
            catResponse=catlogStub.getInstallDetails(externalSystemName,externalAccountReference,phoneNumber,macAddress);
            if(AtlasUtility.isEmpty(catResponse))
              throw new AtlasException.InputDataException(getExCode(AtlasConstants.PKG_No_Data_Exp),getExValue(AtlasConstants.PKG_No_Data_Exp));
        } catch(CalloutException e) {
            system.debug('@@@---> Rsponse'+catResponse);
            system.debug('@@@---> Exception'+e);
            system.debug('@@@---> Exception MSG'+e.getMessage());
            throw new AtlasException.CalloutException(getExCode(AtlasConstants.PKG_Callout_Exp),getExValue(AtlasConstants.PKG_Callout_Exp));
        }
        return catResponse;
    }
    
    /**
    * @author  Tejesh M
    * @description - getALaCartePackagesByQualifier based on beam, satellite for a sales channel, customer type, and transaction type
    * @input param - String packageReference,String salesChannel,String customerType, String transactionType, Integer beam, String satelliteName
    * @return param AtlasPubCatlogServiceXmlschemaV2.Package_x[]
    */
    Public static AtlasPubCatlogServiceXmlschemaV2.Package_x[] getALaCartePackagesByQualifier(String packageReference,String salesChannel,String customerType, String transactionType, Integer beam, String satelliteName)
    {
        AtlasPubCatlogServiceWsdlV2.PublicCatalogServiceEndpoint catlogStub=new AtlasPubCatlogServiceWsdlV2.PublicCatalogServiceEndpoint ();
        catlogStub.endpoint_x=AtlasUtility.getWebServiceHost(string.valueOF(AtlasUtility.randomNumberGenerator()))+wsSettings.get(AtlasConstants.PUBLIC_CATALOG_SERVICE).End_Point__c;
        catlogStub.timeout_x=AtlasConstants.TIMEOUT;
        
        AtlasPubCatlogServiceXmlschemaPWSHeader.wildBlueHeader wbHeaderObj=new AtlasPubCatlogServiceXmlschemaPWSHeader.wildBlueHeader();
        AtlasPubCatlogServiceXmlschemaPWSHeader.invokedBy invokedByObj=new AtlasPubCatlogServiceXmlschemaPWSHeader.invokedBy();
        invokedByObj.application=AtlasConstants.INVOKED_BY_APP;
        invokedByObj.username=AtlasConstants.INVOKED_BY_USERNAME;
        wbHeaderObj.invokedBy=invokedByObj;
        catlogStub.wildBlueHeader=wbHeaderObj;
        
        AtlasPubCatlogServiceXmlschemaV2.Package_x[] catResponse;
        try{
            AtlasPubCatlogServiceXmlschemaV2.Qualifier qualifier = new AtlasPubCatlogServiceXmlschemaV2.Qualifier();
            qualifier.salesChannel = salesChannel;
            qualifier.customerType = customerType;
            qualifier.transactionType = transactionType;
            qualifier.beamNumber = beam;
            qualifier.satelliteName = satelliteName;
                
            catResponse=catlogStub.getALaCartePackagesByQualifier(packageReference, qualifier);
            if(AtlasUtility.isEmpty(catResponse))
                throw new AtlasException.InputDataException(getExCode(AtlasConstants.PKG_No_Data_Exp),getExValue(AtlasConstants.PKG_No_Data_Exp));
        } catch(CalloutException e) {
            system.debug('@@@---> Rsponse'+catResponse);
            system.debug('@@@---> Exception'+e);
            system.debug('@@@---> Exception MSG'+e.getMessage());
            throw new AtlasException.CalloutException(getExCode(AtlasConstants.PKG_Callout_Exp),getExValue(AtlasConstants.PKG_Callout_Exp));
        }
        return catResponse;
    }
    
    //---------------------------------------------------------------------------------------  
    // BUILDING HTTP Requests - Used by Async CallOuts, consider these methods instead of using templates
    //---------------------------------------------------------------------------------------    
    private static DOM.Document getEnvelope() 
    {
        //string sandboxName = ViasatUtilityClass.sandboxName().toUpperCase();       
        string[] securityHeaderArgs = new String[] {AtlasUtility.generatecreatedTimestamp(), AtlasUtility.generateexpiredTimestamp()
                                                   ,AtlasConstants.WEBSERVICE_USERNAME,AtlasConstants.WEBSERVICE_PWD
                                                   //,(sandboxName.contains('PROD') ? AtlasConstants.WEBSERVICE_PWD_PROD:AtlasConstants.WEBSERVICE_PWD_TEST)
                                                   ,AtlasUtility.generateNounce(), AtlasUtility.generateTimestamp()};
        string securityHeader = String.format(AtlasIntegrationUtility.secuirtyHeaderTemplate, securityHeaderArgs);

        string wbHeader = '';
        String[] wbHeaderArgs = new String[] {'AtlasWebServiceTestUI','AtlasWebServiceTestUI'};
        wbHeader = String.format(AtlasIntegrationUtility.wbHeaderTemplate, wbHeaderArgs);          

        DOM.Document doc = new DOM.Document();
        dom.XmlNode envelope = doc.createRootElement('Envelope', soapNS, 'soapenv');
        dom.XmlNode header = envelope.addChildElement('Header', soapNS, null).addTextNode(securityHeader+wbHeader); 

        dom.XmlNode body = envelope.addChildElement('Body', soapNS, null);
        return doc;
    }

    // Create HTTP Request for AtlasIntegrationServiceManager.searchCustomerDetails(mainDTOObj) 
    public static string findSubscribersBySearchCriteriaEnvelope(String internalReferenceType,String internalReference) 
    {
        DOM.Document doc = getEnvelope();       
        dom.XmlNode envelope = doc.getRootElement();
        dom.XmlNode body = envelope.getChildElement('Body', soapNS);
        
        dom.XmlNode method = body.addChildElement('findSubscribersBySearchCriteria', serviceNSSearch, 'sear');
        method.addChildElement('internalReferenceType', serviceNSSearch, null).addTextNode(internalReferenceType);
        method.addChildElement('internalReference', serviceNSSearch, null).addTextNode(internalReference);      
        
        return doc.toXmlString().replace('&lt;', '<'); //EncodingUtil.UrlDecode(doc.toXmlString().replace('&lt;', '<'), 'UTF-8');
    }

    // Create HTTP Request for AtlasIntegrationServiceManager.getLegacyAccount(mainDTOObj) -> 
    //mainDTO.accountKey=AtlasIntegrationUtility.getLegacyAccount(mainDTO.externalSystemName, mainDTO.externalAccountReference, mainDTO.internalAccountReference);      
    public static string getLegacyAccountEnvelope(String externalSystemName, String externalAccountReference, String internalAccountReference) 
    {
        DOM.Document doc = getEnvelope();       
        dom.XmlNode envelope = doc.getRootElement();
        dom.XmlNode body = envelope.getChildElement('Body', soapNS);
            
        dom.XmlNode method = body.addChildElement('getLegacyAccount', serviceNSSearch, 'sear');
        method.addChildElement('externalSystemName', serviceNSSearch, null).addTextNode(externalSystemName);
        method.addChildElement('externalAccountReference', serviceNSSearch, null).addTextNode(externalAccountReference);        
        method.addChildElement('internalAccountReference', serviceNSSearch, null).addTextNode(internalAccountReference);        
        
        return doc.toXmlString().replace('&lt;', '<'); //EncodingUtil.UrlDecode(doc.toXmlString().replace('&lt;', '<'), 'UTF-8');
    }

    // Create HTTP Request for AtlasIntegrationUtility.getAccountServiceAgreementsAndServices(mainDTO.accountKey)
    public static String getAccountServiceAgreementsAndServicesEnvelope(String accountNoEncrypted)
    {   
        DOM.Document doc = getEnvelope();       
        dom.XmlNode envelope = doc.getRootElement();
        dom.XmlNode body = envelope.getChildElement('Body', soapNS);
        
        dom.XmlNode method = body.addChildElement('getAccountServiceAgreementsAndServices', serviceNSAccount, 'sear');
        method.addChildElement('account', serviceNSAccount, null).addTextNode(accountNoEncrypted);      
        
        return doc.toXmlString().replace('&lt;', '<'); //EncodingUtil.UrlDecode(doc.toXmlString().replace('&lt;', '<'), 'UTF-8');
    }
    
    // Create HTTP Request for AtlasIntegrationUtility.getBillingSummary(mainDTO.accountKey)
    public static String getBillingSummaryEnvelope(String accountNoEncrypted)
    {
        DOM.Document doc = getEnvelope();       
        dom.XmlNode envelope = doc.getRootElement();
        dom.XmlNode body = envelope.getChildElement('Body', soapNS);
        
        dom.XmlNode method = body.addChildElement('getBillingSummary', serviceNSAccount, 'sear');
        method.addChildElement('account', serviceNSAccount, null).addTextNode(accountNoEncrypted);      
        
        return doc.toXmlString().replace('&lt;', '<'); //EncodingUtil.UrlDecode(doc.toXmlString().replace('&lt;', '<'), 'UTF-8');
    }

    // Create HTTP Request
    public static String getSubscriberLedgerSummaryEnvelope(string externalSystemName, string externalAccountReference)
    {
        DOM.Document doc = getEnvelope();       
        dom.XmlNode envelope = doc.getRootElement();
        dom.XmlNode body = envelope.getChildElement('Body', soapNS);
        
        dom.XmlNode method = body.addChildElement('getSubscriberLedgerSummary', serviceNSFin, 'fin');
        method.addChildElement('externalSystemName', serviceNSFin, null).addTextNode(externalSystemName);       
        method.addChildElement('externalAccountReference', serviceNSFin, null).addTextNode(externalAccountReference);       
        
        return doc.toXmlString().replace('&lt;', '<'); //EncodingUtil.UrlDecode(doc.toXmlString().replace('&lt;', '<'), 'UTF-8');
    }    
    
    // Create HTTP Request
    public static String getSubscriberPaymentHistoryEnvelope(string externalSystemName, string externalAccountReference)
    {
        DOM.Document doc = getEnvelope();       
        dom.XmlNode envelope = doc.getRootElement();
        dom.XmlNode body = envelope.getChildElement('Body', soapNS);
        
        dom.XmlNode method = body.addChildElement('getSubscriberPaymentHistory', serviceNSFin, 'fin');
        method.addChildElement('externalSystemName', serviceNSFin, null).addTextNode(externalSystemName);       
        method.addChildElement('externalAccountReference', serviceNSFin, null).addTextNode(externalAccountReference);       
        
        return doc.toXmlString().replace('&lt;', '<'); //EncodingUtil.UrlDecode(doc.toXmlString().replace('&lt;', '<'), 'UTF-8');
    }
    
    // Create HTTP Request
    public static String getCurrentUsageByAccountEnvelope(string externalSystemName, string externalAccountReference)
    {
        DOM.Document doc = getEnvelope();       
        dom.XmlNode envelope = doc.getRootElement();
        dom.XmlNode body = envelope.getChildElement('Body', soapNS);
        
        dom.XmlNode method = body.addChildElement('getCurrentUsageByAccount', serviceNSPub, 'pub');
        method.addChildElement('externalSystemName', serviceNSPub, null).addTextNode(externalSystemName);       
        method.addChildElement('externalAccountReference', serviceNSPub, null).addTextNode(externalAccountReference);       
        
        return doc.toXmlString().replace('&lt;', '<'); //EncodingUtil.UrlDecode(doc.toXmlString().replace('&lt;', '<'), 'UTF-8');
    }

    // Create HTTP Request
    public static String getCurrentQuotaByAccountEnvelope(string externalSystemName, string externalAccountReference)
    {
        DOM.Document doc = getEnvelope();       
        dom.XmlNode envelope = doc.getRootElement();
        dom.XmlNode body = envelope.getChildElement('Body', soapNS);
        
        dom.XmlNode method = body.addChildElement('getCurrentQuotaByAccount', serviceNSPub, 'pub');
        method.addChildElement('externalSystemName', serviceNSPub, null).addTextNode(externalSystemName);       
        method.addChildElement('externalAccountReference', serviceNSPub, null).addTextNode(externalAccountReference);       
        
        return doc.toXmlString().replace('&lt;', '<'); //EncodingUtil.UrlDecode(doc.toXmlString().replace('&lt;', '<'), 'UTF-8');
    }
    
    // Hanu Cholleti
    // 10/14/2015
    // Create HTTP Request for Service Availabilty
    // Example: getServiceAvailabilityEnvelope('92008', 'WB_DIRECT')
    public static String getServiceAvailabilityEnvelope(string postalCode, string salesChannel)
    {
        DOM.Document doc = getEnvelope();       
        dom.XmlNode envelope = doc.getRootElement();
        dom.XmlNode body = envelope.getChildElement('Body', soapNS);
        
        dom.XmlNode method = body.addChildElement('getServiceAvailability', serviceNSServiceAvailability, 'pub');
        
        String lsAddressPostalCode = '<Address type="SERVICE">' +
                                     '<postalCode>' + postalCode + '</postalCode>'+
                                     '</Address>';
        
        method.addChildElement('location', serviceNSServiceAvailability, null).addTextNode(lsAddressPostalCode);       
        method.addChildElement('salesChannel', serviceNSServiceAvailability, null).addTextNode(salesChannel);       
        
        return doc.toXmlString().replace('&lt;', '<').replace('http://www.viasat.com/XMLSchema/PublicWebService/v2/PWSHeader','http://www.wildblue.viasat.com/XMLSchema/PublicWebService/v1.0/PWSHeader');
    }
    
    /**
    * @author Srikanth Kudumula
    * @description - findSubscriberBySearchCriteria V2,
    * @input param  - String list oprional fields
    * @return param - HttpResponse
    */
    public static Map<String,String> findSubscriberBySearchCriteriaV2(DealerSearchDTO searDTO) 
    {   
        OasisOpenOrgWssSecuritySecext.SecurityHeaderType Security = new OasisOpenOrgWssSecuritySecext.SecurityHeaderType(AtlasConstants.WEBSERVICE_USERNAME, AtlasConstants.WEBSERVICE_PWD);
        HttpRequest req = new HttpRequest(); 
        String wsEndPoint;
        if(!Test.isRunningTest())          
            wsEndPoint  = AtlasUtility.getWebServiceHost(string.valueOF(AtlasUtility.randomNumberGenerator()))+wsSettings.get(AtlasConstants.FIND_SUBSCRIBERV2).End_Point__c;
            //wsEndPoint  = 'http://requestb.in/ukorcruk';                                         
        else
            wsEndPoint  = 'test'; 
        req.setMethod('POST');
        req.setEndpoint(wsEndPoint);
        req.setTimeout(80000);
        req.setHeader('Content-Type', 'text/xml; charset=utf-8');
        req.setHeader('SOAPAction', '');
        
        String[] securityHeaderArgs = new String[] {Security.Timestamp.Created,Security.Timestamp.Expires,AtlasConstants.WEBSERVICE_USERNAME,AtlasConstants.WEBSERVICE_PWD,generateNounce(),Security.UsernameToken.Created};
        String secuirtyHeader = String.format(secuirtyHeaderTemplate, securityHeaderArgs);

        String wbHeader = '';
        String[] wbHeaderArgs = new String[] {'AtlasWebServiceTestUI','AtlasWebServiceTestUI'};
        wbHeader = String.format(wbHeaderTemplate, wbHeaderArgs);          
     
        String soapServiceCall = '';
        String[] args1 = new String[] {searDTO.internalReferenceType,searDTO.internalReference,searDTO.emailAddress,searDTO.phoneNumber,searDTO.firstName,searDTO.lastName,searDTO.maxresults};
        soapServiceCall = String.format(searchByFiltersTemplate1,args1) ; 
            
        String[] args2 = new String[] {secuirtyHeader,wbHeader,soapServiceCall};
        String wsRequestMsg = String.format(soapEnvelopTemplate,args2);   
        req.setBody(wsRequestMsg);
        
        Http http = new Http();
        HTTPResponse res ;
        try {   
          system.debug('--req-- '+ req);  
          res = http.send(req);
          wsReturn = res.getBody();
          searchResult = parseXML(wsReturn);                                                              
       } 
       catch(Exception e) {
            System.debug('Error Invoking the service' + e.getMessage());
       }
       return searchResult;       
    }
    
    /**
    * @author Srikanth Kudumula
    * @description - getAccount,
    * @input param  - DealerPubServiceV2PWSCommonData.ExternalSubscriberIdentifier exSubId
    * @return param account element
    */
    public static DealerPubAccountInfoXMLSchemaV2.account getAccount(DealerPubServiceV2PWSCommonData.ExternalSubscriberIdentifier exSubId)
    {
        DealerPubAccountInfoWsdlV2.AccountInfoEndpoint accStub=new DealerPubAccountInfoWsdlV2.AccountInfoEndpoint();
        accStub.endpoint_x=AtlasUtility.getWebServiceHost(string.valueOF(AtlasUtility.randomNumberGenerator()))+wsSettings.get(DealerConstants.ACCOUNT_INFOV2).End_Point__c; 
        //accStub.endpoint_x = 'https://webservices.test.wildblue.net/AccountInfoService/v2/services/AccountInfoService';
        accStub.timeout_x=AtlasConstants.TIMEOUT;
        DealerPubAccountInfoXMLSchemaV2.account response = null;
        system.debug('@@@---Parameters--->'+exSubId);
        try{
            response = accStub.getAccount(exSubId);
            system.debug('@@@---response--->'+response);
            if(AtlasUtility.isEmpty(response))
            throw new AtlasException.InvalidDataException(getExCode(AtlasConstants.AS_No_Data_Exp),getExValue(AtlasConstants.AS_No_Data_Exp));
        }
        catch(exception ex){
            system.debug('@@@---Stack Trace--->'+ex.getStackTraceString());
            System.debug('@@@---get Message--->'+ex.getMessage());
            throw new AtlasException.CalloutException(getExCode(AtlasConstants.AS_Callout_Exp),getExValue(AtlasConstants.AS_Callout_Exp));
        }
        if(!AtlasUtility.isEmpty(response))
            return response;
        return null;
    }
    
     /**
    * @author Srikanth Kudumula
    * @description - getinstallationInfo,
    * @input param  - DealerPubServiceV2PWSCommonData.ExternalSubscriberIdentifier exSubId
    * @return param installation info element
    */
    public static DealerPubAccountInfoXMLSchemaV2.installationInfo getInstallationInfo(DealerPubServiceV2PWSCommonData.ExternalSubscriberIdentifier exSubId)
    {
        DealerPubAccountInfoWsdlV2.AccountInfoEndpoint accStub=new DealerPubAccountInfoWsdlV2.AccountInfoEndpoint();
        accStub.endpoint_x=AtlasUtility.getWebServiceHost(string.valueOF(AtlasUtility.randomNumberGenerator()))+wsSettings.get(DealerConstants.ACCOUNT_INFOV2).End_Point__c; 
        accStub.timeout_x=AtlasConstants.TIMEOUT;
        DealerPubAccountInfoXMLSchemaV2.installationInfo response = null;
        system.debug('@@@---Parameters--->'+exSubId);
        try{
            response = accStub.getInstallationInfo(exSubId);
            system.debug('@@@---response--->'+response);
            if(AtlasUtility.isEmpty(response))
            throw new AtlasException.InvalidDataException(getExCode(AtlasConstants.AS_No_Data_Exp),getExValue(AtlasConstants.AS_No_Data_Exp));
        }
        catch(exception ex){
            system.debug('@@@---Stack Trace--->'+ex.getStackTraceString());
            System.debug('@@@---get Message--->'+ex.getMessage());
            throw new AtlasException.CalloutException(getExCode(AtlasConstants.AS_Callout_Exp),getExValue(AtlasConstants.AS_Callout_Exp));
        }
        if(!AtlasUtility.isEmpty(response))
            return response;
        return null;
    }
    
    /**
    * @author Srikanth Kudumula
    * @description - getAllAccountServices,
    * @input param  - DealerPubServiceV2PWSCommonData.ExternalSubscriberIdentifier exSubId
    * @return param Account service element
    */
    public static DealerPubAccountInfoXMLSchemaV2.accountService[] getAllAccountServices(DealerPubServiceV2PWSCommonData.ExternalSubscriberIdentifier exSubId)
    {
        DealerPubAccountInfoWsdlV2.AccountInfoEndpoint accStub=new DealerPubAccountInfoWsdlV2.AccountInfoEndpoint();
        accStub.endpoint_x=AtlasUtility.getWebServiceHost(string.valueOF(AtlasUtility.randomNumberGenerator()))+wsSettings.get(DealerConstants.ACCOUNT_INFOV2).End_Point__c; 
        accStub.timeout_x=AtlasConstants.TIMEOUT;
        DealerPubAccountInfoXMLSchemaV2.accountService[] response = null;
        system.debug('@@@---Parameters--->'+exSubId);
        try{
            response = accStub.getAllAccountServices(exSubId);
            system.debug('@@@---response--->'+response);
            if(AtlasUtility.isEmpty(response))
            throw new AtlasException.InvalidDataException(getExCode(AtlasConstants.AS_No_Data_Exp),getExValue(AtlasConstants.AS_No_Data_Exp));
        }
        catch(exception ex){
            system.debug('@@@---Stack Trace--->'+ex.getStackTraceString());
            System.debug('@@@---get Message--->'+ex.getMessage());
            throw new AtlasException.CalloutException(getExCode(AtlasConstants.AS_Callout_Exp),getExValue(AtlasConstants.AS_Callout_Exp));
        }
        if(!AtlasUtility.isEmpty(response))
            return response;
        return null;
    }
    
    /**
    * @author Srikanth Kudumula
    * @description - getAccountProvisioningInfo,
    * @input param  - DealerPubServiceV2PWSCommonData.ExternalSubscriberIdentifier exSubId
    * @return param Account service element
    */
    public static DealerPubAccountInfoXMLSchemaV2.provisioningInfoBean[] getAccountProvisioningInfo(DealerPubServiceV2PWSCommonData.ExternalSubscriberIdentifier exSubId)
    {
        DealerPubAccountInfoWsdlV2.AccountInfoEndpoint accStub=new DealerPubAccountInfoWsdlV2.AccountInfoEndpoint();
        accStub.endpoint_x=AtlasUtility.getWebServiceHost(string.valueOF(AtlasUtility.randomNumberGenerator()))+wsSettings.get(DealerConstants.ACCOUNT_INFOV2).End_Point__c; 
        accStub.timeout_x=AtlasConstants.TIMEOUT;
        DealerPubAccountInfoXMLSchemaV2.provisioningInfoBean[] response = null;
        system.debug('@@@---Parameters--->'+exSubId);
        try{
            response = accStub.getAccountProvisioningInfo(exSubId);
            system.debug('@@@---response--->'+response);
            if(AtlasUtility.isEmpty(response))
            throw new AtlasException.InvalidDataException(getExCode(AtlasConstants.AS_No_Data_Exp),getExValue(AtlasConstants.AS_No_Data_Exp));
        }
        catch(exception ex){
            system.debug('@@@---Stack Trace--->'+ex.getStackTraceString());
            System.debug('@@@---get Message--->'+ex.getMessage());
            throw new AtlasException.CalloutException(getExCode(AtlasConstants.AS_Callout_Exp),getExValue(AtlasConstants.AS_Callout_Exp));
        }
        if(!AtlasUtility.isEmpty(response))
            return response;
        return null;
    }
	
	/**
    * @author Srikanth Kudumula
    * @description - getBillingSummary,
    * @input param  - DealerPubServiceV2PWSCommonData.ExternalSubscriberIdentifier exSubId
    * @return param Account service element
    */
    public static DealerPubAccountInfoXMLSchemaV2.billingSummary getBillingSummary(DealerPubServiceV2PWSCommonData.ExternalSubscriberIdentifier exSubId)
    {
        DealerPubAccountInfoWsdlV2.AccountInfoEndpoint accStub=new DealerPubAccountInfoWsdlV2.AccountInfoEndpoint();
        accStub.endpoint_x=AtlasUtility.getWebServiceHost(string.valueOF(AtlasUtility.randomNumberGenerator()))+wsSettings.get(DealerConstants.ACCOUNT_INFOV2).End_Point__c; 
        accStub.timeout_x=AtlasConstants.TIMEOUT;
        DealerPubAccountInfoXMLSchemaV2.billingSummary response = null;
        system.debug('@@@---Parameters-->'+exSubId);
        try{
            response = accStub.getBillingSummary(exSubId);
            system.debug('@@@---response--->'+response);
            if(AtlasUtility.isEmpty(response))
            throw new AtlasException.InvalidDataException(getExCode(AtlasConstants.AS_No_Data_Exp),getExValue(AtlasConstants.AS_No_Data_Exp));
        }
        catch(exception ex){
            system.debug('@@@---Stack Trace--->'+ex.getStackTraceString());
            System.debug('@@@---get Message--->'+ex.getMessage());
            throw new AtlasException.CalloutException(getExCode(AtlasConstants.AS_Callout_Exp),getExValue(AtlasConstants.AS_Callout_Exp));
        }
        if(!AtlasUtility.isEmpty(response))
            return response;
        return null;
    }
	
	/**
    * @author Srikanth Kudumula
    * @description - getBillingInfo,
    * @input param  - DealerPubServiceV2PWSCommonData.ExternalSubscriberIdentifier exSubId
    * @return param Account service element
    */
    public static DealerPubAccountInfoXMLSchemaV2.billingInfoBean getBillingInfo(DealerPubServiceV2PWSCommonData.ExternalSubscriberIdentifier exSubId)
    {
        DealerPubAccountInfoWsdlV2.AccountInfoEndpoint accStub=new DealerPubAccountInfoWsdlV2.AccountInfoEndpoint();
        accStub.endpoint_x=AtlasUtility.getWebServiceHost(string.valueOF(AtlasUtility.randomNumberGenerator()))+wsSettings.get(DealerConstants.ACCOUNT_INFOV2).End_Point__c; 
        accStub.timeout_x=AtlasConstants.TIMEOUT;
        DealerPubAccountInfoXMLSchemaV2.billingInfoBean response = null;
        system.debug('@@@---Parameters--->'+exSubId);
        try{
            response = accStub.getBillingInfo(exSubId);
            system.debug('@@@---response--->'+response);
            if(AtlasUtility.isEmpty(response))
            throw new AtlasException.InvalidDataException(getExCode(AtlasConstants.AS_No_Data_Exp),getExValue(AtlasConstants.AS_No_Data_Exp));
        }
        catch(exception ex){
            system.debug('@@@---Stack Trace--->'+ex.getStackTraceString());
            System.debug('@@@---get Message--->'+ex.getMessage());
            throw new AtlasException.CalloutException(getExCode(AtlasConstants.AS_Callout_Exp),getExValue(AtlasConstants.AS_Callout_Exp));
        }
        if(!AtlasUtility.isEmpty(response))
            return response;
        return null;
    }
    
    /**
    * @author Tejesh Kumar
    * @description - updateContacts
    * @input param  - String AtlasTransactionDTO.UpdateCustomerInfoTxDTO custInfoObj
    * @return param String
    */  
    public static String updateContacts(AtlasTransactionDTO.UpdateCustomerInfoTxDTO custInfoObj)
    { 
        AtlasTestConstants.WEBSERVICE_NAME=AtlasConstants.UPDATE_CONTACT_INFO;  
        AtlasPubContactServWsdlV1.PublicContactServiceEndpoint contactStub=new AtlasPubContactServWsdlV1.PublicContactServiceEndpoint();
        contactStub.endpoint_x=AtlasUtility.getWebServiceHost(string.valueOF(AtlasUtility.randomNumberGenerator()))+wsSettings.get(AtlasConstants.UPDATE_CONTACT_SERVICE).End_Point__c;  
        //contactStub.endpoint_x='http://requestb.in/vm58d4vm'; 
        contactStub.timeout_x=AtlasConstants.TIMEOUT; 
       
        String response=null;
		
		AtlasPubContactServXmlschema.CorrectedContact correctedContact=new AtlasPubContactServXmlschema.CorrectedContact();
		if(!AtlasUtility.isEmpty(custInfoObj.email))
			correctedContact.emailAddress=custInfoObj.email;
        try
        {   
            response=contactStub.updateContacts(custInfoObj.externalAccountReference,custInfoObj.externalSystemName,AtlasConstants.SF_ORG_NAME+System.now(),correctedContact) ;        
            System.debug('---updateContact--->' + response);
        }
        catch(CalloutException e)
        {
            System.debug('---Error - updateContact - ' + e.getMessage());
        }   
        return response; 
    }
    
     /**
    * @author Tejesh Kumar
    * @description - updateShippingContact,
    * @input param  - String externalSystemName,String externalTransactionReference,String externalServiceAgreementReference,String enteredBy,AtlasTransServiceXmlschemaPWSCommonData.Contact shippingContact
    * @return param - String
    */
    Public static String updateShippingContact(AtlasTransactionDTO.UpdateCustomerInfoTxDTO custInfoObj) 
    {   
        AtlasTransServiceWsdlTransService.TransactionServiceEndpoint updateShippingContactStub=new AtlasTransServiceWsdlTransService.TransactionServiceEndpoint();
        updateShippingContactStub.endpoint_x=AtlasUtility.getWebServiceHost(string.valueOF(AtlasUtility.randomNumberGenerator()))+wsSettings.get(AtlasConstants.TX_SERVICE).End_Point__c;
        //updateShippingContactStub.endpoint_x = 'http://requestb.in/1bh4oas1'; 
        updateShippingContactStub.timeout_x=AtlasConstants.TIMEOUT;
        AtlasTransServiceXmlschemaPWSHeader.wildBlueHeader wbHeaderObj=new AtlasTransServiceXmlschemaPWSHeader.wildBlueHeader();
        AtlasTransServiceXmlschemaPWSHeader.invokedBy invokedByObj=new AtlasTransServiceXmlschemaPWSHeader.invokedBy();
        invokedByObj.application=AtlasConstants.INVOKED_BY_APP;
        invokedByObj.username=AtlasConstants.INVOKED_BY_USERNAME;
        wbHeaderObj.invokedBy=invokedByObj;
        updateShippingContactStub.wildBlueHeader=wbHeaderObj; 
		
        String updateShippingContactResponse=null;
		
		AtlasTransServiceXmlschemaPWSCommonData.Contact shippingContact = new AtlasTransServiceXmlschemaPWSCommonData.Contact();
		AtlasTransServiceXmlschemaPWSCommonData.Person personDetails = new AtlasTransServiceXmlschemaPWSCommonData.Person();
		AtlasTransServiceXmlschemaPWSCommonData.ContactInfo contactInfoDetails = new AtlasTransServiceXmlschemaPWSCommonData.ContactInfo();
		
		system.debug('---custInfoObj----'+custInfoObj);

		personDetails.firstname = custInfoObj.firstName;
		personDetails.lastName = custInfoObj.lastName;
		
		contactInfoDetails.emailAddress = custInfoObj.email;
		contactInfoDetails.primaryPhone = custInfoObj.phone;
		contactInfoDetails.contactType = 'SHIPPING';
		
		AtlasTransServiceXmlschemaPWSLocation.Location PwsLocation = new AtlasTransServiceXmlschemaPWSLocation.Location();		
		AtlasTransServiceXmlschemaPWSLocation.Address AddressLocation = new AtlasTransServiceXmlschemaPWSLocation.Address();
		
		AddressLocation.countryCode=custInfoObj.countryCode;
		AddressLocation.postalCode=custInfoObj.zipCode;
		AddressLocation.region=custInfoObj.state;
		AddressLocation.municipality=custInfoObj.city;
		AddressLocation.addressLine=new String[]{custInfoObj.billingAddress1};
        if(!AtlasUtility.isEmpty(custInfoObj.billingAddress2))
        	AddressLocation.addressLine.add(custInfoObj.billingAddress2);
		
		PwsLocation.Address=AddressLocation;
		
		contactInfoDetails.location = PwsLocation; 
		shippingContact.person = personDetails;
		shippingContact.contactInfo = contactInfoDetails;
		
		system.debug('---shippingContact----'+shippingContact);
		 
        try
        {              
            updateShippingContactResponse = updateShippingContactStub.updateShippingContact(custInfoObj.externalSystemName,AtlasConstants.SF_ORG_NAME+System.now(),custInfoObj.externalAccountReference,'MyExede',shippingContact); 
        }
        catch(CalloutException e)
        {   
            system.debug('@@@---> Rsponse'+updateShippingContactResponse);
            system.debug('@@@---> Exception'+e);
            system.debug('@@@---> Exception MSG'+e.getMessage());
        }
        return updateShippingContactResponse;
    }  
    
}