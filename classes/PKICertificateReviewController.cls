/*********************************************************************************
Name         : PKICertificateReviewController
Created By   : Shiva Shankar Nalluri
Modified BY  : Poornima Ramachandrachar
Company Name : NTT Data
Project      : ViaSat Atlas, Bangalore
Created Date : 
Modified Date: 
Usages       : Controller for VisualForce Page: PKICertificateReview
*********************************************************************************/
public with sharing class PKICertificateReviewController {
    
    //Variables used for the page.
    
    // External variables
public SObject myObject {get; set;}
public Integer recordLimit {get; set;}
public static String objectLabel {get;}

// Internal Variables
//public objectHistoryLine[] objectHistory; 

public static final Map<String, Schema.SObjectType> mySObjectTypeMap = Schema.getGlobalDescribe();
public static Map<String, Schema.SObjectField> myObjectFieldMap;
public static List<Schema.PicklistEntry> historyFieldPicklistValues;



    //to insert/update L/C reuest
    public PKI_License_and_Certificate_Request__c lcrObj {get; set;}
    //Variables used get the record history(cretaed by/date).
    public List<PKI_License_and_Certificate_Request__c> lstLCRHistory{get; set;}
    //to store submitHelpTxt   
    public boolean submitHelpTxt{get;set;} 
    //to store OtherStatus
    public boolean OtherStatus{get;set;}
    //to store logged in user profiledetail
    public boolean profiledetail{get;set;}
    //to store L/C request Status
    public boolean lcrStatus{get;set;}
    //to store L/C Request Id
    public String orderId;
    //to store view mode or edit mode
    public boolean viewmode{get;set;}
    //to show exception/validation fail message.
    public String errorMessage;
    //to get list of mac address for LCR Id
    public List<MAC_Address__c> macAddlines{get;set;}
    //to store macAddObj
    public MAC_Address__c macAddObj{get;set;}
    //to call toggleSort
    public PageReference toggleSort () {return null;}
    //to store sortField
    public String sortField{get;set;}
    //to store logged in user addrees-street
    public string address1{get;set;}
    //to store logged in user addrees-country
    public string city{get;set;}
    //to store logged in user addrees-city
    public string state{get;set;}
    //to store logged in user addrees-country
    public string country{get;set;}
    //to store logged in user addrees-zip
    public string zip{get;set;}
    //to store logged in user addrees-phone
    public string phone{get;set;}
    //to store logged in user addrees-email
    public string email{get;set;}
    //to store logged in user addrees-account Name
    public string accName{get;set;}
    //to store logged in user addrees-contact Name
    public string conName{get;set;}
    //to store logged in user addrees-product Name
    public string prodName{get;set;}
    
    /**
    * @author Shiva Shankar
    * @description - Constructor
    * @input param  - null
    * @return null
    */
    public PKICertificateReviewController(ApexPages.StandardController controller)
    
    {   
     myObject = new PKI_License_and_Certificate_Request__c();
    // to get LCR id form the page URL
        orderId = ApexPages.currentPage().getParameters().get('id');
        if(ApexPages.currentPage().getParameters().get('viewmode')!=null)
           viewmode=boolean.valueof(ApexPages.currentPage().getParameters().get('viewmode'));
        lcrObj= new PKI_License_and_Certificate_Request__c();
        User user=new User();   
        String uid=UserInfo.getProfileId();    
        submitHelpTxt = false;
        OtherStatus=False;
        profiledetail=True;
        macAddlines = getMACAddressLines(orderId); 
        Profile prof=[SELECT Name FROM Profile where id =: uid];
        
        // if lcr id is available to get all required fields to show in the review page.
        if(orderId != null && orderId != '')
        { 
            lcrObj = [select name,Account__c,Requestor__c,Phone__c,Custom_Product__c,Email__c,Shipping_Address__c,Shipping_City_Name__c,Shipping_State_Name__c,Shipping_Zip_Name__c,
                Shipping_Country_Name__c,Status__c,owner.Name,Software_Version__c,Downloadable__c,Deliver_on_Disk__c,Email_Address1__c,Electronic_Delivery__c,Requestor_Name__c,Account_Name__c,Shipping_Address_Name__c,
                Email_Address2__c,Shipping_Address_Line_1__c,Shipping_Address_Line_2__c,Shipping_City__c,Shipping_State__c,Shipping_Country__c,Postal_Code__c,MAC_IDs_Entered__c
                from PKI_License_and_Certificate_Request__c where id =: orderId];
            address1=lcrObj.Shipping_Address_Name__c;
            city=lcrObj.Shipping_City_Name__c;
            state=lcrObj.Shipping_State_Name__c;
            zip=lcrObj.Shipping_Zip_Name__c;
            country=lcrObj.Shipping_Country_Name__c;
            accName=lcrObj.Account_Name__c;
            conName=lcrObj.Requestor_Name__c;
                if(lcrObj.Status__c ==Label.PKI_Certificate_Request_Pending_Submission_Label)
                {  
                    lcrStatus=true;
                    submitHelpTxt=true;
                }
                else 
                {  
                    lcrStatus=false;
                    submitHelpTxt=false;
                }
            //query to get record history details.     
            //lstLCRHistory=[SELECT CreatedBy.Name,CreatedDate FROM PKI_License_and_Certificate_Request__c where id=:orderId]; 
            lstLCRHistory = [SELECT CreatedBy.Name,CreatedDate ,Id,(select oldValue,NewValue FROM histories),Name from PKI_License_and_Certificate_Request__c where id=:orderId];   
        }
    }
    /**
    * @author Shiva Shankar
    * @description - To Edit License/request
    * @input param  - null
    * @return Edit Mode
    */
    public PageReference edit()
    {   // to upuadte the L/C request on click of edit button fron=m the review page only when status=='Paending Submission.'
        if (orderId != null && orderId != '')
        {
            pagereference pag = new pagereference(Label.PKI_Certificate_Request_URL+'?id='+lcrObj.id+'&viewmode=false');
            pag.setredirect(true);
            return pag;
        }
        else
            return null;
    } 
    /**
    * @author Shiva Shankar
    * @description - To Create New LCR Request
    * @input param  - null
    * @return Edit Mode
    */
    public PageReference createnew() 
    {   // to create new request when click create new request button.
        pagereference pag= new pagereference(Label.PKI_Certificate_Request_URL);
        pag.setredirect(true);
        return pag;
    }
    /**
    * @author Shiva Shankar
    * @description - To submit LCR Request
    * @input param  - null
    * @return View Mode
    */
    public PageReference save()
    {   // to save/update the L/C request.
        Schema.DescribeSObjectResult Orderobj = Schema.SObjectType.PKI_License_and_Certificate_Request__c;
        try
        {
            if (orderId != null && orderId != '')
            {

                update lcrObj;
                                  
                if (lcrObj.status__c == Label.PKI_Certificate_Request_Pending_Submission_Label)
                {     
                    pagereference pag= new pagereference(Label.PKI_Certificate_Request_URL+'?id='+lcrObj.id+'&viewmode=false');
                    pag.setredirect(true);
                    return pag;
                }
                else
                {
                    pagereference pag= new pagereference(Label.PKI_Certificate_Request_URL+'?id='+lcrObj.id+'&viewmode=true');
                    pag.setredirect(true);
                    return pag;
                }
            }
        }    
            
        catch(exception e)
        {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Ooops! ' + e.getDmlMessage(0)));
            return null;
        }
        return null;   
    }
    /**
    * @author Shiva Shankar
    * @description - To submit LCR Request
    * @input param  - null
    * @return null
    */
    public PageReference submit()
    {   // return null when click on submit button in the review page.
        return null;
    }
    /**
    * @author Shiva Shankar
    * @description - To get requested licenses
    * @input param  - LCR Id
    * @return List<MAC_Address__c>
    */
    private List<MAC_Address__c> getMACAddressLines(String asId)
    { 
    //------- Added for unchecking checked order line item for deletion
        list<MAC_Address__c> delunchecklist= new list<MAC_Address__c>();
        list<MAC_Address__c> Temp= new list<MAC_Address__c>();
        //list of MAC Address for one LCR Id.
        delunchecklist = [Select Id, name,MAC_Address__c,Certificate_Type__c,License_Type__c,Comments__c,Marked_For_Deletion__c,Server_Serial__c
                          from MAC_Address__c 
                        where License_and_Certificate_Request__c = :asId order by CreatedDate];
        //Processing the delunchecklist to make Marked_For_Deletion__c =false
        for(MAC_Address__c objMacAdd : delunchecklist)
        {
            if(objMacAdd.Marked_For_Deletion__c == true)
                objMacAdd.Marked_For_Deletion__c = false;
            Temp.add(objMacAdd);      
        }
        return Temp;
    }
    /**
    * @author Poornima Ramachandrachar
    * @description - To get history details of the record
    * @input param  - LCRId
    * @return list<PKI_License_and_Certificate_Request__c>
    */
    public List<objectHistoryLine> getObjectHistory(){

    Id myObjectId = orderId;
    Schema.DescribeSObjectResult objectDescription = myObject.getSObjectType().getDescribe();
    
    myObjectFieldMap = objectDescription.fields.getMap();
    objectLabel = String.valueOf(objectDescription.getLabel());
    
    //Get the name of thew history table
    String objectHistoryTableName = objectDescription.getName();
    //if we have a custom object we need to drop the 'c' off the end before adding 'History' to get the history tables name
    if (objectDescription.isCustom()){
        objectHistoryTableName = objectHistoryTableName.substring(0, objectHistoryTableName.length()-1);
    }
    objectHistoryTableName = objectHistoryTableName + 'History';
    
    Schema.DescribeFieldResult objectHistoryFieldField = mySObjectTypeMap.get(objectHistoryTableName).getDescribe().fields.getMap().get('Field').getDescribe();
    historyFieldPicklistValues = objectHistoryFieldField.getPickListValues();
    
    list<objectHistoryLine> objectHistory = new list<objectHistoryLine>();
    
    String prevDate = '';
    
    if (recordLimit== null){
        recordLimit = 100;
    }
    
    list<sObject> historyList = Database.query( 'SELECT CreatedDate,'+
    'CreatedById,'+
    'Field,'+
    'NewValue,'+
    'OldValue ' +
    'FROM ' + objectHistoryTableName + ' ' +
    'WHERE ParentId =\'' + myObjectId + '\' ' +
    'ORDER BY CreatedDate DESC '+
    'LIMIT ' + String.valueOf(recordLimit));
    
    for(Integer i = 0; i < historyList.size(); i++){
    sObject historyLine = historyList.get(i);
    if ((historyLine.get('newValue') == null && historyLine.get('oldValue') == null) 
    || (historyLine.get('newValue') != null && !(string.valueOf(historyLine.get('newValue')).startsWith('001') || string.valueOf(historyLine.get('newValue')).startsWith('00G')))
    || (historyLine.get('oldValue') != null && !(string.valueOf(historyLine.get('oldValue')).startsWith('001') || string.valueOf(historyLine.get('oldValue')).startsWith('00G')))){
    objectHistoryLine tempHistory = new objectHistoryLine();
    // Set the Date and who performed the action
    if (String.valueOf(historyLine.get('CreatedDate')) != prevDate){
        tempHistory.theDate = Datetime.valueOf(historyLine.get('CreatedDate')).format();
        tempHistory.userId = String.valueOf(historyLine.get('CreatedById'));
        tempHistory.who = String.valueOf(historyLine.get('CreatedById'));
    }
    else{
        tempHistory.theDate = null;
        tempHistory.who = '';
        tempHistory.userId = String.valueOf(historyLine.get('CreatedById'));
    }
    prevDate = String.valueOf(historyLine.get('CreatedDate'));
    
    // Get the field label
    String fieldLabel = PKICertificateReviewController.returnFieldLabel(String.valueOf(historyLine.get('Field')));
    
    // Set the Action value
    if (String.valueOf(historyLine.get('Field')) == 'created') { // on Creation
        tempHistory.action = 'Created.';
    }
    else if (historyLine.get('oldValue') != null && historyLine.get('newValue') == null){ // when deleting a value from a field
        // Format the Date and if there's an error, catch it and re
        try {
            tempHistory.action = 'Deleted ' + Date.valueOf(historyLine.get('oldValue')).format() + ' in <b>' + fieldLabel + '</b>.';
        } 
        catch (Exception e){
            tempHistory.action = 'Deleted ' + String.valueOf(historyLine.get('oldValue')) + ' in <b>' + fieldLabel + '</b>.';
        }
    }
    else{ // all other scenarios
        String fromText = '';
        if (historyLine.get('oldValue') != null && !(String.valueOf(historyLine.get('oldValue')).StartsWith('003')|| String.valueOf(historyLine.get('oldValue')).StartsWith('001'))) {
            try {
                fromText = ' from ' + Date.valueOf(historyLine.get('oldValue')).format();
            } 
            catch (Exception e) {
                fromText = ' from ' + String.valueOf(historyLine.get('oldValue'));
        }
    }
    
    String toText = '';
    if (historyLine.get('oldValue') != null && !(String.valueOf(historyLine.get('oldValue')).StartsWith('003')|| String.valueOf(historyLine.get('oldValue')).StartsWith('001'))) {
        try {
            toText = Date.valueOf(historyLine.get('newValue')).format();
        } 
        catch (Exception e) {
            toText = String.valueOf(historyLine.get('newValue'));
        }
        }
        if (toText != '' && fromText != ''){
            tempHistory.action = 'Changed <b>' + fieldLabel + '</b>' + fromText + ' to <b>' + toText + '</b>.';
        }
        if (toText != ''){
            tempHistory.action = 'Changed <b>' + fieldLabel + '</b>' + fromText + ' to <b>' + toText + '</b>.';
        }
    }
    
    // Add to the list
    if(tempHistory != null && tempHistory.action != null)
        objectHistory.add(tempHistory);
    }
    }
    
    List<Id> userIdList = new List<Id>();
    for (objectHistoryLine myHistory : objectHistory){
        userIdList.add(myHistory.userId);
    }
    Map<Id, User> userIdMap = new Map<ID, User>([SELECT Name FROM User WHERE Id IN : userIdList]);
    
    for (objectHistoryLine myHistory : objectHistory){
        if (userIdMap.containsKey(myHistory.userId) & (myHistory.who != '') ){
            myHistory.who = userIdMap.get(myHistory.who).Name;
        }
    }
    
    return objectHistory;
    } 
    
    // Function to return Field Label of a object field given a Field API name
    public Static String returnFieldLabel(String fieldName){
    
        if (PKICertificateReviewController.myObjectFieldMap.containsKey(fieldName)){
        return PKICertificateReviewController.myObjectFieldMap.get(fieldName).getDescribe().getLabel();
        }
        else {
            for(Schema.PicklistEntry pickList : historyFieldPicklistValues){
                if (pickList.getValue() == fieldName){
                    if (pickList.getLabel() != null){
                        return pickList.getLabel();
                    }
                    else {
                    return pickList.getValue();
                    }
                }
            }
        }
        return '';
    }
    
    // Inner Class to store the detail of the object history lines 
    public class objectHistoryLine {    
    public String theDate {get; set;}
    public String who {get; set;}
    public Id userId {get; set;} 
    public String action {get; set;}
    }
}