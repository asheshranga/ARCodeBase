// Test class for First Response Time ConversationTriggerTest

@isTest
Public class UpdateFirstResponceTime_Test 
{

    static testMethod void createInstanceOfConversation1()
    {
       
        sf4twitter__Twitter_Conversation__c conver= new sf4twitter__Twitter_Conversation__c();
        conver.sf4twitter__TwitterID__c = 'testntt';
        conver.First_Response_Time__c = system.now();
        insert conver;
               
    }
    
    static testMethod void createInstanceOfConversation2()
    {
        List<sf4twitter__Twitter_Conversation__c> lstConversation = new list<sf4twitter__Twitter_Conversation__c>();
        List<sf4twitter__Twitter_Conversation__c> lstConversation2 = new list<sf4twitter__Twitter_Conversation__c>();
        
        for(integer i=1; i<=100; i++) {       
        sf4twitter__Twitter_Conversation__c pConver= new sf4twitter__Twitter_Conversation__c();
        pConver.sf4twitter__TwitterID__c = 'testntt';
        pConver.First_Response_Time__c = null;
        lstConversation2.add(pConver);
        }
        insert lstConversation2;
        
        for(integer i=1; i<lstConversation2.size(); i++) {       
        sf4twitter__Twitter_Conversation__c conver1= new sf4twitter__Twitter_Conversation__c();
        conver1.sf4twitter__TwitterID__c = 'testntt1';
        conver1.First_Response_Time__c = null;
        conver1.sf4twitter__Parent__c = lstConversation2[i].id;
        lstConversation.add(conver1);
        }
        insert lstConversation;
        
        
        
    }
              
 }