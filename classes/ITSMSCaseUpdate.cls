/*
 * Class ITSMSCaseUpdate
 * 
 * @version 1.0
 * @author  Dianna Guilinger - Slalom  
 * 
 *  ITSMS Case updates for before and after trigger logic
 */
public class ITSMSCaseUpdate 
{
    // checks for ITSMS Cases that satisfy criteria prior to insert
    public static void beforeInsert(List<Case> newValues) 
    {
        //ITSMS check for a New Hire AD Case, a New Hire Child, or a New Hire Parent
        boolean caseIsAD = false;
        boolean caseIsITSMSChild = false;
        boolean caseIsITSMSClosingParent = false;
        for (Case c : newValues)
        {
            if(ITSMSConstants.CASE_RECORDTYPE != null && ITSMSConstants.CASE_RECORDTYPE != '')
            { 
                // check if any of the cases are ITSMS New Hire AD
                if (c.RecordTypeId == Schema.SObjectType.Case.RecordTypeInfosByName.get(ITSMSConstants.CASE_RECORDTYPE).RecordTypeId && c.ServiceRequestType__c == ITSMSConstants.NEWHIRE_SRVREQTYPE_ACTIVEDIRECTORY )
                    caseIsAD = true;
                // check if any of the cases are ITSMS New Hire Parent where it is being closed
                if (c.RecordTypeId == Schema.SObjectType.Case.RecordTypeInfosByName.get(ITSMSConstants.CASE_RECORDTYPE).RecordTypeId && c.ServiceRequestType__c == ITSMSConstants.NEWHIRE_SRVREQTYPE_PARENT && ITSMSConstants.CASE_STATUS_CLOSE_ALL.contains('#'+c.Status+'#') )
                    caseIsITSMSClosingParent = true;
                // check if any of the cases are ITSMS General children
                if (c.RecordTypeId == Schema.SObjectType.Case.RecordTypeInfosByName.get(ITSMSConstants.CASE_RECORDTYPE).RecordTypeId && c.ParentId != null )
                    caseIsITSMSChild = true;
            }    
        }
        if (caseIsAD == true)
            ITSMSNewHireCaseComplete.completeITSMSNewHireCase(newValues, null); 
        if (caseIsITSMSChild == true)
            checkITSMSParentCase(newValues, null); 
        // this must occur after any other updates to ITSMS New Hire cases
        if (caseIsITSMSClosingParent== true)
            validateITSMSParentClose(newValues, null); 
        
    }

    // checks for ITSMS Cases that satisfy criteria prior to update
    public static void beforeUpdate(List<Case> newValues, Map<Id, Case> oldValuesMap) 
    {
        //ITSMS check for a New Hire AD Case, a New Hire Child, or a New Hire Parent
        boolean caseIsAD = false;
        boolean caseIsITSMSChild = false;
        boolean caseIsITSMSClosingParent = false;
        for (Case c : newValues)
        {
            if(ITSMSConstants.CASE_RECORDTYPE != null && ITSMSConstants.CASE_RECORDTYPE != '')
            { 
                // check if any of the cases are ITSMS New Hire AD
                if (c.RecordTypeId == Schema.SObjectType.Case.RecordTypeInfosByName.get(ITSMSConstants.CASE_RECORDTYPE).RecordTypeId && c.ServiceRequestType__c == ITSMSConstants.NEWHIRE_SRVREQTYPE_ACTIVEDIRECTORY )
                    caseIsAD = true;
                // check if any of the cases are ITSMS New Hire Parent where it is being closed
                if (c.RecordTypeId == Schema.SObjectType.Case.RecordTypeInfosByName.get(ITSMSConstants.CASE_RECORDTYPE).RecordTypeId && c.ServiceRequestType__c == ITSMSConstants.NEWHIRE_SRVREQTYPE_PARENT && ITSMSConstants.CASE_STATUS_CLOSE_ALL.contains('#'+c.Status+'#') && !ITSMSConstants.CASE_STATUS_CLOSE_ALL.contains('#'+oldValuesMap.get(c.Id).Status+'#'))
                    caseIsITSMSClosingParent = true;
                // check if any of the cases are ITSMS General children
                if (c.RecordTypeId == Schema.SObjectType.Case.RecordTypeInfosByName.get(ITSMSConstants.CASE_RECORDTYPE).RecordTypeId && c.ParentId != null )
                    caseIsITSMSChild = true;
            }    
        }
       if (caseIsAD == true)
            ITSMSNewHireCaseComplete.completeITSMSNewHireCase(newValues, oldValuesMap); 
        if (caseIsITSMSChild == true)
            checkITSMSParentCase(newValues, oldValuesMap); 
        // this must occur after any other updates to ITSMS New Hire cases
        if (caseIsITSMSClosingParent== true)
            validateITSMSParentClose(newValues, oldValuesMap); 
        
    }

