//Test Method for the Apex Class ToowayThankyou
@isTest
public class ToowayThankyouControllerTest
    {  
    static testMethod void ToowayThankyouControllerTest()
      {
     /**OrderPrice__c ordp = new OrderPrice__c();
//      ordp.Name ='NTT';
        ordp.Price__c=500;   
        insert ordp; */
        
        OrderPriceList__c ordplt = new OrderPriceList__c();
        ordplt.Name ='NTT';
        insert ordplt;

        Integer numOfObjs = 1;
        List<Account> accounts = ViasatTestUtility.createAccounts(numOfObjs, 'NTT');
        accounts[0].AccountNumber='11034';
        accounts[0].Type='Prospect';
        insert accounts;
        List<Contact> contacts = ViasatTestUtility.createContacts(accounts, numOfObjs);
        insert contacts;      

        Account acc = accounts[0];
        Contact con = contacts[0];
    
        Order__c ord = new Order__c();
        ord.Account__c= acc.id ;
        ord.Requestor__c= con.Id;
        ord.AgreetoTermsConditions__c = true;
        ord.Requested_Delivery_Datepl__c='ASAP';
        insert ord;
              
        Address__c add = new Address__c();
        add.Address__c='asd';
        add.Type__c='Bill To';
        add.Account__c=acc.id;
        insert add;
         
        PageReference pgr = page.Tooway_ThankYou;
        pgr.getParameters().put('id',ord.id);
        Test.SetCurrentPage(pgr);      
        ApexPages.StandardController sc = new ApexPages.standardController(ord);
        Tooway_Thankyou Tw = new Tooway_Thankyou(sc); 
        Tw.createnew();      
     
      }
   }