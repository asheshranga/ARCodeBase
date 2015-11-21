public class WispCustomerInfoQuestionsController extends AtlasDataManager{
    
    public string securityQuestions{get{return Atlasconstants.SECURITY_QUESTIONS;}set;}
    public string editSecurityQuestions{get{return Atlasconstants.EDIT_SECURITY_QUESTIONS;}set;}
    public string SQmessge1{get{return AtlasUtility.getMapWispValue(Atlasconstants.WISP_SQ1_VALID_FAILED);}set;}
    public string SQmessge2{get{return AtlasUtility.getMapWispValue(Atlasconstants.WISP_SQ2_VALID_FAILED);}set;}  
    public string selectedSQA1{get;set;}
    public string selectedSQA2{get;set;}
    public boolean isVisibleExceptionMessage{get;set;}
    public boolean isVisibleSuccessAlert{get;set;}
    public string exceptionString{get;set;}
    public boolean isError{get;set;}
    public boolean isError1{get;set;}
    public boolean isError2{get;set;}
    public boolean isPageEroor{get;set;}
    public String exceptionDivStyle{get;set;}
    public boolean isMaskedSQA1{get;set;}
    public boolean isMaskedSQA2{get;set;}
    public string loginPblmText{get{return Atlasconstants.LOGIN_PROBLEM_TEXT;}set;}
    public string firstQ{get{return Atlasconstants.FIRST_Q;}set;}
    public string firstQA{get{return Atlasconstants.FIRST_QA;}set;}
    public string secondQ{get{return Atlasconstants.SECOND_Q;}set;}
    public string secondQA{get{return Atlasconstants.SECOND_QA;}set;}
    public string quesHelpText {get{return AtlasUtility.getMapWispValue(Atlasconstants.WISP_QUES_HELP_TEXT);}set;}
    public string firstAnswerReqd{get{return AtlasUtility.getMapWispValue(Atlasconstants.WISP_FIRST_ANSWER);}set;}
    public string secondAnswerReqd{get{return AtlasUtility.getMapWispValue(Atlasconstants.WISP_SECOND_ANSWER);}set;}
    public string sqAnswerHelpText{get{return AtlasUtility.getMapWispValue(Atlasconstants.WISP_ANS_NEWUSR_HLP_TEXT);}set;}
    public string sqHelpText{get{return AtlasUtility.getMapWispValue(Atlasconstants.WISP_QUES_NEWUSR_HLP_TEXT);}set;}
    public string profileId {get;set;}
    
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
    public string sqa;
    public string maskedSQAnswer1{get;set;}
    public string maskedSQAnswer2{get;set;}
    Public WispCustomerInfoQuestionsController(){
    	//populateWispDashboardData();
		//system.debug('---------'+mainDTOObj);
    }
    
    /**
    * @author Srikanth Kudumula
    * @description - cancelException for WispCustomerInformationQuestionsController
    * @input param  - null
    * @return param null
    */     
    public PageReference cancelException()
    {
        isVisibleExceptionMessage = false;
        isVisibleSuccessAlert=false;
        
        string url = '/apex/subscriber_dashboard?firstTime=false&Id=' + profileId; 
		string siteURl =site.getBaseUrl();
		if(!AtlasUtility.IsEmpty(siteURl)) {              
			PageReference page = new PageReference(siteURl+'/subscriber_dashboard');
			page.setRedirect(true);
			return page;
		}
		else {
			PageReference page1 = new PageReference(url);
			page1.setRedirect(true);
			return page1;    
		}
    }
    
     /**
    * @author Srikanth Kudumula
    * @description - saveCustomerInformation for WispCustomerInfoQuestionsController
    * @input param  - null
    * @return param null
    */         
      public PageReference saveSecurityQuestions()
    {   
        populateWispDashboardData();
		system.debug('---------'+mainDTOObj);
        sqAnswer1=sqAnswer1.trim();
        sqAnswer2=sqAnswer2.trim();
        try{
            if(AtlasUtility.isEmpty(sqAnswer1) || AtlasUtility.isEmpty(sqAnswer2)){
                isVisibleExceptionMessage = true;
                isVisibleSuccessAlert = false;
                exceptionString = 'Please fill up required fields.';
                return null;
            }                
            if(sqAnswer1.length()<3 || sqAnswer1.length()>64)
            {
                isVisibleExceptionMessage = true;
                isError1=true;
                isPageEroor=false;
                isVisibleSuccessAlert = false;
                exceptionString = AtlasUtility.getMapValue(Atlasconstants.SQ1_VALID_FAILED);
                return null;
            }               
            else if(sqAnswer2.length()<3 || sqAnswer2.length()>64)
            {
                isVisibleExceptionMessage = true;
                isVisibleSuccessAlert = false;
                isError2=true;
                isPageEroor=false;
                exceptionString = AtlasUtility.getMapValue(Atlasconstants.SQ2_VALID_FAILED);
                return null;
            }
            AtlasSSOWS.securityQuestionType newQuestion1 = new AtlasSSOWS.securityQuestionType();              
            List<AtlasSSOWS.securityQuestionType> newQuestions = new List<AtlasSSOWS.securityQuestionType>();                
            newQuestion1.securityquestionquestion = selectedSQA1;
            newQuestion1.securityquestionanswer = (sqAnswer1 != null && sqAnswer1 != '' ? sqAnswer1 : maskedSQAnswer1);
            newQuestions.add(newQuestion1);              
            AtlasSSOWS.securityQuestionType newQuestion2 = new AtlasSSOWS.securityQuestionType();
            newQuestion2.securityquestionquestion = selectedSQA2;
            newQuestion2.securityquestionanswer = (sqAnswer2 != null && sqAnswer2 != '' ? sqAnswer2 : maskedSQAnswer2);
            newQuestions.add(newQuestion2);
                           
            //Add the security question array to the questionsType variable
            AtlasSSOWS.securityQuestionsType lstQSType= new AtlasSSOWS.securityQuestionsType();
            lstQSType.securityquestion=newQuestions; 
                               
            //Call the service      
            AtlasSSOWS.saveSecurityQuestionsResponse_element resp1;
            System.debug('calling AtlasIntegrationUtility.saveSecurityQuestions');
            resp1 = AtlasIntegrationUtility.saveSecurityQuestions(mainDTOObj.federationId,lstQSType);               
            isPageEroor=true;            
            if(mainDTOObj.federationId == resp1.loginusername){
                isVisibleSuccessAlert=true;
                isVisibleExceptionMessage = false;
                exceptionString='';
            }else{
                isVisibleExceptionMessage = true;
                isVisibleSuccessAlert=false;
                exceptionString = 'Authentication Failed';
                exceptionDivStyle=''; 
                return null;
            }              
        }catch(AtlasException e)
        {
            system.debug('saveCustomerInfo catch: ' + e.errorMessage);
            isVisibleExceptionMessage=true;
            isVisibleSuccessAlert=false;
            exceptionString= e.errorMessage ;
            exceptionDivStyle=''; 
            return null;                  
        }
        finally{
            if(!AtlasUtility.isEmpty(exceptionString) && exceptionString.contains('Security Question 1'))
            {
                sqAnswer1='';
                maskedSQAnswer1='';
                isPageEroor=false;
                isMaskedSQA1=false;
                isVisibleExceptionMessage = true;
            }
            else if(!AtlasUtility.isEmpty(exceptionString) && exceptionString.contains('Security Question 2'))
            {
                sqAnswer2='';
                maskedSQAnswer2='';
                isMaskedSQA2=false;
                isPageEroor=false;
                isVisibleExceptionMessage = true;
            }
            else if(!AtlasUtility.isEmpty(exceptionString))
            {
                sqAnswer1='';
                maskedSQAnswer1='';
                isPageEroor=false;
                isMaskedSQA1=false;
                isMaskedSQA2=false;
                sqAnswer2='';
                maskedSQAnswer2='';
                isVisibleExceptionMessage = true;
            }
            else
            {
                sqAnswer1='';
                maskedSQAnswer1='';
                isMaskedSQA1=false;
                isMaskedSQA2=false;
                sqAnswer2='';
                maskedSQAnswer2='';
                isVisibleExceptionMessage = false;
            }                                
        }
        PageReference page = new PageReference('/'+atlasconstants.STRCUSTOMER_INFO);
        page.setRedirect(false);
        return  null;                
    }
    
    public Pagereference isNotMaskedSQA1()
        {
            sqAnswer1='';
            maskedSQAnswer1='';
            isPageEroor=false;
            isMaskedSQA1=false;
            isError1=false;
            isError2=false;  
            exceptionString='';
            isVisibleExceptionMessage = false;   
            return null;
        }
        
        public Pagereference isNotMaskedSQA2()
        {
            isMaskedSQA2=false;
            sqAnswer2='';
            maskedSQAnswer2='';
            isError2=false;
            isPageEroor=false;
            isError1=false;  
            exceptionString='';
            isVisibleExceptionMessage = false;
            return null;
        }
}