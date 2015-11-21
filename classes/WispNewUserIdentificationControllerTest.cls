/*********************************************************************************
Name         : WispNewUserIdentificationControllerTest
Created By   : Lynnet Ambrocio
Company Name : Slalom Consulting
Project      : ViaSat Wisp
Created Date : 8/17/2015
Usages       : Test Class for Apex Class: WispNewUserIdentificationController
*********************************************************************************/
@isTest
private class WispNewUserIdentificationControllerTest {
    
    static private void createData() {
        // Setup test data
        ApexPages.currentPage().getHeaders().put('True-Client-IP', '1234');
        ApexPages.currentPage().getHeaders().put('X-Salesforce-SIP', '22.231.113.64');   
        
        List<AtlasKeyValueStore__c> atlasKeyValues = new List<AtlasKeyValueStore__c>();
        List<WISPKeyValueStore__c> wispKeyValues = new List<WISPKeyValueStore__c>();
        
        AtlasKeyValueStore__c loginaccNotFound = new AtlasKeyValueStore__c(Name = 'LOGIN_ACC_NOT_FOUND_TEXT', Code__c = 'LOGIN_ACC_NOT_FOUND_TEXT', Value__c = 'We cannot locate your account in the system. Please');
        atlasKeyValues.add(loginaccNotFound);
        
        AtlasKeyValueStore__c loginCCNo = new AtlasKeyValueStore__c(Name = 'LOGIN_CC_NO_TEXT', Code__c = 'LOGIN_CC_NO_TEXT', Value__c = '(855) 463-9333');
        atlasKeyValues.add(loginCCNo);
        
        AtlasKeyValueStore__c macRequired = new AtlasKeyValueStore__c(Name = 'LOGIN_MAC_VALIDATE', Code__c = 'LOGIN_MAC_VALIDATE', Value__c = 'MAC Address is required.');
        atlasKeyValues.add(macRequired);
        
        AtlasKeyValueStore__c phoneRequired = new AtlasKeyValueStore__c(Name = 'LOGIN_PHONE_VALIDATE', Code__c = 'LOGIN_PHONE_VALIDATE', Value__c = 'Phone Number is required.');
        atlasKeyValues.add(phoneRequired);
        
        AtlasKeyValueStore__c emailRequired = new AtlasKeyValueStore__c(Name = 'LOGIN_EMAIL_VALIDATE', Code__c = 'LOGIN_EMAIL_VALIDATE', Value__c = 'Email value is required.');
        atlasKeyValues.add(emailRequired);
        
        AtlasKeyValueStore__c validemail = new AtlasKeyValueStore__c(Name = 'PLS_EMAIL_VALID', Code__c = 'PLS_EMAIL_VALID', Value__c = 'Please make sure you have entered a valid email address.');
        atlasKeyValues.add(validemail);
        
        AtlasKeyValueStore__c whatisThis = new AtlasKeyValueStore__c(Name = 'WHAT_IS_THIS', Code__c = 'WHAT_IS_THIS', Value__c = 'Where is this info?');
        atlasKeyValues.add(whatisThis);
        
        AtlasKeyValueStore__c macaddressLabel = new AtlasKeyValueStore__c(Name = 'LOGIN_MAC_INST_TEXT', Code__c = 'LOGIN_MAC_INST_TEXT', Value__c = 'You can find your "MAC Address" here.');
        atlasKeyValues.add(macaddressLabel);
        
        AtlasKeyValueStore__c userExist1 = new AtlasKeyValueStore__c(Name = 'USER_EXIST1', Code__c = 'USER_EXIST1', Value__c = 'We already have a');
        atlasKeyValues.add(userExist1);
        
        AtlasKeyValueStore__c userExist2 = new AtlasKeyValueStore__c(Name = 'USER_EXIST2', Code__c = 'USER_EXIST2', Value__c = 'username');
        atlasKeyValues.add(userExist2);
        
        AtlasKeyValueStore__c userExist3 = new AtlasKeyValueStore__c(Name = 'USER_EXIST3', Code__c = 'USER_EXIST3', Value__c = 'password');
        atlasKeyValues.add(userExist3);
        
        AtlasKeyValueStore__c userExist4 = new AtlasKeyValueStore__c(Name = 'USER_EXIST4', Code__c = 'USER_EXIST4', Value__c = 'associated with this account.');
        atlasKeyValues.add(userExist4);
        
        AtlasKeyValueStore__c userExist5 = new AtlasKeyValueStore__c(Name = 'USER_EXIST5', Code__c = 'USER_EXIST5', Value__c = 'If you have forgotten your username or password please try');
        atlasKeyValues.add(userExist5);
        
        WISPKeyValueStore__c loginMacText = new WISPKeyValueStore__c(Name = 'WispLoginMacText', Code__c = 'WispLoginMacText', Value__c = '00570000002LdbG,00570000001UXGf,00570000002LWZr,00570000001UOQ7,00570000002KSrB');
        wispKeyValues.add(loginMacText);
        
        AtlasKeyValueStore__c phoneemailHelpText = new AtlasKeyValueStore__c(Name = 'PH,EMAIL_HELP_TEXT', Code__c = 'PH,EMAIL_HELP_TEXT', Value__c = 'Please enter your primary phone number or email.');
        atlasKeyValues.add(phoneemailHelpText);
        
        AtlasKeyValueStore__c userIdentHelpText1 = new AtlasKeyValueStore__c(Name = 'USER_IDENT_HELP_TEXT_1', Code__c = 'USER_IDENT_HELP_TEXT_1', Value__c = 'To access your account information and management tools, you’ll need to log in with a username and password. If this is your first time accessing the system,');
        atlasKeyValues.add(userIdentHelpText1);
        
        AtlasKeyValueStore__c userIdentHelpText2 = new AtlasKeyValueStore__c(Name = 'USER_IDENT_HELP_TEXT_2', Code__c = 'USER_IDENT_HELP_TEXT_2', Value__c = 'you can create a username and password in just a few simple steps, using either your Exede account number or the MAC address located on the bottom of your modem.');
        atlasKeyValues.add(userIdentHelpText2);
        
        AtlasKeyValueStore__c MacDigits = new AtlasKeyValueStore__c(Name = 'MAC_DIGITS', Code__c = 'MAC_DIGITS', Value__c = 'Please enter at least 12 characters MAC address.');
        atlasKeyValues.add(MacDigits);
        
        AtlasKeyValueStore__c PhoneDigits = new AtlasKeyValueStore__c(Name = 'PHONE_DIGITS', Code__c = 'PHONE_DIGITS', Value__c = 'Please enter a valid phone number.');
        atlasKeyValues.add(PhoneDigits);
        
        AtlasKeyValueStore__c MacPlaceHolder = new AtlasKeyValueStore__c(Name = 'MAC_PLACE_HOLDER', Code__c = 'MAC_PLACE_HOLDER', Value__c = 'e.g. 1A:2B:3C:1A:2B:3C');
        atlasKeyValues.add(MacPlaceHolder);
        
        AtlasKeyValueStore__c PhonePlaceHolder = new AtlasKeyValueStore__c(Name = 'PHONE_PLACE_HOLDER', Code__c = 'PHONE_PLACE_HOLDER', Value__c = 'e.g. (333) 333-4444');
        atlasKeyValues.add(PhonePlaceHolder);
        
        AtlasKeyValueStore__c EmailPlaceHolder = new AtlasKeyValueStore__c(Name = 'EMAIL_PLACE_HOLDER', Code__c = 'EMAIL_PLACE_HOLDER', Value__c = 'e.g. username@somehost.com');
        atlasKeyValues.add(EmailPlaceHolder);
        
        AtlasKeyValueStore__c AccLocked = new AtlasKeyValueStore__c(Name = 'ACC_LOCKED', Code__c = 'ACC_LOCKED', Value__c = 'Your account has been locked due to excessive login attempts.');
        atlasKeyValues.add(AccLocked);
        
        AtlasKeyValueStore__c AccLocked1 = new AtlasKeyValueStore__c(Name = 'ACC_LOCKED1', Code__c = 'ACC_LOCKED1', Value__c = 'Please call Customer Care at (855) 463-9333 to resolve this issue or wait');
        atlasKeyValues.add(AccLocked1);
        
        AtlasKeyValueStore__c AccLocked2 = new AtlasKeyValueStore__c(Name = 'ACC_LOCKED2', Code__c = 'ACC_LOCKED2', Value__c = 'minutes and try again.');
        atlasKeyValues.add(AccLocked2);
        
        AtlasKeyValueStore__c AccLocked5 = new AtlasKeyValueStore__c(Name = 'ACC_LOCKED5', Code__c = 'ACC_LOCKED5', Value__c = 'Your account has been locked due to excessive login attempts. Please call Customer Care at (855) 463-9333 to resolve this issue or wait 5 minutes and try again.');
        atlasKeyValues.add(AccLocked5);
        
        AtlasKeyValueStore__c AccPhoneEmail = new AtlasKeyValueStore__c(Name = 'ACC_EMAIL_PHONE', Code__c = 'ACC_EMAIL_PHONE', Value__c = 'We’re sorry, but the information you entered does not match the information we have on file. Please try a different phone number or email address. Please try again or contact Customer Care. (855) 463-9333.');
        atlasKeyValues.add(AccPhoneEmail);
        
        AtlasKeyValueStore__c Accpending = new AtlasKeyValueStore__c(Name = 'ACC_PENDING_ACTIVATION', Code__c = 'ACC_PENDING_ACTIVATION', Value__c = 'Your account is Pending Activation.');
        atlasKeyValues.add(Accpending);
        
        WISPKeyValueStore__c WispEmailPhoneIncorrect = new WISPKeyValueStore__c(Name = 'Wisp_New_User_Phone_Email_Incorrect', Code__c = 'Wisp_New_User_Phone_Email_Incorrect', Value__c = 'We are sorry, but the information you entered does not match the information we have on file. Please try a different phone number or email address. Please try again or contact your internet service provider.');
        wispKeyValues.add(WispEmailPhoneIncorrect);
        
        WISPKeyValueStore__c WispMacHelpText = new WISPKeyValueStore__c(Name = 'Wisp_ACC_HELP_TEXT_1', Code__c = 'Wisp_ACC_HELP_TEXT_1', Value__c = 'Your MAC address is located on the bottom of your internet modem.');
        wispKeyValues.add(WispMacHelpText);
        
        WISPKeyValueStore__c WispAccLocked1 = new WISPKeyValueStore__c(Name = 'Wisp_ACC_LOCKED1', Code__c = 'Wisp_ACC_LOCKED1', Value__c = 'Please call your support agent to resolve this issue or wait');
        wispKeyValues.add(WispAccLocked1);
        
        WISPKeyValueStore__c WispAccLocked5 = new WISPKeyValueStore__c(Name = 'Wisp_ACC_LOCKED5', Code__c = 'Wisp_ACC_LOCKED5', Value__c = 'Your account has been locked due to excessive login attempts. Please call your internet service provider to resolve this issue or wait 5 minutes and try again.');
        wispKeyValues.add(WispAccLocked5);
        
        WISPKeyValueStore__c WispuserIdentHelpText1 = new WISPKeyValueStore__c(Name = 'Wisp_USER_IDENT_HELP_TEXT_1', Code__c = 'Wisp_USER_IDENT_HELP_TEXT_1', Value__c = 'To access your account, you will need to log in with a username and password. If this is your first time accessing the system,');
        wispKeyValues.add(WispuserIdentHelpText1);
        
        WISPKeyValueStore__c WispuserIdentHelpText2 = new WISPKeyValueStore__c(Name = 'Wisp_USER_IDENT_HELP_TEXT_2', Code__c = 'Wisp_USER_IDENT_HELP_TEXT_2', Value__c = 'you can create a username and password in just a few simple steps, using your MAC address located on the bottom of your modem.');
        wispKeyValues.add(WispuserIdentHelpText2);
        
        insert atlasKeyValues;
        insert wispKeyValues;
        
        Atlas_User_Lock_Out__c user = new Atlas_User_Lock_Out__c(Name = '1234', Totalwrong__c = 2, Time_Value__c = System.now());
        insert user;
    }

