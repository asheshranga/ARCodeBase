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
private class AtlasUpdateSPRSFDataControllerTest {

    static testMethod void testSPRCallout() {
        
        AtlasTestMainClass.setTestKeyValueStoreForAtlas();
        AtlasTestMainClass.createCommunityUser();
        
        User u = [select id, contactId from User where contactId != null and IsActive = true order by createdDate desc limit 1];
        System.assertNotEquals(null,u);
        System.assertNotEquals(null,u.ContactId);

        Contact c = [select id, accountId from Contact where id = :u.contactId];
        System.assertNotEquals(null,c);
        System.assertNotEquals(null,c.accountId);
        
        Account a = [select id from Account where id = :c.accountId];
        
        if(AtlasUtility.getMapValue(AtlasConstants.Account_Owner) == null)
        {    
        	AtlasKeyValueStore__c kval =  new AtlasKeyValueStore__c();
        	kval.name = AtlasConstants.Account_Owner;
            kval.Code__c = AtlasConstants.Account_Owner;
        	kval.Value__c  = [select id from User where contactId != null and isActive = true limit 1].id;            
            insert kval;
        }    
        
        System.assert(AtlasKeyValueStore__c.getInstance('Account_Owner') != null);
        
        System.assert(AtlasKeyValueStore__c.getInstance(AtlasConstants.Account_Owner) != null);
        
        AtlasUtility.MapKeyValue=AtlasKeyValueStore__c.getAll();
        
        System.assert(AtlasUtility.getMapValue(AtlasConstants.Account_Owner) != null);
        
        New_User_Registration_History__c objNUR= new New_User_Registration_History__c();
        objNUR.Username__c='Test';
        objNUR.Time_Stamp__c=system.now();
        objNUR.Step2_Username__c=true;
        objNUR.Error_Message__c='';
        objNUR.Step4_Security_Questions__c = true;
        objNUR.Step6_Account_Created__c = false;
        objNUR.Send_Email__c = false;
        insert objNUR;
        
        Test.startTest();
        AtlasUpdateSPRSFDataController.callSPR(objNUR.id, null, a.id); 
        Test.stopTest();
    }
    
