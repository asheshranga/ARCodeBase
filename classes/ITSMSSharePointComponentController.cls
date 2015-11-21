/**************************************************************************************************************
Name         : ITSMSSharePointComponentController 
Created By   : Dianna Guilinger - Slalom 
Description  : Controller for VF Component ITSMSSharePoint
             : Obtains passed parameters, manages page action
***************************************************************************************************************/
public class ITSMSSharePointComponentController  extends ITSMSComponentControllerBase {

    // format case record for Access: Sharepoint
    public override void formatCaseRec (){
        componentToPage.caseRec = caseRec;
        componentToPage.caseRec.Category__c = ITSMSConstants.SHAREPOINT_CATEGORY;
        componentToPage.caseRec.CategoryDetails__c = ITSMSConstants.SHAREPOINT_CATEGORYDETAIL;
        componentToPage.caseRec.ServiceRequestType__c = ITSMSConstants.SHAREPOINT_SERVICEREQUESTTYPE;
        string actionType = ViasatUtilityClass.replaceNullForString(componentToPage.caseRec.ActionTypeSharePoint__c, 'not entered');
        string firstName = ViasatUtilityClass.replaceNullForString(componentToPage.caseRec.FirstName__c, 'not entered');
        string lastName = ViasatUtilityClass.replaceNullForString(componentToPage.caseRec.LastName__c, 'not entered');
        string companyEmail = ViasatUtilityClass.replaceNullForString(componentToPage.caseRec.CompanyEmail__c, 'not entered');
        string linkShare = ViasatUtilityClass.replaceNullForString(componentToPage.caseRec.LinkToSharePointSite__c, 'not entered');
        string progrName = ViasatUtilityClass.replaceNullForString(componentToPage.caseRec.ProgramProjectName__c, 'not entered');
        string justification = ViasatUtilityClass.replaceNullForString(componentToPage.caseRec.JustificationRequest__c, 'not entered');
        if (actionType == ITSMSConstants.ACTION_CREATE)
        {
            componentToPage.caseRec.ServiceDeskProduct__c = ITSMSConstants.SHAREPOINT_PRODUCTCREATE;
        } else {
            if (actionType == ITSMSConstants.ACTION_DISABLE)
            {
                componentToPage.caseRec.ServiceDeskProduct__c = ITSMSConstants.SHAREPOINT_PRODUCTDISABLE;
            } else {
            if (actionType == ITSMSConstants.ACTION_MODIFY)                
                componentToPage.caseRec.ServiceDeskProduct__c = ITSMSConstants.SHAREPOINT_PRODUCTMODIFY;
            }
        }
        string[] sharePointArgs = new string [] { actionType, firstName, lastName, companyEmail, linkShare, progrName, justification };
        componentToPage.caseRec.DescriptionRichText__c = string.format(ITSMSConstants.SHAREPOINT_DESCRIPTION, sharePointArgs);             
        string[] sharePointSubjArgs = new string [] { componentToPage.caseRec.ServiceRequestType__c, actionType, firstName, lastName };
        componentToPage.caseRec.Subject = string.format(ITSMSConstants.SHAREPOINT_SUBJECT, sharePointSubjArgs);             
    }
}