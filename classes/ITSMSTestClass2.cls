/*
 * Class ITSMSTestClass
 * 
 * @version 1.0
 * @author  Dianna Guilinger - Slalom  
 *
 *  Usage: includes methods for all testing 
 */
@isTest
private class ITSMSTestClass2 {
    // coverage for ITSMSRequestHeaderComponentController 
    static testMethod void testRequestHeaderComp() {          
        ITSMSTestDataSetup.createTestConstants();
        // create test data - requestor, requestedFor, delegates
        ITSMSTestDataSetup.createRequestor();
        User communityUser = [select Id,  Delegate__c from User where FirstName = 'Community'];
        system.runAs (communityUser)
        {
            //*** start test
            Test.startTest();
            PageReference pageRef= Page.ITSMSSupportRequest;
            Test.setCurrentPage(pageRef);
            ITSMSRequestHeaderComponentController ccc = new ITSMSRequestHeaderComponentController();
            //-- verify controller
            ccc.pageController = new ITSMSPageControllerBase ();
            ccc.key = 'testing';
            ccc.componentToPage = new ITSMSComponentToController ();
            ccc.caseRec = ITSMSUtilityClass.createCase('Access','Folder/Share');
        }           
     }

    // coverage for ITSMSServerComponentController 
    static testMethod void testServerSave() {          
        ITSMSTestDataSetup.createTestConstants();
        // create test data - requestor, requestedFor, delegates
        ITSMSTestDataSetup.createRequestor();
        User communityUser = [select Id,  Delegate__c from User where FirstName = 'Community'];
        system.runAs (communityUser)
        {
            //*** start test
            Test.startTest();
            PageReference pageRef= Page.ITSMSSupportRequest;
            Test.setCurrentPage(pageRef);
            ITSMSServerComponentController ccc = new ITSMSServerComponentController();
            //-- verify controller
            ccc.caseRec = ITSMSUtilityClass.createCase('Server','Server/VM');
            ccc.pageController = new ITSMSPageControllerBase ();
            ccc.key = 'testing';
            ccc.componentToPage = new ITSMSComponentToController ();
            ccc.caseRec.IssueOrRequest__c = 'Request';
            ccc.caseRec.ManagerUser__c = communityUser.Delegate__c;
            ccc.caseRec.Date_Needed_By__c = system.today();
            ccc.caseRec.EquipmentLocation__c = 'Testing';
            ccc.caseRec.CostCenterNumber__c = 'Testing';
            ccc.caseRec.BriefDescription__c = 'Testing';
            ccc.caseRec.JustificationRequest__c = 'Testing';
            ccc.caseRec.ServerProject__c  = 'Testing';
            ccc.caseRec.ServerLocation__c  = 'Testing';
            ccc.caseRec.RequestingOrg__c  = 'Testing';
            ccc.caseRec.ApprovingDirector__c  = 'Testing';
            ccc.caseRec.CustomerUse__c  = 'Testing';
            ccc.caseRec.EquipmentClass__c  = 'Testing';
            ccc.caseRec.ServerOperatingSystem__c  = 'Testing';
            ccc.caseRec.StorageRequirements__c  = 'Testing';
            ccc.caseRec.ServerCPU__c  = 'Testing';
            ccc.caseRec.PartNumber__c  = 'Testing';
            ccc.caseRec.ServerMemory__c  = 'Testing';
            ccc.caseRec.PartQuantity__c  = 'Testing';
            ccc.saveOnly();
            list<Case> testCases = [Select Id, Subject, Status, ParentId from Case];
            system.debug('@@ after save:'+testCases);
            // verify 2 cases created and status is 'Pending Submission'
            system.assertEquals(testCases.size(),2);
            system.assertEquals(testCases[0].Status,'Pending Submission');
            system.assertEquals(testCases[1].Status,'Pending Submission');
            ccc.caseRec.IssueOrRequest__c = 'Request';
            ccc.caseRec.ManagerUser__c = communityUser.Delegate__c;
            ccc.caseRec.Date_Needed_By__c = system.today();
            ccc.caseRec.EquipmentLocation__c = 'Testing';
            ccc.caseRec.CostCenterNumber__c = 'Testing';
            ccc.caseRec.BriefDescription__c = 'Testing';
            ccc.caseRec.JustificationRequest__c = 'Testing';
            ccc.caseRec.ServerProject__c  = 'Testing';
            ccc.caseRec.ServerLocation__c  = 'Testing';
            ccc.caseRec.RequestingOrg__c  = 'Testing';
            ccc.caseRec.ApprovingDirector__c  = 'Testing';
            ccc.caseRec.CustomerUse__c  = 'Testing';
            ccc.caseRec.EquipmentClass__c  = 'Testing';
            ccc.caseRec.ServerOperatingSystem__c  = 'Testing';
            ccc.caseRec.StorageRequirements__c  = 'Testing';
            ccc.caseRec.ServerCPU__c  = 'Testing';
            ccc.caseRec.PartNumber__c  = 'Testing';
            ccc.caseRec.ServerMemory__c  = 'Testing';
            ccc.caseRec.PartQuantity__c  = 'Testing';
            ccc.saveAndNew();
            ccc.cancelCase();
            testCases = [Select Id, Subject, Status, ParentId from Case];
            system.debug('@@ after cancel:'+testCases);
        }           
     }

    // coverage for ITSMSServerComponentController 
    static testMethod void testServerSubmit() {          
        ITSMSTestDataSetup.createTestConstants();
        // create test data - requestor, requestedFor, delegates
        ITSMSTestDataSetup.createRequestor();
        User communityUser = [select Id,  Delegate__c from User where FirstName = 'Community'];
        system.runAs (communityUser)
        {
            //*** start test
            Test.startTest();
            PageReference pageRef= Page.ITSMSSupportRequest;
            Test.setCurrentPage(pageRef);
            ITSMSServerComponentController ccc = new ITSMSServerComponentController();
            //-- verify controller
            ccc.caseRec = ITSMSUtilityClass.createCase('Server','Server/VM');
            ccc.pageController = new ITSMSPageControllerBase ();
            ccc.key = 'testing';
            ccc.componentToPage = new ITSMSComponentToController ();
            ccc.caseRec.IssueOrRequest__c = 'Request';
            ccc.caseRec.Date_Needed_By__c = system.today();
            ccc.caseRec.EquipmentLocation__c = 'Testing';
            ccc.caseRec.CostCenterNumber__c = 'Testing';
            ccc.caseRec.BriefDescription__c = 'Testing';
            ccc.caseRec.JustificationRequest__c = 'Testing';
            ccc.caseRec.ServerProject__c  = 'Testing';
            ccc.caseRec.ServerLocation__c  = 'Testing';
            ccc.caseRec.RequestingOrg__c  = 'Testing';
            ccc.caseRec.ApprovingDirector__c  = 'Testing';
            ccc.caseRec.CustomerUse__c  = 'Testing';
            ccc.caseRec.EquipmentClass__c  = 'Testing';
            ccc.caseRec.ServerOperatingSystem__c  = 'Testing';
            ccc.caseRec.StorageRequirements__c  = 'Testing';
            ccc.caseRec.ServerCPU__c  = 'Testing';
            ccc.caseRec.PartNumber__c  = 'Testing';
            ccc.caseRec.ServerMemory__c  = 'Testing';
            ccc.caseRec.PartQuantity__c  = 'Testing';
            ccc.saveOnly();
            ccc.saveAndSubmit();
            String sysadmProfileId = [Select Id from Profile WHERE Name = 'System Administrator'].Id;
            User sysAdmin = [Select Id from User where ProfileId = :sysadmProfileId and IsActive = true limit 1];
            system.runAs (sysAdmin) 
            {
                list<Case> testCases = [Select Id, Subject, Status, ParentId, ownerId from Case];
                system.debug('@@ after submit:'+testCases);
                // verify 2 cases created, parent is closed, child is new
                system.assertEquals(testCases.size(),2);
                for (Case c:testCases)
                {
                    if (c.Subject == 'Support Parent')
                        system.assertEquals(c.Status,'Closed');
                    if (c.Subject != 'Support Parent')
                        system.assertEquals(c.Status,'New');
                }
            }
        }           
     }

