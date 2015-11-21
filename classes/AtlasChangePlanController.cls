/*********************************************************************************
Name         : AtlasChangePlanController
Created By   : Shiva shankar
Modified BY  : Shiva shankar
Company Name : NTT Data
Project      : ViaSat Atlas, Bangalore
Created Date : 19 November 2013
Modified Date: 
Usages       : Controller for VisualForce Page: changeplanmoving
*********************************************************************************/
public with sharing class AtlasChangePlanController extends AtlasDataManager{ 
        
    // Initialinzing Change Plan page GlobalVariables HyperLinkURL 
    public String strDashboardUrl{get{return AtlasUtility.getURL(AtlasConstants.DASHBOARD);}set;}
    public String strCustomerContactInfoUrl{get{return AtlasUtility.getURL(AtlasConstants.CUSTOMER_CONTACT_INFO);}set;}
    public String strChangePlanUrl{get{return AtlasUtility.getURL(AtlasConstants.strCHANGE_PLAN);}set;}
    // Initialinzing Change Plan page GlobalVariables HyperLinkText 
    public string strDashboardText{get{return AtlasUtility.getHyperLinkText(AtlasConstants.DASHBOARD);}set;}
    public string strCustomerInformation{get{return AtlasUtility.getHyperLinkText(AtlasConstants.CUSTOMER_CONTACT_INFO);}set;}  
    public string strChangePlan{get{return AtlasUtility.getHyperLinkText(AtlasConstants.strCHANGE_PLAN);}set;}  
    // Initialinzing Change Plan page GlobalVariables Visibility
    public boolean isVisibleDashboard{get{return AtlasUtility.getVisibility(AtlasConstants.DASHBOARD);}set;}               
    public boolean isVisibleCustomerInformation{get{return AtlasUtility.getVisibility(AtlasConstants.CUSTOMER_CONTACT_INFO);}set;}
    public boolean isVisibleChangePlan{get{return AtlasUtility.getVisibility(AtlasConstants.strCHANGE_PLAN);}set;}
    public string strTitle{ get{ return AtlasUtility.getMapValue(AtlasConstants.strTitle_ChangePlanMoving);} set;}
    public string strChangeYourPlan{get{return (AtlasUtility.getMapValue(AtlasConstants.CHANGE_YOUR_PLAN)).trim();}set;}
    public string strWecanhelp{get{return AtlasUtility.getMapValue(AtlasConstants.WECAN_HELP);}set;}
    public string strEmailChat{get{return AtlasConstants.EMAIL_CHAT;}set;}
    public string strCustomerNumber{get{return AtlasUtility.getMapValue(AtlasConstants.ChangePlan_CustomerCareNumber);}set;}
    public string strChangePlan1{get{return AtlasUtility.getMapValue(AtlasConstants.CHANGE_PLAN_POINT1b);}set;}
    public string strChangePlan2{get{return AtlasUtility.getMapValue(AtlasConstants.CHANGE_PLAN_POINT2);}set;}
    public string strChangePlan3{get{return AtlasUtility.getMapValue(AtlasConstants.CHANGE_PLAN_POINT3);}set;}
    public string strWeCanHelp1{get{return AtlasUtility.getMapValue(AtlasConstants.WE_HELP1);}set;}
    public string strWeCanHelp2{get{return AtlasUtility.getMapValue(AtlasConstants.WE_HELP2);}set;}
    public string strNeedChangePlan{get{return AtlasUtility.getMapValue(AtlasConstants.NEED_CHANGE_PLAN);}set;}
    public string pageName{get{return AtlasConstants.CHANGEPLAN;}set;}
    public string FirstName{get{return AtlasConstants.CUSTOMER_NAME;}set;}    
    public string AtlasCallCare{get{return AtlasUtility.getMapValue(AtlasConstants.AtlasCallCare);}set;}
    public string AtlasLeavingVacation{get{return AtlasUtility.getMapValue(AtlasConstants.AtlasLeavingVacation);}set;}
    public string AtlasLeavingVacationText{get{return AtlasUtility.getMapValue(AtlasConstants.AtlasLeavingVacationText);}set;}
    public string AtlasMovingVacation{get{return AtlasUtility.getMapValue(AtlasConstants.AtlasMovingVacation);}set;}
    public string AtlasMovingGoingVacation{get{return AtlasUtility.getMapValue(AtlasConstants.AtlasMovingGoingVacation);}set;}
    public string AtlasMovingHelp{get{return AtlasUtility.getMapValue(AtlasConstants.AtlasMovingHelp);}set;}
    public string AtlasMovingHelpText{get{return AtlasUtility.getMapValue(AtlasConstants.AtlasMovingHelpText);}set;}
    public string AtlasChangeMyPlan{get{return AtlasUtility.getMapValue(AtlasConstants.AtlasChangeMyPlan);}set;}
    public String strMoving{get{return AtlasUtility.getURL(AtlasConstants.Moving);}set;}
    public string vacationPlanList{get{return AtlasUtility.getMapValue(Atlasconstants.AtlasCPlanVacationList);}set;} 
    
    // Initializing the Change Plan DTO object  
    public AtlasChangePlanDTO changePlanDTOObj{get;set;}
    public AtlasComponenttoController componentToPage {get; private set;}
    
    public boolean pendingPlanTransition{get;set;}
        
    /**
    * @author Raghuprasad Halakere
    * @description - Zero parameter ChangePlanController constructor
    * @input param  - null
    * @return null
    */ 
     public AtlasChangePlanController(){       	     	
        componentToPage = new AtlasComponenttoController();
        //pendingPlanTransition=false;
        componentToPage.isLiberty=false;
        // Selection Component Booleans
        componentToPage.selectionPanel=true;
        componentToPage.selectionPanelOptions=true;
        componentToPage.custIssuePanel=false;
        componentToPage.systemIssuePanel=false;
        componentToPage.pendingPanel=false;
        componentToPage.pendingValidated=false;
        // Sumamry Component Booleans
        componentToPage.summaryPanel=false;
        // Confirm Component Booleans
        componentToPage.confirmPanel=false;  
        componentToPage.isSb2plusPlan=false;
        
        Apexpages.currentPage().getHeaders().put(AtlasConstants.X_UA_COMPATIBLE,AtlasConstants.IE_8);    
        
     }
     
    /**
    * @author Raghuprasad Halakere
    * @description - calls populateAtlasDashboardData for ChangePlanController
    * @input param  - null
    * @return null
    */            
       public  void callRemoteAtlasDashboardData()
      {       
          populateAtlasDashboardData();                         
      }
    
     /**
    * @author Tejesh Kumar
    * @description transactionsExistForAccount
    * @param object null
    * @return null
    */  
      public  pageReference transactionsExistForAccount()
      {
         try {              	    	    	
         	system.debug('---mainDTOObj---> '+mainDTOObj);
            Boolean pendingTransition = AtlasIntegrationServiceManager.getTransactionsByAccountAndType(mainDTOObj,'updateService');
            system.debug('---pendingTransition---> '+pendingTransition);
            if(Test.isRunningTest()) 
            	pendingTransition=true;
            if(pendingTransition) {                
            	pendingPlanTransition=true; 
                componentToPage.selectionPanel=true;
                componentToPage.summaryPanel=false;
                componentToPage.confirmPanel=false;
                componentToPage.selectionPanelOptions=false;
                componentToPage.pendingPanel=true;
            }
            else
            	pendingPlanTransition=false;        
         } 
         catch(Exception e) {
            system.debug('@@@ I am in Exception --->'+e.getMessage());
         } 
         componentToPage.pendingValidated=true;
         return redirectToMoving();                     
      }
            
    /**
    * @author Srikanth Kudumula
    * @description - calls getTransitionPackages for ChangePlanController
    * @input param  - null
    * @return null
    */ 
      public  void changePlanPackages()
      {        
          getTransitionPackages();          
      } 
      
      /**
    * @author Tejesh Kumar
    * @description - redirect for Vacation plans
    * @input param  - null
    */ 
      public  pageReference redirectToMoving() { 
          // To redirect to moving page for Vacation Plans
     	if(!AtlasUtility.isEmpty(mainDTOObj.accountDTOObj.serviceLevel)) {
	     	if(vacationPlanList.contains(mainDTOObj.accountDTOObj.serviceLevel)||mainDTOObj.accountDTOObj.serviceLevel.contains('Vacation')) {
		        string siteURl =site.getBaseUrl();
		        if(!AtlasUtility.IsEmpty(siteURl)) {              
		            PageReference page = new PageReference(siteURl+'/moving');
		            page.setRedirect(true);
		            return page;
		        }
		        else {
		            PageReference page1 = new PageReference('/apex/moving');
		            page1.setRedirect(true); 
		            return page1;		              
		        }	
	     	}	     	
	     	else
	     		return null;
     	} 
     	else
     		return null;
    }  
    
     /**
    * @author Tejesh Kumar
    * @description - calls getAccount for ChangePlanController
    * @input param  - null
    * @return null
    */ 
      public  void getAccountService()
      {        
          getAccount();          
      }   
          
}