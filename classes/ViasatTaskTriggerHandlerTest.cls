/*********************************************************************************
Name         : ViasatTaskTriggerHandlerTest
Created By   : Lynnet Ambrocio
Company Name : Slalom Consulting
Created Date : 9/2/2015
Usages       : Test Class for Apex Class: ViasatTaskTriggerHandler
*********************************************************************************/
@isTest
public class ViasatTaskTriggerHandlerTest {

    static testMethod void testHandlerMethod() {
        ViasatTaskTriggerHandler handler = new ViasatTaskTriggerHandler();
        
         //Added by Jaspreet
        
        CaseKeyValueStore__c[] customSettings = new CaseKeyValueStore__c[]{         
     new CaseKeyValueStore__c(name='ITSMS_RT_NAME', Value__c='ITSMS - General')
    ,new CaseKeyValueStore__c(name='ORIGIN_PHONE', Value__c='Phone')
    ,new CaseKeyValueStore__c(name='SERVICE_DESK', Value__c='Service Desk')  
        };
        insert customSettings;
        
        //Create test data
        ViaSatTaskKeyValueStore__c keyValues = new ViaSatTaskKeyValueStore__c(Name='ViaSat_Logo',
                                                                              Value__c='https://viasat--devsup2--c.cs23.content.force.com/servlet/servlet.ImageServer?id=015180000000VrN&oid=00D180000004XVR&lastMod=1436227658000');
        insert keyValues;

        Profile p = [SELECT Id FROM Profile WHERE Name='IT: System Administrator']; 
        User testUser = new User(Alias = 'standt', Email='standarduser@testorg.com', 
                                 EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                                 LocaleSidKey='en_US', ProfileId = p.Id, 
                                 TimeZoneSidKey='America/Los_Angeles', UserName='testuser@viasat.com');
        
        insert testUser;
 
        CCR__c ccr = new CCR__c();
        insert ccr;
        
        List<task> insertTasks = new List<Task>();
        Task t1 = new Task();
        Task t2 = new Task();
        Task t3 = new Task();
        System.runAs(testUser){
        
        
        t1.RecordTypeId = [SELECT Id,SobjectType,Name FROM RecordType WHERE Name ='CCR' AND SobjectType ='Task' LIMIT 1].Id;
        t1.WhatId = ccr.Id;
		t1.Status = 'New';
		t1.ownerId = testUser.Id;
		insertTasks.add(t1);
        
        
        Case c = new Case();
        //c.SlaStartDate = Datetime.Now();
        c.RecordTypeId = [SELECT Id,SobjectType,Name FROM RecordType WHERE SobjectType ='Case' and developerName = :ViasatTaskTriggerHandler.CASE_ITSMS_RT LIMIT 1].Id;
        insert c;
        
        User u = [select id from User where id != :UserInfo.getUserId() and id != :testUser.id  and profileId =: UserInfo.getProfileId() limit 1];
        t2.RecordTypeId = [SELECT Id,SobjectType,Name FROM RecordType WHERE Name ='ITSMS' AND SobjectType ='Task' LIMIT 1].Id;
        t2.WhatId = c.Id;
		t2.Status = 'Completed';
		t2.ownerId = u.id;
		insertTasks.add(t2);
        
        t3.RecordTypeId = [SELECT Id,SobjectType,Name FROM RecordType WHERE Name ='ITSMS' AND SobjectType ='Task' LIMIT 1].Id;
        t3.WhatId = c.Id;
		t3.Status = 'Completed';
		t3.ownerId = u.id;
		t3.type = 'Email';
		insertTasks.add(t3);
        
            
        }    
        
        //Perform test
        Test.startTest();
        insert insertTasks;
        //handler.handlerMethod(new List<Task>(), new map<id,Task>(), new map<id,Task>(), true, false);
        Test.stopTest();
    }
    
}