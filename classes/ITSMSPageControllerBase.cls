/**************************************************************************************************************
Name         : ITSMSPageControllerBase 
Created By   : Dianna Guilinger - Slalom 
Description  : Manages communication between VF Page ITSMSSupportRequest and all components
***************************************************************************************************************/
public with sharing virtual class ITSMSPageControllerBase {
    private ITSMSComponentControllerBase myComponentController;
    private Map<String, ITSMSComponentControllerBase>componentControllerMap; 
  
  
    public String agileSection{get;set;}
    public String alertsArea{get;set;}
    public String alertsSection{get;set;}
    public String alertsType{get;set;}
    public string contactUsNav {get;set;}
    public String desktopSection {get;set;}
    public String featuredLinkArea{get;set;}
    public String featuredLinkSection{get;set;}
    public String featuredLinkType{get;set;}
    public String footerArea{get;set;}
    public String footerSection{get;set;}
    public String footerType{get;set;}
    public String formsArea{get;set;}
    public String formsSection{get;set;}
    public String formsType{get;set;}
    public String formTitle{get;set;}
    public string homeNav {get;set;}
    public string myCasesNav {get;set;}
    public string myNewHiresNav {get;set;}
    public string newHireArea {get;set;}
    public string newHireType {get;set;}
    public string requestNav {get;set;}
    public string selfHelpNav {get;set;}

    public virtual ITSMSComponentControllerBase getMyComponentController() {
        return myComponentController;
    }

    // set up navigation elements
    // only call this if you're planning on using links in that page
    public virtual void setNavigationElements(){
        agileSection = ITSMSConstants.INFOTEXT_SECTION_AGILE;
        alertsArea = ITSMSConstants.ALERTS_AREA;
        alertsSection = ITSMSConstants.ALERTS_SECTION;
        alertsType = ITSMSConstants.ALERTS_TYPE;
        contactUsNav = ITSMSConstants.NAVIGATE_CONTACT_US_PAGE;
        desktopSection = ITSMSConstants.INFOTEXT_SECTION_DESKTOP;
        featuredLinkArea = ITSMSConstants.FEATUREDLINK_AREA;
        featuredLinkSection = ITSMSConstants.FEATUREDLINK_SECTION;
        featuredLinkType = ITSMSConstants.FEATUREDLINK_TYPE;
        footerArea = ITSMSConstants.FOOTER_AREA;
        footerSection = ITSMSConstants.FOOTER_SECTION;
        footerType = ITSMSConstants.FOOTER_TYPE;
        formsArea = ITSMSConstants.FORMS_AREA;
        formsSection = ITSMSConstants.FORMS_SECTION;
        formsType = ITSMSConstants.FORMS_TYPE;
        homeNav = ITSMSConstants.NAVIGATE_HOME_PAGE;
        myCasesNav = ITSMSConstants.NAVIGATE_MY_CASES_PAGE;
        myNewHiresNav = ITSMSConstants.NAVIGATE_NEW_HIRES_PAGE;
        newHireArea = ITSMSConstants.INFOTEXT_AREA_NEWHIRE;
        newHireType = ITSMSConstants.INFOTEXT_TYPE_NEWHIRE;
        requestNav = ITSMSConstants.NAVIGATE_REQUEST_HELP_PAGE;
        selfHelpNav = ITSMSConstants.NAVIGATE_SELF_HELP_PAGE;
     }

    public virtual void setTitleOfForm(String formCategory){
        if (formCategory == ITSMSConstants.FORM_CATEGORY_ACCESS){
            formTitle = ITSMSConstants.FORM_TITLE_ACCESS;
        } else if(formCategory == ITSMSConstants.FORM_CATEGORY_GENERAL){
            formTitle = ITSMSConstants.FORM_TITLE_GENERAL;
        } else if(formCategory == ITSMSConstants.FORM_CATEGORY_CONFERENCING) {
            formTitle = ITSMSConstants.FORM_TITLE_CONFERENCING;
        } else if(formCategory == ITSMSConstants.FORM_CATEGORY_SERVER){
            formTitle = ITSMSConstants.FORM_TITLE_SERVER;
        } else if(formCategory == ITSMSConstants.FORM_CATEGORY_MOBILITY){
            formTitle = ITSMSConstants.FORM_TITLE_MOBILITY;
        } else if(formCategory == ITSMSConstants.FORM_CATEGORY_WORKSTATION){
            formTitle = ITSMSConstants.FORM_TITLE_WORKSTATION;
        } else if(formCategory == ITSMSConstants.FORM_CATEGORY_SOFTWARE){
            formTitle = ITSMSConstants.FORM_TITLE_SOFTWARE;
        }
    }

  // get controller/component map
  public virtual Map<String, ITSMSComponentControllerBase> getComponentControllerMap(){
    return componentControllerMap;
  }

  // add component to map 
  public virtual void setComponentControllerMap(String key, ITSMSComponentControllerBase compController){
    if(componentControllerMap == null)
      componentControllerMap = new Map<String, ITSMSComponentControllerBase>();
    componentControllerMap.put(key,compController);
  }
  
  // set component controller  
  public virtual void setComponentController(ITSMSComponentControllerBase compController) {
    myComponentController = compController;
  }
  
  public ITSMSPageControllerBase getThis() {
    return this;
  }
}