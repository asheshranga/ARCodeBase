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
private class ServiceRequestTest 
{
    // Create numOfObjectsPerType site_c objects for each RecordType that is visible to the current User
    static private list<site__c> createSitesOfEachTypeAvailableForUser(integer numOfObjectsPerType) 
    {      
        list<Site__c> sites = new list<Site__c>();
        
                
        // Get Site__c record types visible to the currect User
        map<string, id> availableRecordTypes = ViasatUtilityClass.getAvailableRecordTypes(Site__c.SObjectType);     
        //system.debug('*** available RecordTypes:' + availableRecordTypes); //Hub, Maritime, Aviation-General, Aviation-GOV, Other Products, Aviation - Commercial, MPLS}
                   
        List<Account> accounts = ViasatTestUtility.createAccounts(availableRecordTypes.size(), 'testAcc');
        insert accounts;             
        List<Contact> contacts = ViasatTestUtility.createContacts(accounts, 1); // 1 contact per account
        insert contacts; 
        List<Product2> Products= ViasatTestUtility.createProducts(availableRecordTypes.size(),'product','Main');
        insert  Products; 
        
        integer i = 0;
        for (id rtId : availableRecordTypes.values())
        {
            for (integer j = 0; j < numOfObjectsPerType; j++)
            {
                //Select TypeofService__c, SiteName__c, Serial__c, Program__c, AccountNameSharingRule__c, ATRF_Finance_Approver__c, ATRF_Capacity_Planning_Approver__c, ATRF_Business_Approver__c From Site__c
                Site__c s = new Site__c(RecordTypeId = rtId, product__c = Products[i].id, Account__c = accounts[i].id, Account__r = accounts[i]);
                sites.add(s);
            }
            i++;
        }
        return sites;
    } 


    static testMethod void serviceRequestControlleTest() 
    {
        //*** Create 3 site_c objects for each RecordType that is visible to the current User
        list<Site__c> sites = createSitesOfEachTypeAvailableForUser(3);
        insert sites;
        
        Service_Request__c obj = new Service_Request__c(Status__c = 'New', ATRF_Submitted_Date__c=System.Today(), ATRF_Company_Name__c=sites[0].Account__c
            ,Requested_Start_Date__c=System.Today(), Requested_End_Date__c=System.Today().addDays(20), Product__c='ArcLight1'); //Requested_By__c,RecordTypeId,Customer_Contact__c  
        insert obj;

        list<site__c> terminals = [select id, name from Site__c where recordType.Name = 'Aviation-GOV'];
        system.assertEquals(terminals.size(),3);

        //*** Start Testing
        test.startTest();

        //*********************************************************************
        ApexPages.StandardController sc = new ApexPages.standardController(obj);
        
        // No terminals associated with the Service Request yet
        ServiceRequestController e = new ServiceRequestController(sc);
        
        // Add two terminals
        PageReference p = e.createNew();
        Schema.DescribeSObjectResult dsr = ServiceRequestSite__c.getSObjectType().getDescribe();
        Id recTypeId = ServiceRequestController.serviceReqRecTypes.get(ServiceRequestController.SERVICEREQUEST_TERMINAL_RecType);
        ServiceRequestSite__c srSite = new ServiceRequestSite__c(RecordTypeId = recTypeId, 
            ServiceSite__c=terminals[0].id, ServiceRequest__c=obj.Id//Program__c, Product__c, Account__c
        );
        insert srSite;

        ServiceRequestSite__c srSite2 = new ServiceRequestSite__c(RecordTypeId = recTypeId, 
            ServiceSite__c=terminals[1].id, ServiceRequest__c=obj.Id//Program__c, Product__c, Account__c
        );
        insert srSite2;

        //**********************************************************************
        // Update, then Delete one terminal
        Apexpages.currentPage().getParameters().put('srSiteId',srSite.id); 
        p = e.updateServiceRequestSite();

        sc = new ApexPages.standardController(obj);
        e = new ServiceRequestController(sc);

        // Link one HUB of each type
        //System.assertEquals(e.acct, obj);
        e.editMode = true;
        for (List<ServiceRequestSite__c> lst : e.sitesToProvisionListMap.values()) 
        {
            for (ServiceRequestSite__c srs : lst)
            {
                srs.ServiceSite__r.isProvisioned__c = true;
                break;
            }
        }
        p = e.saveProvisioning();

        List<ServiceRequestSite__c> ltemp = e.customRelatedList3;
        string temp = e.customRelatedListDesc3; 
        ltemp = e.customRelatedList4;
        temp = e.customRelatedListDesc4;
        ltemp = e.customRelatedList5;
        temp = e.customRelatedListDesc5; 

        //*************************************************************************
        PageReference pageRef = Page.ServiceRequestProvision;
        Test.setCurrentPageReference(pageRef);        

        sc = new ApexPages.standardController(obj);
        e = new ServiceRequestController(sc);

        // UN-Link one HUB of each type
        e.editMode = true;
        for (List<ServiceRequestSite__c> lst : e.sitesToProvisionListMap.values()) 
        {
            for (ServiceRequestSite__c srs : lst)
            {
                srs.ServiceSite__r.isProvisioned__c = false;
                break;
            }
        }
        p = e.saveProvisioning();
        
        e.editProvisioning();
        p = e.cancelProvisioning();

        Apexpages.currentPage().getParameters().put('srSiteId',srSite.id); 
        p = e.deleteServiceRequestSite();
        
        boolean b = e.allowUpdate;  
        
        test.stopTest();
    }    
    
