/*********************************************************************************
Name         : MacAddressUploadController
Created By   : Shiva Shankar Nalluri
Modified BY  : 
Company Name : NTT Data
Project      : ViaSat Atlas, Bangalore
Created Date : 
Modified Date: 
Usages       : Controller for VisualForce Page: MACAddressUpload
*********************************************************************************/
public with sharing class MacAddressUploadController {
    public class applicationException extends Exception {}
    
    //variables are used for csv input file.
    //to store csv fileName
    public String fileName{get;set;}
    //to store csv contentType
    public String contentType{get;set;}
    //to store csv fileName
    public Blob fileContent{get;set;}
    //to store csv fileSize
    public integer fileSize{get;set;}
    //---Used for going through steps of upload
    public Integer uploadStep{get {return (uploadStep == null)? 1:uploadStep;}set;}
    //to store errorCount
    public Integer errorCount{get {return (errorCount== null)? 0:errorCount;}set;}
    //to store  readyToImport
    public Boolean readyToImport{get;set;}
    //variable used to store License and Certificate Request id
    public string lcrId {get;set;}
    //variable used to display the inserted data in the page(review data)
    public List<Map<String, Object>> fileData {get;set;}
    //variable used to extract the data from csv  file.
    String[] fileLines = new String[]{};
    //used to insert multiple mac adddress lines.     
    public List<MAC_Address__c> lstMacAddress;
      
   /**
    * @author Shiva Shankar
    * @description - Constructor for MacAddressUploadController
    * @input param  - null
    * @return null
    */ 
   public MacAddressUploadController () {
      // to get License and Certificate Request id
      lcrId = ApexPages.currentPage().getParameters().get('lcrId');
      
      fileContent = null;
      fileName  = null;     
      contentType  = null;
      fileData = null;
      uploadStep   = 1;      
      lstMacAddress = null;
      readyToImport = false;
      errorCount = 0;       
   }
   
   /**
    * @author Shiva Shankar
    * @description - To read csv file data.
    * @input param  - null
    * @return param csv file
    */
   public Pagereference readFile() {
      // assume that step=1
      uploadStep    = 1;
      readyToImport = false;

      //--- 1. Check if file is provided
      if (fileName == null) {
         ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, Label.PKI_Certificate_Request_Validation_Upload_CSV1));
         return null;
      }
      
      //--- 2. Check for file type to make sure it is a CSV file
      /*if (contentType != 'application/vnd.ms-excel') {
         ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR,Label.PKI_Certificate_Request_Validation_Upload_CSV2+' '+fileName+' '+Label.PKI_Certificate_Request_Validation_Upload_CSV3));
         return null;
      }*/
      
      if(!fileName.endsWith('.csv'))
      {
         ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR,Label.PKI_Certificate_Request_Validation_Upload_CSV2+' '+fileName+' '+Label.PKI_Certificate_Request_Validation_Upload_CSV4));
         return null;               
      }
      
      //--- 3. Get the data to import from the file
      try{    
      filelines = fileContent.toString().split('\\n');
      }catch(exception ex){
         ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR,Label.PKI_Certificate_Request_Validation_Upload_CSV5 +' '+fileName+' '+Label.PKI_Certificate_Request_Validation_Upload_CSV6));
         return null;       
      }
      fileContent = null;
      if (filelines.size() < 1) {
         ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR,Label.PKI_Certificate_Request_Validation_Upload_CSV_No_Row));
         return null;         
      }

      
      //------ 3a. Check to see if header row has all the columns need to import
      
      List<String> headerValues  = new List<String>();
      String[] inputValues  = new String[]{};
      String importFields = Label.PKI_Certificate_Request_Validation_Upload_CSV_Row_Headers;
      String ValidLicenseType = Label.PKI_Certificate_Request_Validation_License_Type_Values;
      String ValidCertificateType = Label.PKI_Certificate_Request_Validation_Certificate_Type_Values;
      // used to assign row headers to integer variables, to get names based on numbers
      Map<String,Integer> importFieldsMap = new Map<String,Integer>();
      // to get row headers in to list
      for(string st : filelines[0].split(',')) 
           headerValues.add(st); 
      if (headerValues.size() < 0) {
         ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR,Label.PKI_Certificate_Request_Validation_Upload_CSV7+' '+headerValues.size()+' ' +'columns.'+' '+
                                                                             Label.PKI_Certificate_Request_Validation_Upload_CSV8+' '+importFields));
         return null;               
      }
      //------ 3b. Map the header columns to the Mac address  fields
      //------ if not all Mac address  fields are found in the header, info the user with error on fields missing in import file
      String fieldsNotFound = '';
      Integer j;
      Integer k = 0;
      //loop through row headers      
      for (String s: importFields.split(',')) {
         //k++;
         for (j = 0; j < headerValues.size(); j++) {
            if (s.trim().equalsIgnoreCase(headerValues[j].trim())) {
               importFieldsMap.put(s.trim(),j);               
            }
         }
         
         if (j==headerValues.size()) 
            fieldsNotFound = fieldsNotFound + ',' + s;
      }    
      if (fieldsNotFound == '') {
         ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR,Label.PKI_Certificate_Request_Validation_Upload_CSV9+' '+fieldsNotFound));
         return null;                     
      }
                     
      //------ 3b. Validate the data
      uploadStep = 2;
      lstMacAddress = new List<MAC_Address__c>();      
      Map<String,Object> fileLineData = null;
      
      String fieldName    = '';
      String errorInfo    = '';
      Boolean foundErrors = false;
      
      fileData = new List<Map<String,Object>>();
      if(filelines.size() > 1000){
         ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR,Label.PKI_Certificate_Request_Validation_Upload_CSV10+' '+filelines.size()));
         return null;                     
        
      }
      //loop through csv file data
      for (Integer i = 1; i<filelines.size(); i++) {
         inputValues = filelines[i].split(',');
         //--- Set the fileData list with File Line Data to be used by the page
         fileLineData = new Map<String, Object>();
         fileLineData.put('rownum',i);
         
         if(inputValues.size()<=importFieldsMap.get('Server Serial #')){
             fileLineData.put('serialNum','');
         }
         else{
             fileLineData.put('serialNum',inputvalues[importFieldsMap.get('Server Serial #')]);
         }
         
         
         if(inputValues.size()<=importFieldsMap.get('Certificate Type')){
             fileLineData.put('certificate','');
         }
         else{
             fileLineData.put('certificate',inputvalues[importFieldsMap.get('Certificate Type')]);
         }
         
         if(inputValues.size()<=importFieldsMap.get('License Type')){
             fileLineData.put('licence','');
         }
         else{
             fileLineData.put('licence',inputvalues[importFieldsMap.get('License Type')]);
         }
         
         if(inputValues.size()<=importFieldsMap.get('MAC Address')){
             fileLineData.put('mac','');
         }
         else{
             fileLineData.put('mac',inputvalues[importFieldsMap.get('MAC Address')]);
         }
         
         if(inputValues.size()<=importFieldsMap.get('Comment')){
             fileLineData.put('comment','');
         }
         else{
             fileLineData.put('comment',inputvalues[importFieldsMap.get('Comment')]);
         }
       
         // to store eror message
         errorInfo = '';
         fieldName = '';
         try {  
            MAC_Address__c objMacAdd= new MAC_Address__c();            
            try {
               fieldName = 'MAC Address';
               if(inputvalues[importFieldsMap.get('MAC Address')] != '' && isMacValid(inputvalues[importFieldsMap.get('MAC Address')]))
                   objMacAdd.MAC_Address__c = inputvalues[importFieldsMap.get('MAC Address')];            
               
               else if(inputvalues[importFieldsMap.get('MAC Address')] != '' && !isMacValid(inputvalues[importFieldsMap.get('MAC Address')]))
               {
                    throw new applicationException(Label.PKI_Certificate_Request_Validation_Upload_CSV11);
               }
               fieldName = 'License Type';
               objMacAdd.License_Type__c = inputvalues[importFieldsMap.get('License Type')];
               
               if(objMacAdd.License_Type__c != ''){
                   List<String> validLicenseTypeLst = new List<String>();
                   for(String s : ValidLicenseType.split(',')){
                       if(objMacAdd.License_Type__c.trim().equalsIgnoreCase(s.trim())){
                           validLicenseTypeLst.add(s);
                       }
                       
                   }
                       if(validLicenseTypeLst.isEmpty()){
                           throw new applicationException(Label.PKI_Certificate_Request_Validation_MAC_Address6);
                       }
               }

               fieldName = 'Certificate Type';
               objMacAdd.Certificate_Type__c = inputvalues[importFieldsMap.get('Certificate Type')];  
               if(objMacAdd.Certificate_Type__c != ''){
                   List<String> validCertificateTypeLst = new List<String>();
                   for(String s : validCertificateType.split(',')){
                       if(objMacAdd.Certificate_Type__c.equalsIgnoreCase(s.trim())){
                           validCertificateTypeLst.add(s);
                       }
                       
                   }
                       if(validCertificateTypeLst.isEmpty()){
                           throw new applicationException(Label.PKI_Certificate_Request_Validation_MAC_Address7);
                       }
               }
                        
            
               fieldName = 'Comment';
               objMacAdd.Comments__c = inputvalues[importFieldsMap.get('Comment')]; 
                
               fieldName = 'LCR';
               objMacAdd.License_and_Certificate_Request__c  = lcrId;
               
               fieldName = 'Server Serial #';
               objMacAdd.Server_Serial__c = inputvalues[importFieldsMap.get('Server Serial #')];
               
               String serverSerial = (objMacAdd.Server_Serial__c == null) ? '':objMacAdd.Server_Serial__c.trim();
               String macAddress   = (objMacAdd.MAC_Address__c == null) ? '':objMacAdd.MAC_Address__c.trim();
               String certificateType = (objMacAdd.Certificate_Type__c == null) ? '':objMacAdd.Certificate_Type__c.trim();
               String licenseType = (objMacAdd.License_Type__c == null) ? '' : objMacAdd.License_Type__c.trim();
               
               
                    if ((serverSerial.equals('')) || (macAddress.equals(''))){
                        fieldName = '';
                        throw new applicationException(label.PKI_Certificate_Request_Validation_MAC_Address5);
                    }
                    if (certificateType.equals('') && licenseType.equals('')) {
                        fieldName = '';
                        throw new applicationException(Label.PKI_Certificate_Request_Validation_MAC_Address4);
                    }
            } catch (Exception e) {
               errorInfo = errorInfo + '<br>Invalid ' + fieldName +' - ' + e.getMessage(); 
            }            
                      
            lstMacAddress.add(objMacAdd);
        } catch (Exception e) {
            errorInfo = errorInfo + '<br>Unable to upload MAC Address - ' + e.getMessage();
        }
        
        
        if (errorInfo != '') {
           errorCount = errorCount + 1;
           errorinfo = errorinfo.substring(4);
        } else {
           errorinfo = 'Success';   
        }
        
        fileLineData.put('errorinfo',errorInfo);
        
        //--- Add the line data with error info to the File Data, which is used by the page to display the data and error information
        fileData.add(fileLineData);
      }
      
      if (errorCount > 0) {
         ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR,Label.PKI_Certificate_Request_Validation_Upload_CSV12));
      } else {
         ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.Info,Label.PKI_Certificate_Request_Validation_Upload_CSV13));
         readyToImport = true;
      }
         
      PageReference loUploadPage = new PageReference(Label.PKI_Certificate_Request_Return_MAC_Address_URL);
      loUploadPage.getParameters().put('lcrId',lcrId);
      return loUploadPage;
   }
   /**
    * @author Shiva Shankar
    * @description - To import data from csv file to database(MAC_Address__c)
    * @input param  - null
    * @return param extracted data from csv file
    */
   public pageReference importData() {
      try {
         uploadStep = 2;
         insert lstMacAddress;
         
         //--- Upon successful import return to the
         PageReference loRMAPage = new PageReference(Label.PKI_Certificate_Request_URL);
         loRMAPage.getParameters().put('id',lcrId);
         
         return loRMAPage.setRedirect(true); 
      } catch (Exception e) {
         ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR,Label.PKI_Certificate_Request_Validation_Upload_Unable_To_Import+' '+e.getMessage()));
         readyToImport = false; 
         return null;                           
      }
   } 
   /**
    * @author Shiva Shankar
    * @description - Go back to License and Certificate Request page
    * @input param  - null
    * @return param 
    */
   public pageReference back() {
      uploadStep = 1;
      fileName  = null;
      contentType  = null;
      lstMacAddress  = null;
      readyToImport = false;  
      errorCount = 0;  
      
      return null;
   }
   /**
    * @author Shiva Shankar
    * @description - Go back to License and Certificate Request
    * @input param  - null
    * @return param lcrid
    */
   public PageReference cancel() {
      uploadStep  = 1;
      fileName = null;
      contentType = null;
      lstMacAddress  = null;
      readyToImport = false;
      errorCount  = 0;   
      
      //--- Return to the L/C Request edit page
      PageReference loRMAPage = new PageReference(Label.PKI_Certificate_Request_URL);
      loRMAPage.getParameters().put('id',lcrId);
         
      return loRMAPage.setRedirect(false); 
   }   
   /**
    * @author Shiva Shankar
    * @description - To validate MAC Address
    * @input param  - null
    * @return null
    */
   public boolean isMacValid(string macAdd)
    {   // to validate mac address
        Pattern macAddressPattern = Pattern.compile('^([0-9a-fA-F][0-9a-fA-F]:){5}([0-9a-fA-F][0-9a-fA-F])$');
        Matcher myMatcher=macAddressPattern.matcher(macAdd);
        while(myMatcher.find()){
        return true;    
        }
        return false;
    } 
}