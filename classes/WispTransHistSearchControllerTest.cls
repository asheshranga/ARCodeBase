/*********************************************************************************
Name         : WispTransactionHistorySearchControllerTest
Created By   : Tejesh Kumar
Modified BY  : Tejesh Kumar
Company Name : CMC Americas
Project      : ViaSat Wisp
Created Date : 
Modified Date: 
Usages       : Test class
*********************************************************************************/
@isTest(SeeAllData=true)
public class WispTransHistSearchControllerTest { 
  
    static testmethod void testTransactionHistorySearchController(){
        WispTransactionHistorySearchController ctlr = new WispTransactionHistorySearchController();      
        ctlr.loadFirst();
        ctlr.toggleSort();
        ctlr.runQuery();
    }
    
    static testMethod void testParameters() {
      // Instantiate a new controller with all parameters in the page
      WispTransactionHistorySearchController controller1 = new WispTransactionHistorySearchController();         
      controller1.runSearch();
    }     
    
    static testMethod void testPageControls() {
      //Instantiate a new controller with all parameters in the page
      WispTransactionHistorySearchController controller = new WispTransactionHistorySearchController();
      Integer s = controller.resultSize;
      Boolean p = controller.hasNext;
      Boolean n = controller.hasPrev;
      String r = controller.recordInfo;
      String p1 = controller.pageInfo;
             
      controller.next();
      controller.previous();
      controller.last();
      controller.first(); 
    }     
 }