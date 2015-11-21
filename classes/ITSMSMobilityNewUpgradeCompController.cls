/**************************************************************************************************************
Name         : ITSMSMobilityNewUpgradeCompController 
Created By   : Dianna Guilinger - Slalom 
Description  : Controller for VF Component ITSMSMobilityNewUpgrade
             : Obtains passed parameters, manages page action
***************************************************************************************************************/
public class ITSMSMobilityNewUpgradeCompController  extends ITSMSComponentControllerBase {

    // format case record for Mobility: New/Upgrade
    public override void formatCaseRec (){
        User requestUser = ITSMSUtilityClass.getRequestor(caseRec);
        componentToPage.caseRec = caseRec;
        componentToPage.caseRec.Category__c = ITSMSConstants.MOBILITYNEW_CATEGORY;
        componentToPage.caseRec.CategoryDetails__c = ITSMSConstants.MOBILITYNEW_CATEGORYDETAILS;
        componentToPage.caseRec.ServiceDeskProduct__c = ITSMSConstants.MOBILITYNEW_PRODUCT;
        componentToPage.caseRec.ServiceRequestType__c = ITSMSConstants.MOBILITYNEW_SRVREQTYPE;
        string actionType = ViasatUtilityClass.replaceNullForString(componentToPage.caseRec.MobileActionType__c, 'not entered');
        string phoneNum = ViasatUtilityClass.replaceNullForString(componentToPage.caseRec.ExistingMobilePhoneNumber__c, 'not entered');
        string carrier = ViasatUtilityClass.replaceNullForString(componentToPage.caseRec.SelectCarrierModel__c, 'not entered');
        string color = ViasatUtilityClass.replaceNullForString(componentToPage.caseRec.Color__c, 'not entered');
        string accessories = ViasatUtilityClass.replaceNullForString(componentToPage.caseRec.Accessories__c, 'not entered');
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
        string[] mobileArgs = new string [] {  actionType, phoneNum, carrier, color, accessories, deptVP, CostCenter, justification };
        componentToPage.caseRec.DescriptionRichText__c = string.format(ITSMSConstants.MOBILITYNEW_DESCRIPTION, mobileArgs);             
        string[] mobileSubjArgs = new string [] { componentToPage.caseRec.SupportRequestType__c, requestUser.FirstName, requestUser.LastName};
        componentToPage.caseRec.Subject = string.format(ITSMSConstants.MOBILITYNEW_SUBJECT,mobileSubjArgs);
    }
}