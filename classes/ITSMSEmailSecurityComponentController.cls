/**************************************************************************************************************
Name         : ITSMSEmailSecurityComponentController 
Created By   : Dianna Guilinger - Slalom 
Description  : Controller for VF Component ITSMSEmailSecurity
             : Obtains passed parameters, manages page action
***************************************************************************************************************/
public class ITSMSEmailSecurityComponentController extends ITSMSComponentControllerBase {


    // format case record for Access: Email/Security
    public override void formatCaseRec (){
        componentToPage.caseRec = caseRec;
        componentToPage.caseRec.Category__c = ITSMSConstants.EMAILSEC_CATEGORY;
        if (componentToPage.caseRec.AccessType__c == ITSMSConstants.EMAILSEC_ACCESS_SECURITY)
        {
            componentToPage.caseRec.CategoryDetails__c = ITSMSConstants.EMAILSEC_CATEGORYDETAILS_SECURE;
            componentToPage.caseRec.ServiceDeskProduct__c = ITSMSConstants.EMAILSEC_PRODUCT_SECURE;
        } else
        {
            componentToPage.caseRec.CategoryDetails__c = ITSMSConstants.EMAILSEC_CATEGORYDETAILS_DISTRIB;
            componentToPage.caseRec.ServiceDeskProduct__c = ITSMSConstants.EMAILSEC_PRODUCT_DISTRIB;
        }
        
        componentToPage.caseRec.ServiceRequestType__c = ITSMSConstants.EMAILSEC_SRVREQTYPE;
        string accessType = ViasatUtilityClass.replaceNullForString(componentToPage.caseRec.AccessType__c, 'not entered');
        string groupName = ViasatUtilityClass.replaceNullForString(componentToPage.caseRec.GroupName__c, 'not entered');
        string emailAddr = ViasatUtilityClass.replaceNullForString(componentToPage.caseRec.EmailAddress__c, 'not entered');
        string availOutside = ViasatUtilityClass.replaceNullForString(componentToPage.caseRec.AvailableToOutsideUsers__c, 'not entered');
        string justification = ViasatUtilityClass.replaceNullForString(componentToPage.caseRec.JustificationRequest__c, 'not entered');
        string usersAccess = '';
        if (ITSMSConstants.ACCESSTYPE_NEW.contains('#'+componentToPage.caseRec.AccessState__c+'#'))
        {
            usersAccess = ITSMSUtilityClass.formatUserAccess(ITSMSConstants.PERMISSIONS_RECTYPE_EMAILSECURITY_NEW, componentToPage.caseRec);
            string[] emailArgs = new string [] { componentToPage.caseRec.AccessState__c, accessType, groupName, emailAddr, availOutside, usersAccess, justification };
            componentToPage.caseRec.DescriptionRichText__c = string.format(ITSMSConstants.EMAILSEC_DESCRIPTION_NEW, emailArgs);             
        } else
        {
            usersAccess = ITSMSUtilityClass.formatUserAccess(ITSMSConstants.PERMISSIONS_RECTYPE_EMAILSECURITY_EXISTING, componentToPage.caseRec);
            string[] emailArgs = new string [] { componentToPage.caseRec.AccessState__c, accessType, groupName, emailAddr, availOutside, usersAccess, justification };
            componentToPage.caseRec.DescriptionRichText__c = string.format(ITSMSConstants.EMAILSEC_DESCRIPTION_EXISTING, emailArgs);             
        }
        string[] emailSubjArgs = new string [] { accessType, componentToPage.caseRec.AccessState__c };
        componentToPage.caseRec.Subject = string.format(ITSMSConstants.EMAILSEC_SUBJECT, emailSubjArgs);    
    }

}