/*****************************************************************
Name          : CCRCreateCaseController
Created By    : Anand Sanjeev
Company Name  : Slalom
Created Date  : October 2015
Modified Date :  
Purpose		  : Controller class for createCCRCase page
******************************************************************/
public class CCRCreateCaseController {
    
    private CCR__c ccr {get;set;}
    public static String CASE_RT = System.Label.CarlsbadNOCRecordType;
	public static String CASE_ACCT_FIELD_ID = CarlsbadNOCKeyValueStore__c.getInstance('CASE_ACCT_FIELD_ID').value__c;
    public static String CASE_SITE_FIELD_ID = CarlsbadNOCKeyValueStore__c.getInstance('CASE_SITE_FIELD_ID').value__c;
    public static String CASE_CCR_FIELD_ID = CarlsbadNOCKeyValueStore__c.getInstance('CASE_CCR_FIELD_ID').value__c;
    public static String CASE_PRODUCT_FIELD_ID = CarlsbadNOCKeyValueStore__c.getInstance('CASE_PRODUCT_FIELD_ID').value__c;
    public static String CASE_VIS_TO_CUST_FIELD_ID = CarlsbadNOCKeyValueStore__c.getInstance('CASE_VIS_TO_CUST_FIELD_ID').value__c;    
    public static String CASE_ORIGIN_FIELD_ID = CarlsbadNOCKeyValueStore__c.getInstance('CASE_ORIGIN_FIELD_ID').value__c;    
    public static String CASE_SUB_FIELD_ID = CarlsbadNOCKeyValueStore__c.getInstance('CASE_SUB_FIELD_ID').value__c;
    public static String CASE_DESC_FIELD_ID = CarlsbadNOCKeyValueStore__c.getInstance('CASE_DESC_FIELD_ID').value__c;
    
    public static String CASE_VIS_TO_CUST_FIELD_DEF_VAL = CarlsbadNOCKeyValueStore__c.getInstance('CASE_VIS_TO_CUST_FIELD_DEF_VAL').value__c;
    public static String CASE_ORIGIN_FIELD_DEF_VAL = CarlsbadNOCKeyValueStore__c.getInstance('CASE_ORIGIN_FIELD_DEF_VAL').value__c;

    public CCRCreateCaseController(ApexPages.StandardController controller) 
    {
        try 
        {
            ccr = [select id, subject__c, description__c, name from CCR__c where id = :controller.getId()];
        }
        catch (Exception e1) { 
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'This page is to be accessed from a CCR.')); 
           
        }
    }
    
    public pageReference redirect()
    {
      if(ccr != null)
      {    
        list<CCRSiteAssociation__c> siteAssoc = new list<CCRSiteAssociation__c>();
        
        if(ccr != null && ccr.id != null)
        siteAssoc = [select CCR__r.id, SiteNOC__r.id from CCRSiteAssociation__c where CCR__c = :ccr.id order by SiteNOC__r.name ASC Limit 1];
        
        if(!siteAssoc.isEmpty())
        {
            Site__c s = [select id, name, account__c,account__r.name,product__c, product__r.name from site__c where id = :siteAssoc[0].SiteNOC__r.id];
            String url = '/500/e?nooverride=1&RecordType=' + CASE_RT + '&retURL=/'+ccr.Id;            

            url = url + '&'+ CASE_ACCT_FIELD_ID + '_lkid=' + s.account__c + '&' +CASE_ACCT_FIELD_ID + '=' + s.account__r.name;
            url = url + '&'+ CASE_SITE_FIELD_ID + '_lkid=' + s.id + '&' +CASE_SITE_FIELD_ID + '=' + s.name;
            url = url + '&'+ CASE_CCR_FIELD_ID + '_lkid=' + ccr.id + '&' + CASE_CCR_FIELD_ID + '=' + ccr.name;
            url = url + '&'+ CASE_PRODUCT_FIELD_ID + '_lkid=' + s.product__c + '&' + CASE_PRODUCT_FIELD_ID + '=' + s.product__r.name;
            url = url + '&' +CASE_VIS_TO_CUST_FIELD_ID + '=' + CASE_VIS_TO_CUST_FIELD_DEF_VAL;
            url = url + '&' +CASE_ORIGIN_FIELD_ID + '=' + CASE_ORIGIN_FIELD_DEF_VAL;
            url = url + '&' +CASE_SUB_FIELD_ID + '=' + ccr.subject__c;
            url = url + '&' +CASE_DESC_FIELD_ID + '=' + ccr.description__c;
            PageReference pg =new PageReference (url);
            return pg;
        }
        else
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'A Site needs to be added to the CCR to automatically create a case.'));             
        
      }
      return null;  
    }
    
}