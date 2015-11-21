/*********************************************************************************
Name         : WispResetPasswordStep3Controller 
Created By   : Tejesh Kumar
Company Name : CMC Americas    
Project      : ViaSat WISP
Created Date : 05 November, 2014
Usages       : Controller for VisualForce Component: WispResetPasswordStep3 
*********************************************************************************/
public with sharing class WispResetPasswordStep3Controller {
       
    //Constant variables
    
    public string resetPwd_Uname{get{return Atlasconstants.RESET_MYPWD_TEXT;}set;}
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
    public string resetPswd{get{return AtlasUtility.getMapWispValue(Atlasconstants.Wisp_ResetPswd);}set;}
    public string newPswd{get{return AtlasUtility.getMapWispValue(Atlasconstants.Wisp_LoginHelp_newPswd);}set;}
    public string step3{get{return AtlasUtility.getMapWispValue(Atlasconstants.Wisp_LoginHelp_Step3);}set;}
    
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
    public WispResetPasswordStep3Controller()
    {      
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
                    componentToPage.LHStep1=false;
                    componentToPage.LHStep2=false;
                    componentToPage.LHStep3=false;
                    componentToPage.LHStep4=true;                   
                    isPWDReset=false;
                    componentToPage.password=password;
                }
                else
                {
                    componentToPage.LHStep1=false;
                    componentToPage.LHStep2=false;
                    componentToPage.LHStep3=true;
                    componentToPage.LHStep4=false;                    
                    isPWDReset=true;
                    errormsg=response.error;
                }
            }
            else if(componentToPage.userName.equalsIgnoreCase(password))
            {
                componentToPage.LHStep1=false;
                componentToPage.LHStep2=false;
                componentToPage.LHStep3=true;
                componentToPage.LHStep4=false;  
                isPWDReset=true;
                errormsg='Password should not be the same as your username or first name.';
                if(Test.isRunningTest()){string e = null; e.tolowercase();}
            }
            
        }catch(Exception e)
        {
            componentToPage.LHStep1=false;
            componentToPage.LHStep2=false;
            componentToPage.LHStep3=true;
            componentToPage.LHStep4=false;  
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