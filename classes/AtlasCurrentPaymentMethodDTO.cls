/*********************************************************************************
Name         : AtlasCurrentPaymentMethodDTO 
Created By   : Gaurav Gathania
Modified BY  : Gaurav Gathania
Company Name : NTT Data
Project      : ViaSat Atlas, Bangalore
Created Date : 30 October 2013
Modified Date : 13 November 2013
Usages       : DTO object for Current Payment Method Information
*********************************************************************************/
global with sharing  class AtlasCurrentPaymentMethodDTO extends AtlasParentDTO{

	/**
	* Holds the payment type (Bank Account / Creadit Card) for this account. 
	*/
	global String paymentMethodType{get;set;}   
	/**
	* Holds the Bank Account details for this account. 
	*/
	global paymentBankAccount paymentBankDetails{get;set;} 
	/**
		* Holds the Credit Card details for this account. 
		*/
	global paymentCreditCard paymentCreditCardDetails{get;set;}              
	
	global class paymentBankAccount
	{
		/**
		* Holds the  Account Holder Name. 
		*/
		global String accountHolder{get;set;}
		/**
		* Holds the last four digits of the Account Number. 
		*/
		global String lastFourDigits{get;set;} 
		/**
		* Holds the bank code. 
		*/
		global String bankCode{get;set;}
		/**
		* Holds the payment type for this account. 
		*/
		global String paymentType{get;set;}
		
		/** Set the constructor for this class **/
		global paymentBankAccount(String accountHolder,String lastFourDigits,String bankCode,String paymentType)
		{
			this.accountHolder=accountHolder;
			this.lastFourDigits=lastFourDigits;
			this.bankCode=bankCode;
			this.paymentType=paymentType;
		}
	}    
	
	global class paymentCreditCard
	{
		/**
		* Holds the last four digits of the Credit Card. 
		*/
		global String lastFourDigits{get;set;}
		/**
		* Holds the expiration date of the Credit Card. 
		*/
		global DateTime expirationDate{get;set;} 
		/**
		* Holds the Zip code associated with the credit card. 
		*/
		global String zipCode{get;set;}
		/**
		* Holds the payment method for this Credit card. 
		*/
		global String methodOfPayment{get;set;}
		
		/** Set the constructor for this class **/
		global paymentCreditCard(String lastFourDigits,DateTime expirationDate,String zipCode,String methodOfPayment)
		{
			this.lastFourDigits=lastFourDigits;
			this.expirationDate=expirationDate;
			this.zipCode=zipCode;
			this.methodOfPayment=methodOfPayment;
		}
	}    
}