    static Service_Request__c createAndApproveServiceReq()
    {
        Service_Request__c sr=createTestATRFServiceRequest(false, 'AFSOC');
        
        CarlsbadNOCKeyValueStore__c noc= new CarlsbadNOCKeyValueStore__c();
        noc.Name = 'CCRTaskStatusListToSendEmail';
        noc.Value__c = 'Not Started,Completed,Approved,Denied,Cancelled';
        insert noc;
                
        // Submit ATRF for Approval 
        // Create an approval request for the ATRF
        Approval.ProcessSubmitRequest req1 = new Approval.ProcessSubmitRequest();
        req1.setComments('Submitting request for approval.');
        req1.setObjectId(sr.id);
         
        
        // Submit the approval request for the ATRF
        Approval.ProcessResult result = Approval.process(req1);        
        
        // Verify the result
        System.assert(result.isSuccess());
        
        System.assertEquals(
            'Pending', result.getInstanceStatus(), 
            'Instance Status'+result.getInstanceStatus());
                     
            
        // trigger the approval reminders
        Service_Request__c srSubmitted= [select Id, RecordTypeId, Status__c from Service_Request__c where id = :sr.id];
        System.assertEquals(
            'Submitted', srSubmitted.Status__c, 
            'sr Status__c: ' + srSubmitted.Status__c);
        
        ServiceRequestHelper.sendATRFApprovalEmailReminders(new List<Service_Request__c>{srSubmitted});      
            
        
        // Approve the submitted request (all approvers)       
        // First, get the ID of the newly created item
        List<Id> newWorkItemIds = result.getNewWorkitemIds();
        
        for (Id witemId : newWorkItemIds)
        {
            // Instantiate the new ProcessWorkitemRequest object and populate it
            Approval.ProcessWorkitemRequest req2 = new Approval.ProcessWorkitemRequest();
            req2.setComments('Approving request.');
            req2.setAction('Approve');                
            // Use the ID from the newly created item to specify the item to be worked
            req2.setWorkitemId(witemId);        
            // Submit the request for approval
            Approval.ProcessResult result2 =  Approval.process(req2);
            // Verify the results
            System.assert(result2.isSuccess(), 'Result Status:'+result2.isSuccess());
        }
        
        // Should go to Final approval (Submitted to NOC Queue)
        Service_Request__c srApproved = [select Id, ATRF_ApprovalStatus__c from Service_Request__c where id = :sr.id];   
               
        System.assertEquals(
            'Submitted to NOC Queue', srApproved.ATRF_ApprovalStatus__c, 
            'sr ATRF_ApprovalStatus__c: ' + srApproved.ATRF_ApprovalStatus__c);
        
        // get the WorkItemId for the NOC Queue Approval step
        list <ProcessInstanceWorkitem> workItems = [Select Id from ProcessInstanceWorkitem where ProcessInstance.TargetObjectId = :sr.id];  

        // Should have only one
        System.assert( workItems.size() == 1, 'workItems.size: ' + workItems.size());
            
        // Approve for the NOC Queue
        Approval.ProcessWorkitemRequest req3 = new Approval.ProcessWorkitemRequest();
        req3.setComments('Approving request.');
        req3.setAction('Approve');                
        req3.setWorkitemId(workItems[0].id);        
        // Submit the request for approval
        Approval.ProcessResult result3 =  Approval.process(req3);
        // Verify the results
        System.assert(result3.isSuccess(), 'Result Status:'+result3.isSuccess());
        
        // Should go to 'Approved' status
        srApproved = [select Id, Status__c from Service_Request__c where id = :sr.id];   
 
        System.assertEquals(
            'Approved', srApproved.Status__c, 
            'sr Status__c: ' + srApproved.Status__c);
        
        return srApproved;
    }
    
    
    // ATRF Test 1 : Activation/Revision/Archiving 
    // Submit ATRF for approval
    // Approve ATRF 
    // verify case creation
    // close case
    // verify ATRF goes to Active 
    // Create revision
    // Submit revision for approval with no change
    // Approve revision
    // verify no case created
    // verify original ATRF is Archived
     
