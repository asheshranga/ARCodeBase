/***********************************************************************************************************
Name          : CPNITestDataManager
Created By    : Sujit Kumar
Company Name  : NTT Data
Project       : ViaSat Atlas
Created Date  : 12 May, 2014
Modified Date : 12 June, 2014
Description   : This class provides test data specific to the AtlasScheduledCPNIReportTest class.
************************************************************************************************************/
public with sharing class CPNITestDataManager {

   public static void addPasswordChangedRecordForYesterday(User userObj, 
                                                            String internalServiceAgreementId, 
                                                            Integer hours, 
                                                            Integer minutes) {
   	addAtlasTxnHistoryRecordForYesterday(userObj, internalServiceAgreementId, hours, minutes, 
   	                                      'Account Level Password');
   }
   
   public static void addSecurityQuestionChangedRecordForYesterday(User userObj,
                                                            String internalServiceAgreementId, 
                                                            Integer hours, 
                                                            Integer minutes) {
      addAtlasTxnHistoryRecordForYesterday(userObj, internalServiceAgreementId, hours, minutes, 
                                             'Security question in any ViaSat system');
   }
   
   public static void addUsernameChangedRecordForYesterday(User userObj, 
                                                            String internalServiceAgreementId, 
                                                            Integer hours, 
                                                            Integer minutes) {
      addAtlasTxnHistoryRecordForYesterday(userObj, internalServiceAgreementId, hours, minutes, 
                                             'Username');
   }
   
   public static void addContactEmailChangedRecordForYesterday(User userObj, 
                                                            String internalServiceAgreementId, 
                                                            Integer hours, 
                                                            Integer minutes,
                                                            String previousEmailAddress) {
      addAtlasTxnHistoryRecordForYesterday(userObj, internalServiceAgreementId, hours, minutes, 
                                             'Contact email address', previousEmailAddress);
   }
   
   public static void addAtlasTxnHistoryRecordForYesterday(User userObj, 
                                                            String internalServiceAgreementId, 
                                                            Integer hours, 
                                                            Integer minutes,
                                                            String txnType) {
      addAtlasTxnHistoryRecordForYesterday(userObj, internalServiceAgreementId, hours, minutes, txnType, null);
   }
   
   public static void addAtlasTxnHistoryRecordForYesterday(User userObj, 
                                                            String internalServiceAgreementId, 
                                                            Integer hours, 
                                                            Integer minutes,
                                                            String txnType,
                                                            String previousEmailAddress) {
      AtlasTransactionHistory__c athRecord = new AtlasTransactionHistory__c();
      athRecord.InternalServiceAgreementId__c = internalServiceAgreementId;
      athRecord.customerName__c = userObj.Id;
      athRecord.Created_Date_For_Unit_Tests_Only__c = DateUtils.getYesterday(hours, minutes, 0);
      athRecord.CPNIReportedTime__c = null;
      athRecord.transactionStatus__c = 'Success';
      athRecord.transactionType__c = txnType;
      athRecord.PreviousEmailAddress__c = previousEmailAddress;
      insert athRecord;
   }
   
}