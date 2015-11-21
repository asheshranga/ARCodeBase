@IsTest
public class NbncoSLAReportableAnalysisTest
{
    public static void setNBNCoKeyvalueStore() 
    {  
        ViasattestUtility.setNBNCoKeyvalueStore();
    }
    
    static testmethod void NbncoSLAReportableAnalysisTest()
    {
        ViasattestUtility.setNBNCoKeyvalueStore();
        
        list<Account> accounts = ViasatTestUtility.createAccounts(1, 'NBNCo');
        insert accounts; 
        list<Contact> contacts = ViasatTestUtility.createContacts(accounts, 2);
        insert contacts; 
        
        integer numOfObjsPerAccounts = 7; 
        list<SLA__c> slas = ViasatTestUtility.createSLAObjs(accounts, numOfObjsPerAccounts);
        insert slas;
        
        User newUser = ViasatTestUtility.createUser(null, 'Engineering Support Services');
        insert newUser;
        
        List<Case> Lstcase = ViasatTestUtility.createCases(accounts, contacts, 'Support Services NBN Co');   
        Lstcase[0].ownerid=newUser.id; 
        Lstcase[0].Location__c='Test';  
        Lstcase[0].NBNCoPrioritybasedonType__c='1 - Critical'; 
        Lstcase[0].SLAReportable__c=true;   // FIELD_CUSTOM_VALIDATION_EXCEPTION, SLA values are missing
        Lstcase[0].NotSLAReportableReason__c=''; 
        
        Lstcase[1].ownerid=newUser.id; 
        Lstcase[1].Location__c='Test';          
        Lstcase[1].SLAReportable__c=false;
        Lstcase[1].NotSLAReportableReason__c='';
        insert Lstcase;  
        
        Test.startTest();           
        NbncoSLAReportableAnalysis controller=new NbncoSLAReportableAnalysis();   
        PageReference NbncoSLAReportable= Page.NBNCoSLAReportable;
        Test.setCurrentPage(NBNCoSLAReportable);
        
        controller.caseNumber='CaseNumber';        
        controller.ownerName=Lstcase[0].ownerid;   
        controller.SelectedCaseId=Lstcase[0].id;       
        controller.SLAflagChecked=true;
        
        controller.caseObj.Subject=Lstcase[0].Subject;
        controller.caseObj.Description=Lstcase[0].Description;
        controller.caseObj.SubSystem__c=Lstcase[0].SubSystem__c;
        controller.caseObj.OtherReason__c='Other Reason';
        controller.caseObj.Location__c=Lstcase[0].Location__c;
        controller.caseObj.NBNCoPrioritybasedonType__c=Lstcase[0].PrioritybasedonType__c;
        controller.caseObj.NBNStatus__c=Lstcase[0].status;
        controller.caseObj.NotSLAReportableReason__c=Lstcase[0].NotSLAReportableReason__c;
        controller.caseObj.DateActionIdentified__c=date.valueof(System.now());
        controller.runSearch();
        controller.sortField='CaseNumber';
        controller.toggleSort();
        controller.toggleSort();
        controller.SLAReportableReason();                                         
        
        controller.next();
        controller.previous();
        controller.last();
        controller.first();
        controller.SLAReasonChecked();              
        controller.clearSearch();   
        controller.saveCase();  
        Boolean Next = controller.hasNext;
        Boolean Prev = controller.hasPrev;
        String record = controller.recordInfo;
        String info = controller.pageInfo;
        Integer n = controller.resultSize;
        List<Case> cc = controller.getCases();
        Test.stopTest();           
    }          
}