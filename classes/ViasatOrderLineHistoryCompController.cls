public class ViasatOrderLineHistoryCompController {
    
    // External variables
    public SObject Currentobject{get; set;}    
    public Integer RLrecordLimit{get; set;}
    public static String objectLabel{get;}
     public static String objectLabel2{get;}
    
    // Internal Variables
    public Histories[] objectHistory; 
    public static final Map<String, Schema.SObjectType> mySObjectTypeMap = Schema.getGlobalDescribe();
    public static final Map<String, Schema.SObjectType> mySObjectTypeMap2 = Schema.getGlobalDescribe();
    public static Map<String, Schema.SObjectField> ObjectFieldMap;
     public static Map<String, Schema.SObjectField> ObjectFieldMap2;
    public static List<Schema.PicklistEntry> historyFieldPicklistValues;
    public static List<Schema.PicklistEntry> historyFieldPicklistValues2;
    public static List<sObject> historyList = new list<sObject>();
    public static List<sObject> historyList2 = new list<sObject>();
    public Set<id> lineids = new Set<id>();
    public map<Id,OrderLine__c> maporderline = new map<id,OrderLine__c>();
    public map<Decimal, set<String>> mapRandomNumbers = new map<Decimal, set<String>>();
    public list<Orderline__c> lstorderline = new list<Orderline__c>();
    public Static Boolean loopstopper = true;
   
    
    public List<Histories> getObjectHistory()
    {        
        Id Currentobjectid = String.valueOf(Currentobject.get('Id'));
        
        for(OrderLine__c ol : [Select id,Part_Description__c,Random_Number__c from OrderLine__c where Order__c =:Currentobjectid])
        {
          lstorderline.add(ol);
          lineids.add(ol.id);
          maporderline.put(ol.id,ol);
        }  
        
        //Build mapping for Terminal grouping based on Random number        
        for(Orderline__c ol : lstorderline)
        {
         if(ol.Random_Number__c <> null)
         {
             set<String> templist= new set<String>();
             if(mapRandomNumbers.containskey(ol.Random_Number__c))
             {
               Templist= mapRandomNumbers.get(ol.Random_Number__c);
               Templist.add(ol.Part_Description__c);
               mapRandomNumbers.put(ol.Random_Number__c,templist);
             }  
             else
             {
               templist.add(ol.Part_Description__c);
               mapRandomNumbers.put(ol.Random_Number__c,templist); 
             }  
          }  
        }
        
        Schema.DescribeSObjectResult objectDescription = OrderLine__c.getSObjectType().getDescribe();
        ObjectFieldMap = objectDescription.fields.getMap();
        objectLabel = String.valueOf(objectDescription.getLabel());        
        String objectHistoryTableName = 'OrderLine__' + 'History';        
        Schema.DescribeFieldResult objectHistoryFieldField = mySObjectTypeMap.get(objectHistoryTableName).getDescribe().fields.getMap().get('Field').getDescribe();
        historyFieldPicklistValues = objectHistoryFieldField.getPickListValues();
        
        Schema.DescribeSObjectResult objectDescription2 = OrderLine__c.getSObjectType().getDescribe();
        ObjectFieldMap2 = objectDescription2.fields.getMap();
        objectLabel2 = String.valueOf(objectDescription2.getLabel());        
        String objectHistoryTableName2 = 'Order__' + 'History';        
        Schema.DescribeFieldResult objectHistoryFieldField2 = mySObjectTypeMap2.get(objectHistoryTableName2).getDescribe().fields.getMap().get('Field').getDescribe();
        historyFieldPicklistValues2 = objectHistoryFieldField2.getPickListValues();
                    
        list<Histories> objectHistory = new list<Histories>();
        list<Histories> objectHistory2 = new list<Histories>();
        list<Histories> objectHistory3 = new list<Histories>();
        
        String prevDate = '';
        
        if (RLrecordLimit== null){
            RLrecordLimit = 100;
        }       
              
        if(Currentobjectid != null)
        {
            historyList = Database.query( 'SELECT CreatedDate,'+
                                            'CreatedById,'+
                                            'Field,'+
                                            'NewValue,'+
                                            'ParentId,'+
                                            'OldValue ' +
                                            'FROM ' + objectHistoryTableName + ' ' +
                                            'WHERE ParentId IN: lineids' + ' ' +
                                            'ORDER BY CreatedDate DESC '+
                                            'LIMIT ' + String.valueOf(RLrecordLimit));
        }
        
        if(Currentobjectid != null)
        {
            historyList2 = Database.query( 'SELECT CreatedDate,'+
                                            'CreatedById,'+
                                            'Field,'+
                                            'NewValue,'+
                                            'OldValue ' +
                                            'FROM ' + objectHistoryTableName2 + ' ' +
                                            'WHERE ParentId =\'' + Currentobjectid + '\' ' +
                                            'ORDER BY CreatedDate DESC '+
                                            'LIMIT ' + String.valueOf(RLrecordLimit));
        }
        
        
        for(Integer i = 0; i < historyList2.size(); i++)
        {
            sObject historyLine = historyList2.get(i);
            if ((historyLine.get('newValue') == null && historyLine.get('oldValue') == null) 
                    || (historyLine.get('newValue') != null && !(string.valueOf(historyLine.get('newValue')).startsWith('005') || string.valueOf(historyLine.get('newValue')).startsWith('00G')))
                    || (historyLine.get('oldValue') != null && !(string.valueOf(historyLine.get('oldValue')).startsWith('005') || string.valueOf(historyLine.get('oldValue')).startsWith('00G')))){
                Histories tempHistory = new Histories();
                // Set the Date and who performed the action
                if (String.valueOf(historyLine.get('CreatedDate')) != prevDate){
                    tempHistory.displayDate = String.valueof(historyLine.get('CreatedDate'));
                    tempHistory.theDate = Datetime.valueof(historyLine.get('CreatedDate'));
                    tempHistory.userId = String.valueOf(historyLine.get('CreatedById'));
                    tempHistory.who = String.valueOf(historyLine.get('CreatedById'));
                }
                else{
                    tempHistory.displayDate = '';
                    tempHistory.theDate = Datetime.valueof(System.now());
                    tempHistory.who = '';
                    tempHistory.userId = String.valueOf(historyLine.get('CreatedById'));
                }
                tempHistory.item = 'Order';
                prevDate = String.valueOf(historyLine.get('CreatedDate'));
                
                // Get the field label
                String fieldLabel = ViasatOrderLineHistoryCompController.returnFieldLabel2(String.valueOf(historyLine.get('Field')));
                
                // Set the Action value
                   if (String.valueOf(historyLine.get('Field')) == 'created') {    // on Creation
                       tempHistory.action = 'Created.';
                  }
                  else if (historyLine.get('oldValue') != null && historyLine.get('newValue') == null){ // when deleting a value from a field
                      // Format the Date and if there's an error, catch it and re
                      try {
                         tempHistory.action = 'Deleted ' + Date.valueOf(historyLine.get('oldValue')).format() + ' in <b>' + fieldLabel + '</b>.';
                    } catch (Exception e){
                         tempHistory.action = 'Deleted ' + String.valueOf(historyLine.get('oldValue')) + ' in <b>' + fieldLabel + '</b>.';
                    }
                  }
                  else{  // all other scenarios
                      String fromText = '';
                    if (historyLine.get('oldValue') != null) {
                         try {
                              fromText = ' from ' + Date.valueOf(historyLine.get('oldValue')).format();
                         } catch (Exception e) {
                              fromText = ' from ' + String.valueOf(historyLine.get('oldValue'));
                         }
                    }
                    
                    String toText = '';
                    if (historyLine.get('oldValue') != null) {
                        try {
                             toText = Date.valueOf(historyLine.get('newValue')).format();
                        } catch (Exception e) {
                             toText = String.valueOf(historyLine.get('newValue'));
                        }
                    }
                    if (toText != ''){
                        tempHistory.action = 'Changed <b>' + fieldLabel + '</b>' + fromText + ' to <b>' + toText + '</b>.';
                    }
                    else {
                        tempHistory.action = 'Changed <b>' + fieldLabel;
                    }
                   }
                   
                   // Add to the list
                   objectHistory.add(tempHistory);
            }
        }   

        for(Integer i = 0; i < historyList.size(); i++)
        {            
            sObject historyLine = historyList.get(i);
            if ((historyLine.get('newValue') == null && historyLine.get('oldValue') == null) 
                    || (historyLine.get('newValue') != null && !(string.valueOf(historyLine.get('newValue')).startsWith('005') || string.valueOf(historyLine.get('newValue')).startsWith('00G')))
                    || (historyLine.get('oldValue') != null && !(string.valueOf(historyLine.get('oldValue')).startsWith('005') || string.valueOf(historyLine.get('oldValue')).startsWith('00G'))))
            {
                Histories tempHistory = new Histories();
                // Set the Date and who performed the action
                if (String.valueOf(historyLine.get('CreatedDate')) != prevDate)
                {
                    tempHistory.displayDate = String.valueof(historyLine.get('CreatedDate'));
                    tempHistory.theDate = Datetime.valueof(historyLine.get('CreatedDate'));
                    tempHistory.userId = String.valueOf(historyLine.get('CreatedById'));
                    tempHistory.who = String.valueOf(historyLine.get('CreatedById'));                   
                }
                else{
                    tempHistory.displayDate = '';
                    tempHistory.theDate = Datetime.valueof(system.now());
                    tempHistory.who = '';
                    tempHistory.userId = String.valueOf(historyLine.get('CreatedById'));                    
                }
                prevDate = String.valueOf(historyLine.get('CreatedDate'));
                
                if(mapRandomNumbers.containskey(maporderline.get(String.valueof(historyLine.get('ParentId'))).Random_Number__c))
                {
                    /*String temp;
                    Set<String> lsttemp = mapRandomNumbers.get(maporderline.get(String.valueof(historyLine.get('ParentId'))).Random_Number__c);
                    System.debug('lsttemp :'+ lsttemp.size());
                    if(lsttemp.size() == 3)
                    {
                        for(String ld: lsttemp)
                        {
                             if(ld != null)
                             {
                              if(temp == null)
                               temp = ld;
                              else  
                               temp = temp + '</br>' + ld;
                             } 
                        }
                    }*/
                    tempHistory.linedescription = 'TERM' + maporderline.get(String.valueof(historyLine.get('ParentId'))).Random_Number__c;
                    tempHistory.item = 'Terminal';
                }  
                else                
                {
                   tempHistory.item = 'Spare';               
                   tempHistory.linedescription = maporderline.get(String.valueof(historyLine.get('ParentId'))).Part_Description__c;
                }
                // Get the field label
                String fieldLabel = ViasatOrderLineHistoryCompController.returnFieldLabel(String.valueOf(historyLine.get('Field')));
                
                // Set the Action value
                if (String.valueOf(historyLine.get('Field')) == 'created') {    // on Creation
                       tempHistory.action = 'Created.';
                }
                else if (historyLine.get('oldValue') != null && historyLine.get('newValue') == null)
                { // when deleting a value from a field
                      // Format the Date and if there's an error, catch it and re
                      try {
                         tempHistory.action = 'Deleted ' + Date.valueOf(historyLine.get('oldValue')).format() + ' in <b>' + fieldLabel + '</b>.';
                    } catch (Exception e){
                         tempHistory.action = 'Deleted ' + String.valueOf(historyLine.get('oldValue')) + ' in <b>' + fieldLabel + '</b>.';
                    }
                }
                else
                {  // all other scenarios
                      String fromText = '';
                    if (historyLine.get('oldValue') != null) 
                    {
                         try {
                              fromText = ' from ' + Date.valueOf(historyLine.get('oldValue')).format();
                         } catch (Exception e) {
                              fromText = ' from ' + String.valueOf(historyLine.get('oldValue'));
                         }
                    }
                    
                    String toText = '';
                    if (historyLine.get('oldValue') != null) 
                    {
                        try {
                             toText = Date.valueOf(historyLine.get('newValue')).format();
                        } catch (Exception e) {
                             toText = String.valueOf(historyLine.get('newValue'));
                        }
                    }
                    if (toText != ''){
                        tempHistory.action = 'Changed <b>' + fieldLabel + '</b>' + fromText + ' to <b>' + toText + '</b>.';
                    }
                    else {
                        tempHistory.action = 'Changed <b>' + fieldLabel;
                    }
                }                   
                // Add to the list
                objectHistory.add(tempHistory);
            }
        }       
        
               
        List<Id> userIdList = new List<Id>();
        for (Histories myHistory : objectHistory)
        {
            userIdList.add(myHistory.userId);
        }
        Map<Id, User> userIdMap = new Map<ID, User>([SELECT Name FROM User WHERE Id IN : userIdList]);
         
        for (Histories myHistory : objectHistory)
        {             
             if (userIdMap.containsKey(myHistory.userId) & (myHistory.who != '') ){
                 myHistory.who = userIdMap.get(myHistory.who).Name;
             }
        }         
        for (Histories myHistory : objectHistory)
        {                    
            if(myHistory.who != '')
            {              
              objectHistory2.add(myHistory);
            }
        }
        for(integer i=0;i<objectHistory2.size();i++)
        {
          for(integer j=0;j<(objectHistory2.size()-i-1);j++)
          {
            if(objectHistory2[j].thedate < objectHistory2[j+1].thedate)
            { 
              Histories temp = objectHistory2[j];
              objectHistory2[j] = objectHistory2[j+1];
              objectHistory2[j+1] = temp;
            } 
          }
        } 
        return objectHistory2;
    } 
    
    // Function to return Field Label of a object field given a Field API name
    public Static String returnFieldLabel(String fieldName){

        if (ViasatOrderLineHistoryCompController.ObjectFieldMap.containsKey(fieldName)){
            return ViasatOrderLineHistoryCompController.ObjectFieldMap.get(fieldName).getDescribe().getLabel();
        }
        else 
        {
            for(Schema.PicklistEntry pickList : historyFieldPicklistValues)
            {
                if (pickList.getValue() == fieldName){
                    if (pickList.getLabel() != null){
                        return pickList.getLabel();
                    }
                    else {
                        return pickList.getValue();
                    }
                }
            }
        }
        return '';
    }
    
    // Function to return Field Label of a object field given a Field API name
    public Static String returnFieldLabel2(String fieldName){

        if (ViasatOrderLineHistoryCompController.ObjectFieldMap2.containsKey(fieldName)){
            return ViasatOrderLineHistoryCompController.ObjectFieldMap2.get(fieldName).getDescribe().getLabel();
        }
        else {
            for(Schema.PicklistEntry pickList : historyFieldPicklistValues2){
                if (pickList.getValue() == fieldName){
                    if (pickList.getLabel() != null){
                        return pickList.getLabel();
                    }
                    else {
                        return pickList.getValue();
                    }
                }
            }
        }
        return '';
    }
    
    // Inner Class to store the detail of the object history lines    
    public class Histories 
    {
        public String item {get; set;}
        public String displayDate {get; set;}
        public Datetime theDate {get; set;}       
        public String linedescription {get; set;}
        public String who {get; set;}       
        public Id userId {get; set;} 
        public String action {get; set;}
    }
}