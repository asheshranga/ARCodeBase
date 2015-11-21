/*
    Controller for the DAP Removal page
    Starts a livechat based on user input
        
    **********************************************************
    Audit History
    **********************************************************
    4/2/2013    Lucian Ciobanu      Created
    **********************************************************  
*/
public with sharing class KBDAPRemoval { 

    public boolean inConsole { get; set; }
    public boolean varContinue { get; set; }
    public boolean chatready { get; set; }
    public boolean pageredirect { get; set; }

    // fields that are set in the page
    public string accountName { get; set; }
    public string accountNameClean {
        get {
            return CleanForJavascript(accountName);
        }
    }
    public string previousRestrictionRemovalTickets { get; set; }
    public string identifiedTheCause { get; set; }
    public string details { get; set; }
    public string detailsClean {
        get {
            return CleanForJavascript(details);
        }
    }
    public string awareOnceInAnAccount { get; set; }
    public String liveAgentDomain {get {return KeyValueStoreHelper.getTextValue('LiveAgentDomain'); } set;}
    
    public string ChatDeploymentId { get; set; }
    public string ChatButtonId { get; set; }
    
    @TestVisible
    private string CleanForJavascript(string initial) {
        string toReturn = initial;
        toReturn = toReturn.replace('\'', '`');
        toReturn = toReturn.replace('\n', '\\n');
        toReturn = toReturn.replace('\r', '\\r');
        return toReturn;
    }

    public KBDAPRemoval() {
        inConsole = false;
        chatready = false;
        pageredirect = false;
        varContinue = false;
        
        if (!String.isEmpty(ApexPages.currentPage().getParameters().get('isdtp')))
            inConsole = true;
            
        ChatDeploymentId = KeyValueStoreHelper.getTextValue('IntLiveAgentDeploymentId');
        ChatButtonId = KeyValueStoreHelper.getTextValue('IntDAPRemovalButtonId');
        retURL = ApexPages.currentPage().getParameters().get('retURL');
    }

    private string retURL { get; set; }
    
    // action for the "Back" button
    public PageReference goBack() {
        if (String.isEmpty(retURL))
            return Page.KBHome;
        return new PageReference(retURL);
    }
    
    public PageReference chatnow(){ 
        insert newCase;
        chatready = true;
        pageredirect = true;
        
        return null;
        
    }
    
    // action for the "Chat Now" button
    public PageReference actionContinue() {
        if (accountName == '' || details == '') {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'All fields are mandatory'));
            return null;
        }
        varContinue = true;
        
        User usr = [SELECT Name, Email, Phone FROM User WHERE Id = :UserInfo.getUserId()];
        
        newCase = new Case();
        RecordType rt = [SELECT Id FROM RecordType WHERE Name = 'Denver Care' AND sObjectType = 'Case'];
        newCase.RecordTypeId = rt.Id;
        newCase.Origin = 'Care - Chat';
        newCase.SuppliedName = usr.Name;
        newCase.SuppliedEmail = usr.Email;
        newCase.SuppliedPhone = usr.Phone;
        newCase.Subject = 'DAP Removal - ' + accountName;
        newCase.Description = 'Account Number: ' + accountName + '\n';
        newCase.Description += 'Does the account have previous restriction removal tickets?: ' + previousRestrictionRemovalTickets + '\n';
        newCase.Description += 'Has the customer identified the cause of the data allowance breach?: ' + identifiedTheCause + '\n';
        newCase.Description += 'Details: ' + details + '\n';
        newCase.Description += 'Is the customer is aware that this is a once in an account lifetime removal?: ' + awareOnceInAnAccount + '\n';
        newCase.Status = 'New';
        //newCase.Category__c = 'DAP Removal';
        
        return null;
    }
    
    public Case newCase { get; set; }
}