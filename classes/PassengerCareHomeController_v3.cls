/*
    Controller : PassengerCareHomeController
    Created By : Rakesh
    Created Date : 19th August 15
    Description : 
    Log :        
*/
public  class PassengerCareHomeController_v3{

    //Desclaration   
    public Id Acc_Psgr;
    public Id Site_Psgr;
    public Id RT_Case;
    public Id GEN_ContactId;
    public Id LiveChatBusttonId{get;set;}
    public String User_Logger;
    public String Queue_Psgr;
    
    public string caseSubject{get;set;}
    public string caseDescription{get;set;}
    public string caseStatus{get;set;}
    public string contactId{get;set;}
    public string siteId{get;set;}
    public string caseOrigin{get;set;}
    public string type{get;set;}
    public string productFamily{get;set;}
    public string UrlExede{get;set;}
    public string UrlVA{get;set;}
    
 
    Contact con;   
    Account Acc;
    Site__c ServiceSite;
    QueueSObject queue;
    
    public string getLiveId(){
        Passenger_Care__c livepc = [select key__c,Value__c from Passenger_Care__c where key__c = 'LiveChatBustton'];
        if(livepc <> null){
            return [select Id,DeveloperName from LiveChatButton where DeveloperName =: livepc.value__c].Id+'';
        }
        return '';
    }
    // Default constructor on class.
    public PassengerCareHomeController_v3(){
    
        map<string,string> mapPassengerCare = new map<String,string>();
        
        // fetch default values from passenger care custom setting
        for(Passenger_Care__c pc : [select key__c,Value__c from Passenger_Care__c]){
            mapPassengerCare.put(pc.key__c,pc.Value__c);
        }
        
        if(mapPassengerCare.size() > 0 ){
        
            if(mapPassengerCare.containsKey('UrlExede')){
                UrlExede = mapPassengerCare.get('UrlExede');
            }
            if(mapPassengerCare.containsKey('UrlVA')){
                UrlVA = mapPassengerCare.get('UrlVA');
            }
            if(mapPassengerCare.containsKey('Account')){
                Acc_Psgr = [select Id from Account where Name = : mapPassengerCare.get('Account') LIMIT 1].Id;
            }
            if(mapPassengerCare.containsKey('Site')){
                siteId = Site_Psgr = [select Id from Site__c where Name = : mapPassengerCare.get('Site')  LIMIT 1].Id;
            }
            if(mapPassengerCare.containsKey('CaseRecordType')){
                RT_Case = Schema.SObjectType.Case.getRecordTypeInfosByName().get(mapPassengerCare.get('CaseRecordType')).getRecordTypeId();
            }
            if(mapPassengerCare.containsKey('Contact')){
                contactId = GEN_ContactId = [select Id from Contact where Name = : mapPassengerCare.get('Contact') LIMIT 1].Id;
            }
            if(mapPassengerCare.containsKey('User')){
                User_Logger =  mapPassengerCare.get('User') ;
            }
            if(mapPassengerCare.containsKey('Queue')){
                Queue_Psgr =  mapPassengerCare.get('Queue') ;
            }
            if(mapPassengerCare.containsKey('Subject')){
                caseSubject =  mapPassengerCare.get('Subject') ;
            }
            if(mapPassengerCare.containsKey('Description')){
                caseDescription =  mapPassengerCare.get('Description') ;
            }
            if(mapPassengerCare.containsKey('Status')){
                caseStatus =  mapPassengerCare.get('Status') ;
            }
            if(mapPassengerCare.containsKey('Origin')){
                caseOrigin =  mapPassengerCare.get('Origin') ;
            }
            if(mapPassengerCare.containsKey('Type')){
                type =  mapPassengerCare.get('Type') ;
            }
            if(mapPassengerCare.containsKey('PFamily')){
                productFamily =  mapPassengerCare.get('PFamily') ;
            }
        }
    
        con = new Contact();
        queue = new QueueSObject();
        queue = [Select Queue.Id from QueueSObject where Queue.Name =: Queue_Psgr LIMIT 1];

    }
    
    // Submit button , when passenger click on submit case via website PassengerCareHome_VA page.
    public Pagereference Submit(){
    
        try{
            // getting parameters from page.
            String Name = Apexpages.currentPage().getParameters().get('Name');
            String Email = Apexpages.currentPage().getParameters().get('Email ID'); 
            String Subject = Apexpages.currentPage().getParameters().get('Subject');
            String Description = Apexpages.currentPage().getParameters().get('Description');

            if(Email   <> null && Email  <> ''){
                Email = Email.Trim();
            }
            //Query with Existing contact using EmailId
            List<Contact> lstExistCon = [select Id,LastName,Title,Description,Email from Contact where Email =: Email  LIMIT 1];
            Contact CaseContact;
            if(!lstExistCon.isEmpty()){
                //Contact is Exist already.
                CaseContact= lstExistCon[0];       
            }
            else{            
            
                string firstname = 'N/A';
                String lastName = Name;
                
                if(Name.contains(' ')){
                    firstname = Name.split(' ')[0];
                    integer count = 0;
                    lastname = '';
                    for(String l : Name.split(' ')){
                        if(count > 0){
                            lastname += l+' ';
                        }
                        count++;
                    }
                    lastname = lastname.trim();
                    
                }
                //create New Contact
                Contact NewCon = new Contact();
                NewCon.AccountId = Acc_Psgr;
                Newcon.firstName = firstname;
                NewCon.LastName = lastName ;
                
                NewCon.Email = Email;
                insert NewCon;
                CaseContact = NewCon;
                
            }  
            
            //create case for passenger.        
            case c = new case();
            c.Subject = Subject;
            c.Description = Description;
            c.ContactId = CaseContact.Id;
            c.Status = casestatus;
            c.Origin = caseorigin;
            c.Type = type;       
            c.RecordtypeId = RT_Case;            
            c.Site__c = Site_Psgr ;   
            c.OwnerId = queue.QueueId;                
        
            // insert case for passenger
            insert c; 
            
        }catch(Exception e){
            //Send Error Log to Logger User.
            APEXCommon.SendSingleEmailViaUserId(User_Logger,'Problem with inserting a case via email service', 'Error : '+e.getMessage()); 
        }      
        
        return  null;
    }
}