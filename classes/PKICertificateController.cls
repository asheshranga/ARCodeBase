/*********************************************************************************
Name         : PKICertificateController
Created By   : Shiva Shankar Nalluri
Modified BY  : 
Company Name : NTT Data
Project      : ViaSat Atlas, Bangalore
Created Date : 
Modified Date: 
Usages       : Controller for VisualForce Page: PKICertificate
*********************************************************************************/
public class PKICertificateController
{
   
    public static string Id{get;set;}
    //Variables used for the page.
    ApexPages.StandardController controller;
    // Variable to save or update L/C request
    public PKI_License_and_Certificate_Request__c lcrObj {get;set;}
    public PKI_License_and_Certificate_Request__c lcrObjOnLoad;    
    //to insert/update mac address
    public List<MAC_Address__c> macAddlines{get;set;}
    // to add macaddress in to the list
    public MAC_Address__c macAddObj{get;set;}
    // commemnted for future use.
   // public Address__c objAddress{get;set;}
   //to store logged in user addrees-street
    public string address1{get;set;}
    //to store logged in user addrees-city
    public string city{get;set;}
    //to store logged in user addrees-state
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
    //to store isEditMode
    public boolean isEditMode{get;set;}
    //to store isInSufficientPrivileges
    public static boolean isInSufficientPrivileges{get;set;}
    //to store logged in user addrees-street
    public integer fileSize{get;set;}
    // notes and attachments
    Transient Public Attachment myfile;
    List<MAC_Address__c> macAddressOnLoad = new List<MAC_Address__c>(); 
    //to show errormessage if exception/validation fails.
    private String errorMessage;
    public final string LCR_SUBMIT_TEXT='Submitted';
    //List of MAC Address to delete  selected rows.   
    public List<MAC_Address__c> macAddressLinedelete = new List<MAC_Address__c>();
    public boolean editLCR {get {return (editLCR == null) ? true:false;} set;}    
    public String accountName {get {return (accountName == null) ? lcrObj.account__r.name:accountName;} set;}
    public String accountId {get {return (accountId == null) ? lcrObj.account__c:accountId;} set;}
    
    public id userid;
    
    public boolean NoPermissionToSave = false;
    //--- For checkbox selection and remove lines    
    public Boolean lineUnchecked {get {return false;} set;}    
    public String linesSelected {get;set;}
    public string linesUnSelected{get;set;}
    
     List<MAC_Address__c> macAddressNew    = new List<MAC_Address__c>();          
     List<MAC_Address__c> macAddressUpdate = new List<MAC_Address__c>();
     set<MAC_Address__c> macAddressUpsertSet;
     
     public user userObj;
         
     Public Attachment getmyfile()
    {   // Initializing Attachment object.
        myfile = new Attachment();
        return myfile;
    }
    //to display list of attachments
    public List<Attachment> getlistattachments()
    {   //Grouping the attachments in to list depending on LCR Id.
        List<Attachment> listattachments = [Select CreatedBy.Name,Id,LastModifiedDate,Name,ParentId from Attachment where parentid =: lcrObj.id]; 
        return listattachments;
    }
    
    /**
    * @author Poornima Ramachandrachar
    * @description - To navigate the user to LCR list view page after click of Cancel button
    * @input param  - null
    * @return Page reference
    */
    
    //To Navigate the user to LCR list view page after click of Cancel button
    public PageReference cancel() {
        //Create a new instance of Page reference 
        PageReference loRMAPage = new PageReference(Label.PKI_Certificate_Request_URL);
        //Get the Id of the current record
        loRMAPage.getParameters().put('id',Id);
        //Setting Page redirect to true
        loRMAPage.setredirect(true);
        //return the instance of Page reference
        return loRMAPage;
    }
    
    
    /**
    * @author Poornima Ramachandrachar
    * @description - To populate the mailing and shipping address after the Requestor field is filled
    * @input param  - null
    * @return Page reference
    */
    public pageReference populateRequestorDetail(){
        //Check if Requestor field is populated
        if (lcrObj != null && lcrObj.Requestor__c !=null) 
            {
                //Create a new instance of Contact record
                Contact con = new Contact();
                //Query the contact record corresponding to Requestor
                con = [select  MailingStreet, MailingState, MailingPostalCode, MailingCountry, MailingCity, Id, AccountId,Account.Name,phone,email,Name from Contact where Id =: lcrObj.Requestor__c];
                //Map the fields with the corresponding queried values
                conName=con.Name;
                phone=con.Phone;
                email=con.Email;
                address1=con.MailingStreet;
                city=con.MailingCity;
                state=con.MailingState;
                zip=con.MailingPostalCode;
                country=con.MailingCountry;
                
                //Map the shipping address details with the queried values
                if(lcrObj.Shipping_Address_Line_1__c == null){
                    lcrObj.Shipping_Address_Line_1__c = con.MailingStreet;
                }                    
                if(lcrObj.Shipping_City__c == null){
                    lcrObj.Shipping_City__c = con.MailingCity;
                }
                if(lcrObj.Shipping_State__c == null){
                    lcrObj.Shipping_State__c = con.MailingState;
                }
                if(lcrObj.Shipping_Country__c == null){
                    lcrObj.Shipping_Country__c = con.MailingCountry;
                }
                if(lcrObj.Postal_Code__c == null){
                    lcrObj.Postal_Code__c = con.MailingPostalCode;
                }
                if(lcrObj.Email_Address1__c == null){
                    lcrObj.Email_Address1__c = con.Email;
                }  
        }//End of IF block
        //return null
        return null;
    }
 
