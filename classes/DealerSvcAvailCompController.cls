/*********************************************************************************
Name         : DealerSvcAvailCompController
Created By   : Jim Tunney
Modified BY  : 
Company Name : 
Project      : Dealer Portal
Created Date : 10/26/2015
Modified Date: 
Usages       : Controller for VisualForce Component: DealerSvcAvailComponent
*********************************************************************************/
public with sharing class DealerSvcAvailCompController {
    public DealerComponenttoController componentToPage{get; set;}
    
    /***** Note: values contained in the DealerKeyValueStore Custom Settings *****/
    public string buttonChkSvcLabel {get {return DealerUtility.getMapValue(DealerConstants.ButtonChkSvcability);} set;} 
    public string USPSZipCodeLookupLink {get {return DealerUtility.getMapValue(DealerConstants.USPSZipCodeLookupLink);} set;} 
    public string ServAvailStatesList {get {return DealerUtility.getMapValue(DealerConstants.ServAvailStatesList);} set;}
    public string ServAvailErrorMessage {get {return DealerUtility.getMapValue(DealerConstants.ServAvailErrorMessage);} set;}

    Public String serviceFirstName{get;set;}
    Public String serviceLastName{get;set;}
    Public String serviceAddress1{get;set;}
    Public String serviceAddress2{get;set;}
    Public String serviceCity{get;set;}
    Public String serviceState{get;set;}
    Public String serviceZip{get;set;}
    Public String customerType{get;set;}
    public boolean isError{get;set;}
    public boolean isMovingCustomer{get;set;} 
    public boolean isSIBusiness{get;set;}
    
    public List<SelectOption> getAvailStates(){
	        List<SelectOption> options=new List<SelectOption>();
	        options.add(new SelectOption('',''));             
	        DealerKeyValueStore__c DealerKVS = DealerKeyValueStore__c.getValues('ServAvailStatesList');
	        String states = DealerKVS.Value__c;
	        String[] sArray = states.split(',');
	        system.debug('---sArray---> '+sArray);
	        for(String str:sArray){
	            options.add(new SelectOption(str,str));
	        }             
	        return options;
	}
	               
    //Constructor
    public DealerSvcAvailCompController(){
        isError= false;
        //DealerIntegrationServiceManager.getPackages();
        //isMovingCustomer=true;
    }
    
    public pageReference checkSvcability(){
        componentToPage.clickedStep = 1;
        componentToPage.OrderStep0 = false;
        componentToPage.OrderStep1 = true;
        componentToPage.OrderStep2 = false;
        componentToPage.OrderStep3 = false;
        componentToPage.OrderStep4 = false;
        componentToPage.OrderStep5 = false;
        componentToPage.OrderStep6 = false;
        componentToPage.OrderStep7 = false;
                       
        return null;
    }
    
    public pageReference startOver(){
        componentToPage.clickedStep = 0;
        componentToPage.OrderStep0 = true;
        componentToPage.OrderStep1 = false;
        componentToPage.OrderStep2 = false;
        componentToPage.OrderStep3 = false;
        componentToPage.OrderStep4 = false;
        componentToPage.OrderStep5 = false;
        componentToPage.OrderStep6 = false;
        componentToPage.OrderStep7 = false;
        
        return null;
    }

}