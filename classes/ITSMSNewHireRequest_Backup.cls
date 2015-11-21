// backup
public class ITSMSNewHireRequest_Backup extends ITSMSPageControllerBase{

    public ITSMSComponentToController componentToPage {get; private set;}

    //--- define variables
    public id existingCaseId {get;set;}
    public string caseNumber {get;set;}
    public string startDate {get;set;}
    public boolean notYetSubmitted {get;set;}
    public boolean showPageMessage {get;set;}
    public boolean newRequestNeeded {get;set;}
    public boolean caseAlreadyExists {get;set;}
    public boolean contractorExtensionRequest {get;set;}
    public Case caseRec {get;set;}
    public Case existingCase {get;set;}
    public string inputCaseId {get;set;}
    
    public ApexPages.StandardController caseCtrl {get;set;}
    public string priorSelectedSoftware {get;set;}
    public List<SelectOption> availableSoftware {get;set;} // Retrieved using ITSMSUtilityClass.getPicklistValues   
    
    public String selectedSoftware {get;set;}
    
    public String selectedSoftwareCheck {get;set;}
    
    // Controller
    public ITSMSNewHireRequest_Backup()  {
        componentToPage = new ITSMSComponentToController();
        setNavigationElements();
        notYetSubmitted = true;
        newRequestNeeded = false;
        contractorExtensionRequest = false;
        caseRec = new Case(); 
        caseCtrl = new ApexPages.StandardController(caseRec);
        inputCaseId = ApexPages.currentPage().getParameters().get('caseId');
        initCaseRec();
    }

    // initialize new case record 
    public void initCaseRec () {
        availableSoftware = ITSMSUtilityClass.getPicklistValues(caseRec, 'Software__c'); 
        if (inputCaseId != null)
        {
            caseRec = ITSMSUtilityClass.getExistingCase(ITSMSConstants.NEWHIRE_QUERY +' from Case where Id = :inputCaseId', inputCaseId);
            if (caseRec != null)
            {
                priorSelectedSoftware = caseRec.Software__c;
                caseAlreadyExists = true;
                checkSubmitButton();
            }
        } 
        if (caseRec == null || caseRec.Id == null)
        {
            string inputCategory = ITSMSConstants.NEWHIRE;
            string srvreqType = ITSMSConstants.NEWHIRE_SRVREQTYPE_PARENT;
            caseRec = ITSMSUtilityClass.createCase(inputCategory, srvreqType);
            caseRec.Requestor__c = UserInfo.getUserId();
            caseRec.Category__c = ITSMSConstants.NEWHIRE_CATEGORY;
            caseRec.CategoryDetails__c = ITSMSConstants.NEWHIRE_CATEGORYDETAIL;
             // required to pass case to components
            componentToPage.notSubmitted = true;
            componentToPage.caseRec = caseRec;
                    
        }
       system.debug('selected software is:' +  ApexPages.currentPage().getParameters().get('selectedSoftwareBox'));
    }  

    //-- ** Do not show submit button if case was already submitted 
    public void checkSubmitButton () {
       
        if (caseRec.Status != null && !ITSMSConstants.NEWHIRE_STATUS_CAN_SUBMIT.contains('#'+caseRec.Status+'#') )
        {
            notYetSubmitted = false;
            turnOnMessage();
            string[] submitMsgArgs = new String[] { caseRec.caseNumber, caseRec.Status };
            ApexPages.Message msg;
            msg = new ApexPages.Message(ApexPages.Severity.INFO, String.format(ITSMSConstants.NEWHIRE_CASE_ALREADY_SUBMITTED, submitMsgArgs) );
            ApexPages.getMessages().clear();
            ApexPages.addMessage(msg);
            
            
        }
    }

