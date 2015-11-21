/*********************************************************************************
Name         : AtlasSiteLoginController  
Created By   : Gaurav Gathania  
Modified BY  : Gaurav Gathania
Company Name : NTT Data
Project      : ViaSat Atlas, Bangalore
Created Date : 23 October 2013
Modified Date: 13 November 2013
Usages       : Controller for VisualForce Page: Atlaslogin
*********************************************************************************/
public class AtlasSiteLoginController  
{ 
    // Intializing GlobalVariables for HyperLinkURL      
    public string strHyperLinkAddressForGotPassword{get{return AtlasUtility.getURL(AtlasConstants.STRFORGOT_PASSWORD);}set;}  
    public string strHyperLinkAddressForGotPasswordWildblue{get{return AtlasUtility.getURL(AtlasConstants.STRFORGOT_PASSWORD_WILDBLUE);}set;}
    public string strTwitterURL{get{return AtlasUtility.getURL(AtlasConstants.TWITTER);}set;}
    public string strYoutubeURL{get{return AtlasUtility.getURL(AtlasConstants.YOUTUBE);}set;}
    public string strGoogleURL{get{return AtlasUtility.getURL(AtlasConstants.GOOGLE_PLUS);}set;}
    public string strFacebookURL{get{return AtlasUtility.getURL(AtlasConstants.FACEBOOK);}set;}
    // Intializing GlobalVariables for HyperLinkText      
    public string strFacebookText{get{return AtlasUtility.getHyperLinkText(AtlasConstants.FACEBOOK);}set;}
    public string strTwitterText{get{return AtlasUtility.getHyperLinkText(AtlasConstants.TWITTER);}set;}
    public string strYoutubeText{get{return AtlasUtility.getHyperLinkText(AtlasConstants.YOUTUBE);}set;}
    public string strGoogleText{get{return AtlasUtility.getHyperLinkText(AtlasConstants.GOOGLE_PLUS);}set;}
    public string strHyperLinkTextForGotPassword{get{return AtlasUtility.getHyperLinkText(AtlasConstants.STRFORGOT_PASSWORD);}set;}
    // Intializing Global Variables for IsVisibility
    public boolean isVisibleFacebook{get{return AtlasUtility.getVisibility(AtlasConstants.FACEBOOK);}set;}
    public boolean isVisibleTwitter{get{return AtlasUtility.getVisibility(AtlasConstants.TWITTER);}set;}
    public boolean isVisibleYoutube{get{return AtlasUtility.getVisibility(AtlasConstants.YOUTUBE);}set;}
    public boolean isVisibleGoogle{get{return AtlasUtility.getVisibility(AtlasConstants.GOOGLE_PLUS);}set;}
    public Boolean IsVisibleForGotPassword{get{return AtlasUtility.getVisibility(AtlasConstants.STRFORGOT_PASSWORD);}set;}
    // Variables used in Site Login page
    public String strCopyRightYear {get{return AtlasUtility.getMapValue(AtlasConstants.CopyRightYear);}set;} 
    public String FooterDisclaimerText {get{ return  AtlasUtility.getMapValue(AtlasConstants.FooterDisclaimerText_a) + '' 
                                                     +AtlasUtility.getMapValue(AtlasConstants.FooterDisclaimerText_b) + ''
                                                     +AtlasUtility.getMapValue(AtlasConstants.FooterDisclaimerText_c) + ''
                                                     +AtlasUtility.getMapValue(AtlasConstants.FooterDisclaimerText_d) + ''
                                                     +AtlasUtility.getMapValue(AtlasConstants.FooterDisclaimerText_e);}set;}     
    public String strTitle {get{return AtlasUtility.getMapValue(AtlasConstants.StrTitle_LoginPage);}set;}
    public String ErrorMessage = '';
    public String username {get; set;}
    public String password {get; set;}
    public boolean isUsername{get;set;}
    public string str{get;set;}
    public string strTop{get;set;}
    public string siteURl{get;set;}
    public string pageURL{get;set;}
    public string usernamePlaceholder{get{return AtlasConstants.usernamePlaceholder;}set;}
    public string pwdPlaceholder{get{return AtlasConstants.pwdPlaceholder;}set;}
    public string checkMyEmailText{get{ return AtlasUtility.getHyperLinkText('Check My Email');}set;}
    public string checkMyEmailURL{get{return AtlasUtility.getURL('Check My Email');}set;}
    /**
    AtlasSiteLoginController
    Constructor
    */    
    public AtlasSiteLoginController(){
        //This code has been written for IE8 Browser Compatibility Issues. 
        Apexpages.currentPage().getHeaders().put(AtlasConstants.X_UA_COMPATIBLE,AtlasConstants.IE_8);
    }
    
