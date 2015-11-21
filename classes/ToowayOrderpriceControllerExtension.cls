public class ToowayOrderpriceControllerExtension {

    public final OrderPrice__c orderprice;
    
    // The extension constructor initializes the private member
    // variable acct by using the getRecord method from the standard
    // controller.
    public ToowayOrderpriceControllerExtension(ApexPages.StandardController stdController) {
        this.orderprice = (OrderPrice__c)stdController.getRecord();
    }
}