//Created 11/16/15
//test version of DealerChangePlan tests
@isTest(SeeAllData=true)
public with sharing class DealerCPTests {

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
    
    //Method to cover DealerCPCompController
    static testmethod void testDealerCPCompController(){
        DealerCPCompController c = new DealerCPCompController();      
        c.componentToPage=new DealerComponenttoController();  
        DealerMainDTO mainDTOObj=c.mainDTO;
        DealerChangePlanDTO changePlanDTOObj=c.changePlanDTOObj;  
        DealerAccountDTO accountDTOObj=c.accountDTO;  
        AtlasPlan__c pln= new AtlasPlan__c(BonusFeature1__c='test', DownloadSpeedUnit__c='Mbps', CurrencyIsoCode='USD', DataCapGB__c='12', DownloadSpeed__c='12');
        c.myPlan= pln;
        
        c.installLabel='test';
        c.plansLabel='test';
        c.planOptionsLabel='test';
        c.availablePlansLabel='test';
        c.buttonOrderNowLabel='test';
        c.cpSelectPlanAlertBoxHeader='test';
        c.cpSelectPlanAlertBoxMsg1='test';
        c.cpSelectPlanAlertBoxMsg2='test';
        c.cpSelectPlanMsgLabel='test';
        c.GBLabel='test';
        c.howFastLabel='test';
        c.howMuchLabel='test';
        c.MBPSLabel='test';
        c.myCurrentPlanLabel='test';
        c.plansLoading='test';
        c.promotionsLabel='test';
        c.selectNewPlanLabel='test';
        c.alertBoxMsg1='test';
        c.alertBoxMsg2='test';
        c.alreadyUsedLabel='test';
        c.buttonBackLabel='test';
        c.buttonSubChgLabel='test';
        c.cpSummaryAlertBoxHeader='test';
        c.cpSummaryMidPgHeader='test';
        c.cpSummaryPastCapMsg='test';
        c.cpSummaryTopMsg='test';
        c.disclosuresBoxHeader='test';
        c.disclosuresChkboxText='test';
        c.disclosuresPrintLink='test';
        c.disclosuresPrintText='test';
        c.eachMonthLabel='test';
        c.libertyPassLink='test';
        c.libertyPassLinkText='test';
        c.libertyNoDataH5Label='test';
        c.libertyNoDataImgPath='test';
        c.newPlanLabel='test';
        c.plusLibertyLabel='test';
        c.remainingLabel='test';
        c.summaryLabel='test';
        c.usingLibertyMsg='test';
        //c.isChecked='test';//booleans
        //c.isSubmit='test';
        //c.isError='test';
        c.buttonSignOutLabel='test';
        c.confirmationLabel='test';
        c.cpConfirmAlertBoxHeader='test';
        c.cpConfirmH4First='test';
        c.cpConfirmH4Second='test';
        c.cpConfirmReceivedMsg='test';
        c.custCarePhoneLabel='test';
        c.dashLink='test';
        c.dashText='test';
        c.printLink='test';
        c.printText='test';
        
        c.myDataCapacity='5'; 
        try{c.getClickedStep();}catch(Exception e){}
        try{c.getBCList();}catch(Exception e){}
        try{c.step0();}catch(Exception e){}
        try{c.step1();}catch(Exception e){}
        try{c.step2();}catch(Exception e){}
        try{c.orderNow();}catch(Exception e){}
        //try{c.setSelectedPlan();}catch(Exception e){}
        //try{c.setMonthlyData();}catch(Exception e){}
        //try{c.setIsLiberty();}catch(Exception e){}
        //try{c.setDataRemainMonth();}catch(Exception e){}
        //try{c.setIsLibertyNoData();}catch(Exception e){}
        try{c.backButton();}catch(Exception e){}      
        try{c.submitChange();}catch(Exception e){} 
    }
    
}