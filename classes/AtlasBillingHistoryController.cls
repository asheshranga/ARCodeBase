/*********************************************************************************
Name         : AtlasBillingHistoryController
Created By   : Raghuprasad Halakere
Modified BY  : Raghuprasad Halakere
Company Name : NTT Data
Project      : ViaSat Atlas, Bangalore
Created Date : 22 October 2013
Modified Date: 13 November 2013
Usages       : Controller for VisualForce Page: billingHistory
*********************************************************************************/
global with sharing class AtlasBillingHistoryController extends AtlasDataManager{
    
    // Initializing Billing History Page GlobalVariables HyperLinkURL 
    public String strCurrentBillUrl{get{return AtlasUtility.getURL(AtlasConstants.CURRENT_BILL);}set;}
    public String strPaymentSettingsUrl{get{return AtlasUtility.getURL(AtlasConstants.PAYMENT_SETTINGS);}set;}
    public String strBillingHistory{get{return AtlasUtility.getURL(AtlasConstants.BILLING_HISTORY);}set;}
    public String strDashboardUrl{get{return AtlasUtility.getURL(AtlasConstants.DASHBOARD);}set;}  
    public String strCurrentBill{get{return AtlasUtility.getURL(AtlasConstants.CURRENT_BILL);}set;}
    public String strViewFSecureInformationURL{get{return AtlasUtility.getURL(AtlasConstants.VIEW_F_SECURE_INFORMATION);}set;}
    // Initializing Billing History Page GlobalVariables HyperLinkText
    public String strCurrentBillText{get{return AtlasUtility.getHyperLinkText(AtlasConstants.CURRENT_BILL);}set;}
    public String strPaymentSettingsText{get{return AtlasUtility.getHyperLinkText(AtlasConstants.PAYMENT_SETTINGS);}set;}
    public String strBillingHistoryText{get{return AtlasUtility.getHyperLinkText(AtlasConstants.BILLING_HISTORY);}set;}
    public String strDashboardText{get{return AtlasUtility.getHyperLinkText(AtlasConstants.DASHBOARD);}set;}
    public String strViewFSecureInformationText{get{return AtlasUtility.getHyperLinkText(AtlasConstants.VIEW_F_SECURE_INFORMATION);}set;}
    public String strInvoiceNumberText{get{return AtlasConstants.INVOICE_NUMBER_TEXT;}set;}
    // Initializing Billing History Page GlobalVariables Visibility
    public boolean isVisibleCurrentBill{get{return AtlasUtility.getVisibility(AtlasConstants.CURRENT_BILL);}set;}
    public boolean isVisiblePaymentSettings{get{return AtlasUtility.getVisibility(AtlasConstants.PAYMENT_SETTINGS);}set;}
    public boolean isVisibleBillingHistory{get{return AtlasUtility.getVisibility(AtlasConstants.BILLING_HISTORY);}set;}
    public boolean isVisibleDashboard{get{return AtlasUtility.getVisibility(AtlasConstants.DASHBOARD);}set;}
    public boolean isVisibleViewFSecureInformation{get{return AtlasUtility.getVisibility(AtlasConstants.EXEDE_VOICE);}set;}
    public boolean isVisibleDashBoardURL{get{return AtlasUtility.getVisibility(AtlasConstants.DASHBOARD);}set;}
    //Variable in BillingHistory.page
    public String strTitle{get{return AtlasUtility.getMapValue(AtlasConstants.STRTitle_BillingHistory);}set;}
    public String BillingOverviewLabel{get{return AtlasConstants.BillingOverviewLabel;}set;}
    public String AccountNameLabel{get{return AtlasConstants.AccountNameLabel;}set;}
    public String AccountNumberLabel{get{return AtlasConstants.AccountNumberLabel;}set;}
    public string styleBlueOrange{get;set;}     
    public String bottomBorderColor{get;set;}
    public String borderleftOrRightcolor{get;set;}
    public boolean bnExede{get;set;}
    public boolean bnWildblue{get;set;}
    // Variables used in CurrentBill.page
    public String strTitle2{get{return AtlasConstants.STRTitle_CurrentBill;}set;}
    public String strHeader2{get{return AtlasConstants.STRHEADER2_CurrentBill;}set;}
    public string StrCity{get;set;}
    public string strUpdateState{get;set;}
    public String BillingAdrsText{get{return AtlasConstants.BillingAdrsText;}set;}
    public String ServiceAdrsText{get{return AtlasConstants.ServiceAdrsText;}set;}
    public String AccountNumberText{get{return AtlasConstants.AccountNumberText;}set;}
    public String DueDateText{get{return AtlasConstants.DueDateText;}set;}
    public String AmountText{get{return AtlasConstants.AmountText;}set;}
    // Create a variable to hold the selected Invoice number
    public String invoiceReference{get;set;}
    public static String printInvoiceReference{get;set;}
    // Create a variable to store the selected invoice detail
    Public AtlasCurrentBillDTO selectedBillData{get;set;}
    Public static AtlasCurrentBillDTO printInvoiceBillDTOObj{get;set;}
    public string pageName{get{return AtlasConstants.STRBILLING_HISTORY;}set;}
    public Boolean showDisclaimerText2{get{if(AtlasUtility.getMapValue(AtlasConstants.SHOW_DISCLAIMER_2).equalsIgnoreCase('false')) {return false;} else {return true;}}set;}
    
        public string subFooterText1 { get {
            return AtlasUtility.getMapValue(AtlasConstants.Atlas_Current_Bill_SubFooter_Msg1);
        }
            private set;
        }
        public string exedeCustomerSupportUrl { get {
            return AtlasUtility.getUrl(AtlasConstants.EXEDE_CUSTOMER_SUPPORT_URL);
        }
            private set;
        }
        public string exedeCustomerSupportHyperlinkText { get {
            return AtlasUtility.getHyperLinkText(AtlasConstants.EXEDE_CUSTOMER_SUPPORT_URL);
        }
            private set;
        }
        public string subFooterText2 { get {
            return AtlasUtility.getMapValue(AtlasConstants.Atlas_Current_Bill_SubFooter_Msg2);
        }
            private set;
        }
            
      /**
        * @author Raghuprasad Halakere 
        * @description - zero parameter AtlasBillingHistoryController constructor
        * @param object null
        * @return void
        */  
    public AtlasBillingHistoryController()
    {   
        Apexpages.currentPage().getHeaders().put(AtlasConstants.X_UA_COMPATIBLE,AtlasConstants.IE_8);
        id userid=userinfo.getUserId();
        bnExede=false;
        bnWildblue=false;       
        User objUser=new user();
        objUser=[Select CommunityUserAccountType__c from user where id=:userid];
        if(objUser.CommunityUserAccountType__c==null||objUser.CommunityUserAccountType__c==AtlasConstants.STR_EXEDE) //(objUser.CommunityUserAccountType__c!=null&&objUser.CommunityUserAccountType__c!=AtlasConstants.BLACK_SPACE&&objUser.CommunityUserAccountType__c==AtlasConstants.STR_EXEDE)
        {  
            styleBlueOrange=AtlasConstants.STYLE_ORANGE;
            bottomBorderColor=AtlasConstants.ExedeBottomBorderColor;
            borderleftOrRightcolor=AtlasConstants.ExedeborderleftOrRightcolor;
            bnExede=true;
        }
        else if(objUser.CommunityUserAccountType__c!=null&&objUser.CommunityUserAccountType__c!=AtlasConstants.BLACK_SPACE&&objUser.CommunityUserAccountType__c==AtlasConstants.STR_WILDBLUE)
        {
            styleBlueOrange =AtlasConstants.STYLE_BLUE;
            bottomBorderColor = AtlasConstants.WildBlueBottomBorderColor;
            borderleftOrRightcolor = AtlasConstants.WildBlueborderleftOrRightcolor;
            bnWildblue=true;
        }
        //populateBillingHistory();            
    }    
      /**
        * @author Raghuprasad Halakere 
        * @description - loadBillingHistory for AtlasBillingHistoryController 
        * @param object null
        * @return void
        */ 
    public PageReference loadBillingHistory()
    {                             
        return null;
    }
      /**
        * @author Raghuprasad Halakere 
        * @description - calls populateBillingHistory method for billinghistory page
        * @param object null
        * @return void
        */   
    public  void callRemoteAtlasDashboardData()
    {
        
        populateBillingHistory();
        
    }
      /**
        * @author Raghuprasad Halakere 
        * @description - calls getCurrentDataUsageDashBoradData method for billinghistory page
        * @param object null
        * @return void
        */   
    public  void currentDataUsageAtlasDashboardData()
    {
        
        getCurrentDataUsageDashBoradData();
        
    }
      /**
        * @author Raghuprasad Halakere 
        * @description - calls getMyAccountDashBoardData method for billinghistory page
        * @param object null
        * @return void
        */ 
    public  void myAccountAtlasDashboardData()
    {
        
        getMyAccountDashBoardData();
        
    }
      /**
        * @author Raghuprasad Halakere 
        * @description - calls getBillingSnapShotDashBoardDAta method for billinghistory page
        * @param object null
        * @return void
        */ 
    public  void billingSnapshotAtlasDashboardData()
    {
        
        getBillingSnapShotDashBoardDAta();
        
    }
      /**
        * @author Raghuprasad Halakere 
        * @description - calls populateBillingHistory method for billinghistory page
        * @param object null
        * @return void
        */
    public  void billingHistoryData()
    {
        populateBillingHistory();
    }
    
}