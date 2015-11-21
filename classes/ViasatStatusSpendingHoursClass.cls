/*
Author: NTT Data
Project: Viasat NBNCo Customer Portal
Date: Oct 2013
Purpose: This is common class for the Trigger(ViaSatUpdateCaseStatusTime) functionality. 
         It has three different methods to update the Individual case status spending hours and Status entry time as well as exit time.
*/
global class ViasatStatusSpendingHoursClass
{
    //Oct,15 - Adding this to track the status changes happening in case of a workflow field update
    //Changes made to address the issue where user updates the status and in the same context a workflow updates the status again
    Public static Map<id, String> mapOfIdToStatus = new Map<id, String>();
    
    //Method for initial record to be inserted on StatusHistory and StatusDetail object 
    public static void insertStatusHistoryAndDetail(String objectType, Id objectId, String objectStatus, Datetime objectLastModifiedDate) 
    {
        List<StatusHistory__c> insertStatusHistory = new List<StatusHistory__c>();
        List<StatusDetail__c> insertStatusDetail = new List<StatusDetail__c>();
        //Status History's object Initial record has been inserted here.        
        StatusHistory__c objectStatusHistory = new StatusHistory__c();
        objectStatusHistory.Case__c = objectId;
        objectStatusHistory.Status__c = objectStatus;
        insertStatusHistory.add(objectStatusHistory);
        //Status Detail's object Initial record has been inserted here.  
        StatusDetail__c objectStatusDetail = new StatusDetail__c();
        objectStatusDetail.Case__c = objectId;          
        objectStatusDetail.ObjectType__c = objectType;
        objectStatusDetail.Status__c = objectStatus;
        objectStatusDetail.EntryTime__c = objectLastModifiedDate;
        insertStatusDetail.add(objectStatusDetail);

        if(insertStatusHistory.size()>0)//Checks for list is not empty
            insert insertStatusHistory;
        if(insertStatusDetail.size()>0)//Checks for list is not empty
            insert insertStatusDetail; 
    }
    //Method for individual case Status spending hours and Status entry time/Exit time updation
    public static StatusWrapper afterUpdateStatusHistoryAndDetail(String objectType, Map<Id, StatusHistory__c> StatusHistoryMap, Map<Id, StatusDetail__c> StatusDetailMap, Id objectId, String objectNewStatus, String objectOldStatus, Datetime objectNewLastmodifiedDate, Datetime objectOldCaseStatusLastModifiedDate) 
    {   
        //Oct,15 - Adding this to track the status changes happening in case of a workflow field update
        //Changes made to address the issue where user updates the status and in the same context a workflow updates the status again. 
        //Also avoid refiring of this logic unless there is a field update in the workflow        
        
        if(mapOfIdToStatus.containsKey(objectId))
            objectOldStatus = mapOfIdToStatus.get(objectId);
        
        //Prevent retriggering
        if(objectOldStatus == objectNewStatus)
            return null;
        
        List<StatusHistory__c> insertStatusHistory = new List<StatusHistory__c>();
        List<StatusDetail__c> insertStatusDetail = new List<StatusDetail__c>();   
        List<StatusHistory__c> updateStatusHistory = new List<StatusHistory__c>();
        List<StatusDetail__c> updateStatusDetail = new List<StatusDetail__c>();
        StatusWrapper dwrapper;
        //************Status History Functionalities (Individual Status spending hours updates)**********************************************
   
        Boolean existscheck = False;
        for(Id objSHmap :StatusHistoryMap.Keyset())
        {                  
            if(StatusHistoryMap.get(objSHmap).Case__c == objectId 
               && StatusHistoryMap.get(objSHmap).Status__c == objectOldStatus               
              )
            {                
                Decimal totalminutes;
                //If the trigger is being called again because of a status update in a workflow - then the case was in this status for 0 seconds.
                if(mapOfIdToStatus.containsKey(objectId))
                {
                    if(StatusHistoryMap.get(objSHmap).TotalDurationInSeconds__c != null)
                    totalminutes = StatusHistoryMap.get(objSHmap).TotalDurationInSeconds__c;
                    else
                    totalminutes = 0;    
                }
                else{    
                	if(StatusHistoryMap.get(objSHmap).TotalDurationInSeconds__c != null)
                    totalminutes = (StatusHistoryMap.get(objSHmap).TotalDurationInSeconds__c)+(ViasatUtilityClass.secondsBetweenTwoDateTimes(objectOldCaseStatusLastModifiedDate, objectNewLastmodifiedDate));            
                    else
                    totalminutes = ViasatUtilityClass.secondsBetweenTwoDateTimes(objectOldCaseStatusLastModifiedDate,objectNewLastmodifiedDate);            
                }
                updateStatusHistory.add(new StatusHistory__c(id = StatusHistoryMap.get(objSHmap).id, StatusSpendingTime__c = ViasatUtilityClass.TimeTextFormatting(totalminutes),TotalDurationInSeconds__c = totalminutes));                 
               
                ViasatUtilityClass.isPreventTriggerLooping = False; //Static variable for Prevent the Trigger recursion
            }
            if(StatusHistoryMap.get(objSHmap).Case__c == objectId && StatusHistoryMap.get(objSHmap).Status__c == objectNewStatus)
                existscheck = True; //Boolean variable for determine the current Case's status record available in Status Hisory object.
        } 
        if(existscheck != True)//If current Case's status record not available means New record will be inserted in Status History object.       
        {
            
            StatusHistory__c objectStatusHistory1 = new StatusHistory__c();
            objectStatusHistory1.Case__c = objectId;
            objectStatusHistory1.Status__c = objectNewStatus;
            insertStatusHistory.add(objectStatusHistory1);          
        }

        //************Status Detail Functionalities (Status Entry time and Exit Time)****************************************
        
        
        for(Id objSDmap :StatusDetailMap.Keyset())
        {             
          //Oct,15 - Changes made to address the issue where user updates the status and in the same context a workflow updates the status again. 
          if(StatusDetailMap.get(objSDmap).Case__c == objectId 
               && ( StatusDetailMap.get(objSDmap).Status__c == objectOldStatus)
               && StatusDetailMap.get(objSDmap).ExitTime__c == null)
            { 
                //If the trigger is being called again because of a status update in a workflow - then the case was in this status for 0 seconds
                //and exit time would be same as entry time.
                DateTime dtExitTime;
                if(mapOfIdToStatus.containsKey(objectId)) 
                    dtExitTime = StatusDetailMap.get(objSDmap).EntryTime__c;
                else
                    dtExitTime = objectNewLastmodifiedDate;
                    
                String duration = ViasatUtilityClass.durationBetweenTwoDateTimes(StatusDetailMap.get(objSDmap).EntryTime__c, dtExitTime);
               
                System.debug('************** collecting status details insert');
                //update exit time for existing Case detail record
                   updateStatusDetail.add(new StatusDetail__c(id=StatusDetailMap.get(objSDmap).id, ExitTime__c = dtExitTime, Duration__c =  duration));
                //Insert new record to Status Detail object with current Status Entry time.
                StatusDetail__c objectStatusDetail1 = new StatusDetail__c();
                objectStatusDetail1.Case__c = objectId;          
                objectStatusDetail1.ObjectType__c = objectType;
                objectStatusDetail1.Status__c = objectNewStatus;
                objectStatusDetail1.EntryTime__c = objectNewLastmodifiedDate;
                insertStatusDetail.add(objectStatusDetail1);
            }             
        }
        
        //Oct,15 - Adding this to track the status changes happening in case of a workflow field update
        If(!mapOfIdToStatus.containsKey(objectId))
            mapOfIdToStatus.put(objectId, objectNewStatus);
        
        //Send insert & update object lists to trigger(ViaSatUpdateCaseStatusTime) for the reason reduce the DML limit
        dwrapper = new StatusWrapper(updateStatusHistory, insertStatusHistory, updateStatusDetail, insertStatusDetail); 
        return dwrapper;
    }
    
    public class StatusWrapper
    {
        public List<StatusHistory__c> WupdStatusHistory{get;set;}
        public List<StatusHistory__c> WinsStatusHistory{get;set;}
        public List<StatusDetail__c> WupdStatusDetail{get;set;}
        public List<StatusDetail__c> WinsStatusDetail{get;set;}

        public StatusWrapper(List<StatusHistory__c> supdStatusHistory, List<StatusHistory__c> sinsStatusHistory, List<StatusDetail__c> supdStatusDetail, List<StatusDetail__c> sinsStatusDetail)
        {
            if(supdStatusHistory != null)
                this.WupdStatusHistory = supdStatusHistory;
            if(sinsStatusHistory != null) 
                this.WinsStatusHistory = sinsStatusHistory;
            if(supdStatusDetail != null)
                this.WupdStatusDetail = supdStatusDetail;
            if(sinsStatusDetail != null)
                this.WinsStatusDetail = sinsStatusDetail;
        }
    }
}