    // coverage for ITSMSServiceAccountComponentController 
    static testMethod void testServiceAccountSave() {          
        ITSMSTestDataSetup.createTestConstants();
        // create test data - requestor, requestedFor, delegates
        ITSMSTestDataSetup.createRequestor();
        User communityUser = [select Id,  Delegate__c from User where FirstName = 'Community'];
        system.runAs (communityUser)
        {
            //*** start test
            Test.startTest();
            PageReference pageRef= Page.ITSMSSupportRequest;
            Test.setCurrentPage(pageRef);
            ITSMSServiceAccountComponentController ccc = new ITSMSServiceAccountComponentController();
            //-- verify controller
            ccc.caseRec = ITSMSUtilityClass.createCase('Access','Service Account');
            ccc.pageController = new ITSMSPageControllerBase ();
            ccc.key = 'testing';
            ccc.componentToPage = new ITSMSComponentToController ();
            ccc.caseRec.IssueOrRequest__c = 'Request';
            ccc.caseRec.ManagerUser__c = communityUser.Delegate__c;
            ccc.caseRec.JustificationRequest__c = 'Testing';
            ccc.caseRec.Environments__c  = 'Testing';
            ccc.caseRec.UsedFor__c  = 'Testing';
            ccc.caseRec.MailboxNeeded__c  = 'Testing';
            ccc.caseRec.ExpirationDate__c  = system.today();
            ccc.caseRec.AccountType__c  = 'Testing';
            ccc.caseRec.ServiceAccountName__c  = 'Testing';
            ccc.caseRec.AccessState__c  = 'New';
            ccc.saveOnly();
            list<Case> testCases = [Select Id, Subject, Status, ParentId from Case];
            system.debug('@@ after save:'+testCases);
            // verify 2 cases created and status is 'Pending Submission'
            system.assertEquals(testCases.size(),2);
            system.assertEquals(testCases[0].Status,'Pending Submission');
            system.assertEquals(testCases[1].Status,'Pending Submission');
            ccc.caseRec.IssueOrRequest__c = 'Request';
            ccc.caseRec.ManagerUser__c = communityUser.Delegate__c;
            ccc.caseRec.JustificationRequest__c = 'Testing';
            ccc.caseRec.Environments__c  = 'Testing';
            ccc.caseRec.UsedFor__c  = 'Testing';
            ccc.caseRec.MailboxNeeded__c  = 'Testing';
            ccc.caseRec.ExpirationDate__c  = system.today();
            ccc.caseRec.AccountType__c  = 'Testing';
            ccc.caseRec.ServiceAccountName__c  = 'Testing';
            ccc.caseRec.AccessState__c  = 'New';
            ccc.saveAndNew();
            ccc.cancelCase();
            testCases = [Select Id, Subject, Status, ParentId from Case];
            system.debug('@@ after cancel:'+testCases);
        }           
     }

    // coverage for ITSMSServiceAccountComponentController 
    static testMethod void testServiceAccountSubmit() {          
        ITSMSTestDataSetup.createTestConstants();
        // create test data - requestor, requestedFor, delegates
        ITSMSTestDataSetup.createRequestor();
        User communityUser = [select Id,  Delegate__c from User where FirstName = 'Community'];
        system.runAs (communityUser)
        {
            //*** start test
            Test.startTest();
            PageReference pageRef= Page.ITSMSSupportRequest;
            Test.setCurrentPage(pageRef);
            ITSMSServiceAccountComponentController ccc = new ITSMSServiceAccountComponentController();
            //-- verify controller
            ccc.caseRec = ITSMSUtilityClass.createCase('Access','Service Account');
            ccc.pageController = new ITSMSPageControllerBase ();
            ccc.key = 'testing';
            ccc.componentToPage = new ITSMSComponentToController ();
            ccc.caseRec.IssueOrRequest__c = 'Request';
            ccc.caseRec.ManagerUser__c = communityUser.Delegate__c;
            ccc.caseRec.JustificationRequest__c = 'Testing';
            ccc.caseRec.Environments__c  = 'Testing';
            ccc.caseRec.UsedFor__c  = 'Testing';
            ccc.caseRec.MailboxNeeded__c  = 'Testing';
            ccc.caseRec.ExpirationDate__c  = system.today();
            ccc.caseRec.AccountType__c  = 'Testing';
            ccc.caseRec.ServiceAccountName__c  = 'Testing';
            ccc.caseRec.AccessState__c  = 'Existing';
            ccc.saveOnly();
            ccc.saveAndSubmit();
            String sysadmProfileId = [Select Id from Profile WHERE Name = 'System Administrator'].Id;
            User sysAdmin = [Select Id from User where ProfileId = :sysadmProfileId and IsActive = true limit 1];
            system.runAs (sysAdmin) 
            {
                list<Case> testCases = [Select Id, Subject, Status, ParentId, ownerId from Case];
                system.debug('@@ after submit:'+testCases);
                // verify 2 cases created, parent is closed, child is new
                system.assertEquals(testCases.size(),2);
                for (Case c:testCases)
                {
                    if (c.Subject == 'Support Parent')
                        system.assertEquals(c.Status,'Closed');
                    if (c.Subject != 'Support Parent')
                        system.assertEquals(c.Status,'New');
                }
            }
        }           
     }

    // coverage for ITSMSSharedMailboxComponentController 
    static testMethod void testSharedMbxSave() {          
        ITSMSTestDataSetup.createTestConstants();
        // create test data - requestor, requestedFor, delegates
        ITSMSTestDataSetup.createRequestor();
        User communityUser = [select Id,  Delegate__c from User where FirstName = 'Community'];
        system.runAs (communityUser)
        {
            //*** start test
            Test.startTest();
            PageReference pageRef= Page.ITSMSSupportRequest;
            Test.setCurrentPage(pageRef);
            ITSMSSharedMailboxComponentController ccc = new ITSMSSharedMailboxComponentController();
            //-- verify controller
            ccc.caseRec = ITSMSUtilityClass.createCase('Access','Shared Mailbox');
            ccc.pageController = new ITSMSPageControllerBase ();
            ccc.key = 'testing';
            ccc.componentToPage = new ITSMSComponentToController ();
            ccc.caseRec.IssueOrRequest__c = 'Request';
            ccc.caseRec.ManagerUser__c = communityUser.Delegate__c;
            ccc.caseRec.JustificationRequest__c = 'Testing';
            ccc.caseRec.AvailableToOutsideUsers__c  = 'Testing';
            ccc.caseRec.EmailAddress__c   = 'Testing@test.com';
            ccc.caseRec.SharedMailboxName__c  = 'Testing';
            ccc.caseRec.AccessState__c  = 'Testing';
            ccc.saveOnly();
            list<Case> testCases = [Select Id, Subject, Status, ParentId from Case];
            system.debug('@@ after save:'+testCases);
            // verify 2 cases created and status is 'Pending Submission'
            system.assertEquals(testCases.size(),2);
            system.assertEquals(testCases[0].Status,'Pending Submission');
            system.assertEquals(testCases[1].Status,'Pending Submission');
            ccc.caseRec.IssueOrRequest__c = 'Request';
            ccc.caseRec.ManagerUser__c = communityUser.Delegate__c;
            ccc.caseRec.JustificationRequest__c = 'Testing';
            ccc.caseRec.AvailableToOutsideUsers__c  = 'Testing';
            ccc.caseRec.EmailAddress__c  = 'Testing@test.com';
            ccc.caseRec.SharedMailboxName__c  = 'Testing';
            ccc.caseRec.AccessState__c  = 'Testing';
            ccc.saveAndNew();
            ccc.cancelCase();
            testCases = [Select Id, Subject, Status, ParentId from Case];
            system.debug('@@ after cancel:'+testCases);
        }           
     }

