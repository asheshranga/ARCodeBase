/**************************************************************************************************************
Name         : ITSMSWorkstationCompController 
Created By   : Dianna Guilinger - Slalom 
Description  : Controller for VF Component ITSMSWorkstation
             : Obtains passed parameters, manages page action
***************************************************************************************************************/
public class ITSMSWorkstationCompController  extends ITSMSComponentControllerBase {


    // format case record for Workstation: Workstation
    public override void formatCaseRec (){
        componentToPage.caseRec = caseRec;
        componentToPage.caseRec.Category__c = ITSMSConstants.WORKSTATION_CATEGORY;
        componentToPage.caseRec.CategoryDetails__c = ITSMSConstants.WORKSTATION_CATEGORYDETAILS;
        if (ITSMSConstants.DESKTOP_PCMODELS.contains('#'+componentToPage.caseRec.PCModelType__c+'#'))
            componentToPage.caseRec.ServiceDeskProduct__c = componentToPage.caseRec.PCModelType__c;
        componentToPage.caseRec.ServiceRequestType__c = ITSMSConstants.WORKSTATION_SERVICEREQUESTTYPE;
        string workstationType = ViasatUtilityClass.replaceNullForString(componentToPage.caseRec.WorkstationType__c, 'not entered');
        string pcModel = ViasatUtilityClass.replaceNullForString(componentToPage.caseRec.PCModelType__c, 'not entered');
        string computerType = ViasatUtilityClass.replaceNullForString(componentToPage.caseRec.ComputerType__c, 'not entered');
        string operatingSystem = ViasatUtilityClass.replaceNullForString(componentToPage.caseRec.OperatingSystem__c, 'not entered');
        string assetTag = ViasatUtilityClass.replaceNullForString(componentToPage.caseRec.AssetTag__c, 'not entered');
        string[] workstationArgs = new string [] { workstationType, pcModel, computerType, operatingSystem, assetTag};
        componentToPage.caseRec.DescriptionRichText__c = string.format(ITSMSConstants.WORKSTATION_DESCRIPTION, workstationArgs);             
        string[] workstationSubjArgs = new string [] { workstationType, componentToPage.caseRec.BriefDescription__c};
        componentToPage.caseRec.Subject = string.format(ITSMSConstants.WORKSTATION_SUBJECT,workstationSubjArgs);
    }
 }