/*********************************************************************************
Name         : AtlasMoveInternalAccountControllerTest
Created By   : Sujit Kumar
Created Date : 6/25/2014
Project      : Atlas Beta-Exit
Usages       : Test Class for the AtlasMoveInternalAccountControllerTest
Change Log   :
<Date>      <Modified By>   <Change Description>
*********************************************************************************/
@isTest(SeeAllData=true)
public with sharing class AtlasMoveInternalAccountControllerTest {

    private static final String INTERNAL_ACCT_REF_NUM = 'INTERNAL_ACCT_REF_001';
    private static final String EMAIL_ADDRESS = 'john@yyzz.com';
     private static final String PRIMARY_PHONE_NUMBER = '972-333-4444';
    
    
    private static void setupCustomSettings() {
      AtlasWebserviceSetting__c findSubscriberSetting = new AtlasWebserviceSetting__c();
      findSubscriberSetting.name = 'FindSubscriber';
      findSubscriberSetting.End_Point__c = 'http://www.google.com';
      insert findSubscriberSetting;
   }
   
    /*
     *  @author Sujit Kumar
     */
    public class FindSubscribersWebServiceSuccessMockImpl implements WebServiceMock {
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
         
          AtlasPublicWebServiceSearchServiceStub.findSubscribersBySearchCriteriaResponse respElement;
          respElement = new AtlasPublicWebServiceSearchServiceStub.findSubscribersBySearchCriteriaResponse();
          
          // Create a subscriber
          AtlasPublicWebServiceSearchServiceStub.Subscriber currentSubscriber = new AtlasPublicWebServiceSearchServiceStub.Subscriber();
          AtlasPublicWebServiceSearchServiceStub.Account subscriberAccount = new AtlasPublicWebServiceSearchServiceStub.Account();
          AtlasPublicWebServiceSearchServiceStub.Contact subscriberContact = new AtlasPublicWebServiceSearchServiceStub.Contact();
          subscriberAccount.internalAccountReference = INTERNAL_ACCT_REF_NUM;
          subscriberContact.emailAddress = EMAIL_ADDRESS;
          subscriberContact.primaryPhoneNumber = PRIMARY_PHONE_NUMBER;
          currentSubscriber.account = subscriberAccount;
          currentSubscriber.contact = subscriberContact;
          
          // Create an array of Subscribers
          AtlasPublicWebServiceSearchServiceStub.Subscriber[] listOfSubscribers = new AtlasPublicWebServiceSearchServiceStub.Subscriber[1];
          listOfSubscribers[0] = currentSubscriber;
          
          // Add array of subscribers to the response
          respElement.subscriber = listOfSubscribers;
          response.put('response_x', respElement); 
      }
    }
    /*
     *  @author Sujit Kumar
      FAILING ON TestDataManager.createPortalUser WITH THIS ERROR:
     System.DmlException: Insert failed. First exception on row 0; first error: 
     MIXED_DML_OPERATION, DML operation on setup object is not permitted after you have updated a non-setup object (or vice versa): 
     Account, original object: User: []
    */
    /*
    public static testmethod void moveInternalAccountNumber() {
        AtlasTestMainClass.setTestKeyValueStoreForAtlas();
        PageReference pageRef = Page.AtlasMoveInternalAccount;
        Test.setCurrentPage(pageRef);
      
        User userObj = TestDataManager.createPortalUser('Test Account 1', 'John', 'Smith', 'john@viasat.com', 
                                                        'JohnP', 'SmithP');
        userObj.Account_Number__c = 'INTERNAL_1111';
        userObj.ExternalAccountReference__c = '11111111';
        userObj.phone = '8003334444';
        update userObj;
        
        Contact contactObj = [select Id, Account_Number__c, Email, Phone from Contact where Id = :userObj.ContactId];
        contactObj.Account_Number__c = 'INTERNAL_1111';
        contactObj.Phone = '8663334444';
        update contactObj;
        
        ApexPages.currentPage().getParameters().put('Id', userObj.Id);
        
        Test.startTest();
        
        // This causes a fake response to be generated
        Test.setMock(WebServiceMock.class, new FindSubscribersWebServiceSuccessMockImpl());
        
        AtlasMoveInternalAccountController controller = new AtlasMoveInternalAccountController();
        controller.newInternalAccountNumber = INTERNAL_ACCT_REF_NUM;
        controller.userObj = userObj;
        PageReference nextPage = controller.moveInternalAccount();
        System.assertEquals(NULL, nextPage);
        
        String contactId = controller.userObj.ContactId;
        contactObj = [select Id, Account_Number__c, Email, Phone from Contact where Id = :contactId];
        
        // verify the contents of the user object and the contact object
        System.assertEquals(controller.userObj.Account_Number__c, INTERNAL_ACCT_REF_NUM);
        System.assertEquals(contactObj.Account_Number__c, INTERNAL_ACCT_REF_NUM);
        System.assertEquals(contactObj.Email, EMAIL_ADDRESS);
        System.assertEquals(contactObj.Phone, PRIMARY_PHONE_NUMBER);
        System.assertEquals(controller.userObj.Phone, PRIMARY_PHONE_NUMBER);
        
        Test.stopTest();
    }
    */
}