    // coverage for ITSMSSharedMailboxComponentController 
    static testMethod void testSharedMbxSubmit() {          
        ITSMSTestDataSetup.createTestConstants();
        // create test data - requestor, requestedFor, delegates
        ITSMSTestDataSetup.createRequestor();
        User communityUser = [select Id,  Delegate__c from User where FirstName = 'Community'];
        system.runAs (communityUser)
        {
            //*** start test
            Test.startTest();
            PageReference pageRef= Page.ITSMSSupportRequest;
            Test.setCurrentPage(pageRef);
            ITSMSSharedMailboxComponentController ccc = new ITSMSSharedMailboxComponentController();
            //-- verify controller
            ccc.caseRec = ITSMSUtilityClass.createCase('Access','Shared Mailbox');
            ccc.pageController = new ITSMSPageControllerBase ();
            ccc.key = 'testing';
            ccc.componentToPage = new ITSMSComponentToController ();
            ccc.caseRec.IssueOrRequest__c = 'Request';
            ccc.caseRec.ManagerUser__c = communityUser.Delegate__c;
            ccc.caseRec.JustificationRequest__c = 'Testing';
            ccc.caseRec.AvailableToOutsideUsers__c  = 'Testing';
            ccc.caseRec.EmailAddress__c   = 'Testing@test.com';
            ccc.caseRec.SharedMailboxName__c  = 'Testing';
            ccc.caseRec.AccessState__c  = 'Testing';
            ccc.saveOnly();
            ccc.saveAndSubmit();
            String sysadmProfileId = [Select Id from Profile WHERE Name = 'System Administrator'].Id;
            User sysAdmin = [Select Id from User where ProfileId = :sysadmProfileId and IsActive = true limit 1];
            system.runAs (sysAdmin) 
            {
                list<Case> testCases = [Select Id, Subject, Status, ParentId, ownerId from Case];
                system.debug('@@ after submit:'+testCases);
                // verify 2 cases created, parent is closed, child is new
                system.assertEquals(testCases.size(),2);
                for (Case c:testCases)
                {
                    if (c.Subject == 'Support Parent')
                        system.assertEquals(c.Status,'Closed');
                    if (c.Subject != 'Support Parent')
                        system.assertEquals(c.Status,'New');
                }
            }
        }           
     }

    // coverage for ITSMSSharePointComponentController 
    static testMethod void testSharepointSave() {          
        ITSMSTestDataSetup.createTestConstants();
        // create test data - requestor, requestedFor, delegates
        ITSMSTestDataSetup.createRequestor();
        User communityUser = [select Id,  Delegate__c from User where FirstName = 'Community'];
        system.runAs (communityUser)
        {
            //*** start test
            Test.startTest();
            PageReference pageRef= Page.ITSMSSupportRequest;
            Test.setCurrentPage(pageRef);
            ITSMSSharePointComponentController ccc = new ITSMSSharePointComponentController();
            //-- verify controller
            ccc.caseRec = ITSMSUtilityClass.createCase('Access','Share Point');
            ccc.pageController = new ITSMSPageControllerBase ();
            ccc.key = 'testing';
            ccc.componentToPage = new ITSMSComponentToController ();
            ccc.caseRec.IssueOrRequest__c = 'Request';
            ccc.caseRec.ManagerUser__c = communityUser.Delegate__c;
            ccc.caseRec.JustificationRequest__c = 'Testing';
            ccc.caseRec.ActionTypeSharePoint__c  = 'Create account';
            ccc.caseRec.FirstName__c  = 'Testing';
            ccc.caseRec.LastName__c  = 'Testing';
            ccc.caseRec.CompanyEmail__c  = 'Testing@test.com';
            ccc.caseRec.LinkToSharePointSite__c  = 'Testing';
            ccc.caseRec.ProgramProjectName__c  = 'Testing';
            ccc.saveOnly();
            list<Case> testCases = [Select Id, Subject, Status, ParentId from Case];
            system.debug('@@ after save:'+testCases);
            // verify 2 cases created and status is 'Pending Submission'
            system.assertEquals(testCases.size(),2);
            system.assertEquals(testCases[0].Status,'Pending Submission');
            system.assertEquals(testCases[1].Status,'Pending Submission');
            ccc.caseRec.IssueOrRequest__c = 'Request';
            ccc.caseRec.ManagerUser__c = communityUser.Delegate__c;
            ccc.caseRec.JustificationRequest__c = 'Testing';
            ccc.caseRec.ActionTypeSharePoint__c  = 'Disable account';
            ccc.caseRec.FirstName__c  = 'Testing';
            ccc.caseRec.LastName__c  = 'Testing';
            ccc.caseRec.CompanyEmail__c  = 'Testing@test.com';
            ccc.caseRec.LinkToSharePointSite__c  = 'Testing';
            ccc.caseRec.ProgramProjectName__c  = 'Testing';
            ccc.saveAndNew();
            ccc.cancelCase();
            testCases = [Select Id, Subject, Status, ParentId from Case];
            system.debug('@@ after cancel:'+testCases);
        }           
     }

    // coverage for ITSMSSharePointComponentController 
    static testMethod void testSharepointSubmit() {          
        ITSMSTestDataSetup.createTestConstants();
        // create test data - requestor, requestedFor, delegates
        ITSMSTestDataSetup.createRequestor();
        User communityUser = [select Id,  Delegate__c from User where FirstName = 'Community'];
        system.runAs (communityUser)
        {
            //*** start test
            Test.startTest();
            PageReference pageRef= Page.ITSMSSupportRequest;
            Test.setCurrentPage(pageRef);
            ITSMSSharePointComponentController ccc = new ITSMSSharePointComponentController();
            //-- verify controller
            ccc.caseRec = ITSMSUtilityClass.createCase('Access','Share Point');
            ccc.pageController = new ITSMSPageControllerBase ();
            ccc.key = 'testing';
            ccc.componentToPage = new ITSMSComponentToController ();
            ccc.caseRec.IssueOrRequest__c = 'Request';
            ccc.caseRec.ManagerUser__c = communityUser.Delegate__c;
            ccc.caseRec.JustificationRequest__c = 'Testing';
            ccc.caseRec.ActionTypeSharePoint__c  = 'Modify Account';
            ccc.caseRec.FirstName__c  = 'Testing';
            ccc.caseRec.LastName__c  = 'Testing';
            ccc.caseRec.CompanyEmail__c  = 'Testing@test.com';
            ccc.caseRec.LinkToSharePointSite__c  = 'Testing';
            ccc.caseRec.ProgramProjectName__c  = 'Testing';
            ccc.saveOnly();
            ccc.saveAndSubmit();
            String sysadmProfileId = [Select Id from Profile WHERE Name = 'System Administrator'].Id;
            User sysAdmin = [Select Id from User where ProfileId = :sysadmProfileId and IsActive = true limit 1];
            system.runAs (sysAdmin) 
            {
                list<Case> testCases = [Select Id, Subject, Status, ParentId, ownerId from Case];
                system.debug('@@ after submit:'+testCases);
                // verify 2 cases created, parent is closed, child is new
                system.assertEquals(testCases.size(),2);
                for (Case c:testCases)
                {
                    if (c.Subject == 'Support Parent')
                        system.assertEquals(c.Status,'Closed');
                    if (c.Subject != 'Support Parent')
                        system.assertEquals(c.Status,'New');
                }
            }
        }           
     }

    // coverage for ITSMSSoftwareComponentController 
        static testMethod void testSoftwareSave() {          
        ITSMSTestDataSetup.createTestConstants();
        // create test data - requestor, requestedFor, delegates
        ITSMSTestDataSetup.createRequestor();
        User communityUser = [select Id,  Delegate__c from User where FirstName = 'Community'];
        system.runAs (communityUser)
        {
            //*** start test
            Test.startTest();
            PageReference pageRef= Page.ITSMSSupportRequest;
            Test.setCurrentPage(pageRef);
            ITSMSSoftwareComponentController ccc = new ITSMSSoftwareComponentController();
            //-- verify controller
            ccc.caseRec = ITSMSUtilityClass.createCase('Software','Software Request');
            ccc.pageController = new ITSMSPageControllerBase ();
            ccc.key = 'testing';
            ccc.componentToPage = new ITSMSComponentToController ();
            ccc.caseRec.IssueOrRequest__c = 'Request';
            ccc.caseRec.JustificationRequest__c = 'Testing';
            ccc.caseRec.SoftwareName__c  = 'Testing';
            ccc.caseRec.IsThisForGroup__c  = 'Testing';
            ccc.caseRec.ComputerNames__c  = 'Testing';
            ccc.saveOnly();
            list<Case> testCases = [Select Id, Subject, Status, ParentId from Case];
            system.debug('@@ after save:'+testCases);
            // verify 2 cases created and status is 'Pending Submission'
            system.assertEquals(testCases.size(),2);
            system.assertEquals(testCases[0].Status,'Pending Submission');
            system.assertEquals(testCases[1].Status,'Pending Submission');
            ccc.caseRec.IssueOrRequest__c = 'Request';
            ccc.caseRec.ManagerUser__c = communityUser.Delegate__c;
            ccc.caseRec.JustificationRequest__c = 'Testing';
            ccc.caseRec.SoftwareName__c  = 'Adobe Acrobat';
            ccc.caseRec.IsThisForGroup__c  = 'Testing';
            ccc.caseRec.ComputerNames__c  = 'Testing';
            ccc.saveAndNew();
            ccc.cancelCase();
            testCases = [Select Id, Subject, Status, ParentId from Case];
            system.debug('@@ after cancel:'+testCases);
        }           
     }

