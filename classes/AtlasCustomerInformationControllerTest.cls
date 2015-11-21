@IsTest(SeeAllData=true) 
public class AtlasCustomerInformationControllerTest{
    static testmethod void myUnitTest1(){
        AtlasCustomerInformationController temp = new AtlasCustomerInformationController();
        temp.getOptionsForQ1();
        temp.getOptionsForQ2();
        temp.getBillingStates();
        temp.callRemoteAtlasDashboardData();
        temp.currentDataUsageAtlasDashboardData();
        temp.editEnable();
        temp.currentPaymentSettingsCurrentBillPage();
        temp.myAccountAtlasDashboardData();
        temp.billingSnapshotAtlasDashboardData();
        //temp.getPlanDetailsForCustomerInfo();
        temp.fillCustomerUpdateForFromDTO();
        temp.saveCustomerInformation();
        temp.saveUsername();
        temp.savePassword();
        temp.saveSecurityQuestions();
        //temp.clearMyAccDataForRefresh();
        temp.cancelException();
        //temp.updateUserImage();
        temp.openImageEditPopup();
        temp.sqAnswer1 = 'test';
        temp.sqAnswer2 = 'test';
        temp.maskedSQAnswer1 = 'test';
        temp.maskedSQAnswer2 = 'test';
        temp.isMaskedSQA1();
        temp.isMaskedSQA2(); 
        temp.isNotMaskedSQA1();
        temp.isNotMaskedSQA2();
        temp.maskedSQAnswer1 = 'test';
        temp.maskedSQAnswer2 = 'test';
        temp.isMaskedSQA1Changed();
        temp.isMaskedSQA2Changed();
        temp.clearFields();
        temp.strPhoneArea = 'test';
        temp.strPhonePrefix= 'test';
        temp.strPhoneLine = 'test';
        temp.strEmailId = 'test';
        temp.strState= 'test';
        temp.strCity= 'test';
        temp.strBillingAddress1= 'test';
        temp.strZipLeft= 'test';
        temp.strZipRight= 'test';
        temp.firstName = 'test';
        temp.lastName = 'test';
        temp.strZip='test';
        temp.strPhoneAreaSecond='1234';
        temp.strPhonePrefixSecond='';
        temp.saveCustomerInformation();
        temp.strPhoneArea = 'test';
        temp.strPhonePrefix= 'test';
        temp.strPhoneLine = 'test';
        temp.strEmailId = 'test';
        temp.strState= 'test';
        temp.strCity= 'test';
        temp.strBillingAddress1= 'test';
        temp.strZipLeft= 'test';
        temp.strZipRight= 'test';
        temp.firstName = 'test';
        temp.lastName = 'test';
        temp.strZip='test';
        temp.strPhoneAreaSecond='1234';
        temp.strPhoneLineSecond='1234';
        temp.strPhonePrefixSecond='11111';
        temp.saveCustomerInformation();
        temp.strPhoneArea = 'test';
        temp.strPhonePrefix= 'test';
        temp.strPhoneLine = 'test';
        temp.strEmailId = 'test';
        temp.strState= 'test';
        temp.strCity= 'test';
        temp.strBillingAddress1= 'test';
        temp.strZipLeft= 'test';
        temp.strZipRight= 'test';
        temp.firstName = 'test';
        temp.lastName = 'test';
        temp.strZip='test';
        temp.strPhoneAreaSecond='';
        temp.strPhoneLineSecond='';
        temp.strPhonePrefixSecond='';
        temp.StrPhoneArea='000';
        temp.saveCustomerInformation();
        temp.strPhoneArea = 'test';
        temp.strPhonePrefix= 'test';
        temp.strPhoneLine = 'test';
        temp.strEmailId = 'test';
        temp.strState= 'test';
        temp.strCity= 'test';
        temp.strBillingAddress1= 'test';
        temp.strZipLeft= 'test';
        temp.strZipRight= 'test';
        temp.firstName = 'test';
        temp.lastName = 'test';
        temp.strZip='test';
        temp.strPhoneAreaSecond='';
        temp.strPhoneLineSecond='';
        temp.strPhonePrefixSecond='';
        temp.StrPhoneArea='0000000000';
        //temp.strEmailId = 'test@gmail.com';
        temp.strZip='00000';
        temp.saveCustomerInformation();
        temp.StrPhoneArea='00000000';
        temp.strPhoneAreaSecond='0000000000';
        temp.saveCustomerInformation();
        temp.strEmailId = 'test@gmail.com';
        temp.strZip='00000';
        temp.saveCustomerInformation();
        temp.strPhoneArea = 'test';
        temp.strPhonePrefix= 'test';
        temp.strPhoneLine = 'test';
        //temp.strEmailId = 'test';
        temp.strState= 'test';
        temp.strCity= 'test';
        temp.strBillingAddress1= 'test';
        temp.strZipLeft= 'test';
        temp.strZipRight= 'test';
        temp.firstName = 'test';
        temp.lastName = 'test';
        temp.strZip='test';
        temp.strPhoneAreaSecond='';
        temp.strPhoneLineSecond='';
        temp.strPhonePrefixSecond='';
        temp.StrPhoneArea='00000';
        temp.strZip='0000000';
        temp.strZip4='0000';
        temp.saveCustomerInformation();
        temp.strPhoneArea = 'test';
        temp.strPhonePrefix= 'test';
        temp.strPhoneLine = 'test';
        //temp.strEmailId = 'test';
        temp.strState= 'test';
        temp.strCity= 'test';
        temp.strBillingAddress1= 'test';
        temp.strZipLeft= 'test';
        temp.strZipRight= 'test';
        temp.firstName = 'test';
        temp.lastName = 'test';
        temp.strZip='test';
        temp.strPhoneAreaSecond='';
        temp.strPhoneLineSecond='';
        temp.strPhonePrefixSecond='';
        temp.StrPhoneArea='00000';
        temp.strZip='0000000';
        temp.strZip4='000000';
        try{temp.saveCustomerInformation();}Catch(exception E){}
        try{temp.clearMyAccDataForRefresh();}Catch(exception E){}
        try{temp.ClearFieldsSecQues();}Catch(exception E){}
    }
    
