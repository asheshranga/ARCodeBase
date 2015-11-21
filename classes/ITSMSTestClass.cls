/*
 * Class ITSMSTestClass
 * 
 * @version 1.0
 * @author  Dianna Guilinger - Slalom  
 *
 *  Usage: includes methods for all testing 
 */
@isTest
private class ITSMSTestClass {

    // Coverage for ITSMSArticleComponentController
    private static testMethod void testArticleController()
    {
        ITSMSTestDataSetup.createTestConstants();
        // create admin user
        ITSMSTestDataSetup.createAdmins();        
        User admin = [SELECT Id, firstname FROM User WHERE firstname = 'knowledgeAdmin' ]; 
        system.runAs (admin)
        {
            //*** start test
            Test.startTest();
            ITSMSTestDataSetup.createPublishedArticle('LandingPage', 'Alerts & Notifications');
            ITSMSArticleComponentController acc = new ITSMSArticleComponentController(); 
            acc.areaContext = 'Landing';
            acc.sectionContext = 'Alerts & Notifications';
            acc.articleType = 'Online';
            system.debug('@@ article test:'+acc.articleMap);
            system.debug('@@ article test:'+acc.articleList);
            system.assertNotEquals(acc.articleMap,null);
            system.assertNotEquals(acc.articleList,null);
        }
    }
    static testMethod void testArticleFailureQuery(){
        
        ITSMSTestDataSetup.createAdmins();
        User admin = [SELECT Id, firstname FROM User WHERE firstname = 'knowledgeAdmin' ];    
        
        test.startTest();           
        System.runAs(admin){
            ITSMSUtilityClass.getITSMSKavs('', '', '');
        }
        test.stopTest();           
    }

    // Coverage for ITSMSCaseCommentsComponentController
    private static testMethod void testCaseCommentsController()
    {
        ITSMSTestDataSetup.createTestConstants();
        // create test data - requestor, requestedFor, delegate
        ITSMSTestDataSetup.createRequestor();
        User requestor = [select Id, ManagerId from User where FirstName = 'Requestor'];
        // create basic Case 
        string inputCategory = ITSMSConstants.GENERAL_CATEGORY;
        string srvreqType = ITSMSConstants.SUPPORT_SRVREQTYPE_GENERAL;
        system.runAs (requestor)
        {
            Case c = ITSMSUtilityClass.createCase(inputCategory, srvreqType);
            boolean isUpserted = ITSMSUtilityClass.upsertCase(c);
            Globals__c tempSkipValidation = new Globals__c (CaseMilestoneValidationIgnore__c=true);
            insert tempSkipValidation;
            
            list<CaseComment> comments = new list<CaseComment> {
                new CaseComment(CommentBody='TestComment1',IsPublished=True,ParentId = c.Id),
                new CaseComment(CommentBody='TestComment2',IsPublished=False,ParentId = c.Id)};
            insert comments;
            
            ITSMSCaseCommentsComponentController controller=new ITSMSCaseCommentsComponentController();
            controller.caseId=c.id;
            //controller.comments= new list<ITSMSCaseCommentsComponentController.cComments>();
            system.assertEquals(2,controller.comments.size());
            system.assertEquals(false,controller.newCommentNeeded);
            controller.newComment();
            controller.saveComment();
            controller.cancelComment();
            
        }
    }
    // Coverage for ITSMSCaseDetailController 
    static testMethod void testCaseDetailPendingNewHire() {          
        ITSMSTestDataSetup.createTestConstants();
        // create test data - requestor, requestedFor, delegate
        ITSMSTestDataSetup.createRequestor();
        User requestor = [select Id, ManagerId from User where FirstName = 'Requestor'];
        system.runAs (requestor)
        {

            // create pending Case for New Hire
            ITSMSTestDataSetup.createTestCase();
            Case pendingCase = [Select Id, Subject from Case limit 1];
			ITSMSUtilityClass.relatedCasesExist(pendingCase);
			ITSMSUtilityClass.relatedEmailsExist(pendingCase);          
            pendingCase.Subject = 'CaseDetailNewHire';
            pendingCase.Status = 'Pending Submission';
            pendingCase.ServiceRequestType__c = ITSMSConstants.NEWHIRE_SRVREQTYPE_PARENT;
            boolean isUpserted = ITSMSUtilityClass.upsertCase(pendingCase);

            Test.startTest();
            PageReference pageRef= Page.ITSMSCaseDetail;
            Test.setCurrentPage(pageRef);
            ApexPages.StandardController sc = new ApexPages.StandardController(pendingCase);
            ITSMSCaseDetailController cdc = new ITSMSCaseDetailController(sc);
            ApexPages.currentPage().getParameters().put('caseId', pendingCase.Id);
        
            //-- verify controller
            cdc.thisCase = [Select Id, Status, ServiceRequestType__c from Case where Id = :pendingCase.Id limit 1];
            cdc.checkCase();
        }
    }
    // Coverage for ITSMSCaseDetailController 
    static testMethod void testCaseDetailPendingSupport() {          
        ITSMSTestDataSetup.createTestConstants();
        // create test data - requestor, requestedFor, delegate
        ITSMSTestDataSetup.createRequestor();
        User requestor = [select Id, ManagerId from User where FirstName = 'Requestor'];
        system.runAs (requestor)
        {

            // create pending Case for Support
            ITSMSTestDataSetup.createTestCase();
            Case pendingCase = [Select Id, Subject, Status, ServiceRequestType__c, SupportCategory__c from Case limit 1];
            pendingCase.Subject = 'CaseDetailSupport';
            pendingCase.Status = 'Pending Submission';
            pendingCase.ServiceRequestType__c = 'Access';
            pendingCase.SupportCategory__c = 'Access';
            boolean isUpserted = ITSMSUtilityClass.upsertCase(pendingCase);

            Test.startTest();
            PageReference pageRef= Page.ITSMSCaseDetail;
            Test.setCurrentPage(pageRef);
            ApexPages.StandardController sc = new ApexPages.StandardController(pendingCase);
            ITSMSCaseDetailController cdc = new ITSMSCaseDetailController(sc);
            ApexPages.currentPage().getParameters().put('caseId', pendingCase.Id);
        
            //-- verify controller
            cdc.thisCase = [Select Id, Status, ServiceRequestType__c from Case where Id = :pendingCase.Id limit 1];
            cdc.checkCase();
        }
    }

    // Coverage for ITSMSCaseDetailController 
    static testMethod void testCaseDetailSubmittedSupport() {          
        ITSMSTestDataSetup.createTestConstants();
        // create test data - requestor, requestedFor, delegate
        ITSMSTestDataSetup.createRequestor();
        User requestor = [select Id, ManagerId from User where FirstName = 'Requestor'];
        system.runAs (requestor)
        {

            // create submitted Case for Support 
            ITSMSTestDataSetup.createTestCase();
            Case submitCase = [Select Id, Subject from Case limit 1 ];
            submitCase.Subject = 'CaseDetailSupport';
            submitCase.Status = 'New';
            submitCase.ServiceRequestType__c = 'Access';
            submitCase.SupportCategory__c = 'Access';
            boolean isUpserted = ITSMSUtilityClass.upsertCase(submitCase);
            Case thisCase = [Select Id, Status, SupportCategory__c, ServiceRequestType__c from Case where Id =: submitCase.Id limit 1];
            system.debug('@@ test case:'+thisCase);
            Test.startTest();
            PageReference pageRef= Page.ITSMSCaseDetail;
            Test.setCurrentPage(pageRef);
            ApexPages.StandardController sc = new ApexPages.StandardController(submitCase);
            ITSMSCaseDetailController cdc = new ITSMSCaseDetailController(sc);
            ApexPages.currentPage().getParameters().put('caseId', submitCase.Id);
        
            //-- verify controller
            cdc.thisCase = [Select Id, Status, ServiceRequestType__c,SupportCategory__c  from Case where Id = :submitCase.Id limit 1];
            cdc.checkCase();
        }
    }

    // Coverage for ITSMSCaseDetailController 
    static testMethod void testCaseDetailSubmittedNewHire() {          
        ITSMSTestDataSetup.createTestConstants();
        // create test data - requestor, requestedFor, delegate
        ITSMSTestDataSetup.createRequestor();
        User requestor = [select Id, ManagerId from User where FirstName = 'Requestor'];
        system.runAs (requestor)
        {
            // create submitted Case 
            ITSMSTestDataSetup.createNewHireToSubmit();
            Case submitCase = [Select Id, Subject, SupportCategory__c, ServiceRequestType__c  from Case limit 1 ];
            submitCase.Subject = 'CaseDetailNewHire';
            submitCase.Status = ITSMSConstants.NEWHIRE_STATUS_SUBMIT;
            submitCase.ServiceRequestType__c = ITSMSConstants.NEWHIRE_SRVREQTYPE_PARENT;
            submitCase.SupportCategory__c = 'New Hire';
            boolean isUpserted = ITSMSUtilityClass.upsertCase(submitCase);
            ITSMSTestDataSetup.createTestCase();
            Case relatedCase = [Select Id, Subject, ParentId from Case where Subject != 'CaseDetailNewHire' limit 1];
            relatedCase.ParentId = submitCase.Id;
            boolean isUpsertRelated = ITSMSUtilityClass.upsertCase(relatedCase);
            EmailMessage[] relatedEmail = new EmailMessage [] {
                new EmailMessage (Subject='Testing',ParentId = submitCase.Id, FromAddress='testing@test.com', ToAddress='Testing@dummy.com')
                };
            insert relatedEmail;
            

            Test.startTest();
            PageReference pageRef= Page.ITSMSCaseDetail;
            Test.setCurrentPage(pageRef);
            ApexPages.StandardController sc = new ApexPages.StandardController(submitCase);
            ITSMSCaseDetailController cdc = new ITSMSCaseDetailController(sc);
            ApexPages.currentPage().getParameters().put('caseId', submitCase.Id);
        
            //-- verify controller
            cdc.thisCase = [Select Id, Status, ServiceRequestType__c, SupportCategory__c from Case where Id = :submitCase.Id limit 1];
            system.debug('@@ submitted case:'+cdc.thisCase);
            cdc.checkCase();
            cdc.returnToMyCases();
        }
    }

    // Coverage for ITSMSCaseMatrix Controller 
    static testMethod void testCaseMatrixController() {
       ITSMSTestDataSetup.createTestConstants();
        // create test data - requestor, requestedFor, delegate
        ITSMSTestDataSetup.createRequestor();
        User requestor = [select Id, ManagerId from User where FirstName = 'Requestor'];
        system.runAs (requestor)
        {
            // create submitted Case 
            ITSMSTestDataSetup.createTestCase();
            Case submitCase = [Select Id, Subject, SupportCategory__c, ServiceRequestType__c  from Case limit 1 ];
            submitCase.SupportRequestType__c = 'Folder/Share';
            submitCase.ServiceRequestType__c = ITSMSConstants.FOLDERSHARE_SRVREQTYPE;
            submitCase.SupportCategory__c = 'Access';
            boolean isUpserted = ITSMSUtilityClass.upsertCase(submitCase);
            ITSMSCaseMatrixComponentController matrixController = new ITSMSCaseMatrixComponentController();
           
            //*** start test
            Test.startTest(); 
            matrixController.key = 'Testing' ;
            matrixController.componentToPage = new ITSMSComponentToController ();
            matrixController.pageController = new ITSMSPageControllerBase();
            matrixController.caseRec = submitCase;
            matrixController.componentToPage.caseRec = submitCase;
            matrixController.recordTypeName = 'FolderShareNew';
            matrixController.theFieldSetName = 'MatrixNew';
            matrixController.intNumberOfRows = 2;
            
            // validate
            system.assertEquals(matrixController.intNumberOfRows, matrixController.LstPermissions.size(), 'Failed to set the lstPermissions');
            system.assertEquals(0, matrixController.lstSavedPermissions.size());
            
            // set the user field of one of the permission rows and save
            ITSMSPermission__c permissionRecord =  matrixController.LstPermissions[0];
            permissionRecord.user__c = UserInfo.getUserId();
            permissionRecord.ReadOnly__c = true;
            matrixController.savePermission();
            // validate the permission saved successfully
            system.assertEquals(1, matrixController.lstSavedPermissions.size());
            
            // set the user field as a duplicate
            ITSMSPermission__c permissionRecord2 =  matrixController.LstPermissions[1];
            permissionRecord2.user__c = UserInfo.getUserId();
            permissionRecord2.ReadOnly__c = true;
            matrixController.savePermission();              

            // set the selected field of one the saved permission rows and delete
            matrixController.lstSavedPermissions[0].selected = true; 
            matrixController.DeleteSelectedPermission();
            // validate the permission deleted successfully
            //system.assertEquals(0, matrixController.lstSavedPermissions.size());
            // Note: assert fails, still need to figure out why selected cases are not being deleted
            Test.stopTest();
                        
        } 
    }

