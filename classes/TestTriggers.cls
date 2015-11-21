/* ****************************************************************************
 * This file serves as a Test class for Triggers
 *
 * Created By: Hanu Cholleti
 * Modified By: Smita Borkar
 *
 * **************************************************************************** */
@isTest
public class TestTriggers 
{       
// This could be taken from the Custom Settings TestKeyValueStore.NumOfObjectsForBulkTest
// For deployment to Production will be set to 1
public static integer numOfObjs = 1;

    //*************************************************************************************
    static testmethod void testCaseTriggers()
    {
        ViasatTestUtility.setNBNCoKeyvalueStore();
        ViasatTestUtility.setGlobals();

        list<Account> accounts = ViasatTestUtility.createAccounts(1, 'NBNCo');
        insert accounts; 
        list<Contact> contacts = ViasatTestUtility.createContacts(accounts, 2); // two contacts for account
        insert contacts; 
        list<SLA__c> listSLA = ViasatTestUtility.createSLAObjs(accounts, 7);
        insert listSLA;      

        list<Account> bAccounts = ViasatTestUtility.createAccounts(1, 'Carlsbad NOC TestCo');
        insert bAccounts; 
        list<Contact> bContacts = ViasatTestUtility.createContacts(bAccounts, 2); // two contacts for account
        insert bContacts; 

        List<Product2> ps = ViasatTestUtility.createProducts(1, null, null);
        insert ps;
           
        site__c s = new site__c (product__c = ps[0].id, account__c=bAccounts[0].id, SiteName__c = 'mySite3');
        insert s;

        //User newUser = ViasatTestUtility.createUser(null, 'Engineering Support Services');
        //User newUser = ViasatTestUtility.createUser(null, 'System Administrator');//'Outside Sales Standard + Carlsbad NOC' 
        //insert newUser;
        //system.runAs(newUser)
        //{
        // Create Four 'Support Services NBN Co' Cases 
        list<Case> lstcase1 = ViasatTestUtility.createCases(accounts, contacts, 'Support Services NBN Co');
        list<Case> lstcase2 = ViasatTestUtility.createCases(accounts, contacts, 'Support Services NBN Co');   
        lstcase2[0].contactId = null; 
        lstcase2[1].contactId = bContacts[0].id;
        
        // Create Four 'Carlsbad NOC' Cases 
        list<Case> lstcase3 = ViasatTestUtility.createCases(bAccounts, bContacts, 'Carlsbad NOC');
        list<Case> lstcase4 = ViasatTestUtility.createCases(bAccounts, bContacts, 'Carlsbad NOC');
        lstcase4[0].contactId = null;   
        lstcase4[0].site__c = s.id;
        lstcase4[0].eventstarttime__c = Date.today()-10;  
        lstcase4[0].eventendtime__c = null;
                       
        lstcase4[1].contactId = contacts[0].id;

        Test.startTest();           
        
        // *** Test Contact Account enforcement on the case 
        // *** Test NBNCO SLAs update
        try{
            //FIELD_CUSTOM_VALIDATION_EXCEPTION, SLA values are missing!
            insert lstcase2[0];
        } catch (Exception e) {
           //--- Do Nothing - expect to fail
        }       
        try{
            // Contact Account is not compatible with Case Account
            insert lstcase2[1];
        } catch (Exception e) {
           //--- Do Nothing - expect to fail
        }
        list<Case> lst = new list<Case>();       
        lst.addAll(lstcase1);
        lst.addAll(lstcase3);
        lst.addAll(lstcase4);
        insert lst;

        list<Case> newcases = [SELECT id, site__c, status, eventstarttime__c, eventendtime__c FROM Case];
        system.assertEquals(newcases.size(),6);
        
        // *** Test Site's Account/Product doesn't match Account/Product of the case
        Case c = lstcase4[0];

        c.status = 'On Hold';
        c.eventendtime__c = Date.today()+10;
        update c;
           
        c.status = 'Working';
        update c;
           
        c.status = 'On Hold';
        c.eventendtime__c = null;
        c.accountid=bAccounts[0].id;
        update c;
           
        c = new Case(site__c = s.id,eventstarttime__c = Date.today(),eventendtime__c = Date.today()+10,status='On Hold',accountid=accounts[0].id);
        try{
            // FIELD_CUSTOM_VALIDATION_EXCEPTION, Site's Account/Product doesn't match Account/Product of the case. Please update the site or Account/Product.
            insert c; 
        } catch (Exception e) {
           //--- Do Nothing - expect to fail
        }       

        Test.stopTest();           
    }          

    
    //*************************************************************************************
    static testMethod void testCaseSiteTriggers() 
    {  
        ViasatTestUtility.setGlobals();
        
        List<Product2> ps = ViasatTestUtility.createProducts(1, null, null);
        Product2 p = ps[0];
        insert p;
       
        resolution__c r1 = new resolution__c(name='Level 1 Res Code', product__c=p.id);
        insert r1;
       
        resolution__c r2 = new resolution__c(name='Level 2 Res Code', product__c=p.id, parent__c=r1.id);
        insert r2;

        resolution__c r3 = new resolution__c(name='Level 3 Res Code', product__c=p.id, parent__c=r2.id);
        insert r3;

        Test.startTest();
        
        site__c s = new site__c (product__c = p.id, SiteName__c = 'mySite4');
        insert s;
        Case c = null;
       
        List<RecordType> recordTypeId = [Select Id, Name From RecordType where SObjectType = 'Case' and Name like 'Carlsbad NOC'];
       
        try {
            c = new Case(RecordTypeId=recordTypeId.get(0).Id);
            insert c;
        } catch (Exception e) {
         //--- Do Nothing
        }
       
        try {

        c = new Case(RecordTypeId=recordTypeId.get(0).Id, site__c = s.id);
        insert c;
        } catch (Exception e) {
         //--- Do Nothing
        }
       
        try {
          c = new Case(RecordTypeId=recordTypeId.get(0).Id, site__c=s.id, status='Resolved');
          insert c;
        } catch (Exception e) {
         //--- Do Nothing
        }
       
        try {
          c = new Case(RecordTypeId=recordTypeId.get(0).Id, site__c=s.id, status='Resolved');
          insert c;
        } catch (Exception e) {
         //--- Do Nothing
        }
       
       try {       
          c = new Case(RecordTypeId=recordTypeId.get(0).Id, site__c=s.id, status='Resolved', resolutioncodelevel1__c=r1.id);
          insert c;
       } catch (Exception e) {
         //--- Do Nothing
       }
       
       try {                        
          c = new Case(RecordTypeId=recordTypeId.get(0).Id, site__c=s.id, status='Resolved', resolutioncodelevel1__c=r1.id,resolutioncodelevel2__c=r2.id);
          insert c;
       } catch (Exception e) {
         //--- Do Nothing
       }
       
       try {
          c = new Case(RecordTypeId=recordTypeId.get(0).Id, site__c=s.id, status='Resolved', resolutioncodelevel1__c=r1.id,resolutioncodelevel2__c=r2.id,resolutioncodelevel3__c=r3.id);
          insert c;    
       } catch (Exception e) {
         //--- Do Nothing
       }
       
        Test.stopTest();    
    }
    

