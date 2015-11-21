/*********************************************************************************
Name         : AtlasMoveInternalAccountController
Created By   : Sujit Kumar
Company Name : NTT Data
Project      : ViaSat Atlas
Created Date : 25 June, 2014
Modified Date: 25 June, 2014
Usages       : Controller for VisualForce Page: AtlasMoveInternalAccount
*********************************************************************************/
public with sharing class AtlasMoveInternalAccountController {
    
   public User userObj { get; set; }
   
   public String newInternalAccountNumber { get; set; }
   
   public AtlasMoveInternalAccountController() {
      loadUserObj();
   }
   
   
   public PageReference moveInternalAccount() {
      if (AtlasUtility.isEmpty(newInternalAccountNumber)) {
         ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,
                              AtlasUtility.getMapValue(AtlasConstants.MoveInternalAccount_Bad_Input_Exp)));
         return null;
      }
      
      AtlasSyncSFDC syncSFDC = new AtlasSyncSFDC();
      String oldInternalAccountNumber = userObj.Account_Number__c;
      Boolean moveStatus = syncSFDC.moveInternalAccountNumber(newInternalAccountNumber, oldInternalAccountNumber);
      System.debug('move status: ' + moveStatus);
      
      if (moveStatus) {
         ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,
                           AtlasUtility.getMapValue(AtlasConstants.MoveInternalAccount_Successful_Message)));
      } else {
         ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,
                           AtlasUtility.getMapValue(AtlasConstants.MoveInternalAccount_Failed_Message)));      	
      }
      
      loadUserObj();      	
      return null;
   }
   
   private void loadUserObj() {
      String profileId = Apexpages.currentPage().getParameters().get('Id');
      this.userObj = [select Id, Account_Number__c, FederationIdentifier, Contact.Name, Contact.Email, Contact.Phone, Phone  
                      from User 
                      where Id = :profileId];
   }
}