    // checks for ITSMS Cases that satisfy criteria after update
    public static void afterUpdate(List<Case> newValues, Map<Id, Case> oldValuesMap) 
    {
        set<Id> requestorChgCases = new set<Id> ();
        for (Case c : newValues)
        {
            if(ITSMSConstants.CASE_RECORDTYPE != null && ITSMSConstants.CASE_RECORDTYPE != '')
            { 
                // check if any of the cases are ITSMS and are inserted or have had requestor/requesting on behalf of modified 
                if (c.RecordTypeId == Schema.SObjectType.Case.RecordTypeInfosByName.get(ITSMSConstants.CASE_RECORDTYPE).RecordTypeId && (oldValuesMap == null || (c.Requestor__c <> oldValuesMap.get(c.Id).Requestor__c || c.RequestingForUser__c <> oldValuesMap.get(c.Id).RequestingForUser__c)))
                    requestorChgCases.add(c.Id);
            }
        }
        // update Case Team for ITSMS cases - avoid recursion
        if (requestorChgCases.size() > 0  && ITSMSUtilityClass.teamUpdateRequired())
            ITSMSCaseTeamUpdate.setCaseTeam(requestorChgCases); 
    }

    //-------------------------------------------------------------------------------  
    //  If the New Hire case is being closed and all other cases for the same parent  
    //  are not closed then an error message is returned
    // Executes: before update
    //-------------------------------------------------------------------------------  
    public static void validateITSMSParentClose(List<Case> newValues, Map<Id, Case> oldValuesMap) 
    { 
       // update Case Team for ITSMS cases - avoid recursion
        if (ITSMSUtilityClass.parentValidationRequired())
        {
            set<Id> parentCaseIds = new set<Id>();
            set<Id> parentCheckClose = new set<Id>();
            map<Id,Case> parentIdToChild= new map<Id,Case>();
            map<Id, Integer> parentToOpenChild = new map<Id, Integer>();
            list<Case> childCases = new list<Case>();
            list<Case> updtParentCases = new list<Case>();
            for (Case nv : newValues)
            { 
                // check for change of status to closed for New Hire Parent
                if (nv.RecordTypeId == Schema.SObjectType.Case.RecordTypeInfosByName.get(ITSMSConstants.CASE_RECORDTYPE).RecordTypeId && nv.ServiceRequestType__c == ITSMSConstants.NEWHIRE_SRVREQTYPE_PARENT && ITSMSConstants.CASE_STATUS_CLOSE_ALL.contains('#'+nv.Status+'#') && !ITSMSConstants.CASE_STATUS_CLOSE_ALL.contains('#'+oldValuesMap.get(nv.Id).Status+'#'))
                    // get parent case ids
                    parentCaseIds.add(nv.Id);
            }
            // get list/map of parent cases 
            if (parentCaseIds.size() > 0)
            {
                // get first open child case for any parents being closed
                childCases= [Select Id, ParentId, CaseNumber, Status from Case where ParentId = :parentCaseIds and IsClosed <> true limit 1];
                for (Case c:childCases)
                {
                    parentIdToChild.put(c.ParentId, c);
                }
                // return error if any child cases are still open 
                for (Case nv : newValues)
                {
                    if (nv.RecordTypeId == Schema.SObjectType.Case.RecordTypeInfosByName.get(ITSMSConstants.CASE_RECORDTYPE).RecordTypeId && nv.ServiceRequestType__c == ITSMSConstants.NEWHIRE_SRVREQTYPE_PARENT && ITSMSConstants.CASE_STATUS_CLOSE_ALL.contains('#'+nv.Status+'#') && !ITSMSConstants.CASE_STATUS_CLOSE_ALL.contains('#'+oldValuesMap.get(nv.Id).Status+'#'))
                    {
                        if (parentIdToChild.get(nv.Id) != null )
                            nv.addError(ITSMSConstants.CASE_ERROR_ONPARENTCLOSE);
                    }
                }
            }
        }
    }
    
