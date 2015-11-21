/***********************************************************************************************************
Name          : AtlasScheduledCPNIReport
Created By    : Sujit Kumar
Company Name  : NTT Data
Project       : ViaSat Atlas
Created Date  : 15 May, 2014
Modified Date : 9 June, 2014
Description   : This will be run as a nightly scheduled job that will generate a CSV file.
                The CSV file will contain all changes to Customer Accounts that happened the day before.
                The CSV file is uploaded via a web service and also emailed to a specified email address.
                The CSV file will contain comma separated records as described in the requirements document.
************************************************************************************************************/
global with sharing class AtlasScheduledCPNIReport implements Schedulable {
      
      public DateTime cpniAtlasExtractDateTime { get; set; }
      public String exedeApplication{get{return AtlasConstants.Exede_application;}set;}
      public String wildBlueApplication{get{return AtlasConstants.Wildblue_application;}set;}
      
      global void execute(SchedulableContext sc) {
         System.debug(logginglevel.INFO, 'In execute of AtlasScheduledCPNIReport ...');
         List<String> csvFileLines = getCSVFileLinesForYesterday();
         String csvFileContent = String.join(csvFileLines, '\n');
         System.debug(logginglevel.INFO, 'csv file content: ' + csvFileContent);
         AtlasScheduledCPNIReport.uploadFile(csvFileContent, cpniAtlasExtractDateTime, false);
      }
      
      /*
       * upload file using web service.
       * Callouts cannot be made in a scheduled job, hence it needs to be a future method.
       */
      @future(callout=true)
      public static void uploadFile(String csvFileContent, DateTime cpniExtractTime, Boolean isTest) {
         String fileName = 'CPNI_Change_Notification_Atlas_Report_' + cpniExtractTime.format('YYYYMMdd') + '.csv';
         Boolean fileUploadSuccess = true;
         try {
            AtlasIntegrationUtility.uploadFile(fileName, csvFileContent);
         } 
         catch (AtlasException.InvalidDataException invalidEx) {
            System.debug(logginglevel.ERROR, invalidEx.errorMessage);
            fileUploadSuccess = false;
         }
         catch (AtlasException.CalloutException calloutEx) {
            System.debug(logginglevel.ERROR, calloutEx.errorMessage);
            fileUploadSuccess = false;
         }
         if(fileUploadSuccess) {
            AtlasScheduledCPNIReport.updateCpniReportedTime(cpniExtractTime, isTest);
            AtlasScheduledCPNIReport.sendEmail(csvFileContent, true);
         } else {
            AtlasScheduledCPNIReport.sendEmail(csvFileContent, false);
         }
      }
      
      /*
       * Update CPNIReportedTime__c column to current date and time
       */
      public static void updateCpniReportedTime(DateTime cpniExtractTime, boolean isTest) {
        AtlasScheduledCPNIReport reporter = new AtlasScheduledCPNIReport();
         List<AtlasTransactionHistory__c> athObjects = reporter.getATHObjectsForYesterdayUsingDynamicQuery(isTest);
         for (AtlasTransactionHistory__c eachAth : athObjects) {
            // system.debug('before update time: ' + eachAth.CPNIReportedTime__c);
            eachAth.CPNIReportedTime__c = cpniExtractTime;
         }
         update athObjects;
      }

      /*
       * Get all AtlasTransactionHistory__c for yesterday. 
       * These records haven't been reported as yet and their txn status is success.
       * Sort by cust name followed by txn type desc and created date desc
       */
      public List<AtlasTransactionHistory__c> getATHObjectsForYesterdayUsingDynamicQuery(Boolean isTest) {
         List<AtlasTransactionHistory__c> allAthRecords;
         String reportTimeFrame =  AtlasUtility.getMapValue(AtlasConstants.CPNI_REPORT_TIME_FRAME);
         
         String retrieveAthRecordsQuery = 'SELECT  CustomerName__r.Contact.Name, RecordType.Name, CustomerName__r.Contact.Email, '; 
         retrieveAthRecordsQuery += ' InternalServiceAgreementId__c, TransactionStatus__c, TransactionType__c, CPNIReportedTime__c, PreviousEmailAddress__c,  '; 
         if (!isTest) {
            retrieveAthRecordsQuery += ' CreatedDate ';
         } else {
            retrieveAthRecordsQuery += ' CreatedDateForUnitTestsOnly__c ';
         }  
         retrieveAthRecordsQuery += ' FROM AtlasTransactionHistory__c ';
         retrieveAthRecordsQuery += ' WHERE CPNIReportedTime__c = null';
         retrieveAthRecordsQuery += ' and RecordType.Name in (\'' + exedeApplication + '\')';                   
         if (!isTest) {
            retrieveAthRecordsQuery += ' and CreatedDate = ' + reportTimeFrame;
         } else {
            retrieveAthRecordsQuery += ' and CreatedDateForUnitTestsOnly__c = ' + reportTimeFrame;
         }                   
         retrieveAthRecordsQuery += ' and TransactionStatus__c = \'Success\' ';
         retrieveAthRecordsQuery += ' and (';
         
         // Add CPNI txn types to the query
         for (Integer i = 0; i < AtlasConstants.CPNI_REPORT_TXN_TYPES.size(); ++i) {
            String eachTxnType = AtlasUtility.getMapValue(AtlasConstants.CPNI_REPORT_TXN_TYPES.get(i));
            retrieveAthRecordsQuery += '(TransactionType__c = ' + '\'' + eachTxnType + '\')';
            if (i < (AtlasConstants.CPNI_REPORT_TXN_TYPES.size() - 1)) {
                retrieveAthRecordsQuery += ' or ';
            }
         }
         retrieveAthRecordsQuery += ') ';
         retrieveAthRecordsQuery += ' ORDER BY InternalServiceAgreementId__c, transactionType__c, ';
         if (!isTest) {
            retrieveAthRecordsQuery += ' CreatedDate desc ';
         } else {
            retrieveAthRecordsQuery += ' CreatedDateForUnitTestsOnly__c desc ';
         }   
         // System.debug('retrieveAthRecordsQuery: ' + retrieveAthRecordsQuery);
         return Database.query(retrieveAthRecordsQuery);
      }
      
      global List<String> getCSVFileLinesForYesterday() {
        return getCSVFileLinesForYesterday(false);
      }
     
      /*
       *  Generate the body of the CSV report that is sent out as an email notification.
       *  The boolean parameter isTest is used by unit tests only.
       */
      global List<String> getCSVFileLinesForYesterday(Boolean isTest) {
      
        List<AtlasTransactionHistory__c> athObjects = getATHObjectsForYesterdayUsingDynamicQuery(isTest);
        cpniAtlasExtractDateTime = System.now();
        String cpniAtlasExtractDate = cpniAtlasExtractDateTime.format('MM/dd/YYYY');
      
        List<AtlasTransactionHistory__c> athObjsWithMostRecentTxnForEachCustAndTxnType = getMostRecentTxnForEachCustAndTxnType(athObjects);
      
        List<String> listOfLinesInCsvFile = new List<String>();
        listOfLinesInCsvFile.add(getCsvHeader());
      
        if (athObjsWithMostRecentTxnForEachCustAndTxnType.size() == 0) {
           listOfLinesInCsvFile.add(AtlasConstants.CPNI_REPORT_NO_DATA_FOUND);
           return listOfLinesInCsvFile;
        } 
         
        Map<String, List<AtlasTransactionHistory__c>> mapCustToListOfTxns = getMapOfCustToListOfTxns(athObjsWithMostRecentTxnForEachCustAndTxnType);
                          
        for (String eachAcctRefNum : mapCustToListOfTxns.keySet()) {
            List<AtlasTransactionHistory__c> listOfTxnsForCust = mapCustToListOfTxns.get(eachAcctRefNum);
            AtlasTransactionHistory__c firstAthObj = listOfTxnsForCust.get(0);
            String currLineInCsvFile = getEmailAddress(listOfTxnsForCust) + AtlasConstants.CPNI_REPORT_FIELD_DELIMITER;
            currLineInCsvFile += parseAndStoreFirstAndLastNames(firstAthObj.customerName__r.Contact.Name);
            currLineInCsvFile += firstAthObj.InternalServiceAgreementId__c + AtlasConstants.CPNI_REPORT_FIELD_DELIMITER;
            currLineInCsvFile += getMostRecentTimeOfTxnsOfGivenCust(listOfTxnsForCust, isTest) + AtlasConstants.CPNI_REPORT_FIELD_DELIMITER;
            String serviceLevel = AtlasUtility.getMapValue(AtlasConstants.CPNI_SERVICE_LEVEL);
            currLineInCsvFile += serviceLevel + AtlasConstants.CPNI_REPORT_FIELD_DELIMITER;
            List<String> txnNamesForCust = getTxnNamesForGivenCust(listOfTxnsForCust);
            currLineInCsvFile += String.join(txnNamesForCust, AtlasConstants.CPNI_REPORT_FIELD_DELIMITER);
            if (txnNamesForCust.size() < AtlasConstants.CPNI_REPORT_TXN_TYPES.size()) {
               currLineInCsvFile += AtlasConstants.CPNI_REPORT_FIELD_DELIMITER;
            }
            currLineInCsvFile += padUpWithNullColumnValuesAtEnd(txnNamesForCust.size());
            currLineInCsvFile += AtlasUtility.getMapValue(AtlasConstants.CPNI_CHANNEL_NAME);
            currLineInCsvFile += AtlasConstants.CPNI_REPORT_FIELD_DELIMITER;
            currLineInCsvFile += cpniAtlasExtractDate;
            System.debug('each csv line: ' + currLineInCsvFile);
            listOfLinesInCsvFile.add(currLineInCsvFile);
        } // end of for loop iterating over all customers
        return listOfLinesInCsvFile;
      }
      
      private String getEmailAddress(List<AtlasTransactionHistory__c> listOfTxnsForCust) {
         AtlasTransactionHistory__c firstAthObj = listOfTxnsForCust.get(0);
         String emailAddress = firstAthObj.customerName__r.Contact.Email;
         System.debug('curr email address: ' + emailAddress);
         for (AtlasTransactionHistory__c eachAth : listOfTxnsForCust) {
            if (!AtlasUtility.isEmpty(eachAth.PreviousEmailAddress__c)) {
                emailAddress = eachAth.PreviousEmailAddress__c;
                System.debug('using previous email address: ' + emailAddress);
            }
         }
         return emailAddress;
      }
      
      private List<String> getTxnNamesForGivenCust(List<AtlasTransactionHistory__c> listOfTxnsForCust) {
         List<String> listOfTxnNames = new List<String>();
         for (AtlasTransactionHistory__c eachAth : listOfTxnsForCust) {
            listOfTxnNames.add(eachAth.transactionType__c);
         }
         return listOfTxnNames;
      }
      
      private String getMostRecentTimeOfTxnsOfGivenCust(List<AtlasTransactionHistory__c> listOfTxnsForCust, boolean isTest) {
         DateTime mostRecentTime = DateUtils.GetDateAnYearBack();
         for (AtlasTransactionHistory__c eachAth : listOfTxnsForCust) {
            // Unit tests need createdDate to be set, but it is a read-only field
            // Use a custom field for unit tests to allow setting it in the tests
            DateTime txnDateTime = isTest ? eachAth.CreatedDateForUnitTestsOnly__c : eachAth.CreatedDate;
            if (txnDateTime > mostRecentTime) {
               mostRecentTime = txnDateTime;
            }
         }
         return mostRecentTime.format('MM/dd/YYYY HH:mm', 'America/Los_Angeles');
      }
      
      /*
       * Add NULL values at the end if less than the required number of txn types.
       * The number of txn types are generated dynamically
       */
      private String padUpWithNullColumnValuesAtEnd(Integer countOfTxnsForACust) {
         String nullsAtEnd = '';
         if (countOfTxnsForACust == AtlasConstants.CPNI_REPORT_TXN_TYPES.size()) {
            nullsAtEnd += AtlasConstants.CPNI_REPORT_FIELD_DELIMITER;
            return nullsAtEnd;
         } 
         for (Integer i = countOfTxnsForACust; i < AtlasConstants.CPNI_REPORT_TXN_TYPES.size(); ++i) {
            nullsAtEnd += ' ' + AtlasConstants.CPNI_REPORT_FIELD_DELIMITER;
         }
         return nullsAtEnd;
      }
     
      /*
       *  Parse the full name on a space character and store as comma sep first and last names
       */
      private String parseAndStoreFirstAndLastNames(String fullName) {
        String commaSepFirstAndLastNames = '';
         if (!String.isEmpty(fullName)) {
            String[] namesArray = fullName.split(' ');
            if (namesArray.size() > 1) {
                commaSepFirstAndLastNames += namesArray[0] + AtlasConstants.CPNI_REPORT_FIELD_DELIMITER;
                commaSepFirstAndLastNames += namesArray[1] + AtlasConstants.CPNI_REPORT_FIELD_DELIMITER;
            } else if (namesArray.size() == 1) {
                commaSepFirstAndLastNames += namesArray[0] + AtlasConstants.CPNI_REPORT_FIELD_DELIMITER;
                commaSepFirstAndLastNames += AtlasConstants.CPNI_REPORT_FIELD_DELIMITER;
            }
         } else {
            commaSepFirstAndLastNames += AtlasConstants.CPNI_REPORT_FIELD_DELIMITER;
            commaSepFirstAndLastNames += AtlasConstants.CPNI_REPORT_FIELD_DELIMITER;
         }
         return commaSepFirstAndLastNames;
      }
      
      /*
       * Get header row of generated CSV file, txn types appear as change types and the 
       * number of txn types are generated dynamically
       */
      private String getCsvHeader() {
         String csvHeaderLine = 'Email Address,First Name,Last Name,Service Agreement ID,Change Date,Service Level,';
         for (Integer i = 1; i < (AtlasConstants.CPNI_REPORT_TXN_TYPES.size() + 1); ++i) {
            csvHeaderLine += 'Change Type ' + i + AtlasConstants.CPNI_REPORT_FIELD_DELIMITER;
         }
         csvHeaderLine += 'Channel Name,CPNI ATLAS Extract Date';
         return csvHeaderLine;
      }
      
      /*
       * For a given customer and given txn type, if there are multiple txn entries for same date,
       * use the most recent one.
       */
      private  List<AtlasTransactionHistory__c> getMostRecentTxnForEachCustAndTxnType(List<AtlasTransactionHistory__c> athObjects) {
         String prevCustomerName = null;
         String prevTxnType = null;
         List<AtlasTransactionHistory__c> listOfMostRecentTxnsForGivenCustAndTxnType;
         listOfMostRecentTxnsForGivenCustAndTxnType = new List<AtlasTransactionHistory__c>();
         for (AtlasTransactionHistory__c eachAthObject : athObjects) {
            String currCustomerName = eachAthObject.InternalServiceAgreementId__c;
            String currTxnType = eachAthObject.TransactionType__c;
            // system.debug('ZZ currCustomerName: ' + currCustomerName);
            // system.debug('ZZ currTxnType: ' + currTxnType);
            if (currCustomerName != null && currTxnType != null) {
               if (currCustomerName.equalsIgnoreCase(prevCustomerName) && currTxnType.equalsIgnoreCase(prevTxnType)) {
                  if (currTxnType.equalsIgnoreCase(AtlasUtility.getMapValue(AtlasConstants.CPNI_CONTACT_EMAIL))) {
                    // for contact email change txn type, remove the last entry and add this, we want the oldest record 
                    Integer lastElementIndex = listOfMostRecentTxnsForGivenCustAndTxnType.size() - 1;
                    AtlasTransactionHistory__c ath = listOfMostRecentTxnsForGivenCustAndTxnType.get(lastElementIndex);
                    System.debug('Discarding ath record with previous email id: ' + ath.PreviousEmailAddress__c);
                    listOfMostRecentTxnsForGivenCustAndTxnType.remove(lastElementIndex);
                    System.debug('Adding ath record with previous email id: ' + eachAthObject.PreviousEmailAddress__c);
                    listOfMostRecentTxnsForGivenCustAndTxnType.add(eachAthObject);
                  } else {
                    // for all other txn types, ignore the current one as it is not the most recent one, we want the most recent one
                  }
               } else {
                  System.debug('Adding ath record with curr email id: ' + eachAthObject.customerName__r.Contact.Email + ', prev email id: ' + eachAthObject.PreviousEmailAddress__c);
                  listOfMostRecentTxnsForGivenCustAndTxnType.add(eachAthObject);
               }
               prevCustomerName = currCustomerName;
               prevTxnType = currTxnType;
            }
         }
         return listOfMostRecentTxnsForGivenCustAndTxnType;
      }
      
      /*
       * if for a given customer, if there are multiple txn types for same date,
       * store them in a map with key as: ExternalReferenceNum
       * and value as: list of txns for that customer in the previous 24 hour period
       */
      private  Map<String, List<AtlasTransactionHistory__c>> getMapOfCustToListOfTxns(
               List<AtlasTransactionHistory__c> athObjsWithMostRecentTxnForEachCustAndTxnType) {
                
        Map<String, List<AtlasTransactionHistory__c>> myMap = new Map<String, List<AtlasTransactionHistory__c>>();
         for (AtlasTransactionHistory__c eachAthObject : athObjsWithMostRecentTxnForEachCustAndTxnType) {
             String key = eachAthObject.InternalServiceAgreementId__c;
             List<AtlasTransactionHistory__c> listOfTxnsForGivenCustomer = myMap.get(key);
             if (listOfTxnsForGivenCustomer != null) {
                 listOfTxnsForGivenCustomer.add(eachAthObject);
             } else {
                 listOfTxnsForGivenCustomer = new List<AtlasTransactionHistory__c>();
                 listOfTxnsForGivenCustomer.add(eachAthObject);
                 myMap.put(key, listOfTxnsForGivenCustomer);
             }
         }
         return myMap;
      }
      
      /*
       *  Send email using SFDC
       *
       */
      private static void sendEmail(String plainTextBody, Boolean uploadStatus) {
         String subject = AtlasConstants.CPNI_REPORT_EMAIL_SUBJECT;
         if (uploadStatus) {
            subject += ' Upload SUCCESSFUL!';
         } else {
            subject += ' Upload FAILED!';
         }
         String commaSepEmailIds = AtlasUtility.getMapValue(AtlasConstants.CPNI_REPORT_EMAIL_ID);
         if (!AtlasUtility.isEmpty(commaSepEmailIds)) {
             String[] toAddresses = commaSepEmailIds.split(',');
             if (toAddresses.size() > 0) {
                 Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();  
                 mail.setToAddresses(toAddresses);  
                 mail.setSubject(subject);
                 mail.setPlainTextBody(plainTextBody);
                Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
             }
         } 
      }

      /* ----------------------------------------------------------------------------
          How to programmatically set up a schedule?
          AtlasScheduledCPNIReport schCPNIReport = new AtlasScheduledCPNIReport();
          // Seconds Minutes Hours Day_of_month Month Day_of_week optional_year
          String dailyCPNIReportSchedule = '0 12 10 20  5 ?';
          System.schedule('Email CPNI Reports Job', dailyCPNIReportSchedule, schCPNIReport);
      */
      
      /* ----------------------------------------------------------------------------
       * Get all AtlasTransactionHistory__c for yesterday. 
       * These records haven't been reported as yet and their txn status is success.
       * Sort by cust name followed by txn type desc and created date desc
       * Not used anymore, just left for reference. Look at the other private method which
       * generates the query dynamically
       */
       
      /*
      private  List<AtlasTransactionHistory__c> getAtlasTransactionHistoryObjectsForYesterday(Boolean isTest) {
        List<AtlasTransactionHistory__c> allAthRecords;
        string reportTimeFrame =  AtlasUtility.getMapValue(AtlasConstants.CPNI_REPORT_TIME_FRAME);
        
        if (!isTest) {
          allAthRecords = [SELECT  CustomerName__r.Name, 
                                        CustomerName__r.Email, 
                                        CreatedDate, 
                                        InternalServiceAgreementId__c, 
                                        TransactionStatus__c, 
                                        TransactionType__c, 
                                        CPNIReportedTime__c, 
                                        PreviousEmailAddress__c,  
                                  FROM AtlasTransactionHistory__c 
                                  WHERE CPNIReportedTime__c = null 
                                  and CreatedDate = :reportTimeFrame 
                                  and TransactionStatus__c = 'Success'
                                  and ((TransactionType__c = 'Account Level Password') or 
                                      (TransactionType__c = 'Security question in any ViaSat system') or
                                      (TransactionType__c = 'Primary email address/username') or 
                                      (TransactionType__c = 'Contact email address'))
                                  ORDER BY InternalServiceAgreementId__c, 
                                           transactionType__c,
                                           CreatedDate desc];
        } else {
           allAthRecords = [SELECT  CustomerName__r.Name, 
                                        CustomerName__r.Email, 
                                        CreatedDateForUnitTestsOnly__c, 
                                        InternalServiceAgreementId__c, 
                                        TransactionStatus__c, 
                                        TransactionType__c, 
                                        CPNIReportedTime__c 
                                  FROM AtlasTransactionHistory__c 
                                  WHERE CPNIReportedTime__c = null 
                                  and CreatedDateForUnitTestsOnly__c = :reportTimeFrame
                                  and TransactionStatus__c = 'Success'
                                  and ((TransactionType__c = 'Account Level Password') or 
                                      (TransactionType__c = 'Security question in any ViaSat system') or
                                      (TransactionType__c = 'Primary email address/username') or 
                                      (TransactionType__c = 'Contact email address'))
                                  ORDER BY InternalServiceAgreementId__c, 
                                           TransactionType__c];
                                           CreatedDateForUnitTestsOnly__c desc];           
        }
        // System.debug('XX CPNI report number of records found: ' + allAthRecords.size());
        return allAthRecords;
      }
      */
}