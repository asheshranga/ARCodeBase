/*
    Controller : PassengerCareHomeController_VA
    Created By : Rakesh
    Created Date : 19th August 15
    Description : 
    Log :        
*/

public  class PassengerCareHomeController_VA_V1{ 

  // Desclaration   
    public Id Acc_Psgr;
    public Id Site_Psgr;
    public Id RT_Case;
    public Id GEN_ContactId;
    public String LiveChatButtonId{get;set;}

    public String User_Logger;
    public String Queue_Psgr;
    
    public string caseSubject{get;set;}
    public string caseDescription{get;set;}
    public string caseStatus{get;set;}
    public string contactId{get;set;}
    public string siteId{get;set;}
    public string caseOrigin{get;set;}
    public string caseOriginWeb{get;set;}
    public string type{get;set;}
    public string productFamily{get;set;}
    public string UrlExede{get;set;}
    public string UrlVA{get;set;}
    public string ComInfoId{get;set;}
    public string LiveDepId{get;set;}
   // public string str = '57318000000CaRC';
    
    public string VA_SerMgmt{get;set;}
    public string VA_Needhelp{get;set;}
    public string VA_Callus{get;set;}
    public string VA_Emailus{get;set;}
    public string VA_Chattous{get;set;}
    public string VA_Findansweronline{get;set;}
    public string VA_Allfieldsrequired{get;set;} 
    public string VA_Contactname{get;set;}
    public string VA_Contactemail{get;set;}
    public string VA_Casesubject{get;set;}
    public string VA_Casedescription{get;set;}
    
    Contact con;   
    Account Acc;
    Site__c ServiceSite;
    QueueSObject queue;
    
    
    
    public string getLiveId(){
        return PassengerCareUtility.getFieldValue('VA_LiveChatButton'); 
    }
    
    //Default constructor on class.
    public PassengerCareHomeController_VA_V1(){
    
        VA_SerMgmt = PassengerCareUtility.getFieldValue('VA_SerMgmt');
        VA_Needhelp = PassengerCareUtility.getFieldValue('VA_Needhelp');
        VA_Callus = PassengerCareUtility.getFieldValue('VA_Callus');
        VA_Emailus = PassengerCareUtility.getFieldValue('VA_Emailus');
        VA_Chattous = PassengerCareUtility.getFieldValue('VA_Chattous');
        VA_Findansweronline = PassengerCareUtility.getFieldValue('VA_Findansweronline');
        VA_Allfieldsrequired = PassengerCareUtility.getFieldValue('VA_Allfieldsrequired');
        VA_Contactname = PassengerCareUtility.getFieldValue('VA_Contactname');
        VA_Contactemail = PassengerCareUtility.getFieldValue('VA_Contactemail');
        VA_Casesubject = PassengerCareUtility.getFieldValue('VA_Casesubject');
        VA_Casedescription = PassengerCareUtility.getFieldValue('VA_Casedescription');
       
        ComInfoId= PassengerCareUtility.getFieldValue('VA_CompanyInformationId');
        LiveDepId= PassengerCareUtility.getFieldValue('VA_LivedeploymentId');
        UrlExede = PassengerCareUtility.getFieldValue('VA_UrlExede');
        UrlVA = PassengerCareUtility.getFieldValue('VA_UrlVA');
        Acc_Psgr = [select Id from Account where Name = : PassengerCareUtility.getFieldValue('VA_Account') LIMIT 1].Id;
        siteId = Site_Psgr = [select Id from Site__c where Name = : PassengerCareUtility.getFieldValue('VA_Site')  LIMIT 1].Id;
        RT_Case = Schema.SObjectType.Case.getRecordTypeInfosByName().get(PassengerCareUtility.getFieldValue('VA_CaseRT')).getRecordTypeId();
        contactId = GEN_ContactId = [select Id from Contact where Name = : PassengerCareUtility.getFieldValue('VA_Contact') LIMIT 1].Id;
        //User_Logger =  PassengerCareUtility.getFieldValue('VA_User') ;
        User_Logger =  PassengerCareUtility.getFieldValue('User_Logger') ;
        Queue_Psgr =  PassengerCareUtility.getFieldValue('VA_Queue') ;
        caseSubject =  PassengerCareUtility.getFieldValue('VA_CSubject') ;
        caseDescription =  PassengerCareUtility.getFieldValue('VA_CDescription') ;
        caseStatus =  PassengerCareUtility.getFieldValue('VA_CStatus') ;
        caseOrigin =  PassengerCareUtility.getFieldValue('VA_COrigin_Chat') ; 
        caseOriginWeb =  PassengerCareUtility.getFieldValue('VA_COrigin_Web') ; 
        type =  PassengerCareUtility.getFieldValue('VA_CType') ;
        productFamily =  PassengerCareUtility.getFieldValue('VA_CPFamily') ;
    
       con = new Contact();
       queue = new QueueSObject();
       queue = [Select Queue.Id from QueueSObject where Queue.Name =: Queue_Psgr LIMIT 1];

    }
    
  //Submit button , when passenger click on submit case via website PassengerCareHome_VA page.
    public Pagereference Submit(){
    
      try{
  //getting parameters from page.
            String Name = Apexpages.currentPage().getParameters().get('Name');
            String Email = Apexpages.currentPage().getParameters().get('Email ID'); 
            String Subject = Apexpages.currentPage().getParameters().get('Subject');
            String Description = Apexpages.currentPage().getParameters().get('Description');

            if(Email   <> null && Email  <> ''){
               Email = Email.Trim();
            }
  //Query with Existing contact using EmailId
           // List<Contact> lstExistCon = [select Id,LastName,Title,Description,Email from Contact where Email =: Email  LIMIT 1];
            List<Contact> lstExistCon = [select Id,LastName,Title,Description,Email, AccountId from Contact where Email =: Email and AccountId =:Acc_Psgr LIMIT 1];
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
                 c.Subject = 'Test_123'+Subject;

                  c.Description = Description;
                  c.ContactId = CaseContact.Id;
                  c.Status = casestatus;
                  c.Origin = caseOriginWeb ;
                  c.Type = type;       
                  c.RecordtypeId = RT_Case;            
                  c.Site__c = Site_Psgr ;   
                  c.OwnerId = queue.QueueId;                
        
  //insert case for passenger
                  insert c; 
            }
        
              catch(Exception e){

                  }      
                  return  null;
        
    }
}