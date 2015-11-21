/*********************************************************************************
Name         : WispTestClass
Created By   : Srikanth Kudumula
Created Date : 01/28/2015
Project      : Wisp 
Usages       : Test Class for All the Wisp Controllers
Change Log   :
<Date>      <Modified By>   <Change Description>
*********************************************************************************/

@isTest(SeeAllData=true)
public class WispTestClass{

    //Create a Portal User
    static void createCommunityUser(){
        Set<String> customerUserTypes = new Set<String> {'CSPLiteUser', 'PowerPartner', 'PowerCustomerSuccess',   'CustomerSuccess'};
        Account acc = new Account ( Name = 'dummtyTestAcc');  
        insert acc;
        System.assert(acc.Name=='dummtyTestAcc');
        Contact con = new Contact ( AccountId = acc.id, FirstName='test', LastName = 'portalTestUser', Email='c_srikanth.kudumula@viasat.com');
        insert con;
        System.assert(con.LastName=='portalTestUser'); 
        User thisUser = [ select Id from User where Id = :UserInfo.getUserId() ];
        System.assertEquals(UserInfo.getUserId(),thisUser.id);
        System.runAs ( thisUser ) {
             // commented UserRole - by Sujit - not needed
             //   UserRole ur = [Select PortalType, PortalAccountId From UserRole where PortalType =:'CustomerPortal' limit 1];
                Profile p = [select Id,name from Profile where Name Like 'WISP Subscriber Community%'  limit 1];
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
                    contactId = con.id,
                    ExternalAccountReference__c='486108',
                    FederationIdentifier = 'test' 
                );
                insert newUser;  
                System.assertEquals(newUser.username,'dummtyTestUser@visasat.com');
            }
    }
    
    //Method to Cover WispNewUserIdentificationController
    static testmethod void TestWispNewUserIdentification(){        
        WispNewUserIdentificationController lh = new WispNewUserIdentificationController();
        lh.componentToPage= new AtlasComponenttoController();
        lh.toatlIncorrect=0;
        lh.tryAgain();
        lh.cancel();
        lh.ClearFields();
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
    }
    
    // method to cover - newuserusername - vf component
    //new user password
    //new user securityquestions
    static testmethod void testNewUserRegistration()
    {
        //createDataForEachTest();
        Test.startTest();
        PageReference pageRef=Page.subscriber_new_user; //replace with your VF page name
        Test.setCurrentPage(pageRef);
        //WispNewUserController n= new WispNewUserController();
        WispNewUserUsernameController nu= new WispNewUserUsernameController();
        nu.componentToPage= new AtlasComponenttoController();
        //createCommunityUserForNuewUserUserNameComponnet();
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
        createCommunityUser();
        nu.userName='Test';
        nu.submitStep2();
        nu.userName='Test';
        nu.submitStep2();
        WispNewUserPasswordController np= new WispNewUserPasswordController();
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
        nQ.componentToPage.externalAccReference = 'DSN001000168292';
        nQ.componentToPage.externalSystemName = 'DISH';
        nQ.componentToPage.partnerName = 'test';
        nQ.componentToPage.accountName = 'test account';
        nQ.WispAccRecordtype = 'Wisp';
        nQ.componentToPage.emailId = 'dummytest@test.com';
        nQ.componentToPage.phone = '1231231234';
        nQ.componentToPage.internalAccReference = 'DSN001000168292';
        nQ.componentToPage.firstName = 'TestFName';
        nQ.componentToPage.lastName = 'TestLName';
        nQ.componentToPage.userName = 'TestUserName';
        nQ.submitStep4();        
        nQ.sqAnswer1='testing';
        nQ.sqAnswer2='testing';
        nQ.componentToPage.externalAccReference = 'DSN001000168292';
        nQ.componentToPage.externalSystemName = 'DISH';
        nQ.submitStep4();  
        nQ.invokeUpdateSubscriber();      
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
    
    //Method to cover WispDashboardController
    static testmethod void testWispDashboardController(){        
        Test.startTest();
        PageReference pageRef=Page.subscriber_dashboard; //replace with your VF page name
        Test.setCurrentPage(pageRef);
        Test.setMock(WebServiceMock.class, new AtlasTestWebserviceProxy());
        WispDashboardController dc = new WispDashboardController();
        dc.mainDTOObj=(AtlasMainDTO)JSON.deserialize(AtlasTestConstants.getMetadata('MainDTOResponse'),AtlasMainDTO.class);       
        dc.callRemoteAtlasDashboardData();
        dc.mainDTOObj.isAccountPopulated = false;
        dc.myAccountWispDashboardData();
        dc.myAccountAtlasDashboardData();
        dc.clearMyAccountDataForRefresh();
        dc.currentDataUsageAtlasDashboardData();
        dc.billingSnapshotAtlasDashboardData();
        dc.servicePlanSearch();
        createCommunityUser();
        dc.updateUserDetails();
        dc.editCustomerInfo();
    }   
    
    //Method to cover WispBuyMoreController
    static testmethod void testWispBuyMOreController(){         
        Test.startTest();
        AtlasIntegrationUtility atlasCP = new AtlasIntegrationUtility();
        Test.setMock(WebServiceMock.class, new AtlasTestWebserviceProxy());
        WispBuyMoreController b= new WispBuyMoreController();
        b.mainDTOObj=(AtlasMainDTO)JSON.deserialize(AtlasTestConstants.getMetadata('MainDTOResponse'),AtlasMainDTO.class);
        AtlasCurrentDataUsageDTO c= new AtlasCurrentDataUsageDTO();
        c.refreshNow=true;
        b.mainDTOObj.cduDTOObj=c;
        try{b.WispaddUsageQuotaForOneGB();}catch(Exception e){}
        try{b.WispaddUsageQuotaforTwoGB();}catch(Exception e){}
        try{b.WispaddUsageQuotaForThreeGB();}catch(Exception e){}
        try{b.WispaddUsageQuotaForTenGB();}catch(Exception e){}
        try{b.addUsageQuota('test','1');}catch(Exception e){}
        b.ActionPoller();
        Test.stopTest();
    }   
    
    //  Method to cover agent admin controller  
    static testmethod void testWispAdminAgentCreationController(){
        account a = new account();
        a.name = 'test account';
        a.Status__c='Customer';
        a.Country__c='United States';
        a.Type='End-User';
        a.Industry='Commercial';
        a.CurrencyIsoCode = 'USD';
        a.OwnerId = AtlasUtility.getMapValue(AtlasConstants.Account_Owner);
        insert a;
        Account acc = [select id from account where id =: a.id limit 1];
        PageReference myVfPage = Page.WispAdminAgentCreation;
        Test.setCurrentPage(myVfPage);
        ApexPAges.StandardController sc = new ApexPages.StandardController(acc);
        WispAdminAgentCreationController temp = new WispAdminAgentCreationController(sc);
        temp.userName = 'testagentadmincreation';
        temp.firstName = 'agentfname';
        temp.lastName = 'agentlname';
        temp.emailId = 'testagent@test.com';
        temp.phoneNumber = '1231231234';
        temp.selectedpartner = 'testpartner';
        temp.emailDomain = 'Viasattest.com';
        temp.WispAccRecordtype = 'Wisp';
        temp.PartnerName = 'testpartner';
        temp.CreateAgent();
        temp.Cancel();
        temp.clearfields();
    }
    
    //Method to cover WispUserNameController
    static testmethod void TestWispUsername(){
        //AtlasTestMainClass.setTestKeyValueStoreForAtlas();
        createCommunityUser();
        WispCustomerInformationController c = new WispCustomerInformationController();
        c.cancelException();
        AtlasDataManager ad = new AtlasDataManager();
        ad.mainDTOObj =(AtlasMainDTO)JSON.deserialize(AtlasTestConstants.getMetadata('MainDTOResponse'),AtlasMainDTO.class); 
        ad.mainDTOObj.accountKey = '-sfksgsdgog45232lkakfd';
        ad.mainDTOObj.federationId = 'mjefferson';
        WispCustomerInfoUsernameController temp = new WispCustomerInfoUsernameController();
        temp.strUsername = '';
        temp.saveUsername();
        temp.strUsername='test';
        temp.saveUsername(); 
        temp.strUsername='mjefferson';
        temp.saveUsername();
        temp.cancelException();
    }
    
    //Method to cover WispSavePasswordController
    static testmethod void TestWispSavePassword(){
        WispCustomerInfoPasswordController temp = new WispCustomerInfoPasswordController();
        temp.weak='test';
        temp.oldpassword = '';
        temp.password = 'test';
        temp.confirmPwd = 'test1';
        temp.savePassword();
        temp.weak='test';
        temp.oldpassword = 'test1';
        temp.password = 'test';
        temp.confirmPwd = 'test1';
        temp.savePassword();
        temp.weak='test';
        temp.oldpassword = 'test1';
        temp.password = 'test';
        temp.confirmPwd = 'test';
        temp.savePassword();
        temp.password = 'Summer@123';
        temp.confirmPwd = 'Summer@123';
        temp.savePassword();
        temp.cancelException();
    }
    
    //Method to cover SaveSecurityQuestionsController
    static testmethod void TestWispSaveSecurityQuestions()
    {
        WispCustomerInfoQuestionsController temp = new WispCustomerInfoQuestionsController();
        temp.getOptionsForQ1();
        temp.getOptionsForQ2();
        temp.isNotMaskedSQA1();
        temp.isNotMaskedSQA2();
        temp.sqAnswer1='';
        temp.sqAnswer2='';
        temp.saveSecurityQuestions();
        temp.sqAnswer1='te';
        temp.sqAnswer2='aaaa';
        temp.saveSecurityQuestions();
        temp.sqAnswer1='testttt';
        temp.sqAnswer2='te';
        temp.saveSecurityQuestions();
        temp.sqAnswer1='test';
        temp.sqAnswer2='test';
        temp.saveSecurityQuestions();
        temp.cancelException();
    }
    
    //Method to cover WispResetPasswordStep1Controller
    static testmethod void testWispResetPasswordStep1Controller(){
        WispResetPasswordStep1Controller lhu = new WispResetPasswordStep1Controller();
        lhu.componentToPage=new AtlasComponenttoController();
        lhu.ReturnValue='Test';
        lhu.userName = 'test';
        User_Lock_Outs__c obj1= new User_Lock_Outs__c(Name='Test',SessionId__c=userInfo.getSessionId(),Totalwrong__c=4,TimeValue__c=system.now());
        insert obj1;        
        lhu.NextStep1();
        lhu.ReturnValue='Test1';
        lhu.userName = 'test';
        User_Lock_Outs__c obj2= new User_Lock_Outs__c(Name='Test1',SessionId__c='tset------',Totalwrong__c=5,TimeValue__c=system.now());
        insert obj2;
        lhu.NextStep1();
        lhu.cancel();
        lhu.ClearFields();
        lhu.userName = 'test';
        lhu.NextStep1();
        lhu.userName = '';
        lhu.NextStep1();
        lhu.redirectToForgotUsername();
    }
    
    //Method to cover WispResetPasswordStep2Controller
    static testmethod void testWispResetPasswordStep2Controller(){
        WispResetPasswordStep2Controller lhp = new WispResetPasswordStep2Controller();
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
        lhp.NextStep2();
        User_Lock_Outs__c obj1= new User_Lock_Outs__c(Name='13:09:13:17:14',SessionId__c='tset------',Totalwrong__c=5,TimeValue__c=system.now());
        insert obj1;
        lhp.NextStep2();
        lhp.selectedSQA1='Q1';
        lhp.sqAnswer1='A1';
        lhp.selectedSQA2='Q2';
        lhp.sqAnswer2='A2';
        lhp.componentToPage.userName='mjefferson';
        lhp.componentToPage.securityQ1='Q1';
        lhp.componentToPage.securityQ2='Q2';
        lhp.componentToPage.securityQA1=' A1';
        lhp.componentToPage.securityQA2=' A2';
        lhp.NextStep2();
        lhp.password='Test';
        lhp.confirmPwd='Test';
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
    }
    
    //Method to cover WispResetPasswordStep3Controller
    static testmethod void testWispResetPasswordStep3Controller(){
        WispResetPasswordStep3Controller lhp = new WispResetPasswordStep3Controller();
        lhp.componentToPage=new AtlasComponenttoController();
        lhp.Cancel();
        lhp.CleasrFields();
        lhp.getOptionsForQ1();
        lhp.getOptionsForQ2();
        lhp.redirectToForgotUsername();
        lhp.componentToPage.userName = 'dummyusername';
        lhp.password='test';
        lhp.confirmPwd='test';       
        lhp.nextStep3();
         lhp.componentToPage.userName = 'test';
        lhp.password='test';
        lhp.confirmPwd='test';       
        lhp.nextStep3();
        lhp.componentToPage.userName = 'mjefferson';
        lhp.password='test';
        lhp.confirmPwd='test';       
        lhp.nextStep3();
        
    }
    
    //Test Method to cover AtlasCommunitiesLanding Controller and AtlasCommunitiesPartnerLanding Controller
    static testmethod void testWispCommunitiesLandingController() {
        // Instantiate a new controller with all parameters in the page
        WispCommunitiesLandingController controller = new WispCommunitiesLandingController();
        controller.forwardToStartPage();
        WISPCommunitiesPartnerLandingController cpl = new WISPCommunitiesPartnerLandingController();
        cpl.forwardToStartPage();
    }
    
    //Test Method to cover WispUnderConstructionController
    static testmethod void WispUnderConstructionControllerTest(){
        WispUnderConstructionController uc = new WispUnderConstructionController();
    }
}