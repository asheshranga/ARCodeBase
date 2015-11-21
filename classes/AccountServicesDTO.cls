/*********************************************************************************
Name         : AccountServicesDTO 
Created By   : Srikanth Kudumula
Modified By  : 
Company Name : 
Project      : Dealer Portal
Created Date : 16 Nov 2015 - AccountServicesDTO
Usages       : Data Transfer Object for Information about the Dealer Account Services
*********************************************************************************/
global with sharing class AccountServicesDTO {
	global List<AccountServicesDTO.product> products{get;set;}
	global class product{
		/**
		* Holds the Product Name
		*/
		global String productName{get;set;}
		/**
		* Holds the Service Level
		*/
		global String serviceLevel{get;set;}
		/**
		* Holds the Effective Date
		*/
		global Datetime effectiveDate{get;set;}
		/**
		* Holds the Provisioning Status
		*/
		global String provisioningStatus{get;set;}
		
		global product(String prodName, String servLevel, Datetime effDate, String provStatus){
			this.productName = prodName;
			this.serviceLevel = servLevel;
			this.effectiveDate = effDate;
			this.provisioningStatus = provStatus; 
		}
	}
}