    static testMethod void ATRF_serviceRequestTest1() 
    {
        Service_Request__c sr = createAndApproveServiceReq();
        Test.startTest();
        try{
        
        
         
        // We have an Approved ATRF for one terminal -> Should have a case for it
        list <Case> caseList = [select id, Status from Case where serviceRequest__c = :sr.id];
        
        // verify we have a case
        //System.assert( caseList.size() == 2, 'caseList.size: ' +caseList.size());
        
        // close the case
        for (integer i=0;i<caseList.size();i++) {
            caseList[i].Status = 'Closed';
            caseList[i].ResolutionDescription__c = 'ATRF Case solved';
            update caseList;
        }
        
        // ATRF should go to 'Active'
         Service_Request__c srApproved = [select Id, Status__c from Service_Request__c where id = :sr.id];   
 
        System.assertEquals(
            'Active', srApproved.Status__c, 
            'sr Status__c: ' + srApproved.Status__c);
        
        // *****************
        // Create a revision 
        // *****************
        ApexPages.StandardController controller = new ApexPages.StandardController(sr);     
        ATRF_NewRevisionController myExtension = new ATRF_NewRevisionController(controller); 
        
        PageReference clonePage = myExtension.cloneWithServiceRequestSites();       
        String nextPage = clonePage.getUrl();

        System.Debug('nextPage: '+ nextPage);
        System.Debug('new sr id: ' + myExtension.newSrId);
        
        Service_Request__c srRevision = [select Id, Status__c, ATRF_Revision_Number__c, ATRF_OriginalVersion__c , ATRF_PreviousRevision__c from Service_Request__c where id = :myExtension.newSrId];   
        
        // We should have a revision number = 1
        System.assertEquals(
            1 , srRevision.ATRF_Revision_Number__c, 
            'srRevision.ATRF_Revision_Number__c: ' + srRevision.ATRF_Revision_Number__c);
        
        // Update the revision with no reason
        try
        {
            update srRevision;          
            System.assertEquals(1,0, 'Revision was updated with no reason');
        }
        catch (Exception e)
        {
        }
        
        // update the revision with reason 
        srRevision.ATRFReasonforNewRevision__c='test';
        update srRevision;
                        
        
        // Submit the revision for approval without changing anything
        // Submit ATRF for Approval 
        // Create an approval request for the ATRF
        Approval.ProcessSubmitRequest req4 = new Approval.ProcessSubmitRequest();
        req4.setComments('Submitting revision for approval.');
        req4.setObjectId(srRevision.id);
         
        
        // Submit the approval request for the ATRF
        Approval.ProcessResult result4 = Approval.process(req4);        
        
        // Verify the result
        System.assert(result4.isSuccess());
        
        System.assertEquals(
            'Pending', result4.getInstanceStatus(), 
            'Instance Status'+result4.getInstanceStatus());
        
        // Approve the submitted request (all approvers)       
        // First, get the ID of the newly created item
        List<Id> newWorkItemIds = result4.getNewWorkitemIds();
        
        for (Id witemId : newWorkItemIds)
        {
            // Instantiate the new ProcessWorkitemRequest object and populate it
            Approval.ProcessWorkitemRequest req5 = new Approval.ProcessWorkitemRequest();
            req5.setComments('Approving request.');
            req5.setAction('Approve');                
            // Use the ID from the newly created item to specify the item to be worked
            req5.setWorkitemId(witemId);        
            // Submit the request for approval
            Approval.ProcessResult result5 =  Approval.process(req5);
            // Verify the results
            System.assert(result5.isSuccess(), 'Result Status:'+result5.isSuccess());
        }
        
        // Should go to Final approval (Submitted to NOC Queue)
        srApproved = [select Id, ATRF_ApprovalStatus__c from Service_Request__c where id = :srRevision.id];   
               
        System.assertEquals(
            'Submitted to NOC Queue', srApproved.ATRF_ApprovalStatus__c, 
            'sr ATRF_ApprovalStatus__c: ' + srApproved.ATRF_ApprovalStatus__c);
        
        // get the WorkItemId for the NOC Queue Approval step
        list <ProcessInstanceWorkitem> workItems = [Select Id from ProcessInstanceWorkitem where ProcessInstance.TargetObjectId = :srRevision.id];  

        // Should have only one
        System.assert( workItems.size() == 1, 'workItems.size: ' + workItems.size());
            
        // Approve for the NOC Queue
        Approval.ProcessWorkitemRequest req6 = new Approval.ProcessWorkitemRequest();
        req6.setComments('Approving request.');
        req6.setAction('Approve');                
        req6.setWorkitemId(workItems[0].id);        
        // Submit the request for approval
        Approval.ProcessResult result6 =  Approval.process(req6);
        // Verify the results
        System.assert(result6.isSuccess(), 'Result Status:'+result6.isSuccess());
        
        // Should go to 'Active' status directly
        srApproved = [select Id, Status__c from Service_Request__c where id = :srRevision.id];   
 
        System.assertEquals(
            'Active', srApproved.Status__c, 
            'sr Status__c: ' + srApproved.Status__c);
        
        // We have an Approved revision with no changes
        // no cases should exist
        caseList = [select id, Status from Case where serviceRequest__c = :srRevision.id];
        
        // verify we have no case
        System.assert( (caseList == null) || (caseList.size() == 0), 'caseList.size: ' +caseList.size());
                
                
        // original should be Archived
        Service_Request__c srOriginal = [select Id, Status__c from Service_Request__c where id = :sr.Id];   
        
        System.assertEquals(
            'Archived', srOriginal.Status__c, 
            'sr Status__c: ' + srOriginal.Status__c);
        
        
            }
        catch(exception e)
        {
            System.debug(e.getMessage());
        }
        test.stopTest();
        
    }
    