    // coverage for ITSMSSoftwareComponentController 
    static testMethod void testSoftwareSubmit() {          
        ITSMSTestDataSetup.createTestConstants();
        // create test data - requestor, requestedFor, delegates
        ITSMSTestDataSetup.createRequestor();
        User communityUser = [select Id,  Delegate__c from User where FirstName = 'Community'];
        system.runAs (communityUser)
        {
            //*** start test
            Test.startTest();
            PageReference pageRef= Page.ITSMSSupportRequest;
            Test.setCurrentPage(pageRef);
            ITSMSSoftwareComponentController ccc = new ITSMSSoftwareComponentController();
            //-- verify controller
            ccc.caseRec = ITSMSUtilityClass.createCase('Software','Software Request');
            ccc.pageController = new ITSMSPageControllerBase ();
            ccc.key = 'testing';
            ccc.componentToPage = new ITSMSComponentToController ();
            ccc.caseRec.IssueOrRequest__c = 'Request';
            ccc.caseRec.ManagerUser__c = communityUser.Delegate__c;
            ccc.caseRec.JustificationRequest__c = 'Testing';
            ccc.caseRec.SoftwareName__c  = 'Testing';
            ccc.caseRec.IsThisForGroup__c  = 'Testing';
            ccc.caseRec.ComputerNames__c  = 'Testing';
            ccc.saveOnly();
            ccc.saveAndSubmit();
            String sysadmProfileId = [Select Id from Profile WHERE Name = 'System Administrator'].Id;
            User sysAdmin = [Select Id from User where ProfileId = :sysadmProfileId and IsActive = true limit 1];
            system.runAs (sysAdmin) 
            {
                list<Case> testCases = [Select Id, Subject, Status, ParentId, ownerId from Case];
                system.debug('@@ after submit:'+testCases);
                // verify 2 cases created, parent is closed, child is new
                system.assertEquals(testCases.size(),2);
                for (Case c:testCases)
                {
                    if (c.Subject == 'Support Parent')
                        system.assertEquals(c.Status,'Closed');
                    if (c.Subject != 'Support Parent')
                        system.assertEquals(c.Status,'New');
                }
            }
        }           
     }

    // coverage for ITSMSSoftwareFishEyeCompController 
    static testMethod void testSoftwareFishEyeSave() {          
        ITSMSTestDataSetup.createTestConstants();
        // create test data - requestor, requestedFor, delegates
        ITSMSTestDataSetup.createRequestor();
        User communityUser = [select Id,  Delegate__c from User where FirstName = 'Community'];
        system.runAs (communityUser)
        {
            //*** start test
            Test.startTest();
            PageReference pageRef= Page.ITSMSSupportRequest;
            Test.setCurrentPage(pageRef);
            ITSMSSoftwareFishEyeCompController ccc = new ITSMSSoftwareFishEyeCompController();
            //-- verify controller
            ccc.caseRec = ITSMSUtilityClass.createCase('Software','Fisheye/Crucible');
            ccc.pageController = new ITSMSPageControllerBase ();
            ccc.key = 'testing';
            ccc.componentToPage = new ITSMSComponentToController ();
            ccc.caseRec.IssueOrRequest__c = 'Request';
            ccc.caseRec.JustificationRequest__c = 'Testing';
            ccc.caseRec.RepoAccountName__c  = 'Testing';
            ccc.caseRec.SourceCodePath__c  = 'Testing';
            ccc.caseRec.DefaultReviewers__c = 'Testing';
            ccc.caseRec.ReviewParticipants__c = 'Testing';
            ccc.saveOnly();
            list<Case> testCases = [Select Id, Subject, Status, ParentId from Case];
            system.debug('@@ after save:'+testCases);
            // verify 2 cases created and status is 'Pending Submission'
            system.assertEquals(testCases.size(),2);
            system.assertEquals(testCases[0].Status,'Pending Submission');
            system.assertEquals(testCases[1].Status,'Pending Submission');
            ccc.caseRec.IssueOrRequest__c = 'Request';
            ccc.caseRec.ManagerUser__c = communityUser.Delegate__c;
            ccc.caseRec.JustificationRequest__c = 'Testing';
            ccc.caseRec.RepoAccountName__c  = 'Testing';
            ccc.caseRec.SourceCodePath__c  = 'Testing';
            ccc.caseRec.DefaultReviewers__c = 'Testing';
            ccc.caseRec.ReviewParticipants__c = 'Testing';
            ccc.saveAndNew();
            ccc.cancelCase();
            testCases = [Select Id, Subject, Status, ParentId from Case];
            system.debug('@@ after cancel:'+testCases);
        }           
     }

    // coverage for ITSMSSoftwareFishEyeCompController 
    static testMethod void testSoftwareFishEyeSubmit() {          
        ITSMSTestDataSetup.createTestConstants();
        // create test data - requestor, requestedFor, delegates
        ITSMSTestDataSetup.createRequestor();
        User communityUser = [select Id,  Delegate__c from User where FirstName = 'Community'];
        system.runAs (communityUser)
        {
            //*** start test
            Test.startTest();
            PageReference pageRef= Page.ITSMSSupportRequest;
            Test.setCurrentPage(pageRef);
            ITSMSSoftwareFishEyeCompController ccc = new ITSMSSoftwareFishEyeCompController();
            //-- verify controller
            ccc.caseRec = ITSMSUtilityClass.createCase('Software','Fisheye/Crucible');
            ccc.pageController = new ITSMSPageControllerBase ();
            ccc.key = 'testing';
            ccc.componentToPage = new ITSMSComponentToController ();
            ccc.caseRec.IssueOrRequest__c = 'Request';
            ccc.caseRec.ManagerUser__c = communityUser.Delegate__c;
            ccc.caseRec.JustificationRequest__c = 'Testing';
            ccc.caseRec.RepoAccountName__c  = 'Testing';
            ccc.caseRec.SourceCodePath__c  = 'Testing';
            ccc.caseRec.DefaultReviewers__c = 'Testing';
            ccc.caseRec.ReviewParticipants__c = 'Testing';
            ccc.saveOnly();
            ccc.saveAndSubmit();
            String sysadmProfileId = [Select Id from Profile WHERE Name = 'System Administrator'].Id;
            User sysAdmin = [Select Id from User where ProfileId = :sysadmProfileId and IsActive = true limit 1];
            system.runAs (sysAdmin) 
            {
                list<Case> testCases = [Select Id, Subject, Status, ParentId, ownerId from Case];
                system.debug('@@ after submit:'+testCases);
                // verify 2 cases created, parent is closed, child is new
                system.assertEquals(testCases.size(),2);
                for (Case c:testCases)
                {
                    if (c.Subject == 'Support Parent')
                        system.assertEquals(c.Status,'Closed');
                    if (c.Subject != 'Support Parent')
                        system.assertEquals(c.Status,'New');
                }
            }
        }           
     }

    // coverage for ITSMSSoftwareJenkinsCompController 
    static testMethod void testSoftwareJenkinsSave() {          
        ITSMSTestDataSetup.createTestConstants();
        // create test data - requestor, requestedFor, delegates
        ITSMSTestDataSetup.createRequestor();
        User communityUser = [select Id,  Delegate__c from User where FirstName = 'Community'];
        system.runAs (communityUser)
        {
            //*** start test
            Test.startTest();
            PageReference pageRef= Page.ITSMSSupportRequest;
            Test.setCurrentPage(pageRef);
            ITSMSSoftwareJenkinsCompController ccc = new ITSMSSoftwareJenkinsCompController();
            //-- verify controller
            ccc.caseRec = ITSMSUtilityClass.createCase('Software','Jenkins');
            ccc.pageController = new ITSMSPageControllerBase ();
            ccc.key = 'testing';
            ccc.componentToPage = new ITSMSComponentToController ();
            ccc.caseRec.IssueOrRequest__c = 'Request';
            ccc.caseRec.Description = 'Testing';
            ccc.caseRec.InstanceName__c  = 'Testing';
            ccc.saveOnly();
            list<Case> testCases = [Select Id, Subject, Status, ParentId from Case];
            system.debug('@@ after save:'+testCases);
            // verify 2 cases created and status is 'Pending Submission'
            system.assertEquals(testCases.size(),2);
            system.assertEquals(testCases[0].Status,'Pending Submission');
            system.assertEquals(testCases[1].Status,'Pending Submission');
            ccc.caseRec.IssueOrRequest__c = 'Request';
            ccc.caseRec.Description = 'Testing';
            ccc.caseRec.InstanceName__c  = 'Testing';
            ccc.saveAndNew();
            ccc.cancelCase();
            testCases = [Select Id, Subject, Status, ParentId from Case];
            system.debug('@@ after cancel:'+testCases);
        }           
     }

