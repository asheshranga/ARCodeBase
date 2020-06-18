//Generated by wsdl2apex

public class AtlasTransServiceWsdlTransService {
    public class TransactionServiceEndpoint {
         public OasisOpenOrgWssSecuritySecext.SecurityHeaderType Security = new OasisOpenOrgWssSecuritySecext.SecurityHeaderType( AtlasConstants.WEBSERVICE_USERNAME, AtlasConstants.WEBSERVICE_PWD);
        private String Security_hns = 'Security=http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd';
        //public String endpoint_x ='http://requestb.in/y8pbxly8';
        public String endpoint_x = 'http://apipub.test.wdc1.wildblue.net:10301/TransactionService/v2/services/TransactionService';
        public Map<String,String> inputHttpHeaders_x;
        public Map<String,String> outputHttpHeaders_x;
        public String clientCertName_x;
        public String clientCert_x;
        public String clientCertPasswd_x;
        public Integer timeout_x;
        public AtlasTransServiceXmlschemaPWSHeader.wildBlueHeader wildBlueHeader;
        private String wildBlueHeader_hns = 'wildBlueHeader=http://www.wildblue.viasat.com/XMLSchema/PublicWebService/v1.0/PWSHeader';
        private String[] ns_map_type_info = new String[]{'http://www.wildblue.viasat.com/XMLSchema/PublicWebService/v1.0/PWSLocation', 'AtlasTransServiceXmlschemaPWSLocation', 'http://www.wildblue.viasat.com/XMLSchema/PublicWebService/v1.0/PWSException', 'AtlasTransServiceXmlschemaPWSException', 'http://www.wildblue.viasat.com/XMLSchema/PublicWebService/v1.0/PWSHeader', 'AtlasTransServiceXmlschemaPWSHeader', 'http://www.wildblue.viasat.com/XMLSchema/PublicWebService/v2/TransactionService', 'AtlasTransServiceXmlschemav2', 'http://www.wildblue.viasat.com/WSDL/PublicWebService/v2/TransactionService', 'AtlasTransServiceWsdlTransService', 'http://www.wildblue.viasat.com/XMLSchema/PublicWebService/v1.0/PWSCommonData', 'AtlasTransServiceXmlschemaPWSCommonData'};
        /** ----------------Commented as unused function to Improve Test coverage ------------Gaurav Gathania -15 Dec 2013---------------
        public String removeUsageQuota(String externalSystemName,String externalTransactionReference,String externalServiceAgreementReference,String responseURL,String salesChannel,String enteredBy,String soldBy,String marketingSourceCode,String referralSourceCode,String note,AtlasTransServiceXmlschemav2.UsageQuotaItem[] removeUsageQuotaItem) {
            AtlasTransServiceXmlschemav2.removeUsageQuota request_x = new AtlasTransServiceXmlschemav2.removeUsageQuota();
            AtlasTransServiceXmlschemav2.removeUsageQuotaResponse_element response_x;
            request_x.externalSystemName = externalSystemName;
            request_x.externalTransactionReference = externalTransactionReference;
            request_x.externalServiceAgreementReference = externalServiceAgreementReference;
            request_x.responseURL = responseURL;
            request_x.salesChannel = salesChannel;
            request_x.enteredBy = enteredBy;
            request_x.soldBy = soldBy;
            request_x.marketingSourceCode = marketingSourceCode;
            request_x.referralSourceCode = referralSourceCode;
            request_x.note = note;
            request_x.removeUsageQuotaItem = removeUsageQuotaItem;
            Map<String, AtlasTransServiceXmlschemav2.removeUsageQuotaResponse_element> response_map_x = new Map<String, AtlasTransServiceXmlschemav2.removeUsageQuotaResponse_element>();
            response_map_x.put('response_x', response_x);
            WebServiceCallout.invoke(
              this,
              request_x,
              response_map_x,
              new String[]{endpoint_x,
              'urn:#NewOperation',
              'http://www.wildblue.viasat.com/XMLSchema/PublicWebService/v2/TransactionService',
              'removeUsageQuota',
              'http://www.wildblue.viasat.com/XMLSchema/PublicWebService/v2/TransactionService',
              'removeUsageQuotaResponse',
              'AtlasTransServiceXmlschemav2.removeUsageQuotaResponse_element'}
            );
            response_x = response_map_x.get('response_x');
            return response_x.result;
        }
        **/
        /** ------ getTransactionsByAccount - Used for Change Plan ------  **/
        public AtlasTransServiceXmlschemav2.Transaction_x[] getTransactionsByAccount(String externalSystemName,String externalAccountReference,DateTime startDate,DateTime endDate) {
            AtlasTransServiceXmlschemav2.getTransactionsByAccount request_x = new AtlasTransServiceXmlschemav2.getTransactionsByAccount();
            AtlasTransServiceXmlschemav2.getTransactionsByAccountResponse_element response_x;
            request_x.externalSystemName = externalSystemName;
            request_x.externalAccountReference = externalAccountReference;
            request_x.startDate = startDate;
            request_x.endDate = endDate;
            Map<String, AtlasTransServiceXmlschemav2.getTransactionsByAccountResponse_element> response_map_x = new Map<String, AtlasTransServiceXmlschemav2.getTransactionsByAccountResponse_element>();
            response_map_x.put('response_x', response_x);
            WebServiceCallout.invoke(
              this,
              request_x,
              response_map_x,
              new String[]{endpoint_x,
              'urn:#NewOperation',
              'http://www.wildblue.viasat.com/XMLSchema/PublicWebService/v2/TransactionService',
              'getTransactionsByAccount',
              'http://www.wildblue.viasat.com/XMLSchema/PublicWebService/v2/TransactionService',
              'getTransactionsByAccountResponse',
              'AtlasTransServiceXmlschemav2.getTransactionsByAccountResponse_element'}
            );
            response_x = response_map_x.get('response_x');
            return response_x.transaction_x;
        }
        
