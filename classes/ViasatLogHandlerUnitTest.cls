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
private class ViasatLogHandlerUnitTest 
{
    private static final String PROJECT_NAME = 'SNG_TEST';  
    private static final String DEFAULT_MESSAGE = 'Default Message';    
    private static final String DEFAULT_DETAILS = 'Default Details';    
    private static final String DEFAULT_STACK_TRACE = 'Default Stack Trace';    
    private static final String DEFAULT_PROCESS_ID = 'Default Process ID';  
    private static final String DEFAULT_USER_ID = 'Default User ID';    
    private static final String DEFAULT_HTTP_CODE = '200';
    
    static testMethod void testLog() 
    {   
		ViasatTestUtility.setGlobals();
		
        Test.startTest();
        
        ViasatLogHandler.LogAsync(PROJECT_NAME, ViasatLogHandler.SeverityTypeMINOR,     DEFAULT_MESSAGE);
        ViasatLogHandler.LogAsync(PROJECT_NAME, ViasatLogHandler.SeverityTypeMINOR,     DEFAULT_MESSAGE, DEFAULT_DETAILS);
        ViasatLogHandler.LogAsync(PROJECT_NAME, ViasatLogHandler.SeverityTypeMAJOR,     DEFAULT_MESSAGE, DEFAULT_DETAILS, DEFAULT_STACK_TRACE);
        ViasatLogHandler.LogAsync(PROJECT_NAME, ViasatLogHandler.SeverityTypeCRITICAL,  DEFAULT_MESSAGE, DEFAULT_DETAILS, DEFAULT_STACK_TRACE, DEFAULT_PROCESS_ID);
        ViasatLogHandler.LogAsync(PROJECT_NAME, ViasatLogHandler.SeverityTypeCRITICAL,  DEFAULT_MESSAGE, DEFAULT_DETAILS, DEFAULT_STACK_TRACE, DEFAULT_PROCESS_ID, DEFAULT_USER_ID);
        ViasatLogHandler.LogAsync(PROJECT_NAME, ViasatLogHandler.SeverityTypeEXCEPTION, DEFAULT_MESSAGE, DEFAULT_DETAILS, DEFAULT_STACK_TRACE, DEFAULT_PROCESS_ID, DEFAULT_USER_ID, DEFAULT_HTTP_CODE);

        ViasatLogHandler.Log(PROJECT_NAME, ViasatLogHandler.SeverityTypeMINOR,     DEFAULT_MESSAGE, DEFAULT_DETAILS);
        ViasatLogHandler.Log(PROJECT_NAME, ViasatLogHandler.SeverityTypeMAJOR,     DEFAULT_MESSAGE, DEFAULT_DETAILS, DEFAULT_STACK_TRACE);
        ViasatLogHandler.Log(PROJECT_NAME, ViasatLogHandler.SeverityTypeCRITICAL,  DEFAULT_MESSAGE, DEFAULT_DETAILS, DEFAULT_STACK_TRACE, DEFAULT_PROCESS_ID);
        //ViasatLogHandler.Log(PROJECT_NAME, ViasatLogHandler.SeverityTypeCRITICAL,  DEFAULT_MESSAGE, DEFAULT_DETAILS, DEFAULT_STACK_TRACE, DEFAULT_PROCESS_ID, DEFAULT_USER_ID);
        ViasatLogHandler.Log(PROJECT_NAME, ViasatLogHandler.SeverityTypeEXCEPTION, DEFAULT_MESSAGE, DEFAULT_DETAILS, DEFAULT_STACK_TRACE, DEFAULT_PROCESS_ID, DEFAULT_USER_ID, DEFAULT_HTTP_CODE);
        
        String inputMessage = ''; 
        String details = ''; 
        for (integer i = 0; i < 250; i++) { 
            inputMessage += DEFAULT_MESSAGE;
            details += DEFAULT_DETAILS;
        }
        ViasatLogHandler.Log(PROJECT_NAME, ViasatLogHandler.SeverityTypeEXCEPTION, inputMessage, details, DEFAULT_STACK_TRACE, DEFAULT_PROCESS_ID, DEFAULT_USER_ID, DEFAULT_HTTP_CODE, 'status');
		
        List<ViasatLog__c> viasatLogEntries = [SELECT Project__c, Type__c, Message__c, Details__c, ProcessID__c, UserID__c, StackTrace__c, StatusCode__c FROM ViasatLog__c];    
        System.assert(viasatLogEntries.size() >= 4);
		
		// Test Apex Job
        final Id cronTriggerId;
/*
        // Even in 24.0, with SeeAllData set to false by default, existing CronTrigger records are visible, this is a SFDC bug.
        // Therefore, to avoid 'System.AsyncException: The Apex job named "ScheduledJob" is already scheduled for execution' abort all existing Scheduled Jobs.
        // Cannot look for and abort only "ScheduledJob" because of an SFDC bug where Name Field is not exposed in CronTrigger, thus the abort all loop.
        //for (CronTrigger cronTrigger : [SELECT Id FROM CronTrigger]) System.abortJob(cronTrigger.Id);
 
        // AsyncApexJob correctly follows SeeAllData=false as this count returns 0 even if existing Batch Job history in org.
        //System.assertEquals(0, [SELECT COUNT() FROM AsyncApexJob
        //                        WHERE ApexClassId IN (SELECT Id FROM ApexClass WHERE NamespacePrefix = null AND Name = 'ViaSatLogJob')]);
        Test.startTest();
        cronTriggerId = System.schedule('ViaSatLogJob', '0 0 * * * ?', new ViaSatLogJob());
        Test.stopTest();
        //System.assertEquals(1, [SELECT COUNT() FROM AsyncApexJob
        //                        WHERE ApexClassId IN (SELECT Id FROM ApexClass WHERE NamespacePrefix = null AND Name = 'ViaSatLogJob')]);
        // This proves that the Scheduled Job has kicked off the Batch Job. You may now proceed to test Batch Job itself directly in its own test method.
        //System.assertEquals('Queued', [SELECT Status FROM AsyncApexJob
        //                               WHERE ApexClassId IN (SELECT Id FROM ApexClass WHERE NamespacePrefix = null AND Name = 'ViaSatLogJob')].Status);
*/    
        try{
        	cronTriggerId = System.schedule('ViaSatLogJob', '0 0 * * * ?', new ViaSatLogJob());
        } catch(Exception e){}
        
        try{
        	ViaSatLogJob.start();
        } catch(Exception e){}
		
		list<ViasatLog__c>scope = [SELECT Id, Type__c, CreatedDate FROM ViasatLog__c];
		ViaSatLogJob b = new ViaSatLogJob();
		string s = ViaSatLogJob.executeBatch(scope);
		list<AsyncApexJob> jobList = [Select Id, Status, NumberOfErrors, JobItemsProcessed, TotalJobItems, CreatedBy.Email from AsyncApexJob];
		if (jobList != null && jobList.size() > 0)
			s = ViaSatLogJob.finishJob(jobList[0].Id ,'');
		ViaSatLogJob.sendBatchResultEmail('subject', 'body');
		
        Test.stopTest();
    }
      
    static testMethod void testGenerateNounce() {
        
        try {
            String randomNumber = ViasatLogHandler.generateNounce();
            System.assertNotEquals(null, randomNumber);
        }
        catch (Exception e) { 
            System.assert(false);
        }
    }
}