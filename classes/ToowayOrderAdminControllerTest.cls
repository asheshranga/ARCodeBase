//Test Method for the Apex Class ToowayOrderAdminController

@isTest
public class ToowayOrderAdminControllerTest
{  
    static testmethod void ToowayOrderAdminControllerTest1()
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
        System.Runas(u1) 
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
           // add1.End_Date__c = date.today()+1;
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
            pdt.Name = 'prodtest1';
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
            contract.Display_Requested_Delivery_Date__c=true;
            contract.ShippingCostLabel__c='Shipping Cost...';
            insert contract; 
            
            Contract contract1 = new Contract();
            contract1.AccountId = acc.id;
            contract1.Payment_Terms__c = 'Net 30';
            contract1.Delivery_Method__c ='Do Not Display';
            contract1.Business_Type__c ='Tooway';
            contract.Display_Requested_Delivery_Date__c=false;
            contract.ShippingCostLabel__c='Shipping Cost 2...';
            
  
            insert contract1; 
            System.assertequals(contract1.accountid,acc.id);
            Contract con3 = [Select contractnumber,EndDate,Delivery_Method__c,Payment_Terms__c from Contract where AccountId =:acc.id and Business_Type__c='Tooway' limit 1];
            
            Order__c order = new Order__c();          
            order.Account__c=acc.id;
            order.Status__c = 'Submitted';   
            order.ShipToAddress__c = add.id;
            order.BillToAddress__c = add1.id;
            order.NotesComments__c = 'Test';
         //   order.Contract__c = contract.ContractNumber;
            order.Task__c = 'Test';
            order.AgreetoTermsConditions__c =false;
            order.Requested_Delivery_Datepl__c='Delivered By';
           // order.Requested_Delivery_Date__c = date.newinstance(2014,12,2);
            // order.Delivery_Method__c=contract.Delivery_Method__c;
            order.Delivery_Method__c =(contract.Delivery_Method__c != 'Do Not Display')? contract.Delivery_Method__c:''; 
            order.Payment_Terms__c=contract.Payment_Terms__c;
            order.Contract_Exp_Date__c = contract.EndDate;
            insert order; 
                 
            orderline__c ol=new orderline__c();
            ol.SerialNo__c='123';
            ol.ShipToAddress__c=add.id;
            ol.PartNumber__c=pdt.id;
            ol.Quantity__c=2;
            ol.Order__c = order.id;
            ol.Order_Price__c=op.id;
            ol.Product_Category__c=pdt.id;
            ol.Related_Antenna__c=pdt.id;
            ol.status__c='All';             
            //ol.Random_Number__c = 123;
            insert ol; 
            orderline__c ol1= [Select Random_Number__c from orderline__c where id=:ol.id];
            
            String myString3 = 'Test';
            Attachment a = new Attachment();
            a.ParentId = order.id;
            a.Body = Blob.valueof(myString3);
            a.Name = 'ravi';
            insert a;
     
            PageReference pageRef = Page.ToowayOrderAdmin;
            Test.setCurrentPage(pageRef);
            ApexPages.currentPage().getParameters().put('id',order.id);
            ApexPages.currentPage().getParameters().put('viewmode','True');
            ApexPages.currentPage().getParameters().put('attachmentid',a.id);
            ApexPages.currentPage().getParameters().put('ToowayOrderNotes',order.id);
            boolean viewmode;
            String orderid;
            List<orderline__c> selectedlist = new List<orderline__c>();
            ApexPages.StandardController controller = new ApexPages.StandardController(order);
            ToowayOrderAdminController TOA = new ToowayOrderAdminController(controller);
            ToowayOrderAdminController.neworderlist no=new ToowayOrderAdminController.neworderlist(ol,'name',12.00,14.00);
            no.selected=true; 
             
