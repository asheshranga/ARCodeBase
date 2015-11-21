/*********************************************************************************
Name         : AtlasDatabaseManager
Created By   : Gaurav Gathania 
Created Date : 5th December 2013
Project      : ViaSat Atlas, Bangalore
Usages       : This class contains methods for the Salesforce Database Queriess.

Change Log:
<Date>      <Modified By>       <Change Description>
4/24/2014   K. Wortel           Added insertTransaction Method to track update transactions
4/25/2014   K. Wortel           Updated getUserDetails to allow for Admin override of userId
4/28/2014   K. Wortel           Added newAdmin check to populateViewState to validate if Admins first time in routine
*********************************************************************************/

global with sharing class AtlasDatabaseManager{
    public static  User userObj{get;set;}
    public static string AccPlaceHolder{get{return AtlasUtility.getMapValue(AtlasConstants.ACC_NO_PLACE_HOLDER);}set;}
    public static string MacPlaceHolder{get{return AtlasUtility.getMapValue(AtlasConstants.MAC_PLACE_HOLDER);}set;}
    public static string PhonePlaceHolder{get{return AtlasUtility.getMapValue(AtlasConstants.PHONE_PLACE_HOLDER);}set;}
    public static string EmailPlaceHolder{get{return AtlasUtility.getMapValue(AtlasConstants.EMAIL_PLACE_HOLDER);}set;}
  //  public AtlasComponenttoController componentToPage= new AtlasComponenttoController();
    
    /**
    * @author Gaurav Gathania 
    * @description getUserDetails from Session ID
    * @param object null
    * @return User
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
    
    /**
    * @author Gaurav Gathania 
    * @description populateViewState for DataManager
    * @param object AtlasMainDTO
    * @return AtlasMainDTO
    */  
    public static AtlasMainDTO populateViewState(AtlasMainDTO mainDTOObj)
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
        /*
        AtlasViewState__c [] viewStateArray=[select Viewstate__c from AtlasViewState__c where ViewStateSessionId__c =:UserInfo.getSessionID()];
        if(!newAdmin&&!AtlasUtility.isEmpty(viewStateArray)&&viewStateArray.size()==1) 
            mainDTOObj=(AtlasMainDTO)JSON.deserialize(viewStateArray[0].Viewstate__c, AtlasMainDTO.class);
        else
        {   getUserDetails();
            mainDTOObj=new AtlasMainDTO();
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
        */
    }

    public static AtlasMainDTO getViewState(boolean newAdmin, AtlasMainDTO mainDTOObj)
    {
        AtlasViewState__c [] viewStateArray = [select Viewstate__c from AtlasViewState__c where ViewStateSessionId__c =:UserInfo.getSessionID()];
        if (!newAdmin && !AtlasUtility.isEmpty(viewStateArray) && viewStateArray.size()==1) 
            mainDTOObj=(AtlasMainDTO)JSON.deserialize(viewStateArray[0].Viewstate__c, AtlasMainDTO.class);
        else
        {   getUserDetails();
            mainDTOObj=new AtlasMainDTO();
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
    * @description populateViewState for AtlasDataManager
    * @param object AtlasMainDTO
    * @return AtlasMainDTO
    */  
    public static String getSerializedViewState(AtlasMainDTO mainDTOObj)
    {
        if (!AtlasUtility.isEmpty(mainDTOObj))
            return JSON.serialize(mainDTOObj); 
        else
            return null;    
    }
    
    /**
    * @author Gaurav Gathania 
    * @description persistViewState for AtlasDataManager
    * @param object AtlasMainDTO
    * @return AtlasMainDTO
    */  
    public static void persistViewState(AtlasMainDTO mainDTOObj)
    {
    try{
      if (!AtlasUtility.isEmpty(mainDTOObj))
            { 
        AtlasViewState__c viewStateOb=new AtlasViewState__c(ViewStateSessionId__c=UserInfo.getSessionID(),Viewstate__c=getSerializedViewState(mainDTOObj));
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
    * @author shiva shankar 
    * @description getGroupIdForCaseCreation for AtlasChangePlan
    * @param object Group
    * @return string
    */
    public static String getGroupIdForCaseCreation()  
    {
        try
        {
            Group groupobj=[Select Name,Id,OwnerId,Type From Group where Type='Queue' and name='Denver - Change Plans'];     
            return groupobj.Id;  
        }
        catch(Exception e)
        {
            return AtlasUtility.getMapValue(AtlasConstants.CP_CASE_OWNER);
        }
    }
    
    /**
    *  @author Kelly Wortel
    *  @description Method to insert transaction history for updateable transactions in ATLAS
    *  @param transactionModule - Picklist values for the transactionModule field
    *  @param transactionType - Picklist values for the transactionType field
    *  @param transactionDescription - general description of the transaction
    *  @param transactionStatus - success or error
    *  @param errorDescription - general description of the transaction error on failure
    */    
    public static void insertTransaction(string transactionModule, string transactionType, string transactionDescription, string transactionStatus, string errorDescription, string externalReferenceNum){
        insertTransaction(transactionModule, transactionType, transactionDescription, transactionStatus, errorDescription, externalReferenceNum, null, null, null, null,null);
    }
    
    /**
    *  @author Kelly Wortel
    *  @description Method to insert transaction history for updateable transactions in ATLAS
    *  @param transactionModule - Picklist values for the transactionModule field
    *  @param transactionType - Picklist values for the transactionType field
    *  @param transactionDescription - general description of the transaction
    *  @param transactionStatus - success or error
    *  @param errorDescription - general description of the transaction error on failure
    */
    public static void insertTransaction(string transactionModule, string transactionType, string transactionDescription, string transactionStatus, string errorDescription, string internalAccountReference, String previousEmailAddress, String sessionID, String groupID, DateTime startTime, DateTime endTime){

        if ((transactionType != null) && (transactionModule != null)) {
            try {
                User custID = [SELECT Id, Account_Number__c, Contact.Account.Parent.Name, CommunityUserAccountType__c from User where Account_Number__c = :internalAccountReference limit 1];
                AtlasTransactionHistory__c t = new AtlasTransactionHistory__c();
                system.debug('---partner name database--> '+ custId.Contact.Account.Parent.Name);
                // Set the Internal Service Agreement ID custom field on the Atlas Transaction History object
                AtlasMainDTO mainDTO = new AtlasMainDTO();
                System.debug('Retrieving the view state...');
                mainDTO = populateViewState(mainDTO);
                System.debug('Internal Service Agreement ID: ' + mainDTO);
                t.internalServiceAgreementId__c = mainDTO.accountNo;
                
                t.transactionModule__c = transactionModule;
                t.transactionType__c = transactionType;
                t.transactionDescription__c = transactionDescription;                
                if (custID != null) { 
                  t.customerName__c = custId.Id;
                  t.Application__c = custId.CommunityUserAccountType__c; 
                  t.AccountNumber__c =  custId.Account_Number__c; 
                  t.PartnerName__c = custId.Contact.Account.Parent.Name; 
                  if(custId.CommunityUserAccountType__c=='Wisp') {
                    t.RecordTypeId=AtlasUtility.getMapWispValue(AtlasConstants.WispTransHistoryRecordType);
                  }
                  else {
                    t.RecordTypeId=AtlasUtility.getMapValue(AtlasConstants.AtlasTransHistRecordType);
                  }                 
                }
              //t.externalReferenceNum__c = externalReferenceNum;	//AR: talk to kelly, if we need this information at all?
                t.loggedInUser__c = UserInfo.getUserId();
                t.transactionStatus__c = transactionStatus;
                t.errorDescription__c = errorDescription;
                t.previousEmailAddress__c = previousEmailAddress;
                t.sessionID__c = sessionID;
                t.groupID__c = groupID;
                t.StartTime__c = startTime;
                t.EndTime__c = endTime;
                insert t;
            } catch (Exception ex) {
                System.debug(LoggingLevel.WARN, 'Unable to insert into AtlasTransactionHistory, error: ' + ex.getMessage());
            }
        }
    }

    /**
    *  @author: Sarath Garimella
    *  @date: 
    *  @description:
    *  @param:
    */        
    public static void insertTransaction(AtlasTransactionHistory__c ath) {
        try{
            insert ath;
        }catch(Exception ex){
        	//AtlasTransactionHistory__c exceptionAtlasTransactionRec = new AtlasTransactionHistory__c();
        	//exceptionAtlasTransactionRec = ath;
        	//artTransc.transactionStatus__c = 'Failed';
        	//artTransc.transactionDescription__c = ex.getMessage();
        	//insert artTransc;
            System.debug(LoggingLevel.WARN, 'Unable to insert into AtlasTransactionHistory, error: ' + ex.getMessage());
        }
    }

    /**
    *  @author: 	Ashesh Ranga
    *  @date: 		11/17/2015
    *  @description:Method to insert a list of transaction history records for dashboard load time
    *  @param:		AtlasMainDTO object
    */    
    public static void insertTransactionList(AtlasMainDTO mainDTO) {

    String sessionID = UserInfo.getSessionId();
	AtlasTransactionHistory__c ath;	
	
	try {
		list<AtlasTransactionHistory__c> athList = new list<AtlasTransactionHistory__c>();

		for(AtlasTransactionModel txnModel : mainDTO.atlasTransactionModelList){
			ath = new AtlasTransactionHistory__c( 	internalServiceAgreementId__c = txnModel.getInternalServiceAgreementId(),
									                externalReferenceNum__c = txnModel.getExternalAccountReference(),
									                transactionDescription__c = txnModel.getTransactionDescription(),
									                transactionModule__c = txnModel.getTransactionModule(),
													transactionType__c = txnModel.getTransactionType(),
									                StartTime__c = txnModel.getStartTime(),
									                EndTime__c = txnModel.getEndTime(),
									                Application__c = mainDTO.CommunityUserAccountType,
									                AccountNumber__c =  mainDTO.internalAccountReference,
									                //customerName__c = mainDTO.contactId,
									                LoggedInUser__c = Userinfo.getUserID(),
									                sessionID__c = sessionID);
			athList.add(ath);
		}	        
		Database.insert(athlist,false);
		mainDTO.atlasTransactionModelList.clear();
	} catch (Exception ex) {
    	System.debug(LoggingLevel.WARN, 'Unable to insert list into AtlasTransactionHistory, error: ' + ex.getMessage());
    } 	
	}        
}