/*********************************************************************************
Name         : WispDashboardController 
Created By   : Tejesh Kumar
Company Name : CMC Americas
Project      : ViaSat Wisp
Created Date : 2 December 2014
Usages       : Controller for VisualForce Page: subscriber_dashboard
*********************************************************************************/

public with sharing class  WispDashboardController extends AtlasDataManager{
           
       public string strExedeVoiceText{get{return AtlasUtility.getHyperLinkText(AtlasConstants.EXEDE_VOICE);}set;}     
       public boolean isVisibleExedeVoice{get{return AtlasUtility.getVisibility(AtlasConstants.EXEDE_VOICE);}set;}
       public String strExedeVoiceURL{get{return AtlasUtility.getURL(AtlasConstants.EXEDE_VOICE);}set;}
       public string dashboardTitle{get{return AtlasUtility.getMapValue(AtlasConstants.DASHBOARD_TITLE);}set;}
       public string pageName{get{return AtlasConstants.STRDASHBOARD;}set;}
       public string strPlanInvalid{get{return AtlasUtility.getURL(AtlasConstants.PLANINVALID);}set;}
       Set<String> AtlasPlansSet = new Set<String>();
       public string servicePlan{get;set;} 
       public boolean isPlanTypeInvalid{get;set;}
       //id profileId;
       //List<User> usr = null;
       // Variables used in WISP
       public string myAccount{get{return AtlasUtility.getMapWispValue(Atlasconstants.Wisp_MyAccount);}set;}
       public string myAccountInfo{get{return AtlasUtility.getMapWispValue(Atlasconstants.Wisp_MyAccount_Info);}set;}
       public string editAccInfo{get{return AtlasUtility.getMapWispValue(Atlasconstants.Wisp_EditAccountInfo);}set;}
       public AtlasComponenttoController componentToPage {get; private set;}
          
       /**
        * @author Raghuprasad Halakere
        * @description populateAtlasDashboardData for dashboard
        * @param object null
        * @return null
        */            
          public  void callRemoteAtlasDashboardData()
         { 
             //populateAtlasDashboardData();
             /*Using the new findSubscriberSearchCriteriaV2 callout */
             populateWispDashboardData1();    
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
        * @author Srikanth Kudumula
        * @description myAccountWispDashboardData for dashboard
        * @param object null
        * @return null
        */  
          public  void myAccountWispDashboardData()
          {
              system.debug('............myaccount');
              getMyAccountDashBoardDataforWisp();
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
         public WispDashboardController(){
               Apexpages.currentPage().getHeaders().put(AtlasConstants.X_UA_COMPATIBLE,AtlasConstants.IE_8); 
               isPlanTypeInvalid=true;
               componentToPage = new AtlasComponenttoController();
		       componentToPage.UsageGBInCorrect=false;
 			   componentToPage.PollerCount = 1;
                         
         }
         /**
        * @author Tejesh Kumar 
        * @description Checking and redirecting if plan does not exist
        * @param object null
        * @return Redirecting to pagenotfound url if plan does not exist
        */  
         public pagereference servicePlanSearch() {
             List<AtlasPlan__c> atlasPlans = [select PlanAPIName__c, PlanDisplayName__c from  AtlasPlan__c where Type__c =: 'Wisp'];
             for(AtlasPlan__c ap : atlasPlans){
                 AtlasPlansSet.add(ap.PlanAPIName__c.toLowerCase());                 
             }
             servicePlan=mainDTOObj.accountDTOObj.serviceLevel;
             if(!AtlasUtility.isEmpty(servicePlan) && AtlasPlansSet.contains(servicePlan.toLowercase()))
             {
                 isPlanTypeInvalid=false;
                 // Update the User details for only Valid Plans
                 updateUserDetails();                                                              
                 return null;       
             }
             else
             {
                 isPlanTypeInvalid=true;                  
                 String siteURl =site.getBaseUrl();
                 if(!AtlasUtility.IsEmpty(siteURl))
                 {
                    PageReference ref=new PageReference(siteURl+AtlasUtility.getWispURL(AtlasConstants.WispPlanInvalidUrl));
                    ref.setRedirect(true); 
                    return ref;
                 }
                 else
                 {            
                     PageReference ref1=new PageReference('/apex/subscriber_plan_invalid'); 
                     ref1.setRedirect(true); 
                     return ref1;  
                 }                                                               
             } 
         }    
         
         /**
        * @author Tejesh Kumar
        * @description Update First name, last name, phone and email in Salesforce Contact and User object with Backoffice data
        * @param object null
        * @return null
        */  
          public  void updateUserDetails()
          {
          	try {
                     User[] users = [Select Id,contactId,firstname,lastname,phone,Email,FederationIdentifier from User where FederationIdentifier =: mainDTOObj.accountDTOObj.username LIMIT 1];
                     
                     if(!AtlasUtility.isEmpty(users))
                     { 
                        User usr = users[0];
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
                     
                     Contact[] conList = [Select Id,firstname,lastname,phone,Email from Contact where Id =: users[0].contactId LIMIT 1];
                     
                     if(!AtlasUtility.isEmpty(conList))
                     {                      
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
                 Catch(Exception e){   
                    System.debug('Excception--->'+e);
                 }	   
          }
          
         
         /**
          * @author Sujit Kumar 
          * @description redirect to Wisp Customer Info page
          * @return page reference to subscriber_customer_info Page
         */  
        public PageReference editCustomerInfo() {
            string url = '/apex/subscriber_customer_info';
            string siteURl =site.getBaseUrl(); 
            if(!AtlasUtility.IsEmpty(siteURl)) {
                PageReference page = new PageReference(siteURl+'/subscriber_customer_info');
                page.setRedirect(true);
                return page;        
            }
            else {
                PageReference page = new PageReference(url);
                page.setRedirect(true);
                return page;
            } 
        }               

}