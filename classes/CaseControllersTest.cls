/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an organization are executed whenever Apex code is deployed
 * to a production organization to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production organization. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the organization size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */ 
@isTest
private class CaseControllersTest 
{
    // TESTS FOR Case Search Controllers:
    
    // Initialize needed custom settings
    public static void setCustomSettings() 
    {  
        ViasatTestUtility.setNBNCoKeyvalueStore();
        ViasatTestUtility.setGlobals();
        ViasatTestUtility.setCaseKeyValueStore();
    }
        
    //*************************************************************************************
    static testMethod void testCaseSearchController() 
    {
        list<Account> accounts = ViasatTestUtility.createAccounts(1, 'Test Acc');
        insert accounts; 
        list<Contact> contacts = ViasatTestUtility.createContacts(accounts, 2); // two contacts for account
        insert contacts; 
        
        // Create two 'Carlsbad NOC' Cases 
        list<Case> lstcase = ViasatTestUtility.createCases(accounts, contacts, 'Carlsbad NOC');
        insert lstcase;

        Test.startTest();           
        
        PageReference pageRef = Page.CaseSearchNOC;
        Test.setCurrentPageReference(pageRef);

        CaseSearchController controller = new CaseSearchController();
        Apexpages.currentPage().getParameters().put('status','New');
        Apexpages.currentPage().getParameters().put('accountname','');
        Apexpages.currentPage().getParameters().put('contactname','');
        Apexpages.currentPage().getParameters().put('productname','');
        Apexpages.currentPage().getParameters().put('ownername','');
        Apexpages.currentPage().getParameters().put('casenumber','');

        PageReference pr = controller.runSearch();
        List<String> loString = controller.statuses;
        loString = controller.networks;
        controller.toggleSort();
        
    //String lsOut=null;
    //List<String> loString=null;    
    //controller.runQuery();          
    String lsField = controller.sortField;        
    List<Case> c = controller.cases;
    Integer s = controller.resultSize;
    Boolean p = controller.hasNext;
    Boolean n = controller.hasPrev;
    String r = controller.recordInfo;
    String p1 = controller.pageInfo;
    
    controller.next();
    controller.previous();
    controller.last();
    controller.first();

        controller.exportResults();

        Test.stopTest();
    }

    //*************************************************************************************
    // TEST CaseSearchNOCController which is an extension to CaseSearchController
    static testMethod void testCaseSearchNOCController() 
    {
        list<Account> accounts = ViasatTestUtility.createAccounts(1, 'Test Acc');
        insert accounts; 
        list<Contact> contacts = ViasatTestUtility.createContacts(accounts, 2); // two contacts for account
        insert contacts; 
        
        // Create two 'Carlsbad NOC' Cases 
        list<Case> lstcase = ViasatTestUtility.createCases(accounts, contacts, 'Carlsbad NOC');
        insert lstcase;

        Test.startTest();           
        
        //CaseSearchController controller = new CaseSearchController();

        // Instantiate a new controller with all parameters in the page
        PageReference pRef = Page.CaseSearchNOC;
        Test.setCurrentPageReference(pRef);

        CaseSearchNOCController cnt = new CaseSearchNOCController();//controller);
      
        cnt.dummyStartDates.type = 'Change Request';
        cnt.dummyStartDates.status = 'Open';
        cnt.dummyStartDates.dummystartdate__c = Date.today();
        cnt.dummyEndDates.dummystartdate__c   = Date.today();
        cnt.dummyStartDates.dummyenddate__c   = Date.today();
        cnt.dummyEndDates.dummyenddate__c     = Date.today();
    
        Apexpages.currentPage().getParameters().put('accountname','test');
        Apexpages.currentPage().getParameters().put('contactname','test');
        Apexpages.currentPage().getParameters().put('productname','test');
        Apexpages.currentPage().getParameters().put('ownername','test');
        Apexpages.currentPage().getParameters().put('casenumber','123');
    
        cnt.runSearch();  

        cnt.toggleSort();
        
    String lsField = cnt.sortField;        
    List<Case> c = cnt.cases;
    Integer s = cnt.resultSize;
    Boolean p = cnt.hasNext;
    Boolean n = cnt.hasPrev;
    String r = cnt.recordInfo;
    String p1 = cnt.pageInfo;
    
    cnt.next();
    cnt.previous();
    cnt.last();
    cnt.first();

        cnt.exportResults();

        Test.stopTest();    
    }    
  
    //*************************************************************************************
    static testMethod void testCaseResolution() 
    {
        Product2 p = new Product2 (name='test');
        insert p;
       
        resolution__c r1 = new resolution__c(name='Level 1 Res Code', product__c=p.id);
        insert r1;
       
        resolution__c r2 = new resolution__c(name='Level 2 Res Code', product__c=p.id, parent__c=r1.id);
        insert r2;

        resolution__c r3 = new resolution__c(name='Level 3 Res Code', product__c=p.id, parent__c=r2.id);
        insert r3;

        // Instantiate a new controller with all parameters in the page       
        list<Account> accounts = ViasatTestUtility.createAccounts(1, 'Test Acc');
        insert accounts; 
        list<Contact> contacts = ViasatTestUtility.createContacts(accounts, 1); // two contacts for account
        insert contacts; 
        
        list<Case> lstcase = ViasatTestUtility.createCases(accounts, contacts, 'Carlsbad NOC');
        Case c = lstcase[0];
        c.productid = p.id;
       c.eventstarttime__c = Date.today()-1;
       c.eventendtime__c = Date.today();
       c.statusdetails__c = 'Waiting RFO';
       c.resolutiondescription__c = 'Test';
       c.actiontaken__c = 'Other';
        insert c;

        Test.startTest();           
        
        ApexPages.Standardcontroller controller = new ApexPages.Standardcontroller(c);
        CaseResolution cr = new CaseResolution(controller);
      
        PageReference pRef = Page.CaseResolution;
        Test.setCurrentPageReference(pRef);

        Apexpages.currentPage().getParameters().put('selectedResCode', r3.id);  
        Apexpages.currentPage().getParameters().put('selectedResCode', r2.id); 
        Apexpages.currentPage().getParameters().put('selectedResCode', r1.id);
         
        // not visible
       //cr.getoffsetMinutes('America/New_York'); 
      
       List<SelectOption> so = cr.timeZones;
       
       cr.refreshResCodes();
       cr.setResCode('Level 3 Res Code');
       cr.searchResCodes();
       cr.setResCodes();
       so = cr.level3ResCodes;        
 
       cr.setResCode('Level 2 Res Code');
       cr.searchResCodes();
       cr.setResCodes(); 
 
       cr.setResCode('Level 1 Res Code');
       cr.searchResCodes();  
      cr.setResCodes(); 
              
       String s = cr.getresCode();

       so = cr.level1ResCodes;
       so = cr.level2ResCodes;
 
       cr.setlevel1ResCode(r1.id);
       cr.setlevel2ResCode(r2.id);  
       cr.setlevel3ResCode(r3.id);                        
       

       s = cr.getstartTimeZone();
       s = cr.getendTimeZone();
       cr.setstartTimeZone('America/Denver');       
       cr.setendTimeZone('America/Denver');         

                     
       try {
         PageReference x = cr.resolveCase();
       }
       catch(Exception e) {
         // Do nothing
       }

       Case c1 = new Case(status='Resolved');
       controller = new ApexPages.Standardcontroller(c1);
       cr = new CaseResolution(controller);
                                         
       cr.setlevel1ResCode('');
       cr.setlevel2ResCode('');  
       cr.setlevel3ResCode('');                        
       s = cr.getlevel1ResCode();
       s = cr.getlevel2ResCode();
       s = cr.getlevel3ResCode();
       PageReference x = cr.resolveCase(); 

       Case c2 = new Case();
       controller = new ApexPages.Standardcontroller(c2);
       cr = new CaseResolution(controller);
       
       Apexpages.currentPage().getParameters().put('level','1');
       cr.refreshResCodes();
       x = cr.resolveCase();
       
       Test.stopTest(); 
    }     

