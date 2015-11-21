/**************************************************************************************************************
Name         : ITSMSSoftwareFishEyeCompController 
Created By   : Dianna Guilinger - Slalom 
Description  : Controller for VF Component ITSMSSoftwareFisheye
             : Obtains passed parameters, manages page action
***************************************************************************************************************/
public class ITSMSSoftwareFishEyeCompController  extends ITSMSComponentControllerBase {
    
    // format case record for Software: FishEye
    public override void formatCaseRec (){
        componentToPage.caseRec = caseRec;
        componentToPage.caseRec.Category__c = ITSMSConstants.SOFTWARE_FISHEYE_CATEGORY;
        componentToPage.caseRec.CategoryDetails__c = ITSMSConstants.SOFTWARE_FISHEYE_CATEGORYDETAILS;
        componentToPage.caseRec.ServiceDeskProduct__c = ITSMSConstants.SOFTWARE_FISHEYE_PRODUCT;
        componentToPage.caseRec.ServiceRequestType__c = ITSMSConstants.SOFTWARE_FISHEYE_SERVICEREQUESTTYPE;
        string repoAccount = ViasatUtilityClass.replaceNullForString(componentToPage.caseRec.RepoAccountName__c, 'not entered');
        string sourcecodePath = ViasatUtilityClass.replaceNullForString(componentToPage.caseRec.SourceCodePath__c, 'not entered');
        string defaultReviewers = ViasatUtilityClass.replaceNullForString(componentToPage.caseRec.DefaultReviewers__c, 'not entered');
        string reviewPart = ViasatUtilityClass.replaceNullForString(componentToPage.caseRec.ReviewParticipants__c, 'not entered');
        string moderator = ' ';
        if (componentToPage.caseRec.ManagerUser__c!= null)
        {
            list<User> u = new list<User> ([Select Id, FirstName, LastName from User
                                              where Id = :componentToPage.caseRec.ManagerUser__c limit 1]);
            if (u.size() == 1)
                 moderator = u[0].FirstName+' '+u[0].LastName;
        } 
        string[] softwareArgs = new string [] { repoAccount, sourcecodePath, moderator, defaultReviewers, reviewPart };
        componentToPage.caseRec.DescriptionRichText__c = string.format(ITSMSConstants.SOFTWARE_FISHEYE_DESCRIPTION, softwareArgs);             
        componentToPage.caseRec.Subject = ITSMSConstants.SOFTWARE_FISHEYE_SUBJECT;
    }
}