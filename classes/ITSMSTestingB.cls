@isTest
public class ITSMSTestingB {
    static testMethod void testUtilityClassFailures(){
        
            ITSMSTestDataSetup.createTestConstants();
            ITSMSTestDataSetup.createRequestor();          
        
            String sysadmProfileId = [Select Id from Profile WHERE Name = 'System Administrator'].Id;
            User sysAdmin = [Select Id from User where ProfileId = :sysadmProfileId and IsActive = true limit 1];  
        	System.runAs(sysAdmin){
                ITSMSTestDataSetup.createTestContact();
            
                Account testAcc = [SELECT Id, Name FROM Account WHERE Name = 'testing'];
                
                // Force catch block of getExistingCase method
                ITSMSUtilityClass.getExistingCase('SELECT Id FROM Case WHERE Id =: inputCaseId', testAcc.Id);
                
                // Force catch block of getCases method        
                SET<Id> nonexistentIDs = new SET<Id>();
                nonexistentIDs.add(testAcc.Id);
                nonexistentIDs.add(testAcc.Id);
                ITSMSUtilityClass.getCases('SELECT Id FROM Case WHERE Id =: inputCaseId', nonexistentIDs);      
    
                // Force catch block of upsertCase method         
                Case newCase =  new Case();
                ITSMSUtilityClass.upsertCase(newCase);
            
                // Force catch block of insertCases method
                
                LIST<Case> newCaseList1 = new LIST<Case>();
                string inputCategory = ITSMSConstants.NEWHIRE;
                string srvreqType = ITSMSConstants.NEWHIRE_SRVREQTYPE_PARENT;
                Case addedCase = ITSMSUtilityClass.createCase(inputCategory, srvreqType);       		
                Case addedCase2 = new Case();                
                addedCase2.Id = addedCase.Id;
                newCaseList1.add(addedCase); 
                newCaseList1.add(addedCase2);                
                ITSMSUtilityClass.insertCases(newCaseList1);
            
                // Force catch block of getContacts method
                string contactQuery = 'SELECT Id FROM Contacts';
                Set<String> queryList = new Set<String>(); 
                ITSMSUtilityClass.getContacts(contactQuery, queryList);            
            
                // Force catch block of createParentCase method
                Case case1 = ITSMSUtilityClass.createParentCase('test');
                Case case2 = ITSMSUtilityClass.createParentCase('test2');        
                Case case3 = ITSMSUtilityClass.createParentCase('test');
                
                // Force catch block of deleteCase method
                ITSMSUtilityClass.deleteCase(case1);
                ITSMSUtilityClass.deleteCase(case1);        
            
                // Force catch block of validateAndUpdateCases method 
				
                ITSMSUtilityClass.validateAndUpdateCases(newCaseList1);
            
                // Force catch block of deleteCaseTeam method 
                LIST<CaseTeamMember> newCaseTeamList1 = new LIST<CaseTeamMember>();
                ITSMSUtilityClass.deleteCaseTeam(newCaseTeamList1);
            
                // Force catch block of getEntitlement method    
                String nullString;  
                ITSMSUtilityClass.getEntitlement(nullString);
            
                // Force catch block of updateDelegate method
                ITSMSUtilityClass.updateDelegate(NULL);
            
                // Force catch block of insertPermission method        
                LIST<ITSMSPermission__c> newPermissionList = new LIST<ITSMSPermission__c>();
                ITSMSPermission__c newPermission = new ITSMSPermission__c();
                newPermissionList.add(newPermission);
                ITSMSUtilityClass.insertPermission(newPermissionList);
                ITSMSUtilityClass.insertPermission(newPermissionList);                
            
                // Forcec catch block of getObjectRecordTypeId method
                ITSMSUtilityClass.getObjectRecordTypeId(Account.sobjecttype, 'Should Not Exist');
            }
    }      
    
    static testMethod void testFormatUserAccess(){
        ITSMSTestDataSetup.createTestConstants();
        ITSMSTestDataSetup.createRequestor(); 
        string inputCategory = ITSMSConstants.NEWHIRE;
        string srvreqType = ITSMSConstants.NEWHIRE_SRVREQTYPE_PARENT;
        Case addedCase = ITSMSUtilityClass.createCase(inputCategory, srvreqType);
        User communityUser = [SELECT Id FROM User WHERE Firstname = 'Community'];
        String sysadmProfileId = [Select Id from Profile WHERE Name = 'System Administrator'].Id;
        User sysAdmin = [Select Id from User where ProfileId = :sysadmProfileId and IsActive = true limit 1];        
        System.runAs(sysAdmin){
            LIST<ITSMSPermission__c> newPermissionList = new LIST<ITSMSPermission__c>();        
            ITSMSPermission__c newPermission = new ITSMSPermission__c();
            newPermission.AddMember__c = true; 
            newPermission.AddToGroup__c = true;
            ITSMSUtilityClass.insertPermission(newPermissionList);       
            ITSMSUtilityClass.formatUserAccess(ITSMSConstants.CASE_RECORDTYPE, addedCase);
           
        }
    }
}