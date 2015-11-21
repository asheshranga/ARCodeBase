/*********************************************************************************
Name         : DealerOptionsCompController
Created By   : Jim Tunney
Modified BY  : 
Company Name : 
Project      : Dealer Portal
Created Date : 10/27/2015
Modified Date: 
Usages       : Controller for VisualForce Component: DealerOptionsComponent
*********************************************************************************/
public with sharing class DealerOptionsCompController {
    public DealerComponenttoController componentToPage{get; set;}
    
    /***** Note: values contained in the DealerKeyValueStore Custom Settings *****/
    public string buttonBackLabel {get {return DealerUtility.getMapValue(DealerConstants.ButtonBack);} set;} //Displays "Back"
    public string buttonNextStepLabel {get {return DealerUtility.getMapValue(DealerConstants.ButtonNextStep);} set;} //Displays "Next Step"
    public DealerMainDTO mainDTO{get;set;}
    
    public pageReference optionsBackButton(){
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
    
     public pageReference optionsNextStep(){
        componentToPage.clickedStep = 3;
        componentToPage.OrderStep0 = false;
        componentToPage.OrderStep1 = false;
        componentToPage.OrderStep2 = false;
        componentToPage.OrderStep3 = true;
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
}