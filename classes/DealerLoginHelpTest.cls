/*********************************************************************************
Name         : DealerLoginTestClass
Created By   : Srikanth Kudumula
Created Date : 10/28/2015
Project      : Dealer Portal 
Usages       : Test Class for Dealer Login Help
Change Log   :
<Date>      <Modified By>   <Change Description>
*********************************************************************************/
@isTest(SeeAllData=true)
public class DealerLoginHelpTest {

	//Method to Cover DealerResetPasswordStep1Controller
	static testmethod void TestDealerResetPasswordStep1Controller(){        
		DealerResetPasswordStep1Controller drp1 = new DealerResetPasswordStep1Controller();
		drp1.componentToPage= new DealerComponenttoController();
		drp1.NextStep1();
		drp1.userName = 'test';
		drp1.NextStep1();
	}
	
	//Method to Cover DealerResetPasswordStep2Controller
	static testmethod void TestDealerResetPasswordStep2Controller(){        
		DealerResetPasswordStep2Controller drp2 = new DealerResetPasswordStep2Controller();
		drp2.componentToPage= new DealerComponenttoController();
		drp2.NextStep2();
		drp2.componentToPage.securityQA1='a1';
		drp2.componentToPage.securityQA2='a2';
		drp2.sqAnswer1='a1';
		drp2.sqAnswer2='a2';
		drp2.NextStep2();
		drp2.sqAnswer1='a3';
		drp2.sqAnswer2='a4';
		drp2.NextStep2();
		drp2.Cancel();
	}
	
	//Method to Cover DealerResetPasswordStep3Controller
	static testmethod void TestDealerResetPasswordStep3Controller(){        
		DealerResetPasswordStep3Controller drp3 = new DealerResetPasswordStep3Controller();
		drp3.componentToPage= new DealerComponenttoController();
		drp3.NextStep3();
		drp3.componentToPage.userName = 'test';
		drp3.password = 'Password1';
		drp3.confirmPassword = 'Password1';
		drp3.NextStep3();
		drp3.componentToPage.userName = 'mjefferson';
		drp3.NextStep3();
		drp3.Cancel();
	}
    
    static testmethod void testDealerChangePlanPgController(){
        /*createDataForEachTest();
        Test.startTest();
        PageReference pageRef=Page.changeplanmoving; //replace with your VF page name
        Test.setCurrentPage(pageRef);
        Test.setMock(WebServiceMock.class, new AtlasTestWebserviceProxy());*/
        DealerChangePlanPgController c=new DealerChangePlanPgController();       
        DealerMainDTO mainDTOObjj=c.mainDTOObj;
        DealerChangePlanDTO changePlanDTOObj=c.changePlanDTOObj;
        
        //try{c.callRemoteAtlasDashboardData();}catch(Exception e){}
        //try{c.transactionsExistForAccount();}catch(Exception e){}
        try{c.changePlanPackages();}catch(Exception e){}
        //c.billingSnapshotAtlasDashboardData();
    }
}