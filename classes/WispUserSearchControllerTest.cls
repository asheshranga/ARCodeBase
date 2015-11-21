/*********************************************************************************
Name         : WispUserSearchControllerTest
Created By   : Tejesh Kumar
Modified BY  : Tejesh Kumar
Company Name : CMC Americas
Project      : ViaSat Wisp
Created Date : 
Modified Date: 
Usages       : Test class
*********************************************************************************/
@isTest(SeeAllData=true)
public class WispUserSearchControllerTest { 
  
    static testmethod void testUserSearchcontroller(){
        WispUserSearchController ctlr = new WispUserSearchController();      
        ctlr.toggleSort();
        ctlr.loginAs();
        ctlr.passwordReset();
        ctlr.changeUsername();
        ctlr.transactionhistory();
    }
       
    static testMethod void testDebug() {
    	WispUserSearchController controller = new WispUserSearchController();
        String lsSQL = controller.debugSoql;
	}
      
    static testMethod void testParameters() {
      // Instantiate a new controller with all parameters in the page
      WispUserSearchController controller1 = new WispUserSearchController();
           
      Apexpages.currentPage().getParameters().put('username','success');
      Apexpages.currentPage().getParameters().put('useremail','success');
      Apexpages.currentPage().getParameters().put('externalaccountref','success');
      Apexpages.currentPage().getParameters().put('accountNumber','success');
      Apexpages.currentPage().getParameters().put('firstname','success');
      Apexpages.currentPage().getParameters().put('lastname','success');
      Apexpages.currentPage().getParameters().put('phoneNumber','success');    
      
      controller1.runSearch();
    }     
    
    static testMethod void testPageControls() {
      //Instantiate a new controller with all parameters in the page
      WispUserSearchController controller = new WispUserSearchController();
      List<User> c = controller.getUsers();
      Integer s = controller.resultSize;
      Boolean p = controller.hasNext;
      Boolean n = controller.hasPrev;
      String r = controller.recordInfo;
      String p1 = controller.pageInfo;
      
      User cObj = controller.dummyUser;
      List<User> userList = controller.users;
        
      controller.next();
      controller.previous();
      controller.last();
      controller.first(); 
    }    
}