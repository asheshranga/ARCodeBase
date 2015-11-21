/*********************************************************************************
Name         : DealerResetPasswordStep3Controller
Created By   : Srikanth Kudumula
Modified BY  : 
Company Name : NTT Data
Project      : Dealer Portal
Created Date : 10/19/2015
Modified Date: 
Usages       : Controller for VisualForce Component: DealerResetPasswordStep3
*********************************************************************************/
public with sharing class DealerResetPasswordStep3Controller {
	public DealerComponenttoController componentToPage{get; set;}//Apex class is used to find the steps(1,2,3,4..)
	public string loginHelpLabel{get {return DealerUtility.getMapValue(DealerConstants.LoginHelp);} set;} //Displays "Login Help"
	public string loginHelpH1Label{get {return DealerUtility.getMapValue(DealerConstants.LoginHelpH1);} set;} //Displays Login Help H1 header 
	public string loginHelpH2Label{get {return DealerUtility.getMapValue(DealerConstants.LoginHelpH2);} set;} //Displays Login Help H2 header 
	public string serviceDeskEmailLabel{get {return DealerUtility.getMapValue(DealerConstants.ServiceDeskEmailAddy);} set;} //Displays help desk email address
	public string newPWLabel{get {return DealerUtility.getMapValue(DealerConstants.NewPassword);} set;} //Displays "New Password"
	public string pgBottomMsgNewPW{get {return DealerUtility.getMapValue(DealerConstants.PgBottomMsgNewPW);} set;} //Displays msg at bottom of New Password Page
	public string resetPWSuccessH2Label{get {return DealerUtility.getMapValue(DealerConstants.ResetPWSuccessH2);} set;} //Displays PW Reset Success header
	public string retypeNewPWLabel{get {return DealerUtility.getMapValue(DealerConstants.RetypeNewPassword);} set;} //Displays "Retype New Password"
	public string buttonNextLabel{get {return DealerUtility.getMapValue(DealerConstants.ButtonNext);} set;} //Displays "Next" 
	public string buttonCancelLabel{get {return DealerUtility.getMapValue(DealerConstants.ButtonCancel);} set;} //Displays "Cancel" 
	public string loginLabel{get {return DealerUtility.getMapValue(DealerConstants.LoginLabel);} set;} //Displays "Login"
	public string LoginHelpPMsg{get {return DealerUtility.getMapValue(DealerConstants.LoginHelpPMsg);} set;} //Displays  generic paragraph message
	public string loginHelpH4Label{get {return DealerUtility.getMapValue(DealerConstants.LoginHelpH4Label);} set;} //Displays Login Help H4 header
	public string LoginHelpPH3Label{get {return DealerUtility.getMapValue(DealerConstants.LoginHelpPH3Label);} set;} //Displays Password H3 header
	public string PasswordRules{get {return DealerUtility.getMapValue(DealerConstants.PasswordRules);} set;} //Displays "Password Rules:"
	public string PasswordRule1Text{get {return DealerUtility.getMapValue(DealerConstants.PasswordRule1Text);} set;} //Displays Password Rule1 Text
	public string PasswordRule2Text{get {return DealerUtility.getMapValue(DealerConstants.PasswordRule2Text);} set;} //Displays Password Rule2 Text
	public string PasswordRule3Text{get {return DealerUtility.getMapValue(DealerConstants.PasswordRule3Text);} set;} //Displays Password Rule3 Text
	public string PasswordRule4Text{get {return DealerUtility.getMapValue(DealerConstants.PasswordRule4Text);} set;} //Displays Password Rule4 Text
	public string FieldsRequiredGeneralMsg{get {return DealerUtility.getMapValue(DealerConstants.FieldsRequiredGeneralMsg);} set;} //Displays generic message when field are required
	public string PasswordsNotMatchErrMsg{get {return DealerUtility.getMapValue(DealerConstants.PasswordsNotMatchErrMsg);} set;} //Displays Passwords not match error message
	public string PasswordRuleCriteria{get {return DealerUtility.getMapValue(DealerConstants.PasswordRuleCriteria);} set;} //Displays password rule criteria error message
	public string password{get;set;}//variable to hold password value
	public string confirmPassword{get;set;}//variable to hold confirm password value
	public boolean calloutExcep{get;set;}
	
	public DealerResetPasswordStep3Controller(){
		calloutExcep = false;
	}
	
	public pageReference NextStep3(){
		try
		{
			system.debug('@@@ password --->'+password);
			system.debug('@@@ confirmPassword --->'+confirmPassword);
			if(!DealerUtility.isEmpty(componentToPage.userName) && (!DealerUtility.isEmpty(password)||!DealerUtility.isEmpty(confirmPassword)) && password==confirmPassword)
			{
				AtlasSSOWS.resetPasswordResponse_element response;
				if (!Test.isRunningTest())
					response=AtlasIntegrationUtility.resetPassword(componentToPage.userName,confirmPassword,false);
				else
				{
					response=(AtlasSSOWS.resetPasswordResponse_element)JSON.deserialize(AtlasTestConstants.getMetadata('resetPasswordResponse'),AtlasSSOWS.resetPasswordResponse_element.class);
				} 
				
				if(!DealerUtility.isEmpty(response) && response.loginusername==componentToPage.userName && response.status=='Success')
				{
					componentToPage.LHStep1=false;
					componentToPage.LHStep2=false;
					componentToPage.LHStep3=false;
					componentToPage.LHStep4=true;                   
					//isPWDReset=false;
					componentToPage.password=password;
				}
				else
				{
					componentToPage.LHStep1=false;
					componentToPage.LHStep2=false;
					componentToPage.LHStep3=true;
					componentToPage.LHStep4=false;                    
					system.debug('@@@ inside --->');
				}
			}
			else
			{
				componentToPage.LHStep1=false;
				componentToPage.LHStep2=false;
				componentToPage.LHStep3=true;
				componentToPage.LHStep4=false;
				calloutExcep=true;                    
				system.debug('@@@ inside --->');
			}
		}catch(Exception e)
		{
			componentToPage.LHStep1=false;
			componentToPage.LHStep2=false;
			componentToPage.LHStep3=true;
			componentToPage.LHStep4=false; 
			system.debug('@@@ outside --->'); 
			calloutExcep=true;
			//errormsg='Unable to reset your password.';
		}
		return null;
	}
	
	public String Cancel(){
		return null;
	}
}