    //*************************************************************************************
    // This is a unit test method for CCRSiteValidation trigger
    static testMethod void testCCRSiteValidation()
    {
        ViasatTestUtility.setGlobals();
        
        QueueSObject qObj = [select Id, Queue.Id, Queue.Name from QueueSObject where Queue.Name = 'NOC - CCR CCB'];

        CCR__c ccr = new CCR__c();
        insert ccr;
        ccr.Status__c = 'Submitted';
        ccr.OwnerId = '00570000001TeB0';
        try{
        update ccr;
        } catch (exception e1) {
         //--- do nothing
        }
               
        ccr.OwnerId = qObj.Queue.Id;
        try{
        update ccr;
        } catch (exception e1) {
         //--- do nothing
        }
              
        ccr.Status__c = 'CCB Rejected';
        try{
        update ccr;
        } catch (exception e1) {
         //--- do nothing
       }

        ccr = new CCR__c();
        insert ccr;
        ccr.OwnerId = '00570000001TeB0';
        try{
        update ccr;
        } catch (exception e1) {
         //--- do nothing
       }
       
        ccr.Status__c = 'Submitted';
        ccr.OwnerId = qObj.Queue.Id;
        try{
        update ccr;
        } catch (exception e1) {
         //--- do nothing
       }

        ccr = new CCR__c();
        insert ccr;

        ccr.Status__c = 'Rejected';
        ccr.OwnerId = qObj.Queue.Id;
        try{
            update ccr;
        } catch (exception e1) {
         //--- do nothing
        }
    }    

    //*************************************************************************************
    static testMethod void testCaseOutageTriggers() {   
        ViasatTestUtility.setGlobals();
        
        Case c = new Case();
        insert c;
        
        OutageTime__c ot1 = new OutageTime__c(
            case__c = c.Id,
            starttime__c = Date.today(),
            endtime__c  = Date.today() + 1            
        );
 
        OutageTime__c ot2 = new OutageTime__c(
            case__c = c.Id,
            starttime__c = Date.today() + 1,
            endtime__c  = Date.today() + 2 
        );

        OutageTime__c ot3 = new OutageTime__c(
            case__c = c.Id,
            starttime__c = Date.today() + 2,
            endtime__c  = Date.today() + 3 
        );

        //--- Check for insert and delete
        try {
            insert ot1; 
            delete ot1; 
        } catch (Exception e) {
           //--- Do Nothing - expect to fail
        }          
        
        //--- Check for multiple insert
        try {
            insert ot1; 
            delete ot2; 
            insert ot2;
            insert ot3;
        } catch (Exception e) {
           //--- Do Nothing - expect to fail
        }                
        
    }
    
