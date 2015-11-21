public class PassengerNotifyEmail{      
    public static void sendEmail(String CaseId){
        Case c = [select id,ContactId,Contact.Name,description,CaseNumber from Case Where Id =: CaseId];
        String Subject = 'Case Notification for your Service Ticket: '+case.CaseNumber;
        String  body = 'Dear '+c.Contact.Name+',<br/><br/>';
                body += 'Greetings from Exede Air!<br/><br/><br/>';
                body += 'You have recently created your Case # '+c.CaseNumber+'<br/><br/>';
                body += 'Details of your recently created case description is :  ';
                body +=  c.description+'</br>';
                body += '<br/><br/><br/><br/>';
                body += 'Thank you,<br/>';
                body += 'Exede Air Desk| Support Team';

        List<Messaging.SingleEmailMessage> lstemail = new List<Messaging.SingleEmailMessage>();
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        mail.setTargetObjectId(c.ContactId);
        mail.setSaveAsActivity(true);
        mail.setSubject(Subject);
        mail.setHtmlBody(body); 
        lstemail.add(mail);
        try{
            Messaging.sendEmail(lstemail );  
        }
        catch(Exception e){
            system.debug('#Error:'+e);
        }
        
    }   
}