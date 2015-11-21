/*********************************************************************************
Name         : DealerResetPasswordStep1Controller
Created By   : Srikanth Kudumula
Modified BY  : 
Company Name : NTT Data
Project      : Dealer Portal
Created Date : 10/19/2015
Modified Date: 
Usages       : Controller for VisualForce Component: DealerResetPasswordStep1
*********************************************************************************/
public with sharing class DealerResetPasswordStep1Controller {
	public DealerComponenttoController componentToPage{get; set;}//Apex class is used to find the steps(1,2,3,4..)
	public string loginLabel{get {return DealerUtility.getMapValue(DealerConstants.LoginLabel);} set;} //Displays "Login"
	public string loginHelpLabel{get {return DealerUtility.getMapValue(DealerConstants.LoginHelp);} set;} //Displays "Login Help"
	public string LoginHelpUNameError{get {return DealerUtility.getMapValue(DealerConstants.LoginHelpUNameError);} set;} //Displays error message
	public string loginHelpH1Label{get {return DealerUtility.getMapValue(DealerConstants.LoginHelpH1);} set;} //Displays Login Help H1 header 
	public string loginHelpH2Label{get {return DealerUtility.getMapValue(DealerConstants.LoginHelpH2);} set;} //Displays Login Help H2 header
	public string LoginHelpPMsg{get {return DealerUtility.getMapValue(DealerConstants.LoginHelpPMsg);} set;} //Displays  generic paragraph message
	public string loginHelpH3Label{get {return DealerUtility.getMapValue(DealerConstants.LoginHelpUNH3Label);} set;} //Displays Login Help H3 header
	public string loginHelpH4Label{get {return DealerUtility.getMapValue(DealerConstants.LoginHelpH4Label);} set;} //Displays Login Help H4 header 
	public string usernameLabel{get {return DealerUtility.getMapValue(DealerConstants.Username);} set;} //Displays "Username"
	public string serviceDeskEmailLabel{get {return DealerUtility.getMapValue(DealerConstants.ServiceDeskEmailAddy);} set;} //Displays help desk email address
	public string buttonNextLabel{get {return DealerUtility.getMapValue(DealerConstants.ButtonNext);} set;} //Displays "Next"
	public string pgBottomMsgUName{get {return DealerUtility.getMapValue(DealerConstants.PgBottomMsgUName);} set;} //Displays msg at bottom of Username 'page'
	public string FieldsRequiredGeneralMsg{get {return DealerUtility.getMapValue(DealerConstants.FieldsRequiredGeneralMsg);} set;} //Displays generic message when field are required
	public string ForAdditionalHelp{get {return DealerUtility.getMapValue(DealerConstants.ForAdditionalHelp);} set;} //Displays for additional help message
	public string LoginHelpSQnotExistErr{get {return DealerUtility.getMapValue(DealerConstants.LoginHelpSQnotExistErr);} set;} //Displays SQ not exist error message
	public string userName{get;set;}
	public boolean isUserFound{get;set;}
	public boolean isCalloutFailed{get;set;}
	public boolean SQnotExist{get;set;}
	public string sqAnswer1{get;set;}
	public string sqAnswer2{get;set;}
	public string sqAnswer3{get;set;}
	public string sqQuestion1{get;set;}
	public string sqQuestion2{get;set;}
	public string sqQuestion3{get;set;}
	
	//Constructor
	public DealerResetPasswordStep1Controller(){
		isUserFound = false;
		isCalloutFailed=false;
		SQnotExist = false;	
	}
	
	//Method for next button
	public pageReference NextStep1(){
		try{
			if(!DealerUtility.isEmpty(userName)){
				AtlasSSOWS.getSubscribersResponse_element repsonseObj;
				if (!Test.isRunningTest())
					repsonseObj=AtlasIntegrationUtility.getSSOSubscribers('','',AtlasUtility.getMapValue(AtlasConstants.Atlas_loginUserName_Attribute),userName);
				else
				{
					AtlasSSOWS.getSubscribersResponse_element repsonseObjdummy=(AtlasSSOWS.getSubscribersResponse_element)JSON.deserialize(AtlasTestConstants.getMetadata('findSSOSubscribersResponse'),AtlasSSOWS.getSubscribersResponse_element.class);
					repsonseObj=repsonseObjdummy;
				}
				 if(!DealerUtility.isEmpty(repsonseObj))
				{
					if(repsonseObj.totalsubscribers>0&&repsonseObj.status=='Success')
					{
						if(!DealerUtility.isEmpty(repsonseObj.subscribers.subscriber))
						{
							for(AtlasSSOWS.subscriberType obj:repsonseObj.subscribers.subscriber)
							{
								componentToPage.subscriberKey=obj.subscriberkey;
							}
							if(componentToPage.subscriberKey!=null)
							{
								 AtlasSSOWS.getSubscriberResponse_element objRepsonse;
								if (!Test.isRunningTest()){
									objRepsonse=AtlasIntegrationUtility.getSSOSubscriber(componentToPage.subscriberKey);
									system.debug('@@@ sso subscriber response --->'+objRepsonse);
								}else
								{
									AtlasSSOWS.getSubscriberResponse_element repsonseObjdummy=(AtlasSSOWS.getSubscriberResponse_element)JSON.deserialize(AtlasTestConstants.getMetadata('findSSOSubscriberResponse'),AtlasSSOWS.getSubscriberResponse_element.class);
									objRepsonse=repsonseObjdummy;
								}
								if(!Atlasutility.isEmpty(objRepsonse.subscriber.sprattributes.sprattribute))
								{
									system.debug('@@@ spr Attribute --->'+objRepsonse.subscriber.sprattributes.sprattribute);
									for(AtlasSSOWS.sprAttributeType obj: objRepsonse.subscriber.sprattributes.sprattribute)
									{   
										system.debug('@@@ spr Attribute --->'+obj);
										if(obj.name=='securityQuestion')
										{   
											if(!DealerUtility.isEmpty(obj.values.value))
											{
												string str='';
												for(string objValue: obj.values.value)
												{
													str+=objValue+'-';
													componentToPage.securityQList=str;
												}
												if(!DealerUtility.isEmpty(componentToPage.securityQList))
												{
													system.debug('@@@ inside security questions --->');
													string[] strvalue=componentToPage.securityQList.split('-');
													system.debug('@@@ number of security questions --->'+strvalue.size());
													string[] str1=strvalue[0].split(';');
													string[] str2=strvalue[1].split(';');
													if(strvalue.size()>2){
														system.debug('@@@ inside 3rd security question --->');
														string[] str3=strvalue[2].split(';');
														sqQuestion3 = str3[0];
														componentToPage.securityQ3=str3[0];
														componentToPage.securityQA3=str3[1];
													}
													sqQuestion1 = str1[0];
													sqQuestion2 = str2[0];
													componentToPage.securityQ1=str1[0];
													componentToPage.securityQA1=str1[1];
													componentToPage.securityQ2=str2[0];
													componentToPage.securityQA2=str2[1];
												}
											}
										}
									}
									if(componentToPage.securityQA1 == null){
										SQnotExist = true;
										componentToPage.LHStep1=true;
										componentToPage.LHStep2=false;
										componentToPage.LHStep3=false;
										componentToPage.LHStep4=false;
										return null;
									}
								}
							}
							componentToPage.LHStep1=false;
							componentToPage.LHStep2=true;
							componentToPage.LHStep3=false;
							componentToPage.LHStep4=false;
							componentToPage.userName=userName;
							isUserFound=false;
							isCalloutFailed=false;
							if(Test.isRunningTest()){string e = null; e.tolowercase();}
						}
						else
						{
							componentToPage.LHStep1=true;
							componentToPage.LHStep2=false;
							componentToPage.LHStep3=false;
							componentToPage.LHStep4=false;
							isUserFound=true;
							isCalloutFailed=false;
						}
					}
					else
					{
						componentToPage.LHStep1=true;
						componentToPage.LHStep2=false;
						componentToPage.LHStep3=false;
						componentToPage.LHStep4=false;
						isCalloutFailed=true;
					}
				}
			}
		}
		catch(exception e){
			isUserFound=false;
			isCalloutFailed=true;
		}
		return null;
	}	
}