     static testmethod void myUnitTest2(){
		AtlasTestMainClass.setTestKeyValueStoreForAtlas();
		AtlasCustomerInformationController temp = new AtlasCustomerInformationController();
        temp.strZipLeft= 'test';
        temp.strZipRight= 'test';
        temp.firstName = 'test';
        temp.lastName = 'test';
        
        temp.sqAnswer1 = 'test';
        temp.sqAnswer2 = 'test';
        Test.setMock(WebServiceMock.class, new AtlasSSOWSMock());
         
         AtlasSSOWS.securityQuestionType[] questionArray = new AtlasSSOWS.securityQuestionType[2];
         AtlasSSOWS.securityQuestionType newQuestion = new AtlasSSOWS.securityQuestionType(); 
         AtlasSSOWS.securityQuestionsType newQuestions = new AtlasSSOWS.securityQuestionsType();
         newQuestion.securityquestionquestion = 'test';
         newQuestion.securityquestionanswer = 'test1';
         questionArray[0] = newQuestion;
         newQuestions.securityquestion = questionArray; 
         AtlasIntegrationUtility.saveSecurityQuestions('temp',newQuestions); 
         try{temp.saveSecurityQuestions();}catch(exception e){}
      
        temp.strPhoneArea = 'test';
        temp.strPhonePrefix= 'test';
        temp.strPhoneLine = 'test';
        temp.strEmailId = 'test';
        temp.strState= 'test';
        temp.strCity= 'test';
        temp.strBillingAddress1= 'test';
        temp.strZipLeft= 'test';
        temp.strZipRight= 'test'; 
       // temp.saveCustomerInformation(); 
         temp.accountNumber = 'test';
        temp.getBillingSnapShotDashBoardDAta();
        temp.openImageEditPopup();
        temp.persistViewState();
       } 
    static testmethod void myUnitTest3(){
        AtlasCustomerInformationController temp = new AtlasCustomerInformationController();
      temp.oldStrUsername = 'test';
        temp.strUsername = 'test';
        temp.strConfirmUsername = 'test1';
        
        //Test.setMock(WebServiceMock.class, new AtlasSSOWSUsernameMock());
        
        temp.saveUsername();
    }
    
    static testmethod void myUnitTest4(){
		AtlasTestMainClass.setTestKeyValueStoreForAtlas();
        AtlasCustomerInformationController temp = new AtlasCustomerInformationController();
      temp.oldStrUsername = 'test';
        temp.strUsername = 'test';
        temp.strConfirmUsername = 'test';
        
        //Test.setMock(WebServiceMock.class, new AtlasSSOWSUsernameMock());
        
        temp.saveUsername();
    }
    