    public PageReference redirect() 
    {  
        siteURl =site.getcurrentsiteurl();
        pageURL =ApexPages.currentPage().getUrl();
        pageURL=pageURL.replace(AtlasConstants.Apex_URL,AtlasConstants.BLANK);
        Pagereference reditrction;
                if(siteURl != null && siteURl.contains(AtlasConstants.Http_text))
        {       siteURl=siteURl.replace(AtlasConstants.Http_text, AtlasConstants.Https_text);
                system.debug('\n \n \n \n siteURl+pageURL : '+siteURl+pageURL);
                reditrction = new pagereference(siteURl+pageURL);
        }
        
        // 7/10/14 - Added as part of the phase II release to prevent existing users from accessing the old login page.
        reditrction = redirectToMain();
        
        return reditrction;
    }
    /**
    AtlasSiteLoginController
    Method to validate if the login credentials are correct and get error message accordingly   
    */     
    public PageReference login() {       
        String startUrl = AtlasConstants.STARTURL;

        Pagereference redirectPage = Site.login(username, password,startUrl); 
        if (redirectPage != null)
            return redirectPage;
        else
        {
          ErrorMessage = AtlasConstants.ERR_MSG;
          isUsername = false;
          return null;
        }  
    }

    /**
    AtlasSiteLoginController
    Method to error message 
    */       
    public String getLoginErrorMessage()
    {
        return ErrorMessage;
    }      

    /**
    AtlasSiteLoginController
    Method to validtae the user name is entered or not
    */       
    public PageReference redirectToForgotpassword()
    {
        if(AtlasUtility.isEmpty(username)|| username.trim().equalsIgnoreCase(usernamePlaceholder))
        {
            isUsername = true;
            ErrorMessage = '';
            return null;
        }
        else
        {
            isUsername=false;
            ErrorMessage='';
            String resetPwdBaseURL = strHyperLinkAddressForGotPassword;
            if(username.toUpperCase().contains(AtlasConstants.WILDBLUE_EMAIL_CHECK))
                resetPwdBaseURL=strHyperLinkAddressForGotPasswordWildblue;           
            String userNameChanged=username;
            if(username.trim().indexOf('@') >0)
                usernameChanged = username.trim().substring(0,username.indexOf('@'));            
            Pagereference reditrction = new pagereference(resetPwdBaseURL+usernameChanged);
            return reditrction;
        }
        
    }
    /**
    
       
    */     
    public PageReference redirectToLoginHelp() {       
        pagereference page=new pagereference(AtlasConstants.ATLAS_LOGIN_HELP_URL);
        page.setRedirect(true);
        return page; 
    }
    
    public PageReference redirectToNewUserSetup() {       
        pagereference page=new pagereference(AtlasConstants.ATLAS_NEW_USER_URL);
        page.setRedirect(true);
        return page; 
    }        
    
    public PageReference redirectToMain() {       
        pagereference page=new pagereference(AtlasConstants.ATLAS_COMMUNITY_URL);
        page.setRedirect(true);
        return page; 
    }                
}