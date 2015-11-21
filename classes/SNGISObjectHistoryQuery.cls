public interface SNGISObjectHistoryQuery 
{
    List<SNGSObjectHistoryObjectWrapper> get(Id sObjectId, integer requestedEntries);
}