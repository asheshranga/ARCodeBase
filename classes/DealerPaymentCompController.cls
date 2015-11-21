/*********************************************************************************
Name         : DealerPaymentCompController
Created By   : Jim Tunney
Modified BY  : 
Company Name : 
Project      : Dealer Portal
Created Date : 10/28/2015
Modified Date: 
Usages       : Controller for VisualForce Component: DealerPaymentComponent
*********************************************************************************/
public with sharing class DealerPaymentCompController {
    public DealerComponenttoController componentToPage{get; set;}
    
    /***** Note: values contained in the DealerKeyValueStore Custom Settings *****/
    public string buttonBackLabel {get {return DealerUtility.getMapValue(DealerConstants.ButtonBack);} set;} //Displays "Back"
    public string buttonPlaceOrderLabel {get {return DealerUtility.getMapValue(DealerConstants.ButtonPlaceOrder);} set;} //Displays "Place Order"
    
    /**
    * @author Jim Tunney
    * @description - Method for Payment component's 'Back' button. Sets booleans so that the Review component is visible.
    * @input param  - none
    * @return null
    */ 
    public pageReference paymentBackButton(){
        componentToPage.clickedStep = 6;
        componentToPage.OrderStep0 = false;
        componentToPage.OrderStep1 = false;
        componentToPage.OrderStep2 = false;
        componentToPage.OrderStep3 = false;
        componentToPage.OrderStep4 = false;
        componentToPage.OrderStep5 = false;
        componentToPage.OrderStep6 = true;
        componentToPage.OrderStep7 = false;
        
        return null;
    }
    
     /**
    * @author Jim Tunney
    * @description - Displays Confirmation component. Breadcrumb and all other components hidden.
    * @input param  - none
    * @return null
    */ 
     public pageReference placeOrderButton(){
        componentToPage.clickedStep = 8;
        componentToPage.OrderStep0 = false;
        componentToPage.OrderStep1 = false;
        componentToPage.OrderStep2 = false;
        componentToPage.OrderStep3 = false;
        componentToPage.OrderStep4 = false;
        componentToPage.OrderStep5 = false;
        componentToPage.OrderStep6 = false;
        componentToPage.OrderStep7 = false;
        componentToPage.confirmation = true;
        
        return null;
    }
    
}