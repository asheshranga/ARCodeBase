/*********************************************************************************
Name         : WispLoginUserNameController
Created By   : Tejesh Kumar
Company Name : NTT Data
Project      : ViaSat Atlas
Created Date : 24 November, 2014
Usages       : Controller for VisualForce Comp: WispAdminChangeUname
*********************************************************************************/
public with sharing class WispLoginUserNameController {
    
   public User userObj { get
                          {   system.debug('@@@--->'+profileId);
                              List<User> usrList = [select Id, Account_Number__c, FederationIdentifier, Contact.Name, Contact.Email, Contact.Phone  
                              from User 
                              where Id = :profileId];
                              return usrList[0];
                          } private set;}
                          
   public String newLoginUserName { get; set; } 
   public AtlasComponenttoController componentToPage{get; set;}
   public String profileId{get; set;}
   public string loading{get{return AtlasUtility.getMapWispValue(Atlasconstants.Wisp_CTI_Loading);}set;}
   public string UserInfo{get{return AtlasUtility.getMapWispValue(Atlasconstants.Wisp_UserInfo);}set;}
   public string ChangeLoginUname{get{return AtlasUtility.getMapWispValue(Atlasconstants.Wisp_ChangeLoginUname);}set;}
   public string backtoSearch{get{return AtlasUtility.getMapWispValue(Atlasconstants.Wisp_BacktoSearch);}set;}
     
   public WispLoginUserNameController() {
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
      	system.debug('@@@ usename length--->'+newLoginUserName.length());
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
      return null;
   }
   
   public PageReference backToSearch() {
        componentToPage.isComp1=true; 
        componentToPage.isComp2=false;
        componentToPage.isComp3=false; 
        componentToPage.isComp4=false;
        return null;
    } 
}