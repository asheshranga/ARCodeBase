/*
    Controller for the everyday tools component.
    Extracts and displays the everyday articles
        
    **********************************************************
    Audit History
    **********************************************************
    4/13/2013    Lucian Ciobanu      Created
    **********************************************************  
*/
public with sharing class KBHomeEverydayTools {

    /*public boolean inConsole { get; set; }

    // Everyday Tools
    public List<KnowledgeArticleVersion> everyDayArticles { get; set; }

    public KBHomeEverydayTools() {
        
        inConsole = false;
        if (!String.isEmpty(ApexPages.currentPage().getParameters().get('isdtp')))
            inConsole = true;
            
        // Extract the limit from custom setting
        integer settingsLimit = KeyValueStoreHelper.getIntegerValue('EverydayToolsLimit');
        
        // Extract the articles
        everyDayArticles = [SELECT Id, Title FROM KnowledgeArticleVersion WHERE PublishStatus = 'Online' AND Language = 'en_US' WITH DATA CATEGORY Care_Categories__c AT Everyday_Tools__c LIMIT :settingsLimit];

    }
    
    @IsTest public static void test1() {
        KeyValueStore__c settings = new KeyValueStore__c(Name = 'EverydayToolsLimit', Application__c = 'KBInternal', IntegerValue__c = 2, Description__c = 'desc');
        insert settings;
        KBHomeEverydayTools controller = new KBHomeEverydayTools();
    }*/
}