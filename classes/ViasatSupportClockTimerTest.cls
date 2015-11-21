/*
Author: Rajesh
Project: Viasat NBNCo Customer Portal
Date: Oct 2013
Purpose: Test Method for 1. 'ViasatSupportClockTimer' Apex, 
                         2. 'CaseBefore', 'CaseAfter Trigger 
                         3. 'ViasatUtilityClass' Apex
*/
@isTest
public class ViasatSupportClockTimerTest
{
   public static Case ViasatSupportInit()
   {
     	List<Account> accounts = ViasatTestUtility.createAccounts(1, 'test');
        accounts[0].Labor_Hours_Required__c = 'No';   
        insert accounts;
        
		List<Contact> con = ViasatTestUtility.createContacts(accounts, 1);
        insert con;
        
        List<RecordType> rtypes = [Select Name, Id From RecordType where Name='Support Services NBN Co'];
        
        integer numOfObjsPerAccounts = 7;
		List<SLA__c> sla = ViasatTestUtility.createSLAObjs(accounts, numOfObjsPerAccounts);

        sla[0].SLAInitialResponseTime__c = '10 Minutes';
        sla[0].SLAWorkaroundTime__c = '12 Hours';
        sla[0].SLAResolutionTime__c = '1 Day';

        sla[1].CaseType__c = 'Fault';
        sla[1].SLAInitialResponseTime__c = '10 Minutes';
        sla[1].SLAWorkaroundTime__c = '12 Hours';
        sla[1].SLAResolutionTime__c = '15 Days';
        
        sla[2].CasePriority__c = 'Major';
        sla[2].SLAInitialResponseTime__c = '20 Minutes';
        sla[2].SLAWorkaroundTime__c = '12 Hours';
        sla[2].SLAResolutionTime__c = '3 Days';

        sla[3].CasePriority__c = 'Major';
        sla[3].CaseType__c = 'Fault';
        sla[3].SLAInitialResponseTime__c = '20 Minutes';
        sla[3].SLAWorkaroundTime__c = '12 Hours';
        sla[3].SLAResolutionTime__c = '15 Days';

        sla[4].CasePriority__c = 'Minor';
        sla[4].SLAInitialResponseTime__c = '2 Hours';
        sla[4].SLAWorkaroundTime__c = '2 Days';
        sla[4].SLAResolutionTime__c = '7 Days';

        sla[5].CasePriority__c = 'Minor';
        sla[5].CaseType__c = 'Fault';
        sla[5].SLAInitialResponseTime__c = '2 Hours';
        sla[5].SLAWorkaroundTime__c = '2 Days';
        sla[5].SLAResolutionTime__c = '7 Days';

        sla[6].CasePriority__c = 'Low';
        sla[6].CaseType__c = 'Inquiry';
        sla[6].SLAInitialResponseTime__c = '2 Hours';
        sla[6].SLAWorkaroundTime__c = '0';
        sla[6].SLAResolutionTime__c = '2 Days';

        insert sla;
       
        ViasatUtilityClass.isRunTestNBNCoTrigger = False;
        Case c = new Case();
        c.Origin = 'Email';
        c.VisibleToCustomer__c = 'Yes';
        c.Type = 'Problem';
        c.Status = 'New';
        c.Subject = 'My Test';
        c.PrioritybasedonType__c = '1 - Critical';
        //c.createdDate = System.today();
        c.Description = 'Hai This is NTT DATA';
        c.AccountID = accounts[0].id;
        c.ContactID = con[0].id;
        c.Recordtypeid = rtypes[0].id;       
        return c;
   }   

