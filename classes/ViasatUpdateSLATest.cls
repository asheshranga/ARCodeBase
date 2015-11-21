//Test Method for the trigger ViasatUpdateSLA
 
@isTest
public class ViasatUpdateSLATest 
{
    static testmethod void ViasatUpdateSLATest1() {
        Integer numOfObjs = 1;
        List<Account> accounts = ViasatTestUtility.createAccounts(numOfObjs, 'test');
       accounts[0].Status__c = 'Prospect';
       accounts[0].Type = 'Contractor';  
       accounts[0].Industry = 'Air Force'; 
       accounts[0].Country__c = 'India'; 
        insert accounts;
        List<Contact> contacts = ViasatTestUtility.createContacts(accounts, numOfObjs);
        insert contacts;      

		Account acc = accounts[0]; 
		Contact con = contacts[0];       
       
		List<SLA__c> slaList = ViasatTestUtility.createSLAObjs(accounts, 7);
		slaList[0].CasePriority__c = 'Major';

		slaList[1].CasePriority__c = 'Low';
		slaList[1].CaseType__c = 'Inquiry';
		slaList[1].SLAInitialResponseTime__c = '2 Hours';
		slaList[1].SLAWorkaroundTime__c= ' '; 
		slaList[1].SLAResolutionTime__c = '2 Days';

		slaList[2].CaseType__c = 'Fault';
		slaList[2].SLAInitialResponseTime__c = '10 Minutes';
		slaList[2].SLAWorkaroundTime__c= '12 Hours'; 
		slaList[2].SLAResolutionTime__c = '15 Days'; 
               
		slaList[3].CasePriority__c = 'Minor';
		slaList[3].CaseType__c = 'Fault';
		slaList[3].SLAInitialResponseTime__c = '2 Hours';
		slaList[3].SLAWorkaroundTime__c= '2 Days'; 
		slaList[3].SLAResolutionTime__c = '7 Days'; 
        
		slaList[4].CasePriority__c = 'Major';
		slaList[4].CaseType__c = 'Fault';
		slaList[4].SLAInitialResponseTime__c = '20 Minutes';
		slaList[4].SLAWorkaroundTime__c= '12 Hours'; 
		slaList[4].SLAResolutionTime__c = '15 Days';       
       
		slaList[5].CasePriority__c = 'Minor';
		slaList[5].CaseType__c = 'Problem';
		slaList[5].SLAInitialResponseTime__c = '2 Hours';
		slaList[5].SLAWorkaroundTime__c= '2 Days';  
		slaList[5].SLAResolutionTime__c = '7 Days';
       
		slaList[6].SLAInitialResponseTime__c = '10 Minutes';
		slaList[6].SLAWorkaroundTime__c= '12 Hours'; 
		slaList[6].SLAResolutionTime__c = '1 Day';
       
		insert slaList;  
        
       Map<Id, SLA__c> SLAMap = new Map<Id, SLA__c>();        
        
       List<BusinessHours> bhList = new List<BusinessHours>(); 
       BusinessHours bh = new BusinessHours();
       bhList.add(bh); 
                
       RecordType rt =[Select Id, Name from RecordType where Name=:'Support Services NBN Co'];  
       
       List<Case> caseList = new List<Case>(); 
       Case cs1a = new Case(); 
       cs1a.AccountId = acc.id;
       cs1a.ContactId = con.id;
       cs1a.Steps_to_Follow__c ='text';     
       cs1a.Type = 'Problem';      
       cs1a.Status = 'In Progress';
       cs1a.StatusDetails__c = 'Initial Response Provided' ;
       cs1a.PrioritybasedonType__c = '1 - Critical';
       cs1a.Origin = 'Email';  
       cs1a.RecordTypeId = rt.Id;
       cs1a.NetworkPicklist__c ='NBNCo';
       cs1a.Subject ='text';
       cs1a.Description = 'text';
       caseList.add(cs1a);
       insert caseList ;
       
       cs1a.PrioritybasedonType__c = '1 - Critical';
       cs1a.Type= 'Incident' ;
        
       update cs1a; 
    }
    static testmethod void ViasatUpdateSLATest2() {
        Integer numOfObjs = 1;
        List<Account> accounts = ViasatTestUtility.createAccounts(numOfObjs, 'test');
       accounts[0].Status__c = 'Prospect';
       accounts[0].Type = 'Contractor';  
       accounts[0].Industry = 'Air Force'; 
       accounts[0].Country__c = 'India'; 
        insert accounts;
        List<Contact> contacts = ViasatTestUtility.createContacts(accounts, numOfObjs);
        insert contacts;      

		Account acc = accounts[0]; 
		Contact con = contacts[0];       
       
       List<SLA__c > slaList = new List<SLA__c >();
       Map<Id, SLA__c> SLAMap = new Map<Id, SLA__c>();
       
                
       SLA__c sla1 = new SLA__c();    
       sla1.Account__c = acc.ID;
       sla1.CasePriority__c = 'Major';
       sla1.CaseType__c = 'Incident/Problem';
       sla1.SLAInitialResponseTime__c = '20 Minutes';
       sla1.SLAWorkaroundTime__c= '12 Hours';
       sla1.SLAResolutionTime__c = '3 Days';
       slaList.add(sla1); 
               
            
       SLA__c sla2 = new SLA__c();              
       sla2.Account__c = acc.ID;
       sla2.CasePriority__c = 'Low';
       sla2.CaseType__c = 'Inquiry';
       sla2.SLAInitialResponseTime__c = '2 Hours';
       sla2.SLAWorkaroundTime__c= ' '; 
       sla2.SLAResolutionTime__c = '2 Days';
       slaList.add(sla2);
       
         
       SLA__c sla4 = new SLA__c();              
       sla4.Account__c = acc.ID;
       sla4.CasePriority__c = 'Minor';
       sla4.CaseType__c = 'Fault';
       sla4.SLAInitialResponseTime__c = '2 Hours';
       sla4.SLAWorkaroundTime__c= '2 Days'; 
       sla4.SLAResolutionTime__c = '7 Days'; 
       slaList.add(sla4);
       
        
       SLA__c sla5 = new SLA__c();              
       sla5.Account__c = acc.ID;
       sla5.CasePriority__c = 'Major';
       sla5.CaseType__c = 'Fault';
       sla5.SLAInitialResponseTime__c = '20 Minutes';
       sla5.SLAWorkaroundTime__c= '12 Hours'; 
       sla5.SLAResolutionTime__c = '15 Days'; 
       slaList.add(sla5); 
       
       
       SLA__c sla6 = new SLA__c();              
       sla6.Account__c = acc.ID;
       sla6.CasePriority__c = 'Minor';
       sla6.CaseType__c = 'Problem';
       sla6.SLAInitialResponseTime__c = '2 Hours';
       sla6.SLAWorkaroundTime__c= '2 Days';  
       sla6.SLAResolutionTime__c = '7 Days';
       slaList.add(sla6); 
       
       SLA__c sla7 = new SLA__c();              
       sla7.Account__c = acc.ID;
       sla7.CasePriority__c = 'Critical';
       sla7.CaseType__c = 'Incident/Problem';
       sla7.SLAInitialResponseTime__c = '10 Minutes';
       sla7.SLAWorkaroundTime__c= '12 Hours'; 
       sla7.SLAResolutionTime__c = '1 Day';
       slaList.add(sla7);  
        
       SLA__c sla3 = new SLA__c();              
       sla3.Account__c = acc.ID;
       sla3.CasePriority__c = 'Critical';
       sla3.CaseType__c = 'Fault';
       sla3.SLAInitialResponseTime__c = '10 Minutes';
       sla3.SLAWorkaroundTime__c= '12 Hours'; 
       sla3.SLAResolutionTime__c = '15 Days'; 
       slaList.add(sla3);
       
       insert slaList;
               
       RecordType rt =[Select Id, Name from RecordType where Name=:'Support Services NBN Co'];  
       
       List<Case> caseList = new List<Case>(); 
       Case cs1a = new Case(); 
       cs1a.AccountId = acc.id;
       cs1a.ContactId = con.id;
       cs1a.Steps_to_Follow__c ='text';     
       cs1a.Type = 'Fault';
       cs1a.Status = 'In Progress';
       cs1a.StatusDetails__c = 'Initial Response Provided' ;
       cs1a.PrioritybasedonType__c = '1 - Critical';
       cs1a.Origin = 'Email';  
       cs1a.RecordTypeId = rt.Id;
       cs1a.NetworkPicklist__c ='NBNCo';
       cs1a.Subject ='text';
       cs1a.Description = 'text';
       caseList.add(cs1a);
       insert caseList ;
           
       cs1a.PrioritybasedonType__c = '2 - Major';
       cs1a.Type= 'Fault' ;
       update cs1a;  
       
    }    
    
