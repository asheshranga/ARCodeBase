@IsTest
  public class ToowayOrderNotesControllerTest 
  { 
     static testmethod void ToowayOrderNotesControllerTest1()
     {
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
    
            //Apexpages.currentPage().getParameters().put('referrer','/OrderController');
            Apexpages.currentPage().getParameters().put('rmaid',c.Id); 
            Apexpages.currentPage().getParameters().put('id',c.Id);          
            ToowayOrderNotesController NotesController = new ToowayOrderNotesController();
            NotesController.sendNote();
            NotesController.cancel();
       }     
   }