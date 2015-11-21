public with sharing class AtlasNewUserEmailController{
    
    public string emailReqd{get{return AtlasUtility.getMapValue(Atlasconstants.EMAIL_REQD);}set;}
    public string cemailReqd{get{return AtlasUtility.getMapValue(Atlasconstants.CEMAIL_REQD);}set;}
    public string cemail{get{return AtlasUtility.getMapValue(Atlasconstants.PLS_CNFM_EMAIL);}set;}
    public string emailInfo{get{return AtlasUtility.getMapValue(Atlasconstants.EMAIL_INFO);}set;}
    public string emailInfo1{get{return AtlasUtility.getMapValue(Atlasconstants.EMAIL_INFO1);}set;}
    public string validemail{get{return AtlasUtility.getMapValue(Atlasconstants.PLS_EMAIL_VALID);}set;}
    public string EmailPlaceHolder{get{return AtlasUtility.getMapValue(AtlasConstants.EMAIL_PLACE_HOLDER);}set;}
    public string emailText{get{return Atlasconstants.EMAIL_LABEL;}set;}
    public string cemailText{get{return Atlasconstants.C_EMAIL_TEXT;}set;}
    public string emailId{get;set;}
    public string ConfirmEmailId{get;set;}
    public string emailId1{get;set;}
    public string ConfirmEmailId1{get;set;}
    public string emailId2{get;set;}
    public string ConfirmEmailId2{get;set;}
    public boolean isEdit{get;set;}
    public string emailExceptionErrorMsg {get{ return AtlasUtility.getMapValue(AtlasConstants.Atlas_User_Creation_Exception); } set;}
    public AtlasComponenttoController componentToPage{get; set;}
    String email = '';
    public string errorMessage{get;set;}
    public boolean isError{get;set;}
    public boolean isEmailIdWrong{get;set;}
    public string knowledgeBaseURL{get{ return AtlasUtility.getURL(AtlasConstants.KNOWLEDGE_BASE);}set;}
    public string ATLAS_LOGIN{get{ return AtlasUtility.getURL(AtlasConstants.ATLAS_LOGIN);}set;}
    public boolean noEmailId{get{ return (AtlasUtility.isEmpty(componentToPage.emailId) || (componentToPage.emailId.containsIgnoreCase(AtlasUtility.getMapValue(AtlasConstants.Atlas_Change_Email_Address))));}set;}
    public string eemail{get{return AtlasUtility.getMapValue(Atlasconstants.PLS_ENTER_EMAIL);}set;}
    public string emailHelpText{get{ return AtlasUtility.getMapValue(AtlasConstants.EMAIL_HELP_TEXT);}set;}
    public string emailEditMsg{get{ return AtlasUtility.getMapValue(AtlasConstants.Email_Info_Edit_Msg);} set;}
    public string stripCharacters{get{return AtlasUtility.getMapValue(AtlasConstants.Disallowed_New_User_Special_Characters);}set;}
    public string emailDomain{get{return AtlasUtility.getMapValue(AtlasConstants.New_User_Email_Domain);}set;}
    PageReference pageRef = Page.AtlasNewUserEmailException;
    boolean isUpdateSubscriberException = false;
    boolean isSaveSecurityQuestionsException = false;
    boolean isUpdateCustomerInfoException = false;
    boolean isCalloutException = false;
    AtlasSSOWS.securityQuestionType qsType1= new AtlasSSOWS.securityQuestionType();
    AtlasSSOWS.securityQuestionType qsType2= new AtlasSSOWS.securityQuestionType();
    List<AtlasSSOWS.securityQuestionType> lstQuestionAnswer= new list<AtlasSSOWS.securityQuestionType>();
    AtlasSSOWS.securityQuestionsType lstQSType= new AtlasSSOWS.securityQuestionsType();
    AtlasSSOWS.updateSubscriberResponse_element response;
    
    public AtlasNewUserEmailController()
    {
        isEdit=false;
    }
    
    public pagereference Edit()
    {
        isEdit=true;
        isEmailIdWrong=false;
        errorMessage='';
        return null;
    }
    
    public pagereference Confirm()
    {
        //variables for response
        AtlasSSOWS.saveSecurityQuestionsResponse_element responseObj;
        string Objresponse;
        if(isEdit || noEmailId){
            emailId1=emailId1.trim();
            emailId1=emailId1.replaceAll('(\\s+)', ' ');
            email=emailId1;
        }
        else{
            email=componentToPage.emailId;
            isEmailIdWrong=false;
            errorMessage='';
        }
        if(!AtlasUtility.isEmpty(email))
        {
            string[] email1=email.split('@');
            if(email.length()>80)
            {
                isEmailIdWrong=true;
                errorMessage=AtlasUtility.getMapValue(Atlasconstants.CNFM_EMAIL_VAIDATION);
                createnewUserRegistrationHistory(email,false,false,errorMessage);
                return null;
            }
            else if(email1[0].equalsIgnoreCase(AtlasUtility.getMapValue(Atlasconstants.PLS_CHNG_EMAIL_ADD)))
            {
                isEmailIdWrong=true;
                errorMessage=AtlasUtility.getMapValue(Atlasconstants.PLS_EMAIL_VALID);
                createnewUserRegistrationHistory(email,false,false,errorMessage);
                return null;
            }
        }
        else
        {
            isEmailIdWrong=true;
            errorMessage=AtlasUtility.getMapValue(Atlasconstants.NO_EMAIL_ID);
            createnewUserRegistrationHistory(email,false,false,errorMessage);
            return null;
        }   
        // to upadte email id in legacy s/y
        if(!AtlasUtility.isEmpty(componentToPage.externalAccReference) && !AtlasUtility.isEmpty(componentToPage.externalSystemName) && !AtlasUtility.isEmpty(email)) 
        {
            try
            {
                //to call update subscriber...
                isEmailIdWrong=false;
                //to pass security questions in update subscriber method
                qsType1.securityquestionquestion=componentToPage.securityQ1;
                qsType1.securityquestionanswer=componentToPage.securityQA1;
                qsType2.securityquestionquestion=componentToPage.securityQ2;
                qsType2.securityquestionanswer=componentToPage.securityQA2;
                lstQuestionAnswer.add(qsType1);
                lstQuestionAnswer.add(qsType2);
                lstQSType.securityquestion=lstQuestionAnswer;
                if (!Test.isRunningTest()) 
                    response = AtlasIntegrationUtility.updateSubscriber(componentToPage.subscriberkey, componentToPage.userName, componentToPage.password,lstQSType);
                else
                    response=(AtlasSSOWS.updateSubscriberResponse_element)JSON.deserialize(AtlasTestConstants.getMetadata('updateSubscriberResponse'),AtlasSSOWS.updateSubscriberResponse_element.class);
                System.debug('update subscriber Response--->'+response);
                System.debug('componentToPage.subscriberkey--->'+componentToPage.subscriberkey);
            }
            catch(Exception e)
            {
                createnewUserRegistrationHistory(email,true,false,e.getMessage());
                System.debug('componentToPage.subscriberkey---22>'+e.getMessage()+'>>>>>'+e.getStacktracestring());
                isUpdateSubscriberException = true;
                pageRef.getParameters().put('msg','FAIL');
                return PageRef;
            }
           
            try
            {   //to update emailaddresss
                if(isEdit || noEmailId)
                {
                    if(!AtlasUtility.isEmpty(response) && response.status=='Success' && response.subscriberkey==componentToPage.subscriberkey)
                    {
                        //callout to make update customerInfo
                        AtlasTransactionDTO.UpdateCustomerInfoTxDTO updateCustInfoObj = new AtlasTransactionDTO.UpdateCustomerInfoTxDTO(componentToPage.externalAccReference,componentToPage.externalSystemName,null,null,email, 
                        null,null,null,null,null,null,null,null,null,null,null,null,null,null,null);
                        if (!Test.isRunningTest()){  
                            Objresponse=AtlasIntegrationUtility.updateCustomerInfo(updateCustInfoObj);
                            createnewUserRegistrationHistory(email,true,false,'');
                        }    
                        else
                            Objresponse='Success';
                        System.debug('Email Response--->'+Objresponse);
                    }
                    else//redirect to error page...
                    {
                        isUpdateSubscriberException = true;
                        isSaveSecurityQuestionsException = true;
                        // if webservice fails.
                        pageRef.getParameters().put('msg','FAIL');                        

                    }
                }
                else
                    createnewUserRegistrationHistory(email,true,false,'');
            }
            catch(Exception e)
            {
                System.debug('Email Update Exception'+e.getMessage());
                isUpdateSubscriberException = true;
                isSaveSecurityQuestionsException = true;
                pageRef.getParameters().put('msg','FAIL');
                ClearSPRValues();
                return pageRef;
            }
        }
        else{
            pageRef.getParameters().put('msg','FAIL');
        }
        return null;        
    }       
    
    //Create Salesforce Records
    public PageReference CreateSFRec(){
        Savepoint sp = Database.setSavepoint();
        try
        {
            //callout to make update customerInfo
            if(!AtlasUtility.isEmpty(response) && response.status == 'Success' && !isUpdateSubscriberException)
            {
                // if security questions saved successfully, call update subscriber.                       
                Account accObj=new Account();
                accObj.Name=componentToPage.accountName;
                accObj.Status__c='Customer';
                accObj.Country__c='United States';
                accObj.Type='End-User';
                accObj.Industry='Commercial';
                accObj.CurrencyIsoCode = 'USD';
                accObj.OwnerId = AtlasUtility.getMapValue(AtlasConstants.Account_Owner);
                insert accObj;
                //to insert contact 
                Contact conObj= new Contact();
                conObj.LastName=componentToPage.accountName;
                conObj.AccountId=accObj.id;
                conObj.ExternalAccountReference__c=componentToPage.externalAccReference;
                string externalAccRef = componentToPage.externalAccReference.trim();
                externalAccRef = externalAccRef.replaceAll('(\\s+)', ' ');
                externalAccRef = externalAccRef.replaceAll('['+stripCharacters+']','');
                conObj.Email=email;
                conObj.Phone=componentToPage.phone;
                conObj.Account_Number__c=componentToPage.internalAccReference;
                conObj.FirstName = componentToPage.firstName;
                conObj.LastName = componentToPage.lastName;
                conObj.OwnerId = AtlasUtility.getMapValue(AtlasConstants.Account_Owner);
                insert conObj;
                //to insert user 
                User userObj = new User();
                userObj.FederationIdentifier= componentToPage.userName;
                userObj.ExternalAccountReference__c = componentToPage.externalAccReference;
                userObj.Email = externalAccRef+emailDomain;
                userObj.Username = externalAccRef+emailDomain;
                userObj.Lastname =componentToPage.lastName;
                userObj.Firstname = componentToPage.firstName;
                userObj.ContactId=conObj.Id;
                if(componentToPage.lastName.length() > 4)
                {
                    userObj.Alias = componentToPage.firstName.substring(0,1)+componentToPage.lastName.substring(0, 4);
                }
                else
                {
                    userObj.Alias = componentToPage.firstName.substring(0,1) + componentToPage.lastName ;
                }
                //userObj.CommunityNickname = componentToPage.firstName;
                if(componentToPage.externalAccReference.length() > 40)
                {
                    userObj.CommunityNickname = componentToPage.externalAccReference.substring(0,40);
                }
                else
                {
                    userObj.CommunityNickname = componentToPage.externalAccReference;
                }
                string profileId = atlasutility.getMapValue(atlasconstants.Atlas_Community_Profile);
                SObject prof = [ select id from profile where Id =: profileId];
                userObj.ProfileId = (ID) prof.get('ID');
                userObj.TimeZoneSidKey = 'America/Los_Angeles';
                userObj.LocaleSidKey = 'en_US';
                userObj.EmailEncodingKey = 'ISO-8859-1';
                userObj.LanguageLocaleKey = 'en_US';
                userObj.UserPermissionsMobileUser = false;
                userObj.Account_Number__c=componentToPage.internalAccReference;
                userObj.CommunityUserAccountType__c = 'EXEDE';
                userObj.Functional_Group__c = 'Customer Portal';
                userObj.Assignment_Group_Active__c = false;
                insert userObj;
                
                pageRef.getParameters().put('msg','SUCCESS');
                createnewUserRegistrationHistory(email,true,true,'');
            }
            else//redirect to error page...
            {
                // if webservice fails.
                pageRef.getParameters().put('msg','FAIL');
            }
        }
        catch(Exception e)
        {
            system.debug('I am in exception--->'+e.getMessage());
            isUpdateSubscriberException = true;
            isSaveSecurityQuestionsException = true;
            Database.rollback(sp);
            ClearSPRValues();
            pageRef.getParameters().put('msg','FAIL');
        } 
        return null;        
    }   
    
    public pagereference Cancel()
    {
        emailId='';
        ConfirmEmailId='';
        String siteURl =site.getcurrentsiteurl();
        if(siteURl!=null && !siteURl.contains(AtlasConstants.Https_text))
        {
            siteURl.replace(AtlasConstants.Http_text,AtlasConstants.Https_text);
            return new PageReference( siteURl+Atlasconstants.ATLAS_COMMUNITY_URL);
        }
           else
           return new PageReference(Atlasconstants.ATLAS_DEV_URL);
    }
    
    //Create New User Registration History Record
    
    public void createnewUserRegistrationHistory(String ConfirmationEmail, boolean confirmEmail, boolean accountCreated,string errMsg)
    {
        List<New_User_Registration_History__c> nurhList = [select id,Time_Stamp__c,Error_Message__c,Confirmation_Email__c,Email_Address__c,Step5_Confirmation_Email__c,Step6_Account_Created__c from New_User_Registration_History__c where Name =: componentToPage.nurhNumber ORDER BY Createddate];
        if(nurhList != null && nurhList.size()>0)
        {
            nurhList[0].Time_Stamp__c = system.now();
            nurhList[0].Confirmation_Email__c=ConfirmationEmail;
            nurhList[0].Email_Address__c=ConfirmationEmail;
            nurhList[0].Step5_Confirmation_Email__c=confirmEmail;
            nurhList[0].Step6_Account_Created__c=accountCreated;
            nurhList[0].Error_Message_Step5__c= errMsg;
        }
        try
        {
            upsert nurhList;
        }
        catch(exception e){
            
        }
    }
    
    
    
    public void ClearSPRValues(){
        try{
            AtlasIntegrationUtility.updateSubscriber(componentToPage.subscriberkey, null, null,null);
        }
        catch(exception e){
            
        }
    }
    
    //Method to validate data is updated properly
    public pagereference validateNewUserRegistration(){
        //Validate whether the username and password are updated successfully in SPR if not update them again
        AtlasSSOWS.getSubscriberResponse_element getSubscriberResponse;
        string loginUsername = null;
        string securityQuestions = null;
        string sfdcAccountName = null;
        string sfdcContactName = null;
        string sfdcUserName = null;
        string sfdcLoginUsername = null;
        try{
            if (!Test.isRunningTest())
                getSubscriberResponse = AtlasIntegrationUtility.getSSOSubscriber(componentToPage.subscriberkey);  
            else                            
                getSubscriberResponse=(AtlasSSOWS.getSubscriberResponse_element)JSON.deserialize(AtlasTestConstants.getMetadata('getSubscriberResponse_element'),AtlasSSOWS.getSubscriberResponse_element.class);  
            system.debug('----------------getSubscriberResponse2: ' + getSubscriberResponse);           
            if(!AtlasUtility.isEmpty(getSubscriberResponse.subscriber.sprattributes.sprattribute)){
            system.debug('@@@ attribute type--->' + getSubscriberResponse.subscriber.sprattributes.sprattribute);
                for(AtlasSSOWS.sprAttributeType sprType : getSubscriberResponse.subscriber.sprattributes.sprattribute){
                    if(sprType.name.trim() == 'loginUserName'){ 
                        //sprType.value=null; -- Used for testing purpose. Manually setting the value to null
                        system.debug('@@@ user name spr typr--->'+sprType.value);
                        loginUsername = sprType.value;  
                        system.debug('@@@ user name--->'+loginUsername);
                    }                                                
                    if(sprType.name.trim() == 'securityQuestion'){
                        if(!AtlasUtility.isEmpty(sprType.values.value)){
                            string str='';
                            for(string objValue: sprType.values.value)
                            {
                                system.debug('@@@ security questions --->'+objValue);
                                str+=objValue+'-';
                                securityQuestions=str;
                            }
                        }
                    }
                    }
                    system.debug('@@@ username --->'+loginUsername+'@@@ securityQuestions --->'+securityQuestions);
                    if(AtlasUtility.isEmpty(loginUsername) || AtlasUtility.isEmpty(securityQuestions)){
                        System.debug('@@@---> I am in Update Subscriber Validation Section');
                         response = AtlasIntegrationUtility.updateSubscriber(componentToPage.subscriberkey, componentToPage.userName, componentToPage.password,lstQSType);
                    }      
            }
            system.debug('@@@ internal account referenec --->'+componenttopage.internalAccReference);
            List<User> tempUser = [SELECT Id, Name, FederationIdentifier,contactId, contact.name, contact.account.name FROM User WHERE Account_Number__c = :componenttopage.internalAccReference limit 1];
            if (!AtlasUtility.isEmpty(tempUser)) {
                sfdcAccountName = tempUser[0].contact.account.name;
                sfdcContactName = tempUser[0].contact.name;
                sfdcUserName = tempUser[0].Name;
                sfdcLoginUsername = tempUser[0].FederationIdentifier;
                // For SFDC and SPR Username Match scenario
                if(!AtlasUtility.isEmpty(loginUsername) && !AtlasUtility.isEmpty(sfdcLoginUsername) && tempUser[0].FederationIdentifier!=loginUsername){
                    tempUser[0].FederationIdentifier=loginUsername;
                    update tempUser;
                }                                        
            }else{
                Account accObj=new Account();
                    accObj.Name=componentToPage.accountName;
                    accObj.Status__c='Customer';
                    accObj.Country__c='United States';
                    accObj.Type='End-User';
                    accObj.Industry='Commercial';
                    accObj.CurrencyIsoCode = 'USD';
                    accObj.OwnerId = AtlasUtility.getMapValue(AtlasConstants.Account_Owner);
                    insert accObj;
                    //to insert contact 
                    Contact conObj= new Contact();
                    conObj.LastName=componentToPage.accountName;
                    conObj.AccountId=accObj.id;
                    conObj.ExternalAccountReference__c=componentToPage.externalAccReference;
                    string externalAccRef = componentToPage.externalAccReference.trim();
                    externalAccRef = externalAccRef.replaceAll('(\\s+)', ' ');
                    externalAccRef = externalAccRef.replaceAll('['+stripCharacters+']','');
                    conObj.Email=email;
                    conObj.Phone=componentToPage.phone;
                    conObj.Account_Number__c=componentToPage.internalAccReference;
                    conObj.FirstName = componentToPage.firstName;
                    conObj.LastName = componentToPage.lastName;
                    conObj.OwnerId = AtlasUtility.getMapValue(AtlasConstants.Account_Owner);
                    insert conObj;
                    //to insert user 
                    User userObj = new User();
                    userObj.FederationIdentifier= componentToPage.userName;
                    userObj.ExternalAccountReference__c = componentToPage.externalAccReference;
                    userObj.Email = externalAccRef+emailDomain;
                    userObj.Username = externalAccRef+emailDomain;
                    userObj.Lastname =componentToPage.lastName;
                    userObj.Firstname = componentToPage.firstName;
                    userObj.ContactId=conObj.Id;
                    if(componentToPage.lastName.length() > 4)
                    {
                        userObj.Alias = componentToPage.firstName.substring(0,1)+componentToPage.lastName.substring(0, 4);
                    }
                    else
                    {
                        userObj.Alias = componentToPage.firstName.substring(0,1) + componentToPage.lastName ;
                    }
                    //userObj.CommunityNickname = componentToPage.firstName;
                    if(componentToPage.externalAccReference.length() > 40)
                    {
                        userObj.CommunityNickname = componentToPage.externalAccReference.substring(0,40);
                    }
                    else
                    {
                        userObj.CommunityNickname = componentToPage.externalAccReference;
                    }
                    string profileId = atlasutility.getMapValue(atlasconstants.Atlas_Community_Profile);
                    SObject prof = [ select id from profile where Id =: profileId];
                    userObj.ProfileId = (ID) prof.get('ID');
                    userObj.TimeZoneSidKey = 'America/Los_Angeles';
                    userObj.LocaleSidKey = 'en_US';
                    userObj.EmailEncodingKey = 'ISO-8859-1';
                    userObj.LanguageLocaleKey = 'en_US';
                    userObj.UserPermissionsMobileUser = false;
                    userObj.Account_Number__c=componentToPage.internalAccReference;
                    userObj.CommunityUserAccountType__c = 'EXEDE';
                    userObj.Functional_Group__c = 'Customer Portal';
                    userObj.Assignment_Group_Active__c = false;
                    insert userObj;
            }
        } catch (exception e) {         
            pageRef.getParameters().put('msg','FAIL');
        }

        return pageRef;
    }
}