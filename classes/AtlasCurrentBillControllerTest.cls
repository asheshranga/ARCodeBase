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
private class AtlasCurrentBillControllerTest {
    
    static testMethod void testAtlasCurrentBillCon() {
        
        AtlasTestMainClass.setTestKeyValueStoreForAtlas();
        AtlasTestMainClass.createCommunityUser();
        
        AtlasKeyValueStore__c admin = new AtlasKeyValueStore__c();
        admin.name = 'Admin Profiles';
        admin.Code__c = 'Admin Profiles';
        admin.Value__c = '00e70000001BevC,00e700000012xyd,00e70000001BVka,00e70000001BVkV,00e70000001BVUc,00e70000001BVkk,00e70000001BVkL,00e70000001BWAn,00e70000001BVkf,00e70000001BVkQ,00e70000001Bfj2,00e70000001BfxY';
        insert admin;
        
        Test.startTest();
        
        Pagereference pg = Page.currentbill;
        Test.setCurrentPage(pg); 
        
        AtlasCurrentBillController acbCont = new AtlasCurrentBillController();
        acbCont.printInvoice();
        acbCont.loadInvoiceDetails();
        acbCont.paginationForCDRDetails();
        acbCont.callRemoteAtlasDashboardData();
        acbCont.currentDataUsageAtlasDashboardData();
        acbCont.myAccountAtlasDashboardData();
        acbCont.billingSnapshotAtlasDashboardData();
        acbCont.currentPaymentSettingsCurrentBillPage();
        acbCont.getCDRInfoList();
        acbCont.fetchInvoiceCDRDetails();
        acbCont.previousPage();
        acbCont.nextPage();
        acbCont.updatePage();
        acbCont.changeData();
        Test.stopTest();
        
        
        
    }
    
    @isTest(seeAllData = true)
    static void testVariables()
    {
        Test.startTest();
        
        Pagereference pg = Page.currentbill;
        Test.setCurrentPage(pg); 
        
        AtlasCurrentBillController acbCont = new AtlasCurrentBillController();
        
        System.assertnotequals(null, acbCont.strBillPaymentURL);
        System.assertnotequals(null, acbCont.strViewCurrentBillURL);
        System.assertnotequals(null, acbCont.strBillingHistoryURL);
        System.assertnotequals(null, acbCont.strVoicePkgCharge);
        System.debug(acbCont.strDetailsURL);
        System.assertnotequals(null, acbCont.strNoThanksURL);
        System.assertnotequals(null, acbCont.strConfirmURL);
        System.assertnotequals(null, acbCont.strDashboardUrl);
        
        // Initialinzing Usage page GlobalVariables HyperLinkText 
        System.assertnotequals(null, acbCont.strBillPaymentText);
        System.assertnotequals(null, acbCont.strViewCurrentBillText);
        System.assertnotequals(null, acbCont.strBillingHistoryText);
        System.debug(acbCont.strDetailsText);
        System.assertnotequals(null, acbCont.strNoThanksText);
        System.assertnotequals(null, acbCont.strConfirmText);
        System.assertnotequals(null, acbCont.strDashboardText);
        
        // Initialinzing Usage page GlobalVariables HyperLinkVisibility    
        System.assertnotequals(null, acbCont.isVisibleBillPayment);
        System.assertnotequals(null, acbCont.isVisibleViewCurrentBill);
        System.assertnotequals(null, acbCont.isVisibleBillingHistory);
        System.debug(acbCont.isVisibleDetails);
        System.assertnotequals(null, acbCont.isVisibleNoThanks);
        System.assertnotequals(null, acbCont.isVisibleConfirm);
        System.assertnotequals(null, acbCont.isVisibleDashboard);
        
        // Variables used in CurrentBill.page
        System.assertnotequals(null, acbCont.strTitle);
        System.assertnotequals(null, acbCont.strHeader2);
        System.debug(acbCont.StrCity);
        System.debug(acbCont.strUpdateState);
        
        System.debug(acbCont.BillingAdrsText);
        System.debug(acbCont.ServiceAdrsText);
        System.debug(acbCont.AccountNumberText);
        System.debug(acbCont.DueDateText);
        System.debug(acbCont.AmountText);
        System.debug(acbCont.OneTimePaymentText);
        System.debug(acbCont.ThankYouText);
        System.debug(acbCont.SuccessFulPaymentText);
        System.debug(acbCont.showDisclaimerText);
        
        
        System.debug(acbCont.paginater);
        System.debug(acbCont.billList);
        System.debug(acbCont.allBillList);
        System.debug(acbCont.exceptionForCDR);
        System.debug(acbCont.close);
        System.debug(acbCont.exedeViocelabel);
        System.debug(acbCont.loadingLabel);
        System.debug(acbCont.manageVoiceAccount);
        System.debug(acbCont.cdrInfoUnavailable);
        System.debug(acbCont.datetime_CDR);
        System.debug(acbCont.calledNo_CDR);
        System.debug(acbCont.location_CDR);
        System.debug(acbCont.duration_CDR);
        System.debug(acbCont.amount_CDR);
        
        System.debug(acbCont.subFooterText1 );
        System.debug(acbCont.exedeCustomerSupportUrl );
        System.debug(acbCont.exedeCustomerSupportHyperlinkText );
        System.debug(acbCont.subFooterText2 );
        
        System.debug(acbCont.hide_Details);
        
        System.debug(acbCont.currentBillData );
    }
    
}