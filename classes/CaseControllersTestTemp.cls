@isTest
private class CaseControllersTestTemp 
{
// Initialize needed custom settings
  public static void setCustomSettings() 
  {  
    ViasatTestUtility.setNBNCoKeyvalueStore();
    ViasatTestUtility.setGlobals();
    ViasatTestUtility.setCaseKeyValueStore();
    ITSMSKeyValueStore__c test = new ITSMSKeyValueStore__c();
    test.name = 'ContactRecordType';
    test.Code__c ='ContactRecordType';
    test.Value1__c = 'ITSMS Contact';
    insert test;
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
    
  }
    
}