/*********************************************************************************
Name         : AtlasSupportBlockController 
Created By   : Raghuprasad Halkere
Modified BY  : Raghuprasad Halkere
Company Name : NTT Data
Project      : ViaSat Atlas, Bangalore
Created Date : 23 October 2013
Modified Date: 13 November 2013
Usages       : Controller for VisualForce component: SupportBlock
*********************************************************************************/
public with sharing class AtlasSupportBlockController{
    
   // Intializing GlobalVariables for HyperLinkURL
    public string strKnowledgeBaseURL{get{return AtlasUtility.getURL(AtlasConstants.KNOWLEDGE_BASE);}set;}   
    public String strVoicePromoUrl{get{return AtlasUtility.getURL(AtlasConstants.Voice_Promo);}set;}
    public String strExcedeVoiceUrl{get{return AtlasUtility.getURL(AtlasConstants.EXEDE_VOICE);}set;}
    public String strExcedeCommunityUrl{get{return AtlasUtility.getURL(AtlasConstants.EXEDE_COMMUNITY);}set;}
        
   // Intializing Global Variables for HyperLinkText 
    public string strLearnAboutExedeVoiceText{get{return AtlasUtility.getHyperLinkText(AtlasConstants.Learn_About_ExedeVoice);}set;}  
    public string strVisitExedeCommunityText{get{return AtlasUtility.getHyperLinkText(AtlasConstants.EXEDE_COMMUNITY_VISIT);}set;}  
    public string strVisitTheKnowledgeBaseText{get{return AtlasUtility.getHyperLinkText(AtlasConstants.Visit_TheKnowledge_Base);}set;}
    public string strKnowledgeBaseText{get{return AtlasUtility.getHyperLinkText(AtlasConstants.KNOWLEDGE_BASE);}set;}
    public string strExedeVoiceText{get{return AtlasUtility.getHyperLinkText(AtlasConstants.EXEDE_VOICE);}set;}
    public string strExedeCommunityText{get{return AtlasUtility.getHyperLinkText(AtlasConstants.EXEDE_COMMUNITY);}set;}
    public string KnowledgeBaseLabel{get{return AtlasUtility.getMapValue(AtlasConstants.STRHEADER3_AtlasKnowledgeBase);}set;}    
   // Intializing Global Variables for IsVisibility        
    public Boolean isVisibleExedeVoice{get{return AtlasUtility.getVisibility(AtlasConstants.Learn_About_ExedeVoice);}set;}    
    public Boolean isVisibleKnowledgebase{get{return AtlasUtility.getVisibility(AtlasConstants.Visit_TheKnowledge_Base);}set;}           
    public Boolean isVisibleExVoice{get{return AtlasUtility.getVisibility(AtlasConstants.EXEDE_VOICE);}set;}
    public Boolean isVisibleExCommunity{get{return AtlasUtility.getVisibility(AtlasConstants.EXEDE_COMMUNITY);}set;}
    public Boolean isVisibleKnowledge{get{return AtlasUtility.getVisibility(AtlasConstants.KNOWLEDGE_BASE);}set;}    
    
    /**
    * @author Raghuprasad Halakere
    * @description - Zero paramter AtlasSupportBlockController constructor 
    * @input param  - null
    * @return null 
    */
    public AtlasSupportBlockController()
    {        
    }       
}