    //-- ** format case record **
    public void formatCaseRec () {        
        if (existingCaseId != null )
            caseRec.Id = existingCaseId;
        if (caseRec.StartDate__c != null)
            startDate = caseRec.StartDate__c.month()+'/'+caseRec.StartDate__c.day()+'/'+caseRec.StartDate__c.year();
        string middleName = ViasatUtilityClass.replaceNullForString(caseRec.MiddleNameInitial__c, ' ');
        string[] newHireSubjArgs = new string[] {caseRec.NewHireType__c, caseRec.FirstName__c, middleName, caseRec.LastName__c, caseRec.PhysicalLocation__c};
        caseRec.Subject = string.format(ITSMSConstants.NEWHIRE_SUBJECT, newHireSubjArgs);
        caseRec.Description = caseRec.Subject;
        // will store New Hire manager in Requesting on behalf of user for consistency with support requests and build of case team
        If (caseRec.ManagerUser__c != null)
                caseRec.RequestingForUser__c = caseRec.ManagerUser__c; 
        // get associated contact for requestor
        User reqUser = ITSMSUtilityClass.getRequestor(caseRec);
        Contact reqContact = ITSMSUtilityClass.getRequestorContact(reqUser);
        if (reqContact != null)
        {
            caseRec.ContactId = reqContact.Id;
            if (reqContact.AccountId != null)
                caseRec.AccountId = reqContact.AccountId;
        }  
        //   get selected software
        system.debug('**************************** HIPPO: ' + selectedSoftware);
        caseRec.AdditionalSoftware__c = selectedSoftware;
        caseRec.Software__c = selectedSoftware;
        //   get entitlement
        Entitlement ent = ITSMSUtilityClass.getEntitlement(ITSMSConstants.ENTITLEMENT_ACTIVEDIRECTORY);
        if (ent != null) 
            caseRec.EntitlementId = ent.Id;
         //   Fetch the assignment rules on case
        formatCaseDescription(); 
    }  