    // coverage for ITSMSSoftwareJenkinsCompController 
   static testMethod void testSoftwareJenkinsSubmit() {          
        ITSMSTestDataSetup.createTestConstants();
        // create test data - requestor, requestedFor, delegates
        ITSMSTestDataSetup.createRequestor();
        User communityUser = [select Id,  Delegate__c from User where FirstName = 'Community'];
        system.runAs (communityUser)
        {
            //*** start test
            Test.startTest();
            PageReference pageRef= Page.ITSMSSupportRequest;
            Test.setCurrentPage(pageRef);
            ITSMSSoftwareJenkinsCompController ccc = new ITSMSSoftwareJenkinsCompController();
            //-- verify controller
            ccc.caseRec = ITSMSUtilityClass.createCase('Software','Jenkins');
            ccc.pageController = new ITSMSPageControllerBase ();
            ccc.key = 'testing';
            ccc.componentToPage = new ITSMSComponentToController ();
            ccc.caseRec.IssueOrRequest__c = 'Request';
            ccc.caseRec.Description = 'Testing';
            ccc.caseRec.InstanceName__c  = 'Testing';
            ccc.saveOnly();
            ccc.saveAndSubmit();
            String sysadmProfileId = [Select Id from Profile WHERE Name = 'System Administrator'].Id;
            User sysAdmin = [Select Id from User where ProfileId = :sysadmProfileId and IsActive = true limit 1];
            system.runAs (sysAdmin) 
            {
                list<Case> testCases = [Select Id, Subject, Status, ParentId, ownerId from Case];
                system.debug('@@ after submit:'+testCases);
                // verify 2 cases created, parent is closed, child is new
                system.assertEquals(testCases.size(),2);
                for (Case c:testCases)
                {
                    if (c.Subject == 'Support Parent')
                        system.assertEquals(c.Status,'Closed');
                    if (c.Subject != 'Support Parent')
                        system.assertEquals(c.Status,'New');
                }
            }
        }           
     }

    // coverage for ITSMSSoftwareJIRACompController 
    static testMethod void testSoftwareJIRASave() {          
        ITSMSTestDataSetup.createTestConstants();
        // create test data - requestor, requestedFor, delegates
        ITSMSTestDataSetup.createRequestor();
        User communityUser = [select Id,  Delegate__c from User where FirstName = 'Community'];
        system.runAs (communityUser)
        {
            //*** start test
            Test.startTest();
            PageReference pageRef= Page.ITSMSSupportRequest;
            Test.setCurrentPage(pageRef);
            ITSMSSoftwareJIRACompController ccc = new ITSMSSoftwareJIRACompController();
            //-- verify controller
            ccc.caseRec = ITSMSUtilityClass.createCase('Software','JIRA');
            ccc.pageController = new ITSMSPageControllerBase ();
            ccc.key = 'testing';
            ccc.componentToPage = new ITSMSComponentToController ();
            ccc.caseRec.IssueOrRequest__c = 'Request';
            ccc.caseRec.ProgramProjectName__c = 'Testing';
            ccc.caseRec.ProjectKey__c  = 'Testing';
            ccc.caseRec.DesiredWorkflow__c  = 'Testing';
            ccc.caseRec.WIKIRequired__c  = 'Testing';
            ccc.saveOnly();
            list<Case> testCases = [Select Id, Subject, Status, ParentId from Case];
            system.debug('@@ after save:'+testCases);
            // verify 2 cases created and status is 'Pending Submission'
            system.assertEquals(testCases.size(),2);
            system.assertEquals(testCases[0].Status,'Pending Submission');
            system.assertEquals(testCases[1].Status,'Pending Submission');
            ccc.caseRec.IssueOrRequest__c = 'Request';
            ccc.caseRec.ProgramProjectName__c = 'Testing';
            ccc.caseRec.ProjectKey__c  = 'Testing';
            ccc.caseRec.ManagerUser__c  = communityUser.Delegate__c;
            ccc.caseRec.DesiredWorkflow__c  = 'Testing';
            ccc.caseRec.WIKIRequired__c  = 'Testing';
            ccc.saveAndNew();
            ccc.cancelCase();
            testCases = [Select Id, Subject, Status, ParentId from Case];
            system.debug('@@ after cancel:'+testCases);
        }           
     }

    // coverage for ITSMSSoftwareJIRACompController 
    static testMethod void testSoftwareJIRASubmit() {          
        ITSMSTestDataSetup.createTestConstants();
        // create test data - requestor, requestedFor, delegates
        ITSMSTestDataSetup.createRequestor();
        User communityUser = [select Id,  Delegate__c from User where FirstName = 'Community'];
        system.runAs (communityUser)
        {
            //*** start test
            Test.startTest();
            PageReference pageRef= Page.ITSMSSupportRequest;
            Test.setCurrentPage(pageRef);
            ITSMSSoftwareJIRACompController ccc = new ITSMSSoftwareJIRACompController();
            //-- verify controller
            ccc.caseRec = ITSMSUtilityClass.createCase('Software','JIRA');
            ccc.pageController = new ITSMSPageControllerBase ();
            ccc.key = 'testing';
            ccc.componentToPage = new ITSMSComponentToController ();
            ccc.caseRec.IssueOrRequest__c = 'Request';
            ccc.caseRec.ProgramProjectName__c = 'Testing';
            ccc.caseRec.ProjectKey__c  = 'Testing';
            ccc.caseRec.ManagerUser__c  = communityUser.Delegate__c;
            ccc.caseRec.DesiredWorkflow__c  = 'Testing';
            ccc.caseRec.WIKIRequired__c  = 'Testing';
            ccc.saveOnly();
            ccc.saveAndSubmit();
            String sysadmProfileId = [Select Id from Profile WHERE Name = 'System Administrator'].Id;
            User sysAdmin = [Select Id from User where ProfileId = :sysadmProfileId and IsActive = true limit 1];
            system.runAs (sysAdmin) 
            {
                list<Case> testCases = [Select Id, Subject, Status, ParentId, ownerId from Case];
                system.debug('@@ after submit:'+testCases);
                // verify 2 cases created, parent is closed, child is new
                system.assertEquals(testCases.size(),2);
                for (Case c:testCases)
                {
                    if (c.Subject == 'Support Parent')
                        system.assertEquals(c.Status,'Closed');
                    if (c.Subject != 'Support Parent')
                        system.assertEquals(c.Status,'New');
                }
            }
        }           
     }

    // coverage for ITSMSSoftwareOtherCompController 
     static testMethod void testSoftwareOtherSave() {          
        ITSMSTestDataSetup.createTestConstants();
        // create test data - requestor, requestedFor, delegates
        ITSMSTestDataSetup.createRequestor();
        User communityUser = [select Id,  Delegate__c from User where FirstName = 'Community'];
        system.runAs (communityUser)
        {
            //*** start test
            Test.startTest();
            PageReference pageRef= Page.ITSMSSupportRequest;
            Test.setCurrentPage(pageRef);
            ITSMSSoftwareOtherCompController ccc = new ITSMSSoftwareOtherCompController();
            //-- verify controller
            ccc.caseRec = ITSMSUtilityClass.createCase('Software','All Other Products/Changes/Issues');
            ccc.pageController = new ITSMSPageControllerBase ();
            ccc.key = 'testing';
            ccc.componentToPage = new ITSMSComponentToController ();
            ccc.caseRec.IssueOrRequest__c = 'Request';
            ccc.caseRec.OtherSoftwareProduct__c = 'bamboo';
            ccc.caseRec.Description  = 'bamboo';
            ccc.saveOnly();
            list<Case> testCases = [Select Id, Subject, Status, ParentId from Case];
            system.debug('@@ after save:'+testCases);
            // verify 2 cases created and status is 'Pending Submission'
            system.assertEquals(testCases.size(),2);
            system.assertEquals(testCases[0].Status,'Pending Submission');
            system.assertEquals(testCases[1].Status,'Pending Submission');
            ccc.caseRec.IssueOrRequest__c = 'Request';
            ccc.caseRec.OtherSoftwareProduct__c = 'Fisheye';
            ccc.caseRec.Description  = 'Fisheye';
            ccc.saveAndNew();
            ccc.caseRec.IssueOrRequest__c = 'Request';
            ccc.caseRec.OtherSoftwareProduct__c = 'HipChat';
            ccc.caseRec.Description  = 'HipChat';
            ccc.saveAndNew();
            ccc.caseRec.IssueOrRequest__c = 'Request';
            ccc.caseRec.OtherSoftwareProduct__c = 'JIRA';
            ccc.caseRec.Description  = 'JIRA';
            ccc.saveAndNew();
            ccc.caseRec.IssueOrRequest__c = 'Request';
            ccc.caseRec.OtherSoftwareProduct__c = 'confluence';
            ccc.caseRec.Description  = 'confluence';
            ccc.saveAndNew();
            ccc.cancelCase();
            testCases = [Select Id, Subject, Status, ParentId from Case];
            system.debug('@@ after cancel:'+testCases);
        }           
     }

