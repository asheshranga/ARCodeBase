/*********************************************************************************
Name         : WispNewUserQuestionsController
Created By   : Srikanth Kudumula
Modified BY  : Srikanth kudumula
Company Name : NTT Data
Project      : ViaSat Wisp, Carlsbad
Created Date : 
Modified Date: 
Usages       : Controller for VisualForce Page: WispNewUserQuestions
*********************************************************************************/
public with sharing class WispNewUserQuestionsController {
    
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
    public string ATLAS_LOGIN{get{ return AtlasUtility.getURL(AtlasConstants.ATLAS_LOGIN);}set;}
    public string stripCharacters{get{return AtlasUtility.getMapValue(AtlasConstants.Disallowed_New_User_Special_Characters);}set;} 
    public string emailExceptionErrorMsg {get{ return AtlasUtility.getMapValue(AtlasConstants.Atlas_User_Creation_Exception); } set;}
    public string emailDomain{get{return AtlasUtility.getMapWispValue(AtlasConstants.Wisp_New_User_Email_Domain);}set;} 	
	public string WispHeaderText{get{return AtlasUtility.getMapWispValue(AtlasConstants.Wisp_Header_Text);}set;}
	public string exceptionPageTitle{get{return AtlasUtility.getMapWispValue(AtlasConstants.Wisp_Exception_Page_Title);}set;}
	public string registrationSuccessMsg{get{return AtlasUtility.getMapWispValue(AtlasConstants.Wisp_Registration_Success_Msg);}set;}
	public string registrationFailureMsg{get{return AtlasUtility.getMapWispValue(AtlasConstants.Wisp_Registration_Failure_Msg);}set;}
	public string WispAccRecordtype{get{return AtlasUtility.getMapWispValue(AtlasConstants.Wisp_Account_Recordtype);}set;} 
	public string Wisp_LOGIN{get{ return AtlasUtility.getWispURL(AtlasConstants.Wisp_LOGIN);}set;}
    PageReference pageRef = Page.subscriber_new_user_exception;
    boolean isUpdateSubscriberException = false;
    boolean isSaveSecurityQuestionsException = false;
    boolean isUpdateCustomerInfoException = false;
    boolean isCalloutException = false;
    AtlasSSOWS.securityQuestionType qsType1= new AtlasSSOWS.securityQuestionType();
    AtlasSSOWS.securityQuestionType qsType2= new AtlasSSOWS.securityQuestionType();
    List<AtlasSSOWS.securityQuestionType> lstQuestionAnswer= new list<AtlasSSOWS.securityQuestionType>();
    AtlasSSOWS.securityQuestionsType lstQSType= new AtlasSSOWS.securityQuestionsType();
    
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
    public WispNewUserQuestionsController()
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
            createnewUserRegistrationHistroy(errormessage,false,false,'');
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
            createnewUserRegistrationHistroy(errormessage,false,false,'');
            return null;
        }
        else
        {
            //variables for response
            AtlasSSOWS.updateSubscriberResponse_element response;
            AtlasSSOWS.saveSecurityQuestionsResponse_element responseObj;
            string Objresponse;
             
            if(!AtlasUtility.isEmpty(componentToPage.externalAccReference) && !AtlasUtility.isEmpty(componentToPage.externalSystemName)) 
            {
                try
                {
                    //to pass security questions in update subscriber method
                    qsType1.securityquestionquestion=selectedSQA1;
                    qsType1.securityquestionanswer=selectedSQA2;
                    qsType2.securityquestionquestion=sqAnswer1;
                    qsType2.securityquestionanswer=sqAnswer2;
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
                    createnewUserRegistrationHistroy('',true,false,e.getMessage());
                    System.debug('componentToPage.subscriberkey---22>'+e.getMessage()+'>>>>>'+e.getStacktracestring());
                    isCalloutException = true;
                    //PageReference pageRef = Page.WispNewUserException;
                    pageRef.getParameters().put('msg','FAIL');
                    return PageRef;
                }

                Savepoint sp = Database.setSavepoint();
                try
                {
                	List<Account> accList = null;
                	Account parentaccObj=new Account();
                    //callout to make update customerInfo
                    if(!AtlasUtility.isEmpty(response) && response.status == 'Success' && !isUpdateSubscriberException)
                    {
                    	//check if there are any accounts when the partner name is not null
                    	if(!AtlasUtility.isEmpty(componentToPage.partnerName)){
                    		accList = [select Id, Name from Account where Name =: componentToPage.partnerName Limit 1];
                    	}
                    	
                    	//if there are no accounts with the partner name then create a partner account
                    	if(AtlasUtility.isEmpty(accList)){                    		
                    		//parentaccObj.Parent.Name = componentToPage.partnerName;
                    		parentaccObj.Name=componentToPage.partnerName;
	                        parentaccObj.Status__c='Customer';
	                        parentaccObj.Country__c='United States';
	                        parentaccObj.Type='Partner';
	                        parentaccObj.Industry='Commercial';
	                        parentaccObj.CurrencyIsoCode = 'USD';
	                        parentaccObj.OwnerId = AtlasUtility.getMapWispValue(AtlasConstants.Wisp_Account_Owner);
                    		insert parentaccObj;
                    	}
                        // Create salesforce Account, Contact and User records.                       
                        Account accObj=new Account();
                        accObj.Name=componentToPage.accountName;
                        accObj.Status__c='Customer';
                        accObj.Country__c='United States';
                        accObj.Type='End-User';
                        accObj.RecordTypeId=WispAccRecordtype;
                        accObj.Industry='Commercial';
                        accObj.CurrencyIsoCode = 'USD';
                        accObj.OwnerId = AtlasUtility.getMapWispValue(AtlasConstants.Wisp_Account_Owner);
                        if(!AtlasUtility.isEmpty(componentToPage.partnerName)){
                        	if(!AtlasUtility.isEmpty(accList)){
                        		accObj.ParentId = accList[0].Id;
                        	}
                        	else{
                        		accObj.ParentId = parentaccObj.Id;
                        	}
                        }
                        insert accObj;
                        //to insert contact 
                        Contact conObj= new Contact();
                        conObj.LastName=componentToPage.accountName;
                        conObj.AccountId=accObj.id;
                        conObj.ExternalAccountReference__c=componentToPage.externalAccReference;
                        string externalAccRef = componentToPage.externalAccReference.trim();
                        externalAccRef = externalAccRef.replaceAll('(\\s+)', ' ');
                        externalAccRef = externalAccRef.replaceAll('['+stripCharacters+']','');
                        conObj.Email=componentToPage.emailId;
                        conObj.Phone=componentToPage.phone;
                        conObj.Account_Number__c=componentToPage.internalAccReference;
                        conObj.FirstName = componentToPage.firstName;
                        conObj.LastName = componentToPage.lastName;
                        conObj.OwnerId = AtlasUtility.getMapWispValue(AtlasConstants.Wisp_Account_Owner);
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
                        string profileId = atlasutility.getMapWispValue(atlasconstants.WISP_Subscriber_Community);
                        SObject prof = [ select id from profile where Id =: profileId];
                        userObj.ProfileId = (ID) prof.get('ID');
                        userObj.TimeZoneSidKey = 'America/Los_Angeles';
                        userObj.LocaleSidKey = 'en_US';
                        userObj.EmailEncodingKey = 'ISO-8859-1';
                        userObj.LanguageLocaleKey = 'en_US';
                        userObj.UserPermissionsMobileUser = false;
                        userObj.Account_Number__c=componentToPage.internalAccReference;
                        userObj.CommunityUserAccountType__c = 'Wisp';
                        userObj.Functional_Group__c = 'Customer Portal';                        
                        userObj.Assignment_Group_Active__c = false;
                        insert userObj;
                        //
                        String customerName = componentToPage.firstName+' '+componentToPage.lastName;
                        String businessName = componentToPage.businessName;                                                         
                        PageReference pageRef = Page.subscriber_new_user_exception;
                        pageRef.getParameters().put('msg','SUCCESS');
                        if(businessName!=null)
                        	pageRef.getParameters().put('customerName',businessName);
                    	else
                    		pageRef.getParameters().put('customerName',customerName);
                        createnewUserRegistrationHistroy('',true,true,'');
                        return PageRef;
                    }
                    else//redirect to error page...
                    {
                        // if webservice fails.
                        //PageReference pageRef = Page.WispNewUserException;
                        pageRef.getParameters().put('msg','FAIL');
                        //return PageRef;
                    }
                }
                catch(Exception e)
                {
                	system.debug('@@@--Stack Trace--->'+e.getStackTraceString());
                    system.debug('@@@--get message--->'+e.getMessage());
                    system.debug('@@@--get cause--->'+e.getCause());
                    isUpdateSubscriberException = true;
                    isSaveSecurityQuestionsException = true;
                    Database.rollback(sp);
                    //createnewUserRegistrationHistroy('',true,false,e.getMessage());
                    PageReference pageRef = Page.subscriber_new_user_exception;
                    pageRef.getParameters().put('msg','FAIL');
                    return PageRef;
                }   
            }
            else{
                pageRef.getParameters().put('msg','FAIL');
            } 
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
        String siteURl =site.getBaseUrl();
        if(siteURl!=null && !siteURl.contains(AtlasConstants.Https_text))
        {
            siteURl.replace(AtlasConstants.Http_text,AtlasConstants.Https_text);
            return new PageReference( siteURl+Atlasconstants.ATLAS_COMMUNITY_URL);
        }
           else
           return new PageReference(Atlasconstants.ATLAS_DEV_URL);
    }
    
    //Clear Out Username when the callout fails
    public pagereference invokeUpdateSubscriber()
    {
        AtlasSSOWS.updateSubscriberResponse_element response1;
        if(isUpdateSubscriberException)
        {
            try{
                if (!Test.isRunningTest()) 
                    response1 = AtlasIntegrationUtility.updateSubscriber(componentToPage.subscriberkey,null,null,null);
                else
                    response1 =(AtlasSSOWS.updateSubscriberResponse_element)JSON.deserialize(AtlasTestConstants.getMetadata('updateSubscriberResponse'),AtlasSSOWS.updateSubscriberResponse_element.class);
                createnewUserRegistrationHistroy('',true,false,'');    
            }
            catch(Exception e){
                //PageReference pageRef = Page.WispNewUserException;
                pageRef.getParameters().put('msg','FAIL');
                createnewUserRegistrationHistroy('',true,false,e.getMessage());
                return PageRef;
            }
        }
        return PageRef;
    }
    
    //Create New User Registration History Record
    public void createnewUserRegistrationHistroy(String errMsg, boolean secquestions, boolean accountCreated,string errorMsg)
    {
        List<New_User_Registration_History__c> nurhList = [select Time_Stamp__c, Step4_Security_Questions__c, Error_Message__c from New_User_Registration_History__c where Name =: componentToPage.nurhNumber ORDER BY Createddate];
        if(nurhList != null && nurhList.size()>0)
        {   
            nurhList[0].Time_Stamp__c = system.now();
            nurhList[0].Step4_Security_Questions__c = secquestions;
            nurhList[0].Error_Message__c = errMsg;
            nurhList[0].Step6_Account_Created__c=accountCreated;
            nurhList[0].Error_Message__c = errorMsg;
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