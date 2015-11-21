// this is the test class for RMAShippedDailyEmail

@IsTest
public class RMAShippedDailyEmailSchedulableTest {

public static testmethod void testRMAShippedDailyEmail() {  
     
        Integer numOfObjs = 1;
        List<Account> accounts = ViasatTestUtility.createAccounts(numOfObjs, 'test');
        insert accounts;
        List<Contact> contacts = ViasatTestUtility.createContacts(accounts, numOfObjs);
        insert contacts;      

        Account acc = accounts[0];
		Contact con = contacts[0];
            
            Product2 pdt = new Product2();
            pdt.CurrencyIsoCode = 'USD';
            pdt.Name='123';
            pdt.Product_Category__c='Antenna';
            insert pdt;  
            
            Address__c sadd = new Address__c(name='test street');
            sadd.Account__c = acc.Id;
            sadd.Type__c = 'Ship to';
            sadd.Default__c = true;
            insert sadd;
            
            Address__c badd = new Address__c(name='test street');
            badd.Account__c = acc.Id;
            badd.Type__c = 'Bill to';
            badd.Default__c = true;
            insert badd;
                
            Order__c order=new Order__c();              
            order.Account__c=acc.id;
            order.Requestor__c= con.id;
            order.PartialShipment__c = 'yes';
            order.FAA81303Required__c = 'yes';
            order.ComSecDoDAACRequirement__c = 'yes';
            order.AgreetoRMAReturnConditions__c = true;
            order.AgreetoTermsConditions__c = true;
            //order.Drop_Shipment__c = true;
            order.BillToAddress__c = badd.id;
            //order.Drop_Shipment__c = false;
            order.ShipToAddress__c = sadd.id;
            insert order;
            
            orderline__c ol=new orderline__c();
            ol.SerialNo__c = 'ABc';
            ol.Shipped_Email_Sent__c = false;
            ol.PartNumber__c=pdt.id;
            ol.Actual_Ship_DateTime__c = system.now();
            ol.Order__c=order.id; 
            dateTime todaysDate = system.now();             
            ol.Actual_Ship_DateTime__c = todaysDate.addHours(-1) ;
            insert ol;   
            
            RMAShippedDailyEmail controller = new RMAShippedDailyEmail();
            controller.sendEmail();  
            String schedule = '0 0 22 * * ?'; 
            system.schedule('MySchedule', schedule, controller);       
          }  
              
         }