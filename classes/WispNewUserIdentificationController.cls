/*********************************************************************************
Name         : WispNewUserIdentificationController
Created By   : Srikanth Kudumula
Modified BY  : Srikanth Kudumula
Company Name : NTT Data
Project      : ViaSat Wisp
Created Date : 
Modified Date: 
Usages       : Controller for VisualForce Component: WispNewUserIdentification
*********************************************************************************/
public with sharing class WispNewUserIdentificationController {
    
    //Constants
    public string newUserText{get{return AtlasConstants.NEW_USER_TEXT;}set;}
    public string identificationText {get{return Atlasconstants.IDENTIFICATION_TEXT;}set;}


    public string loginPblmText{get{return Atlasconstants.LOGIN_PROBLEM_TEXT;}set;}


    public string cancel{get{return Atlasconstants.LOGIN_CANCEL;}set;}
    public string nextStep{get{return Atlasconstants.LOGIN_NEXT_STEP;}set;}
    public string step{get{return AtlasConstants.STEP_1_4;}set;}
    public string note{get{return Atlasconstants.NOTE;}set;}
    public string allFields{get{return Atlasconstants.LOGIN_ALL_FIELDS_TEXT;}set;}
    public string loginHelpText{get{return AtlasConstants.LOGIN_HELP_TEXT;}set;}
    public string loginaccNotFound{get{return AtlasUtility.getMapValue(Atlasconstants.LOGIN_ACC_NOT_FOUND_TEXT);}set;}
    public string loginCCText{get{return Atlasconstants.LOGIN_CC_TEXT;}set;}
    public string loginCCNo{get{return AtlasUtility.getMapValue(Atlasconstants.LOGIN_CC_NO_TEXT);}set;}

    public string macRequired{get{return AtlasUtility.getMapValue(Atlasconstants.LOGIN_MAC_VALIDATE);}set;}
    public string phoneRequired{get{return AtlasUtility.getMapValue(Atlasconstants.LOGIN_PHONE_VALIDATE);}set;}
    public string emailRequired{get{return AtlasUtility.getMapValue(Atlasconstants.LOGIN_EMAIL_VALIDATE);}set;}
    public string validemail{get{return AtlasUtility.getMapValue(Atlasconstants.PLS_EMAIL_VALID);}set;}
    public string whatisThis{get{return AtlasUtility.getMapValue(Atlasconstants.WHAT_IS_THIS);}set;}

    public string macaddressLabel{get{return AtlasUtility.getMapValue(Atlasconstants.LOGIN_MAC_INST_TEXT);}set;}
    public string tryAgain{get{return Atlasconstants.LOGIN_TRY_AGAIN_TEXT;}set;}
    public string phone{get{return Atlasconstants.PHONE_TEXT;}set;}
    public string email{get{return Atlasconstants.EMAIL_TEXT;}set;}
    public string help{get{return Atlasconstants.HELP;}set;}
    public string userExist1{get{return AtlasUtility.getMapValue(Atlasconstants.USER_EXIST1);}set;}
    public string userExist2{get{return AtlasUtility.getMapValue(Atlasconstants.USER_EXIST2);}set;}
    public string userExist3{get{return AtlasUtility.getMapValue(Atlasconstants.USER_EXIST3);}set;}
    public string userExist4{get{return AtlasUtility.getMapValue(Atlasconstants.USER_EXIST4);}set;}
    public string userExist5{get{return AtlasUtility.getMapValue(Atlasconstants.USER_EXIST5);}set;}
    public string loginMacText{get{return AtlasUtility.getMapWispValue(Atlasconstants.WispLoginMacText);}set;}
    public string phoneemailHelpText{get{return AtlasUtility.getMapValue(AtlasConstants.PHNEEMAIL_HELP_TEXT);}set;}
    public string userIdentHelpText1{get{return AtlasUtility.getMapValue(AtlasConstants.USER_IDENT_HELP_TEXT_1);}set;}
    public string userIdentHelpText2{get{return AtlasUtility.getMapValue(AtlasConstants.USER_IDENT_HELP_TEXT_2);}set;}

    public string MacDigits{get{return AtlasUtility.getMapValue(AtlasConstants.MAC_DIGITS);}set;}
    public string PhoneDigits{get{return AtlasUtility.getMapValue(AtlasConstants.PHONE_DIGITS);}set;}
    //variables to get place holder values

    public string MacPlaceHolder{get{return AtlasUtility.getMapValue(AtlasConstants.MAC_PLACE_HOLDER);}set;}
    public string PhonePlaceHolder{get{return AtlasUtility.getMapValue(AtlasConstants.PHONE_PLACE_HOLDER);}set;}
    public string EmailPlaceHolder{get{return AtlasUtility.getMapValue(AtlasConstants.EMAIL_PLACE_HOLDER);}set;}
    public string AccLocked{get{return AtlasUtility.getMapValue(AtlasConstants.ACC_LOCKED);}set;}
    public string AccLocked1{get{return AtlasUtility.getMapValue(AtlasConstants.ACC_LOCKED1);}set;}
    public string AccLocked2{get{return AtlasUtility.getMapValue(AtlasConstants.ACC_LOCKED2);}set;}
    public string AccLocked5{get{return AtlasUtility.getMapValue(AtlasConstants.ACC_LOCKED5);}set;}
    public string AccPhoneEmail{get{return AtlasUtility.getMapValue(AtlasConstants.ACC_EMAIL_PHONE);}set;}
    public string Accpending{get{return AtlasUtility.getMapValue(AtlasConstants.ACC_PENDING_ACTIVATION);}set;}
    public string WispEmailPhoneIncorrect{get{return AtlasUtility.getMapWispValue(AtlasConstants.Wisp_New_User_Phone_Email_Incorrect);}set;}
    public string WispMacHelpText{get{return AtlasUtility.getMapWispValue(AtlasConstants.Wisp_ACC_HELP_TEXT_1);}set;}
    public string WispAccLocked1{get{return AtlasUtility.getMapWispValue(AtlasConstants.Wisp_ACC_LOCKED1);}set;}
    public string WispAccLocked5{get{return AtlasUtility.getMapWispValue(AtlasConstants.Wisp_ACC_LOCKED5);}set;}
    public string WispuserIdentHelpText1{get{return AtlasUtility.getMapWispValue(AtlasConstants.Wisp_USER_IDENT_HELP_TEXT_1);}set;}
    public string WispuserIdentHelpText2{get{return AtlasUtility.getMapWispValue(AtlasConstants.Wisp_USER_IDENT_HELP_TEXT_2);}set;} 
    //Variables used in the component
    public string accountNumber{get;set;}
    public string MACValue1{get;set;}
    public string MACValue2{get;set;}
    public string MACValue3{get;set;}
    public string MACValue4{get;set;}
    public string MACValue5{get;set;}
    public string MACValue6{get;set;}
    public string phone1{get;set;}
    public string phone2{get;set;}
    public string phone3{get;set;}
    public string emailId{get;set;}
    public string emailId1{get;set;}
    //Boolean variables
    public boolean isAccRequired{get;set;}
    public boolean isMACRequired{get;set;}
    public boolean isPhoneRequired{get;set;}
    public boolean isEmailRequired{get;set;}
    public boolean isAccountFound{get;set;}
    public boolean isAccountNotFound{get;set;}
    public boolean isprovisionAccount{get;set;}
    //Apex class is used to find the steps(1,2,3,4..)
    public AtlasComponenttoController componentToPage{get; set;}
    public boolean isAccountExist{get;set;}
    public boolean isEmailorPhonenotMatch{get;set;}
    public boolean isAccwrong{get;set;}
    public boolean isMACwrong{get;set;}
    public string erroMessage{get;set;}
    public boolean isNotAuthorized{get;set;}
    public integer toatlIncorrect{get;set;}
    //public User_Lock_Out__c objUserLock{get;set;}
    public boolean isLocked{get;set;}
    public double remainingMinutes{get;set;}
    public double lastAttempt{get;set;}
    //List<User_Lock_Outs__c> lstvalues= User_Lock_Outs__c.getAll().values();    
    public string ReturnValue;
    string MAcAddress ='';
    String IPAddress = '';
    List<Atlas_User_Lock_Out__c> objUser = null;
    List<User> usr = null;
    String siteURL = '';
    //Variables to store values from the New findSubscriberCriteriaV2 callout
    public string externalAccRefAPI;
    public string provStatusAPI;
    public string strAccountNumberAPI;
    public string externalSystemNameAPI;
    public string partnerNameAPI;
    public string businessNameAPI;
    public string phoneMobileAPI;
    public string customerEmailAPI;
    public string firstNameAPI;
    public string lastNameAPI;
    public string internalServAgrRefAPI;
    
    /**
    * @author Shiva Shankar
    * @description - Constructor for AtlasNewUserIdentificationController
    * @input param  - null
    * @return null
    */ 
    public WispNewUserIdentificationController(){
         isAccRequired=false;
         isMACRequired=false;
         isPhoneRequired=false;
         isEmailRequired=false;
         isAccountFound=false;
         isAccountNotFound=false;
         isAccountExist=false;
         isprovisionAccount=false;
         isEmailorPhonenotMatch=false;
         isNotAuthorized=false;
         accountNumber = '';
         isLocked=false;
         ReturnValue = '';
	     ReturnValue = ApexPages.currentPage().getHeaders().get('True-Client-IP');
	     if ( (ReturnValue == null) || (ReturnValue.trim().equals('')) ) {
	        ReturnValue = ApexPages.currentPage().getHeaders().get('X-Salesforce-SIP')+'NewUser';
	        IPAddress = ApexPages.currentPage().getHeaders().get('X-Salesforce-SIP');
	     }
	     system.debug('ReturnValue____'+ReturnValue);	     
    }
       
    // onclick of submit-
    public pagereference submitStep1()
    {   
        try
        {   
        	//List<User_Lock_Outs__c> lstvalues= User_Lock_Outs__c.getAll().values();
        	objUser=[select Name,Time_Value__c,TotalWrong__c from Atlas_User_Lock_Out__c where Name =: ReturnValue ORDER BY LastModifiedDate];
        	system.debug('objUser____'+objUser);
        	Atlas_User_Lock_Out__c objvalue = null;
        	if(objUser != null && objUser.size() > 0)
	     	{   
	     		objvalue = objUser[0];  			         
	         	if(objUser[0].Name==ReturnValue)			         	        
	         		toatlIncorrect=(integer.valueOf(objUser[0].Totalwrong__c));	         
	         	else 
	         		toatlIncorrect =0;		         		         			         
		     }
		     else
		     {
		     	toatlIncorrect =0;
		     }  
		     system.debug('++++Total Incorrect 1+++'+toatlIncorrect);
            boolean isFailed=false;
            if(!AtlasUtility.isEmpty(MACValue1))
            {
                if(MACValue1.contains(':'))
                    MACValue1=MACValue1.replace(':','');
                if(MACValue1.length()==12)  
                {   
                    string mac1=MACValue1.substring(0,2);string mac2=MACValue1.substring(2,4);string mac3=MACValue1.substring(4,6);string mac4=MACValue1.substring(6,8);string mac5=MACValue1.substring(8,10);string mac6=MACValue1.substring(10,12);
                    MAcAddress=mac1+':'+mac2+':'+mac3+':'+mac4+':'+mac5+':'+mac6;
                }   
            }
            if(!AtlasUtility.isEmpty(MAcAddress))
            MAcAddress=MAcAddress.toLowerCase();
            if(!AtlasUtility.isEmpty(MAcAddress) && MAcAddress.contains('o'))
            MAcAddress=MAcAddress.replace('o', '0');
            String trimmedPhone;
            if(!AtlasUtility.isEmpty(phone1))
            trimmedPhone = phone1.replaceAll('[- )(]','');
            string PhoneNumber='';
            if(!AtlasUtility.isEmpty(trimmedPhone) && trimmedPhone.length()==10)
            {
                string phone11=trimmedPhone.substring(0,3);string phone2=trimmedPhone.substring(3,6);string phone3=trimmedPhone.substring(6,10);
                PhoneNumber=phone11+'-'+phone2+'-'+phone3;
            }
            string email=emailId;
            Long subKey;
            boolean isLoginUserNameExists = false;
            String loginUserNameValue = '';
            string accPlan = '';
            string serviceProvider = '';
            //AtlasPublicWebServiceSearchServiceStub.findSubscriberBySearchCriteria repsonseObj = null;
            Map<String,String> repsonseObj = new Map<String,String>();
            Set<String> AtlasPlansSet = new Set<String>();
            if(!AtlasUtility.isEmpty(MAcAddress) && (!AtlasUtility.isEmpty(email)||!AtlasUtility.isEmpty(PhoneNumber)))
        	{	                
                long dt1;
                datetime d=system.now();
                //List<User_Lock_Outs__c> lstvalues= User_Lock_Outs__c.getAll().values();
                if(!AtlasUtility.isEmpty(objvalue))
                {
                    if(objvalue.Name==ReturnValue && objvalue.Totalwrong__c==5)
                    {
                        isFailed=true;
                         dt1= objvalue.Time_Value__c.getTime() / 1000;
                    }
                    else if(objvalue.Name==ReturnValue && objvalue.Totalwrong__c<5)
                    {
                        toatlIncorrect=integer.valueof(objvalue.Totalwrong__c);
                    }
                }
				
                if(isFailed)
                {	
                    long dt2 = d.getTime() / 1000;
                    double dt = dt2 - dt1;
                    remainingMinutes=dt/60;
                    if(remainingMinutes <5.0)
                    {	
                        //objUserLock=objUser[0];
                        isLocked=true;
                        componentToPage.isStep1=true;
                        componentToPage.isStep2=false;
                        remainingMinutes=decimal.valueof(remainingMinutes).setScale(1,System.RoundingMode.UP);
                        double i1 = 5.0-remainingMinutes;
                        createnewUserRegistrationHistroy(accountNumber,MAcAddress,phone1,emailId,IPAddress,AccLocked+' '+AccLocked1+' '+i1+' '+AccLocked2,false);
                        return null;
                    }                  
                }   
                else
                {
                    //objUserLock.TotalIncorrect__c=0;
                    isLocked=false;
                }
                if (!Test.isRunningTest())
                	//repsonseObj=AtlasIntegrationUtility.findSubscribersBySearchCriteriaGeneric(null,null,null,null,null,null,null,null,null,null,null,null,MacAddress,null);
                	repsonseObj=AtlasIntegrationUtility.findSubscriberBySearchCriteriaV2Mac(MacAddress);
                else
                    //repsonseObj=(AtlasPublicWebServiceSearchServiceStub.findSubscribersBySearchCriteriaResponse)JSON.deserialize(AtlasTestConstants.getMetadata('findSubscribersBySearchCriteriaResponse'),AtlasPublicWebServiceSearchServiceStub.findSubscribersBySearchCriteriaResponse.class);
             
                 system.debug('---Public API Call Response--->'+repsonseObj);
                 if(!AtlasUtility.isEmpty(repsonseObj))
                 {  
                     /* Start - Variable initialization from the New findSubscriberBySearchCriteriaV2 callout */
                     externalAccRefAPI=repsonseObj.get('externalAccountReference');
				     provStatusAPI=repsonseObj.get('provisioningStatus');
				     strAccountNumberAPI=repsonseObj.get('internalAccountReference');
			         externalSystemNameAPI=repsonseObj.get('externalSystemName');
			         partnerNameAPI = repsonseObj.get('partnerName');
				     internalServAgrRefAPI = repsonseObj.get('internalServiceAgreementReference');
				     
			         if(repsonseObj.containsKey('businessName'))                      
		             	businessNameAPI=repsonseObj.get('businessName');
			         if(repsonseObj.containsKey('primaryPhoneNumber'))
		             	phoneMobileAPI=repsonseObj.get('primaryPhoneNumber');
			         if(repsonseObj.containsKey('emailAddress'))
		             	customerEmailAPI=repsonseObj.get('emailAddress');
				     if(repsonseObj.containsKey('firstName'))
		             	firstNameAPI=repsonseObj.get('firstName');                  
		             if(repsonseObj.containsKey('lastName'))
					 	lastNameAPI=repsonseObj.get('lastName');
                     /* End - Variable initialization from the New findSubscriberBySearchCriteriaV2 callout */
                     //check whether user exists in saleforce or not
                     usr = [select id from user where ExternalAccountReference__c =: externalAccRefAPI and isActive = true];
                     if(!AtlasUtility.isEmpty(usr) && usr.size() >0)
                     {
                     	//User already exists in salesforce set isLoginUserNameExists to true
                     	isLoginUserNameExists = true;
                     }
                     //validation to verify the account number is valid--(cusInfoObj.account.externalAccountReference!=null) ||(!cusInfoObj.account.externalAccountReference.trim().equals(''))
                    if((phoneMobileAPI==PhoneNumber) ||(customerEmailAPI==email))
                    {   //if the account is valid, and username is not present redirecting to step-2 only
                        isEmailorPhonenotMatch=false;
                        if(!AtlasUtility.isEmpty(provStatusAPI) && !(AtlasUtility.getMapValue(AtlasConstants.Atlas_Invalid_Account_Status)).containsIgnoreCase('/'+provStatusAPI+'/'))
                        {
                            isNotAuthorized=true;
                            erroMessage=AtlasUtility.getMapWispValue(Atlasconstants.Wisp_Acc_Terminated);
                            createnewUserRegistrationHistroy(accountNumber,MAcAddress,phone1,emailId,IPAddress,erroMessage,false);
                            return null;
                        }
                        isNotAuthorized=false;
                        AtlasSSOWS.getSubscribersResponse_element subRepsonseObj;
                        if (!Test.isRunningTest())
                            subRepsonseObj=AtlasIntegrationUtility.getSSOSubscribers(internalServAgrRefAPI,'','','');
                        else
                            subRepsonseObj=(AtlasSSOWS.getSubscribersResponse_element)JSON.deserialize(AtlasTestConstants.getMetadata('findSSOsubscribersbyinternalServiceAgreementReference'),AtlasSSOWS.getSubscribersResponse_element.class);   
                        if(!AtlasUtility.isEmpty(subRepsonseObj))
                        {
                            if(subRepsonseObj.totalsubscribers!=0&&subRepsonseObj.status=='Success')
                            {
                                for(AtlasSSOWS.subscriberType subType : subRepsonseObj.subscribers.subscriber){
                                    if(subType.subscriberkey != null)
                                    subKey = subType.subscriberkey;
                                }
                                AtlasSSOWS.getSubscriberResponse_element subResObj;
                                system.debug('subKey_____'+subKey);
                                if (!Test.isRunningTest())
                                    subResObj = AtlasIntegrationUtility.getSSOSubscriber(subKey);
                                else
                                    subResObj=(AtlasSSOWS.getSubscriberResponse_element)JSON.deserialize(AtlasTestConstants.getMetadata('getSubscriberResponse_element'),AtlasSSOWS.getSubscriberResponse_element.class);  
                                if(!AtlasUtility.isEmpty(subResObj))
                                {
                                    //List<AtlasPlan__c> atlasPlans = [select PlanAPIName__c, PlanDisplayName__c from  AtlasPlan__c];
                                    //for(AtlasPlan__c ap : atlasPlans){
                                        //AtlasPlansSet.add(ap.PlanAPIName__c.toLowerCase());
                                    //}
                                    for(AtlasSSOWS.sprAttributeType obj : subResObj.subscriber.sprattributes.sprattribute){
                                        if(obj.name.trim() == 'loginUserName'){
                                            isLoginUserNameExists = true;
                                            loginUserNameValue = obj.value;
                                        }
                                        if(obj.name.trim() == 'packageId'){
                                            accPlan = obj.value;
                                        }
                                        if(obj.name.trim() == 'serviceProvider'){
                                        	serviceProvider = obj.value;
                                        }
                                    }
                                    
                                    //Query to fetch AtlasPlans based on the service provider Exede/Reseller
									List<AtlasPlan__c> atlasPlans = null;
									atlasPlans = [select PlanAPIName__c, PlanDisplayName__c from  AtlasPlan__c where Type__c = 'Wisp'];
									                                
									for(AtlasPlan__c ap : atlasPlans){
										AtlasPlansSet.add(ap.PlanAPIName__c.toLowerCase());
									}
                                    if(AtlasPlansSet.contains(accPlan.toLowercase()))
                                    {
                                        if(!isLoginUserNameExists)
                                        {
                                            if(loginUserNameValue =='' || loginUserNameValue == null)
                                            {
                                                componentToPage.isStep1=false;
                                                componentToPage.isStep2=true;
                                                isAccountExist=false;
                                                componentToPage.accountName=firstNameAPI+' '+lastNameAPI;
                                                componentToPage.firstName=firstNameAPI;
                                                componentToPage.lastName=lastNameAPI;
                                                componentToPage.emailId=customerEmailAPI;
                                                componentToPage.externalAccReference=externalAccRefAPI;
                                                componentToPage.externalSystemName=externalSystemNameAPI;
                                                componentToPage.internalAccReference=strAccountNumberAPI;
                                                componentToPage.phone=phoneMobileAPI;
                                                componentToPage.subscriberKey = subKey;
                                                if(partnerNameAPI != null)
                                                	componentToPage.partnerName = partnerNameAPI;
                                                if(businessNameAPI != null)
                                                	componentToPage.businessName = businessNameAPI;	
                                                isprovisionAccount=false;
                                                isAccountNotFound=false;
                                                createnewUserRegistrationHistroy(accountNumber,MAcAddress,phone1,emailId,IPAddress,null,true);
                                                return null;
                                            }
                                        }
                                        else{
                                            componentToPage.isStep1=true;
                                            componentToPage.isStep2=false;
                                            componentToPage.isStep3=false;
                                            componentToPage.isStep4=false;
                                            componentToPage.accountName=firstNameAPI+' '+lastNameAPI;
                                            componentToPage.firstName=firstNameAPI;
                                            componentToPage.lastName=lastNameAPI;
                                            componentToPage.emailId=customerEmailAPI;
                                            componentToPage.externalAccReference=externalAccRefAPI;
                                            componentToPage.externalSystemName=externalSystemNameAPI;
                                            componentToPage.internalAccReference=strAccountNumberAPI;
                                            componentToPage.phone=phoneMobileAPI;
                                            isAccountFound=true;
                                            isAccountNotFound=false;
                                            isAccountExist=true;
                                            isprovisionAccount=false;
                                            createnewUserRegistrationHistroy(accountNumber,MAcAddress,phone1,emailId,IPAddress,userExist1+' '+userExist2+' '+userExist3+' '+userExist4+' '+userExist5,false);
                                            return null;
                                        }
                                    }
                                    else{
                                        isAccountFound=false;
                                        isAccountNotFound=true;
                                        isMACwrong=true;
                                        isEmailorPhonenotMatch =false;                                       
                                        erroMessage=AtlasUtility.getMapWispValue(AtlasConstants.Wisp_Plan_Not_Set);                                      
                                        createnewUserRegistrationHistroy(accountNumber,MAcAddress,phone1,emailId,IPAddress,erroMessage,false);
                                        return null;
                                    }
                                }
                            }
                            else{
                                //Account not provisioned error
                                componentToPage.isStep1=true;
                                componentToPage.isStep2=false;
                                componentToPage.isStep3=false;
                                componentToPage.isStep4=false;
                                isprovisionAccount=true;
                                createnewUserRegistrationHistroy(accountNumber,MAcAddress,phone1,emailId,IPAddress,Accpending,false);
                            }
                        }
                    }else{//if the account is invalid,redirecting to error page.
                        componentToPage.isStep1=true;
                        componentToPage.isStep2=false;
                        componentToPage.isStep3=false;
                        componentToPage.isStep4=false;
                        isAccountFound=false;
                        isAccountNotFound=false;
                        isEmailorPhonenotMatch =true;
                        toatlIncorrect++;
                        //create record
                        createnewUserRegistrationHistroy(accountNumber,MAcAddress,phone1,emailId,IPAddress,AccPhoneEmail,false);
                        createUserLockRecord(toatlIncorrect,accountNumber,MAcAddress,ReturnValue); 
                        return null;
                   }      
                 }
                 else
                 {
                    isAccountNotFound=true;
                    isAccwrong=true;
                    toatlIncorrect++;                   
                    createUserLockRecord(toatlIncorrect,accountNumber,MAcAddress,ReturnValue);
                    erroMessage=AtlasUtility.getMapValue(Atlasconstants.MAC_NO_NOT_EXIST);
                    createnewUserRegistrationHistroy(accountNumber,MAcAddress,phone1,emailId,IPAddress,erroMessage,false);
                 }
            }
        }
        catch(Exception e)
        {   //if any thing went wrong
            toatlIncorrect++;
            isAccountFound=false;
            isAccountNotFound=true;
            isMACwrong=true;
            isEmailorPhonenotMatch =false;
            system.debug('++++Total Incorrect 2+++'+toatlIncorrect);
            createUserLockRecord(toatlIncorrect,accountNumber,MAcAddress,ReturnValue);            
            erroMessage=AtlasUtility.getMapWispValue(Atlasconstants.Wisp_ACC_MAC_NOT_EXIST);
            createnewUserRegistrationHistroy(accountNumber,MAcAddress,phone1,emailId,IPAddress,erroMessage,false);
            return null;
        }
        finally{
            ClearFields();
        }
        return null;
    }
    //goback to step-1
    public pagereference tryAgain()
    {
        ClearFields();
        isAccountNotFound=false;
        componentToPage.isStep1=true;
        componentToPage.isStep2=false;
        isAccountExist=false;
        isprovisionAccount=false;
        isEmailorPhonenotMatch=false;
        isNotAuthorized=false;
        return null;
    }
    //goback to step-1
    public pagereference redirectToLoginHelp()
    {
        ClearFields();
        //return new PageReference(Atlasconstants.ATLAS_LOGIN_HELP_URL);
        return new PageReference('/apex/subscriber_reset_password');
    }
    //goback to step-1
    public pagereference cancel()
    {
        ClearFields();
        isAccountNotFound=false;
        String siteURl =site.getBaseurl();
        if(siteURl!=null && !siteURl.contains(AtlasConstants.Https_text))
        {
            siteURl.replace(AtlasConstants.Http_text,AtlasConstants.Https_text);
            return new PageReference( siteURl+Atlasconstants.ATLAS_COMMUNITY_URL);
        }
           else
           return new PageReference(Atlasconstants.ATLAS_DEV_URL);
    }
    
    // to clear i/p values.
    public void ClearFields()
    {
        accountNumber='';
        MACValue1='';
        MAcAddress='';
        phone1='';
        emailId='';       
    }
    
    //create a record in custom setting for user lock
    public void createUserLockRecord(integer toatlIncorrect, String accountNumber, String MAcAddress, String ReturnValue)
    {
        //from custom settimng
        Atlas_User_Lock_Out__c objUserLock;
        Long recDate;
        Long sysDate;
        Double timeDiff;
        datetime dtime=system.now();
        system.debug('++++Total Incorrect 3+++'+toatlIncorrect);
        //to get ip address
        //List<User_Lock_Outs__c> lstvalues1= User_Lock_Outs__c.getAll().values();
        objUser=[select Name,Time_Value__c,TotalWrong__c from Atlas_User_Lock_Out__c where Name =: ReturnValue ORDER BY LastModifiedDate];
            if(!AtlasUtility.isEmpty(MAcAddress))
            {   
            	if(!AtlasUtility.isEmpty(objuser))
            	{
	            	list<Atlas_User_Lock_Out__c> lstdelete= new list<Atlas_User_Lock_Out__c>();
	                    if(objUser[0].Name == ReturnValue)
	                    {
	                        recDate =  objUser[0].Time_Value__c.getTime() / 1000;
	                        sysDate = dtime.getTime() / 1000;
	                        timeDiff = sysDate - recDate;
	                        lastAttempt=timeDiff/60;
	                        lstdelete.add(objUser[0]);
	                    }
	                    
	                if(!AtlasUtility.isEmpty(lstdelete))
	                delete lstdelete;
            	}
                if(lastAttempt<10 && toatlIncorrect<=5){
                    objUserLock=new Atlas_User_Lock_Out__c(Name=ReturnValue,Time_value__c=system.now(),Totalwrong__c=toatlIncorrect);
                }
                else{
                    objUserLock=new Atlas_User_Lock_Out__c(Name=ReturnValue,Time_value__c=system.now(),Totalwrong__c=1);
                }
                upsert objUserLock Name;
            }
        }
        
        //Create New User Registration History Record
		public void createnewUserRegistrationHistroy(String account, String MAC, String phone, String email, String IPAddress, String errMsg, boolean Identification)
		{
			New_User_Registration_History__c nurh = new New_User_Registration_History__c();			
			if(!AtlasUtility.isEmpty(MAC) && MAC != MacPlaceHolder)
				nurh.MAC_Address__c = MAC;
			if(!AtlasUtility.isEmpty(phone) && phone != PhonePlaceHolder)
				nurh.Phone_Number__c = phone;
			if(!AtlasUtility.isEmpty(email) && email != EmailPlaceHolder)
				nurh.Email_Address__c = email;
			nurh.IP_Address__c = IPAddress;
			nurh.Time_Stamp__c = system.now();
			nurh.Strp1_Identification__c = Identification;
			nurh.Error_Message__c = errMsg;
			try{
				insert nurh;
			}catch(Exception e)
			{
				
			}
			componenttoPage.IPAddress = IPAddress;
			list<New_User_Registration_History__c> nurhList = [select id,name from New_User_Registration_History__c where id =: nurh.id ORDER BY createddate];
			
			if(nurhList != null && nurhList.Size()>0)
			{
				componenttoPage.nurhNumber = nurhList[0].Name;
			}
			
		}       
}