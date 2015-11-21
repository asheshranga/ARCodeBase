/**
 * An apex page controller that exposes the site login functionality
 */
global with sharing class CommunitiesLoginController {

    global CommunitiesLoginController () {}

    global PageReference forwardToCustomAuthPage() {
        return new PageReference(site.getcurrentsiteurl() + 'login?startURL=');
    }
     global PageReference forwardToAuthPage() {
        return new PageReference(site.getcurrentsiteurl() + 'login?startURL=');
    }
}