/*************************************************************************************************************************************************************************************
Created By    : Nazeer Ahamed
Use of Class  : 
Company Name  : NTT DATA,Inc. 
Modified By   : Nazeer Ahamed
**************************************************************************************************************************************************************************************/

public class Tooway_Thankyou 
{
    public String orderId;
    public Order__c order {get; set;}

    public Tooway_Thankyou(ApexPages.StandardController controller) 
    {
    orderId = ApexPages.currentPage().getParameters().get('id');
    
	    if(orderId != null && orderId != '')
	    {
	    order = [select ID, Name from Order__c where id =: orderId ];
	    }

    }
    
    public PageReference createnew() 
    {
        return page.ToowayOrderAdmin;
    }

}