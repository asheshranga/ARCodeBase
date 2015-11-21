/**************************************************************************************************************
Name         : ITSMSFeedbackCaseComponentController 
Created By   : Dianna Guilinger - Slalom 
Description  : Controller for VF Component ITSMSFeedbackCase 
             : build feed back case
/**************************************************************************************************************
*/

public class ITSMSFeedbackCaseComponentController extends ITSMSComponentControllerBase {
 
    public String runningUserName {get;set;}
    public boolean caseSubmitted {get;set;}
    public Case newCase {get;set;}

    // controller 
    public ITSMSFeedbackCaseComponentController(){
        newCase = new Case();                        
        caseSubmitted = false;
        runningUserName = UserInfo.getName();
    } 
 
    // format and submit case for logged in user 
    public void submitFeedbackCase(){
        Id runningUserId = UserInfo.getUserId();
        User runningUser = [SELECT Id, Name, Email FROM User WHERE Id =: runningUserId];        
        newCase.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get(ITSMSConstants.CASE_RECORDTYPE_FEEDBACK).getRecordTypeId();           
        newCase.Requestor__c = runningUserId;         
        
        Contact runningUserContact = ITSMSUtilityClass.getRequestorContact(runningUser);
        if(runningUserContact != NULL)
            newCase.Contact = runningUserContact;
         
        string runningUserName = UserInfo.getName();
        string[] feedbackArgs = new string [] { runningUserName};
        newCase.Subject = string.format(ITSMSConstants.FEEDBACK_SUBJECT, feedbackArgs);  
        
        AssignmentRule assignRule = new AssignmentRule();
        assignRule = [select id from AssignmentRule where SobjectType = 'Case' and Active = true limit 1];
        if (assignRule != null)
        {
            //  Create DMLOptions for "Assign using active assignment rules" checkbox
            Database.DMLOptions dmlOpts = new Database.DMLOptions();
            dmlOpts.assignmentRuleHeader.assignmentRuleId= assignRule.id;
            //   Set DMLOption on Case instance so that assignment rules are executed
            newCase.setOptions(dmlOpts);
        }
                
        ITSMSUtilityClass.upsertCase(newCase);
        caseSubmitted = true;        
    }

}