    // coverage for ITSMSSoftwareOtherCompController 
    static testMethod void testSoftwareOtherSubmit() {          
        ITSMSTestDataSetup.createTestConstants();
        // create test data - requestor, requestedFor, delegates
        ITSMSTestDataSetup.createRequestor();
        User communityUser = [select Id,  Delegate__c from User where FirstName = 'Community'];
        system.runAs (communityUser)
        {
            //*** start test
            Test.startTest();
            PageReference pageRef= Page.ITSMSSupportRequest;
            Test.setCurrentPage(pageRef);
            ITSMSSoftwareOtherCompController ccc = new ITSMSSoftwareOtherCompController();
            //-- verify controller
            ccc.caseRec = ITSMSUtilityClass.createCase('Software','All Other Products/Changes/Issues');
            ccc.pageController = new ITSMSPageControllerBase ();
            ccc.key = 'testing';
            ccc.componentToPage = new ITSMSComponentToController ();
            ccc.caseRec.IssueOrRequest__c = 'Request';
            ccc.caseRec.OtherSoftwareProduct__c = 'Testing';
            ccc.caseRec.Description  = 'Testing';
            ccc.saveOnly();
            ccc.saveAndSubmit();
            String sysadmProfileId = [Select Id from Profile WHERE Name = 'System Administrator'].Id;
            User sysAdmin = [Select Id from User where ProfileId = :sysadmProfileId and IsActive = true limit 1];
            system.runAs (sysAdmin) 
            {
                list<Case> testCases = [Select Id, Subject, Status, ParentId, ownerId from Case];
                system.debug('@@ after submit:'+testCases);
                // verify 2 cases created, parent is closed, child is new
                system.assertEquals(testCases.size(),2);
                for (Case c:testCases)
                {
                    if (c.Subject == 'Support Parent')
                        system.assertEquals(c.Status,'Closed');
                    if (c.Subject != 'Support Parent')
                        system.assertEquals(c.Status,'New');
                }
            }
        }           
     }

    // coverage for ITSMSSoftwareWIKICompController 
    static testMethod void testSoftwareWIKISave() {          
        ITSMSTestDataSetup.createTestConstants();
        // create test data - requestor, requestedFor, delegates
        ITSMSTestDataSetup.createRequestor();
        User communityUser = [select Id,  Delegate__c from User where FirstName = 'Community'];
        system.runAs (communityUser)
        {
            //*** start test
            Test.startTest();
            PageReference pageRef= Page.ITSMSSupportRequest;
            Test.setCurrentPage(pageRef);
            ITSMSSoftwareWIKICompController ccc = new ITSMSSoftwareWIKICompController();
            //-- verify controller
            ccc.caseRec = ITSMSUtilityClass.createCase('Software','Wiki Space');
            ccc.pageController = new ITSMSPageControllerBase ();
            ccc.key = 'testing';
            ccc.componentToPage = new ITSMSComponentToController ();
            ccc.caseRec.IssueOrRequest__c = 'Request';
            ccc.caseRec.WIKISpaceName__c  = 'Testing';
            ccc.caseRec.WIKISpaceKey__c  = 'Testing';
            ccc.caseRec.Description  = 'Testing';
            ccc.caseRec.WIKISpaceType__c  = 'Testing';
            ccc.saveOnly();
            list<Case> testCases = [Select Id, Subject, Status, ParentId from Case];
            system.debug('@@ after save:'+testCases);
            // verify 2 cases created and status is 'Pending Submission'
            system.assertEquals(testCases.size(),2);
            system.assertEquals(testCases[0].Status,'Pending Submission');
            system.assertEquals(testCases[1].Status,'Pending Submission');
            ccc.caseRec.IssueOrRequest__c = 'Request';
            ccc.caseRec.WIKISpaceName__c  = 'Testing';
            ccc.caseRec.WIKISpaceKey__c  = 'Testing';
            ccc.caseRec.Description  = 'Testing';
            ccc.caseRec.WIKISpaceType__c  = 'Testing';
            ccc.saveAndNew();
            ccc.cancelCase();
            testCases = [Select Id, Subject, Status, ParentId from Case];
            system.debug('@@ after cancel:'+testCases);
        }           
     }

    // coverage for ITSMSSoftwareWIKICompController 
    static testMethod void testSoftwareWIKISubmit() {          
        ITSMSTestDataSetup.createTestConstants();
        // create test data - requestor, requestedFor, delegates
        ITSMSTestDataSetup.createRequestor();
        User communityUser = [select Id,  Delegate__c from User where FirstName = 'Community'];
        system.runAs (communityUser)
        {
            //*** start test
            Test.startTest();
            PageReference pageRef= Page.ITSMSSupportRequest;
            Test.setCurrentPage(pageRef);
            ITSMSSoftwareWIKICompController ccc = new ITSMSSoftwareWIKICompController();
            //-- verify controller
            ccc.caseRec = ITSMSUtilityClass.createCase('Software','Wiki Space');
            ccc.pageController = new ITSMSPageControllerBase ();
            ccc.key = 'testing';
            ccc.componentToPage = new ITSMSComponentToController ();
            ccc.caseRec.IssueOrRequest__c = 'Request';
            ccc.caseRec.WIKISpaceName__c  = 'Testing';
            ccc.caseRec.WIKISpaceKey__c  = 'Testing';
            ccc.caseRec.Description  = 'Testing';
            ccc.caseRec.WIKISpaceType__c  = 'Testing';
            ccc.saveOnly();
            ccc.saveAndSubmit();
            String sysadmProfileId = [Select Id from Profile WHERE Name = 'System Administrator'].Id;
            User sysAdmin = [Select Id from User where ProfileId = :sysadmProfileId and IsActive = true limit 1];
            system.runAs (sysAdmin) 
            {
                list<Case> testCases = [Select Id, Subject, Status, ParentId, ownerId from Case];
                system.debug('@@ after submit:'+testCases);
                // verify 2 cases created, parent is closed, child is new
                system.assertEquals(testCases.size(),2);
                for (Case c:testCases)
                {
                    if (c.Subject == 'Support Parent')
                        system.assertEquals(c.Status,'Closed');
                    if (c.Subject != 'Support Parent')
                        system.assertEquals(c.Status,'New');
                }
            }
        }           
     }

