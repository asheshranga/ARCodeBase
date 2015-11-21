//Test Method for the Apex Class ToowayAddressLookupController 

@IsTest(SeeAllData=true) public class AddressLookupControllerTest {
    static testmethod void ToowayAddressLookupControllerTest (){
        Account a = new Account(name = 'test');
        insert a;
        
        Address__c sadd = new Address__c(name='test street');
        sadd.Account__c = a.Id;
        sadd.Type__c = 'Ship to';
        sadd.Default__c = true;
        insert sadd;
 
        Apexpages.currentPage().getParameters().put('accountid',a.Id);
        Apexpages.currentPage().getParameters().put('accountname',a.Name);
        Apexpages.currentPage().getParameters().put('txt','ship');
        Apexpages.currentPage().getParameters().put('lksrch','');
        AddressLookupController AddressLookup = new AddressLookupController();    
    
        }

 @IsTest(SeeAllData=true) public static void testAddressLookupControllerBillTo(){
        Account a = new Account(name = 'test');
        insert a;
        
        Address__c badd = new Address__c(name='test street');
        badd.Account__c = a.Id;
        badd.Type__c = 'Bill to';
        badd.Default__c = true;
       // badd.End_Date__c = date.newinstance(2015,05,03);
        insert badd;        
    
        Apexpages.currentPage().getParameters().put('accountid',a.Id);
        Apexpages.currentPage().getParameters().put('accountname',a.Name);
        Apexpages.currentPage().getParameters().put('txt','bill');
        Apexpages.currentPage().getParameters().put('lksrch','test');
        AddressLookupController AddressLookup= new AddressLookupController();    
    
        }
       
 @IsTest(SeeAllData=true) public static void testAddressLookupControllerDropShip(){
        Account a = new Account(name = 'test');
        insert a;
        
        Address__c badd = new Address__c(name='test street');
        badd.Account__c = a.Id;
        badd.Type__c = 'Drop Ship';
        badd.Default__c = true;
        badd.Company__c = 'Test Company';
       // badd.End_Date__c = date.newinstance(2015,05,03);
        insert badd;        
    
        Apexpages.currentPage().getParameters().put('accountid',a.Id);
        Apexpages.currentPage().getParameters().put('accountname',a.Name);
        Apexpages.currentPage().getParameters().put('txt','bill');
        Apexpages.currentPage().getParameters().put('lksrch','test');
        AddressLookupController AddressLookup= new AddressLookupController();    
    
        }
 
        
 @IsTest(SeeAllData=true) public static void testAddressLookupControllerSearch(){
        Account a = new Account(name = 'test');
        insert a;
        
        Address__c sadd = new Address__c(name='test street');
        sadd.Account__c = a.Id;
        sadd.Type__c = 'Ship to';
        sadd.City__c = 'test';
        sadd.State__c = 'ga';
        sadd.Country__c = 'USA';
        sadd.PostalCode__c = '30096';
        sadd.Default__c = true;
        sadd.EBSAddressID__c = '1';
        sadd.Company__c = 'NTT';
       //  sadd.End_Date__c = date.newinstance(2015,05,03);
        insert sadd;
        
        Address__c sadd1 = new Address__c(name='test street1',Account__c=a.Id,EBSAddressID__c = '1',Type__c = 'Ship to');
        insert sadd1;
        Address__c sadd2 = new Address__c(name='test street2',Account__c=a.Id,EBSAddressID__c = '1',Type__c = 'Ship to');
        insert sadd2;
        Address__c sadd3 = new Address__c(name='test street3',Account__c=a.Id,EBSAddressID__c = '1',Type__c = 'Ship to');
        insert sadd3;
        Address__c sadd4 = new Address__c(name='test street4',Account__c=a.Id,EBSAddressID__c = '1',Type__c = 'Ship to');
        insert sadd4;
        Address__c sadd5 = new Address__c(name='test street5',Account__c=a.Id,EBSAddressID__c = '1',Type__c = 'Ship to');
        insert sadd5;
        Address__c sadd6 = new Address__c(name='test street6',Account__c=a.Id,EBSAddressID__c = '1',Type__c = 'Ship to');
        insert sadd6;
        Address__c sadd7 = new Address__c(name='test street7',Account__c=a.Id,EBSAddressID__c = '1',Type__c = 'Ship to');
        insert sadd7;       
        Address__c sadd8 = new Address__c(name='test street8',Account__c=a.Id,EBSAddressID__c = '1',Type__c = 'Ship to');
        insert sadd8;
        Address__c sadd9 = new Address__c(name='test street9',Account__c=a.Id,EBSAddressID__c = '1',Type__c = 'Ship to');
        insert sadd9;
        Address__c sadd10 = new Address__c(name='test street10',Account__c=a.Id,EBSAddressID__c = '1',Type__c = 'Ship to');
        insert sadd10;
        Address__c sadd11 = new Address__c(name='test street11',Account__c=a.Id,EBSAddressID__c = '1',Type__c = 'Ship to');
        insert sadd11;
        Address__c sadd12 = new Address__c(name='test street12',Account__c=a.Id,EBSAddressID__c = '1',Type__c = 'Ship to');
        insert sadd12;
        Address__c sadd13 = new Address__c(name='test street13',Account__c=a.Id,EBSAddressID__c = '1',Type__c = 'Ship to');
        insert sadd13;
        Address__c sadd14 = new Address__c(name='test street14',Account__c=a.Id,EBSAddressID__c = '1',Type__c = 'Ship to');
        insert sadd14;
        Address__c sadd15 = new Address__c(name='test street15',Account__c=a.Id,EBSAddressID__c = '1',Type__c = 'Ship to');
        insert sadd15;
        Address__c sadd16 = new Address__c(name='test street16',Account__c=a.Id,EBSAddressID__c = '1',Type__c = 'Ship to');
        insert sadd16;
        Address__c sadd17 = new Address__c(name='test street17',Account__c=a.Id,EBSAddressID__c = '1',Type__c = 'Ship to');
        insert sadd17;      
        Address__c sadd18 = new Address__c(name='test street18',Account__c=a.Id,EBSAddressID__c = '1',Type__c = 'Ship to');
        insert sadd18;
        Address__c sadd19 = new Address__c(name='test street19',Account__c=a.Id,EBSAddressID__c = '1',Type__c = 'Ship to');
        insert sadd19;
        Address__c sadd20 = new Address__c(name='test street20',Account__c=a.Id,EBSAddressID__c = '1',Type__c = 'Ship to');
        insert sadd20;
        Address__c sadd21 = new Address__c(name='test street21',Account__c=a.Id,EBSAddressID__c = '1',Type__c = 'Ship to');
        insert sadd21;
        Address__c sadd22 = new Address__c(name='test street22',Account__c=a.Id,EBSAddressID__c = '1',Type__c = 'Ship to');
        insert sadd22;
        Address__c sadd23 = new Address__c(name='test street23',Account__c=a.Id,EBSAddressID__c = '1',Type__c = 'Ship to');
        insert sadd23;
        Address__c sadd24 = new Address__c(name='test street24',Account__c=a.Id,EBSAddressID__c = '1',Type__c = 'Ship to');
        insert sadd24;
        Address__c sadd25 = new Address__c(name='test street25',Account__c=a.Id,EBSAddressID__c = '1',Type__c = 'Ship to');
        insert sadd25;        
  
        Apexpages.currentPage().getParameters().put('accountid',a.Id);
        Apexpages.currentPage().getParameters().put('accountname',a.Name);
        Apexpages.currentPage().getParameters().put('txt','ship');
        Apexpages.currentPage().getParameters().put('lksrch','');
        AddressLookupController AddressLookup= new AddressLookupController();    
        AddressLookup.addressCity = 'test';
        AddressLookup.addressState = 'ga';
        AddressLookup.addressCountry = 'USA';
        AddressLookup.addressPostalcode = '30096';
        AddressLookup.addressEBSID = '1';
        AddressLookup.addressCompany = 'NTT';
        AddressLookup.search();
        }        