    //*************************************************************************************
    public static testmethod void CaseReasonForOutageTest() 
    {
        List<Account> accounts = ViasatTestUtility.createAccounts(1, 'testCaseReason');
        insert accounts;

        List<Contact> contacts = ViasatTestUtility.createContacts(accounts, 1);
        insert contacts;

        RecordType rt=[SELECT Id,Name FROM RecordType WHERE SObjectType = 'Case' AND recordType.name='Carlsbad NOC'];
        
        string profileName = 'ViaSat NOC Customer Portal';
        User u  = ViasatTestUtility.createUser(contacts[0], profileName);
        insert u;

        Account acc1 = accounts[0];
        Contact con = contacts[0];
                   
        Site__c sit = new Site__c();
            sit.CurrencyIsoCode = 'USD';
            sit.Account__c = acc1.id; 
            sit.SiteName__c = 'mySiteCaseReason';          
        insert sit;                 
           
        Case c = new Case();
            c.Start_Labor_Hour__c = true;
            c.site__c = sit.ID;
            c.Status = 'New';
            c.Type = 'Administrative';
            c.Category__c = 'Account';
            c.Origin = 'Email';
            c.VisibleToCustomer__c = 'Yes';
            c.Subject = 'Tesing Ntt Data';
            c.Description = 'Tesing Ntt Data123';
            c.accountid = acc1.id; 
            c.ownerid=u.id;    
            c.ContactId=con.Id;  
            c.recordTypeId =rt.Id;         
        insert c;                

        Test.startTest();                  
            
        PageReference pageRef=Page.CaseReasonForOutage;             
        Test.setCurrentPage(pageRef);                       
        system.runas(u)
        {       
                ApexPages.StandardController controller = new ApexPages.StandardController(c);            
                Apexpages.currentPage().getParameters().put('Id',c.id);           
                CaseReasonForOutage caseRequest = new CaseReasonForOutage(controller);                      
                CaseComment comm = new CaseComment();
                comm.ParentId = c.Id;
                comm.CommentBody = 'test';
                insert comm;
        }
                CaseComment comm2 = new CaseComment();
                comm2.ParentId = c.Id;
                comm2.CommentBody = 'test';
                insert comm2;
        Test.stopTest(); 
    }
     
    static testmethod void ViaSatNOCclosedCommentTest()
    {     
        List<Account> accounts = ViasatTestUtility.createAccounts(1, 'NBNCo');
        accounts[0].ShippingStreet = 'test street';
        insert accounts;
        
        Integer numOfObjsPerAccounts = 1; 
        List<Contact> contacts = ViasatTestUtility.createContacts(accounts, numOfObjsPerAccounts);
        insert contacts;  

        RecordType rt=[SELECT Id,Name FROM RecordType WHERE SObjectType = 'Case' AND recordType.name='Support Services NBN Co'];

        Test.startTest();                  
          
        //Account acc1 List<Account> accounts
        //Contact con
        numOfObjsPerAccounts = 7;
        List<SLA__c> listSLA = ViasatTestUtility.createSLAObjs(accounts, numOfObjsPerAccounts);
        for (SLA__c o : listSLA)
           o.CaseType__C='Problem';
        insert listSLA;   

        Case cc = new Case();
          cc.accountid = accounts[0].id; 
          cc.ContactId = contacts[0].id;          
          cc.Status = 'New';
          cc.Type = 'Problem';            
          cc.NetworkPicklist__c = 'NBNCo';
          cc.PrioritybasedonType__c='1 - Critical';
          cc.Origin = 'Email';
          cc.VisibleToCustomer__c = 'Yes';
          cc.Subject = 'Tesing Ntt Data';
          cc.Description = 'Tesing Ntt Data123';        
          cc.subSystem__c='test'; 
          cc.recordTypeId=rt.id;//'01270000000Hn6A';              
          insert cc;        
        CaseComment cmt=new CaseComment();
         cmt.CommentBody='Test';
         cmt.ParentId=cc.id;
         insert cmt; 
        Test.stopTest(); 
    }

