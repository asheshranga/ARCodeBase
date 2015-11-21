@isTest
public class OrderControllerTest {

	private static Account insertAccWithAddresses() { 

        Integer numOfObjs = 1;
        List<Account> accounts = ViasatTestUtility.createAccounts(numOfObjs, 'test');        
        insert accounts;
        
        Address__c sadd = new Address__c(name='test street');
        sadd.Account__c = accounts[0].Id;
        sadd.Type__c = 'Ship to';
        sadd.Default__c = true;
        insert sadd;
        
        Address__c badd = new Address__c(name='test street');
        badd.Account__c = accounts[0].Id;
        badd.Type__c = 'Bill to';
        badd.Default__c = true;
        insert badd;
        
        return accounts[0];
	}

	private static Account insertAccWithEBSAddresses() { 
        Account a = new Account(name = 'test');
        insert a;
        
        Address__c sadd = new Address__c(name='test street');
        sadd.Account__c = a.Id;
        sadd.Type__c = 'Ship to';
        sadd.Default__c = true;
        sadd.EBSAddressID__c = '222';
        insert sadd;
        
        Address__c badd2 = new Address__c(name='test street');
        badd2.Account__c = a.Id;
        badd2.Type__c = 'Bill to';
        badd2.Default__c = true;
        badd2.EBSAddressID__c = '222';
        insert badd2;
        
        return a;
	}
	
	private static Order__c createOrder(Account a) 
	{ 
        Address__c sadd = [SELECT id FROM Address__c WHERE Account__c = :a.Id and Type__c = 'Ship to' LIMIT 1];
        
        Order__c o = new Order__c();
        o.Account__c = a.id;
        o.Drop_Shipment__c=false;
        o.ShipToAddress__c = sadd.Id;
        return o;
	}

	public static testMethod void testOrderLinePOCControllerStdUser() { 

        Account a = insertAccWithAddresses();
        Order__c c = createOrder(a);
        c.Status__c = 'Cancelled';
        insert c;

        Profile p = [SELECT Id FROM Profile WHERE Name='AMS CSR User']; 
        User u = new User(Alias = 'stdrma', Email='standardusertestrma@testorg.com', 
        EmailEncodingKey='UTF-8', LastName='Test1rma', LanguageLocaleKey='en_US', 
        LocaleSidKey='en_US', ProfileId = p.Id, 
        TimeZoneSidKey='America/Los_Angeles', UserName='standardusertestrma@testorg.com');
    
		Test.startTest();
        System.runAs(u) {
        ApexPages.Standardcontroller controller2 = new ApexPages.Standardcontroller(c);
        OrderController orderLinePOCController2 = new OrderController(controller2);            
        }    
        Test.stopTest();    
    }
    
	public static testMethod void testOrderLinePOCController() { 
        
        Account a = insertAccWithAddresses();
        Order__c c = createOrder(a);
        c.Status__c = 'Cancelled';
//???        c.OrderTypeId__c = 'Test';
        insert c;
        
		Test.startTest();

        ApexPages.Standardcontroller controller3 = new ApexPages.Standardcontroller(c);
        OrderController orderLinePOCController3 = new OrderController(controller3);
        
        orderLinePOCController3.defaultAddresses();
        orderLinePOCController3.getLines();
        orderLinePOCController3.deleteRMA();
        orderLinePOCController3.toggleSort();
        orderLinePOCController3.uploadLines();

        Test.stopTest();    
	}
    
	public static testMethod void testsave(){

        Account a = insertAccWithAddresses();
        Order__c c = createOrder(a);
        c.AgreetoTermsConditions__c = true;
        c.AgreetoRMAReturnConditions__c = false;        
        insert c;
        
        Order__c c2 = createOrder(a);
        c2.AgreetoTermsConditions__c = true;
        c2.AgreetoRMAReturnConditions__c = true;
        c2.PreferredCarrier__c = null;
        insert c2;

        OrderLine__c ol1 = new OrderLine__c();
        ol1.Part_Number_2__c = 'SR3000';
        ol1.SerialNo__c = '123456';
        ol1.ReturnReasonDescription__c = 'test';
        ol1.Order__c = c2.Id;
        insert ol1;

        Order__c c4 = createOrder(a);
        c4.AgreetoTermsConditions__c = false;
        c4.AgreetoRMAReturnConditions__c = false;
        insert c4;
        
        
		Test.startTest();

        ApexPages.Standardcontroller controller2 = new ApexPages.Standardcontroller(c);
        OrderController orderLinePOCController2 = new OrderController(controller2);
        orderLinePOCController2.changelabel();
        orderLinePOCController2.getmyfile();
        orderLinePOCController2.save();
                
        
        ApexPages.Standardcontroller controller3 = new ApexPages.Standardcontroller(c2);
        OrderController orderLinePOCController3 = new OrderController(controller3);
        orderLinePOCController3.orderlinesdelete = null;
       // orderLinePOCController3.save();
        orderLinePOCController3.uploadLines();
        orderLinePOCController3.escalateToCSR();
        
        OrderLine__c ol2 = new OrderLine__c();
        ol2.Order__c = c2.Id;
        insert ol2;
        
        OrderLine__c ol3 = new OrderLine__c();
        ol3.Order__c = c2.Id;
        ol3.Part_Number_2__c = 'SR3000';        
        insert ol3;
        
        OrderLine__c ol4 = new OrderLine__c();
        
        ApexPages.Standardcontroller controller4 = new ApexPages.Standardcontroller(c2);
        OrderController orderLinePOCController4 = new OrderController(controller4);
        orderlinePOCController4.selectedOrderTypeId = '1885';
        orderlinePOCController4.selectedServiceTypeId = null;
        
        orderLinePOCController4.orderlines.add(ol4);        
        orderLinePOCController4.save();
        orderLinePOCController4.escalateToCSR();
        

        ApexPages.Standardcontroller controller5 = new ApexPages.Standardcontroller(c4);
        OrderController orderLinePOCController5 = new OrderController(controller5);
        
        orderLinePOCController5.save();
        
        Order__c c5 = CreateOrder(a);
        //c.Status__c = System.Label.RMASubmitStatus;       
        c5.AgreetoTermsConditions__c = true;
        c5.AgreetoRMAReturnConditions__c = true;
        //c5.PreferredCarrier__c = 'AIT Global';
        c5.CarrierAccount__c = '';
        insert c5;
        
        ApexPages.Standardcontroller controller6 = new ApexPages.Standardcontroller(c5);
        OrderController orderLinePOCController6 = new OrderController(controller6);
        orderLinePOCController6.o.PreferredCarrier__c = 'Test';
         orderLinePOCController2.changelabel();
        orderLinePOCController6.getmyfile();
        orderLinePOCController6.save();
        
        Order__c c6 = CreateOrder(a);
        //c.Status__c = System.Label.RMASubmitStatus;        
        c6.AgreetoTermsConditions__c = true;
        c6.AgreetoRMAReturnConditions__c = true;
        c6.PreferredCarrier__c = null;
        insert c6;
        
        ApexPages.Standardcontroller controller7 = new ApexPages.Standardcontroller(c6);
        OrderController orderLinePOCController7 = new OrderController(controller7);
        orderlinePOCController7.selectedOrderTypeId = '10200';
        orderlinePOCController7.selectedServiceTypeId = null;
        
        orderLinePOCController7.save();
        
        Order__c c7 = CreateOrder(a);
        c7.AgreetoTermsConditions__c = true;
        c7.AgreetoRMAReturnConditions__c = true;
        c7.PreferredCarrier__c = null;
        insert c7;
        
        ApexPages.Standardcontroller controller8 = new ApexPages.Standardcontroller(c7);
        OrderController orderLinePOCController8 = new OrderController(controller8);
        orderlinePOCController8.selectedOrderTypeId = null;
        orderlinePOCController8.selectedServiceTypeId = '22';
        
        orderLinePOCController8.save();

        Test.stopTest();    
	}
        
