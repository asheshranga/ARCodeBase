/*
    Created on: November 2, 2015
    Author: Dennis Estioco
    
    Controller for the ITSMSFeatLinksComponent VF component. This code queries for Knowledge Articles Version records that have Area__c == 'LandingPage'
    and Section__c == 'Featured Links' for the VF component to display.
 
*/

public class ITSMSFeatLinksComponentController{

    public MAP<Id, ITSMS__kav> articleMap {get;set;}
    public LIST<ITSMS__kav> articleList {get;set;}

    public ITSMSFeatLinksComponentController(){     
	        
        articleMap = ITSMSKavUtility.getITSMSKavs('LandingPage', 'Featured Links');
    
        if(articleMap != NULL){
            if(articleMap.values().size() > 0){
            	articleList = articleMap.values();
            }
        }                
        
    }
   

}