/*
 * Class ITSMSCaseDelegateUpdate
 * 
 * @version 1.0
 * @author  Dianna Guilinger - Slalom  
 * 
 *  ITSMS check for change to delegate 
 */
public class ITSMSCaseDelegateUpdate {
    public static void checkCaseDelegateChange (List<User> newValues, Map<Id, User> oldMap, string triggerType) 
    {
      // avoid recursion
        
        if (ITSMSUtilityClass.delegateUpdateRequired())
        {
            set <Id> userIds = new set<Id> ();
            // get all users where delegate changed
            for (User nv : newValues)
            {
                if ((triggerType == 'Insert' && nv.Delegate__c != null) || (triggerType == 'Update' && nv.Delegate__c != oldMap.get(nv.Id).Delegate__c) )
                    userIds.add(nv.Id);
            }
            // get cases where user is requestor/requested on behalf of or creator 
            list<Case> cases = [Select Id, Requestor__c, RequestingForUser__c, CreatedById, RecordTypeId from Case where IsClosed = False and (Requestor__c = :userIds or RequestingForUser__c = :userIds or CreatedById = :userIds)  ];
            set<Id> caseIds = new set<Id> ();
            for (Case c:cases)
            {
                caseIds.add(c.Id);
            }
            // get current team members for these cases
            list<CaseTeamMember> currentTeams = ITSMSUtilityClass.getCaseTeam(caseIds);
            // remove all current team members
            if (currentTeams.size() > 0 )
                ITSMSUtilityClass.deleteCaseTeam(currentTeams);
            // recreate case teams
            if (cases.size() > 0 )
                ITSMSCaseTeamUpdate.setCaseTeam(caseIds); 
        }
    }
}