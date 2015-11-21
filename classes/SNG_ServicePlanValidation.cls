/**
 * This class is used to perform validation Service Plan trigger operations when attempting to 
 * perform write-operations to the database. For triggered operation, Salesforce allows bulk
 * processing, that is multiple records being processed simulatenously. In order to provide
 * a consistent processing of write-operations for Service Plans, the validation of records
 * are performed in 2-phase checks.
 *
 * 1) Validates the record itself against the current existing Salesforce entries. 
 *       Beyond the validation of the record itself (which is done during this step), 
 *       the request is checked against the database to ensure the the new request does not conflict 
 *       against existing records currently in the database. 
 *
 * 2) Validates the record itself against any other requests.
 *       The request must be checked against any other requests that passed the first validation stage. 
 *       This is to ensure that the bulk oepration does not cause records to conflict. 
 *       Records are accepted based on bulk list order. That is, if two requested records are in 
 *       conflict with eachother, the request appearing first in the bulk list will be accepted while 
 *        the latter request will fail.
 *
 */

public with sharing class SNG_ServicePlanValidation 
{
//-------------------------------------------------------------------------------------------------
// Start entry point for validations.
//------------------------------------------------------------------------------------------------- 

    /**
     * Validates that user input when a ServicePlan is attempting to be added. Only to be used upon 
     * insertion of service plan object. 
     *
     * @param    servicePlans         The service plans requiring validation to insert.
     * @return                        A collection of Service Plans that can be inserted.
     * @throws   SNG_Exception        If the input parameter is null.
     */
    public static List<ServicePlan__c> validateInsert(List<ServicePlan__c> servicePlans) 
    {
        SNG_ExceptionUtil.throwIfNullObject(servicePlans, 'Could not validate servicePlans; null servicePlans');
        Map<Id, String> errors = new Map<Id, String>();
        List<ServicePlan__c> newServicePlansFilteredSet = validateInsertAgainstDatabase(servicePlans, errors);
        return validateInsertAgainstOtherRequests(newServicePlansFilteredSet, errors);
    }   
    
    /**
     * Validates Service Plan changes identified in a "before update" trigger.
     *
     * @param    oldServicePlans      Old service plans from trigger. Old represents the Service Plans prior to the
     *                                requested updated.
     * @param    newServicePlans      New service plans from trigger. New represents the requested update of the
     *                                Service Plan.
     * @return                        A collection of Service Plans that can be updated.
     * @throws   SNG_Exception        If either input parameter is null, a size mismatch between the input parameters, or
     *                                if the id field in the sObject is null.
     */
    public static List<ServicePlan__c> validateUpdate(Map<Id, ServicePlan__c> oldServicePlans, List<ServicePlan__c> newServicePlans)
    {
        SNG_ExceptionUtil.throwIfNullObject(oldServicePlans, 'Could not validate service plans; null oldServicePlans');
        SNG_ExceptionUtil.throwIfNullObject(newServicePlans, 'Could not validate service plans; null newServicePlans');
        SNG_ExceptionUtil.assert(oldServicePlans.size() == newServicePlans.size(), 'Size mismatch between oldServicePlan and newServicePlan');
        SNG_ExceptionUtil.assert(SNG_TriggerUtils.containsValidId(oldServicePlans, newServicePlans), 'Invalid update. ID is missing/mismatched.');

        Map<Id, String> errors = new Map<Id, String>();
        List<ServicePlan__c> newServicePlansFilteredSet = validateUpdateAgainstDatabase(oldServicePlans.values(), newServicePlans, errors);
        return validateUpdateAgainstOtherRequests(newServicePlansFilteredSet, errors);
    }
    
    /**
     * This method is used to validate the deletion of a servicePlan. A service plan can only be deleted if there 
     * are no active Modem / Service Plan(s) using the specified service plan.
     *
     * @param    servicePlans         The service plans requiring validation to delete.
     * @return                        A map of service plans that can be deleted.
     * @throws   SNG_Exception        If the input parameter is null.
     */
    public static List<ServicePlan__c> validateDelete(Map<Id, ServicePlan__c> servicePlans)
    {
        SNG_ExceptionUtil.throwIfNullObject(servicePlans, 'Could not validate servicePlans; null servicePlans');
        Map<Id, String> errors = new Map<Id, String>();
        return validateDeleteAgainstDatabase(servicePlans, errors);
    }

//-------------------------------------------------------------------------------------------------
// End entry point for validations.
//------------------------------------------------------------------------------------------------- 

//-------------------------------------------------------------------------------------------------
// Start insert validations
//-------------------------------------------------------------------------------------------------   
    
    /**
     * This method is used to validate insert requests against the current entries stored in Salesforce. This is to
     * ensure the service plans attempting to be inserted do not cause a conflict with other records in the database. 
     * This is the first phase to filter out records that are invalid and/or cannot coexist with current records in the
     * database. 
     *
     * @param    servicePlans         The service plans requiring validation to insert.
     * @param    errors               A collection of Service Plans that have failed validation and their corresponding error message.
     *                                The collection is expected to be updated by the method.
     * @return                        A collection of valid Service Plans that can be inserted.
     */
    private static List<ServicePlan__c> validateInsertAgainstDatabase(List<ServicePlan__c> servicePlans, Map<Id, String> errors)
    {
        List<ServicePlan__c> validServicePlans = new List<ServicePlan__c>();
         
        // retrieve database entries that match the sales order.
        Set<String> salesOrders = SNG_ServicePlanValidationUtil.createSalesOrdersCollection(servicePlans);
        List<ServicePlan__c> servicePlanList = SNG_ServicePlanValidationUtil.createServicePlanListingBasedOnSalesOrders(salesOrders);
        Map<String, List<ServicePlan__c>> salesOrderToServicePlans = SNG_ServicePlanValidationUtil.createSalesOrderToServicePlanCollection(servicePlanList);
     
        Map<Id, Product2> servicePlanTypes = SNG_ServicePlanValidationUtil.createServicePlanTypesToProductCollection(servicePlans);
        
        for (ServicePlan__c servicePlan : servicePlans)
        {
            if (validateServicePlanType(servicePlan, servicePlanTypes, errors))
            {
                validServicePlans.add(servicePlan);
            }
        } 
        
        return validServicePlans;
    }
    
    /**
     * This method is used to validate insert requests against other requests as part of the bulk insert request. This is to
     * ensure the service plans attempted to be inserted do not conflict with eachother. This is the second phase
     * to filter our records that will cause conflict with the other insertion requests. 
     *
     * Note: The records are processed in-order. If two records conflict, the record that appears earlier in the
     * bulk insert list will be accepted. The latter request will be considered an error.
     *
     * @param    servicePlans         The service plans requiring validation to insert.
     * @param    errors               A collection of Service Plans that have failed validation and their corresponding error message.
     *                                The collection is expected to be updated by the method.
     * @return                        A collection of valid Service Plans that can be inserted.
     */
    private static List<ServicePlan__c> validateInsertAgainstOtherRequests(List<ServicePlan__c> servicePlans, Map<Id, String> errors)
    {
        List<ServicePlan__c> validServicePlans = new List<ServicePlan__c>();    
        Map<String, List<ServicePlan__c>> salesOrderToServicePlans = new Map<String, List<ServicePlan__c>>();
        
        for (ServicePlan__c servicePlan : servicePlans)
        {
            // Validation goes here.
            // No need to call validateServicePlanType. That is independent of other requests.
            validServicePlans.add(servicePlan);
            SNG_ServicePlanValidationUtil.addEntry(salesOrderToServicePlans, servicePlan);
        }
        
        return validServicePlans;
    }
    
//-------------------------------------------------------------------------------------------------
// End insert validations
//------------------------------------------------------------------------------------------------- 

//-------------------------------------------------------------------------------------------------
// Start update validations
//------------------------------------------------------------------------------------------------- 

    /**
     * This method is used to validate update requests against the current entries stored in Salesforce. This is to
     * ensure the service plans attempting to be updated do not cause a conflict with other records in the database. 
     * This is the first phase to filter out records that are invalid and/or cannot coexist with current records in the
     * database. 
     *
     * @param    oldServicePlans      Old service plans from trigger. Old represents the Service Plans prior to the
     *                                requested updated.
     * @param    newServicePlans      New service plans from trigger. New represents the requested update of the
     *                                Service Plan.
     * @param    errors               A collection of Service Plans that have failed validation and their corresponding error message.
     *                                The collection is expected to be updated by the method.
     * @return                        A collection of valid Service Plans that can be updated.
     */
    private static List<ServicePlan__c> validateUpdateAgainstDatabase(List<ServicePlan__c> oldServicePlans, 
                                                                      List<ServicePlan__c> newServicePlans,   
                                                                      Map<Id, String> errors)
    {
        List<ServicePlan__c> validServicePlans = new List<ServicePlan__c>();

        // retrieve database entries that match the sales order.
        Set<String> salesOrders = SNG_ServicePlanValidationUtil.createSalesOrdersCollection(newServicePlans);
        List<ServicePlan__c> servicePlanList = SNG_ServicePlanValidationUtil.createServicePlanListingBasedOnSalesOrders(salesOrders);
        Map<String, List<ServicePlan__c>> salesOrderToServicePlans = SNG_ServicePlanValidationUtil.createSalesOrderToServicePlanCollection(servicePlanList);
       
        Map<Id, List<ModemServicePlan__c>> servicePlanIdToModemServicePlan = SNG_ServicePlanValidationUtil.createServicePlanIdToModemServiceplan(newServicePlans);
        Map<Id, Product2> servicePlanTypes = SNG_ServicePlanValidationUtil.createServicePlanTypesToProductCollection(newServicePlans);
        
        // assertion check for size is already applied. So can reuse indexing for both old and new Service Plan
        for (integer i = 0; i < newServicePlans.size(); ++i)
        {    
            if (validateServicePlanType(newServicePlans.get(i), servicePlanTypes, errors) &&
                validateServicePlanEncompassesMspServiceDates(oldServicePlans.get(i), newServicePlans.get(i), servicePlanIdToModemServicePlan, errors))
            {
                validServicePlans.add(newServicePlans.get(i));
            }
        } 

        return validServicePlans;
    }

    /**
     * This method is used to validate update requests against other requests as part of the bulk update request. This is to
     * ensure the service plans attempted to be updated do not conflict with eachother. This is the second phase
     * to filter our records that will cause conflict with the other insertion requests. 
     *
     * Note: The records are processed in-order. If two records conflict, the record that appears earlier in the
     * bulk update list will be accepted. The latter request will be considered an error.
     *
     * @param    servicePlans         The service plans requiring validation to update.
     * @param    errors               A collection of Service Plans that have failed validation and their corresponding error message.
     *                                The collection is expected to be updated by the method.
     * @return                        A collection of valid Service Plans that can be updated.
     */    
    private static List<ServicePlan__c> validateUpdateAgainstOtherRequests(List<ServicePlan__c> servicePlans, 
                                                                           Map<Id, String> errors)
    {
        List<ServicePlan__c> validServicePlans = new List<ServicePlan__c>();
        Map<String, List<ServicePlan__c>> salesOrderToServicePlans = new Map<String, List<ServicePlan__c>>();
        
        // since new service plan is filtered, will use that to index against old service plans to find out what changed.
        for (integer i = 0; i < servicePlans.size(); ++i)
        {
            // no need to call the following validations as these validations are independent of other update requests:
            // validateServicePlanType
            // validateServicePlanEncompassesMspServiceDate
            SNG_ServicePlanValidationUtil.addEntry(salesOrderToServicePlans, servicePlans.get(i));
            validServicePlans.add(servicePlans.get(i));
        } 

        return validServicePlans;
    }

    /**
     * Validates the service plan dates encompasses all associated Modem / Service Plan(s) dates for an update request. 
     * Any Modem / Service Plan date falling outside the range of the Service Plan date will cause the validation to fail.
     * The service plan needs to only be validated if the start date or end date has been modified.
     *
     * @param    oldTerminals                        Old service plan. Old represents the Service Plan prior to the
     *                                               requested updated.
     * @param    newTerminals                        New service plan. New represents the requested update of the
     *                                               Service Plan.
     * @param    servicePlanIdToModemServicePlans    A mapping between sales order numbers to related service plans.
     * @param    errors                              A collection of service plans that failed validation and its accompanying error message.
     * @return                                       True if the validation passes for the service plan update; false otherwise.
     */
    private static boolean validateServicePlanEncompassesMspServiceDates(ServicePlan__c oldServicePlan,
                                                                         ServicePlan__c newServicePlan,
                                                                         Map<Id, List<ModemServicePlan__c>> servicePlanIdToModemServicePlans,
                                                                         Map<Id, String> errors)
    {
        boolean isValid = true;
        if (oldServicePlan.StartDate__c != newServicePlan.StartDate__c || oldServicePlan.EndDate__c != newServicePlan.EndDate__c )
        {
            isValid = validateServicePlanEncompassesMspServiceDates(newServicePlan, 
                                                                    servicePlanIdToModemServicePlans, 
                                                                    errors);
        }
        
        return isValid;
    }   

//-------------------------------------------------------------------------------------------------
// End update validations
//------------------------------------------------------------------------------------------------- 

//-------------------------------------------------------------------------------------------------
// Start delete validations
//-------------------------------------------------------------------------------------------------  

    /**
     * This method is used to validate delete requests against the current entries stored in Salesforce. This is to
     * ensure the service plans attempting to be delete do not cause a conflict with other records in the database. 
     *
     * @param    servicePlans         The service plans requiring validation to update.
     * @param    errors               A collection of Service Plans that have failed validation and their corresponding error message.
     *                                The collection is expected to be deleted by the method.
     * @return                        A collection of valid Service Plans that can be deleted.
     */
    private static List<ServicePlan__c> validateDeleteAgainstDatabase(Map<Id,ServicePlan__c> servicePlans,  
                                                                      Map<Id, String> errors)
    {
        List<ServicePlan__c> validServicePlans = new List<ServicePlan__c>();
        Map<Id, List<ModemServicePlan__c>> servicePlanIdToActiveMsps =  SNG_ServicePlanValidationUtil.createServicePlanToActiveModemServicePlans(servicePlans.keySet());   

        for (ServicePlan__c servicePlan :  servicePlans.values())
        {
            if (validateNoActiveModemServicePlan(servicePlan, servicePlanIdToActiveMsps, errors))
                validServicePlans.add(servicePlan);
        }

        return validServicePlans;
    }

  /**
     * Validates no Modem / Service Plans are actively using a service plan that is attempting to be deleted.
     * 
     * @param   servicePlan                 The service plan to be deleted.
     * @param   servicePlanToActiveMsps     A mapping between the service plan ID and their associated Modem / Service Plan(s) that are active.
     * @param   errors                      A collection of Service Plans that have failed validation and their corresponding error message.
     *                                      The collection is expected to be updated by the method.
     * @return                              True if the there are no active Modem / Service Plan(s) using the 
     *                                      Service Plan; false otherwise
     */
    private static boolean validateNoActiveModemServicePlan(ServicePlan__c servicePlan, Map<Id, List<ModemServicePlan__c>> servicePlanIdToActiveMsps, Map<Id, String> errors) 
    {
        boolean isValid = !servicePlanIdToActiveMsps.containsKey(servicePlan.Id);
        if (!isValid)
        {
            final String ERROR_MSG = 'Service Plan: ' + SNG_HtmlUtilities.getHtmlSalesforceRecordLinkString(servicePlan) + 
                                     ' cannot be deleted as the following Modem / Service Plan(s) use it: ' +
                                     SNG_HtmlUtilities.getHtmlSalesforceRecordLinkListString(servicePlanIdToActiveMsps.get(servicePlan.Id));
    
            //SNG_TriggerUtils.addError(errors, servicePlan, ERROR_MSG);
            errors.put(servicePlan.Id, ERROR_MSG);
            // add to record
            servicePlan.SalesOrder__c.addError(SNG_HtmlUtilities.getHtmlMessageBoldRedFontFormat(ERROR_MSG), false);
        }

        return isValid;
    }
//-------------------------------------------------------------------------------------------------
// End delete validations
//-------------------------------------------------------------------------------------------------  

//-------------------------------------------------------------------------------------------------
// Start common functions for validations.
//-------------------------------------------------------------------------------------------------
    
    /**
     * Validates the service plan is the same as the list of service plans provided. This method assumes that the Service Plans
     * provided as input are matching sales orders. This method is is invoked by the method validateSalesOrderUniqueToAccount.
     *
     * @param    servicePlan                The service plan record to validate.
     * @param    servicePlans               A collection of service plans that match the sales order of the servicePlan parameter
     * @param    conflictingServicePlans    A collection to be updated, capturing all the service plans that are in conflict.
     * @return                              True if the servicePlan account matches the list of servicePlans; false otherwise.
     */ 
    private static boolean isSameAccount(ServicePlan__c servicePlan, List<ServicePlan__c> servicePlans, List<ServicePlan__c> conflictingServicePlans)
    {
        SNG_ExceptionUtil.throwIfNullObject(conflictingServicePlans, 'conflictingServicePlans to populate is null');
        SNG_ExceptionUtil.assert(0 == conflictingServicePlans.size(), 'conflictingServicePlans is not empty');

        for (ServicePlan__c sp : servicePlans)
        {
            if ((null == servicePlan.Id || servicePlan.Id != sp.Id) && servicePlan.Account__c != sp.Account__c)
                conflictingServicePlans.add(servicePlan);
        }
        
        return conflictingServicePlans.isEmpty();
    }
   

    /**
     * Validates the service plan dates encompasses all associated Modem / Service Plan(s) dates. 
     * Any Modem / Service(s) Plan date falling outside the range of the Service Plan date will cause the validation to fail.
     * The service plan needs to only be validated if the start date or end date has been modified.
     *
     * @param    servicePlan                         The service plan record to validate.
     * @param    servicePlanIdToModemServicePlans    A mapping between sales order numbers to related service plans.
     * @param    errors                              A collection of service plans that failed validation and its accompanying error message.
     * @return                                       True if the validation passes for the service plan; false otherwise.
     */
    private static boolean validateServicePlanEncompassesMspServiceDates(ServicePlan__c servicePlan,
                                                                         Map<Id, List<ModemServicePlan__c>> servicePlanIdToModemServicePlans,
                                                                         Map<Id, String> errors)
    {
        List<ModemServicePlan__c> modemServicePlans = (servicePlanIdToModemServicePlans.containsKey(servicePlan.id)) ? 
                                                       servicePlanIdToModemServicePlans.get(servicePlan.id) : new List<ModemServicePlan__c>();
        
        List<ModemServicePlan__c> conflictingModemServicePlans = getConflictingModemServicePlans(servicePlan, modemServicePlans);

        boolean isValid = ArrayUtils.isEmpty(conflictingModemServicePlans);
       
        if (!isValid)
        {
             final string ERROR_MESSAGE = 'At least one Modem / Service Plan (MSP) exists using this Service Plan' +
                                          ' where Service Plan date ( ' + servicePlan.StartDate__c.format() + '-' + 
                                          servicePlan.EndDate__c.format() + ')' +
                                          ' does not encompass the following Modem / Service Plan(s) dates: ' +
                                          SNG_HtmlUtilities.getHtmlSalesforceRecordLinkListString(conflictingModemServicePlans);
             SNG_TriggerUtils.addError(errors, servicePlan, ERROR_MESSAGE);
        }
        
        return false;
      
    } 
    
    /**
     * Retrieves a list of conflict Modem / Service Plan(s) that conflict with the Service Plan start and end date provided.
     * 
     * @param     servicePlan               The Service Plan dates.
     * @param     modemServicePlans         The list of Modem / Service Plan(s) to verify if the Service Plan dates encompass
     *                                      their respective start and end dates.
     * @return                              A collection of conflicting Modem / Service Plans; The collection will be empty if
     *                                      all Modem / Service Plan(s) are within the Service Plan dates.
     */
    private static List<ModemServicePlan__c> getConflictingModemServicePlans(ServicePlan__c servicePlan, 
                                                                             List<ModemServicePlan__c> modemServicePlans)
    {
        List<ModemServicePlan__c> conflictingModemServicePlans = new List<ModemServicePlan__c>();
        for (ModemServicePlan__c modemServicePlan : modemServicePlans)
        {
            if (modemServicePlan.StartDate__c < servicePlan.StartDate__c ||
                (/*null != modemServicePlan.EndDate__c &&*/ modemServicePlan.EndDate__c > servicePlan.EndDate__c))
            {
               conflictingModemServicePlans.add(modemServicePlan);
            } 
        }
        
        return conflictingModemServicePlans;
        
    }

    /**
     * Validates the service plan record type and that the service plan is active.
     *
     * @param     servicePlan               The Service Plan to validate.
     * @param     servicePlanType           A mapping between the service plan product ID and the associated Product object.
     * @param     errors                    A collection of service plans that failed validation and its accompanying error message.
     * @return                              True if a valid service plan type; false otherwise.
     */
    private static boolean validateServicePlanType(ServicePlan__c servicePlan,
                                                   Map<Id, Product2> servicePlanTypes,
                                                   Map<Id, String> errors)
    {
        Product2 spProduct = servicePlanTypes.get(servicePlan.ServicePlanType__c);
        return validateServicePlanRecordType(servicePlan, spProduct, errors) &&
               validateServicePlanActiveProductType(servicePlan, spProduct, errors);
    }
    
    /**
     * Validates the service plan record type matches what is expected for the record.
     *
     * @param     servicePlan               The service plan being validated.
     * @param     spProduct                 The corresponding product that is linked to the service plan.
     * @param     errors                    A collection of service plans that failed validation and its accompanying error message.
     * @return                              True if the product type is a Service Plan Type; false otherwise.
     */
    private static boolean validateServicePlanRecordType(ServicePlan__c servicePlan, Product2 spProduct, Map<Id, String> errors)
    {
        boolean isValid = (null != spProduct && null != spProduct.RecordType 
            && spProduct.RecordType.Name == SNG_ServicePlanValidationUtil.SERVICE_PLAN_TYPE_RECORD_TYPE_NAME);
        if (!isValid)
        {
            final String ERROR_MSG = 'Service Plan Type\'s Record Type must be equal to "' 
                                     + SNG_ServicePlanValidationUtil.SERVICE_PLAN_TYPE_RECORD_TYPE_NAME + '".';
            errors.put(servicePlan.Id, ERROR_MSG);
            servicePlan.ServicePlanType__c.addError(ERROR_MSG);
        }
        
        return isValid;
    }
    
    /**
     * Validates the product type associated with the service plan is active.
     *
     * @param     servicePlan               The service plan being validated.
     * @param     spProduct                 The corresponding product that is linked to the service plan.
     * @param     errors                    A collection of service plans that failed validation and its accompanying error message.
     * @return                              True if the product type is active; false otherwise.
     */
    private static boolean validateServicePlanActiveProductType(ServicePlan__c servicePlan, Product2 spProduct, Map<Id, String> errors)
    {
        boolean isValid = SNG_Product2.validateActiveProductType(spProduct);
        if (!isValid)
        {
            // businessAreasStr to be in format: label1/label2/label3, remove white spaces and commas
            String businessAreasStr = Label.SNGBusinessArea;
            businessAreasStr = businessAreasStr.replace(' ', '').replace(',', '/');

            SNG_TriggerUtils.addError(errors, 
                                      servicePlan, 
                                      'Service Plan Type ' + spProduct.name + ' must be equal to Business Area(' + businessAreasStr + '), Family(Exede), and active.');
        }
        
        return isValid;
    }

    //-------------------------------------------------------------------------------------------------
    // End common functions for validations.
    //-------------------------------------------------------------------------------------------------
}