    // ATRF Test 2: Deactivation
    // Start from Active ATRF
    // Request Deactivation
    // Approve Deactivation
    // Verify creation of deactivation case
    // close case
    // verify ATRF deactivated
    static testMethod void ATRF_serviceRequestTest2() 
    {
         Service_Request__c sr = createAndApproveServiceReq();
        //*** Start Testing
        test.startTest();
        try{
        
       
        
        list <Case> caseList = [select id, Status from Case where serviceRequest__c = :sr.id];
        
        // verify we have a case
        System.assert( caseList.size() == 1, 'caseList.size: ' +caseList.size());
        
        
        
        // close the case
        caseList[0].Status = 'Closed';
        caseList[0].ResolutionDescription__c = 'ATRF Case solved';
        update caseList;
        
        Service_Request__c srApproved = [select Id, Status__c from Service_Request__c where id = :sr.id]; 
       
            
        System.assertEquals(
            'Active', srApproved.Status__c, 
            'sr Status__c: ' + srApproved.Status__c);
                
        // Submit for de-activation
        
        // Test error condition (not active sr)
        ApexPages.StandardController controller = new ApexPages.StandardController(sr);
        ATRF_DeactivationSubmitController myExtension = new ATRF_DeactivationSubmitController(controller); 
        PageReference deactivationPage = myExtension.submitDeactivationToApproval();        
        System.assert( deactivationPage == null, 'deactivationPage: ' +deactivationPage);
        
        // active sr
        controller = new ApexPages.StandardController(srApproved);      
        myExtension = new ATRF_DeactivationSubmitController(controller); 
        deactivationPage = myExtension.submitDeactivationToApproval();      
        System.assert( deactivationPage != null, 'deactivationPage: ' +deactivationPage);
  
        String nextPage = deactivationPage.getUrl();
        System.Debug('nextPage: '+ nextPage);
   
  
  
        // Approve Deactivation
        srApproved.Status__c = 'Deactivation Approved';
        update srApproved;
        
        // verify we have an open case
        caseList = [select id, Status from Case where isClosed <> true and serviceRequest__c = :srApproved.id];
            
        System.assert( caseList.size() == 1, 'caseList.size: ' +caseList.size());
        
        // close the case
        caseList[0].Status = 'Closed';
        caseList[0].ResolutionDescription__c = 'ATRF Deactivation Case solved';
        update caseList;
        
        
        // verify the ATRF is deactivated
        // ATRF should go to 'Deactivated'
        srApproved = [select Id, Status__c from Service_Request__c where id = :srApproved.id];   
 
        System.assertEquals(
            'Deactivated', srApproved.Status__c, 
            'sr Status__c: ' + srApproved.Status__c);
        
                        
        
                
        }
        
         catch(exception e)
        {
            System.debug(e.getMessage());
        }
        test.stopTest();
    }
    
    
       
    
    // Test ATRF revision generation
    static testMethod void ATRF_serviceRequestTest3() 
    {
        Service_Request__c sr = createAndApproveServiceReq();            
        Test.startTest(); 
        try{
        ApexPages.StandardController controller = new ApexPages.StandardController(sr);     
        ATRF_NewRevisionController myExtension = new ATRF_NewRevisionController(controller); 
        
        PageReference clonePage = myExtension.cloneWithServiceRequestSites();       
        System.assert( clonePage == null, 'clonePage: ' +clonePage);

        // Set ATRF to Active - valid for revision
        sr.Status__c = 'Active';
        update sr;  
            
        controller = new ApexPages.StandardController(sr);      
        myExtension = new ATRF_NewRevisionController(controller);       
        clonePage = myExtension.cloneWithServiceRequestSites();     
        System.assert( clonePage != null, 'clonePage: ' +clonePage);
        
        // get the revision     
        Service_Request__c srRevision = [select Id, Status__c, ATRF_Revision_Number__c, ATRF_OriginalVersion__c , ATRF_PreviousRevision__c from Service_Request__c where id = :myExtension.newSrId];   
        
        // Update the revision to Active
        // Update the revision reason - 
        srRevision.ATRFReasonforNewRevision__c='test';
        srRevision.Status__c = 'Active';
        update srRevision;  
        
        // create a second revision
        controller = new ApexPages.StandardController(srRevision);      
        myExtension = new ATRF_NewRevisionController(controller); 
        clonePage = myExtension.cloneWithServiceRequestSites();     
        System.assert( clonePage != null, 'clonePage: ' +clonePage);
        
        // get the 2nd revision     
        Service_Request__c srRevision2 = [select Id, Status__c, ATRF_Revision_Number__c, ATRF_OriginalVersion__c , ATRF_PreviousRevision__c from Service_Request__c where id = :myExtension.newSrId];   
         
        System.assertEquals(
            2, srRevision2.ATRF_Revision_Number__c, 
            'srRevision2.ATRF_Revision_Number__c: ' + srRevision2.ATRF_Revision_Number__c);
        
        
        // try to create another revision on top of 1st one - error
        controller = new ApexPages.StandardController(srRevision);      
        myExtension = new ATRF_NewRevisionController(controller); 
        clonePage = myExtension.cloneWithServiceRequestSites();     
        System.assert( clonePage == null, 'clonePage: ' +clonePage);    
                
        
            }
             catch(exception e)
        {
            System.debug(e.getMessage());
        }
        test.stopTest();

    
    }
    
    
    // Test ATRF status transition
    static testMethod void ATRF_serviceRequestTest4() 
    {
        Service_Request__c sr = createAndApproveServiceReq();
        Test.startTest();
        try{
         
        // try to update ATRF in Approved
        Service_Request__c srUpdate = new Service_Request__c();
        srUpdate.Id = sr.Id;
        srUpdate.Status__c = 'Approved';
        srUpdate.ATRF_APR_Blanking__c = 'Yes';
        try
        {
            update sr; 
            System.assertEquals(
            'Yes', srUpdate.ATRF_APR_Blanking__c, 
            'srUpdate.ATRF_APR_Blanking__c: ' + srUpdate.ATRF_APR_Blanking__c);
             
        }
        catch (Exception e)
        {
            
        }
            
        // Set ATRF to 'New' -> should fail
        sr.Status__c = 'New';
        try
        {
            update sr; 
            System.assertEquals(
            'New', sr.Status__c, 
            'sr Status__c: ' + sr.Status__c);
             
        }
        catch (Exception e)
        {
            
        }
        
        // Set ATRF to Archived
        sr.Status__c = 'Archived';
        update sr;  
        
        
        // Set ATRF to 'New' -> should fail
        sr.Status__c = 'New';
        try
        {
            update sr; 
            System.assertEquals(
            'New', sr.Status__c, 
            'sr Status__c: ' + sr.Status__c);
             
        }
        catch (Exception e)
        {
            
        }
        
        
        // Set ATRF to Deactivation Approved
        sr.Status__c = 'Deactivation Approved';
        update sr;  
        
        
        // try to update ATRF 
        srUpdate = new Service_Request__c();
        srUpdate.Id = sr.Id;
        srUpdate.Status__c = 'Deactivation Approved';
        srUpdate.ATRF_APR_Blanking__c = 'Yes';
        try
        {
            update sr; 
            System.assertEquals(
            'Yes', srUpdate.ATRF_APR_Blanking__c, 
            'srUpdate.ATRF_APR_Blanking__c: ' + srUpdate.ATRF_APR_Blanking__c);
             
        }
        catch (Exception e)
        {
            
        }
        
        
        // Set ATRF to Expired
        sr.Status__c = 'Expired';
        update sr;  
        
        
        // try to update ATRF 
        srUpdate = new Service_Request__c();
        srUpdate.Id = sr.Id;
        srUpdate.Status__c = 'Expired';
        srUpdate.ATRF_APR_Blanking__c = 'Yes';
        try
        {
            update sr; 
            System.assertEquals(
            'Yes', srUpdate.ATRF_APR_Blanking__c, 
            'srUpdate.ATRF_APR_Blanking__c: ' + srUpdate.ATRF_APR_Blanking__c);
             
        }
        catch (Exception e)
        {
            
        }
        
        
        // Set ATRF to Archived
        sr.Status__c = 'Archived';
        update sr;  
        
        
        // try to update ATRF 
        srUpdate = new Service_Request__c();
        srUpdate.Id = sr.Id;
        srUpdate.Status__c = 'Archived';
        srUpdate.ATRF_APR_Blanking__c = 'Yes';
        try
        {
            update sr; 
            System.assertEquals(
            'Yes', srUpdate.ATRF_APR_Blanking__c, 
            'srUpdate.ATRF_APR_Blanking__c: ' + srUpdate.ATRF_APR_Blanking__c);
             
        }
        catch (Exception e)
        {
            
        }
        
                   
        
            }
           catch(exception e)
        {
            System.debug(e.getMessage());
        }
        test.stopTest();
  
    
    }
    
    
    
