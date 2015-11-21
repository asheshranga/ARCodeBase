/************************************************************************************************************************************************************
Created By    : Nazeer Ahamed
Use of Class  : 
Company Name  : NTT DATA,Inc. 
Modified By   : Nazeer Ahamed
*************************************************************************************************************************************************************/
public class OrderHomeController
{
    private String sortDirection = 'ASC';
    private String sortExp = 'Name';
    public boolean portalUser{get;set;}

    public String Partno { get; set; }
    public String Orderno { get; set; }
    public string orderId{get;set;}
    public string orderstatus{get;set;}
    public string accountname{get;set;}
    public string customerPO{get;set;}
    public string cdate{get;set;}
    public Id orderRecordType;
    //  Constructor for class
    
    public OrderHomeController() 
    {   
        string userId=UserInfo.GetUserId();
        portalUser = false;   
        
        orderRecordType = [SELECT Id FROM RecordType WHERE SobjectType = 'Order__c' AND DeveloperName = 'Order'].Id;
        
        if(userId != '')  
            userlst =[select name,contactid from User where id = :userId];
        
        contactList = [select name,id,Accountid from Contact where id = :userlst.Contactid];

        if(contactList.size() > 0)
        {
            myOrderList = [select Name,Account__c,Total_Cost__c,Requestor__c, TotalLines__c, Status__c,OracleOrder__c, createdDate,AccountName__c,CustomerPO__c  from Order__c where Account__c = :contactList[0].Accountid and status__c ='Pending Submission' and recordtypeid=:orderRecordType order by  CreatedDate desc];     
            portalUser = true;
        }   
    }

    User userlst = new User();
    List<Contact> contactList = new List<Contact>();
    List<Order__c> myOrderList = new List<Order__c>();
    
