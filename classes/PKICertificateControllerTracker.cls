/*********************************************************************************
Name         : PKICertificateController
Created By   : Shiva Shankar Nalluri
Modified BY  : Poornima Ramachandrachar
Company Name : NTT Data
Project      : ViaSat Atlas, Bangalore
Created Date : 
Modified Date: 
Usages       : Test for controller: PKICertificateController
*********************************************************************************/
@isTest(SeeAllData = true)
private class PKICertificateControllerTracker {  

    static testMethod void PKICertificateController1() 
    {
        //Create an account record and insert it
        list<Account> accounts = ViasatTestUtility.createAccounts(1,'License and Certificate Request');
        accounts[0].Status__c='Prospect';
        accounts[0].Type='Partner';
        accounts[0].Industry='Banking';
        insert accounts;
        Account objacc = accounts[0];
                
        //Create a contact record and insert it
        list<Contact> contacts = ViasatTestUtility.createContacts(accounts, 1);
        insert contacts;
        Contact objCon= contacts[0];

        //Create an Entitlement record and insert it
        Entitlement ent = new Entitlement();
        ent.AccountId = objacc.Id;
        ent.Name = 'Entitlement';
        ent.startDate = system.today();
        ent.endDate = system.today()+10;
        ent.Type = 'Certificate and License Requests';
        ent.Product__c = 'Linkway';
        insert ent;
        
        //Create a license request record and insert it
        PKI_License_and_Certificate_Request__c lcrobj2=new PKI_License_and_Certificate_Request__c();
        lcrobj2.Account__c=objacc.id;
        lcrobj2.Requestor__c=objCon.id;
        lcrobj2.Custom_Product__c='LinkWay FS';
        lcrobj2.Downloadable__c=true;
        lcrobj2.Deliver_on_Disk__c=false;
        lcrobj2.Electronic_Delivery__c=false;
        lcrObj2.Shipping_Country__c = null;
        lcrObj2.Email_Address1__c = null;
        lcrObj2.Email_Address2__c = null;
        lcrobj2.Software_Version__c='23.1';
        lcrobj2.Status__c='New';
        lcrobj2.Shipping_City__c = null;
        lcrobj2.Shipping_Address_Line_1__c = null;
        insert lcrobj2;
        
        //Create a MAC address record and insert it
        MAC_Address__c macObj1= new MAC_Address__c();
        macObj1.License_and_Certificate_Request__c=lcrobj2.Id;
        macObj1.Certificate_Type__c='New';
        macObj1.License_Type__c='New';
        macObj1.Comments__c='Test';
        macObj1.MAC_Address__c='11:22:33:44:55:66';
        macObj1.Server_Serial__c='123456';
        insert macObj1;
        
        //Create another MAC address record and insert it
        MAC_Address__c macObj2= new MAC_Address__c();
        macObj2.License_and_Certificate_Request__c=lcrobj2.Id;
        macObj2.Certificate_Type__c='New';
        macObj2.License_Type__c='New';
        macObj2.Comments__c='Test';
        macObj2.MAC_Address__c='11:22:33:44:55:66';
        macObj2.Server_Serial__c='123456';
        insert macObj2;

        //Create an instance of standard controller
        Apexpages.Standardcontroller stdcon = new Apexpages.Standardcontroller(lcrObj2);
        //Create an instance of custom controller
        PKICertificateController objPKICertificateController = new PKICertificateController(stdcon);
        
        test.startTest();
        
        //Call the methods in the controller
        objPKICertificateController.CheckPermitToSave();
        objPKICertificateController.submit();
        
        objPKICertificateController.macAddlines[0].Server_Serial__c='';
        objPKICertificateController.macAddlines[0].License_Type__c='';
        objPKICertificateController.macAddlines[0].Certificate_Type__c='';
        objPKICertificateController.macAddlines[0].MAC_Address__c='';       
        objPKICertificateController.submit();
        
        objPKICertificateController.uploadLines();
        
        Cookie DOLIKCZXHW = new Cookie('DOLIKCZXHW','ILDMRBNFVM',null,0,false);
        ApexPages.currentPage().setCookies(new Cookie[]{DOLIKCZXHW});
        ApexPages.currentPage().getParameters().put('submit','0'); 
        objPKICertificateController.submitAction();       
        objPKICertificateController.save();
        
        lcrobj2.Status__c ='Pending Submission';
        objPKICertificateController.isValidEntitlement(lcrobj2,lcrobj2);
        objPKICertificateController.save();
        objPKICertificateController.isValidEntitlement(lcrobj2,null);
        objPKICertificateController.save();
        objPKICertificateController.getMyFile();
        objPKICertificateController.getListAttachments();
        objPKICertificateController.PopulateRequestorDetail();
        objPKICertificateController.getLines();
        objPKICertificateController.getLines(true);
        objPKICertificateController.getLines(false);
        macObj2.Marked_For_Deletion__c = true;
        objPKICertificateController.returToList();
        objPKICertificateController.cancel();
        
        
        objPKICertificateController.removeLines();
        
        lcrobj2.Downloadable__c=true;
        lcrObj2.Email_Address1__c = 'test@test.com';
        objPKICertificateController.saveLCR();
        
        test.stopTest();
        
    }
    
