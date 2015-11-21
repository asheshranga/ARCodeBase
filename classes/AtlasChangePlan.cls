/*********************************************************************************
Name         : AtlasChangePlan 
Created By   : Nalluri Shivashankar
Modified BY  : Rahul Kumar Sharma
Company Name : NTT Data
Project      : ViaSat Atlas, Bangalore
Created Date : 20 October 2013
Modified Dtae: 15 November 2013
Usages       : Controller for component: AtlasChangePlan
*********************************************************************************/
public with sharing class AtlasChangePlan{
    
    public string strTermsConditions{get{return AtlasUtility.getMapValue(AtlasConstants.TERMS_AND_CONDITIONS);}set;}
    public string strPackages{get{return AtlasUtility.getMapValue(AtlasConstants.PACKAGES);}set;}
    public string strOptions{get{return AtlasUtility.getMapValue(AtlasConstants.OPTIONS);}set;}
    public string strOption1{get{return AtlasUtility.getMapValue(AtlasConstants.OPTION1);}set;}
    public string strOption2{get{return AtlasUtility.getMapValue(AtlasConstants.OPTION2);}set;}
    public string strOption3{get{return AtlasUtility.getMapValue(AtlasConstants.OPTION3);}set;}
    public string strOption4{get{return AtlasUtility.getMapValue(AtlasConstants.OPTION4);}set;}
    public string strOption5{get{return AtlasUtility.getMapValue(AtlasConstants.OPTION5);}set;}
    public string strComments{get{return AtlasConstants.COMMENTS;}set;}
    public string denverWebcase{get{return AtlasUtility.getMapValue(AtlasConstants.CASE_RECORD_TYPE_NAME);}set;}
    public Case caseObj{get;set;}
    public Boolean isSuccess{get;set;}
    public Boolean isFailure{get;set;}
    public string errormsg{get;set;}
    public boolean refreshPage{get;set;}
    public string validatemessage{get;set;}
    public boolean validateFailed{get;set;}
    public string successMessage{get;set;}
    public string requestedPlanLabel{get{return AtlasConstants.CP_REQUESTED_PLAN_LABEL;}set;}
    public string sendRequestlabel{get{return AtlasConstants.CP_SEND_REQUEST;}set;}
    public string processingLabel{get{return AtlasConstants.CP_PROCESSING;}set;} 
    public AtlasMainDTO mainDTOObj{get;set;}
    public string strChangePlanTC1{get{return AtlasUtility.getMapValue(AtlasConstants.CP_TC1);}set;}
    public string strChangePlanTC2{get{return AtlasUtility.getMapValue(AtlasConstants.CP_TC2);}set;}
    public string strChangePlanTC3{get{return AtlasUtility.getMapValue(AtlasConstants.CP_TC3);}set;}
    public string strChangePlanTC1Cont{get{return AtlasUtility.getMapValue(AtlasConstants.CP_TC1CONT);}set;}
    public string strChangePlanTC2Cont{get{return AtlasUtility.getMapValue(AtlasConstants.CP_TC2CONT);}set;}    
    public string strChangePlanTC3Cont{get{return AtlasUtility.getMapValue(AtlasConstants.CP_TC3CONT);}set;}
    public string webPhone{get{return AtlasConstants.CP_WEB_PHONE;}set;}    
    
    /**
    * @author Raghuprasad Halakere
    * @description - Zero parameter AtlasChangePlan constructor
    * @input param  - null
    * @return null
    */ 
    public void clearSuccessMessage()
    {
        isSuccess=false;
    }
    /**
    * @author Raghuprasad Halakere
    * @description - Zero parameter AtlasChangePlan constructor
    * @input param  - null
    * @return null
    */ 
    public AtlasChangePlan()
    {
         caseObj=new case(); 
         isSuccess=false;
         isFailure=false;
         refreshPage=false;
         validatefailed=false;
    }
    /**
    * @author Shiva Shankar 
    * @description - saveWebToCaseRequest for Changeplan
    * @param object null
    * @return null
    */
    public PageReference saveWebToCaseRequest()
    {
        try{
            if(caseObj.Requested_Plan__c==''||caseObj.Requested_Plan__c==AtlasUtility.getMapValue(AtlasConstants.OPTIONS)){validateFailed=true;
                validatemessage=AtlasUtility.getMapValue(AtlasConstants.CP_VALIDATE_PLAN);
                return null;}
            
            else{
                validateFailed=false;
                validatemessage='';}
            caseObj.ContactId=mainDTOObj.ContactId;
            caseObj.Category__c=AtlasUtility.getMapValue(AtlasConstants.CHANGE_PLAN_CATEGORY);
            caseObj.CategoryDetails__c=AtlasUtility.getMapValue(AtlasConstants.CHANGE_PLAN_DETAILS);
            caseObj.Subject=AtlasUtility.getMapValue(AtlasConstants.CHANGE_PLAN_SUBJECT)+' '+mainDTOObj.accountDtoObj.strAccountName;
            caseObj.SuppliedName=mainDTOObj.accountDtoObj.strAccountName;
            caseObj.SuppliedEmail=mainDTOObj.accountDtoObj.contactemail;
            caseObj.SuppliedPhone=mainDTOObj.accountDtoObj.phonemobile;
            caseObj.RecordTypeId=Schema.SObjectType.Case.getRecordTypeInfosByName().get(AtlasUtility.getMapValue(AtlasConstants.CASE_RECORD_TYPE_NAME)).getRecordTypeId();
            caseObj.OwnerId=AtlasDatabaseManager.getGroupIdForCaseCreation();     
            caseObj.Origin=AtlasUtility.getMapValue(AtlasConstants.CHANGE_PLAN_CASE);
            
            // As per new requirement, current plan is added in case object record.
            caseObj.Current_Plan__c = mainDTOObj.accountDtoObj.serviceLevel;
                    
            insert caseObj;
            isSuccess=true;
            successMessage=AtlasUtility.getMapValue(AtlasConstants.CP_SUCCESS);
            isFailure=false;
            refreshPage=true;
            return null;
        }catch(Exception e)
        {
            isSuccess=false;
            isFailure=true;
            validateFailed=false;
            validatemessage='';
            errormsg=AtlasUtility.getMapValue(AtlasConstants.CP_ERROR_MSG);
        }
        return null;
    }
}