    //-- ** format case description **----------------------------------------------------------------------------------
    public void formatCaseDescription () {
        string endDate = '';
        if (caseRec.WorkEndDate__c != null)
            endDate = caseRec.WorkEndDate__c.month()+'/'+caseRec.WorkEndDate__c.day()+'/'+caseRec.WorkEndDate__c.year();
            
        string accessLevel = ViasatUtilityClass.replaceNullForString(caseRec.AgileAccessLevel__c, 'not entered');
        string additionalComments = ViasatUtilityClass.replaceNullForString(caseRec.AdditionalComments__c, 'not entered');
        string additionalRoles = ViasatUtilityClass.replaceNullForString(caseRec.AdditionalAgileRolesRequired__c, 'not entered');
        string additionalSoftware = ViasatUtilityClass.replaceNullForString(caseRec.Software__c, 'not entered');
        string agileAccess = ViasatUtilityClass.replaceNullForString(caseRec.AgileAccessRequired__c, 'not entered');
        string backOffice = ViasatUtilityClass.replaceNullForString(caseRec.BackofficeSystemsAccess__c, 'not entered');
        string citizenship = ViasatUtilityClass.replaceNullForString(caseRec.Citizenship__c, 'not entered');
        string companyEmail = ViasatUtilityClass.replaceNullForString(caseRec.CompanyEmail__c, 'not entered');
        string companyName = ViasatUtilityClass.replaceNullForString(caseRec.CompanyName__c, 'not entered');
        string deptName = ViasatUtilityClass.replaceNullForString(caseRec.DepartmentName__c, 'not entered');
        string deskPhone = ViasatUtilityClass.replaceNullForString(caseRec.DeskPhone__c, 'not entered'); 
        string distGroup = ViasatUtilityClass.replaceNullForString(caseRec.DistributionGroup__c, 'not entered'); 
        string doYouApprove = ViasatUtilityClass.replaceNullForString(caseRec.DoYouApproveThisForm__c, 'not entered');
        string exedeBackOffice = ViasatUtilityClass.replaceNullForString(caseRec.ExedeBackOfficeJumpBox__c, 'not entered');
        string isRemote = ViasatUtilityClass.replaceNullForString(caseRec.IsRemoteAccessRequired__c, 'not entered');
        string justification = ViasatUtilityClass.replaceNullForString(caseRec.JustificationWIKIURLs__c, 'not entered');
        string middleName = ViasatUtilityClass.replaceNullForString(caseRec.MiddleNameInitial__c, ' ');
        string mirrorAgent = ViasatUtilityClass.replaceNullForString(caseRec.AgentToMirror__c, 'not entered');
        string modeledAccount = ViasatUtilityClass.replaceNullForString(caseRec.AgileModelUser__c, 'not entered');
        string networkDirectory = ViasatUtilityClass.replaceNullForString(caseRec.NetworkDirectoryAccessLevel__c, 'not entered');
        string nocAgent = ViasatUtilityClass.replaceNullForBoolean(caseRec.NOCAgents__c, 'not entered');
        string officeCube = ViasatUtilityClass.replaceNullForString(caseRec.OfficeCubeNumber__c, 'not entered');
        string offsiteLocation = ViasatUtilityClass.replaceNullForString(caseRec.OffsiteLocation__c, 'not entered');
        string oracleRespASCP = ViasatUtilityClass.replaceNullForString(caseRec.OracleASCPResponsibilities__c, 'not entered');
        string oracleRespEBS = ViasatUtilityClass.replaceNullForString(caseRec.OracleEBSResponsibilities__c, 'not entered');
        string oracleRespOBIEE = ViasatUtilityClass.replaceNullForString(caseRec.OracleOBIEEResponsibilities__c, 'not entered');
        string otherPCModel = ViasatUtilityClass.replaceNullForString(caseRec.OtherPCModelOS__c, 'not entered');
        string otherHardware = ViasatUtilityClass.replaceNullForString(caseRec.OtherHardware__c, 'not entered');
        string pcModel = ViasatUtilityClass.replaceNullForString(caseRec.PCModel__c, 'not entered');
        string pcModelType = ViasatUtilityClass.replaceNullForString(caseRec.PCModelType__c, 'not entered');
        string perforce = ViasatUtilityClass.replaceNullForString(caseRec.PerforceServerFolders__c, 'not entered');
        string physLoc = ViasatUtilityClass.replaceNullForString(caseRec.PhysicalLocation__c, 'not entered');
        string program = ViasatUtilityClass.replaceNullForString(caseRec.ProgramProjectName__c, 'not entered');
        string securityGroups = ViasatUtilityClass.replaceNullForString(caseRec.SecurityGroups__c, 'not entered');
        string sharedMailbox = ViasatUtilityClass.replaceNullForString(caseRec.SharedMailboxes__c, 'not entered');
        string systemDetails = ViasatUtilityClass.replaceNullForString(caseRec.BackofficeSystemDetails__c, 'not entered');
        string wireless = ViasatUtilityClass.replaceNullForString(caseRec.WirelessHeadset__c, 'not entered');
        if (caseRec.AgileModelUser__c!= null)
        {
            list<User> c = new list<User> ([Select Id, FirstName, LastName from User
                                                  where Id = :caseRec.AgileModelUser__c limit 1]);
            if (c.size() == 1)
                modeledAccount = c[0].FirstName+' '+c[0].LastName;
        } 
        if (caseRec.AgentToMirror__c != null)
        {
            list<User> c = new list<User> ([Select Id, FirstName, LastName from User
                                                  where Id = :caseRec.AgentToMirror__c limit 1]);
            if (c.size() == 1)
                mirrorAgent = c[0].FirstName+' '+c[0].LastName;
        } 
        
        string[] descArgs = new string [] {caseRec.FirstName__c, middleName, caseRec.LastName__c, caseRec.NewHireType__c, caseRec.EmployeeType__c,
            startDate, citizenship, deptName, physLoc, offsiteLocation, officeCube};
        caseRec.DescriptionRichText__c = string.format(ITSMSConstants.NEWHIRE_DESCRIPTION_HEADER, descArgs); 
        if (caseRec.NewHireType__c == 'Contractor')
        {
            descArgs = new string [] {companyName, companyEmail, endDate, program};
            caseRec.DescriptionRichText__c += string.format(ITSMSConstants.NEWHIRE_DESCRIPTION_CONTRACTOR, descArgs); 
        }
        descArgs = new string [] {deskPhone, wireless, pcModelType, pcModel,otherPCModel, otherHardware};
        caseRec.DescriptionRichText__c += string.format(ITSMSConstants.NEWHIRE_DESCRIPTION_DESKTOP, descArgs); 
        
        descArgs = new string [] {isRemote, sharedMailbox, securityGroups,  networkDirectory, distGroup, oracleRespASCP, oracleRespEBS, oracleRespOBIEE };
        caseRec.DescriptionRichText__c += string.format(ITSMSConstants.NEWHIRE_DESCRIPTION_ACCESSADMIN, descArgs); 
        
        descArgs = new string [] {caseRec.IsPerforceAccessRequired__c, perforce  };
        caseRec.DescriptionRichText__c += string.format(ITSMSConstants.NEWHIRE_DESCRIPTION_PERFORCE, descArgs); 
        
        descArgs = new string [] {additionalSoftware};
        caseRec.DescriptionRichText__c += string.format(ITSMSConstants.NEWHIRE_DESCRIPTION_SOFTWARE, descArgs); 
        
        descArgs = new string [] {agileAccess, accessLevel, additionalRoles, modeledAccount};
        caseRec.DescriptionRichText__c += string.format(ITSMSConstants.NEWHIRE_DESCRIPTION_AGILE, descArgs); 
        
        descArgs = new string [] {backOffice, exedeBackOffice, systemDetails};
        caseRec.DescriptionRichText__c += string.format(ITSMSConstants.NEWHIRE_DESCRIPTION_BACKOFFICE, descArgs); 
        
        descArgs = new string [] {nocAgent, mirrorAgent };
        caseRec.DescriptionRichText__c += string.format(ITSMSConstants.NEWHIRE_DESCRIPTION_TELECOM, descArgs); 
        
        descArgs = new string [] {additionalComments, doYouApprove};
        caseRec.DescriptionRichText__c += string.format(ITSMSConstants.NEWHIRE_DESCRIPTION_MISC, descArgs); 
    }

