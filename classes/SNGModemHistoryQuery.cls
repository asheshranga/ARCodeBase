public class SNGModemHistoryQuery implements SNGISObjectHistoryQuery 
{
	
	public List<SNGSObjectHistoryObjectWrapper> get(Id sObjectId, integer requestedEntries)
	{
		List<Modem__History> modemHistory = [SELECT Id, Field, NewValue, IsDeleted, ParentId, OldValue, CreatedDate, CreatedById, CreatedBy.Name
                                                    FROM Modem__History WHERE ParentId = :sObjectId ORDER BY CreatedDate 
                                                    DESC, Id DESC LIMIT :requestedEntries];
                                                    
        return createModemHistoryObjectWrapperList(modemHistory);
	}

    @TestVisible
    private List<SNGSObjectHistoryObjectWrapper> createModemHistoryObjectWrapperList(List<Modem__History> modemHistory)
    {
    	List<SNGSObjectHistoryObjectWrapper> modemHistoryWrapper = new List<SNGSObjectHistoryObjectWrapper>();
    	
    	for (Modem__History mh : modemHistory)
    	{
    		modemHistoryWrapper.add(new SNGSObjectHistoryObjectWrapper(mh));
    	}
    	
    	return modemHistoryWrapper;
    }

}