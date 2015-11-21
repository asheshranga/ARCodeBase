public class QueueRoleReportController {    
    
    public static List<UserRole> listOfUserRoles{get;set;}
    public static List<GroupMember> listOfGroupMembers{get;set;}
    public Map<Id, Set<Id>> mapOfUserRoleToChildren{get;set;}
    public Map<Id, Set<Id>> mapOfGroupToMembers{get;set;}
    public Map<Id, UserRole> mapOfUserRoles{get;set;}
    public Map<Id, GroupMember> mapOfGroupMember{get;set;}
    public Map<Id, Group> mapOfQueues{get;set;}
    public Map<Id, Group> mapOfAllGroups{get;set;}
    public Map<Id, User> mapOfAllUsers{get;set;}
    public Map<Id, List<Id>> mapOfRoleIdToUsers{get;set;}
    public Map<Id, String> mapOfUserIdToQueues{get;set;}
    
    
    public Static String TYPE_ROLE {get{return 'Role';} set;}
    public Static String TYPE_QUEUE {get{return 'Queue';} set;}

    public Static String REGULAR = 'Regular';
    public Static String ROLE = 'Role';
    public Static String ROLEANDSUB = 'RoleAndSubordinatesInternal';
    
    public boolean isGroupedByRole{get;set;}
    public boolean isGroupedByQueue{get;set;}
    
    //Constants which will be used to get the data from Custom Setting
    public Static String ITSMS_QUEUE_REPORT_PROFILES = 'ITSMS_QUEUE_REPORT_PROFILES';
    public Static String ITSMS_QUEUE_REPORT_FILE_NAME = 'ITSMS_QUEUE_REPORT_FILE_NAME';
    
    public Static String CONTENT_TYPE = 'application/vnd.ms-excel#';    
    public Static String DEFAULT_FILE_NAME = 'Report.xls';
    public Static String DELIMITER = ';';
    //The grouping user has selected
    public String groupingTypeSelected{get;set;}
    //This is set when the user clicks on the report to excel
    public String contentType{get;set;}    
    
    public String roleSearch{get;set;}
    public String queueSearch{get;set;}
    
    //The list shown to the user as options to group the data 
    public List<SelectOption> groupingType{
        get{
            List<SelectOption> so = new List<SelectOption>(); 
            so.add(new SelectOption(TYPE_ROLE, TYPE_ROLE));
            so.add(new SelectOption(TYPE_QUEUE, TYPE_QUEUE));
            return so;
        } 
        set;
    }
    
    public QueueRoleReportController()
    {   
        isGroupedByQueue = true;
        isGroupedByRole = false;
        populateUsers();
        populateRoleToUserMapping();
        
        mapOfUserRoles =  new  Map<Id, UserRole>([select Id, Name, ParentRoleId from UserRole]);
        mapOfGroupMember =  new  Map<Id, GroupMember>([Select Id, GroupId, Group.Type, Group.relatedId, UserOrGroupId From GroupMember]);
        mapOfAllGroups = new  Map<Id, Group>([Select Id, name, type, RelatedId From Group]);        
    }
    
    public void searchByQueue()
    {      
        String searchTxt = '%' + queueSearch ;
        mapOfQueues =  new  Map<Id, Group>([Select Id, name From Group where group.type ='Queue' and name like :searchTxt]);
        listOfUserRoles = new List<UserRole>();
        listOfUserRoles.addAll(mapOfUserRoles.values());
        
        listOfGroupMembers = new List<GroupMember>();
        listOfGroupMembers.addAll(mapOfGroupMember.values());
        mapOfUserRoleToChildren = new Map<Id, Set<Id>>();
        
        for(Id roleId : mapOfUserRoles.keySet())
        {
            mapOfUserRoleToChildren.put(roleId, getSubordinates(roleId));
        }
        
        mapOfGroupToMembers = new Map<Id, Set<Id>>();
        
        for(Id grpId : mapOfQueues.keySet())
        {
            mapOfGroupToMembers.put(grpId, getGroupMembers(grpId));
        }
        
        populateUserToQueueMapping();
    }
    
     //This method is called when the user change the grouping option 
    public pageReference setGrouping()
    {
        isGroupedByRole = false;
        isGroupedByQueue = false;
        
        //Check if the grouping selected is role
        if(groupingTypeSelected == TYPE_ROLE)
        isGroupedByRole = true;
        //if not role, then it has to be queue
        else 
        isGroupedByQueue = true; 
        return null;
    }
     //This method is called when the user clicks on the export to excel button
    public pageReference exportToExcel()
    {        
        //Get the file name stored in the custom setting
        CaseKeyValueStore__c fName = CaseKeyValueStore__c.getInstance(ITSMS_QUEUE_REPORT_FILE_NAME);
        
        if(fName != null && fName.value__c != null)
           contentType = CONTENT_TYPE + fName.value__c;
        //If file name is null, use the default name
        else
           contentType = CONTENT_TYPE + DEFAULT_FILE_NAME;
        
        return null;
    }
    
    public void populateUserToQueueMapping()
    {
        mapOfUserIdToQueues =  new Map<Id, String>();
        
        for( Id groupId : mapOfGroupToMembers.keySet())
        {
            for( Id userId : mapOfGroupToMembers.get(groupId))
            {                
            	String queue = mapOfUserIdToQueues.containsKey(userId) ? (mapOfUserIdToQueues.get(userId) + ',') : '';                
                queue = queue + mapOfAllGroups.get(groupId).Name;
                mapOfUserIdToQueues.put(userId, queue);
            }
        }
        
        for(Id userId : mapOfAllUsers.keySet())
        {
            if(!mapOfUserIdToQueues.containsKey(userId))
            {
                mapOfUserIdToQueues.put(userId, '');
            }
        }
        
    }
    
    public void populateUsers()
    {
        mapOfAllUsers = new Map<Id, User>([select id, name, managerId, manager.Name, UserRole.Name, UserRoleId from User where isActive = true]);
    }
    
    public void populateRoleToUserMapping()
    {
        mapOfRoleIdToUsers = new Map<Id, List<Id>>();
        List<Id> userList;
        for(User u :mapOfAllUsers.values())
        {
            if(u.UserRoleId != null)
            {
            	userList = mapOfRoleIdToUsers.containsKey(u.UserRoleId) ? mapOfRoleIdToUsers.get(u.UserRoleId) : new List<Id>();
            	userList.add(u.id);
            	mapOfRoleIdToUsers.put(u.UserRoleId, userList);
            }
        }
    }
    
    public set<Id> getSubordinates(Id roleId) {
        Set<Id> subordinateUsers = new set<Id>();
        map<Id, set<Id>> parentAndChildren = new map<Id, set<Id>>();
        set<Id> children;
        for(UserRole ur : listOfUserRoles) {
            children = parentAndChildren.containsKey(ur.ParentRoleId) ? parentAndChildren.get(ur.ParentRoleId) : new set<Id>();
            children.add(ur.id);
            parentAndChildren.put(ur.ParentRoleId, children);
        }
        
        for(Id rId : getSubordinateRoles(roleId, parentAndChildren))
        {
            if(mapOfRoleIdToUsers.containsKey(rId))
                subordinateUsers.addAll(mapOfRoleIdToUsers.get(rId));
        }
         return subordinateUsers;        
    }
    
    public set<Id> getSubordinateRoles(Id roleId, map<Id, set<Id>> parentAndChildren) {
        
        set<Id> subordinateRoles = new set<Id>();
        set<Id> remainingSubordinateRoles = new set<Id>();
        if(parentAndChildren.containsKey(roleId)) {
            subordinateRoles.addAll(parentAndChildren.get(roleId));
            for(Id subRole : subordinateRoles) {
                remainingSubordinateRoles.addAll(getSubordinateRoles(subRole, parentAndChildren));
            }
        } 
        subordinateRoles.addAll(remainingSubordinateRoles);
        
        return subordinateRoles;
        
    }
    
    public set<Id> getGroupMembers(Id groupId) {
        map<Id, set<GroupMember>> parentAndChildren = new map<Id, set<GroupMember>>();
        set<GroupMember> children;
        for(GroupMember gm : listOfGroupMembers) {
            children = parentAndChildren.containsKey(gm.GroupId) ? parentAndChildren.get(gm.GroupId) : new set<GroupMember>();
            children.add(gm);
            parentAndChildren.put(gm.GroupId, children);
        }
        return getGroupMembers(groupId, parentAndChildren);
    }
    
    public set<Id> getGroupMembers(Id groupId, map<Id, set<GroupMember>> parentAndChildren) {
        set<Id> childMembers = new set<Id>();
        set<Id> remainingChildMembers = new set<Id>();
        if(parentAndChildren.containsKey(groupId)) {
            //childMembers.addAll(parentAndChildren.get(groupId));
            for(GroupMember gm : parentAndChildren.get(groupId)) {
                
                System.debug('****************************************** Group Member : '  + gm.userOrGroupId );
                System.debug('****************************************** Group Member : '  + gm.userOrGroupId );
                
                //Group member is an user
                if(mapOfAllUsers.containsKey(gm.userOrGroupId))
                childMembers.add(gm.userOrGroupId);
                
                //If the member is a group, then get its members
                if(mapOfAllGroups.containsKey(gm.UserOrGroupId))
                {
                    Group memGrp = mapOfAllGroups.get(gm.UserOrGroupId);
                    System.debug('****************************************** Group Member is a Group : ' );
                    System.debug(memGrp);
                    
                    if(memGrp.type == REGULAR)
                        remainingChildMembers.addAll(getGroupMembers(gm.userOrGroupId, parentAndChildren));
                    
                    //if the group member is a role
                    else if(memGrp.type == ROLE)
                    {
                        System.debug('****************************************** Group Member is a Role : ' );
                        remainingChildMembers.addAll(mapOfRoleIdToUsers.get(mapOfAllGroups.get(gm.userOrGroupId).relatedId));
                    }
                    
                    //if the group member is a role
                    else if(memGrp.type == ROLEANDSUB)
                    {
                        System.debug('****************************************** Group Member is Role and Sub : ' );
                        remainingChildMembers.addAll(mapOfRoleIdToUsers.get(mapOfAllGroups.get(gm.userOrGroupId).relatedId));
                        
                        //check if subordinates to be added
                        if(mapOfUserRoleToChildren.containsKey(mapOfAllGroups.get(gm.userOrGroupId).relatedId))
                            remainingChildMembers.addAll(mapOfUserRoleToChildren.get(mapOfAllGroups.get(gm.userOrGroupId).relatedId));
                    }
                }
                
                
            }
        }
        
        childMembers.addAll(remainingChildMembers);
        return childMembers;
    }
    
}