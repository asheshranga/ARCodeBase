/*********************************************************************************
Name         : ATRFServiceRequestListController
Created By   : Lynnet Ambrocio
Company Name : Slalom Consulting
Project      : ATRF 2.0
Created Date : 9/2/2015
Usages       : Controller for Visualforce Page: ATRFServiceRequestList
*********************************************************************************/
public class ATRFServiceRequestListController {

    private ApexPages.StandardController controller {get; set;}
    public List<ServiceRequestSite__c> searchResults {get;set;}
    public String pageTitle {get;set;}
    public Boolean showLink {get;set;}
    public Integer rowCount {get;set;}
    public String siteId {get;set;}

    public ATRFServiceRequestListController (ApexPages.StandardController controller) {

        //initialize the standard controller
        this.controller = controller;
        
        String showPage = ApexPages.currentPage().getParameters().get('showPage');
        
        if (showPage == 'true') {
            searchList(true);
            
        } else {
            searchList(false);
        }
    }
    
    private PageReference searchList(Boolean showAll) {
        try {
            siteId = ApexPages.currentPage().getParameters().get('Id');
            searchResults = new List<ServiceRequestSite__c>();
            Set<String> statusList = new Set<String>{ 'Submitted', 'Approved', 'Active' };
            
            //create search query
            String searchQuery = 'SELECT ServiceRequest__r.Id, ServiceRequest__r.Name, '+
                                    'ServiceRequest__r.Status__c, '+
                                    'ServiceRequest__r.ViaSatProgramManager__c, '+
                                    'ServiceRequest__r.Owner.Name, '+
                                    'ServiceRequest__r.ATRF_Date_to_Activate__c, '+
                                    'ServiceRequest__r.ATRF_Date_to_Terminate__c, '+
                                    'ServiceRequest__r.ATRF_Tiered_Service_Plan__c, '+
                                    'ServiceRequest__r.ATRF_Map_Bundle__c, '+
                                    'ServiceRequest__r.ATRF_APR_Blanking__c, '+
                                    'ServiceRequest__r.ATRF_Sat_Search__c '+
                                'FROM ServiceRequestSite__c ';
            
            String firstQuery = searchQuery + 'WHERE ServiceRequest__r.Status__c IN :statusList AND ServiceSite__c = :siteId '+
                      'ORDER BY ServiceRequest__r.Status__c DESC';
            
            //add limit of 5 for related list display
            if (!showAll) firstQuery = firstQuery + ' limit 5';
                 
            searchResults = Database.query(firstQuery);
            
            //create search query
            String archived = 'Archived';
            String secondQuery = searchQuery + 'WHERE ServiceRequest__r.Status__c = :Archived AND ServiceSite__c = :siteId';
                 
            //add limit of 5 for related list display
            if (!showAll) secondQuery = secondQuery + ' limit 5';
            
            searchResults.addAll((List<ServiceRequestSite__c>)Database.query(secondQuery));
            
            if (!showAll) {
                pageTitle = null;
                showLink = true;
                rowCount = 5;
            } else {
                //show all and add title for page display
                pageTitle = 'Service Requests';
                showLink = false;
                rowCount = searchResults.size();
            }
            
        } catch (Exception e) {
            System.debug('ATRFServiceRequestList Error:' + e);
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Cannot display list. Please contact System Administrator.'));
        }
        
        return null;
    }
}