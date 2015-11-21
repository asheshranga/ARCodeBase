/*********************************************************************************
Name         : AtlasUserSearchControllerTest
Created By   : Kelly Wortel
Created Date : 4/24/2014
Project      : Atlas Beta-Exit
Usages       : Test Class for the AtlasUserSearchController

Change Log:
<Date>      <Modified By>   <Change Description>
4/29/2014   K. Wortel       Controller Created
*********************************************************************************/

@isTest(SeeAllData=true)
private class AtlasUserSearchControllerTest {

    static testMethod void testLogInAs() {
	    // Instantiate a new controller with all parameters in the page
	    AtlasUserSearchController controller = new AtlasUserSearchController();
	    controller.logInAs();
  	}
    
    static testMethod void testDebug() {
	    // Instantiate a new controller with all parameters in the page
	    AtlasUserSearchController controller = new AtlasUserSearchController();
	    String lsSQL = controller.debugSoql;
  	}
  
    static testMethod void testToggle() {
	    // Instantiate a new controller with all parameters in the page
	    AtlasUserSearchController controller = new AtlasUserSearchController();
	    controller.toggleSort();
  	}
  
    static testMethod void testParameters() {
	    // Instantiate a new controller with all parameters in the page
	    AtlasUserSearchController controller = new AtlasUserSearchController();
	      
	    PageReference pageRef = Page.AtlasUserSearch;
	    Test.setCurrentPageReference(pageRef);    
	    Apexpages.currentPage().getParameters().put('username','success');
	    Apexpages.currentPage().getParameters().put('useremail','success');
	    Apexpages.currentPage().getParameters().put('externalaccountref','success');
	    Apexpages.currentPage().getParameters().put('accountNumber','success');
	    Apexpages.currentPage().getParameters().put('accounttype','success');
	    Apexpages.currentPage().getParameters().put('firstname','success');
	    Apexpages.currentPage().getParameters().put('lastname','success');
	    Apexpages.currentPage().getParameters().put('phoneNumber','success');    
	    
	    controller.runSearch();
  	}     
    
    static testMethod void testPageControls() {
	    // Instantiate a new controller with all parameters in the page
	    AtlasUserSearchController controller = new AtlasUserSearchController();
	    controller.runSearch();
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