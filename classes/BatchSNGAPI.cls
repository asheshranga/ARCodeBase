global class BatchSNGAPI implements Database.Batchable<sObject>,Database.AllowsCallouts{
   String query = 'select id from account  limit 1';   
   String email;
   Id toUserId;
   Id fromUserId;
   
   boolean gbFoundErrors = false;
   
   List<Atlas_Webservice_Log__c> loLogEntries;
   
   global Database.querylocator start(Database.BatchableContext BC){
            return Database.getQueryLocator(query);}

   global void execute(Database.BatchableContext BC, List<sObject> scope){
       boolean gbFoundErrors = false;
       
       loLogEntries = new List<Atlas_Webservice_Log__c>();
       
       //--- Call Test SNG Services
       callServices('Test');

       //--- Call Prod SNG Services
       callServices('Prod');
       
       //--- Call Test SSO Service
       callSSOServices('Test');
       
       //if (gbFoundErrors == true)
          //sendEmail();
          
       //--- commit the log entries
       try {
          insert loLogEntries;
       } catch (Exception e){
          system.debug('Unable to insert records - ' + e.getMessage());
       }
        
    }
    
    private void callSSOServices(String asInstance) {
        String lsMsg = '';
        String lsServiceName;
        String lsRequest;
        
        String lsSSOBaseURL    = ((asInstance != null) && asInstance.equalsIgnoreCase('PROD')) ? 'https://mysso.exede.net/sso' : 'https://mysso.test.exede.net/sso';
        
        
        try {
           lsMsg = 'Call SSO Service - ' + asInstance + ' - ';
           lsServiceName = 'SSO API Service - ' + asInstance;
           lsRequest = lsSSOBaseURL + '/subscribers';               
               
           HTTPResponse res = HTTPRequestCallOut.invokeService(lsRequest+'?serviceuserpassword=n0ldap4u&subscriberid=1&serviceusername=sfrouser','GET',15000,null,null);
               
           if (res !=null) {
              system.debug('SSO Service - Status = ' + res.getStatusCode());   
              system.debug('SSO Service - Body = ' + res.getBody());
              lsMsg = lsMsg + 'Successful - status = ' + res.getStatusCode();
           } else {
              system.debug('SSO Service Response is null'); 
              lsMsg = lsMsg + 'Successful - response is null' ;                  
           }
               
           addLogEntry(lsServiceName,lsRequest,lsMsg);
       } catch (Exception e) {
            lsMsg = lsMsg + 'Error - ' + e.getMessage();            
            addLogEntry(lsServiceName,lsRequest,lsMsg);
            gbFoundErrors = true;
       }
    }
    
    private void callServices(String asInstance) {
        String lsToken = '';
        Boolean lbValidToken = false;
        String lsMsg = '';
        String lsServiceName;
        String lsRequest;
        
        String lsOpenAMBaseURL = ((asInstance != null) && asInstance.equalsIgnoreCase('PROD')) ? 'https://sso.exede.net/federation' : 'https://sso.test.exede.net/federation';
        String lsSNGBaseURL    = ((asInstance != null) && asInstance.equalsIgnoreCase('PROD')) ? 'https://sngapp.exede.net/PmdrService' : 'https://sngapp.test.exede.net/PmdrService';
        
        
        try {
            lsMsg = 'Call OpenAM Auth Service - ' + asInstance + ' - ';
            lsServiceName = 'OpenAM Auth Token - ' + asInstance;
            lsRequest = lsOpenAMBaseURL + '/identity/authenticate';
            
            lsToken = OpenAMAuthService.getAuthToken(lsOpenAMBaseURL,'eecp','vg3NecHN3w71');
            
            system.debug('Token =' + lsToken);
            lsMsg = lsMsg + 'Successful - Token = ' + lsToken;                        
            addLogEntry(lsServiceName,lsRequest,lsMsg);
                                                      
            if (lsToken!=null) {
               lsMsg = 'Call OpenAM Validate Token Service - ' + asInstance + ' - ';
               lsServiceName = 'OpenAM Auth Token Validation - ' + asInstance;
               lsRequest = lsOpenAMBaseURL + '/identity/isTokenValid';               
               
               lbValidToken = OpenAMAuthService.validateToken(lsOpenAMBaseURL,lsToken.trim());
               system.debug('Valid Token? ' + lbValidToken);
               
               lsMsg = lsMsg + 'Successful - Valid Token? = ' + lbValidToken;
               addLogEntry(lsServiceName,lsRequest,lsMsg);
            }            
            
            if ((lbValidToken!=null) && (lbValidToken)){
               lsMsg = 'Call SNG Service - ' + asInstance + ' - ';
               lsServiceName = 'SNG API Service - ' + asInstance;
               lsRequest = lsSNGBaseURL + '/query/perf/phy/latest/00:a0:bc:26:42:0b';               
               
               HTTPResponse res = HTTPRequestCallOut.invokeService(lsRequest,'GET',9000,'application/x-www-form-urlencoded','iPlanetDirectoryPro=' + lsToken.trim());
               
               if (res !=null) {
                  system.debug('SNG Service - Status = ' + res.getStatusCode());   
                  system.debug('SNG Service - Body = ' + res.getBody());
                  lsMsg = lsMsg + 'Successful - status = ' + res.getStatusCode();
               } else {
                  system.debug('SNG Service Response is null'); 
                  lsMsg = lsMsg + 'Successful - response is null' ;                  
               }
               
               addLogEntry(lsServiceName,lsRequest,lsMsg);
            }
                        
       } catch (Exception e) {
            lsMsg = lsMsg + 'Error - ' + e.getMessage();            
            addLogEntry(lsServiceName,lsRequest,lsMsg);
            gbFoundErrors = true;
       }
       
    }
    
    private void addLogEntry(String asServiceName, String asRequest, String asMsg) {
       try {
           Atlas_Webservice_Log__c loServiceLog = new Atlas_Webservice_Log__c();
       
           loServiceLog.Webservice_Name__c = asServiceName;
           loServiceLog.Request__c = asRequest;
           loServiceLog.Error_Message__c = asMsg;
           
           loLogEntries.add(loServiceLog);
       } catch (Exception e) {
          //--- Nothing
       }
    }

@TestVisible
    private void sendEmail(){
        Messaging.SingleEmailMessage[] emails = new Messaging.SingleEmailMessage[]{};
        EmailTemplate e = [select Id,Name,Subject,body from EmailTemplate where name='API Failure Email' limit 1];
        
        for (User loUser : [select id from user where profile.name='System Administrator']) {
          Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();

          mail.setTargetObjectId(loUser.Id);
          mail.setTemplateId(e.id);
          mail.saveAsActivity = false;   
          emails.add(mail);
        }
    
        ViasatUtilityClass.sendEmails(emails, 'BatchSNGAPI');  
   }

   global void finish(Database.BatchableContext BC){
   }     
}