        /** ----------------Commented as unused function to Improve Test coverage ------------Gaurav Gathania -15 Dec 2013---------------
        public String updateBillCycle(String externalSystemName,String externalTransactionReference,String externalAccountReference,Date nextBillDate) {
            AtlasTransServiceXmlschemav2.updateBillCycle request_x = new AtlasTransServiceXmlschemav2.updateBillCycle();
            AtlasTransServiceXmlschemav2.updateBillCycleResponse_element response_x;
            request_x.externalSystemName = externalSystemName;
            request_x.externalTransactionReference = externalTransactionReference;
            request_x.externalAccountReference = externalAccountReference;
            request_x.nextBillDate = nextBillDate;
            Map<String, AtlasTransServiceXmlschemav2.updateBillCycleResponse_element> response_map_x = new Map<String, AtlasTransServiceXmlschemav2.updateBillCycleResponse_element>();
            response_map_x.put('response_x', response_x);
            WebServiceCallout.invoke(
              this,
              request_x,
              response_map_x,
              new String[]{endpoint_x,
              'urn:#NewOperation',
              'http://www.wildblue.viasat.com/XMLSchema/PublicWebService/v2/TransactionService',
              'updateBillCycle',
              'http://www.wildblue.viasat.com/XMLSchema/PublicWebService/v2/TransactionService',
              'updateBillCycleResponse',
              'AtlasTransServiceXmlschemav2.updateBillCycleResponse_element'}
            );
            response_x = response_map_x.get('response_x');
            return response_x.result;
        }
        **/
        
