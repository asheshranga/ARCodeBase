public with sharing class RMALinesUploadController {
   public String fileName{get;set;}
   public String contentType{get;set;}
   public Blob fileContent{get;set;}
   
   //---Used for going through steps of upload
   public Integer uploadStep{get {return (uploadStep == null)? 1:uploadStep;}set;}
   public Integer errorCount{get {return (errorCount== null)? 0:errorCount;}set;}
   public Boolean readyToImport{get;set;}
   
   public string rmaid {get;set;}
   // Static variable that assumes a test is not running
   public static boolean isApexTest = false;
   
   
   public List<Map<String, Object>> fileData {get;set;}
   
   String[] fileLines = new String[]{};     
   List<OrderLine__c> rmalines;   
   String priorPage{get;set;}
   
   //--- Initialize the controller
   public RMALinesUploadController () {
      priorPage = ApexPages.currentPage().getHeaders().get('Referer');
      rmaid     = ApexPages.currentPage().getParameters().get('rmaid');
      
      fileContent       = null;
      fileName          = null;     
      contentType       = null;
      fileData          = null;
      
      uploadStep        = 1;      
      rmalines          = null;
      readyToImport     = false;
      errorCount        = 0;       
   }
   
    @IsTest(SeeAllData=true) public static void testRMALinesUploadController() { 
        
        Account a = new Account(name = 'test');
        insert a;
        
        Address__c sadd = new Address__c(name='test street');
        sadd.Account__c = a.Id;
        sadd.Type__c = 'Ship to';
        sadd.Default__c = true;
        insert sadd;
        
        Address__c badd = new Address__c(name='test street');
        badd.Account__c = a.Id;
        badd.Type__c = 'Bill to';
        badd.Default__c = true;
        insert badd;
    
        Order__c c = new Order__c();
        c.Account__c = a.id;
        insert c;

        Apexpages.currentPage().getParameters().put('referrer','/OrderController');
        Apexpages.currentPage().getParameters().put('rmaid',c.Id);          
        RMALinesUploadController rmaLinesUploadController = new RMALinesUploadController();
        
    }
    
    @IsTest(SeeAllData=true) public static void testReadFile1() { 
        
        Account a = new Account(name = 'test');
        insert a;
        
        Address__c sadd = new Address__c(name='test street');
        sadd.Account__c = a.Id;
        sadd.Type__c = 'Ship to';
        sadd.Default__c = true;
        insert sadd;
        
        Address__c badd = new Address__c(name='test street');
        badd.Account__c = a.Id;
        badd.Type__c = 'Bill to';
        badd.Default__c = true;
        insert badd;
    
        Order__c c = new Order__c();
        ApexPages.Standardcontroller controller2 = new ApexPages.Standardcontroller(c);
        OrderController orderLinePOCController2 = new OrderController(controller2);
        c.Account__c = a.id;
        c.Status__c = System.Label.RMASubmitStatus;
        insert c;

        Apexpages.currentPage().getParameters().put('referrer','/OrderController');
        Apexpages.currentPage().getParameters().put('rmaid',c.Id);          
        RMALinesUploadController rmaLinesUploadController = new RMALinesUploadController();
        
        rmaLinesUploadController.readFile();
        
        rmaLinesUploadController.fileName = 'test.csv';
        rmaLinesUploadController.readFile();
        
        rmaLinesUploadController.contentType = 'application/vnd.ms-excel';
        String myString1 = '';
        rmaLinesUploadController.fileContent = Blob.valueof(myString1);
        rmaLinesUploadController.readFile();
        
        String myString2 = 'Test';
        rmaLinesUploadController.fileContent = Blob.valueof(myString2);
        rmaLinesUploadController.readFile();
        
        
    }
    
    @IsTest(SeeAllData=true) public static void testReadFile2() { 
        
        Account a = new Account(name = 'test');
        insert a;
        
        Address__c sadd = new Address__c(name='test street');
        sadd.Account__c = a.Id;
        sadd.Type__c = 'Ship to';
        sadd.Default__c = true;
        insert sadd;
        
        Address__c badd = new Address__c(name='test street');
        badd.Account__c = a.Id;
        badd.Type__c = 'Bill to';
        badd.Default__c = true;
        insert badd;
    
        Order__c c = new Order__c();
        ApexPages.Standardcontroller controller2 = new ApexPages.Standardcontroller(c);
        OrderController orderLinePOCController2 = new OrderController(controller2);
        c.Account__c = a.id;
        c.Status__c = System.Label.RMASubmitStatus;
        insert c;

        Apexpages.currentPage().getParameters().put('referrer','/OrderController');
        Apexpages.currentPage().getParameters().put('rmaid',c.Id);          
        RMALinesUploadController rmaLinesUploadController = new RMALinesUploadController();
        
        rmaLinesUploadController.fileName = 'test.csv';
        rmaLinesUploadController.contentType = 'application/vnd.ms-excel';
        String myString2 = 'Test\n Note';
        rmaLinesUploadController.fileContent = Blob.valueof(myString2);
        rmaLinesUploadController.readFile();
        
        
    }

    @IsTest(SeeAllData=true) public static void testReadFile3() { 
        
        Account a = new Account(name = 'test');
        insert a;
        
        Address__c sadd = new Address__c(name='test street');
        sadd.Account__c = a.Id;
        sadd.Type__c = 'Ship to';
        sadd.Default__c = true;
        insert sadd;
        
        Address__c badd = new Address__c(name='test street');
        badd.Account__c = a.Id;
        badd.Type__c = 'Bill to';
        badd.Default__c = true;
        insert badd;
    
        Order__c c = new Order__c();
        ApexPages.Standardcontroller controller2 = new ApexPages.Standardcontroller(c);
        OrderController orderLinePOCController2 = new OrderController(controller2);
        c.Account__c = a.id;
        c.Status__c = System.Label.RMASubmitStatus;
        insert c;

        Apexpages.currentPage().getParameters().put('referrer','/OrderController');
        Apexpages.currentPage().getParameters().put('rmaid',c.Id);          
        RMALinesUploadController rmaLinesUploadController = new RMALinesUploadController();
        
        rmaLinesUploadController.fileName = 'test.csv';
        rmaLinesUploadController.contentType = 'application/vnd.ms-excel';
        String myString2 = 'Part Number, Serial Number, Return Reason\n12345,SR3000,Test';
        rmaLinesUploadController.fileContent = Blob.valueof(myString2);
        rmaLinesUploadController.readFile();
        
        
    }
    
    @IsTest(SeeAllData=true) public static void testReadFile4() { 
        
        Account a = new Account(name = 'test');
        insert a;
        
        Address__c sadd = new Address__c(name='test street');
        sadd.Account__c = a.Id;
        sadd.Type__c = 'Ship to';
        sadd.Default__c = true;
        insert sadd;
        
        Address__c badd = new Address__c(name='test street');
        badd.Account__c = a.Id;
        badd.Type__c = 'Bill to';
        badd.Default__c = true;
        insert badd;
    
        Order__c c = new Order__c();
        ApexPages.Standardcontroller controller2 = new ApexPages.Standardcontroller(c);
        OrderController orderLinePOCController2 = new OrderController(controller2);
        c.Account__c = a.id;
        c.Status__c = System.Label.RMASubmitStatus;
        insert c;

        Apexpages.currentPage().getParameters().put('referrer','/OrderController');
        Apexpages.currentPage().getParameters().put('rmaid',c.Id);          
        RMALinesUploadController rmaLinesUploadController = new RMALinesUploadController();
        
        rmaLinesUploadController.fileName = 'test.csv';
        rmaLinesUploadController.contentType = 'application/vnd.ms-excel';
        String myString2 = 'Part Number, Serial Number, Return Reaso\n12345,SR3000,Test';
        rmaLinesUploadController.fileContent = Blob.valueof(myString2);
        rmaLinesUploadController.readFile();
        
        
    }

    
    @IsTest(SeeAllData=true) public static void testimportData() { 
        Account a = new Account(name = 'test');
        insert a;
        
        Address__c sadd = new Address__c(name='test street');
        sadd.Account__c = a.Id;
        sadd.Type__c = 'Ship to';
        sadd.Default__c = true;
        insert sadd;
        
        Address__c badd = new Address__c(name='test street');
        badd.Account__c = a.Id;
        badd.Type__c = 'Bill to';
        badd.Default__c = true;
        insert badd;
    
        Order__c c = new Order__c();
        ApexPages.Standardcontroller controller2 = new ApexPages.Standardcontroller(c);
        OrderController orderLinePOCController2 = new OrderController(controller2);
        c.Account__c = a.id;
        c.Status__c = System.Label.RMASubmitStatus;
        insert c;
        
        Apexpages.currentPage().getParameters().put('referrer','/OrderController');
        Apexpages.currentPage().getParameters().put('rmaid',c.Id);          
        RMALinesUploadController rmaLinesUploadController = new RMALinesUploadController();
        
        rmaLinesUploadController.importData();
    }   

    @IsTest(SeeAllData=true) public static void testimportData2() { 
        Account a = new Account(name = 'test');
        insert a;
        
        Address__c sadd = new Address__c(name='test street');
        sadd.Account__c = a.Id;
        sadd.Type__c = 'Ship to';
        sadd.Default__c = true;
        insert sadd;
        
        Address__c badd = new Address__c(name='test street');
        badd.Account__c = a.Id;
        badd.Type__c = 'Bill to';
        badd.Default__c = true;
        insert badd;
    
        Order__c c = new Order__c();
        ApexPages.Standardcontroller controller2 = new ApexPages.Standardcontroller(c);
        OrderController orderLinePOCController2 = new OrderController(controller2);
        c.Account__c = a.id;
        c.Status__c = System.Label.RMASubmitStatus;
        insert c;
        
        OrderLine__c ol1 = new OrderLine__c();
        ol1.Part_Number_2__c = 'SR3000';
        ol1.SerialNo__c = '123456';
        ol1.ReturnReasonDescription__c = 'test';
        ol1.Order__c = c.Id;
        
        Apexpages.currentPage().getParameters().put('referrer','/OrderController');
        Apexpages.currentPage().getParameters().put('rmaid',c.Id);          
        RMALinesUploadController rmaLinesUploadController = new RMALinesUploadController();
        rmaLinesUploadController.rmalines = new List<OrderLine__c>();
        rmaLinesUploadController.rmalines.add(ol1);
        rmaLinesUploadController.importData();
    }   


    @IsTest(SeeAllData=true) public static void testback() { 
        Account a = new Account(name = 'test');
        insert a;
        
        Address__c sadd = new Address__c(name='test street');
        sadd.Account__c = a.Id;
        sadd.Type__c = 'Ship to';
        sadd.Default__c = true;
        insert sadd;
        
        Address__c badd = new Address__c(name='test street');
        badd.Account__c = a.Id;
        badd.Type__c = 'Bill to';
        badd.Default__c = true;
        insert badd;
    
        Order__c c = new Order__c();
        ApexPages.Standardcontroller controller2 = new ApexPages.Standardcontroller(c);
        OrderController orderLinePOCController2 = new OrderController(controller2);
        c.Account__c = a.id;
        c.Status__c = System.Label.RMASubmitStatus;
        insert c;
        
        Apexpages.currentPage().getParameters().put('referrer','/OrderController');
        Apexpages.currentPage().getParameters().put('rmaid',c.Id);          
        RMALinesUploadController rmaLinesUploadController = new RMALinesUploadController();
        
        rmaLinesUploadController.back();
    }   

    @IsTest(SeeAllData=true) public static void testcancel() { 
        Account a = new Account(name = 'test');
        insert a;
        
        Address__c sadd = new Address__c(name='test street');
        sadd.Account__c = a.Id;
        sadd.Type__c = 'Ship to';
        sadd.Default__c = true;
        insert sadd;
        
        Address__c badd = new Address__c(name='test street');
        badd.Account__c = a.Id;
        badd.Type__c = 'Bill to';
        badd.Default__c = true;
        insert badd;
    
        Order__c c = new Order__c();
        ApexPages.Standardcontroller controller2 = new ApexPages.Standardcontroller(c);
        OrderController orderLinePOCController2 = new OrderController(controller2);
        c.Account__c = a.id;
        c.Status__c = System.Label.RMASubmitStatus;
        insert c;
        
        Apexpages.currentPage().getParameters().put('referrer','/OrderController');
        Apexpages.currentPage().getParameters().put('rmaid',c.Id);          
        RMALinesUploadController rmaLinesUploadController = new RMALinesUploadController();
        
        rmaLinesUploadController.cancel();
    }   

   
   //--- Read the contents of the file
   public Pagereference readFile() {
      uploadStep    = 1;
      readyToImport = false;

      //--- 1. Check if file is provided
      if (fileName == null) {
         ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR,'Ooops! File is required, select the file you want to import using browse button. Please provide the data in a CSV file that uses the template provided below.'));
         return null;
      }
   
      //--- 2. Check for file type to make sure it is a CSV file
      if (contentType != 'application/vnd.ms-excel') {
         ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR,'Ooops! File uploaded (' + fileName + ') is not a CSV file. Please provide the data in a CSV file that uses the template provided below.'));
         return null;
      }
      
      if(!fileName.endsWith('.csv'))
      {
         ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR,'Ooops! File uploaded (' + fileName + ') does not have .csv extension. Please provide the data in a CSV file that uses the template provided below.'));
         return null;               
      }
      
      //--- 3. Get the data to import from the file
      try{
      filelines   = fileContent.toString().split('\n');
      }catch(exception ex){
         ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR,'Ooops! Error uploading File (' + fileName + '). Please confirm that the data is in CSV file format and uses the template provided below.'));
         return null;       
      }
      fileContent = null;
      
      if (filelines.size() <= 1) {
         ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR,'Ooops! Need atleast one row of data to import lines. Please note that the first row is treated as a header.'));
         return null;         
      }
      
      //------ 3a. Check to see if header row has all the columns need to import
      String[] headerValues = null;
      String[] inputValues  = null;
      String importFields = 'Part Number, Serial Number, Return Reason';
      Map<String,Integer> importFieldsMap = new Map<String,Integer>();
      
      headerValues = filelines[0].split(',');     
      if (headerValues.size() < 3) {
         ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR,'Ooops! Header row only has ' + headerValues.size() + ' columns. ' + 
                                                                             'Return request line import requires following columns: ' + importFields));
         return null;               
      }
      
      
      //------ 3b. Map the header columns to the RMA Line fields
      //------ if not all RMA Line fields are found in the header, info the user with error on fields missing in import file
      String fieldsNotFound = '';
      Integer j;
      Integer k = 0;      
      for (String s: importFields.split(',')) {
         k++;
         for (j = 0; j < headerValues.size(); j++) {
            if (s.trim().equalsignorecase(headerValues[j].trim())) {
               importFieldsMap.put(s.trim(),j);               
               break;
            }
         }
         
         if (j==headerValues.size()) 
            fieldsNotFound = fieldsNotFound + ',' + s;
      }      
      
      if (fieldsNotFound != '') {
         ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR,'Ooops! File doesn\'t contain following header column(s): ' + fieldsNotFound.substring(1)));
         return null;                     
      }
                     
      //------ 3b. Validate the data
      uploadStep = 2;
      rmalines = new List<OrderLine__c>();      
      Map<String,Object> fileLineData = null;
      
      String fieldName    = '';
      String errorInfo    = '';
      Boolean foundErrors = false;
      
      fileData = new List<Map<String,Object>>();
      if(filelines.size() > 1000){
         ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR,'Ooops! File contain more than 1000 lines: ' + filelines.size()));
         return null;                     
        
      }
      RecordType recordTypeId =  [select Id from RecordType where Name = :System.Label.RMALineRecordType and SobjectType = 'OrderLine__c'];
      for (Integer i = 1; i<filelines.size(); i++) {
         inputValues = filelines[i].split(',');
         
         //--- Set the fileData list with File Line Data to be used by the page
         fileLineData = new Map<String, Object>();
         fileLineData.put('rownum',i);
         fileLineData.put('part',inputvalues[importFieldsMap.get('Part Number')]);
         fileLineData.put('serial',inputvalues[importFieldsMap.get('Serial Number')]);
         fileLineData.put('returnreason',inputvalues[importFieldsMap.get('Return Reason')]);

         errorInfo = '';
         fieldName = '';
         try {  
            OrderLine__c rmaline= new OrderLine__c();            
            rmaline.recordtype =  recordTypeId; 
            try {
               fieldName = 'Part Number';
               rmaline.Part_Number_2__c = inputvalues[importFieldsMap.get('Part Number')];            

               fieldName = 'Serial Number';
               rmaline.SerialNo__c = inputvalues[importFieldsMap.get('Serial Number')];

               fieldName = 'Return Reason';
               rmaline.ReturnReasonDescription__c = inputvalues[importFieldsMap.get('Return Reason')];            

               fieldName = 'RMA';
               rmaline.order__c  = rmaid;
            } catch (Exception e) {
               errorInfo = errorInfo + '<br>Invalid ' + fieldName +' - ' + e.getMessage(); 
            }            
                      
            rmalines.add(rmaline);
        } catch (Exception e) {
            errorInfo = errorInfo + '<br>Unable to add the Request Line - ' + e.getMessage();
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
         ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR,'Ooops! Problem with the data. Please fix the data errors and reload the file.'));
      } else {
         ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.Info,'Please review the data and click on <Import Return Request Lines> button to import the data.'));
         readyToImport = true;
      }
         
      return null;
   }
  
   public pageReference importData() {
      try {
         uploadStep = 2;
         insert rmalines;
         
         //--- Upon successful import return to the RMA edit page
         PageReference loRMAPage = new PageReference('/apex/OrderEdit');
         loRMAPage.getParameters().put('id',rmaid);
         
         return loRMAPage.setRedirect(true); 
      } catch (Exception e) {
         ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR,'Ooops! Unable to import the RMA Lines: ' + e.getMessage()));
         readyToImport = false; 
         return null;                           
      }
   } 
   
   public pageReference back() {
      uploadStep        = 1;
      
      fileName          = null;
      contentType       = null;
      rmalines          = null;
      readyToImport     = false;  
      errorCount        = 0;  
      
      return null;
   }
   
   public PageReference cancel() {
      uploadStep        = 1;
      
      fileName          = null;
      contentType       = null;
      rmalines          = null;
      readyToImport     = false;
      errorCount        = 0;   
      
      //--- Return to the RMA edit page
      PageReference loRMAPage = new PageReference('/apex/OrderEdit');
      loRMAPage.getParameters().put('id',rmaid);
         
      return loRMAPage.setRedirect(true); 
   }      
      
    public void mainForTestSuccess(Id lineId){
        isApexTest = true;
    }
    
    // Methods used in RMAWarrantyLinesUpload Page 
      
   public PageReference cancelWarrantyCheck() {
      uploadStep        = 1;
      
      fileName          = null;
      contentType       = null;
      rmalines          = null;
      readyToImport     = false;
      errorCount        = 0;   
      
      //--- Return to the RMA edit page
      PageReference loRMAPage = new PageReference('/apex/WarrantyValidationPage');
      loRMAPage.getParameters().put('id',rmaid);
         
      return loRMAPage.setRedirect(true); 
   }   
   
   public pageReference importDataWarranty() {
      try {
         uploadStep = 2;
         insert rmalines;
         
         //--- Upon successful import return to the RMA edit page
         PageReference loRMAPage = new PageReference('/apex/WarrantyValidationPage');
         loRMAPage.getParameters().put('id',rmaid);
         
         return loRMAPage.setRedirect(true); 
      } catch (Exception e) {
         ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR,'Ooops! Unable to import the RMA Lines: ' + e.getMessage()));
         readyToImport = false; 
         return null;                           
      }
   }          
}