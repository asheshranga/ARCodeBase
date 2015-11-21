/*********************************************************************************
Name         : AtlasNetBillingInfoDTO 
Created By   : Gaurav Gathania
Modified BY  : Gaurav Gathania
Company Name : NTT Data
Project      : ViaSat Atlas, Bangalore
Created Date : 30 October 2013
Modified Date: 13 November 2013
Usages       : Data Transfer Object for billing Information
*********************************************************************************/
global with sharing  class AtlasNetBillingInfoDTO extends AtlasParentDTO{
    
       
    
    /**
    * Holds the  external System Name. 
    */
        global String externalSystemName{get;set;}
	/**
    * Holds the  external Account Reference. 
    */
        global String externalAccountReference{get;set;}
	/**
    * Holds the  start Date of the Billing. 
    */	
		global DateTime startDate{get;set;}
	/**
    * Holds the  end Date of the Billing. 
    */
        global DateTime endDate{get;set;}
	/**
    * Holds the number of rows to be displayed. 
    */
        global Integer maxRows{get;set;}
	/**
    * Holds account information of the billing. 
    */
        global String account{get;set;}
}