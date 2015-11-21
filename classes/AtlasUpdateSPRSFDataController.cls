/*********************************************************************************
Name         : AtlasUpdateSPRSFDataController
Created By   : Srikanth Kudumula
Modified BY  : Srikanth Kudumula
Company Name : NTT Data
Project      : ViaSat Atlas
Created Date : 03/30/2015
Modified Date: 
Usages       : Schedulable class to update SPR and SF Data
*********************************************************************************/
global class AtlasUpdateSPRSFDataController implements Schedulable{
    global void execute(SchedulableContext ctx) {
        DateTime dt = System.now()-1;
        //Retrieve New User History Records created in past 24 hours
        List<New_User_Registration_History__c> nurtList = [select id,Account_Number__c,Subscriber_Key__c, Send_Email__c from New_User_Registration_History__c where Step4_Security_Questions__c =: true AND Step6_Account_Created__c =: false AND Send_Email__c =: false AND CreatedDate >: dt limit 20];
        for(New_User_Registration_History__c nurt: nurtList){
            callSPR(nurt.Id,nurt.Subscriber_Key__c,nurt.Account_Number__c);
        }// End For loop
    } // End Execute
    
    //Method to make callout
    @future(callout=true)
    public static void callSPR(Id nurtId, String subKey, String accNumber){
        AtlasSSOWS.getSubscriberResponse_element getSubscriberResponse;
        AtlasSSOWS.updateSubscriberResponse_element response;
        AtlasPublicWebServiceSearchServiceStub.findSubscribersBySearchCriteriaResponse findSubscriberResponse;
        string loginUsername = null;
        string securityQuestions = null;
        //make callout to SPR to check user name and password are populated successfully
        try{
            if (!Test.isRunningTest())
                getSubscriberResponse = AtlasIntegrationUtility.getSSOSubscriber(Long.ValueOf(subKey));  
            else                            
                getSubscriberResponse=(AtlasSSOWS.getSubscriberResponse_element)JSON.deserialize(AtlasTestConstants.getMetadata('getSubscriberResponse_element'),AtlasSSOWS.getSubscriberResponse_element.class);
                
            if(!AtlasUtility.isEmpty(getSubscriberResponse.subscriber.sprattributes.sprattribute)){
                for(AtlasSSOWS.sprAttributeType sprType : getSubscriberResponse.subscriber.sprattributes.sprattribute){
                    if(sprType.name.trim() == 'loginUserName'){ 
                        //sprType.value=null; -- Used for testing purpose. Manually setting the value to null
                        loginUsername = sprType.value;  
                    }                                                
                    if(sprType.name.trim() == 'securityQuestion'){
                        if(!AtlasUtility.isEmpty(sprType.values.value)){
                            string str='';
                            for(string objValue: sprType.values.value)
                            {
                                str+=objValue+'-';
                                securityQuestions=str;
                            }
                        }
                    }
                }
                //if LoginUsername or Security Questions = null clear SPR and SFdata
                if(AtlasUtility.isEmpty(loginUsername) || AtlasUtility.isEmpty(securityQuestions)){
                     response = AtlasIntegrationUtility.updateSubscriber(Long.ValueOf(subKey),null,null,null);
                     DeleteSFData(accNumber);
                     UpdateNewUserRegistrationHistory(nurtId,false,false);
                }
                else{//if SPR username and Sec questions exists, check SF data if not exists then create SF data
                    if (!Test.isRunningTest()) 
                        findSubscriberResponse = AtlasIntegrationUtility.findSubscribersBySearchCriteriaGeneric(null,null,'ACCOUNT',accNumber,null, null, null, null, null, null, null, null, null, null);
                    else
                        findSubscriberResponse=(AtlasPublicWebServiceSearchServiceStub.findSubscribersBySearchCriteriaResponse)JSON.deserialize(AtlasTestConstants.getMetadata('findSubscribersBySearchCriteriaResponse'),AtlasPublicWebServiceSearchServiceStub.findSubscribersBySearchCriteriaResponse.class);
                        CreateSFData(findSubscriberResponse,loginUsername);
                        UpdateNewUserRegistrationHistory(nurtId,true,true);
                }      
            }
        }//End Try
        Catch(Exception e){
            ViasatLogHandler.Log(AtlasConstants.SF_ORG_NAME, ViasatLogHandler.SeverityTypeEXCEPTION,'Atlas New User Registration Schedule Job - Callouts',e.getMessage());
        }           
    }
    
    //Method to delete SF data 
    public static void DeleteSFData(String internalAccountReference){
        String fedId=null;
        //Check whether SF record exists
        List<user> u = [select id,IsActive,IsPortalEnabled,contact.account.Id,CommunityNickname,FederationIdentifier,ExternalAccountReference__c,Username,Account_Number__c from User where Account_Number__c =: internalAccountReference Limit 1];
        if(!AtlasUtility.isEmpty(u)){    
            fedId = u[0].FederationIdentifier;
            u[0].IsActive = false;
            u[0].IsPortalEnabled = false;
            u[0].FederationIdentifier = '';
            u[0].ExternalAccountReference__c = '';
            u[0].Account_Number__c = '';
            string rand = String.valueOf(Math.round(Math.random()*1000));
            u[0].CommunityNickname = u[0].CommunityNickname+rand;
            u[0].Username = u[0].Username+rand;
            
            try{
                update u; // Disable portal user 
                deleteAccount(u[0].contact.Account.Id); // delete Account
            }
            catch(exception e){
                ViasatLogHandler.Log(AtlasConstants.SF_ORG_NAME, ViasatLogHandler.SeverityTypeEXCEPTION,'Atlas New User Registration Schedule Job - Disable User and Delete Account',e.getMessage());
            }
        }       
    }
    
    //Delete Account record
    @future
    public static void deleteAccount(Id accId){
        try{ 
            Account a = [select id  from account where id =: accId limit 1];
            delete a; //Delete account contact will get deleted automatically
        }catch(exception e){ 
            ViasatLogHandler.Log(AtlasConstants.SF_ORG_NAME, ViasatLogHandler.SeverityTypeEXCEPTION,'Atlas New User Registration Schedule Job - Delete Account',e.getMessage());
        }
    }
    
    //Mehtod to update New User Registration History Records
    public static void UpdateNewUserRegistrationHistory(id nurtId, boolean Step5, boolean Step6){
        List<New_User_Registration_History__c> nurhList = [select id, Step5_Confirmation_Email__c, Step6_Account_Created__c, Send_Email__c from New_User_Registration_History__c where id =: nurtId limit 1];
        if(!AtlasUtility.isEmpty(nurhList)){
            nurhList[0].Send_Email__c = true;
            nurhList[0].Step5_Confirmation_Email__c = Step5;
            nurhList[0].Step6_Account_Created__c = Step6;
        }
        try{
            update nurhList;
        }
        Catch(Exception e){
            ViasatLogHandler.Log(AtlasConstants.SF_ORG_NAME, ViasatLogHandler.SeverityTypeEXCEPTION,'Atlas New User Registration Schedule Job - Update New User Registraiton History',e.getMessage());
        }
    }
    
    //Method to Create SF records
    public static void CreateSFData(AtlasPublicWebServiceSearchServiceStub.findSubscribersBySearchCriteriaResponse findSubscriberResponse, String loginUsername){
        AtlasPublicWebServiceSearchServiceStub.Subscriber cusInfoObj=findSubscriberResponse.subscriber[0];
        List<user> u = [select id,IsActive,IsPortalEnabled,contact.account.Id,CommunityNickname,FederationIdentifier,ExternalAccountReference__c,Username,Account_Number__c from User where Account_Number__c =: cusInfoObj.account.internalAccountReference Limit 1];
        if(AtlasUtility.isEmpty(u)){
            try{    
                //Create Account
                Account accObj=new Account();
                accObj.Name=cusInfoObj.contact.person.firstName+' '+cusInfoObj.contact.person.lastName;
                accObj.Status__c='Customer';
                accObj.Country__c='United States';
                accObj.Type='End-User';
                accObj.Industry='Commercial';
                accObj.CurrencyIsoCode = 'USD';
                accObj.OwnerId = AtlasUtility.getMapValue(AtlasConstants.Account_Owner);
                insert accObj;
                //Create Contact
                Contact conObj= new Contact();
                conObj.LastName=cusInfoObj.contact.person.firstName+' '+cusInfoObj.contact.person.lastName;
                conObj.AccountId=accObj.id;
                conObj.ExternalAccountReference__c=cusInfoObj.account.externalAccountReference;
                string externalAccRef = cusInfoObj.account.externalAccountReference.trim();
                externalAccRef = externalAccRef.replaceAll('(\\s+)', ' ');
                externalAccRef = externalAccRef.replaceAll('['+AtlasUtility.getMapValue(AtlasConstants.Disallowed_New_User_Special_Characters)+']','');
                conObj.Email=cusInfoObj.contact.emailAddress;
                conObj.Phone=cusInfoObj.contact.primaryPhoneNumber;
                conObj.Account_Number__c=cusInfoObj.account.internalAccountReference;
                conObj.FirstName = cusInfoObj.contact.person.firstName;
                conObj.LastName = cusInfoObj.contact.person.lastname;
                conObj.OwnerId = AtlasUtility.getMapValue(AtlasConstants.Account_Owner);
                insert conObj;
                //Create User
                //to insert user 
                User userObj = new User();
                userObj.FederationIdentifier= loginUsername;
                userObj.ExternalAccountReference__c = cusInfoObj.account.externalAccountReference;
                userObj.Email = externalAccRef+AtlasUtility.getMapValue(AtlasConstants.New_User_Email_Domain);
                userObj.Username = externalAccRef+AtlasUtility.getMapValue(AtlasConstants.New_User_Email_Domain);
                userObj.Lastname =cusInfoObj.contact.person.lastName;
                userObj.Firstname = cusInfoObj.contact.person.firstName;
                userObj.ContactId=conObj.Id;
                if(cusInfoObj.contact.person.lastName.length() > 4)
                {
                    userObj.Alias = cusInfoObj.contact.person.firstName.substring(0,1)+cusInfoObj.contact.person.lastName.substring(0, 4);
                }
                else
                {
                    userObj.Alias = cusInfoObj.contact.person.firstName.substring(0,1) + cusInfoObj.contact.person.lastName ;
                }
                if(cusInfoObj.account.externalAccountReference.length() > 40)
                {
                    userObj.CommunityNickname = cusInfoObj.account.externalAccountReference.substring(0,40);
                }
                else
                {
                    userObj.CommunityNickname = cusInfoObj.account.externalAccountReference;
                }
                string profileId = atlasutility.getMapValue(atlasconstants.Atlas_Community_Profile);
                SObject prof = [ select id from profile where Id =: profileId];
                userObj.ProfileId = (ID) prof.get('ID');
                userObj.TimeZoneSidKey = 'America/Los_Angeles';
                userObj.LocaleSidKey = 'en_US';
                userObj.EmailEncodingKey = 'ISO-8859-1';
                userObj.LanguageLocaleKey = 'en_US';
                userObj.UserPermissionsMobileUser = false;
                userObj.Account_Number__c=cusInfoObj.account.internalAccountReference;
                userObj.CommunityUserAccountType__c = 'EXEDE';
                userObj.Functional_Group__c = 'Customer Portal';
                userObj.Assignment_Group_Active__c = false;
                insert userObj;
            }
            catch(exception e){
                ViasatLogHandler.Log(AtlasConstants.SF_ORG_NAME, ViasatLogHandler.SeverityTypeEXCEPTION,'Atlas New User Registration Schedule Job - SF Data Creation',e.getMessage());
            }
        }
    }
}