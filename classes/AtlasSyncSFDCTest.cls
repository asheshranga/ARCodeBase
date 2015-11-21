/*********************************************************************************
Name         : AtlasSyncSFDCTest
Created By   : Tejesh Mandapati
Created Date : 10 June, 2014
Project      : ViaSat Atlas, CA
Usages       : Automated unit tests for AtlasSyncSFDC
Change Log:
<Date>				<Modified By>		<Change Description>
10th June, 2014		Sujit Kumar			Added test case syncUserAndContact
25th June, 2014		Sujit Kumar			Added test case moveInternalAccountNumber
7th  July, 2014		Sujit Kumar			Refactored testsyncContacts test method
30th July, 2014      Sujit Kumar       Refactored as tests were failing on 
                                       Developer Console but not on eclipse
*********************************************************************************/

@isTest
public class AtlasSyncSFDCTest {
    
    private static final String INTERNAL_ACCT_REF_NUM = 'INTERNAL_ACCT_REF_001';
    private static final String EXTERNAL_ACCT_REF_NUM = 'EXTERNAL_ACCT_REF_001';
    private static final String EMAIL_ADDRESS = 'john@yyzz.com';
	 private static final String PRIMARY_PHONE_NUMBER = '972-333-4444';
    
    /*
    *   AtlasIntegrationUtility.findSubscribersBySearchCriteriaGeneric needs this custom setting
    *   It is required even though you use a mock to simulate the web service callout.
    *   This setting is used even before you make the callout in the findSubscribersBySearchCriteriaGeneric method.
    */
    private static void setupCustomSettings() {
		AtlasTestMainClass.setTestKeyValueStoreForAtlas();
      AtlasWebserviceSetting__c findSubscriberSetting = new AtlasWebserviceSetting__c();
      findSubscriberSetting.name = 'FindSubscriber';
      findSubscriberSetting.End_Point__c = 'http://www.google.com';
      
      User thisUser = [ select Id from User where Id = :UserInfo.getUserId() ];
      System.runAs(thisUser) {
        insert findSubscriberSetting;
      }
   }
   
    /*
     *  @author Tejesh
     */
    public static testmethod void testSyncContacts() {
    	 User userObj;
    	 System.runAs(TestDataManager.adminTestUser1) {
    	    userObj = TestDataManager.createPortalUser('Test Account 1', 'John', 'Smith', 'john@viasat.com', 
	                                                   'JohnP', 'SmithP', 'INTERNAL_1111', '11111111',
	                                                   '8003334444', 'myfed@devatlas.exede.net');
    	 }
    	 
	    String newPhone = '8663334444';
	    String newEmail = 'tejesh@devatlas.exede.net';
	    String newUserName = 'tejesh@devatlas.exede.nettr'; 
	    AtlasTransactionDTO.UpdateCustomerInfoTxDTO testUpdateCustomerInfoTxDTO = 
	         new AtlasTransactionDTO.UpdateCustomerInfoTxDTO(
	         			userObj.ExternalAccountReference__c ,
	         			'test','test',
	         			newPhone,
	         			newEmail,
	         			'test','test','test','test','test','test','test','test','test','test','test','test','test');  
	    
	    User thisUser = [ select Id from User where Id = :UserInfo.getUserId() ];
       System.runAs(thisUser) {
		    AtlasSyncSFDC syn = new AtlasSyncSFDC();
		    syn.syncContacts(testUpdateCustomerInfoTxDTO);
		    syn.syncUsername(userObj.FederationIdentifier, newUserName);
	    }
	    
	    // Retrieve the user and contact after the methods syncContacts and syncUsername are called
	    userObj = [select Id, ContactId, FederationIdentifier 
	               from User 
	               where FederationIdentifier = :newUserName LIMIT 1];
	    Contact contactObj = [select Id, Email, Phone from Contact where Email = :newEmail];
	    
	    System.assertEquals(newPhone, contactObj.Phone);
	    System.assertEquals(newEmail, contactObj.Email);
	    System.assertEquals(newUserName, userObj.FederationIdentifier);
    }
    
    /*
     *  @author Sujit Kumar
     */
    public class FindSubscribersWebServiceSyncSuccessMockImpl implements WebServiceMock {
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
          
          subscriberAccount.internalAccountReference = AtlasSyncSFDCTest.INTERNAL_ACCT_REF_NUM;
          
