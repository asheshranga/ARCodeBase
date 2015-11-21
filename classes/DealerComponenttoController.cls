public with sharing class DealerComponenttoController {
    // variables used for login help reset password step1,2,3,4
    public boolean LHStep1{get;set;}
    public boolean LHStep2{get;set;}
    public boolean LHStep3{get;set;}
    public boolean LHStep4{get;set;}
    //variable to hold dealer username
    public string userName{get;set;}
    //variables to hold security questions and answers
    public string securityQ1{get;set;}
    public string securityQA1{get;set;}
    public string securityQ2{get;set;}
    public string securityQA2{get;set;}
    public string securityQ3{get;set;}
    public string securityQA3{get;set;}
    //variable to hold dealer password
    public string password{get;set;}
    
    //variables used for breadcrumb trail (change plan)
    public boolean CPStep0{get;set;}
    public boolean CPStep1{get;set;}
    public boolean CPStep2{get;set;}
    public integer clickedStep{get;set;}//used for both trails
    //variables used for breadcrumb trail (new order & move)
    public boolean OrderStep0{get;set;}
    public boolean OrderStep1{get;set;}
    public boolean OrderStep2{get;set;}
    public boolean OrderStep3{get;set;}
    public boolean OrderStep4{get;set;}
    public boolean OrderStep5{get;set;}
    public boolean OrderStep6{get;set;}
    public boolean OrderStep7{get;set;}
    public boolean confirmation{get;set;}
    
    //***********Change Plan page variables*************
    //boolean for checkbox acknowledgement
    public boolean isChecked {get;set;}    
    //boolean used in logic to highlight submission error in red. Works in tandem with isChecked
    public boolean isSubmit {get;set;}
    //boolean used to hide or show submission error alert box and message
    public boolean isError {get;set;}
    //boolean to indicate if Customer has a Liberty Plan (for Change Plan Pages)
    public boolean isLiberty{get;set;}
    //booleans to indicate if a Liberty Customer has data remaining for the month (for Change Plan Pages)
    public boolean isLibertyData{get;set;}
    public boolean isLibertyNoData{get;set;}
    //boolean to indicate if a non-Liberty Customer is past monthly data cap (for Change Plan Pages)
    public boolean isPastCap{get;set;}
    //variable to hold selected plan for Change Plan
    public DealerChangePlanDTO.changePlanPackage selectedPlan{get;set;}
    //variable to hold data remaining in current month (for Change Plan Pages)
    public double dataRemainMonth{get;set;}
    //variable to hold the new plan's monthly data allowance (for Change Plan Pages)
    public double monthlyData{get;set;}  
    public String externalTransactionReference {get;set;}
    
    //variables for Dealer Settings Pg
    public boolean isResetPW{get;set;}
    public boolean isResetSecQuest{get;set;}
    public boolean isResetDTV{get;set;}
    
    //Remove once new API's are built
    public long subscriberKey{get;set;}
    public string securityQList{get;set;}
}