/*********************************************************************************
Name         : AtlasLoginHelpController
Created By   : Shiva Shankar Nalluri
Modified BY  : Shiva Shankar Nalluri
Company Name : NTT Data
Project      : ViaSat Atlas, Bangalore
Created Date : 
Modified Date: 
Usages       : Controller for VisualForce Page: AtlasLoginHelp
*********************************************************************************/
public with sharing class AtlasLoginHelpController {
    
    public string strTitle{get{ return AtlasConstants.LOGIN_HELP_TEXT;}set;}
    public string PswdReset{get{return AtlasUtility.getMapWispValue(Atlasconstants.Wisp_Pswd_Reset);}set;}
    public string pswdSuccess{get{return AtlasUtility.getMapWispValue(Atlasconstants.Wisp_Pswd_Success);}set;}
    public string backtoLogin{get{return AtlasUtility.getMapWispValue(Atlasconstants.Wisp_LoginPage);}set;}
    public AtlasComponenttoController componentToPage {get; private set;}
    /**
    * @author Shiva Shankar
    * @description - Constructor for AtlasLoginHelpController
    * @input param  - null
    * @return null
    */ 
    public AtlasLoginHelpController()
    {
        //This code has been written for IE8 Browser Compatibility Issues. 
        Apexpages.currentPage().getHeaders().put(AtlasConstants.X_UA_COMPATIBLE,AtlasConstants.IE_8);
        componentToPage = new AtlasComponenttoController();
        componentToPage.LHStep1=true;
        componentToPage.LHStep2=false;
        componentToPage.LHStep3=false;
        componentToPage.LHStep4=false;
    }
    /**
    * @author Tejesh Kumar
    * @description - Redirecting to Home page for WISP
    * @input param  - null
    * @return null
    */ 
    public pagereference backToLogin()
    {   
        String siteURl =site.getBaseUrl();
        if(siteURl!=null && !siteURl.contains(AtlasConstants.Https_text))
        {
            siteURl.replace(AtlasConstants.Http_text,AtlasConstants.Https_text);
            return new PageReference( siteURl+Atlasconstants.ATLAS_COMMUNITY_URL);
        }
           else
           return new PageReference(Atlasconstants.ATLAS_DEV_URL);
        
    }  

}