    static testmethod void ViasatUpdateSLATest3() {
        Integer numOfObjs = 1;
        List<Account> accounts = ViasatTestUtility.createAccounts(numOfObjs, 'test');
       accounts[0].Status__c = 'Prospect';
       accounts[0].Type = 'Contractor';  
       accounts[0].Industry = 'Air Force'; 
       accounts[0].Country__c = 'India'; 
        insert accounts;
        List<Contact> contacts = ViasatTestUtility.createContacts(accounts, numOfObjs);
        insert contacts;      

		Account acc = accounts[0]; 
		Contact con = contacts[0];       
       
       List<SLA__c > slaList = new List<SLA__c >();
       Map<Id, SLA__c> SLAMap = new Map<Id, SLA__c>();
         
       SLA__c sla2 = new SLA__c();              
       sla2.Account__c = acc.ID;
       sla2.CasePriority__c = 'Low';
       sla2.CaseType__c = 'Inquiry';
       sla2.SLAInitialResponseTime__c = '2 Hours';
       sla2.SLAWorkaroundTime__c= ' '; 
       sla2.SLAResolutionTime__c = '2 Days';
       slaList.add(sla2);
        
       SLA__c sla3 = new SLA__c();              
       sla3.Account__c = acc.ID;
       sla3.CasePriority__c = 'Critical';
       sla3.CaseType__c = 'Fault';
       sla3.SLAInitialResponseTime__c = '10 Minutes';
       sla3.SLAWorkaroundTime__c= '12 Hours'; 
       sla3.SLAResolutionTime__c = '15 Days'; 
       slaList.add(sla3); 
       
         
       SLA__c sla4 = new SLA__c();              
       sla4.Account__c = acc.ID;
       sla4.CasePriority__c = 'Minor';
       sla4.CaseType__c = 'Fault';
       sla4.SLAInitialResponseTime__c = '2 Hours';
       sla4.SLAWorkaroundTime__c= '2 Days'; 
       sla4.SLAResolutionTime__c = '7 Days'; 
       slaList.add(sla4);
       
        
       SLA__c sla5 = new SLA__c();              
       sla5.Account__c = acc.ID;
       sla5.CasePriority__c = 'Major';
       sla5.CaseType__c = 'Fault';
       sla5.SLAInitialResponseTime__c = '20 Minutes';
       sla5.SLAWorkaroundTime__c= '12 Hours'; 
       sla5.SLAResolutionTime__c = '15 Days'; 
       slaList.add(sla5); 
       
       
       SLA__c sla6 = new SLA__c();              
       sla6.Account__c = acc.ID;
       sla6.CasePriority__c = 'Minor';
       sla6.CaseType__c = 'Problem';
       sla6.SLAInitialResponseTime__c = '2 Hours';
       sla6.SLAWorkaroundTime__c= '2 Days';  
       sla6.SLAResolutionTime__c = '7 Days';
       slaList.add(sla6); 
       
       SLA__c sla7 = new SLA__c();              
       sla7.Account__c = acc.ID;
       sla7.CasePriority__c = 'Critical';
       sla7.CaseType__c = 'Incident/Problem';
       sla7.SLAInitialResponseTime__c = '10 Minutes';
       sla7.SLAWorkaroundTime__c= '12 Hours'; 
       sla7.SLAResolutionTime__c = '1 Day';
       slaList.add(sla7);  
        
           
       SLA__c sla1 = new SLA__c();    
       sla1.Account__c = acc.ID;
       sla1.CasePriority__c = 'Major';
       sla1.CaseType__c = 'Incident/Problem';
       sla1.SLAInitialResponseTime__c = '20 Minutes';
       sla1.SLAWorkaroundTime__c= '12 Hours';
       sla1.SLAResolutionTime__c = '3 Days';
       slaList.add(sla1);  
       
       insert slaList;
               
       RecordType rt =[Select Id, Name from RecordType where Name=:'Support Services NBN Co'];  
       
       List<Case> caseList = new List<Case>(); 
       Case cs1a = new Case(); 
       cs1a.AccountId = acc.id;
       cs1a.ContactId = con.id;
       cs1a.Steps_to_Follow__c ='text';     
       cs1a.Type = 'Incident';
       cs1a.Status = 'In Progress';
       cs1a.StatusDetails__c = 'Initial Response Provided' ;
       cs1a.PrioritybasedonType__c = '2 - Major';
       cs1a.Origin = 'Email';  
       cs1a.RecordTypeId = rt.Id;
       cs1a.NetworkPicklist__c ='NBNCo';
       cs1a.Subject ='text';
       cs1a.Description = 'text';
       caseList.add(cs1a);
       insert caseList ;
         
       cs1a.PrioritybasedonType__c = '2 - Major';
       cs1a.Type= 'Problem' ;
        
       update cs1a; 
             
    }  
    
