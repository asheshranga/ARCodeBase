/***********************************************************************************************************
Name          : TestDataManager
Created By    : Sujit Kumar
Company Name  : NTT Data
Project       : ViaSat Atlas
Created Date  : 22 May, 2014
Modified Date : 12 June, 2014
Description   : This class provides generic environment agnostic data to all test cases.
                Helps test cases _NOT_ to use SeeAllData annotation, thereby making them isolated & not depend on the environment.
                A test class can use it's own data manager to provide additional data that is specific to it's own test cases.
                Make test cases "FIRST class" - fast, isolated, repeatable, small, transparent.
************************************************************************************************************/
@IsTest
public with sharing class TestDataManager {

   public static User portalAccountOwner = new User(
         UserRoleId = ViasatPortalUserTest.portalRole.Id,
         ProfileId = ViasatTestUtility.adminProfile.Id,
         Username = System.now().millisecond() + '@username-test.com',
         Alias = 'batman',
         Email='bruce.wayne@test.com',
         EmailEncodingKey='UTF-8',
         Firstname='Bruce',
         Lastname='Wayne',
         LanguageLocaleKey='en_US',
         LocaleSidKey='en_US',
         TimeZoneSidKey='America/Chicago'
    );
   
   public static User adminTestUser1 = new User(Alias = 'admUser1', Email='adminTestUser1@viasat.com', 
                              ExternalAccountReference__c = '11111111', 
                              Account_Number__c = 'Test Account 1111', FederationIdentifier = 'Fed-Id-111', 
                              EmailEncodingKey='UTF-8', FirstName='Peter', LastName='Parker', LanguageLocaleKey='en_US', 
                              LocaleSidKey='en_US', ProfileId = ViasatTestUtility.adminProfile.Id, 
                              TimeZoneSidKey='America/Los_Angeles', UserName='adminTestUser1@nttdata.com');
                              
   public static Contact contactForAdminTestUser1 = new Contact(Email='adminTestUser1@viasat.com', 
                                                             FirstName='Peter', LastName='Parker');                            
                               
   public static User adminTestUser2 = new User(Alias = 'admUser2', Email='adminTestUser2@viasat.com', 
                              ExternalAccountReference__c = '22222222', 
                              Account_Number__c = 'Test Account 2222', FederationIdentifier = 'Fed-Id-2222',
                              EmailEncodingKey='UTF-8', FirstName='Joshua', LastName='King', LanguageLocaleKey='en_US', 
                              LocaleSidKey='en_US', ProfileId = ViasatTestUtility.adminProfile.Id, 
                              TimeZoneSidKey='America/Los_Angeles', UserName='adminTestUser2@nttdata.com');
                              
   public static Contact contactForAdminTestUser2 = new Contact(Email='adminTestUser2@viasat.com', 
                                                             FirstName='Joshua', LastName='King');                               
                              
   public static User adminTestUser3 = new User(Alias = 'admUser3', Email='adminTestUser3@viasat.com', 
                              ExternalAccountReference__c = '33333333', 
                              Account_Number__c = 'Test Account 3333', FederationIdentifier = 'Fed-Id-3333',
                              EmailEncodingKey='UTF-8', FirstName='John', LastName='Smith', LanguageLocaleKey='en_US', 
                              LocaleSidKey='en_US', ProfileId = ViasatTestUtility.adminProfile.Id, 
                              TimeZoneSidKey='America/Los_Angeles', UserName='adminTestUser3@nttdata.com');
                              
   public static Contact contactForAdminTestUser3 = new Contact(Email='adminTestUser3@viasat.com', 
                                                             FirstName='John', LastName='Smith');                               
   

   public static Contact dummyContact = new Contact(Email='TestContact@viasat.com', 
                                                             FirstName='Test', LastName='Contact');
                                                                                            
   /**
    * @author              Sujit Kumar
    * @description      Creates a User object that has a portal account contact and a portal profile
    * @return param     returns the created Portal User
    */   
   public static User createPortalUser(String accountName, String contactFirstName, 
                                       String contactLastName, String contactEmail,
                                             String portalUserFirstName, String portalUserLastName) {
      return createPortalUser(accountName, contactFirstName, 
                                       contactLastName, contactEmail,
                                       portalUserFirstName, portalUserLastName,
                                       null, null, null, null);
   }
   
      /**
    * @author           Sujit Kumar
    * @description      Creates a User object that has a portal account contact and a portal profile
    * @return param     returns the created Portal User
    */   
   public static User createPortalUser(String accountName, String contactFirstName, 
                                       String contactLastName, String contactEmail,
                                       String portalUserFirstName, String portalUserLastName,
                                       String internalAccountNumber, String externalAccountNumber,
                                       String phone, String federationId) {
      Database.upsert(portalAccountOwner);

      //Create account using portal account owner
      Account portalAccount = new Account(Name = accountName, OwnerId = portalAccountOwner.Id);
      Database.insert(portalAccount);

      //Create contact using portal account
      Contact portalAccountContact = new Contact(
         FirstName = contactFirstName,
         Lastname = contactLastName,
         AccountId = portalAccount.Id,
         Email = contactEmail
      );
      if (internalAccountNumber!=null)  portalAccountContact.Account_Number__c = internalAccountNumber;
      if (externalAccountNumber!=null)  portalAccountContact.ExternalAccountReference__c = externalAccountNumber;
      Database.insert(portalAccountContact);
         
      //Create portal user using portalUserContact and portalProfile
      User portalUser = new User(
         Username = ViasatTestUtility.getNamePrefix() + '@username-test.com',
         ContactId = portalAccountContact.Id,
         ProfileId = ViasatPortalUserTest.portalProfile.Id,
         Alias = portalUserFirstName,
         Email = ViasatTestUtility.getNamePrefix() + '@user-test.com',
         EmailEncodingKey = 'UTF-8',
         firstName = portalUserFirstName,
         LastName = portalUserLastName,
         CommunityNickname = portalUserFirstName,
         TimeZoneSidKey = 'America/Los_Angeles',
         LocaleSidKey = 'en_US',
         LanguageLocaleKey = 'en_US');
         
      if (internalAccountNumber!=null)  portalUser.Account_Number__c = internalAccountNumber;
      if (externalAccountNumber!=null)  portalUser.ExternalAccountReference__c = externalAccountNumber;
      if (phone!= null) portalUser.phone = phone;
      if (federationId!=null)   portalUser.FederationIdentifier = federationId;

      Database.insert(portalUser);
      
      return portalUser;
   }
}