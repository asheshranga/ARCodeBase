public with sharing class CaseDashboardController
{
    public List<Case> top10cases = new List<case>();
    public List<Case> bottom10cases = new List<case>();
    Set<Id> bottom10casesId = new Set<Id>();
    Set<Id> top10casesId = new Set<Id>();
    Set<Id> UsersList = new Set<Id>();
    Id caseRecType;
    
    public CaseDashboardController()
    {
        
        for (UserGroupAssignment__c nocuser  : [Select User__c from UserGroupAssignment__c])
        {
        UsersList.add(nocuser.User__c);
        }
        
        caseRecType = [SELECT DeveloperName,Id,IsActive,SobjectType FROM RecordType where DeveloperName='Carlsbad_NOC' and SobjectType = 'Case'].Id;
        top10cases = [select id, casenumber, ProductId , Type, Category__c, OwnerId, site__c, site__r.name, site__r.AlternateSiteNames__c, subject, 
                                        status, createddate, account.name from Case where (Status='New' or Status='Working') and owner.userrole.name like '%NOC%' and recordtypeId=:caseRecType  
                                        and Ownerid in : UsersList order by createddate desc limit 10];
        /*bottom10cases = [select id, casenumber, ProductId, Type, Category__c, OwnerId, site__c, site__r.name, site__r.AlternateSiteNames__c, subject, status, 
                                        createddate, account.name from Case where (Status <> 'Closed' or Status <> 'Resolved') and owner.userrole.name like '%NOC%' and recordtypeId=:caseRecType 
                                        order by createddate asc limit 10];*/
        bottom10cases = [select id, casenumber, ProductId, Type, Category__c, OwnerId, site__c, site__r.name, site__r.AlternateSiteNames__c, subject, status, 
                                        createddate, account.name from Case where owner.userrole.name like '%NOC%' and recordtypeId=:caseRecType and Status in('New','Working') 
                                        and Ownerid in : UsersList order by createddate asc limit 10];
                  
        for(Case ct : top10cases )
            top10CasesId.add(ct.Id);
        for(Case cb : bottom10cases )
            bottom10CasesId.add(cb.Id);
    }
             
    public List<Case> getMaintenanceCases()
    {
        return [SELECT id, casenumber, site__c, site__r.name, site__r.AlternateSiteNames__c, subject, status, plannedstarttime__c, eventstarttime__c, createddate, account.name 
                FROM Case
                WHERE product.name in ('ArcLight1','ArcLight2')
                AND type = 'Maintenance' 
                AND status != 'Closed' 
                AND recordtypeId=:caseRecType
                ORDER BY eventstarttime__c, createddate desc];
    }
    
    public List<Case> getOutageCases() 
    {
        return [SELECT id, casenumber, site__c, site__r.name, site__r.AlternateSiteNames__c, subject, status, createddate, account.name 
                FROM Case
                WHERE type = 'Outage' 
                AND createddate >= YESTERDAY
                AND recordtypeId=:caseRecType
                ORDER BY createddate desc];
    }

    public List<Case> getNewCases() 
    {
        return [SELECT id, casenumber, site__c, site__r.name, site__r.AlternateSiteNames__c, subject, status, createddate, account.name 
                FROM Case
                WHERE status = 'New' 
                AND recordtypeId=:caseRecType
                ORDER BY createddate desc];
    } 
    
    //private String sortExp = 'createddate';
    //private String sortDirection = 'ASC'; 
@TestVisible    
    private String sortExp;
@TestVisible    
    private String sortDirection;                      
   
    public String sortExpression
    {
        get 
        {
            return sortExp;
        } 
        set
        {
            if (value == sortExp)
                sortDirection = (sortDirection == 'ASC')? 'DESC' : 'ASC';
            else
                sortDirection = 'ASC';
            sortExp = value;
        }
    }
    
    public String getSortDirection()
    {
        if (sortExpression == null || sortExpression == '')
            return 'ASC';
        else
            return sortDirection;
    }
    
    public void setSortDirection(String value)
    {  
        sortDirection = value;
    }
    
@TestVisible    
    private String sortExp1;
@TestVisible    
    private String sortDirection1;                      
   
    public String sortExpression1
    {
        get 
        {
            return sortExp1;
        } 
        set
        {
            if (value == sortExp1)
                sortDirection1 = (sortDirection1 == 'ASC')? 'DESC' : 'ASC';
            else
                sortDirection1 = 'ASC';
            sortExp1 = value;
        }
    }
    
    public String getSortDirection1()
    {
        if (sortExpression1 == null || sortExpression1 == '')
            return 'ASC';
        else
            return sortDirection1;
    }
    
    public void setSortDirection1(String value)
    {  
        sortDirection1 = value;
    }
  
    public Void Top10CasesSort() 
    {
        String sortFullExp = sortExpression  + ' ' + sortDirection;
        String soql = 'select id, casenumber,ProductId , Type, Category__c, OwnerId, site__c, site__r.name, site__r.AlternateSiteNames__c, subject, status, createddate, account.name from Case where Id in:top10CasesId order by ' + sortFullExp + ' limit 10'  ;
        top10cases = database.query(soql);        
    }
    
    public List<Case> getTop10Cases() 
    {
        return top10cases;
    }
        
     
    public Void Bottom10CasesSort()
     
    {
        String sortFullExp1 = sortExpression1  + ' ' + sortDirection1;
        String soql = 'select id, casenumber,ProductId , Type, Category__c, OwnerId, site__c, site__r.name, site__r.AlternateSiteNames__c, subject, status, createddate, account.name from Case where Id in :bottom10CasesId order by ' + sortFullExp1 + ' limit 10' ;
        bottom10cases=database.query(soql);
    }
    
    public List<Case> getBottom10Cases() 
    {     
        return bottom10cases;
    }
            
    //Case Detail Page reference
            
    public String rId{get;set;}
    public PageReference caseDetail()
    {
        //pagereference ref=new pagereference('https://viasat--devsup.cs3.my.salesforce.com/'+rId);
        String hostname = ApexPages.currentPage().getHeaders().get('Host');
        //pagereference ref=new pagereference('https://' + hostname + '/' + rId);
        //ref.setredirect(true);
        PageReference fullFileURL = new PageReference(URL.getSalesforceBaseUrl().toExternalForm() +'/' + rId);
            return fullFileURL ;
        //return ref;        
    }
}