    static testmethod void ViasatUpdateSLATest4() {
        Integer numOfObjs = 1;
        List<Account> accounts = ViasatTestUtility.createAccounts(numOfObjs, 'test');
       accounts[0].Status__c = 'Prospect';
       accounts[0].Type = 'Contractor';  
       accounts[0].Industry = 'Air Force'; 
       accounts[0].Country__c = 'India'; 
        insert accounts;
        List<Contact> contacts = ViasatTestUtility.createContacts(accounts, numOfObjs);
        insert contacts;      

		Account acc = accounts[0]; 
		Contact con = contacts[0];       
       
       List<SLA__c > slaList = new List<SLA__c >();
       Map<Id, SLA__c> SLAMap = new Map<Id, SLA__c>();
        
       SLA__c sla1 = new SLA__c();    
       sla1.Account__c = acc.ID;
       sla1.CasePriority__c = 'Major';
       sla1.CaseType__c = 'Incident/Problem';
       sla1.SLAInitialResponseTime__c = '20 Minutes';
       sla1.SLAWorkaroundTime__c= '12 Hours';
       sla1.SLAResolutionTime__c = '3 Days';
       slaList.add(sla1); 
         
       SLA__c sla2 = new SLA__c();              
       sla2.Account__c = acc.ID;
       sla2.CasePriority__c = 'Low';
       sla2.CaseType__c = 'Inquiry';
       sla2.SLAInitialResponseTime__c = '2 Hours';
       sla2.SLAWorkaroundTime__c= ' '; 
       sla2.SLAResolutionTime__c = '2 Days';
       slaList.add(sla2);
        
       SLA__c sla3 = new SLA__c();              
       sla3.Account__c = acc.ID;
       sla3.CasePriority__c = 'Critical';
       sla3.CaseType__c = 'Fault';
       sla3.SLAInitialResponseTime__c = '10 Minutes';
       sla3.SLAWorkaroundTime__c= '12 Hours'; 
       sla3.SLAResolutionTime__c = '15 Days'; 
       slaList.add(sla3); 
       
         
       SLA__c sla4 = new SLA__c();              
       sla4.Account__c = acc.ID;
       sla4.CasePriority__c = 'Minor';
       sla4.CaseType__c = 'Fault';
       sla4.SLAInitialResponseTime__c = '2 Hours';
       sla4.SLAWorkaroundTime__c= '2 Days'; 
       sla4.SLAResolutionTime__c = '7 Days'; 
       slaList.add(sla4);
       
       SLA__c sla6 = new SLA__c();              
       sla6.Account__c = acc.ID;
       sla6.CasePriority__c = 'Minor';
       sla6.CaseType__c = 'Problem';
       sla6.SLAInitialResponseTime__c = '2 Hours';
       sla6.SLAWorkaroundTime__c= '2 Days';  
       sla6.SLAResolutionTime__c = '7 Days';
       slaList.add(sla6); 
       
       SLA__c sla7 = new SLA__c();              
       sla7.Account__c = acc.ID;
       sla7.CasePriority__c = 'Critical';
       sla7.CaseType__c = 'Incident/Problem';
       sla7.SLAInitialResponseTime__c = '10 Minutes';
       sla7.SLAWorkaroundTime__c= '12 Hours'; 
       sla7.SLAResolutionTime__c = '1 Day';
       slaList.add(sla7);  
        
       SLA__c sla5 = new SLA__c();              
       sla5.Account__c = acc.ID;
       sla5.CasePriority__c = 'Major';
       sla5.CaseType__c = 'Fault';
       sla5.SLAInitialResponseTime__c = '20 Minutes';
       sla5.SLAWorkaroundTime__c= '12 Hours'; 
       sla5.SLAResolutionTime__c = '15 Days'; 
       slaList.add(sla5);  
           
            
       insert slaList;
               
       RecordType rt =[Select Id, Name from RecordType where Name=:'Support Services NBN Co'];  
       
       List<Case> caseList = new List<Case>(); 
       Case cs1a = new Case(); 
       cs1a.AccountId = acc.id;
       cs1a.ContactId = con.id;
       cs1a.Steps_to_Follow__c ='text';     
       cs1a.Type = 'Fault';
       cs1a.Status = 'In Progress';
       cs1a.StatusDetails__c = 'Initial Response Provided' ;
       
       cs1a.PrioritybasedonType__c = '2 - Major';
      
       
       cs1a.Origin = 'Email';  
       cs1a.RecordTypeId = rt.Id;
       cs1a.NetworkPicklist__c ='NBNCo';
       cs1a.Subject ='text';
       cs1a.Description = 'text';
       caseList.add(cs1a);
       insert caseList ;
       
       // Case 282319: PL - Dec 2014 - raising priority is not possible anymore (Validation rule) 
       // Test decrease priority
       // cs1a.PrioritybasedonType__c = '1 - Critical';
       // cs1a.Type= 'Fault' ;
       cs1a.PrioritybasedonType__c = '3 - Minor';
       
       update cs1a;  
                  
    } 
    
