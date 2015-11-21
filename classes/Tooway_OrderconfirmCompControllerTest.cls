@isTest(seeAllData=true)
public class Tooway_OrderconfirmCompControllerTest
{  
    static testmethod void Tooway_OrderconfirmCompControllerTest1()
    {
            OrderPriceList__c OrderPrice = new OrderPriceList__c();
            OrderPrice.Name='test';
            OrderPrice.CurrencyIsoCode='USD';
            insert OrderPrice;
    
            Account acc=new Account();
            acc.Name='test';
            acc.CurrencyIsoCode='USD';
            acc.BillingStreet = 'DLF';
            acc.BillingCity = 'Chennai';
            acc.BillingState = 'Tamil Nadu';
            insert acc;
            
            Contact con = new Contact();
            con.CurrencyIsoCode='USD';
            con.FirstName = 'Testing';
            con.LastName='TEST';
            con.Phone = '7299552264';
            con.Accountid=acc.id; 
            insert con;
            
            Address__c add = new Address__c();
            add.Address__c='asd';
            add.Type__c='Ship To';
            add.VAT__c = 'Add';
            add.Default__c = true;
            add.account__c =con.Accountid;
            add.End_Date__c = date.today()+1;
            add.name='Address1';
            insert add;
            
            Address__c add1 = new Address__c();
            add1.Address__c='asd123';
            add1.Type__c='Bill To';
            add1.VAT__c = 'Add';
            add1.Default__c = true;
            add1.account__c = con.Accountid;
           //add1.End_Date__c = date.today()+1;
            insert add1;
            
            Product2 pdt1 = new Product2();
            pdt1.CurrencyIsoCode = 'USD';
            pdt1.Name='Spares';
            pdt1.Product_Category__c='Spares';
            insert pdt1;
            
            Product2 pdt2 = new Product2();
            pdt2.CurrencyIsoCode = 'USD';
            pdt2.Name='Spares2';
            pdt2.Product_Category__c='Modem';
            insert pdt2;
            
            Product2 pdt3 = new Product2();
            pdt3.CurrencyIsoCode = 'USD';
            pdt3.Name='Spares3';
            pdt3.Product_Category__c='Tria';
            insert pdt3;        
     
            OrderPrice__c OrderP = new OrderPrice__c();
            OrderP.Product__c=pdt1.id;
            OrderP.Price__c = 500; 
            OrderP.PriceList__c=OrderPrice.id;  
            
            Product2 pdt = new Product2();
            pdt.CurrencyIsoCode = 'USD';
            pdt.Name = 'TEST';
            pdt.Product_Category__c='Antenna';
            insert pdt;        
        
            OrderPrice__c op=new OrderPrice__c();
            op.Product__c=pdt.id;
            op.Price__c=500; 
            op.PriceList__c=OrderPrice.id;     
            insert op;
            
            OrderPrice__c op1=new OrderPrice__c();
            op1.Product__c=pdt2.id;
            op1.Price__c=500; 
            op1.PriceList__c=OrderPrice.id;     
            insert op1;
            
            OrderPrice__c op2=new OrderPrice__c();
            op2.Product__c=pdt3.id;
            op2.Price__c=500; 
            op2.PriceList__c=OrderPrice.id;     
            insert op2;
    
            Contract contract = new Contract();
            contract.AccountId = acc.id;
            contract.Payment_Terms__c = 'Net 30';
            contract.Delivery_Method__c ='ViaSat direct ship (cost + 15%)';
            contract.Business_Type__c ='Tooway';
            insert contract; 
            
            Contract contract1 = new Contract();
            contract1.AccountId = acc.id;
            contract1.Payment_Terms__c = 'Net 30';
            contract1.Delivery_Method__c ='ViaSat direct ship (cost + 15%)';
            contract1.Business_Type__c ='Tooway';
            insert contract1; 
            System.assertequals(contract1.accountid,acc.id);
            Contract con3 = [Select contractnumber,EndDate,Delivery_Method__c,Payment_Terms__c from Contract where AccountId =:acc.id and Business_Type__c='Tooway' limit 1];
            
            Order__c order = new Order__c();          
            order.Account__c=acc.id;
            order.Status__c = 'Submitted';   
            order.ShipToAddress__c = add.id;
            order.BillToAddress__c = add1.id;
            order.NotesComments__c = 'Test';
            order.Contract__c = contract.ContractNumber;
            order.Task__c = 'Test';
            order.AgreetoTermsConditions__c =false;
            order.Requested_Delivery_Datepl__c='Delivered By';
            order.Delivery_Method__c=contract.Delivery_Method__c;
            order.Payment_Terms__c=contract.Payment_Terms__c;
            order.Contract_Exp_Date__c = contract.EndDate;
            insert order;  
            order.Forecast_Delivery_Date__c = system.today();
            order.Status__c = 'Verified';   
            update order;
                        
            orderline__c ol=new orderline__c();
            ol.Is_Spares__c = false;
            ol.SerialNo__c='123';
            ol.ShipToAddress__c = add.id;
            ol.PartNumber__c = pdt.id;
            ol.Quantity__c = 2;
            ol.Order__c = order.id;
            ol.Order_Price__c=op.id;
            ol.Product_Category__c=pdt.id;
            ol.Related_Antenna__c=pdt.id;
            ol.status__c='All';
            ol.Random_Number__c = 345433;
            insert ol; 
            orderline__c ol1=new orderline__c();
            ol1.SerialNo__c='123';
            ol1.Is_Spares__c = false;
            ol1.ShipToAddress__c = add.id;
            ol1.PartNumber__c = pdt.id;
            ol1.Quantity__c = 2;
            ol1.Order__c = order.id;
            ol1.Order_Price__c=op1.id;
            ol1.Product_Category__c=pdt2.id;
            ol1.Related_Antenna__c=pdt2.id;
            ol1.status__c='All';
            ol1.Random_Number__c = 345433;
            insert ol1; 
            orderline__c ol2=new orderline__c();
            ol2.SerialNo__c='123';
            ol2.Is_Spares__c = false;
            ol2.ShipToAddress__c = add.id;
            ol2.PartNumber__c = pdt.id;
            ol2.Quantity__c = 2;
            ol2.Order__c = order.id;
            ol2.Order_Price__c=op2.id;
            ol2.Product_Category__c=pdt3.id;
            ol2.Related_Antenna__c=pdt3.id;
            ol2.status__c='All';
            ol2.Random_Number__c = 345433;
            insert ol2; 
            
            Tooway_OrderconfirmCompController controller = new Tooway_OrderconfirmCompController();
            controller.OrderID = order.id;
            String str = controller.getTerminalString();
            controller.setTerminalString(str);
      }
 }