/*********************************************************************************
Name          : DealerServiceAvailDTO 
Created By    : Tejesh M
Modified By   : 
Company Name  : 
Project       : Dealer Portal
Created Date  : 09 Nov 2015
Modified Date : 
Usages        : Data Transfer Object for Service Availability information
*********************************************************************************/

global with sharing class DealerServiceAvailDTO {
    global String firstName{get;set;}
    global String lastName{get;set;}
    global String serviceAdd1{get;set;} 
    global String serviceAdd2{get;set;}
    global String serviceCity{get;set;}
    global String serviceState{get;set;}
    global String serviceZip{get;set;}
    global String customerType{get;set;}
    
    global DealerServiceAvailDTO(String firstName,String lastName,String serviceAdd1,String serviceAdd2,String serviceCity,String serviceState,String serviceZip,String customerType) {
    	this.firstName = firstName;
        this.lastName = lastName;
        this.serviceAdd1 = serviceAdd1;
        this.serviceAdd2 = serviceAdd2;
        this.serviceCity = serviceCity;
        this.serviceState = serviceState;
        this.serviceZip = serviceZip;
        this.customerType = customerType;
        
    }
}