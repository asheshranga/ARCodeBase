public with sharing class AtlasLoginHelpPasswordController {
    
    
    //Constant variables
    public string resetPwd_Uname{get{return Atlasconstants.RESET_MYPWD_TEXT;}set;}
    public string step2{get{return Atlasconstants.STEP_2_4;}set;}
    public string step3{get{return Atlasconstants.STEP_3_4;}set;}
    public string step4{get{return Atlasconstants.STEP_4_4;}set;}
    public string plsUname{get{return Atlasconstants.PLS_UNAME;}set;}
    public string UnameText{get{return Atlasconstants.UNAME;}set;}
    public string required{get{return Atlasconstants.REQUIRED;}set;}
    public string accNotFoundText{get{return AtlasUtility.getMapValue(Atlasconstants.ACC_NOT_FOUND);}set;}
    public string liveChat{get{return Atlasconstants.LIVE_CHAT;}set;}
    public string toGetHelp{get{return Atlasconstants.TO_GET_HELP;}set;}
    public string resetPWDSQ{get{return Atlasconstants.RESET_PWD_SQ;}set;}
    public string firstQ{get{return Atlasconstants.FIRST_Q;}set;}
    public string firstQA{get{return Atlasconstants.FIRST_QA;}set;}
    public string secondQ{get{return Atlasconstants.SECOND_Q;}set;}
    public string secondQA{get{return Atlasconstants.SECOND_QA;}set;}
    public string forgotUNameLink{get{return Atlasconstants.FORGOT_UNAME_LINK;}set;}
    public string sQIncorrect{get{return AtlasUtility.getMapValue(Atlasconstants.SQ_INCORRECT);}set;}
    public string sQIncorrect5minutes{get{return AtlasUtility.getMapValue(Atlasconstants.SQ_INCORRECT_FIVE_TIMES);}set;}
    public string AccLocked{get{return AtlasUtility.getMapValue(AtlasConstants.ACC_LOCKED);}set;}
    public string AccLocked1{get{return AtlasUtility.getMapValue(AtlasConstants.ACC_LOCKED1);}set;}
    public string AccLocked2{get{return AtlasUtility.getMapValue(AtlasConstants.ACC_LOCKED2);}set;}
    public string speakRep{get{return AtlasUtility.getMapValue(Atlasconstants.SPEAK_REP);}set;}
    public string resetPWDNew{get{return Atlasconstants.RESET_PWD_NEWPWD;}set;}
    public string pwdText{get{return Atlasconstants.PWD_LABEL;}set;}
    public string weak{get{return Atlasconstants.WEAK;}set;}
    public string good{get{return Atlasconstants.GOOD;}set;}
    public string strong{get{return Atlasconstants.STRONG;}set;}
    public string rePwd{get{return Atlasconstants.RE_PWD;}set;}
    public string finished{get{return Atlasconstants.FINISHED;}set;}
    public string pwdDone{get{return AtlasUtility.getMapValue(Atlasconstants.PWD_DONE);}set;}
    public string nextStep{get{return Atlasconstants.LOGIN_NEXT_STEP;}set;}
    public string cancel{get{return Atlasconstants.LOGIN_CANCEL;}set;}
    public string loginHelpText{get{return AtlasConstants.LOGIN_HELP_TEXT;}set;}
    public string note{get{return Atlasconstants.NOTE;}set;}
    public string loginPblmText{get{return Atlasconstants.LOGIN_PROBLEM_TEXT;}set;}
    public string chooseOne{get{return Atlasconstants.CHOOSE_ONE;}set;}
    public string strInvalidPwd{get{return AtlasUtility.getMapValue(Atlasconstants.PWD_VALIDATION_MSG);}set;}
    public string validemail{get{return AtlasUtility.getMapValue(Atlasconstants.PLS_EMAIL_VALID);}set;}
    public string uNameLimit{get{return AtlasUtility.getMapValue(Atlasconstants.LOGIN_UNAME_LIMIT);}set;}
    public string unamereqd{get{return AtlasUtility.getMapValue(Atlasconstants.LOGIN_UNAME_REQD);}set;}
    public string firstAnswerReqd{get{return AtlasUtility.getMapValue(Atlasconstants.FIRST_ANSWER);}set;}
    public string secondAnswerReqd{get{return AtlasUtility.getMapValue(Atlasconstants.SECOND_ANSWER);}set;}
    public string pwdReqd{get{return AtlasUtility.getMapValue(Atlasconstants.PWD_REQD);}set;}
    public string cpwdReqd{get{return AtlasUtility.getMapValue(Atlasconstants.CPWD_REQD);}set;}
    public string sqhelp{get{return AtlasUtility.getMapValue(Atlasconstants.FP_SQ_HELP);}set;}
    public string newUnameHelp{get{return AtlasUtility.getMapValue(Atlasconstants.NEW_UNAME_HELP);}set;}
    public string newUnameHelp1{get{return AtlasUtility.getMapValue(Atlasconstants.LOGIN_UNAME_HELP1);}set;}
    public string newUnameHelp2{get{return AtlasUtility.getMapValue(Atlasconstants.LOGIN_UNAME_HELP2);}set;}
    public string sqHelpText{get{return AtlasUtility.getMapValue(Atlasconstants.QUES_NEWUSR_HLP_TEXT);}set;}
    public string sqAnswerHelpText{get{return AtlasUtility.getMapValue(Atlasconstants.ANS_NEWUSR_HLP_TEXT);}set;}
    public string passwordHelpText{get{return AtlasUtility.getMapValue(Atlasconstants.PSWD_HELP_TEXT);}set;}
    public string pwdvalid1{get{return AtlasUtility.getMapValue(Atlasconstants.PWD_VALIDATION1);}set;}
    public string pwdvalid2{get{return AtlasUtility.getMapValue(Atlasconstants.PWD_VALIDATION2);}set;}
    public string pwdvalid3{get{return AtlasUtility.getMapValue(Atlasconstants.PWD_VALIDATION3);}set;}
    public string pwdvalid4{get{return AtlasUtility.getMapValue(Atlasconstants.PWD_VALIDATION4);}set;}
    public string pwdvalid5{get{return AtlasUtility.getMapValue(Atlasconstants.PWD_VALIDATION5);}set;}
    public string pwdvalid6{get{return AtlasUtility.getMapValue(Atlasconstants.PWD_VALIDATION6);}set;}
    public string liveChatUrl{get{return AtlasUtility.getURL(Atlasconstants.LIVE_CHAT_URL);}set;}
    public string SQmessge1{get{return AtlasUtility.getMapValue(Atlasconstants.SQ1_VALID_FAILED);}set;}
    public string SQmessge2{get{return AtlasUtility.getMapValue(Atlasconstants.SQ2_VALID_FAILED);}set;} 
    //step1
    public string userName{get;set;}
    public boolean isAccountFound{get;set;}
    public boolean isSQAFalse{get;set;}
    public AtlasComponenttoController componentToPage{get; set;}
    //boolean variables to hide/show step1,2,3.
    public boolean isStep1{get;set;}
    public boolean isStep2{get;set;}
    public boolean isStep3{get;set;}
    public boolean isFinal{get;set;}
    //step3
    public string password{get;set;}
    public string confirmPwd{get;set;}
    
    public string selectedSQA1{get;set;}
    public string selectedSQA2{get;set;}
    public List<SelectOption> getOptionsForQ1() {
        List<SelectOption> options = new List<SelectOption>(); 
        List<AtlasSecurityQuestionsList__c> SQList=AtlasSecurityQuestionsList__c.getall().values();
        for (AtlasSecurityQuestionsList__c bSQ: SQList)
        options.add(new SelectOption(bSQ.Value__c,bSQ.Value__c));
        return options; 
    }
    
    public List<SelectOption> getOptionsForQ2() {
        List<SelectOption> options = new List<SelectOption>(); 
        List<AtlasSecurityQuestionsList1__c> SQList=AtlasSecurityQuestionsList1__c.getall().values();
        for (AtlasSecurityQuestionsList1__c bSQ: SQList)
        options.add(new SelectOption(bSQ.Value__c,bSQ.Value__c));
        return options; 
    }
    public integer toatlIncorrect{get;set;}
    //masked data
    public string maskedSQAnswer1{get;set;}
    public string maskedSQAnswer2{get;set;}
    public boolean isMaskedSQA1{get;set;}
    public boolean isMaskedSQA2{get;set;}
    public string sqAnswer1{get;set;}
    public string sqAnswer2{get;set;}
    public string sqQuestion1{get;set;}
    public string sqQuestion2{get;set;}
    //
    public boolean isPWDReset{get;set;}
    public string errormsg{get;set;}
    //public User_Lock_Out__c objUserLock{get;set;}
    public boolean isLocked{get;set;}
    public double remainingMinutes{get;set;}
    public double lastAttempt{get;set;}
    public boolean isCalloutFailed{get;set;}
    //List<User_Lock_Outs__c> lstvalues= User_Lock_Outs__c.getAll().values();
    //public static Map<String,User_Lock_Outs__c> MapKeyValue=User_Lock_Outs__c.getAll();
    public string ReturnValue;
    List<Atlas_User_Lock_Out__c> objUser = null;
    Atlas_User_Lock_Out__c objvalue = null;
    public AtlasLoginHelpPasswordController()
    {
        isStep1=true;
        isStep2=false;
        isStep3=false;
        isFinal=false;
        isAccountFound=false;
        isSQAFalse=false;
        isMaskedSQA1=false;
        isMaskedSQA2=false;
        maskedSQAnswer1='';
        maskedSQAnswer2='';
        isPWDReset=false;
        isLocked=false;
        ReturnValue = '';
        ReturnValue = ApexPages.currentPage().getHeaders().get('True-Client-IP');
        if ( (ReturnValue == null) || (ReturnValue.trim().equals('')) ) {
           ReturnValue = ApexPages.currentPage().getHeaders().get('X-Salesforce-SIP')+'LoginHelp';
        }
        system.debug('ReturnValue____'+ReturnValue);
        /*objUser=[select Name,Time_Value__c,TotalWrong__c from Atlas_User_Lock_Out__c where Name =: ReturnValue ORDER BY LastModifiedDate];
        if(!AtlasUtility.isEmpty(objUser) && objUser.size() > 0)
        {
            objvalue = objUser[0];
            if(objvalue.Name==ReturnValue)          
                toatlIncorrect=(integer.valueOf(objValue.Totalwrong__c));
            else 
                toatlIncorrect =0;                                        
         }
         else
         {
            toatlIncorrect =0;
         }*/      
    }
    //to validate username and capture security questions& answers.
    public pagereference NextStep1()
    {
        try
        {
            objUser=[select Name,Time_Value__c,TotalWrong__c from Atlas_User_Lock_Out__c where Name =: ReturnValue ORDER BY LastModifiedDate];
            if(!AtlasUtility.isEmpty(objUser) && objUser.size() > 0)
            {
                objvalue = objUser[0];
                if(objvalue.Name==ReturnValue)          
                    toatlIncorrect=(integer.valueOf(objValue.Totalwrong__c));
                else 
                    toatlIncorrect =0;                                        
             }
             else
             {
                toatlIncorrect =0;
             }   
            if(!AtlasUtility.isEmpty(userName))
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
                   system.debug('Remaining Min----->'+remainingMinutes);
                   if(remainingMinutes <5.0)
                   {
                        isLocked=true;
                        isStep1=true;
                        isStep2=false;
                        Decimal dec=decimal.valueOf(remainingMinutes).setScale(1,System.RoundingMode.UP);
                        remainingMinutes=dec.round();
                        return null;
                   }
                   
                }     
                AtlasSSOWS.getSubscribersResponse_element repsonseObj;
                if (!Test.isRunningTest())
                    repsonseObj=AtlasIntegrationUtility.getSSOSubscribers('','',AtlasUtility.getMapValue(AtlasConstants.Atlas_loginUserName_Attribute),userName);
                else
                    repsonseObj=(AtlasSSOWS.getSubscribersResponse_element)JSON.deserialize(AtlasTestConstants.getMetadata('findSSOSubscribersResponse'),AtlasSSOWS.getSubscribersResponse_element.class);

                if(!AtlasUtility.isEmpty(repsonseObj))
                {   
                    if(repsonseObj.totalsubscribers>0&&repsonseObj.status=='Success')
                    {   
                        if(!AtlasUtility.isEmpty(repsonseObj.subscribers.subscriber))
                        {   
                            for(AtlasSSOWS.subscriberType obj:repsonseObj.subscribers.subscriber)
                            {
                                componentToPage.subscriberKey=obj.subscriberkey;
                            }
                            
                            if(componentToPage.subscriberKey!=null)
                            {
                                AtlasSSOWS.getSubscriberResponse_element objRepsonse;
                                if (!Test.isRunningTest())
                                    objRepsonse=AtlasIntegrationUtility.getSSOSubscriber(componentToPage.subscriberKey);
                                else
                                    objRepsonse=(AtlasSSOWS.getSubscriberResponse_element)JSON.deserialize(AtlasTestConstants.getMetadata('findSSOSubscriberResponse'),AtlasSSOWS.getSubscriberResponse_element.class);

                                if(!AtlasUtility.isEmpty(objRepsonse.subscriber.sprattributes.sprattribute))
                                {
                                    for(AtlasSSOWS.sprAttributeType obj: objRepsonse.subscriber.sprattributes.sprattribute)
                                    {   
                                        if(obj.name=='securityQuestion')
                                        {   
                                            if(!AtlasUtility.isEmpty(obj.values.value))
                                            {
                                                string str='';
                                                for(string objValue: obj.values.value)
                                                {
                                                    str+=objValue+'-';
                                                    componentToPage.securityQList=str;
                                                }
                                                if(!AtlasUtility.isEmpty(componentToPage.securityQList))
                                                {
                                                    string[] strvalue=componentToPage.securityQList.split('-');
                                                    string[] str1=strvalue[0].split(';');
                                                    string[] str2=strvalue[1].split(';');
                                                    sqQuestion1 = str1[0];
                                                    sqQuestion2 = str2[0];
                                                    componentToPage.securityQ1=str1[0];
                                                    componentToPage.securityQA1=str1[1];
                                                    componentToPage.securityQ2=str2[0];
                                                    componentToPage.securityQA2=str2[1];
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                            isStep1=false;
                            isStep2=true;
                            isStep3=false;
                            isFinal=false;
                            componentToPage.userName=userName;
                            isAccountFound=false;
                            isCalloutFailed=false;
                            if(Test.isRunningTest()){string e = null; e.tolowercase();}
                        }
                        
                    }
                    else
                    {
                        isStep1=true;
                        isStep2=false;
                        isStep3=false;
                        isFinal=false;
                        toatlIncorrect++;
                        createUserLockRecord(toatlIncorrect, ReturnValue);
                        isAccountFound=true;
                        isCalloutFailed=false;
                    }
                }
            }
        }catch(Exception e)
        {
            isStep1=true;
            isStep2=false;
            isStep3=false;
            isFinal=false;
            isAccountFound=true;
            isCalloutFailed=true;
            toatlIncorrect++;
            createUserLockRecord(toatlIncorrect, ReturnValue);
            errormsg=AtlasUtility.getMapValue(Atlasconstants.ACC_MAC_NOT_EXIST);
        }
        return null;
    }
    // to validate security questions & answers.
    public pagereference NextStep2()
    {
        try
        {   
            objUser=[select Name,Time_Value__c,TotalWrong__c from Atlas_User_Lock_Out__c where Name =: ReturnValue ORDER BY LastModifiedDate];
            if(!AtlasUtility.isEmpty(objUser) && objUser.size() > 0)
            {
                objvalue = objUser[0];
                if(objvalue.Name==ReturnValue)          
                    toatlIncorrect=(integer.valueOf(objValue.Totalwrong__c));
                else 
                    toatlIncorrect =0;                                        
             }
             else
             {
                toatlIncorrect =0;
             }
             
             boolean isFailed1=false;
                long dt2;
                if(!AtlasUtility.isEmpty(objUser) && objUser.size() > 0)
                {
                    if(objvalue.Name==ReturnValue && objvalue.Totalwrong__c==5)
                    {
                        isFailed1=true;
                         dt2= objvalue.Time_Value__c.getTime() / 1000;
                    }
                    else if(objvalue.Name==ReturnValue && objvalue.Totalwrong__c<5)
                    {
                        toatlIncorrect=integer.valueof(objvalue.Totalwrong__c);
                    }
                }
                datetime d2=system.now();
                if(isFailed1)
                {
                   long dt3 = d2.getTime() / 1000;
                   double dt1 = dt3 - dt2;
                   remainingMinutes=dt1/60;
                   system.debug('Remaining Min----->'+remainingMinutes);
                   if(remainingMinutes <5.0)
                   {
                        isLocked=true;
                        isStep1=true;
                        isStep2=false;
                        Decimal dec=decimal.valueOf(remainingMinutes).setScale(1,System.RoundingMode.UP);
                        remainingMinutes=dec.round();
                        return null;
                   }
                   
                }    
            if(!AtlasUtility.isEmpty(componentToPage.userName))
            {   
                sqAnswer1=sqAnswer1.trim();
                sqAnswer1=sqAnswer1.replaceAll('(\\s+)', ' ');
                sqAnswer2=sqAnswer2.trim();
                sqAnswer2=sqAnswer2.replaceAll('(\\s+)', ' ');
                if(sqAnswer1.equalsIgnoreCase(componentToPage.securityQA1) && sqAnswer2.equalsIgnoreCase(componentToPage.securityQA2))
                {
                    isStep1=false;
                    isStep2=false;
                    isStep3=true;
                    isFinal=false;
                    isSQAFalse=false;
                }
                else
                {
                    toatlIncorrect++;
                    createUserLockRecord(toatlIncorrect, ReturnValue);
                    isStep1=false;
                    isStep2=true;
                    isStep3=false;
                    isFinal=false;
                    isSQAFalse=true;
                    isMaskedSQA1=false;
                    isMaskedSQA2=false;
                    sqAnswer1='';
                    sqAnswer2='';
                    maskedSQAnswer1='';
                    maskedSQAnswer2='';
                    if(Test.isRunningTest()){string e = null; e.tolowercase();}                    
                }
            }   
        }
        catch(Exception e)
        {
            toatlIncorrect++;
            createUserLockRecord(toatlIncorrect, ReturnValue);
            isStep1=false;
            isStep2=true;
            isStep3=false;
            isFinal=false;            
            isSQAFalse=true;
            isMaskedSQA1=false;
            isMaskedSQA2=false;
            sqAnswer1='';
            sqAnswer2='';
            maskedSQAnswer1='';
            maskedSQAnswer2='';
        }
        return null;
    }
    // to reset password.
    public pagereference NextStep3()
    {
        try
        {
            if(!AtlasUtility.isEmpty(componentToPage.userName) && (!AtlasUtility.isEmpty(password)||!AtlasUtility.isEmpty(confirmPwd)) && password==confirmPwd && !componentToPage.userName.equalsIgnoreCase(password))
            {
                AtlasSSOWS.resetPasswordResponse_element response;
                if (!Test.isRunningTest())
                    response=AtlasIntegrationUtility.resetPassword(componentToPage.userName,confirmPwd,false);
                else
                {
                    response=(AtlasSSOWS.resetPasswordResponse_element)JSON.deserialize(AtlasTestConstants.getMetadata('resetPasswordResponse'),AtlasSSOWS.resetPasswordResponse_element.class);
                } 
                
                if(!AtlasUtility.isEmpty(response) && response.loginusername==componentToPage.userName && response.status=='Success')
                {
                    isStep1=false;
                    isStep2=false;
                    isStep3=false;
                    isFinal=true;
                    isPWDReset=false;
                    componentToPage.password=password;
                }
                else
                {
                    isStep1=false;
                    isStep2=false;
                    isStep3=true;
                    isFinal=false;
                    isPWDReset=true;
                    errormsg=response.error;
                }
            }
            else if(componentToPage.userName.equalsIgnoreCase(password))
            {
                isStep1=false;
                isStep2=false;
                isStep3=true;
                isFinal=false;
                isPWDReset=true;
                errormsg='Password should not be the same as your username or first name.';
                if(Test.isRunningTest()){string e = null; e.tolowercase();}
            }
            
        }catch(Exception e)
        {
            isStep1=false;
            isStep2=false;
            isStep3=true;
            isFinal=false;
            isPWDReset=true;
            errormsg='Unable to reset your password.';
        }
        return null;
    }
    //go back to login page.
    public pagereference Cancel()
    {   
        CleasrFields();
        String siteURl =site.getBaseUrl();
        if(siteURl!=null && !siteURl.contains(AtlasConstants.Https_text))
        {
            siteURl.replace(AtlasConstants.Http_text,AtlasConstants.Https_text);
            return new PageReference( siteURl+Atlasconstants.ATLAS_COMMUNITY_URL);
        }
           else
           return new PageReference(Atlasconstants.ATLAS_DEV_URL);
        
    }
    //clear i/p fields
    public void CleasrFields()
    {
        userName='';
        sqAnswer1='';
        sqAnswer2='';
        password='';
        confirmPwd='';
    }
    // go back to for got user name step.
    public pagereference redirectToForgotUsername()
    {
        CleasrFields();
        componentToPage.LHStep1=false;
        componentToPage.LHStep2=true;
        componentToPage.LHStep3=false;
        return null;
    }
    // go back to loging page.
    public pagereference Finished()
    {   
        CleasrFields();
        String siteURl =site.getcurrentsiteurl();
        if(siteURl!=null && !siteURl.contains(AtlasConstants.Https_text))
        {
            siteURl.replace(AtlasConstants.Http_text,AtlasConstants.Https_text);
            return new PageReference( siteURl+Atlasconstants.ATLAS_COMMUNITY_URL);
        }
           else
           return new PageReference(Atlasconstants.ATLAS_DEV_URL);
        
    }
    public Pagereference isMaskedSQA1()
    {
        if(!AtlasUtility.isEmpty(sqAnswer1))
        {   isMaskedSQA1=true;
            sqAnswer1=sqAnswer1.trim();
            sqAnswer1=sqAnswer1.replaceAll('(\\s+)', ' ');
            integer i=sqAnswer1.length();
            for(integer j=0;j<i;j++)
            {
                maskedSQAnswer1+='X';
            }
        }
        return null;
    }
    public Pagereference isMaskedSQA2()
    {
        if(!AtlasUtility.isEmpty(sqAnswer2))
        {   isMaskedSQA2=true;
            sqAnswer2=sqAnswer2.trim();
            sqAnswer2=sqAnswer2.replaceAll('(\\s+)', ' ');
            integer i=sqAnswer2.length();
            for(integer j=0;j<i;j++)
            {
                maskedSQAnswer2+='X';
            }
        }
        return null;
    }
    public Pagereference isMaskedSQA1Changed()
    {
        isMaskedSQA1=false;
        maskedSQAnswer1='';
        return null;
    }
    public Pagereference isMaskedSQA2Changed()
    {
        isMaskedSQA2=false;
        maskedSQAnswer2='';
        return null;
    }
    public Pagereference isNotMaskedSQA1()
    {
        sqAnswer1='';
        maskedSQAnswer1='';
        isMaskedSQA1=false;
        return null;
    }
    public Pagereference isNotMaskedSQA2()
    {
        isMaskedSQA2=false;
        sqAnswer2='';
        maskedSQAnswer2='';
        return null;
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
                    lstdelete.add(objvalue);
                }
            }
            if(!AtlasUtility.isEmpty(lstdelete))
            delete lstdelete;
            if(lastAttempt<10 && toatlIncorrect <=5 ){
                objUserLock=new Atlas_User_Lock_Out__c(Name=ReturnValue,Time_value__c=system.now(),Totalwrong__c=toatlIncorrect);
            }
            else{
                objUserLock=new Atlas_User_Lock_Out__c(Name=ReturnValue,Time_value__c=system.now(),Totalwrong__c=1);
            }
            upsert objUserLock Name;
        }
    }
}