    //*************************************************************************************
    //Test class for caseRedirect class
    static testmethod void CaseRedirectTest1()
    {         
        setCustomSettings();

      Map<String, Schema.RecordTypeInfo> rtMapByName = Schema.SObjectType.Case.getRecordTypeInfosByName(); 
      String rtCarlsbad =  rtMapByName.get('Carlsbad NOC').getRecordTypeId(); 
      String rtSupportService =  rtMapByName.get('Support Services NBN Co').getRecordTypeId();   
        
        RecordType rt = [SELECT Id, Name FROM RecordType WHERE SObjectType = 'Site__c' AND recordType.name='Aviation - Commercial'];

        profile p = [select id, name from profile where name='Outside Sales Standard + Carlsbad NOC' limit 1];    
        User usr = new User(Alias = 'testCase', Email='CaseRedirect@testorg.com', 
        EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
        LocaleSidKey='en_US', ProfileId = p.Id, 
        TimeZoneSidKey='America/Los_Angeles', UserName='CaseRedirect1@testorg.com');
        insert usr;
        system.debug('temp+++++'+usr.profileId);  
    
        system.runAs(usr)
        {
            List<Account> accounts = ViasatTestUtility.createAccounts(1, 'NBNCo');
            insert accounts;

            List<Contact> contacts = ViasatTestUtility.createContacts(accounts, 1);
            insert contacts; 
        
            List<SLA__c> listSLA = ViasatTestUtility.createSLAObjs(accounts, 7);
            insert listSLA;      
            
            List<Product2> ps = ViasatTestUtility.createProducts(1, null, null);
            Product2 pdt = ps[0];
            insert pdt;       

            Site__c sit = new Site__c();
            sit.recordTypeId = rt.Id;
            sit.SiteName__c='12345';
            sit.CurrencyIsoCode = 'USD';
            sit.Program__c = 'AECN';
            sit.Product__c = pdt.id;
            sit.AlternateSiteNames__c = 'test';
            sit.Account__c = accounts[0].id; 
            sit.SatelliteIP__c='123.123.123.123';          
            insert sit;
                        
            List<case> ListCases=new List<case>();                     

            List<Case> cases = ViasatTestUtility.createCases(accounts, contacts, 'Carlsbad NOC');                       
          //cases[0].Start_Labor_Hour__c = true;
            cases[0].site__c = sit.ID;
            cases[0].contactid = null;
            cases[0].productid = pdt.id;             
            cases[0].Type = 'Administrative';
            cases[0].Category__c = 'Account';            
            ListCases.addAll(cases);
            
            List<Case> cases2 = ViasatTestUtility.createCases(accounts, contacts, 'Support Services NBN Co');                       
            cases2[0].CaseContact__c=contacts[0].id;                   
            ListCases.addAll(cases2);
            
            insert ListCases;
            
            LaborHour__c lh1 = new LaborHour__c();
            lh1.Case__c = cases2[0].id;        
            lh1.User__c = usr.id; 
            lh1.StartTime__c = System.now();
            insert lh1;             
        
            Case caseInfo = [Select Id, Labor_Hours_Required__c,Ownerid,CaseNumber from Case where id =:cases2[0].id ];
                
          Contact conts = new Contact();
          conts.CurrencyIsoCode = 'USD';
          conts.LastName = 'Ravi';
          conts.FirstName = 'Ravi';
          conts.Accountid = accounts[0].id; 
          conts.Email = 'abc@gmail.com';
          conts.Case_Id_Reference__c=caseInfo.casenumber;        
          insert conts; 
          
            System.assertEquals(caseInfo.casenumber, conts.Case_Id_Reference__c);

            Test.startTest();                       
          
            ApexPages.StandardController Redir= new ApexPages.StandardController(cases2[0]);           
            caseRedirect caseRedirectControl = new caseRedirect(Redir); 

            caseRedirectControl.redirect();
            
    Site__c st = caseRedirectControl.sites;
    caseRedirectControl.siteID = sit.id;
    boolean b = caseRedirectControl.selectRecordType; 


    Redir= new ApexPages.StandardController(cases2[0]);      
    ApexPages.currentPage().getParameters().put('RecordType',rtCarlsbad);   
    ApexPages.currentPage().getParameters().put('RecordType',rtCarlsbad);   
    caseRedirectControl = new caseRedirect(Redir); 
    caseRedirectControl.redirect();

            Test.stopTest();                  
        }
    }
    
/*   
  
     static testmethod void CaseRedirectTest2()
     {        
        setCustomSettings();
    profile p = [select id, name from profile where name='Carlsbad NOC' limit 1];    
    User usr = new User(Alias = 'Case2', Email='CaseRedirect@testorg.com', 
      EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
      LocaleSidKey='en_US', ProfileId = p.Id, 
      TimeZoneSidKey='America/Los_Angeles', UserName='CaseRedirect2@testorg.com');
    insert usr;
   
        system.runAs(usr){
    Account acc1 = new Account();
          acc1.Name = 'NBNCo';
          acc1.CurrencyIsoCode = 'USD';
          acc1.Labor_Hours_Required__c = 'Yes';
          acc1.ShippingStreet = 'test street';
          acc1.Status__c = 'Customer'; 
          acc1.BillingStreet='street';
          acc1.BillingCity='city';
          acc1.BillingState='state';           
          insert acc1; 
          
     Contact con = new Contact();
          con.CurrencyIsoCode = 'USD';
          con.LastName = 'Ravi';
          con.FirstName = 'Ravi';
          con.Accountid = acc1.id; 
          con.Email = 'abc@gmail.com';
          insert con;  
          
    List<SLA__c> listSLA=new List<SLA__c>();
    SLA__c sla1=new SLA__C();
           sla1.CasePriority__C='1 - Critical';          
           sla1.Account__c=acc1.Id;
           sla1.CaseType__C='Problem';
           sla1.SLAinitialResponseTime__c='20 Minutes';
           sla1.SLAresolutiontime__c='3 Days';
           sla1.SLAWorkaroundtime__c='12 Hours';
           sla1.CurrencyIsoCode = 'USD';
           listSLA.add(sla1);
    SLA__c sla2=new SLA__C();      
           sla2.CasePriority__C='1 - Critical';          
           sla2.Account__c=acc1.Id;
           sla2.CaseType__C='Problem';
           sla2.SLAinitialResponseTime__c='20 Minutes';
           sla2.SLAresolutiontime__c='3 Days';
           sla2.SLAWorkaroundtime__c='12 Hours';
           sla2.CurrencyIsoCode = 'USD';
           listSLA.add(sla2);
    SLA__c sla3=new SLA__C();            
           sla3.CasePriority__C='1 - Critical';          
           sla3.Account__c=acc1.Id;
           sla3.CaseType__C='Problem';
           sla3.SLAinitialResponseTime__c='20 Minutes';
           sla3.SLAresolutiontime__c='3 Days';
           sla3.SLAWorkaroundtime__c='12 Hours';
           sla3.CurrencyIsoCode = 'USD';
           listSLA.add(sla3);
    SLA__c sla4=new SLA__C();        
           sla4.CasePriority__C='1 - Critical';          
           sla4.Account__c=acc1.Id;
           sla4.CaseType__C='Problem';
           sla4.SLAinitialResponseTime__c='20 Minutes';
           sla4.SLAresolutiontime__c='3 Days';
           sla4.SLAWorkaroundtime__c='12 Hours';
           sla4.CurrencyIsoCode = 'USD';
           listSLA.add(sla4);
    SLA__c sla5=new SLA__C();     
           sla5.CasePriority__C='1 - Critical';          
           sla5.Account__c=acc1.Id;
           sla5.CaseType__C='Problem';
           sla5.SLAinitialResponseTime__c='20 Minutes';
           sla5.SLAresolutiontime__c='3 Days';
           sla5.SLAWorkaroundtime__c='12 Hours';   
           sla5.CurrencyIsoCode = 'USD';
           listSLA.add(sla5);
    SLA__c sla6=new SLA__C();       
           sla6.CasePriority__C='1 - Critical';          
           sla6.Account__c=acc1.Id;
           sla6.CaseType__C='Problem';
           sla6.SLAinitialResponseTime__c='20 Minutes';
           sla6.SLAresolutiontime__c='3 Days';
           sla6.SLAWorkaroundtime__c='12 Hours';
           sla6.CurrencyIsoCode = 'USD';
           listSLA.add(sla6);
    SLA__c sla7=new SLA__C();         
           sla7.CasePriority__C='1 - Critical';          
           sla7.Account__c=acc1.Id;
           sla7.CaseType__C='Problem';
           sla7.SLAinitialResponseTime__c='20 Minutes';
           sla7.SLAresolutiontime__c='3 Days';
           sla7.SLAWorkaroundtime__c='12 Hours'; 
           sla7.CurrencyIsoCode = 'USD' ;
           listSLA.add(sla7);
           insert listSLA;   
            
        List<Product2> ps = ViasatTestUtility.createProducts(1, null, null);
        Product2 pdt = ps[0];
            insert pdt;       
            
      Site__c sit = new Site__c();
            sit.SiteName__c='12345';
            sit.CurrencyIsoCode = 'USD';
            sit.Program__c = 'AECN';
            sit.Product__c = pdt.id;
            sit.AlternateSiteNames__c = 'test';
            sit.Account__c = acc1.id; 
            sit.SatelliteIP__c='123.123.123.123';          
            insert sit;            
      Map<String, Schema.RecordTypeInfo> rtMapByName = Schema.SObjectType.Case.getRecordTypeInfosByName(); 
      String rtCarlsbad =  rtMapByName.get('Carlsbad NOC').getRecordTypeId(); 
      String rtSupportService =  rtMapByName.get('Support Services NBN Co').getRecordTypeId();   
      List<case> ListCases=new List<case>();                     
       Case c = new Case();    
          //  c.Start_Labor_Hour__c = true;
            c.site__c = sit.ID;
            c.accountid = acc1.id;
            c.productid = pdt.id;             
            c.Type = 'Administrative';
            c.Category__c = 'Account';            
            c.Origin = 'Email';
            c.VisibleToCustomer__c = 'Yes';
            c.Status = 'New';           
            c.Subject = 'Tesing Ntt Data';
            c.Description = 'Tesing Ntt Data123';
            c.RecordTypeId=rtCarlsbad;     
            c.CaseContact__c= con.id;                                                         
            ListCases.add(c);
      Case cc = new Case();
           cc.accountid = acc1.id; 
           cc.ContactId = con.id;          
           cc.Status = 'New';
           cc.Type = 'Problem';            
           cc.NetworkPicklist__c = 'NBNCo';
           cc.PrioritybasedonType__c='1 - Critical';
           cc.Origin = 'Email';
           cc.VisibleToCustomer__c = 'Yes';
           cc.Subject = 'Tesing Ntt Data';
           cc.Description = 'Tesing Ntt Data123';        
           cc.subSystem__c='test'; 
           cc.recordTypeId=rtSupportService;   
           cc.CaseContact__c=con.id;                   
           ListCases.add(cc); 
           insert ListCases;
            
            LaborHour__c lh1 = new LaborHour__c();
            lh1.Case__c = c.id;        
            lh1.User__c = usr.id; 
            lh1.StartTime__c = System.now();
            insert lh1;             
        
       //For ContactAfter trigger  
       //**** Start****                                 
     
       
       Case caseInfo = [Select Id, Labor_Hours_Required__c,Ownerid,CaseNumber from Case where id =:cc.id ];
          system.debug(' caseInfo+++'+caseInfo);     
          Contact conts = new Contact();
          conts.CurrencyIsoCode = 'USD';
          conts.LastName = 'Ravi';
          conts.FirstName = 'Ravi';
          conts.Accountid = acc1.id; 
          conts.Email = 'abc@gmail.com';
          conts.Case_Id_Reference__c=caseInfo.casenumber;        
          insert conts; 
          
         //****End****
          System.assertEquals(caseInfo.casenumber, conts.Case_Id_Reference__c);
          
          Test.startTest();                  
          ApexPages.StandardController Redir= new ApexPages.StandardController(cc);      
          ApexPages.currentPage().getParameters().put('RecordType',rtCarlsbad);   
          caseRedirect caseRedirectControl = new caseRedirect(Redir); 
          caseRedirectControl.redirect();
          Test.stopTest();                  
        }
    }  
*/

