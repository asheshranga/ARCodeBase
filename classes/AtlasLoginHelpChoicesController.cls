public with sharing class AtlasLoginHelpChoicesController {
    
    public string selectedValue{get;set;}
    public List<SelectOption> getOptions() {
        List<SelectOption> options = new List<SelectOption>(); 
        options.add(new SelectOption(AtlasConstants.FORGOT_USERNAME,AtlasConstants.FORGOT_USERNAME)); 
        options.add(new SelectOption(AtlasConstants.RESET_PASSWORD,AtlasConstants.RESET_PASSWORD)); 
        return options; 
    }
    public AtlasComponenttoController componentToPage{get; set;}
    public string errorMessage{get;set;}
    public string loginHelpText{get{return AtlasConstants.LOGIN_HELP_TEXT;}set;}
    public string whathelp{get{return AtlasConstants.WHAT_DO_YOU_NEED_HELP;}set;}
    public string step{get{return AtlasConstants.STEP_1_4;}set;}
    public string cancel{get{return AtlasConstants.LOGIN_CANCEL;}set;}
    public string nextStep{get{return AtlasConstants.LOGIN_NEXT_STEP;}set;}
    public string scriptValue{get;set;}
    public string helpMsg{get{return AtlasUtility.getMapValue(Atlasconstants.FU_UNAME_HELP);}set;}
    public string accountHelpText1{get{return AtlasUtility.getMapValue(AtlasConstants.ACC_HELP_TEXT_1);}set;}
    public string accountHelpText2{get{return AtlasUtility.getMapValue(AtlasConstants.ACC_HELP_TEXT_2);}set;}
    public string userIdentHelpText1{get{return AtlasUtility.getMapValue(AtlasConstants.USER_IDENT_HELP_TEXT_1);}set;}
    public string userIdentHelpText2{get{return AtlasUtility.getMapValue(AtlasConstants.USER_IDENT_HELP_TEXT_2);}set;}
    
    public AtlasLoginHelpChoicesController()
    {
        errorMessage='';
        selectedValue=AtlasConstants.FORGOT_USERNAME;
    }
    
    public pagereference submitStep1()
    {
        if(Atlasutility.isEmpty(selectedValue))
        {
            errorMessage=Atlasconstants.LOGIN_HELP_ERROR_MSG;
            componentToPage.LHStep1=true;
            componentToPage.LHStep2=false;
            return null;
        }
        
        else if(selectedValue==AtlasConstants.FORGOT_USERNAME)
        {
            errorMessage='';
            componentToPage.LHStep1=false;
            componentToPage.LHStep2=true;
            scriptValue=AtlasConstants.FORGOT_USERNAME;
        }
        else if(selectedValue==AtlasConstants.RESET_PASSWORD)
        {
            errorMessage='';
            componentToPage.LHStep1=false;
            componentToPage.LHStep3=true;
            scriptValue=AtlasConstants.RESET_PASSWORD;
        }
        return null;
    }
    
    public pagereference Cancel()
    {   
        selectedValue=AtlasConstants.FORGOT_USERNAME;
        errorMessage='';
        String siteURl =site.getcurrentsiteurl();
        if(siteURl!=null && !siteURl.contains(AtlasConstants.Https_text))
        {
            siteURl.replace(AtlasConstants.Http_text,AtlasConstants.Https_text);
            return new PageReference( siteURl+Atlasconstants.ATLAS_COMMUNITY_URL);
        }
           else
           return new PageReference(Atlasconstants.ATLAS_DEV_URL);
        
    }
}