/*********************************************************************************
Name         : AtlasTransactionDTO 
Created By   : Gaurav Gathania
Modified BY  : Gaurav Gathania
Project      : ViaSat Atlas, Bangalore
Created Date : 20 October 2013
Modified Dtae: 15 November 2013
Usages       : Controller for VisualForce Page: dashboard
*********************************************************************************/

global with sharing class AtlasTransactionDTO{
    
    /**
    *  @author Gaurav Gathania
    *  @Holds the AddUsageQuaotaDTO
      @ Method to update Quota
        @ String externalSystemName
        @ String externalTransactionReference
        @ String externalServiceAgreementReference
        @ String responseURL
        @ String salesChannel
        @ String enteredBy
        @ String soldBy
        @ String marketingSourceCode
        @ String referralSourceCode
        @ String note
        @ AtlasTransServiceXmlschemav2.UsageQuotaItem[] addUsageQuotaItem
    */
    global class AddUsageQuotaDTO
    {
        global String externalSystemName{get;set;}
        global String externalTransactionReference{get;set;}
        global String externalServiceAgreementReference{get;set;}
        global String responseURL{get;set;}
        global String salesChannel{get;set;}
        global String enteredBy{get;set;}
        global String soldBy{get;set;}
        global String marketingSourceCode{get;set;}
        global String referralSourceCode{get;set;}
        global String note{get;set;}
        global String transactionType{get;set;}
        global List<UsageItems>  usageItems{get;set;}
        
        global AddUsageQuotaDTO()
        {
            
        }
    }
    global class UsageItems {
        public String externalOneTimeChargeReference;
        public String masterCatalogNumber;
        public String displayName;
        public Double price;
        global UsageItems(String externalOneTimeChargeReference,String masterCatalogNumber,String displayName,Double price)
        {
            this.externalOneTimeChargeReference=externalOneTimeChargeReference;
            this.masterCatalogNumber=masterCatalogNumber;
            this.displayName=displayName;
            this.price=price;
        }
    }
    /**
    *  @author Gaurav Gathania
    *  @Holds the DuplicateAddress for Payment
   
    global class DuplicateAddressDTO
    {
        global Integer index{get;set;}
        global String address{get;set;}
        global String city{get;set;}
        global String state{get;set;}
        global String jurisdictionCode{get;set;}
        global DuplicateAddressDTO(Integer index,String address,String city,String state,String jurisdictionCode)
        {
            this.index=index;
            this.address=address;
            this.city=city;
            this.state=state;
            this.jurisdictionCode=jurisdictionCode;
        }
    }
    */
    /**
    *  @author Gaurav Gathania
    *  @Holds the DuplicateAddress for Payment
    
    global class ValidateBillingAddressDTO
    {   global boolean isValid{get;set;}
        global String errorMessage{get;set;}
        global String countryCode{get;set;}
        global String billingZip{get;set;}
        global String billingState{get;set;}
        global String billingCity{get;set;}
        global String billingAddress1{get;set;}
        global String billingAddress2{get;set;}
        global String taxJurisdictionCode{get;set;}  
        global ValidateBillingAddressDTO(String countryCode,String billingZip,String billingState,String billingCity,String billingAddress1,String billingAddress2,String taxJurisdictionCode)
        {
            this.countryCode=countryCode;
            this.billingZip=billingZip;
            this.billingState=billingState;
            this.billingCity=billingCity;
            this.billingAddress1=billingAddress1;
            this.billingAddress2=billingAddress2;
            this.taxJurisdictionCode=taxJurisdictionCode;
        }
        global void resetState()
        {
            isValid=false;
            errorMessage=AtlasConstants.BLANK;
        }
        
    }*/
    /**
    *  @author Gaurav Gathania
    *  @Holds the Update Customer Infromation DTO
    * 
    */
    global class UpdateCustomerInfoTxDTO {
    
        global String externalAccountReference{get;set;}
        global String externalSystemName{get;set;}
        global String username{get;set;}
        global String firstName{get;set;}
        global String lastName{get;set;}
        global String phone{get;set;}
        global String secondaryPhone{get;set;}
        global String email{get;set;}
        global String password{get;set;}
        global String billingAddress1{get;set;}
        global String billingAddress2{get;set;}
        global String city{get;set;}
        global String state{get;set;}
        global String zipCode{get;set;}
        global String zip4{get;set;}
        global String countryCode{get;set;}
        global String taxJurisdictionCode{get;set;}
        global String oldStrUsername{get;set;} 
        global String internalAccountReference{get;set;}
        global String internalServiceAgreementReference{get;set;}
         
        global UpdateCustomerInfoTxDTO(String externalAccountReference,String externalSystemName,String strUsername,String strPhone,String strEmail,String strPassword,String strBillingAddress1,String strBillingAddress2,String strCity,String strState,String strZipCode,String strZip4,String firstName,String lastName,String secondaryPhone,String countryCode,String taxJurisdictionCode,String oldStrUsername, String internalAccountReference, String InternalServiceAgreementServiceReference)
        {
            this.externalAccountReference=externalAccountReference;
            this.externalSystemName=externalSystemName;
            this.username=strUsername;
            this.phone=strPhone;
            this.email=strEmail;
            this.password=strPassword;
            this.billingAddress1=strBillingAddress1;
            this.billingAddress2=strBillingAddress2; 
            this.city=strCity;
            this.state=strState;
            this.zipCode=strZipCode;
            this.zip4=strZip4;
            this.firstName=firstName;
            this.lastName=lastName;
            this.secondaryPhone=secondaryPhone;
            this.countryCode=countryCode;
            this.taxJurisdictionCode=taxJurisdictionCode;
            this.oldStrUsername=oldStrUsername;
            this.internalAccountReference=internalAccountReference;
            this.internalServiceAgreementReference=internalServiceAgreementReference;
        }

    }
    /**
    *  @author Edwin Raymond
    *  @Holds the Updated Payment Method DTO
    * 
    */
    global class updatedPaymentMethodDTO {
        global String externalAccountReference{get;set;}
        global String externalSystemName{get;set;}
        global String externalTransactionReference {get;set;}
        global AtlasFinServiceXmlschemaV4FinanceService.PaymentMethodDetails paymentMethod {get;set;}
        public updatedPaymentMethodDTO(String externalAccountReference,String externalSystemName,String externalTransactionReference,AtlasFinServiceXmlschemaV4FinanceService.PaymentMethodDetails paymentMethod)
        {
            this.externalAccountReference = externalAccountReference;
            this.externalSystemName = externalSystemName;
            this.externalTransactionReference = externalTransactionReference;
            this.paymentMethod = paymentMethod;
        }
    }
    /**
    *  @author Edwin Raymond
    *  @Holds the One Time Payment DTO
    * 
    */
    global class oneTimePaymentDTO {
        global String externalAccountReference{get;set;}
        global String externalSystemName{get;set;}
        global String externalTransactionReference {get;set;}
        global String paymentMethodActionType {get;set;}
        global Double amount {get;set;}
        global AtlasFinServiceXmlschemaV4FinanceService.PaymentMethodDetails paymentMethod {get;set;}
        public oneTimePaymentDTO(String externalAccountReference,String externalSystemName,String externalTransactionReference,String paymentMethodActionType,Double amount,AtlasFinServiceXmlschemaV4FinanceService.PaymentMethodDetails paymentMethod)
        {
            this.externalAccountReference = externalAccountReference;
            this.externalSystemName = externalSystemName;
            this.externalTransactionReference = externalTransactionReference;
            this.paymentMethodActionType = paymentMethodActionType;
            this.amount = amount;
            this.paymentMethod = paymentMethod;
        }
    }
    /**
    *  @author Tejesh Kumar
    *  @Holds the One Time Payment DTO Auto Resume
    *  
    */
    global class oneTimePaymentDTOForAutoResume {
        global String externalAccountReference{get;set;}
        global String externalSystemName{get;set;}
        global String paymentMethodActionType {get;set;}
        global String externalTransactionReference {get;set;}
        global Double amount {get;set;}
        global AtlasFinServiceXmlschemaV4FinanceService.PaymentMethodDetails paymentMethod {get;set;}
        public oneTimePaymentDTOForAutoResume(String externalAccountReference,String externalSystemName,String externalTransactionReference,String paymentMethodActionType,Double amount,AtlasFinServiceXmlschemaV4FinanceService.PaymentMethodDetails paymentMethod)
        {
            this.externalAccountReference = externalAccountReference;
            this.externalTransactionReference = externalTransactionReference;
            this.externalSystemName = externalSystemName;
            this.paymentMethodActionType = paymentMethodActionType;
            this.amount = amount;
            this.paymentMethod = paymentMethod;
        }
    }

}