    static testMethod void testNoUserNameAndPwd()
    {
        AtlasTestMainClass.setTestKeyValueStoreForAtlas();
        AtlasTestMainClass.createCommunityUser();
        
        User u = [select id, contactId from User where contactId != null and IsActive = true order by createdDate desc limit 1];
        System.assertNotEquals(null,u);
        System.assertNotEquals(null,u.ContactId);

        Contact c = [select id, accountId from Contact where id = :u.contactId];
        System.assertNotEquals(null,c);
        System.assertNotEquals(null,c.accountId);
        
        Account a = [select id from Account where id = :c.accountId];
        
        User testUser = [select id from User where isActive = true and ContactId != null limit 1];
        System.runAs(testUser)
        {
        	u.Account_Number__c = a.id;
        	update u;
        }
        
        New_User_Registration_History__c objNUR= new New_User_Registration_History__c();
        objNUR.Username__c='Test';
        objNUR.Time_Stamp__c=system.now();
        objNUR.Step2_Username__c=true;
        objNUR.Error_Message__c='';
        objNUR.Step4_Security_Questions__c = true;
        objNUR.Step6_Account_Created__c = false;
        objNUR.Send_Email__c = false;
        insert objNUR;
        
        TestKeyValueStore__c t = [select id from TestKeyValueStore__c where code__c = 'getSubscriberResponse_element' limit 1];   
        System.assertNotEquals(null, t);
        
        //Remove security questions and loginusername from the response
        t.Metadata__c = '{ "subscriberkey_type_info":[ "subscriberkey", "http://api.viasat.com/schema/atlas/sso", null, "0", "1", "false" ], "subscriberkey":100000578676070, "subscriber_type_info":[ "subscriber", "http://api.viasat.com/schema/atlas/sso", null, "0", "1", "false" ], "subscriber":{ "usernames_type_info":[ "usernames", "http://api.viasat.com/schema/atlas/sso", null, "0", "1", "false" ], "usernames":{ "username_type_info":[ "username", "http://api.viasat.com/schema/atlas/sso", null, "0", "-1", "true" ], "username":[ "00A0BC2F6181" ], "field_order_type_info":[ "username" ], "apex_schema_type_info":[ "http://api.viasat.com/schema/atlas/sso", "true", "false" ] }, "subscriberkey_type_info":[ "subscriberkey", "http://api.viasat.com/schema/atlas/sso", null, "1", "1", "false" ], "subscriberkey":100000578676070, "subscriberid_type_info":[ "subscriberid", "http://api.viasat.com/schema/atlas/sso", null, "1", "1", "false" ], "subscriberid":"400368928", "sprattributes_type_info":[ "sprattributes", "http://api.viasat.com/schema/atlas/sso", null, "0", "1", "false" ], "sprattributes":{ "sprattribute_type_info":[ "sprattribute", "http://api.viasat.com/schema/atlas/sso", null, "1", "-1", "false" ], "sprattribute":[ { "values_type_info":[ "values", "http://api.viasat.com/schema/atlas/sso", null, "0", "1", "false" ], "values":null, "value_type_info":[ "value", "http://api.viasat.com/schema/atlas/sso", null, "0", "1", "false" ], "value":"exede12 - 10 GB", "sprattributes_type_info":[ "sprattributes", "http://api.viasat.com/schema/atlas/sso", null, "0", "1", "false" ], "sprattributes":null, "name_type_info":[ "name", "http://api.viasat.com/schema/atlas/sso", null, "1", "1", "false" ], "name":"packageId", "field_order_type_info":[ "name", "value", "values", "sprattributes" ], "apex_schema_type_info":[ "http://api.viasat.com/schema/atlas/sso", "true", "false" ] }, { "values_type_info":[ "values", "http://api.viasat.com/schema/atlas/sso", null, "0", "1", "false" ], "values":null, "value_type_info":[ "value", "http://api.viasat.com/schema/atlas/sso", null, "0", "1", "false" ], "value":"active", "sprattributes_type_info":[ "sprattributes", "http://api.viasat.com/schema/atlas/sso", null, "0", "1", "false" ], "sprattributes":null, "name_type_info":[ "name", "http://api.viasat.com/schema/atlas/sso", null, "1", "1", "false" ], "name":"status", "field_order_type_info":[ "name", "value", "values", "sprattributes" ], "apex_schema_type_info":[ "http://api.viasat.com/schema/atlas/sso", "true", "false" ] }, { "values_type_info":[ "values", "http://api.viasat.com/schema/atlas/sso", null, "0", "1", "false" ], "values":null, "value_type_info":[ "value", "http://api.viasat.com/schema/atlas/sso", null, "0", "1", "false" ], "value":"FALSE", "sprattributes_type_info":[ "sprattributes", "http://api.viasat.com/schema/atlas/sso", null, "0", "1", "false" ], "sprattributes":null, "name_type_info":[ "name", "http://api.viasat.com/schema/atlas/sso", null, "1", "1", "false" ], "name":"disableEnforcement", "field_order_type_info":[ "name", "value", "values", "sprattributes" ], "apex_schema_type_info":[ "http://api.viasat.com/schema/atlas/sso", "true", "false" ] }, { "values_type_info":[ "values", "http://api.viasat.com/schema/atlas/sso", null, "0", "1", "false" ], "values":null, "value_type_info":[ "value", "http://api.viasat.com/schema/atlas/sso", null, "0", "1", "false" ], "value":"WildBlue", "sprattributes_type_info":[ "sprattributes", "http://api.viasat.com/schema/atlas/sso", null, "0", "1", "false" ], "sprattributes":null, "name_type_info":[ "name", "http://api.viasat.com/schema/atlas/sso", null, "1", "1", "false" ], "name":"serviceProvider", "field_order_type_info":[ "name", "value", "values", "sprattributes" ], "apex_schema_type_info":[ "http://api.viasat.com/schema/atlas/sso", "true", "false" ] }, { "values_type_info":[ "values", "http://api.viasat.com/schema/atlas/sso", null, "0", "1", "false" ], "values":null, "value_type_info":[ "value", "http://api.viasat.com/schema/atlas/sso", null, "0", "1", "false" ], "value":"28", "sprattributes_type_info":[ "sprattributes", "http://api.viasat.com/schema/atlas/sso", null, "0", "1", "false" ], "sprattributes":null, "name_type_info":[ "name", "http://api.viasat.com/schema/atlas/sso", null, "1", "1", "false" ], "name":"billReset", "field_order_type_info":[ "name", "value", "values", "sprattributes" ], "apex_schema_type_info":[ "http://api.viasat.com/schema/atlas/sso", "true", "false" ] }, { "values_type_info":[ "values", "http://api.viasat.com/schema/atlas/sso", null, "0", "1", "false" ], "values":null, "value_type_info":[ "value", "http://api.viasat.com/schema/atlas/sso", null, "0", "1", "false" ], "value":"America/New_York", "sprattributes_type_info":[ "sprattributes", "http://api.viasat.com/schema/atlas/sso", null, "0", "1", "false" ], "sprattributes":null, "name_type_info":[ "name", "http://api.viasat.com/schema/atlas/sso", null, "1", "1", "false" ], "name":"timeZone", "field_order_type_info":[ "name", "value", "values", "sprattributes" ], "apex_schema_type_info":[ "http://api.viasat.com/schema/atlas/sso", "true", "false" ] } ], "field_order_type_info":[ "sprattribute" ], "apex_schema_type_info":[ "http://api.viasat.com/schema/atlas/sso", "true", "false" ] }, "getsubscriberuri_type_info":[ "getsubscriberuri", "http://api.viasat.com/schema/atlas/sso", null, "1", "1", "false" ], "getsubscriberuri":"/sso/subscribers/100000578676070", "field_order_type_info":[ "subscriberkey", "subscriberid", "usernames", "getsubscriberuri", "sprattributes" ], "apex_schema_type_info":[ "http://api.viasat.com/schema/atlas/sso", "true", "false" ] }, "status_type_info":[ "status", "http://api.viasat.com/schema/atlas/sso", null, "0", "1", "false" ], "status":"Success", "ssotoken_type_info":[ "ssotoken", "http://api.viasat.com/schema/atlas/sso", null, "0", "1", "false" ], "ssotoken":null, "field_order_type_info":[ "subscriberkey", "ssotoken", "subscriber" ], "errorcode_type_info":[ "errorcode", "http://api.viasat.com/schema/atlas/sso", null, "0", "1", "false" ], "errorcode":null, "error_type_info":[ "error", "http://api.viasat.com/schema/atlas/sso", null, "0", "1", "false" ], "error":null, "apex_schema_type_info":[ "http://api.viasat.com/schema/atlas/sso", "true", "false" ] }';
        update t;
        
        if(AtlasUtility.getMapValue(AtlasConstants.Atlas_Community_Profile) == null)
        {    
        	AtlasKeyValueStore__c kval =  new AtlasKeyValueStore__c();
        	kval.name = AtlasConstants.Atlas_Community_Profile;
            kval.Code__c = AtlasConstants.Atlas_Community_Profile;
        	kval.Value__c  = [select id from Profile where name = 'ATLAS Community'].id;            
            insert kval;
        }    
        AtlasUtility.MapKeyValue=AtlasKeyValueStore__c.getAll();
        string profileId = atlasutility.getMapValue(atlasconstants.Atlas_Community_Profile);
		        System.assertnotequals(null, profileId);

        SObject prof = [select id from profile where Id =: profileId];
        
        System.assertnotequals(null, prof);
        
        Test.startTest();
        AtlasUpdateSPRSFDataController.callSPR(objNUR.id, null, a.id); 
        AtlasUpdateSPRSFDataController.DeleteSFData(a.id);
        AtlasUpdateSPRSFDataController.deleteAccount(a.id);
        Test.stopTest();
    }
    
