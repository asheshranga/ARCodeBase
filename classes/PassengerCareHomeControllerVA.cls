/*
Controller : PassengerCareNewHanuController
Created By : Rakesh
Created Date : 19th August 15
Description : 
Log :        
*/

public  class PassengerCareHomeControllerVA{ 
    
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
    
    //--- Case Object for email support
    public case EmailCase {get;set;}
    
    //--- Chat JavaScript Case Mapping
    public string getLiveAgentCaseMapping() {
        String lsLiveAgentCaseMapping = '';
        
        lsLiveAgentCaseMapping+='liveagent.addCustomDetail("Case Subject","{0}");';
        lsLiveAgentCaseMapping+='liveagent.addCustomDetail("Case Description","{1}");';
        lsLiveAgentCaseMapping+='liveagent.addCustomDetail("Case Status", "{2}", false);';
        lsLiveAgentCaseMapping+='liveagent.addCustomDetail("ContactId", "{3}", false);';
        lsLiveAgentCaseMapping+='liveagent.addCustomDetail("SiteId", "{4}", false);';
        lsLiveAgentCaseMapping+='liveagent.addCustomDetail("CaseOrigin", "{5}", false);';
        lsLiveAgentCaseMapping+='liveagent.addCustomDetail("Type", "{6}", false);';
        lsLiveAgentCaseMapping+='liveagent.addCustomDetail("ProductFamily", "{7}", false);';
        lsLiveAgentCaseMapping+='liveagent.findOrCreate("Case").map("Subject", "Case Subject", false, false, true).map("Description", "Case Description", false, false, true).map("Status", "Case Status", false, false, true).map("Origin", "CaseOrigin", false, false, true).map("Type", "Type", false, false, true).map("ContactId", "ContactId", false, false, true).map("Site__c", "SiteId", false, false, true).map("Product_Family__c", "ProductFamily", false, false, true).saveToTranscript("CaseId").showOnCreate();';
        
        String[] loLiveAgentData = new String[] {PassengerCareConstants.CASE_SUBJECT,
            PassengerCareConstants.CASE_DESCRIPTION,
            PassengerCareConstants.CASE_STATUS,
            PassengerCareUtility.getObjectIdByName('contact',PassengerCareConstants.CONTACT_NAME),
            PassengerCareUtility.getObjectIdByName('site__c',PassengerCareConstants.SITE_NAME),
            PassengerCareConstants.CASE_ORIGIN,
            PassengerCareConstants.CASE_TYPE,
            PassengerCareConstants.CASE_PRODUCT_FAMILY};
                
                return String.format(lsLiveAgentCaseMapping,loLiveAgentData);    
    }
    
    //--- Default constructor on class
    public PassengerCareHomeControllerVA(){    
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
                //--- 1a. Contact is Exist already.
                CaseContact= lstExistCon[0];       
            } else{                
                //--- 1b. Set the firstname, lastname based on just the name passed by user
                String lsFirstName = 'N/A';
                String lsLastName =  EmailCase.SuppliedName;
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
            EmailCase.Status = PassengerCareConstants.CASE_STATUS;
            EmailCase.Origin = PassengerCareConstants.CASE_ORIGIN_WEB;
            EmailCase.Type = PassengerCareConstants.CASE_TYPE;       
            EmailCase.ContactId = CaseContact.Id;
            EmailCase.Site__c = PassengerCareUtility.getObjectIdByName('site__c',PassengerCareConstants.SITE_NAME);   
            EmailCase.OwnerId = PassengerCareUtility.getObjectIdByName('user',PassengerCareConstants.CASE_OWNER_NAME);                
            
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