    /**
    * @author Shiva Shankar
    * @description - PKICertificateController2
    * @input param  - null
    * @return param null
    */ 
    static testMethod void PKICertificateController2() 
    {
        //Create an account record and insert it
        list<Account> accounts = ViasatTestUtility.createAccounts(1,'License and Certificate Request');
        accounts[0].Status__c='Prospect';
        accounts[0].Type='Partner';
        accounts[0].Industry='Banking';
        insert accounts;
        Account objacc = accounts[0];

        //Create a contact record and insert it
        list<Contact> contacts = ViasatTestUtility.createContacts(accounts, 1);
        insert contacts;
        Contact objCon= contacts[0];
        
        //Create a license request record and insert it
        PKI_License_and_Certificate_Request__c lcrobj2=new PKI_License_and_Certificate_Request__c();
        lcrobj2.Account__c=objacc.id;
        lcrobj2.Requestor__c=objCon.id;
        lcrobj2.Custom_Product__c='LinkWay FS';
        lcrobj2.Downloadable__c=false;
        lcrobj2.Deliver_on_Disk__c=false;
        lcrobj2.Electronic_Delivery__c=false;
        //lcrobj2.Email_Address1__c='Test@gmail.com';
        lcrobj2.Software_Version__c='23.1';
        lcrobj2.Status__c='New';
        lcrobj2.Shipping_City__c = null;
        lcrobj2.Shipping_Country__c = null;
        lcrobj2.Shipping_Address_Line_1__c = null;
        

        //Create an instance of standard controller
        Apexpages.Standardcontroller stdcon = new Apexpages.Standardcontroller(lcrObj2);
        //Create an instance of extension
        PKICertificateController objPKICertificateController = new PKICertificateController(stdcon);
        
        test.startTest();
        
        //Call the methods in the controller
        objPKICertificateController.returToList();
        objPKICertificateController.save();
        
        objPKICertificateController.submit();
        
        objPKICertificateController.returToList();
        
        test.stopTest();
        
        
    }
    /**
    * @author Shiva Shankar
    * @description - PKICertificateController3
    * @input param  - null
    * @return param null
    */ 
    static testMethod void PKICertificateController3() 
    {
        //Create an account record and insert it
        list<Account> accounts = ViasatTestUtility.createAccounts(1,'License and Certificate Request');
        accounts[0].Status__c='Prospect';
        accounts[0].Type='Partner';
        accounts[0].Industry='Banking';
        insert accounts;
        Account objacc = accounts[0];
                
        //Create a contact record and insert it
        list<Contact> contacts = ViasatTestUtility.createContacts(accounts, 1);
        insert contacts;
        Contact objCon= contacts[0];
        
        //Create a license request record and insert it
        PKI_License_and_Certificate_Request__c lcrobj2=new PKI_License_and_Certificate_Request__c();
        lcrobj2.Account__c=objacc.id;
        lcrobj2.Requestor__c=objCon.id;
        lcrobj2.Custom_Product__c='LinkWay FS';
        lcrobj2.Downloadable__c=false;
        lcrobj2.Deliver_on_Disk__c=false;
        lcrobj2.Electronic_Delivery__c=false;
        lcrobj2.Email_Address1__c='Test@gmail.com';
        lcrobj2.Software_Version__c='23.1';
        lcrobj2.Status__c='New';
        lcrobj2.Shipping_City__c = null;
        lcrobj2.Shipping_Address_Line_1__c = null;
        insert lcrobj2;
        
        //Create a MAC address record and insert it
        MAC_Address__c macObj1= new MAC_Address__c();
        macObj1.License_and_Certificate_Request__c=lcrobj2.Id;
        macObj1.Certificate_Type__c='New';
        macObj1.License_Type__c='New';
        macObj1.Comments__c='Test';
        macObj1.MAC_Address__c='11:22:33:44:55:66';
        macObj1.Server_Serial__c='123456';
        insert macObj1;
        
        //Create an instance of standard controller
        Apexpages.Standardcontroller stdcon = new Apexpages.Standardcontroller(lcrObj2);
        //Create an instance of extension
        PKICertificateController objPKICertificateController = new PKICertificateController(stdcon);
        
        test.startTest();
        
        //Call the methods in the controller
        objPKICertificateController.isMACValid('11:22:33:44:55:66');
        objPKICertificateController.isMACValid('11:2');
        objPKICertificateController.submit();
        
        objPKICertificateController.macAddlines[0].Server_Serial__c='';
        objPKICertificateController.macAddlines[0].License_Type__c='';
        objPKICertificateController.macAddlines[0].Certificate_Type__c='';
        objPKICertificateController.macAddlines[0].MAC_Address__c='';    
        objPKICertificateController.submit();
        
        MAC_Address__c macObj2= new MAC_Address__c();
        macObj2.License_and_Certificate_Request__c=lcrobj2.Id;
        macObj2.Certificate_Type__c='New';
        macObj2.License_Type__c='New';
        macObj2.Comments__c='Test';
        macObj2.MAC_Address__c='11:22:33:44:55:66';
        macObj2.Server_Serial__c='123456';
        objPKICertificateController.macAddlines.add(macObj2);
        objPKICertificateController.returToList();
        
        objPKICertificateController.submit();
        objPKICertificateController.macAddlines = new List<MAC_Address__c>();
        objPKICertificateController.submitCLR();
        objPKICertificateController.returToList();
        
        objPKICertificateController.redirectPage();
        objPKICertificateController.rediretToViewPage();
        objPKICertificateController.createNewRequest();
        
        test.stopTest();
         
    }
    /**
    * @author Shiva Shankar
    * @description - PKICertificateController4
    * @input param  - null
    * @return param null
    */ 
    static testMethod void PKICertificateController4() 
    {
        
        //Create an account record and insert it
        list<Account> accounts = ViasatTestUtility.createAccounts(1,'License and Certificate Request');
        accounts[0].Status__c='Prospect';
        accounts[0].Type='Partner';
        accounts[0].Industry='Banking';
        insert accounts;
        Account objacc = accounts[0];
                
        //Create a contact record and insert it
        list<Contact> contacts = ViasatTestUtility.createContacts(accounts, 1);
        insert contacts;
        Contact objCon= contacts[0];
        
        //Create an Entitlement record and insert it
        Entitlement ent = new Entitlement();
        ent.AccountId = objacc.Id;
        ent.Name = 'Entitlement';
        ent.startDate = system.today();
        ent.endDate = system.today()+10;
        ent.Type = 'Certificate and License Requests';
        ent.Product__c = 'Linkway';
        insert ent;
        
        //Create a license request record and insert it
        PKI_License_and_Certificate_Request__c lcrobj2=new PKI_License_and_Certificate_Request__c();
        lcrobj2.Account__c=objacc.id;
        lcrobj2.Requestor__c=objCon.id;
        lcrobj2.Custom_Product__c='LinkWay FS';
        lcrobj2.Downloadable__c=false;
        lcrobj2.Deliver_on_Disk__c=false;
        lcrobj2.Electronic_Delivery__c=false;
        lcrobj2.Email_Address1__c='Test@gmail.com';
        lcrobj2.Software_Version__c='23.1';
        lcrobj2.Status__c='New';
        lcrobj2.Shipping_City__c = null;
        lcrobj2.Shipping_Address_Line_1__c = null;
        insert lcrobj2;
        
        //Create a MAC address record and insert it
        MAC_Address__c macObj1= new MAC_Address__c();
        macObj1.License_and_Certificate_Request__c=lcrobj2.Id;
        macObj1.Certificate_Type__c='New';
        macObj1.License_Type__c='New';
        macObj1.Comments__c='Test';
        macObj1.MAC_Address__c='11:22:33:44:55:66';
        macObj1.Server_Serial__c='123456';
        insert macObj1;

        //Create an instance of standard controller
        Apexpages.Standardcontroller stdcon = new Apexpages.Standardcontroller(lcrObj2);
        //Create an instance of extension
        PKICertificateController objPKICertificateController = new PKICertificateController(stdcon);
        
        test.startTest();
        
        User u=[select name,contactid,email from User where IsActive = true AND contactid != null LIMIT 1];
        if(u != null){
        system.runAs(u){
        objPKICertificateController.isMACValid('11:22:33:44:55:66');
        objPKICertificateController.isMACValid('11:2');
        objPKICertificateController.CheckPermitToSave();
        objPKICertificateController.submit();

        
        objPKICertificateController.macAddlines[0].Server_Serial__c='';
        objPKICertificateController.macAddlines[0].License_Type__c='';
        objPKICertificateController.macAddlines[0].Certificate_Type__c='';
        objPKICertificateController.macAddlines[0].MAC_Address__c='';       
        objPKICertificateController.submit();
        
        
        MAC_Address__c macObj2= new MAC_Address__c();
        macObj2.License_and_Certificate_Request__c=lcrobj2.Id;
        macObj2.Certificate_Type__c='New';
        macObj2.License_Type__c='New';
        macObj2.Comments__c='Test';
        macObj2.MAC_Address__c='11:22:33:44:55:66';
        macObj2.Server_Serial__c='123456';
        objPKICertificateController.macAddlines.add(macObj2);
        objPKICertificateController.returToList();
        
        objPKICertificateController.submit();
        objPKICertificateController.submitCLR();
        objPKICertificateController.returToList();
        
        objPKICertificateController.redirectPage();
        objPKICertificateController.rediretToViewPage();
        objPKICertificateController.createNewRequest();
        
        test.stopTest();
      } 
      }  
    }
    