    public String sortExpression
    {
        get {
            return sortExp;
        } 
        set{
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
    
    public List<Order__c> getOrderList()
    {
        return myOrderList;
    }
    
    public void sortingdata()
    {
        String sortFullExp = sortExpression  + ' ' + sortDirection;
        if(!portalUser)
        {
            if(sortFullExp != null)
            {
                String soql;
                soql='select Name,Account__c,Requestor__c, TotalLines__c, Status__c,OracleOrder__c,Total_Cost__c, createdDate,AccountName__c,CustomerPO__c from Order__c where recordtypeid=:orderRecordType';

                if(Status=='' || Status!='All')
                    soql+=' and status__c = \''+Status+'\'';
                else
                    soql+=' and status__c !=null';
                if (accountname!='' && accountname != null)
                    soql += ' and AccountName__c LIKE \''+'%'+accountname+'%'+'\'';
                if (orderno !='')
                    soql += ' and name LIKE \''+'%'+orderno+'%'+'\'';        
                if (customerPO !='')
                    soql += ' and CustomerPO__c LIKE \''+'%'+customerPO+'%'+'\'';       
                if (cdate!= null)
                    soql += ' and createdDate ='+cdate;         
                if (partno != null && partno != '')
                    soql += ' and id IN (Select order__c From orderline__c where ProductName__c LIKE \''+'%'+Partno+'%'+'\')';                         

                soql += 'order by ' + sortFullExp + ' limit 1000';
                system.debug('print sorting non portal SOQL'+soql);
                myOrderList = database.query(soql);
            }
        }  
        else if(portalUser)
        {
            if(sortFullExp != null)
            {
                String soql;           
                soql='select Name,Account__c,Requestor__c, TotalLines__c, Status__c,OracleOrder__c,Total_Cost__c, createdDate,AccountName__c,CustomerPO__c from Order__c where recordtypeid=:orderRecordType and Account__c =\''+contactList[0].accountid+'\'';

                if(Status=='' || Status!='All')
                    soql+=' and status__c = \''+Status+'\'';
                else
                    soql+=' and status__c !=null';        
                if (accountname != '' && accountname != null)
                    soql += ' and AccountName__c LIKE \''+'%'+accountname+'%'+'\'';        
                if (orderno !='')
                    soql += ' and name LIKE \''+'%'+orderno+'%'+'\'';
                if (customerPO !='')
                    soql += ' and CustomerPO__c LIKE \''+'%'+customerPO+'%'+'\'';         
                if (cdate!= null)
                    soql += ' and createdDate ='+cdate;             
                if (partno != null && partno != '')
                    soql += ' and id IN (Select order__c From orderline__c where ProductName__c LIKE \''+'%'+Partno+'%'+'\')';                                
            
                soql += ' order by ' + sortFullExp + ' limit 1000'; 
                system.debug('print sorting portal SOQL'+soql);
                myOrderList = database.query(soql);
            }
        }    
    }
    public void Search()
    {
        string soql;      
        
        if(!portalUser) 
        {
            soql='select Name,Account__c,Requestor__c, TotalLines__c, Status__c,OracleOrder__c,Total_Cost__c, createdDate,AccountName__c,CustomerPO__c from Order__c where recordtypeid=:orderRecordType';             
            if(Status=='' || Status!='All')
                soql+=' and status__c = \''+Status+'\'';
            else
                soql+=' and status__c !=null';
            if (accountname !='' && accountname != null)
                soql += ' and AccountName__c LIKE \''+'%'+accountname+'%'+'\'';        
            if (orderno !='')
                soql += ' and name LIKE \''+'%'+orderno+'%'+'\'';             
            if (customerPO !='')
                soql += ' and CustomerPO__c LIKE \''+'%'+customerPO+'%'+'\'';            
            if (cdate!= null)
                soql += ' and createdDate ='+cdate;           
            if (partno != null && partno != '')
                soql += ' and id IN (Select order__c From orderline__c where ProductName__c LIKE \''+'%'+Partno+'%'+'\')';             

            soql += ' order by ' + 'CreatedDate Desc'+ ' limit 1000';
            
            system.debug('print search non portal SOQL'+soql);
            myOrderList = database.query(soql);
             
            if(myOrderList.size()<=0)
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,'No records found'));        
        }
        else if(portaluser)
        { 
            soql='select Name,Account__c,Requestor__c, TotalLines__c, Status__c,OracleOrder__c,Total_Cost__c, createdDate,AccountName__c,CustomerPO__c from Order__c where recordtypeid=:orderRecordType and Account__c =\''+contactList[0].accountid+'\'';       

            if(Status=='' || Status!='All')
                soql+=' and status__c = \''+Status+'\'';
            else
                soql+=' and status__c !=null';
            if (orderno !='')
                soql += ' and name LIKE \''+'%'+orderno+'%'+'\'';      
            if (customerPO !='')
                soql += ' and CustomerPO__c LIKE \''+'%'+customerPO+'%'+'\'';        
            if (cdate!= null)
                soql += ' and createdDate ='+cdate;           
            if (partno != null && partno !='')
                soql += ' and id IN (Select order__c From orderline__c where ProductName__c LIKE \''+'%'+Partno+'%'+'\')';        
            soql += ' order by ' + 'CreatedDate Desc'+ ' limit 1000';       
            
            system.debug('print search portaluser SOQL'+soql);
            myOrderList = database.query(soql);   
            
            if(myOrderList.size() <= 0)
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,'No records found'));
        }
    }
    
    public PageReference Clear()
    {
        accountname='';
        partno='';
        customerPO='';
        orderno='';
        status='';
        cdate='';
       
        return null;
    }

    public String Status { get; set; } 
    public List<SelectOption> getdateOption() 
    {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('LAST_N_DAYS:1000','All'));
        options.add(new SelectOption('YESTERDAY','Yesterday'));
        options.add(new SelectOption('TODAY','Today'));
        options.add(new SelectOption('LAST_N_DAYS:7','Last 7 Days'));
        options.add(new SelectOption('LAST_N_DAYS:30','Last 30 Days'));
        return options;
    }

    public List<SelectOption> getStatusOption() 
    {
        List<SelectOption> options = new List<SelectOption>();         
        options.add(new SelectOption('Pending Submission','Pending Submission'));
        options.add(new SelectOption('All','All'));
        options.add(new SelectOption('Submitted','Submitted'));
        options.add(new SelectOption('Verified','Verified'));
        options.add(new SelectOption('Rejected','Rejected'));
        options.add(new SelectOption('Booked','Booked'));
        options.add(new SelectOption('Shipped','Shipped'));
        options.add(new SelectOption('Cancelled','Cancelled'));
        return options;
    }


    public PageReference GoOrderDetail() 
    {   
        PageReference fullFileURL = new PageReference(URL.getSalesforceBaseUrl().toExternalForm() +'/apex/ToowayOrderReview?id=' + orderId);
        return fullFileURL ;
    }

    public PageReference createnew() 
    {
        return page.ToowayOrderAdmin;
    }     
}