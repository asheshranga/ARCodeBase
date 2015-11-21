/*********************************************************************************
Name         : DealerCPSumCompController (Dealer Change Plan Summary Component Controller)
Created By   : Jim Tunney
Modified By  : 
Company Name : 
Project      : Dealer Portal
Created Date : 10/12/2015
Modified Date: 
Usages       : Controller for VisualForce Component: DealerCPSummaryController
*********************************************************************************/
public with sharing class DealerCPSumCompController {    
    public DealerComponenttoController componentToPage{get; set;}
    
    /***** Note: values contained in the DealerKeyValueStore Custom Settings *****/
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
    public string GBLabel {get {return DealerUtility.getMapValue(DealerConstants.GB);} set;} //displays "GB"    
    public string howFastLabel {get {return DealerUtility.getMapValue(DealerConstants.HowFast);} set;} //displays "How Fast"
    public string howMuchLabel {get {return DealerUtility.getMapValue(DealerConstants.HowMuch);} set;} //displays "How Much"
    public string libertyPassLink {get {return DealerUtility.getMapValue(DealerConstants.CPSummaryLibertyPassLink);} set;} //Provides URL for Liberty Pass hyperlink
    public string libertyPassLinkText {get {return DealerUtility.getMapValue(DealerConstants.CPSummaryLibertyPassLinkText);} set;} //Displays text for Liberty Pass hyperlink
    public string libertyNoDataH5Label {get {return DealerUtility.getMapValue(DealerConstants.CPSummaryLibertyNoDataH5);} set;} //Displays "Estimated Service Performance"(h5)
    public string libertyNoDataImgPath {get {return DealerUtility.getMapValue(DealerConstants.CPSummaryLibertyNoDataImgPath);} set;} //Displays image below Estimated Svc Perf.
    public string newPlanLabel {get {return DealerUtility.getMapValue(DealerConstants.NewPlan);} set;} //Displays "New Plan"(h4)
    public string plusLibertyLabel {get {return DealerUtility.getMapValue(DealerConstants.CPSummaryPlusLiberty);} set;} //Displays "Plus Liberty Pass"
    public string promotionsLabel{get{return DealerUtility.getMapValue(DealerConstants.Promotions);}set;} //displays "Promotions"    
    public string remainingLabel {get {return DealerUtility.getMapValue(DealerConstants.CPSummaryRemainingText);} set;} //Displays "remaining this month"
    public string summaryLabel {get {return DealerUtility.getMapValue(DealerConstants.Summary);} set;} //Displays "Summary"(h1)
    public string usingLibertyMsg {get {return DealerUtility.getMapValue(DealerConstants.CPSummaryUsingLibertyText);} set;} //Displays msg re: using Liberty Pass for rest of month
    
    //boolean for checkbox acknowledging the Terms & Conditions
    public boolean isChecked {get;set;}
    
    //boolean used in logic to highlight submission error in red. Works in tandem with isChecked
    public boolean isSubmit {get;set;}
    
    //boolean used to hide or show submission error alert box and message
    public boolean isError {get;set;}
    
    /**
     * Constructor.
     * Initializes checkbox boolean to false.
    */
    public DealerCPSumCompController() {
        isChecked = false;
        //setIsChecked();
        //setIsError();
        //setIsSubmit();
        isSubmit = false;
        isError = false;
    }
    /**
    public boolean getIsChecked(){
        return componentToPage.isChecked;
    }
    
    public void setIsChecked(){
        componentToPage.isChecked = false;
    } */
    /**
    public boolean getIsError(){
        return componentToPage.isError;
    }
    
    public void setIsError(){
        componentToPage.isError = false;
    }*/
    /**
    public boolean getIsSubmit(){
        return componentToPage.isSubmit;
    }
    
    public void setIsSubmit(){
        componentToPage.isSubmit = false;
    }*/
    
    /**
    * @author Jim Tunney
    * @description - Method for second component's 'Back' button. Sets booleans so that the first component is visible.
    * @input param  - none
    * @return null
    */ 
    public pageReference backButton(){
        isChecked = false;
        isSubmit = false;
        isError = false;
        
        componentToPage.clickedStep = 0;
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
       isSubmit = true;
       if(isChecked) {
        componentToPage.clickedStep = 2;
        componentToPage.CPStep0 = false;
        componentToPage.CPStep1 = false;
        componentToPage.CPStep2 = true;
       }
       else {isError = true;}
        return null;
    }
    
}