    //*************************************************************************************
    //Test Method for the Apex Class CaseEscalation

    //Instantiate all data for the new controller 
    private static User RunUser;
    private static Case CaseEscalationCreate()
    {
        Profile p = [SELECT Id,Name FROM Profile where Name  = 'IT: System Administrator' limit 1];
        RunUser = [SELECT ContactId,Name FROM User where Profileid =: p.id and isActive = true limit 1];
               
        Integer numOfObjs = 1;
        List<Account> accounts = ViasatTestUtility.createAccounts(numOfObjs, 'dummyTestAcc');
        insert accounts;
        List<Contact> contacts = ViasatTestUtility.createContacts(accounts, numOfObjs);
        insert contacts;      
             
        Case c = new Case();
        c.Origin = 'Email';
        c.VisibleToCustomer__c = 'Yes';
        c.Type = 'Change Request';
        c.Status = 'Working';
        c.Subject = 'My Test';
        c.Priority = 'Medium';
        c.Description = 'Hai This is NTT DATA';
        c.AccountID = accounts[0].id;
        c.ContactID = contacts[0].id;
        insert c;
        
        LaborHour__c lh = new LaborHour__c();
        lh.Case__c = c.id;
        lh.CaseResolved__c = true;
        lh.User__c = RunUser.id; 
        insert lh;  
        
        Site__c sit = new Site__c();
        sit.CurrencyIsoCode = 'USD';
        sit.Account__c = accounts[0].id;
        sit.SiteName__c = 'mySite1';
        insert sit;

        return c;
    }
                    
    public static testMethod void CaseEscalationTest1()
    {
        //Instantiate a new controller with all parameters in the page
        Case c = CaseEscalationCreate();
        c.statusDetails__c = 'Tier 4';
        update c;
        casehistory  ch = new casehistory ();
        ch.field = 'StatusDetails__c';
        ch.caseid = c.id;
        insert ch; 
               
        Test.startTest();       
        Schema.DescribeSObjectResult OnDesc = Schema.SObjectType.OnCallSchedule__c;
        Map<String,Schema.RecordTypeInfo> OnRTMapByName = OnDesc.getRecordTypeInfosByName();
        Schema.RecordTypeInfo OnRTByName = OnRTMapByName.get('Tier 4');
        ID OnRecId = OnRTByName.getRecordTypeId(); 
               
        OnCallSchedule__c  oc = new OnCallSchedule__c ();
        oc.StartDate__c = Date.today();
        oc.EndDate__c = Date.today()+1;
        oc.StartTime__c = '08:00';
        oc.EndTime__c = '7:59';
        oc.CallSequence__c = 10;
        oc.CaseType__c = 'Change Request';
        oc.program__c = 'AECN';
        oc.recordtypeID = OnRecId;
        oc.product__c = c.ProductID;
        oc.casetype__c = c.Type;
        oc.program__c = 'All';     
        insert oc;
        
        EscalationCheckList__c estlist = new EscalationCheckList__c();
        estlist.CurrencyIsoCode = 'USD';
        estlist.Case__c = c.id;
        insert estlist;
       
        Escalation__c esc = new Escalation__c();
        esc.Program__c = 'All';
        esc.Tiers__c = 'Tier 1';
        esc.CurrencyIsoCode = 'USD';
        insert esc;
        
        List<EscalationCheckList__c> Elist = new List<EscalationCheckList__c>();
        EscalationCheckList__c e1 = new EscalationCheckList__c();
        e1.case__c = c.id;
        Elist.add(estlist);
          
        //Case c = new Case();
        ApexPages.Standardcontroller controller = new ApexPages.Standardcontroller(c);
        //Apexpages.currentPage().getParameters().put('selectedtier','Tier 1');
        CaseEscalation ce = new CaseEscalation(controller);
        EscalationCheckList__c e = ce.ec;
        //ce.selectedUserId=RunUser.id;
        
        String s = ce.escalateTo;
        s = ce.escalationStep;
        s = ce.result;
        Integer i = ce.errorCode;
   
        List<String> l = ce.escalationTiers;
        List<List<String>> l1 = ce.escalationPath;
       
        Boolean b = ce.renderStatus;
       
        List<OnCallSchedule__c> u = ce.supportUsers;
        List<SelectOption> tiers = ce.getTiers();
        List<SelectOption> ec = ce.escalationCheckLists;
        s = ce.escalationCheckListId;
        ce.escalationCheckListId = '1234';
        s = ce.getescalationCheckListId();
        ce.setescalationCheckListId('1234');
       
        s = ce.getselectedTier();
        ce.setselectedTier('Tier 4');
   
        Apexpages.currentPage().getParameters().put('selectedResCode','Baseband');       
        PageReference x = ce.userSelected();
        x = ce.checkListSelection();
        x = ce.userSelectedManually();
       
        ce.escalateCase();   
        x = ce.save();
        ce.escalationCheckListId = 'NA';
        x = ce.checkListSelection();
        c = new Case(status='Closed',resolutiondescription__c = 'Test');//,ClosedDate = date.today());
        controller = new ApexPages.Standardcontroller(c);
        Apexpages.currentPage().getParameters().put('selectedtier','Tier 1');
        ce = new CaseEscalation(controller);
        ce.getselectedUserId();
        ce.getselectedUserName();
        ce.escalateCase();
        ce.checkListSelection();
        s = ce.getselectedUserName();
        ce.setselectedUserName('test');
        ce.setselectedUserId('test');    
        Test.stopTest();       
    } 
          
