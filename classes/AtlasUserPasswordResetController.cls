/*********************************************************************************
Name         : AtlasUserPasswordResetController
Created By   : Sujit Kumar
Company Name : NTT Data
Project      : ViaSat Atlas
Created Date : 25 May, 2014
Modified Date: 25 May, 2014
Usages       : Controller for VisualForce Page: AtlasUserPasswordReset
*********************************************************************************/
public with sharing class AtlasUserPasswordResetController {
    
   public User userObj { get; private set;}
   public String newPassword { get; set; }
   
   public AtlasUserPasswordResetController() {
      String profileId = Apexpages.currentPage().getParameters().get('Id');
      this.userObj = [select Id, Account_Number__c, FederationIdentifier, Contact.Name, Contact.Email, Contact.Phone  
                      from User 
                      where Id = :profileId];
                      
      this.newPassword = AtlasRandomPasswordGenerator.getRandomPassword(getPasswordMaxLength());
   }
   
   public PageReference resetPassword() {
   	if (this.userObj.FederationIdentifier == null) {
   		ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,
                                 AtlasUtility.getMapValue(AtlasConstants.ResetPassword_Bad_Input_Exp)));
         return null;
      }
      
      AtlasSSOWS.resetPasswordResponse_element response = null;
      
      // TODO: Comment out or remove debug statements
      System.debug('Invoking AIU.resetPassword with params: ' + 
                     userObj.FederationIdentifier + ', ' + newpassword);
      
      /* The exception handling in the catch block seems to be the same for all exceptions.
         Still catching all the exceptions individually instead of the generic Exception class.
      */
      try {
         response = AtlasIntegrationUtility.resetPassword(userObj.FederationIdentifier, newpassword, true);
      } catch (AtlasException.CalloutException calloutEx) {
         ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, calloutEx.errorMessage));
         return null;
      } catch (AtlasException.InvalidDataException invalidDataEx) {
         ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, invalidDataEx.errorMessage));
         return null;
      } catch (AtlasException.GeneralException generalEx) {
         ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, generalEx.errorMessage));
         return null;
      }
      
      ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,
                           AtlasUtility.getMapValue(AtlasConstants.ResetPassword_Successful_Message)));
      return null;
   }
   
   public PageReference generatePassword() {
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
}