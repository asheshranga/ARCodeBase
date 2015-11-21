public with sharing class SNGTabPaging 
{
    public List<SObject> sObjects { get; set; }
    
    public List<SObject> displaySObjects { get; set; }
    
    @TestVisible
    private integer pageNumber 
    { 
        get
        {
            return getPageNumber();
        }
        set
        {
            pageNumberStr = String.valueOf(value);
            pageNumber = value; 
        }
    } // 1-based (i.e. first page index is 1, not 0)
    
    
    public String pageNumberStr { get; set; }
       
    public integer totalPages { get; set; }
    public boolean isNextValid { get; set; }
    public boolean isPrevValid { get; set; }
    public String recordInfo 
    { 
       get 
       { 
       	
       	    return (sObjects.size() == 0) ? '':((pageNumber - 1) * amountToDisplay + 1) + ' - ' + 
                          ((pageNumber * amountToDisplay) < sObjects.size() ? (pageNumber * amountToDisplay) : sObjects.size()) + ' of ' +
                          sObjects.size();
       } 
       set;
    }    
    
    public integer amountToDisplay { get; private set; }  
    
    private static final integer MIN_PAGE_NUMBER = 1;
    private static final integer DEFAULT_OBJECTS_TO_DISPLAY = 10;
    
      
    public SNGTabPaging(List<SObject> sObjectList)
    {
        sObjects = sObjectList;
        initializePaging(); 
    }
    
    public void updateDisplay(List<SObject> sObjectList)
    {
        sObjects = sObjectList;
        displaySObjects = getPartialList(sObjects, pageNumber, amountToDisplay); 
    }
    
    private integer getPageNumber()
    {
        integer retValue;
        
        try
        {
            retValue = Double.valueOf(pageNumberStr).intValue();
            if (!isPageValid(retValue))
            {
                retValue = (retValue < MIN_PAGE_NUMBER) ? MIN_PAGE_NUMBER : totalPages;
            }
        }
        catch (Exception e)
        {
            retValue = MIN_PAGE_NUMBER;
        }
        
        pageNumberStr = String.valueOf(retValue);
        return retValue;
    }    

    private void initializePaging()
    {
        pageNumber = MIN_PAGE_NUMBER;
        amountToDisplay = DEFAULT_OBJECTS_TO_DISPLAY;
        totalPages = getTotalPages(sObjects.size(), amountToDisplay);
        displaySObjects = getPartialList(sObjects, pageNumber, amountToDisplay);
        isNextValid = (totalPages > MIN_PAGE_NUMBER);
        isPrevValid = false;        
    }
    
    public void gotoPage()
    {
       isPrevValid = isPageValid(pageNumber - 1);
       isNextValid = isPageValid(pageNumber + 1);
       displaySObjects = getPartialList(sObjects, pageNumber, amountToDisplay);
    }
    
    public void getFirstPage()
    {
        pageNumber = 1;
        isNextValid = true;
        isPrevValid = false;
        displaySObjects = getPartialList(sObjects, pageNumber, amountToDisplay);
    }
    
    public void getLastPage()
    {
        pageNumber = totalPages;
        isNextValid = false;
        isPrevValid = true;
        displaySObjects = getPartialList(sObjects, pageNumber, amountToDisplay);
    }
    
    /** 
     * navigate to the next page of Service Plan Table in visualforce page
     */ 
    public void getNextPage() 
    { 
        ++pageNumber; 
        isNextValid = (pageNumber < totalPages);
        displaySObjects = getPartialList(sObjects, pageNumber, amountToDisplay); 
        isPrevValid = true;
    } 
    
    /** 
     * navigate to the previous page of ServicePlan Table in visualforce page
     */
    public void getPrevPage() 
    { 
        pageNumber = Math.max(--pageNumber, 1);
        isPrevValid = (pageNumber > 1);
        displaySObjects = getPartialList(sObjects, pageNumber, amountToDisplay);
        isNextValid = true; 
    }
    
    /**
     * calculate the total amount of pages for the Service Plan Table 
     * 
     * @param   totalElements       The total number of Service Plans
     * @param   amount              The amount of Service Plans per page
     */ 
    public static integer getTotalPages(integer totalElements, integer amount) 
    {    
        integer quotient = totalElements/amount; 
        integer remainder = Math.mod(totalElements, amount);        
        return (remainder > 0) ? quotient + 1 : quotient;
    }
    
    
    private List<SObject> getPartialList(List<SObject> sObjects, integer pageNumber, integer amountToDisplay)
    {
        List<SObject> partialList = new List<SObject>(); 
        
        integer startIndex = Math.max(0, (pageNumber - 1)) * amountToDisplay; 
        integer listSize = sObjects.size();
        
        if (startIndex < listSize)
        {
            integer stopIndex = Math.min(startIndex + amountToDisplay, listSize); // stopIndex is not displayed
            
            for (integer i = startIndex; i < stopIndex; i++) 
            {
                partialList.add(sObjects.get(i)); 
            }      
        }
        
        return partialList;
    }
    
    private boolean isPageValid(integer pageNumber)
    {
        return ((pageNumber > 0) && (pageNumber <= totalPages)); 
    } 
}