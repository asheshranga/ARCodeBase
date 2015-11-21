public with sharing class  OrderlinesCSVController{

    public String fileName {get;set;}
    public string id{get;set;}
    public string header{get;set;}
    public List<OrderLine__c> orderlines{get;set;}  
    
    public OrderlinesCSVController() {
        fileName = 'RMA Warranty Check Results';           
        header = 'Part Number,Serial Number,Failure Description,Part Number Description, In Warranty';        
        Map<String,String> params = ApexPages.currentPage().getParameters();      
        id= params.get('id');
        //--- Get the order lines...
        orderlines = getOrderLines(id); 
        system.debug('---orderlines--->'+ orderlines); 
    } 
    
    private List<OrderLine__c> getOrderLines(String asId)
    {
    //------- Added for unchecking checked order line item for deletion
        list<OrderLine__c> delunchecklist= new list<OrderLine__c>();
        list<OrderLine__c> Temp= new list<OrderLine__c>();
        delunchecklist = [Select Id, name, PartNumber__c, Part_Number_2__c, SerialNo__c, ErrorCode__c, ErrorDescription__c,Marked_For_Deletion__c , 
                        ShipToAddress__c,ShipToAddress__r.EBSAddressID__c, Product_Description__c, ReturnReasonDescription__c, Item_Description__c,InWarranty__c
                        from OrderLine__c 
                        where order__c = :asId order by CreatedDate];
        //ordl.Marked_For_Deletion__c == true
        for(OrderLine__c ordl : delunchecklist)
        {           
            Temp.add(ordl);      
        }
        return Temp;
    }
        
}