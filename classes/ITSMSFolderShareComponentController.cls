/**************************************************************************************************************
Name         : ITSMSFolderShareComponentController 
Created By   : Dianna Guilinger - Slalom 
Description  : Controller for VF Component ITSMSFolderShare
             : Obtains passed parameters, manages page action
***************************************************************************************************************/
public class ITSMSFolderShareComponentController extends ITSMSComponentControllerBase {

    // format case record for Access: Folder/Share
    public override void formatCaseRec (){
        componentToPage.caseRec = caseRec;
        componentToPage.caseRec.Category__c = ITSMSConstants.FOLDERSHARE_CATEGORY;
        componentToPage.caseRec.CategoryDetails__c = ITSMSConstants.FOLDERSHARE_CATEGORYDETAILS;
        componentToPage.caseRec.ServiceDeskProduct__c = ITSMSConstants.FOLDERSHARE_PRODUCT;
        componentToPage.caseRec.ServiceRequestType__c = ITSMSConstants.FOLDERSHARE_SRVREQTYPE;
        
        string accessState = ViasatUtilityClass.replaceNullForString(componentToPage.caseRec.AccessState__c, 'not entered');
        string accessType = ViasatUtilityClass.replaceNullForString(componentToPage.caseRec.AccessType__c, 'not entered');
        string networkDir = ViasatUtilityClass.replaceNullForString(componentToPage.caseRec.ListNetworkDirectory__c, 'not entered');
        string justification = ViasatUtilityClass.replaceNullForString(componentToPage.caseRec.JustificationRequest__c, 'not entered');
        string usersAccess = '';
        if (ITSMSConstants.ACCESSTYPE_NEW.contains('#'+accessState+'#') )
            usersAccess = ITSMSUtilityClass.formatUserAccess(ITSMSConstants.PERMISSIONS_RECTYPE_FOLDERSHARE_NEW, componentToPage.caseRec);
        else
            usersAccess = ITSMSUtilityClass.formatUserAccess(ITSMSConstants.PERMISSIONS_RECTYPE_FOLDERSHARE_EXISTING, componentToPage.caseRec);
        string[] folderShareSubjArgs = new string [] { componentToPage.caseRec.ServiceRequestType__c, networkDir};
        componentToPage.caseRec.Subject = string.format(ITSMSConstants.FOLDERSHARE_SUBJECT, folderShareSubjArgs);
        string[] folderShareArgs = new string [] { accessState, accessType, networkDir, usersAccess, justification  };
        componentToPage.caseRec.DescriptionRichText__c = string.format(ITSMSConstants.FOLDERSHARE_DESCRIPTION, folderShareArgs);             
    }
}