/**************************************************************************************************************
Name         : ITSMSArticleComponentController 
Created By   : Dianna Guilinger - Slalom 
Description  :  Controller for VF components using Knowledge Articles: ITSMSAlertsAndNotifications, 
                    ITSMSFooter, ITSMSInformationText, ITSMSFeatLinks
             :  This code queries for Knowledge Articles Version records for the Area__c passed via parameter
***************************************************************************************************************/

public class ITSMSArticleComponentController extends ITSMSComponentControllerBase {

    // get reference to area parameter
    public string areaContext { 
        get;set{
            if (value != null) 
                areaContext = value;
        }
    }

    // get reference to section parameter
    public string sectionContext { 
        get;set{
            if (value != null) 
                sectionContext = value;
        }
    }
    
    // get reference to article type parameter
    public string articleType { 
        get;set{
            if (value != null) 
                articleType = value;
        }
    }


    // get map of knowledge articles 
    public MAP<Id, ITSMS__kav> articleMap {
        get {
            map<Id, ITSMS__kav> articleMap = ITSMSUtilityClass.getITSMSKavs(areaContext, sectionContext, articleType);
            return articleMap;
        }
        set;
    }

    // get list of knowledge articles 
    public LIST<ITSMS__kav> articleList { 
        get {
            list<ITSMS__kav> articleList = ITSMSUtilityClass.createArticleList(articleMap);
            return articleList;
        }
        set;
    }
}