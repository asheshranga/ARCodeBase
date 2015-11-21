/**************************************************************************************************************
Name         : ITSMSMobilityTransferCompController 
Created By   : Dianna Guilinger - Slalom 
Description  : Controller for VF Component ITSMSMobilityTransfer
             : Obtains passed parameters, manages page action
***************************************************************************************************************/
public class ITSMSMobilityTransferCompController  extends ITSMSComponentControllerBase {

    // format case record for Mobility: Transfer
    public override void formatCaseRec (){
        User requestUser = ITSMSUtilityClass.getRequestor(caseRec);
        componentToPage.caseRec = caseRec;
        componentToPage.caseRec.Category__c = ITSMSConstants.MOBILITYTRANSFER_CATEGORY;
        componentToPage.caseRec.CategoryDetails__c = ITSMSConstants.MOBILITYTRANSFER_CATEGORYDETAILS;
        componentToPage.caseRec.ServiceDeskProduct__c = ITSMSConstants.MOBILITYTRANSFER_PRODUCT;
        componentToPage.caseRec.ServiceRequestType__c = ITSMSConstants.MOBILITYTRANSFER_SRVREQTYPE;
        string phoneNum = ViasatUtilityClass.replaceNullForString(componentToPage.caseRec.ExistingMobilePhoneNumber__c, 'not entered');
        string carrier = ViasatUtilityClass.replaceNullForString(componentToPage.caseRec.CurrentCarrier__c, 'not entered');
        string phoneModel = ViasatUtilityClass.replaceNullForString(componentToPage.caseRec.CurrentPhoneModel__c, 'not entered');
        string contractDate = ViasatUtilityClass.replaceNullForDate(componentToPage.caseRec.ContractEndDate__c, 'not entered');
        string newCarrier = ViasatUtilityClass.replaceNullForString(componentToPage.caseRec.NewCarrierPhoneModel__c, 'not entered');
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
        string[] mobileArgs = new string [] {  phoneNum, carrier, phoneModel, contractDate, newCarrier, color, accessories, deptVP, CostCenter, justification  };
        componentToPage.caseRec.DescriptionRichText__c = string.format(ITSMSConstants.MOBILITYTRANSFER_DESCRIPTION, mobileArgs);             
        string[] mobileSubjArgs = new string [] { componentToPage.caseRec.SupportRequestType__c, requestUser.FirstName, requestUser.LastName};
        componentToPage.caseRec.Subject = string.format(ITSMSConstants.MOBILITYTRANSFER_SUBJECT,mobileSubjArgs);
    }
}