/**
 * This class is used to construct dynamic query strings for salesforce objects to use
 * when performing a SOQL query on the Salesforce database. Apex does not support a SELECT * query, 
 * so this class provides the functionality to add all fields to a dynamic query string.
 */
public with sharing class SNG_SObjectQueryBuilder {
	
	/**
	 * Terminal__c SObject Name
	 */
	public static final String TERMINAL_OBJ_NAME = Terminal__c.sObjectType.getDescribe().getName();
	
	/**
	 * Modem__c SObject Name
	 */
	public static final String MODEM_OBJ_NAME = Modem__c.sObjectType.getDescribe().getName();
	
	/**
	 * ServicePlan__c SObject Name
	 */
	public static final String SERVICE_PLAN_OBJ_NAME = ServicePlan__c.sObjectType.getDescribe().getName();
	
	/**
	 * ModemServicePlan__c SObject Name
	 */
	public static final String MODEM_SERVICE_PLAN_OBJ_NAME = ModemServicePlan__c.sObjectType.getDescribe().getName();
	
	/**
	 * SObject Name for this query builder object
	 */
	private SObjectType sObjectType;
	
	/**
	 * The fields included in the query
	 */
	private Set<String> fields;
	
	/**
	 * Constructs a new SNG_SObjectQueryBuilder object with the given sObjectName
	 *
	 * @param 	sObjectName  	Name of the SObject to be queried
	 * @throws	SNG_Exception	If sObjectName is not a valid SObject name
	 */
	public SNG_SObjectQueryBuilder(final String sObjectName) {
		this(Schema.getGlobalDescribe().get(sObjectName));
	}
	
	/**
	 * Constructs a new SNG_SObjectQueryBuilder object with the given sObjectType
	 *
	 * @param 	sObjectType  	Type of the SObject to be queried
	 * @throws	SNG_Exception	If sObjectType is null
	 */
	public SNG_SObjectQueryBuilder(final SObjectType sObjectType) {
		SNG_ExceptionUtil.throwIfNullObject(sObjectType, 'sObjectType cannot be null.');
		
		this.sObjectType = sObjectType;
		this.fields = new Set<String>();
	}
	
	/**
	 * Adds all fields for sObjectType to the set of fields to be included in queries
	 * created by this object.
	 *
	 * @return		This SNG_SObjectQueryBuilder with all fields added
	 */
	public SNG_SObjectQueryBuilder addAllFields() {
        Schema.DescribeSObjectResult sObjectDescribe = sObjectType.getDescribe();
        Map<String, Schema.SObjectField> fieldMap = sObjectDescribe.fields.getMap();
        Set<String> fieldNames = fieldMap.keySet();
        for(String fieldName : fieldNames) {
        	if (isFieldQueryable(fieldMap, fieldName)) {
        		fields.add(fieldName);
        	}
        }
        
        return this;
	}
	
	/**
	 * Adds the relatedFieldName for the referenceField to the query
	 *
	 * @param 	referenceField  	The field in this sObjectType referencing the other sObject
	 * @param 	relatedFieldName	The field in the sObject specified by referenceField to add to the query
	 * @return	                	This SNG_SObjectQueryBuilder with the related field added
	 * @throws	SNG_Exception   	If the relatedFieldName is not related to the SObjectType of referenceField
	 */
	public SNG_SObjectQueryBuilder addRelatedField(final Schema.DescribeFieldResult referenceField, final String relatedFieldName) {
		SNG_ExceptionUtil.throwIfNullObject(referenceField, 'referenceField cannot be null.');
		SNG_ExceptionUtil.throwIfNullObject(relatedFieldName, 'relatedFieldName cannot be null.');
		
		assertFieldRelatedAndQueryable(referenceField, relatedFieldName);
		
		fields.add(referenceField.getRelationshipName() + '.' + relatedFieldName);
		return this;
	}
	
	/**
	 * Constructs the query, selecting all rows in the fields set, for the sObjectType
	 *
	 * @return	             	The query string
	 * @throws	SNG_Exception	If no fields were added
	 */
	public String constructQuery() {
		if (fields.isEmpty()) {
			throw new SNG_Exception('Fields must be added before constructing a query.');
		}
		return 'SELECT ' + StringUtils.joinStrings(fields, ',') + ' FROM ' + sObjectType.getDescribe().getName();
	}
	
	/**
	 * Checks if relatedFieldName is a field in the SObjectType of referenceField, and that it is
	 * queryable. If either the relatedFieldName is not a field in the SObjectType of referenceField or
	 * it is a non-queryable field, SNG_Exception is thrown.
	 *
	 * @param 	referenceField  	The field in this sObjectType referencing the other sObject
	 * @param 	relatedFieldName	The field in the sObject specified by referenceField
	 * @throws	SNG_Exception   	If referenceField is not the Reference type, if there was an
	 *        	                	error getting a reference to it, or if the field is not queryable
	 */
	private static void assertFieldRelatedAndQueryable(final Schema.DescribeFieldResult referenceField, final String relatedFieldName) {
		String errorMessage = null;
		
		// check if the field is the reference type
		if (Schema.DisplayType.Reference == referenceField.getType()) {
			Schema.SObjectType[] references = referenceField.getReferenceTo();
			
			// check that we could get a reference to the field
			if (null != references && !references.isEmpty()) {
				if (1 < references.size()) {
					errorMessage = 'Unable to determine the preferred reference to the ' + referenceField.getName() + ' reference field';
				}
				
				Map<String, Schema.SObjectField> relatedFields = references[0].getDescribe().fields.getMap();
				
				// check that the referenced object contains the related field
				if (SetUtils.lowerCase(relatedFields.keySet()).contains(relatedFieldName.toLowerCase())) {
					if (!isFieldQueryable(relatedFields, relatedFieldName)) {
						errorMessage = referenceField.getRelationshipName() + '.' + relatedFieldName + ' is not queryable.';
					}
				} else {
					errorMessage = referenceField.getRelationshipName() + ' does not have a field named ' + relatedFieldName + '.';
				}
			} else {
				errorMessage = 'Error getting reference to referenceField: ' + referenceField;
			}
		} else {
			errorMessage = 'referenceField is not of Reference type.';
		}
		
		if (null != errorMessage) {
			throw new SNG_Exception(errorMessage);
		}
	}
	
	/**
	 * Checks if the fieldName in fieldMap is queryable
	 *
	 * @param 	fieldMap 	The map of field name to SObjectField to lookup fieldName in
	 * @param 	fieldName	The field name to check if it can be queried
	 * @return	         	True if the field can be queried, otherwise false
	 */
	private static boolean isFieldQueryable(final Map<String, Schema.SObjectField> fieldMap, final String fieldName) {
		boolean queryable = true;
		
		// Location fields cannot be queried. The individual Location__Latitude__s and 
		// Location__Longitude__s fields are separate fields which can be queried.
		if (Schema.DisplayType.Location == fieldMap.get(fieldName).getDescribe().getType()) {
			queryable = false;
		}
		
		return queryable;
	}
	
}