	public static testMethod void testsaveerror(){
        Account a = insertAccWithAddresses();
        
        Order__c c = new Order__c();
        c.Account__c = a.id;
        //c.Status__c = System.Label.RMASubmitStatus;
        c.Status__c = 'Cancelled';
        c.AgreetoTermsConditions__c = true;
        c.AgreetoRMAReturnConditions__c = true;
        
        //insert c;
        
        Test.startTest();    

        ApexPages.Standardcontroller controller2 = new ApexPages.Standardcontroller(c);

        OrderController orderLineController2 = new OrderController(controller2);
        orderLineController2.orderlines = null;
        orderLineController2.save();

        OrderLinePOCController orderLinePOCController2 = new OrderLinePOCController(controller2);
        orderLinePOCController2.orderlines = null;
        orderLinePOCController2.save();       

        Test.stopTest();    
    }
    

	static testMethod void testAttachments()
    {
        Account a = insertAccWithAddresses();
        Order__c Ord = createOrder(a);
        Ord.AgreetoTermsConditions__c = true;
        Ord.AgreetoRMAReturnConditions__c = true;
        insert Ord;
 
        Attachment attach=new Attachment();     
        attach.Name='Unit Test Attachment';
        Blob bodyBlob=Blob.valueOf('Unit Test Attachment Body');
        attach.body=bodyBlob;
        attach.parentId=Ord.id;
        insert attach;
        
        List<Attachment> attachments=[select id, name from Attachment where parent.id=:Ord.id];
        System.assertEquals(1, attachments.size());
	}    
         
	public static testMethod void testinvokeExternalWs(){
		
        Account a = insertAccWithAddresses();
        Order__c o = createOrder(a);
        //o.Status__c = System.Label.RMASubmitStatus;        
        o.AgreetoTermsConditions__c = true;
        o.AgreetoRMAReturnConditions__c = true;
        insert o;
        
        Attachment attach=new Attachment();    
        attach.Name='Unit Test Attachment';
        Blob bodyBlob=Blob.valueOf('Unit Test Attachment Body');
        attach.body=bodyBlob;
        attach.parentId=o.id;
        insert attach;
        
        OrderLine__c ol = new OrderLine__c();
        ol.Part_Number_2__c = 'SR3000';
        ol.SerialNo__c = '123456';
        ol.ReturnReasonDescription__c = 'test';
        ol.Order__c = o.Id;
        insert ol;

        Order__c c2 = createOrder(a);
        //c.Status__c = System.Label.RMASubmitStatus;
        c2.AgreetoTermsConditions__c = true;
        c2.AgreetoRMAReturnConditions__c = true;
        insert c2;
               
		Test.startTest(); 
		
        ApexPages.Standardcontroller controller1 = new ApexPages.Standardcontroller(o);
        OrderController orderLinePOCController1 = new OrderController(controller1);
        orderlinePOCController1.myfile = attach;
        //orderLinePOCController1.getmyfile();
        orderLinePOCController1.save();
        orderLinePOCController1.savedoc();
        orderLinePOCController1.mainForTestSuccess(ol.Id);
        orderLinePOCController1.invokeExternalWs(); 


    
		// testsubmitAction()
        ApexPages.Standardcontroller controller3 = new ApexPages.Standardcontroller(c2);
        Apexpages.currentPage().getParameters().put('submit','1');
        
        OrderController orderLinePOCController3 = new OrderController(controller3);
        orderlinePOCController3.selectedOrderTypeId = '1885';
        orderlinePOCController3.selectedServiceTypeId = null;
        orderLinePOCController3.submitAction();
        
        OrderLine__c ol1 = new OrderLine__c();
        ol1.Part_Number_2__c = 'SR3000';
        ol1.SerialNo__c = '123456';
        ol1.ReturnReasonDescription__c = 'test';
        ol1.Order__c = c2.Id;
        ol1.ShipToAddress__c = c2.ShipToAddress__c;
        insert ol1;
        ApexPages.Standardcontroller controller4 = new ApexPages.Standardcontroller(c2);
        Apexpages.currentPage().getParameters().put('submit','1');
        
        OrderController orderLinePOCController4 = new OrderController(controller4);
        
        orderLinePOCController4.mainForTestSuccess(ol1.Id);
        orderLinePOCController4.orderlines.add(ol1);
        orderLinePOCController4.submitAction();
        //orderLinePOCController3.save();
        
        //orderLinePOCController4.mainForTestError();
        //orderLinePOCController4.submitAction();
        
        Test.stopTest();
	}

