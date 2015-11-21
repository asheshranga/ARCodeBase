/*********************************************************************************
Name         : AtlasInvoiceCDRDTO 
Created By   : NTT Data
Modified BY  : 
Company Name : NTT Data
Project      : ViaSat Atlas, Bangalore
Created Date : 30 October 2013
Usages       : Data Transfer Object(DTO) for Invoice CDR (Call Data Record) information
*********************************************************************************/
global with sharing  class AtlasInvoiceCDRDTO  extends AtlasParentDTO{
    
   /**
    * Holds the  amount.  
    */
   global String amount{get;set;} 
   /**
    * Holds the  called no.  
    */
   global String calledNo{get;set;}
   /**
    * Holds the  locatione.  
    */
   global String location{get;set;}
   /**
    * Holds the  duration.  
    */
   global String duration{get;set;}
   /**
    * Holds the  dateTimeVal.  
    */
   global datetime dateTimeVal{get;set;}
   
   
}