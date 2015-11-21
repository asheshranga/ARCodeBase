public class SNGTerminalHistoryQuery implements SNGISObjectHistoryQuery
{
    public List<SNGSObjectHistoryObjectWrapper> get(Id sObjectId, integer requestedEntries)
    {
        List<Terminal__History> terminalHistory = [SELECT Id, Field, NewValue, IsDeleted, ParentId, OldValue, CreatedDate, CreatedById, CreatedBy.Name
                                                   FROM Terminal__History WHERE ParentId = :sObjectId ORDER BY CreatedDate 
                                                   DESC, Id DESC LIMIT :requestedEntries];
                                                    
        return createModemHistoryObjectWrapperList(terminalHistory);
    }

    @TestVisible
    private List<SNGSObjectHistoryObjectWrapper> createModemHistoryObjectWrapperList(List<Terminal__History> terminalHistory)
    {
        List<SNGSObjectHistoryObjectWrapper> terminalHistoryWrapper = new List<SNGSObjectHistoryObjectWrapper>();
        
        for (Terminal__History th : terminalHistory)
        {
            terminalHistoryWrapper.add(new SNGSObjectHistoryObjectWrapper(th));
        }
        
        return terminalHistoryWrapper;
    }
}