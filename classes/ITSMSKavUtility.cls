//=================================================================================================================
//@author  
//Usage: 
//================================================================================================================  
public class ITSMSKavUtility {
/**
  *@name 
  *@description 
  */
    public static Map<Id,ITSMS__kav> getITSMSKavs(String areaContext, String sectionContext ){
        String area = areaContext;
        String section = sectionContext;
        
        try{
            Map<Id, ITSMS__kav> KnowledgeStructureMap =  new Map<Id, ITSMS__kav> ([ SELECT ActiveDate__c,Additional_Info__c,Area__c,
                                                                                    End_Date__c,Section__c,Sort_Order__c,Summary,Title,URL__c 
                                                                                    FROM ITSMS__kav 
                                                                                    WHERE PublishStatus = 'Online' 
                                                                                    AND Language= 'en_US'
                                                                                    AND Area__c =: area
                                                                                    AND Section__c =:section
                                                                                    ORDER BY Sort_Order__c DESC ]); 
            return KnowledgeStructureMap;
        }catch(Exception ex){
            System.debug(ex.getMessage());
			return null;

        }
    }
	
    // Will combine this method with the getITSMSKavs once testing of this method is complete
    public static Map<Id,ITSMS__kav> getITSMSKavsDraft(String areaContext, String sectionContext, String publishStatusContext){
        String area = areaContext;
        String section = sectionContext; 
                   
        if(publishStatusContext == 'Draft'){
            try{
                Map<Id, ITSMS__kav> KnowledgeStructureMap =  new Map<Id, ITSMS__kav> ([ SELECT ActiveDate__c,Additional_Info__c,Area__c,
                                                                                        End_Date__c,Section__c,Sort_Order__c,Summary,Title,URL__c 
                                                                                        FROM ITSMS__kav 
                                                                                        WHERE PublishStatus =: 'Draft' 
                                                                                        AND Language= 'en_US'
                                                                                        AND Area__c =: area
                                                                                        AND Section__c =:section
                                                                                        ORDER BY Sort_Order__c DESC ]); 
                return KnowledgeStructureMap;
            }catch(Exception ex){
                System.debug(ex.getMessage());
                return null;
    
            }
        } 
        
        else{
            try{
                Map<Id, ITSMS__kav> KnowledgeStructureMap =  new Map<Id, ITSMS__kav> ([ SELECT ActiveDate__c,Additional_Info__c,Area__c,
                                                                                        End_Date__c,Section__c,Sort_Order__c,Summary,Title,URL__c 
                                                                                        FROM ITSMS__kav 
                                                                                        WHERE PublishStatus =: 'Online' 
                                                                                        AND Language= 'en_US'
                                                                                        AND Area__c =: area
                                                                                        AND Section__c =:section
                                                                                        ORDER BY Sort_Order__c DESC ]); 
                return KnowledgeStructureMap;
            }catch(Exception ex){
                System.debug(ex.getMessage());
                return null;
    
            }            
        }
    }    
    

}