	public static testMethod void testsubmitCompusec(){
        Account a = insertAccWithAddresses();
        Order__c c2 = createOrder(a);
        c2.AgreetoTermsConditions__c = true;
        c2.AgreetoRMAReturnConditions__c = true;
        c2.ComSecDoDAACRequirement__c = 'Yes';
        insert c2;
        
        Test.startTest();

        ApexPages.Standardcontroller controller3 = new ApexPages.Standardcontroller(c2);
        Apexpages.currentPage().getParameters().put('submit','1');
        
        OrderController orderLinePOCController3 = new OrderController(controller3);
        orderLinePOCController3.submitAction();
        
        
        OrderLine__c ol1 = new OrderLine__c();
        ol1.Part_Number_2__c = 'SR3000';
        ol1.SerialNo__c = '123456';
        ol1.ReturnReasonDescription__c = 'test';
        ol1.Order__c = c2.Id;
        ol1.ShipToAddress__c = c2.ShipToAddress__c;
        insert ol1;
        ApexPages.Standardcontroller controller4 = new ApexPages.Standardcontroller(c2);
        Apexpages.currentPage().getParameters().put('submit','1');
        Apexpages.currentPage().getParameters().put('lineSelection','1');        
                
        OrderController orderLinePOCController4 = new OrderController(controller4);
        
        orderLinePOCController4.mainForTestSuccess(ol1.Id);
        orderLinePOCController4.orderlines.add(ol1);
        orderLinePOCController4.submitAction();
        orderLinePOCController4.getLines();
		List<selectOption> sel = orderLinePOCController4.orderTypes;
		sel = orderLinePOCController4.serviceTypes;
		pageReference p = orderLinePOCController4.redirectToObject();
		
        Test.stopTest();
	}
    
	public static testMethod void testsubmitAddressEBS(){

		Account a = insertAccWithEBSAddresses();
        Address__c badd = [SELECT id FROM Address__c WHERE Account__c = :a.Id and Type__c = 'Bill to' LIMIT 1];
        
        Order__c c2 = CreateOrder(a);
        //c.Status__c = System.Label.RMASubmitStatus;
        c2.AgreetoTermsConditions__c = true;
        c2.AgreetoRMAReturnConditions__c = true;
        c2.BillToAddress__c = badd.id;
        insert c2;
        
        Test.startTest();

        ApexPages.Standardcontroller controller3 = new ApexPages.Standardcontroller(c2);
        Apexpages.currentPage().getParameters().put('submit','1');
        
        OrderController orderLinePOCController3 = new OrderController(controller3);
        orderLinePOCController3.submitAction();
        
        
        OrderLine__c ol1 = new OrderLine__c();
        ol1.Part_Number_2__c = 'SR3000';
        ol1.SerialNo__c = '123456';
        ol1.ReturnReasonDescription__c = 'test';
        ol1.Order__c = c2.Id;
        ol1.ShipToAddress__c = c2.ShipToAddress__c;
        insert ol1;
        ApexPages.Standardcontroller controller4 = new ApexPages.Standardcontroller(c2);
        Apexpages.currentPage().getParameters().put('submit','1');
        
        OrderController orderLinePOCController4 = new OrderController(controller4);
        
        orderLinePOCController4.mainForTestSuccess(ol1.Id);
        orderLinePOCController4.orderlines.add(ol1);
        orderLinePOCController4.submitAction();
        //orderLinePOCController3.save();
        
        //orderLinePOCController4.mainForTestError();
        //orderLinePOCController4.submitAction();

        Test.stopTest();
    }
    
      public static testMethod void testsubmitAddressEBS2(){
        Account a = insertAccWithEBSAddresses();
        Address__c saddl = new Address__c(name='test street');
        saddl.Account__c = a.Id;
        saddl.Type__c = 'Ship to';
        saddl.Default__c = false;
        saddl.EBSAddressID__c = '0';
        insert saddl;
                
        Order__c c2 = CreateOrder(a);
        //c.Status__c = System.Label.RMASubmitStatus;
        c2.AgreetoTermsConditions__c = true;
        c2.AgreetoRMAReturnConditions__c = true;
        insert c2;
        
        Test.startTest();
        
        ApexPages.Standardcontroller controller3 = new ApexPages.Standardcontroller(c2);
        Apexpages.currentPage().getParameters().put('submit','1');
        
        OrderController orderLinePOCController3 = new OrderController(controller3);
        orderLinePOCController3.submitAction();
        
        
        OrderLine__c ol1 = new OrderLine__c();
        ol1.Part_Number_2__c = 'SR3000';
        ol1.SerialNo__c = '123456';
        ol1.ReturnReasonDescription__c = 'test';
        ol1.Order__c = c2.Id;
        ol1.ShipToAddress__c = c2.ShipToAddress__c;
        insert ol1;
        ApexPages.Standardcontroller controller4 = new ApexPages.Standardcontroller(c2);
        Apexpages.currentPage().getParameters().put('submit','1');
        
        OrderController orderLinePOCController4 = new OrderController(controller4);
        
        orderLinePOCController4.mainForTestSuccess(ol1.Id);
        orderLinePOCController4.orderlines.add(ol1);
        orderLinePOCController4.submitAction();
        //orderLinePOCController3.save();
        
        //orderLinePOCController4.mainForTestError();
        //orderLinePOCController4.submitAction();
        Test.stopTest();
    }

