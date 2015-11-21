public with sharing class WISPCommunitiesPartnerLandingController {

  public static Map<String,WISPKeyValueStore__c> MapKeyValue=WISPKeyValueStore__c.getAll();

  public PageReference forwardToStartPage() {
      String communityUrl = getKeyURL('CommunityPartnerURL');

      String communityRelayState = getKeyURL('CommunityPartnerRelayState');
      
      String startUrl = System.currentPageReference().getParameters().get('startURL');
          
      String customHomePage = getKeyURL('CommunityPartnerHomePage');
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
        
   public WISPCommunitiesPartnerLandingController() {}
}