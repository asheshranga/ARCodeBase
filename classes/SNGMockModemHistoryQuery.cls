@isTest
public with sharing class SNGMockModemHistoryQuery implements SNGISObjectHistoryQuery
{
	private static Integer s_num = 1;
	
	public static final String CREATE_USER_FIRST_NAME = 'Test';
	public static final String CREATE_USER_LAST_NAME = 'User';
	
    public List<SNGSObjectHistoryObjectWrapper> get(Id modemId, integer requestedEntries)
    {
    	List<SNGSObjectHistoryObjectWrapper> historyList = new List<SNGSObjectHistoryObjectWrapper>();
    	
    	if (1 == requestedEntries)
    	{
    		SNGSObjectHistoryObjectWrapper history = new SNGSObjectHistoryObjectWrapper();
    		history.createdById = getFakeId(User.sObjectType);
    		history.createdBy = getNameObj('Test');
    		history.field = 'Created';
    		//history.Id = getFakeId(Modem__c.sObjectType);
    		//history.isDeleted = false;
    		history.oldValue = null;
    		history.newValue = null;
    		//history.parentId = getFakeId(Modem__c.sObjectType);
    		
    		historyList.add(history);
    	}
    	else if (2 == requestedEntries)
    	{
    		// on lookup fields the first entry gets skipped.
            SNGSObjectHistoryObjectWrapper history = new SNGSObjectHistoryObjectWrapper();
            history.createdById = getFakeId(User.sObjectType);
            history.createdBy = getNameObj('Test');
            history.field = 'Terminal__c';
            //history.Id = getFakeId(Modem__c.sObjectType);
            //history.isDeleted = false;
            history.oldValue = null;
            history.newValue = 'Test';
            //history.parentId = getFakeId(Modem__c.sObjectType);
            
            SNGSObjectHistoryObjectWrapper history1 = new SNGSObjectHistoryObjectWrapper();
            history1.createdById = getFakeId(User.sObjectType);
            history1.createdBy = getNameObj('Test');
            history1.field = 'Terminal__c';
            //history1.Id = getFakeId(Modem__c.sObjectType);
            //history1.isDeleted = false;
            history1.oldValue = null;
            history1.newValue = 'Test1';
            //history1.parentId = getFakeId(Modem__c.sObjectType);
            
            historyList.add(history);
            historyList.add(history1);    	
    	}
    	else if (3 == requestedEntries)
    	{
            // on lookup fields the first entry gets skipped.
            SNGSObjectHistoryObjectWrapper history = new SNGSObjectHistoryObjectWrapper();
            history.createdById = getFakeId(User.sObjectType);
            history.createdBy = getNameObj('Test');
            history.field = 'SerialNumber__c';
            //history.Id = getFakeId(Modem__c.sObjectType);
            //history.isDeleted = false;
            history.oldValue = null;
            history.newValue = '2';
            //history.parentId = getFakeId(Modem__c.sObjectType);    		
            
            SNGSObjectHistoryObjectWrapper history1 = new SNGSObjectHistoryObjectWrapper();
            history1.createdById = getFakeId(User.sObjectType);
            history1.createdBy = getNameObj('Test');
            history1.field = 'SerialNumber__c';
            //history1.Id = getFakeId(Modem__c.sObjectType);
            //history1.isDeleted = false;
            history1.oldValue = '2';
            history1.newValue = '3';
            //history1.parentId = getFakeId(Modem__c.sObjectType);    
            
            historyList.add(history);
            historyList.add(history1);      
    	}
    	else if (4 == requestedEntries)
        {
            // on lookup fields the first entry gets skipped.
            SNGSObjectHistoryObjectWrapper history = new SNGSObjectHistoryObjectWrapper();
            history.createdById = getFakeId(User.sObjectType);
            history.createdBy = getNameObj('Test');
            history.field = 'SerialNumber__c';
            //history.Id = getFakeId(Modem__c.sObjectType);
            //history.isDeleted = false;
            history.oldValue = '1';
            history.newValue = null;
      
            historyList.add(history);      
        }
    	
    	return historyList;
    
    }
    
    private SNGSObjectHistoryObjectWrapper.NameWrapper getNameObj(String name)
    {    	
        return new SNGSObjectHistoryObjectWrapper.NameWrapper(name);
    }
    
    private String getFakeId(Schema.SObjectType sot)
    {
         String result = String.valueOf(s_num++);
         return sot.getDescribe().getKeyPrefix() + 
         '0'.repeat(12-result.length()) + result;
    }
}