    static testmethod void ViasatUpdateSLATest5() {
        Integer numOfObjs = 1;
        List<Account> accounts = ViasatTestUtility.createAccounts(numOfObjs, 'test');
       accounts[0].Status__c = 'Prospect';
       accounts[0].Type = 'Contractor';  
       accounts[0].Industry = 'Air Force'; 
       accounts[0].Country__c = 'India'; 
        insert accounts;
        List<Contact> contacts = ViasatTestUtility.createContacts(accounts, numOfObjs);
        insert contacts;      

		Account acc = accounts[0]; 
		Contact con = contacts[0];       
       
       List<SLA__c > slaList = new List<SLA__c >();
       Map<Id, SLA__c> SLAMap = new Map<Id, SLA__c>();
        
       SLA__c sla1 = new SLA__c();    
       sla1.Account__c = acc.ID;
       sla1.CasePriority__c = 'Major';
       sla1.CaseType__c = 'Incident/Problem';
       sla1.SLAInitialResponseTime__c = '20 Minutes';
       sla1.SLAWorkaroundTime__c= '12 Hours';
       sla1.SLAResolutionTime__c = '3 Days';
       slaList.add(sla1); 
         
       SLA__c sla2 = new SLA__c();              
       sla2.Account__c = acc.ID;
       sla2.CasePriority__c = 'Low';
       sla2.CaseType__c = 'Inquiry';
       sla2.SLAInitialResponseTime__c = '2 Hours';
       sla2.SLAWorkaroundTime__c= ' '; 
       sla2.SLAResolutionTime__c = '2 Days';
       slaList.add(sla2);
        
       SLA__c sla3 = new SLA__c();              
       sla3.Account__c = acc.ID;
       sla3.CasePriority__c = 'Critical';
       sla3.CaseType__c = 'Fault';
       sla3.SLAInitialResponseTime__c = '10 Minutes';
       sla3.SLAWorkaroundTime__c= '12 Hours'; 
       sla3.SLAResolutionTime__c = '15 Days'; 
       slaList.add(sla3); 
       
         
       SLA__c sla4 = new SLA__c();              
       sla4.Account__c = acc.ID;
       sla4.CasePriority__c = 'Minor';
       sla4.CaseType__c = 'Fault';
       sla4.SLAInitialResponseTime__c = '2 Hours';
       sla4.SLAWorkaroundTime__c= '2 Days'; 
       sla4.SLAResolutionTime__c = '7 Days'; 
       slaList.add(sla4);
        
       SLA__c sla5 = new SLA__c();              
       sla5.Account__c = acc.ID;
       sla5.CasePriority__c = 'Major';
       sla5.CaseType__c = 'Fault';
       sla5.SLAInitialResponseTime__c = '20 Minutes';
       sla5.SLAWorkaroundTime__c= '12 Hours'; 
       sla5.SLAResolutionTime__c = '15 Days'; 
       slaList.add(sla5);  
              
       SLA__c sla7 = new SLA__c();              
       sla7.Account__c = acc.ID;
       sla7.CasePriority__c = 'Critical';
       sla7.CaseType__c = 'Incident/Problem';
       sla7.SLAInitialResponseTime__c = '10 Minutes';
       sla7.SLAWorkaroundTime__c= '12 Hours'; 
       sla7.SLAResolutionTime__c = '1 Day';
       slaList.add(sla7);  
        
               
       SLA__c sla6 = new SLA__c();              
       sla6.Account__c = acc.ID;
       sla6.CasePriority__c = 'Minor';
       sla6.CaseType__c = 'Problem';
       sla6.SLAInitialResponseTime__c = '2 Hours';
       sla6.SLAWorkaroundTime__c= '2 Days';  
       sla6.SLAResolutionTime__c = '7 Days';
       slaList.add(sla6);  
           
       insert slaList;
               
       RecordType rt =[Select Id, Name from RecordType where Name=:'Support Services NBN Co'];  
       
       List<Case> caseList = new List<Case>(); 
       Case cs1a = new Case(); 
       cs1a.AccountId = acc.id;
       cs1a.ContactId = con.id;
       cs1a.Steps_to_Follow__c ='text';     
       cs1a.Type = 'Problem';
       cs1a.Status = 'In Progress';
       cs1a.StatusDetails__c = 'Initial Response Provided' ;
       cs1a.PrioritybasedonType__c = '3 - Minor';
       cs1a.Origin = 'Email';  
       cs1a.RecordTypeId = rt.Id;
       cs1a.NetworkPicklist__c ='NBNCo';
       cs1a.Subject ='text';
       cs1a.Description = 'text';
       caseList.add(cs1a);
       insert caseList ;
       
      cs1a.PrioritybasedonType__c = '3 - Minor';
      cs1a.Type= 'Fault' ;  
       update cs1a;
       
    } 
    
