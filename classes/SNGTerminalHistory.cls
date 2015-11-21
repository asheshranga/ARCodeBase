public with sharing class SNGTerminalHistory 
{
    //Protected Members
    private static final transient DescribeSObjectResult oSomeObjectSchema = Schema.SObjectType.Terminal__c;
    private static final transient Map<String, SObjectField> mapFields = oSomeObjectSchema.fields.getMap();

    //Properties
    public integer PageSize {get;set;}
    public boolean AllowShowMore {get;set;}
    public List<TerminalHistory> terminalObjectHistories { get { return getTerminalObjectHistory(); } }
    
    private static final transient String[] lookupField = new String[]
    {
        'Account',
        'Terminal Type'
    };


    //Private members
    private Terminal__c terminal;
    
    @TestVisible
    private SNGISObjectHistoryQuery historyQuery;

    //Constructors

    /**
     * Default Constructor
     */
    public SNGTerminalHistory(ApexPages.StandardController controller) 
    {
        terminal = (Terminal__c)controller.getRecord();
        PageSize = 5;   
        AllowShowMore = true;
        historyQuery = new SNGTerminalHistoryQuery();
    }

    //Public Methods
    public void showMore() {
        PageSize += 5;
    }

    //Private Methods

    /**
     * Returns SomeObject History records associated to the current SomeObject
     *
     * @param   SomeObjectId     the SomeObject__c record id to retrieve
     * @return  a list of SomeObjectHistory objects
     */
    private List<TerminalHistory> getTerminalObjectHistory() 
    {
        List<TerminalHistory> listSomeObjectHistory = new List<TerminalHistory>();

        if (terminal != null && terminal.Id != null) {
            DateTime dLastCreatedDate = null;

            integer limitPlusOne = PageSize + 1;
            List<SNGSObjectHistoryObjectWrapper> listEntityHistory = historyQuery.get(terminal.Id, limitPlusOne);
            AllowShowMore = (listEntityHistory.size() == limitPlusOne);
            
            boolean skipLookupFieldCheck = false;
            
            for (SNGSObjectHistoryObjectWrapper oHistory : listEntityHistory) 
            {
                TerminalHistory oSomeObjectHistory = new TerminalHistory(oHistory);
    
                if (mapFields.containsKey(oHistory.Field)) {
                    oSomeObjectHistory.FieldLabel = mapFields.get(oHistory.Field).getDescribe().Label;
                    if (!skipLookupFieldCheck && isLookupField(oSomeObjectHistory.FieldLabel))
                    {
                        skipLookupFieldCheck = true;
                        continue;
                    }
                    
                    skipLookupFieldCheck = false;
                }

                listSomeObjectHistory.add(oSomeObjectHistory);
                dLastCreatedDate = oHistory.CreatedDate;
                
                if (listSomeObjectHistory.size() == PageSize) break;

            }
        }
       
        return listSomeObjectHistory;
    }
    
    
    private boolean isLookupField(String fieldName)
    {
        boolean retValue = false;
        
        
        for (integer i = 0; i < lookupField.size() && !retValue; ++i)
        {
            retValue = (lookupField[i] == fieldName);
        }
        
        System.debug('isLookupField: ' + fieldName + ' result: ' + retValue);
        return retValue;
    }

    //Internal Classes

    /**
     * Data structure representing a SomeObject History record for display
     */
    public class TerminalHistory 
    {
        //Properties
        public boolean ShowDateAndUser {get;set;}
        public string FieldLabel {get;set;}
        public SNGSObjectHistoryObjectWrapper History {get; private set;}

        public string ActionFormat { get { return getActionFormat(); } }

        public TerminalHistory(SNGSObjectHistoryObjectWrapper oHistory) 
        {
            History = oHistory;
        }

        //Constructors
        public TerminalHistory() 
        {
            showDateAndUser = true;
        }

        //Private Methods
        private string getActionFormat() 
        {
            string sActionFormat = '';

            if (History != null) 
            {
                sActionFormat = 'Record <b>{0}.</b>';

                if (History.newValue != null && History.oldValue == null)
                    sActionFormat = 'Changed <b>{1}</b> to <b>{3}</b>.';    
                else if (History.newValue != null && History.oldValue != null)
                    sActionFormat = 'Changed <b>{1}</b> from <b>{2}</b> to <b>{3}</b>.';   
                else if (History.Field != null && History.Field.equalsIgnoreCase('created'))
                    sActionFormat = 'Created.';
            }

            return sActionFormat;
        }
    }
}