    //*************************************************************************************
    static testmethod void TestPMNotification()
    {
        ViasatTestUtility.setGlobals();
        
    // Create Account
    Account acc = new Account();
    acc.Name = 'Acc1';
    acc.Status__c = 'Prospect';
    acc.CurrencyIsoCode = 'USD';
    acc.Type = 'End-User';
    acc.Industry = 'RAF';
    acc.Country__c = 'Benin';
    insert acc;
            
    //Create Product
        List<Product2> ps = ViasatTestUtility.createProducts(1, 'Acceleration', null);
        Product2 prod = ps[0];
    prod.Business_Area__c = 'AMP';
    prod.Referenced_Price_List__c = 'PriceList';
    insert prod;
    
    //Create Site        
    site__c s = new site__c();
    s.Account__c = acc.id; 
    s.Product__c = prod.id;
    s.Program__c = 'AECN';
    s.SiteName__c = 'mySite1';
    insert s;
    
    site__c s2 = new site__c();
    s2.Account__c = acc.id; 
    s2.Product__c = prod.id;
    s2.Program__c = 'AECN';
    s2.SiteName__c = 'mySite10';
    insert s2;
    
    //Create PM Details
    PM_Detail__c PMD1 = new PM_Detail__c();
    PMD1.Name = 'Renu';
    PMD1.Site__c = s2.id;
    PMD1.PM_Email__c = 'Renugadevi.Murugesan@nttdata.com';   
    insert PMD1;
      
    PM_Detail__c PMD2 = new PM_Detail__c();
    PMD2.Name = 'Sakthi';
    PMD2.Site__c = s2.id;
    PMD2.PM_Email__c = 'Renugadevi2.Murugesan1@nttdata.com';
    insert PMD2;

    test.startTest();
    
    List<RecordType> lstRecord = [Select id from RecordType where name = 'Carlsbad NOC' and SObjectType = 'Case'];
    Case c = new Case();
    c.RecordTypeId = lstRecord[0].id;
    c.Site__c = s.id;
    c.Productid = prod.id;
    c.Accountid = acc.id;
    c.TotalLaborHours__c = .02; // VALIDATION_Rule Labor_Hours_Required_Resolved_Case
    insert c;
          
    c.site__c =s2.id;
    c.ResolutionDescription__c = 'some';
    c.status = 'Closed';
    update c;

    c.status = 'Resolved';
    update c;

    test.stopTest();

    List<Case> resolvedCases = [SELECT Id FROM Case WHERE Id =:c.id and Status = 'Resolved'];
    System.Assert(resolvedCases.size()==1);                     
    } 

   
    //*************************************************************************************
    // Test LaborHour__c insert/Delete, case insert/delete
    static testMethod void testCaseEntitlementTriggers() 
    {  
        ViasatTestUtility.setGlobals();
        
        List<Account> accounts = ViasatTestUtility.createAccounts(numOfObjs, 'Test Acc');
        insert accounts;

        List<Contact> contacts = ViasatTestUtility.createContacts(accounts, numOfObjs);
        insert contacts;
       
        list<Product2> products = ViasatTestUtility.createProducts(numOfObjs, '', '');
        insert products;
       
        entitlement e = new entitlement(name='TestMilestone',accountid=accounts[0].id,HoursPerEntitlement__c=25);
        insert e;
    
        site__c s = new site__c (product__c = products[0].id, account__c=accounts[0].id, SiteName__c = 'mySiteMilestone');
        insert s;
       
        resolution__c r1 = new resolution__c(name='Level 1 Res Code', product__c=products[0].id, Active__c=true);
        insert r1;
       
        resolution__c r2 = new resolution__c(name='Level 2 Res Code', product__c=products[0].id, parent__c=r1.id, Active__c=true);
        insert r2;

        resolution__c r3 = new resolution__c(name='Level 3 Res Code', product__c=products[0].id, parent__c=r2.id, Active__c=true);
        insert r3;
       
        User someUser = ViasatTestUtility.createInsertUser(null, null);
        
        Test.startTest();
                
        list<Case> cases = ViasatTestUtility.createCases(accounts, contacts, '');
        integer i = 0;
        for (Case c : cases)
        {
            c.site__c = s.id;
            c.Product_Family__c = products[i].Family;
            c.ProductId=products[i++].id;
            c.entitlementid=e.id;
            c.resolutioncodelevel1__c=r1.id;
            c.resolutioncodelevel2__c=r2.id;
            c.resolutioncodelevel3__c=r3.id;
        }
        insert cases;
      
        list<LaborHour__c> lh = new list<LaborHour__c>();
        //try{
        LaborHour__c lh1 = new LaborHour__c(
            user__c = cases[0].createdbyid,
            case__c = cases[0].Id,
            starttime__c = Date.today(),
            stoptime__c  = Date.today() + 1
        );
        lh.add(lh1);
              
        LaborHour__c lh2 = new LaborHour__c(
            user__c = cases[0].createdbyid,
            case__c = cases[0].Id,
            starttime__c = Date.today(),
            stoptime__c  = Date.today() + 1
        );
        lh.add(lh2);
        insert lh;

        delete lh[1];        
        delete cases;
        
        //} catch (exception e2) {
        //   //---do nothing...
        //}
        
        Test.stopTest();                
    }    