    //-------------------------------------------------------------------------------  
    //  If the case is being closed and all other cases for the same parent are already 
    //  closed then the parent will be closed.  If the parent case is still in 
    //  'Submitted' status, it will be changed to 'In Progress'.
    //  
    // Executes: before insert, before update
    //-------------------------------------------------------------------------------  
    public static void checkITSMSParentCase (List<Case> newValues, Map<Id, Case> valuesMap) 
    { 
        if (ITSMSUtilityClass.parentCloseCheckRequired())
        {
            boolean updtContact;
            set<Id> parentCaseIds = new set<Id>();
            set<Id> parentCheckClose = new set<Id>();
            map<Id,Case> parentIdToCase = new map<Id,Case>();
            map<Id, Integer> parentToOpenChild = new map<Id, Integer>();
            list<Case> parentCases = new list<Case>();
            list<Case> updtParentCases = new list<Case>();
            for (Case nv : newValues)
            { 
                if (nv.RecordTypeId == Schema.SObjectType.Case.RecordTypeInfosByName.get(ITSMSConstants.CASE_RECORDTYPE).RecordTypeId && nv.ParentId != null)
                    // get parent case ids
                    parentCaseIds.add(nv.ParentId);
            }
            // get list/map of parent cases 
            if (parentCaseIds.size() > 0)
            {
                parentCases = [Select Id, CaseNumber, Status from Case where Id = :parentCaseIds ];
                for (Case p:parentCases)
                {
                    parentIdToCase.put(p.Id, p);
                }
                // update parent if this is first child case modified that is not the AD Account child case or if all child cases are
                // closed and user is closing this case
                for (Case nv : newValues)
                {
                    if (nv.RecordTypeId == Schema.SObjectType.Case.RecordTypeInfosByName.get(ITSMSConstants.CASE_RECORDTYPE).RecordTypeId && nv.ParentId != null)
                    {
                        if (nv.Status == ITSMSConstants.CASE_STATUS_CLOSE && parentIdToCase.get(nv.ParentId).Status != ITSMSConstants.CASE_STATUS_CLOSE)
                        {
                            parentCheckClose.add(nv.ParentId);
                        } else
                        {
                            // if this is not a 'new hire active directory case' and the current status is not pre-submit status or already 'in progress'
                            if (nv.ServiceRequestType__c != ITSMSConstants.NEWHIRE_SRVREQTYPE_ACTIVEDIRECTORY && parentIdToCase.get(nv.ParentId).Status != ITSMSConstants.CASE_STATUS_PRESUBMIT && parentIdToCase.get(nv.ParentId).Status != ITSMSConstants.CASE_STATUS_INPROGRESS) 
                            {
                                //  set the status on the parent case to 'in progress'
                                parentIdToCase.get(nv.ParentId).Status = ITSMSConstants.CASE_STATUS_INPROGRESS;
                                updtParentCases.add(parentIdToCase.get(nv.ParentId));
                            }
                        }
                    }
                }
    
                // check for parent cases to close
                if (parentCheckClose.size() > 0)
                {
                    list<AggregateResult> parentChildOpen = [SELECT count(Id) openCount, ParentId FROM Case
                                                                WHERE ParentId = :parentCheckClose
                                                                AND Status != :ITSMSConstants.CASE_STATUS_CLOSE
                                                                GROUP BY ParentId];
                    for (AggregateResult pc:parentChildOpen)
                    {
                        parentToOpenChild.put((Id) pc.get('ParentId'), (integer) pc.get('openCount'));
                    }
                    for (Id pcc:parentCheckClose)
                    {
                        //  no open child cases were found for the parent
                        if (parentToOpenChild.get(pcc) == null)
                        {
                            // set status of parent to Closed
                            parentIdToCase.get(pcc).Status = ITSMSConstants.CASE_STATUS_CLOSE;
                            updtParentCases.add(parentIdToCase.get(pcc));
                        }
                    }
                }
                if (updtParentCases.size() > 0)
                    update updtParentCases;
            }
        }
    }

}