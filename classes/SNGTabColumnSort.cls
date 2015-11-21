public with sharing class SNGTabColumnSort 
{

    private String sortDirection = 'ASC';
    private String sortExp = 'name';
    
    private String sortNullDirection = 'NULLS FIRST'; 
    
    public String sortExpression
    {
        get
        {
            return sortExp;
        }
        set
        {
            //if the column is clicked on then switch between Ascending and Descending modes
            if (value == sortExp) { 
                sortDirection = (sortDirection == 'ASC')? 'DESC' : 'ASC';
                sortNullDirection = (sortDirection == 'ASC') ? 'NULLS FIRST' : 'NULLS LAST';
            } 
            else { 
                sortDirection = 'ASC';
                sortNullDirection = 'NULLS FIRST'; 
            }
            sortExp = value;
        }
    }
    
    
    private String baseQuery;
    
       
    public SNGTabColumnSort(String query)
    {
    	baseQuery = query;
    }
    
    
    public String getSortDirection()
    {
        //if not column is selected 
        if (sortExpression == null || sortExpression == '')
            return 'ASC';
        else
            return sortDirection;
    }

    public void setSortDirection(String value)
    {  
    	if ('ASC' == value || 'DESC' == value)
            sortDirection = value;
    }
    
    public List<SObject> ViewData() 
    {
       //build the full sort expression
       String query = baseQuery + ' ORDER BY ' + sortExpression + ' ' + sortDirection + ' ' + sortNullDirection;
       System.debug(query);
       return Database.query(query);
    }
}