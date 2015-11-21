/**************************************************************************************************************
Name         : ITSMSSiteSearchController 
Created By   : Dianna Guilinger - Slalom 
Description  : Controller for VF Component ITSMSSiteSearch
             : Obtains passed parameters, manages page action
***************************************************************************************************************/
public class ITSMSSiteSearchController {
    public string siteSearchText {get;set;}

    public PageReference SelfHelpRedirect () {
        PageReference selfHelpPage = new PageReference('/apex/ITSMSSupportCenterSelfHelp?j_id0:j_id1:j_id102:j_id103:j_id104:j_id105:theSearchstring='+siteSearchText);
        if(siteSearchText !=null){
            selfHelpPage.setRedirect(true);
        }
       return selfHelpPage;  
    }    
    

}