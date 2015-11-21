/*********************************************************************************
Name         : AtlasDataDispatcher 
Created By   : Gaurav Gathania
Modified BY  : Gaurav Gathania
Company Name : NTT Data
Project      : ViaSat Atlas, Bangalore
Created Date : 29 October 2013
Modified Date : 13 November 2013
Usages       : Data Dispatcher Class to feed data to screens
*********************************************************************************/
public with sharing class AtlasDataDispatcher {
    
    public static Boolean isRefreshCall{get{return false;}set;}

    /**
    *  @author Gaurav Gathania 
    *  @description fetch logged in User State 
    *  @return User
    */  
    public static User getUserDetails()
    {       
        return AtlasDatabaseManager.getUserDetails(); 
    }
    /***
    Boolean Variable : sessionMgmt 
    used in session management
    */
    public static boolean sessionMgmt {get{
    		return (Label.ATLAS_Session_Management==AtlasConstants.TRUE_VALUE);
            }set;}

    /**
    *  @author Gaurav Gathania 
    *  @description fgetDashboardData
    *  @param object AtlasMainDTO
    *  @return AtlasMainDTO
    */  
    public static AtlasMainDTO getDashboardData(AtlasMainDTO mainDTO)
    {
    	//System.debug('--------------------@@@@------------------------>first sessionMgmt= '+sessionMgmt);
    	//System.debug('--------------------@@@@------------------------>first If stmt: isEmpty(mainDTO.accountKey)= '+AtlasUtility.isEmpty(mainDTO.accountKey));
        if(AtlasUtility.isEmpty(mainDTO.accountKey)||!sessionMgmt){
        AtlasIntegrationServiceManager.searchCustomerDetails(mainDTO);
        //System.debug('--------------------@@@@------------------------>marker: getDboardData() first if stmt');
        }
        if(AtlasUtility.isEmpty(mainDTO.accountKey)||!sessionMgmt)
        AtlasIntegrationServiceManager.getAccountServiceAgreementsAndServices(mainDTO);
        return mainDTO; 
    }
    
    /**
    *  @author Tejesh Mandapati
    *  @description fgetWispDashboardData
    *  @param object AtlasMainDTO
    *  @return AtlasMainDTO
    */  
    public static AtlasMainDTO getWispDashboardData(AtlasMainDTO mainDTO)
    {
        if(AtlasUtility.isEmpty(mainDTO.accountKey)||!sessionMgmt)
        AtlasIntegrationServiceManager.searchCustomerDetailsforWisp(mainDTO);
        if(AtlasUtility.isEmpty(mainDTO.accountKey)||!sessionMgmt)
        AtlasIntegrationServiceManager.getAccountServiceAgreementsAndServices(mainDTO);
        return mainDTO; 
    }
    
    /**
    *  @author Gaurav Gathania 
    *  @description getUsageData
    *  @param object AtlasMainDTO
    *  @return AtlasMainDTO
    */  
    public static AtlasMainDTO getUsageData(AtlasMainDTO mainDTO)
    {
        if(AtlasUtility.isEmpty(mainDTO.accountKey)||!sessionMgmt)
        AtlasIntegrationServiceManager.searchCustomerDetails(mainDTO);
        if(AtlasUtility.isEmpty(mainDTO.externalAccountReference)||AtlasUtility.isEmpty(mainDTO.externalSystemName)||!sessionMgmt)
        AtlasIntegrationServiceManager.getAccountServiceAgreementsAndServices(mainDTO);
        if(mainDtO.cduDTOObj==null||!sessionMgmt)
        AtlasIntegrationServiceManager.getCurrentUsageByAccount(mainDTO);
        if(mainDTO.accountDTOObj==null||!sessionMgmt)
        AtlasIntegrationServiceManager.getMyAccount(mainDTO);
        if(mainDTO.billSnapShotDTOObj==null||!sessionMgmt)    
        {    AtlasIntegrationServiceManager.getBillingsnapShot(mainDTO);
            AtlasIntegrationServiceManager.getSubscriberPaymentHistory(mainDTO);
        }
        return mainDTO;
    }
    /**
    *  @author Gaurav Gathania 
    *  @description getBillingHistoryData
    *  @param object AtlasMainDTO
    *  @return AtlasMainDTO
    */  
    public static AtlasMainDTO getBillingHistoryData(AtlasMainDTO mainDTO)
    {
        if(AtlasUtility.isEmpty(mainDTO.accountKey)||!sessionMgmt)
        AtlasIntegrationServiceManager.searchCustomerDetails(mainDTO);
        if(AtlasUtility.isEmpty(mainDTO.externalAccountReference)||AtlasUtility.isEmpty(mainDTO.externalSystemName)||!sessionMgmt)
        AtlasIntegrationServiceManager.getAccountServiceAgreementsAndServices(mainDTO);
        if(mainDtO.cduDTOObj==null||!sessionMgmt)
        AtlasIntegrationServiceManager.getCurrentUsageByAccount(mainDTO);
        if(mainDTO.accountDTOObj==null||!sessionMgmt)
        AtlasIntegrationServiceManager.getMyAccount(mainDTO);
        if(mainDTO.billSnapShotDTOObj==null||!sessionMgmt)    
        {    AtlasIntegrationServiceManager.getBillingsnapShot(mainDTO);
            AtlasIntegrationServiceManager.getSubscriberPaymentHistory(mainDTO);
        }
        if(mainDTO.billhistoryDTOObj==null||!sessionMgmt)
        AtlasIntegrationServiceManager.getBillingHistory(mainDTO);  
        
        return mainDTO;
    }
    
    /**
    *  @author Gaurav Gathania 
    *  @description getCurrentPayment
    *  @param object AtlasMainDTO
    *  @return AtlasMainDTO
    */  
    public static AtlasMainDTO getCurrentPayment(AtlasMainDTO mainDTO)
    {   /**
        if(AtlasUtility.isEmpty(mainDTO.accountKey)||!sessionMgmt)
        AtlasIntegrationServiceManager.searchCustomerDetails(mainDTO);
        if(AtlasUtility.isEmpty(mainDTO.externalAccountReference)||AtlasUtility.isEmpty(mainDTO.externalSystemName)||!sessionMgmt)
        AtlasIntegrationServiceManager.getAccountServiceAgreementsAndServices(mainDTO);
        if(mainDtO.cduDTOObj==null||!sessionMgmt)
        AtlasIntegrationServiceManager.getCurrentUsageByAccount(mainDTO);
        if(mainDTO.accountDTOObj==null||!sessionMgmt)
        AtlasIntegrationServiceManager.getMyAccount(mainDTO);
        **/
        if(mainDTO.currentPaymentMethodDTOObj==null)
        AtlasIntegrationServiceManager.getCurrentPaymentMethod(mainDTO);   
        return mainDTO;
    }
    
    /**
    *  @author Gaurav Gathania 
    *  @description getCurrentBillData
    *  @param object AtlasMainDTO,String invoiceReferenceNumber
    *  @return AtlasCurrentBillDTO
    */ 
    public static AtlasCurrentBillDTO getCurrentBillData(AtlasMainDTO mainDTO,String invoiceReferenceNumber)
    {   /**
        if(AtlasUtility.isEmpty(mainDTO.accountKey)||!sessionMgmt)
        AtlasIntegrationServiceManager.searchCustomerDetails(mainDTO);
        if(AtlasUtility.isEmpty(mainDTO.externalAccountReference)||AtlasUtility.isEmpty(mainDTO.externalSystemName)||!sessionMgmt)
        AtlasIntegrationServiceManager.getAccountServiceAgreementsAndServices(mainDTO);
        if(mainDtO.cduDTOObj==null||!sessionMgmt)
        AtlasIntegrationServiceManager.getCurrentUsageByAccount(mainDTO);
        if(mainDTO.accountDTOObj==null||!sessionMgmt)
        AtlasIntegrationServiceManager.getMyAccount(mainDTO);
        **/
        AtlasCurrentBillDTO c=AtlasIntegrationServiceManager.getSubscriberInvoiceDetails(mainDTO,invoiceReferenceNumber);
        return  c;
    }
    /**
    *  @author Edwin Raymond
    *  @description retrieveInvoiceCDRDet
    *  @param object AtlasMainDTO, String invoiceReferenceNumber
    *  @return object AtlasMainDTO.
    */ 
    public static AtlasMainDTO retrieveInvoiceCDRDet(AtlasMainDTO mainDTO,String invoiceReferenceNumber)
    {
        return AtlasIntegrationServiceManager.getInvoiceDetailsCDRInfo(mainDTO,invoiceReferenceNumber);
    }
    /**
    *  @author Edwin Raymond
    *  @description updateCurrentPaymentSettings
    *  @param object AtlasTransactionDTO.updatedPaymentMethodDTO
    *  @return String
    */ 
    public static String updateCurrentPaymentSettings(AtlasTransactionDTO.updatedPaymentMethodDTO paymentMethodObj)
    {
        return AtlasIntegrationServiceManager.updatePaymentSettings(paymentMethodObj);
    }
    
    /**
    *  @author Edwin Raymond
    *  @description submitOneTimePaymentTransaction
    *  @param object AtlasTransactionDTO.oneTimePaymentDTO paymentObj
    *  @return String
    */ 
    public static String submitOneTimePaymentTransaction(AtlasTransactionDTO.oneTimePaymentDTO paymentObj)
    {
        return AtlasIntegrationServiceManager.submitPaymentTransaction(paymentObj);
    }
    /**
    *  @author Tejesh Kumar
    *  @description submitOneTimePaymentTransactionForAutoResume
    *  @param object AtlasTransactionDTO.oneTimePaymentDTOFOrAutoResume paymentObj
    *  @return String
    */ 
    public static AtlasFinServiceXmlschemaV4FinanceService.OneTimePaymentAutoResumeResults submitOneTimePaymentTransactionForAutoResume(AtlasTransactionDTO.oneTimePaymentDTOForAutoResume paymentObj)
    {
        return AtlasIntegrationServiceManager.submitPaymentTransactionForAutoResume(paymentObj);
    }
    /**
    *  @author Gaurav Gathania 
    *  @description updateCustomerInfo
    *  @param object AtlasTransactionDTO.UpdateCustomerInfoTxDTO custInfoObj
    *  @return String
    */ 
    public static String updateCustomerInfo(AtlasTransactionDTO.UpdateCustomerInfoTxDTO custInfoObj)
    {
        return AtlasIntegrationServiceManager.updateCustomerInfo(custInfoObj);
    }
    /**
    *  @author Gaurav Gathania 
    *  @description 
    *  @param object AtlasMainDTO mainDTO
    *  @return AtlasMainDTO
    */      
    public static AtlasMainDTO getALaCartePackages(AtlasMainDTO mainDTO)
    {                          
        return AtlasIntegrationServiceManager.getALaCartePackages(mainDTO);
    }
    
    /**
    *  @author Gaurav Gathania 
    *  @description addUsageQuota
    *  @param object AtlasMainDTO mainDTOObj,String buyMoreQuantity
    *  @return String
    */     
    public static String addUsageQuota(AtlasMainDTO mainDTOObj,String buyMoreQuantity)
    {   
        AtlasTransactionDTO.AddUsageQuotaDTO addQuotaObj=new AtlasTransactionDTO.AddUsageQuotaDTO();
        AtlasBuyMoreDTO buyMoreObj=mainDTOObj.buyMoreDTOObj;
        Integer buymoreQty=0;
        if(AtlasConstants.buyMoreOneGB==buyMoreQuantity) buymoreQty=1;
        if(AtlasConstants.buyMoreTwoGB==buyMoreQuantity) buymoreQty=2;
        if(AtlasConstants.buyMoreThreeGB==buyMoreQuantity) buymoreQty=3;
        if(AtlasConstants.buyMoreTenGB==buyMoreQuantity) buymoreQty=10;
       
        addQuotaObj.externalSystemName=buyMoreObj.externalSystemName;
        addQuotaObj.externalTransactionReference=buyMoreObj.externalTransactionReference;
        addQuotaObj.externalServiceAgreementReference=buyMoreObj.externalServiceAgreementReference;
        addQuotaObj.responseURL=buyMoreObj.responseURL;
        addQuotaObj.salesChannel=buyMoreObj.salesChannel;
        addQuotaObj.enteredBy=buyMoreObj.enteredBy;
        addQuotaObj.soldBy=buyMoreObj.soldBy;
        addQuotaObj.marketingSourceCode=buyMoreObj.marketingSourceCode;
        addQuotaObj.referralSourceCode=buyMoreObj.referralSourceCode;
        addQuotaObj.note=buyMoreObj.note;           
        addQuotaObj.transactionType=buyMoreObj.transactionType;
        addQuotaObj.enteredBy=mainDTOObj.loggedInUserEmail;
        if(!AtlasUtility.isEmpty(buyMoreObj.usageItems))
        {   List<AtlasTransactionDTO.UsageItems> usgTxObj= new List<AtlasTransactionDTO.UsageItems>();
            AtlasBuyMoreDTO.UsageItem usgItem=buyMoreObj.usageItems[0];
            for(Integer i=0;i<buymoreQty;i++)
                usgTxObj.add(new AtlasTransactionDTO.UsageItems(usgItem.externalOneTimeChargeReference+':'+(i+1)+':'+System.now(),usgItem.masterCatalogNumber,usgItem.displayName,usgItem.price));
            addQuotaObj.usageItems =usgTxObj;
        }
        
        return AtlasIntegrationServiceManager.addUsageQuota(addQuotaObj);
    }

    /*****************************************************************************************************************************************
    *  @author Gaurav Gathania 
    *  @description All below menthods are called for lazy loading of webservices via action functions. 
    *******************************************************************************************************************************************/
    /**
    *  @author Gaurav Gathania 
    *  @description getCurrentDataUsageDashBoradData
    *  @param object AtlasMainDTO mainDTOObj
    *  @return String
    */     
    public static AtlasMainDTO getCurrentDataUsageDashBoradData(AtlasMainDTO mainDTO)
    {   
        if(mainDtO.cduDTOObj==null||!sessionMgmt || mainDTO.cduDTOObj.refreshNow){
            AtlasIntegrationServiceManager.getCurrentUsageByAccount(mainDTO);}
        return mainDTO;
    }   
    
    /**
    *  @author Gaurav Gathania 
    *  @description getMyAccountDashBoardData
    *  @param object AtlasMainDTO mainDTOObj
    *  @return String
    */    
    public static AtlasMainDTO getMyAccountDashBoardData(AtlasMainDTO mainDTO)
    {   if(AtlasUtility.isEmpty(mainDTO.accountDTOObj)||AtlasUtility.isEmpty(mainDTO.accountDTOObj.isBillingDetailsPopulated)||mainDTO.accountDTOObj.isBillingDetailsPopulated==false||!sessionMgmt||AtlasConstants.IS_REFRESH_CALL)
        AtlasIntegrationServiceManager.getMyAccount(mainDTO);
        
        return mainDTO;
    }
    
    /**
    *  @author Srikanth Kudumula 
    *  @description getMyAccountWispDashBoardData
    *  @param object AtlasMainDTO mainDTOObj
    *  @return String
    */    
    public static AtlasMainDTO getMyAccountWispDashBoardData(AtlasMainDTO mainDTO)
    {  
        AtlasIntegrationServiceManager.getPlanName(mainDTO);
        
        return mainDTO;
    }
    
    /**
    *  @author Gaurav Gathania 
    *  @description getBillingSnapShotDashBoardDAta
    *  @param object AtlasMainDTO mainDTOObj
    *  @return String
    */   
    public static AtlasMainDTO getBillingSnapShotDashBoardDAta(AtlasMainDTO mainDTO)
    {
        if(mainDTO.billSnapShotDTOObj==null||!sessionMgmt)    
        {    AtlasIntegrationServiceManager.getBillingsnapShot(mainDTO);
             AtlasIntegrationServiceManager.getSubscriberPaymentHistory(mainDTO);
        }   
        return mainDTO;
    }
    
    /**
    *  @author Gaurav Gathania 
    *  @description getBillingHisory
    *  @param object AtlasMainDTO mainDTOObj
    *  @return String
    */  
    public static AtlasMainDTO getBillingHisory(AtlasMainDTO mainDTO)
    {
        if(mainDTO.billhistoryDTOObj==null||!sessionMgmt)
        AtlasIntegrationServiceManager.getBillingHistory(mainDTO);  
        return mainDTO; 
    }
    
    /**
    *  @author Srikanth Kudumula
    *  @description getTransitionPackages
    *  @param object AtlasMainDTO mainDTOObj
    *  @return String
    */  
    public static AtlasMainDTO getTransitionPackages(AtlasMainDTO mainDTO)
    {
        AtlasIntegrationServiceManager.getTransitionPackages(mainDTO);  
        return mainDTO; 
    }
    
    /**
    *  @author Srikanth Kudumula
    *  @description getTransitionPackages
    *  @param object AtlasMainDTO mainDTOObj
    *  @return String
    */  
    public static AtlasMainDTO getAccountServiceAgreementsAndServicesv2(AtlasMainDTO mainDTO)
    {
        AtlasIntegrationServiceManager.getAccountServiceAgreementsAndServicesv2(mainDTO);  
        return mainDTO; 
    }
    
    /**
    *  @author Tejesh Kumar
    *  @description getAccount
    *  @param object AtlasMainDTO mainDTOObj
    *  @return String
    */  
    public static AtlasMainDTO getAccount(AtlasMainDTO mainDTO)
    {
        AtlasIntegrationServiceManager.getAccount(mainDTO);  
        return mainDTO; 
    }
}