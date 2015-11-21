public with sharing class AtlasCommunitiesLandingController {
   // Code we will invoke on page load.
   Set<String> AtlasPlansSet = new Set<String>();
   public string servicePlan{get;set;} 
   public PageReference forwardToStartPage() {
      String communityUrl = Atlasutility.getURL(AtlasConstants.Community_URL);
      String customHomePage = '/dashboard';
      if (UserInfo.getUserType().equals('Guest')) {
         system.debug(' \n \n \n @@@@@@@@@ '+communityUrl + '/login?startURL=' + EncodingUtil.urlEncode(customHomePage,'UTF-8'));
         return new PageReference(communityUrl + '/login?startURL=' + EncodingUtil.urlEncode(customHomePage,'UTF-8'));
         //return new PageReference('https://mysso.test.exede.net/federation/UI/Login?goto=' + communityUrl + customHomePage);
      } else {
         return new PageReference(communityUrl + customHomePage);
      }
   }
   
   public AtlasCommunitiesLandingController() {}
}