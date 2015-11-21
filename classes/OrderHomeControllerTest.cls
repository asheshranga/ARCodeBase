//Test Method for the Apex Class OrderHomeController 

@isTest(seealldata=false)
public class OrderHomeControllerTest
{
    public static Account A1;
    public static Contact C1,C2;
    public static User u1,u2;
    public OrderHomeControllerTest()
    {
    }
    public static void createdata()
    {
        ID ProfileID1 = [ Select id from Profile where name = 'IT: System Administrator' limit 1].id;
        A1 = new Account(Name = 'Test Account');
        insert A1;
        
        u1 = new User( email='test-user1@fakeemail.com', profileid = profileid1, 
        UserName='test-user1@fakeemail.com', alias='tuser1', CommunityNickName='tuser1', 
        TimeZoneSidKey='America/New_York', LocaleSidKey='en_US', EmailEncodingKey='ISO-8859-1', 
        LanguageLocaleKey='en_US', FirstName = 'Test1', LastName = 'User1' );
        
        ID ProfileID2 = [ Select id from Profile where name = 'Order Customer Portal Users'].id;
               
        C2 = new Contact( AccountID = A1.id, FirstName = 'Test2', LastName = 'User',email = 'test-user@fakeemail.com');
        
        list<contact> collCont=new list<contact>();
        collCont.add(c2);
        insert collCont;
        
        u2 = new User( email='test-user2@fakeemail.com', contactid = c2.id, profileid = profileid2, 
        UserName='test-user2@fakeemail.com', alias='tuser2', CommunityNickName='tuser2', 
        TimeZoneSidKey='America/New_York', LocaleSidKey='en_US', EmailEncodingKey='ISO-8859-1', 
        LanguageLocaleKey='en_US', FirstName = 'Test2', LastName = 'User2' );
                
        list<User> collUsr=new list<User>();
        collUsr.add(u1);
        collUsr.add(u2);
        insert collUsr;
        u1=u1;
        u2=u2;
        
        OrderPriceList__c or1 = new OrderPriceList__c();
        or1 .Name='testing';
        insert or1;   
                       
        Account acc=new Account();
        acc.Name='test';
        acc.CurrencyIsoCode='USD';
        acc.ShippingStreet='test street'; 
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
                  
        Product2 pdt1 = new Product2();
        pdt1.CurrencyIsoCode = 'USD';
        pdt1.Name='Spares';
        pdt1.Product_Category__c='Spares';
        insert pdt1;
        
        
        OrderPrice__c OrderP = new OrderPrice__c();
        OrderP.Product__c=pdt1.id;
        OrderP.Price__c = 500; 
        OrderP.PriceList__c=Or1.id; 
        
        Address__c add= new Address__c(name='test street');
        add.Account__c = acc.Id;
        add.Type__c = 'Ship to';
        add.Default__c = true;
        insert add;        
        
        Order__c ord=new Order__c();              
        ord.Account__c=acc.id;
        ord.Requestor__c= con.id;
        ord.ShipToAddress__c=add.id;
        ord.AgreetoTermsConditions__c = true;
        ord.Status__c = 'Booked';
        ord.OracleOrder__c = 'testing';
        ord.CustomerPO__c = 'Account';
        ord.Requested_Delivery_Datepl__c = 'ASAP';
        insert ord;
        
        orderline__c ol = new orderline__c ();
        ol.SerialNo__c='123';
        ol.ShipToAddress__c=add.id;
        ol.Quantity__c=2;
        ol.Order__c = ord.id;
        ol.status__c='All'; 
        ol.Random_Number__c = 123;        
        insert ol; 
    }
    public static testMethod void SearchSystemAdminProfile() 
    {         
        Test.startTest();
        createdata();
        System.runAs(u1)
        {
            String listSel='MyOpenOrders';
                        
            OrderHomeController OH = new OrderHomeController();
            PageReference pageRef = Page.Tooway_OrderHome_CustomerPortal;
            Test.setCurrentPage(pageRef);
       
            String teststring='ASC';
            
            OH.clear();
            OH.getdateOption();
            OH.getStatusOption();
            OH.GoOrderDetail();
            OH.createnew();
            OH.getOrderList();
            OH.getSortDirection();
            OH.setSortDirection(teststring);

        }
        Test.stopTest();
    }     
      
    public static testMethod void SortingdataCustomerPortalProfile() 
    {         
        Test.startTest();
        Createdata();
        System.runAs(u1)
        {
            String listSel='MyOpenOrders';
                        
            OrderHomeController OH = new OrderHomeController();
            PageReference pageRef = Page.Tooway_OrderHome_CustomerPortal;
            Test.setCurrentPage(pageRef);
            
            String teststring='ASC';
            OH.clear();
            OH.getdateOption();
            OH.getStatusOption();
            OH.GoOrderDetail();
            OH.createnew();
            OH.getOrderList();
            OH.getSortDirection();
            OH.setSortDirection(teststring);
 
        }
        Test.stopTest();
    }     
      
