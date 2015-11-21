/*********************************************************************************
Name         : AtlasCurrentBillController
Created By   : Shiva Shankar N 
Modified BY  : 
Company Name : NTT Data
Project      : ViaSat Atlas, Bangalore
Created Date : 19 October2013
Modified Date: 13 November 2013
Usages       : Controller for VisualForce Page : currentbill
*********************************************************************************/
public with sharing class AtlasCurrentBillController extends AtlasDataManager{
        
        // Initialinzing Usage page GlobalVariables HyperLinkURLs
        public string strBillPaymentURL{get{return AtlasUtility.getURL(AtlasConstants.PAYMENT_SETTINGS);}set;} 
        public string strViewCurrentBillURL{get{return AtlasUtility.getURL(AtlasConstants.CURRENT_BILL);}set;}
        public string strBillingHistoryURL{get{return AtlasUtility.getURL(AtlasConstants.BILLING_HISTORY);}set;}
        public string strVoicePkgCharge{get{return AtlasUtility.getURL(AtlasConstants.BILL_PAYMENT);}set;}
        public String strDetailsURL{get{return AtlasUtility.getURL(AtlasConstants.DETAILS);}set;}
        public String strNoThanksURL{get{return AtlasUtility.getURL(AtlasConstants.NO_THANKS);}set;}
        public String strConfirmURL{get{return AtlasUtility.getURL(AtlasConstants.CONFIRM);}set;}
        public String strDashboardUrl{get{return AtlasUtility.getURL(AtlasConstants.DASHBOARD);}set;}
        
        // Initialinzing Usage page GlobalVariables HyperLinkText 
        public string strBillPaymentText{get{return AtlasUtility.getHyperLinkText(AtlasConstants.PAYMENT_SETTINGS);}set;}
        public string strViewCurrentBillText{get{return AtlasUtility.getHyperLinkText(AtlasConstants.CURRENT_BILL);}set;}
        public string strBillingHistoryText{get{return AtlasUtility.getHyperLinkText(AtlasConstants.BILLING_HISTORY);}set;}
        public String strDetailsText{get{return AtlasUtility.getHyperLinkText(AtlasConstants.DETAILS);}set;}
        public String strNoThanksText{get{return AtlasUtility.getHyperLinkText(AtlasConstants.NO_THANKS);}set;}
        public String strConfirmText{get{return AtlasUtility.getHyperLinkText(AtlasConstants.CONFIRM);}set;}
        public string strDashboardText{get{return AtlasUtility.getHyperLinkText(AtlasConstants.DASHBOARD);}set;}
        
        // Initialinzing Usage page GlobalVariables HyperLinkVisibility    
        public boolean isVisibleBillPayment{get{return AtlasUtility.getVisibility(AtlasConstants.BILL_PAYMENT);}set;} 
        public boolean isVisibleViewCurrentBill{get{return AtlasUtility.getVisibility(AtlasConstants.CURRENT_BILL);}set;}
        public boolean isVisibleBillingHistory{get{return AtlasUtility.getVisibility(AtlasConstants.BILLING_HISTORY);}set;}
        public boolean isVisibleDetails{get{return AtlasUtility.getVisibility(AtlasConstants.DETAILS);}set;}
        public boolean isVisibleNoThanks{get{return AtlasUtility.getVisibility(AtlasConstants.NO_THANKS);}set;}
        public boolean isVisibleConfirm{get{return AtlasUtility.getVisibility(AtlasConstants.CONFIRM);}set;}
        public boolean isVisibleDashboard{get{return AtlasUtility.getVisibility(AtlasConstants.DASHBOARD);}set;}            
        
        // Variables used in CurrentBill.page
        public String strTitle{get{return AtlasUtility.getMapValue(AtlasConstants.STRTitle_CurrentBill);}set;}
        public String strHeader2{get{return AtlasConstants.STRHEADER2_CurrentBill;}set;}
        public string StrCity{get;set;}
        public string strUpdateState{get;set;}

        public String BillingAdrsText{get{return AtlasConstants.BillingAdrsText;} set;}
        public String ServiceAdrsText{get{return AtlasConstants.ServiceAdrsText;} set;}        
        public String AccountNumberText{get{return AtlasConstants.AccountNumberText;}set;}
        public String DueDateText{get{return AtlasConstants.DueDateText;}set;}
        public String AmountText{get{return AtlasConstants.AmountText;}set;}
        public String OneTimePaymentText{get{return AtlasConstants.OneTimePaymentText;}set;}
        public String ThankYouText{get{return AtlasConstants.ThankYouText;}set;}
        public String SuccessFulPaymentText{get{return AtlasUtility.getMapValue(AtlasConstants.SuccessFulPaymentText);}set;}
        public Boolean showDisclaimerText{get{if(AtlasUtility.getMapValue(AtlasConstants.SHOW_DISCLAIMER_2).equalsIgnoreCase('false')) {return false;} else {return true;}}set;}

        public string styleBlueOrange{get;set;}     
        public String bottomBorderColor{get;set;}
        public String borderleftOrRightcolor{get;set;}
        public boolean bnExede {get;set;}
        public boolean bnWildblue {get;set;}
        public string pageName{get{return AtlasConstants.STRCURRENTBILL;}set;}
        public boolean isVisibleExceptionMessage{get;set;}
        public string exceptionString{get;set;}
        public string externalInvoiceReferenceNumber{get;set;}
        // Instantiate the generic Pagination controller
    public AtlasGenericPaginationController paginater{get;set;}
    // Create Lists to hold the data to be be displayed in tables
    public List<AtlasInvoiceCDRDTO> billList{get;set;}
    public List<List<AtlasInvoiceCDRDTO>> allBillList{get;set;}
    public string exceptionForCDR{get;set;}
    public string close{get{return AtlasConstants.STR_CLOSE;}set;}
    public string exedeViocelabel{get{return AtlasConstants.EXEDE_VOICE_DETAILS;}set;}
    public string loadingLabel{get{return AtlasConstants.LOADING_CDR_INFO;}set;}
    public string manageVoiceAccount{get{return AtlasConstants.MANAGE_VOICE;}set;}
    public string cdrInfoUnavailable{get{return AtlasUtility.getMapValue(AtlasConstants.CDR_NO_INFO);}set;}
    public string datetime_CDR{get{return AtlasConstants.CDR_DATE_TIME;}set;}
        public string calledNo_CDR{get{return AtlasConstants.CDR_CALLED_NO;}set;}
        public string location_CDR{get{return AtlasConstants.CDR_LOCATION;}set;}
        public string duration_CDR{get{return AtlasConstants.CDR_DURATION;}set;}
        public string amount_CDR{get{return AtlasConstants.CDR_AMOUNT;}set;}
        
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
        
        public boolean hide_Details{get;set;}
        /*** Hold the currentbilldata ***/
        Public AtlasCurrentBillDTO currentBillData {get; set;}
        
        
          /**
                * @author Raghuprasad Halakere 
                * @description zero parameter AtlasCurrentBillController constructor
                * @param object null
                * @return void
                */  
        public AtlasCurrentBillController(){
                if(Apexpages.currentPage().getUrl().containsIgnoreCase(AtlasConstants.URL_FOR_PRINT_INVOICE)||Apexpages.currentPage().getUrl().containsIgnoreCase(AtlasConstants.URL_FOR_BILL_PRINT_INVOICE)) 
                                hide_Details=false;
                else
                            hide_Details=true;
                Apexpages.currentPage().getHeaders().put(AtlasConstants.X_UA_COMPATIBLE,AtlasConstants.IE_8);
                id userid= userinfo.getUserId();
                bnExede = false;
                bnWildblue = false;       
                User objUser = new user();
                objUser = [Select CommunityUserAccountType__c from user where id=:userid];
                if(objUser.CommunityUserAccountType__c == null || objUser.CommunityUserAccountType__c == AtlasConstants.STR_EXEDE) //(objUser.CommunityUserAccountType__c != null && objUser.CommunityUserAccountType__c != AtlasConstants.BLACK_SPACE && objUser.CommunityUserAccountType__c == AtlasConstants.STR_EXEDE)
                {  
                        styleBlueOrange = AtlasConstants.STYLE_ORANGE;
                        bottomBorderColor = AtlasConstants.ExedeBottomBorderColor;
                        borderleftOrRightcolor = AtlasConstants.ExedeborderleftOrRightcolor;
                        bnExede = true;
                }
                else if(objUser.CommunityUserAccountType__c != null && objUser.CommunityUserAccountType__c != AtlasConstants.BLACK_SPACE && objUser.CommunityUserAccountType__c == AtlasConstants.STR_WILDBLUE)
                {
                        styleBlueOrange =AtlasConstants.STYLE_BLUE;
                        bottomBorderColor = AtlasConstants.WildBlueBottomBorderColor;
                        borderleftOrRightcolor = AtlasConstants.WildBlueborderleftOrRightcolor;
                        bnWildblue = true;
                }      
                String strurl = ApexPages.currentPage().getUrl();
                if(strurl.contains('history')&& !AtlasUtility.isEmpty(printInvoiceDTOObj))
                {
                        currentBillData = printInvoiceDTOObj;
                }
                isVisibleExceptionMessage=false;
                exceptionForCDR='';    
        }
          /**
                * @author Raghuprasad Halakere 
                * @description - opens the print invoice popup page in currentbill
                * @param object - null
                * @return void
                */      
        Public pageReference printInvoice()
        {
                Pagereference p = Page.AtlasBillingInvoicePrintInvoice;
                
                p.setRedirect(false);
                return p;
        }
          /**
                * @author Raghuprasad Halakere 
                * @description - loadInvoiceDetails for currentbill
                * @param object - null
                * @return void
                */  
        Public void loadInvoiceDetails()
        {
                try{                                   
                        populateBillingHistory();           
                        if(mainDTOObj.billhistoryDTOObj.billHistory != null){
                                currentBillData = populateCurrentBillData(mainDTOObj.billhistoryDTOObj.billHistory[0].invoiceReference); 
                                system.debug('^^^^'+currentBillData);
                                isVisibleExceptionMessage=false;}
                        //else
                        //currentBillData = null; 
                        else{
                                isVisibleExceptionMessage=true;  
                            exceptionString=AtlasConstants.CURRENTBILL_EXCEPTION;}                
                }catch(AtlasException e)
                {       
                    isVisibleExceptionMessage=true;
                    exceptionString=e.errorMessage ;
                        
                }  
                
        }
          /**
                * @author Raghuprasad Halakere 
                * @description - calls populateAtlasDashboardData method for currentbill
                * @param object - null
                * @return void
                */           
        public  void callRemoteAtlasDashboardData()
        {
                populateAtlasDashboardData();          
        }
          /**
                * @author Raghuprasad Halakere 
                * @description - calls getCurrentDataUsageDashBoradData method for currentbill
                * @param object - null
                * @return void
                */ 
        public  void currentDataUsageAtlasDashboardData()
        {         
                getCurrentDataUsageDashBoradData();
                
        }
          /**
                * @author Raghuprasad Halakere 
                * @description - calls getMyAccountDashBoardData method for currentbill
                * @param object - null
                * @return void
                */
        public  void myAccountAtlasDashboardData()
        {
                getMyAccountDashBoardData();
                
        }  
          /**
                * @author Raghuprasad Halakere 
                * @description - calls getBillingSnapShotDashBoardDAta method for currentbill
                * @param object - null
                * @return void
                */
        public  void billingSnapshotAtlasDashboardData()
        {
                getBillingSnapShotDashBoardDAta();
                
        }
          /**
                * @author Raghuprasad Halakere 
                * @description - calls getCurrentPaymentSettingsBillPage method for currentbill
                * @param object - null
                * @return void
                */
        public  void currentPaymentSettingsCurrentBillPage()
        {
                getCurrentPaymentSettingsBillPage();
                
                
        }
          /**
                * @author Raghuprasad Halakere 
                * @description - calls fetchInvoiceCDRDetails method for currentbill
                * @param object - null
                * @return void
                */
        public  void fetchInvoiceCDRDetails()
        {    
                 
                try{
                        mainDTOObj = populateCDRBillingData(externalInvoiceReferenceNumber);    
                        // to call paginator
                        paginationForCDRDetails();
                        exceptionForCDR='';
                }
                catch(Exception e)
                {
                        exceptionForCDR=AtlasUtility.getMapValue(AtlasConstants.CDR_EXCEPTION);  
                }          
        }
        
        /**
        * @author shiva shankar 
        * @description - calls paginationForCDRDetails method for currentbill
        * @param object - null
        * @return void
        */
        public string paginationForCDRDetails()
        {    
                 List<AtlasInvoiceCDRDTO> resultsList=getCDRInfoList(); 
                 
                 //Set the page size
        Integer pageSize=AtlasConstants.NO_OF_RECORDS_PER_PAGE;
        
        //Create a new instance of AtlasGenericPaginationController passing in the overall size of
        //the list of data and the page size you want
        if(resultsList != null)
            this.paginater=new AtlasGenericPaginationController(resultsList.size(),pageSize);
        else
            this.paginater=new AtlasGenericPaginationController(0, pageSize);
                //These lists hold the data
                this.allBillList=new List<List<AtlasInvoiceCDRDTO>>();
                this.billList=new List<AtlasInvoiceCDRDTO>();
                
                //Break out the full list into a list of lists
                if(resultsList != null)
                if(resultsList.size() > 0){
                    List<AtlasInvoiceCDRDTO> tempCC=new List<AtlasInvoiceCDRDTO>();        
                    Integer i=0;
                    for(AtlasInvoiceCDRDTO cc : resultsList){
                        tempCC.add(cc);
                        i++;
                        if(i == pageSize){
                            this.allBillList.add(tempCC);
                            tempCC=new List<AtlasInvoiceCDRDTO>();
                            i=0;
                        }
                    }
                    if(!tempCC.isEmpty()){
                        this.allBillList.add(tempCC);
                        
                    }
                     
                    //Gets the correct list of data to show on the page
                    this.billList=this.allBillList.get(this.paginater.index);
                    
                }
                return null;  
        }
        
        /**
    * @author Raghuprasad Halakere
    * @description - getBillingHistoryList for currentbill
    * @input param  - null
    * @return mainDTOObj.invoiceCDRDTO
    */
    public List<AtlasInvoiceCDRDTO> getCDRInfoList()
    {
        if (mainDTOObj.invoiceCDRDTO!=null)
            return mainDTOObj.invoiceCDRDTO;
        else
            return null;    
    }  
        /**
    * @author shiva shankar
    * @description - previousPage for currentbill
    * @input param  - null
    * @return PageReference
    */
    /************ Pagination Methods ***************************/
    public PageReference previousPage(){
        this.paginater.decrement();
        return changeData();
    }
        /**
    * @author shiva shankar
    * @description - nextPage for currentbill
    * @input param  - null
    * @return PageReference
    */
    public PageReference nextPage(){
        this.paginater.increment();
        return changeData();
    }
        /**
    * @author shiva shankar
    * @description - updatePage for currentbill
    * @input param  - null
    * @return PageReference
    */
    public PageReference updatePage(){
        this.paginater.updateNumbers();
        return changeData();
    }
        /**
    * @author shiva shankar
    * @description - changeData on clicking previous/next page for currentbill
    * @input param  - null
    * @return PageReference
    */
    public PageReference changeData(){
        if(allBillList.size() > 0)
          this.billList=this.allBillList.get(this.paginater.index);
        return null;
    }
}