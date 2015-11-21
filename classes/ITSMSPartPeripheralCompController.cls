/**************************************************************************************************************
Name         : ITSMSPartPeripheralCompController 
Created By   : Dianna Guilinger - Slalom 
Description  : Controller for VF Component ITSMSPartPeripheral
             : Obtains passed parameters, manages page action
***************************************************************************************************************/
public class ITSMSPartPeripheralCompController  extends ITSMSComponentControllerBase {

    // format case record for Workstation: Part/Peripheral
    public override void formatCaseRec (){
        componentToPage.caseRec = caseRec;
        componentToPage.caseRec.Category__c = ITSMSConstants.WORKSTATION_PARTS_CATEGORY;
        componentToPage.caseRec.CategoryDetails__c = null;
        componentToPage.caseRec.ServiceDeskProduct__c = ITSMSConstants.WORKSTATION_PARTS_PRODUCT;
        componentToPage.caseRec.ServiceRequestType__c = ITSMSConstants.WORKSTATION_PARTS_SERVICEREQUESTTYPE;
        string partsRequest = ViasatUtilityClass.replaceNullForString(componentToPage.caseRec.PartsRequest__c, 'not entered');
        string[] partArgs = new string [] { partsRequest};
        componentToPage.caseRec.DescriptionRichText__c = string.format(ITSMSConstants.WORKSTATION_PARTS_DESCRIPTION, partArgs);             
        string[] partSubjArgs = new string [] { componentToPage.caseRec.SupportRequestType__c};
        componentToPage.caseRec.Subject = string.format(ITSMSConstants.WORKSTATION_PARTS_SUBJECT,partSubjArgs);
    }
    
}