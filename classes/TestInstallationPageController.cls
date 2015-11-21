public class TestInstallationPageController {
    
    public string selectedSlot {get;set;}
    public Map<string,installTime> datesMap {get;set;}
    public  Set<string> monthsList {get;set;}
    public  List<string> monthsListtoSend {get;set;}
    public  Set<string> datesList {get;set;}
    public  List<string> datesListtoSend  {get;set;}
    public  date previousdate;
    public  installTime times;
    public string installXml = 
    '<soap:Envelope xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">'+
   '<soap:Body>'+
      '<getAvailableInstallDatesResponse xmlns="http://services.webservice.wildblue.com/">'+
        ' <scheduleDate>'+
            '<fromDate>2015-10-18T14:00:00Z</fromDate>'+
            '<toDate>2015-10-18T17:00:00Z</toDate>'+
         '</scheduleDate>'+
         '<scheduleDate>'+
            '<fromDate>2015-10-18T17:00:00Z</fromDate>'+
            '<toDate>2015-10-18T20:00:00Z</toDate>'+
         '</scheduleDate>'+

         '<scheduleDate>'+
            '<fromDate>2015-10-19T17:00:00Z</fromDate>'+
           ' <toDate>2015-10-19T20:00:00Z</toDate>'+
         '</scheduleDate>'+
         '<scheduleDate>'+
            '<fromDate>2015-10-19T11:00:00Z</fromDate>'+
            '<toDate>2015-10-19T14:00:00Z</toDate>'+
         '</scheduleDate>'+
         '<scheduleDate>'+
            '<fromDate>2015-11-11T14:00:00Z</fromDate>'+
            '<toDate>2015-10-11T17:00:00Z</toDate>'+
         '</scheduleDate>'+
         '<scheduleDate>'+
            '<fromDate>2015-11-11T17:00:00Z</fromDate>'+
            '<toDate>2015-10-11T20:00:00Z</toDate>'+
         '</scheduleDate>'+
         '<scheduleDate>'+
            '<fromDate>2015-10-21T11:00:00Z</fromDate>'+
            '<toDate>2015-10-21T14:00:00Z</toDate>'+
         '</scheduleDate>'+
         '<scheduleDate>'+
            '<toDate>2015-10-22T14:00:00Z</toDate>'+
         '</scheduleDate>'+
         '<scheduleDate>'+
            '<fromDate>2015-10-22T08:00:00Z</fromDate>'+
            '<toDate>2015-10-22T11:00:00Z</toDate>'+
        ' </scheduleDate>'+
         '<scheduleDate>'+
            '<fromDate>2015-11-03T14:00:00Z</fromDate>'+
            '<toDate>2015-11-03T17:00:00Z</toDate>'+
         '</scheduleDate>'+
         '<scheduleDate>'+
            '<fromDate>2015-11-03T17:00:00Z</fromDate>'+
            '<toDate>2015-11-03T20:00:00Z</toDate>'+
         '</scheduleDate>'+
         '<scheduleDate>'+
            '<fromDate>2015-11-03T11:00:00Z</fromDate>'+
            '<toDate>2015-11-03T14:00:00Z</toDate>'+
         '</scheduleDate>'+
         '<scheduleDate>'+
            '<fromDate>2015-11-05T08:00:00Z</fromDate>'+
            '<toDate>2015-11-05T11:00:00Z</toDate>'+
         '</scheduleDate>'+
 
         
         '<scheduleDate>'+
            '<fromDate>2015-10-25T14:00:00Z</fromDate>'+
            '<toDate>2015-10-25T17:00:00Z</toDate>'+
         '</scheduleDate>'+
         '<scheduleDate>'+
            '<fromDate>2015-10-25T17:00:00Z</fromDate>'+
            '<toDate>2015-10-25T20:00:00Z</toDate>'+
        ' </scheduleDate>'+
         '<scheduleDate>'+
            '<fromDate>2015-10-25T11:00:00Z</fromDate>'+
            '<toDate>2015-10-25T14:00:00Z</toDate>'+
         '</scheduleDate>'+

         '<scheduleDate>'+
            '<fromDate>2015-10-31T17:00:00Z</fromDate>'+
            '<toDate>2015-10-31T20:00:00Z</toDate>'+
         '</scheduleDate>'+
         '<scheduleDate>'+
            '<fromDate>2015-10-31T11:00:00Z</fromDate>'+
            '<toDate>2015-10-31T14:00:00Z</toDate>'+
         '</scheduleDate>'+
         '<scheduleDate>'+
           ' <fromDate>2015-10-31T08:00:00Z</fromDate>'+
            '<toDate>2015-10-31T11:00:00Z</toDate>'+
        ' </scheduleDate>'+
     ' </getAvailableInstallDatesResponse>'+
  ' </soap:Body>'+
'</soap:Envelope>';

    
    
    
    public TestInstallationPageController() {
        monthsList = new Set<string>();
        monthsListtoSend = new List<string>();
        datesList = new Set<string>();
        datesListtoSend = new List<string>();
        
        
    }
    
    public PageReference testLinkAction() {
        selectedSlot  = ApexPages.CurrentPage().getParameters().get('paramName');
        System.debug('---selectedSlot : '+selectedSlot ); 
        return null;   
    }
    
    public class installTime{
        public boolean slot1{get;set;}
        public boolean slot2{get;set;}
        public boolean slot3{get;set;}
        public boolean slot4{get;set;}
                  
        public installTime(boolean slot1,boolean slot2,boolean slot3,boolean slot4) {
            this.slot1= slot1;
            this.slot2= slot2;
            this.slot3= slot3;     
            this.slot4= slot4;                
        }    
    }
    public void testDatesCallout() { 
        parseXML(installXml);
    }
    
    // Method for Parsing response XML 
    public Map<string,installTime> parseXML(String toParse) {
       datesMap = new Map<string,installTime>();
       
       DOM.Document doc = new DOM.Document();      
       try {                         
          Date d = date.today();
          datetime myDateTime = datetime.newInstance(d.year(), d.month(), d.day()); 
          String dayOfWeek = myDateTime.format('u');
          integer modDay = integer.valueOf(dayOfWeek);
          system.debug('---modDay ---> '+ modDay);
          date startDate = date.today().addDays(-modDay);
          system.debug('---startDate ---> '+ startDate );
          
          List<date> allDates= new List<date>(); 
          for(integer i=0;i<30;i++) {
               date dt = startDate.addDays(i);
               date myDate = date.newInstance(dt.year(), dt.month(), dt.day()); 
               String dateOutput = String.valueOf(myDate);
               allDates.add(myDate);
               installTime times= new installTime(false,false,false,false);
               datesMap.put(dateOutput,times); 
               //--- Building Dates List String
               //2015-10-18
               String[] strDate = dateOutput.split('-');       
               datesList.add(dateOutput);
          }
                    
          doc.load(toParse);    
          DOM.XMLNode root = doc.getRootElement();
                     
          //Parsing and updating the map
          walkThrough(root, datesMap);  
          system.debug('---monthsList---> '+monthsList);
          system.debug('---datesMap after---> '+datesMap);
          
          monthsListtoSend.addAll(monthsList);
          datesListtoSend.addAll(datesList);
          system.debug('---datesListtoSend---> '+datesListtoSend);
                       
       } catch (System.XMLException e) {  
            // invalid XML
       }          
       return datesMap;
    }        
    public void walkThrough(DOM.XMLNode node, Map<string,installTime> datesMap) {       
       String result = '\n';
       if (node.getNodeType() == DOM.XMLNodeType.COMMENT) {
          return;
       }
       if (node.getNodeType() == DOM.XMLNodeType.TEXT) {
          return;
       }
       if (node.getNodeType() == DOM.XMLNodeType.ELEMENT) {
           if(node.getName().trim() != '' && node.getName()=='fromDate') {
               string lsElement = node.getText();
               //2015-10-23T17:00:00Z
               String[] str = lsElement.split('-');               
               String[] timeString = str[2].split(':');
               String substring = timeString[0].substring(Math.max(timeString[0].length() - 2, 0));              
               String dateOnly1= timeString[0].substring(0,2);
               date currentdate = date.newinstance(Integer.valueOf(str[0]), Integer.valueOf(str[1]), Integer.valueOf(dateOnly1)); 
               system.debug('---previousdate---> '+previousdate);
               system.debug('---currentdate ---> '+currentdate);
               string monthName= monthsMap.get(str[1]);              
               if(!monthsList.contains(monthName)) {
                   monthsList.add(monthName);
               } 
               //--- To support the same date response - if response contains a different date, the times object is reset
               if(previousdate!=currentdate) {
                   times= new installTime(false,false,false,false);                                      
               }                                                
                               
               if(substring=='08') 
                   times.slot1=true;
               else if (substring=='11')  
                   times.slot2=true;
               else if (substring=='14')  
                   times.slot3=true;
               else if (substring=='17')  
                   times.slot4=true;
                String dateOutput = String.valueOf(currentdate);   
                if(datesMap.containsKey(dateOutput)) {
                    system.debug('---map contains key---'); 
                    datesMap.remove(dateOutput);
                    datesMap.put(dateOutput,times);  
                
                }                     
               previousdate = currentdate;       
             
           }         
          for (Dom.XMLNode child: node.getChildElements()) {
            walkThrough(child, datesMap);
          } 
          return;
       }
       return;  //should never reach here          
    }  
    public static Map<String, String> monthsMap = new Map<String, String> {
        '1' => 'January','2' => 'February','3' => 'March','4' => 'April',
        '5' => 'May','6' => 'June','7' => 'July','8' => 'August',
        '9' => 'September','10' => 'October','11' => 'November','12' => 'December'
    };          
    
}