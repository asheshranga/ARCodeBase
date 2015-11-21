/*
 * Class ITSMSMyCasesController
 * 
 * @version 1.0
 * @author  Dianna Guilinger - Slalom  
 *
 *  Usage: Controller for Visualforce page ITSMSMyCases
 *        
 *  functionality for generating list of ITSMS cases for logged on user
 * 
 */
 
 public with sharing class  ITSMSMyCasesController extends ITSMSPageControllerBase{
    
    // define variables
    public id thisUser {get;set;}
    public id caseRTId {get;set;}
    public string filterRule {get;set;}
    public string filterStatus {get;set;}
    public string filterYear {get;set;}
    public string newSearchText {get;set;}
    public string queryString {get;set;}
    public string selectRule {get;set;}
    public integer filterIntegerYear {get;set;}
    public integer noOfRecords{get;set;}
    public integer pageSize{get;set;}
    public set<Id> foundCaseIds {get;set;}
    public list<Case> unfilteredCaseList {get;set;}
    public list<SelectOption> years = new list<SelectOption>();
    public list<SelectOption> statuses = new list<SelectOption>();

    // set default sort field for list 
    public String sortField {
        get  { 
            if (sortField == null) 
                sortField = ITSMSConstants.MYCASES_SORTFIELD; 
            return sortField;  
        }
        set;
        }

    // set default sort direction for list 
    public String sortDir {
        get  { 
            if (sortDir == null) 
                sortDir = ITSMSConstants.MYCASES_SORTDIRECTION;  
            return sortDir;  
        }
        set;
    }
    // initialize search text 
    public string searchText {
        get { 
            if (searchText==null) 
                searchText = ''; 
            return searchText; }
                set;
        }

    // controller 
    public ApexPages.StandardSetController setCon {
        get{
            if (setCon == null)
            {
                initPage();
            }
            return setCon;
        }set;
    }

    
    // initializes page
    public void initPage() {
        thisUser = UserInfo.getUserId();
        caseRTId = Schema.SObjectType.Case.RecordTypeInfosByName.get(ITSMSConstants.CASE_RECORDTYPE).RecordTypeId;
        selectRule = ITSMSConstants.MYCASES_QUERY; 
        filterRule = '';
        filterYear='';
        filterStatus='';
        newSearchText = '';
                // gets all ITSMS cases visible to the logged on user
        unfilteredCaseList =  Database.query(selectRule); 
        runQuery();
    }
    // get cases returned from query
    public List<Case> getCases (){
        list<Case> caseList = new list<Case>();
        for (Case c: (List<Case>)setCon.getRecords())
            caseList.add(c);
        return caseList;
    } 

    // build options for Status filter using unfiltered list of cases requested by logged on user
    public List<SelectOption> getStatuses () {
        set<string> uniqueStatus = new set<string>();
        list<SelectOption> options = new List<SelectOption>();
        for (Case c:unfilteredCaseList)
        {
            uniqueStatus.add(c.Status);
        }
        options.add(new SelectOption('--All--','--All--'));
        for (string s:uniqueStatus)
        {
            options.add(new SelectOption(s,s));
        }
        return options;
        } 
    
    // build options for Year filter using unfiltered list of cases requested by logged on user
    public List<SelectOption> getYears () {
        set<string> uniqueYears = new set<string>();
        list<SelectOption> optiony = new List<SelectOption>();
        for (Case c:unfilteredCaseList)
        {
            uniqueYears.add(string.valueOf(c.CreatedDate.year()));
        }
        optiony.add(new SelectOption('--All--','--All--'));
        for (string y:uniqueYears)
        {
            optiony.add(new SelectOption(y,y));
        }
        return optiony;
    }

    // run query
    public void runQuery() {
        if (filterRule == '')
       {
            // default query skips closed cases
            queryString = selectRule + ' '+ ITSMSConstants.MYCASES_DEFAULT_FILTER + ' order by ' + sortField + ' ' + sortDir;
        } else
        {
            queryString = selectRule + ' ' + filterRule + ' order by ' + sortField + ' ' + sortDir;
        }
        setCon = new ApexPages.StandardSetController(Database.getQueryLocator(queryString));
        pageSize = integer.valueOf(ITSMSConstants.MYCASES_PAGESIZE);
        setCon.setPageSize(pageSize);
        noOfRecords = setCon.getResultSize();
    }
    
    // sets navigation for next page
    public Boolean hasNext {
        get {
                return setCon.getHasNext();
        }
        set;
    }
    
    // sets navigation for prior page
    public Boolean hasPrevious {
        get {
            return setCon.getHasPrevious();
        }
        set;
    }
    
    // sets page number
    public Integer pageNumber {
        get {
            return setCon.getPageNumber();
        }
        set;
    }
    
    // sets first page
    public void first() {
        setCon.first();
    }
    
    // sets last page
    public void last() {
        setCon.last();
    }
    
    // sets prior page
    public void previous() {
        setCon.previous();
    }
    
    // sets next page
    public void next() {
        setCon.next();
    }
    
    // toggles the sorting of query from asc<-->desc
    public void toggleSort() {
        sortDir = sortDir.equals('asc') ? 'desc' : 'asc';
        runQuery();
    } 
    
    // navigates to the Case Detail page for the selected case
    public pageReference caseDetail() {
        string caseId = ApexPages.currentPage().getParameters().get('caseKey');
        PageReference pageRef= new PageReference(ITSMSConstants.NAVIGATE_CASEDETAIL+'?Id='+caseId);
        pageRef.setredirect(true); 
        return pageRef;
    } 
   
    // refresh will reset search/filters  
    public pageReference refresh() {
        setCon = null;
        initPage();
        getCases();
        setCon.setPageNumber(1);
        return null;
    }
    
    // performs search for user entered keywords across case 
    public PageReference runSearch() {
        filterRule = '';
        if (!searchText.equals('') && searchText != null )
        {
            newSearchText = '\'*'+searchText+'*\'';
            List<List<SObject>> searchList = [FIND :newSearchText IN ALL FIELDS RETURNING Case (Id, CaseNumber)];
            list<Case> foundCases = ((List<Case>)searchList[0]);
            if (foundCases.size() > 0)
            {
                foundCaseIds = new set<Id>();
                for (Case fc:foundCases)
                {
                    foundCaseIds.add(fc.Id); 
                }
            }
                filterRule = 'AND Id IN :foundCaseIds';
        }
        runQuery();
        return null;
    }
    
    // sets filter parameters
    public PageReference checkQueryFilters() {
        filterRule = '';
        if (!filterYear.equals('') && filterYear.isNumeric() && filterYear != null )
        {
            filterIntegerYear = integer.valueOf(filterYear);
            filterRule += ' AND CALENDAR_YEAR(CreatedDate) = :filterIntegerYear ';
        }
        if (!filterStatus.equals('') && filterStatus <> '--All--' && filterStatus != null )
                filterRule += ' AND Status = :filterStatus ';
        runQuery();
        return null;
        }
}