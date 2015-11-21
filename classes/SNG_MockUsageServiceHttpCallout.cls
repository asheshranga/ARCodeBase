@isTest
global with sharing class SNG_MockUsageServiceHttpCallout implements HttpCalloutMock 
{
	public static final String udmHttpAddress = SNG_ModemUsageDataHttpCallout.UDM_HTTP_PATH;
	
	public static final String CALLOUT_EXCEPTION_MAC_ADDRESS = '00:a0:bc:44:55:11';
	public static final String STATUS_FAILURE_DATA_EMPTY_MAC_ADDRESS = '00:a0:bc:44:55:22';
	public static final String HTTP_STATUS_FAILURE_MAC_ADDRESS = '00:a0:bc:44:55:33';
	public static final String SUNNY_DAY_MAC_ADDRESS_SINGLE = '00:a0:bc:44:55:44';
	public static final String OK_WITH_ERRORS_MAC_ADDRESS = '00:a0:bc:44:55:55';
	
	public static final String SUNNY_DAY_MAC_ADDRESS_DOUBLE_A = '00:a0:bc:44:55:66';
	public static final String SUNNY_DAY_MAC_ADDRESS_DOUBLE_B = '00:a0:bc:44:55:77';
	
	public static final String INVALID_MAC_ADDRESS_RESPONSE_FORMAT = '00:a0:bc:44:55:88';
	public static final String SUNNY_DAY_MAC_ADDRESS_SINGLE_TE = '00:a0:bc:44:55:99';
	public static final String SUNNY_DAY_MAC_ADDRESS_CURRENT_SINGLE_TE = '00:a0:bc:44:55:98';
	
	public static final String SUNNY_DAY_MAC_ADDRESS_NO_DATA = '00:a0:bc:44:55:AA';
	public static final String SUNNY_DAY_MAC_ADDRESS_CURRENT = '00:a0:bc:44:55:BB';

	public static final String SINGLE_START_TIME = '2014-09-01T00:00:00Z';
	public static final String SINGLE_END_TIME = '2014-09-02T00:00:00Z';
	public static final String SINGLE_FIRST_PROCESSED = '2014-09-01T00:03:00Z';
	public static final String SINGLE_LAST_PROCESSED = '2014-09-02T23:57:00Z';
	public static final String SINGLE_BSID_NAME = SUNNY_DAY_MAC_ADDRESS_SINGLE + '_BSID';
	public static final long SINGLE_BSID_DOWNLOAD = 7891236789L;
	public static final long SINGLE_BSID_UPLOAD = 1234567890L;
	public static final long SINGLE_AGGREGATE_DOWNLOAD = SINGLE_BSID_DOWNLOAD;
	public static final long SINGLE_AGGREGATE_UPLOAD = SINGLE_BSID_UPLOAD;
	
	private static final DateTime SINGLE_CURRENT_START_TIME_DT = DateTime.newInstanceGmt(DateTime.now().yearGmt(), DateTime.now().monthGmt(), 1);
	private static final DateTime SINGLE_CURRENT_END_TIME_DT = SINGLE_CURRENT_START_TIME_DT.addMonths(1);
	private static final DateTime SINGLE_CURRENT_FIRST_PROCESSED_DT = SINGLE_CURRENT_START_TIME_DT;
	private static final DateTime SINGLE_CURRENT_LAST_PROCESSED_DT = DateTime.now().addSeconds(-1);
	public static final String SINGLE_CURRENT_START_TIME = ISODateAndTimeConverter.formatDateTimeGmt(SINGLE_CURRENT_START_TIME_DT);
	public static final String SINGLE_CURRENT_END_TIME = ISODateAndTimeConverter.formatDateTimeGmt(SINGLE_CURRENT_END_TIME_DT);
	public static final String SINGLE_CURRENT_FIRST_PROCESSED = ISODateAndTimeConverter.formatDateTimeGmt(SINGLE_CURRENT_FIRST_PROCESSED_DT);
	public static final String SINGLE_CURRENT_LAST_PROCESSED = ISODateAndTimeConverter.formatDateTimeGmt(SINGLE_CURRENT_LAST_PROCESSED_DT);
	public static final String SINGLE_CURRENT_TE_START_TIME = SINGLE_CURRENT_START_TIME;
	public static final String SINGLE_CURRENT_TE_END_TIME = SINGLE_CURRENT_END_TIME;
	public static final String SINGLE_CURRENT_TE_FIRST_PROCESSED = SINGLE_CURRENT_FIRST_PROCESSED;
	public static final String SINGLE_CURRENT_TE_LAST_PROCESSED = SINGLE_CURRENT_LAST_PROCESSED;
	
    public static final String SINGLE_TE_START_TIME = '2014-09-03T00:00:00Z';
    public static final String SINGLE_TE_END_TIME = '2014-09-04T00:00:00Z';
    public static final String SINGLE_TE_FIRST_PROCESSED = '2014-09-03T00:03:00Z';
    public static final String SINGLE_TE_LAST_PROCESSED = '2014-09-4T23:57:00Z';
    public static final String SINGLE_TE_BSID_NAME = SUNNY_DAY_MAC_ADDRESS_SINGLE_TE + '_BSID';
    public static final long SINGLE_TE_BSID_DOWNLOAD = 7891236789L;
    public static final long SINGLE_TE_BSID_UPLOAD = 1234567890L;
    public static final long SINGLE_TE_AGGREGATE_DOWNLOAD = SINGLE_TE_BSID_DOWNLOAD;
    public static final long SINGLE_TE_AGGREGATE_UPLOAD = SINGLE_TE_BSID_UPLOAD;	
	
	public static final String OK_WITH_ERRORS_START_TIME = '2014-07-01T00:00:00Z';
	public static final String OK_WITH_ERRORS_END_TIME = '2014-08-01T00:00:00Z';
	public static final String OK_WITH_ERRORS_FIRST_PROCESSED = '2014-09-01T00:02:00Z';
	public static final String OK_WITH_ERRORS_LAST_PROCESSED = '2014-09-30T23:58:00Z';
	public static final String OK_WITH_ERRORS_BSID_NAME = OK_WITH_ERRORS_MAC_ADDRESS + '_BSID';
	public static final long OK_WITH_ERRORS_BSID_DOWNLOAD = 9612315114L;
	public static final long OK_WITH_ERRORS_BSID_UPLOAD = 32156781294L;
	public static final long OK_WITH_ERRORS_AGGREGATE_DOWNLOAD = OK_WITH_ERRORS_BSID_DOWNLOAD;
	public static final long OK_WITH_ERRORS_AGGREGATE_UPLOAD = OK_WITH_ERRORS_BSID_UPLOAD;
	
	public static final String DOUBLE_A_START_TIME = '2014-09-01T00:00:00Z';
	public static final String DOUBLE_A_END_TIME = '2014-09-10T00:00:00Z';
	public static final String DOUBLE_A_FIRST_PROCESSED = '2014-09-01T00:03:00Z';
	public static final String DOUBLE_A_LAST_PROCESSED = '2014-09-30T23:57:00Z';
	public static final String DOUBLE_A_BSID_NAME = SUNNY_DAY_MAC_ADDRESS_DOUBLE_A + '_BSID';
	public static final long DOUBLE_A_BSID_DOWNLOAD = 7891236789L;
	public static final long DOUBLE_A_BSID_UPLOAD = 1234567890L;
	public static final long DOUBLE_A_AGGREGATE_DOWNLOAD = DOUBLE_A_BSID_DOWNLOAD;
	public static final long DOUBLE_A_AGGREGATE_UPLOAD = DOUBLE_A_BSID_UPLOAD;
	
	public static final String DOUBLE_A1_START_TIME = '2014-09-11T00:00:00Z';
	public static final String DOUBLE_A1_END_TIME = '2014-09-17T00:00:00Z';
	public static final String DOUBLE_A1_FIRST_PROCESSED = '2014-09-01T01:01:17Z';
	public static final String DOUBLE_A1_LAST_PROCESSED = '2014-09-30T22:56:03Z';
	public static final String DOUBLE_A1_BSID_NAME = SUNNY_DAY_MAC_ADDRESS_DOUBLE_A + '_BSID';
	public static final long DOUBLE_A1_BSID_DOWNLOAD = 3458796224L;
	public static final long DOUBLE_A1_BSID_UPLOAD = 875631875L;
	public static final long DOUBLE_A1_AGGREGATE_DOWNLOAD = DOUBLE_A1_BSID_DOWNLOAD;
	public static final long DOUBLE_A1_AGGREGATE_UPLOAD = DOUBLE_A1_BSID_UPLOAD;
	
	public static final String DOUBLE_B_START_TIME = '2014-09-11T02:54:13Z';
	public static final String DOUBLE_B_END_TIME = '2014-09-13T09:23:12Z';
	public static final String DOUBLE_B_FIRST_PROCESSED = '2014-09-11T00:03:00Z';
	public static final String DOUBLE_B_LAST_PROCESSED = '2014-09-13T23:57:00Z';
	public static final String DOUBLE_B_BSID_NAME = SUNNY_DAY_MAC_ADDRESS_DOUBLE_B + '_BSID';
	public static final long DOUBLE_B_BSID_DOWNLOAD = 54879541216L;
	public static final long DOUBLE_B_BSID_UPLOAD = 5789432185L;
	public static final long DOUBLE_B_AGGREGATE_DOWNLOAD = DOUBLE_B_BSID_DOWNLOAD;
	public static final long DOUBLE_B_AGGREGATE_UPLOAD = DOUBLE_B_BSID_UPLOAD;
	
	

	
	
    private static final transient String SET_COOKIE_HEADER_KEY = SNG_HttpCallout.COOKIE_HEADER_KEY;

    global HTTPResponse respond(HTTPRequest req)
    {
    	String endpoint = req.getEndpoint();
        HttpResponse res = new HttpResponse();

    	if (endpoint.startsWith(udmHttpAddress))
    	{
    		String jsonRequestBody = req.getBody();
			
			System.debug('endPoint: ' + req.getEndPoint());
    		System.debug('Json Request body: ' + jsonRequestBody);
    		
    		// HTTP callout exception salesforce
    		if (jsonRequestBody.contains(CALLOUT_EXCEPTION_MAC_ADDRESS))
    		{
                System.assertEquals('POST', req.getMethod());
                throw new SNG_CalloutException('Hello world');
    		}
    		// Usage service is down, can't ge tot it
    		else if (jsonRequestBody.contains(HTTP_STATUS_FAILURE_MAC_ADDRESS))
    		{
    			res.setHeader('Content-Type', 'application/json');
    			res.setStatusCode(SNGHttpUtilities.STATUS_CODE.NOT_FOUND);
    		}
    		// No data entry found for the mac address sent to usageservice
    		else if (jsonRequestBody.contains(STATUS_FAILURE_DATA_EMPTY_MAC_ADDRESS))
    		{
    			res.setHeader('Content-Type', 'application/json');
                res.setBody('{' +
                                '"status" : "fail"' + ',' +
                                '"error" : 1' + ',' +
                                '"errordetail" : null' + ',' +
                                '"data" : null' +
                            '}' 
                           );
                res.setStatusCode(SNGHttpUtilities.STATUS_CODE.OK);
    		}
    		else if (jsonRequestBody.contains(SUNNY_DAY_MAC_ADDRESS_SINGLE))
    		{
    			String macAddressFormatted = SUNNY_DAY_MAC_ADDRESS_SINGLE.replaceAll(':', '').toUpperCase();
    			res.setHeader('Content-Type', 'application/json');
    			res.setBody('{' +
    						  '"status" : "success"' + ',' +
    						  '"error": 0' + ',' +
    						  '"errordetail" : null' + ',' +
    						  '"data":' +
    						  '[ [ {' +
    						      '"startTime" : "' + SINGLE_START_TIME + '" ,' +
    						      '"endTime" : "' + SINGLE_END_TIME + '" ,' +
    							  '"firstProcessedEventTimestamp" : "' + SINGLE_FIRST_PROCESSED + '" ,' +
    							  '"lastProcessedEventTimestamp"  : "' + SINGLE_LAST_PROCESSED + '" , ' +
    							  '"aggregateAcctInputOctets" : ' + SINGLE_AGGREGATE_DOWNLOAD + ',' +
    							  '"aggregateAcctOutputOctets" : ' + SINGLE_AGGREGATE_UPLOAD + ',' +
    							  '"macAddress" : "' + macAddressFormatted + '" ,' +
    							  '"usage" : ' +
    							  '[ {' +
    							  		'"bsid" : "' + SINGLE_BSID_NAME + '", ' +
    							  		'"acctInputOctets" : ' + SINGLE_BSID_DOWNLOAD + ',' +
    							  		'"acctOutputOctets" : ' + SINGLE_BSID_UPLOAD +
    							  '} ]' +
    						  '} ] ]' +
    					    '}'
    					   );
    			res.setStatusCode(SNGHttpUtilities.STATUS_CODE.OK);
    		}
    		else if (jsonRequestBody.contains(SUNNY_DAY_MAC_ADDRESS_CURRENT))
    		{
    		    String singleJsonRequestBody = jsonRequestBody.remove('[').remove(']');
    			SNG_ModemUsageDate mspDate = SNG_ModemUsageDate.deserialize(singleJsonRequestBody);
    			
                String macAddressFormatted = SUNNY_DAY_MAC_ADDRESS_CURRENT.replaceAll(':', '').toUpperCase();
                
                Date startDate = SNG_DateUtils.todayGmt().toStartOfMonth(); 
                Date endDate = startDate.addMonths(1);
                String startTimeStr = formatDate(startDate);
                String endTimeStr = formatDate(endDate);
              	
                Date mspStartTime = Date.newInstance(mspDate.startTime.yearGmt(), mspDate.startTime.monthGmt(), mspDate.startTime.dayGmt());
                Date mspEndTime = Date.newInstance(mspDate.endTime.yearGmt(), mspDate.endTime.monthGmt(), mspDate.endTime.dayGmt());
                
                System.debug(LoggingLevel.ERROR, 'RT TEST requestBody: ' + singleJsonRequestBody);
                System.debug(LoggingLevel.ERROR, 'RT TEST mspDate: ' + mspDate);
                System.debug(LoggingLevel.ERROR, 'RT TEST mspDate.startTime: ' + mspDate.startTime.date() + ' ' + mspDate.startTime.dateGmt());
                System.debug(LoggingLevel.ERROR, 'RT Test dayGmt(): ' + mspDate.startTime.day() + mspDate.startTime.dayGmt());
                
                System.debug(LoggingLevel.ERROR, 'YL msp start date: ' + mspStartTime);
                
                Date firstProcessedDate = SNG_DateUtils.max(startDate, mspStartTime);
                Date lastProcessedDate = SNG_DateUtils.min(endDate, mspEndTime);
                String firstProcessedStr = formatDate(firstProcessedDate);
                String lastProcessedDateStr = formatDate(lastProcessedDate);
                
                System.debug(LoggingLevel.ERROR, 'YL firstProcessedStr: ' + firstProcessedStr);
                

                res.setHeader('Content-Type', 'application/json');
                res.setBody('{' +
                              '"status" : "success"' + ',' +
                              '"error": 0' + ',' +
                              '"errordetail" : null' + ',' +
                              '"data":' +
                              '[ [ {' +
                                  '"startTime" : "' + startTimeStr + '" ,' +
                                  '"endTime" : "' + endTimeStr + '" ,' +
                                  '"firstProcessedEventTimestamp" : "' + firstProcessedStr + '" ,' +
                                  '"lastProcessedEventTimestamp"  : "' + lastProcessedDateStr + '" , ' +
                                  '"aggregateAcctInputOctets" : ' + SINGLE_AGGREGATE_DOWNLOAD + ',' +
                                  '"aggregateAcctOutputOctets" : ' + SINGLE_AGGREGATE_UPLOAD + ',' +
                                  '"macAddress" : "' + macAddressFormatted + '" ,' +
                                  '"usage" : ' +
                                  '[ {' +
                                        '"bsid" : "' + SINGLE_BSID_NAME + '", ' +
                                        '"acctInputOctets" : ' + SINGLE_BSID_DOWNLOAD + ',' +
                                        '"acctOutputOctets" : ' + SINGLE_BSID_UPLOAD +
                                  '} ]' +
                              '} ] ]' +
                            '}'
                           );
                res.setStatusCode(SNGHttpUtilities.STATUS_CODE.OK);   			
    		}
    		else if (jsonRequestBody.contains(SUNNY_DAY_MAC_ADDRESS_NO_DATA))
            {
                String macAddressFormatted = SUNNY_DAY_MAC_ADDRESS_SINGLE.replaceAll(':', '').toUpperCase();
                res.setHeader('Content-Type', 'application/json');
                res.setBody('{' +
                              '"status" : "success"' + ',' +
                              '"error": 0' + ',' +
                              '"errordetail" : null' + ',' +
                              '"data":[[]]' +
                              '}'
                           );
                res.setStatusCode(SNGHttpUtilities.STATUS_CODE.OK);
            }
    		else if (jsonRequestBody.contains(SUNNY_DAY_MAC_ADDRESS_SINGLE_TE))
            {
                String macAddressFormatted = SUNNY_DAY_MAC_ADDRESS_SINGLE_TE.replaceAll(':', '').toUpperCase();
                res.setHeader('Content-Type', 'application/json');
                res.setBody('{' +
                              '"status" : "success"' + ',' +
                              '"error": 0' + ',' +
                              '"errordetail" : null' + ',' +
                              '"data":' +
                              '[ [ {' +
                                  '"startTime" : "' + SINGLE_START_TIME + '" ,' +
                                  '"endTime" : "' + SINGLE_END_TIME + '" ,' +
                                  '"firstProcessedEventTimestamp" : "' + SINGLE_FIRST_PROCESSED + '" ,' +
                                  '"lastProcessedEventTimestamp"  : "' + SINGLE_LAST_PROCESSED + '" , ' +
                                  '"aggregateAcctInputOctets" : ' + SINGLE_AGGREGATE_DOWNLOAD + ',' +
                                  '"aggregateAcctOutputOctets" : ' + SINGLE_AGGREGATE_UPLOAD + ',' +
                                  '"macAddress" : "' + macAddressFormatted + '" ,' +
                                  '"usage" : ' +
                                  '[ {' +
                                        '"bsid" : "' + SINGLE_BSID_NAME + '", ' +
                                        '"acctInputOctets" : ' + SINGLE_BSID_DOWNLOAD + ',' +
                                        '"acctOutputOctets" : ' + SINGLE_BSID_UPLOAD +
                                  '} ]' +
                                  '},' +
                                  '{' +
                                  '"startTime" : "' + SINGLE_TE_START_TIME + '" ,' +
                                  '"endTime" : "' + SINGLE_TE_END_TIME + '" ,' +
                                  '"firstProcessedEventTimestamp" : "' + SINGLE_TE_FIRST_PROCESSED + '" ,' +
                                  '"lastProcessedEventTimestamp"  : "' + SINGLE_TE_LAST_PROCESSED + '" , ' +
                                  '"aggregateAcctInputOctets" : ' + SINGLE_TE_AGGREGATE_DOWNLOAD + ',' +
                                  '"aggregateAcctOutputOctets" : ' + SINGLE_TE_AGGREGATE_UPLOAD + ',' +
                                  '"macAddress" : "' + macAddressFormatted + '" ,' +
                                  '"usage" : ' +
                                  '[ {' +
                                        '"bsid" : "' + SINGLE_TE_BSID_NAME + '", ' +
                                        '"acctInputOctets" : ' + SINGLE_TE_BSID_DOWNLOAD + ',' +
                                        '"acctOutputOctets" : ' + SINGLE_TE_BSID_UPLOAD +
                                  '} ]' +
                                  
                              '} ] ]' +
                            '}'
                           );
                res.setStatusCode(SNGHttpUtilities.STATUS_CODE.OK);
            }
            
            // Added for current month usage data
            else if (jsonRequestBody.contains(SUNNY_DAY_MAC_ADDRESS_CURRENT_SINGLE_TE))
            {
            	String macAddressFormatted = SUNNY_DAY_MAC_ADDRESS_CURRENT_SINGLE_TE.replaceAll(':', '').toUpperCase();
                res.setHeader('Content-Type', 'application/json');
                res.setBody('{' +
                              '"status" : "success"' + ',' +
                              '"error": 0' + ',' +
                              '"errordetail" : null' + ',' +
                              '"data":' +
                              '[ [ {' +
                                  '"startTime" : "' + SINGLE_CURRENT_TE_START_TIME + '" ,' +
                                  '"endTime" : "' + SINGLE_CURRENT_TE_END_TIME + '" ,' +
                                  '"firstProcessedEventTimestamp" : "' + SINGLE_CURRENT_TE_FIRST_PROCESSED + '" ,' +
                                  '"lastProcessedEventTimestamp"  : "' + SINGLE_CURRENT_TE_LAST_PROCESSED + '" , ' +
                                  '"aggregateAcctInputOctets" : ' + SINGLE_TE_AGGREGATE_DOWNLOAD + ',' +
                                  '"aggregateAcctOutputOctets" : ' + SINGLE_TE_AGGREGATE_UPLOAD + ',' +
                                  '"macAddress" : "' + macAddressFormatted + '" ,' +
                                  '"usage" : ' +
                                  '[ {' +
                                        '"bsid" : "' + SINGLE_TE_BSID_NAME + '", ' +
                                        '"acctInputOctets" : ' + SINGLE_TE_BSID_DOWNLOAD + ',' +
                                        '"acctOutputOctets" : ' + SINGLE_TE_BSID_UPLOAD +
                                  '} ]' +
                                  
                              '} ] ]' +
                            '}'
                           );
                res.setStatusCode(SNGHttpUtilities.STATUS_CODE.OK);
            }
    		
    		// Multiple mac addresses, only one returns
    		else if (jsonRequestBody.contains(OK_WITH_ERRORS_MAC_ADDRESS))
    		{
				String macAddressFormatted = OK_WITH_ERRORS_MAC_ADDRESS.replaceAll(':', '').toUpperCase();
    			res.setHeader('Content-Type', 'application/json');
    			res.setBody('{' +
    						  '"status" : "failure"' + ',' +
    						  '"error": 0' + ',' +
    						  '"errordetail" : null' + ',' +
    						  '"data":' +
    						  '[ [ {' +
    						      '"startTime" : "' + OK_WITH_ERRORS_START_TIME + '" ,' +
    						      '"endTime" : "' + OK_WITH_ERRORS_END_TIME + '" ,' +
    							  '"firstProcessedEventTimestamp" : "' + OK_WITH_ERRORS_FIRST_PROCESSED + '" ,' +
    							  '"lastProcessedEventTimestamp"  : "' + OK_WITH_ERRORS_LAST_PROCESSED + '" , ' +
    							  '"aggregateAcctInputOctets" : ' + OK_WITH_ERRORS_AGGREGATE_DOWNLOAD + ',' +
    							  '"aggregateAcctOutputOctets" : ' + OK_WITH_ERRORS_AGGREGATE_UPLOAD + ',' +
    							  '"macAddress" : "' + macAddressFormatted + '" ,' +
    							  '"usage" : ' +
    							  '[ {' +
    							  		'"bsid" : "' + OK_WITH_ERRORS_BSID_NAME + '", ' +
    							  		'"acctInputOctets" : ' + OK_WITH_ERRORS_BSID_DOWNLOAD + ',' +
    							  		'"acctOutputOctets" : ' + OK_WITH_ERRORS_BSID_UPLOAD +
    							  '} ]' +
    						  '} ] ]' +
    					    '}'
    					   );
    			res.setStatusCode(SNGHttpUtilities.STATUS_CODE.OK);    		
    		}  		
    		else if (jsonRequestBody.contains(INVALID_MAC_ADDRESS_RESPONSE_FORMAT))
    		{
				String macAddressFormatted = 'asdfafafasf';
    			res.setHeader('Content-Type', 'application/json');
    			res.setBody('{' +
    						  '"status" : "failure"' + ',' +
    						  '"error": 0' + ',' +
    						  '"errordetail" : null' + ',' +
    						  '"data":' +
    						  '[ {' +
    						      '"startTime" : "' + OK_WITH_ERRORS_START_TIME + '" ,' +
    						      '"endTime" : "' + OK_WITH_ERRORS_END_TIME + '" ,' +
    							  '"firstProcessedEventTimestamp" : "' + OK_WITH_ERRORS_FIRST_PROCESSED + '" ,' +
    							  '"lastProcessedEventTimestamp"  : "' + OK_WITH_ERRORS_LAST_PROCESSED + '" , ' +
    							  '"aggregateAcctInputOctets" : ' + OK_WITH_ERRORS_AGGREGATE_DOWNLOAD + ',' +
    							  '"aggregateAcctOutputOctets" : ' + OK_WITH_ERRORS_AGGREGATE_UPLOAD + ',' +
    							  '"macAddress" : "' + macAddressFormatted + '" ,' +
    							  '"usage" : ' +
    							  '[ {' +
    							  		'"bsid" : "' + OK_WITH_ERRORS_BSID_NAME + '", ' +
    							  		'"acctInputOctets" : ' + OK_WITH_ERRORS_BSID_DOWNLOAD + ',' +
    							  		'"acctOutputOctets" : ' + OK_WITH_ERRORS_BSID_UPLOAD +
    							  '} ]' +
    						  '} ]' +
    					    '}'
    					   );
    			res.setStatusCode(SNGHttpUtilities.STATUS_CODE.OK);    		
    		}
    		else if (jsonRequestBody.contains(SUNNY_DAY_MAC_ADDRESS_DOUBLE_A) &&
    				 jsonRequestBody.contains(SUNNY_DAY_MAC_ADDRESS_DOUBLE_B) )
    		{
 				String macAddressAFormatted = SUNNY_DAY_MAC_ADDRESS_DOUBLE_A.replaceAll(':', '').toUpperCase();
 				String macAddressBFormatted = SUNNY_DAY_MAC_ADDRESS_DOUBLE_B.replaceAll(':', '').toUpperCase();
    			res.setHeader('Content-Type', 'application/json');
    			res.setBody('{' +
    						  '"status" : "success"' + ',' +
    						  '"error": 0' + ',' +
    						  '"errordetail" : null' + ',' +
    						  '"data":' +
    						  '[ [{' +
    						      '"startTime" : "' + DOUBLE_A_START_TIME + '" ,' +
    						      '"endTime" : "' + DOUBLE_A_END_TIME + '" ,' +
    							  '"firstProcessedEventTimestamp" : "' + DOUBLE_A_FIRST_PROCESSED + '" ,' +
    							  '"lastProcessedEventTimestamp"  : "' + DOUBLE_A_LAST_PROCESSED + '" , ' +
    							  '"aggregateAcctInputOctets" : ' + DOUBLE_A_AGGREGATE_DOWNLOAD + ',' +
    							  '"aggregateAcctOutputOctets" : ' + DOUBLE_A_AGGREGATE_UPLOAD + ',' +
    							  '"macAddress" : "' + macAddressAFormatted + '" ,' +
    							  '"usage" : ' +
    							  '[ {' +
    							  		'"bsid" : "' + DOUBLE_A_BSID_NAME + '", ' +
    							  		'"acctInputOctets" : ' + DOUBLE_A_BSID_DOWNLOAD + ',' +
    							  		'"acctOutputOctets" : ' + DOUBLE_A_BSID_UPLOAD +
    							  '} ]' +
    						     '} ],' +
    						    '[ {' +
								  '"startTime" : "' + DOUBLE_B_START_TIME + '" ,' +
    						      '"endTime" : "' + DOUBLE_B_END_TIME + '" ,' +
    							  '"firstProcessedEventTimestamp" : "' + DOUBLE_B_FIRST_PROCESSED + '" ,' +
    							  '"lastProcessedEventTimestamp"  : "' + DOUBLE_B_LAST_PROCESSED + '" , ' +
    							  '"aggregateAcctInputOctets" : ' + DOUBLE_B_AGGREGATE_DOWNLOAD + ',' +
    							  '"aggregateAcctOutputOctets" : ' + DOUBLE_B_AGGREGATE_UPLOAD + ',' +
    							  '"macAddress" : "' + macAddressBFormatted + '" ,' +
    							  '"usage" : ' +
    							  '[ {' +
    							  		'"bsid" : "' + DOUBLE_B_BSID_NAME + '", ' +
    							  		'"acctInputOctets" : ' + DOUBLE_B_BSID_DOWNLOAD + ',' +
    							  		'"acctOutputOctets" : ' + DOUBLE_B_BSID_UPLOAD +
    							  '} ]' +    						  
    						  
    						    '} ] ]' +
    					    '}'
    					   );
    			res.setStatusCode(SNGHttpUtilities.STATUS_CODE.OK);       			
    		}
    		else if (jsonRequestBody.contains(SUNNY_DAY_MAC_ADDRESS_DOUBLE_A))
    		{
   				String macAddressAFormatted = SUNNY_DAY_MAC_ADDRESS_DOUBLE_A.replaceAll(':', '').toUpperCase();
    			res.setHeader('Content-Type', 'application/json');
    			res.setBody('{' +
    						  '"status" : "success"' + ',' +
    						  '"error": 0' + ',' +
    						  '"errordetail" : null' + ',' +
    						  '"data":' +
    						  '[ [ {' +
    						      '"startTime" : "' + DOUBLE_A_START_TIME + '" ,' +
    						      '"endTime" : "' + DOUBLE_A_END_TIME + '" ,' +
    							  '"firstProcessedEventTimestamp" : "' + DOUBLE_A_FIRST_PROCESSED + '" ,' +
    							  '"lastProcessedEventTimestamp"  : "' + DOUBLE_A_LAST_PROCESSED + '" , ' +
    							  '"aggregateAcctInputOctets" : ' + DOUBLE_A_AGGREGATE_DOWNLOAD + ',' +
    							  '"aggregateAcctOutputOctets" : ' + DOUBLE_A_AGGREGATE_UPLOAD + ',' +
    							  '"macAddress" : "' + macAddressAFormatted + '" ,' +
    							  '"usage" : ' +
    							  '[ {' +
    							  		'"bsid" : "' + DOUBLE_A_BSID_NAME + '", ' +
    							  		'"acctInputOctets" : ' + DOUBLE_A_BSID_DOWNLOAD + ',' +
    							  		'"acctOutputOctets" : ' + DOUBLE_A_BSID_UPLOAD +
    							  '} ]' +
    						  '} ] ,' +
    						  '[ {' +
								  '"startTime" : "' + DOUBLE_A1_START_TIME + '" ,' +
    						      '"endTime" : "' + DOUBLE_A1_END_TIME + '" ,' +
    							  '"firstProcessedEventTimestamp" : "' + DOUBLE_A1_FIRST_PROCESSED + '" ,' +
    							  '"lastProcessedEventTimestamp"  : "' + DOUBLE_A1_LAST_PROCESSED + '" , ' +
    							  '"aggregateAcctInputOctets" : ' + DOUBLE_A1_AGGREGATE_DOWNLOAD + ',' +
    							  '"aggregateAcctOutputOctets" : ' + DOUBLE_A1_AGGREGATE_UPLOAD + ',' +
    							  '"macAddress" : "' + macAddressAFormatted + '" ,' +
    							  '"usage" : ' +
    							  '[ {' +
    							  		'"bsid" : "' + DOUBLE_A1_BSID_NAME + '", ' +
    							  		'"acctInputOctets" : ' + DOUBLE_A1_BSID_DOWNLOAD + ',' +
    							  		'"acctOutputOctets" : ' + DOUBLE_A1_BSID_UPLOAD +
    							  '} ]' +    						  
    						  
    						  '} ] ]' +
    					    '}'
    					   );
    			res.setStatusCode(SNGHttpUtilities.STATUS_CODE.OK);   			
    		}
    		else
    		{
    			System.debug('no match for anything.');
    		}
    	}
        else if (ENDPOINT.startsWith(SNG_MockCustomSettings.MOCK_OPENAM_URL)) {
            System.debug('SNG_MockUsageServiceHttpCallout.respond: OpenAM Authentication');
            System.assertEquals('GET', req.getMethod());
            
            res.setStatusCode(SNGHttpUtilities.STATUS_CODE.OK);
            res.setBody('token.id=' + SNG_MockHttpCallout.TOKEN_ID);
        }
        
        System.debug('Response body: ' + res.getBody());
        
        return res;
    }
    
    
    private String formatDate(Date dateToFormat)
    {
        return dateToFormat.year() + '-' + dateToFormat.month() + '-' + dateToFormat.day() + 'T00:00:00Z';
    }

}