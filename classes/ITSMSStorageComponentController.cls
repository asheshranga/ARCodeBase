/**************************************************************************************************************
Name         : ITSMSStorageComponentController 
Created By   : Dianna Guilinger - Slalom 
Description  : Controller for VF Component ITSMSStorage
             : Obtains passed parameters, manages page action
***************************************************************************************************************/
public class ITSMSStorageComponentController  extends ITSMSComponentControllerBase {


    // format case record for Server: Storage
    public override void formatCaseRec (){
        componentToPage.caseRec = caseRec;
        componentToPage.caseRec.Category__c = ITSMSConstants.SERVER_STORAGE_CATEGORY;
        componentToPage.caseRec.CategoryDetails__c = ITSMSConstants.SERVER_STORAGE_CATEGORYDETAIL;
        componentToPage.caseRec.ServiceDeskProduct__c = ITSMSConstants.SERVER_STORAGE_PRODUCT;
        componentToPage.caseRec.ServiceRequestType__c = ITSMSConstants.SERVER_STORAGE_SERVICEREQUESTTYPE;
        string needBy = ViasatUtilityClass.replaceNullForDate(componentToPage.caseRec.Date_Needed_By__c, 'not entered');
        string newHost = ViasatUtilityClass.replaceNullForString(componentToPage.caseRec.NewHost__c, 'not entered');
        string hostName = ViasatUtilityClass.replaceNullForString(componentToPage.caseRec.ServerHostName__c, 'not entered');
        string clustered = ViasatUtilityClass.replaceNullForString(componentToPage.caseRec.Clustered__c, 'not entered');
        string database = ViasatUtilityClass.replaceNullForString(componentToPage.caseRec.Database__c, 'not entered');
        string diskname = ViasatUtilityClass.replaceNullForString(componentToPage.caseRec.DiskName__c, 'not entered');
        string storageType = ViasatUtilityClass.replaceNullForString(componentToPage.caseRec.ServerStorageType__c, 'not entered');
        string size = ViasatUtilityClass.replaceNullForDecimal(componentToPage.caseRec.StorageSize__c, 'not entered');
        string sizeType = ViasatUtilityClass.replaceNullForString(componentToPage.caseRec.StorageSizeType__c, 'not entered');
        string snapshotClone = ViasatUtilityClass.replaceNullForString(componentToPage.caseRec.StorageSnapshotClone__c, 'not entered');
        string sourceHost = ViasatUtilityClass.replaceNullForString(componentToPage.caseRec.SourceHostname__c, 'not entered');
        string targetHost = ViasatUtilityClass.replaceNullForString(componentToPage.caseRec.TargetHostname__c, 'not entered');
        string environments = ViasatUtilityClass.replaceNullForString(componentToPage.caseRec.StorageEnvironment__c, 'not entered');
        string frequency = ViasatUtilityClass.replaceNullForString(componentToPage.caseRec.StorageFrequency__c, 'not entered');
        string startDate = ViasatUtilityClass.replaceNullForDateTime(componentToPage.caseRec.StartDateTime__c, 'not entered');
        string endDate = ViasatUtilityClass.replaceNullForDateTime(componentToPage.caseRec.EndDateTime__c, 'not entered');
        string[] storageArgs = new string [] { needBy, componentToPage.caseRec.EquipmentLocation__c, componentToPage.caseRec.CostCenterNumber__c,
            componentToPage.caseRec.BriefDescription__c, componentToPage.caseRec.JustificationRequest__c, newHost, hostName, clustered, storageType,
            database, diskname, size, sizeType, snapshotClone, sourceHost, targetHost, environments,frequency,startDate, endDate};
        componentToPage.caseRec.DescriptionRichText__c = string.format(ITSMSConstants.SERVER_STORAGE_DESCRIPTION, storageArgs);             
        string[] storageSubjArgs = new string [] { componentToPage.caseRec.SupportRequestType__c, componentToPage.caseRec.BriefDescription__c};
        componentToPage.caseRec.Subject = string.format(ITSMSConstants.SERVER_STORAGE_SUBJECT,storageSubjArgs);
    }
}