/**************************************************************************************************************
Name         : ITSMSSupportRequestController 
Created By   : Dianna Guilinger - Slalom 
Description  : Controller for VF Page ITSMS Support Request - enables 
             : ViaSat Support Center community users to create either a request for service comprised of 1 or more
             : child cases or a case for an issue/problem. 
***************************************************************************************************************/
public class ITSMSSupportRequestController extends ITSMSPageControllerBase{
    
    public ITSMSComponentToController componentToPage {get; private set;}

    // initialize page - check for category, id parameters
    public ITSMSSupportRequestController()  {
        componentToPage = new ITSMSComponentToController();
        // get category of request - if not entered will default to Access. This will only happen accessed outside community
        componentToPage.inputSupportCategory = ApexPages.currentPage().getParameters().get('Category');
         // get id of selected case
        componentToPage.inputCaseId = ApexPages.currentPage().getParameters().get('Id');
        // get existing case or initialize new case
        componentToPage.setCaseRec(componentToPage.inputSupportCategory, componentToPage.inputCaseId);
        // if existing case, will format page and get related cases
        if (componentToPage.caseRec.Id != null)
                formatExistingRequest();
        // set to display general case if category is general
        if (componentToPage.inputSupportCategory == ITSMSConstants.GENERAL_CATEGORY)
            componentToPage.isGeneralCase = true;
        // set the title of the page to correct name
        setTitleOfForm(componentToPage.caseRec.SupportCategory__c);
    }

    // existing case is input, format associated group of cases if it is 'request'
    public void formatExistingRequest () {
        // define set for parent ids as that is what utility class needs
        set<Id> parentIds = new set<Id> ();
        //  check if child case was input, or parent was and save parent id 
        if (componentToPage.caseRec.Id != null && componentToPage.caseRec.ParentId != null)
            parentIds.add(componentToPage.caseRec.ParentId);
        if (componentToPage.caseRec.Id != null && componentToPage.caseRec.ParentId == null)
            parentIds.add(componentToPage.caseRec.Id);
        // get all child cases    
        componentToPage.childCases = ITSMSUtilityClass.getCases(ITSMSConstants.SUPPORT_QUERY +' from Case where ParentId = :caseIds', parentIds);
        // initialize area for validating child cases
        if (componentToPage.childCases.size() > 0)
            componentToPage.initRequestChildCases();
        // if 'this' is parent, change to first child case
        if (componentToPage.caseRec.ParentId == null && componentToPage.childCases.size() > 0)
            componentToPage.caseRec = componentToPage.childCases[0];
        componentToPage.inEditMode = true;
        componentToPage.inputSupportCategory = componentToPage.caseRec.SupportCategory__c;
    } 

    // user has selected to edit a child case for a request
    public PageReference editCase (){
        if (ApexPages.currentPage().getParameters().get('EditCaseId') != null)
        {
            componentToPage.caseToEdit = ApexPages.currentPage().getParameters().get('EditCaseId');
            // set case in focus to selected case
            for (Case c:componentToPage.childCases)
            {
                if (c.Id == componentToPage.caseToEdit)
                {
                    componentToPage.caseRec = c;
                    componentToPage.isNewCaseForRequest = false;
                }
            }
            //flag child case as selected
           componentToPage.reqChildCases = componentToPage.setRequestChildCases(componentToPage.childCases, componentToPage.errorRows, componentToPage.caseRec);
        }
        componentToPage.inEditMode = true;
        return null;
    }


    // user has selected issue type 
    public PageReference setIssueType (){
        componentToPage.isGeneralCase = true;
        return null;
    }

    // user has selected to submit All child cases for the request
    public PageReference submitAll (){
        PageReference pageRef = componentToPage.submitCases();
        return pageRef;
    }
}