public class CCRFindDetailsforMailController {

    public String cases{
    get {
        String lsCases = '';
        for (CCRCaseAssociation__c c:[select ccr__c, case__c, case__r.casenumber from CCRCaseAssociation__c where ccr__r.id = :CCR]){
            lsCases += ', ' + c.case__r.casenumber;
        }
        
        return (lsCases.equals('') ? lsCases : lsCases.substring(1).trim());
    } set;}
    
    public String sites{
    get {
        String lsSites = '';
        for (CCRSiteAssociation__c s:[select ccr__c, siteNOC__c, siteNOC__r.AlternateSiteNames__c from CCRSiteAssociation__c where ccr__r.id = :CCR]){
            lsSites += ', ' + s.siteNOC__r.AlternateSiteNames__c;
        }
        
        return (lsSites.equals('') ? lsSites : lsSites.substring(1).trim());
    } set;}    

    public id CCR{get;set;}

    //initialize the controller
    public CCRFindDetailsforMailController () {

    }   
}