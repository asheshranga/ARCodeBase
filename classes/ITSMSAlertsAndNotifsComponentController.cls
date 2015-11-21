/*
    Created on: October 29, 2015
    Author: Dennis Estioco
    
    Controller for the ITSMSAlertsAndNotifsComponent VF component. This code queries for Knowledge Articles Version records that have Area__c == 'LandingPage'
    and Section__c == 'Alerts & Notifications' for the VF component to display.
 
*/

public class ITSMSAlertsAndNotifsComponentController{

    public MAP<Id, ITSMS__kav> articleMap {get;set;}
    public LIST<ITSMS__kav> articleList {get;set;}

    public ITSMSAlertsAndNotifsComponentController(){     
	        
        articleMap = ITSMSKavUtility.getITSMSKavsDraft('LandingPage', 'Alerts & Notifications', 'Draft');
    
        if(articleMap != NULL){
            if(articleMap.values().size() > 0){ 
            	articleList = articleMap.values();
            }
        }                
        
    }
   

}