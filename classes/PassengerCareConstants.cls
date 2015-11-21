/*********************************************************************************
Name         : PassengerCareConstants 
Created By   : Rakesh 
Usages       : PassengerCareConstants.IS_REFRESH_CALL
*********************************************************************************/
global with sharing class PassengerCareConstants{    
    //--- Live chat constants
    public static string LIVE_CHAT_DEPLOYMENT_URL = PassengerCareUtility.getFieldValue('VA_ChatDeploymentURL');
    public static string LIVE_CHAT_INIT_URL = PassengerCareUtility.getFieldValue('VA_ChatInitURL');
    public static string LIVE_CHAT_COMPANY_INFO_ID = PassengerCareUtility.getFieldValue('VA_CompanyInformationId');
    public static string LIVE_CHAR_DEPLOYMENT_ID = PassengerCareUtility.getFieldValue('VA_LivedeploymentId'); 
    public static string LIVE_CHAT_BUTTON_ID = PassengerCareUtility.getFieldValue('VA_LiveChatButton');
    
    //--- Text constants
    public static string EMAIL_TO_US = PassengerCareUtility.getFieldValue('VA_EmailToUs');
    public static string EMAIL_ADDITIONAL_INFO = PassengerCareUtility.getFieldValue('VA_EmailAdditionalInfo');
    public static string CHAT_WITH_US = PassengerCareUtility.getFieldValue('VA_ChatWithUs');
    public static string CHAT_ADDITIONAL_INFO = PassengerCareUtility.getFieldValue('VA_ChatAdditionalInfo');
    public static string EMAIL_TO_US_SUCCESS_MSG = PassengerCareUtility.getFieldValue('VA_EmailToUsSuccessMsg');
    public static string CALL_US_PHONE = PassengerCareUtility.getFieldValue('VA_CallUsPhone');
    public static string HELP_PAGE_TITLE = PassengerCareUtility.getFieldValue('VA_HelpPageTitle');
    public static string FAQ_PAGE_TITLE = PassengerCareUtility.getFieldValue('VA_FAQPageTitle');
    
    //--- Object detail constants
    public static string ACCOUNT_NAME = PassengerCareUtility.getFieldValue('VA_Account');
    public static string SITE_NAME  = PassengerCareUtility.getFieldValue('VA_Site');
    public static string CONTACT_NAME = PassengerCareUtility.getFieldValue('VA_Contact');
    public static string QUEUE_NAME = PassengerCareUtility.getFieldValue('VA_Queue');
    public static string CASE_OWNER_NAME = PassengerCareUtility.getFieldValue('VA_CaseOwner');
    
    //--- Case Constants
    public static string CASE_RECORD_TYPE_NAME = PassengerCareUtility.getFieldValue('VA_CaseRT');
    public static string CASE_STATUS = PassengerCareUtility.getFieldValue('VA_CStatus');
    public static string CASE_ORIGIN = PassengerCareUtility.getFieldValue('VA_COrigin_Chat');
    public static string CASE_ORIGIN_WEB = PassengerCareUtility.getFieldValue('VA_COrigin_Web');
    public static string CASE_TYPE = PassengerCareUtility.getFieldValue('VA_CType');         
    public static string CASE_PRODUCT_FAMILY =  PassengerCareUtility.getFieldValue('VA_CPFamily');
    public static string CASE_SUBJECT =  PassengerCareUtility.getFieldValue('VA_CSubject') ;
    public static string CASE_DESCRIPTION =  PassengerCareUtility.getFieldValue('VA_CDescription');    
    public static string CASE_EMAILSUBJECT =  PassengerCareUtility.getFieldValue('VA_EmailSubject') ;
    
    //--- Help Links
    public static string LEARN_MORE_VIASAT_URL  = PassengerCareUtility.getFieldValue('VA_LearnMoreViaSatURL');  
    public static string LEARN_MORE_EXEDE_URL   = PassengerCareUtility.getFieldValue('VA_LearnMoreExedeURL'); 
    public static string PASSENGER_CARE_FAQ_URL = PassengerCareUtility.getFieldValue('VA_UrlPassengerCareFAQ'); 
    
    //--- FAQ Constants
    public static string PASSENGER_CARE_FAQ_CATEGORY_GROUP = PassengerCareUtility.getFieldValue('VA_PCFAQCategoryGroup');
    public static string FAQ_HEADER = PassengerCareUtility.getFieldValue('VA_FAQHeader');
    public static string FAQ_HEADER_TEXT = PassengerCareUtility.getFieldValue('VA_FAQHeaderText');
}