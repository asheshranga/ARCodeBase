/*********************************************************************************
Name         : AtlasOneTimePaymentController 
Created By   : Shiva Shankar N 
Modified BY  : Shiva Shankar N 
Company Name : NTT Data
Project      : ViaSat Atlas, Bangalore
Created Date : 18 October2013
Modified Date: 13 November 2013
Usages       : Controller for VisualForce Component : AtlasBillPaymentOneTimePayment
*********************************************************************************/
public with sharing class AtlasOneTimePaymentController extends AtlasPaymentSettingsController {
    
    // Variables used in AtlasBillPaymentOneTimePayment Component 
    public AtlasMainDTO dummyPaymentMainDTOObj {get; set;}
    public AtlasMainDTO paymentMainDTOObj {get; set;}
    public string strPaymentType {get;set;}    
    public boolean isvisibleCreditcard{get;set;}
    public string StrCity{get;set;}
    public string strUpdateState{get;set;}
    public string StrNameOnCard{get;set;}
    public string strCardNumber{get;set;}
    public string StrBillingAddress1{get;set;}
    public string strBillingAddress2{get;set;}
    public string StrMonth{get;set;}
    public string strYear{get;set;}
    public string StrCcv{get;set;}
    public string StrNameOfAccount{get;set;}
    public string StrAcount{get;set;}
    public string StrRouting{get;set;}
    public boolean inputCheckBbox{get;set;}
    public date dtSetAutoPayment{get;set;}
    public string strAutoPaymentdate{get;set;}    
    public double amountValue{get;set;}
    public String amountValuePayment{get;set;}
    public String paymentMethodType{get;set;}
    public String oneTimesuccessMessage{get;set;}
    public String AmountdueText{get{return AtlasConstants.AmountdueText;} set;}
    public String NoPaymentNeededLabel{get{return AtlasUtility.getMapValue(AtlasConstants.NoPaymentNeededLabel);}set;}
    public String AccounttochargeLabel{get{return AtlasConstants.AccounttochargeLabel;}set;}
    public String AmountTochargeLabel{get{return AtlasConstants.AmountTochargeLabel;}set;}
    public String ProcessingLabel{get{return AtlasConstants.ProcessingLabel;}set;}
    public String CardTypeLabel{get{return AtlasConstants.CardTypeLabel;}set;}
    public String ExpirationLabel{get{return AtlasConstants.ExpirationLabel;}set;} 
    public String NameOnAccountLabel{get{return AtlasConstants.NameOnAccountLabel;}set;} 
    public String creditCardNameLabel{get{return AtlasConstants.creditCardNameLabel;}set;}     
    public String accountRoutingNumberLabel{get{return AtlasConstants.accountRoutingNumberLabel;}set;}
    public String accountACNumberLabel{get{return AtlasConstants.accountACNumberLabel;}set;}
    public String creditCardNumberLabel{get{return AtlasConstants.creditCardNumberLabel;}set;}
    public String creditCardCVVLabel{get{return AtlasConstants.creditCardCVVLabel;}set;}
    public String creditCardZipLabel{get{return AtlasConstants.creditCardZipLabel;}set;}
    public string oneTimePaymentNote{get{return AtlasUtility.getMapValue(AtlasConstants.ONETIME_PAYMENT_NOTE);}set;}
    public string oneTimepaymentAmountCharge{get{return AtlasUtility.getMapValue(AtlasConstants.ONETIME_PAYMENT_CHARGE);}set;}
    public Boolean showDisclaimerText{get{if(AtlasUtility.getMapValue(AtlasConstants.SHOW_DISCLAIMER_2).equalsIgnoreCase('false')) {return false;} else {return true;}}set;}
    public string noteLabel{get{return AtlasConstants.NOTE;}set;}
    public string achDisclaimer1{get{return AtlasUtility.getMapValue(AtlasConstants.AtlasAchOTPDisclaimer);}set;}
    public string achDisclaimer2{get{return AtlasUtility.getMapValue(AtlasConstants.AtlasAchDisclaimer2);}set;}
    public string invalidCVVMsg{get{return AtlasUtility.getMapValue(AtlasConstants.Invalid_CVV);}set;}
    public string invalidCCMsg{get{return AtlasUtility.getMapValue(AtlasConstants.Invalid_CC);}set;}
    /*** Encryption section ****/
    public pageReference dummyProcessEncryptedResult()
    {
        return null;
    }
    public string oneTimeencryptedCreditCard{get;set;}
    public string oneTimeencryptedBankAccount{get;set;}
    public string oneTimeencryptedRoutingNumber{get;set;}
    public String oneTimeencryptionKey{get;set;}
    
    //public string oneTimeencryptedCCard{get;set;}
    public string oneTimeencryptedBAccount{get;set;}
    public string oneTimeencryptedRoutNumber{get;set;}
    public String oneTimeencryptedCCard {get; set;}
    public integer CvvSize{get;set;}
    public integer cardNumberSize{get;set;}
    /*** End of Encryption Section ****/
    /**
    * @author Raghuprasad Halakere 
    * @description - Zero parameter AtlasOneTimePaymentController constructor
    * @input param  - null
    * @return null
    */ 
    public AtlasOneTimePaymentController()
    {
       isvisibleCreditcard=true; 
       oneTimeencryptionKey=AtlasUtility.getHyperlinkText(AtlasConstants.EncryptionKey);   
       oneTimesuccessMessage='';
       CvvSize=4;
       cardNumberSize=16;
       if(amountValue!=null)
         amountValuePayment=String.valueOf(amountValue);        
       if (amountValue < 0.00 ||amountValue==0.00)
             amountValuePayment = '0.00';  
       if(dummyPaymentMainDTOObj != null)
             paymentMainDTOObj = dummyPaymentMainDTOObj;                
    }
    /**
    * @author Raghuprasad Halakere 
    * @description - getdummyfunction for AtlasOneTimePaymentController
    * @input param  - null
    * @return null
    */
    public String getdummyfunction()
    {
         if(amountValue!=null){
                String s1 = String.valueOf(amountValue);
                String s11 = s1.substringBeforeLast('.');
                String s2 =  s1.substringAfterLast('.');
                if(s2.length() == 1)
                amountValuePayment = s11+'.'+s2+'0';                
                else if (s2.length() == 2)
                amountValuePayment=String.valueOf(amountValue);
         }      

         if (amountValue < 0.00||amountValue==0.00){
             amountValuePayment = '0.00';
         }
         if(dummyPaymentMainDTOObj != null)
             paymentMainDTOObj = dummyPaymentMainDTOObj;    
         return null;
    }
    /**
    * @author Raghuprasad Halakere 
    * @description - save for AtlasOneTimePaymentController
    * @input param  - null
    * @return pagereference
    */   
    public PageReference save(){
        try{
        return new pagereference(AtlasConstants.OTP_SAVE_PR); 
        }
        catch(exception e)
        {
                return null;
        }
    }
    /**
    * @author Raghuprasad Halakere 
    * @description - getPaymentMethodTypes for AtlasOneTimePaymentController
    * @input param  - null
    * @return List of PaymentMethodTypes
    */ 
    public List<SelectOption> getPaymentMethodTypes(){
                List<SelectOption> options = new List<SelectOption>();
                String currentpaytype,currentpaycard;
               if(paymentMainDTOObj==null && dummyPaymentMainDTOObj!=null) paymentMainDTOObj=dummyPaymentMainDTOObj;
                if (paymentMainDTOObj.currentPaymentMethodDTOObj.paymentCreditCardDetails != null){
                	Date dt1 = paymentMainDTOObj.currentPaymentMethodDTOObj.paymentCreditCardDetails.expirationDate.date();
                	Date dt2 = system.today();
                	if(dt1>=dt2){
	                    currentpaytype=paymentMainDTOObj.currentPaymentMethodDTOObj.paymentCreditCardDetails.methodOfPayment;
	                    if(currentpaytype==AtlasConstants.AMEX_LABEL){currentpaytype='AMEX';
	                        currentpaycard='XXXX XXXXXX X'+paymentMainDTOObj.currentPaymentMethodDTOObj.paymentCreditCardDetails.lastFourDigits;
	                    }
	                    else if(currentpaytype==AtlasConstants.MASTER_CARD_LABEL){currentpaytype='MC';
	                    currentpaycard='XXXX XXXX XXXX '+paymentMainDTOObj.currentPaymentMethodDTOObj.paymentCreditCardDetails.lastFourDigits;}
	                    else
	                    currentpaycard='XXXX XXXX XXXX '+paymentMainDTOObj.currentPaymentMethodDTOObj.paymentCreditCardDetails.lastFourDigits;
                	}else{
                		currentpaycard='Current Payment Method Expired';
                    	currentpaytype='';
                	}
                }    
                else if( paymentMainDTOObj.currentPaymentMethodDTOObj.paymentBankDetails != null){
                    currentpaytype=paymentMainDTOObj.currentPaymentMethodDTOObj.paymentBankDetails.paymentType;
                    currentpaycard='XXXXXXXXXXXX '+paymentMainDTOObj.currentPaymentMethodDTOObj.paymentBankDetails.lastFourDigits; }  
                else {
                     currentpaycard='No Existing Payment Method';
                     currentpaytype='';}
                if(currentpaycard == 'Current Payment Method Expired'){
                	options.add(new SelectOption('expired',currentpaytype+' '+currentpaycard));
                }else{        
                	options.add(new SelectOption('existing',currentpaytype+' '+currentpaycard));
                }
                options.add(new SelectOption('new-cc','New Credit Card'));
                options.add(new SelectOption('new-check','New Bank Account'));
                
                return options;
   }
    /**
    * @author Raghuprasad Halakere 
    * @description - validateInput for AtlasOneTimePaymentController
    * @input param  - null
    * @return Pagereference
    */  
    public Pagereference validateInput()
    {
        String lastFourDigits;
        String lastFiveDigits;
        Pattern isnumbers = Pattern.Compile('^([0-9]{1,3})?+(\\.[0-9][0-9][0-9]?)?$');  
        Matcher amountMatcher = isnumbers.matcher(amountValuePayment);  
        if(!amountMatcher.matches()) {errorMessage = AtlasKeyValueStore__c.getInstance(AtlasConstants.ERR_MSG_INVALID_AMOUNT).Value__c; return null;}
        if (amountValuePayment =='' || decimal.valueOf(amountValuePayment) <= 0.00 || decimal.valueOf(amountValuePayment) == null){
            errorMessage = AtlasUtility.getMapValue(AtlasConstants.ERROR_MSG_VALID_IN); return null;}
        else if (PaymentMethodType == 'new-cc')
        { 
            updatePaymentAcccountType = 'update--cc';
            //accountHolderName = this.accountHolderName.trim(); creditCardNumber = this.creditCardNumber.trim();CreditCardZipCode = this.CreditCardZipCode.trim();creditCardCVV = this.creditCardCVV.trim();
            if(handleExceptionsCreditCard(accountHolderName,creditCardNumber,creditCardYear,creditCardMonth,creditCardType,CreditCardZipCode,creditCardCVV) == 'true'){
                enablePaymentSettingsSubmit = true;
                lastFourDigits = creditCardNumber.substring(creditCardNumber.length() - 4);
                lastFiveDigits=creditCardNumber.substring(creditCardNumber.length() - 5);
                maskedCreditCardNumber = 'XXXX-XXXX-XXXX-'+lastFourDigits;
                if(creditCardType == AtlasConstants.AMEX_LABEL){ maskedCreditCardCVV = 'XXXX'; maskedCreditCardNumber = 'XXXX-XXXXXX-'+lastFiveDigits;}else maskedCreditCardCVV = 'XXX';}
                if(creditCardType == AtlasConstants.VISA_CARD_LABEL && creditCardNumber.length()== 13){ maskedCreditCardNumber = 'X-XXXX-XXXX-' + lastFourDigits;}           
        }         
        else if(PaymentMethodType == 'new-check')
        {
            updatePaymentAcccountType = 'update-check';  
            //accountHolderName = this.accountHolderName.trim();bankAccountNumber = this.bankAccountNumber.trim();bankAccountRoutingNumber = this.bankAccountRoutingNumber.trim();
            if(handleExceptionsAccount(accountHolderName,bankAccountNumber,bankAccountRoutingNumber,bankAccountType) == 'true'){
                enablePaymentSettingsSubmit = true;
                lastFourDigits = bankAccountNumber.substring(bankAccountNumber.length() - 4);
                Integer bankAccountNumberLength = bankAccountNumber.length() -4;
                string maskedValue = '';                               
                for(integer i=0; i < bankAccountNumberLength; i++)
                {
                    maskedValue += 'x';
                }
                maskedbankAccountNumber = maskedValue + lastFourDigits;
                lastFourDigits = bankAccountRoutingNumber.substring(bankAccountRoutingNumber.length() - 4);
                maskedbankAccountRoutingNumber = 'XXXXX'+lastFourDigits;}
        }
        else if(PaymentMethodType == 'expired')
        {
        	errorMessage = AtlasUtility.getMapValue(AtlasConstants.ERR_MSG_PMT_MTHD_TYPE_EXPIRED);
        }   
        else if(PaymentMethodType == 'existing')
        {
            if(paymentMainDTOObj.currentPaymentMethodDTOObj.paymentCreditCardDetails == null &&   paymentMainDTOObj.currentPaymentMethodDTOObj.paymentBankDetails == null){
            errorMessage = AtlasUtility.getMapValue(AtlasConstants.ERR_MSG_PMT_MTHD_TYPE);} 
            else { enablePaymentSettingsSubmit = true; errorMessage = '';}
        }     
        return null;
    }
    /**
    * @author Raghuprasad Halakere 
    * @description - Onchange of PaymentType clears all fields for AtlasOneTimePaymentController
    * @input param  - null
    * @return Pagereference
    */  
    public PageReference changePaymentType()
    {
        clearAllPaymentSettingsfields();
        enablePaymentSettingsSubmit = false;
        errorMessage = '';
        CvvSize=4;
        cardNumberSize=16;
        return null;
    }
    
    
    /**
    * @author Raghuprasad Halakere 
    * @description - cancelPayment for AtlasOneTimePaymentController
    * @input param  - null
    * @return Pagereference
    */  
    public PageReference cancelPayment()
    {
        /*commented by shhiva as per ATLAS-218*/
        clearAllPaymentSettingsfields();
        amountValuePayment = '0.00';         
        PaymentMethodType = 'existing';
        enablePaymentSettingsSubmit = false;
        errorMessage = '';
        return null;
    }
    /**
    * @author Raghuprasad Halakere 
    * @description - assignEncryptedValuesCC calls submitPayment method
    * @input param  - null
    * @return Pagereference
    */    
    public pageReference assignEncryptedValuesCC()
    {
        submitPayment();
        return null;
    }
    
  
    /**
    * @author Raghuprasad Halakere 
    * @description - submitPayment for AtlasOneTimePaymentController
    * @input param  - null
    * @return Pagereference
    */   
    public Pagereference submitPayment()
    { 
        system.debug('----------status --------->'+ paymentMainDTOObj.accountDTOObj.provisionStatus);
        if(paymentMainDTOObj.accountDTOObj.provisionStatus=='NON-PAY') //NON-PAY
            submitPaymentForAutoResume();          
        else
            submitPaymentForNonAutoResume(); 
            
        return null;
    }
    /**
    * @author edwin 
    * @description - clear the payment success message
    * @input param  - null
    * @return null
    */
    public void clearSuccessMessage()
    {
        oneTimesuccessMessage = '';
    }
    /**
    * @author shiva shankar 
    * @description - check cvvsize for AtlasOneTimePaymentController
    * @input param  - null
    * @return null
    */
    public pageReference CVVSize()
    {
        errorMessage='';
        creditCardType = Apexpages.currentPage().getParameters().get('cctype');
        return null;
    }
    /* @author Tejesh Kumar 
    * @description - Submit Payment for non suspended accounts
    * @input param  - null
    * @return null
    */
    public void submitPaymentForNonAutoResume()
    {
        AtlasFinServiceXmlschemaV4FinanceService.PaymentMethodDetails paymentMethod = new AtlasFinServiceXmlschemaV4FinanceService.PaymentMethodDetails();
        AtlasFinServiceXmlschemaV4FinanceService.EFTDetails eft = new AtlasFinServiceXmlschemaV4FinanceService.EFTDetails();
        AtlasFinServiceXmlschemaV4FinanceService.CreditCardDetails creditCard = new AtlasFinServiceXmlschemaV4FinanceService.CreditCardDetails();
        String paymentMethodActionType;
        if(paymentMethodType != 'existing')
        {
             /* Dashes in the Account Holder Name are discarded - Defect fix : Atlas 214 */
               if(accountHolderName.contains('-'))
                {
                    accountHolderName=accountHolderName.replaceAll('-',' ');            
                }
            paymentMethodActionType = AtlasUtility.getMapValue(AtlasConstants.NEW_OTP_MTHD_ONLY);
            if(paymentMethodType == 'new-cc'){
                 creditCard.accountHolder = accountHolderName;creditCard.cardNumber = oneTimeencryptedCreditCard;Integer daysInMonth = date.daysInMonth(Integer.valueOf(creditCardYear),Integer.valueOf(creditCardMonth));DateTime expirationDate = Datetime.newInstanceGmt(Integer.valueOf(creditCardYear),Integer.valueOf(creditCardMonth),daysInMonth);
                 creditCard.expirationDate = expirationDate;creditCard.methodOfPayment = creditCardType;creditCard.zipCode = CreditCardZipCode;
                 creditCard.CVV = creditCardCVV;
                    paymentMethod.eft = null;
                    paymentMethod.creditCard = creditCard;}
            else if(paymentMethodType == 'new-check'){
                eft.accountHolder = accountHolderName;                
                eft.bankAccountNumber = oneTimeencryptedBankAccount;
                eft.bankCode = bankAccountRoutingNumber;
                eft.paymentType = bankAccountType;
                paymentMethod.creditCard = null;
                paymentMethod.eft = eft;}
          } 
          else{
              paymentMethodActionType = AtlasConstants.RCUR_PMT_MTHD;             
              paymentMethod = null;
              }
          try{       
            Double amountPayment = decimal.valueOf(amountValuePayment);
            AtlasTransactionDTO.oneTimePaymentDTO oneTimePaymentObj = new AtlasTransactionDTO.oneTimePaymentDTO(paymentMainDTOObj.externalAccountReference,paymentMainDTOObj.externalSystemName,null,paymentMethodActionType,amountPayment,paymentMethod);
            String paymentResponse = submitPaymentTransaction(oneTimePaymentObj);
            system.debug('--------------paymentResponse ---------> '+ paymentResponse );
            if(paymentResponse == 'success')
            {
                oneTimesuccessMessage = AtlasKeyValueStore__c.getInstance(AtlasConstants.OTP_SUCC_MSG).Value__c;
                refreshPage = true;
                errorMessage = '';
                enablePaymentSettingsSubmit = false;
                clearAllPaymentSettingsfields();
                PaymentMethodType = 'existing';
            }    
            else if (!AtlasUtility.isEmpty(paymentResponse) && paymentResponse != 'success' && paymentMethodType == 'new-check') {
                 //---Retrieving ACH error messages from MyExedeACHErrors Custom Object and mapping with the response code
                List<AtlasTransactionErrors__c> ACHmessages= new List<AtlasTransactionErrors__c>();
                Map<String,String> errorMap = new Map<String,String>();
                ACHmessages= [SELECT id,Name,APIMessage__c,MyExedeMessage__c FROM AtlasTransactionErrors__c WHERE Type__c=:'ACH'];
                system.debug('---ACHmessages---> '+ACHmessages);
                if(ACHmessages!=null && ACHmessages.size()>0) {
                    for(AtlasTransactionErrors__c ach:ACHmessages) {
                        errorMap.put(ach.name,ach.MyExedeMessage__c);        
                    }
                }
                
                String ExedeErrMsg = errorMap.get(paymentResponse);
                system.debug('---Exede errMsg ---> '+ ExedeErrMsg);
                if(!AtlasUtility.isEmpty(ExedeErrMsg))
                    errorMessage = ExedeErrMsg;
                else
                    errorMessage = errorMap.get('V01');    
            }
            
            else 
                errorMessage = AtlasKeyValueStore__c.getInstance(AtlasConstants.OTP_General_Exp).Value__c; 
          }
          catch (Exception e) {errorMessage = AtlasKeyValueStore__c.getInstance(AtlasConstants.OTP_General_Exp).Value__c;}
    }
    /**
    * @author Tejesh Kumar 
    * @description - Submit Payment for suspended accounts - Auto Resume
    * @input param  - null
    * @return null
    */
    public void submitPaymentForAutoResume()
    {       
        AtlasFinServiceXmlschemaV4FinanceService.PaymentMethodDetails paymentMethod = new AtlasFinServiceXmlschemaV4FinanceService.PaymentMethodDetails();
        AtlasFinServiceXmlschemaV4FinanceService.EFTDetails eft = new AtlasFinServiceXmlschemaV4FinanceService.EFTDetails();
        AtlasFinServiceXmlschemaV4FinanceService.CreditCardDetails creditCard = new AtlasFinServiceXmlschemaV4FinanceService.CreditCardDetails();
        String paymentMethodActionType;
        if(paymentMethodType != 'existing')
        {
             /* Dashes in the Account Holder Name are discarded - Defect fix : Atlas 214 */
               if(accountHolderName.contains('-'))
                {
                    accountHolderName=accountHolderName.replaceAll('-',' ');            
                }
            paymentMethodActionType = AtlasUtility.getMapValue(AtlasConstants.NEW_OTP_MTHD_ONLY);
            if(paymentMethodType == 'new-cc'){
                 creditCard.accountHolder = accountHolderName;creditCard.cardNumber = oneTimeencryptedCreditCard;Integer daysInMonth = date.daysInMonth(Integer.valueOf(creditCardYear),Integer.valueOf(creditCardMonth));DateTime expirationDate = Datetime.newInstanceGmt(Integer.valueOf(creditCardYear),Integer.valueOf(creditCardMonth),daysInMonth);
                 creditCard.expirationDate = expirationDate;creditCard.methodOfPayment = creditCardType;creditCard.zipCode = CreditCardZipCode;
                 creditCard.CVV = creditCardCVV;
                    paymentMethod.eft = null;
                    paymentMethod.creditCard = creditCard;}
            else if(paymentMethodType == 'new-check'){
                eft.accountHolder = accountHolderName;                
                eft.bankAccountNumber = oneTimeencryptedBankAccount;
                eft.bankCode = bankAccountRoutingNumber;
                eft.paymentType = bankAccountType;
                paymentMethod.creditCard = null;
                paymentMethod.eft = eft;}
          } 
          else{
              paymentMethodActionType = AtlasConstants.RCUR_PMT_MTHD;             
              paymentMethod = null;
              }
          try{       
            Double amountPayment = decimal.valueOf(amountValuePayment);
            AtlasTransactionDTO.oneTimePaymentDTOForAutoResume oneTimePaymentObj = new AtlasTransactionDTO.oneTimePaymentDTOForAutoResume(paymentMainDTOObj.externalAccountReference,paymentMainDTOObj.externalSystemName,null,paymentMethodActionType,amountPayment,paymentMethod);
            AtlasFinServiceXmlschemaV4FinanceService.OneTimePaymentAutoResumeResults paymentResponse = submitPaymentTransactionForAutoResume(oneTimePaymentObj);
            system.debug('--------------paymentResult---------> '+ paymentResponse);
            system.debug('--------------paymentResult---------> '+ paymentResponse.paymentResult + '-------------autoResumeResult---------> '+ paymentResponse.autoResumeResult);
            if(paymentResponse.paymentResult== 'success' && paymentResponse.autoResumeResult=='success')
            {
                oneTimesuccessMessage = AtlasKeyValueStore__c.getInstance(AtlasConstants.AutoResume_success).Value__c;                
                refreshPage = true;
                errorMessage = '';
                enablePaymentSettingsSubmit = false;
                clearAllPaymentSettingsfields();
                PaymentMethodType = 'existing';

                //To update the viewstate
                system.debug('--------------acc dto before---------> '+ paymentMainDTOObj.accountDTOObj);
                paymentMainDTOObj.accountDTOObj.provisionStatus='ACTIVE';
                paymentMainDTOObj.accountDTOObj.accountStatus='ACTIVE';
                AtlasDatabaseManager.persistViewState(paymentMainDTOObj);
                system.debug('--------------acc dto after---------> '+ paymentMainDTOObj.accountDTOObj);
            }           
            else if (paymentResponse.paymentResult== 'success' && paymentResponse.autoResumeResult!='success') {
                oneTimesuccessMessage = AtlasKeyValueStore__c.getInstance(AtlasConstants.AutoResume_failure1).Value__c+ AtlasKeyValueStore__c.getInstance(AtlasConstants.AutoResume_failure2).Value__c;
                refreshPage = true;
                errorMessage = '';
                enablePaymentSettingsSubmit = false;
                clearAllPaymentSettingsfields();
                PaymentMethodType = 'existing';
            } 
            else if (paymentResponse.paymentResult!= 'success' && !AtlasUtility.isEmpty(paymentResponse.paymentResult) && paymentMethodType == 'new-check') {
                //---Retrieving ACH error messages from MyExedeACHErrors Custom Object and mapping with the response code
                List<AtlasTransactionErrors__c> ACHmessages= new List<AtlasTransactionErrors__c>();
                Map<String,String> errorMap = new Map<String,String>();
                ACHmessages= [SELECT id,Name,Type__c,APIMessage__c,MyExedeMessage__c FROM AtlasTransactionErrors__c WHERE Type__c=:'ACH'];
                system.debug('---ACHmessages---> '+ACHmessages);
                if(ACHmessages!=null && ACHmessages.size()>0) {
                    for(AtlasTransactionErrors__c ach:ACHmessages) {
                        errorMap.put(ach.name,ach.MyExedeMessage__c);        
                    }
                }
                
                String ExedeErrMsg = errorMap.get(paymentResponse.paymentResult);
                system.debug('---Exede errMsg ---> '+ ExedeErrMsg);
                if(!AtlasUtility.isEmpty(ExedeErrMsg))
                    errorMessage = ExedeErrMsg;
                else
                    errorMessage = errorMap.get('V01');   
            }
            else
                errorMessage = AtlasKeyValueStore__c.getInstance(AtlasConstants.OTP_General_Exp).Value__c;
          }
          catch (Exception e) {errorMessage = AtlasKeyValueStore__c.getInstance(AtlasConstants.OTP_General_Exp).Value__c;}
    }
}