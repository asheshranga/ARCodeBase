/*********************************************************************************
Name         : DealerPlansCompController
Created By   : Jim Tunney
Modified BY  : 
Company Name : 
Project      : Dealer Portal
Created Date : 10/27/2015
Modified Date: 
Usages       : Controller for VisualForce Component: DealerPlansComponent
*********************************************************************************/
public with sharing class DealerPlansCompController {
    public DealerComponenttoController componentToPage{get; set;}
    
    /***** Note: values contained in the DealerKeyValueStore Custom Settings *****/
    public string buttonOrderNowLabel {get {return DealerUtility.getMapValue(DealerConstants.ButtonOrderNow);} set;} 
    public string buttonBackLabel {get {return DealerUtility.getMapValue(DealerConstants.ButtonBack);} set;} 
    public boolean isMovingCustomer{get;set;}
    public string selectedPlanName{get;set;}
    public DealerMainDTO mainDTO{get;set;}
    
    public DealerPlansCompController() {
    	
    }
    
    public pageReference orderNow(){
    	
    	for(DealerPlansDTO.changePlanPackage plan: mainDTO.plansDTOObj.changePlanPackages) {
            system.debug('--plan--> '+plan);
            if(selectedPlanName.toLowercase() == plan.planName.toLowercase()) {
                componentToPage.orderedPlan=plan;
            }
        }
        system.debug('---componentToPage.orderedPlan---> '+componentToPage.orderedPlan);
    	
    	//--- Hide and display Plan Options Component
        componentToPage.clickedStep = 2;
        componentToPage.OrderStep0 = false;
        componentToPage.OrderStep1 = false;
        componentToPage.OrderStep2 = true;
        componentToPage.OrderStep3 = false;
        componentToPage.OrderStep4 = false;
        componentToPage.OrderStep5 = false;
        componentToPage.OrderStep6 = false;
        componentToPage.OrderStep7 = false;        
        return null;
    }
    
     public pageReference startOverAction(){
        componentToPage.clickedStep = 0;
        componentToPage.OrderStep0 = true;
        componentToPage.OrderStep1 = false;
        componentToPage.OrderStep2 = false;
        componentToPage.OrderStep3 = false;
        componentToPage.OrderStep4 = false;
        componentToPage.OrderStep5 = false;
        componentToPage.OrderStep6 = false;
        componentToPage.OrderStep7 = false;       
        return null;
    }
    
     public pageReference plansBackButton(){
        componentToPage.clickedStep = 0;
        componentToPage.OrderStep0 = true;
        componentToPage.OrderStep1 = false;
        componentToPage.OrderStep2 = false;
        componentToPage.OrderStep3 = false;
        componentToPage.OrderStep4 = false;
        componentToPage.OrderStep5 = false;
        componentToPage.OrderStep6 = false;
        componentToPage.OrderStep7 = false;        
        return null;
    }
    
    public pageReference reloadPlanInfo(){
        componentToPage.clickedStep = 1;
        componentToPage.OrderStep0 = false;
        componentToPage.OrderStep1 = true;
        componentToPage.OrderStep2 = false;
        componentToPage.OrderStep3 = false;
        componentToPage.OrderStep4 = false;
        componentToPage.OrderStep5 = false;
        componentToPage.OrderStep6 = false;
        componentToPage.OrderStep7 = false;        
        return null;
    }
        
}