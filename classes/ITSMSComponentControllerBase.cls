/**************************************************************************************************************
Name         : ITSMSComponentControllerBase 
Created By   : Dianna Guilinger - Slalom 
Description  : Manages communication between VF Page ITSMSSupportRequest and all components
***************************************************************************************************************/
public with sharing virtual class ITSMSComponentControllerBase {

    public string sectionConferencing { get {return ITSMSConstants.FORM_SECTION_CONFERENCING;}} 
    public string sectionEmailSecurity { get {return ITSMSConstants.FORM_SECTION_EMAILSECURITY;}} 
    public string sectionFolderShare { get {return ITSMSConstants.FORM_SECTION_FOLDERSHARE;}} 
    public string sectionMobilityAgreement { get {return ITSMSConstants.FORM_SECTION_MOBILITYAGREEMENT;}} 
    public string sectionMobilityLoan { get {return ITSMSConstants.FORM_SECTION_MOBILITYLOAN;}} 
    public string sectionMobilityNewUpgrade { get {return ITSMSConstants.FORM_SECTION_MOBILITYNEWUPGRADE;}} 
    public string sectionMobilityTransfer { get {return ITSMSConstants.FORM_SECTION_MOBILITYTRANSFER;}} 
    public string sectionOracle { get {return ITSMSConstants.FORM_SECTION_ORACLE;}} 
    public string sectionPartPeripheral { get {return ITSMSConstants.FORM_SECTION_PARTPERIPHERAL;}} 
    public string sectionServerVM { get {return ITSMSConstants.FORM_SECTION_SERVERVM;}} 
    public string sectionServiceAccount { get {return ITSMSConstants.FORM_SECTION_SERVICEACCOUNT;}} 
    public string sectionSharedMailbox { get {return ITSMSConstants.FORM_SECTION_SHAREDMAILBOX;}} 
    public string sectionSharepoint { get {return ITSMSConstants.FORM_SECTION_SHAREPOINT;}} 
    public string sectionSoftware { get {return ITSMSConstants.FORM_SECTION_SOFTWARE;}} 
    public string sectionSoftwareFisheye { get {return ITSMSConstants.FORM_SECTION_SOFTWAREFISHEYE;}} 
    public string sectionSoftwareJIRA { get {return ITSMSConstants.FORM_SECTION_SOFTWAREJIRA;}} 
    public string sectionSoftwareJenkins  { get {return ITSMSConstants.FORM_SECTION_SOFTWAREJENKINS;}} 
    public string sectionSoftwareOther { get {return ITSMSConstants.FORM_SECTION_SOFTWAREOTHER;}} 
    public string sectionSoftwareWIKI { get {return ITSMSConstants.FORM_SECTION_SOFTWAREWIKI;}} 
    public string sectionStorage  { get {return ITSMSConstants.FORM_SECTION_STORAGE;}} 
    public string sectionWorkstation  { get {return ITSMSConstants.FORM_SECTION_WORKSTATION;}} 

    //get key for component controller
    public string key{ 
        get;set{
            if(value != null){
                Key = value;
                if(pageController != null)
                    pageController.setComponentControllerMap(Key, this);
            }
        }
    }

    // get reference to page controller 
    public ITSMSPageControllerBase pageController { 
        get;set{ 
            if (value != null) 
            {
                pageController = value;
                pageController.setComponentController(this);
            }
        }
    }

    // get reference to shared data class    
    public ITSMSComponentToController componentToPage { 
        get;set{ 
            if (value != null) 
                componentToPage = value;
        }
    }

    // get reference to shared case record
    public Case caseRec { 
        get;set{
            if (value != null) 
                caseRec = value;
        }
    }
    
    public virtual void formatCaseRec (){
        // placeholder to allow saveOnly to include formatCaseRec method.
        // formatCaseRec should be overridden in the main component class
    }    
    
    // save 'this case' and prepare to create another for the request
    public PageReference saveAndNew (){
        saveOnly();
        // prepare for adding another case to this request
        componentToPage.caseRec = ITSMSUtilityClass.setupNewCaseRec(componentToPage.caseRec);
        componentToPage.isNewCaseForRequest = true;
        componentToPage.showSubmitAll = true;
        PageReference pageRef= new PageReference(ITSMSConstants.NAVIGATE_SUPPORT_REQUEST+'?Id='+componentToPage.caseRec.Id);
        componentToPage.inEditMode = false;
        return pageRef;  
    }
    
    // save this case as pending first, then 'submit' all cases in request
    public PageReference saveAndSubmit (){
        // first save this record
        saveOnly();
        // then submit all child cases
        PageReference pageRef = componentToPage.submitCases();
        return PageRef;
    }
    
    // save 'this case' and leave formatted on page
    public PageReference saveOnly (){
        formatCaseRec();
        componentToPage.saveCase();
        componentToPage.showSubmitAll = true;
        componentToPage.inEditMode = true;
        return null;
    }
    
    // user clicked cancel - return 
    public PageReference cancelCase(){
        componentToPage.closeCancelRequest();
        // navigate to MyCases
        PageReference pageRef= new PageReference(ITSMSConstants.NAVIGATE_ON_CANCELSUPPORT);
        pageRef.setredirect(true); 
        return pageRef;
    }
    // user clicked cancel of this add - redisplay with no selection
    public PageReference cancelAdd(){
        // reset
        componentToPage.caseRec.SupportRequestType__c = null;
        componentToPage.inEditMode = false;
        return null;
    }

}