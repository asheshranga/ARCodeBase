/*********************************************************************************
Name         : AtlasGenericPaginationController
Created By   : Rahul Kumar Sharma
Modified BY  : Rahul Kumar Sharma
Company Name : NTT Data
Project      : ViaSat Atlas, Bangalore
Created Date : 22 October 2013
Modified Date: 13 November 2013
Usages       : Controller for VisualForce Component: AtlasBillHistoryPageBillingHistory
*********************************************************************************/
public with sharing  class AtlasGenericPaginationController{
	
   // Variables used for pagination
    public Integer index{get;set;}
    public Integer pageNum{get;set;}
    public Integer totalPage{get;set;}
    public Integer totalResults{get;set;}
    public List<Pager> pageList{get;set;}
    public Boolean showPrevious{get;set;}
    public Boolean showNext{get;set;}
    public Boolean isAll{get;set;}
         
    /**
      AtlasGenericPaginationController
      constructor
    */         
    public AtlasGenericPaginationController (Integer listSize,Integer pageSize){
        this.totalResults=listSize;
        pageSize=(pageSize > 0)?pageSize:10;
        this.totalPage=(Integer)Math.ceil((Double)listSize / (Double)pageSize);
        this.pageNum=1;
        this.index=0;
        this.isAll=(listSize==pageSize)?true:false;
        updateNumbers();
    }
     
    /**
      AtlasGenericPaginationController
      Method to Update the page numbers
    */       
    public void updateNumbers(){
        this.pageList=new List<Pager>();
        for(Integer i=1; i < (this.totalPage + 1); i++){
            Boolean b=(i==pageNum)?true:false;
            this.pageList.add(new Pager(i, b));
        }
        this.showPrevious=(this.pageNum==1)?false:true;
        this.showNext=(this.pageNum==this.totalPage)?false:true;
        this.index=this.pageNum-1;
    }
    
    /**
      AtlasGenericPaginationController
      Method to decrement the page number
    */           
    public void decrement(){
        this.pageNum=this.pageNum-1;
        updateNumbers();
    }
    
    /**
      AtlasGenericPaginationController
      Method to increment the page number
    */       
    public void increment(){
        this.pageNum++;
        updateNumbers();
    }
 
    /**
      AtlasGenericPaginationController
      Inner Class to determine the active page
    */  
    public class Pager{
        public Integer pageNum{get;set;}
        public Boolean isActive{get;set;}
         
        public Pager(Integer num,Boolean active){
            this.pageNum=num;
            this.isActive=active;
        }
    }
}