/*********************************************************************************
Name         : DealerSearchDTO Controller
Created By   : Srikanth Kudumula
Created Date : 11/5/2015
Project      : Dealer Portal 
Usages       :Class for Dealer Search Information
Change Log   :
<Date>      <Modified By>   <Change Description>
*********************************************************************************/
global with sharing class DealerSearchDTO {
	global string externalReferenceType{get;set;}//variable to hold external account type
	global string externalReference{get;set;}//variable to hold external account number
	global string internalReferenceType{get;set;}//variable to hold internal account type
	global string internalReference{get;set;}//variable to hold account number
	global string contactType{get;set;}//variable to hold contact type
	global string emailAddress{get;set;}//variable to hold email address
	global string phoneNumber{get;set;}//variable to hold phone number
	global string firstName{get;set;}//variable to hold first name
	global string lastName{get;set;}//variable to hold last name
	global string subscriberUsername{get;set;}//variable to hold Subscriber username
	global string businessName{get;set;}//variable to hold business name
	global string countryCode{get;set;}//variable to hold country code
	global string Zip{get;set;}//variable to hold zip
	global string city{get;set;}//variable to hold city
	global string state{get;set;}//variable to hold state
	global string streetAddress{get;set;}//variable to hold street address
	global string ticketNumber{get;set;}//variable to hold ticket number
	global string MACAddress{get;set;}//variable to hold MAC address
	global string serialNumber{get;set;}//variable to hold serial number
	global string maxresults{get;set;}
	global string systemval{get;set;}//variable to hold system value

}