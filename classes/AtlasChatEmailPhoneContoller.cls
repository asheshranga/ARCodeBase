/*********************************************************************************
Name         : AtlasChatEmailPhoneController 
Created By   : NTT Data
Modified BY  : 
Company Name : NTT Data
Project      : ViaSat Atlas, Bangalore
Created Date : 25 October2013
Usages       : Controller for VisualForce Component : AtlasChatEmailPhoneComponent
*********************************************************************************/
public with sharing class AtlasChatEmailPhoneContoller{
    public String strChatURL{get{return AtlasUtility.getURL(AtlasConstants.CHAT);}set;}
    public String strPhoneURL{get{return AtlasUtility.getURL(AtlasConstants.PHONE);}set;}
    public String strEmailURL{get{return AtlasUtility.getURL(AtlasConstants.EMAIL);}set;}
    public String strChatText{get{return AtlasUtility.getHyperLinkText(AtlasConstants.CHAT);}set;}
    public String strPhoneText{get{return AtlasUtility.getHyperLinkText(AtlasConstants.PHONE);}set;}
    public String strEmailText{get{return AtlasUtility.getHyperLinkText(AtlasConstants.EMAIL);}set;}
    public Boolean isChatVisible{get{return AtlasUtility.getVisibility(AtlasConstants.CHAT);}set;}
    public Boolean isPhoneVisible{get{return AtlasUtility.getVisibility(AtlasConstants.PHONE);}set;}
    public Boolean isEmailVisible{get{return AtlasUtility.getVisibility(AtlasConstants.EMAIL);}set;}
    public String customerCareNumberLabel{get{return AtlasUtility.getHyperLinkText(AtlasConstants.customerCareNumberLabel);}set;}
    
    //Added By Praveen Bala 11/11/2015
    public static User userObj{get;set;}
    public static Contact conObj{get;set;}
    public string firstnameValue { get; set; }   
    public string lastnameValue { get; set; }    
    public string phoneValue { get; set; }   
    public string emailValue { get; set; }  
    public string productValue { get; set; }
    public string validationValue { get; set; }
    public string helpValue { get;  set; }
    
    public Boolean productEntered {get {return (productValue != null && productValue != 'All'); }}  

    /**
    * @author Raghuprasad Halakere
    * @description - Zero paramter AtlasChatEmailPhoneContoller constructor 
    * @input param  - null
    * @return null 
    */
 public AtlasChatEmailPhoneContoller(){
    Apexpages.currentPage().getHeaders().put(AtlasConstants.X_UA_COMPATIBLE,AtlasConstants.IE_8); 
    //Added By Praveen Bala 11/11/2015
    
     
    }

    public Case newCase { get; set; }
    public String newCaseId { get; set; }
    
    public void CreateCase() { 
    
        string userId = UserInfo.getUserID();
    
    if(!Test.isRunningTest()) {
          if(AtlasUtility.isAdmin())  // if user is an authorized Admin and the query string is populated, set the userId to the passed parameter.
              if(!AtlasUtility.isEmpty(Apexpages.currentPage().getParameters().get('Id'))) 
                  userId = Apexpages.currentPage().getParameters().get('Id');
                  
                  System.debug('@@@@UserId@@@@@'+userId);
    }
        System.debug('******User Id'+userId);
    userObj = [Select Id,contactId from User where User.Id=:userId];
    conObj = [Select Id,Name,firstName,lastName,Email,Phone from Contact where Id =: userObj.contactId];
    
    System.debug('***Contact Id****'+conObj.Id);
    firstNameValue = conObj.firstName;
    lastNameValue = conObj.lastName;
    phoneValue = conObj.Phone;
    emailValue = conObj.Email;     
        
        newCase = new Case();
        RecordType rt = [SELECT Id FROM RecordType WHERE Name = 'Denver Care' AND sObjectType = 'Case'];
        newCase.RecordTypeId = rt.Id;
        newCase.Origin = 'Care - Chat';
        newCase.ContactId = conObj.id;
        newCase.Subject = 'Public Chat';
        newCase.Description = 'A New Customer Chat Case has been Created';
        newCase.Status = 'New';    
        insert newCase;        
        newCaseId = newCase.Id;                
        
        System.debug('New Case:' + newCase);
    }
    
}