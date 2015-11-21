public with sharing class testCommunitiesLandingController {
   // Code we will invoke on page load.
   public PageReference forwardToStartPage() {

      String siteURl =site.getcurrentsiteurl();
      if (UserInfo.getUserType().equals('Guest')) {
          return new PageReference('https://myexede.force.com/ssotest/login?startURL=https://myexede.force.com/ssotest/_ui/core/chatter/ui/ChatterPage');
         //return new PageReference(communityUrl + '/login?startURL=' + EncodingUtil.urlEncode(communityUrl + customHomePage,'UTF-8'));
         //return new PageReference('https://mysso.test.exede.net/federation/UI/Login?goto=' + communityUrl + customHomePage);
      } else {
         return new PageReference('https://myexede.force.com/ssotest/_ui/core/chatter/ui/ChatterPage');
      }
   }
   
   public TestCommunitiesLandingController() {}
}