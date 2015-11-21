/*****************************************************************
Name          : PublicKBErrorRedirectToSearch
Created By    : Sneha Chail
Purpose       : Case # 139392
Created Date  : November 6, 2014
Modified Date : November 13, 2014
******************************************************************
*/

Public Class PublicKBErrorRedirectToSearch{

    public pageReference ErrorRedirect() 
    {
        String OriginalUrl=site.getOriginalUrl();
        system.debug('OriginalUrl......'+OriginalUrl);   
        pageReference pageRedirect;
        
        if (OriginalUrl != null) 
        	pageRedirect = new pageReference('/apex/publickbhome?dosearch=1&searchKeyword='+OriginalUrl);
        else
        	pageRedirect = new pageReference('/apex/publickbhome?dosearch=1'); // go to search with no keyword - PL
        	
        pageRedirect.setRedirect(true);
        return pageRedirect;
    }       
}