/**************************************************************************************************************
Name         : ITSMSSoftwareOtherCompController 
Created By   : Dianna Guilinger - Slalom 
Description  : Controller for VF Component ITSMSSoftwareOther
             : Obtains passed parameters, manages page action
***************************************************************************************************************/
public class ITSMSSoftwareOtherCompController  extends ITSMSComponentControllerBase {

    // format case record for Software: Software Request
    public override void formatCaseRec (){
        componentToPage.caseRec = caseRec;
        componentToPage.caseRec.Category__c = ITSMSConstants.SOFTWARE_OTHER_CATEGORY;
        componentToPage.caseRec.CategoryDetails__c = ITSMSConstants.SOFTWARE_OTHER_CATEGORYDETAILS;
        componentToPage.caseRec.ServiceRequestType__c = ITSMSConstants.SOFTWARE_OTHER_SERVICEREQUESTTYPE;
        
        if (ITSMSConstants.SOFTWARE_OTHER_BAMBOO.contains('#'+componentToPage.caseRec.Description+'#') || ITSMSConstants.SOFTWARE_OTHER_BAMBOO.contains('#'+componentToPage.caseRec.OtherSoftwareProduct__c+'#'))
        {
            componentToPage.caseRec.ServiceDeskProduct__c = ITSMSConstants.SOFTWARE_PRODUCT_BAMBOO;
        } else{
            if (ITSMSConstants.SOFTWARE_OTHER_FISHEYE.contains('#'+componentToPage.caseRec.Description+'#') || ITSMSConstants.SOFTWARE_OTHER_FISHEYE.contains('#'+componentToPage.caseRec.OtherSoftwareProduct__c+'#'))    
            {
                componentToPage.caseRec.ServiceDeskProduct__c = ITSMSConstants.SOFTWARE_PRODUCT_FISHEYE;
            } else {
                if (ITSMSConstants.SOFTWARE_OTHER_HIPCHAT.contains('#'+componentToPage.caseRec.Description+'#')  || ITSMSConstants.SOFTWARE_OTHER_HIPCHAT.contains('#'+componentToPage.caseRec.OtherSoftwareProduct__c+'#'))    
                {
                    componentToPage.caseRec.ServiceDeskProduct__c = ITSMSConstants.SOFTWARE_PRODUCT_HIPCHAT;
                } else {
                    if (ITSMSConstants.SOFTWARE_OTHER_JIRA.contains('#'+componentToPage.caseRec.Description+'#')  || ITSMSConstants.SOFTWARE_OTHER_JIRA.contains('#'+componentToPage.caseRec.OtherSoftwareProduct__c+'#'))     
                    {
                        componentToPage.caseRec.ServiceDeskProduct__c = ITSMSConstants.SOFTWARE_PRODUCT_JIRA;
                    } else {
                        if (ITSMSConstants.SOFTWARE_OTHER_WIKI.contains('#'+componentToPage.caseRec.Description+'#')  || ITSMSConstants.SOFTWARE_OTHER_WIKI.contains('#'+componentToPage.caseRec.OtherSoftwareProduct__c+'#'))    
                        {
                            componentToPage.caseRec.ServiceDeskProduct__c = ITSMSConstants.SOFTWARE_PRODUCT_WIKI;
                        } 
                    }
                }
            }
        }
            
        string[] softwareArgs = new string [] { componentToPage.caseRec.OtherSoftwareProduct__c, componentToPage.caseRec.Description };
        componentToPage.caseRec.DescriptionRichText__c = string.format(ITSMSConstants.SOFTWARE_OTHER_DESCRIPTION, softwareArgs);             
        string[] softwareSubjArgs = new string [] { componentToPage.caseRec.ServiceDeskProduct__c  };
        componentToPage.caseRec.Subject = string.format(ITSMSConstants.SOFTWARE_OTHER_SUBJECT, softwareSubjArgs);             
    }
    
}