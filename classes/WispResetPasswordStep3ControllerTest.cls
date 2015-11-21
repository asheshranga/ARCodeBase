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
private class WispResetPasswordStep3ControllerTest {
    
    static testMethod void testResetPasswordController() { 
        
        AtlasTestMainClass.setTestKeyValueStoreForAtlas();
        AtlasSecurityQuestionsList1__c sq1 = new AtlasSecurityQuestionsList1__c();
        sq1.name = 'sq1';
        sq1.Value__c = 'What is the name of your pet';
        insert sq1;
        
        AtlasSecurityQuestionsList__c sq = new AtlasSecurityQuestionsList__c();
        sq.name = 'sq1';
        sq.Value__c = 'What is the name of your pet';
        insert sq;
        
        Test.startTest();
        WispResetPasswordStep3Controller wrpsCon = new WispResetPasswordStep3Controller();
        AtlasComponenttoController c = new AtlasComponenttoController();     
        c.userName = 'mjefferson';
        wrpsCon.password = 'testPwd';
        wrpsCon.confirmPwd = wrpsCon.password;
        wrpsCon.componentToPage = c; 
        wrpsCon.NextStep3();  
        wrpsCon.createUserLockRecord(11, 'test');
        wrpsCon.Cancel();
        wrpsCon.redirectToForgotUsername();
        wrpsCon.getOptionsForQ1();
        wrpsCon.getOptionsForQ2();
        Test.stopTest();
    }       
    
    static testMethod void testResetLoginNameDiff() { 
        
        AtlasTestMainClass.setTestKeyValueStoreForAtlas();
        
        Test.startTest();
        WispResetPasswordStep3Controller wrpsCon = new WispResetPasswordStep3Controller();
        AtlasComponenttoController c = new AtlasComponenttoController();     
        c.userName = 'test';
        wrpsCon.password = 'testPwd';
        wrpsCon.confirmPwd = wrpsCon.password;
        wrpsCon.componentToPage = c; 
        wrpsCon.NextStep3();  
        wrpsCon.createUserLockRecord(11, 'test');
        wrpsCon.Cancel();
        Test.stopTest();
    }      
    
    static testMethod void testResetUNandPWSame() { 
        
        AtlasTestMainClass.setTestKeyValueStoreForAtlas();        
        Test.startTest();
        WispResetPasswordStep3Controller wrpsCon = new WispResetPasswordStep3Controller();
        AtlasComponenttoController c = new AtlasComponenttoController();     
        c.userName = 'sameusernamandpassword';
        wrpsCon.password = 'sameusernamandpassword';
        wrpsCon.confirmPwd = wrpsCon.password;
        wrpsCon.componentToPage = c; 
        wrpsCon.NextStep3();  
        wrpsCon.createUserLockRecord(11, 'test');
        wrpsCon.Cancel();
        Test.stopTest();
    }
    
    static testMethod void testException() { 
        
        Test.startTest();
        WispResetPasswordStep3Controller wrpsCon = new WispResetPasswordStep3Controller();
        AtlasComponenttoController c = new AtlasComponenttoController();     
        c.userName = 'test';
        wrpsCon.password = 'testPwd';
        wrpsCon.confirmPwd = wrpsCon.password;
        wrpsCon.componentToPage = c; 
        wrpsCon.NextStep3();  
        wrpsCon.createUserLockRecord(11, 'test');
        wrpsCon.Cancel();
        Test.stopTest();
    }     
    
