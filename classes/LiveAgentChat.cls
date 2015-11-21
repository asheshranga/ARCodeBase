public with sharing class LiveAgentChat {

    public string msg{get;set;}
    public list<string> admsg{get;set;}
    Public_Chat_Greeting__c stdmsg = new Public_Chat_Greeting__c();
    list<Public_Chat_Greeting__c> addlmsg = new list<Public_Chat_Greeting__c>();

    public LiveAgentChat(){
    
        //PublicKBContactUs pcs = new PublicKbContactUS();
        //CreateCase();
        
    datetime myDateTime = datetime.now(); 
    stdmsg = [select General_Message__c, High_Volume_Message__c, Message_to_be_displayed__c, Start_Date_Time__c, End_Date_Time__c, Additional_Message__c 
              from Public_Chat_Greeting__c 
              where recordTypeId =:label.Record_Type_General_High_Volume_Message];
    //addlmsg = [select Start_Date_Time__c, End_Date_Time__c, Additional_Message__c,recordType.name from Public_Chat_Greeting__c where recordTypeId =:label.RecordType_Additional_Messages and Start_Date_Time__c <= today and (End_Date_Time__c >= today OR End_Date_Time__c = null)]; 
    addlmsg = [select Start_Date_Time__c, End_Date_Time__c, Additional_Message__c,recordType.name 
               from Public_Chat_Greeting__c 
               where recordTypeId =:label.RecordType_Additional_Messages and Start_Date_Time__c <= :myDateTime and (End_Date_Time__c >= :myDateTime OR End_Date_Time__c = null)]; 
    
    if(stdmsg.Message_to_be_displayed__c == 'General')
        msg = stdmsg.General_Message__c;
    else if(stdmsg.Message_to_be_displayed__c == 'High Volume')
        msg = stdmsg.High_Volume_Message__c;
        
        if(addlmsg.size() > 0)
        {
            admsg = new list<string>();

            for(Public_Chat_Greeting__c m:addlmsg)
            {       
            if(m.Additional_Message__c != null && m.Additional_Message__c != '')
            admsg.add(m.Additional_Message__c);     
            }
        }
    }
    
    
    public integer getMinutesPerQueue() {
        try {
            return KeyValueStoreHelper.getIntegerValue('LiveAgentMinutesPerQueue');
        } catch (Exception ex) {
            return 1;
        }
    }
}