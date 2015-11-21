/*********************************************************************************
Name         : DealerMainDTO 
Created By   : 
Modified By  : 
Company Name : 
Project      : Dealer Portal
Created Date : 3 Nov 2015 - initially just copied AtlasMainDTO
Usages       : Data Transfer Object for Information Across constructors 
*********************************************************************************/
global with sharing class DealerMainDTO extends AtlasParentDTO{
	/**
    * Holds the loggedin  User Email.
    */
    global String loggedInUserEmail{get;set;}
    /**
    * Holds the Community User AccountType Information. 
    */
    global String CommunityUserAccountType{get;set;}
    /**
    * Holds the  Account No. 
    */
    global String accountNo{get;set;}
    /**
    * Holds the  Display Account No. 
    */
    global String displayAccNo{get;set;}
    
    /**
    * Holds the deviceProtocol  One of: pending, active, suspended, disconnected, or cancelled
    */
    global String deviceProtocol{get;set;}
    
    /**
    * Holds the  Account Encrypted Key. 
    */
    global String accountKey{get;set;}
    
    /**
    * Holds the  Account externalSystemName. 
    */
    global String externalSystemName{get;set;}
    
    /**
    * Holds the  Account externalAccountReference. 
    */
    global String externalAccountReference{get;set;}
    /**
    * Holds the  Account externalAccountReference. 
    */
    global String externalAccountReferencetype{get;set;}
    /**
    * Holds the transaction type 
    */
    global String transactionType{get;set;}
    /**
    * Holds the  Account externalAccountReference. 
    */
    global String internalAccountReference{get;set;}
      /**
    * Holds the  Account accountStatus. 
    */
    global String accountStatus{get;set;}
    
       /**
    * Holds the  Service Address1. 
    */
    global String serviceAdd1{get;set;}   
    global String serviceAdd2{get;set;}    
    global String serviceAddCity{get;set;}
    global String serviceAddCounty{get;set;}
    global String serviceAddState{get;set;}
    global String serviceAddZip{get;set;}
    
     /**
    * Holds the  Email 
    */
    global String customerEmail{get;set;}
    
     /**
    * Holds the fullPhotoURL 
    */    
    global string fullPhotoURL{get;set;}

     /**
    * Holds the  smallPhotoURL(cropped photo URL) 
    */    
    global string smallPhotoURL{get;set;}  
    /**
    * Holds the  Change Plan  DTO. 
    */
    global DealerChangePlanDTO changePlanDTOObj{get;set;}
    /**
    * Holds the  Plans  DTO. 
    */
    global DealerPlansDTO plansDTOObj{get;set;}
    /**
    * Holds the  Account DTO. 
    */
    global DealerAccountDTO accountDTOObj{get;set;}
    //***************************ATLAS SPECIFIC BELOW*************************
    /**
    * Holds the  Current Data Usage DTO. 
    */
    global AtlasCurrentDataUsageDTO cduDTOObj{get;set;}
    /**
    * Holds the  Current Payment Method DTO. 
    */
    global AtlasCurrentPaymentMethodDTO currentPaymentMethodDTOObj{get; set;}
     /**
    * Holds the  Billing History DTO. 
    */
    global AtlasBillingHistoryDTO billhistoryDTOObj{get;set;}
    /**
    * Holds the  Billing History DTO. 
    */
    global AtlasBillingSnapShotDTO billSnapShotDTOObj{get;set;}
    
    /**
    * Holds the  Current Bill  DTO. 
    */
    global AtlasCurrentBillDTO currentBillDTOObj{get;set;}
    
     /**
    * Holds the  Current Bill  DTO. 
    */
    global AtlasBuyMoreDTO buyMoreDTOObj{get;set;}
    
    /**
    * Holds the  Current Bill  DTO. 
    */
    global AtlasPlanDetailsDTO planDetailsDTO{get;set;}
    
    /**
    * Holds the  Current Bill  CDR DTO. 
    */
    global List<AtlasInvoiceCDRDTO> invoiceCDRDTO{get;set;}
//***************************ATLAS SPECIFIC ABOVE*************************

    /**
    * Holds  contactid.
    */
    global string contactId{get;set;} 
    /**
    *Holds UserName
    */
    global string federationId{get;set;}
    /**
    *Holds externalServiceAgreementReference
    */
    global string externalServiceAgreementReference{get;set;}
    /**
    *Holds isUnlimited value
    */
    global boolean isUnlimited{get;set;}
    
    global boolean isAccountPopulated{get;set;}
    
    global boolean isOpenNetPlan{get;set;}
    
    global String partnerName{get;set;}
    /**
    *Holds isBusinessPlan value
    */
    global boolean isBusinessPlan{get;set;}
    /**
    *Holds LibertyPlan value
    */
    global boolean isLibertyPlan{get;set;}
    /**
    Holds displayPlanData
    */
    global boolean displayPlanData{get;set;}
    /**
    * Holds the Customer Info DTO.
    */
    global DealerCustomerInfoDTO cusInfoDTO{get;set;}
    /**
    * Holds the Account Services DTO.
    */
    global AccountServicesDTO accServDTO{get;set;}
    /**
    * Holds the list of Customer Info DTO.
    */
    global list<DealerCustomerInfoDTO> cusInfoDTOList{get;set;}
}