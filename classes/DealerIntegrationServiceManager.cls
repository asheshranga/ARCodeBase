/*********************************************************************************
    Name         : DealerIntegrationServiceManager 
    Created By   : Tejesh Kumar
    Project      : ViaSat Dealer Portal
    Created Date : 06 November 2015
    Usages       : Integration Service Manager to call Integration Utility
*********************************************************************************/
global with sharing class DealerIntegrationServiceManager{
    
    public static String thisClassName='DealerIntegrationServiceManager';
    
    public static DealerMainDTO findSubscribersBySearchCriteria(DealerMainDTO mainDTO)
    {
        //AtlasPublicWebServiceSearchServiceStub.findSubscribersBySearchCriteriaResponse responseObj=AtlasIntegrationUtility.findSubscribersBySearchCriteria(mainDTO.internalAccountReference);
        AtlasPublicWebServiceSearchServiceStub.findSubscribersBySearchCriteriaResponse responseObj=AtlasIntegrationUtility.findSubscribersBySearchCriteria('302283366');
        if(!AtlasUtility.isEmpty(responseObj))
        {
            AtlasPublicWebServiceSearchServiceStub.Subscriber cusInfoObj=responseObj.subscriber[0];
            //mainDTO.accountKey=cusInfoObj.account; 
            if(AtlasUtility.isEmpty(mainDTO.accountDTOObj))
                mainDTO.accountDTOObj=new DealerAccountDTO();
            DealerAccountDTO myAccountObj=mainDTO.accountDTOObj;
            myAccountObj.contactEmail=mainDTO.customerEmail;
            myAccountObj.username=mainDTO.federationId;
            myAccountObj.fullPhotoURL=mainDTO.fullPhotoURL;
            myAccountObj.smallPhotoURL=mainDTO.smallPhotoURL;
            myAccountObj.provisionStatus=cusInfoObj.serviceAgreement.provisioningStatus;
            //myAccountObj.strAccountNumber=mainDTO.accountNo;
            //myAccountObj.strAccountNumber=cusInfoObj.serviceAgreement.internalServiceAgreementReference;
            myAccountObj.strAccountNumber=cusInfoObj.account.internalAccountReference;
            myAccountObj.strAccountType=mainDTO.CommunityUserAccountType;
            mainDTO.externalSystemName=cusInfoObj.serviceAgreement.externalSystemName;
            mainDTO.externalAccountReference=cusInfoObj.account.externalAccountReference;
            mainDTO.accountNo=cusInfoObj.serviceAgreement.internalServiceAgreementReference;
            mainDTO.internalAccountReference=cusInfoObj.account.internalAccountReference;
            mainDTO.deviceProtocol=cusInfoObj.serviceAgreement.deviceProtocol;
            mainDTO.externalServiceAgreementReference=cusInfoObj.serviceAgreement.externalServiceAgreementReference;
            mainDTO.partnerName = cusInfoObj.serviceAgreement.partnerName;
            
            system.debug('---------cusInfoObj.account.externalAccountReference----------'+cusInfoObj.account.externalAccountReference);
            system.debug('---------cusInfoObj.serviceAgreement.externalSystemName----------'+cusInfoObj.serviceAgreement.externalSystemName);
            
            if(!AtlasUtility.isEmpty(cusInfoObj.account))
            {
                 mainDTO.displayAccNo=cusInfoObj.account.externalAccountReference;            
                 mainDTO.accountStatus=cusInfoObj.account.billingStatus;
            }
            if(!AtlasUtility.isEmpty(cusInfoObj.contact))
            {
                mainDTO.customerEmail=cusInfoObj.contact.emailAddress;
                myAccountObj.contactEmail=mainDTO.customerEmail;
                if(!AtlasUtility.isEmpty(cusInfoObj.contact.person))
                {   
                    myAccountObj.firstName=cusInfoObj.contact.person.firstName;
                    myAccountObj.middleName=cusInfoObj.contact.person.middleName;
                    myAccountObj.lastName=cusInfoObj.contact.person.lastName;
                    myAccountObj.phoneMobile=cusInfoObj.contact.primaryPhoneNumber;
                    myAccountObj.secondaryPhone=cusInfoObj.contact.secondaryPhoneNumber;
                }
                if(!AtlasUtility.isEmpty(cusInfoObj.contact.address))
                {
                    if(!AtlasUtility.isEmpty(cusInfoObj.contact.address.addressLine)) 
                    {
                        mainDTO.serviceAdd1=cusInfoObj.contact.address.addressLine[0];
                        if(cusInfoObj.contact.address.addressLine.size()>1) 
                            mainDTO.serviceAdd2=cusInfoObj.contact.address.addressLine[1];
                    }       
                    mainDTO.serviceAddCity=cusInfoObj.contact.address.municipality;
                    mainDTO.serviceAddState=cusInfoObj.contact.address.region;
                    mainDTO.serviceAddZip=cusInfoObj.contact.address.postalCode;
                }
            }
            myAccountObj.populateServiceAddress(mainDTO);
        } 
        system.debug('--mainDTO--> '+mainDTO);  
        return mainDTO;
    }
    
    /**
    * @author Srikanth Kudumula
    * @param mainDTO - DealerMainDTO object
    * @Calls AtlasIntegrationUtility to get getTransitionPackages
    * @return DealerMainDTO mainDTO
    */  
    public static DealerMainDTO getTransitionPackages(DealerMainDTO mainDTO)
    { 
    	system.debug('--------------------@@@@------------------------>marker: DealerIntegrationSvcMgr --> getTransitionPkgs() top of method');
        DealerChangePlanDTO changePlanDTOObj = new DealerChangePlanDTO();//mainDTO.changePlanDTOObj;
        List<AtlasPlan__c> plansToDisplay= new List<AtlasPlan__c>();
        Set<string> plansToSkipList= new Set<string>();
        AtlasPubCatlogServiceXmlschemaV2.Package_TPTest[] usagePckg;       
        List<AtlasPubCatlogServiceXmlschemaV2.OptionGroup> optionGroups=null;
        List<AtlasPubCatlogServiceXmlschemaV2.Feature> features = null;
        String dataCapacity = '0';
        String downloadSpeed = null;
        String speedUnit = null;
        String uploadSpeed = null;
        String freeZone = null;
        String voiceAdapter = null;
        String wirelessRtr = null;
        String thresholds = null;
        String addlDataAllowance = null;
        String promotions = null;
        
        Map<String,String> bonusFeaturesMap = new Map<String,String>(); 
        
        plansToDisplay= [select id,PlanAPIName__c,SelfCareTransitionAllowed__c from AtlasPlan__c where SelfCareTransitionAllowed__c=: false];
        for(AtlasPlan__c plan : plansToDisplay) {
            plansToSkipList.add(plan.PlanAPIName__c);        
        }
        system.debug('---plansToSkipList---> '+plansToSkipList);
            
        List<AtlasPlanAttributes__c> apaList = [select AttributeValue__c, SelfcareText__c from AtlasPlanAttributes__c];
        for(AtlasPlanAttributes__c apa : apaList){
            bonusFeaturesMap.put(apa.AttributeValue__c,apa.SelfcareText__c);
        }
         try{
         	system.debug('--------------------@@@@------------------------>marker: DealerIntegrationSvcMgr --> getTransitionPkgs() try stmt');
                //usagePckg=AtlasIntegrationUtility.getTransitionPackages(mainDTO.externalSystemName, mainDTO.externalAccountReference);//uncomment when all APIs avail
                usagePckg=AtlasIntegrationUtility.getTransitionPackages('WB_DIRECT', '14186546');//hard-coded for testing
            system.debug('@@@ Usage Package--->'+usagePckg);
            if(!AtlasUtility.isEmpty(usagePckg) )
            {
                System.debug('@@@  I am inside parser --->');
                changePlanDTOObj.changePlanPackages=new List<DealerChangePlanDTO.changePlanPackage>();
                for(AtlasPubCatlogServiceXmlschemaV2.Package_TPTest p: usagePckg)
                {   
                    optionGroups = p.optionGroup;
                    features = p.feature;
                    dataCapacity = '0';
                    system.debug('@@@ features --->'+features);
                    for(AtlasPubCatlogServiceXmlschemaV2.feature f : features){
                        if(f.name == 'DATA_CAP_GB') 
                            dataCapacity = f.value;
                        if(f.name == 'DOWNLOAD_SPEED') 
                            downloadSpeed = f.value;//.removeEndIgnoreCase('Download Speed');
                        if(f.name == 'UPLOAD_SPEED') 
                            uploadSpeed = f.value;//.removeEndIgnoreCase('Upload Speed');
                        if(f.name == 'FREE_ZONE')
							freeZone = f.value;
                        if(f.name == 'ADDITIONAL_DATA_ALLOWANCE')
							addlDataAllowance = f.value;
                        
                    }
                    system.debug('@@@ individual package --->'+optionGroups);
                    for(AtlasPubCatlogServiceXmlschemaV2.OptionGroup og : optionGroups) { 
                        if(og.displayName == 'Internet Access Service'){
                            AtlasPubCatlogServiceXmlschemaV2.PackageItem pckItem=og.packageItem[0];
                            system.debug('@@@ og.packageItem[0] --->'+og.packageItem[0]);
                            if(!Test.isRunningTest()){
                                system.debug('---pckItem.displayName--->'+pckItem.displayName); 
                                if(!plansToSkipList.contains(pckItem.displayName)) {                                                   
                                    changePlanDTOObj.changePlanPackages.add(new DealerChangePlanDTO.changePlanPackage(pckItem.packageItemPrice[0].price,pckItem.displayName,pckItem.packageItemPrice[0].masterCatalogReference,dataCapacity,downloadSpeed,uploadSpeed,freeZone,voiceAdapter,wirelessRtr,thresholds,addlDataAllowance,promotions));
                                }
                            }
                        }
                    }
                } 
                AtlasUtility.populateSuccess(changePlanDTOObj);
            }
        }catch(Exception e)
        {
            system.debug('@@@ message --->'+e.getMessage());
            AtlasUtility.populateExceptionString(thisClassName+':getTransitionPackages',changePlanDTOObj,e);
        }
        mainDTO.changePlanDTOObj = changePlanDTOObj;
        system.debug('@@@ change plan DTO --->'+mainDTO.changePlanDTOObj);
        //system.assert(false, 'assert failure');
        //system.debug('--------------------@@@@------------------------>marker: DealerIntegrationSvcMgr --> !accountDTO.serviceLevel '+mainDTO.accountDTOObj.serviceLevel);
        return mainDTO;
    }
    
     /**
    * @author Srikanth Kudumula
    * @Calls AtlasIntegrationUtility to get getALaCartePackages
    * @return DealerMainDTO mainDTO
    */  
    public static DealerMainDTO getALaCartePackages(DealerMainDTO mainDTO)
    { 
        AtlasPubCatlogServiceXmlschemaV2.Package_Test[] usagePckg;
        try{
            usagePckg=AtlasIntegrationUtility.getALaCartePackages(mainDTO.externalSystemName, mainDTO.externalAccountReference, mainDTO.transactionType);
            system.debug('@@@ usagePckg --->'+usagePckg);
            if(!AtlasUtility.isEmpty(usagePckg) )
            {
            	AtlasPubCatlogServiceXmlschemaV2.OptionGroup[] optionGroups;
                for(AtlasPubCatlogServiceXmlschemaV2.Package_Test p: usagePckg)
                {       
                	for(AtlasPubCatlogServiceXmlschemaV2.OptionGroup og : p.optionGroup)
                	{
                		system.debug('@@@ displayName --->'+og.packageItem[0].displayName);
                		if(og.packageItem[0].displayName == 'Exede Voice')
                		{
                			system.debug('@@@ displayName --->'+og.packageItem[0].displayName);
                		}
                	}
                }
                AtlasUtility.populateSuccess(mainDTO);
            }
        }catch(Exception e)
        {
            AtlasUtility.populateExceptionString(thisClassName+':getALaCartePackages',mainDTO,e);
        }
        return mainDTO;
    }
    
    /**
    * @author Srikanth Kudumula
    * @description - getLegacyAccount,
    * @input param  - DealerMainDTO mainDTO
    * @return param AtlasPublicWebServiceSearchServiceStub.findSubscribersBySearchCriteriaResponse
    **/
    public static DealerMainDTO getLegacyAccount(DealerMainDTO mainDTO) {
        mainDTO.accountKey=AtlasIntegrationUtility.getLegacyAccount(mainDTO.externalSystemName, mainDTO.externalAccountReference, mainDTO.internalAccountReference);
        //mainDTO.accountKey=AtlasIntegrationUtility.getLegacyAccount('WB_DIRECT', '14186546', '302283366');//for testing only
        //system.debug('@@@ Account Key --->'+mainDTO.accountKey);
        return mainDTO;      
    }
    
    /**
    * @author Srikanth Kudumula
    * @description - getLegacyAccount,
    * @input param  - DealerMainDTO mainDTO
    * @return param DealerMainDTO mainDTO
    **/
    public static DealerMainDTO getAccount(DealerMainDTO mainDTO) {
    	DealerPubAccountInfoXMLSchemaV2.account acc;
    	try{
    		DealerPubServiceV2PWSCommonData.ExternalSubscriberIdentifier exSubId = buildParameters(mainDTO);
    		system.debug('@@@ parameters --->'+exSubId);
        	acc=AtlasIntegrationUtility.getAccount(exSubId);
        	if(!AtlasUtility.isEmpty(acc))
        	{
        		mainDTO.cusInfoDTO.contractTerm = acc.contractInfo.term;
        		mainDTO.cusInfoDTO.contrRenewalDate = acc.contractInfo.renewalDate;
        		mainDTO.cusInfoDTO.orgActivationDate = acc.originalActivationDate;
        		mainDTO.cusInfoDTO.remMononContract = acc.contractInfo.remainingMonths;
        		mainDTO.cusInfoDTO.serAgrActivationDate = acc.activationDate;
        		mainDTO.cusInfoDTO.billStreet1 = acc.billingAddress.address1;
        		mainDTO.cusInfoDTO.billStreet2 = acc.billingAddress.address2;
        		mainDTO.cusInfoDTO.billCity = acc.billingAddress.city;
        		mainDTO.cusInfoDTO.billState = acc.billingAddress.state;
        		mainDTO.cusInfoDTO.billZip = acc.billingAddress.zip;
        		mainDTO.cusInfoDTO.billZipLastFour = acc.billingAddress.zipFour;
        		mainDTO.cusInfoDTO.password = acc.password;
        		system.debug('@@@ Account --->'+acc);
        	}
    	}
    	catch(exception e){
    		 AtlasUtility.populateExceptionString(thisClassName+':getAccount',mainDTO,e);
    	}
        return mainDTO;      
    }
    
    /**
    * @author Srikanth Kudumula
    * @description - getInstallationInfo,
    * @input param  - DealerMainDTO mainDTO
    * @return param DealerMainDTO mainDTO
    **/
    public static DealerMainDTO getInstallationInfo(DealerMainDTO mainDTO) {
    	DealerPubAccountInfoXMLSchemaV2.installationInfo installationInfo;
    	try{
    		DealerPubServiceV2PWSCommonData.ExternalSubscriberIdentifier exSubId = buildParameters(mainDTO);
    		system.debug('@@@ parameters --->'+exSubId);
        	installationInfo=AtlasIntegrationUtility.getInstallationInfo(exSubId);
        	if(!AtlasUtility.isEmpty(installationInfo))
        	{
        		system.debug('@@@ installationInfo --->'+installationInfo);
        	}
    	}
    	catch(exception e){
    		 AtlasUtility.populateExceptionString(thisClassName+':getAccount',mainDTO,e);
    	}
    	system.debug('@@@ installationInfo --->'+installationInfo);
        return mainDTO;      
    }
    
     /**
    * @author Tejesh M
    * @param mainDTO - DealerMainDTO object
    * @Calls AtlasIntegrationUtility to get getPackages
    * @return DealerMainDTO mainDTO
    */  //usagePckg=AtlasIntegrationUtility.getPackages('P10_SALES_ONLY','RESIDENTIAL','newConnect',368,'ViaSat-1');
    public static DealerMainDTO getPackages(DealerMainDTO mainDTO)
    { 
        DealerPlansDTO plansDTOObj = new DealerPlansDTO();//mainDTO.changePlanDTOObj;
        List<AtlasPlan__c> plansToDisplay= new List<AtlasPlan__c>();
        Set<string> plansToSkipList= new Set<string>();
        AtlasPubCatlogServiceXmlschemaV2.Package_x[] usagePckg;       
        List<AtlasPubCatlogServiceXmlschemaV2.OptionGroup> optionGroups=null;
        List<AtlasPubCatlogServiceXmlschemaV2.Feature> features = null;
        String dataCapacity = '0';
        String downloadSpeed = null;
        String speedUnit = null;
        String uploadSpeed = null;
        String freeZone = null;
        String voiceAdapter = null;
        String wirelessRtr = null;
        String thresholds = null;
        String addlDataAllowance = null;
        String promotions = null;
        
        Map<String,String> bonusFeaturesMap = new Map<String,String>(); 

        plansToDisplay= [select id,PlanAPIName__c,SelfCareTransitionAllowed__c from AtlasPlan__c where SelfCareTransitionAllowed__c=: false];
        for(AtlasPlan__c plan : plansToDisplay) {
            plansToSkipList.add(plan.PlanAPIName__c);        
        }
        system.debug('---plansToSkipList---> '+plansToSkipList);
            
        List<AtlasPlanAttributes__c> apaList = [select AttributeValue__c, SelfcareText__c from AtlasPlanAttributes__c];
        for(AtlasPlanAttributes__c apa : apaList){
            bonusFeaturesMap.put(apa.AttributeValue__c,apa.SelfcareText__c);
        }
         try{
                usagePckg=AtlasIntegrationUtility.getPackages('P10_SALES_ONLY','RESIDENTIAL','newConnect',368,'ViaSat-1');
            system.debug('@@@ Usage Package--->'+usagePckg);
            if(!AtlasUtility.isEmpty(usagePckg) )
            {
                System.debug('@@@  I am inside parser --->');
                plansDTOObj.changePlanPackages=new List<DealerPlansDTO.changePlanPackage>();
                for(AtlasPubCatlogServiceXmlschemaV2.Package_x p: usagePckg)
                {   
                    optionGroups = p.optionGroup;  
                    features = p.feature;
                    dataCapacity = '0';
                    system.debug('@@@ features --->'+features);
                    for(AtlasPubCatlogServiceXmlschemaV2.feature f : features){
                        if(f.name == 'DATA_CAP_GB') 
                            dataCapacity = f.value;
                        if(f.name == 'DOWNLOAD_SPEED') 
                            downloadSpeed = f.value;//.removeEndIgnoreCase('Download Speed');
                        if(f.name == 'UPLOAD_SPEED') 
                            uploadSpeed = f.value;//.removeEndIgnoreCase('Upload Speed');
                        if(f.name == 'FREE_ZONE')
							freeZone = f.value;
                        if(f.name == 'ADDITIONAL_DATA_ALLOWANCE')
							addlDataAllowance = f.value;
                    }
                    system.debug('@@@ individual package --->'+optionGroups); 
                    for(AtlasPubCatlogServiceXmlschemaV2.OptionGroup og : optionGroups) { 
                        if(og.displayName == 'Internet Access Service'){
                            AtlasPubCatlogServiceXmlschemaV2.PackageItem pckItem=og.packageItem[0];
                            system.debug('@@@ og.packageItem[0] --->'+og.packageItem[0]);
                            if(!Test.isRunningTest()){
                                system.debug('---pckItem.displayName--->'+pckItem.displayName);
                                if(!plansToSkipList.contains(pckItem.displayName)) {                                                   
                                    plansDTOObj.changePlanPackages.add(new DealerPlansDTO.changePlanPackage(pckItem.packageItemPrice[0].price,pckItem.displayName,pckItem.packageItemPrice[0].masterCatalogReference,dataCapacity,downloadSpeed,uploadSpeed,freeZone,voiceAdapter,wirelessRtr,thresholds,addlDataAllowance,promotions));
                                }
                            }
                        }
                    }
                } 
                //AtlasUtility.populateSuccess(plansDTOObj);
            }
        }catch(Exception e)
        {
            system.debug('@@@ message --->'+e.getMessage()); 
        }
        mainDTO.plansDTOObj = plansDTOObj;
        system.debug('@@@ plansDTOObj--->'+plansDTOObj); 
        //system.assert(false, 'assert failure');
        return mainDTO;
        //return null;
    }
    
	/**
    * @author Srikanth Kudumula
    * @description - buildParameters,
    * @input param  - DealerMainDTO
    * @return param DealerPubServiceV2PWSCommonData.ExternalSubscriberIdentifier element
    */
    public static DealerPubServiceV2PWSCommonData.ExternalSubscriberIdentifier buildParameters(DealerMainDTO mainDto)
    {
			DealerPubServiceV2PWSCommonData.ExternalSubscriberIdentifier param = new DealerPubServiceV2PWSCommonData.ExternalSubscriberIdentifier();
			param.externalSystemName = mainDto.externalSystemName;
			param.externalReference = mainDto.externalAccountReference;
			param.externalReferenceType = mainDto.externalAccountReferencetype;
			return param;
    }
    
    /**
    * @author Jim Tunney
    * @description - searchCustomerDetails
    * @param  - DealerMainDTO mainDTO
    * @return - mainDTO - DealerMainDTO obj
    */   
    public static DealerMainDTO searchCustomerDetails(DealerMainDTO mainDTO)
    {   
    	//system.assert(false,'assert in DlrIntSvcMgr -->searchCustomerDetails()');
    	//system.debug('--------------------@@@@------------------------>marker: searchCustomerDetails()');
		AtlasCustomerSearchWS.customerInfoBean cusInfoObj;
			try{ 
				//system.assert(false,'assert in DlrIntSvcMgr -->searchCustomerDetails()');
	      		mainDTO=findSubscribersBySearchCriteria(mainDTO);
	      		return mainDTO;
            }
            catch(Exception e)
            {
                AtlasUtility.populateExceptionString(thisClassName+':searchCustomer',mainDTO,e);
            }
            return mainDTO;
    }
    /**
    * @author Jim Tunney
    * @description - getAccountServiceAgreementsAndServices
    * @param  - DealerMainDTO mainDTO
    * @return - mainDTO - DealerMainDTO obj
    */  
    public static DealerMainDTO getAccountServiceAgreementsAndServices(DealerMainDTO mainDTO)
    { 
    	//system.debug('--------------------@@@@------------------------>marker: getAcctSvcAgreeAndSvcs()');
    	//system.assert(false,'assert in DlrIntSvcMgr -->getAcctSvcAgreeAndSvcs()');
        try{
            mainDTO=getLegacyAccount(mainDTO);
            return mainDTO;   
        }catch(Exception e)
        {
            AtlasUtility.populateExceptionString(thisClassName+':getAccountServiceAgreementsAndServices',mainDTO,e);
        }
        return mainDTO;
    }
    
    /**
    * @author Srikanth Kudumula
    * @description - getAccountProvisioningInfo,
    * @input param  - DealerMainDTO mainDTO
    * @return param DealerMainDTO mainDTO
    **/
    public static DealerMainDTO getAccountProvisioningInfo(DealerMainDTO mainDTO) {
    	DealerPubAccountInfoXMLSchemaV2.provisioningInfoBean[] accProvisioningInfo;
    	DealerPubAccountInfoXMLSchemaV2.provisioningInfoBean accProvInfo;
    	try{
    		DealerPubServiceV2PWSCommonData.ExternalSubscriberIdentifier exSubId = buildParameters(mainDTO);
    		system.debug('@@@ parameters --->'+exSubId);
        	accProvisioningInfo=AtlasIntegrationUtility.getAccountProvisioningInfo(exSubId);
        	if(!AtlasUtility.isEmpty(accProvisioningInfo))
        	{
        		accProvInfo = accProvisioningInfo[0];
        		mainDTO.cusInfoDTO.userName = accProvInfo.username;
        		mainDTO.cusInfoDTO.beamNumber = accProvInfo.equipment.beamNumber;
        		mainDTO.cusInfoDTO.satelliteId = accProvInfo.equipment.satelliteId;
        		mainDTO.cusInfoDTO.modemKey = accProvInfo.equipment.modemInstallCode;
        		mainDTO.cusInfoDTO.polaziration = accProvInfo.equipment.polarization;
        		system.debug('@@@ accProvisioningInfo --->'+accProvisioningInfo);
        	}
    	}
    	catch(exception e){
    		 AtlasUtility.populateExceptionString(thisClassName+':getAccount',mainDTO,e);
    	}
    	system.debug('@@@ accProvisioningInfo --->'+accProvisioningInfo);
        return mainDTO;      
    }
	
	/**
    * @author Srikanth Kudumula
    * @description - getBillingSummary,
    * @input param  - DealerMainDTO mainDTO
    * @return param DealerMainDTO mainDTO
    **/
    public static DealerMainDTO getBillingSummary(DealerMainDTO mainDTO) {
    	DealerPubAccountInfoXMLSchemaV2.billingSummary billingSummary;
    	try{
    		DealerPubServiceV2PWSCommonData.ExternalSubscriberIdentifier exSubId = buildParameters(mainDTO);
    		system.debug('@@@ parameters --->'+exSubId);
        	billingSummary=AtlasIntegrationUtility.getBillingSummary(exSubId);
        	if(!AtlasUtility.isEmpty(billingSummary))
        	{
        		mainDTO.cusInfoDTO.billingAccNumber = billingSummary.accountNumber;
        		mainDTO.cusInfoDTO.avKey = billingSummary.antivirusInfos[0].antivirusKey;
        		mainDTO.cusInfoDTO.avService = billingSummary.antivirusInfos[0].antivirusServices;
        		mainDTO.cusInfoDTO.avStatus = billingSummary.antivirusInfos[0].antivirusStatus;
        		mainDTO.cusInfoDTO.avStatusDate = billingSummary.antivirusInfos[0].antivirusEffectiveDate;
        		system.debug('@@@ billingSummary --->'+billingSummary);
        	}
    	}
    	catch(exception e){
    		 AtlasUtility.populateExceptionString(thisClassName+':getAccount',mainDTO,e);
    	}
    	system.debug('@@@ billingSummary --->'+billingSummary);
        return mainDTO;      
    }
	
	/**
    * @author Srikanth Kudumula
    * @description - getBillingInfo,
    * @input param  - DealerMainDTO mainDTO
    * @return param DealerMainDTO mainDTO
    **/
    public static DealerMainDTO getBillingInfo(DealerMainDTO mainDTO) {
    	DealerPubAccountInfoXMLSchemaV2.billingInfoBean billingInfo;
    	try{
    		DealerPubServiceV2PWSCommonData.ExternalSubscriberIdentifier exSubId = buildParameters(mainDTO);
    		system.debug('@@@ parameters --->'+exSubId);
        	billingInfo=AtlasIntegrationUtility.getBillingInfo(exSubId);
        	if(!AtlasUtility.isEmpty(billingInfo))
        	{
        		mainDTO.cusInfoDTO.billingCycle = billingInfo.billCycle;
        		mainDTO.cusInfoDTO.currentAmtDue = billingInfo.currentAmountDue;
        		system.debug('@@@ billingInfo --->'+billingInfo);
        	}
    	}
    	catch(exception e){
    		 AtlasUtility.populateExceptionString(thisClassName+':getAccount',mainDTO,e);
    	}
    	system.debug('@@@ billingInfo --->'+billingInfo);
        return mainDTO;      
    }
    
    /**
    * @author Srikanth Kudumula
    * @description - getAllAcountServices,
    * @input param  - DealerMainDTO mainDTO
    * @return param DealerMainDTO mainDTO
    **/
    public static DealerMainDTO getAllAccountServices(DealerMainDTO mainDTO) {
    	DealerPubAccountInfoXMLSchemaV2.accountService[] accountServices;
    	AccountServicesDTO accServDTO = new AccountServicesDTO();
    	try{
    		DealerPubServiceV2PWSCommonData.ExternalSubscriberIdentifier exSubId = buildParameters(mainDTO);
    		system.debug('@@@ parameters --->'+exSubId);
        	accountServices=AtlasIntegrationUtility.getAllAccountServices(exSubId);
        	if(!AtlasUtility.isEmpty(accountServices))
        	{
        		accServDTO.products = new List<AccountServicesDTO.product>();
        		for(DealerPubAccountInfoXMLSchemaV2.accountService accSer : accountServices){
        			if(accSer.type_x == 'INTERNET_ACCESS_SERVICE'){
        				mainDTO.cusInfoDTO.ispproductName = accSer.name;
        				mainDTO.cusInfoDTO.ispserviceLevel = accSer.description;
        				mainDTO.cusInfoDTO.ispeffectiveDate = accSer.effectiveDate;
        				mainDTO.cusInfoDTO.ispprovisioningStatus = accSer.status;
        				mainDTO.cusInfoDTO.equipmentPlan = accSer.equipmentPlan;
        			}
        			accServDTO.products.add(new AccountServicesDTO.product(accSer.name,accSer.description,accSer.effectiveDate,accSer.status));
        		}
        		mainDTO.accServDTO = accServDTO;
        		system.debug('@@@ mainDTO --->'+mainDTO);
        	}
    	}
    	catch(exception e){
    		 AtlasUtility.populateExceptionString(thisClassName+':getAccount',mainDTO,e);
    	}
    	system.debug('@@@ getAllAccountServices --->'+accountServices);
        return mainDTO;      
    }
    
    /**
    * @author Srikanth Kudumula
    * @description - getSubscriberPaymentHistory
    * @input param  - DealerMainDTO mainDTO
    * @return param DealerMainDTO
    */
    public static DealerMainDTO getSubscriberPaymentHistory(DealerMainDTO mainDTO)
    {
        AtlasFinServiceXmlschemaFinanceService.PaymentHistoryItem paymentHistoryObj;
        try{
            paymentHistoryObj=AtlasIntegrationUtility.getSubscriberPaymentHistory(mainDTO.externalSystemName,mainDTO.externalAccountReference,1,mainDTO.internalAccountReference);
            if(paymentHistoryObj!=null)
            {
                mainDTO.cusInfoDTO.billInfoDate = paymentHistoryObj.date_x;
            }
        }catch(Exception e)
        {
            
        }
        return mainDTO;
    }
}