    /**
    * @author Shiva Shankar
    * @description - PKICertificateController5
    * @input param  - null
    * @return param null
    */
    static testMethod void PKICertificateController5() 
    {
        //Create an account record and insert it
        list<Account> accounts = ViasatTestUtility.createAccounts(1,'License and Certificate Request');
        accounts[0].Status__c='Prospect';
        accounts[0].Type='Partner';
        accounts[0].Industry='Banking';
        insert accounts;
        Account objacc = accounts[0];
                
        //Create a contact record and insert it
        list<Contact> contacts = ViasatTestUtility.createContacts(accounts, 1);
        insert contacts;
        Contact objCon= contacts[0];
        
        //Create a license request record and insert it
        PKI_License_and_Certificate_Request__c lcrobj2=new PKI_License_and_Certificate_Request__c();
        lcrobj2.Account__c=objacc.id;
        lcrobj2.Requestor__c=objCon.id;
        lcrobj2.Custom_Product__c='LinkWay FS';
        lcrobj2.Downloadable__c=true;
        lcrobj2.Deliver_on_Disk__c=false;
        lcrobj2.Electronic_Delivery__c=false;
        lcrobj2.Email_Address1__c='Test@gmail.com';
        lcrobj2.Email_Address2__c='Test@gmail.com';
        lcrobj2.Software_Version__c='23.1';
        lcrobj2.Status__c='New';
        insert lcrobj2;
        
        //Create a attachment record and insert it
        Attachment objAtt=new Attachment();
        Blob b = Blob.valueOf('Test Data'); 
        objAtt.Name='Text';
        objAtt.IsPrivate=true;
        objAtt.ParentId=lcrobj2.Id;
        objAtt.Body=b;
        insert objAtt;
        
        //Create an instance of standard controller
        Apexpages.Standardcontroller stdcon = new Apexpages.Standardcontroller(lcrObj2);
        //Create an instance of extension
        PKICertificateController objPKICertificateController = new PKICertificateController(stdcon);
        
        test.startTest();
        
        //Call the methods in the controller
        objPKICertificateController.myfile = objAtt;        
        objPKICertificateController.saveLCR();
        
        ApexPages.currentPage().getParameters().put('attachmentid', objAtt.Id);
        
        objPKICertificateController.myfile = objAtt;        
        objPKICertificateController.save();
        objPKICertificateController.ViewAttachment();
        objPKICertificateController.EditAttachment();
        objPKICertificateController.DelAttachment();
        objPKICertificateController.getmyfile();
        objPKICertificateController.getlistattachments();
        objPKICertificateController.populateRequestorDetail();
        objPKICertificateController.returToList();
        objPKICertificateController.cancel();
        
        test.stopTest();
        
    }
    /**
    * @author Shiva Shankar
    * @description - PKICertificateController6
    * @input param  - null
    * @return param null
    */ 
    static testMethod void PKICertificateController6() 
    {
        //Create an account record and insert it
        list<Account> accounts = ViasatTestUtility.createAccounts(1,'License and Certificate Request');
        accounts[0].Status__c='Prospect';
        accounts[0].Type='Partner';
        accounts[0].Industry='Banking';
        insert accounts;
        Account objacc = accounts[0];
                
        //Create a contact record and insert it
        list<Contact> contacts = ViasatTestUtility.createContacts(accounts, 1);
        insert contacts;
        Contact objCon= contacts[0];
        
        //Create a license request record and insert it
        PKI_License_and_Certificate_Request__c lcrobj2=new PKI_License_and_Certificate_Request__c();
        lcrobj2.Account__c=objacc.id;
        lcrobj2.Requestor__c=objCon.id;
        lcrobj2.Custom_Product__c='LinkWay FS';
        lcrobj2.Downloadable__c=false;
        lcrobj2.Deliver_on_Disk__c=false;
        lcrobj2.Electronic_Delivery__c=false;
        lcrobj2.Email_Address1__c='Test@gmail.com';
        lcrobj2.Software_Version__c='23.1';
        lcrobj2.Status__c='New';
        insert lcrobj2;
        
        //Create an instance of standard controller
        Apexpages.Standardcontroller stdcon = new Apexpages.Standardcontroller(lcrObj2);
        //Create an instance of extension
        PKICertificateController objPKICertificateController = new PKICertificateController(stdcon);
        
        test.startTest();
        
        //Call the methods in the controller
        
        lcrobj2.Downloadable__c = true;
        objPKICertificateController.saveLCR();
        
        lcrobj2.Downloadable__c = false;
        lcrobj2.Email_Address2__c='Test@gmail.com';
        objPKICertificateController.saveLCR();
        
        lcrobj2.Downloadable__c = false;
        lcrobj2.Deliver_on_Disk__c= false;
        objPKICertificateController.saveLCR();
        
        test.stopTest();
    }
    /**
    * @author Shiva Shankar
    * @description - PKICertificateController7
    * @input param  - null
    * @return param null
    */ 
    static testMethod void PKICertificateController7() 
    {
        //Create an account record and insert it
        list<Account> accounts = ViasatTestUtility.createAccounts(1,'License and Certificate Request');
        accounts[0].Status__c='Prospect';
        accounts[0].Type='Partner';
        accounts[0].Industry='Banking';
        insert accounts;
        Account objacc = accounts[0];

        //Create a contact record and insert it
        list<Contact> contacts = ViasatTestUtility.createContacts(accounts, 1);
        insert contacts;
        Contact objCon= contacts[0];
                
        //Create an Entitlement record and insert it
        Entitlement ent = new Entitlement();
        ent.AccountId = objacc.Id;
        ent.Name = 'Entitlement';
        ent.startDate = system.today();
        ent.endDate = system.today()+10;
        ent.Type = 'Certificate and License Requests';
        ent.Product__c = 'Linkway';
        insert ent;
        
        //Create a license request record and insert it
        PKI_License_and_Certificate_Request__c lcrobj2=new PKI_License_and_Certificate_Request__c();
        lcrobj2.Account__c=objacc.id;
        lcrobj2.Requestor__c=objCon.id;
        lcrobj2.Custom_Product__c='LinkWay FS';
        lcrobj2.Downloadable__c=true;
        lcrobj2.Deliver_on_Disk__c=false;
        lcrobj2.Electronic_Delivery__c=false;
        lcrobj2.Email_Address1__c='Test@gmail.com';
        lcrobj2.Email_Address2__c='Test1@gmail.com';
        lcrobj2.Software_Version__c='23.1';
        lcrobj2.Status__c ='Pending Submission';
        lcrobj2.Shipping_City__c = null;
        lcrobj2.Shipping_Address_Line_1__c = null;
        insert lcrobj2;
        
        //Create a MAC address record and insert it
        MAC_Address__c macObj1= new MAC_Address__c();
        macObj1.License_and_Certificate_Request__c=lcrobj2.Id;
        macObj1.Certificate_Type__c='New';
        macObj1.License_Type__c='New';
        macObj1.Comments__c='Test';
        macObj1.MAC_Address__c='11:22:33:44:55:66';
        macObj1.Server_Serial__c='123456';
        insert macObj1;
        
        //Create an instance of standard controller
        Apexpages.Standardcontroller stdcon = new Apexpages.Standardcontroller(lcrObj2);
        //Create an instance of extension
        PKICertificateController objPKICertificateController = new PKICertificateController(stdcon);
        
        test.startTest();
        
        //Call the methods in the controller
        objPKICertificateController.uploadLines();
        
        objPKICertificateController.isValidEntitlement(lcrobj2,lcrobj2);
        objPKICertificateController.save();
        objPKICertificateController.isValidEntitlement(lcrobj2,null);
        objPKICertificateController.save();
        
        test.stopTest();
        
    }
    /**
    * @author Poornima
    * @description - PKICertificateController8
    * @input param  - null
    * @return param null
    */ 
    static testMethod void PKICertificateController8() 
    {
        //Create an account record and insert it
        list<Account> accounts = ViasatTestUtility.createAccounts(1,'License and Certificate Request');
        accounts[0].Status__c='Prospect';
        accounts[0].Type='Partner';
        accounts[0].Industry='Banking';
        insert accounts;
        Account objacc = accounts[0];
        
        //Create a contact record and insert it
        List<Contact> contacts = ViasatTestUtility.createContacts(accounts, 1);
        Contact con = contacts[0];
        insert con;

        User user = ViasatTestUtility.createInsertUser(con, 'License and Certificate Requests');
                
        //Create an Entitlement record and insert it
        Entitlement ent = new Entitlement();
        ent.AccountId = objacc.Id;
        ent.Name = 'Entitlement';
        ent.startDate = system.today();
        ent.endDate = system.today()+10;
        ent.Type = 'Certificate and License Requests';
        ent.Product__c = 'Linkway';
        insert ent;
                
        test.startTest();
              
        //User user = [select Id,ContactId from user where profile.Name = 'License and Certificate Requests' and contactId != null limit 1];
        if(user != null){
        Contact c = [Select AccountId,Id from Contact where Id =:user.ContactId limit 1];
 
        // Unable to let the portal user set the status to Approved.
        // We create the lcr record as system and share it with the portal user 
        // case 00306272 Feb 2015 - PL
        // system.runAs(user){
        
        //Create a license request record and insert it
        PKI_License_and_Certificate_Request__c lcrobj2=new PKI_License_and_Certificate_Request__c();
        lcrobj2.Account__c=c.AccountId;
        lcrobj2.Requestor__c = user.ContactId;
        lcrobj2.Custom_Product__c='LinkWay FS';
        lcrobj2.Downloadable__c=true;
        lcrobj2.Deliver_on_Disk__c=false;
        lcrobj2.Electronic_Delivery__c=false;
        lcrobj2.Email_Address1__c='Test@gmail.com';
        lcrobj2.Email_Address2__c='Test1@gmail.com';
        lcrobj2.Software_Version__c='23.1';
        lcrobj2.Status__c = label.PKI_Certificate_Request_Status_Approved;
        lcrobj2.Shipping_City__c = null;
        lcrobj2.Shipping_Address_Line_1__c = null;
        insert lcrobj2;
        
        //Create a MAC address record and insert it
        MAC_Address__c macObj1= new MAC_Address__c();
        macObj1.License_and_Certificate_Request__c=lcrobj2.Id;
        macObj1.Certificate_Type__c='New';
        macObj1.License_Type__c='New';
        macObj1.Comments__c='Test';
        macObj1.MAC_Address__c='11:22:33:44:55:66';
        macObj1.Server_Serial__c='123456';
        insert macObj1;
        
        // case 00306272 Feb 2015 - PL
        // share lc with portal user
        // in order for the portal user to access it
        PKI_License_and_Certificate_Request__Share lcShr = new PKI_License_and_Certificate_Request__Share();
        lcShr.ParentId = lcrobj2.Id;
        lcShr.UserOrGroupId = user.id;        
        lcShr.AccessLevel = 'Edit';
        insert lcShr;
              
        system.runAs(user){
        
        
        //Create an instance of standard controller
        Apexpages.Standardcontroller stdcon = new Apexpages.Standardcontroller(lcrObj2);
        //Create an instance of extension
        PKICertificateController objPKICertificateController = new PKICertificateController(stdcon);
        //Call the methods in the controller
        objPKICertificateController.saveLCR();
        }
        }
        test.Stoptest(); 
    }
    /**
    * @author Poornima
    * @description - PKICertificateController9
    * @input param  - null
    * @return param null
    */ 
    static testMethod void PKICertificateController9() 
    {
        //Create an account record and insert it
        list<Account> accounts = ViasatTestUtility.createAccounts(1,'License and Certificate Request');
        accounts[0].Status__c='Prospect';
        accounts[0].Type='Partner';
        accounts[0].Industry='Banking';
        insert accounts;
        Account objacc = accounts[0];
        
        //Create a contact record and insert it
        List<Contact> contacts = ViasatTestUtility.createContacts(accounts, 1);
        Contact con = contacts[0];
        insert con;

        User user = ViasatTestUtility.createInsertUser(con, 'License and Certificate Requests');
        
        //Create an Entitlement record and insert it
        Entitlement ent = new Entitlement();
        ent.AccountId = objacc.Id;
        ent.Name = 'Entitlement';
        ent.startDate = system.today();
        ent.endDate = system.today()+10;
        ent.Type = 'Certificate and License Requests';
        ent.Product__c = 'Linkway';
        insert ent;
        
        test.startTest();
        
        //User user = [select Id,ContactId from user where profile.Name = 'License and Certificate Requests' and contactId != null limit 1];
        if(user != null){
        Contact c = [Select AccountId,Id from Contact where Id =:user.ContactId limit 1];

        system.runAs(user){
        
        //Create a license request record and insert it
        PKI_License_and_Certificate_Request__c lcrobj2=new PKI_License_and_Certificate_Request__c();
        lcrobj2.Account__c=c.AccountId;
        lcrobj2.Requestor__c = user.ContactId;
        lcrobj2.Custom_Product__c='LinkWay FS';
        lcrobj2.Downloadable__c=true;
        lcrobj2.Deliver_on_Disk__c=false;
        lcrobj2.Electronic_Delivery__c=false;
        lcrobj2.Email_Address1__c='Test@gmail.com';
        lcrobj2.Email_Address2__c='Test1@gmail.com';
        lcrobj2.Software_Version__c='23.1';
        lcrobj2.Status__c = label.PKI_Certificate_Request_Status_Cancelled;
        lcrobj2.Shipping_City__c = null;
        lcrobj2.Shipping_Country__c = null;
        lcrobj2.Shipping_Address_Line_1__c = null;
        insert lcrobj2;
        
        //Create a MAC address record and insert it
        MAC_Address__c macObj1= new MAC_Address__c();
        macObj1.License_and_Certificate_Request__c=lcrobj2.Id;
        macObj1.Certificate_Type__c='New';
        macObj1.License_Type__c='New';
        macObj1.Comments__c='Test';
        macObj1.MAC_Address__c='11:22:33:44:55:66';
        macObj1.Server_Serial__c='123456';
        insert macObj1;
        
        //Create an instance of standard controller
        Apexpages.Standardcontroller stdcon = new Apexpages.Standardcontroller(lcrObj2);
        //Create an instance of extension
        PKICertificateController objPKICertificateController = new PKICertificateController(stdcon);
        objPKICertificateController.saveLCR();
        }
        }
        test.Stoptest(); 
    }
    
