/*
 * Class ITSMSCaseUpdateTest
 * 
 * @version 1.0
 * @author  Dianna Guilinger - Slalom  
 * 
 *  Verifies functionality and code coverage for ITSMSCaseUpdate 
 */
@isTest
private class ITSMSCaseUpdateTest {
    static testMethod void testCaseUpdateCheckParent() {          
        ITSMSTestDataSetup.createTestConstants();
        // create - parent case as Submitted
        ITSMSTestDataSetup.createNewHireSubmitted();
        Case parentCase = [Select Id, CreatedById from Case where FirstName__c = 'Submitted' and LastName__c = 'Employee'];
        // flag as parent
        parentCase.FirstName__c ='Parent';
        parentCase.Subject = 'test parent';
        update parentCase;       
        // create - child case as Submitted
        ITSMSTestDataSetup.createNewHireSubmitted();
        Case childCase = [Select Id, CreatedById from Case where FirstName__c = 'Submitted' and LastName__c = 'Employee'];
        // flag as child
        childCase.FirstName__c ='Child';
        childCase.ParentId = parentCase.Id;
        childCase.Subject = 'test child';
        update childCase;       
		//*** start test
       	Test.startTest();
        // set child to assigned
        childCase.Status = 'Assigned';
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
            ITSMSTestDataSetup.createNewHireSubmitted();
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
    static testMethod void testChangeUserDelegate() {          
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
            ITSMSUtilityClass.hasTeamUpdateOccurred = false;
        	system.runAs (requestor)
        	{
	        	User requestorUser = [Select Id, Delegate__c from User where Id = :requestor.Id limit 1];
            	string delegateBefore = requestorUser.Delegate__c;
                requestorUser.Delegate__c = requestedFor.Delegate__c;
           		update requestorUser;
                list<CaseTeamMember> caseTeamAfter = [Select Id, ParentId, MemberId from CaseTeamMember];
                system.debug('@@ team after:'+caseTeamAfter);
            }
        
        }
    }
}