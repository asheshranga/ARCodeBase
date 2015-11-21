/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an organization are executed whenever Apex code is deployed
 * to a production organization to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production organization. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the organization size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
@isTest
private class RMAWarrantyCheckTest 
{

    static testMethod void WarrantyValidationControllerTest1() 
    {
    	
    	// create account		           
		List<Account> accs = ViasatTestUtility.createAccounts(1, 'testAcc');
		insert accs; 
    	
    	// create Order
    	Order__c o1 = new Order__c();
        o1.Account__c = accs[0].id;          
        insert o1;
        
        // create order lines
        OrderLine__c ol1 = new OrderLine__c();
        ol1.Part_Number_2__c = 'VA-016753-0003';
        ol1.SerialNo__c = '1234';
        ol1.ReturnReasonDescription__c = 'test';
        ol1.Order__c = o1.Id;
        insert ol1;
        
        OrderLine__c ol2 = new OrderLine__c();
        ol2.Part_Number_2__c = '1234';
        ol2.SerialNo__c = '1234';
        ol2.ReturnReasonDescription__c = 'test';
        ol2.Order__c = o1.Id;
        insert ol2;
                
                     
        ApexPages.Standardcontroller controller = new ApexPages.Standardcontroller(o1);
        WarrantyValidationController wvC = new  WarrantyValidationController(controller);
       
        string test = wvC.accountName; 
        test = wvC.accountId; 
        
 		wvC.getLines();
     	wvC.exportToCSV();
     	
     	// success test  
     	wvC.mainForTestSuccess(ol1.Id);	
    	wvC.submitForWarranty();
    	wvC.submitAction();
    	wvC.submitRMA();
    	// select the line
    	for(OrderLine__c l: wvC.validOrderlines) 
    		l.marked_for_deletion__c = true;
    	wvc.linesInWarranty();
    	
   
        
    }
    
    
    static testMethod void WarrantyValidationControllerTest2() 
    {
    	
    	// create account		           
		List<Account> accs = ViasatTestUtility.createAccounts(1, 'testAcc');
		insert accs; 
    	
    	// create Order
    	Order__c o1 = new Order__c();
        o1.Account__c = accs[0].id;          
        insert o1;
        
        // create order line
        OrderLine__c ol1 = new OrderLine__c();
        ol1.Part_Number_2__c = 'VA-016753-0003';
        ol1.SerialNo__c = '1234';
        ol1.ReturnReasonDescription__c = 'test';
        ol1.Order__c = o1.Id;
        insert ol1;
        
        OrderLine__c ol2 = new OrderLine__c();
        ol2.Part_Number_2__c = '1234';
        ol2.SerialNo__c = '1234';
        ol2.ReturnReasonDescription__c = 'test';
        ol2.Order__c = o1.Id;
        insert ol2;
        
                     
        ApexPages.Standardcontroller controller = new ApexPages.Standardcontroller(o1);
        WarrantyValidationController wvC = new  WarrantyValidationController(controller);
      	  	
    	// error test
    	wvC.mainForTestError(ol1.id, ol2.id);
    	wvC.submitForWarranty();
    	wvC.submitAction();
    	wvC.submitRMA();
    	for(OrderLine__c l: wvC.invalidOrderlines) 
    		l.marked_for_deletion__c = true;
    	wvC.linesOutofWarranty();
    	    
            
    }
    
     
    
    static testMethod void OrderlinesCSVControllerTest() 
    {
    	
    	// create account		           
		List<Account> accs = ViasatTestUtility.createAccounts(1, 'testAcc');
		insert accs; 
    	
    	// create Order
    	Order__c o1 = new Order__c();
        o1.Account__c = accs[0].id;          
        insert o1;
        
        // create order lines
        OrderLine__c ol1 = new OrderLine__c();
        ol1.Part_Number_2__c = 'VA-016753-0003';
        ol1.SerialNo__c = '1234';
        ol1.ReturnReasonDescription__c = 'test';
        ol1.Order__c = o1.Id;
        insert ol1;
        
        OrderLine__c ol2 = new OrderLine__c();
        ol2.Part_Number_2__c = '1234';
        ol2.SerialNo__c = '1234';
        ol2.ReturnReasonDescription__c = 'test';
        ol2.Order__c = o1.Id;
        insert ol2;
    	
    	
    	PageReference pageRef = Page.OrderlinesCSVfile;
        Test.setCurrentPage(pageRef);      
        ApexPages.currentPage().getParameters().put('id', o1.id);
    	
    	OrderlinesCSVController OlCSVController = new  OrderlinesCSVController();
         
    }
    
    
    
    
    
    
}