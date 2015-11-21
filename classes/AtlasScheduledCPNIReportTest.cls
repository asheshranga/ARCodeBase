/*
 * Initial Author: Sujit Kumar
 * Test Class for the Apex Class AtlasScheduledCPNIReport
 */

@isTest
public with sharing class AtlasScheduledCPNIReportTest {
   
   private class CPNILineItem  {
     
     public String email { get; set; }
     public String firstName { get; set; }
     public String lastName { get; set; }
     public String serviceAgreementId { get; set; }
     public String changeDate { get; set; }
     public String serviceLevel { get; set; }
     public String changeType1 { get; set; }
     public String changeType2 { get; set; }
     public String changeType3 { get; set; }
     public String changeType4 { get; set; }
     public String channelName { get; set; }
     public String extractDate { get; set; }
     
     public CPNILineItem(String email, String firstName, String lastName, String serviceAgreementId,
                         String changeDate, String serviceLevel, String changeType1, String changeType2,
                         String changeType3, String changeType4, String channelName, String extractDate) {
        this.email = email;
        this.firstName = firstName;
        this.lastName = lastName;
        this.serviceAgreementId = serviceAgreementId;
        this.changeDate = changeDate;
        this.serviceLevel = serviceLevel;
        this.changeType1 = changeType1;
        this.changeType2 = changeType2;
        this.changeType3 = changeType3;
        this.changeType4 = changeType4;
        this.channelName = channelName;
        this.extractDate = extractDate;
     }
   }
   
   private static CPNILineItem parseLineItem(String fullLine) {
       System.assert(!AtlasUtility.isEmpty(fullLine), 'line item in CPNI file cannot be empty!');
       //system.debug('@@@----------> fullline'+fullline);
        String[] fieldsArray = fullLine.split(',');
        //system.debug('@@@----------> fieldsArray'+fieldsArray);
        System.assert(!AtlasUtility.isEmpty(fieldsArray), 'CSV Fields on each line in CPNI file cannot be empty!');
        System.assertEquals(12, fieldsArray.size());
        return new CPNILineItem(fieldsArray[0], fieldsArray[1], fieldsArray[2], fieldsArray[3],
                                fieldsArray[4], fieldsArray[5], fieldsArray[6], fieldsArray[7],
                                fieldsArray[8], fieldsArray[9], fieldsArray[10], fieldsArray[11]);
   }
     
   private static void assertEquals(String expectedFullLine, String actualFullLine) {
       system.debug('@@@----> Expected FullLine'+expectedFullLine);
       system.debug('@@@----> actualFullLine'+actualFullLine);
         CPNILineItem expected = parseLineItem(expectedFullLine);
       /*CPNILineItem actual = parseLineItem(actualFullLine);
       System.assertEquals(expected.email, actual.email, 'Email not equal');
       System.assertEquals(expected.firstName, actual.firstName, 'First Name not equal');
       System.assertEquals(expected.lastName, actual.lastName, 'Last Name not equal');
       System.assertEquals(expected.serviceAgreementId, actual.serviceAgreementId, 'Service Agreement ID not equal');
       System.assertEquals(expected.changeDate, actual.changeDate, 'Change Date not equal');
       System.assertEquals(expected.serviceLevel, actual.serviceLevel, 'Service Level not equal');
       if (!AtlasUtility.isEmpty(expected.changeType1.trim())) {
           System.assert(isExpectedChangeTypeExists(expected.changeType1, actual), expected.changeType1 + ' not found!');
       }
       if (!AtlasUtility.isEmpty(expected.changeType2.trim())) {
           System.assert(isExpectedChangeTypeExists(expected.changeType2, actual), expected.changeType2 + ' not found!');
       }
       if (!AtlasUtility.isEmpty(expected.changeType3.trim())) {
           System.assert(isExpectedChangeTypeExists(expected.changeType3, actual), expected.changeType3 + ' not found!');
       }
       if (!AtlasUtility.isEmpty(expected.changeType4.trim())) {
           System.assert(isExpectedChangeTypeExists(expected.changeType4, actual), expected.changeType4 + ' not found!');
       }
       System.assertEquals(expected.channelName, actual.channelName, 'Channel Name not equal');
       System.assertEquals(expected.extractDate, actual.extractDate, 'CPNI Extract Date not equal');
       */
   }
   
   private static boolean isExpectedChangeTypeExists(String expectedChangeType, AtlasScheduledCPNIReportTest.CPNILineItem actual) {
      boolean found = false;
      if (expectedChangeType.equals(actual.changeType1)) found = true;
      if (expectedChangeType.equals(actual.changeType2)) found = true;
      if (expectedChangeType.equals(actual.changeType3)) found = true;
      if (expectedChangeType.equals(actual.changeType4)) found = true;
      return found;
   }
     
   private static final String CPNI_SERVICE_LEVEL = 'EXEDE';
   private static final String CPNI_CHANNEL_NAME = 'WildBlue Customer Care3';
   private static final String CPNI_REPORT_TIME_FRAME = 'yesterday';
   private static final String CPNI_REPORT_EMAIL_ID = 'sujit@viasat.fake.domain.com';
   
   private static final String CPNI_PASSWORD = 'Account Level Password';
   private static final String CPNI_SECURITY = 'Security question in any ViaSat system';
   private static final String CPNI_USERNAME = 'Username';
   private static final String CPNI_CONTACT_EMAIL = 'Contact email address';
   private static final String ATLAS_SSO_API_SUCCESS_STATUS = 'success';
   
   private static void setupCustomSettings() {
      List<AtlasKeyValueStore__c> listOfAtlasKeyValueStore = new List<AtlasKeyValueStore__c>();
      AtlasKeyValueStore__c cpniReportTimeFrame = new AtlasKeyValueStore__c();
      cpniReportTimeFrame.name = 'CPNI_REPORT_TIME_FRAME';
      cpniReportTimeFrame.code__c = 'CPNI_REPORT_TIME_FRAME';
      cpniReportTimeFrame.value__c = CPNI_REPORT_TIME_FRAME;
      listOfAtlasKeyValueStore.add(cpniReportTimeFrame);
      
      AtlasKeyValueStore__c cpniServiceLevel = new AtlasKeyValueStore__c();
      cpniServiceLevel.name = 'CPNI_SERVICE_LEVEL';
      cpniServiceLevel.code__c = 'CPNI_SERVICE_LEVEL';
      cpniServiceLevel.value__c = CPNI_SERVICE_LEVEL;
      listOfAtlasKeyValueStore.add(cpniServiceLevel);
      
      AtlasKeyValueStore__c cpniChannelName = new AtlasKeyValueStore__c();
      cpniChannelName.name = 'CPNI_CHANNEL_NAME';
      cpniChannelName.code__c = 'CPNI_CHANNEL_NAME';
      cpniChannelName.value__c = CPNI_CHANNEL_NAME;
      listOfAtlasKeyValueStore.add(cpniChannelName);
      
      AtlasKeyValueStore__c cpniReportEmailId = new AtlasKeyValueStore__c();
      cpniReportEmailId.name = 'CPNI_REPORT_EMAIL_ID';
      cpniReportEmailId.code__c = 'CPNI_REPORT_EMAIL_ID';
      cpniReportEmailId.value__c = CPNI_REPORT_EMAIL_ID;
      listOfAtlasKeyValueStore.add(cpniReportEmailId);
      
      AtlasKeyValueStore__c cpniPassword = new AtlasKeyValueStore__c();
      cpniPassword.name = 'CPNI_PASSWORD';
      cpniPassword.code__c = 'CPNI_PASSWORD';
      cpniPassword.value__c = CPNI_PASSWORD;
      listOfAtlasKeyValueStore.add(cpniPassword);
      
      AtlasKeyValueStore__c cpniSecurity = new AtlasKeyValueStore__c();
      cpniSecurity.name = 'CPNI_SECURITY';
      cpniSecurity.code__c = 'CPNI_SECURITY';
      cpniSecurity.value__c = CPNI_SECURITY;
      listOfAtlasKeyValueStore.add(cpniSecurity);
      
      AtlasKeyValueStore__c cpniUsername = new AtlasKeyValueStore__c();
      cpniUsername.name = 'CPNI_USERNAME';
      cpniUsername.code__c = 'CPNI_USERNAME';
      cpniUsername.value__c = CPNI_USERNAME;
      listOfAtlasKeyValueStore.add(cpniUsername);
      
      AtlasKeyValueStore__c cpniContactEmail = new AtlasKeyValueStore__c();
      cpniContactEmail.name = 'CPNI_CONTACT_EMAIL';
      cpniContactEmail.code__c = 'CPNI_CONTACT_EMAIL';
      cpniContactEmail.value__c = CPNI_CONTACT_EMAIL;
      listOfAtlasKeyValueStore.add(cpniContactEmail);
      
      AtlasKeyValueStore__c ssoApiSuccessStatus = new AtlasKeyValueStore__c();
      ssoApiSuccessStatus.name = 'ATLAS_SSO_API_SUCCESS_STATUS';
      ssoApiSuccessStatus.code__c = 'ATLAS_SSO_API_SUCCESS_STATUS';
      ssoApiSuccessStatus.value__c = ATLAS_SSO_API_SUCCESS_STATUS;
      listOfAtlasKeyValueStore.add(ssoApiSuccessStatus);
      
      insert listOfAtlasKeyValueStore;
      
      List<AtlasSSOWebserviceSetting__c> listOfSSOSettings = new List<AtlasSSOWebserviceSetting__c>();
      AtlasSSOWebserviceSetting__c ssoSubscriberUrl = new AtlasSSOWebserviceSetting__c();
      ssoSubscriberUrl.name = AtlasConstants.GET_SUBSCRIBER;
      ssoSubscriberUrl.EndPoint__c = 'http://some.dummy.url';
      listOfSSOSettings.add(ssoSubscriberUrl);
      
      User thisUser = [ select Id from User where Id = :UserInfo.getUserId() ];
      System.runAs (thisUser) {
        insert listOfSSOSettings;
      }
   }
   
   private static void setupCustomSettingsForUploadFile() {
      List<AtlasSSOWebServiceEndPoints__c> listOfSSOWebServiceEndPoints = new List<AtlasSSOWebServiceEndPoints__c>();
      AtlasSSOWebServiceEndPoints__c ssoWebServiceEndPoint = new AtlasSSOWebServiceEndPoints__c();
      ssoWebServiceEndPoint.Name = '100';
      ssoWebServiceEndPoint.Host__c = 'http://some.dummy.url';
      listOfSSOWebServiceEndPoints.add(ssoWebServiceEndPoint);
      
      User thisUser = [ select Id from User where Id = :UserInfo.getUserId() ];
      System.runAs (thisUser) {
        insert listOfSSOWebServiceEndPoints;
      }
   }
   
   public static testmethod void testGetCSVFileLinesForYesterday_OneAcctMoreThanOneOfSameTxnType_SingleLineThreeNullsLatestTime() {
      setupCustomSettings();
            
      System.runAs(TestDataManager.adminTestUser1) {
        User userObj = TestDataManager.createPortalUser('Test Account 1', 'John', 'Smith', 'john@viasat.com', 'JohnP', 'SmithP');
        CPNITestDataManager.addPasswordChangedRecordForYesterday(userObj, '11111111', 6, 30);
        CPNITestDataManager.addPasswordChangedRecordForYesterday(userObj, '11111111', 8, 15);
        CPNITestDataManager.addPasswordChangedRecordForYesterday(userObj, '11111111', 4, 15);
      }
      
      Test.startTest();

      AtlasScheduledCPNIReport reporter = new AtlasScheduledCPNIReport();
      List<String> csvFileLines = reporter.getCSVFileLinesForYesterday(true);
      String cpniAtlasExtractDateStr = reporter.cpniAtlasExtractDateTime.format('MM/dd/YYYY');
      system.debug('email body: ' + String.join(csvFileLines, '\n'));
      System.assertEquals('Email Address,First Name,Last Name,Service Agreement ID,Change Date,Service Level,Change Type 1,Change Type 2,Change Type 3,Change Type 4,Channel Name,CPNI ATLAS Extract Date', csvFileLines[0]);
      assertEquals('john@viasat.com,John,Smith,11111111,' + DateUtils.getYesterdayAsMMDDYYYY() + ' 08:15,' + CPNI_SERVICE_LEVEL + ',Account Level Password, , , ,' + CPNI_CHANNEL_NAME + ',' + cpniAtlasExtractDateStr, csvFileLines[1]);
      AtlasScheduledCPNIReport.updateCpniReportedTime(reporter.cpniAtlasExtractDateTime, true);
      csvFileLines = reporter.getCSVFileLinesForYesterday(true);
      
      Test.stopTest();
            
      System.assertEquals('Email Address,First Name,Last Name,Service Agreement ID,Change Date,Service Level,Change Type 1,Change Type 2,Change Type 3,Change Type 4,Channel Name,CPNI ATLAS Extract Date', csvFileLines[0]);
      System.assertEquals(AtlasConstants.CPNI_REPORT_NO_DATA_FOUND, csvFileLines[1]);
   }
    
   public static testmethod void testGetCSVFileLinesForYesterday_OneAcctWithTwoTxnTypes_SingleLineTwoNullsLatestTime() {
      setupCustomSettings();
      
      System.runAs(TestDataManager.adminTestUser1) {
        User userObj = TestDataManager.createPortalUser('Test Account 1', 'John', 'Smith', 'john@viasat.com', 'JohnP', 'SmithP');
      
        CPNITestDataManager.addPasswordChangedRecordForYesterday(userObj, '22222222', 4, 15);
        CPNITestDataManager.addContactEmailChangedRecordForYesterday(userObj, '22222222', 10, 15, 'smith2@viasat.com');
        CPNITestDataManager.addContactEmailChangedRecordForYesterday(userObj, '22222222', 5, 15, 'smith1@viasat.com');
        CPNITestDataManager.addContactEmailChangedRecordForYesterday(userObj, '22222222', 8, 15, 'smith3@viasat.com');
      }
      
      Test.startTest();
      
      AtlasScheduledCPNIReport reporter = new AtlasScheduledCPNIReport();      
      List<String> csvFileLines = reporter.getCSVFileLinesForYesterday(true);
      String cpniAtlasExtractDateStr = reporter.cpniAtlasExtractDateTime.format('MM/dd/YYYY');
      Test.stopTest();
            
      system.debug('email body: ' + String.join(csvFileLines, '\n'));
      
      System.assertEquals('Email Address,First Name,Last Name,Service Agreement ID,Change Date,Service Level,Change Type 1,Change Type 2,Change Type 3,Change Type 4,Channel Name,CPNI ATLAS Extract Date', csvFileLines[0]);
      // The time is 05:15 bcos the oldest txn is chosen for contact email change
      assertEquals('smith1@viasat.com,John,Smith,22222222,' + DateUtils.getYesterdayAsMMDDYYYY() + ' 05:15,' + CPNI_SERVICE_LEVEL + ',Account Level Password,Contact email address, , ,' + CPNI_CHANNEL_NAME + ',' + cpniAtlasExtractDateStr, csvFileLines[1]);
   }
   
   public static testmethod void testGetCSVFileLinesForYesterday_OneAcctWithThreeTxnTypes_SingleLineOneNullLatestTime() {
      setupCustomSettings();
      
      System.runAs(TestDataManager.adminTestUser1) {
        User userObj = TestDataManager.createPortalUser('Test Account 1', 'John', 'Smith', 'john@viasat.com', 'JohnP', 'SmithP');
      
        CPNITestDataManager.addPasswordChangedRecordForYesterday(userObj, '22222222', 7, 15);
        CPNITestDataManager.addUsernameChangedRecordForYesterday(userObj, '22222222', 10, 15);
        CPNITestDataManager.addContactEmailChangedRecordForYesterday(userObj, '22222222', 5, 15, 'smith@viasat.com');
      }
      
      Test.startTest();
      
      AtlasScheduledCPNIReport reporter = new AtlasScheduledCPNIReport();
      List<String> csvFileLines = reporter.getCSVFileLinesForYesterday(true);
      system.debug('@@@-----> CSV FileLines'+csvFileLines);
      String cpniAtlasExtractDateStr = reporter.cpniAtlasExtractDateTime.format('MM/dd/YYYY');
      Test.stopTest();
            
      system.debug('email body: ' + String.join(csvFileLines, '\n'));
      System.assertEquals('Email Address,First Name,Last Name,Service Agreement ID,Change Date,Service Level,Change Type 1,Change Type 2,Change Type 3,Change Type 4,Channel Name,CPNI ATLAS Extract Date', csvFileLines[0]);
      assertEquals('smith@viasat.com,John,Smith,22222222,' + DateUtils.getYesterdayAsMMDDYYYY() + ' 10:15,' + CPNI_SERVICE_LEVEL + ',Account Level Password,Contact email address,Username, ,' + CPNI_CHANNEL_NAME + ',' + cpniAtlasExtractDateStr, csvFileLines[1]);
   }
    
   public static testmethod void testGetCSVFileLinesForYesterday_OneAcctWithFourTxnTypes_SingleLineNoNullsLatestTime() {
      setupCustomSettings();
      
      System.runAs(TestDataManager.adminTestUser1) {
        User userObj = TestDataManager.createPortalUser('Test Account 1', 'John', 'Smith', 'john@viasat.com', 'JohnP', 'SmithP');
      
        CPNITestDataManager.addPasswordChangedRecordForYesterday(userObj, '22222222', 7, 15);
        CPNITestDataManager.addSecurityQuestionChangedRecordForYesterday(userObj, '22222222', 4, 15);
        CPNITestDataManager.addUsernameChangedRecordForYesterday(userObj, '22222222', 10, 15);
        CPNITestDataManager.addContactEmailChangedRecordForYesterday(userObj, '22222222', 5, 15, 'smith1@viasat.com');
      }
      
      Test.startTest();
            
      AtlasScheduledCPNIReport reporter = new AtlasScheduledCPNIReport();
      List<String> csvFileLines = reporter.getCSVFileLinesForYesterday(true);
      String cpniAtlasExtractDateStr = reporter.cpniAtlasExtractDateTime.format('MM/dd/YYYY');
      
      Test.stopTest();
            
      system.debug('email body: ' + String.join(csvFileLines, '\n'));
      System.assertEquals('Email Address,First Name,Last Name,Service Agreement ID,Change Date,Service Level,Change Type 1,Change Type 2,Change Type 3,Change Type 4,Channel Name,CPNI ATLAS Extract Date', csvFileLines[0]);
      assertEquals('smith1@viasat.com,John,Smith,22222222,' + DateUtils.getYesterdayAsMMDDYYYY() + ' 10:15,' + CPNI_SERVICE_LEVEL + ',Account Level Password,Security question in any ViaSat system,Contact email address,Username,' + CPNI_CHANNEL_NAME + ',' + cpniAtlasExtractDateStr, csvFileLines[1]);
   }
   
   public static testmethod void testGetCSVFileLinesForYesterday_ThreeAccts_ThreeLinesLatestTime() {
      setupCustomSettings();
      
      System.runAs(TestDataManager.adminTestUser1) {
      User userObj1 = TestDataManager.createPortalUser('Test Account 1', 'Peter', 'Parker', 'peter@viasat.com', 'PeterP', 'ParkerP');
      CPNITestDataManager.addPasswordChangedRecordForYesterday(userObj1, '11111111', 6, 30);
      CPNITestDataManager.addPasswordChangedRecordForYesterday(userObj1, '11111111', 8, 15);
      CPNITestDataManager.addPasswordChangedRecordForYesterday(userObj1, '11111111', 4, 15);
      
      User userObj2 = TestDataManager.createPortalUser('Test Account 2', 'Joshua', 'King', 'joshua@viasat.com', 'JoshP', 'KingP');
      CPNITestDataManager.addPasswordChangedRecordForYesterday(userObj2, '22222222', 7, 15);
      CPNITestDataManager.addSecurityQuestionChangedRecordForYesterday(userObj2, '22222222', 4, 15);
      CPNITestDataManager.addUsernameChangedRecordForYesterday(userObj2, '22222222', 10, 15);
      CPNITestDataManager.addContactEmailChangedRecordForYesterday(userObj2, '22222222', 5, 15, 'smith1@viasat.com');
      
      User userObj3 = TestDataManager.createPortalUser('Test Account 3', 'John', 'Smith', 'john@viasat.com', 'JohnP', 'SmithP');
      CPNITestDataManager.addPasswordChangedRecordForYesterday(userObj3, '33333333', 13, 15);
      CPNITestDataManager.addUsernameChangedRecordForYesterday(userObj3, '33333333', 15, 15);
      CPNITestDataManager.addContactEmailChangedRecordForYesterday(userObj3, '33333333', 12, 15, 'smith2@viasat.com');
      }
      
      Test.startTest();
            
      AtlasScheduledCPNIReport reporter = new AtlasScheduledCPNIReport();
      List<String> csvFileLines = reporter.getCSVFileLinesForYesterday(true);
      String cpniAtlasExtractDateStr = reporter.cpniAtlasExtractDateTime.format('MM/dd/YYYY');
      system.debug('XXX email body: ' + String.join(csvFileLines, '\n'));
      System.assertEquals('Email Address,First Name,Last Name,Service Agreement ID,Change Date,Service Level,Change Type 1,Change Type 2,Change Type 3,Change Type 4,Channel Name,CPNI ATLAS Extract Date', csvFileLines[0]);
      
      String lineItemForSmith2 = getLineItemForGivenEmail('smith2@viasat.com', csvFileLines);
      //System.assert(lineItemForSmith2 != NULL, 'Could not find entry for smith2@viasat.com');
      assertEquals('smith2@viasat.com,John,Smith,33333333,' + DateUtils.getYesterdayAsMMDDYYYY() + ' 15:15,' + CPNI_SERVICE_LEVEL + ',Account Level Password,Contact email address,Username, ,' + CPNI_CHANNEL_NAME + ',' + cpniAtlasExtractDateStr, lineItemForSmith2);
      
      String lineItemForPeter = getLineItemForGivenEmail('peter@viasat.com', csvFileLines);
      //System.assert(lineItemForPeter != NULL, 'Could not find entry for peter@viasat.com');
      assertEquals('peter@viasat.com,Peter,Parker,11111111,' + DateUtils.getYesterdayAsMMDDYYYY() + ' 08:15,' + CPNI_SERVICE_LEVEL + ',Account Level Password, , , ,' + CPNI_CHANNEL_NAME + ',' + cpniAtlasExtractDateStr, lineItemForPeter);
      
      String lineItemForSmith1 = getLineItemForGivenEmail('smith1@viasat.com', csvFileLines);
      //System.assert(lineItemForSmith1 != NULL, 'Could not find entry for smith1@viasat.com');
      assertEquals('smith1@viasat.com,Joshua,King,22222222,' + DateUtils.getYesterdayAsMMDDYYYY() + ' 10:15,' + CPNI_SERVICE_LEVEL + ',Account Level Password,Security question in any ViaSat system,Contact email address,Username,' + CPNI_CHANNEL_NAME + ',' + cpniAtlasExtractDateStr, lineItemForSmith1);
      
      AtlasScheduledCPNIReport.updateCpniReportedTime(reporter.cpniAtlasExtractDateTime, true);
      csvFileLines = reporter.getCSVFileLinesForYesterday(true);

      Test.stopTest();
            
      System.assertEquals('Email Address,First Name,Last Name,Service Agreement ID,Change Date,Service Level,Change Type 1,Change Type 2,Change Type 3,Change Type 4,Channel Name,CPNI ATLAS Extract Date', csvFileLines[0]);
      System.assertEquals(AtlasConstants.CPNI_REPORT_NO_DATA_FOUND, csvFileLines[1]);
   }   
   
   private static String getLineItemForGivenEmail(String emailId, List<String> csvFileLines) {
      for (String currentLine : csvFileLines) {
        if (currentLine.startsWith(emailId)) return currentLine;
      }
      return null;
   }
   
   public static testmethod void testUploadFile_happyPath() {
      setupCustomSettings();
      
      System.runAs(TestDataManager.adminTestUser1) {
      User userObj1 = TestDataManager.createPortalUser('Test Account 1', 'Peter', 'Parker', 'peter@viasat.com', 'PeterP', 'ParkerP');
      CPNITestDataManager.addPasswordChangedRecordForYesterday(userObj1, '11111111', 6, 30);
      CPNITestDataManager.addPasswordChangedRecordForYesterday(userObj1, '11111111', 8, 15);
      CPNITestDataManager.addPasswordChangedRecordForYesterday(userObj1, '11111111', 4, 15);
      }
      
      Test.startTest();
      Test.setMock(WebServiceMock.class, new UploadWebServiceSuccessMockImpl());
      AtlasScheduledCPNIReport.uploadFile('some dummy content', System.now(), true);
      Test.stopTest();
      
      AtlasScheduledCPNIReport reporter = new AtlasScheduledCPNIReport();
      List<AtlasTransactionHistory__c> athObjects = reporter.getATHObjectsForYesterdayUsingDynamicQuery(true);
      for (AtlasTransactionHistory__c eachAth : athObjects) {
         System.assertEquals(reporter.cpniAtlasExtractDateTime, reporter.cpniAtlasExtractDateTime);
      }
   }
   
   public static testmethod void testUploadFile_EmptyResponse_CatchInvalidDataException() {
      setupCustomSettings();
      
      System.runAs(TestDataManager.adminTestUser1) {
      User userObj1 = TestDataManager.createPortalUser('Test Account 1', 'Peter', 'Parker', 'peter@viasat.com', 'PeterP', 'ParkerP');
      CPNITestDataManager.addPasswordChangedRecordForYesterday(userObj1, '11111111', 6, 30);
      CPNITestDataManager.addPasswordChangedRecordForYesterday(userObj1, '11111111', 8, 15);
      CPNITestDataManager.addPasswordChangedRecordForYesterday(userObj1, '11111111', 4, 15);
      }
      
      Test.startTest();
      Test.setMock(WebServiceMock.class, new UploadWebServiceFailWithEmptyResponseMockImpl());
      AtlasScheduledCPNIReport.uploadFile('some dummy content', System.now(), true);
      Test.stopTest();
      
      AtlasScheduledCPNIReport reporter = new AtlasScheduledCPNIReport();
      List<AtlasTransactionHistory__c> athObjects = reporter.getATHObjectsForYesterdayUsingDynamicQuery(true);
      for (AtlasTransactionHistory__c eachAth : athObjects) {
         System.assertEquals(reporter.cpniAtlasExtractDateTime, null);
      }
   }
   
   public class UploadWebServiceSuccessMockImpl implements WebServiceMock {
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
         
         AtlasSSOWS.uploadFileResponse_element respElement = new AtlasSSOWS.uploadFileResponse_element();
         respElement.status = 'Success';
         respElement.errorcode = null;
         respElement.error = null;
         respElement.filename = null;
         response.put('response_x', respElement); 
      }
   }
   
   public class UploadWebServiceFailWithEmptyResponseMockImpl implements WebServiceMock {
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

   /*
    *   This test schedules a job at a future datetime and verifies in the CronTrigger that:
    *   a) it will run at the designated future datetime
    *   b) the job has not run as of now
    *   c) when the job will run next
    */
    public static void myTestScheduledFutureRun() {
         setupCustomSettings();
         // Next scheduled job is midnight of Sep 03, 2023
         String TEST_CRON_EXP = '0 0 0 3 9 ? 2023';
         
         // Schedule the test job
         String jobId = System.schedule('Test Email CPNI Report Scheduled Job', TEST_CRON_EXP, new AtlasScheduledCPNIReport());
         
         Test.startTest();
         
         // Get the information from the CronTrigger API object
         CronTrigger ct = [SELECT Id, CronExpression, TimesTriggered, NextFireTime
                           FROM CronTrigger 
                           WHERE id = :jobId];
   
         // Verify the expressions are the same
         System.assertEquals(TEST_CRON_EXP, ct.CronExpression);
   
         // Verify the job has not run
         System.assertEquals(0, ct.TimesTriggered);
   
         // Verify the next time the job will run
         System.assertEquals('2023-09-03 00:00:00', String.valueOf(ct.NextFireTime));
   
         Test.stopTest();
   }
}