    /**
    * @author Poornima
    * @description - PKICertificateController10
    * @input param  - null
    * @return param null
    */ 
    static testMethod void PKICertificateController10() 
    {
        //Create an account record and insert it
        list<Account> accounts = ViasatTestUtility.createAccounts(1,'License and Certificate Request');
        accounts[0].Status__c='Prospect';
        accounts[0].Type='Partner';
        accounts[0].Industry='Banking';
        insert accounts;
        Account objacc = accounts[0];
        
        //Create a contact record and insert it
        List<Contact> contacts = ViasatTestUtility.createContacts(accounts, 1);
        Contact con = contacts[0];
        insert con;

        User user = ViasatTestUtility.createInsertUser(con, 'License and Certificate Requests');
        
        //Create an Entitlement record and insert it
        Entitlement ent = new Entitlement();
        ent.AccountId = objacc.Id;
        ent.Name = 'Entitlement';
        ent.startDate = system.today();
        ent.endDate = system.today()+10;
        ent.Type = 'Certificate and License Requests';
        ent.Product__c = 'Linkway';
        insert ent;
        
        test.startTest();
        
        //User user = [select Id,ContactId from user where profile.Name = 'License and Certificate Requests' and contactId != null limit 1];
        
        if(user != null){
            Contact c = [Select AccountId,Id from Contact where Id =:user.ContactId limit 1];


        system.runAs(user){
        
        //Create a license request record and insert it
        PKI_License_and_Certificate_Request__c lcrobj2=new PKI_License_and_Certificate_Request__c();
        lcrobj2.Account__c=c.AccountId;
        lcrobj2.Requestor__c = user.ContactId;
        lcrobj2.Custom_Product__c='LinkWay FS';
        lcrobj2.Downloadable__c=true;
        lcrobj2.Deliver_on_Disk__c=false;
        lcrobj2.Electronic_Delivery__c=false;
        lcrobj2.Email_Address1__c=null;
        lcrobj2.Email_Address2__c='Test1@gmail.com';
        lcrobj2.Software_Version__c='23.1';
        lcrobj2.Status__c = label.PKI_Certificate_Request_Status_Closed;
        lcrobj2.Shipping_City__c = null;
        lcrobj2.Shipping_Address_Line_1__c = null;
        insert lcrobj2;
        
        //Create a MAC address record and insert it
        MAC_Address__c macObj1= new MAC_Address__c();
        macObj1.License_and_Certificate_Request__c=lcrobj2.Id;
        macObj1.Certificate_Type__c='New';
        macObj1.License_Type__c='New';
        macObj1.Comments__c='Test';
        macObj1.MAC_Address__c='11:22:33:44:55:66';
        macObj1.Server_Serial__c='123456';
        insert macObj1;
        
        //Create an instance of standard controller
        Apexpages.Standardcontroller stdcon = new Apexpages.Standardcontroller(lcrObj2);
        //Create an instance of extension
        PKICertificateController objPKICertificateController = new PKICertificateController(stdcon);
        //Call the methods in the controller
        objPKICertificateController.saveLCR();
        }
        }
        test.Stoptest(); 
    }
    /**
    * @author Poornima
    * @description - PKICertificateController11
    * @input param  - null
    * @return param null
    */ 
    
