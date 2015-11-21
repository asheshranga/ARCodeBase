/*********************************************************************************
Name         : DealerNewOrderPgController
Created By   : Jim Tunney
Modified BY  : 
Company Name : 
Project      : Dealer Portal
Created Date : 10/26/2015
Modified Date: 
Usages       : Controller for VisualForce Page: DealerNewOrderPage
*********************************************************************************/
public with sharing class DealerNewOrderPgController extends DealerDataManager {
    public DealerComponenttoController componentToPage{get; set;}
    public DealerPlansDTO plansDTOObj{get;set;}
    
    /**
     * @author Jim Tunney
     * @description - Constructor for DealerNewOrderPgController
     * @input param  - none
     * @return null
    */ 
    public DealerNewOrderPgController()
    {
        //This code has been written for IE8 Browser Compatibility Issues. 
        Apexpages.currentPage().getHeaders().put(AtlasConstants.X_UA_COMPATIBLE,AtlasConstants.IE_8);
        componentToPage = new DealerComponenttoController();
        componentToPage.OrderStep0 = true;
        componentToPage.OrderStep1 = false;
        componentToPage.OrderStep2 = false;
        componentToPage.OrderStep3 = false;
        componentToPage.OrderStep4 = false;
        componentToPage.OrderStep5 = false;
        componentToPage.OrderStep6 = false;
        componentToPage.OrderStep7 = false; 
        componentToPage.clickedStep = 0;
        componentToPage.confirmation = false;        
        
    }
    
    public void getPackagesAction() {
    	getPackages();
    }
    
}