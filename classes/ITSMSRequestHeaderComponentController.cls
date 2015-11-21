/**************************************************************************************************************
Name         : ITSMSRequestHeaderComponentController 
Created By   : Dianna Guilinger - Slalom 
Description  : Controller for VF Component ITSMSRequestHeader
             : Obtains passed parameters, manages page action
***************************************************************************************************************/
public with sharing class ITSMSRequestHeaderComponentController extends ITSMSComponentControllerBase {

    public boolean showPageMessage {get;set;}
    public string requestorLocation {get;set;}
    public string requestorManager {get;set;}
    public string requestorContact {get;set;}

    public ITSMSRequestHeaderComponentController () {
        formatHeader();
   }


    public PageReference formatHeader () {
        User reqUser = ITSMSUtilityClass.getRequestor(caseRec);
        // get associated contact for requestor
        Contact requestContact = ITSMSUtilityClass.getRequestorContact(reqUser);
        requestorManager = 'Not Available';
        requestorLocation = 'Not Available';
        if (requestContact!= null)
        {
            if (requestContact.ManagerUser__r.FirstName != null && requestContact.ManagerUser__r.LastName != null)
                requestorManager = requestContact.ManagerUser__r.FirstName +' '+ requestContact.ManagerUser__r.LastName;
            string site = ViasatUtilityClass.replaceNullForString(requestContact.Site__c, ' ');
            string building = ViasatUtilityClass.replaceNullForString(requestContact.Building__c, ' ');
            requestorLocation = site +' '+ building;
        }  
        return null;
    }

    // check if user has selected to create a request - insert case if needed
    public PageReference checkCase (){
        componentToPage.caseRec = caseRec;
        boolean isCreated = false;
        if (componentToPage.caseRec.Id == null)
            isCreated = ITSMSUtilityClass.upsertCase(componentToPage.caseRec);
        // check if case is part of existing request and other child cases exist
        if (componentToPage.childCases != null && componentToPage.childCases.size() > 0 && (componentToPage.caseRec.SupportRequestType__c == '--None--' || componentToPage.caseRec.SupportRequestType__c == null ) )
              componentToPage.showSubmitAll = true;
        else
            componentToPage.showSubmitAll = false;
        return null;
    }
}