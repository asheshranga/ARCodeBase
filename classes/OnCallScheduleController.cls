public with sharing class OnCallScheduleController {
   public String fileName{get;set;}
   public String contentType{get;set;}
   public Blob fileContent{get;set;}
   
   public Integer uploadStep{get {return (uploadStep == null)? 1:uploadStep;}set;}
   public Integer errorCount{get {return (errorCount== null)? 0:errorCount;}set;}
   public Boolean readyToImport{get;set;}
   
   public List<Map<String, Object>> fileData {get;set;}
   
   String[] fileLines = new String[]{};     
   List<OnCallSchedule__c> oncallschedules;   
   String priorPage{get;set;}
   
   public OnCallScheduleController () {
      priorPage = ApexPages.currentPage().getHeaders().get('Referer');
      fileContent       = null;
      fileName          = null;     
      contentType       = null;
      fileData          = null;
      
      uploadStep        = 1;      
      oncallschedules   = null;
      readyToImport     = false;
      errorCount        = 0;       
   }
   
   private Boolean isPickVal(List<Schema.PicklistEntry> listPE, String checkValue) {
      Boolean valueFound = false;
      
      if (checkValue.trim() == '')
         return true;
         
      for (String v : checkValue.split(';')) {
         valueFound = false;
         for (Schema.PicklistEntry pe:listPE) {
            if (v.trim().equals(pe.getLabel())) {
               valueFound = true;
               break;
            }         
         }   
         
         if (valueFound == false)
            return false;
      }
      
      return true;
   }
   
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
      
      //--- 3. Get the data to import from the file
      filelines   = fileContent.toString().split('\n');
      fileContent = null;
      
      if (filelines.size() <= 1) {
         ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR,'Ooops! Need atleast one row of data to import the schedule. Please note that the first row is treated as a header.'));
         return null;         
      }
      
      //------ 3a. Check to see if header row has all the columns need to import
      String[] headerValues = null;
      String[] inputValues  = null;
      String scheduleFields = 'Tier, Product, Program, User/Queue, Start Date, End Date, Start Time, End Time, Call Sequence, Case Type';
      Map<String,Integer> scheduleFieldsMap = new Map<String,Integer>();
      
      headerValues = filelines[0].split(',');     
      if (headerValues.size() < 10) {
         ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR,'Ooops! Header row only has ' + headerValues.size() + ' columns. ' + 
                                                                             'Schedule import requires following 10 columns: ' + scheduleFields));
         return null;               
      }
      
      
      //------ 3b. Map the header columns to the schedule fields
      //------ if not all scedule fields are found in the header, info the user with error on fields missing in import file
      String fieldsNotFound = '';
      Integer j;
      Integer k = 0;
      
      //------ Initialize the unique tier, owner, product names in the file.
      //------ These will be used to get their corresponding ids using SOQL to insert the data as Ids
      set<String> tierNames    = new set<String>();
      set<String> ownerNames   = new set<String>();
      set<String> productNames = new set<String>();
      
      for (String s: scheduleFields.split(',')) {
         k++;
         for (j = 0; j < headerValues.size(); j++) {
            if (s.trim().equalsignorecase(headerValues[j].trim())) {
               scheduleFieldsMap.put(s.trim(),j);
               
               if ((s.trim().equalsignorecase('Tier')) || 
                   (s.trim().equalsignorecase('User/Queue')) ||
                   (s.trim().equalsignorecase('Product'))) {                   
                  for (Integer i = 1; i<filelines.size(); i++) {
                     inputValues = filelines[i].split(',');   
                     if (s.trim().equalsignorecase('Tier'))
                        tierNames.add(inputValues[j]);
                     if (s.trim().equalsignorecase('User/Queue'))
                        ownerNames.add(inputValues[j]);
                     if (s.trim().equalsignorecase('Product'))
                        productNames.add(inputValues[j]);
                  }                              
               }               
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
      
      //--- Get the Ids for Tiers, Products and Owners
      Map<String,Id> rt1 = new Map<String,Id>();
      Map<String,Id> p21 = new Map<String,Id>();
      Map<String,Id> u1  = new Map<String,Id>();
      
      for (RecordType r : [select id,name from RecordType where Name = :tierNames]) 
         rt1.put(r.name,r.id);
         
      for (Product2 p : [select id,name from product2 where Name = :productNames]) 
         p21.put(p.name,p.id);
         
      for (User u : [select id,name from user where Name = :ownerNames]) 
         u1.put(u.name,u.id);
         
      for (QueueSobject q : [select Queue.id,Queue.Name from QueueSobject where Queue.Name = :ownerNames]) 
         u1.put(q.Queue.name,q.Queue.id);
               
      //------ 3b. Validate the data
      uploadStep = 2;
      oncallschedules = new List<OnCallSchedule__c>();      
      Map<String,Object> fileLineData = null;
      
      String fieldName    = '';
      String errorInfo    = '';
      Boolean foundErrors = false;
      fileData = new List<Map<String,Object>>();
      List<Schema.PicklistEntry> listPrograms  = oncallschedule__c.program__c.getDescribe().getPickListValues();
      List<Schema.PicklistEntry> listCaseTypes = oncallschedule__c.casetype__c.getDescribe().getPickListValues();
      for (Integer i = 1; i<filelines.size(); i++) {
         inputValues = filelines[i].split(',');
         
         //--- Set the fileData list with File Line Data to be used by the page
         fileLineData = new Map<String, Object>();
         fileLineData.put('rownum',i);
         fileLineData.put('tier',inputvalues[scheduleFieldsMap.get('Tier')]);
         fileLineData.put('product',inputvalues[scheduleFieldsMap.get('Product')]);
         fileLineData.put('program',inputvalues[scheduleFieldsMap.get('Program')]);
         fileLineData.put('owner',inputvalues[scheduleFieldsMap.get('User/Queue')]);
         fileLineData.put('startdate',inputvalues[scheduleFieldsMap.get('Start Date')]);
         fileLineData.put('enddate',inputvalues[scheduleFieldsMap.get('End Date')]);
         fileLineData.put('starttime',inputvalues[scheduleFieldsMap.get('Start Time')]);
         fileLineData.put('endtime',inputvalues[scheduleFieldsMap.get('End Time')]);
         fileLineData.put('callseq',inputvalues[scheduleFieldsMap.get('Call Sequence')]);
         fileLineData.put('casetype',inputvalues[scheduleFieldsMap.get('Case Type')]);

         errorInfo = '';
         try {  
            OnCallSchedule__c schedule= new OnCallSchedule__c();
            if (rt1.get(inputvalues[scheduleFieldsMap.get('Tier')]) == null) 
               errorInfo = '<br>Invalid Tier - ' + inputvalues[scheduleFieldsMap.get('Tier')];
            else         
               schedule.RecordTypeid = rt1.get(inputvalues[scheduleFieldsMap.get('Tier')]);
            
            if (p21.get(inputvalues[scheduleFieldsMap.get('Product')]) == null)
               errorInfo = errorInfo + '<br>Invalid Product - ' + inputvalues[scheduleFieldsMap.get('Product')]; 
            else
               schedule.Product__c = p21.get(inputvalues[scheduleFieldsMap.get('Product')]);
            
            if (ispickval(listPrograms,inputvalues[scheduleFieldsMap.get('Program')]) == false) 
               errorInfo = errorInfo + '<br>Invalid Program - ' + inputvalues[scheduleFieldsMap.get('Program')]; 
            else   
               schedule.Program__c = inputvalues[scheduleFieldsMap.get('Program')];            
            
            if (u1.get(inputvalues[scheduleFieldsMap.get('User/Queue')]) == null) 
               errorInfo = errorInfo + '<br>Invalid User/Queue - ' + inputvalues[scheduleFieldsMap.get('User/Queue')];
            else
               schedule.Ownerid = u1.get(inputvalues[scheduleFieldsMap.get('User/Queue')]);

            try {           
               schedule.StartDate__c    = Date.parse(inputvalues[scheduleFieldsMap.get('Start Date')]);
            } catch (Exception e) {
               errorInfo = errorInfo + '<br>Invalid Start Date - ' + e.getMessage(); 
            }         

            try {           
               schedule.EndDate__c      = Date.parse(inputvalues[scheduleFieldsMap.get('End Date')]);
            } catch (Exception e) {
               errorInfo = errorInfo + '<br>Invalid End Date - ' + e.getMessage(); 
            }         
            
            if (schedule.EndDate__c < schedule.StartDate__c) {
               errorInfo = errorInfo + '<br>End Date should be greater than or equal to Start Date';
            }

            try {           
               schedule.StartTime__c    = inputvalues[scheduleFieldsMap.get('Start Time')];
            } catch (exception e) {
               errorInfo = errorInfo + '<br>Invalid Start Time - ' + e.getMessage();
            }
            
            try {                       
               schedule.EndTime__c      = inputvalues[scheduleFieldsMap.get('End Time')];
            } catch (exception e) {
               errorInfo = errorInfo + '<br>Invalid End Time - ' + e.getMessage();            
            }
            
            try {            
               schedule.CallSequence__c = integer.valueOf(inputvalues[scheduleFieldsMap.get('Call Sequence')]);
            } catch (exception e) {
               errorInfo = errorInfo + 'Invalid Call Sequence - ' + e.getMessage();            
            }
            
            try {
               if (ispickval(listCaseTypes,inputvalues[scheduleFieldsMap.get('Case Type')]) == false)
                  errorInfo = errorInfo + '<br>Invalid Case Type - ' + inputvalues[scheduleFieldsMap.get('Case Type')]; 
               else
                  schedule.CaseType__c     = inputvalues[scheduleFieldsMap.get('Case Type')];
            } catch (exception e) {
               errorInfo = errorInfo + '<br>Invalid Case Type - ' + e.getMessage();            
            }
                      
            oncallschedules.add(schedule);
        } catch (Exception e) {
            errorInfo = errorInfo + '<br>Unable to add the schedule - ' + e.getMessage();
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
         ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.Info,'Validated data successfully. Click on <Import Schedule> button to import the data.'));
         readyToImport = true;
      }
         
      return null;
   }
  
   public pageReference importData() {
      try {
         uploadStep = 3;
         insert oncallschedules;
         ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.Info,'Imported the schedule successfully.'));
      } catch (Exception e) {
         ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR,'Ooops! Unable to import the schedule: ' + e.getMessage()));
         readyToImport = false; 
         return null;                           
      }
      
      return null;
   } 
   
   public pageReference back() {
      uploadStep        = 1;
      fileName          = null;
      contentType       = null;
      oncallschedules   = null;
      readyToImport     = false;  
      errorCount        = 0;    
      return null;
   }
   
   public string cancel() {
      uploadStep        = 1;
      fileName          = null;
      contentType       = null;
      oncallschedules   = null;
      readyToImport     = false;
      errorCount        = 0;   
      return priorPage;
   }          
   
    @IsTest(SeeAllData=true) public static void testOnCallScheduleController() {        
       OnCallScheduleController controller = new OnCallScheduleController();
       
       //--- No File Name Test
       try {
          controller.readFile();
       } catch (Exception e) {
          //---Nothing
       }
       
       //--- Invalid Content Type Test
       try {
         controller = new OnCallScheduleController();
         controller.fileName = 'test.xls';
         controller.contentType = 'abc';
         controller.readFile();
       } catch (Exception e) {
         //---Nothing
       }
       
       //--- Invalid Columns
       try {
         controller = new OnCallScheduleController();
         controller.fileName = 'test.xls';
         controller.contentType = 'application/vnd.ms-excel';
         
         controller.fileContent = blob.valueof('Tier,Product,Program,User/Queue,Start Date,End Date,Start Time1,End Time,Call Sequence,Case Type \n' +
                                  'Tier 5,ArcLight1,,Anton Hoffman,4/30/2012,5/17/2012,8:00,7:59,1,Outage;Degradation;Haz Con;Information\n' + 
                                  'Tier 7,ArcLight2,,Anton Hoffman1,4/31/2012,5/17/2012,8a:00,7:59,1,Outage1;Degradation;Haz Con;Information');
         controller.readFile();
       } catch (Exception e) {
         //---Nothing
       }
       
       //--- Less than required Columns
       try {
         controller = new OnCallScheduleController();
         controller.fileName = 'test.xls';
         controller.contentType = 'application/vnd.ms-excel';
         
         controller.fileContent = blob.valueof('Tier,Product,Program,User/Queue,Start Date,End Date,End Time,Call Sequence,Case Type \n' +
                                  'Tier 5,ArcLight1,,Anton Hoffman,4/30/2012,5/17/2012,8:00,7:59,1,Outage;Degradation;Haz Con;Information\n' + 
                                  'Tier 7,ArcLight2,,Anton Hoffman1,4/31/2012,5/17/2012,8a:00,7:59,1,Outage1;Degradation;Haz Con;Information');
         controller.readFile();
       } catch (Exception e) {
         //---Nothing
       }
       
       //--- No Data
       try {
         controller = new OnCallScheduleController();
         controller.fileName = 'test.xls';
         controller.contentType = 'application/vnd.ms-excel';
         
         controller.fileContent = blob.valueof('Tier,Product,Program,User/Queue,Start Date,End Date,End Time,Call Sequence,Case Type');
         controller.readFile();
       } catch (Exception e) {
         //---Nothing
       }       
       
       //--- Invalid data values
       try {
         controller = new OnCallScheduleController();
         controller.fileName = 'test.xls';
         controller.contentType = 'application/vnd.ms-excel';
         
         controller.fileContent = blob.valueof('Tier,Product,Program,User/Queue,Start Date,End Date,Start Time,End Time,Call Sequence,Case Type \n' +
                                  'Tier 5,ArcLight1,,Anton Hoffman,5/30/2012,4/17/2012,12345,7:59,1,Outage;Degradation;Haz Con;Information\n' + 
                                  'Tier 7,ArcLight2,abc,Anton Hoffman1,4/31/2012,5/32/2012,8a:00,7:59,a,ccc;Outage1;Degradation;Haz Con;Information');
         controller.readFile();
       } catch (Exception e) {
         //---Nothing
       }
       
       //--- Valid Test Case
       try {
         controller = new OnCallScheduleController();
         controller.fileName = 'test.xls';
         controller.contentType = 'application/vnd.ms-excel';
         
         controller.fileContent = blob.valueof('Tier,Product,Program,User/Queue,Start Date,End Date,Start Time,End Time,Call Sequence,Case Type \n' +
                                  'Tier 5,ArcLight1,,Anton Hoffman,4/30/2012,5/17/2012,12345,7:59,1,Outage;Degradation;Haz Con;Information'); 
         controller.readFile();
       } catch (Exception e) {
         //---Nothing
       }       
       
       controller.importData();
       PageReference p = controller.back();
       String s = controller.cancel();    
       
       Integer i = controller.uploadStep;
       i = controller.errorCount;
       Boolean b = controller.readyToImport;
    }       
}