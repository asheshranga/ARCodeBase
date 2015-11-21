global class WispCustomerInformationController extends AtlasDataManager{
	
	public string profileId{get;set;}
	public string strHyperLinkAddressWispDashboard{get{return AtlasUtility.getWispURL(AtlasConstants.Wisp_Dashboard);}set;}
	public string strHyperLinkAddressWispPrivacyPolicy{get{return AtlasUtility.getWispURL(AtlasConstants.WispPrivacyPolicy);}set;}
	public WispCustomerInformationController(){
		profileId = UserInfo.getUserID();
		populateWispDashboardData();
		system.debug('----Profile Id-----'+profileId);
	}
	
	/**
    * @author Srikanth Kudumula
    * @description - cancelException for WispCustomerInformationQuestionsController
    * @input param  - null
    * @return param null
    */     
    public PageReference cancelException()
    {
       // isVisibleExceptionMessage = false;
        //isVisibleSuccessAlert=false;
        
 		string url = '/apex/subscriber_dashboard?firstTime=false&Id=' + profileId; 
        string siteURl =site.getBaseUrl();
        if(!AtlasUtility.IsEmpty(siteURl)) {              
            PageReference page = new PageReference(siteURl+'/subscriber_dashboard');
            page.setRedirect(true);
            return page;
        }
        else {
            PageReference page1 = new PageReference(url);
            page1.setRedirect(true);
            return page1;    
        }
    }
	
}