   static testmethod void ViasatSupportClockTimerTest1()
   {      
		Case c = ViasatSupportInit();
        insert c;        
        c = [SELECT id,createddate FROM Case WHERE Id = :c.Id LIMIT 1];        
        System.assertEquals(c.createddate.date(),system.now().date());
        System.currentPageReference().getParameters().put('id', c.id);
        ApexPages.StandardController sc = new ApexPages.standardController(c);
        ViasatSupportClockTimer ct = new ViasatSupportClockTimer(sc);
        ct.updateRunningstate();
       
         c.PrioritybasedonType__c = '2 - Major';
         c.Type = 'Fault';
         c.Status = 'On Hold';
         c.StatusDetails__c = 'Waiting for Information';       
         update c;        
        
        Datetime today = System.today();
        Datetime anotherday = today + 3;
        //ViasatUtilityClass.BusinessDurationBetweenTwoDateTimes(today, anotherday);
        ViasatUtilityClass.BusinessSecondsBetweenTwoDateTimes(today, anotherday);

     c.PrioritybasedonType__c = '2 - Major';
     c.Type = 'Problem';
     c.Status = 'In Progress';
     c.StatusDetails__c = 'Initial Response Provided';
     c.Steps_to_Follow__c = 'Test';
     update c;   
        
     c.PrioritybasedonType__c = '3 - Minor';
     c.Type = 'Problem';   
     c.Status = 'In Progress';
     c.StatusDetails__c = 'Workaround Provided';
     c.WorkaroundDescription__c = 'Test Workaround description';
     c.Steps_to_Follow__c = 'required by FIELD_CUSTOM_VALIDATION_EXCEPTION';
     update c;     

     c.Status = 'On Hold';
     c.StatusDetails__c = 'Management Review Workaround';
     update c;

     c.StatusDetails__c = 'Management Review Final Resolution';
     update c;

     c.Status = 'Resolved';      
     c.ResolutionDescription__c = 'Test Resolution';  
     update c;

     c.Status = 'Closed';        
     update c;

      // PL - Dec 2014 - Case 282319. Do not change priority and type- may interfere with validation rules  
      // c.PrioritybasedonType__c = '1 - Critical';
      // c.Type = 'Fault';      
      c.Status = 'In Progress';
      c.StatusDetails__c = 'Workaround Provided';
      c.WorkaroundDescription__c = 'Test Workaround description';
      c.Steps_to_Follow__c = 'required by FIELD_CUSTOM_VALIDATION_EXCEPTION';
      update c;    
   }
       
   static testmethod Case ViasatSupportClockTimerTest2()
   {         
		Case c = ViasatSupportInit();
        insert c;        
        c = [SELECT id,createddate FROM Case WHERE Id = :c.Id LIMIT 1];        
        System.assertEquals(c.createddate.date(),system.now().date());
        System.currentPageReference().getParameters().put('id', c.id);
        ApexPages.StandardController sc = new ApexPages.standardController(c);
        ViasatSupportClockTimer ct = new ViasatSupportClockTimer(sc);
        ct.updateRunningstate();
        
         c.PrioritybasedonType__c = '1 - Critical';
         c.Type = 'Problem';        
         c.Status = 'Resolved';      
         c.ResolutionDescription__c = 'Test Resolution'; 
         update c;        
		return c;
   }
     
	static testmethod void ViasatSupportClockTimerTest3()
	{ 
		Case c = ViasatSupportInit();
		c.Type = 'Fault';
        c.PrioritybasedonType__c = '2 - Major';
        insert c;                    
        c = [SELECT id,createddate FROM Case WHERE Id = :c.Id LIMIT 1];        
        System.assertEquals(c.createddate.date(),system.now().date());
        System.currentPageReference().getParameters().put('id', c.id);
        ApexPages.StandardController sc = new ApexPages.standardController(c);
        ViasatSupportClockTimer ct = new ViasatSupportClockTimer(sc);
        ct.updateRunningstate();
        
        System.assertEquals(c.createddate.date(),system.now().date());         
        c.Status = 'In Progress';
        c.StatusDetails__c = 'Workaround Provided';
        c.WorkaroundDescription__c = 'Test Workaround description'; 
        c.Steps_to_Follow__c = 'required by FIELD_CUSTOM_VALIDATION_EXCEPTION';
        update c;        

		c.Status = 'On Hold';
		c.StatusDetails__c = 'Management Review Workaround';
		update c;

		c.Status = 'On Hold';
		c.StatusDetails__c = 'Management Review Final Resolution';
		update c;
	}
   
	static testmethod void ViasatSupportClockTimerTest4()
	{ 
		Case c = ViasatSupportInit();
        c.Status = 'In Progress';
        c.StatusDetails__c = 'Initial Response Provided';
        c.Steps_to_Follow__c = 'Test Step';
        c.PrioritybasedonType__c = '3 - Minor';
        insert c;
        c = [SELECT id,createddate FROM Case WHERE Id = :c.Id LIMIT 1];        
        System.assertEquals(c.createddate.date(),system.now().date());
        System.currentPageReference().getParameters().put('id', c.id);
        ApexPages.StandardController sc = new ApexPages.standardController(c);
        ViasatSupportClockTimer ct = new ViasatSupportClockTimer(sc);
        ct.updateRunningstate();
	}
}