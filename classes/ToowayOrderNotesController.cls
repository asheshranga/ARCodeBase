public with sharing class ToowayOrderNotesController 
{
    public string rmaid {get;set;}
    public String note{get;set;}    
        
    public ID Pid {get{
        pid = ApexPages.currentPage().getParameters().get('Id');
        return Pid;
        }set;
    }

    //--- Initialize the controller
    public ToowayOrderNotesController () 
    {       
        rmaid     = ApexPages.currentPage().getParameters().get('id');
        note       = null;
    }
       
    public PageReference sendNote()
    {
        try 
        {  
            User u = [select firstname,lastname from user where id = : UserInfo.getUserId()]; 
            Order__c  ord = [Select Name,AccountName__c from Order__c where id =: Pid];           
            String RAddress = System.Label.Tooway_Order_Note_Recipient;
            String[] toAddresses = new String[] {RAddress};
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            mail.setToAddresses(toAddresses);
            mail.setSubject('New Request from Customer');
            mail.setBccSender(false);
            mail.setUseSignature(false);
            String emailBody =  'Sales Team, <br/><br/>'; 
            emailBody = emailBody + u.firstname + ' ' + u.lastname + ' of ' + ord.AccountName__c + ' has sent the following message to you regarding an Order Request number ' + ord.Name + ' they are placing via the customer portal.';             
            emailBody += '<br/><br/>';
            emailBody = emailBody + note;           
            emailBody += '<br/><br/>';
            //emailBody += 'Regards,<br/>';
            //emailBody += u.firstname + ' ' + u.lastname;   
            mail.setHtmlBody(emailBody);
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
             
             //--- Upon successful import return to the RMA edit page
            PageReference loRMAPage = new PageReference('/apex/ToowayOrderAdmin');
            loRMAPage.getParameters().put('id',rmaid);             
            return loRMAPage.setRedirect(true); 
        } catch (Exception e) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR,'Ooops! Unable to send a note: ' + e.getMessage()));
            return null;                           
        }
    }
        
    public PageReference cancel()
    {        
        PageReference Page = new PageReference('/apex/ToowayOrderReview?id='+Pid); 
        Page.setRedirect(true);
        return Page;  
    }
}