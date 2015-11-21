/*
Controller    : PassengerCareHomeController_VA
Created By    : Rakesh
Created Date  : 19th August 15
Description   : Passenger Care Home Page controller Apex class 

Log :
*****************************************************************************************************************
* JIRA #     Install Date  Developer          Description                                                       *
* SMS-###    mm/dd/yyyy    FistName LastName  Brief description of change                                       *
*****************************************************************************************************************
* SMS-951    11/13/2015    Rajbabu Boopalan   Addition of Pre-Chat web form changes                             *
*---------------------------------------------------------------------------------------------------------------*
*/

public  class PassengerCareHomeController_VA{ 
    
    //--- Variables used in visual force page
    //--- a. Chat related
    public string LiveChatDeploymentURL { get {return PassengerCareConstants.LIVE_CHAT_DEPLOYMENT_URL;}}
    public string LiveChatInitURL { get {return PassengerCareConstants.LIVE_CHAT_INIT_URL;}}
    public string LiveChatCompanyInfoID { get {return PassengerCareConstants.LIVE_CHAT_COMPANY_INFO_ID;}}
    public string LiveChatDeploymentID { get {return PassengerCareConstants.LIVE_CHAR_DEPLOYMENT_ID;}}
    public String LiveChatButtonID {get {return PassengerCareConstants.LIVE_CHAT_BUTTON_ID;}}
    
    //--- b. Text related
    public string EmailToUsInfo { get {return PassengerCareConstants.EMAIL_TO_US;}}    
    public string EmailAdditionalInfo { get {return PassengerCareConstants.EMAIL_ADDITIONAL_INFO;}}
    public string ChatWithUsInfo { get {return PassengerCareConstants.CHAT_WITH_US;}}
    public string ChatAdditionalInfo { get {return PassengerCareConstants.CHAT_ADDITIONAL_INFO;}}
    public String CallUsPhone {get {return PassengerCareConstants.CALL_US_PHONE;}}
    public String LearnMoreViaSatURL {get {return PassengerCareConstants.LEARN_MORE_VIASAT_URL;}}
    public String LearnMoreExedeURL {get {return PassengerCareConstants.LEARN_MORE_EXEDE_URL;}}
    public String HelpPageTitle {get {return PassengerCareConstants.HELP_PAGE_TITLE;}}
    public String PassengerCareFAQURL {get {return PassengerCareConstants.PASSENGER_CARE_FAQ_URL;}}
    
    //--- Begin SMS-951
    //--- c. Pre-Chat information related fields
    public Id CaseRecordTypeId {get{return PassengerCareUtility.getObjectRecordTypeId(CASE.SObjectType, PassengerCareConstants.CASE_RECORD_TYPE_NAME);}}
    public Id PassengerCareAccountId {get {return PassengerCareUtility.getObjectIdByName('account', PassengerCareConstants.ACCOUNT_NAME);}}
    public Id ChatSite {get{return PassengerCareUtility.getObjectIdByName('site__c',PassengerCareConstants.SITE_NAME);}}
    public string ChatSubject {get{return PassengerCareConstants.CASE_SUBJECT;}}
    public string ChatStatus {get{return PassengerCareConstants.CASE_STATUS;}}
    public string ChatOrigin {get{return PassengerCareConstants.CASE_ORIGIN;}}    
    public string ChatType {get{return PassengerCareConstants.CASE_TYPE;}}
    public string ChatProductFamily {get{return PassengerCareConstants.CASE_PRODUCT_FAMILY;}}
    
    //--- c.i Map to hold the picklist values of field "How can we help you?" (API - PassengerCareEmailSubject__c)
    public Map<string,string> PCSubject {get{
        Map<string,string> options = new Map<string,string>();        
        Schema.DescribeFieldResult fieldResult = Case.PassengerCareEmailSubject__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        
        //--- Build a List with 'None' as the first option
        for( integer i=0; i<ple.size(); i++)
        {
            if (i==0) options.put('--None--','');
            options.put(ple[i].getLabel(),ple[i].getLabel());
        }       
        return options;
    }}
    //--- End SMS-951    
    
    //--- Case Object for email support
    public case EmailCase {get;set;}    
    
    //--- Default constructor on class
    public PassengerCareHomeController_VA(){    
        EmailCase = new case();
    }
    
    //--- Display Submit button flag;
    public boolean displaySubmitButton {get {return (displaySubmitButton==null) ? true:displaySubmitButton;} set;}
    
    //--- Submit button , when passenger click on submit on email us support
    public Pagereference Submit(){
        Contact CaseContact;    
        try{
            //--- 1. Query for Existing contact using EmailId
            Id lsAccountId = PassengerCareUtility.getObjectIdByName('account', PassengerCareConstants.ACCOUNT_NAME);            
            List<Contact> lstExistCon = [select Id,LastName,Title,Description,Email, AccountId from Contact where Email =:EmailCase.SuppliedEmail and AccountId =:lsAccountId LIMIT 1];
            if(!lstExistCon.isEmpty()){
                //--- 1a. Contact already exist.
                CaseContact= lstExistCon[0];       
            } else{                
                //--- 1b. Set the firstname, lastname based on just the name passed by user
                String lsFirstName = EmailCase.SuppliedName;
                String lsLastName = 'N/A';
                String[] loName = EmailCase.SuppliedName.split(' ');                
                if (loName.size() > 1) {
                    lsFirstName = loName[0];
                    loName[0] = '';
                    lsLastName = String.join(loName,' ');
                }
                
                //--- 1c. Create new contact
                CaseContact = new Contact();
                CaseContact.AccountId = lsAccountId;
                CaseContact.FirstName = lsFirstName;
                CaseContact.LastName = lsLastName;
                CaseContact.Email = EmailCase.SuppliedEmail;
                
                //--- 1d. Save the contact
                insert CaseContact;
            }  
            
            //---2. Set case fields        
            EmailCase.RecordtypeId = PassengerCareUtility.getObjectRecordTypeId(CASE.SObjectType, PassengerCareConstants.CASE_RECORD_TYPE_NAME);            
            EmailCase.Subject = PassengerCareConstants.CASE_EMAILSUBJECT;
            EmailCase.Status = PassengerCareConstants.CASE_STATUS;
            EmailCase.Origin = PassengerCareConstants.CASE_ORIGIN_WEB;
            EmailCase.Type = PassengerCareConstants.CASE_TYPE;       
            EmailCase.ContactId = CaseContact.Id;
            EmailCase.Site__c = PassengerCareUtility.getObjectIdByName('site__c',PassengerCareConstants.SITE_NAME);   
            EmailCase.OwnerId = PassengerCareUtility.getQueueIdByName(PassengerCareConstants.CASE_OWNER_NAME);
            
            //---3. Save case for passenger
            insert EmailCase; 
            
            //---4. Info user of successful case creation
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,((PassengerCareConstants.EMAIL_TO_US_SUCCESS_MSG==null) ? 'Thank you!':PassengerCareConstants.EMAIL_TO_US_SUCCESS_MSG)));
            
            //---4. On success, don't display submit button
            displaySubmitButton=false;
        }
        
        catch(Exception e){
            //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Error: Submitting the case - ' + e.getMessage()));
        }
        
        return  null;        
    }
}