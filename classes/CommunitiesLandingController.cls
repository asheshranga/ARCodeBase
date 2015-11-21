/**
 * An apex page controller that takes the user to the right start page based on credentials or lack thereof
 */
public with sharing class CommunitiesLandingController {
    
    // Code we will invoke on page load.
    public PageReference forwardToStartPage() {
        return Network.communitiesLanding();
    }
    
    public CommunitiesLandingController() {}
     // Added Code for redirecting to Custom Login Page
    public PageReference forwardToCustomAuthPage() {
        String siteURl =site.getcurrentsiteurl();
        if(siteURl!=null && !siteURl.contains('https:'))
           siteURl.replace('http:','https:');
        //return new PageReference( siteURl+ 'Atlaslogin?startURL=');
        return Network.communitiesLanding();
     }
}