      public static testMethod void testsubmitAddressEBS3(){
        Account a = insertAccWithEBSAddresses();
        
        Order__c c2 = CreateOrder(a);
        c2.AgreetoTermsConditions__c = true;
        c2.AgreetoRMAReturnConditions__c = true;
        insert c2;
        
        Test.startTest();

        ApexPages.Standardcontroller controller3 = new ApexPages.Standardcontroller(c2);
        Apexpages.currentPage().getParameters().put('submit','1');
        
        OrderController orderLinePOCController3 = new OrderController(controller3);
        orderLinePOCController3.submitAction();
        
        
        OrderLine__c ol1 = new OrderLine__c();
        ol1.Part_Number_2__c = 'SR3000';
        ol1.SerialNo__c = '123456';
        ol1.ReturnReasonDescription__c = 'test';
        ol1.Order__c = c2.Id;
        ol1.ShipToAddress__c = null;
        insert ol1;
        ApexPages.Standardcontroller controller4 = new ApexPages.Standardcontroller(c2);
        Apexpages.currentPage().getParameters().put('submit','1');
        
        OrderController orderLinePOCController4 = new OrderController(controller4);
        
        orderLinePOCController4.mainForTestSuccess(ol1.Id);
        orderLinePOCController4.orderlines.add(ol1);
        orderLinePOCController4.submitAction();
        //orderLinePOCController3.save();
        
        //orderLinePOCController4.mainForTestError();
        //orderLinePOCController4.submitAction();

        Test.stopTest();
    }

	public static testMethod void testsubmitActionError(){
        Account a = insertAccWithAddresses();
        Order__c c2 = CreateOrder(a);
        c2.AgreetoTermsConditions__c = true;
        c2.AgreetoRMAReturnConditions__c = true;
        insert c2;
        
        Test.startTest();

        ApexPages.Standardcontroller controller3 = new ApexPages.Standardcontroller(c2);
        Apexpages.currentPage().getParameters().put('submit','1');
        
        OrderController orderLinePOCController3 = new OrderController(controller3);
        orderLinePOCController3.submitAction();
        
        
        OrderLine__c ol1 = new OrderLine__c();
        ol1.Part_Number_2__c = 'SR3000';
        ol1.SerialNo__c = '123456';
        ol1.ReturnReasonDescription__c = 'test';
        ol1.Order__c = c2.Id;
        insert ol1;
        ApexPages.Standardcontroller controller4 = new ApexPages.Standardcontroller(c2);
        Apexpages.currentPage().getParameters().put('submit','1');
        
        OrderController orderLinePOCController4 = new OrderController(controller4);
        
        orderLinePOCController4.orderlines.add(ol1);
        orderLinePOCController4.mainForTestError();
        orderLinePOCController4.mainForTestError2();
        orderLinePOCController4.submitAction();
        Test.stopTest();
	}
    
	public static testMethod  void testsubmit(){  
        Account a = insertAccWithAddresses();
        Address__c sadd = [SELECT id FROM Address__c WHERE Account__c = :a.Id LIMIT 1];
    
        Order__c c2 = CreateOrder(a);
        //c.Status__c = System.Label.RMASubmitStatus;
        c2.AgreetoTermsConditions__c = true;
        c2.AgreetoRMAReturnConditions__c = true;
        insert c2;
        
        OrderLine__c ol1 = new OrderLine__c();
        ol1.Part_Number_2__c = 'SR3000';
        ol1.SerialNo__c = '123456';
        ol1.ReturnReasonDescription__c = 'test';
        ol1.Order__c = c2.Id;
        insert ol1;
        
		Test.startTest();

        ApexPages.Standardcontroller controller3 = new ApexPages.Standardcontroller(c2);
        OrderController orderLineController3 = new OrderController(controller3);
        orderLineController3.submit();
        orderLineController3.submitRMA(); 
    
        OrderLine__c ol2 = new OrderLine__c();
        ol2.Order__c = c2.Id;
        insert ol2;
        
        OrderLine__c ol3 = new OrderLine__c();
        ol3.Order__c = c2.Id;
        ol3.Part_Number_2__c = 'SR3000';        
        insert ol3;
        
        OrderLine__c ol4 = new OrderLine__c();
               
        ApexPages.Standardcontroller controller4 = new ApexPages.Standardcontroller(c2);
        OrderController orderLineController4 = new OrderController(controller4);
        orderLineController4.mainForTestSuccess(ol2.Id);
        orderLineController4.submit();
        orderLineController4.submitRMA();        

        Test.stopTest();
    }       
    
      public static testMethod void testremoveLines(){
        Order__c c = new Order__c();
        ApexPages.Standardcontroller controller1 = new ApexPages.Standardcontroller(c);
        OrderController orderLinePOCController1 = new OrderController(controller1);       
        
        orderLinePOCController1.linesSelected = null;
        orderLinePOCController1.removeLines();
        
        
        orderLinePOCController1.linesSelected = '1:2:3';
        orderLinePOCController1.removeLines();       
    }
    
	public static testMethod void testviewAttachment(){
    
         Order__c c = new Order__c();
        ApexPages.Standardcontroller controller1 = new ApexPages.Standardcontroller(c);
        OrderController orderLinePOCController1 = new OrderController(controller1);       
        
        orderLinePOCController1.viewAttachment();    
        orderLinePOCController1.editAttachment(); 
        orderLinePOCController1.submitRMA();
    }
    
