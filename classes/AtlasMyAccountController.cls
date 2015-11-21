/*********************************************************************************
Name         : AtlasMyAccountController 
Created By   : Shiva Shankar N 
Modified BY  : Gaurav Gathania
Company Name : NTT Data
Project      : ViaSat Atlas, Bangalore
Created Date : 18 October2013
Usages       : Controller for VisualForce Component : AtlasDashboardPageMyAccount
*********************************************************************************/
public with sharing class AtlasMyAccountController{
	
	public  AtlasAccountDTO  accountDTO{get;set;}  	
	//My Account
	public string strHyperLinkTextMyAccount{get{return AtlasUtility.getHyperLinkText(AtlasConstants.MY_ACCOUNT);}set;}
	public string strHyperLinkAddressMyAccount{get{return AtlasUtility.getURL(AtlasConstants.MY_ACCOUNT);}set;}
	public Boolean IsVisibleMyAccount{get{return AtlasUtility.getVisibility(AtlasConstants.MY_ACCOUNT);}set;}
	//Manage your Account
	public string strHyperLinkTextManageYourAccount{get{return AtlasUtility.getHyperLinkText(AtlasConstants.MANAGE_YOUR_ACCOUNT);}set;}
	public string strHyperLinkAddressManageYourAccount{get{return AtlasUtility.getURL(AtlasConstants.MANAGE_YOUR_ACCOUNT);}set;}
	public Boolean IsVisibleManageYourAccount{get{return AtlasUtility.getVisibility(AtlasConstants.MANAGE_YOUR_ACCOUNT);}set;}
	//Manage Email
	public string strHyperLinkTextManageEmail{get{return AtlasUtility.getHyperLinkText(AtlasConstants.MANAGE_EMAIL);}set;}
	public string strHyperLinkAddressManageEmail{get{return AtlasUtility.getURL(AtlasConstants.MANAGE_EMAIL);}set;}
	public Boolean IsVisibleManageEmail{get{return AtlasUtility.getVisibility(AtlasConstants.MANAGE_EMAIL);}set;}
	//Upgrade Account
	public string strHyperLinkTextChangePlan{get{return AtlasConstants.strCHANGE_PLAN;}set;}
	public string strHyperLinkAddressChangePlan{get{return AtlasUtility.getURL(AtlasConstants.strCHANGE_PLAN);}set;}
	public Boolean IsVisibleChangePlan{get{return AtlasUtility.getVisibility(AtlasConstants.strCHANGE_PLAN);}set;}
	public String strMoving{get{return AtlasUtility.getURL(AtlasConstants.Moving);}set;}
	//is visible billingsettings{get;set;}
	public boolean isvisible{get;set;}
	public string divHeightForDashboardpage{get{return getDivHeightForDashBoardpage();}set;}
	public string vacationPlanList{get{return AtlasUtility.getMapValue(Atlasconstants.AtlasCPlanVacationList);}set;} 
	/**
    * @author Shiva Shankar
    * @description - strCSSStyle for MyAccount Component
    * @input param  - null
    * @return string
    */ 
	public string strCSSStyle{get{if(pageNameLabel==AtlasConstants.STRDASHBOARD)
			{
				return AtlasConstants.STYLE_CLASS_MYACCOUNT;
			}
			else if(pageNameLabel==AtlasConstants.STRUSAGE)
			{
				return AtlasConstants.STYLE_CLASS_CUSTOMERINFO; 
			}
			else if(pageNameLabel==AtlasConstants.STRCUSTOMER_INFO)
			{
				return AtlasConstants.STYLE_CLASS_BILLINGHISTORY;
			}
			else if(pageNameLabel==AtlasConstants.STRCURRENTBILL)
			{
				return AtlasConstants.STYLE_CLASS_CURRENTBILL;
			}
			return null;
		}set;}
	
	public boolean isOutPutPanelVisibleForCustomerInfo{get{if(pageNameLabel==AtlasConstants.STRCUSTOMER_INFO)
			{
				return true;
			}
			else 
			return false; 
		}
		set;}
	
	public string strPassword{get{return AtlasConstants.strPASSWORD;}set;}
	// Variables used for labels
	public string LoadingMyAccountLabel{get{return AtlasConstants.LoadingMyAccountLabel;}set;}
	public string AccoutLabel{get{return AtlasConstants.AccoutLabel;}set;}
	public string PhoneLabel{get{return AtlasConstants.PhoneLabel;}set;}
	public string EmailLabel{get{return AtlasConstants.EmailLabel;}set;}
	public string UserNameLabel{get{return AtlasConstants.UserNameLabel;}set;}
	public string ServiceAddressLabel{get{return AtlasConstants.ServiceAddressLabel;}set;}
	public string BillingAddressLabel{get{return AtlasConstants.BillingAddressLabel;}set;}
	public string YourPlanLabel{get{return AtlasConstants.YourPlanLabel;}set;}
	public string PasswordLabel{get{return AtlasConstants.PasswordLabel;}set;}
	//variables used for showing exception div
	public string errorMessage{get{return errorMessage;}set;} 
	public boolean isVisibleExceptionDiv{get{if(!AtlasUtility.isEmpty(errorMessage))
			{
				return true;
			}
			else
			return false;}set;} 	
	//variable is used to set button's color
	public string buttonStyleClass{get{return getButtonStyleClass();}set;}
	public boolean isvisibleHRTag{get{return getisVisibleHRTag();}set;}   	
	public string pageNameLabel{get;set;}																	
	/**
    * @author Shiva Shankar
    * @description - zero parameter AtlasMyAccountController constructor
    * @input param  - null
    * @return null
    */
	public AtlasMyAccountController(){
		
		isvisible = false;
		isvisible = ApexPages.currentPage().getUrl().containsIgnoreCase(AtlasConstants.STRDASHBOARD);
		divHeightForDashboardpage='height: 147px;';
	}
	
	/**
    * @author Shiva Shankar
    * @description - getButtonStyleClass for MyAccount Component
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
    * @description - getDivHeightForDashBoardpage for MyAccount Component
    * @input param  - null
    * @return string
    *///'height: 194px;';
	private string getDivHeightForDashBoardpage()
	{
		if(pageNameLabel==AtlasConstants.STRDASHBOARD)
		{
			return 'height: 189px;';
		}
		else
		return 'height: 194px;';
	}
	/**
    * @author Shiva Shankar
    * @description - getisVisibleHRTag for MyAccount Component
    * @input param  - null
    * @return boolean
    */	
	private boolean getisVisibleHRTag()
	{
		if(pageNameLabel==AtlasConstants.STRDASHBOARD||pageNameLabel==AtlasConstants.STRCUSTOMER_INFO)
		return false;
		else
		return true;
	}
}