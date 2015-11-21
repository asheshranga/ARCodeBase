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
private class SNGVisualforceErrorReporterUnitTest {
	
	private static final String PROJECT_NAME = 'TestSNG';

    static testMethod void errorMessageNotFromVFPage() {
    	SNG_MockCustomSettings.initialize();
       	
       	// SNGVisualforceErrorReporter.reportError has a @future method, keep in betwen startTest() and stopTest() to have it fire before asserts
       	Test.startTest();
        SNGVisualforceErrorReporter.reportError('mock external message', 'mock internal message' );
		Test.stopTest();
		
        // not from visualforce page, no messages
        System.assertEquals(ApexPages.getMessages().size(),0);
		
		// Retrieve ViasatLog SObjects that were created by reportError()
		List<ViasatLog__c> logObjects = [SELECT Details__c, Message__c, ProcessID__c, Project__c, StackTrace__c, Status__c, StatusCode__c, Type__c, UserID__c  
										FROM ViasatLog__c];
    	
    	// error not sent from visualforce page, should have 2 ViasatLog Sobjects
    	System.assertEquals(logObjects.size(), 2);
    	
    	ViasatLog__c expectedLogObj = null;
    	
    	for (ViasatLog__c actualObj : logObjects)
    	{
    		if (actualObj.Message__c == 'ReportError was invoked from a Non-Visualforce page. Message: mock external message')
    		{
    			expectedLogObj = buildViasatLogObject(null, 'ReportError was invoked from a Non-Visualforce page. Message: mock external message', 
    							null, PROJECT_NAME, true, null, 'Exception', null);
    			logObjectVerifier(expectedLogObj, actualObj);
    		}
    		else if (actualObj.Message__c == 'mock internal message')
    		{
    			expectedLogObj = buildViasatLogObject(null, 'mock internal message', null, PROJECT_NAME, true, null, 'Exception', null);
    			logObjectVerifier(expectedLogObj, actualObj);
    		}
    		else 
    		{
    			System.assert(false);
    		}
    			
    	}
    	
    	for (ViasatLog__c obj : logObjects) 
    	{
    		// ViasatLog__c SObjects should be Exception type
    		System.assertEquals(obj.Type__c, 'Exception');
    		
    		// ViasatLog__c SObjects are from SNG project 
    		System.assertEquals(obj.Project__c, 'TestSNG');
    	}
    }

    static testMethod void errorMessageFromVFPage() {
    	SNG_MockCustomSettings.initialize();
    	PageReference vfPage = new PageReference('/apex/TestPage');
    	Test.setCurrentPage(vfPage);

		Test.startTest();
    	SNGVisualforceErrorReporter.reportError('mock external message', 'mock internal message');
	
    	// there should only be one message in the Apex Page message
    	System.assert(ApexPages.getMessages().size() == 1);
    	System.assert(ApexPages.getMessages().get(0).getSummary() == 'mock external message');
    	Test.stopTest();
    	
    	
    	List<ViasatLog__c> logObjects = [SELECT Details__c, Message__c, ProcessID__c, Project__c, StackTrace__c, Status__c, StatusCode__c, Type__c, UserID__c  
										FROM ViasatLog__c];
		
		// Logging from visualforce page results in one ViasatLog__c SOjbect
		System.assertEquals(logObjects.size(), 1);
		
		ViasatLog__c expectedLogObj = buildViasatLogObject(null, 'mock internal message', null, PROJECT_NAME, true, null, 'Exception', null);
		
		logObjectVerifier(expectedLogObj, logObjects.get(0));
    }


    static testMethod void exceptionFromVFPageWithExternalMessage() {
    	SNG_MockCustomSettings.initialize();
    	SNG_Exception testException = new SNG_Exception('mock exception message');
		PageReference vfPage = new PageReference('/apex/TestPage');
		Test.setCurrentPage(vfpage);
		
		Test.startTest();
		SNGVisualforceErrorReporter.reportError(testException, 'mock external message');

		System.assert(ApexPages.getMessages().size() == 1);

		System.assert(ApexPages.getMessages().get(0).getSummary() == 'mock external message');
		Test.stopTest();
		
		
		List<ViasatLog__c> logObjects = [SELECT Details__c, Message__c, ProcessID__c, Project__c, StackTrace__c, Status__c, StatusCode__c, Type__c, UserID__c  
										FROM ViasatLog__c];
		
		// Logging from a visualforce page results in one logged ViasatLog__c SObject
		System.assertEquals(logObjects.size(), 1); 
		
		ViasatLog__c expectedLogObj = buildViasatLogObject(null, 'mock exception message', null, PROJECT_NAME, false, null, 'Exception', null);
		
		// Verify ViasatLog__c SObject
		logObjectVerifier(expectedLogObj, logObjects.get(0));
    }


