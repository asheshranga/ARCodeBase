/*********************************************************************************
Name         : AtlasDataManager 
Created By   : Gaurav Gathania
Modified BY  : Gaurav Gathania
Company Name : NTT Data
Project      : ViaSat Atlas, Bangalore
Created Date : 20 October 2013
Usages       : Parent Class for all Page Controllers for VisualForce Page
*********************************************************************************/

public virtual with sharing class AtlasDataManager {
    
    public AtlasMainDTO mainDTOObj{get;set;}
    public AtlasCurrentBillDTO printInvoiceDTOObj{get;set;}
    public String testString{get;set;}

    public Set<String> planNameSet = new Set<String>();
    public Set<String> openNetSet = new Set<String>();
    public Set<String> businessPlanSet = new Set<String>();                         

// init AtlasPlansSet and Set<String> planNameSet, openNetSet, businessPlanSet used in getPlanName()
public Set<String> initAtlasPlanSets()
{
    Set<String> AtlasPlansSet = new Set<String>();
    List<AtlasPlan__c> atlasPlans = [SELECT PlanAPIName__c, PlanDisplayName__c, Type__c, id, Is_Plan_Unlimited__c, Is_Plan_Opennet__c,BusinessPlan__c  
                                     FROM AtlasPlan__c WHERE Type__c =: 'Wisp' or 
                                                             Is_Plan_Unlimited__c =: true OR Is_Plan_Opennet__c =: true OR BusinessPlan__c =: true];
    for(AtlasPlan__c ap : atlasPlans)
    {
        if (ap.Type__c != null && ap.Type__c.equalsIgnoreCase('Wisp'))
            AtlasPlansSet.add(ap.PlanAPIName__c.toLowerCase());                 
        if(ap.Is_Plan_Unlimited__c)
            planNameSet.add(ap.PlanAPIName__c.toLowerCase());
        else if(ap.Is_Plan_Opennet__c)
            openNetSet.add(ap.PlanAPIName__c.toLowerCase());
        else if(ap.BusinessPlan__c)
            businessPlanSet.add(ap.PlanAPIName__c.toLowerCase());
    }
    return AtlasPlansSet;
}
         
    
    public AtlasDataManager()
    {
        mainDTOObj=new AtlasMainDTO();
    }
    /**
    * @author Gaurav Gathania 
    * @description fetch logged in User State 
    * @param object AtlasMainDTO
    * @return AtlasMainDTO
    */  
    public static User getUserDetails()
    {       
        return AtlasDataDispatcher.getUserDetails();        
    }
    
    /**
    * @author Gaurav Gathania 
    * @description populateViewState for Session Management 
    * @param object AtlasMainDTO
    * @return AtlasMainDTO
    */  
    private void populateViewState()
    {   
        mainDTOObj=AtlasDatabaseManager.populateViewState(mainDTOObj);
    }

    /**
    * @author Gaurav Gathania 
    * @description persist view state for Session Management 
    * @Across Atlas Screens 
    * @param object AtlasMainDTO
    * @return void
    */  
    public void persistViewState()
    {
        AtlasDatabaseManager.persistViewState(mainDTOObj);
        if(!mainDTOObj.atlasTransactionModelList.isEmpty()) {
            AtlasDatabaseManager.insertTransactionList(mainDTOObj);
            mainDTOObj.atlasTransactionModelList.clear();
        }        
    }

    /**
    * @author Gaurav Gathania 
    * @description populateAtlasDashboardData
    * @Across Atlas Dashboard Screen
    * @param object AtlasMainDTO
    * @return void
    */  
    public void populateAtlasDashboardData()
    {
        populateViewState(); 
        AtlasDataDispatcher.getDashboardData(mainDTOObj);
        persistViewState();
    }
    
     /**
    * @author Tejesh Kumar
    * @description populateWispDashboardData
    * @Across Wisp Dashboard Screen
    * @param object AtlasMainDTO
    * @return void
    */  
    public void populateWispDashboardData1()
    {
DateTime startDt = dateTime.now();
        populateViewState();
        if (AtlasUtility.isEmpty(mainDTOObj.accountKey) || !AtlasDataDispatcher.sessionMgmt)
        {
        AtlasDataDispatcher.getWispDashboardData(mainDTOObj);
        persistViewState();
ViasatLogHandler.Log(AtlasConstants.SF_ORG_NAME, ViasatLogHandler.SeverityTypeINFO, 'getWispDashboardData:AtlasIntegrationServiceManager.searchCustomerDetailsforWisp+getLegacyAccount ' + string.valueOf(ViasatUtilityClass.GetSecondsElapsed(startDt, DateTime.now())) + ' sec', string.valueOf(startDt), 'mainDTOObj.accountKey: ' + string.valueOf(mainDTOObj.accountKey));
        }
    }
    
    /**
    * @author Srikanth Kudumula
    * @description populateWispDashboardData
    * @Across Wisp Dashboard Screen
    * @param object AtlasMainDTO
    * @return void
    */  
    public void populateWispDashboardData()
    {
        populateViewState(); 
        //AtlasDataDispatcher.getDashboardData(mainDTOObj);
        //persistViewState();
    }
    
    /**
    * @author Gaurav Gathania 
    * @description populateAtlasUsageData
    * @Across Atlas Usage Screen
    * @param object AtlasMainDTO
    * @return void
    */  
    public void populateAtlasUsageData()
    {
        populateViewState();
        AtlasDataDispatcher.getUsageData(mainDTOObj);
        temporaryFunction(mainDTOObj);
    }
    /**
    * @author Gaurav Gathania 
    * @description populateBillingHistory
    * @Across Atlas Usage Screen
    * @param object AtlasMainDTO
    * @return void
    */  
    public void populateBillingHistory()
    {
        populateViewState();       
        AtlasDataDispatcher.getBillingHistoryData(mainDTOObj);  
    }
    
    /**
    * @author Gaurav Gathania 
    * @description populateCurrentPayment
    * @Across Atlas CurrentBill Screen
    * @param object AtlasMainDTO
    * @return void
    */  
    public void populateCurrentPayment()
    {
        populateViewState();
        AtlasDataDispatcher.getCurrentPayment(mainDTOObj);  
    } 
    
    /**
    * @author Gaurav Gathania 
    * @description refreshCurrentPayment
    * @Across Atlas Payment Screen
    * @param object AtlasMainDTO
    * @return void
calls getMyAccountDashBoardData() twice. bug?
    */  
    public void refreshCurrentPayment()
    {
        AtlasDataDispatcher.getCurrentPayment(mainDTOObj); 
        clearMyAccountDataForRefresh(); 
        getMyAccountDashBoardData();
        persistviewstate();          
    } 
    
    /**
    * @author Gaurav Gathania 
    * @description populateCurrentBillData
    * @Across Atlas Payment Screen
    * @param object AtlasMainDTO
    * @return void
    */  
    public AtlasCurrentBillDTO populateCurrentBillData(String invoiceReferenceNumber)
    {
        populateViewState();
        AtlasCurrentBillDTO obj = AtlasDataDispatcher.getCurrentBillData(mainDTOObj,invoiceReferenceNumber);
        return obj;
    }
    
    /**
    * @author Gaurav Gathania 
    * @description populatePlanDetails on Usgae Screen
    * @Across Atlas Payment Screen
    * @param object AtlasMainDTO
    * @return void
    */  
    private void populatePlanDetails()
    {
        mainDTOObj.planDetailsDTO=new AtlasPlanDetailsDTO();
        String planName;
        if(mainDTOObj.accountDTOObj != null){
            planName = mainDTOObj.accountDTOObj.serviceLevel;
        }
        if (planName != NULL && planName != '') {
            AtlasPlan__c[] planDetailsObjects = [SELECT Id, 
                                                      Name, 
                                                      PlanAPIName__c, 
                                                      PlanUnmeteredStatement__c, 
                                                      PlanDescription__c 
                                               FROM AtlasPlan__c 
                                               where PlanAPIName__c = :planName LIMIT 1];
           if (planDetailsObjects.size() == 1) {
                mainDTOObj.planDetailsDTO.exedeLimit = planName;
                AtlasPlan__c atlasPlanObject = planDetailsObjects[0];
                mainDTOObj.planDetailsDTO.planDescription = atlasPlanObject.PlanDescription__c;
                if(!AtlasUtility.isEmpty(atlasPlanObject.PlanUnmeteredStatement__c)) {
                    String[] timeFromAndTo = atlasPlanObject.PlanUnmeteredStatement__c.split('-');
                    if (timeFromAndTo.size() > 1) {
                       mainDTOObj.planDetailsDTO.timeFrom = timeFromAndTo[0].trim();
                       mainDTOObj.planDetailsDTO.timeTo  = timeFromAndTo[1].trim();
                    }
                }
            }
        }
        if(mainDTOObj.cduDTOObj != null){
            mainDTOObj.planDetailsDTO.totalData = mainDTOObj.cduDTOObj.planThresholdConvertedText;
        }
    }
    
    /**
    * @author Edwin Raymond 
    * @description populateCDRBillingData
    * @Across Atlas Billing Invoice Screen
    * @param object AtlasMainDTO, string invoiceReferenceNumber
    * @return void
    */  
    public AtlasMainDTO populateCDRBillingData(String invoiceReferenceNumber)
    {
        populateViewState();
        AtlasMainDTO obj = AtlasDataDispatcher.retrieveInvoiceCDRDet(mainDTOObj,invoiceReferenceNumber);        
        return obj;
    }
    /** TO DO-----Delete this function
    * @author Gaurav Gathania 
    * @description temporaryFunction on
    * @Across Atlas Payment Screen
    * @param object AtlasMainDTO
    * @return void
    */  
    private void temporaryFunction(AtlasMainDTO mainDTO)
    {
        AtlasBuyMoreDTO buyMoreDTOObj=new AtlasBuyMoreDTO();
        AtlasBuyMoreDTO.BuyMoreButton tempBill=new AtlasBuyMoreDTO.BuyMoreButton();
        tempBill.GB=1;
        tempBill.currencyValue =9.99;
        buyMoreDTOObj.buyMoreButtonList  =new List<AtlasBuyMoreDTO.BuyMoreButton>();
        buyMoreDTOObj.buyMoreButtonList.add(tempBill);
        mainDTO.buyMoreDTOObj=buyMoreDTOObj;
    }
    
    /**
    * @author Edwin Raymond
    * @Calls AtlasIntegrationServiceManager to Udpate Payment Method: 
    * @return status String
    */
    public String updatePaymentMethod(AtlasTransactionDTO.updatedPaymentMethodDTO paymentObj)
    {
        return AtlasDataDispatcher.updateCurrentPaymentSettings(paymentObj);
    }
    
    /**
    * @author Edwin Raymond
    * @Calls AtlasIntegrationServiceManager to perform Payment Transaction
    * @return status String 
    */
    public String submitPaymentTransaction(AtlasTransactionDTO.oneTimePaymentDTO paymentObj)
    {
        return AtlasDataDispatcher.submitOneTimePaymentTransaction(paymentObj);
    }
    
    /**
    * @author Tejesh Kumar
    * @Calls AtlasIntegrationServiceManager to perform Payment Transaction Auto Resume
    * @return status String 
    */
    public AtlasFinServiceXmlschemaV4FinanceService.OneTimePaymentAutoResumeResults submitPaymentTransactionForAutoResume(AtlasTransactionDTO.oneTimePaymentDTOForAutoResume paymentObj)
    {
        return AtlasDataDispatcher.submitOneTimePaymentTransactionForAutoResume(paymentObj);
    }
    
    /**
    * @author Gaurav Gathania
    * @Calls AtlasIntegrationServiceManager to Udpate customer Info
    * @return status String return false
    */
    public void updateCustomerInfo(AtlasTransactionDTO.UpdateCustomerInfoTxDTO custInfoObj)
    {
        AtlasDataDispatcher.updateCustomerInfo(custInfoObj);      
        clearMyAccountDataForRefresh();
    }
    /** 
    * @author Gaurav Gathania 
    * @description clearMyAccountDataForRefresh on
    * @Across Atlas Payment Screen
    * @param object AtlasMainDTO
    * @return void
    */  
    public void clearMyAccountDataForRefresh()
    {
        mainDTOObj.accountDTOObj.isBillingDetailsPopulated=false;  
        getMyAccountDashBoardData();
    }
    /**********************************************************************************************************************************************
    **********************************************************************************************************************
    
    
    
    /** 
    * @author Gaurav Gathania 
    * @description getMyAccountDashBoardData
    * @Across Usage Screen
    * @param object AtlasMainDTO
    * @return void
    */  
    public void getMyAccountDashBoardData()
    {   
        AtlasDataDispatcher.getMyAccountDashBoardData(mainDTOObj);
        persistViewState();
    }
    
    /** 
    * @author Srikanth Kudumula 
    * @description getMyAccountWispDashBoardData
    * @Across Usage Screen
    * @param object AtlasMainDTO
    * @return void
    */  
    public void getMyAccountDashBoardDataforWisp()
    {   
DateTime startDt = dateTime.now();
        if (mainDTOObj.isAccountPopulated==false || mainDTOObj.accountDTOObj.serviceLevel == null || !AtlasDataDispatcher.sessionMgmt)
        {
        AtlasDataDispatcher.getMyAccountWispDashBoardData(mainDTOObj);
//      string sResult = AtlasIntegrationServiceManager.getPlanName(mainDTOObj, planNameSet, openNetSet, businessPlanSet);
        persistViewState();
ViasatLogHandler.Log('ATLAS', ViasatLogHandler.SeverityTypeINFO, 'getMyAccountWispDashBoardData:AtlasIntegrationServiceManager.getPlanName ' + string.valueOf(ViasatUtilityClass.GetSecondsElapsed(startDt, DateTime.now())) + ' sec', string.valueOf(startDt));
        }
    }
    
    /** 
    * @author Gaurav Gathania 
    * @description getBillingSnapShotDashBoardDAta
    * @Across Usage Screen
    * @param object AtlasMainDTO
    * @return void
    */  
    public void getBillingSnapShotDashBoardDAta()
    {
        AtlasDataDispatcher.getBillingSnapShotDashBoardDAta(mainDTOObj);
        persistViewState();
    }
    
    /** 
    * @author Gaurav Gathania 
    * @description getCurrentPaymentSettingsBillPage
    * @Across Usage Screen
    * @param object AtlasMainDTO
    * @return void
    */  
    public void getCurrentPaymentSettingsBillPage()
    {
        AtlasDataDispatcher.getCurrentPayment(mainDTOObj);        
        persistViewState();
    }
    /** 
    * @author Gaurav Gathania 
    * @description getCurrentDataUsageDashBoradData
    * @Across Usage Screen
    * @param object AtlasMainDTO
    * @return void
    */  
    public void getCurrentDataUsageDashBoradData()
    {
		DateTime startDt = dateTime.now();
        if (mainDTOObj.cduDTOObj==null || mainDTOObj.cduDTOObj.refreshNow || !AtlasDataDispatcher.sessionMgmt)
        {   
        AtlasDataDispatcher.getCurrentDataUsageDashBoradData(mainDTOObj);
        persistViewState();
        }
		ViasatLogHandler.Log('ATLAS', ViasatLogHandler.SeverityTypeINFO, 'getCurrentDataUsageDashBoradData:AtlasIntegrationServiceManager.getCurrentUsageByAccount ' + string.valueOf(ViasatUtilityClass.GetSecondsElapsed(startDt, DateTime.now())) + ' sec', string.valueOf(startDt));
    }
    
    /** 
    * @author Gaurav Gathania 
    * @description getPlanDetails
    * @Across Usage Screen
    * @param object AtlasMainDTO
    * @return void
    */  
    public void getPlanDetails()
    {
        populatePlanDetails();
        persistViewState();
    }
    /** 
    * @author Gaurav Gathania 
    * @description getBillingHistory
    * @Across Usage Screen
    * @param object AtlasMainDTO
    * @return void
    */  
    public void getBillingHistory()
    {
        populateViewState();
        AtlasDataDispatcher.getBillingHisory(mainDTOObj);
        persistViewState();
    }
    /** 
    * @author Gaurav Gathania 
    * @description getALaCartePackages
    * @Across Usage Screen
    * @param object AtlasMainDTO
    * @return void
    */  
    public void getALaCartePackages()
    {
        // TODO: Sujit needs to review with Kerry, if I uncomment this it erases the cdu object 
DateTime startDt = dateTime.now();   
        AtlasBuyMoreDTO buyMoreDTOObj=new AtlasBuyMoreDTO();
        buyMoreDTOObj.externalServiceAgreementReference=mainDTOObj.externalServiceAgreementReference;
        buyMoreDtoObj.externalAccountReference = mainDTOObj.externalAccountReference;
        buyMoreDTOObj.externalSystemName=mainDTOObj.externalSystemName;
        buyMoreDTOObj.externalTransactionReference=mainDTOObj.externalSystemName+System.now();
        buyMoreDTOObj.transactionType=AtlasConstants.ADD_USAGE_QUOTA;    
        buyMoreDTOObj.responseURL=null;
        buyMoreDTOObj.salesChannel=null;
        buyMoreDTOObj.enteredBy=mainDTOObj.loggedInUserEmail;
        buyMoreDTOObj.soldBy=null;
        buyMoreDTOObj.marketingSourceCode=null;
        buyMoreDTOObj.referralSourceCode=null;
        buyMoreDTOObj.note=null;            
        mainDTOObj.buyMoreDTOObj=buyMoreDTOObj;
        mainDTOObj=AtlasDataDispatcher.getALaCartePackages(mainDTOObj);
ViasatLogHandler.Log('ATLAS', ViasatLogHandler.SeverityTypeINFO, 'getALaCartePackages:AtlasIntegrationServiceManager.getALaCartePackages ' + string.valueOf(ViasatUtilityClass.GetSecondsElapsed(startDt, DateTime.now())) + ' sec', string.valueOf(startDt));
    }
    
    /** 
    * @author Srikanth Kudumula
    * @description getTransitionPackages
    * @Across Change Plan
    * @param object AtlasMainDTO
    * @return void
    */  
    public void getTransitionPackages()
    {
        populateViewState();
        AtlasDataDispatcher.getTransitionPackages(mainDTOObj);
        persistViewState();
    }
    
    /** 
    * @author Tejesh Kumar
    * @description getAccountServiceAgreementsAndServicesv2
    * @Across Change Plan
    * @param object AtlasMainDTO
    * @return void
    */  
    public void getAccountServiceAgreementsAndServicesv2(AtlasMainDTO mainDTOObj)
    {
        AtlasDataDispatcher.getAccountServiceAgreementsAndServicesv2(mainDTOObj);
    }
    
    /** 
    * @author Tejesh Kumar
    * @description getTransitionBase Service
    * @Across Change Plan
    * @param object AtlasMainDTO
    * @return void
    */  
    public Map<String,String> getTransistionBaseService(String externalSystemName, String externalAccountReference, String planName, String masterCatalogReference, String serviceItemReference)
    {
        Map<String,String> changePlanMap = new Map<String,String>();
        httpResponse res = AtlasIntegrationUtility.getTransistionBaseService(externalSystemName, externalAccountReference, planName, masterCatalogReference, serviceItemReference);
        Dom.Document doc=res.getBodyDocument();
        Dom.XMLNode rootNode=doc.getRootElement();
        system.debug('@@@ SC root Node --->'+rootNode);
        for(Dom.XMLNode childNode : rootNode.getChildElements()){
            if('ResponseStatus' == childNode.getName()){
                system.debug('@@@ child Node --->'+childNode);
                Dom.Xmlnode[]  cNode = childNode.getChildElements();
                for(Dom.Xmlnode c : cNode){
                    if('ErrorCode' == c.getName()){
                        changePlanMap.put('ErrorCode',c.getText());
                    }
                } 
            }
            if('Transaction' == childNode.getName()){
                Dom.Xmlnode[]  cNode1 = childNode.getChildElements();
                for(Dom.Xmlnode c1 : cNode1){
                    if('OrderStatus' == c1.getName()){
                        Dom.Xmlnode[]  cNode2 = c1.getChildElements();
                        for(Dom.Xmlnode c2 : cNode2){
                            if('OrderStatus' == c2.getName()){
                                changePlanMap.put('OrderStatus',c2.getText());
                            }
                        }
                    }
                }
            }
        }
        if(changePlanMap.get('ErrorCode') == 'Success' && changePlanMap.get('OrderStatus') == 'Accepted'){
            clearMyAccountDataForRefresh();
            return changePlanMap;
        }
        else{
            return null;
        }
    }
    
    /** 
    * @author Tejesh Kumar
    * @description getAccount
    * @Across Change Plan
    * @param object AtlasMainDTO
    * @return void
    */  
    public void getAccount()
    {
        populateViewState();
        AtlasDataDispatcher.getAccount(mainDTOObj);
        persistViewState();
    }
    /** 
    * @author Tejesh Kumar
    * @description updateContacts
    * @Across Change Plan
    * @param object AtlasMainDTO
    * @return void
    */  
    public String updateContacts(AtlasTransactionDTO.UpdateCustomerInfoTxDTO custInfoObj)
    {
        populateViewState();
        String response=null;
        response = AtlasIntegrationServiceManager.updateContacts(mainDTOObj,custInfoObj); 
        persistViewState();
        return response;
    }
    /** 
    * @author Tejesh Kumar
    * @description updateShippingContact
    * @Across Change Plan
    * @param object AtlasMainDTO
    * @return void
    */  
    public String updateShippingContact(AtlasTransactionDTO.UpdateCustomerInfoTxDTO custInfoObj)
    {
        populateViewState();
        String response=null;
        response = AtlasIntegrationServiceManager.updateShippingContact(mainDTOObj,custInfoObj);
        persistViewState();
        return response;
    }
    
}