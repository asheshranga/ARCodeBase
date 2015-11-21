public with sharing class WispAdminAgentCreationController {
	public string userName{get;set;}
	public string firstName{get;set;}
	public string lastName{get;set;}
	public string emailId{get;set;}
	public string phoneNumber{get;set;}
	public string selectedpartner{get;set;}
	public boolean isSuccess{get;set;}
	public string emailDomain{get{return AtlasUtility.getMapWispValue(AtlasConstants.Wisp_New_User_Email_Domain);}set;}
	public string WispAccRecordtype{get{return AtlasUtility.getMapWispValue(AtlasConstants.Wisp_Account_Recordtype);}set;} 
	public Account con;
	Public String PartnerName{get{ Account a = [select name from Account where id =: con.Id Limit 1]; return a.Name;}set;}
	public WispAdminAgentCreationController(ApexPages.StandardController stdController){
		this.con = (Account)stdController.getRecord();
		isSuccess = false;
	}
	
	Public PageReference CreateAgent(){
		Savepoint sp = Database.setSavepoint();
		try{
			// create account
			Account accObj= [select id from Account where id =: con.Id];
            
            //create contact
            Contact conObj= new Contact();
            conObj.AccountId=accObj.id;
            conObj.Email=emailId;
            conObj.Phone=phoneNumber;
            conObj.FirstName = firstName;
            conObj.LastName = lastName;
            conObj.OwnerId = AtlasUtility.getMapWispValue(AtlasConstants.Wisp_Account_Owner);
            insert conObj;
            
            //create user
            User userObj = new User();
            userObj.FederationIdentifier= userName;

            userObj.Email = userName+emailDomain;
            userObj.Username = userName+emailDomain;
            userObj.Lastname = lastName;
            userObj.Firstname = firstName;
            userObj.ContactId=conObj.Id;
            if(lastName.length() > 4)
            {
                userObj.Alias = firstName.substring(0,1) + lastName.substring(0, 4);
            }
            else
            {
                userObj.Alias = firstName.substring(0,1) + lastName ;
            }
            userObj.CommunityNickname = 'Wisp'+username;
            string profileId = atlasutility.getMapWispValue(atlasconstants.WISP_Admin_Community);
            SObject prof = [ select id from profile where Id =: profileId];
            userObj.ProfileId = (ID) prof.get('ID');
            userObj.TimeZoneSidKey = 'America/Los_Angeles';
            userObj.LocaleSidKey = 'en_US';
            userObj.EmailEncodingKey = 'ISO-8859-1';
            userObj.LanguageLocaleKey = 'en_US';
            userObj.UserPermissionsMobileUser = false;
            //userObj.Account_Number__c=componentToPage.internalAccReference;
            userObj.CommunityUserAccountType__c = 'Wisp';
            userObj.Functional_Group__c = 'Customer Portal';                        
            userObj.Assignment_Group_Active__c = false;
            insert userObj;
            
            clearFields();
            isSuccess = true;
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Info, 'Agent Record is Created Successully.'));
		}
		catch(exception ex){
			Database.rollback(sp);
			ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, ex.getMessage()));
		}
		return null;
	}
	
	public pagereference Cancel(){
		PageReference pr = new PageReference('/'+con.Id);
		pr.setRedirect(true);
		return pr;
	}
	
	public pagereference ReturntoAccount(){
		PageReference pr = new PageReference('/'+con.Id);
		pr.setRedirect(true);
		return pr;
	}
	
	public void clearfields(){
		this.userName = '';
		this.phoneNumber = '';
		this.firstName = '';
		this.lastName = '';
		this.emailId = '';
		this.partnerName = '';
	}
}