/**************************************************************************************************************
Name         : ITSMSComponentToController 
Created By   : Dianna Guilinger - Slalom 
Description  : Class of shared data/methods between components and page for ITSMS Support Center
***************************************************************************************************************/
public with sharing class ITSMSComponentToController{

    
    public boolean notSubmitted {get;set;}
    public boolean isNewRequest {get;set;}
    public boolean isNewCaseForRequest {get;set;}
    public boolean showSubmitAll {get;set;}
    public boolean isGeneralCase {get;set;}
    public boolean isContractorExtension {get;set;}
    public boolean childCasesExist {get;set;}
    public boolean inEditMode {get;set;}
    public string inputCaseId {get;set;}
    public string parentId {get;set;}
    public string inputSupportCategory {get;set;}
    public string caseToEdit {get;set;}
    public string caseToDelete {get;set;}

    public list <Case> childCases {get;set;}
    public map <Integer, String> errorRows {get;set;}
    public list <RequestChildCase> reqChildCases {get;set;}
    public Case caseRec; 
    public Case getCaseRec(){
        return caseRec;
    }
    
    // find or initialize case record 
    public Case setCaseRec (string inputSupportCategory, string inputCaseId){
        childCasesExist = false;
        isNewRequest = true;
        notSubmitted = true;
        showSubmitAll = false;
        isNewCaseForRequest = true;
        isGeneralCase = false;
        isContractorExtension = false;
        inEditMode = false;
       // get record if id was included in URL
        if (caseRec == null && inputCaseId != null && inputCaseId != '')
        {
            caseRec = ITSMSUtilityClass.getExistingCase(ITSMSConstants.SUPPORT_QUERY +' from Case where Id = :inputCaseId Limit 1', inputCaseId);
            if (caseRec != null)
            {
                isNewRequest = false;
                if ( !ITSMSConstants.SUPPORT_STATUS_CAN_SUBMIT.contains('#'+caseRec.Status+'#')  ) 
                    notSubmitted = false;
            }
        }
        // initialize for creating new record if id was not included or not found
        if (caseRec == null)
            caseRec = ITSMSUtilityClass.createCase(inputSupportCategory, ITSMSConstants.SUPPORT_SRVREQTYPE_GENERAL);
        // if existing non-submitted cases for the request show submit all button
        if (isNewrequest == false && notSubmitted == true)
            showSubmitAll = true;
        return caseRec;
    }     
    
    // initialize area to hold existing related/child cases and any encountered errors
    public void initRequestChildCases (){
        map <Integer, String> noErrorsYet = new map<Integer, String> ();
        reqChildCases = setRequestChildCases (childCases, noErrorsYet, null);
        childCasesExist = true;
        
    }     

    // define area to hold existing related/child cases and any encountered errors
    public list <RequestChildCase> setRequestChildCases (list<Case> childCases, map<integer,string> errorRows, Case thisCase){
        reqChildCases = new list<RequestChildCase> ();
        integer thisRow = 0;
        string errorText = ' ';
        string thisCaseText = ' ';
        for (Case  c:childCases)
        {
            if (errorRows != null && !errorRows.isEmpty()  && errorRows.get(thisRow) != null)
                errorText = errorRows.get(thisRow);
            If (thisCase != null && thisCase.Id != null && thisCase.Id == c.Id)
                thisCaseText = 'selected';
            RequestChildCase row = new RequestChildCase(c, errorText, thisCaseText);
            reqChildCases.add(row);
            thisRow++;
        }
        return reqChildCases;
    }

    // common method used to submit all related cases 
    public PageReference submitCases (){
        
        User reqUser = ITSMSUtilityClass.getRequestor(caseRec);
        // get associated contact for requestor
        Contact requestContact = ITSMSUtilityClass.getRequestorContact(reqUser);
        //   Fetch the assignment rules on case
        AssignmentRule assignRule = new AssignmentRule();
        Database.DMLOptions dmlOpts = new Database.DMLOptions();
        assignRule = [select id from AssignmentRule where SobjectType = 'Case' and Active = true limit 1];
        if (assignRule != null)
            dmlOpts.assignmentRuleHeader.assignmentRuleId= assignRule.id;
        //   Set DMLOption on each case instance so that assignment rules are executed
         parentId = null;
        for (Case c:childCases)
        {
            if (assignRule != null)
                c.setOptions(dmlOpts);
            c.Status = ITSMSConstants.SUPPORT_STATUS_SUBMIT;
            if (parentId == null && c.ParentId != null)
                parentId = c.ParentId;
            if (requestContact != null)
            {
                c.ContactId = requestContact.Id;
                c.AccountId = requestContact.AccountId;
            }
       }
        errorRows = new map<Integer, String> ();
        if (childCases.size() > 0)
            errorRows = ITSMSUtilityClass.validateAndUpdateCases(childCases);
         if (errorRows.size() == 0)
        {
            // close parent as all child cases are submitted
            Case parentCase = [Select Id from Case where Id = :parentId limit 1];
            if (parentCase != null)
            {
                parentCase.Status = ITSMSConstants.CASE_STATUS_CLOSE;
                ITSMSUtilityClass.upsertCase(parentCase);
            }
            // navigate as no errors occurred
            PageReference pageRef= new PageReference(ITSMSConstants.NAVIGATE_ON_SUBMITSUPPORT);
            pageRef.setredirect(true); 
            return pageRef;
        } else
        {
            // move first error row to 'this' case and re-update 
            //  so that field level error messages are displayed
            list<integer> rowForError = new list<integer> (errorRows.keyset());
            caseRec = childCases.get(rowForError.get(0));
            // flag childcases having error
            reqChildCases = setRequestChildCases (childCases, errorRows, caseRec);
            // re-update this case to get errors
            boolean errorCheck = ITSMSUtilityClass.upsertCase (caseRec); 
            return null;
        }
    }
    
    // save was clicked for case 
    public boolean saveCase (){
        User reqUser = ITSMSUtilityClass.getRequestor(caseRec);
        // get associated contact for requestor
        Contact requestContact = ITSMSUtilityClass.getRequestorContact(reqUser);
        if (requestContact != null)
        {
            caseRec.ContactId = requestContact.Id;
            caseRec.AccountId = requestContact.AccountId;
        }
        // set status to allow further edit for request case
        if (caseRec.IssueOrRequest__c == ITSMSConstants.REQUEST_SELECTED)
        {
            caseRec.Status = ITSMSConstants.SUPPORT_STATUS_SAVE;
        } else
        {
            caseRec.Status = ITSMSConstants.SUPPORT_STATUS_SUBMIT;
        }
        
        // create parent case if this is first case for a request
        if (caseRec.ParentId == null && caseRec.IssueOrRequest__c == ITSMSConstants.REQUEST_SELECTED)
        {
            Case parentCase = ITSMSUtilityClass.createParentCase(inputSupportCategory);
            caseRec.parentId = parentCase.Id;
        }
        // insert/update this case
        boolean isUpserted = ITSMSUtilityClass.upsertCase(caseRec);
        // if this is request, manage list of childCases 
        if (caseRec.IssueOrRequest__c == ITSMSConstants.REQUEST_SELECTED)
        {
           // start list of childCases if this is first case for request
            if (childCases == null)
                childCases = new list<Case>();
            // will add to list if this case is new
            if (childCases.size() == 0)
            {
                childCases.add(caseRec);
            } else
            {
                boolean insertCase = true;
                // check if case already exists in list of child cases
                for (Case c:childCases)
                {
                    if (c.Id == caseRec.Id)
                    {
                        c = caseRec;
                        insertCase = false;
                    }
                }
                if (insertCase)
                    childCases.add(caseRec);
            }
            // initialize request child list for page
            initRequestChildCases();
        }
        return isUpserted;
    } 
    
    // cancel was clicked for case - will close
    public void closeCancelRequest (){
        User reqUser = ITSMSUtilityClass.getRequestor(caseRec);
        // get associated contact for requestor
        Contact requestContact = ITSMSUtilityClass.getRequestorContact(reqUser);
        if (requestContact != null)
        {
            caseRec.ContactId = requestContact.Id;
            caseRec.AccountId = requestContact.AccountId;
        }
        // set status to close/cancel this case 
        caseRec.Status = ITSMSConstants.CASE_STATUS_CLOSE_CANCEL;
        
        // if parent is case in focus, find any children to be canceled
        if (caseRec.ParentId == null)
        {
        } else {
        	// case in focus is not parent, find parent insert/update this case
        }
        // set status of related child cases, if any	
		// update cases
    } 

    // define class to contain child cases, errors for parent case
    public with sharing class RequestChildCase {
        public Case rCase{get;set;}
        public string rError{get;set;}
        public string thisFlag{get;set;}
        public RequestChildCase(Case c, string e, string t){
            this.rCase = c;
            this.rError = e;
            this.thisFlag = t;
        }
    }
}