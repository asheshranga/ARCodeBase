//Generated by wsdl2apex

public class AtlasTransServiceXmlschemav2 {
    public class updateShippingContact {
        public String externalSystemName;
        public String externalTransactionReference;
        public String externalServiceAgreementReference;
        public String enteredBy;
        public AtlasTransServiceXmlschemaPWSCommonData.Contact shippingContact;
        private String[] externalSystemName_type_info = new String[]{'externalSystemName','http://www.wildblue.viasat.com/XMLSchema/PublicWebService/v2/TransactionService',null,'1','1','false'};
        private String[] externalTransactionReference_type_info = new String[]{'externalTransactionReference','http://www.wildblue.viasat.com/XMLSchema/PublicWebService/v2/TransactionService',null,'1','1','false'};
        private String[] externalServiceAgreementReference_type_info = new String[]{'externalServiceAgreementReference','http://www.wildblue.viasat.com/XMLSchema/PublicWebService/v2/TransactionService',null,'1','1','false'};
        private String[] enteredBy_type_info = new String[]{'enteredBy','http://www.wildblue.viasat.com/XMLSchema/PublicWebService/v2/TransactionService',null,'1','1','false'};
        private String[] shippingContact_type_info = new String[]{'shippingContact','http://www.wildblue.viasat.com/XMLSchema/PublicWebService/v2/TransactionService',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://www.wildblue.viasat.com/XMLSchema/PublicWebService/v2/TransactionService','true','false'};
        private String[] field_order_type_info = new String[]{'externalSystemName','externalTransactionReference','externalServiceAgreementReference','enteredBy','shippingContact'};
    }
    public class ServiceItem {
        public String externalSystemName;
        public String externalServiceAgreementReference;
        public String externalServiceItemReference;
        public String type_x;
        public String pricePlanName;
        public String deviceIdentifier;
        public String ratingEventType;
        public AtlasTransServiceXmlschemaPWSCommonData.Contract contract;
        private String[] externalSystemName_type_info = new String[]{'externalSystemName','http://www.wildblue.viasat.com/XMLSchema/PublicWebService/v2/TransactionService',null,'1','1','false'};
        private String[] externalServiceAgreementReference_type_info = new String[]{'externalServiceAgreementReference','http://www.wildblue.viasat.com/XMLSchema/PublicWebService/v2/TransactionService',null,'1','1','false'};
        private String[] externalServiceItemReference_type_info = new String[]{'externalServiceItemReference','http://www.wildblue.viasat.com/XMLSchema/PublicWebService/v2/TransactionService',null,'1','1','false'};
        private String[] type_x_type_info = new String[]{'type','http://www.wildblue.viasat.com/XMLSchema/PublicWebService/v2/TransactionService',null,'1','1','false'};
        private String[] pricePlanName_type_info = new String[]{'pricePlanName','http://www.wildblue.viasat.com/XMLSchema/PublicWebService/v2/TransactionService',null,'1','1','false'};
        private String[] deviceIdentifier_type_info = new String[]{'deviceIdentifier','http://www.wildblue.viasat.com/XMLSchema/PublicWebService/v2/TransactionService',null,'1','1','false'};
        private String[] ratingEventType_type_info = new String[]{'ratingEventType','http://www.wildblue.viasat.com/XMLSchema/PublicWebService/v2/TransactionService',null,'1','1','false'};
        private String[] contract_type_info = new String[]{'contract','http://www.wildblue.viasat.com/XMLSchema/PublicWebService/v2/TransactionService',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://www.wildblue.viasat.com/XMLSchema/PublicWebService/v2/TransactionService','true','false'};
        private String[] field_order_type_info = new String[]{'externalSystemName','externalServiceAgreementReference','externalServiceItemReference','type_x','pricePlanName','deviceIdentifier','ratingEventType','contract'};
    }
    public class getAvailableBillCycles_element {
        private String[] apex_schema_type_info = new String[]{'http://www.wildblue.viasat.com/XMLSchema/PublicWebService/v2/TransactionService','true','false'};
        private String[] field_order_type_info = new String[]{};
    }
    public class removeUsageQuotaResponse_element {
        public String result;
        private String[] result_type_info = new String[]{'result','http://www.wildblue.viasat.com/XMLSchema/PublicWebService/v2/TransactionService',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://www.wildblue.viasat.com/XMLSchema/PublicWebService/v2/TransactionService','true','false'};
        private String[] field_order_type_info = new String[]{'result'};
    }
    public class UsageQuotaItem {
        public String externalOneTimeChargeReference;
        public String masterCatalogNumber;
        private String[] externalOneTimeChargeReference_type_info = new String[]{'externalOneTimeChargeReference','http://www.wildblue.viasat.com/XMLSchema/PublicWebService/v2/TransactionService',null,'1','1','false'};
        private String[] masterCatalogNumber_type_info = new String[]{'masterCatalogNumber','http://www.wildblue.viasat.com/XMLSchema/PublicWebService/v2/TransactionService',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://www.wildblue.viasat.com/XMLSchema/PublicWebService/v2/TransactionService','true','false'};
        private String[] field_order_type_info = new String[]{'externalOneTimeChargeReference','masterCatalogNumber'};
    }
    public class getTransactionsByAccount {
        public String externalSystemName;
        public String externalAccountReference;
        public DateTime startDate;
        public DateTime endDate;
        private String[] externalSystemName_type_info = new String[]{'externalSystemName','http://www.wildblue.viasat.com/XMLSchema/PublicWebService/v2/TransactionService',null,'1','1','false'};
        private String[] externalAccountReference_type_info = new String[]{'externalAccountReference','http://www.wildblue.viasat.com/XMLSchema/PublicWebService/v2/TransactionService',null,'1','1','false'};
        private String[] startDate_type_info = new String[]{'startDate','http://www.wildblue.viasat.com/XMLSchema/PublicWebService/v2/TransactionService',null,'0','1','false'};
        private String[] endDate_type_info = new String[]{'endDate','http://www.wildblue.viasat.com/XMLSchema/PublicWebService/v2/TransactionService',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://www.wildblue.viasat.com/XMLSchema/PublicWebService/v2/TransactionService','true','false'};
        private String[] field_order_type_info = new String[]{'externalSystemName','externalAccountReference','startDate','endDate'};
    }
    public class getTransactionsByAccountAndTypeResponse_element {
        public AtlasTransServiceXmlschemav2.Transaction_x[] transaction_x;
        private String[] transaction_x_type_info = new String[]{'transaction','http://www.wildblue.viasat.com/XMLSchema/PublicWebService/v2/TransactionService',null,'0','-1','false'};
        private String[] apex_schema_type_info = new String[]{'http://www.wildblue.viasat.com/XMLSchema/PublicWebService/v2/TransactionService','true','false'};
        private String[] field_order_type_info = new String[]{'transaction_x'};
    }
    public class Transaction_x {
        public String externalServiceAgreementReference;
        public String externalTransactionReference;
        public String salesChannelName;
        public String dealerName;
        public String type_x;
        public String status;
        public String reasonCode;
        public DateTime submittedDate;
        public String soldBy;
        public String submittedBy;
        public String note;
        public String serviceCallTypeName;
        public AtlasTransServiceXmlschemav2.ServiceItem[] oldServiceItem;
        public AtlasTransServiceXmlschemav2.ServiceItem[] serviceItem;
        public AtlasTransServiceXmlschemaPWSCommonData.OneTimeCharge[] oneTimeCharge;
        private String[] externalServiceAgreementReference_type_info = new String[]{'externalServiceAgreementReference','http://www.wildblue.viasat.com/XMLSchema/PublicWebService/v2/TransactionService',null,'0','1','false'};
        private String[] externalTransactionReference_type_info = new String[]{'externalTransactionReference','http://www.wildblue.viasat.com/XMLSchema/PublicWebService/v2/TransactionService',null,'1','1','false'};
        private String[] salesChannelName_type_info = new String[]{'salesChannelName','http://www.wildblue.viasat.com/XMLSchema/PublicWebService/v2/TransactionService',null,'1','1','false'};
        private String[] dealerName_type_info = new String[]{'dealerName','http://www.wildblue.viasat.com/XMLSchema/PublicWebService/v2/TransactionService',null,'1','1','false'};
        private String[] type_x_type_info = new String[]{'type','http://www.wildblue.viasat.com/XMLSchema/PublicWebService/v2/TransactionService',null,'1','1','false'};
        private String[] status_type_info = new String[]{'status','http://www.wildblue.viasat.com/XMLSchema/PublicWebService/v2/TransactionService',null,'1','1','false'};
        private String[] reasonCode_type_info = new String[]{'reasonCode','http://www.wildblue.viasat.com/XMLSchema/PublicWebService/v2/TransactionService',null,'1','1','false'};
        private String[] submittedDate_type_info = new String[]{'submittedDate','http://www.wildblue.viasat.com/XMLSchema/PublicWebService/v2/TransactionService',null,'1','1','false'};
        private String[] soldBy_type_info = new String[]{'soldBy','http://www.wildblue.viasat.com/XMLSchema/PublicWebService/v2/TransactionService',null,'0','1','false'};
        private String[] submittedBy_type_info = new String[]{'submittedBy','http://www.wildblue.viasat.com/XMLSchema/PublicWebService/v2/TransactionService',null,'1','1','false'};
        private String[] note_type_info = new String[]{'note','http://www.wildblue.viasat.com/XMLSchema/PublicWebService/v2/TransactionService',null,'0','1','false'};
        private String[] serviceCallTypeName_type_info = new String[]{'serviceCallTypeName','http://www.wildblue.viasat.com/XMLSchema/PublicWebService/v2/TransactionService',null,'0','1','false'};
        private String[] oldServiceItem_type_info = new String[]{'oldServiceItem','http://www.wildblue.viasat.com/XMLSchema/PublicWebService/v2/TransactionService',null,'0','-1','false'};
        private String[] serviceItem_type_info = new String[]{'serviceItem','http://www.wildblue.viasat.com/XMLSchema/PublicWebService/v2/TransactionService',null,'0','-1','false'};
        private String[] oneTimeCharge_type_info = new String[]{'oneTimeCharge','http://www.wildblue.viasat.com/XMLSchema/PublicWebService/v2/TransactionService',null,'0','-1','false'};
        private String[] apex_schema_type_info = new String[]{'http://www.wildblue.viasat.com/XMLSchema/PublicWebService/v2/TransactionService','true','false'};
        private String[] field_order_type_info = new String[]{'externalServiceAgreementReference','externalTransactionReference','salesChannelName','dealerName','type_x','status','reasonCode','submittedDate','soldBy','submittedBy','note','serviceCallTypeName','oldServiceItem','serviceItem','oneTimeCharge'};
    }
    public class removeUsageQuota {
        public String externalSystemName;
        public String externalTransactionReference;
        public String externalServiceAgreementReference;
        public String responseURL;
        public String salesChannel;
        public String enteredBy;
        public String soldBy;
        public String marketingSourceCode;
        public String referralSourceCode;
        public String note;
        public AtlasTransServiceXmlschemav2.UsageQuotaItem[] removeUsageQuotaItem;
        private String[] externalSystemName_type_info = new String[]{'externalSystemName','http://www.wildblue.viasat.com/XMLSchema/PublicWebService/v2/TransactionService',null,'1','1','false'};
        private String[] externalTransactionReference_type_info = new String[]{'externalTransactionReference','http://www.wildblue.viasat.com/XMLSchema/PublicWebService/v2/TransactionService',null,'1','1','false'};
        private String[] externalServiceAgreementReference_type_info = new String[]{'externalServiceAgreementReference','http://www.wildblue.viasat.com/XMLSchema/PublicWebService/v2/TransactionService',null,'1','1','false'};
        private String[] responseURL_type_info = new String[]{'responseURL','http://www.wildblue.viasat.com/XMLSchema/PublicWebService/v2/TransactionService',null,'0','1','false'};
        private String[] salesChannel_type_info = new String[]{'salesChannel','http://www.wildblue.viasat.com/XMLSchema/PublicWebService/v2/TransactionService',null,'0','1','false'};
        private String[] enteredBy_type_info = new String[]{'enteredBy','http://www.wildblue.viasat.com/XMLSchema/PublicWebService/v2/TransactionService',null,'1','1','false'};
        private String[] soldBy_type_info = new String[]{'soldBy','http://www.wildblue.viasat.com/XMLSchema/PublicWebService/v2/TransactionService',null,'0','1','false'};
        private String[] marketingSourceCode_type_info = new String[]{'marketingSourceCode','http://www.wildblue.viasat.com/XMLSchema/PublicWebService/v2/TransactionService',null,'0','1','false'};
        private String[] referralSourceCode_type_info = new String[]{'referralSourceCode','http://www.wildblue.viasat.com/XMLSchema/PublicWebService/v2/TransactionService',null,'0','1','false'};
        private String[] note_type_info = new String[]{'note','http://www.wildblue.viasat.com/XMLSchema/PublicWebService/v2/TransactionService',null,'0','1','false'};
        private String[] removeUsageQuotaItem_type_info = new String[]{'removeUsageQuotaItem','http://www.wildblue.viasat.com/XMLSchema/PublicWebService/v2/TransactionService',null,'1','-1','false'};
        private String[] apex_schema_type_info = new String[]{'http://www.wildblue.viasat.com/XMLSchema/PublicWebService/v2/TransactionService','true','false'};
        private String[] field_order_type_info = new String[]{'externalSystemName','externalTransactionReference','externalServiceAgreementReference','responseURL','salesChannel','enteredBy','soldBy','marketingSourceCode','referralSourceCode','note','removeUsageQuotaItem'};
    }
    public class updateBillCycleResponse_element {
        public String result;
        private String[] result_type_info = new String[]{'result','http://www.wildblue.viasat.com/XMLSchema/PublicWebService/v2/TransactionService',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://www.wildblue.viasat.com/XMLSchema/PublicWebService/v2/TransactionService','true','false'};
        private String[] field_order_type_info = new String[]{'result'};
    }
    public class getAvailableBillCyclesResponse_element {
        public Integer[] dayOfMonth;
        private String[] dayOfMonth_type_info = new String[]{'dayOfMonth','http://www.wildblue.viasat.com/XMLSchema/PublicWebService/v2/TransactionService',null,'0','-1','false'};
        private String[] apex_schema_type_info = new String[]{'http://www.wildblue.viasat.com/XMLSchema/PublicWebService/v2/TransactionService','true','false'};
        private String[] field_order_type_info = new String[]{'dayOfMonth'};
    }
    public class getTransactionsByAccountResponse_element {
        public AtlasTransServiceXmlschemav2.Transaction_x[] transaction_x;
        private String[] transaction_x_type_info = new String[]{'transaction','http://www.wildblue.viasat.com/XMLSchema/PublicWebService/v2/TransactionService',null,'0','-1','false'};
        private String[] apex_schema_type_info = new String[]{'http://www.wildblue.viasat.com/XMLSchema/PublicWebService/v2/TransactionService','true','false'};
        private String[] field_order_type_info = new String[]{'transaction_x'};
    }
    public class getTransactionsByAccountAndType {
        public String externalSystemName;
        public String externalAccountReference;
        public String type_x;
        public DateTime startDate;
        public DateTime endDate;
        private String[] externalSystemName_type_info = new String[]{'externalSystemName','http://www.wildblue.viasat.com/XMLSchema/PublicWebService/v2/TransactionService',null,'1','1','false'};
        private String[] externalAccountReference_type_info = new String[]{'externalAccountReference','http://www.wildblue.viasat.com/XMLSchema/PublicWebService/v2/TransactionService',null,'1','1','false'};
        private String[] type_x_type_info = new String[]{'type','http://www.wildblue.viasat.com/XMLSchema/PublicWebService/v2/TransactionService',null,'1','1','false'};
        private String[] startDate_type_info = new String[]{'startDate','http://www.wildblue.viasat.com/XMLSchema/PublicWebService/v2/TransactionService',null,'0','1','false'};
        private String[] endDate_type_info = new String[]{'endDate','http://www.wildblue.viasat.com/XMLSchema/PublicWebService/v2/TransactionService',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://www.wildblue.viasat.com/XMLSchema/PublicWebService/v2/TransactionService','true','false'};
        private String[] field_order_type_info = new String[]{'externalSystemName','externalAccountReference','type_x','startDate','endDate'};
    }
    public class addUsageQuota {
        public String externalSystemName;
        public String externalTransactionReference;
        public String externalServiceAgreementReference;
        public String responseURL;
        public String salesChannel;
        public String enteredBy;
        public String soldBy;
        public String marketingSourceCode;
        public String referralSourceCode;
        public String note;
        public AtlasTransServiceXmlschemav2.UsageQuotaItem[] addUsageQuotaItem;
        private String[] externalSystemName_type_info = new String[]{'externalSystemName','http://www.wildblue.viasat.com/XMLSchema/PublicWebService/v2/TransactionService',null,'1','1','false'};
        private String[] externalTransactionReference_type_info = new String[]{'externalTransactionReference','http://www.wildblue.viasat.com/XMLSchema/PublicWebService/v2/TransactionService',null,'1','1','false'};
        private String[] externalServiceAgreementReference_type_info = new String[]{'externalServiceAgreementReference','http://www.wildblue.viasat.com/XMLSchema/PublicWebService/v2/TransactionService',null,'1','1','false'};
        private String[] responseURL_type_info = new String[]{'responseURL','http://www.wildblue.viasat.com/XMLSchema/PublicWebService/v2/TransactionService',null,'0','1','false'};
        private String[] salesChannel_type_info = new String[]{'salesChannel','http://www.wildblue.viasat.com/XMLSchema/PublicWebService/v2/TransactionService',null,'0','1','false'};
        private String[] enteredBy_type_info = new String[]{'enteredBy','http://www.wildblue.viasat.com/XMLSchema/PublicWebService/v2/TransactionService',null,'1','1','false'};
        private String[] soldBy_type_info = new String[]{'soldBy','http://www.wildblue.viasat.com/XMLSchema/PublicWebService/v2/TransactionService',null,'0','1','false'};
        private String[] marketingSourceCode_type_info = new String[]{'marketingSourceCode','http://www.wildblue.viasat.com/XMLSchema/PublicWebService/v2/TransactionService',null,'0','1','false'};
        private String[] referralSourceCode_type_info = new String[]{'referralSourceCode','http://www.wildblue.viasat.com/XMLSchema/PublicWebService/v2/TransactionService',null,'0','1','false'};
        private String[] note_type_info = new String[]{'note','http://www.wildblue.viasat.com/XMLSchema/PublicWebService/v2/TransactionService',null,'0','1','false'};
        private String[] addUsageQuotaItem_type_info = new String[]{'addUsageQuotaItem','http://www.wildblue.viasat.com/XMLSchema/PublicWebService/v2/TransactionService',null,'1','-1','false'};
        private String[] apex_schema_type_info = new String[]{'http://www.wildblue.viasat.com/XMLSchema/PublicWebService/v2/TransactionService','true','false'};
        private String[] field_order_type_info = new String[]{'externalSystemName','externalTransactionReference','externalServiceAgreementReference','responseURL','salesChannel','enteredBy','soldBy','marketingSourceCode','referralSourceCode','note','addUsageQuotaItem'};
    }
    public class getUniqueExternalReferenceValues {
        public Integer quantity;
        public String prefix;
        private String[] quantity_type_info = new String[]{'quantity','http://www.wildblue.viasat.com/XMLSchema/PublicWebService/v2/TransactionService',null,'0','1','false'};
        private String[] prefix_type_info = new String[]{'prefix','http://www.wildblue.viasat.com/XMLSchema/PublicWebService/v2/TransactionService',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://www.wildblue.viasat.com/XMLSchema/PublicWebService/v2/TransactionService','true','false'};
        private String[] field_order_type_info = new String[]{'quantity','prefix'};
    }
    public class updateBillCycle {
        public String externalSystemName;
        public String externalTransactionReference;
        public String externalAccountReference;
        public Date nextBillDate;
        private String[] externalSystemName_type_info = new String[]{'externalSystemName','http://www.wildblue.viasat.com/XMLSchema/PublicWebService/v2/TransactionService',null,'1','1','false'};
        private String[] externalTransactionReference_type_info = new String[]{'externalTransactionReference','http://www.wildblue.viasat.com/XMLSchema/PublicWebService/v2/TransactionService',null,'1','1','false'};
        private String[] externalAccountReference_type_info = new String[]{'externalAccountReference','http://www.wildblue.viasat.com/XMLSchema/PublicWebService/v2/TransactionService',null,'1','1','false'};
        private String[] nextBillDate_type_info = new String[]{'nextBillDate','http://www.wildblue.viasat.com/XMLSchema/PublicWebService/v2/TransactionService',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://www.wildblue.viasat.com/XMLSchema/PublicWebService/v2/TransactionService','true','false'};
        private String[] field_order_type_info = new String[]{'externalSystemName','externalTransactionReference','externalAccountReference','nextBillDate'};
    }
    public class updateShippingContactResponse_element {
        public String result;
        private String[] result_type_info = new String[]{'result','http://www.wildblue.viasat.com/XMLSchema/PublicWebService/v2/TransactionService',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://www.wildblue.viasat.com/XMLSchema/PublicWebService/v2/TransactionService','true','false'};
        private String[] field_order_type_info = new String[]{'result'};
    }
    public class addUsageQuotaResponse_element {
        public String result;
        private String[] result_type_info = new String[]{'result','http://www.wildblue.viasat.com/XMLSchema/PublicWebService/v2/TransactionService',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://www.wildblue.viasat.com/XMLSchema/PublicWebService/v2/TransactionService','true','false'};
        private String[] field_order_type_info = new String[]{'result'};
    }
    public class getUniqueExternalReferenceValuesResponse_element {
        public String[] externalReferenceValue;
        private String[] externalReferenceValue_type_info = new String[]{'externalReferenceValue','http://www.wildblue.viasat.com/XMLSchema/PublicWebService/v2/TransactionService',null,'1','-1','false'};
        private String[] apex_schema_type_info = new String[]{'http://www.wildblue.viasat.com/XMLSchema/PublicWebService/v2/TransactionService','true','false'};
        private String[] field_order_type_info = new String[]{'externalReferenceValue'};
    }
}