    static testMethod void PKICertificateController11() 
    {
        //Create an account record and insert it
        list<Account> accounts = ViasatTestUtility.createAccounts(1,'License and Certificate Request');
        accounts[0].Status__c='Prospect';
        accounts[0].Type='Partner';
        accounts[0].Industry='Banking';
        insert accounts;
        Account objacc = accounts[0];
        
        //Create a contact record and insert it
        List<Contact> contacts = ViasatTestUtility.createContacts(accounts, 1);
        Contact con = contacts[0];
        insert con;

        User user = ViasatTestUtility.createInsertUser(con, 'License and Certificate Requests');
        
        //Create an Entitlement record and insert it
        Entitlement ent = new Entitlement();
        ent.AccountId = objacc.Id;
        ent.Name = 'Entitlement';
        ent.startDate = system.today();
        ent.endDate = system.today()+10;
        ent.Type = 'Certificate and License Requests';
        ent.Product__c = 'Linkway';
        insert ent;
        
        test.startTest();
        
        //User user = [select Id,ContactId from user where profile.Name = 'License and Certificate Requests' and contactId != null limit 1];
        if(user != null){ 
        Contact c = [Select AccountId,Id from Contact where Id =:user.ContactId limit 1];
 
        system.runAs(user){
        
        //Create a license request record and insert it
        PKI_License_and_Certificate_Request__c lcrobj2=new PKI_License_and_Certificate_Request__c();
        lcrobj2.Account__c=c.AccountId;
        lcrobj2.Requestor__c = user.ContactId;
        lcrobj2.Custom_Product__c='LinkWay FS';
        lcrobj2.Downloadable__c=true;
        lcrobj2.Deliver_on_Disk__c=false;
        lcrobj2.Electronic_Delivery__c=false;
        lcrobj2.Email_Address1__c='Test@gmail.com';
        lcrobj2.Email_Address2__c='Test1@gmail.com';
        lcrobj2.Software_Version__c='23.1';
        lcrobj2.Status__c = label.PKI_Certificate_Request_Status_Completed;
        lcrobj2.Shipping_City__c = null;
        lcrobj2.Shipping_Address_Line_1__c = null;
        insert lcrobj2;
        
        //Create a MAC address record and insert it
        MAC_Address__c macObj1= new MAC_Address__c();
        macObj1.License_and_Certificate_Request__c=lcrobj2.Id;
        macObj1.Certificate_Type__c='New';
        macObj1.License_Type__c='New';
        macObj1.Comments__c='Test';
        macObj1.MAC_Address__c='11:22:33:44:55:66';
        macObj1.Server_Serial__c='123456';
        insert macObj1;
        
        //Create an instance of standard controller
        Apexpages.Standardcontroller stdcon = new Apexpages.Standardcontroller(lcrObj2);
        //Create an instance of extension
        PKICertificateController objPKICertificateController = new PKICertificateController(stdcon);
        
        //Call the methods in the controller
        objPKICertificateController.saveLCR();
        }
        }
        test.Stoptest(); 
    }
    
