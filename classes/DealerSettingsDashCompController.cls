/**************************************************************************************************************
Name         : DealerSettingsDashCompController (Dealer Settings Dashboard Component Controller)
Created By   : Jim Tunney
Modified By  : 
Project      : Dealer Portal
Created Date : 16 Nov 2015
Modified Date: 
Usages       : Controller for DealerSettingsDashboardComponent, a component to the VF page: DealerSettingsPage.
***************************************************************************************************************/  
public with sharing class DealerSettingsDashCompController {
	public DealerComponenttoController componentToPage{get; set;}
    
    /***** Note: values contained in the DealerKeyValueStore Custom Settings *****/
    public string buttonCancel {get {return DealerUtility.getMapValue(DealerConstants.ButtonCancel);} set;} //displays text on Cancel button
    public string buttonEditMyDTVNum {get {return DealerUtility.getMapValue(DealerConstants.ButtonEditMyDTVNum);} set;} //displays text on Edit my DIRECTV button
    public string buttonEditMyPW {get {return DealerUtility.getMapValue(DealerConstants.ButtonEditMyPW);} set;} //displays text on Edit my Password button
    public string buttonEditMySecQuest {get {return DealerUtility.getMapValue(DealerConstants.ButtonEditMySecQuest);} set;} //displays text on Edit my Security Questions button
    public string buttonSubmit {get {return DealerUtility.getMapValue(DealerConstants.ButtonSubmit);} set;} //displays text on Submit button
    public string currentPW {get {return DealerUtility.getMapValue(DealerConstants.CurrentPW);} set;} //displays "Current Password"
    public string dealerDashMainHeader {get {return DealerUtility.getMapValue(DealerConstants.DealerDashMainHeader);} set;} //displays "Dealer Settings"(h1)
    public string DIRECTVLabel {get {return DealerUtility.getMapValue(DealerConstants.DIRECTV);} set;} //displays "DIRECTV"
    public string forAdditionalHelp_DlrSettings {get {return DealerUtility.getMapValue(DealerConstants.ForAdditionalHelp_DlrSettings);} set;} //displays "DIRECTV"
    public string newDirecTVDealerNumber {get {return DealerUtility.getMapValue(DealerConstants.NewDirecTVDealerNumber);} set;} //displays "New DIRECTV Dealer Number" 
    public string newPW {get {return DealerUtility.getMapValue(DealerConstants.NewPassword);} set;} //displays "New Password"
    public string noteLabel {get {return DealerUtility.getMapValue(DealerConstants.NoteLabel);} set;} //displays "Note:"
    public string pwRule1Text {get {return DealerUtility.getMapValue(DealerConstants.PasswordRule1Text);} set;} //displays first PW Rule
    public string pwRule2Text {get {return DealerUtility.getMapValue(DealerConstants.PasswordRule2Text);} set;} //displays second PW Rule
    public string pwRule3Text {get {return DealerUtility.getMapValue(DealerConstants.PasswordRule3Text);} set;} //displays third PW Rule
    public string pwRule4Text {get {return DealerUtility.getMapValue(DealerConstants.PasswordRule4Text);} set;} //displays fourth PW Rule
    public string resetDTVID {get {return DealerUtility.getMapValue(DealerConstants.ResetDTVID);} set;} //displays "Reset Your DIRECTV ID"(h6)
    public string resetSecQuestRule {get {return DealerUtility.getMapValue(DealerConstants.ResetSecQuestRule);} set;} //displays rule for resetting security questions
    public string resetYourPW {get {return DealerUtility.getMapValue(DealerConstants.ResetYourPW);} set;} //displays "Reset Your Password"(h6)
    public string resetYourSecQuest {get {return DealerUtility.getMapValue(DealerConstants.ResetYourSecQuest);} set;} //displays "Reset Your Security Questions"(h6)
    public string retypeNewPW {get {return DealerUtility.getMapValue(DealerConstants.RetypeNewPassword);} set;} //displays "Retype New Password"    
    public string secQuest1{get {return DealerUtility.getMapValue(DealerConstants.SecurityQuestion1);} set;} //Displays first security question
    public string secQuest2{get {return DealerUtility.getMapValue(DealerConstants.SecurityQuestion2);} set;} //Displays second security question
    public string secQuest3{get {return DealerUtility.getMapValue(DealerConstants.SecurityQuestion3);} set;} //Displays third security question
    public string secQuest4{get {return DealerUtility.getMapValue(DealerConstants.SecurityQuestion4);} set;} //Displays fourth security question
    public string secQuest5{get {return DealerUtility.getMapValue(DealerConstants.SecurityQuestion5);} set;} //Displays fifth security question
    public string secQuest6{get {return DealerUtility.getMapValue(DealerConstants.SecurityQuestion6);} set;} //Displays sixth security question
    public string securityQuestionNote{get {return DealerUtility.getMapValue(DealerConstants.SecurityQuestionNote);} set;} //Displays security question note to user
    public string serviceDeskEmailAddy {get {return DealerUtility.getMapValue(DealerConstants.ServiceDeskEmailAddy);} set;} //displays "DIRECTV"
    public string theNewPW {get {return DealerUtility.getMapValue(DealerConstants.TheNewPW);} set;} //displays "The New Password:"
    
    
    //used to determine which cancel button was clicked
    public string idCancelButton{get;set;}
    
    //used to determine which submit button was clicked
    public string idSubmitButton{get;set;}
    
    /**
     * Constructor.
     * 
     */
    public DealerSettingsDashCompController() {
        componentToPage = new DealerComponenttoController();
        componentToPage.isResetPW = false;
        componentToPage.isResetSecQuest = false;
        componentToPage.isResetDTV = false;
    }
    
    //Toggles boolean that controls display of edit password section
    public pageReference editPWButton() {
        componentToPage.isResetPW = true;
        
        return null;
    }
    
    //Toggles boolean that controls display of edit security questions section
    public pageReference editSecQuestButton() {
        componentToPage.isResetSecQuest = true;
        
        return null;
    }

    //Toggles boolean that controls display of edit DIRECTV number section 
    public pageReference editDTVButton() {
        componentToPage.isResetDTV = true;
        
        return null;
    }
    
    //Handles action when any cancel button is clicked. Identifies which cancel button was clicked then toggles corresponding boolean to hide that section.
    public pageReference cancelButton() { 
    	if(idCancelButton.toLowercase()=='pwcancel') {
    		componentToPage.isResetPW = false;
    	}
    	else if(idCancelButton.toLowercase()=='secquestcancel') {
    		componentToPage.isResetSecQuest = false;
    	}
    	else {componentToPage.isResetDTV = false;}
    	
    	return null;
    }
    
    //Handles action when any submit button is clicked. Identifies which submit button was clicked then processes the submission. Lastly, toggles boolean to hide that section.
    public pageReference submitButton() {
        if(idSubmitButton.toLowercase()=='pwsubmit') {
            //CODE TO HANDLE UPDATING PW HERE
    		componentToPage.isResetPW = false;
    	}
    	else if(idSubmitButton.toLowercase()=='secquestsubmit') {
            //CODE TO HANDLE UPDATING SECURITY QUESTIONS HERE
    		componentToPage.isResetSecQuest = false;
    	}
    	else {
            //CODE TO HANDLE UPDATING DIRECTV NUMBER HERE
            componentToPage.isResetDTV = false;
        }
        
    	return null;
    }
    
}