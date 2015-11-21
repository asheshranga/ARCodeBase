public class ITSMSupportCenterSelfHelpContollerPOC {
 // place in constants class later
 private Static Final Integer PAGE_NUMBER = 5;
 public String searchstring { get; set; }
 public ITSMSupportCenterSelfHelpContollerPOC() {
  
  //Use kav utility    
  String qryString = 'SELECT ActiveDate__c,Additional_Info__c,Area__c,End_Date__c,Section__c,Sort_Order__c,Summary,Title,URL__c FROM ITSMS__kav WHERE PublishStatus = \'Online\' AND Language= \'en_US\' ORDER BY Sort_Order__c DESC';

  List<ITSMS__kav> articleList= Database.query(qryString);
  maxSize = articleList.size() ;
 }

 Integer currentPage = 1;
 Integer maxSize = 1;
 public boolean getPrevRequired() {
  return currentPage > 1;
 }

 public boolean getNextRequired() {
  return currentPage * PAGE_NUMBER < maxSize;
 }
 public Decimal getCurrentPageNumber() {
  return this.currentPage;
 }
 public PageReference next() {
  if(maxSize > this.currentPage * PAGE_NUMBER) {
   this.currentPage = this.currentPage + 1;
  }
  return null;
 }   

 public PageReference previous() {       
  if(this.currentPage > 1){
   this.currentPage = this.currentPage - 1;
  }
   return null;
 }
}