    //*************************************************************************************
    // test EmailMessageAfterTrigger and Case Owner Update
    static testMethod void testEmailMessageAfterTrigger()
    {
        list<Case> cases = createCasesWithEntitlements(1);
      
        User someUser = ViasatTestUtility.createInsertUser(null, null);//TimeZoneSidKey
        list<Contact> contacts = [SELECT Id, Email FROM CONTACT WHERE Id =: cases[0].ContactId];
       
        Test.startTest();
    
        // EmailMessage trigger (email on case)
        List<EmailMessage> emails = new List<EmailMessage>();
        for(Case ca : cases){
            emails.add(new EmailMessage(parentId = ca.id, ToAddress = contacts[0].Email));
        }
        if(emails.isEmpty()==false)
            database.insert(emails);

        for(Case c : cases){
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            String[] toAddr = new String[] {'mramsey@salesforce.com'};
            mail.setToAddresses(toAddr);
            mail.setSaveAsActivity(false);
            mail.setTargetObjectId(c.ContactId);
            mail.setWhatId(c.Id);
            mail.setHtmlBody('TestHTMLBody');
            mail.setPlainTextBody('TestTextBody');
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
//            caseIds.add(c.Id);
        }

        // Update the Owner on the case
        for(Case c : cases){
            c.OwnerId = someUser.Id;
        }
        update cases;

        // Query the database for the newly inserted records.
        List<Case> insertedCases = [SELECT Subject,
                                           Description,
                                          (SELECT IsPublished, CommentBody From CaseComments),
                                          (SELECT TextBody, Subject, Incoming From EmailMessages)
                                           FROM Case
                                           WHERE Id IN :cases];
        
        Test.stopTest();
    }

    static private list<Case> createCasesWithEntitlements(integer thisnumOfObjs)
    {
        ViasatTestUtility.setGlobals();
        
        List<Account> accounts = ViasatTestUtility.createAccounts(thisnumOfObjs, 'Milestone');
        insert accounts;

        List<Contact> contacts = ViasatTestUtility.createContacts(accounts, thisnumOfObjs);
        insert contacts;
       
        list<Product2> products = ViasatTestUtility.createProducts(thisnumOfObjs, '', '');
        insert products;
       
        entitlement e = new entitlement(name='TestMilestone',accountid=accounts[0].id,HoursPerEntitlement__c=25);
        insert e;

//new Entitlement(Name='EntStd', AccountId=accountId, CurrencyIsoCode = 'USD', SlaProcessId = null, 
//StartDate = System.Today().addDays(-1), EndDate = System.Today().addMonths(12), IsPerIncident = true, CasesPerEntitlement=5, RemainingCases=4),
           
        site__c s = new site__c (product__c = products[0].id, account__c=accounts[0].id, SiteName__c = 'mySiteMilestone');
        insert s;
       
        resolution__c r1 = new resolution__c(name='Level 1 Res Code', product__c=products[0].id, Active__c=true);
        insert r1;
       
        resolution__c r2 = new resolution__c(name='Level 2 Res Code', product__c=products[0].id, parent__c=r1.id, Active__c=true);
        insert r2;

        resolution__c r3 = new resolution__c(name='Level 3 Res Code', product__c=products[0].id, parent__c=r2.id, Active__c=true);
        insert r3;
       
        list<Case> cases = ViasatTestUtility.createCases(accounts, contacts, '');
        integer i = 0;
        for (Case c : cases)
        {
            c.Product_Family__c = products[i].Family;
            c.site__c = s.id;
            c.ProductId=products[i++].id;
            c.entitlementid=e.id;
            c.resolutioncodelevel1__c=r1.id;
            c.resolutioncodelevel2__c=r2.id;
            c.resolutioncodelevel3__c=r3.id;

        c.SlaStartDate = system.now().addDays(-2);
        }
        insert cases;
      
        LaborHour__c lh1 = new LaborHour__c(
            user__c = cases[0].createdbyid,
            case__c = cases[0].Id,
            starttime__c = Date.today(),
            stoptime__c  = Date.today() + 1
        );       
        insert lh1;

        // Milestone should be created on the case with Entitlement with the owner who is the User with business hours
//      List<CaseMilestone> cms = [SELECT Id, caseId, completionDate, BusinessHoursId, Case.BusinessHoursId 
//                                 FROM CaseMilestone WHERE completionDate = null and caseId in :caseIds];
        return cases;
    }
    
    static testMethod void testCaseWithEntitlement()
    {
        list<Case> cases = createCasesWithEntitlements(1);
        
        // caseComment trigger (public comment on case)
        List<CaseComment> ccs = new List<CaseComment>{};
        CaseComment cc = new CaseComment(CommentBody='TestPublic', IsPublished=true, ParentId=cases[0].Id);
        ccs.add(cc);
        cc = new CaseComment(CommentBody='TestPrivate', IsPublished=false, ParentId=cases[0].Id);
        ccs.add(cc);
        insert ccs;
        
        Set<Id> caseIds = new Set<Id>();
        for(Case c : cases){
            caseIds.add(c.Id);
        }

        Test.startTest();
        
        ViasatTriggerHandler.completeMilestone(caseIds);//, 'Initial Response', system.now());
        ViasatTriggerHandler.updateMilestoneBusinessHours(caseIds);

        for(Case c : cases){
            c.Status = 'Closed';
            c.statusdetails__c = 'Waiting RFO';
            c.resolutiondescription__c = 'Test';
            c.actiontaken__c = 'Other';
        }
        update cases;

        Test.stopTest();
    
        //system.assert(cases[0].NextMilestoneTargetDate__c != null);
    }

