public with sharing class LiveAgentPostChat {
    public string transcriptval{get;set;}
    public string transcriptvalfinal{get;set;}
    public integer agentindex;
    public string agentname;
    public string disconnectedBy { get; set; }
    public string error { get; set; }
    public string chatKey { get; set; }
    public boolean transcriptLoaded { get; set; }
    public LiveChatTranscriptDuplicate__c transcript { get; set; }
    public string chatButtonId { get; set; }
    public string chatDeploymentId { get; set; }
    public String liveAgentDomain {get {return KeyValueStoreHelper.getTextValue('LiveAgentDomain'); } set;}
    
    public LiveAgentPostChat() {
    	try{
        transcriptval=apexpages.currentpage().getparameters().get('transcript');
        if(!(transcriptval == null))
        {
            agentindex = transcriptval.indexOf(':', 0); // Fetching index of angent name
            agentname = transcriptval.substring(0,agentindex); // Fetch agents name with help of index
            string temp = '<br/>' + agentname; // Add break to the agent name
            transcriptval = transcriptval.replaceAll(agentname,temp); // Replace the agent's name in transcript with breaks
            transcriptvalfinal = transcriptval.replaceAll('You:','<br/>You:'); // Replace the 'You' in transcript with breaks
            system.debug('ttttttttttttttttttt transcriptvalfinal 55 '+transcriptvalfinal);
        }
        Map<String, String> params = ApexPages.currentPage().getParameters();
        
                 
        disconnectedBy = params.get('disconnectedBy');
        if (disconnectedBy == 'error') {
            error = params.get('error');
            chatKey = params.get('chatKey');
            transcriptLoaded = false;
            chatButtonId = params.get('buttonId');
            chatDeploymentId = params.get('deploymentId');
        }
        
    	}
        catch(Exception e)
        {
        	transcriptLoaded = false;
        	disconnectedBy = 'agent';	
        	system.debug('Exception: '+e);      	
        	
        }
    }
    
    public void CheckTranscript() {
        List<LiveChatTranscriptDuplicate__c> transcripts = [SELECT Information__c, Name__c, Email__c, Phone__c, Product__c, Help__c FROM LiveChatTranscriptDuplicate__c WHERE Name = :chatKey LIMIT 1];
        if (transcripts.size() > 0) {
            transcript = transcripts.get(0);
            transcriptLoaded = true;
        }
    }
    
    public string TranscriptInformation {
        get {
            return transcript.Information__c.Replace('\r\n', '\\n').Replace('\n', '\\n');
        }
    }

}