    public static testMethod void CaseEscalationTest2() 
    {
        //Instantiate a new controller with all parameters in the page
        Case c = CaseEscalationCreate();

        Site__c sit = [SELECT id FROM Site__c WHERE Account__c =: c.AccountID limit 1];        
        c.site__c = sit.id;
        c.statusDetails__c = 'Tier 4';
        update c;

        casehistory  ch = new casehistory ();
        ch.field = 'StatusDetails__c';
        ch.caseid = c.id;
        insert ch;  

        Test.startTest();       
        
        Schema.DescribeSObjectResult OnDesc = Schema.SObjectType.OnCallSchedule__c;
        Map<String,Schema.RecordTypeInfo> OnRTMapByName = OnDesc .getRecordTypeInfosByName();
        Schema.RecordTypeInfo OnRTByName = OnRTMapByName .get('Tier 4');
        ID OnRecId = OnRTByName.getRecordTypeId(); 
        
        Schema.DescribeSObjectResult OnDesc1 = Schema.SObjectType.EscalationCheckList__c;
        Map<String,Schema.RecordTypeInfo> OnRTMapByName1 = OnDesc1.getRecordTypeInfosByName();
        Schema.RecordTypeInfo OnRTByName1 = OnRTMapByName1.get('RF Connectivity Issue');
        ID EScId = OnRTByName1.getRecordTypeId();
                
        OnCallSchedule__c  oc = new OnCallSchedule__c ();
        oc.StartDate__c = system.today();
        oc.EndDate__c = system.today()+1;
        oc.StartTime__c = '8:00';
        oc.EndTime__c = '7:59';
        oc.CallSequence__c = 10;
        oc.CaseType__c = 'Change Request';
        oc.program__c = 'AECN';
        oc.recordtypeID = OnRecId;
        oc.Product__c = c.ProductID;
        oc.casetype__c = c.Type;
        oc.program__c = 'All';        
        insert oc;

        EscalationCheckList__c estlist = new EscalationCheckList__c();
        estlist.CurrencyIsoCode = 'USD';
        estlist.Case__c = c.id;
        estlist.RecordTypeId=EScId;
        insert estlist;
             
        
        List<EscalationCheckList__c> Elist = new List<EscalationCheckList__c>();
        EscalationCheckList__c e1 = new EscalationCheckList__c();
        e1.case__c = c.id;
        Elist.add(estlist);
          
        //Case c = new Case();
        ApexPages.Standardcontroller controller = new ApexPages.Standardcontroller(c);
        //Apexpages.currentPage().getParameters().put('selectedtier','Tier 1');
        CaseEscalation ce = new CaseEscalation(controller);
        EscalationCheckList__c e = ce.ec;
        String s = ce.escalateTo;
        s = ce.escalationStep;
        s = ce.result;
        Integer i = ce.errorCode;
      
        List<String> l = ce.escalationTiers;
        List<List<String>> l1 = ce.escalationPath;
       
        Boolean b = ce.renderStatus;
       
        List<OnCallSchedule__c> u = ce.supportUsers;
        List<SelectOption> tiers = ce.getTiers();
        List<SelectOption> ec = ce.escalationCheckLists;
        List<Case> casesToUpdate = new List<Case>(); 
        c.Description = 'Hai This is Legacy Keane';
        casesToUpdate.add(c);
        update casesToUpdate;        
        s = ce.escalationCheckListId;
        ce.escalationCheckListId = EScId;
        s = ce.getescalationCheckListId();
        ce.setescalationCheckListId(EScId);
        s = ce.getselectedTier();
        ce.setselectedTier('Tier 4');
      
        Apexpages.currentPage().getParameters().put('selectedResCode','Baseband');       
        PageReference x = ce.userSelected();
        x = ce.checkListSelection();
        x = ce.userSelectedManually();
        ce.escalateCase();
        x = ce.save();
        ce.escalationCheckListId = 'NA';
        x = ce.checkListSelection();
         
        c = new Case(status='Closed',resolutiondescription__c = 'Test');//,ClosedDate=date.today());
        insert c;
        controller = new ApexPages.Standardcontroller(c);
        Apexpages.currentPage().getParameters().put('selectedtier','Tier 1');
        ce = new CaseEscalation(controller);        
        ce.getselectedUserName();
        ce.escalateCase();
        ce.checkListSelection();
        s = ce.getselectedUserName();
        ce.setselectedUserName('test');
        ce.setselectedUserId(RunUser.Id);
        ce.getselectedUserId();
        system.debug('RunUser.Id >>'+RunUser.Id);
        system.debug('Obj ce>>'+ce.getselectedUserId()); 
        
        Test.stopTest();       
    }    

    public static testMethod void CaseEscalationTest3() 
    {
        //Instantiate a new controller with all parameters in the page
        Case c = CaseEscalationCreate();

        Site__c sit = [SELECT id FROM Site__c WHERE Account__c =: c.AccountID limit 1];        
        c.site__c = sit.id;
        c.statusDetails__c = 'Tier 4';
        update c;
        
        casehistory  ch = new casehistory ();
        ch.caseid = c.id;
        ch.field = 'TotalLaborHours__c';
        insert ch; 

        Test.startTest();       
        Schema.DescribeSObjectResult OnDesc = Schema.SObjectType.OnCallSchedule__c;
        Map<String,Schema.RecordTypeInfo> OnRTMapByName = OnDesc .getRecordTypeInfosByName();
        Schema.RecordTypeInfo OnRTByName = OnRTMapByName .get('Tier 4');
        ID OnRecId = OnRTByName.getRecordTypeId();     
        
        OnCallSchedule__c  oc = new OnCallSchedule__c ();
        oc.StartDate__c = system.today();
        oc.EndDate__c = system.today();
        oc.StartTime__c = 'mon';
        oc.EndTime__c = 'tue';
        oc.CallSequence__c = 10;
        oc.CaseType__c = 'Change Request';
        oc.recordtypeID = OnRecId;
        oc.program__c = 'AECN';
        insert oc;

        EscalationCheckList__c estlist = new EscalationCheckList__c();
        estlist.CurrencyIsoCode = 'USD';
        estlist.Case__c = c.id;
        insert estlist;
       
       
        List<EscalationCheckList__c> Elist = new List<EscalationCheckList__c>();
        EscalationCheckList__c e1 = new EscalationCheckList__c();
        e1.case__c = c.id;
        Elist.add(estlist);
          
        //Case c = new Case();
        ApexPages.Standardcontroller controller = new ApexPages.Standardcontroller(c);
        //Apexpages.currentPage().getParameters().put('selectedtier','Tier 1');
        CaseEscalation ce = new CaseEscalation(controller);
        EscalationCheckList__c e = ce.ec;
        String s = ce.escalateTo;
        s = ce.escalationStep;
        s = ce.result;
        Integer i = ce.errorCode;
      
        List<String> l = ce.escalationTiers;
        List<List<String>> l1 = ce.escalationPath;
       
        Boolean b = ce.renderStatus;
       
        List<OnCallSchedule__c> u = ce.supportUsers;
        List<SelectOption> tiers = ce.getTiers();
        List<SelectOption> ec = ce.escalationCheckLists;
        List<Case> casesToUpdate = new List<Case>(); 
        update casesToUpdate;
        c.Description = 'Hai This is Legacy Keane';
        casesToUpdate.add(c);
        update casesToUpdate;
        s = ce.escalationCheckListId;
        ce.escalationCheckListId = '1234';
        s = ce.getescalationCheckListId();
        ce.setescalationCheckListId('123');
        s = ce.getselectedTier();
        ce.setselectedTier('Tier 4');
      
        Apexpages.currentPage().getParameters().put('selectedResCode','Baseband');       
        PageReference x = ce.userSelected();
        x = ce.checkListSelection();
        x = ce.userSelectedManually();
        ce.escalateCase();
        x = ce.save();
        ce.escalationCheckListId = 'NA';
        x = ce.checkListSelection();
         
        c = new Case(status='Closed',resolutiondescription__c = 'Test');//,ClosedDate=date.today());
        insert c;
        controller = new ApexPages.Standardcontroller(c);
        Apexpages.currentPage().getParameters().put('selectedtier','Tier 1');
        ce = new CaseEscalation(controller);
        ce.getselectedUserId();
        ce.getselectedUserName();
        ce.escalateCase();
        ce.checkListSelection();
        s = ce.getselectedUserName();
        ce.setselectedUserName('test');
        ce.setselectedUserId('test');       
        Test.stopTest();       
    } 
       
