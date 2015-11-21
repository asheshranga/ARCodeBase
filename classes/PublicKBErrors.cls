/*
    Utility class to handle the public KB errors
        
    **********************************************************
    Audit History
    **********************************************************
    5/14/2013    Lucian Ciobanu      Created
    **********************************************************  
*/
public with sharing class PublicKBErrors {

	// Add an error from an exception and return the tracking number
	public static string AddError(Exception ex) {
		
		KnowledgeError__c error = new KnowledgeError__c();
		error.Application__c = 'KBExternal';
		error.Status__c = 'Open';
		error.User__c = UserInfo.getUserId();
		error.MoreInformation__c = ex.getMessage();
		error.ErrorDescription__c = ex.getStackTraceString();
		insert error;
		
		error = [SELECT Name FROM KnowledgeError__c WHERE Id = :error.Id];
		
		return error.Name;
	}

	// Add an error and return the tracking number
	public static string AddError(String moreInfo, String errorDesc) {
		
		KnowledgeError__c error = new KnowledgeError__c();
		error.Application__c = 'KBExternal';
		error.Status__c = 'Open';
		error.User__c = UserInfo.getUserId();
		error.MoreInformation__c = moreInfo;
		error.ErrorDescription__c = errorDesc;
		insert error;
		
		error = [SELECT Name FROM KnowledgeError__c WHERE Id = :error.Id];
		
		return error.Name;
	}

}