	public static testMethod  void test1(){  
        Account a = insertAccWithAddresses();
        Address__c sadd = [SELECT id FROM Address__c WHERE Account__c = :a.Id LIMIT 1];
    
        Order__c c2 = new Order__c();
        c2.Account__c = a.id;
        //c.Status__c = System.Label.RMASubmitStatus;
        c2.Drop_Shipment__c=false;
        c2.AgreetoTermsConditions__c = true;
        c2.AgreetoRMAReturnConditions__c = true;
        c2.ShipToAddress__c = sadd.Id;
        
        insert c2;
        
        OrderLine__c ol1 = new OrderLine__c();
        ol1.Part_Number_2__c = 'SR3000';
        ol1.SerialNo__c = '123456';
        ol1.ReturnReasonDescription__c = 'test';
        ol1.Order__c = c2.Id;
        insert ol1;
        
        ApexPages.Standardcontroller controller3 = new ApexPages.Standardcontroller(c2);
        OrderController orderLinePOCController3 = new OrderController(controller3);
        orderLinePOCController3.submit();
        orderLinePOCController3.submitRMA(); 
        orderLinePOCController3.getlistattachments();
        orderLinePOCController3.getmyfile();
    
        OrderLine__c ol2 = new OrderLine__c();
        ol2.Order__c = c2.Id;
        insert ol2;
        
        OrderLine__c ol3 = new OrderLine__c();
        ol3.Order__c = c2.Id;
        ol3.Part_Number_2__c = 'SR3000';        
        insert ol3;
        
        OrderLine__c ol4 = new OrderLine__c();
        
       /* attachment att = new attachment();
        att.Name = 'test';
        att.ParentId = c2.id;
        
        Blob bodyBlob=Blob.valueOf('Unit Test Attachment Body');
        att.body=bodyBlob;
        insert att;  */

         ApexPages.currentPage().getParameters().put('id','');
        
        ApexPages.Standardcontroller controller4 = new ApexPages.Standardcontroller(c2);
        OrderController orderLinePOCController4 = new OrderController(controller4);
        orderLinePOCController4.mainForTestSuccess(ol2.Id);
        orderLinePOCController4.submit();
        orderLinePOCController4.submitRMA();
	}   
    
	public static testMethod void test2(){ 
        
         profile p = [select id, name from profile where name='IT: System Administrator'];
          user u = [select id,name,UserType from user where ProfileID =: P.id and IsActive = true limit 1]; 
            System.Runas(u)
            {
        Account a = insertAccWithAddresses();
        Address__c sadd = [SELECT id FROM Address__c WHERE Account__c = :a.Id LIMIT 1];
    
        Order__c c2 = CreateOrder(a);
 //     c2.Status__c = System.Label.RMASubmitStatus;
        c2.AgreetoTermsConditions__c = true;
        c2.AgreetoRMAReturnConditions__c = true;
        insert c2;
        
        OrderLine__c ol1 = new OrderLine__c();
        ol1.Part_Number_2__c = 'SR3000';
        ol1.SerialNo__c = '123456';
        ol1.ReturnReasonDescription__c = 'test';
        ol1.Order__c = c2.Id;
        insert ol1;
        
        
        Attachment attach=new Attachment();     
        attach.Name='Unit Test Attachment';
        Blob bodyBlob=Blob.valueOf('Unit Test Attachment Body');
        attach.body=bodyBlob;
        attach.parentId=c2.id;
        insert attach;

		Test.startTest();
        
        Apexpages.currentpage().getparameters().put('attachmentid',attach.id);
        
        ApexPages.Standardcontroller controller3 = new ApexPages.Standardcontroller(c2);
        OrderController orderLinePOCController3 = new OrderController(controller3);
        orderLinePOCController3.submit();
        orderLinePOCController3.submitRMA(); 
        orderLinePOCController3.getlistattachments();
        orderLinePOCController3.getmyfile();
         orderLinePOCController3.delAttachment();
    
        OrderLine__c ol2 = new OrderLine__c();
        ol2.Order__c = c2.Id;
        insert ol2;
        
        OrderLine__c ol3 = new OrderLine__c();
        ol3.Order__c = c2.Id;
        ol3.Part_Number_2__c = 'SR3000';        
        insert ol3;
        
        OrderLine__c ol4 = new OrderLine__c();

         ApexPages.currentPage().getParameters().put('id','');
        
        ApexPages.Standardcontroller controller4 = new ApexPages.Standardcontroller(c2);
        OrderController orderLinePOCController4 = new OrderController(controller4);
        orderLinePOCController4.mainForTestSuccess(ol2.Id);
        orderLinePOCController4.submit();
        orderLinePOCController4.submitRMA();
		Test.stopTest();
		}   
	}    

	
	
	// TESTS FOR
	public static testMethod void testOrderLinePOCControllerStdUser2() { 
        Account a = insertAccWithAddresses();
        
        Order__c c = new Order__c();
        c.Account__c = a.id;
        //c.Status__c = System.Label.RMASubmitStatus;
        c.Status__c = 'Cancelled';
        insert c;


        Profile p = [SELECT Id FROM Profile WHERE Name='AMS CSR User']; 
        User u = new User(Alias = 'stdrma', Email='standardusertestrma@testorg.com', 
        EmailEncodingKey='UTF-8', LastName='Test1rma', LanguageLocaleKey='en_US', 
        LocaleSidKey='en_US', ProfileId = p.Id, 
        TimeZoneSidKey='America/Los_Angeles', UserName='standardusertestrma@testorg.com');
    
    
        System.runAs(u) {
        ApexPages.Standardcontroller controller2 = new ApexPages.Standardcontroller(c);
        OrderLinePOCController orderLinePOCController2 = new OrderLinePOCController(controller2);
            
        }
        
    }
    
	public static testMethod void testOrderLinePOCController2() { 
        
        Account a = insertAccWithAddresses();
    
        User u = new User();
        
        Order__c c = new Order__c();
        ApexPages.Standardcontroller controller2 = new ApexPages.Standardcontroller(c);
        OrderLinePOCController orderLinePOCController2 = new OrderLinePOCController(controller2);
        //Account acct = []
        c.Account__c = a.id;
        //c.Status__c = System.Label.RMASubmitStatus;
        c.Status__c = 'Cancelled';
        insert c;
        ApexPages.Standardcontroller controller3 = new ApexPages.Standardcontroller(c);
        OrderLinePOCController orderLinePOCController3 = new OrderLinePOCController(controller3);
        
        orderLinePOCController3.defaultAddresses();
        orderLinePOCController3.getLines();
        orderLinePOCController3.deleteRMA();
        orderLinePOCController3.toggleSort();
        orderLinePOCController3.uploadLines();
//      orderLinePOCController3.orderTypes();
//      orderLinePOCController3.serviceTypes();
        
        List<selectoption> orderTypesSel = orderLinePOCController3.orderTypes; 
        List<selectoption> serviceTypesSel = orderLinePOCController3.serviceTypes;
  
        c.OrderTypeId__c = 'Test';
        c.ServiceTypeId__c = 'Test';
        update c;
        
        ApexPages.Standardcontroller controller4 = new ApexPages.Standardcontroller(c);
        OrderLinePOCController orderLinePOCController4 = new OrderLinePOCController(controller4);
    }
    
