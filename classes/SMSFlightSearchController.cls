public with sharing class SMSFlightSearchController {
    
    // the soql without the order and limit
    private String soql {get;set;}
    // the collection of examples to display
    public List<Flight__c> flights {get;set;}
    
    // the current sort direction. defaults to asc
    public String sortDir {
        get  { if (sortDir == null) {  sortDir = 'asc'; } return sortDir;  }
        set;
    }
    
    // the current field to sort by. defaults to flight ID
    public String sortField {
        get  { if (sortField == null) {sortField = 'Name'; } return sortField;  }
        set;
    }
    
    // format the soql for display on the visualforce page
    public String debugSoql {
        get { return soql + ' order by ' + sortField + ' ' + sortDir + ' limit 2000'; }
        set;
    }
    
    // init the controller and display some sample data when the page loads
    public SMSFlightSearchController() {
        soql = 'SELECT Id, Name, Airline__c, Flight_ID_Link__c, Site__c, Site_Name__c, Tail_ID__c, Status__c, ocode__c, dcode__c, peds__c, Altitude__c, Connectivity_Image__c, TV_Image__c, Wi_Fi_Image__c FROM Flight__c WHERE Airline__c != null';
        runQuery();
    }
    
    // toggles the sorting of query from asc<-->desc
    public void toggleSort() {
        // simply toggle the direction
        sortDir = sortDir.equals('asc') ? 'desc' : 'asc';
        // run the query again
        runQuery();
    }
    
    // runs the actual query
    public void runQuery() {
        
        try {
            flights = Database.query(soql + ' order by ' + sortField + ' ' + sortDir + ' limit 2000');
        } catch (Exception e) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Ooops!'));
        }
        
    }
    
    // runs the search with parameters passed via Javascript
    public PageReference runSearch() {
        
        String flightID = Apexpages.currentPage().getParameters().get('flightID');
        String tailID = Apexpages.currentPage().getParameters().get('tailID');
        String airline = Apexpages.currentPage().getParameters().get('airline');
        
        soql = 'SELECT Id, Name, Airline__c, Flight_ID_Link__c, Site__c, Site_Name__c, Tail_ID__c, Status__c, ocode__c, dcode__c, peds__c, Altitude__c, Connectivity_Image__c, TV_Image__c, Wi_Fi_Image__c FROM Flight__c WHERE Airline__c != null';
        if (!flightID.equals(''))
            soql += ' and Name LIKE \''+String.escapeSingleQuotes(flightID)+'%\'';
        if (!tailID.equals(''))
            soql += ' and Tail_ID__c LIKE \''+String.escapeSingleQuotes(tailID)+'%\'';
        if (!airline.equals(''))
            soql += ' and Airline__c LIKE \''+String.escapeSingleQuotes(airline)+'%\'';
        
        // run the query again
        runQuery();
        
        return null;
    }
    
}