          subscriberContact.emailAddress = AtlasSyncSFDCTest.EMAIL_ADDRESS;
		    subscriberContact.primaryPhoneNumber = AtlasSyncSFDCTest.PRIMARY_PHONE_NUMBER;
		    
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
     */
    public class FindSubscribersWebServiceMoveSuccessMockImpl implements WebServiceMock {
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
          subscriberAccount.internalAccountReference = AtlasSyncSFDCTest.INTERNAL_ACCT_REF_NUM;
          subscriberAccount.externalAccountReference = AtlasSyncSFDCTest.EXTERNAL_ACCT_REF_NUM;
          subscriberContact.emailAddress = AtlasSyncSFDCTest.EMAIL_ADDRESS;
		  subscriberContact.primaryPhoneNumber = AtlasSyncSFDCTest.PRIMARY_PHONE_NUMBER;
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
     */
    public static testmethod void syncUserAndContact() {
    	 setupCustomSettings();
    	  	 
    	 insert TestDataManager.adminTestUser1;
    	 
       User userObj;
       System.runAs(TestDataManager.adminTestUser1) {
          userObj = TestDataManager.createPortalUser('Test Account 1', 'John', 'Smith', 'john@viasat.com', 
                                                      'JohnP', 'SmithP', 'INTERNAL_5252', '52525252',
                                                      '8003334444', 'myfed@devatlas.exede.net');
       }
	    
	    Test.startTest();
	    
	    AtlasSyncSFDC sync = new AtlasSyncSFDC();
	    // DO NOT REMOVE THE LINE BELOW, otherwise the call to sync.syncUserAndContact fails
       User thisUser = [ select Id from User where Id = :UserInfo.getUserId() ];
       System.runAs(TestDataManager.adminTestUser1) {
       	 // This causes a fake response to be generated
          Test.setMock(WebServiceMock.class, new FindSubscribersWebServiceSyncSuccessMockImpl());
       	 boolean syncStatus = sync.syncUserAndContact(userObj.ExternalAccountReference__c);
       	 System.assert(syncStatus, 'syncUserAndContact call failed!');
	    
		    // Retrieve the user and contact after the method syncUserAndContact is called
		    userObj = [select Id, ContactId, Account_Number__c, ExternalAccountReference__c, Phone 
		               from User 
		               where ExternalAccountReference__c = :userObj.ExternalAccountReference__c LIMIT 1];
		    Contact contactObj = [select Id, Account_Number__c, Email, Phone 
		                          from Contact 
		                          where ExternalAccountReference__c = :userObj.ExternalAccountReference__c];

		    // verify the contents of the user object and the contact object
		    System.assertEquals(AtlasSyncSFDCTest.INTERNAL_ACCT_REF_NUM, userObj.Account_Number__c, 'user internal account number mis-match!');
		    System.assertEquals(AtlasSyncSFDCTest.PRIMARY_PHONE_NUMBER, userObj.Phone, 'user phone number mis-match!');
		    System.assertEquals(AtlasSyncSFDCTest.INTERNAL_ACCT_REF_NUM, contactObj.Account_Number__c, 'contact internal account number mis-match!');
		    System.assertEquals(AtlasSyncSFDCTest.EMAIL_ADDRESS, contactObj.Email, 'contact email mis-match!');
		    System.assertEquals(AtlasSyncSFDCTest.PRIMARY_PHONE_NUMBER, contactObj.Phone, 'contact phone number mis-match!');
       }
	    Test.stopTest();
    }
    
    /*
     *  @author Sujit Kumar
     */
    public static testmethod void moveInternalAccountNumber() {
       setupCustomSettings();
       insert TestDataManager.adminTestUser1;
       User userObj;
       System.runAs(TestDataManager.adminTestUser1) {
          userObj = TestDataManager.createPortalUser('Test Account 1', 'John', 'Smith', 'john@viasat.com', 
                                                      'JohnP', 'SmithP', 'INTERNAL_5252', '52525252',
                                                      '8003334444', 'myfed@devatlas.exede.net');
       }
       Test.startTest();
	    String oldInternalAccountNumber = userObj.Account_Number__c;
	       
	    AtlasSyncSFDC sync = new AtlasSyncSFDC();
       // DO NOT REMOVE THE LINE BELOW, otherwise the call to sync.syncUserAndContact fails
       User thisUser = [ select Id from User where Id = :UserInfo.getUserId() ];
       System.runAs(TestDataManager.adminTestUser1) {
          // This causes a fake response to be generated
          Test.setMock(WebServiceMock.class, new FindSubscribersWebServiceMoveSuccessMockImpl());
          
          String newInternalAccountNumber = AtlasSyncSFDCTest.INTERNAL_ACCT_REF_NUM;
          Boolean status = sync.moveInternalAccountNumber(newInternalAccountNumber, oldInternalAccountNumber);
   	    System.assert(status, 'AtlasSyncSFDC.moveInternalAccountNumber failed!');
	    
	       // Retrieve the user and contact after the method moveInternalAccountNumber is called
	       userObj = [select Id, ContactId, Account_Number__c, ExternalAccountReference__c, Phone 
	                  from User 
	                  where Account_Number__c = :AtlasSyncSFDCTest.INTERNAL_ACCT_REF_NUM LIMIT 1];
		               
	       Contact contactObj = [select Id, Account_Number__c, ExternalAccountReference__c, Email, Phone 
	                     from Contact 
	                     where Id = :userObj.ContactId];
		    // Assert on user
		    System.assertEquals(AtlasSyncSFDCTest.INTERNAL_ACCT_REF_NUM, userObj.Account_Number__c);
		    System.assertEquals(AtlasSyncSFDCTest.PRIMARY_PHONE_NUMBER, userObj.Phone);
		    System.assertEquals(AtlasSyncSFDCTest.EXTERNAL_ACCT_REF_NUM, userObj.ExternalAccountReference__c);
		    // Asserts on Contact
		    System.assertEquals(AtlasSyncSFDCTest.INTERNAL_ACCT_REF_NUM, contactObj.Account_Number__c);
		    System.assertEquals(AtlasSyncSFDCTest.EXTERNAL_ACCT_REF_NUM, contactObj.ExternalAccountReference__c);
		    System.assertEquals(AtlasSyncSFDCTest.EMAIL_ADDRESS, contactObj.Email);
		    System.assertEquals(AtlasSyncSFDCTest.PRIMARY_PHONE_NUMBER, contactObj.Phone);
       }
	    Test.stopTest();
    }
}