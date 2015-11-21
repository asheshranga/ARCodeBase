/*
 * Class ITSMSMyAccountComponentControllerTest
 * 
 * @version 1.0
 * @author  Slalom  
 *  tests code coverage for ITSMSMyAccountComponentController in ITSMSMyAccountComponent
 */
@isTest
private class ITSMSMyAccountComponentControllerTest {
    
    static User UserRecordHelper(String fName, String lName) {
        User thisUser = [ select Id from User where Id = :UserInfo.getUserId() ];
        Profile p = [select Id,name from Profile where Name = 'ViaSat Support Center' limit 1];
             
        User newUser = new User(
            profileId = p.id,
            username = lName + '@yahoo.com',
            email = 'pb@ff.com',
            emailencodingkey = 'UTF-8',
            localesidkey = 'en_US',
            languagelocalekey = 'en_US',
            timezonesidkey = 'America/Los_Angeles',
            alias='nuser',
            lastname= lName,
            firstname = fName
        );
        insert newUser;  
        return newUser;        
    }
    
    static void SetupUserRecords() {
        User Charles = UserRecordHelper('Charles', 'Frank');
        User Olivia = UserRecordHelper('Olivia', 'Waller');
        Olivia.Delegate__c = Charles.Id;
        update Olivia;
    }
    
    
    //Test Method: Step 1- Onload
    static testMethod void OnPageLoad() {
        ITSMSTestDataSetup.createTestConstants();
        SetupUserRecords();
        User Olivia = [Select Id, Delegate__c from User where LastName = 'Waller' limit 1];
        User Charles = [Select Id, Delegate__c from User where LastName = 'Frank' limit 1];
        ITSMSMyAccountComponentController controller1, controller2;
        PageReference componentPage = Page.ITSMSSupportCenterHome;
        
        Test.startTest();
        System.runAs(Olivia) {
            controller1 = new ITSMSMyAccountComponentController();
            Test.setCurrentPage(componentPage);
        }
        System.runAs(Charles) {
            controller2 = new ITSMSMyAccountComponentController();
            Test.setCurrentPage(componentPage);
        }
        Test.stopTest();
       
        
        Olivia = [Select Id, Delegate__c from User where LastName = 'Waller' limit 1];
        Charles = [Select Id, Delegate__c from User where LastName = 'Frank' limit 1];
        System.assertEquals(Charles.Id, Olivia.Delegate__c);
        System.assertEquals(null, Charles.Delegate__c);
        System.assertEquals('Charles Frank', controller1.DelegateText);
        System.assertEquals('--None--', controller2.DelegateText);
        
    }
    
    //Test Method: Step 2- OnSave
    static testMethod void OnSaveClick() {
        ITSMSTestDataSetup.createTestConstants();
        SetupUserRecords();
        User Olivia = [Select Id, Delegate__c from User where LastName = 'Waller' limit 1];
        ITSMSMyAccountComponentController controller1;
        PageReference componentPage = Page.ITSMSSupportCenterHome;
        
        Test.startTest();
        System.runAs(Olivia) {
            controller1 = new ITSMSMyAccountComponentController();
            Test.setCurrentPage(componentPage);
            controller1.NewDelegate.Delegate__c = null;
            controller1.SaveAndToggle();
        }
        Test.stopTest();
       
        
        Olivia = [Select Id, Delegate__c from User where LastName = 'Waller' limit 1];
        System.assertEquals(null, Olivia.Delegate__c);
        System.assertEquals('--None--', controller1.DelegateText);
        
    }
}