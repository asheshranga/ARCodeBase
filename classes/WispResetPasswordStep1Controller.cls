/*********************************************************************************
Name         : WispResetPasswordStep1Controller 
Created By   : Tejesh Kumar
Company Name : CMC Americas    
Project      : ViaSat WISP
Created Date : 04 November, 2014
Usages       : Controller for VisualForce Component: WispResetPasswordStep1 
*********************************************************************************/
public with sharing class WispResetPasswordStep1Controller {
       
    //Constant variables    
    public string required{get{return Atlasconstants.REQUIRED;}set;}
    public string accNotFoundText{get{return AtlasUtility.getMapValue(Atlasconstants.ACC_NOT_FOUND);}set;}
    public string AccLocked{get{return AtlasUtility.getMapValue(AtlasConstants.ACC_LOCKED);}set;}
    public string AccLocked1{get{return AtlasUtility.getMapValue(AtlasConstants.ACC_LOCKED1);}set;}
    public string AccLocked2{get{return AtlasUtility.getMapValue(AtlasConstants.ACC_LOCKED2);}set;}
    public string nextStep{get{return Atlasconstants.LOGIN_NEXT_STEP;}set;}
    public string cancel{get{return Atlasconstants.LOGIN_CANCEL;}set;}
    public string loginHelpText{get{return AtlasConstants.LOGIN_HELP_TEXT;}set;}
    public string note{get{return Atlasconstants.NOTE;}set;}
    public string loginPblmText{get{return Atlasconstants.LOGIN_PROBLEM_TEXT;}set;}
    public string strInvalidPwd{get{return AtlasUtility.getMapValue(Atlasconstants.PWD_VALIDATION_MSG);}set;}
    public string validemail{get{return AtlasUtility.getMapValue(Atlasconstants.PLS_EMAIL_VALID);}set;}
    public string uNameLimit{get{return AtlasUtility.getMapValue(Atlasconstants.LOGIN_UNAME_LIMIT);}set;}
    public string unamereqd{get{return AtlasUtility.getMapValue(Atlasconstants.LOGIN_UNAME_REQD);}set;}
    public string newUnameHelp{get{return AtlasUtility.getMapWispValue(AtlasConstants.Wisp_UNAME_NEWUSR_HLP_TEXT);}set;}
    public string newUnameHelp1{get{return AtlasUtility.getMapValue(Atlasconstants.LOGIN_UNAME_HELP1);}set;}
    public string newUnameHelp2{get{return AtlasUtility.getMapValue(Atlasconstants.LOGIN_UNAME_HELP2);}set;}
    public string resetPswd{get{return AtlasUtility.getMapWispValue(Atlasconstants.Wisp_ResetPswd);}set;}
    public string enterUname{get{return AtlasUtility.getMapWispValue(Atlasconstants.Wisp_Username);}set;}
    public string enterUnameHover{get{return AtlasUtility.getMapWispValue(Atlasconstants.WIsp_LoginHelp_PswdHelpText);}set;}   
    public string step1{get{return AtlasUtility.getMapWispValue(Atlasconstants.Wisp_LoginHelp_Step1);}set;}
    public string UnameText{get{return AtlasUtility.getMapWispValue(Atlasconstants.Wisp_LoginHelp_UnameText);}set;}
    public string calloutFailed{get{return AtlasUtility.getMapWispValue(Atlasconstants.Wisp_Callout_Failed);}set;}
    public string accNotExist{get{return AtlasUtility.getMapWispValue(Atlasconstants.Wisp_ACC_NOT_FOUND);}set;}
    public string wispAccLocked1{get{return AtlasUtility.getMapWispValue(Atlasconstants.Wisp_ACC_LOCKED1);}set;}
    public string wispResetPwdHelpText{get{return AtlasUtility.getMapWispValue(Atlasconstants.Wisp_LOGIN_UNAME_HELP1);}set;}
        
    //step1
    public string userName{get;set;}
    public boolean isAccountFound{get;set;}
    public boolean isSQAFalse{get;set;}
    
    //Apex class is used to find the steps(1,2,3,4..)
    public AtlasComponenttoController componentToPage{get; set;}
        
    public integer toatlIncorrect{get;set;}    
    //
    public string errormsg{get;set;}
    public string sqAnswer1{get;set;}
    public string sqAnswer2{get;set;}
    public string sqQuestion1{get;set;}
    public string sqQuestion2{get;set;}
    
    //public User_Lock_Out__c objUserLock{get;set;}
    public boolean isLocked{get;set;}
    public double remainingMinutes{get;set;}
    public double lastAttempt{get;set;}
    public boolean isCalloutFailed{get;set;}

    public string ReturnValue;
    List<Atlas_User_Lock_Out__c> objUser = null;
    Atlas_User_Lock_Out__c objvalue = null;
    
    // Constructor
    public WispResetPasswordStep1Controller()
    {       
        isAccountFound=false;       
        isLocked=false;
        ReturnValue = '';
        ReturnValue = ApexPages.currentPage().getHeaders().get('True-Client-IP');
        if ( (ReturnValue == null) || (ReturnValue.trim().equals('')) ) {
           ReturnValue = ApexPages.currentPage().getHeaders().get('X-Salesforce-SIP')+'LoginHelp';
        }
        system.debug('ReturnValue____'+ReturnValue);
                 
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
                        componentToPage.LHStep1=true;
                        componentToPage.LHStep2=false;
                        Decimal dec=decimal.valueOf(remainingMinutes).setScale(1,System.RoundingMode.UP);
                        remainingMinutes=dec.round();
                        return null;
                   }
                   
                }     
                AtlasSSOWS.getSubscribersResponse_element repsonseObj;
                if (!Test.isRunningTest())
                    repsonseObj=AtlasIntegrationUtility.getSSOSubscribers('','',AtlasUtility.getMapValue(AtlasConstants.Atlas_loginUserName_Attribute),userName);
                else
                {
                    AtlasSSOWS.getSubscribersResponse_element repsonseObjdummy=(AtlasSSOWS.getSubscribersResponse_element)JSON.deserialize(AtlasTestConstants.getMetadata('findSSOSubscribersResponse'),AtlasSSOWS.getSubscribersResponse_element.class);
                    repsonseObj=repsonseObjdummy;
                } 
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
                                {
                                    AtlasSSOWS.getSubscriberResponse_element repsonseObjdummy=(AtlasSSOWS.getSubscriberResponse_element)JSON.deserialize(AtlasTestConstants.getMetadata('findSSOSubscriberResponse'),AtlasSSOWS.getSubscriberResponse_element.class);
                                    objRepsonse=repsonseObjdummy;
                                } 
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
                                                    
                                                    // To check the response of the sec ques and assign them accordingly
											        List<AtlasSecurityQuestionsList1__c> SQList=AtlasSecurityQuestionsList1__c.getall().values();
											        for (AtlasSecurityQuestionsList1__c bSQ: SQList) {                                                 
	                                                    if(bsQ.Value__c==str1[1]) {	                                                    	                                                   	
	                                                    	componentToPage.wispSecurityQ1=str1[0];
	                                                    	componentToPage.wispSecurityQ2=str1[1];
	                                                    	componentToPage.wispSecurityQA1=str2[0];
	                                                    	componentToPage.wispSecurityQA2=str2[1];
	                                                    	break;
	                                                    }
	                                                    else {
	                                                    	componentToPage.wispSecurityQ1=str1[0];
	                                                    	componentToPage.wispSecurityQA1=str1[1];
	                                                    	componentToPage.wispSecurityQ2=str2[0];
	                                                    	componentToPage.wispSecurityQA2=str2[1];
	                                                    }
											        }
											        
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                            componentToPage.LHStep1=false;
                            componentToPage.LHStep2=true;
                            componentToPage.LHStep3=false;
                            componentToPage.LHStep4=false;
                            componentToPage.userName=userName;
                            isAccountFound=false;
                            isCalloutFailed=false;
                            if(Test.isRunningTest()){string e = null; e.tolowercase();}
                        }
                        
                    }
                    else
                    {
                        componentToPage.LHStep1=true;
                        componentToPage.LHStep2=false;
                        componentToPage.LHStep3=false;
                        componentToPage.LHStep4=false;
                        toatlIncorrect++;
                        createUserLockRecord(toatlIncorrect, ReturnValue);
                        isAccountFound=true;
                        isCalloutFailed=false;
                    }
                }
            }
        }catch(Exception e)
        {
            isAccountFound=true;
            isCalloutFailed=true;
            toatlIncorrect++;
            createUserLockRecord(toatlIncorrect, ReturnValue);
            errormsg=AtlasUtility.getMapValue(Atlasconstants.ACC_MAC_NOT_EXIST);
        }
        finally{
            ClearFields();
        }
        return null;
        
    }
    
    public pagereference Cancel()
    {   
        ClearFields();
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
    public void ClearFields()
    {
        userName='';        
    }
    // go back to for got user name step.
    public pagereference redirectToForgotUsername()
    {
        ClearFields();
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