public with sharing class SNGSObjectHistoryObjectWrapper 
{
    public Id createdById { get; set; }
    public DateTime createdDate { get; set; }
    public NameWrapper createdBy { get; set; }
    public String field { get; set; }
    public Object newValue { get;set; }
    public Object oldValue { get; set; }
    
    public SNGSObjectHistoryObjectWrapper()
    {
    }

    public SNGSObjectHistoryObjectWrapper(Modem__History modemHistory)
    {
    	createdById = modemHistory.CreatedById;
    	createdDate = modemHistory.CreatedDate;
    	field = modemHistory.Field;
    	newValue = modemHistory.NewValue;
    	oldValue = modemHistory.OldValue;
    }
    
    public SNGSObjectHistoryObjectWrapper(Terminal__History terminalHistory)
    {
    	createdById = terminalHistory.CreatedById;
    	createdDate = terminalHistory.CreatedDate;
    	field = terminalHistory.Field;
    	newValue = terminalHistory.NewValue;
    	oldValue = terminalHistory.OldValue;
    }
    
    public class NameWrapper
    {
    	public String name { get; set; }
    	
    	public NameWrapper(String name)
    	{
    		this.name = name;
    	}
    	
    	public NameWrapper(Name nameObj)
    	{ 
    		this(nameObj.Name);
    	}
    }

}