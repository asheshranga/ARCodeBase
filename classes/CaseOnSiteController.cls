/*********************************************************************************
Name:	 CaseOnSiteController 
Created: Marina Basovich
Created: 07/15/2015
Project: Case 00403567
Usage:	To support case creation against an MPLS Service Site:
		When a Case is created against an MPLS Service Site, the system shall enforce the user to select the Circuit Affected
		After the Case has been created, the ‘MPLS Customers to Notify’ shall be displayed in the Case (near the ‘MPLS Circuit Affected’ picklist)
*********************************************************************************/
public with sharing class CaseOnSiteController 
{
	public Case caseInput {get;set;} 
	public Id CaseId {get;set;}   
	public list<SiteAccountAssociation__c> siteAccounts {get;set;}

	public boolean showSiteAccounts{get;set;} 
     
	private ApexPages.StandardController sController=null; 
    
	public CaseOnSiteController(ApexPages.StandardController controller) 
	{     
		sController=controller;     
		CaseId=controller.getID();  
		caseInput = [SELECT id, MPLSCircuitAffected__c, Site__c, Site__r.RecordTypeId, Site__r.RecordType.name, CaseNumber FROM Case WHERE id=:CaseId];            
		
		showSiteAccounts = false;
		if (caseInput.Site__c != Null && caseInput.Site__r.RecordTypeId != null && caseInput.Site__r.RecordType.name == 'MPLS')
			showSiteAccounts = true;

		initCaseOnSite();
	}
	             
    private void initCaseOnSite()
    {
    	if (showSiteAccounts)
    	{
			// If MPLSCircuitAffected__c = ‘Physical Circuit’, then display accounts with the ‘Circuit ID’ = ‘Logical 1’ and ‘Logical 2’
			// ‘Logical 1’ is selected, then display accounts with the ‘Circuit ID’  = ‘Logical 1’ 
			// ‘Logical 2’ is selected, then display accounts with the ‘Circuit ID’  = ‘Logical 2’
			set<string> circuitSet = new set<string>();
			if (caseInput.MPLSCircuitAffected__c == 'Logical 1' || caseInput.MPLSCircuitAffected__c == 'Physical Circuit')	circuitSet.add('Logical 1');
			if (caseInput.MPLSCircuitAffected__c == 'Logical 2' || caseInput.MPLSCircuitAffected__c == 'Physical Circuit')	circuitSet.add('Logical 2');
			siteAccounts = [SELECT Account__c, Account__r.Name, AccountType__c, CircuitID__c FROM SiteAccountAssociation__c WHERE ServiceSite__c = :caseInput.Site__c and CircuitID__c in :circuitSet];
    	}
		if (siteAccounts == null || siteAccounts.isEmpty())
			siteAccounts = new list<SiteAccountAssociation__c>();
        system.debug('*** '+ siteAccounts);
    }
}