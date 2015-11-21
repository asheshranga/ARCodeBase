/**
 * This class contains helper functions to determine whether Accounts can be successfully added, updated, or deleted in the database.
 */
public with sharing class SNG_Account {

	/**
	 * This class is used to hold onto records linked to a particular account. It is used in validating deletion of Account records.
	 */
	private class LinkedRecords {
		public Account account { get; private set; }
		public List<ServicePlan__c> servicePlans = new List<ServicePlan__c>();
		public List<Terminal__c> terminals = new List<Terminal__c>();
		public List<Modem__c> modems = new List<Modem__c>();

		public LinkedRecords(Account account) {
			this.account = account;
		}
	}

	/**
	 * Validates Account deletion
	 *
	 * @param  accounts    The accounts to be deleted
	 * @return             Mapping of Account ID to an error String, containing all Accounts that cannot be deleted due to an error
	 */
	public static Map<Id, String> validateDeletion(Map<Id, Account> accounts) {
		Map<Id, String> errors = new Map<Id, String>();
		errors = validateNoLinkedServicePlanAndTerminalAndModems(accounts, errors);
		return errors;
	}

	/**
	 * Validates no Service Plans and Terminals are linked to Accounts that are attempting to be deleted
	 *
	 * @param 	accounts	The accounts to be deleted
	 * @return	        	Mapping of Account ID to an error String, containing all Accounts that cannot be deleted due to an error
	 */
	 private static Map<Id, String> validateNoLinkedServicePlanAndTerminalAndModems(Map<Id, Account> accounts, Map<Id, String> errors) {
	 	// Initialize MAP of AccountID with LinkedRecords object: <Account.Id, LinkedRecords>
	 	Map<Id, LinkedRecords> accountLinkedRecords = new Map<Id, LinkedRecords>();
	 	for (Account account : accounts.values()) {
            accountLinkedRecords.put(account.Id, new LinkedRecords(account));
        }

        final Set<Id> accountIds = accounts.keySet();

        // Add service plans
        List<ServicePlan__c> sps = [SELECT Id, Name, Account__c FROM ServicePlan__c WHERE Account__c = :accountIds];
        for (ServicePlan__c sp : sps)
        {
            accountLinkedRecords.get(sp.Account__c).servicePlans.add(sp);
        }

        // Add terminals
        List<Terminal__c> terminals = [SELECT Id, Name, Account__c FROM Terminal__c WHERE Account__c = :accountIds];
        for (Terminal__c t : terminals)
        {
            accountLinkedRecords.get(t.Account__c).terminals.add(t);
        }

        // Add modems
        List<Modem__c> modems = [SELECT Id, Name, Account__c FROM Modem__c WHERE Account__c = :accountIds];
        for (Modem__c m : modems)
        {
            accountLinkedRecords.get(m.Account__c).modems.add(m);
        }


        // Add errors
        for (LinkedRecords linkedRecords : accountLinkedRecords.values()) {
        	boolean shouldAddError = false;
        	String errorMessage = 'Account: ' + SNG_HtmlUtilities.getHtmlSalesforceRecordLinkString(linkedRecords.account) +
                                   ' cannot be deleted because it is associated with the following: ';

            if (!linkedRecords.servicePlans.isEmpty()) {
            	shouldAddError = true;
                errorMessage = errorMessage + ' Service Plan: ' +
                                SNG_HtmlUtilities.getHtmlSalesforceRecordLinkListString(linkedRecords.servicePlans);
            }
            if (!linkedRecords.terminals.isEmpty()) {
            	shouldAddError = true;
                errorMessage = errorMessage + ' Terminal: ' +
                                SNG_HtmlUtilities.getHtmlSalesforceRecordLinkListString(linkedRecords.terminals);
            }
            if (!linkedRecords.modems.isEmpty()) {
            	shouldAddError = true;
                errorMessage = errorMessage + ' Modem: ' +
                                SNG_HtmlUtilities.getHtmlSalesforceRecordLinkListString(linkedRecords.modems);
            }

            if (shouldAddError) {
            	errors = addError(errors, linkedRecords.account, SNG_HtmlUtilities.getHtmlMessageBoldRedFontFormat(errorMessage));
            }
        }

	 	return errors;
	 }

	 /**
	  * Adds an error to both the errors Map<AccountID, errorString> as well as to the Account record itself
	  *
	  * @param     errors  Map<AccountID, errorString> to add the error to
	  * @param     account Account to add the error on
	  * @param     error   The error message to add
	  * @return            Map<AccountID, errorString> with the error added
	  */
	 private static Map<Id, String> addError(Map<Id, String> errors, Account account, String error) {
	 	// add to map
	 	errors.put(account.Id, error);

	 	// add to record
	 	account.addError(error, false);

	 	return errors;
	 }
}