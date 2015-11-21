public without sharing class CaseCalloutCtrlr 
{
   public Case caseObj{get;set;}
   public boolean isActStatus{get;set;}
   public boolean isYTDStatus{get;set;}
   public boolean isActYTDStat{get;set;}
   private List<Case> caseActList=new List<case>();
   private List<Case> caseYTDList=new List<case>();
   Public static Map<String,NBNCoKeyvalueStore__c> MapKeyValue= NBNCoKeyvalueStore__c.getAll(); 
   String nbnAccountName = MapKeyValue.get('NBN_AccountName').Value__c;
   String nbnSupportServices = MapKeyValue.get('NBNSupportServices').Value__c;
   String nbnSubSystem = MapKeyValue.get('NBN_SubSystem').Value__c;

     
   public CaseCalloutCtrlr(ApexPages.StandardController controller) 
   {
       isActStatus = false;
       isYTDStatus = false;
       isActYTDStat = false;            
       caseObj = new Case();                        
 
/*                          
        String caseListQuery = 'SELECT CaseNumber, SubSystem__c, CalloutStatus__c, CreatedDate ';
        caseListQuery       += 'FROM Case ';
        caseListQuery       += 'WHERE (Account.Name = :nbnAccountName OR recordType.name = :nbnSupportServices) ';
        caseListQuery       += ' AND SubSystem__c in ( ';
        caseListQuery       += nbnSubSystem;
        caseListQuery       += ' ) ';       
*/        
        
   		// PL  case 288899 - base query on record type (id) instead of (record type name or company name) 
        RecordType caserecordtype=[SELECT Id,Name FROM RecordType WHERE SObjectType = 'Case' AND recordType.name=:+nbnSupportServices];        
        String recordTypeId = caserecordtype.Id;
         
        String caseListQuery = 'SELECT CaseNumber, SubSystem__c, CalloutStatus__c, CreatedDate ';
        caseListQuery       += 'FROM Case ';   
        caseListQuery       += 'WHERE (recordTypeId = :recordTypeId) ';       
        caseListQuery       += ' AND SubSystem__c in ( ';
        caseListQuery       += nbnSubSystem;
        caseListQuery       += ' ) ';           
                   
          
      List<Case> caseList = Database.query(caseListQuery);   
            
      if(caseList!=Null){
       for(case cases:caseList)
         {
              if(cases.CalloutStatus__c == MapKeyValue.get('Callout_Open').Value__c)
              {
                caseActList.add(cases);
              }
              if((cases.CalloutStatus__c == MapKeyValue.get('Callout_Open').Value__c || cases.CalloutStatus__c==MapKeyValue.get('Callout_Closed').Value__c) && cases.CreatedDate.Year() == Date.Today().Year())
              {
                caseYTDList.add(cases);
              } 
           }  
       } 
          
      if(caseActList.size() >= 3 && caseYTDList.size() >= 27  )
           {
               isActYTDStat = true;
               caseObj.ActiveCallouts__c = caseActList.size();
               caseObj.YTDCallouts__c = caseYTDList.size();           
           }
      else if(caseActList.size() >= 3)
           {
               isActStatus=true;
               caseObj.ActiveCallouts__c = caseActList.size();
               caseObj.YTDCallouts__c = caseYTDList.size();          
           }
      else if(caseYTDList.size() >= 27 )
           {
               isYTDStatus =true;
               caseObj.ActiveCallouts__c = caseActList.size();
               caseObj.YTDCallouts__c = caseYTDList.size(); 
           }           
   }
}