    // coverage for ITSMSStorageComponentController 
    static testMethod void testStorageSave() {          
        ITSMSTestDataSetup.createTestConstants();
        // create test data - requestor, requestedFor, delegates
        ITSMSTestDataSetup.createRequestor();
        User communityUser = [select Id,  Delegate__c from User where FirstName = 'Community'];
        system.runAs (communityUser)
        {
            //*** start test
            Test.startTest();
            PageReference pageRef= Page.ITSMSSupportRequest;
            Test.setCurrentPage(pageRef);
            ITSMSStorageComponentController ccc = new ITSMSStorageComponentController();
            //-- verify controller
            ccc.caseRec = ITSMSUtilityClass.createCase('Server','Storage');
            ccc.pageController = new ITSMSPageControllerBase ();
            ccc.key = 'testing';
            ccc.componentToPage = new ITSMSComponentToController ();
            ccc.caseRec.IssueOrRequest__c = 'Request';
            ccc.caseRec.Date_Needed_By__c = system.today();
            ccc.caseRec.EquipmentLocation__c = 'testing';
            ccc.caseRec.CostCenterNumber__c = 'testing';
            ccc.caseRec.BriefDescription__c = 'testing';
            ccc.caseRec.JustificationRequest__c = 'testing';
            ccc.caseRec.StorageRequestType__c = 'testing';
            ccc.caseRec.StorageLocation__c = 'testing';
            ccc.caseRec.NewHost__c = 'testing';
            ccc.caseRec.ServerHostName__c = 'testing';
            ccc.caseRec.Clustered__c  = 'testing';
            ccc.caseRec.Database__c = 'testing';
            ccc.caseRec.DiskName__c = 'testing';
            ccc.caseRec.StorageSize__c  = 5;
            ccc.caseRec.StorageSizeType__c = 'testing';
            ccc.caseRec.StorageSnapshotClone__c = 'testing';
            ccc.caseRec.SourceHostname__c = 'testing';
            ccc.caseRec.TargetHostname__c = 'testing';
            ccc.caseRec.StorageEnvironment__c = 'testing';
            ccc.caseRec.StorageFrequency__c = 'testing';
            ccc.caseRec.StartDateTime__c = system.now();
            ccc.caseRec.EndDateTime__c = system.now();
            ccc.saveOnly();
            list<Case> testCases = [Select Id, Subject, Status, ParentId from Case];
            system.debug('@@ after save:'+testCases);
            // verify 2 cases created and status is 'Pending Submission'
            system.assertEquals(testCases.size(),2);
            system.assertEquals(testCases[0].Status,'Pending Submission');
            system.assertEquals(testCases[1].Status,'Pending Submission');
            ccc.caseRec.IssueOrRequest__c = 'Request';
            ccc.caseRec.Date_Needed_By__c = system.today();
            ccc.caseRec.EquipmentLocation__c = 'testing';
            ccc.caseRec.CostCenterNumber__c = 'testing';
            ccc.caseRec.BriefDescription__c = 'testing';
            ccc.caseRec.JustificationRequest__c = 'testing';
            ccc.caseRec.StorageRequestType__c = 'testing';
            ccc.caseRec.StorageLocation__c = 'testing';
            ccc.caseRec.NewHost__c = 'testing';
            ccc.caseRec.ServerHostName__c = 'testing';
            ccc.caseRec.Clustered__c  = 'testing';
            ccc.caseRec.Database__c = 'testing';
            ccc.caseRec.DiskName__c = 'testing';
            ccc.caseRec.StorageSize__c  = 3;
            ccc.caseRec.StorageSizeType__c = 'testing';
            ccc.caseRec.StorageSnapshotClone__c = 'testing';
            ccc.caseRec.SourceHostname__c = 'testing';
            ccc.caseRec.TargetHostname__c = 'testing';
            ccc.caseRec.StorageEnvironment__c = 'testing';
            ccc.caseRec.StorageFrequency__c = 'testing';
            ccc.caseRec.StartDateTime__c = system.now();
            ccc.caseRec.EndDateTime__c = system.now();
            ccc.saveAndNew();
            ccc.cancelCase();
            testCases = [Select Id, Subject, Status, ParentId from Case];
            system.debug('@@ after cancel:'+testCases);
        }           
     }

    // coverage for ITSMSStorageComponentController 
    static testMethod void testStorageSubmit() {          
        ITSMSTestDataSetup.createTestConstants();
        // create test data - requestor, requestedFor, delegates
        ITSMSTestDataSetup.createRequestor();
        User communityUser = [select Id,  Delegate__c from User where FirstName = 'Community'];
        system.runAs (communityUser)
        {
            //*** start test
            Test.startTest();
            PageReference pageRef= Page.ITSMSSupportRequest;
            Test.setCurrentPage(pageRef);
            ITSMSStorageComponentController ccc = new ITSMSStorageComponentController();
            //-- verify controller
            ccc.caseRec = ITSMSUtilityClass.createCase('Server','Storage');
            ccc.pageController = new ITSMSPageControllerBase ();
            ccc.key = 'testing';
            ccc.componentToPage = new ITSMSComponentToController ();
            ccc.caseRec.IssueOrRequest__c = 'Request';
            ccc.caseRec.Date_Needed_By__c = system.today();
            ccc.caseRec.EquipmentLocation__c = 'testing';
            ccc.caseRec.CostCenterNumber__c = 'testing';
            ccc.caseRec.BriefDescription__c = 'testing';
            ccc.caseRec.JustificationRequest__c = 'testing';
            ccc.caseRec.StorageRequestType__c = 'testing';
            ccc.caseRec.StorageLocation__c = 'testing';
            ccc.caseRec.NewHost__c = 'testing';
            ccc.caseRec.ServerHostName__c = 'testing';
            ccc.caseRec.Clustered__c  = 'testing';
            ccc.caseRec.Database__c = 'testing';
            ccc.caseRec.DiskName__c = 'testing';
            ccc.caseRec.StorageSize__c  = 2;
            ccc.caseRec.StorageSizeType__c = 'testing';
            ccc.caseRec.StorageSnapshotClone__c = 'testing';
            ccc.caseRec.SourceHostname__c = 'testing';
            ccc.caseRec.TargetHostname__c = 'testing';
            ccc.caseRec.StorageEnvironment__c = 'testing';
            ccc.caseRec.StorageFrequency__c = 'testing';
            ccc.caseRec.StartDateTime__c = system.now();
            ccc.caseRec.EndDateTime__c = system.now();
            ccc.saveOnly();
            ccc.saveAndSubmit();
            String sysadmProfileId = [Select Id from Profile WHERE Name = 'System Administrator'].Id;
            User sysAdmin = [Select Id from User where ProfileId = :sysadmProfileId and IsActive = true limit 1];
            system.runAs (sysAdmin) 
            {
                list<Case> testCases = [Select Id, Subject, Status, ParentId, ownerId from Case];
                system.debug('@@ after submit:'+testCases);
                // verify 2 cases created, parent is closed, child is new
                system.assertEquals(testCases.size(),2);
                for (Case c:testCases)
                {
                    if (c.Subject == 'Support Parent')
                        system.assertEquals(c.Status,'Closed');
                    if (c.Subject != 'Support Parent')
                        system.assertEquals(c.Status,'New');
                }
            }
        }           
     }

    // coverage for ITSMSSupportRequestController 
    static testMethod void testSupportRequestBasic() {
        ITSMSTestDataSetup.createTestConstants();
        // create test data - requestor, requestedFor, delegate
        ITSMSTestDataSetup.createRequestor();
        User requestor = [select Id, ManagerId from User where FirstName = 'Requestor'];

        system.runAs (requestor)
        {
            // create a parent case
            ITSMSTestDataSetup.createTestCase();
            Case testParent = [Select Id, Subject from Case limit 1];
            testParent.Subject = 'ParentCase';
            update testParent;
            // create a child to parent  
            ITSMSTestDataSetup.createTestCase();
            Case testChild = [Select Id, Subject from Case where Subject != 'ParentCase' limit 1];
            testChild.Subject = 'ChildCase';
            testChild.ParentId = testParent.Id;
            update testChild;
            //*** start test
            Test.startTest();
            PageReference pageRef= Page.ITSMSSupportRequest;
            Test.setCurrentPage(pageRef);
            ApexPages.currentPage().getParameters().put('Category', 'General');
            // test 1.  No existing case 
            ITSMSSupportRequestController e = new ITSMSSupportRequestController();
            // test 2.  Existing case that is parent
            ApexPages.currentPage().getParameters().put('Id', testParent.Id);
            ITSMSSupportRequestController e2 = new ITSMSSupportRequestController();
            // test 3.  Existing case that is not parent
            ApexPages.currentPage().getParameters().put('Id', testChild.Id);
            ITSMSSupportRequestController e3= new ITSMSSupportRequestController();
            
            // test 4.  Edit case that is child
            ApexPages.currentPage().getParameters().put('EditCaseId',testChild.Id);
            ITSMSSupportRequestController e4= new ITSMSSupportRequestController();
            //  e4.editCase();
            // test 5.  Delete case that is child
            ApexPages.currentPage().getParameters().put('DeleteCaseId',testChild.Id);
            ITSMSSupportRequestController e5= new ITSMSSupportRequestController();
            e5.deleteCase();
            
        }
    }