    // Coverage for ITSMSCaseUpdate
    static testMethod void testCaseUpdateCheckParent() {          
        ITSMSTestDataSetup.createTestConstants();
        ITSMSTestDataSetup.createAdmins();
        User admin = [Select Id, FirstName from User where FirstName = 'Admin' limit 1];
        system.runAs(admin) {
        	// create test data - requestor, requestedFor, delegate
        	ITSMSTestDataSetup.createRequestor();
        	User requestor = [select Id, FirstName from User where FirstName = 'Requestor']; 
        	Contact requestorContact = [Select Id, ContactUser__c, FirstName from Contact where ContactUser__c =: requestor.Id];
        	User admin2 = [Select Id, FirstName from User where FirstName = 'Admin2' limit 1];
            system.runAs(admin2) {
                // create - parent case as Submitted
                ITSMSTestDataSetup.createNewHireToSubmit();
                Case parentCase = [Select Id, CreatedById from Case where FirstName__c = 'Submitted' and LastName__c = 'Employee'];
                // flag as parent, take ownership 
                parentCase.Requestor__c = requestor.Id;
                parentCase.ContactId = requestorContact.Id;
                parentCase.FirstName__c ='Parent';
                parentCase.Subject = 'test parent';
                parentCase.Status = ITSMSConstants.NEWHIRE_STATUS_SUBMIT;
                parentCase.OwnerId = requestor.Id;
                system.debug('@@ ready to update parent:'+parentCase);
                update parentCase;       
                // create - child case as Submitted
                ITSMSTestDataSetup.createNewHireToSubmit();
                Case childCase = [Select Id, CreatedById from Case where FirstName__c = 'Submitted' and LastName__c = 'Employee'];
                // flag as child
                childCase.FirstName__c ='Child';
                childCase.ParentId = parentCase.Id;
                childCase.Status = ITSMSConstants.NEWHIRE_STATUS_SUBMIT;
                childCase.Subject = 'test child';
                childCase.Requestor__c = requestor.Id;
                childCase.ContactId = requestorContact.Id;
                update childCase;       
                //*** start test
                Test.startTest();
                // set child to assigned
                childCase.Status = 'Assigned';
                childCase.OwnerId = requestor.Id;
                update childCase;
                // verify parent is 'in progress'
                parentCase = ITSMSUtilityClass.getExistingCase(ITSMSConstants.NEWHIRE_QUERY +' from Case where Id = :inputCaseId', parentCase.Id);
                system.debug('@@ test parent:'+parentCase);
                system.assertEquals(parentCase.Status,'In Progress');
                // set child to closed
                childCase.Status = 'Closed';
                update childCase;
                // verify parent is 'closed'
                parentCase = ITSMSUtilityClass.getExistingCase(ITSMSConstants.NEWHIRE_QUERY +' from Case where Id = :inputCaseId', parentCase.Id);
                system.debug('@@ test parent:'+parentCase);
                system.assertEquals(parentCase.Status,'Closed');
            }
        }
    }

    // test coverage for ITSMSCaseUpdate
    static testMethod void testCaseUpdateSetTeam() {          
        ITSMSTestDataSetup.createTestConstants();
        // create test data - requestor, requestedFor, delegates
        ITSMSTestDataSetup.createRequestor();
        User communityUser = [select Id,  Delegate__c from User where FirstName = 'Community'];
        User requestor = [select Id,  Delegate__c from User where FirstName = 'Requestor' and LastName = 'Creator'];
        User requestedFor = [select Id,  Delegate__c from User where FirstName = 'Requested' and LastName = 'ForUser'];
        system.debug('@@ communityUser:'+communityUser.Id);
        system.debug('@@ communityUser delegate:'+communityUser.Delegate__c);
        system.debug('@@ requestor:'+requestor.Id);
        system.debug('@@ requestor delegate:'+requestor.Delegate__c);
        system.debug('@@ requestedFor:'+requestedFor.Id);
        system.debug('@@ requestedFor delegate:'+requestedFor.Delegate__c);
        
        system.runAs (communityUser)
        {
            // create test case for requestor
            ITSMSTestDataSetup.createNewHireToSubmit();
            Case testCase1 = [Select Id, CreatedById, Requestor__c, RequestingForUser__c from Case where FirstName__c = 'Submitted' and LastName__c = 'Employee'];
            testCase1.Subject = 'TestingCaseTeam1';
            testCase1.Requestor__c = requestor.Id;
            list<Case> testCases = new list<Case> ();
            testCases.add(testCase1);
            // create test case for requested for
            ITSMSTestDataSetup.createNewHirePending();
            Case testCase2 = [Select Id, CreatedById, Requestor__c, RequestingForUser__c from Case where FirstName__c = 'Pending' and LastName__c = 'Employee'];
            // set Requestor, Requested For 
            testCase2.Subject = 'TestingCaseTeam2';
            testCase2.RequestingForUser__c = requestedFor.Id;
            testCases.add(testCase2);
            //*** start test
            ITSMSUtilityClass.hasTeamUpdateOccurred = false;
            Test.startTest();
            update testCases;       
            list<Case> testCasesA = [Select Id, ParentId, CreatedById, Requestor__c, RequestingForUser__c, Requestor__r.Delegate__c, RequestingForUser__r.Delegate__c from Case ];
            system.debug('@@ case after update:'+testCasesA);
            // verify case teams
            list<CaseTeamMember> caseTeamMembers = [Select Id, ParentId, MemberId, TeamRoleId from CaseTeamMember ];
            boolean foundCreatorDelegate = false;
            boolean foundRequestedFor = false;
            boolean foundRequestedForDelegate = false;
            boolean foundRequestor = false;
            boolean foundRequestorDelegate = false;
            system.debug('@@ test case team members:'+caseTeamMembers);
            for (CaseTeamMember ct: caseTeamMembers)
            {
                if (ct.ParentId == testCase1.Id && ct.MemberId == communityUser.Delegate__c)
                    foundCreatorDelegate = true;
                if (ct.ParentId == testCase1.Id && ct.MemberId == requestor.Id)
                    foundRequestor = true;
                if (ct.ParentId == testCase1.Id && ct.MemberId == requestor.Delegate__c)
                    foundRequestorDelegate = true;
                if (ct.ParentId == testCase2.Id && ct.MemberId == requestedFor.Id)
                    foundRequestedFor = true;
                if (ct.ParentId == testCase2.Id && ct.MemberId == requestedFor.Delegate__c)
                    foundRequestedForDelegate = true;
            }
            system.assertEquals(foundCreatorDelegate,true);
            system.assertEquals(foundRequestedFor,true);
            system.assertEquals(foundRequestedForDelegate,true);
            system.assertEquals(foundRequestor,true);
            system.assertEquals(foundRequestorDelegate,true);
        }
    }

    // test coverage for ITSMSCaseUpdate
    static testMethod void testChangeUserDelegate() {          
        ITSMSTestDataSetup.createTestConstants();
        // create test data - requestor, requestedFor, delegates
        ITSMSTestDataSetup.createRequestor();
        User communityUser = [select Id,  Delegate__c from User where FirstName = 'Community'];
        User requestor = [select Id,  Delegate__c from User where FirstName = 'Requestor' and LastName = 'Creator'];
        User requestedFor = [select Id,  Delegate__c from User where FirstName = 'Requested' and LastName = 'ForUser'];
        
        system.runAs (communityUser)
        {
            ITSMSUtilityClass.hasTeamUpdateOccurred = false;
             // create - case 
            ITSMSTestDataSetup.createNewHirePending();
            Case testCase = [Select Id, CreatedById, Requestor__c, RequestingForUser__c from Case where FirstName__c = 'Pending' and LastName__c = 'Employee'];
            // set Requestor
            testCase.Subject = 'TestingCaseTeam1';
            testCase.Requestor__c = requestor.Id;
            //*** start test
            ITSMSUtilityClass.hasTeamUpdateOccurred = false;
            Test.startTest();
            update testCase;       
            testCase = [Select Id, CreatedById, Requestor__c, RequestingForUser__c, Requestor__r.Delegate__c, RequestingForUser__r.Delegate__c from Case limit 1];
            system.debug('@@ case after update:'+testCase);
            // verify case team
            list<CaseTeamMember> caseTeamMembers = [Select Id, MemberId, TeamRoleId from CaseTeamMember where ParentId =:testCase.Id];
            boolean foundCreatorDelegate = false;
            boolean foundRequestor = false;
            boolean foundRequestorDelegate = false;
            system.debug('@@ test case team members:'+caseTeamMembers);
            for (CaseTeamMember ct: caseTeamMembers)
            {
                if (ct.MemberId == communityUser.Delegate__c)
                    foundCreatorDelegate = true;
                if (ct.MemberId == requestor.Id)
                    foundRequestor = true;
                if (ct.MemberId == requestor.Delegate__c)
                    foundRequestorDelegate = true;
            }
            system.assertEquals(foundCreatorDelegate,true);
            system.assertEquals(foundRequestor,true);
            system.assertEquals(foundRequestorDelegate,true);
            // change delegate for Requestor 
            ITSMSUtilityClass.hasDelegateUpdateOccurred = false;
            system.runAs (requestor)
            {
                User requestorUser = [Select Id, Delegate__c from User where Id = :requestor.Id limit 1];
                string delegateBefore = requestorUser.Delegate__c;
                requestorUser.Delegate__c = requestedFor.Delegate__c;
                update requestorUser;
                list<CaseTeamMember> caseTeamAfter = [Select Id, ParentId, MemberId from CaseTeamMember];
            }
        
        }
    }
    
    // test coverage for ITSMSCommunitiesLandingController
    private static testMethod void testCommunitiesLanding() {
        ITSMSTestDataSetup.createTestConstants();
        ITSMSTestDataSetup.createRequestor();
        User requestor = [select Id, ManagerId from User where FirstName = 'Requestor'];
        system.runAs (requestor)
        {
            //*** start test
            Test.startTest();
            ITSMSCommunitiesLandingController clc = new ITSMSCommunitiesLandingController(); 
            ApexPages.currentPage().getParameters().put('startURL', 'testing');
            clc.forwardToStartPage();
            ITSMSCommunitiesLandingController.getKeyURL('This should throw an exception');
            system.debug('@@ page returned:'+ApexPages.currentPage() );
        }
    }

    
    // coverage for ITSMSComponentControllerBase
    static testMethod void testComponentControllerBase() {
        ITSMSTestDataSetup.createTestConstants();
        Test.startTest();
        PageReference pageRef= Page.ITSMSSupportRequest;
        Test.setCurrentPage(pageRef);
        ITSMSComponentControllerBase base = new ITSMSComponentControllerBase();
        //-- verify controller
        base.key = 'Testing' ;
        base.pageController = new ITSMSPageControllerBase();
        base.key = 'Testing2' ;
        system.debug('@@ section titles"'+base.sectionConferencing+' '+base.sectionEmailSecurity+' '+base.sectionFolderShare+' '+base.sectionMobilityAgreement+' '+base.sectionMobilityLoan+' '+base.sectionMobilityNewUpgrade+' '+base.sectionMobilityTransfer+' '+base.sectionOracle);
        system.debug('@@ section titles"'+base.sectionPartPeripheral+' '+base.sectionServerVM+' '+base.sectionServiceAccount+' '+base.sectionSharedMailbox+' '+base.sectionSharepoint+' '+base.sectionSoftware+' '+base.sectionSoftwareFisheye+' '+base.sectionSoftwareJIRA);
        system.assertNotEquals(null,base.sectionConferencing);
        system.assertNotEquals(null,base.sectionEmailSecurity);
        system.assertNotEquals(null,base.sectionFolderShare);
        system.assertNotEquals(null,base.sectionMobilityAgreement);
        system.assertNotEquals(null,base.sectionMobilityLoan);
        system.assertNotEquals(null,base.sectionMobilityNewUpgrade);
        system.assertNotEquals(null,base.sectionMobilityTransfer);
        system.assertNotEquals(null,base.sectionOracle);
        system.assertNotEquals(null,base.sectionPartPeripheral);
        system.assertNotEquals(null,base.sectionServerVM);
        system.assertNotEquals(null,base.sectionServiceAccount);
        system.assertNotEquals(null,base.sectionSharedMailbox);
        system.assertNotEquals(null,base.sectionSharepoint);
        system.assertNotEquals(null,base.sectionSoftware);
        system.assertNotEquals(null,base.sectionSoftwareFisheye);
        system.assertNotEquals(null,base.sectionSoftwareJIRA);
        system.assertNotEquals(null,base.sectionSoftwareJenkins);
        system.assertNotEquals(null,base.sectionSoftwareOther);
        system.assertNotEquals(null,base.sectionSoftwareWIKI);
        system.assertNotEquals(null,base.sectionStorage);
        system.assertNotEquals(null,base.sectionWorkstation);
        base.componentToPage = new ITSMSComponentToController();
        base.componentToPage.inputSupportCategory = 'Access';
        base.componentToPage.inputCaseId = null;
        base.componentToPage.setCaseRec(base.componentToPage.inputSupportCategory, base.componentToPage.inputCaseId);
        base.formatCaseRec();
        base.cancelAdd();
    }

    // coverage for ITSMSComponentToController
    static testMethod void testComponentToController() {          
        ITSMSTestDataSetup.createTestConstants();
        //*** start test
        Test.startTest();
        ITSMSComponentToController c = new ITSMSComponentToController();
        c.notSubmitted = true;
        c.isNewRequest = true;
        c.isNewCaseForRequest = true;
        c.showSubmitAll = true;
        c.isGeneralCase = true;
        c.childCasesExist = false;
        c.inputCaseId = null;
        c.parentId = null;
        c.inputSupportCategory = 'test';
        c.caseToEdit = 'test';
        c.caseToDelete= 'test';
        c.childCases = new list <Case> ();
        c.errorRows = new map <Integer, String>();
        Case testCase = c.setCaseRec('test',null);
        c.initRequestChildCases();
        c.saveCase();
        //PageReference pageRef = c.submitCases();
        Case thisCase = c.getCaseRec();
    }

