public with sharing class SNG_REST_NameCollection extends SNG_REST_Collection {

	/**
	 * Name of the Sobject to query for 
	 */ 
	private String sObjectName; 
	
	/**
	 * Validator to check for IDs parameter 
	 */
	 private SNG_IValidator validator;  
	
	
	/**
	 * Constructor
	 *
	 * @param  sObjectName     Name of the SObject that is being referenced.
	 * @param  validator       The validator used to validate the IDs.
	 */ 
	public SNG_REST_NameCollection(String sObjectName, SNG_IValidator validator) { 
		
		this.sObjectName = sObjectName;
		
		if (validator == null) 
		{
			throw new SNG_Exception('Need a validator for: ' + sObjectName); 
		} 

		this.validator = validator;
	}

	
	/**
	 * Retrieves salesforce custom objects based on a list of IDs 
     * @param ids	ID names of the custom objects to be retrieved
     * @return		custom objects corresponding to the list of ID names
	 */ 
	@TestVisible 
	private sobject[] getSObjects(String[] ids) { 
		
		List<SObject> sObjects; 
		String queryString = 'SELECT Name FROM ' + sObjectName + ' WHERE '; 
		
		for(integer i = 0; i < ids.size(); i++) 
		{ 
			queryString += 'Name = ' + '\'' + ids[i] + '\''; 
			
			// not the last element, add OR 
			if (i < ids.size() - 1) 
			{ 
				queryString += ' OR '; 
			} 	
		}
		
		try { 
			sObjects = Database.query(queryString); 
		}
		catch(QueryException qe) { 
			throw new SNG_Exception('Invalid sObject name: ' + sObjectName); 
		}
		
		return sObjects; 
	}


	/**
	 * Retrieve all objects for a given object name 
	 * 
	 * @param 	sObjectName 	Name of the object i.e. Modem__c
	 * @return					List of objects, empty if no records for the object exists
	 * 							
	 */
	@TestVisible  
	private sobject[] getSObjects() { 
		
		List<SObject> sObjects; 
		String queryString = 'SELECT Name FROM ' + sObjectName; 
		
		try { 
			sObjects = Database.query(queryString); 
		}
		catch (QueryException qe) { 
			throw new SNG_Exception('Invalid sObject name: ' + sObjectName);
		}
		
		return sObjects; 
	}


    /**
     * Constructs the resulting list of JSON objects with the data corresponding to the collected objects
     *
     * @param detail    The current detail. this can be overridden as necessary.
     * @param ids       The collection of IDs for the data requested.
     * @param objs      The objects corresponding to the ids.
     * @return		    resulting list of JSON objects. Return type is polymorphic depending on the
     * 					particular API. Primitive types may be valid return types which precludes
     * 					the use of a marker interface as the return type in this signature
     */
	@TestVisible  
	private SNG_REST_Response constructResultList(SNG_REST_StatusDetail detail, String[] ids, SObject[] objs) { 
		
		// Extract the name field for each of the SObjects 
		List<String> sObjectNames = extractNameField(objs); 
		
		// If sObjectNames is empty or null, set to null for data portion of SNG_REST_Response
		if (sObjectNames == null || sObjectNames.isEmpty()) 
		{ 
			sObjectNames = null; 
		}
		
		SNG_REST_CollectionOutput items = new SNG_REST_CollectionOutput(sObjectNames); 
		
		return new SNG_REST_Response(detail, items); 
	}
	

	/**
	 * Extract the name field from the list of sObjects 
	 *
	 * @param	sObjects	List of sObjects
	 * @return				List of sObject names 
	 * 						empty List if no sObjects 
	 */
	@TestVisible 
	private List<String> extractNameField(SObject[] sObjects) { 
		List<String> sObjectNames = new List<String>(); 
		
		for (SObject obj : sObjects) 
		{ 
			sObjectNames.add((String) obj.get('Name')); 
		}
		
		return sObjectNames; 
	}
	
	/**
     * Checks if the ID name is of valid format
     * @param ids	ID name of salesforce custom object to check
     * @return		true if ID is valid; false otherwise
     */
    @TestVisible 
	private boolean isValidId(String Id) { 
		return validator.isValidFormat(Id); 
 	}	  
}