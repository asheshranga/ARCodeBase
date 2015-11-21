/*********************************************************************************
Name 		: KBSOQLHelper Class
Created By  : Mohantesh Kanike
Created Date: 11-SEP-2014	 
Project  	: ViaSat Support Tooway
Usage 		: KBSOQLHelper Class for SOQL query in KB*.cls, PublicKB*.cls, Case*.cls,CCR*.cls
*********************************************************************************/

global class KBSOQLHelper {
	
	/**
		* @description - Dynamic Method for KBArticleRequest, KBViewArticle and PublicKBViewArticle Class. 
		* @param object articleId.
	*/  
	public static KnowledgeArticleVersion knowledgeArticleQuery(Id articleId)
	{
		KnowledgeArticleVersion knowQuery = [SELECT Id, Title, Summary, UrlName, ArticleType,ArticleNumber,KnowledgeArticleId,VersionNumber FROM KnowledgeArticleVersion 
											WHERE Id = :articleId UPDATE VIEWSTAT]; 
										 
		return knowQuery;						 
	}
	
	/**
		* @description - Dynamic Method for KBHomeCtrlrTest and KBViewArticleTest Class. 
		* @param object publishStatus, language.
	*/
	public static  KnowledgeArticleVersion knwldgeArtPubOnline(String publishStatus, String language)
	{
		KnowledgeArticleVersion knowStatQuery = [SELECT Id, Title, Summary, UrlName, ArticleType,ArticleNumber FROM KnowledgeArticleVersion 
										Where PublishStatus = 'Online' AND	Language = 'en_US' limit 1];
		return knowStatQuery;								
									
	}	
	
	/**
		* @description - Dynamic Method for KBHomeSearchResults and PublicKBHomeSearchResults Class . 
		* @param object pageArticleIds.
	*/
	public static String strArtQuery(List<Id> pageArticleIds)
	{
		String knowStringQuery = 'SELECT Id, Title, Summary, UrlName, IsVisibleInPkb, ArticleType,ArticleNumber FROM KnowledgeArticleVersion Where Id IN :pageArticleIds';
		return knowStringQuery;								
									
	}
	
	/**
		* @description - Dynamic Method for KBHomeCtrlrTest and PublicKBHometest Class . 
		* @param object objList.
	*/
	public static List<KnowledgeArticleVersion> knowArtQueryList(List<sObject> objList)
	{
		List<KnowledgeArticleVersion> knowQueryList = [SELECT knowledgeArticleId, ArticleType,Title, Summary, UrlName, ArticleNumber from KnowledgeArticleVersion 
													  where id in :objList];
										 
		return knowQueryList;						 
	}	
	
	/**
		* @description - Dynamic Method for CaseCreateController, CaseEscalation, CaseRedirectTest , CCRCreateCaseController 	
							and NBNDispatchonTimeTest  Class. 
		* @param object caseId.
	*/
	public static Case caseQuery(Id caseId) 
	{
		Case caseInput = [select id,AccountId,casenumber,productid, status, Ownerid,Labor_Hours_Required__c,
						  NetworkPicklist__c,SoftwareVersion__c,SubSystem__c,EstimatedInitialResponseTime__c,Steps_to_Follow__c,FirmwareVersion__c,
                          Priority,Type,ContactId,PrioritybasedonType__c,CustomerTicket__c,Origin,Subject,Description,recordtypeId,StatusDetails__c,
                          AccountName__c,Location__c,ProductType__c,Redundant__c,SentEmail__c,AvailableonSite__c,DeliveryDateTime__c,DispatchTime__c,DispatchMethod__c,DispatchMethodDetails__c,
                          RequestRMARequired__c,RMARequest__c,Comment__c,InitialResponseProvidedAt__c,ElapsedTimeToInitialResponse__c,CalloutStatus__c,CalloutStartTime__c,CalloutEndTime__c,
                          Date_Needed_By__c,VisibleToCustomer__c,EstimatedWorkaroundTime__c,WorkaroundDescription__c,WorkaroundProvidedAt__c,EntitlementId,ElapsedTimeToWorkaround__c,
                          EstimatedResolutionTime__c,ResolutionDescription__c,ResolutionProvidedAt__c,ElapsedTimeToResolution__c from Case where id=:caseId];
		return caseInput;
	}
	

	
}