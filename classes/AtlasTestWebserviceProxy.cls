/*********************************************************************************
Name         : AtlasTestWebserviceProxy 
Created By   : Gaurav Gathania
Modified BY  : Gaurav Gathania
Company Name : NTT Data
Project      : ViaSat Atlas, Bangalore
Created Date : 28 October 2013
Modified Date: 13 November 2013
Usages       : Atlas Webservice Testing Framwork called from : AtlasTestMainClass
*********************************************************************************/
@isTest
global  with sharing class AtlasTestWebserviceProxy  implements WebServiceMock 
{ 
	global void doInvoke(
           Object stub,
           Object request,
           Map<String, Object> response,
           String endpoint,
           String soapAction,
           String requestName,
           String responseNS,
           String responseName,
           String responseType) 
	{ 
		if(requestName.contains('findTransactionsByExternalReference'))
		{
			AtlasPublicWebServiceSearchServiceStub.Transaction_x c=(AtlasPublicWebServiceSearchServiceStub.Transaction_x)JSON.deserialize(AtlasTestConstants.getMetadata('findSubscriberResponse'),AtlasPublicWebServiceSearchServiceStub.Transaction_x.class);
			AtlasPublicWebServiceSearchServiceStub.Transaction_x [] cList=new AtlasPublicWebServiceSearchServiceStub.Transaction_x[]{c};
			AtlasPublicWebServiceSearchServiceStub.findTransactionsByExternalReferenceResponse respElement = new AtlasPublicWebServiceSearchServiceStub.findTransactionsByExternalReferenceResponse();
			respElement.transaction_x=cList;
			response.put('response_x', respElement);
		}
		else if(requestName.contains('findSubscribersBySearchCriteria'))
		{
			//AtlasTestConstants.WEBSERVICE_NAME=AtlasConstants.FIND_SUBSCRIBER; 
                    //AtlasPublicWebServiceSearchServiceStub.Subscriber c=(AtlasPublicWebServiceSearchServiceStub.Subscriber)JSON.deserialize(AtlasTestConstants.getMetadata('findSubscribersBySearchCriteriaResponse'),AtlasPublicWebServiceSearchServiceStub.Subscriber.class);
                    //AtlasPublicWebServiceSearchServiceStub.Subscriber [] cList=new AtlasPublicWebServiceSearchServiceStub.Subscriber[]{c};
                    //AtlasPublicWebServiceSearchServiceStub.findSubscribersBySearchCriteriaResponse respElement = new AtlasPublicWebServiceSearchServiceStub.findSubscribersBySearchCriteriaResponse();
                    //respElement.subscriber=cList;
                    //response.put('response_x', respElement);

	   		AtlasPublicWebServiceSearchServiceStub.findSubscribersBySearchCriteriaResponse respElement=(AtlasPublicWebServiceSearchServiceStub.findSubscribersBySearchCriteriaResponse)JSON.deserialize(AtlasTestConstants.getMetadata('findSubscriberResponse'),AtlasPublicWebServiceSearchServiceStub.findSubscribersBySearchCriteriaResponse.class);                    
			response.put('response_x', respElement);
		}
		else if(requestName.contains('getLegacyAccount'))
		{
			//AtlasTestConstants.WEBSERVICE_NAME=AtlasConstants.GET_LEGACYACCOUNT;
			AtlasPublicWebServiceSearchServiceStub.getLegacyAccountResponse respElement = new AtlasPublicWebServiceSearchServiceStub.getLegacyAccountResponse();
			respElement.account='Mock response';
			response.put('response_x', respElement);
		}
		else if(requestName.contains('findTransactionsBySearchCriteria'))
		{
			AtlasPublicWebServiceSearchServiceStub.Transaction_x c=(AtlasPublicWebServiceSearchServiceStub.Transaction_x)JSON.deserialize(AtlasTestConstants.getMetadata('findSubscriberResponse'),AtlasPublicWebServiceSearchServiceStub.Transaction_x.class);
			AtlasPublicWebServiceSearchServiceStub.Transaction_x [] cList=new AtlasPublicWebServiceSearchServiceStub.Transaction_x[]{c};
			AtlasPublicWebServiceSearchServiceStub.findTransactionsBySearchCriteriaResponse respElement = new AtlasPublicWebServiceSearchServiceStub.findTransactionsBySearchCriteriaResponse();
			respElement.transaction_x=cList;
			response.put('response_x', respElement);
		}
		else if(requestName.contains('updateContacts') || requestName.contains('findAddressAndTaxJurisdictions'))
		{
			//AtlasTestConstants.WEBSERVICE_NAME=AtlasConstants.UPDATE_CONTACT_INFO;
			AtlasPubContactServXmlschema.updateContactsResponse_element respElement = new AtlasPubContactServXmlschema.updateContactsResponse_element();
			respElement.result='Success';
			response.put('response_x', respElement);
		}
		else if(requestName.contains('updatePaymentMethod'))
		{
			//AtlasTestConstants.WEBSERVICE_NAME=AtlasConstants.UPDATE_PAYMENT;
			AtlasFinServiceXmlschemaFinanceService.updatePaymentMethodResponse_element respElement= new AtlasFinServiceXmlschemaFinanceService.updatePaymentMethodResponse_element();
			respElement.result='Success';
			response.put('response_x', respElement);
		}
		else if(requestName.contains('submitOneTimePayment')) //submitOneTimePaymentAutoResume
		{
	        //AtlasTestConstants.WEBSERVICE_NAME=AtlasConstants.MAKE_ONE_TIME_PAY;
			AtlasFinServiceXmlschemaFinanceService.updatePaymentMethodResponse_element respElement = new AtlasFinServiceXmlschemaFinanceService.updatePaymentMethodResponse_element();
			respElement.result='Success';
			response.put('response_x', respElement);
		}
		else if(requestName.contains('getSubscriberOneTimeChargeHistory'))
		{
			AtlasFinServiceXmlschemaV4FinanceService.OneTimeChargeHistoryItem x=(AtlasFinServiceXmlschemaV4FinanceService.OneTimeChargeHistoryItem)JSON.deserialize(AtlasTestConstants.getMetadata('retieveInvoiceOneTimeCharges'),AtlasFinServiceXmlschemaV4FinanceService.OneTimeChargeHistoryItem.class);
			AtlasFinServiceXmlschemaV4FinanceService.getSubscriberOneTimeChargeHistoryResponse_element respElement = new AtlasFinServiceXmlschemaV4FinanceService.getSubscriberOneTimeChargeHistoryResponse_element();
			respElement.allOneTimeCharges =x;
			response.put('response_x', respElement);
		}
		else if(requestName.contains('findCustomersByMacAddress'))
		{
			AtlasCustomerSearchWS.customerInfoBean c=(AtlasCustomerSearchWS.customerInfoBean)JSON.deserialize(AtlasTestConstants.getMetadata('findmacaddressResponse'),AtlasCustomerSearchWS.customerInfoBean.class);
			AtlasCustomerSearchWS.customerInfoBean [] cList=new AtlasCustomerSearchWS.customerInfoBean[]{c};
			AtlasCustomerSearchWS.findCustomersByMacAddressResponse respElement = new AtlasCustomerSearchWS.findCustomersByMacAddressResponse();
			respElement.customer =cList;
			response.put('response_x', respElement);
		}
		else if(requestName.contains('findCustomers')) 
		{
	        //AtlasTestConstants.WEBSERVICE_NAME=AtlasConstants.CUSTOMER_SEARCH;  
   		 	AtlasCustomerSearchWS.customerInfoBean c=(AtlasCustomerSearchWS.customerInfoBean )JSON.deserialize(AtlasTestConstants.getMetadata('searchCustomerArrayResponseArr'), AtlasCustomerSearchWS.customerInfoBean.class);
      	 	AtlasCustomerSearchWS.customerInfoBean [] cList=new AtlasCustomerSearchWS.customerInfoBean []{c};
      	 	AtlasCustomerSearchWS.findCustomersResponse respElement=new AtlasCustomerSearchWS.findCustomersResponse();
       	 	respElement.Customer=cList;
			response.put('response_x', respElement);
		}
		else if(requestName.contains('addUsageQuota'))
		{
            //AtlasTestConstants.WEBSERVICE_NAME=AtlasConstants.BUY_MORE;
			AtlasTransServiceXmlschemav2.addUsageQuotaResponse_element respElement= new AtlasTransServiceXmlschemav2.addUsageQuotaResponse_element();
			respElement.result='Success';
			response.put('response_x', respElement);
		}
		else if(requestName.contains('getAccountServiceAgreementsAndServices'))
		{
        	//AtlasTestConstants.WEBSERVICE_NAME=AtlasConstants.GET_SERVICEAGREEMENTS;    
			AtlasAccInfoXmlschemaPublic.accountServiceAgreementsBean c=(AtlasAccInfoXmlschemaPublic.accountServiceAgreementsBean)JSON.deserialize(AtlasTestConstants.getMetadata('getAccountServiceAgreementsAndServicesResponseArr') , AtlasAccInfoXmlschemaPublic.accountServiceAgreementsBean.class);
			AtlasAccInfoXmlschemaPublic.accountServiceAgreementsBean [] cList=new AtlasAccInfoXmlschemaPublic.accountServiceAgreementsBean []{c};
			AtlasAccInfoXmlschemaPublic.getAccountServiceAgreementsAndServicesResponse respElement=new AtlasAccInfoXmlschemaPublic.getAccountServiceAgreementsAndServicesResponse();
			respElement.accountServiceAgreements=cList;
			response.put('response_x', respElement);
		}
		else if(requestName.contains('getBillingSummary')) 
		{
			//AtlasTestConstants.WEBSERVICE_NAME=AtlasConstants.GET_BILLING;   
			AtlasAccInfoXmlschemaPublic.billingSummary x=(AtlasAccInfoXmlschemaPublic.billingSummary)JSON.deserialize(AtlasTestConstants.getMetadata('getBillingSummaryResponse'),AtlasAccInfoXmlschemaPublic.billingSummary.class);
			AtlasAccInfoXmlschemaPublic.getBillingSummaryResponse respElement= new AtlasAccInfoXmlschemaPublic.getBillingSummaryResponse();
			respElement.billingSummaryBean=x;
			response.put('response_x', respElement);
		}
		else if(requestName.contains('getSubscriberCurrentPaymentMethod')) 
		{	
			//AtlasTestConstants.WEBSERVICE_NAME=AtlasConstants.GET_SUBSCRIBER_PaymentMethod;
			AtlasFinServiceXmlschemaFinanceService.PaymentMethodHistoryItem x=(AtlasFinServiceXmlschemaFinanceService.PaymentMethodHistoryItem)JSON.deserialize(AtlasTestConstants.getMetadata('getSubscriberCurrentPaymentMethodResponse'),AtlasFinServiceXmlschemaFinanceService.PaymentMethodHistoryItem.class);
			AtlasFinServiceXmlschemaFinanceService.getSubscriberCurrentPaymentMethodResponse_element respElement= new AtlasFinServiceXmlschemaFinanceService.getSubscriberCurrentPaymentMethodResponse_element();
			respElement.paymentMethods=x;
			response.put('response_x', respElement);
		}
		else if(requestName.contains('getSubscriberInvoiceDetails')) 
		{
        	//AtlasTestConstants.WEBSERVICE_NAME=AtlasConstants.GET_SUBSCRIBER_INVOICE;  
			AtlasFinServiceXmlschemaFinanceService.SubscriberInvoiceDetails x=(AtlasFinServiceXmlschemaFinanceService.SubscriberInvoiceDetails)JSON.deserialize(AtlasTestConstants.getMetadata('getSubscriberInvoiceDetailsResponse'),AtlasFinServiceXmlschemaFinanceService.SubscriberInvoiceDetails.class);
			AtlasFinServiceXmlschemaFinanceService.getSubscriberInvoiceDetailsResponse_element respElement= new AtlasFinServiceXmlschemaFinanceService.getSubscriberInvoiceDetailsResponse_element();
			respElement.subscriberInvoiceDetail=x;
			response.put('response_x', respElement);
		}
		else if(requestName.contains('getSubscriberEventHistory')) 
		{
			AtlasFinServiceXmlschemaFinanceService.EventHistoryItem c= (AtlasFinServiceXmlschemaFinanceService.EventHistoryItem)JSON.deserialize(AtlasTestConstants.getMetadata('getCDRInvoceResponse'),AtlasFinServiceXmlschemaFinanceService.EventHistoryItem.class);
			AtlasFinServiceXmlschemaFinanceService.EventHistoryItem[] clist = new AtlasFinServiceXmlschemaFinanceService.EventHistoryItem[]{c};
			AtlasFinServiceXmlschemaFinanceService.getSubscriberEventHistoryResponse_element respElement= new AtlasFinServiceXmlschemaFinanceService.getSubscriberEventHistoryResponse_element();
			respElement.events=clist;
			response.put('response_x', respElement);
		}
		else if(requestName.contains('getSubscriberInvoiceSummaries')) 
		{
			//AtlasTestConstants.WEBSERVICE_NAME=AtlasConstants.BILLING_HISTORY;
			AtlasFinServiceXmlschemaFinanceService.SubscriberInvoiceSummaries c=(AtlasFinServiceXmlschemaFinanceService.SubscriberInvoiceSummaries)JSON.deserialize(AtlasTestConstants.getMetadata('getBillingHistoryResponse'),AtlasFinServiceXmlschemaFinanceService.SubscriberInvoiceSummaries.class);
			AtlasFinServiceXmlschemaFinanceService.getSubscriberInvoiceSummariesResponse_element respElement=new AtlasFinServiceXmlschemaFinanceService.getSubscriberInvoiceSummariesResponse_element();
			respElement.subscriberInvoiceSummaries=c;
			response.put('response_x', respElement);
		}
		else if(requestName.contains('getSubscriberLedgerSummary')) 
		{
			//AtlasTestConstants.WEBSERVICE_NAME=AtlasConstants.BILLING_SNAPSHOT;
   	 		AtlasFinServiceXmlschemaFinanceService.SubscriberLedgerSummary c=(AtlasFinServiceXmlschemaFinanceService.SubscriberLedgerSummary)JSON.deserialize(AtlasTestConstants.getMetadata('getBillingsnapShotResponse'),AtlasFinServiceXmlschemaFinanceService.SubscriberLedgerSummary.class);
   			AtlasFinServiceXmlschemaFinanceService.getSubscriberLedgerSummaryResponse_element respElement=new AtlasFinServiceXmlschemaFinanceService.getSubscriberLedgerSummaryResponse_element();
   			respElement.subscriberLedgerSummary=c;
			response.put('response_x', respElement);
		}
		else if(requestName.contains('getSubscriberPaymentHistory')) 
		{
        	//AtlasTestConstants.WEBSERVICE_NAME=AtlasConstants.GET_SUBSCRIBER_PAYMENTS;  
   	 		AtlasFinServiceXmlschemaFinanceService.PaymentHistoryItem c=(AtlasFinServiceXmlschemaFinanceService.PaymentHistoryItem)JSON.deserialize(AtlasTestConstants.getMetadata('getSubscriberPaymentHistoryResponseArr'),AtlasFinServiceXmlschemaFinanceService.PaymentHistoryItem.class);
   			AtlasFinServiceXmlschemaFinanceService.getSubscriberPaymentHistoryResponse_element respElement=new AtlasFinServiceXmlschemaFinanceService.getSubscriberPaymentHistoryResponse_element();
   			respElement.payments=new AtlasFinServiceXmlschemaFinanceService.PaymentHistoryItem[]{c};
			response.put('response_x', respElement);
		}
		else if(requestName.contains('getCurrentUsageByAccount') || AtlasTestConstants.WEBSERVICE_NAME==AtlasConstants.CURRENT_DATA_USAGE) 
		{
			//AtlasTestConstants.WEBSERVICE_NAME=AtlasConstants.CURRENT_DATA_USAGE;   
	   		AtlasPubUsageServiceXmlschemaV1Web.serviceAgreementUsage_element x=(AtlasPubUsageServiceXmlschemaV1Web.serviceAgreementUsage_element)JSON.deserialize(AtlasTestConstants.getMetadata('getCurrentUsageByAccountResponseArr'),AtlasPubUsageServiceXmlschemaV1Web.serviceAgreementUsage_element.class);
			AtlasPubUsageServiceXmlschemaV1Web.getCurrentUsageByAccountResponse_element respElement=new AtlasPubUsageServiceXmlschemaV1Web.getCurrentUsageByAccountResponse_element();
			respElement.serviceAgreementUsage=new AtlasPubUsageServiceXmlschemaV1Web.serviceAgreementUsage_element[]{x};
			response.put('response_x', respElement);
		}
		
		else if(requestName.contains('getSubscriberDisputeHistory'))
		{
			//AtlasTestConstants.WEBSERVICE_NAME=AtlasConstants.UPDATE_PAYMENT;
			AtlasFinServiceXmlschemaV4FinanceService.DisputeHistoryItem[] cList = new AtlasFinServiceXmlschemaV4FinanceService.DisputeHistoryItem[]{};
			AtlasFinServiceXmlschemaV4FinanceService.getSubscriberDisputeHistoryResponse_element respElement=new AtlasFinServiceXmlschemaV4FinanceService.getSubscriberDisputeHistoryResponse_element();
			respElement.disputes=cList;
			response.put('response_x', respElement);
		}
		
		AtlasTestConstants.WEBSERVICE_NAME = '';
	}
/*
	global void doInvoke(
           Object stub,
           Object request,
           Map<String, Object> response,
           String endpoint,
           String soapAction,
           String requestName,
           String responseNS,
           String responseName,
           String responseType) 
           {
     
      Object respElement=null;
      if(AtlasTestConstants.WEBSERVICE_NAME==AtlasConstants.CUSTOMER_SEARCH)
      		respElement=getCustomerSearchResponse();
      if(AtlasTestConstants.WEBSERVICE_NAME==AtlasConstants.GET_SERVICEAGREEMENTS)
      		respElement=getAccountServiceAgreementsAndServices();
      if(AtlasTestConstants.WEBSERVICE_NAME==AtlasConstants.GET_BILLING)
      		respElement=getBillingSummary();
      if(AtlasTestConstants.WEBSERVICE_NAME==AtlasConstants.CURRENT_DATA_USAGE)
      		respElement=getCurrentUsageByAccount();
      if(AtlasTestConstants.WEBSERVICE_NAME==AtlasConstants.GET_SUBSCRIBER_PaymentMethod)
      		respElement=getSubscriberCurrentPaymentMethod();
      if(AtlasTestConstants.WEBSERVICE_NAME==AtlasConstants.BILLING_HISTORY)
      		respElement=getBillingHistory();
      if(AtlasTestConstants.WEBSERVICE_NAME==AtlasConstants.BILLING_SNAPSHOT)
      		respElement=getBillingsnapShot();
      if(AtlasTestConstants.WEBSERVICE_NAME==AtlasConstants.GET_SUBSCRIBER_INVOICE)
      		respElement=getSubscriberInvoiceDetails();
      if(AtlasTestConstants.WEBSERVICE_NAME==AtlasConstants.GET_SUBSCRIBER_PAYMENTS)
      		respElement=getSubscriberPaymentHistory();
      if(AtlasTestConstants.WEBSERVICE_NAME==AtlasConstants.UPDATE_CONTACT_INFO)
      		respElement=updateContacts();
      if(AtlasTestConstants.WEBSERVICE_NAME==AtlasConstants.BUY_MORE)
      		respElement=addUsageQuota();
      if(AtlasTestConstants.WEBSERVICE_NAME==AtlasConstants.MAKE_ONE_TIME_PAY)
      		respElement=submitOneTimePayment();
      if(AtlasTestConstants.WEBSERVICE_NAME==AtlasConstants.FIND_SUBSCRIBER)
      		respElement=findSubscriber();
      if(AtlasTestConstants.WEBSERVICE_NAME==AtlasConstants.GET_LEGACYACCOUNT)
      		respElement=getLegacyAccount();
      if(AtlasTestConstants.WEBSERVICE_NAME==AtlasConstants.UPDATE_PAYMENT)
      		respElement=updatePaymenSetting();		   
		response.put('response_x', respElement); 
	}
   
   public AtlasCustomerSearchWS.findCustomersResponse getCustomerSearchResponse()
   {
   		 AtlasCustomerSearchWS.customerInfoBean c=(AtlasCustomerSearchWS.customerInfoBean )JSON.deserialize(AtlasTestConstants.getMetadata('searchCustomerArrayResponseArr'), AtlasCustomerSearchWS.customerInfoBean.class);
      	 AtlasCustomerSearchWS.customerInfoBean [] cList=new AtlasCustomerSearchWS.customerInfoBean []{c};
      	 AtlasCustomerSearchWS.findCustomersResponse respElement=new AtlasCustomerSearchWS.findCustomersResponse();
       	 respElement.Customer=cList;
       	 
       	 return respElement;
   }
   public AtlasAccInfoXmlschemaPublic.getAccountServiceAgreementsAndServicesResponse getAccountServiceAgreementsAndServices()
   {	AtlasAccInfoXmlschemaPublic.accountServiceAgreementsBean c=(AtlasAccInfoXmlschemaPublic.accountServiceAgreementsBean)JSON.deserialize(AtlasTestConstants.getMetadata('getAccountServiceAgreementsAndServicesResponseArr'),AtlasAccInfoXmlschemaPublic.accountServiceAgreementsBean.class);
   		AtlasAccInfoXmlschemaPublic.accountServiceAgreementsBean [] cList=new AtlasAccInfoXmlschemaPublic.accountServiceAgreementsBean[]{c};
      	AtlasAccInfoXmlschemaPublic.getAccountServiceAgreementsAndServicesResponse respElement=new AtlasAccInfoXmlschemaPublic.getAccountServiceAgreementsAndServicesResponse();
       	respElement.accountServiceAgreements=cList;
   		return respElement;
   }
   public AtlasAccInfoXmlschemaPublic.getBillingSummaryResponse getBillingSummary()
   {	AtlasAccInfoXmlschemaPublic.billingSummary c=(AtlasAccInfoXmlschemaPublic.billingSummary)JSON.deserialize(AtlasTestConstants.getMetadata('getBillingSummaryResponse'),AtlasAccInfoXmlschemaPublic.billingSummary.class);
   		AtlasAccInfoXmlschemaPublic.getBillingSummaryResponse respElement=new AtlasAccInfoXmlschemaPublic.getBillingSummaryResponse();
       	respElement.billingSummaryBean=c;
   		return respElement;
   }
   public AtlasPubUsageServiceXmlschemaV1Web.getCurrentUsageByAccountResponse_element getCurrentUsageByAccount()
   {
   		AtlasPubUsageServiceXmlschemaV1Web.serviceAgreementUsage_element c=(AtlasPubUsageServiceXmlschemaV1Web.serviceAgreementUsage_element)JSON.deserialize(AtlasTestConstants.getMetadata('getCurrentUsageByAccountResponseArr'),AtlasPubUsageServiceXmlschemaV1Web.serviceAgreementUsage_element.class);
   		AtlasPubUsageServiceXmlschemaV1Web.getCurrentUsageByAccountResponse_element respElement=new AtlasPubUsageServiceXmlschemaV1Web.getCurrentUsageByAccountResponse_element();
   		respElement.serviceAgreementUsage=new AtlasPubUsageServiceXmlschemaV1Web.serviceAgreementUsage_element[]{c};
   		return respElement;
   }
   public AtlasFinServiceXmlschemaFinanceService.getSubscriberCurrentPaymentMethodResponse_element getSubscriberCurrentPaymentMethod()
   {
   		AtlasFinServiceXmlschemaFinanceService.PaymentMethodHistoryItem c=(AtlasFinServiceXmlschemaFinanceService.PaymentMethodHistoryItem)JSON.deserialize(AtlasTestConstants.getMetadata('getSubscriberCurrentPaymentMethodResponse'),AtlasFinServiceXmlschemaFinanceService.PaymentMethodHistoryItem.class);
   		AtlasFinServiceXmlschemaFinanceService.getSubscriberCurrentPaymentMethodResponse_element respElement=new AtlasFinServiceXmlschemaFinanceService.getSubscriberCurrentPaymentMethodResponse_element();
   		respElement.paymentMethods=c;
   		return respElement;
   }
   public AtlasFinServiceXmlschemaFinanceService.getSubscriberInvoiceSummariesResponse_element getBillingHistory()
   {
   		AtlasFinServiceXmlschemaFinanceService.SubscriberInvoiceSummaries c=(AtlasFinServiceXmlschemaFinanceService.SubscriberInvoiceSummaries)JSON.deserialize(AtlasTestConstants.getMetadata('getBillingHistoryResponse'),AtlasFinServiceXmlschemaFinanceService.SubscriberInvoiceSummaries.class);
   		AtlasFinServiceXmlschemaFinanceService.getSubscriberInvoiceSummariesResponse_element respElement=new AtlasFinServiceXmlschemaFinanceService.getSubscriberInvoiceSummariesResponse_element();
   		respElement.subscriberInvoiceSummaries=c;
   		return respElement;
   }
   public AtlasFinServiceXmlschemaFinanceService.getSubscriberLedgerSummaryResponse_element getBillingsnapShot()
   {
   	 	AtlasFinServiceXmlschemaFinanceService.SubscriberLedgerSummary c=(AtlasFinServiceXmlschemaFinanceService.SubscriberLedgerSummary)JSON.deserialize(AtlasTestConstants.getMetadata('getBillingsnapShotResponse'),AtlasFinServiceXmlschemaFinanceService.SubscriberLedgerSummary.class);
   		AtlasFinServiceXmlschemaFinanceService.getSubscriberLedgerSummaryResponse_element respElement=new AtlasFinServiceXmlschemaFinanceService.getSubscriberLedgerSummaryResponse_element();
   		respElement.subscriberLedgerSummary=c;
   		return respElement;
   }
   public AtlasFinServiceXmlschemaFinanceService.getSubscriberInvoiceDetailsResponse_element getSubscriberInvoiceDetails()
   {
   	 	AtlasFinServiceXmlschemaFinanceService.SubscriberInvoiceDetails c=(AtlasFinServiceXmlschemaFinanceService.SubscriberInvoiceDetails)JSON.deserialize(AtlasTestConstants.getMetadata('getSubscriberInvoiceDetailsResponse'),AtlasFinServiceXmlschemaFinanceService.SubscriberInvoiceDetails.class);
   		AtlasFinServiceXmlschemaFinanceService.getSubscriberInvoiceDetailsResponse_element respElement=new AtlasFinServiceXmlschemaFinanceService.getSubscriberInvoiceDetailsResponse_element();
   		respElement.subscriberInvoiceDetail=c;
   		return respElement;
   }
   
   public AtlasFinServiceXmlschemaFinanceService.getSubscriberPaymentHistoryResponse_element getSubscriberPaymentHistory()
   {
   	 	AtlasFinServiceXmlschemaFinanceService.PaymentHistoryItem c=(AtlasFinServiceXmlschemaFinanceService.PaymentHistoryItem)JSON.deserialize(AtlasTestConstants.getMetadata('getSubscriberPaymentHistoryResponseArr'),AtlasFinServiceXmlschemaFinanceService.PaymentHistoryItem.class);
   		AtlasFinServiceXmlschemaFinanceService.getSubscriberPaymentHistoryResponse_element respElement=new AtlasFinServiceXmlschemaFinanceService.getSubscriberPaymentHistoryResponse_element();
   		respElement.payments=new AtlasFinServiceXmlschemaFinanceService.PaymentHistoryItem[]{c};
   		return respElement;
   }
   public AtlasPubContactServXmlschema.updateContactsResponse_element updateContacts()
   {	AtlasPubContactServXmlschema.updateContactsResponse_element response_x=new AtlasPubContactServXmlschema.updateContactsResponse_element();
   		response_x.result =AtlasConstants.UPDATE_CONTACT;
   	 	return response_x;
   }
   public AtlasTransServiceXmlschemav2.addUsageQuotaResponse_element addUsageQuota()
   {
   		AtlasTransServiceXmlschemav2.addUsageQuotaResponse_element response_x = new AtlasTransServiceXmlschemav2.addUsageQuotaResponse_element();
   		response_x.result='Success';
   		return response_x;
   }    
   public AtlasFinServiceXmlschemaFinanceService.updatePaymentMethodResponse_element submitOneTimePayment()
   {
   		AtlasFinServiceXmlschemaFinanceService.updatePaymentMethodResponse_element response_x=new AtlasFinServiceXmlschemaFinanceService.updatePaymentMethodResponse_element();
   		response_x.result='Success';
   		return response_x;
   }   
  
   public AtlasPubCatlogServiceXmlschemaV2.getALaCartePackagesResponse_element getALaCartePackages()
   {
   		AtlasPubCatlogServiceXmlschemaV2.Package_Test p = (AtlasPubCatlogServiceXmlschemaV2.Package_Test)JSON.deserialize(AtlasTestConstants.getMetadata('getAlacarte'),AtlasPubCatlogServiceXmlschemaV2.Package_Test.class);
   		AtlasPubCatlogServiceXmlschemaV2.getALaCartePackagesResponse_element resp = new AtlasPubCatlogServiceXmlschemaV2.getALaCartePackagesResponse_element();
   		resp.package_x= new AtlasPubCatlogServiceXmlschemaV2.Package_Test[]{p};
   		return resp;
   }
   public  AtlasFinServiceXmlschemaFinanceService.getSubscriberOneTimeChargeHistoryResponse_element retieveInvoiceOneTimeCharges()
   {
   		AtlasFinServiceXmlschemaFinanceService.OneTimeChargeHistoryItem x=(AtlasFinServiceXmlschemaFinanceService.OneTimeChargeHistoryItem)JSON.deserialize(AtlasTestConstants.getMetadata('retieveInvoiceOneTimeCharges'),AtlasFinServiceXmlschemaFinanceService.OneTimeChargeHistoryItem.class);
   		AtlasFinServiceXmlschemaFinanceService.getSubscriberOneTimeChargeHistoryResponse_element response_x = new AtlasFinServiceXmlschemaFinanceService.getSubscriberOneTimeChargeHistoryResponse_element();
   		response_x.allOneTimeCharges =x;
   		return response_x;
   }
   public  AtlasPublicWebServiceSearchServiceStub.findSubscribersBySearchCriteriaResponse findSubscriber()
   {
   		AtlasPublicWebServiceSearchServiceStub.findSubscribersBySearchCriteriaResponse x=(AtlasPublicWebServiceSearchServiceStub.findSubscribersBySearchCriteriaResponse)JSON.deserialize(AtlasTestConstants.getMetadata('findSubscriberResponse'),AtlasPublicWebServiceSearchServiceStub.findSubscribersBySearchCriteriaResponse.class);
   		
   		return x;
   } 
   
     public  AtlasPublicWebServiceSearchServiceStub.getLegacyAccountResponse getLegacyAccount()
   {
   		AtlasPublicWebServiceSearchServiceStub.getLegacyAccountResponse x=(AtlasPublicWebServiceSearchServiceStub.getLegacyAccountResponse)JSON.deserialize(AtlasTestConstants.getMetadata('findlegacyresponse'),AtlasPublicWebServiceSearchServiceStub.getLegacyAccountResponse.class);
   		
   		return x;
   } 
    public AtlasFinServiceXmlschemaFinanceService.updatePaymentMethodResponse_element updatePaymenSetting()
   {
   		AtlasFinServiceXmlschemaFinanceService.updatePaymentMethodResponse_element response_x=new AtlasFinServiceXmlschemaFinanceService.updatePaymentMethodResponse_element();
   		response_x.result='Success';
   		return response_x;
   }
*/
    @isTest static void testEchoString1() 
    {              
		// This causes a fake response to be generated
		AtlasTestMainClass.setTestKeyValueStoreForAtlas();
		Test.startTest();
            Test.setMock(WebServiceMock.class, new AtlasTestWebserviceProxy());
            
            AtlasPublicWebServiceSearchService.SearchImplPort accStub=new AtlasPublicWebServiceSearchService.SearchImplPort();
            // Call the method that invokes a callout
           list< AtlasPublicWebServiceSearchServiceStub.Transaction_x> accResponse = accStub.findTransactionsByExternalReference('Test','test','test',system.now(),system.now(),5);            
            // Verify that a fake result is returned
            //System.assertEquals('Mock response', output); 
		Test.stopTest();
	}
        
	@isTest static void testEchoString2() 
	{              
		// This causes a fake response to be generated
		AtlasTestMainClass.setTestKeyValueStoreForAtlas();
		Test.setMock(WebServiceMock.class, new AtlasTestWebserviceProxy());
		Test.startTest();
            
            AtlasPublicWebServiceSearchService.SearchImplPort accStub=new AtlasPublicWebServiceSearchService.SearchImplPort();
            // Call the method that invokes a callout
            AtlasPublicWebServicePWSCommonData.Address Address= new AtlasPublicWebServicePWSCommonData.Address();
			AtlasPublicWebServiceSearchServiceStub.findSubscribersBySearchCriteriaResponse accResponse = accStub.findSubscribersBySearchCriteria('externalReferenceType','externalReference','internalReferenceType','internalReference', 'contactType','emailAddress','phoneNumber','firstName','lastName','subscriberUsername',address,'ticketNumber','macAddress','serialNumber',5);
            //findSubscribersBySearchCriteria(AtlasConstants.EX_REF_FOR_SEARCH, '12345', null, null, null, null, null, null, null, null, null, null, 1);            
            
		Test.stopTest();
	}   
        
	@isTest static void testEchoString3() 
	{              
		// This causes a fake response to be generated
		AtlasTestMainClass.setTestKeyValueStoreForAtlas();
		Test.setMock(WebServiceMock.class, new AtlasTestWebserviceProxy());
		Test.startTest();
            
            AtlasPublicWebServiceSearchService.SearchImplPort accStub=new AtlasPublicWebServiceSearchService.SearchImplPort();
            string[] str=new String[]{'123','456','789'};
            string[] str1=new String[]{'123','456','789'};
            string[] str2=new String[]{'123','456','789'};
            string[] str3=new String[]{'123','456','789'};
            list< AtlasPublicWebServiceSearchServiceStub.Transaction_x> accResponse = accStub.findTransactionsBySearchCriteria(str,str1,str2,str3,'1234','4567',system.now(),system.now(),5); 
		Test.stopTest();
	}   
	@isTest static void testEchoString4() {              
		// This causes a fake response to be generated
		AtlasTestMainClass.setTestKeyValueStoreForAtlas();
		Test.setMock(WebServiceMock.class, new AtlasTestWebserviceProxy());
		Test.startTest();
            AtlasPubContactServWsdlV1.PublicContactServiceEndpoint accStub=new AtlasPubContactServWsdlV1.PublicContactServiceEndpoint();
            AtlasPubContactServXmlschema.CorrectedContact correctedcontact = new AtlasPubContactServXmlschema.CorrectedContact();
            String output = accStub.updateContacts('12345', 'XEROX', '8', correctedcontact); 
		Test.stopTest();
	}   
	@isTest static void testEchoString5() {              
		// This causes a fake response to be generated
		AtlasTestMainClass.setTestKeyValueStoreForAtlas();
		Test.setMock(WebServiceMock.class, new AtlasTestWebserviceProxy());
		Test.startTest();
            AtlasFinServiceWsdlV3FinanceService.FinanceServiceEndpoint accStub=new AtlasFinServiceWsdlV3FinanceService.FinanceServiceEndpoint();
            AtlasFinServiceXmlschemaFinanceService.PaymentMethodDetails paymentMethod = new AtlasFinServiceXmlschemaFinanceService.PaymentMethodDetails();
            String output = accStub.updatePaymentMethod('12345', 'XEROX',paymentMethod); 
		Test.stopTest();
	}   
	@isTest static void testEchoString6() {              
		// This causes a fake response to be generated
		AtlasTestMainClass.setTestKeyValueStoreForAtlas();
		Test.setMock(WebServiceMock.class, new AtlasTestWebserviceProxy());
		Test.startTest();
            AtlasFinServiceWsdlV3FinanceService.FinanceServiceEndpoint accStub=new AtlasFinServiceWsdlV3FinanceService.FinanceServiceEndpoint();
            //AtlasFinServiceXmlschemaFinanceService.OneTimeChargeHistoryItem output= accStub.getSubscriberOneTimeChargeHistory('XEROX', '457896', 10); 
		Test.stopTest();
	}   
	@isTest static void testEchoString7() {              
		// This causes a fake response to be generated
		AtlasTestMainClass.setTestKeyValueStoreForAtlas();
		Test.setMock(WebServiceMock.class, new AtlasTestWebserviceProxy());
		Test.startTest();
            AtlasPublicWebServiceSearchService.SearchImplPort accStub=new AtlasPublicWebServiceSearchService.SearchImplPort();
            // Call the method that invokes a callout
            string accResponse = accStub.getLegacyAccount('externalReferenceType','externalReference','internalReferenceType');
		Test.stopTest();
	}   
	@isTest static void testEchoString8() {              
		// This causes a fake response to be generated
		AtlasTestMainClass.setTestKeyValueStoreForAtlas();
		Test.setMock(WebServiceMock.class, new AtlasTestWebserviceProxy());
		Test.startTest();
                AtlasCustomerSearchWS.CustomerSearchImplV2Port accStub=new AtlasCustomerSearchWS.CustomerSearchImplV2Port();
                // Call the method that invokes a callout
                AtlasCustomerSearchWS.customerInfoBean[] accResponse = accStub.findCustomersByMacAddress('internalReferenceType');
		Test.stopTest();
	}   
	@isTest static void testEchoString9() {              
		// This causes a fake response to be generated
		AtlasTestMainClass.setTestKeyValueStoreForAtlas();
		Test.setMock(WebServiceMock.class, new AtlasTestWebserviceProxy());
		Test.startTest();
                    AtlasTransServiceWsdlTransService.TransactionServiceEndpoint addUsageQuotaStub=new AtlasTransServiceWsdlTransService.TransactionServiceEndpoint();
                    AtlasTransServiceXmlschemav2.UsageQuotaItem[] addUsageQuotaItem = new AtlasTransServiceXmlschemav2.UsageQuotaItem[]{};
            		// Call the method that invokes a callout
                    string accResponse = addUsageQuotaStub.addUsageQuota('externalSystemName','externalTransactionReference','externalServiceAgreementReference','responseURL','salesChannel','enteredBy','soldBy','marketingSourceCode','referralSourceCode','note',addUsageQuotaItem);
		Test.stopTest();
	} 
	
	@isTest static void testEchoString10() {              
		// This causes a fake response to be generated
		AtlasTestMainClass.setTestKeyValueStoreForAtlas();
		Test.setMock(WebServiceMock.class, new AtlasTestWebserviceProxy());
		Test.startTest();
            AtlasFinServiceWsdlV4FinanceService.FinanceServiceEndpoint accStub=new AtlasFinServiceWsdlV4FinanceService.FinanceServiceEndpoint();
            AtlasFinServiceXmlschemaV4FinanceService.DisputeHistoryItem[] getSubscriberDisputeHistory = new AtlasFinServiceXmlschemaV4FinanceService.DisputeHistoryItem[]{};
            List<AtlasFinServiceXmlschemaV4FinanceService.DisputeHistoryItem> callResponse = accStub.getSubscriberDisputeHistory('12345', 'XEROX',12); 
		Test.stopTest();
	}  
	
	@isTest static void testEchoString11() {              
		// This causes a fake response to be generated
		AtlasTestMainClass.setTestKeyValueStoreForAtlas();
		Test.setMock(WebServiceMock.class, new AtlasTestWebserviceProxy());
		Test.startTest();
            AtlasFinServiceWsdlV4FinanceService.FinanceServiceEndpoint accStub=new AtlasFinServiceWsdlV4FinanceService.FinanceServiceEndpoint();
            AtlasFinServiceXmlschemaV4FinanceService.OneTimeChargeHistoryItem output= accStub.getSubscriberOneTimeChargeHistory('XEROX', '457896', 10); 
		Test.stopTest();
	}    
}