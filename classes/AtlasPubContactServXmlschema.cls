//Generated by wsdl2apex

public class AtlasPubContactServXmlschema {
    public class CorrectedAddress {
        public AtlasPubContactServXmlschemaCommonData.Address address;
        public String taxJurisdictionCode;
        private String[] address_type_info = new String[]{'address','http://www.viasat.com/XMLSchema/PublicWebService/v1/PublicContactService',null,'1','1','false'};
        private String[] taxJurisdictionCode_type_info = new String[]{'taxJurisdictionCode','http://www.viasat.com/XMLSchema/PublicWebService/v1/PublicContactService',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://www.viasat.com/XMLSchema/PublicWebService/v1/PublicContactService','true','false'};
        private String[] field_order_type_info = new String[]{'address','taxJurisdictionCode'};
    }
    public class updateContactsResponse_element {
        public String result;
        private String[] result_type_info = new String[]{'result','http://www.viasat.com/XMLSchema/PublicWebService/v1/PublicContactService',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://www.viasat.com/XMLSchema/PublicWebService/v1/PublicContactService','true','false'};
        private String[] field_order_type_info = new String[]{'result'};
    }
    public class UpdateContacts {
        public String externalAccountReference;
        public String externalSystemName;
        public String externalTransactionReference;
        public AtlasPubContactServXmlschema.CorrectedContact correctedContact;
        private String[] externalAccountReference_type_info = new String[]{'externalAccountReference','http://www.viasat.com/XMLSchema/PublicWebService/v1/PublicContactService',null,'1','1','false'};
        private String[] externalSystemName_type_info = new String[]{'externalSystemName','http://www.viasat.com/XMLSchema/PublicWebService/v1/PublicContactService',null,'1','1','false'};
        private String[] externalTransactionReference_type_info = new String[]{'externalTransactionReference','http://www.viasat.com/XMLSchema/PublicWebService/v1/PublicContactService',null,'1','1','false'};
        private String[] correctedContact_type_info = new String[]{'correctedContact','http://www.viasat.com/XMLSchema/PublicWebService/v1/PublicContactService',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://www.viasat.com/XMLSchema/PublicWebService/v1/PublicContactService','true','false'};
        private String[] field_order_type_info = new String[]{'externalAccountReference','externalSystemName','externalTransactionReference','correctedContact'};
    }
    public class FindAddressAndTaxJurisdictionsResponse {
        public AtlasPubContactServXmlschema.AddressAndTaxJurisdictions[] addressAndTaxJurisdictions;
        private String[] addressAndTaxJurisdictions_type_info = new String[]{'addressAndTaxJurisdictions','http://www.viasat.com/XMLSchema/PublicWebService/v1/PublicContactService',null,'1','-1','false'};
        private String[] apex_schema_type_info = new String[]{'http://www.viasat.com/XMLSchema/PublicWebService/v1/PublicContactService','true','false'};
        private String[] field_order_type_info = new String[]{'addressAndTaxJurisdictions'};
    }
    public class FindAddressAndTaxJurisdictions {
        public AtlasPubContactServXmlschemaCommonData.Address address;
        private String[] address_type_info = new String[]{'address','http://www.viasat.com/XMLSchema/PublicWebService/v1/PublicContactService',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://www.viasat.com/XMLSchema/PublicWebService/v1/PublicContactService','true','false'};
        private String[] field_order_type_info = new String[]{'address'};
    }
    public class AddressAndTaxJurisdictions {
        public AtlasPubContactServXmlschemaCommonData.Address address;
        public String[] taxJurisdictionCode;
        private String[] address_type_info = new String[]{'address','http://www.viasat.com/XMLSchema/PublicWebService/v1/PublicContactService',null,'1','1','false'};
        private String[] taxJurisdictionCode_type_info = new String[]{'taxJurisdictionCode','http://www.viasat.com/XMLSchema/PublicWebService/v1/PublicContactService',null,'0','-1','false'};
        private String[] apex_schema_type_info = new String[]{'http://www.viasat.com/XMLSchema/PublicWebService/v1/PublicContactService','true','false'};
        private String[] field_order_type_info = new String[]{'address','taxJurisdictionCode'};
    }
    public class CorrectedContact {
        public AtlasPubContactServXmlschemaCommonData.Person person;
        public String emailAddress;
        public String primaryPhone;
        public String secondaryPhone;
        public AtlasPubContactServXmlschema.CorrectedAddress billingAddress;
        public AtlasPubContactServXmlschema.CorrectedAddress serviceAddress;
        private String[] person_type_info = new String[]{'person','http://www.viasat.com/XMLSchema/PublicWebService/v1/PublicContactService',null,'0','1','false'};
        private String[] emailAddress_type_info = new String[]{'emailAddress','http://www.viasat.com/XMLSchema/PublicWebService/v1/PublicContactService',null,'0','1','false'};
        private String[] primaryPhone_type_info = new String[]{'primaryPhone','http://www.viasat.com/XMLSchema/PublicWebService/v1/PublicContactService',null,'0','1','false'};
        private String[] secondaryPhone_type_info = new String[]{'secondaryPhone','http://www.viasat.com/XMLSchema/PublicWebService/v1/PublicContactService',null,'0','1','false'};
        private String[] billingAddress_type_info = new String[]{'billingAddress','http://www.viasat.com/XMLSchema/PublicWebService/v1/PublicContactService',null,'0','1','false'};
        private String[] serviceAddress_type_info = new String[]{'serviceAddress','http://www.viasat.com/XMLSchema/PublicWebService/v1/PublicContactService',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://www.viasat.com/XMLSchema/PublicWebService/v1/PublicContactService','true','false'};
        private String[] field_order_type_info = new String[]{'person','emailAddress','primaryPhone','secondaryPhone','billingAddress','serviceAddress'};
    }
}