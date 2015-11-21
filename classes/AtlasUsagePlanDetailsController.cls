/*********************************************************************************
Name         : AtlasUsagePlanDetailsController
Created By   : Ruba Devi T
Modified BY  : Ruba Dev T
Company Name : NTT Data
Project      : ViaSat Atlas, Bangalore
Created Date : 19 October 2013
Created Date : 13 November 2013
Usages       : Controller for VisualForce Component : Atlas_UsagePage_Plan_Details
*********************************************************************************/
public with sharing class AtlasUsagePlanDetailsController {
	
    public  AtlasPlanDetailsDTO planDtDTO{get;set;}
    public AtlasCurrentDataUsageDTO cudDTO{get;set;}
    public string strChangePlanURL{get{return AtlasUtility.getURL(AtlasConstants.strCHANGE_PLAN);}set;}
    public string strStyleClass{get{return AtlasConstants.STYLE_CLASS_BILLINGHISTORY;}set;}
    public string PlanDetailsLabel{get{return AtlasConstants.PlanDetailsLabel;}set;}
    public string Added1GBLabel{get{return AtlasUtility.getMapValue(AtlasConstants.Added1GBLabel);}set;}
    public string PerMonthLabel{get{return AtlasConstants.PerMonthLabel;}set;}
    public string ChangePlanLabel{get{return AtlasConstants.ChangePlanLabel;}set;}
    public string LoadingPlanDetailsLabel{get{return AtlasConstants.LOADING_PLAN_DETAILS;}set;}
    public string UnlimitedPlan{get{return AtlasUtility.getMapValue(AtlasConstants.Unlimited_Plan_Text);}set;}
    public String strMoving{get{return AtlasUtility.getURL(AtlasConstants.Moving);}set;}
    public string vacationPlanList{get{return AtlasUtility.getMapValue(Atlasconstants.AtlasCPlanVacationList);}set;} 
    
    /**
      Atlas UsagePlanDetails Controller
      constructor
    */
    public AtlasUsagePlanDetailsController ()
    {
        Apexpages.currentPage().getHeaders().put(AtlasConstants.X_UA_COMPATIBLE,AtlasConstants.IE_8);        
    }
}