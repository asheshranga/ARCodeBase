/**************************************************************************************************************
Name         : ITSMSSoftwareWIKICompController 
Created By   : Dianna Guilinger - Slalom 
Description  : Controller for VF Component ITSMSSoftwareWIKI
             : Obtains passed parameters, manages page action
***************************************************************************************************************/
public class ITSMSSoftwareWIKICompController  extends ITSMSComponentControllerBase {

    // format case record for Software: WIKI
    public override void formatCaseRec (){
        User requestUser = ITSMSUtilityClass.getRequestor(caseRec);
        componentToPage.caseRec = caseRec;
        componentToPage.caseRec.Category__c = ITSMSConstants.SOFTWARE_WIKI_CATEGORY;
        componentToPage.caseRec.CategoryDetails__c = ITSMSConstants.SOFTWARE_WIKI_CATEGORYDETAILS;
        componentToPage.caseRec.ServiceDeskProduct__c = ITSMSConstants.SOFTWARE_WIKI_PRODUCT;
        componentToPage.caseRec.ServiceRequestType__c = ITSMSConstants.SOFTWARE_WIKI_SERVICEREQUESTTYPE;
        string spaceName = ViasatUtilityClass.replaceNullForString(componentToPage.caseRec.WIKISpaceName__c, 'not entered');
        string spaceKey = ViasatUtilityClass.replaceNullForString(componentToPage.caseRec.WIKISpaceKey__c, 'not entered');
        string description = ViasatUtilityClass.replaceNullForString(componentToPage.caseRec.Description, 'not entered');
        string spaceType = ViasatUtilityClass.replaceNullForString(componentToPage.caseRec.WIKISpaceType__c, 'not entered');
        string team; // = ViasatUtilityClass.replaceNullForString(componentToPage.caseRec.WIKITeamMembers__c, 'not entered');
        string[] softwareArgs = new string [] { spaceName, spaceKey, description, spaceType, team};
        componentToPage.caseRec.DescriptionRichText__c = string.format(ITSMSConstants.SOFTWARE_WIKI_DESCRIPTION, softwareArgs);             
        componentToPage.caseRec.Subject = ITSMSConstants.SOFTWARE_WIKI_SUBJECT;
    }
}