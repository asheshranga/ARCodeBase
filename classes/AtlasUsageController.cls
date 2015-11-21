/*********************************************************************************
Name         : AtlasUsageController
Created By   : Ruba Devi T
Modified BY  : Ruba Devi T
Company Name : NTT Data
Project      : ViaSat Atlas, Bangalore
Created Date : 23 October 2013
Modified Date: 13 November 2013
Usages       : Controller for VisualForce Page: usage
*********************************************************************************/
public with sharing class AtlasUsageController extends AtlasDataManager {
        public list<AtlasBuyMoreDTO.buyMoreButton> lstString{get{return mainDTOObj.buyMoreDTOObj.buyMoreButtonList;}set;}
        public string strTitle{get{ return AtlasUtility.getMapValue(AtlasConstants.STRTITLE_USAGE);}set;}
        public string strHeader2{get{ return AtlasConstants.STRHEADER2_USAGE;}set;}
        public string strHeader3{get{ return AtlasConstants.STRHEADER3_USAGE;}set;}
        public String strDashboardUrl{get{return AtlasUtility.getURL(AtlasConstants.DASHBOARD);}set;}
        public string strDashboardText{get{return AtlasUtility.getHyperLinkText(AtlasConstants.DASHBOARD);}set;}
        public boolean isVisibleDashboard{get{return AtlasUtility.getVisibility(AtlasConstants.DASHBOARD);}set;}
        public string currentTime{get{ return '>>>>>'+System.now();}set;}
        public boolean refreshPollerExecutedOnce{get;set;}       
        public boolean refreshUsagePoller{
                get{
                        if(!AtlasUtility.isEmpty(mainDTOObj)&&!AtlasUtility.isEmpty(mainDTOObj.cduDTOObj)&&!refreshPollerExecutedOnce)
                                return mainDTOObj.cduDTOObj.refreshNow; 
                        else 
                                return false;
                }set;}
         public string pageName{get{return AtlasConstants.STRUSAGE;}set;} 
         public AtlasComponenttoController componentToPage {get; private set;}
         
	   /**
		* @author Raghuprasad Halakere 
		* @description zero parameter AtlasDashboardControllers constructor
		* @param object null
		* @return null
		*/    
        public AtlasUsageController()
        {
                Apexpages.currentPage().getHeaders().put(AtlasConstants.X_UA_COMPATIBLE,AtlasConstants.IE_8);
                refreshPollerExecutedOnce=false;
                componentToPage = new AtlasComponenttoController();
		        componentToPage.UsageGBInCorrect=false;
 			    componentToPage.PollerCount = 1;
        }
	   /**
		* @author Raghuprasad Halakere 
		* @description calls populateAtlasDashboardData method for usage page
		* @param object null
		* @return void
		*/  
        public  void callRemoteAtlasUsageData()
        {
                populateAtlasDashboardData();
                
        }
	   /**
		* @author Raghuprasad Halakere 
		* @description calls getCurrentDataUsageDashBoradData method for usage page
		* @param object null
		* @return void
		*/
        public  void currentDataUsageAtlasUsage()
        {		boolean tempRefresh=false;
        		if(!AtlasUtility.isEmpty(mainDTOObj)&&!AtlasUtility.isEmpty(mainDTOObj.cduDTOObj)&&mainDTOObj.cduDTOObj.refreshNow)
                {                refreshPollerExecutedOnce=true; 
                				tempRefresh=true;
                }
                getCurrentDataUsageDashBoradData();
                if(tempRefresh)
                	persistViewState();
        }
	   /**
		* @author Raghuprasad Halakere 
		* @description calls getMyAccountDashBoardData method for usage page
		* @param object null
		* @return void
		*/
        public  void myAccountAtlasUsage()
        {
                getMyAccountDashBoardData();
                
        }
	   /**
		* @author Raghuprasad Halakere 
		* @description calls getBillingSnapShotDashBoardDAta method for usage page
		* @param object null
		* @return void
		*/
        public  void billingSnapshotAtlasUsage()
        {
                getBillingSnapShotDashBoardDAta();
        }
	   /**
		* @author Raghuprasad Halakere 
		* @description calls getPlanDetails method for usage page
		* @param object null
		* @return void
		*/
        public  void usagePlanDetails()
        {
                getPlanDetails();
        }
	   /**
		* @author Raghuprasad Halakere 
		* @description calls getALaCartePackages method for usage page
		* @param object null
		* @return void
		*/
        public void usageBuyMore()
        {
                getALaCartePackages();
        }
	   /**
		* @author Raghuprasad Halakere 
		* @description 
		* @param object null
		* @return void
		*/
        public void addUsageQuota()
        {
        }
	   /**
		* @author Raghuprasad Halakere 
		* @description calls getCurrentDataUsageDashBoradData method for usage page
		* @param object null
		* @return void
		*/        
        public void refreshCurrentDataUsageOnBuyMore()
        {
               
                 getCurrentDataUsageDashBoradData();
        }
}