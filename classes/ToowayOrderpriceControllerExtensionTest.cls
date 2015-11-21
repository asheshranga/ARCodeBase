//Test Method for the Apex Class ToowayOrderpriceControllerExtension
@isTest
public class ToowayOrderpriceControllerExtensionTest{
  static testMethod void ToowayOrderpriceControllerExtensionTest()
      {          
          OrderPrice__c ordprice = new OrderPrice__c();
          ApexPages.StandardController sc = new ApexPages.standardController(ordprice);          
          ToowayOrderpriceControllerExtension obj = new ToowayOrderpriceControllerExtension(sc);          
      }
}