    static testmethod void ViasatUpdateSLATest6() {
        Integer numOfObjs = 1;
        List<Account> accounts = ViasatTestUtility.createAccounts(numOfObjs, 'test');
       accounts[0].Status__c = 'Prospect';
       accounts[0].Type = 'Contractor';  
       accounts[0].Industry = 'Air Force'; 
       accounts[0].Country__c = 'India'; 
        insert accounts;
        List<Contact> contacts = ViasatTestUtility.createContacts(accounts, numOfObjs);
        insert contacts;      

		Account acc = accounts[0]; 
		Contact con = contacts[0];       
       
       List<SLA__c > slaList = new List<SLA__c >();
       Map<Id, SLA__c> SLAMap = new Map<Id, SLA__c>();
        
       SLA__c sla1 = new SLA__c();    
       sla1.Account__c = acc.ID;
       sla1.CasePriority__c = 'Major';
       sla1.CaseType__c = 'Incident/Problem';
       sla1.SLAInitialResponseTime__c = '20 Minutes';
       sla1.SLAWorkaroundTime__c= '12 Hours';
       sla1.SLAResolutionTime__c = '3 Days';
       slaList.add(sla1); 
         
       SLA__c sla2 = new SLA__c();              
       sla2.Account__c = acc.ID;
       sla2.CasePriority__c = 'Low';
       sla2.CaseType__c = 'Inquiry';
       sla2.SLAInitialResponseTime__c = '2 Hours';
       sla2.SLAWorkaroundTime__c= ' '; 
       sla2.SLAResolutionTime__c = '2 Days';
       slaList.add(sla2);
        
       SLA__c sla3 = new SLA__c();              
       sla3.Account__c = acc.ID;
       sla3.CasePriority__c = 'Critical';
       sla3.CaseType__c = 'Fault';
       sla3.SLAInitialResponseTime__c = '10 Minutes';
       sla3.SLAWorkaroundTime__c= '12 Hours'; 
       sla3.SLAResolutionTime__c = '15 Days'; 
       slaList.add(sla3); 
       
       SLA__c sla5 = new SLA__c();              
       sla5.Account__c = acc.ID;
       sla5.CasePriority__c = 'Major';
       sla5.CaseType__c = 'Fault';
       sla5.SLAInitialResponseTime__c = '20 Minutes';
       sla5.SLAWorkaroundTime__c= '12 Hours'; 
       sla5.SLAResolutionTime__c = '15 Days'; 
       slaList.add(sla5);  
        
       SLA__c sla6 = new SLA__c();              
       sla6.Account__c = acc.ID;
       sla6.CasePriority__c = 'Minor';
       sla6.CaseType__c = 'Problem';
       sla6.SLAInitialResponseTime__c = '2 Hours';
       sla6.SLAWorkaroundTime__c= '2 Days';  
       sla6.SLAResolutionTime__c = '7 Days';
       slaList.add(sla6); 
              
       SLA__c sla7 = new SLA__c();              
       sla7.Account__c = acc.ID;
       sla7.CasePriority__c = 'Critical';
       sla7.CaseType__c = 'Incident/Problem';
       sla7.SLAInitialResponseTime__c = '10 Minutes';
       sla7.SLAWorkaroundTime__c= '12 Hours'; 
       sla7.SLAResolutionTime__c = '1 Day';
       slaList.add(sla7);  
        
       SLA__c sla4 = new SLA__c();              
       sla4.Account__c = acc.ID;
       sla4.CasePriority__c = 'Minor';
       sla4.CaseType__c = 'Fault';
       sla4.SLAInitialResponseTime__c = '2 Hours';
       sla4.SLAWorkaroundTime__c= '2 Days'; 
       sla4.SLAResolutionTime__c = '7 Days'; 
       slaList.add(sla4); 
           
            
       insert slaList;
               
       RecordType rt =[Select Id, Name from RecordType where Name=:'Support Services NBN Co'];  
       
       List<Case> caseList = new List<Case>(); 
       Case cs1a = new Case(); 
       cs1a.AccountId = acc.id;
       cs1a.ContactId = con.id;
       cs1a.Steps_to_Follow__c ='text';     
       cs1a.Type = 'Fault';
       cs1a.Status = 'In Progress';
       cs1a.StatusDetails__c = 'Initial Response Provided' ;
       cs1a.PrioritybasedonType__c = '3 - Minor';
       cs1a.Origin = 'Email';  
       cs1a.RecordTypeId = rt.Id;
       cs1a.NetworkPicklist__c ='NBNCo';
       cs1a.Subject ='text';
       cs1a.Description = 'text';
       caseList.add(cs1a); 
       insert caseList ;
           
       cs1a.PrioritybasedonType__c = '3- Minor';
       cs1a.Type = 'Problem';
       update cs1a; 
    }  
    
