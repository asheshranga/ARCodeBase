public with sharing class LiveAgentPreChat {

    public Case caseRecord { get; set; }

    public LiveAgentPreChat() {
        Map<String, String> params = ApexPages.currentPage().getParameters();
        for(String param : params.keyset())
            System.debug(param + ':' + params.get('param'));
            
    }
    
    public void CreateCase() {
        caseRecord = new Case();
       // Below line is commented to avoid dummy case record being created on click of chat now button.
       // insert caseRecord;
    }

}