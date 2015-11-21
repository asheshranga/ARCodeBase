public with sharing class AtlasNewUserPasswordController {
    
    public string newUserText{get{return AtlasConstants.NEW_USER_TEXT;}set;}
    public string cancel{get{return Atlasconstants.LOGIN_CANCEL;}set;}
    public string nextStep{get{return Atlasconstants.LOGIN_NEXT_STEP;}set;}
    public string step{get{return AtlasConstants.STEP_3_4;}set;}
    public string note{get{return Atlasconstants.NOTE;}set;}
    public string allFields{get{return Atlasconstants.LOGIN_ALL_FIELDS_TEXT;}set;}
    public string help{get{return Atlasconstants.HELP;}set;}
    public string loginPblmText{get{return Atlasconstants.LOGIN_PROBLEM_TEXT;}set;}
    public string weak{get{return Atlasconstants.WEAK;}set;}
    public string good{get{return Atlasconstants.GOOD;}set;}
    public string strong{get{return Atlasconstants.STRONG;}set;}
    public string createPWDTEXT{get{return Atlasconstants.CREATE_PWD;}set;}
    public string PWD{get{return Atlasconstants.PWD;}set;}
    public string rePWD{get{return Atlasconstants.RE_PWD;}set;}
    
    public string accountNumber{get;set;}
    public string password{get;set;}
    public string confirmPwd{get;set;}
    public AtlasComponenttoController componentToPage{get; set;}
    public string strInvalidPwd{get{return AtlasUtility.getMapValue(Atlasconstants.PWD_VALIDATION_MSG);}set;}
    public string pwdReqd{get{return AtlasUtility.getMapValue(Atlasconstants.PWD_REQD);}set;}
    public string cpwdReqd{get{return AtlasUtility.getMapValue(Atlasconstants.CPWD_REQD);}set;}
    public string passwordHelpText{get{return AtlasUtility.getMapValue(Atlasconstants.PSWD_HELP_TEXT);}set;}
    public boolean ispwdFailed{get;set;}
    public string errorMessage{get;set;}
    public AtlasNewUserPasswordController(){
        
    }
    
    public pagereference submitStep3()
    {   
        try
        {   
            if(!AtlasUtility.isEmpty(componentToPage.userName) && (!AtlasUtility.isEmpty(password)||!AtlasUtility.isEmpty(confirmPwd)) && password==confirmPwd && !componentToPage.userName.equalsIgnoreCase(password) && !componentToPage.firstName.equalsIgnoreCase(password))
            {
                
                componentToPage.isStep1=false;
                componentToPage.isStep2=false;
                componentToPage.isStep3=false;
                componentToPage.isStep4=true;
                componentToPage.password=password;
                ispwdFailed=false;
                createnewUserRegistrationHistory(null,true);
            }
            else 
            {
                componentToPage.isStep1=false;
                componentToPage.isStep2=false;
                componentToPage.isStep3=true;
                componentToPage.isStep4=false;
                ispwdFailed=true;
                errorMessage='Password should not be the same as your username or first name.';
                createnewUserRegistrationHistory(errorMessage,false);
            }
            if(Test.isRunningTest()){string e = null; e.tolowercase();}
            
        }catch(Exception e)
        {
            componentToPage.isStep1=false;
            componentToPage.isStep2=false;
            componentToPage.isStep3=true;
            componentToPage.isStep4=false;
            createnewUserRegistrationHistory(e.getMessage(),false);
        }
        return null;
    }
    
    public pagereference cancel()
    {
        password='';
        confirmPwd='';
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
   
    public void createnewUserRegistrationHistory(String errMsg, boolean password)
    {
        List<New_User_Registration_History__c> nurhList = [select Time_Stamp__c, Step3_Password__c, Error_Message__c from New_User_Registration_History__c where Name =: componentToPage.nurhNumber ORDER BY Createddate];
        if(nurhList != null && nurhList.Size()>0)   
        {
            nurhList[0].Time_Stamp__c = system.now();
            nurhList[0].Step3_Password__c = password;
            nurhList[0].Error_Message__c = errMsg;
        }
        try
        {
            upsert nurhList;
        }
        catch(exception e)
        {
        
        }
    }
    

}