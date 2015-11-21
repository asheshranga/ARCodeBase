/********************************************************************************************************************************************************************************************************
Created By    : Nazeer Ahamed
Use of Class  : 
Company Name  : NTT DATA,Inc. 
Modified By   : Nazeer Ahamed
*********************************************************************************************************************************************************************************************************/

public with sharing class SparesLookupController
{
    public OrderPrice__c OrderPrice {get;set;}        // new OrderPrice to create
    public Order__c o {get;set;}
    public Contract c {get;set;}
    public List<OrderPrice__c> results{get;set;}  // search results
    public string searchString{get;set;}          // search keyword
    public string WarrantyName{get;set;}
    public string ContractSparesPL{get;set;}
    public String orderID{get;set;}    
    
    
    //----------------------------------------Constructor for class
      
    Public SparesLookupController()
    {
        orderID=System.currentPageReference().getParameters().get('orderid');
        
       Order__c o=[select id,contract__c from order__c where name=:orderID];
    
        
        
        Contract c=[select Spares_Price_List__r.name,Spares_Price_List__c from Contract where ContractNumber=:o.contract__c]; 
        ContractSparesPL=c.Spares_Price_List__r.name;
        
        OrderPrice = new OrderPrice__c();
        searchString = System.currentPageReference().getParameters().get('lksrch');
        //results = [Select id, Name ,Product_Category__c ,Product__c,ProductDescription__c,Price__c,PriceList__r.name from OrderPrice__c where /*Product_Category__c = 'Spares'and */PriceList__r.name=:ContractSparesPL];
        results = [Select id, Name ,Product_Category__c ,Product__r.Name, Product__c,ProductDescription__c,Price__c,PriceList__r.name from OrderPrice__c where /*Product_Category__c = 'Spares'and */PriceList__r.name=:ContractSparesPL and (product__r.ProductExpirationDate__c = NULL OR product__r.ProductExpirationDate__c >= Today)];
        if(results.size()==0)
        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'There are no Spare Products'));
    }
    
    //------------------------------------------performs the keyword search
    
    public PageReference search()
    {
        runSearch();
        return null;
    }
    
    //------------------------------------------ prepare the query and issue the search command
    
    public void runSearch() 
    {
    //TODO prepare query string for complex serarches & prevent injections
        results = performSearch(searchString);         
    } 
   
    //----------------------------------------- run the search and return the records found.
     
    @TestVisible private List<OrderPrice__c> performSearch(string searchString) 
    {
              
     // String Soql = 'select id, Name ,Product_Category__c,Product__c,ProductDescription__c,Price__c from OrderPrice__c where PriceList__r.name=\''+ ContractSparesPL +'\' and Product_Category__c = \'Spares\'';     
        String Soql = 'select id, Name ,Product__r.Name,Product_Category__c,Product__c,ProductDescription__c,Price__c from OrderPrice__c where PriceList__r.name=:ContractSparesPL and (product__r.ProductExpirationDate__c = NULL OR product__r.ProductExpirationDate__c >= Today)';      
        if(searchString != '' && searchString != null)
            soql = soql +  ' and Product__r.name LIKE \'%' + searchString +'%\'';
            soql = soql + 'order by name limit 25';                                               
            ApexPages.getMessages().clear();
            
            List<OrderPrice__c> Ord = database.query(soql);    
                if (Ord .size() >= 25)    
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'Search results have been restricted to first 25 rows. Found more than 25+ rows, please refine the search.'));
                if (Ord .size() == 0)    
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'No records found, please refine the search.'));    
                return Ord ;  
    }
    
    //--------------------------------------- used by the visualforce page to send the link to the right dom element
    public string getFormTag() 
    {
        return System.currentPageReference().getParameters().get('frm');
    }
    
    //--------------------------------------- used by the visualforce page to send the link to the right dom element for the text box
    public string getTextBox() 
    {
        return System.currentPageReference().getParameters().get('txt');
    }
}