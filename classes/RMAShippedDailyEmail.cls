global class RMAShippedDailyEmail implements Schedulable {

List<OrderLine__c> olList = new List<OrderLine__c>();
list<order__c>orderlist=new list<order__c>();
set<id>orderid= new set<id>();
set<id> orderset=new set<id>();
global void execute (SchedulableContext SC) {
    sendEmail();
}

public void sendEmail() {
    List<Messaging.SingleEmailMessage>  myEmails = new List<Messaging.SingleEmailMessage>();
    dateTime todaysDate = system.now();    
    dateTime yesterdaysDate = todaysDate.addDays(-1);
    //system.debug('yesterday*****'+yesterdaysDate );
    system.debug('today*********'+todaysDate);
    //datetime yesterdaysDate = todaysDate.addMinutes(-5); 
    system.debug('yesterday*****'+yesterdaysDate );   
    
      
     for (orderline__c ol: [select Name, SerialNo__c, order__r.id , order__r.requestor_email__c, order__r.requestor__c from orderline__c 
                                where Shipped_Email_Sent__c = False and Actual_Ship_DateTime__c > :yesterdaysDate 
                                and Actual_Ship_DateTime__c <:todaysDate])
        {  
            olList.add(ol);
            orderid.add(ol.order__c);
            System.debug('Order with Shipment: ' + olList);
        }   
     
    System.debug('Order List: ' + olList.size());
     
    orderlist=[select id,requestor__c from order__c where id in :orderid];                                     
    if (orderlist!= null) {
        for (order__c o: orderlist) {
        myEmails.clear();
        system.debug('count***********'+o.id);
                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                mail.setTemplateId(System.label.RMADailyShippedEmailTemplate);
                mail.setwhatid(o.id);
                System.debug('Order id =' + o.id);
                mail.setTargetObjectId(o.requestor__c);
                mail.setOrgWideEmailAddressId(System.label.RMAReplyToAddressID);
                String CCList = System.label.RMAEmailCCList;
                String[] toCC = new String[] {};
                toCC = CCList.split(',');
                mail.setCCAddresses(toCC);
               
                mail.SaveAsActivity = false;
                myEmails.add(mail);         
      
            
            try {       
                Messaging.sendEmail(myEmails);
                orderset.add(o.id);
                      } catch (DMLException e) {
                System.debug('Error sending email - Error: ' + e.getDMLMessage(0));
                return;
            } catch (exception e1) {
                System.debug('Error sending email - Error: ' + e1.getMessage());
                return;
            }   
        } 
       for(orderline__c o :[select id from orderline__c where order__c in:orderset and Shipped_Email_Sent__c = False and Actual_Ship_DateTime__c > :yesterdaysDate 
                                and Actual_Ship_DateTime__c <:todaysDate])  
       {
             o.Shipped_Email_Sent__c = True;
             update o;           
       }
    }
    }
    
}