    static testMethod void testCaseWithEntitlement2()
    {
        list<Case> cases = createCasesWithEntitlements(1);

        // caseComment trigger (public comment on case)
        List<CaseComment> ccs = new List<CaseComment>{};
        CaseComment cc = new CaseComment(CommentBody='TestPublic', IsPublished=true, ParentId=cases[0].Id);
        ccs.add(cc);
        cc = new CaseComment(CommentBody='TestPrivate', IsPublished=false, ParentId=cases[0].Id);
        ccs.add(cc);
        insert ccs;

        Set<Id> caseIds = new Set<Id>();
        for(Case c : cases){
            caseIds.add(c.Id);
        }

        Test.startTest();
        
        ViasatTriggerHandler.completeMilestone(caseIds);//, 'Initial Response', system.now());
        ViasatTriggerHandler.updateNextMilestoneTargetDate(caseIds);           

        for(Case c : cases){
            c.Status = 'Closed';
            c.statusdetails__c = 'Waiting RFO';
            c.resolutiondescription__c = 'Test';
            c.actiontaken__c = 'Other';
        }
        update cases;

        Test.stopTest();
    
        //system.assert(cases[0].NextMilestoneTargetDate__c != null);
    }
    
    static testMethod void testCaseSupportNBNCo()
    {
        ViasatTestUtility.setGlobals();
        
        ViasatTestUtility.setNBNCoKeyvalueStore();

        List<Account> accounts = ViasatTestUtility.createAccounts(numOfObjs, 'TestNBNCo');
        insert accounts;

        List<Contact> contacts = ViasatTestUtility.createContacts(accounts, numOfObjs);
        insert contacts;
       
        list<Product2> products = ViasatTestUtility.createProducts(numOfObjs, '', '');
        insert products;
      
        List<SLA__c> listSLA = ViasatTestUtility.createSLAObjs(accounts, 7);
        insert listSLA;    

        User someUser = ViasatTestUtility.createInsertUser(null, null);
        
        Test.startTest();

        list<Case> cases = ViasatTestUtility.createCases(accounts, contacts, 'Support Services NBN Co');
        try
        {
        //list<casehistory> histList = new list<casehistory>();
        for(Case c : cases){
            c.Status = 'In Progress';
            c.statusdetails__c = 'Advance Replacement';
            c.SubSystem__c = 'test';
            c.Location__c = 'test';
            //casehistory h = new casehistory(caseid=c.id, field='Status', newvalue='In Progress', oldvalue='New');
            //histList.add(h);
        }
        insert cases;
        //insert histList;
        } catch(Exception e){
        // it is expected to fail
        }
        
        for(Case c : cases){
            c.Status = 'New';
            c.eventstarttime__c = system.now().addDays(-1);
            c.statusdetails__c = 'Advance Replacement';
            c.SubSystem__c = 'test';
            c.Location__c = 'test';
        }
        insert cases;

set<Id> caseids = new set<Id>();
        for(Case c : cases){
            c.eventstarttime__c = system.now().addDays(-2);
            c.Status = 'In Progress';
            caseids.add(c.id);
        }
        update cases;

Map<id,Case> oldCases = new Map<id,Case>([Select id,Type,Status,RecordTypeName__c, PrioritybasedonType__c,EstimatedInitialResponseTime__c, EstimatedWorkaroundTime__c, EstimatedResolutionTime__c from Case where id in:caseids]);

        //list<casehistory> histList = [select id, caseid, newvalue, oldvalue, createddate from casehistory where field = 'Status'];// and caseid = :cases[0].id];//createddate >= :cases[0].eventstarttime__c];       
        //system.assert(histList.size()>0);
        //list<case> cList = [select id, eventstarttime__c, Status from case where id = :histList[0].caseId];//createddate >= :cases[0].eventstarttime__c];
        //for(Case c : cList){
        //    c.eventstarttime__c = histList[0].createddate.addDays(-1);
        //    c.Status = 'On Hold';
        //}
        //update cList;   
        for(Case c : cases){
            c.Status = 'On Hold';
        }
        update cases;   

list<Case> newCases = [Select id,Type,Status,RecordTypeName__c, PrioritybasedonType__c,EstimatedInitialResponseTime__c, EstimatedWorkaroundTime__c, EstimatedResolutionTime__c from Case where id in:caseids];
system.assertEquals(newCases[0].RecordTypeName__c, 'Support Services NBN Co');
        ViasatUpdateCaseClocksClass.AfterUpdateClock(newCases, oldCases);

        
        
        //system.assert(cases[0].EventOnHoldHours__c != 0.0);
        //system.assert(cases[0].LastOnHoldDate__c != null);
       /* case c=cases[0];
        c.Status = 'On Hold';
        c.eventstarttime__c = system.now()-2;
        update c;
        List<caseHistory> caseH=[select id, caseid, newvalue, oldvalue, createddate from casehistory where field = 'Status' and createddate >= :c.eventstarttime__c and caseid = :c.id];   
       */
              
        Test.stopTest();
    }

