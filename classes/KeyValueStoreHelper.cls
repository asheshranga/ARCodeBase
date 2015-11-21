/*
    Represents KeyValueStore__c custom setting object. This class has convenient 
    methods to fetch values from this custom setting. Since custom setting is cached,
    this class will return the cached information only. 
	
    **********************************************************
    Audit History
    **********************************************************
    5/10/2013	Shah Kadirmohideen 		Created
    **********************************************************  
*/ 
public class KeyValueStoreHelper {
	
	//Use this method to return value from TextValue__c field
    public static String getTextValue(String key) {
    	KeyValueStore__c keyValueRecord = getRecord(key);
        return keyValueRecord == null ? null : keyValueRecord.TextValue__c;
    }   
    
    //Use this method to return value from BooleanValue__c field
    public static Boolean getBooleanValue(String key) {
    	KeyValueStore__c keyValueRecord = getRecord(key);
        return keyValueRecord == null ? false : keyValueRecord.BooleanValue__c;
    }   
    
    //Use this method to return value from IntegerValue__c field
    public static Integer getIntegerValue(String key) {
    	KeyValueStore__c keyValueRecord = getRecord(key);
        return keyValueRecord == null ? null : keyValueRecord.IntegerValue__c == null ? null : keyValueRecord.IntegerValue__c.intValue();
    }   
    
    //Use this method to return value from DecimalValue__c field
    public static Decimal getDecimalValue(String key) {
    	KeyValueStore__c keyValueRecord = getRecord(key);
        return keyValueRecord == null ? null : keyValueRecord.DecimalValue__c;
    }   
    
    //Use this method to return value from DateValue__c field
    public static Date getDateValue(String key) {
    	KeyValueStore__c keyValueRecord = getRecord(key);
        return keyValueRecord == null ? null : keyValueRecord.DateValue__c;
    }   
    
    //Use this method to return value from DateTimeValue__c field
    public static DateTime getDateTimeValue(String key) {
    	KeyValueStore__c keyValueRecord = getRecord(key);
        return keyValueRecord == null ? null : keyValueRecord.DateTimeValue__c;
    }   
	
	/* PRIVATE METHODS */
	
	private static KeyValueStore__c getRecord(String key) {
        //Map<String, KeyValueStore__c> mapValues = KeyValueStore__c.getAll();
        //KeyValueStore__c keyValueRecord = mapValues.get(key);
        KeyValueStore__c keyValueRecord = KeyValueStore__c.getInstance(key);
        return keyValueRecord;
	}
}