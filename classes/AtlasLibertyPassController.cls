/*********************************************************************************
Name         : AtlasLibertyPassController
Created By   : Srikanth Kudumula
Modified BY  : 
Company Name : NTT Data
Project      : ViaSat Atlas
Created Date : 2 February 2015
Usages       : Controller for VisualForce Component : Atlas_Liberty_Plan_Details
*********************************************************************************/
public with sharing class AtlasLibertyPassController {
    
    public  AtlasPlanDetailsDTO planDtDTO{get;set;}
    public AtlasCurrentDataUsageDTO cudDTO{get;set;}
    public string LibertyPassText{get{return AtlasUtility.getMapValue(AtlasConstants.Atlas_Liberty_Pass_Text);}set;}
    public string LibertyPassMsg{get{return AtlasUtility.getMapValue(AtlasConstants.Atlas_Liberty_Pass_Message);}set;}
    public string LibertyPassEnabledMsg{get{return AtlasUtility.getMapValue(AtlasConstants.Atlas_Liberty_Pass_Enabled_Message);}set;}
    public string LibertyPassEnabledText{get{return AtlasUtility.getMapValue(AtlasConstants.Atlas_Liberty_Pass_Enabled_Text);}set;}
    public string LibertyPassLearnMoreText{get{return AtlasUtility.getMapValue(AtlasConstants.Atlas_Liberty_Pass_Learn_More_Text);}set;}
    public integer intValueOneFifty{get{return AtlasConstants.ONE_FIFTY;}set;}
    public String LibertyPassLink{get{return AtlasUtility.getURL('Liberty_Pass_Link');}set;}
    
    /**
      Atlas Liberty Pass Controller
      constructor
    */
    public AtlasLibertyPassController ()
    {
        Apexpages.currentPage().getHeaders().put(AtlasConstants.X_UA_COMPATIBLE,AtlasConstants.IE_8);        
    }
}