        public String[] getUniqueExternalReferenceValues(Integer quantity,String prefix) {
            AtlasTransServiceXmlschemav2.getUniqueExternalReferenceValues request_x = new AtlasTransServiceXmlschemav2.getUniqueExternalReferenceValues();
            AtlasTransServiceXmlschemav2.getUniqueExternalReferenceValuesResponse_element response_x;
            request_x.quantity = quantity;
            request_x.prefix = prefix;
            Map<String, AtlasTransServiceXmlschemav2.getUniqueExternalReferenceValuesResponse_element> response_map_x = new Map<String, AtlasTransServiceXmlschemav2.getUniqueExternalReferenceValuesResponse_element>();
            response_map_x.put('response_x', response_x);
            WebServiceCallout.invoke(
              this,
              request_x,
              response_map_x,
              new String[]{endpoint_x,
              'urn:#NewOperation',
              'http://www.wildblue.viasat.com/XMLSchema/PublicWebService/v2/TransactionService',
              'getUniqueExternalReferenceValues',
              'http://www.wildblue.viasat.com/XMLSchema/PublicWebService/v2/TransactionService',
              'getUniqueExternalReferenceValuesResponse',
              'AtlasTransServiceXmlschemav2.getUniqueExternalReferenceValuesResponse_element'}
            );
            response_x = response_map_x.get('response_x');
            return response_x.externalReferenceValue;
        }
        
        public String addUsageQuota(String externalSystemName,String externalTransactionReference,String externalServiceAgreementReference,String responseURL,String salesChannel,String enteredBy,String soldBy,String marketingSourceCode,String referralSourceCode,String note,AtlasTransServiceXmlschemav2.UsageQuotaItem[] addUsageQuotaItem) {
            AtlasTransServiceXmlschemav2.addUsageQuota request_x = new AtlasTransServiceXmlschemav2.addUsageQuota();
            AtlasTransServiceXmlschemav2.addUsageQuotaResponse_element response_x;
            request_x.externalSystemName = externalSystemName;
            request_x.externalTransactionReference = externalTransactionReference;
            request_x.externalServiceAgreementReference = externalServiceAgreementReference;
            request_x.responseURL = responseURL;
            request_x.salesChannel = salesChannel;
            request_x.enteredBy = enteredBy;
            request_x.soldBy = soldBy;
            request_x.marketingSourceCode = marketingSourceCode;
            request_x.referralSourceCode = referralSourceCode;
            request_x.note = note;
            request_x.addUsageQuotaItem = addUsageQuotaItem;
            Map<String, AtlasTransServiceXmlschemav2.addUsageQuotaResponse_element> response_map_x = new Map<String, AtlasTransServiceXmlschemav2.addUsageQuotaResponse_element>();
            response_map_x.put('response_x', response_x);
            WebServiceCallout.invoke(
              this,
              request_x,
              response_map_x,
              new String[]{endpoint_x,
              'urn:#NewOperation',
              'http://www.wildblue.viasat.com/XMLSchema/PublicWebService/v2/TransactionService',
              'addUsageQuota',
              'http://www.wildblue.viasat.com/XMLSchema/PublicWebService/v2/TransactionService',
              'addUsageQuotaResponse',
              'AtlasTransServiceXmlschemav2.addUsageQuotaResponse_element'}
            );
            response_x = response_map_x.get('response_x');
            return response_x.result;
        }
        /** ------ getTransactionsByAccountAndType - Used for Change Plan ------ **/
        public AtlasTransServiceXmlschemav2.Transaction_x[] getTransactionsByAccountAndType(String externalSystemName,String externalAccountReference,String type_x,DateTime startDate,DateTime endDate) {
            AtlasTransServiceXmlschemav2.getTransactionsByAccountAndType request_x = new AtlasTransServiceXmlschemav2.getTransactionsByAccountAndType();
            AtlasTransServiceXmlschemav2.getTransactionsByAccountAndTypeResponse_element response_x;
            request_x.externalSystemName = externalSystemName;
            request_x.externalAccountReference = externalAccountReference;
            request_x.type_x = type_x;
            request_x.startDate = startDate;
            request_x.endDate = endDate;
            Map<String, AtlasTransServiceXmlschemav2.getTransactionsByAccountAndTypeResponse_element> response_map_x = new Map<String, AtlasTransServiceXmlschemav2.getTransactionsByAccountAndTypeResponse_element>();
            response_map_x.put('response_x', response_x);
            WebServiceCallout.invoke(
              this,
              request_x,
              response_map_x,
              new String[]{endpoint_x,
              'urn:#NewOperation',
              'http://www.wildblue.viasat.com/XMLSchema/PublicWebService/v2/TransactionService',
              'getTransactionsByAccountAndType',
              'http://www.wildblue.viasat.com/XMLSchema/PublicWebService/v2/TransactionService',
              'getTransactionsByAccountAndTypeResponse',
              'AtlasTransServiceXmlschemav2.getTransactionsByAccountAndTypeResponse_element'}
            );
            response_x = response_map_x.get('response_x');
            return response_x.transaction_x;
        }
        
