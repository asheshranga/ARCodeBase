/**************************************************************************************************************
Name         : ITSMSMobilityLoanComponentController 
Created By   : Dianna Guilinger - Slalom 
Description  : Controller for VF Component ITSMSMobilityLoan
             : Obtains passed parameters, manages page action
***************************************************************************************************************/
public class ITSMSMobilityLoanComponentController  extends ITSMSComponentControllerBase {

    // format case record for Mobility: Loan
    public override void formatCaseRec (){
        User requestUser = ITSMSUtilityClass.getRequestor(caseRec);
        componentToPage.caseRec = caseRec;
        componentToPage.caseRec.Category__c = ITSMSConstants.MOBILITYLOAN_CATEGORY;
        componentToPage.caseRec.CategoryDetails__c = ITSMSConstants.MOBILITYLOAN_CATEGORYDETAILS;
        componentToPage.caseRec.ServiceDeskProduct__c = ITSMSConstants.MOBILITYLOAN_PRODUCT;
        componentToPage.caseRec.ServiceRequestType__c = ITSMSConstants.MOBILITYLOAN_SRVREQTYPE;
        string mobileType = ViasatUtilityClass.replaceNullForString(componentToPage.caseRec.MobileType__c, 'not entered');
        string phoneNum = ViasatUtilityClass.replaceNullForString(componentToPage.caseRec.ExistingMobilePhoneNumber__c, 'not entered');
        string departDate = ViasatUtilityClass.replaceNullForDate(componentToPage.caseRec.DepartureDate__c, 'not entered');
        string returnDate = ViasatUtilityClass.replaceNullForDate(componentToPage.caseRec.ReturnDate__c, 'not entered');
        string destinations = ViasatUtilityClass.replaceNullForString(componentToPage.caseRec.Destinations__c, 'not entered');
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
        string[] mobileArgs = new string [] {  mobileType, phoneNum, departDate, returnDate, destinations,deptVP, CostCenter, justification };
        componentToPage.caseRec.DescriptionRichText__c = string.format(ITSMSConstants.MOBILITYLOAN_DESCRIPTION, mobileArgs);             
        string[] mobileSubjArgs = new string [] { componentToPage.caseRec.SupportRequestType__c, requestUser.FirstName, requestUser.LastName};
        componentToPage.caseRec.Subject = string.format(ITSMSConstants.MOBILITYLOAN_SUBJECT,mobileSubjArgs);
    }
 
}