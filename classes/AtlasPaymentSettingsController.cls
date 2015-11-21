/*********************************************************************************
Name         : AtlasPaymentSettingsController
Created By   : Shiva Shankar N 
Modified BY  : Shiva Shankar N 
Company Name : NTT Data
Project      : ViaSat Atlas, Bangalore
Created Date : 22 October 2013
Modified Date: 13 November 2013
Usages       : Controller for VisualForce Page: PaymentSettings
*********************************************************************************/
public virtual with sharing class AtlasPaymentSettingsController extends AtlasDataManager{
         
        //Intializing static values for apex:input field value
        public string strUpdateAdd1{get;set;}
        public string strUpdateAdd2{get;set;}
        public string strUpdateCity{get;set;}
        public string strUpdateState{get;set;}
        public string strUpdateZip{get;set;}
        public string strUpdateAcc{get;set;}
        public string strUpdateName{get;set;}
        public string strUpdateAccNum{get;set;}
        public string strUpdateMonth{get;set;}
        public string strUpdateYear{get;set;}
        public string strUpdateCCV{get;set;}
        public string strUpdateRouting{get;set;}
        // Initialinzing PaymentSettings Page GlobalVariables HyperLinkURL
        public String strDashboardUrl{get{return AtlasUtility.getURL(AtlasConstants.DASHBOARD);}set;}
        public string strCurrentBillURL{get{return AtlasUtility.getURL(AtlasConstants.CURRENT_BILL);}set;}
        public string strCurrentBillPaymentURL{get{return AtlasUtility.getURL(AtlasConstants.CURRENT_BILL);}set;}
        public string strBillingHistoryURL{get{return AtlasUtility.getURL(AtlasConstants.BILLING_HISTORY);}set;}
        public string strEditPaymentMethodURL{get{return AtlasUtility.getURL(AtlasConstants.EDIT_PAYMENT_METHOD);}set;}
        public string strExedeVoiceURL{get{return AtlasUtility.getURL(AtlasConstants.EXEDE_VOICE);}set;}
        public string strKnowledgeBaseURL{get{return AtlasUtility.getURL(AtlasConstants.KNOWLEDGE_BASE);}set;}
        public String strSignOut{get{return AtlasUtility.getURL(AtlasConstants.SIGNOUT);}set;}
        public String strPaymentSettingsUrl{get{return AtlasUtility.getURL(AtlasConstants.PAYMENT_SETTINGS);}set;}
        public String strCustomerContactInfoUrl{get{return AtlasUtility.getURL(AtlasConstants.CUSTOMER_CONTACT_INFO);}set;}
        public String strManageEmailUrl{get{return AtlasUtility.getURL(AtlasConstants.MANAGE_EMAIL);}set;}
        public String strOnlineCommunity{get{return AtlasUtility.getURL(AtlasConstants.ONLINE_COMMUNITY);}set;}
        public String strBlog{get{return AtlasUtility.getURL(AtlasConstants.BLOG);}set;}
        public String strForum{get{return AtlasUtility.getURL(AtlasConstants.FORUM);}set;}
        public String strCommunityExede{get{return AtlasUtility.getURL(AtlasConstants.COMMUNITY);}set;}
        public String strVoicePromoUrl{get{return AtlasUtility.getURL(AtlasConstants.EXEDE_VOICE);}set;}
        public String strExcedeVoiceUrl{get{return AtlasUtility.getURL(AtlasConstants.EXEDE_VOICE);}set;}          
        // Initialinzing Dashboard Page GlobalVariables HyperLinkText
        public string strCurrentBillText{get{return AtlasUtility.getHyperLinkText(AtlasConstants.CURRENT_BILL);}set;}
        public string strCurrentBillPaymentText{get{return AtlasUtility.getHyperLinkText(AtlasConstants.CURRENT_BILL);}set;}
        public string strBillingHistoryText{get{return AtlasUtility.getHyperLinkText(AtlasConstants.BILLING_HISTORY);}set;}
        public string strEditPaymentMethodText{get{return AtlasUtility.getHyperLinkText(AtlasConstants.EDIT_PAYMENT_METHOD);}set;}
        public string strPaymentSettingsText{get{return AtlasUtility.getHyperLinkText(AtlasConstants.PAYMENT_SETTINGS);}set;}
        public string strExedeVoiceText{get{return AtlasUtility.getHyperLinkText(AtlasConstants.EXEDE_VOICE);}set;}
        public string strKnowledgeBaseText{get{return AtlasUtility.getHyperLinkText(AtlasConstants.KNOWLEDGE_BASE);}set;} 
        public string strLearnAboutExedeVoiceText{get{return AtlasUtility.getHyperLinkText(AtlasConstants.EXEDE_VOICE);}set;}
        public string strVisitTheKnowledgeBaseText{get{return AtlasUtility.getHyperLinkText(AtlasConstants.KNOWLEDGE_BASE);}set;}
        public string strSaveText{get{return AtlasUtility.getHyperLinkText(AtlasConstants.SAVE);}set;}
        public string strCancelText{get{return AtlasUtility.getHyperLinkText(AtlasConstants.CANCEL);}set;}                           
        //Intializing Global Variables for IsVisibility
        public boolean isVisibleDashboard{get{return AtlasUtility.getVisibility(AtlasConstants.DASHBOARD);}set;}
        public boolean isVisibleCurrentBill{get{return AtlasUtility.getVisibility(AtlasConstants.CURRENT_BILL);}set;}
        public boolean isVisibleCurrentBillPayment{get{return AtlasUtility.getVisibility(AtlasConstants.CURRENT_BILL);}set;}
        public boolean isVisibleBillingHistory{get{return AtlasUtility.getVisibility(AtlasConstants.BILLING_HISTORY);}set;}
        public boolean isVisiblePaymentSettings{get{return AtlasUtility.getVisibility(AtlasConstants.PAYMENT_SETTINGS);}set;}
        public boolean isVisibleExedeVoice{get{return AtlasUtility.getVisibility(AtlasConstants.EXEDE_VOICE);}set;}
        public boolean isVisibleKnowledgeBase{get{return AtlasUtility.getVisibility(AtlasConstants.KNOWLEDGE_BASE);}set;}
        //Variable for PaymentSettings.page
        public String strTitle{get{return AtlasUtility.getMapValue(AtlasConstants.STRTitle_PaymentSettings);}set;}   
        public string pageName{get{return AtlasConstants.STRPAYMENT_SETTINGS;}set;}
        public integer CvvSize{get;set;}
        public integer cardNumberSize{get;set;}
        public boolean isSaveEnable{get;set;}
        public string achDisclaimer1{get{return AtlasUtility.getMapValue(AtlasConstants.AtlasAchDisclaimer1);}set;}
        public string achDisclaimer2{get{return AtlasUtility.getMapValue(AtlasConstants.AtlasAchDisclaimer2);}set;}
        public string invalidCVVMsg{get{return AtlasUtility.getMapValue(AtlasConstants.Invalid_CVV);}set;}
        public string invalidCCMsg{get{return AtlasUtility.getMapValue(AtlasConstants.Invalid_CC);}set;}
      /**
        * @author Raghuprasad Halakere 
        * @description - zero parameter AtlasPaymentSettingsController constructor
        * @param object null
        * @return void
        */      
        public AtlasPaymentSettingsController(){  
                Apexpages.currentPage().getHeaders().put(AtlasConstants.X_UA_COMPATIBLE,AtlasConstants.IE_8);                          
                displayPaymentSettings = false;  //Sets the edit payment settings display to false
                refreshPage = false;             //Sets the page to not reload. Page will be reloaded only when the payment settings were updated successfully.
                CvvSize=4;
                cardNumberSize=16;
                encryptionKey = AtlasUtility.getHyperlinkText(AtlasConstants.EncryptionKey);
                isSaveEnable=true;
                //populateAtlasDashboardData();
                //populateCurrentPayment();
        }
      /**
        * @author Raghuprasad Halakere 
        * @description - assigns staticValues for paymentsettings
        * @param object null
        * @return void
        */       
        public void staticValues(){
                strUpdateAdd1='update-address-1';
                strUpdateAdd2='update-address-2';
                strUpdateCity='update-city';
                strUpdateState='update-state';
                strUpdateZip='update-zip';
                strUpdateAcc='update-acc';
                strUpdateName='update-name';
                strUpdateAccNum='update-acc-number';
                strUpdateMonth='update-month';
                strUpdateYear='update-year';
                strUpdateCCV='update-ccv';
                strUpdateRouting='update-routing';
        }
        // Variables for updating Payment Method
        Public string cookieValue{get;set;}
        public class duplicateAddress
        {
                public Integer index{get;set;}
                public String address{get;set;}
                public String city{get;set;}
                public String state{get;set;}
                public String jurisdictionCode{get;set;}
                public duplicateAddress(Integer index,String address,String city,String state,String jurisdictionCode)
                {
                        this.index=index;
                        this.address=address;
                        this.city=city;
                        this.state=state;
                        this.jurisdictionCode=jurisdictionCode;
                }
        }
        public List<duplicateAddress> allDuplicateAddresses=new List<duplicateAddress>(); 
      /**
        * @author Raghuprasad Halakere 
        * @description - getAllValidAddresses for paymentsettings
        * @param object null
        * @return List of Addresess 
        */            
        public List<duplicateAddress> getAllValidAddresses()
        {
                return allDuplicateAddresses;
        }
        
        // Variables used in paymentsettings.pae  
        public Boolean multipleAddressesFound {get; set;}
        public List<AtlasPubContactServXmlschema.AddressAndTaxJurisdictions> allAddressMatchedFound{get;set;}
        public AtlasPubContactServXmlschema.AddressAndTaxJurisdictions finalValidatedAddress{get;set;}
        public String billingState{get;set;}
        Public String billingAddress1{get;set;}
        Public String billingAddress2{get;set;}
        Public String billingCity{get;set;}
        Public String billingZip{get;set;}
        public Boolean displayPaymentSettings{get;set;}
        public String updatePaymentAcccountType{get;set;}
        public String accountHolderName{get;set;}   
        public String bankAccountNumber{get;set;}
        public String maskedBankAccountNumber{get;set;}
        public String bankAccountRoutingNumber{get;set;}
        public String maskedBankAccountRoutingNumber{get;set;}
        public String bankAccountType{get;set;}
        public String creditCardNumber{get;set;}
        Public String maskedCreditCardNumber{get;set;}
        Public String creditCardType{get;set;}
        Public String creditCardMonth {get;set;}
        Public String creditCardYear{get;set;}
        Public String creditCardCVV{get;set;}
        Public String maskedcreditCardCVV{get;set;}
        Public String CreditCardZipCode{get;set;}
        public String errorMessage{get;set;} 
        Public String successMessage{get;set;}
        Public boolean refreshPage{get;set;}
        Public boolean enablePaymentSettingsSubmit{get;set;}
      /**
        * @author Raghuprasad Halakere 
        * @description - getAllValidAddresses for paymentsettings
        * @param object null
        * @return List of Addresess 
        */             
       public  void callRemoteAtlasDashboardData()
      {
          populateAtlasDashboardData();          
      }
      /**
        * @author Raghuprasad Halakere 
        * @description - calls getCurrentDataUsageDashBoradData method for paymentsettings
        * @param object null
        * @return void
        */
      public  void currentDataUsageAtlasDashboardData()
      {         
         getCurrentDataUsageDashBoradData();
          
      }
      /**
        * @author Raghuprasad Halakere 
        * @description - calls getMyAccountDashBoardData method for paymentsettings
        * @param object null
        * @return void
        */
      public  void myAccountAtlasDashboardData()
      {
          getMyAccountDashBoardData();
          
      }  
      /**
        * @author Raghuprasad Halakere 
        * @description - calls getBillingSnapShotDashBoardDAta method for paymentsettings
        * @param object null
        * @return void
        */
      public  void billingSnapshotAtlasDashboardData()
      {
          getBillingSnapShotDashBoardDAta();
          
      }
      /**
        * @author Raghuprasad Halakere 
        * @description - calls getCurrentPaymentSettingsBillPage method for paymentsettings
        * @param object null
        * @return void
        */
      public  void currentPaymentSettingsCurrentBillPage()
      {
          getCurrentPaymentSettingsBillPage();
          
      }
      /**
        * @author Raghuprasad Halakere 
        * @description - processEncryptedResult for paymentsettings
        * @param object null
        * @return null
        */
        public pageReference processEncryptedResult()
        {
            return null;
        }
        public string encryptedCreditCard{get;set;}
        public string encryptedBankAccount{get;set;}
        public string encryptedRoutingNumber{get;set;}
        public String encryptionKey{get;set;}
        
        /*** End of Encryption Section ****/
      /**
        * @author Raghuprasad Halakere 
        * @description - getPaymentAccountTypes for paymentsettings
        * @param object null
        * @return - List of Payment Accout Types
        */        
        public List<SelectOption> getPaymentAccountTypes(){
                List<SelectOption> options=new List<SelectOption>();
                options.add(new SelectOption('update--cc','Credit Card'));
                options.add(new SelectOption('update-check','Bank Account'));
                return options;
        }
      /**
        * @author Raghuprasad Halakere 
        * @description - getCreditCardTypes for paymentsettings
        * @param object null
        * @return - List of Credit Card Types
        */       
        public List<SelectOption> getCreditCardTypes() {
                List<SelectOption> options=new List<SelectOption>();
                options.add(new SelectOption('AMERICAN_EXPRESS','AMEX'));                
                options.add(new SelectOption('MASTERCARD','MC'));
                options.add(new SelectOption('VISA','VISA'));
                return options;
        } 
      /**
        * @author Raghuprasad Halakere 
        * @description - getcreditCardMonths for paymentsettings
        * @param object null
        * @return - List of Months
        */              
        public List<SelectOption> getcreditCardMonths(){
                List<SelectOption> options=new List<SelectOption>();
                options.add(new SelectOption('none','Month'));
                options.add(new SelectOption('01','Jan - 01'));
                options.add(new SelectOption('02','Feb - 02'));
                options.add(new SelectOption('03','Mar - 03'));
                options.add(new SelectOption('04','Apr - 04'));
                options.add(new SelectOption('05','May - 05'));
                options.add(new SelectOption('06','Jun - 06'));
                options.add(new SelectOption('07','Jul - 07'));
                options.add(new SelectOption('08','Aug - 08'));
                options.add(new SelectOption('09','Sep - 09'));
                options.add(new SelectOption('10','Oct - 10'));
                options.add(new SelectOption('11','Nov - 11'));
                options.add(new SelectOption('12','Dec - 12'));
                return options;
        }  
      /**
        * @author Raghuprasad Halakere 
        * @description - getCreditCardYears for paymentsettings
        * @param object null
        * @return - List of Years
        */            
        public List<SelectOption> getCreditCardYears(){
                List<SelectOption> options=new List<SelectOption>();
                options.add(new SelectOption('none','Year'));             
                AtlasKeyValueStore__c AtlasKVS = AtlasKeyValueStore__c.getValues('AtlasCreditCardYearOptions');
                String creditCardYears = AtlasKVS.Value__c;
                String[] sArray = creditCardYears.split(',');
                system.debug('---sArray---> '+sArray);
                for(String str:sArray){
                    options.add(new SelectOption(str,str));
                }             
                return options;
        }
      /**
        * @author Raghuprasad Halakere 
        * @description - getbankAccountTypes for paymentsettings
        * @param object null
        * @return - List of AccountTypes
        */         
        public List<SelectOption> getbankAccountTypes(){
                List<SelectOption> options=new List<SelectOption>();
                options.add(new SelectOption('CHECKING','CHECKING'));
                options.add(new SelectOption('SAVINGS','SAVINGS'));
                return options;
        }
      /**
        * @author Raghuprasad Halakere 
        * @description - displayPaymentSettings for paymentsettings
        * @param object null
        * @return void
        */        
        public void displayPaymentSettings()
        {
                displayPaymentSettings=true;  //Sets the edit payment settings display to true
                updatePaymentAcccountType='update--cc'; //Sets the payment method type to Credit Card by default
                enablePaymentSettingsSubmit=false;    // Hide's the payment settings submit button
                isSaveEnable=true;
                successMessage = null;
        }
      /**
        * @author Raghuprasad Halakere 
        * @description - nullifies errorMessage on change of paymentType
        * @param object null
        * @return void
        */  
        public PageReference changePaymentType1()
        {
            clearAllPaymentSettingsfields();
            errorMessage = '';
            return null;
        }
      /**
        * @author Raghuprasad Halakere 
        * @description - reviewpaymentmethod for paymentsettings
        * @param object null
        * @return void
        */          
        public Pagereference reviewpaymentmethod()
        {
                /** Billing Address updation has been removed from the associated VF page 'paymentsettings'
                if (handleExceptionsBillingAddress(billingAddress1,billingAddress2,billingCity,billingState,billingZip) == 'false')
                {
                        return null;                
                }**/
                system.debug('---Credit Card Type--->'+creditCardType);
                if (updatePaymentAcccountType=='update--cc' && handleExceptionsCreditCard(accountHolderName,creditCardNumber,creditCardYear,creditCardMonth,creditCardType,CreditCardZipCode,creditCardCVV) == 'false')            
                return null;  
                else if(updatePaymentAcccountType=='update-check' && handleExceptionsAccount(accountHolderName,bankAccountNumber,bankAccountRoutingNumber,bankAccountType) == 'false')
                return null;       
                else 
                {       /** Billing Address updation has been removed from the associated VF page 'paymentsettings' //
                        if (validateBillingAddress() == 'NOT FOUND' || validateBillingAddress() == 'Exception')
                        {
                                errorMessage = 'You have entered a Invalid Billing Address';
                                return null;
                        } **/
                        String lastFourDigits;
                        String lastFiveDigits;
                        if(updatePaymentAcccountType == 'update--cc')
                        {
                                creditCardNumber = this.creditCardNumber.trim();
                                lastFourDigits = creditCardNumber.substring(creditCardNumber.length() - 4);                                
                                maskedCreditCardNumber = 'XXXX-XXXX-XXXX-'+lastFourDigits;
                                lastFiveDigits = creditCardNumber.substring(creditCardNumber.length() - 5); 
                                if (creditCardType == AtlasConstants.AMEX_LABEL){ maskedCreditCardCVV = 'XXXX'; maskedCreditCardNumber = 'XXXX-XXXXXX-'+lastFiveDigits;}else maskedCreditCardCVV = 'XXX';
                                if(creditCardType == AtlasConstants.VISA_CARD_LABEL && creditCardNumber.length()== 13){ maskedCreditCardNumber = 'X-XXXX-XXXX-' + lastFourDigits;}
                        } 
                        else if(updatePaymentAcccountType == 'update-check')
                        {   
                                bankAccountNumber = this.bankAccountNumber.trim();
                                lastFourDigits = bankAccountNumber.substring(bankAccountNumber.length() - 4);
                                Integer bankAccountNumberLength = bankAccountNumber.length()-4;                               
                                string maskedValue = '';                               
                                for(integer i=0; i < bankAccountNumberLength; i++)
                                {
                                    maskedValue += 'x';
                                }
                                maskedbankAccountNumber = maskedValue + lastFourDigits;
                                bankAccountRoutingNumber = this.bankAccountRoutingNumber.trim();
                                lastFourDigits = bankAccountRoutingNumber.substring(bankAccountRoutingNumber.length() - 4);
                                maskedbankAccountRoutingNumber = 'XXXXX'+lastFourDigits;
                        }    
                        enablePaymentSettingsSubmit  = true;    // Enable the payment settings submit button
                        return null;
                }    
        }
      /**
        * @author Raghuprasad Halakere 
        * @description - calls clearAllPaymentSettingsfields method and clears the errorMessage in paymentsettings page
        * @param object null
        * @return void
        */        
        public void cancelPaymentMethod()
        {
                clearAllPaymentSettingsfields();
                displayPaymentSettings = false;
                //isSaveEnable=true;
                errorMessage = '';
        }
      /**
        * @author Raghuprasad Halakere 
        * @description - updatepaymentmethod for paymentsettings
        * @param object null
        * @return void
        */         
        public Pagereference updatepaymentmethod()
        {       /** Billing Address updation has been removed from the associated VF page 'paymentsettings' 
                if(finalValidatedAddress != NULL)
                updateBillingAddress(finalValidatedAddress);
                else
                {
                        errorMessage = 'Please select a Address from the list';
                        return null;    
                }*/
                AtlasFinServiceXmlschemaV4FinanceService.PaymentMethodDetails paymentMethod = new AtlasFinServiceXmlschemaV4FinanceService.PaymentMethodDetails();
                AtlasFinServiceXmlschemaV4FinanceService.EFTDetails eft = new AtlasFinServiceXmlschemaV4FinanceService.EFTDetails();
                AtlasFinServiceXmlschemaV4FinanceService.CreditCardDetails creditCard = new AtlasFinServiceXmlschemaV4FinanceService.CreditCardDetails();
                /* Dashes in the Account Holder Name are discarded - Defect fix : Atlas 214 */
                if(!AtlasUtility.IsEmpty(accountHolderName ))
                {
                    if(accountHolderName.contains('-'))
                    {
                        accountHolderName=accountHolderName.replaceAll('-',' ');
                    }
                }    
                if (updatePaymentAcccountType == 'update--cc')
                {                
                        if (handleExceptionsCreditCard(accountHolderName,creditCardNumber,creditCardYear,creditCardMonth,creditCardType,CreditCardZipCode,creditCardCVV) == 'false' && AtlasCreditCardValidation.isValid(creditCardType,creditCardNumber) == true)
                        return null;
                        else
                        {    
                                creditCard.accountHolder = accountHolderName;
                                creditCard.cardNumber = encryptedCreditCard;
                                Integer daysInMonth = date.daysInMonth(Integer.valueOf(creditCardYear),Integer.valueOf(creditCardMonth));
                                DateTime expirationDate = Datetime.newInstanceGmt(Integer.valueOf(creditCardYear),Integer.valueOf(creditCardMonth),daysInMonth );
                                creditCard.expirationDate = expirationDate;
                                creditCard.methodOfPayment = creditCardType;
                                creditCard.zipCode = CreditCardZipCode;
                                creditCard.CVV = creditCardCVV;
                                paymentMethod.eft = null;
                                paymentMethod.creditCard = creditCard;
                                
                                // Call the webservice
                                try{                        
                                        AtlasTransactionDTO.updatedPaymentMethodDTO paymentMethodObj = new AtlasTransactionDTO.updatedPaymentMethodDTO(mainDTOObj.externalAccountReference,mainDTOObj.externalSystemName,null,paymentMethod);
                                        String paymentUpdateResponse;
                                        if (!Test.isRunningTest())
                                            paymentUpdateResponse = updatePaymentMethod(paymentMethodObj);
                                        else
                                            paymentUpdateResponse='success';                
                                        //String paymentUpdateResponse = AtlasIntegrationUtility.updateCurrentPaymentSetting(mainDTOObj.externalSystemName,mainDTOObj.externalAccountReference,paymentMethod);
                                       if (paymentUpdateResponse == 'success')
                                        {
                                                /* To Update Credit card details immediately. @ Tejesh Mandapati */                                               
                                                AtlasCurrentPaymentMethodDTO currentPaymentMethodDTOObj=new AtlasCurrentPaymentMethodDTO();
                                                currentPaymentMethodDTOObj.paymentMethodType=creditCardType;
                                                AtlasFinServiceXmlschemaV4FinanceService.CreditCardSummary creditCardDetails= new  AtlasFinServiceXmlschemaV4FinanceService.CreditCardSummary();
                                                creditCardDetails.lastFourDigits=creditCardNumber.substring(creditCardNumber.length() - 4);
                                                creditCardDetails.expirationDate=expirationDate;
                                                creditCardDetails.zipCode=CreditCardZipCode;
                                                creditCardDetails.methodOfPayment=creditCardType;
                                                AtlasCurrentPaymentMethodDTO.paymentCreditCard tempCreditCard=new AtlasCurrentPaymentMethodDTO.paymentCreditCard(creditCardDetails.lastFourDigits,creditCardDetails.expirationDate,creditCardDetails.zipCode,creditCardDetails.methodOfPayment);
                                                currentPaymentMethodDTOObj.paymentCreditCardDetails=tempCreditCard;
                                                mainDTOObj.currentPaymentMethodDTOObj = currentPaymentMethodDTOObj; 
                                                persistViewState();
                                                displayPaymentSettings=false;
                                                system.debug('mainDTOObj.currentPaymentMethodDTOObj____'+json.serializepretty(mainDTOObj.currentPaymentMethodDTOObj));                                               
                                                //refreshPage = true;
                                                successMessage = AtlasKeyValueStore__c.getInstance(AtlasConstants.PMU_SuccessMessageCode).Value__c;
                                                errorMessage = '';
                                                clearAllPaymentSettingsfields();
                                                refreshCurrentPayment();
                                                return null;
                                        }
                                      /*  //---Commenting as per Carrie comments, Credit Card errors are not yet fixed.. so displaying our regular error message
                                      else if (!AtlasUtility.isEmpty(paymentUpdateResponse))
                                        { 
                                                //errorMessage = AtlasKeyValueStore__c.getInstance(AtlasConstants.PMU_UpdateCreditCard_FailureMessageCode).Value__c;
                                                errorMessage = paymentUpdateResponse;
                                                isSaveEnable=false;  
                                                clearAllPaymentSettingsfields();                      
                                                return null;
                                        }  
                                        */
                                        else 
                                        {
                                                errorMessage = AtlasKeyValueStore__c.getInstance(AtlasConstants.PMU_UpdateCreditCard_FailureMessageCode).Value__c;
                                                successMessage = '';
                                                isSaveEnable=false;  
                                                clearAllPaymentSettingsfields();                      
                                                return null;
                                        }                         
                                }
                                catch (Exception e)
                                {    
                                        errorMessage = AtlasKeyValueStore__c.getInstance(AtlasConstants.PMU_UpdateCreditCard_FailureMessageCode).Value__c;
                                        successMessage = ''; 
                                        isSaveEnable=false;
                                        clearAllPaymentSettingsfields();                      
                                        return null;
                                } 
                        } 
                        return null;   
                }
                if (updatePaymentAcccountType == 'update-check')
                {               
                        if (handleExceptionsAccount(accountHolderName,bankAccountNumber,bankAccountRoutingNumber,bankAccountType) == 'false')
                        return null;
                        else
                        {    
                                eft.accountHolder = accountHolderName;
                                eft.bankAccountNumber = encryptedBankAccount;
                                eft.bankCode = bankAccountRoutingNumber;
                                eft.paymentType = bankAccountType;
                                paymentMethod.creditCard = null;
                                paymentMethod.eft = eft;
                                // Call the webservice
                                try{
                                        
                                        system.debug('---enter bank details--->');
                                        AtlasTransactionDTO.updatedPaymentMethodDTO paymentMethodObj = new AtlasTransactionDTO.updatedPaymentMethodDTO(mainDTOObj.externalAccountReference,mainDTOObj.externalSystemName,null,paymentMethod);
                                        String paymentUpdateResponse;
                                        if (!Test.isRunningTest())
                                            paymentUpdateResponse = updatePaymentMethod(paymentMethodObj);
                                        else
                                            paymentUpdateResponse='success';
                                        system.debug('---paymentUpdateResponse --->' + paymentUpdateResponse);
                                        //String paymentUpdateResponse = AtlasIntegrationUtility.updateCurrentPaymentSetting(mainDTOObj.externalSystemName,mainDTOObj.externalAccountReference,paymentMethod);
                                        if(paymentUpdateResponse == 'success')
                                        {
                                                /*  To Update Bank Account details immediately. @ Tejesh Mandapati */                                               
                                                AtlasCurrentPaymentMethodDTO currentPaymentMethodDTOObj=new AtlasCurrentPaymentMethodDTO();
                                                currentPaymentMethodDTOObj.paymentMethodType=bankAccountType;
                                                AtlasFinServiceXmlschemaV4FinanceService.EFTSummary eftAccountDetails= new AtlasFinServiceXmlschemaV4FinanceService.EFTSummary();
                                                eftAccountDetails.accountHolder = accountHolderName;
                                                eftAccountDetails.lastFourDigits = bankAccountNumber.substring(bankAccountNumber.length() - 4);
                                                eftAccountDetails.bankCode = bankAccountRoutingNumber;
                                                eftAccountDetails.paymentType = bankAccountType;
                                                AtlasCurrentPaymentMethodDTO.paymentBankAccount tempBankAccount=new AtlasCurrentPaymentMethodDTO.paymentBankAccount(eftAccountDetails.accountHolder,eftAccountDetails.lastFourDigits,eftAccountDetails.bankCode,eftAccountDetails.paymentType);
                                                currentPaymentMethodDTOObj.paymentBankDetails=tempBankAccount;
                                                mainDTOObj.currentPaymentMethodDTOObj = currentPaymentMethodDTOObj; 
                                                persistViewState();
                                                displayPaymentSettings=false;
                                                system.debug('mainDTOObj.currentPaymentMethodDTOObj____'+json.serializepretty(mainDTOObj.currentPaymentMethodDTOObj)); 
                                                //refreshPage = true;
                                                errorMessage = '';
                                                successMessage = AtlasKeyValueStore__c.getInstance(AtlasConstants.PMU_SuccessMessageCode).Value__c;
                                                clearAllPaymentSettingsfields();
                                                refreshCurrentPayment();
                                                return null;
                                        }   
                                        else if (!AtlasUtility.isEmpty(paymentUpdateResponse) && paymentUpdateResponse != 'success')
                                        {
                                                //errorMessage = AtlasKeyValueStore__c.getInstance(AtlasConstants.PMU_UpdateBankAcc_FailureMessageCode).Value__c;
                                                errorMessage = paymentUpdateResponse;
                                                successMessage = '';
                                                isSaveEnable=false; 
                                                clearAllPaymentSettingsfields();                      
                                                return null;
                                        } 
                                        else 
                                        {
                                                errorMessage = AtlasKeyValueStore__c.getInstance(AtlasConstants.PMU_UpdateBankAcc_FailureMessageCode).Value__c;
                                                successMessage = '';
                                                isSaveEnable=false; 
                                                clearAllPaymentSettingsfields();                      
                                                return null;
                                        }    
                                }
                                catch (Exception e)
                                {    
                                        errorMessage = AtlasKeyValueStore__c.getInstance(AtlasConstants.PMU_UpdateBankAcc_FailureMessageCode).Value__c;
                                        successMessage = '';
                                        isSaveEnable=false;
                                        clearAllPaymentSettingsfields();
                                        return null;
                                }
                                return null; 
                        }   
                }
                return null;
        }
      /**
        * @author Raghuprasad Halakere 
        * @description - handleExceptionsCreditCard for paymentsettings
        * @param -  accountHolderName, creditCardNumber, creditCardYear, creditCardMonth, creditCardType, CreditCardZipCode, creditCardCVV
        * @return - String
        */            
        Public String handleExceptionsCreditCard(String accountHolderName,String creditCardNumber,String creditCardYear,String creditCardMonth,String creditCardType,String CreditCardZipCode,String creditCardCVV)
        {
                accountHolderName = this.accountHolderName.trim(); 
                creditCardNumber = this.creditCardNumber.trim();CreditCardZipCode = this.CreditCardZipCode.trim();creditCardCVV = this.creditCardCVV.trim();
                Pattern isnumbers = Pattern.Compile('^[a-zA-Z ]+(-[a-zA-Z]+)*$'); 
                Matcher accountNameMatcher = isnumbers.matcher(accountHolderName);
                Integer CurrentMonth = Date.Today().Month();
                Integer CurrentYear = Date.Today().Year();
                if (accountHolderName == '' || creditCardNumber == '' || creditCardYear == 'none' || creditCardMonth == 'none' || creditCardType == '' || CreditCardZipCode == '' || creditCardCVV == '')
                {
                        errorMessage = AtlasKeyValueStore__c.getInstance(AtlasConstants.CC_Validation_AllFieldsRequiredCode).Value__c;
                        //this.creditCardNumber = '';
                        //this.creditCardCVV = '';
                        return 'false';                   
                }
                else if(!accountNameMatcher.Matches()) { errorMessage = AtlasKeyValueStore__c.getInstance(AtlasConstants.CC_Validation_InvalidNameCode).Value__c; return 'false';}
                else if(!creditCardNumber.isNumeric() || !CreditCardZipCode.isNumeric() || !creditCardCVV.isNumeric()) {  errorMessage = AtlasKeyValueStore__c.getInstance(AtlasConstants.CC_Validation_InvalidNumbersCode).Value__c; return 'false'; }
                else if((CreditCardType == 'MASTERCARD' || CreditCardType == 'VISA') && creditCardCVV.length() != 3) { errorMessage = AtlasKeyValueStore__c.getInstance(AtlasConstants.CC_Validation_CVV3DigitsCode).Value__c; return 'false';}
                else if((CreditCardType == 'AMERICAN_EXPRESS') && creditCardCVV.length() != 4) { errorMessage = AtlasKeyValueStore__c.getInstance(AtlasConstants.CC_Validation_CVV4DigitsCode).Value__c; return 'false';}
                else if(CreditCardZipCode.length() < 5) {errorMessage = AtlasKeyValueStore__c.getInstance(AtlasConstants.CC_Validation_ZIPCODE5DigitsCode).Value__c; return 'false';}
                else if((Integer.valueOf(creditCardMonth) < CurrentMonth) &&  (Integer.valueOf(creditCardYear) == CurrentYear)) {errorMessage = AtlasKeyValueStore__c.getInstance(AtlasConstants.CC_Validation_InvalidExpiryCode).Value__c; return 'false';}
                else if(AtlasCreditCardValidation.isValid(creditCardType,creditCardNumber) == false)
                {
                    errorMessage = AtlasKeyValueStore__c.getInstance(AtlasConstants.CC_Validation_InvalidCardCode).Value__c;
                    return 'false';
                }
                else
                {
                        errorMessage = '';
                        return 'true'; 
                }                   
        }
      /**
        * @author Raghuprasad Halakere 
        * @description - handleExceptionsAccount for paymentsettings
        * @param - accountHolderName , bankAccountNumber , bankAccountRoutingNumber , bankAccountType
        * @return String
        */         
        Public String handleExceptionsAccount(String accountHolderName,String bankAccountNumber,String bankAccountRoutingNumber,String bankAccountType)
        {
                accountHolderName = this.accountHolderName.trim();bankAccountNumber = this.bankAccountNumber.trim();bankAccountRoutingNumber = this.bankAccountRoutingNumber.trim();
                Pattern isnumbers = Pattern.Compile('^[a-zA-Z ]+(-[a-zA-Z]+)*$');
                Matcher accountNameMatcher = isnumbers.matcher(accountHolderName);
                if (accountHolderName == '' || bankAccountNumber == '' || bankAccountRoutingNumber == '' || bankAccountType == '' || bankAccountType == null)
                {
                        errorMessage = AtlasKeyValueStore__c.getInstance(AtlasConstants.Bank_Validation_AllFieldsRequiredCode).Value__c;
                        //this.bankAccountNumber = '';
                        //this.bankAccountRoutingNumber = '';
                        return 'false';                   
                }
                else if(bankAccountNumber.length() < 4 || bankAccountNumber.length() > 17) { errorMessage = AtlasKeyValueStore__c.getInstance(AtlasConstants.Bank_Validation_AccountNumber).Value__c; return 'false'; }
                else if(bankAccountRoutingNumber.length() < 9) { errorMessage = AtlasKeyValueStore__c.getInstance(AtlasConstants.Bank_Validation_RoutingCode).Value__c; return 'false'; }
                else if(!bankAccountRoutingNumber.isNumeric() || !bankAccountNumber.isNumeric()) {  errorMessage = AtlasKeyValueStore__c.getInstance(AtlasConstants.Bank_Validation_InvalidAccountCode).Value__c; return 'false'; }
                else if(!accountNameMatcher.Matches()) { errorMessage = AtlasKeyValueStore__c.getInstance(AtlasConstants.Bank_Validation_InvalidNameCode).Value__c; return 'false';}
                {
                        errorMessage = '';
                        return 'true'; 
                }                   
        }
      /**
        * @author Raghuprasad Halakere 
        * @description - clearAllPaymentSettingsfields for paymentsettings
        * @param Object null
        * @return void
        */           
        Public void clearAllPaymentSettingsfields()
        {
                this.accountHolderName = null;
                this.creditCardNumber = null;
                this.maskedCreditCardNumber = null;
                this.creditCardYear = null;
                this.creditCardMonth = null;
                this.creditCardType = null;
                this.CreditCardZipCode = null;
                this.creditCardCVV = null;
                this.bankAccountNumber = null;
                this.maskedBankAccountNumber = null;
                this.bankAccountRoutingNumber = null;
                this.maskedBankAccountRoutingNumber = null;
                this.bankAccountType = null;
                CvvSize=4;
                cardNumberSize=16;
                /** Billing Address updation has been removed from the associated VF page 'paymentsettings'//
                this.billingAddress1 = null;
                this.billingAddress2 = null;
                this.billingState = null;
                this.billingCity = null;
                this.billingZip = null;*/
        }
        
        /**
        * @author shiva shankar 
        * @description - check CVVSizeforPayment for AtlasOneTimePaymentController
        * @input param  - null
        * @return null
        */
        public pagereference CVVSizeforPayment()
        {
        	//clearPaymentSettingsfieldsONChangeOfCardType();
        	errorMessage = null;
            creditCardType = Apexpages.currentPage().getParameters().get('cctype');
            return null;
        }
        /**
        * @author Srikanth Kudumula
        * @description - ClearCVV for paymentsettings
        * @param Object null
        * @return void
        */           
        Public void clearCVV()
        {
            this.creditCardCVV = null;
                               
        }
        /**
        * @author Raghuprasad Halakere 
        * @description - clearPaymentSettingsfieldsONChangeOfCardType for paymentsettings
        * @param Object null
        * @return void
        */           
        Public void clearPaymentSettingsfieldsONChangeOfCardType()
        {
            this.accountHolderName = null;
            this.creditCardNumber = null;
            this.maskedCreditCardNumber = null;
            this.creditCardYear = null;
            this.creditCardMonth = null;
            this.CreditCardZipCode = null;
            this.creditCardCVV = null;
                               
        }
        /**
        AtlasPaymentSettingsController
        Method to Validate the Billing Address
        */        
        /** Billing Address updation has been removed from the associated VF page 'paymentsettings' //
        Public string validateBillingAddress()
        {            
                try{
                        AtlasPubContactServXmlschemaCommonData.Address billingAddress = new AtlasPubContactServXmlschemaCommonData.Address();
                        billingAddress.countryCode = 'USA';
                        billingAddress.postalCode = billingZip;
                        billingAddress.region = billingState;
                        billingAddress.municipality = billingCity;
                        String[] billingAddressList = new String[]{};
                        billingAddressList.add(billingAddress1);
                        billingAddress.addressLine = billingAddressList;
                        AtlasPubContactServWsdlV1.PublicContactServiceEndpoint billingAddressUpdateStub = new AtlasPubContactServWsdlV1.PublicContactServiceEndpoint();
                        billingAddressUpdateStub.endpoint_x = 'https://webservices.test.wildblue.net//PublicContact/v1/services/PublicContactService';  
                        billingAddressUpdateStub.timeout_x= 10000;
                        AtlasPubContactServXmlschema.AddressAndTaxJurisdictions[] resultStub = billingAddressUpdateStub.findAddressAndTaxJurisdictions(billingAddress);
                        if (resultStub != null)
                        {
                                if (resultStub.size() > 1 )
                                {
                                        multipleAddressesFound = true;
                                        allAddressMatchedFound = resultStub;
                                        
                                        for (Integer i=0; i < resultStub.size() ; i++)
                                        {
                                                String tempAddress = '';
                                                for(String s: resultStub[i].address.addressLine)
                                                tempAddress = tempAddress + s;
                                                String tempJurisdictioncode = '';  
                                                for(String s: resultStub[i].taxJurisdictionCode)
                                                tempJurisdictioncode = tempJurisdictioncode + s;  
                                                allDuplicateAddresses.add(new duplicateAddress(i,tempAddress,resultStub[i].address.municipality,resultStub[i].address.region,tempJurisdictioncode));
                                        }    
                                }
                                else
                                {
                                        multipleAddressesFound = false; 
                                        finalValidatedAddress = resultStub[0]; 
                                }      
                                return 'SUCCESS';
                        }
                        else
                        {
                                errorMessage = 'Not a Valid Billing Address';
                                return 'NOT FOUND'; 
                        }       
                }   
                catch (Exception e)
                {
                        return 'EXCEPTION'; }         
                
        }

        /**
        AtlasPaymentSettingsController
        Method for updating the billing Address
        */        
        /** Billing Address updation has been removed from the associated VF page 'paymentsettings'
        public String updateBillingAddress(AtlasPubContactServXmlschema.AddressAndTaxJurisdictions validAddressAndTaxBean)
        {
                try{
                        AtlasPubContactServXmlschema.CorrectedContact correctedBillingContact = new AtlasPubContactServXmlschema.CorrectedContact();
                        AtlasPubContactServXmlschemaCommonData.Person person = new AtlasPubContactServXmlschemaCommonData.Person();
                        AtlasPubContactServXmlschema.CorrectedAddress billingAddress = new AtlasPubContactServXmlschema.CorrectedAddress();
                        billingAddress.address = validAddressAndTaxBean.address;
                        billingAddress.address.Countrycode = 'USA';
                        billingAddress.taxJurisdictionCode = validAddressAndTaxBean.taxJurisdictionCode[0];
                        correctedBillingContact.billingAddress = billingAddress;           
                        AtlasPubContactServWsdlV1.PublicContactServiceEndpoint billingAddressUpdateStub = new AtlasPubContactServWsdlV1.PublicContactServiceEndpoint();
                        billingAddressUpdateStub.endpoint_x = 'https://webservices.test.wildblue.net//PublicContact/v1/services/PublicContactService';  
                        //billingAddressUpdateStub.endpoint_x = 'http://requestb.in/11c761g1'; 
                        billingAddressUpdateStub.timeout_x= 10000;
                        String updateResponse = billingAddressUpdateStub.updateContacts(mainDTOObj.externalAccountReference,mainDTOObj.externalSystemName,''+System.now(),correctedBillingContact);                                                            
                        return 'Success';
                }
                catch (Exception e)
                { return 'Success'; }    
        }

        /**
        AtlasPaymentSettingsController
        Method for selecting a specific address from the validated list
        */          
        /** Billing Address updation has been removed from the associated VF page 'paymentsettings'
        Public void selectAddress()
        {
                if (finalValidatedAddress == null){                
                    finalValidatedAddress = allAddressMatchedFound[Integer.valueOf(apexpages.currentpage().getparameters().get('addressindex'))];
                    if(finalValidatedAddress.address.addressLine != null && finalValidatedAddress.address.addressLine.size() > 0)
                        this.billingAddress1 = finalValidatedAddress.address.addressLine[0];
                    if(finalValidatedAddress.address.addressLine != null && finalValidatedAddress.address.addressLine.size() > 1) 
                        this.billingAddress2 = finalValidatedAddress.address.addressLine[1]; 
                    else
                        this.billingAddress2 = '';
                    this.billingState  = finalValidatedAddress.address.region;
                    this.billingCity = finalValidatedAddress.address.municipality;
                    this.billingZip = finalValidatedAddress.address.postalCode;
                }        
        }
        /**
        AtlasPaymentSettingsController
        Method for handling Billing Address exceptions
        */
        /** Billing Address updation has been removed from the associated VF page 'paymentsettings' //      
        Public String handleExceptionsBillingAddress(String billingAddress1,String billingAddress2,String billingCity,String billingState,String billingZip)
        {
                if (billingAddress1 == '' && billingAddress2 == '')
                {
                        errorMessage = 'Billing Address is required';
                        return 'false';                   
                }
                else if (billingCity == '' || billingState == '' || billingZip == '')
                {
                        errorMessage = 'Billing City, State and Zip are required';
                        return 'false';
                }    
                else
                {
                        errorMessage = '';
                        return 'true'; 
                }               
        }
        /**
        AtlasPaymentSettingsController
        Method to get list of Billing States
        */       
        /** Billing Address updation has been removed from the associated VF page 'paymentsettings' //  
        public List<SelectOption> getBillingStates() {
                List<SelectOption> options = new List<SelectOption>();
                List<AtlasBillingStatesList__c> bStates = AtlasBillingStatesList__c.getall().values();
                bStates.sort();
                for (AtlasBillingStatesList__c bState: bStates)
                options.add(new SelectOption(bState.StateAbbreviatedCode__c,bState.StateAbbreviatedCode__c));
                return options;
        }**/
   
}