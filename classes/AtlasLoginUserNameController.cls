/*********************************************************************************
Name         : AtlasLoginUserNameController
Created By   : Sujit Kumar
Company Name : NTT Data
Project      : ViaSat Atlas
Created Date : 25 May, 2014
Modified Date: 25 May, 2014
Usages       : Controller for VisualForce Page: ApexChangeLoginName
*********************************************************************************/
public with sharing class AtlasLoginUserNameController {
    
   public User userObj { get; private set;}
   public String newLoginUserName { get; set; }
   public String headerName { get; set; } 
   public AtlasComponenttoController componentToPage{get; set;}
     
   public AtlasLoginUserNameController() {
      headerName =  Apexpages.currentPage().getParameters().get('Name');
      loadUserObj();
   }
   
   public PageReference changeLoginUserName() {
      if (this.userObj.FederationIdentifier == null) {
         ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,
                                 AtlasUtility.getMapValue(AtlasConstants.ChangeUserName_Bad_Input_Exp)));
         return null;
      }
      
      // Validate the new username
      if(AtlasUtility.isEmpty(newLoginUserName)){
      	 ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,
                                 AtlasUtility.getMapValue(Atlasconstants.LOGIN_UNAME_REQD)));
         return null;
      }
      else if(newLoginUserName.length()<6 || newLoginUserName.length()>30){
      	ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,
                                 AtlasUtility.getMapValue(Atlasconstants.NEW_USER_UNAME_VALIDATION)));
         return null;
      }
      else if(newLoginUserName.contains(' ')){
      	ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,
                                 AtlasUtility.getMapValue(Atlasconstants.NEW_USER_UNAME_SPACEVALIDATION)));
         return null;
      }
      else{
      	String emailRegex = '^[a-zA-Z0-9|.|@]+$';
      	Pattern MyPattern = Pattern.compile(emailRegex);
      	Matcher MyMatcher = MyPattern.matcher(newLoginUserName);
      	 if (!MyMatcher.matches()){
      	 	ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,
                                 AtlasUtility.getMapValue(Atlasconstants.NEW_USER_UNAME_VALIDATION)));
         	return null;
      	 }
      }
      
      
      AtlasSSOWS.changeLoginUserNameResponse_element response = null;
      /* The exception handling in the catch block seems to be the same for all exceptions.
         Still catching all the exceptions individually instead of the generic Exception class.
      */
      try {
         response = AtlasIntegrationUtility.changeLoginUserName(userObj.FederationIdentifier, newLoginUserName);
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
                           AtlasUtility.getMapValue(AtlasConstants.ChangeUserName_Successful_Message)));
      loadUserObj();        
      return null;
   }
   
   private void loadUserObj() {
    String profileId = Apexpages.currentPage().getParameters().get('Id');
    this.userObj = [select Id, Account_Number__c, FederationIdentifier, Contact.Name, Contact.Email, Contact.Phone  
                      from User 
                      where Id = :profileId];
   }
   
   public PageReference backToSearch() {
        componentToPage.isComp1=true; 
        componentToPage.isComp2=false;
        componentToPage.isComp3=false; 
        componentToPage.isComp4=false;
        return null;
    } 
}