    // CaseAfter Insert trigger - Update CaseinConversation on Case
    //    If case inserted with Twitter Conversation then update this conversation object with Case Id.
    static testMethod void testUpdateCaseinConversation()
    {
        List<Account> accounts = ViasatTestUtility.createAccounts(numOfObjs, 'TestNBNCo');
        insert accounts;

        List<Contact> contacts = ViasatTestUtility.createContacts(accounts, numOfObjs);
        insert contacts;
       
        list<Product2> products = ViasatTestUtility.createProducts(numOfObjs, '', '');
        insert products;
      
        List<SLA__c> listSLA = ViasatTestUtility.createSLAObjs(accounts, 7);
        insert listSLA;    
               
        List<sf4twitter__Twitter_Conversation__c> lstConversation = new list<sf4twitter__Twitter_Conversation__c>();
        List<sf4twitter__Twitter_Conversation__c> lstConversation2 = new list<sf4twitter__Twitter_Conversation__c>();
        
        for(integer i=1; i<=numOfObjs; i++) {       
        sf4twitter__Twitter_Conversation__c pConver= new sf4twitter__Twitter_Conversation__c();
        pConver.sf4twitter__TwitterID__c = 'test';
        pConver.First_Response_Time__c = null;
        lstConversation2.add(pConver);
        }
        insert lstConversation2;
        
        for(integer i=0; i<lstConversation2.size(); i++) {       
        sf4twitter__Twitter_Conversation__c conver1= new sf4twitter__Twitter_Conversation__c();
        conver1.sf4twitter__TwitterID__c = 'test1';
        conver1.First_Response_Time__c = null;
        conver1.sf4twitter__Parent__c = lstConversation2[i].id;
        lstConversation.add(conver1);
        }
        insert lstConversation;
        
        Test.startTest();

        list<Case> cases = ViasatTestUtility.createCases(accounts, contacts, '');
        for(integer i=0; i<numOfObjs; i++)
        {
            cases[i].ConversationId__c = lstConversation2[i].id;
        }
        insert cases;
        
        list<sf4twitter__Twitter_Conversation__c> result = [select sf4twitter__Case__c from sf4twitter__Twitter_Conversation__c where id =: cases[0].ConversationId__c];
        system.assert(result[0].sf4twitter__Case__c == cases[0].id);
        
        Test.stopTest();
    }   
    
    static testMethod void testCaseAssignmentGroupforQueue()
    {
        List<Account> accounts = ViasatTestUtility.createAccounts(numOfObjs, 'TestNBNCo');
        insert accounts;

        List<Contact> contacts = ViasatTestUtility.createContacts(accounts, numOfObjs);
        insert contacts;
       
        list<Product2> products = ViasatTestUtility.createProducts(numOfObjs, '', '');
        insert products;
      
        List<SLA__c> listSLA = ViasatTestUtility.createSLAObjs(accounts, 7);
        insert listSLA;    

        User someUser = ViasatTestUtility.createInsertUser(null, 'IT: System Administrator');
        System.assert(someUser!=null);
        
        Group testGroup = ViasatTestUtility.createInsertQueue('TestQueue', 'Case');
        Group testGroup2 = ViasatTestUtility.createInsertQueue('NBNCoSupport', 'Case');

        //Create Assignment Group
        Assignment_Group_Name__c ag1 = new Assignment_Group_Name__c (Name='TestAG', Type__c = 'Case');
        insert ag1;        

        //Add Good Queue to Assignment Group
        Assignment_Group_Queues__c agq1 = new Assignment_Group_Queues__c(name=testGroup.Name, Assignment_Group_Name__c = ag1.id );
        agq1.QueueId__c= testGroup.id;//someUser.Id;
        agq1.Active__c='True';
        agq1.Valid_Queue__c = true;
        insert agq1;

        //Add User to Assignment Groups Users
        Assignment_Groups__c agu1 = new Assignment_Groups__c (User__c = someUser.id, Active__c='True', Group_Name__c = ag1.id, Last_Assignment__c = datetime.valueOf('2014-01-01 21:13:24') );
        insert agu1;


        Test.startTest();        
        
        list<Case> cases= ViasatTestUtility.createCases(accounts, contacts, '');
        cases[0].subject='testcase'; 
        cases[0].OwnerID = testGroup.id;
        
        list<Case> sObjs= ViasatTestUtility.createCases(accounts, contacts, 'Support Services NBN Co');
        sObjs[0].subject='testcase';
        sObjs[0].OwnerID = testGroup.id;
        sObjs[0].tempOwnerID__c = testGroup2.id;
        
        insert cases;
        insert sObjs;
        system.debug('sObjs***********'+sObjs);

        //list<Group> testGrp = [SELECT Id FROM Group WHERE Name = 'TestQueue' and Type = 'Queue'];
        //system.assertEquals(testGrp.size(), 1);
        
        //list<Group> testGroup = [SELECT Id FROM Group WHERE Name = 'NBNCoSupport' and Type = 'Queue'];
        //system.assertEquals(testGroup.size(), 1);
        
        ViasatTestUtility.assignCasesToQueue('TestQueue', cases);
        ViasatTestUtility.assignCasesToQueue('NBN Co Support',sObjs);

        for(Case c : cases){
            c.eventstarttime__c = system.now().addDays(-2);
            c.Status = 'In Progress';
        }
        update cases;

        ViasatTestUtility.assignCasesToQueue('TESTqueue', sObjs);
        for(Case c : sObjs){
            c.eventstarttime__c = system.now().addDays(-2);
            c.Status = 'In Progress';
        }
        update sObjs;

        //list<Assignment_Group_Queues__c> agqs = [SELECT Valid_Queue__c, QueueId__c, Name, Assignment_Group_Name__c, Active__c From Assignment_Group_Queues__c 
        //                                         WHERE QueueId__c = :testGrp[0].id AND Active__c = 'True'];
        Test.stopTest();
              
        //TODO: CaseBefore - TEST active Assignment Group for Queue
        //Map<Id,Assignment_Group_Queues__c> asgnGroupQueues = new Map<Id,Assignment_Group_Queues__c>(); //Queue ID --> Assignment Group Queues    
        //for(Assignment_Group_Queues__c[] agq : [SELECT Assignment_Group_Name__c, QueueId__c FROM Assignment_Group_Queues__c 
        //                                        WHERE QueueId__c in :queueIds.values() AND Active__c = 'True'])
    }   

