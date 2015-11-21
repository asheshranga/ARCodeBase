/*********************************************************************************
Name         : AtlasFooterController
Created By   : Raghuprasad Halakere 
Modified BY  : Raghuprasad Halakere
Company Name : NTT Data
Project      : ViaSat Atlas, Bangalore
Created Date : 20 October 2013
Modified Date: 13 November 2013
Usages       : Controller for VisualForce PageComponent: Atlas_Footer_Component
*********************************************************************************/
public with sharing class AtlasFooterController{
        
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
        public string strBlogURL{get{return AtlasUtility.getURL(AtlasConstants.BLOG);}set;}
        public string strOnlineCommURL{get{return AtlasUtility.getURL(AtlasConstants.ONLINE_COMMUNITY);}set;}
        public string strKnowBaseURL{get{return AtlasUtility.getURL(AtlasConstants.KNOWLEDGE_BASE);}set;}
        public string strFacebookURL{get{return AtlasUtility.getURL(AtlasConstants.FACEBOOK);}set;}
        public string strTwitterURL{get{return AtlasUtility.getURL(AtlasConstants.TWITTER);}set;}
        public string strYoutubeURL{get{return AtlasUtility.getURL(AtlasConstants.YOUTUBE);}set;}
        public string strGoogleURL{get{return AtlasUtility.getURL(AtlasConstants.GOOGLE_PLUS);}set;}
        public string strCommunityURL{get{return AtlasUtility.getURL(AtlasConstants.COMMUNITY);}set;}
        public String strChatURL{get{return AtlasUtility.getURL(AtlasConstants.CHAT);}set;}
        public String strPhoneURL{get{return AtlasUtility.getURL(AtlasConstants.PHONE);}set;}
        public String strEmailURL{get{return AtlasUtility.getURL(AtlasConstants.EMAIL);}set;}    
        //Intializing Global Variables for HyperLinkText
        public string strSignOutText{get{return AtlasUtility.getHyperLinkText(AtlasConstants.SIGNOUT);}set;}
        public string strEmailInboxText{get{return AtlasUtility.getHyperLinkText(AtlasConstants.EMAIL_INBOX);}set;}
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
        public String strChatText{get{return AtlasUtility.getHyperLinkText(AtlasConstants.CHAT);}set;}
        public String strPhoneText{get{return AtlasUtility.getHyperLinkText(AtlasConstants.PHONE);}set;}
        public String strEmailText{get{return AtlasUtility.getHyperLinkText(AtlasConstants.EMAIL);}set;}
        public string strCommunityText{get{return AtlasUtility.getHyperLinkText(AtlasConstants.COMMUNITY);}set;}
        public string strBlogText{get{return AtlasUtility.getHyperLinkText(AtlasConstants.BLOG);}set;}
        public string strOnlineCommText{get{return AtlasUtility.getHyperLinkText(AtlasConstants.ONLINE_COMMUNITY);}set;}
        public string strKnowBaseText{get{return AtlasUtility.getHyperLinkText(AtlasConstants.KNOWLEDGE_BASE);}set;}        
        public string strFacebookText{get{return AtlasUtility.getHyperLinkText(AtlasConstants.FACEBOOK);}set;}
        public string strTwitterText{get{return AtlasUtility.getHyperLinkText(AtlasConstants.TWITTER);}set;}
        public string strYoutubeText{get{return AtlasUtility.getHyperLinkText(AtlasConstants.YOUTUBE);}set;}
        public string strGoogleText{get{return AtlasUtility.getHyperLinkText(AtlasConstants.GOOGLE_PLUS);}set;}
        //Intializing Global Variables for IsVisibility
        public boolean isVisibleSignOut{get{return AtlasUtility.getVisibility(AtlasConstants.SIGNOUT);}set;}
        public boolean isVisibleEmailInbox{get{return AtlasUtility.getVisibility(AtlasConstants.EMAIL_INBOX);}set;}
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
        public boolean isVisibleCommunity{get{return AtlasUtility.getVisibility(AtlasConstants.COMMUNITY);}set;}
        public boolean isVisibleBlog{get{return AtlasUtility.getVisibility(AtlasConstants.BLOG);}set;}
        public boolean isVisibleOnlineComm{get{return AtlasUtility.getVisibility(AtlasConstants.ONLINE_COMMUNITY);}set;}
        public boolean isVisibleKnowBase{get{return AtlasUtility.getVisibility(AtlasConstants.KNOWLEDGE_BASE);}set;}
        public boolean isVisibleFacebook{get{return AtlasUtility.getVisibility(AtlasConstants.FACEBOOK);}set;}
        public boolean isVisibleTwitter{get{return AtlasUtility.getVisibility(AtlasConstants.TWITTER);}set;}
        public boolean isVisibleYoutube{get{return AtlasUtility.getVisibility(AtlasConstants.YOUTUBE);}set;}
        public Boolean showDisclaimerText{get{if(AtlasUtility.getMapValue(AtlasConstants.SHOW_DISCLAIMER_1).equalsIgnoreCase('false')) {return false;} else {return true;}}set;}
        public Boolean isVisibleGoogle{get{return AtlasUtility.getVisibility(AtlasConstants.GOOGLE_PLUS);}set;}          
        public Boolean isChatVisible{get{return AtlasUtility.getVisibility(AtlasConstants.CHAT);}set;}
        public Boolean isPhoneVisible{get{return AtlasUtility.getVisibility(AtlasConstants.PHONE);}set;}
        public Boolean isEmailVisible{get{return AtlasUtility.getVisibility(AtlasConstants.EMAIL);}set;}
        public String customerCareLabel{get{return AtlasUtility.getHyperLinkText(AtlasConstants.customerCareNumberLabel);}set;}
        public Boolean showDisclaimerText1{get{if(AtlasUtility.getMapValue(AtlasConstants.SHOW_DISCLAIMER_1).equalsIgnoreCase('false')) {return false;} else {return true;}}set;}        
        public string KnowledgeBaseLabel{get{return AtlasUtility.getMapValue(AtlasConstants.STRHEADER3_AtlasKnowledgeBase);}set;}
        
        // Variable for Copy Right year
        public Integer currYear {get{return Date.Today().Year();}set;}
        public String strCopyRightYear {get{return AtlasUtility.getMapValue(AtlasConstants.CopyRightYear);}set;}
        public String LegalDocumnetsText {get{return AtlasUtility.getMapValue(AtlasConstants.Footer_Legal_Documents_Text);}set;}
        public String LegalDocumnetsURL {get{return AtlasUtility.getURL(AtlasConstants.Atlas_Legal_Documents_URL);}set;}
        public String FooterDisclaimerText {get{ return  AtlasUtility.getMapValue(AtlasConstants.FooterDisclaimerText_a) + ' ' 
                                                         +AtlasUtility.getMapValue(AtlasConstants.FooterDisclaimerText_b) + ' '
                                                         +AtlasUtility.getMapValue(AtlasConstants.FooterDisclaimerText_c) + ' '
                                                         +AtlasUtility.getMapValue(AtlasConstants.FooterDisclaimerText_d) + ' '
                                                         +AtlasUtility.getMapValue(AtlasConstants.FooterDisclaimerText_e);}set;} 
                                                         
        // Variables used in WISP
        public string privacyPolicy{get{return AtlasUtility.getMapWispValue(Atlasconstants.Wisp_PrivacyPolicy);}set;}
        public string copyright{get{return AtlasUtility.getMapWispValue(Atlasconstants.Wisp_copyright);}set;}
        public string wispPrivacyPolicy{get{return AtlasUtility.getWispURL(AtlasConstants.WispPrivacyPolicy);}set;}
                                
    /**
    * @author Raghuprasad Halakere
    * @description - Zero paramter AtlasFooterController constructor 
    * @input param  - null
    * @return null 
    */
        public AtlasFooterController(){

        }
  
}