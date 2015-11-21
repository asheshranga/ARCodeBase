/**
 * This class contains unit tests for validating the behavior of All SNG Controllers 
 */
@isTest
private class SNGTest2 {

    //**********************************************************
    // TEST SNGModemDetail (SNGModemDetailUnitTest)
    //**********************************************************
    static testMethod void testSNGModemDetail() { 
        SNG_MockCustomSettings.initialize();

        // create a modem that has a terminal with a valid terminal type
        Modem__c modem = SNG_TestUtilities.insertModem('00:A0:BC:29:df:59', '3', true); 
        // set the software version
        modem.SoftwareVersion__c = 'test'; 
        update(modem); 
        
        System.debug('initial software version ' + modem);
        System.assert(modem.SoftwareVersion__c == 'test'); 

        // create an active service plan 
        ServicePlan__c servicePlan = SNG_TestUtilities.insertServicePlan(modem.Account__r, true); 
        // create MSP
        ModemServicePlan__c msp = SNG_TestUtilities.insertModemServicePlan(modem, servicePlan); 
        
        Test.startTest();
               
        // set a page reference to an instantiation of SNGModemDetail page
        PageReference pageRef = Page.SNGModemDetail; 
        Test.setCurrentPage(pageRef); 
        ApexPages.currentPage().getParameters().put('id', modem.Id);

        // Initialize the controller for SNGModemDetail
        ApexPages.StandardController stdController = new ApexPages.StandardController(modem);
        SNGModemDetail customController = new SNGModemDetail(stdController); 
        
        customController.relatedModemServicePlans.isEmpty();
        
        // There should only be 1 MSP in the list 
        System.assert( (customController.relatedModemServicePlans.size() == 1) ); 
        
        System.debug(msp); 
        System.debug(servicePlan); 
        System.debug('modem test ' + modem);  

        customController.updateVersion(); 

        Test.stopTest();  
        
        modem = [SELECT SoftwareVersion__c FROM Modem__c WHERE Id = :modem.Id]; 
        
        System.assert(modem.SoftwareVersion__c != 'test');  
    }
    
    //**********************************************************
    // TEST SNGModemHistory (SNGModemHistoryUnitTest)
    //**********************************************************
    static testMethod void testSNGModemHistory()
    {
       Modem__c modem = SNG_TestUtilities.insertEquipment(true);
       modem.SerialNumber__c = 'Test';
       update modem;
       
       Test.startTest();

       Modem__History tempHist = new Modem__History();
       
		ApexPages.StandardController sc = new ApexPages.StandardController(modem);
		SNGModemHistory history = new SNGModemHistory(sc);

        history.showMore();

       history.historyQuery = new SNGMockModemHistoryQuery();
       
       history.PageSize = 0; 
       List<SNGModemHistory.ModemHistory> historyList = history.modemObjectHistories;
       System.assertEquals(1, historyList.size()); 
       System.assertEquals('Created.', historyList[0].ActionFormat);       
    
        //testGetObjectHistoryLookupFieldSkip()
       history.PageSize = 1; 
       historyList = history.modemObjectHistories;
       System.assertEquals(1, historyList.size()); 
       System.assertEquals('Changed <b>{1}</b> to <b>{3}</b>.', historyList[0].ActionFormat);  
    
        //testGetObjectHistoryOn2Updates()
       history.PageSize = 2; 
       historyList = history.modemObjectHistories;
       System.assertEquals(2, historyList.size()); 
       System.assertEquals('Changed <b>{1}</b> to <b>{3}</b>.', historyList[0].ActionFormat);  
       System.assertEquals('Changed <b>{1}</b> from <b>{2}</b> to <b>{3}</b>.', historyList[1].ActionFormat);
    
        //testMethod void testModemHistoryCtorEmpty()
        SNGModemHistory.ModemHistory history1 = new SNGModemHistory.ModemHistory();
        System.assertEquals(true, history1.ShowDateAndUser);
        Test.stopTest();
    }
    
    //**********************************************************
    // TEST SNGServicePlanDetail (SNGServicePlanDetailUnitTest)
    //**********************************************************
    private static final decimal ONE_GIGABYTE_IN_BYTES = 1073741824;

    static testMethod void testSNGServicePlanDetail() 
    { 
        SNG_MockCustomSettings.initialize();
        
        Account a = SNG_TestUtilities.insertAccount('testAccount');
        ServicePlan__c sp0 = SNG_TestUtilities.constructServicePlan(a, SNG_TestUtilities.insertServicePlanType(true), '1');      
        insert sp0;

        Account acct = SNG_TestUtilities.insertAccount('Red Cross');
        ServicePlan__c sp = SNG_TestUtilities.constructServicePlan(acct, SNG_TestUtilities.insertServicePlanType(true), '2');      
        insert sp;
        
        Modem__c modem2 = SNG_TestUtilities.insertEquipment('Equipment2', SNG_MockUsageServiceHttpCallout.SUNNY_DAY_MAC_ADDRESS_CURRENT, acct, '', true);
        ModemServicePlan__c msp2 = SNG_TestUtilities.insertModemServicePlan(modem2, sp); 
        
        Terminal__c terminal = [SELECT Id FROM Terminal__c WHERE Nickname__c = 'Equipment2'];
        
        Test.startTest();
        
        PageReference pageRef = Page.SNGServicePlanDetail; 
        Test.setCurrentPage(pageRef); 

        ApexPages.StandardController sc = new ApexPages.StandardController(sp0);
        SNGServicePlanDetail spDetail = new SNGServicePlanDetail(sc);
        
        sp = [SELECT Name, Id, GbDownloaded__c, GbUploaded__c, GbTotal__c FROM ServicePlan__c WHERE Id = :sp0.Id];
/*!!!!!!        
        System.assertEquals('0', sp0.GbDownloaded__c);
        System.assertEquals('0', sp0.GbUploaded__c);
        System.assertEquals('0', sp0.GbTotal__c);
        System.assertEquals(1, spDetail.aggregateUsageData.size());
        System.assertEquals(0, spDetail.relatedModemServicePlans.size());
*/
        //testUpdateUsageData()
        Test.setMock(HttpCalloutMock.class, new SNG_MockUsageServiceHttpCallout());
        
        sc = new ApexPages.StandardController(sp);
        spDetail = new SNGServicePlanDetail(sc);
        
        System.debug(LoggingLevel.error, 'related MSPS: ' + spDetail.relatedModemServicePlans);
        
        //spDetail.updateUsageDataMspId = msp2.Id;
        spDetail.updateUsageData();
        
        decimal gbDownloaded =  SNG_MockUsageServiceHttpCallout.SINGLE_AGGREGATE_DOWNLOAD/ ONE_GIGABYTE_IN_BYTES;
        gbDownloaded = gbDownloaded.setScale(2);
        decimal gbUploaded = SNG_MockUsageServiceHttpCallout.SINGLE_AGGREGATE_UPLOAD/ ONE_GIGABYTE_IN_BYTES;
        gbUploaded = gbUploaded.setScale(2);
        decimal gbTotal = (SNG_MockUsageServiceHttpCallout.SINGLE_AGGREGATE_DOWNLOAD + SNG_MockUsageServiceHttpCallout.SINGLE_AGGREGATE_UPLOAD)/ONE_GIGABYTE_IN_BYTES;
        gbTotal = gbTotal.setScale(2);
        
        Test.stopTest();
/*!!!!!!
        System.assertEquals(String.valueOf(gbDownloaded), spDetail.servicePlan.GbDownloaded__c);
        System.assertEquals(String.valueOf(gbUploaded), spDetail.servicePlan.GbUploaded__c);
        System.assertEquals(String.valueOf(gbTotal), spDetail.servicePlan.GbTotal__c);
*/
    }
    
    //**********************************************************
    // TEST SNGServicePlanTab (SNGServicePlanTabUnitTest)
    //**********************************************************
    private static final Integer NUM_SPS_FOR_QUERY_LIMIT_TESTS = 101;
    
    static testMethod void noServicePlansAndMsps() {

        // Initialize controller class for Service Plan Tab page
        SNGServicePlanTab spTabController = new SNGServicePlanTab(); 
            
        System.assert(spTabController.servicePlans.isEmpty()); 
        System.assert(spTabController.displayServicePlans.isEmpty()); 
        System.assert(spTabController.msps.isEmpty()); 
    
        //updateAggregateUsageDataNoServicePlans() { 
        SNGServicePlanTab sngServicePlanController = new SNGServicePlanTab();
        
        System.assert(sngServicePlanController.servicePlans.isEmpty()); 
        System.assert(sngServicePlanController.servicePlans.isEmpty()); 
        System.assert(sngServicePlanController.displayServicePlans.isEmpty()); 
    }
    
	static testMethod void testSNGServicePlanTab() {
        // initialize custom settings
        SNG_MockCustomSettings.initialize();
        
        // create Modem that will have two HTTP status results, with an associated terminal
        Modem__c modem = SNG_TestUtilities.insertModem(SNG_MockUsageServiceHttpCallout.SUNNY_DAY_MAC_ADDRESS_CURRENT_SINGLE_TE, '1111', true); 
        
        Account account = [SELECT Name, Id FROM Account];
        
        // create active Service Plan with same account as modem
        ServicePlan__c servicePlan = SNG_TestUtilities.insertServicePlan(account, SNG_TestUtilities.insertServicePlanType(true), SNG_DateUtils.todayGmt().addYears(-1), SNG_DateUtils.todayGmt().addYears(1));
        
        // create active Modem/Service Plan
        ModemServicePlan__c msp = SNG_TestUtilities.insertModemServicePlan(modem, servicePlan);
        
        msp = [SELECT Name, Id, Status__c, ServicePlan__c, StartDate__c, EndDate__c, GbTotal__c, GbDownloaded__c, GbUploaded__c,
                            Modem__r.Id, Modem__r.Name, Modem__r.SerialNumber__c, Modem__r.Terminal__c, Modem__r.Terminal__r.Name 
                FROM ModemServicePlan__c];
                
        Test.startTest();
        
        // Create SNGServicePlanTab
        PageReference pageRef = Page.SNGServicePlanTab;
        // Set the current page reference for the controller
        Test.setCurrentPage(pageRef); 
        
        // set mspId parameter that the controller uses to get the Modem Service Plan's ID      
        ApexPages.currentPage().getParameters().put('mspId', msp.Id);
        
        // HttpCalloutMock - interface used for sending fake responses when testing HTTP callouts
        // Object - instance of the class that will provide the fake HTTP response
        Test.setMock(HttpCalloutMock.class, new SNG_MockUsageServiceHttpCallout()); 
        
        SNGServicePlanTab sngServicePlanTabController = new SNGServicePlanTab(); 
        sngServicePlanTabController.updateUsageData();
        sngServicePlanTabController.updateDisplay();
        
        //decimal ONE_GIGABYTE_IN_BYTES = 1073741824; 
        
        decimal gbDownloaded = SNG_MockUsageServiceHttpCallout.SINGLE_BSID_DOWNLOAD/ONE_GIGABYTE_IN_BYTES;
        gbDownloaded = gbDownloaded.setScale(2);  
        decimal gbUploaded = SNG_MockUsageServiceHttpCallout.SINGLE_BSID_UPLOAD/ONE_GIGABYTE_IN_BYTES;
        gbUploaded = gbUploaded.setScale(2);
        decimal gbTotal = (SNG_MockUsageServiceHttpCallout.SINGLE_BSID_DOWNLOAD + SNG_MockUsageServiceHttpCallout.SINGLE_BSID_UPLOAD)/ONE_GIGABYTE_IN_BYTES;
        gbTotal = gbTotal.setScale(2);
        
        System.debug('Number of ServicePlans: ' + sngServicePlanTabController.servicePlans.size());
        System.debug('ServicePlans: ' + sngServicePlanTabController.servicePlans);
        
        System.assertEquals(String.valueOf(gbDownloaded), sngServicePlanTabController.servicePlans.get(0).GbDownloaded__c); 
        System.assertEquals(String.valueOf(gbUploaded), sngServicePlanTabController.servicePlans.get(0).GbUploaded__c); 
        System.assertEquals(String.valueOf(gbTotal), sngServicePlanTabController.servicePlans.get(0).GbTotal__c);  
        Test.stopTest(); 
    }
    
    static testMethod void updateAggregateUsageDataTestMulitpleMsps() { 
        
        Account account = SNG_TestUtilities.insertAccount('testAccount');
        
        // insert service plan that will have multiple Modems
        ServicePlan__c servicePlan = SNG_TestUtilities.insertServicePlan(account, true); 
        
        // insert modems
        Modem__c modem1 = SNG_TestUtilities.insertEquipment('Terminal1', '00:a0:bc:11:22:33', account, true); 
        Modem__c modem2 = SNG_TestUtilities.insertEquipment('Terminal2', '00:a0:bc:11:22:44', account, true);
        Modem__c modem3 = SNG_TestUtilities.insertEquipment('Terminal3', '00:a0:bc:11:22:55', account, true);
        
        // insert Modem/Service Plan
        ModemServicePlan__c msp1 = SNG_TestUtilities.insertModemServicePlan(modem1, servicePlan); 
        ModemServicePlan__c msp2 = SNG_TestUtilities.insertModemServicePlan(modem2, servicePlan); 
        ModemServicePlan__c msp3 = SNG_TestUtilities.insertModemServicePlan(modem3, servicePlan);
        
        // Set the MSP fields and update the MSPs
        msp1.GbDownloaded__c = '1.00'; 
        msp1.GbUploaded__c = '2.00'; 
        msp1.GbTotal__c = '3.00'; 
        //update msp1; 
        
        msp2.GbDownloaded__c = '0.5'; 
        msp2.GbUploaded__c = '0.4';
        msp2.GbTotal__c = '0.9'; 
        //update msp2; 
        
        msp3.GbDownloaded__c = 'invalid entry'; 
        msp3.GbUploaded__c = 'invalid entry';
        msp3.GbTotal__c = 'invalid entry'; 
        //update msp3; 
        
        final ModemServicePlan__c[] msps = new ModemServicePlan__c[] { msp1, msp2, msp3 };
        final Map<String, SNG_ServicePlanUsageData> spUsageDatas = mapToSpUsageDatas(msps);
        SNG_SpUsageAggregateUpdater.updateMspAndSpUsage(new ServicePlan__c[] { servicePlan }, msps, spUsageDatas);
        
        Test.startTest();   
        // Initialize service plan tab controller 
        SNGServicePlanTab servicePlanTabController = new SNGServicePlanTab();
        
        System.assertEquals('1.50', servicePlanTabController.servicePlans.get(0).GbDownloaded__c);
        System.assertEquals('2.40', servicePlanTabController.servicePlans.get(0).GbUploaded__c);
        System.assertEquals('3.90', servicePlanTabController.servicePlans.get(0).GbTotal__c);
        Test.stopTest(); 
    }
    
    
    static testMethod void testPagingGetFirstPage() {
        SNG_MockCustomSettings.initialize();
        
        SNG_TestUtilities.insertListOfServicePlans(33);
        
        Test.startTest(); 
        
        SNGServicePlanTab servicePlanTabController = new SNGServicePlanTab(); 
        servicePlanTabController.getFirstPage();        
        System.assertEquals('1', servicePlanTabController.pageNumberStr);       
        servicePlanTabController.ViewData();        
        List<ServicePlan__c> displayList = servicePlanTabController.displayServicePlans;
        
        System.assertEquals(10, displayList.size()); 
        
        servicePlanTabController.getNextPage(); 
        servicePlanTabController.ViewData();
        
        displayList = servicePlanTabController.displayServicePlans;
        
        System.assertEquals('2', servicePlanTabController.pageNumberStr);
        System.assert(servicePlanTabController.isNextValid);
        System.assert(servicePlanTabController.isPrevValid); 
        
        servicePlanTabController.getLastPage();
        servicePlanTabController.ViewData();
            
        displayList = servicePlanTabController.displayServicePlans;
        
        System.assertEquals('4', servicePlanTabController.pageNumberStr);
        System.assert(!servicePlanTabController.isNextValid);
        System.assert(servicePlanTabController.isPrevValid);

        servicePlanTabController.getPrevPage(); 
        servicePlanTabController.ViewData();
                
        displayList = servicePlanTabController.displayServicePlans;

        servicePlanTabController.pageNumberStr = '3'; 
        servicePlanTabController.goToPage(); 
        servicePlanTabController.ViewData();        
            
        displayList = servicePlanTabController.displayServicePlans;
        
        System.assertEquals('3', servicePlanTabController.pageNumberStr);
        System.assertEquals(10, displayList.size());
        System.assert(servicePlanTabController.isNextValid);
        System.assert(servicePlanTabController.isPrevValid);    

        servicePlanTabController.sortExpression = 'SalesOrder__c';  
        servicePlanTabController.setSortDirection('DESC');
        System.assertEquals('DESC', servicePlanTabController.getSortDirection()); 
        
        servicePlanTabController.ViewData(); 
        
        displayList = servicePlanTabController.displayServicePlans;
        
        System.assertEquals(10, displayList.size()); 
        
        Test.stopTest(); 
    }
    
    private static Map<String, SNG_ServicePlanUsageData> mapToSpUsageDatas(ModemServicePlan__c[] msps) {
        final SNG_UsageService.UsageAndErrors[] uaes = new List<SNG_UsageService.UsageAndErrors>();
        for (ModemServicePlan__c msp : msps) {
            final SNG_UsageService.UsageAndErrors uae = new SNG_UsageService.UsageAndErrors();
            uae.startTime = SNG_DateTimeUtils.toDateTimeGmt(msp.StartDate__c);
            uae.endTime = SNG_DateTimeUtils.toDateTimeGmt(msp.EndDate__c.addDays(1));
            uae.firstProcessedEventTimestamp = uae.startTime;
            uae.lastProcessedEventTimestamp = uae.endTime.addSeconds(-1);
            uae.aggregateAcctInputOctets = convertMspGbUsageFieldToBytes(msp.GbDownloaded__c);
            uae.aggregateAcctOutputOctets = convertMspGbUsageFieldToBytes(msp.GbUploaded__c);
            uae.macAddress = msp.Modem__r.MacAddress__c.replaceAll(':', '').toUpperCase();
            
            // Note: The BSID used here is hard-coded.
            final SNG_UsageService.UsagePerBaseStationId usage = new SNG_UsageService.UsagePerBaseStationId();
            usage.bsid = '00a0bc01110b';
            usage.acctInputOctets = uae.aggregateAcctInputOctets;
            usage.acctOutputOctets = uae.aggregateAcctOutputOctets;
            uae.usage = new SNG_UsageService.UsagePerBaseStationId[] { usage };
            
            uaes.add(uae);
        }
        
        final Map<String, SNG_ServicePlanUsageData> spUsageDatas = new Map<String, SNG_ServicePlanUsageData>();
        SNG_ModemServicePlanUsageMapper.mapToServicePlanUsageDatas(msps, spUsageDatas, uaes);
        return spUsageDatas;
    }
    
    private static Long convertMspGbUsageFieldToBytes(final String usageStr) {
        return isNumber(usageStr) ? convertGiBToBytes(Decimal.valueOf(usageStr)) : 0L;
    }
    
    private static boolean isNumber(final String str) {
        return null != str && StringUtils.containsOnly(str, '0123456789.');
    }
    
    private static Long convertGiBToBytes(final Decimal giB) {
        final Long BYTES_PER_GIB = 1073741824L;
        return (Long) (BYTES_PER_GIB * giB);
    }
   
    //**********************************************************
    // TEST SNGTabColumnSort (SNGTabColumnSortUnitTest)
    //**********************************************************
    static testMethod void testGetSetSortDirection()
    {
        String basicQuery = 'SELECT SerialNumber__c FROM Modem__c';
        SNGTabColumnSort sorting = new SNGTabColumnSort(basicQuery);
        System.assert('ASC' == sorting.getSortDirection());
        sorting.setSortDirection('DESC');
        System.assert('DESC' == sorting.getSortDirection());
        
        sorting.setSortDirection('ASC');
        System.assert('ASC' == sorting.getSortDirection());
        sorting.setSortDirection('DESC');
        System.assert('DESC' == sorting.getSortDirection());
        
        sorting.setSortDirection('');
        System.assert('DESC' == sorting.getSortDirection());
        
        sorting.setSortDirection('notADirection');
        System.assert('DESC' == sorting.getSortDirection());
        
        sorting.setSortDirection('ASC');
        System.assert('ASC' == sorting.getSortDirection());
        sorting.setSortDirection('');
        System.assert('ASC' == sorting.getSortDirection());
        sorting.setSortDirection('notADirection');
        System.assert('ASC' == sorting.getSortDirection());
    }
    
