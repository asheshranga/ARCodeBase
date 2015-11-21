/*********************************************************************************
Name         : DealerCustomerInfoDTO 
Created By   : Srikanth Kudumula
Modified By  : 
Company Name : 
Project      : Dealer Portal
Created Date : 11 Nov 2015 - Customer Info DTO
Usages       : Data Transfer Object for Information about the Dealer Dashboard 
*********************************************************************************/
global with sharing class DealerCustomerInfoDTO {
	
	/**
    * Holds the Anti Virus Service Name.
    */
    global String avService{get;set;}
    /**
    * Holds the Anti Virus Key.
    */
    global String avKey{get;set;}
    /**
    * Holds the Anti Virus Status.
    */
    global String avStatus{get;set;}
    /**
    * Holds the Anti Virus Status Date.
    */
    global DateTime avStatusDate{get;set;}
    /**
    * Holds the Billing Account Number.
    */
    global String billingAccNumber{get;set;}
    /**
    * Holds the Service Agreement Activation Date
    */
    global Datetime serAgrActivationDate{get;set;}
    /**
    * Holds the Contract Term
    */
    global Integer contractTerm{get;set;}
    /**
    * Holds the Remaining Months on Contract
    */
    global Integer remMononContract{get;set;}
    /**
    * Holds the Contract Renewal Date
    */
    global Datetime contrRenewalDate {get;set;}
    /**
    * Holds the Original Activation Date
    */
    global Datetime orgActivationDate {get;set;}
    /**
    * Holds the billing Address
    */
    global String billingAddress{get;set;}
    /**
    * Holds the Billing Address Street1
    */
    global String billStreet1{get;set;}
    /**
    * Holds the Billing Address Street2
    */
    global String billStreet2{get;set;}
    /**
    * Holds the Billing Address City
    */
    global String billCity{get;set;}
    /**
    * Holds the Billing Address State
    */
    global String billState{get;set;}
    /**
    * Holds the Billing Address Zip Code
    */
    global String billZip{get;set;}
    /**
    * Holds the Billing Address Zip Code last four digits
    */
    global String billZipLastFour{get;set;}
    /**
    * Holds the Password
    */
    global String password{get;set;}
    /**
    * Holds the Username
    */
    global String userName{get;set;}
    /**
    * Holds the Provisioned Beam
    */
    global Integer beamNumber{get;set;}
    /**
    * Holds the Satellite Id
    */
    global String satelliteId{get;set;}
    /**
    * Holds the Modem Key
    */
    global String modemKey{get;set;}
    /**
    * Holds the Polarization
    */
    global String polaziration{get;set;}
    /**
    * Holds the Date in Billing Info Section
    */
    global Datetime billInfoDate{get;set;}
    /**
    * Holds the Billing Cycle
    */
    global String billingCycle{get;set;}
    /**
    * Holds the Current Amount Due
    */
    global Double currentAmtDue{get;set;}
    /**
    * Holds the Product Name
    */
    global String ispproductName{get;set;}
    /**
    * Holds the Service Level
    */
    global String ispserviceLevel{get;set;}
    /**
    * Holds the Effective Date
    */
    global Datetime ispeffectiveDate{get;set;}
    /**
    * Holds the Provisioning Status
    */
    global String ispprovisioningStatus{get;set;}
	/**
    * Holds the Equipment Plan
    */
    global String equipmentPlan{get;set;}
    /**
    * Holds the Account Number
    */
    global String accountNumber{get;set;}
    /**
    * Holds the Device
    */
    global String device{get;set;}
    /**
    * Holds the Agreement Number
    */
    global String agreement{get;set;}
    /**
    * Holds the Status
    */
    global String status{get;set;}
    /**
    * Holds the Partner Account Number
    */
    global String partAccount{get;set;}
    /**
    * Holds the contact
    */
    global String contact{get;set;}
    /**
    * Holds the Primary Phone Number
    */
    global String primaryPhone{get;set;}
    /**
    * Holds the Secondary Phone Number
    */
    global String secondaryPhone{get;set;}
    /**
    * Holds the Email Address
    */
    global String emailAddress{get;set;}
    /**
    * Holds the First Name
    */
    global String firstName{get;set;}
    /**
    * Holds the Last Name
    */
    global String lastName{get;set;}
    /**
    * Holds the Business Name
    */
    global String businessName{get;set;}
    /**
    * Holds the Address1
    */
    global String street1{get;set;}
    /**
    * Holds the Street2
    */
    global String street2{get;set;}
    /**
    * Holds the City
    */
    global String city{get;set;}
    /**
    * Holds the State
    */
    global String state{get;set;}
    /**
    * Holds the Zip Code
    */
    global String zip{get;set;}
    /**
    * Holds the Zip Code last four digits
    */
    global String zipLastFour{get;set;}
    /**
    * Holds the Sales Channel
    */
    global String salesChannel{get;set;}
    /**
    * Holds the MAC Address
    */
    global String MACAddress{get;set;}
}