    public static testMethod void SortingdataSystemAdminProfile() 
    {         
        Test.startTest();
        Createdata();
        System.runAs(u1)
        {
            String listSel='MyOpenOrders';
                        
            OrderHomeController OH = new OrderHomeController();
            PageReference pageRef = Page.Tooway_OrderHome_CustomerPortal;
            Test.setCurrentPage(pageRef);
            
            String teststring='ASC';
            
            OH.clear();           
            OH.getdateOption();
            OH.getStatusOption();
            OH.GoOrderDetail();
            OH.createnew();
            OH.getOrderList();
            OH.getSortDirection();
            OH.setSortDirection(teststring);
        }
        Test.stopTest();
    }     
    public static testMethod void SearchCustomerPortalProfile() 
    {        
        Test.startTest(); 
        createdata();
        System.runAs(u1)
        {
            String listSel='MyOpenOrders';
                        
            OrderHomeController OH = new OrderHomeController();
            PageReference pageRef = Page.Tooway_OrderHome_CustomerPortal;
            Test.setCurrentPage(pageRef);
            
            String teststring='ASC';
            
            OH.clear();
            OH.getdateOption();
            OH.getStatusOption();
            OH.GoOrderDetail();
            OH.createnew();
            OH.getOrderList();
            OH.getSortDirection();
            OH.setSortDirection(teststring);           
 
        }
        Test.stopTest();
    }
  
        
    public static testMethod void test1() 
    {
            String createddate='All';
            String Partno='Spares'; 
            String Orderno='LKJH' ;
            string orderstatus='Entered';
            Profile p = [SELECT Id,Name FROM Profile where Name = 'IT: System Administrator'];
            user u = [select id,name from user where ProfileID =: P.id and IsActive = true limit 1]; 
            System.Runas(u)
        {
            String listSel='MyOpenOrders';
            
            OrderHomeController OH = new OrderHomeController();
            PageReference pageRef = Page.Tooway_OrderHome_CustomerPortal;
            Test.setCurrentPage(pageRef);
            
            OH.orderstatus='Booked';
            OH.accountname='Acc';            
            OH.Partno='abc';
       
            String teststring='ASC';
            
            OH.sortingdata();
        }
    }
            
    public static testMethod void test2() 
    {
            String createddate='All';
            String Partno=''; 
            String Orderno='LKJH' ;
            string orderstatus='Entered';
            
            ID ProfileID = [ Select id from Profile where name = 'Order Customer Portal Users'].id;
            Account A2 = new Account(Name = 'Test Account');
            insert A2;
        
            List<Contact> ContactList = new List<Contact>();
            Contact C3 = new Contact( AccountID = A2.id, FirstName = 'Test', LastName = 'User', 
            email = 'test-user@fakeemail.com');
            insert C3;
     
            User u3 = new User( email='test-user@fakeemail.com', contactid = c3.id, profileid = profileid, 
            UserName='test-user@fakeemail.com', alias='tuser1', CommunityNickName='tuser1', 
            TimeZoneSidKey='America/New_York', LocaleSidKey='en_US', EmailEncodingKey='ISO-8859-1', 
            LanguageLocaleKey='en_US', FirstName = 'Test', LastName = 'User' );
            insert u3;
       
            System.runAs(u3)
        {
            String listSel='MyOpenOrders';
            
            OrderHomeController OH = new OrderHomeController();
            PageReference pageRef = Page.Tooway_OrderHome_CustomerPortal;
            Test.setCurrentPage(pageRef);
            
            OH.orderstatus='Booked';
            OH.accountname='Acc';            
            OH.Partno='abc';
       
            String teststring='ASC';
            OH.sortingdata();
        }
    }
            
    public static testMethod void test3() 
    {
            String createddate='All';
            String Partno=''; 
            String Orderno='LKJH' ;
            string orderstatus='Entered';
            Profile p = [SELECT Id,Name FROM Profile where Name = 'IT: System Administrator'];
            user u = [select id,name from user where ProfileID =: P.id and IsActive = true limit 1]; 
            System.Runas(u)
        {
            String listSel='MyOpenOrders';
            
            OrderHomeController OH = new OrderHomeController();
            PageReference pageRef = Page.Tooway_OrderHome_CustomerPortal;
            Test.setCurrentPage(pageRef);
            
            OH.orderstatus='Booked';
            OH.accountname='Acc';            
            OH.Partno='abc';
       
            String teststring='ASC';
            
            OH.Search();
        }
    }
            
    public static testMethod void test4() 
    {
            String createddate='All';
            String Partno=''; 
            String Orderno='LKJH' ;
            string orderstatus='Entered';
            
            ID ProfileID = [ Select id from Profile where name = 'Order Customer Portal Users'].id;
            Account A2 = new Account(Name = 'Test Account');
            insert A2;
        
            List<Contact> ContactList = new List<Contact>();
            Contact C3 = new Contact( AccountID = A2.id, FirstName = 'Test', LastName = 'User', 
            email = 'test-user@fakeemail.com');
            insert C3;
     
            User u3 = new User( email='test-user@fakeemail.com', contactid = c3.id, profileid = profileid, 
            UserName='test-user@fakeemail.com', alias='tuser1', CommunityNickName='tuser1', 
            TimeZoneSidKey='America/New_York', LocaleSidKey='en_US', EmailEncodingKey='ISO-8859-1', 
            LanguageLocaleKey='en_US', FirstName = 'Test', LastName = 'User' );
            insert u3;
       
            System.runAs(u3)
        {
            String listSel='MyOpenOrders';
            
            OrderHomeController OH = new OrderHomeController();
            PageReference pageRef = Page.Tooway_OrderHome_CustomerPortal;
            Test.setCurrentPage(pageRef);
            
            OH.orderstatus='Booked';
            OH.accountname='Acc';            
            OH.Partno='abc';
       
            String teststring='ASC';
            
            OH.Search();
        }
    }
}