    static testMethod void TestSubmitStep11() {
        
        //Setup test data
        createData();
        
        WispNewUserIdentificationController controller = new WispNewUserIdentificationController();
        
        // Set values
        controller.componentToPage = new AtlasComponenttoController();
        controller.MACValue1 = '1o:12:AB:12:CD:34';
        controller.MACValue2 = '1o:12:AB:12:CD:35';
        controller.MACValue3 = '1o:12:AB:12:CD:36';
        controller.MACValue4 = '1o:12:AB:12:CD:37';
        controller.MACValue5 = '1o:12:AB:12:CD:38';
        controller.MACValue6 = '1o:12:AB:12:CD:39';
        controller.phone1 = '310-222-4343';
        controller.phone2 = '310-222-4344';
        controller.phone3 = '310-222-4345';
        
        // Perform test
        Test.startTest();
        controller.submitStep1();
        Test.stopTest();
        
        // Verify
        System.assertEquals('New User', controller.newUserText);
        System.assertEquals('Identification', controller.identificationText);
        System.assertEquals('Problems with the following fields', controller.loginPblmText);
        System.assertEquals('Cancel', controller.cancel);
        System.assertEquals('Next Step', controller.nextStep);
        System.assertEquals('Step 1 of 4', controller.step);
        System.assertEquals('Note', controller.note);
        System.assertEquals('* required', controller.allFields);
        System.assertEquals('Login Help', controller.loginHelpText);
        System.assertEquals('We cannot locate your account in the system. Please', controller.loginaccNotFound);
        System.assertEquals(' or contact Customer Care.', controller.loginCCText);
        System.assertEquals('(855) 463-9333', controller.loginCCNo);
        
        System.assertEquals('MAC Address is required.', controller.macRequired);
        System.assertEquals('Phone Number is required.', controller.phoneRequired);
        System.assertEquals('Email value is required.', controller.emailRequired);
        System.assertEquals('Please make sure you have entered a valid email address.', controller.validemail);
        System.assertEquals('Where is this info?', controller.whatisThis);
        
        System.assertEquals('You can find your "MAC Address" here.', controller.macaddressLabel);
        System.assertEquals('Try Again', controller.tryAgain);
        System.assertEquals('Phone', controller.phone);
        System.assertEquals('Email', controller.email);
        System.assertEquals('Help', controller.help);
        System.assertEquals('We already have a', controller.userExist1);
        System.assertEquals('username', controller.userExist2);
        System.assertEquals('password', controller.userExist3);
        System.assertEquals('associated with this account.', controller.userExist4);
        System.assertEquals('If you have forgotten your username or password please try', controller.userExist5);
        System.assertEquals('00570000002LdbG,00570000001UXGf,00570000002LWZr,00570000001UOQ7,00570000002KSrB', controller.loginMacText);
        System.assertEquals('Please enter your primary phone number or email.', controller.phoneemailHelpText);
        System.assertEquals('To access your account information and management tools, you’ll need to log in with a username and password. If this is your first time accessing the system,', controller.userIdentHelpText1);
        System.assertEquals('you can create a username and password in just a few simple steps, using either your Exede account number or the MAC address located on the bottom of your modem.', controller.userIdentHelpText2);
        
        System.assertEquals('Please enter at least 12 characters MAC address.', controller.MacDigits);
        System.assertEquals('Please enter a valid phone number.', controller.PhoneDigits);
        
        System.assertEquals('e.g. 1A:2B:3C:1A:2B:3C', controller.MacPlaceHolder);
        System.assertEquals('e.g. (333) 333-4444', controller.PhonePlaceHolder);
        System.assertEquals('e.g. username@somehost.com', controller.EmailPlaceHolder);
        System.assertEquals('Your account has been locked due to excessive login attempts.', controller.AccLocked);
        System.assertEquals('Please call Customer Care at (855) 463-9333 to resolve this issue or wait', controller.AccLocked1);
        System.assertEquals('minutes and try again.', controller.AccLocked2);
        System.assertEquals('Your account has been locked due to excessive login attempts. Please call Customer Care at (855) 463-9333 to resolve this issue or wait 5 minutes and try again.', controller.AccLocked5);
        System.assertEquals('We’re sorry, but the information you entered does not match the information we have on file. Please try a different phone number or email address. Please try again or contact Customer Care. (855) 463-9333.', controller.AccPhoneEmail);
        System.assertEquals('Your account is Pending Activation.', controller.Accpending);
        System.assertEquals('We are sorry, but the information you entered does not match the information we have on file. Please try a different phone number or email address. Please try again or contact your internet service provider.', controller.WispEmailPhoneIncorrect);
        System.assertEquals('Your MAC address is located on the bottom of your internet modem.', controller.WispMacHelpText);
        System.assertEquals('Please call your support agent to resolve this issue or wait', controller.WispAccLocked1);
        System.assertEquals('Your account has been locked due to excessive login attempts. Please call your internet service provider to resolve this issue or wait 5 minutes and try again.', controller.WispAccLocked5);
        System.assertEquals('To access your account, you will need to log in with a username and password. If this is your first time accessing the system,', controller.WispuserIdentHelpText1);
        System.assertEquals('you can create a username and password in just a few simple steps, using your MAC address located on the bottom of your modem.', controller.WispuserIdentHelpText2);
         
    }
    
