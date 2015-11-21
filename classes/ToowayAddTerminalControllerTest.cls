//Test Method for the Apex Class ToowayAddTerminalControllerTest

@isTest(SeeAllData = true)
public class ToowayAddTerminalControllerTest
    {
          
        static testMethod void ToowayAddTerminalControllerTest1()
        {
            OrderPriceList__c opl2=new OrderPriceList__c();
            opl2.Name='OPL';
            opl2.CurrencyIsoCode='USD';
            insert opl2;

        Integer numOfObjs = 1;
        List<Account> accounts = ViasatTestUtility.createAccounts(numOfObjs, 'test');
        insert accounts;
        List<Contact> contacts = ViasatTestUtility.createContacts(accounts, numOfObjs);
        insert contacts;      

        Account acc2 = accounts[0];
		Contact con2 = contacts[0];

            Address__c add2 = new Address__c();
            add2.Address__c='asd';
            add2.Type__c='Bill To';
            add2.Account__c=acc2.id;
    
            Product2 productId = new Product2();
            productId.CurrencyIsoCode = 'USD';
            productId.Name='456';
            productId.Family='SurfBeam 2';
            productId.Product_Category__c='modem';
            productId.Product_Short_Description__c='shortdesc';
            productId.ProductGrade__c='Consumer';
            insert productId;   

            OrderPrice__c op2=new OrderPrice__c();
            op2.Product__c=productId.id;
            op2.Price__c=500;  
//            op2.Name='900';
            op2.PriceList__c=opl2.id;    
            insert op2;    
 
            Contract contract = new Contract();
            contract.Spares_Price_List__c = opl2.id;
            contract.Order_Price_List__c = opl2.id;
            contract.Name = 'Testing';
            contract.Terminals_Quantity__c = 123;
            contract.AccountId = acc2.id;
            contract.Payment_Terms__c = 'Net 30';
            contract.Delivery_Method__c ='ViaSat direct ship (cost + 15%)';    
            contract.Business_Type__c ='Tooway';
            contract.Status = 'Draft';
            contract.CurrencyIsoCode ='USD';        
            contract.StartDate = date.today();
            contract.ContractTerm =50;       
            insert contract; 
         
            Contract con3 = [Select contractnumber from Contract where id =:contract.id];
            
            Order__c order2=new Order__c();       
            order2.Account__c=acc2.id;
            order2.Requestor__c=con2.id;
            order2.AgreetoTermsConditions__c=true;
            order2.BillToAddress__c=add2.id;
            order2.ShipToAddress__c=add2.id;        
            order2.Contract__c = con3.ContractNumber;
            order2.Requested_Delivery_Datepl__c='ASAP';
            insert order2; 

            orderline__c ol2=new orderline__c();
            ol2.SerialNo__c='123';
            ol2.ShipToAddress__c=add2.id;
            ol2.PartNumber__c=productId.id;
            ol2.Quantity__c=2;
            ol2.Order__c=order2.id; 
            ol2.Order_Price__c=op2.id;  
            ol2.Related_Antenna__c=productId.id;
            ol2.Quantity__c=5;
            ol2.Product_Category__c = 'Modem';
            ol2.Random_Number__c = 123;
            insert ol2;
        
            PageReference pageRef2 = Page.ToowayAddTerminal; 
            pageRef2.getParameters().put('id', order2.id);
            pageRef2.getParameters().put('editTerminalID',ol2.id);
            pageRef2.getParameters().put('viewmode','True');
            Test.setCurrentPage(pageRef2);
          
            List<OrderPrice__c> lstordrprice = new list<OrderPrice__c>();
            ApexPages.StandardSetController setCon = new ApexPages.StandardSetController(lstordrprice);
            //ToowayAddTerminalController ext = new ToowayAddTerminalController(setCon);
        
            ToowayAddTerminalController.ModemTRIAWrapper m2=new ToowayAddTerminalController.ModemTRIAWrapper('modemname',op2);
            List<ToowayAddTerminalController.ModemTRIAWrapper> ml2=new List<ToowayAddTerminalController.ModemTRIAWrapper>();
            ml2.add(m2);

            ToowayAddTerminalController TAT2= new ToowayAddTerminalController();
            ToowayAddTerminalController.OrderPriceWrapper opw2=new ToowayAddTerminalController.OrderPriceWrapper(op2, ml2, ml2, 2);
            opw2.getCounter();
            opw2.getQuantity();
            opw2.setQuantity(2);
            TAT2.setCon = null;
            //TAT2.orderPriceList = lstordrprice;
            
            TAT2.resultSize = lstordrprice.size();
            TAT2.selectedAntennaOrderPriceWrapper=opw2;
            TAT2.isPageInEditMode=true;
            TAT2.populatePartAssociations();
            TAT2.populate_Radio_Button_Selection_GetSet();
            TAT2.addTerminalToOrder();
            TAT2.toggleSort();
            TAT2.cancelAction();
            TAT2.getCategoriesForAntenna();
            TAT2.resultSize=2;
            TAT2.next();
            TAT2.previous();
            TAT2.first();
            TAT2.last();
        }
        
   static testMethod void ToowayAddTerminalControllerTest11()
   {
            
            Schema.DescribeSObjectResult OnDesc = Schema.SObjectType.OrderLine__c;
            Map<String,Schema.RecordTypeInfo> OnRTMapByName = OnDesc .getRecordTypeInfosByName();
            Schema.RecordTypeInfo OnRTByName = OnRTMapByName .get('Order');
            ID OnRecId = OnRTByName.getRecordTypeId();
            
            OrderPriceList__c opl2=new OrderPriceList__c();
            opl2.Name='OPL';
            opl2.CurrencyIsoCode='USD';
            insert opl2;

        Integer numOfObjs = 1;
        List<Account> accounts = ViasatTestUtility.createAccounts(numOfObjs, 'test');
        insert accounts;
        List<Contact> contacts = ViasatTestUtility.createContacts(accounts, numOfObjs);
        insert contacts;      

        Account acc2 = accounts[0];
		Contact con2 = contacts[0];

            Address__c add2 = new Address__c();
            add2.Address__c='asd';
            add2.Type__c='Bill To';
            add2.Account__c=acc2.id;
            insert add2;
            
            
            Address__c add3 = new Address__c();
            add3.Address__c='asd';
            add3.Type__c='Ship To';
            add3.Account__c=acc2.id;
            insert add3;
    
            Product2 productId = new Product2();
            productId.CurrencyIsoCode = 'USD';
            productId.Name='456';
            productId.Family='SurfBeam 2';
            productId.Product_Category__c='TRIA';
            productId.Product_Short_Description__c='shortdesc';
            productId.ProductGrade__c='Consumer';
            insert productId;   

            OrderPrice__c op2=new OrderPrice__c();
            op2.Product__c=productId.id;
            op2.Price__c=500;  
//            op2.Name='900';
            op2.PriceList__c=opl2.id;    
            insert op2;    
 
            Contract contract = new Contract();
            contract.Spares_Price_List__c = opl2.id;
            contract.Order_Price_List__c = opl2.id;
            contract.Name = 'Testing';
            contract.Terminals_Quantity__c = 123;
            contract.AccountId = acc2.id;
            contract.Payment_Terms__c = 'Net 30';
            contract.Delivery_Method__c ='ViaSat direct ship (cost + 15%)';    
            contract.Business_Type__c ='Tooway';
            contract.Status = 'Draft';
            contract.CurrencyIsoCode ='USD';        
            contract.StartDate = date.today();
            contract.ContractTerm =50;       
            insert contract; 
         
            Contract con3 = [Select contractnumber from Contract where id =:contract.id];
            
            Order__c order2=new Order__c();       
            order2.Account__c=acc2.id;
            order2.Requestor__c=con2.id;
            order2.AgreetoTermsConditions__c=true;
            order2.BillToAddress__c=add2.id;
            order2.ShipToAddress__c=add2.id;        
            order2.Contract__c = con3.ContractNumber;
            order2.Requested_Delivery_Datepl__c='ASAP';
           
            insert order2; 

            orderline__c ol2=new orderline__c();
            ol2.SerialNo__c='123';
            ol2.ShipToAddress__c=add3.id;
            ol2.PartNumber__c=productId.id;
            ol2.Quantity__c=2;
            ol2.Order__c=order2.id; 
            ol2.Order_Price__c=op2.id;  
            ol2.Related_Antenna__c=productId.id;
            ol2.Quantity__c=5;
            ol2.Product_Category__c = 'Modem';
            ol2.Random_Number__c = 123;
            ol2.RecordTypeId=OnRecId;
            insert ol2;
        
            PageReference pageRef2 = Page.ToowayAddTerminal; 
            pageRef2.getParameters().put('id', order2.id);
            pageRef2.getParameters().put('editTerminalID',ol2.id);
            pageRef2.getParameters().put('viewmode','True');
            Test.setCurrentPage(pageRef2);
          
            List<OrderPrice__c> lstordrprice = new list<OrderPrice__c>();
            lstordrprice.add(op2);
            ApexPages.StandardSetController setCon = new ApexPages.StandardSetController(lstordrprice);
            setCon.getHasPrevious();
            
            //ToowayAddTerminalController ext = new ToowayAddTerminalController(setCon);
        
            ToowayAddTerminalController.ModemTRIAWrapper m2=new ToowayAddTerminalController.ModemTRIAWrapper('modemname',op2);
            List<ToowayAddTerminalController.ModemTRIAWrapper> ml2=new List<ToowayAddTerminalController.ModemTRIAWrapper>();
            ml2.add(m2);

            ToowayAddTerminalController TAT2= new ToowayAddTerminalController();
            ToowayAddTerminalController.OrderPriceWrapper opw2=new ToowayAddTerminalController.OrderPriceWrapper(op2, ml2, ml2, 2);
            //TAT2.setCon.getRecords(lstordrprice);
            
            opw2.getCounter();
            opw2.getQuantity();
            opw2.setQuantity(2);
            TAT2.setCon = null;
            //TAT2.orderPriceList = lstordrprice;            
            TAT2.resultSize = lstordrprice.size();
            //TAT2.selectedAntennaOrderPriceWrapper=opw2;
            ToowayAddTerminalController.OrderPriceWrapper selectedAntennaOrderPriceWrapper=opw2;
            TAT2.isPageInEditMode=false;
            TAT2.exceptionCaused = true;
            TAT2.populatePartAssociations();
            Boolean hasPrev=TAT2.hasPrev;           
            Boolean hasNext=TAT2.hasNext;
            String recordinfo=TAT2.recordinfo;
            String pageinfo=TAT2.pageinfo;
            String debugSoql=TAT2.debugSoql;
            
            //TAT2.populatePartAssociations.set(orderPriceAntennaList)=lstordrprice;
            TAT2.populate_Radio_Button_Selection_GetSet();
            TAT2.populate_Radio_Button_Selection();

            TAT2.addTerminalToOrder();
            TAT2.toggleSort();
            TAT2.cancelAction();
            TAT2.getCategoriesForAntenna();
            TAT2.resultSize=2;
            TAT2.next();
            TAT2.previous();
            TAT2.first();
            TAT2.last();           
           
        }


        static testMethod void ToowayAddTerminalControllerTest2()
        {
        
            OrderPriceList__c opl2=new OrderPriceList__c();
            opl2.Name='OPL';
            opl2.CurrencyIsoCode='USD';
            insert opl2;

        Integer numOfObjs = 1;
        List<Account> accounts = ViasatTestUtility.createAccounts(numOfObjs, 'test');
        insert accounts;
        List<Contact> contacts = ViasatTestUtility.createContacts(accounts, numOfObjs);
        insert contacts;      

        Account acc2 = accounts[0];
		Contact con2 = contacts[0];

            Address__c add2 = new Address__c();
            add2.Address__c='asd';
            add2.Type__c='Bill To';
            add2.Account__c=acc2.id;
    
            Product2 productId = new Product2();
            productId.CurrencyIsoCode = 'USD';
            productId.Name='456';
            productId.Family='SurfBeam 2';
            productId.Product_Category__c='TRIA';
            productId.Product_Short_Description__c='shortdesc';
            productId.ProductGrade__c='Consumer';
            insert productId;

            OrderPrice__c op2=new OrderPrice__c();
            op2.Product__c=productId.id;
            op2.Price__c=500;  
//          op2.Name='900';
            op2.PriceList__c=opl2.id;    
            insert op2;    

            Contract contract = new Contract();
            contract.Spares_Price_List__c = opl2.id;
            contract.Order_Price_List__c = opl2.id;
            contract.Name = 'Testing';
            contract.Terminals_Quantity__c = 123;
            contract.AccountId = acc2.id;
            contract.Payment_Terms__c = 'Net 30';
            contract.Delivery_Method__c ='ViaSat direct ship (cost + 15%)';
            contract.AccountId = acc2.id;
            contract.Business_Type__c ='Tooway';
            contract.Status = 'Draft';
            contract.CurrencyIsoCode ='USD';
            contract.AccountId = acc2.id;
            contract.StartDate = date.today();
            contract.ContractTerm =50;
            insert contract;
                
        	Contract objcontract = [select contractNumber from contract where id=:contract.id]; 
        	
            Order__c order2=new Order__c();       
            order2.Account__c=acc2.id;
            order2.Requestor__c=con2.id;
            order2.AgreetoTermsConditions__c=true;
            order2.BillToAddress__c=add2.id;
            order2.ShipToAddress__c=add2.id;
            order2.Contract__c = objcontract.ContractNumber;
            order2.Requested_Delivery_Datepl__c='ASAP';
            insert order2;
                
            orderline__c ol2=new orderline__c();
            ol2.SerialNo__c='123';
            ol2.ShipToAddress__c=add2.id;
            ol2.PartNumber__c=productId.id;
            ol2.Quantity__c=2;
            ol2.Order__c=order2.id; 
            ol2.Order_Price__c=op2.id;  
            ol2.Related_Antenna__c=productId.id;
            ol2.Quantity__c=5;
            ol2.Random_Number__c = 235689;
            insert ol2;
        
            PageReference pageRef2 = Page.ToowayAddTerminal;
            Test.setCurrentPage(pageRef2);
            
            List<OrderPrice__c> lstordrprice = new list<OrderPrice__c>();
            lstordrprice.add(op2);
            
            Apexpages.currentPage().getParameters().put('id',order2.id);
            pageRef2.getParameters().put('productId',string.valueOf(ol2.Random_Number__c));
            ApexPages.currentPage().getParameters().put('viewmode','True');

            ToowayAddTerminalController.ModemTRIAWrapper m2=new ToowayAddTerminalController.ModemTRIAWrapper('modemname',op2);
            List<ToowayAddTerminalController.ModemTRIAWrapper> ml2=new List<ToowayAddTerminalController.ModemTRIAWrapper>();
            ml2.add(m2);

            ToowayAddTerminalController TAT2= new ToowayAddTerminalController();
            ToowayAddTerminalController.OrderPriceWrapper opw2=new ToowayAddTerminalController.OrderPriceWrapper(op2, ml2, ml2, 2);
            
            opw2.antenna =op2;
            opw2.modemList = ml2;
            opw2.selectedModem = m2;
//            opw2.selectedAntennaOrderPriceWrapper();
            opw2.getCounter();
            opw2.getQuantity();
            opw2.setQuantity(2);
            
            TAT2.addTerminalToOrder();
			
			TAT2.exceptionCaused = false;
            TAT2.isPageInEditMode=false;
            
            TAT2.orderPriceList = lstordrprice;
            TAT2.populate_Radio_Button_Selection_GetSet();
            TAT2.selectedAntennaOrderPriceWrapper=opw2;
            TAT2.editAntennaOrderLineSalesforceId = ol2.id;
            
            TAT2.toggleSort();
            TAT2.cancelAction();
            TAT2.getCategoriesForAntenna();
            TAT2.resultSize=2;
            TAT2.next();
            TAT2.previous();
            TAT2.first();
            TAT2.last();
            TAT2.populatePartAssociations();
            
            TAT2.setCon = null;
            
    /*
            //list<OrderPrice__c> getorderPriceList = TAT2.orderPriceList;
            //Integer resultSize = TAT2.resultSize;
            //String debugSoql = TAT2.debugSoql;
            TAT2.isPageInEditMode=true;
            TAT2.selectedAntennaOrderPriceWrapper=opw2;
            TAT2.exceptionCaused = false;
            //TAT2.addTerminalToOrder();
  */
        }

        static testMethod void ToowayAddTerminalControllerTest3()
        {            
            OrderPriceList__c opl1=new OrderPriceList__c();
            opl1.Name='OPL';
            opl1.CurrencyIsoCode='USD';
            insert opl1;

        Integer numOfObjs = 1;
        List<Account> accounts = ViasatTestUtility.createAccounts(numOfObjs, 'test');
        insert accounts;
        List<Contact> contacts = ViasatTestUtility.createContacts(accounts, numOfObjs);
        insert contacts;      

        Account acc1 = accounts[0];
		Contact con1 = contacts[0];

            Address__c add1 = new Address__c();
            add1.Address__c='asd';
            add1.Type__c='Bill To';
            add1.Account__c=acc1.id;
        
            Product2 productId = new Product2();
            productId.CurrencyIsoCode = 'USD';
            productId.Name='456';
            productId.Family='SurfBeam 2';
            productId.Product_Category__c='Modem';
            productId.Product_Short_Description__c='shortdesc';
            productId.ProductGrade__c='Consumer';
            insert productId;
 
            OrderPrice__c op1 = new OrderPrice__c();
            op1.Product__c =productId.id;
            op1.Price__c = 500;  
//            op1.Name = '900';
            op1.PriceList__c = opl1.id;
           // op1.productId = op1.id;    
           // op1.Unique_ID__c = 'ravi';
            insert op1;    

            Contract contract = new Contract();
            contract.Spares_Price_List__c = opl1.id;
            contract.Order_Price_List__c = opl1.id;
            contract.Name = 'Testing';
            contract.Terminals_Quantity__c = 123;
            contract.AccountId = acc1.id;
            contract.Payment_Terms__c = 'Net 30';
            contract.Delivery_Method__c ='ViaSat direct ship (cost + 15%)';
            contract.AccountId = acc1.id;
            contract.Business_Type__c ='Tooway';
            contract.Status = 'Draft';
            contract.CurrencyIsoCode ='USD';
            contract.AccountId = acc1.id;
            contract.StartDate = date.today();
            contract.ContractTerm =50;
            insert contract; 
            
            Contract objcontract = [select contractNumber from contract where id=:contract.id]; 
        
            Order__c order3 = new Order__c();       
            order3.Account__c=acc1.id;
            order3.Requestor__c=con1.id;
            order3.AgreetoTermsConditions__c=true;
            order3.BillToAddress__c=add1.id;
            order3.ShipToAddress__c=add1.id;
            order3.Contract__c = objcontract.ContractNumber;
            order3.Requested_Delivery_Datepl__c='ASAP';
            insert order3;
 
            orderline__c ol1=new orderline__c();
            ol1.SerialNo__c='741';
            ol1.ShipToAddress__c=add1.id;
            ol1.PartNumber__c=productId.id;
            ol1.Quantity__c=2;
            ol1.Order__c=order3.id; 
            ol1.Order_Price__c=op1.id;  
            ol1.Related_Antenna__c=productId.id;
            ol1.Random_Number__c = 123;
            insert ol1;        
         
            PageReference pageRef1 = Page.ToowayAddTerminal;
            Test.setCurrentPage(pageRef1);

            Apexpages.currentPage().getParameters().put('id',order3.id);
            Apexpages.currentPage().getParameters().put('productId',String.valueOf(ol1.Random_Number__c));
            ApexPages.currentPage().getParameters().put('viewmode','True');
            
            ToowayAddTerminalController.ModemTRIAWrapper m2=new ToowayAddTerminalController.ModemTRIAWrapper('modemname',op1);
            List<ToowayAddTerminalController.ModemTRIAWrapper> ml2=new List<ToowayAddTerminalController.ModemTRIAWrapper>();
            ml2.add(m2);

           // ToowayAddTerminalController TAT2= new ToowayAddTerminalController();
            ToowayAddTerminalController.OrderPriceWrapper opw2=new ToowayAddTerminalController.OrderPriceWrapper(op1, ml2, ml2, 2);
      
            ToowayAddTerminalController TAT1 = new ToowayAddTerminalController();
            //ToowayAddTerminalController.OrderPriceWrapper orderW = new ToowayAddTerminalController.OrderPriceWrapper();
            ToowayAddTerminalController.OrderPriceWrapper odw;
            TAT1.selectedAntennaOrderPriceWrapper=opw2;
            
/*            //TAT1.isPageInEditMode =false;
            TAT1.getCategoriesForAntenna();  
            TAT1.toggleSort(); 
            TAT1.cancelAction();
            TAT1.resultSize=2;
            TAT1.isPageInEditMode=true;
            TAT1.exceptionCaused = false;
            //TAT1.addTerminalToOrder();
	*/		
			TAT1.addTerminalToOrder();
			TAT1.selectedAntennaOrderPriceWrapper=opw2;
			TAT1.exceptionCaused = false;
            TAT1.isPageInEditMode=true;
            TAT1.populatePartAssociations();
            TAT1.populate_Radio_Button_Selection_GetSet();
            TAT1.editAntennaOrderLineSalesforceId = ol1.id;
            
            TAT1.toggleSort();
            TAT1.cancelAction();
            TAT1.getCategoriesForAntenna();
            TAT1.resultSize=2;
            TAT1.next();
            TAT1.previous();
            TAT1.first();
            TAT1.last();

                      
        }
        
        static testMethod void ToowayAddTerminalControllerTest4()
        {            
            OrderPriceList__c opl1=new OrderPriceList__c();
            opl1.Name='OPL';
            opl1.CurrencyIsoCode='USD';
            insert opl1;

        Integer numOfObjs = 1;
        List<Account> accounts = ViasatTestUtility.createAccounts(numOfObjs, 'test');
        insert accounts;
        List<Contact> contacts = ViasatTestUtility.createContacts(accounts, numOfObjs);
        insert contacts;      

        Account acc = accounts[0];
		Contact con = contacts[0];

            Address__c add1 = new Address__c();
            add1.Address__c='asd';
            add1.Type__c='Bill To';
            add1.Account__c=acc.id;
        
            Product2 productId = new Product2();
            productId.CurrencyIsoCode = 'USD';
            productId.Name='456';
            productId.Family='SurfBeam 2';
            productId.Product_Category__c='Antenna';
            productId.Product_Short_Description__c='shortdesc';
            productId.ProductGrade__c='Consumer';
            productId.ProductExpirationDate__c=system.today();
            insert productId;
 
            OrderPrice__c op1 = new OrderPrice__c();
            op1.Product__c =productId.id;
            op1.Price__c = 500;  
//            op1.Name = '900';
            op1.PriceList__c = opl1.id;
           // op1.productId = op1.id;    
           // op1.Unique_ID__c = 'ravi';
            insert op1;    

            Contract contract = new Contract();
            contract.Spares_Price_List__c = opl1.id;
            contract.Order_Price_List__c = opl1.id;
            contract.Name = 'Testing';
            contract.Terminals_Quantity__c = 123;
            contract.AccountId = acc.id;
            contract.Payment_Terms__c = 'Net 30';
            contract.Delivery_Method__c ='ViaSat direct ship (cost + 15%)';
            contract.AccountId = acc.id;
            contract.Business_Type__c ='Tooway';
            contract.Status = 'Draft';
            contract.CurrencyIsoCode ='USD';
            contract.AccountId = acc.id;
            contract.StartDate = date.today();
            contract.ContractTerm =50;
            insert contract;  
            Contract objcontract = [select contractNumber from contract where id=:contract.id];
            
            Order__c order3 = new Order__c();       
            order3.Account__c=acc.id;
            order3.Requestor__c=con.id;
            order3.AgreetoTermsConditions__c=true;
            order3.BillToAddress__c=add1.id;
            order3.ShipToAddress__c=add1.id;
            order3.Contract__c = objcontract.ContractNumber;
            order3.Requested_Delivery_Datepl__c='ASAP';
            insert order3;
 
            orderline__c ol1=new orderline__c();
            ol1.SerialNo__c='741';
            ol1.ShipToAddress__c=add1.id;
            ol1.PartNumber__c=productId.id;
            ol1.Quantity__c=2;
            ol1.Order__c=order3.id; 
            ol1.Order_Price__c=op1.id;  
            ol1.Related_Antenna__c=productId.id;
            ol1.Random_Number__c = 123;
            insert ol1;        
         
            PageReference pageRef1 = Page.ToowayAddTerminal;
            Test.setCurrentPage(pageRef1);

            Apexpages.currentPage().getParameters().put('id',order3.id);
            Apexpages.currentPage().getParameters().put('productId',String.valueOf(ol1.Random_Number__c));
            ApexPages.currentPage().getParameters().put('viewmode','True');
            
            ToowayAddTerminalController.ModemTRIAWrapper m2=new ToowayAddTerminalController.ModemTRIAWrapper('modemname',op1);
            List<ToowayAddTerminalController.ModemTRIAWrapper> ml2=new List<ToowayAddTerminalController.ModemTRIAWrapper>();
            ml2.add(m2);

           // ToowayAddTerminalController TAT2= new ToowayAddTerminalController();
            ToowayAddTerminalController.OrderPriceWrapper opw2=new ToowayAddTerminalController.OrderPriceWrapper(op1, ml2, ml2, 2);
      
            ToowayAddTerminalController TAT1 = new ToowayAddTerminalController();
            //ToowayAddTerminalController.OrderPriceWrapper orderW = new ToowayAddTerminalController.OrderPriceWrapper();
            ToowayAddTerminalController.OrderPriceWrapper odw;
            TAT1.selectedAntennaOrderPriceWrapper=opw2;
            
            
            //TAT1.resultSize = lstordrprice.size();
            TAT1.selectedAntennaOrderPriceWrapper=opw2;
            TAT1.isPageInEditMode=true;
            TAT1.populatePartAssociations();
            TAT1.populate_Radio_Button_Selection_GetSet();
            TAT1.editAntennaOrderLineSalesforceId = ol1.id;
            TAT1.addTerminalToOrder();
            TAT1.toggleSort();
            TAT1.cancelAction();
            TAT1.getCategoriesForAntenna();
            TAT1.resultSize=2;
            TAT1.next();
            TAT1.previous();
            TAT1.first();
            TAT1.last();
           
           
           /* TAT1.addTerminalToOrder();
            TAT1.getCategoriesForAntenna();  
            TAT1.toggleSort(); 
            TAT1.cancelAction();
            TAT1.resultSize=2;
            TAT1.isPageInEditMode=true;
            TAT1.exceptionCaused = false;
            TAT1.editAntennaOrderLineSalesforceId = ol1.id;*/
            //TAT1.editModemOrderLineSalesforceId = ol1.id;
            
            //TAT1.populatePartAssociations();
            //TAT1.addTerminalToOrder();
                      
        }
        
            
    }