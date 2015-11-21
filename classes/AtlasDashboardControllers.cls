/*********************************************************************************
Name         : AtlasDashboardController 
Created By   : Shiva Shankar N
Modified BY  : Shiva Shankar N
Company Name : NTT Data
Project      : ViaSat Atlas, Bangalore
Created Date : 20 October 2013
Modified Dtae: 15 November 2013
Usages       : Controller for VisualForce Page: dashboard
*********************************************************************************/

public with sharing class  AtlasDashboardControllers extends AtlasDataManagerAsync{
           
       public string strExedeVoiceText{get{return AtlasUtility.getHyperLinkText(AtlasConstants.EXEDE_VOICE);}set;}     
       public boolean isVisibleExedeVoice{get{return AtlasUtility.getVisibility(AtlasConstants.EXEDE_VOICE);}set;}
       public String strExedeVoiceURL{get{return AtlasUtility.getURL(AtlasConstants.EXEDE_VOICE);}set;}
       public string dashboardTitle{get{return AtlasUtility.getMapValue(AtlasConstants.DASHBOARD_TITLE);}set;}
       public string pageName{get{return AtlasConstants.STRDASHBOARD;}set;}
       public string strPlanInvalid{get{return AtlasUtility.getURL(AtlasConstants.PLANINVALID);}set;}
       Set<String> AtlasPlansSet = new Set<String>();
       public string servicePlan{get;set;} 
       public boolean isPlanTypeInvalid{get;set;}    
          
       /**
        * @author Raghuprasad Halakere
        * @description populateAtlasDashboardData for dashboard
        * @param object null
        * @return null
        */            
          public  void callRemoteAtlasDashboardData()
         { 
             populateAtlasDashboardData();    
         }
      
       /**
        * @author Raghuprasad Halakere
        * @description currentDataUsageAtlasDashboardData for dashboard
        * @param object null
        * @return null
        */  
          public  void currentDataUsageAtlasDashboardData()
          {     
             getCurrentDataUsageDashBoradData();
          }
          
       /**
        * @author Raghuprasad Halakere
        * @description myAccountAtlasDashboardData for dashboard
        * @param object null
        * @return null
        */  
          public  void myAccountAtlasDashboardData()
          {
              system.debug('............myaccount');
              getMyAccountDashBoardData();
              //servicePlanSearch(); 
          }
       /**
        * @author Raghuprasad Halakere
        * @description billingSnapshotAtlasDashboardData for dashboard
        * @param object null
        * @return null
        */  
          public  void billingSnapshotAtlasDashboardData()
          {
              getBillingSnapShotDashBoardDAta();
              
          }
          
       /**
        * @author Raghuprasad Halakere 
        * @description zero parameter AtlasDashboardControllers constructor
        * @param object null
        * @return null
        */  
         public AtlasDashboardControllers(){
               Apexpages.currentPage().getHeaders().put(AtlasConstants.X_UA_COMPATIBLE,AtlasConstants.IE_8); 
               isPlanTypeInvalid=true;
               //profileId = Apexpages.currentPage().getParameters().get('Id');    
                         
         }
                
         /**
        * @author Tejesh Kumar 
        * @description Checking and redirecting if plan does not exist
        * @param object null
        * @return Redirecting to pagenotfound url if plan does not exist
        */  
         public pagereference servicePlanSearch() {
             Id userContactId;
             
             List<AtlasPlan__c> atlasPlans = [select PlanAPIName__c, PlanDisplayName__c from  AtlasPlan__c];
             for(AtlasPlan__c ap : atlasPlans){
                 AtlasPlansSet.add(ap.PlanAPIName__c.toLowerCase());
             }
             servicePlan=mainDTOObj.accountDTOObj.serviceLevel;
             system.debug('@@@ Service Place from Account DTO---->'+servicePlan);
             System.debug('@@@ Service plan set---->'+AtlasPlansSet);
             if(!AtlasUtility.isEmpty(servicePlan) && AtlasPlansSet.contains(servicePlan.toLowercase()))
             {
                 isPlanTypeInvalid=false;
                  
                 /** Updating First name, last name, phone and email in Salesforce Contact and User object with Backoffice data **/
                 try {
                     User[] users = [Select Id,contactId,firstname,lastname,phone,Email,FederationIdentifier from User where FederationIdentifier =: mainDTOObj.accountDTOObj.username and CommunityUserAccountType__c = 'Exede' LIMIT 5];
                     // Need limit above to be > 1 since SOQL is not case sensitive and need to allow for the possibility that more than one user could have the same federationID with different case spelling smith vs Smith
                     
                     if(!AtlasUtility.isEmpty(users)){                       
                        for(Integer i = 0; i < users.size(); i++){
                            if (users.get(i).FederationIdentifier.equals(mainDTOObj.accountDTOObj.username)){                        
                                User usr = users.get(i);
                                userContactId = users.get(i).contactId;
                                boolean isuserupdate=false;
                                if(usr.firstname != mainDTOObj.accountDTOObj.firstName) {
                                    usr.firstname = mainDTOObj.accountDTOObj.firstName;
                                    isuserupdate=true;
                                }
                                if(usr.lastname != mainDTOObj.accountDTOObj.lastName) {
                                      usr.lastname = mainDTOObj.accountDTOObj.lastName;
                                      isuserupdate=true;
                                }
                                if(usr.phone != mainDTOObj.accountDTOObj.strUSMobileNOFormat) {
                                      usr.phone = mainDTOObj.accountDTOObj.strUSMobileNOFormat;
                                      isuserupdate=true;
                                } 
                                if(usr.Email != mainDTOObj.accountDTOObj.contactEmail) {
                                      usr.Email = mainDTOObj.accountDTOObj.contactEmail;
                                      isuserupdate=true; 
                                }
                                if(isuserupdate)        
                                    update usr;
                            }
                        }
                     
                         Contact[] conList = [Select Id,firstname,lastname,phone,Email from Contact where Id =: userContactId LIMIT 1];
                         
                         if(!AtlasUtility.isEmpty(conList)){                      
                            Contact con = conList[0];
                            boolean iscontactupdate=false;
                            if(con.firstname != mainDTOObj.accountDTOObj.firstName) {
                                con.firstname = mainDTOObj.accountDTOObj.firstName;
                                iscontactupdate=true;
                            }
                            if(con.lastname != mainDTOObj.accountDTOObj.lastName) {
                                  con.lastname = mainDTOObj.accountDTOObj.lastName;
                                  iscontactupdate=true;
                            }
                            if(con.phone != mainDTOObj.accountDTOObj.strUSMobileNOFormat) {
                                  con.phone = mainDTOObj.accountDTOObj.strUSMobileNOFormat;
                                  iscontactupdate=true;
                            } 
                            if(con.Email != mainDTOObj.accountDTOObj.contactEmail) {
                                  con.Email = mainDTOObj.accountDTOObj.contactEmail;
                                  iscontactupdate=true; 
                            }
                            if(iscontactupdate)        
                                update con;                        
                         }
                     }
                 } Catch(Exception e){   
                    System.debug('Exception--->'+e);
                 }
                                  
                 return null;       
             }
             else
             {
                 isPlanTypeInvalid=true;                  
                 String siteURl =site.getcurrentsiteurl();
                 if(siteURl!=null)
                 {
                    PageReference ref=new PageReference(siteURl+AtlasUtility.getURL(AtlasConstants.PLANINVALID));
                    ref.setRedirect(true); 
                    return ref;
                 }
                 else
                 {            
                     PageReference ref1=new PageReference('/apex/AtlasPlanInvalid'); 
                     ref1.setRedirect(true); 
                     return ref1;  
                 }                                                               
             } 
         }                         
}