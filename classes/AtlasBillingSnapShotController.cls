/*********************************************************************************
Name         : AtlasBillingSnapShotController 
Created By   : Shiva Shankar N 
Modified BY  : Gaurav Gathania
Company Name : NTT Data
Project      : ViaSat Atlas, Bangalore
Created Date : 18 October2013
Modified Date: 13 November 2013
Usages       : Controller for VisualForce Component : AtlasDashboardPageBillingSnapShot
*********************************************************************************/
public with sharing class AtlasBillingSnapShotController {

  // Initialinzing AtlasBillingSnapShotDTO object
    public AtlasBillingSnapShotDTO bssDTO{get;set;}

  // Intializing Global Variables for HyperLinkURLs
    public string strHyperLinkAddressPayBill{get{return AtlasUtility.getURL(AtlasConstants.VIEW_CURRENT_BILL);}set;}
    public string strHyperLinkAddressBillingHistory{get{return AtlasUtility.getURL(AtlasConstants.BILLING_HISTORY);}set;}   
    public string strHyperLinkAddressBillingSnapShot{get{return AtlasUtility.getURL(AtlasConstants.BILLING_SNAPSHOT);}set;}
    public string strHyperLinkAddressManageBilling{get{return AtlasUtility.getURL(AtlasConstants.MANAGE_BILLING_SETTINGS);}set;}
    
    public string strLastBill{get{return AtlasConstants.LAST_BILL;}set;}
    public string strDue{get{return AtlasConstants.DUE;}set;}
    public string strLastPayment{get{return AtlasConstants.LAST_PAYMENT;}set;}
    public string LoadingBillingLabel{get{return AtlasConstants.LoadingBillingLabel;}set;}
    
  // Intializing Global Variables for HyperLinkText
    public string strHyperLinkTextBillingSnapShot{get{return AtlasUtility.getHyperLinkText(AtlasConstants.BILLING_SNAPSHOT);}set;}  
    public string strHyperLinkTextPayBill{get{
            if(pageNameLabel==AtlasConstants.STRBILLING_HISTORY)
            {
                return AtlasConstants.HEADER_CLASS_BILLINGHISTORY_PAYBILL_TEXT;
            }
            else
            return AtlasUtility.getHyperLinkText(AtlasConstants.VIEW_CURRENT_BILL);
        }set;}
    public string strHyperLinkTextBillingHistory{get{return AtlasUtility.getHyperLinkText(AtlasConstants.VIEW_BILLING_HISTORY);}set;}
    public string strHyperLinkTextManageBilling{get{return AtlasUtility.getHyperLinkText(AtlasConstants.MANAGE_BILLING_SETTINGS);}set;}
            
  // Intializing Global Variables for IsVisibility
    public boolean isvisible{get{return pageNameLabel==AtlasConstants.STRDASHBOARD;}set;}
    public Boolean IsVisibleManageBilling{get{return AtlasUtility.getVisibility(AtlasConstants.MANAGE_BILLING_SETTINGS);}set;}
    public boolean isvisiblBillinghistory{get{return getisVisibleBillingHistory();}set;}
    public Boolean IsVisibleBillingHistory{get{return AtlasUtility.getVisibility(AtlasConstants.BILLING_HISTORY);}set;}
    public Boolean IsVisibleBillingSnapShot{get{return AtlasUtility.getVisibility(AtlasConstants.BILLING_SNAPSHOT);}set;}
    public Boolean IsVisiblePayBill{get{return AtlasUtility.getVisibility(AtlasConstants.VIEW_CURRENT_BILL);}set;}
    public string pageNameLabel{get;set;}   
   // Variable used to hold the HeaderClass info 
    public string strHeaderClass{get{return getHeaderClass();}set;}
        
   // Variable used to disable the billing history in other pages.
    public Boolean isBillingHistoryVisible{get{return getisVisibleBillingHistory();}set;}
    
   // Variable for setting the class style based on the rendered page
    public String strStyleClass{get{return getStyleClass();}set;}
    //variable is used to set button's color
    public string buttonStyleClass{get{return getButtonStyleClass();}set;}
    public string divHeightForDashboardpage{get{return getDivHeightForDashBoardpage();}set;}
    public string divHeightIfNoException{get{if(pageNameLabel==AtlasConstants.STRDASHBOARD)
                                                {
                                                    return 'height: 151px;';
                                                }
                                                else return '';
                                                }set;}
    public string pHeight{get{if(pageNameLabel==AtlasConstants.STRDASHBOARD)
                                                {
                                                    return 'margin-top:73px;';
                                                }
                                                else return '';
                                                }set;}                                              
    public boolean isvisibleHRTag{get{return getisVisibleHRTag();}set;}     
      /**
        * @author Raghuprasad Halakere 
        * @description - zero parameter AtlasBillingSnapShotController constructor
        * @param object null
        * @return null
        */
    public AtlasBillingSnapShotController ()
    {      
        isvisible = false;
        isBillingHistoryVisible = true;
        divHeightForDashboardpage='height: 167px;';
    }
      /**
        * @author Raghuprasad Halakere 
        * @description - getHeaderClass for BillingSnapShot Component
        * @param object null
        * @return string
        */
    private string getHeaderClass()
    {
        if(pageNameLabel==AtlasConstants.STRDASHBOARD)
        {
            return AtlasConstants.HEADER_CLASS_DASHBOARD;
        }
        else if(pageNameLabel==AtlasConstants.STRUSAGE)
        {
            return AtlasConstants.HEADER_CLASS_USAGE;
        }
        else if(pageNameLabel==AtlasConstants.STRCUSTOMER_INFO||pageNameLabel==AtlasConstants.CHANGEPLAN)
        {
            return AtlasConstants.HEADER_CLASS_CUSTOMERINFO;
        }
        else if(pageNameLabel==AtlasConstants.STRBILLING_HISTORY)
        {
            return AtlasConstants.HEADER_CLASS_BILLINGHISTORY;
        }
        else if(pageNameLabel==AtlasConstants.STRMANAGE_EMAIL)
        {
            return AtlasConstants.HEADER_CLASS_MANAGEEMAIL;
        }
        return AtlasConstants.HEADER_CLASS_DASHBOARD;
    }
      /**
        * @author Raghuprasad Halakere 
        * @description - getStyleClass for BillingSnapShot Component
        * @param object null
        * @return string
        */
    private string getStyleClass()
    {
        if(pageNameLabel==AtlasConstants.STRDASHBOARD)
        {
            return AtlasConstants.STYLE_CLASS_DASHBOARD;
        }
        else if(pageNameLabel==AtlasConstants.STRUSAGE)
        {
            return AtlasConstants.STYLE_CLASS_USAGE;
        }
        else if(pageNameLabel==AtlasConstants.STRCUSTOMER_INFO||pageNameLabel==AtlasConstants.CHANGEPLAN)
        {
            return AtlasConstants.STYLE_CLASS_CUSTOMERINFO;
        }
        else if(pageNameLabel==AtlasConstants.STRBILLING_HISTORY)
        {
            return AtlasConstants.STYLE_CLASS_BILLINGHISTORY;
        }
        else if(pageNameLabel==AtlasConstants.STRMANAGE_EMAIL)
        {
            return AtlasConstants.STYLE_CLASS_MANAGEEMAIL;
        }
        return AtlasConstants.STYLE_CLASS_USAGE;
    }
      /**
        * @author Raghuprasad Halakere 
        * @description - getisVisibleBillingHistory for BillingSnapShot Component
        * @param object null
        * @return boolean
        */
    private boolean getisVisibleBillingHistory()
    {
        if(pageNameLabel==AtlasConstants.STRUSAGE)
        {
            return AtlasConstants.IS_BILLING_HISTORYVISIBLE;
        }
        else if(pageNameLabel==AtlasConstants.STRCUSTOMER_INFO||pageNameLabel==AtlasConstants.CHANGEPLAN)
        {
            return AtlasConstants.IS_BILLING_HISTORYVISIBLE_CUSTOMERINFO;
        }
        else if(pageNameLabel==AtlasConstants.STRBILLING_HISTORY)
        {
            return AtlasConstants.IS_BILLING_HISTORYVISIBLE_BILLINGHISTORY;
        }
        else if(pageNameLabel==AtlasConstants.STRMANAGE_EMAIL)
        {
            return AtlasConstants.IS_BILLING_HISTORYVISIBLE_MANAGEEMAIL;
        }
        return true;
    }
      /**
        * @author Raghuprasad Halakere 
        * @description - getButtonStyleClass for BillingSnapShot Component
        * @param object null
        * @return string
        */
    private string getButtonStyleClass()
    {
        if(pageNameLabel==AtlasConstants.STRDASHBOARD)
        {
            return AtlasConstants.BUTTONCLASS_DASHBOARD_BILLING;
        }
        else 
        {
            return AtlasConstants.BUTTONCLASS_ALLPAGES_BILLING;
        }
    }
      /**
        * @author Raghuprasad Halakere 
        * @description - getDivHeightForDashBoardpage for BillingSnapShot Component
        * @param object null
        * @return string
        */
    private string getDivHeightForDashBoardpage()
    {
        if(pageNameLabel==AtlasConstants.STRDASHBOARD)
        {   
            return 'height: 209px;';
        }
        else
        return '';
    }
      /**
        * @author Raghuprasad Halakere 
        * @description - getisVisibleHRTag for BillingSnapShot Component
        * @param object null
        * @return boolean
        */
    private boolean getisVisibleHRTag()
    {
        if(pageNameLabel==AtlasConstants.STRDASHBOARD||pageNameLabel==AtlasConstants.STRBILLING_HISTORY)
        return false;
        else
        return true;
    }
}