    // coverage for ITSMSConferencingComponentController
    static testMethod void testConferencingComponentSave() {          
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
            ITSMSConferencingComponentController ccc = new ITSMSConferencingComponentController();
            //-- verify controller
            ccc.caseRec = ITSMSUtilityClass.createCase('Conferencing','Test');
            ccc.pageController = new ITSMSPageControllerBase ();
            ccc.key = 'testing';
            ccc.componentToPage = new ITSMSComponentToController ();
            ccc.caseRec.IssueOrRequest__c = 'Request';
            ccc.caseRec.ManagerUser__c = communityUser.Delegate__c;
            ccc.caseRec.EventTitle__c = 'Testing';
            ccc.caseRec.Description = 'Testing';
            ccc.caseRec.ConferenceRoomSetupTime__c = system.Now();
            ccc.caseRec.StartDateTime__c = system.Now();
            ccc.caseRec.EndDateTime__c = system.Now();
            ccc.caseRec.Attendees__c = 3;
            ccc.caseRec.VTCRoom__c = 'Testing';
            ccc.caseRec.WebExRequired__c = 'Yes';
            ccc.caseRec.WebExMeetingNumber__c = 'Testing';
            ccc.caseRec.HostPasscode__c = 'Testing';
            ccc.caseRec.WebexInformation__c = 'Testing';
            ccc.saveOnly();
            list<Case> testCases = [Select Id, Subject, Status, ParentId from Case];
            system.debug('@@ after save:'+testCases);
            // verify 2 cases created and status is 'Pending Submission'
            system.assertEquals(testCases.size(),2);
            system.assertEquals(testCases[0].Status,'Pending Submission');
            system.assertEquals(testCases[1].Status,'Pending Submission');
            ccc.saveAndNew();
            testCases = [Select Id, Subject, Status, ParentId from Case];
            ccc.caseRec.EventTitle__c = 'Testing';
            ccc.caseRec.Description = 'Testing';
            ccc.caseRec.ConferenceRoomSetupTime__c = system.Now();
            ccc.caseRec.StartDateTime__c = system.Now();
            ccc.caseRec.EndDateTime__c = system.Now();
            ccc.caseRec.Attendees__c = 3;
            ccc.caseRec.VTCRoom__c = 'Testing';
            ccc.caseRec.WebExRequired__c = 'Yes';
            ccc.caseRec.WebExMeetingNumber__c = 'Testing';
            ccc.caseRec.HostPasscode__c = 'Testing';
            ccc.caseRec.WebexInformation__c = 'Testing';
            ccc.componentToPage.childCases = [Select Id, Status, ParentId from Case];
            ccc.componentToPage.parentId = null;
            ccc.cancelCase();
            testCases = [Select Id, Subject, Status, ParentId from Case];
            system.debug('@@ after cancel:'+testCases);
            // verify 2 cases created and status is 'Pending Submission'
        }           
     }

    // coverage for ITSMSConferencingComponentController
    static testMethod void testConferencingComponentSubmit() {          
        ITSMSTestDataSetup.createTestConstants();
        // create test data - requestor, requestedFor, delegates
        ITSMSTestDataSetup.createRequestor();
        User communityUser = [select Id,  Delegate__c from User where FirstName = 'Community'];
        Contact communityContact = [Select Id, FirstName, ContactUser__c from Contact where ContactUser__c =: communityUser.Id Limit 1];
        system.runAs (communityUser)
        {
            //*** start test
            Test.startTest();
            PageReference pageRef= Page.ITSMSSupportRequest;
            Test.setCurrentPage(pageRef);
            ITSMSConferencingComponentController ccc = new ITSMSConferencingComponentController();
            //-- verify controller
            ccc.caseRec = ITSMSUtilityClass.createCase('Conferencing','Test');
            ccc.pageController = new ITSMSPageControllerBase ();
            ccc.key = 'testing';
            ccc.componentToPage = new ITSMSComponentToController ();
            ccc.caseRec.IssueOrRequest__c = 'Request';
            ccc.caseRec.EventTitle__c = 'Testing';
            ccc.caseRec.Description = 'Testing';
            ccc.caseRec.ConferenceRoomSetupTime__c = system.Now();
            ccc.caseRec.StartDateTime__c = system.Now();
            ccc.caseRec.EndDateTime__c = system.Now();
            ccc.caseRec.Attendees__c = 3;
            ccc.caseRec.VTCRoom__c = 'Testing';
            ccc.caseRec.WebExRequired__c = 'Yes';
            ccc.caseRec.WebExMeetingNumber__c = 'Testing';
            ccc.caseRec.HostPasscode__c = 'Testing';
            ccc.caseRec.WebexInformation__c = 'Testing';
            ccc.caseRec.ContactId  = communityContact.Id;
            list<case> testcasesN =[Select Id, CaseNumber, Status, ParentId from Case];
            system.debug('@@ cases before:'+testcasesN);
            ccc.saveAndSubmit();
            String sysadmProfileId = [Select Id from Profile WHERE Name = 'System Administrator'].Id;
            User sysAdmin = [Select Id from User where ProfileId = :sysadmProfileId and IsActive = true limit 1];
            system.runAs (sysAdmin) 
            {
                list<Case> testCases = [Select Id, Subject, Status, ParentId from Case];
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

    // coverage for ITSMSSupportCenterContactUsController    
    static testMethod void testContactUsController(){
		ITSMSSupportCenterContactUsController contactUsController = new ITSMSSUpportCenterContactUsController();
    }    

    static testMethod void testContactUsInfoController(){
       ITSMSTestDataSetup.createTestConstants();
       ITSMSTestDataSetup.createAdmins();
        User admin = [SELECT Id, firstname FROM User WHERE firstname = 'knowledgeAdmin' ];    
        
        test.startTest();
        System.runAs(admin){
            LIST<String> sections = new LIST<String> {'Hours','Phone Number','Email','IT Support Personnel'};
            LIST<String> summaries = new LIST<String> {'5 a.m. to 12 a.m.', '1234567890','testEmail@test.com','test'};
            LIST<String> urls = new LIST<String>{'testURL1@test.com','testURL2@test.com','testUR3L@test.com','testURL4@test.com'};
            Integer numOfSections = sections.size();
            LIST<ITSMS__kav> contactArticles = new LIST<ITSMS__kav>();
            for(Integer i = 0; i < numOfSections ; i++){            
                ITSMS__kav contactArticle = new ITSMS__kav(Title = 'test article' + i, 
                                                         Summary = 'test summary ' + i, 
                                                         URL__c = 'testURL' + i, 
                                                         UrlName = 'testURLName' + i, 
                                                         Section__c = sections[i], 
                                                         Area__c = 'Contact Us',
                                                         Language = 'en_US',
                                                         IsVisibleInPkb = true,
                                                         IsVisibleInCsp = true                                                     
                                                         );                                                                                                                
                contactArticles.add(contactArticle);
            }                
                                               
            insert contactArticles;                                                
                        
            
            for(ITSMS__kav i: contactArticles){
                ITSMS__kav a = [SELECT KnowledgeArticleId FROM ITSMS__kav WHERE Id = :i.Id LIMIT 1];
                System.debug('@@ contactArticle: ' + i.Title + ' Area: ' + i.Area__c + ' Section: ' + i.Section__c);
                KbManagement.PublishingService.publishArticle(a.KnowledgeArticleId, true);   
            }                      
            ITSMSContactUsInfoComponentController cuc = new ITSMSContactUsInfoComponentController();        
            system.debug('@@ contact us email:'+ cuc.contactUsEmail);            
            system.debug('@@ contact us hours:'+ cuc.contactUsHours);          
            system.debug('@@ contact us phone:'+ cuc.contactUsPhone); 
            system.debug('@@ contact us support:'+ cuc.contactUsSupport);           
            test.stopTest();
        }
    }
    // coverage for ITSMSEmailSecurityComponentController
    static testMethod void testEmailSecComponentSave() {          
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
            ITSMSEmailSecurityComponentController ccc = new ITSMSEmailSecurityComponentController();
            //-- verify controller
            ccc.caseRec = ITSMSUtilityClass.createCase('Access','Email/Security Group');
            ccc.pageController = new ITSMSPageControllerBase ();
            ccc.key = 'testing';
            ccc.componentToPage = new ITSMSComponentToController ();
            ccc.caseRec.IssueOrRequest__c = 'Request';
            ccc.caseRec.ManagerUser__c = communityUser.Delegate__c;
            ccc.caseRec.AccessState__c = 'New';
            ccc.caseRec.AccessType__c = ITSMSConstants.EMAILSEC_ACCESS_SECURITY;
            ccc.caseRec.GroupName__c = 'Testing';
            ccc.caseRec.EmailAddress__c = 'Test@test.com';
            ccc.caseRec.AvailableToOutsideUsers__c = 'No';
            ccc.caseRec.JustificationRequest__c = 'Testing';
            ccc.saveOnly();
            list<Case> testCases = [Select Id, Subject, Status, ParentId from Case];
            system.debug('@@ after save:'+testCases);
            // verify 2 cases created and status is 'Pending Submission'
            system.assertEquals(testCases.size(),2);
            system.assertEquals(testCases[0].Status,'Pending Submission');
            system.assertEquals(testCases[1].Status,'Pending Submission');
            ccc.caseRec.IssueOrRequest__c = 'Request';
            ccc.caseRec.ManagerUser__c = communityUser.Delegate__c;
            ccc.caseRec.AccessState__c = 'Existing';
            ccc.caseRec.AccessType__c = 'Test';
            ccc.caseRec.GroupName__c = 'Testing';
            ccc.caseRec.EmailAddress__c = 'Test@test.com';
            ccc.caseRec.AvailableToOutsideUsers__c = 'No';
            ccc.caseRec.JustificationRequest__c = 'Testing';
            ccc.saveAndNew();
            ccc.cancelCase();
            testCases = [Select Id, Subject, Status, ParentId from Case];
            system.debug('@@ after cancel:'+testCases);
        }           
     }

    // coverage for ITSMSEmailSecurityComponentController
    static testMethod void testEmailSecSubmit() {          
        ITSMSTestDataSetup.createTestConstants();
        // create test data - requestor, requestedFor, delegates
        ITSMSTestDataSetup.createRequestor();
        User communityUser = [select Id,  Delegate__c from User where FirstName = 'Community'];
        Contact communityContact = [Select Id, FirstName, ContactUser__c from Contact where ContactUser__c =: communityUser.Id Limit 1];
        system.runAs (communityUser)
        {
            //*** start test
            Test.startTest();
            PageReference pageRef= Page.ITSMSSupportRequest;
            Test.setCurrentPage(pageRef);
            ITSMSEmailSecurityComponentController ccc = new ITSMSEmailSecurityComponentController();
            //-- verify controller
            ccc.caseRec = ITSMSUtilityClass.createCase('Access','Email/Security Group');
            ccc.pageController = new ITSMSPageControllerBase ();
            ccc.key = 'testing';
            ccc.componentToPage = new ITSMSComponentToController ();
            ccc.caseRec.IssueOrRequest__c = 'Request';
            ccc.caseRec.ManagerUser__c = communityUser.Delegate__c;
            ccc.caseRec.AccessState__c = 'New';
            ccc.caseRec.AccessType__c = ITSMSConstants.EMAILSEC_ACCESS_SECURITY;
            ccc.caseRec.GroupName__c = 'Testing';
            ccc.caseRec.EmailAddress__c = 'Test@test.com';
            ccc.caseRec.AvailableToOutsideUsers__c = 'No';
            ccc.caseRec.JustificationRequest__c = 'Testing';
            ccc.caseRec.ContactId  = communityContact.Id;
            ccc.saveOnly();
            ccc.saveAndSubmit();
            String sysadmProfileId = [Select Id from Profile WHERE Name = 'System Administrator'].Id;
            User sysAdmin = [Select Id from User where ProfileId = :sysadmProfileId and IsActive = true limit 1];
            system.runAs (sysAdmin) 
            {
                list<Case> testCases = [Select Id, Subject, Status, ParentId from Case];
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

   // coverage for ITSMSFeedbackCaseComponentController
   static testMethod void testFeedbackCasePage(){     
        
        ITSMSTestDataSetup.createTestConstants();
        //ITSMSTestDataSetup.createPortalUser();
        ITSMSTestDataSetup.createRequestor();
        User communityUser = [select Id,  Delegate__c from User where FirstName = 'Community'];       
        ITSMSFeedbackCaseComponentController feedbackCaseController = new ITSMSFeedbackCaseComponentController();            
        test.startTest();
        system.runAs (communityUser){                        
            feedbackCaseController.submitFeedbackCase();            
        }    
        feedbackCaseController.submitFeedbackCase();
        Case testCase=[Select Id, Status, Subject from Case where CreatedbyId = :communityUser.Id limit 1];
        system.assertEquals(testCase.Status,'New');
        test.stopTest(); 
    }

    // coverage for ITSMSFolderShareComponentController 
    static testMethod void testFolderShareComponentSave() {          
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
            ITSMSFolderShareComponentController ccc = new ITSMSFolderShareComponentController();
            //-- verify controller
            ccc.caseRec = ITSMSUtilityClass.createCase('Access','Folder/Share');
            ccc.pageController = new ITSMSPageControllerBase ();
            ccc.key = 'testing';
            ccc.componentToPage = new ITSMSComponentToController ();
            ccc.caseRec.IssueOrRequest__c = 'Request';
            ccc.caseRec.ManagerUser__c = communityUser.Delegate__c;
            ccc.caseRec.AccessState__c = 'New';
            ccc.caseRec.AccessType__c = 'Folder';
            ccc.caseRec.ListNetworkDirectory__c = 'Testing';
            ccc.caseRec.JustificationRequest__c = 'Testing';
            ccc.saveOnly();
            list<Case> testCases = [Select Id, Subject, Status, ParentId from Case];
            system.debug('@@ after save:'+testCases);
            // verify 2 cases created and status is 'Pending Submission'
            system.assertEquals(testCases.size(),2);
            system.assertEquals(testCases[0].Status,'Pending Submission');
            system.assertEquals(testCases[1].Status,'Pending Submission');
            ccc.caseRec.IssueOrRequest__c = 'Request';
            ccc.caseRec.ManagerUser__c = communityUser.Delegate__c;
            ccc.caseRec.AccessState__c = 'Existing';
            ccc.caseRec.AccessType__c = 'Test';
            ccc.caseRec.ListNetworkDirectory__c = 'Testing';
            ccc.caseRec.JustificationRequest__c = 'Testing';
            ccc.saveAndNew();
            ccc.cancelCase();
            testCases = [Select Id, Subject, Status, ParentId from Case];
            system.debug('@@ after cancel:'+testCases);
        }           
     }

    // coverage for ITSMSFolderShareComponentController 
    static testMethod void testFolderShareSubmit() {          
        ITSMSTestDataSetup.createTestConstants();
        // create test data - requestor, requestedFor, delegates
        ITSMSTestDataSetup.createRequestor();
        User communityUser = [select Id,  Delegate__c from User where FirstName = 'Community'];
        Contact communityContact = [Select Id, FirstName, ContactUser__c from Contact where ContactUser__c =: communityUser.Id Limit 1];
        system.runAs (communityUser)
        {
            //*** start test
            Test.startTest();
            PageReference pageRef= Page.ITSMSSupportRequest;
            Test.setCurrentPage(pageRef);
            ITSMSFolderShareComponentController ccc = new ITSMSFolderShareComponentController();
            //-- verify controller
            ccc.caseRec = ITSMSUtilityClass.createCase('Access','Folder/Share');
            ccc.pageController = new ITSMSPageControllerBase ();
            ccc.key = 'testing';
            ccc.componentToPage = new ITSMSComponentToController ();
            ccc.caseRec.IssueOrRequest__c = 'Request';
            ccc.caseRec.ManagerUser__c = communityUser.Delegate__c;
            ccc.caseRec.AccessState__c = 'Existing';
            ccc.caseRec.AccessType__c = 'Test';
            ccc.caseRec.ListNetworkDirectory__c = 'Testing';
            ccc.caseRec.JustificationRequest__c = 'Testing';
            ccc.caseRec.ContactId  = communityContact.Id;
            ccc.saveOnly();
            ccc.saveAndSubmit();
            String sysadmProfileId = [Select Id from Profile WHERE Name = 'System Administrator'].Id;
            User sysAdmin = [Select Id from User where ProfileId = :sysadmProfileId and IsActive = true limit 1];
            system.runAs (sysAdmin) 
            {
                list<Case> testCases = [Select Id, Subject, Status, ParentId from Case];
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

    // coverage for ITSMSFormsComponentController 
    static testMethod void testFormsComp() {          
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
            ITSMSFormsComponentController ccc = new ITSMSFormsComponentController();
            //-- verify controller
            ccc.pageController = new ITSMSPageControllerBase ();
            ccc.key = 'testing';
            ccc.componentToPage = new ITSMSComponentToController ();
            ccc.caseRec = ITSMSUtilityClass.createCase('Access','Folder/Share');
        }           
     }

    // coverage for ITSMSIssueComponentController 
   static testMethod void testIssueComp() {          
        ITSMSTestDataSetup.createTestConstants();
        // create test data - requestor, requestedFor, delegates
        ITSMSTestDataSetup.createRequestor();
        User communityUser = [select Id,  Delegate__c from User where FirstName = 'Community'];
        Contact communityContact = [Select Id, FirstName, ContactUser__c from Contact where ContactUser__c =: communityUser.Id Limit 1];
        system.runAs (communityUser)
        {
            //*** start test
            Test.startTest();
            PageReference pageRef= Page.ITSMSSupportRequest;
            Test.setCurrentPage(pageRef);
            ITSMSIssueComponentController ccc = new ITSMSIssueComponentController();
            //-- verify controller
            ccc.pageController = new ITSMSPageControllerBase ();
            ccc.key = 'testing';
            ccc.componentToPage = new ITSMSComponentToController ();
            ccc.caseRec = ITSMSUtilityClass.createCase('Access','Issue');
            ccc.componentToPage.caseRec = ccc.caseRec;
            ccc.caseRec.IssueOrRequest__c = 'Issue';
            ccc.caseRec.Description = 'Testing';
            ccc.caseRec.ScreenshotsAttached__c = 'Yes';
            ccc.caseRec.ContactId  = communityContact.Id;
            ccc.addingAttachment();
            Case testCase = [Select Id, Status, Type, ServiceRequestType__c from Case limit 1];
            system.debug('@@ case will exist:'+ccc.caseRec);
            system.assertEquals(testCase.Status, 'Pending Submission');
            PageReference pageRef2 = ccc.submitAndNew();
            testCase = [Select Id, Status, Type, ServiceRequestType__c from Case limit 1];
            system.debug('@@ after submit and new:'+testCase);
            system.assertEquals(testCase.Status, 'New');
            ccc.caseRec.IssueOrRequest__c = 'Issue';
            ccc.caseRec.Description = 'Testing';
            ccc.caseRec.ScreenshotsAttached__c = 'Yes';
            PageReference pageRef3 = ccc.submitOnly();
            List<Case> testCases = [Select Id, Status, Type, ServiceRequestType__c from Case];
            system.debug('@@ after submit only:'+testCases);
            system.assertEquals(testCases.size(),2);
            PageReference pageRef4 = ccc.cancelCase();
            system.debug('@@ after cancel:'+pageRef4);
            system.assert(pageRef4.getUrl().contains('Home'));
            // negative test - failure on submit
            ITSMSIssueComponentController ccc2 = new ITSMSIssueComponentController();
            ccc2.pageController = new ITSMSPageControllerBase ();
            ccc2.key = 'testing';
            ccc2.componentToPage = new ITSMSComponentToController ();
            ccc2.caseRec = ITSMSUtilityClass.createCase('General','Issue');
            ccc2.componentToPage.caseRec = ccc.caseRec;
            ccc2.caseRec.IssueOrRequest__c = 'Issue';
            PageReference pageRef5 = ccc2.submitAndNew();
            system.debug('@@ after submit and new:'+pageRef5);
            PageReference pageRef6 = ccc2.submitOnly();
            system.debug('@@ after submit only:'+pageRef6);
        }           
     }

    // coverage for ITSMSLandingPageController 
    static testMethod void testLandingPage() {
        ITSMSTestDataSetup.createTestConstants();
            Test.startTest();
            PageReference pageRef= Page.ITSMSSupportCenterLandingPage;
            Test.setCurrentPage(pageRef);
            ApexPages.currentPage().getParameters().put('tab', 'Request_Help');
            ITSMSLandingPageController lpc1 = new ITSMSLandingPageController();
            lpc1.requestHelp();
            system.assertEquals(lpc1.RequestHelpCSS,'active');

            ApexPages.currentPage().getParameters().put('tab', 'My_Cases');
            ITSMSLandingPageController lpc2 = new ITSMSLandingPageController();
            lpc2.MyCases();
            system.debug('@@ lpc2:'+lpc2.MyCasesCSS);
            system.assertEquals(lpc2.MyCasesCSS,'active');

            ApexPages.currentPage().getParameters().put('tab', 'My_New_Team_Members');
             ITSMSLandingPageController lpc3 = new ITSMSLandingPageController();
            lpc3.MyNewHires();
            system.assertEquals(lpc3.MyNewHiresCSS,'active');

            ApexPages.currentPage().getParameters().put('tab', ' ');
            ITSMSLandingPageController lpc4 = new ITSMSLandingPageController();
            system.assertEquals(lpc4.RequestHelpCSS,'active');
        }

    // coverage for ITSMSMobilityAgreementCompController 
    static testMethod void testMobilityAgreeSave() {          
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
            ITSMSMobilityAgreementCompController ccc = new ITSMSMobilityAgreementCompController();
            //-- verify controller
            ccc.caseRec = ITSMSUtilityClass.createCase('Mobility','Corporate Email Agreement');
            ccc.pageController = new ITSMSPageControllerBase (); 
            ccc.key = 'testing';
            ccc.componentToPage = new ITSMSComponentToController ();
            ccc.caseRec.IssueOrRequest__c = 'Request';
            ccc.caseRec.ManagerUser__c = communityUser.Delegate__c;
            ccc.caseRec.Date_Needed_By__c = system.today();
            ccc.caseRec.DeptVP__c = communityUser.Delegate__c;
            ccc.caseRec.CostCenterNumber__c = '11111';
            ccc.caseRec.JustificationRequest__c = 'Testing';
            ccc.caseRec.DeviceModel__c = 'Testing';
            ccc.caseRec.ReferenceCaseId__c = 'Testing';
            ccc.caseRec.MEID_IMEINumber__c = 'Testing';
            ccc.caseRec.ICCID_SIMNumber__c = 'Testing';
            ccc.caseRec.SerialNumber__c = 'Testing';
            ccc.caseRec.WhoOwnsDevice__c = 'Testing';
            ccc.caseRec.AcceptMobileTerms__c = true;
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
            ccc.caseRec.CostCenterNumber__c = '11111';
            ccc.caseRec.JustificationRequest__c = 'Testing';
            ccc.caseRec.DeviceModel__c = 'Testing';
            ccc.caseRec.ReferenceCaseId__c = 'Testing';
            ccc.caseRec.MEID_IMEINumber__c = 'Testing';
            ccc.caseRec.ICCID_SIMNumber__c = 'Testing';
            ccc.caseRec.SerialNumber__c = 'Testing';
            ccc.caseRec.WhoOwnsDevice__c = 'Testing';
            ccc.caseRec.AcceptMobileTerms__c = false;
            ccc.saveAndNew();
            ccc.cancelCase();
            testCases = [Select Id, Subject, Status, ParentId from Case];
            system.debug('@@ after cancel:'+testCases);
        }           
     }

    // coverage for ITSMSMobilityAgreementCompController 
    static testMethod void testMobilityAgreeSubmit() {          
        ITSMSTestDataSetup.createTestConstants();
        // create test data - requestor, requestedFor, delegates
        ITSMSTestDataSetup.createRequestor();
        User communityUser = [select Id,  Delegate__c from User where FirstName = 'Community'];
        Contact communityContact = [Select Id, FirstName, ContactUser__c from Contact where ContactUser__c =: communityUser.Id Limit 1];
        system.runAs (communityUser)
        {
            //*** start test
            Test.startTest();
            PageReference pageRef= Page.ITSMSSupportRequest;
            Test.setCurrentPage(pageRef);
            ITSMSMobilityAgreementCompController ccc = new ITSMSMobilityAgreementCompController();
            //-- verify controller
            ccc.caseRec = ITSMSUtilityClass.createCase('Mobility','Corporate Email Agreement');
            ccc.pageController = new ITSMSPageControllerBase ();
            ccc.key = 'testing';
            ccc.componentToPage = new ITSMSComponentToController ();
            ccc.caseRec.IssueOrRequest__c = 'Request';
            ccc.caseRec.Date_Needed_By__c = system.today();
            ccc.caseRec.DeptVP__c = communityUser.Delegate__c;
            ccc.caseRec.CostCenterNumber__c = '11111';
            ccc.caseRec.JustificationRequest__c = 'Testing';
            ccc.caseRec.DeviceModel__c = 'Testing';
            ccc.caseRec.ReferenceCaseId__c = 'Testing';
            ccc.caseRec.MEID_IMEINumber__c = 'Testing';
            ccc.caseRec.ICCID_SIMNumber__c = 'Testing';
            ccc.caseRec.SerialNumber__c = 'Testing';
            ccc.caseRec.WhoOwnsDevice__c = 'Testing';
            ccc.caseRec.AcceptMobileTerms__c = true;
            ccc.caseRec.ContactId  = communityContact.Id;
            ccc.saveOnly();
            ccc.saveAndSubmit();
            String sysadmProfileId = [Select Id from Profile WHERE Name = 'System Administrator'].Id;
            User sysAdmin = [Select Id from User where ProfileId = :sysadmProfileId and IsActive = true limit 1];
            system.runAs (sysAdmin) 
            {
                list<Case> testCases = [Select Id, Subject, Status, ParentId from Case];
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
    
    // coverage for ITSMSMobilityLoanComponentController 
    static testMethod void testMobilityLoanSave() {          
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
            ITSMSMobilityLoanComponentController ccc = new ITSMSMobilityLoanComponentController();
            //-- verify controller
            ccc.caseRec = ITSMSUtilityClass.createCase('Mobility','Device Loan, International Plan, or USB Tethering');
            ccc.pageController = new ITSMSPageControllerBase ();
            ccc.key = 'testing';
            ccc.componentToPage = new ITSMSComponentToController ();
            ccc.caseRec.IssueOrRequest__c = 'Request';
            ccc.caseRec.ManagerUser__c = communityUser.Delegate__c;
            ccc.caseRec.Date_Needed_By__c = system.today();
            ccc.caseRec.DeptVP__c = communityUser.Delegate__c;
            ccc.caseRec.CostCenterNumber__c = '11111';
            ccc.caseRec.JustificationRequest__c = 'Testing';
            ccc.caseRec.MobileType__c = 'Testing';
            ccc.caseRec.ExistingMobilePhoneNumber__c = 'Testing';
            ccc.caseRec.DepartureDate__c = system.today();
            ccc.caseRec.ReturnDate__c = system.today();
            ccc.caseRec.Destinations__c = 'Testing';
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
            ccc.caseRec.CostCenterNumber__c = '11111';
            ccc.caseRec.JustificationRequest__c = 'Testing';
            ccc.caseRec.MobileType__c = 'Testing';
            ccc.caseRec.ExistingMobilePhoneNumber__c = 'Testing';
            ccc.caseRec.DepartureDate__c = system.today();
            ccc.caseRec.ReturnDate__c = system.today();
            ccc.caseRec.Destinations__c = 'Testing';
            ccc.saveAndNew();
            ccc.cancelCase();
            testCases = [Select Id, Subject, Status, ParentId from Case];
            system.debug('@@ after cancel:'+testCases);
        }           
     }

    // coverage for ITSMSMobilityLoanComponentController 
    static testMethod void testMobilityLoanSubmit() {          
        ITSMSTestDataSetup.createTestConstants();
        // create test data - requestor, requestedFor, delegates
        ITSMSTestDataSetup.createRequestor();
        User communityUser = [select Id,  Delegate__c from User where FirstName = 'Community'];
        Contact communityContact = [Select Id, FirstName, ContactUser__c from Contact where ContactUser__c =: communityUser.Id Limit 1];
        system.runAs (communityUser)
        {
            //*** start test
            Test.startTest();
            PageReference pageRef= Page.ITSMSSupportRequest;
            Test.setCurrentPage(pageRef);
            ITSMSMobilityLoanComponentController ccc = new ITSMSMobilityLoanComponentController();
            //-- verify controller
            ccc.caseRec = ITSMSUtilityClass.createCase('Mobility','Device Loan, International Plan, or USB Tethering');
            ccc.pageController = new ITSMSPageControllerBase ();
            ccc.key = 'testing';
            ccc.componentToPage = new ITSMSComponentToController ();
            ccc.caseRec.IssueOrRequest__c = 'Request';
            ccc.caseRec.Date_Needed_By__c = system.today();
            ccc.caseRec.DeptVP__c = communityUser.Delegate__c;
            ccc.caseRec.CostCenterNumber__c = '11111';
            ccc.caseRec.JustificationRequest__c = 'Testing';
            ccc.caseRec.MobileType__c = 'Testing';
            ccc.caseRec.ExistingMobilePhoneNumber__c = 'Testing';
            ccc.caseRec.DepartureDate__c = system.today();
            ccc.caseRec.ReturnDate__c = system.today();
            ccc.caseRec.Destinations__c = 'Testing';
            ccc.caseRec.ContactId  = communityContact.Id;
            ccc.saveOnly();
            ccc.saveAndSubmit();
            String sysadmProfileId = [Select Id from Profile WHERE Name = 'System Administrator'].Id;
            User sysAdmin = [Select Id from User where ProfileId = :sysadmProfileId and IsActive = true limit 1];
            system.runAs (sysAdmin) 
            {
                list<Case> testCases = [Select Id, Subject, Status, ParentId from Case];
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

    // coverage for ITSMSMobilityNewUpgradeCompController 
    static testMethod void testMobilityNewUpgradeSave() {          
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
            ITSMSMobilityNewUpgradeCompController ccc = new ITSMSMobilityNewUpgradeCompController();
            //-- verify controller
            ccc.caseRec = ITSMSUtilityClass.createCase('Mobility','New/Upgrade Device');
            ccc.pageController = new ITSMSPageControllerBase ();                    
            ccc.key = 'testing';
            ccc.componentToPage = new ITSMSComponentToController ();
            ccc.caseRec.IssueOrRequest__c = 'Request';
            ccc.caseRec.ManagerUser__c = communityUser.Delegate__c;
            ccc.caseRec.Date_Needed_By__c = system.today();
            ccc.caseRec.DeptVP__c = communityUser.Delegate__c;
            ccc.caseRec.CostCenterNumber__c = '11111';
            ccc.caseRec.JustificationRequest__c = 'Testing';
            ccc.caseRec.MobileActionType__c = 'Testing';
            ccc.caseRec.ExistingMobilePhoneNumber__c = 'Testing';
            ccc.caseRec.SelectCarrierModel__c = 'Testing';
            ccc.caseRec.Color__c = 'Testing';
            ccc.caseRec.Accessories__c = 'Testing';
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
            ccc.caseRec.CostCenterNumber__c = '11111';
            ccc.caseRec.JustificationRequest__c = 'Testing';
            ccc.caseRec.MobileActionType__c = 'Testing';
            ccc.caseRec.ExistingMobilePhoneNumber__c = 'Testing';
            ccc.caseRec.SelectCarrierModel__c = 'Testing';
            ccc.caseRec.Color__c = 'Testing';
            ccc.caseRec.Accessories__c = 'Testing';
            ccc.saveAndNew();
            ccc.cancelCase();
            testCases = [Select Id, Subject, Status, ParentId from Case];
            system.debug('@@ after cancel:'+testCases);
        }           
     }

    // coverage for ITSMSMobilityNewUpgradeCompController 
    static testMethod void testMobilityNewUpgradeSubmit() {          
        ITSMSTestDataSetup.createTestConstants();
        // create test data - requestor, requestedFor, delegates
        ITSMSTestDataSetup.createRequestor();
        User communityUser = [select Id,  Delegate__c from User where FirstName = 'Community'];
        Contact communityContact = [Select Id, FirstName, ContactUser__c from Contact where ContactUser__c =: communityUser.Id Limit 1];
        system.runAs (communityUser)
        {
            //*** start test
            Test.startTest();
            PageReference pageRef= Page.ITSMSSupportRequest;
            Test.setCurrentPage(pageRef);
            ITSMSMobilityNewUpgradeCompController ccc = new ITSMSMobilityNewUpgradeCompController();
            //-- verify controller
            ccc.caseRec = ITSMSUtilityClass.createCase('Mobility','New/Upgrade Device');
            ccc.pageController = new ITSMSPageControllerBase ();
            ccc.key = 'testing';
            ccc.componentToPage = new ITSMSComponentToController ();
            ccc.caseRec.IssueOrRequest__c = 'Request';
            ccc.caseRec.Date_Needed_By__c = system.today();
            ccc.caseRec.DeptVP__c = communityUser.Delegate__c;
            ccc.caseRec.CostCenterNumber__c = '11111';
            ccc.caseRec.JustificationRequest__c = 'Testing';
            ccc.caseRec.MobileActionType__c = 'Testing';
            ccc.caseRec.ExistingMobilePhoneNumber__c = 'Testing';
            ccc.caseRec.SelectCarrierModel__c = 'Testing';
            ccc.caseRec.Color__c = 'Testing';
            ccc.caseRec.Accessories__c = 'Testing';
            ccc.saveOnly();
            ccc.saveAndSubmit();
            ccc.caseRec.ContactId  = communityContact.Id;
            String sysadmProfileId = [Select Id from Profile WHERE Name = 'System Administrator'].Id;
            User sysAdmin = [Select Id from User where ProfileId = :sysadmProfileId and IsActive = true limit 1];
            system.runAs (sysAdmin) 
            {
                list<Case> testCases = [Select Id, Subject, Status, ParentId from Case];
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

    // coverage for ITSMSMobilityTransferCompController 
    static testMethod void testMobilityTransferSave() {          
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
            ITSMSMobilityTransferCompController ccc = new ITSMSMobilityTransferCompController();
            //-- verify controller
            ccc.caseRec = ITSMSUtilityClass.createCase('Mobility','Transfer Service from Personal account');
            ccc.pageController = new ITSMSPageControllerBase ();
            ccc.key = 'testing';
            ccc.componentToPage = new ITSMSComponentToController ();
            ccc.caseRec.IssueOrRequest__c = 'Request';
            ccc.caseRec.ManagerUser__c = communityUser.Delegate__c;
            ccc.caseRec.Date_Needed_By__c = system.today();
            ccc.caseRec.DeptVP__c = communityUser.Delegate__c;
            ccc.caseRec.CostCenterNumber__c = '11111';
            ccc.caseRec.JustificationRequest__c = 'Testing';
            ccc.caseRec.ExistingMobilePhoneNumber__c = 'Testing';
            ccc.caseRec.CurrentCarrier__c = 'Testing'; 
            ccc.caseRec.CurrentPhoneModel__c = 'Testing';
            ccc.caseRec.ContractEndDate__c = system.today();
            ccc.caseRec.NewCarrierPhoneModel__c = 'Testing';
            ccc.caseRec.Color__c = 'Testing';
            ccc.caseRec.Accessories__c = 'Testing';
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
            ccc.caseRec.CostCenterNumber__c = '11111';
            ccc.caseRec.JustificationRequest__c = 'Testing';
            ccc.caseRec.ExistingMobilePhoneNumber__c = 'Testing';
            ccc.caseRec.CurrentCarrier__c = 'Testing'; 
            ccc.caseRec.CurrentPhoneModel__c = 'Testing';
            ccc.caseRec.ContractEndDate__c = system.today();
            ccc.caseRec.NewCarrierPhoneModel__c = 'Testing';
            ccc.caseRec.Color__c = 'Testing';
            ccc.caseRec.Accessories__c = 'Testing';
            ccc.saveAndNew();
            ccc.cancelCase();
            testCases = [Select Id, Subject, Status, ParentId from Case];
            system.debug('@@ after cancel:'+testCases);
        }           
     }

    // coverage for ITSMSMobilityTransferCompController 
    static testMethod void testMobilityTransferSubmit() {          
        ITSMSTestDataSetup.createTestConstants();
        // create test data - requestor, requestedFor, delegates
        ITSMSTestDataSetup.createRequestor();
        User communityUser = [select Id,  Delegate__c from User where FirstName = 'Community'];
        Contact communityContact = [Select Id, FirstName, ContactUser__c from Contact where ContactUser__c =: communityUser.Id Limit 1];
        system.runAs (communityUser)
        {
            //*** start test
            Test.startTest();
            PageReference pageRef= Page.ITSMSSupportRequest;
            Test.setCurrentPage(pageRef);
            ITSMSMobilityTransferCompController ccc = new ITSMSMobilityTransferCompController();
            //-- verify controller
            ccc.caseRec = ITSMSUtilityClass.createCase('Mobility','Transfer Service from Personal account');
            ccc.pageController = new ITSMSPageControllerBase ();
            ccc.key = 'testing';
            ccc.componentToPage = new ITSMSComponentToController ();
            ccc.caseRec.IssueOrRequest__c = 'Request';
            ccc.caseRec.Date_Needed_By__c = system.today();
            ccc.caseRec.DeptVP__c = communityUser.Delegate__c;
            ccc.caseRec.CostCenterNumber__c = '11111';
            ccc.caseRec.JustificationRequest__c = 'Testing';
            ccc.caseRec.ExistingMobilePhoneNumber__c = 'Testing';
            ccc.caseRec.CurrentCarrier__c = 'Testing'; 
            ccc.caseRec.CurrentPhoneModel__c = 'Testing';
            ccc.caseRec.ContractEndDate__c = system.today();
            ccc.caseRec.NewCarrierPhoneModel__c = 'Testing';
            ccc.caseRec.Color__c = 'Testing';
            ccc.caseRec.Accessories__c = 'Testing';
            ccc.caseRec.ContactId  = communityContact.Id;
            ccc.saveOnly();
            ccc.saveAndSubmit();
            String sysadmProfileId = [Select Id from Profile WHERE Name = 'System Administrator'].Id;
            User sysAdmin = [Select Id from User where ProfileId = :sysadmProfileId and IsActive = true limit 1];
            system.runAs (sysAdmin) 
            {
                list<Case> testCases = [Select Id, Subject, Status, ParentId from Case];
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

    // coverage for ITSMSMultiAttachmentComponentController 
    private static testMethod void testMultiAttachController()
    {
        ITSMSTestDataSetup.createTestConstants();
        // create test data - requestor, requestedFor, delegate
        ITSMSTestDataSetup.createRequestor();
        User requestor = [select Id, ManagerId from User where FirstName = 'Requestor'];
        // create basic Case 
        string inputCategory = ITSMSConstants.GENERAL_CATEGORY;
        string srvreqType = ITSMSConstants.SUPPORT_SRVREQTYPE_GENERAL;
        system.runAs (requestor)
        {
            Case c = ITSMSUtilityClass.createCase(inputCategory, srvreqType);
            boolean isUpserted = ITSMSUtilityClass.upsertCase(c);
            ITSMSMultiAttachmentComponentController controller=new ITSMSMultiAttachmentComponentController();
            controller.sobjId=c.id;
            system.assertEquals(0, controller.getAttachments().size());
            system.assertEquals(3,controller.newAttachments.size());
    
            controller.addMore();
            system.assertEquals(6, controller.newAttachments.size());
    
            // populate the first and third new attachments
            List<Attachment> newAtts=controller.newAttachments;
            newAtts[0].Name='Unit Test 1';
            newAtts[0].Description='Unit Test 1';
            newAtts[0].Body=Blob.valueOf('Unit Test 1');

            newAtts[2].Name='Unit Test 2';
            newAtts[2].Description='Unit Test 2';
            newAtts[2].Body=Blob.valueOf('Unit Test 2');
    
            controller.saveAttachment();
    
            system.assertEquals(2, controller.getAttachments().size());
        }
    }
    
    // coverage for ITSMSMyAccountComponentController 
    static testMethod void testMyAccountOnPageLoad() {
        ITSMSTestDataSetup.createTestConstants();
        ITSMSTestDataSetup.SetupDelegateUsers();
        User Olivia = [Select Id, Delegate__c from User where LastName = 'Waller' limit 1];
        User Charles = [Select Id, Delegate__c from User where LastName = 'Frank' limit 1];
        ITSMSMyAccountComponentController controller1, controller2;
        PageReference componentPage = Page.ITSMSSupportCenterHome;
        
        Test.startTest();
        System.runAs(Olivia) {
            controller1 = new ITSMSMyAccountComponentController();
            Test.setCurrentPage(componentPage);
        }
        System.runAs(Charles) {
            controller2 = new ITSMSMyAccountComponentController();
            Test.setCurrentPage(componentPage);
        }
        Test.stopTest();
       
        
        Olivia = [Select Id, Delegate__c from User where LastName = 'Waller' limit 1];
        Charles = [Select Id, Delegate__c from User where LastName = 'Frank' limit 1];
        System.assertEquals(Charles.Id, Olivia.Delegate__c);
        System.assertEquals(null, Charles.Delegate__c);
        System.assertEquals('Charles Frank', controller1.DelegateText);
        System.assertEquals('--None--', controller2.DelegateText);
        
    }
    
    // coverage for ITSMSMyAccountComponentController 
    static testMethod void testMyAccountOnSaveClick() {
        ITSMSTestDataSetup.createTestConstants();
         ITSMSTestDataSetup.SetupDelegateUsers();
        User Olivia = [Select Id, Delegate__c from User where LastName = 'Waller' limit 1];
        ITSMSMyAccountComponentController controller1;
        PageReference componentPage = Page.ITSMSSupportCenterHome;
        
        Test.startTest();
        System.runAs(Olivia) {
            controller1 = new ITSMSMyAccountComponentController();
            Test.setCurrentPage(componentPage);
            controller1.NewDelegate.Delegate__c = null;
            controller1.SaveAndToggle();
        }
        Test.stopTest();
       
        
        Olivia = [Select Id, Delegate__c from User where LastName = 'Waller' limit 1];
        System.assertEquals(null, Olivia.Delegate__c);
        System.assertEquals('--None--', controller1.DelegateText);
        
    }

    // coverage for ITSMSMyCasesController 
    static testMethod void testMyCases() {          
        ITSMSTestDataSetup.createTestConstants();
        // create test data - requestor, requestedFor, delegate
        ITSMSTestDataSetup.createRequestor();
        User requestor = [select Id, ManagerId from User where FirstName = 'Requestor'];
        system.runAs (requestor)
        {

            // create submitted Case 
            ITSMSTestDataSetup.createNewHireToSubmit();
            ITSMSTestDataSetup.createNewHireToSubmit();
            Test.startTest();
            PageReference pageRef= Page.ITSMSMyCases;
            Test.setCurrentPage(pageRef);
            list<Case> c = [Select Id, Subject from Case];
            ApexPages.StandardSetController ssc = new ApexPages.Standardsetcontroller(c);
            ITSMSMyCasesController mcc = new ITSMSMyCasesController();
        
            //-- verify controller 
            system.assert(mcc != null); 
            system.assert(ssc != null);
            system.debug('@@ ready to test '+ssc);
            mcc.getCases();
            mcc.getStatuses();
            mcc.getYears();
            mcc.next();
            mcc.previous();
            mcc.first();
            mcc.last();
            mcc.filterYear = '2015';
            mcc.filterStatus = 'Submitted';
            mcc.checkQueryFilters();
            system.debug('@@ filter:'+mcc.foundCaseIds);
            mcc.refresh();
           	String initSearchText = mcc.searchText;
            mcc.runSearch();            
            mcc.searchText='Test';	                
            //mcc.searchText = null;        
            system.debug('@@ search:'+mcc.foundCaseIds);
            mcc.toggleSort();
            system.assertEquals(false,mcc.hasNext);
            system.assertEquals(false,mcc.hasPrevious);
            system.assertEquals(1,mcc.pageNumber);
            mcc.caseDetail();
        }    
    }

    // coverage for ITSMSNewHireCaseComplete 
    static testMethod void testNewHireComplete() {          
        ITSMSTestDataSetup.createTestConstants();
        // create test contact        
        ITSMSTestDataSetup.createTestContact();
        // create test parent case, set Requestor with manager/delegate 
        boolean checkFlag = ITSMSUtilityClass.runCompleteCase();
        ITSMSTestDataSetup.createNewHireToSubmit();
        Case pc1 = [Select Id, Subject, Type, Origin, RecordTypeId, Requestor__c, 
                            RequestingForUser__c, ManagerUser__c, Category__c, CategoryDetails__c  
                       from Case where FirstName__c = 'Submitted' and LastName__c = 'Employee'];
        update pc1;
        
        Contact testContact = [SELECT Id, Name, Email FROM Contact WHERE Email =: 'testContact@testing.com' LIMIT 1];        
        // create child case for 'AD Account'
        Case cc1 = new Case (Subject='Test 1 Child Case',ParentId=pc1.Id, RecordTypeId=pc1.RecordTypeId,  Status='New', 
                                        ServiceRequestType__c='AD Account', ContactId = testContact.Id);
        insert cc1;
        Test.startTest();
        // populate new hire email on AD case
        cc1.NewHireEmail__c='testContact@testing.com';
        cc1.OwnerId = UserInfo.getUserId();
        update cc1;
        Case cc1a = [Select Id, ParentId, Subject, Status, ServiceRequestType__c 
                      from Case where Id = :cc1.Id limit 1];
        system.assertEquals(cc1a.Status,'Closed');
        Case pc1a = [Select Id, Subject, Status, NewHireContact__c  
                           from Case where Id = :cc1.ParentId];
        system.assert(pc1a.NewHireContact__c != null);
    }    

    // coverage for ITSMSNewHireContact 
    static testMethod void testNewHireContact() {          
        ITSMSTestDataSetup.createTestConstants();
        // create test contact                
        ITSMSTestDataSetup.createTestContact();        
        // create test parent case, set Requestor with manager/delegate 
        ITSMSTestDataSetup.createNewHireToSubmit();
        Case pc1 = [Select Id, Subject, Type, Origin, RecordTypeId, Requestor__c, 
                            RequestingForUser__c, ManagerUser__c, Category__c, CategoryDetails__c  
                       from Case where FirstName__c = 'Submitted' and LastName__c = 'Employee'];
        update pc1;
        
        Contact testContact = [SELECT Id, Name, Email FROM Contact WHERE Email =: 'testContact@testing.com' LIMIT 1];                
        // create child case for 'AD Account'
        Case cc1 = new Case (Subject='Test 1 Child Case',ParentId=pc1.Id, RecordTypeId=pc1.RecordTypeId,  Status='New', 
                                        ServiceRequestType__c='AD Account',ContactId = testContact.Id);
        insert cc1;
        Test.startTest();
        // populate new hire email on AD case
        cc1.NewHireEmail__c='testContact@testing.com';
        cc1.OwnerId = UserInfo.getUserId();
        update cc1;

        Case cc1a = [Select Id, ParentId, Subject, Status, ServiceRequestType__c 
                      from Case where Id = :cc1.Id limit 1];
        system.assertEquals(cc1a.Status,'Closed');
        Case pc1a = [Select Id, Subject, Status, NewHireContact__c  
                           from Case where Id = :cc1.ParentId];
        system.assert(pc1a.NewHireContact__c != null);
    }
    
    // coverage for ITSMSNewHireCasesController 
    static testMethod void testNewHireCases() {          
        ITSMSTestDataSetup.createTestConstants();
        // create test data - requestor, requestedFor, delegate
        ITSMSTestDataSetup.createRequestor();
        User requestor = [select Id, ManagerId from User where FirstName = 'Requestor'];
        system.runAs (requestor)
        {

            // create submitted Case 
            ITSMSTestDataSetup.createNewHireToSubmit();
            Test.startTest();
            PageReference pageRef= Page.ITSMSNewHireCases;
            Test.setCurrentPage(pageRef);
            ITSMSNewHireCasesController mcc = new ITSMSNewHireCasesController();
        
            //-- verify controller 
            system.assert(mcc != null); 
            mcc.totalPages = 1;
            mcc.refresh();
            mcc.next();
            mcc.previous();
            mcc.first();
            mcc.last();
            mcc.getStatuses();
            mcc.getYears();
            mcc.toggleSort();
            mcc.checkQueryFilters();
            mcc.filterYear = '2015';
            mcc.checkQueryFilters();
            mcc.filterStatus = 'New';
            mcc.checkQueryFilters();
            String initSearchText = mcc.searchText;
            mcc.runSearch();            
            mcc.searchText='Test';			
            mcc.caseDetail();
            mcc.createNewHire();
            boolean chk = mcc.hasNext;
            boolean chk2 = mcc.hasPrevious;
            integer pn = mcc.pageNumber;
        }
    }

    // coverage for ITSMSNewHireChildCases 
    static testMethod void testNewHireChildCasesAll() {          
        ITSMSTestDataSetup.createTestConstants();
        // create test data - requestor, requestedFor, delegate
        ITSMSTestDataSetup.createRequestor();
        User requestor = [select Id, ManagerId from User where FirstName = 'Requestor'];
        ITSMSTestDataSetup.createAdmins();
        User admin = [select Id from User where FirstName = 'Admin'];
        system.runAs (requestor)
        {
            // create test where all child cases will be created
            ITSMSTestDataSetup.createNewHireToSubmit();
            Case ce = [Select Id, CreatedById from Case where FirstName__c = 'Submitted' and LastName__c = 'Employee' limit 1];
            ce.FirstName__c = 'TestA';
            ce.MiddleNameInitial__c = 'A';
            // set requestor
            ce.Requestor__c = requestor.Id;
            // desktop
            ce.DeskPhone__c = 'Yes';
            ce.WirelessHeadset__c = 'Yes';
            // access admin
            ce.IsRemoteAccessRequired__c = 'Yes';
            ce.WIKIRequired__c = 'Yes';
            ce.JustificationWIKIURLs__c = 'testing WIKI access';
            ce.SecurityGroups__c ='Testing';
            // Perforce
            ce.IsPerforceAccessRequired__c = 'Yes';
            ce.PerforceServerFolders__c = 'freeform text'; 
            // agile
            ce.AgileAccessRequired__c = 'Yes';
            ce.AgileAccessLevel__c= 'Access Level 1';
            ce.AgileModelUser__c= requestor.ManagerId;
            ce.OracleASCPResponsibilities__c = 'read update delete';
            ce.OracleEBSResponsibilities__c= 'read update delete';
            ce.OracleOBIEEResponsibilities__c= 'read update delete';
            // subscriber/backoffice
            ce.BackofficeSystemDetails__c = 'Exede/Denver';
            ce.BackofficeSystemsAccess__c = 'freeform text';
            ce.ExedeBackOfficeJumpBox__c = 'freeform text'; 
            // telecom
            ce.NOCAgents__c= True;
            ce.AgentToMirror__c = requestor.ManagerId;
            ce.Software__c = 'testing';
            update ce;       
            // create case with form where only wireless option is selected 
            ITSMSTestDataSetup.createNewHireToSubmit();
            Case ce2 = [Select Id, CreatedById from Case where FirstName__c = 'Submitted' and LastName__c = 'Employee' limit 1];
            ce2.FirstName__c = 'TestB';
            //    --desktop
            ce2.DeskPhone__c = 'No';
            ce2.WirelessHeadset__c = 'Yes';
            ce2.PCModelType__c = 'No PC Required';
            ce2.IsRemoteAccessRequired__c = 'No';
            ce2.WIKIRequired__c = 'No';
            ce2.IsPerforceAccessRequired__c = 'No';
            ce2.AgileAccessRequired__c = 'No';
            ce2.BackofficeSystemDetails__c = 'Exede/Denver';
            update ce2;

            // create form where only PC Model Laptop option is selected 
            ITSMSTestDataSetup.createNewHireToSubmit();
            Case ce3 = [Select Id, CreatedById from Case where FirstName__c = 'Submitted' and LastName__c = 'Employee' limit 1];
            ce3.FirstName__c = 'TestC';
            ce3.DeskPhone__c = 'No';
            ce3.WirelessHeadset__c = 'No';
            ce3.PCModelType__c = 'Laptop';
            ce3.PCModel__c = 'HP 820';
            ce3.IsRemoteAccessRequired__c = 'No';
            ce3.WIKIRequired__c = 'No';
            ce3.IsPerforceAccessRequired__c = 'No';
            ce3.AgileAccessRequired__c = 'No';
            ce3.BackofficeSystemDetails__c = 'Exede/Denver';
            update ce3;

            // get all test cases, build set of Ids 
            list<Case> testCases = new list<Case> ([Select Id from Case]);
            set<Id> testCaseIds = new set<Id>();
            for (Case c:testCases)
            {
                testCaseIds.add(c.Id);
            }
            //*** start test
            Test.startTest();
            system.debug('@@ start test:'+testCaseIds);
            ITSMSNewHireChildCases.createCases(testCaseIds);
            Test.stopTest();
            String sysadmProfileId = [Select Id from Profile WHERE Name = 'System Administrator'].Id;
            User sysAdmin = [Select Id from User where ProfileId = :sysadmProfileId and IsActive = true limit 1];
            system.runAs (sysAdmin) 
            {
                list<Case> allCases = [Select Id, Status, ParentId from Case];
                system.debug('@@ all cases:'+allCases);
                list<Case> childCasesTest1 = new list<Case> ([Select Id, ParentId from Case where ParentId = :ce.Id]);
                system.assert(childCasesTest1.size() > 1); 
    
                list<Case> childCasesTest2 = new list<Case> ([Select Id, ParentId from Case where ParentId = :ce2.Id]);
                system.assert(childCasesTest2.size() > 1); 
                list<Case> childCasesTest3 = new list<Case> ([Select Id, ParentId from Case where ParentId = :ce3.Id]);
                system.assert(childCasesTest3.size() > 1); 
            }
        }
    }

    // coverage for ITSMSNewHireEmailNotice 
    static testMethod void testNewHireEmailNotice() {          
        ITSMSTestDataSetup.createTestConstants();
        // create test users as Requestor, Requested For 
        ITSMSTestDataSetup.createRequestor();
        User requestor = [Select Id from User where firstname = 'Requestor' and lastName = 'Creator' Limit 1];
        system.runAs (requestor) 
        {
            // create test parent case
            ITSMSTestDataSetup.createNewHirePending();
            // create test new hire contact
            ITSMSTestDataSetup.createTestContact();
            Contact newHireContact = [Select Id from Contact where LastName = 'NewHire' Limit 1];
            Case parentCase = [Select Id from Case Limit 1];
            set<Id> parentCaseIds = new set<Id>();
            parentCaseIds.add(parentCase.Id);
            // set requestor and new hire contact on parent case 
            parentCase.NewHireContact__c = newHireContact.Id;
            parentCase.Requestor__c = requestor.Id;
            update parentCase;
            // create child case
            ITSMSTestDataSetup.createNewHirePending();  
            Case childCase = [Select Id, ParentId from Case where Id != :parentCase.Id limit 1];
            childCase.ParentId = parentCase.Id;
            update childCase;
            //*** start test
            Test.startTest();
            system.debug(' **** start of Email test ***');
            ITSMSNewHireEmailNotice.sendNewHireNotice(parentCaseIds);
        }
    }

    // coverage for ITSMSNewHireInitCase 
    static testMethod void testNewHireInitEmployee() {          
        ITSMSTestDataSetup.createTestConstants();
        // create test data - requestor, requestedFor, delegate
        ITSMSTestDataSetup.createRequestor();
        User requestor = [select Id, ManagerId from User where FirstName = 'Community' and LastName = 'User'];
        system.runAs (requestor)
        {
            // create - Case as Submitted
            ITSMSTestDataSetup.createNewHireToSubmit();
            Case ce = [Select Id, CreatedById from Case where FirstName__c = 'Submitted' and LastName__c = 'Employee'];
            // set requestor
            ce.Requestor__c = requestor.Id;
            update ce;       
            ce = ITSMSUtilityClass.getExistingCase(ITSMSConstants.NEWHIRE_QUERY +' from Case where Id = :inputCaseId', ce.Id);
            system.debug('@@ test parent:'+ce);

            //*** start test
            Test.startTest();
            Case childCase = ITSMSNewHireInitCase.createInitialNewHireCase(ce);
            system.debug('@@ emp:'+childCase);
            system.assert(childCase.ParentId == ce.Id); 
        }
    }

    // coverage for ITSMSNewHireInitCase 
    static testMethod void testNewHireInitContractor() {          
        ITSMSTestDataSetup.createTestConstants();
        // create test data - requestor, requestedFor, delegate
        ITSMSTestDataSetup.createRequestor();
        User requestor = [select Id, ManagerId from User where FirstName = 'Requestor'];
        system.runAs (requestor)
        {
            // create - Case as Submitted
            ITSMSTestDataSetup.createNewHireToSubmit();
            Case cc = [Select Id from Case where FirstName__c = 'Submitted' and LastName__c = 'Employee'];
            // change case to be for contractor
            cc.Requestor__c = requestor.Id;
            cc.CompanyName__c = 'ConsultantCompany';
            cc.CompanyEmail__c = 'consult@testing.com';
            cc.WorkEndDate__c = date.newInstance(2016,08,20);
            update cc;       
            cc = ITSMSUtilityClass.getExistingCase(ITSMSConstants.NEWHIRE_QUERY +' from Case where Id = :inputCaseId', cc.Id);
            system.debug('@@ test parent:'+cc);
            //*** start test
            Test.startTest();
            Case childCase = ITSMSNewHireInitCase.createInitialNewHireCase(cc);
            system.debug('@@ emp:'+childCase);
            system.assert(childCase.ParentId == cc.Id); 
        }
    }

    // coverage for ITSMSNewHireRequestController 
     static testMethod void testNewHireRequest() {
        ITSMSTestDataSetup.createTestConstants();
        // create test data - requestor, requestedFor, delegate
        ITSMSTestDataSetup.createRequestor();
        User requestor = [select Id, ManagerId from User where FirstName = 'Requestor'];

        system.runAs (requestor)
        {
            // create - Case in Pending Submission Status
            ITSMSTestDataSetup.createNewHirePending();
            Case peC = [Select Id from Case where FirstName__c = 'Pending' and LastName__c = 'Employee'];
            // set requestor
            peC.Requestor__c = requestor.Id;
            update peC;       
            //*** start test
            Test.startTest();
            PageReference pageRef= Page.ITSMSSupportCenterNewHireRequest;
            Test.setCurrentPage(pageRef);
            // test 1.  No existing case 
            ITSMSNewHireRequestController e = new ITSMSNewHireRequestController();
            // set variables, save form
            e.caseRec.AdditionalComments__c ='testing';
            e.caseRec.DeskPhone__c = 'Yes';
            e.caseRec.EmployeeType__c='Regular';
            e.caseRec.NewHireType__c = 'Employee';
            e.caseRec.StartDate__c = date.newInstance(2015,08,20);
            e.setNewHire();
            e.saveRequest();
            // verify case submitted in 'Pending Submission' status on save
            system.assert(e.caseRec.Status == 'Pending Submission');

            // update fields required on submit
            e.caseRec.AgileAccessRequired__c = 'No';
            e.caseRec.DoYouApproveThisForm__c  = 'Yes';
            e.caseRec.DeskPhone__c = 'Yes';
            e.caseRec.WirelessHeadset__c = 'No';
            e.caseRec.PCModelType__c = 'No PC Required';
            e.caseRec.IsRemoteAccessRequired__c = 'Yes';
            e.caseRec.WIKIRequired__c = 'No';
            e.caseRec.IsPerforceAccessRequired__c = 'No';
            e.caseRec.AgileAccessRequired__c = 'No';
            e.caseRec.BackofficeSystemDetails__c = 'Exede/Denver';
            e.caseRec.BackofficeSystemsAccess__c = 'freeform text';
            e.caseRec.ExedeBackOfficeJumpBox__c = 'freeform text';
            e.caseRec.NOCAgents__c= True;
            e.caseRec.AgentToMirror__c = requestor.ManagerId;
            e.caseNumber = '123123'; 
            e.selectedSoftwareCheck = 'MATLab'; 
            Case ec = e.existingCase;             
            e.SubmitAndNew();
            e.SubmitRequestAndNew(); 
            e.checkSubmitButton(); 
            e.checkRequestIssue(); 
            // verify case submitted 
            system.assert(e.caseRec.Status == 'Submitted');
            // test with existing case
            PageReference pageRef2= Page.ITSMSSupportCenterNewHireRequest;
            Test.setCurrentPage(pageRef2);
            ApexPages.currentPage().getParameters().put('caseId', pec.Id);
            ITSMSNewHireRequestController e1 = new ITSMSNewHireRequestController();
            // set variables, submit form
            e1.caseRec.AdditionalComments__c ='testing';
            e1.caseRec.NewHireType__c = 'Contractor';
            e1.caseRec.EmployeeType__c='Consultant';
            e1.caseRec.StartDate__c = date.newInstance(2015,08,20);
            e1.caseRec.WorkEndDate__c = date.newInstance(2016,01,10);
            e1.caseRec.AgileAccessRequired__c = 'No';
            e1.caseRec.DoYouApproveThisForm__c  = 'Yes';
            e1.caseRec.PhysicalLocation__c = 'Testing';
            e1.caseRec.OfficeCubeNumber__c = 'Some cube';
            e1.caseRec.DepartmentName__c = 'test';
            e1.caseRec.Citizenship__c = 'test';
            e1.caseRec.DeskPhone__c = 'Yes';
            e1.caseRec.WirelessHeadset__c = 'No';
            e1.caseRec.PCModelType__c = 'No PC Required';
            e1.caseRec.OtherPCModelOS__c = 'freeform text';
            e1.caseRec.PCModel__c = 'freeform text';
            e1.caseRec.OtherHardware__c = 'freeform text';
            e1.caseRec.OracleASCPResponsibilities__c= 'read update delete';
            e1.caseRec.OracleEBSResponsibilities__c= 'read update delete';
            e1.caseRec.OracleOBIEEResponsibilities__c= 'read update delete';
            e1.caseRec.SecurityGroups__c = 'freeform text';
            e1.caseRec.DistributionGroup__c = 'freeform text';
            e1.caseRec.SharedMailboxes__c = 'freeform text';
            e1.caseRec.NetworkDirectoryAccessLevel__c = 'freeform text';
            e1.caseRec.IsRemoteAccessRequired__c = 'Yes';
            e1.caseRec.WIKIRequired__c = 'Yes';
            e1.caseRec.JustificationWIKIURLs__c = 'testing WIKI access';                                                      
            e1.caseRec.IsPerforceAccessRequired__c = 'Yes';
            e1.caseRec.PerforceServerFolders__c = 'freeform text';
            e1.caseRec.AgileAccessRequired__c = 'Yes';
            e1.caseRec.AgileAccessLevel__c= 'Access Level 1';
            e1.caseRec.AdditionalAgileRolesRequired__c = 'some roles here';
            e1.caseRec.AgileModelUser__c= requestor.ManagerId;
            e1.caseRec.BackofficeSystemDetails__c = 'Exede/Denver';
            e1.caseRec.BackofficeSystemsAccess__c = 'freeform text';
            e1.caseRec.ExedeBackOfficeJumpBox__c = 'freeform text';
            e1.caseRec.NOCAgents__c= True;
            e1.caseRec.AgentToMirror__c = requestor.ManagerId;
            e1.submitRequest();
            ApexPages.getMessages();
            system.debug('@@ error:'+pec.Id+' '+pec);
            list<Case> secondCase = [Select Id, Status, CreatedById, Requestor__c from Case];
            // verify case now in 'Submitted' status 
            //system.assert(secondCase.Status == 'Submitted');
        
            // test 3. Existing submitted case 
            PageReference pageRef3= Page.ITSMSSupportCenterNewHireRequest;
            Test.setCurrentPage(pageRef3);
            ApexPages.currentPage().getParameters().put('caseId', e.caseRec.Id);
            ITSMSNewHireRequestController e2 = new ITSMSNewHireRequestController();
            // test cancel 
            e2.cancelRequest();
        }
    }

    // coverage for ITSMSOracleComponentController 
    static testMethod void testOracleSave() {          
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
            ITSMSOracleComponentController ccc = new ITSMSOracleComponentController();
            //-- verify controller
            ccc.caseRec = ITSMSUtilityClass.createCase('Access','Oracle Access');
            ccc.pageController = new ITSMSPageControllerBase ();
            ccc.key = 'testing';
            ccc.componentToPage = new ITSMSComponentToController ();
            ccc.caseRec.IssueOrRequest__c = 'Request';
            ccc.caseRec.ManagerUser__c = communityUser.Delegate__c;
            ccc.caseRec.AccessType__c = 'Agile';
            ccc.caseRec.DepartmentName__c = 'Testing';
            ccc.caseRec.AdditionalAgileRolesRequired__c = 'Testing';
            ccc.caseRec.PrivilegesNeeded__c = 'Testing';
            ccc.caseRec.JustificationRequest__c = 'Testing';
            ccc.caseRec.DoYouApproveThisForm__c = 'Yes';
            ccc.saveOnly();
            list<Case> testCases = [Select Id, Subject, Status, ParentId from Case];
            system.debug('@@ after save:'+testCases);
            // verify 2 cases created and status is 'Pending Submission'
            system.assertEquals(testCases.size(),2);
            system.assertEquals(testCases[0].Status,'Pending Submission');
            system.assertEquals(testCases[1].Status,'Pending Submission');
            ccc.caseRec.IssueOrRequest__c = 'Request';
            ccc.caseRec.ManagerUser__c = communityUser.Delegate__c;
            ccc.caseRec.AccessType__c = 'Oracle';
            ccc.caseRec.DepartmentName__c = 'Testing';
            ccc.caseRec.AdditionalAgileRolesRequired__c = 'Testing';
            ccc.caseRec.PrivilegesNeeded__c = 'Testing';
            ccc.caseRec.JustificationRequest__c = 'Testing';
            ccc.caseRec.DoYouApproveThisForm__c = 'Yes';
            ccc.saveAndNew();
            ccc.cancelCase();
            testCases = [Select Id, Subject, Status, ParentId from Case];
            system.debug('@@ after cancel:'+testCases);
        }           
     }

    // coverage for ITSMSOracleComponentController 
    static testMethod void testOracleSubmit() {          
        ITSMSTestDataSetup.createTestConstants();
        // create test data - requestor, requestedFor, delegates
        ITSMSTestDataSetup.createRequestor();
        User communityUser = [select Id,  Delegate__c from User where FirstName = 'Community'];
        Contact communityContact = [Select Id, FirstName, ContactUser__c from Contact where ContactUser__c =: communityUser.Id Limit 1];
        system.runAs (communityUser)
        {
            //*** start test
            Test.startTest();
            PageReference pageRef= Page.ITSMSSupportRequest;
            Test.setCurrentPage(pageRef);
            ITSMSOracleComponentController ccc = new ITSMSOracleComponentController();
            //-- verify controller
            ccc.caseRec = ITSMSUtilityClass.createCase('Access','Oracle Access');
            ccc.pageController = new ITSMSPageControllerBase ();
            ccc.key = 'testing';
            ccc.componentToPage = new ITSMSComponentToController ();
            ccc.caseRec.IssueOrRequest__c = 'Request';
            ccc.caseRec.AccessType__c = 'Oracle BI (OBIEE)';
            ccc.caseRec.DepartmentName__c = 'Testing';
            ccc.caseRec.AdditionalAgileRolesRequired__c = 'Testing';
            ccc.caseRec.PrivilegesNeeded__c = 'Testing';
            ccc.caseRec.JustificationRequest__c = 'Testing';
            ccc.caseRec.DoYouApproveThisForm__c = 'Yes';
            ccc.caseRec.ContactId  = communityContact.Id;
            ccc.saveOnly();
            ccc.saveAndSubmit();
            String sysadmProfileId = [Select Id from Profile WHERE Name = 'System Administrator'].Id;
            User sysAdmin = [Select Id from User where ProfileId = :sysadmProfileId and IsActive = true limit 1];
            system.runAs (sysAdmin) 
            {
                list<Case> testCases = [Select Id, Subject, Status, ParentId from Case];
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
    
    // coverage for ITSMSOracleComponentController 
    static testMethod void testOracleASCPAccessType() {          
        ITSMSTestDataSetup.createTestConstants();
        // create test data - requestor, requestedFor, delegates
        ITSMSTestDataSetup.createRequestor();
        User communityUser = [select Id,  Delegate__c from User where FirstName = 'Community'];
        Contact communityContact = [Select Id, FirstName, ContactUser__c from Contact where ContactUser__c =: communityUser.Id Limit 1];
        system.runAs (communityUser)
        {
            //*** start test
            Test.startTest();
            PageReference pageRef= Page.ITSMSSupportRequest;
            Test.setCurrentPage(pageRef);
            ITSMSOracleComponentController ccc = new ITSMSOracleComponentController();
            //-- verify controller
            ccc.caseRec = ITSMSUtilityClass.createCase('Access','Oracle Access');
            ccc.pageController = new ITSMSPageControllerBase ();
            ccc.key = 'testing';
            ccc.componentToPage = new ITSMSComponentToController ();
            ccc.caseRec.IssueOrRequest__c = 'Request';
            ccc.caseRec.AccessType__c = 'Oracle ASCP';
            ccc.caseRec.DepartmentName__c = 'Testing';
            ccc.caseRec.AdditionalAgileRolesRequired__c = 'Testing';
            ccc.caseRec.PrivilegesNeeded__c = 'Testing';
            ccc.caseRec.JustificationRequest__c = 'Testing';
            ccc.caseRec.DoYouApproveThisForm__c = 'Yes';
            ccc.caseRec.ContactId  = communityContact.Id;
			//ccc.formatCaseRec(); // added            
            ccc.saveOnly();
            ccc.saveAndSubmit();
            String sysadmProfileId = [Select Id from Profile WHERE Name = 'System Administrator'].Id;
            User sysAdmin = [Select Id from User where ProfileId = :sysadmProfileId and IsActive = true limit 1];
            system.runAs (sysAdmin) 
            { 
                list<Case> testCases = [Select Id, Subject, Status, ParentId from Case];
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

    // coverage for ITSMSPageControllerBase 
    static testMethod void testPageControllerBase() {
        ITSMSTestDataSetup.createTestConstants();
        Test.startTest();
        PageReference pageRef= Page.ITSMSSupportRequest;
        Test.setCurrentPage(pageRef);
        ITSMSPageControllerBase base = new ITSMSPageControllerBase();
        //-- verify controller
        base.getComponentControllerMap();
        base.getMyComponentController();
        base.getThis();
        ITSMSComponentControllerBase cm = new ITSMSComponentControllerBase();
        base.setComponentController(cm);
        base.setComponentControllerMap('test',cm);
        base.setNavigationElements();
        base.setTitleOfForm('Access');
        base.setTitleOfForm('Conferencing');
        base.setTitleOfForm('General');
        base.setTitleOfForm('Mobility');
        base.setTitleOfForm('Server');
        base.setTitleOfForm('Software');      
        base.setTitleOfForm('Workstation');            
        
            
    }

    // coverage for ITSMSPartPeripheralCompController 
    static testMethod void testPartPeripheralSave() {          
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
            ITSMSPartPeripheralCompController ccc = new ITSMSPartPeripheralCompController();
            //-- verify controller
            ccc.caseRec = ITSMSUtilityClass.createCase('Workstation','Part/Peripheral');
            ccc.pageController = new ITSMSPageControllerBase ();
            ccc.key = 'testing';
            ccc.componentToPage = new ITSMSComponentToController ();
            ccc.caseRec.IssueOrRequest__c = 'Request';
            ccc.caseRec.ManagerUser__c = communityUser.Delegate__c;
            ccc.caseRec.Date_Needed_By__c = system.today();
            ccc.caseRec.EquipmentLocation__c = 'Testing';
            ccc.caseRec.CostCenterNumber__c = 'Testing';
            ccc.caseRec.BriefDescription__c = 'Testing';
            ccc.caseRec.PartsRequest__c = 'Testing';
            ccc.caseRec.JustificationRequest__c = 'Testing';
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
            ccc.caseRec.PartsRequest__c = 'Testing';
            ccc.caseRec.JustificationRequest__c = 'Testing';
            ccc.saveAndNew();
            ccc.cancelCase();
            testCases = [Select Id, Subject, Status, ParentId from Case];
            system.debug('@@ after cancel:'+testCases);
        }           
     }

    // coverage for ITSMSPartPeripheralCompController 
    static testMethod void testPartPeripheralSubmit() {          
        ITSMSTestDataSetup.createTestConstants();
        // create test data - requestor, requestedFor, delegates
        ITSMSTestDataSetup.createRequestor();
        User communityUser = [select Id,  Delegate__c from User where FirstName = 'Community'];
        Contact communityContact = [Select Id, FirstName, ContactUser__c from Contact where ContactUser__c =: communityUser.Id Limit 1];
        system.runAs (communityUser)
        {
            //*** start test
            Test.startTest();
            PageReference pageRef= Page.ITSMSSupportRequest;
            Test.setCurrentPage(pageRef);
            ITSMSPartPeripheralCompController ccc = new ITSMSPartPeripheralCompController();
            //-- verify controller
            ccc.caseRec = ITSMSUtilityClass.createCase('Workstation','Part/Peripheral');
            ccc.pageController = new ITSMSPageControllerBase ();
            ccc.key = 'testing';
            ccc.componentToPage = new ITSMSComponentToController ();
            ccc.caseRec.IssueOrRequest__c = 'Request';
            ccc.caseRec.Date_Needed_By__c = system.today();
            ccc.caseRec.EquipmentLocation__c = 'Testing';
            ccc.caseRec.CostCenterNumber__c = 'Testing';
            ccc.caseRec.BriefDescription__c = 'Testing';
            ccc.caseRec.PartsRequest__c = 'Testing';
            ccc.caseRec.JustificationRequest__c = 'Testing';
            ccc.caseRec.ContactId  = communityContact.Id;
            ccc.saveOnly();
            ccc.saveAndSubmit();
            String sysadmProfileId = [Select Id from Profile WHERE Name = 'System Administrator'].Id;
            User sysAdmin = [Select Id from User where ProfileId = :sysadmProfileId and IsActive = true limit 1];
            system.runAs (sysAdmin) 
            {
                list<Case> testCases = [Select Id, Subject, Status, ParentId from Case];
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
            ITSMSRequestHeaderComponentController rhc = new ITSMSRequestHeaderComponentController();
            //-- verify controller
            rhc.pageController = new ITSMSPageControllerBase ();
            rhc.key = 'testing';
            rhc.showPageMessage = true;
            rhc.RequestorContact = 'testContact';
            rhc.componentToPage = new ITSMSComponentToController ();
            rhc.caseRec = ITSMSUtilityClass.createCase('Access','Folder/Share');
            rhc.formatHeader();
            rhc.checkCase();
            system.assertNotEquals(rhc.requestorLocation,null);
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

    // coverage for ITSMSSupportCenterSelfHelpController    
    static testMethod void testSelfHelpController(){     
        
        ITSMSTestDataSetup.createTestConstants();      
        ITSMSTestDataSetup.createAdmins();
        
        User admin = [SELECT Id, firstname FROM User WHERE firstname = 'knowledgeAdmin' ]; 
        test.startTest();             
        
        System.runAs(admin){ 
            
			ITSMSTestDataSetup.createPublishedArticleList('LandingPage', 'Featured Links', 22);        
			PageReference pageRef = Page.ITSMSupportCenterSelfHelpPOC;        
            Test.setCurrentPage(pageRef);         
            ITSMSSupportCenterSelfHelpContoller selfHelpController = new ITSMSSupportCenterSelfHelpContoller();       

            selfHelpController.refreshSearchResult();
            selfHelpController.queryString = 'Test';
             
            System.debug(selfHelpController.maxSize);
            System.assertEquals(22, selfHelpController.maxSize);            
            
            System.assertEquals(false, selfHelpController.getPrevRequired());
                
            System.assertEquals(true, selfHelpController.getNextRequired());
            
            System.assertEquals(1, selfHelpController.getCurrentPageNumber());            
			selfHelpController.next();
            System.assertEquals(2, selfHelpController.getCurrentPageNumber());            
			selfHelpController.next();
            System.assertEquals(3, selfHelpController.getCurrentPageNumber());            
			selfHelpController.next();
            System.assertEquals(3, selfHelpController.getCurrentPageNumber());  
            
            selfHelpController.previous();		
            System.assertEquals(2, selfHelpController.getCurrentPageNumber());              
            selfHelpController.previous();		
            System.assertEquals(1, selfHelpController.getCurrentPageNumber());              
            selfHelpController.previous();	
            System.assertEquals(1, selfHelpController.getCurrentPageNumber());  
            
            selfHelpController.clickedPage = 3;
            selfHelpController.jumpPage();       
            System.assertEquals(3, selfHelpController.getCurrentPageNumber());  
            
            selfHelpController.clickedPage = 1;
            selfHelpController.jumpPage();             
            System.assertEquals(1, selfHelpController.getCurrentPageNumber());  
            
            selfHelpController.searchString = 'test';
            selfHelpController.getRatings();
            selfHelpController.refreshSearchResult();             
            selfHelpController.checkRatingFilter(); 
            selfHelpController.filterRating = 'Most Viewed';
            selfHelpController.checkRatingFilter();            
            selfHelpController.filterRating = 'Last Updated';
            selfHelpController.checkRatingFilter();            
            selfHelpController.filterRating = 'Title';
            selfHelpController.checkRatingFilter();
            Integer a = selfHelpController.articlesPerPage;
            
			            
        }             
        test.stopTest();
    }        
    
    static testMethod void testSelfHelpController2(){
        
        ITSMSTestDataSetup.createTestConstants();      
        ITSMSTestDataSetup.createAdmins();
        
        
        
        User admin = [SELECT Id, firstname FROM User WHERE firstname = 'knowledgeAdmin' ]; 
        test.startTest();             
         
        System.runAs(admin){  
            
			ITSMSTestDataSetup.createPublishedArticleList('LandingPage', 'Featured Links', 40);           
			PageReference pageRef = Page.ITSMSupportCenterSelfHelpPOC;        
            Test.setCurrentPage(pageRef);
			ApexPages.currentPage().getParameters().put('j_id0:j_id1:j_id102:j_id103:j_id104:j_id105:theSearchstring','Test Search String');                
            ITSMSSupportCenterSelfHelpContoller selfHelpController = new ITSMSSupportCenterSelfHelpContoller();       
			selfHelpController.next();                            
            selfHelpController.previous();                   
        }             
        test.stopTest();
    }      
    
    static testMethod void testSelfHelpController3(){  
		// Case where there are no articles           
        ITSMSTestDataSetup.createTestConstants();      
        ITSMSTestDataSetup.createAdmins();
        
        User admin = [SELECT Id, firstname FROM User WHERE firstname = 'knowledgeAdmin' ]; 
        test.startTest();             
        
        System.runAs(admin){ 
			PageReference pageRef = Page.ITSMSupportCenterSelfHelpPOC;        
            Test.setCurrentPage(pageRef);	                                  
            ITSMSSupportCenterSelfHelpContoller selfHelpController = new ITSMSSupportCenterSelfHelpContoller();       
            System.assertEquals(selfHelpController.maxSize, 0);
        }             
        test.stopTest();
    } 
    
    // coverage for ITSMSSiteSearchController
    static testmethod void testSiteSearchController(){
		
        ITSMSTestDataSetup.createTestConstants();        
		ITSMSSiteSearchController siteSearchController = new ITSMSSiteSearchController();
		siteSearchController.siteSearchText = 'Test search text';
        PageReference selfHelp = siteSearchController.SelfHelpRedirect();
        Test.setCurrentPage(selfHelp);
		ITSMSSupportCenterSelfHelpContoller selfHelpController = new ITSMSSupportCenterSelfHelpContoller();
        System.assertEquals('Test search text', selfHelpController.searchString);
        
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
            e4.editCase();
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
        User communityUser = [select Id,  Delegate__c from User where FirstName = 'Community'];
        Contact communityContact = [Select Id, FirstName, ContactUser__c from Contact where ContactUser__c =: communityUser.Id Limit 1];

        system.runAs (communityUser)
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
                testParent.ContactId = communityContact.Id;
                update testParent;
            
                // create 2 children to parent  
                ITSMSTestDataSetup.createTestCase();
                Case testChild1 = [Select Id, Subject from Case where Subject != 'ParentCase' limit 1];
                testChild1.Subject = 'ChildCase1';
                testChild1.ParentId = testParent.Id;
                testChild1.ContactId = testParent.ContactId;
                update testChild1;
                // create 2 children to parent  
                ITSMSTestDataSetup.createTestCase();
                Case testChild2 = [Select Id, Subject from Case where Subject != 'ParentCase' and Subject != 'ChildCase1' limit 1];
                testChild2.Subject = 'ChildCase2';
                testChild2.ParentId = testParent.Id;
                testChild2.ContactId = testParent.ContactId;
                update testChild2;
            
                PageReference pageRef= Page.ITSMSSupportRequest;
                Test.setCurrentPage(pageRef);
                ApexPages.currentPage().getParameters().put('Category', 'General');
                // test  Existing case that is child
                ApexPages.currentPage().getParameters().put('Id', testChild1.Id);
                ITSMSSupportRequestController e1= new ITSMSSupportRequestController();
                e1.submitAll();
                List<Case> testSubmit = [Select Id, Status, ParentId from Case where ParentId =: testChild1.ParentId];
                system.debug('@@ found children'+testSubmit);
                system.assertEquals(testSubmit.size(),2);
                system.assertEquals(testSubmit[0].Status,'New');
                system.assertEquals(testSubmit[1].Status,'New');
                e1.setIssueType();
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
        Contact communityContact = [Select Id, FirstName, ContactUser__c from Contact where ContactUser__c =: communityUser.Id Limit 1];
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
            ccc.caseRec.ContactId  = communityContact.Id;
            list<Case> testCases = [Select Id, Subject, Status, ParentId from Case];
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
        Contact communityContact = [Select Id, FirstName, ContactUser__c from Contact where ContactUser__c =: communityUser.Id Limit 1];
        system.runAs (communityUser)
        {
            //*** start test
            Test.startTest();
            PageReference pageRef= Page.ITSMSSupportRequest;
            Test.setCurrentPage(pageRef);
            ITSMSWorkstationCompController ccc = new ITSMSWorkstationCompController();
            //-- verify controller
            system.debug('@@ ready to create case:');
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
            ccc.caseRec.ContactId  = communityContact.Id;
            ccc.saveOnly();
            ccc.saveAndSubmit();
            String sysadmProfileId = [Select Id from Profile WHERE Name = 'System Administrator'].Id;
            User sysAdmin = [Select Id from User where ProfileId = :sysadmProfileId and IsActive = true limit 1];
            system.runAs (sysAdmin) { 
                list<Case> testCases = [Select Id, Subject, Status, ParentId, ownerId from Case];
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
        }           
     }

}