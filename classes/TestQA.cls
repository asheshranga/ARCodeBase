public class TestQA {

    public List<PassengerCareFAQ_VA__kav> lstExede{get;set;}
    public TestQA (){    
        lstExede = [select Id,Title,Answer__c,Question__c from PassengerCareFAQ_VA__kav where language = 'en_US' and publishstatus = 'Online'];
    }    
}