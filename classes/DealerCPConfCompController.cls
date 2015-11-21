/*********************************************************************************
Name         : DealerCPConfCompController (Dealer Change Plan Confirmation Component Controller)
Created By   : Jim Tunney
Modified By  : 
Company Name : 
Project      : Dealer Portal
Created Date : 10/12/2015
Modified Date: 
Usages       : Controller for VisualForce Component: DealerCPConfirmComponent
*********************************************************************************/
public with sharing class  DealerCPConfCompController {    
    public DealerComponenttoController componentToPage{get; set;}
    
    /***** Note: values contained in the DealerKeyValueStore Custom Settings *****/
    public string buttonSignOutLabel {get {return DealerUtility.getMapValue(DealerConstants.ButtonSignOut);} set;}//displays "Sign Out"
    public string confirmationLabel {get {return DealerUtility.getMapValue(DealerConstants.Confirmation);} set;}//displays "Confirmation"
    public string cpConfirmAlertBoxHeader {get {return DealerUtility.getMapValue(DealerConstants.CPConfirmAlertBoxHeader);} set;}//displays header for blue alert box
    public string cpConfirmH4First {get {return DealerUtility.getMapValue(DealerConstants.CPConfirmH4First);} set;}//displays first h4 tag's text
    public string cpConfirmH4Second {get {return DealerUtility.getMapValue(DealerConstants.CPConfirmH4Second);} set;}//displays second h4 tag's text
    public string cpConfirmReceivedMsg {get {return DealerUtility.getMapValue(DealerConstants.CPConfirmReceivedMsg);} set;}//displays msg that change request is received
    public string custCarePhoneLabel {get {return DealerUtility.getMapValue(DealerConstants.CustCarePhone);} set;}//displays customer care phone number
    public string dashLink {get {return DealerUtility.getMapValue(DealerConstants.CPConfirmDashLink);} set;}//provides URL for dashboard hyperlink
    public string dashText {get {return DealerUtility.getMapValue(DealerConstants.CPConfirmDashText);} set;}//displays text for dashboard hyperlink
    public string printLink {get {return DealerUtility.getMapValue(DealerConstants.CPConfirmPrintLink);} set;}//provides URL for print hyperlink
    public string printText {get {return DealerUtility.getMapValue(DealerConstants.CPConfirmPrintText);} set;}//displays text for print hyperlink
    
   
}