	public static testMethod void  testsave2(){
        Account a = insertAccWithAddresses();
        
        Order__c c = new Order__c();
        c.Account__c = a.id;
        //c.Status__c = System.Label.RMASubmitStatus;
        c.Status__c = 'Cancelled';
        c.AgreetoTermsConditions__c = true;
        c.AgreetoRMAReturnConditions__c = false;        
        insert c;
        
		Test.startTest();

        ApexPages.Standardcontroller controller2 = new ApexPages.Standardcontroller(c);
        OrderLinePOCController orderLinePOCController2 = new OrderLinePOCController(controller2);
        
        orderLinePOCController2.save();
        
        Order__c c2 = new Order__c();
        c2.Account__c = a.id;
        //c.Status__c = System.Label.RMASubmitStatus;
        c2.AgreetoTermsConditions__c = true;
        c2.AgreetoRMAReturnConditions__c = true;
        c2.PreferredCarrier__c = null;        
        insert c2;
        
        OrderLine__c ol1 = new OrderLine__c();
        ol1.Part_Number_2__c = 'SR3000';
        ol1.SerialNo__c = '123456';
        ol1.ReturnReasonDescription__c = 'test';
        ol1.Order__c = c2.Id;
        insert ol1;
        
        ApexPages.Standardcontroller controller3 = new ApexPages.Standardcontroller(c2);
        OrderLinePOCController orderLinePOCController3 = new OrderLinePOCController(controller3);
        orderLinePOCController3.orderlinesdelete = null;
        orderLinePOCController3.save();
        orderLinePOCController3.uploadLines();
        orderLinePOCController3.escalateToCSR();
        orderLinePOCController3.redirectPage();
    
        OrderLine__c ol2 = new OrderLine__c();
        ol2.Order__c = c2.Id;
        insert ol2;
        
        OrderLine__c ol3 = new OrderLine__c();
        ol3.Order__c = c2.Id;
        ol3.Part_Number_2__c = 'SR3000';        
        insert ol3;
        
        OrderLine__c ol4 = new OrderLine__c();
        
        ApexPages.Standardcontroller controller4 = new ApexPages.Standardcontroller(c2);
        OrderLinePOCController orderLinePOCController4 = new OrderLinePOCController(controller4);
        orderlinePOCController4.selectedOrderTypeId = '1885';
        orderlinePOCController4.selectedServiceTypeId = null;
        
        orderLinePOCController4.orderlines.add(ol4);        
        orderLinePOCController4.save();
        orderLinePOCController4.escalateToCSR();
        

        Order__c c4 = new Order__c();
        c4.Account__c = a.id;
        //c.Status__c = System.Label.RMASubmitStatus;
        c4.AgreetoTermsConditions__c = false;
        c4.AgreetoRMAReturnConditions__c = false;
        
        insert c4;
        
        ApexPages.Standardcontroller controller5 = new ApexPages.Standardcontroller(c4);
        OrderLinePOCController orderLinePOCController5 = new OrderLinePOCController(controller5);
        
        orderLinePOCController5.save();
        
        Order__c c5 = new Order__c();
        c5.Account__c = a.id;
        //c.Status__c = System.Label.RMASubmitStatus;
        c5.AgreetoTermsConditions__c = true;
        c5.AgreetoRMAReturnConditions__c = true;
        //c5.PreferredCarrier__c = 'AIT Global';
        c5.CarrierAccount__c = '';
        insert c5;
        
        ApexPages.Standardcontroller controller6 = new ApexPages.Standardcontroller(c5);
        OrderLinePOCController orderLinePOCController6 = new OrderLinePOCController(controller6);
        orderLinePOCController6.o.PreferredCarrier__c = 'Test';
        
        orderLinePOCController6.save();
        
        Order__c c6 = new Order__c();
        c6.Account__c = a.id;
        //c.Status__c = System.Label.RMASubmitStatus;
        c6.AgreetoTermsConditions__c = true;
        c6.AgreetoRMAReturnConditions__c = true;
        c6.PreferredCarrier__c = null;
        insert c6;
        
        ApexPages.Standardcontroller controller7 = new ApexPages.Standardcontroller(c6);
        OrderLinePOCController orderLinePOCController7 = new OrderLinePOCController(controller7);
        orderlinePOCController7.selectedOrderTypeId = '10200';
        orderlinePOCController7.selectedServiceTypeId = null;
        
        orderLinePOCController7.save();
        
        Order__c c7 = new Order__c();
        c7.Account__c = a.id;
        //c.Status__c = System.Label.RMASubmitStatus;
        c7.AgreetoTermsConditions__c = true;
        c7.AgreetoRMAReturnConditions__c = true;
        c7.PreferredCarrier__c = null;
        insert c7;
        
        ApexPages.Standardcontroller controller8 = new ApexPages.Standardcontroller(c7);
        OrderLinePOCController orderLinePOCController8 = new OrderLinePOCController(controller8);
        orderlinePOCController8.selectedOrderTypeId = null;
        orderlinePOCController8.selectedServiceTypeId = '22';
        orderLinePOCController8.save();

		Test.stopTest();
    }	
        