 @IsTest(SeeAllData=true) public static void testAddressLookupControllerSearchStr(){
        Account a = new Account(name = 'test');
        insert a;
        
        Address__c sadd = new Address__c(name='test street');
        sadd.Account__c = a.Id;
        sadd.Type__c = 'Ship to';
        sadd.City__c = 'test';
        sadd.State__c = 'ga';
        sadd.Country__c = 'United States';
        sadd.PostalCode__c = '30096';
        sadd.Default__c = true;
       //  sadd.End_Date__c = date.newinstance(2015,05,03);
        insert sadd;
 
        Apexpages.currentPage().getParameters().put('accountid',a.Id);
        Apexpages.currentPage().getParameters().put('accountname',a.Name);
        Apexpages.currentPage().getParameters().put('txt','Ship to');
        Apexpages.currentPage().getParameters().put('lksrch','');
        AddressLookupController AddressLookup= new AddressLookupController();    
        AddressLookup.searchString = 'United States';
        AddressLookup.runSearch();
        
        
        }
 
 @IsTest(SeeAllData=true) public static void testAddressLookupControllerSave(){
        Account a = new Account(name = 'test');
        insert a;
        
        Address__c sadd = new Address__c(name='test street');
        sadd.Account__c = a.Id;
        sadd.Type__c = 'Ship to';
        sadd.City__c = 'test';
        sadd.State__c = 'ga';
        sadd.Country__c = 'USA';
        sadd.PostalCode__c = '30096';
        sadd.Default__c = true;
        //sadd.End_Date__c = date.newinstance(2015,05,03);
        insert sadd;
     
        Apexpages.currentPage().getParameters().put('accountid',a.Id);
        Apexpages.currentPage().getParameters().put('accountname',a.Name);
        Apexpages.currentPage().getParameters().put('txt','Ship');
        Apexpages.currentPage().getParameters().put('lksrch','test');
        AddressLookupController AddressLookup= new AddressLookupController();    
        AddressLookup.addressCity = 'test';
        AddressLookup.addressState = 'ga';
        AddressLookup.addressCountry = 'USA';
        AddressLookup.addressPostalcode = '30096';
        AddressLookup.saveAddress();
        }
 
 @IsTest(SeeAllData=true) public static void testAddressLookupControllerMethods(){
 
        Apexpages.currentPage().getParameters().put('accountid','');
        Apexpages.currentPage().getParameters().put('accountname','');
        Apexpages.currentPage().getParameters().put('txt','Ship');
        Apexpages.currentPage().getParameters().put('lksrch','');
        AddressLookupController AddressLookup= new AddressLookupController();    
        AddressLookup.getFormTag();
        AddressLookup.getTextBox();
        //AddressLookup.addressEndDate = string.valueof(date.newinstance(2015,05,03));
    
        }
 
@IsTest(SeeAllData=true) public static void testAddressLookupControllerAcctErr(){
    
        Apexpages.currentPage().getParameters().put('accountid','');
        Apexpages.currentPage().getParameters().put('accountname','');
        Apexpages.currentPage().getParameters().put('txt','ship');
        Apexpages.currentPage().getParameters().put('lksrch','');
        AddressLookupController AddressLookup= new AddressLookupController();    
    
        }
}