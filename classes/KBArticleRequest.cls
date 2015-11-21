/*
    Controller for the article request page. Creates a case based on the user input
        
    **********************************************************
    Audit History
    **********************************************************
    4/4/2013    Lucian Ciobanu      Created
    **********************************************************  
*/
public with sharing class KBArticleRequest {
    
    
   public boolean inConsole { get; set; }

    // New case to create
    public Case newCase { get; set; }
    
    // type of the contact, new or existing
    public string typeOfContact { get; set; }
    
    public boolean isArticle{get;set;}
    
     
    
    // requestor details 
    private Contact loginUserContact;
    
    public boolean isUpdateOrArchive
    {
    	get
    	{
    		if (!isTypeSelected)
    			return false;
    		
    		if (newCase.Type=='New Article') 
    			return false;	
    		
    		return true;
    	}
    	
   	}
    
    
     public void actionTypeChangeMethod()
     {
     	system.debug('newCase.Type-->'+newCase.Type);  
     	
   	
     	if(!isUpdateOrArchive)
     	{
     		newCase.Article__c = null;
			newCase.ArticleLink__c = null;
     		isArticle = false;     		
     	}
     	  	    	
      	
     }
     
     
         
      public boolean isTypeSelected 
      {
      	get
      	{
      		if (newCase.Type == null || newCase.Type =='')
      			return false;
      		
      		system.debug('isTypeSelected-->true'); 
      			
      		return true;	
      		
      	}	
      }
    
    
    
    
         
    public KBArticleRequest() {
        inConsole = false;
        if (!String.isEmpty(ApexPages.currentPage().getParameters().get('isdtp')))
            inConsole = true;
            
        // initialize case
        String caseRecordTypeName = KeyValueStoreHelper.getTextValue('ArticleRequestCaseRecordType');
        RecordType caserecordtype=[SELECT Id,Name FROM RecordType WHERE SObjectType = 'Case' AND recordType.name=:+caseRecordTypeName];
        this.newCase = new Case();
        this.newCase.Priority = 'Medium';
        this.newCase.RecordtypeId=caserecordtype.Id;
        this.caseSaved = false;
        isArticle = false;
        
        
        
       // Article number,name and link from KBViewArticle page will prepopulate to KBArticleRequest page 
       // and then map to Case fields.
		if(ApexPages.currentPage().getParameters().get('articleNumber') != null 
           && ApexPages.currentPage().getParameters().get('artName') != null
			&& ApexPages.currentPage().getParameters().get('articleLink') !=  null )			
			{
				isArticle = true;
				newCase.Article__c = ApexPages.currentPage().getParameters().get('articleNumber');
				newCase.ArticleName__c = ApexPages.currentPage().getParameters().get('artName');
				newCase.ArticleLink__c = ApexPages.currentPage().getParameters().get('articleLink');
			}       
        else
        {
        		isArticle = false;
        }
        
        retURL = ApexPages.currentPage().getParameters().get('retURL');
        string articleId = ApexPages.currentPage().getParameters().get('articleId');
        if (!String.isEmpty(articleId))
            setCategories(articleId); 
    }
    
    @TestVisible
    private void setCategories(Id articleId) {
       
       KnowledgeArticleVersion artic = KBSOQLHelper.knowledgeArticleQuery(articleId);
        string categorizationName = artic.ArticleType.replace('__kav', '__DataCategorySelection');
         
        List<sObject> categoriesWithLabels = database.query('SELECT Id, DataCategoryGroupName, toLabel(DataCategoryName) FROM ' + categorizationName + ' WHERE ParentId = \'' + artic.Id + '\'');

        boolean isExede = false;
        boolean isWildblue = false;
        for (sObject categoryWithLabel : categoriesWithLabels) {
            if ((string)categoryWithLabel.get('DataCategoryGroupName') == 'Denver_Product') {
                if ((string)categoryWithLabel.get('DataCategoryName') == 'Exede')
                    isExede = true;
                if ((string)categoryWithLabel.get('DataCategoryName') == 'WildBlue')
                    isWildBlue = true;
            }
            if ((string)categoryWithLabel.get('DataCategoryGroupName') == 'Care_Categories') {
                this.newCase.Category__c = (string)categoryWithLabel.get('DataCategoryName');
            }
        }
        if (isExede && isWildblue)
            this.newCase.Product_Family__c = 'Exede/WildBlue';
        if (isExede && !isWildblue)
            this.newCase.Product_Family__c = 'Exede';
        if (!isExede && isWildblue)
            this.newCase.Product_Family__c = 'WildBlue';
    }
     // true if the case was saved, false by default
    public boolean caseSaved { get; set; }
    
        
    // action to save the case. occurs when the user clicks "Submit"
    public void saveCase() {        
               
         try {
            String caseOrigin = KeyValueStoreHelper.getTextValue('ArticleRequestCaseOrigin');
            String caseRecordTypeName = KeyValueStoreHelper.getTextValue('ArticleRequestCaseRecordType');
            String caseStatus = KeyValueStoreHelper.getTextValue('ArticleRequestCaseStatus');
            
            RecordType rt = [SELECT Id FROM RecordType WHERE Name = :caseRecordTypeName AND sObjectType = 'Case'];
            newCase.RecordTypeId = rt.Id;
            newCase.Origin = caseOrigin;
            newCase.Status = caseStatus;
            
            newCase.Article__c = newCase.Article__c;
           	newCase.Subject = newCase.ArticleName__c ;
            newCase.ArticleLink__c = newCase.ArticleLink__c ;
            
            newCase.SuppliedName = UserInfo.getFirstName() + ' ' + UserInfo.getLastName();
            newCase.SuppliedEmail = UserInfo.getUserEmail();
            
            newCase.OwnerId = KeyValueStoreHelper.getTextValue('ArticleRequestOwnerId');
            
            insert newCase;
            caseLoaded = false;
            // We need the case number to be displayed in the page
            CheckCaseLoaded(); 
        } catch(Exception ex) {
            ApexPages.addMessages(ex);
            return;
        }
        
        caseSaved = true;
    }
    
    public boolean caseLoaded { get; set; }
    
    public void CheckCaseLoaded() {
        List<Case> newCases = [SELECT Id, CaseNumber FROM Case WHERE Id = :newCase.Id];
        if (newCases.size() > 0) {
            newCase = newCases.get(0);
            caseLoaded = true;
        }
    }
    
    private string retURL { get; set; }
    
    // action for the "Back" button
    public PageReference goBack() {
        if (String.isEmpty(retURL))
            return Page.KBHome;
        return new PageReference(retURL);
    }
    
    public void findLoginUserContactRecord() {
        User loginUser = [Select Email from User  where Id=:UserInfo.getUserId()];
        List<Contact> conts = [Select Id from Contact where Firstname=:UserInfo.getFirstname() and LastName=:UserInfo.getLastName() 
                                    and Email=:loginUser.Email limit 1];
        if (conts.size() == 1) {
            this.loginUserContact = conts.get(0);
        }
        else {
            this.loginUserContact = new Contact(Firstname=UserInfo.getFirstname(), Lastname=UserInfo.getLastname(), Email=loginUser.Email);
            insert loginUserContact;
        }
        newCase.ContactId = loginUserContact.Id;
    }
    

}