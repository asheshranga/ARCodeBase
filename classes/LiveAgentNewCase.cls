public with sharing class LiveAgentNewCase {

	public String CaseId { get; set; }

	public void TakeCaseOwnership() {
		
		try {
			if (CaseId != null && CaseId != '') {
				
				Case c = [SELECT Id FROM Case WHERE Id = :CaseId];
				
				c.OwnerId = UserInfo.getUserId();
				
				update c;
				
			}
		} catch (Exception ex) {
			System.Debug(ex);
		}
		
	}

}