    static testMethod void testViewDataBasedOnSort()
    {
        Modem__c modem1 = SNG_TestUtilities.insertModem('00:a0:bc:11:11:11', null, false);
        Modem__c modem2 = SNG_TestUtilities.insertModem('00:a0:bc:22:22:22', 'a', false);
        Modem__c modem3 = SNG_TestUtilities.insertModem('00:a0:bc:33:33:33', 'b', false);
        
        Test.startTest();
        String basicQuery = 'SELECT SerialNumber__c FROM Modem__c';
        SNGTabColumnSort sorting = new SNGTabColumnSort(basicQuery);
        sorting.sortExpression = null;
        System.assert('ASC' == sorting.getSortDirection());
        sorting.sortExpression = '';
        System.assert('ASC' == sorting.getSortDirection());     
 
        sorting.sortExpression = 'SerialNumber__c';
        List<Modem__c> sortedList = sorting.ViewData(); 
        
        System.assertEquals(modem1.SerialNumber__c,  sortedList[0].SerialNumber__c);
        System.assertEquals(modem2.SerialNumber__c, sortedList[1].SerialNumber__c);
        System.assertEquals(modem3.SerialNumber__c, sortedList[2].SerialNumber__c);
        
        sorting.sortExpression = 'SerialNumber__c';
        sortedList = sorting.ViewData(); 
        System.assertEquals(modem3.SerialNumber__c, sortedList[0].SerialNumber__c);
        System.assertEquals(modem2.SerialNumber__c, sortedList[1].SerialNumber__c);
        System.assertEquals(modem1.SerialNumber__c,  sortedList[2].SerialNumber__c);
        Test.stoptest();
    }
    
    //**********************************************************
    // TEST SNGTabPaging (SNGTabPagingUnitTest)
    //**********************************************************
    static testMethod void testCtorInitializePagingEmptyList()
    {
        List<Modem__c> modemList = new List<Modem__c>();
        SNGTabPaging paging = new SNGTabPaging(modemList);
        System.assertEquals(0, paging.totalPages);
        System.assertEquals('0', paging.pageNumberStr);
        System.assertEquals(false, paging.isPrevValid);
        System.assertEquals(false, paging.isNextValid);
        System.assertEquals('', paging.recordInfo);
        
        List<Modem__c> displayList = paging.displaySObjects;
        System.assertEquals(0, displayList.size());
    }
    
    static testMethod void testNextPageAndGetFirstPage()
    {
        List<Modem__c> modemList = createListOfModemObjects(45);
        
        Test.startTest();
        SNGTabPaging paging = new SNGTabPaging(modemList);
        System.assertEquals(5, paging.totalPages);
        System.assertEquals('1', paging.pageNumberStr);
        System.assertEquals(false, paging.isPrevValid);
        System.assertEquals(true, paging.isNextValid);
        System.assertEquals('1 - 10 of 45', paging.recordInfo);
        
        paging.getNextPage();
        System.assertEquals('2', paging.pageNumberStr); 
        System.assertEquals(true, paging.isPrevValid);
        System.assertEquals(true, paging.isNextValid);

        paging.pageNumber = 3;
        paging.gotoPage();
        System.assertEquals('3', paging.pageNumberStr);
        System.assertEquals(true, paging.isPrevValid);
        System.assertEquals(true, paging.isNextValid);
        
        // test to see display get updated.
        List<Modem__c> displayList = paging.displaySObjects;
        for (integer i = 0; i < paging.amountToDisplay ; ++i)
        {
            System.assertEquals(String.valueOf(i + (2 * paging.amountToDisplay)), displayList[i].SerialNumber__c);
        }        
        
        paging.getNextPage();
        System.assertEquals('4', paging.pageNumberStr);
        System.assertEquals(true, paging.isPrevValid);
        System.assertEquals(true, paging.isNextValid);
        
        paging.getNextPage();
        System.assertEquals('5', paging.pageNumberStr);
        System.assertEquals(true, paging.isPrevValid);
        System.assertEquals(false, paging.isNextValid);
        
        paging.getFirstPage();
        System.assertEquals('1', paging.pageNumberStr); 
        System.assertEquals(false, paging.isPrevValid);
        System.assertEquals(true, paging.isNextValid); 
        
        paging.getLastPage();
        System.assertEquals('5', paging.pageNumberStr);
        System.assertEquals(true, paging.isPrevValid);
        System.assertEquals(false, paging.isNextValid); 
                
        paging.getPrevPage();
        System.assertEquals('4', paging.pageNumberStr);
        System.assertEquals(true, paging.isPrevValid);
        System.assertEquals(true, paging.isNextValid); 
        
        // test to see display get updated.
        displayList = paging.displaySObjects;
        for (integer i = 0; i < paging.amountToDisplay ; ++i)
        {
            System.assertEquals(String.valueOf(i + (3 * paging.amountToDisplay)), displayList[i].SerialNumber__c);
        }
        
        paging.getPrevPage();
        System.assertEquals('3', paging.pageNumberStr);
        System.assertEquals(true, paging.isPrevValid);
        System.assertEquals(true, paging.isNextValid);
        
        paging.getPrevPage();
        System.assertEquals('2', paging.pageNumberStr);
        System.assertEquals(true, paging.isPrevValid);
        System.assertEquals(true, paging.isNextValid);
        
        paging.getPrevPage();
        System.assertEquals('1', paging.pageNumberStr);
        System.assertEquals(false, paging.isPrevValid);
        System.assertEquals(true, paging.isNextValid);

        modemList[0].SerialNumber__c = 'Foo';
        
        paging.updateDisplay(modemList);
    }
      
    private static List<Modem__c> createListOfModemObjects(integer amountToCreate)
    {
       List<Modem__c> modemList = new List<Modem__c>(); 
    
       for (integer i = 0; i < amountToCreate; ++i)
       {
           Modem__c modem = new Modem__c();
           modem.SerialNumber__c = String.valueOf(i);
           modemList.add(modem);
       }
       
       return modemList;
    }
    
    //**********************************************************
    // TEST SNGTerminalDetail (SNGTerminalDetailUnitTest)
    //**********************************************************
	//Test SNGTerminalDetail to cover SNGTerminalHelpText,SNGTerminalDetail,SNG_UtUsageHistory,SNG_UTPerformanceHistory,SNGVisualforceRender,SNG_UtPeers,SNGTerminalHistory,SNG_TerminalQuery
	static testMethod void testSNGTerminalDetail() 
    {
        SNG_MockCustomSettings.initialize();
        
        Modem__c modem = SNG_TestUtilities.insertEquipment('Equipment1', SNG_MockModemSoftwareVersionHttpCallout.MACADDR_OK, 'testAccount', true);
        Terminal__c terminal = modem.Terminal__r;
        
        Test.startTest();

        PageReference pageRef=Page.SNGTerminalDetail;
        Test.setCurrentPage(pageRef);

        //testCtorWithCurrentBillingCycleOnly
        ApexPages.StandardController sc = new ApexPages.StandardController(terminal);
        SNGTerminalDetail terminalDetail = new SNGTerminalDetail(sc);
        SNG_UtUsageHistory uHist = new SNG_UtUsageHistory(sc);
        string s = uHist.byteCountUnit;
        s = uHist.bytesDownloadedStr;
        s = uHist.bytesUploadedStr;
        uHist.getUsageHistory();       
        
        System.assertEquals('Current Billing Cycle', terminalDetail.billingCycleSelection);
        
        Date expectedStartDate = SNG_DateUtils.todayGmt().toStartOfMonth();
        Date expectedEndDate = expectedStartDate.addMonths(1).addDays(-1);
        System.assertEquals(expectedStartDate.format(), terminalDetail.billingCycleStartDateStr);
        System.assertEquals(expectedEndDate.format(), terminalDetail.billingCycleEndDateStr);
        
        List<SelectOption> billingCycles = terminalDetail.billingCycles;
        System.assertEquals(1, billingCycles.size());
        System.assertEquals('Current Billing Cycle (' + expectedStartDate.format() + ' - ' + expectedEndDate.format() + ')', billingCycles[0].getLabel());
        
        Test.stopTest();
    }
    
    static testMethod void testCtorWithPreviousBillingCycleAvailable()
    {
        Modem__c modem = SNG_TestUtilities.insertEquipment('testTerminal', SNG_TestUtilities.VALID_MAC_ADDR, 'testAccount', true);
        Product2 servicePlanType = SNG_TestUtilities.insertProduct2('servicePlanType', 'Service Plan Types', true);
        
        Date spStartDate = SNG_DateUtils.todayGmt().addMonths(-1);
        Date spEndDate = spStartDate.addMonths(1);
        if (1 == spStartDate.day())
           spStartDate = spStartDate.addDays(10);
        ServicePlan__c servicePlan = SNG_TestUtilities.insertServicePlan(modem.Account__r, servicePlanType, spStartDate, spEndDate);
        ModemServicePlan__c msp = SNG_TestUtilities.insertModemServicePlan(modem, servicePlan);


        Terminal__c terminal = modem.Terminal__r;
        ApexPages.StandardController sc = new ApexPages.StandardController(terminal);
        SNGTerminalDetail terminalDetail = new SNGTerminalDetail(sc);
                
        System.assertEquals('Current Billing Cycle', terminalDetail.billingCycleSelection);
        
        Date expectedStartDate = SNG_DateUtils.todayGmt().toStartOfMonth();
        Date expectedEndDate = expectedStartDate.addMonths(1).addDays(-1);
        System.assertEquals(expectedStartDate.format(), terminalDetail.billingCycleStartDateStr);
        System.assertEquals(expectedEndDate.format(), terminalDetail.billingCycleEndDateStr);
        
        Date expectedPrevStartDate = expectedStartDate.addMonths(-1);
        Date expectedPrevEndDate = expectedStartDate.addDays(-1);
        
        List<SelectOption> billingCycles = terminalDetail.billingCycles;
        System.assertEquals(2, billingCycles.size());
        System.assertEquals('Current Billing Cycle (' + expectedStartDate.format() + ' - ' + expectedEndDate.format() + ')', billingCycles[0].getLabel());
        System.assertEquals('Previous Billing Cycle (' + expectedPrevStartDate.format() + ' - ' + expectedPrevEndDate.format() + ')', billingCycles[1].getLabel());
    }
    
    
    static testMethod void testUpdateBillingCycleDates()
    {
        Modem__c modem = SNG_TestUtilities.insertEquipment('testTerminal', SNG_TestUtilities.VALID_MAC_ADDR, 'testAccount', true);
        Product2 servicePlanType = SNG_TestUtilities.insertProduct2('servicePlanType', 'Service Plan Types', true);
        
        Date spStartDate = SNG_DateUtils.todayGmt().addMonths(-1);
        Date spEndDate = spStartDate.addMonths(1);
        if (1 == spStartDate.day())
           spStartDate = spStartDate.addDays(10);
        ServicePlan__c servicePlan = SNG_TestUtilities.insertServicePlan(modem.Account__r, servicePlanType, spStartDate, spEndDate);
        ModemServicePlan__c msp = SNG_TestUtilities.insertModemServicePlan(modem, servicePlan);


        Terminal__c terminal = modem.Terminal__r;
        ApexPages.StandardController sc = new ApexPages.StandardController(terminal);
        SNGTerminalDetail terminalDetail = new SNGTerminalDetail(sc);
                
        System.assertEquals('Current Billing Cycle', terminalDetail.billingCycleSelection);
        
        Date expectedStartDate = SNG_DateUtils.todayGmt().toStartOfMonth();
        Date expectedEndDate = expectedStartDate.addMonths(1).addDays(-1);
        System.assertEquals(expectedStartDate.format(), terminalDetail.billingCycleStartDateStr);
        System.assertEquals(expectedEndDate.format(), terminalDetail.billingCycleEndDateStr);
        
        Date expectedPrevStartDate = expectedStartDate.addMonths(-1);
        Date expectedPrevEndDate = expectedStartDate.addDays(-1);
        
        List<SelectOption> billingCycles = terminalDetail.billingCycles;
        System.assertEquals(2, billingCycles.size());
        System.assertEquals('Current Billing Cycle (' + expectedStartDate.format() + ' - ' + expectedEndDate.format() + ')', billingCycles[0].getLabel());
        System.assertEquals('Previous Billing Cycle (' + expectedPrevStartDate.format() + ' - ' + expectedPrevEndDate.format() + ')', billingCycles[1].getLabel());
        
        
        terminalDetail.billingCycleSelection = 'Previous Billing Cycle';
        terminalDetail.updateBillingCycleDates();
        System.assertEquals('Previous Billing Cycle', terminalDetail.billingCycleSelection);
        System.assertEquals(expectedPrevStartDate.format(), terminalDetail.billingCycleStartDateStr);
        System.assertEquals(expectedPrevEndDate.format(), terminalDetail.billingCycleEndDateStr);
    }
    
    static testMethod void testUpdateBillingCycleDatesInvalidSelection()
    {
        SNG_MockCustomSettings.initialize();
        
        Modem__c modem = SNG_TestUtilities.insertEquipment('Equipment1', SNG_MockModemSoftwareVersionHttpCallout.MACADDR_OK, 'testAccount', true);
        Terminal__c terminal = modem.Terminal__r;
        ApexPages.StandardController sc = new ApexPages.StandardController(terminal);
        SNGTerminalDetail terminalDetail = new SNGTerminalDetail(sc);
        
        System.assertEquals('Current Billing Cycle', terminalDetail.billingCycleSelection);
        
        terminalDetail.billingCycleSelection = 'Invalid Billing Cycle';
        try
        {
            terminalDetail.updateBillingCycleDates();
            System.assert(false);
        }
        catch (SNG_Exception e)
        {
            System.assert(true);
        }
    }
    
    
    static testMethod void testGetSoftwareVersions()
    {
        SNG_MockCustomSettings.initialize();
        
        Modem__c modem = SNG_TestUtilities.insertEquipment('Equipment1', SNG_MockModemSoftwareVersionHttpCallout.MACADDR_OK, 'testAccount', true);
        Terminal__c terminal = modem.Terminal__r;
        ApexPages.StandardController sc = new ApexPages.StandardController(terminal);
        SNGTerminalDetail terminalDetail = new SNGTerminalDetail(sc);        
        
        
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new SNGMockModemSoftwareVersionHttpCallout());

        terminalDetail.getSoftwareVersions();
        
