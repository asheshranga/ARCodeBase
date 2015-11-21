/*********************************************************************************
Name         : DealerResetPasswordStep2Controller
Created By   : Srikanth Kudumula
Modified BY  : 
Company Name : NTT Data
Project      : Dealer Portal
Created Date : 10/19/2015
Modified Date: 
Usages       : Controller for VisualForce Component: DealerResetPasswordStep2
*********************************************************************************/
public with sharing class DealerResetPasswordStep2Controller {
	public DealerComponenttoController componentToPage{get; set;}//Apex class is used to find the steps(1,2,3,4..)
	public string loginLabel{get {return DealerUtility.getMapValue(DealerConstants.LoginLabel);} set;} //Displays "Login"
	public string loginHelpLabel{get {return DealerUtility.getMapValue(DealerConstants.LoginHelp);} set;} //Displays "Login Help"
	public string loginHelpH1Label{get {return DealerUtility.getMapValue(DealerConstants.LoginHelpH1);} set;} //Displays Login Help H1 header 
	public string loginHelpH2Label{get {return DealerUtility.getMapValue(DealerConstants.LoginHelpH2);} set;} //Displays Login Help H2 header
	public string LoginHelpPMsg{get {return DealerUtility.getMapValue(DealerConstants.LoginHelpPMsg);} set;} //Displays  generic paragraph message
	public string loginHelpH4Label{get {return DealerUtility.getMapValue(DealerConstants.LoginHelpH4Label);} set;} //Displays Login Help H4 header  
	public string serviceDeskEmailLabel{get {return DealerUtility.getMapValue(DealerConstants.ServiceDeskEmailAddy);} set;} //Displays help desk email address
	public string securityQuestionNoteLabel{get {return DealerUtility.getMapValue(DealerConstants.SecurityQuestionNote);} set;} //Displays security question note to user    
	public string pgBottomMsgSecQuest{get {return DealerUtility.getMapValue(DealerConstants.PgBottomMsgSecQuest);} set;} //Displays msg at bottom of Security Questions 'page'
	public string pgBottomMsgSecQuestError{get {return DealerUtility.getMapValue(DealerConstants.PgBottomMsgSecQuestError);} set;} //Displays msg at bottom of Security Questions Error 'page'
	public string buttonNextLabel{get {return DealerUtility.getMapValue(DealerConstants.ButtonNext);} set;} //Displays "Next" 
	public string buttonCancelLabel{get {return DealerUtility.getMapValue(DealerConstants.ButtonCancel);} set;} //Displays "Cancel"     
	public string Question1Label{get {return DealerUtility.getMapValue(DealerConstants.Question1Label);} set;} //Displays Login Help Question1 Label  
	public string Question2Label{get {return DealerUtility.getMapValue(DealerConstants.Question2Label);} set;} //Displays Login Help Question2 Label  
	public string Question3Label{get {return DealerUtility.getMapValue(DealerConstants.Question3Label);} set;} //Displays Login Help Question3 Label  
	public string NoteLabel{get {return DealerUtility.getMapValue(DealerConstants.NoteLabel);} set;} //Displays Login Help Note Label  
	public string LoginHelpSQH3Label{get {return DealerUtility.getMapValue(DealerConstants.LoginHelpSQH3Label);} set;} //Displays Login Help SQ H3 header
	public string LoginHelpSQError{get {return DealerUtility.getMapValue(DealerConstants.LoginHelpSQError);} set;} //Displays Login Help SQ Error 
	public string Answer1Label{get {return DealerUtility.getMapValue(DealerConstants.Answer1Label);} set;} //Displays Login Help Answer1 Label 
	public string Answer2Label{get {return DealerUtility.getMapValue(DealerConstants.Answer2Label);} set;} //Displays Login Help Answer2 Label
	public string Answer3Label{get {return DealerUtility.getMapValue(DealerConstants.Answer3Label);} set;} //Displays Login Help Answer3 Label
	public string FieldsRequiredGeneralMsg{get {return DealerUtility.getMapValue(DealerConstants.FieldsRequiredGeneralMsg);} set;} //Displays generic message when field are required
	public string sqAnswer1{get;set;}
	public string sqAnswer2{get;set;}
	public string sqAnswer3{get;set;}
	public string maskedSQAnswer1{get;set;}
	public string maskedSQAnswer2{get;set;}
	public string maskedSQAnswer3{get;set;}
	public boolean isSQAError{get;set;}
	public boolean isSQError{get;set;}
	
	public DealerResetPasswordStep2Controller(){
		isSQAError = false;
	}
	
	public pageReference NextStep2(){
		if(componentToPage.securityQA1 == sqAnswer1 && componentToPage.securityQA2 == sqAnswer2 && componentToPage.securityQA3 == sqAnswer3)
		{
			componentToPage.LHStep1 = false;
			componentToPage.LHStep2 = false;
			componentToPage.LHStep3 = true;
			componentToPage.LHStep4 = false;
			return null;
		}
		else
		{
			isSQAError = true;
			componentToPage.LHStep1 = false;
			componentToPage.LHStep2 = true;
			componentToPage.LHStep3 = false;
			componentToPage.LHStep4 = false;
			return null;
		}
	}
	
	public String Cancel(){
		return null;
	}
}