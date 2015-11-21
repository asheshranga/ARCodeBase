/**
 * This class is used to construct a query for all fields for a salesforce object to use
 * when performing a SOQL query on the Salesforce database. Apex does not support a SELECT * query, 
 * requiring all fields to be named when performing a SOQL call. The SOQL string is extensible
 * as the user can add futhur constraints to the query.
 */
public with sharing class SNG_SoqlSelectAll 
{
	/**
	 * The SOQL query string constructed from the command.
	 */
	public String soql;
	
	/**
	 * All the fields of the salesforce object.
	 */
	private String allFields;
	
	/**
	 * The salesforce object to construct a SOQL command for.
	 */
	private String sfo;
	
	/**
	 * This constructor is used to construct a SOQL query that can obtain all field values for a 
	 * particular Salesforce object in the database.
	 *
	 * @param 	sfo          	The Salesforce object to construct a query for.
	 * @throws	SNG_Exception	If an initialization error occurred.
	 */
	public SNG_SoqlSelectAll(String sfo)
	{	
        try
        {
        	initialize(sfo);
        }
        catch (Exception e)
        {
        	throw new SNG_Exception(e.getMessage());
        }
	}
	
	/**
	 * Adds a field in addition to the the other fields constructed for the SOQL query. This
	 * function is useful to obtain access to linked properties across multiple Salesforce objects.
	 *
	 * @param   field           The field to add to the SOQL query constructed.
	 */
	public void addField(String field)
	{
		allFields += ', ' + field;
		constructSoql();
	}
	
	/**
	 * Extracts and sets all the fields of the Salesforce object to be retrieved.
	 *
	 * @param   sfo             The Salesforce object to extract all relevant fields for the SOQL query.
	 */
	private void initialize(String sfo)
	{
		this.sfo = sfo;
        map<string, schema.sobjecttype> allSObjects = schema.getglobaldescribe();
        schema.sobjecttype q = allsobjects.get(sfo);       
        schema.describesobjectresult d = q.getdescribe();
        map<string, schema.sobjectfield> m = d.fields.getmap();
        set<string> s = m.keyset();
        string query = '';
        for(string f : s){
            //System.Debug('Field ' + f + ' Type: [' + m.get(f).getDescribe().getType() + ']');
            // Removing Location__c field since it is not actually a valid field for querying. 
            // The individual Location__Latitude__s and Location__Longitude__s fields are still 
            // in the query string.
            if (m.get(f).getDescribe().getType() != Schema.DisplayType.Location) {
                query += f + ', ';
            }
        }
        query = query.substring(0,query.length()-2);
        this.allFields = query;
        constructSoql();
	}
	
	/**
	 * Concatenates the fields and the Salesforce object name to construct a full SELECT * query.
	 */
	private void constructSoql()
	{
		this.soql = 'SELECT ' + this.allFields + ' FROM ' + this.sfo;
	}
}