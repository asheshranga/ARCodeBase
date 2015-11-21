/**
 * This class is used to support a RESTful API for the Service Plans administrative info method
 * (service-plans/info).
 */
@TestVisible
public with sharing class SNG_REST_ServicePlansInfo extends SNG_REST_Collection {

    /**
     * The prefix for a valid ServicePlan id. All ServicePlan IDs are of the format: SP-xxx. 
     */
	private static final String servicePlanPrefixRegex = '[Ss][Pp][-]';

    /**
	 * Validates if ServicePlan Id input is correct form
	 *
	 * @param	id		   the ID input
	 * @return 			   true if id is valid, false if not
	 */
	private boolean isValidId(String id) {
		//TODO: Create iIdChecker interface and move into SNG_REST_Collection
		SfIdChecker servicePlanIdChecker = new SfIdChecker(servicePlanPrefixRegex);
		return servicePlanIdChecker.isValidFormat(id);
	}
    
    /**
     * Validates if ServicePlan status is a valid status (Active or Inactive)
     *
     * @param   status     The status to validate
     * @return             true if a valid status (Active or Inactive), false otherwise.
     */
	private static boolean validateServicePlanStatus(String status) {
		return (status == 'Active' || status == 'Inactive');
	}

    /**
     * Retrieves all ServicePlans based on the list of ID names that are input
     *
     * @param    ids        ID names of the custom objects to be retrieved
     * @return              ServicePlans corresponding to the list of ID names
     */
	@TestVisible
    private sobject[] getSObjects(String[] ids)
    {
    	List<ServicePlan__c> servicePlans;
    	servicePlans = [SELECT Id, Name, Status__c, StartDate__c, EndDate__c, SalesOrder__c,
    	                ServicePlanType__r.Name FROM ServicePlan__c WHERE Name IN :ids];
    	return servicePlans;
    }
     
    /**
     * Retrieves ALL salesforce custom objects associated with account relevant to the
     * ServicePlan.
     *
     * @return               all ServicePlans associated with the account
     */
	@TestVisible
    private sobject[] getSObjects()
    {
		List<ServicePlan__c> servicePlans;
		//Return all object instances if no IDs are passed in
    	servicePlans = [SELECT Id, Name, Status__c, StartDate__c, EndDate__c, SalesOrder__c,
    	                ServicePlanType__r.Name FROM ServicePlan__c];
    	return servicePlans;
    }

    /**
     * Retrieves all MSPs which are associated to the ServicePlan ID provided as input.
     *
     * @param    id           The id of the ServicePlan.
     * @return                All Modem/Service Plans that contain the Service Plan ID.
     */
	@TestVisible
    private static List<ModemServicePlan__c> getMsps(String id)
    {
    	List<ModemServicePlan__c> msps;
		msps = [SELECT Modem__r.Name, Modem__r.SerialNumber__c, Status__c, StartDate__c, EndDate__c,
		        Modem__r.Terminal__r.Name FROM ModemServicePlan__c WHERE ServicePlan__c = :id];
    	return msps;
    }

    /**
     * Retrieves all MSPs which are associated the any of the ServicePlan IDs provided. If the list
     * is empty, it will retrieve all MSPs associated with the user's account.
     *
     * @param    servicePlanIds   The list of service plan Ids.
     * @return                    All Modem / Service Plans that contain the Service Plan ID or
     *                            all Modem / Service Plans associated with the user's account.
     */
    @TestVisible
    private static List<ModemServicePlan__c> getMsps(String[] servicePlanIds)
    {
    	List<ModemServicePlan__c> msps;
    	if (null == servicePlanIds) {
    		//Return all object instances if no IDs are passed in
    		msps = [SELECT Modem__r.Name, Modem__r.SerialNumber__c, Status__c, StartDate__c, EndDate__c,
    		        Modem__r.Terminal__r.Name, ServicePlan__c FROM ModemServicePlan__c];
    	} else {
    		msps = [SELECT Modem__r.Name, Modem__r.SerialNumber__c, Status__c, StartDate__c, EndDate__c,
    		        Modem__r.Terminal__r.Name, ServicePlan__c FROM ModemServicePlan__c WHERE ServicePlan__r.Name IN :servicePlanIds];
    	}
    	return msps;
    }


    /**
     * Constructs the resulting list of JSON objects with the data corresponding to the service plans.
     *
     * @param    detail             The current detail. this can be overridden as necessary.
     * @param    ids                The collection of IDs for the data requested.
     * @param    servicePlans       The ServicePlan objects with the data requested
     * @return                      resulting list of JSON objects. Return type is polymorphic depending on the
     *                              particular API. Primitive types may be valid return types which precludes
     *                              the use of a marker interface as the return type in this signature
     */
    @TestVisible
    private SNG_REST_Response constructResultList(final SNG_REST_StatusDetail detail, final string[] ids, final sobject[] servicePlans) {
    	List<ServicePlanInfoOutput> result = new List<ServicePlanInfoOutput>();

    	List<ModemServicePlan__c> msps = getMsps(ids);

    	Map<Id, List<ModemServicePlan__c>> spToMspsMap = SNGObjMapper.buildServicePlanToMspsMap(msps);

    	for (sobject obj : servicePlans) {
    		ServicePlan__c sp = (ServicePlan__c) obj;

    	    List<ModemServicePlan__c> relatedMsps = SNGObjMapper.getMsps(sp.Id, spToMspsMap);
    		List<ServicePlanInfoMspOutput> spInfoMspOutputList = constructMspOutput(relatedMsps);
    		ServicePlanInfoOutput spInfoOutput = new ServicePlanInfoOutput(sp.Name, sp.Status__c, sp.StartDate__c,
    				sp.EndDate__c, sp.SalesOrder__c, sp.ServicePlanType__r.Name, spInfoMspOutputList);

    		result.add(spInfoOutput);
		}

		return new SNG_REST_Response(detail, new SNG_REST_CollectionOutput(result));
    }

    private List<ServicePlanInfoMspOutput> constructMspOutput(List<ModemServicePlan__c> relatedMsps)
    {
		List<ServicePlanInfoMspOutput> spInfoMspOutputList;
		if (relatedMsps != null)
		{
			spInfoMspOutputList = new List<ServicePlanInfoMspOutput>();
    		for (ModemServicePlan__c msp : relatedMsps) {
    			ServicePlanInfoMspOutput spInfoMspOutput = new ServicePlanInfoMspOutput(
    					msp.Modem__r.Name, msp.Modem__r.SerialNumber__c, msp.Status__c,
    					msp.StartDate__c, msp.EndDate__c, msp.Modem__r.Terminal__r.Name);
    			spInfoMspOutputList.add(spInfoMspOutput);
    		}
		}

		return spInfoMspOutputList;
    }

    /**
     * This class is used in the response to the service-plans/info RESTful API request.
     * Must implement SNG_REST_IJsonResponseData as it is used as the Data object for
     * the corresponding instance call. Given that, it probably warrants it's own class
     * under best practices, but is included here given the motivation to minimize files
     * in the organization.
     */
	@TestVisible
    private class ServicePlanInfoOutput implements SNG_REST_IJsonResponseData {
    	/**
    	 * The service plan ID.
    	 */
    	public String servicePlanId {
    		get;
    		set {
    			SfIdChecker servicePlanIdChecker = new SfIdChecker(servicePlanPrefixRegex);
    			if (servicePlanIdChecker.isValidFormat(value)) {
    				servicePlanId = value;
    			} else {
    				throw new SNG_REST_JsonResponseOutput.ValidationException('Invalid servicePlanId: ' + value);
    			}
    		}
    	}

    	/**
    	 * Current status of the service plan; either 'Active or Inactive'
    	 */
    	public String status {
    		get;
    		set {
    			if (validateServicePlanStatus(value)) {
    				status = value;
    			} else {
    				throw new SNG_REST_JsonResponseOutput.ValidationException('Invalid status value: ' + value);
    			}
    		}
    	}

    	/**
    	 * Start Date of the Service Plan
    	 *
    	 * Format:
    	 * YYYY-MM-DD
    	 */
    	public String startDate { get; set; }

       	/**
    	 * End Date of the Service Plan
    	 *
    	 * Format:
    	 * YYYY-MM-DD
    	 */
    	public String endDate { get; set; }

       	/**
    	 * Sales Order corresponding to the Service Plan
    	 */
    	public String salesOrder { get; set; }

       	/**
    	 * Type of Service Plan
    	 *
    	 * Format varies on the type
    	 */
    	public String servicePlanType { get; set; }

       	/**
    	 * Modem / Service Plan (MSP) related data
    	 */
    	public List<ServicePlanInfoMspOutput> modems { get; set; }


    	/**
    	 * Constructs a ServicePlanInfoOutput
    	 *
    	 * @param servicePlanId 	service plan name (e.g. SP-0123)
    	 * @param status			status of service plan (e.g. 'Active' or 'Inactive')
    	 * @param startDate			service plan start date
    	 * @param endDate			service plan end date
    	 * @param salesOrder		service plan sales order
    	 * @param servicePlanType	service plan type number
    	 * @param modems			list of data corresponding to modem on service plan
    	 */
    	public ServicePlanInfoOutput(String servicePlanId, String status, Date startDate,
    			Date endDate, String salesOrder, String servicePlanType,
    			List<ServicePlanInfoMspOutput> modems) {
			this.servicePlanId = servicePlanId;
			this.status = status;
			this.startDate = ISODateAndTimeConverter.formatDate(startDate);
			this.endDate = ISODateAndTimeConverter.formatDate(endDate);
			this.salesOrder = salesOrder;
			this.servicePlanType = servicePlanType;
			this.modems = modems;
		}

        /**
         * The hashcode for this object.
         *
         * @return                   A singular hashcode representing this object.
         */
		public integer hashCode() {
			final integer prime = 31;
			integer result = 1;
			result = prime * result
					+ ((endDate == null) ? 0 : endDate.hashCode());
			result = prime * result
					+ ((salesOrder == null) ? 0 : salesOrder.hashCode());
			result = prime
					* result
					+ ((servicePlanId == null) ? 0 : servicePlanId
							.hashCode());
			result = prime * result
					+ ((startDate == null) ? 0 : startDate.hashCode());
			result = prime * result
					+ ((status == null) ? 0 : status.hashCode());
			result = prime * result
					+ ((servicePlanType == null) ? 0 : servicePlanType.hashCode());
			result = prime * result
					+ ((modems == null) ? 0 : modems.hashCode());
			return result;
		}

    	/**
    	 * Equality comparison used when the object is used as a key in a map.
    	 * Verifies the status and sub-code is equal.
    	 *
    	 * @param    obj             The object to compare for equality.
    	 * @return                   Whether or not the objects are considered equal.
    	 */
		public boolean equals(Object obj) {
			// Compare references
			if (this === obj) {
				return true;
			}

			if (obj == null || !(obj instanceof ServicePlanInfoOutput)) {
				return false;
			}

			ServicePlanInfoOutput other = (ServicePlanInfoOutput) obj;
			return (StringUtils.equals(servicePlanId, other.servicePlanId) &&
					StringUtils.equals(status, other.status) &&
					StringUtils.equals(startDate, other.startDate) &&
					StringUtils.equals(endDate, other.endDate) &&
					StringUtils.equals(salesOrder, other.salesOrder) &&
					StringUtils.equals(servicePlanType, other.servicePlanType) &&
					(modems == null ? other.modems == null : modems.equals(other.modems)));
		}
    }


    /**
     * This class is used for the modem related data in the response to the service-plans/info
     * RESTful API request.
     */
	@TestVisible
    private class ServicePlanInfoMspOutput {
    	/**
    	 * The modem MAC address
    	 */
    	public String macAddress {
    		get;
    		set;
    	}

    	/**
    	 * The modem serial number
    	 */
    	public String serialNumber {
    		get;
    		set;
    	}

    	/**
    	 * The status of the modem on given service plan
    	 */
    	public String status {
    		get;
    		set;
    	}

    	/**
    	 * Date that modem was activated (or will activate) on given service plan
    	 */
    	public String startDate {
    		get;
    		set;
    	}

    	/**
    	 * Date that modem was deactivated (or will deactivate) on given service plan
    	 */
    	public String endDate {
    		get;
    		set;
    	}

    	/**
    	 * The Terminal ID associated with the modem
    	 */
    	public String terminalId {
    		get;
    		set;
    	}

    	/**
    	 * Constructs a ServicePlanInfoMspOutput
    	 *
    	 * @param macAddress	 	MAC address of the modem associated to given service plan
    	 * @param serialNumber		serial number of the modem
    	 * @param status			status of modem on service plan (e.g. 'Active' or 'Inactive')
    	 * @param startDate			date at which modem was (or will be) associated with service plan
    	 * @param endDate			date at which modem was (or will be) deassociated with service plan
    	 * @param terminalId		ID of terminal associated with the modem (e.g. T0123)
    	 */
    	@TestVisible
    	public ServicePlanInfoMspOutput(String macAddress, String serialNumber, String status,
    			Date startDate, Date endDate, String terminalId) {
			this.macAddress = macAddress;
			this.serialNumber = serialNumber;
			this.status = status;
			this.startDate = ISODateAndTimeConverter.formatDate(startDate);
			this.endDate = ISODateAndTimeConverter.formatDate(endDate);
			this.terminalId = terminalId;
		}

        /**
         * The hashcode for this object.
         *
         * @return                   A singular hashcode representing this object.
         */
		public integer hashCode() {
			final integer prime = 31;
			integer result = 1;
			result = prime * result
					+ ((endDate == null) ? 0 : endDate.hashCode());
			result = prime * result
					+ ((macAddress == null) ? 0 : macAddress.hashCode());
			result = prime * result
					+ ((serialNumber == null) ? 0 : serialNumber.hashCode());
			result = prime * result
					+ ((startDate == null) ? 0 : startDate.hashCode());
			result = prime * result
					+ ((status == null) ? 0 : status.hashCode());
			result = prime * result
					+ ((terminalId == null) ? 0 : terminalId.hashCode());
			return result;
		}

    	/**
    	 * Equality comparison used when the object is used as a key in a map.
    	 * Verifies the status and sub-code is equal.
    	 *
    	 * @param    obj             The object to compare for equality.
    	 * @return                   Whether or not the objects are considered equal.
    	 */
		public boolean equals(Object obj) {
			// Compare references
			if (this === obj) {
				return true;
			}

			if (obj == null || !(obj instanceof ServicePlanInfoMspOutput)) {
				return false;
			}

			ServicePlanInfoMspOutput other = (ServicePlanInfoMspOutput) obj;
			return (StringUtils.equals(macAddress, other.macAddress) &&
					StringUtils.equals(serialNumber, other.serialNumber) &&
					StringUtils.equals(status, other.status) &&
					StringUtils.equals(startDate, other.startDate) &&
					StringUtils.equals(endDate, other.endDate) &&
					StringUtils.equals(terminalId, other.terminalId));
		}
	}
}