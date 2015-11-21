/**************************************************************************************************************
Name         : ITSMSSharedMailboxComponentController 
Created By   : Dianna Guilinger - Slalom 
Description  : Controller for VF Component ITSMSSharedMailbox
             : Obtains passed parameters, manages page action
***************************************************************************************************************/
public class ITSMSSharedMailboxComponentController extends ITSMSComponentControllerBase {


    // format case record for Access: Shared Mailbox
    public override void formatCaseRec (){
        componentToPage.caseRec = caseRec;
        componentToPage.caseRec.Category__c = ITSMSConstants.SHAREDMBX_CATEGORY;
        componentToPage.caseRec.CategoryDetails__c = ITSMSConstants.SHAREDMBX_CATEGORYDETAIL;
        componentToPage.caseRec.ServiceDeskProduct__c = ITSMSConstants.SHAREDMBX_PRODUCT;
        componentToPage.caseRec.ServiceRequestType__c = ITSMSConstants.SHAREDMBX_SERVICEREQUESTTYPE;
        string sharedMail = ViasatUtilityClass.replaceNullForString(componentToPage.caseRec.SharedMailboxName__c, 'not entered');
        string emailAddr = ViasatUtilityClass.replaceNullForString(componentToPage.caseRec.EmailAddress__c, 'not entered');
        string availOutside = ViasatUtilityClass.replaceNullForString(componentToPage.caseRec.AvailableToOutsideUsers__c, 'not entered');
        string justification = ViasatUtilityClass.replaceNullForString(componentToPage.caseRec.JustificationRequest__c, 'not entered');
        string usersAccess = '';
        if (ITSMSConstants.ACCESSTYPE_NEW.contains('#'+componentToPage.caseRec.AccessState__c+'#'))
        {
            usersAccess = ITSMSUtilityClass.formatUserAccess(ITSMSConstants.PERMISSIONS_RECTYPE_SHAREDMAILBOX_NEW, componentToPage.caseRec);
        } else {
            usersAccess = ITSMSUtilityClass.formatUserAccess(ITSMSConstants.PERMISSIONS_RECTYPE_SHAREDMAILBOX_EXISTING, componentToPage.caseRec);
        }
        
        string[] sharedArgs = new string [] { componentToPage.caseRec.AccessState__c, sharedMail, emailAddr, usersAccess, availOutside, justification };
        componentToPage.caseRec.DescriptionRichText__c = string.format(ITSMSConstants.SHAREDMBX_DESCRIPTION, sharedArgs);             
        string[] sharedSubjArgs = new string [] { componentToPage.caseRec.ServiceRequestType__c, componentToPage.caseRec.AccessState__c};
        componentToPage.caseRec.Subject = string.format(ITSMSConstants.SHAREDMBX_SUBJECT, sharedSubjArgs); 
    
    }
}