    static testmethod void myUnitTest5(){
        AtlasCustomerInformationController temp = new AtlasCustomerInformationController();
        
        temp.weak='test';
        temp.oldpassword = 'test1';
        temp.password = 'test';
        temp.confirmPwd = 'test';
        //Test.setMock(WebServiceMock.class, new AtlasSSOWSPasswordMock());
        try{temp.savePassword();}catch(exception e){}
    }
    static testmethod void myUnitTest6(){
        AtlasCustomerInformationController temp = new AtlasCustomerInformationController();
        
        temp.weak='test';
        temp.oldpassword = 'test1';
        temp.password = 'test';
        temp.confirmPwd = 'test1';
        //Test.setMock(WebServiceMock.class, new AtlasSSOWSPasswordMock());
        temp.savePassword();
    }
    static testmethod void myUnitTest7(){
        AtlasCustomerInformationController temp = new AtlasCustomerInformationController();
        
        temp.weak='test';
        temp.oldpassword = 'test1';
        temp.password = '';
        temp.confirmPwd = 'test1';
        //Test.setMock(WebServiceMock.class, new AtlasSSOWSPasswordMock());
        temp.savePassword();
        temp.mainDTOObj=new AtlasMainDto();
        temp.mainDTOObj.accountDTOObj= new AtlasAccountDTO();
        temp.mainDTOObj.accountDTOObj.smallPhotoURL='';
        temp.updateUserImage();
       
    }
    static testmethod void myUnitTest8()
    {
        AtlasCustomerInformationController temp = new AtlasCustomerInformationController();
        temp.sqAnswer1='';
        temp.sqAnswer2='';
        temp.saveSecurityQuestions();
        temp.sqAnswer1='te';
        temp.sqAnswer2='aaaa';
        temp.saveSecurityQuestions();
        temp.sqAnswer1='testttt';
        temp.sqAnswer2='te';
        temp.saveSecurityQuestions();
    }
    static testmethod void myUnitTest9()
    {
        AtlasCustomerInformationController temp = new AtlasCustomerInformationController();
        AtlasAccountDTO accDTO= new AtlasAccountDTO();
        accDTO.contactEmail='Test@cmc.com';
        accDTO.strUSMobileNOFormat='123-456-7890';
        accDTO.secondaryPhone='123-456-7890';
        accDTO.zip='00000-0000';
        temp.mainDTOObj= new AtlasMainDTO();
        temp.mainDTOObj.federationId='12335456888';
        temp.mainDTOObj.accountDTOObj= new AtlasAccountDTO();
        temp.mainDTOObj.accountDTOObj.strUSMobileNOFormat='123-456-7890';
        temp.StrPhone='123'+'-'+'456'+'-'+'7890';
        temp.mainDTOObj.accountDTOObj.secondaryPhone='123-456-7890';
        temp.StrsecondaryPhone='123-456-7890';
        temp.mainDTOObj.accountDTOObj.zip='00000-0000';
        try{temp.fillCustomerUpdateForFromDTO();}catch(Exception e){}
    }
    
    static testmethod void myUnitTestWispUsername(){
		AtlasTestMainClass.setTestKeyValueStoreForAtlas();
        WispCustomerInfoUsernameController temp = new WispCustomerInfoUsernameController();
        temp.strUsername = '';
        temp.saveUsername();
     	temp.oldStrUsername = 'test';
        temp.strUsername = 'test';
        //Test.setMock(WebServiceMock.class, new AtlasSSOWSUsernameMock());
        temp.saveUsername();
        temp.cancelException();
    }
    
    static testmethod void myUnitTestWispSavePassword(){
        WispCustomerInfoPasswordController temp = new WispCustomerInfoPasswordController();
        temp.weak='test';
        temp.oldpassword = '';
        temp.password = 'test';
        temp.confirmPwd = 'test1';
        //Test.setMock(WebServiceMock.class, new AtlasSSOWSPasswordMock());
        temp.savePassword();
        temp.weak='test';
        temp.oldpassword = 'test1';
        temp.password = 'test';
        temp.confirmPwd = 'test1';
        //Test.setMock(WebServiceMock.class, new AtlasSSOWSPasswordMock());
        temp.savePassword();
        temp.weak='test';
        temp.oldpassword = 'test1';
        temp.password = 'test';
        temp.confirmPwd = 'test';
        temp.savePassword();
        temp.cancelException();
    }
    
    static testmethod void myUnitTestWispSaveSecurityQuestions()
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
        temp.cancelException();
    }
}