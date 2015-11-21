public class PassengerCareUtility {
    public static Map<String,Passenger_Care__c> MapPassengerCase=Passenger_Care__c.getAll();
    
    //--- Get Key Value from custom settings
    public static string getFieldValue(String name) { 
        try{
            return MapPassengerCase.get(name).Value__c;
        }        
        catch(Exception e){
            return null;
        }         
    }    
    
    //--- Get Object Id by name
    //--- Examples:
    //--- PassengerCareUtility.getObjectIdByName('account',PassengerCareConstants.ACCOUNT_NAME)
    //--- PassengerCareUtility.getObjectIdByName('site__c',PassengerCareConstants.SITE_NAME)    
    public static Id getObjectIdByName (String asObject, String asObjectName) {
        try {
            SObject[] loObject = Database.query(String.format('select id from {0} where name = \'\'{1}\'\' LIMIT 1', new string[] {asObject,asObjectName}));
            return loObject[0].id;
        } catch (Exception e) {
            return null;
        }
    }
    
    //--- Get Queue Id by name
    //--- Examples:
    //--- PassengerCareUtility.getQueueIdByName(PassengerCareConstants.QUEUE_NAME)
    public static Id getQueueIdByName (String asQueueName) {
        try {
            return [select queue.id from QueueSObject where queue.name=:asQueueName LIMIT 1].queue.id;
        } catch (Exception e) {
            return null;
        }
    }
    
    //--- Get Record Type Id by name
    //--- Examples:
    //--- PassengerCareUtility.getObjectRecordTypeId(CASE.SObjectType, PassengerCareConstants.CASE_RECORD_TYPE_NAME)
    public static String getObjectRecordTypeId(SObjectType sObjectType, String asRecordTypeName) {        
        try {
            //Generate a map of tokens for all the Record Types for the desired object
            Map<String,Schema.RecordTypeInfo> recordTypeInfo = sObjectType.getDescribe().getRecordTypeInfosByName();
            
            //Retrieve the record type id by name
            return recordTypeInfo.get(asRecordTypeName).getRecordTypeId();
        } catch (Exception e) {
            return null;
        }
    }    
}