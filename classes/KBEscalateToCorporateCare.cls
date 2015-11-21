/*
    Controller for the escalate to corporate care page
    Starts a livechat based on user input
        
    **********************************************************
    Audit History
    **********************************************************
    4/4/2013    Lucian Ciobanu      Created
    **********************************************************  
*/
public with sharing class KBEscalateToCorporateCare {

    public boolean inConsole { get; set; }
    public boolean varContinue { get; set; }
    public boolean chatready { get; set; }
    public boolean pageredirect { get; set; }

    // fields that are set in the interface
    public string accountName { get; set; }
    public string accountNameClean {
        get {
            return CleanForJavascript(accountName);
        }
    }
    public string name { get; set; }
    public string nameClean {
        get {
            return CleanForJavascript(name);
        }
    }
    public string ticketNumber { get; set; }
    public string ticketNumberClean {
        get {
            return CleanForJavascript(ticketNumber);
        }
    }
    public string description { get; set; }
    public string descriptionClean {
        get {
            return CleanForJavascript(description);
        }
    }
    public string ChatDeploymentId { get; set; }
    public string ChatButtonId { get; set; }
    
    private string retURL { get; set; }
    public String liveAgentDomain {get {return KeyValueStoreHelper.getTextValue('LiveAgentDomain'); } set;}
    
    @TestVisible 
    private string CleanForJavascript(string initial) {
        string toReturn = initial;
        toReturn = toReturn.replace('\'', '`');
        toReturn = toReturn.replace('\n', '\\n');
        toReturn = toReturn.replace('\r', '\\r');
        return toReturn;
    }
    
    public KBEscalateToCorporateCare() {
        varContinue = false;
        chatready = false;
        inConsole = false;
        pageredirect = false;
        if (!String.isEmpty(ApexPages.currentPage().getParameters().get('isdtp')))
            inConsole = true;
            
        ChatDeploymentId = KeyValueStoreHelper.getTextValue('IntLiveAgentDeploymentId');
        ChatButtonId = KeyValueStoreHelper.getTextValue('IntEscalateToCorporateCareButtonId');
        retURL = ApexPages.currentPage().getParameters().get('retURL');
    }

    // action for the "Back" button
    public PageReference goBack() {
        if (String.isEmpty(retURL))
            return Page.KBHome;
        return new PageReference(retURL);
    }
    
    // action for the "Chat Now" button
    
    public PageReference chatnow(){ 
        insert newCase;
        
        chatready = true;
        pageredirect = true;
        
        return null;
        
    }
    
    public PageReference actionContinue() {
        if (String.isEmpty(accountName) || String.isEmpty(name) || String.isEmpty(description)) {
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
        newCase.Subject = 'Escalate to Corporate Care - ' + accountName;
        newCase.Description = 'Account Number: ' + accountName + '\n';
        newCase.Description += 'Name: ' + name + '\n';
        newCase.Description += 'Ticket Number: ' + ticketNumber + '\n';
        newCase.Description += 'Brief Description: ' + description + '\n';
        newCase.Status = 'New';
        //newCase.Category__c = 'Escalation Chat';
        
        return null;
/*      
        PageReference pr = Page.KBEscalateToCorporateCareStep2;
        pr.setRedirect(false);
        return pr;
        */
    }
    
    public Case newCase { get; set; }
}