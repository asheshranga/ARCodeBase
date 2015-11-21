/*********************************************************************************
Name         : AtlasLoginUserNameControllerTest
Created By   : Sujit Kumar
Created Date : 6/3/2014
Project      : Atlas Beta-Exit
Usages       : Test Class for the AtlasLoginUserNameController
Change Log   :
<Date>      <Modified By>   <Change Description>
*********************************************************************************/

@isTest(SeeAllData=true)
public with sharing class AtlasLoginUserNameControllerTest {

   public class WebServiceSuccessMockImpl implements WebServiceMock {
      public void doInvoke(
           Object stub,
           Object request,
           Map<String, Object> response,
           String endpoint,
           String soapAction,
           String requestName,
           String responseNS,
           String responseName,
           String responseType) {
         
         AtlasSSOWS.changeLoginUserNameResponse_element respElement = new AtlasSSOWS.changeLoginUserNameResponse_element();
         respElement.status = 'Success';
         respElement.errorcode = null;
         respElement.error = null;
         respElement.loginusername = null;
         response.put('response_x', respElement); 
      }
   }
   
   public class WebServiceError504UserNotFoundMockImpl implements WebServiceMock {
      public void doInvoke(
           Object stub,
           Object request,
           Map<String, Object> response,
           String endpoint,
           String soapAction,
           String requestName,
           String responseNS,
           String responseName,
           String responseType) {
         
         AtlasSSOWS.changeLoginUserNameResponse_element respElement = new AtlasSSOWS.changeLoginUserNameResponse_element();
         respElement.status = 'Fail';
         respElement.errorcode = 504;
         respElement.error = 'User not found: kelly25';
         respElement.loginusername = null;
         response.put('response_x', respElement); 
      }
   }
   
   public class WebServiceFailsWithEmptyResponseMockImpl implements WebServiceMock {
      public void doInvoke(
           Object stub,
           Object request,
           Map<String, Object> response,
           String endpoint,
           String soapAction,
           String requestName,
           String responseNS,
           String responseName,
           String responseType) {
         
         response.put('response_x', null); 
      }
   }
   
   public class WebServiceFailsWithCalloutExceptionMockImpl implements WebServiceMock {
      public void doInvoke(
           Object stub,
           Object request,
           Map<String, Object> response,
           String endpoint,
           String soapAction,
           String requestName,
           String responseNS,
           String responseName,
           String responseType) {
         
         throw new AtlasException.CalloutException(
            AtlasUtility.getMapValue(AtlasConstants.ChangeUserName_Callout_Exp),
            AtlasUtility.getMapValue(AtlasConstants.ChangeUserName_Callout_Exp));
      }
   }
   
   public class WebServiceFailsWithGeneralExceptionMockImpl implements WebServiceMock {
      public void doInvoke(
           Object stub,
           Object request,
           Map<String, Object> response,
           String endpoint,
           String soapAction,
           String requestName,
           String responseNS,
           String responseName,
           String responseType) {
         
         throw new AtlasException.GeneralException(
            AtlasUtility.getMapValue(AtlasConstants.ChangeUserName_General_Exp),
            AtlasUtility.getMapValue(AtlasConstants.ChangeUserName_General_Exp));
      }
   }   
   

   /*  Naming Convention: <MethodName>_<Use_Case_Scenario>_<ExpectedResponse>
    *
    */
   public static testMethod void changeUsername_SuccessWebServiceResponse_SuccessMessage() {
      PageReference pageRef = Page.AtlasUserPasswordReset;
      Test.setCurrentPage(pageRef);
      
      insert TestDataManager.adminTestUser1;

      Test.startTest();
      ApexPages.currentPage().getParameters().put('Id', TestDataManager.adminTestUser1.Id);

      // This causes a fake response to be generated
      Test.setMock(WebServiceMock.class, new WebServiceSuccessMockImpl());
      
      AtlasLoginUserNameController controller = new AtlasLoginUserNameController();      
      Pagereference nextPage = controller.changeLoginUserName();
      Test.stopTest();
      
      // Verify that the same page displays
      System.assertEquals(null, nextPage);
      
      List<ApexPages.Message> msgs = ApexPages.getMessages();
      System.assertEquals('1', msgs.size().format());
      String expectedMesg = AtlasUtility.getMapValue(AtlasConstants.LOGIN_UNAME_REQD);
      System.assertEquals(expectedMesg, msgs[0].getDetail());
   }
   
   /*  Naming Convention: test<MethodName>_<Use_Case_Scenario>_<ExpectedResponse>
    *
    */
   public static testMethod void changeUsername_Error504UserNotFound_ShowErrorMessage() {
      PageReference pageRef = Page.AtlasUserPasswordReset;
      Test.setCurrentPage(pageRef);
      
      insert TestDataManager.adminTestUser1;

      Test.startTest();
      ApexPages.currentPage().getParameters().put('Id', TestDataManager.adminTestUser1.Id);

      // This causes a fake response to be generated
      Test.setMock(WebServiceMock.class, new WebServiceError504UserNotFoundMockImpl());
      
      AtlasLoginUserNameController controller = new AtlasLoginUserNameController();      
      Pagereference nextPage = controller.changeLoginUserName();
      Test.stopTest();
      
      // Verify that the same page displays
      System.assertEquals(null, nextPage);
      
      List<ApexPages.Message> msgs = ApexPages.getMessages();
      System.assertEquals('1', msgs.size().format());
      String expectedMesg = AtlasUtility.getMapValue(Atlasconstants.LOGIN_UNAME_REQD);
      System.assertEquals(expectedMesg, msgs[0].getDetail());
   }
   
      /*  Naming Convention: <MethodName>_<Use_Case_Scenario>_<ExpectedResponse>
    *
    */
   public static testMethod void changeUsername_WebServiceEmptyResponse_ShowErrorMessage() {
      PageReference pageRef = Page.AtlasUserPasswordReset;
      Test.setCurrentPage(pageRef);
      
      insert TestDataManager.adminTestUser1;

      Test.startTest();
      ApexPages.currentPage().getParameters().put('Id', TestDataManager.adminTestUser1.Id);

      // This causes a fake response to be generated
      Test.setMock(WebServiceMock.class, new WebServiceFailsWithEmptyResponseMockImpl());
      
      AtlasLoginUserNameController controller = new AtlasLoginUserNameController();      
      Pagereference nextPage = controller.changeLoginUserName();
      Test.stopTest();
      
      // Verify that the same page displays
      System.assertEquals(null, nextPage);
      
      List<ApexPages.Message> msgs = ApexPages.getMessages();
      System.assertEquals('1', msgs.size().format());
      String expectedMesg = AtlasUtility.getMapValue(AtlasConstants.LOGIN_UNAME_REQD);
      System.assertEquals(expectedMesg, msgs[0].getDetail());
   }
   
   /*  Naming Convention: <MethodName>_<Use_Case_Scenario>_<ExpectedResponse>
    *
    */
   public static testMethod void changeUsername_NullFederationId_ShowErrorMessage() {
      PageReference pageRef = Page.AtlasUserPasswordReset;
      Test.setCurrentPage(pageRef);
      
      TestDataManager.adminTestUser1.FederationIdentifier = NULL;
      
      insert TestDataManager.adminTestUser1;

      Test.startTest();
      ApexPages.currentPage().getParameters().put('Id', TestDataManager.adminTestUser1.Id);

      // This causes a fake response to be generated
      Test.setMock(WebServiceMock.class, new WebServiceSuccessMockImpl());
      
      AtlasLoginUserNameController controller = new AtlasLoginUserNameController();      
      Pagereference nextPage = controller.changeLoginUserName();
      Test.stopTest();
      
      // Verify that the same page displays
      System.assertEquals(null, nextPage);
      
      List<ApexPages.Message> msgs = ApexPages.getMessages();
      System.assertEquals('1', msgs.size().format());
      String expectedMesg = AtlasUtility.getMapValue(AtlasConstants.ChangeUserName_Bad_Input_Exp);
      System.assertEquals(expectedMesg, msgs[0].getDetail());
   }
   
   /*  Naming Convention: <MethodName>_<Use_Case_Scenario>_<ExpectedResponse>
    *
    */
   public static testMethod void changeUsername_CalloutException_ShowErrorMessage() {
      PageReference pageRef = Page.AtlasUserPasswordReset;
      Test.setCurrentPage(pageRef);
      
      insert TestDataManager.adminTestUser1;

      Test.startTest();
      ApexPages.currentPage().getParameters().put('Id', TestDataManager.adminTestUser1.Id);

      // This causes a fake response to be generated
      Test.setMock(WebServiceMock.class, new WebServiceFailsWithCalloutExceptionMockImpl());
      
      AtlasLoginUserNameController controller = new AtlasLoginUserNameController();      
      Pagereference nextPage = controller.changeLoginUserName();
      Test.stopTest();
      
      // Verify that the same page displays
      System.assertEquals(null, nextPage);
      
      List<ApexPages.Message> msgs = ApexPages.getMessages();
      System.assertEquals('1', msgs.size().format());
      String expectedMesg = AtlasUtility.getMapValue(AtlasConstants.LOGIN_UNAME_REQD);
      System.assertEquals(expectedMesg, msgs[0].getDetail());
   }   

   /*  Naming Convention: <MethodName>_<Use_Case_Scenario>_<ExpectedResponse>
    *
    */
   public static testMethod void changeUsername_GeneralException_ShowErrorMessage() {
      PageReference pageRef = Page.AtlasUserPasswordReset;
      Test.setCurrentPage(pageRef);
      
      insert TestDataManager.adminTestUser1;

      Test.startTest();
      ApexPages.currentPage().getParameters().put('Id', TestDataManager.adminTestUser1.Id);

      // This causes a fake response to be generated
      Test.setMock(WebServiceMock.class, new WebServiceFailsWithGeneralExceptionMockImpl());
      
      AtlasLoginUserNameController controller = new AtlasLoginUserNameController();      
      Pagereference nextPage = controller.changeLoginUserName();
      Test.stopTest();
      
      // Verify that the same page displays
      System.assertEquals(null, nextPage);
      
      List<ApexPages.Message> msgs = ApexPages.getMessages();
      System.assertEquals('1', msgs.size().format());
      String expectedMesg = AtlasUtility.getMapValue(AtlasConstants.LOGIN_UNAME_REQD);
      System.assertEquals(expectedMesg, msgs[0].getDetail());
   }      
}