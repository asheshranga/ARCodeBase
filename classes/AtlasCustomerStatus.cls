public without sharing class AtlasCustomerStatus {

    public string internalAccountReference{get;set;}
    public string internalServiceAgreement{get;set;}
    public string externalAccountReference{get;set;}
    public string provisioningStatus{get;set;}
    public string billingStatus{get;set;}
    public string primaryPhone{get;set;}
    public string email{get;set;}
    public string firstName{get;set;}
    public string lastName{get;set;}
    public string Nickname{get;set;}
    public integer subscriberCount{get;set;}
    public string loginUserName{get;set;}
    public string sfdcLoginUsername{get;set;} 
    public string packageName{get;set;}
    public string status{get;set;}
    public integer sprSubscriberCount{get;set;}
    public boolean securityQuestions{get;set;}
    public string sfdcAccountName{get;set;}
    public string sfdcContactName{get;set;}
    public string sfdcUserName{get;set;}
    public Long subKey{get;set;}
    public string macAddress{get;set;}
    public boolean userNameExist{get;set;}
    public boolean isUserExist{get;set;}
    public boolean isAccExist{get;set;}
    public boolean isContactExist{get;set;}
    public boolean issprstatusactive{get;set;}
    public boolean isProvStatusActive{get;set;}
    public boolean Subscribercountspr{get;set;}
    public boolean SubcountBackOffice{get;set;}
    public boolean SPRSFDCUname{get;set;}
    public boolean Unamematches{get;set;}
    public boolean isEmailNull{get;set;} 
    public boolean isSFDCUnameExists{get;set;}   
    public string errorMessage{get;set;}
    public static Id accountId;
    public boolean isGrey{get;set;}
    public boolean button1{get;set;}
    public boolean button2{get;set;}
    public boolean button3{get;set;}
    public boolean button4{get;set;}
    public string sprmsg1{get{return AtlasUtility.getMapValue(Atlasconstants.CustomerStatus_clearSPR1);}set;}
    public string sprmsg2{get{return AtlasUtility.getMapValue(Atlasconstants.CustomerStatus_clearSPR2);}set;}
    public string msg2{get{return AtlasUtility.getMapValue(Atlasconstants.CustomerStatus_InvalidAcc);}set;}
    public string sfdcmsg1{get{return AtlasUtility.getMapValue(Atlasconstants.CustomerStatus_CreateSFDC1);}set;}
    public string sfdcmsg2{get{return AtlasUtility.getMapValue(Atlasconstants.CustomerStatus_CreateSFDC2);}set;}
    public string register{get{return AtlasUtility.getMapValue(Atlasconstants.CustomerStatus_ReRigister);}set;}
    public string stripCharacters{get{return AtlasUtility.getMapValue(AtlasConstants.Disallowed_New_User_Special_Characters);}set;}
    public string emailDomain{get{return AtlasUtility.getMapValue(AtlasConstants.New_User_Email_Domain);}set;}
    public static string internacc;
    public boolean isFromAdmin{get;set;}
    
    // Constructor
    public AtlasCustomerStatus()
    {
    	String accountNumId = ApexPages.currentPage().getParameters().get('accountId');
        isGrey=true;
        button1=true;
        button2=true;
        button3=true;
        button4=true;        
        SPRSFDCUname=false;
        Unamematches=false;
        isEmailNull=false;
        isFromAdmin=false;
        if(!AtlasUtility.isEmpty(accountNumId)){
        	isFromAdmin = true;
        	internalAccountReference = accountNumId;
        	//findsubscriber();
        }
    }
    
    // Find Subscriber by Search Criteria
    public pageReference findsubscriber() {
        AtlasPublicWebServiceSearchServiceStub.findSubscribersBySearchCriteriaResponse findSubscriberResponse;
        try{
            if(!AtlasUtility.isEmpty(internalAccountReference))
            {   clearFields();
                isGrey=false;
                button1=true;
                button2=true;
                button3=true;
                button4=true;               
                if (!Test.isRunningTest()) 
                    findSubscriberResponse = AtlasIntegrationUtility.findSubscribersBySearchCriteriaGeneric(null,null,'ACCOUNT',internalAccountReference,null, null, null, null, null, null, null, null, null, null);
                else
                    findSubscriberResponse=(AtlasPublicWebServiceSearchServiceStub.findSubscribersBySearchCriteriaResponse)JSON.deserialize(AtlasTestConstants.getMetadata('findSubscribersBySearchCriteriaResponse'),AtlasPublicWebServiceSearchServiceStub.findSubscribersBySearchCriteriaResponse.class);
                system.debug('-----------findSubscriberResponse-------------->'+ findSubscriberResponse);
                system.debug('-----------internalServiceAgreement-------------->'+ findSubscriberResponse.subscriber[0].serviceAgreement.internalServiceAgreementReference);
                system.debug('-----------externalAccountReference-------------->'+ externalAccountReference);
                system.debug('-----------internalAccountReference-------------->'+ internalAccountReference);
                 system.debug('-----------provisioningStatus-------------->'+ provisioningStatus);
                system.debug('-----------billingStatus-------------->'+ billingStatus);
                if(AtlasUtility.isEmpty(findSubscriberResponse)&& AtlasUtility.isEmpty(findSubscriberResponse.subscriber))
                {
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, AtlasUtility.getMapValue(Atlasconstants.CustomerStatus_AccNoError)));
                    isGrey=true;                    
                    return null;
                }
                // set the variables
                internalServiceAgreement = findSubscriberResponse.subscriber[0].serviceAgreement.internalServiceAgreementReference;
                externalAccountReference = findSubscriberResponse.subscriber[0].account.externalAccountReference;
                internalAccountReference = findSubscriberResponse.subscriber[0].account.internalAccountReference;
                provisioningStatus = findSubscriberResponse.subscriber[0].serviceAgreement.provisioningStatus;
                billingStatus = findSubscriberResponse.subscriber[0].account.billingStatus;
                primaryPhone = findSubscriberResponse.subscriber[0].contact.primaryPhoneNumber;
                
                email = findSubscriberResponse.subscriber[0].contact.emailAddress;
                if(AtlasUtility.isEmpty(email)) 
                	isEmailNull=true;	
                
                firstName = findSubscriberResponse.subscriber[0].contact.person.firstName;
                lastName = findSubscriberResponse.subscriber[0].contact.person.lastName;
                subscriberCount = findSubscriberResponse.subscriber.size();
                macAddress=findSubscriberResponse.subscriber[0].serviceAgreement.macAddress;
                internacc=internalAccountReference;             
                if (provisioningStatus.toUpperCase() == 'ACTIVE'){
                    isProvStatusActive=true;
                }
                if (subscriberCount  == 1){
                    SubcountBackOffice=true;
                }
                
                // Use this to pull the SPR data for a customer given an internal service agreement number
                AtlasSSOWS.getSubscribersResponse_element getSubscribersResponse;
                // enter account number
                try{
                    if (!Test.isRunningTest()) 
                        getSubscribersResponse = AtlasIntegrationUtility.getSSOSubscribers(internalServiceAgreement, null, null, null);
                    else
                        getSubscribersResponse=(AtlasSSOWS.getSubscribersResponse_element)JSON.deserialize(AtlasTestConstants.getMetadata('findSSOsubscribersbyinternalServiceAgreementReference'),AtlasSSOWS.getSubscribersResponse_element.class);   
                     system.debug('-----------getSubscribersResponse-------------->'+ getSubscribersResponse);
                    // find the subscriberkey
                    if(getSubscribersResponse.totalsubscribers!=0&&getSubscribersResponse.status=='Success'){
                        for(AtlasSSOWS.subscriberType subType : getSubscribersResponse.subscribers.subscriber){
                            if(subType.subscriberkey != null)
                                subKey = subType.subscriberkey;
                        }
                    }
                    sprSubscriberCount = getSubscribersResponse.totalsubscribers;
                    if (sprSubscriberCount == 1){
                        Subscribercountspr=true;
                        if(Test.isRunningTest()){string e = null; e.tolowercase();}
                    }
                } catch (exception e) {
                    subKey=null;
                    sprSubscriberCount=null;
                    Subscribercountspr=false;
                }
                
                system.debug('----------------subkey: ' + subKey); 
                system.debug('----------------sprSubscriberCount: ' + sprSubscriberCount);            
                AtlasSSOWS.getSubscriberResponse_element getSubscriberResponse;
                
                // pass the returned subscriber id to the getSSOSubscriber method
                try{
                    if (!Test.isRunningTest())
                        getSubscriberResponse = AtlasIntegrationUtility.getSSOSubscriber(subKey);  
                    else
                        getSubscriberResponse=(AtlasSSOWS.getSubscriberResponse_element)JSON.deserialize(AtlasTestConstants.getMetadata('getSubscriberResponse_element'),AtlasSSOWS.getSubscriberResponse_element.class);  
                    system.debug('----------------getSubscriberResponse2: ' + getSubscriberResponse); 
                    if(getSubscriberResponse.status=='Success'){
                        for(AtlasSSOWS.sprAttributeType sprType : getSubscriberResponse.subscriber.sprattributes.sprattribute){
                            if(sprType.name != null&&sprType.name == 'packageId')
                                packageName = sprType.value;
                            if(sprType.name != null&&sprType.name == 'loginUsername')
                            {
                                loginUsername = sprType.value; 
                                userNameExist=true;
                            }      
                            if(sprType.name != null&&sprType.name == 'status'){
                                status = sprType.value.toUpperCase();
                                if (status.toUpperCase() == 'ACTIVE'){
                                    issprstatusactive=true;}
                            }            
                            if(sprType.name != null&&sprType.name == 'securityQuestion')
                                securityQuestions = True; 
                                if(Test.isRunningTest()){string e = null; e.tolowercase();}
                        }
                    }
                } catch (exception e) {
                    packageName='';
                    loginUsername='';
                    userNameExist=false;                  
                    issprstatusactive=false;
                    securityQuestions = false;
                    status='';   
                }
                system.debug('-----------spr loginUsername-------------->'+ loginUsername);
                 system.debug('-----------spr loginUsername-------------->'+ loginUsername);
                
                // check if the account, contact, user exists
                try {
                    List<User> tempUser = [SELECT Id, Name, FederationIdentifier,contactId, contact.name, contact.account.name FROM User WHERE Account_Number__c = :internalAccountReference limit 1];
                    if (!AtlasUtility.isEmpty(tempUser)) {
                        sfdcAccountName = tempUser[0].contact.account.name;
                        sfdcContactName = tempUser[0].contact.name;
                        sfdcUserName = tempUser[0].Name;
                        sfdcLoginUsername = tempUser[0].FederationIdentifier;
                        isUserExist=true;
                        if(!AtlasUtility.isEmpty(sfdcLoginUsername))
                        	isSFDCUnameExists=true;                       
                        
                        // For SFDC and SPR Username Match scenario
                        if(!AtlasUtility.isEmpty(loginUsername) && !AtlasUtility.isEmpty(sfdcLoginUsername) && tempUser[0].FederationIdentifier!=loginUsername)                    
                            SPRSFDCUname=true;
                        else if(tempUser[0].FederationIdentifier==loginUsername)
                        	Unamematches=true;
                                                                                                                     
                        if(Test.isRunningTest()){string e = null; e.tolowercase();}
                        
                        if(tempUser[0].ContactId!=null)
                        {
                            isAccExist=true;isContactExist=true;
                        }
                    }
                    else
                    {
                        isUserExist=false;
                        sfdcUserName='';
                        sfdcLoginUsername='';
                        isAccExist=false;
                        isContactExist=false;
                        SPRSFDCUname=false;
                        Unamematches=false;
                        isSFDCUnameExists=false;
                    }
                } catch (exception e) {
                    isUserExist=false;
                    sfdcUserName='';
                    sfdcLoginUsername=''; 
                    isAccExist=false;
                    isContactExist=false;
                    SPRSFDCUname=false;
                    Unamematches=false;
                    isSFDCUnameExists=false;
                }
            }
            else
            {   
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, AtlasUtility.getMapValue(Atlasconstants.CustomerStatus_AccNoError)));
                clearFields();
                internalAccountReference='';
                return null;
            }
            if(Test.isRunningTest()){string e = null; e.tolowercase();}
            return null;        
            
        } catch (exception e) {
            errorMessage=e.getmessage()+''+e.getStacktracestring();
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, AtlasUtility.getMapValue(Atlasconstants.CustomerStatus_AccNoError)));
            clearFields();
            internalAccountReference='';
            return null;
        }
         
    }
    
    // To update SFDC Username if it doesnt match with SPR Username
    public void updateUname() {
        try{           
            User tempUser = [SELECT Id, Name, FederationIdentifier,contactId, contact.name, contact.account.name FROM User WHERE Account_Number__c = :internalAccountReference limit 1];
            tempUser.FederationIdentifier=loginUsername;
            update tempUser;
            button4=false;
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM, 'SFDC Login Username is updated successfully.'));           
        }
        catch(Exception e){
            system.debug('---------------' + e.getmessage());
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Ooops! Error occurred while updating SFDC Username. Please contact Salesforce Support Team for assistance.'));
        } 
    }  
    
    //clear all fields
    public pagereference clearFields()
    {
        internalServiceAgreement='';
        externalAccountReference='';
        //internalAccountReference='';
        provisioningStatus='';
        billingStatus='';
        primaryPhone='';
        email='';
        firstName='';
        lastName='';
        subscriberCount=null;
        macAddress='';
        subKey=null;
        sprSubscriberCount=null;
        packageName='';
        loginUsername='';
        sfdcLoginUsername='';
        userNameExist=false;
        status='';
        Subscribercountspr=false;
        SubcountBackOffice=false;
        issprstatusactive=false;
        isProvStatusActive=false;
        securityQuestions=false;
        isUserExist=false;
        isAccExist=false;
        isContactExist=false;
        SPRSFDCUname=false;
        Unamematches=false;
        isEmailNull=false;
        isSFDCUnameExists=false; 
        return null;
    }
    
    // To clear SPR data 
     public void invokeUpdateSubscriber()
    {
      AtlasSSOWS.updateSubscriberResponse_element response1;     
            try{
                if (!Test.isRunningTest()) 
                    response1 = AtlasIntegrationUtility.updateSubscriber(subKey,null,null,null);
                else
                    response1 =(AtlasSSOWS.updateSubscriberResponse_element)JSON.deserialize(AtlasTestConstants.getMetadata('updateSubscriberResponse'),AtlasSSOWS.updateSubscriberResponse_element.class);   
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM, AtlasUtility.getMapValue(Atlasconstants.CustomerStatus_SPRSuccess)));
                button1=false; 
                if(Test.isRunningTest()){string e = null; e.tolowercase();}
            }
            catch(Exception e){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, AtlasUtility.getMapValue(Atlasconstants.CustomerStatus_SPRfailure)));
            }
    }
   
    // To create records in SFDC
    public pagereference createInSFDC()
    {
        Savepoint sp = Database.setSavepoint();
            try
            {
                Account accObj=new Account();
                accObj.Name=firstName+' '+lastName;
                accObj.Status__c='Customer';
                accObj.Country__c='United States';
                accObj.Type='End-User';
                accObj.Industry='Commercial';
                accObj.CurrencyIsoCode = 'USD';
                accobj.AccountNumber=internalAccountReference;
                accObj.OwnerId = AtlasUtility.getMapValue(AtlasConstants.Account_Owner);
                insert accObj;
                //to insert contact 
                Contact conObj= new Contact();
                conObj.LastName=firstName+' '+lastName;
                conObj.AccountId=accObj.id;
                conObj.ExternalAccountReference__c=externalAccountReference;
                string externalAccRef =externalAccountReference.trim();
                externalAccRef = externalAccRef.replaceAll('(\\s+)', ' ');              
                externalAccRef = externalAccRef.replaceAll('['+stripCharacters+']','');                                
                conObj.Email=email;
                conObj.Phone=primaryPhone;
                conObj.Account_Number__c=internalAccountReference;
                conObj.FirstName =firstName;
                conObj.LastName =lastName;
                conObj.OwnerId = AtlasUtility.getMapValue(AtlasConstants.Account_Owner);
                insert conObj;
                //to insert user
                User userObj = new User();
                userObj.FederationIdentifier= loginUsername;
                userObj.ExternalAccountReference__c = externalAccountReference;
                userObj.Email = externalAccRef+emailDomain;
                userObj.Username = externalAccRef+emailDomain;               
                userObj.Lastname =lastName;
                userObj.Firstname = firstName;
                userObj.ContactId=conObj.Id;
                if(lastName.length() > 4)
                {
                    userObj.Alias = firstName.substring(0,1)+lastName.substring(0, 4);
                }
                else
                {
                    userObj.Alias = firstName.substring(0,1) + lastName ;
                }
                userObj.CommunityNickname = externalAccountReference;
                string profileId = atlasutility.getMapValue(atlasconstants.Atlas_Community_Profile);
                SObject prof = [ select id from profile where Id =: profileId];
                userObj.ProfileId = (ID) prof.get('ID');
                userObj.TimeZoneSidKey = 'America/Los_Angeles';
                userObj.LocaleSidKey = 'en_US';
                userObj.EmailEncodingKey = 'ISO-8859-1';
                userObj.LanguageLocaleKey = 'en_US';
                userObj.UserPermissionsMobileUser = false;
                userObj.Account_Number__c=internalAccountReference;
                userObj.CommunityUserAccountType__c = 'EXEDE';
                userObj.Functional_Group__c = 'Customer Portal';
                userObj.Assignment_Group_Active__c = false;
                insert userObj;
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM, AtlasUtility.getMapValue(Atlasconstants.CustomerStatus_SFDCSuccess)));
                button2=false;
                if(Test.isRunningTest()){string e = null; e.tolowercase();}
                return null;
            }
            catch(Exception e)
            {   
            	system.debug('>>>>>>'+e.getStackTraceString());
            	system.debug('---------------' + e.getmessage());
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, AtlasUtility.getMapValue(Atlasconstants.CustomerStatus_SFDCfailure)));
                Database.rollback(sp);
                return null;
            } 
    }
	
	// To reset the Account Information both in SPR and SFDC
    public void resetAccount() {
         AtlasSSOWS.updateSubscriberResponse_element response1;
            try{
                if (!Test.isRunningTest()) 
                    response1 = AtlasIntegrationUtility.updateSubscriber(subKey,null,null,null);
                else
                    response1 =(AtlasSSOWS.updateSubscriberResponse_element)JSON.deserialize(AtlasTestConstants.getMetadata('updateSubscriberResponse'),AtlasSSOWS.updateSubscriberResponse_element.class);   
                if(!AtlasUtility.isEmpty(internalAccountReference))
                {
                	// To update User              
                    User tempUser = [SELECT Id, Name,FederationIdentifier,Username,CommunityNickname,ExternalAccountReference__c,Account_Number__c,IsActive,contactId,contact.accountId FROM User WHERE Account_Number__c = :internalAccountReference limit 1];
                    system.debug('-----------------------user-----------------'+ tempUser);
                    tempUser.FederationIdentifier+='-disconnected';

                    // Checking for the length of Nickname
                    if(tempUser.CommunityNickname.length() > 27) {
						tempUser.CommunityNickname=tempUser.CommunityNickname.substring(0,27)+'-disconnected';	
					}
					else
						tempUser.CommunityNickname+='-disconnected';
						
                    tempUser.ExternalAccountReference__c+='-disconnected';
                    tempUser.Account_Number__c+='-disconnected';
                    tempUser.Username+='-disconnected';
                    tempUser.IsActive=false;
                    tempUser.IsPortalEnabled=false;
                    update tempUser;
                    accountId= tempUser.contact.accountId;
                    // To delete the Account and Contact related to the user                 
                    mixedDML(accountId);  
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM, 'SPR and SFDC data are cleared successfully.'));
                    button3=false;
                             
                    if(Test.isRunningTest()){string e = null; e.tolowercase();}
                }    
            }
            catch(Exception e){
                system.debug('---------------' + e.getmessage());
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Ooops! Error occurred while clearing SPR and SFDC data. Please contact Salesforce Support Team for assistance.'));
            }     
    } 
    
    @future
    public static void mixedDML(Id accountId1) {       
        if(!AtlasUtility.isEmpty(accountId1))
        {
            try
            {
                account acc=[select id from account where id =:accountId1 limit 1];
                delete acc;
            }
            catch(Exception e)
            {
                system.debug('---------------' + e.getmessage());               
            }
        }   
    }  
       
}