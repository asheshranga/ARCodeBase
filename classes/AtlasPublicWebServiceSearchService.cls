//Generated by wsdl2apex

public class AtlasPublicWebServiceSearchService {
    public class SearchImplPort {
        public OasisOpenOrgWssSecuritySecext.SecurityHeaderType Security = new OasisOpenOrgWssSecuritySecext.SecurityHeaderType( AtlasConstants.WEBSERVICE_USERNAME, AtlasConstants.WEBSERVICE_PWD);
        private String Security_hns = 'Security=http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd';
        public String endpoint_x = 'https://webservices.test.wildblue.net:443/PublicSearch/v1/services/PublicSearchService';
        public Map<String,String> inputHttpHeaders_x;
        public Map<String,String> outputHttpHeaders_x;
        public String clientCertName_x;
        public String clientCert_x;
        public String clientCertPasswd_x;
        public Integer timeout_x;
        private String[] ns_map_type_info = new String[]{'http://www.viasat.com/XMLSchema/PublicWebService/v1/PWSFault', 'AtlasPublicWebServicePWSFault', 'http://www.viasat.com/XMLSchema/PublicWebService/v1/SearchService', 'AtlasPublicWebServiceSearchServiceStub', 'http://www.viasat.com/XMLSchema/PublicWebService/v2/PWSCommonData', 'AtlasPublicWebServicePWSCommonData', 'http://www.viasat.com/WSDL/PublicWebService/v1/SearchService', 'AtlasPublicWebServiceSearchService'};
        public AtlasPublicWebServiceSearchServiceStub.Transaction_x[] findTransactionsByExternalReference(String externalSystemName,String externalReference,String externalReferenceType,DateTime startDateTime,DateTime endDateTime,Integer maxResults) {
            AtlasPublicWebServiceSearchServiceStub.findTransactionsByExternalReference request_x = new AtlasPublicWebServiceSearchServiceStub.findTransactionsByExternalReference();
            AtlasPublicWebServiceSearchServiceStub.findTransactionsByExternalReferenceResponse response_x;
            request_x.externalSystemName = externalSystemName;
            request_x.externalReference = externalReference;
            request_x.externalReferenceType = externalReferenceType;
            request_x.startDateTime = startDateTime;
            request_x.endDateTime = endDateTime;
            request_x.maxResults = maxResults;
            Map<String, AtlasPublicWebServiceSearchServiceStub.findTransactionsByExternalReferenceResponse> response_map_x = new Map<String, AtlasPublicWebServiceSearchServiceStub.findTransactionsByExternalReferenceResponse>();
            response_map_x.put('response_x', response_x);
            WebServiceCallout.invoke(
              this,
              request_x,
              response_map_x,
              new String[]{endpoint_x,
              'findTransactionsByExternalReference',
              'http://www.viasat.com/XMLSchema/PublicWebService/v1/SearchService',
              'findTransactionsByExternalReference',
              'http://www.viasat.com/XMLSchema/PublicWebService/v1/SearchService',
              'findTransactionsByExternalReferenceResponse',
              'AtlasPublicWebServiceSearchServiceStub.findTransactionsByExternalReferenceResponse'}
            );
            response_x = response_map_x.get('response_x');
            return response_x.transaction_x;
        }
        public AtlasPublicWebServiceSearchServiceStub.Transaction_x[] findTransactionsBySearchCriteria(String[] transactionType,String[] externalSystemName,String[] salesChannel,String[] status,String externalReference,String externalReferenceType,DateTime startDateTime,DateTime endDateTime,Integer maxResults) {
            AtlasPublicWebServiceSearchServiceStub.findTransactionsBySearchCriteria request_x = new AtlasPublicWebServiceSearchServiceStub.findTransactionsBySearchCriteria();
            AtlasPublicWebServiceSearchServiceStub.findTransactionsBySearchCriteriaResponse response_x;
            request_x.transactionType = transactionType;
            request_x.externalSystemName = externalSystemName;
            request_x.salesChannel = salesChannel;
            request_x.status = status;
            request_x.externalReference = externalReference;
            request_x.externalReferenceType = externalReferenceType;
            request_x.startDateTime = startDateTime;
            request_x.endDateTime = endDateTime;
            request_x.maxResults = maxResults;
            Map<String, AtlasPublicWebServiceSearchServiceStub.findTransactionsBySearchCriteriaResponse> response_map_x = new Map<String, AtlasPublicWebServiceSearchServiceStub.findTransactionsBySearchCriteriaResponse>();
            response_map_x.put('response_x', response_x);
            WebServiceCallout.invoke(
              this,
              request_x,
              response_map_x,
              new String[]{endpoint_x,
              'findTransactionsBySearchCriteria',
              'http://www.viasat.com/XMLSchema/PublicWebService/v1/SearchService',
              'findTransactionsBySearchCriteria',
              'http://www.viasat.com/XMLSchema/PublicWebService/v1/SearchService',
              'findTransactionsBySearchCriteriaResponse',
              'AtlasPublicWebServiceSearchServiceStub.findTransactionsBySearchCriteriaResponse'}
            );
            response_x = response_map_x.get('response_x');
            return response_x.transaction_x;
        }
        public AtlasPublicWebServiceSearchServiceStub.findSubscribersBySearchCriteriaResponse findSubscribersBySearchCriteria(String externalReferenceType,String externalReference,String internalReferenceType,String internalReference, String contactType,String emailAddress,String phoneNumber,String firstName,String lastName,String subscriberUsername,AtlasPublicWebServicePWSCommonData.Address address,String ticketNumber,String macAddress,String serialNumber,Integer maxResults) {
            AtlasPublicWebServiceSearchServiceStub.findSubscribersBySearchCriteria request_x = new AtlasPublicWebServiceSearchServiceStub.findSubscribersBySearchCriteria();
            AtlasPublicWebServiceSearchServiceStub.findSubscribersBySearchCriteriaResponse response_x;
            request_x.externalReferenceType = externalReferenceType;
            request_x.externalReference = externalReference;
            request_x.internalReferenceType = internalReferenceType;
            request_x.internalReference = internalReference;           
            request_x.contactType = contactType;
            request_x.emailAddress = emailAddress;
            request_x.phoneNumber = phoneNumber;
            request_x.firstName = firstName;
            request_x.lastName = lastName;
            request_x.subscriberUsername = subscriberUsername;
            request_x.address = address;
            request_x.ticketNumber = ticketNumber;
            request_x.macAddress = macAddress;
            request_x.serialNumber = serialNumber;
            request_x.maxResults = maxResults;
            Map<String, AtlasPublicWebServiceSearchServiceStub.findSubscribersBySearchCriteriaResponse> response_map_x = new Map<String, AtlasPublicWebServiceSearchServiceStub.findSubscribersBySearchCriteriaResponse>();
            response_map_x.put('response_x', response_x);
            WebServiceCallout.invoke(
              this,
              request_x,
              response_map_x,
              new String[]{endpoint_x,
              'findSubscribersBySearchCriteria',
              'http://www.viasat.com/XMLSchema/PublicWebService/v1/SearchService',
              'findSubscribersBySearchCriteria',
              'http://www.viasat.com/XMLSchema/PublicWebService/v1/SearchService',
              'findSubscribersBySearchCriteriaResponse',
              'AtlasPublicWebServiceSearchServiceStub.findSubscribersBySearchCriteriaResponse'}
            );
            response_x = response_map_x.get('response_x');
            return response_x;
        }
        public String getLegacyAccount(String externalSystemName,String externalAccountReference,String internalAccountReference) {
            AtlasPublicWebServiceSearchServiceStub.getLegacyAccount request_x = new AtlasPublicWebServiceSearchServiceStub.getLegacyAccount();
            AtlasPublicWebServiceSearchServiceStub.getLegacyAccountResponse response_x;
            request_x.externalSystemName = externalSystemName;
            request_x.externalAccountReference = externalAccountReference;
            request_x.internalAccountReference = internalAccountReference;
            Map<String, AtlasPublicWebServiceSearchServiceStub.getLegacyAccountResponse> response_map_x = new Map<String, AtlasPublicWebServiceSearchServiceStub.getLegacyAccountResponse>();
            response_map_x.put('response_x', response_x);
            WebServiceCallout.invoke(
              this,
              request_x,
              response_map_x,
              new String[]{endpoint_x,
              'getLegacyAccount',
              'http://www.viasat.com/XMLSchema/PublicWebService/v1/SearchService',
              'getLegacyAccount',
              'http://www.viasat.com/XMLSchema/PublicWebService/v1/SearchService',
              'getLegacyAccountResponse',
              'AtlasPublicWebServiceSearchServiceStub.getLegacyAccountResponse'}
            );
            response_x = response_map_x.get('response_x');
            return response_x.account;
        }
    }
}