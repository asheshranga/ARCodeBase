public with sharing class NbncoSLAReportableAnalysis
{

    // the soql without the order and limit
    @TestVisible private String soql {get;set;}  
    public String caseNumber{get; set;}
    public case caseObj{get;set;} 
    public String ownerName{get; set;}  
    public List<case> listCase=new list<case>();
    public List<case> listCasewithDescription=new list<case>();
    public string SelectedCaseId { get; set; } 
    public boolean SLAflagChecked{ get; set; } 
    
    //Set boolean variable to update cases
    Public Static Boolean NotSLAReportableReason{get;set;} 
    
    // the collection of custom setting "NBNCo KeyvalueStore"
    Public static Map<String,NBNCoKeyvalueStore__c> MapKeyValue= NBNCoKeyvalueStore__c.getAll(); 
    public String recordTypeNbnCo=MapKeyValue.get('NBNSupportServices').Value__c;    
    
    // the collection of case to display
    public List<Case> cases{get{return (List<Case>) setCon.getRecords();      
    }set;}   
    public boolean SortAscending{get;set;}
    // the current sort direction. defaults to asc
    public String sortDir {
        get  { if (sortDir == null) {  sortDir = 'asc'; } return sortDir;  }
        set;
    }
 
    // the current field to sort by. defaults to last name
    public String sortField {
        get  { if (sortField == null) {sortField = 'CaseNumber'; } return sortField;  }
        set;
    }
   
  
    // init the controller and display some sample data when the page loads
    public NbncoSLAReportableAnalysis() {
    
       NotSLAReportableReason=false;
       RecordType caserecordtype=[SELECT Id,Name FROM RecordType WHERE SObjectType = 'Case' AND recordType.name=:recordTypeNbnCo];
       this.caseObj= new Case();       
       this.caseObj.RecordtypeId=caserecordtype.Id;       
       SortAscending=false;   
       
       // case 363807 - PL Feb 2015 - use recordId
/*          
        soql = 'select id,CaseNumber,AccountName__c,Createddate,CaseResolvedDate__c,NBNCoCreateddate__c,Status,Subject,Description,SubSystem__c,Location__c,NBNCoImagePriority__c,OwnerId,' +
               'SLAReportable__c,NotSLAReportableReason__c,OtherReason__c,NBN_DateActionIndentified__c from Case Where (AccountName__c like \'%'+String.escapeSingleQuotes(MapKeyValue.get('NBNCo').Value__c)+'%\' OR Recordtype.Name Like \'%'+recordTypeNbnCo+'%\')';
*/
 		soql = 'select id,CaseNumber,AccountName__c,Createddate,CaseResolvedDate__c,NBNCoCreateddate__c,Status,Subject,Description,SubSystem__c,Location__c,NBNCoImagePriority__c,OwnerId,' +
               'SLAReportable__c,NotSLAReportableReason__c,OtherReason__c,NBN_DateActionIndentified__c from Case Where recordtypeId= \'' + caserecordtype.Id + '\'';

        soql +=  ' AND ((Status =\'New\' OR Status =\'In Progress\') OR ((DaysDifference__c<=30 AND Status =\'Closed\') OR (CaseResolveddaysdifference__c<=30 AND Status =\'Resolved\')))'; 
        
          } 
            

    // toggles the sorting of query from asc<-->desc
    public void toggleSort() {
        // simply toggle the direction    
       if(sortDir=='asc')
               {
                 sortDir ='desc';
                 SortAscending=true;
               }
       else
               {
                 sortDir ='asc';
                 SortAscending=false;
               }
        // run the query again
        runQuerySearch();
    }
  
    // ApexPages.StandardSetController must be instantiated     
    // for standard list controllers     
    public ApexPages.StandardSetController setCon {
        get {
            if(setCon == null) {
                setCon = new ApexPages.StandardSetController(Database.getQueryLocator(soql + ' order by ' + sortField + ' ' + sortDir));
           }
            return setCon;
        }
        set;
    }

    // Initialize setCon and return a list of records     
    public List<Case> getCases() {   
       return (List<Case>) setCon.getRecords();
      }
    
    public Integer resultSize {
        get {return setCon.getResultSize();}
        set;
    }
    
    public Boolean hasPrev {
        get {return setCon.getHasPrevious();}
        set;
    }

    public Boolean hasNext {
        get {return setCon.getHasNext();}
        set;
    }

    public String recordInfo { 
        get { return (resultSize == 0) ? '':((setCon.getPageNumber() - 1) * setCon.getPageSize() + 1) + ' - ' + 
                    ((setCon.getPageNumber() * setCon.getPageSize()) < setCon.getResultSize() ? (setCon.getPageNumber() * setCon.getPageSize()) : setCon.getResultSize()) + ' of ' +
                    setCon.getResultSize(); } 
        set;
    }    
    
    public String pageInfo { 
        get { return (resultSize == 0) ? '':'Page ' + setCon.getPageNumber() + ' of ' + 
                    (((setCon.getResultSize()/setCon.getPageSize())*setCon.getPageSize() == setCon.getResultSize()) ? (setCon.getResultSize() / setCon.getPageSize()) : (setCon.getResultSize() / setCon.getPageSize()+1));} 
        set;
    }    
    
    public void next() {
        setCon.next();
    }
    
    public void previous() {
        setCon.previous();
    }
    
    public void first() {
        setCon.first();
    }
    
    public void last() {
        setCon.last();
    }
      
    public void runQuerySearch(){
       try {
           listCase=Database.Query(soql + ' order by ' + sortField + ' ' + sortDir);   
         
            if(listCase.size()>0)
               {
                for(Case c:listCase)
                  {
                    listCasewithDescription.add(c);
                   }
                 listCase.clear();
                } 
            
           if(caseObj.description!=Null)
             {               
               for(Case c:listCasewithDescription)
                {                      
                   if(c.description!=Null)
                     {                                        
                     if(c.description.trim().replaceAll('(\\s+)','').toLowerCase().contains(caseObj.description.trim().replaceAll('(\\s+)', '').toLowercase()))
                       {               
                         listCase.add(c);
                       } 
                     }
                }                  
             }
          else {
                  listCase=Database.Query(soql + ' order by ' + sortField + ' ' + sortDir);
               }               
            listCasewithDescription.clear();  
                                          
        } catch (Exception e) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Ooops! ' + e.getMessage()));
         }  
        runQuery();  
      }
    // runs the actual query
    public void runQuery() {
        try {             
            setCon = new ApexPages.StandardSetController(listCase);     
        } catch (Exception e) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Ooops! ' + e.getMessage() + ' SQL - ' + soql + ' order by ' + sortField + ' ' + sortDir));
        }
    }
      // runs the actual query
    public void runQueryClear() {
        try {
            setCon = new ApexPages.StandardSetController(Database.getQueryLocator(soql + ' order by ' + sortField + ' ' + sortDir));             
        } catch (Exception e) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Ooops! ' + e.getMessage() + ' SQL - ' + soql + ' order by ' + sortField + ' ' + sortDir));
        }
    }
 
    // runs the search with parameters passed via Javascript
    public PageReference runSearch()
      {      
 		soql = 'select id,CaseNumber,AccountName__c,Createddate,CaseResolvedDate__c,NBNCoCreateddate__c,Status,Subject,Description,SubSystem__c,Location__c,NBNCoImagePriority__c,OwnerId,' +
               'SLAReportable__c,NotSLAReportableReason__c,OtherReason__c,NBN_DateActionIndentified__c from Case Where recordtypeId= \'' + this.caseObj.RecordtypeId + '\'';
//             'SLAReportable__c,NotSLAReportableReason__c,OtherReason__c,NBN_DateActionIndentified__c from Case Where (AccountName__c like \'%'+String.escapeSingleQuotes(MapKeyValue.get('NBNCo').Value__c)+'%\' OR Recordtype.Name Like \'%'+recordTypeNbnCo+'%\')'; 
        soql += ' AND ((Status =\'New\' OR Status =\'In Progress\') OR ((DaysDifference__c<=30 AND Status =\'Closed\') OR (CaseResolveddaysdifference__c<=30 AND Status =\'Resolved\')))';     
         if(!caseNumber.equals(''))
             caseNumber=caseNumber.trim();
             soql += ' and CaseNumber like \'%'+String.escapeSingleQuotes(caseNumber.trim())+'%\''; 
        if(caseObj.subject!=Null)
            {
             caseObj.subject=caseObj.subject.trim();
             soql += ' and Subject like \'%'+String.escapeSingleQuotes(caseObj.subject)+'%\'';  
            }     
        if(caseObj.SubSystem__c!=Null)
           {             
             caseObj.SubSystem__c=caseObj.SubSystem__c.trim();
             soql += ' and SubSystem__c like \'%'+String.escapeSingleQuotes(caseObj.SubSystem__c)+'%\'';   
           }
        if(caseObj.Location__c!=Null)
           {             
            caseObj.Location__c=caseObj.Location__c.trim();            
            soql += ' and Location__c like \'%'+String.escapeSingleQuotes(caseObj.Location__c)+'%\'';
           }   
        if(caseObj.NBNCoPrioritybasedonType__c!=Null)
           {
            caseObj.NBNCoPrioritybasedonType__c=caseObj.NBNCoPrioritybasedonType__c.trim();
            soql += ' and NBNCoImagePriority__c like \'%'+String.escapeSingleQuotes(caseObj.NBNCoPrioritybasedonType__c)+'%\'';    
           }       
        if(!ownerName.equals(''))
           {
            ownerName=ownerName.trim();
            soql += ' and Owner.name like \'%'+String.escapeSingleQuotes(ownerName)+'%\'';    
           } 
        if(caseObj.NBNStatus__c!=Null)
           {
            caseObj.NBNStatus__c=caseObj.NBNStatus__c.trim();
            soql += ' and Status like \'%'+String.escapeSingleQuotes(caseObj.NBNStatus__c)+'%\'';    
           }      
               
        if(caseObj.NotSLAReportableReason__c!=Null)
           {
            caseObj.NotSLAReportableReason__c=caseObj.NotSLAReportableReason__c.trim();
            soql += ' and NotSLAReportableReason__c like \'%'+String.escapeSingleQuotes(caseObj.NotSLAReportableReason__c)+'%\'';    
           }  
         if(caseObj.OtherReason__c!=Null)
           {
            caseObj.OtherReason__c=caseObj.OtherReason__c.trim();
            soql += ' and OtherReason__c like \'%'+String.escapeSingleQuotes(caseObj.OtherReason__c)+'%\'';    
           }  
        if(caseObj.DateActionIdentified__c!=Null)
           {   
                DateTime dT = System.now();
                Date systemDate = date.newinstance(dT.year(), dT.month(), dT.day());                
                Integer days = caseObj.DateActionIdentified__c.daysBetween(systemDate);                           
                soql += ' and NBN_DateActionIndentified__c='+days+''; 
           } 
                soql += ' and SLAReportable__c='+caseObj.SLAReportable__c; 
                  
        // run the query again
        runQuerySearch();      
        return null;
     }
   public PageReference clearSearch() { 
       // Map for RecordType
        Map<String, Schema.RecordTypeInfo> rtMap = Schema.SObjectType.Case.getRecordTypeInfosByName();      
        if(!caseNumber.equals(''))
           {
             caseNumber    = '';
           }      
        if(!ownerName.equals(''))
           {
             ownerName = '';
           }           
        if(caseObj!=null)
           {
             caseObj.clear();
           }   
         caseObj.RecordTypeId=rtMap.get(recordTypeNbnCo).getRecordTypeId();
                   
		soql = 'select id,CaseNumber,AccountName__c,Status,Subject,Createddate,CaseResolvedDate__c,NBNCoCreateddate__c,Description,SubSystem__c,Location__c,NBNCoImagePriority__c,OwnerId,' +
//             'SLAReportable__c,NotSLAReportableReason__c,OtherReason__c,NBN_DateActionIndentified__c from Case Where (AccountName__c like \'%'+String.escapeSingleQuotes(MapKeyValue.get('NBNCo').Value__c)+'%\' OR Recordtype.Name Like \'%'+recordTypeNbnCo+'%\')'; 
               'SLAReportable__c,NotSLAReportableReason__c,OtherReason__c,NBN_DateActionIndentified__c from Case Where recordtypeId= \'' + this.caseObj.RecordtypeId + '\'';
       soql += ' AND ((Status =\'New\' OR Status =\'In Progress\') OR ((DaysDifference__c<=30 AND Status =\'Closed\') OR (CaseResolveddaysdifference__c<=30 AND Status =\'Resolved\')))'; 
       // run the query again
        runQueryClear();     
        return null;
     }
  
   public void SLAReasonChecked()
   {      
      if (SelectedCaseId == null) {        
         return;
      }
       // find the Case record within the collection
    else
        { for(Case c : Cases)
             {    
              if(c.SLAReportable__c==false && c.NotSLAReportableReason__c==Null)
                {                     
                   ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Warning,+MapKeyValue.get('NotSLAReportableReason').Value__c));                    
                 }     
               if (c.Id == SelectedCaseId && c.SLAReportable__c==true) {
                    SLAflagChecked=true;  
                    c.NotSLAReportableReason__c=Null;  
                    c.OtherReason__c=Null; 
                 }
                else
                {
                   SLAflagChecked=false;
                }
             }
          } 
      }         
    
   Public void SLAReportableReason(){          
      for(Case c:cases)
          {                       
           if(c.SLAReportable__c==false && c.NotSLAReportableReason__c==Null)
               {     
                   NotSLAReportableReason=true;                  
                   ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Warning,+MapKeyValue.get('NotSLAReportableReason').Value__c));                                     
               }
           else if(c.NotSLAReportableReason__c==MapKeyValue.get('NBN_Other').Value__c && c.OtherReason__c==Null)
                {  
                   NotSLAReportableReason=true;                     
                   ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Warning,+MapKeyValue.get('OtherReason').Value__c));                          
                }  
           else if(c.NotSLAReportableReason__c!=MapKeyValue.get('NBN_Other').Value__c)
                {
                   c.OtherReason__c=null;                   
                }                   
           }          
      }
   public void saveCase() { 
     SLAReportableReason();
     if(cases.size()>0 && NotSLAReportableReason!=true)
        update cases;       
   }  
}