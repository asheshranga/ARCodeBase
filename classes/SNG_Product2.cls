public with sharing class SNG_Product2 {
	
	public static final String BUSINESS_AREA = 'TSN';
	public static final String FAMILY = 'EXEDE';
	
	private static final Map<Id, RecordType> RECORD_TYPES = new Map<Id, RecordType>([SELECT Id, Name FROM RecordType]);
	
	private static final Map<String, RecordType> RECORD_TYPES_BY_NAME = new Map<String, RecordType>();
	static {
		for (RecordType recType : RECORD_TYPES.values()) {
			RECORD_TYPES_BY_NAME.put(recType.Name, recType);
		}
	}
	
	/**
	 * Validates whether or not Products in Exede TSN are active or inactive 
	 *  
	 * @param	productType			The product being evaluated
	 * @return						True if the product is active, false if the product is inactive 
	 */
	public static boolean validateActiveProductType(final Product2 productType) { 
		boolean result = false; 
		
		// validate product's family, business area, and if product is active
		if (productType.Family == 'Exede' && isValidBusinessArea(productType.Business_Area__c))
		{
			result = productType.IsActive;
		}

		return result; 
	}
	
	/**
	 * Returns a new map containing only the new products which are becoming inactive
	 *
	 * @param  oldProducts Product map before the update
	 * @param  newProducts Product map after the update
	 * @return             Product map after the update, filtered to only contain the products which are becoming inactive
	 */
	public static Map<Id, Product2> extractProductsBecomingInactive(final Map<Id, Product2> oldProducts, final Map<Id, Product2> newProducts) {
		final Map<Id, Product2> productsBecomingInactive = new Map<Id, Product2>();
		for (Product2 product : newProducts.values()) {
			if (!product.IsActive && oldProducts.get(product.Id).IsActive) {
				productsBecomingInactive.put(product.Id, product);
			}
		}
		return productsBecomingInactive;
	}
	
	/**
     * Returns a new map containing only the products from the given products map which the record type matches recordTypeName
     * 
     * @param   products        Map of products
     * @param   recordTypeName  RecordType.Name as a String to look for in the products map
     * @return                  Map of products for the given recordTypeName
     */
	public static Map<Id, Product2> extractProductsWithMatchingRecordType(final Map<Id, Product2> products, final String recordTypeName) {
		final Map<Id, Product2> matchingProducts = new Map<Id, Product2>();
        for (Product2 product: products.values()) {
            if (doesProductRecordTypeNameMatch(product, recordTypeName)) {
                matchingProducts.put(product.Id, product);
            }
        }
        return matchingProducts;
    }
	
	/**
      * Adds an error to both the errors Map<ProductID, errorString> as well as to the Product record itself
      *
      * @param     errors  Map<ProductID, errorString> to add the error to
      * @param     product Product to add the error on
      * @param     error   The error message to add
      * @return            Map<ProductID, errorString> with the error added
      */
     public static Map<Id, String> addError(final Map<Id, String> errors, final Product2 product, final String error) {
        // add to map
        errors.put(product.Id, error);
        
        // add to record
        product.addError(error, false);
        
        return errors;
     }
     
     /**
     * Checks if the product's record type name matched the passed in recordTypeName
     *
     * @param  product         The product to check the record type name for
     * @param  recordTypeName  The record type name to compare against the product's
     * @return                 True if the passed in recordTypeName matches the product's record type name, otherwise false
     */
    private static boolean doesProductRecordTypeNameMatch(final Product2 product, final String recordTypeName) {
    	final RecordType actualRecordType = RECORD_TYPES.get(product.RecordTypeId);
    	final RecordType expectedRecordType = RECORD_TYPES_BY_NAME.get(recordTypeName);
        return (expectedRecordType == actualRecordType);
    }
	
	/**
	 * Parse custom label for allowable business areas for service plan types
	 * 
	 * @return 			String list of the allowable business areas
	 */
	public static Set<String> parseBusinessAreaCustomLabel() { 

		// Retrieve allowable business areas custom label
		String businessAreasStr = Label.SNGBusinessArea; 

		// Parse string into tokens using ',' delimiter
		List<String> businessAreaTokens = businessAreasStr.split(',');

		Set<String> businessAreaSet = new Set<String>();

		// Remove any leading or trailing whitespace, add to Set<String>  
		for (String businessArea : businessAreaTokens)
		{
			businessAreaSet.add(businessArea.trim());
		}

		return businessAreaSet;
	}

	/**
	 * Verify that the product's business area is a valid business area
	 * 
	 * @parse 	businessArea 		The Product's business area
	 * @return 						True if matches a valid business area, false it not
	 */
	private static boolean isValidBusinessArea(final String businessArea) {

		// Retrieve the Business Areas from Salesforce and determine if the argument is valid
		Set<String> validBusinessAreas = parseBusinessAreaCustomLabel();
		return validBusinessAreas.contains(businessArea);
	}
}