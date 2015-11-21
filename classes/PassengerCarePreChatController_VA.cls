public  class PassengerCarePreChatController_VA{ 

    //--- Variables used in visual force page
    //--- a. Chat related    
    public String LiveChatButtonID {get {return PassengerCareConstants.LIVE_CHAT_BUTTON_ID;}}

    //--- b. PreChat information related fields
    public Id CaseRecordTypeId {get{return PassengerCareUtility.getObjectRecordTypeId(CASE.SObjectType, PassengerCareConstants.CASE_RECORD_TYPE_NAME);}}
    public Id PassengerCareAccountId {get {return PassengerCareUtility.getObjectIdByName('account', PassengerCareConstants.ACCOUNT_NAME);}}
    public Id ChatSite {get{return PassengerCareUtility.getObjectIdByName('site__c',PassengerCareConstants.SITE_NAME);}}
    public string ChatOrigin {get{return PassengerCareConstants.CASE_ORIGIN_WEB;}}
    public string ChatSubject {get{return PassengerCareConstants.CASE_SUBJECT;}}
    public string ChatStatus {get{return PassengerCareConstants.CASE_STATUS;}}
    public string ChatType {get{return PassengerCareConstants.CASE_TYPE;}}
    public string ChatProductFamily {get{return PassengerCareConstants.CASE_PRODUCT_FAMILY;}}    
    
    //--- Map to hold the picklist values of field "How can we help you?" (API - PassengerCareEmailSubject__c)
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
    
    //--- Default constructor on class
    public PassengerCarePreChatController_VA(){
    }
}