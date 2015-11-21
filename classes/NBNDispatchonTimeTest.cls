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
 @IsTest
public class NBNDispatchonTimeTest
{
    static testmethod void NBNDispatchonTimeTest()
    {
    	NbncoSLAReportableAnalysisTest.setNBNCoKeyvalueStore();
    	
		Map<String,NBNCoKeyvalueStore__c> MapKeyValue= NBNCoKeyvalueStore__c.getAll();

        List<Account> accounts = ViasatTestUtility.createAccounts(1, 'NBNCo');
        insert accounts; 
        Account acc1 = accounts[0]; 
        
        List<Contact> contacts = ViasatTestUtility.createContacts(accounts, 1);
        insert contacts; 
        Contact con = contacts[0]; 
 
		integer numOfObjsPerAccounts = 7; 
        List<SLA__c> listSLA = ViasatTestUtility.createSLAObjs(accounts, numOfObjsPerAccounts);
        insert listSLA;    
        
        List<Case> cases = ViasatTestUtility.createCases(accounts, contacts, 'Support Services NBN Co');                       
        insert cases;   
       
        Case cc = cases[0];
        
        Case caseInput = KBSOQLHelper.caseQuery(cc.Id); 
        
        Test.startTest();  
        
        System.assertNotEquals(caseInput,null);
        
        // set the test's page to NBNRMARequested VF page   
        Test.setCurrentPage(Page.NBNRMARequested); 

        ApexPages.currentPage().getParameters().put('Id',cc.Id);
        
        // call the constructor  
        NBNDispatchonTime cntrDispatchonTime = new NBNDispatchonTime(new ApexPages.StandardController(cc));
        
        // call properties
        boolean bRet = cntrDispatchonTime.AllowRMARequest;
        
        // call methods
        PageReference pref = cntrDispatchonTime.saveCaseRMA();

        cntrDispatchonTime.caseInput.AvailableonSite__c = 'Yes';
        cntrDispatchonTime.caseInput.DispatchMethod__c = MapKeyValue.get('ViaSat TEST Dispatch Method').Value__c;
        cntrDispatchonTime.DispatchMethod();    
        cntrDispatchonTime.AvailableOnSite();   
        pref = cntrDispatchonTime.saveCaseRMA();
        System.assertEquals(pref, null);
        
        pRef = cntrDispatchonTime.close();
        
        cntrDispatchonTime.caseInput.AvailableonSite__c = 'No';
        cntrDispatchonTime.caseInput.DispatchMethod__c = null;
        cntrDispatchonTime.AvailableOnSite();   
        cntrDispatchonTime.DispatchMethod();    
        pref = cntrDispatchonTime.saveCaseRMA();
                
        cntrDispatchonTime.AvailableOnSite();                
        
        cntrDispatchonTime.caseInput.AvailableonSite__c = 'No';
        cntrDispatchonTime.caseInput.status ='Resolved';
        cntrDispatchonTime.caseInput.DeliveryDateTimeNotAvaiable__c = Null; 
        cntrDispatchonTime.AvailableOnSite();   
        cntrDispatchonTime.DispatchMethod();    
        pref = cntrDispatchonTime.saveCaseRMA();
        
        cntrDispatchonTime.caseInput.DeliveryDateTimeNotAvaiable__c = null;
        cntrDispatchonTime.caseInput.DispatchMethod__c = '';
        cntrDispatchonTime.AvailableOnSite();   
        cntrDispatchonTime.DispatchMethod();    
        pref = cntrDispatchonTime.saveCaseRMA();

        cntrDispatchonTime.caseInput.DeliveryDateTimeNotAvaiable__c = system.today();
        cntrDispatchonTime.caseInput.DispatchMethod__c = null;
        cntrDispatchonTime.AvailableOnSite();   
        cntrDispatchonTime.DispatchMethod();    
        pref = cntrDispatchonTime.saveCaseRMA();
            
        cntrDispatchonTime.caseInput.status ='New';
        cntrDispatchonTime.caseInput.DeliveryDateTimeNotAvaiable__c=system.today()+2;
        cntrDispatchonTime.AvailableOnSite();   
        cntrDispatchonTime.DispatchMethod();    
        pref = cntrDispatchonTime.saveCaseRMA();

        cntrDispatchonTime.caseInput.DispatchMethod__c = 'ViaSat TEST Dispatch Method';
        cntrDispatchonTime.DispatchMethod();    
        System.assertNotEquals(cntrDispatchonTime.caseInput.DispatchMethodDetails__c,'');   

        cntrDispatchonTime.AvailableOnSite();   
        cntrDispatchonTime.DispatchMethod();    
        pref = cntrDispatchonTime.saveCaseRMA();

        // Validate that RMA Requested
        Case newCaseInput = KBSOQLHelper.caseQuery(cc.Id);
        cntrDispatchonTime.doSendEmail();
        System.assertEquals(newCaseInput.Status,'New');
                  
		// Test ViasatUtilityClass
		DateTime dt = DateTime.newinstance(2014, 1, 1, 1, 1, 1);
		List<Holiday> holidays = [SELECT Id, Name, ActivityDate FROM Holiday];	
		integer i = ViasatUtilityClass.getNumOfDaysToNextWorkDay(dt, holidays);
		
		DateTime dt2 = ViasatUtilityClass.getWorkDay(dt, holidays);
		
		dt = DateTime.newinstance(2014, 12, 25, 1, 1, 1);
		dt2 = ViasatUtilityClass.getWorkDay(dt, holidays);
		
        Test.stopTest();               
    }
 }