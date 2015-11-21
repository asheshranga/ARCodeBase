/*********************************************************************************
Name         : AtlasUsageQuotaDTO
Company Name : NTT Data 
Created By   : RahulKumar Sharma
Modified BY  : RahulKumar Sharma
Project      : ViaSat Atlas, Bangalore
Created Date : 30 October 2013
Modified Date : 13 November 2013
Usages       : DTO object for Usage Quota Information
*********************************************************************************/
global with sharing  class AtlasUsageQuotaDTO extends AtlasParentDTO{
   
   	
	
    /**
    * Holds the  external System Name. 
    */
        global String externalSystemName{get;set;}
    /**
    * Holds the external Transaction Reference. 
    */
        global String externalTransactionReference{get;set;}
	/**
    * Holds the  external Service Agreement Reference. 
    */
        global String externalServiceAgreementReference{get;set;}
	/**
    * Holds the responseURL. 
    */
        global String responseURL{get;set;}
	/**
    * Holds the sales Channel of the customer. 
    */
        global String salesChannel{get;set;}
	/**
    * Holds the  entered By details of the customer contact. 
    */
        global String enteredBy{get;set;}
	/**
    * Holds the sold By details of the customer contact. 
    */
        global String soldBy{get;set;}
	/**
    * Holds the  marketing Source Code of the customer contact. 
    */
        global String marketingSourceCode{get;set;}
	/**
    * Holds the  referral Source Code of the customer contact. 
    */
        global String referralSourceCode{get;set;}
	/**
    * Holds the note for the customer contact. 
    */
        global String note{get;set;}
    
}