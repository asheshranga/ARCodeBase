/**************************************************************************************************************
Name         : ITSMSIssueComponentController 
Created By   : Dianna Guilinger - Slalom 
Description  : Controller for VF Component ITSMSIssue
             : Obtains passed parameters, manages page action
***************************************************************************************************************/
public with sharing class ITSMSIssueComponentController extends ITSMSComponentControllerBase {

    // format case record for Issue
    public override void formatCaseRec (){
        componentToPage.caseRec.Description = caseRec.Description;
        componentToPage.caseRec.ScreenshotsAttached__c = caseRec.ScreenshotsAttached__c;
        componentToPage.caseRec.Type = ITSMSConstants.CASE_TYPE_ISSUE;
        string[] subjectArgs = new string [] { componentToPage.caseRec.SupportCategory__c};
        componentToPage.caseRec.Subject = string.format(ITSMSConstants.SUPPORT_SUBJECT_ISSUE, subjectArgs);
        componentToPage.caseRec.DescriptionRichText__c = componentToPage.caseRec.Description;
         //   Fetch the assignment rules on case
        AssignmentRule assignRule = new AssignmentRule();
        assignRule = [select id from AssignmentRule where SobjectType = 'Case' and Active = true limit 1];
        if (assignRule != null)
        {
            //  Create DMLOptions for "Assign using active assignment rules" checkbox
            Database.DMLOptions dmlOpts = new Database.DMLOptions();
            dmlOpts.assignmentRuleHeader.assignmentRuleId= assignRule.id;
            //   Set DMLOption on Case instance so that assignment rules are executed
            componentToPage.caseRec.setOptions(dmlOpts);
        }
    }

    // user wants to add attachments, will need to insert case now 
    public PageReference addingAttachment (){
        formatCaseRec();
        boolean isUpserted = ITSMSUtilityClass.upsertCase(componentToPage.caseRec);
        return null;
    }

    // submit 'this case' and prepare to create another 
    public PageReference submitAndNew (){
        formatCaseRec();
        boolean isUpserted = componentToPage.saveCase();
        if (isUpserted)
        {
            // prepare for adding another case to this request
            componentToPage.caseRec = ITSMSUtilityClass.setupNewCaseRec(componentToPage.caseRec);
            componentToPage.isNewCaseForRequest = true;
            PageReference pageRef= new PageReference(ITSMSConstants.NAVIGATE_SUPPORT_REQUEST);
            return pageRef;  
        } else
            return null;
    }
    
    // submit this case and navigate
    public PageReference submitOnly (){
        formatCaseRec();
        boolean isUpserted = componentToPage.saveCase();
        if (isUpserted)
        {
            PageReference pageRef = new PageReference(ITSMSConstants.NAVIGATE_ON_SUBMITSUPPORT); 
        	return PageRef;
        } else
            return null;
    }
}