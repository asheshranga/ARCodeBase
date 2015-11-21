public with sharing class RMANotesController {
   public string rmaid {get;set;}
   public String note{get;set;}
   String priorPage{get;set;}
    
       //--- Initialize the controller
   public RMANotesController () {
      priorPage = ApexPages.currentPage().getHeaders().get('Referer');
      rmaid     = ApexPages.currentPage().getParameters().get('rmaid');
      
      note       = null;
   }
   
    @IsTest(SeeAllData=true) public static void testsendNote() { 
        
        Account a = new Account(name = 'test');
        insert a;
        
        Address__c sadd = new Address__c(name='test street');
        sadd.Account__c = a.Id;
        sadd.Type__c = 'Ship to';
        sadd.Default__c = true;
        insert sadd;
        
        Address__c badd = new Address__c(name='test street');
        badd.Account__c = a.Id;
        badd.Type__c = 'Bill to';
        badd.Default__c = true;
        insert badd;
    
        Order__c c = new Order__c();
        c.Account__c = a.id;
        insert c;

        Apexpages.currentPage().getParameters().put('referrer','/OrderController');
        Apexpages.currentPage().getParameters().put('rmaid',c.Id);          
        RMANotesController rmaNotesController = new RMANotesController();
        rmaNotesController.sendNote();
        
    }
   
    @IsTest(SeeAllData=true) public static void testsendNote2() { 
        
        Account a = new Account(name = 'test');
        insert a;
        
        Address__c sadd = new Address__c(name='test street');
        sadd.Account__c = a.Id;
        sadd.Type__c = 'Ship to';
        sadd.Default__c = true;
        insert sadd;
        
        Address__c badd = new Address__c(name='test street');
        badd.Account__c = a.Id;
        badd.Type__c = 'Bill to';
        badd.Default__c = true;
        insert badd;
    
        Order__c c = new Order__c();
        c.Account__c = a.id;
        insert c;

        Apexpages.currentPage().getParameters().put('referrer','/OrderController');
        Apexpages.currentPage().getParameters().put('rmaid',c.Id);          
        RMANotesController rmaNotesController = new RMANotesController();
        rmaNotesController.note = 'Test';
        rmaNotesController.sendNote();
        
    }
    
    @IsTest(SeeAllData=true) public static void testsendNote3() { 
        
        Integer numOfObjs = 1;
        List<Account> accounts = ViasatTestUtility.createAccounts(numOfObjs, 'test');
        accounts[0].EBSCustomer__c = '222';
        insert accounts;
        List<Contact> contacts = ViasatTestUtility.createContacts(accounts, numOfObjs);
        insert contacts;      

        Account a = accounts[0];
        
        Address__c sadd = new Address__c(name='test street');
        sadd.Account__c = a.Id;
        sadd.Type__c = 'Ship to';
        sadd.Default__c = true;
        insert sadd;
        
        Address__c badd = new Address__c(name='test street');
        badd.Account__c = a.Id;
        badd.Type__c = 'Bill to';
        badd.Default__c = true;
        insert badd;
        
        Contact cont = contacts[0];
        
        Profile p = [SELECT Id FROM Profile WHERE Name='ViaSat RMA Customer Portal']; 
        
        User u = new User(email = 'test@test.com', EmailEncodingKey='UTF-8', LanguageLocaleKey='en_US', 
        LocaleSidKey='en_US', TimeZoneSidKey='America/Los_Angeles');
        u.ContactId = cont.Id;
        u.ProfileId = p.id;
        u.Username = 'test@test.com';
        u.Alias = 'testu';
        u.LastName = 'tlastname';
        insert u;
    
    
        Order__c c = new Order__c();
        c.Account__c = a.id;
        c.PartialShipment__c = 'No';
        c.ShipToAddress__c = sadd.Id;
        c.BillToAddress__c = badd.Id;
        c.FAA81303Required__c = 'No';
        c.Requestor__c = cont.Id;
        c.CustomerPO__c = 'test';
        c.NotesComments__c = 'test';        
        insert c;
        
            
        System.runAs(u) {
        Apexpages.currentPage().getParameters().put('referrer','/OrderController');
        Apexpages.currentPage().getParameters().put('rmaid',c.Id);          
        RMANotesController rmaNotesController = new RMANotesController();
        rmaNotesController.note = 'Test';
        rmaNotesController.sendNote();
        }
    }
    
    
    @IsTest(SeeAllData=true) public static void testcancel() { 
        
        
        Account a = new Account(name = 'test');
        insert a;
        
        Address__c sadd = new Address__c(name='test street');
        sadd.Account__c = a.Id;
        sadd.Type__c = 'Ship to';
        sadd.Default__c = true;
        insert sadd;
        
        Address__c badd = new Address__c(name='test street');
        badd.Account__c = a.Id;
        badd.Type__c = 'Bill to';
        badd.Default__c = true;
        insert badd;
        
        Order__c c = new Order__c();
        c.Account__c = a.id;
        insert c;

        Apexpages.currentPage().getParameters().put('referrer','/OrderController');
        Apexpages.currentPage().getParameters().put('rmaid',c.Id);          
        RMANotesController rmaNotesController = new RMANotesController();
        rmaNotesController.cancel();
        
    }
    

   
   public PageReference sendNote(){
    try {
        Note noteObj = new Note();
        noteObj.ParentId = rmaid;
        noteObj.IsPrivate = false;
        noteObj.Body = note;
        noteObj.Title = System.Label.RMAEscalationTitle;
        insert noteObj;
        
        EmailTemplate template = [SELECT Id from EmailTemplate where Name = :System.Label.RMAEscalationTemplate];
        User u = [select contactid from user where id = :UserInfo.getUserId()];
        List<Messaging.SingleEmailMessage>  myEmails = new List<Messaging.SingleEmailMessage>();
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        mail.setTemplateId(template.Id);
        mail.setwhatid(rmaid);
        mail.setTargetObjectId(u.contactid);
        String[] toAddresses = (System.Label.RMAEscalationEmail).split(','); 
        mail.setToAddresses(toAddresses);
        mail.SaveAsActivity = false;
        myEmails.add(mail);

        if (!Test.isRunningTest())	Messaging.sendEmail(myEmails);
         
         //--- Upon successful import return to the RMA edit page
         PageReference loRMAPage = new PageReference('/apex/OrderEdit');
         loRMAPage.getParameters().put('id',rmaid);
         
         return loRMAPage.setRedirect(true); 
      } catch (Exception e) {
         ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR,'Ooops! Unable to Escalate to CSR: ' + e.getMessage()));
         return null;                           
      }     
    
   }
    
   public PageReference cancel(){
      PageReference loRMAPage = new PageReference('/apex/OrderEdit');
      loRMAPage.getParameters().put('id',rmaid);
         
      return loRMAPage.setRedirect(true); 
    
   }
}