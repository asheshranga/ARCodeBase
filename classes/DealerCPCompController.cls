/*************************************************************************************
Name         : DealerCPCompController (Dealer Change Plan Component Controller)
Created By   : Jim Tunney
Modified By  : 
Company Name : 
Project      : Dealer Portal
Created Date : 4 Nov 2015
Modified Date: 
Usages       : Controller for all four components to the VF page: DealerChangePlanPage.
				Controls DealerCPBreadCrumbComponent, DealerCPSelectPlanComponent,
				DealerCPSummaryComponent, and DealerCPConfirmComponent.
**************************************************************************************/  
public with sharing class DealerCPCompController extends DealerDataManager{   
	
	public DealerComponenttoController componentToPage{get; set;}
	
	// Initializing the Change Plan DTO object   
    public DealerChangePlanDTO changePlanDTOObj{get;set;}
    
    public string selectedPlanName{get;set;}
    
    // Initializing Main DTO 
    public DealerMainDTO mainDTO{get;set;}
    
    // Initializing Account DTO    
    public DealerAccountDTO accountDTO{get;set;} 
    
    /***** Note: values contained in the DealerKeyValueStore Custom Settings *****/ 
	//for DealerCPBreadCrumbComponent
    public string installLabel {get {return DealerUtility.getMapValue(DealerConstants.Installation);} set;} 
    public string plansLabel {get {return DealerUtility.getMapValue(DealerConstants.Plans);} set;}
    public string planOptionsLabel {get {return DealerUtility.getMapValue(DealerConstants.PlanOptions);} set;}
	
	//for DealerCPSelectPlanComponent
	public string availablePlansLabel {get {return DealerUtility.getMapValue(DealerConstants.AvailablePlans);} set;} //displays "Available Plans"(h4)
    public string buttonOrderNowLabel {get {return DealerUtility.getMapValue(DealerConstants.ButtonOrderNow);} set;} //displays "Order Now"
    public string cpSelectPlanAlertBoxHeader {get {return DealerUtility.getMapValue(DealerConstants.CPSelectPlanAlertBoxHeader);} set;} //displays header for blue alert box at bottom of page(h4)
    public string cpSelectPlanAlertBoxMsg1 {get {return DealerUtility.getMapValue(DealerConstants.CPSelectPlanAlertBoxMsg1);} set;} //displays 1st msg in blue alert box at bottom of page
    public string cpSelectPlanAlertBoxMsg2 {get {return DealerUtility.getMapValue(DealerConstants.CPSelectPlanAlertBoxMsg2);} set;} //displays 2nd msg in blue alert box at bottom of page
    public string cpSelectPlanMsgLabel {get {return DealerUtility.getMapValue(DealerConstants.CPSelectPlanMsg);} set;} //displays message that appears above plan selections
    public string GBLabel {get {return DealerUtility.getMapValue(DealerConstants.GB);} set;} //displays "GB"; also used in Summary Component
    public string howFastLabel {get {return DealerUtility.getMapValue(DealerConstants.HowFast);} set;} //displays "How fast"; also used in Summary Component
    public string howMuchLabel {get {return DealerUtility.getMapValue(DealerConstants.HowMuch);} set;} //displays "How much"; also used in Summary Component
    public string MBPSLabel {get {return DealerUtility.getMapValue(DealerConstants.MBPS);} set;} //displays "MBPS"; also used in Summary Component
    public string myCurrentPlanLabel {get {return DealerUtility.getMapValue(DealerConstants.MyCurrentPlan);} set;} //displays "My Current Plan"(h4)
    public string plansLoading{get{return DealerUtility.getMapValue(DealerConstants.PlansLoading);}set;} //displays msg that plans are loading
    public string promotionsLabel{get{return DealerUtility.getMapValue(DealerConstants.Promotions);}set;} //displays "Promotions"; also used in Summary Component
    public string selectNewPlanLabel {get {return DealerUtility.getMapValue(DealerConstants.SelectNewPlan);} set;} //displays "Select a New Plan"(h1)
	
	//for DealerCPSummaryComponent
	public string alertBoxMsg1 {get {return DealerUtility.getMapValue(DealerConstants.CPSummaryPlsNote1);} set;} //Displays 1st msg in blue alert box
    public string alertBoxMsg2 {get {return DealerUtility.getMapValue(DealerConstants.CPSummaryPlsNote2);} set;} //Displays 2nd msg in blue alert box
    public string alreadyUsedLabel {get {return DealerUtility.getMapValue(DealerConstants.CPSummaryAlreadyUsedText);} set;} //Displays "(already used this month)"
    public string buttonBackLabel {get {return DealerUtility.getMapValue(DealerConstants.ButtonBack);} set;} //Displays "Back"
    public string buttonSubChgLabel {get {return DealerUtility.getMapValue(DealerConstants.ButtonSubmitChange);} set;} //Displays "Submit Change"
    public string cpSummaryAlertBoxHeader {get {return DealerUtility.getMapValue(DealerConstants.CPSummaryAlertBoxHeader);} set;} //Displays header (h4) for blue alert box
    public string cpSummaryMidPgHeader {get {return DealerUtility.getMapValue(DealerConstants.CPSummaryMidPgHeader);} set;} //Displays header (h5) for section next to Plan info
    public string cpSummaryPastCapMsg {get {return DealerUtility.getMapValue(DealerConstants.CPSummaryPastCapMsg);} set;} //Displays the Past Cap msg
    public string cpSummaryTopMsg {get {return DealerUtility.getMapValue(DealerConstants.CPSummaryTopMsg);} set;} //Displays msg at top of component, below the h1
    public string disclosuresBoxHeader {get {return DealerUtility.getMapValue(DealerConstants.DisclosuresBoxHeader);} set;} //Displays header (h2) for disclosures box
    public string disclosuresChkboxText {get {return DealerUtility.getMapValue(DealerConstants.DisclosuresChkboxText);} set;} //Displays text next to disclosures checkbox
    public string disclosuresPrintLink {get {return DealerUtility.getMapValue(DealerConstants.DisclosuresPrintLink);} set;} //Provides URL for Print Disclosures hyperlink
    public string disclosuresPrintText {get {return DealerUtility.getMapValue(DealerConstants.DisclosuresPrintText);} set;} //Displays text for Print Disclosures hyperlink
    public string eachMonthLabel {get {return DealerUtility.getMapValue(DealerConstants.CPSummaryEachMonthText);} set;} //Displays "each month (new plan)"
    public string libertyPassLink {get {return DealerUtility.getMapValue(DealerConstants.CPSummaryLibertyPassLink);} set;} //Provides URL for Liberty Pass hyperlink
    public string libertyPassLinkText {get {return DealerUtility.getMapValue(DealerConstants.CPSummaryLibertyPassLinkText);} set;} //Displays text for Liberty Pass hyperlink
    public string libertyNoDataH5Label {get {return DealerUtility.getMapValue(DealerConstants.CPSummaryLibertyNoDataH5);} set;} //Displays "Estimated Service Performance"(h5)
    public string libertyNoDataImgPath {get {return DealerUtility.getMapValue(DealerConstants.CPSummaryLibertyNoDataImgPath);} set;} //Displays image below Estimated Svc Perf.
    public string newPlanLabel {get {return DealerUtility.getMapValue(DealerConstants.NewPlan);} set;} //Displays "New Plan"(h4)
    public string plusLibertyLabel {get {return DealerUtility.getMapValue(DealerConstants.CPSummaryPlusLiberty);} set;} //Displays "Plus Liberty Pass"
    public string remainingLabel {get {return DealerUtility.getMapValue(DealerConstants.CPSummaryRemainingText);} set;} //Displays "remaining this month"
    public string summaryLabel {get {return DealerUtility.getMapValue(DealerConstants.Summary);} set;} //Displays "Summary"(h1)
    public string usingLibertyMsg {get {return DealerUtility.getMapValue(DealerConstants.CPSummaryUsingLibertyText);} set;} //Displays msg re: using Liberty Pass for rest of month
    //boolean for checkbox acknowledging the Terms & Conditions
    public boolean isChecked {get;set;}
    //boolean used in logic to highlight submission error in red. Works in tandem with isChecked
    public boolean isSubmit {get;set;}    
    //boolean used to hide or show submission error alert box and message
    public boolean isError {get;set;}
	
	//for DealerCPConfirmComponent
	public string buttonSignOutLabel {get {return DealerUtility.getMapValue(DealerConstants.ButtonSignOut);} set;}//displays "Sign Out"
    public string confirmationLabel {get {return DealerUtility.getMapValue(DealerConstants.Confirmation);} set;}//displays "Confirmation"
    public string cpConfirmAlertBoxHeader {get {return DealerUtility.getMapValue(DealerConstants.CPConfirmAlertBoxHeader);} set;}//displays header for blue alert box
    public string cpConfirmH4First {get {return DealerUtility.getMapValue(DealerConstants.CPConfirmH4First);} set;}//displays first h4 tag's text
    public string cpConfirmH4Second {get {return DealerUtility.getMapValue(DealerConstants.CPConfirmH4Second);} set;}//displays second h4 tag's text
    public string cpConfirmReceivedMsg {get {return DealerUtility.getMapValue(DealerConstants.CPConfirmReceivedMsg);} set;}//displays msg that change request is received
    public string custCarePhoneLabel {get {return DealerUtility.getMapValue(DealerConstants.CustCarePhone);} set;}//displays customer care phone number
    public string dashLink {get {return DealerUtility.getMapValue(DealerConstants.CPConfirmDashLink);} set;}//provides URL for dashboard hyperlink
    public string dashText {get {return DealerUtility.getMapValue(DealerConstants.CPConfirmDashText);} set;}//displays text for dashboard hyperlink
    public string printLink {get {return DealerUtility.getMapValue(DealerConstants.CPConfirmPrintLink);} set;}//provides URL for print hyperlink
    public string printText {get {return DealerUtility.getMapValue(DealerConstants.CPConfirmPrintText);} set;}//displays text for print hyperlink
	
	
	/**
     * Constructor.
     * 
    */
    public DealerCPCompController() {
    	system.debug('---------------------I AM IN DealerCPCompController CONSTRUCTOR----------------------------------');
        componentToPage = new DealerComponenttoController();
        componentToPage.isLiberty = false;
        componentToPage.isLibertyNoData = false;
        componentToPage.isPastCap = false;
        componentToPage.dataRemainMonth = 0;
        componentToPage.monthlyData = 0;
        
        dataUsedMonth = 10.5;//hard-coded until can pull from customer info    
        
        isPrint = false;
    }    
    
//**************************************************BREAD CRUMB SECTION**************************************************
	//list to hold the String values for the breadcrumbs
    public List<String> bcList = new List<String>();
    
    //size of bcList; used in repeat tag in Bread Crumb Component
    public Integer listSize {get;set;}
	
	/**
     * @author Jim Tunney
     * @description - Getter for the integer clickedStep (declared in class DealerComponenttoController)
     * @input param  - none
     * @return componentToPage.clickedStep - integer
    */ 
   public integer getClickedStep(){
        return componentToPage.clickedStep;
    }
    
    /**
     * @author Jim Tunney
     * @description - Creates a List containing the breadcrumb Strings from the comma-separated list 'BreadCrumbChange' in the DealerKeyValueStore Custom Setting
     * @input param  - none
     * @return bcList - List of Strings
    */ 
    public List<String> getBCList(){
        bcList.clear();
        String s = DealerUtility.getMapValue('BreadCrumbChange');
        String[] sList = s.split(',');
        
        for(integer i = 0; i < sList.size(); i++){
            bcList.add(sList[i]);
        }
        listSize = bcList.size();
        
        return bcList; 
    }
    
    /**
    * @author Jim Tunney
    * @description - Sets booleans so that the first step (Select Plan) component is visible.
    * @input param  - none
    * @return null
    */ 
    public pageReference step0(){
        componentToPage.isChecked = false;
        componentToPage.isSubmit = false;
        componentToPage.isError = false;
          
        componentToPage.clickedStep = 0;
        system.debug('**------------@@@@--------------------->clickedStep '+ componentToPage.clickedStep);
        componentToPage.CPStep0 = true;
        componentToPage.CPStep1 = false;
        componentToPage.CPStep2 = false;

        return null; 
    }
    
    /**
    * @author Jim Tunney
    * @description - Sets booleans so that the second step (Plan Summary) component is visible.
    * @input param  - none
    * @return null
    */ 
    //11/13/15: NOTE: step1() may not be necessary b/c cannot click to step 0 from step 2 or step 1, and no need to click to second step from itself
    public pageReference step1(){
    	//Can only click back to beginning once final step (step2) is reached 
        if (componentToPage.clickedStep == 2){
            return null;
        }
        componentToPage.isChecked = false;
        componentToPage.isSubmit = false;
        componentToPage.isError = false; 
        
        componentToPage.clickedStep = 1;
        componentToPage.CPStep0 = false;
        componentToPage.CPStep1 = true;
        componentToPage.CPStep2 = false;
        return null;
    }
    
    /**
    * @author Jim Tunney
    * @description - Sets booleans so that the third step (Confirmation) component is visible.
    * @input param  - none
    * @return null
    */ 
    public pageReference step2(){
        componentToPage.clickedStep = 2;
        componentToPage.CPStep0 = false;
        componentToPage.CPStep1 = false;
        componentToPage.CPStep2 = true;
        
        return null;
    }
    
    /**
    * @author Jim Tunney
    * @description - Not used (as of 10/28/15); anticipated future use
    * @input param  - none
    * @return null
     
    public pageReference step3(){
        componentToPage.clickedStep = 3;
        componentToPage.CPStep0 = false;
        componentToPage.CPStep1 = false;
        componentToPage.CPStep2 = true;
        
        return null;
    }*/
	
//**************************************************SELECT PLAN SECTION**************************************************
    public  AtlasPlan__c myPlan{get{
        String serviceLevel;
        if(!Test.isRunningTest())
            //serviceLevel=accountDTO.serviceLevel;//************uncomment once APIs all up and running************
            serviceLevel='EVOLUTION 20 GB';//hard-coded for testing; delete once APIs up and running
        else
            serviceLevel='FREEDOM';
        //query to return plan attributes from Atlas Plan object
        List<AtlasPlan__c> myPlanList = [SELECT datacapgb__c, downloadspeed__c, downloadspeedunit__c, freezonetype__c, 
        								uploadspeed__c, addldataallow__c, thresholds__c, voiceadapter__c, wirelessrtr__c
        FROM AtlasPlan__c
        WHERE PlanAPIName__c =: serviceLevel LIMIT 1]; 
        system.debug('--myPlanList --> '+myPlanList );
        if(myPlanList.size() > 0)
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
    
    public string myUploadSpeed{get {     
        if(myPlan!=null)
            return myPlan.UploadSpeed__c;
        else
            return null;    
    } set;} 
    
    public string myAddlDataAllow{get {     
        if(myPlan!=null)
            return myPlan.AddlDataAllow__c;
        else
            return null;    
    } set;} 
    
    public string myThresholds{get {     
        if(myPlan!=null)
            return myPlan.Thresholds__c;
        else
            return null;    
    } set;} 
    
    public string myFreeZone{get {     
        if(myPlan!=null)
            return myPlan.FreezoneType__c;
        else
            return null;    
    } set;} 
    
    public string myVoiceAdapter{get {     
        if(myPlan!=null)
            return myPlan.VoiceAdapter__c;
        else
            return null;    
    } set;} 
    
    public string myWirelessRtr{get {     
        if(myPlan!=null) 
            return myPlan.WirelessRtr__c;
        else
            return null;    
    } set;} 
    
    public List<AtlasPlanAttributes__c> myBonusFeatures{get {
        return null;
    }set;} 
        
    /** TBD if used for Dealer Portal
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
    }set;}  */
    
    
    /**
    * @author Jim Tunney
    * @description - Method for first component's 'Order Now' button. Sets booleans so that the second component is visible.
    * @input param  - none
    * @return null
    */ 
    public pageReference orderNow() {
        system.debug('**------------@@@@--------------------->mainDTO.changePlanDTOObj.changePlanPackages '+ mainDTO.changePlanDTOObj.changePlanPackages);
        system.debug('----FROM DlrCPCompCtrlr ->orderNow()------@@@@----------------------------------componentToPage.CPStep0= '+componentToPage.CPStep0);
        
        setSelectedPlan();
        setIsLiberty();
        setDataRemainMonth();
        setIsLibertyNoData();
        
        system.debug('----FROM DlrCPCompCtrlr ->orderNow()------@@@@----------------------------------componentToPage.isLiberty= '+componentToPage.isLiberty);
        system.debug('----FROM DlrCPCompCtrlr ->orderNow()------@@@@----------------------------------dataRemainMonth= '+componentToPage.dataRemainMonth);
        system.debug('----FROM DlrCPCompCtrlr ->orderNow()------@@@@----------------------------------isLibertyNoData= '+componentToPage.isLibertyNoData);
        
        componentToPage.isChecked = false;
        componentToPage.isSubmit = false;
        componentToPage.isError = false; 
        componentToPage.clickedStep = 1;
        componentToPage.CPStep0 = false;
        componentToPage.CPStep1 = true;
        componentToPage.CPStep2 = false;
        
        return null;
    }
    
    /**
    *  @author Jim Tunney
    *  @description - Sets page level var selectedPlan based on data in DealerChangePlanDTO. selectedPlan is used for display on Summary component.
    *				  Calls setMonthlyData()
    *  @param none
    *  @return void
    */
    private void setSelectedPlan() {
        for(DealerChangePlanDTO.changePlanPackage plan: mainDTO.changePlanDTOObj.changePlanPackages) {
            system.debug('--plan--> '+plan);
            if(selectedPlanName.toLowercase() == plan.planName.toLowercase()) {
                componentToPage.selectedPlan=plan;
            }
        }
        setMonthlyData();
    }
    
    /**
    *  @author Jim Tunney
    *  @description - Sets boolean isLiberty based on info retrieved from AtlasPlan__c
    *  @param none
    *  @return void
    */
    private void setIsLiberty() {
    	// To identify the Liberty Plans
        Set<String> AtlasPlansSet = new Set<String>();
        List<AtlasPlan__c> atlasPlans = [select Id,PlanAPIName__c,IsLibertyPlan__c FROM  AtlasPlan__c WHERE IsLibertyPlan__c=TRUE];
             for(AtlasPlan__c ap : atlasPlans){
                 AtlasPlansSet.add(ap.PlanAPIName__c.toLowerCase());
             }
        string servicePlan= componentToPage.selectedPlan.planName;
        if(!AtlasUtility.isEmpty(servicePlan) && AtlasPlansSet.contains(servicePlan.toLowercase())){
            componentToPage.isLiberty=true; }    
    }
    
    /**
    *  @author Jim Tunney
    *  @description - Sets page level var dataRemainMonth = difference of the new plan's monthly data and how much data the customer has remaining 
    *				  for the month, or Zero, whichever is greater. Also sets boolean isPastCap based on the remaining data and if customer 
    *				  currently has a Liberty plan.
    *  @param none
    *  @return void
    */
    private void setDataRemainMonth() {
    	//***NEED LOGIC TO RETRIVE dataUsedMonth FROM CUSTOMER'S ACCOUNT***
        if(componentToPage.monthlyData > dataUsedMonth){
            componentToPage.dataRemainMonth = componentToPage.monthlyData - dataUsedMonth; 
        }
        else {
            componentToPage.dataRemainMonth = 0;//Can't go negative on remaining data
            componentToPage.isPastCap = componentToPage.isLiberty ? false : true;//Only non-Liberty plan holders see the 'past data capacity' msg 
            system.debug('----FROM DlrCPCompCtrlr ->setDataRemainMonth()------@@@@----------------------------------dataRemainMonth= '+componentToPage.dataRemainMonth);
        }
    }
    
    /**
    *	@author Jim Tunney
    *	@description - Sets boolean isLibertyNoData based on if it is a Liberty plan and if the customer has data remaining for the month.
    *				   ifLibertyNoData is true if it is a Liberty plan and the customer has no remaining monthly data.
    *	@param none
    *	@return void
    */
    private void setIsLibertyNoData(){
    	system.debug('----FROM DlrCPCompCtrlr ->setIsLibertyNoData()------@@@@----------------------------------isLiberty= '+componentToPage.isLiberty);
    	system.debug('----FROM DlrCPCompCtrlr ->setIsLibertyNoData()------@@@@----------------------------------dataRemainMonth= '+componentToPage.dataRemainMonth);
        if(componentToPage.isLiberty && (componentToPage.dataRemainMonth <= 0)){
            componentToPage.isLibertyNoData = true;
        }
        else {componentToPage.isLibertyNoData = false;}
    }
    
    /**
    *  @author Jim Tunney
    *  @description - Sets page level var dataRemainMonth = difference of monthlyData and dataUsedMonth, or Zero, whichever is greater. Also
    *				  sets boolean isPastCap based on value of dataRemainMonth and if customer currently has a Liberty plan.
    *  @param none
    *  @return void
    */
    private void setMonthlyData() {
    	if(componentToPage.selectedPlan!=null) {
    		componentToPage.monthlyData = componentToPage.selectedPlan.dataCapacity;
    	}
    	else {componentToPage.monthlyData = 0;}
    }
    
	
//**************************************************SUMMARY SECTION**************************************************
	//used for rendering text on Liberty-data page
    //public boolean isLibertyData{get;set;}
    
    //used for rendering text/image on Liberty-no-data page
    //public boolean isLibertyNoData{get;set;}
    
    //used to determine if Summary Past Cap msg is displayed	
    //public boolean isPastCap{get;set;} 
    
    //public double dataRemainMonth{get;set;} //difference of monthlyData and dataUsedMonth, or Zero, whichever is greater

    //public double monthlyData{get;set;} //***hard coded (in Constructor) until can be pulled from customer's info***
    
    public double dataUsedMonth{get;set;} //***hard coded (in Constructor) until can be pulled from customer's info***
    
	/**
    * @author Jim Tunney
    * @description - Method for second component's 'Back' button. Sets booleans so that the first component is visible.
    * @input param  - none
    * @return null
    */ 
    public pageReference backButton(){
        componentToPage.isChecked = false;
        componentToPage.isSubmit = false;
        componentToPage.isError = false;
        
        componentToPage.clickedStep -= componentTopage.clickedStep;
        componentToPage.CPStep0 = true;
        componentToPage.CPStep1 = false;
        componentToPage.CPStep2 = false;
        return null;
    }
   
    /**
    * @author Jim Tunney
    * @description - Method for second component's 'Submit Changes' button. Sets booleans so that the third(final) component is visible.
    * @input param  - none
    * @return null
    */ 
    public pageReference submitChange(){
        
        componentToPage.isSubmit = true;
        
        system.debug('**------------@@@@--------------------->isChecked'+ isChecked); 
        if(componentToPage.isChecked) {   
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
                if(!(errorCode == 'Success' && OrderStatus == 'Accepted')){                                
                    //system.debug('--plan changed successfully---> '); 
                    if(!AtlasUtility.isEmpty(mainDTO.externalAccountReference)) 
                        AtlasDatabaseManager.insertTransaction('Change Plan','Change Plan','Change Plan Transition','Success','',mainDTO.accountNo);  
                    
                    //--- Ashesh changes to above insert transaction to pass account no instead of external account reference. But for SB2+ QA deployment is before Ashesh changes deployment,
                    //--- so use the below statement for SB2+ migration and let Ashesh know
                    //AtlasDatabaseManager.insertTransaction('Change Plan','Change Plan','Change Plan Transition','Success','',mainDTO.externalAccountReference);     
                    
                    /**componentToPage.selectionPanel=false;
                        componentToPage.summaryPanel=false;
                        componentToPage.confirmPanel=true;*/   
                    componentToPage.clickedStep = 2;
                    componentToPage.CPStep0 = false;
                    componentToPage.CPStep1 = false;
                    componentToPage.CPStep2 = true;
                    string servicePlan= componentToPage.selectedPlan.planName;              
                    mainDTOObj.accountDTOObj.serviceLevel = servicePlan;                                 
                }
                else{
                    /**componentToPage.selectionPanel=true;
                    componentToPage.summaryPanel=false;
                    componentToPage.confirmPanel=false;
                    componentToPage.selectionPanelOptions=false;
                    componentToPage.systemIssuePanel=true;*/
                }  
                
                //return null; 
            }
            catch(Exception e){
                //return null;
            }
        }
        else {
            componentToPage.isError = true;
            System.debug('**------------@@@@--------------------->isError'+ isError); 
            
            //return null;
        }
        
        return null;
    }
    
    public string textFromLegalDisclosures {
    	get {
    		StaticResource sr = [
    		select Body
    		from StaticResource
    		where Name = 'DealerLegalDisclosures' 
    		];
    	return sr.Body.toString();
    	}
    }
	
//**************************************************CONFIRMATION SECTION**************************************************
	//NO METHODS FOR CONFIRMATION COMPONENT AS OF 11/4/2015
	public boolean isPrint{get;set;}
	
	public void clickPrint() {
		isPrint = true;
	}

}