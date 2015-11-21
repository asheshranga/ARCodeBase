/**************************************************************************************************************
Name         : ITSMSMobilityAgreementCompController 
Created By   : Dianna Guilinger - Slalom 
Description  : Controller for VF Component ITSMSMobilityAgreement
: Obtains passed parameters, manages page action
***************************************************************************************************************/
public class ITSMSMobilityAgreementCompController  extends ITSMSComponentControllerBase {

    // format case record for Mobility: Agreement
    public override void formatCaseRec (){
        User requestUser = ITSMSUtilityClass.getRequestor(caseRec);
        componentToPage.caseRec = caseRec;
        componentToPage.caseRec.Category__c = ITSMSConstants.MOBILITYAGREE_CATEGORY;
        componentToPage.caseRec.CategoryDetails__c = ITSMSConstants.MOBILITYAGREE_CATEGORYDETAILS;
        componentToPage.caseRec.ServiceDeskProduct__c = ITSMSConstants.MOBILITYAGREE_PRODUCT;
        componentToPage.caseRec.ServiceRequestType__c = ITSMSConstants.MOBILITYAGREE_SRVREQTYPE;
        string deviceModel = ViasatUtilityClass.replaceNullForString(componentToPage.caseRec.DeviceModel__c, 'not entered');
        string phoneNum = ViasatUtilityClass.replaceNullForString(componentToPage.caseRec.ExistingMobilePhoneNumber__c, 'not entered');
        string caseRef = ViasatUtilityClass.replaceNullForString(componentToPage.caseRec.ReferenceCaseId__c, 'not entered');
        string meidNum = ViasatUtilityClass.replaceNullForString(componentToPage.caseRec.MEID_IMEINumber__c, 'not entered');
        string iccidNum = ViasatUtilityClass.replaceNullForString(componentToPage.caseRec.ICCID_SIMNumber__c, 'not entered');
        string serialNum = ViasatUtilityClass.replaceNullForString(componentToPage.caseRec.SerialNumber__c, 'not entered');
        string whoOwns = ViasatUtilityClass.replaceNullForString(componentToPage.caseRec.WhoOwnsDevice__c, 'not entered');
        string accept = ViasatUtilityClass.replaceNullForBoolean(componentToPage.caseRec.AcceptMobileTerms__c, 'not entered');
        string costCenter = ViasatUtilityClass.replaceNullForString(componentToPage.caseRec.CostCenterNumber__c, 'not entered');
        string justification = ViasatUtilityClass.replaceNullForString(componentToPage.caseRec.JustificationRequest__c, 'not entered');
        string deptVP = ' ';
        if (componentToPage.caseRec.DeptVP__c!= null)
        {
            list<User> u = new list<User> ([Select Id, FirstName, LastName from User
                                              where Id = :componentToPage.caseRec.DeptVP__c limit 1]);
            if (u.size() == 1)
                 deptVP = u[0].FirstName+' '+u[0].LastName;
        }
        string[] mobileArgs = new string [] {  deviceModel, phoneNum, caseRef, meidNum, iccidNum, serialNum, whoOwns, accept, deptVP, CostCenter, justification };
        componentToPage.caseRec.DescriptionRichText__c = string.format(ITSMSConstants.MOBILITYAGREE_DESCRIPTION, mobileArgs);             
        string[] mobileSubjArgs = new string [] { componentToPage.caseRec.SupportRequestType__c, requestUser.FirstName, requestUser.LastName};
        componentToPage.caseRec.Subject = string.format(ITSMSConstants.MOBILITYAGREE_SUBJECT,mobileSubjArgs);
    }
}