    public static testMethod void CaseEscalationTest4() 
    {
        //Instantiate a new controller with all parameters in the page
        Case c = CaseEscalationCreate();
       
        Site__c sit = [SELECT id FROM Site__c WHERE Account__c =: c.AccountID limit 1];        
        c.site__c = sit.id;
        c.StatusDetails__c = 'testTier';
        update c;

        casehistory  ch = new casehistory ();
        ch.field = 'StatusDetails__c';
        ch.caseid = c.id;
        insert ch;  

        Test.startTest();       
       
        Schema.DescribeSObjectResult EscDesc = Schema.SObjectType.EscalationCheckList__c;
        Map<String,Schema.RecordTypeInfo> EscRTMapByName = EscDesc .getRecordTypeInfosByName();
        Schema.RecordTypeInfo EscRTByName = EscRTMapByName .get('Aircraft Issue');
        ID EscRecId = EscRTByName.getRecordTypeId(); 
        
        Schema.DescribeSObjectResult OnDesc = Schema.SObjectType.OnCallSchedule__c;
        Map<String,Schema.RecordTypeInfo> OnRTMapByName = OnDesc .getRecordTypeInfosByName();
        Schema.RecordTypeInfo OnRTByName = OnRTMapByName .get('Tier 2');
        ID OnRecId = OnRTByName.getRecordTypeId(); 
 
        OnCallSchedule__c  oc = new OnCallSchedule__c ();
        oc.StartDate__c = Date.today()-1;
        oc.EndDate__c = Date.today()+3;
        oc.StartTime__c = 'mon';
        oc.EndTime__c = 'tue';
        oc.CallSequence__c = 10;
        oc.CaseType__c = 'Change Request';
        oc.recordtypeID = OnRecId;
        oc.program__c = 'AECN';
        insert oc;
        
        EscalationCheckList__c estlist = new EscalationCheckList__c();
        estlist.CurrencyIsoCode = 'USD';
        estlist.Case__c = c.id;
        insert estlist;
       
        
        List<EscalationCheckList__c> Elist = new List<EscalationCheckList__c>();
        EscalationCheckList__c e1 = new EscalationCheckList__c();
        e1.case__c = c.id;
        Elist.add(estlist);
          
        //Case c = new Case();
        ApexPages.Standardcontroller controller = new ApexPages.Standardcontroller(c);
        //Apexpages.currentPage().getParameters().put('selectedtier','Tier 1');
        CaseEscalation ce = new CaseEscalation(controller);
       // ce.selectedUserId=null;
        //ce.lsNewValue = 'testTierTier';
        EscalationCheckList__c e = ce.ec;
        String s = ce.escalateTo;
        s = ce.escalationStep;
        s = ce.result;
        Integer i = ce.errorCode;
      
        List<String> l = ce.escalationTiers;
        List<List<String>> l1 = ce.escalationPath;
       
        Boolean b = ce.renderStatus;
       
        List<OnCallSchedule__c> u = ce.supportUsers;
        List<SelectOption> tiers = ce.getTiers();
        List<SelectOption> ec = ce.escalationCheckLists;
       
        s = ce.escalationCheckListId;
        ce.escalationCheckListId = EscRecId;
        s = ce.getescalationCheckListId();
        ce.setescalationCheckListId(EscRecId);
        s = ce.getselectedTier();
        ce.setselectedTier(OnRecId);
      
        Apexpages.currentPage().getParameters().put('selectedResCode','Baseband');
        Apexpages.currentPage().getParameters().put('escalationCheckListId','Baseband');        
        PageReference x = ce.userSelected();
        x = ce.checkListSelection();
        x = ce.userSelectedManually();
        //ce.escalateCase();
        x = ce.save();
        ce.escalationCheckListId = 'NA';
       // x = ce.checkListSelection();
         
        c = new Case(status='Closed', resolutiondescription__c = 'Test');//,ClosedDate=date.today());
        controller = new ApexPages.Standardcontroller(c);
        Apexpages.currentPage().getParameters().put('selectedtier','Tier 1');
        ce = new CaseEscalation(controller);
        ce.getselectedUserId();
        
        ce.getselectedUserName();
        ce.escalateCase();
        ce.checkListSelection();
        s = ce.getselectedUserName();
        ce.dummyCase=[select id,OwnerId from case limit 1];
        ce.setselectedUserName('test');
        String usr = ce.getselectedUserId();

        ce.setselectedUserId(usr);             
        Test.stopTest();       
    } 
    