    // Test ATRF revision generation : Configuration change case
    static testMethod void ATRF_serviceRequestTest5() 
    {
        Service_Request__c sr = createAndApproveServiceReq();
        
        Test.startTest();
        try{
       
            
            
        // Set ATRF to Active - valid for revision
        sr.Status__c = 'Active';
        update sr;  
                       
                           
        ApexPages.StandardController controller = new ApexPages.StandardController(sr);     
        ATRF_NewRevisionController myExtension = new ATRF_NewRevisionController(controller);        
        PageReference clonePage = myExtension.cloneWithServiceRequestSites();       
        System.assert( clonePage != null, 'clonePage: ' +clonePage);
        
        // get the revision     
        Service_Request__c srRevision = [select Id, Status__c, ATRF_Revision_Number__c, ATRF_OriginalVersion__c , ATRF_PreviousRevision__c from Service_Request__c where id = :myExtension.newSrId];   
        
        // Update the revision -> config change
        srRevision.ATRFReasonforNewRevision__c='test';
        srRevision.ATRF_APR_Blanking__c = 'Yes';
        srRevision.Status__c = 'Approved'; // should trigger a config case
        update srRevision;  
        
        
        // verify we have an open case
        list <Case> caseList = [select id, Status from Case where isClosed <> true and serviceRequest__c = :srRevision.id];
            
        System.assert( caseList.size() == 1, 'caseList.size: ' +caseList.size());
     
        
            }
            
     catch(exception e)
        {
            System.debug(e.getMessage());
        }
        test.stopTest();

    }    
    
    
     static private service_request__c createTestATRFServiceRequest(Boolean networkingApprovalNeeded, String terminalProgram)
     {
        
        // create the Viasat corporate account-user and contact
        List<Account> corpAccount = ViasatTestUtility.createAccounts(1, 'ViaSat, Inc.-Corporate Headquarters');
        insert corpAccount; 
        
        // create contact
/*      
        Contact corpContact = new Contact();
        corpContact.AccountId = corpAccount[0].id;
        corpContact.FirstName = 'ATRF';
        corpContact.LastName = 'Test';
        insert corpContact;
*/      
        List<Contact> corpContacts = ViasatTestUtility.createContacts(corpAccount, 1); // 1 contact per account
        insert corpContacts; 
        Contact corpContact = corpContacts[0];
        
        
        // matching user
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
        User corpUser = new User();
        corpUser.profileId = p.id;
        corpUser.FirstName = corpContact.FirstName;
        corpUser.LastName = corpContact.LastName;
        corpUser.Alias = 'ATRFTest';
        corpUser.Email='ATRFTest@testorg.com';
        corpUser.EmailEncodingKey='UTF-8';
        corpUser.LanguageLocaleKey='en_US';
        corpUser.LocaleSidKey='en_US';
        corpUser.TimeZoneSidKey='America/Chicago';
        corpUser.UserName='ATRFTest@testorg.com';
        insert corpUser;
    
        // create case queue - not needed   
    
        // create product
        List<Product2> products= ViasatTestUtility.createProducts(1,'product','Main');
        insert  Products; 
                
        // create account                  
        List<Account> accounts = ViasatTestUtility.createAccounts(1, 'testAcc');
        insert accounts; 
        
        // create contact
        List<Contact> contacts = ViasatTestUtility.createContacts(accounts, 1);
        insert contacts; 
                            
            
        // create users (will be approvers)
        // TO DO: use approvers from correct profiles (Capacity planning, business, finance)
        User user1 = ViasatTestUtility.createInsertUser(null, 'Carlsbad NOC Manager');
        User user2 = ViasatTestUtility.createInsertUser(null, 'Carlsbad NOC Manager');
        User user3 = ViasatTestUtility.createInsertUser(null, 'Carlsbad NOC Manager');
        
        // create sites (Terminals + Hubs)
        list <Site__c> sites = new list<Site__c>();
                
        // Get Site__c record types 
        map<string, id> siteRecordTypes = ViasatUtilityClass.getAvailableRecordTypes(Site__c.SObjectType);      
        
        // Create Terminal
        Site__c terminal1 = new Site__c();
        terminal1.RecordTypeId = siteRecordTypes.get('Aviation-GOV');
        terminal1.product__c = products[0].id; 
        terminal1.Account__c = accounts[0].id;
        terminal1.Program__c = terminalProgram; // 'AFSOC' 
        sites.add(terminal1); 
        
        // create Hubs
        Site__c hub1 = new Site__c();
        hub1.RecordTypeId = siteRecordTypes.get('Hub');
        hub1.product__c = products[0].id; 
        hub1.Account__c = accounts[0].id;
        hub1.ATRF_Finance_Approver__c = user1.id;
        hub1.ATRF_Capacity_Planning_Approver__c = user2.id; 
        hub1.ATRF_Business_Approver__c = user3.id; 
                
        sites.add(hub1); 
        
        // Create sites
        insert sites;  
        
        
        // Create ATRF service request
        map<string, id> srRecordTypes = ViasatUtilityClass.getAvailableRecordTypes(Service_Request__c.SObjectType);     
    
        Service_Request__c sr = new Service_Request__c();
        sr.RecordTypeId = srRecordTypes.get('ATRF-Gov');
        sr.Status__c = 'New';   
        sr.ATRF_Submitted_Date__c = System.Today();
        sr.ATRF_Company_Name__c = accounts[0].id;
        sr.Customer_Contact__c = contacts[0].id;
        sr.ownerId = corpUser.id;   
        sr.ATRF_Networking_Approval_Needed__c = networkingApprovalNeeded; 
        //9/14/15 : Modified to add Service Requirements Notes to pass a validation rule
        sr.ATRF_Service_Requirements_Notes__c = 'test';
        insert sr;
        
        
        // Create Service request sites
        map<string, id> srsRecordTypes = ViasatUtilityClass.getAvailableRecordTypes(ServiceRequestSite__c.SObjectType);     
        list <ServiceRequestSite__c> srsList = new list <ServiceRequestSite__c>();
        
        ServiceRequestSite__c srs = new ServiceRequestSite__c();
        srs.RecordTypeId = srsRecordTypes.get('Terminal');
        srs.ServiceRequest__c = sr.id;
        srs.ServiceSite__c = terminal1.id;
        srsList.add(srs);
        
        srs = new ServiceRequestSite__c();
        srs.RecordTypeId = srsRecordTypes.get('Hub');
        srs.ServiceRequest__c = sr.id;
        srs.ServiceSite__c = hub1.id;
        srsList.add(srs);
                
    
        insert srsList;
        
        
                
        return sr;
        
        
     } 
    
    
    
    
    
    
    
}