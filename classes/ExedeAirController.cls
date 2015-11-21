public class ExedeAirController{

    public Contact con{get;set;}   
    public Account Acc{get;set;}
    QueueSObject queue;
    
    public ExedeAirController(){
        con = new Contact();
        Acc = [select Id,(select Id from Sites__r) from Account where Name = 'Virgin America' LIMIT 1];
        queue = new QueueSObject();
        queue = [Select Queue.Id from QueueSObject where Queue.Name = 'PassengerEmailSupport' LIMIT 1];        
    }
    
    public Pagereference Submit(){
    
        String Name = Apexpages.currentPage().getParameters().get('Name');
        String Email = Apexpages.currentPage().getParameters().get('Email ID'); 
        String Subject = Apexpages.currentPage().getParameters().get('Subject');
        String Description = Apexpages.currentPage().getParameters().get('Description');
        
        RecordType r = [select id, Name from recordType where Name = 'Support Services Care' and SobjectType='Case' LIMIT 1];
        
        //updated by Rakesh query with Existing contact using EmailId
        List<Contact> lstExistCon = [select Id,LastName,Title,Description,Email from Contact where Email =: Email  LIMIT 1];
        Contact CaseContact;
        if(!lstExistCon.isEmpty()){
            //updated by Rakesh if LastName not match with the given Name then exist .
            CaseContact= lstExistCon[0];            
            //if(CaseContact.LastName <> Name){
            //return null;
            //}            
        }
        else{            

            Contact NewCon = new Contact();
            NewCon.AccountId = Acc.Id;
            NewCon.LastName = Name;
            //NewCon.FirstName = 'Test';
            NewCon.Email = Email;
            insert NewCon;
            CaseContact = NewCon;
            
        }        
        case c = new case();
        c.Subject = Subject;
        c.Description = Description;
        c.ContactId = CaseContact.Id;
        c.Status = 'New';
        c.Origin = 'Care - Web';
        c.Type = 'Passenger Care';
       
        c.RecordtypeId = r.Id;
        //if(Acc.Sites__r <> null && Acc.Sites__r.size() > 0)
        //c.Site__c = Acc.Sites__r[0].Id;
        c.Site__c='a0F180000000MoQ';   
        //updated by Rakesh : Assign to Passenger Queue 
        c.OwnerId = queue.QueueId;  
                  
        insert c;
        
        //sending email to passenger
        PassengerNotifyEmail.sendEmail(c.Id);
        
        
        return  null;
    }
}