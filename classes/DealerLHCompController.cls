public with sharing class DealerLHCompController{
/*********************************************************************************
    Name         : DealerLHCompController (Dealer Login Help Component Controller)
    Created By   : Jim Tunney
    Company Name : ViaSat, Inc.
    Project      : Dealer Pages
    Created Date : 9 Oct 2015
    *********************************************************************************/
    
    /***** Note: all variables' values contained in the DealerKeyValueStore Custom Settings *****/
    public string buttonCancelLabel{get {return DealerUtility.getMapValue(DealerConstants.ButtonCancel);} set;} //Displays "Cancel"     
    public string buttonNextLabel{get {return DealerUtility.getMapValue(DealerConstants.ButtonNext);} set;} //Displays "Next" 
	public string buttonRetToLogLabel{get {return DealerUtility.getMapValue(DealerConstants.ButtonReturnToLogin);} set;} //Displays "Return to Login" 
    public string loginHelpLabel{get {return DealerUtility.getMapValue(DealerConstants.LoginHelp);} set;} //Displays "Login Help"
    public string loginHelpH1Label{get {return DealerUtility.getMapValue(DealerConstants.LoginHelpH1);} set;} //Displays Login Help H1 header 
    public string loginHelpH2Label{get {return DealerUtility.getMapValue(DealerConstants.LoginHelpH2);} set;} //Displays Login Help H2 header 
    public string newPWLabel{get {return DealerUtility.getMapValue(DealerConstants.NewPassword);} set;} //Displays "New Password"
    public string pgBottomMsgNewPW{get {return DealerUtility.getMapValue(DealerConstants.PgBottomMsgNewPW);} set;} //Displays msg at bottom of New Password Page
    public string pgBottomMsgSecQuest{get {return DealerUtility.getMapValue(DealerConstants.PgBottomMsgSecQuest);} set;} //Displays msg at bottom of Security Questions 'page'
    public string pgBottomMsgSecQuestError{get {return DealerUtility.getMapValue(DealerConstants.PgBottomMsgSecQuestError);} set;} //Displays msg at bottom of Security Questions Error 'page'
    public string pgBottomMsgUName{get {return DealerUtility.getMapValue(DealerConstants.PgBottomMsgUName);} set;} //Displays msg at bottom of Username 'page'
    public string resetPWSuccessH2Label{get {return DealerUtility.getMapValue(DealerConstants.ResetPWSuccessH2);} set;} //Displays PW Reset Success header
    public string retypeNewPWLabel{get {return DealerUtility.getMapValue(DealerConstants.RetypeNewPassword);} set;} //Displays "Retype New Password"
    public string securityQuestionNoteLabel{get {return DealerUtility.getMapValue(DealerConstants.SecurityQuestionNote);} set;} //Displays security question note to user     
    public string serviceDeskEmailLabel{get {return DealerUtility.getMapValue(DealerConstants.ServiceDeskEmailAddy);} set;} //Displays help desk email address
    public string usernameLabel{get {return DealerUtility.getMapValue(DealerConstants.Username);} set;} //Displays "Username"
     
}