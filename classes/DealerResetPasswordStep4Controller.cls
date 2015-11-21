/*********************************************************************************
Name         : DealerResetPasswordStep4Controller
Created By   : Srikanth Kudumula
Modified BY  : 
Company Name : NTT Data
Project      : Dealer Portal
Created Date : 10/19/2015
Modified Date: 
Usages       : Controller for VisualForce Component: DealerResetPasswordStep4
*********************************************************************************/
public with sharing class DealerResetPasswordStep4Controller {
	public DealerComponenttoController componentToPage{get; set;}//Apex class is used to find the steps(1,2,3,4..)
	public string loginHelpLabel{get {return DealerUtility.getMapValue(DealerConstants.LoginHelp);} set;} //Displays "Login Help"
	public string loginHelpH1Label{get {return DealerUtility.getMapValue(DealerConstants.LoginHelpH1);} set;} //Displays Login Help H1 header 
	public string buttonRetToLogLabel{get {return DealerUtility.getMapValue(DealerConstants.ButtonReturnToLogin);} set;} //Displays "Return to Login"
	public string resetPWSuccessH2Label{get {return DealerUtility.getMapValue(DealerConstants.ResetPWSuccessH2);} set;} //Displays PW Reset Success header
}