public class CommunityManagementController {
    public class Community {
     	public Boolean isSelected {get;set;}
        public String CommunityURL {get;set;}
        public Network community {get;set;}

     	public Community(Network aoNetwork){
        	this.community = aoNetwork;
            CommunityURL=Network.getLoginUrl(''+aoNetwork.id);
     	}
	}
    
    public List<Community> Communities {get;set;}
    public String actionType {get;set;}
    
    public CommunityManagementController () {
        Communities = new List<Community>();
        for (Network n: [select id,name, status,UrlPathPrefix,Description from Network]) {
            Communities.add(new Community(n));
        }        
    }

    public List<SelectOption> getTypes() {
    	List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('Online','Online'));
        options.add(new SelectOption('Offline','Offline'));
        
        return options;
    }
    
    public PageReference actionSelected() {
    	return null;    
    }
    
    public void invokeStatusUpdate() {
    	try {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'Successfully performed the community status update'));
       } catch(Exception e) {
       		System.debug('Error Invoking the service' + e.getMessage());
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Ooops! Unable to set the community status - ' + e.getMessage()));
       }       
    }
}