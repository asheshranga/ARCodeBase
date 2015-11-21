public with sharing class SNG_Product2Validation {
	
	// TODO: move record type to SNGKeyValueType

	/**
	 * The Product Record Type for Terminal Type to validate against
	 */
	public static final transient String TERMINAL_TYPE_RECORD_TYPE_NAME = 'Terminal Types';

	public static final transient String SERVICE_PLAN_RECORD_TYPE_NAME = 'Service Plan Types';

	public SNG_Product2Validation() 
	{
		
	}

	public static List<Product2> validateUpdates(Map<Id, Product2> oldProducts, Map<Id, Product2> updatedProducts)
	{
		List<Product2> validProducts = new List<Product2>();

		try
		{
			// only care about the original product. If the old product was not an SNG type, it is okay to be updated
			// to an SNG product. If a switch like that requires additional checks, then the SNG products would need
			// to be modified.
			Map<Id, Product2> sngProducts = getSngProducts(oldProducts);
			validProducts = validateSngProductUpdates(sngProducts, updatedProducts);
		}
		catch (Exception e)
		{

		}

		return validProducts;
	}


	private static List<Product2> validateSngProductUpdates(final Map<Id, Product2> sngProducts, final Map<Id, Product2> updatedProducts)
	{
		Map<Id, List<SObject>> servicePlansUsingProduct = createMappingProductIdToServicePlan(sngProducts.keySet());
		Map<Id, List<SObject>> terminalTypesUsingProduct = createMappingProductIdToTerminal(sngProducts.keySet());
		// note that only one map is needed for MSP. The Service Plan and Terminal are objects with unique IDs.
		Map<Id, List<SObject>> activeAndFutureMspsUsingProduct = createMappingProductIdToActiveAndFutureModemServicePlans(sngProducts.keySet());

		for (Product2 sngProduct : sngProducts.values())
		{
			Product2 updatedProduct = updatedProducts.get(sngProduct.Id);
		    if (validateSngProductUpdate(sngProduct, updatedProduct, servicePlansUsingProduct, terminalTypesUsingProduct))
		    	System.debug('Hello');
		}

		return null;

	}


	private static boolean validateSngProductUpdate(Product2 sngProduct, 
													Product2 updatedProduct,  
													Map<Id, List<SObject>> servicePlansUsingProduct,
												    Map<Id, List<SObject>> terminalTypesUsingProduct)
	{
		// if product type changed
		return  validateProductType(sngProduct, updatedProduct, servicePlansUsingProduct, terminalTypesUsingProduct) &&
				validateRecordTypeChange(sngProduct, updatedProduct, servicePlansUsingProduct, terminalTypesUsingProduct) &&
				validateActiveState(sngProduct, updatedProduct, servicePlansUsingProduct, terminalTypesUsingProduct);
	}

	private static boolean validateProductType(Product2 sngProduct, 
											   Product2 updatedProduct,  
											   Map<Id, List<SObject>> servicePlansUsingProduct,
											   Map<Id, List<SObject>> terminalTypesUsingProduct)
	{
		boolean retValue = true;
		if (!isSngProduct(updatedProduct))
		{
			// if a product is not an SNG product anymore, ensure that a service plan or terminal is not assigned to it.
			retValue = validateProductIsNotInUse(sngProduct, updatedProduct, servicePlansUsingProduct, terminalTypesUsingProduct);	
		}		

		return retValue;
	}

	private static boolean validateRecordTypeChange(Product2 sngProduct, 
													Product2 updatedProduct,  
													Map<Id, List<SObject>> servicePlansUsingProduct,
												    Map<Id, List<SObject>> terminalTypesUsingProduct)
	{
		boolean retValue = true;  // assume true.

		if (isSngProduct(sngProduct) && isRecordTypeChanged(sngProduct, updatedProduct))
		{
			retValue = validateProductIsNotInUse(sngProduct, updatedProduct, servicePlansUsingProduct, terminalTypesUsingProduct);
		}

		return retValue;
	}

	private static boolean validateActiveState(Product2 sngProduct, 
											   Product2 updatedProduct,  
											   Map<Id, List<SObject>> servicePlansUsingProduct,
											   Map<Id, List<SObject>> terminalTypesUsingProduct)
	{
		if (isProductBeingDeactivated(sngProduct, updatedProduct))
		{
			// more checks here.
		}

		return true;  //to be implementated (should test deactivate)
	}

	private static Map<Id, List<SObject>> createMappingProductIdToTerminal(final Set<Id> productIds)
	{
		List<Terminal__c> terminals = [SELECT Id, Name FROM Terminal__c WHERE TerminalType__c IN :productIds];
		Map<Id, List<SObject>> terminalsUsingProduct = new Map<Id, List<SObject>>();
		for (Terminal__c terminal : terminals)
		{
			List<SObject> terminalsInMap = (terminalsUsingProduct.containsKey(terminal.TerminalType__c)) ?
										         terminalsUsingProduct.get(terminal.TerminalType__c) : 
												 new List<SObject>();

			terminalsInMap.add(terminal);
			terminalsUsingProduct.put(terminal.TerminalType__c, terminalsInMap);
		}	

		return terminalsUsingProduct;
	}

	private static Map<Id, List<SObject>> createMappingProductIdToServicePlan(final Set<Id> productIds)
	{
		List<ServicePlan__c> servicePlans = [SELECT Id, Name FROM ServicePlan__c WHERE ServicePlanType__c IN :productIds];
		Map<Id, List<SObject>> servicePlansUsingProduct = new Map<Id, List<SObject>>();
		for (ServicePlan__c servicePlan : servicePlans)
		{
			List<SObject> servicePlansInMap = (servicePlansUsingProduct.containsKey(servicePlan.ServicePlanType__c)) ?
													servicePlansUsingProduct.get(servicePlan.ServicePlanType__c) : 
													new List<SObject>();

			servicePlansInMap.add(servicePlan);
			servicePlansUsingProduct.put(servicePlan.ServicePlanType__c, servicePlansInMap);
		}	

		return servicePlansUsingProduct;
	}

	private static Map<Id, List<SObject>> createMappingProductIdToActiveAndFutureModemServicePlans(final Set<Id> productIds)
	{
		List<ModemServicePlan__c> modemServicePlans = [SELECT Id, Name, ServicePlan__c, Terminal__c FROM ModemServicePlan__c 
	                                WHERE (ServicePlan__c IN :productIds OR Terminal__c IN :productIds) AND 
	                                ( (StartDate__c <= :SNG_DateUtils.todayGmt() AND (EndDate__c >= :SNG_DateUtils.todayGmt() OR EndDate__c = NULL))
	                                OR StartDate__c > :SNG_DateUtils.todayGmt())];
		

		Map<Id, List<SObject>> modemServicePlansUsingProduct = new Map<Id, List<SObject>>();

/*
		for (ModemServicePlan__c modemServicePlan : modemServicePlans)
		{
			List<SObject> modemServicePlansInMap = (modemServicePlansUsingProduct.containsKey(servicePlan.ServicePlanType__c)) ?
													modemServicePlansUsingProduct.get(servicePlan.ServicePlanType__c) : 
													new List<SObject>();

		}
*/

		return modemServicePlansUsingProduct;
	}


	private static Map<Id, Product2> getSngProducts(Map<Id, Product2> products)
	{
		Map<Id, Product2> sngProducts = new Map<Id, Product2>();

		for (Product2 product : products.values())
		{
			if (isSngProduct(product))
				sngProducts.put(product.Id, product);
		}
		
		return sngProducts;
	}

	private static boolean validateProductIsNotInUse(Product2 sngProduct, 
													 Product2 updatedProduct,  
													 Map<Id, List<SObject>> servicePlansUsingProduct,
												     Map<Id, List<SObject>> terminalTypesUsingProduct)
	{
		boolean retValue = false;

		if (servicePlansUsingProduct.containsKey(sngProduct.Id))
		{
			List<SObject> conflictingRecords = servicePlansUsingProduct.get(sngProduct.Id);
			updatedProduct.addError('Product is currently in use by the following Service Plan(s): ' + 
								    SNG_HtmlUtilities.getHtmlSalesforceRecordLinkListString(conflictingRecords));
		}
		else if (terminalTypesUsingProduct.containsKey(sngProduct.Id))
		{
			List<SObject> conflictingRecords = terminalTypesUsingProduct.get(sngProduct.Id);
			updatedProduct.RecordType.addError('Product is currently in use by the following Terminal(s): ' + 
											   SNG_HtmlUtilities.getHtmlSalesforceRecordLinkListString(conflictingRecords));
		}
		else
		{
			retValue = true;
		}

		return retValue;
	}

	private static boolean isProductBeingDeactivated(final Product2 product, final Product2 updatedProduct)
	{
		return (product.isActive && !updatedProduct.isActive);
	}


	private static boolean isRecordTypeChanged(final Product2 product, final Product2 updatedProduct)
	{
		return (product.RecordType.Name != updatedProduct.RecordType.Name);
	}


	private static boolean isSngProduct(final Product2 product)
	{
		return (TERMINAL_TYPE_RECORD_TYPE_NAME == product.RecordType.Name || SERVICE_PLAN_RECORD_TYPE_NAME == product.RecordType.Name);
	}
}