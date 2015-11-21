global class Tooway_OrderconfirmCompController
{
    public Id OrderID {get;set;}
    Private String TerminalString;
    public string emailBody;
    
    public String getTerminalString() 
    {
        List<OrderLine__c> OLTermlist;
        OLTermlist = [SELECT Order__c,Part_Description__c,Order_Price__r.Product_Category__c,Quantity__c,Unit_Price__c,LinePrice__c,Is_Spares__c,Random_Number__c FROM OrderLine__c WHERE Order__c =: OrderID AND Is_Spares__c = false ORDER BY Random_Number__c, Product_Category__c];
              
        emailBody = '<style type="text/css">.temp {border-style:solid;border-top-style:none;border-left-style:none;border-right-style:none;border-bottom-width:1px;}';
        emailBody = emailBody + '.temp2 {border-style:solid;border-top-width:1px;border-left-style:none;border-right-style:none;border-bottom-style:none;}'; 
        emailBody = emailBody + '.temp3 {border-style:solid;border-top-width:1px;border-right-style:none;border-left-width:0px;border-bottom-style:none;}';
        emailBody = emailBody + '.temp4 {border-style:solid;border-top-width:1px;border-right-width:0px;border-left-style:none;border-bottom-style:none;}';
        emailBody = emailBody + '.temp5 {border-style:solid;border-top-width:1px;border-left-style:none;border-right-style:none;border-bottom-width:1px;}'; 
        emailBody = emailBody + '</style><table style="width:100%;border-collapse:collapse;border:1px solid black;"><tr><th>Terminal Details</th><th>Quantity</th><th>Unit Price</th><th>Line Price</th></tr>';     
        for(orderline__c ol: OLTermlist)
        {  
        
           if(ol.Order_Price__r.Product_Category__c == 'Antenna')
            /* {
                emailBody = emailBody +'<tr>';
                emailBody = emailBody + '<td class="temp3">'+ ol.Part_Description__c +'</td>'; 
                emailBody = emailBody + '<td class="temp5" rowspan="3">'+ ol.Quantity__c +'</td>';
                emailBody = emailBody + '<td class="temp2">'+ ol.Unit_Price__c +'</td>';
                emailBody = emailBody + '<td class="temp4">'+ ol.LinePrice__c +'</td></tr>';
            }  */           
            
            {
                emailBody = emailBody +'<tr>';
                emailBody = emailBody + '<td class="temp3">'+ ol.Part_Description__c +'</td>'; 
                emailBody = emailBody + '<td class="temp2">'+ ol.Quantity__c +'</td>';
                emailBody = emailBody + '<td class="temp2">'+ ol.Unit_Price__c +'</td>';
                emailBody = emailBody + '<td class="temp4">'+ ol.LinePrice__c +'</td></tr>';
            }             


            
            if(ol.Order_Price__r.Product_Category__c == 'Modem')
            {
                emailBody = emailBody +'<tr>';
                emailBody = emailBody + '<td>'+ ol.Part_Description__c +'</td>'; 
                emailBody = emailBody + '<td>'+ ol.Quantity__c +'</td>';
                emailBody = emailBody + '<td>'+ ol.Unit_Price__c +'</td>';
                emailBody = emailBody + '<td>'+ ol.LinePrice__c +'</td></tr>';
            }      
            if(ol.Order_Price__r.Product_Category__c == 'Tria')
            {
                emailBody = emailBody +'<tr>';
                emailBody = emailBody + '<td>'+ ol.Part_Description__c +'</td>'; 
                emailBody = emailBody + '<td>'+ ol.Quantity__c +'</td>';
                emailBody = emailBody + '<td>'+ ol.Unit_Price__c +'</td>';
                emailBody = emailBody + '<td>'+ ol.LinePrice__c +'</td></tr>';
            }                 
        }
        emailBody = emailBody + '</table>';
        TerminalString = emailBody;
      return this.TerminalString;
    }
    public void setTerminalString(String TerminalString) 
    {
        this.TerminalString= TerminalString;
    }
}