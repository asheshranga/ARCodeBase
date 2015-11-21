/*********************************************************************************
Name         : AtlasMobileController
Created By   : Raghuprasad Halkere
Modified BY  : Raghuprasad Halkere
Company Name : NTT Data
Project      : ViaSat Atlas, Bangalore
Created Date : 20 October 2013
Modified Date: 13 November 2013
Usages       : Controller for VisualForce PageComponent: AtlasMobileComponent
*********************************************************************************/
public with sharing class AtlasMobileController{
       
        // Intializing AtlasAccountDTO object       
        public  AtlasAccountDTO  accountDTO{get;set;}
        // Intializing GlobalVariables for HyperLinkURL      
        public string strDashboardURL{get{return AtlasUtility.getURL(AtlasConstants.DASHBOARD);}set;}
        public string strDataUsageURL{get{return AtlasUtility.getURL(AtlasConstants.DATA_USAGE);}set;}
        public string strViewUsageURL{get{return AtlasUtility.getURL(AtlasConstants.VIEW_USAGE);}set;}
        public string strBuyMoreURL{get{return AtlasUtility.getURL(AtlasConstants.BUY_MORE);}set;}
        public string strBillPaymentURL{get{return AtlasUtility.getURL(AtlasConstants.BILL_PAYMENT);}set;}
        public string strViewCurrentBillURL{get{return AtlasUtility.getURL(AtlasConstants.VIEW_CURRENT_BILL);}set;}
        public string strBillingHistoryURL{get{return AtlasUtility.getURL(AtlasConstants.BILLING_HISTORY);}set;}
        public string strUpadePaymentURL{get{return AtlasUtility.getURL(AtlasConstants.UPDATE_PAYMENT);}set;}
        public string strMakeOneTimePayURL{get{return AtlasUtility.getURL(AtlasConstants.MAKE_ONE_TIME_PAY);}set;}
        public string strMyAccountURL{get{return AtlasUtility.getURL(AtlasConstants.MY_ACCOUNT);}set;}
        public string strCustomerURL{get{return AtlasUtility.getURL(AtlasConstants.CUSTOMER);}set;}
        public string strManageEmailURL{get{return AtlasUtility.getURL(AtlasConstants.MANAGE_EMAIL);}set;}
        public string strManageEmailAccountURL{get{return AtlasUtility.getURL(AtlasConstants.MANAGE_EMAIL_ACCOUNT);}set;}     
        public string strManageEmailText{get{return AtlasUtility.getHyperLinkText(AtlasConstants.MANAGE_EMAIL_ACCOUNT);}set;}
        public string strManageEmailLabel{get{return AtlasUtility.getHyperLinkText(AtlasConstants.MANAGE_EMAIL);}set;}           
        //public string strManageEmailURL{get{return AtlasUtility.getURL(AtlasConstants.MANAGE_EMAIL);}set;}
        public string strOnlineCommunityURL{get{return AtlasUtility.getURL(AtlasConstants.ONLINE_COMMUNITY);}set;}  
        public string strBlogURL{get{return AtlasUtility.getURL(AtlasConstants.BLOG);}set;}  
        public string strForumURL{get{return AtlasUtility.getURL(AtlasConstants.FORUM);}set;} 
        public string strKnowledgeBaseURL{get{return AtlasUtility.getURL(AtlasConstants.KNOWLEDGE_BASE);}set;}  
        public String strfacebookURL{get{return AtlasUtility.getURL(AtlasConstants.FACEBOOK);}set;}
        public String strtwitterURL{get{return AtlasUtility.getURL(AtlasConstants.TWITTER);}set;}
        public String strYouTubeURL{get{return AtlasUtility.getURL(AtlasConstants.YOUTUBE);}set;}
        public String strGooglePlusURL{get{return AtlasUtility.getURL(AtlasConstants.GOOGLE_PLUS);}set;}
        public string strSignOutURL{get{return AtlasUtility.getURL(AtlasConstants.SIGNOUT);}set;}
        public String strChangePlanUrl{get{return AtlasUtility.getURL(AtlasConstants.strCHANGE_PLAN);}set;}
        public String strMoving{get{return AtlasUtility.getURL(AtlasConstants.Moving);}set;}
        public String activateVoipLink{get{return AtlasUtility.getURL(AtlasConstants.AtlasActivateVoipLink);}set;}
        public String manageVoipLink{get{return AtlasUtility.getURL(AtlasConstants.AtlasManageVoipLink);}set;}
        // Intializing Global Variables for HyperLinkText              
        public string strDashboardText{get{return AtlasUtility.getHyperLinkText(AtlasConstants.DASHBOARD);}set;}
        public string strDataUsageText{get{return AtlasUtility.getHyperLinkText(AtlasConstants.DATA_USAGE);}set;}
        public string strViewUsageText{get{return AtlasUtility.getHyperLinkText(AtlasConstants.VIEW_USAGE);}set;}
        public string strBuyMoreText{get{return AtlasUtility.getHyperLinkText(AtlasConstants.BUY_MORE);}set;}
        public string strBillPaymentText{get{return AtlasUtility.getHyperLinkText(AtlasConstants.BILL_PAYMENT);}set;}
        public string strViewCurrentBillText{get{return AtlasUtility.getHyperLinkText(AtlasConstants.VIEW_CURRENT_BILL);}set;}
        public string strBillingHistoryText{get{return AtlasUtility.getHyperLinkText(AtlasConstants.BILLING_HISTORY);}set;}
        public string strUpadePaymentText{get{return AtlasUtility.getHyperLinkText(AtlasConstants.UPDATE_PAYMENT);}set;}
        public string strMakeOneTimePayText{get{return AtlasUtility.getHyperLinkText(AtlasConstants.MAKE_ONE_TIME_PAY);}set;}
        public string strMyAccountText{get{return AtlasUtility.getHyperLinkText(AtlasConstants.MY_ACCOUNT);}set;}
        public string strCustomerText{get{return AtlasUtility.getHyperLinkText(AtlasConstants.CUSTOMER);}set;}
        public string strChangePlan{get{return AtlasUtility.getHyperLinkText(AtlasConstants.strCHANGE_PLAN);}set;}
        //public string strManageEmailText{get{return AtlasUtility.getHyperLinkText(AtlasConstants.MANAGE_EMAIL);}set;}
        public string strOnlineCommunityText{get{return AtlasUtility.getHyperLinkText(AtlasConstants.ONLINE_COMMUNITY);}set;}  
        public string strBlogText{get{return AtlasUtility.getHyperLinkText(AtlasConstants.BLOG);}set;}  
        public string strForumText{get{return AtlasUtility.getHyperLinkText(AtlasConstants.FORUM);}set;} 
        public string strKnowledgeBaseText{get{return AtlasUtility.getHyperLinkText(AtlasConstants.KNOWLEDGE_BASE);}set;}
        public string KnowledgeBaseLabel{get{return AtlasUtility.getMapValue(AtlasConstants.STRHEADER3_AtlasKnowledgeBase);}set;}  
        public String strfacebookText{get{return AtlasUtility.getHyperLinkText(AtlasConstants.FACEBOOK);}set;}
        public String strtwitterText{get{return AtlasUtility.getHyperLinkText(AtlasConstants.TWITTER);}set;}
        public String strYouTubeText{get{return AtlasUtility.getHyperLinkText(AtlasConstants.YOUTUBE);}set;}
        public String strGooglePlusText{get{return AtlasUtility.getHyperLinkText(AtlasConstants.GOOGLE_PLUS);}set;}
        public string strSignOutText{get{return AtlasUtility.getHyperLinkText(AtlasConstants.SIGNOUT);}set;}       
         // Intializing Global Variables for IsVisibility              
        public boolean isVisibleDashboard{get{return AtlasUtility.getVisibility(AtlasConstants.DASHBOARD);}set;}
        public boolean isVisibleDataUsage{get{return AtlasUtility.getVisibility(AtlasConstants.DATA_USAGE);}set;}
        public boolean isVisibleViewUsage{get{return AtlasUtility.getVisibility(AtlasConstants.VIEW_USAGE);}set;}
        public boolean isVisibleBuyMore{get{return AtlasUtility.getVisibility(AtlasConstants.BUY_MORE);}set;}
        public boolean isVisibleBillPayment{get{return AtlasUtility.getVisibility(AtlasConstants.BILL_PAYMENT);}set;}
        public boolean isVisibleViewCurrentBill{get{return AtlasUtility.getVisibility(AtlasConstants.VIEW_CURRENT_BILL);}set;}
        public boolean isVisibleBillingHistory{get{return AtlasUtility.getVisibility(AtlasConstants.BILLING_HISTORY);}set;}
        public boolean isVisibleUpadePayment{get{return AtlasUtility.getVisibility(AtlasConstants.UPDATE_PAYMENT);}set;}
        public boolean isVisibleMakeOneTimePay{get{return AtlasUtility.getVisibility(AtlasConstants.MAKE_ONE_TIME_PAY);}set;}
        public boolean isVisibleMyAccount{get{return AtlasUtility.getVisibility(AtlasConstants.MY_ACCOUNT);}set;}
        public boolean isVisibleCustomer{get{return AtlasUtility.getVisibility(AtlasConstants.CUSTOMER);}set;}
        //public boolean isVisibleManageEmail{get{return AtlasUtility.getVisibility(AtlasConstants.MANAGE_EMAIL);}set;}
        public boolean isVisibleOnlineCommunity{get{return AtlasUtility.getVisibility(AtlasConstants.ONLINE_COMMUNITY);}set;}  
        public boolean isVisibleBlog{get{return AtlasUtility.getVisibility(AtlasConstants.BLOG);}set;}  
        public boolean isVisibleForum{get{return AtlasUtility.getVisibility(AtlasConstants.FORUM);}set;} 
        public boolean isVisibleKnowledgeBase{get{return AtlasUtility.getVisibility(AtlasConstants.KNOWLEDGE_BASE);}set;}  
        public boolean isVisiblefacebook{get{return AtlasUtility.getVisibility(AtlasConstants.FACEBOOK);}set;}
        public boolean isVisibletwitter{get{return AtlasUtility.getVisibility(AtlasConstants.TWITTER);}set;}
        public boolean isVisibleYouTube{get{return AtlasUtility.getVisibility(AtlasConstants.YOUTUBE);}set;}
        public boolean isVisibleGooglePlus{get{return AtlasUtility.getVisibility(AtlasConstants.GOOGLE_PLUS);}set;}
        public boolean isVisibleSignOut{get{return AtlasUtility.getVisibility(AtlasConstants.SIGNOUT);}set;}
        public boolean isVisibleChangePlan{get{return AtlasUtility.getVisibility(AtlasConstants.strCHANGE_PLAN);}set;}
        public boolean isVisibleManageEmail{get{return AtlasUtility.getVisibility(AtlasConstants.MANAGE_EMAIL);}set;}
        
        public string vacationPlanList{get{return AtlasUtility.getMapValue(Atlasconstants.AtlasCPlanVacationList);}set;} 
        
        public string exedeVoice{get{return AtlasUtility.getMapValue(Atlasconstants.AtlasExedeVoice);}set;} 
        public string activateVoipText{get{return AtlasUtility.getMapValue(Atlasconstants.AtlasActivateVoip);}set;} 
        public string manageVoipText{get{return AtlasUtility.getMapValue(Atlasconstants.AtlasManageVoip);}set;} 
    /**
    * @author Raghuprasad Halakere
    * @description - Zero paramter AtlasMobileController constructor 
    * @input param  - null
    * @return null 
    */
        public AtlasMobileController(){
        
        } 
}