    static testMethod void TestSubmitStep12() {
        ApexPages.currentPage().getHeaders().put('X-Salesforce-SIP', '22.231.113.64');   
        
        WispNewUserIdentificationController controller = new WispNewUserIdentificationController();
        
        // Set values
        controller.componentToPage = new AtlasComponenttoController();
        controller.MACValue1 = '1o:12:AB:12:CD:34';
        controller.phone1 = '310-222-4343';
        
        // Perform test
        Test.startTest();
        controller.submitStep1();
        Test.stopTest();
    }
    
    static testMethod void TestSubmitStep13() {
        ApexPages.currentPage().getHeaders().put('True-Client-IP', '1234');
        
        // Setup data
        Atlas_User_Lock_Out__c user = new Atlas_User_Lock_Out__c(Name = '1234', Totalwrong__c = 5, Time_Value__c = System.now());
        insert user;
        
        WispNewUserIdentificationController controller = new WispNewUserIdentificationController();
        
        // Set values
        controller.componentToPage = new AtlasComponenttoController();
        controller.MACValue1 = '1o:12:AB:12:CD:34';
        controller.phone1 = '310-222-4343';
        
        // Perform test
        Test.startTest();
        controller.submitStep1();
        Test.stopTest();
    }
    
    static testMethod void TestTryAgain() {
        WispNewUserIdentificationController controller = new WispNewUserIdentificationController();
        
        // Set values
        controller.componentToPage = new AtlasComponenttoController();
        
        // Perform test
        Test.startTest();
        controller.tryAgain();
        Test.stopTest();
    }
    
    static testMethod void TestRedirectToLoginHelp() {
        WispNewUserIdentificationController controller = new WispNewUserIdentificationController();
        
        // Perform test
        Test.startTest();
        controller.redirectToLoginHelp();
        Test.stopTest();
    }
    
    static testMethod void TestCancel() {
        WispNewUserIdentificationController controller = new WispNewUserIdentificationController();
        
        // Perform test
        Test.startTest();
        controller.cancel();
        Test.stopTest();
    }
    
    static testMethod void TestClearFields() {
        WispNewUserIdentificationController controller = new WispNewUserIdentificationController();
        
        // Perform test
        Test.startTest();
        controller.clearFields();
        Test.stopTest();
    }
    
    static testMethod void TestCreatenewUserRegistrationHistroy() {
        WispNewUserIdentificationController controller = new WispNewUserIdentificationController();
        
        // Set values
        controller.componentToPage = new AtlasComponenttoController();
        
        controller.createnewUserRegistrationHistroy('1234', '1o:12:AB:12:CD:34', '310-222-4343', 'test@viasat.com', '22.231.113.64', 'Error occurred.', true);
        
        // TODO
    }
}