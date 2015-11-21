/*********************************************************************************
Name         : DealerConfirmationCompController
Created By   : Jim Tunney
Modified By  : 
Company Name : 
Project      : Dealer Portal
Created Date : 10/28/2015
Modified Date: 
Usages       : Controller for VisualForce Component: DealerConfirmationComponent
*********************************************************************************/
public with sharing class DealerConfirmationCompController {
    public DealerComponenttoController componentToPage{get; set;}
    
    /***** Note: values contained in the DealerKeyValueStore Custom Settings *****/
    public string buttonNewOrderLabel {get {return DealerUtility.getMapValue(DealerConstants.ButtonNewOrder);} set;} //Displays "New Order"
    public string buttonPrintLabel {get {return DealerUtility.getMapValue(DealerConstants.ButtonPrint);} set;} //Displays "Print"
    
    /**
    * @author Jim Tunney
    * @description - Sets booleans so that the Serviceability component is visible/starts the order process again.
    * @input param  - none
    * @return null
    */ 
    public pageReference newOrderButton(){
        componentToPage.clickedStep = 0;
        componentToPage.OrderStep0 = true;
        componentToPage.OrderStep1 = false;
        componentToPage.OrderStep2 = false;
        componentToPage.OrderStep3 = false;
        componentToPage.OrderStep4 = false;
        componentToPage.OrderStep5 = false;
        componentToPage.OrderStep6 = false;
        componentToPage.OrderStep7 = false;
        componentToPage.confirmation = false;
        
        return null;
    }
    
     /**
    * @author Jim Tunney
    * @description - Prints the Confirmation page.
    * @input param  - none
    * @return null
    */ 
     public pageReference printButton(){
        //Code to be input
        return null;
    }
    
}