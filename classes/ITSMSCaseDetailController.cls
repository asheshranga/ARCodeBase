/*
 * Class ITSMSCaseDetailController
 * 
 * @version 1.0
 * @author  Dianna Guilinger - Slalom  
 *
 * Usage: controller for ITSMSCaseDetail VF Page 
 * Displays details and related information for a selected Case.  When a community user
 * selects a submitted case from the My Cases or My New Hires list view and clicks on the 
 * Case Number hyperlink, details for that case will be displayed by this controller.
 * 
 */
public class ITSMSCaseDetailController extends ITSMSPageControllerBase{

    public boolean caseIsNewHire {get;set;}
    public boolean caseIsSupport {get;set;}
    public boolean relatedCasesExist {get;set;}
    public boolean relatedEmailsExist {get;set;}
    public string inputCaseId=ApexPages.currentPage().getParameters().get('caseId');
    public PageReference pageRef {get;set;}
    public Case thisCase{get;set;}


   // --  controller 
    public ITSMSCaseDetailController (ApexPages.StandardController setCon) {
        thisCase= (Case)setCon.getRecord();
    } 

    //  --    
    public PageReference checkCase() {
        if ( thisCase.Status == ITSMSConstants.CASE_STATUS_PRESUBMIT && thisCase.ServiceRequestType__c == ITSMSConstants.NEWHIRE_SRVREQTYPE_PARENT)
        {
            pageRef= new PageReference(ITSMSConstants.NAVIGATE_NEWHIRE+'?caseId='+thisCase.Id);
            pageRef.setredirect(true); 
            return pageRef;  
        } else
        {
            if ( thisCase.Status == ITSMSConstants.CASE_STATUS_PRESUBMIT && thisCase.ServiceRequestType__c != ITSMSConstants.NEWHIRE_SRVREQTYPE_PARENT)
            {
                pageRef= new PageReference(ITSMSConstants.NAVIGATE_SUPPORT_REQUEST+'?Id='+thisCase.Id);
                pageRef.setredirect(true); 
                return pageRef;  
            } else
            {
                if (ITSMSConstants.SUPPORT_CATEGORY.contains('#'+thisCase.SupportCategory__c+'#') )
                {
                    caseIsSupport = true;
                }
                else {
                    caseIsNewHire = true;
                }
                if (ITSMSUtilityClass.relatedCasesExist(thisCase))
                	relatedCasesExist = true;    
                if (ITSMSUtilityClass.relatedEmailsExist(thisCase))
                	relatedEmailsExist = true;    
                return null;
            }
        }
    }
    public PageReference returnToMyCases() {
    return null;
    }

}