    /**
    * @author Poornima
    * @description - PKICertificateController12
    * @input param  - null
    * @return param null
    */  
    static testMethod void PKICertificateController12() 
    {
        //Create an account record and insert it
        list<Account> accounts = ViasatTestUtility.createAccounts(1,'License and Certificate Request');
        accounts[0].Status__c='Prospect';
        accounts[0].Type='Partner';
        accounts[0].Industry='Banking';
        insert accounts;
        Account objacc = accounts[0];

        //Create a contact record and insert it
        list<Contact> contacts = ViasatTestUtility.createContacts(accounts, 1);
        insert contacts;
        Contact objCon= contacts[0];
                
        //Create an Entitlement record and insert it
        Entitlement ent = new Entitlement();
        ent.AccountId = objacc.Id;
        ent.Name = 'Entitlement';
        ent.startDate = system.today();
        ent.endDate = system.today()+10;
        ent.Type = 'Certificate and License Requests';
        ent.Product__c = 'Linkway';
        insert ent;
        
        //Create a license request record and insert it
        PKI_License_and_Certificate_Request__c lcrobj2=new PKI_License_and_Certificate_Request__c();
        lcrobj2.Account__c=objacc.id;
        lcrobj2.Requestor__c=objCon.id;
        lcrobj2.Custom_Product__c='LinkWay FS';
        lcrobj2.Downloadable__c=true;
        lcrobj2.Deliver_on_Disk__c=false;
        lcrobj2.Electronic_Delivery__c=false;
        lcrObj2.Shipping_Country__c = null;
        lcrObj2.Email_Address1__c = 'test@test.com';
        lcrObj2.Email_Address2__c = null;
        lcrobj2.Software_Version__c='23.1';
        lcrobj2.Status__c='New';
        lcrobj2.Shipping_City__c = null;
        lcrobj2.Shipping_Address_Line_1__c = null;
        insert lcrobj2;
        
        //Create a MAC address record and insert it
        MAC_Address__c macObj1= new MAC_Address__c();
        macObj1.License_and_Certificate_Request__c=lcrobj2.Id;
        macObj1.Certificate_Type__c='New';
        macObj1.License_Type__c='New';
        macObj1.Comments__c='Test';
        macObj1.MAC_Address__c='11:22:33:44:55:66';
        macObj1.Server_Serial__c='123456';
        insert macObj1;
        
        //Create another MAC address record and insert it
        MAC_Address__c macObj2= new MAC_Address__c();
        macObj2.License_and_Certificate_Request__c=lcrobj2.Id;
        macObj2.Certificate_Type__c='New';
        macObj2.License_Type__c='New';
        macObj2.Comments__c='Test';
        macObj2.MAC_Address__c='11:22:33:44:55:66';
        macObj2.Server_Serial__c='123456';
        insert macObj2;

        //Create an instance of standard controller
        Apexpages.Standardcontroller stdcon = new Apexpages.Standardcontroller(lcrObj2);
        //Create an instance of custom controller
        PKICertificateController objPKICertificateController = new PKICertificateController(stdcon);
        
        test.startTest();
        
        //Call the methods in the controller
        objPKICertificateController.CheckPermitToSave();
        objPKICertificateController.submit();
        
        objPKICertificateController.macAddlines[0].Server_Serial__c='';
        objPKICertificateController.macAddlines[0].License_Type__c='';
        objPKICertificateController.macAddlines[0].Certificate_Type__c='';
        objPKICertificateController.macAddlines[0].MAC_Address__c='';       
        objPKICertificateController.submit();
        
        objPKICertificateController.uploadLines();
        objPKICertificateController.macAddlines[0].Marked_For_Deletion__c = true;
        objPKICertificateController.removeLines();
        
        Cookie DOLIKCZXHW = new Cookie('DOLIKCZXHW','ILDMRBNFVM',null,0,false);
        ApexPages.currentPage().setCookies(new Cookie[]{DOLIKCZXHW});
        ApexPages.currentPage().getParameters().put('submit','0'); 
        objPKICertificateController.submitAction();       
        objPKICertificateController.save();
        
        lcrobj2.Status__c ='Pending Submission';
        objPKICertificateController.isValidEntitlement(lcrobj2,lcrobj2);
        objPKICertificateController.save();
        objPKICertificateController.isValidEntitlement(lcrobj2,null);
        objPKICertificateController.save();
        objPKICertificateController.getMyFile();
        objPKICertificateController.getListAttachments();
        objPKICertificateController.PopulateRequestorDetail();
        objPKICertificateController.getLines();
        objPKICertificateController.getLines(true);
        objPKICertificateController.getLines(false);
        macObj2.Marked_For_Deletion__c = true;
        objPKICertificateController.returToList();
        objPKICertificateController.cancel();
        
        
        objPKICertificateController.removeLines();
        
        objPKICertificateController.saveLCR();
        
        test.stopTest();
    }
    
