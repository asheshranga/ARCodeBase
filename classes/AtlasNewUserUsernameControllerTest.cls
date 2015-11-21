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
private class AtlasNewUserUsernameControllerTest {
    
    static testMethod void testAtlasNewUserUsernameController()
    {
        
        AtlasTestMainClass.setTestKeyValueStoreForAtlas();
        AtlasTestMainClass.createCommunityUser();
        
        New_User_Registration_History__c objNUR= new New_User_Registration_History__c();
        objNUR.Username__c='Test';
        objNUR.Time_Stamp__c=system.now();
        objNUR.Step2_Username__c=true;
        objNUR.Error_Message__c='';
        objNUR.Step4_Security_Questions__c = true;
        objNUR.Step6_Account_Created__c = false;
        objNUR.Send_Email__c = false;
        insert objNUR;
        
        
        AtlasComponenttoController c = new AtlasComponenttoController();     
        c.nurhNumber = [select name from New_User_Registration_History__c where id = :objNUR.id ].name;
        
        Test.startTest();
        AtlasNewUserUsernameController anewuCont = new AtlasNewUserUsernameController();
        anewuCont.componentToPage = c;
        anewuCont.submitStep2();
        anewuCont.cancel();
        anewuCont.notYouMSG();
        anewuCont.createnewUserRegistrationHistroy('testuname', 'testerrmsg', true);        
        Test.stopTest();
    }
    
}