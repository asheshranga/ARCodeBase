/*********************************************************************************
Name         : AtlasNewUserController
Created By   : Shiva Shankar Nalluri
Modified BY  : Shiva Shankar Nalluri
Company Name : NTT Data
Project      : ViaSat Atlas, Bangalore
Created Date : 
Modified Date: 
Usages       : Controller for VisualForce Page: AtlasNewUser
*********************************************************************************/
public with sharing class AtlasNewUserController{
    
    public string strTitle{get{ return 'New User';}set;}
    public string accountNumber{get;set;}
    public string MACValue1{get;set;}
    public string MACValue2{get;set;}
    public string MACValue3{get;set;}
    public string MACValue4{get;set;}
    public string MACValue5{get;set;}
    public string MACValue6{get;set;}
    public string phone1{get;set;}
    public string phone2{get;set;}
    public string phone3{get;set;}
    public string emailId{get;set;}
    public string Atlas_NewUser_Action_Status{get{return AtlasUtility.getMapValue(AtlasConstants.Atlas_NewUser_Action_Status);}set;}
    public string Atlas_NewUser_Action_Status1{get{return AtlasUtility.getMapValue(AtlasConstants.Atlas_NewUser_Action_Status1);}set;}
    public string Atlas_NewUser_Action_Status2{get{return AtlasUtility.getMapValue(AtlasConstants.Atlas_NewUser_Action_Status2);}set;}
    public string Atlas_NewUser_Action_Status3{get{return AtlasUtility.getMapValue(AtlasConstants.Atlas_NewUser_Action_Status3);}set;}
    public AtlasComponenttoController componentToPage {get; private set;}
    /**
    * @author Shiva Shankar
    * @description - Constructor for AtlasNewUserController
    * @input param  - null
    * @return null
    */ 
    public AtlasNewUserController(){
        //This code has been written for IE8 Browser Compatibility Issues. 
        Apexpages.currentPage().getHeaders().put(AtlasConstants.X_UA_COMPATIBLE,AtlasConstants.IE_8);
        componentToPage = new AtlasComponenttoController();
        componentToPage.isStep1=true;
        componentToPage.isStep2=false;
        componentToPage.isStep3=false;
        componentToPage.isStep4=false;
        componentToPage.isStep5=false;
    }
}