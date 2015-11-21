/*********************************************************************************
Name         : AtlasCurrentDataUsageController 
Created By   : Shiva Shankar N 
Modified BY  : Shiva Shankar N
Company Name : NTT Data
Project      : ViaSat Atlas, Bangalore
Created Date : 18 October 2013
Modified Date: 13 Novemeber 2013
Usages       : Controller for VisualForce Component : AtlasDashboardPageCurrentDataUsage
*********************************************************************************/
public with sharing class AtlasCurrentDataUsageController {
    
    public AtlasCurrentDataUsageDTO cudDTO{get;set;}
    public AtlasMainDTO mainDTO{get;set;}
    public string strPercentofData{get;set;}
    public string LoadingUsageLabel{get{return AtlasConstants.LoadingUsageLabel;}set;}
    public string DaysRemainingLabel{get{return AtlasUtility.getMapValue(AtlasConstants.DaysRemainingLabel);}set;} 
    public string CDU_disclaimerText{get{return AtlasUtility.getMapValue(AtlasConstants.CDU_disclaimerText_a)+''+AtlasUtility.getMapValue(AtlasConstants.CDU_disclaimerText_b);}set;}
    // Initializing AtlasDashboardPageCurrentDataUsage Component GlobalVariables HyperLinkURL 
    public string strHyperLinkTextCurrentDataUsage{get;set;} 
    public string strHyperLinkTextUsageDetails{get{return AtlasUtility.getHyperLinkText(AtlasConstants.USAGE_DETAILS);}set;}
    public string strHyperLinkTextBuyMoreData{get{return AtlasUtility.getHyperLinkText(AtlasConstants.BUY_MORE_DATA);}set;}
    // Initializing AtlasDashboardPageCurrentDataUsage Component GlobalVariables HyperLinkText
    public string strHyperLinkAddressCurrentDataUsage{get{return AtlasUtility.getURL(AtlasConstants.CURRENT_DATA_USAGE);}set;}
    public string strHyperLinkAddressUsageDetails{get{return AtlasUtility.getURL(AtlasConstants.USAGE_DETAILS);}set;}
    public string strHyperLinkAddressBuyMoreData{get{return AtlasUtility.getURL(AtlasConstants.BUY_MORE_DATA);}set;}
    // Initializing AtlasDashboardPageCurrentDataUsage Component GlobalVariables Visibility
    public Boolean IsVisibleCurrentDataUsage{get{return AtlasUtility.getVisibility(AtlasConstants.CURRENT_DATA_USAGE);}set;}
    public Boolean IsVisibleUsageDetails{get{return AtlasUtility.getVisibility(AtlasConstants.USAGE_DETAILS);}set;}
    public Boolean IsVisibleBuyMoreData{get{return AtlasUtility.getVisibility(AtlasConstants.BUY_MORE_DATA);}set;}    
    public boolean isvisible{get;set;}

    public boolean isUsagePage{get;set;}
    //variable for header class  
    public string strHeaderClass{get;set;}
    //Variable to get css style sheet
    public string strCSSStyle{get;set;}
    public integer intValueEighty{get{return AtlasConstants.EIGHTY;}set;} 
    public integer intValueNinety{get{return AtlasConstants.NINETY;}set;}
    public integer intValueOneFifty{get{return AtlasConstants.ONE_FIFTY;}set;}
    //variable is used to set button's color
    public string buttonStyleClass{get{return getButtonStyleClass();}set;}
    public string paddingHeightForIE{get;set;}
    public String disclaimerFontHeight{get;set;}
    public boolean isvisibleHRTag{get{return getisVisibleHRTag();}set;}
    public string pageNameLabel{get;set;}
    //variables for liberty Pass
    public string LibertyPassEnabledText{get{return AtlasUtility.getMapValue(AtlasConstants.Atlas_Liberty_Pass_Enabled_Text);}set;}
	public string LibertyPassText{get{return AtlasUtility.getMapValue(AtlasConstants.Atlas_Liberty_Pass_Text);}set;}
	public string LibertyPassUsageText{get{return AtlasUtility.getMapValue(AtlasConstants.Atlas_Liberty_Pass_Usage_Text);}set;}
    
    // variables used in WISP
    public string currentDataUsage{get{return AtlasUtility.getMapWispValue(Atlasconstants.Wisp_CurrentDataUsage);}set;}
    public string usageMeterInfo{get{return AtlasUtility.getMapWispValue(Atlasconstants.Wisp_UsageMeterInfo);}set;}
    public string usageMeterText{get{return AtlasUtility.getMapWispValue(Atlasconstants.Wisp_UsageMeterInfoText);}set;}
    public string wispDaysRemaining{get{return AtlasUtility.getMapWispValue(Atlasconstants.wispDaysRemainingLabel);}set;}
    /**
    * @author Shiva Shankar
    * @description - zero parameter AtlasCurrentDataUsageController constructor
    * @input param  - null
    * @return null
    */
    public AtlasCurrentDataUsageController ()
    {
       getCurrentUsagedata(); 
       if(ApexPages.currentPage().getUrl().containsIgnoreCase(AtlasConstants.STRDASHBOARD))
       {    
        
            if(ApexPages.currentPage().getHeaders().get(AtlasConstants.USER_AGENT).containsIgnoreCase(AtlasConstants.BROWSER_NAME))    
            {
                paddingHeightForIE='21px';
            }
            else
            paddingHeightForIE='0px';
       } 
       
    }
    /**
    * @author Shiva Shankar
    * @description - getCurrentUsagedata for AtlasCurrentDataUsageController
    * @input param  - null
    * @return void
    */
    private void getCurrentUsagedata()
    {
        strHyperLinkTextCurrentDataUsage=AtlasUtility.getHyperLinkText(AtlasConstants.CURRENT_DATA_USAGE);       
       isvisible=false;
       isUsagePage=false;
       disclaimerFontHeight='8px';
       if(ApexPages.currentPage().getUrl().containsIgnoreCase(AtlasConstants.STRDASHBOARD)||ApexPages.currentPage().getUrl().containsIgnoreCase(AtlasConstants.STRPAYMENT_SETTINGS)||ApexPages.currentPage().getUrl().containsIgnoreCase(AtlasConstants.STRCURRENTBILL))
       {
           isvisible=true;

       }
       
       
       if(ApexPages.currentPage().getUrl().containsIgnoreCase(AtlasConstants.STRCURRENTBILL))
       {
           strCSSStyle=AtlasConstants.STYLE_CLASS_USAGE;
           strHyperLinkTextCurrentDataUsage=AtlasConstants.STRHYPERLINKTEXT_DATAUSAGE;
           strHeaderClass=AtlasConstants.STRCLASSSTYLE_DATAUSAGE;
       }
       
       else if(ApexPages.currentPage().getUrl().containsIgnoreCase(AtlasConstants.STRDASHBOARD))
       {
           strCSSStyle=AtlasConstants.STYLE_CLASS_DASHBOARD_DATAUSAGE;
           strHeaderClass=AtlasConstants.STRCLASSSTYLE_DATAUSAGE;
          
       }










        else if(ApexPages.currentPage().getUrl().containsIgnoreCase(AtlasConstants.STRPAYMENT_SETTINGS))
        {
            strHyperLinkTextCurrentDataUsage=AtlasConstants.STRHYPERLINKTEXT_DATAUSAGE;            
        } 
        else if(ApexPages.currentPage().getUrl().containsIgnoreCase(AtlasConstants.STRCUSTOMER_INFO)||ApexPages.currentPage().getUrl().containsIgnoreCase(AtlasConstants.CHANGEPLAN))
        {
            strCSSStyle=AtlasConstants.STYLE_CLASS_CUSTOMERINFO;
            strHyperLinkTextCurrentDataUsage=AtlasConstants.STRHYPERLINKTEXT_DATAUSAGE;
            strHeaderClass=AtlasConstants.HEADER_CLASS_CUSTOMERINFO_DATAUSAGE;
            isvisible= true;

            
        }
        else if(ApexPages.currentPage().getUrl().containsIgnoreCase(AtlasConstants.STRUSAGE))
        {
            strCSSStyle=AtlasConstants.STYLECSS_CLASS_USAGE;
            strHeaderClass=AtlasConstants.HEADERROW_CLASS_USAGE;
            isUsagePage=true;
            disclaimerFontHeight='12px';
        }
        
        else if(ApexPages.currentPage().getUrl().containsIgnoreCase(AtlasConstants.STRBILLING_HISTORY))
        {
            strHyperLinkTextCurrentDataUsage=AtlasConstants.STRHYPERLINKTEXT_DATAUSAGE;
            isvisible= true;
            isVisibleBuyMoreData=false; 
        }
        /*else if(ApexPages.currentPage().getUrl().containsIgnoreCase(AtlasConstants.STRCURRENTBILL))
        {
            strCSSStyle='col-xs-12 col-sm-6 col-md-12 col-lg-12';
        }*/
    }
    
    /**
    * @author Shiva Shankar
    * @description - getButtonStyleClass for AtlasCurrentDataUsageController
    * @input param  - null
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
    * @author Shiva Shankar
    * @description - getButtonStyleClass for AtlasCurrentDataUsageController
    * @input param  - null
    * @return boolean
    */  
    private boolean getisVisibleHRTag()
    {
        if(pageNameLabel==AtlasConstants.STRDASHBOARD)
        return false;
        else
        return true;
    }
  
}