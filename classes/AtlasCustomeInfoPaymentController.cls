/*********************************************************************************
Name         : AtlasCustomeInfoPaymentController
Created By   : Ruba Devi T
Modified BY  : Shiva Shankr N
Company Name : NTT Data
Project      : ViaSat Atlas, Bangalore
Created Date : 19 October2013
Usages       : Controller for VisualForce Component : AtlasCustomerInfoPaymentMethod
*********************************************************************************/
public with sharing class AtlasCustomeInfoPaymentController {
    
    public  AtlasAccountDTO  accountDTO{get;set;}
    public  AtlasPlanDetailsDTO planDtDTO{get;set;}
    public  AtlasMainDTO mainDTOObject{get;set;}
    // Initialinzing Customer Information Payment GlobalVariables HyperLinkURL   
    public string strBillPaymentURL{get{return AtlasUtility.getURL(AtlasConstants.PAYMENT_SETTINGS);}set;}
    public string strUpgradeAccount{get{return AtlasUtility.getURL(AtlasConstants.UPGRADE_ACCOUNT);}set;}
    public string strEditContactEmail{get{return AtlasUtility.getURL(AtlasConstants.ADD_AN_EMAIL_ADDRESS);}set;}
    // Initialinzing Customer Information Payment GlobalVariables HyperLinkText 
    public string strBillPaymentText{get{return AtlasUtility.getHyperLinkText(AtlasConstants.PAYMENT_SETTINGS);}set;}
    public string strUpgradeAccountText{get{return AtlasUtility.getHyperLinkText(AtlasConstants.PAYMENT_SETTINGS);}set;}
    public string strEditContactEmailText{get{return AtlasUtility.getHyperLinkText(AtlasConstants.PAYMENT_SETTINGS);}set;}
    // Initialinzing Customer Information Payment GlobalVariables Visibilty 
    public boolean isVisibleBillPayment{get{return AtlasUtility.getVisibility(AtlasConstants.PAYMENT_SETTINGS);}set;}
    public boolean isVisibleUpgradeAccount{get{return AtlasUtility.getVisibility(AtlasConstants.PAYMENT_SETTINGS);}set;}
    public boolean isVisibleEditContactEmail{get{return AtlasUtility.getVisibility(AtlasConstants.PAYMENT_SETTINGS);}set;}
    // Other variables used in this class    
    public string strCardType{get{return AtlasConstants.CREDIT_CARD;}set;}
    public string strPrice{get{return AtlasConstants.PRICE;}set;}
    public string strAgreementEndDate{get{return AtlasConstants.SERVICE_AGREEMENT_END_DATE;}set;}    
    //Style class Variables
    public string strStyleClass{get{return AtlasConstants.STYLE_CLASS_BILLINGHISTORY;}set;}
    // Holds Data allocation text vvalue for unlimited plans
    public string dataAllocationText{get{return AtlasUtility.getMapValue(AtlasConstants.Data_Allocation_For_Unlimited_Plan);} set;}
    Public AtlasCurrentBillDTO currentBillData{get;set;}  
    
    public String strMoving{get{return AtlasUtility.getURL(AtlasConstants.Moving);}set;}
    public string vacationPlanList{get{return AtlasUtility.getMapValue(Atlasconstants.AtlasCPlanVacationList);}set;} 
    
    /**
    * @author Raghuprasad Halakere
    * @description - Zero parameter AtlasCustomeInfoPaymentController constructor
    * @input param  - null
    * @return null
    */ 
    public AtlasCustomeInfoPaymentController()
    {  
    Apexpages.currentPage().getHeaders().put(AtlasConstants.X_UA_COMPATIBLE,AtlasConstants.IE_8); 
    }

}