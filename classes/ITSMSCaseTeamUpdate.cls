/**************************************************************************************************************
Name         : ITSMSCaseTeamUpdate 
Created By   : Dianna Guilinger - Slalom 
Description  :  Requestor, Requested on Behalf of and Delegates are added to Case Team to allow visibility of  
             :  ITSMS Cases. Executes: after insert, after update
***************************************************************************************************************/
public class ITSMSCaseTeamUpdate {

    public static map<Id, list<Id>> NewCaseTeamMembersMap = new map <Id, list<Id>> ();
    public static list<CaseTeamMember> NewCaseTeamMembers = new list<CaseTeamMember> ();

    public static void setCaseTeam (Set<Id> requestorChgCases) 
    { 
        list<Case> chgdCases = [Select Id, Requestor__c, Requestor__r.Delegate__c, RequestingForUser__c, RequestingForUser__r.Delegate__c from Case where Id =:requestorChgCases];
        set <Id> caseTeamUserIds = new set<Id> ();
        // get all creator, requestor and requested on behalf of user ids
        for (Case c : chgdCases)
        {
			if (c.Requestor__c != null)
            	caseTeamUserIds.add(c.Requestor__c);
            if (c.RequestingForUser__c != null)
            	caseTeamUserIds.add(c.RequestingForUser__c);
        }
        // get delegates for requestor/requested on behalf of users
        list<User> caseTeamUsers = [Select Id, Delegate__c from User where id = :caseTeamUserIds ];
        map<Id, User> userDelegates = new map<Id, User> ();
            for (User d:caseTeamUsers)
            {
                userDelegates.put(d.Id, d);
            }
       	// get current team members 
       	map<Id, list<CaseTeamMember>> currentTeams = ITSMSUtilityClass.getCaseTeamMap(requestorChgCases);
       	// get case team roles
       	map<String, CaseTeamRole> caseTeamRoles = ITSMSUtilityClass.getCaseTeamRoles();
       	for (Case c : chgdCases)
       	{
        	// requestor should be on case team
            if (c.Requestor__c != null && !ITSMSUtilityClass.userOnCaseTeam(c.id, c.Requestor__c, currentTeams) && isNewTeamMember(c.Id, c.Requestor__c) )
            	addNewTeamMember(c.Id, c.Requestor__c, caseTeamRoles.get(ITSMSConstants.CASE_TEAM_REQUESTOR).Id);    
            
            // delegate for requestor should be on case team
            if (c.Requestor__r.Delegate__c != null && !ITSMSUtilityClass.userOnCaseTeam(c.id, c.Requestor__r.Delegate__c, currentTeams) && isNewTeamMember(c.Id, c.Requestor__r.Delegate__c) )
            	addNewTeamMember(c.Id, c.Requestor__r.Delegate__c, caseTeamRoles.get(ITSMSConstants.CASE_TEAM_DELEGATE).Id);    
            
            // requested on behalf of should be on case team
            if (c.RequestingForUser__c != null && !ITSMSUtilityClass.userOnCaseTeam(c.id, c.RequestingForUser__c, currentTeams) && isNewTeamMember(c.Id, c.RequestingForUser__c) )
            	addNewTeamMember(c.Id, c.RequestingForUser__c, caseTeamRoles.get(ITSMSConstants.CASE_TEAM_REQUESTEDFOR).Id);    
            
            // add delegate for requested on behalf of to team
            if (c.RequestingForUser__r.Delegate__c != null && !ITSMSUtilityClass.userOnCaseTeam(c.id, c.RequestingForUser__r.Delegate__c, currentTeams) && isNewTeamMember(c.Id, c.RequestingForUser__r.Delegate__c) ) 
            	addNewTeamMember(c.Id, c.RequestingForUser__r.Delegate__c, caseTeamRoles.get(ITSMSConstants.CASE_TEAM_DELEGATE).Id);    
        }
        if (NewCaseTeamMembers.size() > 0)
        	ITSMSUtilityClass.insertCaseTeam(NewCaseTeamMembers);
    }
    //------------------------------------------------------------------------------------
    // check if user is already in list to add
    //------------------------------------------------------------------------------------
    static public boolean isNewTeamMember (Id caseId, Id teamMember) {
        boolean isNewTeamMember = true;
        if (NewCaseTeamMembersMap.containsKey(caseId) )
        {
            for (Id i: NewCaseTeamMembersMap.get(caseId))
            {
                if (teamMember == i) 
                    isNewTeamMember = false;
            }
        }
        return isNewTeamMember;
    }
    //------------------------------------------------------------------------------------
    // add user to list
    //------------------------------------------------------------------------------------
    static public void addNewTeamMember (Id caseId, Id teamMember, Id teamMemberRole){
        CaseTeamMember ctm = new CaseTeamMember ();
        ctm.ParentId = caseId;
        ctm.MemberId = teamMember;
        ctm.TeamRoleId = teamMemberRole;
        NewCaseTeamMembers.add(ctm);
        
        if (NewCaseTeamMembersMap.containsKey(caseId) )
        {
            NewCaseTeamMembersMap.get(caseId).add(teamMember);
        } else {
            list <Id> teamMembers = new list <Id> ();
            teamMembers.add(teamMember);
            NewCaseTeamMembersMap.put(caseId,teamMembers);
        }
    }

}