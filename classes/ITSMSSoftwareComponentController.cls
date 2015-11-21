/**************************************************************************************************************
Name         : ITSMSSoftwareComponentController 
Created By   : Dianna Guilinger - Slalom 
Description  : Controller for VF Component ITSMSSoftware
             : Obtains passed parameters, manages page action
***************************************************************************************************************/
public class ITSMSSoftwareComponentController  extends ITSMSComponentControllerBase {

    // format case record for Software: Software Request
    public override void formatCaseRec (){
        User requestUser = ITSMSUtilityClass.getRequestor(caseRec);
        componentToPage.caseRec = caseRec;
        if (ITSMSConstants.SOFTWARE_NAME_GROUP1.contains('#'+componentToPage.caseRec.SoftwareName__c+'#'))
        {
            componentToPage.caseRec.Category__c = ITSMSConstants.SOFTWARE_GROUP1_CATEGORY;
            componentToPage.caseRec.CategoryDetails__c = ITSMSConstants.SOFTWARE_GROUP1_CATEGORYDETAIL;
            componentToPage.caseRec.ServiceDeskProduct__c = null;
        } else {
            componentToPage.caseRec.Category__c = null;
            componentToPage.caseRec.CategoryDetails__c = null;
            componentToPage.caseRec.ServiceDeskProduct__c = null;
        }
        
        componentToPage.caseRec.ServiceRequestType__c = ITSMSConstants.SOFTWARE_SERVICEREQUESTTYPE;
        string forGroup = ViasatUtilityClass.replaceNullForString(componentToPage.caseRec.IsThisForGroup__c, 'not entered');
        string computerNames = ViasatUtilityClass.replaceNullForString(componentToPage.caseRec.ComputerNames__c, 'not entered');
        string justification = ViasatUtilityClass.replaceNullForString(componentToPage.caseRec.JustificationRequest__c, 'not entered');
        string forUser = ' ';
        if (componentToPage.caseRec.ManagerUser__c!= null)
        {
            list<User> u = new list<User> ([Select Id, FirstName, LastName from User
                                              where Id = :componentToPage.caseRec.ManagerUser__c limit 1]);
            if (u.size() == 1)
                 forUser = u[0].FirstName+' '+u[0].LastName;
        } 
        string[] softwareArgs = new string [] { componentToPage.caseRec.SoftwareName__c, forUser, forGroup, computerNames,  justification};
        componentToPage.caseRec.DescriptionRichText__c = string.format(ITSMSConstants.SOFTWARE_DESCRIPTION, softwareArgs);             
        string[] softwareSubjArgs = new string [] { componentToPage.caseRec.SoftwareName__c };
        componentToPage.caseRec.Subject = string.format(ITSMSConstants.SOFTWARE_SUBJECT,softwareSubjArgs);
    } 
}