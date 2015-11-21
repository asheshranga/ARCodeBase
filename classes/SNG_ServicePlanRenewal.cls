/**
 * This class is used to update the current Service Plan object and the Modem / Service Plan(s) that
 * were active at the end of the current Service Plan.
 */
public with sharing class SNG_ServicePlanRenewal {
	
	/**
	 * Deteails regarding the current Service Plan object to be renewed.
	 */
	public ServicePlan__c currentServicePlan { get; set; }

	/**
	 * Details regarding the Service Plan renewal parameters. The user input parameters
	 * in Visualforce are added to this object.
	 */
	public ServicePlan__c renewedServicePlan { get; set; }

	/**
	 * The parameter ID from the URL, which represents the Service Plan ID.
	 */
	private static final String PARAM_ID = 'id';

	/**
	 * Value to used for checking if the Service Plan renewal start date is one day more
	 * than the current Service Plan end date.
	 */
	private transient static final integer MINUS_ONE_DAY = -1;

	/**
	 * Flag to indicate if the Service Plan renewal has been completed. Used by the Visualforce page.
	 */
	public boolean renewComplete { get; private set; }

	/**
	 * Flag to indicate if the Service Plan renewal has yet to be completed. Used by the Visualforce page.
	 */
	public boolean renewIncomplete { get { return !renewComplete; } }

	/**
	 * Flag to indicate the expected sales order length for a Service Plan.
	 */
	public static final integer SALESORDER_REQ_LENGTH =  (Integer) SNGEnvVars__c.getOrgDefaults().SalesOrderNumericLength__c;

	/**
	 * Creates an instance of this object.
	 */
	public SNG_ServicePlanRenewal() 
	{		
		init();
	}

	/**
	 * The main entry point for the Service Plan renewal request.
	 */
	public void renew()
	{
		try
		{
			process();
		}
		catch (SNG_Exception e)
		{
			SNGVisualforceErrorReporter.reportError('Unexpected error in processing renew request.', e.getMessage());
		}
	}

	/**
	 * Initializes the object. Invoked by the constructor.
	 */
	private void init()
	{
		try
		{
			String id = ApexPages.currentPage().getParameters().get(PARAM_ID);
			SNG_ExceptionUtil.throwIfNullObject(id, PARAM_ID + ' for ServicePlan is null.');
			initializeAttributes(getServicePlan(id));
		}
		catch (Exception e)
		{
			SNGVisualforceErrorReporter.reportError('Unable to retrieve Service Plan info for the id provided.', e.getMessage());
		}
	}

	/**
	 * Initializes the attributes of the class.
	 *
	 * @param     servicePlan                 The Service Plan object to renew.
	 */
	private void initializeAttributes(final ServicePlan__c servicePlan)
	{
		renewComplete = false;
		// keep original service plan
		currentServicePlan = servicePlan;
		// clone the object to be updated - clone(preverseId, isDeepClone, preserveTimeStamp, preserveAutoNumber).
		renewedServicePlan = currentServicePlan.clone(false, true, false, false);
		renewedServicePlan.StartDate__c = currentServicePlan.EndDate__c.addDays(1);
		renewedServicePlan.EndDate__c = null;
		renewedServicePlan.SalesOrder__c = null;
	}

    /**
     * Processes the Service Plan renewal request.
     */
	private void process()
	{
		assertNonNullInput(renewedServicePlan);
		reset();
		if ( validateStartDate(currentServicePlan, renewedServicePlan) && validateEndDate(renewedServicePlan) && validateSalesOrder(renewedServicePlan) )
		{
			List<ModemServicePlan__c> modemServicePlans = getActiveModemServicePlansAtEndOfCurrentServicePlan(currentServicePlan);		
			processRenewalRequest(currentServicePlan, renewedServicePlan, modemServicePlans);
		}

	}

    /**
     * Resets the data cloning the Service Plan object and setting the renewal parameters.
     */
	private void reset()
	{
		renewComplete = false;
		// clone the object to be updated - clone(preverseId, isDeepClone, preserveTimeStamp, preserveAutoNumber).
		ServicePlan__c tempRenewedClone = renewedServicePlan.clone(false, true, false, false);
		renewedServicePlan = currentServicePlan.clone(false, true, false, false);
		renewedServicePlan.StartDate__c = tempRenewedClone.StartDate__c;
		renewedServicePlan.EndDate__c = tempRenewedClone.EndDate__c;
		renewedServicePlan.SalesOrder__c = tempRenewedClone.SalesOrder__c;
	}

    /**
     * Commits the entries to to the Salesforce database.
     *
     * @param     renewedServicePlan           The renewed Service Plan object.
     * @param     modemServicePlansToInsert    The Modem / Service Plan(s) to insert.
     * @return                                 True if the commit succeeds; false otherwise.
     */
	private boolean commitToDatabase(final ServicePlan__c renewedServicePlan, List<ModemServicePLan__c> modemServicePlansToInsert)
	{
		boolean retValue = false;

		if ( insertSObjects(new List<ServicePlan__c>{renewedServicePlan}) )
		{
			// update to point to new service plan.
			modemServicePlansToInsert = updateModemServicePlanToInsert(renewedServicePlan, modemServicePlansToInsert); 
			retValue = insertSObjects(modemServicePlansToInsert);
		}

		return retValue;
	}

    /**
     * Updates the Modem / Service Plan(s) to insert into the database using the renewed Service Plan object.
     *
	 * @param     renewedServicePlan           The renewed Service Plan object.
     * @param     modemServicePlansToInsert    The Modem / Service Plan(s) to insert.
     * @return                                 The collection of updated Modem / Service Plan(s) to insert.
     */
	private List<ModemServicePlan__c> updateModemServicePlanToInsert(final ServicePlan__c renewedServicePlan, 
																	 List<ModemServicePLan__c> modemServicePlansToInsert)
	{
		for (ModemServicePlan__c modemServicePlan : modemServicePlansToInsert)
		{
			modemServicePlan.ServicePlan__c = renewedServicePlan.Id;
			modemServicePlan.ServicePlan__r = renewedServicePlan;
		}

		return modemServicePlansToInsert;
	} 

	/**
	 * Rollbacks the set of changes for the Service Plan renewal. The method is invoked if the commit fails for 
	 * any reason
	 *
	 * @param     renewedServicePlan           The renewed Service Plan object.
	 */
	private void rollbackChanges(final ServicePlan__c renewedServicePlan)
	{
		if (!deleteSObject(renewedServicePlan))
		{
			SNGVisualforceErrorReporter.reportError('Cannot rollback changes. Service Pla', 'Cannot rollback changes.');
		}
	}

	/**
	 * Deletes an SObjects in the Salesforce database.
	 *
	 * @param     objectToDelete               The object to delete.
	 * @return                                 True if the delete succeeds; false otherwise.
	 */
	private boolean deleteSObject(final SObject objectToDelete)
	{
		boolean retValue = false;
		try
		{
			if (null != objectToDelete.id)   // no need to delete if object ID doesn't exist.
				delete objectToDelete;    
			retValue = true;
		}
		catch (DmlException e)
		{
			System.debug(e.getMessage()); // no need to report using Visualforce. Trigger validations report error already.
		}

		return retValue;
	}

	/**
	 * Inserts a collection of SObjects to the Salesforce database.
	 *
	 * @param     objectsToInsert              The collection of object(s) to insert.
	 * @return                                 True if the insert succeeds; false otherwise.
	 */
	private boolean insertSObjects(final List<SObject> objectsToInsert)
	{
		boolean retValue = false;
		try
		{
			insert objectsToInsert;
			retValue = true;
		}
		catch (DmlException e)
		{	
			System.debug(e.getMessage()); // no need to report using Visualforce. Trigger validations report error already.
		}

		return retValue;
	}

    /**
     * Processes the Service Plan renewal request.
     *
	 * @param     currentServicePlan           The current Service Plan object.
	 * @param     renewedServicePlan           The renewed Service Plan object.
	 * @param     activeModemServicePlans      A collection of Modem / Service Plan(s) considered active at the end
	 *                                         of the current Service Plan.
     */
	private void processRenewalRequest(final ServicePlan__c currentServicePlan, 
									   final ServicePlan__c renewedServicePlan, 
									   final List<ModemServicePlan__c> activeModemServicePlans)
	{
		List<ModemServicePlan__c> modemServicePlansToInsert = processExtendingActiveModems(renewedServicePlan, activeModemServicePlans);
		if (!commitToDatabase(renewedServicePlan, modemServicePlansToInsert))
		{
			rollbackChanges(renewedServicePlan);
		}
		else
		{
			SNG_VisualforceReporter.report(ApexPages.Severity.CONFIRM, 
										  'Successfully renewed Service Plan under Name: ' + getServicePlanName(renewedServicePlan.Id));
		}

		renewComplete = true;
	}

    /**
     * Extends the collection of Modem / Service Plan(s) provided. The start and end dates of the extended Modem / Service Plan(s)
     * are dictated by the start and end date of the renewed Service Plan.
     *
	 * @param     renewedServicePlan           The renewed Service Plan object.
	 * @param     activeModemServicePlans      A collection of Modem / Service Plan(s).
	 * @return                                 A collection of renewed Modem Service Plan(s) using the renewed Service Plan object.
	 *   
     */
	private List<ModemServicePlan__c> processExtendingActiveModems(final ServicePlan__c renewedServicePlan, 
																   final List<ModemServicePlan__c> activeModemServicePlans)
	{
		List<ModemServicePlan__c> modemServicePlansToInsert = new List<ModemServicePlan__c>();
		
		for (ModemServicePlan__c activeMsp : activeModemServicePlans)
		{
			// clone the object to copy - clone(preverseId, isDeepClone, preserveTimeStamp, preserveAutoNumber).
			ModemServicePlan__c msp = activeMsp.clone(false, true, false, false);
			msp.StartDate__c = renewedServicePlan.StartDate__c;
			msp.EndDate__c = renewedServicePlan.EndDate__c;
			modemServicePlansToInsert.add(msp);
		}

		return modemServicePlansToInsert;
	}

	/**
	 * Retrieves the Service Plan name based on the Service Plan ID.
	 * 
	 * @param     servicePlanId                The Service Plan ID.
	 * @return                                 The Service Plan name corresponding to the Service Plan ID.
	 */
	private String getServicePlanName(final Id servicePlanId)
	{
		List<ServicePlan__c> queriedServicePlan = [SELECT Id, Name FROM ServicePlan__c WHERE Id = :servicePlanId];
		SNG_ExceptionUtil.assert(1 == queriedServicePlan.size(), 'Queried service Plan does not have required entry.');
		return SNG_HtmlUtilities.getHtmlSalesforceRecordLinkString(queriedServicePlan.get(0).Id, queriedServicePlan.get(0).Name);
	}

	/**
	 * Retrieves the list of active Modem / Service Plan(s) at the end of the current Service Plan.
	 * 
	 * @param     currentServicePlan        The current Service Plan object.
	 * @param     renewedServicePlan        The renewed Service Plan object.
	 * @return                              A collection of active Modem / Service Plans at the end of the current
	 *                                      service plan.
	 */
	private List<ModemServicePlan__c> getActiveModemServicePlansAtEndOfCurrentServicePlan(final ServicePlan__c currentServicePlan)
	{
		return [SELECT Modem__c, ServicePlan__c, StartDate__c, EndDate__c FROM ModemServicePlan__c 
					WHERE ServicePlan__c = :currentServicePlan.Id AND EndDate__c = :currentServicePlan.EndDate__c];
	}


	/**
	 * Asserts if any of the required renewed Service Plan parameters are null (user-inputs).
	 *
	 * @param     renewedServicePlan       The renewed Service Plan object.
	 * @throws    SNG_Exception            Thrown if one of the required user input parameters are null.
	 */
	private void assertNonNullInput(final ServicePlan__c renewedServicePlan)
	{
		SNG_ExceptionUtil.assert(null != renewedServicePlan.StartDate__c, 'Start date is null.');
		SNG_ExceptionUtil.assert(null != renewedServicePlan.EndDate__c, 'End date is null.');
		SNG_ExceptionUtil.assert(null != renewedServicePlan.SalesOrder__c, 'SalesOrder is null.');
	}

	/**
	 * Validates the start date for the Service Plan. The check verifies the renewed Service Plan start date is
	 * one day after the end date. Through the renewal Visualforce page, this should be true since
	 * the start date is fixed.
	 *
	 * @param     currentServicePlan       The current Service Plan object.
	 * @param     renewedServicePlan       The renewed Service Plan object.
	 * @return                             True if the renewed Service Plan start date is valid; false otherwise.
	 */
	private boolean validateStartDate(final ServicePlan__c currentServicePlan, ServicePlan__c renewedServicePlan)
	{
		// renewal date should be at most one day greater than current service plan.
		boolean result = (renewedServicePlan.StartDate__c.addDays(MINUS_ONE_DAY) == currentServicePlan.EndDate__c);

		if (!result)
		{
			renewedServicePlan.StartDate__c.addError('Service Plan Renewal start date must be one day greater than current Service Plan end date: ' + 
													 currentServicePlan.StartDate__c);
		}

		return result;

	}

	/**
	 * Validates the end date for the renewed Service Plan. The check verifies the renewed start date is
	 * before the renewed end date.
	 *
	 * @param     renewedServicePlan       The renew Service Plan object.
	 * @return                             True if the Service Plan end date is valid; otherwise false.
	 */
	private boolean validateEndDate(final ServicePlan__c renewedServicePlan)
	{
		boolean result = (renewedServicePlan.EndDate__c >= renewedServicePlan.StartDate__c);
		if (!result)
		{
			renewedServicePlan.EndDate__c.addError('Service Plan Renewal end date must be greater than or equal to the Service Plan Renewal start date: ' + 
												   renewedServicePlan.StartDate__c);
		}

		return result;
	}

    /** 
     * Validates the sales order for the renewed Service Plan. The check verifies the renewed Service Plan sales order is
     * of correct length and numeric.
     *
     * @param     renewedServicePlan       The renewed Service Plan object.
     * @return                             True if the Service Plan sales order is valid; false otherwise.
     */
	private boolean validateSalesOrder(final ServicePlan__c renewedServicePlan)
	{
		boolean result = (SALESORDER_REQ_LENGTH == renewedServicePlan.SalesOrder__c.length() && isNumeric(renewedServicePlan.SalesOrder__c));
		if (!result)
		{
			renewedServicePlan.SalesOrder__c.addError('Service Plan Renewal Sales Order must be a numerical value of length: ' + SALESORDER_REQ_LENGTH);
		}

		return result;
	}

	/**
	 * Validates whether the parameter provide is numeric.
	 *
	 * @param     valueToCheck             The value to verify.
	 * @return                             True if numeric; false otherwise.
	 */
	private boolean isNumeric(String valueToCheck)
	{
		boolean retValue;

		try 
		{
  			Long x = Long.valueOf(valueToCheck);
  			retValue = true;
		}
		catch (Exception e) 
		{
  			// it's not an Integer, try something else
  			retValue = false;
		}

		return retValue;
	}

	/**
	 * Retrieves the Service Plan object corresponding to the ID.
	 *
	 * @param     id                       The Service Plan ID to query.
	 * @return                             The corresponding Service Plan object with the ID specified.
	 * @throws    SNG_Exception            Thrown if a corresponding Service Plan object cannot be found.
	 */
	private ServicePlan__c getServicePlan(final String id)
	{
		ServicePlan__c retObj = null;

		try
		{
			String queryString = new SNG_SoqlSelectAll('ServicePlan__c').soql + ' WHERE Id = \'' + id + '\'';
			List<ServicePlan__c> servicePlans = Database.query(queryString);
			SNG_ExceptionUtil.assert(1 == servicePlans.size(), 'Cannot retrieve Service Plan with id: ' + id);
			retObj = servicePlans.get(0);
		}
		catch (SNG_Exception e)
		{
			throw e;
		}

		return retObj;
	}
}