	public static testMethod void testinvokeExternalWs2(){
        Account a = insertAccWithAddresses();
        
        Order__c c2 = new Order__c();
        c2.Account__c = a.id;
        //c.Status__c = System.Label.RMASubmitStatus;
        c2.AgreetoTermsConditions__c = true;
        c2.AgreetoRMAReturnConditions__c = true;        
        insert c2;
        
        OrderLine__c ol1 = new OrderLine__c();
        ol1.Part_Number_2__c = 'SR3000';
        ol1.SerialNo__c = '123456';
        ol1.ReturnReasonDescription__c = 'test';
        ol1.Order__c = c2.Id;
        insert ol1;
        
        ApexPages.Standardcontroller controller3 = new ApexPages.Standardcontroller(c2);
        OrderLinePOCController orderLinePOCController3 = new OrderLinePOCController(controller3);
        
        orderLinePOCController3.save();
        orderLinePOCController3.mainForTestSuccess(ol1.Id);
        orderLinePOCController3.submitRMA();
        orderLinePOCController3.invokeExternalWs();         
    }
    
	public static testMethod void testsubmitAction2(){
        Account a = insertAccWithAddresses();
        
        Order__c c2 = CreateOrder(a);
        //c.Status__c = System.Label.RMASubmitStatus;
        c2.AgreetoTermsConditions__c = true;
        c2.AgreetoRMAReturnConditions__c = true;
        insert c2;
        
        ApexPages.Standardcontroller controller3 = new ApexPages.Standardcontroller(c2);
        Apexpages.currentPage().getParameters().put('submit','1');
        
        OrderLinePOCController orderLinePOCController3 = new OrderLinePOCController(controller3);
        orderlinePOCController3.selectedOrderTypeId = '1885';
        orderlinePOCController3.selectedServiceTypeId = null;
        orderLinePOCController3.submitAction();
        orderLinePOCController3.submitRMA();        
        
        OrderLine__c ol1 = new OrderLine__c();
        ol1.Part_Number_2__c = 'SR3000';
        ol1.SerialNo__c = '123456';
        ol1.ReturnReasonDescription__c = 'test';
        ol1.Order__c = c2.Id;
        ol1.ShipToAddress__c = c2.ShipToAddress__c;
        insert ol1;
        ApexPages.Standardcontroller controller4 = new ApexPages.Standardcontroller(c2);
        Apexpages.currentPage().getParameters().put('submit','1');
        
        OrderLinePOCController orderLinePOCController4 = new OrderLinePOCController(controller4);
        
        orderLinePOCController4.mainForTestSuccess(ol1.Id);
        orderLinePOCController4.orderlines.add(ol1);
        orderLinePOCController4.submitAction();
        //orderLinePOCController3.save();
        
        //orderLinePOCController4.mainForTestError();
        //orderLinePOCController4.submitAction();
    }

	public static testMethod void testsubmitCompusec2(){
        Account a = insertAccWithAddresses();
        
        Order__c c2 = CreateOrder(a);
        //c.Status__c = System.Label.RMASubmitStatus;
        c2.AgreetoTermsConditions__c = true;
        c2.AgreetoRMAReturnConditions__c = true;
        c2.ComSecDoDAACRequirement__c = 'Yes';
        insert c2;
        
        ApexPages.Standardcontroller controller3 = new ApexPages.Standardcontroller(c2);
        Apexpages.currentPage().getParameters().put('submit','1');
        
        OrderLinePOCController orderLinePOCController3 = new OrderLinePOCController(controller3);
        orderLinePOCController3.submitAction();
        
        OrderLine__c ol1 = new OrderLine__c();
        ol1.Part_Number_2__c = 'SR3000';
        ol1.SerialNo__c = '123456';
        ol1.ReturnReasonDescription__c = 'test';
        ol1.Order__c = c2.Id;
        ol1.ShipToAddress__c = c2.ShipToAddress__c;
        insert ol1;
        ApexPages.Standardcontroller controller4 = new ApexPages.Standardcontroller(c2);
        Apexpages.currentPage().getParameters().put('submit','1');
        
        OrderLinePOCController orderLinePOCController4 = new OrderLinePOCController(controller4);
        
        orderLinePOCController4.mainForTestSuccess(ol1.Id);
        orderLinePOCController4.orderlines.add(ol1);
        orderLinePOCController4.submitAction();
        //orderLinePOCController3.save();
        
        //orderLinePOCController4.mainForTestError();
        //orderLinePOCController4.submitAction();
    }
/*    
	public static testMethod void  testsubmitAddressEBS(){
        Account a = insertAccWithEBSAddresses();
        
        Order__c c2 = new Order__c();
        c2.Account__c = a.id;
        //c.Status__c = System.Label.RMASubmitStatus;
        c2.AgreetoTermsConditions__c = true;
        c2.AgreetoRMAReturnConditions__c = true;
        c2.ShipToAddress__c = sadd.Id;
        c2.BillToAddress__c = badd.Id;
        insert c2;
        
        ApexPages.Standardcontroller controller3 = new ApexPages.Standardcontroller(c2);
        Apexpages.currentPage().getParameters().put('submit','1');
        
        OrderLinePOCController orderLinePOCController3 = new OrderLinePOCController(controller3);
        orderLinePOCController3.submitAction();
        
        
        OrderLine__c ol1 = new OrderLine__c();
        ol1.Part_Number_2__c = 'SR3000';
        ol1.SerialNo__c = '123456';
        ol1.ReturnReasonDescription__c = 'test';
        ol1.Order__c = c2.Id;
        ol1.ShipToAddress__c = sadd.Id;
        insert ol1;
        ApexPages.Standardcontroller controller4 = new ApexPages.Standardcontroller(c2);
        Apexpages.currentPage().getParameters().put('submit','1');
        
        OrderLinePOCController orderLinePOCController4 = new OrderLinePOCController(controller4);
        
        orderLinePOCController4.mainForTestSuccess(ol1.Id);
        orderLinePOCController4.orderlines.add(ol1);
        orderLinePOCController4.submitAction();
        //orderLinePOCController3.save();
        
        //orderLinePOCController4.mainForTestError();
        //orderLinePOCController4.submitAction();
    }
*/    
	public static testMethod void  testsubmitAddressEBS4(){
        Account a = insertAccWithEBSAddresses();        
        Address__c saddl = new Address__c(name='test street');
        saddl.Account__c = a.Id;
        saddl.Type__c = 'Ship to';
        saddl.Default__c = false;
        saddl.EBSAddressID__c = '0';
        insert saddl;
               
        Order__c c2 = CreateOrder(a);
        //c.Status__c = System.Label.RMASubmitStatus;
        c2.AgreetoTermsConditions__c = true;
        c2.AgreetoRMAReturnConditions__c = true;
        insert c2;
        
        ApexPages.Standardcontroller controller3 = new ApexPages.Standardcontroller(c2);
        Apexpages.currentPage().getParameters().put('submit','1');
        
        OrderLinePOCController orderLinePOCController3 = new OrderLinePOCController(controller3);
        orderLinePOCController3.submitAction();
        
        
        OrderLine__c ol1 = new OrderLine__c();
        ol1.Part_Number_2__c = 'SR3000';
        ol1.SerialNo__c = '123456';
        ol1.ReturnReasonDescription__c = 'test';
        ol1.Order__c = c2.Id;
        ol1.ShipToAddress__c = saddl.Id;
        insert ol1;
        ApexPages.Standardcontroller controller4 = new ApexPages.Standardcontroller(c2);
        Apexpages.currentPage().getParameters().put('submit','1');
        
        OrderLinePOCController orderLinePOCController4 = new OrderLinePOCController(controller4);
        
        orderLinePOCController4.mainForTestSuccess(ol1.Id);
        orderLinePOCController4.orderlines.add(ol1);
        orderLinePOCController4.submitAction();
        //orderLinePOCController3.save();
        
        //orderLinePOCController4.mainForTestError();
        //orderLinePOCController4.submitAction();
    }

