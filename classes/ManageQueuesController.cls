/*****************************************************************
Name          : ManageQueuesController
Created By    : Anand Sanjeev
Company Name  : ViaSat
Project       : Case 00344273 - Custom Visualforce report, page with user queue assignments
Created Date  : October, 2015
Modified Date : div
******************************************************************/

public class ManageQueuesController {
    
    public Static String TYPE_ROLE {get{return 'Role';} set;}
    public Static String TYPE_QUEUE {get{return 'Queue';} set;}
    
    //Constants which will be used to get the data from Custom Setting
    public Static String ITSMS_QUEUE_REPORT_PROFILES = 'ITSMS_QUEUE_REPORT_PROFILES';
    public Static String ITSMS_QUEUE_REPORT_FILE_NAME = 'ITSMS_QUEUE_REPORT_FILE_NAME';
    
    public Static String CONTENT_TYPE = 'application/vnd.ms-excel#';    
    public Static String DEFAULT_FILE_NAME = 'Report.xls';
    public Static String DELIMITER = ';';
    
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
    //The grouping user has selected
    public String groupingTypeSelected{get;set;}
    //This is set when the user clicks on the report to excel
    public String contentType{get;set;}
        
    public Map<id,Profile> mapOfProfiles{get;set;}
    public Map<id, User> mapOfUsers{get;set;}
    public Map<Id, Group> mapOfQueues{get;set;}
    public Map<Id, UserRole> mapOfRoles{get;set;}
    
    public Map<Id, List<User>> mapOfQueueIdToUsers{get;set;}
    public Map<Id, String> mapOfUserIdToQueueNames{get;set;}
    public Map<id, List<User>> mapOfRoleIdToMembers {get;set;}
    
    public List<Id> listOfOrderedQueueIds{get;set;}
    public List<Id> listOfOrderedRoleIds{get;set;}
    
    public boolean isGroupedByRole{get;set;}
    public boolean isGroupedByQueue{get;set;}
    
