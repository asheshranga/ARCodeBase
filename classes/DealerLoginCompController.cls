public with sharing class DealerLoginCompController {
/*********************************************************************************
    Name         : DealerLHCompController
    Created By   : Jim Tunney
    Company Name : ViaSat, Inc.
    Project      : Dealer Pages
    Created Date : 12 Oct 2015
    *********************************************************************************/
    
    /***** Note: all variables' values contained in the DealerKeyValueStore Custom Settings *****/
    public string buttonCancelLabel{get {return DealerUtility.getMapValue(Dealerconstants.ButtonCancel);} set;} //Displays "Cancel"
    public string buttonNextLabel{get {return DealerUtility.getMapValue(Dealerconstants.ButtonNext);} set;} //Displays "Next"
    public string buttonSecFirstLabel{get {return DealerUtility.getMapValue(Dealerconstants.ButtonSecurityFirst);} set;} //Displays "Set Questions and Enter Portal" for button on Security Question First Time Page
    public string buttonSubmitLabel{get {return DealerUtility.getMapValue(Dealerconstants.ButtonSubmit);} set;} //Displays "Submit" 
    public string loginHelpLabel{get {return DealerUtility.getMapValue(DealerConstants.LoginHelp);} set;} //Displays "Login Help"
    public string newPWLabel{get {return DealerUtility.getMapValue(DealerConstants.NewPassword);} set;} //Displays "New Password"
    public string noteLabel {get {return DealerUtility.getMapValue(DealerConstants.NoteLabel);} set;} //displays "Note:"    
    public string oldPWLabel{get {return DealerUtility.getMapValue(DealerConstants.OldPassword);} set;} //Displays "Old Password"
    public string passwordLabel{get {return DealerUtility.getMapValue(DealerConstants.Password);} set;} //Displays "Password"
    public string pgBottomMsgResetPW{get {return DealerUtility.getMapValue(DealerConstants.PgBottomMsgResetPW);} set;} //Displays msg at bottom of Reset Password Page
    public string pgBottomMsgSecQuest1st{get {return DealerUtility.getMapValue(DealerConstants.PgBottomMsgSecQuest1st);} set;} //Displays msg at bottom of Security Questions 1st Time 'page'
    public string retypeNewPWLabel{get {return DealerUtility.getMapValue(DealerConstants.RetypeNewPassword);} set;} //Displays "Retype New Password"
    public string secQuest1Label{get {return DealerUtility.getMapValue(DealerConstants.SecurityQuestion1);} set;} //Displays first security question
    public string secQuest2Label{get {return DealerUtility.getMapValue(DealerConstants.SecurityQuestion2);} set;} //Displays second security question
    public string secQuest3Label{get {return DealerUtility.getMapValue(DealerConstants.SecurityQuestion3);} set;} //Displays third security question
    public string secQuest4Label{get {return DealerUtility.getMapValue(DealerConstants.SecurityQuestion4);} set;} //Displays fourth security question
    public string secQuest5Label{get {return DealerUtility.getMapValue(DealerConstants.SecurityQuestion5);} set;} //Displays fifth security question
    public string secQuest6Label{get {return DealerUtility.getMapValue(DealerConstants.SecurityQuestion6);} set;} //Displays sixth security question
    public string secQuest7Label{get {return DealerUtility.getMapValue(DealerConstants.SecurityQuestion7);} set;} //Displays seventh security question    
    public string securityQuestionNoteLabel{get {return DealerUtility.getMapValue(DealerConstants.SecurityQuestionNote);} set;} //Displays security question note to user
    public string serviceDeskEmailLabel{get {return DealerUtility.getMapValue(DealerConstants.ServiceDeskEmailAddy);} set;} //Displays help desk email address
    public string usernameLabel{get {return DealerUtility.getMapValue(DealerConstants.Username);} set;} //Displays "Username"
    
    
}