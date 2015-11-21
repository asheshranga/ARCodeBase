/*********************************************************************************
Name         : DealerDatabaseManager
Created By   : Tejesh Kumar
Created Date : 06 November 2015
Project      : Dealer Portal
Usages       : This class contains methods for the Salesforce Database Queries.
*********************************************************************************/

global with sharing class DealerDatabaseManager{

    public static User userObj{get;set;}
    
    /**
    * @author Gaurav Gathania 
    * @description persistViewState for DealerDataManager
    * @param object DealerMainDTO
    * @return void
    */  
    public static void persistViewState(DealerMainDTO mainDTOObj)
    {
    try{
      if (!AtlasUtility.isEmpty(mainDTOObj))
            { 
        DealerViewState__c viewStateOb=new DealerViewState__c(ViewStateSessionId__c=UserInfo.getSessionID(),Viewstate__c=getSerializedViewState(mainDTOObj));
        upsert viewStateOb ViewStateSessionId__c;
            }            
        }catch(JSONException e)
        {            
            throw new AtlasException.InvalidDataException(e.getMessage(),e.getMessage()+String.valueOf(mainDTOObj));
        }
        catch(NullPointerException e)
        {
            throw new AtlasException.InvalidDataException();
        }
        catch(DmlException e)
        {
            throw new AtlasException.DMLException();
        }           
    }
    
    /**
    * @author Gaurav Gathania 
    * @description Checks if mainDTO object parameter is empty
    * @param object DealerMainDTO
    * @return String or null based on above described check
    */  
    public static String getSerializedViewState(DealerMainDTO mainDTOObj)
    {
        if (!AtlasUtility.isEmpty(mainDTOObj))
            return JSON.serialize(mainDTOObj); 
        else
            return null;    
    }
    
    /**
    * @author Gaurav Gathania 
    * @description populateViewState for DataManager
    * @param object DealerMainDTO
    * @return object DealerMainDTO
    */  
    public static DealerMainDTO populateViewState(DealerMainDTO mainDTOObj)
    {   
        boolean newAdmin = false; 
        
        system.debug('ADM populateViewState SessionId: ' + UserInfo.getSessionID());
        system.debug('ADM populateViewState firstTime: ' + Apexpages.currentPage().getParameters().get('firstTime'));
        if(!Test.isRunningTest()) {
          if(AtlasUtility.isAdmin())  // if user is an authorized Admin and the query string is populated, clear the existing viewState.
              if(Apexpages.currentPage().getParameters().get('firstTime')=='true')    
                  newAdmin = true;
        }
        if(Test.isRunningTest()) { newAdmin = true; }
        
        return getViewState(newAdmin, mainDTOObj);
    }
    
    /**
    * @author unascribed
    * @description - Get view state based on newAdmin boolean and mainDTOObj
    * @param newAdmin boolean
    * @param object DealerMainDTO
    * @return object DealerMainDTO
    */  
    public static DealerMainDTO getViewState(boolean newAdmin, DealerMainDTO mainDTOObj)
    {
        DealerViewState__c [] viewStateArray = [select Viewstate__c from DealerViewState__c where ViewStateSessionId__c =:UserInfo.getSessionID()];
        if (!newAdmin && !AtlasUtility.isEmpty(viewStateArray) && viewStateArray.size()==1) 
            mainDTOObj=(DealerMainDTO)JSON.deserialize(viewStateArray[0].Viewstate__c, DealerMainDTO.class);
        else
        {   getUserDetails();
            mainDTOObj=new DealerMainDTO();
            mainDTOObj.accountNo=userObj.ExternalAccountReference__c;
            mainDTOObj.externalAccountReference=userObj.ExternalAccountReference__c;
            mainDTOObj.fullPhotoURL=userObj.FullPhotoUrl;
            mainDTOObj.smallPhotoURL=userObj.SmallPhotoUrl;
            mainDTOObj.CommunityUserAccountType=userObj.CommunityUserAccountType__c;
            mainDTOObj.loggedInUserEmail=userObj.Email;
            mainDTOObj.contactId=userObj.ContactId;
            mainDTOObj.federationId=userObj.FederationIdentifier;
            mainDTOObj.internalAccountReference=userObj.Account_Number__c;
            mainDTOObj.isUnlimited = false;
            mainDTOObj.isOpenNetPlan = false;
        }
        system.debug('@@@ main dto object--->'+mainDTOObj);
        return mainDTOObj;
    }
    
    /**
    * @author Gaurav Gathania 
    * @description getUserDetails from Session ID
    * @param none
    * @return object User
    */   
    public static User getUserDetails()
    {
        string userId = UserInfo.getUserID();
    
    if(!Test.isRunningTest()) {
          if(AtlasUtility.isAdmin())  // if user is an authorized Admin and the query string is populated, set the userId to the passed parameter.
              if(!AtlasUtility.isEmpty(Apexpages.currentPage().getParameters().get('Id'))) 
                  userId = Apexpages.currentPage().getParameters().get('Id');
    }
    
        if(AtlasUtility.isEmpty(userObj))
            userObj=[select id,Email,CommunityUserAccountType__c,ExternalAccountReference__c, Account_Number__c, FullPhotoUrl,SmallPhotoUrl,ContactId, federationIdentifier from User where id = :userId];
        return userObj;  
    }

}