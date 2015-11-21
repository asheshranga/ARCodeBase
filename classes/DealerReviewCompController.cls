/*********************************************************************************
Name         : DealerReviewCompController
Created By   : Jim Tunney
Modified BY  : 
Company Name : 
Project      : Dealer Portal
Created Date : 10/28/2015
Modified Date: 
Usages       : Controller for VisualForce Component: DealerReviewComponent
*********************************************************************************/
public with sharing class DealerReviewCompController {
    public DealerComponenttoController componentToPage{get; set;}
    
    /***** Note: values contained in the DealerKeyValueStore Custom Settings *****/
    public string buttonBackLabel {get {return DealerUtility.getMapValue(DealerConstants.ButtonBack);} set;} //Displays "Back"
    public string buttonNextStepLabel {get {return DealerUtility.getMapValue(DealerConstants.ButtonNextStep);} set;} //Displays "Next Step"
    
    /**
    * @author Jim Tunney
    * @description - Method for Review component's 'Back' button. Sets booleans so that the Installation component is visible.
    * @input param  - none
    * @return null
    */ 
    public pageReference reviewBackButton(){
        componentToPage.clickedStep = 5;
        componentToPage.OrderStep0 = false;
        componentToPage.OrderStep1 = false;
        componentToPage.OrderStep2 = false;
        componentToPage.OrderStep3 = false;
        componentToPage.OrderStep4 = false;
        componentToPage.OrderStep5 = true;
        componentToPage.OrderStep6 = false;
        componentToPage.OrderStep7 = false;
        
        return null;
    }
    
     /**
    * @author Jim Tunney
    * @description - Method for Review component's 'Next Step' button. Sets booleans so that the Payment component is visible.
    * @input param  - none
    * @return null
    */ 
     public pageReference reviewNextStep(){
        componentToPage.clickedStep = 7;
        componentToPage.OrderStep0 = false;
        componentToPage.OrderStep1 = false;
        componentToPage.OrderStep2 = false;
        componentToPage.OrderStep3 = false;
        componentToPage.OrderStep4 = false;
        componentToPage.OrderStep5 = false;
        componentToPage.OrderStep6 = false;
        componentToPage.OrderStep7 = true;
        
        return null;
    }
}