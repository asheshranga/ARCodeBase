//DTO
public with sharing class AtlasComponenttoController{
    
    //Variables used for New-user setup(1->2->3->4)
    public boolean isStep1{get;set;}
    public boolean isStep2{get;set;}
    public boolean isStep3{get;set;}
    public boolean isStep4{get;set;}
    public boolean isStep5{get;set;}
    //variable -> to store fullname
    public string accountName{get;set;}
     //variable -> to store first name
    public string firstName{get;set;}
     //variable -> to store last name
    public string lastName{get;set;}
    //variable to hold subscriber username
    public string userName{get;set;}
    //variable to hold subscriber pwd
    public string password{get;set;}
    //variable to hold subscriber email
    public string emailId{get;set;}
    //Variables used for Login Help(1->2->3->4)
    public boolean LHStep1{get;set;}
    public boolean LHStep2{get;set;}
    public boolean LHStep3{get;set;}
    public boolean LHStep4{get;set;}
    public boolean LHStep5{get;set;}
    // variable to store subscriber key value
    public long subscriberKey{get;set;}
    public string securityQList{get;set;}
    public string securityQ1{get;set;}
    public string securityQA1{get;set;}
    public string securityQ2{get;set;}
    public string securityQA2{get;set;}
    // variable to store subscriber key value
    public string externalAccReference{get;set;}
    // variable to store subscriber key value
    public string externalSystemName{get;set;}
    // varible to store error message for save security questions.
    public string errorMessage{get;set;}
    //to hold phone number
    public string phone{get;set;}
    //to hold Internal Account Reference
    public string internalAccReference{get;set;}
    //to hold session Id
    public string sessionId{get;set;}
    //to hold counter value
    public integer toatlIncorrect{get;set;}
    //to hold time
    public dateTime timevalue{get;set;}
    //to hold date time used in new user registration history record creation
    public dateTime timeStmap{get;set;}
    //to hold IP Address
    public string IPAddress{get;set;}
    //to hold the new user registration history record Auto Number field
    public string nurhNumber{get;set;}
    //to hold the partner name
    public string partnerName{get;set;}
    
    //Variables used for WISP Admin user search
    public boolean isComp1{get;set;}
    public boolean isComp2{get;set;}
    public boolean isComp3{get;set;}
    public boolean isComp4{get;set;}
    //Variables used in WISP to pass profile Id to components
    public string compProfileId{get;set;}
    //Variables used in WISP to for Sec Ques
    public string wispSecurityQ1{get;set;}
    public string wispSecurityQA1{get;set;}
    public string wispSecurityQ2{get;set;}
    public string wispSecurityQA2{get;set;}
    //Variables used in WispBuyMoreController
    public decimal requestedGB{get;set;}
    public decimal oldGB{get;set;}
    public decimal newGB{get;set;}
    public boolean UsageGBInCorrect{get;set;}
    public integer PollerCount{get;set;}
    //To hold business name from the NewuserIdentification Controller
    public string businessName{get;set;}
    
    //Variables used in Change Plan page
    public boolean selectionPanel{get;set;}
    public boolean summaryPanel{get;set;} 
    public boolean confirmPanel{get;set;}
    public boolean selectionPanelOptions{get;set;}
    public boolean custIssuePanel{get;set;}
    public boolean systemIssuePanel{get;set;}
    public boolean pendingPanel{get;set;}
    public boolean isLiberty{get;set;}
    public String externalTransactionReference {get;set;}
    public AtlasChangePlanDTO.changePlanPackage selectedPlan{get;set;}
    public boolean pendingValidated{get;set;}
    public boolean isSb2plusPlan{get;set;}
     
}