	public static testMethod void  testsubmitAddressEBS5(){
        Account a = insertAccWithEBSAddresses();
        
        Order__c c2 = CreateOrder(a);
        //c.Status__c = System.Label.RMASubmitStatus;
        c2.AgreetoTermsConditions__c = true;
        c2.AgreetoRMAReturnConditions__c = true;
        insert c2;
        
        ApexPages.Standardcontroller controller3 = new ApexPages.Standardcontroller(c2);
        Apexpages.currentPage().getParameters().put('submit','1');
        
        OrderLinePOCController orderLinePOCController3 = new OrderLinePOCController(controller3);
        orderLinePOCController3.submitAction();
        
        
        OrderLine__c ol1 = new OrderLine__c();
        ol1.Part_Number_2__c = 'SR3000';
        ol1.SerialNo__c = '123456';
        ol1.ReturnReasonDescription__c = 'test';
        ol1.Order__c = c2.Id;
        ol1.ShipToAddress__c = null;
        insert ol1;
        ApexPages.Standardcontroller controller4 = new ApexPages.Standardcontroller(c2);
        Apexpages.currentPage().getParameters().put('submit','1');
        
        OrderLinePOCController orderLinePOCController4 = new OrderLinePOCController(controller4);
        
        orderLinePOCController4.mainForTestSuccess(ol1.Id);
        orderLinePOCController4.orderlines.add(ol1);
        orderLinePOCController4.submitAction();
        //orderLinePOCController3.save();
        
        //orderLinePOCController4.mainForTestError();
        //orderLinePOCController4.submitAction();
    }
    
	public static testMethod void testsubmitActionError3(){
        Account a = insertAccWithAddresses();
        Order__c c2 = createOrder(a);
        c2.AgreetoTermsConditions__c = true;
        c2.AgreetoRMAReturnConditions__c = true;
        insert c2;
        
        Test.startTest();

        ApexPages.Standardcontroller controller3 = new ApexPages.Standardcontroller(c2);
        Apexpages.currentPage().getParameters().put('submit','1');
        
        OrderLinePOCController orderLinePOCController3 = new OrderLinePOCController(controller3);
        orderLinePOCController3.submitAction();
        
        
        OrderLine__c ol1 = new OrderLine__c();
        ol1.Part_Number_2__c = 'SR3000';
        ol1.SerialNo__c = '123456';
        ol1.ReturnReasonDescription__c = 'test';
        ol1.Order__c = c2.Id;
        insert ol1;
        ApexPages.Standardcontroller controller4 = new ApexPages.Standardcontroller(c2);
        Apexpages.currentPage().getParameters().put('submit','1');
        
        OrderLinePOCController orderLinePOCController4 = new OrderLinePOCController(controller4);
        
        orderLinePOCController4.orderlines.add(ol1);
        orderLinePOCController4.mainForTestError();
        orderLinePOCController4.mainForTestError2();
        orderLinePOCController4.submitAction();
        Test.stopTest();
    }
    
	public static testMethod void testsubmit2()
	{
        Account a = insertAccWithAddresses();
        Order__c c2 = createOrder(a);
        //c.Status__c = System.Label.RMASubmitStatus;
        c2.AgreetoTermsConditions__c = true;
        c2.AgreetoRMAReturnConditions__c = true;        
        insert c2;
        
        OrderLine__c ol1 = new OrderLine__c();
        ol1.Part_Number_2__c = 'SR3000';
        ol1.SerialNo__c = '123456';
        ol1.ReturnReasonDescription__c = 'test';
        ol1.Order__c = c2.Id;
        insert ol1;
        
		Test.startTest();
		
        ApexPages.Standardcontroller controller3 = new ApexPages.Standardcontroller(c2);
        OrderLinePOCController orderLinePOCController3 = new OrderLinePOCController(controller3);
        orderLinePOCController3.submit();
    
        OrderLine__c ol2 = new OrderLine__c();
        ol2.Order__c = c2.Id;
        insert ol2;
        
        OrderLine__c ol3 = new OrderLine__c();
        ol3.Order__c = c2.Id;
        ol3.Part_Number_2__c = 'SR3000';        
        insert ol3;
        
        OrderLine__c ol4 = new OrderLine__c();
        
        ApexPages.Standardcontroller controller4 = new ApexPages.Standardcontroller(c2);
        OrderLinePOCController orderLinePOCController4 = new OrderLinePOCController(controller4);
        orderLinePOCController4.mainForTestSuccess(ol2.Id);
        orderLinePOCController4.submit();
        
        Test.stopTest();
    }       
}