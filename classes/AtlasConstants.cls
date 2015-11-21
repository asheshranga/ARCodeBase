/*********************************************************************************
    Name         : AtlasConstants 
    Created By   : Gaurav Gathania
    Modified BY  : Shiva Shankar
    Company Name : NTT Data
    Project      : ViaSat Atlas, Bangalore
    Created Date : 29 October 2013
    Modified Date: 13 November 2013
    Usages       : AtlasConstants.IS_REFRESH_CALL
    *********************************************************************************/
    global with sharing class AtlasConstants{
        public static String EX_REF_FOR_SEARCH='ACCOUNT';
        public static String EXEDE_EMAIL_CHECK='@EXEDE';
        public static String WILDBLUE_EMAIL_CHECK='@WILDBLUE';
        public static String BUY_MORE_REJECTED='REJECTED';
        public static String SF_ORG_NAME='ATLAS';
        public static String buyMoreOneGB='1 GB';
        public static String buyMoreTwoGB='2 GB';
        public static String buyMoreThreeGB='3 GB';
        public static String buyMoreTenGB='10 GB';
        public static String ADD_USAGE_QUOTA='addUsageQuota';
        public static boolean IS_REFRESH_CALL=false;
        public static String DEBUG_STRING='Debug Statments:<br/>';
        public static final String GauravEmail='gaurav.gathania@nttdata.com';
        public static final String COUNTRY_CODE='USA';
        public static final String UPDATE_CONTACT='SUCCESS';
        public static final String BLANK='';
        public  static String WEBSERVICE_USERNAME=AtlasUtility.getMapValue('AtlasAPIUsername');
        public  static String WEBSERVICE_PWD=AtlasUtility.getMapValue('AtlasAPIPassword');
        public  static String WEBSERVICE_PWD_TEST=AtlasUtility.getMapValue('AtlasAPIPassword(TEST)');
        public  static String WEBSERVICE_PWD_PROD=AtlasUtility.getMapValue('AtlasAPIPassword(PROD)');
        public final static String EXEDE_VOICE='ExedeVoice';
        public final static String EXEDE_COMMUNITY='communityExede';
        public final static String EXEDE_COMMUNITY_VISIT='communityExedeVisit';
        // Variable for Knowledgebase Component 
        public final static String strKnowledgebaseSearch='KnowledgeBaseSearch';
        // Variables for Header & Footer Component 
        public final static String SIGNOUT='SignOut';
        public final static String PLANINVALID='PlanInvalid';
        public final static String EMAIL_INBOX='EmailInbox';
        public final static String DASHBOARD='Dashboard';
        public final static String DATA_USAGE='DataUsagePlan';
        public final static String VIEW_USAGE='ViewMyUsage';
        public final static String BUY_MORE='BuyMore';
        public final static String BILL_PAYMENT='BILLPAYMENT';
        public final static String VIEW_CURRENT_BILL='ViewCurrentBill';
        public final static String BILLING_HISTORY='BillingHistory';
        public final static String UPDATE_PAYMENT='UpdatePaymentMethod';
        public final static String MAKE_ONE_TIME_PAY='MakeOneTimePayment';
        public final static String MY_ACCOUNT='MYACCOUNT';
        public final static String CUSTOMER='CustomerContact Information';
        public final static String MANAGE_EMAIL_ACCOUNT='ManageEmailAccounts';
        public final static String MANAGE_EMAIL='ManageEmail';
        public final static String PAYMENT_SETTINGS='Payment Settings';
        public final static String EDIT_PAYMENT_METHOD='Edit Payment Method';
        public final static String PAYMENT_METHOD_NULL='Payment_Method_Null';
        public final static String CURRENT_BILL='CurrentBill&Payment';
        public final static String BLOG='Blog';
        public final static String ONLINE_COMMUNITY='onlineCommunity';
        public final static String KNOWLEDGE_BASE='KnowledgeBase';
        public final static String FACEBOOK='facebook';
        public final static String TWITTER='twitter';
        public final static String YOUTUBE='Youtube';
        public final static String GOOGLE_PLUS='google+';
        public final static String COMMUNITY='Community';
        public final static String FORUM='Forum';
        public final static String ExedeBottomBorderColor='#CF580D';    
        public final static String WildBlueBottomBorderColor='#00677F';
        public final static String ExedeborderleftOrRightcolor='#F48F4E';
        public final static String ExedeborderRightcolor = '#00BBE5';
        public final static String WildBlueborderleftOrRightcolor=' #00BBE5';
        public final static String CopyRightYear='CopyRightYear';
        public final static String FooterDisclaimerText_a='FooterDisclaimerText_a';
        public final static String FooterDisclaimerText_b='FooterDisclaimerText_b';
        public final static String FooterDisclaimerText_c='FooterDisclaimerText_c';
        public final static String FooterDisclaimerText_d='FooterDisclaimerText_d';
        public final static String FooterDisclaimerText_e='FooterDisclaimerText_e';
        public final static string VIEW_CURRENT_BILL_HEADER='ViewCurrentBill_Header';
        public final static string ONETIME_PAYMENT_NOTE='OneTimePayment_Note';
        public final static string ONETIME_PAYMENT_CHARGE='OneTimePayment_AmountCharge';
        // Variables for ChatEmailPhone Component
        public final static String CHAT='Chat';
        public final static String PHONE='Phone';
        public final static String EMAIL='Email';
        
        // Variables for billing snanpshot component
        public final static String BILLING_SNAPSHOT='BillingSnapShot';
        public final static String MANAGE_BILLING_SETTINGS='ManageBillingSettings';
        public final static String LAST_BILL='Current amount due: ';
        public final static String DUE='Next bill due on: ';
        public final static String LAST_PAYMENT='Last payment of';
        public final static String StatementDateLabel='Statement Date';
        public final static String InvoiceNumberLabel='Invoice Number';
        public final static String InvoiceTotalLabel='Invoice Total';
        public final static String LoadingBillingLabel='Loading Billing Data...';
        public final static String billingSnapshotLink='BILLING SNAPSHOT';
        
        // Variables for current data usage component
        public final static String CURRENT_DATA_USAGE='CurrentDataUsage';
        public final static String USAGE_DETAILS='ViewUsageDetails';
        public final static String BUY_MORE_DATA='BuyMoreData';
        public final static String LoadingUsageLabel='Loading Usage Data...';
        public final static String DaysRemainingLabel='DaysRemainingLabel';
        public final static String CDU_disclaimerText_a='CDU_disclaimerText_a';
        public final static String CDU_disclaimerText_b='CDU_disclaimerText_b';
        
        // Variabls for My account component
        public final static String MANAGE_YOUR_ACCOUNT='ManageYourAccount';
        public final static String UPGRADE_ACCOUNT='UpgradeAccount';        
        
        // Variables for AtlasUsagePagePlanDetails component
        public final static String PlanDetailsLabel='Plan Details';
        public final static String Added1GBLabel='Added1GBLabel';
        public final static String PerMonthLabel='per month';
        public final static String ChangePlanLabel='Change Plan';
        public final static String CHANGE_PHOTO='Change Photo';
        public final static String Unlimited_Plan_Text='Unlimited_Plan_Text';
        
        //Variables for AtlasLibertyPass Component
        public final static String Atlas_Liberty_Pass_Text = 'Atlas_Liberty_Pass_Text';
        public final static String Atlas_Liberty_Pass_Message = 'Atlas_Liberty_Pass_Message';
        public final static String Atlas_Liberty_Pass_Enabled_Message = 'Atlas_Liberty_Pass_Enabled_Message';
        public final static String Atlas_Liberty_Pass_Enabled_Text = 'Atlas_Liberty_Pass_Enabled_Text';
        public final static String Atlas_Liberty_Pass_Learn_More_Text = 'Atlas_Liberty_Pass_Learn_More_Text';
        public final static String Atlas_Liberty_Pass_Usage_Text = 'Atlas_Liberty_Pass_Usage_Text';
        public final static String Liberty_Pass_Link = 'Liberty_Pass_Link';
        
        // Variables for all other controllers
        public final static String VIEW_F_SECURE_INFORMATION='ViewFSecureInformation';
        public final static String LOGOUT='Signout';
        public final static String CUSTOMER_CONTACT_INFO='CustomerInformation';
        public final static String DETAILS='Details'; 
        public final static String NO_THANKS='NoThanks';
        public final static String CONFIRM='Confirm';
        public final static String SAVE='Save';
        public final static String CANCEL='Cancel';
        public final static String SAVE_CHANGE='SaveChanges';
        public final static String BEGIN_MOVING_SERVICE='Start the moving process';
        public final static String ARE_YOU_MOVING='ARE_YOU_MOVING';
        public final static String PAY_YOUR_BILL='PayYourBill';
        public final static String ADD_EMAIL_TEXT='AddEmail';
        public final static String ADD_AN_EMAIL_ADDRESS='AddanEmailAddress';
        public final static String URL_FOR_PRINT_INVOICE='atlasbillinghistoryprintinvoice';
        public final static String URL_FOR_BILL_PRINT_INVOICE='atlasbillingInvoiceprintinvoice'; 
        public final static String TAX_TYPES_NO_TAX_AUTHORITY='TAX_TYPES_NO_TAX_AUTHORITY';       
        
        // Variables for the AtlasIntegrationUtility        
        public final static String FIND_SUBSCRIBER='FindSubscriber';
        public final static String CUSTOMER_SEARCH='CustomerSearch';
        public final static String ACCOUNT_INFO='AccountInfoService';
        public final static String UPDATE_CONTACT_SERVICE='PublicContactService';
        public final static String CURRENT_USAGE='CurrentUsage';
        public final static String CURRENT_USAGE_V3='CurrentUsageV3';
        public final static String FINANCE_SERVICE='FinanceService';
        public final static String FINANCE_SERVICEV4='FinanceServicev4';
        public final static String TX_SERVICE='TransactionService';
        public final static String PUBLIC_CATALOG_SERVICE='PublicCatalogService';
        public final static String GET_SUBSCRIBER='getSubscribers';
        public final static String GET_BILLING='getBillingSummary';
        public final static String GET_LEGACYACCOUNT='getLegacyAccount';
        public final static String UPDATE_CONTACT_INFO='updateContacts';
        public final static String GET_SUBSCRIBER_PaymentMethod='getSubscriberCurrentPaymentMethod';
        public final static String GET_SUBSCRIBER_INVOICE='getSubscriberInvoiceDetails';
        public final static String GET_SUBSCRIBER_PAYMENTS='getSubscriberPaymentHistory';
        public final static String GET_SERVICEAGREEMENTS='getAccountServiceAgreementsAndServices';
        public final static String FIND_SUBSCRIBERV2='FindSubscriberV2';
        public final static String GET_SERVICE_AVAILABILITY='GetServiceAvailability';
        
        public static Integer TIMEOUT=120000;
        public final static String INVOKED_BY_USERNAME=AtlasUtility.getMapValue('INVOKED_BY_USERNAME');
        public final static String INVOKED_BY_APP=AtlasUtility.getMapValue('INVOKED_BY_APP');
        
        // Varialbles for Support block component
        public final static String Learn_About_ExedeVoice='LearnAboutExedeVoice';
        public final static String Learn_About_ExedeCommunity='LearnAboutExedeCommunity';
        public final static String Visit_TheKnowledge_Base='VisitTheKnowledgeBase';
        public final static String Voice_Promo='VoicePromo';
        // Variables used in AtlasDashboardController
        public final static String STR_EXEDE='Exede';
        public final static String STR_WILDBLUE='WildBlue';     
        public final static String STYLE_ORANGE='#F1701E';
        public final static String STYLE_BLUE='#0091B2';
        public final static String ACTIVE='active';
        public final static String DROPDOWN='dropdown';
        public final static String ACTIVE_DROPDOWN='active dropdown';
        public final static String BLACK_SPACE='';
        public final static String STRDASHBOARD='dashboard';
        public final static String STRUSAGE='usage';
        public final static String STRCURRENTBILL='currentbill';
        public final static String STRBILLING_HISTORY='billinghistory';
        public final static String STRPAYMENT_SETTINGS='paymentsettings';
        public final static String STRCUSTOMER_INFO='customerInfo';
        public final static String STRMANAGE_EMAIL='manageemail'; 
        //VARIABLES FOR BILLING SNAPSHOT CONTRLLER
        //strStyleClass for dashboard  in header component
        public final static String STYLE_CLASS_DASHBOARD='col-xs-12 col-sm-6 col-md-4 col-lg-4 border-right';
        public final static String HEADER_CLASS_DASHBOARD='';
        //strStyleClass for USAGE  in header component
        public final static String STYLE_CLASS_USAGE='col-xs-12 col-sm-6 col-md-12 col-lg-12';
        public final static String HEADER_CLASS_USAGE='';
        public static Boolean IS_BILLING_HISTORYVISIBLE=false;
        //strStyleClass for AtlasCustomerInfo  in header component
        public final static String STYLE_CLASS_CUSTOMERINFO='col-xs-12 col-sm-6 col-md-12 col-lg-12';
        public final static String HEADER_CLASS_CUSTOMERINFO='';
        public static Boolean IS_BILLING_HISTORYVISIBLE_CUSTOMERINFO=false;
        //strStyleClass for billinghistory  in header component
        public final static String STYLE_CLASS_BILLINGHISTORY='col-xs-12 col-sm-12 col-md-6 col-lg-6';
        public final static String HEADER_CLASS_BILLINGHISTORY='margin-top-0';
        public static Boolean IS_BILLING_HISTORYVISIBLE_BILLINGHISTORY=false;
        public final static String HEADER_CLASS_BILLINGHISTORY_PAYBILL_TEXT='View & Pay Your Bill';
        //strStyleClass for manageemail  in header component
        public final static String STYLE_CLASS_MANAGEEMAIL='col-xs-12 col-sm-6 col-md-12 col-lg-12';
        public final static String HEADER_CLASS_MANAGEEMAIL='margin-top-0';
        public static Boolean IS_BILLING_HISTORYVISIBLE_MANAGEEMAIL=true;
        //variables for current data usage controller
        public final static String HEADER_CLASS_CUSTOMERINFO_DATAUSAGE='margin-top-0 color-blue';
        public final static String STYLE_CLASS_DASHBOARD_DATAUSAGE='col-xs-12 col-sm-6 col-md-4 col-lg-4 border-right';
        public final static String STRHYPERLINKTEXT_DATAUSAGE='Usage Snapshot';
        public final static String STRCLASSSTYLE_DATAUSAGE='staus-titles';
        //variables for data usage component in usage page
        public final static String STYLECSS_CLASS_USAGE='col-xs-12';
        public final static String HEADERROW_CLASS_USAGE='staus-titles color-default';
        // Variables for MY ACCOUNT Component
        public final static String  STYLE_CLASS_MYACCOUNT='col-xs-12 col-sm-6 col-md-4 col-lg-4';
        public final static String STYLE_CLASS_CURRENTBILL='col-xs-12 col-sm-6 col-md-12 col-lg-12';
        public final static String  LoadingMyAccountLabel='Loading My Account Data...';
        public final static String  AccoutLabel='Account #:';
        public final static String  PhoneLabel='Phone:';
        public final static String  EmailLabel='Email:';
        public final static String  UserNameLabel='Username:';
        public final static String  ServiceAddressLabel='Service Address:';
        public final static String  BillingAddressLabel='Billing Address:';
        public final static String  YourPlanLabel='Your Plan';
        public final static String  PasswordLabel='Password:';
        public final static String HEADER_CLASS_USAGEPAGE='staus-titles color-default';
        // variables for Atlas Customer info payment method component
        public final static String strPAYMENT_METHOD='Payment Method';
        public final static String strCURRENT_PAYMENT_TYPE='Current Payment Type:';
        public final static String strCARD_NUMBER='Card Number:';
        public final static String strEXP_DATE='Expiration Date:';
        public final static String strUPDATE_PAYMENT_METHOD='Update Payment Method';
        public final static String strPLAN_DETAILS='Plan Details';
        public final static String strPLAN_TYPE='Plan Type:';
        public final static String strDATA='Data Allocation:';
        public final static String strPRICE='Price:';
        public final static String strVOIP='VoIP';
        public final static String strUPGRADE_ACCOUNT='Upgrade Account';
        public final static String strSERVICE_AGREEMENT='Service Agreement';
        public final static String strEND_DATE='End Date:';
        public final static String strAGREEMENT='View your Customer Agreement';
        public final static String strEDIT_MAIL='Edit Contact Email';
        //constants for CurrentBill 
        public final static String EQUIPMENT_LEASE_FEE='Equipment Lease Fee';
        public final static String MONTH_CONTRACT='24 Month Contract';
        public final static String DATA_PROJECT_CHARGES='Data Package Charges (i.e ';
        public final static String ADJUSTMENTS='Adjustments';
        //These variables are used in usage page
        public final static String STRTITLE_USAGE='STRTITLE_USAGE';
        public final static String STRHEADER2_USAGE='Data Usage '+'&'+ ' Buy More';
        public final static String STRHEADER3_USAGE='Last 10 Days of Usage';
        //These variables are used in AtlasKnowledgeBase.component
        public final static String STRHEADER3_AtlasKnowledgeBase='Help_Center'; 
        public final static String STRHEADER4_AtlasKnowledgeBase='Popular Articles'; 
        //(Variables)Starting of CustomerInfo.page
        public final static String STRTITLE_CustomerInfo='STRTITLE_CustomerInfo';
        public final static String STRHEADER2_CustomerInfo='Customer Information';
        public final static String UsernameText='Username:';
        public final static String PhoneText='Phone:';
        public final static String EmailText='Email:';
        public final static String BillingAddress1Text='Billing Address 1'; 
        public final static String BillingAddress2Text='Billing Address 2';
        public final static String CityText='City';
        public final static String StateText='State';
        public final static String ZIPCodeText='ZIP Code';
        public final static String STROPTION_CustomerInfo='Manage Email Accounts';
        //End of CustomerInfo.page
        //Starting of PaymentSettings.page
        public final static String STRTitle_PaymentSettings='STRTitle_PaymentSettings';
        public final static String EncryptionKey = 'PaymentSettingsEncryptionKey';
        //End of PaymentSettings.page
        //Variables for BillingHistory.page  
        public final static String STRTitle_BillingHistory='STRTitle_BillingHistory';
        public final static String BillingOverviewLabel='Billing Overview';
        public final static String AccountNameLabel='Account Name:';
        public final static String AccountNumberLabel='Account Number:';
        //Variables for CurrentBill.page
        public final static String STRTitle_CurrentBill='STRTitle_CurrentBill';
        public final static String STRHEADER2_CurrentBill='Current Bill'+ ' & ' +'Payment';
        public final static String BillingAdrsText='Billing Address';
        public final static String ServiceAdrsText='Service Address';
        public final static String AccountNumberText='Account Number';
        public final static String DueDateText='Due Date';
        public final static String AmountText='Amount Due';
        public final static String OneTimePaymentText='One time payment';
        public final static String ThankYouText='Thank you!';
        public final static String SuccessFulPaymentText='SuccessFulPaymentText';
        // variables for AtlasBillPaymentOneTimePayment component
        public final static String AmountdueText='Current Amount due... ';
        public final static String NoPaymentNeededLabel='NoPaymentNeededLabel';
        public final static String AccounttochargeLabel='Account to charge';
        public final static String AmountTochargeLabel='Amount';
        public final static String ProcessingLabel='Processing......!!';
        public final static String CardTypeLabel='Card Type';
        public final static String ExpirationLabel='Expiration';
        public final static String NameOnAccountLabel='Account Holder Name';
        public final static String accountRoutingNumberLabel='Routing Number';
        public final static String accountACNumberLabel='Account Number';
        public final static String creditCardNumberLabel='Card Number';
        public final static String creditCardCVVLabel='CVV';
        public final static String creditCardZipLabel='Zip';
        public final static String creditCardNameLabel='Name On Card';
        // Variables for ChatEmailPhone Component
        public final static String  customerCareNumberLabel='CustomerCareNumber';
        // variables for Buy more component        
        public final static String STR_BUYMORE='Buy More';
        public final static String STR_DATA='You'+ +'ve added 1GB of data.';
        public final static String STR_NO_THANKS='No Thanks';
        public final static String STR_PURCHASE='Purchase';
        public final static String STR_NOTE='Please Note';
        public final static String STR_POINT1='STR_POINT1';
        public final static String STR_POINT2='STR_POINT2';
        public final static String STR_POINT3='STR_POINT3';
        public final static String STR_READ_DETAILS='STR_READ_DETAILS';
        public final static String STR_BUYMORE_DETAILS='STR_BUYMORE_DETAILS';
        public final static String STR_BADGE1='STR_BADGE1';
        public final static String STR_BADGE2='STR_BADGE2';
        public final static String STR_BADGE3='STR_BADGE3';
        public final static String STR_BADGE4='STR_BADGE4';
        public final static String STR_BADGE5='STR_BADGE5';
        public final static String STR_BADGE6='STR_BADGE6';
        public final static String STR_BADGE7a='STR_BADGE7a';
        public final static String STR_BADGE7b='STR_BADGE7b';
        public final static String STR_BADGE8a='STR_BADGE8a';
        public final static String STR_BADGE8b='STR_BADGE8b';
        public final static String STR_BADGE8c='STR_BADGE8c';        
        public final static String STR_CLOSE='Close';
        public final static String STYLE_CLASS_ENABLED='btn btn-info btn-block btn-lg';
        public final static String STYLE_CLASS_DISABLED='btn btn-info btn-block btn-lg disabled';
        public final static string ERROR_MSG_SUSPENDED_ACCOUNT='ERROR_MSG_SUSPENED_ACCOUNT'; 
        public final static string ERROR_MSG_VACATION_ACCOUNT='ERROR_MSG_ACCOUNT_WITH_VACATION_PLAN';
        // Varibles used in BUY MORE DTO Class      
        public final static String STR_GB='GB';
        public final static String STR_CURRENCy='$';
        //Static variables are used in Atlas Login Page     
        public final static String STRFORGOT_PASSWORD='ForGotPassword';
        public final static String STRFORGOT_PASSWORD_WILDBLUE='ForGotPasswordWildBlue';
        public final static String StrTitle_LoginPage='StrTitle_LoginPage';
        public final static String Apex_URL='/apex/';
        public final static String Http_text='http:';
        public final static String Https_text='https:';
        public final static String usernamePlaceholder='Email';
        public final static String pwdPlaceholder='Password';
        //Static variables ENCRYPTION
        private static final String KEY='';
        private static final String ENCRYPTION_METHOD='DES/ECB/PKCS5Padding';
        //static variables used for the rss feed component
        public static final String RSS_FEED='RssFeed'; 
        // static variable used in customer info page
        public static final String strPASSWORD='**********';
        public static final String strCHANGE_PLAN='Change Plan';
        public static final String strTitle_ChangePlanMoving = 'strTitle_ChangePlanMoving';        
        public static final String CHANGEPLAN ='changeplanmoving';
        public static final String CHANGE_YOUR_PLAN='CHANGE_YOUR_PLAN';
        public static final String WECAN_HELP='WECAN_HELP';
        public static final String EMAIL_CHAT='Email and Chat';
        public static final String CHANGE_PLAN_POINT1a='CHANGE_PLAN_POINT1a';
        public static final String CHANGE_PLAN_POINT1b='CHANGE_PLAN_POINT1b'; 
        public static final String CHANGE_PLAN_POINT2='CHANGE_PLAN_POINT2';
        public static final String CHANGE_PLAN_POINT3='CHANGE_PLAN_POINT3';
        public static final String WE_HELP1='WE_HELP1';
        public static final String WE_HELP2='WE_HELP2';
        public static final String CHANGE_PWD_OR_SECURITY='CHANGE_PWD_OR_SECURITY';
        public static final String NEED_CHANGE_PLAN='NEED_CHANGE_PLAN';
        public static final String DASHBOARD_TITLE='DASHBOARD_TITLE';
        public static final String OLD_CUSTOMER_PORTAL='Old Customer Portal'; 
        public static final String NOTE='Note'; 
        public static final String NOTE1='NOTE1';
        public static final String NOTE2='soon';
        public static final String NOTE3='';
        public static final String CUSTOMER_NAME='Customer Name:';
        public static final String ACOUNT_NUMBER='Account number:';
        public static final String PASSWORD='Password:';
        //variables used for change plan component
        public static final String REQUEST='REQUEST';
        public static final String TERMS_AND_CONDITIONS='TERMS_AND_CONDITIONS';
        public static final String PACKAGES='PACKAGES';
        public static final String OPTIONS='CP_REQUESTED_PLAN_OPTION1';
        public static final String OPTION1='CP_REQUESTED_PLAN_OPTION2';
        public static final String OPTION2='CP_REQUESTED_PLAN_OPTION3'; 
        public static final String OPTION3='CP_REQUESTED_PLAN_OPTION4';
        public static final String OPTION4='CP_REQUESTED_PLAN_OPTION5';
        public static final String OPTION5='CP_REQUESTED_PLAN_OPTION6';
        public static final String COMMENTS='Comments';
        public static final String ChangePlan_CustomerCareNumber='ChangePlan_CustomerCareNumber';
        public static final String BUTTONCLASS_DASHBOARD_BILLING='btn btn-info btn-lg btn-block';
        public static final String BUTTONCLASS_ALLPAGES_BILLING='btn btn-primary btn-lg btn-block';
        public static final string CP_SUCCESS='CP_SuccessMessage';
        public static final string CP_CASE_OWNER='CP_CASE_OWNER_ID';
        public static final String CONTACT_NAME = 'Contact';
        public static final String CONTACT_EMAIL = 'ContactEmail';
        public static final String ACCOUNT = 'Account';
        public static final String SUBJECT = 'Subject';
        public static final String CASE_RECORD_TYPE = 'RecordType';
        public static final String CASE_ORIGIN= 'Origin';
        public static final String CATEGORY= 'Category';
        public static final String CATEGORY_OPT = 'Choose One';
        public static final String CATEGORY_OPT1 = 'Account';
        public static final String CATEGORY_OPT2 = 'Account Administration';
        public static final String CATEGORY_OPT3 = 'Additional Resources';
        public static final String CATEGORY_DETAILS='CategoryDetails';
        public static final String CATEGORY_DETAILS_OPT='Choose Category';
        public static final String CATEGORY_DETAILS_OPT1='Acceptable Use Policy';
        public static final String CATEGORY_DETAILS_OPT2='Add/Remove Exede Voice';
        public static final String CATEGORY_DETAILS_OPT3='Billing';
        public static final String CASE_OWNER='Owner';
        public static final String CHANGE_PLAN_CASE='CHANGE_PLAN_CASE_ORIGIN';
        public static final String CHANGE_PLAN_CATEGORY='CHANGE_PLAN_CATEGORY';
        public static final String CHANGE_PLAN_DETAILS='CHANGE_PLAN_CATEGORY_DETAILS';
        public static final String CHANGE_PLAN_SUBJECT='CHANGE_PLAN_SUBJECT';
        public static final string CP_VALIDATE_PLAN='CP_VALIDATE_REQUESTED_PLAN';
        public static final string CP_VALIDATE_DESCRIPTION='CP_VALIDATE_COMMENTS';
        public static final string CP_ERROR_MSG='CP_ERROR_MESSAGE';
        public static final string CP_SEND_REQUEST='Submit Change'; 
        public static final string CP_PROCESSING=' Processing';
        public static final string CP_REQUESTED_PLAN_LABEL='Please change my plan to:';
        public static final string CP_CASE_ORIGIN_WEB='Web - Care';
        public static final string CP_SUPPLIED_NAME='SuppliedName';
        public static final string CP_SUPPLIED_EMAIL='Email';
        public static final string CP_RECORD_TYPE='Case Record Type';
        public static final string CP_WEB_PHONE='Web Phone';
        public static final string CP_CASE_ORIGIN='Case Origin';
        public static final string CP_CONTACTID='ContactID';
        public static final string CP_TC1='CHANGE_PLAN_TC1';
        public static final string CP_TC2='CHANGE_PLAN_TC2';
        public static final string CP_TC3='CHANGE_PLAN_TC3';
        public static final string CP_TC1CONT='CHANGE_PLAN_TC1_CONT';
        public static final string CP_TC2CONT='CHANGE_PLAN_TC2_CONT';
        public static final string CP_TC3CONT='CHANGE_PLAN_TC3_CONT'; 
        public static final string GET_TRANSITION_BASE='TransitionBase';
        //variables used for Billing Invoice
        public static String sortBy='date';
        public static final String VIEW_BILLING_HISTORY ='ViewBillHistory';
        public static final String INVOICE_NUMBER_TEXT='130011';
        public static final String X_UA_COMPATIBLE='X-UA-Compatible';
        public static final String IE_8='IE=8';
        public static final String ENCRYPTION_KEY='1A5D791A40D35470';
        public static final String CREDIT_CARD='Credit Card';
        public static final String PRICE='$79.99';
        public static final String SERVICE_AGREEMENT_END_DATE='03-13-2015';
       // public static final String ERROR_IN_CUSTOMERINFO_SAVE='<b>Error in Customer Info Save<b> <br/>';
        public static final String EXCEPTION_DIV_STYLE='display: none;';
        public static final String ERROR_IN_BUYMORE='<b>Error in Buy More <b> <br/>';
        public static final integer EIGHTY=80;
        public static final integer NINETY=90;
        public static final integer ONE_FIFTY=100;
        public static final string UPDATE_CUSTOMER_INFO_SUCCESS='UPDATE_CUSTOMER_INFO_SUCCESS';
        public static final string BUYMORE_PURCHASE_SUCCESS='';
        public final static String BuymorePriceNullValue='BuymorePriceNullValue';
     //variable used for Billing History Pagination
        public static final String PARAMETER_VARIABLE='invref'; 
        //Variable used for CryptoUtil
        public static final String ENCRYPTION_ALG='AES128';   
        //Variable used for Current Data Usage
        public static final String AMOUNT_USED_UNIT=' GB';
        public static final String TRUE_VALUE='TRUE';
        public static final string LOADING_BUYMORE='Loading Buymore Data.....'; 
        public static final string BUYMORE_GB='GB @ $';
        public static final string ADD_BUYMORE='Add';
        public static final string PURCHASED_DATA_1GB='purchased 1GB of data. Your Usage Meter will be reloaded automatically.';
        public static final string PURCHASED_DATA_2GB='purchased 2GB of data. Your Usage Meter will be reloaded automatically.';
        public static final string PURCHASED_DATA_3GB='purchased 3GB of data. Your Usage Meter will be reloaded automatically.';
        public static final string PURCHASED_DATA_10GB='purchased 10GB of data. Your Usage Meter will be reloaded automatically.';
        public static final string WISP_DATA_1GB='added 1GB of data.';
        public static final string WISP_DATA_2GB='added 2GB(s) of data.';
        public static final string WISP_DATA_3GB='added 3GB(s) of data.';
        public static final string WISP_DATA_10GB='added 10GB(s) of data.';
        public static final string YOU='You';
        public static final string VIEW_MORE='viewMore';
        public static final string BUY_MORE_1GB='1 GB';
        public static final string BUY_MORE_2GB='2 GBs';
        public static final string BUY_MORE_3GB='3 GBs';
        public static final string BUY_MORE_10GB='10 GBs';
        //Variables used for AtlasOneTimePaymentController
        public static final String OTP_SAVE_PR='apex/currentbill'; 
        
        //Variables used for AtlasPlanDetailsDTO
        public static final String PLAN_DETAILS_DTO='un-metered usage'; 
        
        // For AtlasDummyTestPage Constant Variable Checking
        public static final String BLUE_COLOR= 'blue';
        
        //Variables used for AtlasPopularArticles Controller
        public static final String ARTICLE_LIMIT='ExtTrendingArticlesLimit';
        public static final String CHARACTER_LIMIT='TrendingArticleSummaryCharsLimit'; 
        public static final String PUBLISH_STATUS='Online'; 
        //Variables used for AtlasSiteLoginController
        public static final String STARTURL='/dashboard'; 
        public static final String USERNAME='gauravg';
        public static final String DOMAIN='@nttdata.com'; 
        public static final String ERR_MSG='Login unsuccessful';
        //Variables used for Popular Articles
        public static final String AVG_RATING='avgRating';
        public static final String ICON_STAR='icon-star';
        public static final String ICON_STAR_EMPTY='icon-star-empty';
        public static final String PARENT_ID='ParentId';
        public static final String DATA_CTG_GRP_NAME='DataCategoryGroupName';
        public static final String DATA_CTG_NAME='DataCategoryName'; 
        public static final String DENVER_PROD='Denver_Product';
        public static final String AtlasKnowledgeLinkPageURL = '/apex/AtlasKnowledgeLinkPage';
        //Variables used for KnowledgeBaseController
        public static final String KB_URL= AtlasUtility.getURL('PUBLIC_KB');
        public static final String KB_DEV_URL='KnowledgeArticles_DEV_URL';
        public static final String KB_QA_URL='KnowledgeArticles_QA_URL';
        public static final String KB_UAT_URL='KnowledgeArticles_UAT_URL';
        public static final String ATLAS_DEV_EXEDE='atlasdev-exede';
        public static final String TEST_ATLAS_EXEDE='testatlas-atlasqa-exede';  
        public static final string LOADING_PLAN_DETAILS='Loading Plan Details....';
        public static final string PAYMENT_METHOD_LABEL='Payment Method';
        public static final string EXISING_PAYMENT_METHOD='NO Exisitng Payment Method';
        public static final string LOADING_PAYMENT_METHOD='Loading PaymentMethod details...';
        public static final string CURRENT_PAYMENT_TYPE='Current Payment Type:';
        public static final string CARD_NUMBER='Card Number:';
        public static final string EXPIRY_DATE='Expiration Date:';
        public static final string ACCOUNT_HOLDER='Account Holder:';
        public static final string ACCOUNT_NUMBER='Account Number:';
        public static final string ACCOUNT_TYPE='Account Type:';
        public static final string UPDATE_PAYMENT_METHOD='Update Payment Method';
        public static final string PLAN_DETAILS_LABEL='Plan Details';
        public static final string PLAN_TYPE='Plan Type:';
        public static final string DATA_ALLOCATION='Data Allocation:';
        public static final string PRICE_LABEL='Price:';
        public static final string ACTIVATED='Activated';
        public static final string VOIP_LABEL='VoIP';
        public static final string PER_MONTH='per month';
        public static final string CHANGE_PLAN_LABEL='Change Plan';
        public static final string BILL_SENT_TO='Bill Sent To:';
        public static final string EDIT_PICTURE='Edit Picture';
        //Variables used for AtlasPaymentSettingsController
        public static final String PMU_SuccessMessageCode = 'PMU_SuccessMessage';
        public static final String PMU_UpdateCreditCard_FailureMessageCode = 'PMU_UpdateCreditCard_FailureMessage';
        public static final String PMU_UpdateBankAcc_FailureMessageCode = 'PMU_UpdateBankAcc_FailureMessage';
        public static final String CC_Validation_AllFieldsRequiredCode = 'CC_Validation_AllFieldsRequired';
        public static final String CC_Validation_InvalidNameCode = 'CC_Validation_InvalidName';
        public static final String CC_Validation_InvalidNumbersCode = 'CC_Validation_InvalidNumbers';
        public static final String CC_Validation_CVV3DigitsCode = 'CC_Validation_CVV3Digits';
        public static final String CC_Validation_CVV4DigitsCode = 'CC_Validation_CVV4Digits';
        public static final String CC_Validation_ZIPCODE5DigitsCode = 'CC_Validation_ZIPCODE5Digits';
        public static final String CC_Validation_InvalidExpiryCode = 'CC_Validation_InvalidExpiry';
        public static final String CC_Validation_InvalidCardCode = 'CC_Validation_InvalidCard';
        public static final String Bank_Validation_AllFieldsRequiredCode = 'Bank_Validation_AllFieldsRequired';
        public static final String Bank_Validation_RoutingCode = 'Bank_Validation_Routing';
        public static final String Bank_Validation_InvalidAccountCode = 'Bank_Validation_InvalidAccount';
        public static final String Bank_Validation_InvalidNameCode = 'Bank_Validation_InvalidName';
        public static final String Bank_Validation_AccountNumber = 'Bank_Validation_Account_Number';
        //Variables used for OneTimePaymentController
        public static final string RCUR_PMT_MTHD='USE_RECURRING_PAYMENT_METHOD';
        public static final String OTP_IN_DATA_EXP='OTP_Input_Data_Exp';
        public static final String OTP_SUCC_MSG='OTP_Success_Msg';
        public static final String NEW_OTP_MTHD_ONLY='NEW_OTP_MTHD_ONLY';
        public static final String AutoResume_success='AutoResume_success';
        public static final String AutoResume_failure1='AutoResume_failure1';
        public static final String AutoResume_failure2='AutoResume_failure2';
        public static final String ERROR_MSG_VALID_IN='ERROR_MSG_VALID_IN';
        public static final String ERR_MSG_INVALID_AMOUNT ='ERR_MSG_INVALID_AMOUNT';
        public static final String ERR_MSG_PMT_MTHD_TYPE_EXPIRED ='ERR_MSG_PMT_MTHD_TYPE_EXPIRED';
        public static final String ERR_MSG_PMT_MTHD_TYPE='ERR_MSG_PMT_MTHD_TYPE';
        //Variables is used in currentdatausage controller
        public static final String BROWSER_NAME='MSIE'; 
        public static final String USER_AGENT='user-agent'; 
        public static final String BLOG_URL='http://www.exede.com/tag/evergreen'; 
        public static final string CASE_RECORD_TYPE_NAME='CP_CASE_RECORD_TYPE'; 
        public static final string AMEX_LABEL='AMERICAN_EXPRESS';   
        public static final string MASTER_CARD_LABEL='MASTERCARD';
        public static final string VISA_CARD_LABEL='VISA';
        public static final string Invalid_CVV = 'AtlasInvalidCVV';
        public static final string Invalid_CC = 'AtlasInvalidCreditCard';
        //Variables is used to store toAdrees emails to send exception email
        public static final String[] toAddresses=new String[]{'gaurav.gathania@nttdata.com','shivashankar.nalluri@nttdata.com'};
        //for integration service manager getInvoiceDetailsCDRInfo1
        public static final string AMOUNT='amount';
        public static final string DURATION='duration';
        public static final string LOCATION='destinationLocation';
        public static final string CALLED_NUMBER='terminatingTN';
        public static final string CDR_EXCEPTION='CDR_Callout_Exp';
        public static final string CURRENTBILL_EXCEPTION='Unable to Load Billing Information at this time. Please try again later.';
        public static final integer NO_OF_RECORDS_PER_PAGE=10;
        public static final string LOADING_CDR_INFO='Loading CDR Details';
        public static final string EXEDE_VOICE_DETAILS='Details of Your Exede Voice Charges';
        public static final string MANAGE_VOICE='Manage Voice Account';
        public static final string CDR_NO_INFO='CDR_No_Data_Exp'; 
        public static final string CDR_DATE_TIME='Date / Time';
        public static final string CDR_CALLED_NO='Called Number';
        public static final string CDR_LOCATION='Location';
        public static final string CDR_DURATION='Duration (Min.)';
        public static final string CDR_AMOUNT='Amount';
        public static final string NO_OF_SERVERS='No_Of_Servers';
        public static final string CDR_TRANSACTION_ID='transactionId';
        //Variables used for AtlasLoginUserNameController
        public static final String ChangeUserName_Successful_Message='ChangeUserName_Successful_Message';
        //Variables used for AtlasUserPasswordResetController
        public static final String ResetPassword_Successful_Message='ResetPassword_Successful_Message';
        public static final String ResetPassword_Max_Length='ResetPassword_Max_Length';
        //Variables used for AtlasMoveInternalAccountController
        public static final String MoveInternalAccount_Successful_Message='MoveInternalAccount_Successful_Message';
        public static final String MoveInternalAccount_Failed_Message='MoveInternalAccount_Failed_Message';
        public static final String MoveInternalAccount_Bad_Input_Exp='MoveInternalAccount_Bad_Input_Exp';
        public static final String MoveInternalAccount_Disconnected = 'MoveInternalAccount_Disconnected';
        // Variables used for CPNI Reports
        public static final String CPNI_REPORT_NO_DATA_FOUND='NO DATA FOUND FOR REPORT!';
        public static final String CPNI_REPORT_EMAIL_SUBJECT='Daily CPNI Report';
        public static final String CPNI_REPORT_FIELD_DELIMITER=',';
        public static final String CPNI_REPORT_EMAIL_ID='CPNI_REPORT_EMAIL_ID';
        public static final String CPNI_REPORT_TIME_FRAME='CPNI_REPORT_TIME_FRAME';
        public static final String CPNI_CHANNEL_NAME='CPNI_CHANNEL_NAME';
        public static final String CPNI_SERVICE_LEVEL='CPNI_SERVICE_LEVEL';
        public static final String CPNI_PASSWORD='CPNI_PASSWORD';
        public static final String CPNI_SECURITY='CPNI_SECURITY';
        public static final String CPNI_USERNAME='CPNI_USERNAME';
        public static final String CPNI_CONTACT_EMAIL='CPNI_CONTACT_EMAIL';
        
        public static final String[] CPNI_REPORT_TXN_TYPES=new String[] {'CPNI_PASSWORD',
                                                                         'CPNI_SECURITY',
                                                                         'CPNI_USERNAME',
                                                                         'CPNI_CONTACT_EMAIL'};
        public static final String UploadFile_Callout_Exp='UploadFile_Callout_Exp';
        public static final String UploadFile_No_Data_Exp='UploadFile_No_Data_Exp';
        
        public static final String SYNC_USER_DATA_WITH_SFDC_SUCCESS_MESG='SYNC_USER_DATA_WITH_SFDC_SUCCESS_MESG';
        public static final String SYNC_USER_DATA_WITH_SFDC_FAIL_MESG='SYNC_USER_DATA_WITH_SFDC_FAIL_MESG';
        
        //variables for Atlas Customer Status
        public static final string CustomerStatus_AccNoError='CustomerStatus_AccNoError';
        public static final string CustomerStatus_SPRSuccess='CustomerStatus_SPRSuccess';
        public static final string CustomerStatus_SPRfailure='CustomerStatus_SPRfailure';
        public static final string CustomerStatus_SFDCSuccess='CustomerStatus_SFDCSuccess';
        public static final string CustomerStatus_SFDCfailure='CustomerStatus_SFDCfailure';
        public static final string CustomerStatus_InvalidAcc='CustomerStatus_InvalidAcc';
        public static final string CustomerStatus_clearSPR1='CustomerStatus_clearSPR1';
        public static final string CustomerStatus_clearSPR2='CustomerStatus_clearSPR2';
        public static final string CustomerStatus_CreateSFDC1='CustomerStatus_CreateSFDC1';
        public static final string CustomerStatus_CreateSFDC2='CustomerStatus_CreateSFDC2';
        public static final string CustomerStatus_ReRigister='CustomerStatus_ReRigister';
        /* 
        *   *************************************** ATLAS Exception Constants ****************************************
        *   **********************************************START*******************************************************
        */
             public static final String UPDATE_CONTACT_FAIL_CODE='UC01';
             public static final String UPDATE_CONTACT_FAIL_MSG='Update Contact Service has failed. Please try again';
             public static final String SEARCH_CUSTOMER_FAIL_CODE='SC01';
             public static final String SEARCH_CUSTOMER_FAIL_MSG='Unable to find Customer. Please try again';
             public static final String SERVICE_AGREEMENT_FAIL_CODE='SA01';
             public static final String SERVICE_AGREEMENT_FAIL_MSG='Unable to find Service Agreement. Please try again';
             public static final String BILLING_SUMMARY_FAIL_CODE='BS01';
             public static final String BILLING_SUMMARY_FAIL_MSG='Unable to Billing details. Please try again';
             public static final String CURRENT_DATA_USAGE_FAIL_CODE='CDU01';
             public static final String CURRENT_DATA_USAGE_FAIL_MSG='Unable to get data usage details. Please try again';
             public static final String BILLING_SNAPSHOT_FAIL_CODE='BSS01';
             public static final String BILLING_SNAPSHOT_FAIL_MSG='Unable to get billing snapshot details. Please try again';
             public static final String AtlasSMgr_GetCurrentUsageByAccount='AtlasSMgr_GetCurrentUsageByAccount';
             
             public static final String General_Auth_Error_Exp='General_Auth_Error_Exp';
             public static final String ChangePassword_No_Data_Exp='ChangePassword_No_Data_Exp';
             public static final String ChangePassword_Callout_Exp='ChangePassword_Callout_Exp';
             public static final String ChangePassword_General_Exp='ChangePassword_General_Exp';             
             public static final String ChangeSecurity_Callout_Exp='ChangeSecurity_Callout_Exp';
             public static final String ChangeSecurity_General_Exp='ChangeSecurity_General_Exp';
             public static final String ChangeSecurity_No_Data_Exp='ChangeSecurity_No_Data_Exp';
             public static final String ChangeSecurity_Data_Prob_Exp='ChangeSecurity_Data_Prob_Exp';
             public static final String ChangeUserName_No_Data_Exp='ChangeUserName_No_Data_Exp';
             public static final String ChangeUserName_Invalid_Data_Exp='ChangeUserName_Invalid_Data_Exp';
             public static final String ChangeUserName_Callout_Exp='ChangeUserName_Callout_Exp';
             public static final String ChangeUserName_General_Exp='ChangeUserName_General_Exp'; 
             public static final String ChangeUserName_Dup_User_Exp='ChangeUserName_Dup_User_Exp';
             public static final String ChangeUserName_User_Not_Found_Exp='ChangeUserName_User_Not_Found_Exp';
             public static final String ChangeUserName_Bad_Input_Exp='ChangeUserName_Bad_Input_Exp';
             public static final String ResetPassword_No_Data_Exp='ResetPassword_No_Data_Exp';
             public static final String ResetPassword_Invalid_Data_Exp='ResetPassword_Invalid_Data_Exp';
             public static final String ResetPassword_Callout_Exp='ResetPassword_Callout_Exp';
             public static final String ResetPassword_Dup_User_Exp='ResetPassword_Dup_User_Exp';
             public static final String ResetPassword_User_Not_Found_Exp='ResetPassword_User_Not_Found_Exp';  
             public static final String ResetPassword_Bad_Input_Exp='ResetPassword_Bad_Input_Exp';
             public static final String ResetPassword_General_Exp='ResetPassword_General_Exp';              
             public static final String SC_No_Data_Exp='SC_No_Data_Exp';
             public static final String SC_Callout_Exp='SC_CallOut_Exp';
             public static final String SC_General_Exp='SC_General_Exp';
             public static final String SA_General_Exp='SA_General_Exp';
             public static final String SA_Callout_Exp='SA_Callout_Exp';
            public static final String  SA_No_Data_Exp='SA_No_Data_Exp';
            public static final String  BS_General_Exp='BS_General_Exp';
            public static final String  BS_Callout_Exp='BS_Callout_Exp';
            public static final String  BS_No_Data_Exp='BS_No_Data_Exp';
            public static final String  CU_General_Exp='CU_General_Exp';
            public static final String  CU_Callout_Exp='CU_Callout_Exp';
            public static final String  CU_No_Data_Exp='CU_No_Data_Exp';
            public static final String  PM_General_Exp='PM_General_Exp';
            public static final String  PM_Callout_Exp='PM_Callout_Exp';
            public static final String  PM_No_Data_Exp='PM_No_Data_Exp';
            public static final String  CDR_General_Exp='CDR_General_Exp';
            public static final String  CDR_Callout_Exp='CDR_Callout_Exp';
            public static final String  CDR_No_Data_Exp='CDR_No_Data_Exp';
            public static final String  BH_General_Exp='BH_General_Exp';
            public static final String  BH_Callout_Exp='BH_Callout_Exp';
            public static final String  BH_No_Data_Exp='BH_No_Data_Exp';
            public static final String  LS_General_Exp='LS_General_Exp';
            public static final String  LS_Callout_Exp='LS_Callout_Exp';
            public static final String  LS_No_Data_Exp='LS_No_Data_Exp';
            public static final String  ID_General_Exp='ID_General_Exp';
            public static final String  ID_Callout_Exp='ID_Callout_Exp';
            public static final String  ID_No_Data_Exp='ID_No_Data_Exp';
            public static final String  UP_General_Exp='UP_General_Exp';
            public static final String  UP_Callout_Exp='UP_Callout_Exp';
            public static final String  UP_Input_Data_Exp='UP_Input_Data_Exp';
            public static final String  PH_General_Exp='PH_General_Exp';
            public static final String  PH_Callout_Exp='PH_Callout_Exp';
            public static final String  PH_No_Data_Exp='PH_No_Data_Exp';
            public static final String  UC_General_Exp='UC_General_Exp';
            public static final String  UC_Callout_Exp='UC_Callout_Exp';
            public static final String  UC_Input_Data_Exp='UC_Input_Data_Exp';
            public static final String  VB_General_Exp='VB_General_Exp';
            public static final String  VB_Callout_Exp='VB_Callout_Exp';
            public static final String  VB_Input_Data_Exp='VB_Input_Data_Exp';
            public static final String  OTP_General_Exp='OTP_General_Exp';
            public static final String  OTP_Callout_Exp='OTP_Callout_Exp';
            public static final String  OTP_Input_Data_Exp='OTP_Input_Data_Exp'; 
            public static final String  OTC_General_Exp='OTC_General_Exp';
            public static final String  OTC_Callout_Exp='OTC_Callout_Exp';
            public static final String  OTC_No_Data_Exp='OTC_No_Data_Exp';
            public static final String  PKG_General_Exp='PKG_General_Exp';
            public static final String  PKG_Callout_Exp='PKG_Callout_Exp';
            public static final String  PKG_No_Data_Exp='PKG_No_Data_Exp';
            public static final String  AUQ_General_Exp='AUQ_General_Exp';
            public static final String  AUQ_Callout_Exp='AUQ_Callout_Exp';
            public static final String  AUQ_Input_Data_Exp='AUQ_Input_Data_Exp';
            public static final String UpdateSubscriber_No_Data_Exp='UpdateSubscriber_No_Data_Exp';
            public static final String UpdateSubscriber_Callout_Exp='UpdateSubscriber_Callout_Exp';
            public static final String UpdateSubscriber_General_Exp='UpdateSubscriber_General_Exp'; 
            public static final String AS_Callout_Exp = 'AS_Callout_Exp';
            public static final String AS_No_Data_Exp = 'AS_No_Data_Exp';
         /* 
        *   **********************************************END*******************************************************
        *   *************************************** ATLAS Exception Constants ****************************************
        */
        //Variables used in Beta-exit
          public static final string LOGIN_HELP_TEXT='Login Help';
          public static final string WHAT_DO_YOU_NEED_HELP='What Do You Need Help With';
          public static final string STEP_1_4='Step 1 of 4';
          public static final string LOGIN_HELP_ERROR_MSG = 'Please choose one option.';
          public static final string FORGOT_USERNAME='Forgot My Username';
          public static final string RESET_PASSWORD='Reset My Password';
          public static final string LOGIN_CANCEL='Cancel';
          public static final string LOGIN_NEXT_STEP='Next Step';
          //Variables used in LoginhelpUsername-VfComponent
          public static final string NEW_USER_TEXT='New User';
          public final static string IDENTIFICATION_TEXT='Identification';
          public final static string LOGIN_FIRST_TEXT='Logging in for the first time?';
          public final static string LOGIN_INST_TEXT='LOGIN_INST_TEXT';
          public final static string PSWD_HELP_TEXT='PSWD_HELP_TEXT';
          public final static string QUES_HELP_TEXT='QUES_HELP_TEXT';
          public final static string EMAIL_HELP_TEXT='EMAIL_HELP_TEXT';
          public final static string USR_CNFM_TEXT='USR_CNFM_TEXT';
          public final static string OPWD_REQ_TEXT='OPWD_REQ_TEXT';
          public final static string BILLING_HELP_TEXT='BILLING_HELP_TEXT';
          public final static string USER_HELP_TEXT='USER_HELP_TEXT';
          public final static string LOGIN_PROBLEM_TEXT='Problems with the following fields';
          public final static string LOGIN_MAC_TEXT='LOGIN_MAC_TEXT';
          public final static string LOGIN_ACC_TEXT='LOGIN_ACC_TEXT';
          public final static string LOGIN_ACC_VALIDATE='LOGIN_ACC_VALIDATE';
          public final static string LOGIN_MAC_VALIDATE='LOGIN_MAC_VALIDATE';
          public final static string LOGIN_PHONE_VALIDATE='LOGIN_PHONE_VALIDATE';
          public final static string LOGIN_EMAIL_VALIDATE='LOGIN_EMAIL_VALIDATE';
          public final static string PLS_EMAIL_VALID='PLS_EMAIL_VALID';
          public final static string PH_INVALID_MSG='PH_INVALID_MSG';
          public final static string WHAT_IS_THIS='WHAT_IS_THIS';
          public final static string LOGIN_ACC_INST_TEXT='LOGIN_ACC_INST_TEXT';
          public final static string LOGIN_MAC_INST_TEXT='LOGIN_MAC_INST_TEXT';
          public final static string LOGIN_ACC_NOT_FOUND_TEXT='LOGIN_ACC_NOT_FOUND_TEXT';
          public final static string LOGIN_UNAME_LIMIT='LOGIN_UNAME_LIMIT';
          public final static string LOGIN_UNAME_REQD='LOGIN_UNAME_REQD';
          public final static string EMAIL_SENT='EMAIL_SENT';
          public final static string IM_SORRY='IM_SORRY';
          public final static string START_LIVE='START_LIVE';
          public final static string ACC_HELP_TEXT_1='ACC_HELP_TEXT_1';
          public final static string ACC_HELP_TEXT_2='ACC_HELP_TEXT_2';
          public final static string MAC_HELP_TEXT='MAC_HELP_TEXT';
          public final static string PHNEEMAIL_HELP_TEXT='PH,EMAIL_HELP_TEXT';
          public final static string PSWD_NEWUSR_HLP_TEXT_1='PSWD_NEWUSR_HLP_TEXT_1';
          public final static string PSWD_NEWUSR_HLP_TEXT_2='PSWD_NEWUSR_HLP_TEXT_2';
          public final static string USER_IDENT_HELP_TEXT_1='USER_IDENT_HELP_TEXT_1';
          public final static string USER_IDENT_HELP_TEXT_2='USER_IDENT_HELP_TEXT_2';
          public final static string QUES_NEWUSR_HLP_TEXT='QUES_NEWUSR_HLP_TEXT';         
          public final static string ANS_NEWUSR_HLP_TEXT='ANS_NEWUSR_HLP_TEXT';          
          public final static string UNAME_NEWUSR_HLP_TEXT='UNAME_NEWUSR_HLP_TEXT';       
          public final static string LOGIN_CC_TEXT=' or contact Customer Care.';
          public final static string LOGIN_CC_NO_TEXT='LOGIN_CC_NO_TEXT';
          public final static string LOGIN_TRY_AGAIN_TEXT='Try Again';
          public final static string LOGIN_ACC_LABEL='Account Number';
          public final static string LOGIN_MAC_LABEL='MAC Address';
          public final static string LOGIN_ALL_FIELDS_TEXT='* required';
          
           //Variable used to show/hide disclaimer
          public final static string SHOW_DISCLAIMER_1='Show_Disclaimer_Footer';
          public final static string SHOW_DISCLAIMER_2='Show_Disclaimer_Page';
          
          //Variable used to display for Jcode in case of Invalid address
          public final static string JCODE_INVALID_ADDRESS='Jcode_Invalid_Address';
          
          //Variables used in LoginhelpPassword-VfComponent
          public final static string RESET_MYPWD_TEXT='Reset my password - Enter Username';
          public static final string STEP_2_4='Step 2 of 4';
          public static final string STEP_3_4='Step 3 of 4';
          public static final string STEP_4_4='Step 4 of 4';
          public static final string PLS_UNAME='Please enter your username to get started.';
          public static final string UNAME='Username *';
          public static final string REQUIRED='* required';
          public static final string ACC_NOT_FOUND='ACC_NOT_FOUND';
          public static final string LIVE_CHAT='Live Chat';
          public static final string TO_GET_HELP='to get help.';
          public static final string RESET_PWD_SQ='Reset my password - Security Questions';
          public static final string FIRST_Q='First Question';
          public final static string FIRST_ANSWER='FIRST_ANSWER';
          public final static string SECOND_ANSWER='SECOND_ANSWER';
          public static final string FIRST_QA='First Answer';
          public static final string SECOND_Q='Second Question';
          public static final string SECOND_QA='Second Answer';
          public static final string FORGOT_UNAME_LINK='I forgot my username';
          public static final string SQ_INCORRECT='SQ_INCORRECT';
          public static final string SPEAK_REP='SPEAK_REP';
          public static final string PWD_REQD='PWD_REQD';
          public static final string CPWD_REQD='CPWD_REQD';
          public static final string EMAIL_REQD='EMAIL_REQD';
          public static final string CEMAIL_REQD='CEMAIL_REQD';
          public static final string PLS_CNFM_EMAIL='PLS_CNFM_EMAIL';
          public static final string EMAIL_INFO='EMAIL_INFO';
          public static final string EMAIL_INFO1='EMAIL_INFO1';
          public static final string EMAIL_LABEL='Email Address';
          public static final string C_EMAIL_TEXT='Re-enter Email Address';
          public static final string RESET_PWD_NEWPWD='Reset my password - Create New Password';
          public static final string PWD_LABEL='Password *';
          public static final string WEAK='Weak';
          public static final string GOOD='Good';
          public static final string STRONG='Strong';
          public static final string RE_PWD='Re-enter Password *';
          public static final string PWD_DONE='PWD_DONE';
          public static final string FINISHED='Finished';
          //
          public static final string HELP='Help';
          public static final string PHONE_TEXT='Phone';
          public static final string EMAIL_TEXT='Email';
          public static final string USER_EXIST1='USER_EXIST1';
          public static final string USER_EXIST2='USER_EXIST2';
          public static final string USER_EXIST3='USER_EXIST3';
          public static final string USER_EXIST4='USER_EXIST4';
          public static final string USER_EXIST5='USER_EXIST5';
          public static final string PLS_CHOOSE_UNAME='Please choose a username.';
          public static final string PLS_VALID_UNAME='Please enter a valid username.'; 
          public static final string NOT_YOU='not you?';
          //
          public static final string PWD='Password *';
          public static final string RE_PWD_LABEL='Password';
          public static final string CREATE_PWD='Create Password';
          public static final string EDIT_PWD='Edit Password';
          public static final string SECURITY_QUESTIONS='Security Questions';
          public static final string EDIT_SECURITY_QUESTIONS='Edit Questions';
          public static final string CHOOSE_ONE='Choose one';
          //Atlas sso username && pwd
          public static final string ATLAS_SSO_API_SUCCESS_STATUS='ATLAS_SSO_API_SUCCESS_STATUS';
          public static final string ATLAS_SSO_API_UNAME='AtlasSSOAPIUsername';
          public static final string ATLAS_SSO_API_PWD='AtlasSSOAPIPassword';
          public static final string ATLAS_SSO_API_PWD_TEST='AtlasSSOAPIPassword(TEST)';
          public static final string ATLAS_SSO_API_PWD_PROD='AtlasSSOAPIPassword(Prod)';
          
          public static final string ATLAS_COMMUNITY_URL='/';
          public static final string ATLAS_DEV_URL='/';
          public static final string ATLAS_NEW_USER_URL='/apex/AtlasNewUser';
          public static final string ATLAS_LOGIN_HELP_URL='/apex/atlasLoginHelp';
          public static final string PWD_VALIDATION_MSG='PWD_VALIDATION_MSG';
          public static final string ACC_NO_NOT_EXIST='ACC_NO_NOT_EXIST';
          public static final string MAC_NO_NOT_EXIST='MAC_NO_NOT_EXIST';
          public static final string MAC_ADD_NOT_EXIST='MAC_ADD_NOT_EXIST';
          public static final string ACC_MAC_NOT_EXIST='ACC_MAC_NOT_EXIST';
          public static final string NEW_UNAME_HELP='NEW_UNAME_HELP';
          public static final string NEW_USER_UNAME_VALIDATION='NEW_USER_UNAME_VALIDATION';
          public static final string NEW_USER_UNAME_SPACEVALIDATION='NEW_USER_UNAME_SPACEVALIDATION';
          public static final string NEW_UNAME_VALID_FAILED='NEW_UNAME_VALID_FAILED';
          public static final string NEW_USER_SQ_HELP='NEW_USER_SQ_HELP';
          public static final string SQ1_VALID_FAILED='SQ1_VALID_FAILED';
          public static final string SQ2_VALID_FAILED='SQ2_VALID_FAILED';
          public static final string CNFM_EMAIL_VAIDATION='CNFM_EMAIL_VAIDATION';
          public static final string PLS_CHNG_EMAIL_ADD='PLS_CHNG_EMAIL_ADD';
          public static final string FP_SQ_HELP='FP_SQ_HELP';
          public static final string FU_UNAME_HELP='FU_UNAME_HELP';
          public static final string Atlas_loginUserName_Attribute = 'Atlas_loginUserName_Attribute';
          public static final string Account_Owner = 'Account_Owner';
          public static final string FORGOT_USERNAME_TEXT ='AtlasForgotUsername';
          public static final string NO_EMAIL_ID ='NO_EMAIL_ID';
          public static final string ACC_Terminated = 'ACC_Terminated';
          public static final string ATLAS_LOGIN = 'ATLAS_LOGIN';
          public static final string PLS_ENTER_EMAIL = 'PLS_ENTER_EMAIL';
          public static final string Atlas_Change_Email_Address = 'Atlas_Change_Email_Address';
          public static final string Atlas_Invalid_Account_Status = 'Atlas_Invalid_Account_Status';
          public static final string Atlas_User_Creation_Exception = 'Atlas_User_Creation_Exception';
          public static final string Atlas_Not_Exede_Customer = 'Atlas_Not_Exede_Customer';
          public static final string Footer_Legal_Documents_Text = 'Footer_Legal_Documents_Text';
          public static final string Atlas_Legal_Documents_URL = 'Atlas_Legal_Documents_URL';
          public static final string Atlas_Current_Bill_SubFooter_Msg1 = 'Atlas_Current_Bill_SubFooter_Msg1';
          public static final string Atlas_Current_Bill_SubFooter_Msg2 = 'Atlas_Current_Bill_SubFooter_Msg2';
          public static final String EXEDE_CUSTOMER_SUPPORT_URL= 'ExedeCustomerSupport';
          public static final string UserName_Not_You_Message = 'UserName_Not_You_Message';
          public static final string Email_Info_Edit_Msg = 'Email_Info_Edit_Msg';
          public static final string PLAN_INVALID_TEXT = 'PLAN_INVALID_TEXT';
          public static final string MAC_DIGITS = 'MAC_DIGITS';
          public static final string PHONE_DIGITS = 'PHONE_DIGITS';
          public static final string ACC_NO_PLACE_HOLDER = 'ACC_NO_PLACE_HOLDER';
          public static final string MAC_PLACE_HOLDER = 'MAC_PLACE_HOLDER';
          public static final string PHONE_PLACE_HOLDER = 'PHONE_PLACE_HOLDER';
          public static final string EMAIL_PLACE_HOLDER = 'EMAIL_PLACE_HOLDER';
          public static final string LOGIN_UNAME_HELP1 = 'LOGIN_UNAME_HELP1';
          public static final string LOGIN_UNAME_HELP2 = 'LOGIN_UNAME_HELP2';
          public static final string Community_URL = 'Community URL';
          public static final string Atlas_Community_Profile = 'Atlas Community Profile';
          public static final string ACC_LOCKED = 'ACC_LOCKED';
          public static final string ACC_LOCKED1 = 'ACC_LOCKED1';
          public static final string ACC_LOCKED2 = 'ACC_LOCKED2';
          public static final string ACC_LOCKED5 = 'ACC_LOCKED5';
          public static final string ACC_EMAIL_PHONE = 'ACC_EMAIL_PHONE';
          public static final string SQ_INCORRECT_FIVE_TIMES = 'SQ_INCORRECT_FIVE_TIMES';
          public static final string PWD_VALIDATION1 = 'PWD_VALIDATION1';
          public static final string PWD_VALIDATION2 = 'PWD_VALIDATION2';
          public static final string PWD_VALIDATION3 = 'PWD_VALIDATION3';
          public static final string PWD_VALIDATION4 = 'PWD_VALIDATION4';
          public static final string PWD_VALIDATION5 = 'PWD_VALIDATION5';
          public static final string PWD_VALIDATION6 = 'PWD_VALIDATION6';
          public static final string ACC_PENDING_ACTIVATION = 'ACC_PENDING_ACTIVATION';
          public static final string LIVE_CHAT_URL = 'LIVE_CHAT_URL';
          public static final string Buy_More_Valid_Status = 'Buy_More_Valid_Status';
          public static final string LOGIN_HELP_UNAME_DESC = 'LOGIN_HELP_UNAME_DESC';
          public static final string PURGE_USER_LOCK_OUTS = 'PURGE_USER_LOCK_OUTS';
          public static final string PURGE_USER_REGISTRATION_HISTORY = 'PURGE_USER_REGISTRATION_HISTORY';
          public static final string Atlas_Community_Id = 'Atlas_Community_Id';
          public static final string Atlas_Community_Message = 'Atlas_Community_Message';
          public static final string Disallowed_New_User_Special_Characters = 'Disallowed_New_User_Special_Characters';
          public static final string New_User_Email_Domain = 'New_User_Email_Domain';
          public static final string Data_Allocation_For_Unlimited_Plan = 'Data_Allocation_For_Unlimited_Plan';
          public static final string AtlasTransHistRecordType = 'AtlasTransHistoryRecordType';
          public static final string Atlas_NewUser_Action_Status = 'Atlas_NewUser_Action_Status';
          public static final string Atlas_NewUser_Action_Status1 = 'Atlas_NewUser_Action_Status1';
          public static final string Atlas_NewUser_Action_Status2 = 'Atlas_NewUser_Action_Status2';
          public static final string Atlas_NewUser_Action_Status3 = 'Atlas_NewUser_Action_Status3';
          public static final string AtlasBuyMorePollerCount = 'AtlasBuyMorePollerCount';
          public static final string AtlasCreditCardYearOptions = 'AtlasCreditCardYearOptions';
          public static final string AtlasBillingSnapshotPaid = 'AtlasBillingSnapshotPaid';
          public static final string AtlasBillingSnapshotFailed = 'AtlasBillingSnapshotFailed';
          
          //variables used in Change Plan & Moving page new build
          public static final String AtlasConfirmation='AtlasConfirmation';
          public static final String ChangePlanConfirm='ChangePlanConfirm';
          public static final String WhatToExpect='WhatToExpect';
          public static final String AtlasHoldTight1='AtlasHoldTight1';
          public static final String AtlasHoldTight2='AtlasHoldTight2';
          public static final String AtlasHoldTight3='AtlasHoldTight3';
          public static final String AtlasWhatNext1='AtlasWhatNext1';
          public static final String AtlasWhatNext2='AtlasWhatNext2';
          public static final String AtlasWhatNext3='AtlasWhatNext3';
          public static final String AtlasWhatNext4='AtlasWhatNext4';
          public static final String AtlasWhatNext5='AtlasWhatNext5';
          public static final String AtlasTroubleText1='AtlasTroubleText1';
          public static final String AtlasTroubleText2='AtlasTroubleText2';
          public static final String AtlasTroubleText3='AtlasTroubleText3';
          public static final String AtlasTroubleText4='AtlasTroubleText4';
          public static final String AtlasTroubleText5='AtlasTroubleText5';
          public static final String AtlasNextBill='AtlasNextBill';
          public static final String AtlasNextBillText1='AtlasNextBillText1';
          public static final String AtlasNextBillText2='AtlasNextBillText2';
          public static final String AtlasPrint='AtlasPrint';
          public static final String AtlasCPlanDashboard='AtlasCPlanDashboard';
          public static final String AtlasMovingVacation='AtlasMovingVacation';
          public static final String AtlasMovingGoingVacation='AtlasMovingGoingVacation';
          public static final String AtlasMovingHelpText='AtlasMovingHelpText';
          public static final String AtlasMovingHelp='AtlasMovingHelp';
          public static final String AtlasCallCare='AtlasCallCare';
          public static final String AtlasLeavingVacation='AtlasLeavingVacation';
          public static final String AtlasLeavingVacationText='AtlasLeavingVacationText';
          public static final String AtlasChangeMyPlan='AtlasChangeMyPlan';
          public static final String AtlasCPlanSummary='AtlasCPlanSummary';
          public static final String AtlasCPlanSummaryText='AtlasCPlanSummaryText';
          public static final String AtlasNewPlan='AtlasNewPlan'; 
          public static final String AtlasDataTransition='AtlasDataTransition'; 
          public static final String AtlasPerMonth='AtlasPerMonth'; 
          public static final String AtlasAlreadyUsed='AtlasAlreadyUsed'; 
          public static final String AtlasPlanRemaining='AtlasPlanRemaining'; 
          public static final String AtlasPlusLiberyPass='AtlasPlusLiberyPass'; 
          public static final String AtlasPastDataCap='AtlasPastDataCap';
          public static final String AtlasLibertyPassText='AtlasLibertyPassText';
          public static final String AtlasServicePerformance='AtlasServicePerformance';
          public static final String AtlasPleaseNote='AtlasPleaseNote';
          public static final String AtlasSummaryNote1='AtlasSummaryNote1';
          public static final String AtlasSummaryNote2='AtlasSummaryNote2';
          public static final String AtlasTermsConditions='AtlasTermsConditions';
          public static final String AtlasTermsConditionsText1='AtlasTermsConditionsText1';
          public static final String AtlasSubmitChange='AtlasSubmitChange';
          public static final String AtlasHowFast='AtlasHowFast';
          public static final String AtlasMbps='AtlasMbps';
          public static final String AtlasHowMuch='AtlasHowMuch';
          public static final String AtlasGBperMonth='AtlasGBperMonth';
          public static final String AtlasBonus='AtlasBonus';
          public static final String AtlasSelectPlan='AtlasSelectPlan';
          public static final String AtlasSelectPlanText='AtlasSelectPlanText';
          public static final String AtlasCurrentPlan='AtlasCurrentPlan';
          public static final String AtlasThingstoKnow='AtlasThingstoKnow';
          public static final String AtlasThingstoKnowText1='AtlasThingstoKnowText1';
          public static final String AtlasThingstoKnowText2='AtlasThingstoKnowText2';
          public static final String AtlasPlansLoading='AtlasPlansLoading';
          public static final String LIbertyPlansLink='LIbertyPlansLink';
          public static final String AtlasCPlanCustIssue='AtlasCPlanCustIssue';
          public static final String AtlasCPlanUnavailable='AtlasCPlanUnavailable';
          public static final String AtlasCPlanCustIssueText='AtlasCPlanCustIssueText';
          public static final String AtlasUnavailable='AtlasUnavailable';
          public static final String AtlasCPlanSysIssueText='AtlasCPlanSysIssueText';
          public static final String AtlasCPlanPending='AtlasCPlanPending';
          public static final String AtlasPendingStatus1='AtlasPendingStatus1';
          public static final String AtlasPendingStatus2='AtlasPendingStatus2';
          public static final String Moving='Moving';
          public static final String AtlasCPlanPendingPlan='AtlasCPlanPendingPlan';
          public static final String AtlasCPlanPendingPlanText='AtlasCPlanPendingPlanText';
          public static final String AtlasCPlanNextBill1='AtlasCPlanNextBill1';
          public static final String AtlasCPlanNextBill2='AtlasCPlanNextBill2';
          public static final String AtlasCPlanProvStatusList='AtlasCPlanProvStatusSuspended';
          public static final String AtlasCPlanLogout='AtlasCPlanLogout';
          public static final String AtlasCPlanLogoutText='AtlasCPlanLogoutText';
          public static final String AtlasCPlanVacationList='AtlasCPlanVacationList';
          public static final String AtlasActivateVoipLink='AtlasActivateVoipLink';
          public static final String AtlasManageVoipLink='AtlasManageVoipLink';
          public static final String AtlasActivateVoip='AtlasActivateVoip';
          public static final String AtlasManageVoip='AtlasManageVoip';
          public static final String AtlasExedeVoice='AtlasExedeVoice';
          public static final String AtlasAchDisclaimer1='AtlasAchDisclaimer1';
          public static final String AtlasAchDisclaimer2='AtlasAchDisclaimer2';
          public static final String CPlanEditEmail='CPlanEditEmail';
          public static final String CPlanEditShippingAdd='CPlanEditShippingAdd';
          public static final String CPlanModemText1='CPlanModemText1';
          public static final String CPlanModemText2='CPlanModemText2';
          public static final String CPlanModemText3='CPlanModemText3';
          public static final String CPlanNewEquip='CPlanNewEquip';
          public static final String CPlanNewEquipText='CPlanNewEquipText';
          public static final String CPlanShippingInfo='CPlanShippingInfo';
          public static final String CPlanShippingText='CPlanShippingText';
          public static final String CPlanSwitchModemText='CPlanSwitchModemText';
          public static final String CPlanThatsIt='CPlanThatsIt';
          public static final String CPlanConfirmSb2PlusText='CPlanConfirmSb2PlusText';
          
          //variables used in WISP
          public static final string WISP_Subscriber_Community = 'WISP Subscriber Community Profile';
          public static final string WISP_Admin_Community = 'WISP Admin Community Profile';
          public static final string Wisp_Dashboard = 'WispDashboard';
          public static final string Wisp_New_User_Email_Domain = 'Wisp_New_User_Email_Domain';
          public static final string Wisp_ResetPswd = 'Wisp_ResetPswd';
          public static final string Wisp_Username = 'Wisp_Username';
          public static final string WIsp_LoginHelp_PswdHelpText = 'WIsp_LoginHelp_PswdHelpText';
          public static final string Wisp_LoginHelp_Step1 = 'Wisp_LoginHelp_Step1';
          public static final string Wisp_LoginHelp_Step2 = 'Wisp_LoginHelp_Step2';
          public static final string Wisp_LoginHelp_Step3 = 'Wisp_LoginHelp_Step3';
          public static final string Wisp_LoginHelp_UnameText = 'Wisp_LoginHelp_UnameText';
          public static final string Wisp_LoginHelp_SQ= 'Wisp_LoginHelp_SQ';
          public static final string Wisp_LoginHelp_newPswd= 'Wisp_LoginHelp_newPswd';
          public static final string Wisp_Pswd_Reset= 'Wisp_Pswd_Reset';
          public static final string Wisp_Pswd_Success= 'Wisp_Pswd_Success';
          public static final string Wisp_LoginPage= 'Wisp_LoginPage';
          public static final string Wisp_Callout_Failed= 'Wisp_Callout_Failed'; 
          public static final string Wisp_ACC_NOT_FOUND= 'Wisp_ACC_NOT_FOUND';
          public static final string Wisp_ACC_LOCKED1= 'Wisp_ACC_LOCKED1';
          public static final string Wisp_Header_Text= 'Wisp_Header_Text';
          public static final string Wisp_Exception_Page_Title= 'Wisp_Exception_Page_Title';
          public static final string Wisp_Registration_Success_Msg= 'Wisp_Registration_Success_Msg';
          public static final string Wisp_Registration_Failure_Msg= 'Wisp_Registration_Failure_Msg';
          public static final string WispUserName_Not_You_Message= 'WispUserName_Not_You_Message';
          public static final string Wisp_New_User_Phone_Email_Incorrect= 'Wisp_New_User_Phone_Email_Incorrect';
          public static final string Wisp_SQ_Incorrect= 'Wisp_SQ_Incorrect';
          public static final string Wisp_CurrentDataUsage= 'Wisp_CurrentDataUsage';
          public static final string Wisp_UsageMeterInfo= 'Wisp_UsageMeterInfo';
          public static final string Wisp_UsageMeterInfoText= 'Wisp_UsageMeterInfoText';
          public static final string Wisp_Buymore= 'Wisp_Buymore';
          public static final string Wisp_Buymore_1= 'Wisp_Buymore_1';
          public static final string Wisp_Buy1GB= 'Wisp_Buy1GB';
          public static final string Wisp_Buy2GB= 'Wisp_Buy2GB';
          public static final string Wisp_Buy3GB= 'Wisp_Buy3GB';
          public static final string Wisp_Buy10GB= 'Wisp_Buy10GB';
          public static final string Wisp_GBs= 'Wisp_GBs';
          public static final string Wisp_BuymoreDisclaimer= 'Wisp_BuymoreDisclaimer';
          public static final string Wisp_MyAccount= 'Wisp_MyAccount';
          public static final string Wisp_MyAccount_Info= 'Wisp_MyAccount_Info';
          public static final string Wisp_EditAccountInfo= 'Wisp_EditAccountInfo';
          public static final string Wisp_copyright= 'Wisp_copyright';
          public static final string Wisp_PrivacyPolicy= 'Wisp_PrivacyPolicy';
          public static final string WISP_NEW_USER_UNAME_VALIDATION= 'WISP_NEW_USER_UNAME_VALIDATION';
          public static final string WISP_PLS_EMAIL_VALID= 'WISP_PLS_EMAIL_VALID';
          public static final string WISP_LOGIN_UNAME_REQD= 'WISP_LOGIN_UNAME_REQD';
          public static final string WISP_OPWD_REQ_TEXT= 'WISP_OPWD_REQ_TEXT';
          public static final string WISP_PWD_VALIDATION_MSG= 'WISP_PWD_VALIDATION_MSG';
          public static final string WISP_CPWD_REQD= 'WISP_CPWD_REQD';
          public static final string WISP_PSWD_HELP_TEXT= 'WISP_PSWD_HELP_TEXT';
          public static final string WISP_PWD_REQD= 'WISP_PWD_REQD';
          public static final string WISP_SQ1_VALID_FAILED= 'WISP_SQ1_VALID_FAILED';
          public static final string WISP_SQ2_VALID_FAILED= 'WISP_SQ2_VALID_FAILED';
          public static final string WISP_QUES_HELP_TEXT= 'WISP_QUES_HELP_TEXT';
          public static final string WISP_FIRST_ANSWER= 'WISP_FIRST_ANSWER';
          public static final string WISP_SECOND_ANSWER= 'WISP_SECOND_ANSWER';
          public static final string WISP_ANS_NEWUSR_HLP_TEXT= 'WISP_ANS_NEWUSR_HLP_TEXT';
          public static final string WISP_QUES_NEWUSR_HLP_TEXT= 'WISP_QUES_NEWUSR_HLP_TEXT';
          public static final string Wisp_CTI_Viasat= 'Wisp CTI/Viasat';
          public static final string Wisp_SearchAgents= 'Wisp_SearchAgents';
          public static final string Wisp_CTI_Loading= 'Wisp_CTI_Loading';
          public static final string Wisp_Agents= 'Wisp_Agents';
          public static final string Wisp_CTI_LoginAs= 'Wisp_CTI_LoginAs';
          public static final string WIsp_CTI_CreateSFDC= 'WIsp_CTI_CreateSFDC';
          public static final string Wisp_Search= 'Wisp_Search';
          public static final string Wisp_Clear= 'Wisp_Clear';
          public static final string Wisp_UserAdmin= 'Wisp_UserAdmin';
          public static final string WIsp_Subscribers= 'WIsp_Subscribers';
          public static final string Wisp_SearchSubscribers= 'Wisp_SearchSubscribers';
          public static final string Wisp_Partner_Loginas= 'Wisp_Partner_Loginas';
          public static final string Wisp_Password= 'Wisp_Password';
          public static final string Wisp_ChangeUname= 'Wisp_ChangeUname';
          public static final string Wisp_ACC_HELP_TEXT_1= 'Wisp_ACC_HELP_TEXT_1';
          public static final string Wisp_ACC_LOCKED= 'Wisp_ACC_LOCKED';
          public static final string Wisp_ACC_LOCKED5= 'Wisp_ACC_LOCKED5';
          public static final string Wisp_SIGNOUT= 'WispSignOut';
          public static final string Wisp_Account_Recordtype= 'Wisp_Account_Recordtype';
          public static final string Wisp_Service_Provider= 'Wisp_Service_Provider';
          public static final string Wisp_Account_Owner= 'Wisp_Account_Owner';
          public static final string Wisp_ACC_MAC_NOT_EXIST= 'Wisp_ACC_MAC_NOT_EXIST';
          public static final string Wisp_Acc_Terminated= 'Wisp_Acc_Terminated';
          public static final string Wisp_UNAME_NEWUSR_HLP_TEXT= 'Wisp_UNAME_NEWUSR_HLP_TEXT';
          public static final string Wisp_USER_IDENT_HELP_TEXT_1= 'Wisp_USER_IDENT_HELP_TEXT_1';
          public static final string Wisp_USER_IDENT_HELP_TEXT_2= 'Wisp_USER_IDENT_HELP_TEXT_2';
          public static final string Wisp_LOGIN = 'CommunityURL';
          public static final string Wisp_application = 'Wisp';
          public static final string Exede_application ='Exede'; 
          public static final string Wildblue_application = 'WildBlue';
          public static final string Wisp_Partner_Next= 'Wisp_Partner_Next'; 
          public static final string Wisp_Partner_Previous= 'Wisp_Partner_Previous';
          public static final string Wisp_UserInfo= 'Wisp_UserInfo';
          public static final string Wisp_ChangeLoginUname= 'Wisp_ChangeLoginUname';
          public static final string Wisp_Transaction_History= 'Wisp_Transaction_History';
          public static final string Wisp_BacktoSearch= 'Wisp_BacktoSearch';
          public static final string Wisp_GenPswd= 'Wisp_GenPswd';
          public static final string Wisp_planinvalid1= 'Wisp_planinvalid1';
          public static final string WispPlanInvalid= 'WispPlanInvalid';
          public static final string Wisp_Plan_Not_Set = 'Wisp_Plan_Not_Set';
          public static final string Wisp_UnderConstruction_msg1 = 'Wisp_UnderConstruction_msg1';
          public static final string Wisp_UnderConstruction_msg2 = 'Wisp_UnderConstruction_msg2';
          public static final string WispSubscriber = 'Wisp Subscriber';
          public static final string wispDaysRemainingLabel = 'wispDaysRemainingLabel';
          public static final string WispPrivacyPolicy= 'WispPrivacyPolicy';
          public static final string Wisp_LOGIN_UNAME_HELP1 = 'WispLoginUnameHelp1';
          public static final string WispPlanInvalidUrl = 'WispPlanInvalidUrl';
          public static final string WispTransHistoryRecordType = 'WispTransHistoryRecordType';
          public static final string WispDelegatedAdminOwner = 'WispDelegatedAdminOwner';
          public static final string WispBuyMoreSuspendedAcc = 'WispBuyMoreSuspendedAcc';
          public static final string WispLoginMacText = 'WispLoginMacText';
          public static final string WispBuyMorePollerCount = 'WispBuyMorePollerCount';
          
    }