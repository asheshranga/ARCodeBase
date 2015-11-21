public class AtlasKnowledgeLinkPage {

    //public String strKnowledgebaseSearch; 
    //public string redirectURL{get;set;}  
    public String articleId;
    public String articleType;
    public String articleUrlName;
    public String articleRedirectUrl;
    public String customerUserId;
    public String PageUrl;
    Integer PageUrlpart1;
    Integer PageUrlpart2;
    public String ref;
    public AtlasTransactionHistory__c artTransc;
    public AtlasKnowledgeLinkPage(){
        //strKnowledgebaseSearch=URL.getSalesforceBaseUrl().toExternalForm();
        //redirectURL = AtlasConstants.KB_URL+'/publickbhome?dosearch=1&searchKeyword='; 
        articleId = ApexPages.currentPage().getParameters().get('aticleId'); 
        customerUserId = ApexPages.currentPage().getParameters().get('customerId'); 
        articleType = ApexPages.currentPage().getParameters().get('articleType'); 
        articleUrlName = ApexPages.currentPage().getParameters().get('articleUrlName'); 
        PageUrl= ApexPages.currentPage().getUrl(); 
        PageUrlpart1= PageUrl.indexOf('apex/');
        PageUrlpart2= pageUrl.indexOf('?');
        ref= PageUrl.substring(PageUrlpart1,PageUrlpart2);    
        system.debug('@@@@@@ customerid'+customerUserId );
        system.debug('@@@@@@ articleId '+articleId );
    }
    
    public PageReference redirect(){  
        
        articleRedirectUrl = AtlasConstants.KB_URL+'/articles/' + articleType + '/' + articleUrlName;
        
        system.debug('@@@@@@@@@@ articleId' + articleId);
        system.debug('@@@@@@@@@@ customerUserId' + customerUserId);
        
        artTransc = new AtlasTransactionHistory__c();
        artTransc.transactionDescription__c = 'Kb article';
        artTransc.KBArticleUrl__c = articleRedirectUrl;
        artTransc.SessionID__c = userinfo.getSessionId();
        artTransc.transactionStatus__c = 'Success';
        artTransc.transactionType__c = 'Kb article';
        artTransc.transactionModule__c ='Knowledge';
        artTransc.KBArticleReferer__c=ref;
        artTransc.KBArticleId__c=articleId;
        artTransc.KBArticleType__c= articleType;
        arttransc.LoggedInUser__c=UserInfo.getUserId();
        if(customerUserId != null){
            arttransc.customerName__c = customerUserId;
            }
        system.debug('@@@@@@@@@@' + arttransc.customerName__c);
        List<User> lstUser=[select id,Account_Number__c from user where id=:arttransc.LoggedInUser__c limit 1];
        String test=lstuser[0].Account_number__c;
        system.debug('@@@@@@@@@@' + test);
        //calling DatabaseManager method
        AtlasDatabaseManager.insertTransaction(artTransc);
        pagereference page=new pagereference(articleRedirectUrl);
        page.setRedirect(true);
        return page;
    }
}