    /**
    * @author Poornima
    * @description - PKICertificateController13
    * @input param  - null
    * @return param null
    */  
    static testMethod void PKICertificateController13() 
    {
        //Create an account record and insert it
        list<Account> accounts = ViasatTestUtility.createAccounts(1,'License and Certificate Request');
        accounts[0].Status__c='Prospect';
        accounts[0].Type='Partner';
        accounts[0].Industry='Banking';
        insert accounts;
        Account objacc = accounts[0];

        //Create a contact record and insert it
        list<Contact> contacts = ViasatTestUtility.createContacts(accounts, 1);
        insert contacts;
        Contact objCon= contacts[0];
        
        //Create an Entitlement record and insert it
        Entitlement ent = new Entitlement();
        ent.AccountId = objacc.Id;
        ent.Name = 'Entitlement';
        ent.startDate = system.today();
        ent.Type = 'Certificate and License Requests';
        ent.Product__c = 'Linkway';
        insert ent;
        
        Entitlement e = [select AccountId,status from Entitlement where status =: 'Active' and id =: ent.Id limit 1];
        e.AccountId = objacc.Id;
        e.Type = 'Certificate and License Requests';
        e.Product__c = 'Linkway';
        update e;
        
        //Create a license request record and insert it
        PKI_License_and_Certificate_Request__c lcrobj2=new PKI_License_and_Certificate_Request__c();
        lcrobj2.Account__c=objacc.id;
        lcrobj2.Requestor__c=objCon.id;
        lcrobj2.Custom_Product__c='LinkWay';
        lcrobj2.Downloadable__c=false;
        lcrobj2.Deliver_on_Disk__c=true;
        lcrobj2.Electronic_Delivery__c=false;
        lcrObj2.Shipping_Country__c = '';
        lcrObj2.Email_Address1__c = 'test@test.com';
        lcrObj2.Email_Address2__c = null;
        lcrobj2.Software_Version__c='23.1';
        lcrobj2.Status__c='New';
        lcrobj2.Shipping_City__c = '';
        lcrobj2.Shipping_Address_Line_1__c = null;
        insert lcrobj2;
        
        //Create a MAC address record and insert it
        MAC_Address__c macObj1= new MAC_Address__c();
        macObj1.License_and_Certificate_Request__c=lcrobj2.Id;
        macObj1.Certificate_Type__c='New';
        macObj1.License_Type__c='New';
        macObj1.Comments__c='Test';
        macObj1.MAC_Address__c='11:22:33:44:55:66';
        macObj1.Server_Serial__c='123456';
        insert macObj1;
        
        //Create another MAC address record and insert it
        MAC_Address__c macObj2= new MAC_Address__c();
        macObj2.License_and_Certificate_Request__c=lcrobj2.Id;
        macObj2.Certificate_Type__c='New';
        macObj2.License_Type__c='New';
        macObj2.Comments__c='Test';
        macObj2.MAC_Address__c='11:22:33:44:55:66';
        macObj2.Server_Serial__c='123456';
        insert macObj2;

        //Create an instance of standard controller
        Apexpages.Standardcontroller stdcon = new Apexpages.Standardcontroller(lcrObj2);
        //Create an instance of custom controller
        PKICertificateController objPKICertificateController = new PKICertificateController(stdcon);
        
        test.startTest();
        
        //Call the methods in the controller
        objPKICertificateController.CheckPermitToSave();
        objPKICertificateController.submit();
        
        objPKICertificateController.macAddlines[0].Server_Serial__c='';
        objPKICertificateController.macAddlines[0].License_Type__c='';
        objPKICertificateController.macAddlines[0].Certificate_Type__c='';
        objPKICertificateController.macAddlines[0].MAC_Address__c='';       
        objPKICertificateController.submit();
        
        objPKICertificateController.uploadLines();
        
        Cookie DOLIKCZXHW = new Cookie('DOLIKCZXHW','ILDMRBNFVM',null,0,false);
        ApexPages.currentPage().setCookies(new Cookie[]{DOLIKCZXHW});
        ApexPages.currentPage().getParameters().put('submit','0'); 
        objPKICertificateController.submitAction();       
        objPKICertificateController.save();
        
        lcrobj2.Status__c ='Pending Submission';
        objPKICertificateController.isValidEntitlement(lcrobj2,lcrobj2);
        objPKICertificateController.save();
        objPKICertificateController.getMyFile();
        objPKICertificateController.getListAttachments();
        objPKICertificateController.PopulateRequestorDetail();
        objPKICertificateController.getLines();
        objPKICertificateController.getLines(true);
        objPKICertificateController.getLines(false);
        objPKICertificateController.returToList();
        objPKICertificateController.cancel();
        
        
        objPKICertificateController.removeLines();
        lcrObj2.Shipping_Country__c = '';
        objPKICertificateController.saveLCR();
        
        test.stopTest();
        
    }
    
