/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an organization are executed whenever Apex code is deployed
 * to a production organization to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production organization. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the organization size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
@isTest
private class OppPusherTests {
 private static sObject[] OpptyList; 
 private static List<Opportunity> testOpptys = new List<Opportunity>();

    static testMethod void myOppUnitTest() {
        // TO DO: implement unit test
        // create an oppty
        Opportunity oTestOppty=createOppty('testOppty');
        // change the month pushcount+1
        oTestOppty.CloseDate=date.newinstance(2015,12,11);
        //Opportunity oTestUpdateOppty=[select Id from Opportunities where Id=oTestOppty.Id]
        update oTestOppty;
        Opportunity oReadOppty=[select Id,PushCount__c from Opportunity where id=:oTestOppty.Id];
        System.debug(oReadOppty.PushCount__c);
        System.assert(oReadOppty.PushCount__c==1);
        // make it later this month, no change
        oTestOppty.CloseDate=date.newinstance(2015,12,31);
        update oTestOppty;
        oReadOppty=[select Id,PushCount__c from Opportunity where id=:oTestOppty.Id];
        System.debug(oReadOppty.PushCount__c);
        System.assert(oReadOppty.PushCount__c==1);
        // make it next year, but an earlier month, pushcount+1
        oTestOppty.CloseDate=date.newInstance(2016, 1,1);
        update oTestOppty;
        oReadOppty=[select Id,PushCount__c from Opportunity where id=:oTestOppty.Id];
        System.debug(oReadOppty.PushCount__c);
        System.assertEquals(oReadOppty.PushCount__c, 2);
        // don't change the date, no change
        oTestOppty.CloseDate=date.newInstance(2016,1,1);
        update oTestOppty;
       oReadOppty=[select Id,PushCount__c from Opportunity where id=:oTestOppty.Id];
        System.debug(oReadOppty.PushCount__c);
        System.assertEquals(oReadOppty.PushCount__c,2);
        
        // test bulk update
        integer i;
        for(i=1;i<199;i++){
            
        }
        
        //clean up
        cleanOpptys();
    }
    
    private static Opportunity createOppty(String sOppName) {
        Opportunity oNewOpp= new Opportunity(name= sOppName,closedate= date.newinstance(2015,11,11),stagename='Prospecting');
    //  List<Opportunity> testLocalOpptys = new List<Opportunity>();
    //  testLocalOpptys=(List<Opportunity>)OpptyList;
    //  testLocalOpptys.add(oNewOpp);
    //  OpptyList=testLocalOpptys;
    insert oNewOpp;
        testOpptys.add(oNewOpp);
        return oNewOpp;
    }
    
    
    private static void cleanOpptys() {
        for(Opportunity oIterator : testOpptys) {
            delete oIterator;
            
        }
        testOpptys.clear();
    }
    
    
}