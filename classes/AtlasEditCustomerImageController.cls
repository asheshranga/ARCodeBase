/*********************************************************************************
Name         : AtlasEditCustomerImageController 
Created By   : Shiva Shankar
Modified BY  : Shiva Shankar
Company Name : NTT Data
Project      : ViaSat Atlas, Bangalore
Created Date : 29 October 2013
Modified Date : 13 November 2013
Usages       : Used In AtlasEditCustomerImage visualforce page
*********************************************************************************/
public with sharing class AtlasEditCustomerImageController{
	
	public String str{get;set;}
    public string strTitle{get{return AtlasUtility.getMapValue(AtlasConstants.STRTITLE_CustomerInfo);}set;}
    
    public AtlasEditCustomerImageController()
    {    
      try{	       
	        PageReference bl=Page.uploaduserimage;
	        bl.setRedirect(true);
	        Blob b = bl.getContent(); // this is returning blob from current page, not page tc_report...
	        
	        str=b.toString();
	       } catch(VisualforceException e){
	     
	    }
    
    }
    
}