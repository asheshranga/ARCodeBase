//Generated by wsdl2apex

public class AtlasPubContactServWsdlV1 {
    public class PublicContactServiceEndpoint {
        public String endpoint_x = 'http://apipub.test.wdc1.wildblue.net:10301/PublicContact/v1/services/PublicContactService';
        public OasisOpenOrgWssSecuritySecext.SecurityHeaderType Security = new OasisOpenOrgWssSecuritySecext.SecurityHeaderType(AtlasConstants.WEBSERVICE_USERNAME, AtlasConstants.WEBSERVICE_PWD);
        private String Security_hns = 'Security=http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd';
        public Map<String,String> inputHttpHeaders_x;
        public Map<String,String> outputHttpHeaders_x;
        public String clientCertName_x;
        public String clientCert_x;
        public String clientCertPasswd_x; 
        public Integer timeout_x;
        private String[] ns_map_type_info = new String[]{'http://www.viasat.com/XMLSchema/PublicWebService/v1/PWSFault', 'AtlasPubContactServXmlschemaPWSFault', 'http://www.viasat.com/XMLSchema/PublicWebService/v2/PWSCommonData', 'AtlasPubContactServXmlschemaCommonData', 'http://www.viasat.com/WSDL/PublicWebService/v1/PublicContactService', 'AtlasPubContactServWsdlV1', 'http://www.viasat.com/XMLSchema/PublicWebService/v1/PublicContactService', 'AtlasPubContactServXmlschema'};
        public String updateContacts(String externalAccountReference,String externalSystemName,String externalTransactionReference,AtlasPubContactServXmlschema.CorrectedContact correctedContact) {
            AtlasPubContactServXmlschema.UpdateContacts request_x = new AtlasPubContactServXmlschema.UpdateContacts();
            AtlasPubContactServXmlschema.updateContactsResponse_element response_x;
            request_x.externalAccountReference = externalAccountReference;
            request_x.externalSystemName = externalSystemName;
            request_x.externalTransactionReference = externalTransactionReference;
            request_x.correctedContact = correctedContact;
            
            Map<String, AtlasPubContactServXmlschema.updateContactsResponse_element> response_map_x = new Map<String, AtlasPubContactServXmlschema.updateContactsResponse_element>();
            response_map_x.put('response_x', response_x);
            WebServiceCallout.invoke(
              this,
              request_x,
              response_map_x,
              new String[]{endpoint_x,
              'updateContacts',
              'http://www.viasat.com/XMLSchema/PublicWebService/v1/PublicContactService',
              'updateContacts',
              'http://www.viasat.com/XMLSchema/PublicWebService/v1/PublicContactService',
              'updateContactsResponse',
              'AtlasPubContactServXmlschema.updateContactsResponse_element'}
            );
            response_x = response_map_x.get('response_x');
            return response_x.result;
        }
       
        public AtlasPubContactServXmlschema.AddressAndTaxJurisdictions[] findAddressAndTaxJurisdictions(AtlasPubContactServXmlschemaCommonData.Address address) {
            AtlasPubContactServXmlschema.FindAddressAndTaxJurisdictions request_x = new AtlasPubContactServXmlschema.FindAddressAndTaxJurisdictions();
            AtlasPubContactServXmlschema.FindAddressAndTaxJurisdictionsResponse response_x;
            request_x.address = address;
            Map<String, AtlasPubContactServXmlschema.FindAddressAndTaxJurisdictionsResponse> response_map_x = new Map<String, AtlasPubContactServXmlschema.FindAddressAndTaxJurisdictionsResponse>();
            response_map_x.put('response_x', response_x);
            WebServiceCallout.invoke(
              this,
              request_x,
              response_map_x,
              new String[]{endpoint_x,
              'findAddressAndTaxJurisdictions',
              'http://www.viasat.com/XMLSchema/PublicWebService/v1/PublicContactService',
              'findAddressAndTaxJurisdictions',
              'http://www.viasat.com/XMLSchema/PublicWebService/v1/PublicContactService',
              'findAddressAndTaxJurisdictionsResponse',
              'AtlasPubContactServXmlschema.FindAddressAndTaxJurisdictionsResponse'}
            );
            response_x = response_map_x.get('response_x');
            return response_x.addressAndTaxJurisdictions;
        }
        
    }
}