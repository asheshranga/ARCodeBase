/*****************************************************************
Name          : CaseOwnerHistoryUtility
Created By    : Anand Sanjeev
Company Name  : Slalom
Created Date  : October 2015
Modified Date : 
Purpose		  : Utility class to handle case owner change
******************************************************************/
public class CaseOwnerHistoryUtility {
    
   public static String USER_ID_PREFIX = '005';
   public static String QUEUE_ID_PREFIX = '00G';
   
   //Iterate through the cases, identify cases with owner change and process them. 
   public static void handleCaseOwnerChange(Map<Id, Case> newMap, Map<Id, Case> oldMap)
    {        
        List<case> listOfCasesWithOwnerChange = new List<case> ();
        //List<Id> listOfCaseOwnerIds = new List<Id> ();
        for(Id cId : newMap.keySet())
        {
            //Collect the ids of cases for which the owner changed
            if(oldMap != null){
            	//Check if ownerId has changed            
            	if(newMap.get(cId).ownerId != oldMap.get(cId).ownerId)
            	{
                	listOfCasesWithOwnerChange.add(newMap.get(cId));
            	}
            }
            else
                listOfCasesWithOwnerChange.add(newMap.get(cId));
        }   
        
        if(!listOfCasesWithOwnerChange.isEmpty())
        {        
            CaseOwnerHistoryUtility.updatePreviousOwnerHistoryRecord(listOfCasesWithOwnerChange);
        	CaseOwnerHistoryUtility.createOwnerHistoryRecord(listOfCasesWithOwnerChange);        	 
        }
    } 
   //For a list of cases which gets passed, create case owner history records
   public static void createOwnerHistoryRecord(List<case> listOfCasesWithOwnerChange)
   {
       
       List<Case_Owner_History__c> listOfCaseOwnerHistoryRecs = new List<Case_Owner_History__c>();
       List<Id> listOfQueueOwnerIds = new List<Id>();
       List<Id> listOfUserOwnerIds = new List<Id>();      
       
        for(Case cCase: listOfCasesWithOwnerChange)
        {
             	//The case was assigned to a user
                if((cCase.OwnerId+'').startsWith(USER_ID_PREFIX))
                listOfUserOwnerIds.add(cCase.OwnerId);	
                //The case was assigned to a queue    
                else if((cCase.OwnerId+'').startsWith(QUEUE_ID_PREFIX))
                listOfQueueOwnerIds.add(cCase.OwnerId); 
        }
        
        Map<Id,User> userMap = new Map<Id,User>();
        if(!listOfUserOwnerIds.isEmpty())
        {
            userMap = new Map<Id,User>([select id, Name, Tier__c from User where id IN :listOfUserOwnerIds]);
        }
        
        Map<Id,Group> queueMap= new Map<Id,Group>();
		if(!listOfQueueOwnerIds.isEmpty())
        {
            queueMap = new Map<Id,Group>([select id, Name, developerName from Group where id IN :listOfQueueOwnerIds]);
        }
        
        for(Case cCase: listOfCasesWithOwnerChange)
        {
            Case_Owner_History__c coh = new Case_Owner_History__c();
            coh.Case__c = cCase.id;
            coh.EntryTime__c = System.now();
            coh.OwnerId__c = cCase.ownerId;
            
            
            if(userMap.containsKey(coh.OwnerId__c))
            {   
                coh.OwnerName__c = userMap.get(coh.OwnerId__c).Name;
            	coh.Tier__c = userMap.get(coh.OwnerId__c).Tier__c;
            }
            else if(queueMap.containsKey(coh.OwnerId__c))
            {
                coh.OwnerName__c = queueMap.get(coh.OwnerId__c).Name;
                if(CaseQueueTierMap__c.getInstance(queueMap.get(coh.OwnerId__c).developerName) != null)
                {
                    coh.Tier__c = CaseQueueTierMap__c.getInstance(queueMap.get(coh.OwnerId__c).developerName).Tier__c;
                }
            } 
            listOfCaseOwnerHistoryRecs.add(coh);
        }
       
       insert listOfCaseOwnerHistoryRecs;
   }
    //For a list of cases which gets passed, get the previously inserted case owner history record and update the exit time to now.
    public static void updatePreviousOwnerHistoryRecord(List<case> listOfCasesWithOwnerChange)
    {
        Set<Id> setOfCaseIdsWithOwnerChange = new Set<Id> ();
        
        for(Case c :listOfCasesWithOwnerChange)
        {
            setOfCaseIdsWithOwnerChange.add(c.id);
        }
        
        List<Case_Owner_History__c> previousCaseOwnerHistoryList = new List<Case_Owner_History__c>();
        previousCaseOwnerHistoryList = [select id, Exittime__c from Case_Owner_History__c where case__c IN: setOfCaseIdsWithOwnerChange and Exittime__c = null];
        
        for(Case_Owner_History__c coh : previousCaseOwnerHistoryList) 
        {
            coh.Exittime__c = System.now();
        }
        
        if(!previousCaseOwnerHistoryList.isEmpty())
        update previousCaseOwnerHistoryList; 
    }

}