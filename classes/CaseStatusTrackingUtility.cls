/*****************************************************************
Name          : CaseStatusTrackingUtility
Created By    : Anand Sanjeev
Company Name  : Slalom
Created Date  : October 2015
Modified Date : Oct 16 2015, Added code for case 00334926 to check for closed ITSMS cases
Purpose		  : class for handling status changes in case
******************************************************************/
public class CaseStatusTrackingUtility {
    
    public static String RESOLVED = 'Resolved';    
    public static String CANCELLED = 'Cancelled';  
    
    Public static String MASTER_CLK_STAT_TO_IGNORE = 'StatusToIgnoreForMasterClock';
    
    Public static String DELIMITER = ';';
    
    Public static String ITSMS_RT_NAME = 'ITSMS_RT_NAME';
    Public static String OPEN_TASKS_ERROR = 'You cannot close a case when there are open tasks';
    
    //Iterate through a list of cases, identify cases with status change and process them.
    public static void handleCaseStatusChange(List<Case> newCaseList, Map<Id, Case> oldMap)
    {
       List<Case> listOfCasesWithStatusChange = new  List<Case>();
       //Case 00334926 - code for handling closed cases
       Map<Id,Case> mapOfClosedCases = new Map<Id,Case>();
       Map<String,CaseStatus> mapOfStatusToCaseStatus = new Map<String,CaseStatus>(); 
       
       for(Case cCase : newCaseList)
       {
         //Check if status has changed            
         if( Trigger.isInsert || cCase.status != oldMap.get(cCase.id).status)
         {             
             //This update was moved from the trigger to handler class
             cCase.CaseStatusLastModifiedDate__c = system.now();  
             updateStatusSpecificTrackingFields(cCase);
             //Only for updates
             if(cCase.id != null)
             {    
               listOfCasesWithStatusChange.add(cCase);  
               //Check if case is closed                
               if(cCase.isClosed)
               mapOfClosedCases.put(cCase.id, cCase);    
             }
         } 
       }
        
        if(!mapOfClosedCases.isEmpty())
         handleClosedCases(mapOfClosedCases);  
    
        if(!listOfCasesWithStatusChange.isEmpty())
         updateMasterClock(listOfCasesWithStatusChange);
    }
    
    //Case 00334926 - method for handling closed cases
    public static void handleClosedCases(Map<id, Case> mapOfClosedCases)
    {  
        if(!mapOfClosedCases.isEmpty())
        {    
         
            //Get the name for ITSMS record type stored in a custom setting
            CaseKeyValueStore__c itsmsRT = CaseKeyValueStore__c.getInstance(ITSMS_RT_NAME);
           
            //Check if there are open tasks for the closed cases
            for(Task t: [select id, whatId from Task where whatId IN: mapOfClosedCases.keySet() and isClosed = false])
            {   
                if(itsmsRT != null && itsmsRT.value__c != null)
                {
                    //The error should be thrown only for ITSMS Cases
                	if(mapOfClosedCases.get(t.whatId).recordTypeId == Schema.SObjectType.Case.RecordTypeInfosByName.get(itsmsRT.value__c).RecordTypeId)
                	mapOfClosedCases.get(t.whatId).addError(OPEN_TASKS_ERROR);            
                }
            }
        } 
       
    }
    
    public static void updateMasterClock(List<Case> caseList)
    {       
        Set<Id> setOfCaseIds = new Set<Id>();
        List<String> listOfStatusToAvoid = new List<String>();
        //Get the values for the status that should not be used in the master clock calculation
        CarlsbadNOCKeyValueStore__c cs  = CarlsbadNOCKeyValueStore__c.getInstance(MASTER_CLK_STAT_TO_IGNORE);
        //The list is stored in a semi-colon separated format. Split it.
        if(cs!=null && cs.Value__c !=null)
            listOfStatusToAvoid.addAll(cs.Value__c.split(DELIMITER));
        
        for(Case cCase: caseList)
        {
            setOfCaseIds.add(cCase.id);
        }
        //Query for all the status detail records which does not belong to a status to be ignored. Form a map with case id as the key.
        Map<id, List<StatusDetail__c>> mapOfCaseToStatusDetail = new Map<id, List<StatusDetail__c>> ();
        for(StatusDetail__c statDet: [Select id,TotalTimeInHrs__c,LastModifiedDate,Case__c,ObjectType__c,Status__c,EntryTime__c,ExitTime__c
                                      from StatusDetail__c
                                      where Case__c IN :setOfCaseIds AND Status__c NOT IN :listOfStatusToAvoid])
        {
            if(mapOfCaseToStatusDetail.containsKey(statDet.Case__c))
               mapOfCaseToStatusDetail.get(statDet.Case__c).add(statDet);
            else
               {
                   List<StatusDetail__c> tempList = new List<StatusDetail__c>();  
                   tempList.add(statDet);
                   mapOfCaseToStatusDetail.put(statDet.Case__c,tempList);
               }
        }
        //Iterate through the cases, get the list of status details for that case. Iterate through the status detail records
        //and calculate the total time by adding time from all of these records.
        for(Case cCase: caseList)
        {
          if(mapOfCaseToStatusDetail.containsKey(cCase.id))
          {    
            Decimal timeInPreviousStatus = 0;
            for(StatusDetail__c statDet: mapOfCaseToStatusDetail.get(cCase.id))
            {
                timeInPreviousStatus = timeInPreviousStatus + statDet.TotalTimeInHrs__c;
            }
            cCase.TotalTimeInAllPreviousStatus__c = timeInPreviousStatus;
          }
        }
        
    }
    
    
    //Check if the case is being updated to one of the fields being tracked 
    //If yes, update the date time and set the user making the change
    public static void updateStatusSpecificTrackingFields(Case cCase)
    {
        String newStatus = cCase.status;
             //If the new status is resolved
             if(newStatus == RESOLVED)
             {
                 //If the case was not already set to resolved earlier
                 if(cCase.FirstResolution__c == null)
                 {
                 	cCase.FirstResolution__c = System.now();
                 	cCase.FirstResolutionSetBy__c =  UserInfo.getUserId();
                 }
                 //Whenever the case gets set to resolved set the following fields
                 cCase.LastResolution__c= System.now();
                 cCase.LastResolutionSetBy__c=  UserInfo.getUserId();
             }
             
             //If the new status is closed
             if(cCase.IsClosed)
             {
                 //If the case was not already set to closed earlier
                 if(cCase.FirstClosure__c == null)
                 {
                 	cCase.FirstClosure__c = System.now();
                 	cCase.FirstClosureSetBy__c =  UserInfo.getUserId();
                 }
                 //Whenever the case gets set to closed set the following fields
                 cCase.LastClosure__c= System.now();
                 cCase.LastClosureSetBy__c=  UserInfo.getUserId();
             }
             
             //If the new status is cancelled
             if(newStatus == CANCELLED)
             {
                 //If the case was not already set to cancelled earlier
                 if(cCase.FirstCancelled__c == null)
                 {
                 	cCase.FirstCancelled__c = System.now();
                 	cCase.FirstCancelledSetBy__c =  UserInfo.getUserId();
                 }                
             }

    }
}