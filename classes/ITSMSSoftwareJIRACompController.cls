/**************************************************************************************************************
Name         : ITSMSSoftwareJIRACompController 
Created By   : Dianna Guilinger - Slalom 
Description  : Controller for VF Component ITSMSSoftwareJIRA
             : Obtains passed parameters, manages page action
***************************************************************************************************************/
public class ITSMSSoftwareJIRACompController  extends ITSMSComponentControllerBase {

    // format case record for Software: JIRA
    public override void formatCaseRec (){
        componentToPage.caseRec = caseRec;
        componentToPage.caseRec.Category__c = ITSMSConstants.SOFTWARE_JIRA_CATEGORY;
        componentToPage.caseRec.CategoryDetails__c = ITSMSConstants.SOFTWARE_JIRA_CATEGORYDETAILS;
        componentToPage.caseRec.ServiceDeskProduct__c = ITSMSConstants.SOFTWARE_JIRA_PRODUCT;
        componentToPage.caseRec.ServiceRequestType__c = ITSMSConstants.SOFTWARE_JIRA_SERVICEREQUESTTYPE;
        string projectName = ViasatUtilityClass.replaceNullForString(componentToPage.caseRec.ProgramProjectName__c, 'not entered');
        string projectKey = ViasatUtilityClass.replaceNullForString(componentToPage.caseRec.ProjectKey__c, 'not entered');
        string workflow = ViasatUtilityClass.replaceNullForString(componentToPage.caseRec.DesiredWorkflow__c, 'not entered');
        string wikiReqd = ViasatUtilityClass.replaceNullForString(componentToPage.caseRec.WIKIRequired__c, 'not entered');
        string projectLead = ' ';
        if (componentToPage.caseRec.ManagerUser__c!= null)
        {
            list<User> u = new list<User> ([Select Id, FirstName, LastName from User
                                              where Id = :componentToPage.caseRec.ManagerUser__c limit 1]);
            if (u.size() == 1)
                 projectLead = u[0].FirstName+' '+u[0].LastName;
        }  
        string[] servAcctArgs = new string [] { projectName, projectKey, projectLead, workflow, wikiReqd };
        componentToPage.caseRec.DescriptionRichText__c = string.format(ITSMSConstants.SOFTWARE_JIRA_DESCRIPTION, servAcctArgs);             
        componentToPage.caseRec.Subject = ITSMSConstants.SOFTWARE_JIRA_SUBJECT;
    }
     
}