   public static String CRON_EXP = '0 0 0 15 3 ? 2022';

   public static testmethod void testScheduling() {
      Test.startTest();

      // Schedule the test job
      String jobId = System.schedule('AtlasUpdateSPRSFDataControllerTest',
                        CRON_EXP, 
                        new AtlasUpdateSPRSFDataController());
         
      // Get the information from the CronTrigger API object
      CronTrigger ct = [SELECT Id, CronExpression, TimesTriggered, 
         NextFireTime
         FROM CronTrigger WHERE id = :jobId];

      // Verify the expressions are the same
      System.assertEquals(CRON_EXP, 
         ct.CronExpression);

      // Verify the job has not run
      System.assertEquals(0, ct.TimesTriggered);
      Test.stopTest();
   }

    
    static testMethod void testExceptionWithWS()
    {
        AtlasTestMainClass.createCommunityUser();    
        
        User u = [select id, contactId from User where contactId != null and IsActive = true order by createdDate desc limit 1];
        System.assertNotEquals(null,u);
        System.assertNotEquals(null,u.ContactId);

        Contact c = [select id, accountId from Contact where id = :u.contactId];
        System.assertNotEquals(null,c);
        System.assertNotEquals(null,c.accountId);
        
        Account a = [select id from Account where id = :c.accountId];
        
        New_User_Registration_History__c objNUR= new New_User_Registration_History__c();
        objNUR.Username__c='Test';
        objNUR.Time_Stamp__c=system.now();
        objNUR.Step2_Username__c=true;
        objNUR.Error_Message__c='';
        objNUR.Step4_Security_Questions__c = true;
        objNUR.Step6_Account_Created__c = false;
        objNUR.Send_Email__c = false;
        insert objNUR;
        
        Test.startTest();
        AtlasUpdateSPRSFDataController.callSPR(objNUR.id, null, a.id);
        Test.stopTest();
    }
}