    @isTest(SeeAllData=true)
    static void testAllVariables()
    {
        AtlasTestMainClass.setTestKeyValueStoreForAtlas();  
        WispResetPasswordStep3Controller wrpsCon = new WispResetPasswordStep3Controller();
        System.assertNotEquals(null,wrpsCon.resetPwd_Uname);
        System.assertNotEquals(null,wrpsCon.plsUname);
        System.assertNotEquals(null,wrpsCon.UnameText);
        System.assertNotEquals(null,wrpsCon.required);
        System.assertNotEquals(null,wrpsCon.accNotFoundText);
        System.assertNotEquals(null,wrpsCon.liveChat);
        System.assertNotEquals(null,wrpsCon.toGetHelp);
        System.assertNotEquals(null,wrpsCon.resetPWDSQ);
        System.assertNotEquals(null,wrpsCon.firstQ);
        System.assertNotEquals(null,wrpsCon.firstQA);
        System.assertNotEquals(null,wrpsCon.secondQ);
        System.assertNotEquals(null,wrpsCon.secondQA);
        System.assertNotEquals(null,wrpsCon.forgotUNameLink);
        System.assertNotEquals(null,wrpsCon.sQIncorrect);
        System.assertNotEquals(null,wrpsCon.sQIncorrect5minutes);
        System.assertNotEquals(null,wrpsCon.AccLocked);
        System.assertNotEquals(null,wrpsCon.AccLocked1);
        System.assertNotEquals(null,wrpsCon.AccLocked2);
        System.assertNotEquals(null,wrpsCon.speakRep);
        System.assertNotEquals(null,wrpsCon.resetPWDNew);
        System.assertNotEquals(null,wrpsCon.pwdText);
        System.assertNotEquals(null,wrpsCon.weak);
        System.assertNotEquals(null,wrpsCon.good);
        System.assertNotEquals(null,wrpsCon.strong);
        System.assertNotEquals(null,wrpsCon.rePwd);
        System.assertNotEquals(null,wrpsCon.finished);
        System.assertNotEquals(null,wrpsCon.pwdDone);
        System.assertNotEquals(null,wrpsCon.nextStep);
        System.assertNotEquals(null,wrpsCon.cancel);
        System.assertNotEquals(null,wrpsCon.loginHelpText);
        System.assertNotEquals(null,wrpsCon.note);
        System.assertNotEquals(null,wrpsCon.loginPblmText);
        System.assertNotEquals(null,wrpsCon.chooseOne);
        System.assertNotEquals(null,wrpsCon.strInvalidPwd);
        System.assertNotEquals(null,wrpsCon.validemail);
        System.assertNotEquals(null,wrpsCon.uNameLimit);
        System.assertNotEquals(null,wrpsCon.unamereqd);
        System.assertNotEquals(null,wrpsCon.firstAnswerReqd);
        System.assertNotEquals(null,wrpsCon.secondAnswerReqd);
        System.assertNotEquals(null,wrpsCon.pwdReqd);
        System.assertNotEquals(null,wrpsCon.cpwdReqd);
        System.assertNotEquals(null,wrpsCon.sqhelp);
        System.assertNotEquals(null,wrpsCon.newUnameHelp);
        System.assertNotEquals(null,wrpsCon.newUnameHelp1);
        System.assertNotEquals(null,wrpsCon.newUnameHelp2);
        System.assertNotEquals(null,wrpsCon.sqHelpText);
        System.assertNotEquals(null,wrpsCon.sqAnswerHelpText);
        System.assertNotEquals(null,wrpsCon.passwordHelpText);
        System.assertNotEquals(null,wrpsCon.pwdvalid1);
        System.assertNotEquals(null,wrpsCon.pwdvalid2);
        System.assertNotEquals(null,wrpsCon.pwdvalid3);
        System.assertNotEquals(null,wrpsCon.pwdvalid4);
        System.assertNotEquals(null,wrpsCon.pwdvalid5);
        System.assertNotEquals(null,wrpsCon.pwdvalid6);
        System.assertNotEquals(null,wrpsCon.resetPswd);
        System.assertNotEquals(null,wrpsCon.newPswd);
        System.assertNotEquals(null,wrpsCon.step3);
        
        wrpsCon.isStep1 = true;
        wrpsCon.isStep2 = true;
        wrpsCon.isStep3 = true;
        wrpsCon.isFinal = true;
        
        wrpsCon.selectedSQA1 = 'test';
        wrpsCon.selectedSQA2 = 'test';
        
        wrpsCon.toatlIncorrect = 0;
        
        wrpsCon.sqQuestion1= 'test';
        wrpsCon.sqQuestion2= 'test';
        
    }
    
}