    //--  ** Turn on page messages **---------------------------------------------------------------------------------------
    public void turnOnMessage () {
        showPageMessage = true;
    }   

    //--  ** Turn on page messages **---------------------------------------------------------------------------------------
    public PageReference checkRequestIssue () {
        if (caseRec.IssueOrRequest__c == ITSMSConstants.REQUEST_SELECTED)
            contractorExtensionRequest = true;
        componentToPage.caseRec.IssueOrRequest__c = caseRec.IssueOrRequest__c;
        return null;
    }   

    // submit as parent case and prep page for new entry 
    public PageReference submitAndNew(){ 
        newRequestNeeded = true;
        submitRequest();
        PageReference pageRef= new PageReference(ITSMSConstants.NAVIGATE_NEWHIRE);
        pageRef.setredirect(true); 
        return pageRef;  
    }

    // submit New Hire Request Parent case
    public PageReference submitRequest(){ 
        caseRec.Status = ITSMSConstants.NEWHIRE_STATUS_SUBMIT;
        showPageMessage = false;    //  Page messages are off for form validation
        formatCaseRec();        
        
         //   Fetch the assignment rules on case
        AssignmentRule assignRule = new AssignmentRule();
        assignRule = [select id from AssignmentRule where SobjectType = 'Case' and Active = true limit 1];
        if (assignRule != null)
        {
            //  Create DMLOptions for "Assign using active assignment rules" checkbox
            Database.DMLOptions dmlOpts = new Database.DMLOptions();
            dmlOpts.assignmentRuleHeader.assignmentRuleId= assignRule.id;
            //   Set DMLOption on Case instance so that assignment rules are executed
            caseRec.setOptions(dmlOpts);
        }
                // insert/update the parent case        
        boolean isUpserted = ITSMSUtilityClass.upsertCase(caseRec);
        // check that case was upserted without errors
        if (isUpserted)
        {
            // create child case for Active Directory setup
            Case childCase = ITSMSNewHireInitCase.createInitialNewHireCase(caseRec);
        
            //  If another request is needed, redisplay page, otherwise go to case detail page           
            if (!newRequestNeeded )
            {
                PageReference pageRef= new PageReference(ITSMSConstants.NAVIGATE_ON_SUBMITNEWHIRE);
                pageRef.setredirect(true); 
                return pageRef;
            } else
            {
                return null;
            }
        } else
        return null;
    }
    // save case as pending submit 
    public PageReference saveRequest(){ 
        caseRec.Status = ITSMSConstants.NEWHIRE_STATUS_SAVE;
        showPageMessage = false;    //  Page messages are off for form validation
        formatCaseRec();
        boolean isUpserted = ITSMSUtilityClass.upsertCase(caseRec);
        // check that case was upserted without errors
        if (isUpserted)
        {
             // make sure page messages are on
            turnOnMessage();
            string[] saveMsgArgs = new String[] { caseRec.Status };
            PageReference pageRef = ApexPages.currentPage();
            ApexPages.Message msg2;
            msg2 = new ApexPages.Message(ApexPages.Severity.INFO, String.format(ITSMSConstants.NEWHIRE_CASE_IS_CREATED, saveMsgArgs) );
            ApexPages.getMessages().clear();
            ApexPages.addMessage(msg2);
                return pageRef;  
        }
        return null;
    }

    // cancel request creation/update
    public PageReference cancelRequest() {
        PageReference pageRef= new PageReference(ITSMSConstants.NAVIGATE_ON_CANCELNEWHIRE);
        pageRef.setredirect(true); 
        return pageRef;  
    }
}