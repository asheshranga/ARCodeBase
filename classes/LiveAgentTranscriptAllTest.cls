@isTest
public class LiveAgentTranscriptAllTest {

	public static testMethod void test1() {
		
		LiveChatVisitor lcv = new LiveChatVisitor();
		insert lcv;
		
		LiveChatTranscript lct = new LiveChatTranscript();
		lct.ChatKey = 'ChatKey1';
		lct.Additional_Information__c = 'A';
		lct.LiveChatVisitorId = lcv.Id;
		insert lct;
		
		LiveChatTranscriptDuplicate__c lctd = [SELECT Information__c FROM LiveChatTranscriptDuplicate__c WHERE Name = 'ChatKey1'];
		System.assertEquals('A', lctd.Information__c);
		
		lct.Additional_Information__c = 'B';
		update lct;
		
		lctd = [SELECT Information__c FROM LiveChatTranscriptDuplicate__c WHERE Name = 'ChatKey1'];
		System.assertEquals('B', lctd.Information__c);
		
	}

	// *** TEST LiveAgentChat
	public static testMethod void testLiveAgentChat() 
	{
		map<string, id> availableRecordTypes = ViasatUtilityClass.getAvailableRecordTypes(Public_Chat_Greeting__c.SObjectType);
		
		Public_Chat_Greeting__c o1 = new Public_Chat_Greeting__c();
		o1.recordTypeId = availableRecordTypes.get('General/High Volume Message');
		o1.General_Message__c='Thanks';
		o1.High_Volume_Message__c='Thanks';
		o1.Message_to_be_displayed__c='General';
		insert o1;

		Public_Chat_Greeting__c o2 = new Public_Chat_Greeting__c();
		o2.recordTypeId = availableRecordTypes.get('Additional Messages' );
		o2.General_Message__c='Thanks';
		o2.High_Volume_Message__c='Thanks';
		o2.Message_to_be_displayed__c='High Volume';
		o2.Start_Date_Time__c = datetime.now();
		insert o2;
	
		LiveAgentChat lac = new LiveAgentChat();
		integer i = lac.getMinutesPerQueue();
		
		list<string> ss = lac.admsg;
	}
	
	// *** TEST LiveAgentNewCase
	public static testMethod void LiveAgentPreChat() 
	{
		LiveAgentPreChat oc = new LiveAgentPreChat();
		oc.CreateCase();
		Case c = oc.caseRecord;
	}
	
	// *** TEST LiveAgentNewCase
	public static testMethod void LiveAgentPostChat() 
	{
		LiveChatTranscriptDuplicate__c o = new LiveChatTranscriptDuplicate__c();
		insert o;
		
		LiveAgentPostChat oc = new LiveAgentPostChat();
		oc.CheckTranscript();
	}
	
	// *** TEST LiveAgentNewCase
	public static testMethod void testLiveAgentNewCase() 
	{
		// create Case
		list<Account> accounts = ViasatTestUtility.createAccounts(1, 'testAcc');
		insert accounts;
		list<Contact> contacts = ViasatTestUtility.createContacts(accounts, 1); 
		insert contacts;            
		Case c = ViasatTestUtility.generalCaseFromEmail;
		c.AccountID=accounts[0].Id;
		c.ContactID=contacts[0].Id;
		upsert c;
		
		LiveAgentNewCase oc = new LiveAgentNewCase();
		oc.TakeCaseOwnership();
	}
}