    /**
    * @author Poornima
    * @description - PKICertificateController14
    * @input param  - null
    * @return param null
    */  
    static testMethod void PKICertificateController14() 
    {
        //Create an account record and insert it
        list<Account> accounts = ViasatTestUtility.createAccounts(1,'License and Certificate Request');
        accounts[0].Status__c='Prospect';
        accounts[0].Type='Partner';
        accounts[0].Industry='Banking';
        insert accounts;
        Account objacc = accounts[0];

        //Create a contact record and insert it
        list<Contact> contacts = ViasatTestUtility.createContacts(accounts, 1);
        insert contacts;
        Contact objCon= contacts[0];
                
        //Create an Entitlement record and insert it
        Entitlement ent = new Entitlement();
        ent.AccountId = objacc.Id;
        ent.Name = 'Entitlement';
        ent.startDate = system.today();
        ent.Type = 'Certificate and License Requests';
        ent.Product__c = 'Linkway';
        insert ent;
        
        Entitlement e = [select AccountId,status from Entitlement where status =: 'Active' and id =: ent.Id limit 1];
        e.AccountId = objacc.Id;
        e.Type = 'Certificate and License Requests';
        e.Product__c = 'Linkway';
        update e;
        
        //Create a license request record and insert it
        PKI_License_and_Certificate_Request__c lcrobj2=new PKI_License_and_Certificate_Request__c();
        lcrobj2.Account__c=objacc.id;
        lcrobj2.Requestor__c=objCon.id;
        lcrobj2.Custom_Product__c='LinkWay';
        lcrobj2.Downloadable__c=true;
        lcrobj2.Deliver_on_Disk__c=false;
        lcrobj2.Electronic_Delivery__c=false;
        lcrObj2.Shipping_Country__c = '';
        lcrObj2.Email_Address1__c = 'test@test.com';
        lcrObj2.Email_Address2__c = 'test1@test.com';
        lcrobj2.Software_Version__c='23.1';
        lcrobj2.Status__c='New';
        lcrobj2.Shipping_City__c = '';
        lcrobj2.Shipping_Address_Line_1__c = null;
        insert lcrobj2;
        
        //Create a MAC address record and insert it
        MAC_Address__c macObj1= new MAC_Address__c();
        macObj1.License_and_Certificate_Request__c=lcrobj2.Id;
        macObj1.Certificate_Type__c='New';
        macObj1.License_Type__c='New';
        macObj1.Comments__c='Test';
        macObj1.MAC_Address__c='11:22:33:44:55:66';
        macObj1.Server_Serial__c='123456';
        insert macObj1;


        //Create an instance of standard controller
        Apexpages.Standardcontroller stdcon = new Apexpages.Standardcontroller(lcrObj2);
        //Create an instance of custom controller
        PKICertificateController objPKICertificateController = new PKICertificateController(stdcon);
        
        test.startTest();
        
        //Call the methods in the controller
        objPKICertificateController.CheckPermitToSave();
        objPKICertificateController.submit();
        
        test.stopTest();
    }  
    /**
    * @author Poornima
    * @description - PKICertificateController15
    * @input param  - null
    * @return param null
    */  
    static testMethod void PKICertificateController15() 
    {
        //Create an account record and insert it
        list<Account> accounts = ViasatTestUtility.createAccounts(1,'License and Certificate Request');
        accounts[0].Status__c='Prospect';
        accounts[0].Type='Partner';
        accounts[0].Industry='Banking';
        insert accounts;
        Account objacc = accounts[0];

        //Create a contact record and insert it
        list<Contact> contacts = ViasatTestUtility.createContacts(accounts, 1);
        insert contacts;
        Contact objCon= contacts[0];
                
        //Create an Entitlement record and insert it
        Entitlement ent = new Entitlement();
        ent.AccountId = objacc.Id;
        ent.Name = 'Entitlement';
        ent.startDate = system.today();
        ent.Type = 'Certificate and License Requests';
        ent.Product__c = 'Linkway';
        insert ent;
        
        Entitlement e = [select AccountId,status from Entitlement where status =: 'Active' and id =: ent.Id limit 1];
        e.AccountId = objacc.Id;
        e.Type = 'Certificate and License Requests';
        e.Product__c = 'Linkway';
        update e;
        
        //Create a license request record and insert it
        PKI_License_and_Certificate_Request__c lcrobj2=new PKI_License_and_Certificate_Request__c();
        lcrobj2.Account__c=objacc.id;
        lcrobj2.Requestor__c=objCon.id;
        lcrobj2.Custom_Product__c='LinkWay';
        lcrobj2.Downloadable__c=true;
        lcrobj2.Deliver_on_Disk__c=false;
        lcrobj2.Electronic_Delivery__c=false;
        lcrObj2.Shipping_Country__c = null;
        lcrObj2.Email_Address1__c = 'test@test.com';
        lcrObj2.Email_Address2__c = 'test1@test.com';
        lcrobj2.Software_Version__c='23.1';
        lcrobj2.Status__c='New';
        lcrobj2.Shipping_City__c = '';
        lcrobj2.Shipping_Address_Line_1__c = null;
        insert lcrobj2;
        
        //Create an instance of standard controller
        Apexpages.Standardcontroller stdcon = new Apexpages.Standardcontroller(lcrObj2);
        //Create an instance of custom controller
        PKICertificateController objPKICertificateController = new PKICertificateController(stdcon);
        
        test.startTest();
        
        //Call the methods in the controller
        objPKICertificateController.saveLCR();
        lcrobj2.Software_Version__c = '23';
        objPKICertificateController.NoPermissionToSave = true;
        objPKICertificateController.returToList();
        
        test.stopTest();
        
        
    } 
    /**
    * @author Poornima
    * @description - PKICertificateController16
    * @input param  - null
    * @return param null
    */  
    static testMethod void PKICertificateController16() 
    {
        //Create an account record and insert it
        list<Account> accounts = ViasatTestUtility.createAccounts(1,'License and Certificate Request');
        accounts[0].Status__c='Prospect';
        accounts[0].Type='Partner';
        accounts[0].Industry='Banking';
        insert accounts;
        Account objacc = accounts[0];
        
        //Create a contact record and insert it
        list<Contact> contacts = ViasatTestUtility.createContacts(accounts, 1);
        insert contacts;
        Contact objCon= contacts[0];
        
        //Create an Entitlement record and insert it
        Entitlement ent = new Entitlement();
        ent.AccountId = objacc.Id;
        ent.Name = 'Entitlement';
        ent.startDate = system.today();
        ent.Type = 'Certificate and License Requests';
        ent.Product__c = 'Linkway';
        insert ent;
        
        Entitlement e = [select AccountId,status from Entitlement where status =: 'Active' and id =: ent.Id limit 1];
        e.AccountId = objacc.Id;
        e.Type = 'Certificate and License Requests';
        e.Product__c = 'Linkway';
        update e;
                
        //Create a license request record and insert it
        PKI_License_and_Certificate_Request__c lcrobj2=new PKI_License_and_Certificate_Request__c();
        lcrobj2.Account__c=objacc.id;
        lcrobj2.Requestor__c=objCon.id;
        lcrobj2.Custom_Product__c='LinkWay';
        lcrobj2.Downloadable__c=true;
        lcrobj2.Deliver_on_Disk__c=false;
        lcrobj2.Electronic_Delivery__c=false;
        lcrObj2.Shipping_Country__c = '';
        lcrObj2.Email_Address1__c = 'test@test.com';
        lcrObj2.Email_Address2__c = 'test1@test.com';
        lcrobj2.Software_Version__c='23.1';
        lcrobj2.Status__c='New';
        lcrobj2.Shipping_City__c = '';
        lcrobj2.Shipping_Address_Line_1__c = null;
        insert lcrobj2;
        
        //Create a MAC address record and insert it
        MAC_Address__c macObj1= new MAC_Address__c();
        macObj1.License_and_Certificate_Request__c=lcrobj2.Id;
        macObj1.Certificate_Type__c='New';
        macObj1.License_Type__c='New';
        macObj1.Comments__c='Test';
        macObj1.MAC_Address__c='';
        macObj1.Server_Serial__c='';
        insert macObj1;


        //Create an instance of standard controller
        Apexpages.Standardcontroller stdcon = new Apexpages.Standardcontroller(lcrObj2);
        //Create an instance of custom controller
        PKICertificateController objPKICertificateController = new PKICertificateController(stdcon);
        test.startTest();
        
        //Call the methods in the controller
        objPKICertificateController.CheckPermitToSave();
        objPKICertificateController.submit();
        
        test.stopTest();
        
    }
}