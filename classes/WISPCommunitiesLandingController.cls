public with sharing class WISPCommunitiesLandingController {

  public static Map<String,WISPKeyValueStore__c> MapKeyValue=WISPKeyValueStore__c.getAll();

  public PageReference forwardToStartPage() {
      String communityUrl = getKeyURL('CommunityURL');

      String communityRelayState = getKeyURL('CommunityRelayState');
      
      String startUrl = System.currentPageReference().getParameters().get('startURL');
          
      String customHomePage = getKeyURL('CommunityHomePage');
      if ((startUrl != null) && (!startURL.trim().equals(''))){
         customHomePage = startUrl;
         communityRelayState = startUrl;
      }
      
      if (UserInfo.getUserType().equals('Guest')) {
         return new PageReference(communityUrl + '/login?startURL=' + EncodingUtil.urlEncode(communityRelayState,'UTF-8'));
      } else {
         return new PageReference(communityUrl + customHomePage);
      }
   }
   
   
   public static String getKeyURL(String name) {
      try{
         return MapKeyValue.get(name).URL__c;        
      } catch(Exception e) {
         return '';
      }
   }
        
   public WISPCommunitiesLandingController() {}
}