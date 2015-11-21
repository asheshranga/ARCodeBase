/*********************************************************************************
Name         : AtlasSSOTestClass
Created By   : Shiva Shankar Nalluri
Modified BY  : Shiva Shankar Nalluri
Company Name : NTT Data
Project      : ViaSat Atlas, Bangalore
Created Date : 
Modified Date: 
Usages       : Test class 
*********************************************************************************/
@isTest
public with sharing class AtlasSSOTestClass {
    
    static void createCommunityUser(){
        Integer numOfObjs = 1;
        List<Account> accounts = ViasatTestUtility.createAccounts(numOfObjs, 'dummyTestAcc');
        insert accounts;
        List<Contact> contacts = ViasatTestUtility.createContacts(accounts, numOfObjs);
        insert contacts;

        User thisUser = [ select Id from User where Id = :UserInfo.getUserId() ];
        System.assertEquals(UserInfo.getUserId(),thisUser.id);
        System.runAs ( thisUser ) {
             // commented UserRole - by Sujit - not needed
             //   UserRole ur = [Select PortalType, PortalAccountId From UserRole where PortalType =:'CustomerPortal' limit 1];
                Profile p = [select Id,name from Profile where Name Like 'ATLAS Community%'  limit 1];
                User newUser = new User(
                 // commented UserRoleId -  by Sujit - not needed
                //    UserRoleId = ur.Id,
                    profileId = p.id,
                    username = 'dummtyTestUser@visasat.com',
                    email = 'dummtyTestUser@visasat.com',
                    emailencodingkey = 'UTF-8',
                    localesidkey = 'en_US',
                    languagelocalekey = 'en_US',
                    timezonesidkey = 'America/Los_Angeles',
                    alias='nuser',
                    lastname='lastname',
                    contactId = contacts[0].id,
                    ExternalAccountReference__c='486108'
                );
                insert newUser;  
                System.assertEquals(newUser.username,'dummtyTestUser@visasat.com');
            }
    }
    
    static void createDataForEachTest()
    {
        AtlasTestMainClass.setTestKeyValueStoreForAtlas();
        List<AtlasKeyValueStore__c>keyList=(List<AtlasKeyValueStore__c>)JSON.deserialize(AtlasTestConstants.getMetadata('KEY_VAL_STORE_UPDATED'),List<AtlasKeyValueStore__c>.class);
        for(AtlasKeyValueStore__c vTemp:keyList)
        vTemp.Id=null;
        insert keyList;
        List<AtlasPlan__c> atlasPlans=(List<AtlasPlan__c>)JSON.deserialize(AtlasTestConstants.getMetadata('atlasPlans'),List<AtlasPlan__c>.class);
        for(AtlasPlan__c vTemp:atlasPlans)
        vTemp.Id=null;
        insert atlasPlans;
        
        List<User_Lock_Outs__c> lockouts=(List<User_Lock_Outs__c>)JSON.deserialize(AtlasTestConstants.getMetadata('getLockOutValues'),List<User_Lock_Outs__c>.class);
        for(User_Lock_Outs__c vTemp:lockouts)
        vTemp.Id=null;
        insert lockouts;
        
    }
    @isTest 
    static void testLoginHelpPage()
    {  
        createDataForEachTest();
        Test.startTest();
        PageReference pageRef=Page.atlasLoginHelp; //replace with your VF page name
        Test.setCurrentPage(pageRef);
        AtlasLoginHelpController l= new AtlasLoginHelpController();
        //new AtlasHeaderController();
        AtlasLoginHelpChoicesController lh=new AtlasLoginHelpChoicesController();
        lh.componentToPage= new AtlasComponenttoController();
        lh.getOptions();
        lh.Cancel();
        lh.submitStep1();
        lh.selectedValue='';
        lh.submitStep1();
        lh.selectedValue=AtlasConstants.RESET_PASSWORD;
        lh.submitStep1();
        AtlasLoginHelpUsernameController lhu=new AtlasLoginHelpUsernameController();
        lhu.componentToPage=new AtlasComponenttoController();
        User_Lock_Outs__c obj3= new User_Lock_Outs__c(Name='Test',SessionId__c=userInfo.getSessionId(),Totalwrong__c=5,TimeValue__c=system.now());
        insert obj3;
        lhu.ReturnValue='Test';
        lhu.submitStep1();
        lhu.cancel();
        lhu.ClearFields();
        lhu.accountNumber='300368434';
        lhu.submitStep1();
        lhu.accountNumber='131746111729';
        lhu.submitStep1();
        lhu.accountNumber='';
        lhu.MACValue1='oo:Ao:bc:2f:61:81';
        lhu.submitStep1();
        lhu.MACValue1='oo:Ao:bc:2f:61:82';
        lhu.submitStep1();
        lhu.tryAgain();
        LHU.redirectToNewUserSetup();
        createCommunityUser();
        lhu.sendUserNametoUser('srikanth.kudumula@nttdata.com','486108');
        AtlasLoginHelpPasswordController lhp=new AtlasLoginHelpPasswordController();
        lhp.componentToPage=new AtlasComponenttoController();
        lhp.Cancel();
        lhp.CleasrFields();
        lhp.getOptionsForQ1();
        lhp.getOptionsForQ2();
        lhp.userName='13:09:13:17:14';
        lhp.componentToPage.subscriberKey=101378421367068l;
        lhp.ReturnValue='Test';
        User_Lock_Outs__c obj= new User_Lock_Outs__c(Name='Test',SessionId__c=userInfo.getSessionId(),Totalwrong__c=4,TimeValue__c=system.now());
        insert obj;
        lhp.NextStep1();
        //lhp.NextStep2();
        User_Lock_Outs__c obj1= new User_Lock_Outs__c(Name='13:09:13:17:14',SessionId__c='tset------',Totalwrong__c=5,TimeValue__c=system.now());
        insert obj1;
        //lhp.NextStep2();
        lhp.selectedSQA1='Q1';
        lhp.sqAnswer1='A1';
        lhp.selectedSQA2='Q2';
        lhp.sqAnswer2='A2';
        lhp.componentToPage.userName='mjefferson';
        lhp.componentToPage.securityQ1='Q1';
        lhp.componentToPage.securityQ2='Q2';
        lhp.componentToPage.securityQA1=' A1';
        lhp.componentToPage.securityQA2=' A2';
        //lhp.NextStep2();
        lhp.password='Test';
        lhp.confirmPwd='Test';
        lhp.NextStep3();
        lhp.password='Test';
        lhp.confirmPwd='Test';
        lhp.componentToPage.userName='mjefferson';
        lhp.NextStep3();
        lhp.password='Test';
        lhp.confirmPwd='Test';
        lhp.componentToPage.userName='mjefferson1';
        lhp.NextStep3();
        lhp.redirectToForgotUsername();
        lhp.Finished();
        lhp.sqAnswer1='Test';
        lhp.isMaskedSQA1();
        lhp.sqAnswer2='Test';
        lhp.isMaskedSQA2();
        lhp.maskedSQAnswer1='Test';
        lhp.maskedSQAnswer2='Test';
        lhp.isMaskedSQA1Changed();
        lhp.isMaskedSQA2Changed();
        lhp.isNotMaskedSQA1();
        lhp.isNotMaskedSQA2();
        new AtlasFooterController();
        Test.stopTest();
    }
    @isTest 
    static void testLoginHelpPage1()
    { 
        Test.startTest();
        PageReference pageRef=Page.atlasLoginHelp; //replace with your VF page name
        Test.setCurrentPage(pageRef);
        AtlasLoginHelpController l= new AtlasLoginHelpController();
        AtlasLoginHelpPasswordController lhp=new AtlasLoginHelpPasswordController();
        lhp.componentToPage=new AtlasComponenttoController();
        lhp.userName='13:09:13:17:14';
        lhp.componentToPage.subscriberKey=101378421367068l;
        User_Lock_Outs__c obj= new User_Lock_Outs__c(Name='Test',SessionId__c=userInfo.getSessionId(),Totalwrong__c=5,TimeValue__c=system.now());
        insert obj;
        lhp.NextStep1();
        lhp.userName='13:09:13:17:14';
        lhp.password='13:09:13:17:14';
        lhp.confirmPwd='13:09:13:17:14';
        lhp.NextStep3();
        Test.stopTest();
    }
    @isTest 
    static void testLoginHelpPage2()
    {
        AtlasTestMainClass.setTestKeyValueStoreForAtlas();
        List<User_Lock_Outs__c> lockouts=(List<User_Lock_Outs__c>)JSON.deserialize(AtlasTestConstants.getMetadata('getLockOutValues1'),List<User_Lock_Outs__c>.class);
        for(User_Lock_Outs__c vTemp:lockouts)
        vTemp.Id=null;
        insert lockouts;
        Test.startTest();
        AtlasLoginHelpUsernameController lhu=new AtlasLoginHelpUsernameController();
        lhu.componentToPage=new AtlasComponenttoController();
        lhu.ReturnValue='Test';
        lhu.submitStep1();
        Test.stopTest();
    }
    @isTest 
    static void testLoginHelpPage3()
    {
        AtlasTestMainClass.setTestKeyValueStoreForAtlas();
        List<User_Lock_Outs__c> lockouts=(List<User_Lock_Outs__c>)JSON.deserialize(AtlasTestConstants.getMetadata('getLockOutValues1'),List<User_Lock_Outs__c>.class);
        for(User_Lock_Outs__c vTemp:lockouts)
        vTemp.Id=null;
        insert lockouts;
        Test.startTest();
        AtlasLoginHelpPasswordController lhp=new AtlasLoginHelpPasswordController();
        lhp.ReturnValue='Test';
        lhp.NextStep1();
        lhp.componentToPage=new AtlasComponenttoController();
        lhp.componentToPage.userName='mjefferson';
        lhp.componentToPage.securityQ1='Q1';
        lhp.componentToPage.securityQ2='Q2';
        lhp.componentToPage.securityQA1='A1';
        lhp.componentToPage.securityQA2='A2';
        lhp.sqAnswer1='A1';
        lhp.sqAnswer2='A2';
        lhp.NextStep2();
        Test.stopTest();
    }
    @isTest 
    static void testNewUserPage()
    {  
        createDataForEachTest();
        Test.startTest();
        PageReference pageRef=Page.AtlasNewUser; //replace with your VF page name
        Test.setCurrentPage(pageRef);
        AtlasNewUserController n= new AtlasNewUserController();
        AtlasNewUserIdentificationController lh=new AtlasNewUserIdentificationController();
        lh.componentToPage= new AtlasComponenttoController();
        lh.toatlIncorrect=0;
        lh.tryAgain();
        lh.cancel();
        lh.ClearFields();
        lh.redirectToLoginHelp();
        lh.accountNumber='300368434';
        lh.phone1='(304) 655-8090';
        User_Lock_Outs__c obj= new User_Lock_Outs__c(Name='Test1',SessionId__c=userInfo.getSessionId(),Totalwrong__c=4,TimeValue__c=system.now());
        insert obj;
        lh.submitStep1();
        lh.accountNumber='300368434';
        lh.MACValue1='oo:Ao:bc:2f:61:81';
        lh.phone1='(304) 655-8090';
        lh.submitStep1();
        string sName = string.valueOf(userInfo.getSessionId());
        lh.createUserLockRecord(5,'300368434','oo:Ao:bc:2f:61:81',(sName.length() > 80 ? sName.substring(0,79) :sName));
        new AtlasFooterController();
        Test.stopTest();
    }
    @isTest 
    static void testNewUserPageAccNotFound()
    {  
        createDataForEachTest();
        Test.startTest();
        PageReference pageRef=Page.AtlasNewUser; //replace with your VF page name
        Test.setCurrentPage(pageRef);
        AtlasNewUserController n= new AtlasNewUserController();
        AtlasNewUserIdentificationController lh=new AtlasNewUserIdentificationController();
        lh.componentToPage= new AtlasComponenttoController();
        lh.toatlIncorrect=0;
        lh.tryAgain();
        lh.cancel();
        lh.ClearFields();
        lh.redirectToLoginHelp();
        lh.accountNumber='300368434';
        lh.phone1='(304) 655-8090';
        User_Lock_Outs__c obj= new User_Lock_Outs__c(Name='Test1',SessionId__c=userInfo.getSessionId(),Totalwrong__c=4,TimeValue__c=system.now());
        insert obj;
        lh.submitStep1();
        lh.accountNumber='300368434';
        lh.MACValue1='oo:Ao:bc:2f:61:81';
        lh.phone1='(304) 655-8092';
        lh.submitStep1();
        new AtlasFooterController();
        Test.stopTest();
    }
    @isTest 
    static void testNewUserPage1()
    {  
        createDataForEachTest();
        Test.startTest();
        PageReference pageRef=Page.AtlasNewUser; //replace with your VF page name
        Test.setCurrentPage(pageRef);
        AtlasNewUserController n= new AtlasNewUserController();
        AtlasNewUserIdentificationController lh=new AtlasNewUserIdentificationController();
        lh.componentToPage= new AtlasComponenttoController();
        lh.tryAgain();
        lh.toatlIncorrect=0;
        lh.cancel();
        lh.ClearFields();
        lh.redirectToLoginHelp();
        lh.accountNumber='';
        lh.MACValue1='oo:Ao:bc:2f:61:81';
        lh.phone1='(304) 655-8090';
        User_Lock_Outs__c obj= new User_Lock_Outs__c(Name='Test1',SessionId__c=userInfo.getSessionId(),Totalwrong__c=3,TimeValue__c=system.now());
        insert obj;
        lh.submitStep1();
        new AtlasFooterController();
        Test.stopTest();
    }
    @isTest 
    static void testNewUserPage12()
    {  
        createDataForEachTest();
        Test.startTest();
        PageReference pageRef=Page.AtlasNewUser; //replace with your VF page name
        Test.setCurrentPage(pageRef);
        AtlasNewUserController n= new AtlasNewUserController();
        AtlasNewUserIdentificationController lh=new AtlasNewUserIdentificationController();
        lh.componentToPage= new AtlasComponenttoController();
        lh.tryAgain();
        lh.toatlIncorrect=0;
        lh.cancel();
        lh.ClearFields();
        lh.redirectToLoginHelp();
        lh.accountNumber='';
        lh.MACValue1='oo:Ao:bc:2f:61:81';
        lh.phone1='(304) 655-8090';
        lh.ReturnValue='Test1';
        User_Lock_Outs__c obj= new User_Lock_Outs__c(Name='Test1',SessionId__c=userInfo.getSessionId(),Totalwrong__c=5,TimeValue__c=system.now());
        insert obj;
        lh.submitStep1();
        new AtlasFooterController();
        Test.stopTest();
    }
    @isTest 
    static void testNewUserPage2()
    {  
        createDataForEachTest();
        Test.startTest();
        PageReference pageRef=Page.AtlasNewUser; //replace with your VF page name
        Test.setCurrentPage(pageRef);
        AtlasNewUserController n= new AtlasNewUserController();
        AtlasNewUserIdentificationController lh=new AtlasNewUserIdentificationController();
        lh.componentToPage= new AtlasComponenttoController();
        lh.toatlIncorrect=0;
        lh.tryAgain();
        lh.cancel();
        lh.ClearFields();
        lh.redirectToLoginHelp();
        lh.accountNumber='300368434';
        lh.phone1='(304) 655-8090';
        lh.ReturnValue='Test1';
        User_Lock_Outs__c obj= new User_Lock_Outs__c(Name='Test1',SessionId__c=userInfo.getSessionId(),Totalwrong__c=5,TimeValue__c=system.now());
        insert obj;
        lh.submitStep1();
        lh.accountNumber='300368434';
        lh.MACValue1='oo:Ao:bc:2f:61:81';
        lh.phone1='(304) 655-8090';
        lh.submitStep1();
        new AtlasFooterController();
        Test.stopTest();
    }
    @isTest 
    static void testNewUserPage11()
    {
        createDataForEachTest();
        Test.startTest();
        PageReference pageRef=Page.AtlasNewUser; //replace with your VF page name
        Test.setCurrentPage(pageRef);
        AtlasNewUserController n= new AtlasNewUserController();
        AtlasNewUserIdentificationController lh=new AtlasNewUserIdentificationController();
        lh.componentToPage= new AtlasComponenttoController();
        lh.tryAgain();
        lh.cancel();
        lh.toatlIncorrect=0;
        lh.ClearFields();
        lh.redirectToLoginHelp();
        lh.accountNumber='';
        lh.MACValue1='oo';
        lh.MACValue2='Ao';
        lh.MACValue3='bc';
        lh.MACValue4='2f';
        lh.MACValue5='61';
        lh.MACValue6='81';
        lh.phone1='304';
        lh.phone2='655';
        lh.phone3='8090';
        User_Lock_Outs__c obj= new User_Lock_Outs__c(Name='Test1',SessionId__c=userInfo.getSessionId(),Totalwrong__c=3,TimeValue__c=system.now());
        insert obj;
        lh.submitStep1();
        new AtlasFooterController();
        Test.stopTest();
    }
    @isTest 
    static void testNewUserPage3()
    {
        createDataForEachTest();
        Test.startTest();
        PageReference pageRef=Page.AtlasNewUser; //replace with your VF page name
        Test.setCurrentPage(pageRef);
        AtlasNewUserController n= new AtlasNewUserController();
        AtlasNewUserIdentificationController lh=new AtlasNewUserIdentificationController();
        lh.componentToPage= new AtlasComponenttoController();
        lh.tryAgain();
        lh.cancel();
        lh.toatlIncorrect=0;
        lh.ClearFields();
        lh.redirectToLoginHelp();
        lh.accountNumber='';
        lh.MACValue1='oo';
        lh.MACValue2='Ao';
        lh.MACValue3='bc';
        lh.MACValue4='2f';
        lh.MACValue5='61';
        lh.MACValue6='81';
        lh.phone1='304';
        lh.phone2='655';
        lh.phone3='8091';
        User_Lock_Outs__c obj= new User_Lock_Outs__c(Name='Test1',SessionId__c=userInfo.getUserId(),Totalwrong__c=3,TimeValue__c=system.now());
        insert obj;
        lh.submitStep1();
        new AtlasFooterController();
        Test.stopTest();
    }
    // method to cover - newuserusername - vf component
    //new user password
    //new user securityquestions
    @isTest 
    static void testNewUserPage4()
    {
        createDataForEachTest();
        Test.startTest();
        PageReference pageRef=Page.AtlasNewUser; //replace with your VF page name
        Test.setCurrentPage(pageRef);
        AtlasNewUserController n= new AtlasNewUserController();
        AtlasNewUserUsernameController nu= new AtlasNewUserUsernameController();
        nu.componentToPage= new AtlasComponenttoController();
        createCommunityUserForNuewUserUserNameComponnet();
        New_User_Registration_History__c objNUR= new New_User_Registration_History__c();
        objNUR.Username__c='Test';
        objNUR.Time_Stamp__c=system.now();
        objNUR.Step2_Username__c=true;
        objNUR.Error_Message__c='';
        insert objNUR;
        list<New_User_Registration_History__c> nurhList = [select id,name from New_User_Registration_History__c where id =: objNUR.Id ORDER BY createddate];
        nu.componentToPage.nurhNumber=nurhList[0].Name;
        nu.userName='Test';
        nu.submitStep2();
        nu.notYouMSG();
        nu.cancel();
        nu.userName='Test';
        nu.submitStep2();
        AtlasNewUserPasswordController np= new AtlasNewUserPasswordController();
        np.cancel();
        np.componentToPage= new AtlasComponenttoController();
        np.componentToPage.userName='jeferrson';
        np.componentToPage.firstName='First name';
        np.password='Test';
        np.confirmPwd='Test';
        np.submitStep3();
        np.confirmPwd='';
        np.submitStep3();
        AtlasNewUserQuestionsController nQ= new AtlasNewUserQuestionsController();
        nq.componentToPage=new AtlasComponenttoController();
        nQ.sqAnswer1='te';
        nQ.sqAnswer2='testing';
        nQ.submitStep4();
        nQ.sqAnswer1='testing';
        nQ.sqAnswer2='te';
        nQ.submitStep4();
        nQ.sqAnswer1='testing';
        nQ.sqAnswer2='testing';
        nQ.submitStep4();
        nQ.getOptionsForQ1();
        nQ.getOptionsForQ2();
        nQ.isMaskedSQA1();
        nq.isMaskedSQA2();
        nQ.isNotMaskedSQA1();
        nQ.isNotMaskedSQA2();
        nQ.maskedSQAnswer1='Test';
        nQ.isMaskedSQA1Changed();
        nQ.maskedSQAnswer2='Test';
        nQ.isMaskedSQA2Changed();
        nQ.cancel();
        nQ.sqAnswer1='te';
        nQ.isMaskedSQA1();
        nQ.sqAnswer2='te';
        nQ.isMaskedSQA2();
        nQ.maskedSQAnswer1='te';
        nQ.isMaskedSQA1Changed();
        nQ.maskedSQAnswer2='te';
        nQ.isMaskedSQA2Changed();
        new AtlasFooterController();
        Test.stopTest();
    }
    //method to cover new user email
    @isTest 
    static void testNewUserPage5()
    {
        createDataForEachTest();
        Test.startTest();
        PageReference pageRef=Page.AtlasNewUser; //replace with your VF page name
        Test.setCurrentPage(pageRef);
        AtlasNewUserController n= new AtlasNewUserController();
        AtlasNewUserEmailController nE= new AtlasNewUserEmailController();
        nE.componentToPage= new AtlasComponenttoController();
        ne.componentToPage.emailId='test@viasat.com';
        ne.componentToPage.subscriberKey=100001780692158l;
        ne.componentToPage.externalAccReference='DSN001000168292';
        ne.componentToPage.externalSystemName='DISH';
        ne.componentToPage.userName='testing';
        ne.componentToPage.accountName='Test123';
        ne.componentToPage.firstName='Test123';
        ne.componentToPage.lastName='Test123';
        ne.componentToPage.internalAccReference='DSN001000168292';
        nE.Cancel();
        nE.Edit();
        ne.isEdit=true;
        nE.emailId1='test@viasat.com';
        nE.emailId2='viasat.com';
        New_User_Registration_History__c objNUR= new New_User_Registration_History__c();
        objNUR.Username__c='Test';
        objNUR.Time_Stamp__c=system.now();
        objNUR.Confirmation_Email__c='test@viasat.com';
        objNUR.Step5_Confirmation_Email__c=true;
        objNUR.Step6_Account_Created__c=true;
        objNUR.Error_Message__c='';
        insert objNUR;
        list<New_User_Registration_History__c> nurhList = [select id,name from New_User_Registration_History__c where id =: objNUR.Id ORDER BY createddate];
        ne.componentToPage.nurhNumber=nurhList[0].Name;
        nE.Confirm();
        new AtlasFooterController();
        //Test.stopTest();
        
        //Test.startTest();
        PageReference pageRef1=Page.AtlasNewUser; //replace with your VF page name
        Test.setCurrentPage(pageRef1);
        AtlasNewUserController n1= new AtlasNewUserController();
        AtlasNewUserEmailController nE1= new AtlasNewUserEmailController();
        nE1.componentToPage= new AtlasComponenttoController();
        ne1.componentToPage.emailId='test@viasat.com';
        ne1.componentToPage.subscriberKey=100001780692158l;
        ne1.componentToPage.externalAccReference='DSN001000168292';
        ne1.componentToPage.externalSystemName='DISH';
        ne1.componentToPage.userName='testing';
        ne1.componentToPage.accountName='Test123';
        ne1.componentToPage.firstName='Test123';
        ne1.componentToPage.lastName='Test123';
        ne1.componentToPage.internalAccReference='DSN001000168292';
        nE1.Cancel();
        nE1.Edit();
        ne1.isEdit=true;
        nE1.emailId1='testtesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttest@viasat.com';
        nE1.emailId2='viasat.com';
        New_User_Registration_History__c objNUR1= new New_User_Registration_History__c();
        objNUR1.Username__c='Test';
        objNUR1.Time_Stamp__c=system.now();
        objNUR1.Confirmation_Email__c='test@viasat.com';
        objNUR1.Step5_Confirmation_Email__c=true;
        objNUR1.Step6_Account_Created__c=true;
        objNUR1.Error_Message__c='';
        insert objNUR1;
        list<New_User_Registration_History__c> nurhList1 = [select id,name from New_User_Registration_History__c where id =: objNUR.Id ORDER BY createddate];
        ne1.componentToPage.nurhNumber=nurhList1[0].Name;
        nE1.Confirm();
        new AtlasFooterController();
        nE1.emailId1='pleasechangethisemailaddress';
        nE1.Confirm();
        nE1.isEdit=false;
        nE1.noEmailId=false;
        nE1.componentToPage.emailId=null;
        nE1.Confirm();
        Test.stopTest();
    }
    
    @isTest static void testEchoString4() {              
        // This causes a fake response to be generated
        AtlasTestMainClass.setTestKeyValueStoreForAtlas();
        Test.setMock(WebServiceMock.class, new AtlasSSOWSMock());
        Test.startTest();
        AtlasSSOWS.ATLASSSOAPIPort ssowstub= new AtlasSSOWS.ATLASSSOAPIPort();
        AtlasSSOWS.resetPasswordResponse_element output = ssowstub.resetPassword('serviceusername', 'serviceuserpassword', 'loginusername', 'newpassword', false);
        Test.stopTest();
    }   
    @isTest static void testEchoString5() {              
        // This causes a fake response to be generated
        AtlasTestMainClass.setTestKeyValueStoreForAtlas();
        Test.setMock(WebServiceMock.class, new AtlasSSOWSMock());
        Test.startTest();
        AtlasSSOWS.ATLASSSOAPIPort ssowstub= new AtlasSSOWS.ATLASSSOAPIPort();
        AtlasSSOWS.changePasswordResponse_element output = ssowstub.changePassword('loginusername', 'loginuserpassword', 'newpassword');
        Test.stopTest();
    }   
    @isTest static void testEchoString6() {              
        // This causes a fake response to be generated
        AtlasTestMainClass.setTestKeyValueStoreForAtlas();
        Test.setMock(WebServiceMock.class, new AtlasSSOWSMock());
        Test.startTest();
        AtlasSSOWS.ATLASSSOAPIPort ssowstub= new AtlasSSOWS.ATLASSSOAPIPort();
        AtlasSSOWS.getSubscribersResponse_element output = ssowstub.getSubscribers('serviceusername', 'serviceuserpassword', 'subscriberid', 'username', 'subscriberattribute', 'subscriberattributevalue', 'resultstoken', 1, 1);
        Test.stopTest();
    }   
    @isTest static void testEchoString7() {              
        // This causes a fake response to be generated
        AtlasTestMainClass.setTestKeyValueStoreForAtlas();
        Test.setMock(WebServiceMock.class, new AtlasSSOWSMock());
        Test.startTest();
        AtlasSSOWS.ATLASSSOAPIPort ssowstub= new AtlasSSOWS.ATLASSSOAPIPort();
        AtlasSSOWS.getSubscriberResponse_element output = ssowstub.getSubscriber('serviceusername','serviceuserpassword',100000578676070l,'ssotoken');
        Test.stopTest();
    }   
    @isTest static void testEchoString8() {              
        // This causes a fake response to be generated
        AtlasTestMainClass.setTestKeyValueStoreForAtlas();
        Test.setMock(WebServiceMock.class, new AtlasSSOWSMock());
        Test.startTest();
        AtlasSSOWS.ATLASSSOAPIPort ssowstub= new AtlasSSOWS.ATLASSSOAPIPort();
        AtlasSSOWS.loginResponse_element output = ssowstub.login('loginusername', 'password');
        Test.stopTest();
    }   
    @isTest static void testEchoString9() {              
        // This causes a fake response to be generated
        AtlasTestMainClass.setTestKeyValueStoreForAtlas();
        Test.setMock(WebServiceMock.class, new AtlasSSOWSMock());
        Test.startTest();
        AtlasSSOWS.ATLASSSOAPIPort ssowstub= new AtlasSSOWS.ATLASSSOAPIPort();
        AtlasSSOWS.uploadFileResponse_element output = ssowstub.uploadFile('serviceusername', 'serviceuserpassword', 'filename', 'fileblob');
        Test.stopTest();
    }   
    @isTest static void testEchoString10() {              
        // This causes a fake response to be generated
        AtlasTestMainClass.setTestKeyValueStoreForAtlas();
        Test.setMock(WebServiceMock.class, new AtlasSSOWSMock());
        Test.startTest();
        AtlasSSOWS.ATLASSSOAPIPort ssowstub= new AtlasSSOWS.ATLASSSOAPIPort();
        AtlasSSOWS.changeLoginUserNameResponse_element output = ssowstub.changeLoginUserName('serviceusername', 'serviceuserpassword', 'loginusername', 'newloginusername');
        Test.stopTest();
    }   
    @isTest static void testEchoString11() {              
        // This causes a fake response to be generated
        AtlasTestMainClass.setTestKeyValueStoreForAtlas();
        Test.setMock(WebServiceMock.class, new AtlasSSOWSMock());
        Test.startTest();
        AtlasSSOWS.ATLASSSOAPIPort ssowstub= new AtlasSSOWS.ATLASSSOAPIPort();
        AtlasSSOWS.securityQuestionType qsType1= new AtlasSSOWS.securityQuestionType();
        AtlasSSOWS.securityQuestionType qsType2= new AtlasSSOWS.securityQuestionType();
        List<AtlasSSOWS.securityQuestionType> lstQuestionAnswer= new list<AtlasSSOWS.securityQuestionType>();
        AtlasSSOWS.securityQuestionsType lstQSType= new AtlasSSOWS.securityQuestionsType();
        qsType1.securityquestionquestion='What is the city of your ultimate dream vacation?';
        qsType1.securityquestionanswer='asdfafd';
        qsType2.securityquestionquestion='What is your favorite musical artist or song?';
        qsType2.securityquestionanswer='asdfdf';
        lstQuestionAnswer.add(qsType1);
        lstQuestionAnswer.add(qsType2);
        lstQSType.securityquestion=lstQuestionAnswer;
        AtlasSSOWS.saveSecurityQuestionsResponse_element output = ssowstub.saveSecurityQuestions('serviceusername', 'servicepassword', 'loginusername', lstQSType);
    }
    @isTest 
    static void testSSow()
    {
       
        AtlasSSOWS.securityQuestionType obj= new AtlasSSOWS.securityQuestionType();
        AtlasSSOWS.changeLoginUserName_element obj1= new AtlasSSOWS.changeLoginUserName_element();
        AtlasSSOWS.changeLoginUserNameRequest_element obj2 = new AtlasSSOWS.changeLoginUserNameRequest_element();
        AtlasSSOWS.changeLoginUserNameResponse_element obj3= new AtlasSSOWS.changeLoginUserNameResponse_element();
        AtlasSSOWS.changePassword_element obj4= new AtlasSSOWS.changePassword_element();
        AtlasSSOWS.changePasswordRequest_element obj5= new AtlasSSOWS.changePasswordRequest_element();
        AtlasSSOWS.changePasswordResponse_element obj6= new AtlasSSOWS.changePasswordResponse_element();
        AtlasSSOWS.getSubscriber_element obj37= new AtlasSSOWS.getSubscriber_element();
        AtlasSSOWS.getSubscriberRequest_element obj7= new AtlasSSOWS.getSubscriberRequest_element();
        AtlasSSOWS.getSubscriberResponse_element obj8= new AtlasSSOWS.getSubscriberResponse_element();
        AtlasSSOWS.getSubscribers_element obj9= new AtlasSSOWS.getSubscribers_element();
        AtlasSSOWS.getSubscribersRequest_element obj10 = new AtlasSSOWS.getSubscribersRequest_element();
        AtlasSSOWS.getSubscribersResponse_element obj11= new AtlasSSOWS.getSubscribersResponse_element();
        AtlasSSOWS.login_element obj12= new AtlasSSOWS.login_element();
        AtlasSSOWS.loginRequest_element obj13= new AtlasSSOWS.loginRequest_element();
        AtlasSSOWS.loginResponse_element obj14= new AtlasSSOWS.loginResponse_element();
        AtlasSSOWS.resetPassword_element obj15= new AtlasSSOWS.resetPassword_element();
        AtlasSSOWS.resetPasswordRequest_element obj16 = new AtlasSSOWS.resetPasswordRequest_element();
        AtlasSSOWS.resetPasswordResponse_element obj17= new AtlasSSOWS.resetPasswordResponse_element();
        AtlasSSOWS.saveSecurityQuestions_element obj18 = new AtlasSSOWS.saveSecurityQuestions_element();
        AtlasSSOWS.saveSecurityQuestionsRequest_element obj19= new AtlasSSOWS.saveSecurityQuestionsRequest_element ();
        AtlasSSOWS.saveSecurityQuestionsResponse_element obj21= new AtlasSSOWS.saveSecurityQuestionsResponse_element();
        AtlasSSOWS.securityQuestionsType obj22= new AtlasSSOWS.securityQuestionsType();
        AtlasSSOWS.securityQuestionType obj23= new AtlasSSOWS.securityQuestionType();
        AtlasSSOWS.sprAttributesType obj24= new AtlasSSOWS.sprAttributesType();
        AtlasSSOWS.sprAttributeType obj25= new AtlasSSOWS.sprAttributeType();
        AtlasSSOWS.ssoApiResponse obj26 = new AtlasSSOWS.ssoApiResponse();
        AtlasSSOWS.subscribersType obj27= new AtlasSSOWS.subscribersType();
        AtlasSSOWS.subscriberType obj28 = new AtlasSSOWS.subscriberType();
        AtlasSSOWS.updateSubscriber_element obj29 = new AtlasSSOWS.updateSubscriber_element();
        AtlasSSOWS.updateSubscriberRequest_element obj30= new AtlasSSOWS.updateSubscriberRequest_element();
        AtlasSSOWS.updateSubscriberResponse_element obj31= new AtlasSSOWS.updateSubscriberResponse_element();
        AtlasSSOWS.uploadFile_element obj32= new AtlasSSOWS.uploadFile_element();
        AtlasSSOWS.uploadFileRequest_element obj33= new AtlasSSOWS.uploadFileRequest_element();
        AtlasSSOWS.uploadFileResponse_element obj34= new AtlasSSOWS.uploadFileResponse_element();
        AtlasSSOWS.userNamesType obj35= new AtlasSSOWS.userNamesType();
        AtlasSSOWS.valuesType obj36 = new AtlasSSOWS.valuesType();
    }
    static void createCommunityUserForNuewUserUserNameComponnet(){       
        Integer numOfObjs = 1;
        List<Account> accounts = ViasatTestUtility.createAccounts(numOfObjs, 'dummyTestAcc');
        insert accounts;
        List<Contact> contacts = ViasatTestUtility.createContacts(accounts, numOfObjs);
        insert contacts;
        
        User thisUser = [ select Id from User where Id = :UserInfo.getUserId() ];
        System.assertEquals(UserInfo.getUserId(),thisUser.id);
        System.runAs ( thisUser ) {
             // commented UserRole - by Sujit - not needed
             //   UserRole ur = [Select PortalType, PortalAccountId From UserRole where PortalType =:'CustomerPortal' limit 1];
                Profile p = [select Id,name from Profile where Name Like 'ATLAS Community%'  limit 1];
                User newUser = new User(
                 // commented UserRoleId -  by Sujit - not needed
                //    UserRoleId = ur.Id,
                    profileId = p.id,
                    username = 'dummtyTestUser@visasat.com',
                    email = 'dummtyTestUser@visasat.com',
                    emailencodingkey = 'UTF-8',
                    localesidkey = 'en_US',
                    languagelocalekey = 'en_US',
                    timezonesidkey = 'America/Los_Angeles',
                    alias='nuser',
                    lastname='lastname',
                    contactId = contacts[0].id,
                    federationIdentifier='Test'
                );
                insert newUser;  
                System.assertEquals(newUser.username,'dummtyTestUser@visasat.com');
            }
    }
    
      @isTest 
    static void testWispNewUserPage()
    {  
        createDataForEachTest();
        Test.startTest();
        PageReference pageRef=Page.WispNewUser; //replace with your VF page name
        Test.setCurrentPage(pageRef);
        AtlasNewUserController n= new AtlasNewUserController();
        AtlasNewUserIdentificationController lh=new AtlasNewUserIdentificationController();
        lh.componentToPage= new AtlasComponenttoController();
        lh.toatlIncorrect=0;
        lh.tryAgain();
        lh.cancel();
        lh.ClearFields();
        lh.redirectToLoginHelp();
        lh.accountNumber='300368434';
        lh.phone1='(304) 655-8090';
        User_Lock_Outs__c obj= new User_Lock_Outs__c(Name='Test1',SessionId__c=userInfo.getSessionId(),Totalwrong__c=4,TimeValue__c=system.now());
        insert obj;
        lh.submitStep1();
        lh.accountNumber='300368434';
        lh.MACValue1='oo:Ao:bc:2f:61:81';
        lh.phone1='(304) 655-8090';
        lh.submitStep1();
        string sName = string.valueOf(userInfo.getSessionId());
        lh.createUserLockRecord(5,'300368434','oo:Ao:bc:2f:61:81',(sName.length() > 80 ? sName.substring(0,79) :sName));
        new AtlasFooterController();
        Test.stopTest();
    }
    @isTest 
    static void testWispNewUserPageAccNotFound()
    {  
        createDataForEachTest();
        Test.startTest();
        PageReference pageRef=Page.WispNewUser; //replace with your VF page name
        Test.setCurrentPage(pageRef);
        AtlasNewUserController n= new AtlasNewUserController();
        AtlasNewUserIdentificationController lh=new AtlasNewUserIdentificationController();
        lh.componentToPage= new AtlasComponenttoController();
        lh.toatlIncorrect=0;
        lh.tryAgain();
        lh.cancel();
        lh.ClearFields();
        lh.redirectToLoginHelp();
        lh.accountNumber='300368434';
        lh.phone1='(304) 655-8090';
        User_Lock_Outs__c obj= new User_Lock_Outs__c(Name='Test1',SessionId__c=userInfo.getSessionId(),Totalwrong__c=4,TimeValue__c=system.now());
        insert obj;
        lh.submitStep1();
        lh.accountNumber='300368434';
        lh.MACValue1='oo:Ao:bc:2f:61:81';
        lh.phone1='(304) 655-8092';
        lh.submitStep1();
        new AtlasFooterController();
        Test.stopTest();
    }
    @isTest 
    static void testWispNewUserPage1()
    {  
        createDataForEachTest();
        Test.startTest();
        PageReference pageRef=Page.WispNewUser; //replace with your VF page name
        Test.setCurrentPage(pageRef);
        AtlasNewUserController n= new AtlasNewUserController();
        AtlasNewUserIdentificationController lh=new AtlasNewUserIdentificationController();
        lh.componentToPage= new AtlasComponenttoController();
        lh.tryAgain();
        lh.toatlIncorrect=0;
        lh.cancel();
        lh.ClearFields();
        lh.redirectToLoginHelp();
        lh.accountNumber='';
        lh.MACValue1='oo:Ao:bc:2f:61:81';
        lh.phone1='(304) 655-8090';
        User_Lock_Outs__c obj= new User_Lock_Outs__c(Name='Test1',SessionId__c=userInfo.getSessionId(),Totalwrong__c=3,TimeValue__c=system.now());
        insert obj;
        lh.submitStep1();
        new AtlasFooterController();
        Test.stopTest();
    }
    @isTest 
    static void testWispNewUserPage12()
    {  
        createDataForEachTest();
        Test.startTest();
        PageReference pageRef=Page.WispNewUser; //replace with your VF page name
        Test.setCurrentPage(pageRef);
        AtlasNewUserController n= new AtlasNewUserController();
        AtlasNewUserIdentificationController lh=new AtlasNewUserIdentificationController();
        lh.componentToPage= new AtlasComponenttoController();
        lh.tryAgain();
        lh.toatlIncorrect=0;
        lh.cancel();
        lh.ClearFields();
        lh.redirectToLoginHelp();
        lh.accountNumber='';
        lh.MACValue1='oo:Ao:bc:2f:61:81';
        lh.phone1='(304) 655-8090';
        lh.ReturnValue='Test1';
        User_Lock_Outs__c obj= new User_Lock_Outs__c(Name='Test1',SessionId__c=userInfo.getSessionId(),Totalwrong__c=5,TimeValue__c=system.now());
        insert obj;
        lh.submitStep1();
        new AtlasFooterController();
        Test.stopTest();
    }
    @isTest 
    static void testWispNewUserPage2()
    {  
        createDataForEachTest();
        Test.startTest();
        PageReference pageRef=Page.WispNewUser; //replace with your VF page name
        Test.setCurrentPage(pageRef);
        AtlasNewUserController n= new AtlasNewUserController();
        AtlasNewUserIdentificationController lh=new AtlasNewUserIdentificationController();
        lh.componentToPage= new AtlasComponenttoController();
        lh.toatlIncorrect=0;
        lh.tryAgain();
        lh.cancel();
        lh.ClearFields();
        lh.redirectToLoginHelp();
        lh.accountNumber='300368434';
        lh.phone1='(304) 655-8090';
        lh.ReturnValue='Test1';
        User_Lock_Outs__c obj= new User_Lock_Outs__c(Name='Test1',SessionId__c=userInfo.getSessionId(),Totalwrong__c=5,TimeValue__c=system.now());
        insert obj;
        lh.submitStep1();
        lh.accountNumber='300368434';
        lh.MACValue1='oo:Ao:bc:2f:61:81';
        lh.phone1='(304) 655-8090';
        lh.submitStep1();
        new AtlasFooterController();
        Test.stopTest();
    }
    @isTest 
    static void testWispNewUserPage11()
    {
        createDataForEachTest();
        Test.startTest();
        PageReference pageRef=Page.WispNewUser; //replace with your VF page name
        Test.setCurrentPage(pageRef);
        AtlasNewUserController n= new AtlasNewUserController();
        AtlasNewUserIdentificationController lh=new AtlasNewUserIdentificationController();
        lh.componentToPage= new AtlasComponenttoController();
        lh.tryAgain();
        lh.cancel();
        lh.toatlIncorrect=0;
        lh.ClearFields();
        lh.redirectToLoginHelp();
        lh.accountNumber='';
        lh.MACValue1='oo';
        lh.MACValue2='Ao';
        lh.MACValue3='bc';
        lh.MACValue4='2f';
        lh.MACValue5='61';
        lh.MACValue6='81';
        lh.phone1='304';
        lh.phone2='655';
        lh.phone3='8090';
        User_Lock_Outs__c obj= new User_Lock_Outs__c(Name='Test1',SessionId__c=userInfo.getSessionId(),Totalwrong__c=3,TimeValue__c=system.now());
        insert obj;
        lh.submitStep1();
        new AtlasFooterController();
        Test.stopTest();
    }
    @isTest 
    static void testWispNewUserPage3()
    {
        createDataForEachTest();
        Test.startTest();
        PageReference pageRef=Page.WispNewUser; //replace with your VF page name
        Test.setCurrentPage(pageRef);
        AtlasNewUserController n= new AtlasNewUserController();
        AtlasNewUserIdentificationController lh=new AtlasNewUserIdentificationController();
        lh.componentToPage= new AtlasComponenttoController();
        lh.tryAgain();
        lh.cancel();
        lh.toatlIncorrect=0;
        lh.ClearFields();
        lh.redirectToLoginHelp();
        lh.accountNumber='';
        lh.MACValue1='oo';
        lh.MACValue2='Ao';
        lh.MACValue3='bc';
        lh.MACValue4='2f';
        lh.MACValue5='61';
        lh.MACValue6='81';
        lh.phone1='304';
        lh.phone2='655';
        lh.phone3='8091';
        User_Lock_Outs__c obj= new User_Lock_Outs__c(Name='Test1',SessionId__c=userInfo.getUserId(),Totalwrong__c=3,TimeValue__c=system.now());
        insert obj;
        lh.submitStep1();
        new AtlasFooterController();
        Test.stopTest();
    }
    // method to cover - Wispnewuserusername - vf component
    //Wisp new user password
    //Wisp new user securityquestions
    @isTest 
    static void testWispNewUserPage4()
    {
        createDataForEachTest();
        Test.startTest();
        PageReference pageRef=Page.WispNewUser; //replace with your VF page name
        Test.setCurrentPage(pageRef);
        AtlasNewUserController n= new AtlasNewUserController();
        AtlasNewUserUsernameController nu= new AtlasNewUserUsernameController();
        nu.componentToPage= new AtlasComponenttoController();
        createCommunityUserForNuewUserUserNameComponnet();
        New_User_Registration_History__c objNUR= new New_User_Registration_History__c();
        objNUR.Username__c='Test';
        objNUR.Time_Stamp__c=system.now();
        objNUR.Step2_Username__c=true;
        objNUR.Error_Message__c='';
        insert objNUR;
        list<New_User_Registration_History__c> nurhList = [select id,name from New_User_Registration_History__c where id =: objNUR.Id ORDER BY createddate];
        nu.componentToPage.nurhNumber=nurhList[0].Name;
        nu.userName='Test';
        nu.submitStep2();
        nu.notYouMSG();
        nu.cancel();
        nu.userName='Test';
        nu.submitStep2();
        AtlasNewUserPasswordController np= new AtlasNewUserPasswordController();
        np.cancel();
        np.componentToPage= new AtlasComponenttoController();
        np.componentToPage.userName='jeferrson';
        np.componentToPage.firstName='First name';
        np.password='Test';
        np.confirmPwd='Test';
        np.submitStep3();
        np.confirmPwd='';
        np.submitStep3();
        WispNewUserQuestionsController nQ= new WispNewUserQuestionsController();
        nq.componentToPage=new AtlasComponenttoController();
        nQ.sqAnswer1='te';
        nQ.sqAnswer2='testing';
        nQ.submitStep4();
        nQ.sqAnswer1='testing';
        nQ.sqAnswer2='te';
        nQ.submitStep4();
        nQ.sqAnswer1='testing';
        nQ.sqAnswer2='testing';
        nQ.submitStep4();
        nQ.getOptionsForQ1();
        nQ.getOptionsForQ2();
        nQ.isMaskedSQA1();
        nq.isMaskedSQA2();
        nQ.isNotMaskedSQA1();
        nQ.isNotMaskedSQA2();
        nQ.maskedSQAnswer1='Test';
        nQ.isMaskedSQA1Changed();
        nQ.maskedSQAnswer2='Test';
        nQ.isMaskedSQA2Changed();
        nQ.cancel();
        nQ.sqAnswer1='te';
        nQ.isMaskedSQA1();
        nQ.sqAnswer2='te';
        nQ.isMaskedSQA2();
        nQ.maskedSQAnswer1='te';
        nQ.isMaskedSQA1Changed();
        nQ.maskedSQAnswer2='te';
        nQ.isMaskedSQA2Changed();
        nQ.sqAnswer1='testing';
        nQ.sqAnswer2='testing';
        nQ.maskedSQAnswer1='testing';
        nQ.maskedSQAnswer2='testing';
        nQ.componentToPage.emailId='test@viasat.com';
        nQ.componentToPage.subscriberKey=100001780692158l;
        nQ.componentToPage.externalAccReference='DSN001000168292';
        nQ.componentToPage.externalSystemName='DISH';
        nQ.componentToPage.userName='testing';
        nQ.componentToPage.accountName='Test123';
        nQ.componentToPage.firstName='Test123';
        nQ.componentToPage.lastName='Test123';
        nQ.componentToPage.internalAccReference='DSN001000168292';
        nQ.submitStep4();
        new AtlasFooterController();
        Test.stopTest();
    }
}