    static testMethod void myTest1() 
    {
        // This code runs as the system user
        User u1 = ViasatTestUtility.createInsertUser(null, 'IT: System Administrator');
        System.assert(u1!=null);

        Group testGroup = ViasatTestUtility.createInsertQueue('TestQueue', 'Case');
        Group testGroup2 = ViasatTestUtility.createInsertQueue('TestQueue2', 'Case');

        test.starttest();

        //Assign Case with out any Assignment Groups
        Case c1 = new Case (subject='testcase',tempOwnerID__c=testGroup2.id, OwnerID=u1.id); //tempOwnerID__c=testGroup2.id,  
        insert c1;
        update c1;
        
        
        //Create Assignment Group
        Assignment_Group_Name__c ag1 = new Assignment_Group_Name__c (Name='TestAG', Type__c = 'Case');
        insert ag1;

        
        //Test for AG-Queues already assigned to another Assignment Group
        Assignment_Group_Queues__c agq2 = new Assignment_Group_Queues__c(name=testGroup.Name, Assignment_Group_Name__c = ag1.id );
        try {
            insert agq2;
        } catch (DmlException e){
             System.assert(e.getMessage().contains('CUSTOM_VALIDATION_EXCEPTION'), e.getMessage()); 
        } //catch
         
        //Add bad queue name
        Assignment_Group_Queues__c agqBad = new Assignment_Group_Queues__c(name='Bad Queue', Assignment_Group_Name__c = ag1.id );

        try {
            insert agqBad; 
        } catch (DmlException e){
             System.assert(e.getMessage().contains('CUSTOM_VALIDATION_EXCEPTION'), e.getMessage()); 
        
        } //catch

        test.stoptest();
        
    }
    
    //*************************************************************************************
    static testMethod void SiteTriggerUnitTest() 
    {
        list<Account> myAccounts=ViasatTestUtility.createAccounts(1, ViasatTestUtility.getNamePrefix());
        insert myAccounts;

        test.starttest();
        
        Site__c mySite = CreateAviationSite(myAccounts[0].id, 'Aviation - Commercial' , 'Tail 1');
        insert mySite;  
               
        // verify tail       
        mySite = [select tailNumber__c from Site__c where id = :mySite.id ];     
        System.assert(mySite.tailNumber__c == 'TAIL 1');
        
        // create duplicate tail sites in bulk insert
        try
        {
            list<string> tailList = new list<string>{'tail 2', 'tail 3', 'TAIL 3', 'TAIL 1', ''}; 
            
            list <Site__c> mySites = CreateAviationSites(myAccounts[0].id, 'Aviation - Commercial' , tailList);          
            insert mySites; 
            System.Assert(false); // should never get there 
        }
                    
        catch (System.DmlException e)
        {
            System.debug(e);                
        }
        test.stoptest();
    }

    static private Site__c CreateAviationSite(Id accountid, string recordTypeName, string tailNumber)
    {
        Schema.DescribeSObjectResult cfrSchema = Schema.SObjectType.Site__c;
        Map<String,Schema.RecordTypeInfo>siteRecordTypeInfo = cfrSchema.getRecordTypeInfosByName();
        
        Site__c mySite = new Site__c();
        
        mySite.RecordTypeId = siteRecordTypeInfo.get(recordTypeName).getRecordTypeId();
        mySite.Account__c = accountId;
        mySite.TailNumber__c = tailNumber;
        return mySite;   
    } 
    
    // create multiple aviation sites
    static private list <Site__c> CreateAviationSites(Id accountid, string recordTypeName, list<string>tailNumberList)
    {
        Schema.DescribeSObjectResult cfrSchema = Schema.SObjectType.Site__c;
        Map<String,Schema.RecordTypeInfo>siteRecordTypeInfo = cfrSchema.getRecordTypeInfosByName();
        
        list <Site__c> mySites = new list<Site__c>();
        
        for (string t: tailNumberList)
        {
            Site__c mySite = new Site__c();
        
            mySite.RecordTypeId = siteRecordTypeInfo.get(recordTypeName).getRecordTypeId();
            mySite.Account__c = accountId;
            mySite.TailNumber__c = t;
            
            mySites.add(mySite);
        }               
        return mySites;
    } 
       
