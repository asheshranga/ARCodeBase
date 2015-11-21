/**************************************************************************************************************
Name         : ITSMSTemplateController 
Created By   : Dianna Guilinger - Slalom 
Description  : Controller for VF Template
***************************************************************************************************************/



public class ITSMSLandingPageController extends ITSMSPageControllerBase{
    public String RequestHelpCSS {get;set;}
    public String RequestHelpTabCSS {get;set;}
    public String MyCasesCSS {get;set;}
    public String MyCasesTabCSS {get;set;}
    public String MyNewHiresCSS {get;set;}
    public String MyNewHiresTabCSS {get;set;}


    public ITSMSLandingPageController () {
    
        setNavigationElements();
        String activeTab = ApexPages.currentPage().getParameters().get('tab');
        if (activeTab == ITSMSConstants.TAB_REQUESTHELP) {
            RequestHelpCSS = 'active';
            RequestHelpTabCSS = 'tab-pane fade in active';
            MyCasesCSS = '';
            MyCasesTabCSS = 'tab-pane fade';
            MyNewHiresCSS = '';
            MyNewHiresTabCSS = 'tab-pane fade';
        } else if (activeTab == ITSMSConstants.TAB_MYCASES) {
            RequestHelpCSS = '';
            RequestHelpTabCSS = 'tab-pane fade';
            MyCasesCSS = 'active';
            MyCasesTabCSS = 'tab-pane fade in active';
            MyNewHiresCSS = '';
            MyNewHiresTabCSS = 'tab-pane fade';
        } else if (activeTab == ITSMSConstants.TAB_MYNEWTEAM ) {
            RequestHelpCSS = '';
            RequestHelpTabCSS = 'tab-pane fade';
            MyCasesCSS = '';
            MyCasesTabCSS = 'tab-pane fade';
            MyNewHiresCSS = 'active';
            MyNewHiresTabCSS = 'tab-pane fade in active';
        } else {
            RequestHelpCSS = 'active';
            RequestHelpTabCSS = 'tab-pane fade in active';
            MyCasesCSS = '';
            MyCasesTabCSS = 'tab-pane fade';
            MyNewHiresCSS = '';
            MyNewHiresTabCSS = 'tab-pane fade';
        }
    }
    
    public void RequestHelp () {
    ApexPages.currentPage().getParameters().put('tab', ITSMSConstants.TAB_REQUESTHELP);
    }    
    
    public void MyCases () {
        ApexPages.currentPage().getParameters().put('tab', ITSMSConstants.TAB_MYCASES);
    }
    
    public void MyNewHires () {
        ApexPages.currentPage().getParameters().put('tab', ITSMSConstants.TAB_MYNEWTEAM);
    }
}