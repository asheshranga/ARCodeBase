/*********************************************************************************
Name         : AtlasKnowledgeBaseController 
Created By   : Shiva Shankar N 
Modified BY  : Shiva Shankar N
Company Name : NTT Data
Project      : ViaSat Atlas, Bangalore
Created Date : 18 October 2013
Modified Date: 13 November 2013
Usages       : Controller for VisualForce Component : AtlasDashboardPageKnowledgeBase
*********************************************************************************/

global with sharing class AtlasKnowledgeBaseController 
{
    //Variables used in the AtlasDashboardPageKnowledgeBase Component
    public String searchstring{get;set;} 
    public String strKnowledgebaseSearch; 
    public String strConcatinatedSearch{get;set;}   
    public String strRedirectSearchUrl{get;set;}
    public String strUrl;
    global boolean isVisibleChatInloginpage{get{if(ApexPages.currentPage().getUrl().contains(AtlasConstants.STRDASHBOARD))
            {return true;}
            else 
            return false;}set;} 
    public string KnowledgeBaseLabel{get{return AtlasUtility.getMapValue(AtlasConstants.STRHEADER3_AtlasKnowledgeBase);}set;}
    public string redirectURL{get;set;}    
    public String PopuplarArticlesLabel{get{return AtlasConstants.STRHEADER4_AtlasKnowledgeBase;}set;}    
    
    /**
    * @author Shiva Shankar
    * @description - zero parameter AtlasKnowledgeBaseController constructor
    * @input param  - null
    * @return null
    */     
    global AtlasKnowledgeBaseController() 
    {   
        strKnowledgebaseSearch=URL.getSalesforceBaseUrl().toExternalForm();
        redirectURL = AtlasConstants.KB_URL+'/publickbhome?dosearch=1&searchKeyword=';          
    }
    
    /**
    * @author Shiva Shankar
    * @description - redictToNewtab for KnowledgeBase Component
    * @input param  - null
    * @return pagereference
    */ 
    public pagereference redictToNewtab()
    {   
        strConcatinatedSearch = AtlasConstants.KB_URL+'/publickbhome?dosearch=1&searchKeyword='+searchstring; 
        PageReference pageRef=new PageReference(strConcatinatedSearch);
        
        return pageRef;  
    }
}