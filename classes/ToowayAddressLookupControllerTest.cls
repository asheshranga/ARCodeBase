//Test Method for the Apex Class ToowayAddressLookupController 

@IsTest(SeeAllData=true) public class ToowayAddressLookupControllerTest {
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
        ToowayAddressLookupController ToowayAddressLookup = new ToowayAddressLookupController();    
    
        }

 @IsTest(SeeAllData=true) public static void testToowayAddressLookupControllerBillTo(){
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
        ToowayAddressLookupController ToowayAddressLookup= new ToowayAddressLookupController();    
    
        }
 
 @IsTest(SeeAllData=true) public static void testToowayAddressLookupControllerSearch(){
        Account a = new Account(name = 'test');
        insert a;
        
        Address__c sadd = new Address__c(name='test street');
        sadd.Account__c = a.Id;
        sadd.Type__c = 'Ship to';
        sadd.City__c = 'test';
        sadd.State__c = 'ga';
        sadd.Country__c = 'USA';
        sadd.PostalCode__c = '30096';
        sadd.VAT__c = 'GB107995930';
        sadd.Default__c = true;
       //  sadd.End_Date__c = date.newinstance(2015,05,03);
        insert sadd;
  
        Apexpages.currentPage().getParameters().put('accountid',a.Id);
        Apexpages.currentPage().getParameters().put('accountname',a.Name);
        Apexpages.currentPage().getParameters().put('txt','ship');
        Apexpages.currentPage().getParameters().put('lksrch','');
        ToowayAddressLookupController ToowayAddressLookup= new ToowayAddressLookupController();    
        ToowayAddressLookup.addressCity = 'test';
        ToowayAddressLookup.addressState = 'ga';
        ToowayAddressLookup.addressCountry = 'USA';
        ToowayAddressLookup.addressPostalcode = '30096';
        ToowayAddressLookup.addressVAT = 'GB107995930';
        ToowayAddressLookup.search();
        }

 @IsTest(SeeAllData=true) public static void testToowayAddressLookupControllerSearchStr(){
        Account a = new Account(name = 'test');
        insert a;
        
        Address__c sadd = new Address__c(name='test street');
        sadd.Account__c = a.Id;
        sadd.Type__c = 'Ship to';
        sadd.City__c = 'test';
        sadd.State__c = 'ga';
        sadd.Country__c = 'USA';
        sadd.PostalCode__c = '30096';
        sadd.VAT__c = 'GB107995930';
        sadd.Default__c = true;
       //  sadd.End_Date__c = date.newinstance(2015,05,03);
        insert sadd;
 
        Apexpages.currentPage().getParameters().put('accountid',a.Id);
        Apexpages.currentPage().getParameters().put('accountname',a.Name);
        Apexpages.currentPage().getParameters().put('txt','Ship to');
        Apexpages.currentPage().getParameters().put('lksrch','');
        ToowayAddressLookupController ToowayAddressLookup= new ToowayAddressLookupController();    
        ToowayAddressLookup.searchString = 'test';
        ToowayAddressLookup.runSearch();
        
        
        }
 
 @IsTest(SeeAllData=true) public static void testToowayAddressLookupControllerSave(){
        Account a = new Account(name = 'test');
        insert a;
        
        Address__c sadd = new Address__c(name='test street');
        sadd.Account__c = a.Id;
        sadd.Type__c = 'Ship to';
        sadd.City__c = 'test';
        sadd.State__c = 'ga';
        sadd.Country__c = 'USA';
        sadd.PostalCode__c = '30096';
        sadd.VAT__c = 'GB107995930';
        sadd.Default__c = true;
        //sadd.End_Date__c = date.newinstance(2015,05,03);
        insert sadd;
     
        Apexpages.currentPage().getParameters().put('accountid',a.Id);
        Apexpages.currentPage().getParameters().put('accountname',a.Name);
        Apexpages.currentPage().getParameters().put('txt','Ship');
        Apexpages.currentPage().getParameters().put('lksrch','test');
        ToowayAddressLookupController ToowayAddressLookup= new ToowayAddressLookupController();    
        ToowayAddressLookup.addressCity = 'test';
        ToowayAddressLookup.addressState = 'ga';
        ToowayAddressLookup.addressCountry = 'USA';
        ToowayAddressLookup.addressPostalcode = '30096';
        ToowayAddressLookup.addressVAT = 'GB107995930';
//        ToowayAddressLookup.addressEndDate = string.valueof(date.newinstance(2015,05,03));
        ToowayAddressLookup.runSearch();
        }
 
 @IsTest(SeeAllData=true) public static void testToowayAddressLookupControllerMethods(){
 
        Apexpages.currentPage().getParameters().put('accountid','');
        Apexpages.currentPage().getParameters().put('accountname','');
        Apexpages.currentPage().getParameters().put('txt','Ship');
        Apexpages.currentPage().getParameters().put('lksrch','');
        ToowayAddressLookupController ToowayAddressLookup= new ToowayAddressLookupController();    
        ToowayAddressLookup.getFormTag();
        ToowayAddressLookup.getTextBox();
        ToowayAddressLookup.addressEndDate = string.valueof(date.newinstance(2015,05,03));
    
        }
 
@IsTest(SeeAllData=true) public static void testAddressLookupControllerAcctErr(){
    
        Apexpages.currentPage().getParameters().put('accountid','');
        Apexpages.currentPage().getParameters().put('accountname','');
        Apexpages.currentPage().getParameters().put('txt','ship');
        Apexpages.currentPage().getParameters().put('lksrch','');
        ToowayAddressLookupController ToowayAddressLookup= new ToowayAddressLookupController();    
    
        }
}