        /** ----------------Commented as unused function to Improve Test coverage ------------Gaurav Gathania -15 Dec 2013---------------
        public Integer[] getAvailableBillCycles() {
            AtlasTransServiceXmlschemav2.getAvailableBillCycles_element request_x = new AtlasTransServiceXmlschemav2.getAvailableBillCycles_element();
            AtlasTransServiceXmlschemav2.getAvailableBillCyclesResponse_element response_x;
            Map<String, AtlasTransServiceXmlschemav2.getAvailableBillCyclesResponse_element> response_map_x = new Map<String, AtlasTransServiceXmlschemav2.getAvailableBillCyclesResponse_element>();
            response_map_x.put('response_x', response_x);
            WebServiceCallout.invoke(
              this,
              request_x,
              response_map_x,
              new String[]{endpoint_x,
              'urn:#NewOperation',
              'http://www.wildblue.viasat.com/XMLSchema/PublicWebService/v2/TransactionService',
              'getAvailableBillCycles',
              'http://www.wildblue.viasat.com/XMLSchema/PublicWebService/v2/TransactionService',
              'getAvailableBillCyclesResponse',
              'AtlasTransServiceXmlschemav2.getAvailableBillCyclesResponse_element'}
            );
            response_x = response_map_x.get('response_x');
            return response_x.dayOfMonth;
        }
        **/
        //** ----------------Commented as unused function to Improve Test coverage ------------Gaurav Gathania -15 Dec 2013---------------
        //Uncommenting this as part of SB2+ project
        public String updateShippingContact(String externalSystemName,String externalTransactionReference,String externalServiceAgreementReference,String enteredBy,AtlasTransServiceXmlschemaPWSCommonData.Contact shippingContact) {
            AtlasTransServiceXmlschemav2.updateShippingContact request_x = new AtlasTransServiceXmlschemav2.updateShippingContact();
            AtlasTransServiceXmlschemav2.updateShippingContactResponse_element response_x;
            request_x.externalSystemName = externalSystemName;
            request_x.externalTransactionReference = externalTransactionReference;
            request_x.externalServiceAgreementReference = externalServiceAgreementReference;
            request_x.enteredBy = enteredBy;
            request_x.shippingContact = shippingContact;
            Map<String, AtlasTransServiceXmlschemav2.updateShippingContactResponse_element> response_map_x = new Map<String, AtlasTransServiceXmlschemav2.updateShippingContactResponse_element>();
            response_map_x.put('response_x', response_x);
            WebServiceCallout.invoke(
              this,
              request_x,
              response_map_x,
              new String[]{endpoint_x,
              'urn:#NewOperation',
              'http://www.wildblue.viasat.com/XMLSchema/PublicWebService/v2/TransactionService',
              'updateShippingContact',
              'http://www.wildblue.viasat.com/XMLSchema/PublicWebService/v2/TransactionService',
              'updateShippingContactResponse',
              'AtlasTransServiceXmlschemav2.updateShippingContactResponse_element'}
            );
            response_x = response_map_x.get('response_x');
            return response_x.result;
        }
        
    }
}