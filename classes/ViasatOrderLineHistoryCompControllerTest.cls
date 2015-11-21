@isTest(seeAllData=true)
public class ViasatOrderLineHistoryCompControllerTest
{  
    static testmethod void ViasatOrderLineHistoryCompControllerTest1()
    {
        profile profileid = [ Select id from Profile where name = 'Order Customer Portal Users'];
        Account A1 = new Account(Name = 'Test Account');
        insert A1;
        
        List<Contact> ContactList = new List<Contact>();
        Contact C1 = new Contact( AccountID = A1.id, FirstName = 'Test', LastName = 'User', 
        email = 'test-user@fakeemail.com');
        insert C1;

        User u1 = new User( email='test-user@fakeemail.com', contactid = c1.id, profileid = profileid.id, 
        UserName='test-user@fakeemail.com', alias='tuser1', CommunityNickName='tuser1', 
        TimeZoneSidKey='America/New_York', LocaleSidKey='en_US', EmailEncodingKey='ISO-8859-1', 
        LanguageLocaleKey='en_US', FirstName = 'Test', LastName = 'User' );
        insert u1;
        //System.Runas(u1)
       // {       
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
            
           /* orderline__History oh = new orderline__History();
            //oh.createdbyid = UserInfo.getUserId();
            //oh.Field = 'Quantity__c';
            oh.NewValue = 3;
            oh.OldValue = 2;
            insert oh;*/
             orderline__History coh = new orderline__History(ParentId = ol.id, Field = 'Quantity__c'); 
             insert coh; 
            
             order__History coh1 = new order__History(ParentId = Order.id, Field = 'Status__c'); 
             insert coh1;
             
            
            ViasatOrderLineHistoryCompController controller = new ViasatOrderLineHistoryCompController();
            ApexPages.currentPage().getParameters().put('id',order.id);
            controller.Currentobject = order;
            controller.getObjectHistory();
            orderline__c ol1= [Select Quantity__c from orderline__c where id=:ol.id]; 
            ol1.Quantity__c = 4;
            update ol1;
             controller.getObjectHistory();
            
            ol.Quantity__c = 3;
            update ol;
   }                 
}