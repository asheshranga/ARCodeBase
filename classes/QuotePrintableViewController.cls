/**
 * Controller for a customized PDF view of a quote object. 
 *
 * @author thomas.schulte@highondemand.com
 * @date May 18, 2010 
 */
public class QuotePrintableViewController {

	private Quote quote = null; 
	
	// This value will be the user record associated with the current running
	// user, or the value of the user in the preparedBy field, if any.
	public User preparedBy = null;

	// Grap a reference to the standard controller
	public QuotePrintableViewController(ApexPages.StandardController controller) {
		quote = (Quote) controller.getRecord();
	}

	// Retrieve QuoteLineItems
	public List<QuoteLineItem> getLineItems() {
		return [SELECT Id, PricebookEntry.Product2.Name, PricebookEntry.Product2.Description, PricebookEntry.Product2.ProductCode, UnitPrice, Quantity, TotalPrice
		        FROM QuoteLineItem
		        WHERE QuoteId = :quote.Id];		 
	}

	// Custom formatting of the current date.
	public String getCurrentDate() {
		return DateTime.now().format('dd MMMM yyyy');
	}

	// Returns a reference to the current running user, of the user reference
	// in the PreparedBy field.
	public User getPreparedBy() {
		
		if (preparedBy == null) {
			User user = null;
			Id userId = [SELECT Quote_Prepared_By_if_not_Current_User__c FROM Quote WHERE Id = :quote.Id LIMIT 1].Quote_Prepared_By_if_not_Current_User__c;
			if (userId == null) {
				userId =  UserInfo.getUserId();
			}
			preparedBy = [SELECT Id, Phone, Name, Title FROM User WHERE Id = :userId LIMIT 1];
		}
		return preparedBy;
	}
		


	@isTest
	public static void testQuotePrintableViewController() {
        Integer numOfObjs = 1;
        List<Account> accounts = ViasatTestUtility.createAccounts(numOfObjs, 'dummyTestAcc');
        insert accounts;
        List<Contact> contacts = ViasatTestUtility.createContacts(accounts, numOfObjs);
        insert contacts;      
		
		Opportunity opp = new Opportunity(
			Name = 'TestOpp',
			StageName = [SELECT MasterLabel FROM OpportunityStage WHERE IsActive = true and IsWon = false LIMIT 1].MasterLabel,
			CloseDate = Date.today()
		);
		insert opp;
		
						
		Quote q = new Quote(Contact = contacts[0], Name = 'TestQuote', OpportunityId = opp.Id);
		insert q;
		
		ApexPages.Standardcontroller controller = new ApexPages.Standardcontroller(q);
		QuotePrintableViewController pController = new QuotePrintableViewController(controller);
		
		pController.getLineItems();
		pController.getCurrentDate();
		pController.getPreparedBy();
	}


}