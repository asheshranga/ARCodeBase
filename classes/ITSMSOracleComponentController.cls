/**************************************************************************************************************
Name         : ITSMSOracleComponentController 
Created By   : Dianna Guilinger - Slalom 
Description  : Controller for VF Component ITSMSOracle
             : Obtains passed parameters, manages page action
***************************************************************************************************************/
public class ITSMSOracleComponentController  extends ITSMSComponentControllerBase {

    // format case record for Access: Oracle
    public override void formatCaseRec (){
        User requestUser = ITSMSUtilityClass.getRequestor(caseRec);
        componentToPage.caseRec = caseRec;
        componentToPage.caseRec.Category__c = ITSMSConstants.ORACLE_CATEGORY;
        componentToPage.caseRec.CategoryDetails__c = ITSMSConstants.ORACLE_CATEGORYDETAIL;
        componentToPage.caseRec.ServiceRequestType__c = ITSMSConstants.ORACLE_SERVICEREQUESTTYPE;
        string accessType = ViasatUtilityClass.replaceNullForString(componentToPage.caseRec.AccessType__c, 'not entered');
        string deptName = ViasatUtilityClass.replaceNullForString(componentToPage.caseRec.DepartmentName__c, 'not entered');
        string addtlRoles = ViasatUtilityClass.replaceNullForString(componentToPage.caseRec.AdditionalAgileRolesRequired__c, 'not entered');
        string privNeeded = ViasatUtilityClass.replaceNullForString(componentToPage.caseRec.PrivilegesNeeded__c, 'not entered');
        string approveForm = ViasatUtilityClass.replaceNullForString(componentToPage.caseRec.DoYouApproveThisForm__c, 'not entered');
        string otherResp = ViasatUtilityClass.replaceNullForString(componentToPage.caseRec.OtherResponsibilities__c, 'not entered');
        string addtlComments = ViasatUtilityClass.replaceNullForString(componentToPage.caseRec.AdditionalComments__c, 'not entered');
        string userAccess = '';
        If (ITSMSConstants.ACCESSTYPE_AGILE.contains('#'+componentToPage.caseRec.AccessType__c+'#'))
        {
            userAccess = ITSMSUtilityClass.formatUserAccess(ITSMSConstants.PERMISSIONS_RECTYPE_ORACLE_AGILE, componentToPage.caseRec);
            string[] oracleArgs = new string [] { accessType, deptName, addtlRoles, privNeeded, approveForm, userAccess, otherResp, addtlComments };
            componentToPage.caseRec.DescriptionRichText__c = string.format(ITSMSConstants.ORACLE_DESCRIPTION_AGILE, oracleArgs);             
            string[] oracleSubjArgs = new string[] {accessType, requestUser.FirstName, requestUser.LastName};
            componentToPage.caseRec.Subject = string.format(ITSMSConstants.ORACLE_SUBJECT_AGILE, oracleSubjArgs);  
            componentToPage.caseRec.ServiceDeskProduct__c = ITSMSConstants.ORACLE_PRODUCT_AGILE;
        } else
        {
            if (ITSMSConstants.ACCESSTYPE_OBIEE.contains('#'+componentToPage.caseRec.AccessType__c+'#'))
            {
            	userAccess = ITSMSUtilityClass.formatUserAccess(ITSMSConstants.PERMISSIONS_RECTYPE_ORACLE_OBIEE, componentToPage.caseRec);
                componentToPage.caseRec.ServiceDeskProduct__c = ITSMSConstants.ORACLE_PRODUCT_OBIEE;
            	string[] oracleArgs = new string [] { accessType, userAccess, otherResp, addtlComments };
            	componentToPage.caseRec.DescriptionRichText__c = string.format(ITSMSConstants.ORACLE_DESCRIPTION_NOTAGILE, oracleArgs);             
            	string[] oracleSubjArgs = new string[] {accessType, requestUser.FirstName, requestUser.LastName};
            	componentToPage.caseRec.Subject = string.format(ITSMSConstants.ORACLE_SUBJECT_NOTAGILE, oracleSubjArgs); 
            } else {
            	if (ITSMSConstants.ACCESSTYPE_ASCP.contains('#'+componentToPage.caseRec.AccessType__c+'#'))
            	{
            		userAccess = ITSMSUtilityClass.formatUserAccess(ITSMSConstants.PERMISSIONS_RECTYPE_ORACLE_ASCP, componentToPage.caseRec);
            		string[] oracleArgs = new string [] { accessType, userAccess, otherResp, addtlComments };
            		componentToPage.caseRec.DescriptionRichText__c = string.format(ITSMSConstants.ORACLE_DESCRIPTION_NOTAGILE, oracleArgs);             
            		string[] oracleSubjArgs = new string[] {accessType, requestUser.FirstName, requestUser.LastName};
            		componentToPage.caseRec.Subject = string.format(ITSMSConstants.ORACLE_SUBJECT_NOTAGILE, oracleSubjArgs); 
                	componentToPage.caseRec.ServiceDeskProduct__c = ITSMSConstants.ORACLE_PRODUCT_OTHER;
                } else {
            		userAccess = ITSMSUtilityClass.formatUserAccess(ITSMSConstants.PERMISSIONS_RECTYPE_ORACLE_EBS, componentToPage.caseRec);
            		string[] oracleArgs = new string [] { accessType, userAccess, otherResp, addtlComments };
            		componentToPage.caseRec.DescriptionRichText__c = string.format(ITSMSConstants.ORACLE_DESCRIPTION_NOTAGILE, oracleArgs);             
            		string[] oracleSubjArgs = new string[] {accessType, requestUser.FirstName, requestUser.LastName};
            		componentToPage.caseRec.Subject = string.format(ITSMSConstants.ORACLE_SUBJECT_NOTAGILE, oracleSubjArgs); 
                	componentToPage.caseRec.ServiceDeskProduct__c = ITSMSConstants.ORACLE_PRODUCT_OTHER;
                }
        	} 
        }
    }

}