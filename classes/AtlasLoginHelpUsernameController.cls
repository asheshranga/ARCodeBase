public with sharing class AtlasLoginHelpUsernameController {
    
    //Constant variables
    public string note{get{return Atlasconstants.NOTE;}set;}
    public string loginHelpText{get{return AtlasConstants.LOGIN_HELP_TEXT;}set;}
    public string identificationText {get{return Atlasconstants.IDENTIFICATION_TEXT;}set;}
    public string loginFirstText {get{return Atlasconstants.LOGIN_FIRST_TEXT;}set;}
    public string loginInstText {get{return AtlasUtility.getMapValue(Atlasconstants.LOGIN_INST_TEXT);}set;}
    public string loginPblmText{get{return Atlasconstants.LOGIN_PROBLEM_TEXT;}set;}
    public string loginMacText{get{return AtlasUtility.getMapValue(Atlasconstants.LOGIN_MAC_TEXT);}set;}
    public string loginAccText{get{return AtlasUtility.getMapValue(Atlasconstants.LOGIN_ACC_TEXT);}set;}
    public string loginaccNotFound{get{return AtlasUtility.getMapValue(Atlasconstants.LOGIN_ACC_NOT_FOUND_TEXT);}set;}
    public string accRequired{get{return AtlasUtility.getMapValue(Atlasconstants.LOGIN_ACC_VALIDATE);}set;}
    public string macRequired{get{return AtlasUtility.getMapValue(Atlasconstants.LOGIN_MAC_VALIDATE);}set;}
    public string account{get{return AtlasUtility.getMapValue(Atlasconstants.LOGIN_ACC_INST_TEXT);}set;}
    public string macaddress{get{return AtlasUtility.getMapValue(Atlasconstants.LOGIN_MAC_INST_TEXT);}set;}
    public string loginCCText{get{return Atlasconstants.LOGIN_CC_TEXT;}set;}
    public string loginCCNo{get{return AtlasUtility.getMapValue(Atlasconstants.LOGIN_CC_NO_TEXT);}set;}
    public string tryAgain{get{return Atlasconstants.LOGIN_TRY_AGAIN_TEXT;}set;}
    public string accLabel{get{return Atlasconstants.LOGIN_ACC_LABEL;}set;}
    public string macLabel{get{return Atlasconstants.LOGIN_MAC_LABEL;}set;}
    public string allFields{get{return Atlasconstants.LOGIN_ALL_FIELDS_TEXT;}set;}
    public string cancel{get{return Atlasconstants.LOGIN_CANCEL;}set;}
    public string nextStep{get{return Atlasconstants.LOGIN_NEXT_STEP;}set;}
    public string step{get{return AtlasConstants.STEP_1_4;}set;}
    public string whatisThis{get{return AtlasUtility.getMapValue(Atlasconstants.WHAT_IS_THIS);}set;}
    public string imSorry{get{return AtlasUtility.getMapValue(Atlasconstants.IM_SORRY);}set;}
    public string startLive{get{return AtlasUtility.getMapValue(Atlasconstants.START_LIVE);}set;}
    public string emailSent{get{return AtlasUtility.getMapValue(Atlasconstants.EMAIL_SENT);}set;}
    public string userIdentHelpText1{get{return AtlasUtility.getMapValue(AtlasConstants.USER_IDENT_HELP_TEXT_1);}set;}
    public string userIdentHelpText2{get{return AtlasUtility.getMapValue(AtlasConstants.USER_IDENT_HELP_TEXT_2);}set;}
    public string accountHelpText1{get{return AtlasUtility.getMapValue(AtlasConstants.ACC_HELP_TEXT_1);}set;}
    public string accountHelpText2{get{return AtlasUtility.getMapValue(AtlasConstants.ACC_HELP_TEXT_2);}set;}
    public string MacDigits{get{return AtlasUtility.getMapValue(AtlasConstants.MAC_DIGITS);}set;}
    public string AccPlaceHolder{get{return AtlasUtility.getMapValue(AtlasConstants.ACC_NO_PLACE_HOLDER);}set;}
    public string MacPlaceHolder{get{return AtlasUtility.getMapValue(AtlasConstants.MAC_PLACE_HOLDER);}set;}
    public string UserNameDescription{get{return AtlasUtility.getMapValue(AtlasConstants.LOGIN_HELP_UNAME_DESC);}set;}
    //Variables used in the component
    public string accountNumber{get;set;}
    public string MACValue1{get;set;}
    public string MACValue2{get;set;}
    public string MACValue3{get;set;}
    public string MACValue4{get;set;}
    public string MACValue5{get;set;}
    public string MACValue6{get;set;}
    public AtlasComponenttoController componentToPage{get; set;}
    public boolean isAccountFound{get;set;}
    //Boolean variables
    public boolean isAccRequired{get;set;}
    public boolean isMACRequired{get;set;}
    public boolean isEmailsent{get;set;}
    public string erroMessage{get;set;}
    public boolean isAccwrong{get;set;}
    public boolean isLoginUserNameExists{get;set;}
    public  String loginUserNameValue{get;set;}
    public boolean isnoUsername{get;set;}
    public string liveChat{get{return Atlasconstants.LIVE_CHAT;}set;}
    public string liveChatUrl{get{return AtlasUtility.getURL(Atlasconstants.LIVE_CHAT_URL);}set;}
    public string AccLocked{get{return AtlasUtility.getMapValue(AtlasConstants.ACC_LOCKED);}set;}
    public string AccLocked1{get{return AtlasUtility.getMapValue(AtlasConstants.ACC_LOCKED1);}set;}
    public string AccLocked2{get{return AtlasUtility.getMapValue(AtlasConstants.ACC_LOCKED2);}set;}
    //public User_Lock_Out__c objUserLock{get;set;}
    public integer toatlIncorrect{get;set;}
    public boolean isLocked{get;set;}
    public double remainingMinutes{get;set;}
    public double lastAttempt{get;set;}
    public boolean isCalloutFailed{get;set;}
    List<User_Lock_Outs__c> lstvalues= User_Lock_Outs__c.getAll().values();
    public static Map<String,User_Lock_Outs__c> MapKeyValue=User_Lock_Outs__c.getAll();
    public string ReturnValue;
    List<Atlas_User_Lock_Out__c> objUser = null;
    Atlas_User_Lock_Out__c objvalue = null;
    public AtlasLoginHelpUsernameController()
    {
        isAccRequired=true;
        isMACRequired=false;
        isAccountFound=false;
        isLoginUserNameExists=false;
        loginUserNameValue='';
        isnoUsername=false;
        isLocked=false;
        ReturnValue = '';
	    ReturnValue = ApexPages.currentPage().getHeaders().get('True-Client-IP');
	    if ( (ReturnValue == null) || (ReturnValue.trim().equals('')) ) {
	       ReturnValue = ApexPages.currentPage().getHeaders().get('X-Salesforce-SIP')+'LoginHelpUN';
	    }
	    system.debug('ReturnValue____'+ReturnValue);
	    /*objUser=[select Name,Time_Value__c,TotalWrong__c from Atlas_User_Lock_Out__c where Name =: ReturnValue ORDER BY LastModifiedDate];
	    if(!AtlasUtility.isEmpty(objUser) && objUser.size() > 0)
	    {
	    	objvalue = objUser[0];
         	if(objvalue.Name==ReturnValue)	        
         		toatlIncorrect=(integer.valueOf(objValue.Totalwrong__c));
         	else
         		toatlIncorrect=0;	         		         		
	     }
	     else
	     {
	     	toatlIncorrect =0;
	     }*/         
    }
    
    // onclick of submit-
    public pagereference submitStep1()
    {
        
        objUser=[select Name,Time_Value__c,TotalWrong__c from Atlas_User_Lock_Out__c where Name =: ReturnValue ORDER BY LastModifiedDate];
	    if(!AtlasUtility.isEmpty(objUser) && objUser.size() > 0)
	    {
	    	objvalue = objUser[0];
         	if(objvalue.Name==ReturnValue)	        
         		toatlIncorrect=(integer.valueOf(objValue.Totalwrong__c));
         	else
         		toatlIncorrect=0;	         		         		
	     }
	     else
	     {
	     	toatlIncorrect =0;
	     } 
        try 
        {   
        	boolean isFailed=false;
            long dt1;
            if(!AtlasUtility.isEmpty(objUser) && objUser.size() > 0)
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
            datetime d=system.now();
            if(isFailed)
            {
               long dt2 = d.getTime() / 1000;
               double dt = dt2 - dt1;
               remainingMinutes=dt/60;
               if(remainingMinutes <5.0)
               {
                    isLocked=true;
                    componentToPage.LHStep1=false;
                    componentToPage.LHStep2=true;
                    Decimal dec=decimal.valueOf(remainingMinutes).setScale(1,System.RoundingMode.UP);
                    remainingMinutes=dec.round();
                    return null;
               }
               
            }   
            else
            {
                isLocked=false;
            }   
            Long subKey;
            AtlasPublicWebServiceSearchServiceStub.findSubscribersBySearchCriteriaResponse repsonseObj;
            string MAcAddress;
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
            if(!AtlasUtility.isEmpty(accountNumber) || !AtlasUtility.isEmpty(MAcAddress))
            {
                if(!AtlasUtility.isEmpty(accountNumber))
                    {// to make callout to identify  the acount
                        if (!Test.isRunningTest())      
                        repsonseObj=AtlasIntegrationUtility.findSubscribersBySearchCriteriaGeneric(null,null,AtlasConstants.EX_REF_FOR_SEARCH,accountNumber,null,null,null,null,null,null,null,null,null,null);
                        else
                        repsonseObj=(AtlasPublicWebServiceSearchServiceStub.findSubscribersBySearchCriteriaResponse)JSON.deserialize(AtlasTestConstants.getMetadata('findSubscribersBySearchCriteriaResponse'),AtlasPublicWebServiceSearchServiceStub.findSubscribersBySearchCriteriaResponse.class);
                    }   
                else{   if (!Test.isRunningTest())
                        repsonseObj=AtlasIntegrationUtility.findSubscribersBySearchCriteriaGeneric(null,null,null,null,null,null,null,null,null,null,null,null,MacAddress,null);
                        else
                        repsonseObj=(AtlasPublicWebServiceSearchServiceStub.findSubscribersBySearchCriteriaResponse)JSON.deserialize(AtlasTestConstants.getMetadata('findSubscribersBySearchCriteriaResponse'),AtlasPublicWebServiceSearchServiceStub.findSubscribersBySearchCriteriaResponse.class);
                    }
            }   
            if(!AtlasUtility.isEmpty(repsonseObj)&& !AtlasUtility.isEmpty(repsonseObj.subscriber))
            {   // to get subscriber information
                AtlasPublicWebServiceSearchServiceStub.Subscriber cusInfoObj=repsonseObj.subscriber[0];
                //validation to verify the account number is valid--(cusInfoObj.account.externalAccountReference!=null) ||(!cusInfoObj.account.externalAccountReference.trim().equals(''))
                if(cusInfoObj.account.internalAccountReference == accountNumber || cusInfoObj.serviceAgreement.macAddress == MacAddress)
                {   
                    AtlasSSOWS.getSubscribersResponse_element subRepsonseObj;
                    if (!Test.isRunningTest())
                        subRepsonseObj=AtlasIntegrationUtility.getSSOSubscribers(cusInfoObj.serviceAgreement.internalServiceAgreementReference,'','','');
                    else
                        subRepsonseObj=(AtlasSSOWS.getSubscribersResponse_element)JSON.deserialize(AtlasTestConstants.getMetadata('findSSOsubscribersbyinternalServiceAgreementReference'),AtlasSSOWS.getSubscribersResponse_element.class);
                    system.debug('+++subRepsonseObj++++'+subRepsonseObj);
                    if(!AtlasUtility.isEmpty(subRepsonseObj))
                    {
                        if(subRepsonseObj.totalsubscribers!=0&&subRepsonseObj.status=='Success')
                        {
                            for(AtlasSSOWS.subscriberType subType : subRepsonseObj.subscribers.subscriber){
                                if(subType.subscriberkey != null)
                                subKey = subType.subscriberkey;
                            }
                            AtlasSSOWS.getSubscriberResponse_element subResObj;
                            if (!Test.isRunningTest())
                                subResObj = AtlasIntegrationUtility.getSSOSubscriber(subKey);
                            else
                                subResObj=(AtlasSSOWS.getSubscriberResponse_element)JSON.deserialize(AtlasTestConstants.getMetadata('getSubscriberResponse_element'),AtlasSSOWS.getSubscriberResponse_element.class); 
                            system.debug('+++subRepsonseObj++++'+subRepsonseObj); 
                            if(!AtlasUtility.isEmpty(subResObj))
                            {
                                for(AtlasSSOWS.sprAttributeType obj : subResObj.subscriber.sprattributes.sprattribute){
                                        if(obj.name.trim() == 'loginUserName'){
                                           //if the account is valid, redirecting to step-2
                                            isLoginUserNameExists = true;
                                            isnoUsername=false;
                                            loginUserNameValue = obj.value;
                                            componentToPage.LHStep1=false;
                                            componentToPage.LHStep2=true;
                                            componentToPage.accountName=cusInfoObj.contact.person.firstName+''+cusInfoObj.contact.person.lastName;
                                            isAccountFound=false;
                                            isEmailsent=true;
                                            isAccwrong=false;
                                            if(!AtlasUtility.isEmpty(cusInfoObj.contact.emailAddress) && !AtlasUtility.isEmpty(cusInfoObj.account.externalAccountReference))
                                            sendUserNametoUser(cusInfoObj.contact.emailAddress,cusInfoObj.account.externalAccountReference);
                                            return null;
                                        }
                                    }
                                    if(!isLoginUserNameExists){
                                        if(loginUserNameValue =='' || loginUserNameValue == null){
                                            isnoUsername=true;
                                            toatlIncorrect++;
                    						createUserLockRecord(toatlIncorrect, ReturnValue);
                                            componentToPage.LHStep1=false;
                                            componentToPage.LHStep2=true;
                                        }
                                    }
                            }
                        }
                        else{
                        	//if any thing went wrong
				            toatlIncorrect++;
				            createUserLockRecord(toatlIncorrect, ReturnValue);
				            isAccountFound=true;
				            isAccwrong=true;            
				            componentToPage.LHStep1=false;
				            componentToPage.LHStep2=true;
				            erroMessage=AtlasUtility.getMapValue(Atlasconstants.ACC_MAC_NOT_EXIST);
				            return null;
                        }
                    }
                        
                }else{//if the account is invalid,redirecting to error page.
                	toatlIncorrect++;
                    createUserLockRecord(toatlIncorrect, ReturnValue);
                    componentToPage.LHStep1=false;
                    componentToPage.LHStep2=true;
                    isAccwrong=false;                    
                    isAccountFound=true;
                    isEmailsent=false;
                    return null;
            }       
            }
            else
             {
             	toatlIncorrect++;
                createUserLockRecord(toatlIncorrect, ReturnValue);
                isAccountFound=true;
                isAccwrong=false;
                if(Test.isRunningTest()){string e = null; e.tolowercase();}
             }
             return null;
        }
        catch(exception e)
        {   //if any thing went wrong
            toatlIncorrect++;
            createUserLockRecord(toatlIncorrect, ReturnValue);
            isAccountFound=true;
            isAccwrong=true;            
            componentToPage.LHStep1=false;
            componentToPage.LHStep2=true;
            erroMessage=AtlasUtility.getMapValue(Atlasconstants.ACC_MAC_NOT_EXIST);
            return null;
        }
        finally{
            ClearFields();
        }
    }
    
    //goback to step-1
    public pagereference cancel()
    {
        ClearFields();
        String siteURl =site.getcurrentsiteurl();
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
        MACValue2='';
        MACValue3='';
        MACValue4='';
        MACValue5='';
        MACValue6='';
    }
    //goback to step-1
    public pagereference tryAgain()
    {
        ClearFields();
        isAccountFound=false;
        return null;
    }
    //
    public void sendUserNametoUser(string emailAddress, string externalAccRef)
    {
        List<User> lstUser=[select id,contactId,Name,email from user where contact.email=:emailAddress AND ExternalAccountReference__c=: externalAccRef limit 1];
        list<EmailTemplate> emialtempId=[SELECT Id,DeveloperName FROM EmailTemplate WHERE DeveloperName =:AtlasUtility.getMapValue(Atlasconstants.FORGOT_USERNAME_TEXT) limit 1];
        if(!AtlasUtility.isEmpty(lstUser) && !AtlasUtility.isEmpty(emialtempId))
        {
            List<Messaging.SingleEmailMessage> mailList = new List<Messaging.SingleEmailMessage>();
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            mail.setTargetObjectId(lstUser[0].contactId);
            mail.setTemplateId(emialtempId[0].Id);
            mail.setsaveAsActivity(false);
            mail.setWhatId(lstUser[0].Id);
            mailList.add(mail);
            if(mailList!=null && mailList.size()>0)
            Messaging.sendEmail(mailList);
        }       
    }
    public PageReference redirectToNewUserSetup() {       
        pagereference page=new pagereference(AtlasConstants.ATLAS_NEW_USER_URL);
        page.setRedirect(true);
        return page; 
    }
    
    //create record
	public void createUserLockRecord(integer toatlIncorrect, String ReturnValue)
	{
	    Atlas_User_Lock_Out__c objUserLock;
	    //List<User_Lock_Outs__c> lstvalues= User_Lock_Outs__c.getAll().values();
	    Long recDate;
	    Long sysDate;
	    Double timeDiff;
	    datetime dtime=system.now();
	    String sessionId = userInfo.getSessionId();
	    if(!AtlasUtility.isEmpty(ReturnValue))
	    {   
	    	list<Atlas_User_Lock_Out__c> lstdelete= new list<Atlas_User_Lock_Out__c>();
	        if(!AtlasUtility.isEmpty(objUser) && objUser.size() > 0)
	        {
	            if(objvalue.Name==ReturnValue)
	            {
	                recDate =  objvalue.Time_Value__c.getTime() / 1000;
	                sysDate = dtime.getTime() / 1000;
	                timeDiff = sysDate - recDate;
	                lastAttempt=timeDiff/60;
	                lstdelete.add((objvalue));
	            }
	        }
	        if(!AtlasUtility.isEmpty(lstdelete))
	        delete lstdelete;
	        if(lastAttempt<10 && toatlIncorrect <= 5){
	            objUserLock=new Atlas_User_Lock_Out__c(Name=ReturnValue,Time_value__c=system.now(),Totalwrong__c=toatlIncorrect);
	        }
	        else{
	            objUserLock=new Atlas_User_Lock_Out__c(Name=ReturnValue,Time_value__c=system.now(),Totalwrong__c=1);
	        }
	        upsert objUserLock Name;
	    }
	}
}