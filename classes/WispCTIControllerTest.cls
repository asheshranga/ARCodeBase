/*********************************************************************************
Name         : WispCTIControllerTest
Created By   : Srikanth Kudumula
Modified BY  : Srikanth Kudumula
Company Name : NTT Data
Project      : ViaSat Wisp
Created Date : 
Modified Date: 
Usages       : Test class
*********************************************************************************/
@isTest(SeeAllData=true)
public class WispCTIControllerTest{
    
    static testmethod void testCTIcontroller(){
        WispCTIController cti = new WispCTIController();
        cti.toggleSort();
        cti.loginAs();
        cti.createInSFDC();
    }
    
    static testMethod void testDebug() {
	    WispCTIController controller = new WispCTIController();
	    String lsSQL = controller.debugSoql;
  	}
  	
    static testMethod void testParameters() { 	
    	  	
      // Instantiate a new controller with all parameters in the page
      WispCTIController controller1 = new WispCTIController();      
      Apexpages.currentPage().getParameters().put('username','success');
      Apexpages.currentPage().getParameters().put('useremail','success');
      Apexpages.currentPage().getParameters().put('externalaccountref','success');
      Apexpages.currentPage().getParameters().put('accountNumber','success');
      Apexpages.currentPage().getParameters().put('partnername','success');
      Apexpages.currentPage().getParameters().put('firstname','success');
      Apexpages.currentPage().getParameters().put('lastname','success');
      Apexpages.currentPage().getParameters().put('phoneNumber','success');    
      
      controller1.runSearch();    
      
    }     
    static testMethod void testPageControls() {
      // Instantiate a new controller with all parameters in the page
      WispCTIController controller2 = new WispCTIController();
      List<User> c = controller2.getUsers();
      Integer s = controller2.resultSize;
      Boolean p = controller2.hasNext;
      Boolean n = controller2.hasPrev;
      String r = controller2.recordInfo;
      String p1 = controller2.pageInfo;
      
      User cObj = controller2.dummyUser;
      List<User> userList = controller2.users;         
      controller2.next();
      controller2.previous();
      controller2.last();
      controller2.first(); 
    }    
}