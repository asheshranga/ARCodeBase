/**************************************************************************************************************
Name         : ITSMSSoftwareJenkinsCompController 
Created By   : Dianna Guilinger - Slalom 
Description  : Controller for VF Component ITSMSSoftwareJenkins
             : Obtains passed parameters, manages page action
***************************************************************************************************************/
public class ITSMSSoftwareJenkinsCompController  extends ITSMSComponentControllerBase {

    // format case record for Software: Software Request
    public override void formatCaseRec (){
        componentToPage.caseRec = caseRec;
        componentToPage.caseRec.Category__c = ITSMSConstants.SOFTWARE_OTHER_CATEGORY;
        componentToPage.caseRec.CategoryDetails__c = ITSMSConstants.SOFTWARE_OTHER_CATEGORYDETAILS;
        componentToPage.caseRec.ServiceDeskProduct__c = ITSMSConstants.SOFTWARE_OTHER_PRODUCT;
        componentToPage.caseRec.ServiceRequestType__c = ITSMSConstants.SOFTWARE_OTHER_SERVICEREQUESTTYPE;
        string[] softwareArgs = new string [] { componentToPage.caseRec.InstanceName__c, componentToPage.caseRec.Description };
            componentToPage.caseRec.DescriptionRichText__c = string.format(ITSMSConstants.SOFTWARE_OTHER_DESCRIPTION, softwareArgs);             
        componentToPage.caseRec.Subject = ITSMSConstants.SOFTWARE_OTHER_SUBJECT;
    }
 }