 /**
    * @author Shiva Shankar
    * @description - To check if the record is not saved before Returning to the list.
                     If so, display an error message. Else navigate the user to LCR view page 
    * @input param  - string
    * @return boolean
    */
    public PageReference returToList()
    {       
        PageReference result = null;
        
        //Get the MAC addressed of the current record
        if(controller.getRecord() != null && controller.getRecord().id != null){
            macAddressOnLoad = getMACAddressLines(controller.getRecord().id);
        }
        else if(lcrObj.Id != null){
            macAddressOnLoad = getMACAddressLines(lcrObj.id); 
        } 
          
        List<MAC_Address__c> macAddressEnteredLst = new List<MAC_Address__c>();
        //Call a method to see if Requested License rows have been added and data is entered in them
        if(processReqLicenses() != null)
            //Add the newly added rows to a list
            macAddressEnteredLst.addAll(processReqLicenses());
        // to show the prompt message if the record is not saved when click on return to list button.
        
        checkPermitToSave();
        if(NoPermissionToSave == false){
            if(lcrObj.id==null)
            {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR,Label.PKI_Certificate_Request_Validation_Save));
            } 
            
            //To show the prompt message if the record is not saved when software version is modified
            else if((lcrObjOnLoad != null && lcrObj != null)&&(lcrObj.Software_Version__c != lcrObjOnLoad.Software_Version__c)){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR,Label.PKI_Certificate_Request_Validation_Save));
                
            }
            
            //To show the prompt message if the record is not saved when any of the fields in the form are modified and the form is not saved
            else if((lcrObjOnLoad != null && lcrObj != null)&&(lcrObj.Requestor__c != lcrObjOnLoad.Requestor__c) ||(lcrObj.Status__c != lcrObjOnLoad.Status__c)||(lcrObj.Software_Version__c != lcrObjOnLoad.Software_Version__c)
            ||(lcrObj.Deliver_on_Disk__c != lcrObjOnLoad.Deliver_on_Disk__c)
            ||((lcrObj.Shipping_Address__c != null && (lcrObj.Shipping_Address__c != lcrObjOnLoad.Shipping_Address__c)) || (lcrObj.Shipping_Address__c == null && lcrObjOnLoad.Shipping_Address__c != null))
            ||(lcrObj.Downloadable__c != lcrObjOnLoad.Downloadable__c)
            ||((lcrObj.Email_Address1__c != null && (lcrObj.Email_Address1__c != lcrObjOnLoad.Email_Address1__c)) || (lcrObj.Email_Address1__c == null && lcrObjOnLoad.Email_Address1__c != null))
            ||((lcrObj.Email_Address2__c != null && (lcrObj.Email_Address2__c != lcrObjOnLoad.Email_Address2__c)) || (lcrObj.Email_Address2__c == null && lcrObjOnLoad.Email_Address2__c != null))
            ||((lcrObj.Electronic_Delivery__c != null && (lcrObj.Electronic_Delivery__c != lcrObjOnLoad.Electronic_Delivery__c)) || (lcrObj.Electronic_Delivery__c == null && lcrObjOnLoad.Electronic_Delivery__c != null))
            ||((lcrObj.Shipping_Address_Line_1__c != null && (lcrObj.Shipping_Address_Line_1__c != lcrObjOnLoad.Shipping_Address_Line_1__c)) || (lcrObj.Shipping_Address_Line_1__c == null && lcrObjOnLoad.Shipping_Address_Line_1__c != null))
            ||((lcrObj.Shipping_Address_Line_2__c != null && (lcrObj.Shipping_Address_Line_2__c != lcrObjOnLoad.Shipping_Address_Line_2__c)) || (lcrObj.Shipping_Address_Line_2__c == null && lcrObjOnLoad.Shipping_Address_Line_2__c != null))
            ||((lcrObj.Shipping_State__c != null && (lcrObj.Shipping_State__c != lcrObjOnLoad.Shipping_State__c)) || (lcrObj.Shipping_State__c == null && lcrObjOnLoad.Shipping_State__c != null))
            ||((lcrObj.Postal_Code__c != null && (lcrObj.Postal_Code__c != lcrObjOnLoad.Postal_Code__c)) || (lcrObj.Postal_Code__c == null && lcrObjOnLoad.Postal_Code__c != null))
            ||((lcrObj.Shipping_Country__c != null && (lcrObj.Shipping_Country__c != lcrObjOnLoad.Shipping_Country__c)) || (lcrObj.Shipping_Country__c == null && lcrObjOnLoad.Shipping_Country__c != null))){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR,Label.PKI_Certificate_Request_Validation_Save));
                
            }
            //To show an error message if no Requested License record is added
            else if(lcrObj == null && macAddressEnteredLst.IsEmpty() && macAddressOnLoad.IsEmpty()){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR,label.PKI_Certificate_Request_License_Required));
            }
            //To show an error message if existing Requested License records are deleted and no new ones are added
            else if(macAddressEnteredLst.IsEmpty() && !macAddressOnLoad.IsEmpty()){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR,label.PKI_Certificate_Request_License_Required));
            }
            //To show an error message if a new Requested License record is added    
            else if(!macAddressEnteredLst.IsEmpty() && macAddressEnteredLst.size() != macAddressOnLoad.size()){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR,Label.PKI_Certificate_Request_Validation_Save));
            }
            //To show an error message if any change is made to existing Requested License record
            else if(!macAddressEnteredLst.IsEmpty() && (macAddressEnteredLst.size() == macAddressOnLoad.size())){
                for(MAC_Address__c mac1 : macAddressEnteredLst){
                    for(MAC_Address__c mac2 : macAddressOnLoad){
                        
                        String Comments1 = (mac1.Comments__c == null) ? '' : mac1.Comments__c.trim();
                        String Comments2 = (mac2.Comments__c == null) ? '' : mac2.Comments__c.trim();
                        
                        String macAdd1 = (mac1.MAC_Address__c == null) ? '' : mac1.MAC_Address__c.trim();
                        String macAdd2 = (mac2.MAC_Address__c == null) ? '' : mac2.MAC_Address__c.trim();
                        
                        String certType1 = (mac1.Certificate_Type__c == null) ? '' : mac1.Certificate_Type__c.trim();
                        String certType2 = (mac2.Certificate_Type__c == null) ? '' : mac2.Certificate_Type__c.trim();
                        
                        String lType1 = (mac1.License_Type__c == null) ? '' : mac1.License_Type__c.trim();
                        String lType2 = (mac2.License_Type__c == null) ? '' : mac2.License_Type__c.trim();
                        
                        String serialNum1 = (mac1.Server_Serial__c == null) ? '' : mac1.Server_Serial__c.trim();
                        String serialNum2 = (mac2.Server_Serial__c == null) ? '' : mac2.Server_Serial__c.trim();
    
                        if((mac1.Id == mac2.Id)&& (((Comments1 != '' && Comments1 != Comments2) ||(Comments1 != '' &&  Comments2 == '')) 
                        ||((macAdd1 != '' && macAdd1 != macAdd2) ||(macAdd1 != '' &&  macAdd2 == '')) 
                        ||((certType1 != '' && certType1 != certType2) ||(certType1 != '' &&  certType2 == ''))
                        ||((lType1 != '' && lType1 != lType2) ||(lType1 != '' &&  lType2 == ''))
                        ||((serialNum1 != '' && serialNum1 != serialNum2) ||(serialNum1 != '' &&  serialNum2 == '')))){
                        
                            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR,Label.PKI_Certificate_Request_Validation_Save+'5'));
                            return null;
                        }    
                        else {
                            result = new PageReference(label.PKI_Certificate_Request_Return_To_List_URL);
                            result.setRedirect(true);
                        }
                    }
                }
            }
            else{
                result = new PageReference(label.PKI_Certificate_Request_Return_To_List_URL);
                result.setRedirect(true);
            }
        }
        //redirecting to list when click on return to list button.
        else
        {
            result = new PageReference(label.PKI_Certificate_Request_Return_To_List_URL);
            result.setRedirect(true);
        }
        errorMessage = null;
        return result;
                      
    }
    
    /**
    * @author Shiva Shankar
    * @description - to getlist of lcr details
    * @input param  - LCRId
    * @return list<PKI_License_and_Certificate_Request__c>
    */
    private PKI_License_and_Certificate_Request__c getMacAddress(String asId)
    {   // return list of PKI_License_and_Certificate_Request__c depending on LCR Id
        return [select Id, name,Account__c,Requestor__c,Phone__c,Email__c,Shipping_Address__c,Status__c,Custom_Product__c,owner.Name,Software_Version__c,Downloadable__c,Deliver_on_Disk__c,Email_Address1__c,Electronic_Delivery__c,
               Email_Address2__c,Shipping_Address_Line_1__c,Shipping_Address_Line_2__c,Shipping_City__c,Shipping_State__c,Shipping_Country__c,Shipping_Address_Name__c,Shipping_City_Name__c,Postal_Code__c,Shipping_State_Name__c,
                Shipping_Zip_Name__c,Shipping_Country_Name__c
                from PKI_License_and_Certificate_Request__c
                where Id = :asId];
    }
    /**
    * @author Shiva Shankar
    * @description - To get getMACAddressLines
    * @input param  - LCRId
    * @return list<PKI_License_and_Certificate_Request__c>
    */
    private List<MAC_Address__c> getMACAddressLines(String asId)
    {   //list of MAC Address to delete selected rows
        list<MAC_Address__c> delunchecklist= new list<MAC_Address__c>();
        //list of MAC Address for one LCR Id.
        list<MAC_Address__c> Temp= new list<MAC_Address__c>();
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
    * @author Shiva Shankar
    * @description - Constructor for PKICertificateController
    * @input param  - null
    * @return null
    */
    public PKICertificateController(ApexPages.StandardController stdController)
    {                   
      controller = stdController;        
      
      //to get LCR Object record Id.
      lcrObj = (PKI_License_and_Certificate_Request__c)controller.getRecord();
      Id = lcrObj.Id;
      isInSufficientPrivileges=false;
        //Get the data from the existing record
        if (lcrObj != null && lcrObj.id != null)
            {
             lcrObj = getMacAddress(controller.getRecord().id); 
             lcrObjOnLoad = getMacAddress(controller.getRecord().id);
             isEditMode=true;
             phone=lcrObj.Phone__c;
             email=lcrObj.Email__c;
             address1=lcrObj.Shipping_Address_Name__c;
             city=lcrObj.Shipping_City_Name__c;
             state=lcrObj.Shipping_State_Name__c;
             zip=lcrObj.Shipping_Zip_Name__c;
             country=lcrObj.Shipping_Country_Name__c;
             rediretToViewPage();
            }     
        //Initializing LCR Object
        else{
            lcrObj = new PKI_License_and_Certificate_Request__c();
            isEditMode=false;
            lcrobj.Status__c=Label.PKI_Certificate_Request_Pending_Submission_Label;
        }   
         
        userId= userInfo.getUserId();
        macAddObj=new MAC_Address__c();
        macAddlines = new List<MAC_Address__c >();
        macAddlines.addAll(getMACAddressLines(lcrObj.id));
        
        if(userId!=null)
        {
            //Get the details of the contact and map it to corresponding fields
            userObj=[select name,contactid,email from User where id = :userId];
            if (userObj.contactid!=null) 
                {
                    Contact con = new Contact();
                    con = [select  MailingStreet, MailingState, MailingPostalCode, MailingCountry, MailingCity, Id, AccountId,Account.Name,phone,email,Name from Contact where Id =: userObj.contactid];
                    lcrObj.Account__c=con.AccountId;
                    accName=con.Account.Name;
                    lcrObj.Requestor__c=con.Id;
                    conName=con.Name;
                    phone=con.Phone;
                    email=con.Email;
                    address1=con.MailingStreet;
                    city=con.MailingCity;
                    state=con.MailingState;
                    zip=con.MailingPostalCode;
                    country=con.MailingCountry;
                    
                    if(lcrObj.Shipping_Address_Line_1__c == null){
                        lcrObj.Shipping_Address_Line_1__c = con.MailingStreet;
                    }
                    if(lcrObj.Shipping_City__c == null){
                        lcrObj.Shipping_City__c = con.MailingCity;
                    }
                    if(lcrObj.Shipping_State__c == null){
                        lcrObj.Shipping_State__c = con.MailingState;
                    }
                    if(lcrObj.Shipping_Country__c == null){
                        lcrObj.Shipping_Country__c = con.MailingCountry;
                    }
                    if(lcrObj.Postal_Code__c == null){
                        lcrObj.Postal_Code__c = con.MailingPostalCode;
                    }
                    if(lcrObj.Email_Address1__c == null){
                        lcrObj.Email_Address1__c = con.Email;
                    }
               }        
        }
        
        getLines(false);   
    }
    
    
    /**
    * @author Shiva Shankar
    * @description - To getLines
    * @input param  - Boolean
    * @return null
    */
    public void getLines() {
        getLines(true);
    }
    /**
    * @author Shiva Shankar
    * @description - To getLines
    * @input param  - Boolean
    * @return null
    */
    public void getLines(Boolean abSave)
    { 
         if (abSave){ 
            //Add rows to Requested license if requested
            for (integer j=1;j<=5;j++) {
                    MAC_Address__c objMacAdd = new MAC_Address__c();
                    objMacAdd.License_and_Certificate_Request__c=lcrObj.Id;
                    objMacAdd.Certificate_Type__c = '';
                    objMacAdd.License_Type__c = '';
                    macAddlines.add(objMacAdd);
            }   
         }
            // Add requested License rows if there are no rows at all
            if(macAddlines.IsEmpty()){                                                                     
                for (integer j=1;j<=5;j++) {
                    MAC_Address__c objMacAdd = new MAC_Address__c();
                    objMacAdd.Certificate_Type__c = '';
                    objMacAdd.License_Type__c = '';
                    objMacAdd.License_and_Certificate_Request__c=lcrObj.Id;
                    macAddlines.add(objMacAdd);
                }
            }   
    }
    
    /**
    * @author Shiva Shankar
    * @description - To removeLines
    * @input param  - null
    * @return null
    */
    public  void removeLines() 
    {
        Boolean RowsMarkedForDeletion = false;
            list<MAC_Address__c> deletelist= new list<MAC_Address__c>();
            if(!macAddlines.isEmpty() && macAddlines.size() == 1 && macAddlines[0].Marked_For_Deletion__c == true){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, label.PKI_Certificate_Request_License_Required));
                
            }
            else {
                integer i=0;
                while (i<macAddlines.size()){
                    if(macAddlines[i].Marked_For_Deletion__c == true){
                        if(macAddlines[i].Id != null){
                            deletelist.add(macAddlines[i]);
                         }
                         macAddlines.remove(i);
                         RowsMarkedForDeletion = true;
                    }
                    else{
                        i++;
                    }    
                }
                if(RowsMarkedForDeletion == false){
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, label.PKI_Certificate_Request_Validation_Remove_Selected));
                }
               
            }
            if(macAddlines.isEmpty())
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, label.PKI_Certificate_Request_License_Required));
                
                
            else if(!deletelist.IsEmpty() && !macAddlines.isEmpty())
                delete deletelist;
                    
        
        // to save the LCR Request
            saveLCR();
            
        //return null;
        /*if(lcrObj.id != null){
            PageReference loReadPage = new PageReference(Label.PKI_Certificate_Request_URL+'?scontrolCaching=1&sfdc.override=1&retURL=%2F'+lcrObj.id+'&id='+lcrObj.id);
            return loReadPage.setRedirect(true);
         }
         else
             return null;*/
    }
    
    /**
    * @author Shiva Shankar
    * @description - To import csv file
    * @input param  - null
    * @return null
    */
    public PageReference uploadLines()
    {
        // to save the LCR Request when click on import button
        saveLCR();
        if (errorMessage != null) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, errorMessage));
            return null;
        }
        else{
            PageReference loUploadPage = new PageReference(Label.PKI_Certificate_Request_Return_MAC_Address_URL);
            loUploadPage.getParameters().put('lcrId',lcrObj.id);
            return loUploadPage.setRedirect(false); 
        }      
    }
        
    /**
    * @author Shiva Shankar
    * @description - To save the lcr and mac address
    * @input param  - null
    * @return null
    */    
    public PageReference save() {
    
        // to save the LCR Request and save attachment when click on save button.
        saveLCR();
        savedoc();
        
        if (errorMessage !=null) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, errorMessage));
            return null;
        }else{
            
            PageReference loReadPage = new PageReference('/'+lcrObj.id);
            return null;
            //return loReadPage.setRedirect(true);           
        }
    }
    
    public void checkPermitToSave(){
    errorMessage = null;
    if(userObj.contactid != null){
        if(lcrObjOnLoad != null && lcrObjOnLoad.status__c == Label.PKI_Certificate_Request_Status_Approved){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,Label.PKI_Certificate_Request_Validation_Approved_Request));
            errorMessage= Label.PKI_Certificate_Request_Validation_Approved_Request;
            NoPermissionToSave = true;
            return;
        }
        if(lcrObjOnLoad != null && lcrObjOnLoad.status__c == Label.PKI_Certificate_Request_Status_Cancelled){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,Label.PKI_Certificate_Request_Validation_Cancelled_Request));
            errorMessage= Label.PKI_Certificate_Request_Validation_Cancelled_Request;
            NoPermissionToSave = true;
            return;
            }
        if(lcrObjOnLoad != null && lcrObjOnLoad.status__c == Label.PKI_Certificate_Request_Status_Closed){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,Label.PKI_Certificate_Request_Validation_Closed_Request));
            errorMessage= Label.PKI_Certificate_Request_Validation_Closed_Request;
            NoPermissionToSave = true;
            return;
        }
        if(lcrObjOnLoad != null && lcrObjOnLoad.status__c == Label.PKI_Certificate_Request_Status_Completed){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,Label.PKI_Certificate_Request_Validation_Completed_Request));
            errorMessage= Label.PKI_Certificate_Request_Validation_Completed_Request;
            NoPermissionToSave = true;
            return;
        }
    }    
    }
    /**
    * @author Shiva Shankar
    * @description - saveRMA
    * @input param  - null
    * @return null
    */
    public void saveLCR()
    {
        try{
            errorMessage = null;
            checkPermitToSave();
            if(NoPermissionToSave == true){
                return;    
            }
                if(lcrObj.Account__c==null){
                    errorMessage=Label.PKI_Certificate_Request_Validation_Account;
                    return;
                }
                if(lcrObj.Requestor__c==null){errorMessage=Label.PKI_Certificate_Request_Validation_Requestor;return;}
                if(lcrObj.Custom_Product__c==null){errorMessage=Label.PKI_Certificate_Request_Validation_Product;return;}
                if(lcrObj.Software_Version__c==null || lcrObj.Software_Version__c==''){errorMessage=Label.PKI_Certificate_Request_Validation_SW;return;}
                if(lcrObj.Downloadable__c==true && (lcrObj.Email_Address1__c==''||lcrObj.Email_Address1__c==null))
                {
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,Label.PKI_Certificate_Request_Validation_Email1));
                    errorMessage=Label.PKI_Certificate_Request_Validation_Email1;
                    return;
                }
                if(lcrObj.Downloadable__c ==true && (lcrObj.Email_Address2__c==''||lcrObj.Email_Address2__c==null))
                {
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,Label.PKI_Certificate_Request_Validation_Email2));
                    errorMessage=Label.PKI_Certificate_Request_Validation_Email2;
                    return;
                }
                if(lcrObj.Deliver_on_Disk__c==true && (string.isEmpty(lcrObj.Shipping_Address_Line_1__c) || String.isEmpty(lcrObj.Shipping_City__c) || String.isEmpty(lcrObj.Shipping_State__c) || String.isEmpty(lcrObj.Shipping_Country__c) || lcrObj.Postal_Code__c==null))
                {
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,Label.PKI_Certificate_Request_Validation_Shipping));
                    errorMessage=Label.PKI_Certificate_Request_Validation_Shipping;
                    return;
                }
                if(lcrObj.Email_Address1__c==lcrObj.Email_Address2__c)
                {
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,Label.PKI_Certificate_Request_Validation_Email1_2));
                    errorMessage=Label.PKI_Certificate_Request_Validation_Email1_2;
                    return;
                } 
                if(lcrObj.Downloadable__c == false && lcrObj.Deliver_on_Disk__c== false)
                {
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,Label.PKI_Certificate_Request_Validation_CheckBoxes));
                    errorMessage=Label.PKI_Certificate_Request_Validation_CheckBoxes;
                    return;
                } 
            //if new request. 
            if (lcrObj.id == null){
                lcrObj.Status__c=Label.PKI_Certificate_Request_Pending_Submission_Label;                            
                insert lcrObj;
                lcrObj = getMacAddress(lcrObj.id);
                lcrObjOnLoad = getMacAddress(lcrObj.id);
                phone=lcrObj.Phone__c;
                email=lcrObj.Email__c;
                address1=lcrObj.Shipping_Address_Name__c;
                city=lcrObj.Shipping_City_Name__c;
                state=lcrObj.Shipping_State_Name__c;
                zip=lcrObj.Shipping_Zip_Name__c;
                country=lcrObj.Shipping_Country_Name__c;
                
                
                
            }
            // to update existing request. 
            
            
            else{                   
                update lcrObj;  
                lcrObj = getMacAddress(lcrObj.Id);  
                lcrObjOnLoad = getMacAddress(lcrObj.id);        
            }
            //--- Now add the Lines only if MAC Address is provided.
            List<MAC_Address__c> macAddressUpsertLst = new List<MAC_Address__c>();
            String serverSerial;
            String macAddress;
            String certificateType;
            String licenseType;
            boolean lbLineError = false;
            macAddressUpsertSet = new set<MAC_Address__c>();
            // processing the List Mac address to insert / update/ delete.
            for (MAC_Address__c objMacAdd: macAddlines) 
            {
                serverSerial = (objMacAdd.Server_Serial__c == null) ? '':objMacAdd.Server_Serial__c.trim();
                macAddress   = (objMacAdd.MAC_Address__c == null) ? '':objMacAdd.MAC_Address__c.trim();
                certificateType = (objMacAdd.Certificate_Type__c == null) ? '':objMacAdd.Certificate_Type__c.trim();
                licenseType = (objMacAdd.License_Type__c == null) ? '' : objMacAdd.License_Type__c.trim();
                
                objMacAdd.License_and_Certificate_Request__c   = lcrObj.id;

                if (serverSerial.equals('') && (macAddress.equals('')) && (certificateType.equals('')) && (licenseType.equals(''))) {
                    
                    macAddressLinedelete.add(objMacAdd);
                }               
                else if ((serverSerial.equals('')) || (macAddress.equals(''))){
                    lbLineError = true;                   
                    errorMessage=Label.PKI_Certificate_Request_Validation_MAC_Address5;
                    return;    
                }
                else if ((!serverSerial.equals('')) && (!macAddress.equals(''))) 
                {
                                                         
                    if(!macAddress.equals('') && !isMacValid(macAddress))
                    {
                        errorMessage=Label.PKI_Certificate_Request_Validation_MAC_Address1;
                        return;
                    }
                    if (certificateType.equals('') && licenseType.equals('')) {
                        lbLineError = true;
                        errorMessage=Label.PKI_Certificate_Request_Validation_MAC_Address4;
                        return;
                    } 
                    else{
                      //--- Add the line to be inserted or updated to a set
                        macAddressUpsertSet.add(objMacAdd);
                      } 
                }
              } 
            
            if (lbLineError) {
                errorMessage = Label.PKI_Certificate_Request_Validation_MAC_Address2;
                return; 
            }
            
            //To throw an error message if there are no entries for Requested License 
            if(macAddressUpsertSet.isEmpty()){
                errorMessage = Label.PKI_Certificate_Request_License_Required;
                return;
            }

            /*--- Add/update/delete the lines
            Add the contents of the set to a new list*/
            macAddressUpsertLst.addAll(macAddressUpsertSet);
            //Perform database upsert
            database.upsert(macAddressUpsertLst,false);

            try{
                delete macAddressLinedelete;
            }
            catch(exception e){} 

            macAddressLinedelete = new List<MAC_Address__c>();
            getLines(false);
            } 
            catch (DMLException de) {
                errorMessage =Label.PKI_Certificate_Request_Validation_Unable_To_Save+' '+de.getMessage();
            }             
    }
    
    public set<MAC_Address__c> processReqLicenses(){
            //--- Now add the Lines only if MAC Address is provided.
            set<MAC_Address__c> macAddressSet = new set<MAC_Address__c>();
            String serverSerial;
            String macAddress;
            String certificateType;
            String licenseType;
            boolean lbLineError = false;
            macAddressUpsertSet = new set<MAC_Address__c>();
            // processing the List Mac address to insert / update/ delete.
            for (MAC_Address__c objMacAdd: macAddlines) 
            {
                serverSerial = (objMacAdd.Server_Serial__c == null) ? '':objMacAdd.Server_Serial__c.trim();
                macAddress   = (objMacAdd.MAC_Address__c == null) ? '':objMacAdd.MAC_Address__c.trim();
                certificateType = (objMacAdd.Certificate_Type__c == null) ? '':objMacAdd.Certificate_Type__c.trim();
                licenseType = (objMacAdd.License_Type__c == null) ? '' : objMacAdd.License_Type__c.trim();
                
                objMacAdd.License_and_Certificate_Request__c   = lcrObj.id;

                if ((!serverSerial.equals('')) || (!macAddress.equals(''))) 
                {
                    macAddressSet.add(objMacAdd);     
                }
               
            }
    
            //To throw an error message if there are no entries for Requested License 
            if(macAddressSet.isEmpty()){               
                return null;
            }
            else 
                return macAddressSet;
            }                    
    
    /**
    * @author Shiva Shankar
    * @description - submitAction
    * @input param  - null
    * @return null
    */
    public void submitAction()
    {
        //--- Check to see if the user is submitting the L/C request
        String lsSubmit = ApexPages.currentPage().getParameters().get('submit');
        Cookie theCookie = ApexPages.currentPage().getCookies().get('DOLIKCZXHW');
        String submitActionCookie = null;
        if(theCookie != null) 
            submitActionCookie = theCookie.getValue();
        if (((editLCR == null) || (editLCR == true)) && (lsSubmit != null) && (lsSubmit.equalsIgnoreCase('1')) && submitActionCookie != null && submitActionCookie == 'YUBXYEICII') 
        {
            submitCLR();
            if (errorMessage !=null) 
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, errorMessage));
            else 
            {
                editLCR = false;
                //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, Label.PKI_Certificate_Request_Submit_Success));
            } 
        }

        //--- Now remove the cookie
        Cookie DOLIKCZXHW = new Cookie('DOLIKCZXHW','ILDMRBNFVM',null,0,false);
        ApexPages.currentPage().setCookies(new Cookie[]{DOLIKCZXHW});          
        ApexPages.currentPage().getParameters().put('submit','0');       
    }
    /**
    * @author Shiva Shankar
    * @description - To submit LCR Request
    * @input param  - null
    * @return null
    */
    public PageReference submit()
    {
        // to save the LCR Request when click on save & submit
        saveLCR(); 
        if (errorMessage !=null) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, errorMessage));
            return null;
        }
        else {
            isValidEntitlement(lcrobj,lcrobjOnLoad);
            upsert lcrobj;
            //--- Save is successful, submit the L/C Request.
            Cookie DOLIKCZXHW = new Cookie('DOLIKCZXHW','YUBXYEICII',null,315569260,false);
            //Set the page cookies using the setCookies() method
            ApexPages.currentPage().setCookies(new Cookie[]{DOLIKCZXHW});          
            PageReference loRMAPage = new PageReference(Label.PKI_Certificate_Request_URL);
            loRMAPage.getParameters().put('id',lcrObj.id);
            loRMAPage.getParameters().put('submit','1');
            return loRMAPage.setRedirect(true);           
        }
    }
    /**
    * @author Shiva Shankar
    * @description - To submit LCR Request
    * @input param  - null
    * @return null
    */
    public void submitCLR() 
    {
        boolean lbFoundLineErrors = false;
        boolean lbNewAddress      = false;  
            errorMessage = null;                                           
            //--- If no lines are found, inform the user to add at least MAC Address.
            if (macAddlines.size() <=0) {
                errorMessage = Label.PKI_Certificate_Request_Validation_MAC_Address3;   
                return;             
            }
            redirectPage();      
    }
    
    /**
    * @author Shiva Shankar
    * @description - redirectPage
    * @input param  - null
    * @return null
    */
    public PageReference redirectPage()
    {       
        PageReference loRMAPage = new PageReference(Label.PKI_Certificate_Request_URL);
        loRMAPage.getParameters().put('id',lcrObj.id);
        loRMAPage.getParameters().put('submit','0');
        return loRMAPage.setRedirect(true);           
    }

    /**
    * @author Shiva Shankar
    * @description - To save attachment
    * @input param  - null
    * @return null
    */    
    public void savedoc()
    {
        // to save the LCR Request when click on Attch File 
        saveLCR();
        string orderId=lcrObj.id;
        
        if (errorMessage !=null) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, errorMessage));
            // return null;
        }
        else if(myfile != null && myfile.name!=null){
                Transient attachment a = new attachment(parentId = orderId, name=myfile.name, body = myfile.body);  
            try{       
                insert a; 
            }catch (DMLException e){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR,Label.PKI_Certificate_Request_Validation_Attachment));
                return;
            }
        }
        
    }
    /**
    * @author Shiva Shankar
    * @description - viewAttachment
    * @input param  - null
    * @return null
    */
    public PageReference viewAttachment() {
        // to view the attchment
        string attid=apexpages.currentpage().getparameters().get('attachmentid');
        pagereference pag= new pagereference('/servlet/servlet.FileDownload?file='+attid);       
        return pag;
    }
    /**
    * @author Shiva Shankar
    * @description - editAttachment
    * @input param  - null
    * @return null
    */
    public PageReference editAttachment() {
        //to update the attachment
        string attid1=apexpages.currentpage().getparameters().get('attachmentid');
        pagereference pag= new pagereference('/'+attid1+'/e?retURL=%2F'+lcrObj.id);
        pag.setredirect(true);
        return pag;
    } 
    /**
    * @author Shiva Shankar
    * @description - delAttachment
    * @input param  - null
    * @return null
    */
    public void delAttachment() {
        //to delete the attachment
        string attid=apexpages.currentpage().getparameters().get('attachmentid');      
        attachment tempAttachment = new attachment();
        tempAttachment =[select Id from Attachment where id =:attid]; 
        if(attid != null)
        delete tempAttachment;
    }
   /**
    * @author Shiva Shankar
    * @description - To validate MAC Address
    * @input param  - null
    * @return null
    */
   public boolean isMacValid(string macAdd)
    {   // to validate the MAC Address format and returns true if it's valid else false.
        Pattern macAddressPattern = Pattern.compile('^([0-9a-fA-F][0-9a-fA-F]:){5}([0-9a-fA-F][0-9a-fA-F])$');
        Matcher myMatcher=macAddressPattern.matcher(macAdd);
        while(myMatcher.find()){
        return true;    
        }
        return false;
    }
    /**
    * @author Shiva Shankar
    * @description - To 
    
     string is empty
    * @input param  - string
    * @return boolean
    */
    /*public static boolean isEmpty(String value){
        // to check whether string is null or empty
        boolean flag=false;
        if(value==null||value.trim().equals('')){
            flag=true;      
        }
        return flag;
    }*/
    /**
    * @author Shiva Shankar
    * @description - To check string is empty
    * @input param  - string
    * @return boolean
    */
    public PageReference createNewRequest()
    {   // redirecting to new form on clik of cretae new request button.    
        PageReference loRMAPage = new PageReference(Label.PKI_Certificate_Request_URL);
        return loRMAPage.setRedirect(true);           
    }
    
    /**
    * @author Shiva Shankar
    * @description - rediretToViewPage when click on edit button if record is submitted
    * @input param  - string
    * @return boolean
    */
    public void rediretToViewPage()
    {   // if the record is submitted and click on edit button, to show prompt message and hide edit(save) button.   
        if(lcrObj.Status__c==Label.PKI_Certificate_Request_Pending_Submission_Label)
        {
            isInSufficientPrivileges=false;
        }
        else
        {
            isInSufficientPrivileges=true;
        }              
    }
    
     /**
    * @author Poornima Ramachandrachar
    * @description - to validate if the account for given LCR has valid entitlement
    * @input param  - old and new version of LCR object record
    * @return null
    */
    public void isValidEntitlement(PKI_License_and_Certificate_Request__c lcrObj,PKI_License_and_Certificate_Request__c lcrObjOnLoad)
    {   
        Set<Id> accountIds = new Set<Id>(); // set to hold account Ids
        list<id> lstWhatId=new list<id>();  
        Id linkwayFSQueueId=label.PKI_LinkwayFSQueueId;
        Id certLicenseTeamQueueId=Label.PKI_certLicenseTeamQueueId;
        // to check old and new values from triggrold/trigger new(to stop recursive.) 
        if(lcrObj != null && lcrObjOnLoad != null && lcrObj.Account__c != null && (lcrObjOnLoad.Status__c == label.PKI_Certificate_Request_Pending_Submission_Label || lcrObjOnLoad.Status__c== label.PKI_Certificate_Request_Rejected_Label))
        {
             //add all account ids to Set
             accountIds.add(lcrObj.Account__c);
             lstWhatId.add(lcrObj.Id);
        }
        else if(lcrObj != null && lcrObjOnLoad == null && lcrObj.Account__c != null)
        {
             //add all account ids to Set
             accountIds.add(lcrObj.Account__c);
             lstWhatId.add(lcrObj.Id);
         }
/* TODO 
        if ( lcrObj != null && 
             lcrObj.Account__c != null && 
            (lcrObjOnLoad == null || lcrObjOnLoad.Status__c == label.PKI_Certificate_Request_Pending_Submission_Label || lcrObjOnLoad.Status__c== label.PKI_Certificate_Request_Rejected_Label))
        {
             //add all account ids to Set
             accountIds.add(lcrObj.Account__c);
             lstWhatId.add(lcrObj.Id);
        }
*/
                   
         if(accountIds!=null && accountIds.size()>0)
         {
            list<string> lstRequestoremailIds=new list<string>();
            list<string> lstQueOwneremailIds=new list<string>();
            set<id> setId=new set<id>();
            set<string> queueNames= new set<string>();
            Map<Id,Entitlement> accEntitlementMap = new Map<Id,Entitlement>(); // Map to hold account Ids and Entitlements
            //Code to verify whether account related to PKI License Certificate has active entitlements
            //retrieve Entitlements related to accounts
            List <Entitlement> entls = [Select e.StartDate, e.Id, e.EndDate, e.AccountId,e.Product__c,e.Field_Service_Team__c
                                         From Entitlement e
                                         Where e.AccountId in:accountIds And e.Type = 'Certificate and License Requests' And e.Status='Active'
                                         AND e.Product__c =: lcrObj.Custom_Product__c];
            //If active entitlements are found, then change the status to approved else change to pending Authorization
            if(entls!= null && entls.size()>0)
                {   
                     // loop through the entitlements and add account ids and entitlements to the Map
                     for(Entitlement e : entls)
                     {
                         accEntitlementMap.put(e.AccountId,e);
                     }
                    if(!accEntitlementMap.isEmpty() && accEntitlementMap.containsKey(lcrObj.Account__c) && accEntitlementMap.get(lcrObj.Account__c).Product__c == lcrObj.custom_product__c){
                        lcrObj.Status__c ='Approved';
                     }                                   
                     else
                     {
                        lcrObj.Status__c ='Pending Authorization';
                     }
                 }
            else{
                    lcrObj.Status__c ='Pending Authorization';
                }
                
                
            }
    }   
        }