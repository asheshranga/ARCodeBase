/*********************************************************************************
Name         : AtlasMainDTO 
Created By   : NTT Data
Modified BY  : 
Company Name : NTT Data
Project      : ViaSat Atlas, Bangalore
Created Date : 28 October 2013
Usages       : Data Transfer Object for Information Across constructors 
*********************************************************************************/
global with sharing class AtlasMainDTO extends AtlasParentDTO{  
   
   
    
   
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
    * Holds the  Account DTO. 
    */
    global AtlasAccountDTO accountDTOObj{get;set;}
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
    * Holds the  Change Plan  DTO. 
    */
    global AtlasChangePlanDTO changePlanDTOObj{get;set;}
    
    /*AR 11/17/2015: instrumention project, to capture callout times*/
 	
 	global  List<AtlasTransactionModel> atlasTransactionModelList {get;set;} 
 	 	
 	 //--- New variables for SB2+ : getAccount Shipping address details        
    /**
    * Holds the  Line one of the  shipping address. Usually street number and name.
    */
    global String shippingAdd1{get;set;}
    /**
    * Holds the  Line two of the  shipping address. Usually information such as apartment number.
    */
    global String shippingAdd2{get;set;}
    /**
    * Holds the  The city of the  shipping address.
    */
    global String shippingCity{get;set;}
    /**
    * Holds the  The county of the shipping address.Reserved for future use. 
    */
    global String shippingCounty{get;set;}  
    /**
    * Holds the  The two-letter state abbreviation of the  shipping address.
    */
    global String shippingState{get;set;}   
    /**
    * Holds the five-digit ZIP code of the shipping address.
    */
    global String shippingZip{get;set;} 
    /**
    * Holds the plus four component of the ZIP code of the  shipping address.
    */
    global String shippingZip4{get;set;} 
    /**
    * Holds the shippingFname of the  shipping address.
    */
    global String shippingFname{get;set;} 
    /**
    * Holds the shippingLname of the  shipping address.
    */
    global String shippingLname{get;set;} 
    /**
    * Holds the shippingPhone of the  shipping address.
    */
    global String shippingPhone{get;set;} 
    
    /**
    * Holds the shippingPhone of the  shipping address.
    */
    global String shippingPhoneUS{get{return usMobileNoFormat();}set;}
    
	/**
	* Method is used to convert the mobile number to us format and return the string
	*/
	global string usMobileNoFormat()
	{
	    system.debug('---shippingPhone---> '+ shippingPhone);
	    
	    if(!AtlasUtility.isEmpty(shippingPhone)) 
	      {                  
	          shippingPhone=shippingPhone.remove('-');
	          shippingPhone=shippingPhone.remove('(');
	          shippingPhone=shippingPhone.remove(')');
	          shippingPhone=shippingPhone.remove(' '); 
	          String s = shippingPhone.trim();
	          return s.substring(0, 3) + '-' + s.substring(3, 6) + '-' + s.substring(6);                                          
	      }
	      else{
	      return shippingPhone;
	      }
	} 
 	 
}