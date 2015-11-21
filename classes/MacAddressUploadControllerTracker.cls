/*********************************************************************************
Name         : MacAddressUploadControllerTracker
Created By   : Shiva Shankar Nalluri
Modified BY  : Poornima Ramachandrachar
Company Name : NTT Data
Project      : ViaSat Atlas, Bangalore
Created Date : 
Modified Date: 
Usages       : Test Class for controller: MacAddressUploadController
*********************************************************************************/
@isTest(SeeAllData = false)
private class MacAddressUploadControllerTracker {
    
    private static PKI_License_and_Certificate_Request__c lcrobj;
    private static MAC_Address__c macObj;
    
     /**
    * @author Shiva Shankar
    * @description - MacAddressUploadController
    * @input param  - null
    * @return param null
    */   
    static testMethod void MacAddressUploadController() 
    {
        LoadMethod();
        Apexpages.currentPage().getParameters().put('lcrId',lcrobj.Id);          
        MacAddressUploadController objMacAddressUploadController = new MacAddressUploadController();
    }
     /**
    * @author Shiva Shankar
    * @description - testReadFile
    * @input param  - null
    * @return param null
    */   
    static testMethod void testReadFile() { 
        
        LoadMethod();
        Apexpages.currentPage().getParameters().put('lcrId',lcrobj.Id);          
        MacAddressUploadController objMacAddressUploadController = new MacAddressUploadController();
        
        test.startTest();
        
        objMacAddressUploadController.readFile();
        
        objMacAddressUploadController.fileName = 'test.csv';
        objMacAddressUploadController.readFile();
        
        objMacAddressUploadController.contentType = 'application/vnd.ms-excel';
        String myString1 = '';
        objMacAddressUploadController.fileContent = Blob.valueof(myString1);
        objMacAddressUploadController.readFile();
        
        String myString2 = 'Test';
        objMacAddressUploadController.fileContent = Blob.valueof(myString2);
        objMacAddressUploadController.readFile();
        objMacAddressUploadController.IsMacValid('11:22:33:44:55:66');
        objMacAddressUploadController.IsMacValid('11:22');
        
        test.stopTest();
        
        
    }
     /**
    * @author Shiva Shankar
    * @description - testReadFile2
    * @input param  - null
    * @return param null
    */   
      static testMethod void testReadFile2() { 
        
        LoadMethod();
        Apexpages.currentPage().getParameters().put('lcrId',lcrobj.Id);          
        MacAddressUploadController objMacAddressUploadController = new MacAddressUploadController();
        
        test.startTest();
        
        objMacAddressUploadController.readFile();
        
        objMacAddressUploadController.fileName = 'test.csv';
        objMacAddressUploadController.contentType = 'application/vnd.ms-excel';
        String myString2 = 'Server Serial #,Certificate Type,License Type,MAC Address,Comment \n 1,New,New,11:22:33:44:55:66,5';
        objMacAddressUploadController.fileContent = Blob.valueof(myString2);
        objMacAddressUploadController.readFile();
        
        test.stopTest();
        
    } 
    
    /**
    * @author Poornima
    * @description - testReadFile
    * @input param  - null
    * @return param null
    */   
    static testMethod void testReadFile3() { 
        
        LoadMethod();
        Apexpages.currentPage().getParameters().put('lcrId',lcrobj.Id);          
        MacAddressUploadController objMacAddressUploadController = new MacAddressUploadController();
        
        test.startTest();
        
        objMacAddressUploadController.readFile();
        
        objMacAddressUploadController.fileName = 'test.xlx';
        objMacAddressUploadController.readFile();
        
        test.stopTest();
        
        
    }
    
     /**
    * @author Poornima
    * @description - testReadFile4
    * @input param  - null
    * @return param null
    */   
      static testMethod void testReadFile4() { 
        
        LoadMethod();
        Apexpages.currentPage().getParameters().put('lcrId',lcrobj.Id);          
        MacAddressUploadController objMacAddressUploadController = new MacAddressUploadController();
        
        test.startTest();
        
        objMacAddressUploadController.readFile();
        
        objMacAddressUploadController.fileName = 'test.csv';
        objMacAddressUploadController.contentType = 'application/vnd.ms-excel';
        String myString2 = 'Server Serial #,Certificate Type,License Type,MAC Address,Comment \n 1, , ,11:22:33:44:55:66,5';       
        objMacAddressUploadController.fileContent = Blob.valueof(myString2);
        objMacAddressUploadController.readFile();
        
        test.stopTest();
        
    } 
    
    /**
    * @author Shiva Shankar
    * @description - testReadFile5
    * @input param  - null
    * @return param null
    */   
      static testMethod void testReadFile5() { 
        
        LoadMethod();
        Apexpages.currentPage().getParameters().put('lcrId',lcrobj.Id);          
        MacAddressUploadController objMacAddressUploadController = new MacAddressUploadController();
        
        test.startTest();
        
        objMacAddressUploadController.readFile();
        
        objMacAddressUploadController.fileName = 'test.csv';
        objMacAddressUploadController.contentType = 'application/vnd.ms-excel';
        String myString2 = 'Server Serial #,Certificate Type,License Type,MAC Address,Comment \n 1, , ,,5';       
        objMacAddressUploadController.fileContent = Blob.valueof(myString2);
        objMacAddressUploadController.readFile();
        
        test.stopTest();
        
    } 
    
