@isTest
private class ManageQueuesControllerTest {
    
    static testMethod void manageQueuesControllerTest() 
    {
        CaseKeyValueStore__c profile = new CaseKeyValueStore__c();
        profile.name = ManageQueuesController.ITSMS_QUEUE_REPORT_PROFILES;
        profile.Value__c = 'ITSMS Manager;ITSMS Technician';
        insert profile;

        CaseKeyValueStore__c fileName = new CaseKeyValueStore__c();
        fileName.name = ManageQueuesController.ITSMS_QUEUE_REPORT_FILE_NAME;
        fileName.Value__c = 'QueueRoleReport.xls';
        insert fileName;
        Test.startTest();
        
        ManageQueuesController controller = new ManageQueuesController();
        System.assert(controller.groupingType != null);
        System.assert(!controller.mapOfQueueIdToUsers.isEmpty());
        System.assert(!controller.mapOfRoleIdToMembers.isEmpty());
        controller.setGrouping();
        controller.exportToExcel();
        System.assert(!String.isBlank(controller.contentType));
        Test.stopTest();
        
    }
    
}