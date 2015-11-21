Public class CaseReasonForOutage{
public Case caseinfo{get;set;}
public boolean ShowRFO{get;set;}

RecordType rt=[SELECT Id,Name FROM RecordType WHERE SObjectType = 'Case' AND recordType.name='Carlsbad NOC'];
Profile ProfileName= [SELECT Id, Name FROM Profile WHERE Id=:userinfo.getProfileId()]; 

public CaseReasonForOutage(ApexPages.StandardController controller){  
         ShowRFO=false;       
         caseinfo=[select id,status,Timeline__c,RootCause__c,FutureMitigation__c, Type from Case where id=:ApexPages.currentPage().getParameters().get('Id')];
         if((caseinfo.status.equalsIgnoreCase('Closed')) && rt.name=='Carlsbad NOC' && (ProfileName.name=='ViaSat NOC Customer Portal'  && (caseinfo.Timeline__c!=Null || caseinfo.RootCause__c!=Null || caseinfo.FutureMitigation__c!=Null)))
         {
             ShowRFO=true;    
         }    
    }
}