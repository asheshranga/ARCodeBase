global class PassengerCareURLRewriter implements Site.UrlRewriter {
    //Variable to represent the friendly URLs for pages
    String FRIENDLY_URL = '/vx';
    
    //Variable to represent my custom Visualforce pages that display page information
    String VISUALFORCE_PAGE ='/PassengerCareHome_VA';
    
    // The first global method for mapping external URL to an internal one
    global PageReference mapRequestUrl(PageReference myFriendlyUrl)
    {
        String url = myFriendlyUrl.getUrl();
        System.debug('****************************** Map Request URL - '+url);
        if(url.toLowerCase().startsWith(FRIENDLY_URL)) {
            return new PageReference(VISUALFORCE_PAGE);
        }
        
        return null;
    }
    
    // The second global method for mapping internal Ids to URLs
    global List<PageReference> generateUrlFor(List<PageReference> mySalesforceUrls) {
        //A list of pages to return after all the links have been evaluated
        System.debug('****************************** Generate URL FOr - ');
        
        List<PageReference> myFriendlyUrls = new List<PageReference>();
        for(PageReference mySalesforceUrl : mySalesforceUrls)
        {
            //Get the URL of the page
            String url = mySalesforceUrl.getUrl();
            
            //If this looks like a page that needs to be mapped, transform it
            if(url.toLowerCase().startsWith(VISUALFORCE_PAGE)) {
                myFriendlyUrls.add(new PageReference(FRIENDLY_URL));
            } else {
                myFriendlyUrls.add(mySalesforceUrl);
            }
        }
        
        //Return the full list of pages
        return myFriendlyUrls;
    }
}