            TOA.restrictSelectedSave =false; 
            update order;                   
            TOA.accountId=acc.id;
            TOA.Discount=false;
            TOA.CAuser=false;
            TOA.checkcontract = false;
            TOA.getterminals();
            TOA.cancel2();
            TOA.cancelorder();
            TOA.submit();
            TOA.save();
            TOA.edit();
            TOA.myorders();
            TOA.AddTerminal();
            TOA.SaveTerminal();
            TOA.EditTerminal(); 
            TOA.selected = true;   
            TOA.selecteddelete();
            TOA.gettotalantenna();
            TOA.selectedsave();
            TOA.DeleteTerminal();
            TOA.reviewnsubmit();
            TOA.createnew(); 
            TOA.cancel();
            TOA.getprofee();
            TOA.ContractFields();
            TOA.getmyfile();
            TOA.createorderline();
            TOA.getlistattachments();
            TOA.errorMessage = 'errorMessage';
           // TOA.myfile.name = 'File';
            TOA.savedoc();
            TOA.viewAttachment();
            TOA.editAttachment();
            TOA.delAttachment();
            TOA.ContactyourSalesRepresentative();            
            
          }                 
    }   
    static testmethod void ToowayOrderAdminControllerTest2()
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
        System.Runas(u1)        
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
            add.Type__c='Bill To';
            add.VAT__c = 'Add';
            add.Default__c = true;
            add.End_Date__c = system.today()+1;
            add.Account__c=acc.id;
            insert add;
            
            Address__c add1 = new Address__c();
            add1.Address__c='asd';
            add1.Type__c='Ship To';
            add1.VAT__c = 'Add';
            add1.Default__c = true;
            add1.End_Date__c = system.today()+1;
            add1.Account__c=acc.id;
            insert add1;        
            
            Product2 pdt1 = new Product2();
            pdt1.CurrencyIsoCode = 'USD';
            pdt1.Name='Spares';
            pdt1.Product_Category__c='Antenna';
            insert pdt1;        
     
            OrderPrice__c OrderP = new OrderPrice__c();
            OrderP.Product__c=pdt1.id;
            OrderP.Price__c=500; 
            OrderP.PriceList__c=OrderPrice.id;  
     
            Product2 pdt = new Product2();
            pdt.CurrencyIsoCode = 'USD';
            pdt.Name = 'prodtest2';
            pdt.Product_Category__c='Antenna';
            insert pdt;        
        
            OrderPrice__c op=new OrderPrice__c();
            op.Product__c=pdt.id;
            op.Price__c=500; 
            op.PriceList__c=OrderPrice.id;  
            insert op;
     
            Contract contract = new Contract();
            contract.Spares_Price_List__c = OrderPrice.id;
            contract.Order_Price_List__c = OrderPrice.id;
            contract.AccountId = acc.id;
            contract.Payment_Terms__c = 'Net 30';
            contract.Delivery_Method__c ='ViaSat direct ship (cost + 15%)';
            
            contract.Business_Type__c ='Tooway';
            contract.Status = 'Draft';
            contract.CurrencyIsoCode ='USD';
            
            contract.StartDate = date.today();
            contract.ContractTerm =50;
            contract.Terminals_Quantity__c = 1;
            insert contract; 
            
            Contract con3 = [Select contractnumber,EndDate,Delivery_Method__c from Contract where id =:contract.id];        
            Order__c order = new Order__c();   
            order.Account__c=acc.id;
            order.Status__c = 'Pending Submission';   
            order.ShipToAddress__c = add1.id;
            order.BillToAddress__c = add.id;
            order.NotesComments__c = 'Test';
            order.Contract__c = con3.ContractNumber;
            order.Task__c = 'Test';
            order.AgreetoTermsConditions__c = true;
            order.Requested_Delivery_Datepl__c='Delivered By';  
            order.Requested_Delivery_Date__c = null;
            insert order;
                               
            orderline__c ol=new orderline__c();
            ol.SerialNo__c='123';
            ol.ShipToAddress__c=add1.id;
            ol.PartNumber__c=pdt.id;
            ol.Quantity__c=2;
            ol.Order__c = order.id; 
            ol.Order_Price__c=op.id; 
            ol.Related_Antenna__c=pdt.id;        
            ol.status__c='All'; 
            ol.Random_Number__c = 123;
            insert ol; 
            
            PageReference pageRef = Page.ToowayOrderAdmin;
            Test.setCurrentPage(pageRef);
            ApexPages.currentPage().getParameters().put('id',order.id);
            ApexPages.currentPage().getParameters().put('viewmode','True');
            boolean viewmode;
            String orderid;
            ApexPages.StandardController controller = new ApexPages.StandardController(order);
            ToowayOrderAdminController TOA = new ToowayOrderAdminController(controller);
            
            
            Test.StartTest();        
           // TOA.AddTerminal();
            TOA.SaveTerminal();
           // TOA.selectedsave();
            TOA.getterminals();        
            TOA.reviewnsubmit();
            TOA.AddTerminal();
            TOA.SaveTerminal();
            TOA.selectedsave();
            TOA.getterminals();
            TOA.cancel2();
            TOA.cancelorder();
            TOA.submit();
            TOA.save();
            TOA.edit();
            TOA.myorders();
            TOA.selecteddelete();
            TOA.gettotalantenna();
            TOA.EditTerminal(); 
            TOA.DeleteTerminal();
            TOA.createnew(); 
            TOA.cancel();
            TOA.getprofee();
            TOA.ContractFields();
            TOA.getmyfile();
            TOA.createorderline();
            TOA.getlistattachments();            
            TOA.myfile.name = 'File';
            TOA.savedoc();             
            TOA.createorderline();
            ToA.ContactyourSalesRepresentative();
            TOA.checkcontract = True;
            
            String testString=TOA.quantity;
    		testString=TOA.spares;
    		testString=TOA.fees;
    		Boolean testBool=TOA.TerminalsQty;
    		Date testDate=TOA.ocDate;
    		testString=TOA.URLText;
    		testString=TOA.labelText;
  			testBool=TOA.shippingCostVisible;
  			testString=TOA.OrderStatusOutputField;
 			testString=TOA.profiledetailOutputField;
            
            Test.StopTest(); 
        }
    }
    
    static testmethod void ToowayOrderAdminControllerTest3()
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
        System.Runas(u1)        
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
            
            List<Address__c> addressList=new List<Address__c>();
            Address__c add = new Address__c();
            add.Address__c='asd';
            add.Type__c='Bill To';
            add.VAT__c = 'Add';
            add.Default__c = true;
            add.End_Date__c = system.today()+1;
            add.Account__c=acc.id;
            addressList.add(add);
            
            Address__c add1 = new Address__c();
            add1.Address__c='asd';
            add1.Type__c='Ship To';
            add1.VAT__c = 'Add';
            add1.Default__c = true;
            add1.End_Date__c = system.today()+1;
            add1.Account__c=acc.id;            
            addressList.add(add1);                  
            insert addressList;            
            
            
            Product2 pdt1 = new Product2();
            pdt1.CurrencyIsoCode = 'USD';
            pdt1.Name='Spares';
            pdt1.Product_Category__c='Antenna';
            insert pdt1;        
     
            OrderPrice__c OrderP = new OrderPrice__c();
            OrderP.Product__c=pdt1.id;
            OrderP.Price__c=500; 
            OrderP.PriceList__c=OrderPrice.id;  
     
            Product2 pdt = new Product2();
            pdt.CurrencyIsoCode = 'USD';
            pdt.Name = 'prodtest3';
            pdt.Product_Category__c='Antenna';
            insert pdt;        
        
            OrderPrice__c op=new OrderPrice__c();
            op.Product__c=pdt.id;
            op.Price__c=500; 
            op.PriceList__c=OrderPrice.id;  
            insert op;
     
            Contract contract = new Contract();
            contract.Spares_Price_List__c = OrderPrice.id;
            contract.Order_Price_List__c = OrderPrice.id;
            contract.AccountId = acc.id;
            contract.Payment_Terms__c = 'Net 30';
            contract.Delivery_Method__c ='ViaSat direct ship (cost + 15%)';        
            contract.Business_Type__c ='Tooway';
            contract.Status = 'Draft';
            contract.CurrencyIsoCode ='USD';        
            contract.StartDate = date.today();
            contract.ContractTerm =50;
            contract.Terminals_Quantity__c = 1;
            insert contract; 
            
            Contract con3 = [Select contractnumber,EndDate,Delivery_Method__c from Contract where id =:contract.id];
            
            Order__c order = new Order__c();   
            order.Account__c=acc.id;
            order.Status__c = 'Booked';   
            order.ShipToAddress__c = add1.id;
            order.BillToAddress__c = add.id;
            order.NotesComments__c = 'Test';
            order.Contract__c = con3.ContractNumber;
            order.Task__c = 'Test';
            order.AgreetoTermsConditions__c =false;
            order.Requested_Delivery_Datepl__c='Delivered By';       
            insert order;
            List<Address__c> addrList =new list<Address__c>();
            
            addrList = [Select Id, Name, VAT__c,Type__c from Address__c where Default__c = true and Account__c =: con.AccountId and (End_Date__c >= today or End_Date__c = null)];
         
            List<orderline__c> listOrderline=new List<orderline__c>();                              
            orderline__c ol=new orderline__c();
            ol.SerialNo__c='123';
            ol.ShipToAddress__c=add1.id;
            ol.PartNumber__c=pdt.id;
            ol.Quantity__c=2;
            ol.Order__c = order.id; 
            ol.Order_Price__c=op.id; 
            ol.Related_Antenna__c=pdt.id;        
            ol.status__c='All'; 
            ol.Random_Number__c = 123;
            listOrderline.add(ol); 
            
          
            orderline__c ol1=new orderline__c();
            ol1.SerialNo__c='123';
            ol1.ShipToAddress__c=add1.id;
            ol1.PartNumber__c=pdt.id;
         //   ol1.Quantity__c=2;
            ol1.Order__c = order.id; 
            ol1.Order_Price__c=op.id; 
            ol1.Related_Antenna__c=pdt.id;        
            ol1.status__c='All'; 
            ol1.Random_Number__c = 123;
         //   ol1.Unit_Price__c=;
            ol1.Is_spares__c = true;
            ol1.Random_Number__c=12.00;
            listOrderline.add(ol1);
            
            insert  listOrderline;
            PageReference pageRef = Page.ToowayOrderAdmin;
            Test.setCurrentPage(pageRef);
            ApexPages.currentPage().getParameters().put('id',order.id);
            ApexPages.currentPage().getParameters().put('viewmode','True');         
            Apexpages.currentpage().getparameters().put('createnewline','true');
            boolean viewmode;
            String orderid;
            ApexPages.StandardController controller = new ApexPages.StandardController(order);
            ToowayOrderAdminController TOA1 = new ToowayOrderAdminController();
            ToowayOrderAdminController TOA = new ToowayOrderAdminController(controller);
            
            Test.StartTest();        
           // TOA.AddTerminal();
            TOA.SaveTerminal();
           // TOA.selectedsave();
            TOA.getterminals();        
            TOA.reviewnsubmit();
            TOA.AddTerminal();
            TOA.SaveTerminal();
            TOA.selectedsave();
            TOA.getterminals();
            TOA.cancel2();
            TOA.cancelorder();
            TOA.submit();
            TOA.save();
            TOA.edit();
            TOA.myorders();
            TOA.selecteddelete();
            TOA.gettotalantenna();
            TOA.EditTerminal(); 
            TOA.DeleteTerminal();
            TOA.createnew(); 
            TOA.cancel();
            TOA.getprofee();
            TOA.ContractFields(); 
            TOA.getmyfile();
            TOA.createorderline();
            TOA.getlistattachments();
            TOA.errorMessage = null;            
            TOA.savedoc();            
            TOA.createorderline();
            TOA.TerminalsQtyCheck=true;
            TOA.ContactyourSalesRepresentative(); 
            TOA.checkcontract = false;      
            
            // case 316272
           	TOA.currentRow = 0;
           	TOA.UpdateQuantity();
           
                
            Test.StopTest(); 
        }
    }
    
    static testmethod void ToowayOrderAdminControllerTest4()
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
        System.Runas(u1)        
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
        add.Type__c='Bill To';
        add.VAT__c = 'Add';
        add.Default__c = true;
        add.End_Date__c = system.today()+1;
        add.Account__c=acc.id;
        insert add;
        
        Address__c add1 = new Address__c();
        add1.Address__c='asd';
        add1.Type__c='Ship To';
        add1.VAT__c = 'Add';
        add1.Default__c = true;
        add1.End_Date__c = system.today()+1;
        add1.Account__c=acc.id;
        insert add1;
        
        Address__c add2 = new Address__c();
        add2.Address__c='asd';
        add2.Type__c='Ship To';
        add2.VAT__c = 'Add';
        add2.Default__c = false;
        add2.End_Date__c = system.today()+1;
        add2.Account__c=acc.id;
        insert add2;
            
        
        Product2 pdt1 = new Product2();
        pdt1.CurrencyIsoCode = 'USD';
        pdt1.Name='Spares';
        pdt1.Product_Category__c='Antenna';
        insert pdt1;        
 
        OrderPrice__c OrderP = new OrderPrice__c();
        OrderP.Product__c=pdt1.id;
        OrderP.Price__c=500; 
        OrderP.PriceList__c=OrderPrice.id;  

        Product2 pdt = new Product2();
        pdt.CurrencyIsoCode = 'USD';
        pdt.Name = 'prodtest4';
        pdt.Product_Category__c='Antenna';
        insert pdt;        
    
        OrderPrice__c op=new OrderPrice__c();
        op.Product__c=pdt.id;
        op.Price__c=500; 
        op.PriceList__c=OrderPrice.id;  
        insert op;
 
        Contract contract = new Contract();
        contract.Spares_Price_List__c = OrderPrice.id;
        contract.Order_Price_List__c = OrderPrice.id;
        contract.AccountId = acc.id;
        contract.Payment_Terms__c = 'Net 30';
        contract.Delivery_Method__c ='ViaSat direct ship (cost + 15%)';        
        contract.Business_Type__c ='Tooway';
        contract.Status = 'Draft';
        contract.CurrencyIsoCode ='USD';        
        contract.StartDate = date.today();
        contract.ContractTerm =50;
        contract.Terminals_Quantity__c = 1;
        insert contract; 
        
        Contract con3 = [Select contractnumber,EndDate,Delivery_Method__c from Contract where id =:contract.id];
        
        Order__c order = new Order__c();   
        order.Account__c=acc.id;
        order.Status__c = 'Cancelled';   
        order.ShipToAddress__c = add1.id;
        order.BillToAddress__c = add.id;
        order.NotesComments__c = 'Test';
        order.Contract__c = con3.ContractNumber;
        order.Task__c = 'Test';
        order.AgreetoTermsConditions__c =true;
        order.Requested_Delivery_Datepl__c='Delivered By';       
        insert order; 
                           
        orderline__c ol=new orderline__c();
        ol.SerialNo__c='123';
        ol.ShipToAddress__c=add1.id;
        ol.PartNumber__c=pdt.id;
        ol.Quantity__c=2;
        ol.Order__c=order.id; 
        ol.Order_Price__c=op.id;        
        ol.Related_Antenna__c=pdt.id;
        ol.status__c='All'; 
        ol.Random_Number__c = 123;
        insert ol;   
        
        PageReference pageRef = Page.ToowayOrderAdmin;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('id',order.id);
        ApexPages.currentPage().getParameters().put('viewmode','True');
        boolean viewmode;
        String orderid;
        ApexPages.StandardController controller = new ApexPages.StandardController(order);
        ToowayOrderAdminController TOA = new ToowayOrderAdminController(controller);
    
        Test.StartTest();
        
       // TOA.AddTerminal();
        TOA.SaveTerminal();
       // TOA.selectedsave();
        TOA.getterminals();
        
        TOA.reviewnsubmit();
        TOA.AddTerminal();
        TOA.SaveTerminal();
        TOA.selectedsave();
        TOA.getterminals();
        TOA.cancel2();
        TOA.cancelorder();
        TOA.submit();
        TOA.save();
        TOA.edit();
        TOA.myorders();
        TOA.selecteddelete();
        TOA.gettotalantenna();
        TOA.EditTerminal(); 
        TOA.DeleteTerminal();
        TOA.createnew(); 
        TOA.cancel();
        TOA.getprofee();
        TOA.ContractFields(); 
        TOA.createorderline();
        TOA.ContactyourSalesRepresentative();
        TOA.checkcontract = false;
        Test.StopTest(); 
        }                 
    }
   
    static testmethod void ToowayOrderAdminControllerTest5()
    {
        profile profileid = [ Select id from Profile where name = 'Order Contract Administrator'];
        Account A1 = new Account(Name = 'Test Account');
        insert A1;
        
        List<Contact> ContactList = new List<Contact>();
        Contact C1 = new Contact( AccountID = A1.id, FirstName = 'Test', LastName = 'User', 
        email = 'test-user@fakeemail.com');
        insert C1;

        User u1 = new User( email='test-user@fakeemail.com', profileid = profileid.id, 
        UserName='workingtest@nttdata.com', alias='tuser1', CommunityNickName='tuser1',
        TimeZoneSidKey='America/New_York', LocaleSidKey='en_US', EmailEncodingKey='ISO-8859-1', 
        LanguageLocaleKey='en_US', FirstName = 'Test', LastName = 'User' );
        insert u1;
        System.Runas(u1)      
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
        add.Type__c='Bill To';
        add.VAT__c = 'Add';
        add.Default__c = true;
        add.End_Date__c = system.today()+1;
        add.Account__c=acc.id;
        insert add;
        
        Address__c add1 = new Address__c();
        add1.Address__c='asd';
        add1.Type__c='Ship To';
        add1.VAT__c = 'Add';
        add1.Default__c = true;
        add1.End_Date__c = system.today()+1;
        add1.Account__c=acc.id;
        insert add1;
        
        Address__c add2 = new Address__c();
        add2.Address__c='asd';
        add2.Type__c='Ship To';
        add2.VAT__c = 'Add';
        add2.Default__c = false;
        add2.End_Date__c = system.today()+1;
        add2.Account__c=acc.id;
        insert add2;
        
        Product2 pdt1 = new Product2();
        pdt1.CurrencyIsoCode = 'USD';
        pdt1.Name='Spares';
        pdt1.Product_Category__c='Antenna';
        insert pdt1;        
 
        OrderPrice__c OrderP = new OrderPrice__c();
        OrderP.Product__c=pdt1.id;
        OrderP.Price__c=500; 
        OrderP.PriceList__c=OrderPrice.id;  
 
        Product2 pdt = new Product2();
        pdt.CurrencyIsoCode = 'USD';
        pdt.Name = 'prodtest5';
        pdt.Product_Category__c='Antenna';
        insert pdt;        
    
        OrderPrice__c op=new OrderPrice__c();
        op.Product__c=pdt.id;
        op.Price__c=500; 
        op.PriceList__c=OrderPrice.id;  
        insert op;

        Contract contract = new Contract();
        contract.Spares_Price_List__c = OrderPrice.id;
        contract.Order_Price_List__c = OrderPrice.id;
        contract.Payment_Terms__c = 'Net 30';
        contract.Delivery_Method__c ='ViaSat direct ship (cost + 15%)';
        contract.AccountId = acc.id;
        contract.Business_Type__c ='Tooway';
        contract.Status = 'Draft';
        contract.CurrencyIsoCode ='USD';
        contract.StartDate = date.today();
        contract.ContractTerm =50;
        contract.Terminals_Quantity__c = 1;
        insert contract; 
                   
        Contract con3 = [Select contractnumber,EndDate,Delivery_Method__c from Contract where id =:contract.id];                  
        
        Order__c order = new Order__c();   
        order.Account__c=acc.id;
        order.Status__c = 'Submitted';   
        order.ShipToAddress__c = add1.id;
        order.BillToAddress__c = add.id;
        order.NotesComments__c = 'Test';
        order.Contract__c = con3.contractnumber;
        order.Task__c = 'Test';
        order.AgreetoTermsConditions__c =true;
        order.Requested_Delivery_Datepl__c='Delivered By';
        order.Requested_Delivery_Date__c = date.today().addDays(100);
        insert order; 
                     
        orderline__c ol=new orderline__c();
        ol.SerialNo__c='123';
        ol.ShipToAddress__c=add1.id;
        ol.PartNumber__c=pdt.id;
        ol.Quantity__c=2;
        ol.Unit_Price__c = 2;
        ol.Order__c=order.id; 
        ol.Order_Price__c=op.id;       
        ol.Related_Antenna__c=pdt.id;     
        ol.status__c='All'; 
        ol.Random_Number__c = 123;
        insert ol; 
        
        PageReference pageRef = Page.ToowayOrderAdmin;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('id',order.id);
        ApexPages.currentPage().getParameters().put('viewmode','True');
        boolean viewmode;
        String orderid;
        ApexPages.StandardController controller = new ApexPages.StandardController(order);
        ToowayOrderAdminController TOA = new ToowayOrderAdminController(controller);
        
        Test.StartTest();
        TOA.SaveTerminal();
       TOA.gettemp();
        TOA.SaveTerminal();
       // TOA.selectedsave();
        TOA.getterminals();
        TOA.Discount=false;
        TOA.CAuser=false;
        TOA.reviewnsubmit();
        TOA.AddTerminal();
        TOA.selectedsave();
        TOA.getterminals();
        TOA.cancel2();
        TOA.cancelorder();
        TOA.submit();
        TOA.save();
        TOA.edit();
        TOA.myorders();
        TOA.selecteddelete();
        TOA.gettotalantenna();
        TOA.EditTerminal(); 
        TOA.DeleteTerminal();
        TOA.createnew(); 
        TOA.cancel();
        TOA.getprofee();
        TOA.ContractFields(); 
        TOA.createorderline(); 
        TOA.checkcontract = false;
        TOA.ContactyourSalesRepresentative();       
        Test.StopTest(); 
        }                 
    }
   
    static testmethod void ToowayOrderAdminControllerTest6()
    {
        profile profileid = [ Select id from Profile where name = 'Order Contract Administrator'];
        Account A1 = new Account(Name = 'Test Account');
        insert A1;
        
        List<Contact> ContactList = new List<Contact>();
        Contact C1 = new Contact( AccountID = A1.id, FirstName = 'Test', LastName = 'User', 
        email = 'test-user@fakeemail.com');
        insert C1;

        User u1 = new User( email='test-user@fakeemail.com', profileid = profileid.id,
        UserName='userntt@in.com', alias='tuser1', CommunityNickName='tuser1',
        TimeZoneSidKey='America/New_York', LocaleSidKey='en_US', EmailEncodingKey='ISO-8859-1', 
        LanguageLocaleKey='en_US', FirstName = 'Test', LastName = 'User' );
        insert u1;
        System.Runas(u1)      
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
        add.Type__c='Bill To';
        add.VAT__c = 'Add';
        add.Default__c = true;
        add.End_Date__c = system.today()+1;
        add.Account__c=acc.id;
        insert add;
        
        Address__c add1 = new Address__c();
        add1.Address__c='asd';
        add1.Type__c='Ship To';
        add1.VAT__c = 'Add';
        add1.Default__c = true;
        add1.End_Date__c = system.today()+1;
        add1.Account__c=acc.id;
        insert add1;
        
        Address__c add2 = new Address__c();
        add2.Address__c='asd';
        add2.Type__c='Ship To';
        add2.VAT__c = 'Add';
        add2.Default__c = false;
        add2.End_Date__c = system.today()+1;
        add2.Account__c=acc.id;
        insert add2;
        
        Product2 pdt1 = new Product2();
        pdt1.CurrencyIsoCode = 'USD';
        pdt1.Name='Spares';
        pdt1.Product_Category__c='Antenna';
        insert pdt1;        
 
        OrderPrice__c OrderP = new OrderPrice__c();
        OrderP.Product__c=pdt1.id;
        OrderP.Price__c=500; 
        OrderP.PriceList__c=OrderPrice.id;  
                
        Product2 pdt = new Product2();
        pdt.CurrencyIsoCode = 'USD';
        pdt.Name = 'prodtest5';
        pdt.Product_Category__c='Antenna';
        insert pdt;        
    
        OrderPrice__c op=new OrderPrice__c();
        op.Product__c=pdt.id;
        op.Price__c=500; 
        op.PriceList__c=OrderPrice.id;  
        insert op;
 
        Contract contract = new Contract();
        contract.Spares_Price_List__c = OrderPrice.id;
        contract.Order_Price_List__c = OrderPrice.id;
        contract.AccountId = acc.id;
        contract.Payment_Terms__c = 'Net 30';
        contract.Delivery_Method__c ='ViaSat direct ship (cost + 15%)';        
        contract.Business_Type__c ='Tooway';
        contract.Status = 'Draft';
        contract.CurrencyIsoCode ='USD';        
        contract.StartDate = date.today();
        contract.ContractTerm =50;
        contract.Terminals_Quantity__c = 1;
        insert contract;        
        Contract con3 = [Select contractnumber,EndDate,Delivery_Method__c from Contract where id =:contract.id];
        
        Order__c order = new Order__c();   
        order.Account__c=acc.id;
        order.Status__c = 'Pending Submission';   
        order.ShipToAddress__c = add1.id;
        order.BillToAddress__c = add.id;
        order.NotesComments__c = 'Test';
        order.Contract__c = con3.ContractNumber;
        order.Task__c = 'Test';
        order.AgreetoTermsConditions__c =false;
        order.Requested_Delivery_Datepl__c='Delivered By';
        insert order; 
     
        orderline__c ol=new orderline__c();
        ol.SerialNo__c='123';
        ol.ShipToAddress__c=add2.id;
        ol.PartNumber__c=pdt.id;
        ol.Quantity__c=2;
        ol.Order__c=order.id; 
        ol.Order_Price__c=op.id;        
        ol.Related_Antenna__c=pdt.id;       
        ol.status__c='All';
        ol.Random_Number__c = 123;      
        insert ol; 
        
        PageReference pageRef = Page.ToowayOrderAdmin;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('id',order.id);
        ApexPages.currentPage().getParameters().put('viewmode','True');
        boolean viewmode;
        String orderid;
        ApexPages.StandardController controller = new ApexPages.StandardController(order);
        ToowayOrderAdminController TOA = new ToowayOrderAdminController(controller);
    
        Test.StartTest();        
        TOA.SaveTerminal();       
        TOA.getterminals();        
        TOA.reviewnsubmit();
        TOA.AddTerminal();
        TOA.SaveTerminal();
        TOA.selectedsave();
        TOA.getterminals();
        TOA.cancel2();
        TOA.cancelorder();
        TOA.submit();
        TOA.save();
        TOA.edit();
        TOA.myorders();
        TOA.selecteddelete();
        TOA.gettotalantenna();
        TOA.EditTerminal(); 
        TOA.DeleteTerminal();
        TOA.createnew(); 
        TOA.cancel();
        TOA.getprofee();
        TOA.ContractFields(); 
        TOA.createorderline();
        TOA.ContactyourSalesRepresentative();
        TOA.checkcontract = false;
        Test.StopTest(); 
        }                 
    }  
   
    static testmethod void ToowayOrderAdminControllerTest7()
    {
        profile profileid = [ Select id from Profile where name = 'Order Contract Administrator'];
        Account A1 = new Account(Name = 'Test Account');
        insert A1;
        
        List<Contact> ContactList = new List<Contact>();
        Contact C1 = new Contact( AccountID = A1.id, FirstName = 'Test', LastName = 'User', 
        email = 'test-user@fakeemail.com');
        insert C1;

        User u1 = new User( email='test-user@fakeemail.com', profileid = profileid.id,
        UserName='work@intest.com', alias='tuser1', CommunityNickName='tuser1',
        TimeZoneSidKey='America/New_York', LocaleSidKey='en_US', EmailEncodingKey='ISO-8859-1', 
        LanguageLocaleKey='en_US', FirstName = 'Test', LastName = 'User' );
        insert u1;
        System.Runas(u1)      
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
        add.Type__c='Bill To';
        add.VAT__c = 'Add';
        add.Default__c = true; 
        add.Account__c=con.Accountid;
        insert add;
        
        Address__c add1 = new Address__c();
        add1.Address__c='asd';
        add1.Type__c='Ship To';
        add1.VAT__c = 'Add';
        add1.Default__c = true;
        add1.End_Date__c = system.today()+1;
        add1.Account__c=con.Accountid;
        insert add1;
        
        Address__c add2 = new Address__c();
        add2.Address__c='asd';
        add2.Type__c='Ship To';
        add2.VAT__c = 'Add';
        add2.Default__c = false;
        add2.End_Date__c = system.today()+1;
        add2.Account__c=acc.id;
        insert add2;
        
        Product2 pdt1 = new Product2();
        pdt1.CurrencyIsoCode = 'USD';
        pdt1.Name='Spares';
        pdt1.Product_Category__c='Antenna';
        insert pdt1;        
 
        OrderPrice__c OrderP = new OrderPrice__c();
        OrderP.Product__c=pdt1.id;
        OrderP.Price__c=500; 
        OrderP.PriceList__c=OrderPrice.id;  

        Product2 pdt = new Product2();
        pdt.CurrencyIsoCode = 'USD';
        pdt.Name = 'prodtest6';
        pdt.Product_Category__c='Antenna';
        insert pdt;        
    
        OrderPrice__c op=new OrderPrice__c();
        op.Product__c=pdt.id;
        op.Price__c=500; 
        op.PriceList__c=OrderPrice.id;  
        insert op;
  
        Contract contract = new Contract();
        contract.Spares_Price_List__c = OrderPrice.id;
        contract.Order_Price_List__c = OrderPrice.id;
        contract.AccountId = acc.id;
        contract.Payment_Terms__c = 'Net 30';
        contract.Delivery_Method__c ='ViaSat direct ship (cost + 15%)';
        contract.Business_Type__c ='Tooway';
        contract.Status = 'Draft';
        contract.CurrencyIsoCode ='USD';
        contract.StartDate = date.today();
        contract.ContractTerm =50;
        contract.Terminals_Quantity__c = 1;
        insert contract; 

        Contract con3 = [Select contractnumber,EndDate,Delivery_Method__c from Contract where id =:contract.id];
        Order__c order = new Order__c();   
        order.Account__c=acc.id;
        order.Status__c = 'Cancelled';   
        order.ShipToAddress__c = add1.id;
        order.BillToAddress__c = add.id;
        order.NotesComments__c = 'Test';
        order.Contract__c = con3.ContractNumber;
        order.Task__c = 'Test';
        order.AgreetoTermsConditions__c =false;
        order.Requested_Delivery_Datepl__c='Delivered By';
        insert order; 
                    
        orderline__c ol=new orderline__c();
        ol.SerialNo__c='123';
        ol.ShipToAddress__c=add2.id;
        ol.PartNumber__c=pdt.id;
        ol.Quantity__c=2;
        ol.Order__c=order.id; 
        ol.Order_Price__c=op.id;        
        ol.Related_Antenna__c=pdt.id;      
        ol.status__c='All';
        ol.Random_Number__c = 123;      
        insert ol;  
        
        PageReference pageRef = Page.ToowayOrderAdmin;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('id',order.id);
        ApexPages.currentPage().getParameters().put('viewmode','True');
        boolean viewmode;
        String orderid;
        ApexPages.StandardController controller = new ApexPages.StandardController(order);
        ToowayOrderAdminController TOA = new ToowayOrderAdminController(controller);
        
        Test.StartTest();
        
       // TOA.AddTerminal();
        TOA.SaveTerminal();
       // TOA.selectedsave();
        TOA.getterminals();        
        TOA.reviewnsubmit();
        TOA.AddTerminal();
        TOA.SaveTerminal();
        TOA.selectedsave();
        TOA.getterminals();
        TOA.cancel2();
        TOA.cancelorder();
        TOA.submit();
        TOA.save();
        TOA.edit();
        TOA.myorders();
        TOA.selecteddelete();
        TOA.gettotalantenna();
        TOA.EditTerminal(); 
        TOA.DeleteTerminal();
        TOA.createnew(); 
        TOA.cancel();
        TOA.getprofee();
        TOA.ContractFields(); 
        TOA.createorderline();
        TOA.ContactyourSalesRepresentative();        
        Test.StopTest();       
        }                 
    }
   
    static testmethod void ToowayOrderAdminControllerTest8()
    {
        profile profileid = [ Select id from Profile where name = 'System Administrator'];
        Account A1 = new Account(Name = 'Test Account');
        insert A1;
        
        List<Contact> ContactList = new List<Contact>();
        Contact C1 = new Contact( AccountID = A1.id, FirstName = 'Test', LastName = 'User', 
        email = 'test-user@fakeemail.com');
        insert C1;

        User u1 = new User( email='test-user@fakeemail.com', profileid = profileid.id, 
        UserName='testsecond@ntt.com', alias='tuser1', CommunityNickName='tuser1',
        TimeZoneSidKey='America/New_York', LocaleSidKey='en_US', EmailEncodingKey='ISO-8859-1', 
        LanguageLocaleKey='en_US', FirstName = 'Test', LastName = 'User' );
        insert u1;

        System.Runas(u1)      
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
        add.Type__c='Bill To';
        add.VAT__c = 'Add';
        add.Default__c = true;
        add.End_Date__c = system.today()+1;
        add.Account__c=acc.id;
        insert add;
        
        Address__c add1 = new Address__c();
        add1.Address__c='asd';
        add1.Type__c='Ship To';
        add1.VAT__c = 'Add';
        add1.Default__c = true;
        add1.End_Date__c = system.today()+1;
        add1.Account__c=acc.id;
        insert add1;
        
        Address__c add2 = new Address__c();
        add2.Address__c='asd';
        add2.Type__c='Ship To';
        add2.VAT__c = 'Add';
        add2.Default__c = false;
        add2.End_Date__c = system.today()+1;
        add2.Account__c=acc.id;
        insert add2;
        
        Product2 pdt1 = new Product2();
        pdt1.CurrencyIsoCode = 'USD';
        pdt1.Name='Spares';
        pdt1.Product_Category__c='Antenna';
        insert pdt1;        
 
        OrderPrice__c OrderP = new OrderPrice__c();
        OrderP.Product__c=pdt1.id;
        OrderP.Price__c=500; 
        OrderP.PriceList__c=OrderPrice.id;  

        Product2 pdt = new Product2();
        pdt.CurrencyIsoCode = 'USD';
        pdt.Name = 'prodtest7';
        pdt.Product_Category__c='Antenna';
        insert pdt;        
    
        OrderPrice__c op=new OrderPrice__c();
        op.Product__c=pdt.id;
        op.Price__c=500; 
        op.PriceList__c=OrderPrice.id;  
        insert op;
  
        Contract contract = new Contract();
        contract.Spares_Price_List__c = OrderPrice.id;
        contract.Order_Price_List__c = OrderPrice.id;
        contract.AccountId = acc.id;
        contract.Payment_Terms__c = 'Net 30';
        contract.Delivery_Method__c ='ViaSat direct ship (cost + 15%)';
        
        contract.Business_Type__c ='Tooway';
        contract.Status = 'Draft';
        contract.CurrencyIsoCode ='USD';
        
        contract.StartDate = date.today();
        contract.ContractTerm =50;
        contract.Terminals_Quantity__c = 1;
        insert contract; 
        
        Contract con3 = [Select contractnumber,EndDate,Delivery_Method__c from Contract where id =:contract.id];
        Order__c order = new Order__c();   
        order.Account__c=acc.id;
        order.Status__c = 'Pending Submission';   
        order.ShipToAddress__c = add2.id;
        order.BillToAddress__c = add.id;
        order.NotesComments__c = 'Test';
        order.Contract__c = con3.ContractNumber;
        order.contract__c = '';
        order.Task__c = 'Test';
        order.AgreetoTermsConditions__c =true;
        order.Requested_Delivery_Datepl__c='ASAP';
        order.Requested_Delivery_Date__c = date.today().addDays(100); 
        insert order;
        update order; 
                    
        orderline__c ol=new orderline__c();
        ol.SerialNo__c='123';
        ol.ShipToAddress__c=add1.id;
        ol.PartNumber__c=pdt.id;
        ol.Quantity__c=2;
        ol.Order__c=order.id; 
        ol.Order_Price__c=op.id;        
        ol.Related_Antenna__c=pdt.id;      
        ol.status__c='All';
        ol.Random_Number__c = 123;      
        insert ol;  
        
        PageReference pageRef = Page.ToowayOrderAdmin;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('id',order.id);
        ApexPages.currentPage().getParameters().put('viewmode','True');
        boolean viewmode;
        String orderid;
        ApexPages.StandardController controller = new ApexPages.StandardController(order);
        ToowayOrderAdminController TOA = new ToowayOrderAdminController(controller);
    
        Test.StartTest();
        TOA.SaveTerminal();
        TOA.getterminals();
        TOA.reviewnsubmit();
        TOA.AddTerminal();
        TOA.SaveTerminal();
        TOA.selectedsave();
        TOA.getterminals();
        TOA.cancel2();
        TOA.cancelorder();
        TOA.submit();
        TOA.save();
        TOA.edit();
        TOA.myorders();
        TOA.selecteddelete();
        TOA.gettotalantenna();
        TOA.EditTerminal(); 
        TOA.DeleteTerminal();
        TOA.createnew(); 
        TOA.cancel();
        TOA.getprofee();
        TOA.ContractFields();
        TOA.checkcontract = false; 
        TOA.createorderline();
        TOA.ContactyourSalesRepresentative();
        TOA.checkcontract = false;
        Test.StopTest();
        }                 
    }
   
    static testmethod void ToowayOrderAdminControllerTest9()
    {
        profile profileid = [ Select id from Profile where name = 'Order Customer Portal Users'];
        Userrole Usrole = [Select id from userrole where name = 'Carlsbad NOC'];
        
        Account A1 = new Account(Name = 'Test Account');
        insert A1;
        
        List<Contact> ContactList = new List<Contact>();
        Contact C1 = new Contact( AccountID = A1.id, FirstName = 'Test', LastName = 'User', 
        email = 'test-user@fakeemail.com');
        insert C1;
        
        User u1;
        User admin = [Select id from user where id=:UserInfo.getUserId()];
        system.runas(admin)
        {
        u1 = new User( email='test-user@fakeemail.com', contactID = C1.id, profileid = profileid.id, 
        UserName='test-user@fakeemail.com', alias='tuser1', CommunityNickName='tuser1', 
        TimeZoneSidKey='America/New_York', LocaleSidKey='en_US', EmailEncodingKey='ISO-8859-1', 
        LanguageLocaleKey='en_US', FirstName = 'Test', LastName = 'User');
        insert u1;
        }             
        
        System.Runas(u1)        
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
        add.Type__c='Bill To';
        add.VAT__c = 'Add';
        add.Default__c = true;
        add.End_Date__c = system.today()+2;
        add.Account__c=con.Accountid;
        insert add;
        
        Address__c add1 = new Address__c();
        add1.Address__c='asd';
        add1.Type__c='Ship To';
        add1.VAT__c = 'Add';
        add1.Default__c = true;
        add1.End_Date__c = system.today()+2;
        add1.Account__c=con.Accountid;
        insert add1;
        
        Address__c add2 = new Address__c();
        add2.Address__c='asd';
        add2.Type__c='Ship To';
        add2.VAT__c = 'Add';
        add2.Default__c = false;
        add2.End_Date__c = system.today()+1;
        add2.Account__c=acc.id;
        insert add2;
        
        Product2 pdt1 = new Product2();
        pdt1.CurrencyIsoCode = 'USD';
        pdt1.Name='Spares';
        pdt1.Product_Category__c='Antenna';
        insert pdt1;        
 
        OrderPrice__c OrderP = new OrderPrice__c();
        OrderP.Product__c=pdt1.id;
        OrderP.Price__c=500; 
        OrderP.PriceList__c=OrderPrice.id;  

        Product2 pdt = new Product2();
        pdt.CurrencyIsoCode = 'USD';
        pdt.Name = 'prodtest8';
        pdt.Product_Category__c='Antenna';
        insert pdt;        
    
        OrderPrice__c op=new OrderPrice__c();
        op.Product__c=pdt.id;
        op.Price__c=500; 
        op.PriceList__c=OrderPrice.id;  
        insert op;
 
        Contract contract = new Contract();
        contract.Spares_Price_List__c = OrderPrice.id;
        contract.Order_Price_List__c = OrderPrice.id;
        contract.AccountId = acc.id;
        contract.Payment_Terms__c = 'Net 30';
        contract.Delivery_Method__c ='ViaSat direct ship (cost + 15%)';
        contract.Business_Type__c ='Tooway';
        contract.Status = 'Draft';
        contract.CurrencyIsoCode ='USD';
        contract.StartDate = date.today();
        contract.ContractTerm =50;
        contract.Terminals_Quantity__c = 1;
        insert contract;
        
        Contract con3 = [Select contractnumber,EndDate,Delivery_Method__c from Contract where id =:contract.id];
        
        Order__c order = new Order__c();   
        order.Account__c=acc.id;
        order.Status__c = 'Pending Submission';   
        order.ShipToAddress__c = add1.id;
        order.BillToAddress__c = add.id;
        order.NotesComments__c = 'Test';
        order.Contract__c = con3.ContractNumber;      
        order.Task__c = 'Test';
        order.AgreetoTermsConditions__c =true;
        order.Requested_Delivery_Datepl__c='ASAP'; 
        order.Contract_Exp_Date__c = system.today();
        order.Delivery_Method__c = 'NTTDATA1';
        insert order; 
        List<Address__c> addrList =new list<Address__c>();
        addrList = [Select Id, Name, VAT__c,Type__c from Address__c where Default__c = true and Account__c =: con.AccountId and (End_Date__c >= today or End_Date__c = null)];
        system.debug('ListaddrList'+addrList);                 
        orderline__c ol=new orderline__c();
        ol.SerialNo__c='123';
        ol.ShipToAddress__c=add1.id;
        ol.PartNumber__c=pdt.id;
        ol.Quantity__c=2;
        ol.Order__c=order.id; 
        ol.Order_Price__c=op.id;        
        ol.Related_Antenna__c=pdt.id;
        ol.status__c='All'; 
        ol.Random_Number__c = 123;
        insert ol;  
        
        
        String myString3 = 'Test';
        Attachment a = new Attachment();
        a.ParentId = order.id;
        a.Body = Blob.valueof(myString3);
        a.Name = 'ravi';
        insert a; 
        
        PageReference pageRef = Page.ToowayOrderAdmin;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('id',null);
       // ApexPages.currentPage().getParameters().put('viewmode','True');
        ApexPages.currentPage().getParameters().put('ToowayOrderNotes',order.id);
        ApexPages.currentPage().getParameters().put('ToowayAddTerminal',order.id);
        Apexpages.currentpage().getparameters().put('createnewline','true');
        boolean viewmode;
        String orderid;
        ApexPages.StandardController controller = new ApexPages.StandardController(order);
        ToowayOrderAdminController TOA = new ToowayOrderAdminController(controller);
    
        Test.StartTest();
        TOA.accountId=acc.id;
        TOA.SaveTerminal();
        TOA.getterminals();
        TOA.reviewnsubmit();
        TOA.AddTerminal();
        TOA.SaveTerminal();
        TOA.selectedsave();
        TOA.getterminals();
        TOA.cancel2();
        TOA.cancelorder();
        //TOA.submit();
        TOA.save();
        TOA.edit();
        TOA.myorders();
        TOA.selecteddelete();
        TOA.gettotalantenna();
        TOA.EditTerminal(); 
        TOA.DeleteTerminal();
        TOA.createnew(); 
        TOA.cancel();
        TOA.getprofee();
        TOA.ContractFields(); 
        TOA.createorderline();
        TOA.ContactyourSalesRepresentative();
        TOA.gettemp();
        TOA.getlistattachments();
        TOA.getmyfile();
        TOA.checkcontract = false;
        Test.StopTest(); 
        }                 
    }
   
    static testmethod void ToowayOrderAdminControllerTest10()
    {
        profile profileid = [ Select id from Profile where name = 'Order Contract Administrator'];
        Account A1 = new Account(Name = 'Test Account');
        insert A1;
        
        List<Contact> ContactList = new List<Contact>();
        Contact C1 = new Contact( AccountID = A1.id, FirstName = 'Test', LastName = 'User', 
        email = 'test-user@fakeemail.com');
        insert C1;

        User u1 = new User( email='test-user@fakeemail.com', profileid = profileid.id,
        UserName='work@nttdata.com', alias='tuser1', CommunityNickName='tuser1',
        TimeZoneSidKey='America/New_York', LocaleSidKey='en_US', EmailEncodingKey='ISO-8859-1', 
        LanguageLocaleKey='en_US', FirstName = 'Test', LastName = 'User' );
        insert u1;

        System.Runas(u1)      
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
        add.Type__c='Bill To';
        add.VAT__c = 'Add';
        add.Default__c = true;
        add.End_Date__c = system.today()+1;
        add.Account__c=acc.id;
        insert add;
        
        Address__c add1 = new Address__c();
        add1.Address__c='asd';
        add1.Type__c='Ship To';
        add1.VAT__c = 'Add';
        add1.Default__c = true;
        add1.End_Date__c = system.today()+1;
        add1.Account__c=acc.id;
        insert add1;
        
        Address__c add2 = new Address__c();
        add2.Address__c='asd';
        add2.Type__c='Ship To';
        add2.VAT__c = 'Add';
        add2.Default__c = false;
        add2.End_Date__c = system.today()+1;
        add2.Account__c=acc.id;
        insert add2;
        
        Product2 pdt1 = new Product2();
        pdt1.CurrencyIsoCode = 'USD';
        pdt1.Name='Spares';
        pdt1.Product_Category__c='Antenna';
        insert pdt1;        
 
        OrderPrice__c OrderP = new OrderPrice__c();
        OrderP.Product__c=pdt1.id;
        OrderP.Price__c=500; 
        OrderP.PriceList__c=OrderPrice.id;  
                
        Product2 pdt = new Product2();
        pdt.CurrencyIsoCode = 'USD';
        pdt.Name = 'prodtest9';
        pdt.Product_Category__c='Antenna';
        insert pdt;        
    
        OrderPrice__c op=new OrderPrice__c();
        op.Product__c=pdt.id;
        op.Price__c=500; 
        op.PriceList__c=OrderPrice.id;  
        insert op;
 
        Contract contract = new Contract();        
        contract.Spares_Price_List__c = OrderPrice.id;
        contract.Order_Price_List__c = OrderPrice.id;
        contract.AccountId = acc.id;
        contract.Payment_Terms__c = 'Net 30';
        contract.Delivery_Method__c ='ViaSat direct ship (cost + 15%)';
        
        contract.Business_Type__c ='Tooway';
        contract.Status = 'Draft';
        contract.CurrencyIsoCode ='USD';
        
        contract.StartDate = date.today();
        contract.ContractTerm =50;
        contract.Terminals_Quantity__c = 1;
        insert contract; 
        
        Contract con3 = [Select contractnumber,EndDate,Delivery_Method__c from Contract where id =:contract.id];
        
        Order__c order = new Order__c();   
        order.Account__c=acc.id;
        order.Status__c = 'Booked';   
        order.ShipToAddress__c = add1.id;
        order.BillToAddress__c = add.id;
        order.NotesComments__c = 'Test';
        order.Contract__c = con3.ContractNumber;
        order.Task__c = 'Test';
        order.AgreetoTermsConditions__c =true;
        order.Requested_Delivery_Datepl__c='Delivered By';
        order.Discount__c=300.00;
        insert order; 
        List<Address__c> addrList =new list<Address__c>();            
        addrList = [Select Id, Name, VAT__c,Type__c from Address__c where Default__c = true and Account__c =: con.AccountId and (End_Date__c >= today or End_Date__c = null)];
                                    
        orderline__c ol=new orderline__c();
        ol.SerialNo__c='123';
        ol.ShipToAddress__c=add2.id;
        ol.PartNumber__c=pdt.id;
        ol.Quantity__c=2;
        ol.Order__c=order.id; 
        ol.Order_Price__c=op.id;        
        ol.Related_Antenna__c=pdt.id;       
        ol.status__c='All';
        ol.Random_Number__c = 123;      
        insert ol; 
        
        PageReference pageRef = Page.ToowayOrderAdmin;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('id',order.id);
        ApexPages.currentPage().getParameters().put('viewmode','True');
        boolean viewmode;
        String orderid;
        ApexPages.StandardController controller = new ApexPages.StandardController(order);
        ToowayOrderAdminController TOA = new ToowayOrderAdminController(controller);
    
        Test.StartTest();
        TOA.SaveTerminal();
        TOA.getterminals();
        TOA.reviewnsubmit();
        TOA.AddTerminal();
        TOA.SaveTerminal();
        TOA.selectedsave();
        TOA.getterminals();
        TOA.cancel2();
        TOA.cancelorder();
        TOA.submit();
        TOA.save();
        TOA.edit();
        TOA.myorders();
        TOA.selecteddelete();
        TOA.gettotalantenna();
        TOA.EditTerminal(); 
        TOA.DeleteTerminal();
        TOA.createnew(); 
        TOA.cancel();
        TOA.getprofee();
        TOA.ContractFields(); 
        TOA.createorderline();
        TOA.ContactyourSalesRepresentative();
        TOA.checkcontract = false;
        Test.StopTest(); 
        }                 
    }
    
    static testmethod void ToowayOrderAdminControllerTest11()
    {
        profile profileid = [ Select id from Profile where name = 'Order Customer Portal Users'];
        Userrole Usrole = [Select id from userrole where name = 'Carlsbad NOC'];
        
        Account A1 = new Account(Name = 'Test Account');
        insert A1;
        
        List<Contact> ContactList = new List<Contact>();
        Contact C1 = new Contact( AccountID = A1.id, FirstName = 'Test', LastName = 'User', 
        email = 'test-user@fakeemail.com');
        insert C1;
        
        User u1;
        User admin = [Select id from user where id=:UserInfo.getUserId()];
        system.runas(admin)
        {
        u1 = new User( email='test-user@fakeemail.com', contactID = C1.id, profileid = profileid.id, 
        UserName='test-user@fakeemail.com', alias='tuser1', CommunityNickName='tuser1', 
        TimeZoneSidKey='America/New_York', LocaleSidKey='en_US', EmailEncodingKey='ISO-8859-1', 
        LanguageLocaleKey='en_US', FirstName = 'Test', LastName = 'User');
        insert u1;
        }             
        
        System.Runas(u1)        
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
        add.Type__c='Bill To';
        add.VAT__c = 'Add';
        add.Default__c = true;
        add.End_Date__c = system.today()+2;
        add.Account__c=con.Accountid;
        insert add;
        
        Address__c add1 = new Address__c();
        add1.Address__c='asd';
        add1.Type__c='Ship To';
        add1.VAT__c = 'Add';
        add1.Default__c = true;
        add1.End_Date__c = system.today()+2;
        add1.Account__c=con.Accountid;
        insert add1;
        
        Address__c add2 = new Address__c();
        add2.Address__c='asd';
        add2.Type__c='Ship To';
        add2.VAT__c = 'Add';
        add2.Default__c = false;
        add2.End_Date__c = system.today()+1;
        add2.Account__c=acc.id;
        insert add2;
        
        Product2 pdt1 = new Product2();
        pdt1.CurrencyIsoCode = 'USD';
        pdt1.Name='Spares';
        pdt1.Product_Category__c='Antenna';
        insert pdt1;        
 
        OrderPrice__c OrderP = new OrderPrice__c();
        OrderP.Product__c=pdt1.id;
        OrderP.Price__c=500; 
        OrderP.PriceList__c=OrderPrice.id;  

        Product2 pdt = new Product2();
        pdt.CurrencyIsoCode = 'USD';
        pdt.Name = 'prodtest10';
        pdt.Product_Category__c='Antenna';
        insert pdt;        
    
        OrderPrice__c op=new OrderPrice__c();
        op.Product__c=pdt.id;
        op.Price__c=500; 
        op.PriceList__c=OrderPrice.id;  
        insert op;
 
        Contract contract = new Contract();
        contract.Spares_Price_List__c = OrderPrice.id;
        contract.Order_Price_List__c = OrderPrice.id;
        contract.AccountId = acc.id;
        contract.Payment_Terms__c = 'Net 30';
        contract.Delivery_Method__c ='ViaSat direct ship (cost + 15%)';
        contract.Business_Type__c ='Tooway';
        contract.Status = 'Draft';
        contract.CurrencyIsoCode ='USD';
        contract.StartDate = date.today();
        contract.ContractTerm =50;
        contract.Terminals_Quantity__c = 1;
        insert contract;
        
        Contract con3 = [Select contractnumber,EndDate,Delivery_Method__c from Contract where id =:contract.id];
        
        Order__c order = new Order__c();   
        order.Account__c=acc.id;
        order.Status__c = 'Pending Submission';   
        order.ShipToAddress__c = add1.id;
        order.BillToAddress__c = add.id;
        order.NotesComments__c = 'Test';
        order.Contract__c = con3.ContractNumber;      
        order.Task__c = 'Test';
        order.AgreetoTermsConditions__c =true;
        order.Requested_Delivery_Datepl__c='Delivered By';
        order.Requested_Delivery_Date__c = null;
        order.Contract_Exp_Date__c = system.today();
        order.Delivery_Method__c = 'NTTDATA1';
        order.CustomerPO__c = 'TEST123';
        insert order; 
                           
        orderline__c ol=new orderline__c();
        ol.SerialNo__c='123';
        ol.ShipToAddress__c=add1.id;
        ol.PartNumber__c=pdt.id;
        ol.Quantity__c=2;
        ol.Order__c=order.id; 
        ol.Order_Price__c=op.id;        
        ol.Related_Antenna__c=pdt.id;
        ol.status__c='All'; 
        ol.Random_Number__c = 123;
        insert ol;  
        
        
        String myString3 = 'Test';
        Attachment a = new Attachment();
        a.ParentId = order.id;
        a.Body = Blob.valueof(myString3);
        a.Name = 'ravi';
        insert a; 
        
        PageReference pageRef = Page.ToowayOrderAdmin;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('id',null);
       // ApexPages.currentPage().getParameters().put('viewmode','True');
        ApexPages.currentPage().getParameters().put('ToowayOrderNotes',order.id);
         ApexPages.currentPage().getParameters().put('ToowayAddTerminal',order.id);
        boolean viewmode;
        String orderid;
        ApexPages.StandardController controller = new ApexPages.StandardController(order);
        ToowayOrderAdminController TOA = new ToowayOrderAdminController(controller);
    
        Test.StartTest();
        TOA.accountId=acc.id;
        TOA.SaveTerminal();
        TOA.getterminals();
        TOA.reviewnsubmit();
        TOA.AddTerminal();
        TOA.SaveTerminal();
        TOA.selectedsave();
        TOA.getterminals();
        TOA.cancel2();
        TOA.cancelorder();
        //TOA.submit();
        TOA.save();
        TOA.edit();
        TOA.myorders();
        TOA.selecteddelete();
        TOA.gettotalantenna();
        TOA.EditTerminal(); 
        TOA.DeleteTerminal();
        TOA.createnew(); 
        TOA.cancel();
        TOA.getprofee();
        TOA.ContractFields(); 
        TOA.createorderline();
        TOA.ContactyourSalesRepresentative();
        TOA.gettemp();
        TOA.getlistattachments();
        TOA.getmyfile();
        TOA.checkcontract = false;
        Test.StopTest(); 
        }                 
    }
     
}