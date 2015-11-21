public with sharing class AtlasCustomerInformationController extends AtlasDataManager
{           
        // Initializing Usage page GlobalVariables HyperLinkURL 
        public String strDashboardUrl{get{return AtlasUtility.getURL(AtlasConstants.DASHBOARD);}set;}
        public String strBeginMovingServiceUrl{get{return AtlasUtility.getURL(AtlasConstants.BEGIN_MOVING_SERVICE);}set;}
        public String strCustomerContactInfoUrl{get{return AtlasUtility.getURL(AtlasConstants.CUSTOMER_CONTACT_INFO);}set;}
        public String strChangePlanUrl{get{return AtlasUtility.getURL(AtlasConstants.strCHANGE_PLAN);}set;}
        public string strChangePWDUrl{get{return AtlasUtility.getURL(AtlasConstants.CHANGE_PWD_OR_SECURITY);}set;}  
        public string changePhoto{get{return AtlasUtility.getURL(AtlasConstants.CHANGE_PHOTO);}set;}     
        
        // Initializing Usage page GlobalVariables HyperLinkText 
        public string strDashboardText{get{return AtlasUtility.getHyperLinkText(AtlasConstants.DASHBOARD);}set;}
        public string strBeginMovingService{get{return AtlasUtility.getHyperLinkText(AtlasConstants.BEGIN_MOVING_SERVICE);}set;}
        public string strCancel{get{return AtlasUtility.getHyperLinkText(AtlasConstants.CANCEL);}set;}     
        public string strSaveChanges{get{return AtlasUtility.getHyperLinkText(AtlasConstants.SAVE_CHANGE);}set;}   
        public string strManageEmailText{get{return AtlasUtility.getHyperLinkText(AtlasConstants.MANAGE_EMAIL);}set;}
        public string strCustomerInformation{get{return AtlasUtility.getHyperLinkText(AtlasConstants.CUSTOMER_CONTACT_INFO);}set;}  
        public string strChangePlan{get{return AtlasUtility.getHyperLinkText(AtlasConstants.strCHANGE_PLAN);}set;} 
        public string strChangePWD{get{return AtlasUtility.getHyperLinkText(AtlasConstants.CHANGE_PWD_OR_SECURITY);}set;} 
        
        // Intializing Help Text 
        public string phoneRequired{get{return AtlasUtility.getMapValue(Atlasconstants.LOGIN_PHONE_VALIDATE);}set;}
        public string emailRequired{get{return AtlasUtility.getMapValue(Atlasconstants.LOGIN_EMAIL_VALIDATE);}set;}
        public string uNameLimit{get{return AtlasUtility.getMapValue(Atlasconstants.NEW_USER_UNAME_VALIDATION);}set;}
        public string unamereqd{get{return AtlasUtility.getMapValue(Atlasconstants.LOGIN_UNAME_REQD);}set;}
        public string validemail{get{return AtlasUtility.getMapValue(Atlasconstants.PLS_EMAIL_VALID);}set;}
        public string validphone{get{return AtlasUtility.getMapValue(Atlasconstants.PH_INVALID_MSG);}set;}
        public string confmUsername{get{return AtlasUtility.getMapValue(Atlasconstants.USR_CNFM_TEXT);}set;}
        public string oldpasswordReq{get{return AtlasUtility.getMapValue(Atlasconstants.OPWD_REQ_TEXT);}set;}
        public string pwdReqd{get{return AtlasUtility.getMapValue(Atlasconstants.PWD_REQD);}set;}
        public string strInvalidPwd{get{return AtlasUtility.getMapValue(Atlasconstants.PWD_VALIDATION_MSG);}set;}
        public string cpwdReqd{get{return AtlasUtility.getMapValue(Atlasconstants.CPWD_REQD);}set;}
        public string firstAnswerReqd{get{return AtlasUtility.getMapValue(Atlasconstants.FIRST_ANSWER);}set;}
        public string secondAnswerReqd{get{return AtlasUtility.getMapValue(Atlasconstants.SECOND_ANSWER);}set;}
        public string pswdHelpText {get{return AtlasUtility.getMapValue(Atlasconstants.PSWD_HELP_TEXT);}set;}
        public string quesHelpText {get{return AtlasUtility.getMapValue(Atlasconstants.QUES_HELP_TEXT);}set;}
        public string emailHelpText {get{return AtlasUtility.getMapValue(Atlasconstants.EMAIL_HELP_TEXT);}set;}
        public string billingHelpText {get{return AtlasUtility.getMapValue(Atlasconstants.BILLING_HELP_TEXT);}set;}
        public string userHelpText {get{return AtlasUtility.getMapValue(Atlasconstants.USER_HELP_TEXT);}set;}  
        public string vacationPlanList{get{return AtlasUtility.getMapValue(Atlasconstants.AtlasCPlanVacationList);}set;}       
                
        // Initializing Usage page GlobalVariables Visibility
        public boolean isVisibleDashboard{get{return AtlasUtility.getVisibility(AtlasConstants.DASHBOARD);}set;}               
        public boolean isVisibleBeginMovingService{get{return AtlasUtility.getVisibility(AtlasConstants.BEGIN_MOVING_SERVICE);}set;}        
        public boolean isVisibleCancel{get{return AtlasUtility.getVisibility(AtlasConstants.CANCEL);}set;}    
        public boolean isVisibleSaveChanges{get{return AtlasUtility.getVisibility(AtlasConstants.SAVE_CHANGE);}set;}        
        public boolean isVisibleManageEmail{get{return AtlasUtility.getVisibility(AtlasConstants.MANAGE_EMAIL);}set;}    
        public boolean isVisibleCustomerInformation{get{return AtlasUtility.getVisibility(AtlasConstants.CUSTOMER_CONTACT_INFO);}set;}
        public boolean isVisibleChangePlan{get{return AtlasUtility.getVisibility(AtlasConstants.strCHANGE_PLAN);}set;}
        public boolean isVisibleChangePWD{get{return AtlasUtility.getVisibility(AtlasConstants.CHANGE_PWD_OR_SECURITY);}set;}   
        public string strAreYouMoving{get{return AtlasUtility.getMapValue(AtlasConstants.ARE_YOU_MOVING);}set;}
        public String debugText{get{return AtlasConstants.DEBUG_STRING;}set;}     
       
        // Variables used in Customerinfo page    
        public string strUsername{get;set;}
        public string strConfirmUsername{get;set;}                  
        public string oldStrUsername{get;set;}                       
        public string strPassword{get;set;}
        public string StrPhone{get;set;}   
        public string StrPhoneArea{get;set;}                       
        public string StrPhonePrefix{get;set;}                     
        public string StrPhoneLine{get;set;}                                            
        public string StrPhoneAreaSecond{get;set;}                  
        public string StrPhonePrefixSecond{get;set;}                
        public string StrPhoneLineSecond{get;set;}                  
        public string StrPhoneClean{get;set;}
        public string StrPhoneCleanSecond{get;set;}
        public string StrPhoneAreaClean{get;set;}
        public string StrPhoneAreaSecondClean{get;set;}            
        public string strEmailId{get;set;}
        public string strBillingAddress1{get;set;}
        public string strBillingAddress2{get;set;}
        public string strCity{get;set;}
        public string strState{get;set;}
        public string strZip{get;set;} 
        public string strZip4{get;set;}  
        public string strZipLeft{get;set;}
        public string strZipRight{get;set;}    
        public string externalAccountReference{get;set;} 
        public string externalSystemName{get;set;}
        public string firstName{get;set;}          
        public string lastName{get;set;}
        public string StrsecondaryPhone{get;set;}
        public string countryCode{get;set;}
        public string taxJurisdictionCode{get;set;}
        public string strTitle{get{return AtlasUtility.getMapValue(AtlasConstants.STRTITLE_CustomerInfo);}set;}
        public string strHeader2{get{return AtlasConstants.STRHEADER2_CustomerInfo ;}set;}
        public string strOption{get{return AtlasConstants.STROPTION_CustomerInfo ;}set;}
        public String UsernameText{get{return AtlasConstants.UsernameText;}set;}
        public String PhoneText{get{return AtlasConstants.PhoneText;}set;}
        public String EmailText{get{return AtlasConstants.EmailText;}set;}
        public String BillingAddress1Text{get{return AtlasConstants.BillingAddress1Text;}set;}
        public String BillingAddress2Text{get{return AtlasConstants.BillingAddress2Text;}set;}
        public String CityText{get{return AtlasConstants.CityText;}set;}
        public String StateText{get{return AtlasConstants.StateText;}set;}
        public String ZIPCodeText{get{return AtlasConstants.ZIPCodeText;}set;}    
        public String billingState{get; set;}
        public string passwordText{get{return AtlasConstants.PASSWORD;}set;} 
        public string customerNameText{get{return AtlasConstants.CUSTOMER_NAME;}set;}
        public string accountNumberText{get{return AtlasConstants.ACOUNT_NUMBER;}set;}
        public string noteText{get{return AtlasConstants.NOTE;}set;}
        public string note1Text{get{return AtlasConstants.NOTE1;}set;}
        public string note2Text{get{return AtlasConstants.NOTE2;}set;}
        public string note3Text{get{return AtlasConstants.NOTE3;}set;}
        public string oldCustomerPortalText{get{return AtlasConstants.OLD_CUSTOMER_PORTAL;}set;}
        public boolean isEditEnable {get;set;} 
        public String exceptionDivStyle{get;set;}
        
        //variables used for Exception messages
        public boolean isVisibleExceptionMessage{get;set;}
        public string exceptionString{get;set;}
        public string exceptionStringSmall{get;set;}
        public string siteURL{get;set;}
        public boolean isVisibleSuccessAlert{get;set;}
        public boolean isUserImageUpdated{get;set;}
        public boolean isImageRefreshPoller{get;set;}
        public boolean isUserOldImage{get;set;}
        public string updatePhotoURL{get;set;}
        public string updateCustomerInfo{get{return AtlasUtility.getMapValue(AtlasConstants.UPDATE_CUSTOMER_INFO_SUCCESS);}set;}
        public string editPicture{get{return AtlasConstants.EDIT_PICTURE;}set;}
        public string pageName{get{return AtlasConstants.STRCUSTOMER_INFO;}set;}
        public string updatedusername{get;set;}
        public string updatedpassword{get;set;}
        public string updatednewpassword{get;set;}
        public string retypenewpassword{get;set;}
        public string errormessage{get;set;}
        public boolean isError{get;set;}
        public boolean isError1{get;set;}
        public boolean isError2{get;set;}
        public boolean isPageEroor{get;set;}
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
        public string editSecurityQuestions{get{return Atlasconstants.EDIT_SECURITY_QUESTIONS;}set;}
        public string SQmessge1{get{return AtlasUtility.getMapValue(Atlasconstants.SQ1_VALID_FAILED);}set;}
        public string SQmessge2{get{return AtlasUtility.getMapValue(Atlasconstants.SQ2_VALID_FAILED);}set;}  
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
          
          public string sqAnswer1{get;set;}
          public string sqAnswer2{get;set;}
          public string sqa;
          public string maskedSQAnswer1{get;set;}
          public string maskedSQAnswer2{get;set;}
          public AtlasComponenttoController componentToPage{get; set;}
          public boolean isMaskedSQA1{get;set;}
          public boolean isMaskedSQA2{get;set;}                   
          public string weak{get{return Atlasconstants.WEAK;}set;}
          public string good{get{return Atlasconstants.GOOD;}set;}
          public string strong{get{return Atlasconstants.STRONG;}set;}
          public string createPWDTEXT{get{return Atlasconstants.CREATE_PWD;}set;}
          public string editPWDTEXT{get{return Atlasconstants.EDIT_PWD;}set;}
          public string PWD{get{return Atlasconstants.PWD;}set;}
          public string rePWD{get{return Atlasconstants.RE_PWD_LABEL;}set;}
          
          public string accountNumber{get;set;}
          public string password{get;set;}
          public string oldpassword{get;set;}
          public string confirmPwd{get;set;}
                
          public string uNameText{get{return Atlasconstants.UserNameLabel;}set;}
          public string chooseUName{get{return Atlasconstants.PLS_CHOOSE_UNAME;}set;}
          public string validUName{get{return Atlasconstants.PLS_VALID_UNAME;}set;}
          public string notYouText{get{ return AtlasUtility.getHyperLinkText(AtlasConstants.NOT_YOU);}set;}
          public string notYouURL{get{ return AtlasUtility.getURL(AtlasConstants.NOT_YOU);}set;}
          public String strMoving{get{return AtlasUtility.getURL(AtlasConstants.Moving);}set;}
          
    /**
    * @author Shiva Shankar
    * @description - Constructor for AtlasCustomerInformationController
    * @input param  - null
    * @return null
    */  
        public AtlasCustomerInformationController(){  
            Apexpages.currentPage().getHeaders().put(AtlasConstants.X_UA_COMPATIBLE,AtlasConstants.IE_8);
            isImageRefreshPoller=false;
            isVisibleExceptionMessage=false;
            isVisibleSuccessAlert=false;
            isUserImageUpdated=false;
            isUserOldImage=true;
            isEditEnable=false;
            exceptionDivStyle=AtlasConstants.EXCEPTION_DIV_STYLE;
            exceptionString='';
            exceptionStringSmall='';
            siteURL = URL.getSalesforceBaseUrl().toExternalForm();                              
            isMaskedSQA1=false;
            isMaskedSQA2=false;
            maskedSQAnswer1='';
            maskedSQAnswer2='';
            isPageEroor=true;
            List<AtlasSecurityQuestionsList__c> SQList=AtlasSecurityQuestionsList__c.getall().values();
            selectedSQA1=SQList[0].Value__c;
            List<AtlasSecurityQuestionsList1__c> SQList1=AtlasSecurityQuestionsList1__c.getall().values();
            selectedSQA2=SQList1[0].Value__c;
        }
        
    /**
    * @author - Tejesh Kumar
    * @description - To enable the edit info button
    * @input param  - null
    * @return param - null
    */     
        public pagereference editEnable() {
            isEditEnable=true;
            return null;
        }
        
    /**
    * @author Shiva Shankar
    * @description - To get list of states from custom settings
    * @input param  - null
    * @return param List of states
    */         
        public List<SelectOption> getBillingStates(){
            List<SelectOption> options=new List<SelectOption>();
            List<AtlasBillingStatesList__c> bStates=AtlasBillingStatesList__c.getall().values();
            bStates.sort();
            for (AtlasBillingStatesList__c bState: bStates)
            options.add(new SelectOption(bState.StateAbbreviatedCode__c,bState.StateAbbreviatedCode__c));
            return options;
        }
        
    /**
    * @author Shiva Shankar
    * @description - PopulateAtlasDashboardData for AtlasCustomerInformationController
    * @input param  - null
    * @return param void
    */         
        public  void callRemoteAtlasDashboardData()
        {
            populateAtlasDashboardData();             
        }
        
    /**
    * @author Shiva Shankar
    * @description - getCurrentDataUsageDashBoradData for AtlasCustomerInformationController
    * @input param  - null
    * @return param void
    */ 
        public  void currentDataUsageAtlasDashboardData()
        {   if(!AtlasUtility.isEmpty(mainDTOObj.accountDTOObj))
                getCurrentDataUsageDashBoradData();                
        }
        
    /**
    * @author Shiva Shankar
    * @description - getCurrentPaymentSettingsBillPage for AtlasCustomerInformationController
    * @input param  - null
    * @return param void
    */ 
        public  void currentPaymentSettingsCurrentBillPage()
        {
            getCurrentPaymentSettingsBillPage();
            isEditEnable=true;              
        }
        
    /**
    * @author Shiva Shankar
    * @description - getMyAccountDashBoardData for AtlasCustomerInformationController
    * @input param  - null
    * @return param void
    */ 
        public  void myAccountAtlasDashboardData()
        {   if(!AtlasUtility.isEmpty(mainDTOObj.accountDTOObj))
                getMyAccountDashBoardData();
                AtlasConstants.IS_REFRESH_CALL=false;
                
        }
        
    /**
    * @author Shiva Shankar
    * @description - getBillingSnapShotDashBoardDAta for AtlasCustomerInformationController
    * @input param  - null
    * @return param void
    */ 
        public  void billingSnapshotAtlasDashboardData()
        {
            getBillingSnapShotDashBoardDAta();
        }
        
    /**
    * @author Shiva Shankar
    * @description - getPlanDetailsForCustomerInfo for AtlasCustomerInformationController
    * @input param  - null
    * @return param void
    */ 
        public void getPlanDetailsForCustomerInfo()
        {
            getPlanDetails();
            isEditEnable=true;
        }
        
    /**
    * @author Shiva Shankar
    * @description - fillCustomerUpdateForFromDTO for AtlasCustomerInformationController
    * @input param  - null
    * @return param void
    */ 
        public void fillCustomerUpdateForFromDTO()
        {
            isVisibleExceptionMessage = false;
            isVisibleSuccessAlert=false;
            exceptionString = '';
            exceptionDivStyle='';                   
            StrsecondaryPhone = '';
            sqAnswer1 = '';
            sqAnswer2 = '';
            password = '';
            confirmPwd = '';
            oldpassword = '';
            strConfirmUsername = '';
            strUsername = '';
            maskedSQAnswer1 = '';
            maskedSQAnswer2 = '';
            isMaskedSQA1 = false;
            isMaskedSQA2 = false; 
                                                                                                                                                  
            if(mainDTOObj.accountDTOObj != null){
                oldStrUsername =mainDTOObj.federationId;              
                strEmailId=mainDTOObj.accountDTOObj.contactEmail; 
                StrPhone=mainDTOObj.accountDTOObj.strUSMobileNOFormat;                 
                StrPhoneClean = strPhone.replaceAll('-',''); 
                StrPhoneArea = '(' + StrPhoneClean.substring(0, 3) + ')' + ' ' + StrPhoneClean.substring(3,6) + '-' + StrPhoneClean.substring(6,10);                               
                StrsecondaryPhone=mainDTOObj.accountDTOObj.secondaryPhone;
                if(!AtlasUtility.isEmpty(StrsecondaryPhone)){
                    StrPhoneCleanSecond = StrsecondaryPhone.replaceAll('-','');
                    if(StrPhoneCleanSecond.length()==10) {
                        StrPhoneAreaSecond = '(' + StrPhoneCleanSecond.substring(0, 3) + ')' + ' ' + StrPhoneCleanSecond.substring(3,6) + '-' + StrPhoneCleanSecond.substring(6,10);              
                    }
                }
                strBillingAddress1=mainDTOObj.accountDTOObj.address1;     
                strBillingAddress2=mainDTOObj.accountDTOObj.address2;
                strCity=mainDTOObj.accountDTOObj.city;
                strState=mainDTOObj.accountDTOObj.state;
                strZip=mainDTOObj.accountDTOObj.zip;
                strZip4=mainDTOObj.accountDTOObj.zip4;                                                                                          
                externalAccountReference=mainDTOObj.externalAccountReference;
                externalSystemName=mainDTOObj.externalSystemName;
                firstName=mainDTOObj.accountDTOObj.firstName;
                lastName=mainDTOObj.accountDTOObj.lastName;
                countryCode=AtlasConstants.COUNTRY_CODE;               
            }
        }
        
    /**
    * @author Shiva Shankar
    * @description - saveCustomerInformation for AtlasCustomerInformationController
    * @input param  - null
    * @return param null
    */ 
        public PageReference saveCustomerInformation()
        { 
            exceptionString = '';
            if(AtlasUtility.isEmpty(strPhoneArea) || AtlasUtility.isEmpty(strEmailId) || AtlasUtility.isEmpty(strState) || AtlasUtility.isEmpty(strCity) || AtlasUtility.isEmpty(strBillingAddress1)
               || AtlasUtility.isEmpty(strZip)){
                isVisibleExceptionMessage = true;
                isVisibleSuccessAlert = false;
                exceptionString = 'Please fill up required fields.';
                return null;
            } 
            if((!AtlasUtility.isEmpty(strPhoneArea) && strPhoneArea=='0000000000'))
            {
             isVisibleExceptionMessage = true;
               isVisibleSuccessAlert = false;
               exceptionString = 'Invalid phone number.';
               return null;
            }
            if(!AtlasUtility.isEmpty(strPhoneAreaSecond))
            {                       
                if((!AtlasUtility.isEmpty(strPhoneAreaSecond) && strPhoneAreaSecond=='0000000000'))
                {
                    isVisibleExceptionMessage = true;
                    isVisibleSuccessAlert = false;
                    exceptionString = 'Invalid secondary phone number.';
                    return null;
                }
            }                        
            if(strEmailId.length() < 6 || strEmailId.length() > 80 ){
                isVisibleExceptionMessage = true;
                isVisibleSuccessAlert = false;
                exceptionString = exceptionString + '\nInvalid Email Address.';
                return null;
            }                               
            if(strZip == '00000' || strZip.length() < 5){
                isVisibleExceptionMessage = true;
                isVisibleSuccessAlert = false;
                exceptionString = exceptionString + '\nInvalid ZIP code.';
                return null;
            }
            if(strZip4!=''){
                if(strZip4 == '0000' || strZip4.length() < 4){
                    isVisibleExceptionMessage = true;
                    isVisibleSuccessAlert = false;
                    exceptionString = exceptionString + '\nInvalid ZIP code.';
                    return null;
                }
            }
            if(exceptionString == ''){
                system.debug('saveCustomerInfo start');
                system.debug('-----------------mainDTOObj.accountDTOObj-----------------' + mainDTOObj.accountDTOObj);
                if(AtlasUtility.isEmpty(strBillingAddress1))strBillingAddress1='';else strBillingAddress1=strBillingAddress1.trim();
                if(AtlasUtility.isEmpty(strBillingAddress2))strBillingAddress2='';else strBillingAddress2=strBillingAddress2.trim();
                if(AtlasUtility.isEmpty(strCity))strCity='';else strCity=strCity.trim();
                if(AtlasUtility.isEmpty(strState))strState='';else strState=strState.trim();
                if(AtlasUtility.isEmpty(strEmailId))strEmailId='';else strEmailId=strEmailId.trim();
                if(AtlasUtility.isEmpty(strUsername))strUsername=null;else strUsername=strUsername.trim();                                            
                if(!AtlasUtility.isEmpty(strZip) && !AtlasUtility.isEmpty(strZip4))
                    strZip=strZip.trim() + '-' + strZip4.trim();
                else if(!AtlasUtility.isEmpty(strZip))
                    strZip=strZip.trim();
                else
                    strZip='';
                StrPhoneAreaClean = strPhoneArea.replaceAll('[- )(]','');
                StrPhone = StrPhoneAreaClean;

                if(!AtlasUtility.isEmpty(strPhoneAreaSecond )){
                    StrPhoneAreaSecondClean = strPhoneAreaSecond.replaceAll('[- )(]','');
                    StrsecondaryPhone = StrPhoneAreaSecondClean;
                }
                else
                    StrsecondaryPhone=strPhoneAreaSecond;
                    
                // Start: To retrieve tax jurisdiction code
                AtlasTransactionDTO.UpdateCustomerInfoTxDTO CustInfoObj = new AtlasTransactionDTO.UpdateCustomerInfoTxDTO(externalAccountReference,externalSystemName,strUsername,strPhone,strEmailId, 
                strPassword,strBillingAddress1,strBillingAddress2,strCity,strState,strZip,strZip4,firstName,lastName,StrsecondaryPhone, 
                AtlasConstants.COUNTRY_CODE,taxJurisdictionCode,oldStrUsername,null,null);              
                List<AtlasPubContactServXmlschema.AddressAndTaxJurisdictions> findAddressAndTaxJurisdictions = AtlasIntegrationUtility.findAddressAndTaxJurisdictions(custInfoObj);
                if(!AtlasUtility.isEmpty(findAddressAndTaxJurisdictions)){
                    taxJurisdictionCode=findAddressAndTaxJurisdictions[0].taxJurisdictionCode[0];
                }
                else{
                    taxJurisdictionCode= AtlasUtility.getMapValue(Atlasconstants.JCODE_INVALID_ADDRESS);                 
                }
                // End: To retrieve tax jurisdiction code
                    
                AtlasTransactionDTO.UpdateCustomerInfoTxDTO updateCustInfoObj = new AtlasTransactionDTO.UpdateCustomerInfoTxDTO(externalAccountReference,externalSystemName,strUsername,strPhone,strEmailId, 
                strPassword,strBillingAddress1,strBillingAddress2,strCity,strState,strZip,strZip4,firstName,lastName,StrsecondaryPhone, 
                AtlasConstants.COUNTRY_CODE,taxJurisdictionCode,oldStrUsername,null,null);
                try{
                    system.debug('saveCustomerInfo: ' + updateCustInfoObj);
                    updateCustomerInfo(updateCustInfoObj);
                    if(!AtlasUtility.isEmpty(StrsecondaryPhone)) 
                         mainDTOObj.accountDTOObj.secondaryPhone=StrsecondaryPhone;
                    else
                        mainDTOObj.accountDTOObj.secondaryPhone=StrsecondaryPhone;
                    mainDTOObj.accountDTOObj.contactEmail=strEmailId;
                    persistViewState();
                    isVisibleSuccessAlert=true;
                    isVisibleExceptionMessage = false;
                }catch(AtlasException e)
                {
                    system.debug('saveCustomerInfo catch: ' + e.errorMessage);
                    isVisibleExceptionMessage=true;
                    isVisibleSuccessAlert=false;
                    exceptionString= e.errorMessage ;
                    exceptionDivStyle='';                   
                }                           
                PageReference page = new PageReference('/'+atlasconstants.STRCUSTOMER_INFO);
                page.setRedirect(false);
            }
            return  null;              
        }
        
    /**
    * @author Shiva Shankar
    * @description - saveUsername for AtlasCustomerInformationController
    * @input param  - null
    * @return param null
    */ 
        public PageReference saveUsername()
        {   
            oldStrUsername =mainDTOObj.federationId;    
            try{
                system.debug(strConfirmUsername + '------------------strUsername-------' + strUsername);
                if((AtlasUtility.isEmpty(strUsername))||(AtlasUtility.isEmpty(strConfirmUsername))) {
                    isVisibleExceptionMessage = true;
                    isVisibleSuccessAlert = false;
                    exceptionString = 'Please fill up required fields.';
                    return null;
                }else if(!AtlasUtility.isEmpty(strConfirmUsername)){
                    if(strUsername != strConfirmUsername){
                        isVisibleExceptionMessage = true;
                        isVisibleSuccessAlert = false;
                        exceptionString = 'Usernames are not matching.';
                        return null;
                    }
                }
                List<User> userObj = [select Id from User where FederationIdentifier =: strUsername limit 1];               
                if(AtlasUtility.isEmpty(userObj)){       
                    AtlasSSOWS.changeLoginUserNameResponse_element result;
                    if (!Test.isRunningTest()) 
                        result= AtlasIntegrationUtility.changeLoginUserName(oldStrUsername ,strUsername);
                    else
                    result=(AtlasSSOWS.changeLoginUserNameResponse_element)JSON.deserialize(AtlasTestConstants.getMetadata('changeUserNameResponse'),AtlasSSOWS.changeLoginUserNameResponse_element.class);              
                    system.debug('---------result----------------' + result);
                    system.debug('----------result.status------------' + result.status);  
                    system.debug('----------result.loginusername------------' + result.loginusername);              
                    if(oldStrUsername == result.loginusername){
                       oldStrUsername = strUsername;
                       isVisibleSuccessAlert=true;
                       isVisibleExceptionMessage = false;
                       mainDTOObj.accountDTOObj.username=strUsername;
                       mainDTOObj.federationId=oldStrUsername;                 
                       persistViewState();
                    }else{
                       isVisibleExceptionMessage = true;
                       isVisibleSuccessAlert=false;
                       exceptionString = 'Username is not available';
                       exceptionDivStyle='';                        
                    } 
                }
                else {
                    isVisibleExceptionMessage=true;
                    isVisibleSuccessAlert=false;
                    exceptionString= 'Duplicate Username.';
                    exceptionDivStyle='';       
                }
            }catch(AtlasException e)
            {
                system.debug('saveCustomerInfo catch: ' + e.errorMessage);
                isVisibleExceptionMessage=true;
                isVisibleSuccessAlert=false;
                exceptionString= e.errorMessage ;
                exceptionDivStyle='';                   
            }
            return  null;               
        }
        
    /**
    * @author Shiva Shankar
    * @description - savePasswordfor AtlasCustomerInformationController
    * @input param  - null
    * @return param null
    */ 
        public PageReference savePassword()
        {    
            try{    
                if(AtlasUtility.isEmpty(oldpassword) || AtlasUtility.isEmpty(password) || AtlasUtility.isEmpty(confirmPwd)){
                    isVisibleExceptionMessage = true;
                    isVisibleSuccessAlert = false;
                    exceptionString = 'Please fill up required fields.';
                    return null;
                }else if(confirmPwd != password){
                    isVisibleExceptionMessage = true;
                    isVisibleSuccessAlert = false;
                    exceptionString = 'Password are not matching.';
                    return null;
                }else if(password.length() < 8){
                    isVisibleExceptionMessage = true;
                    isVisibleSuccessAlert = false;
                    exceptionString = 'Password is invalid.';
                    return null;
                }
                                           
                AtlasSSOWS.changePasswordResponse_element resp = AtlasIntegrationUtility.changePassword(mainDTOObj.federationId,oldpassword,password);
                system.debug('--- password response ---' + resp);
                if(mainDTOObj.federationId == resp.loginusername){
                    isVisibleSuccessAlert=true;
                    isVisibleExceptionMessage = false;
                }else{
                    isVisibleExceptionMessage = true;
                    isVisibleSuccessAlert=false;
                    exceptionString = 'Authentication Failed';
                    exceptionDivStyle=''; 
                    return null;
                }                
                system.debug('--------pwd--------------' + strUsername );
            }catch(AtlasException e)
            {
                system.debug('saveCustomerInfo catch: ' + e.errorMessage);
                isVisibleExceptionMessage=true;
                isVisibleSuccessAlert=false;
                exceptionString = e.errorMessage ;
                exceptionDivStyle='';                   
            }            
            PageReference page = new PageReference('/'+atlasconstants.STRCUSTOMER_INFO);
            page.setRedirect(false);
            return  null;               
        }
                
    /**
    * @author Shiva Shankar
    * @description - saveCustomerInformation for AtlasCustomerInformationController
    * @input param  - null
    * @return param null
    */         
      public PageReference saveSecurityQuestions()
        {   
            system.debug('enter method.............. ');
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
    public void ClearFieldsSecQues()
    {
        sqAnswer1='';
        sqAnswer2='';       
    }

    /**
    * @author Shiva Shankar
    * @description - clearMyAccDataForRefresh for AtlasCustomerInformationController
    * @input param  - null
    * @return param void
    */ 
        public void clearMyAccDataForRefresh()
        {
            clearMyAccountDataForRefresh();
        }
        
    /**
    * @author Shiva Shankar
    * @description - cancelException for AtlasCustomerInformationController
    * @input param  - null
    * @return param null
    */     
        public PageReference cancelException()
        {
            isVisibleExceptionMessage = false;
            isVisibleSuccessAlert=false;
            return null;
        }
        
    /**
    * @author Shiva Shankar
    * @description - updateUserImage for AtlasCustomerInformationController
    * @input param  - null
    * @return param null
    */ 
        public PageReference updateUserImage()
        {
            User userObj=getUserDetails();
            if(mainDTOObj.accountDTOObj.SmallPhotoUrl!=userObj.SmallPhotoUrl)
            {
                    isImageRefreshPoller=false;
                    isUserImageUpdated=true;
                    isUserOldImage=false;
                    updatePhotoURL=userObj.SmallPhotoUrl;
                    mainDTOObj.accountDTOObj.smallPhotoURL=userObj.SmallPhotoUrl;
                    mainDTOObj.smallPhotoURL=userObj.SmallPhotoUrl;
                    persistViewState();
            }
            return null;
        }
        
    /**
    * @author Shiva Shankar
    * @description - openImageEditPopup for AtlasCustomerInformationController
    * @input param  - null
    * @return param null
    */ 
        public PageReference openImageEditPopup()
        {
            isImageRefreshPoller=true;
            return null;                
        }
        
        public Pagereference isMaskedSQA1()
        {
          if(!AtlasUtility.isEmpty(sqAnswer1))
          {   isError1=false;  
              isPageEroor=true;
              exceptionString='';
              sqAnswer1=sqAnswer1.trim();
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
          {   isError2=false;
              exceptionString='';
              isPageEroor=true;                           
              sqAnswer2=sqAnswer2.trim();
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
        public Pagereference isMaskedSQA1Changed()
        {                           
            isMaskedSQA1=false;
            maskedSQAnswer1='';
            isPageEroor=false;
            isError1=false;
            isError2=false;    
            exceptionString='';
            isVisibleExceptionMessage = false;   
            return null;            
        }
        public Pagereference isMaskedSQA2Changed()
        {
            isMaskedSQA2=false;
            maskedSQAnswer2='';
            isError1=false;
            isPageEroor=false;
            isError2=false;  
            exceptionString='';
            isVisibleExceptionMessage = false;
            return null;
        }
        
    /**
    * @author Tejesh Kumar
    * @description - To clear fields in Security Questions
    * @input param  - null
    * @return param null
    */ 
        public pagereference clearFields()
        {
            sqAnswer1='';
            maskedSQAnswer1='';
            isMaskedSQA1=false;
            isVisibleExceptionMessage = false;
            isMaskedSQA2=false;
            sqAnswer2='';
            maskedSQAnswer2='';  
            exceptionString=''; 
            isError2=false;
            isError1=false;
            return null;
        }       
}