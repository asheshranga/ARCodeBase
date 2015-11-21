/*********************************************************************************
    Name         : AtlasIntegrationServiceManager 
    Created By   : Gaurav Gathania
    Modified BY  : Gaurav Gathania
    Company Name : NTT Data
    Project      : ViaSat Atlas, Bangalore
    Created Date : 29 October 2013
    Modified Date : 13 November 2013
    Usages       : Integration Service Manager to call Integration Ultitlity
*********************************************************************************/
global with sharing class AtlasIntegrationServiceManager{

    public static String thisClassName='AtlasIntegrationServiceManager';
    
    public static AtlasMainDTO findSubscribersBySearchCriteria(AtlasMainDTO mainDTO)
    {
        AtlasPublicWebServiceSearchServiceStub.findSubscribersBySearchCriteriaResponse repsonseObj=AtlasIntegrationUtility.findSubscribersBySearchCriteria(mainDTO.internalAccountReference);
        if(!AtlasUtility.isEmpty(repsonseObj))
        {
            AtlasPublicWebServiceSearchServiceStub.Subscriber cusInfoObj=repsonseObj.subscriber[0];
            //mainDTO.accountKey=cusInfoObj.account; 
            if(AtlasUtility.isEmpty(mainDTO.accountDTOObj))
                mainDTO.accountDTOObj=new AtlasAccountDTO();
            AtlasAccountDTO myAccountObj=mainDTO.accountDTOObj;
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
            system.debug('----------cusInfoObj----------'+cusInfoObj);
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
    
    // IF DTO does not have this data THEN build the REQUEST to get it, ELSE return NULL to indicate that data is in DTO already
    public static string findSubscribersBySearchCriteriaRequest(AtlasMainDTO mainDTOObj) 
    {        
        // Check if already got mainDTOObj.accountKey populated
        if (!(AtlasUtility.isEmpty(mainDTOObj.accountKey) || !AtlasDataDispatcher.sessionMgmt))
            return null;

        return AtlasIntegrationUtility.findSubscribersBySearchCriteriaEnvelope(AtlasConstants.EX_REF_FOR_SEARCH, mainDTOObj.internalAccountReference);
    }

     /**
    * @author Gaurav Gathania
    * @description - getLegacyAccount,
    * @input param  - String externalAccountNo
    * @return param AtlasPublicWebServiceSearchServiceStub.findSubscribersBySearchCriteriaResponse
    **/
    public static AtlasMainDTO getLegacyAccount(AtlasMainDTO mainDTO) {
        mainDTO.accountKey=AtlasIntegrationUtility.getLegacyAccount(mainDTO.externalSystemName, mainDTO.externalAccountReference, mainDTO.internalAccountReference); 
        // To determine VOIP Accounts 
        AtlasIntegrationServiceManager.getAccountServicesAtlas(mainDTO);
        
        return mainDTO;      
    }
    
    // IF DTO does not have this data THEN build the REQUEST to get it, ELSE return NULL to indicate that data is in DTO already
    public static string getLegacyAccountRequest(AtlasMainDTO mainDTOObj) 
    {        
        // Check if got mainDTOObj.accountKey populated
        if (!(AtlasUtility.isEmpty(mainDTOObj.accountKey) || !AtlasDataDispatcher.sessionMgmt))
            return null;

        return AtlasIntegrationUtility.getLegacyAccountEnvelope(mainDTOObj.externalSystemName, mainDTOObj.externalAccountReference, mainDTOObj.internalAccountReference);
    }

    /**
    * @author Gaurav Gathania
    * @description - searchCustomerDetails, taking an input parameter of type String accountNo
    * @input param  - AtlasMainDTO mainDTO
    * @return param AtlasMainDTO
    */   
    public static AtlasMainDTO searchCustomerDetails(AtlasMainDTO mainDTO)
    {   
        AtlasCustomerSearchWS.customerInfoBean cusInfoObj;
        DateTime startTime;
		DateTime endTime;

          try{
                	startTime = System.now();
                    mainDTO=findSubscribersBySearchCriteria(mainDTO);
                    endtime  = System.now();

					AtlasTransactionModel txnModel = new AtlasTransactionModel('Dashboard Load Time','My Account','searchCustomerDetails',mainDTO.accountNo,mainDTO.externalAccountReference,startTime,endTime);
					addAtlasTransactionModel(mainDTO, txnModel); 
					System.debug('++++AR: ----searchCustomerDetails');
                    return mainDTO;
                /*cusInfoObj=AtlasIntegrationUtility.searchCustomer(mainDTO.accountNo);
                if(!AtlasUtility.isEmpty(cusInfoObj))
                {       
                    mainDTO.accountKey=cusInfoObj.account;
                    mainDTO.displayAccNo=cusInfoObj.displayAccountNumber;
                    mainDTO.customerEmail=cusInfoObj.emailAddress;
                    mainDTO.accountStatus=cusInfoObj.accountStatus;
                    mainDTO.serviceAdd1=cusInfoObj.serviceAddress.address1;
                    mainDTO.serviceAdd2=cusInfoObj.serviceAddress.address2;
                    mainDTO.serviceAddCity=cusInfoObj.serviceAddress.city;
                    mainDTO.serviceAddCounty=cusInfoObj.serviceAddress.county;
                    mainDTO.serviceAddState=cusInfoObj.serviceAddress.state;
                    mainDTO.serviceAddZip=cusInfoObj.serviceAddress.zip;
                    if(AtlasUtility.isEmpty(mainDTO.accountDTOObj))
                    mainDTO.accountDTOObj=new AtlasAccountDTO();
                    AtlasAccountDTO myAccountObj=mainDTO.accountDTOObj;
                    myAccountObj.contactEmail=mainDTO.customerEmail;
                    myAccountObj.username=mainDTO.federationId;
                    myAccountObj.fullPhotoURL=mainDTO.fullPhotoURL;
                    myAccountObj.smallPhotoURL=mainDTO.smallPhotoURL;
                    myAccountObj.strAccountNumber=mainDTO.internalAccountReference;
                    myAccountObj.strAccountType=mainDTO.CommunityUserAccountType;
                    myAccountObj.firstName=cusInfoObj.firstName;
                    myAccountObj.lastName=cusInfoObj.lastName;
                    myAccountObj.displayAccNum=cusInfoObj.displayAccountNumber;
                    myAccountObj.username=mainDTO.federationId;
                    if(!AtlasUtility.isEmpty(cusInfoObj.daytimePhone))
                    myAccountObj.phoneMobile=cusInfoObj.daytimePhone;
                    else if(!AtlasUtility.isEmpty(cusInfoObj.mobilePhone))
                    myAccountObj.phoneMobile=cusInfoObj.mobilePhone;
                    myAccountObj.populateServiceAddress(mainDTO);
                    AtlasUtility.populateSuccess(mainDTO);
                }*/
            }
            catch(Exception e)
            {
                AtlasUtility.populateExceptionString(thisClassName+':searchCustomer',mainDTO,e);
            }
            return mainDTO;
    }
    
     /**
    * @author Tejesh Kumar
    * @description - searchCustomerDetailsforWisp, taking an input parameter of type String accountNo
    * @input param  - AtlasMainDTO mainDTO
    * @return param AtlasMainDTO
    */   
    public static AtlasMainDTO searchCustomerDetailsforWisp(AtlasMainDTO mainDTO)
    {     Map<String,String> resMap = new Map<String,String>();
          
          try{
                 resMap=AtlasIntegrationUtility.findSubscriberBySearchCriteriaV2(mainDTO);
                 mainDTO = processSubscribersBySearchCriteriaResponse(resMap, mainDTO);
            }
            catch(Exception e)
            {
                AtlasUtility.populateExceptionString(thisClassName+':searchCustomer',mainDTO,e);
            }
            return mainDTO;
    }
    
    // Parse web service Response, init AtlasMainDTO
    public static AtlasMainDTO processSubscribersBySearchCriteriaResponse(Map<String,String> resMap, AtlasMainDTO mainDTO)
    {
        if (resMap != null)
        {                   
                if (mainDTO.accountDTOObj == null)
                    mainDTO.accountDTOObj = new AtlasAccountDTO();
                
                AtlasAccountDTO myAccountObj = mainDTO.accountDTOObj;
                myAccountObj.contactEmail=mainDTO.customerEmail;
                myAccountObj.username=mainDTO.federationId;
                myAccountObj.fullPhotoURL=mainDTO.fullPhotoURL;
                myAccountObj.smallPhotoURL=mainDTO.smallPhotoURL;
                myAccountObj.provisionStatus = resMap.get('provisioningStatus');
                myAccountObj.strAccountType=mainDTO.CommunityUserAccountType;                                   
                myAccountObj.strAccountNumber = resMap.get('internalAccountReference');
                    
                mainDTO.externalSystemName=resMap.get('externalSystemName');
                mainDTO.externalAccountReference=resMap.get('externalAccountReference');
                mainDTO.accountNo=resMap.get('internalServiceAgreementReference');
                mainDTO.internalAccountReference=resMap.get('internalAccountReference');
                mainDTO.deviceProtocol=resMap.get('deviceProtocol');
                mainDTO.externalServiceAgreementReference=resMap.get('externalServiceAgreementReference');
                mainDTO.partnerName = resMap.get('partnerName');

                // Account info
                if (resMap.containsKey('businessName'))                      
                        myAccountObj.businessName=resMap.get('businessName');
                    
                if (resMap.containsKey('externalAccountReference'))
                        mainDTO.displayAccNo = resMap.get('externalAccountReference');                                   
                if (resMap.containsKey('billingStatus'))
                        mainDTO.accountStatus = resMap.get('billingStatus');
                    
                // Contact info
                if (resMap.containsKey('emailAddress'))
                        mainDTO.customerEmail = resMap.get('emailAddress');
                myAccountObj.contactEmail = mainDTO.customerEmail;
                    
                // Contact.person info
                if (resMap.containsKey('firstName'))
                        myAccountObj.firstName = resMap.get('firstName');
                if (resMap.containsKey('middleName'))
                        myAccountObj.middleName = resMap.get('middleName');
                if (resMap.containsKey('lastName'))
                        myAccountObj.lastName = resMap.get('lastName');
                if (resMap.containsKey('primaryPhoneNumber'))
                        myAccountObj.phoneMobile = resMap.get('primaryPhoneNumber');
                if (resMap.containsKey('secondaryPhoneNumber'))
                        myAccountObj.secondaryPhone = resMap.get('secondaryPhoneNumber');

                // Contact.address info
                if (resMap.containsKey('addressLine'))
                    mainDTO.serviceAdd1=resMap.get('addressLine');
                if (resMap.containsKey('municipality'))
                    mainDTO.serviceAddCity = resMap.get('municipality');
                if (resMap.containsKey('region'))
                    mainDTO.serviceAddState = resMap.get('region');
                if (resMap.containsKey('postalCode'))
                    mainDTO.serviceAddZip = resMap.get('postalCode');
                myAccountObj.populateServiceAddress(mainDTO);
        }        
        return mainDTO; 
    }
    
    /**
    * @author Gaurav Gathania
    * @description - getAccountServiceAgreementsAndServices
    * @input param  - AtlasMainDTO mainDTO
    * @return param AtlasMainDTO
    */  
    public static AtlasMainDTO getAccountServiceAgreementsAndServices(AtlasMainDTO mainDTO)
    { 
        //AtlasAccInfoXmlschemaPublic.accountServiceAgreementsBean servAgrmntInfoObj;
		DateTime startTime;
		DateTime endTime;
		        
        try{
	        	startTime = System.now();
                mainDTO=getLegacyAccount(mainDTO);
            	endtime  = System.now();
				AtlasTransactionModel txnModel = new AtlasTransactionModel('Dashboard Load Time','My Account','getAccountServiceAgreementsAndServices',mainDTO.accountNo,mainDTO.externalAccountReference,startTime,endTime); 
				addAtlasTransactionModel(mainDTO, txnModel);
				System.debug('++++AR: ----getAccountServiceAgreementsAndServices');
                return mainDTO;
           
            /*servAgrmntInfoObj=AtlasIntegrationUtility.getAccountServiceAgreementsAndServices(mainDTO.accountKey);
            if(servAgrmntInfoObj!=null)
            {
                mainDTO.externalSystemName=servAgrmntInfoObj.systemName;
                mainDTO.externalAccountReference=servAgrmntInfoObj.serviceAgreementReference;
                mainDTO.deviceProtocol=servAgrmntInfoObj.deviceProtocol;
                AtlasUtility.populateSuccess(mainDTO);
                
            }*/
        }catch(Exception e)
        {
            AtlasUtility.populateExceptionString(thisClassName+':getAccountServiceAgreementsAndServices',mainDTO,e);
        }
        return mainDTO;
    }

    /**
    * @author Gaurav Gathania
    * @description - getCurrentUsageByAccount
    * @input param  - AtlasMainDTO mainDTO
    * @return param AtlasMainDTO
    */
    public static AtlasMainDTO getCurrentUsageByAccount(AtlasMainDTO mainDTO)
    {
		DateTime startTime;
		DateTime endTime;
        try{
	        if(!Test.isRunningTest()) {
	        	startTime = system.now();
				System.debug('++++AR:mainDTO1 before adding timestamps'+mainDTO);
	        	mainDTO = getCurrentUsageByAccountV3(mainDTO);
	        	endTime = system.now();
				AtlasTransactionModel txnModel = new AtlasTransactionModel('Dashboard Load Time','Current Data Usage','getCurrentUsageByAccount',mainDTO.accountNo, mainDTO.externalAccountReference,startTime,endTime);
				addAtlasTransactionModel(mainDTO, txnModel);
				return mainDTO;
    	}
        }catch(Exception e) {   
            AtlasUtility.populateExceptionString(thisClassName+':getCurrentUsageByAccount',mainDTO,e);
        }      
        return mainDTO;
    }
     /**
    * @author Gaurav Gathania
    * @description - getCurrentUsageByAccount
    * @input param  - AtlasMainDTO mainDTO
    * @return param AtlasMainDTO
    */
    /*
    public static AtlasMainDTO getCurrentUsageByAccountV3(AtlasMainDTO mainDTO)
    {  AtlasCurrentDataUsageDTO cduDTOObj=new AtlasCurrentDataUsageDTO();
         mainDTO.cduDTOObj=cduDTOObj;
        try{ 
            if(mainDTO.isUnlimited || mainDTO.isOpenNetPlan){
                HttpResponse res1=AtlasIntegrationUtility.getCurrentQuotaByAccount(mainDTO.externalSystemName,mainDTO.externalAccountReference);
                 //Start -Data assignment for the Usage DTO 
                if(cduDTOObj !=null)
                {
                    cduDTOObj.refreshNow =false;
                    Dom.Document docu=res1.getBodyDocument();
                    system.debug('----docu----> '+docu);
                    Dom.XMLNode addressu=docu.getRootElement();
                    Dom.XMLNode usageElementu=addressu.getChildElements()[0].getChildElements()[0].getChildElements()[0];
                    Dom.XMLNode[] corrNode;
                    Dom.XMLNode[] buyMoreNode;
                    Dom.Xmlnode[] graceNode;
                    for(Dom.XMLNode child : usageElementu.getChildElements()) {
                        if('quota'==child.getName()){
                            for(Dom.XMLNode child1 : child.getChildElements()) {
                                system.debug('----child1----> '+child1);
                                if('Monthly' == child1.getText()){
                                    corrNode = child.getChildElements();
                                }
                                if('BuyMore' == child1.getText()) {
                                    buyMoreNode = child.getChildElements();
                                }
                                if('Grace' == child1.getText()){
                                    graceNode = child.getChildElements();
                                }                               
                            }
                        }
                        
                    }
                    if(corrNode.size()>0){  
                        for(Dom.Xmlnode child2 : corrNode){
                            system.debug('---------Child2----------'+child2);
                            if('effectiveDate'==child2.getName()){ 
                                cduDTOObj.usageCycleStartDate=Datetime.valueOfGmt(child2.getText().substring(0,10)+'  00:00:00');
                            }
                            if('expiryDate'==child2.getName()){ 
                                cduDTOObj.usageResetDate=Datetime.valueOfGmt(child2.getText().substring(0,10)+'  00:00:00');
                            }
                            if('amountUsed'==child2.getName()) {   
                                if(cduDTOObj.amountUsed==null)cduDTOObj.amountUsed=0;
                                cduDTOObj.amountUsed+= Long.valueOf(child2.getText());
                            }
                            if('totalAmount'==child2.getName()) {   
                                if(cduDTOObj.threshold==null)cduDTOObj.threshold=0;
                                cduDTOObj.threshold+= Long.valueOf(child2.getText());
                                cduDTOObj.planThreshold= Long.valueOf(child2.getText());
                            } 
                        }
                    }
                    if(buyMoreNode != null && buyMoreNode.size()>0) {
                        for(Dom.Xmlnode child3 : buyMoreNode){
                            if('totalAmount'==child3.getName()) 
                            {   
                                if(cduDTOObj.threshold==null)cduDTOObj.threshold=0;
                                cduDTOObj.threshold+= Long.valueOf(child3.getText());   
                            }
                            if('amountUsed'==child3.getName()) {   
                                if(cduDTOObj.amountUsed==null)cduDTOObj.amountUsed=0;
                                cduDTOObj.amountUsed+= Long.valueOf(child3.getText());
                            }
                        }
                    }
                    if(graceNode != null && graceNode.size()>0 && mainDTO.isUnlimited){
                        for(Dom.Xmlnode child4 : graceNode){
                            if('amountUsed' == child4.getName())
                            {
                                if(cduDTOObj.amountUsed==null)cduDTOObj.amountUsed=0;
                                cduDTOObj.amountUsed+= Long.valueOf(child4.getText());
                            }
                        }
                    }
                        
                    AtlasUtility.populateSuccess(cduDTOObj);
                }
                }else{
                    system.debug('++++++inside Accountv3+++');
                    HttpResponse res=AtlasIntegrationUtility.getCurrentUsageByAccountV3(mainDTO.externalSystemName,mainDTO.externalAccountReference);
                    if(cduDTOObj !=null)
                    {   cduDTOObj.refreshNow =false;
                        Dom.Document doc=res.getBodyDocument();
                        Dom.XMLNode address=doc.getRootElement();
                        Dom.XMLNode usageElement=address.getChildElements()[0].getChildElements()[0].getChildElements()[0];
                        for(Dom.XMLNode child : usageElement.getChildElements()) { 
                                if('usageDetail'==child.getName()) 
                                     for(Dom.XMLNode child1 : child.getChildElements()) { 
                                        if('usageCycleStartDate'==child1.getName()){ 
                                            cduDTOObj.usageCycleStartDate=Datetime.valueOfGmt(child1.getText().substring(0,10)+'  00:00:00');
                                            }
                                        if('usageResetDate'==child1.getName()){ 
                                            cduDTOObj.usageResetDate=Datetime.valueOfGmt(child1.getText().substring(0,10)+'  00:00:00');
                                            }
                                        if('usageStatistics'==child1.getName()) 
                                            for(Dom.XMLNode child2 : child1.getChildElements()) { 
                                                 system.debug('++++++child2+++' + child2);
                                                if('totalUsage'==child2.getName()) 
                                                {   for(Dom.XMLNode child3 : child2.getChildElements()) { 
                                                        if('timePeriod'==child3.getName()) 
                                                            {   
                                                                cduDTOObj.timePeriod=Integer.valueOf(child3.getText());
                                                                cduDTOObj.timePeriodVal=double.valueOf(child3.getText());}
                                                        if('dataPlanThreshold'==child3.getName()) 
                                                        {   if(cduDTOObj.threshold==null)cduDTOObj.threshold=0;
                                                            cduDTOObj.threshold+= Long.valueOf(child3.getText());
                                                            cduDTOObj.planThreshold= Long.valueOf(child3.getText());
                                                        }   
                                                        
                                                        //--- 06/30/2014 - Hanu
                                                        //--- Based on meeting with Lisa, we no long show total used
                                                        //--- Only show full speed usage - which is what the plan + additional quota usage
                                                        //--- commenting below code and adding the section to only get fullspeed usage
                                                        //if('amountUsed'==child3.getName()) 
                                                        //{   if(cduDTOObj.amountUsed==null)cduDTOObj.amountUsed=0;
                                                        //    cduDTOObj.amountUsed+= Long.valueOf(child3.getText());
                                                        //}   
                                                        if('fullSpeedUsage'==child3.getName()) 
                                                        {   if(cduDTOObj.amountUsed==null)cduDTOObj.amountUsed=0;
                                                            cduDTOObj.amountUsed+= Long.valueOf(child3.getText());
                                                        }   
                                                        
                                                    }
                                                }
                                                if('additionalQuota'==child2.getName()) 
                                                {   for(Dom.XMLNode child3 : child2.getChildElements()) { 
                                                        if('totalAmount'==child3.getName()) 
                                                        {   if(cduDTOObj.threshold==null)cduDTOObj.threshold=0;
                                                            cduDTOObj.threshold+= Long.valueOf(child3.getText());
                                                        }
                                                        if('amountUsed'==child3.getName()) 
                                                        {   if(cduDTOObj.amountUsed==null)cduDTOObj.amountUsed=0;
                                                            //--- 06/30/2014 - Hanu/Kelly
                                                            //--- commented out to not double dip
                                                            //--- amountUsed already includes the additional quota usage
                                                            //cduDTOObj.amountUsed+= Long.valueOf(child3.getText());
                                                        }       
                                                    }
                                                }
                                                
                                            }
                                     }
                                  
                                }
                            AtlasUtility.populateSuccess(cduDTOObj);
                        }
                    }
                
        }catch(Exception e)
        {   cduDTOObj.refreshNow =false;
            AtlasUtility.populateExceptionString(thisClassName+':getCurrentUsageByAccount',cduDTOObj,e);
        }
       
        return mainDTO;
    }
    */
    
    public static AtlasMainDTO getCurrentUsageByAccountV3(AtlasMainDTO mainDTO)
    {
        AtlasCurrentDataUsageDTO cduDTOObj=new AtlasCurrentDataUsageDTO();
        mainDTO.cduDTOObj=cduDTOObj;
        try
        { 
            //if(mainDTO.isUnlimited || mainDTO.isOpenNetPlan)
            //{
                HttpResponse res = AtlasIntegrationUtility.getCurrentQuotaByAccount(mainDTO.externalSystemName, mainDTO.externalAccountReference, mainDTO.internalAccountReference);
                string resp = res.getBody();

                // Start -Data assignment for the Usage DTO 
                mainDTO = processGetCurrentQuotaByAccountResponse(resp, mainDTO);
            /*}
            else
            {
                HttpResponse res = AtlasIntegrationUtility.getCurrentUsageByAccountV3(mainDTO.externalSystemName,mainDTO.externalAccountReference);
                string resp = res.getBody();
                system.debug('---resp ---> '+resp);
                // Start -Data assignment for the Usage DTO
                mainDTO = processGetCurrentUsageByAccountResponse(resp, mainDTO);
            }*/
        }
        catch(Exception e)
        {
            cduDTOObj.refreshNow =false;
            AtlasUtility.populateExceptionString(thisClassName+':getCurrentUsageByAccount',cduDTOObj,e);
        }
        return mainDTO;
    }

    // IF appropriate Plan THEN build the REQUEST to get details, ELSE return NULL to indicate that no data is needed
    public static String getCurrentQuotaByAccountRequest(AtlasMainDTO mainDTOObj)
    {
        if (String.isEmpty(mainDTOObj.externalSystemName) || String.isEmpty(mainDTOObj.externalAccountReference))
            return null;
        
        //if (!(mainDTOObj.isUnlimited || mainDTOObj.isOpenNetPlan))
          //  return null;
            
        return AtlasIntegrationUtility.getCurrentQuotaByAccountEnvelope(mainDTOObj.externalSystemName, mainDTOObj.externalAccountReference);
    }

    // IF appropriate Plan THEN build the REQUEST to get details, ELSE return NULL to indicate that no data is needed
    public static String getCurrentUsageByAccountRequest(AtlasMainDTO mainDTOObj)
    {
        if (String.isEmpty(mainDTOObj.externalSystemName) || String.isEmpty(mainDTOObj.externalAccountReference))
            return null;
        
        if (mainDTOObj.isUnlimited || mainDTOObj.isOpenNetPlan)
            return null;
                    
        return AtlasIntegrationUtility.getCurrentUsageByAccountEnvelope(mainDTOObj.externalSystemName, mainDTOObj.externalAccountReference);
    }
        
    // Data assignment for the Usage DTO - process the HTTP Response from getCurrentQuotaByAccount Continuation Process
    public static AtlasMainDTO processGetCurrentQuotaByAccountResponse(string res1, AtlasMainDTO mainDTO)
    {
        if (mainDTO.cduDTOObj == null)
            mainDTO.cduDTOObj = new AtlasCurrentDataUsageDTO();     
        AtlasCurrentDataUsageDTO cduDTOObj = mainDTO.cduDTOObj; 

        cduDTOObj.refreshNow =false;
        Dom.Document docu = new DOM.Document();
        docu.load(res1); //res1.getBodyDocument();

        system.debug('*** docu----> '+docu);
        Dom.XMLNode addressu=docu.getRootElement();
        Dom.XMLNode usageElementu=addressu.getChildElements()[0].getChildElements()[0].getChildElements()[0];
        Dom.XMLNode[] corrNode;
        Dom.XMLNode[] buyMoreNode;
        Dom.Xmlnode[] graceNode;
        for(Dom.XMLNode child : usageElementu.getChildElements()) 
        {
            if('quota'==child.getName())
            {
                for(Dom.XMLNode child1 : child.getChildElements()) 
                {
                    if('Monthly' == child1.getText())
                        corrNode = child.getChildElements();
                    if('BuyMore' == child1.getText()) 
                        buyMoreNode = child.getChildElements();
                    if('Grace' == child1.getText())
                        graceNode = child.getChildElements();
                }
            }
        }                        
        if(corrNode.size()>0)
        {
            for(Dom.Xmlnode child2 : corrNode)
            {
                if('effectiveDate'==child2.getName())
                    cduDTOObj.usageCycleStartDate=Datetime.valueOfGmt(child2.getText().substring(0,10)+'  00:00:00');
                if('expiryDate'==child2.getName())
                    cduDTOObj.usageResetDate=Datetime.valueOfGmt(child2.getText().substring(0,10)+'  00:00:00');
                if('amountUsed'==child2.getName()) 
                {   
                    if(cduDTOObj.amountUsed==null)cduDTOObj.amountUsed=0;
                    cduDTOObj.amountUsed+= Long.valueOf(child2.getText());
                }
                if('totalAmount'==child2.getName()) 
                {   
                    if(cduDTOObj.threshold==null)cduDTOObj.threshold=0;
                    cduDTOObj.threshold+= Long.valueOf(child2.getText());
                    cduDTOObj.planThreshold= Long.valueOf(child2.getText());
                }
            }
        }
        if(buyMoreNode != null && buyMoreNode.size()>0) 
        {
            for(Dom.Xmlnode child3 : buyMoreNode)
            {
                if('totalAmount'==child3.getName()) 
                {   
                    if(cduDTOObj.threshold==null)cduDTOObj.threshold=0;
                    cduDTOObj.threshold+= Long.valueOf(child3.getText());   
                }
                if('amountUsed'==child3.getName()) 
                {   
                    if(cduDTOObj.amountUsed==null)cduDTOObj.amountUsed=0;
                    cduDTOObj.amountUsed+= Long.valueOf(child3.getText());
                }
            }
        }
        if(graceNode != null && graceNode.size()>0 && mainDTO.isUnlimited)
        {
            for(Dom.Xmlnode child4 : graceNode)
            {
                if('amountUsed' == child4.getName())
                {
                    if(cduDTOObj.amountUsed==null)cduDTOObj.amountUsed=0;
                    cduDTOObj.amountUsed+= Long.valueOf(child4.getText());
                }
            }
        }
                        
        AtlasUtility.populateSuccess(cduDTOObj);
        return mainDTO;
    }

    // Data assignment for the Usage DTO - process the HTTP Response from getCurrentUsageByAccount Continuation Process
    public static AtlasMainDTO processGetCurrentUsageByAccountResponse(string res, AtlasMainDTO mainDTO)
    {
        AtlasCurrentDataUsageDTO cduDTOObj = mainDTO.cduDTOObj; 

        cduDTOObj.refreshNow =false;
        Dom.Document doc = new Dom.Document();
        doc.load(res);//res.getBodyDocument();
        Dom.XMLNode address=doc.getRootElement();
        Dom.XMLNode usageElement=address.getChildElements()[0].getChildElements()[0].getChildElements()[0];
        for(Dom.XMLNode child : usageElement.getChildElements()) 
        { 
            if ('usageDetail'==child.getName()) 
                for(Dom.XMLNode child1 : child.getChildElements()) 
                { 
                    if ('usageCycleStartDate'==child1.getName())
                        cduDTOObj.usageCycleStartDate=Datetime.valueOfGmt(child1.getText().substring(0,10)+'  00:00:00');
                                            
                    if ('usageResetDate'==child1.getName()) 
                        cduDTOObj.usageResetDate=Datetime.valueOfGmt(child1.getText().substring(0,10)+'  00:00:00');
                                            
                    if ('usageStatistics'==child1.getName()) 
                        for(Dom.XMLNode child2 : child1.getChildElements()) 
                        { 
                            if('totalUsage'==child2.getName()) 
                            {
                                for(Dom.XMLNode child3 : child2.getChildElements()) 
                                { 
                                    if('timePeriod'==child3.getName()) 
                                    {
                                        cduDTOObj.timePeriod=Integer.valueOf(child3.getText());
                                        cduDTOObj.timePeriodVal=double.valueOf(child3.getText());
                                    }
                                    if('dataPlanThreshold'==child3.getName())
                                    {   if(cduDTOObj.threshold==null)cduDTOObj.threshold=0;
                                        cduDTOObj.threshold+= Long.valueOf(child3.getText());
                                        cduDTOObj.planThreshold= Long.valueOf(child3.getText());
                                    }
                                                        
                                                        //--- 06/30/2014 - Hanu
                                                        //--- Based on meeting with Lisa, we no long show total used
                                                        //--- Only show full speed usage - which is what the plan + additional quota usage
                                                        //--- commenting below code and adding the section to only get fullspeed usage
                                                        //if('amountUsed'==child3.getName()) 
                                                        //{   if(cduDTOObj.amountUsed==null)cduDTOObj.amountUsed=0;
                                                        //    cduDTOObj.amountUsed+= Long.valueOf(child3.getText());
                                                        //}   
                                    if('fullSpeedUsage'==child3.getName()) 
                                    {   
                                        if(cduDTOObj.amountUsed==null)cduDTOObj.amountUsed=0;
                                        cduDTOObj.amountUsed+= Long.valueOf(child3.getText());
                                    }                                                           
                                }
                            }
                            if('additionalQuota'==child2.getName()) 
                            {
                                for(Dom.XMLNode child3 : child2.getChildElements()) 
                                { 
                                    if('totalAmount'==child3.getName()) 
                                    {   
                                        if(cduDTOObj.threshold==null)cduDTOObj.threshold=0;                                                           
                                        cduDTOObj.threshold+= Long.valueOf(child3.getText());
                                    }
                                    if('amountUsed'==child3.getName()) 
                                    {   
                                        if(cduDTOObj.amountUsed==null)cduDTOObj.amountUsed=0;
                                        //--- 06/30/2014 - Hanu/Kelly
                                        //--- commented out to not double dip amountUsed already includes the additional quota usage
                                        //cduDTOObj.amountUsed+= Long.valueOf(child3.getText());
                                    }       
                                }
                            }                                              
                        }
                }                              
        }
        AtlasUtility.populateSuccess(cduDTOObj);
        return mainDTO;
    }
    
    /**
    * @author Gaurav Gathania
    * @description - getMyAccount
    * @input param  - AtlasMainDTO mainDTO
    * @return param AtlasMainDTO
    */
    public static AtlasMainDTO getMyAccount(AtlasMainDTO mainDTO)
    {  
        AtlasAccInfoXmlschemaPublic.billingSummary billingSummObj;
        DateTime startTime;
		DateTime endTime;

        if(mainDTO.isUnlimited  == null)
            mainDTO.isUnlimited = false;
        if(mainDTO.isOpenNetPlan == null)
            mainDTO.isOpenNetPlan = false;
        try{
        	startTime = System.now();
            billingSummObj=AtlasIntegrationUtility.getBillingSummary(mainDTO.accountKey, mainDTO.internalAccountReference);
            //  Start -Data assignment for the Billing Summary DTO
            mainDTO = processGetBillingSummaryResponse(billingSummObj, mainDTO);
            endtime  = System.now();

			AtlasTransactionModel txnModel = new AtlasTransactionModel('Dashboard Load Time','My Account','getMyAccount',mainDTO.accountNo,mainDTO.externalAccountReference,startTime,endTime);
			addAtlasTransactionModel(mainDTO, txnModel); 	        
	        System.debug('++++AR: ----getmyaccount');
        }
        catch(Exception e)
        {
            if(AtlasUtility.isEmpty(mainDTO.accountDTOObj))
            mainDTO.accountDTOObj=new AtlasAccountDTO();      
            AtlasUtility.populateExceptionString(thisClassName+':getMyAccount', mainDTO.accountDTOObj,e);
        }
        return mainDTO;
    }

    public static AtlasMainDTO processGetBillingSummaryResponse(AtlasAccInfoXmlschemaPublic.billingSummary billingSummObj, AtlasMainDTO mainDTO)
    {
        if(AtlasUtility.isEmpty(mainDTO.accountDTOObj))
        {    
            mainDTO.accountDTOObj=new AtlasAccountDTO();
            mainDTO.accountDTOObj.contactEmail=mainDTO.customerEmail;
            mainDTO.accountDTOObj.username=mainDTO.federationId;
            mainDTO.accountDTOObj.fullPhotoURL=mainDTO.fullPhotoURL;
            mainDTO.accountDTOObj.smallPhotoURL=mainDTO.smallPhotoURL;
            mainDTO.accountDTOObj.strAccountNumber=mainDTO.accountNo;
            mainDTO.accountDTOObj.strAccountType=mainDTO.CommunityUserAccountType;
            mainDTO.accountDTOObj.populateServiceAddress(mainDTO);
            mainDTO.accountDTOObj.isBillingDetailsPopulated=false;
            mainDTO.isAccountPopulated = true;
        }
        else
            mainDTO.isAccountPopulated = true;

        if (!AtlasUtility.isEmpty(billingSummObj))
        {
            AtlasAccountDTO myAccountObj = mainDTO.accountDTOObj;
            
            if (!AtlasUtility.isEmpty(billingSummObj.daytimePhone ))
                myAccountObj.phoneMobile=billingSummObj.daytimePhone;
            else 
            if (!AtlasUtility.isEmpty(billingSummObj.mobilePhone))
                myAccountObj.phoneMobile=billingSummObj.mobilePhone;
                
            if (!AtlasUtility.isEmpty(billingSummObj.address ))
            {  
                myAccountObj.isBillingDetailsPopulated=true;
                myAccountObj.address1=billingSummObj.address.address1;
                myAccountObj.address2=billingSummObj.address.address2;
                myAccountObj.city=billingSummObj.address.city;
                myAccountObj.county=billingSummObj.address.county;
                myAccountObj.state=billingSummObj.address.state;
                myAccountObj.zip=billingSummObj.address.zip;
                myAccountObj.zip4=billingSummObj.address.zipFour;
            }
            myAccountObj.customerType=billingSummObj.customerType;
            system.debug('*** billingSummObj ->'+ billingSummObj);
            if (!AtlasUtility.isEmpty(billingSummObj.serviceLevel))
            { 
                myAccountObj.serviceLevel=billingSummObj.serviceLevel; 
                List<AtlasPlan__c> atlasPlan = new List<AtlasPlan__c>();
                Set<String> planNameSet = new Set<String>();
                Set<String> openNetSet = new Set<String>();
                Set<String> libertySet = new Set<String>();
                Set<String> displayPlanDataSet = new Set<String>();
                atlasPlan = [select id, Is_Plan_Unlimited__c, PlanAPIName__c,Is_Plan_Opennet__c,IsLibertyPlan__c,displayPlanData__c  from AtlasPlan__c where Is_Plan_Unlimited__c =: true OR Is_Plan_Opennet__c =: true OR IsLibertyPlan__c=: true OR displayPlanData__c=: true];
                if (atlasPlan != null && atlasPlan.size()>0)
                {
                    for(AtlasPlan__c ap : atlasPlan)
                    {
                        if  (ap.Is_Plan_Unlimited__c)
                            planNameSet.add(ap.PlanAPIName__c.toLowerCase());
                        if(ap.Is_Plan_Opennet__c)
                            openNetSet.add(ap.PlanAPIName__c.toLowerCase());
                        if(ap.IsLibertyPlan__c)
                            libertySet.add(ap.PlanAPIName__c.toLowerCase());
                        if(ap.displayPlanData__c)
                            displayPlanDataSet.add(ap.PlanAPIName__c.toLowerCase());
                    }
                }
                if(planNameSet.contains(myAccountObj.serviceLevel.toLowerCase()))
                    mainDTO.isUnlimited = true;
                if(openNetSet.contains(myAccountObj.serviceLevel.toLowerCase()))
                    mainDTO.isOpenNetPlan = true;
                if(libertySet.contains(myAccountObj.serviceLevel.toLowerCase()))
                    mainDTO.isLibertyPlan = true;
                if(displayPlanDataSet.contains(myAccountObj.serviceLevel.toLowerCase()))
                    mainDTO.displayPlanData = true;
            }   
        }
        AtlasUtility.populateSuccess(mainDTO.accountDTOObj);
        return mainDTO;
    }
    
    /**
    * @author Tejesh Kumar
    * @description - getAccountServicesAtlas
    * @input param  - AtlasMainDTO mainDTO
    * @return param AtlasMainDTO
    */
    public static AtlasMainDTO getAccountServicesAtlas(AtlasMainDTO mainDTO)
    {
        AtlasAccInfoXmlschemaPublic.accountServiceBean[] accServiceBean = null;
        try{
            if(mainDTO.accountDTOObj.isVoipAccount== null)
                mainDTO.accountDTOObj.isVoipAccount= false;
            if(!mainDTO.accountDTOObj.isVoipAccount) {
                system.debug('@@@---VOIP boolean before--->'+mainDTO.accountDTOObj.isVoipAccount);
                if(!AtlasUtility.isEmpty(MainDTO.accountKey)) {
                    accServiceBean = AtlasIntegrationUtility.getAccountServicesAtlas(MainDTO.accountKey);
                    system.debug('@@@---Account Ser Bean atlas--->'+accServiceBean);
                    for(AtlasAccInfoXmlschemaPublic.accountServiceBean serviceBean: accServiceBean) {
                        if(serviceBean.serviceLevel=='VOIP') {
                            system.debug('@@@---Account Ser Bean is VOIP--->'+serviceBean);
                            mainDTO.accountDTOObj.isVoipAccount = true;                      
                        }
                    }
                }
            }
        }
        catch(exception ex) {
            System.debug('@@@---get Message--->'+ex.getMessage());
        }
        return null;
    }
    
    /**
    * @author Srikanth Kudumula
    * @description - getPlanName
    * @input param  - AtlasMainDTO mainDTO
    * @return param AtlasMainDTO
    */
    public static AtlasMainDTO getPlanName(AtlasMainDTO mainDTO)
    {
        AtlasAccInfoXmlschemaPublic.accountServiceBean accServiceBean;
        if(mainDTO.isUnlimited  == null)
            mainDTO.isUnlimited = false;
        if(mainDTO.isOpenNetPlan == null)
            mainDTO.isOpenNetPlan = false;
        if(mainDTO.isBusinessPlan == null)
            mainDTO.isBusinessPlan = false; 
        try{
            accServiceBean = AtlasIntegrationUtility.getAccountServices(MainDTO.accountKey, mainDTO.internalAccountReference);
            system.debug('@@@---Account Ser Bean--->'+accServiceBean);
            if(AtlasUtility.isEmpty(mainDTO.accountDTOObj))
            {   
                mainDTO.accountDTOObj=new AtlasAccountDTO();
                mainDTO.accountDTOObj.contactEmail=mainDTO.customerEmail;
                mainDTO.accountDTOObj.username=mainDTO.federationId;
                mainDTO.accountDTOObj.fullPhotoURL=mainDTO.fullPhotoURL;
                mainDTO.accountDTOObj.smallPhotoURL=mainDTO.smallPhotoURL;
                mainDTO.accountDTOObj.strAccountNumber=mainDTO.accountNo;
                mainDTO.accountDTOObj.strAccountType=mainDTO.CommunityUserAccountType;
                mainDTO.accountDTOObj.populateServiceAddress(mainDTO);
                mainDTO.accountDTOObj.isBillingDetailsPopulated=false;
                //mainDTO.isAccountPopulated = true;
            }
            //else{
                mainDTO.isAccountPopulated = true;
            //}
            AtlasAccountDTO myAccountObj=mainDTO.accountDTOObj;
            system.debug('@@@---Service Level in Plan Name--->'+accServiceBean.serviceLevel);
            if(!AtlasUtility.isEmpty(accServiceBean.serviceLevel)){
                myAccountObj.serviceLevel=accServiceBean.serviceLevel;
                List<AtlasPlan__c> atlasPlan = new List<AtlasPlan__c>();
                    Set<String> planNameSet = new Set<String>();
                    Set<String> openNetSet = new Set<String>();
                    Set<String> businessPlanSet = new Set<String>();
                    atlasPlan = [select id, Is_Plan_Unlimited__c, PlanAPIName__c,Is_Plan_Opennet__c,BusinessPlan__c  from AtlasPlan__c where Is_Plan_Unlimited__c =: true OR Is_Plan_Opennet__c =: true OR BusinessPlan__c =: true];
                    if(atlasPlan != null && atlasPlan.size()>0){
                        for(AtlasPlan__c ap : atlasPlan){
                            if(ap.Is_Plan_Unlimited__c){
                                planNameSet.add(ap.PlanAPIName__c.toLowerCase());
                            }
                            else if(ap.Is_Plan_Opennet__c){
                                openNetSet.add(ap.PlanAPIName__c.toLowerCase());
                            }
                            else if(ap.BusinessPlan__c){
                                businessPlanSet.add(ap.PlanAPIName__c.toLowerCase());
                            }
                        }
                        system.debug('@@@---planNameSet for unlimited--->'+planNameSet);
                        system.debug('@@@---planName--->'+myAccountObj.serviceLevel.toLowerCase());
                        system.debug('@@@---businessPlanSet--->'+businessPlanSet);
                    }
                    if(planNameSet.contains(myAccountObj.serviceLevel.toLowerCase()))
                        mainDTO.isUnlimited = true;
                    if(openNetSet.contains(myAccountObj.serviceLevel.toLowerCase()))
                        mainDTO.isOpenNetPlan = true;
                    if(businessPlanSet.contains(myAccountObj.serviceLevel.toLowerCase()))
                        mainDTO.isBusinessPlan = true;
            }
        }catch(exception ex){
            if(AtlasUtility.isEmpty(mainDTO.accountDTOObj))
            mainDTO.accountDTOObj=new AtlasAccountDTO();
            AtlasUtility.populateExceptionString(thisClassName+':getMyAccount', mainDTO.accountDTOObj,ex);
        }
        return mainDTO;
    }
    
    /**
    * @author Gaurav Gathania
    * @description - getCurrentPaymentMethod
    * @input param  - AtlasMainDTO mainDTO
    * @return param AtlasMainDTO
    */
    public static AtlasMainDTO getCurrentPaymentMethod(AtlasMainDTO mainDTO)
    {
        mainDTO.currentPaymentMethodDTOObj = new AtlasCurrentPaymentMethodDTO();
        AtlasFinServiceXmlschemaFinanceService.PaymentMethodHistoryItem paymentMethodObj;
        try{
            paymentMethodObj=AtlasIntegrationUtility.getSubscriberCurrentPaymentMethod(mainDTO.externalSystemName,mainDTO.externalAccountReference);    
            mainDTO = processGetSubscriberCurrentPaymentMethodResponse(paymentMethodObj, mainDTO);
        }catch(Exception e)
        {
            AtlasUtility.populateExceptionString(thisClassName+':getCurrentPaymentMethod',mainDTO.currentPaymentMethodDTOObj,e);
        }  
        return mainDTO;
    }

    // Data assignment for the currentPaymentMethodDTOObj - process the HTTP Response from getSubscriberCurrentPaymentMethod
    public static AtlasMainDTO processGetSubscriberCurrentPaymentMethodResponse(AtlasFinServiceXmlschemaFinanceService.PaymentMethodHistoryItem paymentMethodObj, AtlasMainDTO mainDTO)
    {
        //mainDTO.currentPaymentMethodDTOObj = new AtlasCurrentPaymentMethodDTO();
        if(paymentMethodObj!=null)
        {
            AtlasCurrentPaymentMethodDTO currentPaymentMethodDTOObj = mainDTO.currentPaymentMethodDTOObj;
            currentPaymentMethodDTOObj.paymentMethodType = paymentMethodObj.paymentMethodType;
            AtlasFinServiceXmlschemaFinanceService.EFTSummary eftAccountDetails = paymentMethodObj.eft;
            AtlasFinServiceXmlschemaFinanceService.CreditCardSummary creditCardDetails = paymentMethodObj.creditCard;
            // system.debug('Tejesh Test____'+Json.serializepretty(creditCardDetails));
            if (eftAccountDetails!=null)
            {
                    AtlasCurrentPaymentMethodDTO.paymentBankAccount tempBankAccount=new AtlasCurrentPaymentMethodDTO.paymentBankAccount(eftAccountDetails.accountHolder,eftAccountDetails.lastFourDigits,eftAccountDetails.bankCode,eftAccountDetails.paymentType);
                    currentPaymentMethodDTOObj.paymentBankDetails=tempBankAccount;
            }
            if (creditCardDetails!=null)
            {
                    AtlasCurrentPaymentMethodDTO.paymentCreditCard tempCreditCard=new AtlasCurrentPaymentMethodDTO.paymentCreditCard(creditCardDetails.lastFourDigits,creditCardDetails.expirationDate,creditCardDetails.zipCode,creditCardDetails.methodOfPayment);
                    currentPaymentMethodDTOObj.paymentCreditCardDetails=tempCreditCard;
            }  
            AtlasUtility.populateSuccess(currentPaymentMethodDTOObj);
    
            mainDTO.currentPaymentMethodDTOObj=currentPaymentMethodDTOObj;   
        } 
        return mainDTO;
    }
    
    /**
    * @author Edwin Raymond
    * @description - getInvoiceDetailsCDRInfo
    * @input param  - AtlasMainDTO mainDTO,String invoiceReference
    * @return param AtlasMainDTO
    */  
    /*public static AtlasMainDTO getInvoiceDetailsCDRInfo(AtlasMainDTO mainDTO,String invoiceReference)
    { system.debug('getInvoiceDetailsCDRInfo___'+invoiceReference);
        AtlasFinServiceXmlschemaFinanceService.EventHistoryItem[] invoiceCDRObj;
        List<AtlasInvoiceCDRDTO> tempCDRDTO=new List<AtlasInvoiceCDRDTO>();        
        try{
            String[] allinvoicerefs=new String[]{};
            allinvoicerefs.add(invoiceReference);
            system.debug('>>>>>>>>mainDTO.externalSystemName'+Json.serialize(mainDTO));
            invoiceCDRObj=AtlasIntegrationUtility.getInvoiceCDRDetails(mainDTO.externalSystemName,mainDTO.externalAccountReference,allinvoicerefs,10);
            system.debug('invoiceCDRObj____'+Json.serialize(invoiceCDRObj));
            if(invoiceCDRObj!=null)
            {
                
                for(AtlasFinServiceXmlschemaFinanceService.EventHistoryItem eventitem :invoiceCDRObj)
                {
                    List<AtlasInvoiceCDRDTO.eventAttributes> tempEventAttributes=new List<AtlasInvoiceCDRDTO.eventAttributes>();
                    if(eventItem.eventAttributes != null)
                    {
                        if(eventItem.eventAttributes.size() > 0)
                        {
                            for(Integer i=0; i < eventItem.eventAttributes.size();i++)
                                tempEventAttributes.add(new AtlasInvoiceCDRDTO.eventAttributes(eventItem.eventAttributes[i].attributeName,eventItem.eventAttributes[i].attributeValue));
                        }
                    } 
                    tempCDRDTO.add(new AtlasInvoiceCDRDTO(eventItem.externalSystemName,eventItem.externalServiceAgreementReference,eventItem.externalInvoiceReference,eventItem.eventDateTime,eventItem.eventType,tempEventAttributes));  
                } 
                
               //AtlasUtility.populateSuccess(invoiceCDRObj);
            }
        }catch(Exception e)
        {system.debug('getInvoiceDetailsCDRInfo___'+e.getMessage());
           //AtlasUtility.populateExceptionString(thisClassName+':getInvoiceDetailsCDRInfo', mainDTO.invoiceCDRDTO ,e);
        }
        mainDTO.invoiceCDRDTO=tempCDRDTO;
        return mainDTO;
    }
    */
    /**
    * @author Edwin Raymond
    * @description - getInvoiceDetailsCDRInfo
    * @input param  - AtlasMainDTO mainDTO,String invoiceReference
    * @return param AtlasMainDTO
    */
     public static AtlasMainDTO getInvoiceDetailsCDRInfo(AtlasMainDTO mainDTO,String invoiceReference)
    { 
        AtlasFinServiceXmlschemaFinanceService.EventHistoryItem[] invoiceCDRObj;
        List<AtlasInvoiceCDRDTO> tempCDRDTO=new List<AtlasInvoiceCDRDTO>();        
        try{ 
            String[] allinvoicerefs=new String[]{};
            allinvoicerefs.add(invoiceReference);
                invoiceCDRObj=AtlasIntegrationUtility.getInvoiceCDRDetails(mainDTO.externalSystemName,mainDTO.externalAccountReference,allinvoicerefs,10);
            if(invoiceCDRObj!=null)
            {
                AtlasInvoiceCDRDTO aTemp = new AtlasInvoiceCDRDTO();
                for(AtlasFinServiceXmlschemaFinanceService.EventHistoryItem eventitem :invoiceCDRObj)
                {
                    if(!AtlasUtility.isEmpty(eventItem.eventAttributes))
                    {
                            aTemp = new AtlasInvoiceCDRDTO();
                            for(Integer i=0; i < eventItem.eventAttributes.size();i++)
                            {    
                                if(eventItem.eventAttributes[i].attributeName==AtlasConstants.AMOUNT)
                                    aTemp.amount = eventItem.eventAttributes[i].attributeValue;
                                if(eventItem.eventAttributes[i].attributeName==AtlasConstants.DURATION)
                                    aTemp.duration = eventItem.eventAttributes[i].attributeValue;
                                if(eventItem.eventAttributes[i].attributeName==AtlasConstants.LOCATION)
                                    aTemp.location = eventItem.eventAttributes[i].attributeValue;
                                if(eventItem.eventAttributes[i].attributeName==AtlasConstants.CALLED_NUMBER)
                                {
                                    if(!AtlasUtility.isEmpty(eventItem.eventAttributes[i].attributeValue))
                                    {String s1 = eventItem.eventAttributes[i].attributeValue.trim();
                                    String s2=s1.substring(1);
                                    aTemp.calledNo = s2.substring(0, 3) + '-' + s2.substring(3, 6) + '-' + s2.substring(6);}
                                }
                                    
                                aTemp.dateTimeVal= eventItem.eventDateTime;             
                            }
                    } 
                   tempCDRDTO.add(aTemp);
                     
                } 
                
            }
        }catch(Exception e)
        {
           //AtlasUtility.populateExceptionString(thisClassName+':getInvoiceDetailsCDRInfo', mainDTO.invoiceCDRDTO ,e);
        }
        mainDTO.invoiceCDRDTO=tempCDRDTO;
        return mainDTO;
    }
    /**
    * @author Gaurav Gathania
    * @description - getBillingHistory
    * @input param  - AtlasMainDTO mainDTO
    * @return param AtlasMainDTO
    */
    public static AtlasMainDTO getBillingHistory(AtlasMainDTO mainDTO)
    {
        AtlasFinServiceXmlschemaFinanceService.SubscriberInvoiceSummaries billingHistoryObj;
        AtlasBillingHistoryDTO billingHistoryDTOObj=new AtlasBillingHistoryDTO();
        mainDTO.billhistoryDTOObj=billingHistoryDTOObj;
        try{
                billingHistoryObj=AtlasIntegrationUtility.getBillingHistory(mainDTO.externalSystemName,mainDTO.externalAccountReference);
            if(billingHistoryObj !=null)
            {
                AtlasFinServiceXmlschemaFinanceService.InvoiceSummary[] invoiceSummaries=billingHistoryObj.invoiceSummaries;
                AtlasBillingHistoryDTO.billingHistoryLineItem[] allbills=new AtlasBillingHistoryDTO.billingHistoryLineItem[]{};
                
                if (invoiceSummaries==null||invoiceSummaries.size()==0)
                {
                    billingHistoryDTOObj.hasBillingHistory=false;
                }
                else
                billingHistoryDTOObj.hasBillingHistory=true;
                for (AtlasFinServiceXmlschemaFinanceService.InvoiceSummary isumm: invoiceSummaries)
                {
                    AtlasBillingHistoryDTO.billingHistoryLineItem tempbill=new AtlasBillingHistoryDTO.billingHistoryLineItem(isumm.statementDate,isumm.dueDate,isumm.amountDue,isumm.externalInvoiceReference);
                    allbills.add(tempbill);
                }
                if (allbills.size() > 0)
                billingHistoryDTOObj.billHistory=allbills;
                AtlasUtility.populateSuccess(billingHistoryDTOObj);
            }     
        }catch(Exception e)
        {   
            AtlasUtility.populateExceptionString(thisClassName+':getBillingHistory',billingHistoryDTOObj,e);
        }  
        mainDTO.billhistoryDTOObj=billingHistoryDTOObj; 
        return mainDTO;
    }

    /**
    * @author Gaurav Gathania
    * @description - getCurrentPaymentMethod
    * @input param  - AtlasMainDTO mainDTO
    * @return param AtlasMainDTO
    */
    public static AtlasMainDTO getBillingsnapShot(AtlasMainDTO mainDTO)
    {
        AtlasFinServiceXmlschemaFinanceService.SubscriberLedgerSummary billingSnapShotObj;
        DateTime startTime;
		DateTime endTime;
		System.debug('++++AR: ****mainDTO' + mainDTO);
        if(mainDTO.billSnapShotDTOObj==null)
        	mainDTO.billSnapShotDTOObj=new AtlasBillingSnapShotDTO();
        try{
        	startTime = System.now();
            billingSnapShotObj=AtlasIntegrationUtility.getBillingsnapShot(mainDTO.externalSystemName,mainDTO.externalAccountReference, mainDTO.internalAccountReference);
            mainDTO = processGetSubscriberLedgerSummaryResponse(billingSnapShotObj, mainDTO);
            endtime  = System.now();

			AtlasTransactionModel txnModel = new AtlasTransactionModel('Dashboard Load Time','Billing Snapshot','getBillingsnapShot',mainDTO.accountNo,mainDTO.externalAccountReference,startTime,endTime); 
			addAtlasTransactionModel(mainDTO, txnModel);
			System.debug('++++AR: ****mainDTO' + mainDTO);
			System.debug('++++AR: ----getBillingSnapShot');
        }catch(Exception e)
        {   
            AtlasUtility.populateExceptionString(thisClassName+':getBillingsnapShot', mainDTO.billSnapShotDTOObj,e);
        }
        return mainDTO;
    }
    public static AtlasMainDTO processGetSubscriberLedgerSummaryResponse(AtlasFinServiceXmlschemaFinanceService.SubscriberLedgerSummary billingSnapShotObj, AtlasMainDTO mainDTO)
    {
        if (billingSnapShotObj!=null && billingSnapShotObj.ledgerSummary != null)
        {
            mainDTO.billSnapShotDTOObj.Amount=billingSnapShotObj.ledgerSummary.currentAmountBalance;
            mainDTO.billSnapShotDTOObj.nextBillDate=billingSnapShotObj.ledgerSummary.nextBillDate;
            AtlasUtility.populateSuccess(mainDTO.billSnapShotDTOObj);
        }
        return mainDTO; 
    }
    
    /**
    * @author Edwin Raymond
    * @description - getSubscriberInvoiceDetails
    * @input param  - AtlasMainDTO mainDTO,String invoiceReferenceNumber
    * @return param AtlasCurrentBillDTO
    */
    public static AtlasCurrentBillDTO getSubscriberInvoiceDetails(AtlasMainDTO mainDTO,String invoiceReferenceNumber)
    {  
        AtlasCurrentBillDTO currBillDTOObj=new AtlasCurrentBillDTO();
        try{
            AtlasFinServiceXmlschemaFinanceService.SubscriberInvoiceDetails subInvoiceObj=AtlasIntegrationUtility.getSubscriberInvoiceDetails(mainDTO.externalSystemName,mainDTO.externalAccountReference,invoiceReferenceNumber);               
            if(subInvoiceObj !=null)
            {  system.debug('subInvoiceObj.ledgerSummary___'+json.serializepretty(subInvoiceObj.ledgerSummary));
                // Retrieve the ledger summary details
                if(subInvoiceObj.ledgerSummary!=null)
                currBillDTOObj.ledgerSummaryDetails=new AtlasCurrentBillDTO.ledgerSummary(subInvoiceObj.ledgerSummary.billingCycleDay,subInvoiceObj.ledgerSummary.nextBillDate,subInvoiceObj.ledgerSummary.currentAmountBalance,subInvoiceObj.ledgerSummary.totalAmountUnbilledOneTimeCharges,subInvoiceObj.ledgerSummary.totalAmountUnbilledAdjustments,subInvoiceObj.ledgerSummary.totalAmountPendingDisputes,subInvoiceObj.ledgerSummary.totalAmountPastDue,subInvoiceObj.ledgerSummary.totalDaysPastDue);      
                
                // Retreive the invoice summary details
                if(subInvoiceObj.invoiceSummary!=null)
                currBillDTOObj.invoiceSummaryDetails=new AtlasCurrentBillDTO.InvoiceSummary(subInvoiceObj.invoiceSummary.externalInvoiceReference,subInvoiceObj.invoiceSummary.statementDate,subInvoiceObj.invoiceSummary.dueDate,subInvoiceObj.invoiceSummary.amountDue,subInvoiceObj.invoiceSummary.previousBalance,subInvoiceObj.invoiceSummary.totalAmountCurrentChargesAndFees,subInvoiceObj.invoiceSummary.totalAmountAdjustments,subInvoiceObj.invoiceSummary.totalAmountLateFees,subInvoiceObj.invoiceSummary.totalAmountTaxes,subInvoiceObj.invoiceSummary.totalAmountPayments,subInvoiceObj.invoiceSummary.totalAmountFailedPayments,subInvoiceObj.invoiceSummary.totalAmountRefunds,subInvoiceObj.invoiceSummary.totalAmountOneTimeCharges);        
                
                // Retireve the Account One Time charges
                currBillDTOObj.oneTimeCharges=new List<AtlasCurrentBillDTO.accountOneTimeCharge>();
                if(subInvoiceObj.invoiceDetails[0].account.accountOneTimeCharges != null)
                {
                    if(subInvoiceObj.invoiceDetails[0].account.accountOneTimeCharges.size() > 0){
                        for (integer i=0; i<subInvoiceObj.invoiceDetails[0].account.accountOneTimeCharges.size(); i++)
                        currBillDTOObj.oneTimeCharges.add(new AtlasCurrentBillDTO.accountOneTimeCharge(subInvoiceObj.invoiceDetails[0].account.accountOneTimeCharges[i].pricePlanName,subInvoiceObj.invoiceDetails[0].account.accountOneTimeCharges[i].date_x,subInvoiceObj.invoiceDetails[0].account.accountOneTimeCharges[i].amount)); 
                        }
                }
                if(subInvoiceObj.invoiceDetails[0].serviceAgreements != null){
                    if(subInvoiceObj.invoiceDetails[0].serviceAgreements.size() > 0){
                    for(integer j = 0; j < subInvoiceObj.invoiceDetails[0].serviceAgreements.size(); j++){
                        if(subInvoiceObj.invoiceDetails[0].serviceAgreements[j].serviceAgreementOneTimeCharges != null)
                        {
                            if(subInvoiceObj.invoiceDetails[0].serviceAgreements[j].serviceAgreementOneTimeCharges.size() > 0){
                                for (integer i=0; i<subInvoiceObj.invoiceDetails[0].serviceAgreements[j].serviceAgreementOneTimeCharges.size(); i++)
                                currBillDTOObj.oneTimeCharges.add(new AtlasCurrentBillDTO.accountOneTimeCharge(subInvoiceObj.invoiceDetails[0].serviceAgreements[j].serviceAgreementOneTimeCharges[i].pricePlanName,subInvoiceObj.invoiceDetails[0].serviceAgreements[j].serviceAgreementOneTimeCharges[i].date_x,subInvoiceObj.invoiceDetails[0].serviceAgreements[j].serviceAgreementOneTimeCharges[i].amount)); 
                                }
                        }
                }}}        
               
                
                // Retrieve the billing Address information
                currBillDTOObj.billingAddress=subInvoiceObj.billingContact.address.addressLine +', '+ subInvoiceObj.billingContact.address.municipality +', '+ subInvoiceObj.billingContact.address.region +', '+ subInvoiceObj.billingContact.address.postalCode;        
                
                // Retrieve the Service Address information
                if(subInvoiceObj.invoiceDetails.size()==1)
                if(subInvoiceObj.invoiceDetails[0].serviceAgreements.size() > 0)
                    currBillDTOObj.serviceAddress=subInvoiceObj.invoiceDetails[0].serviceAgreements[0].serviceAddress.addressLine +', '+ subInvoiceObj.invoiceDetails[0].serviceAgreements[0].serviceAddress.municipality +', '+ subInvoiceObj.invoiceDetails[0].serviceAgreements[0].serviceAddress.region +', '+ subInvoiceObj.invoiceDetails[0].serviceAgreements[0].serviceAddress.postalCode;        
                
                // Extract all plan charges and eqipment charges
                currBillDTOObj.billdetails=new List<AtlasCurrentBillDTO.BillingDetail>();
                if(subInvoiceObj.invoiceDetails.size()==1) {
                    if(subInvoiceObj.invoiceDetails[0].serviceAgreements.size() > 0) {
                        for(integer j=0; j<subInvoiceObj.invoiceDetails[0].serviceAgreements.size(); j++) {
                            if(subInvoiceObj.invoiceDetails[0].serviceAgreements[j].productCharges!=null) {
                                for(integer i=0; i< subInvoiceObj.invoiceDetails[0].serviceAgreements[j].productCharges.size() ; i ++)
                                    currBillDTOObj.billdetails.add(new AtlasCurrentBillDTO.BillingDetail(subInvoiceObj.invoiceDetails[0].serviceAgreements[j].productCharges[i].pricePlanName,subInvoiceObj.invoiceDetails[0].serviceAgreements[j].productCharges[i].billedFromDate.dategmt(),subInvoiceObj.invoiceDetails[0].serviceAgreements[j].productCharges[i].billedToDate.dategmt(),subInvoiceObj.invoiceDetails[0].serviceAgreements[j].productCharges[i].amount));
                            }
                        }
                    }
                }
                // Extract all tax charges 
                currBillDTOObj.taxdetails=new List<AtlasCurrentBillDTO.BillingDetail>(); 
                if(subInvoiceObj.invoiceDetails.size()==1)
                if(subInvoiceObj.invoiceDetails[0].account.taxTypes!=null)
                {
                    currBillDTOObj.allTaxdetails=new List<AtlasCurrentBillDTO.taxDetails>();
                    for(integer i=0;i<subInvoiceObj.invoiceDetails[0].account.taxTypes.size();i++)
                    {
                        List<AtlasCurrentBillDTO.BillingDetail> taxDetailsList=new List<AtlasCurrentBillDTO.BillingDetail>(); 
                        for(integer j=0;j<subInvoiceObj.invoiceDetails[0].account.taxTypes[i].taxAuthority.size();j ++)
                        {
                            for(integer k=0; k < subInvoiceObj.invoiceDetails[0].account.taxTypes[i].taxAuthority[j].taxes.size(); k++)
                                if(AtlasUtility.getMapValue(AtlasConstants.TAX_TYPES_NO_TAX_AUTHORITY).contains(subInvoiceObj.invoiceDetails[0].account.taxTypes[i].taxAuthority[j].taxes[k].description))
                                    taxDetailsList.add(new AtlasCurrentBillDTO.BillingDetail(''+subInvoiceObj.invoiceDetails[0].account.taxTypes[i].taxAuthority[j].taxes[k].description ,null,null,subInvoiceObj.invoiceDetails[0].account.taxTypes[i].taxAuthority[j].taxes[k].amount));
                                else    
                                    taxDetailsList.add(new AtlasCurrentBillDTO.BillingDetail(''+subInvoiceObj.invoiceDetails[0].account.taxTypes[i].taxAuthority[j].taxAuthorityName +' '+subInvoiceObj.invoiceDetails[0].account.taxTypes[i].taxAuthority[j].taxes[k].description ,null,null,subInvoiceObj.invoiceDetails[0].account.taxTypes[i].taxAuthority[j].taxes[k].amount));
                        }
                        currBillDTOObj.allTaxdetails.add(new AtlasCurrentBillDTO.taxDetails(subInvoiceObj.invoiceDetails[0].account.taxTypes[i].taxTypeName+' Service Taxes, Surcharges and Fees',taxDetailsList));  
                    } 
                }   
                
                // Extract all Event Summary Data 
                currBillDTOObj.allEventData=new List<AtlasCurrentBillDTO.EventSummaryData>(); 
                if(subInvoiceObj.invoiceDetails.size()==1)
                if(subInvoiceObj.invoiceDetails[0].serviceAgreements != null)
                    for(integer j=0; j< subInvoiceObj.invoiceDetails[0].serviceAgreements.size(); j++)
                    {
                        if(subInvoiceObj.invoiceDetails[0].serviceAgreements[j].eventSummaryCharges !=null)
                            for(integer i=0; i< subInvoiceObj.invoiceDetails[0].serviceAgreements[j].eventSummaryCharges.size() ; i ++)
                                currBillDTOObj.allEventData.add(new AtlasCurrentBillDTO.EventSummaryData(''+subInvoiceObj.invoiceDetails[0].serviceAgreements[j].eventSummaryCharges[i].evenType,subInvoiceObj.invoiceDetails[0].serviceAgreements[j].eventSummaryCharges[i].eventLabel,subInvoiceObj.invoiceDetails[0].serviceAgreements[j].eventSummaryCharges[i].totalAmountEvents));
                    }
                    
                // Extract all adjustments to bill
                currBillDTOObj.adjustmentdetails=new List<AtlasCurrentBillDTO.BillingDetail>();
                if(subInvoiceObj.invoiceDetails.size()==1)
                if (subInvoiceObj.invoiceDetails[0].account.adjustments !=null)
                for(integer i=0;i<subInvoiceObj.invoiceDetails[0].account.adjustments.size();i ++)
                currBillDTOObj.adjustmentdetails.add(new AtlasCurrentBillDTO.BillingDetail(AtlasConstants.ADJUSTMENTS,subInvoiceObj.invoiceDetails[0].account.adjustments[i].date_x.dategmt(),subInvoiceObj.invoiceDetails[0].account.adjustments[i].date_x.dategmt(),subInvoiceObj.invoiceDetails[0].account.adjustments[i].amount));  
            }
             AtlasUtility.populateSuccess(currBillDTOObj);
        }
        catch(Exception e)
        {   system.debug('Exception_____'+e.getMessage()+'>>>>'+e.getStackTraceString());
            AtlasUtility.populateExceptionString(thisClassName+':getSubscriberInvoiceDetails',currBillDTOObj,e);
        }     
        return currBillDTOObj;
    }
    
    /**
    * @author Gaurav Gathania
    * @description - getSubscriberPaymentHistory
    * @input param  - AtlasMainDTO mainDTO
    * @return param AtlasCurrentBillDTO
    */
    public static AtlasMainDTO getSubscriberPaymentHistory(AtlasMainDTO mainDTO)
    {
    	System.debug('++++AR: +++++mainDTO' + mainDTO);
        AtlasFinServiceXmlschemaFinanceService.PaymentHistoryItem paymentHistoryObj;
        DateTime startTime;
		DateTime endTime;

        try{
            if(mainDTO.billSnapShotDTOObj==null)
            mainDTO.billSnapShotDTOObj=new AtlasBillingSnapShotDTO();
        	startTime = System.now();            
            paymentHistoryObj=AtlasIntegrationUtility.getSubscriberPaymentHistory(mainDTO.externalSystemName,mainDTO.externalAccountReference,1,mainDTO.internalAccountReference);
            if(paymentHistoryObj!=null)
            {
                mainDTO = processGetSubscriberPaymentHistoryResponse(paymentHistoryObj, mainDTO);
            }
            endtime  = System.now();

			AtlasTransactionModel txnModel = new AtlasTransactionModel('Dashboard Load Time','Billing Snapshot','getSubscriberPaymentHistory',mainDTO.accountNo,mainDTO.externalAccountReference,startTime,endTime);
			addAtlasTransactionModel(mainDTO, txnModel); 
   			System.debug('++++AR: ----getsubscriberpaymenthistory');
			System.debug('++++AR: +++++mainDTO' + mainDTO);
   			
        }catch(Exception e)
        {
            if(!mainDTO.billSnapShotDTOObj.isPopulated)
                AtlasUtility.populateExceptionString(thisClassName+':getSubscriberPaymentHistory', mainDTO.billSnapShotDTOObj,e);
            mainDTO.billSnapShotDTOObj.isPymentPopulated=false;
        }
        return mainDTO;
    }
    
    public static AtlasMainDTO processGetSubscriberPaymentHistoryResponse(AtlasFinServiceXmlschemaFinanceService.PaymentHistoryItem paymentHistoryObj, AtlasMainDTO mainDTO)
    {
        mainDTO.billSnapShotDTOObj.prevoiusDueAmount=paymentHistoryObj.amount;
        mainDTO.billSnapShotDTOObj.paymentDate=paymentHistoryObj.date_x;
        AtlasUtility.populateSuccess(mainDTO.billSnapShotDTOObj);

        // To identify if the previous transaction is failed or not
        if (!AtlasUtility.isEmpty(paymentHistoryObj.status) && paymentHistoryObj.status=='Failed')
               mainDTO.billSnapShotDTOObj.isPymentFailed=true;  
        return mainDTO; 
    }
        
    /**
    * @author Edwin Raymond
    * @description - updatePaymentSettings
    * @input param  - AtlasTransactionDTO.updatedPaymentMethodDTO
    * @return param String
    */
    public static String updatePaymentSettings(AtlasTransactionDTO.updatedPaymentMethodDTO paymentMethodObj)
    {   
        return AtlasIntegrationUtility.updateCurrentPaymentSettings(paymentMethodObj);
    }
    
    /**
    * @author Edwin Raymond
    * @description - submitPaymentTransaction
    * @input param  - AtlasTransactionDTO.oneTimePaymentDTO
    * @return param String
    */
    public static String submitPaymentTransaction(AtlasTransactionDTO.oneTimePaymentDTO paymentObj)
    {   
        return AtlasIntegrationUtility.submitOneTimePaymentTransaction(paymentObj);
    }
    /**
    * @author Tejesh Kumar
    * @description - submitPaymentTransactionForAutoResume
    * @input param  - AtlasTransactionDTO.oneTimePaymentDTOForAutoResume
    * @return param String
    */
    public static AtlasFinServiceXmlschemaV4FinanceService.OneTimePaymentAutoResumeResults submitPaymentTransactionForAutoResume(AtlasTransactionDTO.oneTimePaymentDTOForAutoResume paymentObj)
    {   
        return AtlasIntegrationUtility.submitOneTimePaymentAutoResume(paymentObj);
    }
    /**
    * @author Gaurav Gathania
    * @description - updateCustomerInfo
    * @input param  - AtlasTransactionDTO.UpdateCustomerInfoTxDTO custInfoObj
    * @return param String
    */
    public static String updateCustomerInfo(AtlasTransactionDTO.UpdateCustomerInfoTxDTO custInfoObj)
    {   
        return AtlasIntegrationUtility.updateCustomerInfo(custInfoObj);
    }

    /**
    * @author Gaurav Gathania
    * @Calls AtlasIntegrationUtility to get getALaCartePackages
    * @return AtlasMainDTO mainDTO
    */  
    public static AtlasMainDTO getALaCartePackages(AtlasMainDTO mainDTO)
    { 
        AtlasBuyMoreDTO buyMoreDTOObj=mainDTO.buyMoreDTOObj;
        AtlasPubCatlogServiceXmlschemaV2.Package_Test[] usagePckg;
        try{
            usagePckg=AtlasIntegrationUtility.getALaCartePackages(buyMoreDTOObj.externalSystemName, buyMoreDTOObj.externalAccountReference, buyMoreDTOObj.transactionType);
            if(!AtlasUtility.isEmpty(usagePckg) )
            {
                buyMoreDTOObj.usageItems=new List<AtlasBuyMoreDTO.UsageItem>();
                for(AtlasPubCatlogServiceXmlschemaV2.Package_Test p: usagePckg)
                {        AtlasPubCatlogServiceXmlschemaV2.PackageItem pckItem=p.optionGroup[0].packageItem[0];
                    buyMoreDTOObj.usageItems.add(new AtlasBuyMoreDTO.UsageItem(pckItem.packageItemReference,pckItem.packageItemPrice[0].masterCatalogReference,pckItem.displayName,pckItem.packageItemPrice[0].price) );
                } 
                AtlasUtility.populateSuccess(buyMoreDTOObj);
            }
        }catch(Exception e)
        {
            AtlasUtility.populateExceptionString(thisClassName+':getALaCartePackages',buyMoreDTOObj,e);
        }
        return mainDTO;
    }

    /**
    * @author Gaurav Gathania
    * @Calls AtlasIntegrationUtility to get addUsageQuota(
    * @return String
    */  
    public static String addUsageQuota(AtlasTransactionDTO.AddUsageQuotaDTO addQuotaObj)
    { 
        return AtlasIntegrationUtility.addUsageQuota(addQuotaObj);
    }
    
    /**
    * @author Srikanth Kudumula
    * @Calls AtlasIntegrationUtility to get getTransitionPackages
    * @return AtlasMainDTO mainDTO
    */  
    public static AtlasMainDTO getTransitionPackages(AtlasMainDTO mainDTO)
    { 
        AtlasChangePlanDTO changePlanDTOObj = new AtlasChangePlanDTO();//mainDTO.changePlanDTOObj;
        List<AtlasPlan__c> plansToDisplay= new List<AtlasPlan__c>();
        Set<string> plansToSkipList= new Set<string>();
        AtlasPubCatlogServiceXmlschemaV2.Package_TPTest[] usagePckg;       
        List<AtlasPubCatlogServiceXmlschemaV2.OptionGroup> optionGroups=null;
        List<AtlasPubCatlogServiceXmlschemaV2.Feature> features = null;
        String dataCapacity = '0';
        String downloadSpeed = null;
        String speedUnit = null;
        String bonusFeature = null;
        Map<String,String> bonusFeaturesMap = new Map<String,String>(); 
        //AtlasKeyValueStore__c AtlasKVS;
        
        //--- As per SB2+ requirements, commenting the customsetting and using the boolean in atlas plans table to display the plans for transition
        //AtlasKVS = AtlasKeyValueStore__c.getValues('AtlasCPlanVacationList');
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
                usagePckg=AtlasIntegrationUtility.getTransitionPackages(mainDTO.externalSystemName, mainDTO.externalAccountReference);
            system.debug('@@@ Usage Package--->'+usagePckg);
            if(!AtlasUtility.isEmpty(usagePckg) )
            {
                System.debug('@@@  I am inside parser --->');
                changePlanDTOObj.changePlanPackages=new List<AtlasChangePlanDTO.changePlanPackage>();
                for(AtlasPubCatlogServiceXmlschemaV2.Package_TPTest p: usagePckg)
                {   
                    optionGroups = p.optionGroup;
                    features = p.feature;
                    bonusFeature=null;
                    dataCapacity = '0';
                    system.debug('@@@ features --->'+features);
                    for(AtlasPubCatlogServiceXmlschemaV2.feature f : features){
                        if(f.name == 'DATA_CAP_GB') 
                            dataCapacity = f.value;
                        if(f.name == 'DOWNLOAD_RATE') 
                            downloadSpeed = f.value;
                        if(f.name == 'DOWNLOAD_RATE_UNIT')
                            speedUnit = f.value;
                        if(f.name == 'BONUS_FEATURE'){
                            system.debug('@@@ feature value--->'+f.value);
                            if(bonusFeature == null) {
                                bonusFeature = bonusFeaturesMap.get(f.value);                           
                            }
                            else
                                bonusFeature += '<br/>' + bonusFeaturesMap.get(f.value);
                        }
                    }
                    system.debug('@@@ individual package --->'+optionGroups); 
                    for(AtlasPubCatlogServiceXmlschemaV2.OptionGroup og : optionGroups) { 
                        if(og.displayName == 'Internet Access Service'){
                            AtlasPubCatlogServiceXmlschemaV2.PackageItem pckItem=og.packageItem[0];
                            system.debug('@@@ og.packageItem[0] --->'+og.packageItem[0]);
                            if(!Test.isRunningTest()){
                                //String plansToSkip = AtlasKVS.Value__c; // && !pckItem.displayName.contains('Vacation')
                                //system.debug('---plansToSkip --->'+plansToSkip); 
                                system.debug('---pckItem.displayName--->'+pckItem.displayName);
                                if(!plansToSkipList.contains(pckItem.displayName)) {                                                   
                                    changePlanDTOObj.changePlanPackages.add(new AtlasChangePlanDTO.changePlanPackage(pckItem.packageItemPrice[0].price,pckItem.displayName,pckItem.packageItemPrice[0].masterCatalogReference,dataCapacity,downloadSpeed,speedUnit,bonusFeature));
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
        return mainDTO;
    }
    
    /**
    * @author Srikanth Kudumula
    * @description - getAccountServiceAgreementsAndServicesV2
    * @input param  - AtlasMainDTO mainDTO
    * @return param AtlasMainDTO
    */  
    public static AtlasMainDTO getAccountServiceAgreementsAndServicesv2(AtlasMainDTO mainDTO)
    { 
        AtlasAccInfoXmlschemaPublic.accountServiceAgreementsBean servAgrmntInfoObj;
        try{
            //mainDTO = getLegacyAccount(mainDTO);
            servAgrmntInfoObj=AtlasIntegrationUtility.getAccountServiceAgreementsAndServices(mainDTO.accountKey);
            system.debug('@@@ Service Agreement Info -->'+servAgrmntInfoObj);
            if(!AtlasUtility.isEmpty(servAgrmntInfoObj))
            {
                mainDTO = processGetAccountServiceAgreementsAndServicesResponse(servAgrmntInfoObj, mainDTO);
            }
        }catch(Exception e)
        {
            system.debug('@@@ I am in Exception --->'+e.getMessage());
            AtlasUtility.populateExceptionString(thisClassName+':getAccountServiceAgreementsAndServices',mainDTO,e);
        }
        return mainDTO;
    }

    public static AtlasMainDTO processGetAccountServiceAgreementsAndServicesResponse(AtlasAccInfoXmlschemaPublic.accountServiceAgreementsBean servAgrmntInfoObj, AtlasMainDTO mainDTO)
    {
        if (mainDTO.changePlanDTOObj == null)
            mainDTO.changePlanDTOObj = new AtlasChangePlanDTO();
            
        AtlasChangePlanDTO changePlanDTOObj = mainDTO.changePlanDTOObj;         
        List<AtlasAccInfoXmlschemaPublic.accountServiceAndReferenceBean> accountServices = servAgrmntInfoObj.accountServices;
        
        for(AtlasAccInfoXmlschemaPublic.accountServiceAndReferenceBean accSer : accountServices)
        {
                if(accSer.accountServiceBean.productGroup=='INTERNET_ACCESS')
                    changePlanDTOObj.serviceItemReference = accSer.serviceItemReference;
        }
        AtlasUtility.populateSuccess(mainDTO);
        return mainDTO; 
    }
    
      /**
    * @author Srikanth Kudumula
    * @description - getTransactionsByAccountandType		//AR 11/17/15: updated the incorrect description
    * @input param  - AtlasMainDTO mainDTO
    * @return param AtlasMainDTO
    */  
    public static Boolean getTransactionsByAccountAndType(AtlasMainDTO mainDTO, String transitionType)
    {
        AtlasTransServiceXmlschemav2.Transaction_x[] getTransactionsByAccountAndTypeResponse=null;
        try{
            getTransactionsByAccountAndTypeResponse = AtlasIntegrationUtility.getTransactionsByAccountAndType(mainDTO.externalSystemName, mainDTO.externalAccountReference, transitionType);
            for(AtlasTransServiceXmlschemav2.Transaction_x res : getTransactionsByAccountAndTypeResponse){
                system.debug('--res.status--> '+res.status);
                if((res.status != 'COMPLETE')&&(res.status != 'REJECTED')) { //if any status other than COMPLETE/REJECTED assume inflight transaction                   
                    return true;
                }
            }
        }
        catch(Exception e){
            system.debug('@@@ I am in Exception --->'+e.getMessage());
            AtlasUtility.populateExceptionString(thisClassName+':getTransactionsByAccountAndType',mainDTO,e);
        }
        return false;
    } 
    
      /**
    * @author Kelly Wortel
    * @description - transactionsExistForAccount
    * @input param  - AtlasMainDTO mainDTO
    * @return boolean
    */  
    public static Boolean transactionsExistForAccount(AtlasMainDTO mainDTO)
    {
        AtlasTransServiceXmlschemav2.Transaction_x[] getTransactionsByAccountResponse=null;
        try{
            system.debug('---mainDTO.externalSystemName--->'+mainDTO.externalSystemName);
            system.debug('---mainDTO.externalAccountReference--->'+mainDTO.externalAccountReference);
            getTransactionsByAccountResponse = AtlasIntegrationUtility.getTransactionsByAccount(mainDTO.externalSystemName, mainDTO.externalAccountReference);
            for(AtlasTransServiceXmlschemav2.Transaction_x res : getTransactionsByAccountResponse){
                system.debug('--res.status--> '+res.status);
                if((res.status != 'COMPLETE')&&(res.status != 'REJECTED')) { //if any status other than COMPLETE/REJECTED assume inflight transaction                   
                    return true;
                }
            }
        }
        catch(Exception e){
            system.debug('@@@ I am in Exception --->'+e.getMessage());
            AtlasUtility.populateExceptionString(thisClassName+':getTransactionsByAccount',mainDTO,e);
        }
        return false;
    }     
	
	/**
    * @author Tejesh Kumar
    * @description - updateContacts
    * @input param  - AtlasMainDTO mainDTO,AtlasTransactionDTO.UpdateCustomerInfoTxDTO custInfoObj
    * @return boolean
    */  
    public static string updateContacts(AtlasMainDTO mainDTO,AtlasTransactionDTO.UpdateCustomerInfoTxDTO custInfoObj)
    {
        String updateContactsResponse=null;
        try{
            system.debug('---mainDTO.externalSystemName--->'+mainDTO.externalSystemName);
            system.debug('---mainDTO.externalAccountReference--->'+mainDTO.externalAccountReference);
            updateContactsResponse = AtlasIntegrationUtility.updateContacts(custInfoObj);
            
            system.debug('--updateContactsResponse--> '+updateContactsResponse);
			
			if(updateContactsResponse=='SUCCESS') {
				mainDTO.accountDTOObj.contactEmail	= custInfoObj.email;
				AtlasDatabaseManager.persistViewState(mainDTO);
				return updateContactsResponse;
			}
			else
				return null;
        }
        catch(Exception e) {
            system.debug('@@@ I am in Exception --->'+e.getMessage());
            //AtlasUtility.populateExceptionString(thisClassName+':updateContacts',mainDTO,e);
            return null;
        }
        
    }     
    
     /**
    * @author Tejesh Kumar
    * @Calls AtlasIntegrationUtility to get getAccount
    * @return AtlasMainDTO mainDTO
    */  
    public static AtlasMainDTO getAccount(AtlasMainDTO mainDTO)
    { 	
    	DealerPubAccountInfoXMLSchemaV2.account acc;
    	try{
    		//DealerPubServiceV2PWSCommonData.ExternalSubscriberIdentifier exSubId; 
    		//= buildParameters(mainDTO);
    		DealerPubServiceV2PWSCommonData.ExternalSubscriberIdentifier exSubId = new DealerPubServiceV2PWSCommonData.ExternalSubscriberIdentifier();
			exSubId.externalSystemName = mainDto.externalSystemName;
			exSubId.externalReference = mainDto.externalAccountReference;
    		system.debug('@@@ parameters --->'+exSubId);
        	acc=AtlasIntegrationUtility.getAccount(exSubId);
        	if(!AtlasUtility.isEmpty(acc))
        	{
        		system.debug('@@@ getAccount response --->'+acc);
        		system.debug('@@@ getAccount isSameAsServiceAddress --->'+acc.shippingContact.isSameAsServiceAddress);
        		if(acc.shippingContact.isSameAsServiceAddress=='false') {
	        		mainDTO.shippingAdd1 = acc.shippingContact.address.address1; 
	        		mainDTO.shippingAdd2 = acc.shippingContact.address.address2; 
	        		mainDTO.shippingCity = acc.shippingContact.address.city;
	        		mainDTO.shippingState = acc.shippingContact.address.state;
	        		mainDTO.shippingZip = acc.shippingContact.address.zip;
	        		mainDTO.shippingZip4 = acc.shippingContact.address.zipFour; 
	        		mainDTO.shippingFname = acc.shippingContact.person.firstName; 
	        		mainDTO.shippingLname = acc.shippingContact.person.lastName;
	        		mainDTO.shippingPhone = acc.shippingContact.primaryPhoneNumber;
        		}
        		else {
        			mainDTO.shippingAdd1 = acc.serviceAddress.address1;
	        		mainDTO.shippingAdd2 = acc.serviceAddress.address2;
	        		mainDTO.shippingCity = acc.serviceAddress.city;
	        		mainDTO.shippingState = acc.serviceAddress.state; 
	        		mainDTO.shippingZip = acc.serviceAddress.zip;
	        		mainDTO.shippingZip4 = acc.serviceAddress.zipFour;	
	        		mainDTO.shippingFname = acc.firstName; 
	        		mainDTO.shippingLname = acc.lastName;
	        		mainDTO.shippingPhone = acc.phoneDaytime;
        		}       		
        	}
    	}
    	catch(exception e){
    		 AtlasUtility.populateExceptionString(thisClassName+':getAccount',mainDTO,e);
    	}
        return mainDTO;  
    }
    
    
    /**
    * @author Tejesh Kumar
    * @Calls AtlasIntegrationUtility to get updateShippingContact, AtlasMainDTO mainDTO,AtlasTransactionDTO.UpdateCustomerInfoTxDTO custInfoObj
    * @return AtlasMainDTO mainDTO
    */  
    public static String updateShippingContact(AtlasMainDTO mainDTO,AtlasTransactionDTO.UpdateCustomerInfoTxDTO custInfoObj)
    { 
    	String response=null;
        try{
            response = AtlasIntegrationUtility.updateShippingContact(custInfoObj);           
            system.debug('--response--> '+response);
			
			if(response=='ACCEPTED') {
				mainDTO.accountDTOObj.contactEmail	= custInfoObj.email;
				mainDTO.shippingAdd1 = custInfoObj.billingAddress1;
	        	mainDTO.shippingAdd2 = custInfoObj.billingAddress2; 
        		mainDTO.shippingCity = custInfoObj.city;
        		mainDTO.shippingState = custInfoObj.state;
        		mainDTO.shippingZip = custInfoObj.zipCode; 
        		mainDTO.shippingFname = custInfoObj.firstName;
        		mainDTO.shippingLname = custInfoObj.lastName;
        		mainDTO.shippingPhone = custInfoObj.phone;
				AtlasDatabaseManager.persistViewState(mainDTO);
				return response;
			}
			else
				return null;
        }
        catch(Exception e) {
            system.debug('@@@ updateShippingContact I am in Exception --->'+e.getMessage());
            //AtlasUtility.populateExceptionString(thisClassName+':updateContacts',mainDTO,e);
            return null;
        }
    }
    
    //---------------------------------------------------------------------------------------  
    // PROCESSINGS ASYNC/CONTINUATION RESPONSES
    //---------------------------------------------------------------------------------------  
    // Parse web service Response, init AtlasMainDTO.accountKey
    public static AtlasMainDTO processGetLegacyAccountResponseAsync(string wsReturn, AtlasMainDTO mainDTO)
    {
        if (AtlasUtility.isEmpty(wsReturn))
            throw new AtlasException.InvalidDataException(AtlasUtility.getMapCode(AtlasConstants.SC_No_Data_Exp), AtlasUtility.getMapCode(AtlasConstants.SC_No_Data_Exp));

        Map<String,String> resMap = AtlasIntegrationUtility.parseXML(wsReturn);
        if (resMap.containsKey('account'))
            mainDTO.accountKey = resMap.get('account');
        return mainDTO; 
    }
    
    // Parse web service Response, init AtlasMainDTO.accountDTOObj
    public static AtlasMainDTO processSubscribersBySearchCriteriaResponseAsync(string wsReturn, AtlasMainDTO mainDTO)
    {
        if (AtlasUtility.isEmpty(wsReturn))
            throw new AtlasException.InvalidDataException(AtlasUtility.getMapCode(AtlasConstants.SC_No_Data_Exp), AtlasUtility.getMapCode(AtlasConstants.SC_No_Data_Exp));

        Map<String,String> resMap = AtlasIntegrationUtility.parseXML(wsReturn);
        mainDTO = AtlasIntegrationServiceManager.processSubscribersBySearchCriteriaResponse(resMap, mainDTO);       
mainDTO.accountDTOObj.isPopulated=true;        
        return mainDTO; 
    }

    // Parse web service Response, init AtlasMainDTO billing info
    public static AtlasMainDTO processGetBillingSummaryResponseAsync(Object wsReturn, AtlasMainDTO mainDTO)
    {
        if (mainDTO.isUnlimited == null)
            mainDTO.isUnlimited = false;
        if (mainDTO.isOpenNetPlan == null)
            mainDTO.isOpenNetPlan = false;
        if (mainDTO.accountDTOObj == null)
            mainDTO.accountDTOObj = new AtlasAccountDTO();      
        if (mainDTO.isAccountPopulated == null)
            mainDTO.isAccountPopulated = false;

        if (AtlasUtility.isEmpty(wsReturn))
            throw new AtlasException.InvalidDataException(AtlasUtility.getMapCode(AtlasConstants.SC_No_Data_Exp), AtlasUtility.getMapCode(AtlasConstants.SC_No_Data_Exp));

        AtlasAccInfoXmlschemaPublic.billingSummary billingSummaryObj = (AtlasAccInfoXmlschemaPublic.billingSummary)wsReturn;
        return AtlasIntegrationServiceManager.processGetBillingSummaryResponse(billingSummaryObj, mainDTO);
    }      

    // Parse web service Response, init AtlasMainDTO
    public static AtlasMainDTO processGetAccountServiceAgreementsAndServicesResponseAsync(Object wsReturn, AtlasMainDTO mainDTO)
    {
        if (AtlasUtility.isEmpty(wsReturn))
            throw new AtlasException.InvalidDataException(AtlasUtility.getMapCode(AtlasConstants.SA_No_Data_Exp), AtlasUtility.getMapCode(AtlasConstants.SA_No_Data_Exp));

        AtlasAccInfoXmlschemaPublic.accountServiceAgreementsBean[] accServAgmntArray = (AtlasAccInfoXmlschemaPublic.accountServiceAgreementsBean[])wsReturn;
        if (AtlasUtility.isEmpty(accServAgmntArray))
            throw new AtlasException.InvalidDataException(AtlasUtility.getMapCode(AtlasConstants.SA_No_Data_Exp), AtlasUtility.getMapValue(AtlasConstants.SA_No_Data_Exp));
            
        if (accServAgmntArray.size()==1)
            mainDTO = AtlasIntegrationServiceManager.processGetAccountServiceAgreementsAndServicesResponse(accServAgmntArray[0], mainDTO);
        return mainDTO; 
    }
    
    // Parse web service Response, init AtlasMainDTO
    public static AtlasMainDTO processGetSubscriberPaymentHistoryResponseAsync(Object wsReturn, AtlasMainDTO mainDTO)
    {
        if (mainDTO.billSnapShotDTOObj == null)
            mainDTO.billSnapShotDTOObj = new AtlasBillingSnapShotDTO();

        if (AtlasUtility.isEmpty(wsReturn))
            throw new AtlasException.InvalidDataException(AtlasUtility.getMapCode(AtlasConstants.PH_No_Data_Exp), AtlasUtility.getMapCode(AtlasConstants.PH_No_Data_Exp));

        AtlasFinServiceXmlschemaFinanceService.PaymentHistoryItem[] subInvoiceObj = (AtlasFinServiceXmlschemaFinanceService.PaymentHistoryItem[])wsReturn;
        if (AtlasUtility.isEmpty(subInvoiceObj))
            throw new AtlasException.InvalidDataException(AtlasUtility.getMapCode(AtlasConstants.PH_No_Data_Exp), AtlasUtility.getMapValue(AtlasConstants.PH_No_Data_Exp));
            
        if (subInvoiceObj.size()>=1)
            mainDTO = AtlasIntegrationServiceManager.processGetSubscriberPaymentHistoryResponse(subInvoiceObj[0], mainDTO);
        return mainDTO; 
    }
    
    public static AtlasMainDTO processGetSubscriberLedgerSummaryResponseAsync(Object wsReturn, AtlasMainDTO mainDTO)
    {
        if (mainDTO.billSnapShotDTOObj == null)
            mainDTO.billSnapShotDTOObj = new AtlasBillingSnapShotDTO();
            
        if (AtlasUtility.isEmpty(wsReturn))
            throw new AtlasException.InvalidDataException(AtlasUtility.getMapCode(AtlasConstants.LS_No_Data_Exp), AtlasUtility.getMapCode(AtlasConstants.LS_No_Data_Exp));

        AtlasFinServiceXmlschemaFinanceService.SubscriberLedgerSummary billingSnapShotObj = (AtlasFinServiceXmlschemaFinanceService.SubscriberLedgerSummary)wsReturn;
        return AtlasIntegrationServiceManager.processGetSubscriberLedgerSummaryResponse(billingSnapShotObj, mainDTO);
    }

    public static AtlasMainDTO processGetSubscriberCurrentPaymentMethodResponseAsync(Object wsReturn, AtlasMainDTO mainDTO)
    {
        if (mainDTO.currentPaymentMethodDTOObj == null)
            mainDTO.currentPaymentMethodDTOObj = new AtlasCurrentPaymentMethodDTO();

        if (!AtlasUtility.isEmpty(wsReturn))
        {
            AtlasFinServiceXmlschemaFinanceService.PaymentMethodHistoryItem paymentMethodObj = (AtlasFinServiceXmlschemaFinanceService.PaymentMethodHistoryItem)wsReturn;
            mainDTO = AtlasIntegrationServiceManager.processGetSubscriberCurrentPaymentMethodResponse(paymentMethodObj, mainDTO);
        }
        return mainDTO;
    }

    // Data assignment for the Usage DTO - process the HTTP Response from getCurrentQuotaByAccount Continuation Process
    // based on AtlasIntegrationServiceManager.getCurrentUsageByAccountV3(AtlasMainDTO mainDTO)
    public static AtlasMainDTO processGetCurrentQuotaByAccountResponseAsync(string res, AtlasMainDTO mainDTO)
    {
        if (AtlasUtility.isEmpty(res))
            throw new AtlasException.InvalidDataException(AtlasUtility.getMapCode(AtlasConstants.SC_No_Data_Exp), AtlasUtility.getMapCode(AtlasConstants.SC_No_Data_Exp));
        
        mainDTO.cduDTOObj = new AtlasCurrentDataUsageDTO();     
        return AtlasIntegrationServiceManager.processGetCurrentQuotaByAccountResponse(res, mainDTO);
    }

    // Data assignment for the Usage DTO - process the HTTP Response from getCurrentUsageByAccount Continuation Process
    public static AtlasMainDTO processGetCurrentUsageByAccountResponseAsync(string res, AtlasMainDTO mainDTO)
    {
        if (AtlasUtility.isEmpty(res))
            throw new AtlasException.InvalidDataException(AtlasUtility.getMapCode(AtlasConstants.SC_No_Data_Exp), AtlasUtility.getMapCode(AtlasConstants.SC_No_Data_Exp));
        
        mainDTO.cduDTOObj = new AtlasCurrentDataUsageDTO();     
        return AtlasIntegrationServiceManager.processGetCurrentUsageByAccountResponse(res, mainDTO);
    }
    
    //AR: 11/17/2015: for sending the values of transaction history table values to mainDTO
    public static void addAtlasTransactionModel(AtlasMainDTO mainDTO, AtlasTransactionModel txnModel){
		List<AtlasTransactionModel> result = mainDTO.atlasTransactionModelList;
		if(result != null)
		  mainDTO.atlasTransactionModelList.add(txnModel);
		else{
			result = new List<AtlasTransactionModel>();
			result.add(txnModel);
			mainDTO.atlasTransactionModelList = result;
		}
		system.debug('>>>>>>>>AR:mainDTO list'+mainDTO.atlasTransactionModelList);
    }
}