/*********************************************************************************
Name         : AtlasCurrentBillDTO 
Created By   : Gaurav Gathania
Modified BY  : Gaurav Gathania
Company Name : NTT Data
Project      : ViaSat Atlas, Bangalore
Created Date : 30 October 2013
Modified Date: 13 November 2013
Usages       : DTO object for billing Information
*********************************************************************************/
global with sharing class AtlasCurrentBillDTO extends AtlasParentDTO{
    
    
  
    
    /**
    * Holds the  Invoice Reference number. 
    */
    global string invoiceReference{get;set;}
    /**
    * Holds the  total charges details. 
    */
    global Double totalcharges{get;set;}
    /**
    * Holds the  total tax details. 
    */
    global Double totaltaxes{get;set;}
    /**
    * Holds the  total adjustment values. 
    */
    global Double totaladjustments{get;set;}
    /**
    * Holds the  total bill amount information. 
    */
    global Double totalbillamount{get;set;}
    /**
    * Holds the  total bill due date. 
    */
    global DateTime billDueDate{get;set;}
    /**
    * Holds the billing Address. 
    */
    global String billingAddress{get;set;}
     /**
    * Holds the Service Address. 
    */
    global String serviceAddress{get;set;}
    /**
    * Holds the  bill details. 
    */
    public List<BillingDetail> billdetails;
    public List<BillingDetail> getbilldetails(){
    if(billdetails != null) {
    AtlasConstants.sortBy='date';this.billdetails.sort();AtlasConstants.sortBy='desc';this.billdetails.sort();return billdetails;
    }else return null;
    }
   
    public void setbilldetails(List<BillingDetail> billdetails)
    {
        this.billdetails=billdetails;
    }   
    
    /**
    * Holds the List of List of tax details. 
    */
    global List<taxDetails> allTaxdetails{get;set;}
    
    /**
    * Holds the  tax details. 
    */
    global List<BillingDetail> taxdetails{get;set;}
    /**
    * Holds the  adjustment details. 
    */
    global List<BillingDetail> adjustmentdetails{get;set;}
    /**
    * Holds the  ledger summary details. 
    */
    global ledgerSummary ledgerSummaryDetails{get;set;}
    
    /**
    * Holds the  billing summary details. 
    */
    global InvoiceSummary invoiceSummaryDetails{get;set;}
    /**
    * Holds the Account One Time Charge details. 
    */
    global List<accountOneTimeCharge> oneTimeCharges{get;set;}
    /**
    * Holds the Event Summary details. 
    */
    global List<EventSummaryData> allEventData{get;set;}
    
    
    /** Inner class
    * Holds the  Account One Time charges. 
    */
    public class accountOneTimeCharge
    {
        public String type{get;set;}
        public DateTime chargeDate{get;set;}
        public Double amount{get;set;}
        public accountOneTimeCharge(String type,DateTime chargeDate,Double amount)
        {
            this.type=type;
            this.chargeDate=chargeDate;
            this.amount=amount;
        }
    }     
    /** Inner class
    * Holds the  billing detail information. 
    */
    Public class BillingDetail implements Comparable
    {
        Public String itemname{get;set;}
        Public Date billfromdate{get;set;}
        Public Date billtodate{get;set;}
        Public Double amount{get;set;}
        public String sortBy{get;set;}
        Public BillingDetail(String iname,Date fdate,Date tdate,Double amount)
        {
            this.itemname=iname;
            this.billfromdate=fdate;
            this.billtodate=tdate;
            this.amount=amount;            
        } 
        public Integer compareTo(Object compareTo){
            BillingDetail compareTobill=(BillingDetail)compareTo;
            if (AtlasConstants.sortBy=='date'){
                if (billfromdate==compareTobill.billfromdate) return 0;
                if (billfromdate>compareTobill.billfromdate) return 1;
                return -1;       
            } 
            else if(AtlasConstants.sortBy=='desc'){
                return itemname.CompareTo(((BillingDetail)compareTobill).itemname);
            }
                return -1;
         }         
    }  
    
    /** Inner class
    * Holds the  billing detail information. 
    */
    Public class taxDetails
    {
        Public String taxType{get;set;}
        Public List<BillingDetail> taxLineItems{get;set;}
        Public taxDetails(String taxType,List<BillingDetail> taxLineItems)
        {
            this.taxType=taxType;
            this.taxLineItems=taxLineItems;
        }        
    }  
    
     /** Inner class
    * Holds the  Ledger Summary Information. 
    */
    Public class ledgerSummary
    {
        public String billingCycleDay{get;set;}
        public DateTime nextBillDate{get;set;}
        public Double currentAmountBalance{get;set;}
        public Double totalAmountUnbilledOneTimeCharges{get;set;}
        public Double totalAmountUnbilledAdjustments{get;set;}
        public Double totalAmountPendingDisputes{get;set;}
        public Double totalAmountPastDue{get;set;}
        public Integer totalDaysPastDue{get;set;}
        
        Public ledgerSummary(String billingCycleDay, DateTime nextBillDate,Double currentAmountBalance,Double totalAmountUnbilledOneTimeCharges,Double totalAmountUnbilledAdjustments,Double totalAmountPendingDisputes,Double totalAmountPastDue,Integer totalDaysPastDue)
        {
            this.billingCycleDay=billingCycleDay;
            this.nextBillDate=nextBillDate;
            this.currentAmountBalance=currentAmountBalance;
            this.totalAmountUnbilledOneTimeCharges=totalAmountUnbilledOneTimeCharges;
            this.totalAmountUnbilledAdjustments=totalAmountUnbilledAdjustments;
            this.totalAmountPendingDisputes=totalAmountPendingDisputes;
            this.totalAmountPastDue=totalAmountPastDue;
            this.totalDaysPastDue=totalDaysPastDue;
        }
    } 
    /** Inner class
    * Holds the  Event Summary Information. 
    */
    public class EventSummaryData
    {
        public String evenType{get;set;}
        public String eventLabel{get;set;}
        public Double totalAmountEvents{get;set;}
        public EventSummaryData(String evenType, String eventLabel, Double totalAmountEvents)
        {
            this.evenType=evenType;
            this.eventLabel=eventLabel;
            this.totalAmountEvents=totalAmountEvents;
        }
    }
    /** Inner class
    * Holds the  Billing Summary Information. 
    */
    public class InvoiceSummary {
        public String externalInvoiceReference{get;set;}
        public DateTime statementDate{get;set;}
        public DateTime dueDate{get;set;}
        public Double amountDue{get;set;}
        public Double previousBalance{get;set;}
        public Double totalAmountCurrentChargesAndFees{get;set;}
        public Double totalAmountAdjustments{get;set;}
        public Double totalAmountLateFees{get;set;}
        public Double totalAmountTaxes{get;set;}
        public Double totalAmountPayments{get;set;}
        public Double totalAmountFailedPayments{get;set;}
        public Double totalAmountRefunds{get;set;}
        public Double totalAmountOneTimeCharges{get;set;}
        
        public String statementDateAsMMDDYYYY { get { return DateUtils.getDateTimeAsMMDDYYYY(statementDate); } private set; }
        
        Public InvoiceSummary (String externalInvoiceReference, DateTime statementDate,DateTime dueDate,Double amountDue,Double previousBalance,Double totalAmountCurrentChargesAndFees,Double totalAmountAdjustments,Double totalAmountLateFees,Double totalAmountTaxes,Double totalAmountPayments,Double totalAmountFailedPayments,Double totalAmountRefunds,Double totalAmountOneTimeCharges)
        {
            this.externalInvoiceReference=externalInvoiceReference;
            this.statementDate=statementDate;
            this.dueDate=dueDate;
            this.amountDue=amountDue;
            this.previousBalance=previousBalance;
            this.totalAmountCurrentChargesAndFees=totalAmountCurrentChargesAndFees;
            this.totalAmountAdjustments=totalAmountAdjustments;
            this.totalAmountLateFees=totalAmountLateFees;
            this.totalAmountTaxes=totalAmountTaxes;
            this.totalAmountPayments=totalAmountPayments;
            this.totalAmountFailedPayments=totalAmountFailedPayments;
            this.totalAmountRefunds=totalAmountRefunds;
            this.totalAmountOneTimeCharges=totalAmountOneTimeCharges;
        }
     }     
}