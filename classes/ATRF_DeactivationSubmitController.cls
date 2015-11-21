/*****************************************************************
Name          :  ATRF_DeactivationSubmitController
Created By    : Patrick Labaye
Company Name  : ViaSat
Project       : ATRF
Created Date  : Feb 2015
Modified Date : 
******************************************************************
*/

public class ATRF_DeactivationSubmitController 
{
	
	private Service_Request__c sr {get;set;}
	

	// initialize the controller
    public ATRF_DeactivationSubmitController(ApexPages.StandardController controller) 
    {
        // load the current record
        sr = (Service_Request__c)controller.getRecord();
    }

	
	public PageReference submitDeactivationToApproval()
	{
		String error=null;
		
			        
                				
		// Validate the request
		if (sr == null)
			error = 'Unable to retrieve record:' + sr.id;
		// Allow deactivation only in 'Active' or 'Expired' state
		else if ((sr.Status__c != 'Active') && (sr.Status__c != 'Expired')) 
			error = 'ATRF is not active or expired. Deactivation not allowed.';
			 
				
		if(error != null)
		{	
			string errorTxt = error;
			errorTxt += ' <a href=/' +sr.id + '>Go Back </a>';  			
			ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, errorTxt));
			return null;
		}
		
				
		try {
			  	
			Approval.ProcessSubmitRequest req = new Approval.ProcessSubmitRequest();
        	req.setObjectId(sr.Id);
        	req.setProcessDefinitionNameOrId('ATRF_Deactivation_Approval_Process_PM');
    		Approval.ProcessResult result = Approval.process(req);			                                      

         } 
         
         catch (Exception e)
         {             
         	string errorTxt = e.getMessage();
			errorTxt += ' <a href=/' +sr.id + '>Go Back </a>';  			
			ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, errorTxt));                          
               
            return null;
         }

         return new PageReference('/'+sr.id+'?retURL=%2F'+sr.id); // details
		
		
		
	}	
	
	
	
	
	
	
	
	
	
	
	
	
	
	


}