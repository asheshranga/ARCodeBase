/*
 
	Created by: Dennis Estioco
	
	Controller used by the ITSMSViewStatRetriever component. This code takes in an article ID and then returns the normalized view score of that article. 

*/
public class ITSMSViewStatRetrieverController {
    public String articleId {get;set;}
    public LIST<Double> viewNormalizedScore{
        get{
            
            LIST<ITSMS__ka> thisArticle = [SELECT Id FROM ITSMS__ka WHERE Id =: articleId LIMIT 1];
            Id thisArticleId;
            for(ITSMS__ka a : thisArticle){   
                thisArticleId = a.Id;                
            }
            
            LIST<ITSMS__ViewStat> viewStat = [SELECT Id, ParentId, ViewCount, NormalizedScore FROM ITSMS__ViewStat WHERE ParentId =: thisArticleId];             
            
            if(viewStat.size() == 0){
                LIST<Double> defaultScores = new LIST<Double>{0};           
                return defaultScores;
            }                     
            
            LIST<Double> scores = new LIST<Double>(); 
            Double highestViewStat = 0;
            for(ITSMS__ViewStat v : viewStat){
                if(v.NormalizedScore > highestViewStat){
                    highestViewStat = v.NormalizedScore;
                }                           
            } 
            Decimal toRound = highestViewStat;
            highestViewStat = toRound.setScale(2);
            scores.add(highestViewStat);                             
            return scores; 
        }set;        
    }         


    public ITSMSViewStatRetrieverController(){
    }
          
}