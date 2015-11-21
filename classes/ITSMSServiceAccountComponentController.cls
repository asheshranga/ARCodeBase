/**************************************************************************************************************
Name         : ITSMSServiceAccountComponentController 
Created By   : Dianna Guilinger - Slalom 
Description  : Controller for VF Component ITSMSServiceAccount
             : Obtains passed parameters, manages page action
***************************************************************************************************************/
public class ITSMSServiceAccountComponentController  extends ITSMSComponentControllerBase {


    // format case record for Access: Service Account
    public override void formatCaseRec (){
        componentToPage.caseRec = caseRec;
        componentToPage.caseRec.Category__c = ITSMSConstants.SERVACCT_CATEGORY;
        componentToPage.caseRec.CategoryDetails__c = ITSMSConstants.SERVACCT_CATEGORYDETAIL;
        componentToPage.caseRec.ServiceDeskProduct__c = ITSMSConstants.SERVACCT_PRODUCT;
        componentToPage.caseRec.ServiceRequestType__c = ITSMSConstants.SERVACCT_SERVICEREQUESTTYPE;
        string accountType = ViasatUtilityClass.replaceNullForString(componentToPage.caseRec.AccountType__c, 'not entered');
        string expireDate = ViasatUtilityClass.replaceNullForDate(componentToPage.caseRec.ExpirationDate__c, 'not entered');
        string servAcctName = ViasatUtilityClass.replaceNullForString(componentToPage.caseRec.ServiceAccountName__c, 'not entered');
        string mailboxNeeded = ViasatUtilityClass.replaceNullForString(componentToPage.caseRec.MailboxNeeded__c, 'not entered');
        string usedFor = ViasatUtilityClass.replaceNullForString(componentToPage.caseRec.UsedFor__c, 'not entered');
        string environments = ViasatUtilityClass.replaceNullForString(componentToPage.caseRec.Environments__c, 'not entered');
        string justification = ViasatUtilityClass.replaceNullForString(componentToPage.caseRec.JustificationRequest__c, 'not entered');
        string userAccess = '';
        if (ITSMSConstants.ACCESSTYPE_NEW.contains('#'+componentToPage.caseRec.AccessState__c+'#'))
        {
            userAccess = ITSMSUtilityClass.formatUserAccess(ITSMSConstants.PERMISSIONS_RECTYPE_SERVICEACCT_NEW, componentToPage.caseRec);
            string[] servAcctArgs = new string [] { componentToPage.caseRec.AccessState__c, servAcctName, accountType, expireDate, mailboxNeeded,
                usedFor, environments,  userAccess, justification };
            componentToPage.caseRec.DescriptionRichText__c = string.format(ITSMSConstants.SERVACCT_DESCRIPTION_NEW, servAcctArgs);             
        } else
        {
            userAccess = ITSMSUtilityClass.formatUserAccess(ITSMSConstants.PERMISSIONS_RECTYPE_SERVICEACCT_EXISTING, componentToPage.caseRec);
            string[] servAcctArgs = new string [] { componentToPage.caseRec.AccessState__c, servAcctName, accountType, expireDate, userAccess, justification  };
            componentToPage.caseRec.DescriptionRichText__c = string.format(ITSMSConstants.SERVACCT_DESCRIPTION_EXIST, servAcctArgs);             
        }
        string[] servAcctSubjArgs = new string [] { componentToPage.caseRec.ServiceRequestType__c, componentToPage.caseRec.AccessState__c};
        componentToPage.caseRec.Subject = string.format(ITSMSConstants.SERVACCT_SUBJECT,servAcctSubjArgs);
    }
}