    public ManageQueuesController()
    {
        //Get the profile of the users who we should build the report on 
        CaseKeyValueStore__c profiles = CaseKeyValueStore__c.getInstance(ITSMS_QUEUE_REPORT_PROFILES);
        List<String> profileNames = new List<String>();
        if(profiles != null && profiles.value__c != null)
        {
            profileNames.addAll(profiles.value__c.split(DELIMITER));
        }
        //Proceed only if the custom setting has the profile names stored
        if(!profileNames.isEmpty())
        {
            //Query for the profile to get the profile Id
            mapOfProfiles = new Map<id,Profile>([select id from Profile where name IN: profileNames]);
            //Use the profile Id to query the users
            mapOfUsers = new Map<id, User>([select id, name, profile.Name, UserRole.Name, ManagerId, Manager.Name from User where profileId IN: mapOfProfiles.keySet() and isActive = true order by name ]);        
            
            //Initialize all the variables
            mapOfQueueIdToUsers = new Map<Id, List<User>>();
            mapOfUserIdToQueueNames = new Map<Id, String>();
            mapOfRoleIdToMembers = new Map<id, List<User>>();
            
            listOfOrderedQueueIds = new List<Id>();
            listOfOrderedRoleIds = new List<Id>();
            mapOfQueues = new Map<Id, Group>();
            mapOfRoles = new Map<Id, UserRole>();
            
            //By default the grouping is by queue.
            groupingTypeSelected = TYPE_QUEUE; 
            
            //Query all the queue members and form a map with queue id as the key and list of users as the value
            populateQueueToUserMap();
            //Query all the role members and form a map with queue id as the key and list of users as the value
            populateRoleToMemberMap();
			//We just have the queue and role ids - we need to query and get details like queue name, role name 
			//and also order the data in ascending order of names.            
            populateQueueAndRoleData();
            //form a map with user id as the key and all the queues they belong in a semi-colon separated format as the value.
            populateUserToQueueMap();
            
            setGrouping();
        }
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
    

    //form a map with queue id as the key and list of users as the value
    public void populateQueueToUserMap()
    {
        Set<Id> setOfRegularGroupIds = new Set<Id>();
        
        //Get all the queues the users are part of
        for(GroupMember m : [Select Id, GroupId, UserOrGroupId From GroupMember Where UserOrGroupId in :mapOfUsers.keySet() and Group.type = 'Queue'])
        {
            if(mapOfQueueIdToUsers.containsKey(m.GroupId))
            {
                mapOfQueueIdToUsers.get(m.GroupId).add(mapOfUsers.get(m.UserOrGroupId));
            }
            //iF this is the first time the members are being added for the queue
            else
            {
                List<User> uList = new List<User>();
                uList.add(mapOfUsers.get(m.UserOrGroupId)); 
                mapOfQueueIdToUsers.put(m.GroupId, uList);
            }            
        }
        
        Map<Id, List<User>> mapOfGroupIdToListOfUsers = new Map<Id, List<User>>();
        //Get all the regular groups the users are part of 
        for(GroupMember m : [Select Id, GroupId, UserOrGroupId From GroupMember Where UserOrGroupId in :mapOfUsers.keySet() and Group.type = 'Regular'])
        {
            if(mapOfGroupIdToListOfUsers.containsKey(m.GroupId))
            {
               mapOfGroupIdToListOfUsers.get(m.GroupId).add(mapOfUsers.get(m.UserOrGroupId));
            }  
            else
            {
                List<User> uList = new List<User>();
                uList.add(mapOfUsers.get(m.UserOrGroupId));
                mapOfGroupIdToListOfUsers.put(m.GroupId, uList);
            }            
        }
        
        Map<Id, List<Id>> mapOfQueueIdToListOfGroups = new Map<Id, List<Id>>();
        //Get all the queues the groups are part of
        for(GroupMember m : [Select Id, GroupId, UserOrGroupId From GroupMember Where UserOrGroupId in :mapOfGroupIdToListOfUsers.keySet() and Group.type = 'Queue'])
        {
            if(mapOfQueueIdToListOfGroups.containsKey(m.GroupId))
            {    
                mapOfQueueIdToListOfGroups.get(m.GroupId).add(m.UserOrGroupId);
            }
            else
            { 
                List<Id> grpList = new List<Id>();
                grpList.add(m.UserOrGroupId);
                mapOfQueueIdToListOfGroups.put(m.GroupId, grpList);
            }
        }
        
        //Iterate through the queues which have groups as members 
        for(Id qId: mapOfQueueIdToListOfGroups.keySet())
        {
            //Get the groups which belongs to the queue
            for(Id grpId: mapOfQueueIdToListOfGroups.get(qId))
            {
                //Check if the groups have any members
                if(mapOfGroupIdToListOfUsers.containsKey(grpId))
                {
                    //See if the queue already have members added
                    //If yes, then we just need to add to the list
                    if(mapOfQueueIdToUsers.containsKey(qId))
                    {
                        mapOfQueueIdToUsers.get(qId).addAll(mapOfGroupIdToListOfUsers.get(grpId));
                    }
                    //iF this is the first time the members are being added for the queue
                    else
                    {
                        List<User> uList = new List<User>();
                        uList.addAll(mapOfGroupIdToListOfUsers.get(grpId));
                        mapOfQueueIdToUsers.put(qId, uList);
                    }
                    
                }
                
            }
        }
    }
    
    //form a map with role id as the key and list of users as the value
    public void populateRoleToMemberMap()
    {
     for(Id userId : mapOfUsers.keySet())
        {   
            Id roleId = mapOfUsers.get(userId).userRoleId;
            User u =mapOfUsers.get(userId);
            //If this role was already added to the map
            if(mapOfRoleIdToMembers.containsKey(roleId))
            {               
             mapOfRoleIdToMembers.get(roleId).add(u);               
            }
            //this roles is being processed for the first time
            else
            { 
             List<User> uList = new List<User>();               
             uList.add(u);
             mapOfRoleIdToMembers.put(roleId, uList);              
            }
        }  
   }
    
    
   //query and get details like queue name, role name and also order the data in ascending order of names
    public void populateQueueAndRoleData()
    {     
        //Query and get the queue information - orderd by name
        for(Group q: [select id, name from Group where Type = 'Queue' and Id IN: mapOfQueueIdToUsers.keySet() order by name ])
        {
            listOfOrderedQueueIds.add(q.id);
            mapOfQueues.put(q.id, q);
        }
        //Query and get the role information - orderd by name
        for(UserRole r: [select id, name from UserRole where Id IN: mapOfRoleIdToMembers.keySet() order by name ])
        {
            listOfOrderedRoleIds.add(r.id);
            mapOfRoles.put(r.id, r);
        }            
    }
    
    //form a map with user id as the key and all the queues they belong in a semi-colon separated format as the value.
    public void populateUserToQueueMap()
    {   
      for(Id qId: mapOfQueueIdToUsers.keySet())
      {
          for(User u : mapOfQueueIdToUsers.get(qId))
          {
            //This user was already added to the map
            if(mapOfUserIdToQueueNames.containsKey(u.id))
            {
                //the queue names are added in a semi colon separated formate
                mapOfUserIdToQueueNames.put(u.id, mapOfUserIdToQueueNames.get(u.id) + DELIMITER + ' ' + mapOfQueues.get(qId).name);
            }
            //User is being added to the map the first time
            else
            {
                mapOfUserIdToQueueNames.put(u.id, mapOfQueues.get(qId).name);
            }
          }
      }
       
        //for users which do not belong to any queue, put an empty string as the value
        for(Id userId : mapOfUsers.keySet())
        {  
         if(!mapOfUserIdToQueueNames.containsKey(userId))
                mapOfUserIdToQueueNames.put(userId, '');
        }    
    }
   
}