    private static testMethod void exceptionWithSetExternalMessage() {
    	
    	SNG_MockCustomSettings.initialize();
    	SNG_Exception testException = new SNG_Exception('mock exception message');
    	PageReference vfPage = new PageReference('/apex/TestPage');
    	Test.setCurrentPage(vfpage);
		
		Test.startTest();
    	SNGVisualforceErrorReporter.reportError(testException);

    	System.assert(ApexPages.getMessages().size() == 1);
    	System.assert(ApexPages.getMessages().get(0).getSummary() == 'Unexpected error');
    	Test.stopTest();
    	
		List<ViasatLog__c> logObjects = [SELECT Details__c, Message__c, ProcessID__c, Project__c, StackTrace__c, Status__c, StatusCode__c, Type__c, UserID__c  
										FROM ViasatLog__c];
		
		// Logging from a visualforce page results in one logged ViasatLog__c Sobject								
		System.assertEquals(logObjects.size(), 1);
		
		ViasatLog__c expectedLogObj = buildViasatLogObject(null, 'mock exception message', null, PROJECT_NAME, false, null, 
															'Exception', null);
		
		logObjectVerifier(expectedLogObj, logObjects.get(0));
    }
    

    static testMethod void errorMessageWithStackTrace() {
    	SNG_MockCustomSettings.initialize();
    	PageReference vfPage = new PageReference('/apex/TestPage');
    	Test.setCurrentPage(vfPage);
		
		Test.startTest();
    	
    	SNGVisualforceErrorReporter.reportError('mock external message', 'mock internal message', 'mock stack trace');
    	SNGVisualforceErrorReporter.reportError('another mock external message', 'internal message', 'test');

    	System.assert(ApexPages.getMessages().size() == 2);
    	System.assert(ApexPages.getMessages().get(0).getSummary() == 'mock external message');
    	System.assert(ApexPages.getMessages().get(1).getSummary() == 'another mock external message');
    	
    	Test.stopTest();
    	
    	
    	List<ViasatLog__c> logObjects = [SELECT Details__c, Message__c, ProcessID__c, Project__c, StackTrace__c, Status__c, StatusCode__c, Type__c, UserID__c  
										FROM ViasatLog__c];
		
		// reportError from visualforce page, should have 2 log objects
		System.assertEquals(logObjects.size(), 2);					
		
		ViasatLog__c expectedLogObj = null;
		
		for(ViasatLog__c actualObj : logObjects)
		{
			if (actualObj.Message__c == 'mock internal message')
			{
				expectedLogObj = buildViasatLogObject(null, 'mock internal message', null, PROJECT_NAME, false, null, 'Exception', null);
				logObjectVerifier(expectedLogObj, actualObj);
			}
			else if (actualObj.Message__c == 'internal message')
			{
				expectedLogObj = buildViasatLogObject(null, 'internal message', null, PROJECT_NAME, false, null, 'Exception', null);
				logObjectVerifier(expectedLogObj, actualObj);
			}
			else 
			{
				System.assert(false);
			}
		}								
    }
    
    private static ViasatLog__c buildViasatLogObject(String details, String message, String processId, String project, 
    												boolean stackTraceNull, String statusCode, String logType, String userId)
    {
    	String sProcessId = null;
    	if (processId == null)
    	{
    		sProcessId = UserInfo.getSessionId();
    		if (sProcessId.length() > 50)
    		{
    			sProcessId = sProcessId.subString(0,49);
    		}
    	}
    	
    	String sUserId = null;
    	if (sUserId == null)
    	{
    		sUserId = UserInfo.getUserId();
    	}
    	
    	String stackTrace = null;
    	if (!stackTraceNull)
    	{
    		stackTrace = 'stack trace';
    	}
    	
    	ViasatLog__c obj = new ViasatLog__c(Details__c=details, Message__c=message, ProcessID__c=sProcessId, Project__c=project, 
    										StackTrace__c=stackTrace, StatusCode__c=statusCode, Type__c=logType, 
    										UserID__c=sUserId);
    	
    	return obj;
    }
    
    private static void logObjectVerifier(ViasatLog__c expectedLogObj, ViasatLog__c actualLogObj)
    {
    	System.assertEquals(expectedLogObj.Details__c, actualLogObj.Details__c);
    	System.assertEquals(expectedLogObj.Message__c, actualLogObj.Message__c);
    	//System.assertEquals(expectedLogObj.ProcessID__c, actualLogObj.ProcessID__c);
    	System.assertEquals(expectedLogObj.Project__c, actualLogObj.Project__c);
    	System.assertEquals(expectedLogObj.StatusCode__c, actualLogObj.StatusCode__c);
    	System.assertEquals(expectedLogObj.Type__c, actualLogObj.Type__c);
    	System.assertEquals(expectedLogObj.UserID__c, actualLogObj.UserID__c);
    	
    	if (expectedLogObj.StackTrace__c != null)
    	{
    		System.assertNotEquals(actualLogObj.StackTrace__c, null);
    	}
    	else 
    	{
    		System.assertEquals(actualLogObj.StackTrace__c, null);
    	}
    }
}