    public static testMethod void CaseEscalationTest5()
    {
        Case c = CaseEscalationCreate();
        casehistory  ch = new casehistory ();
        ch.field = 'StatusDetails__c';
        ch.caseid = c.id;
        insert ch;  
                
        Test.startTest();       
        Schema.DescribeSObjectResult OnDesc = Schema.SObjectType.OnCallSchedule__c;
        Map<String,Schema.RecordTypeInfo> OnRTMapByName = OnDesc .getRecordTypeInfosByName();
        Schema.RecordTypeInfo OnRTByName = OnRTMapByName .get('Tier 4');
        ID OnRecId = OnRTByName.getRecordTypeId(); 

        OnCallSchedule__c  oc = new OnCallSchedule__c ();
        oc.StartDate__c = Date.today();
        oc.EndDate__c = Date.today();
        oc.StartTime__c = 'mon';
        oc.EndTime__c = 'tue';
        oc.CallSequence__c = 10;
        oc.CaseType__c = 'Change Request';
        oc.program__c = 'AECN';
        oc.recordtypeID = OnRecId;
        oc.product__c = c.ProductID;
        oc.casetype__c = c.Type;
        oc.program__c = 'All';
        insert oc;

        EscalationCheckList__c estlist = new EscalationCheckList__c();
        estlist.CurrencyIsoCode = 'USD';
        estlist.Case__c = c.id;
        insert estlist;
       
        Escalation__c esc = new Escalation__c();
        esc.Program__c = 'All';
        esc.Tiers__c = 'Tier 1';
        esc.CurrencyIsoCode = 'USD';
        insert esc;
                
        List<EscalationCheckList__c> Elist = new List<EscalationCheckList__c>();
        EscalationCheckList__c e1 = new EscalationCheckList__c();
        e1.case__c = c.id;
        Elist.add(estlist);
          
        //Case c = new Case();
        ApexPages.Standardcontroller controller = new ApexPages.Standardcontroller(c);
        //Apexpages.currentPage().getParameters().put('selectedtier','Tier 1');
        CaseEscalation ce = new CaseEscalation(controller);
        EscalationCheckList__c e = ce.ec;
        //ce.selectedUserId=RunUser.id;
        
        String s = ce.escalateTo;
        s = ce.escalationStep;
        s = ce.result;
        Integer i = ce.errorCode;
   
        List<String> l = ce.escalationTiers;
        List<List<String>> l1 = ce.escalationPath;
       
        Boolean b = ce.renderStatus;
       
        List<OnCallSchedule__c> u = ce.supportUsers;
        List<SelectOption> tiers = ce.getTiers();
        List<SelectOption> ec = ce.escalationCheckLists;
        s = ce.escalationCheckListId;
        ce.escalationCheckListId = '1234';
        s = ce.getescalationCheckListId();
        ce.setescalationCheckListId('123');
       
        s = ce.getselectedTier();
        ce.setselectedTier('Tier 4');
   
        Apexpages.currentPage().getParameters().put('selectedResCode','Baseband');       
        PageReference x = ce.userSelected();
        x = ce.checkListSelection();
        x = ce.userSelectedManually();
       
        ce.escalateCase();   
        x = ce.save();
        ce.escalationCheckListId = 'NA';
        x = ce.checkListSelection();
        c = new Case(status='Closed', resolutiondescription__c = 'Test');//,ClosedDate = date.today());
        controller = new ApexPages.Standardcontroller(c);
        Apexpages.currentPage().getParameters().put('selectedtier','Tier 1');
        ce = new CaseEscalation(controller);
        ce.getselectedUserId();
        ce.getselectedUserName();
        ce.escalateCase();
        ce.checkListSelection();
        s = ce.getselectedUserName();
        ce.setselectedUserName('test');
        ce.setselectedUserId('test');
        Test.stopTest();       
    } 
    
    //*************************************************************************************
    // Method checking Active List size greater than or equal to 3 and
    // YTD List size greater than or equal to 28. But YTD List query contains Active List query 
    static testmethod void CaseCalloutCtrlrTest() 
    {
        setCustomSettings();
        
        Map<String,NBNCoKeyvalueStore__c> MapKeyValue= NBNCoKeyvalueStore__c.getAll();
        String nbnAccountName = MapKeyValue.get('NBN_AccountName').Value__c;
        String nbnSupportServices = MapKeyValue.get('NBNSupportServices').Value__c;
        String nbnSubSystem = MapKeyValue.get('NBN_SubSystem').Value__c;
            
        List<Account> accounts = ViasatTestUtility.createAccounts(1, nbnAccountName);
        insert accounts; 
        Account acc1 = accounts[0];  
        
        List<Contact> contacts = ViasatTestUtility.createContacts(accounts,28);       
        insert contacts;
            
        List<SLA__c> listSLA = ViasatTestUtility.createSLAObjs(accounts, 7);
        insert listSLA;      
        
        List<Case> caseYTDList = ViasatTestUtility.createCases(accounts, contacts, nbnSupportServices);
        for (Case caseYTDObj : caseYTDList)
        //for(Integer i = 0; i<=28; i++)
        {    
            //Case caseYTDObj = new Case();
            caseYTDObj.AccountId = acc1.Id;
            caseYTDObj.SubSystem__c = 'GSTB';
            caseYTDObj.Status = 'In Progress';
            caseYTDObj.CalloutStatus__c = 'Open';
            caseYTDObj.CalloutStartTime__c = DateTime.Now();
            caseYTDObj.CalloutEndTime__c = DateTime.Now();
       caseYTDObj.StatusDetails__c = 'Initial Response Provided' ;
       caseYTDObj.Steps_to_Follow__c ='text';
       caseYTDObj.PrioritybasedonType__c = null;
            //caseYTDList.add(caseYTDObj);
        }   
        insert caseYTDList;  
           
        // Starting the Test    
        Test.startTest(); 
        PageReference calloutVFPage= Page.calloutVFPage;
        Test.setCurrentPage(calloutVFPage);  
        CaseCalloutCtrlr ctrlr = new CaseCalloutCtrlr (new ApexPages.StandardController(caseYTDList[0]));       
        Test.stopTest();        
    }   

    static testMethod void CaseNotificationTest1() 
    {
        setCustomSettings();

        list<Account> accounts = ViasatTestUtility.createAccounts(2, 'Test Account');
        accounts[1].name='Gulfstream';
        insert accounts; 
        list<Contact> contacts = ViasatTestUtility.createContacts(accounts, 1); // one contact per account
        contacts[1].Email = 'two'+contacts[1].Email;
        insert contacts; 
        
        //// Create two 'Carlsbad NOC' Cases 
        //list<Case> lstcase = ViasatTestUtility.createCases(accounts, contacts, 'Carlsbad NOC');
        //insert lstcase;
        
        Account acc1 = accounts[0];
        Account acc2 = accounts[1]; 
        Contact con1 = contacts[0];
        Contact con2 = contacts[1];
                
        // setup con1 as an account contact role
        AccountContactRole accr1 = new AccountContactRole();
        accr1.Role = 'Company Distribution List';
        accr1.ContactId = con1.Id; 
        accr1.AccountId = acc1.Id;
        insert accr1;
        
        // setup con2 as an account contact role
        AccountContactRole accr2 = new AccountContactRole();
        accr2.Role = 'Company Distribution List';
        accr2.ContactId = con2.Id; 
        accr2.AccountId = acc2.Id;
        insert accr2;
        
        // custom setting SiteMakeMapping
        upsert new SiteMakeMapping__c(
            Name='Gulfstream',
            MakeAccountId__c=acc2.Id    
        );
        
        RecordType aviationSiteRecordType= [SELECT Id,Name FROM RecordType WHERE SObjectType = 'Site__c' AND recordType.name = 'Aviation-General' limit 1];
                
        List<Product2> ps = ViasatTestUtility.createProducts(1, null, null);
        Product2 p = ps[0];
        insert p;
        
        Site__c s = new Site__c ();        
        s.product__c = p.id;
        s.account__c= acc1.id;
        s.SiteName__c = 'site 1';
        s.recordtypeid = aviationSiteRecordType.id;
        s.Make__c = 'Gulfstream';
        insert s;
         
        Site__c snew = [select Id, MakeAccount__c from Site__c where id =:s.id];
        
        // Verify that the maleAccountId is populated on site
        System.assertEquals(snew.MakeAccount__c, acc2.Id, 'snew.MakeAccount__c:'+snew.MakeAccount__c+' <> acc2.Id:'+ acc2.Id );
        
        Test.startTest();
                
        // Create a NOC case with Account 1 and Service Site 1
        // Verify that notificationEmail1 and notificationEmail2 are populated with emails
        RecordType NocCaseRecordType=[Select Id, Name From RecordType where SObjectType = 'Case' and Name='Carlsbad NOC' limit 1];
        
        Case c = new Case();
        c.recordtypeId = NocCaseRecordType.Id;
        c.accountId = acc1.Id;
        c.Site__c = s.id;
        c.VisibleToCustomer__c = 'Yes';
        
        insert c; 
        
        case cnew = [select Id, notificationEmail1__c, notificationEmail2__c from case where id =:c.id];   
        System.assertEquals(cnew.notificationEmail1__c, con1.Email, 'cnew.notificationEmail1__c:'+cnew.notificationEmail1__c+' <> con1.Email:'+ con1.Email );       
        System.assertEquals(cnew.notificationEmail2__c, con2.Email, 'cnew.notificationEmail2__c:'+cnew.notificationEmail2__c+' <> con2.Email:'+ con2.Email );
  
        Test.stopTest(); 
    }
  
