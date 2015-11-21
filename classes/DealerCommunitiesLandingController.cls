public class DealerCommunitiesLandingController {

  public static Map<String,DealerKeyValueStore__c> MapKeyValue=DealerKeyValueStore__c.getAll();

  public PageReference forwardToStartPage() {
      String communityUrl = getKeyURL(DealerConstants.CommunityURL);

      String communityRelayState = getKeyURL(DealerConstants.CommunityRelayState);
      
      String startUrl = System.currentPageReference().getParameters().get('startURL');
          
      String customHomePage = getKeyURL(DealerConstants.CommunityHomePage);
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
        
   public DealerCommunitiesLandingController() {}
}