public with sharing class ITSMSCommunitiesLandingController {

  public static Map<String,ITSMSKeyValueStore__c> MapKeyValue=ITSMSKeyValueStore__c.getAll();

  public PageReference forwardToStartPage() {
      String communityUrl = getKeyURL('CommunityURL');

      String startUrl = System.currentPageReference().getParameters().get('startURL');
          
      String customHomePage = getKeyURL('CommunityHomePage');
      if ((startUrl != null) && (!startURL.trim().equals('')))
         customHomePage = startUrl;
      
      if (UserInfo.getUserType().equals('Guest')) {
         return new PageReference(communityUrl + '/login?startURL=' + EncodingUtil.urlEncode(customHomePage,'UTF-8'));
      } else {
         return new PageReference(communityUrl + customHomePage);
      }
   }
   
   
   public static String getKeyURL(String name) {
      try{
         return MapKeyValue.get(name).URL__c;        
      } catch(Exception e) { return '';
      }
   }
        
   public ITSMSCommunitiesLandingController() {}
}