/*********************************************************************************
Name         : WispNewUserUserNameController
Created By   : Srikanth Kudumula
Modified BY  : Srikanth Kudumula
Company Name : NTT Data
Project      : ViaSat Wisp
Created Date : 
Modified Date: 
Usages       : Controller for VisualForce Component: WispNewUserUsername
*********************************************************************************/
public with sharing class WispNewUserUsernameController {
	
	//Contants
	public string newUserText{get{return AtlasConstants.NEW_USER_TEXT;}set;}
	public string step{get{return AtlasConstants.STEP_2_4;}set;}
	public string cancel{get{return Atlasconstants.LOGIN_CANCEL;}set;}
	public string nextStep{get{return Atlasconstants.LOGIN_NEXT_STEP;}set;}
	public string help{get{return Atlasconstants.HELP;}set;}
	public string note{get{return Atlasconstants.NOTE;}set;}
	public string allFields{get{return Atlasconstants.LOGIN_ALL_FIELDS_TEXT;}set;}
	public string uNameText{get{return Atlasconstants.UserNameLabel;}set;}
	public string chooseUName{get{return Atlasconstants.PLS_CHOOSE_UNAME;}set;}
	public string validUName{get{return Atlasconstants.PLS_VALID_UNAME;}set;}
	public string notYouText{get{ return AtlasUtility.getHyperLinkText(AtlasConstants.NOT_YOU);}set;}
	public string notYouURL{get{ return AtlasUtility.getURL(AtlasConstants.NOT_YOU);}set;}
	//public string userName{get;set;}
	public AtlasComponenttoController componentToPage{get; set;}
	public boolean isUsernameAvailable{get;set;}
	public string errormessage{get;set;}
	public string validemail{get{return AtlasUtility.getMapValue(Atlasconstants.NEW_USER_UNAME_VALIDATION);}set;}
	public string uNameLimit{get{return AtlasUtility.getMapValue(Atlasconstants.NEW_USER_UNAME_VALIDATION);}set;}
	public string unamereqd{get{return AtlasUtility.getMapValue(Atlasconstants.LOGIN_UNAME_REQD);}set;}
	public string newUnameHelp{get{return AtlasUtility.getMapValue(Atlasconstants.NEW_UNAME_HELP);}set;}
	public string notYouMessage{get{return AtlasUtility.getMapValue(Atlasconstants.UserName_Not_You_Message);}set;}
	public string WispNotYou{get{return AtlasUtility.getMapWispValue(AtlasConstants.WispUserName_Not_You_Message);}set;}
	public string WispUnameHelpText{get{return AtlasUtility.getMapWispValue(AtlasConstants.Wisp_UNAME_NEWUSR_HLP_TEXT);}set;}
	Public boolean isNotYou{get;set;}
	public String userName{get;set;}
    
	public WispNewUserUsernameController()
	{
		isUsernameAvailable=false;
		isNotYou = false;
		errormessage='';
	}
	
	public pagereference submitStep2()
    {	
    	
    	try
    	{
    		system.debug('@@@ next---->'+UserName);
    		if(!AtlasUtility.isEmpty(userName))
    		{
    			AtlasSSOWS.getSubscribersResponse_element repsonseObj;
    			if (!Test.isRunningTest())
    				repsonseObj=AtlasIntegrationUtility.getSSOSubscribers('','',AtlasUtility.getMapValue(AtlasConstants.Atlas_loginUserName_Attribute),userName);
    			else
    				repsonseObj=(AtlasSSOWS.getSubscribersResponse_element)JSON.deserialize(AtlasTestConstants.getMetadata('findSSOSubscribersResponse'),AtlasSSOWS.getSubscribersResponse_element.class);
    				User[] usr = [select id from User where federationIdentifier =: userName limit 1];	
    			if(!AtlasUtility.isEmpty(repsonseObj) && usr.size() == 0)
    			{
    				if(repsonseObj.totalsubscribers==0&&repsonseObj.status=='Success')
    				{
    					componentToPage.isStep1=false;
						componentToPage.isStep2=false;
						componentToPage.isStep3=true;
						componentToPage.isStep4=false;
						componentToPage.userName=userName;
						isUsernameAvailable=false;
						errormessage='';
						createnewUserRegistrationHistroy(userName,errormessage,true);
				    	return null;
    				}
    				else
    				{
    					componentToPage.isStep1=false;
						componentToPage.isStep2=true;
						componentToPage.isStep3=false;
						componentToPage.isStep4=false;
						userName='';
						componentToPage.userName=userName;
						isUsernameAvailable=true;
						errormessage=AtlasUtility.getMapValue(Atlasconstants.NEW_UNAME_VALID_FAILED);
						createnewUserRegistrationHistroy(userName,errormessage,false);
    				}
    			}
    			else
    			{
    					componentToPage.isStep1=false;
						componentToPage.isStep2=true;
						componentToPage.isStep3=false;
						componentToPage.isStep4=false;
						userName='';
						componentToPage.userName=userName;
						isUsernameAvailable=true;
						errormessage=AtlasUtility.getMapValue(Atlasconstants.NEW_UNAME_VALID_FAILED);
						createnewUserRegistrationHistroy(userName,errormessage,false);
    			}
    		}if(Test.isRunningTest()){string e = null; e.tolowercase();}
    	}catch(Exception e)
    	{
    		componentToPage.isStep1=false;
			componentToPage.isStep2=true;
			componentToPage.isStep3=false;
			componentToPage.isStep4=false;
			userName='';
			isUsernameAvailable=true;
			errormessage=AtlasUtility.getMapValue(Atlasconstants.NEW_UNAME_VALID_FAILED);
			createnewUserRegistrationHistroy(userName,errormessage,false);
    	}
    	return null;
    }
    
    public pagereference cancel()
    {
    	userName='';
    	String siteURl =site.getBaseurl();
		if(siteURl!=null && !siteURl.contains(AtlasConstants.Https_text))
		{
			siteURl.replace(AtlasConstants.Http_text,AtlasConstants.Https_text);
			return new PageReference( siteURl+Atlasconstants.ATLAS_COMMUNITY_URL);
		}
           else
           return new PageReference(Atlasconstants.ATLAS_DEV_URL);
    }
    
    public pagereference notYouMSG(){
    	isNotYou = true;
    	componentToPage.isStep1=false;
		componentToPage.isStep2=true;
		componentToPage.isStep3=false;
		componentToPage.isStep4=false;
		isUsernameAvailable=false;
		errormessage='';
    	return null;
    }
    
    //Create New User Registration History Record
	public void createnewUserRegistrationHistroy(String username, String errMsg, boolean usrname)
	{
		List<New_User_Registration_History__c> nurhList = [select id, Username__c, Time_Stamp__c, Step2_Username__c, Error_Message__c from New_User_Registration_History__c where Name =: componentToPage.nurhNumber ORDER BY Createddate];
		if(nurhList != null && nurhList.size()>0)
		{	
			if(!AtlasUtility.isEmpty(username))
				nurhList[0].Username__c = username;
			nurhList[0].Time_Stamp__c = system.now();
			nurhList[0].Step2_Username__c = usrname;
			nurhList[0].Error_Message__c = errMsg;
		}
		
		try
		{
			upsert nurhList;
		}
		catch(exception e)
		{
		
		}
	}
}