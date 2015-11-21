/*****************************************************************
Name          : ViasatLogHandler
Created By    : Marina Basovich
Company Name  : ViaSat
Purpose       : Methods to support ViasatLog__c sObject
Created Date  : November, 2014
Modified Date : 

NOTE:   - Do not use it in a Constructor - DML is not allowed in a constructor.
        - Use future/Async call only in Triggers
        - DML is not allowed before CALLOUT
******************************************************************
*/
public with sharing class ViasatLogHandler 
{
    public static final String SeverityTypeDebug = 'Debug';
    public static final String SeverityTypeINFO = 'Info';
    public static final String SeverityTypeServiceINFO = 'Service';
    public static final String SeverityTypeMINOR = 'Minor';
    public static final String SeverityTypeMAJOR = 'Major';
    public static final String SeverityTypeCRITICAL = 'Critical';
    public static final String SeverityTypeEXCEPTION = 'Exception';
    public static final String SeverityTypeSECURITY = 'Security';	// Log SECURITY ISSUES

    // ID that groups messages for the same execution process, should be set in the begining of the execution process
    public static string logExecutionProcessId = null;
    //public static Map<String,LogKeyValueStore__c> logKeyValue= LogKeyValueStore__c.getAll(); 
    
    // -----------------------------------------------------------------------------------------------
    public static void Log(string project, string logType, string message, string details, string stackTrace, string processId, string userId, string httpCode, string status)
    {
        //if ((logKeyValue.get('EnableLogging').Value__c == 'false' && logKeyValue.get('EnableLogging').Code__c == project) ||
        //    (logKeyValue.get('EnableDebugLogging').Value == 'false' && logKeyValue.get('EnableDebugLogging').Code__c == project))
        //    return;
            
        try
        {
        // Validate data
        string sProject=(string.isEmpty(project) ? 'UNKNOWN' : project);
        string sType=(string.isEmpty(logType) ? 'UNKNOWN' : logType);
        string sMessage=message;
        if (sMessage != null && sMessage.length() > 255)    sMessage = sMessage.substring(0,254);

        string sDetails=details;
        string sUserId=(string.isEmpty(userId) ? UserInfo.getUserId() : userId);
        string sStackTrace = stackTrace;

        string sProcessId = (processId == null ? logExecutionProcessId : processId);
        if (sProcessId == null) sProcessId = UserInfo.getSessionId();
        if (sProcessId != null && sProcessId.length() > 50) sProcessId = sProcessId.substring(0,49);

        if (Test.isRunningTest())
            sProject = 'Test' + sProject;
        ViasatLog__c log = new ViasatLog__c(Project__c=sProject, Type__c=sType, Message__c=sMessage, Details__c=sDetails, ProcessID__c=sProcessId, UserID__c=sUserId, StackTrace__c=sStackTrace, StatusCode__c=httpCode, Status__c=status);
        insert log;
        }
        catch(Exception e){}
    }

    public static void Log(string project, string logType, string message, string details, string stackTrace, string processId, string userId, string httpCode){
        Log(project, logType, message, details, stackTrace, processId, userId, httpCode, null);
    }

    public static void Log(string project, string logType, string message, string details, string stackTrace, string processId){
        Log(project, logType, message, details, stackTrace, processId, null, null, null);
    }

    public static void Log(string project, string logType, string message, string details, string stackTrace){
        Log(project, logType, message, details, stackTrace, null, null, null, null);
    }
    
    public static void Log(string project, string logType, string message, string details){
        Log(project, logType, message, details, null, null, null, null, null);
    }
    
    // -----------------------------------------------------------------------------------------------
    // KEEP IN MIND THAT ONLY 10 FUTURE CALLS ALLOWED PER EXEC CALL & 200 PER HOUR PER 1 LICENCE
    // -----------------------------------------------------------------------------------------------
    public static void LogAsync(string project, string logType, string message){
        futureLog(project, logType, message, null, null, null, null, null, null);   
    }
    
    public static void LogAsync(string project, string logType, string message, string details){
        futureLog(project, logType, message, details, null, null, null, null, null);
    }

    public static void LogAsync(string project, string logType, string message, string details, string stackTrace){
        futureLog(project, logType, message, details, stackTrace, null, null, null, null);
    }

    public static void LogAsync(string project, string logType, string message, string details, string stackTrace, string processId){
        futureLog(project, logType, message, details, stackTrace, processId, null, null, null);
    }

    public static void LogAsync(string project, string logType, string message, string details, string stackTrace, string processId, string userId){
        futureLog(project, logType, message, details, stackTrace, processId, userId, null, null);
    }
    
    public static void LogAsync(string project, string logType, string message, string details, string stackTrace, string processId, string userId, string httpCode){
        futureLog(project, logType, message, details, stackTrace, processId, userId, httpCode, null);
    }

    @future
    public static void futureLog(string project, string logType, string message, string details, string stackTrace, string processId, string userId, string httpCode, string status)
    {
        Log(project, logType, message, details, stackTrace, processId, userId, httpCode, status);
    }  
                   
    // -----------------------------------------------------------------------------------------------
    // Generate Nounce, random number base64 encoded
    public static String generateNounce()
    {
        Long randomLong = Crypto.getRandomLong();
        return EncodingUtil.base64Encode(Blob.valueOf(String.valueOf(randomLong)));
    }
    
/*    // -----------------------------------------------------------------------------------------------
    public static void TestLoggingException() 
    {            
        Account a = new Account();
        try 
        {               
            a.Id = 'want it to fail';    
            ViasatLogHandler.LogAsync('Test', ViasatLogHandler.SeverityTypeINFO, 'TESTING', String.valueOf(a));
                         
        }
        catch (Exception e) 
        {               
            ViasatLogHandler.Log('Test', ViasatLogHandler.SeverityTypeCRITICAL, e.getMessage()
                                       , String.valueOf(a)
                                       , e.getStackTraceString()
                                       ,'TestLoggingException() threw ' + e.getTypeName() + ' on line ' + e.getLineNumber()
                                       , UserInfo.getUserId()
                                       , '500');
        }
    }  */             
}