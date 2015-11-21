/*********************************************************************************
Name :   caseRedirect 
Created By  : Sneha Chail
Modified Date : 09/26/2014
Project  : Viasat Support
Usage : Case record type will be redirected to the appropriate case page layout.
*********************************************************************************/
public with sharing class caseRedirect 
{
private ApexPages.StandardController controller;
public String retURL {get; set;}
public String saveNewURL {get; set;}
public String rType {get; set;}
public String cancelURL {get; set;}
public String ent {get; set;}
public String confirmationToken {get; set;}

public string defAccountId{get;set;}
public string defContactId{get;set;}
public string defEntitlementid{get;set;}

public string siteID {get;set;}
public Site__c sites{get;set;}
public string AccountId{get;set;}
public string ProductId{get;set;}
public string ProductName{get;set;}

// Collection of custom setting
public static Map<String,CaseKeyValueStore__c> caseKeyValue = CaseKeyValueStore__c.getAll();

public boolean autoPopulateAccount {get;set;}
public string profileName{get;set;}
public boolean selectRecordType 
{
    get
    {
        return (profileName != 'ViaSat NOC Customer Portal');
    }
}
      
public caseRedirect(ApexPages.StandardController controller) 
{
    // Fetch standard Url parameters
    this.controller = controller;    
    retURL = ApexPages.currentPage().getParameters().get('retURL');
    rType = ApexPages.currentPage().getParameters().get('RecordType');
    cancelURL = ApexPages.currentPage().getParameters().get('cancelURL');
    ent = ApexPages.currentPage().getParameters().get('ent');
    confirmationToken = ApexPages.currentPage().getParameters().get('_CONFIRMATIONTOKEN');
    saveNewURL = ApexPages.currentPage().getParameters().get('save_new_url');  
    
    // Fetch Url parameters if case originated from Contact
    defContactId = ApexPages.currentPage().getParameters().get('def_contact_id');
    defAccountId = ApexPages.currentPage().getParameters().get('def_account_id');
    defEntitlementid = ApexPages.currentPage().getParameters().get('def_entitlement_id');
    
    autoPopulateAccount = true;
        
    // Fetch Url parameters if case originated from Site
    siteID = ApexPages.currentPage().getParameters().get('SiteId');
    
    AccountId= ApexPages.currentPage().getParameters().get('AccountId');     
    ProductId= ApexPages.currentPage().getParameters().get('ProductId'); 
    if (ProductId == null)
        ProductId= ApexPages.currentPage().getParameters().get('Product_lkid');
    ProductName= ApexPages.currentPage().getParameters().get('ProductName');
    if(ProductName== null)
        ProductName= ApexPages.currentPage().getParameters().get('Product');
        
    profileName=[Select Id, Name, usertype from Profile where Id=:userinfo.getProfileId()].Name; 
    
system.debug('*** ' + defContactId + ', ' + retURL + ', ' + defAccountId + ', ' + rType + ', ' + saveNewURL + ', ' + AccountId + ', ' + ', ');
}

    private static CaseKeyValueStore__c getSetting(string settingName)
    {
        if (caseKeyValue == null)
            caseKeyValue = CaseKeyValueStore__c.getAll();
        return caseKeyValue.get(settingName);
    }
  
    // If user's profile = ViaSat NOC Customer Portal -> Viasite VF Page, else STANDARD Case Page
    public PageReference redirect() 
    {
        PageReference returnURL;
        
        //String baseURL = URL.getSalesforceBaseUrl().toExternalForm();     
        String recordTypeName = '';     
        if (rType != null)
        {
            Map<ID, Schema.RecordTypeInfo> rtMap = Schema.SObjectType.Case.getRecordTypeInfosById();
            recordTypeName = rtMap.get(rType).getName();
        }
          
        // Today: redirect if profileName=='ViaSat NOC Customer Portal', else - Standard Case page
        CaseKeyValueStore__c redirect = getSetting('Profile:'+profileName);     
        if (siteID==null && redirect != null && redirect.Value__c != null)
            returnURL = new PageReference(redirect.Value__c); //new PageReference(baseURL + redirect.Value__c);
        else 
            returnURL = new PageReference('/500/e');//new PageReference(baseURL + '/500/e');                    

        if (retURL != null) returnURL.getParameters().put('retURL', retURL);
        if (rType != null)  returnURL.getParameters().put('RecordType', rType);
            
        if (cancelURL!=null)    returnURL.getParameters().put('cancelURL', cancelURL);
        if (ent!=null)  returnURL.getParameters().put('ent', ent);
        if (confirmationToken!=null)    returnURL.getParameters().put('_CONFIRMATIONTOKEN', confirmationToken);
        if (saveNewURL!=null)   returnURL.getParameters().put('save_new_url', saveNewURL);   
        returnURL.getParameters().put('nooverride', '1'); 

        // If case created from the Contact - pre-populate account & contact
        if (defAccountId != null)
            returnURL.getParameters().put('cas4_lkid', defAccountId);
        if (defContactId != null)
        {
            returnURL.getParameters().put('cas3_lkid',defContactId);
            //returnURL.getParameters().put('cas10_ileinner',defContactId);
            //returnURL.getParameters().put('cas9_ilecell',defContactId);
        }
        if (defEntitlementid != null)
            returnURL.getParameters().put('def_entitlement_id', defEntitlementid); // Entitlement_lkid
        
        // Add parameters if case originated after Site selected
system.debug('*** ' + profileName + ', ' + recordTypeName + ', ' + returnURL);

        if (siteID != Null)
        {
            // If case created from the site & site's recordtype is 'Aviation - Commercial' - DO NOT POPULATE Account 
            site__c s = [select recordtype.Name, name from site__c where name =:siteID or id =:siteID];
            if (s!= null)
                autoPopulateAccount = !(s.recordtype.Name == 'Aviation - Commercial');
            
        //if(recordTypeName.contains(MapKeyValue.get('NOCCaseRecordTypes').Value__c) || recordTypeName==MapKeyValue.get('SupportCaseRecordTypes').Value__c || 
        //   recordTypeName==MapKeyValue.get('SupportServicesProfile').Value__c)
            returnURL.getParameters().put(getSetting('FieldID:Site').Value__c,s.Name); //iteID);
        //if(recordTypeName.contains(MapKeyValue.get('NOCCaseRecordTypes').Value__c) || recordTypeName==MapKeyValue.get('SupportCaseRecordTypes').Value__c )
            returnURL.getParameters().put(getSetting('FieldID:Site').Value__c + '_lkwgt',s.Name); //siteID);
        }
        
        if (AccountId != null && autoPopulateAccount)
        {
            if(defAccountId == null) returnURL.getParameters().put('cas4_lkid',AccountId);
            returnURL.getParameters().put('AccountId',AccountId);
        }   
        if(ProductId!=Null) returnURL.getParameters().put('Product_lkid',ProductId);
        if(ProductName!=Null) returnURL.getParameters().put('Product',ProductName);   
        
        returnURL.setRedirect(true);
system.debug('*** returnURL: ' + returnURL);
        return returnURL;  
    }      
 }