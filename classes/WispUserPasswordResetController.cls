/*********************************************************************************
Name         :WispUserPasswordResetController
Created By   : Tejesh Kumar
Company Name : CMC Americas
Project      : ViaSat WISP
Created Date : 24 Nov, 2014
Usages       : Controller for VisualForce Component: WispAdminResetPassword
*********************************************************************************/
public with sharing class WispUserPasswordResetController {
    
    public User userObj { get
                          {   system.debug('@@@--->'+profileId);
                              List<User> usrList = [select Id, Account_Number__c, FederationIdentifier, Contact.Name, Contact.Email, Contact.Phone  
                              from User 
                              where Id = :profileId];
                              return usrList[0];
                          } private set;}
                        
    public String newPassword { get; set; }  
    public AtlasComponenttoController componentToPage{get; set; }
    public String profileId{get; set; }
    public string loading{get{return AtlasUtility.getMapWispValue(Atlasconstants.Wisp_CTI_Loading);}set;}
    public string resetPswd{get{return AtlasUtility.getMapWispValue(Atlasconstants.Wisp_ResetPswd);}set;}
    public string userInfo{get{return AtlasUtility.getMapWispValue(Atlasconstants.Wisp_UserInfo);}set;}
    public string backtoSearch{get{return AtlasUtility.getMapWispValue(Atlasconstants.Wisp_BacktoSearch);}set;}
    public string genPswd{get{return AtlasUtility.getMapWispValue(Atlasconstants.Wisp_GenPswd);}set;}
    
    public WispUserPasswordResetController() {         
        this.newPassword = AtlasRandomPasswordGenerator.getRandomPassword(getPasswordMaxLength());
    }
   
    public PageReference resetPassword() {
        if (this.userObj.FederationIdentifier == null) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, AtlasUtility.getMapValue(AtlasConstants.ResetPassword_Bad_Input_Exp)));
            return null;
        }    
        AtlasSSOWS.resetPasswordResponse_element response = null;
      
        /* The exception handling in the catch block seems to be the same for all exceptions.
         Still catching all the exceptions individually instead of the generic Exception class.
        */
        try {
            response = AtlasIntegrationUtility.resetPassword(userObj.FederationIdentifier, newpassword, true);
        } 
        catch (AtlasException.CalloutException calloutEx) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, calloutEx.errorMessage));
            return null;
        } 
        catch (AtlasException.InvalidDataException invalidDataEx) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, invalidDataEx.errorMessage));
            return null;
        } 
        catch (AtlasException.GeneralException generalEx) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, generalEx.errorMessage));
            return null;
        }
      
        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, AtlasUtility.getMapValue(AtlasConstants.ResetPassword_Successful_Message) + ' ' + newpassword));
        return null;
    }
   
    public PageReference generatePassword() {
        System.debug('in generatePassword ...');
        this.newPassword = AtlasRandomPasswordGenerator.getRandomPassword(getPasswordMaxLength());
        return null;
    }
   
    private Integer getPasswordMaxLength() {
        Integer maxLength = 10; // default value
        try {
            maxLength = Integer.valueOf(AtlasUtility.getMapValue(AtlasConstants.ResetPassword_Max_Length));
        } catch (Exception typeEx) {
        // ignore, use default value
        }
        return maxLength;
    }
   
    public PageReference backToSearch() {
        componentToPage.isComp1=true; 
        componentToPage.isComp2=false;
        componentToPage.isComp3=false; 
        componentToPage.isComp4=false;
        return null;
    } 
}