    // coverage for ITSMSSupportRequestController 
    static testMethod void testSupportRequestSubmitAll() {
        ITSMSTestDataSetup.createTestConstants();
        // create test data - requestor, requestedFor, delegate
        ITSMSTestDataSetup.createRequestor();
        User requestor = [select Id, ManagerId from User where FirstName = 'Requestor'];

        system.runAs (requestor)
        {
            Test.startTest();
            // create a parent case
            ITSMSTestDataSetup.createTestCase();
            String sysadmProfileId = [Select Id from Profile WHERE Name = 'System Administrator'].Id;
            User sysAdmin = [Select Id from User where ProfileId = :sysadmProfileId and IsActive = true limit 1];
            system.runAs (sysAdmin) 
            {
                Case testParent = [Select Id, Subject from Case limit 1];
                testParent.Subject = 'ParentCase';
                update testParent;
            
                // create 2 children to parent  
                ITSMSTestDataSetup.createTestCase();
                Case testChild1 = [Select Id, Subject from Case where Subject != 'ParentCase' limit 1];
                testChild1.Subject = 'ChildCase1';
                testChild1.ParentId = testParent.Id;
                update testChild1;
                // create 2 children to parent  
                ITSMSTestDataSetup.createTestCase();
                Case testChild2 = [Select Id, Subject from Case where Subject != 'ParentCase' and Subject != 'ChildCase1' limit 1];
                testChild2.Subject = 'ChildCase2';
                testChild2.ParentId = testParent.Id;
                update testChild2;
            
            PageReference pageRef= Page.ITSMSSupportRequest;
            Test.setCurrentPage(pageRef);
            ApexPages.currentPage().getParameters().put('Category', 'General');
            // test  Existing case that is child
            ApexPages.currentPage().getParameters().put('Id', testChild1.Id);
            ITSMSSupportRequestController e1= new ITSMSSupportRequestController();
            e1.submitAll();
            //String sysadmProfileId = [Select Id from Profile WHERE Name = 'System Administrator'].Id;
            //User sysAdmin = [Select Id from User where ProfileId = :sysadmProfileId and IsActive = true limit 1];
            //system.runAs (sysAdmin) 
            //{
                List<Case> testSubmit = [Select Id, Status, ParentId from Case where ParentId =: testChild1.ParentId];
                system.debug('@@ found children'+testSubmit);
                system.assertEquals(testSubmit.size(),2);
                system.assertEquals(testSubmit[0].Status,'New');
                system.assertEquals(testSubmit[1].Status,'New');
            }
        }    
    }

    // coverage for ITSMSTemplateController
    static testMethod void testTemplateComp() {          
        ITSMSTestDataSetup.createTestConstants();
        // create test data - requestor, requestedFor, delegates
        ITSMSTestDataSetup.createRequestor();
        User communityUser = [select Id,  Delegate__c from User where FirstName = 'Community'];
        system.runAs (communityUser)
        {
            //*** start test
            Test.startTest();
            PageReference pageRef= Page.ITSMSSupportRequest;
            Test.setCurrentPage(pageRef);
            ITSMSTemplateController  ccc = new ITSMSTemplateController ();
            //-- verify controller
        }           
     }

    // coverage for ITSMSWorkstationCompController 
    static testMethod void testWorkstationSave() {          
        ITSMSTestDataSetup.createTestConstants();
        // create test data - requestor, requestedFor, delegates
        ITSMSTestDataSetup.createRequestor();
        User communityUser = [select Id,  Delegate__c from User where FirstName = 'Community'];
        system.runAs (communityUser)
        {
            //*** start test
            Test.startTest();
            PageReference pageRef= Page.ITSMSSupportRequest;
            Test.setCurrentPage(pageRef);
            ITSMSWorkstationCompController ccc = new ITSMSWorkstationCompController();
            //-- verify controller
            ccc.caseRec = ITSMSUtilityClass.createCase('Workstation','Workstation/Laptop');
            ccc.pageController = new ITSMSPageControllerBase ();
            ccc.key = 'testing';
            ccc.componentToPage = new ITSMSComponentToController ();
            ccc.caseRec.IssueOrRequest__c = 'Request';
            ccc.caseRec.Date_Needed_By__c = system.today();
            ccc.caseRec.EquipmentLocation__c = 'testing';
            ccc.caseRec.CostCenterNumber__c = 'testing';
            ccc.caseRec.BriefDescription__c = 'testing';
            ccc.caseRec.JustificationRequest__c = 'testing';
            ccc.caseRec.WorkstationType__c = 'testing';
            ccc.caseRec.PCModelType__c = 'testing';
            ccc.caseRec.ComputerType__c = 'testing';
            ccc.caseRec.OperatingSystem__c = 'testing';
            ccc.caseRec.AssetTag__c  = 'testing';
            ccc.saveOnly();
            list<Case> testCases = [Select Id, Subject, Status, ParentId from Case];
            system.debug('@@ after save:'+testCases);
            // verify 2 cases created and status is 'Pending Submission'
            system.assertEquals(testCases.size(),2);
            system.assertEquals(testCases[0].Status,'Pending Submission');
            system.assertEquals(testCases[1].Status,'Pending Submission');
            ccc.caseRec.IssueOrRequest__c = 'Request';
            ccc.caseRec.Date_Needed_By__c = system.today();
            ccc.caseRec.EquipmentLocation__c = 'testing';
            ccc.caseRec.CostCenterNumber__c = 'testing';
            ccc.caseRec.BriefDescription__c = 'testing';
            ccc.caseRec.JustificationRequest__c = 'testing';
            ccc.caseRec.WorkstationType__c = 'testing';
            ccc.caseRec.PCModelType__c = 'Laptop';
            ccc.caseRec.ComputerType__c = 'testing';
            ccc.caseRec.OperatingSystem__c = 'testing';
            ccc.caseRec.AssetTag__c  = 'testing';
            ccc.saveAndNew();
            ccc.cancelCase();
            testCases = [Select Id, Subject, Status, ParentId from Case];
            system.debug('@@ after cancel:'+testCases);
        }           
     }

    // coverage for ITSMSWorkstationCompController 
    static testMethod void testWorkstationSubmit() {          
        ITSMSTestDataSetup.createTestConstants();
        // create test data - requestor, requestedFor, delegates
        ITSMSTestDataSetup.createRequestor();
        User communityUser = [select Id,  Delegate__c from User where FirstName = 'Community'];
        system.runAs (communityUser)
        {
            //*** start test
            Test.startTest();
            PageReference pageRef= Page.ITSMSSupportRequest;
            Test.setCurrentPage(pageRef);
            ITSMSWorkstationCompController ccc = new ITSMSWorkstationCompController();
            //-- verify controller
            ccc.caseRec = ITSMSUtilityClass.createCase('Workstation','Workstation/Laptop');
            ccc.pageController = new ITSMSPageControllerBase ();
            ccc.key = 'testing';
            ccc.componentToPage = new ITSMSComponentToController ();
            ccc.caseRec.IssueOrRequest__c = 'Request';
            ccc.caseRec.Date_Needed_By__c = system.today();
            ccc.caseRec.EquipmentLocation__c = 'testing';
            ccc.caseRec.CostCenterNumber__c = 'testing';
            ccc.caseRec.BriefDescription__c = 'testing';
            ccc.caseRec.JustificationRequest__c = 'testing';
            ccc.caseRec.WorkstationType__c = 'testing';
            ccc.caseRec.PCModelType__c = 'Desktop';
            ccc.caseRec.ComputerType__c = 'testing';
            ccc.caseRec.OperatingSystem__c = 'testing';
            ccc.caseRec.AssetTag__c  = 'testing';
            ccc.saveOnly();
            ccc.saveAndSubmit();
            String sysadmProfileId = [Select Id from Profile WHERE Name = 'System Administrator'].Id;
            User sysAdmin = [Select Id from User where ProfileId = :sysadmProfileId and IsActive = true limit 1];
            system.runAs (sysAdmin) 
            {
                list<Case> testCases = [Select Id, Subject, Status, ParentId, ownerId from Case];
                system.debug('@@ after submit:'+testCases);
                // verify 2 cases created, parent is closed, child is new
                system.assertEquals(testCases.size(),2);
                for (Case c:testCases)
                {
                    if (c.Subject == 'Support Parent')
                        system.assertEquals(c.Status,'Closed');
                    if (c.Subject != 'Support Parent')
                        system.assertEquals(c.Status,'New');
                }
            }
        }           
     }
    
    // coverage for ITSMSUtilityClass 
    static testMethod void testUtilities() {          
        ITSMSTestDataSetup.createTestConstants();
        // create test data - requestor, requestedFor, delegates
        ITSMSTestDataSetup.createRequestor();
        User communityUser = [select Id,  Delegate__c from User where FirstName = 'Community'];
        system.runAs (communityUser)
        {
            //*** start test
            Test.startTest();
            system.debug('@@ additional software:'+ITSMSConstants.ADDITIONAL_SOFTWARELIST);
        }           
     }
}