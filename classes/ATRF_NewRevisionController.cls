/*****************************************************************
Name          : ATRF_NewRevisionController
Created By    : Patrick Labaye
Company Name  : ViaSat
Project       : ATRF
Created Date  : Feb 2015
Modified Date : Nov 2015, Modified by Anand Sanjeev Case 602189 Adding logic for filtering out archived sites when creating new revision
			    Nov 2015, Modified by Anand Sanjeev Moving the fields which needs to be cloned to ATRFNewRevision fied set to enable adding new  fields without code change
******************************************************************/


public with sharing class ATRF_NewRevisionController 
{
	private Service_Request__c sr {get;set;}
	public Id newSrId {get; set;} // for unit test only	

	// initialize the controller
    public ATRF_NewRevisionController(ApexPages.StandardController controller) {

        // load the current record
        sr = (Service_Request__c)controller.getRecord();
    }
	
	public PageReference cloneWithServiceRequestSites()
	{
		String error=null;
        
		// Validate the request
		if (sr == null)
			error = 'Unable to retrieve record:' + sr.id;
		// if current is in 'Submitted' status, cannot create a revision
		else if ((sr.Status__c != 'Active') && (sr.Status__c != 'Expired')) 
			error = 'Revision can only be created for an Active or Expired ATRF.';
		
		ID originalVersionId;
		Decimal revisionNumber;	 
		 
		if(error == null)
		{
			// set original version
			originalVersionId = (sr.ATRF_OriginalVersion__c != null)?sr.ATRF_OriginalVersion__c:sr.Id;
			
			// retrieve the max revision number for this original version
			list <Service_Request__c> revisions = [select Id, ATRF_Revision_Number__c from Service_Request__c where ATRF_OriginalVersion__c = :originalVersionId order by ATRF_Revision_Number__c desc limit 1];
     
     		if (revisions == null || revisions.size() == 0)
     			// no max - starting 1st revision
     			revisionNumber=1;
     		else if (sr.Id != revisions[0].Id)
     			error = 'Please go to the max revision to create a new revision'; 	
     		else
     			revisionNumber=revisions[0].ATRF_Revision_Number__c+1;	     				
		}
		
		if(error != null)
		{	
			string errorTxt = error;
			errorTxt += ' <a href=/' +sr.id + '>Go Back </a>';  			
			ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, errorTxt));
			return null;				
		}
		
		// setup the save point for rollback
        Savepoint sp = Database.setSavepoint();
        Service_Request__c newSr;

		try {
             newSr = sr.clone(false);
             
             newSr.ATRF_OriginalVersion__c=originalVersionId;
             // JIRA SFP-21
             // newSr.ATRF_Revision_Number__c=revisionNumber;
             newSr.ATRF_Revision_Number__c=null;
             newSr.ATRF_PreviousRevision__c=sr.id;
             newSr.Status__c = 'Change Requested';   
             
             insert newSr;
             
             // copy over the service request site items - ONLY INCLUDE THE FIELDS We want to clone             
             List<ServiceRequestSite__c> items = new List<ServiceRequestSite__c>();
             
             Set<String> setOfStatusToAvoid = ServiceRequestHelper.getSiteStatusesToAvoid();
             //Nov 15, Changed for case 00602189
             //Copy over only sites which are not archived
             for (ServiceRequestSite__c srs : [Select ServiceSite__c, RecordTypeId, PriorityAccess__c  From ServiceRequestSite__c
                                               where ServiceRequest__c = :sr.id
                                               and ServiceSite__r.Status__c NOT IN :setOfStatusToAvoid]) 
             {
                  ServiceRequestSite__c newSrs = srs.clone(false);
                  newSrs.ServiceRequest__c = newSr.id;
                  items.add(newSrs);
             }
             insert items;

			 newSrId = newSr.Id; // for unit test	
			 
			 // JIRA SFP-21
			 // Update the revision number: indicates the creation is done
			 newSr.ATRF_Revision_Number__c=revisionNumber;		 
			 update newSr;		 
         } 
         
         catch (Exception e)
         {
             // roll everything back in case of error
            Database.rollback(sp);
                                   
         	string errorTxt = e.getMessage();
			errorTxt += ' <a href=/' +sr.id + '>Go Back </a>';  			
			ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, errorTxt));                          
               
            return null;
         }
         
        return new PageReference('/'+newSr.id+'/e?retURL=%2F'+newSr.id); // edit
        // return new PageReference('/'+newSr.id+'?retURL=%2F'+newSr.id); // details
	}
}