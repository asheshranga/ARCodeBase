/*********************************************************************************
Name         : AtlasBillingHistoryDTO 
Created By   : Gaurav Gathania
Modified BY  : Gaurav Gathania
Company Name : NTT Data
Project      : ViaSat Atlas, Bangalore
Created Date : 30 October 2013
Modified Date: 13 November 2013
Usages       : DTO object for billing History Information
*********************************************************************************/
global with sharing  class AtlasBillingHistoryDTO  extends AtlasParentDTO{

     
        /**
        * Holds a boolean value to denote if billing history exists for this account. 
        */
            global Boolean hasBillingHistory{get;set;}   
        /**
        * Holds a list of individual bills for this account. 
        */
            global List<billingHistoryLineItem> billHistory {get;set;}         
        
    global class billingHistoryLineItem
    {
        /**
        * Holds the  Statement Date of the bill. 
        */
            global DateTime statementDate{get;set;}
        /**
        * Holds the  Due Date of the bill. 
        */
            global DateTime dueDate{get;set;} 
        /**
        * Holds the Amound due for the bill. 
        */
            global Double amountDue{get;set;}
        /**
        * Holds the  Invoice reference number of the bill. 
        */
            global String invoiceReference{get;set;}
        
        /** Set the constructor for this class **/
        global billingHistoryLineItem(DateTime statementDate, DateTime dueDate, Double amountDue, String invoiceReference)
        {
            this.statementDate = statementDate;
            this.dueDate = dueDate;
            this.amountDue = amountDue;
            this.invoiceReference = invoiceReference;
        }
    }    
}