    static testMethod void testCloseChildCases() 
    {   
        string profileName ='Carlsbad NOC';        
        User thisUser = ViasatTestUtility.createInsertUser(null, profileName);

        Test.startTest();        
        System.runAs ( thisUser ) 
        {
            //create a case
            Case parentCase = new Case();
            parentCase.Subject = 'Parent Case';
            parentCase.Status = 'New';
            insert parentCase; 
            Case pCase = [select id, Status from Case where id = :parentCase.Id];
            System.assertEquals('New',pCase.Status);
    
            //create a child case
            Case childCase = new Case();
            childCase.Subject = 'Child Case';
            childCase.ParentId = parentCase.Id;
            insert childCase;
    
            Case cCase = [select id, Status from Case where id = :childCase.Id];
            System.assertEquals('New',cCase.Status);
    
            // close the original case: FIELD_CUSTOM_VALIDATION_EXCEPTION, Resolution Description is required to Resolve or Close a Case
            // OR(RecordTypeName__c ="Carlsbad NOC", RecordTypeName__c ="Carlsbad NOC Customer Portal") && 
            try
            {
                parentCase.Status = 'Closed';
                update parentCase;
                system.assert(false);
            }
            catch (Exception e)
            {
                system.assert(true);
            }   
            //assert that the child case is closed
            Case ccCase = [select id, Status from Case where id = :childCase.Id];
            System.assertEquals('New',ccCase.Status);
        }

        Test.stopTest();
    }

    static testMethod void testCaseDashboardController() 
    {   
        setCustomSettings();

        list<Account> accounts = ViasatTestUtility.createAccounts(2, 'Test Account');
        insert accounts; 
        list<Contact> contacts = ViasatTestUtility.createContacts(accounts, 1); // one contact per account
        insert contacts; 

        Site__c sit = new Site__c();
        sit.CurrencyIsoCode = 'USD';
        sit.Account__c = accounts[0].id;
        sit.SiteName__c='myName1';
        insert sit;         

        // Create User group of three
        System.runAs(new User(Id = Userinfo.getUserId()))
        {
            string profileName ='Carlsbad NOC';   
            string roleName ='Carlsbad NOC';  
            User user1 = ViasatTestUtility.createUser(null, profileName, roleName);
            insert user1;
            
            User user2 = ViasatTestUtility.createUser(null, profileName, roleName);
            insert user2;
            
            User user3 = ViasatTestUtility.createUser(null, profileName, roleName);
            insert user3;
            
            list<UserGroupAssignment__c> ugaList = new list<UserGroupAssignment__c>{new UserGroupAssignment__c(User__c=user1.id)
                ,new UserGroupAssignment__c(User__c=user2.id)
                ,new UserGroupAssignment__c(User__c=user3.id)};
            insert ugaList;
            // Create Carlsbad_NOC Cases
            List<Case> caseList = new List<Case>();
            for (UserGroupAssignment__c uga : ugaList)
            {
                List<Case> cases1 = ViasatTestUtility.createCases(accounts, null, 'Carlsbad NOC');
                for (Case c : cases1)
                {
                    //c.product = [SELECT Id FROM Product2 WHERE Name in ('ArcLight1','ArcLight2') LIMIT 1];
                    c.type = 'Maintenance';
                    c.PlannedStartTime__c = DateTime.Now();
                    c.PlannedEndTime__c = DateTime.Now().addDays(100);
                    c.Ownerid = uga.User__c;
                    caseList.add(c);
                }
                
                List<Case> cases2 = ViasatTestUtility.createCases(accounts, null, 'Carlsbad NOC');
                for (Case c : cases2)
                {
                    c.Status = 'Working';
                    c.type = 'Outage';
                    c.Ownerid = uga.User__c;        
                }
                cases2[0].site__c = sit.ID;
                caseList.addAll(cases2);
                
            }
            insert caseList;
        }
                
        
        Test.startTest();        

           // Instantiate a new controller with all parameters in the page                   
            CaseDashboardController controller = new CaseDashboardController();
            List<Case> c = controller.getMaintenanceCases();
           
            c = controller.getOutageCases();
            c = controller.getNewCases();
            c = controller.getBottom10Cases();
            c = controller.getTop10Cases();
            c = controller.getBottom10Cases();
            
            controller.sortDirection = 'ASC';
            controller.sortExp = 'casenumber';
            controller.sortExp1 = 'casenumber';
            
            controller.sortExpression = 'casenumber';
            controller.sortExpression1 = 'casenumber';
            controller.getSortDirection();
            controller.setSortDirection1('ASC');
            controller.setSortDirection('ASC');

            controller.getSortDirection1();
            controller.Top10CasesSort();
            controller.Bottom10CasesSort();
            controller.caseDetail();

            controller.sortExpression = '';
            controller.getSortDirection();
            controller.sortExpression1 = '';
            controller.getSortDirection1();
            controller.caseDetail();

        Test.stopTest();
    }

    static testMethod void CaseOnSiteController() 
    {
        List<Account> accounts = ViasatTestUtility.createAccounts(3, 'testCaseOnMPLSSite');
        insert accounts;

        List<Contact> contacts = ViasatTestUtility.createContacts(accounts, 1);
        insert contacts;

        RecordType rtCase=[SELECT Id,Name FROM RecordType WHERE SObjectType = 'Case' AND recordType.name='Carlsbad NOC'];
        RecordType rtSite=[SELECT Id,Name FROM RecordType WHERE SObjectType = 'Site__c' AND recordType.name='MPLS'];
        
        string profileName = 'Carlsbad NOC';
        User u  = ViasatTestUtility.createUser(null, profileName);
        insert u;

        Site__c sit = new Site__c();
            sit.CurrencyIsoCode = 'USD';
            sit.Account__c = accounts[0].Id; 
            sit.SiteName__c = 'mySiteCaseReason';  
            sit.RecordTypeId = rtSite.Id;       
        insert sit;                 
           
        Test.startTest();                  

        Case c = new Case();
            c.Start_Labor_Hour__c = true;
            c.site__c = sit.ID;
            c.Status = 'New';
            c.Type = 'Administrative';
            c.Category__c = 'Account';
            c.Origin = 'Email';
            c.VisibleToCustomer__c = 'Yes';
            c.Subject = 'Tesing Ntt Data';
            c.Description = 'Tesing Ntt Data123';
            c.accountid = accounts[0].id; 
            c.ownerid=u.id;    
            c.ContactId=contacts[0].Id;  
            c.recordTypeId =rtCase.Id;  
        try{       
            insert c;   
            system.assert(false);  
        }
        catch(exception e){
            system.assert(true);
        }
        c.MPLSCircuitAffected__c = 'Physical Circuit';
        insert c;
            
        ApexPages.StandardController controller = new ApexPages.StandardController(c);            
        CaseOnSiteController myContr = new CaseOnSiteController(controller);
        PageReference pageRef=Page.CaseMLPSCustomers;             
        Test.setCurrentPage(pageRef);                       

        Test.stopTest(); 
    }
}