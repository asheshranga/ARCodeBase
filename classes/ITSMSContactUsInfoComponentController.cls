/**************************************************************************************************************
Name         : ITSMSContactUsInfoComponentController 
Created By   : Dianna Guilinger - Slalom 
Description  : Controller for VF Component ITSMSContactUsInfo
             : Obtains passed parameters, manages page action
***************************************************************************************************************/
public class ITSMSContactUsInfoComponentController extends ITSMSPageControllerBase{  

    public String contactUsSupport{get;set;}    
    public String contactUsEmail{get;set;}
    public String contactUsPhone{get;set;}    
    public String contactUsHours{get;set;}          
    public String formattedPhoneNumber{get;set;}
    public ITSMS__kav phoneArticle {get;set;}
    public ITSMS__kav emailArticle {get;set;}
    public ITSMS__kav hoursArticle {get;set;}
    public ITSMS__kav supportArticle {get;set;}
    public ITSMSContactUsInfoComponentController(){  
      
        setNavigationElements();
		supportArticle = retrieveInfoArticle(ITSMSConstants.CONTACT_US_SUPPORT);
        emailArticle = retrieveInfoArticle(ITSMSConstants.CONTACT_US_EMAIL);
        phoneArticle = retrieveInfoArticle(ITSMSConstants.CONTACT_US_PHONE);  
        hoursArticle = retrieveInfoArticle(ITSMSConstants.CONTACT_US_HOURS);   
                 
        if(supportArticle != NULL){
            contactUsSupport = supportArticle.URL__c;            
		}
        if(emailArticle != NULL){
            contactUsEmail = emailArticle.Summary;            
		}
        if(hoursArticle != NULL){
            contactUsHours = hoursArticle.Summary;               
		}        
        
    }
    
    // Get articles for contact area, section
    private ITSMS__kav retrieveInfoArticle(String section){
        MAP<Id, ITSMS__kav> articleMap;
        LIST<ITSMS__kav> articleList; 
    
        articleMap = ITSMSUtilityClass.getITSMSKavs(ITSMSConstants.CONTACT_US_AREA, section, 'Online');         
    	articleList = ITSMSUtilityClass.createArticleList(articleMap);
        if(articleList.size() != 0){
        	return articleList[0];
        }else{
            return NULL;
        }
    }   
}