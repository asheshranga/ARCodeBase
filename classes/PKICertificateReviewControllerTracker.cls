/*********************************************************************************
Name         : PKICertificateReviewController
Created By   : Shiva Shankar Nalluri
Modified BY  : Poornima Ramachandrachar
Company Name : NTT Data
Project      : ViaSat Atlas, Bangalore
Created Date : 
Modified Date: July 16 2014
Usages       : Test Class for controller: PKICertificateReviewController
*********************************************************************************/
@isTest(SeeAllData=true)


private class PKICertificateReviewControllerTracker {
    
    private static PKI_License_and_Certificate_Request__c lcrobj;
    private static MAC_Address__c macObj;
    private static PKICertificateReviewController objPKICertificateReviewController;
    private static Account objacc;
    private static Contact objCon;
    
    
    
    /**
    * @author Shiva Shankar
    * @description - testPKICertificateReviewController1
    * @input param  - null
    * @return param null
    */
    static testMethod void testPKICertificateReviewController1() 
    {
        LoadMethod();
        lcrobj.Status__c = 'Closed';
        update lcrobj;
        
        //here create a history record with old value
        PKI_License_and_Certificate_Request__History his = new PKI_License_and_Certificate_Request__History();
        his.field = 'Status__c';
        his.ParentId = lcrobj.Id;
        insert his;
        
        LoadMethod();
        
        //Create a history record with new value
        PKI_License_and_Certificate_Request__History his1 = new PKI_License_and_Certificate_Request__History();
        his1.field = 'Status__c';
        his1.ParentId = lcrobj.Id;
        insert his1;
        
        PKI_License_and_Certificate_Request__History his5 = new PKI_License_and_Certificate_Request__History();
        his5.field = 'Name';
        his5.ParentId = lcrobj.Id;
        insert his5;
        
        lcrobj.Status__c = 'New';
        update lcrobj;
        
        //Create a history record with new value
        PKI_License_and_Certificate_Request__History his2 = new PKI_License_and_Certificate_Request__History();
        his2.field = 'Status__c';
        his2.ParentId = lcrobj.Id;
        insert his2;
        
        lcrobj.Status__c = null;
        update lcrobj;
        
        //Create a history record with new value
        PKI_License_and_Certificate_Request__History his3 = new PKI_License_and_Certificate_Request__History();
        his3.field = 'Status__c';
        his3.ParentId = lcrobj.Id;
        insert his3;
        
        lcrobj.status__c = 'Closed';
        update lcrobj;
        
        Apexpages.currentPage().getParameters().put('Id',lcrobj.Id);  
        Apexpages.currentPage().getParameters().put('viewmode','true');  
        Apexpages.Standardcontroller stdcon = new Apexpages.Standardcontroller(lcrObj);
        objPKICertificateReviewController= new PKICertificateReviewController(stdcon);
        test.startTest();
        
        objPKICertificateReviewController.edit();
        objPKICertificateReviewController.createnew();
        lcrobj.Id = null;
        objPKICertificateReviewController.save();
        objPKICertificateReviewController.submit();
        objPKICertificateReviewController.toggleSort();
        objPKICertificateReviewController.getObjectHistory();
        
        Apexpages.currentPage().getParameters().put('Id',lcrobj.Id);
        objPKICertificateReviewController.getObjectHistory();
        
        test.stoptest();

    }
    /**
    * @author Shiva Shankar
    * @description - testPKICertificateReviewController2
    * @input param  - null
    * @return param null
    */
    static testMethod void testPKICertificateReviewController2() 
    {
        PKI_License_and_Certificate_Request__c lcrobj1=new PKI_License_and_Certificate_Request__c();
        lcrobj1.Downloadable__c=true;
        lcrobj1.Status__c= Label.PKI_Certificate_Request_Pending_Submission_Label;
        insert lcrObj1;
        Apexpages.currentPage().getParameters().put('Id',lcrobj1.Id);  
        Apexpages.currentPage().getParameters().put('viewmode','true');  
        Apexpages.Standardcontroller stdcon = new Apexpages.Standardcontroller(lcrObj1);
        objPKICertificateReviewController= new PKICertificateReviewController(stdcon);
        test.startTest();
        
        objPKICertificateReviewController.edit();
        objPKICertificateReviewController.createnew();
        objPKICertificateReviewController.save();
        objPKICertificateReviewController.submit();
        objPKICertificateReviewController.toggleSort();
        objPKICertificateReviewController.getObjectHistory();
        delete lcrobj1;
        objPKICertificateReviewController.save();
        
        test.stopTest();
    }
    /**
    * @author Shiva Shankar
    * @description - LoadMethod
    * @input param  - null
    * @return param null
    */    
    static void LoadMethod()
    {
        CreateLicenseandRequest();
        CreateMacAddress();
    }
    /**
    * @author Shiva Shankar
    * @description - CreateLicenseandRequest
    * @input param  - null
    * @return param null
    */
    static void CreateLicenseandRequest()
    {
         lcrobj=new PKI_License_and_Certificate_Request__c();
         lcrobj.Downloadable__c=true;
         insert lcrObj;
    }
    /**
    * @author Shiva Shankar
    * @description - CreateMacAddress
    * @input param  - null
    * @return param null
    */
    static void CreateMacAddress()
    {
        macObj= new MAC_Address__c();
        macObj.License_and_Certificate_Request__c=lcrObj.id;
        macObj.Certificate_Type__c='New';
        macObj.License_Type__c='New';
        macObj.Comments__c='Test';
        macObj.MAC_Address__c='11:22:33:44:55:66';
        macObj.Marked_For_Deletion__c=true;
        insert macObj;
    }
    
    /**
    * @author Shiva Shankar
    * @description - testPKICertificateReviewController3
    * @input param  - null
    * @return param null
    */
    static testMethod void testPKICertificateReviewController3() 
    {
        PKI_License_and_Certificate_Request__c lcrobj1=new PKI_License_and_Certificate_Request__c();
        lcrobj1.Downloadable__c=true;
        lcrobj1.Status__c= Label.PKI_Certificate_Request_Pending_Submission_Label;
        insert lcrObj1;
        Apexpages.currentPage().getParameters().put('Id','');  
        Apexpages.currentPage().getParameters().put('viewmode','true');  
        Apexpages.Standardcontroller stdcon = new Apexpages.Standardcontroller(lcrObj1);
        objPKICertificateReviewController= new PKICertificateReviewController(stdcon);
        test.startTest();
        
        objPKICertificateReviewController.edit();
        Apexpages.currentPage().getParameters().put('Id',lcrObj1.Id); 
        objPKICertificateReviewController.edit();
        objPKICertificateReviewController.save();
        
        test.stopTest();
    }
    
    
}