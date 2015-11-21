public class AtlasPlanInvalidController {
    public string planinvalid{get{return AtlasUtility.getMapValue(Atlasconstants.PLAN_INVALID_TEXT);}set;}
    public string strSignOutURL{get{return AtlasUtility.getURL(AtlasConstants.SIGNOUT);}set;}
    public string wispSignOutURL{get{return AtlasUtility.getWispURL(AtlasConstants.Wisp_SIGNOUT);}set;}
    public string wispplaninvalid{get{return AtlasUtility.getMapWispValue(Atlasconstants.Wisp_planinvalid1);}set;}
    public boolean isCTIAdmin{get;set;}
    public boolean isResellerAdmin{get;set;}
    
    public AtlasPlanInvalidController() {
      isCTIAdmin=false;
        isResellerAdmin=false;
      /* To determine whether the logged in user is an Internal User */     
    system.debug('###UserInfo--> '+UserInfo.getUserType()); 
    if(UserInfo.getUserType()=='Standard')
      isCTIAdmin=true; 

    /* To determine whether the logged in user is an Reseller Admin */
    if(!Test.isRunningTest()){
        WispKeyValueStore__c WispKVS = WispKeyValueStore__c.getValues('WISP Admin Community Profile');
      String resellerProfile = WispKVS.Value__c;
      isResellerAdmin = resellerProfile.contains(UserInfo.getProfileId().left(15));
    }
    }
}