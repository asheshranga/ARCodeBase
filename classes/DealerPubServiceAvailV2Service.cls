//Generated by wsdl2apex

public class DealerPubServiceAvailV2Service {
    public class ServiceAvailabilityServiceEndpoint {
        public String endpoint_x = 'https://webservices.test.wildblue.net/PublicServiceAvailability/v2/services/PublicServiceAvailabilityService';
        public Map<String,String> inputHttpHeaders_x;
        public Map<String,String> outputHttpHeaders_x;
        public String clientCertName_x;
        public String clientCert_x;
        public String clientCertPasswd_x;
        public Integer timeout_x;
        public DealerPubServiceAvailV1PWSHeader.wildBlueHeader wildBlueHeader;
        private String wildBlueHeader_hns = 'wildBlueHeader=http://www.wildblue.viasat.com/XMLSchema/PublicWebService/v1.0/PWSHeader';
        private String[] ns_map_type_info = new String[]{'http://www.wildblue.viasat.com/XMLSchema/PublicWebService/v1.0/PWSHeader', 'DealerPubServiceAvailV1PWSHeader', 'http://www.wildblue.viasat.com/XMLSchema/v2/webservice/PublicServiceAvailabilityWebService', 'DealerPubServiceAvailV2XMLSchema', 'http://www.wildblue.viasat.com/XMLSchema/PublicWebService/v1.0/PWSLocation', 'DealerPubServiceAvailV1PWSLocation', 'http://www.wildblue.viasat.com/XMLSchema/PublicWebService/v1.0/PWSException', 'DealerPubServiceAvailV1PWSExcept', 'http://www.wildblue.viasat.com/WSDL/v2/PublicServiceAvailabilityWebService', 'DealerPubServiceAvailV2Service'};
        public DealerPubServiceAvailV1PWSHeader.invokedBy getServiceAvailability(DealerPubServiceAvailV1PWSHeader.invokedBy invokedBy) {
            DealerPubServiceAvailV1PWSHeader.wildBlueHeader request_x = new DealerPubServiceAvailV1PWSHeader.wildBlueHeader();
            request_x.invokedBy = invokedBy;
            DealerPubServiceAvailV1PWSHeader.wildBlueHeader response_x;
            Map<String, DealerPubServiceAvailV1PWSHeader.wildBlueHeader> response_map_x = new Map<String, DealerPubServiceAvailV1PWSHeader.wildBlueHeader>();
            response_map_x.put('response_x', response_x);
            WebServiceCallout.invoke(
              this,
              request_x,
              response_map_x,
              new String[]{endpoint_x,
              '',
              'http://www.wildblue.viasat.com/XMLSchema/PublicWebService/v1.0/PWSHeader',
              'wildBlueHeader',
              'http://www.wildblue.viasat.com/XMLSchema/PublicWebService/v1.0/PWSHeader',
              'wildBlueHeader',
              'DealerPubServiceAvailV1PWSHeader.wildBlueHeader'}
            );
            response_x = response_map_x.get('response_x');
            return response_x.invokedBy;
        }
    }
}