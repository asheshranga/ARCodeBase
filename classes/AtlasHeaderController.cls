/*********************************************************************************
Name         : AtlasHeaderController
Created By   : Raghuprasad Halakere
Modified BY  : Raghuprasad Halakere
Company Name : NTT Data
Project      : ViaSat Atlas, Bangalore
Created Date : 20 October 2013
Modified Date: 13 November 2013
Usages       : Controller for VisualForce PageComponent: AtlasHeaderComponent
*********************************************************************************/
public with sharing class AtlasHeaderController{
    
        // Variable to Initialize Account Name    
        public string strAccountName{get;set;}
        // Initializing the MainDTO object  
        public AtlasMainDTO mainDTO{get;set;}
        // Initializing the AccountDTO object  
        public AtlasAccountDTO  accountDTO{get;set;}          
        public  AtlasCurrentDataUsageDTO cudDTO{get;set;} 
        // Intializing GlobalVariables for HyperLinkURL
        public string strSignOutURL{get{return AtlasUtility.getURL(AtlasConstants.SIGNOUT);}set;}
        public string strEmailInboxURL{get{return AtlasUtility.getURL(AtlasConstants.EMAIL_INBOX);}set;}
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
        public String strChangePlanUrl{get{return AtlasUtility.getURL(AtlasConstants.strCHANGE_PLAN);}set;}      
        
        //Intializing Global Variables for HyperLinkText
        public string strSignOutText{get{return AtlasUtility.getHyperLinkText(AtlasConstants.SIGNOUT);}set;}
        public string strEmailInboxText{get{return AtlasUtility.getHyperLinkText(AtlasConstants.EMAIL_INBOX);}set;}
        public string strDashboardText{get{return AtlasUtility.getHyperLinkText(AtlasConstants.DASHBOARD);}set;}
        public string strDataUsageText{get{return AtlasUtility.getHyperLinkText(AtlasConstants.DATA_USAGE);}set;}
        public string strViewUsageText{get{return AtlasUtility.getHyperLinkText(AtlasConstants.VIEW_USAGE);}set;}
        public string strBuyMoreText{get{return AtlasUtility.getHyperLinkText(AtlasConstants.BUY_MORE);}set;}
        public string strBillPaymentText{get{return AtlasUtility.getHyperLinkText(AtlasConstants.BILL_PAYMENT);}set;}
        public string strViewCurrentBillText{get{return AtlasUtility.getHyperLinkText(AtlasConstants.VIEW_CURRENT_BILL_HEADER);}set;}
        public string strBillingHistoryText{get{return AtlasUtility.getHyperLinkText(AtlasConstants.BILLING_HISTORY);}set;}
        public string strUpadePaymentText{get{return AtlasUtility.getHyperLinkText(AtlasConstants.UPDATE_PAYMENT);}set;}
        public string strMakeOneTimePayText{get{return AtlasUtility.getHyperLinkText(AtlasConstants.MAKE_ONE_TIME_PAY);}set;}
        public string strMyAccountText{get{return AtlasUtility.getHyperLinkText(AtlasConstants.MY_ACCOUNT);}set;}
        public string strCustomerText{get{return AtlasUtility.getHyperLinkText(AtlasConstants.CUSTOMER);}set;}
        public string strManageEmailText{get{return AtlasUtility.getHyperLinkText(AtlasConstants.MANAGE_EMAIL_ACCOUNT);}set;}
        public string strManageEmailLabel{get{return AtlasUtility.getHyperLinkText(AtlasConstants.MANAGE_EMAIL);}set;}
        public string strChangePlan{get{return AtlasUtility.getHyperLinkText(AtlasConstants.strCHANGE_PLAN);}set;} 
        public String strMoving{get{return AtlasUtility.getURL(AtlasConstants.Moving);}set;}
        public string vacationPlanList{get{return AtlasUtility.getMapValue(Atlasconstants.AtlasCPlanVacationList);}set;} 
        
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
        public boolean isVisibleManageEmail{get{return AtlasUtility.getVisibility(AtlasConstants.MANAGE_EMAIL);}set;}
        public boolean isVisibleChangePlan{get{return AtlasUtility.getVisibility(AtlasConstants.strCHANGE_PLAN);}set;}
        // class variables for Active Dropdown
        public string strDashboard{get;set;}
        public string strUsage{get;set;}
        public string strBillPayment{get;set;}
        public string strAccountInfo{get;set;}
        public string strVoice{get;set;}
        public string styleBlueOrange{get;set;}     
        public String bottomBorderColor{get;set;}
        public String borderleftOrRightcolor{get;set;}
        public String borderRightcolor{get;set;}
        public boolean bnExede{get;set;}
        public boolean bnWildblue{get;set;}
        // Variables used to navigate from one to another page
        public string str{get;set;}            
        public string strViewstate{get;set;}
        public transient user objUser{get;set;}       
        public string strACCType{get{return accountDTO.strAccountType;}set;}
        // Variable used in ChangeColorOnMouseover method    
        public String backGroundColor{get;set;} 
        //to get check my email url and text
        public string checkMyEmailText{get{ return AtlasUtility.getHyperLinkText('Check My Email');}set;}
        public string checkMyEmailURL{get{return AtlasUtility.getURL('Check My Email');}set;}
        
        // Variables used in WISP
        public string highSpeedInternet{get{return AtlasUtility.getMapWispValue(Atlasconstants.Wisp_Header_Text);}set;}
        public string wispSignout{get{return AtlasUtility.getWispURL(Atlasconstants.Wisp_SIGNOUT);}set;}
        public boolean isCTIAdmin{get;set;}
        public boolean isResellerAdmin{get;set;}
        
        // Variables used for Exede Voice
        public String activateVoipLink{get{return AtlasUtility.getURL(AtlasConstants.AtlasActivateVoipLink);}set;}
        public String manageVoipLink{get{return AtlasUtility.getURL(AtlasConstants.AtlasManageVoipLink);}set;}
        public string exedeVoice{get{return AtlasUtility.getMapValue(Atlasconstants.AtlasExedeVoice);}set;} 
        public string activateVoipText{get{return AtlasUtility.getMapValue(Atlasconstants.AtlasActivateVoip);}set;} 
        public string manageVoipText{get{return AtlasUtility.getMapValue(Atlasconstants.AtlasManageVoip);}set;}
        
    /**
    * @author Raghuprasad Halakere
    * @description - zero parameter AtlasHeaderController constructor
    * @input param  - null
    * @return null
    */
    public AtlasHeaderController(){
        isCTIAdmin=false;
        isResellerAdmin=false;
        backGroundColor=AtlasConstants.STYLE_ORANGE;
        id userid=userinfo.getUserId();
        bnExede=false;
        bnWildblue=false;       
        objUser=new user();
        
        objUser=AtlasDataDispatcher.getUserDetails();
         if(objUser.CommunityUserAccountType__c== null||objUser.CommunityUserAccountType__c==AtlasConstants.BLACK_SPACE||objUser.CommunityUserAccountType__c==AtlasConstants.STR_EXEDE)
         {  
             styleBlueOrange=AtlasConstants.STYLE_ORANGE;
             bottomBorderColor=AtlasConstants.ExedeBottomBorderColor;
             borderleftOrRightcolor=AtlasConstants.ExedeborderleftOrRightcolor;
             borderRightcolor = AtlasConstants.ExedeborderRightcolor;
             bnExede=true;
         }
         else if(objUser.CommunityUserAccountType__c!= null&&objUser.CommunityUserAccountType__c!=AtlasConstants.BLACK_SPACE&&objUser.CommunityUserAccountType__c==AtlasConstants.STR_WILDBLUE)
         {
             styleBlueOrange=AtlasConstants.STYLE_BLUE;
             bottomBorderColor=AtlasConstants.WildBlueBottomBorderColor;
             borderleftOrRightcolor=AtlasConstants.WildBlueborderleftOrRightcolor;
             bnWildblue=true;
         }
        searchAndVisible();
        if(ApexPages.currentPage().getUrl().contains(AtlasConstants.STRDASHBOARD)){
             strDashboard=AtlasConstants.ACTIVE;
             strUsage=AtlasConstants.DROPDOWN;
             strBillPayment=AtlasConstants.DROPDOWN;
             strAccountInfo=AtlasConstants.DROPDOWN;
             strVoice=AtlasConstants.DROPDOWN;
        } 
        /* To determine whether the logged in user is an Internal User */       
        system.debug('###UserInfo--> '+UserInfo.getUserType()); 
        if(UserInfo.getUserType()=='Standard')
            isCTIAdmin=true; 

        /* To determine whether the logged in user is an Reseller Admin */
        WispKeyValueStore__c WispKVS;
        if(!Test.isRunningTest()){
            WispKVS = WispKeyValueStore__c.getValues('WISP Admin Community Profile');
            String resellerProfile = WispKVS.Value__c;
            isResellerAdmin = resellerProfile.contains(UserInfo.getProfileId().left(15));
        }
    }
    /**
    * @author Raghuprasad Halakere
    * @description - searchAndVisible for Header Component
    * @input param  - null
    * @return void
    */
     public void searchAndVisible(){
        
        if(ApexPages.currentPage().getUrl().contains(AtlasConstants.STRDASHBOARD)){
             strDashboard=AtlasConstants.ACTIVE;
             strUsage=AtlasConstants.DROPDOWN;
             strBillPayment=AtlasConstants.DROPDOWN;
             strAccountInfo=AtlasConstants.DROPDOWN;
             strVoice=AtlasConstants.DROPDOWN;
        } if(ApexPages.currentPage().getUrl().contains(AtlasConstants.STRUSAGE)){
             strDashboard=AtlasConstants.BLACK_SPACE;
             strUsage=AtlasConstants.ACTIVE_DROPDOWN;
             strBillPayment=AtlasConstants.DROPDOWN;
             strAccountInfo=AtlasConstants.DROPDOWN;
             strVoice=AtlasConstants.DROPDOWN;
        } if(ApexPages.currentPage().getUrl().contains(AtlasConstants.STRCURRENTBILL)
            ||ApexPages.currentPage().getUrl().contains(AtlasConstants.STRBILLING_HISTORY)
            ||ApexPages.currentPage().getUrl().contains(AtlasConstants.STRPAYMENT_SETTINGS)){
             strDashboard=AtlasConstants.BLACK_SPACE;
             strUsage=AtlasConstants.DROPDOWN;
             strBillPayment=AtlasConstants.ACTIVE_DROPDOWN;
             strAccountInfo=AtlasConstants.DROPDOWN;
             strVoice=AtlasConstants.DROPDOWN;
        } if(ApexPages.currentPage().getUrl().contains(AtlasConstants.STRCUSTOMER_INFO)
             ||ApexPages.currentPage().getUrl().contains(AtlasConstants.CHANGEPLAN)
             ||ApexPages.currentPage().getUrl().contains('moving')){
             strDashboard=AtlasConstants.BLACK_SPACE;
             strUsage=AtlasConstants.DROPDOWN;
             strBillPayment=AtlasConstants.DROPDOWN;
             strAccountInfo=AtlasConstants.ACTIVE_DROPDOWN;
             strVoice=AtlasConstants.DROPDOWN;
        } 
       
    }     
    /**
    * @author Raghuprasad Halakere
    * @description - ChangeColorOnMouseover for Header Component
    * @input param  - null
    * @return void
    */
    public void ChangeColorOnMouseover(){
         if(objUser.CommunityUserAccountType__c!=null&&objUser.CommunityUserAccountType__c!=AtlasConstants.BLACK_SPACE&&objUser.CommunityUserAccountType__c==AtlasConstants.STR_EXEDE)
         {  
             backGroundColor=AtlasConstants.STYLE_ORANGE;
         }
         else if(objUser.CommunityUserAccountType__c!=null&&objUser.CommunityUserAccountType__c!=AtlasConstants.BLACK_SPACE&&objUser.CommunityUserAccountType__c==AtlasConstants.STR_WILDBLUE)
         {
            backGroundColor=AtlasConstants.STYLE_BLUE;
         }
    } 
    /**
    * @author Raghuprasad Halakere
    * @description - redirectToUsagePage for Header Component
    * @input param  - null
    * @return PageReference
    */     
    public PageReference redirectToUsagePage()
    {
        pagereference page=new pagereference(strViewUsageURL);
        page.setRedirect(true);
        return page;
    }
    /**
    * @author Raghuprasad Halakere
    * @description - redirectTodashBoardPage for Header Component
    * @input param  - null
    * @return PageReference
    */ 
    public PageReference redirectTodashBoardPage()
    {
        pagereference page=new pagereference(strDashboardURL);
        page.setRedirect(true);
        return page;
    }
    /**
    * @author Raghuprasad Halakere
    * @description - redirectToBuyMorePage for Header Component
    * @input param  - null
    * @return PageReference
    */
    public PageReference redirectToBuyMorePage()
    {
        pagereference page=new pagereference(strBuyMoreURL);
        page.setRedirect(true);
        return page;
    }
    /**
    * @author Raghuprasad Halakere
    * @description - redirectToCurrentBillPage for Header Component
    * @input param  - null
    * @return PageReference
    */
    public PageReference redirectToCurrentBillPage()
    {
        pagereference page=new pagereference(strViewCurrentBillURL);
        page.setRedirect(true);
        return page;
    }
    /**
    * @author Raghuprasad Halakere
    * @description - redirectToBillingHistoryPage for Header Component
    * @input param  - null
    * @return PageReference
    */ 
    public PageReference redirectToBillingHistoryPage()
    {
        pagereference page=new pagereference(strBillingHistoryURL);
        page.setRedirect(true);
        return page;
    }
    /**
    * @author Raghuprasad Halakere
    * @description - redirectToUpdatePaymentPage for Header Component
    * @input param  - null
    * @return PageReference
    */  
    public PageReference redirectToUpdatePaymentPage()
    {
        pagereference page=new pagereference(strUpadePaymentURL);
        page.setRedirect(true);
        return page;
    }
    /**
    * @author Raghuprasad Halakere
    * @description - redirectToMakeOneTimePayPage for Header Component
    * @input param  - null
    * @return PageReference
    */
    public PageReference redirectToMakeOneTimePayPage()
    {
        pagereference page=new pagereference(strMakeOneTimePayURL);
        page.setRedirect(true);
        return page;
    }
    /**
    * @author Raghuprasad Halakere
    * @description - redirectToCustomerInfoPage for Header Component
    * @input param  - null
    * @return PageReference
    */
    public PageReference redirectToCustomerInfoPage()
    {
        pagereference page=new pagereference(strCustomerURL);
        page.setRedirect(true);
        return page;
    }
    /**
    * @author Raghuprasad Halakere
    * @description - redirectToChangePlanPage for Header Component
    * @input param  - null
    * @return PageReference
    */
    public PageReference redirectToChangePlanPage()
    {
        pagereference page=new pagereference(strChangePlanUrl);
        page.setRedirect(true);
        return page;
    } 
    public PageReference redirectToMyEmail()
    {
        pagereference page=new pagereference(checkMyEmailURL);
        page.setRedirect(true);
        return page;
    }            
}