        List<Modem__c> relatedModems = terminalDetail.relatedModems;
        System.assertEquals(1, relatedModems.size());
        System.assertEquals(SNGMockModemSoftwareVersionHttpCallout.SOFTWARE_VERSION, relatedModems[0].SoftwareVersion__c);
        Test.stopTest();
    }
    
    //**********************************************************
    // TEST SNGTerminalHelpTextUnitTest
    //**********************************************************
    static testMethod void statusHelpTextTest() {
        SNGTerminalHelpText helpTextExt = new SNGTerminalHelpText(initController());
        System.assertEquals(Terminal__c.Status__c.getDescribe().getInlineHelpText(), helpTextExt.statusHelpText);
    
        //onlineTimeHelpTextTest
        //SNGTerminalHelpText helpTextExt = new SNGTerminalHelpText(initController());
        System.assertEquals(Terminal__c.OnlineTime__c.getDescribe().getInlineHelpText(), helpTextExt.onlineTimeHelpText);
    
        //billingCycleHelpTextTest() {
        //SNGTerminalHelpText helpTextExt = new SNGTerminalHelpText(initController());
        System.assert(!StringUtils.isBlank(helpTextExt.billingCycleHelpText));
    
        //bytesDownloadedHelpTextTest() {
        //SNGTerminalHelpText helpTextExt = new SNGTerminalHelpText(initController());
        System.assert(!StringUtils.isBlank(helpTextExt.bytesDownloadedHelpText));

        //bytesUploadedHelpTextTest() {
        //SNGTerminalHelpText helpTextExt = new SNGTerminalHelpText(initController());
        System.assert(!StringUtils.isBlank(helpTextExt.bytesUploadedHelpText));
    
        //billingCycleStartDateHelpTextTest() {
        //SNGTerminalHelpText helpTextExt = new SNGTerminalHelpText(initController());
        System.assert(!StringUtils.isBlank(helpTextExt.billingCycleStartDateHelpText));
    
        //dataAsOfHelpTextTest() {
        //SNGTerminalHelpText helpTextExt = new SNGTerminalHelpText(initController());
        System.assert(!StringUtils.isBlank(helpTextExt.dataAsOfHelpText));
    
        // chartHelpTextTest() {
        //SNGTerminalHelpText helpTextExt = new SNGTerminalHelpText(initController());
        System.assert(!StringUtils.isBlank(helpTextExt.chartHelpText));
    }
    
    static testMethod void networkHelpTextGreenTest() {
        ApexPages.StandardController controller = initController();
        SNGTerminalStatusLightUnitTestHelper.setNetworkGreen((Terminal__c)controller.getRecord());
        getNetworkHelpText(new SNGTerminalHelpText(controller));
    }
    
    static testMethod void networkHelpTextRedTest() {
        ApexPages.StandardController controller = initController();
        SNGTerminalStatusLightUnitTestHelper.setNetworkRed((Terminal__c)controller.getRecord());
        getNetworkHelpText(new SNGTerminalHelpText(controller));
    }
    
    static testMethod void weatherHelpTextGreenTest() {
        ApexPages.StandardController controller = initController();
        SNGTerminalStatusLightUnitTestHelper.setWeatherGreen((Terminal__c)controller.getRecord());
        getWeatherHelpText(new SNGTerminalHelpText(controller));
    }
    
    static testMethod void weatherHelpTextYellowTest() {
        ApexPages.StandardController controller = initController();
        SNGTerminalStatusLightUnitTestHelper.setWeatherYellow((Terminal__c)controller.getRecord());
        getWeatherHelpText(new SNGTerminalHelpText(controller));
    }
    
    static testMethod void weatherHelpTextRedTest() {
        ApexPages.StandardController controller = initController();
        SNGTerminalStatusLightUnitTestHelper.setWeatherRed((Terminal__c)controller.getRecord());
        getWeatherHelpText(new SNGTerminalHelpText(controller));
    }
    
    static testMethod void performanceHelpTextGreenTest() {
        ApexPages.StandardController controller = initController();
        SNGTerminalStatusLightUnitTestHelper.setPerformanceGreen((Terminal__c)controller.getRecord());
        getPerformanceHelpText(new SNGTerminalHelpText(controller));
    }
    
    static testMethod void performanceHelpTextYellowTest() {
        ApexPages.StandardController controller = initController();
        SNGTerminalStatusLightUnitTestHelper.setPerformanceYellow((Terminal__c)controller.getRecord());
        getPerformanceHelpText(new SNGTerminalHelpText(controller));
    }
    
    static testMethod void performanceHelpTextRedTest() {
        ApexPages.StandardController controller = initController();
        SNGTerminalStatusLightUnitTestHelper.setPerformanceRed((Terminal__c)controller.getRecord());
        getPerformanceHelpText(new SNGTerminalHelpText(controller));
    }
    
    static testMethod void performanceHelpTextGrayTest() {
        ApexPages.StandardController controller = initController();
        SNGTerminalStatusLightUnitTestHelper.setPerformanceGray((Terminal__c)controller.getRecord());
        getPerformanceHelpText(new SNGTerminalHelpText(controller));
    }
    
    static testMethod void pointingHelpTextGreenTest() {
        ApexPages.StandardController controller = initController();
        SNGTerminalStatusLightUnitTestHelper.setPointingGreen((Terminal__c)controller.getRecord());
        getPointingHelpText(new SNGTerminalHelpText(controller));
    }
    
    static testMethod void pointingHelpTextYellowTest() {
        ApexPages.StandardController controller = initController();
        SNGTerminalStatusLightUnitTestHelper.setPointingYellow((Terminal__c)controller.getRecord());
        getPointingHelpText(new SNGTerminalHelpText(controller));
    }
    
    static testMethod void pointingHelpTextRedTest() {
        ApexPages.StandardController controller = initController();
        SNGTerminalStatusLightUnitTestHelper.setPointingRed((Terminal__c)controller.getRecord());
        getPointingHelpText(new SNGTerminalHelpText(controller));
    }
    
    static testMethod void pointingHelpTextGrayTest() {
        ApexPages.StandardController controller = initController();
        SNGTerminalStatusLightUnitTestHelper.setPointingGray((Terminal__c)controller.getRecord());
        getPointingHelpText(new SNGTerminalHelpText(controller));
    }
    
    private static ApexPages.StandardController initController() {
        Terminal__c terminal = SNG_TestUtilities.insertTerminal(SNG_TestUtilities.insertAccount('accountName'), 'serialNum', '9876543');
        return new ApexPages.StandardController(terminal);
    }
    
    private static String getNetworkHelpText(SNGTerminalHelpText helpTextExt) {
        String helpText = helpTextExt.networkHelpText;
        System.assert(!StringUtils.isBlank(helpText));
        return helpText;
    }
    
    private static String getWeatherHelpText(SNGTerminalHelpText helpTextExt) {
        String helpText = helpTextExt.weatherHelpText;
        System.assert(!StringUtils.isBlank(helpText));
        return helpText;
    }
    
    private static String getPerformanceHelpText(SNGTerminalHelpText helpTextExt) {
        String helpText = helpTextExt.performanceHelpText;
        System.assert(!StringUtils.isBlank(helpText));
        return helpText;
    }
    
    private static String getPointingHelpText(SNGTerminalHelpText helpTextExt) {
        String helpText = helpTextExt.pointingHelpText;
        System.assert(!StringUtils.isBlank(helpText));
        return helpText;
    }

    //******************************************************************************
    // TEST SNG_CustomTerminalLookupController (SNG_CustomTerminalLookupUnitTest)
    //******************************************************************************
    static testMethod void SNG_CustomTerminalLookupControllerTest() {
        
        SNG_MockCustomSettings.initialize();

        // initialize Terminals, Accounts, and page parameters
        // searchField will be blank
        // Initialize Account of the modem and insert  
        Account modemAccount = SNG_TestUtilities.insertAccount('testAccount');
        // Initialize other Account that is not the modem's 
        Account otherAccount = SNG_TestUtilities.insertAccount('otherAccount'); 
        
        // Initialize terminals with the same account as modem
        Terminal__c terminalOne = SNG_TestUtilities.insertTerminal(modemAccount, '0', '1234561'); 
        Terminal__c terminalTwo = SNG_TestUtilities.insertTerminal(modemAccount, '1', '1234561');
        Terminal__c terminalThree = SNG_TestUtilities.insertTerminal(modemAccount, '2', '1234561'); 
        
        // Initialize terminals with different account than modem 
        Terminal__c otherTermOne = SNG_TestUtilities.insertTerminal(otherAccount, '10', '3451121');
        Terminal__c otherTermTwo = SNG_TestUtilities.insertTerminal(otherAccount, '11', '3451121');

        // queryHasNoWildcardChar
         
        // Initialize page parameters for the controller
        // No need to set current PageReference (create a page) for Test class. 
        Test.startTest();
        
        String searchField = '';

        PageReference pageRef = Page.SNG_CustomTerminalLookup;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('mAcct', modemAccount.Name);
        ApexPages.currentPage().getParameters().put('lksrch', searchField);  
        ApexPages.currentPage().getParameters().put('frm', ''); 
        ApexPages.currentPage().getParameters().put('txt', '');    
        
        // initialize controller 
        SNG_CustomTerminalLookupController controller = new SNG_CustomTerminalLookupController(); 
        
        // call on search
        controller.search(); 
        
        // There should only be 3 Terminals in List<Terminal__c> results 
        System.assert(controller.results.size() == 3); 
        
        // The terminals in result should have the same account as modem account 
        for (Terminal__c terminal : controller.results) { 
            System.assert(terminal.Account__c == controller.modemAccount.Id); 
        }
        
        // query string has wildcard character at the end
        searchField = 'T*';      
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('mAcct', modemAccount.Name);
        ApexPages.currentPage().getParameters().put('lksrch', searchField);  
        ApexPages.currentPage().getParameters().put('frm', ''); 
        ApexPages.currentPage().getParameters().put('txt', '');    

        controller = new SNG_CustomTerminalLookupController(); 
        controller.search(); 
        
        // There should only be 3 Terminals in results 
        System.assert(controller.results.size() == 3); 
        
        for (Terminal__c terminal : controller.results) { 
            System.assert(terminal.Account__c == controller.modemAccount.Id); 
        }

        // query string has wildcard character at the end
        searchField = '*T'; 
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('mAcct', modemAccount.Name);
        ApexPages.currentPage().getParameters().put('lksrch', searchField);  
        ApexPages.currentPage().getParameters().put('frm', ''); 
        ApexPages.currentPage().getParameters().put('txt', '');    

        controller = new SNG_CustomTerminalLookupController(); 
        controller.search(); 
        
        // There should only be 3 Terminals in results 
        System.assert(controller.results.size() == 3); 
        
        for (Terminal__c terminal : controller.results) { 
            System.assert(terminal.Account__c == controller.modemAccount.Id); 
        } 
        
        Test.stopTest();    
    }

    //******************************************************************************
    // TEST SNG_ModemServicePlan (SNG_ModemServicePlanUnitTest)
    //******************************************************************************
    final static Date TODAY = SNG_DateUtils.todayGmt();


    static testMethod void doesModemHaveActiveServicePlanTrueTest() {
        ModemServicePlan__c msp = insertMSP(TODAY, TODAY.addDays(1));
        System.assert(SNG_ModemServicePlan.doesModemHaveActiveServicePlan(msp.Modem__r));
    }
    
    static testMethod void doesModemHaveActiveServicePlanFalseTest() {
        ModemServicePlan__c msp = insertMSP(TODAY.addDays(1), TODAY.addDays(2));
        System.assert(null != msp.Modem__r);
        System.assert(!SNG_ModemServicePlan.doesModemHaveActiveServicePlan(msp.Modem__r));
    }

  
    static testMethod void testAutoCompleteEndDateServicePlanBeforeClosestMsp() 
    { 
        SNG_MockCustomSettings.initialize();

        Date todayGmt = SNG_DateUtils.todayGmt();
        Account account = SNG_TestUtilities.insertAccount('testAccount');
        Terminal__c terminal = SNG_TestUtilities.insertTerminal(account, '11111', '1234561');
        Modem__c modem = SNG_TestUtilities.insertModem('00:a0:bc:11:11:11', account, terminal);
        ServicePlan__c spForClosestMsp = createServicePlan(account, todayGmt.addYears(-1), todayGmt.addYears(1), 
                                                            SNG_TestUtilities.insertServicePlanType(true), '1111111');
        ServicePlan__c spBeforeClosestMsp = createServicePlan(account, todayGmt.addYears(-1), todayGmt.addDays(30), 
                                                            SNG_TestUtilities.insertServicePlanType(true), '2222222');


        ModemServicePlan__c closestMsp = new ModemServicePlan__c(); 
        closestMsp.Modem__c = modem.Id;
        closestMsp.ServicePlan__c = spForClosestMsp.Id;
        closestMsp.StartDate__c = todayGmt.addDays(100);
        closestMsp.EndDate__c = todayGmt.addDays(120);
        insert closestMsp;

        Test.startTest();

        ModemServicePlan__c mspToAutoComplete = new ModemServicePlan__c();
        mspToAutoComplete.Modem__c = modem.Id;
        mspToAutoComplete.ServicePlan__c = spBeforeClosestMsp.Id;
        mspToAutoComplete.StartDate__c = todayGmt;

        try { 
            insert mspToAutoComplete;
        }
        catch (DmlException e) {
            System.assert(false);
        }

        Map<Id, ModemServicePlan__c> mspsRetrieved = new Map<Id, ModemServicePlan__c>([SELECT Name, Id, 
                                                                                    EndDate__c, 
                                                                                    StartDate__c, 
                                                                                    Modem__c, 
                                                                                    ServicePlan__c 
                                                                                    FROM ModemServicePlan__c]);
        mspToAutoComplete = mspsRetrieved.get(mspToAutoComplete.Id);
        System.assertEquals(spBeforeClosestMsp.EndDate__c, mspToAutoComplete.EndDate__c);
    }
    
    static testMethod void testAutoCompleteEndDateClosestMspSameAsServicePlan() 
    {
        SNG_MockCustomSettings.initialize();

        Date todayGmt = SNG_DateUtils.todayGmt();
        Account account = SNG_TestUtilities.insertAccount('testAccount');
        Terminal__c terminal = SNG_TestUtilities.insertTerminal(account, '11111', '1234561');
        Modem__c modem = SNG_TestUtilities.insertModem('00:a0:bc:11:11:11', account, terminal);
        ServicePlan__c spForClosestMsp = createServicePlan(account, todayGmt.addYears(-1), todayGmt.addYears(1), 
                                                            SNG_TestUtilities.insertServicePlanType(true), '1111111');
        ServicePlan__c spEndAtClosestMsp = createServicePlan(account, todayGmt.addYears(-1), todayGmt.addDays(30), 
                                                            SNG_TestUtilities.insertServicePlanType(true), '2222222');

        ModemServicePlan__c closestMsp = new ModemServicePlan__c(); 
        closestMsp.Modem__c = modem.Id;
        closestMsp.ServicePlan__c = spForClosestMsp.Id;
        closestMsp.StartDate__c = spEndAtClosestMsp.EndDate__c;
        closestMsp.EndDate__c = spEndAtClosestMsp.EndDate__c.addDays(30);
        insert closestMsp;

        Test.startTest();

        System.assertEquals(closestMsp.StartDate__c, spEndAtClosestMsp.EndDate__c);

        ModemServicePlan__c mspToAutoComplete = new ModemServicePlan__c();
        mspToAutoComplete.Modem__c = modem.Id;
        mspToAutoComplete.ServicePlan__c = spEndAtClosestMsp.Id;
        mspToAutoComplete.StartDate__c = todayGmt;

        try { 
            insert mspToAutoComplete;
        }
        catch (DmlException e) {
            System.assert(false);
        }

        Map<Id, ModemServicePlan__c> mspsRetrieved = new Map<Id, ModemServicePlan__c>([SELECT Name, Id, 
                                                                                    EndDate__c, 
                                                                                    StartDate__c, 
                                                                                    Modem__c, 
                                                                                    ServicePlan__c 
                                                                                    FROM ModemServicePlan__c]);
        mspToAutoComplete = mspsRetrieved.get(mspToAutoComplete.Id);
        System.assertEquals(spEndAtClosestMsp.EndDate__c.addDays(-1), mspToAutoComplete.EndDate__c);
        System.assertEquals(closestMsp.StartDate__c.addDays(-1), mspToAutoComplete.EndDate__c);
    }

    static testMethod void testAutoCompleteEndDateClosestMspBeforeServicePlan()
    {
        SNG_MockCustomSettings.initialize();

        Date todayGmt = SNG_DateUtils.todayGmt();
        Account account = SNG_TestUtilities.insertAccount('testAccount');
        Terminal__c terminal = SNG_TestUtilities.insertTerminal(account, '11111', '1234561');
        Modem__c modem = SNG_TestUtilities.insertModem('00:a0:bc:11:11:11', account, terminal);
        ServicePlan__c sp = createServicePlan(account, todayGmt.addYears(-1), todayGmt.addYears(1), SNG_TestUtilities.insertServicePlanType(true), '1111111');
        
        ModemServicePlan__c closestMsp = new ModemServicePlan__c(); 
        closestMsp.Modem__c = modem.Id;
        closestMsp.ServicePlan__c = sp.Id;
        closestMsp.StartDate__c = todayGmt.addDays(30);
        closestMsp.EndDate__c = todayGmt.addDays(40);
        insert closestMsp;

        Test.startTest();

        ModemServicePlan__c mspToAutoComplete = new ModemServicePlan__c();
        mspToAutoComplete.Modem__c = modem.Id;
        mspToAutoComplete.ServicePlan__c = sp.Id;
        mspToAutoComplete.StartDate__c = todayGmt;

        try {
            insert mspToAutoComplete;
        }
        catch (DmlException e) {
            System.assert(false);
        }

        Map<Id, ModemServicePlan__c> mspsRetrieved = new Map<Id, ModemServicePlan__c>([SELECT Name, Id, 
                                                                                    EndDate__c, 
                                                                                    StartDate__c, 
                                                                                    Modem__c, 
                                                                                    ServicePlan__c 
                                                                                    FROM ModemServicePlan__c]);
        mspToAutoComplete = mspsRetrieved.get(mspToAutoComplete.Id);

        System.assertEquals(closestMsp.StartDate__c.addDays(-1), mspToAutoComplete.EndDate__c);
    }

    
    static testMethod void testUpdateUsageDataActiveMsp() 
    { 
        SNG_MockCustomSettings.initialize(); 
        
        Account account = SNG_TestUtilities.insertAccount('testAccount'); 
        Modem__c modem = SNG_TestUtilities.insertEquipment('terminal', SNG_MockUsageServiceHttpCallout.SUNNY_DAY_MAC_ADDRESS_NO_DATA, 
                                                            account, true); 
        ServicePlan__c servicePlan = SNG_TestUtilities.insertServicePlan(account, true); 
        ModemServicePlan__c msp = SNG_TestUtilities.insertModemServicePlan(modem, servicePlan); 
        
        msp = [SELECT Id, Name, GbDownloaded__c, GbUploaded__c, GbTotal__c, ServicePlan__c,
                ServicePlan__r.GbTotal__c, ServicePlan__r.GbUploaded__c, ServicePlan__r.GbDownloaded__c,
                ServicePlan__r.Name, Modem__r.Name, StartDate__c, EndDate__c FROM ModemServicePlan__c WHERE Id = :msp.Id];

        Test.startTest(); 
        Test.setMock(HttpCalloutMock.class, new SNG_MockUsageServiceHttpCallout());
        
        updateUsageData(msp);
        
        System.assertEquals(SNG_SpUsageAggregateUpdater.ZERO_STR, msp.GbDownloaded__c);
        System.assertEquals(SNG_SpUsageAggregateUpdater.ZERO_STR, msp.GbUploaded__c);
        System.assertEquals(SNG_SpUsageAggregateUpdater.ZERO_STR, msp.GbTotal__c);
        
        Test.stopTest(); 
    }
    
   
    static testMethod void testUpdateUsageDataPartiallyActiveMsp() 
    { 
        SNG_MockCustomSettings.initialize(); 
        
        Account account = SNG_TestUtilities.insertAccount('testAccount'); 
        Modem__c modem = SNG_TestUtilities.insertEquipment('terminal', SNG_MockUsageServiceHttpCallout.SUNNY_DAY_MAC_ADDRESS_NO_DATA, 
                                                            account, true);         
        Date todayGmt = SNG_DateUtils.todayGmt();
        Date spStartDate = today.toStartOfMonth().addDays(-2);
        Date spEndDate = today.toStartOfMonth().addDays(2); 
        
        ServicePlan__c servicePlan = SNG_TestUtilities.insertServicePlan(account, SNG_TestUtilities.insertServicePlanType(true), 
                                                                            spStartDate, spEndDate); 
        
        ModemServicePlan__c msp = SNG_TestUtilities.insertModemServicePlan(modem, servicePlan);
        
        msp = [SELECT Id, Name, GbDownloaded__c, GbUploaded__c, GbTotal__c, ServicePlan__c,
                ServicePlan__r.GbTotal__c, ServicePlan__r.GbUploaded__c, ServicePlan__r.GbDownloaded__c,
                ServicePlan__r.Name, Modem__r.Name, StartDate__c, EndDate__c FROM ModemServicePlan__c WHERE Id = :msp.Id];

        Test.startTest(); 
        Test.setMock(HttpCalloutMock.class, new SNG_MockUsageServiceHttpCallout());
        
        updateUsageData(msp); 
        
        System.assertEquals(SNG_SpUsageAggregateUpdater.ZERO_STR, msp.GbDownloaded__c);
        System.assertEquals(SNG_SpUsageAggregateUpdater.ZERO_STR, msp.GbUploaded__c);
        System.assertEquals(SNG_SpUsageAggregateUpdater.ZERO_STR, msp.GbTotal__c);
        
        Test.stopTest(); 
    }

    static testMethod void testMspStartOnOtherMspEndDate()
    {
        SNG_MockCustomSettings.initialize();

        Account account = SNG_TestUtilities.insertAccount('testAccount'); 
        Modem__c modem = SNG_TestUtilities.insertEquipment('terminal', SNG_MockUsageServiceHttpCallout.SUNNY_DAY_MAC_ADDRESS_NO_DATA, 
                                                            account, true);

        // Create 1 MSP successfully...
        Date todayGmt = SNG_DateUtils.todayGmt();
        Date sp1StartDate = today.toStartOfMonth().addDays(-2);
        Date sp1EndDate = today.toStartOfMonth().addDays(2);
        ServicePlan__c servicePlan1 = SNG_TestUtilities.insertServicePlan(account, SNG_TestUtilities.insertServicePlanType(true), 
                                                                            sp1StartDate, sp1EndDate); 
        ModemServicePlan__c msp1 = SNG_TestUtilities.insertModemServicePlan(modem, servicePlan1);

        // Prepare for creation of 2nd MSP...
        Date sp2StartDate = today.toStartOfMonth().addDays(2);
        Date sp2EndDate = today.toStartOfMonth().addDays(4);
        ServicePlan__c servicePlan2 = SNG_TestUtilities.insertServicePlan(account, SNG_TestUtilities.insertServicePlanType(true), 
                                                                            sp2StartDate, sp2EndDate);
        // Attempt to create 2nd MSP with start date on MSP1's end date. This should fail.
        try
        {
            ModemServicePlan__c msp2 = SNG_TestUtilities.insertModemServicePlan(modem, servicePlan2);
            System.assert(false);
        }
        catch (DmlException e)
        {
            System.assert(e.getMessage().toLowerCase().contains('date'));
        }
        catch (Exception e)
        {
            System.assert(false);
        }
    }
    
    private static ServicePlan__c createServicePlan(Account account, Date startDate, Date endDate, Product2 servicePlanType, String salesOrder)
    {
        ServicePlan__c servicePlan = new ServicePlan__c(); 
        
        servicePlan.StartDate__c = startDate;
        servicePlan.EndDate__c = endDate; 
        servicePlan.Account__c = account.Id;
        servicePlan.SalesOrder__c = salesOrder;
        servicePlan.ServicePlanType__r = servicePlanType;
        servicePlan.ServicePlanType__c = servicePlanType.Id;
        
        insert servicePlan;
        return servicePlan;
    }

    
    private static ModemServicePlan__c insertMSP(Date startDate, Date endDate) {
        Modem__c modem = SNG_TestUtilities.insertEquipment(true);
        ServicePlan__c sp = SNG_TestUtilities.insertServicePlan(modem.Account__r, SNG_TestUtilities.insertServicePlanType(true), startDate, endDate);
        return SNG_TestUtilities.insertModemServicePlan(modem, sp);
    }
    
    private static void updateUsageData(ModemServicePlan__c msp) {
        SNG_ModemServicePlan.updateUsageData(new ServicePlan__c[] { msp.ServicePlan__r }, new ModemServicePlan__c[] { msp });
    }
    
    
    //******************************************************************************
    // TEST SNG_ModemServicePlanMove (SNG_ModemServicePlanMoveUnitTest)
    //******************************************************************************
 
    static testMethod void movedMspSunnyDayNoAccountChange() {
        
        SNG_MockCustomSettings.initialize();

        // Set up SObjects for testing
        Account account = SNG_TestUtilities.insertAccount('account_1');
        Terminal__c terminal = SNG_TestUtilities.insertTerminal(account, '1111111', '1234561');

        Modem__c modem = SNG_TestUtilities.insertModem('00:a0:bc:ff:ff:11', account, terminal);
        
        Date todayGmt = SNG_DateUtils.todayGmt();
        ServicePlan__c servicePlan_1 =  SNG_TestUtilities.createServicePlan(account, todayGmt.addYears(-1), 
                                                            SNG_DateUtils.todayGmt().addYears(1), 
                                                            SNG_TestUtilities.insertServicePlanType(true), 
                                                            '1111111');
        ServicePlan__c servicePlan_2 =  SNG_TestUtilities.createServicePlan(account, todayGmt.addYears(-1), 
                                                            SNG_DateUtils.todayGmt().addYears(1), 
                                                            SNG_TestUtilities.insertServicePlanType(true), 
                                                            '2222222');

        ModemServicePlan__c overlappingMspToBeShifted = SNG_TestUtilities.createModemServicePlan(modem, servicePlan_1, todayGmt.addDays(-10), todayGmt.addDays(-5));

        ModemServicePlan__c futureMsp = SNG_TestUtilities.createModemServicePlan(modem, servicePlan_1, todayGmt.addDays(20), todayGmt.addDays(25));

        ModemServicePlan__c movedMsp = SNG_TestUtilities.createModemServicePlan(modem, servicePlan_2, todayGmt.addDays(-7), todayGmt.addDays(5));

        // Insert MSPs to ready database for testing
        List<ModemServicePlan__c> setupMspDatabase = new List<ModemServicePlan__c>();
        setupMspDatabase.add(overlappingMspToBeShifted);
        setupMspDatabase.add(futureMsp);
        insert setupMspDatabase;

        // Moved MSP insertion validation
        Test.startTest();

        try { 
            insert movedMsp;
        }
        catch (DmlException e) {
            System.assert(false);
        }

        // Retrieve all MSP
        Map<Id, ModemServicePlan__c> allMsps = new Map<Id, ModemServicePlan__c> ([SELECT Id, Name, StartDate__c, 
                                                                                EndDate__c, Modem__c, ServicePlan__c
                                                                                FROM ModemServicePlan__c]);

        System.assertEquals(3, allMsps.size());

        overlappingMspToBeShifted = allMsps.get(overlappingMspToBeShifted.Id);
        futureMsp = allMsps.get(futureMsp.Id);
        movedMsp = allMsps.get(movedMsp.Id);

        // overlappingMspToBeShifted Start Date should be same, with end Date shifted 
        System.assertEquals(SNG_DateUtils.todayGmt().addDays(-10), overlappingMspToBeShifted.StartDate__c);
        System.assertEquals(movedMsp.StartDate__c.addDays(-1), overlappingMspToBeShifted.EndDate__c);

        // futureMsp should remain the same
        System.assertEquals(todayGmt.addDays(20), futureMsp.StartDate__c);
        System.assertEquals(todayGmt.addDays(25), futureMsp.EndDate__c);
    }   

    static testMethod void movedMspSunnyDayAccountChange() {

        SNG_MockCustomSettings.initialize();

        Account originAccount = SNG_TestUtilities.insertAccount('account_1');
        Account movedAccount = SNG_TestUtilities.insertAccount('account_2');

        Terminal__c terminal = SNG_TestUtilities.insertTerminal(originAccount, '1111111', '1234561');

        Modem__c modem = SNG_TestUtilities.insertModem('00:a0:bc:ff:ff:11', originAccount, terminal);

        Date todayGmt = SNG_DateUtils.todayGmt();
        ServicePlan__c originServicePlan_1 = SNG_TestUtilities.createServicePlan(originAccount, todayGmt.addYears(-1), todayGmt.addYears(1), 
                                                            SNG_TestUtilities.insertServicePlanType(true), '1111111');

        ServicePlan__c originServicePlan_2 = SNG_TestUtilities.createServicePlan(originAccount, todayGmt.addYears(-1), todayGmt.addYears(1), 
                                                            SNG_TestUtilities.insertServicePlanType(true), '2222222');

        ServicePlan__c movedServicePlan = SNG_TestUtilities.createServicePlan(movedAccount, todayGmt.addYears(-1), todayGmt.addYears(1), 
                                                            SNG_TestUtilities.insertServicePlanType(true), '3333333');

        ModemServicePlan__c overlappingMspToBeShifted = SNG_TestUtilities.createModemServicePlan(modem, originServicePlan_1, todayGmt.addDays(-10), todayGmt.addDays(-5));

        ModemServicePlan__c futureMsp_1 = SNG_TestUtilities.createModemServicePlan(modem, originServicePlan_2, todayGmt.addDays(20), todayGmt.addDays(25));

        ModemServicePlan__c futureMsp_2 = SNG_TestUtilities.createModemServicePlan(modem, originServicePlan_1, todayGmt.addDays(1), todayGmt.addDays(3));

        ModemServicePlan__c movedMsp = SNG_TestUtilities.createModemServicePlan(modem, movedServicePlan, todayGmt.addDays(-7), todayGmt.addDays(5));
    
        insert overlappingMspToBeShifted;
        insert futureMsp_1;
        insert futureMsp_2;

        // Moved MSP insertion validation
        Test.startTest();

        try {
            insert movedMsp;
        }
        catch(DmlException e) {
            System.debug(e.getMessage());
            System.assert(false);
        }

        // Retrieve all MSP
        Map<Id, ModemServicePlan__c> allMsps = new Map<Id, ModemServicePlan__c> ([SELECT Id, Name, StartDate__c, 
                                                                                EndDate__c, Modem__c, Modem__r.Account__c,
                                                                                ServicePlan__c, ServicePlan__r.Account__c
                                                                                FROM ModemServicePlan__c]);

        System.assertEquals(2, allMsps.size());

        overlappingMspToBeShifted = allMsps.get(overlappingMspToBeShifted.Id);
        movedMsp = allMsps.get(movedMsp.Id);

        System.assertEquals(movedMsp.StartDate__c.addDays(-1), overlappingMspToBeShifted.EndDate__c);
        System.assertEquals(movedAccount.Id, overlappingMspToBeShifted.Modem__r.Account__c);
        System.assertEquals(originAccount.Id, overlappingMspToBeShifted.ServicePlan__r.Account__c);

        System.assertEquals(SNG_DateUtils.todayGmt().addDays(-7), movedMsp.StartDate__c);
        System.assertEquals(SNG_DateUtils.todayGmt().addDays(5), movedMsp.EndDate__c);
    }

    static testMethod void validMoveMspStartDateOnOverlapMspEndDate() { 

        SNG_MockCustomSettings.initialize();

        Account originAccount = SNG_TestUtilities.insertAccount('account_1');
        Account movedAccount = SNG_TestUtilities.insertAccount('account_2');

        Terminal__c terminal = SNG_TestUtilities.insertTerminal(originAccount, '1111111', '1234561');

        Modem__c modem = SNG_TestUtilities.insertModem('00:a0:bc:ff:ff:11', originAccount, terminal);

        Date todayGmt = SNG_DateUtils.todayGmt();
        ServicePlan__c originServicePlan_1 = SNG_TestUtilities.createServicePlan(originAccount, todayGmt.addYears(-1), todayGmt.addYears(1), 
                                                            SNG_TestUtilities.insertServicePlanType(true), '1111111');

        ServicePlan__c originServicePlan_2 = SNG_TestUtilities.createServicePlan(originAccount, todayGmt.addYears(-1), todayGmt.addYears(1), 
                                                            SNG_TestUtilities.insertServicePlanType(true), '2222222');

        ServicePlan__c movedServicePlan = SNG_TestUtilities.createServicePlan(movedAccount, todayGmt.addYears(-1), todayGmt.addYears(1), 
                                                            SNG_TestUtilities.insertServicePlanType(true), '3333333');

        ModemServicePlan__c overlappingMspToBeShifted = SNG_TestUtilities.createModemServicePlan(modem, originServicePlan_1, todayGmt.addDays(-10), todayGmt.addDays(-5));

        ModemServicePlan__c futureMsp_1 = SNG_TestUtilities.createModemServicePlan(modem, originServicePlan_2, todayGmt.addDays(20), todayGmt.addDays(25));

        ModemServicePlan__c movedMsp = SNG_TestUtilities.createModemServicePlan(modem, movedServicePlan, todayGmt.addDays(-5), todayGmt.addDays(5));

        insert overlappingMspToBeShifted;
        insert futureMsp_1;

        Test.startTest();

        try {
            insert movedMsp;
        }
        catch (DmlException e){
            System.assert(false);
        }

        // Retrieve all MSP
        Map<Id, ModemServicePlan__c> allMsps = new Map<Id, ModemServicePlan__c> ([SELECT Id, Name, StartDate__c, 
                                                                                EndDate__c, Modem__c, Modem__r.Account__c,
                                                                                ServicePlan__c, ServicePlan__r.Account__c
                                                                                FROM ModemServicePlan__c]);
        // futureMsp_1 should have been deleted
        System.assertEquals(2, allMsps.size());

        ModemServicePlan__c modifiedOverlappingMsp = allMsps.get(overlappingMspToBeShifted.Id);
        movedMsp = allMsps.get(movedMsp.Id);

        System.assertEquals(todayGmt.addDays(-5), movedMsp.StartDate__c);
        System.assertEquals(todayGmt.addDays(5), movedMsp.EndDate__c);

        // overlapping msp's end date should be one day less than movedMsp's start date
        System.assertEquals(movedMsp.StartDate__c.addDays(-1), modifiedOverlappingMsp.EndDate__c);
        System.assertEquals(todayGmt.addDays(-10), modifiedOverlappingMsp.StartDate__c);

        System.assert(!allMsps.containsKey(futureMsp_1.Id));
    }

    static testMethod void validMoveOverlapMspEncompassesMovedMsp () { 

        SNG_MockCustomSettings.initialize();

        Account originAccount = SNG_TestUtilities.insertAccount('account_1');
        Account movedAccount = SNG_TestUtilities.insertAccount('account_2');
        
        Terminal__c terminal = SNG_TestUtilities.insertTerminal(originAccount, '1111111', '1234561');
        Modem__c modem = SNG_TestUtilities.insertModem('00:a0:bc:ff:ff:11', originAccount, terminal);

        Date todayGmt = SNG_DateUtils.todayGmt();
        ServicePlan__c originServicePlan = SNG_TestUtilities.createServicePlan(originAccount, todayGmt.addYears(-1), todayGmt.addYears(1), 
                                                            SNG_TestUtilities.insertServicePlanType(true), '2222222');

        ServicePlan__c movedServicePlan = SNG_TestUtilities.createServicePlan(movedAccount, todayGmt.addYears(-1), todayGmt.addYears(1), 
                                                            SNG_TestUtilities.insertServicePlanType(true), '3333333');

        ModemServicePlan__c overlappingMspToBeShifted = SNG_TestUtilities.createModemServicePlan(modem, originServicePlan, todayGmt.addDays(-10), todayGmt.addDays(10));

        ModemServicePlan__c futureMsp = SNG_TestUtilities.createModemServicePlan(modem, originServicePlan, todayGmt.addDays(20), todayGmt.addDays(25));

        ModemServicePlan__c movedMsp = SNG_TestUtilities.createModemServicePlan(modem, movedServicePlan, todayGmt.addDays(-5), todayGmt.addDays(5));

        insert overlappingMspToBeShifted;
        insert futureMsp;

        Test.startTest();

        try { 
            insert movedMsp;
        }
        catch (DmlException e) {
            System.assert(false);
        }

        // Retrieve all MSP
        Map<Id, ModemServicePlan__c> allMsps = new Map<Id, ModemServicePlan__c> ([SELECT Id, Name, StartDate__c, 
                                                                                EndDate__c, Modem__c, Modem__r.Account__c,
                                                                                ServicePlan__c, ServicePlan__r.Account__c
                                                                                FROM ModemServicePlan__c]);

        System.assertEquals(2, allMsps.size());
        System.assert(allMsps.containsKey(movedMsp.Id));
        System.assert(!allMsps.containsKey(futureMsp.Id));
    }

    static testMethod void moveFailNoAccountChangeConflictFuture() {

        SNG_MockCustomSettings.initialize();

        Account account = SNG_TestUtilities.insertAccount('account_1');
        Terminal__c terminal = SNG_TestUtilities.insertTerminal(account, '1111111', '1234561');
        Modem__c modem = SNG_TestUtilities.insertModem('00:a0:bc:ff:ff:11', account, terminal);

        Date todayGmt = SNG_DateUtils.todayGmt();
        ServicePlan__c servicePlan_1 = SNG_TestUtilities.createServicePlan(account, todayGmt.addYears(-1), todayGmt.addYears(1), 
                                                            SNG_TestUtilities.insertServicePlanType(true), '1111111');

        ServicePlan__c servicePlan_2 = SNG_TestUtilities.createServicePlan(account, todayGmt.addYears(-1), todayGmt.addYears(1), 
                                                            SNG_TestUtilities.insertServicePlanType(true), '2222222');

        ModemServicePlan__c overlappingMsp =  SNG_TestUtilities.createModemServicePlan(modem, servicePlan_1, todayGmt.addDays(-10), todayGmt.addDays(-5));

        ModemServicePlan__c futureMspConflicting = SNG_TestUtilities.createModemServicePlan(modem, servicePlan_2, todayGmt.addDays(10), todayGmt.addDays(15));

        ModemServicePlan__c movedMsp = SNG_TestUtilities.createModemServicePlan(modem, servicePlan_2, todayGmt.addDays(11), todayGmt.addDays(12));

        insert overlappingMsp;
        insert futureMspConflicting;

        Test.startTest();

        // insert movedMsp fails b/c no account change and overlaps with future MSP
        try { 
            insert movedMsp;
            System.assert(false);
        }
        catch (DmlException e) {
            System.assert(true);
        }
    }

    static testMethod void moveFailAccountChangeEncompassOldOrActiveMsp() {
        
        SNG_MockCustomSettings.initialize();

        Account originAccount = SNG_TestUtilities.insertAccount('account_1');
        Account movedAccount = SNG_TestUtilities.insertAccount('account_2');        

        Terminal__c terminal = SNG_TestUtilities.insertTerminal(originAccount, '1111111', '1234561');
        Modem__c modem = SNG_TestUtilities.insertModem('00:a0:bc:ff:ff:11', originAccount, terminal);

        Date todayGmt = SNG_DateUtils.todayGmt();
        ServicePlan__c originServicePlan_1 = SNG_TestUtilities.createServicePlan(originAccount, todayGmt.addYears(-1), todayGmt.addYears(1), 
                                                            SNG_TestUtilities.insertServicePlanType(true), '1111111');

        ServicePlan__c originServicePlan_2 = SNG_TestUtilities.createServicePlan(originAccount, todayGmt.addYears(-1), todayGmt.addYears(1), 
                                                            SNG_TestUtilities.insertServicePlanType(true), '2222222');

        ServicePlan__c movedServicePlan = SNG_TestUtilities.createServicePlan(movedAccount, todayGmt.addYears(-1), todayGmt.addYears(1), 
                                                            SNG_TestUtilities.insertServicePlanType(true), '3333333');  
    
        ModemServicePlan__c overlappingMspToBeShifted = SNG_TestUtilities.createModemServicePlan(modem, originServicePlan_1, todayGmt.addDays(-10), todayGmt.addDays(-5));

        ModemServicePlan__c futureMsp_1 = SNG_TestUtilities.createModemServicePlan(modem, originServicePlan_2, todayGmt.addDays(20), todayGmt.addDays(25));

        ModemServicePlan__c encompassingMsp = SNG_TestUtilities.createModemServicePlan(modem, originServicePlan_1, todayGmt.addDays(-2), todayGmt.addDays(3));

        ModemServicePlan__c movedMsp = SNG_TestUtilities.createModemServicePlan(modem, movedServicePlan, todayGmt.addDays(-7), todayGmt.addDays(5));

        insert overlappingMspToBeShifted;
        insert futureMsp_1;
        insert encompassingMsp;

        Test.startTest();

        try { 
            insert movedMsp;
            System.assert(false);
        }
        catch (DmlException e) { 
            System.assert(true);
        }
    }

    static testMethod void notMoveMspNoServicePlanChange() {

        SNG_MockCustomSettings.initialize();

        Account account = SNG_TestUtilities.insertAccount('account_1');
        Terminal__c terminal = SNG_TestUtilities.insertTerminal(account, '1111111', '1234561');
        Modem__c modem = SNG_TestUtilities.insertModem('00:a0:bc:ff:ff:11', account, terminal);

        Date todayGmt = SNG_DateUtils.todayGmt();
        ServicePlan__c servicePlan_1 = SNG_TestUtilities.createServicePlan(account, todayGmt.addYears(-1), todayGmt.addYears(1), 
                                                            SNG_TestUtilities.insertServicePlanType(true), '1111111');

        ServicePlan__c servicePlan_2 = SNG_TestUtilities.createServicePlan(account, todayGmt.addYears(-1), todayGmt.addYears(1), 
                                                            SNG_TestUtilities.insertServicePlanType(true), '2222222');

        ModemServicePlan__c overlappingMspToBeShifted = SNG_TestUtilities.createModemServicePlan(modem, servicePlan_1, todayGmt.addDays(-10), todayGmt.addDays(-5));

        ModemServicePlan__c futureMsp_1 = SNG_TestUtilities.createModemServicePlan(modem, servicePlan_2, todayGmt.addDays(20), todayGmt.addDays(25));

        ModemServicePlan__c movedMsp = SNG_TestUtilities.createModemServicePlan(modem, servicePlan_1, todayGmt.addDays(-7), todayGmt.addDays(5));

        insert overlappingMspToBeShifted;
        insert futureMsp_1;

        Test.startTest();

        try { 
            insert movedMsp;
            System.assert(false);
        }
        catch (DmlException e) {
            System.assert(true);
        }

        // Retrieve all MSP
        Map<Id, ModemServicePlan__c> allMsps = new Map<Id, ModemServicePlan__c> ([SELECT Id, Name, StartDate__c, 
                                                                                EndDate__c, Modem__c, Modem__r.Account__c,
                                                                                ServicePlan__c, ServicePlan__r.Account__c
                                                                                FROM ModemServicePlan__c]);

        System.assertEquals(2, allMsps.size());

        for (ModemServicePlan__c msp : allMsps.values())
        {
            if (msp.Id == overlappingMspToBeShifted.Id) {
                System.assert(true);
            }
            else if (msp.Id == futureMsp_1.Id) {
                System.assert(true);
            }
            else {
                System.assert(false);
            }
        }
    } 

    static testMethod void oneDayMspOnMoveMspStartDateAccountChangeRegularInsert() {

        SNG_MockCustomSettings.initialize();

        Account originAccount = SNG_TestUtilities.insertAccount('account_1');
        Account movedAccount = SNG_TestUtilities.insertAccount('account_2');
        Terminal__c terminal = SNG_TestUtilities.insertTerminal(originAccount, '1111111', '1234561');
        Modem__c modem = SNG_TestUtilities.insertModem('00:a0:bc:ff:ff:11', originAccount, terminal);

        Date todayGmt = SNG_DateUtils.todayGmt();
        ServicePlan__c servicePlan_1 = SNG_TestUtilities.createServicePlan(originAccount, todayGmt.addYears(-1), todayGmt.addYears(1), 
                                                            SNG_TestUtilities.insertServicePlanType(true), '1111111');

        ServicePlan__c servicePlan_2 = SNG_TestUtilities.createServicePlan(movedAccount, todayGmt.addYears(-1), todayGmt.addYears(1), 
                                                            SNG_TestUtilities.insertServicePlanType(true), '2222222');

        ModemServicePlan__c overlappingMsp = SNG_TestUtilities.createModemServicePlan(modem, servicePlan_1, todayGmt.addDays(-5), todayGmt.addDays(-5));

        ModemServicePlan__c movedMsp = SNG_TestUtilities.createModemServicePlan(modem, servicePlan_2, todayGmt.addDays(-5), todayGmt.addDays(5));

        insert overlappingMsp;

        Test.startTest();

        try {
            insert movedMsp;            // Regular insert, fail due to Modem and servicePlan_2 being different accounts
            System.assert(false);
        }
        catch (DmlException e) {
            System.assert(true);
        }

        // Retrieve all MSP
        Map<Id, ModemServicePlan__c> allMsps = new Map<Id, ModemServicePlan__c> ([SELECT Id, Name, StartDate__c, 
                                                                                EndDate__c, Modem__c, Modem__r.Account__c,
                                                                                ServicePlan__c, ServicePlan__r.Account__c
                                                                                FROM ModemServicePlan__c]);

        System.assertEquals(1, allMsps.size());
    }


    @isTest
    static void movedMspAutoCompleteEndDate() { 

        SNG_MockCustomSettings.initialize();

        Account originAccount = SNG_TestUtilities.insertAccount('account_1');
        Account movedAccount = SNG_TestUtilities.insertAccount('account_2');
        Terminal__c terminal = SNG_TestUtilities.insertTerminal(originAccount, '1111111', '1234561');
        Modem__c modem = SNG_TestUtilities.insertModem('00:a0:bc:ff:ff:11', originAccount, terminal);

        Date todayGmt = SNG_DateUtils.todayGmt();

        ServicePlan__c servicePlan_1 = SNG_TestUtilities.createServicePlan(originAccount, todayGmt.addYears(-1), todayGmt.addYears(1), 
                                                            SNG_TestUtilities.insertServicePlanType(true), '1111111');

        ServicePlan__c servicePlan_2 = SNG_TestUtilities.createServicePlan(movedAccount, todayGmt.addYears(-1), todayGmt.addYears(3), 
                                                            SNG_TestUtilities.insertServicePlanType(true), '2222222');

        ModemServicePlan__c originalMsp = SNG_TestUtilities.createModemServicePlan(modem, servicePlan_1, 
                                                                                    todayGmt.addDays(-10), todayGmt.addDays(1));

        ModemServicePlan__c movedMsp = SNG_TestUtilities.createModemServicePlan(modem, servicePlan_2, 
                                                                                    todayGmt.addDays(-5), todayGmt.addDays(5));

        ModemServicePlan__c futureMsp = SNG_TestUtilities.createModemServicePlan(modem, servicePlan_1, todayGmt.addDays(20), todayGmt.addDays(25));

        insert originalMsp; 
        insert futureMsp;

        Test.startTest();

        try {
            movedMsp.EndDate__c = null; 
            insert movedMsp;
        }
        catch (DmlException e) {
            System.assert(false);
        }

        // Retrieve all MSP
        Map<Id, ModemServicePlan__c> allMsps = new Map<Id, ModemServicePlan__c> ([SELECT Id, Name, StartDate__c, 
                                                                                EndDate__c, Modem__c, Modem__r.Account__c,
                                                                                ServicePlan__c, ServicePlan__r.Account__c
                                                                                FROM ModemServicePlan__c]);

        System.assertEquals(2, allMsps.size());
        System.assertEquals(todayGmt.addDays(-6), allMsps.get(originalMsp.Id).EndDate__c);
        System.assertEquals(todayGmt.addYears(3), allMsps.get(movedMsp.Id).EndDate__c);
    }

    // PBSBOOK-990 bug fix
    @isTest
    static void attemptMultipleMoveMspWithSameModem() { 

        SNG_MockCustomSettings.initialize();

        Account originAccount = SNG_TestUtilities.insertAccount('account_1');
        Account movedAccount = SNG_TestUtilities.insertAccount('account_2');
        Terminal__c terminal = SNG_TestUtilities.insertTerminal(originAccount, '1111111', '1234561');
        Modem__c modem = SNG_TestUtilities.insertModem('00:a0:bc:ff:ff:11', originAccount, terminal);

        Date todayGmt = SNG_DateUtils.todayGmt();

        ServicePlan__c servicePlan_1 = SNG_TestUtilities.createServicePlan(originAccount, todayGmt.addYears(-1), todayGmt.addYears(1), 
                                                            SNG_TestUtilities.insertServicePlanType(true), '1111111');

        ServicePlan__c servicePlan_2 = SNG_TestUtilities.createServicePlan(movedAccount, todayGmt.addYears(-1), todayGmt.addYears(1), 
                                                            SNG_TestUtilities.insertServicePlanType(true), '2222222');

        ServicePlan__c servicePlan_3 = SNG_TestUtilities.createServicePlan(movedAccount, todayGmt.addYears(-1), todayGmt.addYears(1), 
                                                            SNG_TestUtilities.insertServicePlanType(true), '3333333');

        ModemServicePlan__c originalMsp = SNG_TestUtilities.createModemServicePlan(modem, servicePlan_1, 
                                                                                    todayGmt.addDays(-10), todayGmt.addDays(1));

        ModemServicePlan__c firstMovedMsp = SNG_TestUtilities.createModemServicePlan(modem, servicePlan_2, 
                                                                                    todayGmt.addDays(-5), todayGmt.addDays(4));

        ModemServicePlan__c secondMovedMsp = SNG_TestUtilities.createModemServicePlan(modem, servicePlan_3, 
                                                                                        todayGmt.addDays(-7), todayGmt.addDays(2));

        insert originalMsp;

        Test.startTest();

        List<ModemServicePlan__c> movedMspsToInsert = new List<ModemServicePlan__c>();
        movedMspsToInsert.add(firstMovedMsp);
        movedMspsToInsert.add(secondMovedMsp);

        try { 
            insert movedMspsToInsert;
            System.assert(false);
        }
        catch (DmlException e) {
            System.assert(true);
            System.assertEquals(StatusCode.FIELD_CUSTOM_VALIDATION_EXCEPTION, e.getDmlType(0));
            final String dmlMessageLowerCase = e.getDmlMessage(0).toLowerCase();
            System.assert(dmlMessageLowerCase.contains('cannot be created'));
            System.assert(dmlMessageLowerCase.contains('conflicts'));
        }

        Map<Id, ModemServicePlan__c> allMsps = new Map<Id, ModemServicePlan__c> ([SELECT Id, Name, StartDate__c, 
                                                                                EndDate__c, Modem__c, Modem__r.Account__c,
                                                                                ServicePlan__c, ServicePlan__r.Account__c
                                                                                FROM ModemServicePlan__c]);

        System.assertEquals(1, allMsps.size());
        System.assertEquals(todayGmt.addDays(1), allMsps.get(originalMsp.Id).EndDate__c);
    }

    @isTest
    static void attemptMspMoveModemNoTerminal() { 

        SNG_MockCustomSettings.initialize();

        Account originAccount = SNG_TestUtilities.insertAccount('account_1');
        Account movedAccount = SNG_TestUtilities.insertAccount('account_2');
        Terminal__c terminal = SNG_TestUtilities.insertTerminal(originAccount, '1111111', '1234561');
        Modem__c modem = SNG_TestUtilities.insertModem('00:a0:bc:ff:ff:11', originAccount, terminal);

        // deassociate terminal from modem
        modem.Terminal__c = null;
        update modem;

        Date todayGmt = SNG_DateUtils.todayGmt();

        ServicePlan__c servicePlan_1 = SNG_TestUtilities.createServicePlan(originAccount, todayGmt.addYears(-1), todayGmt.addYears(1), 
                                                            SNG_TestUtilities.insertServicePlanType(true), '1111111');

        ServicePlan__c servicePlan_2 = SNG_TestUtilities.createServicePlan(movedAccount, todayGmt.addYears(-1), todayGmt.addYears(1), 
                                                            SNG_TestUtilities.insertServicePlanType(true), '2222222');

        ModemServicePlan__c originalMsp = SNG_TestUtilities.createModemServicePlan(modem, servicePlan_1, 
                                                                                    todayGmt.addDays(-10), todayGmt.addDays(-1));

        ModemServicePlan__c movedMsp = SNG_TestUtilities.createModemServicePlan(modem, servicePlan_2, 
                                                                                    todayGmt.addDays(-1), todayGmt.addDays(3));

        insert originalMsp;

        Test.startTest();

        try { 
            insert movedMsp;
            System.assert(false);
        }
        catch (DmlException e)
        {
            System.assertEquals(StatusCode.FIELD_CUSTOM_VALIDATION_EXCEPTION, e.getDmlType(0));
            final String dmlMessageLowerCase = e.getDmlMessage(0).toLowerCase();
            System.assert(dmlMessageLowerCase.contains('terminals'));
            System.assert(dmlMessageLowerCase.contains('associated'));
        }

        Map<Id, ModemServicePlan__c> allMsps = new Map<Id, ModemServicePlan__c> ([SELECT Id, Name, StartDate__c, 
                                                                                EndDate__c, Modem__c, Modem__r.Account__c,
                                                                                ServicePlan__c, ServicePlan__r.Account__c
                                                                                FROM ModemServicePlan__c]);
        System.assertEquals(1, allMsps.size());
        System.assertEquals(todayGmt.addDays(-1), allMsps.get(originalMsp.Id).EndDate__c);
    }


    // Note: This is testing the bug found in JIRA issue PBSBOOK-993.
    @isTest
    static void attemptMspMoveWithMspDatesOutsideServicePlan() {
        // Step 1: Setup. Create sObject records needed for test.
        SNG_MockCustomSettings.initialize();

        // Today in GMT
        final Date todayGmt = SNG_DateUtils.todayGmt();

        // Create Service Plan Type
        final Product2 servicePlanType = SNG_TestUtilities.insertServicePlanType(true);

        // Create Accounts
        final Account accountBeforeMove = SNG_TestUtilities.insertAccount('accountBeforeMove');
        final Account accountAfterMove = SNG_TestUtilities.insertAccount('accountAfterMove');

        // Create Terminal, Modem, and Service Plan Type
        final Terminal__c terminalBeforeMove = SNG_TestUtilities.insertTerminal(accountBeforeMove, 'serialNumber_terminalFor00A0BC001122', '1234561');
        final Modem__c modemBeforeMove = SNG_TestUtilities.insertModem(accountBeforeMove, 'partNumber_00A0BC001122', '00:A0:BC:00:11:22', 'serialNumber_00A0BC001122', terminalBeforeMove);

        // Create Service Plans for before and after the move
        final Date spBeforeMoveStartDate = todayGmt.addDays(-12);
        final Date spBeforeMoveEndDate = spBeforeMoveStartDate.addYears(2);
        final Date spAfterMoveStartDate = todayGmt.addDays(4);
        final Date spAfterMoveEndDate = spAfterMoveStartDate.addDays(-7).addYears(2);
        final ServicePlan__c spBeforeMove = SNG_TestUtilities.insertServicePlan(accountBeforeMove, servicePlanType, spBeforeMoveStartDate, spBeforeMoveEndDate);
        final ServicePlan__c spAfterMove = SNG_TestUtilities.insertServicePlan(accountAfterMove, servicePlanType, spAFterMoveStartDate, spAfterMoveEndDate);

        // Create MSP before and after start and end dates
        final Date mspBeforeMoveStartDate = todayGmt.addDays(-11);
        final Date mspBeforeMoveEndDate = mspBeforeMoveStartDate.addDays(-1).addYears(2);
        final Date mspAfterMoveStartDate = todayGmt.addDays(-1);
        final Date mspAfterMoveEndDate = mspAfterMoveStartDate.addDays(7);


        // Step 2: Create the original MSP which we want to be moved.
        final ModemServicePlan__c mspBeforeMove = SNG_TestUtilities.insertModemServicePlan(modemBeforeMove, spBeforeMove, mspBeforeMoveStartDate, mspBeforeMoveEndDate);


        // Step 3: Attempt MSP Move.
        try {
            SNG_TestUtilities.insertModemServicePlan(modemBeforeMove, spAfterMove, mspAfterMoveStartDate, mspAfterMoveEndDate);

            // The insert should not work.
            System.assert(false);
        } catch (DmlException e) {
            // Make sure the exception is a DmlException and what we expect.
            System.assertEquals(1, e.getNumDml());
            System.assertEquals(ModemServicePlan__c.StartDate__c, e.getDmlFields(0)[0]);
            System.assertEquals(StatusCode.FIELD_CUSTOM_VALIDATION_EXCEPTION, e.getDmlType(0));

            // Inspect the dml message to make sure it contains information we expect.
            final String dmlMessageLowerCase = e.getDmlMessage(0).toLowerCase();
            System.assert(dmlMessageLowerCase.contains('service plan'));
            System.assert(dmlMessageLowerCase.contains('date'));
            System.assert(dmlMessageLowerCase.contains(mspAfterMoveStartDate.format()));
            System.assert(dmlMessageLowerCase.contains(spAfterMoveStartDate.format()));
            System.assert(dmlMessageLowerCase.contains(spAfterMoveEndDate.format()));
        } catch(Exception e) {
            // We don't want some other type of Exception to be thrown.
            System.assert(false);
        }


        // Step 4: Make sure step 3 didn't make any Salesforce database changes.
        
        // Get modem after move attempt
        final Modem__c modemAfterMove = [SELECT Account__c, Terminal__c, Terminal__r.Account__c FROM Modem__c WHERE Id = :modemBeforeMove.Id];

        // Modem Account should not have changed.
        System.assertEquals(modemBeforeMove.Account__c, modemAfterMove.Account__c);

        // Terminal should not have changed.
        System.assertEquals(modemBeforeMove.Terminal__c, modemAfterMove.Terminal__c);

        // Terminal Account should not have changed.
        System.assertEquals(terminalBeforeMove.Account__c, modemAfterMove.Terminal__r.Account__c);

        // Old MSP should not have changed.
        final ModemServicePlan__c oldMspAfterMove = [SELECT StartDate__c, EndDate__c, Modem__c, ServicePlan__c FROM ModemServicePlan__c WHERE Id = :mspBeforeMove.Id];
        System.assertEquals(mspBeforeMove.StartDate__c, oldMspAfterMove.StartDate__c);
        System.assertEquals(mspBeforeMove.EndDate__c, oldMspAfterMove.EndDate__c);
        System.assertEquals(mspBeforeMove.Modem__c, oldMspAfterMove.Modem__c);
        System.assertEquals(mspBeforeMove.ServicePlan__c, oldMspAfterMove.ServicePlan__c);
    }


    //******************************************************************************
    // TEST SNG_UTPerformanceFromPerf (SNG_UTPerformanceFromPerfUnitTest)
    //******************************************************************************        
    static testMethod void testGetUTPerformanceSunnyDay() {
        
        // initialize custom settings
        SNG_MockCustomSettings.initialize();
        
        Modem__c modem
            = SNG_TestUtilities.insertEquipment('testEquip', 
                                                SNG_MockUTPerformanceFromPerfHttpCallout.VALID_MAC_ADDRESS, 
                                                'testAccount', 
                                                true);
        Terminal__c terminal = modem.Terminal__r;
        ApexPages.StandardController controller = new ApexPages.StandardController(terminal);
        
        
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new SNG_MockUTPerformanceFromPerfHttpCallout());
        
        //PageReference pageRef = Page.SNG_UTPerformance;
        //Test.setCurrentPage(pageRef);

        SNG_UTPerformanceFromPerf sngUtPerf = new SNG_UTPerformanceFromPerf(controller);
        sngUtPerf.getUTPerformance();
        
        Id terminalId = modem.Terminal__c;
        
        System.assertEquals(terminal.UploadSymbolRateBackEnd__c, 10000.00000);
        System.assertEquals(terminal.DownloadSinrBackEnd__c, 25.70000);
        System.assertEquals(terminal.StatusBackEnd__c, 'Online');
        System.assertEquals(null, terminal.IpAddress__c);
        System.assert(Math.abs(((Long)(Datetime.now().getTime()) - (Long)(parseOnlineTime(terminal.OnlineTime__c))*1000L - 1384284200000L)/1000) < 3);
        Test.stopTest();
    }
    
    static testMethod void testGetUTPerformanceAccessDeniedMacAddress() {
        //PageReference pageRef = Page.SNG_UTPerformance;
        //Test.setCurrentPage(pageRef);
        
        // initialize custom settings
        SNG_MockCustomSettings.initialize();
        
        Modem__c modem
            = SNG_TestUtilities.insertEquipment('testEquip', 
                                                SNG_MockUTPerformanceFromPerfHttpCallout.ACCESS_DENIED_MAC_ADDRESS, 
                                                'testAccount', 
                                                true);
        Terminal__c terminal = modem.Terminal__r;
        ApexPages.StandardController controller = new ApexPages.StandardController(terminal);
        
        
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new SNG_MockUTPerformanceFromPerfHttpCallout());
        
        SNG_UTPerformanceFromPerf sngUtPerf = new SNG_UTPerformanceFromPerf(controller);
        sngUtPerf.getUTPerformance();
        
        Id terminalId = modem.Terminal__c;
        
        System.assertEquals(terminal.UploadSymbolRateBackEnd__c, 0);
        System.assertEquals(terminal.DownloadSinrBackEnd__c, 0);
        System.assertEquals(terminal.StatusBackEnd__c, SNG_TerminalQuery.UNABLE_TO_LOAD);
        System.assertEquals(null, terminal.IpAddress__c);
        System.assertEquals(terminal.OnlineTime__c, SNG_TerminalQuery.UNABLE_TO_LOAD);
        Test.stopTest();
    }
    
    static testMethod void testGetUTPerformanceNoLinkToMacAddress()
    {
        // initialize custom settings
        SNG_MockCustomSettings.initialize();
        
        Terminal__c terminal = SNG_TestUtilities.insertTerminal(SNG_TestUtilities.insertAccount('accountName'), 'serialNum', '1234561');       
        Test.setCurrentPageReference(new PageReference('/apex/SNGTerminalDetail?id=' + terminal.Id));

        ApexPages.StandardController controller = new ApexPages.StandardController(terminal);
        SNG_UTPerformanceFromPerf sngUtPerf = new SNG_UTPerformanceFromPerf(controller);
        sngUtPerf.getUTPerformance();
        
        System.assert(isTextContainedInApexPageMessages('MAC address to get performance data is NULL.'));
    }
    
    static testMethod void testGetUTPerformanceZeroResults() {
        // initialize custom settings
        SNG_MockCustomSettings.initialize();
        
        Modem__c modem
            = SNG_TestUtilities.insertEquipment('testEquip', 
                                                SNG_MockUTPerformanceFromPerfHttpCallout.ZERO_RESULTS_MAC_ADDRESS, 
                                                'testAccount', 
                                                true);
        Terminal__c terminal = modem.Terminal__r;
        ApexPages.StandardController controller = new ApexPages.StandardController(terminal);
        
        
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new SNG_MockUTPerformanceFromPerfHttpCallout());
        
        SNG_UTPerformanceFromPerf sngUtPerf = new SNG_UTPerformanceFromPerf(controller);
        sngUtPerf.getUTPerformance();
        
        Id terminalId = modem.Terminal__c;
        
        System.assertEquals(terminal.UploadSymbolRateBackEnd__c, 0);
        System.assertEquals(terminal.DownloadSinrBackEnd__c, 0);
        System.assertEquals(terminal.StatusBackEnd__c, SNG_TerminalQuery.UNABLE_TO_LOAD);
        System.assertEquals(null, terminal.IpAddress__c);
        System.assertEquals(terminal.OnlineTime__c, SNG_TerminalQuery.UNABLE_TO_LOAD);
        Test.stopTest();
    }
    
    static testMethod void testGetUTPerformanceMacAddressNotFound()
    {
        // initialize custom settings
        SNG_MockCustomSettings.initialize();
        
        Modem__c modem
            = SNG_TestUtilities.insertEquipment('testEquip', 
                                                SNG_MockUTPerformanceFromPerfHttpCallout.NOT_FOUND_MAC_ADDRESS, 
                                                'testAccount', 
                                                true);
        Terminal__c terminal = modem.Terminal__r;
        ApexPages.StandardController controller = new ApexPages.StandardController(terminal);
        
        
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new SNG_MockUTPerformanceFromPerfHttpCallout());
        
        SNG_UTPerformanceFromPerf sngUtPerf = new SNG_UTPerformanceFromPerf(controller);
        sngUtPerf.getUTPerformance();
        
        Id terminalId = modem.Terminal__c;
        
        System.assertEquals(null, terminal.UploadSymbolRateBackEnd__c);
        System.assertEquals(null, terminal.DownloadSinrBackEnd__c);
        System.assertEquals(null, terminal.StatusBackEnd__c);
        System.assertEquals(null, terminal.IpAddress__c);
        System.assertEquals(null, terminal.OnlineTime__c);
        Test.stopTest();        
    }
    
    private static Integer parseOnlineTime(String onlineTime) {
        Integer onlineTimeSeconds = 0;
        
        if (onlineTime != 'Offline') {
            String[] timeParts = onlineTime.split(',');
            for (String s : timeParts) {
                s = s.trim().toLowerCase();
                Integer numPart = Integer.valueOf(s.split(' ')[0]);
                if (s.contains('day')) {
                    onlineTimeSeconds += (numPart * 86400);
                } else if (s.contains('hour')) {
                    onlineTimeSeconds += (numPart * 3600);
                } else if (s.contains('min')) {
                    onlineTimeSeconds += (numPart * 60);
                } else if (s.contains('sec')) {
                    onlineTimeSeconds += numPart;
                }
            }
        }
        
        return onlineTimeSeconds;
    }
        
    //******************************************************************************
    // TEST SNG_UTPerformanceHistory (SNG_UTPerformanceHistoryUnitTest)
    //******************************************************************************
    private static final Date END_DATE = SNG_DateUtils.todayGmt();
    private static final Date START_DATE = END_DATE - 59;

    static testMethod void testGetPerformanceHistoryPerformanceDatesNotSet() 
    {
        // initialize custom settings
        SNG_MockCustomSettings.initialize();
        
        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new SNG_MockUTPerformanceHistoryHttpCallout());
        
        Modem__c modem = SNG_TestUtilities.insertEquipment('testEquipment', 
                                                           SNG_MockUTPerformanceHistoryHttpCallout.ZERO_RESULTS_MAC_ADDRESS, 
                                                           'testAccount', 
                                                           true);
                                                           
        SNG_TestUtilities.insertModemServicePlan(modem, SNG_TestUtilities.insertServicePlan(modem.Account__r, true));
        
        Test.startTest();
        setPageReference(modem.Terminal__r);
                                                           
        ApexPages.StandardController controller = new ApexPages.StandardController(modem.Terminal__r);
               
        SNG_UTPerformanceHistory utPerfHistory = new SNG_UTPerformanceHistory(controller);
        utPerfHistory.getPerformanceHistory();
        System.assert(isTextContainedInApexPageMessages('Performance data could not be retrieved.'));
        
        // test fail
        try
        {
            Terminal__c nullTerminal = null;
            SNG_UTPerformanceHistory history = new SNG_UTPerformanceHistory(nullTerminal);
            System.assert(false);
        }
        catch (SNG_Exception e)
        {
            System.assert(true);
        }
        
        Test.stopTest();
    }
    
    static testMethod void testGetPerformanceHistoryMacAddressNotFound() 
    {
        // initialize custom settings
        SNG_MockCustomSettings.initialize();
        
        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new SNG_MockUTPerformanceHistoryHttpCallout());
        
        Modem__c modem = SNG_TestUtilities.insertEquipment('testEquipment', 
                                                           SNG_MockUTPerformanceHistoryHttpCallout.NOT_FOUND_MAC_ADDRESS, 
                                                           'testAccount', 
                                                           true);
                                                           
        SNG_TestUtilities.insertModemServicePlan(modem, SNG_TestUtilities.insertServicePlan(modem.Account__r, true));
        
        setPageReference(modem.Terminal__r);
                                                           
        ApexPages.StandardController controller = new ApexPages.StandardController(modem.Terminal__r);
        
        Test.startTest();
        SNG_UTPerformanceHistory utPerfHistory = new SNG_UTPerformanceHistory(controller);
        setDates(utPerfHistory);
        utPerfHistory.getPerformanceHistory();
        
        System.assert(isTextContainedInApexPageMessages('Performance data could not be retrieved.'));
        Test.stopTest();        
    }
        
    static testMethod void testGetPerformanceHistoryCurrentBillingCycle() {
        
        SNG_MockCustomSettings.initialize(); 
        Test.setMock(HttpCalloutMock.class, new SNG_MockUTPerformanceHistoryHttpCallout());
        
        Modem__c modem = SNG_TestUtilities.insertEquipment('testEquipment', 
                                                            SNG_MockUTPerformanceHistoryHttpCallout.HTTP_STATUS_ONE_RESULT_MAC_ADDRESS, 
                                                            'testAccount', 
                                                            true);
        
        SNG_TestUtilities.insertModemServicePlan(modem, SNG_TestUtilities.insertServicePlan(modem.Account__r, true));
        
        setPageReference(modem.Terminal__r);
        ApexPages.StandardController controller = new ApexPages.StandardController(modem.Terminal__r);
        
        Test.startTest();
        
        SNG_UTPerformanceHistory utPerfHistory = new SNG_UTPerformanceHistory(controller);
        setDates(utPerfHistory);
        utPerfHistory.performanceCurrentBillingCycle = true;
        utPerfHistory.getPerformanceHistory();
        
        System.debug('RT TEST mock response: ' + utPerfHistory.internalPhyHistory);
        
        Test.stopTest();
        
        List<Terminal__c> terminalUpdated = [SELECT UploadSymbolRateBackEnd__c, DownloadSinrBackEnd__c, OnlineTime__c FROM Terminal__c];
        
        for (Terminal__c term : terminalUpdated)
        {
            System.debug('RT TEST - uploadSymbolRate: ' + term.UploadSymbolRateBackEnd__c + ', downloadSinr: ' + term.DownloadSinrBackEnd__c 
                            + ', onlineTime: ' + term.OnlineTime__c);
        }
        
        System.assertEquals(1, terminalUpdated.size());
        System.assertEquals('Offline', terminalUpdated.get(0).OnlineTime__c);
    }
    
    static testMethod void getHistoryTestZeroResults() 
    {
        // initialize custom settings
        SNG_MockCustomSettings.initialize();
        
        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new SNG_MockUTPerformanceHistoryHttpCallout());
        
        Modem__c modem = SNG_TestUtilities.insertEquipment('testEquipment', 
                                                           SNG_MockUTPerformanceHistoryHttpCallout.ZERO_RESULTS_MAC_ADDRESS, 
                                                           'testAccount', 
                                                           true);
                                                           
        SNG_TestUtilities.insertModemServicePlan(modem, SNG_TestUtilities.insertServicePlan(modem.Account__r, true));
        
        setPageReference(modem.Terminal__r);
                                                           
        ApexPages.StandardController controller = new ApexPages.StandardController(modem.Terminal__r);
        
        Test.startTest();
        SNG_UTPerformanceHistory utPerfHistory = new SNG_UTPerformanceHistory(controller);
        setDates(utPerfHistory);
        utPerfHistory.getPerformanceHistory();
        SNG_Perf.UtPhyHistory phyHistory = new SNG_Perf.UtPhyHistory(utPerfHistory.internalPhyHistory);
        
        System.assertEquals(null, phyHistory.result.MAC_ADDRESS);
        System.assertEquals(0, phyHistory.result.history.size());
        System.assertEquals('ZERO_RESULTS', phyHistory.status);
        Test.stopTest();
    }
  
    static testMethod void getHistory404NotFoundError()
    {
        // initialize custom settings
        SNG_MockCustomSettings.initialize();
        
        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new SNG_MockUTPerformanceHistoryHttpCallout());
        
        Modem__c modem = SNG_TestUtilities.insertEquipment('testEquipment', 
                                                           SNG_MockUTPerformanceHistoryHttpCallout.HTTP_ERROR_404_MAC_ADDRESS, 
                                                           'testAccount', 
                                                           true);
                                                           
        SNG_TestUtilities.insertModemServicePlan(modem, SNG_TestUtilities.insertServicePlan(modem.Account__r, true));
        
        setPageReference(modem.Terminal__r);
        
        Test.startTest();

        ApexPages.StandardController controller = new ApexPages.StandardController(modem.Terminal__r);
        SNG_UTPerformanceHistory utPerfHistory = new SNG_UTPerformanceHistory(controller);
        setDates(utPerfHistory);
        utPerfHistory.getPerformanceHistory();
        System.assert(isTextContainedInApexPageMessages('Performance data could not be retrieved.'));

        Test.stopTest();
    }

    static testMethod void getHistoryOneResult()
    {
        // initialize custom settings
        SNG_MockCustomSettings.initialize();
        
        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new SNG_MockUTPerformanceHistoryHttpCallout());
        
        Modem__c modem = SNG_TestUtilities.insertEquipment('testEquipment', 
                                                           SNG_MockUTPerformanceHistoryHttpCallout.HTTP_STATUS_ONE_RESULT_MAC_ADDRESS, 
                                                           'testAccount', 
                                                           true);
                                                           
        SNG_TestUtilities.insertModemServicePlan(modem, SNG_TestUtilities.insertServicePlan(modem.Account__r, true));
        
        setPageReference(modem.Terminal__r);
        
        Test.startTest();
        ApexPages.StandardController controller = new ApexPages.StandardController(modem.Terminal__r);
        SNG_UTPerformanceHistory utPerfHistory = new SNG_UTPerformanceHistory(controller);
        setDates(utPerfHistory);
        utPerfHistory.getPerformanceHistory();
        SNG_Perf.UtPhyHistory phy = new SNG_Perf.UtPhyHistory(utPerfHistory.internalPhyHistory);
        
        System.assertEquals(SNG_MockUTPerformanceHistoryHttpCallout.HTTP_STATUS_ONE_RESULT_MAC_ADDRESS, phy.result.MAC_ADDRESS);
        System.assertEquals('OK', phy.status);
        System.assertEquals(1, phy.result.history.size());
        System.assertEquals(1385971200, phy.result.history[0].TIMESTAMP);
        System.assertEquals(20.5, phy.result.history[0].FORWARD_LINK_SINR);
        System.assertEquals(625, phy.result.history[0].RETURN_LINK_SYMBOL_RATE);
        
        Test.stopTest();
    }
        
    static testMethod void getHistoryTwoResults()
    {
        // initialize custom settings
        SNG_MockCustomSettings.initialize();
        
        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new SNG_MockUTPerformanceHistoryHttpCallout());
        
        Modem__c modem = SNG_TestUtilities.insertEquipment('testEquipment', 
                                                           SNG_MockUTPerformanceHistoryHttpCallout.HTTP_STATUS_TWO_RESULT_MAC_ADDRESS, 
                                                           'testAccount', 
                                                           true);
                                                           
        SNG_TestUtilities.insertModemServicePlan(modem, SNG_TestUtilities.insertServicePlan(modem.Account__r, true));
        
        setPageReference(modem.Terminal__r);
        
        Test.startTest();
        ApexPages.StandardController controller = new ApexPages.StandardController(modem.Terminal__r);
        SNG_UTPerformanceHistory utPerfHistory = new SNG_UTPerformanceHistory(controller);
        setDates(utPerfHistory);
        utPerfHistory.getPerformanceHistory();
        SNG_Perf.UtPhyHistory phy = new SNG_Perf.UtPhyHistory(utPerfHistory.internalPhyHistory);
        
        System.assertEquals(SNG_MockUTPerformanceHistoryHttpCallout.HTTP_STATUS_TWO_RESULT_MAC_ADDRESS, phy.result.MAC_ADDRESS);
        System.assertEquals('OK', phy.status);
        System.assertEquals(2, phy.result.history.size());
        System.assertEquals(1385971200, phy.result.history[0].TIMESTAMP);
        System.assertEquals(20.5, phy.result.history[0].FORWARD_LINK_SINR);
        System.assertEquals(625, phy.result.history[0].RETURN_LINK_SYMBOL_RATE);
        System.assertEquals(1385971215, phy.result.history[1].TIMESTAMP);
        System.assertEquals(19.0, phy.result.history[1].FORWARD_LINK_SINR);
        System.assertEquals(376, phy.result.history[1].RETURN_LINK_SYMBOL_RATE);
        
        Test.stopTest();                
    }
 
    
    private static void setPageReference(SObject record) {
        Test.setCurrentPageReference(new PageReference('/apex/SNGTerminalDetail?id=' + record.Id));
    }
    
    private static void setDates(SNG_UTPerformanceHistory utPerfHistory) {
        utPerfHistory.performanceStartDate = START_DATE.format();
        utPerfHistory.performanceEndDate = END_DATE.format();
    }
    
    private static boolean isTextContainedInApexPageMessages(String text) {
        boolean result = false;
        
        ApexPages.Message[] msgs = ApexPages.getMessages();
        
        System.debug('About to look at ' + msgs.size() + ' messages');
        
        for (ApexPages.Message msg : msgs) {
            
            System.debug('msg.Detail: ' + msg.getDetail());
            if (msg.getDetail().contains(text)) {
                System.debug('Found matching message');
                result = true;
                break;
            }
        }
        return result;
    }

    //**********************************************************
    // TEST SNGTerminalTabUnitTest
    //**********************************************************
    static testMethod void testUpdateUsageDataNoTerminals()
    {
        SNG_MockCustomSettings.initialize();
        SNGTerminalTab terminalTab = new SNGTerminalTab();
        setPageReference();
        try
        {
            terminalTab.updateUsageData(true);
            System.assert(true);
        }
        catch (Exception e)        {
            System.assert(false);
        }
        System.assertEquals(true, isTextContainedInApexPageMessages('Usage data could not be retrieved.'));

        //testUpdateUsageDataNull()
        try
        {
            terminalTab.terminals = null;
            terminalTab.updateUsageData(true);
            System.assert(true);
        }
        catch (Exception e)        {
            System.assert(false);
        }
        
        System.assertEquals(true, isTextContainedInApexPageMessages('Usage data could not be retrieved.'));

        //testUpdatePerformanceDataNoTerminals()
        try
        {
            terminalTab.updatePerformanceData(true);
            System.assert(true);
        }
        catch (Exception e)        {
            System.assert(false);
        }
        
        //testUpdatePerformanceDataNull()
        try
        {
            terminalTab.terminals = null;
            terminalTab.updatePerformanceData(true);
            System.assert(true);
        }
        catch (Exception e)        {
            System.assert(false);
        }
        
        System.assertEquals(true, isTextContainedInApexPageMessages('Performance data could not be retrieved.'));
    }

    static testMethod void TestUpdateTable()
    {
        SNG_MockCustomSettings.initialize();

        insertListOfTerminalObjects(30);
        SNGTerminalTab terminalTab = new SNGTerminalTab();
        terminalTab.getFirstPage();
        System.assertEquals('1', terminalTab.pageNumberStr);
        terminalTab.ViewData();

        Test.startTest();
        terminalTab.ViewData();
        List<Terminal__c> displayedList = terminalTab.displayTerminals;
        System.assertEquals(10, displayedList.size());

        Terminal__c terminal = [SELECT Id, SerialNumber__c FROM Terminal__c limit 1];
        terminal.SerialNumber__c = '100';
        update terminal;

        terminalTab.updateTable();
        terminalTab.ViewData();
        displayedList = terminalTab.displayTerminals;
        System.assertEquals(terminal.SerialNumber__c, displayedList[0].SerialNumber__c);
        Test.stopTest();
    }

    static testMethod void TestSortingGetSetSort()
    {
        SNG_MockCustomSettings.initialize();

        insertListOfTerminalObjects(30);

        Test.startTest();
        SNGTerminalTab terminalTab = new SNGTerminalTab();
        terminalTab.getFirstPage();
        System.assertEquals('1', terminalTab.pageNumberStr);

        terminalTab.sortExpression = 'SerialNumber__c';

        terminalTab.setSortDirection('DESC');
        System.assertEquals('DESC', terminalTab.getSortDirection());


        terminalTab.ViewData();
        List<Terminal__c> displayedList = terminalTab.displayTerminals;
        System.assertEquals(10, displayedList.size());

        terminalTab.getNextPage();
        Test.stopTest();
    }

    static testMethod void TestPagingGotoPage()
    {
        SNG_MockCustomSettings.initialize();

        insertListOfTerminalObjects(30);
        SNGTerminalTab terminalTab = new SNGTerminalTab();
        terminalTab.pageNumberStr = '3';
        terminalTab.gotoPage();
        System.assertEquals('3', terminalTab.pageNumberStr);
        terminalTab.ViewData();

        terminalTab.ViewData();
        List<Terminal__c> displayedList = terminalTab.displayTerminals;
        System.assertEquals(10, displayedList.size());
    }

    static testMethod void TestPagingGetLastPage()
    {
        SNG_MockCustomSettings.initialize();

        insertListOfTerminalObjects(30);
        SNGTerminalTab terminalTab = new SNGTerminalTab();
        terminalTab.getLastPage();
        System.assertEquals('3', terminalTab.pageNumberStr);
        terminalTab.ViewData();

        terminalTab.ViewData();
        List<Terminal__c> displayedList = terminalTab.displayTerminals;
        System.assertEquals(10, displayedList.size());
    }

    static testMethod void testUpdatePerformanceSunnyDay()
    {
        // initialize custom settings
        SNG_MockCustomSettings.initialize();

        // Set mock callout class
        Test.setMock(HttpCalloutMock.class, new SNG_MockPerformanceLatestHttpCallout());

        Modem__c modem = SNG_TestUtilities.insertEquipment('testEquipment',
                                                           SNG_MockPerformanceLatestHttpCallout.SUCCESS_MACADDRS[0],
                                                           'testAccount',
                                                           true);

        SNG_TestUtilities.insertModemServicePlan(modem, SNG_TestUtilities.insertServicePlan(modem.Account__r, true));

        Test.startTest();

        Test.setMock(HttpCalloutMock.class, new SNG_MockPerformanceLatestHttpCallout());
        SNGTerminalTab terminalTab = new SNGTerminalTab();

        terminalTab.terminalId = String.valueOf(modem.Terminal__c);

        terminalTab.updatePerformanceData(true);

        //Terminal__c terminal = [SELECT DownloadSinrBackEnd__c, UploadSymbolRateBackEnd__c  FROM Terminal__c WHERE Id = :modem.Terminal__c];

        List<Terminal__c> terminals = terminalTab.terminals;
        System.assertEquals(1, terminals.size());
        
        Terminal__c terminal = terminals.get(0);

        System.assertEquals(25.7, terminal.DownloadSinrBackEnd__c);
        System.assertEquals(10000, terminal.UploadSymbolRateBackEnd__c);

        Test.stopTest();
    }
    
    static testMethod void testUpdatePerformanceFailureCase()
    {
        // initialize custom settings
        SNG_MockCustomSettings.initialize();

        // Set mock callout class
        Test.setMock(HttpCalloutMock.class, new SNG_MockPerformanceLatestHttpCallout());

        Modem__c modem = SNG_TestUtilities.insertEquipment('testEquipment',
                                                           SNG_MockPerformanceLatestHttpCallout.SERVER_ERROR_MACADDRS[0],
                                                           'testAccount',
                                                           true);

        SNG_TestUtilities.insertModemServicePlan(modem, SNG_TestUtilities.insertServicePlan(modem.Account__r, true));

        Test.startTest();

        Test.setMock(HttpCalloutMock.class, new SNG_MockPerformanceLatestHttpCallout());
        SNGTerminalTab terminalTab = new SNGTerminalTab();

        terminalTab.terminalId = String.valueOf(modem.Terminal__c);

        terminalTab.updatePerformanceData(true);

        //Terminal__c terminal = [SELECT DownloadSinrBackEnd__c, UploadSymbolRateBackEnd__c, StatusBackEnd__c, OnlineTime__c
        //                        FROM Terminal__c WHERE Id = :modem.Terminal__c];

        List<Terminal__c> terminals = terminalTab.terminals;
        System.assertEquals(1, terminals.size());
        
        Terminal__c terminal = terminals.get(0);
        System.assertEquals(0, terminal.DownloadSinrBackEnd__c);
        System.assertEquals(0, terminal.UploadSymbolRateBackEnd__c);
        System.assertEquals(SNG_TerminalQuery.UNABLE_TO_LOAD, terminal.StatusBackEnd__c);
        System.assertEquals(SNGTerminalTab.OFFLINE, terminal.OnlineTime__c);

        Test.stopTest();
    }
    
    static testMethod void testUpdateUsageDataSunnyDay()
    {
        // initialize custom settings
        SNG_MockCustomSettings.initialize();

        // Set mock callout class
        Test.setMock(HttpCalloutMock.class, new SNG_MockUsageServiceHttpCallout());
    

        Modem__c modem = SNG_TestUtilities.insertEquipment('testEquipment',
                                                           SNG_MockUsageServiceHttpCallout.SUNNY_DAY_MAC_ADDRESS_SINGLE,
                                                           'testAccount',
                                                           true);

        SNG_TestUtilities.insertModemServicePlan(modem, SNG_TestUtilities.insertServicePlan(modem.Account__r, true));

        Test.startTest();

        Terminal__c terminal = [SELECT Name, GbDownloaded__c, GbUploaded__c, GbTotal__c  FROM Terminal__c WHERE Id = :modem.Terminal__c];
        
        SNGTerminalTab terminalTab = new SNGTerminalTab();
        terminalTab.terminals = new Terminal__c[] { terminal };
        terminalTab.updateUsageData(true);
        
        //terminal = [SELECT GbDownloaded__c, GbUploaded__c, GbTotal__c  FROM Terminal__c WHERE Id = :modem.Terminal__c];

        List<Terminal__c> terminals = terminalTab.terminals;
        System.assertEquals(1, terminals.size()); 
        terminal = terminals.get(0);  

        System.assertEquals(String.valueOf(SNG_UsageAggregateUpdateHelper.convertToGb(SNG_MockUsageServiceHttpCallout.SINGLE_AGGREGATE_DOWNLOAD)), terminal.GbDownloaded__c);
        System.assertEquals(String.valueOf(SNG_UsageAggregateUpdateHelper.convertToGb(SNG_MockUsageServiceHttpCallout.SINGLE_AGGREGATE_UPLOAD)), terminal.GbUploaded__c);
        System.assertEquals(String.valueOf(SNG_UsageAggregateUpdateHelper.convertToGb(SNG_MockUsageServiceHttpCallout.SINGLE_AGGREGATE_DOWNLOAD + SNG_MockUsageServiceHttpCallout.SINGLE_AGGREGATE_UPLOAD)), terminal.GbTotal__c);

        Test.stopTest();
    }


    static testMethod void testGetStatusTrafficLigt()
    {
        // initialize custom settings
        SNG_MockCustomSettings.initialize();

        // Set mock callout class
        Test.setMock(HttpCalloutMock.class, new SNG_MockUsageServiceHttpCallout());

        Modem__c modem = SNG_TestUtilities.insertEquipment('testEquipment',
                                                           SNG_MockUsageServiceHttpCallout.SUNNY_DAY_MAC_ADDRESS_SINGLE,
                                                           'testAccount',
                                                           true);

        SNG_TestUtilities.insertModemServicePlan(modem, SNG_TestUtilities.insertServicePlan(modem.Account__r, true));

        Test.startTest();
        SNGTerminalTab terminalTab = new SNGTerminalTab();

        System.assertEquals('/resource/SNGDots/SNGDots/' + SNGTerminalStatusLight.GRAY_DOT_FILENAME , SNGTerminalTab.getStatusTrafficLight(modem.Terminal__c));
    }


    private static void setPageReference() {
        Test.setCurrentPageReference(new PageReference('/apex/SNGTerminalTab'));
    }

    private static List<Terminal__c> insertListOfTerminalObjects(integer num)
    {
        Account account = SNG_TestUtilities.insertAccount('Red Cross');
        List<Product2> terminalTypes = ViasatTestUtility.createProducts(num, 'Exede', SNG_Terminal.TERMINAL_TYPE_RECORD_TYPE_NAME, 'testTerminalType_', true);
        insert terminalTypes;

        list<Terminal__c> terminals = SNG_TestUtilities.constructTerminals(account, num, terminalTypes, 'testTerminal');
        insert terminals;
        return terminals;
    }
    
    //**********************************************************
    // TEST SNGTerminalHistoryUnitTest
    //**********************************************************
    static testMethod void testTerminalHistoryConstructor() {
        Terminal__c terminal = new Terminal__c(); 
        ApexPages.StandardController sc = new ApexPages.StandardController(terminal);
        SNGTerminalHistory history = new SNGTerminalHistory(sc);
        System.assertEquals(5, history.PageSize);
        System.assertEquals(true, history.AllowShowMore);

        history.showMore();
        System.assertEquals(10, history.PageSize);      
    }
    
    static testMethod void testGetObjectTermHistoryOnCreate()
    {
        SNG_MockCustomSettings.initialize();

        Account account = SNG_TestUtilities.insertAccount('Red Cross'); 
        Terminal__c terminal = SNG_TestUtilities.insertTerminal(account, '', '1234561');

        Terminal__History tempHist = new Terminal__History();
       
        ApexPages.StandardController sc = new ApexPages.StandardController(terminal);
        SNGTerminalHistory history = new SNGTerminalHistory(sc);
        history.historyQuery = new SNGMockTerminalHistoryQuery();

        history.PageSize = 0; 
        List<SNGTerminalHistory.TerminalHistory> historyList = history.terminalObjectHistories;
        System.assertEquals(1, historyList.size()); 
        System.assertEquals('Created.', historyList[0].ActionFormat);       

        terminal.Nickname__c = 'Test';
        update terminal;

        tempHist = new Terminal__History();
       
        sc = new ApexPages.StandardController(terminal);
        history = new SNGTerminalHistory(sc);
        history.historyQuery = new SNGMockTerminalHistoryQuery();

        history.PageSize = 1; 
        historyList = history.terminalObjectHistories;
        System.assertEquals(1, historyList.size());
        System.assertEquals('Changed <b>{1}</b> to <b>{3}</b>.', historyList[0].ActionFormat);  
    }
    
    static testMethod void testGetObjectHistoryOn2Updates()
    {
        SNG_MockCustomSettings.initialize();

        Account account = SNG_TestUtilities.insertAccount('Red Cross'); 
        Terminal__c terminal = SNG_TestUtilities.insertTerminal(account, '', '1234561');
        terminal.Nickname__c = 'Test';
        update terminal;

        Terminal__History tempHist = new Terminal__History();
       
        ApexPages.StandardController sc = new ApexPages.StandardController(terminal);
        SNGTerminalHistory history = new SNGTerminalHistory(sc);
        history.historyQuery = new SNGMockTerminalHistoryQuery();

        history.PageSize = 2; 
        List<SNGTerminalHistory.TerminalHistory> historyList = history.terminalObjectHistories;
        System.assertEquals(2, historyList.size()); 
        System.assertEquals('Changed <b>{1}</b> to <b>{3}</b>.', historyList[0].ActionFormat);  
        System.assertEquals('Changed <b>{1}</b> from <b>{2}</b> to <b>{3}</b>.', historyList[1].ActionFormat);
    }
    
    static testMethod void testGetObjectElseCaseForAction()
    {
        SNG_MockCustomSettings.initialize();

        Account account = SNG_TestUtilities.insertAccount('Red Cross'); 
        Terminal__c terminal = SNG_TestUtilities.insertTerminal(account, '', '1234561');
        terminal.Nickname__c = 'Test';
        update terminal;

        Terminal__History tempHist = new Terminal__History();
       
        ApexPages.StandardController sc = new ApexPages.StandardController(terminal);
        SNGTerminalHistory history = new SNGTerminalHistory(sc);
        history.historyQuery = new SNGMockTerminalHistoryQuery();

        history.PageSize = 3; 
        List<SNGTerminalHistory.TerminalHistory> historyList = history.terminalObjectHistories;
        System.assertEquals(1, historyList.size());
        System.assertEquals('Record <b>{0}.</b>', historyList[0].ActionFormat);  
    }
    
    
    static testMethod void testModemHistoryCtorEmpty()
    {
        SNGTerminalHistory.TerminalHistory history = new SNGTerminalHistory.TerminalHistory();
        System.assertEquals(true, history.ShowDateAndUser);
    }
    

    //**********************************************************
    // TEST SNG_UtPeers
    //**********************************************************
    static testMethod void testCtor() {
        // TO DO: implement unit test
        SNG_MockCustomSettings.initialize();
        
        String macAddress = '00:a0:bc:11:22:33';
        String equipmentName = 'equipmentName';
        Modem__c modem = SNG_TestUtilities.insertEquipment(equipmentName, macAddress, 'Account1', true);
        
        Terminal__c terminal = [SELECT Id, MacAddress__c FROM Terminal__c WHERE Nickname__c = :equipmentName];
        ApexPages.StandardController sc = new ApexPages.StandardController(terminal);
        SNG_UtPeers utPeers = new SNG_UtPeers(sc);
    }
    
    static testMethod void testGetPeersOnlineDataSingleMacAddressSunnyDay()
    {
        SNG_MockCustomSettings.initialize(); 
        Test.setMock(HttpCalloutMock.class, new SNG_MockUtPeersHttpCallout());
        
        
        // TO DO: implement unit test
        String macAddress = SNG_MockUtPeersHttpCallout.SUNNY_DAY_SINGLE_VALID_MAC_ADDRESS;
        String equipmentName = 'equipmentName';
        Modem__c modem = SNG_TestUtilities.insertEquipment(equipmentName, macAddress, 'Account1', true);
        
        Terminal__c terminal = [SELECT Id, MacAddress__c FROM Terminal__c WHERE Nickname__c = :equipmentName];
        ApexPages.StandardController sc = new ApexPages.StandardController(terminal);
        SNG_UtPeers utPeers = new SNG_UtPeers(sc);
        
        terminal = [SELECT Id, MacAddress__c, PeersOnlineBackEnd__c, PeersAvgUploadSymbolRateBackEnd__c FROM Terminal__c WHERE Nickname__c = :equipmentName];
        System.assertEquals(null, terminal.PeersOnlineBackEnd__c);
        System.assertEquals(null, terminal.PeersAvgUploadSymbolRateBackEnd__c);
        
        Test.startTest();
        utPeers.getPeersOnlineData();
        
        
        terminal = [SELECT Id, MacAddress__c, PeersOnlineBackEnd__c, PeersAvgUploadSymbolRateBackEnd__c FROM Terminal__c WHERE Nickname__c = :equipmentName];
        
        System.assertEquals(SNG_MockUtPeersHttpCallout.SUNNY_DAY_SINGLE_NUM_PEERS_ONLINE, terminal.PeersOnlineBackEnd__c);
        System.assertEquals(SNG_MockUtPeersHttpCallout.SUNNY_DAY_SINGLE_AVG_RL_SYM_RATE, terminal.PeersAvgUploadSymbolRateBackEnd__c);
        
        Test.stopTest();
    }
    
    static testMethod void testGetPeersOnlineDataSingleMacAddressSunnyDayDifferentCtor()
    {
        SNG_MockCustomSettings.initialize(); 
        Test.setMock(HttpCalloutMock.class, new SNG_MockUtPeersHttpCallout());
        
        
        // TO DO: implement unit test
        String macAddress = SNG_MockUtPeersHttpCallout.SUNNY_DAY_SINGLE_VALID_MAC_ADDRESS;
        String equipmentName = 'equipmentName';
        Modem__c modem = SNG_TestUtilities.insertEquipment(equipmentName, macAddress, 'Account1', true);
        
        Terminal__c terminal = [SELECT Id, MacAddress__c FROM Terminal__c WHERE Nickname__c = :equipmentName];
        List<Terminal__c> terminals = new List<Terminal__c>{ terminal };
        SNG_UtPeers utPeers = new SNG_UtPeers(terminals);
        
        terminal = [SELECT Id, MacAddress__c, PeersOnlineBackEnd__c, PeersAvgUploadSymbolRateBackEnd__c FROM Terminal__c WHERE Nickname__c = :equipmentName];
        System.assertEquals(null, terminal.PeersOnlineBackEnd__c);
        System.assertEquals(null, terminal.PeersAvgUploadSymbolRateBackEnd__c);
        
        Test.startTest();
        utPeers.getPeersOnlineData();
        
        
        terminal = [SELECT Id, MacAddress__c, PeersOnlineBackEnd__c, PeersAvgUploadSymbolRateBackEnd__c FROM Terminal__c WHERE Nickname__c = :equipmentName];
        
        System.assertEquals(SNG_MockUtPeersHttpCallout.SUNNY_DAY_SINGLE_NUM_PEERS_ONLINE, terminal.PeersOnlineBackEnd__c);
        System.assertEquals(SNG_MockUtPeersHttpCallout.SUNNY_DAY_SINGLE_AVG_RL_SYM_RATE, terminal.PeersAvgUploadSymbolRateBackEnd__c);
        
        Test.stopTest();
    }
    
    static testMethod void testGetPeersOnlineDataDoubleMacAddressSunnyDayDifferentCtor()
    {
        SNG_MockCustomSettings.initialize(); 
        Test.setMock(HttpCalloutMock.class, new SNG_MockUtPeersHttpCallout());
        
        Account account = SNG_TestUtilities.insertAccount('Account1');
        
        // TO DO: implement unit test
        String macAddress1 = SNG_MockUtPeersHttpCallout.SUNNY_DAY_DOUBLE_VALID_MAC_ADDRESS_1;
        String equipmentName1 = 'equipmentName1';
        Modem__c modem1 = SNG_TestUtilities.insertEquipment(equipmentName1, macAddress1, account, true);
        
        String macAddress2 = SNG_MockUtPeersHttpCallout.SUNNY_DAY_DOUBLE_VALID_MAC_ADDRESS_2;
        String equipmentName2 = 'equipmentName2';
        Modem__c modem2 = SNG_TestUtilities.insertEquipment(equipmentName2, macAddress2, account, true);
        
        List<String> equipments = new List<String>{equipmentName1, equipmentName2};
        
        List<Terminal__c> terminals = [SELECT Id, MacAddress__c FROM Terminal__c WHERE Nickname__c IN :equipments];
        SNG_UtPeers utPeers = new SNG_UtPeers(terminals);
        
        Terminal__c terminal = [SELECT Id, MacAddress__c, PeersOnlineBackEnd__c, PeersAvgUploadSymbolRateBackEnd__c FROM Terminal__c WHERE Nickname__c = :equipmentName1];
        System.assertEquals(null, terminal.PeersOnlineBackEnd__c);
        System.assertEquals(null, terminal.PeersAvgUploadSymbolRateBackEnd__c);
        
        terminal = [SELECT Id, MacAddress__c, PeersOnlineBackEnd__c, PeersAvgUploadSymbolRateBackEnd__c FROM Terminal__c WHERE Nickname__c = :equipmentName2];
        System.assertEquals(null, terminal.PeersOnlineBackEnd__c);
        System.assertEquals(null, terminal.PeersAvgUploadSymbolRateBackEnd__c);
        
        Test.startTest();
        utPeers.getPeersOnlineData();

        terminal = [SELECT Id, MacAddress__c, PeersOnlineBackEnd__c, PeersAvgUploadSymbolRateBackEnd__c FROM Terminal__c WHERE Nickname__c = :equipmentName1];
        
        System.assertEquals(SNG_MockUtPeersHttpCallout.SUNNY_DAY_DOUBLE_NUM_PEERS_ONLINE_1, terminal.PeersOnlineBackEnd__c);
        System.assertEquals(SNG_MockUtPeersHttpCallout.SUNNY_DAY_DOUBLE_AVG_RL_SYM_RATE_1, terminal.PeersAvgUploadSymbolRateBackEnd__c);
        
        terminal = [SELECT Id, MacAddress__c, PeersOnlineBackEnd__c, PeersAvgUploadSymbolRateBackEnd__c FROM Terminal__c WHERE Nickname__c = :equipmentName2];
        
        System.assertEquals(SNG_MockUtPeersHttpCallout.SUNNY_DAY_DOUBLE_NUM_PEERS_ONLINE_2, terminal.PeersOnlineBackEnd__c);
        System.assertEquals(SNG_MockUtPeersHttpCallout.SUNNY_DAY_DOUBLE_AVG_RL_SYM_RATE_2, terminal.PeersAvgUploadSymbolRateBackEnd__c);
        
        Test.stopTest();
    }
    
    
    static testMethod void testGetPeersOnlineDataHttpResponseInvalidFormat()
    {
        SNG_MockCustomSettings.initialize(); 
        Test.setMock(HttpCalloutMock.class, new SNG_MockUtPeersHttpCallout());
        
        
        // TO DO: implement unit test
        String macAddress = SNG_MockUtPeersHttpCallout.INVALID_RESPONSE_FORMAT_MAC_ADDRESS;
        String equipmentName = 'equipmentName';
        Modem__c modem = SNG_TestUtilities.insertEquipment(equipmentName, macAddress, 'Account1', true);
        
        Terminal__c terminal = [SELECT Id, MacAddress__c FROM Terminal__c WHERE Nickname__c = :equipmentName];
        ApexPages.StandardController sc = new ApexPages.StandardController(terminal);
        SNG_UtPeers utPeers = new SNG_UtPeers(sc);
        
        terminal = [SELECT Id, MacAddress__c, PeersOnlineBackEnd__c, PeersAvgUploadSymbolRateBackEnd__c FROM Terminal__c WHERE Nickname__c = :equipmentName];
        System.assertEquals(null, terminal.PeersOnlineBackEnd__c);
        System.assertEquals(null, terminal.PeersAvgUploadSymbolRateBackEnd__c);
        
        Test.startTest();
        utPeers.getPeersOnlineData();
        
        
        terminal = [SELECT Id, MacAddress__c, PeersOnlineBackEnd__c, PeersAvgUploadSymbolRateBackEnd__c FROM Terminal__c WHERE Nickname__c = :equipmentName];
        
        System.assertEquals(0, terminal.PeersOnlineBackEnd__c);
        System.assertEquals(0, terminal.PeersAvgUploadSymbolRateBackEnd__c);
        
        Test.stopTest();        
    }
    
    static testMethod void testGetPeersOnlineDataHttpStatusFailure()
    {
        SNG_MockCustomSettings.initialize(); 
        Test.setMock(HttpCalloutMock.class, new SNG_MockUtPeersHttpCallout());
        
        
        // TO DO: implement unit test
        String macAddress = SNG_MockUtPeersHttpCallout.HTTP_STATUS_FAILURE_MAC_ADDRESS;
        String equipmentName = 'equipmentName';
        Modem__c modem = SNG_TestUtilities.insertEquipment(equipmentName, macAddress, 'Account1', true);
        
        Terminal__c terminal = [SELECT Id, MacAddress__c FROM Terminal__c WHERE Nickname__c = :equipmentName];
        ApexPages.StandardController sc = new ApexPages.StandardController(terminal);
        SNG_UtPeers utPeers = new SNG_UtPeers(sc);
        
        terminal = [SELECT Id, MacAddress__c, PeersOnlineBackEnd__c, PeersAvgUploadSymbolRateBackEnd__c FROM Terminal__c WHERE Nickname__c = :equipmentName];
        System.assertEquals(null, terminal.PeersOnlineBackEnd__c);
        System.assertEquals(null, terminal.PeersAvgUploadSymbolRateBackEnd__c);
        
        Test.startTest();
        utPeers.getPeersOnlineData();
        
        
        terminal = [SELECT Id, MacAddress__c, PeersOnlineBackEnd__c, PeersAvgUploadSymbolRateBackEnd__c FROM Terminal__c WHERE Nickname__c = :equipmentName];
        
        System.assertEquals(0, terminal.PeersOnlineBackEnd__c);
        System.assertEquals(0, terminal.PeersAvgUploadSymbolRateBackEnd__c);
        
        Test.stopTest();
    }
    
    //**********************************************************
    // TEST SNG_UtPeersUpdater
    //**********************************************************
    static testMethod void testUtPeersUpdater() {
        
        SNG_MockCustomSettings.initialize();

        Map<String, Terminal__c> macAddrToEmptyTerminal = new Map<String, Terminal__c>();
        Map<String, Terminal__c> macAddrToTerminal = createMacAddrToTerminalMap(3);
        SNG_Perf.UtPeerDataLatest utPeerData = createUtPeerData(2);
                
        Test.startTest();
        
        SNG_UtPeersUpdater.process(macAddrToEmptyTerminal, null);
        SNG_UtPeersUpdater.process(macAddrToTerminal, null);
        SNG_UtPeersUpdater.process(macAddrToTerminal, utPeerData);
        
        Test.stopTest();
        
        List<Terminal__c> updatedTerms = [SELECT Id, Name, MacAddress__c, PeersOnlineBackEnd__c, PeersAvgUploadSymbolRateBackEnd__c
                                            FROM Terminal__c];
        
        System.assertEquals(3, updatedTerms.size());
        
        for (Terminal__c term : updatedTerms)
        {                                   
            if (term.MacAddress__c == '00:a0:bc:11:11:10')
            {
                System.assertEquals(0L, term.PeersOnlineBackEnd__c);
                System.assertEquals(0, term.PeersAvgUploadSymbolRateBackEnd__c); 
            }
            else if (term.MacAddress__c == '00:a0:bc:11:11:11')
            { 
                System.assertEquals(1L, term.PeersOnlineBackEnd__c);
                System.assertEquals(1, term.PeersAvgUploadSymbolRateBackEnd__c);
            }
        }
    }
    
    private static SNG_Perf.UtPeerDataLatest createUtPeerData(integer numOfTerminals) { 
        
        String startingMacAddr = '00A0BC11111';
         
        String strUtPeerData = '{' + 
                                ' "status": "OK",' + 
                                ' "result": [';
                                 
        for (integer i = 0; i < numOfTerminals; i++)
        {
            strUtPeerData += ' {"NUM_PEERS_ONLINE": ' + String.valueOf(i) + ',' + 
                            ' "AVG_RL_SYM_RATE": ' + String.valueOf((Decimal) i) + ',' + 
                            ' "id": "' + startingMacAddr + String.valueOf(i) + '"' + ' }';
            if (i != numOfTerminals - 1)
                strUtPeerData += ',';
        }       
        strUtPeerData += ' ]}';
        
        SNG_Perf.UtPeerDataLatest utPeerData = (SNG_Perf.UtPeerDataLatest) JSON.deserialize(strUtPeerData, SNG_Perf.UtPeerDataLatest.class);
        return utPeerData;
    }
    
    private static Map<String, Terminal__c> createMacAddrToTerminalMap(integer numOfTerminals) { 

        String startingMacAddr = '00:a0:bc:11:11:1';        
        for (integer i = 0; i < numOfTerminals; i++) 
        {
            String macAddrToInsert = startingMacAddr + String.valueOf(i);
            SNG_TestUtilities.insertEquipment('Test Terminals', macAddrToInsert, 'Test Account', String.valueOf(i), true, SNG_TestUtilities.generateSalesOrder(i)); 
        }

        List<Terminal__c> terms = [SELECT Id, Name, MacAddress__c, PeersOnlineBackEnd__c, PeersAvgUploadSymbolRateBackEnd__c
                                    FROM Terminal__c];
                                    
        Map<String, Terminal__c> macAddrToTerminalMap = new Map<String, Terminal__c>();
        
        for (Terminal__c term : terms) 
        {
            macAddrToTerminalMap.put(term.MacAddress__c, term);
        }       
        return macAddrToTerminalMap;        
    }

    //**********************************************************
    // TEST SNG_UtUsageAggregateUpdaterUnitTest
    //**********************************************************
    static testMethod void testProcessExceptionTerminalEntries() 
    {
        SNG_MockCustomSettings.initialize();

        Account account = SNG_TestUtilities.insertAccount('testAccount');
        
        String terminalNickname1 = 'Terminal1';
        String macAddress1 = '00:a0:bc:11:22:33';
        SNG_TestUtilities.insertEquipment(terminalNickname1, macAddress1, account, 'ser1', true);
                
        String terminalNickname2 = 'Terminal2';
        String macAddress2 = '00:a0:bc:11:22:44';
        SNG_TestUtilities.insertEquipment(terminalNickname2, macAddress2, account, 'ser2', true);

        Terminal__c terminal1 = [SELECT Name, GbUploaded__c, GbDownloaded__c, GbTotal__c FROM Terminal__c WHERE Nickname__c = :terminalNickname1];
        Terminal__c terminal2 = [SELECT Name, GbUploaded__c, GbDownloaded__c, GbTotal__c FROM Terminal__c WHERE Nickname__c = :terminalNickname2];
        
        System.assertEquals(null, terminal1.GbUploaded__c);
        System.assertEquals(null, terminal1.GbDownloaded__c);
        System.assertEquals(null, terminal1.GbTotal__c);        
        System.assertEquals(null, terminal2.GbUploaded__c);
        System.assertEquals(null, terminal2.GbDownloaded__c);
        System.assertEquals(null, terminal2.GbTotal__c);
        
        Map<String, Terminal__c> macAddressToTerminals = new Map<String, Terminal__c>();
        macAddressToTerminals.put(macAddress1, terminal1);
        macAddressToTerminals.put(macAddress2, terminal2);

        Test.startTest();
        // nothing to test. just verify it doesn't throw.
        SNG_UtUsageAggregateUpdater.processException(macAddressToTerminals.values());
        
        System.assertEquals(SNG_TerminalQuery.UNABLE_TO_LOAD, terminal1.GbUploaded__c);
        System.assertEquals(SNG_TerminalQuery.UNABLE_TO_LOAD, terminal1.GbDownloaded__c);
        System.assertEquals(SNG_TerminalQuery.UNABLE_TO_LOAD, terminal1.GbTotal__c);        
        System.assertEquals(SNG_TerminalQuery.UNABLE_TO_LOAD, terminal2.GbUploaded__c);
        System.assertEquals(SNG_TerminalQuery.UNABLE_TO_LOAD, terminal2.GbDownloaded__c);
        System.assertEquals(SNG_TerminalQuery.UNABLE_TO_LOAD, terminal2.GbTotal__c);
    
        //testProcessSunnyDay()
        Map<String, Id> macAddressToTerminalIds = new Map<String, Id>();
        macAddressToTerminalIds.put(macAddress1, terminal1.Id);
        macAddressToTerminalIds.put(macAddress2, terminal2.Id);
        
        Map<Id, Terminal__c> terminals = new Map<Id, Terminal__c>();
        terminals.put(terminal1.Id, terminal1);
        terminals.put(terminal2.Id, terminal2);
        
        SNG_UsageService.UsageAndErrors uae1 = new SNG_UsageService.UsageAndErrors();
        uae1.macAddress = formatMacAddress(macAddress1);
        uae1.aggregateAcctInputOctets = 1234567L;
        uae1.aggregateAcctOutputOctets = 2345678L;
        
        SNG_UsageService.UsageAndErrors uae2 = new SNG_UsageService.UsageAndErrors();
        uae2.macAddress = formatMacAddress(macAddress1);
        uae2.aggregateAcctInputOctets = 65421L;
        uae2.aggregateAcctOutputOctets = 32145L;
        
        List<SNG_UsageService.UsageAndErrors> uaes1 = new List<SNG_UsageService.UsageAndErrors>();
        uaes1.add(uae1);
        uaes1.add(uae2);
        
        SNG_UsageService.UsageAndErrors uae3 = new SNG_UsageService.UsageAndErrors();
        uae3.macAddress = formatMacAddress(macAddress2);
        uae3.aggregateAcctInputOctets = 98612L;
        uae3.aggregateAcctOutputOctets = 561235L;
        
        SNG_UsageService.UsageAndErrors uae4 = new SNG_UsageService.UsageAndErrors();
        uae4.macAddress = formatMacAddress(macAddress2);
        uae4.aggregateAcctInputOctets = 12678L;
        uae4.aggregateAcctOutputOctets = 234L;
        
        List<SNG_UsageService.UsageAndErrors> uaes2 = new List<SNG_UsageService.UsageAndErrors>();
        uaes2.add(uae3);
        uaes2.add(uae4);
        
        SNG_UsageService.Response response = new SNG_UsageService.Response();
        response.data = new List<List<SNG_UsageService.UsageAndErrors>>();
        response.data.add(uaes1);
        response.data.add(uaes2);
        
        //Test.startTest();
        // nothing to test. just verify it doesn't throw.
        SNG_UtUsageAggregateUpdater.process(terminals, macAddressToTerminalIds, response);
        Test.stopTest();

        Decimal downloadCount =  SNG_UsageAggregateUpdateHelper.convertToGb(uae1.aggregateAcctInputOctets) 
                            + SNG_UsageAggregateUpdateHelper.convertToGb(uae2.aggregateAcctInputOctets);
        Decimal uploadCount =   SNG_UsageAggregateUpdateHelper.convertToGb(uae1.aggregateAcctOutputOctets) 
                           +  SNG_UsageAggregateUpdateHelper.convertToGb(uae2.aggregateAcctOutputOctets);
        Decimal totalCount = downloadCount + uploadCount;
        System.assertEquals(downloadCount, Decimal.valueOf(terminal1.GbDownloaded__c));
        System.assertEquals(uploadCount, Decimal.valueOf(terminal1.GbUploaded__c));
        System.assertEquals(totalCount, Decimal.valueOf(terminal1.GbTotal__c));
        
        downloadCount =  SNG_UsageAggregateUpdateHelper.convertToGb(uae3.aggregateAcctInputOctets) 
                            + SNG_UsageAggregateUpdateHelper.convertToGb(uae4.aggregateAcctInputOctets);
        uploadCount =   SNG_UsageAggregateUpdateHelper.convertToGb(uae3.aggregateAcctOutputOctets) 
                           +  SNG_UsageAggregateUpdateHelper.convertToGb(uae4.aggregateAcctOutputOctets);
        totalCount = downloadCount + uploadCount;
        System.assertEquals(downloadCount, Decimal.valueOf(terminal2.GbDownloaded__c));
        System.assertEquals(uploadCount, Decimal.valueOf(terminal2.GbUploaded__c));
        System.assertEquals(totalCount, Decimal.valueOf(terminal2.GbTotal__c));    
    }
    
    static testMethod void testProcessSunnyDayWithOneMissing()
    {
        SNG_MockCustomSettings.initialize();

        Account account = SNG_TestUtilities.insertAccount('testAccount');

        String terminalNickname1 = 'Terminal1';
        String macAddress1 = '00:a0:bc:11:22:33';
        SNG_TestUtilities.insertEquipment(terminalNickname1, macAddress1, account, 'ser1', true);
        
        String terminalNickname2 = 'Terminal2';
        String macAddress2 = '00:a0:bc:11:22:44';
        SNG_TestUtilities.insertEquipment(terminalNickname2, macAddress2, account, 'ser2', true);
        
        String terminalNickname3 = 'Terminal3';
        String macAddress3 = '00:a0:bc:11:22:55';
        SNG_TestUtilities.insertEquipment(terminalNickname3, macAddress3, account, 'ser3', true);

        Terminal__c terminal1 = [SELECT Name, GbUploaded__c, GbDownloaded__c, GbTotal__c FROM Terminal__c WHERE Nickname__c = :terminalNickname1];
        Terminal__c terminal2 = [SELECT Name, GbUploaded__c, GbDownloaded__c, GbTotal__c FROM Terminal__c WHERE Nickname__c = :terminalNickname2];
        Terminal__c terminal3 = [SELECT Name, GbUploaded__c, GbDownloaded__c, GbTotal__c FROM Terminal__c WHERE Nickname__c = :terminalNickname3];
        
        
        Map<String, Id> macAddressToTerminalIds = new Map<String, Id>();
        macAddressToTerminalIds.put(macAddress1, terminal1.Id);
        macAddressToTerminalIds.put(macAddress2, terminal2.Id);
        macAddressToTerminalIds.put(macAddress3, terminal3.Id);
        
        Map<Id, Terminal__c> terminals = new Map<Id, Terminal__c>();
        terminals.put(terminal1.Id, terminal1);
        terminals.put(terminal2.Id, terminal2);
        terminals.put(terminal3.Id, terminal3);
        
        //construct Response
        
        SNG_UsageService.UsageAndErrors uae1 = new SNG_UsageService.UsageAndErrors();
        uae1.macAddress = formatMacAddress(macAddress1);
        uae1.aggregateAcctInputOctets = 1256712L;
        uae1.aggregateAcctOutputOctets = 561389124L;
        
        SNG_UsageService.UsageAndErrors uae2 = new SNG_UsageService.UsageAndErrors();
        uae2.macAddress = formatMacAddress(macAddress1);
        uae2.aggregateAcctInputOctets = 7895136L;
        uae2.aggregateAcctOutputOctets = 18742311L;
        
        List<SNG_UsageService.UsageAndErrors> uaes1 = new List<SNG_UsageService.UsageAndErrors>();
        uaes1.add(uae1);
        uaes1.add(uae2);
        
        SNG_UsageService.UsageAndErrors uae3 = new SNG_UsageService.UsageAndErrors();
        uae3.macAddress = formatMacAddress(macAddress2);
        uae3.aggregateAcctInputOctets = 8876163L;
        uae3.aggregateAcctOutputOctets = 57481312L;
        
        SNG_UsageService.UsageAndErrors uae4 = new SNG_UsageService.UsageAndErrors();
        uae4.macAddress = formatMacAddress(macAddress2);
        uae4.aggregateAcctInputOctets = 4312L;
        uae4.aggregateAcctOutputOctets = 123678L;
        
        List<SNG_UsageService.UsageAndErrors> uaes2 = new List<SNG_UsageService.UsageAndErrors>();
        uaes2.add(uae3);
        uaes2.add(uae4);
        
        
        SNG_UsageService.Response response = new SNG_UsageService.Response();
        response.data = new List<List<SNG_UsageService.UsageAndErrors>>();
        response.data.add(uaes1);
        response.data.add(uaes2);
        
        
        Test.startTest();
        // nothing to test. just verify it doesn't throw.
        SNG_UtUsageAggregateUpdater.process(terminals, macAddressToTerminalIds, response);
        
        try
        {
            SNG_UtUsageAggregateUpdater.process(null, null, null);
            System.assert(true);
        }
        catch (Exception e)
        {
            System.assert(false);
        }
        
        try
        {
            // nothing to test. just verify it doesn't throw.
            SNG_UtUsageAggregateUpdater.processException(null);
            System.assert(true);
        }
        catch (Exception e)
        {
            System.assert(false);
        }

        Test.stopTest();
        
        // no need to query since the update trigger was removed. Just ensure the objects were updated.
        //terminal1 = [SELECT Name, GbUploaded__c, GbDownloaded__c, GbTotal__c FROM Terminal__c WHERE Nickname__c = :terminalNickname1];
        //terminal2 = [SELECT Name, GbUploaded__c, GbDownloaded__c, GbTotal__c FROM Terminal__c WHERE Nickname__c = :terminalNickname2];
       
       
        Decimal downloadCount =  SNG_UsageAggregateUpdateHelper.convertToGb(uae1.aggregateAcctInputOctets + uae2.aggregateAcctInputOctets);
        Decimal uploadCount =   SNG_UsageAggregateUpdateHelper.convertToGb(uae1.aggregateAcctOutputOctets + uae2.aggregateAcctOutputOctets);
        Decimal totalCount = downloadCount + uploadCount;
        System.assertEquals(downloadCount, Decimal.valueOf(terminal1.GbDownloaded__c));
        System.assertEquals(uploadCount, Decimal.valueOf(terminal1.GbUploaded__c));
        System.assertEquals(totalCount, Decimal.valueOf(terminal1.GbTotal__c));
        
        downloadCount =  SNG_UsageAggregateUpdateHelper.convertToGb(uae3.aggregateAcctInputOctets + uae4.aggregateAcctInputOctets);
        uploadCount =   SNG_UsageAggregateUpdateHelper.convertToGb(uae3.aggregateAcctOutputOctets + uae4.aggregateAcctOutputOctets);
        totalCount = downloadCount + uploadCount;
        System.assertEquals(downloadCount, Decimal.valueOf(terminal2.GbDownloaded__c));
        System.assertEquals(uploadCount, Decimal.valueOf(terminal2.GbUploaded__c));
        System.assertEquals(totalCount, Decimal.valueOf(terminal2.GbTotal__c));   
        
        // terminal 3 is not in response. should be zeroed out.
        System.assertEquals(0, Decimal.valueOf(terminal3.GbDownloaded__c));
        System.assertEquals(0, Decimal.valueOf(terminal3.GbUploaded__c));
        System.assertEquals(0, Decimal.valueOf(terminal3.GbTotal__c));     
    }
    
    private static String formatMacAddress(String macAddress){
        return macAddress.remove(':').toUpperCase();
    } 

    //**********************************************************
    // TEST SNG_UtUsageHistoryUnitTest
    //**********************************************************
    static testMethod void testGetUsageHistorySunnyDay()
    {
        SNG_MockCustomSettings.initialize();

        Modem__c modem = SNG_TestUtilities.insertEquipment('testTerminal', SNG_MockUsageServiceHttpCallout.SUNNY_DAY_MAC_ADDRESS_SINGLE, 'testAccount', true);
        Product2 servicePlanType = SNG_TestUtilities.insertProduct2('servicePlanType', 'Service Plan Types', true);
        
        DateTime expectedStartTime = (DateTime) JSON.deserialize('"' + SNG_MockUsageServiceHttpCallout.SINGLE_START_TIME + '"', DateTime.class);
        DateTime expectedEndTime = (DateTime) JSON.deserialize('"' + SNG_MockUsageServiceHttpCallout.SINGLE_END_TIME + '"', DateTime.class);

        DateTime updatedStartTime = DateTime.newInstance(expectedStartTime.getTime());
        DateTime updatedEndTime = DateTime.newInstance(expectedEndTime.getTime());

       
        Date startDate = updatedStartTime.dateGmt();
        Date endDate = updatedEndTime.dateGmt();

        ServicePlan__c servicePlan = SNG_TestUtilities.insertServicePlan(modem.Account__r, servicePlanType, startDate, endDate);
        ModemServicePlan__c msp = SNG_TestUtilities.insertModemServicePlan(modem, servicePlan);

        List<ModemServicePlan__c> msps = [SELECT StartDate__c, EndDate__c FROM ModemServicePlan__c];
        System.debug(msps);
        
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new SNG_MockUsageServiceHttpCallout());
        ApexPages.Standardcontroller sc = new ApexPages.StandardController(modem.Terminal__r);
        SNG_UtUsageHistory usageHistory = new SNG_UtUsageHistory(sc);

        usageHistory.startDate = startDate.format();
        usageHistory.endDate = endDate.format();  
        

        DateTime requestTimestamp = DateTime.Now();
        usageHistory.getUsageHistory();
        

        String expectedDownloadStr = SNG_UsageAggregateUpdateHelper.convertToGb(SNG_MockUsageServiceHttpCallout.SINGLE_AGGREGATE_DOWNLOAD) + ' ' + usageHistory.byteCountUnit;
        String expectedUploadStr = SNG_UsageAggregateUpdateHelper.convertToGb(SNG_MockUsageServiceHttpCallout.SINGLE_AGGREGATE_UPLOAD) + ' ' + usageHistory.byteCountUnit;
        System.assertEquals(expectedDownloadStr, usageHistory.bytesDownloadedStr);
        System.assertEquals(expectedUploadStr, usageHistory.bytesUploadedStr);
        System.assert(requestTimestamp.getTime() <= usageHistory.dataAsOf);
        System.assertEquals(true, usageHistory.validData);

        List<Decimal[]> downloadByteCountArray = usageHistory.downloadByteCountArr;
        List<Decimal[]> uploadByteCountArray = usageHistory.uploadByteCountArr;

        System.assertEquals(24*4 + 1, downloadByteCountArray.size());
        System.assertEquals(uploadByteCountArray.size(), downloadByteCountArray.size());

        long expectedStartTimeLong = updatedStartTime.getTime();
        for (integer i = 0; i < 48; ++i)
        {
            System.assertEquals(2, downloadByteCountArray.get(i).size());
            System.assertEquals(expectedStartTimeLong, downloadByteCountArray.get(i)[0]);
            System.assertEquals(0, downloadByteCountArray.get(i)[1]);

            System.assertEquals(2, uploadByteCountArray.get(i).size());
            System.assertEquals(expectedStartTimeLong, uploadByteCountArray.get(i)[0]);
            System.assertEquals(0, uploadByteCountArray.get(i)[1]);             

            expectedStartTimeLong += (30 * 60) * 1000; //30 minute increments.
        }

        // this is for endTime 12:00 and the rest of the day.
        for (integer i = 48; i < 96; ++i)
        {
            System.assertEquals(2, downloadByteCountArray.get(i).size());
            System.assertEquals(expectedStartTimeLong, downloadByteCountArray.get(i)[0]);
            System.assertEquals((decimal)SNG_MockUsageServiceHttpCallout.SINGLE_AGGREGATE_DOWNLOAD/(decimal)ONE_GIGABYTE_IN_BYTES, downloadByteCountArray.get(i)[1]);
            
            System.assertEquals(2, uploadByteCountArray.get(i).size());
            System.assertEquals(expectedStartTimeLong, uploadByteCountArray.get(i)[0]);
            System.assertEquals((decimal)SNG_MockUsageServiceHttpCallout.SINGLE_AGGREGATE_UPLOAD/(decimal)ONE_GIGABYTE_IN_BYTES, uploadByteCountArray.get(i)[1]);

            expectedStartTimeLong += (30 * 60) * 1000; //30 minute increments.
        }
    }

    static testMethod void testGetUsageHistoryNoMacAddressAssociatedWithTerminal()
    {
        SNG_MockCustomSettings.initialize();

        Account account = SNG_TestUtilities.insertAccount('TestAccount');
        Terminal__c terminal = SNG_TestUtilities.insertTerminal(account, 'SO123', '1234561');

        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new SNG_MockUsageServiceHttpCallout());
        ApexPages.Standardcontroller sc = new ApexPages.StandardController(terminal);
        SNG_UtUsageHistory usageHistory = new SNG_UtUsageHistory(sc);

        usageHistory.startDate = SNG_DateUtils.todayGmt().format();
        usageHistory.endDate =  SNG_DateUtils.todayGmt().addDays(1).format();
        
        usageHistory.getUsageHistory();
        
        System.assertEquals('0.00 GB', usageHistory.bytesDownloadedStr);
        System.assertEquals('0.00 GB', usageHistory.bytesUploadedStr);
        System.assert(null == usageHistory.dataAsOf);
        System.assertEquals(false, usageHistory.validData);

        List<Decimal[]> downloadByteCountArray = usageHistory.downloadByteCountArr;

        System.assertEquals(0, downloadByteCountArray.size());
    }   


    static testMethod void testGetUsageHistoryInvalidMacAddressFormat()
    {
        SNG_MockCustomSettings.initialize();

        Modem__c modem = SNG_TestUtilities.insertEquipment('testTerminal', SNG_MockUsageServiceHttpCallout.INVALID_MAC_ADDRESS_RESPONSE_FORMAT, 'testAccount', true);
        Product2 servicePlanType = SNG_TestUtilities.insertProduct2('servicePlanType', 'Service Plan Types', true);
        
        DateTime expectedStartTime = (DateTime) JSON.deserialize('"' + SNG_MockUsageServiceHttpCallout.SINGLE_START_TIME + '"', DateTime.class);
        DateTime expectedEndTime = (DateTime) JSON.deserialize('"' + SNG_MockUsageServiceHttpCallout.SINGLE_END_TIME + '"', DateTime.class);

        DateTime updatedStartTime = DateTime.newInstance(expectedStartTime.getTime());
        DateTime updatedEndTime = DateTime.newInstance(expectedEndTime.getTime());

       
        Date startDate = updatedStartTime.dateGmt();
        Date endDate = updatedEndTime.dateGmt();

        ServicePlan__c servicePlan = SNG_TestUtilities.insertServicePlan(modem.Account__r, servicePlanType, startDate, endDate);
        ModemServicePlan__c msp = SNG_TestUtilities.insertModemServicePlan(modem, servicePlan);

        List<ModemServicePlan__c> msps = [SELECT StartDate__c, EndDate__c FROM ModemServicePlan__c];
        System.debug(msps);
        
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new SNG_MockUsageServiceHttpCallout());
        ApexPages.Standardcontroller sc = new ApexPages.StandardController(modem.Terminal__r);
        SNG_UtUsageHistory usageHistory = new SNG_UtUsageHistory(sc);

        usageHistory.startDate = startDate.format();
        usageHistory.endDate = endDate.format();  
        

        DateTime requestTimestamp = DateTime.Now();
        usageHistory.getUsageHistory();
        
        System.assertEquals('0.00 GB', usageHistory.bytesDownloadedStr);
        System.assertEquals('0.00 GB', usageHistory.bytesUploadedStr);
        System.assert(null == usageHistory.dataAsOf);
        System.assertEquals(false, usageHistory.validData);

        List<Decimal[]> downloadByteCountArray = usageHistory.downloadByteCountArr;

       System.assertEquals(0, downloadByteCountArray.size());

    }   


    static testMethod void testGetUsageHistoryHttpStatusFailure()
    {
        SNG_MockCustomSettings.initialize();

        Modem__c modem = SNG_TestUtilities.insertEquipment('testTerminal', SNG_MockUsageServiceHttpCallout.HTTP_STATUS_FAILURE_MAC_ADDRESS, 'testAccount', true);
        Product2 servicePlanType = SNG_TestUtilities.insertProduct2('servicePlanType', 'Service Plan Types', true);
        
        DateTime expectedStartTime = (DateTime) JSON.deserialize('"' + SNG_MockUsageServiceHttpCallout.SINGLE_START_TIME + '"', DateTime.class);
        DateTime expectedEndTime = (DateTime) JSON.deserialize('"' + SNG_MockUsageServiceHttpCallout.SINGLE_END_TIME + '"', DateTime.class);

        DateTime updatedStartTime = DateTime.newInstance(expectedStartTime.getTime());
        DateTime updatedEndTime = DateTime.newInstance(expectedEndTime.getTime());

       
        Date startDate = updatedStartTime.dateGmt();
        Date endDate = updatedEndTime.dateGmt();

        ServicePlan__c servicePlan = SNG_TestUtilities.insertServicePlan(modem.Account__r, servicePlanType, startDate, endDate);
        ModemServicePlan__c msp = SNG_TestUtilities.insertModemServicePlan(modem, servicePlan);

        List<ModemServicePlan__c> msps = [SELECT StartDate__c, EndDate__c FROM ModemServicePlan__c];
        System.debug(msps);
        
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new SNG_MockUsageServiceHttpCallout());
        ApexPages.Standardcontroller sc = new ApexPages.StandardController(modem.Terminal__r);
        SNG_UtUsageHistory usageHistory = new SNG_UtUsageHistory(sc);

        usageHistory.startDate = startDate.format();
        usageHistory.endDate = endDate.format();  
        

        DateTime requestTimestamp = DateTime.Now();
        usageHistory.getUsageHistory();
        
        System.assertEquals('0.00 GB', usageHistory.bytesDownloadedStr);
        System.assertEquals('0.00 GB', usageHistory.bytesUploadedStr);
        System.assert(null == usageHistory.dataAsOf);
        System.assertEquals(false, usageHistory.validData);

        List<Decimal[]> downloadByteCountArray = usageHistory.downloadByteCountArr;

        System.assertEquals(0, downloadByteCountArray.size());

    }   
}