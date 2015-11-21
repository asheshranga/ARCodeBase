/*********************************************************************************
Name         : AtlasChangePlanCompController
Created By   : Tejesh Kumar
Company Name : CMC Americas
Project      : ViaSat Atlas
Created Date : 04/16/2015
Usages       : Controller for VisualForce Components: 
*********************************************************************************/
public with sharing class AtlasChangePlanCompController extends AtlasDataManager{ 
   
    // Variables used in Change Plan New Enhancement Project
    public string buttonStyleClass{get;set;}
    public string confirmation{get{return AtlasUtility.getMapValue(AtlasConstants.AtlasConfirmation);}set;}
    public string confirmText{get{return AtlasUtility.getMapValue(AtlasConstants.ChangePlanConfirm);}set;}
    public string WhatToExpect{get{return AtlasUtility.getMapValue(AtlasConstants.WhatToExpect);}set;}
    public string AtlasHoldTight1{get{return AtlasUtility.getMapValue(AtlasConstants.AtlasHoldTight1);}set;}
    public string AtlasHoldTight2{get{return AtlasUtility.getMapValue(AtlasConstants.AtlasHoldTight2);}set;}
    public string AtlasHoldTight3{get{return AtlasUtility.getMapValue(AtlasConstants.AtlasHoldTight3);}set;}
    public string AtlasWhatNext1{get{return AtlasUtility.getMapValue(AtlasConstants.AtlasWhatNext1);}set;}
    public string AtlasWhatNext2{get{return AtlasUtility.getMapValue(AtlasConstants.AtlasWhatNext2);}set;}
    public string AtlasWhatNext3{get{return AtlasUtility.getMapValue(AtlasConstants.AtlasWhatNext3);}set;}
    public string AtlasWhatNext4{get{return AtlasUtility.getMapValue(AtlasConstants.AtlasWhatNext4);}set;}
    public string AtlasWhatNext5{get{return AtlasUtility.getMapValue(AtlasConstants.AtlasWhatNext5);}set;}
    public string AtlasTroubleText1{get{return AtlasUtility.getMapValue(AtlasConstants.AtlasTroubleText1);}set;}
    public string AtlasTroubleText2{get{return AtlasUtility.getMapValue(AtlasConstants.AtlasTroubleText2);}set;} 
    public string AtlasTroubleText3{get{return AtlasUtility.getMapValue(AtlasConstants.AtlasTroubleText3);}set;}
    public string AtlasTroubleText4{get{return AtlasUtility.getMapValue(AtlasConstants.AtlasTroubleText4);}set;}
    public string AtlasTroubleText5{get{return AtlasUtility.getMapValue(AtlasConstants.AtlasTroubleText5);}set;}
    public string AtlasNextBill{get{return AtlasUtility.getMapValue(AtlasConstants.AtlasNextBill);}set;}
    public string AtlasNextBillText1{get{return AtlasUtility.getMapValue(AtlasConstants.AtlasNextBillText1);}set;}
    public string AtlasNextBillText2{get{return AtlasUtility.getMapValue(AtlasConstants.AtlasNextBillText2);}set;}
    public string AtlasPrint{get{return AtlasUtility.getMapValue(AtlasConstants.AtlasPrint);}set;}
    public string AtlasCPlanDashboard{get{return AtlasUtility.getMapValue(AtlasConstants.AtlasCPlanDashboard);}set;}
    public string AtlasMovingVacation{get{return AtlasUtility.getMapValue(AtlasConstants.AtlasMovingVacation);}set;}
    public string AtlasMovingGoingVacation{get{return AtlasUtility.getMapValue(AtlasConstants.AtlasMovingGoingVacation);}set;}
    public string AtlasMovingHelp{get{return AtlasUtility.getMapValue(AtlasConstants.AtlasMovingHelp);}set;}
    public string AtlasMovingHelpText{get{return AtlasUtility.getMapValue(AtlasConstants.AtlasMovingHelpText);}set;}
    public string AtlasCallCare{get{return AtlasUtility.getMapValue(AtlasConstants.AtlasCallCare);}set;}
    public string AtlasLeavingVacation{get{return AtlasUtility.getMapValue(AtlasConstants.AtlasLeavingVacation);}set;}
    public string AtlasLeavingVacationText{get{return AtlasUtility.getMapValue(AtlasConstants.AtlasLeavingVacationText);}set;}
    public string AtlasChangeMyPlan{get{return AtlasUtility.getMapValue(AtlasConstants.AtlasChangeMyPlan);}set;}
    public string AtlasCPlanSummary{get{return AtlasUtility.getMapValue(AtlasConstants.AtlasCPlanSummary);}set;}
    public string AtlasCPlanSummaryText{get{return AtlasUtility.getMapValue(AtlasConstants.AtlasCPlanSummaryText);}set;}
    public string AtlasNewPlan{get{return AtlasUtility.getMapValue(AtlasConstants.AtlasNewPlan);}set;}
    public string AtlasDataTransition{get{return AtlasUtility.getMapValue(AtlasConstants.AtlasDataTransition);}set;}
    public string AtlasPerMonth{get{return AtlasUtility.getMapValue(AtlasConstants.AtlasPerMonth);}set;}
    public string AtlasAlreadyUsed{get{return AtlasUtility.getMapValue(AtlasConstants.AtlasAlreadyUsed);}set;}
    public string AtlasPlanRemaining{get{return AtlasUtility.getMapValue(AtlasConstants.AtlasPlanRemaining);}set;}
    public string AtlasPlusLiberyPass{get{return AtlasUtility.getMapValue(AtlasConstants.AtlasPlusLiberyPass);}set;} 
    public string LearnLibertyPass{get{return AtlasUtility.getMapValue(AtlasConstants.Atlas_Liberty_Pass_Learn_More_Text);}set;}
    public string AtlasPastDataCap{get{return AtlasUtility.getMapValue(AtlasConstants.AtlasPastDataCap);}set;}
    public string AtlasLibertyPassText{get{return AtlasUtility.getMapValue(AtlasConstants.AtlasLibertyPassText);}set;}
    public string AtlasServicePerformance{get{return AtlasUtility.getMapValue(AtlasConstants.AtlasServicePerformance);}set;}
    public string AtlasPleaseNote{get{return AtlasUtility.getMapValue(AtlasConstants.AtlasPleaseNote);}set;}
    public string AtlasSummaryNote1{get{return AtlasUtility.getMapValue(AtlasConstants.AtlasSummaryNote1);}set;}
    public string AtlasSummaryNote2{get{return AtlasUtility.getMapValue(AtlasConstants.AtlasSummaryNote2);}set;}
    public string AtlasTermsConditions{get{return AtlasUtility.getMapValue(AtlasConstants.AtlasTermsConditions);}set;}
    public string AtlasTermsConditionsText1{get{return AtlasUtility.getMapValue(AtlasConstants.AtlasTermsConditionsText1);}set;}
    public string AtlasSubmitChange{get{return AtlasUtility.getMapValue(AtlasConstants.AtlasSubmitChange);}set;}
    public string AtlasHowFast{get{return AtlasUtility.getMapValue(AtlasConstants.AtlasHowFast);}set;}
    public string AtlasMbps{get{return AtlasUtility.getMapValue(AtlasConstants.AtlasMbps);}set;}
    public string AtlasHowMuch{get{return AtlasUtility.getMapValue(AtlasConstants.AtlasHowMuch);}set;}
    public string AtlasGBperMonth{get{return AtlasUtility.getMapValue(AtlasConstants.AtlasGBperMonth);}set;}
    public string AtlasBonus{get{return AtlasUtility.getMapValue(AtlasConstants.AtlasBonus);}set;}  
    public string AtlasPlansLoading{get{return AtlasUtility.getMapValue(AtlasConstants.AtlasPlansLoading);}set;} 
    public string AtlasThingstoKnow{get{return AtlasUtility.getMapValue(AtlasConstants.AtlasThingstoKnow);}set;}  
    public string AtlasThingstoKnowText1{get{return AtlasUtility.getMapValue(AtlasConstants.AtlasThingstoKnowText1);}set;}  
    public string AtlasThingstoKnowText2{get{return AtlasUtility.getMapValue(AtlasConstants.AtlasThingstoKnowText2);}set;}  
    public string AtlasCurrentPlan{get{return AtlasUtility.getMapValue(AtlasConstants.AtlasCurrentPlan);}set;}  
    public string AtlasSelectPlan{get{return AtlasUtility.getMapValue(AtlasConstants.AtlasSelectPlan);}set;}  
    public string AtlasSelectPlanText{get{return AtlasUtility.getMapValue(AtlasConstants.AtlasSelectPlanText);}set;}      
    public string AtlasCPlanCustIssue{get{return AtlasUtility.getMapValue(AtlasConstants.AtlasCPlanCustIssue);}set;} 
    public string AtlasCPlanUnavailable{get{return AtlasUtility.getMapValue(AtlasConstants.AtlasCPlanUnavailable);}set;} 
    public string AtlasCPlanCustIssueText{get{return AtlasUtility.getMapValue(AtlasConstants.AtlasCPlanCustIssueText);}set;} 
    public string AtlasUnavailable{get{return AtlasUtility.getMapValue(AtlasConstants.AtlasUnavailable);}set;} 
    public string AtlasCPlanSysIssueText{get{return AtlasUtility.getMapValue(AtlasConstants.AtlasCPlanSysIssueText);}set;} 
    public string AtlasCPlanPending{get{return AtlasUtility.getMapValue(AtlasConstants.AtlasCPlanPending);}set;} 
    public string AtlasPendingStatus1{get{return AtlasUtility.getMapValue(AtlasConstants.AtlasPendingStatus1);}set;} 
    public string AtlasPendingStatus2{get{return AtlasUtility.getMapValue(AtlasConstants.AtlasPendingStatus2);}set;} 
    public string privisonStatus{get{return AtlasUtility.getMapValue(AtlasConstants.Buy_More_Valid_Status);}set;}     
    public string AtlasCPlanPendingPlan{get{return AtlasUtility.getMapValue(AtlasConstants.AtlasCPlanPendingPlan);}set;}
    public string AtlasCPlanPendingPlanText{get{return AtlasUtility.getMapValue(AtlasConstants.AtlasCPlanPendingPlanText);}set;}
    public string AtlasCPlanNextBill2{get{return AtlasUtility.getMapValue(AtlasConstants.AtlasCPlanNextBill2);}set;}
    public string AtlasCPlanNextBill1{get{return AtlasUtility.getMapValue(AtlasConstants.AtlasCPlanNextBill1);}set;}
    public string AtlasCPlanProvStatusList{get{return AtlasUtility.getMapValue(AtlasConstants.AtlasCPlanProvStatusList);}set;}
    public string strSignOutText{get{return AtlasUtility.getHyperLinkText(AtlasConstants.SIGNOUT);}set;}
    public string AtlasCPlanLogout{get{return AtlasUtility.getMapValue(AtlasConstants.AtlasCPlanLogout);}set;}
    public string AtlasCPlanLogoutText{get{return AtlasUtility.getMapValue(AtlasConstants.AtlasCPlanLogoutText);}set;}
    public string CPlanEditEmail{get{return AtlasUtility.getMapValue(AtlasConstants.CPlanEditEmail);}set;}
    public string CPlanEditShippingAdd{get{return AtlasUtility.getMapValue(AtlasConstants.CPlanEditShippingAdd);}set;}
    public string CPlanModemText1{get{return AtlasUtility.getMapValue(AtlasConstants.CPlanModemText1);}set;}
    public string CPlanModemText2{get{return AtlasUtility.getMapValue(AtlasConstants.CPlanModemText2);}set;}
    public string CPlanModemText3{get{return AtlasUtility.getMapValue(AtlasConstants.CPlanModemText3);}set;}
    public string CPlanNewEquip{get{return AtlasUtility.getMapValue(AtlasConstants.CPlanNewEquip);}set;}
    public string CPlanNewEquipText{get{return AtlasUtility.getMapValue(AtlasConstants.CPlanNewEquipText);}set;}
    public string CPlanShippingInfo{get{return AtlasUtility.getMapValue(AtlasConstants.CPlanShippingInfo);}set;}
    public string CPlanShippingText{get{return AtlasUtility.getMapValue(AtlasConstants.CPlanShippingText);}set;}
    public string CPlanSwitchModemText{get{return AtlasUtility.getMapValue(AtlasConstants.CPlanSwitchModemText);}set;}
    public string CPlanThatsIt{get{return AtlasUtility.getMapValue(AtlasConstants.CPlanThatsIt);}set;}
    public string CPlanConfirmSb2PlusText{get{return AtlasUtility.getMapValue(AtlasConstants.CPlanConfirmSb2PlusText);}set;}
    
    //Url Custom Settings
    public String strDashboardUrl{get{return AtlasUtility.getURL(AtlasConstants.DASHBOARD);}set;}
    public String billingSnapshotLink{get{return AtlasUtility.getURL(AtlasConstants.BILLING_SNAPSHOT);}set;}
    public String strChangePlanUrl{get{return AtlasUtility.getURL(AtlasConstants.strCHANGE_PLAN);}set;}
    public String LIbertyPlansLink{get{return AtlasUtility.getURL(AtlasConstants.LIbertyPlansLink);}set;}
    public string strSignOutURL{get{return AtlasUtility.getURL(AtlasConstants.SIGNOUT);}set;}
    
    public boolean isVisibleSuccessAlert{get;set;}
    public boolean isVisibleExceptionMessage{get;set;}
    public boolean isVisibleSuccessShipping{get;set;}
    public boolean isVisibleExceptionShipping{get;set;}
    public string strEmail{get;set;}
    public string strConfirmEmail{get;set;}       
    public string strFirstName{get;set;}
    public string strLastName{get;set;}
    public string strAddress1{get;set;}
    public string strAddress2{get;set;}
    public string strCity{get;set;}
    public string strState{get;set;}
    public string strZip{get;set;} 
    public string strPhone{get;set;} 
    public string exceptionString{get;set;}
    public boolean hideEmailEditBody{get;set;}
     
    // Initializing the Change Plan DTO object   
    public AtlasChangePlanDTO changePlanDTOObj{get;set;}
    
    public string selectedPlanName{get;set;}
    
    // Initializing Main DTO 
    public AtlasMainDTO mainDTO{get;set;}
    // Initializing Account DTO    
    public AtlasAccountDTO accountDTO{get;set;} 
       
    //Apex class is used to find the booleans
    public AtlasComponenttoController componentToPage{get; set;}
    
    /**
    * @author Tejesh Kumar
    * @description - To get list of states from custom settings
    * @input param  - null
    * @return param List of states
    */         
	public List<SelectOption> getBillingStates() {
	   List<SelectOption> options=new List<SelectOption>();
	    List<AtlasBillingStatesList__c> bStates=AtlasBillingStatesList__c.getall().values();
	    bStates.sort();
	    for (AtlasBillingStatesList__c bState: bStates)
	    options.add(new SelectOption(bState.StateAbbreviatedCode__c,bState.StateAbbreviatedCode__c));
	    return options;
	}
        
        
    public  AtlasPlan__c myPlan{get{
        String serviceLevel;
        if(!Test.isRunningTest())
            serviceLevel=accountDTO.serviceLevel;
        else
            serviceLevel='FREEDOM';
        //query to return plan attributes from Atlas Plan object
        List<AtlasPlan__c> myPlanList = [SELECT datacapgb__c, downloadspeed__c, downloadspeedunit__c, freezonetype__c, bonusfeature1__c, bonusfeature2__c, bonusfeature3__c,BonusFeature4__c,BonusFeature5__c
        FROM AtlasPlan__c
        WHERE PlanAPIName__c =: serviceLevel LIMIT 1]; 
        system.debug('--myPlanList --> '+myPlanList );
        if(myPlanList.size()>0)
            return myPlanList[0]; 
        else
            return null;
    }  
    set;} 
    
    public integer intDataCap{get {
        decimal d = Decimal.valueOf(myDataCapacity);
        return d.intValue();
     } set;} 
    
    public string myDataCapacity{get {
        if(myPlan!=null) {
            return myPlan.DataCapGB__c;
        }
        else
            return null;
    } set;} 
    
    public string myDownloadSpeed{get {     
        if(myPlan!=null)
            return myPlan.DownloadSpeed__c;
        else
            return null;    
    } set;}  
    
    public List<AtlasPlanAttributes__c> myBonusFeatures{get {
        return null;
    }set;} 
        
    public List<String> mybfList{get {
        List<string> dummyList = new List<string>();
        Set<string> bonusFeatSet= new Set<string>();
        List<String> bfList=new List<String>();
        if(myPlan!=null) {                       
            Map<String,String> bonusFeaturesMap = new Map<String,String>(); 
            List<AtlasPlanAttributes__c> apaList = [select AttributeValue__c, SelfcareText__c from AtlasPlanAttributes__c];
            for(AtlasPlanAttributes__c apa : apaList){
                bonusFeaturesMap.put(apa.AttributeValue__c,apa.SelfcareText__c);
            }
            if(!AtlasUtility.isEmpty(myPlan.bonusfeature1__c)) bonusFeatSet.add(bonusFeaturesMap.get(myPlan.bonusfeature1__c));      
            if(!AtlasUtility.isEmpty(myPlan.bonusfeature2__c)) bonusFeatSet.add(bonusFeaturesMap.get(myPlan.bonusfeature2__c)); 
            if(!AtlasUtility.isEmpty(myPlan.bonusfeature3__c)) bonusFeatSet.add(bonusFeaturesMap.get(myPlan.bonusfeature3__c)); 
            if(!AtlasUtility.isEmpty(myPlan.bonusfeature4__c)) bonusFeatSet.add(bonusFeaturesMap.get(myPlan.bonusfeature4__c)); 
            if(!AtlasUtility.isEmpty(myPlan.bonusfeature5__c)) bonusFeatSet.add(bonusFeaturesMap.get(myPlan.bonusfeature5__c)); 
            
            bfList.addAll(bonusFeatSet);  
            system.debug('---bfList---> '+bfList);
            
            return bfList;
        }       
        else
            return null;    
    }set;}     
    
    public List<Integer> myPlanNumOfBars {get {
    if(myDataCapacity!=null) {
        List<Integer> dummyList = new List<Integer>();
        decimal d = Decimal.valueOf(myDataCapacity);
        integer dataCap = d.intValue();
        for(Integer i=0; i<dataCap; i++){
            dummyList.add(i);
        }
        return dummyList;
    }
    else
        return null;
    } 
    set;}
    
    // Constructor
    public AtlasChangePlanCompController() {         
        componentToPage = new AtlasComponenttoController(); 
        isVisibleSuccessAlert= false; 
        isVisibleExceptionMessage = false;
        exceptionString='test exception msg';
    } 
    
    /**
    * @author Tejesh Kumar
    * @description - Select Button action for Available Plans
    * @input param  - null
    * @return null
    */ 
    public  pageReference selectButton() {        
        componentToPage.selectionPanel=false;
        componentToPage.summaryPanel=true;
        componentToPage.confirmPanel=false;
        system.debug('--selectedPlanName --> '+selectedPlanName );
        for(AtlasChangePlanDTO.changePlanPackage plan: mainDTO.changePlanDTOObj.changePlanPackages) {
            system.debug('--plan--> '+plan);
            if(selectedPlanName.toLowercase() == plan.planName.toLowercase()) {
                componentToPage.selectedPlan=plan;
            }
        }
        try{
            getAccountServiceAgreementsAndServicesv2(mainDTO);
        }
        catch(exception e){
            
        }
        
        // To identify the Liberty Plans and SB2+ Plans
        Set<String> AtlasPlansSet = new Set<String>();
        Set<String> sb2PlusPlansSet = new Set<String>();       
        List<AtlasPlan__c> atlasPlans = [select Id,PlanAPIName__c,IsLibertyPlan__c,sb2PlusPlan__c FROM  AtlasPlan__c WHERE IsLibertyPlan__c=TRUE OR sb2PlusPlan__c=TRUE];
             for(AtlasPlan__c ap : atlasPlans){
             	if(ap.IsLibertyPlan__c)
             		AtlasPlansSet.add(ap.PlanAPIName__c.toLowerCase());
         		if(ap.sb2PlusPlan__c)
             		sb2PlusPlansSet.add(ap.PlanAPIName__c.toLowerCase());
            }
        system.debug('---sb2PlusPlansSet---> '+ sb2PlusPlansSet); 
        string servicePlan= componentToPage.selectedPlan.planName;
        if(!AtlasUtility.isEmpty(servicePlan) && AtlasPlansSet.contains(servicePlan.toLowercase()))
            componentToPage.isLiberty=true; 
        // To identify SB2+ plan transition
        if(!AtlasUtility.isEmpty(servicePlan) && sb2PlusPlansSet.contains(servicePlan.toLowercase()))
            componentToPage.isSb2plusPlan=true;
                         
        return null;    
    } 
    
    /**
    * @author Tejesh Kumar
    * @description - Back button action in Confirmation page for ChangePlanController
    * @input param  - null
    * @return null
    */ 
    public  pageReference backButton() {        
        componentToPage.selectionPanel=true;
        componentToPage.summaryPanel=false;
        componentToPage.confirmPanel=false;
        componentToPage.isSb2plusPlan=false;
        return null;      
    }   
    
    /**
    * @author Tejesh Kumar
    * @description - submit change button action in Confirmation page for ChangePlanController
    * @input param  - null
    * @return null
    */ 
    public  pageReference submitChange() {        
        //system.debug('@@@ SC Selected Plan-->'+componentToPage);
        //system.debug('@@@ SC Main DTO --->'+mainDTO);
        Map<String,String> changePlanMap = new Map<String,String>();
        try{
            //ChangePlanMap = getTransistionBaseService(mainDTO.externalSystemName, mainDTO.externalAccountReference, componentToPage.selectedPlan.planName, componentToPage.selectedPlan.masterCatalogReference, mainDTO.changePlanDTOObj.serviceItemReference);
            httpResponse res = AtlasIntegrationUtility.getTransistionBaseService(mainDTO.externalSystemName, mainDTO.externalAccountReference, componentToPage.selectedPlan.planName, componentToPage.selectedPlan.masterCatalogReference, mainDTO.changePlanDTOObj.serviceItemReference);                          
            //system.debug('@@@ SC res --->'+res); 
            Dom.Document doc=res.getBodyDocument();
            Dom.XMLNode rootNode=doc.getRootElement();
            system.debug('@@@ SC root Node --->'+rootNode);
            String ErrorCode;
            String OrderStatus;
            for(Dom.XMLNode childNode : rootNode.getChildElements()){
                if('ResponseStatus' == childNode.getName()){
                    system.debug('@@@ child Node --->'+childNode);
                    Dom.Xmlnode[]  cNode = childNode.getChildElements();
                    for(Dom.Xmlnode c : cNode){
                        if('ErrorCode' == c.getName()){
                            system.debug('@@@ child node --->'+c.getName());
                            system.debug('@@@ child text --->'+c.getText());
                            ErrorCode = c.getText();
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
                                    system.debug('@@@ child node --->'+c2.getName()); 
                                    system.debug('@@@ child text --->'+c2.getText());
                                    OrderStatus = c2.getText();
                                }
                                if('OrderReference' == c2.getName()){
                                    system.debug('@@@ child node --->'+c2.getName());
                                    system.debug('@@@ child text --->'+c2.getText());
                                    componentToPage.externalTransactionReference = c2.getText();
                                }
                            }
                        }
                    }
                }
            }          
            if(errorCode == 'Success' && OrderStatus == 'Accepted'){                                
                system.debug('--plan changed successfully---> '); 
                if(!AtlasUtility.isEmpty(mainDTO.externalAccountReference)) 
                    AtlasDatabaseManager.insertTransaction('Change Plan','Change Plan','Change Plan Transition','Success','',mainDTO.accountNo);  
                    
                //--- Ashesh changes to above insert transaction to pass account no instead of external account reference. But for SB2+ QA deployment is before Ashesh changes deployment,
                //--- so use the below statement for SB2+ migration and let Ashesh know
                //AtlasDatabaseManager.insertTransaction('Change Plan','Change Plan','Change Plan Transition','Success','',mainDTO.externalAccountReference);     
                                        
                componentToPage.selectionPanel=false;
                componentToPage.summaryPanel=false;
                componentToPage.confirmPanel=true;                     
                string servicePlan= componentToPage.selectedPlan.planName;              
                mainDTOObj.accountDTOObj.serviceLevel = servicePlan;                                 
            }
            else{
                componentToPage.selectionPanel=true;
                componentToPage.summaryPanel=false;
                componentToPage.confirmPanel=false;
                componentToPage.selectionPanelOptions=false;
                componentToPage.systemIssuePanel=true;
            }  
            
            return null; 
        }
        catch(Exception e){
            return null;
        }
    }  
    
    /**
    * @author Tejesh Kumar
    * @description - fillContactEmail action in Sumamry page for ChangePlanController
    * @input param  - null
    * @return param void
    */ 
	public pageReference fillContactEmail() {    
		isVisibleSuccessAlert= false;
		if(mainDTO.accountDTOObj != null) {
			strEmail=mainDTO.accountDTOObj.contactEmail;
			strConfirmEmail=mainDTO.accountDTOObj.contactEmail;	  
		}
		return null;
	}
	
	/**
    * @author Tejesh Kumar
    * @description - updateEmail action in Sumamry page for ChangePlanController
    * @input param  - null
    * @return null
    */ 
    public  pageReference updateEmail() {     		
    	if(!AtlasUtility.isEmpty(strEmail) && !AtlasUtility.isEmpty(strConfirmEmail)) {
    		if(strEmail==strConfirmEmail) {
    			strEmail=strEmail.trim();	//mainDTO.externalAccountReference
    		
	    		AtlasTransactionDTO.UpdateCustomerInfoTxDTO custInfoObj = new AtlasTransactionDTO.UpdateCustomerInfoTxDTO(mainDTO.externalAccountReference,mainDTO.externalSystemName,null,null,strEmail, 
                																null,null,null,null,null,null,null,null,null,null,null,null,null,null,null);
	    		try {
	    			system.debug('---saveCustomerInfo:---> ' + custInfoObj);
	    			exceptionString='test exception';	
	    			isVisibleExceptionMessage=true;  
	    			String result = updateContacts(custInfoObj);
	    			system.debug('---result:---> ' + result);
	    			if(result=='SUCCESS') {	
    					system.debug('--enter if success--> ');    				
    					//strEmail=mainDTO.accountDTOObj.contactEmail;
    											 
    					mainDTO.accountDTOObj.contactEmail= strEmail;  
    					//isVisibleExceptionMessage=false;					
	    				hideEmailEditBody= true;
	    				isVisibleSuccessAlert= true;
	    			} 
	    			else {
	    				exceptionString='Contact Email is not saved';
	    				isVisibleExceptionMessage=true; 
	    				isVisibleSuccessAlert= false;  
	    			}		    		
	    		} 
	    		catch(exception e) {
	    			isVisibleSuccessAlert= false; 	
	    		}   		
	    	}
	    	else {
	    		isVisibleExceptionMessage=true;
	    		hideEmailEditBody= false;
	    		exceptionString='Emails do not match';	
	    	}    	    	
    	}
    	return null;
    }     
     
    /**
    * @author Tejesh Kumar
    * @description - fillShippingDetails action in Sumamry page for ChangePlanController
    * @input param  - null
    * @return param void
    */ 
	public pageReference fillShippingDetails() {    
		isVisibleSuccessAlert= false;
		if(mainDTO!= null) {
			strFirstName=mainDTO.shippingFname;
			strLastName=mainDTO.shippingLname;
		    strAddress1=mainDTO.shippingAdd1;    
	        strAddress2=mainDTO.shippingAdd2;
	        strCity=mainDTO.shippingCity;
	        strState=mainDTO.shippingState;
	        strZip=mainDTO.shippingZip;
	        strPhone=mainDTO.shippingPhoneUS;   	
		}
		return null;
	}
	
	/**
    * @author Tejesh Kumar
    * @description - SaveShippingDetails action in Sumamry page for ChangePlanController
    * @input param  - null
    * @return null
    */ 
    public  pageReference SaveShippingDetails() {
    	system.debug('----enter save shipping ---');     		
    	if(!AtlasUtility.isEmpty(strFirstName) && !AtlasUtility.isEmpty(strLastName) && !AtlasUtility.isEmpty(strAddress1) && !AtlasUtility.isEmpty(strCity) && !AtlasUtility.isEmpty(strZip) && !AtlasUtility.isEmpty(strPhone)) {
    		strFirstName=strFirstName.trim();
    		strLastName=strLastName.trim();	
    		strAddress1=strAddress1.trim();	
    		strCity=strCity.trim();
    		strState=strState.trim();	
    		strZip=strZip.trim();	
    		if(!AtlasUtility.isEmpty(strAddress2))strAddress2=strAddress2.trim();	
    		
    		strPhone=strPhone.deleteWhitespace();
    		strPhone=strPhone.remove('-');
    		strPhone=strPhone.remove('(');
    		strPhone=strPhone.remove(')');
    		system.debug('---strPhone---> '+strPhone);
    		
    		isVisibleSuccessShipping=true;
    		AtlasTransactionDTO.UpdateCustomerInfoTxDTO custInfoObj = new AtlasTransactionDTO.UpdateCustomerInfoTxDTO(mainDTO.externalAccountReference,mainDTO.externalSystemName,null,strPhone,mainDTO.accountDTOObj.contactEmail, 
                																null,strAddress1,strAddress2,strCity,strState,strZip,null,strFirstName,strLastName,null,AtlasConstants.COUNTRY_CODE,null,null,null,null);	
            try {				
				String result = updateShippingContact(custInfoObj);
				system.debug('---result---> ' + result); 
				if(result=='ACCEPTED') {
					mainDTO.shippingFname=strFirstName;
					mainDTO.shippingLname=strLastName;
				    mainDTO.shippingAdd1=strAddress1;    
			        mainDTO.shippingAdd2=strAddress2;
			        mainDTO.shippingCity=strCity;
			        mainDTO.shippingState=strState;
			        mainDTO.shippingZip=strZip;
			        mainDTO.shippingPhoneUS=strPhone;   	    					
					//isVisibleExceptionMessage=false;
					///hideEmailEditBody= true;
					//isVisibleSuccessAlert= true;
				} 
				else {
					//exceptionString='Contact Email is not saved';
					//isVisibleExceptionMessage=true;
					//isVisibleSuccessAlert= false;  
				}		    		
			} 
			catch(exception e) {
				//isVisibleSuccessAlert= false; 	
			}   		    																 		
    	}
    	//isVisibleSuccessAlert= true;
    	//isVisibleExceptionMessage=false;
    	//exceptionString='';
    	return null;
    }       
          
    /**
    * @author Tejesh Kumar
    * @description - updateEmailFinish action in Sumamry page for ChangePlanController
    * @input param  - null
    * @return null
    */ 
    public  pageReference updateEmailFinish() { 
    	isVisibleSuccessAlert= false;
    	hideEmailEditBody= false;
    	return null;
    }     
    /**
    * @author Tejesh Kumar
    * @description - updateEmailCancel action in Sumamry page for ChangePlanController
    * @input param  - null
    * @return null
    */ 
    public  pageReference updateEmailCancel() { 
    	return null;
    } 
    	           
}