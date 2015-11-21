@isTest(SeeAllData = true)
public class KBHomeSearchResultsTest
{ 
      static testmethod void  KBHomeSearchResultsTest() {     
/*        
        List<KnowledgeArticleVersion> kavList = KBHomeAnnouncements.insertTestArticles();
        List<sObject> l = new List<sObject>();
        for (KnowledgeArticleVersion k:kavList) {
            string categorizationName = k.ArticleType.replace('__kav', '__DataCategorySelection');
            sObject obj = Schema.getGlobalDescribe().get(categorizationName).newSObject();
            obj.put('parentId', k.Id);
            obj.put('DataCategoryGroupName', 'Care_Categories');
            obj.put('DataCategoryName', 'Announcements');
            l.add(obj);
             KBHomeSearchResults.ArticleLine Artline = new KBHomeSearchResults.ArticleLine(k);        
           }       
        insert l;
*/               
        KBHomeSearchResults controller = new KBHomeSearchResults();          
        controller.searchCriteria = 'Title test one';
        controller.internalCareCategory = 'Announcements__c';
        controller.customerCategory = 'Policies__c';
        controller.product = 'Exede__c';
        controller.loadSearchResults();
		list<integer> pages = controller.previousPages;
		pages = controller.nextPages;
        //controller.updatePage();
        //controller.changeData();
        controller.BuildSOQLQuery(); 
        controller.BuildSOSLQuery();
        controller.loadArticles();
        boolean categoryAdded = false;   
       
		//testmethod KbHomesearchResultPaginateTest() {            
        //KbHomesearchResultPaginate.Pager cmp = new KbHomesearchResultPaginate.Pager(20,true);       
        //KbHomesearchResultPaginate controller2 = new  KbHomesearchResultPaginate(20,5);          
        //controller2.updateNumbers();
        //controller2.decrement();
        //controller2.increment();       
       }          
   }