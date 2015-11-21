/*********************************************************************************
Name         : AtlasNewUserQuestionsController
Created By   : Shiva Shankar Nalluri
Modified BY  : Shiva Shankar Nalluri
Company Name : NTT Data
Project      : ViaSat Atlas, Bangalore
Created Date : 
Modified Date: 
Usages       : Controller for VisualForce Page: AtlasNewUserQuestions
*********************************************************************************/
public with sharing class AtlasNewUserQuestionsController {
    
    public string newUserText{get{return AtlasConstants.NEW_USER_TEXT;}set;}
    public string cancel{get{return Atlasconstants.LOGIN_CANCEL;}set;}
    public string nextStep{get{return Atlasconstants.LOGIN_NEXT_STEP;}set;}
    public string loginPblmText{get{return Atlasconstants.LOGIN_PROBLEM_TEXT;}set;}
    public string firstQ{get{return Atlasconstants.FIRST_Q;}set;}
    public string firstQA{get{return Atlasconstants.FIRST_QA;}set;}
    public string secondQ{get{return Atlasconstants.SECOND_Q;}set;}
    public string secondQA{get{return Atlasconstants.SECOND_QA;}set;}
    public string help{get{return Atlasconstants.HELP;}set;}
    public string step{get{return AtlasConstants.STEP_4_4;}set;}
    public string note{get{return Atlasconstants.NOTE;}set;}
    public string allFields{get{return Atlasconstants.LOGIN_ALL_FIELDS_TEXT;}set;}
    public string securityQuestions{get{return Atlasconstants.SECURITY_QUESTIONS;}set;}
    public string sqHelp{get{return AtlasUtility.getMapValue(Atlasconstants.NEW_USER_SQ_HELP);}set;}
    public string selectedSQA1{get;set;}
    public string selectedSQA2{get;set;}
    public string sqHelpText{get{return AtlasUtility.getMapValue(Atlasconstants.QUES_NEWUSR_HLP_TEXT);}set;}
    public string sqAnswerHelpText{get{return AtlasUtility.getMapValue(Atlasconstants.ANS_NEWUSR_HLP_TEXT);}set;}
    public string SQmessge1{get{return AtlasUtility.getMapValue(Atlasconstants.SQ1_VALID_FAILED);}set;}
    public string SQmessge2{get{return AtlasUtility.getMapValue(Atlasconstants.SQ2_VALID_FAILED);}set;}  
    
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
    
    public string sqAnswer1{get;set;}
    public string sqAnswer2{get;set;}
    //masked data
    public string maskedSQAnswer1{get;set;}
    public string maskedSQAnswer2{get;set;}
    public AtlasComponenttoController componentToPage{get; set;}
    public boolean isMaskedSQA1{get;set;}
    public boolean isMaskedSQA2{get;set;}
    public string firstAnswerReqd{get{return AtlasUtility.getMapValue(Atlasconstants.FIRST_ANSWER);}set;}
    public string secondAnswerReqd{get{return AtlasUtility.getMapValue(Atlasconstants.SECOND_ANSWER);}set;}
    public string errormessage{get;set;}
    public boolean isError{get;set;}
    public boolean isError1{get;set;}
    public boolean isError2{get;set;}
    public boolean isPageEroor{get;set;}
    /**
    * @author Shiva Shankar
    * @description - Constructor for AtlasNewUserQuestionsController
    * @input param  - null
    * @return null
    */ 
    public AtlasNewUserQuestionsController()
    {
        isMaskedSQA1=false;
        isMaskedSQA2=false;
        maskedSQAnswer1='';
        maskedSQAnswer2='';
        isPageEroor=true;
        List<AtlasSecurityQuestionsList__c> SQList=AtlasSecurityQuestionsList__c.getall().values();
        if(SQList != null && SQList.size()>0)
            selectedSQA1=SQList[0].Value__c;
        List<AtlasSecurityQuestionsList1__c> SQList1=AtlasSecurityQuestionsList1__c.getall().values();
        if(SQList1 != null && SQList1.size()>0)
            selectedSQA2=SQList1[0].Value__c;
        
        
    }
    public pagereference submitStep4()
    {   
        
        sqAnswer1=sqAnswer1.trim();
        sqAnswer1=sqAnswer1.replaceAll('(\\s+)', ' ');
        sqAnswer2=sqAnswer2.trim();
        sqAnswer2=sqAnswer2.replaceAll('(\\s+)', ' ');
        if(sqAnswer1.length()<3 || sqAnswer1.length()>64)
        {
            componentToPage.isStep1=false;
            componentToPage.isStep2=false;
            componentToPage.isStep3=false;
            componentToPage.isStep4=true;
            componentToPage.isStep5=false;
            errormessage=AtlasUtility.getMapValue(Atlasconstants.SQ1_VALID_FAILED);
            sqAnswer1='';
            isError=true;
            isError1=true;
            isPageEroor=false;
            maskedSQAnswer1='';
            isMaskedSQA1=false;
            createnewUserRegistrationHistroy(errormessage,false);
            return null;
        }
        else if(sqAnswer2.length()<3 || sqAnswer2.length()>64)
        {
            componentToPage.isStep1=false;
            componentToPage.isStep2=false;
            componentToPage.isStep3=false;
            componentToPage.isStep4=true;
            componentToPage.isStep5=false;
            isError=true;
            isPageEroor=false;
            isError2=true;
            isMaskedSQA2=false;
            sqAnswer2='';
            maskedSQAnswer2='';
            errormessage=AtlasUtility.getMapValue(Atlasconstants.SQ2_VALID_FAILED);
            createnewUserRegistrationHistroy(errormessage,false);
            return null;
        }
        else
        {
            componentToPage.isStep1=false;
            componentToPage.isStep2=false;
            componentToPage.isStep3=false;
            componentToPage.isStep4=false;
            componentToPage.isStep5=true;
            isError=false;
            isError1=false;
            isError2=false;
            isPageEroor=true;
            componentToPage.securityQ1 = selectedSQA1;
            componentToPage.securityQ2 = selectedSQA2;
            componentToPage.securityQA1 = sqAnswer1;
            componentToPage.securityQA2 =sqAnswer2;
            createnewUserRegistrationHistroy(null,true);
            system.debug('shiva___'+selectedSQA1+'>>>'+selectedSQA2+'<<<<<'+sqAnswer1+'>>>>>>>'+sqAnswer2);
        }
        return null;
        
    }
    public Pagereference isMaskedSQA1()
    {
        if(!AtlasUtility.isEmpty(sqAnswer1))
        {
            sqAnswer1=sqAnswer1.trim();
            isError=false;
            isError1=false;
            sqAnswer1=sqAnswer1.replaceAll('(\\s+)', ' ');
            integer i=sqAnswer1.length();
            for(integer j=0;j<i;j++)
                maskedSQAnswer1+='X';
            isMaskedSQA1=true;
        }
        return null;
    }
    public Pagereference isMaskedSQA2()
    {
        if(!AtlasUtility.isEmpty(sqAnswer2))
        {
            sqAnswer2=sqAnswer2.trim();
            isError=false;
            isError2=false;
            sqAnswer2=sqAnswer2.replaceAll('(\\s+)', ' ');
            integer i=sqAnswer2.length();
            for(integer j=0;j<i;j++)
                maskedSQAnswer2+='X';
            isMaskedSQA2=true;
        }
        return null;
    }
    public Pagereference isNotMaskedSQA1()
    {
        sqAnswer1='';
        isError=false;
        isError1=false;
        isError2=false;
        isPageEroor=false;
        maskedSQAnswer1='';
        isMaskedSQA1=false;
        isError=false;  
        return null;
    }
    public Pagereference isNotMaskedSQA2()
    {
        isMaskedSQA2=false;
        sqAnswer2='';
        isError=false;
        isError1=false;
        isPageEroor=false;
        isError2=false;
        maskedSQAnswer2='';
        isError=false;
        return null;
    }
    public Pagereference isMaskedSQA1Changed()
    {   
        
        isMaskedSQA1=false;
        maskedSQAnswer1='';
        isPageEroor=false;
        isError=false;
        isError1=false;
        isError2=false;     
        return null;
    }
    public Pagereference isMaskedSQA2Changed()
    {
        isMaskedSQA2=false;
        maskedSQAnswer2='';
        isError=false;
        isPageEroor=false;
        isError1=false;
        isError2=false;
        return null;
    }
    public pagereference cancel()
    {
        sqAnswer1='';
        sqAnswer2='';
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
  
    public void createnewUserRegistrationHistroy(String errMsg, boolean secquestions)
    {
        List<New_User_Registration_History__c> nurhList = [select Time_Stamp__c, Step4_Security_Questions__c, Error_Message__c from New_User_Registration_History__c where Name =: componentToPage.nurhNumber ORDER BY Createddate];
        if(nurhList != null && nurhList.size()>0)
        {   
            nurhList[0].Time_Stamp__c = system.now();
            nurhList[0].Step4_Security_Questions__c = secquestions;
            nurhList[0].Error_Message_Step4__c= errMsg;
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