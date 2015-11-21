/*********************************************************************************
Name         : DealerChangePlanPgController
Created By   : Jim Tunney
Modified By  : 
Company Name : 
Project      : Dealer Portal
Created Date : 10/26/2015
Modified Date: 
Usages       : Controller for VisualForce Page: DealerChangePlanPage
*********************************************************************************/
public with sharing class DealerChangePlanPgController extends DealerDataManager {
    // Initializing the Change Plan DTO object  
    public DealerChangePlanDTO changePlanDTOObj{get;set;}
    public DealerComponenttoController componentToPage{get; private set;}
    
    
    /**
     * @author Jim Tunney
     * @description - Constructor for DealerChangePlanPgController. All variables use zero-based indexing.
     * @input param  - none
     * @return null
    */ 
    public DealerChangePlanPgController() {
    	system.debug('---------------------I AM IN DealerChangePlanPgController CONSTRUCTOR----------------------------------');
        //This code has been written for IE8 Browser Compatibility Issues. 
        Apexpages.currentPage().getHeaders().put(DealerConstants.X_UA_COMPATIBLE,DealerConstants.IE_8);
        
        componentToPage = new DealerComponenttoController();
        //componentToPage.isLiberty = false;
        componentToPage.CPStep0 = true;
        componentToPage.CPStep1 = false;
        componentToPage.CPStep2 = false;
        componentToPage.clickedStep = 0;
        system.debug('----FROM DlrCPPgCtrlr ->C-tor()------@@@@----------------------------------componentToPage.CPStep0= '+componentToPage.CPStep0);
        //componentToPage.isLiberty = true;
        //componentToPage.isError = false;
    }
    
    /**
    * @author Srikanth Kudumula
    * @description - calls populateDealerDashboardData 
    * @input param  null
    * @return null
    */            
    public void callRemoteDealerDashboardData() {      
          populateDealerDashboardData();   
          System.debug('@@---------------------STUB for call RemoteDealerDashboardData()---------------------@@');                     
      }
    
    /**
    * @author Tejesh Kumar
    * @description transactionsExistForAccount
    * @param object null
    * @return null
    */  
    public pageReference transactionsExistForAccount() {
         /**COMMENTED-OUT UNTIL ALL CLASSES CREATED
            try {                               
            system.debug('---mainDTOObj---> '+mainDTOObj);
            Boolean pendingTransition = DealerIntegrationServiceManager.getTransactionsByAccountAndType(mainDTOObj,'updateService');
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
            system.debug('@@---------------Exception: transactionsExistForAccount() -------------->'+e.getMessage());
         } 
         componentToPage.pendingValidated=true;
         return redirectToMoving();   */    
             return null;//remove once all classes in place
      }
    
    /**
    * @author Srikanth Kudumula
    * @description - calls getTransitionPackages for ChangePlanController
    * @input param  - null
    * @return null
    */ 
    public void changePlanPackages()
      {        
          getTransitionPackages();
      } 
      
    
}//end class