    // Case 288859: email2case population of contactId when not done automatically
    static testMethod void email2CaseTest() 
    {       
        ViasatTestUtility.setGlobals();

        // simulate an email2Case for 'Salesforce Support' record type
        RecordType salesforceSupportRecordType = [Select id from RecordType where name = 'Salesforce Support' and SObjectType = 'Case'];
        // simulate an email2Case for 'ITSMS - General' record type
        RecordType ITSMSRecordType = [Select id from RecordType where name = 'ITSMS - General' and SObjectType = 'Case'];
 
        // 2 contacts with same email address
        Globals__c gs = Globals__c.getInstance();
        
        List<Contact> contacts = ViasatTestUtility.createContacts([select ID from Account where id=:gs.ViaSatAccount__c], 2);
        contacts[0].email = 'test@email.com'; 
        contacts[1].email = 'test@email.com';               
        insert contacts;
        
        Case c = new Case(); 
        c.Origin = 'Email';
        c.recordTypeId = salesforceSupportRecordType.id;               
        c.SuppliedEmail = 'test@email.com';         
        insert c;
        
        // make sure the case contact got updated 
        Case newC = [select contactId from Case where Id = :c.Id];
        System.Assert((newC.contactId == contacts[0].Id) || (newC.contactId == contacts[1].Id));
 
        c = new Case(); 
        c.Origin = 'Email - Service Desk';
        c.recordTypeId = ITSMSRecordType.id;               
        c.SuppliedEmail = 'test@email.com';    
        insert c;
        
        // make sure the case contact got updated 
        newC = [select contactId from Case where Id = :c.Id];
        System.Assert((newC.contactId == contacts[0].Id) || (newC.contactId == contacts[1].Id));
    }   

    static testmethod void ViaSatTaskTest() 
    {
        CCR__c ccr = new CCR__c();
        RecordType rt = [SELECT Id FROM RecordType WHERE SObjectType='Task' AND Name='CCR' LIMIT 1];   
        Profile p1 = [select Id,name from Profile  where name ='System Administrator' limit 1];
        
        User thisUser = new User(
            profileId = p1.id,
            username = 'ViaSatTestUser1@viasat.com',
            email = 'ViaSatTestUser1@viasat.com',
            emailencodingkey = 'UTF-8',
            localesidkey = 'en_US',
            languagelocalekey = 'en_US',
            timezonesidkey = 'America/Los_Angeles',
            alias='nuser1',
            lastname='lastname1'
            );
            insert thisUser;
        
        System.runAs ( thisUser ) {
        UserRole ur = [Select PortalType, PortalAccountId From UserRole limit 1];
        Profile p = [select Id,name from Profile where name <> 'System Administrator' limit 1];
        User newUser = new User(
            profileId = p.id,
            username = 'ViaSatTestUser@viasat.com',
            email = 'ViaSatTestUser@viasat.com',
            emailencodingkey = 'UTF-8',
            localesidkey = 'en_US',
            languagelocalekey = 'en_US',
            timezonesidkey = 'America/Los_Angeles',
            alias='nuser',
            lastname='lastname'
            );
            insert newUser;  
            System.assertEquals(newUser.username,'ViaSatTestUser@viasat.com');
            
             //CCR object section 'CCR Details' mandatory fields
         ccr.RequestedBy__c = newUser.Id;
         ccr.Status__c= 'New';
         
         //CCR object section 'Additional Information' mandatory fields
         ccr.Subject__c='Test';
         ccr.Description__c ='Test';
         ccr.SuccessCriteria__c ='Test';
         ccr.RollbackCriteria__c ='Test';
         ccr.Urgency__c = 'Immediate';
         ccr.Severity__c ='Low';
         ccr.RiskLevel__c = 'High';
         ccr.RiskDescription__c = 'Test';
         ccr.RiskMitigation__c='Test';
         
         //CCR object section 'CCR Instructions' mandatory fields
         ccr.Pre_Checks__c= 'Test';
         ccr.Pre_Backup__c = 'Test';
         ccr.Main_Work__c = 'Test';
         ccr.Backout__c = 'Test';
         ccr.Post_Checks__c = 'Test';
         ccr.Post_Backup__c = 'Test';
         
         //CCR object section 'Schedule & Outage Information' mandatory fields
         ccr.EstimatedOutage__c = '0:20';
         ccr.EstimatedVisibilityOutage__c = '0:35';
         ccr.OutageDescription__c ='Test';
         ccr.Customer_Maintenance_Notice_Required__c = 'Yes';
         ccr.Smart_Hands_Required__c = 'Yes';
         
        //CCR object section 'Post Execution Cleanup Information' mandatory fields 
//         ccr.Backups__c='Test';
//         ccr.Documents__c ='Test';
//         ccr.Drawings__c = 'Test';
//         ccr.Configs__c = 'Test';
//         ccr.Inventory__c = 'Test';
         ccr.CustomerPOCInfo__c = 'Test';
         
         insert ccr;
         
         /**
          * @description - Bulk test for task object and 
          *                then inserting and updating the list
         */ 
         CarlsbadNOCKeyValueStore__c noc= new CarlsbadNOCKeyValueStore__c();
         noc.Name = 'CCRTaskStatusListToSendEmail';
         noc.Value__c = 'Not Started,Completed,Approved,Denied,Cancelled';
         insert noc;
         List<Task> taskList = new List<Task>();
         for(integer i=0;i<5;i++)
         {
             Task taskObj = new Task();
             // Task object mandatory fields
             taskObj.OwnerId= newUser.Id;
             taskObj.whatid=ccr.Id;
             taskObj.Status = 'Not Started';
             taskObj.Priority = 'Normal';
             taskObj.Subject = 'Subject';
             taskObj.RecordTypeId=rt.id;  
             taskList.add(taskObj);
         }  
         Test.startTest();
         insert taskList;
         
             
            
         //Update for OldMap    
         taskList[0].Status = 'Completed';    
         update taskList;
             
         //Update for NewMap    
         taskList[0].Status = 'Completed';    
         update taskList;
         
         Test.stopTest();    
       }
    }
   
}