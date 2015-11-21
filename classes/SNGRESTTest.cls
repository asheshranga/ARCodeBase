/**
 * This class contains unit tests for validating the behavior of all SNG_REST Apex classes
 */ 
@isTest
@testVisible
private class SNGRESTTest 
{

    /**
     * Verify response object from API call
     */
    private static void compareResponses(SNG_REST_JsonResponse actualResponse, SNGHttpUtilities.Status statusExpected, 
                                        SNG_REST_Error.SubCode errorSubCodeExpected, String errorMessageExpected, 
                                        SNG_REST_IJsonResponseData dataExpected) 
    { 
        SNG_REST_JsonResponse expectedResponse = new SNG_REST_JsonResponse(statusExpected, errorSubCodeExpected, errorMessageExpected, dataExpected);
        System.assertEquals(expectedResponse, actualResponse);  
    }
    
    //**********************************************************
    // TEST SNG_REST_Utilities (SNG_REST_UtilitiesUnitTest)
    //**********************************************************
    static testMethod void testDoesOwnOwnMacAddressSuccess()
    {
        Profile p = [SELECT Id FROM Profile WHERE Name = 'SNG Customer User'];

        Account a = new Account(name ='Red Cross', BillingStreet = '6155 El Camino Real', 
                                BillingState = 'California', BillingCity = 'San Diego',
                                BillingPostalCode = '92008');
        insert a;

        Contact c = new Contact(AccountId = a.id, firstname='firstname', lastname = 'testName', Phone='760-111-2222');
        insert c;     

        User u = new User(Alias = 'tempuser', Email='tempuser@testorg.com', 
        EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
        LocaleSidKey='en_US', ProfileId = p.Id, 
        TimeZoneSidKey='America/Los_Angeles', UserName='tempuser@testorg.com',
        ContactId= c.Id);

        System.runAs(u) 
        {
            System.assert(false == SNG_REST_Utilities.isUserAuthorized('bad mac address'));
    
            SNG_TestUtilities.insertEquipment('testEquipment', '00:a0:bc:44:55:11', a, true);

            System.assert(true == SNG_REST_Utilities.isUserAuthorized('00:a0:bc:44:55:11'));
            // 00:a0:bc:36:28:e2
            // The following code runs as user 'u' 
            System.debug('Current User: ' + UserInfo.getUserName());
            System.debug('Current Profile: ' + UserInfo.getProfileId()); 
        }       
    }

    //**********************************************************
    // TEST SNG_REST_TerminalIdMacAddressOutputUT
    //**********************************************************
    static testMethod void testTerminalIdMacAddressOutput() {
        // TO DO: implement unit test
        String terminalId = 'T1000';
        String macAddress = '00:a0:bc:11:22:33';
        
        String terminalId1 = 'T1001';
        String macAddress1 = '00:a0:bc:11:33:22';
        
        SNG_REST_TerminalIdMacAddressOutput timao1 = new SNG_REST_TerminalIdMacAddressOutput(terminalId, macAddress);
        SNG_REST_TerminalIdMacAddressOutput timao2 = new SNG_REST_TerminalIdMacAddressOutput(terminalId, macAddress);
        
        SNG_REST_TerminalIdMacAddressOutput timao3 = new SNG_REST_TerminalIdMacAddressOutput(terminalId1, macAddress);
        SNG_REST_TerminalIdMacAddressOutput timao4 = new SNG_REST_TerminalIdMacAddressOutput(terminalId, macAddress1);
        SNG_REST_TerminalIdMacAddressOutput timao5 = new SNG_REST_TerminalIdMacAddressOutput(terminalId1, macAddress1);
        
        System.assert(timao1 == timao2);
        System.assertEquals(timao1.hashCode(), timao2.hashCode());
        
        System.assert(timao1 != timao3);
        System.assertNotEquals(timao1.hashCode(), timao3.hashCode());
        
        System.assert(timao1 != timao4);
        System.assertNotEquals(timao1.hashCode(), timao4.hashCode());
        
        System.assert(timao1 != timao5);
        System.assertNotEquals(timao1.hashCode(), timao5.hashCode());
    }
        
    //**********************************************************
    // TEST SNG_REST_ServicePlanUsage
    //**********************************************************
    static testMethod void getModemServicePlans2() 
    { 
        SNG_MockCustomSettings.initialize();

        // Add modem to Salesforce 
        Account account = SNG_TestUtilities.insertAccount('testAccount');
        Terminal__c terminal = SNG_TestUtilities.insertTerminal(account, '11111', '1234561');
        Modem__c modem = SNG_TestUtilities.insertModem(account, '11111', '00:a0:bc:22:33:44', '123', terminal);  
        
        // Create Service Plan
        Product2 servicePlanType = SNG_TestUtilities.insertServicePlanType(true);
        ServicePlan__c servicePlan_1 = SNG_TestUtilities.insertServicePlan(account,servicePlanType, 
                                                                            Date.valueOf('2014-05-01'), Date.valueOf('2014-05-30'));
        // Create Modem Service Plans
        ModemServicePlan__c msp1_inRange = new ModemServicePlan__c(); 
        msp1_inRange.Modem__c = modem.Id;
        msp1_inRange.Modem__r = modem;
        msp1_inRange.ServicePlan__c = servicePlan_1.Id;
        msp1_inRange.ServicePlan__r = servicePlan_1;
        msp1_inRange.StartDate__c = Date.valueOf('2014-05-02');
        msp1_inRange.EndDate__c = Date.valueOf('2014-05-04');
        insert msp1_inRange;
        
        ModemServicePlan__c msp2_inRange = new ModemServicePlan__c();
        msp2_inRange.Modem__c = modem.Id;
        msp2_inRange.Modem__r = modem;
        msp2_inRange.ServicePlan__c = servicePlan_1.Id;
        msp2_inRange.ServicePlan__r = servicePlan_1;
        msp2_inRange.StartDate__c = Date.valueOf('2014-05-05');
        msp2_inRange.EndDate__c = Date.valueOf('2014-05-07');
        insert msp2_inRange;
        
        ModemServicePlan__c msp_outOfRange = new ModemServicePlan__c();
        msp_outOfRange.Modem__c = modem.Id;
        msp_outOfRange.Modem__r = modem;
        msp_outOfRange.ServicePlan__c = servicePlan_1.Id;
        msp_outOfRange.ServicePlan__r = servicePlan_1;
        msp_outOfRange.StartDate__c = Date.valueOf('2014-05-20');
        msp_outOfRange.EndDate__c = Date.valueOf('2014-05-25');
        insert msp_outOfRange; 
        
        ServicePlan__c servicePlanObj = [SELECT Name From ServicePlan__c WHERE Id = :servicePlan_1.Id];
        String servicePlanId = servicePlanObj.Name;

        Test.startTest();
        
        SNG_REST_ServicePlanUsage spu = new SNG_REST_ServicePlanUsage(servicePlanId, '2014-05-01', '2014-05-15');
        List<ModemServicePlan__c> mspsInRange = spu.getModemServicePlans('2014-05-01', '2014-05-15');
        System.assertEquals(2, mspsInRange.size());      
        
        mspsInRange = spu.getModemServicePlans('2014-05-01', '2014-05-24');
        System.assertEquals(3, mspsInRange.size()); 
        
        mspsInRange = spu.getModemServicePlans('2014-05-05', '2014-05-08');
        System.assertEquals(1, mspsInRange.size());
        
        mspsInRange = spu.getModemServicePlans('2014-05-09', '2014-05-10');
        System.assertEquals(0, mspsInRange.size());
        Test.stopTest();
    }

    static testMethod void testInvalidInputInvalidServicePlanIdFormat()
    {
        DateTime startDate = SNG_DateUtils.todayGmt().toStartOfMonth();
        DateTime endDate = SNG_DateUtils.todayGmt().addMonths(1).addDays(-1);
    
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        
        String invalidFormatServicePlanId = 'SERVICE_PLAN_INVALID';
        req.requestURI = '/service-plan/' + invalidFormatServicePlanId + '/usage';
        req.resourcePath = '/service-plan/*/usage';
        req.addParameter('start-date', startDate.formatGmt('YYYY-MM-dd'));
        req.addParameter('end-date', endDate.formatGmt('YYYY-MM-dd'));
        
        req.httpMethod = 'POST';
        
        RestContext.request = req;
        RestContext.response = res;
        
        SNG_REST_ServicePlanUsage servicePlanUsage = new SNG_REST_ServicePlanUsage(RestContext.request);
        SNG_REST_JsonResponse response = servicePlanUsage.get();
        
        integer expectedErrorCode = SNG_REST_Error.getErrorCode(SNGHttpUtilities.Status.INPUT_VALIDATION_ERROR, 
                                                                SNG_REST_Error.SubCode.SALESFORCE_GENERATED_ERROR);
         
        System.assertEquals(SNGHttpUtilities.Status.INPUT_VALIDATION_ERROR.name(), response.status);
        System.assertEquals(expectedErrorCode, response.errorCode);
        System.assertEquals(SNG_REST_Error.INPUT_INVALID_FORMAT, response.errorMessage);
        System.assertEquals(null, response.data);
        
    }
    
    static testMethod void testInvalidInputInvalidServicePlanIdFormatWithCtor()
    {
        DateTime startDate = SNG_DateUtils.todayGmt().toStartOfMonth();
        DateTime endDate = SNG_DateUtils.todayGmt().addMonths(1).addDays(-1);

        String invalidFormatServicePlanId = 'SERVICE_PLAN_INVALID';

        
        SNG_REST_ServicePlanUsage servicePlanUsage = new SNG_REST_ServicePlanUsage(invalidFormatServicePlanId, startDate.formatGmt('YYYY-MM-dd'), endDate.formatGmt('YYYY-MM-dd'));
        SNG_REST_JsonResponse response = servicePlanUsage.get();
        
        integer expectedErrorCode = SNG_REST_Error.getErrorCode(SNGHttpUtilities.Status.INPUT_VALIDATION_ERROR, 
                                                                SNG_REST_Error.SubCode.SALESFORCE_GENERATED_ERROR);
         
        System.assertEquals(SNGHttpUtilities.Status.INPUT_VALIDATION_ERROR.name(), response.status);
        System.assertEquals(expectedErrorCode, response.errorCode);
        System.assertEquals(SNG_REST_Error.INPUT_INVALID_FORMAT, response.errorMessage);
        System.assertEquals(null, response.data);
    }
    
    static testMethod void testInvalidInputInvalidStartDateInvalidFormat()
    {
        DateTime startDate = SNG_DateUtils.todayGmt().addDays(-SNG_DateUtils.todayGmt().day() + 1);
        DateTime endDate = SNG_DateUtils.todayGmt().addMonths(1).addDays(-1);
    
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        
        String invalidFormatServicePlanId = 'SP-1000';
        req.requestURI = '/service-plan/' + invalidFormatServicePlanId + '/usage';
        req.resourcePath = '/service-plan/*/usage';
        req.addParameter('start-date', 'Invalid Start Date');
        req.addParameter('end-date', endDate.formatGmt('YYYY-MM-dd'));
        
        req.httpMethod = 'POST';
        
        RestContext.request = req;
        RestContext.response = res;
        
        SNG_REST_ServicePlanUsage servicePlanUsage = new SNG_REST_ServicePlanUsage(RestContext.request);
        SNG_REST_JsonResponse response = servicePlanUsage.get();
        
        integer expectedErrorCode = SNG_REST_Error.getErrorCode(SNGHttpUtilities.Status.INPUT_VALIDATION_ERROR, 
                                                                SNG_REST_Error.SubCode.SALESFORCE_GENERATED_ERROR);
         
        System.assertEquals(SNGHttpUtilities.Status.INPUT_VALIDATION_ERROR.name(), response.status);
        System.assertEquals(expectedErrorCode, response.errorCode);
        System.assertEquals(SNG_REST_Error.INVALID_DATE +  ' Dates must be in YYYY-MM-DD format.', response.errorMessage);
        System.assertEquals(null, response.data);
    }
    
    static testMethod void testInvalidInputInvalidEndDateInvalidFormat()
    {
        DateTime startDate = SNG_DateUtils.todayGmt().toStartOfMonth();
        DateTime endDate = SNG_DateUtils.todayGmt().addMonths(1).addDays(-1);
    
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        
        String invalidFormatServicePlanId = 'SP-1000';
        req.requestURI = '/service-plan/' + invalidFormatServicePlanId + '/usage';
        req.resourcePath = '/service-plan/*/usage';
        req.addParameter('start-date', startDate.formatGmt('YYYY-MM-DD'));
        req.addParameter('end-date', endDate.formatGmt('YYYY/MM/dd'));
        
        req.httpMethod = 'POST';
        
        RestContext.request = req;
        RestContext.response = res;
        
        SNG_REST_ServicePlanUsage servicePlanUsage = new SNG_REST_ServicePlanUsage(RestContext.request);
        SNG_REST_JsonResponse response = servicePlanUsage.get();
        
        integer expectedErrorCode = SNG_REST_Error.getErrorCode(SNGHttpUtilities.Status.INPUT_VALIDATION_ERROR, 
                                                                SNG_REST_Error.SubCode.SALESFORCE_GENERATED_ERROR);
         
        System.assertEquals(SNGHttpUtilities.Status.INPUT_VALIDATION_ERROR.name(), response.status);
        System.assertEquals(expectedErrorCode, response.errorCode);
        System.assertEquals(SNG_REST_Error.INVALID_DATE +  ' Dates must be in YYYY-MM-DD format.', response.errorMessage);
        System.assertEquals(null, response.data);
    }
    
    static testMethod void testInvalidInputInvalidStartDateInFuture()
    {
        DateTime startDate = SNG_DateUtils.todayGmt().toStartOfMonth().addYears(1);
        DateTime endDate = SNG_DateUtils.todayGmt().addMonths(1).addDays(-1).addYears(1);
    
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        
        String invalidFormatServicePlanId = 'SP-1000';
        req.requestURI = '/service-plan/' + invalidFormatServicePlanId + '/usage';
        req.resourcePath = '/service-plan/*/usage';
        req.addParameter('start-date', startDate.formatGmt('YYYY-MM-dd'));
        req.addParameter('end-date', endDate.formatGmt('YYYY-MM-dd'));
        
        req.httpMethod = 'POST';
        
        RestContext.request = req;
        RestContext.response = res;
        

        SNG_REST_ServicePlanUsage servicePlanUsage = new SNG_REST_ServicePlanUsage(RestContext.request);
        SNG_REST_JsonResponse response = servicePlanUsage.get();
        
        integer expectedErrorCode = SNG_REST_Error.getErrorCode(SNGHttpUtilities.Status.INPUT_VALIDATION_ERROR, 
                                                                SNG_REST_Error.SubCode.SALESFORCE_GENERATED_ERROR);
         
        System.assertEquals(SNGHttpUtilities.Status.INPUT_VALIDATION_ERROR.name(), response.status);
        System.assertEquals(expectedErrorCode, response.errorCode);
        System.assertEquals(SNG_REST_Error.START_DATE_IN_FUTURE, response.errorMessage);
        System.assertEquals(null, response.data);
    }
    
    static testMethod void testInvalidInputInvalidEndDateBeforeStartDate()
    {
        DateTime startDate = SNG_DateUtils.todayGmt().addMonths(-1).toStartOfMonth();
        DateTime endDate = startDate.addDays(1);
    
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        
        String invalidFormatServicePlanId = 'SP-1000';
        req.requestURI = '/service-plan/' + invalidFormatServicePlanId + '/usage';
        req.resourcePath = '/service-plan/*/usage';
        req.addParameter('start-date', endDate.formatGmt('YYYY-MM-dd'));  //swap dates
        req.addParameter('end-date', startDate.formatGmt('YYYY-MM-dd'));  //swap dates
        
        req.httpMethod = 'POST';
        
        RestContext.request = req;
        RestContext.response = res;
        
        SNG_REST_ServicePlanUsage servicePlanUsage = new SNG_REST_ServicePlanUsage(RestContext.request);
        SNG_REST_JsonResponse response = servicePlanUsage.get();
        
        integer expectedErrorCode = SNG_REST_Error.getErrorCode(SNGHttpUtilities.Status.INPUT_VALIDATION_ERROR, 
                                                                SNG_REST_Error.SubCode.SALESFORCE_GENERATED_ERROR);
         
        System.assertEquals(SNGHttpUtilities.Status.INPUT_VALIDATION_ERROR.name(), response.status);
        System.assertEquals(expectedErrorCode, response.errorCode);
        System.assertEquals(SNG_REST_Error.END_DATE_BEFORE_START_DATE, response.errorMessage);
        System.assertEquals(null, response.data);
    }   


    static testMethod void testInvalidInputInvalidNonExistentServicePlandId()
    {
        DateTime startDate = SNG_DateUtils.todayGmt().toStartOfMonth();
        DateTime endDate = SNG_DateUtils.todayGmt().addMonths(1).addDays(-1);
    
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        
        String invalidFormatServicePlanId = 'SP-1000';
        req.requestURI = '/service-plan/' + invalidFormatServicePlanId + '/usage';
        req.resourcePath = '/service-plan/*/usage';
        req.addParameter('start-date', startDate.formatGmt('YYYY-MM-dd'));
        req.addParameter('end-date', endDate.formatGmt('YYYY-MM-dd'));
        
        req.httpMethod = 'POST';
        
        RestContext.request = req;
        RestContext.response = res;
        
        SNG_REST_ServicePlanUsage servicePlanUsage = new SNG_REST_ServicePlanUsage(RestContext.request);
        SNG_REST_JsonResponse response = servicePlanUsage.get();
        
        integer expectedErrorCode = SNG_REST_Error.getErrorCode(SNGHttpUtilities.Status.INPUT_VALIDATION_ERROR, 
                                                                SNG_REST_Error.SubCode.SALESFORCE_GENERATED_ERROR);
         
        System.assertEquals(SNGHttpUtilities.Status.INPUT_VALIDATION_ERROR.name(), response.status);
        System.assertEquals(expectedErrorCode, response.errorCode);
        System.assertEquals(SNG_REST_Error.IDS_INVALID, response.errorMessage);
        System.assertEquals(null, response.data);
    }
    
    static testMethod void testValidSevicePlanNoActiveMsp() 
    {
        SNG_MockCustomSettings.initialize();
        
        //create servicePlan
        Account account = SNG_TestUtilities.insertAccount('Red Cross');
        ServicePlan__c servicePlan = SNG_TestUtilities.insertServicePlan(account, true);
        
        DateTime startDate = SNG_DateUtils.todayGmt().toStartOfMonth();
        DateTime endDate = SNG_DateUtils.todayGmt().addMonths(1).addDays(-1);
    
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        
        ServicePlan__c servicePlanObj = [SELECT Name From ServicePlan__c WHERE Id = :servicePlan.Id];
        String servicePlanId = servicePlanObj.Name;
        
        req.requestURI = '/service-plan/' + servicePlanId + '/usage';
        req.resourcePath = '/service-plan/*/usage';
        req.addParameter('start-date', startDate.formatGmt('YYYY-MM-dd'));
        req.addParameter('end-date', endDate.formatGmt('YYYY-MM-dd'));
        
        req.httpMethod = 'POST';
        
        RestContext.request = req;
        RestContext.response = res;
        
        SNG_REST_ServicePlanUsage servicePlanUsage = new SNG_REST_ServicePlanUsage(RestContext.request);
        SNG_REST_JsonResponse response = servicePlanUsage.get();
        
        integer expectedErrorCode = SNG_REST_Error.getErrorCode(SNGHttpUtilities.Status.ZERO_RESULTS, 
                                                                SNG_REST_Error.SubCode.SALESFORCE_GENERATED_ERROR);
        
        System.assertEquals(SNGHttpUtilities.Status.ZERO_RESULTS.name(), response.status);
        System.assertEquals(expectedErrorCode, response.errorCode);
        System.assertEquals(SNG_REST_ServicePlanUsage.NO_ACTIVE_MODEMS, response.errorMessage);
        System.assertEquals(null, response.data);
    }

    static testMethod void testWebServiceHttpStatusFail()
    {
          SNG_MockCustomSettings.initialize();
        
        //create servicePlan
        Account account = SNG_TestUtilities.insertAccount('Red Cross');
        ServicePlan__c servicePlan = SNG_TestUtilities.insertServicePlan(account, true);
        Modem__c modem = SNG_TestUtilities.insertEquipment('Terminal1', 
                                                           SNG_MockUsageServiceHttpCallout.HTTP_STATUS_FAILURE_MAC_ADDRESS,
                                                           account,
                                                           true);
                                                           
        ModemServicePlan__c msp = SNG_TestUtilities.insertModemServicePlan(modem, servicePlan);
        
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new SNG_MockUsageServiceHttpCallout());
        
        DateTime startDate = SNG_DateUtils.todayGmt().toStartOfMonth();
        DateTime endDate = SNG_DateUtils.todayGmt().addMonths(1).addDays(-1);
    
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        
        ServicePlan__c servicePlanObj = [SELECT Name From ServicePlan__c WHERE Id = :servicePlan.Id];
        String servicePlanId = servicePlanObj.Name;
        
        req.requestURI = '/service-plan/' + servicePlanId + '/usage';
        req.resourcePath = '/service-plan/*/usage';
        req.addParameter('start-date', startDate.formatGmt('YYYY-MM-dd'));
        req.addParameter('end-date', endDate.formatGmt('YYYY-MM-dd'));
        
        req.httpMethod = 'POST';
        
        RestContext.request = req;
        RestContext.response = res;
        
        SNG_REST_ServicePlanUsage servicePlanUsage = new SNG_REST_ServicePlanUsage(RestContext.request);
        SNG_REST_JsonResponse response = servicePlanUsage.get();
        
        integer expectedErrorCode = SNG_REST_Error.getErrorCode(SNGHttpUtilities.Status.SERVER_ERROR, 
                                                                SNG_REST_Error.SubCode.WEBSERVICE_GENERATED_ERROR);
         
        System.assertEquals(SNGHttpUtilities.Status.SERVER_ERROR.name(), response.status);
        System.assertEquals(expectedErrorCode, response.errorCode);
        System.assertEquals(SNG_REST_Error.GENERIC_WEBSERVICE_ERROR, response.errorMessage);
        System.assertEquals(null, response.data);

        Test.stopTest();
    }


    static testMethod void testWebServiceFailureStatus() 
    {
        SNG_MockCustomSettings.initialize();
        
        //create servicePlan
        Account account = SNG_TestUtilities.insertAccount('Red Cross');
        ServicePlan__c servicePlan = SNG_TestUtilities.insertServicePlan(account, true);
        Modem__c modem = SNG_TestUtilities.insertEquipment('Terminal1', 
                                                           SNG_MockUsageServiceHttpCallout.STATUS_FAILURE_DATA_EMPTY_MAC_ADDRESS,
                                                           account,
                                                           true);
                                                           
        ModemServicePlan__c msp = SNG_TestUtilities.insertModemServicePlan(modem, servicePlan);
        
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new SNG_MockUsageServiceHttpCallout());
        
        DateTime startDate = SNG_DateUtils.todayGmt().toStartOfMonth();
        DateTime endDate = SNG_DateUtils.todayGmt().addMonths(1).addDays(-1);
    
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        
        ServicePlan__c servicePlanObj = [SELECT Name From ServicePlan__c WHERE Id = :servicePlan.Id];
        String servicePlanId = servicePlanObj.Name;
        
        req.requestURI = '/service-plan/' + servicePlanId + '/usage';
        req.resourcePath = '/service-plan/*/usage';
        req.addParameter('start-date', startDate.formatGmt('YYYY-MM-dd'));
        req.addParameter('end-date', endDate.formatGmt('YYYY-MM-dd'));
        
        req.httpMethod = 'POST';
        
        RestContext.request = req;
        RestContext.response = res;
        
        SNG_REST_ServicePlanUsage servicePlanUsage = new SNG_REST_ServicePlanUsage(RestContext.request);
        SNG_REST_JsonResponse response = servicePlanUsage.get();
        
        integer expectedErrorCode = SNG_REST_Error.getErrorCode(SNGHttpUtilities.Status.SERVER_ERROR, 
                                                                SNG_REST_Error.SubCode.WEBSERVICE_GENERATED_ERROR);
         
        System.assertEquals(SNGHttpUtilities.Status.SERVER_ERROR.name(), response.status);
        System.assertEquals(expectedErrorCode, response.errorCode);
        System.assertEquals(SNG_REST_ServicePlanUsage.USAGE_SERVICE_ERROR + servicePlanId, response.errorMessage);
        System.assertEquals(null, response.data);
        
        Test.stopTest();
    }
    
    static testMethod void testWebServiceMacAddressReturnInvalidFormat()
    {
        SNG_MockCustomSettings.initialize();
        
        //create servicePlan
        Account account = SNG_TestUtilities.insertAccount('Red Cross');
        ServicePlan__c servicePlan = SNG_TestUtilities.insertServicePlan(account, true);
        Modem__c modem = SNG_TestUtilities.insertEquipment('Terminal1', 
                                                           SNG_MockUsageServiceHttpCallout.INVALID_MAC_ADDRESS_RESPONSE_FORMAT,
                                                           account,
                                                           true);
                                                           
        ModemServicePlan__c msp = SNG_TestUtilities.insertModemServicePlan(modem, servicePlan);
        
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new SNG_MockUsageServiceHttpCallout());
        
        DateTime startDate = SNG_DateUtils.todayGmt().toStartOfMonth();
        DateTime endDate = SNG_DateUtils.todayGmt().addMonths(1).addDays(-1);
    
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        
        ServicePlan__c servicePlanObj = [SELECT Name From ServicePlan__c WHERE Id = :servicePlan.Id];
        String servicePlanId = servicePlanObj.Name;
        
        req.requestURI = '/service-plan/' + servicePlanId + '/usage';
        req.resourcePath = '/service-plan/*/usage';
        req.addParameter('start-date', startDate.formatGmt('YYYY-MM-dd'));
        req.addParameter('end-date', endDate.formatGmt('YYYY-MM-dd'));
        
        req.httpMethod = 'POST';
        
        RestContext.request = req;
        RestContext.response = res;
        
        SNG_REST_ServicePlanUsage servicePlanUsage = new SNG_REST_ServicePlanUsage(RestContext.request);
        SNG_REST_JsonResponse response = servicePlanUsage.get();
        
        integer expectedErrorCode = SNG_REST_Error.getErrorCode(SNGHttpUtilities.Status.SERVER_ERROR, 
                                                                SNG_REST_Error.SubCode.WEBSERVICE_GENERATED_ERROR);
         
        System.assertEquals(SNGHttpUtilities.Status.SERVER_ERROR.name(), response.status);
        System.assertEquals(expectedErrorCode, response.errorCode);
        System.assertEquals(SNG_REST_Error.GENERIC_WEBSERVICE_ERROR, response.errorMessage);
        System.assertEquals(null, response.data);
        
        Test.stopTest();
    }
    
    static testMethod void testWebServiceSunnyDaySingleEntry() 
    {
        SNG_MockCustomSettings.initialize();
        
        Account account = SNG_TestUtilities.insertAccount('Red Cross');
        ServicePlan__c servicePlan = SNG_TestUtilities.insertServicePlan(account, true);
        Modem__c modem = SNG_TestUtilities.insertEquipment('Terminal1', 
                                                           SNG_MockUsageServiceHttpCallout.SUNNY_DAY_MAC_ADDRESS_SINGLE,
                                                           account, true);                                                           
        ModemServicePlan__c msp = SNG_TestUtilities.insertModemServicePlan(modem, servicePlan);
        
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new SNG_MockUsageServiceHttpCallout());
        
        DateTime startDate = SNG_DateUtils.todayGmt().toStartOfMonth();
        DateTime endDate = SNG_DateUtils.todayGmt().addMonths(1).addDays(-1);
    
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        
        ServicePlan__c servicePlanObj = [SELECT Name From ServicePlan__c WHERE Id = :servicePlan.Id];
        String servicePlanId = servicePlanObj.Name;
        
        req.requestURI = '/service-plan/' + servicePlanId + '/usage';
        req.resourcePath = '/service-plan/*/usage';
        req.addParameter('start-date', startDate.formatGmt('YYYY-MM-dd'));
        req.addParameter('end-date', endDate.formatGmt('YYYY-MM-dd'));
        
        req.httpMethod = 'POST';
        
        RestContext.request = req;
        RestContext.response = res;
        
        SNG_REST_ServicePlanUsage servicePlanUsage = new SNG_REST_ServicePlanUsage(RestContext.request);
        SNG_REST_JsonResponse response = servicePlanUsage.get();
        
        SNG_REST_ServicePlanUsageOutput.MacAddressUsageData expectedMaud =
             new SNG_REST_ServicePlanUsageOutput.MacAddressUsageData(SNG_MockUsageServiceHttpCallout.SUNNY_DAY_MAC_ADDRESS_SINGLE,
                                                                               SNG_MockUsageServiceHttpCallout.SINGLE_BSID_UPLOAD,
                                                                               SNG_MockUsageServiceHttpCallout.SINGLE_BSID_DOWNLOAD);
       
        List<SNG_REST_ServicePlanUsageOutput.MacAddressUsageData> expectedMauds = new List<SNG_REST_ServicePlanUsageOutput.MacAddressUsageData>();
        expectedMauds.add(expectedMaud);
        
        SNG_REST_ServicePlanUsageOutput expectedUsageOutput = new SNG_REST_ServicePlanUsageOutput(servicePlanId, expectedMauds);
       
          
        SNG_REST_JsonResponse expectedOutput = new SNG_REST_JsonResponse(SNGHttpUtilities.Status.OK, 
                                                                         SNG_REST_Error.SubCode.SALESFORCE_GENERATED_ERROR, 
                                                                         null, 
                                                                         expectedUsageOutput);
        System.assertEquals(expectedOutput, response);
        
        Test.stopTest();
    }
    
    static testMethod void testWebServiceSunnyDayDoubleEntry() 
    {
        SNG_MockCustomSettings.initialize();
        
        Account account = SNG_TestUtilities.insertAccount('Red Cross');
        ServicePlan__c servicePlan = SNG_TestUtilities.insertServicePlan(account, true);        
        
        List<Product2> terminalTypes = ViasatTestUtility.createProducts(2, 'Exede', SNG_Terminal.TERMINAL_TYPE_RECORD_TYPE_NAME, 'Terminal', true);
        insert terminalTypes;

        list<Terminal__c> terminals = SNG_TestUtilities.constructTerminals(account, 2, terminalTypes, 'Terminal');
        insert terminals;
       
        string[] macAddresses = new string[]{SNG_MockUsageServiceHttpCallout.SUNNY_DAY_MAC_ADDRESS_DOUBLE_A,
                                             SNG_MockUsageServiceHttpCallout.SUNNY_DAY_MAC_ADDRESS_DOUBLE_B};

        list<Modem__c> modems = SNG_TestUtilities.constructModems(new Account[]{account}, 2, terminals, macAddresses, '');
        insert modems;
        
        // insert Modem/Service Plan
        ModemServicePlan__c msp = SNG_TestUtilities.insertModemServicePlan(modems[0], servicePlan);        
        ModemServicePlan__c msp2 = SNG_TestUtilities.insertModemServicePlan(modems[1], servicePlan);
        
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new SNG_MockUsageServiceHttpCallout());
        
        DateTime startDate = SNG_DateUtils.todayGmt().toStartOfMonth();
        DateTime endDate = SNG_DateUtils.todayGmt().addMonths(1).addDays(-1);
    
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        
        ServicePlan__c servicePlanObj = [SELECT Name From ServicePlan__c WHERE Id = :servicePlan.Id];
        String servicePlanId = servicePlanObj.Name;
        
        req.requestURI = '/service-plan/' + servicePlanId + '/usage';
        req.resourcePath = '/service-plan/*/usage';
        req.addParameter('start-date', startDate.formatGmt('YYYY-MM-dd'));
        req.addParameter('end-date', endDate.formatGmt('YYYY-MM-dd'));
        
        req.httpMethod = 'POST';
        
        RestContext.request = req;
        RestContext.response = res;
        
        SNG_REST_ServicePlanUsage servicePlanUsage = new SNG_REST_ServicePlanUsage(RestContext.request);
        SNG_REST_JsonResponse response = servicePlanUsage.get();
        
        SNG_REST_ServicePlanUsageOutput.MacAddressUsageData expectedMaud1 =
             new SNG_REST_ServicePlanUsageOutput.MacAddressUsageData(SNG_MockUsageServiceHttpCallout.SUNNY_DAY_MAC_ADDRESS_DOUBLE_A,
                                                                               SNG_MockUsageServiceHttpCallout.DOUBLE_A_BSID_UPLOAD,
                                                                               SNG_MockUsageServiceHttpCallout.DOUBLE_A_BSID_DOWNLOAD);
       
        SNG_REST_ServicePlanUsageOutput.MacAddressUsageData expectedMaud2 =
             new SNG_REST_ServicePlanUsageOutput.MacAddressUsageData(SNG_MockUsageServiceHttpCallout.SUNNY_DAY_MAC_ADDRESS_DOUBLE_B,
                                                                               SNG_MockUsageServiceHttpCallout.DOUBLE_B_BSID_UPLOAD,
                                                                               SNG_MockUsageServiceHttpCallout.DOUBLE_B_BSID_DOWNLOAD);
       
        List<SNG_REST_ServicePlanUsageOutput.MacAddressUsageData> expectedMauds = new List<SNG_REST_ServicePlanUsageOutput.MacAddressUsageData>();
        expectedMauds.add(expectedMaud1);
        expectedMauds.add(expectedMaud2);
        
        SNG_REST_ServicePlanUsageOutput expectedUsageOutput = new SNG_REST_ServicePlanUsageOutput(servicePlanId, expectedMauds);
       
          
        SNG_REST_JsonResponse expectedOutput = new SNG_REST_JsonResponse(SNGHttpUtilities.Status.OK, 
                                                                         SNG_REST_Error.SubCode.SALESFORCE_GENERATED_ERROR, 
                                                                         null, expectedUsageOutput);
        System.assertEquals(expectedOutput, response);
        
        Test.stopTest();
    }
    
    static testMethod void testWebServiceOkWithErrors() 
    {
        SNG_MockCustomSettings.initialize();
        
        //create servicePlan
        Account account = SNG_TestUtilities.insertAccount('Red Cross');
        ServicePlan__c servicePlan = SNG_TestUtilities.insertServicePlan(account, true);
        Modem__c modem = SNG_TestUtilities.insertEquipment('Terminal1', 
                                                           SNG_MockUsageServiceHttpCallout.OK_WITH_ERRORS_MAC_ADDRESS,
                                                           account,
                                                           true);
                                                           
        ModemServicePlan__c msp = SNG_TestUtilities.insertModemServicePlan(modem, servicePlan);
        
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new SNG_MockUsageServiceHttpCallout());
        
        DateTime startDate = SNG_DateUtils.todayGmt().toStartOfMonth();
        DateTime endDate = SNG_DateUtils.todayGmt().addMonths(1).addDays(-1);
    
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        
        ServicePlan__c servicePlanObj = [SELECT Name From ServicePlan__c WHERE Id = :servicePlan.Id];
        String servicePlanId = servicePlanObj.Name;
        
        req.requestURI = '/service-plan/' + servicePlanId + '/usage';
        req.resourcePath = '/service-plan/*/usage';
        req.addParameter('start-date', startDate.formatGmt('YYYY-MM-dd'));
        req.addParameter('end-date', endDate.formatGmt('YYYY-MM-dd'));
        
        req.httpMethod = 'POST';
        
        RestContext.request = req;
        RestContext.response = res;
        
        SNG_REST_ServicePlanUsage servicePlanUsage = new SNG_REST_ServicePlanUsage(RestContext.request);
        SNG_REST_JsonResponse response = servicePlanUsage.get();
        
        SNG_REST_ServicePlanUsageOutput.MacAddressUsageData expectedMaud =
             new SNG_REST_ServicePlanUsageOutput.MacAddressUsageData(SNG_MockUsageServiceHttpCallout.OK_WITH_ERRORS_MAC_ADDRESS,
                                                                     SNG_MockUsageServiceHttpCallout.OK_WITH_ERRORS_BSID_UPLOAD,
                                                                     SNG_MockUsageServiceHttpCallout.OK_WITH_ERRORS_BSID_DOWNLOAD);
       
        List<SNG_REST_ServicePlanUsageOutput.MacAddressUsageData> expectedMauds = new List<SNG_REST_ServicePlanUsageOutput.MacAddressUsageData>();
        expectedMauds.add(expectedMaud);
        
        SNG_REST_ServicePlanUsageOutput expectedUsageOutput = new SNG_REST_ServicePlanUsageOutput(servicePlanId, expectedMauds);
       
          
        SNG_REST_JsonResponse expectedOutput = new SNG_REST_JsonResponse(SNGHttpUtilities.Status.OK_WITH_ERRORS, 
                                                                         SNG_REST_Error.SubCode.WEBSERVICE_GENERATED_ERROR, 
                                                                         SNG_REST_ServicePlanUsage.USAGE_PARTIAL_ERROR, 
                                                                         expectedUsageOutput);
        System.assertEquals(expectedOutput, response);
        
        Test.stopTest();
    }
        
    //**********************************************************
    // TEST SNG_REST_StatusDetail (SNG_REST_StatusDetailUnitTest)
    //**********************************************************
    static testMethod void testCtor2Items()
    {
        SNGHttpUtilities.Status expectedStatus = SNGHttpUtilities.Status.ZERO_RESULTS;
        SNG_REST_Error.SubCode expectedSubCode = SNG_REST_Error.SubCode.WEBSERVICE_GENERATED_ERROR;
        String expectedMessage = null;
        
        SNG_REST_StatusDetail sd = new SNG_REST_StatusDetail(expectedStatus, expectedSubCode);
        System.assertEquals(expectedStatus, sd.status);
        System.assertEquals(expectedSubCode, sd.code);
        System.assertEquals(expectedMessage, sd.message);

        expectedStatus = SNGHttpUtilities.Status.OK;
        expectedSubCode = SNG_REST_Error.SubCode.SALESFORCE_GENERATED_ERROR;
        expectedMessage = null;
        
        sd = new SNG_REST_StatusDetail(expectedStatus, expectedSubCode);
        System.assertEquals(expectedStatus, sd.status);
        System.assertEquals(expectedSubCode, sd.code);
        System.assertEquals(expectedMessage, sd.message);
    } 
    
    static testMethod void testCtor3Items()
    {
        SNGHttpUtilities.Status expectedStatus = SNGHttpUtilities.Status.OK_WITH_ERRORS;
        SNG_REST_Error.SubCode expectedSubCode = SNG_REST_Error.SubCode.WEBSERVICE_GENERATED_ERROR;
        String expectedMessage = 'TestMessage1';
        
        SNG_REST_StatusDetail sd = new SNG_REST_StatusDetail(expectedStatus, expectedSubCode, expectedMessage);
        System.assertEquals(expectedStatus, sd.status);
        System.assertEquals(expectedSubCode, sd.code);
        System.assertEquals(expectedMessage, sd.message);

        expectedStatus = SNGHttpUtilities.Status.INPUT_VALIDATION_ERROR;
        expectedSubCode = SNG_REST_Error.SubCode.SALESFORCE_GENERATED_ERROR;
        expectedMessage = 'Test message 2';
        
        sd = new SNG_REST_StatusDetail(expectedStatus, expectedSubCode, expectedMessage);
        System.assertEquals(expectedStatus, sd.status);
        System.assertEquals(expectedSubCode, sd.code);
        System.assertEquals(expectedMessage, sd.message);
    }    
    
    //**********************************************************
    // TEST SNG_REST_ServicePlansInfo
    //**********************************************************
    static testMethod void getConstructResultListTest(){
        SNG_MockCustomSettings.initialize();

        final Integer NUM_SERVICE_PLANS = 2;
        SNG_REST_ServicePlansInfo spi = new SNG_REST_ServicePlansInfo();

        List<ModemServicePlan__c> msps =
                SNG_TestUtilities.insertListOfModemServicePlans(NUM_SERVICE_PLANS, 'testAccount');

        List<ServicePlan__c> servicePlans = [SELECT Id, Name, Status__c, StartDate__c, EndDate__c, SalesOrder__c,
                        ServicePlanType__r.Name FROM ServicePlan__c];


        //Build the expected Response
        SNG_REST_ServicePlansInfo.ServicePlanInfoMspOutput spInfoMspOutput0 = new SNG_REST_ServicePlansInfo.ServicePlanInfoMspOutput(
                        msps[0].Modem__r.Name, msps[0].Modem__r.SerialNumber__c, msps[0].Status__c,
                        msps[0].StartDate__c, msps[0].EndDate__c, msps[0].Modem__r.Terminal__r.Name);
        SNG_REST_ServicePlansInfo.ServicePlanInfoMspOutput spInfoMspOutput1 = new SNG_REST_ServicePlansInfo.ServicePlanInfoMspOutput(
                msps[1].Modem__r.Name, msps[1].Modem__r.SerialNumber__c, msps[1].Status__c,
                msps[1].StartDate__c, msps[1].EndDate__c, msps[1].Modem__r.Terminal__r.Name);


        SNG_REST_ServicePlansInfo.ServicePlanInfoOutput spInfoOutput0 = new SNG_REST_ServicePlansInfo.ServicePlanInfoOutput(
                servicePlans[0].Name,servicePlans[0].Status__c,servicePlans[0].StartDate__c,servicePlans[0].EndDate__c,
                servicePlans[0].SalesOrder__c, servicePlans[0].ServicePlanType__r.Name,
                new List<SNG_REST_ServicePlansInfo.ServicePlanInfoMspOutput> {spInfoMspOutput0});
        SNG_REST_ServicePlansInfo.ServicePlanInfoOutput spInfoOutput1 = new SNG_REST_ServicePlansInfo.ServicePlanInfoOutput(
                servicePlans[1].Name,servicePlans[1].Status__c,servicePlans[1].StartDate__c,servicePlans[1].EndDate__c,
                servicePlans[1].SalesOrder__c, servicePlans[1].ServicePlanType__r.Name,
                new List<SNG_REST_ServicePlansInfo.ServicePlanInfoMspOutput> {spInfoMspOutput1});

        List<SNG_REST_ServicePlansInfo.ServicePlanInfoOutput> expectedSpInfoOutputs =
                new List<SNG_REST_ServicePlansInfo.ServicePlanInfoOutput>{spInfoOutput0, spInfoOutput1};

        //Get actual response
        SNG_REST_StatusDetail detail = new SNG_REST_StatusDetail(SNGHttpUtilities.Status.OK, null,  null);
        SNG_REST_Response response = spi.constructResultList(detail, null, servicePlans);
        SNG_REST_CollectionOutput collectionOutput = (SNG_REST_CollectionOutput)response.data;
        List<SNG_REST_ServicePlansInfo.ServicePlanInfoOutput> spInfoOutputs = (List<SNG_REST_ServicePlansInfo.ServicePlanInfoOutput>)collectionOutput.items;

        System.assertEquals(spi, spi);
    }

    static testMethod void getServicePlansInfoSuccessTest() {
        SNG_MockCustomSettings.initialize();

        final Integer NUM_SERVICE_PLANS = 3;
        List<ModemServicePlan__c> msps = SNG_TestUtilities.insertListOfModemServicePlans(NUM_SERVICE_PLANS, 'testAccount');

        // Although service plans is returned from the insertion above, not all relevant
        // fields are returned (in particular the Name field). Therefore, an additional query must be made
        SNG_REST_ServicePlansInfo spi = new SNG_REST_ServicePlansInfo();
        List<ServicePlan__c> servicePlans = spi.getSObjects();

        String[] ids = getIdNames(servicePlans);

        //Build the expected Response
        SNG_REST_StatusDetail detail = new SNG_REST_StatusDetail(SNGHttpUtilities.Status.OK, null,  null);
        SNG_REST_Response response = spi.constructResultList(detail, null, servicePlans);
        SNG_REST_CollectionOutput collectionOutput = (SNG_REST_CollectionOutput)response.data;
        List<SNG_REST_ServicePlansInfo.ServicePlanInfoOutput> expectedSpInfoOutputs =
                (List<SNG_REST_ServicePlansInfo.ServicePlanInfoOutput>) collectionOutput.items;

        SNG_REST_JsonResponse expectedResponse = new SNG_REST_JsonResponse(
                SNGHttpUtilities.Status.OK,
                SNG_REST_Error.SubCode.SALESFORCE_GENERATED_ERROR,
                null,
                new SNG_REST_CollectionOutput(expectedSpInfoOutputs));

        executeServicePlansInfoTest(ids, expectedResponse);
    }

    static testMethod void getServicePlansInfoOkWithErrors() {
        SNG_MockCustomSettings.initialize();

        final Integer NUM_SERVICE_PLANS = 3;
        List<ModemServicePlan__c> msps = SNG_TestUtilities.insertListOfModemServicePlans(NUM_SERVICE_PLANS, 'testAccount');

        // Although service plans is returned from the insertion above, not all relevant
        // fields are returned (in particular the Name field). Therefore, an additional query must be made
        SNG_REST_ServicePlansInfo spi = new SNG_REST_ServicePlansInfo();
        List<ServicePlan__c> servicePlans = spi.getSObjects();

        String[] ids = getIdNames(servicePlans);
        ids.add('SP-9999');

        //Build the expected Response
        SNG_REST_StatusDetail detail = new SNG_REST_StatusDetail(SNGHttpUtilities.Status.OK_WITH_ERRORS, 
                                                                 SNG_REST_Error.SubCode.SALESFORCE_GENERATED_ERROR,
                                                                 SNG_REST_Error.IDS_INVALID);
        SNG_REST_Response response = spi.constructResultList(detail, null, servicePlans);
        SNG_REST_CollectionOutput collectionOutput = (SNG_REST_CollectionOutput)response.data;
        List<SNG_REST_ServicePlansInfo.ServicePlanInfoOutput> expectedSpInfoOutputs =
                (List<SNG_REST_ServicePlansInfo.ServicePlanInfoOutput>) collectionOutput.items;
                
        SNG_REST_JsonResponse expectedResponse =
                new SNG_REST_JsonResponse(
                        SNGHttpUtilities.Status.OK_WITH_ERRORS,
                        SNG_REST_Error.SubCode.SALESFORCE_GENERATED_ERROR,
                        SNG_REST_Error.IDS_INVALID, // Constants don't appear to be inherited by child classes regardless of scope
                        new SNG_REST_CollectionOutput(expectedSpInfoOutputs));

        executeServicePlansInfoTest(ids, expectedResponse);
    }

    static testMethod void getServicePlansInfoInvalidId() {
        final Integer NUM_SERVICE_PLANS = 3;
        String[] ids = new List<String>{'bogus'};

        //Build the expected Response
        SNG_REST_JsonResponse expectedResponse =
                new SNG_REST_JsonResponse(
                        SNGHttpUtilities.Status.INPUT_VALIDATION_ERROR,
                        SNG_REST_Error.SubCode.SALESFORCE_GENERATED_ERROR,
                        SNG_REST_Error.INPUT_INVALID_FORMAT,
                        null);

        executeServicePlansInfoTest(ids, expectedResponse);
    }

    static testMethod void getServicePlansInfoZeroResults() {
        String[] ids = new List<String>{'SP-0001','SP-0002'};

        SNG_REST_JsonResponse expectedResponse =
            new SNG_REST_JsonResponse(
                    SNGHttpUtilities.Status.ZERO_RESULTS,
                    SNG_REST_Error.SubCode.SALESFORCE_GENERATED_ERROR,
                    SNG_REST_Error.IDS_INVALID,
                    null);

        executeServicePlansInfoTest(ids, expectedResponse);
    }
   
   
    static testMethod void testGetMsps()
    {
        SNG_MockCustomSettings.initialize();

        Account newAccount = SNG_TestUtilities.insertAccount('Red Cross');
        Terminal__c terminal = SNG_TestUtilities.insertTerminal(newAccount, 'SerialNumber', '1234561');
        Modem__c modem = SNG_TestUtilities.insertModem(newAccount, '', '00:a0:bc:11:11:11', '', terminal);
        
        ServicePlan__c servicePlan = SNG_TestUtilities.insertServicePlan(newAccount, true);
        servicePlan.StartDate__c = Date.newInstance(2014, 4, 1);
        servicePlan.EndDate__c = Date.newInstance(2014, 4, 30);
        update servicePlan;
        
        List<ModemServicePlan__c> msps = SNG_Terminal.getMspForTerminal(terminal, servicePlan.StartDate__c, servicePlan.EndDate__c);
        System.assertEquals(0, msps.size());   
        
        
        ModemServicePlan__c msp = new ModemServicePlan__c();
        msp.Modem__c = modem.Id;
        msp.Modem__r = modem;
        msp.ServicePlan__c = servicePlan.Id;
        msp.ServicePlan__r = servicePlan;
        msp.StartDate__c = Date.newInstance(2014, 4, 1);
        msp.EndDate__c = Date.newInstance(2014, 4, 5);
        insert msp;
        
        ModemServicePlan__c msp1 = new ModemServicePlan__c();
        msp1.Modem__c = modem.Id;
        msp1.Modem__r = modem;
        msp1.ServicePlan__c = servicePlan.Id;
        msp1.ServicePlan__r = servicePlan;
        msp1.StartDate__c = Date.newInstance(2014, 4, 10);
        msp1.EndDate__c = Date.newInstance(2014, 4, 13);
        insert msp1;

        msps = SNG_REST_ServicePlansInfo.getMsps(servicePlan.Id);
        System.assertEquals(2, msps.size());   
        
        //verify contents
        ModemServicePlan__c extractedMsp1 = msps.get(0);
        System.assertEquals(msp.StartDate__c, extractedMsp1.StartDate__c);
        System.assertEquals(msp.EndDate__c, extractedMsp1.EndDate__c);
        System.assertEquals(msp.Id, extractedMsp1.Id);
        
        ModemServicePlan__c extractedMsp2 = msps.get(1);
        System.assertEquals(msp1.StartDate__c, extractedMsp2.StartDate__c);
        System.assertEquals(msp1.EndDate__c, extractedMsp2.EndDate__c);
        System.assertEquals(msp1.Id, extractedMsp2.Id);
    }
    
    static testMethod void testServicePlanInfoMspOutput_HashCode()
    {
        String macAddress = '00:a0:bc:11:22:33';
        String serialNumber = 'SerialNumber';
        String status = 'OK';
        Date startDate = Date.newInstance(2014, 2, 14);
        Date endDate = Date.newInstance(2014, 2, 21);
        String terminalId = 'T-1234';
        
        String macAddressDiff = '00:a0:bc:11:22:34';
        
        SNG_REST_ServicePlansInfo.ServicePlanInfoMspOutput spimo = 
           new SNG_REST_ServicePlansInfo.ServicePlanInfoMspOutput(macAddress, serialNumber, status, startDate, endDate, terminalId);
        
        SNG_REST_ServicePlansInfo.ServicePlanInfoMspOutput spimo1 = 
           new SNG_REST_ServicePlansInfo.ServicePlanInfoMspOutput(macAddress, serialNumber, status, startDate, endDate, terminalId);
       
        SNG_REST_ServicePlansInfo.ServicePlanInfoMspOutput spimo2 = 
           new SNG_REST_ServicePlansInfo.ServicePlanInfoMspOutput(macAddressDiff, serialNumber, status, startDate, endDate, terminalId);
         
        System.assertEquals(spimo.hashCode(), spimo1.hashCode());
        System.assertNotEquals(spimo.hashCode(), spimo2.hashCode());
        
    }
    
    static testMethod void testServicePlanInfoMspOutput_Equals()
    {
        String macAddress = '00:a0:bc:11:22:33';
        String serialNumber = 'SerialNumber';
        String status = 'OK';
        Date startDate = Date.newInstance(2014, 2, 14);
        Date endDate = Date.newInstance(2014, 2, 21);
        String terminalId = 'T-1234';
        
        String macAddressDiff = '00:a0:bc:11:22:34';
        
        SNG_REST_ServicePlansInfo.ServicePlanInfoMspOutput spimo = 
           new SNG_REST_ServicePlansInfo.ServicePlanInfoMspOutput(macAddress, serialNumber, status, startDate, endDate, terminalId);
        
        SNG_REST_ServicePlansInfo.ServicePlanInfoMspOutput spimo1 = 
           new SNG_REST_ServicePlansInfo.ServicePlanInfoMspOutput(macAddress, serialNumber, status, startDate, endDate, terminalId);
       
        SNG_REST_ServicePlansInfo.ServicePlanInfoMspOutput spimo2 = 
           new SNG_REST_ServicePlansInfo.ServicePlanInfoMspOutput(macAddressDiff, serialNumber, status, startDate, endDate, terminalId);
         
        System.assertEquals(true, spimo.equals(spimo)); //equals itself
        System.assertEquals(false, spimo.equals(null)); //does not equal null
        System.assertEquals(false, spimo.equals(new Terminal__c())); //does not equal terminal object
        
        System.assertEquals(true, spimo.equals(spimo1));
        System.assertEquals(false, spimo.equals(spimo2));
    }   
    
    static testMethod void testServicePlanInfoOutput_CtorInvalid()
    {
        
        String servicePlanId = 'SP-1234';
        String status = 'Active';  //valid status
        Date startDate = Date.newInstance(2014, 2, 14);
        Date endDate = Date.newInstance(2014, 2, 21);
        String salesOrder = 'SO-1234';
        String servicePlanType = 'ServicePlan';
        
        String invalidServicePlanId = 'SP-asdfaf'; //invalid format
        
        try
        {
           SNG_REST_ServicePlansInfo.ServicePlanInfoOutput spInfo = 
               new SNG_REST_ServicePlansInfo.ServicePlanInfoOutput(invalidServicePlanId, status, startDate, endDate, salesOrder, servicePlanType, null);
           System.assert(false);
        }
        catch (SNG_REST_JsonResponseOutput.ValidationException e)
        {
            System.assert(true);
        }
        catch (Exception e)
        {
            System.assert(false);
        }
        
        String invalidStatus = 'invalidStatus';
        
        try
        {
           SNG_REST_ServicePlansInfo.ServicePlanInfoOutput spInfo = 
               new SNG_REST_ServicePlansInfo.ServicePlanInfoOutput(servicePlanId, invalidStatus, startDate, endDate, salesOrder, servicePlanType, null);
           System.assert(false);
        }
        catch (SNG_REST_JsonResponseOutput.ValidationException e)
        {
            System.assert(true);
        }
        catch (Exception e)
        {
            System.assert(false);
        }
    }
    
    static testMethod void testServicePlanInfoOutput_CtorValid()
    {
        
        String servicePlanId = 'SP-1234';
        String status = 'Active';  //valid status
        Date startDate = Date.newInstance(2014, 2, 14);
        Date endDate = Date.newInstance(2014, 2, 21);
        String salesOrder = 'SO-1234';
        String servicePlanType = 'ServicePlan';
        
        try
        {
           SNG_REST_ServicePlansInfo.ServicePlanInfoOutput spInfo = 
               new SNG_REST_ServicePlansInfo.ServicePlanInfoOutput(servicePlanId, status, startDate, endDate, salesOrder, servicePlanType, null);
           
           spInfo = 
               new SNG_REST_ServicePlansInfo.ServicePlanInfoOutput(servicePlanId, status, startDate, endDate, salesOrder, 
                                                                   servicePlanType, new List<SNG_REST_ServicePlansInfo.ServicePlanInfoMspOutput>());    
           
           System.assert(true);
        }
        catch (Exception e)
        {
            System.assert(false);
        }
        
    }   
    
    static testMethod void testServicePlanInfoOutput_HashCode()
    {
        
        String macAddress = '00:a0:bc:11:22:33';
        String serialNumber = 'SerialNumber';
        String spStatus = 'OK';
        Date startDate = Date.newInstance(2014, 2, 14);
        Date endDate = Date.newInstance(2014, 2, 21);
        String terminalId = 'T-1234';
        
        String macAddressDiff = '00:a0:bc:11:22:34';
        
        SNG_REST_ServicePlansInfo.ServicePlanInfoMspOutput spimo = 
           new SNG_REST_ServicePlansInfo.ServicePlanInfoMspOutput(macAddress, serialNumber, spStatus, startDate, endDate, terminalId);
        
        SNG_REST_ServicePlansInfo.ServicePlanInfoMspOutput spimo1 = 
           new SNG_REST_ServicePlansInfo.ServicePlanInfoMspOutput(macAddress, serialNumber, spStatus, startDate, endDate, terminalId);
       
        SNG_REST_ServicePlansInfo.ServicePlanInfoMspOutput spimo2 = 
           new SNG_REST_ServicePlansInfo.ServicePlanInfoMspOutput(macAddressDiff, serialNumber, spStatus, startDate, endDate, terminalId);
        
        SNG_REST_ServicePlansInfo.ServicePlanInfoMspOutput spimoCopy = 
           new SNG_REST_ServicePlansInfo.ServicePlanInfoMspOutput(macAddress, serialNumber, spStatus, startDate, endDate, terminalId);
        
        SNG_REST_ServicePlansInfo.ServicePlanInfoMspOutput spimo1Copy = 
           new SNG_REST_ServicePlansInfo.ServicePlanInfoMspOutput(macAddress, serialNumber, spStatus, startDate, endDate, terminalId);
       
        SNG_REST_ServicePlansInfo.ServicePlanInfoMspOutput spimo2Copy = 
           new SNG_REST_ServicePlansInfo.ServicePlanInfoMspOutput(macAddressDiff, serialNumber, spStatus, startDate, endDate, terminalId);
        
        List<SNG_REST_ServicePlansInfo.ServicePlanInfoMspOutput> spimos = new List<SNG_REST_ServicePlansInfo.ServicePlanInfoMspOutput>{spimo, spimo1, spimo2};
        List<SNG_REST_ServicePlansInfo.ServicePlanInfoMspOutput> spimos1 = new List<SNG_REST_ServicePlansInfo.ServicePlanInfoMspOutput>{spimoCopy, spimo1Copy, spimo2Copy};
        List<SNG_REST_ServicePlansInfo.ServicePlanInfoMspOutput> spimos2 = new List<SNG_REST_ServicePlansInfo.ServicePlanInfoMspOutput>{spimo};
        
        String servicePlanId = 'SP-1234';
        String status = 'Active';  //valid status
        String salesOrder = 'SO-1234';
        String servicePlanType = 'ServicePlan';
        

        SNG_REST_ServicePlansInfo.ServicePlanInfoOutput spInfo = 
               new SNG_REST_ServicePlansInfo.ServicePlanInfoOutput(servicePlanId, status, startDate, endDate, salesOrder, servicePlanType, spimos);
           
        SNG_REST_ServicePlansInfo.ServicePlanInfoOutput spInfo1 = 
               new SNG_REST_ServicePlansInfo.ServicePlanInfoOutput(servicePlanId, status, startDate, endDate, salesOrder, servicePlanType, spimos1);
        
        SNG_REST_ServicePlansInfo.ServicePlanInfoOutput spInfo2 = 
               new SNG_REST_ServicePlansInfo.ServicePlanInfoOutput(servicePlanId, status, startDate, endDate, salesOrder, servicePlanType, spimos2);
               
        System.assertEquals(spInfo.hashCode(), spInfo1.hashCode());
        System.assertNotEquals(spInfo.hashCode(), spInfo2.hashCode());         

        SNG_REST_ServicePlansInfo.ServicePlanInfoOutput spInfo3 = 
               new SNG_REST_ServicePlansInfo.ServicePlanInfoOutput(servicePlanId, status, startDate, endDate, salesOrder, servicePlanType, null);
           
        SNG_REST_ServicePlansInfo.ServicePlanInfoOutput spInfo4 = 
               new SNG_REST_ServicePlansInfo.ServicePlanInfoOutput(servicePlanId, status, startDate, endDate, salesOrder, servicePlanType, null);
               
        System.assertEquals(spInfo3.hashCode(), spInfo4.hashCode());
        
    }  
    
        
    static testMethod void testServicePlanInfoOutput_Equals()
    {
        
        String macAddress = '00:a0:bc:11:22:33';
        String serialNumber = 'SerialNumber';
        String spStatus = 'OK';
        Date startDate = Date.newInstance(2014, 2, 14);
        Date endDate = Date.newInstance(2014, 2, 21);
        String terminalId = 'T-1234';
        
        String macAddressDiff = '00:a0:bc:11:22:34';
        
        SNG_REST_ServicePlansInfo.ServicePlanInfoMspOutput spimo = 
           new SNG_REST_ServicePlansInfo.ServicePlanInfoMspOutput(macAddress, serialNumber, spStatus, startDate, endDate, terminalId);
        
        SNG_REST_ServicePlansInfo.ServicePlanInfoMspOutput spimo1 = 
           new SNG_REST_ServicePlansInfo.ServicePlanInfoMspOutput(macAddress, serialNumber, spStatus, startDate, endDate, terminalId);
       
        SNG_REST_ServicePlansInfo.ServicePlanInfoMspOutput spimo2 = 
           new SNG_REST_ServicePlansInfo.ServicePlanInfoMspOutput(macAddressDiff, serialNumber, spStatus, startDate, endDate, terminalId);
        
        SNG_REST_ServicePlansInfo.ServicePlanInfoMspOutput spimoCopy = 
           new SNG_REST_ServicePlansInfo.ServicePlanInfoMspOutput(macAddress, serialNumber, spStatus, startDate, endDate, terminalId);
        
        SNG_REST_ServicePlansInfo.ServicePlanInfoMspOutput spimo1Copy = 
           new SNG_REST_ServicePlansInfo.ServicePlanInfoMspOutput(macAddress, serialNumber, spStatus, startDate, endDate, terminalId);
       
        SNG_REST_ServicePlansInfo.ServicePlanInfoMspOutput spimo2Copy = 
           new SNG_REST_ServicePlansInfo.ServicePlanInfoMspOutput(macAddressDiff, serialNumber, spStatus, startDate, endDate, terminalId);
        
        List<SNG_REST_ServicePlansInfo.ServicePlanInfoMspOutput> spimos = new List<SNG_REST_ServicePlansInfo.ServicePlanInfoMspOutput>{spimo, spimo1, spimo2};
        List<SNG_REST_ServicePlansInfo.ServicePlanInfoMspOutput> spimos1 = new List<SNG_REST_ServicePlansInfo.ServicePlanInfoMspOutput>{spimoCopy, spimo1Copy, spimo2Copy};
        List<SNG_REST_ServicePlansInfo.ServicePlanInfoMspOutput> spimos2 = new List<SNG_REST_ServicePlansInfo.ServicePlanInfoMspOutput>{spimo};
        
        String servicePlanId = 'SP-1234';
        String status = 'Active';  //valid status
        String salesOrder = 'SO-1234';
        String servicePlanType = 'ServicePlan';
        

        SNG_REST_ServicePlansInfo.ServicePlanInfoOutput spInfo = 
               new SNG_REST_ServicePlansInfo.ServicePlanInfoOutput(servicePlanId, status, startDate, endDate, salesOrder, servicePlanType, spimos);
           
        SNG_REST_ServicePlansInfo.ServicePlanInfoOutput spInfo1 = 
               new SNG_REST_ServicePlansInfo.ServicePlanInfoOutput(servicePlanId, status, startDate, endDate, salesOrder, servicePlanType, spimos1);
        
        SNG_REST_ServicePlansInfo.ServicePlanInfoOutput spInfo2 = 
               new SNG_REST_ServicePlansInfo.ServicePlanInfoOutput(servicePlanId, status, startDate, endDate, salesOrder, servicePlanType, spimos2);
               
        System.assertEquals(true, spInfo.equals(spInfo)); // equals itself  
        System.assertEquals(true, spInfo1.equals(spInfo1)); // equals itself  
        System.assertEquals(true, spInfo2.equals(spInfo2)); // equals itself       
        System.assertEquals(false, spInfo.equals(null)); // not equal to null
        System.assertEquals(false, spInfo.equals(new Terminal__c())); // not equal to diferent object.       
               
        System.assertEquals(true, spInfo.equals(spInfo1));
        System.assertEquals(false, spInfo.equals(spInfo2));
        System.assertEquals(false, spInfo1.equals(spInfo2));         
        System.assertEquals(false, spInfo2.equals(spInfo));
        System.assertEquals(false, spInfo2.equals(spInfo1));

        SNG_REST_ServicePlansInfo.ServicePlanInfoOutput spInfo3 = 
               new SNG_REST_ServicePlansInfo.ServicePlanInfoOutput(servicePlanId, status, startDate, endDate, salesOrder, servicePlanType, null);
           
        SNG_REST_ServicePlansInfo.ServicePlanInfoOutput spInfo4 = 
               new SNG_REST_ServicePlansInfo.ServicePlanInfoOutput(servicePlanId, status, startDate, endDate, salesOrder, servicePlanType, null);
               
        System.assertEquals(spInfo3.hashCode(), spInfo4.hashCode());
        
    }

    static testMethod void testServicePlanInfoMspOutputConstructor()
    {
        final String macAddress = '00:A0:BC:12:34:56';
        final String serialNumber = '1';
        final String status = 'Active';
        final Date startDate = SNG_DateUtils.todayGmt();
        final Date endDate = SNG_DateUtils.todayGmt().addDays(1);
        final String terminalId = 'T0001';

        SNG_REST_ServicePlansInfo.ServicePlanInfoMspOutput spInfoMspOutput 
            = new SNG_REST_ServicePlansInfo.ServicePlanInfoMspOutput(macAddress, serialNumber, status,
                                                                     startDate, endDate, terminalId);

        System.assertEquals(macAddress, spInfoMspOutput.macAddress);
        System.assertEquals(serialNumber, spInfoMspOutput.serialNumber);
        System.assertEquals(status, spInfoMspOutput.status);
        System.assertEquals(startDate, Date.valueOf(spInfoMspOutput.startDate));
        System.assertEquals(endDate, Date.valueOf(spInfoMspOutput.endDate));
        System.assertEquals(terminalId, spInfoMspOutput.terminalId);
    }  

    private static RestRequest setRequestURI(RestRequest req, String[] Ids) {
        String joinedIds = StringUtils.joinStrings(Ids, ',');

        req.requestURI = URL.getSalesforceBaseUrl().toExternalForm() + '/services/apexrest/' + SNG_REST_ServicePlansInfoApi.URI_PATH;
        req.addParameter(SNG_REST_Collection.IDS_PARAM, joinedIds);
        return req;
    }

    private static String[] getIdNames(ServicePlan__c[] servicePlans) {
        List<String> idNames = new List<String>();

        for (ServicePlan__c servicePlan : servicePlans) {
            idNames.add(servicePlan.Name);
        }

        return idNames;
    }


    private static RestRequest setInstanceRequestURI(RestRequest req, ServicePlan__c[] servicePlans) {
        String[] idNames = getIdNames(servicePlans);
        return setInstanceRequestURI(req, idNames);
    }

    private static RestRequest setInstanceRequestURI(RestRequest req, String[] Ids) {
        final String SINGULAR_URI_PATH = '/service-plan/' + Ids[0] + '/info';
        req.requestURI = SINGULAR_URI_PATH;
        return req;
    }

    private static RestRequest setInstanceResourcePath(RestRequest req) {
        final String SINGULAR_URI_PATH = '/service-plan/*/info';
        req.resourcePath = SINGULAR_URI_PATH;
        return req;
    }

    static List<ServicePlan__c> prepareServicePlansInfoTest(integer numServicePlans, SNG_REST_ServicePlansInfo spi) {
        List<ModemServicePlan__c> msps =
                SNG_TestUtilities.insertListOfModemServicePlans(numServicePlans, 'testAccount');

        for (ModemServicePlan__c msp : msps)
        {
            System.debug('msp: ' + msp);
        }

        /* Although service plans is returned from the insertion above, not all relevant
         * fields are returned (in particular the Name field). Therefore, an additional
         * query must be made
         */
        List<ServicePlan__c> servicePlans = spi.getSObjects();

//      Map<Id, List<ModemServicePlan__c>> spToMspsMap = SNGObjMapper.buildServicePlanToMspsMap(msps);

        for (ServicePlan__c sp : servicePlans)
        {
            System.debug('servicePlan: ' + sp);
        }

        return servicePlans;
    }

    static void executeServicePlansInfoTest(String[] idsToRequest, SNG_REST_JsonResponse expectedResponse) {
        // set the request URI
        RestRequest req = new RestRequest();

        req = setRequestURI(req, idsToRequest);

        // set the request method
        req.httpMethod = 'GET';

        // RestContext contains the RestRequest and RestResponse objects in REST methods
        RestContext.request = req;

        //Invoke the API
        Test.startTest();
        SNG_REST_JsonResponse jsonResponse = SNG_REST_ServicePlansInfoApi.getServicePlanInfo();
        Test.stopTest();

        System.assertEquals(expectedResponse, jsonResponse);
    }

    //**********************************************************
    // TEST SNG_REST_ModemUsage
    //**********************************************************    
    private static String START_DATE_PARAM = 'start-date'; 
    private static String END_DATE_PARAM = 'end-date'; 
    
    static testMethod void validateInputs_ValidInputs() {
        
        SNG_REST_StatusDetail detail = new SNG_REST_StatusDetail(SNGHttpUtilities.Status.OK, null);
        
        // Valid user inputs
        String macAddress = '00:a0:bc:00:11:11'; 
        String startDate = '2014-04-24';
        String endDate = '2014-04-26';

        // Add modem to Salesforce 
        Account account = SNG_TestUtilities.insertAccount('testAccount');
        Modem__c modem = SNG_TestUtilities.insertModem(macAddress, '111111', false);
        
        System.assert(new SNG_REST_ModemUsage(macAddress, startDate, endDate).validateInput(detail));
        System.assertEquals(SNGHttpUtilities.Status.OK, detail.status);
        System.assertEquals(null, detail.code);
        System.assertEquals(null, detail.message);
    }
    
    static testMethod void validateInputs_InvalidMacAddress() { 
        
        SNG_REST_StatusDetail detail = new SNG_REST_StatusDetail(SNGHttpUtilities.Status.OK, null);
        
        // Valid user inputs
        String macAddress = '00:a0:bc:00:6:'; 
        String startDate = '2014-04-24';
        String endDate = '2014-04-26';

        // Add modem to Salesforce 
        Account account = SNG_TestUtilities.insertAccount('testAccount');
        Modem__c modem = SNG_TestUtilities.insertModem('00:a0:bc:22:33:44', '111111', false);

        System.assert(! new SNG_REST_ModemUsage(macAddress, startDate, endDate).validateInput(detail));
        System.assertEquals(SNGHttpUtilities.Status.INPUT_VALIDATION_ERROR, detail.status);
        System.assertEquals(SNG_REST_Error.SubCode.SALESFORCE_GENERATED_ERROR, detail.code);
        System.assertEquals(SNG_ModemMacAddressChecker.INVALID_MAC_ADDRESS, detail.message);
    }
    
    static testMethod void validateInputs_InvalidDates() { 
        SNG_REST_StatusDetail detail = new SNG_REST_StatusDetail(SNGHttpUtilities.Status.OK, null);
        
        // Valid user inputs
        String macAddress = '00:a0:bc:22:33:44'; 
        String startDate = '2014-04-52';
        String endDate = '2014/04/26';

        // Add modem to Salesforce 
        Account account = SNG_TestUtilities.insertAccount('testAccount');
        Modem__c modem = SNG_TestUtilities.insertModem('00:a0:bc:22:33:44', '111111', false);  
        
        System.assert(! new SNG_REST_ModemUsage(macAddress, startDate, endDate).validateInput(detail));
        System.assertEquals(SNGHttpUtilities.Status.INPUT_VALIDATION_ERROR, detail.status);
        System.assertEquals(SNG_REST_Error.SubCode.SALESFORCE_GENERATED_ERROR, detail.code);
        System.assertEquals('Invalid Start and/or End dates Dates must be in YYYY-MM-DD format.', detail.message);

    }
    
    static testMethod void validateInputs_NoModem() { 
        SNG_REST_StatusDetail detail = new SNG_REST_StatusDetail(SNGHttpUtilities.Status.OK, null);
        
        // Valid user inputs
        String macAddress = '00:a0:bc:22:33:44'; 
        String startDate = '2014-04-24';
        String endDate = '2014-04-26';

        System.assert(! new SNG_REST_ModemUsage(macAddress, startDate, endDate).validateInput(detail));
        System.assertEquals(SNGHttpUtilities.Status.ZERO_RESULTS, detail.status);
        System.assertEquals(SNG_REST_Error.SubCode.SALESFORCE_GENERATED_ERROR, detail.code);
        System.assertEquals(SNG_REST_ModemUsage.MISSING_MODEM, detail.message);
    }
    
    static testMethod void getModemServicePlans() { 

        SNG_MockCustomSettings.initialize();

        // Add modem to Salesforce 
        Account account = SNG_TestUtilities.insertAccount('testAccount');
        Terminal__c terminal = SNG_TestUtilities.insertTerminal(account, '11111', '1234561');
        Modem__c modem = SNG_TestUtilities.insertModem(account, '11111', '00:a0:bc:22:33:44', '123', terminal);  
        
        // Create Service Plans 
        Product2 servicePlanType = SNG_TestUtilities.insertServicePlanType(true);
        ServicePlan__c servicePlan_1 = SNG_TestUtilities.insertServicePlan(account,servicePlanType, 
                                                                            Date.valueOf('2014-05-01'), Date.valueOf('2014-05-30'));
        
        ServicePlan__c servicePlan_2 = SNG_TestUtilities.insertServicePlan(account, servicePlanType, 
                                                                            Date.valueOf('2014-05-01'), Date.valueOf('2014-05-30'));
                                                                            
        // Create Modem Service Plans
        ModemServicePlan__c msp1_inRange = new ModemServicePlan__c(); 
        msp1_inRange.Modem__c = modem.Id;
        msp1_inRange.Modem__r = modem;
        msp1_inRange.ServicePlan__c = servicePlan_1.Id;
        msp1_inRange.ServicePlan__r = servicePlan_1;
        msp1_inRange.StartDate__c = Date.valueOf('2014-05-02');
        msp1_inRange.EndDate__c = Date.valueOf('2014-05-04');
        insert msp1_inRange;
        
        ModemServicePlan__c msp2_inRange = new ModemServicePlan__c();
        msp2_inRange.Modem__c = modem.Id;
        msp2_inRange.Modem__r = modem;
        msp2_inRange.ServicePlan__c = servicePlan_2.Id;
        msp2_inRange.ServicePlan__r = servicePlan_2;
        msp2_inRange.StartDate__c = Date.valueOf('2014-05-05');
        msp2_inRange.EndDate__c = Date.valueOf('2014-05-07');
        insert msp2_inRange;
        
        ModemServicePlan__c msp_outOfRange = new ModemServicePlan__c();
        msp_outOfRange.Modem__c = modem.Id;
        msp_outOfRange.Modem__r = modem;
        msp_outOfRange.ServicePlan__c = servicePlan_2.Id;
        msp_outOfRange.ServicePlan__r = servicePlan_2;
        msp_outOfRange.StartDate__c = Date.valueOf('2014-05-20');
        msp_outOfRange.EndDate__c = Date.valueOf('2014-05-25');
        insert msp_outOfRange; 
        
        List<ModemServicePlan__c> mspsInRange = SNG_REST_ModemUsage.getModemServicePlans('00:a0:bc:22:33:44', '2014-05-01', '2014-05-15');
        System.assertEquals(2, mspsInRange.size());      
        
        mspsInRange = SNG_REST_ModemUsage.getModemServicePlans('00:a0:bc:22:33:44', '2014-05-01', '2014-05-24');
        System.assertEquals(3, mspsInRange.size()); 
        
        mspsInRange = SNG_REST_ModemUsage.getModemServicePlans('00:a0:bc:22:33:44', '2014-05-05', '2014-05-08');
        System.assertEquals(1, mspsInRange.size());
        
        mspsInRange = SNG_REST_ModemUsage.getModemServicePlans('00:a0:bc:22:33:43', '2014-05-09', '2014-05-10');
        System.assertEquals(null, mspsInRange);  
    }

    public static testMethod void buildRequestBody() {
        
        String macAddress = '00:a0:bc:22:33:44';
        
        SNG_MockCustomSettings.initialize();

        // Add modem to Salesforce 
        Account account = SNG_TestUtilities.insertAccount('testAccount');
        Terminal__c terminal = SNG_TestUtilities.insertTerminal(account, '11111', '1234561');
        Modem__c modem = SNG_TestUtilities.insertModem(account, '11111', macAddress, '123', terminal);  
        
        // Create Service Plans 
        Product2 servicePlanType = SNG_TestUtilities.insertServicePlanType(true);
        ServicePlan__c servicePlan_1 = SNG_TestUtilities.insertServicePlan(account, servicePlanType, 
                                                                            Date.valueOf('2014-04-01'), Date.valueOf('2014-05-30'));
        
        ServicePlan__c servicePlan_2 = SNG_TestUtilities.insertServicePlan(account, servicePlanType, 
                                                                            Date.valueOf('2014-04-01'), Date.valueOf('2014-05-30'));
        
        // Create Modem Service Plans
        ModemServicePlan__c msp1_inRange = new ModemServicePlan__c(); 
        msp1_inRange.Modem__c = modem.Id;
        msp1_inRange.Modem__r = modem;
        msp1_inRange.ServicePlan__c = servicePlan_1.Id;
        msp1_inRange.ServicePlan__r = servicePlan_1;
        msp1_inRange.StartDate__c = Date.valueOf('2014-04-30');
        msp1_inRange.EndDate__c = Date.valueOf('2014-05-04');
        insert msp1_inRange;
        
        ModemServicePlan__c msp2_inRange = new ModemServicePlan__c();
        msp2_inRange.Modem__c = modem.Id;
        msp2_inRange.Modem__r = modem;
        msp2_inRange.ServicePlan__c = servicePlan_2.Id;
        msp2_inRange.ServicePlan__r = servicePlan_2;
        msp2_inRange.StartDate__c = Date.valueOf('2014-05-05');
        msp2_inRange.EndDate__c = Date.valueOf('2014-05-07');
        insert msp2_inRange;
        
        ModemServicePlan__c msp3_inRange = new ModemServicePlan__c();
        msp3_inRange.Modem__c = modem.Id;
        msp3_inRange.Modem__r = modem;
        msp3_inRange.ServicePlan__c = servicePlan_2.Id;
        msp3_inRange.ServicePlan__r = servicePlan_2;
        msp3_inRange.StartDate__c = Date.valueOf('2014-05-14');
        msp3_inRange.EndDate__c = Date.valueOf('2014-05-20');
        insert msp3_inRange;
        
        List<ModemServicePlan__c> activeMsps = SNG_REST_ModemUsage.getModemServicePlans(macAddress, '2014-05-01', '2014-05-15');
        
        
        List<SNG_REST_ModemUsage.ServicePlanInfo> servicePlans = new List<SNG_REST_ModemUsage.ServicePlanInfo>();   
        List<SNG_ModemUsageDate> requestBody = SNG_REST_ModemUsage.buildRequestBody(servicePlans, activeMsps, 
                                                                                    macAddress,
                                                                                    '2014-05-01', '2014-05-15');
        
        // Build expected ModemUsageDate
        List<SNG_ModemUsageDate> expectedRequestBody = new List<SNG_ModemUsageDate>();
        SNG_ModemUsageDate modemUsageDate_1 = new SNG_ModemUsageDate(macAddress, 
                                                                    Date.valueOf('2014-05-01'),
                                                                    Date.valueOf('2014-05-04'));
        SNG_ModemUsageDate modemUsageDate_2 = new SNG_ModemUsageDate(macAddress,
                                                                    Date.valueOf('2014-05-05'), 
                                                                    Date.valueOf('2014-05-07')); 
        SNG_ModemUsageDate modemUsageDate_3 = new SNG_ModemUsageDate(macAddress,
                                                                    Date.valueOf('2014-05-14'), 
                                                                    Date.valueOf('2014-05-15'));
        expectedRequestBody.add(modemUsageDate_1);
        expectedRequestBody.add(modemUsageDate_2);
        expectedRequestBody.add(modemUsageDate_3);
        
        // Check requestBody has 3 objects 
        System.assertEquals(3, requestBody.size());
        
        Integer counter = 0;
        
        // Check that the requestBody contains the 3 SNG_ModemUsageDate objects, no duplicates
        for(SNG_ModemUsageDate actualObject : requestBody) 
        {   
            // Compare each requestBody to the expectedRequestBody
            for(Integer i = 0; i < expectedRequestBody.size(); i++)
            { 
                // If there is a match, increment counter and remove the object from the check
                if (actualObject.equals(expectedRequestBody.get(i)))
                { 
                    counter++;
                    expectedRequestBody.remove(i);
                    break;
                }
            }
        }
        
        // There should be only be 3 matches
        System.assertEquals(3, counter);  
        
        // Check the mapping of SNG_ModemUsageDate objects to Service Plan Name
        String servicePlan_1_Name = [SELECT Name FROM ServicePlan__c WHERE Id = :servicePlan_1.Id].Name;
        String servicePlan_2_Name = [SELECT Name FROM ServicePlan__c WHERE Id = :servicePlan_2.Id].Name;
        System.assertEquals(servicePlan_1_Name,  servicePlans.get(0).id);
        System.assertEquals(servicePlan_2_Name,  servicePlans.get(1).id);
        System.assertEquals(servicePlan_2_Name,  servicePlans.get(2).id);  
    }
    
    static testMethod void testHandler_InvalidMacAddress() {
        
        // Client input
        String invalidMacAddress = 'Invalid:MAC:Address';
        String validStartDate = '2014-04-01';
        String validEndDate = '2014-05-01';
        
        String requestURI = '/modem/' + invalidMacAddress + '/usage';
        
        RestRequest req = new RestRequest();
        req.requestURI = requestURI;
        req.resourcePath = '/modem/*/usage';
        req.addParameter(START_DATE_PARAM, validStartDate);
        req.addParameter(END_DATE_PARAM, validEndDate);

        SNG_REST_JsonResponse response = new SNG_REST_ModemUsage(req).get();
        
        compareResponses(response, SNGHttpUtilities.Status.INPUT_VALIDATION_ERROR, SNG_REST_Error.SubCode.SALESFORCE_GENERATED_ERROR, 
                            SNG_ModemMacAddressChecker.INVALID_MAC_ADDRESS, null);
    }
    
    
    static testMethod void testHandler_InvalidDateFormat() { 
        String validMacAddress = '00:a0:bc:11:22:33';
        String invalidStartDate = 'Invalid Date';
        String invalidEndDate = 'Invalid Date'; 
        
        String requestURI = '/modem/' + validMacAddress + '/usage';
        
        RestRequest req = new RestRequest();
        req.requestURI = requestURI;
        req.resourcePath = '/modem/*/usage';
        req.addParameter(START_DATE_PARAM, invalidStartDate);
        req.addParameter(END_DATE_PARAM, invalidEndDate);

        SNG_Rest_JsonResponse response = new SNG_REST_ModemUsage(req).get();
        
        compareResponses(response, SNGHttpUtilities.Status.INPUT_VALIDATION_ERROR, 
                            SNG_REST_Error.SubCode.SALESFORCE_GENERATED_ERROR, SNG_REST_Error.INVALID_DATE +  ' Dates must be in YYYY-MM-DD format.', 
                            null);
    }
    
    
    static testMethod void testHandler_InvalidDateFutureStartDate() { 
        
        String startYear, startMonth, startDay;
        String endYear, endMonth, endDay;
        
        // Set Start date to the future
        Date futureDate = SNG_DateUtils.todayGmt().addDays(1); 
        startYear = String.valueOf(futureDate.year());
        startMonth = ((futureDate.month() < 10) ? '0' : '') + String.valueOf(futureDate.month());
        startDay = ((futureDate.day() < 10) ? '0' : '') + String.valueOf(futureDate.day());
    
         // Set End date to the future one day after start date
        futureDate = futureDate.addDays(1);
        endYear = String.valueOf(futureDate.year());
        endMonth = ((futureDate.month() < 10) ? '0' : '') + String.valueOf(futureDate.month());
        endDay = ((futureDate.day() < 10) ? '0' : '') + String.valueOf(futureDate.day());
        
        String validMacAddress = '00:a0:bc:11:22:33';
        String futureStartDate = startYear + '-' + startMonth + '-' + startDay;
        String endDate = endYear + '-' + endMonth + '-' + endDay;
        
        String requestURI = '/modem/' + validMacAddress + '/usage';
        
        RestRequest req = new RestRequest();
        req.requestURI = requestURI;
        req.resourcePath = '/modem/*/usage';
        req.addParameter(START_DATE_PARAM, futureStartDate);
        req.addParameter(END_DATE_PARAM, endDate);  

        SNG_REST_JsonResponse response = new SNG_REST_ModemUsage(req).get();
        
        compareResponses(response, SNGHttpUtilities.Status.INPUT_VALIDATION_ERROR, SNG_REST_Error.SubCode.SALESFORCE_GENERATED_ERROR,
                        SNG_REST_Error.START_DATE_IN_FUTURE, null);
    }
        
    static testMethod void testHandler_InvalidDateEndDateBeforeStartDate() { 
        // Client input
        String validMacAddress = '00:a0:bc:11:22:33';
        String startDate = '2014-05-01';
        String endDateBeforeStartDate = '2014-04-01';
        
        RestRequest req = new RestRequest();
        req.requestURI = '/modem/' + validMacAddress + '/usage';
        req.resourcePath = '/modem/*/usage';
        req.addParameter(START_DATE_PARAM, startDate);
        req.addParameter(END_DATE_PARAM, endDateBeforeStartDate);

        SNG_REST_JsonResponse response = new SNG_REST_ModemUsage(req).get();
        
        compareResponses(response, SNGHttpUtilities.Status.INPUT_VALIDATION_ERROR, SNG_REST_Error.SubCode.SALESFORCE_GENERATED_ERROR, 
                            SNG_REST_Error.END_DATE_BEFORE_START_DATE, null);
    }
    
    static testMethod void testHandler_InvalidDateMissingStartDate() { 
        //Client input
        String validMacAddress = '00:a0:bc:11:22:33';
        String endDate = '2014-05-01';
        
        RestRequest req = new RestRequest();
        req.requestURI = '/modem/' + validMacAddress + '/usage';
        req.resourcePath = '/modem/*/usage';
        req.addParameter(END_DATE_PARAM, endDate);

        SNG_REST_JsonResponse response = new SNG_REST_ModemUsage(req).get();
        
        compareResponses(response, SNGHttpUtilities.Status.INPUT_VALIDATION_ERROR, SNG_REST_Error.SubCode.SALESFORCE_GENERATED_ERROR, 
                            SNG_REST_Error.MISSING_START_DATE, null);
    }
    
    static testMethod void testHandler_InvalidDateMissingEndDate() { 
        //Client input
        String validMacAddress = '00:a0:bc:11:22:33';
        String startDate = '2014-05-01';
        
        RestRequest req = new RestRequest();
        req.requestURI = '/modem/' + validMacAddress + '/usage';
        req.resourcePath = '/modem/*/usage';
        req.addParameter(START_DATE_PARAM, startDate);

        SNG_REST_JsonResponse response = new SNG_REST_ModemUsage(req).get();
        
        compareResponses(response, SNGHttpUtilities.Status.INPUT_VALIDATION_ERROR, SNG_REST_Error.SubCode.SALESFORCE_GENERATED_ERROR, 
                            SNG_REST_Error.MISSING_END_DATE, null);
    }    
    
    static testMethod void testHandler_NoModemForMacAddress() { 
        //Client input
        String validMacAddress = '00:a0:bc:11:22:33';
        String startDate = '2014-04-01';
        String endDate = '2014-05-01';
        
        RestRequest req = new RestRequest();
        req.requestURI = '/modem/' + validMacAddress + '/usage';
        req.resourcePath = '/modem/*/usage';
        req.addParameter(START_DATE_PARAM, startDate);
        req.addParameter(END_DATE_PARAM, endDate);

        SNG_REST_JsonResponse response = new SNG_REST_ModemUsage(req).get();
        
        compareResponses(response, SNGHttpUtilities.Status.ZERO_RESULTS, SNG_REST_Error.SubCode.SALESFORCE_GENERATED_ERROR, 
                            SNG_REST_ModemUsage.MISSING_MODEM, null);
    }
    
    static testMethod void testHandler_NoModemServicePlans() { 
        // Client Input
        String validMacAddress = '00:a0:bc:11:22:33';
        String startDate = '2014-04-01';
        String endDate = '2014-05-01';
        
        // Insert modem  
        Account account = SNG_TestUtilities.insertAccount('testAccount');
        Modem__c modem = SNG_TestUtilities.insertModem(validMacAddress, '111111', false);
        
        RestRequest req = new RestRequest();
        req.requestURI = '/modem/' + validMacAddress + '/usage';
        req.resourcePath = '/modem/*/usage';
        req.addParameter(START_DATE_PARAM, startDate);
        req.addParameter(END_DATE_PARAM, endDate);

        SNG_REST_JsonResponse response = new SNG_REST_ModemUsage(req).get();
        
        compareResponses(response, SNGHttpUtilities.Status.ZERO_RESULTS, SNG_REST_Error.SubCode.SALESFORCE_GENERATED_ERROR, 
                        SNG_REST_ModemUsage.MODEM_NOT_ACTIVE, null);
    }
 
    
    static testMethod void testGetServicePlanId_SunnyDay()
    {
        SNG_ModemUsageDate mud1 = new SNG_ModemUsageDate('00:a0:bc:11:22:33', DateTime.newInstance(2014, 4, 1), DateTime.newInstance(2014, 5, 1));
        SNG_REST_ModemUsage.ServicePlanInfo sp1 = new SNG_REST_ModemUsage.ServicePlanInfo('SP-0001', mud1);
        
        SNG_ModemUsageDate mud2 = new SNG_ModemUsageDate('00:a0:bc:22:33:44', DateTime.newInstance(2014, 5, 1), DateTime.newInstance(2014, 6, 1));
        SNG_REST_ModemUsage.ServicePlanInfo sp2 = new SNG_REST_ModemUsage.ServicePlanInfo('SP-0002', mud2);
        
        List<SNG_REST_ModemUsage.ServicePlanInfo> servicePlans = new List<SNG_REST_ModemUsage.ServicePlanInfo>();
        servicePlans.add(sp1);
        servicePlans.add(sp2);
        
        System.assertEquals('SP-0001', SNG_REST_ModemUsage.getServicePlanId(servicePlans, DateTime.newInstance(2014, 4, 16)) );
        System.assertEquals('SP-0002', SNG_REST_ModemUsage.getServicePlanId(servicePlans, DateTime.newInstance(2014, 5, 24)) );
    }
    
    static testMethod void testGetServicePlanId_OutOfRangeDate()
    {
        SNG_ModemUsageDate mud1 = new SNG_ModemUsageDate('00:a0:bc:11:22:33', DateTime.newInstance(2014, 4, 1), DateTime.newInstance(2014, 5, 1));
        SNG_REST_ModemUsage.ServicePlanInfo sp1 = new SNG_REST_ModemUsage.ServicePlanInfo('SP-0001', mud1);
        
        SNG_ModemUsageDate mud2 = new SNG_ModemUsageDate('00:a0:bc:22:33:44', DateTime.newInstance(2014, 5, 1), DateTime.newInstance(2014, 6, 1));
        SNG_REST_ModemUsage.ServicePlanInfo sp2 = new SNG_REST_ModemUsage.ServicePlanInfo('SP-0002', mud2);
        
        List<SNG_REST_ModemUsage.ServicePlanInfo> servicePlans = new List<SNG_REST_ModemUsage.ServicePlanInfo>();
        servicePlans.add(sp1);
        servicePlans.add(sp2);
        
        try
        {
            SNG_REST_ModemUsage.getServicePlanId(servicePlans, DateTime.newInstance(2014, 6, 27));
            System.assert(false);
        }
        catch (SNG_Exception e)
        {
            System.assert(true);
        }
    }
    
    //Exception occurred during Salesforce HTTP callout process 
    static testMethod void testHandler_HttpCalloutExceptionSalesforce() { 
        
        SNG_MockCustomSettings.initialize();
        
        // Client input
        String macAddress = SNG_MockUsageServiceHttpCallout.CALLOUT_EXCEPTION_MAC_ADDRESS;
        String queryStartDate = '2014-08-15';
        String queryEndDate = '2014-10-05';
        
        // Build Account, Terminal, and Modem object 
        Account account = SNG_TestUtilities.insertAccount('testAccount');
        Terminal__c terminal = SNG_TestUtilities.insertTerminal(account, '11111', '1234561');
        Modem__c modem = SNG_TestUtilities.insertModem(account, '11111', macAddress, '123', terminal);
        
        // Build Service Plans
        Product2 servicePlanType = SNG_TestUtilities.insertServicePlanType(true);
        ServicePlan__c servicePlan_1 = SNG_TestUtilities.insertServicePlan(account, servicePlanType, 
                                                                            Date.valueOf('2014-04-01'), Date.valueOf('2014-12-30'));
        
        // Build Modem Service Plan
        ModemServicePlan__c msp1_inRange = new ModemServicePlan__c(); 
        msp1_inRange.Modem__c = modem.Id;
        msp1_inRange.Modem__r = modem;
        msp1_inRange.ServicePlan__c = servicePlan_1.Id;
        msp1_inRange.ServicePlan__r = servicePlan_1;
        msp1_inRange.StartDate__c = Date.valueOf('2014-09-01');
        msp1_inRange.EndDate__c = Date.valueOf('2014-10-01');
        insert msp1_inRange;
        
        // Build the RestContext Request
        RestRequest req = new RestRequest();
        req.requestURI = '/modem/' + macAddress + '/usage';
        req.resourcePath = '/modem/*/usage';
        req.addParameter('start-date', queryStartDate);
        req.addParameter('end-date', queryEndDate);

        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new SNG_MockUsageServiceHttpCallout());
        
        
        try {
            SNG_REST_JsonResponse response = new SNG_REST_ModemUsage(req).get();
        }
        catch (SNG_CalloutException e) { 
            System.assertEquals('Hello world', e.getMessage());
        }
    }
    
    // UsageService is down, cannot be reached
    static testMethod void testHandler_UsageServiceDown() { 
        
        SNG_MockCustomSettings.initialize();
        
        // Client input
        String macAddress = SNG_MockUsageServiceHttpCallout.HTTP_STATUS_FAILURE_MAC_ADDRESS;
        String queryStartDate = '2014-08-15';
        String queryEndDate = '2014-10-05';
        
        // Build Account, Terminal, and Modem object 
        Account account = SNG_TestUtilities.insertAccount('testAccount');
        Terminal__c terminal = SNG_TestUtilities.insertTerminal(account, '11111', '1234561');
        Modem__c modem = SNG_TestUtilities.insertModem(account, '11111', macAddress, '123', terminal);
        
        // Build Service Plans
        Product2 servicePlanType = SNG_TestUtilities.insertServicePlanType(true);
        ServicePlan__c servicePlan_1 = SNG_TestUtilities.insertServicePlan(account, servicePlanType, 
                                                                            Date.valueOf('2014-04-01'), Date.valueOf('2014-12-30'));
                                                                            
        servicePlan_1 = [SELECT Name, Id, StartDate__c, EndDate__c FROM ServicePlan__c WHERE Id = :servicePlan_1.Id];
        
        // Build Modem Service Plans
        ModemServicePlan__c msp1_inRange = new ModemServicePlan__c(); 
        msp1_inRange.Modem__c = modem.Id;
        msp1_inRange.Modem__r = modem;
        msp1_inRange.ServicePlan__c = servicePlan_1.Id;
        msp1_inRange.ServicePlan__r = servicePlan_1;
        msp1_inRange.StartDate__c = Date.valueOf('2014-09-01');
        msp1_inRange.EndDate__c = Date.valueOf('2014-10-01');
        insert msp1_inRange;
        
        RestRequest req = new RestRequest(); 
        req.requestURI = '/modem/' + macAddress + '/usage';
        req.resourcePath = '/modem/*/usage';
        req.addParameter('start-date', queryStartDate);
        req.addParameter('end-date', queryEndDate);

        // Need Test.startTest() cannot make any callouts after a DML statement within the same transaction. 
        // This is to ensure that the DML transaction is completed before the Web Service/or any callout occurs
        // Can't make callouts with pending transactions in the request context
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new SNG_MockUsageServiceHttpCallout());
        
        
        SNG_REST_JsonResponse response = new SNG_REST_ModemUsage(req).get();
        
        compareResponses(response, SNGHttpUtilities.Status.SERVER_ERROR, SNG_REST_Error.SubCode.WEBSERVICE_GENERATED_ERROR, 
                        SNG_REST_Error.GENERIC_WEBSERVICE_ERROR, null);
    }
    
    // No usage data associated with the MAC address in UDM
    static testMethod void testHandler_NoUsageDataForMacAddress() { 
        SNG_MockCustomSettings.initialize();
        
        // Client input
        String macAddress = SNG_MockUsageServiceHttpCallout.STATUS_FAILURE_DATA_EMPTY_MAC_ADDRESS;
        String queryStartDate = '2014-08-15';
        String queryEndDate = '2014-10-05';
        
        // Build Account, Terminal, and Modem object 
        Account account = SNG_TestUtilities.insertAccount('testAccount');
        Terminal__c terminal = SNG_TestUtilities.insertTerminal(account, '11111', '1234561');
        Modem__c modem = SNG_TestUtilities.insertModem(account, '11111', macAddress, '123', terminal);
        
        // Build Service Plans
        Product2 servicePlanType = SNG_TestUtilities.insertServicePlanType(true);
        ServicePlan__c servicePlan_1 = SNG_TestUtilities.insertServicePlan(account, servicePlanType, 
                                                                            Date.valueOf('2014-04-01'), Date.valueOf('2014-12-30'));
                                                                            
        servicePlan_1 = [SELECT Name, Id, StartDate__c, EndDate__c FROM ServicePlan__c WHERE Id = :servicePlan_1.Id];
        
        // Build Modem Service Plans
        ModemServicePlan__c msp1_inRange = new ModemServicePlan__c(); 
        msp1_inRange.Modem__c = modem.Id;
        msp1_inRange.Modem__r = modem;
        msp1_inRange.ServicePlan__c = servicePlan_1.Id;
        msp1_inRange.ServicePlan__r = servicePlan_1;
        msp1_inRange.StartDate__c = Date.valueOf('2014-09-01');
        msp1_inRange.EndDate__c = Date.valueOf('2014-10-01');
        insert msp1_inRange;
        
        RestRequest req = new RestRequest(); 
        req.requestURI = '/modem/' + macAddress + '/usage';
        req.resourcePath = '/modem/*/usage';
        req.addParameter('start-date', queryStartDate);
        req.addParameter('end-date', queryEndDate);
        
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new SNG_MockUsageServiceHttpCallout());
        
        
        SNG_REST_JsonResponse response = new SNG_REST_ModemUsage(req).get();
        
        compareResponses(response, SNGHttpUtilities.Status.SERVER_ERROR, SNG_REST_Error.SubCode.WEBSERVICE_GENERATED_ERROR, 
                        SNG_REST_Error.GENERIC_WEBSERVICE_ERROR, null);
    }
    
    // Sunny Day Test for response from Usage Service 
     static testMethod void testHandler_SunnyDay_OneMSP_NoData() { 
        
        SNG_MockCustomSettings.initialize();
        
        // Client input
        String macAddress = SNG_MockUsageServiceHttpCallout.SUNNY_DAY_MAC_ADDRESS_NO_DATA;
        String queryStartDate = '2014-08-15';
        String queryEndDate = '2014-10-05';
        
        // Build Account, Terminal, and Modem object 
        Account account = SNG_TestUtilities.insertAccount('testAccount');
        Terminal__c terminal = SNG_TestUtilities.insertTerminal(account, '11111', '1234561');
        Modem__c modem = SNG_TestUtilities.insertModem(account, '11111', macAddress, '123', terminal);
        
        // Build Service Plans
        Product2 servicePlanType = SNG_TestUtilities.insertServicePlanType(true);
        ServicePlan__c servicePlan_1 = SNG_TestUtilities.insertServicePlan(account, servicePlanType, 
                                                                            Date.valueOf('2014-04-01'), Date.valueOf('2014-12-30'));
        
        servicePlan_1 = [SELECT Name, Id, StartDate__c, EndDate__c FROM ServicePlan__c WHERE Id = :servicePlan_1.Id];
        
        // Build Modem Service Plans
        ModemServicePlan__c msp1_inRange = new ModemServicePlan__c(); 
        msp1_inRange.Modem__c = modem.Id;
        msp1_inRange.Modem__r = modem;
        msp1_inRange.ServicePlan__c = servicePlan_1.Id;
        msp1_inRange.ServicePlan__r = servicePlan_1;
        msp1_inRange.StartDate__c = Date.valueOf('2014-09-01');
        msp1_inRange.EndDate__c = Date.valueOf('2014-10-01');
        insert msp1_inRange;
        
        // MSP is out of range should not be included in query
        ModemServicePlan__c msp2_outOfRange = new ModemServicePlan__c();
        msp2_outOfRange.Modem__c = modem.Id;
        msp2_outOfRange.Modem__r = modem;
        msp2_outOfRange.ServicePlan__c = servicePlan_1.Id;
        msp2_outOfRange.ServicePlan__r = servicePlan_1;
        msp2_outOfRange.StartDate__c = Date.valueOf('2014-07-01');
        msp2_outOfRange.EndDate__c = Date.valueOf('2014-08-10');
        insert msp2_outOfRange;
        
        // Build the RestContext Request
        RestRequest req = new RestRequest();
        req.requestURI = '/modem/' + macAddress + '/usage';
        req.resourcePath = '/modem/*/usage';
        req.addParameter('start-date', queryStartDate);
        req.addParameter('end-date', queryEndDate);
        
        Test.startTest();
        // Set mock callout class
        Test.setMock(HttpCalloutMock.class, new SNG_MockUsageServiceHttpCallout());
        
        SNG_REST_JsonResponse response = new SNG_REST_ModemUsage(req).get();
        
        // Create expected SNG_REST_JsonResponse to compare against
        SNG_REST_ModemUsageOutput.ServicePlanUsageData item = new SNG_REST_ModemUsageOutput.ServicePlanUsageData(servicePlan_1.Name, 0, 0);
        List<SNG_REST_ModemUsageOutput.ServicePlanUsageData> items = new List<SNG_REST_ModemUsageOutput.ServicePlanUsageData>();
        items.add(item); 
           
        SNG_REST_ModemUsageOutput expectedData = new SNG_REST_ModemUsageOutput(items, 
                                                                               SNG_MockUsageServiceHttpCallout.SUNNY_DAY_MAC_ADDRESS_NO_DATA);

        compareResponses(response, SNGHttpUtilities.Status.OK, null, null, expectedData);
        
        Test.stopTest();
    } 
     
     
    static testMethod void testHandler_SunnyDay_OneMSP() { 
        
        SNG_MockCustomSettings.initialize();
        
        // Client input
        String macAddress = SNG_MockUsageServiceHttpCallout.SUNNY_DAY_MAC_ADDRESS_SINGLE;
        String queryStartDate = '2014-08-15';
        String queryEndDate = '2014-10-05';
        
        // Build Account, Terminal, and Modem object 
        Account account = SNG_TestUtilities.insertAccount('testAccount');
        Terminal__c terminal = SNG_TestUtilities.insertTerminal(account, '11111', '1234561');
        Modem__c modem = SNG_TestUtilities.insertModem(account, '11111', macAddress, '123', terminal);
        
        // Build Service Plans
        Product2 servicePlanType = SNG_TestUtilities.insertServicePlanType(true);
        ServicePlan__c servicePlan_1 = SNG_TestUtilities.insertServicePlan(account, servicePlanType, 
                                                                            Date.valueOf('2014-04-01'), Date.valueOf('2014-12-30'));
        
        servicePlan_1 = [SELECT Name, Id, StartDate__c, EndDate__c FROM ServicePlan__c WHERE Id = :servicePlan_1.Id];
        
        // Build Modem Service Plans
        ModemServicePlan__c msp1_inRange = new ModemServicePlan__c(); 
        msp1_inRange.Modem__c = modem.Id;
        msp1_inRange.Modem__r = modem;
        msp1_inRange.ServicePlan__c = servicePlan_1.Id;
        msp1_inRange.ServicePlan__r = servicePlan_1;
        msp1_inRange.StartDate__c = Date.valueOf('2014-09-01');
        msp1_inRange.EndDate__c = Date.valueOf('2014-10-01');
        insert msp1_inRange;
        
        // MSP is out of range should not be included in query
        ModemServicePlan__c msp2_outOfRange = new ModemServicePlan__c();
        msp2_outOfRange.Modem__c = modem.Id;
        msp2_outOfRange.Modem__r = modem;
        msp2_outOfRange.ServicePlan__c = servicePlan_1.Id;
        msp2_outOfRange.ServicePlan__r = servicePlan_1;
        msp2_outOfRange.StartDate__c = Date.valueOf('2014-07-01');
        msp2_outOfRange.EndDate__c = Date.valueOf('2014-08-10');
        insert msp2_outOfRange;
        
        // Build the RestContext Request
        RestRequest req = new RestRequest();
        req.requestURI = '/modem/' + macAddress + '/usage';
        req.resourcePath = '/modem/*/usage';
        req.addParameter('start-date', queryStartDate);
        req.addParameter('end-date', queryEndDate);
        
        Test.startTest();
        // Set mock callout class
        Test.setMock(HttpCalloutMock.class, new SNG_MockUsageServiceHttpCallout());
        
        SNG_REST_JsonResponse response = new SNG_REST_ModemUsage(req).get();
        
        // Create expected SNG_REST_JsonResponse to compare against
        SNG_REST_ModemUsageOutput.ServicePlanUsageData item = new SNG_REST_ModemUsageOutput.ServicePlanUsageData(servicePlan_1.Name, 7891236789L, 1234567890L);
        List<SNG_REST_ModemUsageOutput.ServicePlanUsageData> items = new List<SNG_REST_ModemUsageOutput.ServicePlanUsageData>();
        items.add(item); 
            
        SNG_REST_ModemUsageOutput expectedData = new SNG_REST_ModemUsageOutput(items, 
                                                                               SNG_MockUsageServiceHttpCallout.SUNNY_DAY_MAC_ADDRESS_SINGLE);

        compareResponses(response, SNGHttpUtilities.Status.OK, null, null, expectedData);

        //request with URL encode
        req = new RestRequest();
        req.requestURI = '/modem/' + EncodingUtil.urlEncode(macAddress, 'UTF-8') + '/usage';
        req.resourcePath = '/modem/*/usage';
        req.addParameter('start-date', queryStartDate);
        req.addParameter('end-date', queryEndDate);


        response = new SNG_REST_ModemUsage(req).get();
        compareResponses(response, SNGHttpUtilities.Status.OK, null, null, expectedData);


        //request with mac address without colons
        req = new RestRequest();
        req.requestURI = '/modem/' + macAddress.remove(':') + '/usage';
        req.resourcePath = '/modem/*/usage';
        req.addParameter('start-date', queryStartDate);
        req.addParameter('end-date', queryEndDate);


        response = new SNG_REST_ModemUsage(req).get();
        compareResponses(response, SNGHttpUtilities.Status.OK, null, null, expectedData);

        Test.stopTest();
    }
    
    
    static testMethod void testHandler_SunnyDay_OneMSPTwoEntries() { 
        
        SNG_MockCustomSettings.initialize();
        
        // Client input
        String macAddress = SNG_MockUsageServiceHttpCallout.SUNNY_DAY_MAC_ADDRESS_SINGLE_TE;
        String queryStartDate = '2014-08-15';
        String queryEndDate = '2014-10-05';
        
        // Build Account, Terminal, and Modem object 
        Account account = SNG_TestUtilities.insertAccount('testAccount');
        Terminal__c terminal = SNG_TestUtilities.insertTerminal(account, '11111', '1234561');
        Modem__c modem = SNG_TestUtilities.insertModem(account, '11111', macAddress, '123', terminal);
        
        // Build Service Plans
        Product2 servicePlanType = SNG_TestUtilities.insertServicePlanType(true);
        ServicePlan__c servicePlan_1 = SNG_TestUtilities.insertServicePlan(account, servicePlanType, 
                                                                            Date.valueOf('2014-04-01'), Date.valueOf('2014-12-30'));
        
        servicePlan_1 = [SELECT Name, Id, StartDate__c, EndDate__c FROM ServicePlan__c WHERE Id = :servicePlan_1.Id];
        
        // Build Modem Service Plans
        ModemServicePlan__c msp1_inRange = new ModemServicePlan__c(); 
        msp1_inRange.Modem__c = modem.Id;
        msp1_inRange.Modem__r = modem;
        msp1_inRange.ServicePlan__c = servicePlan_1.Id;
        msp1_inRange.ServicePlan__r = servicePlan_1;
        msp1_inRange.StartDate__c = Date.valueOf('2014-09-01');
        msp1_inRange.EndDate__c = Date.valueOf('2014-10-01');
        insert msp1_inRange;
        
        // MSP is out of range should not be included in query
        ModemServicePlan__c msp2_outOfRange = new ModemServicePlan__c();
        msp2_outOfRange.Modem__c = modem.Id;
        msp2_outOfRange.Modem__r = modem;
        msp2_outOfRange.ServicePlan__c = servicePlan_1.Id;
        msp2_outOfRange.ServicePlan__r = servicePlan_1;
        msp2_outOfRange.StartDate__c = Date.valueOf('2014-07-01');
        msp2_outOfRange.EndDate__c = Date.valueOf('2014-08-10');
        insert msp2_outOfRange;
        
        // Build the RestContext Request
        RestRequest req = new RestRequest();
        req.requestURI = '/modem/' + macAddress + '/usage';
        req.resourcePath = '/modem/*/usage';
        req.addParameter('start-date', queryStartDate);
        req.addParameter('end-date', queryEndDate);

        Test.startTest();
        // Set mock callout class
        Test.setMock(HttpCalloutMock.class, new SNG_MockUsageServiceHttpCallout());
        
        SNG_REST_JsonResponse response = new SNG_REST_ModemUsage(req).get();
        
        long expectedDlUsage = SNG_MockUsageServiceHttpCallout.SINGLE_AGGREGATE_DOWNLOAD + SNG_MockUsageServiceHttpCallout.SINGLE_TE_AGGREGATE_DOWNLOAD;
        long expectedUlUsage = SNG_MockUsageServiceHttpCallout.SINGLE_AGGREGATE_UPLOAD + SNG_MockUsageServiceHttpCallout.SINGLE_TE_AGGREGATE_UPLOAD;
        
        
        // Create expected SNG_REST_JsonResponse to compare against
        SNG_REST_ModemUsageOutput.ServicePlanUsageData item = new SNG_REST_ModemUsageOutput.ServicePlanUsageData(servicePlan_1.Name, expectedDlUsage, expectedUlUsage);
        List<SNG_REST_ModemUsageOutput.ServicePlanUsageData> items = new List<SNG_REST_ModemUsageOutput.ServicePlanUsageData>();
        items.add(item); 
         
        SNG_REST_ModemUsageOutput expectedData = new SNG_REST_ModemUsageOutput(items, 
                                                                               SNG_MockUsageServiceHttpCallout.SUNNY_DAY_MAC_ADDRESS_SINGLE_TE);

        compareResponses(response, SNGHttpUtilities.Status.OK, null, null, expectedData);
        
        Test.stopTest();
    }
    
    static testMethod void testHandler_SunnyDay_MissingOneServicePlanData() { 
        
        SNG_MockCustomSettings.initialize();
        
        // Client input
        String macAddress = SNG_MockUsageServiceHttpCallout.SUNNY_DAY_MAC_ADDRESS_SINGLE;
        String queryStartDate = '2014-08-15';
        String queryEndDate = '2014-10-05';
        
        // Build Account, Terminal, and Modem object 
        Account account = SNG_TestUtilities.insertAccount('testAccount');
        Terminal__c terminal = SNG_TestUtilities.insertTerminal(account, '11111', '1234561');
        Modem__c modem = SNG_TestUtilities.insertModem(account, '11111', macAddress, '123', terminal);
        
        // Build Service Plans
        Product2 servicePlanType = SNG_TestUtilities.insertServicePlanType(true);
        ServicePlan__c servicePlan_1 = SNG_TestUtilities.insertServicePlan(account, servicePlanType, 
                                                                            Date.valueOf('2014-04-01'), Date.valueOf('2014-12-30'));
                                                                            
        ServicePlan__c servicePlan_2 = SNG_TestUtilities.insertServicePlan(account, servicePlanType, 
                                                                            Date.valueOf('2014-04-01'), Date.valueOf('2014-12-30'));
        
        servicePlan_1 = [SELECT Name, Id, StartDate__c, EndDate__c FROM ServicePlan__c WHERE Id = :servicePlan_1.Id];
        servicePlan_2 = [SELECT Name, Id, StartDate__c, EndDate__c FROM ServicePlan__c WHERE Id = :servicePlan_2.Id];
        
        // Build Modem Service Plans
        ModemServicePlan__c msp1_inRange = new ModemServicePlan__c(); 
        msp1_inRange.Modem__c = modem.Id;
        msp1_inRange.Modem__r = modem;
        msp1_inRange.ServicePlan__c = servicePlan_1.Id;
        msp1_inRange.ServicePlan__r = servicePlan_1;
        msp1_inRange.StartDate__c = Date.valueOf(SNG_MockUsageServiceHttpCallout.SINGLE_START_TIME);
        msp1_inRange.EndDate__c = Date.valueOf(SNG_MockUsageServiceHttpCallout.SINGLE_END_TIME);
        insert msp1_inRange;
        
        // MSP is in range but will not be returned as data.
        ModemServicePlan__c msp2_inRangeNoData = new ModemServicePlan__c();
        msp2_inRangeNoData.Modem__c = modem.Id;
        msp2_inRangeNoData.Modem__r = modem;
        msp2_inRangeNoData.ServicePlan__c = servicePlan_2.Id;
        msp2_inRangeNoData.ServicePlan__r = servicePlan_2;
        msp2_inRangeNoData.StartDate__c = msp1_inRange.EndDate__c.addDays(2);
        msp2_inRangeNoData.EndDate__c = msp2_inRangeNoData.StartDate__c.addDays(1);
        insert msp2_inRangeNoData;
        
        // Build the RestContext Request
        RestRequest req = new RestRequest();
        req.requestURI = '/modem/' + macAddress + '/usage';
        req.resourcePath = '/modem/*/usage';
        req.addParameter('start-date', queryStartDate);
        req.addParameter('end-date', queryEndDate);

        Test.startTest();
        // Set mock callout class
        Test.setMock(HttpCalloutMock.class, new SNG_MockUsageServiceHttpCallout());
        
        SNG_REST_JsonResponse response = new SNG_REST_ModemUsage(req).get();
        
        // Create expected SNG_REST_JsonResponse to compare against
        SNG_REST_ModemUsageOutput.ServicePlanUsageData item1 = new SNG_REST_ModemUsageOutput.ServicePlanUsageData(servicePlan_1.Name, SNG_MockUsageServiceHttpCallout.SINGLE_AGGREGATE_DOWNLOAD, SNG_MockUsageServiceHttpCallout.SINGLE_AGGREGATE_UPLOAD);
        SNG_REST_ModemUsageOutput.ServicePlanUsageData item2 = new SNG_REST_ModemUsageOutput.ServicePlanUsageData(servicePlan_2.Name, 0, 0);
        
        List<SNG_REST_ModemUsageOutput.ServicePlanUsageData> items = new List<SNG_REST_ModemUsageOutput.ServicePlanUsageData>();
        items.add(item1);
        items.add(item2); 
            
        SNG_REST_ModemUsageOutput expectedData = new SNG_REST_ModemUsageOutput(items, 
                                                                               SNG_MockUsageServiceHttpCallout.SUNNY_DAY_MAC_ADDRESS_SINGLE);

        compareResponses(response, SNGHttpUtilities.Status.OK, null, null, expectedData);
        
        Test.stopTest();
    }
 
    // Sunnyday response for two msps
    static testMethod void testHandler_Sunnyday_TwoMSPs() { 
        
        SNG_MockCustomSettings.initialize();
        // Client input/query
        String macAddress = SNG_MockUsageServiceHttpCallout.SUNNY_DAY_MAC_ADDRESS_DOUBLE_A;
        String startDate = '2014-09-01';
        String endDate = '2014-09-30';
        
        // Build Account, Terminal, and Modem object 
        Account account = SNG_TestUtilities.insertAccount('testAccount');
        Terminal__c terminal = SNG_TestUtilities.insertTerminal(account, '11111', '1234561');
        Modem__c modem = SNG_TestUtilities.insertModem(account, '11111', macAddress, '123', terminal);
        
        // Build Service Plans
        Product2 servicePlanType = SNG_TestUtilities.insertServicePlanType(true);
        ServicePlan__c servicePlan_1 = SNG_TestUtilities.insertServicePlan(account, servicePlanType, 
                                                                            Date.valueOf('2014-04-01'), Date.valueOf('2014-12-30'));
        ServicePlan__c servicePlan_2 = SNG_TestUtilities.insertServicePlan(account, servicePlanType, 
                                                                            Date.valueOf('2014-07-01'), Date.valueOf('2014-12-25'));
        
        
        
        servicePlan_1 = [SELECT Name, Id, StartDate__c, EndDate__c FROM ServicePlan__c WHERE Id = :servicePlan_1.Id];  
        servicePlan_2 = [SELECT Name, Id, StartDate__c, EndDate__c FROM ServicePlan__c WHERE Id = :servicePlan_2.Id]; 
        
        // Build Modem Service Plans
        ModemServicePlan__c msp1_inRange = new ModemServicePlan__c(); 
        msp1_inRange.Modem__c = modem.Id;
        msp1_inRange.Modem__r = modem;
        msp1_inRange.ServicePlan__c = servicePlan_1.Id;
        msp1_inRange.ServicePlan__r = servicePlan_1;
        msp1_inRange.StartDate__c = Date.valueOf('2014-08-31');
        msp1_inRange.EndDate__c = Date.valueOf('2014-09-10');
        insert msp1_inRange; 
        
        ModemServicePlan__c msp2_inRange = new ModemServicePlan__c();
        msp2_inRange.Modem__c = modem.Id;
        msp2_inRange.Modem__r = modem;
        msp2_inRange.ServicePlan__c = servicePlan_2.Id;
        msp2_inRange.ServicePlan__r = servicePlan_2;
        msp2_inRange.StartDate__c = Date.valueOf('2014-09-11');
        msp2_inRange.EndDate__c = Date.valueOf('2014-09-17');
        insert msp2_inRange;     
        
        ModemServicePlan__c msp3_outOfRange = new ModemServicePlan__c();
        msp3_outOfRange.Modem__c = modem.Id;
        msp3_outOfRange.Modem__r = modem;
        msp3_outOfRange.ServicePlan__c = servicePlan_2.Id;
        msp3_outOfRange.ServicePlan__r = servicePlan_2;
        msp3_outOfRange.StartDate__c = Date.valueOf('2014-10-01');
        msp3_outOfRange.EndDate__c = Date.valueOf('2014-10-17');
        insert msp3_outOfRange;          
        
        // Build the RestContext Request
        RestRequest req = new RestRequest();
        req.requestURI = '/modem/' + macAddress + '/usage';
        req.resourcePath = '/modem/*/usage';
        req.addParameter('start-date', startDate);
        req.addParameter('end-date', endDate);
        
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new SNG_MockUsageServiceHttpCallout());
        

        SNG_REST_JsonResponse response = new SNG_REST_ModemUsage(req).get();
        
        // Create expected SNG_REST_JsonResponse to compare against
        SNG_REST_ModemUsageOutput.ServicePlanUsageData item_1 = new SNG_REST_ModemUsageOutput.ServicePlanUsageData(servicePlan_1.Name, 
                                                                                 SNG_MockUsageServiceHttpCallout.DOUBLE_A_AGGREGATE_DOWNLOAD,
                                                                                 SNG_MockUsageServiceHttpCallout.DOUBLE_A_AGGREGATE_UPLOAD);
        SNG_REST_ModemUsageOutput.ServicePlanUsageData item_2 = new SNG_REST_ModemUsageOutput.ServicePlanUsageData(servicePlan_2.Name, 
                                                                                 SNG_MockUsageServiceHttpCallout.DOUBLE_A1_AGGREGATE_DOWNLOAD,
                                                                                 SNG_MockUsageServiceHttpCallout.DOUBLE_A1_AGGREGATE_UPLOAD);
        
        List<SNG_REST_ModemUsageOutput.ServicePlanUsageData> items = new List<SNG_REST_ModemUsageOutput.ServicePlanUsageData>();                                                                                            
        
        // Salesforce seems to switch ordering of the map entries. which causes problems in consistent testing. this ensures
        // the right order comparison.
        SNG_REST_ModemUsageOutput muo = (SNG_REST_ModemUsageOutput)response.data;
        
        System.assertEquals(2, muo.items.size());
        SNG_REST_ModemUsageOutput.ServicePlanUsageData muoi = (SNG_REST_ModemUsageOutput.ServicePlanUsageData)muo.items.get(0);
        
        if (servicePlan_1.Name  == muoi.servicePlanId )
        {
            items.add(item_1);
            items.add(item_2);
        }
        else
        {
            items.add(item_2);
            items.add(item_1);
        }
        
        
        SNG_REST_ModemUsageOutput expectedData = new SNG_REST_ModemUsageOutput(items, 
                                                                               SNG_MockUsageServiceHttpCallout.SUNNY_DAY_MAC_ADDRESS_DOUBLE_A);

        compareResponses(response, SNGHttpUtilities.Status.OK, null, null, expectedData);
        
        Test.stopTest();
    }
        
    //**********************************************************
    // TEST SNG_REST_ModemUsageOutput (SNG_REST_ModemUsageOutputUnitTest)
    //**********************************************************

    //*****************************************************************
    // Inner class hashcode / equals testing
    // *****************************************************************/
    static testMethod void modemUsageOutputItem_testEquals_Symmetric() 
    {
        SNG_REST_ModemUsageOutput.ServicePlanUsageData muoiX = new SNG_REST_ModemUsageOutput.ServicePlanUsageData('SP-1234', 123456789L, 987654321L);
        SNG_REST_ModemUsageOutput.ServicePlanUsageData muoiY = new SNG_REST_ModemUsageOutput.ServicePlanUsageData('SP-1234', 123456789L, 987654321L);
        
        System.assert(muoiX.equals(muoiY) && muoiY.equals(muoiX));
        System.assertEquals(muoiX.hashCode(), muoiY.hashCode());
    }
    
    static testMethod void modemUsageOutput_testEquals_Symmetric() 
    {
        SNG_REST_ModemUsageOutput.ServicePlanUsageData muoiX = new SNG_REST_ModemUsageOutput.ServicePlanUsageData('SP-1234', 123456789L, 987654321L);
        SNG_REST_ModemUsageOutput.ServicePlanUsageData muoiY = new SNG_REST_ModemUsageOutput.ServicePlanUsageData('SP-1234', 45678121L, 11234235L);
        
        List<SNG_REST_ModemUsageOutput.ServicePlanUsageData> mouis = new List<SNG_REST_ModemUsageOutput.ServicePlanUsageData>();
        mouis.add(muoiX);
        mouis.add(muoiY);
        
        SNG_REST_ModemUsageOutput muoX = new SNG_REST_ModemUsageOutput(mouis, '00:a0:bc:11:22:33');
        SNG_REST_ModemUsageOutput muoY = new SNG_REST_ModemUsageOutput(mouis, '00:a0:bc:11:22:33');
        
        System.assert(muoX.equals(muoY) && muoY.equals(muoX));
        System.assertEquals(muoX.hashCode(), muoY.hashCode());
    }
    
    static testMethod void modemUsageOutput_testEquals_MissingItems() 
    {
        SNG_REST_ModemUsageOutput.ServicePlanUsageData muoiX = new SNG_REST_ModemUsageOutput.ServicePlanUsageData('SP-1234', 123456789L, 987654321L);
        SNG_REST_ModemUsageOutput.ServicePlanUsageData muoiY = new SNG_REST_ModemUsageOutput.ServicePlanUsageData('SP-1234', 45678121L, 11234235L);
        
        List<SNG_REST_ModemUsageOutput.ServicePlanUsageData> mouis = new List<SNG_REST_ModemUsageOutput.ServicePlanUsageData>();
        mouis.add(muoiX);
        mouis.add(muoiY);
        
        SNG_REST_ModemUsageOutput muoX = new SNG_REST_ModemUsageOutput(null, '00:a0:bc:11:22:33');
        SNG_REST_ModemUsageOutput muoY = new SNG_REST_ModemUsageOutput(null, '00:a0:bc:11:22:33');
        
        System.assert(muoX.equals(muoY) && muoY.equals(muoX));
        System.assertEquals(muoX.hashCode(), muoY.hashCode());
        
        SNG_REST_ModemUsageOutput muoA = new SNG_REST_ModemUsageOutput(null, '00:a0:bc:11:22:33');
        SNG_REST_ModemUsageOutput muoB = new SNG_REST_ModemUsageOutput(mouis, '00:a0:bc:11:22:33');
        
        System.assert(false == muoA.equals(muoB) && false == muoB.equals(muoA));       
    }
    
    //**********************************************************
    // TEST SNG_REST_ModemUsageOutputB (SNG_REST_ModemUsageOutputBUnitTest)
    //**********************************************************
    static testMethod void testGetServicePlanIdInvalid() 
    {
        try
        {
            List<SNG_REST_ModemUsage.ServicePlanInfo> servicePlans = new List<SNG_REST_ModemUsage.ServicePlanInfo>();
            DateTime startTime = DateTime.newInstance(2014, 10, 5);
            SNG_REST_ModemUsageOutputBuilder.getServicePlanId(servicePlans, startTime);
            System.assert(false);
        }
        catch (SNG_Exception e)
        {
            System.assert(true);
        }
    }
    
    static testMethod void testGetServicePlanIdSunnyDay() 
    {
        DateTime startDate1 = DateTime.newInstance(2014, 10, 6);
        DateTime endDate1 = DateTime.newInstance(2014, 10, 7);
        SNG_ModemUsageDate mud1 = new SNG_ModemUsageDate('00:a0:bc:11:22:33', startDate1, endDate1);
        
        String SERVICE_PLAN_1 = 'SP-0001';      
        SNG_REST_ModemUsage.ServicePlanInfo sp1 = new SNG_REST_ModemUsage.ServicePlanInfo(SERVICE_PLAN_1, mud1);

        DateTime startDate2 = DateTime.newInstance(2014, 10, 8);
        DateTime endDate2 = DateTime.newInstance(2014, 10, 9);
        SNG_ModemUsageDate mud2 = new SNG_ModemUsageDate('00:a0:bc:22:33:44', startDate2, endDate2);
        
        String SERVICE_PLAN_2 = 'SP-0002';      
        SNG_REST_ModemUsage.ServicePlanInfo sp2 = new SNG_REST_ModemUsage.ServicePlanInfo(SERVICE_PLAN_2, mud2);
        
        List<SNG_REST_ModemUsage.ServicePlanInfo> servicePlans = new List<SNG_REST_ModemUsage.ServicePlanInfo>();
        servicePlans.add(sp1);
        servicePlans.add(sp2);
       
        System.assertEquals(SERVICE_PLAN_1, SNG_REST_ModemUsageOutputBuilder.getServicePlanId(servicePlans, startDate1));
        System.assertEquals(SERVICE_PLAN_1, SNG_REST_ModemUsageOutputBuilder.getServicePlanId(servicePlans, endDate1));
        System.assertEquals(SERVICE_PLAN_2, SNG_REST_ModemUsageOutputBuilder.getServicePlanId(servicePlans, startDate2));
        System.assertEquals(SERVICE_PLAN_2, SNG_REST_ModemUsageOutputBuilder.getServicePlanId(servicePlans, endDate2));
       
    }
    
    static testMethod void testBuild() 
    {
        
        SNG_UsageService.UsagePerBaseStationId ub1 = new SNG_UsageService.UsagePerBaseStationId();
        ub1.bsid = 'BS1';
        ub1.acctInputOctets = 1234567890L;
        ub1.acctOutputOctets = 9876543210L;
        
        SNG_UsageService.UsagePerBaseStationId ub2 = new SNG_UsageService.UsagePerBaseStationId();
        ub2.bsid = 'BS2';
        ub2.acctInputOctets = 5678;
        ub2.acctOutputOctets = 9876;
        
        List<SNG_UsageService.UsagePerBaseStationId> ubList1 = new List<SNG_UsageService.UsagePerBaseStationId>();
        ubList1.add(ub1);
        ubList1.add(ub2);
        
        String macAddress = '00a0bc112233';
        
        SNG_UsageService.UsageAndErrors u1 = new SNG_UsageService.UsageAndErrors();
        u1.startTime = DateTime.newInstance(2014, 1, 10, 1, 2, 3);
        u1.endTime = DateTime.newInstance(2014, 2, 10, 12, 23, 14);
        u1.firstProcessedEventTimestamp = DateTime.newInstance(2014, 1, 14, 17, 0, 9);  
        u1.lastProcessedEventTimestamp = DateTime.newInstance(2014, 2, 4, 6, 45, 13);
        u1.aggregateAcctInputOctets = ub1.acctInputOctets + ub2.acctInputOctets;
        u1.aggregateAcctOutputOctets = ub1.acctOutputOctets + ub2.acctOutputOctets;
        u1.usage = ubList1;
        u1.macAddress = macAddress;

        SNG_UsageService.UsagePerBaseStationId ub3 = new SNG_UsageService.UsagePerBaseStationId();
        ub3.bsid = 'BS3';
        ub3.acctInputOctets = 641829731L;
        ub3.acctOutputOctets = 189231289L;
        
        SNG_UsageService.UsagePerBaseStationId ub4 = new SNG_UsageService.UsagePerBaseStationId();
        ub4.bsid = 'BS4';
        ub4.acctInputOctets = 98787123L;
        ub4.acctOutputOctets = 123215L;
        
        List<SNG_UsageService.UsagePerBaseStationId> ubList2 = new List<SNG_UsageService.UsagePerBaseStationId>();
        ubList2.add(ub3);
        ubList2.add(ub4);       
        
        SNG_UsageService.UsageAndErrors u2 = new SNG_UsageService.UsageAndErrors();
        u2.startTime = DateTime.newInstance(2014, 3, 1, 13, 24, 31);
        u2.endTime = DateTime.newInstance(2014, 3, 10, 9, 36, 14);
        u2.firstProcessedEventTimestamp = DateTime.newInstance(2014, 3, 15, 12, 10, 45);  
        u2.lastProcessedEventTimestamp = DateTime.newInstance(2014, 4, 15, 5, 6, 7);
        u2.aggregateAcctInputOctets = ub3.acctInputOctets + ub4.acctInputOctets;
        u2.aggregateAcctOutputOctets = ub3.acctOutputOctets + ub4.acctOutputOctets;
        u2.usage = ubList2;
        u2.macAddress = macAddress;     
        
        List<SNG_UsageService.UsageAndErrors> uaes = new List<SNG_UsageService.UsageAndErrors>();
        uaes.add(u1);
        List<SNG_UsageService.UsageAndErrors> uaes1 = new List<SNG_UsageService.UsageAndErrors>();
        uaes1.add(u2);
        
        SNG_UsageService.Response response = new SNG_UsageService.Response();
        response.status = 'success';
        response.error = 0;
        response.errorDetail = new List<String>();
        response.errorDetail.add('Hello World');
        response.errorDetail.add('Foo');
        
        List<List<SNG_UsageService.UsageAndErrors>> uaesListOfList = new List<List<SNG_UsageService.UsageAndErrors>>();
        uaesListOfList.add(uaes);
        uaesListOfList.add(uaes1);
        
        response.data = uaesListOfList;
        
        Long expectedAggUploadUsage = u1.aggregateAcctOutputOctets + u2.aggregateAcctOutputOctets;
        Long expectedAggDownloadUsage = u1.aggregateAcctInputOctets + u2.aggregateAcctInputOctets;
        Long expectedAggTotalUsage = expectedAggUploadUsage + expectedAggDownloadUsage;
        
        
        DateTime startDate1 = u1.startTime;
        DateTime endDate1 = u1.endTime;
        SNG_ModemUsageDate mud1 = new SNG_ModemUsageDate('00:a0:bc:11:22:33', startDate1, endDate1);
        
        String SERVICE_PLAN_1 = 'SP-0001';      
        SNG_REST_ModemUsage.ServicePlanInfo sp1 = new SNG_REST_ModemUsage.ServicePlanInfo(SERVICE_PLAN_1, mud1);

        DateTime startDate2 = u2.startTime;
        DateTime endDate2 = u2.endTime;
        SNG_ModemUsageDate mud2 = new SNG_ModemUsageDate('00:a0:bc:11:22:33', startDate2, endDate2);
        
        String SERVICE_PLAN_2 = 'SP-0002';      
        SNG_REST_ModemUsage.ServicePlanInfo sp2 = new SNG_REST_ModemUsage.ServicePlanInfo(SERVICE_PLAN_2, mud2);
        
        List<SNG_REST_ModemUsage.ServicePlanInfo> servicePlans = new List<SNG_REST_ModemUsage.ServicePlanInfo>();
        servicePlans.add(sp1);
        servicePlans.add(sp2);
        
        SNG_REST_ModemUsageOutput output = SNG_REST_ModemUsageOutputBuilder.build(macAddress, response, servicePlans);
        System.debug(output);
        
        System.assertEquals(macAddress, output.macAddress);
        System.assertEquals(expectedAggUploadUsage, output.uploadUsage);
        System.assertEquals(expectedAggDownloadUsage, output.downloadUsage);
        System.assertEquals(expectedAggTotalUsage, output.totalUsage);
        System.assertEquals(2, output.items.size());
            
        SNG_REST_ModemUsageOutput.ServicePlanUsageData spud = (SNG_REST_ModemUsageOutput.ServicePlanUsageData)output.items.get(0);
        if (SERVICE_PLAN_2 == spud.servicePlanId){
        	System.assertEquals(u2.aggregateAcctOutputOctets, spud.uploadUsage);
        	System.assertEquals(u2.aggregateAcctInputOctets, spud.downloadUsage);
        } else {
        //spud = (SNG_REST_ModemUsageOutput.ServicePlanUsageData)output.items.get(1);
        //System.assertEquals(SERVICE_PLAN_1,  spud.servicePlanId);
        	System.assertEquals(u1.aggregateAcctOutputOctets, spud.uploadUsage);
        	System.assertEquals(u1.aggregateAcctInputOctets, spud.downloadUsage); }
    }
    
    static testMethod void testBuildAddMissingEntry() 
    {
        
        SNG_UsageService.UsagePerBaseStationId ub1 = new SNG_UsageService.UsagePerBaseStationId();
        ub1.bsid = 'BS1';
        ub1.acctInputOctets = 1234567890L;
        ub1.acctOutputOctets = 9876543210L;
        
        SNG_UsageService.UsagePerBaseStationId ub2 = new SNG_UsageService.UsagePerBaseStationId();
        ub2.bsid = 'BS2';
        ub2.acctInputOctets = 5678;
        ub2.acctOutputOctets = 9876;
        
        List<SNG_UsageService.UsagePerBaseStationId> ubList1 = new List<SNG_UsageService.UsagePerBaseStationId>();
        ubList1.add(ub1);
        ubList1.add(ub2);
        
        String macAddress = '00a0bc112233';
        
        SNG_UsageService.UsageAndErrors u1 = new SNG_UsageService.UsageAndErrors();
        u1.startTime = DateTime.newInstance(2014, 1, 10, 1, 2, 3);
        u1.endTime = DateTime.newInstance(2014, 2, 10, 12, 23, 14);
        u1.firstProcessedEventTimestamp = DateTime.newInstance(2014, 1, 14, 17, 0, 9);  
        u1.lastProcessedEventTimestamp = DateTime.newInstance(2014, 2, 4, 6, 45, 13);
        u1.aggregateAcctInputOctets = ub1.acctInputOctets + ub2.acctInputOctets;
        u1.aggregateAcctOutputOctets = ub1.acctOutputOctets + ub2.acctOutputOctets;
        u1.usage = ubList1;
        u1.macAddress = macAddress;

        List<SNG_UsageService.UsageAndErrors> uaes = new List<SNG_UsageService.UsageAndErrors>();
        uaes.add(u1);
        
        SNG_UsageService.Response response = new SNG_UsageService.Response();
        response.status = 'success';
        response.error = 0;
        response.errorDetail = new List<String>();
        response.errorDetail.add('Hello World');
        response.errorDetail.add('Foo');
        
        List<List<SNG_UsageService.UsageAndErrors>> uaesListOfList = new List<List<SNG_UsageService.UsageAndErrors>>();
        uaesListOfList.add(uaes);
        
        response.data = uaesListOfList;
        
        Long expectedAggUploadUsage = u1.aggregateAcctOutputOctets;
        Long expectedAggDownloadUsage = u1.aggregateAcctInputOctets;
        Long expectedAggTotalUsage = expectedAggUploadUsage + expectedAggDownloadUsage;
        
        DateTime startDate1 = u1.startTime;
        DateTime endDate1 = u1.endTime;
        SNG_ModemUsageDate mud1 = new SNG_ModemUsageDate('00:a0:bc:11:22:33', startDate1, endDate1);
        
        String SERVICE_PLAN_1 = 'SP-0001';      
        SNG_REST_ModemUsage.ServicePlanInfo sp1 = new SNG_REST_ModemUsage.ServicePlanInfo(SERVICE_PLAN_1, mud1);

        DateTime startDate2 = u1.endTime.addDays(1);
        DateTime endDate2 = startDate2.addDays(1);
        SNG_ModemUsageDate mud2 = new SNG_ModemUsageDate('00:a0:bc:11:22:33', startDate2, endDate2);
        
        String SERVICE_PLAN_2 = 'SP-0002';      
        SNG_REST_ModemUsage.ServicePlanInfo sp2 = new SNG_REST_ModemUsage.ServicePlanInfo(SERVICE_PLAN_2, mud2);
        
        List<SNG_REST_ModemUsage.ServicePlanInfo> servicePlans = new List<SNG_REST_ModemUsage.ServicePlanInfo>();
        servicePlans.add(sp1);
        servicePlans.add(sp2);
        
        SNG_REST_ModemUsageOutput output = SNG_REST_ModemUsageOutputBuilder.build(macAddress, response, servicePlans);
        System.debug(output);
        
        System.assertEquals(macAddress, output.macAddress);
        System.assertEquals(expectedAggUploadUsage, output.uploadUsage);
        System.assertEquals(expectedAggDownloadUsage, output.downloadUsage);
        System.assertEquals(expectedAggTotalUsage, output.totalUsage);
        System.assertEquals(2, output.items.size());
            
        SNG_REST_ModemUsageOutput.ServicePlanUsageData spud = (SNG_REST_ModemUsageOutput.ServicePlanUsageData)output.items.get(0);
        System.assertEquals(SERVICE_PLAN_1,  spud.servicePlanId);
        System.assertEquals(u1.aggregateAcctOutputOctets,  spud.uploadUsage);
        System.assertEquals(u1.aggregateAcctInputOctets, spud.downloadUsage);

        spud = (SNG_REST_ModemUsageOutput.ServicePlanUsageData)output.items.get(1);
        System.assertEquals(SERVICE_PLAN_2,  spud.servicePlanId);
        System.assertEquals(0,  spud.uploadUsage);
        System.assertEquals(0,  spud.downloadUsage);
    }
    
    //**********************************************************
    // TEST SNG_REST_ModemUsageApi 
    //**********************************************************
    static testMethod void testGetNoParameters()
    {
         SNG_MockCustomSettings.initialize();
        
        //create mac address
        Account account = SNG_TestUtilities.insertAccount('Red Cross');
        ServicePlan__c servicePlan = SNG_TestUtilities.insertServicePlan(account, true);
        Modem__c modem = SNG_TestUtilities.insertEquipment('Terminal1', 
                                                           SNG_MockUsageServiceHttpCallout.SUNNY_DAY_MAC_ADDRESS_SINGLE,
                                                           account,
                                                           true);
                                                           
        ModemServicePlan__c msp = SNG_TestUtilities.insertModemServicePlan(modem, servicePlan);
        
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new SNG_MockUsageServiceHttpCallout());
        
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        
        req.requestURI = '/modem/' + SNG_MockUsageServiceHttpCallout.SUNNY_DAY_MAC_ADDRESS_SINGLE + '/usage';
        req.resourcePath = '/modem/*/usage';
        req.httpMethod = 'POST';
        
        RestContext.request = req;
        RestContext.response = res;

        SNG_REST_JsonResponse response = SNG_REST_ModemUsageApi.get();

        SNG_REST_JsonResponse expectedOutput = new SNG_REST_JsonResponse(SNGHttpUtilities.Status.INPUT_VALIDATION_ERROR, 
                                                                         SNG_REST_Error.SubCode.SALESFORCE_GENERATED_ERROR, 
                                                                         SNG_REST_Error.MISSING_START_DATE, 
                                                                         null);
        System.assertEquals(expectedOutput, response);

        //--------------------------------------------------------------------------
        // MAC address with colons removed.
        //--------------------------------------------------------------------------
        String noColonMacAddress = SNG_MockUsageServiceHttpCallout.SUNNY_DAY_MAC_ADDRESS_SINGLE.replace( ':', '');

        req.requestURI = '/modem/' + noColonMacAddress + '/usage';
        req.resourcePath = '/modem/*/usage';
        req.httpMethod = 'POST';
        
        RestContext.request = req;
        RestContext.response = res;
        
        response = SNG_REST_ModemUsageApi.get();
        System.assertEquals(expectedOutput, response);         // no change to response.

        //------------------------------------------------------------------------
        // MAC address URL encoded.
        //------------------------------------------------------------------------
        String urlEncodedMacAddress = EncodingUtil.urlEncode(SNG_MockUsageServiceHttpCallout.SUNNY_DAY_MAC_ADDRESS_SINGLE, 'UTF-8');

        req.requestURI = '/modem/' + urlEncodedMacAddress + '/usage';
        req.resourcePath = '/modem/*/usage';
        req.httpMethod = 'POST';
        
        response = SNG_REST_ModemUsageApi.get();
        System.assertEquals(expectedOutput, response);         // no change to response.

        Test.stopTest();        
    }
    

     static testMethod void testSunnyDay() 
     { 
        SNG_MockCustomSettings.initialize();
        
        // Client input
        String macAddress = SNG_MockUsageServiceHttpCallout.SUNNY_DAY_MAC_ADDRESS_NO_DATA;
        String queryStartDate = '2014-08-15';
        String queryEndDate = '2014-10-05';
        
        // Build Account, Terminal, and Modem object 
        Account account = SNG_TestUtilities.insertAccount('testAccount');
        Terminal__c terminal = SNG_TestUtilities.insertTerminal(account, '11111', '1234561');
        Modem__c modem = SNG_TestUtilities.insertModem(account, '11111', macAddress, '123', terminal);
        
        // Build Service Plans
        Product2 servicePlanType = SNG_TestUtilities.insertServicePlanType(true);
        ServicePlan__c servicePlan_1 = SNG_TestUtilities.insertServicePlan(account, servicePlanType, 
                                                                            Date.valueOf('2014-04-01'), Date.valueOf('2014-12-30'));
        
        servicePlan_1 = [SELECT Name, Id, StartDate__c, EndDate__c FROM ServicePlan__c WHERE Id = :servicePlan_1.Id];
        
        // Build Modem Service Plans
        ModemServicePlan__c msp1_inRange = new ModemServicePlan__c(); 
        msp1_inRange.Modem__c = modem.Id;
        msp1_inRange.Modem__r = modem;
        msp1_inRange.ServicePlan__c = servicePlan_1.Id;
        msp1_inRange.ServicePlan__r = servicePlan_1;
        msp1_inRange.StartDate__c = Date.valueOf('2014-09-01');
        msp1_inRange.EndDate__c = Date.valueOf('2014-10-01');
        insert msp1_inRange;
        
        // MSP is out of range should not be included in query
        ModemServicePlan__c msp2_outOfRange = new ModemServicePlan__c();
        msp2_outOfRange.Modem__c = modem.Id;
        msp2_outOfRange.Modem__r = modem;
        msp2_outOfRange.ServicePlan__c = servicePlan_1.Id;
        msp2_outOfRange.ServicePlan__r = servicePlan_1;
        msp2_outOfRange.StartDate__c = Date.valueOf('2014-07-01');
        msp2_outOfRange.EndDate__c = Date.valueOf('2014-08-10');
        insert msp2_outOfRange;
        
        // Build the RestContext Request
        RestRequest req = new RestRequest();
        req.requestURI = '/modem/' + macAddress + '/usage';
        req.resourcePath = '/modem/*/usage';
        req.addParameter(START_DATE_PARAM, queryStartDate);
        req.addParameter(END_DATE_PARAM, queryEndDate);
        
        RestResponse res = new RestResponse();
        
        RestContext.request = req;
        RestContext.response = res;
        
        Test.startTest();
        // Set mock callout class
        Test.setMock(HttpCalloutMock.class, new SNG_MockUsageServiceHttpCallout());
        
        SNG_REST_JsonResponse response = SNG_REST_ModemUsageApi.get();
        
        // Create expected SNG_REST_JsonResponse to compare against
        SNG_REST_ModemUsageOutput.ServicePlanUsageData item = new SNG_REST_ModemUsageOutput.ServicePlanUsageData(servicePlan_1.Name, 0, 0);
        List<SNG_REST_ModemUsageOutput.ServicePlanUsageData> items = new List<SNG_REST_ModemUsageOutput.ServicePlanUsageData>();
        items.add(item); 
           
        SNG_REST_ModemUsageOutput expectedData = new SNG_REST_ModemUsageOutput(items, 
                                                                               SNG_MockUsageServiceHttpCallout.SUNNY_DAY_MAC_ADDRESS_NO_DATA);

        
        SNG_REST_JsonResponse expectedResponse = new SNG_REST_JsonResponse(SNGHttpUtilities.Status.OK, null, null, expectedData);
        System.assertEquals(expectedResponse, response);
        Test.stopTest();
    }
    
    static testMethod void testFailureUsageServiceDown() { 
        
        SNG_MockCustomSettings.initialize();
        
        // Client input
        String macAddress = SNG_MockUsageServiceHttpCallout.HTTP_STATUS_FAILURE_MAC_ADDRESS;
        String queryStartDate = '2014-08-15';
        String queryEndDate = '2014-10-05';
        
        // Build Account, Terminal, and Modem object 
        Account account = SNG_TestUtilities.insertAccount('testAccount');
        Terminal__c terminal = SNG_TestUtilities.insertTerminal(account, '11111', '1234561');
        Modem__c modem = SNG_TestUtilities.insertModem(account, '11111', macAddress, '123', terminal);
        
        // Build Service Plans
        Product2 servicePlanType = SNG_TestUtilities.insertServicePlanType(true);
        ServicePlan__c servicePlan_1 = SNG_TestUtilities.insertServicePlan(account, servicePlanType, 
                                                                            Date.valueOf('2014-04-01'), Date.valueOf('2014-12-30'));
                                                                            
        servicePlan_1 = [SELECT Name, Id, StartDate__c, EndDate__c FROM ServicePlan__c WHERE Id = :servicePlan_1.Id];
        
        // Build Modem Service Plans
        ModemServicePlan__c msp1_inRange = new ModemServicePlan__c(); 
        msp1_inRange.Modem__c = modem.Id;
        msp1_inRange.Modem__r = modem;
        msp1_inRange.ServicePlan__c = servicePlan_1.Id;
        msp1_inRange.ServicePlan__r = servicePlan_1;
        msp1_inRange.StartDate__c = Date.valueOf('2014-09-01');
        msp1_inRange.EndDate__c = Date.valueOf('2014-10-01');
        insert msp1_inRange;
        
        RestRequest req = new RestRequest(); 
        req.requestURI = '/modem/' + macAddress + '/usage';
        req.resourcePath = '/modem/*/usage';
        req.addParameter(START_DATE_PARAM, queryStartDate);
        req.addParameter(END_DATE_PARAM, queryEndDate);
        
        RestResponse res = new RestResponse();
        
        RestContext.request = req;
        RestContext.response = res;
        
        // Need Test.startTest() cannot make any callouts after a DML statement within the same transaction. 
        // This is to ensure that the DML transaction is completed before the Web Service/or any callout occurs
        // Can't make callouts with pending transactions in the request context
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new SNG_MockUsageServiceHttpCallout());
        
        SNG_REST_JsonResponse response = SNG_REST_ModemUsageApi.get();
        
        SNG_REST_JsonResponse expectedResponse = new SNG_REST_JsonResponse(SNGHttpUtilities.Status.SERVER_ERROR, 
                                                                           SNG_REST_Error.SubCode.WEBSERVICE_GENERATED_ERROR, 
                                                                           SNG_REST_Error.GENERIC_WEBSERVICE_ERROR, 
                                                                           null);
        System.assertEquals(expectedResponse, response);
    }
    
    static testMethod void testFailureNoModemServicePlans() 
    { 
        // Client Input
        String validMacAddress = '00:a0:bc:11:22:33';
        String startDate = '2014-04-01';
        String endDate = '2014-05-01';
        
        // Insert modem  
        Account account = SNG_TestUtilities.insertAccount('testAccount');
        Modem__c modem = SNG_TestUtilities.insertModem(validMacAddress, '111111', false);
        
        RestRequest req = new RestRequest();
        req.requestURI = '/modem/' + validMacAddress + '/usage';
        req.resourcePath = '/modem/*/usage';
        req.addParameter(START_DATE_PARAM, startDate);
        req.addParameter(END_DATE_PARAM, endDate);
        
        RestResponse res = new RestResponse();
        
        RestContext.request = req;
        RestContext.response = res;
        
        SNG_REST_JsonResponse response = SNG_REST_ModemUsageApi.get();
        
        SNG_REST_JsonResponse expectedResponse = new SNG_REST_JsonResponse(SNGHttpUtilities.Status.ZERO_RESULTS, 
                                                                           SNG_REST_Error.SubCode.SALESFORCE_GENERATED_ERROR, 
                                                                           SNG_REST_ModemUsage.MODEM_NOT_ACTIVE, 
                                                                           null);
        System.assertEquals(expectedResponse, response);
    }

        
    //**********************************************************
    // TEST SNG_REST_MacAddress
    //**********************************************************
    private static final String REST_RES_URL_START = '/terminal/';
    private static final String REST_RESL_URL_END = '/mac-address';
    private static final String REST_RES_PLURAL_URL = 'terminals/mac-address';
    private static final String RESOURCE_PATH_PREFIX = '/services/apexrest';
    private static final String RESOURCE_PATH = RESOURCE_PATH_PREFIX + REST_RES_URL_START + '*' + REST_RESL_URL_END;
    private static final String PLURAL_RESOURCE_PATH = RESOURCE_PATH_PREFIX + REST_RES_PLURAL_URL;

    private static testMethod void validTerminalIdNoTerminalObj() {
        
        // Create RestRequest object
        RestRequest req = new RestRequest();
        
        // Set RestContext's request to the new object since they are null originally 
        // There is no RestContext set since this method is not called through a Rest Request
        RestContext.request = req;
                
        // set the request URL
        String terminalId = 'T0000';
        RestContext.request.requestURI = REST_RES_URL_START + terminalId + REST_RESL_URL_END;
        RestContext.request.resourcePath = RESOURCE_PATH;
        
        // set the request method
        RestContext.request.httpMethod = 'GET';
        
        String response = JSON.serialize(SNG_REST_MacAddressApi.getMacAddress());
        
        // verify the response is correct
        jsonVerifier(response, 'ZERO_RESULTS', 1001, SNG_REST_Error.IDS_INVALID, 'T0000', 'null');      
    }
    
    private static testMethod void validTerminalIdNoModemObj() { 

        SNG_MockCustomSettings.initialize();

        RestRequest req = new RestRequest();  

        RestContext.request = req;

        // Create terminal object
        Account account = SNG_TestUtilities.insertAccount('testAccount'); 
        Terminal__c terminal = SNG_TestUtilities.insertTerminal(account, '1111', '1234561');
        
        terminal = [SELECT Name FROM Terminal__c WHERE SerialNumber__c = '1111'];       
        
        String terminalId = terminal.Name; 
        
        // Set the RestContext's request object 
        RestContext.request.requestURI =  REST_RES_URL_START + terminalId + REST_RESL_URL_END;
        RestContext.request.resourcePath = RESOURCE_PATH;
        RestContext.request.httpMethod = 'GET'; 
        
        String response = JSON.serialize(SNG_REST_MacAddressApi.getMacAddress());
        
        jsonVerifier(response, 'OK', 0, 'null', 
                        terminalId, 'null');
    }
    
    private static testMethod void validTerminalIdResult() { 
        
        SNG_MockCustomSettings.initialize();

        RestRequest req = new RestRequest();
        
        RestContext.request = req;
        
        // Create a Terminal with a modem
        Account account = SNG_TestUtilities.insertAccount('testAccount'); 
        Terminal__c terminal = SNG_TestUtilities.insertTerminal(account, '1111', '1234561');
        Modem__c modem = SNG_TestUtilities.insertModem(account, '0000', '00:a0:bc:26:14:9f', '123', terminal);
        
        terminal = [SELECT Name FROM Terminal__c WHERE SerialNumber__c = '1111'];  
        
        // Set the REST request after getting new Terminal name
        String terminalId = terminal.Name; 
        RestContext.request.requestURI = REST_RES_URL_START + terminalId + REST_RESL_URL_END;
        RestContext.request.resourcePath = RESOURCE_PATH;
            
        // Set the REST request method
        RestContext.request.httpMethod = 'GET';
        
        String response = JSON.serialize(SNG_REST_MacAddressApi.getMacAddress());
        
        jsonVerifier(response, 'OK', 0, 'null', terminalId, '00:a0:bc:26:14:9f');
    }
    
    private static testMethod void validTerminalIdsResult() {

        SNG_MockCustomSettings.initialize();

        RestRequest req = new RestRequest();
        
        RestContext.request = req;
        
        // Create a Terminal with a modem
        Account account = SNG_TestUtilities.insertAccount('testAccount'); 
        Terminal__c[] terminals = new Terminal__c[] { SNG_TestUtilities.insertTerminal(account, '1111', '1234561'), SNG_TestUtilities.insertTerminal(account, '2222', '1234561') };
        Modem__c[] modems = new Modem__c[] { SNG_TestUtilities.insertModem(account, '0000', '00:a0:bc:26:14:9f', '123', terminals[0]), 
                                             SNG_TestUtilities.insertModem(account, '3333', '00:a0:bc:26:14:9e', '456', terminals[1]) };
        
        terminals[0] = [SELECT Name FROM Terminal__c WHERE SerialNumber__c = '1111'];
        terminals[1] = [SELECT Name FROM Terminal__c WHERE SerialNumber__c = '2222'];
        
        // Set the REST request after getting new Terminal name
        String[] terminalIds = new String[] { terminals[0].Name, terminals[1].Name }; 
        RestContext.request.requestURI = REST_RES_PLURAL_URL + '?ids=' + terminalIds[0] + ',' + terminalIds[1];
        RestContext.request.resourcePath = PLURAL_RESOURCE_PATH;
            
        // Set the REST request method
        RestContext.request.httpMethod = 'GET';
        
        final SNG_REST_JsonResponse response = SNG_REST_MacAddressesApi.getMacAddresses();

        final SNG_REST_IJsonResponseData[] expectedResponseCollection = new SNG_REST_TerminalIdMacAddressOutput[] {
            new SNG_REST_TerminalidMacAddressOutput(terminalIds[1], modems[1].Name),
            new SNG_REST_TerminalidMacAddressOutput(terminalIds[0], modems[0].Name)
        };

        final SNG_REST_JsonResponse expectedResponse = new SNG_REST_JsonResponse(
            new SNG_REST_Response(SNGHttpUtilities.Status.OK, null, null, new SNG_REST_CollectionOutput(expectedResponseCollection)));

        verifyPluralResponse(expectedResponse, response);
    }
    
    private static testMethod void invalidTerminalIdBadId() { 
        
        RestRequest req = new RestRequest();
        
        RestContext.request = req;
        
        // Set the REST request method
        RestContext.request.httpMethod = 'GET'; 
        
        String badTerminalId_1 = 'T01000';
        String badTerminalId_2 = 'T1'; 
        String badTerminalId_3 = 'P1000'; 
        String badTerminalId_4 = 'TT013';
        String badTerminalId_5 = '09001';
        String badTerminalId_6 = 'T'; 
        
        RestContext.request.requestURI = REST_RES_URL_START +  badTerminalId_1 + REST_RESL_URL_END;
        RestContext.request.resourcePath = RESOURCE_PATH;
        String response = JSON.serialize(SNG_REST_MacAddressApi.getMacAddress());
        jsonVerifier(response, 'INPUT_VALIDATION_ERROR', 4001, SNG_REST_Error.INPUT_INVALID_FORMAT, 'T01000', 'null'); 
        
        RestContext.request.requestURI = REST_RES_URL_START +  badTerminalId_2 + REST_RESL_URL_END; 
        response = JSON.serialize(SNG_REST_MacAddressApi.getMacAddress());
        jsonVerifier(response, 'INPUT_VALIDATION_ERROR', 4001, SNG_REST_Error.INPUT_INVALID_FORMAT, 'T1', 'null');   
        
        RestContext.request.requestURI = REST_RES_URL_START +  badTerminalId_3 + REST_RESL_URL_END; 
        response = JSON.serialize(SNG_REST_MacAddressApi.getMacAddress());
        jsonVerifier(response, 'INPUT_VALIDATION_ERROR', 4001, SNG_REST_Error.INPUT_INVALID_FORMAT,'P1000', 'null');

        RestContext.request.requestURI = REST_RES_URL_START +  badTerminalId_4 + REST_RESL_URL_END; 
        response = JSON.serialize(SNG_REST_MacAddressApi.getMacAddress());
        jsonVerifier(response, 'INPUT_VALIDATION_ERROR', 4001, SNG_REST_Error.INPUT_INVALID_FORMAT, 'TT013', 'null');
        
        RestContext.request.requestURI = REST_RES_URL_START +  badTerminalId_5 + REST_RESL_URL_END;  
        response = JSON.serialize(SNG_REST_MacAddressApi.getMacAddress());
        jsonVerifier(response, 'INPUT_VALIDATION_ERROR', 4001, SNG_REST_Error.INPUT_INVALID_FORMAT, '09001', 'null');

        RestContext.request.requestURI = REST_RES_URL_START +  badTerminalId_6 + REST_RESL_URL_END; 
        response = JSON.serialize(SNG_REST_MacAddressApi.getMacAddress());
        jsonVerifier(response, 'INPUT_VALIDATION_ERROR', 4001, SNG_REST_Error.INPUT_INVALID_FORMAT, 'T', 'null');                    
    }
    
    // Verify JSON contents are correct
    private static void jsonVerifier(final String responseBody, final String statusExpected, final Integer errorCodeExpected, 
                                        final String errorMessageExpected, final String termIdExpected, final String macAddrExpected) { 
        
        // Create a parser to parse the response
        JSONParser parser = JSON.createParser(responseBody);
        
        while (parser.nextToken() != null) { 
                    
            if (parser.getCurrentName() == 'status')
            {
                // move to the value token
                parser.nextToken(); 
                String status = parser.getText(); 
                System.assertEquals(statusExpected, status);
            }
            else if (parser.getCurrentName() == 'errorCode') 
            { 
                parser.nextToken(); 
                Integer errorCode = parser.getIntegerValue(); 
                System.assertEquals(errorCodeExpected, errorCode);  
            }           
            else if (parser.getCurrentName() == 'errorMessage') 
            { 
                parser.nextToken();
                String errorMessage = parser.getText();
                System.assertEquals( errorMessageExpected, errorMessage); 
            }
            else if (parser.getCurrentName() == 'data')
            { 
                while (parser.nextToken() != null)
                { 
                    if (parser.getCurrentName() == 'terminalId')
                    { 
                        parser.nextToken(); 
                        String termId = parser.getText(); 
                        System.assertEquals(termIdExpected, termId); 
                    }
                    else if (parser.getCurrentName() == 'macAddress') 
                    { 
                        parser.nextToken(); 
                        String macAddress = parser.getText(); 
                        System.assertEquals(macAddrExpected, macAddress); 
                    }
                }
            }// end of iterating through data object in json
        }// end of iterating through json 
    }

    private static void verifyPluralResponse(final SNG_REST_JsonResponse expected, final SNG_REST_JsonResponse actual) {
        System.assertEquals(expected.status, actual.status);
        System.assertEquals(expected.errorCode, actual.errorCode);
        System.assertEquals(expected.errorMessage, actual.errorMessage);
        if (expected.data == actual.data) {
            System.assert(true);
        } else {
            // expected.data didn't exactly match actual.data, but maybe just the order is different.
            // Do an unordered comparison...

            System.debug('Verifying unordered response data collection');

            if (actual.data instanceof SNG_REST_CollectionOutput && expected.data instanceof SNG_REST_CollectionOutput) {
                final SNG_REST_CollectionOutput expectedData = (SNG_REST_CollectionOutput) expected.data;
                final SNG_REST_CollectionOutput actualData = (SNG_REST_CollectionOutput) actual.data;

                final Set<Object> expectedDataSet = new Set<Object>();
                for (Object item : expectedData.items) {
                    expectedDataSet.add(item);
                }

                final Set<Object> actualDataSet = new Set<Object>();
                for (Object item : actualData.items) {
                    actualDataSet.add(item);
                }

                System.assertEquals(expectedDataSet, actualDataSet);
            } else {
                // Data types do not match.
                System.assert(false);
            }
        }
    }

    //**********************************************************
    // TEST SNG_REST_JsonResponse 
    //**********************************************************
    static testMethod void testJsonResponseStructureOK()
    {
        SNG_REST_JsonResponse response = new SNG_REST_JsonResponse(SNGHttpUtilities.Status.OK, null, null, null);
        String jsonFormat = JSON.serialize(response);
        System.assertEquals('{"status":"OK","errorMessage":null,"errorCode":0,"data":null}', jsonFormat);
    }
    
    static testMethod void testJsonResponseStructureNotOK() 
    {
        SNG_REST_JsonResponse response = new SNG_REST_JsonResponse(SNGHttpUtilities.Status.OK_WITH_ERRORS, SNG_REST_Error.SubCode.SALESFORCE_GENERATED_ERROR, 'With errors', null);
        String jsonFormat = JSON.serialize(response);
        System.assertEquals('{"status":"OK_WITH_ERRORS","errorMessage":"With errors","errorCode":5001,"data":null}', jsonFormat);
    }

    //**********************************************************
    // TEST SNG_REST_ErrorUnitTest
    //**********************************************************
    static testMethod void testGetErrorCodeSunnyDay() {
        // TO DO: implement unit test
        
        System.assertEquals(1001, SNG_REST_Error.getErrorCode(SNGHttpUtilities.Status.ZERO_RESULTS, SNG_REST_Error.SubCode.SALESFORCE_GENERATED_ERROR));
        System.assertEquals(1002, SNG_REST_Error.getErrorCode(SNGHttpUtilities.Status.ZERO_RESULTS, SNG_REST_Error.SubCode.WEBSERVICE_GENERATED_ERROR));
        
        System.assertEquals(2001, SNG_REST_Error.getErrorCode(SNGHttpUtilities.Status.ACCESS_DENIED, SNG_REST_Error.SubCode.SALESFORCE_GENERATED_ERROR));
        System.assertEquals(2002, SNG_REST_Error.getErrorCode(SNGHttpUtilities.Status.ACCESS_DENIED, SNG_REST_Error.SubCode.WEBSERVICE_GENERATED_ERROR));
        
        System.assertEquals(3001, SNG_REST_Error.getErrorCode(SNGHttpUtilities.Status.SERVER_ERROR, SNG_REST_Error.SubCode.SALESFORCE_GENERATED_ERROR));
        System.assertEquals(3002, SNG_REST_Error.getErrorCode(SNGHttpUtilities.Status.SERVER_ERROR, SNG_REST_Error.SubCode.WEBSERVICE_GENERATED_ERROR));
        
        System.assertEquals(4001, SNG_REST_Error.getErrorCode(SNGHttpUtilities.Status.INPUT_VALIDATION_ERROR, SNG_REST_Error.SubCode.SALESFORCE_GENERATED_ERROR));
        System.assertEquals(4002, SNG_REST_Error.getErrorCode(SNGHttpUtilities.Status.INPUT_VALIDATION_ERROR, SNG_REST_Error.SubCode.WEBSERVICE_GENERATED_ERROR));
        
        System.assertEquals(5001, SNG_REST_Error.getErrorCode(SNGHttpUtilities.Status.OK_WITH_ERRORS, SNG_REST_Error.SubCode.SALESFORCE_GENERATED_ERROR));
        System.assertEquals(5002, SNG_REST_Error.getErrorCode(SNGHttpUtilities.Status.OK_WITH_ERRORS, SNG_REST_Error.SubCode.WEBSERVICE_GENERATED_ERROR));
        
        System.assertEquals(0, SNG_REST_Error.getErrorCode(SNGHttpUtilities.Status.OK, SNG_REST_Error.SubCode.SALESFORCE_GENERATED_ERROR));
        System.assertEquals(0, SNG_REST_Error.getErrorCode(SNGHttpUtilities.Status.OK, SNG_REST_Error.SubCode.WEBSERVICE_GENERATED_ERROR));
    }
    
    static testMethod void testEquals()
    {
        SNG_REST_Error.StatusAndSubCode scTarget = new SNG_REST_Error.StatusAndSubCode(SNGHttpUtilities.Status.OK, SNG_REST_Error.SubCode.SALESFORCE_GENERATED_ERROR);
        SNG_REST_Error.StatusAndSubCode scMismatch1 = new SNG_REST_Error.StatusAndSubCode(SNGHttpUtilities.Status.OK, SNG_REST_Error.SubCode.WEBSERVICE_GENERATED_ERROR);
        SNG_REST_Error.StatusAndSubCode scMismatch2 = new SNG_REST_Error.StatusAndSubCode(SNGHttpUtilities.Status.OK_WITH_ERRORS, SNG_REST_Error.SubCode.SALESFORCE_GENERATED_ERROR);
        SNG_REST_Error.StatusAndSubCode scMatch = new SNG_REST_Error.StatusAndSubCode(SNGHttpUtilities.Status.OK, SNG_REST_Error.SubCode.SALESFORCE_GENERATED_ERROR);
        
        System.assertEquals(false, scTarget.equals(scMismatch1));
        System.assertEquals(false, scTarget.equals(scMismatch2));
        System.assertEquals(true, scTarget.equals(scMatch));
    }
        
    static testMethod void testHashcode()
    {
        SNG_REST_Error.StatusAndSubCode scTarget = new SNG_REST_Error.StatusAndSubCode(SNGHttpUtilities.Status.OK, SNG_REST_Error.SubCode.SALESFORCE_GENERATED_ERROR);
        
        System.assertEquals(31 * scTarget.status.hashCode() ^ scTarget.subCode.hashCode(), scTarget.hashCode());
    }
    
    static testMethod void testGetErrorCodeNullValues()
    {
        System.assertEquals(0, SNG_REST_Error.getErrorCode(null, null));
    }

    //**********************************************************
    // TEST SNG_REST_NameCollection 
    //**********************************************************
    static testMethod void invalidObjectName() { 
        
        SfIdChecker idValidator = new SfIdChecker('[Tt]'); 
        
        SNG_REST_NameCollection obj = new SNG_REST_NameCollection('Term__c', idValidator); 
        
        List<String> termNames = new List<String> {'T0000', 'T0001'}; 
        
        // get objects from list
        try {
            List<Terminal__c> termList = obj.getSObjects(termNames);
            System.assert(false);
        }
        catch(SNG_Exception se) { 
            System.assert(true);
        }
        
        // get all objects
        try { 
            List<Terminal__c> termList = obj.getSobjects(); 
            System.assert(false); 
        }
        catch(SNG_Exception se) { 
            System.assert(true); 
        }
    }
    
    static testMethod void constructorValidation() {
        
        SfIdChecker idValidator = new SfIdChecker('[Ss][Pp]'); 
        
        SNG_REST_NameCollection validObj = new SNG_REST_NameCollection('Modem__c', idValidator); 
        
        // Test if validator is null 
        idValidator = null; 
        try { 
            SNG_REST_NameCollection obj = new SNG_REST_NameCollection('Modem__c', idValidator);
            System.assert(false);
        }
        catch (Exception se) { 
            System.assert(true); 
        } 
    }
    
    
    static testMethod void validObjects() { 
        
        SNG_MockCustomSettings.initialize();
        
        List<ServicePlan__c> retrievedSps; 
        
        SfIdChecker spValidator = new SfIdChecker('[Ss][Pp]'); 
        
        SNG_REST_NameCollection obj = new SNG_REST_NameCollection('ServicePlan__c', spValidator); 
        
        List<ServicePlan__c> spList =  SNG_TestUtilities.insertListOfServicePlans(2); 
        
        String sp1Name = spList[0].SalesOrder__c;
        String sp2Name = spList[1].SalesOrder__c;   
        
        ServicePlan__c servicePlan1 = [SELECT Name FROM ServicePlan__c WHERE SalesOrder__c = :sp1Name];
        ServicePlan__c servicePlan2 = [SELECT Name FROM ServicePlan__c WHERE SalesOrder__c = :sp2Name];
        
        List<String> servicePlanIds = new List<String> {servicePlan1.Name, servicePlan2.Name};
        
        try { 
            retrievedSps = obj.getSobjects(servicePlanIds);
        } 
        catch(SNG_Exception se) { 
            System.assert(false); 
        }
        
        for (integer i = 0; i < retrievedSps.size(); i++) { 
            System.assertEquals(servicePlanIds[i], retrievedSps[i].Name);
        }
        
        try { 
            retrievedSps = obj.getSObjects(); 
        }      
        catch(SNG_Exception se) { 
            System.assert(false); 
        }
        
        for (integer i = 0; i < retrievedSps.size(); i++) { 
            System.assertEquals(servicePlanIds[i], retrievedSps[i].Name); 
        }
    }

    //**********************************************************
    // TEST SNG_REST_QueryAllServicePlans 
    //**********************************************************
    private static testMethod void testQueryAllServicePlans() 
    {
        SNG_MockCustomSettings.initialize();

        // getZeroResults
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse(); 
        req.requestURI = 'https://viasat--deveecp.cs30.my.salesforce.com/services/apexrest/terminals/ids';
        req.httpMethod = 'GET'; 
        
        // RestContext contains the RestRequest and RestResponse objects in REST methods
        RestContext.request = req; 
        RestContext.response = res; 
        
        SNG_REST_JSONResponse response = SNG_REST_QueryAllServicePlans.get();         
        SNG_REST_JsonResponse expectedOutput = new SNG_REST_JsonResponse(SNGHttpUtilities.Status.ZERO_RESULTS,
                                                                         null, null, null);
        System.assert(response == expectedOutput);
    
        // getSunnyDay() 
        req = new RestRequest(); 
        res = new RestResponse(); 

        List<ServicePlan__c> spList = SNG_TestUtilities.insertListOfServicePlans(2);
        req.requestURI = '/terminals/ids';
        req.httpMethod = 'GET'; 
        
        // RestContext contains the RestRequest and RestResponse objects in REST methods
        RestContext.request = req; 
        RestContext.response = res; 
        
        response = SNG_REST_QueryAllServicePlans.get(); 
        
        String sp1Name = spList[0].SalesOrder__c;
        String sp2Name = spList[1].SalesOrder__c;
        
        ServicePlan__c servicePlan1 = [SELECT Name FROM ServicePlan__c WHERE SalesOrder__c = :sp1Name];
        ServicePlan__c servicePlan2 = [SELECT Name FROM ServicePlan__c WHERE SalesOrder__c = :sp2Name];
        
        List<String> expectedIds = new List<String>();
        expectedIds.add(servicePlan1.Name);
        expectedIds.add(servicePlan2.Name);
        
        
        expectedOutput = new SNG_REST_JsonResponse(SNGHttpUtilities.Status.OK,
                                                                         null,
                                                                         null,
                                                                         new SNG_REST_CollectionOutput(expectedIds));
        System.debug('Response: ' + response.toString());
        System.debug('Expected: ' + expectedOutput.toString());
        System.assert(response == expectedOutput);
    }
    
    // Filtering with all filtering parameters matching
    private static testMethod void filteringOkStatus() 
    {
        SNG_MockCustomSettings.initialize();

        // Insert service plan objects
        List<ServicePlan__c> spList = SNG_TestUtilities.insertListOfServicePlans(2); 
        
        String sp1Name = spList[0].SalesOrder__c;
        String sp2Name = spList[1].SalesOrder__c;       

        ServicePlan__c servicePlan1 = [SELECT Name FROM ServicePlan__c WHERE SalesOrder__c = :sp1Name];
        ServicePlan__c servicePlan2 = [SELECT Name FROM ServicePlan__c WHERE SalesOrder__c = :sp2Name];
        
        String idsParameter = servicePlan1.Name + ',' + servicePlan2.Name; 
        
        // Set RestContext.request and add in parameters
        RestContext.request = new RestRequest(); 
        RestContext.request.requestURI =  '/service-plans/ids'; 
        RestContext.request.httpMethod = 'GET';
        RestContext.request.addParameter('ids', idsParameter); 
        
        // Build the expected response
        List<String> items = new List<String> {servicePlan1.Name, ServicePlan2.Name}; 
        SNG_REST_CollectionOutput dataExpected = new SNG_REST_CollectionOutput(items);
        
        SNG_REST_JsonResponse expectedOutput = new SNG_REST_JsonResponse(SNGHttpUtilities.Status.OK, null, null, dataExpected);
        
        // Call API 
        SNG_REST_JsonResponse actualOutput = SNG_REST_QueryAllServicePlans.get(); 
        
        System.assertEquals(expectedOutput, actualOutput); 
    }

    private static testMethod void filterOkSomeErrorsStatus() {
        SNG_MockCustomSettings.initialize();

        // Filtering with some parameters matching actual objects. 
        List<ServicePlan__c> spList = SNG_TestUtilities.insertListOfServicePlans(1); 
        
        String sp1Name = spList[0].SalesOrder__c;   

        ServicePlan__c servicePlan1 = [SELECT Name FROM ServicePlan__c WHERE SalesOrder__c = :sp1Name];
        
        String idsParameter = servicePlan1.Name + ',' + 'SP-0002';
        
        // Set RestContext request and add in parameters
        RestContext.request = new RestRequest(); 
        RestContext.request.requestURI =  '/service-plans/ids'; 
        RestContext.request.httpMethod = 'GET';
        RestContext.request.addParameter('ids', idsParameter); 
        
        // Build the expected JsonResponse 
        List<String> items = new List<String> {servicePlan1.Name}; 
        SNG_REST_CollectionOutput dataExpected = new SNG_REST_CollectionOutput(items);
        SNG_Rest_JsonResponse expectedOutput = new SNG_REST_JsonResponse(SNGHttpUtilities.Status.OK_WITH_ERRORS, SNG_REST_Error.SubCode.SALESFORCE_GENERATED_ERROR, 
                                                                                SNG_REST_Error.IDS_INVALID, dataExpected); 
        SNG_REST_JsonResponse actualOutput = SNG_REST_QueryAllServicePlans.get();       
        System.assertEquals(expectedOutput, actualOutput); 
    
        //Filtering with incorrect input format
        RestContext.request = new RestRequest(); 
        RestContext.request.requestURI =  '/service-plans/ids'; 
        RestContext.request.addParameter('ids', 'ST-0001');
        
        // Build the expected response
        expectedOutput = new SNG_REST_JsonResponse(SNGHttpUtilities.Status.INPUT_VALIDATION_ERROR, SNG_REST_Error.SubCode.SALESFORCE_GENERATED_ERROR, 
                                                                            SNG_REST_Error.INPUT_INVALID_FORMAT, null);             
        actualOutput = SNG_REST_QueryAllServicePlans.get(); 
        System.assertEquals(expectedOutput, actualOutput);  
    }
    
    //**********************************************************
    // TEST SNG_REST_QueryAllModemMacAddrs
    //**********************************************************
    static testMethod void testQueryAllModemMacAddrs() {
        
        // No modems under user's account
        SNG_REST_JsonResponse response = SNG_REST_QueryAllModemMacAddresses.getModemMacAddresses();
        compareResponses(response, SNGHttpUtilities.Status.ZERO_RESULTS, null, null, null);
            
    
        // One modem found under user's account
        Account account = SNG_TestUtilities.insertAccount('TestAccount'); 
        Modem__c modem = SNG_TestUtilities.insertModem('00:a0:bc:00:00:01', '12345', false);
        
        response = SNG_REST_QueryAllModemMacAddresses.getModemMacAddresses();       
        System.debug('RT TEST = ' + response); 
        
        List<String> items = new List<String> {'00:a0:bc:00:00:01'};
        
        SNG_REST_CollectionOutput dataExpected = new SNG_REST_CollectionOutput(items);
        
        compareResponses(response, SNGHttpUtilities.Status.OK, null, null, dataExpected);       
    }
        
    // Test with filtering
    static testMethod void testWithfiltering() { 
        
        // 1. one valid modem, other modem not located
        Account account = SNG_TestUtilities.insertAccount('TestAccount'); 
        Modem__c modem = SNG_TestUtilities.insertModem('00:a0:bc:00:00:01', '12345', false);
        
        // Set RestContext.request and add in parameters
        RestContext.request = new RestRequest(); 
        RestContext.request.requestURI =  '/modems/ids'; 
        RestContext.request.addParameter('ids', '00:a0:bc:00:00:01,00:a0:bc:00:00:02'); 
        
        // Build the expected response
        List<String> items = new List<String> {'00:a0:bc:00:00:01'}; 
        SNG_REST_CollectionOutput dataExpected = new SNG_REST_CollectionOutput(items);
        
        SNG_REST_JsonResponse response = SNG_REST_QueryAllModemMacAddresses.getModemMacAddresses();
        
        compareResponses(response, SNGHttpUtilities.Status.OK_WITH_ERRORS, SNG_REST_Error.SubCode.SALESFORCE_GENERATED_ERROR, 
                            SNG_REST_Error.IDS_INVALID, dataExpected);      
    
        // 2. Test with filtering, incorrect input
        // Set RestContext.request and add in paramteres 
        RestContext.request = new RestRequest(); 
        RestContext.request.requestURI =  '/modems/ids'; 
        RestContext.request.addParameter('ids', '00:a0:bc:00:00:01,00:a0:bc:00:00:t');      
        
        // Build the expected response with incorrect input
        dataExpected = null;        
        response = SNG_REST_QueryAllModemMacAddresses.getModemMacAddresses();
        
        compareResponses(response, SNGHttpUtilities.Status.INPUT_VALIDATION_ERROR, SNG_REST_Error.SubCode.SALESFORCE_GENERATED_ERROR, 
                            SNG_REST_Error.INPUT_INVALID_FORMAT, dataExpected);                 
    }
    

    //**********************************************************
    // TEST SNG_REST_ServicePlanUsageApi
    //**********************************************************
    static testMethod void testGetNoParameters2()
    {
         SNG_MockCustomSettings.initialize();
        
        //create servicePlan
        Account account = SNG_TestUtilities.insertAccount('Red Cross');
        ServicePlan__c servicePlan = SNG_TestUtilities.insertServicePlan(account, true);
        Modem__c modem = SNG_TestUtilities.insertEquipment('Terminal1', 
                                                           SNG_MockUsageServiceHttpCallout.SUNNY_DAY_MAC_ADDRESS_SINGLE,
                                                           account,
                                                           true);
                                                           
        ModemServicePlan__c msp = SNG_TestUtilities.insertModemServicePlan(modem, servicePlan);
        
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new SNG_MockUsageServiceHttpCallout());
        
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        
        ServicePlan__c servicePlanObj = [SELECT Name From ServicePlan__c WHERE Id = :servicePlan.Id];
        String servicePlanId = servicePlanObj.Name;
        
        req.requestURI = '/service-plan/' + servicePlanId + '/usage';
        req.resourcePath = '/service-plan/*/usage';
        req.httpMethod = 'POST';
        
        RestContext.request = req;
        RestContext.response = res;
        
        SNG_REST_JsonResponse response = SNG_REST_ServicePlanUsageApi.get();

        SNG_REST_JsonResponse expectedOutput = new SNG_REST_JsonResponse(SNGHttpUtilities.Status.INPUT_VALIDATION_ERROR, 
                                                                         SNG_REST_Error.SubCode.SALESFORCE_GENERATED_ERROR, 
                                                                         SNG_REST_Error.MISSING_START_DATE, 
                                                                         null);
        System.assertEquals(expectedOutput, response);
        
        Test.stopTest();        
    }

    static testMethod void testGetSunnyDay() 
    {    
        SNG_MockCustomSettings.initialize();
        
        //create servicePlan
        Account account = SNG_TestUtilities.insertAccount('Red Cross');
        ServicePlan__c servicePlan = SNG_TestUtilities.insertServicePlan(account, true);
        Modem__c modem = SNG_TestUtilities.insertEquipment('Terminal1', 
                                                           SNG_MockUsageServiceHttpCallout.SUNNY_DAY_MAC_ADDRESS_SINGLE,
                                                           account,
                                                           true);
                                                           
        ModemServicePlan__c msp = SNG_TestUtilities.insertModemServicePlan(modem, servicePlan);
        
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new SNG_MockUsageServiceHttpCallout());
        
        DateTime startDate = SNG_DateUtils.todayGmt().toStartOfMonth();
        DateTime endDate = SNG_DateUtils.todayGmt().addMonths(1).addDays(-1);
    
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        
        ServicePlan__c servicePlanObj = [SELECT Name From ServicePlan__c WHERE Id = :servicePlan.Id];
        String servicePlanId = servicePlanObj.Name;
        
        req.requestURI = '/service-plan/' + servicePlanId + '/usage';
        req.resourcePath = '/service-plan/*/usage';
        req.addParameter('start-date', startDate.formatGmt('YYYY-MM-dd'));
        req.addParameter('end-date', endDate.formatGmt('YYYY-MM-dd'));
        
        req.httpMethod = 'POST';
        
        RestContext.request = req;
        RestContext.response = res;
        
        SNG_REST_JsonResponse response = SNG_REST_ServicePlanUsageApi.get();
       
        SNG_REST_ServicePlanUsageOutput.MacAddressUsageData expectedMaud =
             new SNG_REST_ServicePlanUsageOutput.MacAddressUsageData(SNG_MockUsageServiceHttpCallout.SUNNY_DAY_MAC_ADDRESS_SINGLE,
                                                                               SNG_MockUsageServiceHttpCallout.SINGLE_BSID_UPLOAD,
                                                                               SNG_MockUsageServiceHttpCallout.SINGLE_BSID_DOWNLOAD);
       
        List<SNG_REST_ServicePlanUsageOutput.MacAddressUsageData> expectedMauds = new List<SNG_REST_ServicePlanUsageOutput.MacAddressUsageData>();
        expectedMauds.add(expectedMaud);
        
        SNG_REST_ServicePlanUsageOutput expectedUsageOutput = new SNG_REST_ServicePlanUsageOutput(servicePlanId, expectedMauds);
       
          
        SNG_REST_JsonResponse expectedOutput = new SNG_REST_JsonResponse(SNGHttpUtilities.Status.OK, 
                                                                         SNG_REST_Error.SubCode.SALESFORCE_GENERATED_ERROR, 
                                                                         null, 
                                                                         expectedUsageOutput);
        System.assertEquals(expectedOutput, response);
        
        Test.stopTest();        
        
    }
    
    static testMethod void testWebServiceSunnyDayDoubleEntry2() 
    {
        SNG_MockCustomSettings.initialize();
        
        //create servicePlan
        Account account = SNG_TestUtilities.insertAccount('Red Cross');
        ServicePlan__c servicePlan = SNG_TestUtilities.insertServicePlan(account, true);
        Modem__c modem = SNG_TestUtilities.insertEquipment('Terminal1', SNG_MockUsageServiceHttpCallout.SUNNY_DAY_MAC_ADDRESS_DOUBLE_A,
                                                           account, 'sn0', true);
                                                           
        ModemServicePlan__c msp = SNG_TestUtilities.insertModemServicePlan(modem, servicePlan);
                
        Modem__c modem2 = SNG_TestUtilities.insertEquipment('Terminal2', SNG_MockUsageServiceHttpCallout.SUNNY_DAY_MAC_ADDRESS_DOUBLE_B,
                                                             account, 'sn1', true);
        ModemServicePlan__c msp2 = SNG_TestUtilities.insertModemServicePlan(modem2, servicePlan);
        
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new SNG_MockUsageServiceHttpCallout());
        
        DateTime startDate = SNG_DateUtils.todayGmt().toStartOfMonth();
        DateTime endDate = SNG_DateUtils.todayGmt().addMonths(1).addDays(-1);
    
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        
        ServicePlan__c servicePlanObj = [SELECT Name From ServicePlan__c WHERE Id = :servicePlan.Id];
        String servicePlanId = servicePlanObj.Name;
        
        String endDateStr = endDate.formatGmt('YYYY-MM-dd');
        String startDateStr = startDate.formatGmt('YYYY-MM-dd');
        Date startDateD = Date.valueOf(startDateStr);
        Date endDateD = Date.valueOf(endDateStr);
        
        List<ModemServicePlan__c> msps = [SELECT Modem__r.Name, StartDate__c, EndDate__c FROM ModemServicePlan__c 
                                          WHERE ServicePlan__r.Name = :servicePlanId AND
                                          StartDate__c <= :endDateD AND EndDate__c >= :startDateD];
        
        System.debug('MSP SIZE: ' + msps.size());
        
        req.requestURI = '/service-plan/' + servicePlanId + '/usage';
        req.resourcePath = '/service-plan/*/usage';
        req.addParameter('start-date', startDate.formatGmt('YYYY-MM-dd'));
        req.addParameter('end-date', endDate.formatGmt('YYYY-MM-dd'));
        
        req.httpMethod = 'POST';
        
        RestContext.request = req;
        RestContext.response = res;
        
        SNG_REST_JsonResponse response = SNG_REST_ServicePlanUsageApi.get();

        SNG_REST_ServicePlanUsageOutput.MacAddressUsageData expectedMaud1 =
             new SNG_REST_ServicePlanUsageOutput.MacAddressUsageData(SNG_MockUsageServiceHttpCallout.SUNNY_DAY_MAC_ADDRESS_DOUBLE_A,
                                                                               SNG_MockUsageServiceHttpCallout.DOUBLE_A_BSID_UPLOAD,
                                                                               SNG_MockUsageServiceHttpCallout.DOUBLE_A_BSID_DOWNLOAD);
       
        SNG_REST_ServicePlanUsageOutput.MacAddressUsageData expectedMaud2 =
             new SNG_REST_ServicePlanUsageOutput.MacAddressUsageData(SNG_MockUsageServiceHttpCallout.SUNNY_DAY_MAC_ADDRESS_DOUBLE_B,
                                                                               SNG_MockUsageServiceHttpCallout.DOUBLE_B_BSID_UPLOAD,
                                                                               SNG_MockUsageServiceHttpCallout.DOUBLE_B_BSID_DOWNLOAD);
       
        List<SNG_REST_ServicePlanUsageOutput.MacAddressUsageData> expectedMauds = new List<SNG_REST_ServicePlanUsageOutput.MacAddressUsageData>();
        expectedMauds.add(expectedMaud1);
        expectedMauds.add(expectedMaud2);
        
        SNG_REST_ServicePlanUsageOutput expectedUsageOutput = new SNG_REST_ServicePlanUsageOutput(servicePlanId, expectedMauds);
       
          
        SNG_REST_JsonResponse expectedOutput = new SNG_REST_JsonResponse(SNGHttpUtilities.Status.OK, 
                                                                         SNG_REST_Error.SubCode.SALESFORCE_GENERATED_ERROR, 
                                                                         null, 
                                                                         expectedUsageOutput);
        System.assertEquals(expectedOutput, response);
        
        Test.stopTest();
    }
    
    static testMethod void testGetFailureStatus() 
    {
        SNG_MockCustomSettings.initialize();
        
        //create servicePlan
        Account account = SNG_TestUtilities.insertAccount('Red Cross');
        ServicePlan__c servicePlan = SNG_TestUtilities.insertServicePlan(account, true);
        Modem__c modem = SNG_TestUtilities.insertEquipment('Terminal1', 
                                                           SNG_MockUsageServiceHttpCallout.STATUS_FAILURE_DATA_EMPTY_MAC_ADDRESS,
                                                           account,
                                                           true);
                                                           
        ModemServicePlan__c msp = SNG_TestUtilities.insertModemServicePlan(modem, servicePlan);
        
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new SNG_MockUsageServiceHttpCallout());
        
        DateTime startDate = SNG_DateUtils.todayGmt().toStartOfMonth();
        DateTime endDate = SNG_DateUtils.todayGmt().addMonths(1).addDays(-1);
    
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        
        ServicePlan__c servicePlanObj = [SELECT Name From ServicePlan__c WHERE Id = :servicePlan.Id];
        String servicePlanId = servicePlanObj.Name;
        
        req.requestURI = '/service-plan/' + servicePlanId + '/usage';
        req.resourcePath = '/service-plan/*/usage';
        req.addParameter('start-date', startDate.formatGmt('YYYY-MM-dd'));
        req.addParameter('end-date', endDate.formatGmt('YYYY-MM-dd'));
        
        req.httpMethod = 'POST';
        
        RestContext.request = req;
        RestContext.response = res;
        
        SNG_REST_JsonResponse response = SNG_REST_ServicePlanUsageApi.get();
        
        integer expectedErrorCode = SNG_REST_Error.getErrorCode(SNGHttpUtilities.Status.SERVER_ERROR, 
                                                                SNG_REST_Error.SubCode.WEBSERVICE_GENERATED_ERROR);
         
        System.assertEquals(SNGHttpUtilities.Status.SERVER_ERROR.name(), response.status);
        System.assertEquals(expectedErrorCode, response.errorCode);
        System.assertEquals(SNG_REST_ServicePlanUsage.USAGE_SERVICE_ERROR + servicePlanId, response.errorMessage);
        System.assertEquals(null, response.data);
        
        Test.stopTest();
    }
    
    static testMethod void testWebServiceMacAddressReturnInvalidFormat2()
    {
        SNG_MockCustomSettings.initialize();
        
        //create servicePlan
        Account account = SNG_TestUtilities.insertAccount('Red Cross');
        ServicePlan__c servicePlan = SNG_TestUtilities.insertServicePlan(account, true);
        Modem__c modem = SNG_TestUtilities.insertEquipment('Terminal1', 
                                                           SNG_MockUsageServiceHttpCallout.INVALID_MAC_ADDRESS_RESPONSE_FORMAT,
                                                           account,
                                                           true);
                                                           
        ModemServicePlan__c msp = SNG_TestUtilities.insertModemServicePlan(modem, servicePlan);
        
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new SNG_MockUsageServiceHttpCallout());
        
        DateTime startDate = SNG_DateUtils.todayGmt().toStartOfMonth();
        DateTime endDate = SNG_DateUtils.todayGmt().addMonths(1).addDays(-1);
    
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        
        ServicePlan__c servicePlanObj = [SELECT Name From ServicePlan__c WHERE Id = :servicePlan.Id];
        String servicePlanId = servicePlanObj.Name;
        
        req.requestURI = '/service-plan/' + servicePlanId + '/usage';
        req.resourcePath = '/service-plan/*/usage';
        req.addParameter('start-date', startDate.formatGmt('YYYY-MM-dd'));
        req.addParameter('end-date', endDate.formatGmt('YYYY-MM-dd'));
        
        req.httpMethod = 'POST';
        
        RestContext.request = req;
        RestContext.response = res;
        
        SNG_REST_JsonResponse response = SNG_REST_ServicePlanUsageApi.get();
        
        integer expectedErrorCode = SNG_REST_Error.getErrorCode(SNGHttpUtilities.Status.SERVER_ERROR, 
                                                                SNG_REST_Error.SubCode.WEBSERVICE_GENERATED_ERROR);
         
        System.assertEquals(SNGHttpUtilities.Status.SERVER_ERROR.name(), response.status);
        System.assertEquals(expectedErrorCode, response.errorCode);
        System.assertEquals(SNG_REST_Error.GENERIC_WEBSERVICE_ERROR, response.errorMessage);
        System.assertEquals(null, response.data);
        
        Test.stopTest();    
    }

    //**********************************************************
    // TEST SNG_REST_ServicePlanUsageOutput
    //**********************************************************
    static testMethod void testServicePlanUsageOutputCtor()
    {
        System.assertEquals(true, throwsValidationException(null, null));
        System.assertEquals(true, throwsValidationException('SP--', null));
        System.assertEquals(true, throwsValidationException('SP-1', null));
        System.assertEquals(false, throwsValidationException('SP-1000', null));
        
        SNG_REST_ServicePlanUsageOutput.MacAddressUsageData m1 = 
           new SNG_REST_ServicePlanUsageOutput.MacAddressUsageData('00:a0:bc:11:22:33', 12345, 78967);
                                                                                                                         
        List<SNG_REST_ServicePlanUsageOutput.MacAddressUsageData> mauds1 = new List<SNG_REST_ServicePlanUsageOutput.MacAddressUsageData>();
        mauds1.add(m1);
        
        System.assertEquals(false, throwsValidationException('SP-1000', mauds1));
    }
    
    static testMethod void testEqualsMethodServicePlanUsageOutput()
    {
        SNG_REST_ServicePlanUsageOutput.MacAddressUsageData m1 = new SNG_REST_ServicePlanUsageOutput.MacAddressUsageData('00:a0:bc:11:22:33',
                                                                                                                         12345,
                                                                                                                         78967);
                                                                                                                         
        SNG_REST_ServicePlanUsageOutput.MacAddressUsageData m2 = new SNG_REST_ServicePlanUsageOutput.MacAddressUsageData('00:a0:bc:55:66:77',
                                                                                                                         789123,
                                                                                                                         819341);
        
                                                                                                                                 
        SNG_REST_ServicePlanUsageOutput.MacAddressUsageData m3 = new SNG_REST_ServicePlanUsageOutput.MacAddressUsageData('00:a0:bc:55:66:77',
                                                                                                                         789123,
                                                                                                                         819341);   
        
        System.assertNotEquals(m1, m2);
        System.assertNotEquals(m1, m3);
        System.assertEquals(m2, m3);
        
                                                                                                                         
        List<SNG_REST_ServicePlanUsageOutput.MacAddressUsageData> mauds1 = new List<SNG_REST_ServicePlanUsageOutput.MacAddressUsageData>();
        mauds1.add(m1);
        mauds1.add(m2);
        
        List<SNG_REST_ServicePlanUsageOutput.MacAddressUsageData> mauds2 = new List<SNG_REST_ServicePlanUsageOutput.MacAddressUsageData>();                                                                                                                                                                                                                                      
        mauds2.add(m1);
        mauds2.add(m2);
        
        List<SNG_REST_ServicePlanUsageOutput.MacAddressUsageData> mauds3 = new List<SNG_REST_ServicePlanUsageOutput.MacAddressUsageData>();                                                                                                                                                                                                                                      
        mauds3.add(m1);
        
        SNG_REST_ServicePlanUsageOutput output1 = new SNG_REST_ServicePlanUsageOutput('SP-1234', mauds1);
        SNG_REST_ServicePlanUsageOutput output2 = new SNG_REST_ServicePlanUsageOutput('SP-1234', mauds2);
        SNG_REST_ServicePlanUsageOutput output3 = new SNG_REST_ServicePlanUsageOutput('SP-1231', mauds1);
        SNG_REST_ServicePlanUsageOutput output4 = new SNG_REST_ServicePlanUsageOutput('SP-1231', mauds3);
    
        System.assertEquals(output1, output1);
        System.assertEquals(output2, output2);
        System.assertEquals(output3, output3);
        System.assertEquals(output4, output4);
        
        System.assertEquals(output1, output2);
        
        System.assertNotEquals(output1, output3);
        System.assertNotEquals(output1, output4);
        
        System.assertNotEquals(output2, output3);
        System.assertNotEquals(output2, output4);
        
        System.assertNotEquals(output3, output4);   
    }
    
    static testMethod void testServicePlanUsageHashCode()
    {
        SNG_REST_ServicePlanUsageOutput.MacAddressUsageData m1 = new SNG_REST_ServicePlanUsageOutput.MacAddressUsageData('00:a0:bc:11:22:33',
                                                                                                                         12345,
                                                                                                                         78967);
                                                                                                                         
        SNG_REST_ServicePlanUsageOutput.MacAddressUsageData m2 = new SNG_REST_ServicePlanUsageOutput.MacAddressUsageData('00:a0:bc:55:66:77',
                                                                                                                         789123,
                                                                                                                         819341);
                                                                                                                         
        List<SNG_REST_ServicePlanUsageOutput.MacAddressUsageData> mauds1 = new List<SNG_REST_ServicePlanUsageOutput.MacAddressUsageData>();
        mauds1.add(m1);
        mauds1.add(m2);
        
        List<SNG_REST_ServicePlanUsageOutput.MacAddressUsageData> mauds2 = new List<SNG_REST_ServicePlanUsageOutput.MacAddressUsageData>();                                                                                                                                                                                                                                      
        mauds2.add(m1);
        mauds2.add(m2);
        
        List<SNG_REST_ServicePlanUsageOutput.MacAddressUsageData> mauds3 = new List<SNG_REST_ServicePlanUsageOutput.MacAddressUsageData>();                                                                                                                                                                                                                                      
        mauds3.add(m1);
        
        SNG_REST_ServicePlanUsageOutput output1 = new SNG_REST_ServicePlanUsageOutput('SP-1234', mauds1);
        SNG_REST_ServicePlanUsageOutput output2 = new SNG_REST_ServicePlanUsageOutput('SP-1234', mauds2);
        SNG_REST_ServicePlanUsageOutput output3 = new SNG_REST_ServicePlanUsageOutput('SP-1231', mauds1);
        SNG_REST_ServicePlanUsageOutput output4 = new SNG_REST_ServicePlanUsageOutput('SP-1231', mauds3);
        
        
        System.assertEquals(output1, output1);
        System.assertEquals(output1.hashCode(), output1.hashCode());
        
        System.assertEquals(output2, output2);
        System.assertEquals(output2.hashCode(), output2.hashCode());
        
        System.assertEquals(output3, output3);
        System.assertEquals(output3.hashCode(), output3.hashCode());
        
        System.assertEquals(output4, output4);
        System.assertEquals(output4.hashCode(), output4.hashCode());
        
        System.assertEquals(output1, output2);
        System.assertEquals(output1.hashCode(), output2.hashCode());
        
        System.assertNotEquals(output1, output3);
        System.assertNotEquals(output1.hashCode(), output3.hashCode());
        
        System.assertNotEquals(output1, output4);
        System.assertNotEquals(output1.hashCode(), output4.hashCode());
        
        System.assertNotEquals(output2, output3);
        System.assertNotEquals(output2.hashCode(), output3.hashCode());
        
        System.assertNotEquals(output2, output4);
        System.assertNotEquals(output2.hashCode(), output4.hashCode());
        
        System.assertNotEquals(output3, output4); 
        System.assertNotEquals(output3.hashCode(), output4.hashCode());         
    } 
    
    
    private static boolean throwsValidationException(String servicePlanId, 
                                                     List<SNG_REST_ServicePlanUsageOutput.MacAddressUsageData> items)
    {
        boolean retValue = false;
        try
        {
            new SNG_REST_ServicePlanUsageOutput(servicePlanId, items);
        }
        catch (SNG_REST_JsonResponseOutput.ValidationException e)
        {
            retValue = true;
        }
        
        return retValue;
    }

    //**********************************************************
    // TEST SNG_REST_ServicePlanUsageOutputBuild
    //**********************************************************
    static testMethod void testBuildImproperFormatStillHandling() 
    {       
        SNG_UsageService.UsagePerBaseStationId ub1 = new SNG_UsageService.UsagePerBaseStationId();
        ub1.bsid = 'BS1';
        ub1.acctInputOctets = 1234567890L;
        ub1.acctOutputOctets = 9876543210L;
        
        SNG_UsageService.UsagePerBaseStationId ub2 = new SNG_UsageService.UsagePerBaseStationId();
        ub2.bsid = 'BS2';
        ub2.acctInputOctets = 5678;
        ub2.acctOutputOctets = 9876;
        
        List<SNG_UsageService.UsagePerBaseStationId> ubList1 = new List<SNG_UsageService.UsagePerBaseStationId>();
        ubList1.add(ub1);
        ubList1.add(ub2);
        
        SNG_UsageService.UsageAndErrors u1 = new SNG_UsageService.UsageAndErrors();
        u1.startTime = DateTime.newInstance(2014, 1, 10, 1, 2, 3);
        u1.endTime = DateTime.newInstance(2014, 2, 10, 12, 23, 14);
        u1.firstProcessedEventTimestamp = DateTime.newInstance(2014, 1, 14, 17, 0, 9);  
        u1.lastProcessedEventTimestamp = DateTime.newInstance(2014, 2, 4, 6, 45, 13);
        u1.aggregateAcctInputOctets = ub1.acctInputOctets + ub2.acctInputOctets;
        u1.aggregateAcctOutputOctets = ub1.acctOutputOctets + ub2.acctOutputOctets;
        u1.usage = ubList1;
        u1.macAddress = '00a0bc112233';

        SNG_UsageService.UsagePerBaseStationId ub3 = new SNG_UsageService.UsagePerBaseStationId();
        ub3.bsid = 'BS3';
        ub3.acctInputOctets = 641829731L;
        ub3.acctOutputOctets = 189231289L;
        
        SNG_UsageService.UsagePerBaseStationId ub4 = new SNG_UsageService.UsagePerBaseStationId();
        ub4.bsid = 'BS4';
        ub4.acctInputOctets = 98787123L;
        ub4.acctOutputOctets = 123215L;
        
        List<SNG_UsageService.UsagePerBaseStationId> ubList2 = new List<SNG_UsageService.UsagePerBaseStationId>();
        ubList2.add(ub3);
        ubList2.add(ub4);       
        
        SNG_UsageService.UsageAndErrors u2 = new SNG_UsageService.UsageAndErrors();
        u2.startTime = DateTime.newInstance(2014, 3, 10, 13, 24, 31);
        u2.endTime = DateTime.newInstance(2014, 3, 10, 9, 36, 14);
        u2.firstProcessedEventTimestamp = DateTime.newInstance(2014, 3, 15, 12, 10, 45);  
        u2.lastProcessedEventTimestamp = DateTime.newInstance(2014, 4, 15, 5, 6, 7);
        u2.aggregateAcctInputOctets = ub3.acctInputOctets + ub4.acctInputOctets;
        u2.aggregateAcctOutputOctets = ub3.acctOutputOctets + ub4.acctOutputOctets;
        u2.usage = ubList2;
        u2.macAddress = '00a0bc223344';     
        
        List<SNG_UsageService.UsageAndErrors> uaes = new List<SNG_UsageService.UsageAndErrors>();
        uaes.add(u1);
        uaes.add(u2);
        
        SNG_UsageService.Response response = new SNG_UsageService.Response();
        response.status = 'success';
        response.error = 0;
        response.errorDetail = new List<String>();
        response.errorDetail.add('Hello World');
        response.errorDetail.add('Foo');
        
        List<List<SNG_UsageService.UsageAndErrors>> uaesListOfList = new List<List<SNG_UsageService.UsageAndErrors>>();
        uaesListOfList.add(uaes);
        
        response.data = uaesListOfList;
        
        Long expectedAggUploadUsage = u1.aggregateAcctOutputOctets + u2.aggregateAcctOutputOctets;
        Long expectedAggDownloadUsage = u1.aggregateAcctInputOctets + u2.aggregateAcctInputOctets;
        Long expectedAggTotalUsage = expectedAggUploadUsage + expectedAggDownloadUsage;
        
        String servicePlanId = 'SP-1234';
        
        
        ModemServicePlan__c msp1 = new ModemServicePlan__c();
        msp1.Modem__r = new Modem__c();
        msp1.Modem__r.Name = SNG_REST_Utilities.formatMacAddress(u1.macAddress);
        
        ModemServicePlan__c msp2 = new ModemServicePlan__c();
        msp2.Modem__r = new Modem__c();
        msp2.Modem__r.Name = SNG_REST_Utilities.formatMacAddress(u2.macAddress);
        
        List<ModemServicePlan__c> msps = new List<ModemServicePlan__c>();
        msps.add(msp1);
        msps.add(msp2);
        
        SNG_REST_ServicePlanUsageOutput output = SNG_REST_ServicePlanUsageOutputBuilder.build(servicePlanId, response, msps);
        System.debug(output);
        
        System.assertEquals(servicePlanId, output.servicePlanId);
        System.assertEquals(expectedAggUploadUsage, output.uploadUsage);
        System.assertEquals(expectedAggDownloadUsage, output.downloadUsage);
        System.assertEquals(expectedAggTotalUsage, output.totalUsage);
        System.assertEquals(2, output.items.size());
            
        SNG_REST_ServicePlanUsageOutput.MacAddressUsageData maud = (SNG_REST_ServicePlanUsageOutput.MacAddressUsageData)output.items.get(0);
        if (SNG_REST_Utilities.formatMacAddress(u2.macAddress) == maud.macAddress) {
        System.assertEquals(u2.aggregateAcctOutputOctets,  maud.uploadUsage);
        System.assertEquals(u2.aggregateAcctInputOctets, maud.downloadUsage);
        } else {
        //maud = (SNG_REST_ServicePlanUsageOutput.MacAddressUsageData)output.items.get(1);
        System.assertEquals(SNG_REST_Utilities.formatMacAddress(u1.macAddress),  maud.macAddress);
        System.assertEquals(u1.aggregateAcctOutputOctets,  maud.uploadUsage);
        System.assertEquals(u1.aggregateAcctInputOctets, maud.downloadUsage); }
    }
    
    static testMethod void testServicePlanUsageBuild() 
    {
        SNG_UsageService.UsagePerBaseStationId ub1 = new SNG_UsageService.UsagePerBaseStationId();
        ub1.bsid = 'BS1';
        ub1.acctInputOctets = 1234567890L;
        ub1.acctOutputOctets = 9876543210L;
        
        SNG_UsageService.UsagePerBaseStationId ub2 = new SNG_UsageService.UsagePerBaseStationId();
        ub2.bsid = 'BS2';
        ub2.acctInputOctets = 5678;
        ub2.acctOutputOctets = 9876;
        
        List<SNG_UsageService.UsagePerBaseStationId> ubList1 = new List<SNG_UsageService.UsagePerBaseStationId>();
        ubList1.add(ub1);
        ubList1.add(ub2);
        
        SNG_UsageService.UsageAndErrors u1 = new SNG_UsageService.UsageAndErrors();
        u1.startTime = DateTime.newInstance(2014, 1, 10, 1, 2, 3);
        u1.endTime = DateTime.newInstance(2014, 2, 10, 12, 23, 14);
        u1.firstProcessedEventTimestamp = DateTime.newInstance(2014, 1, 14, 17, 0, 9);  
        u1.lastProcessedEventTimestamp = DateTime.newInstance(2014, 2, 4, 6, 45, 13);
        u1.aggregateAcctInputOctets = ub1.acctInputOctets + ub2.acctInputOctets;
        u1.aggregateAcctOutputOctets = ub1.acctOutputOctets + ub2.acctOutputOctets;
        u1.usage = ubList1;
        u1.macAddress = '00a0bc112233';

        SNG_UsageService.UsagePerBaseStationId ub3 = new SNG_UsageService.UsagePerBaseStationId();
        ub3.bsid = 'BS3';
        ub3.acctInputOctets = 641829731L;
        ub3.acctOutputOctets = 189231289L;
        
        SNG_UsageService.UsagePerBaseStationId ub4 = new SNG_UsageService.UsagePerBaseStationId();
        ub4.bsid = 'BS4';
        ub4.acctInputOctets = 98787123L;
        ub4.acctOutputOctets = 123215L;
        
        List<SNG_UsageService.UsagePerBaseStationId> ubList2 = new List<SNG_UsageService.UsagePerBaseStationId>();
        ubList2.add(ub3);
        ubList2.add(ub4);       
        
        SNG_UsageService.UsageAndErrors u2 = new SNG_UsageService.UsageAndErrors();
        u2.startTime = DateTime.newInstance(2014, 3, 10, 13, 24, 31);
        u2.endTime = DateTime.newInstance(2014, 3, 10, 9, 36, 14);
        u2.firstProcessedEventTimestamp = DateTime.newInstance(2014, 3, 15, 12, 10, 45);  
        u2.lastProcessedEventTimestamp = DateTime.newInstance(2014, 4, 15, 5, 6, 7);
        u2.aggregateAcctInputOctets = ub3.acctInputOctets + ub4.acctInputOctets;
        u2.aggregateAcctOutputOctets = ub3.acctOutputOctets + ub4.acctOutputOctets;
        u2.usage = ubList2;
        u2.macAddress = '00a0bc223344';     
        
        List<SNG_UsageService.UsageAndErrors> uaes = new List<SNG_UsageService.UsageAndErrors>();
        uaes.add(u1);
        List<SNG_UsageService.UsageAndErrors> uaes1 = new List<SNG_UsageService.UsageAndErrors>();
        uaes1.add(u2);
        
        SNG_UsageService.Response response = new SNG_UsageService.Response();
        response.status = 'success';
        response.error = 0;
        response.errorDetail = new List<String>();
        response.errorDetail.add('Hello World');
        response.errorDetail.add('Foo');
        
        List<List<SNG_UsageService.UsageAndErrors>> uaesListOfList = new List<List<SNG_UsageService.UsageAndErrors>>();
        uaesListOfList.add(uaes);
        uaesListOfList.add(uaes1);
        
        response.data = uaesListOfList;
        
        Long expectedAggUploadUsage = u1.aggregateAcctOutputOctets + u2.aggregateAcctOutputOctets;
        Long expectedAggDownloadUsage = u1.aggregateAcctInputOctets + u2.aggregateAcctInputOctets;
        Long expectedAggTotalUsage = expectedAggUploadUsage + expectedAggDownloadUsage;
        
        String servicePlanId = 'SP-1234';
        
        
        ModemServicePlan__c msp1 = new ModemServicePlan__c();
        msp1.Modem__r = new Modem__c();
        msp1.Modem__r.Name = SNG_REST_Utilities.formatMacAddress(u1.macAddress);
        
        ModemServicePlan__c msp2 = new ModemServicePlan__c();
        msp2.Modem__r = new Modem__c();
        msp2.Modem__r.Name = SNG_REST_Utilities.formatMacAddress(u2.macAddress);
        
        List<ModemServicePlan__c> msps = new List<ModemServicePlan__c>();
        msps.add(msp1);
        msps.add(msp2);
        
        SNG_REST_ServicePlanUsageOutput output = SNG_REST_ServicePlanUsageOutputBuilder.build(servicePlanId, response, msps);
        System.debug(output);
        
        System.assertEquals(servicePlanId, output.servicePlanId);
        System.assertEquals(expectedAggUploadUsage, output.uploadUsage);
        System.assertEquals(expectedAggDownloadUsage, output.downloadUsage);
        System.assertEquals(expectedAggTotalUsage, output.totalUsage);
        System.assertEquals(2, output.items.size());
            
        SNG_REST_ServicePlanUsageOutput.MacAddressUsageData maud = (SNG_REST_ServicePlanUsageOutput.MacAddressUsageData)output.items.get(0);
        if (SNG_REST_Utilities.formatMacAddress(u2.macAddress) == maud.macAddress){
        System.assertEquals(u2.aggregateAcctOutputOctets,  maud.uploadUsage);
        System.assertEquals(u2.aggregateAcctInputOctets, maud.downloadUsage);
        } else {
        //maud = (SNG_REST_ServicePlanUsageOutput.MacAddressUsageData)output.items.get(1);
        System.assertEquals(SNG_REST_Utilities.formatMacAddress(u1.macAddress),  maud.macAddress);
        System.assertEquals(u1.aggregateAcctOutputOctets,  maud.uploadUsage);
        System.assertEquals(u1.aggregateAcctInputOctets, maud.downloadUsage); 
        }
    }
    
    static testMethod void testBuildMissingEntry() 
    {        
        SNG_UsageService.UsagePerBaseStationId ub1 = new SNG_UsageService.UsagePerBaseStationId();
        ub1.bsid = 'BS1';
        ub1.acctInputOctets = 1234567890L;
        ub1.acctOutputOctets = 9876543210L;
        
        SNG_UsageService.UsagePerBaseStationId ub2 = new SNG_UsageService.UsagePerBaseStationId();
        ub2.bsid = 'BS2';
        ub2.acctInputOctets = 5678;
        ub2.acctOutputOctets = 9876;
        
        List<SNG_UsageService.UsagePerBaseStationId> ubList1 = new List<SNG_UsageService.UsagePerBaseStationId>();
        ubList1.add(ub1);
        ubList1.add(ub2);
        
        SNG_UsageService.UsageAndErrors u1 = new SNG_UsageService.UsageAndErrors();
        u1.startTime = DateTime.newInstance(2014, 1, 10, 1, 2, 3);
        u1.endTime = DateTime.newInstance(2014, 2, 10, 12, 23, 14);
        u1.firstProcessedEventTimestamp = DateTime.newInstance(2014, 1, 14, 17, 0, 9);  
        u1.lastProcessedEventTimestamp = DateTime.newInstance(2014, 2, 4, 6, 45, 13);
        u1.aggregateAcctInputOctets = ub1.acctInputOctets + ub2.acctInputOctets;
        u1.aggregateAcctOutputOctets = ub1.acctOutputOctets + ub2.acctOutputOctets;
        u1.usage = ubList1;
        u1.macAddress = '00a0bc112233';

        SNG_UsageService.UsagePerBaseStationId ub3 = new SNG_UsageService.UsagePerBaseStationId();
        ub3.bsid = 'BS3';
        ub3.acctInputOctets = 641829731L;
        ub3.acctOutputOctets = 189231289L;
        
        SNG_UsageService.UsagePerBaseStationId ub4 = new SNG_UsageService.UsagePerBaseStationId();
        ub4.bsid = 'BS4';
        ub4.acctInputOctets = 98787123L;
        ub4.acctOutputOctets = 123215L;
        
        List<SNG_UsageService.UsagePerBaseStationId> ubList2 = new List<SNG_UsageService.UsagePerBaseStationId>();
        ubList2.add(ub3);
        ubList2.add(ub4);       
        
        List<SNG_UsageService.UsageAndErrors> uaes = new List<SNG_UsageService.UsageAndErrors>();
        uaes.add(u1);
        
        SNG_UsageService.Response response = new SNG_UsageService.Response();
        response.status = 'success';
        response.error = 0;
        response.errorDetail = new List<String>();
        response.errorDetail.add('Hello World');
        response.errorDetail.add('Foo');
        
        List<List<SNG_UsageService.UsageAndErrors>> uaesListOfList = new List<List<SNG_UsageService.UsageAndErrors>>();
        uaesListOfList.add(uaes);
        
        response.data = uaesListOfList;
        
        Long expectedAggUploadUsage = u1.aggregateAcctOutputOctets;
        Long expectedAggDownloadUsage = u1.aggregateAcctInputOctets;
        Long expectedAggTotalUsage = expectedAggUploadUsage + expectedAggDownloadUsage;
        
        String servicePlanId = 'SP-1234';
        
        
        ModemServicePlan__c msp1 = new ModemServicePlan__c();
        msp1.Modem__r = new Modem__c();
        msp1.Modem__r.Name = SNG_REST_Utilities.formatMacAddress(u1.macAddress);
        
        ModemServicePlan__c msp2 = new ModemServicePlan__c();
        msp2.Modem__r = new Modem__c();
        msp2.Modem__r.Name = SNG_REST_Utilities.formatMacAddress('00a0bc223344');
        
        List<ModemServicePlan__c> msps = new List<ModemServicePlan__c>();
        msps.add(msp1);
        msps.add(msp2);
        
        SNG_REST_ServicePlanUsageOutput output = SNG_REST_ServicePlanUsageOutputBuilder.build(servicePlanId, response, msps);
        System.debug(output);
        
        System.assertEquals(servicePlanId, output.servicePlanId);
        System.assertEquals(expectedAggUploadUsage, output.uploadUsage);
        System.assertEquals(expectedAggDownloadUsage, output.downloadUsage);
        System.assertEquals(expectedAggTotalUsage, output.totalUsage);
        System.assertEquals(2, output.items.size());
            
        SNG_REST_ServicePlanUsageOutput.MacAddressUsageData maud = (SNG_REST_ServicePlanUsageOutput.MacAddressUsageData)output.items.get(0);
        if (msp2.Modem__r.Name == maud.macAddress){
        System.assertEquals(0, maud.uploadUsage);
        System.assertEquals(0, maud.downloadUsage);
        } else {
        //maud = (SNG_REST_ServicePlanUsageOutput.MacAddressUsageData)output.items.get(1);
        System.assertEquals(SNG_REST_Utilities.formatMacAddress(u1.macAddress),  maud.macAddress);
        System.assertEquals(u1.aggregateAcctOutputOctets, maud.uploadUsage);
        System.assertEquals(u1.aggregateAcctInputOctets, maud.downloadUsage); }
    }
    
    //**********************************************************
    // TEST SNG_REST_PerfHistor 
    //**********************************************************
    private static String SERVICE_URI = '/services/apexrest/terminal/'; 
    private static String PERFORMANCE_URI = '/performance/history'; 
    
    private static Date inputStartDate = SNG_DateUtils.todayGmt().addDays(-3); 
    private static Date inputEndDate = SNG_DateUtils.todayGmt().addDays(-2); 
    
    private static String validStartDate = String.valueOf(inputStartDate.year()) + '-' + String.valueOf(inputStartDate.month()) + '-' + String.valueOf(inputStartDate.day()); 
    private static String validEndDate = String.valueOf(inputEndDate.year()) + '-' + String.valueOf(inputEndDate.month()) + '-' + String.valueOf(inputEndDate.day());
    
    /**
     * Valid Customer Input, No Terminal in Salesforce
     */ 
    static testMethod void validTerminalAndDatesNoTerminal() {
                
        // Client Inputs
        String terminalId = 'T0181'; 
         
        // Create new RestRequest object and set the URI
        RestRequest req = new RestRequest();
        req.requestURI = SERVICE_URI + terminalId + PERFORMANCE_URI; 
        
        // Add the parameters for Start Date and End Date into the RestRequest parameters
        req.addParameter(START_DATE_PARAM, validStartDate);
        req.addParameter(END_DATE_PARAM, validEndDate); 
         
        // RestContext stores the RestRequest in context for API Rest Method 
        RestContext.request = req; 

        
        // Get the performance history
       SNG_REST_JsonResponse outputResult = SNG_REST_PerfHistory.getPerformanceHistory(); 
       
       // Build the expected response
       compareResponses(outputResult, SNGHttpUtilities.Status.ZERO_RESULTS, SNG_REST_Error.SubCode.SALESFORCE_GENERATED_ERROR, 
                        SNG_REST_PerfHistory.NO_TERMINAL, null); 
    }
    
    
    /**
     * Valid customer input, no modem associated with Terminal
     */ 
    static testMethod void validTerminalAndDatesNoModem() { 
        
        SNG_MockCustomSettings.initialize();

        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse(); 
        
        RestContext.request = req; 
        RestContext.response = res; 
        
        // insert Terminal with no modem
        Account account = SNG_TestUtilities.insertAccount('testAccount'); 
        Terminal__c terminal = SNG_TestUtilities.insertTerminal(account, '11111', '1234561'); 
        
        // Get terminal Name that SF assigns to it
        terminal = [SELECT Name FROM Terminal__c WHERE SerialNumber__c = '11111'];
        
        // Client inputs
        String terminalId = terminal.Name; 
        
        // Use terminal name to construct the Request URI
        RestContext.request.requestURI = SERVICE_URI + terminalId + PERFORMANCE_URI; 
        
        // Set Request Method
        RestContext.request.httpMethod = 'GET'; 

        // Add parameters for RestRequest
        RestContext.request.addParameter(START_DATE_PARAM, validStartDate);
        RestContext.request.addParameter(END_DATE_PARAM, validEndDate); 
        
        Test.startTest(); 
        
        SNG_REST_JsonResponse outputResult = SNG_REST_PerfHistory.getPerformanceHistory();
        
       // Build the expected response
       compareResponses(outputResult, SNGHttpUtilities.Status.ZERO_RESULTS, SNG_REST_Error.SubCode.SALESFORCE_GENERATED_ERROR, 
                        SNG_REST_PerfHistory.TERMINAL_NO_MODEM, null);      
    
        Test.stopTest(); 
    }
    
    
    /**
     * Valid customer input, Terminal is in Salesforce
     */ 
    static testMethod void validTerminalAndDatesWithTerminal() { 
        
        // Initialize mock custom settings for unit test (Need for SNG_HttpUtilities)
        SNG_MockCustomSettings.initialize();

        // Insert Account, Terminal
        Account account = SNG_TestUtilities.insertAccount('testAccount'); 
        Terminal__c terminal = SNG_TestUtilities.insertTerminal(account, '11111', '1234561'); 
        terminal = [SELECT Id, Name FROM Terminal__c WHERE SerialNumber__c = '11111'];
        
        // Insert Modem, set lookup to terminal
        String macAddress = SNG_MockUTPerformanceHistoryHttpCallout.HTTP_STATUS_ONE_RESULT_MAC_ADDRESS; 
        Modem__c modem = SNG_TestUtilities.insertModem(account, '22222', macAddress, '12345', terminal);
        
        // Client Inputs
        String terminalId = terminal.Name; 
        
        Test.startTest(); 
        // Set up mock response for HTTP callout
        Test.setMock(HttpCalloutMock.class, new SNG_MockUTPerformanceHistoryHttpCallout());
         
        // RestRequest
        RestRequest req = new RestRequest();
        req.requestURI = SERVICE_URI + terminalId + PERFORMANCE_URI;
        
        // Add parameters for RestRequest
        req.addParameter(START_DATE_PARAM, validStartDate);
        req.addParameter(END_DATE_PARAM, validEndDate); 
        
        // Set the RestContext's request and response
        RestContext.request = req; 
        RestContext.response = new RestResponse(); 
         
        SNG_REST_JsonResponse outputResult = SNG_REST_PerfHistory.getPerformanceHistory();
        
        // Build the data portion of the expected response
        SNG_REST_PerfHistory.TerminalRawPerformanceData oneResult = 
                                    new SNG_REST_PerfHistory.TerminalRawPerformanceData(1385971200, 625.0,20.5);
        List<SNG_REST_PerfHistory.TerminalRawPerformanceData> items = new List<SNG_REST_PerfHistory.TerminalRawPerformanceData>();
        items.add(oneResult);
        SNG_REST_PerfHistory.TerminalPerformanceHistoryOutput dataPortion = 
                                            new SNG_REST_PerfHistory.TerminalPerformanceHistoryOutput(terminalId, validStartDate, validEndDate,
                                                                    items);
        
        compareResponses(outputResult, SNGHttpUtilities.Status.OK, null, 
                        null, dataPortion);         
/*        
        jsonVerifier(RestContext.response, 'OK', 'null', 0, terminal.Name, validStartDate, validEndDate, '625', '1385971200', '20.5');
*/        
        Test.stopTest(); 
    }
    
    
    /**
     * Invalid Terminal format
     */ 
    static testMethod void invalidTerminalIdValidDates() { 
        
        // Different possible erroneous Terminal Ids
        String terminalId_1 = 'T009';           // Terminal ID must have at least 4 numbers after T (i.e. TXXXX)
        String terminalId_2 = 'P0000';          // Terminal ID must start with letter 't' or 'T'
        String terminalId_3 = 'T01811';         // Terminal ID may not have leading 0s before a valid number
        String terminalId_4 = 'TT0181';         // Terminal ID can only start with 1 letter 'T'     
        String terminalId_5 = '0181';           // Terminal ID must start with 'T' or 't'
        
        SNG_MockCustomSettings.initialize(); 
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new SNG_MockUTPerformanceHistoryHttpCallout());
        
        RestRequest req = new RestRequest(); 
        
        RestContext.response = new RestResponse(); 
        RestContext.request = req; 
        
        SNG_REST_JsonResponse outputResult; 
        
        // Add parameters for RestRequest
        req.addParameter(START_DATE_PARAM, validStartDate);
        req.addParameter(END_DATE_PARAM, validEndDate);
        
        req.requestURI = SERVICE_URI + terminalId_1 + PERFORMANCE_URI;
        outputResult = SNG_REST_PerfHistory.getPerformanceHistory();
        compareResponses(outputResult, SNGHttpUtilities.Status.INPUT_VALIDATION_ERROR, 
                        SNG_REST_Error.SubCode.SALESFORCE_GENERATED_ERROR, SNG_REST_PerfHistory.TERMINAL_INVALID_FORMAT, 
                        null);
/*      
        jsonVerifier(RestContext.response, 'INPUT_VALIDATION_ERROR', SNG_REST_PerfHistory.TERMINAL_INVALID_FORMAT, 4001, 'T009', validStartDate, validEndDate, null, null, null);
*/      
        req.requestURI = SERVICE_URI + terminalId_2 + PERFORMANCE_URI;
        outputResult = SNG_REST_PerfHistory.getPerformanceHistory();
        compareResponses(outputResult, SNGHttpUtilities.Status.INPUT_VALIDATION_ERROR, 
                        SNG_REST_Error.SubCode.SALESFORCE_GENERATED_ERROR, SNG_REST_PerfHistory.TERMINAL_INVALID_FORMAT, 
                        null);
/*      
        jsonVerifier(RestContext.response, 'INPUT_VALIDATION_ERROR', SNG_REST_PerfHistory.TERMINAL_INVALID_FORMAT, 4001, 'P0000', validStartDate, validEndDate, null, null, null);
*/      
        req.requestURI = SERVICE_URI + terminalId_3 + PERFORMANCE_URI;
        outputResult = SNG_REST_PerfHistory.getPerformanceHistory();
        compareResponses(outputResult, SNGHttpUtilities.Status.INPUT_VALIDATION_ERROR, 
                        SNG_REST_Error.SubCode.SALESFORCE_GENERATED_ERROR, SNG_REST_PerfHistory.TERMINAL_INVALID_FORMAT, 
                        null);
/*      
        jsonVerifier(RestContext.response, 'INPUT_VALIDATION_ERROR', SNG_REST_PerfHistory.TERMINAL_INVALID_FORMAT, 4001, 'T01811', validStartDate, validEndDate, null, null, null);
*/
        req.requestURI = SERVICE_URI + terminalId_4 + PERFORMANCE_URI;
        outputResult = SNG_REST_PerfHistory.getPerformanceHistory();
        compareResponses(outputResult, SNGHttpUtilities.Status.INPUT_VALIDATION_ERROR, 
                        SNG_REST_Error.SubCode.SALESFORCE_GENERATED_ERROR, SNG_REST_PerfHistory.TERMINAL_INVALID_FORMAT, 
                        null);  
/*      
        jsonVerifier(RestContext.response, 'INPUT_VALIDATION_ERROR', SNG_REST_PerfHistory.TERMINAL_INVALID_FORMAT, 4001, 'TT0181', validStartDate, validEndDate, null, null, null);
*/
        req.requestURI = SERVICE_URI + terminalId_5 + PERFORMANCE_URI;
        outputResult = SNG_REST_PerfHistory.getPerformanceHistory();
        compareResponses(outputResult, SNGHttpUtilities.Status.INPUT_VALIDATION_ERROR, 
                        SNG_REST_Error.SubCode.SALESFORCE_GENERATED_ERROR, SNG_REST_PerfHistory.TERMINAL_INVALID_FORMAT, 
                        null);      
/*
        jsonVerifier(RestContext.response, 'INPUT_VALIDATION_ERROR', SNG_REST_PerfHistory.TERMINAL_INVALID_FORMAT, 4001, '0181', validStartDate, validEndDate, null, null, null);            
*/      
        Test.stopTest();  
    }
    
    /**
     * Invalid Start Date
     */ 
    static testMethod void validTerminalIdInvalidStartDate() { 
        
        SNG_MockCustomSettings.initialize();

        // Insert Account, Terminal
        Account account = SNG_TestUtilities.insertAccount('testAccount'); 
        Terminal__c terminal = SNG_TestUtilities.insertTerminal(account, '11111', '1234561'); 
        terminal = [SELECT Id, Name FROM Terminal__c WHERE SerialNumber__c = '11111'];
        
        // Insert Modem, set lookup to terminal
        String macAddress = SNG_MockUTPerformanceHistoryHttpCallout.HTTP_STATUS_ONE_RESULT_MAC_ADDRESS; 
        Modem__c modem = SNG_TestUtilities.insertModem(account, '22222', macAddress, '12345', terminal);
        
        // Client Input
        String terminalId = terminal.Name; 
        String testEndDate = '2014-05-30'; 
        
        String startDate_1 = '05-30-2014';      // StartDate must be in format YYYY-MM-DD
        String startDate_2 = '';                // StartDate cannot be an empty string performance/raw/history?StartDate=&EndDate=2014-05-30
        String startDate_3 = null;              // StartDate cannot be null
        String startDate_4 = 'Test';            // StartDate must be a valid date in valid format
        String startDate_5 = '2014/05/29';      // StartDate must be in format YYYY-MM-DD
        String startDate_6 = '0000-05-29';      
        
        SNG_MockCustomSettings.initialize(); 
        
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new SNG_MockUTPerformanceHistoryHttpCallout());
        
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse(); 
        
        RestContext.request = req;
        RestContext.response = res; 
        
        // Set RestRequest URI
        req.requestURI = SERVICE_URI + terminalId + PERFORMANCE_URI;
        
        // Set parameters for REST Request
        req.addParameter(END_DATE_PARAM, testEndDate);
        
        SNG_REST_JsonResponse outputResult; 
        
        // Test startDate_1
        req.addParameter(START_DATE_PARAM, startDate_1); 
        outputResult = SNG_REST_PerfHistory.getPerformanceHistory(); 
        compareResponses(outputResult, SNGHttpUtilities.Status.INPUT_VALIDATION_ERROR, 
                            SNG_REST_ERROR.SubCode.SALESFORCE_GENERATED_ERROR, 
                            SNG_REST_Error.INVALID_DATE + ' Dates must be in YYYY-MM-DD format.',
                            null);
/*      
        jsonVerifier(res, 'INPUT_VALIDATION_ERROR', SNG_REST_Error.INVALID_DATE + ' Dates must be in YYYY-MM-DD format.', 4001, terminal.Name, '05-30-2014', '2014-05-30', null, null, null);
*/      
        // Test startDate_2
        req.addParameter(START_DATE_PARAM, startDate_2); 
        outputResult = SNG_REST_PerfHistory.getPerformanceHistory(); 
        compareResponses(outputResult, SNGHttpUtilities.Status.INPUT_VALIDATION_ERROR, 
                            SNG_REST_ERROR.SubCode.SALESFORCE_GENERATED_ERROR, 
                            SNG_REST_Error.INVALID_DATE + ' Dates must be in YYYY-MM-DD format.',
                            null);  
/*      
        jsonVerifier(res, 'INPUT_VALIDATION_ERROR', SNG_REST_Error.INVALID_DATE + ' Dates must be in YYYY-MM-DD format.', 4001, terminal.Name, '', '2014-05-30', null, null, null);
*/      
        // Test startDate_3
        req.addParameter(START_DATE_PARAM, startDate_3);
        System.debug('START HERE');  
        outputResult = SNG_REST_PerfHistory.getPerformanceHistory(); 
        compareResponses(outputResult, SNGHttpUtilities.Status.INPUT_VALIDATION_ERROR, 
                            SNG_REST_ERROR.SubCode.SALESFORCE_GENERATED_ERROR, 
                            SNG_REST_Error.MISSING_START_DATE,
                            null);      
/*      
        jsonVerifier(res, 'INPUT_VALIDATION_ERROR', SNG_REST_Error.MISSING_START_DATE, 4001, terminal.Name, 'null', '2014-05-30', null, null, null);
*/
        // Test startDate_4     
        req.addParameter(START_DATE_PARAM, startDate_4); 
        outputResult = SNG_REST_PerfHistory.getPerformanceHistory(); 
        compareResponses(outputResult, SNGHttpUtilities.Status.INPUT_VALIDATION_ERROR, 
                            SNG_REST_ERROR.SubCode.SALESFORCE_GENERATED_ERROR, 
                            SNG_REST_Error.INVALID_DATE + ' Dates must be in YYYY-MM-DD format.',
                            null);      
/*      
        jsonVerifier(res, 'INPUT_VALIDATION_ERROR', SNG_REST_Error.INVALID_DATE + ' Dates must be in YYYY-MM-DD format.', 4001, terminal.Name, 'Test', '2014-05-30', null, null, null);  
*/      
        // Test startDate_5
        req.addParameter(START_DATE_PARAM, startDate_5); 
        outputResult = SNG_REST_PerfHistory.getPerformanceHistory(); 
        compareResponses(outputResult, SNGHttpUtilities.Status.INPUT_VALIDATION_ERROR, 
                            SNG_REST_ERROR.SubCode.SALESFORCE_GENERATED_ERROR, 
                            SNG_REST_Error.INVALID_DATE + ' Dates must be in YYYY-MM-DD format.',
                            null);      
/*      
        jsonVerifier(res, 'INPUT_VALIDATION_ERROR', SNG_REST_Error.INVALID_DATE + ' Dates must be in YYYY-MM-DD format.', 4001, terminal.Name, '2014/05/29', '2014-05-30', null, null, null);
*/      
        // Test startDate_6
        req.addParameter(START_DATE_PARAM, startDate_6); 
        outputResult = SNG_REST_PerfHistory.getPerformanceHistory(); 
        compareResponses(outputResult, SNGHttpUtilities.Status.INPUT_VALIDATION_ERROR, 
                            SNG_REST_ERROR.SubCode.SALESFORCE_GENERATED_ERROR, 
                            SNG_REST_Error.INVALID_DATE + ' Dates must be in YYYY-MM-DD format.',
                            null); 

/*      
        jsonVerifier(res, 'INPUT_VALIDATION_ERROR', SNG_REST_Error.INVALID_DATE + ' Dates must be in YYYY-MM-DD format.', 4001, terminal.Name, '0000-05-29', '2014-05-30', null, null, null);   
*/      
        Test.stopTest(); 
    } 
    
    
    /**
     * Start Date cannot be in the future
     */ 
    static testMethod void startDateIsInTheFuture() { 

        SNG_MockCustomSettings.initialize();

        // Insert Account, Terminal
        Account account = SNG_TestUtilities.insertAccount('testAccount'); 
        Terminal__c terminal = SNG_TestUtilities.insertTerminal(account, '11111', '1234561'); 
        terminal = [SELECT Id, Name FROM Terminal__c WHERE SerialNumber__c = '11111'];
        
        // Insert Modem, set lookup to terminal
        String macAddress = SNG_MockUTPerformanceHistoryHttpCallout.HTTP_STATUS_ONE_RESULT_MAC_ADDRESS; 
        Modem__c modem = SNG_TestUtilities.insertModem(account, '22222', macAddress, '12345', terminal);

        String startYear, startMonth, startDay;
        String endYear, endMonth, endDay;
        
        // Set Start date to the future
        Date futureDate = SNG_DateUtils.todayGmt().addDays(1); 
        
        startYear = String.valueOf(futureDate.year());
        
        if (futureDate.month() < 10) { 
            startMonth = '0' + String.valueOf(futureDate.month()); 
        }
        else { 
            startMonth = String.valueOf(futureDate.month()); 
        }
        
        if (futureDate.day() < 10) { 
            startDay = '0' + String.valueOf(futureDate.day()); 
        }
        else { 
            startDay = String.valueOf(futureDate.day());
        }
         
        
        // Set End date to the future one day after start date
        futureDate = futureDate.addDays(1);
        
        endYear = String.valueOf(futureDate.year());
        
        if (futureDate.month() < 10) { 
            endMonth = '0' + String.valueOf(futureDate.month());
        }
        else { 
            endMonth = String.valueOf(futureDate.month());
        }
        
        if (futureDate.day() < 10) { 
            endDay = '0' + String.valueOf(futureDate.day());
        } 
        else { 
            endDay = String.valueOf(futureDate.day());
        } 
        
        
        // Client Input
        String testStartDate = startYear + '-' + startMonth + '-' + startDay;       // StartDate cannot be in the future
        String testEndDate = endYear + '-' + endMonth + '-' + endDay;           
        String terminalId = 'T0181'; 
        
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse(); 
        
        RestContext.request = req; 
        RestContext.response = res; 
        
        // Set request URI 
        req.requestURI = SERVICE_URI + terminalId + PERFORMANCE_URI;
        
        // add request parameters
        req.addParameter(START_DATE_PARAM, testStartDate);
        req.addParameter(END_DATE_PARAM, testEndDate);
        
        SNG_REST_JsonResponse outputResult = SNG_REST_PerfHistory.getPerformanceHistory();
        compareResponses(outputResult, SNGHttpUtilities.Status.INPUT_VALIDATION_ERROR, 
                            SNG_REST_Error.SubCode.SALESFORCE_GENERATED_ERROR, 
                            SNG_REST_ERROR.START_DATE_IN_FUTURE, 
                            null); 
/*       
        jsonVerifier(RestContext.response, 'INPUT_VALIDATION_ERROR', SNG_REST_Error.START_DATE_IN_FUTURE, 4001, 'T0181', testStartDate, testEndDate, null, null, null);
*/       
    }
    
    /**
     * Missing Start Date parameter
     * i.e. performance/raw/history?EndDate=2014-05-30
     */ 
    static testMethod void missingStartDateParameter() { 
        
        SNG_MockCustomSettings.initialize();

        // Insert Account, Terminal
        Account account = SNG_TestUtilities.insertAccount('testAccount'); 
        Terminal__c terminal = SNG_TestUtilities.insertTerminal(account, '11111', '1234561'); 
        terminal = [SELECT Id, Name FROM Terminal__c WHERE SerialNumber__c = '11111'];
        
        // Insert Modem, set lookup to terminal
        String macAddress = SNG_MockUTPerformanceHistoryHttpCallout.HTTP_STATUS_ONE_RESULT_MAC_ADDRESS; 
        Modem__c modem = SNG_TestUtilities.insertModem(account, '22222', macAddress, '12345', terminal);        
        
        // Client input
        String terminalId = terminal.Name; 
        String testEndDate = '2014-05-30'; 
        
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();      
        
        RestContext.request = req; 
        RestContext.response = res;
        
        // Set request URI 
        req.requestURI = SERVICE_URI + terminalId + PERFORMANCE_URI;
        
        req.addParameter(END_DATE_PARAM, testEndDate); 
        
        SNG_REST_JsonResponse outputResult = SNG_REST_PerfHistory.getPerformanceHistory();

        compareResponses(outputResult, SNGHttpUtilities.Status.INPUT_VALIDATION_ERROR,
                        SNG_REST_Error.SubCode.SALESFORCE_GENERATED_ERROR, 
                        SNG_REST_Error.MISSING_START_DATE, null);       
/*      
        jsonVerifier(RestContext.response, 'INPUT_VALIDATION_ERROR', SNG_REST_Error.MISSING_START_DATE, 4001, terminal.Name, 'null', '2014-05-30', null, null, null);
*/ 
    } 
    
    
    /**
     * End date cannot occur before the start date.
     */ 
    static testMethod void endDateBeforeStartDate() { 
        
        // Client input
        String terminalId = 'T0181'; 
        String testStartDate = '2014-05-30';
        String testEndDate = '2014-05-29';
        
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse(); 
        
        RestContext.request = req; 
        RestContext.response = res; 
        
        // Set request URI 
        req.requestURI = SERVICE_URI + terminalId + PERFORMANCE_URI;
        
        req.addParameter(START_DATE_PARAM, testStartDate);
        req.addParameter(END_DATE_PARAM, testEndDate); 
        
        SNG_REST_JsonResponse outputResult = SNG_REST_PerfHistory.getPerformanceHistory();
        
        compareResponses(outputResult, SNGHttpUtilities.Status.INPUT_VALIDATION_ERROR, 
                        SNG_REST_Error.SubCode.SALESFORCE_GENERATED_ERROR, 
                        SNG_REST_Error.END_DATE_BEFORE_START_DATE, null);       
/*      
        jsonVerifier(RestContext.response, 'INPUT_VALIDATION_ERROR', SNG_REST_Error.END_DATE_BEFORE_START_DATE, 4001, 'T0181', '2014-05-30', '2014-05-29', null, null, null);
*/      
    }
    
    
    /**
     * Start Date more than 60 days old. 
     */ 
    static testMethod void startDateOlderThan60Days() { 
        
        String startMonth; 
        String startDay;
        String endMonth;
        String endDay;
        
        // Client input
        String terminalId = 'T0181';
        
        // Build start date
        Date dateStart = SNG_DateUtils.todayGmt().addDays(-61);
        String startYear = String.valueOf(dateStart.year()); 
        
        if (dateStart.month() < 10) { 
            startMonth = '0' + String.valueOf(dateStart.month()); 
        }
        else { 
            startMonth = String.valueOf(dateStart.month()); 
        }
        
        if (dateStart.day() < 10) { 
            startDay = '0' + String.valueOf(dateStart.day()); 
        }
        else { 
            startDay = String.valueOf(dateStart.day());
        }
        
        // Build end Date
        Date dateEnd = dateStart.addDays(1); 
        String endYear = String.valueOf(dateEnd.year()); 

        if (dateEnd.month() < 10) { 
            endMonth = '0' + String.valueOf(dateEnd.month()); 
        }
        else { 
            endMonth = String.valueOf(dateEnd.month()); 
        }
        
        if (dateEnd.day() < 10) { 
            endDay = '0' + String.valueOf(dateEnd.day()); 
        }
        else { 
            endDay = String.valueOf(dateEnd.day());
        }
        
        // get start and end dates in proper format
        String testStartDate = startYear + '-' + startMonth + '-' + startDay; 
        String testEndDate = endYear + '-' + endMonth + '-' + endDay; 
        
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();

        RestContext.request = req; 
        RestContext.response = res;

        req.requestURI = SERVICE_URI + terminalId + PERFORMANCE_URI;

        req.addParameter(START_DATE_PARAM, testStartDate);
        req.addParameter(END_DATE_PARAM, testEndDate);     
        
        SNG_REST_JsonResponse outputResult = SNG_REST_PerfHistory.getPerformanceHistory();

        compareResponses(outputResult, SNGHttpUtilities.Status.INPUT_VALIDATION_ERROR, 
                        SNG_REST_Error.SubCode.SALESFORCE_GENERATED_ERROR, 
                        SNG_REST_PerfHistory.START_DATE_MORE_THAN_60_DAYS, null);
/*      
        jsonVerifier(RestContext.response, 'INPUT_VALIDATION_ERROR', SNG_REST_PerfHistory.START_DATE_MORE_THAN_60_DAYS, 4001, 
                        'T0181', testStartDate, testEndDate, null, null, null);  
*/                                      
    } 
    
    /**
     * Invalid End Date
     */ 
    static testMethod void validTerminalIdInvalidEndDate() { 
        
        SNG_MockCustomSettings.initialize();

        SNG_REST_JsonResponse outputResult; 
        
        // Insert Account, Terminal
        Account account = SNG_TestUtilities.insertAccount('testAccount'); 
        Terminal__c terminal = SNG_TestUtilities.insertTerminal(account, '11111', '1234561'); 
        terminal = [SELECT Id, Name FROM Terminal__c WHERE SerialNumber__c = '11111'];
        
        // Insert Modem, set lookup to terminal
        String macAddress = SNG_MockUTPerformanceHistoryHttpCallout.HTTP_STATUS_ONE_RESULT_MAC_ADDRESS; 
        Modem__c modem = SNG_TestUtilities.insertModem(account, '22222', macAddress, '12345', terminal);
        
        // Client Input
        String terminalId = terminal.Name;
        String testStartDate = '2014-05-29'; 
        
        String endDate_1 = '05-30-2014';        // StartDate must be in format YYYY-MM-DD
        String endDate_2 = '';                  // StartDate cannot be an empty string performance/raw/history?StartDate=&EndDate=2014-05-30
        String endDate_3 = null;                // StartDate cannot be null
        String endDate_4 = 'Test';              // StartDate must be a valid date in valid format
        String endDate_5 = '2014/05/30';        // StartDate must be in format YYYY-MM-DD 
        
        SNG_MockCustomSettings.initialize();

        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new SNG_MockUTPerformanceHistoryHttpCallout());
        
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();      

        RestContext.request = req;
        RestContext.response = res; 
        
        // Set RestRequest URI
        req.requestURI = SERVICE_URI + terminalId + PERFORMANCE_URI;
        
        // Set parameters for REST Request
        req.addParameter(START_DATE_PARAM, testStartDate);

        // Test endDate_1
        req.addParameter(END_DATE_PARAM, endDate_1); 
        outputResult = SNG_REST_PerfHistory.getPerformanceHistory(); 

        compareResponses(outputResult, SNGHttpUtilities.Status.INPUT_VALIDATION_ERROR, 
                        SNG_REST_Error.SubCode.SALESFORCE_GENERATED_ERROR, 
                        SNG_REST_Error.INVALID_DATE + ' Dates must be in YYYY-MM-DD format.',
                        null);      
/*      
        jsonVerifier(res, 'INPUT_VALIDATION_ERROR', SNG_REST_Error.INVALID_DATE + ' Dates must be in YYYY-MM-DD format.', 4001, terminal.Name, '2014-05-29', '05-30-2014', null, null, null);    
*/
        // Test endDate_2
        req.addParameter(END_DATE_PARAM, endDate_2); 
        outputResult = SNG_REST_PerfHistory.getPerformanceHistory(); 
        compareResponses(outputResult, SNGHttpUtilities.Status.INPUT_VALIDATION_ERROR, 
                        SNG_REST_Error.SubCode.SALESFORCE_GENERATED_ERROR, 
                        SNG_REST_Error.INVALID_DATE + ' Dates must be in YYYY-MM-DD format.',
                        null);          
/*
        jsonVerifier(res, 'INPUT_VALIDATION_ERROR', SNG_REST_Error.INVALID_DATE + ' Dates must be in YYYY-MM-DD format.', 4001, terminal.Name, '2014-05-29', '', null, null, null);
*/      
        // Test endDate_3
        req.addParameter(END_DATE_PARAM, endDate_3); 
        outputResult = SNG_REST_PerfHistory.getPerformanceHistory(); 
        compareResponses(outputResult, SNGHttpUtilities.Status.INPUT_VALIDATION_ERROR, 
                        SNG_REST_Error.SubCode.SALESFORCE_GENERATED_ERROR, 
                        SNG_REST_Error.MISSING_END_DATE,
                        null);  
/*
        jsonVerifier(res, 'INPUT_VALIDATION_ERROR', SNG_REST_Error.MISSING_END_DATE, 4001, terminal.Name, '2014-05-29', 'null', null, null, null); 
*/      
        // Test endDate_4
        req.addParameter(END_DATE_PARAM, endDate_4); 
        outputResult = SNG_REST_PerfHistory.getPerformanceHistory(); 
        compareResponses(outputResult, SNGHttpUtilities.Status.INPUT_VALIDATION_ERROR, 
                        SNG_REST_Error.SubCode.SALESFORCE_GENERATED_ERROR, 
                        SNG_REST_Error.INVALID_DATE + ' Dates must be in YYYY-MM-DD format.',
                        null);  
/*
        jsonVerifier(res, 'INPUT_VALIDATION_ERROR', SNG_REST_Error.INVALID_DATE + ' Dates must be in YYYY-MM-DD format.', 4001, terminal.Name, '2014-05-29', 'Test', null, null, null);                     
*/    
        // Test endDate_5
        req.addParameter(END_DATE_PARAM, endDate_5); 
        outputResult = SNG_REST_PerfHistory.getPerformanceHistory(); 
        compareResponses(outputResult, SNGHttpUtilities.Status.INPUT_VALIDATION_ERROR, 
                        SNG_REST_Error.SubCode.SALESFORCE_GENERATED_ERROR, 
                        SNG_REST_Error.INVALID_DATE + ' Dates must be in YYYY-MM-DD format.',
                        null);      
/*      
        jsonVerifier(res, 'INPUT_VALIDATION_ERROR', SNG_REST_Error.INVALID_DATE + ' Dates must be in YYYY-MM-DD format.', 4001, terminal.Name, '2014-05-29', '2014/05/30', null, null, null);           
*/    
        Test.stopTest(); 
    } 
    
    
    /**
     * Missing End Date Parameter
     */
    static testMethod void missingEndDateParameter() { 
        
        // Client Input
        String terminalId = 'T0181';
        String testStartDate = '2014-05-29'; 
        
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();      
        
        RestContext.request = req; 
        RestContext.response = res;
        
        // Set request URI 
        req.requestURI = SERVICE_URI + terminalId + PERFORMANCE_URI;
        
        req.addParameter(START_DATE_PARAM, testStartDate); 
        
        SNG_REST_JsonResponse outputResult = SNG_REST_PerfHistory.getPerformanceHistory();
        compareResponses(outputResult, SNGHttpUtilities.Status.INPUT_VALIDATION_ERROR, 
                        SNG_REST_Error.SubCode.SALESFORCE_GENERATED_ERROR, 
                        SNG_REST_Error.MISSING_END_DATE,
                        null);  
/*
        jsonVerifier(RestContext.response, 'INPUT_VALIDATION_ERROR', SNG_REST_Error.MISSING_END_DATE, 4001, 'T0181', '2014-05-29', 'null', null, null, null);
*/       
    }
    
    
    /**
     * Receive a Bad Response
     */ 
    static testMethod void badResponseFromInputValidationException() { 
        
        SNG_MockCustomSettings.initialize();

        // Insert Account, Terminal
        Account account = SNG_TestUtilities.insertAccount('testAccount'); 
        Terminal__c terminal = SNG_TestUtilities.insertTerminal(account, '11111', '1234561'); 
        terminal = [SELECT Id, Name FROM Terminal__c WHERE SerialNumber__c = '11111'];
        
        // Insert Modem, set lookup to terminal
        String macAddress = SNG_MockUTPerformanceHistoryHttpCallout.BAD_REQUEST; 
        Modem__c modem = SNG_TestUtilities.insertModem(account, '22222', macAddress, '12345', terminal);  
        
        // Client input
        String terminalId = terminal.Name;

        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new SNG_MockUTPerformanceHistoryHttpCallout());
                
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse(); 
        
        RestContext.request = req;
        RestContext.response = res;     
        
        // Set request URI 
        req.requestURI = SERVICE_URI + terminalId + PERFORMANCE_URI;
        
        req.addParameter(START_DATE_PARAM, validStartDate);
        req.addParameter(END_DATE_PARAM, validEndDate);
        
        SNG_REST_JsonResponse outputResult = SNG_REST_PerfHistory.getPerformanceHistory();

        compareResponses(outputResult, SNGHttpUtilities.Status.INPUT_VALIDATION_ERROR, 
                        SNG_REST_Error.SubCode.WEBSERVICE_GENERATED_ERROR, 
                        SNG_REST_PerfHistory.DATE_YEAR_LIMITS,
                        null);          
/*
        jsonVerifier(res, 'INPUT_VALIDATION_ERROR', SNG_REST_PerfHistory.DATE_YEAR_LIMITS, 4002, terminal.Name, validStartDate, validEndDate, null, null, null);
*/      
        Test.stopTest(); 
    }

    static testMethod void badResponse() { 
        
        SNG_MockCustomSettings.initialize();

        // Insert Account, Terminal
        Account account = SNG_TestUtilities.insertAccount('testAccount'); 
        Terminal__c terminal = SNG_TestUtilities.insertTerminal(account, '11111', '1234561'); 
        terminal = [SELECT Id, Name FROM Terminal__c WHERE SerialNumber__c = '11111'];
        
        // Insert Modem, set lookup to terminal
        String macAddress = SNG_MockUTPerformanceHistoryHttpCallout.BAD_REQUEST_DIFF_STATUS; 
        Modem__c modem = SNG_TestUtilities.insertModem(account, '22222', macAddress, '12345', terminal);
        
        // Client Input
        String terminalId = terminal.Name;  
        
        Test.startTest(); 
        Test.setMock(HttpCalloutMock.class, new SNG_MockUTPerformanceHistoryHttpCallout());
        
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse(); 
        
        RestContext.request = req;
        RestContext.response = res; 

        // Set request URI 
        req.requestURI = SERVICE_URI + terminalId + PERFORMANCE_URI;
        
        req.addParameter(START_DATE_PARAM, validStartDate);
        req.addParameter(END_DATE_PARAM, validEndDate);  
        
        SNG_REST_JsonResponse outputResult = SNG_REST_PerfHistory.getPerformanceHistory(); 
    
        compareResponses(outputResult,SNGHttpUtilities.Status.SERVER_ERROR, 
                        SNG_REST_Error.SubCode.WEBSERVICE_GENERATED_ERROR, 
                        SNG_REST_Error.GENERIC_WEBSERVICE_ERROR,
                        null); 
        
/*      
        jsonVerifier(res, 'SERVER_ERROR', SNG_REST_Error.GENERIC_WEBSERVICE_ERROR, 3002, terminal.Name, validStartDate, validEndDate, null, null, null);
*/                  
    }
    
    /**
     * Receive a Not Found
     */ 
    static testMethod void notFoundResponse() { 
        
        SNG_MockCustomSettings.initialize();

        // Insert Account, Terminal
        Account account = SNG_TestUtilities.insertAccount('testAccount'); 
        Terminal__c terminal = SNG_TestUtilities.insertTerminal(account, '11111', '1234561'); 
        terminal = [SELECT Id, Name FROM Terminal__c WHERE SerialNumber__c = '11111'];
        
        // Insert Modem, set lookup to terminal
        String macAddress = SNG_MockUTPerformanceHistoryHttpCallout.HTTP_ERROR_404_MAC_ADDRESS; 
        Modem__c modem = SNG_TestUtilities.insertModem(account, '22222', macAddress, '12345', terminal);  
        
        // Client input
        String terminalId = terminal.Name;

        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new SNG_MockUTPerformanceHistoryHttpCallout());
                
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse(); 
        
        RestContext.request = req;
        RestContext.response = res;     
        
        // Set request URI 
        req.requestURI = SERVICE_URI + terminalId + PERFORMANCE_URI;
        
        req.addParameter(START_DATE_PARAM, validStartDate);
        req.addParameter(END_DATE_PARAM, validEndDate);
        
        SNG_REST_JsonResponse outputResult = SNG_REST_PerfHistory.getPerformanceHistory();

        compareResponses(outputResult,SNGHttpUtilities.Status.SERVER_ERROR, 
                        SNG_REST_Error.SubCode.WEBSERVICE_GENERATED_ERROR, 
                        SNG_REST_Error.GENERIC_WEBSERVICE_ERROR,
                        null); 
/*      
        jsonVerifier(res, 'SERVER_ERROR', SNG_REST_Error.GENERIC_WEBSERVICE_ERROR, 3002, terminal.Name, validStartDate, validEndDate, null, null, null);
*/      
        Test.stopTest(); 
    }
    
    static testMethod void zeroResultsFromPmdr() { 

        SNG_MockCustomSettings.initialize();

        // Insert Account, Terminal
        Account account = SNG_TestUtilities.insertAccount('testAccount'); 
        Terminal__c terminal = SNG_TestUtilities.insertTerminal(account, '11111', '1234561'); 
        terminal = [SELECT Id, Name FROM Terminal__c WHERE SerialNumber__c = '11111'];
        
        // Insert modem, set lookup to terminal  
        String macAddress = SNG_MockUTPerformanceHistoryHttpCallout.ZERO_RESULTS_MAC_ADDRESS; 
        Modem__c modem = SNG_TestUtilities.insertModem(account, '22222', macAddress, '12345', terminal);    
        
        // Client input
        String terminalId = terminal.Name;          // use inserted terminal so can bypass ZERO_RESULTS check 

        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new SNG_MockUTPerformanceHistoryHttpCallout());

        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse(); 
        
        RestContext.request = req;
        RestContext.response = res;
        
        req.requestURI = SERVICE_URI + terminalId + PERFORMANCE_URI; 
        
        req.addParameter(START_DATE_PARAM, validStartDate);
        req.addParameter(END_DATE_PARAM, validEndDate);
        
        SNG_REST_JsonResponse outputResult = SNG_REST_PerfHistory.getPerformanceHistory();

        compareResponses(outputResult,SNGHttpUtilities.Status.ZERO_RESULTS, 
                        SNG_REST_Error.SubCode.WEBSERVICE_GENERATED_ERROR, 
                        SNG_REST_PerfHistory.NO_PERFORMANCE_HISTORY,
                        null); 
/*      
        jsonVerifier(res, 'ZERO_RESULTS', SNG_REST_PerfHistory.NO_PERFORMANCE_HISTORY, 1002, terminal.Name, validStartDate, validEndDate, null, null, null);
*/      
        Test.stopTest();
    }
    
    /**
     * OK Response from HTTP, but unknown status 
     */ 
    static testMethod void okResponseUnknownPmdrStatus() { 

        SNG_MockCustomSettings.initialize();

        // Insert Account, Terminal
        Account account = SNG_TestUtilities.insertAccount('testAccount'); 
        Terminal__c terminal = SNG_TestUtilities.insertTerminal(account, '11111', '1234561'); 
        terminal = [SELECT Id, Name FROM Terminal__c WHERE SerialNumber__c = '11111'];
        
        // Insert Modem, set lookup to terminal
        String macAddress = SNG_MockUTPerformanceHistoryHttpCallout.HTTP_STATUS_DIFF_STATUS; 
        Modem__c modem = SNG_TestUtilities.insertModem(account, '22222', macAddress, '12345', terminal);
                
        // Client input
        String terminalId = terminal.Name;          // use inserted terminal so can bypass ZERO_RESULTS check 
        
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new SNG_MockUTPerformanceHistoryHttpCallout());
        
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse(); 
        
        RestContext.request = req;
        RestContext.response = res;
        
        req.requestURI = SERVICE_URI + terminalId + PERFORMANCE_URI; 
        
        req.addParameter(START_DATE_PARAM, validStartDate);
        req.addParameter(END_DATE_PARAM, validEndDate);
        
        SNG_REST_JsonResponse outputResult = SNG_REST_PerfHistory.getPerformanceHistory();

        compareResponses(outputResult,SNGHttpUtilities.Status.SERVER_ERROR, 
                        SNG_REST_Error.SubCode.WEBSERVICE_GENERATED_ERROR, 
                        SNG_REST_Error.GENERIC_WEBSERVICE_ERROR,
                        null); 
/*      
        jsonVerifier(res, 'SERVER_ERROR', SNG_REST_Error.GENERIC_WEBSERVICE_ERROR, 3002, terminal.Name, validStartDate, validEndDate, null, null, null);
*/      
        Test.stopTest();
    }
    
    
    /**
     * Verify JSON contents are correct
     */    
    private static void jsonVerifier(RestResponse res, String statusExpected, String errorMessageExpected, Integer errorCodeExpected, 
                                    String terminalIdExpected, String startDateExpected, String endDateExpected,
                                    String uploadSymbolRateExpected, String timestampExpected, String downloadSinrExpected) 
    { 
        JSONParser parser = JSON.createParser(res.responseBody.toString()); 
        
        while (parser.nextToken() != null) 
        { 
            if (parser.getCurrentName() == 'status') 
            {
                parser.nextToken(); 
                String status = parser.getText(); 
                System.assertEquals(statusExpected, status); 
            }
            else if (parser.getCurrentName() == 'errorMessage')
            { 
                parser.nextToken(); 
                String errorMessage = parser.getText(); 
                System.assertEquals(errorMessageExpected, errorMessage); 
            }
            else if (parser.getCurrentName() == 'errorCode')
            { 
                parser.nextToken(); 
                Integer errorCode = parser.getIntegerValue(); 
                System.assertEquals(errorCodeExpected, errorCode); 
            }
            else if (parser.getCurrentName() == 'data')
            { 
                // iterate through data
                while (parser.nextToken() != null)  
                { 
                    if (parser.getCurrentName() == 'terminalId') 
                    { 
                        parser.nextToken();
                        String terminalId = parser.getText();
                        System.assertEquals(terminalIdExpected, terminalId);
                    }
                    else if (parser.getCurrentName() == 'startDate')
                    { 
                        parser.nextToken(); 
                        String startDate = parser.getText(); 
                        System.assertEquals(startDateExpected, startDate);                  
                    }
                    else if (parser.getCurrentName() == 'endDate')
                    { 
                        parser.nextToken(); 
                        String endDate = parser.getText(); 
                        System.assertEquals(endDateExpected, endDate);                  
                    }
                    else if (parser.getText() == 'items')
                    { 
                        if (uploadSymbolRateExpected != null && timestampExpected != null && downloadSinrExpected != null)
                        { 
                            // skip the '[' token, iterate through items
                            while (parser.nextToken() != null)
                            {
                                if (parser.getCurrentName() == 'uploadSymbolRate')
                                { 
                                    parser.nextToken(); 
                                    Integer uploadSymbolRate = parser.getIntegerValue(); 
                                    System.assertEquals(Integer.valueOf(uploadSymbolRateExpected), uploadSymbolRate);
                                }
                                else if (parser.getCurrentName() == 'timestamp')
                                { 
                                    parser.nextToken(); 
                                    Integer timestamp = parser.getIntegerValue(); 
                                    System.assertEquals(Integer.valueOf(timestampExpected), timestamp); 
                                }
                                else if (parser.getCurrentName() == 'downloadSinr')
                                {
                                    parser.nextToken(); 
                                    Decimal downloadSinr = parser.getDecimalValue();
                                    System.assertEquals(Decimal.valueOf(downloadSinrExpected), downloadSinr);                               }
                            }       
                        }
                        // items is null
                        else 
                        { 
                            parser.nextToken(); 
                            String itemsValue = parser.getText();
                            System.assertEquals('null', itemsValue); 
                        }
                    }   
                }// end of inner while loop 
            }// end of Data token iteration 
        }// end of outer while loop
    }// end of jsonVerifier 

    //**********************************************************
    //  TEST SNG_REST_QueryAllTerminalIds
    //**********************************************************
    private static final String ALL_TERMINALS_URI = '/terminals/ids';
    
    private static testMethod void getZeroResults() 
    {
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse(); 
        
        // set the request URL ;
        req.requestURI = ALL_TERMINALS_URI;
        
        // set the request method
        req.httpMethod = 'GET'; 
        
        // RestContext contains the RestRequest and RestResponse objects in REST methods
        RestContext.request = req; 
        RestContext.response = res; 
        
        SNG_REST_JSONResponse response = SNG_REST_QueryAllTerminalIds.get(); 
        
        SNG_REST_JsonResponse expectedOutput = new SNG_REST_JsonResponse(SNGHttpUtilities.Status.ZERO_RESULTS,
                                                                         null,
                                                                         null,
                                                                         null);
        System.assert(response == expectedOutput);
    }
    
    private static testMethod void getSunnyDay() 
    {
        SNG_MockCustomSettings.initialize();

        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse(); 

        String t1Nickname = 'Terminal1';
        String t2Nickname = 'Terminal2';
        SNG_TestUtilities.insertEquipment(t1Nickname, '00:a0:bc:11:22:33', 'Red Cross 1', 'ser1', true, '1234561');
        SNG_TestUtilities.insertEquipment(t2Nickname, '00:a0:bc:11:22:44', 'Red Cross 2', 'ser2', true, '7654321');
      
      
        Terminal__c terminal1 = [SELECT Name FROM Terminal__c WHERE Nickname__c = :t1Nickname];
        Terminal__c terminal2 = [SELECT Name FROM Terminal__c WHERE Nickname__c = :t2Nickname];
        
        
        // set the request URL ;
        req.requestURI = ALL_TERMINALS_URI;
        
        // set the request method
        req.httpMethod = 'GET'; 
        
        // RestContext contains the RestRequest and RestResponse objects in REST methods
        RestContext.request = req; 
        RestContext.response = res; 
        
        SNG_REST_JSONResponse response = SNG_REST_QueryAllTerminalIds.get(); 
        
        
        List<String> expectedIds = new List<String>();
        expectedIds.add(terminal1.Name);
        expectedIds.add(terminal2.Name);
        
        
        SNG_REST_JsonResponse expectedOutput = new SNG_REST_JsonResponse(SNGHttpUtilities.Status.OK,
                                                                         null,
                                                                         null,
                                                                         new SNG_REST_CollectionOutput(expectedIds));
        System.assert(response == expectedOutput);
    }
    
    private static testMethod void getSunnyDayWithParameters() 
    {
        SNG_MockCustomSettings.initialize();

        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse(); 

        String t1Nickname = 'Terminal1';
        String t2Nickname = 'Terminal2';
        SNG_TestUtilities.insertEquipment(t1Nickname, '00:a0:bc:11:22:33', 'Red Cross 1', 'ser1', true, '1234567');
        SNG_TestUtilities.insertEquipment(t2Nickname, '00:a0:bc:11:22:44', 'Red Cross 2', 'ser2', true, '7654321');
      
      
        Terminal__c terminal1 = [SELECT Name FROM Terminal__c WHERE Nickname__c = :t1Nickname];
        Terminal__c terminal2 = [SELECT Name FROM Terminal__c WHERE Nickname__c = :t2Nickname];
        
        List<String> terminals = new List<String>();
        terminals.add(terminal1.Name);
        terminals.add(terminal2.Name);
        
        
        System.debug('output: ' + getCommaSeperatedString(terminals));
        
        // set the request URL ;
        req.requestURI = ALL_TERMINALS_URI;
        
        // set the request method
        req.httpMethod = 'GET'; 
        req.addParameter('ids', getCommaSeperatedString(terminals));
        
        // RestContext contains the RestRequest and RestResponse objects in REST methods
        RestContext.request = req; 
        RestContext.response = res; 
        
        SNG_REST_JSONResponse response = SNG_REST_QueryAllTerminalIds.get(); 
        
        
        List<String> expectedIds = new List<String>();
        expectedIds.add(terminal1.Name);
        expectedIds.add(terminal2.Name); 
        
        SNG_REST_JsonResponse expectedOutput = new SNG_REST_JsonResponse(SNGHttpUtilities.Status.OK,
                                                                         null,
                                                                         null,
                                                                         new SNG_REST_CollectionOutput(expectedIds));
        System.assert(response == expectedOutput);
    }
    
    
    private static testMethod void getSunnyDayWithOneParameterInvalid() 
    {
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse(); 

        String t1Nickname = 'Terminal1';
        String t2Nickname = 'Terminal2';
        SNG_TestUtilities.insertEquipment(t1Nickname, '00:a0:bc:11:22:33', 'Red Cross', true);

        Terminal__c terminal1 = [SELECT Name FROM Terminal__c WHERE Nickname__c = :t1Nickname];
        
        List<String> terminals = new List<String>();
        terminals.add(terminal1.Name);
        terminals.add('T9876');
        
        // set the request URL ;
        req.requestURI = ALL_TERMINALS_URI;
        
        // set the request method
        req.httpMethod = 'GET'; 
        req.addParameter('ids', getCommaSeperatedString(terminals));
        
        // RestContext contains the RestRequest and RestResponse objects in REST methods
        RestContext.request = req; 
        RestContext.response = res; 
        
        SNG_REST_JSONResponse response = SNG_REST_QueryAllTerminalIds.get(); 
        
        
        List<String> expectedIds = new List<String>();
        expectedIds.add(terminal1.Name);        
                
        SNG_REST_JsonResponse expectedOutput = new SNG_REST_JsonResponse(SNGHttpUtilities.Status.OK_WITH_ERRORS,
                                                                         SNG_REST_Error.SubCode.SALESFORCE_GENERATED_ERROR,
                                                                         SNG_REST_Error.IDS_INVALID,
                                                                         new SNG_REST_CollectionOutput(expectedIds));
        
        System.debug('Response: ' + response.toString());
        System.debug('Expected: ' + expectedOutput.toString());
        
        System.assert(response == expectedOutput);
    }
    
    private static testMethod void getZeroResultsWithInvalidParameter() 
    {
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse(); 

   
        List<String> terminals = new List<String>();
        terminals.add('T9876');
        
        // set the request URL ;
        req.requestURI = ALL_TERMINALS_URI;
        
        // set the request method
        req.httpMethod = 'GET'; 
        req.addParameter('ids', getCommaSeperatedString(terminals));
        
        // RestContext contains the RestRequest and RestResponse objects in REST methods
        RestContext.request = req; 
        RestContext.response = res; 
        
        SNG_REST_JSONResponse response = SNG_REST_QueryAllTerminalIds.get();  
                
        SNG_REST_JsonResponse expectedOutput = new SNG_REST_JsonResponse(SNGHttpUtilities.Status.ZERO_RESULTS,
                                                                         SNG_REST_Error.SubCode.SALESFORCE_GENERATED_ERROR,
                                                                         SNG_REST_Error.IDS_INVALID,
                                                                         null);
        
        System.debug('Response: ' + response.toString());
        System.debug('Expected: ' + expectedOutput.toString());
        
        System.assert(response == expectedOutput);
    }
    
    private static String getCommaSeperatedString(List<String> stringList)
    {
        String retValue = '';
        
        for (integer i = 0; i < stringList.size(); ++i)
        {
            retValue += (i + 1 < stringList.size()) ? (stringList.get(i) + ',') : stringList.get(i);
        }
        
        return retValue;
        
    }
    
    //**********************************************************
    // TEST SNG_REST_InstanceUnitTest
    //**********************************************************
    static testMethod void handleRequestNullCollectionObject() {
        
        // Create RestRequest and RestResponse objects
        RestRequest req = new RestRequest();   
        RestResponse res = new RestResponse(); 
                
        // set the request URL 
        //String restResUrl = 'https://viasat--deveecp.cs30.my.salesforce.com/services/apexrest/terminal/mac-address/';
        req.requestURI = '/services/terminal/T1000/test';
        req.resourcePath = '/services/terminal/*/test';
        req.httpMethod = 'POST';
      
        // Set RestContext's request and response to the new objects since they are null originally 
        // There is no RestContext set since this method is not called through a Rest Request
        RestContext.request = req; 
        RestContext.response = res; 
        
        SNG_REST_Instance restInstance = new SNG_REST_Instance();
        
        SNG_REST_JsonResponse actualResponse = restInstance.handleRequest(RestContext.request, null);
        SNG_REST_JsonResponse expectedResponse = new SNG_REST_JsonResponse(
            new SNG_REST_StatusDetail( SNGHttpUtilities.Status.SERVER_ERROR, 
                                       SNG_REST_Error.SubCode.SALESFORCE_GENERATED_ERROR, 
                                       SNG_REST_ERROR.INTERNAL_SERVER_ERROR ), 
            null);
        System.assertEquals(expectedResponse, actualResponse);
    }
    
    static testMethod void handleRequestNullNoWildcardInPath() {
        
        // Create RestRequest and RestResponse objects
        RestRequest req = new RestRequest();   
        RestResponse res = new RestResponse(); 
                
        // set the request URL 
        //String restResUrl = 'https://viasat--deveecp.cs30.my.salesforce.com/services/apexrest/terminal/mac-address/';
        req.requestURI = '/services/terminal/T1000/test';
        req.resourcePath = '/services/terminal/T1000/test'; //missing wildcard
        req.httpMethod = 'POST';
      
        // Set RestContext's request and response to the new objects since they are null originally 
        // There is no RestContext set since this method is not called through a Rest Request
        RestContext.request = req; 
        RestContext.response = res; 
        
        SNG_REST_Instance restInstance = new SNG_REST_Instance();
        
        SNG_REST_JsonResponse actualResponse = restInstance.handleRequest(RestContext.request, new SNG_REST_Mock_CollectionHandler());
        SNG_REST_JsonResponse expectedResponse = new SNG_REST_JsonResponse(
            new SNG_REST_StatusDetail( SNGHttpUtilities.Status.SERVER_ERROR, 
                                       SNG_REST_Error.SubCode.SALESFORCE_GENERATED_ERROR, 
                                       SNG_REST_ERROR.INTERNAL_SERVER_ERROR ), 
            null);
        System.assertEquals(expectedResponse, actualResponse);
    }
    
    static testMethod void handleRequestNullTooManyWildcardsInPath() {
        
        // Create RestRequest and RestResponse objects
        RestRequest req = new RestRequest();   
        RestResponse res = new RestResponse(); 
                
        // set the request URL 
        //String restResUrl = 'https://viasat--deveecp.cs30.my.salesforce.com/services/apexrest/terminal/mac-address/';
        req.requestURI = '/services/terminal/T1000/test/tooManyWildcards';
        req.resourcePath = '/services/terminal/*/test/*'; //too many wildcards
        req.httpMethod = 'POST';
      
        // Set RestContext's request and response to the new objects since they are null originally 
        // There is no RestContext set since this method is not called through a Rest Request
        RestContext.request = req; 
        RestContext.response = res; 
        
        SNG_REST_Instance restInstance = new SNG_REST_Instance();
        
        SNG_REST_JsonResponse actualResponse = restInstance.handleRequest(RestContext.request, new SNG_REST_Mock_CollectionHandler());
        SNG_REST_JsonResponse expectedResponse = new SNG_REST_JsonResponse(
            new SNG_REST_StatusDetail( SNGHttpUtilities.Status.SERVER_ERROR, 
                                       SNG_REST_Error.SubCode.SALESFORCE_GENERATED_ERROR, 
                                       SNG_REST_ERROR.INTERNAL_SERVER_ERROR ), 
            null);
        System.assertEquals(expectedResponse, actualResponse);
    }
    
     static testMethod void handleRequestSingleDataResponse()
     {   
        // Create RestRequest and RestResponse objects
        RestRequest req = new RestRequest();   
        RestResponse res = new RestResponse(); 
                
        // set the request URL 
        //String restResUrl = 'https://viasat--deveecp.cs30.my.salesforce.com/services/apexrest/terminal/mac-address/';
        req.requestURI = '/services/terminal/T1000/test';
        req.resourcePath = '/services/terminal/*/test';
        req.httpMethod = 'POST';
      
        // Set RestContext's request and response to the new objects since they are null originally 
        // There is no RestContext set since this method is not called through a Rest Request
        RestContext.request = req; 
        RestContext.response = res; 
        
        SNG_REST_Instance restInstance = new SNG_REST_Instance();
        
        SNG_REST_Mock_CollectionHandler collectionHandler = new SNG_REST_Mock_CollectionHandler();
        collectionHandler.desiredResponse = SNG_REST_Mock_CollectionHandler.ResponseEnum.SAMPLE_SINGLE_DATA_COLLECTION_INT;
        
        SNG_REST_JsonResponse response = restInstance.handleRequest(RestContext.request, collectionHandler);
        
        SNG_REST_Mock_CollectionHandler.SNG_REST_Mock_CollectionHandler_Output collectionOutput =  
                    (SNG_REST_Mock_CollectionHandler.SNG_REST_Mock_CollectionHandler_Output)response.data;
                    
        System.assertEquals(SNG_REST_Mock_CollectionHandler.SINGLE_DATA_RESPONSE_VALUE, collectionOutput.value);
     }
     
     static testMethod void handleRequestTwoDataResponse() 
     {   
        // Create RestRequest and RestResponse objects
        RestRequest req = new RestRequest();   
        RestResponse res = new RestResponse(); 
                
        // set the request URL 
        //String restResUrl = 'https://viasat--deveecp.cs30.my.salesforce.com/services/apexrest/terminal/mac-address/';
        req.requestURI = '/services/terminal/T1000/test';
        req.resourcePath = '/services/terminal/*/test';
        req.httpMethod = 'POST';
      
        // Set RestContext's request and response to the new objects since they are null originally 
        // There is no RestContext set since this method is not called through a Rest Request
        RestContext.request = req; 
        RestContext.response = res; 
        
        SNG_REST_Instance restInstance = new SNG_REST_Instance();
        
        SNG_REST_Mock_CollectionHandler collectionHandler = new SNG_REST_Mock_CollectionHandler();
        collectionHandler.desiredResponse = SNG_REST_Mock_CollectionHandler.ResponseEnum.SAMPLE_TWO_DATA_COLLECTION_INT;
        
        SNG_REST_JsonResponse actualResponse = restInstance.handleRequest(RestContext.request, collectionHandler);
        SNG_REST_JsonResponse expectedResponse = new SNG_REST_JsonResponse(
            new SNG_REST_StatusDetail( SNGHttpUtilities.Status.SERVER_ERROR, 
                                       SNG_REST_Error.SubCode.SALESFORCE_GENERATED_ERROR, 
                                       SNG_REST_ERROR.INTERNAL_SERVER_ERROR ), 
            null);
        System.assertEquals(expectedResponse, actualResponse);
     }
     
    //**********************************************************
    // TEST SNG_REST_ModemSoftwareVersionUnitTest
    //**********************************************************
    static testMethod void sunnyDay() {
        
        SNG_MockCustomSettings.initialize(); 
        Test.setMock(HttpCalloutMock.class, new SNGMockModemSoftwareVersionHttpCallout());
        Test.startTest(); 
        
        List<String> modems = new List<String>();
        modems.add(SNGMockModemSoftwareVersionHttpCallout.MACADDR_OK);
        
        SNG_Perf.UtPhyVersion response = SNG_REST_ModemSoftwareVersion.get(modems);
        
        Test.stopTest();  
        System.assertEquals('OK', response.status);
        System.assertEquals(1, response.result.size());
        System.assertEquals('00:a0:bc:11:11:11', response.result.get(0).MACADDR);
        System.assertEquals('UT_1.3.4', response.result.get(0).SOFTWAREVERSION);
    }
     
    static testMethod void zeroResults() {
        
        SNG_MockCustomSettings.initialize(); 
        Test.setMock(HttpCalloutMock.class, new SNGMockModemSoftwareVersionHttpCallout());
        Test.startTest(); 
        
        List<String> modems = new List<String>();
        modems.add(SNGMockModemSoftwareVersionHttpCallout.MACADDR_ZERO_RESULTS);
        
        SNG_Perf.UtPhyVersion response = SNG_REST_ModemSoftwareVersion.get(modems); 
        
        Test.stopTest();
        System.assertEquals('ZERO_RESULTS', response.status);
        System.assertEquals(0, response.result.size());
    }
  
    
    static testMethod void httpError() { 

        SNG_MockCustomSettings.initialize(); 
        Test.setMock(HttpCalloutMock.class, new SNGMockModemSoftwareVersionHttpCallout());
        Test.startTest(); 
        
        List<String> modems = new List<String>();
        modems.add(SNGMockModemSoftwareVersionHttpCallout.MACADDR_HTTP_ERROR);
        
        SNG_Perf.UtPhyVersion response = SNG_REST_ModemSoftwareVersion.get(modems); 
        
        Test.stopTest();
        System.assertEquals('SERVER_ERROR', response.status);
        System.assertEquals(0, response.result.size());
    }

    //**********************************************************
    // TEST SNG_REST_StatusLightUnitTest
    //**********************************************************
    static testMethod void testGetStatus() 
    {    
        System.assertEquals(SNG_REST_StatusLight.Status.NO_ISSUES, SNG_REST_StatusLight.getStatus(SNGTerminalStatusLight.GREEN_DOT_FILENAME));
        System.assertEquals(SNG_REST_StatusLight.Status.MINOR_ISSUES, SNG_REST_StatusLight.getStatus(SNGTerminalStatusLight.YELLOW_DOT_FILENAME));
        System.assertEquals(SNG_REST_StatusLight.Status.SEVERE_ISSUES, SNG_REST_StatusLight.getStatus(SNGTerminalStatusLight.RED_DOT_FILENAME));
        System.assertEquals(SNG_REST_StatusLight.Status.OFFLINE, SNG_REST_StatusLight.getStatus(SNGTerminalStatusLight.GRAY_DOT_FILENAME));
    }

    //**********************************************************
    // TEST SNG_REST_TerminalIdUnitTest
    //**********************************************************
    private static testMethod void validMacAddressNoResults() 
    {
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse(); 
        
        // set the request URL 
        String macAddress = '00:a0:bc:11:22:33';
        req.requestURI = '/modem/' + macAddress + '/terminal-id';
        req.resourcePath = '/modem/*/terminal-id';

        // set the request method
        req.httpMethod = 'GET'; 
        
        // RestContext contains the RestRequest and RestResponse objects in REST methods
        RestContext.request = req; 
        RestContext.response = res; 
        
        SNG_REST_JsonResponse response = SNG_REST_TerminalIdApi.getTerminalId(); 

        SNG_REST_JsonResponse expectedOutput = new SNG_REST_JsonResponse(SNGHttpUtilities.Status.ZERO_RESULTS,
                                                                         SNG_REST_Error.SubCode.SALESFORCE_GENERATED_ERROR,
                                                                         SNG_REST_ERROR.IDS_INVALID,
                                                                         null);
        System.assertEquals(expectedOutput, response);
    }
    
    private static testMethod void methodCallNotFromRestfulUriRequest() 
    {
        try
        {
            SNG_REST_TerminalIdApi.getTerminalId();
            System.assert(false);
        }
        catch (Exception e)
        {
            System.assert(true);
        }
    }
    
    private static testMethod void invalidMacAddress() 
    {
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse(); 
        
        // set the request URL 
        String macAddress = '00:f0:ad:11:22:';
        req.requestURI = '/modem/' + macAddress + '/terminal-id';
        req.resourcePath = '/modem/*/terminal-id';

        // set the request method
        req.httpMethod = 'GET'; 
        
        // RestContext contains the RestRequest and RestResponse objects in REST methods
        RestContext.request = req; 
        RestContext.response = res; 
        
        SNG_REST_JsonResponse response = SNG_REST_TerminalIdApi.getTerminalId(); 

        SNG_REST_JsonResponse expectedOutput = new SNG_REST_JsonResponse(SNGHttpUtilities.Status.INPUT_VALIDATION_ERROR,
                                                                         SNG_REST_Error.SubCode.SALESFORCE_GENERATED_ERROR,
                                                                         SNG_REST_ERROR.INPUT_INVALID_FORMAT,
                                                                         null);
        System.assertEquals(expectedOutput, response);
    }
    
    private static testMethod void validMacAddressToTerminalSunnyDay() 
    {
        String macAddressSalesforceFormat = '00:a0:bc:11:22:33';
        String macAddressUrlEncoded = '00%3Aa0%3Abc%3A11%3A22%3A33';
        String macAddressNoColons = '00a0bc112233';

        String equipmentName = 'T1234';
        SNG_TestUtilities.insertEquipment(equipmentName, macAddressSalesforceFormat, SNG_TestUtilities.insertAccount('Red Cross'), true);
      
        Terminal__c terminal = [SELECT Name FROM Terminal__c WHERE NickName__c = :equipmentName];
      
      
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse(); 
        
        // set the request method
        req.httpMethod = 'GET'; 

        // Set the resource path
        req.resourcePath = '/modem/*/terminal-id';

        // RestContext contains the RestRequest and RestResponse objects in REST methods
        RestContext.request = req; 
        RestContext.response = res; 

        // Create expected response
        SNG_REST_JsonResponse expectedOutput = new SNG_REST_JsonResponse(SNGHttpUtilities.Status.OK,
                                                                         null,
                                                                         null,
                                                                         new SNG_REST_TerminalIdMacAddressOutput(terminal.Name, macAddressSalesforceFormat));

        // TerminalId API call for MAC address in Salesforce format
        req.requestURI = '/modem/' + macAddressSalesforceFormat + '/terminal-id';
        SNG_REST_JsonResponse response = SNG_REST_TerminalIdApi.getTerminalId();
        System.assertEquals(expectedOutput, response);

        // TerminalId API call for MAC address in URL encoded format
        req.requestURI = '/modem/' + macAddressUrlEncoded + '/terminal-id';
        response = SNG_REST_TerminalIdApi.getTerminalId();
        System.assertEquals(expectedOutput, response);

        // TerminalId API call for MAC address with no colons format
        req.requestURI = '/modem/' + macAddressNoColons + '/terminal-id';
        response = SNG_REST_TerminalIdApi.getTerminalId();
        System.assertEquals(expectedOutput, response);
    }

    private static testMethod void validMacAddressToTerminalPluralSunnyDay() 
    {
        String[] macAddressesSalesforceFormat = new String[] { '00:a0:bc:11:22:33', '00:a0:bc:11:22:34' };
        String[] macAddressesUrlEncoded = new String[] { '00%3Aa0%3Abc%3A11%3A22%3A33', '00%3Aa0%3Abc%3A11%3A22%3A34' };
        String[] macAddressesNoColons = new String[] { '00a0bc112233', '00a0bc112234' };

        String[] equipmentNames = new String[] { 'T1234', 'T1235' };
        Account acc = SNG_TestUtilities.insertAccount('Red Cross');
        SNG_TestUtilities.insertEquipment(equipmentNames[0], macAddressesSalesforceFormat[0], acc, true);
        SNG_TestUtilities.insertEquipment(equipmentNames[1], macAddressesSalesforceFormat[1], acc, true);
      
        Terminal__c[] terminals = new Terminal__c[] {
            [SELECT Name FROM Terminal__c WHERE NickName__c = :equipmentNames.get(0)],
            [SELECT Name FROM Terminal__c WHERE NickName__c = :equipmentNames.get(1)]
        };
      
      
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse(); 
        
        // set the request method
        req.httpMethod = 'GET'; 

        // Set the resource path
        req.resourcePath = '/modems/terminal-id';

        // RestContext contains the RestRequest and RestResponse objects in REST methods
        RestContext.request = req; 
        RestContext.response = res;

        // Create expected response
        final SNG_REST_IJsonResponseData[] expectedResponseCollection = new SNG_REST_TerminalIdMacAddressOutput[] {
            new SNG_REST_TerminalIdMacAddressOutput(terminals[0].Name, macAddressesSalesforceFormat[0]),
            new SNG_REST_TerminalIdMacAddressOutput(terminals[1].Name, macAddressesSalesforceFormat[1])
        };
        final SNG_REST_JsonResponse expectedResponse = new SNG_REST_JsonResponse(
            new SNG_REST_Response(SNGHttpUtilities.Status.OK, null, null, new SNG_REST_CollectionOutput(expectedResponseCollection)));

        // TerminalIds API call for MAC addresses in Salesforce format
        req.requestURI = '/modems/terminal-id?ids=' + macAddressesSalesforceFormat[0] + ',' + macAddressesSalesforceFormat[1];
        SNG_REST_JsonResponse response = SNG_REST_TerminalIdsApi.getTerminalIds();
        verifyPluralResponse(expectedResponse, response);

        // TerminalIds API call for MAC addresses in URL encoded format
        req.requestURI = '/modems/terminal-ids?ids=' + macAddressesUrlEncoded[0] + ',' + macAddressesUrlEncoded[1];
        response = SNG_REST_TerminalIdsApi.getTerminalIds();
        verifyPluralResponse(expectedResponse, response);

        // TerminalIds API call for MAC addresses with no colons format
        req.requestURI = '/modems/terminal-ids?ids=' + macAddressesNoColons[0] + ',' + macAddressesNoColons[1];
        response = SNG_REST_TerminalIdsApi.getTerminalIds();
        verifyPluralResponse(expectedResponse, response);
    }

    private static testMethod void validModemNoTerminal() 
    {
        String macAddress = '00:a0:bc:11:22:33';
        String equipmentName = 'T1234';
        Modem__c modem = SNG_TestUtilities.insertEquipment(equipmentName, macAddress, SNG_TestUtilities.insertAccount('Red Cross'), true);
        modem.Terminal__c = null;
        modem.Terminal__r = null;
        update modem;
      
        Terminal__c terminal = [SELECT Name FROM Terminal__c WHERE NickName__c = :equipmentName];
        delete terminal;
      
      
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse(); 
        
        // set the request URL 
        req.requestURI = '/modem/' + macAddress + '/terminal-id';
        req.resourcePath = '/modem/*/terminal-id';
        
        
        // set the request method
        req.httpMethod = 'GET'; 
        
        // RestContext contains the RestRequest and RestResponse objects in REST methods
        RestContext.request = req; 
        RestContext.response = res; 
        
        SNG_REST_JsonResponse response = SNG_REST_TerminalIdApi.getTerminalId(); 

        SNG_REST_JsonResponse expectedOutput = new SNG_REST_JsonResponse(SNGHttpUtilities.Status.OK,
                                                                         null,
                                                                         null,
                                                                         new SNG_REST_TerminalIdMacAddressOutput(null, macAddress));
        System.assertEquals(expectedOutput, response);
        
    }


    //-------------------------------------------------------------------------------
    // SNG_REST_TerminalStatusUnitTest.cls
    //-------------------------------------------------------------------------------
    static testMethod void singularRequestSuccessTest() {
        // init
        SNG_REST_TerminalStatusUnitTestHelper utHelper = new SNG_REST_TerminalStatusUnitTestHelper();
        utHelper.initTest();
        Terminal__c terminal = utHelper.getTerminalForSingularRequestSuccessTest();
        RestContext.request = utHelper.getSingularRequest(terminal);
        utHelper.startTestAndSetMock();
        
        // do the callout
        SNG_REST_JsonResponse responseBody = SNG_REST_TerminalStatus.get();
        
        // verify the response
        utHelper.verifyResponseForSingularRequestSuccessTest(terminal, responseBody);
        
        // stop the test
        Test.stopTest();
    }

    static testMethod void singularRequestPmdrZeroResultsTest() {
        // init
        SNG_REST_TerminalStatusUnitTestHelper utHelper = new SNG_REST_TerminalStatusUnitTestHelper();
        utHelper.initTest();
        Terminal__c terminal = utHelper.getTerminalsForSingularRequestPmdrServiceZeroResults();
        RestContext.request = utHelper.getSingularRequest(terminal);
        utHelper.startTestAndSetMock();
        
        // do the callout
        SNG_REST_JsonResponse responseBody = SNG_REST_TerminalStatus.get();
        
        // verify the response
        utHelper.verifyResponseForSingularRequestPmdrZeroResultsTest(terminal, responseBody);
        
        // stop the test
        Test.stopTest();
    }
    
    static testMethod void singularRequestInvalidIdTest() {
        // init
        SNG_REST_TerminalStatusUnitTestHelper utHelper = new SNG_REST_TerminalStatusUnitTestHelper();
        String terminalIdName = utHelper.getTerminalNameForSingularRequestInvalidIdTest();
        RestContext.request = utHelper.getSingularRequest(terminalIdName);
        utHelper.startTestAndSetMock();
        
        // do the callout
        SNG_REST_JsonResponse responseBody = SNG_REST_TerminalStatus.get();
        
        // verify the response
        utHelper.verifyResponseForSingularRequestInvalidIdTest(responseBody);
        
        // stop the test
        Test.stopTest();
    }
    
    static testMethod void singularRequestNoTerminalsOnAccountTest() {
        // init
        SNG_REST_TerminalStatusUnitTestHelper utHelper = new SNG_REST_TerminalStatusUnitTestHelper();
        utHelper.initTest();
        Terminal__c terminal = utHelper.getTerminalForSingularRequestNoTerminalsOnAccountTest();
        RestContext.request = utHelper.getSingularRequest(terminal);
        utHelper.startTestAndSetMock();
        
        // do the callout
        SNG_REST_JsonResponse responseBody = SNG_REST_TerminalStatus.get();
        
        // verify the response
        utHelper.verifyResponseForSingularRequestNoTerminalsOnAccountTest(responseBody);
        
        // stop the test
        Test.stopTest();
    }
    
    static testMethod void singularRequestTerminalModemNotAssociatedTest() {
        // init
        SNG_REST_TerminalStatusUnitTestHelper utHelper = new SNG_REST_TerminalStatusUnitTestHelper();
        utHelper.initTest();
        Terminal__c terminal = utHelper.getTerminalForSingularRequestTerminalModemNotAssociatedTest();
        RestContext.request = utHelper.getSingularRequest(terminal);
        utHelper.startTestAndSetMock();
        
        // do the callout
        SNG_REST_JsonResponse responseBody = SNG_REST_TerminalStatus.get();
        
        // verify the response
        utHelper.verifyResponseForSingularRequestTerminalModemNotAssociatedTest(responseBody);
        
        // stop the test
        Test.stopTest();
    }
    
    static testMethod void singularRequestPmdrServiceErrorTest() {
        // init
        SNG_REST_TerminalStatusUnitTestHelper utHelper = new SNG_REST_TerminalStatusUnitTestHelper();
        utHelper.initTest();
        Terminal__c terminal = utHelper.getTerminalForSingularRequestPmdrServiceErrorTest();
        RestContext.request = utHelper.getSingularRequest(terminal);
        utHelper.startTestAndSetMock();
        
        // do the callout
        SNG_REST_JsonResponse responseBody = SNG_REST_TerminalStatus.get();
        
        // verify the response
        utHelper.verifyResponseForSingularRequestPmdrServiceErrorTest(responseBody);
        
        // stop the test
        Test.stopTest();
    }
    
    static testMethod void singularRequestPmdrServiceBugTest() {
        // init
        SNG_REST_TerminalStatusUnitTestHelper utHelper = new SNG_REST_TerminalStatusUnitTestHelper();
        utHelper.initTest();
        Terminal__c terminal = utHelper.getTerminalForSingularRequestPmdrServiceBugTest();
        RestContext.request = utHelper.getSingularRequest(terminal);
        utHelper.startTestAndSetMock();
        
        // do the callout
        SNG_REST_JsonResponse responseBody = SNG_REST_TerminalStatus.get();
        
        // verify the response
        utHelper.verifyResponseForSingularRequestPmdrServiceBugTest(responseBody);
        
        // stop the test
        Test.stopTest();
    }
    
    static testMethod void singularRequestNullRequestTest() {
        // init
        SNG_REST_TerminalStatusUnitTestHelper utHelper = new SNG_REST_TerminalStatusUnitTestHelper();
        utHelper.initTest();
        Terminal__c terminal = null;
        RestContext.request = utHelper.getSingularRequest(terminal);
        utHelper.startTestAndSetMock();
        
        SNG_REST_JsonResponse actualResponse = SNG_REST_TerminalStatus.get();
        SNG_REST_JsonResponse expectedResponse = new SNG_REST_JsonResponse(
            new SNG_REST_StatusDetail( SNGHttpUtilities.Status.SERVER_ERROR, 
                                       SNG_REST_Error.SubCode.SALESFORCE_GENERATED_ERROR, 
                                       SNG_REST_ERROR.INTERNAL_SERVER_ERROR ), 
            null);
        System.assertEquals(expectedResponse, actualResponse);
        
        // stop the test
        Test.stopTest();
    }

    //------------------------------------------------------------------------------
    // SNG_REST_TerminalsStatusUnitTest.cls
    //------------------------------------------------------------------------------
    static testMethod void pluralRequestSuccessTest() {
        // init
        SNG_REST_TerminalStatusUnitTestHelper utHelper = new SNG_REST_TerminalStatusUnitTestHelper();
        utHelper.initTest();
        Terminal__c[] terminals = utHelper.getTerminalsForPluralRequestSuccessTest();
        RestContext.request = utHelper.getPluralRequest(terminals);
        utHelper.startTestAndSetMock();
        
        // do the callout
        SNG_REST_JsonResponse responseBody = SNG_REST_TerminalsStatus.get();
        
        // verify the response
        utHelper.verifyResponseForPluralRequestSuccessTest(terminals, responseBody);
        
        // stop the test
        Test.stopTest();
    }

    static testMethod void pluralRequestPmdrServiceZeroReusltsTest() {
        // init
        SNG_REST_TerminalStatusUnitTestHelper utHelper = new SNG_REST_TerminalStatusUnitTestHelper();
        utHelper.initTest();
        Terminal__c[] terminals = utHelper.getTerminalsForPluralRequestPmdrServiceZeroResults();
        RestContext.request = utHelper.getPluralRequest(terminals);
        utHelper.startTestAndSetMock();
        
        // do the callout
        SNG_REST_JsonResponse responseBody = SNG_REST_TerminalsStatus.get();
        
        // verify the response
        utHelper.verifyResponseForPluralRequestPmdrZeroResultsTest(terminals, responseBody);
        
        // stop the test
        Test.stopTest();
    }
    
    static testMethod void pluralRequestInvalidIdTest() {
        // init
        SNG_REST_TerminalStatusUnitTestHelper utHelper = new SNG_REST_TerminalStatusUnitTestHelper();
        utHelper.initTest();
        String[] terminalIdNames = utHelper.getTerminalNamesForPluralRequestInvalidIdTest();
        RestContext.request = utHelper.getPluralRequest(terminalIdNames);
        utHelper.startTestAndSetMock();
        
        // do the callout
        SNG_REST_JsonResponse responseBody = SNG_REST_TerminalsStatus.get();
        
        // verify the response
        utHelper.verifyResponseForPluralRequestInvalidIdTest(terminalIdNames, responseBody);
        
        // stop the test
        Test.stopTest();
    }
    
    static testMethod void pluralRequestTerminalNotOnAccountTest() {
        // init
        SNG_REST_TerminalStatusUnitTestHelper utHelper = new SNG_REST_TerminalStatusUnitTestHelper();
        utHelper.initTest();
        Terminal__c[] terminals = utHelper.getTerminalsForPluralRequestTerminalNotOnAccountTest();
        RestContext.request = utHelper.getPluralRequest(terminals);
        utHelper.startTestAndSetMock();
        
        // do the callout
        SNG_REST_JsonResponse responseBody = SNG_REST_TerminalsStatus.get();
        
        // verify the response
        utHelper.verifyResponseForPluralRequestTerminalNotOnAccountTest(terminals, responseBody);
        
        // stop the test
        Test.stopTest();
    }
    
    static testMethod void pluralRequestNoTerminalsOnAccountTest() {
        // init
        SNG_REST_TerminalStatusUnitTestHelper utHelper = new SNG_REST_TerminalStatusUnitTestHelper();
        utHelper.initTest();
        Terminal__c[] terminals = utHelper.getTerminalsForPluralRequestNoTerminalsOnAccountTest();
        RestContext.request = utHelper.getPluralRequest(terminals);
        utHelper.startTestAndSetMock();
        
        // do the callout
        SNG_REST_JsonResponse responseBody = SNG_REST_TerminalsStatus.get();
        
        // verify the response
        utHelper.verifyResponseForPluralRequestNoTerminalsOnAccountTest(responseBody);
        
        // stop the test
        Test.stopTest();
    }

    static testMethod void pluralRequestTerminalModemNotAssociatedTest() {
        // init
        SNG_REST_TerminalStatusUnitTestHelper utHelper = new SNG_REST_TerminalStatusUnitTestHelper();
        utHelper.initTest();
        Terminal__c[] terminals = utHelper.getTerminalsForPluralRequestTerminalModemNotAssociatedTest();
        RestContext.request = utHelper.getPluralRequest(terminals);
        utHelper.startTestAndSetMock();
        
        // do the callout
        SNG_REST_JsonResponse responseBody = SNG_REST_TerminalsStatus.get();
        
        // verify the response
        utHelper.verifyResponseForPluralRequestTerminalModemNotAssociatedTest(terminals, responseBody);
        
        // stop the test
        Test.stopTest();
    }
    
    static testMethod void pluralRequestPmdrServiceErrorTest() {
        // init
        SNG_REST_TerminalStatusUnitTestHelper utHelper = new SNG_REST_TerminalStatusUnitTestHelper();
        utHelper.initTest();
        Terminal__c[] terminals = utHelper.getTerminalsForPluralRequestPmdrServiceErrorTest();
        RestContext.request = utHelper.getPluralRequest(terminals);
        utHelper.startTestAndSetMock();
        
        // do the callout
        SNG_REST_JsonResponse responseBody = SNG_REST_TerminalsStatus.get();
        
        // verify the response
        utHelper.verifyResponseForPluralRequestPmdrServiceErrorTest(responseBody);
        
        // stop the test
        Test.stopTest();
    }
    
    static testMethod void pluralRequestPmdrServiceBugTest() {
        // init
        SNG_REST_TerminalStatusUnitTestHelper utHelper = new SNG_REST_TerminalStatusUnitTestHelper();
        utHelper.initTest();
        Terminal__c[] terminals = utHelper.getTerminalsForPluralRequestPmdrServiceBugTest();
        RestContext.request = utHelper.getPluralRequest(terminals);
        utHelper.startTestAndSetMock();
        
        // do the callout
        SNG_REST_JsonResponse responseBody = SNG_REST_TerminalsStatus.get();
        
        // verify the response
        utHelper.verifyResponseForPluralRequestPmdrServiceBugTest(responseBody);
        
        // stop the test
        Test.stopTest();
    }
    
    static testMethod void pluralRequestNullRequestTest() {
        // init
        SNG_REST_TerminalStatusUnitTestHelper utHelper = new SNG_REST_TerminalStatusUnitTestHelper();
        utHelper.initTest();
        RestContext.request = null;
        utHelper.startTestAndSetMock();
        
        try {
            // do the callout
            SNG_REST_JsonResponse responseBody = SNG_REST_TerminalsStatus.get();
            System.assert(false);
        } catch (SNG_Exception e) {
            // verify the exception
            utHelper.verifyExceptionForRequestNullRequestTest(e);
        }
        
        // stop the test
        Test.stopTest();
    }


    //-------------------------------------------------------------------------------
    // SNG_REST_TerminalStatusUnitTestHelper.cls - inner class
    //-------------------------------------------------------------------------------
    public class SNG_REST_TerminalStatusUnitTestHelper {
    
        /**
         * Resource path for the singular API call
         * NOTE: This must match what's specigetTerminalsForPluralRequestSuccessTestfied in the @RestResource annotation
         */
        private final String SINGULAR_TERMINAL_STATUS_RESOURCE_PATH = '/terminal/*/status';
        
        /**
         * Resource path for the plural API call
         * NOTE: This must match what's specified in the @RestResource annotation
         */
        private final String PLURAL_TERMINAL_STATUS_RESOURCE_PATH = '/terminals/status';
        
        public void initTest() {
            // initialize custom settings
            SNG_MockCustomSettings.initialize();
        }
        
        public void startTestAndSetMock() {
            // start the test and set the mock for the http callout
            Test.startTest();
            Test.setMock(HttpCalloutMock.class, new SNG_MockPerformanceLatestHttpCallout());
        }
        
        public RestRequest getSingularRequest(Terminal__c terminal) {
            return (null == terminal ? null : getSingularRequest(terminal.Name));
        }
        
        public RestRequest getSingularRequest(String terminalIdName) {
            RestRequest req = new RestRequest();
            
            req.requestURI = '/terminal/' + terminalIdName + '/status';
            req.resourcePath = SINGULAR_TERMINAL_STATUS_RESOURCE_PATH;
            
            // set the request method
            req.httpMethod = 'GET';
            
            // Print out the request URI for debug
            System.debug('Singular Request URI for terminalIdName [' + terminalIdName + ']: ' + req.requestUri);
            
            return req;
        }
        
        public RestRequest getPluralRequest(Terminal__c[] terminals) {
            String[] terminalIdNames = getTerminalIdNames(terminals);
            return getPluralRequest(terminalIdNames);
        }
        
        public RestRequest getPluralRequest(String[] terminalIdNames) {
            RestRequest req = new RestRequest();
            
            String joinedTerminalIdNames = StringUtils.joinStrings(terminalIdNames, ',');
            req.requestURI = PLURAL_TERMINAL_STATUS_RESOURCE_PATH + '?' + SNG_REST_Collection.IDS_PARAM + '=' + joinedTerminalIdNames;
            req.addParameter(SNG_REST_Collection.IDS_PARAM, joinedTerminalIdNames);
            req.resourcePath = PLURAL_TERMINAL_STATUS_RESOURCE_PATH;
            
            // set the request method
            req.httpMethod = 'GET';
            
            // Print out the request URI for debug
            System.debug('Plural Request URI for terminalIdNames [' + terminalIdNames + ']: ' + req.requestUri);
            
            return req;
        }
        
        public void verifyExceptionForRequestNullRequestTest(SNG_Exception e) {
            System.assert(null != e);
        }
        
        
        
        // START Plural Request Tests
        
        
        public Terminal__c[] getTerminalsForPluralRequestSuccessTest() {
            Modem__c[] modems = insertModems(SNG_MockPerformanceLatestHttpCallout.SUCCESS_MACADDRS);
            return getTerminalsForModems(modems);
        }

        public Terminal__c[] getTerminalsForPluralRequestPmdrServiceZeroResults() {
            Modem__c[] modems = insertModems(SNG_MockPerformanceLatestHttpCallout.ZERO_RESULTS_MACADDRS);
            return getTerminalsForModems(modems);
        }
        
        public void verifyResponseForPluralRequestSuccessTest(Terminal__c[] terminals, SNG_REST_JsonResponse responseBody) {
            SNG_REST_CollectionOutput expectedPerformance = new SNG_REST_CollectionOutput(
                new SNG_REST_TerminalStatusHandler.TerminalPerformanceLatestOutput[] {
                    new SNG_REST_TerminalStatusHandler.TerminalPerformanceLatestOutput(
                        terminals[0].Name, 
                        SNG_REST_StatusLight.Status.NO_ISSUES, // Status
                        SNG_REST_StatusLight.Status.NO_ISSUES, // Network
                        SNG_REST_StatusLight.Status.NO_ISSUES, // Weather
                        SNG_REST_StatusLight.Status.NO_ISSUES, // Performance
                        SNG_REST_StatusLight.Status.NO_ISSUES, // Pointing
                        SNG_SnmpDateAndTimeConverter.translateTimeToDurationFromNow('0x07dd0b0c131714002b0000')
                    ),
                    new SNG_REST_TerminalStatusHandler.TerminalPerformanceLatestOutput(
                        terminals[1].Name, 
                        SNG_REST_StatusLight.Status.NO_ISSUES, // Status
                        SNG_REST_StatusLight.Status.NO_ISSUES, // Network
                        SNG_REST_StatusLight.Status.NO_ISSUES, // Weather
                        SNG_REST_StatusLight.Status.NO_ISSUES, // Performance
                        SNG_REST_StatusLight.Status.NO_ISSUES, // Pointing
                        SNG_SnmpDateAndTimeConverter.translateTimeToDurationFromNow('0x07dd0b0c131714003b0000')
                    )
                }
            );
            
            verifyPluralResponse(responseBody, SNGHttpUtilities.Status.OK, null, null, expectedPerformance);
        }
        
        public void verifyResponseForPluralRequestPmdrZeroResultsTest(Terminal__c[] terminals, SNG_REST_JsonResponse responseBody)
        {
            SNG_REST_CollectionOutput expectedPerformance = new SNG_REST_CollectionOutput(
                new SNG_REST_TerminalStatusHandler.TerminalPerformanceLatestOutput[] {
                    new SNG_REST_TerminalStatusHandler.TerminalPerformanceLatestOutput(
                        terminals[0].Name, 
                        SNG_REST_StatusLight.Status.OFFLINE, // Status
                        SNG_REST_StatusLight.Status.SEVERE_ISSUES, // Network
                        SNG_REST_StatusLight.Status.SEVERE_ISSUES, // Weather
                        SNG_REST_StatusLight.Status.OFFLINE, // Performance
                        SNG_REST_StatusLight.Status.OFFLINE, // Pointing
                        0
                    ),
                    new SNG_REST_TerminalStatusHandler.TerminalPerformanceLatestOutput(
                        terminals[1].Name, 
                        SNG_REST_StatusLight.Status.OFFLINE, // Status
                        SNG_REST_StatusLight.Status.SEVERE_ISSUES, // Network
                        SNG_REST_StatusLight.Status.SEVERE_ISSUES, // Weather
                        SNG_REST_StatusLight.Status.OFFLINE, // Performance
                        SNG_REST_StatusLight.Status.OFFLINE, // Pointing
                        0
                    )
                }
            );
            
            verifyPluralResponse(responseBody, SNGHttpUtilities.Status.OK, null, null, expectedPerformance);        
        }

        
        public String[] getTerminalNamesForPluralRequestInvalidIdTest() {
            Modem__c[] modems = insertModems(SNG_MockPerformanceLatestHttpCallout.SUCCESS_MACADDRS);
            Terminal__c[] terminals = getTerminalsForModems(modems);
            List<String> terminalIdNames = getTerminalIdNames(terminals);
            terminalIdNames.add('INVALID_TERMINAL_ID');
            return terminalIdNames;
        }
        
        public void verifyResponseForPluralRequestInvalidIdTest(String[] terminalIdNames, SNG_REST_JsonResponse responseBody) {
            verifyPluralResponse(responseBody, SNGHttpUtilities.Status.INPUT_VALIDATION_ERROR, 
                           SNG_REST_Error.INPUT_INVALID_FORMAT, 
                           SNG_REST_Error.SubCode.SALESFORCE_GENERATED_ERROR, null);
        }
        
        
        public Terminal__c[] getTerminalsForPluralRequestTerminalNotOnAccountTest() {
            Modem__c[] modems = insertModems(SNG_MockPerformanceLatestHttpCallout.SUCCESS_MACADDRS);
            Terminal__c[] terminals = getTerminalsForModems(modems);
            
            // delete so it's not available on the account
            delete modems[0];
            delete terminals[0];
            
            return terminals;
        }
        
        public void verifyResponseForPluralRequestTerminalNotOnAccountTest(Terminal__c[] terminals, SNG_REST_JsonResponse responseBody) {
            SNG_REST_CollectionOutput expectedPerformance = new SNG_REST_CollectionOutput(
                new SNG_REST_TerminalStatusHandler.TerminalPerformanceLatestOutput[] {
                    new SNG_REST_TerminalStatusHandler.TerminalPerformanceLatestOutput(
                        terminals[1].Name, 
                        SNG_REST_StatusLight.Status.NO_ISSUES, // Status
                        SNG_REST_StatusLight.Status.NO_ISSUES, // Network
                        SNG_REST_StatusLight.Status.NO_ISSUES, // Weather
                        SNG_REST_StatusLight.Status.NO_ISSUES, // Performance
                        SNG_REST_StatusLight.Status.NO_ISSUES, // Pointing
                        SNG_SnmpDateAndTimeConverter.translateTimeToDurationFromNow('0x07dd0b0c131714003b0000')
                    )
                }
            );
            
            verifyPluralResponse(responseBody, SNGHttpUtilities.Status.OK_WITH_ERRORS, 
                           SNG_REST_Error.IDS_INVALID, 
                           SNG_REST_Error.SubCode.SALESFORCE_GENERATED_ERROR, expectedPerformance);
        }
        
        
        public Terminal__c[] getTerminalsForPluralRequestNoTerminalsOnAccountTest() {
            String[] macAddrs = new String[] { '00:a0:bc:99:99:99' };
            Modem__c[] modems = insertModems(macAddrs);
            Terminal__c[] terminals = getTerminalsForModems(modems);
            
            // delete so it's not available on the account
            delete modems[0];
            delete terminals[0];
            
            return terminals;
        }
        
        public void verifyResponseForPluralRequestNoTerminalsOnAccountTest(SNG_REST_JsonResponse responseBody) {
            verifyPluralResponse(responseBody, SNGHttpUtilities.Status.ZERO_RESULTS, 
                           SNG_REST_Error.IDS_INVALID, 
                           SNG_REST_Error.SubCode.SALESFORCE_GENERATED_ERROR, null);
        }
        
        
        public Terminal__c[] getTerminalsForPluralRequestTerminalModemNotAssociatedTest() {
            Modem__c[] modems = insertModems(SNG_MockPerformanceLatestHttpCallout.SUCCESS_MACADDRS);
            Terminal__c[] terminals = getTerminalsForModems(modems);
            
            // delete a modem so it's not associated with the corresponding terminal
            delete modems[0];
            
            return terminals;
        }
        
        public void verifyResponseForPluralRequestTerminalModemNotAssociatedTest(Terminal__c[] terminals, SNG_REST_JsonResponse responseBody) {
            SNG_REST_CollectionOutput expectedPerformance = new SNG_REST_CollectionOutput(
                new SNG_REST_TerminalStatusHandler.TerminalPerformanceLatestOutput[] {
                    new SNG_REST_TerminalStatusHandler.TerminalPerformanceLatestOutput(
                        terminals[1].Name, 
                        SNG_REST_StatusLight.Status.NO_ISSUES, // Status
                        SNG_REST_StatusLight.Status.NO_ISSUES, // Network
                        SNG_REST_StatusLight.Status.NO_ISSUES, // Weather
                        SNG_REST_StatusLight.Status.NO_ISSUES, // Performance
                        SNG_REST_StatusLight.Status.NO_ISSUES, // Pointing
                        SNG_SnmpDateAndTimeConverter.translateTimeToDurationFromNow('0x07dd0b0c131714003b0000')
                    )
                }
            );
            
            verifyPluralResponse(responseBody, SNGHttpUtilities.Status.OK_WITH_ERRORS, 
                           SNG_REST_Error.TERMINAL_NO_MODEM, 
                           SNG_REST_Error.SubCode.SALESFORCE_GENERATED_ERROR, expectedPerformance);
        }
        
        
        public Terminal__c[] getTerminalsForPluralRequestPmdrServiceErrorTest() {
            Modem__c[] modems = insertModems(SNG_MockPerformanceLatestHttpCallout.SERVER_ERROR_MACADDRS);
            return getTerminalsForModems(modems);
        }
        
        public void verifyResponseForPluralRequestPmdrServiceErrorTest(SNG_REST_JsonResponse responseBody) {
            verifyPluralResponse(responseBody, SNGHttpUtilities.Status.SERVER_ERROR, 
                           SNG_REST_Error.GENERIC_WEBSERVICE_ERROR, 
                           SNG_REST_Error.SubCode.WEBSERVICE_GENERATED_ERROR, null);
        }
        
        
        public Terminal__c[] getTerminalsForPluralRequestPmdrServiceBugTest() {
            Modem__c[] modems = insertModems(SNG_MockPerformanceLatestHttpCallout.SERVER_BUG_MACADDRS);
            return getTerminalsForModems(modems);
        }
        
        public void verifyResponseForPluralRequestPmdrServiceBugTest(SNG_REST_JsonResponse responseBody) {
            verifyPluralResponse(responseBody, SNGHttpUtilities.Status.SERVER_ERROR, 
                           SNG_REST_Error.GENERIC_WEBSERVICE_ERROR, 
                           SNG_REST_Error.SubCode.SALESFORCE_GENERATED_ERROR, null);
        }
        
        
        // END Handle Plural Request Tests
        
        
        
        // START Handle Singular Request Tests
        
        public Terminal__c getTerminalForSingularRequestSuccessTest() {
            Modem__c modem = insertModem(SNG_MockPerformanceLatestHttpCallout.SUCCESS_MACADDRS[0]);
            return requeryTerminal(modem.Terminal__r);
        }
        
        public Terminal__c getTerminalsForSingularRequestPmdrServiceZeroResults() {
            Modem__c modem = insertModem(SNG_MockPerformanceLatestHttpCallout.ZERO_RESULTS_MACADDRS[0]);
            return requeryTerminal(modem.Terminal__r);
        }

        public void verifyResponseForSingularRequestSuccessTest(Terminal__c terminal, SNG_REST_JsonResponse responseBody) {
            SNG_REST_TerminalStatusHandler.TerminalPerformanceLatestOutput expectedPerformance 
                = new SNG_REST_TerminalStatusHandler.TerminalPerformanceLatestOutput(
                    terminal.Name, 
                    SNG_REST_StatusLight.Status.NO_ISSUES, // Status
                    SNG_REST_StatusLight.Status.NO_ISSUES, // Network
                    SNG_REST_StatusLight.Status.NO_ISSUES, // Weather
                    SNG_REST_StatusLight.Status.NO_ISSUES, // Performance
                    SNG_REST_StatusLight.Status.NO_ISSUES, // Pointing
                    SNG_SnmpDateAndTimeConverter.translateTimeToDurationFromNow('0x07dd0b0c131714002b0000')
                );
            
            verifySingularResponse(responseBody, SNGHttpUtilities.Status.OK, null, null, expectedPerformance);
        }

        public void verifyResponseForSingularRequestPmdrZeroResultsTest(Terminal__c terminal, SNG_REST_JsonResponse responseBody)
        {
            SNG_REST_TerminalStatusHandler.TerminalPerformanceLatestOutput expectedPerformance 
                = new SNG_REST_TerminalStatusHandler.TerminalPerformanceLatestOutput(
                    terminal.Name, 
                    SNG_REST_StatusLight.Status.OFFLINE, // Status
                    SNG_REST_StatusLight.Status.SEVERE_ISSUES, // Network
                    SNG_REST_StatusLight.Status.SEVERE_ISSUES, // Weather
                    SNG_REST_StatusLight.Status.OFFLINE, // Performance
                    SNG_REST_StatusLight.Status.OFFLINE, // Pointing
                    0
                );
            
            verifySingularResponse(responseBody, SNGHttpUtilities.Status.OK, null, null, expectedPerformance);        
        }

        
        
        public String getTerminalNameForSingularRequestInvalidIdTest() {
            return 'INVALID_TERMINAL_ID';
        }
        
        public void verifyResponseForSingularRequestInvalidIdTest(SNG_REST_JsonResponse responseBody) {
            verifySingularResponse(responseBody, SNGHttpUtilities.Status.INPUT_VALIDATION_ERROR, 
                                   SNG_REST_Error.INPUT_INVALID_FORMAT, 
                                   SNG_REST_Error.SubCode.SALESFORCE_GENERATED_ERROR, null);
        }
        
        
        public Terminal__c getTerminalForSingularRequestNoTerminalsOnAccountTest() {
            String macAddr = '00:a0:bc:99:99:99';
            Modem__c modem = insertModem(macAddr);
            Terminal__c terminal = requeryTerminal(modem.Terminal__r);
            
            // delete so it's not available on the account
            delete modem;
            delete terminal;
            
            return terminal;
        }
        
        public void verifyResponseForSingularRequestNoTerminalsOnAccountTest(SNG_REST_JsonResponse responseBody) {
            verifySingularResponse(responseBody, SNGHttpUtilities.Status.ZERO_RESULTS, 
                                   SNG_REST_Error.IDS_INVALID, 
                                   SNG_REST_Error.SubCode.SALESFORCE_GENERATED_ERROR, null);
        }
        
        
        public Terminal__c getTerminalForSingularRequestTerminalModemNotAssociatedTest() {
            String macAddr = SNG_MockPerformanceLatestHttpCallout.SUCCESS_MACADDRS[0];
            Modem__c modem = insertModem(macAddr);
            Terminal__c terminal = requeryTerminal(modem.Terminal__r);
            
            // Disassociate terminal from modem
            modem.Terminal__c = null;
            modem.Terminal__r = null;
            update modem;
            
            return terminal;
        }
        
        public void verifyResponseForSingularRequestTerminalModemNotAssociatedTest(SNG_REST_JsonResponse responseBody) {
            verifySingularResponse(responseBody, SNGHttpUtilities.Status.ZERO_RESULTS, 
                                   SNG_REST_Error.TERMINAL_NO_MODEM, 
                                   SNG_REST_Error.SubCode.SALESFORCE_GENERATED_ERROR, null);
        }
        
        
        public Terminal__c getTerminalForSingularRequestPmdrServiceErrorTest() {
            Modem__c modem = insertModem(SNG_MockPerformanceLatestHttpCallout.SERVER_ERROR_MACADDRS[0]);
            return requeryTerminal(modem.Terminal__r);
        }
        
        public void verifyResponseForSingularRequestPmdrServiceErrorTest(SNG_REST_JsonResponse responseBody) {
            verifySingularResponse(responseBody, SNGHttpUtilities.Status.SERVER_ERROR, 
                                   SNG_REST_Error.GENERIC_WEBSERVICE_ERROR, 
                                   SNG_REST_Error.SubCode.WEBSERVICE_GENERATED_ERROR, null);
        }
        
        
        public Terminal__c getTerminalForSingularRequestPmdrServiceBugTest() {
            Modem__c modem = insertModem(SNG_MockPerformanceLatestHttpCallout.SERVER_BUG_MACADDRS[0]);
            return requeryTerminal(modem.Terminal__r);
        }
        
        public void verifyResponseForSingularRequestPmdrServiceBugTest(SNG_REST_JsonResponse responseBody) {
            verifySingularResponse(responseBody, SNGHttpUtilities.Status.SERVER_ERROR, 
                                   SNG_REST_Error.GENERIC_WEBSERVICE_ERROR, 
                                   SNG_REST_Error.SubCode.SALESFORCE_GENERATED_ERROR, null);
        }
        
        
        // END Handle Singular Request Tests
        
        
        
        
        // START Private Helper Methods
        
        private Terminal__c requeryTerminal(Terminal__c terminal) {
            final SNG_SObjectQueryBuilder queryBuilder = new SNG_SObjectQueryBuilder(SNG_SObjectQueryBuilder.TERMINAL_OBJ_NAME);
            queryBuilder.addAllFields();
            String queryStr = queryBuilder.constructQuery() + ' WHERE Id=\'' + terminal.Id + '\'';
            return Database.query(queryStr);
        }
        
        private Modem__c[] insertModems(String[] macAddrs) {
            Account acct = SNG_TestUtilities.insertAccount('testAccount');
            
            Modem__c[] modems = new Modem__c[macAddrs.size()];
            
            for (Integer i = 0; i < macAddrs.size(); ++i) {
                modems[i] = insertModem(macAddrs[i], acct, i);
            }
            
            return modems;
        }
        
        private Modem__c insertModem(String macAddr) {
            return insertModem(macAddr, SNG_TestUtilities.insertAccount('testAccount'), 0);
        }
        
        private Modem__c insertModem(String macAddr, Account acct, Integer index) {
            return SNG_TestUtilities.insertEquipment('Terminal_' + index, macAddr, acct, String.valueOf(index), true);
        }
        
        private Id[] getTerminalIdsForModems(Modem__c[] modems) {
            List<Id> terminalIds = new List<Id>();
            
            for (Modem__c modem : modems) {
                terminalIds.add(modem.Terminal__c);
            }
            
            return terminalIds;
        }
        
        private Terminal__c[] getTerminalsForModems(Modem__c[] modems) {
            Id[] terminalIds = getTerminalIdsForModems(modems);
            
            Terminal__c[] terminals = [SELECT Id, Name, PeersOnlineBackEnd__c, PeersAvgUploadSymbolRateBackEnd__c, DownloadSinrBackEnd__c, 
                                       UploadSymbolRateBackEnd__c, Status__c, Network__c, WeatherBackEnd__c, Performance__c, Pointing__c, 
                                       OnlineTime__c FROM Terminal__c WHERE Id IN :terminalIds];
            
            return terminals;
        }
        
        private String[] getTerminalIdNames(Terminal__c[] terminals) {
            List<String> terminalIdNames = new List<String>();
            
            for (Terminal__c terminal : terminals) {
                terminalIdNames.add(terminal.Name);
            }
            
            return terminalIdNames;
        }
        
        private void verifyPluralResponse(final SNG_REST_JsonResponse responseBody, final SNGHttpUtilities.Status status, 
                                           final String errorMessage, final SNG_REST_Error.SubCode errorSubCode, final SNG_REST_CollectionOutput termPerf) {
            System.assertEquals(status.name(), responseBody.status);
            System.assertEquals(errorMessage, responseBody.errorMessage);
            System.assertEquals(SNG_REST_Error.getErrorCode(status, errorSubCode), responseBody.errorCode);
            
            SNG_REST_CollectionOutput responseBodyData = (SNG_REST_CollectionOutput) responseBody.data;
            verifyResponseData(termPerf, responseBodyData);
        }
        
        private void verifySingularResponse(final SNG_REST_JsonResponse responseBody, final SNGHttpUtilities.Status status, 
                                                   final String errorMessage, final SNG_REST_Error.SubCode errorSubCode, final SNG_REST_TerminalStatusHandler.TerminalPerformanceLatestOutput termPerf) {
            System.assertEquals(status.name(), responseBody.status);
            System.assertEquals(errorMessage, responseBody.errorMessage);
            System.assertEquals(SNG_REST_Error.getErrorCode(status, errorSubCode), responseBody.errorCode);
            
            SNG_REST_TerminalStatusHandler.TerminalPerformanceLatestOutput responseBodyData 
                = (SNG_REST_TerminalStatusHandler.TerminalPerformanceLatestOutput) responseBody.data;
            verifyResponseResult(termPerf, responseBodyData);
        }
        
        private void verifyResponseData(SNG_REST_CollectionOutput expected, SNG_REST_CollectionOutput actual) {
            if (null != expected) {
                SNG_REST_TerminalStatusHandler.TerminalPerformanceLatestOutput[] expectedItems = (SNG_REST_TerminalStatusHandler.TerminalPerformanceLatestOutput[]) expected.items;
                SNG_REST_TerminalStatusHandler.TerminalPerformanceLatestOutput[] actualItems = (SNG_REST_TerminalStatusHandler.TerminalPerformanceLatestOutput[]) actual.items;
                verifyResponseItems(expectedItems, actualItems);
            } else {
                System.assertEquals(null, actual);
            }
        }
        
        private void verifyResponseItems(final SNG_REST_TerminalStatusHandler.TerminalPerformanceLatestOutput[] expected, 
                                                final SNG_REST_TerminalStatusHandler.TerminalPerformanceLatestOutput[] actual) {
            if (null != expected) {
                // Check the size
                System.assertEquals(expected.size(), actual.size());
                
                // Sort the 2 lists to ensure the order is the same
                expected.sort();
                actual.sort();
                
                for (Integer i = 0; i < expected.size(); ++i) {
                    verifyResponseResult(expected[i], actual[i]);
                }
            } else {
                System.assertEquals(null, actual);
            }
        }
        
        private void verifyResponseResult(final SNG_REST_TerminalStatusHandler.TerminalPerformanceLatestOutput expected, 
                                                 final SNG_REST_TerminalStatusHandler.TerminalPerformanceLatestOutput actual) {
            
            if (null != expected) {
                if (expected != actual) {
                    System.assertEquals(expected.terminalId, actual.terminalId);
                    System.assertEquals(expected.network, actual.network);
                    System.assertEquals(expected.weather, actual.weather);
                    System.assertEquals(expected.performance, actual.performance);
                    System.assertEquals(expected.pointing, actual.pointing);
                    System.assertEquals(expected.status, actual.status);
                    verifyOnlineTime(expected.onlineTime, actual.onlineTime);
                }
            } else {
                System.assertEquals(null, actual);
            }
        }
        
        private void verifyOnlineTime(String expectedOnlineTimeStr, String actualOnlineTimeStr) {
            Long expectedOnlineTime = parseOnlineTime(expectedOnlineTimeStr);
            Long actualOnlineTime = parseOnlineTime(actualOnlineTimeStr);
            
            // 5 second tolerance
            System.assert(Math.abs(expectedOnlineTime - actualOnlineTime) < 5);
        }
        
        private Long parseOnlineTime(String onlineTimeStr) 
        {
            Long totalSeconds = 0;
            
            onlineTimeStr = onlineTimeStr.substring(1);  // removes P
            
            integer index = onlineTimeStr.indexOf('D');
            
            if (-1 != index)
            {
               String days = onlineTimeStr.substring(0, index);
               totalSeconds += Integer.valueOf(days) * 86400;
               onlineTimeStr = onlineTimeStr.substring(index + 2); 
            }
                    
            index = onlineTimeStr.indexOf('H');
            
            if (-1 != index)
            {
               String hours = onlineTimeStr.substring(0, index);
               totalSeconds += Integer.valueOf(hours) * 3600;   
               onlineTimeStr = onlineTimeStr.substring(index + 1);      
            }
            
            index = onlineTimeStr.indexOf('M');
            
            if (-1 != index)
            {
               String minutes = onlineTimeStr.substring(0, index);
               totalSeconds += Integer.valueOf(minutes) * 60;   
               onlineTimeStr = onlineTimeStr.substring(index + 1);      
            } 
            
            index = onlineTimeStr.indexOf('S');
            
            if (-1 != index)
            {
               String seconds = onlineTimeStr.substring(0, index);
               totalSeconds += Integer.valueOf(seconds);   
            }
            
            return totalSeconds;
        }
        
        // END Private Helper Methods
        
    }

}