    /**
    * @author Poornima
    * @description - testReadFile6
    * @input param  - null
    * @return param null
    */   
      static testMethod void testReadFile6() { 
        
        LoadMethod();
        Apexpages.currentPage().getParameters().put('lcrId',lcrobj.Id);          
        MacAddressUploadController objMacAddressUploadController = new MacAddressUploadController();
        
        test.startTest();
        
        objMacAddressUploadController.readFile();
        
        objMacAddressUploadController.fileName = 'test.csv';
        objMacAddressUploadController.contentType = 'application/vnd.ms-excel';
        String myString2 = 'Server Serial #,Certificate Type,License Type,MAC Address,Comment \n 1, , ,11:22,5';       
        objMacAddressUploadController.fileContent = Blob.valueof(myString2);
        objMacAddressUploadController.readFile();
        
        test.stopTest();
        
    }
    
    /**
    * @author Poornima
    * @description - testReadFile7
    * @input param  - null
    * @return param null
    */   
      static testMethod void testReadFile7() { 
        
        LoadMethod();
        Apexpages.currentPage().getParameters().put('lcrId',lcrobj.Id);          
        MacAddressUploadController objMacAddressUploadController = new MacAddressUploadController();
        
        test.startTest();
        
        objMacAddressUploadController.readFile();
        
        objMacAddressUploadController.fileName = 'test.csv';
        objMacAddressUploadController.contentType = 'application/vnd.ms-excel';
        String myString2 = 'Server Serial #,Certificate Type,License Type,MAC Address,Comment \n ,,,11:22:33:44:55:66,5';
        objMacAddressUploadController.fileContent = Blob.valueof(myString2);
        objMacAddressUploadController.readFile();
        
        test.stopTest();
        
    }
    
    /**
    * @author Poornima
    * @description - testReadFile8
    * @input param  - null
    * @return param null
    */   
      static testMethod void testReadFile8() { 
        
        LoadMethod();
        Apexpages.currentPage().getParameters().put('lcrId',lcrobj.Id);          
        MacAddressUploadController objMacAddressUploadController = new MacAddressUploadController();
        
        test.startTest();
        
        objMacAddressUploadController.readFile();
        
        objMacAddressUploadController.fileName = 'test.csv';
        objMacAddressUploadController.contentType = 'application/vnd.ms-excel';
        String myString2 = 'Server Serial #,Certificate Type,License Type,MAC Address,Comment \n 1,,,11:22:33:44:55:66,5';
        objMacAddressUploadController.fileContent = Blob.valueof(myString2);
        objMacAddressUploadController.readFile();
        
        test.stopTest();
        
    }
    
     /**
    * @author Shiva Shankar
    * @description - testimportData
    * @input param  - null
    * @return param null
    */   
     static testMethod void testimportData() { 
               
        LoadMethod();
        Apexpages.currentPage().getParameters().put('lcrId',lcrobj.Id);          
        MacAddressUploadController objMacAddressUploadController = new MacAddressUploadController();
        test.startTest();
        objMacAddressUploadController.importData();
        test.stopTest();
    }   
     /**
    * @author Shiva Shankar
    * @description - testimportData2
    * @input param  - null
    * @return param null
    */   
    static testMethod void testimportData2() { 
        
        LoadMethod();
        Apexpages.currentPage().getParameters().put('lcrId',lcrobj.Id);          
        MacAddressUploadController objMacAddressUploadController = new MacAddressUploadController();
        objMacAddressUploadController.lstMacAddress = new List<MAC_Address__c>();
        objMacAddressUploadController.lstMacAddress.add(macObj);
        test.startTest();
        objMacAddressUploadController.importData();
        test.stopTest();
    }   
     /**
    * @author Shiva Shankar
    * @description - testback
    * @input param  - null
    * @return param null
    */   
    static testMethod void testback() { 
        LoadMethod();
        Apexpages.currentPage().getParameters().put('lcrId',lcrobj.Id);          
        MacAddressUploadController objMacAddressUploadController = new MacAddressUploadController();
        test.startTest();
        objMacAddressUploadController.back();
        test.stopTest();
    }   
     /**
    * @author Shiva Shankar
    * @description - testcancel
    * @input param  - null
    * @return param null
    */   
    static testMethod void testcancel() { 
        LoadMethod();
        Apexpages.currentPage().getParameters().put('lcrId',lcrobj.Id);          
        MacAddressUploadController objMacAddressUploadController = new MacAddressUploadController();
        test.startTest();
        objMacAddressUploadController.cancel();
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
    }
}