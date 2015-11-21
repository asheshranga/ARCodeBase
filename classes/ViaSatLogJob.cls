/*****************************************************************
Name          : ViaSatLogJob
Created By    : Marina Basovich
Company Name  : ViaSat
Description   : Scheduled Job that runs every day to Clean ViasatLog records older than 60 days
******************************************************************
*/
global class ViaSatLogJob implements Database.Batchable<sObject>, Schedulable 
{
	static string appName = 'ViaSatLogJob';	
	public String query;

	global ViaSatLogJob()
	{
		Globals__c gs = Globals__c.getInstance();
		integer lastNDays = (integer)gs.ViaSatLogLastNDays__c;

		string timeframe = 'LAST_N_DAYS:' + string.valueOf(lastNDays);
        query = 'SELECT Id, Type__c, CreatedDate FROM ViasatLog__c WHERE IsDeleted = false and CreatedDate < ' + timeFrame ; //Status__c in (\'Security\')';       
        System.debug('*** APEX Job Query:' + query);		
	}

	// ------------------ METHODS to Implement the Batchable Interface--------------------------------------
	global Database.QueryLocator start(Database.BatchableContext BC)
	{
        System.debug('*** ' + appName + ' started, Query:' + query);
		return Database.getQueryLocator(query);
	}

    global void execute(Database.BatchableContext BC, List<Sobject> scope)
    {
        String result = executeBatch(scope);
        System.Debug('*** ' + appName + ' processed the scope of ' + scope.size() + ' records');
    }

	global void finish(Database.BatchableContext BC)
	{
		String body = finishJob(BC.getJobID(), '');
		System.debug('***' + appName + ' Finished: ' + body);
	}

	// ------------------ METHOD to Implement the Schedulable Interface--------------------------------------
    global void execute(SchedulableContext SC)
    {               
        CronTrigger ct = [SELECT Id, CronExpression, TimesTriggered, NextFireTime FROM CronTrigger WHERE id = :SC.getTriggerId()];
        System.Debug('*** ' + appName + ' started. jobID: ' + String.valueOf(ct.Id));               
        ViaSatLogJob b = new ViaSatLogJob();        
        database.executebatch(b);
        System.debug('*** ' + appName + ' ended. jobID: ' + String.valueOf(ct.Id));   
    }

	// ------------------ METHOD to SCHEDULE JOB FROM the Developer Console --------------------------------------
    public static void start()
    {
        //System.schedule('Daily ViaSatLogJob to delete old Log records','0 0 10 * * ?', new ViaSatLogJob());
        System.schedule('Daily ViaSatLogJob to delete old Log records','0 0 1 * * ?', new ViaSatLogJob()); //at 1am every day
	}

	// ------------------ PRIVATE METHODS --------------------------------------	
@TestVisible	
	private static string executeBatch(List<Sobject> scope)
	{
        String output = '';         
        try
        {
			list<ViasatLog__c> deletedRecords = (list<ViasatLog__c>)scope;
            if (deletedRecords.size() > 0) 
            	delete deletedRecords;         
            output = 'Deleted ' + deletedRecords.size() + ' ViasatLog__c objects';
        }
        catch (System.Exception e)
        {
            output += ' ERROR: ' + e.getMessage();
            sendBatchResultEmail('Failed APEX Job Process', output);
        }		
		System.debug('*** ' + appName + ' executeBatch: ' + output);   
        return output;
	}
	
	// When the job is finished send out a notification to the appropriate email addresses
@TestVisible	
	private static String finishJob(Id jobID, String result)
	{
		AsyncApexJob[] aJobs = [Select Id, Status, NumberOfErrors, JobItemsProcessed, TotalJobItems, CreatedBy.Email 
		                        from AsyncApexJob where Id = :jobID];
		String subject = ' Completed ' + appName + ': ' + String.valueOf(jobID);
		String body = '';
		for (AsyncApexJob aj : aJobs)
		{
			body = body + ' Total Job Batch Items: ' + String.valueOf(aj.TotalJobItems);
			body = body + ' Total Failures: ' + String.valueOf(aj.NumberOfErrors);
			body = body + ' Job Items Processed: ' + String.valueOf(aj.JobItemsProcessed);
		}
		sendBatchResultEmail(subject, ' Summary: ' + result + '<p>' + body);		
		return body; 
	}
@TestVisible	
	private static void sendBatchResultEmail(String subject, String body)
	{
		Globals__c gs = Globals__c.getInstance();
		string email = gs.InternalNotificationEmail__c;

        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        mail.setToAddresses(new String[] {email});     
        mail.setReplyTo('noreply@viasat.com');
        mail.setSenderDisplayName('Batch Processing');
        mail.setSubject(subject);
        mail.setBccSender(false);
        mail.setUseSignature(false);           
        mail.setSaveAsActivity(false);
        mail.setHTMLBody(body);    
		ViasatUtilityClass.sendEmails(new List<Messaging.SingleEmailMessage>{mail}, appName);              
    }
}