     static testmethod void ViasatUpdateSLATest7() {
        Integer numOfObjs = 1;
        List<Account> accounts = ViasatTestUtility.createAccounts(numOfObjs, 'test');
       accounts[0].Status__c = 'Prospect';
       accounts[0].Type = 'Contractor';  
       accounts[0].Industry = 'Air Force'; 
       accounts[0].Country__c = 'India'; 
        insert accounts;
        List<Contact> contacts = ViasatTestUtility.createContacts(accounts, numOfObjs);
        insert contacts;      

		Account acc = accounts[0]; 
		Contact con = contacts[0];       
       
       List<SLA__c > slaList = new List<SLA__c >();
       Map<Id, SLA__c> SLAMap = new Map<Id, SLA__c>();
        
       SLA__c sla1 = new SLA__c();    
       sla1.Account__c = acc.ID;
       sla1.CasePriority__c = 'Major';
       sla1.CaseType__c = 'Incident/Problem';
       sla1.SLAInitialResponseTime__c = '20 Minutes';
       sla1.SLAWorkaroundTime__c= '12 Hours';
       sla1.SLAResolutionTime__c = '3 Days';
       slaList.add(sla1); 
         
            
       SLA__c sla3 = new SLA__c();              
       sla3.Account__c = acc.ID;
       sla3.CasePriority__c = 'Critical';
       sla3.CaseType__c = 'Fault';
       sla3.SLAInitialResponseTime__c = '10 Minutes';
       sla3.SLAWorkaroundTime__c= '12 Hours'; 
       sla3.SLAResolutionTime__c = '15 Days'; 
       slaList.add(sla3); 
       
       SLA__c sla4 = new SLA__c();              
       sla4.Account__c = acc.ID;
       sla4.CasePriority__c = 'Minor';
       sla4.CaseType__c = 'Fault';
       sla4.SLAInitialResponseTime__c = '2 Hours';
       sla4.SLAWorkaroundTime__c= '2 Days'; 
       sla4.SLAResolutionTime__c = '7 Days'; 
       slaList.add(sla4);   
          
        
       SLA__c sla5 = new SLA__c();              
       sla5.Account__c = acc.ID;
       sla5.CasePriority__c = 'Major';
       sla5.CaseType__c = 'Fault';
       sla5.SLAInitialResponseTime__c = '20 Minutes';
       sla5.SLAWorkaroundTime__c= '12 Hours'; 
       sla5.SLAResolutionTime__c = '15 Days'; 
       slaList.add(sla5);  
        
       SLA__c sla6 = new SLA__c();              
       sla6.Account__c = acc.ID;
       sla6.CasePriority__c = 'Minor';
       sla6.CaseType__c = 'Problem';
       sla6.SLAInitialResponseTime__c = '2 Hours';
       sla6.SLAWorkaroundTime__c= '2 Days';  
       sla6.SLAResolutionTime__c = '7 Days';
       slaList.add(sla6); 
              
       SLA__c sla7 = new SLA__c();              
       sla7.Account__c = acc.ID;
       sla7.CasePriority__c = 'Critical';
       sla7.CaseType__c = 'Incident/Problem';
       sla7.SLAInitialResponseTime__c = '10 Minutes';
       sla7.SLAWorkaroundTime__c= '12 Hours'; 
       sla7.SLAResolutionTime__c = '1 Day';
       slaList.add(sla7);  
           
       
       SLA__c sla2 = new SLA__c();              
       sla2.Account__c = acc.ID;
       sla2.CasePriority__c = 'Low';
       sla2.CaseType__c = 'Inquiry';
       sla2.SLAInitialResponseTime__c = '2 Hours';
       sla2.SLAWorkaroundTime__c= ' '; 
       sla2.SLAResolutionTime__c = '2 Days';
       slaList.add(sla2);  
           
            
       insert slaList;
               
       RecordType rt =[Select Id, Name from RecordType where Name=:'Support Services NBN Co'];  
       
       List<Case> caseList = new List<Case>(); 
       Case cs1a = new Case(); 
       cs1a.AccountId = acc.id;
       cs1a.ContactId = con.id;
       cs1a.Steps_to_Follow__c ='text';     
       cs1a.Type = 'Technical Inquiry';
       cs1a.Status = 'In Progress';
       cs1a.StatusDetails__c = 'Initial Response Provided' ;
       cs1a.PrioritybasedonType__c = '4 - Normal';
       cs1a.Origin = 'Email';  
       cs1a.RecordTypeId = rt.Id;
       cs1a.NetworkPicklist__c ='NBNCo';
       cs1a.Subject ='text';
       cs1a.Description = 'text';
       caseList.add(cs1a);
       insert caseList ;
         
       cs1a.PrioritybasedonType__c = '4 - Normal';
       cs1a.Type= 'Fault' ;
       
       update cs1a;   
       
    }  
     static testmethod void ViasatUpdateSLATest8() {
        Integer numOfObjs = 1;
        List<Account> accounts = ViasatTestUtility.createAccounts(numOfObjs, 'test');
       accounts[0].Status__c = 'Prospect';
       accounts[0].Type = 'Contractor';  
       accounts[0].Industry = 'Air Force'; 
       accounts[0].Country__c = 'India'; 
        insert accounts;
        List<Contact> contacts = ViasatTestUtility.createContacts(accounts, numOfObjs);
        insert contacts;      

		Account acc = accounts[0]; 
		Contact con = contacts[0];       
       
       List<SLA__c > slaList = new List<SLA__c >();
       Map<Id, SLA__c> SLAMap = new Map<Id, SLA__c>();
       
       SLA__c sla1 = new SLA__c();  
       sla1.Account__c = acc.ID;
       sla1.CasePriority__c = 'Major';
       sla1.CaseType__c = 'Incident/Problem';
       sla1.SLAInitialResponseTime__c = '20 Minutes';
       sla1.SLAWorkaroundTime__c= '12 Hours';
       sla1.SLAResolutionTime__c = '3 Days';
       slaList.add(sla1); 
               
         
       SLA__c sla2 = new SLA__c();              
       sla2.Account__c = acc.ID;
       sla2.CasePriority__c = 'Low';
       sla2.CaseType__c = 'Inquiry';
       sla2.SLAInitialResponseTime__c = '2 Hours';
       sla2.SLAWorkaroundTime__c= ' '; 
       sla2.SLAResolutionTime__c = '2 Days';
       slaList.add(sla2); 
        
            
       insert slaList;         
         
       RecordType rt =[Select Id, Name from RecordType where Name=:'Support Services NBN Co'];  
       
       try {  
       List<Case> caseList = new List<Case>(); 
       Case cs1a = new Case(); 
       cs1a.AccountId = acc.id;
       cs1a.ContactId = con.id;
       cs1a.Steps_to_Follow__c ='text';     
       cs1a.Type = 'Technical Inquiry';
       cs1a.Status = 'In Progress';
       cs1a.StatusDetails__c = 'Initial Response Provided' ;
       cs1a.PrioritybasedonType__c = '4 - Normal';
       cs1a.Origin = 'Email';  
       cs1a.RecordTypeId = rt.Id;
       cs1a.NetworkPicklist__c ='NBNCo'; 
       cs1a.Subject ='text';
       cs1a.Description = 'text'; 
       caseList.add(cs1a);
       insert caseList ;
       
       cs1a.PrioritybasedonType__c = '4 - Normal';
       cs1a.Type= 'Technical Inquiry' ;
       
       update cs1a; 
       } catch(Exception ex) {
             ex.getMessage();
       }
	}
}