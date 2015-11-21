/**************************************************************************************************************
Name         : ITSMSSupportCenterSelfHelpContoller 
Created By   : Dianna Guilinger - Slalom 
Description  :  Controller for VF page using Knowledge Articles: ITSMSSupportCenterSelfHelp
             :
***************************************************************************************************************/
public class ITSMSSupportCenterSelfHelpContoller {
    public Integer currentPage {get;set;}
    public Integer maxSize {get;set;}
    //public static final Integer PAGE_NUMBER = 10; 
    public Integer articlesPerPage {
        get;set; 
    }

    public list<SelectOption> ratings = new list<SelectOption>(); 
     
    public Integer numberOfPages;
    public Integer maxSizeModulus;
    public Integer pageOffset = 0;     

    public boolean showJumpLinks {get;set;}
    public boolean showSortBy {get;set;}
    public String sortByOption {get;set;} 
    public String searchString {get; set; }        
    public String filterRating {get; set; }
    public String queryString {get; set; }
    public Integer clickedPage {get;set;}    
    public List<ITSMS__kav> articleList { get; set; } 
    public List<String> pageList {get; set; } 
    public ApexPages.StandardSetController setCon { get; set; }    
    
    public ITSMSSupportCenterSelfHelpContoller() {
        string articlesPerPageString = ITSMSConstants.SELF_HELP_ARTICLES_PER_PAGE;        
        articlesPerPage = Integer.valueOf(articlesPerPageString);
        Map<Id, ITSMS__kav> articleMap = ITSMSUtilityClass.getITSMSKavs('All','All','Online');
        articleList = ITSMSUtilityClass.createArticleList(articleMap);   
        showJumpLinks = true; 
                showSortBy = true;        
                sortByOption = 'mostViewed';        
        currentPage = 1;
        maxSize = articleList.size(); 
             
        searchString = ApexPages.currentPage().getParameters().get('j_id0:j_id1:j_id102:j_id103:j_id104:j_id105:theSearchstring');
        if((searchString!=null) && (searchString != '')){
            refreshSearchResult();
        }  

        pageList = new List<String>();
        numberOfPages = maxSize / articlesPerPage;            
        maxSizeModulus = math.mod(maxSize,articlesPerPage);
        if(maxSizeModulus != 0)
        {
           numberOfPages += 1;
        }
        
        for(integer i = 1; i <= numberOfPages; i++)
        {
            pageList.add(String.valueOf(i));
        }
    }
    
    public boolean getPrevRequired() {
        return currentPage > 1;
    }
    
    public boolean getNextRequired() {
        return currentPage * articlesPerPage < maxSize;
    }
    

    public Integer getCurrentPageNumber() {
        return this.currentPage;
    } 
    
    
     public PageReference next() {
      if(maxSize > this.currentPage * articlesPerPage) {
       this.currentPage = this.currentPage + 1;
      }
      return null;
     }     
    
        
     //action for previous click
     public PageReference previous() {        
      if(this.currentPage > 1)
       this.currentPage = this.currentPage - 1;
      return null;
     }
    
    
    public void jumpPage(){    
        
        Integer pagesAway = currentPage - clickedPage;                
        this.currentPage = clickedPage;        
    }    
    
     //sets filter parameters
     public PageReference checkRatingFilter() {     
         if(filterRating == 'Most Viewed'){
                        sortByOption = 'mostViewed';
         }
         else if(filterRating == 'Last Updated'){
                        sortByOption = 'lastUpdated';
         }
         else if(filterRating == 'Title'){
                        sortByOption = 'title';           
         }      
         return null;
     }     

     public List<SelectOption> getRatings() {
         //Creating a Rating filter list
         list<SelectOption> options = new list<SelectOption>();
         options.add(new SelectOption('Most Viewed','Most Viewed'));
         options.add(new SelectOption('Last Updated','Last Updated'));    
         options.add(new SelectOption('Title','Title'));    
         return options;
     }
    
     // Action call when the new list needs to be fetched
     public PageReference refreshSearchResult() {
        setCon = null;
        showJumpLinks = true;     
        showSortBy = true;             
        currentPage = 1;
        maxSize = articleList.size();          
        if((searchString != '')&&(searchString != NULL)){         
                maxSize = 1;             
            showJumpLinks = false;
                        showSortBy = false;            
        }
        return null;
     }
          
}