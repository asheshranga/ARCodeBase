/**************************************************************************************************************
Name         : ITSMSServerComponentController 
Created By   : Dianna Guilinger - Slalom 
Description  : Controller for VF Component ITSMSServer
             : Obtains passed parameters, manages page action
***************************************************************************************************************/
public class ITSMSServerComponentController  extends ITSMSComponentControllerBase {

    // format case record for Server: 
    public override void formatCaseRec (){
        componentToPage.caseRec = caseRec;
        componentToPage.caseRec.Category__c = ITSMSConstants.SERVER_CATEGORY;
        componentToPage.caseRec.CategoryDetails__c = ITSMSConstants.SERVER_CATEGORYDETAIL;
        componentToPage.caseRec.ServiceRequestType__c = ITSMSConstants.SERVER_SERVICEREQUESTTYPE;
        string needBy = ViasatUtilityClass.replaceNullForDate(componentToPage.caseRec.Date_Needed_By__c, 'not entered');
        string project = ViasatUtilityClass.replaceNullForString(componentToPage.caseRec.ServerProject__c, 'not entered');
        string location = ViasatUtilityClass.replaceNullForString(componentToPage.caseRec.ServerLocation__c, 'not entered');
        string reqOrg = ViasatUtilityClass.replaceNullForString(componentToPage.caseRec.RequestingOrg__c, 'not entered');
        string approvDir = ViasatUtilityClass.replaceNullForString(componentToPage.caseRec.ApprovingDirector__c, 'not entered');
        string customerUse = ViasatUtilityClass.replaceNullForString(componentToPage.caseRec.CustomerUse__c, 'not entered');
        string equipClass = ViasatUtilityClass.replaceNullForString(componentToPage.caseRec.EquipmentClass__c, 'not entered');
        string operSystem = ViasatUtilityClass.replaceNullForString(componentToPage.caseRec.ServerOperatingSystem__c, 'not entered');
        string storageReqm = ViasatUtilityClass.replaceNullForString(componentToPage.caseRec.StorageRequirements__c, 'not entered');
        string cpu = ViasatUtilityClass.replaceNullForString(componentToPage.caseRec.ServerCPU__c, 'not entered');
        string memory = ViasatUtilityClass.replaceNullForString(componentToPage.caseRec.ServerMemory__c, 'not entered');
        string partNumber = ViasatUtilityClass.replaceNullForString(componentToPage.caseRec.PartNumber__c, 'not entered');
        string partQty = ViasatUtilityClass.replaceNullForString(componentToPage.caseRec.PartQuantity__c, 'not entered');
        string[] serverArgs = new string [] { needBy, componentToPage.caseRec.EquipmentLocation__c, componentToPage.caseRec.CostCenterNumber__c,
            componentToPage.caseRec.BriefDescription__c, componentToPage.caseRec.JustificationRequest__c,
            project, location, reqOrg, approvDir, customerUse, equipClass, operSystem, storageReqm, cpu, memory, partNumber, partQty};
        componentToPage.caseRec.DescriptionRichText__c = string.format(ITSMSConstants.SERVER_DESCRIPTION, serverArgs);             
        string[] serverSubjArgs = new string [] { componentToPage.caseRec.SupportRequestType__c, componentToPage.caseRec.BriefDescription__c};
        componentToPage.caseRec.Subject = string.format(ITSMSConstants.SERVER_SUBJECT,serverSubjArgs);
    }
}